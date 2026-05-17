unit uScripting;

interface

uses
  uGDAO,
  atScript, atScripter, IDEMain, IDEDialog;

procedure LaunchScriptingIDE(Dictionary: TGDAODatabase);

implementation

procedure LaunchScriptingIDE(Dictionary: TGDAODatabase);
var
  Scripter: TIDEScripter;
  Engine: TIDEEngine;
  Dialog: TIDEDialog;
begin
  Scripter := TIDEScripter.Create(nil);
  Engine := TIDEEngine.Create(nil);
  Dialog := TIDEDialog.Create(nil);
  try
    Dialog.Engine := Engine;
    Engine.Scripter := Scripter;
    Scripter.DefineClassByRTTI(TGDAORelationship, TRedefineOption.roNone, True);
    Scripter.DefineClassByRTTI(TGDAORelationshipFieldLinks, TRedefineOption.roNone, True);
    Scripter.DefineClassByRTTI(TGDAORelationshipFieldLink, TRedefineOption.roNone, True);

    Scripter.DefineClassByRTTI(TGDAOTable, TRedefineOption.roNone, True);
    Scripter.DefineClassByRTTI(TGDAOFields, TRedefineOption.roNone, True);
    Scripter.DefineClassByRTTI(TGDAOField, TRedefineOption.roNone, True);
    Scripter.DefineClassByRTTI(TGDAOIndexes, TRedefineOption.roNone, True);
    Scripter.DefineClassByRTTI(TGDAOIndex, TRedefineOption.roNone, True);
    Scripter.DefineClassByRTTI(TGDAOConstraints, TRedefineOption.roNone, True);
    Scripter.DefineClassByRTTI(TGDAOConstraint, TRedefineOption.roNone, True);
    Scripter.DefineClassByRTTI(TGDAOIFields, TRedefineOption.roNone, True);
    Scripter.DefineClassByRTTI(TGDAOIField, TRedefineOption.roNone, True);
    Scripter.DefineClassByRTTI(TGDAOTriggers, TRedefineOption.roNone, True);
    Scripter.DefineClassByRTTI(TGDAOTrigger, TRedefineOption.roNone, True);

    Scripter.DefineClassByRTTI(TGDAODatabase, TRedefineOption.roNone, True);
    Scripter.AddObject('Dic', Dictionary);
    Engine.NewProject;
    Engine.NewUnit(TScriptLanguage.slPascal, true);
    Dialog.Execute;
  finally
    Dialog.Free;
    Engine.Free;
    Scripter.Free;
  end;
end;

end.
