//      Project: Poker
//         Unit: uSessionModule.pas
//
//      Company: Offshore Creations
//    Developer: Maxim L. Korablev
//
//    Class(es): TSessionModule
//  Description: Start session, keep session, terminate session

unit uSessionModule;

interface

uses
  Forms, Windows, Messages, SysUtils, Classes, AppEvnts, ExtCtrls, ShellAPI,
  xmldom, XMLIntf, msxmldom, XMLDoc, Controls, Dialogs, Registry, Clipbrd,
  uDataList, uHTTPGetFileThread, uFileManagerModule;

const
  ReconnectInterval_MilliSec = 500;
  ConnectFailedCountBeforeTerminate = 20;
  SynchronizingRequestsCount = 6;
  { apgetcurrencies, apgetcountries, apgetstates,
    apgetstats, apgetcategories, apgetprocesses }


type
  TSessionEvent = procedure of object;

  TAppState = (poPreparing,
    poConnecting, poDisconnected, poUpdating,
    poRunning, poReconnecting,
    poTerminating);

  TSessionModule = class(TDataModule)
    ApplicationEvents: TApplicationEvents;
    ReconnectTimer: TTimer;
    NonLatinCharTimer: TTimer;
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure ApplicationEventsActivate(Sender: TObject);
    procedure ReconnectTimerTimer(Sender: TObject);
    procedure ApplicationEventsMessage(var Msg: tagMSG;
      var Handled: Boolean);
    procedure ApplicationEventsDeactivate(Sender: TObject);
    procedure NonLatinCharTimerTimer(Sender: TObject);
  private
    FSessionID: Integer;
    FSessionState: TAppState;
    FSessionSettings: TDataList;
    FAppPath: String;
    FAppName: String;

    FSyhchFinished: Integer;
    FSynchProgress: Real;
    FOnConnecting: TSessionEvent;
    FOnConnectingFailed: TSessionEvent;
    FOnSynchronizing: TSessionEvent;
    FOnSynchronized: TSessionEvent;
    FOnUpdating: TSessionEvent;
    FOnUpdatingFiles: TSessionEvent;

    FNonLatinCharsWarningShowingNow: Boolean;
    FControlPressed: Boolean;

    FConnectFailedCount: Integer;
    FFailedWarningShowingNow: Boolean;

    // Connection events
    procedure OnSocketConnected;
    procedure OnSocketDisconnected;
    procedure Run_Connect(XMLRoot: IXMLNode);
    procedure Run_Message(XMLRoot: IXMLNode);

    // Set procedures
    procedure SetOnConnecting(const Value: TSessionEvent);
    procedure SetOnConnectingFailed(const Value: TSessionEvent);
    procedure SetOnSynchronized(const Value: TSessionEvent);
    procedure SetOnSynchronizing(const Value: TSessionEvent);
    procedure LoadFromRegistry;
    procedure GetApplicationPathAndName;
    procedure SetOnUpdating(const Value: TSessionEvent);
    procedure OnUpdatedCSADownloading(This: THTTPGetFileThread);
    procedure TerminateApplication;
    procedure SetOnUpdatingFiles(const Value: TSessionEvent);
    procedure OnUpdatedFilesDownloading(This: TDownloadSession);
    procedure RetryConnect;
    procedure ApplicationChangeActiveForm(Sender: TObject);
    procedure InitConnect;
  public
    property  SessionID: Integer read FSessionID;
    property  SessionState: TAppState read FSessionState;
    property  SessionSettings: TDataList read FSessionSettings;
    property  AppPath: String read FAppPath;
    property  AppName: String read FAppName;

    // Connecting and synchronizing
    property  SynchProgress: Real read FSynchProgress;
    property  OnConnecting: TSessionEvent read FOnConnecting write SetOnConnecting;
    property  OnConnectingFailed: TSessionEvent read FOnConnectingFailed write SetOnConnectingFailed;
    property  OnSynchronizing: TSessionEvent read FOnSynchronizing write SetOnSynchronizing;
    property  OnSynchronized: TSessionEvent read FOnSynchronized write SetOnSynchronized;
    property  OnUpdating: TSessionEvent read FOnUpdating write SetOnUpdating;
    property  OnUpdatingFiles: TSessionEvent read FOnUpdatingFiles write SetOnUpdatingFiles;

    function CheckForValidApplicationFile: Boolean;

    procedure StartApplication;
    procedure CloseApplication;
    procedure SaveToRegistry;
    procedure ShowApplication;

    // Parser
    procedure RunCommand(XMLRoot: IXMLNode);

    // Synchronizing actions
    procedure Do_Synchronized;
    procedure Do_RetryConnect;
    procedure Do_ViewNetworkStatus;
  end;

var
  SessionModule: TSessionModule;

implementation

uses
  uLogger,
  uConstants,
  uTCPSocketModule,
  uParserModule,
  uConnectingForm,
  uThemeEngineModule,
  uLobbyModule, uUserModule, uLobbyForm, uProcessModule, uTournamentModule,
  uExitForm, uPictureMessageForm;

{$R *.dfm}

{ TSessionModule }

procedure TSessionModule.DataModuleCreate(Sender: TObject);
begin
  FSessionID := 0;
  FSyhchFinished := 0;
  FSynchProgress := 0;
  FOnConnecting := nil;
  FOnConnectingFailed := nil;
  FOnSynchronizing := nil;
  FOnSynchronized := nil;
  FOnUpdating := nil;
  FOnUpdatingFiles := nil;
  FNonLatinCharsWarningShowingNow := False;
  FConnectFailedCount := 0;
  FFailedWarningShowingNow := False;
  FSessionState := poPreparing;
  FSessionSettings := TDataList.Create(0, nil);
  Screen.OnActiveFormChange := ApplicationChangeActiveForm;
  GetApplicationPathAndName;
  LoadFromRegistry;
end;

procedure TSessionModule.DataModuleDestroy(Sender: TObject);
begin
  SaveToRegistry;
  FSessionState := poTerminating;
  FSessionSettings.Free;
end;


// Get/Set procedures

procedure TSessionModule.SetOnUpdatingFiles(const Value: TSessionEvent);
begin
  FOnUpdatingFiles := Value;
end;

procedure TSessionModule.SetOnUpdating(const Value: TSessionEvent);
begin
  FOnUpdating := Value;
end;

procedure TSessionModule.SetOnConnecting(const Value: TSessionEvent);
begin
  FOnConnecting := Value;
end;

procedure TSessionModule.SetOnConnectingFailed(const Value: TSessionEvent);
begin
  FOnConnectingFailed := Value;
end;

procedure TSessionModule.SetOnSynchronized(const Value: TSessionEvent);
begin
  FOnSynchronized := Value;
end;

procedure TSessionModule.SetOnSynchronizing(const Value: TSessionEvent);
begin
  FOnSynchronizing := Value;
end;


// Application events

procedure TSessionModule.ApplicationEventsException(Sender: TObject;
  E: Exception);
begin
  Logger.Add('EXCEPTION (' + E.ClassName + '):' + E.Message, llBase);
  ApplicationEvents.CancelDispatch;
end;


// Initiate application

procedure TSessionModule.StartApplication;
begin
  Logger.Add('SessionModule.StartApplication', llBase);

  TCPSocketModule.OnConnect := OnSocketConnected;
  TCPSocketModule.OnDisconnect := OnSocketDisconnected;

  if Assigned(FOnConnecting) then
    FOnConnecting;

  //delete CSAlog
  if FileExists(SessionModule.AppPath+cstrCSALogFile) then
   DeleteFile(SessionModule.AppPath+cstrCSALogFile);
     
  InitConnect;
end;

procedure TSessionModule.InitConnect;
var
  Index: Integer;
  strText: String;
  strList: TStringList;
begin
  Logger.Add('SessionModule.InitConnect', llBase);

  if FSessionState <> poReconnecting then
    FSessionState := poConnecting;
  FSessionID := 0;
  FSyhchFinished := 0;
  FSynchProgress := 0;

  case SessionSettings.ValuesAsInteger['ssl'] of
    1: TCPSocketModule.SecurityMethod := smSSL;
    2: TCPSocketModule.SecurityMethod := smBlowFish;
  else
    TCPSocketModule.SecurityMethod := smNone;
  end;

  strList := TStringList.Create;
  Randomize;

  strText := SessionSettings.ValuesAsString['host'];
  if strText = '' then
    strText := RemoteHost;

  if strText <> '' then
  begin
    strList.Text := StringReplace(strText, ',', #13#10, [rfReplaceAll, rfIgnoreCase]);
    if strList.Count > 0 then
      if strList.Count = 1 then
        TCPSocketModule.RemoteHost := strList.Strings[0]
      else
      begin
        Index := Random(strList.Count);
        if Index < 0 then
          Index := 0;
        if Index >= strList.Count then
          Index := strList.Count - 1;
        TCPSocketModule.RemoteHost := strList.Strings[Index];
      end;
  end;

  strText := SessionSettings.ValuesAsString['port'];
  if strText = '' then
    strText := IntToStr(RemotePort);

  if strText <> '' then
  begin
    strList.Text := StringReplace(strText, ',', #13#10, [rfReplaceAll, rfIgnoreCase]);
    if strList.Count > 0 then
    begin
      if strList.Count = 1 then
        TCPSocketModule.RemotePort := StrToIntDef(strList.Strings[0], 0)
      else
      begin
        Index := Random(strList.Count);
        if Index < 0 then
          Index := 0;
        if Index >= strList.Count then
          Index := strList.Count - 1;
        TCPSocketModule.RemotePort := StrToIntDef(strList.Strings[Index], 0);
      end;
    end;
  end;

  strList.Free;

  if (TCPSocketModule.RemoteHost <> '') and (TCPSocketModule.RemotePort > 0) then
    TCPSocketModule.Connect
  else
    TerminateApplication;
end;


// Terminate application

procedure TSessionModule.CloseApplication;
var
  NeedClose: Boolean;
begin
  Logger.Add('SessionModule.CloseApplication', llExtended);

  NeedClose := (not TCPSocketModule.Connected) or (not UserModule.Logged);
  if (not NeedClose) or (FSessionState = poUpdating) then
    NeedClose := ThemeEngineModule.AskQuestion(cstrQuitQuestion);

  if NeedClose then
    TerminateApplication;
end;

procedure TSessionModule.TerminateApplication;
var
  Loop: Integer;
begin
  Logger.Add('SessionModule.TerminateApplication', llExtended);

  FSessionState := poTerminating;
  UserModule.Logout;
  LobbyModule.StopWork;

  for Loop := Screen.CustomFormCount - 1 downto 0 do
    Screen.CustomForms[Loop].Hide;

  ExitForm.ShowModal;

  TCPSocketModule.Disconnect;
  ConnectingForm.Close;
  Application.Terminate;

end;

// Connection

procedure TSessionModule.OnSocketConnected;
begin
  ShowWindow(Application.Handle, SW_HIDE);
  ParserModule.Send_Connect;
end;

procedure TSessionModule.RunCommand(XMLRoot: IXMLNode);
var
  Loop: Integer;
  XMLNode: IXMLNode;
  strNode: String;
begin
  Logger.Add('SessionModule.RunCommand started', llExtended);
  try
    if XMLRoot.ChildNodes.Count > 0 then
      for Loop := 0 to XMLRoot.ChildNodes.Count - 1 do
      begin
        XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
        strNode := XMLNode.NodeName;

        if strNode = 'connect' then
          Run_Connect(XMLNode);

        if strNode = 'message' then
          Run_Message(XMLNode);

      end;
  except
    Logger.Add('SessionModule.RunCommand failed', llBase);
  end;
end;

procedure TSessionModule.Run_Connect(XMLRoot: IXMLNode);
{
<object name="session">
  <connect result="0|1001|..." sessionid="1" magicword="passphrase"
   reason="Error reason!!!" tournamentlimit="1"
   processlimit="2" tournamenttablelimit="2" recordhandlimit="1"
   csafileurl="http://www.poker.com/download/updates/poker.exe"
   csafilesize="1890674"/>
</object>
}
var
  ErrorCode: Integer;
  CSA_URL: String;
  CSA_Size: Integer;
begin
  ErrorCode := -1;
  FSessionID := 0;

  if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
  begin
    FSessionID := strtointdef(XMLRoot.Attributes['sessionid'], 0);

    if XMLRoot.HasAttribute('magicword') then
      TCPSocketModule.SetNewPassPhrase(XMLRoot.Attributes['magicword']);

    // Set limitations
    if XMLRoot.HasAttribute('processlimit') then
      ProcessModule.TablesLimit := strtointdef(XMLRoot.Attributes['processlimit'], 0);

    if XMLRoot.HasAttribute('tournamentlimit') then
      TournamentModule.TournamentLimit := strtointdef(XMLRoot.Attributes['tournamentlimit'], 0);

    if XMLRoot.HasAttribute('tournamenttablelimit') then
      ProcessModule.TournamentTablesLimit := strtointdef(XMLRoot.Attributes['tournamenttablelimit'], 0);

    if XMLRoot.HasAttribute('recordhandlimit') then
      ProcessModule.RecordedHandsLimit := strtointdef(XMLRoot.Attributes['recordhandlimit'], 0);

    // Get system files
    if FSessionID > 0 then
      FileManagerModule.DownloadSystemFiles(OnUpdatedFilesDownloading)
    else
      TCPSocketModule.Disconnect;
  end
  else
  if ErrorCode = 1001 then
  begin
    CSA_URL  := XMLRoot.Attributes['csafileurl'];
    CSA_Size := strtointdef(XMLRoot.Attributes['csafilesize'], 0);
    Logger.Add('SessionModule.Run_Connect: Need update from ' + CSA_URL +
      ' with size ' + inttostr(CSA_Size) + ' bytes', llExtended);

    if (CSA_URL <> '') and (CSA_Size > 0) then
      THTTPGetFileThread.Create(0, 0, 0, CSA_URL,
        AppUpdateFileName, FAppPath + AppUpdateFileName, 'exe', 0, 0,
        CSA_Size, OnUpdatedCSADownloading)
    else
    begin
      ThemeEngineModule.ShowWarning(cstrSoftwareUpdateFailed);
      TCPSocketModule.Disconnect;
    end;
  end
  else
    if XMLRoot.HasAttribute('reason') then
      ThemeEngineModule.ShowWarning(XMLRoot.Attributes['reason']);{}
end;

procedure TSessionModule.OnUpdatedCSADownloading(This: THTTPGetFileThread);
begin

  case This.CurrentState of
    gfStart:
      begin
        FSynchProgress := 0;
        if Assigned(FOnUpdating) then
          FOnUpdating;
      end;

    gfDownload:
      begin
        if This.URLFileSize > 0 then
        begin
          FSynchProgress := (100 * This.SizeCompleted) div This.URLFileSize;
          if FSynchProgress > 100 then FSynchProgress := 100;
          if FSynchProgress < 0 then FSynchProgress := 0;
        end
        else
          FSynchProgress := 0;
          
        if Assigned(FOnUpdating) then
          FOnUpdating;
      end;

    gfFinished:
      begin
        FSynchProgress := 100;
        if Assigned(FOnUpdating) then
          FOnUpdating;
        if Assigned(FOnSynchronized) then
          FOnSynchronized;
        ShellExecute(0, pchar('open'), pchar(FAppPath+AppUpdateFileName), nil, pchar(FAppPath), SW_HIDE);
        sleep(0);
        TerminateApplication;
      end;

    gfFailed:
      begin
        if Assigned(FOnSynchronized) then
          FOnSynchronized;
        ThemeEngineModule.ShowWarning(cstrSoftwareUpdateFailed);
        TerminateApplication;
      end;
  end;
end;

procedure TSessionModule.OnUpdatedFilesDownloading(This: TDownloadSession);
var
  Loop: Integer;
  curData: TDataList;
begin
  case This.SessionState of
    gfStart:
      FSynchProgress := 0;

    gfDownload:
      begin
        FSynchProgress := This.PercentCompleted;
        if Assigned(FOnUpdatingFiles) then
          FOnUpdatingFiles;
      end;

    gfFinished:
      begin
        if FSynchProgress > 0 then
        begin
          FSynchProgress := 100;
          if Assigned(FOnUpdatingFiles) then
            FOnUpdatingFiles;
        end;

        for Loop := 0 to This.FilesToDownload.Count - 1 do
        begin
          curData := This.FilesToDownload.Items(Loop);
          case curData.ValuesAsInteger['contenttypeid'] of
            BannerContentTypeID:
              LobbyModule.BannerFileName := curData.ValuesAsString[XMLATTRNAME_NAME];
            PlayerLogoContentTypeID:
              UserModule.PlayerLogoFileName := curData.ValuesAsString[XMLATTRNAME_NAME];
            FlashGameContentTypeID:
              ProcessModule.FlashGameFileName := curData.ValuesAsString[XMLATTRNAME_NAME];
          end;
        end;

        FSyhchFinished := 0;
        FSynchProgress := 0;
        if Assigned(FOnSynchronizing) then
          FOnSynchronizing;

        if not ParserModule.Send_GetReferences then
          TCPSocketModule.Disconnect;
      end;

    gfFailed:
    begin
      if Assigned(FOnSynchronized) then
        FOnSynchronized;
      if not FFailedWarningShowingNow then
      begin
        FFailedWarningShowingNow := True;
        ThemeEngineModule.ShowWarning(cstrFilesUpdateFailed);
        TerminateApplication;
      end;
    end;
  end;
end;

procedure TSessionModule.Do_Synchronized;
begin
  FSyhchFinished := FSyhchFinished + 1;
  if FSyhchFinished >= SynchronizingRequestsCount then
  begin
    FConnectFailedCount := 0;
    FSynchProgress := 100;
    if Assigned(FOnSynchronizing) then
    begin
      PictureMessageForm.Close;
      FOnSynchronizing;
    end;
    if FSessionState = poReconnecting then
      UserModule.AutoLogin;
    if FSessionState <> poRunning then
    begin
      FSessionState := poRunning;
      ProcessModule.UpdateConnectingState;
      LobbyModule.UpdateLoginState;
    end;
    LobbyModule.StartWork;
    FSynchProgress := 0;
    FSyhchFinished := 0;

    if Assigned(FOnSynchronized) then
      FOnSynchronized;
  end
  else
  begin
    FSynchProgress := round(100 * FSyhchFinished / SynchronizingRequestsCount);
    if Assigned(FOnSynchronizing) then
    begin
      PictureMessageForm.Close;
      FOnSynchronizing;
    end;
  end;
end;

procedure TSessionModule.Do_ViewNetworkStatus;
begin
  ShellExecute(0,pchar('open'),pchar(cstrNetworkStatusURL),nil,nil,SW_RESTORE);
end;


// Disconnect and reconnect

procedure TSessionModule.Do_RetryConnect;
begin
  TCPSocketModule.Disconnect;
end;

procedure TSessionModule.ReconnectTimerTimer(Sender: TObject);
begin
  ReconnectTimer.Enabled := false;
  RetryConnect;
end;

procedure TSessionModule.RetryConnect;
begin
  FSessionState := poReconnecting;
  InitConnect;
end;

procedure TSessionModule.OnSocketDisconnected;
var
  OldState: TAppState;
begin
  Logger.Add('SessionModule.OnSocketDisconnected', llExtended);
  FSessionID := 0;
  FSyhchFinished := 0;
  FSynchProgress := 0;
  if FSessionState = poDisconnected then
  begin
    if not ReconnectTimer.Enabled then
    begin
      ReconnectTimer.Interval := ReconnectInterval_MilliSec;
      ReconnectTimer.Enabled := true;
    end
  end
  else
    if FSessionState <> poTerminating then
    begin
      OldState := FSessionState;
      FSessionState := poDisconnected;
      if OldState = poRunning then
      begin
        ProcessModule.UpdateConnectingState;
        LobbyModule.UpdateLoginState;
        ReconnectTimer.Interval := ReconnectInterval_MilliSec;
        if Assigned(FOnConnectingFailed) then
        begin
          FOnConnectingFailed;
          PictureMessageForm.ShowForm(pmReconnect,'',0);
        end;
      end
      else
        ReconnectTimer.Interval := ReconnectInterval_MilliSec;

      FConnectFailedCount := FConnectFailedCount + 1;
      if FConnectFailedCount < ConnectFailedCountBeforeTerminate then
        ReconnectTimer.Enabled := true
      else
      begin
        if Assigned(FOnConnectingFailed) then
          FOnConnectingFailed;
        ThemeEngineModule.ShowWarning(cstrServerUnreachable);
        TerminateApplication;
      end;
    end;
end;

procedure TSessionModule.SaveToRegistry;
Var
  Reg : TRegINIFile;
  Loop: Integer;
  strName: String;
begin
  try
    Reg := TRegIniFile.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      Reg.OpenKey(RegistryKey, True);
      Reg.DeleteValue(SessionUserName);
      Reg.DeleteValue(SessionUserPassword);
      for Loop := 0 to FSessionSettings.ValueCount - 1 do
      begin
        strName := FSessionSettings.ValueNames[Loop];
        Reg.WriteString('', strName, String(FSessionSettings.Values[Loop]));
      end;
    finally
      Reg.CloseKey;
      Reg.Free;
    end;
  except
    Logger.Add('SessionModule.SaveToRegistry failed.', llBase);
    ShowMessage(cstrSettingsDeny);
  end;
end;

procedure TSessionModule.LoadFromRegistry;
Var
  Reg : TRegINIFile;
  ValueList: TStringList;
  Loop: Integer;
begin
  try
    ValueList := TStringList.Create;
    Reg := TRegIniFile.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKeyReadOnly(RegistryKey) then
      Reg.ReadSectionValues('', ValueList);

      SessionSettings.ValuesAsString[SessionHideWelcomeMessage] := '0';
      SessionSettings.ValuesAsString[SessionShowPlayMoneyTables] := '1';
      SessionSettings.ValuesAsString[SessionShowNoLimitTables] := '0';
      SessionSettings.ValuesAsString[SessionShowLimitTables] := '0';
      SessionSettings.ValuesAsString[SessionShowLPTables] := '0';
      SessionSettings.ValuesAsString[SessionHideCompletedTournamens] := '1';
      SessionSettings.ValuesAsString[SessionHideRunningTournamens] := '0';
      SessionSettings.ValuesAsString[SessionHideFullTables] := '0';

      SessionSettings.ValuesAsString[SessionDeckColor] := 'black';
      SessionSettings.ValuesAsString[SessionUse4ColorsDeck] := '0';
      SessionSettings.ValuesAsString[SessionEnableAnimation] := '1';
      SessionSettings.ValuesAsString[SessionEnableChatBubbles] := '0';
      SessionSettings.ValuesAsString[SessionEnableSounds] := '1';
      SessionSettings.ValuesAsString[SessionReverseStereoPanning] := '0';
      SessionSettings.ValuesAsString[SessionChatMode] := '2';

      SessionSettings.ValuesAsString[SessionProcessStatsOnTop] := '0';
      SessionSettings.ValuesAsString[SessionProcessStatsPreserve] := '0';
      SessionSettings.ValuesAsString[SessionProcessLogging] := '0';

      SessionSettings.ValuesAsString[SessionWebserviceHost] := '196.40.45.132';

      if SessionSettings.ValuesAsString[RegistryAffiliateIDName] = '' then
        SessionSettings.ValuesAsString[RegistryAffiliateIDName] := CSA_DefaultAffiliateID;

      if SessionSettings.ValuesAsString[RegistryAdvertisementIDName] = '' then
        SessionSettings.ValuesAsString[RegistryAdvertisementIDName] := CSA_DefaultAdvertisementID;

      for Loop := 0 to ValueList.Count - 1 do
        FSessionSettings.ValuesAsString[ValueList.Names[Loop]] := ValueList.ValueFromIndex[Loop];
    finally
      Reg.CloseKey;
      Reg.Free;
      ValueList.Free;
    end;
  except
    Logger.Add('SessionModule.LoadFromRegistry failed.', llBase);
  end;
end;

procedure TSessionModule.GetApplicationPathAndName;
var
  PCModuleName: PChar;
begin
  GetMem(PCModuleName, MAX_PATH);
  GetModuleFileName(0, PCModuleName, MAX_Path);
  FAppPath := ExtractFilePath(PCModuleName);
  FAppName := ExtractFileName(PCModuleName);
  FreeMem(PCModuleName);
end;


procedure TSessionModule.ApplicationEventsMessage(var Msg: tagMSG;
  var Handled: Boolean);
var
  Loop: Integer;
  inBuffer: String;
  curChar: Char;
  outBuffer: String;
begin
  Handled := False;

  if ((MSG.message = WM_KEYDOWN) or (MSG.message = WM_KEYUP)) then
  begin
    if msg.wParam = $5D then
      Handled := true;

    if msg.wparam = 17 then
      FControlPressed := MSG.message = WM_KEYDOWN;

    if (msg.wparam = ord('V')) and FControlPressed then
    begin
      Clipboard.Open;
      inBuffer := Clipboard.AsText;
      Clipboard.Close;

      if inBuffer <> '' then
      begin
        outBuffer := '';
        for Loop := 1 to Length(inBuffer) do
        begin
          curChar := inBuffer[Loop];
          if (curChar > #127) or (curChar = '<') or (curChar = '>') or (curChar = '?') then
            Continue;
          outBuffer := outBuffer + curChar;
          if Length(outBuffer) >= 45 then
            Break;
        end;
      end;

      Clipboard.Open;
      Clipboard.Clear;
      Clipboard.AsText := outBuffer;
      Clipboard.Close;
    end;

  end;

  if MSG.message = WM_CHAR then
    if (msg.wparam > 127) or (msg.wparam = ord('<')) or (msg.wparam = ord('>')) then
    begin
      Handled:=true;
      if not FNonLatinCharsWarningShowingNow then
      begin
        FNonLatinCharsWarningShowingNow := True;
        NonLatinCharTimer.Enabled := True;
      end;
    end;

  if (Msg.message = WM_CONTEXTMENU) or
    ((MSG.wparam = 121) and ((MSG.message = WM_SYSKEYDOWN) or (MSG.message = WM_SYSKEYUP))) or
    (Msg.message = WM_RBUTTONUP) or (Msg.message = WM_RBUTTONDOWN) or
    (Msg.message = WM_RBUTTONDBLCLK) or
    (Msg.message = WM_NCRBUTTONUP) or (Msg.message = WM_NCRBUTTONDOWN) or
    (Msg.message = WM_NCRBUTTONDBLCLK) then
//    if (LobbyForm.ShockwaveFlash.Handle = Msg.hwnd) or
//      ProcessModule.IsProcessHandle(Msg.hwnd) then
        Handled := true;
end;


function TSessionModule.CheckForValidApplicationFile: Boolean;
Var
  ConnFormRunningHandle: HWND;
  LobbyFormRunningHandle: HWND;
begin
  Result := true;

  if lowercase(FAppName) = lowercase(AppUpdateFileName) then
  try
    Result := false;
    while FileExists(FAppPath+AppFileName) do
    begin
      sleep(0);
      DeleteFile(FAppPath+AppFileName);
    end;
    copyfile(pchar(FAppPath+AppUpdateFileName), pchar(FAppPath+AppFileName), false);
    ShellExecute(0, pchar('open'), pchar(FAppPath+AppFileName), nil, pchar(FAppPath), SW_HIDE);
  except
  end
  else
  try
    if FileExists(FAppPath+AppUpdateFileName) then
      DeleteFile(FAppPath+AppUpdateFileName);

    if not (lowercase(SessionSettings.ValuesAsString[RegistryMultiInstancesKey]) =
       lowercase(RegistryMultiInstancesValue)) then
    begin
      ConnFormRunningHandle := FindWindow('TConnectingForm', nil);
      LobbyFormRunningHandle := FindWindow('TLobbyForm', nil);
      if (ConnFormRunningHandle > 0) or (LobbyFormRunningHandle > 0) then
      begin
        Result := false;
        if LobbyFormRunningHandle > 0 then
          SetForegroundWindow(LobbyFormRunningHandle)
        else
          if ConnFormRunningHandle > 0 then
            SetForegroundWindow(ConnFormRunningHandle);
        SendMessage(ConnFormRunningHandle, WM_USER, 0,0);
      end;
    end;
  except
  end;
end;


// Activate/Deactivate/ChangeActiveForm

procedure TSessionModule.ApplicationEventsActivate(Sender: TObject);
begin
  if (FSessionState = poConnecting) or (FSessionState = poDisconnected) or
    (FSessionState = poUpdating) or (FSessionState = poRunning) or
    (FSessionState = poReconnecting) then
  begin
    ThemeEngineModule.DeActivateAllForms;
    ThemeEngineModule.ActivateCurrentForm;

    if FSessionState = poRunning then
      ProcessModule.UpdateActiveStates(true);
  end;
end;

procedure TSessionModule.ApplicationEventsDeactivate(Sender: TObject);
begin
  if (FSessionState = poConnecting) or (FSessionState = poDisconnected) or
    (FSessionState = poUpdating) or (FSessionState = poRunning) or
    (FSessionState = poReconnecting) then
  begin
    ThemeEngineModule.DeActivateAllForms;

    if FSessionState = poRunning then
      ProcessModule.UpdateActiveStates(false);
  end;
end;

procedure TSessionModule.ApplicationChangeActiveForm(Sender: TObject);
begin
  if (FSessionState = poConnecting) or (FSessionState = poDisconnected) or
    (FSessionState = poUpdating) or (FSessionState = poRunning) or
    (FSessionState = poReconnecting) then
  begin
    ThemeEngineModule.DeActivateAllForms;
    ThemeEngineModule.ActivateCurrentForm;
  end;
end;

procedure TSessionModule.ShowApplication;
begin
  if FSessionState = poRunning then
    LobbyForm.ShowLobby;
end;

procedure TSessionModule.NonLatinCharTimerTimer(Sender: TObject);
begin
  NonLatinCharTimer.Enabled := False;
  ThemeEngineModule.ShowWarning(cstrNonLatinChars);
  FNonLatinCharsWarningShowingNow := False;
end;

procedure TSessionModule.Run_Message(XMLRoot: IXMLNode);
{
<object name="session">
  <message msg="Text"/>
</object>
}
var StrMes: String;
begin
  if XMLRoot.HasAttribute('msg') then
  begin
    StrMes := XMLRoot.Attributes['msg'];
    {if pos('Congratulations',StrMes) <> 0 then
     PictureMessageForm.ShowForm(pmPrizeInfo,StrMes)
    else{}
     ThemeEngineModule.ShowMessage(StrMes);
  end;
end;

end.


