unit uSQLMacro;

interface

uses
  SysUtils, Classes;

type
  TSQLMacroExprInfo = record
    Expression: string;
    FinalString: string;
    Success: boolean;
  end;

  TExprEvalProc = procedure(var AExprInfo: TSQLMacroExprInfo) of object;

function ParseSQLMacro(AInCode: string; ExprProc: TExprEvalProc;
  IgnoreOptionals: boolean): string;

implementation

const
  PS_READ      = 2;
  PS_READDIR   = 4;
  PS_READEVAL  = 6;
  PS_END       = 7;

procedure ParseSQLScriptEx(AInStream: TStream; var AOutput, ADirCode: string;
  ExprProc: TExprEvalProc; IgnoreOptionals: boolean);
var
  EndOfStream: Boolean;
  iPState, iPrevState: integer;
  Buf: array[0..20] of Char; // The buffer size = 10 -> PeekString has a max. of 10 !!
  CPrev, CCur, CNext, CLast: ^Char;
  SCurData, SCurEval, SCurDir: string;
  AOutCode: string;
  DirLevel: integer;

  function ScrQuote: string;
  begin
    Result := '''';
  end;

  function ScrConCat: string;
  begin
    Result := ' + ';
  end;

  function ScrLnStart: string;
  begin
    Result := '';
  end;

  function ScrLnEnd: string;
  begin
    Result := '';
  end;

  function ScrEvalStart: string;
  begin
    Result := '';
  end;

  function ScrEvalEnd: string;
  begin
    Result := '';
  end;

  procedure SetParserState(ANewState: integer);
  begin
    if ANewState <> iPState then
    begin
      iPrevState := iPState;
      iPState := ANewState;
    end;
  end;

  function GetNextChar: Char;
  var
    i: integer;
  begin
    // Shift the buffer
    for i := Low(Buf) + 1 to High(Buf) do Buf[i-1] := Buf[i];

    if AInStream.Position < AInStream.Size then
      AInStream.Read(CLast^, SizeOf(Char))
    else begin
      EndOfStream := True;
      CLast^ := #0;
    end;
    Result := CCur^;
  end;

  function PeekString(ACount: integer): string;
  begin
    SetString(Result, PChar(CNext), ACount * SizeOf(Char));
  end;

  function CompareBuf(ACompare: string; SkipIfTrue: Boolean): Boolean;
  var
    S: string;
    i: integer;
  begin
    // The first char will be deleted since this is checked in the main-loop.
    // The reason for this is to make the keywords in the loop a little more
    // readable.
    Delete(ACompare, 1, 1);
    SetString(S, PChar(CNext), Length(ACompare));
    Result := SameText(S, ACompare);
    if Result and SkipIfTrue then
      for i := 1 to Length(S) do GetNextChar;
  end;

  procedure AddLineToOutput;
  var
    AExpr: TSQLMacroExprInfo;
  begin
    case iPState of
      PS_READ, PS_END, PS_READDIR:
        begin
          if SCurData <> '' then
          begin
            AOutCode := AOutCode + SCurData;
            {if AOutCode <> '' then
              AOutCode := AOutCode + ScrConcat;
            AOutCode := AOutCode + ScrQuote + SCurData + ScrQuote;}

            ADirCode := ADirCode + SCurData;
            {  ADirCode := ADirCode + ScrConcat;
            ADirCode := ADirCode + ScrQuote + SCurData + ScrQuote;}
          end;
        end;
      PS_READEVAL:
        begin
          if SCurEval <> '' then
          begin
            AExpr.Success := true;
            AExpr.Expression := SCurEval;
            if Assigned(ExprProc) then
            begin
              ExprProc(AExpr);
              SCurEval := AExpr.FinalString
            end else
              SCurEval := '';

            if SCurEval <> '' then
              AOutCode := AOutCode + SCurEval;
            {if AOutCode <> '' then
              AOutCode := AOutCode + ScrConcat;
            AOutCode := AOutCode + SCurEval;}
          end;
        end;
    end;
    SCurData := '';
    SCurEval := '';
  end;

  procedure ProcessChar;
  var
    S: string;
  begin
    S := CCur^;
    {if (S = #13) then
      if CNext^ = #10 then
      begin
        S := scrQuote + scrConcat + '#13#10' + scrConcat + scrQuote;
        GetNextChar;
      end
      else
      S := scrQuote + scrConcat + '#13' + scrConcat + scrQuote;}
    case iPState of
      PS_READ:
        SCurData := sCurData + S;
      PS_READDIR:
        SCurDir := SCurDir + S;
      PS_READEVAL:
        SCurEval := SCurEval + S;
    end;
  end;

  procedure HandleDirectiveCode;
  var
    SStrm: TStream;
    SaveDir: string;
    DC: string;
    SaveOut: string;
    OC: string;
  begin
    //if Assigned(ADirProc) then
    begin
      SStrm := TMemoryStream.Create;
      SStrm.WriteBuffer(PChar(SCurDir)^, Length(SCurDir) * SizeOf(Char));
      SStrm.Position := 0;
      try
        {Evaluate directive with expressions}
        SaveDir := ADirCode;
        DC := '';
        SaveOut := AOutCode;
        OC := '';
        ParseSQLScriptEx(SStrm, OC, DC, ExprProc, IgnoreOptionals);
        AOutCode := SaveOut;
        ADirCode := SaveDir;

        {handle directive and add it to source code. If text is equal,
         it means expressions are null, so do not add directive to source code}
        if CompareStr(OC, DC) = 0 then
          SCurEval := ''
        else
          SCurEval := OC;
        AOutCode := AOutCode + SCurEval;
        {ipState := PS_READEVAL;
        AddLineToOutput;
        ipState := PS_READ;}
      finally
        SStrm.Free;
      end;
    end;
    SCurDir := '';
  end;

begin
  DirLevel := 0;
  AOutCode := '';

  if AInStream.Size = 0 then Exit;

  iPState := PS_READ;
  iPrevState := -1;

  SCurData := '';
  SCurEval := '';
  SCurDir  := '';

  // init the buffer and pointers pointer reference
  FillChar(Buf, SizeOf(Buf), 0);
  CPrev := @Buf[0];
  CCur  := @Buf[1];
  CNext := @Buf[2];
  CLast := @Buf[High(Buf)];
  EndOfStream := (AInStream.Read(Buf[2], SizeOf(Char) * (High(Buf) - 1)) <> (High(Buf) - 1) * SizeOf(Char));

  while (iPState <> PS_END) do
  begin
    case GetNextChar of
      '<':
        begin
          if (CNext^ = '%') and (iPState <= PS_READ) then
          begin
            AddLineToOutput;
            GetNextChar; // Skip the '%'
            SetParserState(PS_READEVAL);
          end
          else begin
            ProcessChar;
          end;
        end;
      '%':
        if (CNext^ = '>') and (iPState = PS_READEVAL) then
        begin
          AddLineToOutput;
          GetNextChar;
          SetParserState(PS_READ);
        end
        else //if not ((CPrev^ = '<') and (iPState = PS_READEVAL) and (iPrevState = PS_READ)) then
          ProcessChar;
      '{':
        begin
          if IgnoreOptionals then
            ProcessChar
          else
          begin
            if (iPState = PS_READ) and (CPrev^ <> '\') then
            begin
              //GetNextChar; // Skip the '$'
              Inc(DirLevel);
              AddLineToOutput; //Flush pending data
              SetParserState(PS_READDIR);
            end
            else
            if (iPState = PS_READDIR) and (CPrev^ <> '\') then
            begin
              Inc(DirLevel);
              ProcessChar;
            end
            else
              ProcessChar;
          end;
        end;
      '}':
        begin
          if (iPState = PS_READDIR) then
          begin
            Dec(DirLevel);
            if DirLevel = 0 then
            begin
              HandleDirectiveCode;
              SetParserState(iPrevState); //  PS_READ)
            end else
              ProcessChar;
          end
          else
            ProcessChar;
        end;
      #10:;
      #13:
        begin
          ProcessChar;
        end;
      #0:
        if (CNext^ = #0) then SetParserState(PS_END);
    else
      ProcessChar;
    end;
    if (iPState = PS_END) and EndOfStream then Break;
  end;
  AddLineToOutput;

  if AOutput <> '' then
    AOutput := AOutput + scrConcat;
  AOutput := AOutput + AOutCode;
end;

function ParseSQLMacro(AInCode: string; ExprProc: TExprEvalProc;
  IgnoreOptionals: boolean): string;
var
  InStream: TStream;
  Dummy: string;
begin
  result := '';
  InStream := TMemoryStream.Create;
  try
    InStream.Write(PChar(AInCode)^, Length(AInCode) * SizeOf(Char));
    InStream.Position := 0;
    ParseSQLScriptEx(InStream, result, Dummy, ExprProc, IgnoreOptionals);
  finally
    InStream.Free;
  end;
end;

end.

