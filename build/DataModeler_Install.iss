#define DMLocalExeFile "..\source\Win32\Release\dm.exe"
#define DMVersion GetFileProductVersion(DMLocalExeFile)
#define MyAppName "TMS Data Modeler"
#define MyAppVerName "TMS Data Modeler "  + DMVersion
#define DMOutputDir ".\__output"
#define DMOutputFileName "dmstp-" + DMVersion
#define MyAppPublisher "tmssoftware.com"
#define MyAppURL "https://www.tmssoftware.com"
#define MyAppExeName "dm.exe"
#define MyAppHelpFile "datamodeler_manual.chm"
#define MyAppManualFile "datamodeler_manual.pdf"
#define DMAppCopyright GetFileCopyright(DMLocalExeFile)
#define DMAppSupportURL "https://www.tmssoftware.com/site/support.asp"
;#define DMRegistrySettingsKey "Software\TMS Software\Data Modeler\Settings"

[Setup]
AppId={{E03055E3-D4AB-47CE-AAB9-F58797F8D314}}
AppName={#MyAppName}
AppVerName={#MyAppVerName}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#DMAppSupportURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\TMSSoftware\DataModeler
DefaultGroupName={#MyAppName}
LicenseFile=..\LICENSE.txt
OutputDir={#DMOutputDir}
OutputBaseFilename={#DMOutputFileName}
Compression=lzma
SolidCompression=true
VersionInfoCompany={#MyAppPublisher}
VersionInfoDescription={#MyAppName} Installer
VersionInfoCopyright={#DMAppCopyright}
ChangesAssociations=true
WizardImageFile=DM_Setup_Image.bmp
WizardSmallImageFile=DM_Setup_Image_Small.bmp
SetupIconFile=..\source\dm.ico
AppComments=.
AppVersion={#DMVersion}
AppCopyright={#DMAppCopyright}
VersionInfoVersion={#DMVersion}
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
UninstallDisplayIcon={app}\{#MyAppExeName}
SignedUninstaller=yes
SignTool=dmsigner
SignToolRetryCount=10
SignToolRetryDelay=60

[Tasks]
Name: desktopicon; Description: {cm:CreateDesktopIcon}; GroupDescription: {cm:AdditionalIcons}

[Files]
Source: {#DMLocalExeFile}; DestDir: {app}; Flags: ignoreversion signonce
Source: ..\source\conversions\*.dcm; DestDir: {app}\conversions; Flags: ignoreversion recursesubdirs createallsubdirs
;Source: ..\doc\manual\output\chm\datamodeler_manual.chm; DestDir: {app}; Flags: ignoreversion
;Source: ..\doc\manual\output\pdf\datamodeler_manual.pdf; DestDir: {app}; Flags: ignoreversion
Source: ..\samples\adventureworks.*; DestDir: {app}\samples; Flags: ignoreversion recursesubdirs createallsubdirs
Source: ..\samples\pubs.*; DestDir: {app}\samples; Flags: ignoreversion recursesubdirs createallsubdirs
Source: ..\samples\northwind.*; DestDir: {app}\samples; Flags: ignoreversion recursesubdirs createallsubdirs
Source: ..\samples\dbdemos.*; DestDir: {app}\samples; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: {group}\{#MyAppName}; Filename: {app}\{#MyAppExeName}
;Name: {group}\Documentation; Filename: {app}\{#MyAppHelpFile}
Name: {group}\Sample Projects; Filename: {app}\samples
Name: {autodesktop}\{#MyAppName}; Filename: {app}\{#MyAppExeName}; Tasks: desktopicon

[Run]
Filename: {app}\{#MyAppExeName}; Description: {cm:LaunchProgram,{#MyAppName}}; Flags: nowait postinstall runascurrentuser skipifsilent; 

[Registry]
Root: HKA; Subkey: "Software\Classes\.dgp\OpenWithProgids"; ValueType: string; ValueName: "TMSDataModeler.dgp"; ValueData: ""; Flags: uninsdeletevalue
Root: HKA; Subkey: "Software\Classes\TMSDataModeler.dgp"; ValueType: string; ValueName: ""; ValueData: "TMS Data Modeler project"; Flags: uninsdeletekey
Root: HKA; Subkey: "Software\Classes\TMSDataModeler.dgp\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"",0"
Root: HKA; Subkey: "Software\Classes\TMSDataModeler.dgp\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""
Root: HKA; Subkey: "Software\Classes\Applications\dm.exe\SupportedTypes"; ValueType: string; ValueName: ".dgp"; ValueData: ""
;Root: HKCU; Subkey: {#DMRegistrySettingsKey}; ValueType: string; ValueName: DefaultProject; ValueData: {app}\samples\northwind\northwind.dgp; Flags: uninsdeletevalue
;Root: HKCU; Subkey: {#DMRegistrySettingsKey}; ValueType: string; ValueName: AutoRemoveDefaultProject; ValueData: 1; Flags: uninsdeletevalue
