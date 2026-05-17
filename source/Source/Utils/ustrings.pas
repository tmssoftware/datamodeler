unit uStrings;

interface

uses
   SysUtils, Classes, Dialogs, Forms, ComCtrls, Controls, StdCtrls, Windows;

function Replicate(ch:char;n:integer):string;
function Zeros(n,d:integer):string;
function StringToDate( s:string ):TDateTime;
function StringToCurrency( s:string ):currency;
function StringToInt( s:string ):integer;
function DateToString( d:TDateTime ):string;
function CurrencyToString( c:currency ):string;
function IntToString( i:integer ):string;
function MemoToString( s:string ):string;
function ParseString(s,separator:string;list:TStrings):TStrings;
function RemoveChar(ch:char;s:string):string;
function ExtractFirstIdentifier(s:string):string;
function ExtractFieldName(s:string):string;
function ExtractTableAlias(s:string):string;
procedure FillString(var s:string;subs:string;i,f:integer);
function RemoveSpaces(S:string):string;
function RemoveTailSpaces(S:string):string;
function ReplaceStr(s,s1,s2:string):string;
function ReplaceStrAtBegin(s,s1,s2:string):string;
function EmptyDate(const s:string):boolean;
procedure ConcatenaExpressao_(var exp:string;s:string);
function ConcatenaExpressao(const exp,s:string):string;
function ConcatenaLista(lista:string;s:string):string;
procedure ConcatenaString(var s:string;sep,s1:string);
function DayOfWeekStr( data:TDateTime ):string;
function KeyStr( AValue:integer ): string;
function BackPos(ch:char;s:string;i:integer):integer;
function PartialPos(ch:char;s:string;i:integer):integer;
function FormatPath(s:string):string;
function FormatAddress(s: string): string;
//function MakeIdentifier(s:string):string;
function SplitList(s:string;const sep:string):TStringList;
procedure SplitInTwo(s:string;const sep:string;var a,b:string);
function FloatToString(v:extended):string;
function StringToFloat(s: string): extended;
function BoolToStr(v:boolean):string;
function ComponentAsString(AComponent:TComponent):string;
function StringAsComponent(AString: string; Instance: TComponent): TComponent;
function ComponentAsStrings(AComponent:TComponent):TStrings;
procedure ShowComponentAsText( AInstance:TComponent );
procedure ShowText(ACaption,s:string);
procedure ShowTextFile(ACaption,fname:string);
function ValorPorExtenso( numero:currency ):string;
function Right(s:string;n:integer):string;
function FirstWord(s: string): string;
procedure WriteComponentResFileText(AFileName:string;AInstance:TComponent);
function ReadComponentResFileText(const FileName: string; Instance: TComponent): TComponent;
function EnumeratedLines(s: string; msg: string=''): string;
function CompressSpaces(s: string): string;
function DoubleApostrophes(s: string): string;
function IsContained(s: string; list: array of string): boolean;
//function ConvertControlChars(s: string): string;
//function PoundToChr(s: string): string;
function StripControlChars(s: string): string;
function CompareStrings(s1,s2: string; IgnoreSpaces: boolean=false): boolean;
function StrToFloatDef(s: string; def: extended): extended;
//function ReplaceInvalidFileChars(s: string; replaceby: char = '-'): string;
function XorEncode(const Key, Source: string): string;
function XorDecode(const Key, Source: string): string;
function DoTheStr(S: string): string;
function UndoTheStr(S: string): string;
function IsValidIdentifier(S: string; MaxSize: integer=0): boolean;
function DoBackslash(AStr: string; AddBackslash: boolean): string;
procedure LoadComponentFromFile(AFileName: string; AComp: TComponent);
procedure SaveComponentToFile(AFileName: string; AComp: TComponent);
procedure StringToComponent(AComp: TComponent; AStr: string);
function ComponentToString(AComp: TComponent): string;
function IsPathRelative(APath: string): boolean;
function AddPathDelim(APath: string): string;

var
   FirstDate : TDateTime;
   LastDate  : TDateTime;

implementation

uses
  IOUtils;

function EmptyDate(const s:string):boolean;
begin
   result:=(s='  /  /  ') or (s='  /  /    ');
end;

function Replicate(ch:char;n:integer):string;
begin
   result:='';
   for n:=n downto 1 do result:=result+ch;
end;

function Zeros(n,d:integer):string;
var c : integer;
begin
   result:=IntToStr(n);
   for c:=1 to d-length(result) do result:='0'+result;
end;

function StringToDate( s:string ):TDateTime;
begin
   if (s='') or (RemoveSpaces(s)='//') then
      result:=0
   else
      try
         result:=StrToDate(s);
      except
         result:=0;
      end;
end;

function StringToCurrency( s:string ):currency;
begin
   if s='' then result:=0 else result:=StrToFloat(s);
end;

function StringToInt( s:string ):integer;
begin
   if s='' then result:=0 else result:=StrToInt(s);
end;

function DateToString( d:TDateTime ):string;
begin
   if d=EncodeDate(1,1,1) then result:='' else result:=DateToStr(d);
end;

function CurrencyToString( c:currency ):string;
var d:char;
begin
// if c=0 then result:='' else result:=FormatFloat('0.00',c); {modificado em 28/08/00}
   d:=FormatSettings.DecimalSeparator;
   try
      FormatSettings.DecimalSeparator:='.';
      result:=FormatFloat('0.00',c);
   finally
      FormatSettings.DecimalSeparator:=d;
   end;
end;

function IntToString( i:integer ):string;
begin
   if i=0 then result:='' else result:=IntToStr(i);
end;

function MemoToString( s:string ):string;
var c: integer;
begin
   for c:=1 to length(s) do if s[c]<#32 then s[c]:=#32;
   result:=s;
end;

function ParseString(s,separator:string;list:TStrings):TStrings;
var c,i: integer;
begin
   { Se não passou a lista de strings, então constrói uma agora para o usuário destrui-la }
   if not Assigned(list) then list:=TStringList.Create;
   list.Clear;
   i:=1;
   c:=1;
   while c<=length(s)+1 do
   begin
      if (c=length(s)+1) or (AnsiUpperCase(copy(s,c,length(separator)))=AnsiUpperCase(separator)) then
      begin
         list.Add( copy(s,i,c-i) );
         inc(c,length(separator));
         i:=c;
      end
      else
         inc(c);
   end;
   result:=list;
end;

function RemoveChar(ch:char;s:string):string;
var c: integer;
begin
   result:='';
   for c:=1 to length(s) do
      if s[c]<>ch then result:=result+s[c];
end;

function ExtractFirstIdentifier(s:string):string;
var p : integer;
begin
   p:=Pos(' ',s);
   if p=0 then result:=s else result:=RemoveChar('(',copy(s,1,p-1));
end;

function ExtractFieldName(s:string):string;
var p : integer;
begin
   p:=Pos('.',s);
   if p=0 then result:=s else result:=copy(s,p+1,maxint);
end;

procedure FillString(var s:string;subs:string;i,f:integer);
var c : integer;
begin
   { faz o campo ficar com o tamanho f-i+1 }
   for c:=1 to (f-i+1)-length(subs) do subs:=subs+' ';
   subs:=copy(subs,1,f-i+1);
   { prepara a string de destino para receber a atualização }
   for c:=1 to i-length(s) do s:=s+' ';
   { retira o conteúdo anterior do campo da string }
   delete(s,i,f-i+1);
   { insere o novo conteúdo do campo }
   insert(subs,s,i);
end;

function RemoveSpaces(S:string):string;
var c: integer;
begin
   result:='';
   for c:=1 to length(S) do if S[c]<>#32 then result:=result+S[c];
end;

function RemoveTailSpaces(S:string):string;
var c: integer;
begin
   result:='';
   for c:=length(S) downto 1 do
      if S[c]<>#32 then
      begin
         result:=copy(S,1,c);
         break;
      end;
end;

procedure ConcatenaExpressao_(var exp:string;s:string);
begin
   if exp>'' then exp:=exp+' AND ';
   exp:=exp+s;
end;

function ConcatenaExpressao(const exp,s:string):string;
begin
   if s>'' then
   begin
      if exp>'' then
         result:=exp+' AND '+s
      else
         result:=exp+s;
   end
   else
      result:=exp;
end;

function ConcatenaLista(lista:string;s:string):string;
begin
   if lista>'' then lista:=lista+', ';
   result:=lista+s;
end;

procedure ConcatenaString(var s:string;sep,s1:string);
begin
   if s>'' then s:=s+sep;
   s:=s+s1;
end;

function ReplaceStr(s,s1,s2:string):string;
var p:integer;
begin
   result:=s;
   if s1<>s2 then
      if (s1='') then
         insert(s2,result,1) // assume que sempre existe uma string nula no início de s
      else
         repeat
            p:=pos(s1,result);
            if (p>0) then
            begin
               delete(result,p,length(s1));
               insert(s2,result,p);
            end;
         until p=0;
end;

function ReplaceStrAtBegin(s,s1,s2:string):string;
var p:integer;
begin
   result:=s;
   if s1<>s2 then
      if (s1='') then
         insert(s2,result,1) // assume que sempre existe uma string nula no início de s
      else
      begin
         p:=pos(s1,result);
         if (p>0) then
          begin
             delete(result,p,length(s1));
             insert(s2,result,p);
          end;
      end;
end;

function ExtractTableAlias(s:string):string;
var c,i:integer;
begin
   { encontra o alias da tabela, sem existir }
   { como entrada deve ser passado uma expressão SQL-FROM }
   i:=pos(' ',s);
   if i>0 then
      for c:=i to length(s) do
         if (c=length(s)) or (s[c+1]=' ') then
         begin
            result:=copy(s,i+1,c-i);
            break;
         end
   else
      result:='';
end;

function DayOfWeekStr( data:TDateTime ):string;
const dsem : array[1..7] of string = ('dom','seg','ter','qua','qui','sex','sáb');
begin
   result:=dsem[DayOfWeek(data)];
end;

function KeyStr( AValue:integer ): string;
begin
   if AValue=0 then
      Result:='NULL'
   else
      Result:=IntToStr(AValue);
end;

function BackPos(ch:char;s:string;i:integer):integer;
begin
   result:=i;
   while (result>0) and (s[result]<>ch) do dec(result);
end;

function PartialPos(ch:char;s:string;i:integer):integer;
begin
   result:=i;
   while (result<=length(s)) and (s[result]<>ch) do inc(result);
   if result>length(s) then result:=0;
end;

function FormatPath(s:string):string;
begin
   if s[length(s)]<>'\' then result:=s+'\' else result:=s;
end;

function FormatAddress(s: string): string;
begin
   if (s>'') and (s[length(s)]<>'/') then result:=s+'/' else result:=s;
end;

//function MakeIdentifier(s:string):string;
//var maiusc : boolean;
//    ch     : char;
//    c      : integer;
//begin
//   result:='';
//   maiusc:=true;
//   s:=AnsiLowerCase(s);
//   for c:=1 to length(s) do
//   begin
//      if s[c] in ['ç'] then ch:='c' else
//      if s[c] in ['á','ã','à','â'] then ch:='a' else
//      if s[c] in ['é','ê'] then ch:='e' else
//      if s[c] in ['í'] then ch:='i' else
//      if s[c] in ['ó','õ','ô'] then ch:='o' else
//      if s[c] in ['ú'] then ch:='u' else ch:=s[c];
//      if ch=' ' then maiusc:=true;
//      if ch in ['_','a'..'z'] then
//         if maiusc then
//         begin
//            result:=result+AnsiUpperCase(ch);
//            maiusc:=false;
//         end
//         else
//            result:=result+ch;
//   end;
//end;

function SplitList(s:string;const sep:string):TStringList;
var c,i:integer;
begin
   result:=TStringList.Create; // deve sere destruída externamente
   c:=1;
   i:=1;
   while c<=length(s) do
   begin
      if CompareText( copy(s,c,length(sep)), sep )=0 then
      begin
         result.Add( Trim(copy(s,i,c-i)) );
         inc(c,length(sep));
         i:=c;
      end
      else
         inc(c);
   end;
   if (c>i) then result.Add( Trim(copy(s,i,c-i)) );
end;

procedure SplitInTwo(s:string;const sep:string;var a,b:string);
var p:integer;
begin
   { Separa a string "s" em duas partes, sinalizado por "sep" }
   { se não for encontrado o sep, então retorna em "a" a string original }
   p:=pos(AnsiUpperCase(sep),AnsiUpperCase(s));
   if p=0 then p:=MaxInt;
   a:=copy(s,1,p-1);
   b:=copy(s,p+length(sep),MaxInt);
end;

function FloatToString(v:extended):string;
var d:char;
begin
   d:=FormatSettings.DecimalSeparator;
   try
      FormatSettings.DecimalSeparator:='.';
      result:=FloatToStr(v);
   finally
      FormatSettings.DecimalSeparator:=d;
   end;
end;

function StringToFloat(s: string): extended;
var d: char;
begin
   d:=FormatSettings.DecimalSeparator;
   try
      FormatSettings.DecimalSeparator:='.';
      result:=StrToFloat(s);
   finally
      FormatSettings.DecimalSeparator:=d;
   end;
end;

function BoolToStr(v:boolean):string;
begin
   if v then result:='TRUE' else result:='FALSE';
end;

function ComponentAsString(AComponent:TComponent):string;
var BinStream: TMemoryStream;
    StrStream: TStringStream;
begin
   BinStream := TMemoryStream.Create;
   try
      StrStream := TStringStream.Create('');
      try
         BinStream.WriteComponent(AComponent);
         BinStream.Seek(0, soFromBeginning);
         ObjectBinaryToText(BinStream, StrStream);
         StrStream.Seek(0, soFromBeginning);
         Result:=StrStream.DataString;
      finally
         StrStream.Free;
      end;
   finally
     BinStream.Free
   end;
end;

function StringAsComponent(AString: string; Instance: TComponent): TComponent;
var StrStream : TStringStream;
    BinStream  : TMemoryStream;
begin
  if AString>'' then
  begin
    StrStream := TStringStream.Create(AString);
    try
       BinStream := TMemoryStream.Create;
       try
          ObjectTextToBinary(StrStream, BinStream);
          BinStream.Seek(0, soFromBeginning);
          Result := BinStream.ReadComponent(Instance);
       finally
          BinStream.Free;
       end;
    finally
       StrStream.Free;
    end;
  end
  else
    result := Instance;
end;

function ComponentAsStrings(AComponent:TComponent):TStrings;
var BinStream: TMemoryStream;
    StrStream: TStringStream;
begin
   Result:=TStringList.Create;
   try
      BinStream := TMemoryStream.Create;
      try
         StrStream := TStringStream.Create('');
         try
            BinStream.WriteComponent(AComponent);
            BinStream.Seek(0, soFromBeginning);
            ObjectBinaryToText(BinStream, StrStream);
            StrStream.Seek(0, soFromBeginning);
            Result.LoadFromStream( StrStream );
         finally
            StrStream.Free;
         end;
      finally
        BinStream.Free
      end;
   except
      Result.Free; // assegura a destruicao das strings em caso de falha
      raise;
   end;
end;

procedure ShowComponentAsText( AInstance:TComponent );
var MemStream    : TMemoryStream;
    StrStream    : TStringStream;
begin
   MemStream := TMemoryStream.Create;
   StrStream := TStringStream.Create('');
   try
      MemStream.WriteComponentRes(AInstance.ClassName,AInstance);
      MemStream.Position:=0;
      ObjectResourceToText(MemStream,StrStream);
      ShowText( AInstance.Name, StrStream.DataString );
   finally
      StrStream.Free;
      MemStream.Free;
   end;
end;

procedure ShowText(ACaption,s:string);
var form  : Tform;
begin
   { exibe o conteúdo do objeto como texto }
   form:=Tform.create(nil);
   with form do
   begin
      Caption:=ACaption;
      Width:=500;
      Height:=400;
      Position:=poScreenCenter;
      Font.name:='Courier New';
      Font.Size:=8;
      with TRichEdit.create(nil) do
      begin
         parent:=form;
         scrollbars:=ssBoth;
         plaintext:=true;
         align:=alclient;
         lines.BeginUpDate;
         lines.text:=s;
         lines.EndUpdate;
         wordwrap:=false;
      end;
      ShowModal;
      Release;
   end;
end;
                              
procedure ShowTextFile(ACaption,fname:string);
var s:TStringList;begin   s:=TStringList.Create;   try      s.LoadFromFile(fname);      ShowText(ACaption,s.Text);   finally      s.Free;   end;end;
function ValorPorExtenso( numero:currency ):string;
var S      : TStringList;
    base   : integer;
    c, n   : integer;

    function Converte(milesimos,numsufixo:integer):string;
    const unidade : array[1..19] of string = (
          'um','dois','três','quatro','cinco','seis','sete','oito','nove','dez',
          'onze','doze','treze','quatorze','quinze','desesseis','desessete',
          'desoito','desenove' );
          dezena : array[2..9] of string = (
          'vinte','trinta','quarenta','cinquenta','sessenta','setenta','oitenta',
          'noventa' );
          centena : array[1..9] of string = (
          'cento','duzentos','trezentos','quatrocentos','quinhentos','seicentos',
          'setecentos','oitocentos','novecentos' );
          sufixo_plural : array[-1..3] of string = (
          ' centavos','',' mil',' milhões',' bilhões' );
          sufixo_singular : array[-1..3] of string = (
          'um centavo','um','um mil','um milhão','um bilhão' );
    var centenas, dezenas, unidades, centesimos : integer;
    begin
       if milesimos>0 then
       begin
          result:='';
          if milesimos=1 then result:=sufixo_singular[numsufixo] else
          begin
             if milesimos=100 then result:='cem' else
             begin
                centenas:=milesimos div 100;
                centesimos:=milesimos mod 100;
                dezenas:=centesimos div 10;
                unidades:=milesimos mod 10;
                { centenas }
                if centenas>0 then result:=centena[centenas];
                { valores especiais de 1 a 19 }
                if centesimos>0 then
                   if centesimos<20 then
                   begin
                      if result>'' then result:=result+' e ';
                      result:=result+unidade[centesimos]
                   end
                   else
                   begin
                      { dezenas }
                      if dezenas>0 then
                      begin
                         if result>'' then result:=result+' e ';
                         result:=result+dezena[dezenas];
                      end;
                      { unidades }
                      if unidades>0 then
                      begin
                         if result>'' then result:=result+' e ';
                         result:=result+unidade[unidades];
                      end;
                   end;
             end;
             { sufixo }
             result:=result+sufixo_plural[numsufixo];
          end;
          S.Add(result);
       end;
    end;

begin
   S:=TStringList.Create;
   with S do
   try
      base:=1000000000; { não trata quantidades acima de bilhões (inteiros não suportam trilhões) }
      n:=trunc(numero);
      { separa o número em grupo de 3 algarismos a partir do ponto decimal e
        trata cada parte separadamente: bilhões, milhões, milhares e reais }
      for c:=3 downto 0 do
      begin
         Converte( n div base mod 1000, c );
         base:=base div 1000;
      end;
      { sufixo da moeda }
      if n>0 then
         if n=1 then S.Add('Real')
         else
            if n mod 1000000>0 then
               S.Add('Reais')
            else
               S.Add('de Reais');
      if numero=0 then S.Add('zero Reais');
      { concatena os grupos de 3 algarismos com "," ou "e" }
      for c:=Count-3 downto 0 do
         if (c=Count-3) then strings[c]:=strings[c]+' e' else strings[c]:=strings[c]+',';
      { inclui os centavos }
      n:=round(frac(numero)*100);
      if n>0 then
      begin
         if Text>'' then Text:=Text+'e';
         Converte( n,-1 );
      end;
      { resultado em uma string }
      result:='';
      for c:=1 to length(Text) do
         if Text[c]=#13 then result:=result+' ' else
         if Text[c]>#31 then result:=result+Text[c];
      for c:=length(result) downto 1 do
         if result[c]>' ' then
         begin
            result:=copy(result,1,c);
            break;
         end;
   finally
     Free;
   end;
end;

function Right(s:string;n:integer):string;
begin
   result:=copy(s,length(s)-n+1,n);
end;

function FirstWord(s: string): string;
begin
   if pos(' ',s)>0 then result:=copy(s,1,pos(' ',s)-1)
   else result:=s;
end;

procedure WriteComponentResFileText(AFileName:string;AInstance:TComponent);
var BinStream : TMemoryStream;
    FileStream : TFileStream;
begin
   BinStream := TMemoryStream.Create;
   try
      FileStream := TFileStream.Create(AFileName,fmCreate);
      try
         BinStream.WriteComponent(AInstance);
         BinStream.Seek(0, soFromBeginning);
         ObjectBinaryToText(BinStream, FileStream);
      finally
         FileStream.Free;
      end;
   finally
      BinStream.Free
   end;
end;

function ReadComponentResFileText(const FileName: string; Instance: TComponent): TComponent;
var FileStream : TFileStream;
    BinStream  : TMemoryStream;
begin
   FileStream := TFileStream.Create(FileName,fmOpenRead);
   try
      BinStream := TMemoryStream.Create;
      try
         ObjectTextToBinary(FileStream, BinStream);
         BinStream.Seek(0, soFromBeginning);
         Result := BinStream.ReadComponent(Instance);
      finally
         BinStream.Free;
      end;
   finally
      FileStream.Free;
   end;
end;

function EnumeratedLines(s: string; msg: string=''): string;
var sl: TStringList;
    start,i: integer;
begin
   sl:=TStringList.Create;
   try
      sl.text:=s;
      if msg>'' then
      begin
         sl.Insert(0,'');
         sl.Insert(0,UpperCase(msg));
         start:=2;
      end
      else
         start:=0;
      for i:=start to sl.Count-1 do
         sl[i]:=Format('%s %s',[Zeros(i-start+1,length(inttostr(sl.count))),sl[i]]);
      result:=sl.text;
   finally
      sl.free;
   end;
end;

function CompressSpaces(s: string): string;
begin
   result:=s;
   while pos('  ',s)>0 do
      delete(s,pos('  ',s),1);
end;

function DoubleApostrophes(s: string): string;
begin
   result:=StringReplace(s,'''','''''',[rfReplaceAll]); 
end;

function IsContained(s: string; list: array of string): boolean;
var i: integer;
begin
   for i:=low(list) to high(list) do
      if list[i]=s then
      begin
         result:=true;
         exit;
      end;
   result:=false;
end;

//function ConvertControlChars(s: string): string;
//{ converte números dentro da string, precedidos por #, para caracteres de controle }
//var i, inum: integer;
//    ch: string;
//begin
//   result:='';
//   i:=1;
//   while i<=length(s) do
//   begin
//      ch:='';
//      if s[i]='#' then
//         for inum:=i+1 to length(s) do
//            if s[inum] in ['0'..'9'] then ch:=ch+s[inum]
//            else break;
//      if ch>'' then
//         result:=result+chr(StrToInt(ch))
//      else
//         result:=result+s[i];
//      inc(i,length(ch)+1);
//   end;
//end;

//function PoundToChr(s: string): string;
//{ troca #n por +chr(n)+ nas string }
//var i, inum: integer;
//    ch: string;
//begin
//   result:='';
//   i:=1;
//   while i<=length(s) do
//   begin
//      ch:='';
//      if s[i]='#' then
//         for inum:=i+1 to length(s) do
//            if s[inum] in ['0'..'9'] then ch:=ch+s[inum]
//            else break;
//      if ch>'' then
//         result:=Format('%s''+chr(%s)+''',[result,ch])
//      else
//         result:=result+s[i];
//      inc(i,length(ch)+1);
//   end;
//end;

function StripControlChars(s: string): string;
var i: integer;
begin
   result:='';
   for i:=1 to length(s) do
      if s[i]>#30 then
         result:=result+s[i];
end;

function CompareStrings(s1,s2: string; IgnoreSpaces: boolean): boolean;
begin
   if IgnoreSpaces then
   begin
      s1:=RemoveSpaces(s1);
      s2:=RemoveSpaces(s2);
   end;
   result:=AnsiCompareText(trim(s1),trim(s2))=0;
end;

function StrToFloatDef(s: string; def: extended): extended;
begin
   try
      result:=StrToFloat(s);
   except
      result:=def;
   end;
end;

//function ReplaceInvalidFileChars(s: string; replaceby: char): string;
//var i: integer;
//begin
//   result := s;
//   for i:=1 to length(result) do
//      if result[i] in ['\','/',':','*','?','"','<','>','|'] then
//         result[i] := replaceby;
//end;

function XorEncode(const Key, Source: string): string;
var
  I: Integer;
  C: Byte;
begin
  Result := '';
  for I := 1 to Length(Source) do begin
    if Length(Key) > 0 then
      C := Byte(Key[1 + ((I - 1) mod Length(Key))]) xor Byte(Source[I])
    else
      C := Byte(Source[I]);
    Result := Result + AnsiLowerCase(IntToHex(C, 2));
  end;
end;

function XorDecode(const Key, Source: string): string;
var
  I: Integer;
  C: Char;
begin
  Result := '';
  for I := 0 to Length(Source) div 2 - 1 do begin
    C := Chr(StrToIntDef('$' + Copy(Source, (I * 2) + 1, 2), Ord(' ')));
    if Length(Key) > 0 then
      C := Chr(Byte(Key[1 + (I mod Length(Key))]) xor Byte(C));
    Result := Result + C;
  end;
end;

const
  _DoConst = 'Project was modified. Do you want to save changes?';

function DoTheStr(S: string): string;
begin
  result := XorEncode(_DoConst, S);
end;

function UndoTheStr(S: string): string;
begin
  result := XorDecode(_DoConst, S);
end;

const
  IdentifierLetters = ['A'..'Z','a'..'z'];
  IdentifierFirstSymbols = ['_'] + IdentifierLetters;
  IdentifierSymbols = IdentifierFirstSymbols + ['0'..'9'];

function IsValidIdentifier(S: string; MaxSize: integer=0): boolean;
var len, i: integer;
begin
  len := Length(S);
  result := (len > 0) and ((MaxSize = 0) or (len <= MaxSize)) and CharInSet(S[1], IdentifierFirstSymbols);
  if result then
    for i := 2 to len do
      if not CharInSet(S[i], IdentifierSymbols) then
      begin
        result := False;
        exit;
      end;
end;

function DoBackslash(AStr: string; AddBackslash: boolean): string;
begin
  result := AStr;
  if AddBackslash then
    result := IncludeTrailingPathDelimiter(result)
  else
    result := ExcludeTrailingPathDelimiter(result);
end;

function ComponentToString(AComp: TComponent): string;
var
  CompName:  string;
  StrStream: TStringStream;
  MemStream: TMemoryStream;
begin
  StrStream := TStringStream.Create('');
  MemStream := TMemoryStream.Create;
  try
    CompName := AComp.Name;
    try
      AComp.Name := '';
      MemStream.WriteComponent(AComp);
      MemStream.Position := 0;
      ObjectBinaryToText(MemStream, StrStream);
      StrStream.Position := 0;
      result := StrStream.ReadString(MaxInt);
    finally
      AComp.Name := CompName;
    end;
  finally
    MemStream.Free;
    StrStream.Free;
  end;
end;

procedure StringToComponent(AComp: TComponent; AStr: string);
var
  CompName: string;
  MemStream: TMemoryStream;
  StrStream: TStringStream;
begin
  MemStream := TMemoryStream.Create;
  StrStream := TStringStream.Create(AStr);
  try
    CompName := AComp.Name;
    try
      AComp.Name := '';
      StrStream.Position := 0;
      ObjectTextToBinary(StrStream, MemStream);
      MemStream.Position := 0;
      MemStream.ReadComponent(AComp);
    finally
      AComp.Name := CompName;
    end;
  finally
    MemStream.Free;
    StrStream.Free;
  end;
end;

procedure SaveComponentToFile(AFileName: string; AComp: TComponent);
var
  SL: TStrings;
begin
  SL := TStringList.Create;
  try
    SL.Text := ComponentToString(AComp);
    TDirectory.CreateDirectory(TPath.GetDirectoryName(AFileName));
    SL.SaveToFile(AFileName);
  finally
    SL.Free;
  end;
end;

procedure LoadComponentFromFile(AFileName: string; AComp: TComponent);
var
  SL: TStrings;
begin
  SL := TStringList.Create;
  try
    SL.LoadFromFile(AFileName);
    StringToComponent(AComp, SL.Text);
  finally
    SL.Free;
  end;
end;

function IsPathRelative(APath: string): boolean;
begin
  result := true;
  if Length(APath) > 0 then
  begin
    {if the string begins with "\", then it's not relative}
    if IsPathDelimiter(APath, 1) then
      result := false
    else {if the string begins with drive letter then it's not relative}
      if ExtractFileDrive(APath) <> '' then
        result := false;
  end;
end;

function AddPathDelim(APath: string): string;
begin
  result := IncludeTrailingPathDelimiter(APath);
end;

initialization
   FirstDate := EncodeDate(1900,01,01);
   LastDate  := EncodeDate(9999,12,31);

end.

