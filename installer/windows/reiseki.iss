; Reiseki — Windows Installer
; Built with Inno Setup 6.x
; Requires: PyInstaller output at ..\..\agent\dist\Reiseki\

#ifndef AppVersion
  #define AppVersion "0.0.0"
#endif

[Setup]
AppName=Reiseki
AppVersion={#AppVersion}
AppPublisher=Florian Zielasko
AppPublisherURL=https://github.com/Flo1632/reiseki
DefaultDirName={autopf}\Reiseki
DefaultGroupName=Reiseki
OutputDir=Output
OutputBaseFilename=ReisekiSetup
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
; Require 64-bit Windows
ArchitecturesInstallIn64BitMode=x64compatible
ArchitecturesAllowed=x64compatible
; No admin rights needed — Reiseki installs to user programs folder
PrivilegesRequired=lowest
; Minimum Windows 10
MinVersion=10.0

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "..\..\agent\dist\Reiseki\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Reiseki"; Filename: "{app}\Reiseki.exe"
Name: "{group}\{cm:UninstallProgram,Reiseki}"; Filename: "{uninstallexe}"
Name: "{userdesktop}\Reiseki"; Filename: "{app}\Reiseki.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\Reiseki.exe"; Description: "{cm:LaunchProgram,Reiseki}"; \
  Flags: nowait postinstall skipifsilent

[Code]
function OllamaInstalled(): Boolean;
begin
  Result := FileExists(ExpandConstant('{localappdata}\Programs\Ollama\ollama.exe'));
  if not Result then
    Result := FileSearch('ollama.exe', GetEnv('PATH')) <> '';
end;

function InitializeSetup(): Boolean;
begin
  Result := True;
  if not OllamaInstalled() then
  begin
    MsgBox(
      'Ollama is not installed.' + #13#10 + #13#10 +
      'Reiseki requires Ollama to run the AI model.' + #13#10 +
      'Please install it first from:' + #13#10 +
      'https://ollama.com/download' + #13#10 + #13#10 +
      'After installing Ollama, run this installer again.',
      mbError,
      MB_OK
    );
    Result := False; // abort installation
  end;
end;
