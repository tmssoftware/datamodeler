unit AbsoluteRetrv;

{$I ../../dm.inc}

{$IFDEF ABSOLUTEDB}

interface

uses
   uSQLModule, SysUtils, Classes, Dialogs, DB, qryretrv, dgConsts, uGDAO,
   Variants, dAbsoluteDBModule, ABSMain, ABSTypes;

type
   TFieldDefinitionRec = record
      _DataTypeName: String;
      _Size: integer;
   end;

   TAbsoluteDataRetriever = class(TDataRetriever)
   private
      function ABSTable: TABSTable;
      function GetFieldDefinition(ADatatype: TABSAdvancedFieldType;
        ASize: Integer): TFieldDefinitionRec;
   public
      procedure GetDataDictionary(ADictionary: TGDAODatabase); override;
   end;

implementation
uses
  uDBConnect, ADODB;

{TAbsoluteDataRetriever}

function TAbsoluteDataRetriever.ABSTable: TABSTable;
begin
  result := TAbsoluteDBModule(Module).Table;
end;

procedure TAbsoluteDataRetriever.GetDataDictionary(ADictionary: TGDAODatabase);
var
  TablesCondition: string;

  procedure _GetTables;
  var
    SL: TStringList;
    c: Integer;
  begin
    ADictionary.Tables.Clear;
    SL := TStringList.Create;
    try
      Session.FindDatabase(ABSTable.DatabaseName).GetTablesList(SL);
      for c := 0 to SL.Count - 1 do
        ADictionary.Tables.Add(SL[c]);
    finally
      SL.Free;
    end;
  end;

  procedure _GetFieldList;
  var
    ATable: TGDAOTable;
    newField: TGDAOField;
    c: integer;
    d: Integer;
  begin
    for c := 0 to ADictionary.Tables.Count - 1 do
    begin
      ATable := ADictionary.Tables[c];
      ABSTable.Close;
      ABSTable.TableName := ATable.TableName;
      ABSTable.FieldDefs.Update;

      {Get fields}
      for d := 0 to ABSTable.AdvFieldDefs.Count - 1 do
      begin
        {Basic field information: name and required}
        newField := ATable.Fields.Add(
          ABSTable.AdvFieldDefs[d].Name, nil, 0, 0,
          ABSTable.AdvFieldDefs[d].Required);

        {default value}
        newField.DefaultValue := VarToStr(ABSTable.AdvFieldDefs[d].DefaultValue.AsVariant);

        with GetFieldDefinition(
          ABSTable.AdvFieldDefs[d].DataType,
          ABSTable.AdvFieldDefs[d].Size) do
        begin
          newField.DataTypeName := _DataTypeName;
          newField.Size         := _Size;
        end;

        {identity information}
        if (newField.DataType <> nil) and (newField.DataType.Counter) then
        begin
          newField.SeedValue := ABSTable.AdvFieldDefs[d].AutoincInitialValue;
          newField.IncrementValue := ABSTable.AdvFieldDefs[d].AutoincIncrement;
        end;
      end;
    end;
  end;

  procedure _GetIndexes;
  var
    ATable: TGDAOTable;
    newIndex: TGDAOIndex;
    AField: TGDAOField;
    c: integer;
    d: Integer;
    e: integer;
    FieldList: TStringList;
    DescFieldList: TStringList;
  begin
    for c := 0 to ADictionary.Tables.Count - 1 do
    begin
      ATable := ADictionary.Tables[c];
      ABSTable.Close;
      ABSTable.TableName := ATable.TableName;
      ABSTable.IndexDefs.Update;

      {Get indexes}
      for d := 0 to ABSTable.IndexDefs.Count - 1 do
      begin
        if ixPrimary in ABSTable.IndexDefs[d].Options then
          newIndex := ATable.PrimaryKeyIndex
        else
        begin
          newIndex := ATable.Indexes.Add;

          if ixUnique in ABSTable.IndexDefs[d].Options then
            newIndex.IndexType := itUnique
          else
            newIndex.IndexType := itNone;
        end;
        newIndex.IndexName := ABSTable.Indexdefs[d].Name;

        FieldList := TStringList.Create;
        DescFieldList := TStringList.Create;
        try
          GetNamesList(FieldList, ABSTable.AdvIndexDefs[d].Fields);
          GetNamesList(DescFieldList, ABSTable.AdvIndexDefs[d].DescFields);

          for e := 0 to FieldList.Count - 1 do
          begin
            AField := ATable.FieldByName(FieldList[e]);
            if AField <> nil then
            begin
              with newIndex.IFields.Add(AField) do
              begin
                if DescFieldList.IndexOf(FieldList[e]) >= 0 then
                  FieldOrder := ioDesc
                else
                  FieldOrder := ioAsc;
              end;
            end;
          end;
        finally
          FieldList.Free;
          DescFieldList.Free;
        end;

      end;
    end;
  end;

begin
  {TablesCondition might have a filter for tables. Example:
   "SO.name in ('blobs', 'labels')"}
  TablesCondition := '0=0';
  SetMaxProgress(300);
  SetProgressPos(0);

  _GetTables;
  SetProgressPos(100);

  _GetFieldList;
  SetProgressPos(200);

  _GetIndexes;
  SetProgressPos(300);
end;

function TAbsoluteDataRetriever.GetFieldDefinition(
  ADatatype: TABSAdvancedFieldType;
  ASize: Integer): TFieldDefinitionRec;
const
  MapStr: array[TABSAdvancedFieldType] of string =
    (
    {aftUnknown          } '',
    {aftChar             } 'Char',
    {aftString           } 'String',
    {aftWideChar         } 'WideChar',
    {aftWideString       } 'WideString',
    {aftShortint         } 'SmallInt',
    {aftSmallint         } 'SmallInt',
    {aftInteger          } 'Integer',
    {aftLargeint         } 'LargeInt',
    {aftByte             } 'Byte',
    {aftWord             } 'Word',
    {aftCardinal         } 'Cardinal',
    {aftAutoInc          } 'AutoInc',
    {aftAutoIncShortint  } 'AutoIncShortInt',
    {aftAutoIncSmallint  } 'AutoIncSmallInt',
    {aftAutoIncInteger   } 'AutoIncInteger',
    {aftAutoIncLargeint  } 'AutoIncLargeInt',
    {aftAutoIncByte      } 'AutoIncByte',
    {aftAutoIncWord      } 'AutoIncWord',
    {aftAutoIncCardinal  } 'AudoIncCardinal',
    {aftSingle           } 'Single',
    {aftDouble           } 'Float',
    {aftExtended         } 'Extended',
    {aftBoolean          } 'Logical',
    {aftCurrency         } 'Currency',
    {aftDate             } 'Date',
    {aftTime             } 'Time',
    {aftDateTime         } 'DateTime',
    {aftTimeStamp        } 'TimeStamp',
    {aftBytes            } 'Bytes',
    {aftVarBytes         } 'VarBytes',
    {aftBlob             } 'Blob',
    {aftGraphic          } 'Graphic',
    {aftMemo             } 'Memo',
    {aftFormattedMemo    } 'FormattedMemo',
    {aftWideMemo         } 'WideMemo',
    {aftGuid             } 'Guid'
    );
begin
  result._DataTypeName := MapStr[ADataType];
  if ADataType in [aftBytes, aftChar, aftString, aftWideChar, aftWideString] then
    result._Size := ASize
  else
    result._Size := 0;
end;

{$ELSE}
interface
implementation
{$ENDIF}

end.

