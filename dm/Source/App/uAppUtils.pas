unit uAppUtils;

interface

uses
  Windows, Forms, SysUtils, FormSize, uAppRegistry;

function CreateFormSize(AForm: TForm): TFormSize;
function GetDMAppDataFolder(AddBackslash: boolean = false): string;
function GetDMConversionsFolder(AddBackslash: boolean = false): string;
function GetDMCustomConversionsFolder(AddBackslash: boolean = false): string;
function GetDMVersion(AFormat: string = '%d.%d.%d.%d'): string;

implementation

uses
  ShellApi, SHFolder, uStrings;

const
  TMSAPPDATAFOLDER = 'TMS Software\Data Modeler';
  DEVGEMSAPPDATAFOLDER = 'Devgems\Data Modeler';

function CreateFormSize(AForm: TForm): TFormSize;
begin
  result := TFormSize.Create(AForm);
  result.Location := plRegistry;
  result.SaveUser := false;
  result.SaveMachine := false;
  result.SaveName := DMRegistry.SettingsKey;
  result.SaveKey := AForm.Name;
  result.LoadFormSettings;
end;

function GetAppDataFolder(AddBackslash: boolean = false): string;
var
  Buffer: array[0..MAX_PATH] of char;
begin
  SHGetFolderPath(0, CSIDL_APPDATA, 0, 0, Buffer);
  result := Buffer;
  result := DoBackslash(result, AddBackslash);
end;

var
  devgemsAppDataFolderChecked: boolean = False;

function CheckDevgemsAppDataFolder(AAppDataFolder: string): string;
var
  fos: TSHFileOpStruct;
begin
  // move Devgems AppData folder to TMS Software folder
  devgemsAppDataFolderChecked := True;
  result := AAppDataFolder + TMSAPPDATAFOLDER;
  if DirectoryExists(AAppDataFolder + DEVGEMSAPPDATAFOLDER) and not DirectoryExists(AAppDataFolder + TMSAPPDATAFOLDER) then
  begin
    with fos do
    begin
      wFunc := FO_MOVE;
      fFlags := FOF_FILESONLY or FOF_SILENT;
      pFrom := PChar(AAppDataFolder + DEVGEMSAPPDATAFOLDER);
      pTo := PChar(AAppDataFolder + 'TMS Software');
    end;
    if not ForceDirectories(fos.pTo) or (ShFileOperation(fos) <> 0) then
    begin
      devgemsAppDataFolderChecked := False;
      result := AAppDataFolder + DEVGEMSAPPDATAFOLDER;
    end;
  end;
end;

function GetDMAppDataFolder(AddBackslash: boolean = false): string;
var
  appDataFolder: string;
begin
  appDataFolder := GetAppDataFolder(true);
  if devgemsAppDataFolderChecked then
    result := appDataFolder + TMSAPPDATAFOLDER
  else
    result := CheckDevgemsAppDataFolder(appDataFolder);
  result := DoBackslash(result, AddBackslash);
  ForceDirectories(result);
end;

function GetDMCustomConversionsFolder(AddBackslash: boolean = false): string;
begin
  result := GetDMAppDataFolder(true) + 'Conversions';
  result := DoBackslash(result, AddBackslash);
  ForceDirectories(result);
end;

function GetDMConversionsFolder(AddBackslash: boolean = false): string;
begin
  result := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Conversions';
  result := DoBackslash(result, AddBackslash);
end;

function RetrieveFileVersionInfo(const FileName: String = '';
  const Fmt: String = '%d.%d.%d.%d'): String;
var
  sFileName: String;
  iBufferSize: DWORD;
  iDummy: DWORD;
  pBuffer: Pointer;
  pFileInfo: Pointer;
  iVer: array[1..4] of Word;
  FFI: Windows.TVSFixedFileInfo;
begin
  // set default value
  Result := '';
  iVer[1] := 0;
  iVer[2] := 0;
  iVer[3] := 0;
  iVer[4] := 0;

  // get filename of exe/dll if no filename is specified
  sFileName := FileName;
  if (sFileName = '') then
    sFileName := Application.ExeName;

  // get size of version info (0 if no version info exists)
  iBufferSize := GetFileVersionInfoSize(PChar(sFileName), iDummy);
  if (iBufferSize > 0) then
  begin
    GetMem(pBuffer, iBufferSize);
    try
      // get fixed file info (language independent)
      GetFileVersionInfo(PChar(sFileName), 0, iBufferSize, pBuffer);
      if VerQueryValue(pBuffer, '\', pFileInfo, iDummy) then
      begin
        FFI := Windows.PVSFixedFileInfo(pFileInfo)^;
        // read version blocks
        iVer[1] := HiWord(FFI.dwFileVersionMS);
        iVer[2] := LoWord(FFI.dwFileVersionMS);
        iVer[3] := HiWord(FFI.dwFileVersionLS);
        iVer[4] := LoWord(FFI.dwFileVersionLS);

      end;
    finally
      FreeMem(pBuffer);
    end;
  end;

  // format result string
  Result := Format(Fmt, [iVer[1], iVer[2], iVer[3], iVer[4]]);
end;

function GetDMVersion(AFormat: string = '%d.%d.%d.%d'): string;
begin
  result := RetrieveFileVersionInfo(Application.ExeName, AFormat);
end;

end.
