#ifndef BuildArch
  #define BuildArch "universal"
#endif

#define DistAppName "Sitemarker"
#define DistAppVersion "4.0.0"
#define DistAppPublisher "Aero"
#define DistAppURL "https://aerocyber.github.io/sitemarker"
#define DistAppSupportURL "https://github.com/aerocyber/sitemarker/issues"
#define DistAppExeName "sitemarker.exe"
#define DistAppAssocName "Osmata Input Output File"
#define DistAppAssocExt ".omio"
#define DistAppAssocKey StringChange(DistAppAssocName, " ", "") + DistAppAssocExt

[Setup]
; AppId is the unique GUID of the application
AppId={{30DE3E66-CE67-4040-ADD4-E164744A9DD3}

; Architecture Stuff
#if BuildArch == "x64"
  ArchitecturesAllowed=x64compatible
  ArchitecturesInstallIn64BitMode=x64compatible
  OutputBaseFilename={#DistAppName}-{#DistAppVersion}-x64-Setup
#elif BuildArch == "arm64"
  ArchitecturesAllowed=arm64
  ArchitecturesInstallIn64BitMode=arm64
  OutputBaseFilename={#DistAppName}-{#DistAppVersion}-arm64-Setup
#else
  ; Fallback to Universal
  ArchitecturesAllowed=x64compatible arm64
  ArchitecturesInstallIn64BitMode=x64compatible arm64
  OutputBaseFilename={#DistAppName}-{#DistAppVersion}-universal-Setup
#endif

; Branding
SetupIconFile=..\..\sitemarker\windows\runner\resources\app_icon.ico
WizardStyle=modern dynamic windows11 includetitlebar

; QoS and App info
AllowCancelDuringInstall=no
AppName={#DistAppName}
AppVerName={#DistAppName} {#DistAppVersion}
AppVersion={#DistAppVersion}
ChangesAssociations=yes
ChangesEnvironment=yes
AppCopyright=Copyright (C) 2023-present {#DistAppPublisher}

; Installer privileges
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=commandline dialog
UsePreviousPrivileges=yes

; Other QoS
SetupLogging=yes
UninstallLogging=yes
Uninstallable=yes
CreateUninstallRegKey=yes

; App dir
AppendDefaultDirName=yes
CreateAppDir=yes
DefaultDirName={autoappdata}\{#DistAppName}
UsePreviousAppDir=yes

; Compiler stuff
Output=yes
OutputDir=..\build\windows\installer

; Installation Pages Control
AlwaysShowDirOnReadyPage=yes
AlwaysShowGroupOnReadyPage=yes
DisableReadyMemo=no
DisableWelcomePage=no
LicenseFile=..\..\LICENSE

; Uninstallation
AppComments=A beautiful, offline-first digital vault for your bookmarks
AppContact=Raise an issue
AppPublisher={#DistAppPublisher}
AppPublisherURL={#DistAppURL}
AppSupportURL={#DistAppSupportURL}

[Languages]
Name: English; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: desktopicon; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; x64 binaries
#if BuildArch == "x64" || BuildArch == "universal"
Source: "..\..\sitemarker\build\windows\x64\runner\Release\{#DistAppExeName}"; DestDir: "{app}"; Flags: ignoreversion; Check: IsX64Compatible
Source: "..\..\sitemarker\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsX64Compatible
#endif

; arm64 binaries
#if BuildArch == "arm64" || BuildArch == "universal"
Source: "..\..\sitemarker\build\windows\arm64\runner\Release\{#DistAppExeName}"; DestDir: "{app}"; Flags: ignoreversion; Check: IsArm64
Source: "..\..\sitemarker\build\windows\arm64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: IsArm64
#endif

[Icons]
Name: "{autoprograms}\{#DistAppName}"; Filename: "{app}\{#DistAppExeName}"
Name: "{autodesktop}\{#DistAppName}"; Filename: "{app}\{#DistAppExeName}"; Tasks: desktopicon

[Registry]
Root: HKA; Subkey: "Software\Classes\{#DistAppAssocExt}\OpenWithProgids"; ValueType: string; ValueName: "{#DistAppAssocKey}"; ValueData: ""; Flags: uninsdeletevalue
Root: HKA; Subkey: "Software\Classes\{#DistAppAssocKey}"; ValueType: string; ValueName: ""; ValueData: "{#DistAppAssocName}"; Flags: uninsdeletekey
Root: HKA; Subkey: "Software\Classes\{#DistAppAssocKey}\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#DistAppExeName},0"
Root: HKA; Subkey: "Software\Classes\{#DistAppAssocKey}\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#DistAppExeName}"" ""%1"""
Root: HKA; Subkey: "Software\Classes\Applications\{#DistAppExeName}\SupportedTypes"; ValueType: string; ValueName: ".omio"; ValueData: ""