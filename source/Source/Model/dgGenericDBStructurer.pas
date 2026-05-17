unit dgGenericDBStructurer;

interface

uses
   SysUtils, Classes, DB, dgDBStructurer, dgMacroDBStructurer, dgConsts, dgDBTypes;

type
   TGenericDBStructurer = class(TMacroDBStructurer)
   public
     constructor Create(ADBType: TDatabaseType);
   end;

implementation

{ TGenericDBStructurer }

constructor TGenericDBStructurer.Create(ADBType: TDatabaseType);
begin
  inherited Create;
  DBType := ADBType;
  if Assigned(DBType) then
  begin
    if Assigned(DBType.OnLoadScriptExpressions) then
      DBType.OnLoadScriptExpressions(ScriptExpressions);
  end;
end;

end.

