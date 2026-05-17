unit uSQLModule;

interface

uses
   Variants, SysUtils, Classes;

type
  TSQLModule = class abstract
  protected
    function GetEOF: boolean; virtual; abstract;
  public
    function FieldAsString(const AFieldName: string): string; virtual; abstract;
    function FieldAsInteger(const AFieldName: string): integer; virtual; abstract;
    function FieldAsBoolean(const AFieldName: string): boolean; virtual; abstract;
    procedure Next; virtual; abstract;
    procedure Open(const SQL: string); virtual; abstract;
    procedure Execute(const SQL: string); virtual; abstract;
    property EOF: boolean read GetEOF;
  end;

  ISQLModuleFactory = interface
  ['{25122CD0-75F4-4C77-9BE2-97013E55F306}']
    function NewSQLModule: TSQLModule;
  end;

implementation

end.

