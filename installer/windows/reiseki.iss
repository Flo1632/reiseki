; Reiseki — Windows Installer
; Built with Inno Setup 6.x
; Requires: PyInstaller output at ..\..\agent\dist\Reiseki\

#ifndef AppVersion
  #define AppVersion "0.0.0"
#endif

[Setup]
AppName=Reiseki
AppVersion={#AppVersion}
AppPublisher=Florian
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

[UninstallDelete]
Type: files; Name: "{app}\workspace.txt"

[Code]
var
  WorkspacePage: TInputDirWizardPage;

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
    Result := False;
  end;
end;

procedure InitializeWizard;
begin
  WorkspacePage := CreateInputDirPage(
    wpSelectDir,
    'Select Workspace Folder',
    'Choose the folder where Reiseki will read and write your files.',
    'A new folder will be created here for Reiseki to work in. ' +
    'Leave the default or pick a different location.',
    False,
    'Reiseki Workspace'
  );
  WorkspacePage.Add('');
  WorkspacePage.Values[0] := ExpandConstant('{userdocs}\Reiseki');
end;

function IsUnsafePath(P: String): Boolean;
var
  WinDir, ProgFiles, ProgFiles86, ProgData, AppDir: String;
begin
  Result := False;
  WinDir     := ExpandConstant('{win}');
  ProgFiles  := ExpandConstant('{pf}');
  ProgFiles86:= ExpandConstant('{pf32}');
  ProgData   := ExpandConstant('{commonappdata}');
  AppDir     := ExpandConstant('{app}');
  // Reject if the path starts with any system directory
  if (Pos(LowerCase(WinDir),      LowerCase(P)) = 1) or
     (Pos(LowerCase(ProgFiles),   LowerCase(P)) = 1) or
     (Pos(LowerCase(ProgFiles86), LowerCase(P)) = 1) or
     (Pos(LowerCase(ProgData),    LowerCase(P)) = 1) or
     (Pos(LowerCase(AppDir),      LowerCase(P)) = 1) then
    Result := True;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  P: String;
begin
  Result := True;
  if CurPageID = WorkspacePage.ID then
  begin
    P := WorkspacePage.Values[0];
    if P = '' then
    begin
      MsgBox('Please enter a workspace folder path.', mbError, MB_OK);
      Result := False; Exit;
    end;
    if Length(P) > 260 then
    begin
      MsgBox('The path is too long (max 260 characters).', mbError, MB_OK);
      Result := False; Exit;
    end;
    if (Pos('\\', Copy(P, 1, 2)) = 1) then
    begin
      MsgBox('Network paths (\\server\share) are not supported.', mbError, MB_OK);
      Result := False; Exit;
    end;
    if IsUnsafePath(P) then
    begin
      MsgBox(
        'Please choose a folder inside your user profile (e.g. Documents\Reiseki).' + #13#10 +
        'System and program directories are not allowed.',
        mbError, MB_OK
      );
      Result := False; Exit;
    end;
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  WorkspacePath: String;
begin
  if CurStep = ssPostInstall then
  begin
    WorkspacePath := WorkspacePage.Values[0];
    if WorkspacePath = '' then
      WorkspacePath := ExpandConstant('{userdocs}\Reiseki');

    // Create the workspace directory
    if not ForceDirectories(WorkspacePath) then
      MsgBox('Could not create workspace folder: ' + WorkspacePath, mbError, MB_OK);

    // SaveStringToFile writes UTF-8 in Inno Setup 6 — Python reads it with utf-8-sig
    SaveStringToFile(ExpandConstant('{app}\workspace.txt'), WorkspacePath, False);
  end;
end;


