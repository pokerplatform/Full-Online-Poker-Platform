unit uCommonDataModule;

interface

uses
  Forms, Windows, Messages, SysUtils, Classes, AppEvnts, ExtCtrls, ShellAPI,
  xmldom, XMLIntf, msxmldom, XMLDoc, Dialogs,
  Registry, Contnrs,
  uDataList, uTCPSocketModule, uLobbyModule, uBotConnection,
  uBotForm, uBotConstants, uBotClasses;

  { apgetcurrencies, apgetcountries, apgetstates,
    apgetstats, apgetcategories, apgetprocesses }

type
  TSimpleEvent = procedure of object;
  TGenerationProgressEvent = procedure (Percent: Integer) of object;

  TCommonDataModule = class(TDataModule)
    ApplicationEvents: TApplicationEvents;
    ReadTimer: TTimer;
    RefreshTimer: TTimer;
    ConnectionsTimer: TTimer;
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure ReadTimerTimer(Sender: TObject);
    procedure RefreshTimerTimer(Sender: TObject);
    procedure ConnectionsTimerTimer(Sender: TObject);
  private
    FAppPath: String;
    FSessionSettings: TDataList;
    FCommandRunned: Boolean;
    FCommandBuffer: TStringList;
    FBotList: TDataList;
    FBotConnections: TObjectList;
    FOnBotListUpdate: TSimpleEvent;
    FOnBotConnectedUpdate: TSimpleEvent;
    FLobbyModule: TLobbyModule;
    FLastUpdateTime: TDateTime;
    FStartTime: TDateTime;
    FSupportedADList: array of Integer;
    FApplicationTerminationAllowed: Boolean;

    // Parser
    procedure ParseCommands;

    // Commands
    procedure RunCommand(BotConnection: TBotConnection; XMLRoot: IXMLNode);
    procedure Run_Connect(BotConnection: TBotConnection; XMLRoot: IXMLNode);
    procedure Run_Disconnect(BotConnection: TBotConnection; XMLRoot: IXMLNode);
    procedure Run_Message(BotConnection: TBotConnection; XMLRoot: IXMLNode);
    procedure Run_Login(BotConnection: TBotConnection; XMLRoot: IXMLNode);
    procedure Run_NewUser(BotConnection: TBotConnection; XMLRoot: IXMLNode);

    // Bot List
    procedure CheckBotConnections;
    function  CheckBotListForDublicates(LoginName, EMail: String): Boolean;

    // For automation
    function CountJoinedBotsToProcess(ProcessID: Integer): Integer;
    procedure GetFirstEmptyTable(var ProcessID, CountJoinedBots: Integer; var ProcessName: string);
    function GetFirstNotJoinedBotID(ProcessID: Integer): Integer; // result = BotID
    procedure AutoJoinBotsToProcesses;
    function GetCountNotJoinedBots: Integer;
    procedure FillADList;
    procedure SitBotToProcesses(BotConnection: TBotConnection);
  public
    property ApplicationTerminationAllowed: Boolean read FApplicationTerminationAllowed write FApplicationTerminationAllowed;
    property SessionSettings: TDataList read FSessionSettings;
    property BotList: TDataList read FBotList;
    property BotConnections: TObjectList read FBotConnections;
    property LobbyModule: TLobbyModule read FLobbyModule;

    property OnBotListUpdate: TSimpleEvent read FOnBotListUpdate write FOnBotListUpdate;
    property OnBotConnectedUpdate: TSimpleEvent read FOnBotConnectedUpdate write FOnBotConnectedUpdate;

    // read only
    property CountNotJoinedBots: Integer read GetCountNotJoinedBots;

    function BotsConnected: Integer;
    function BotsDisconnected: Integer;
    function BotsRegistered: Integer;
    function BotsLogged: Integer;
    procedure BotsSummary(var ConnectedCount, DisconnectedCount, RegisteredCount, LoggedCount: Integer);

    // Registry
    procedure LoadFromRegistry;
    procedure SaveToRegistry;

    // BotList
    procedure GenerateBotsByMask(OnGenerationProgress: TGenerationProgressEvent);
    procedure GenerateBotsFromFile(OnGenerationProgress: TGenerationProgressEvent;
      FileName: String);

    // BotConnections
    function FindBotConnection(BotID: Integer; var BotConnection: TBotConnection;
      LogError: Boolean = False): Boolean;
    function FindBotConnectionByUserID(UserID: Integer; var BotConnection: TBotConnection;
      LogError: Boolean = False): Boolean;
    function ConnectBot(BotID: Integer): TBotConnection;
    procedure ConnectBots(BotIDs: String);
    function ReconnectBot(BotID: Integer): TBotConnection;
    procedure DisconnectBot(BotID: Integer);

    // Bot Actions
    procedure BotProcessorResponse(UserID, ProcessId: Integer; sResponse: string; aResponseType: TFixAction);

    // Parser
    procedure ParseCommand(BotID: Integer; Command: String);
    function  CheckCommandResult(BotConnection: TBotConnection; XMLNode: IXMLNode): Boolean;

    // Updates
    procedure RefreshAll;

    // BotAction
    procedure JoinBotToProcess(BotID, ProcessID: Integer; ProcessName: String);
  end;

var
  CommonDataModule: TCommonDataModule;

implementation

{$R *.dfm}

uses
  uParserModule, uLogger, uConstants,
  uConversions, DateUtils, Math;

{ TCommonDataModule }


// Common

procedure TCommonDataModule.DataModuleCreate(Sender: TObject);
var
  PCModuleName: PChar;
begin
  FStartTime := Now;
  FApplicationTerminationAllowed := False;
  SetLength(FSupportedADList, 0);

  GetMem(PCModuleName, MAX_PATH);
  GetModuleFileName(0, PCModuleName, MAX_Path);
  FAppPath := ExtractFilePath(PCModuleName);
  FreeMem(PCModuleName);

  FSessionSettings := TDataList.Create(0, nil);
  FBotList := TDataList.Create(0, nil);
  FBotList.LoadFromFile(FAppPath + BotListFileName);
  FBotConnections := TObjectList.Create(True);
  FCommandBuffer := TStringList.Create;
  FLobbyModule := TLobbyModule.Create;
  FCommandRunned := False;
  FLastUpdateTime := Now;

  LoadFromRegistry;
  Randomize;
  RefreshAll;

  Logger.Log(0, ClassName, 'Create', 'Created sucessfully', ltBase);
end;

procedure TCommonDataModule.DataModuleDestroy(Sender: TObject);
begin
  RefreshTimer.Enabled := False;
  ReadTimer.Enabled := False;
  SaveToRegistry;
  FBotList.SaveToFile(FAppPath + BotListFileName, 'BotList');
  FBotConnections.Free;
  FBotList.Free;
  FSessionSettings.Free;
  FCommandBuffer.Free;
  FLobbyModule.Free;
  Logger.Log(0, ClassName, 'Destroy', 'Destroyed sucessfully', ltBase);
end;


// Exceptions handler

procedure TCommonDataModule.ApplicationEventsException(Sender: TObject; E: Exception);
begin
  Logger.Log(0, ClassName, 'ApplicationEventsException',
    E.ClassName + ' - ' + E.Message, ltException);
  ApplicationEvents.CancelDispatch;
end;


// Registry

procedure TCommonDataModule.LoadFromRegistry;
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

      // Default settings
      FSessionSettings.ValuesAsString[BotRemoteHost] := RemoteHost;
      FSessionSettings.ValuesAsString[BotRemotePort] := RemotePort;
      FSessionSettings.ValuesAsBoolean[BotKeepConnected] := True;
      FSessionSettings.ValuesAsBoolean[BotSSL] := False;
      FSessionSettings.ValuesAsBoolean[BotCompressTraffic] := False;
      FSessionSettings.ValuesAsBoolean[BotLogging] := True;
      FSessionSettings.ValuesAsInteger[BotNewConnectionsPerSecond] := 1;
      FSessionSettings.ValuesAsString[BotGenerationName] := 'robot';
      FSessionSettings.ValuesAsString[BotGenerationPassword] := 'qwerty1';
      FSessionSettings.ValuesAsString[BotGenerationLocation] := 'Botland';
      FSessionSettings.ValuesAsInteger[BotGenerationCount] := 100;
      FSessionSettings.ValuesAsBoolean[BotGenerationPrivate] := False;
      FSessionSettings.ValuesAsBoolean[BotGenerationMale] := True;
      FSessionSettings.ValuesAsInteger[BotRefreshInterval] := 1;
      FSessionSettings.ValuesAsInteger[BotResponseTimeOutProcesses] := 10;
      FSessionSettings.ValuesAsInteger[BotResponseTimeOutOnBotEntry] := 5;
      FSessionSettings.ValuesAsInteger[BotTimeOutOnHandTimeline] := 10;
      FSessionSettings.ValuesAsString[BotMailList] := '';
      FSessionSettings.ValuesAsBoolean[BotAllowManyTables] := True;
      FSessionSettings.ValuesAsBoolean[BotUseHeaders] := True;
      FSessionSettings.ValuesAsBoolean[BotRestrictByNames] := True;
      FSessionSettings.ValuesAsString[BotRestrictedNames] := 'Computer';
      FSessionSettings.ValuesAsString[BotActionDispatcherIDList] := '';
      FSessionSettings.ValuesAsInteger[BotMaximumWorkTime] := 300;
      FSessionSettings.ValuesAsBoolean[BotStopAfterMaximumWorkTime] := True;
      FSessionSettings.ValuesAsBoolean[BotRestartAfterMaximumWorkTime] := True;
      FSessionSettings.ValuesAsBoolean[BotEmulateLobby] := False;
      FSessionSettings.ValuesAsInteger[BotEmulateLobbyType] := 1;
      FSessionSettings.ValuesAsInteger[BotAutoSitCount] := 2;
      FSessionSettings.ValuesAsInteger[BotAutoSitGamers] := 3;
      FSessionSettings.ValuesAsInteger[BotAutoLeaveOnGamers] := 3;
      FSessionSettings.ValuesAsInteger[BotAutoSitTimeOut] := 30;
      FSessionSettings.ValuesAsInteger[BotAutoResponseTimeOut] := 3;

      for Loop := 0 to ValueList.Count - 1 do
        FSessionSettings.ValuesAsString[ValueList.Names[Loop]] := ValueList.ValueFromIndex[Loop];

      Logger.Logging := FSessionSettings.ValuesAsBoolean[BotLogging];
      FillADList;
    finally
      Reg.CloseKey;
      Reg.Free;
      ValueList.Free;
    end;
  except
    on E: Exception do
      Logger.Log(0, ClassName, 'LoadFromRegistry', E.Message, ltException);
  end;
end;

procedure TCommonDataModule.SaveToRegistry;
Var
  Reg: TRegINIFile;
  Loop: Integer;
begin
  try
    Reg := TRegIniFile.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      Reg.OpenKey(RegistryKey, True);
      for Loop := 0 to FSessionSettings.ValueCount - 1 do
        Reg.WriteString('', FSessionSettings.ValueNames[Loop],
          String(FSessionSettings.Values[Loop]));
    finally
      Reg.CloseKey;
      Reg.Free;
    end;
  except
    on E: Exception do
      Logger.Log(0, ClassName, 'SaveToRegistry', E.Message, ltException);
  end;

  Logger.Logging := FSessionSettings.ValuesAsBoolean[BotLogging];
  FillADList;
end;


// Actions

procedure TCommonDataModule.ParseCommand(BotID: Integer; Command: String);
begin
  Logger.Log(BotID, ClassName, 'ParseCommand', 'Run', ltCall);
  if Command <> '' then
    FCommandBuffer.AddObject(Command, Pointer(BotID));

  if not ReadTimer.Enabled then
    ReadTimer.Enabled := True;
end;

procedure TCommonDataModule.ReadTimerTimer(Sender: TObject);
begin
  ReadTimer.Enabled := False;
  Logger.Log(0, ClassName, 'ReadTimerTimer', 'Started', ltCall);
  if FCommandRunned then
  begin
    Logger.Log(0, ClassName, 'ReadTimerTimer', 'Exit because FCommandRunned=True', ltError);
    Exit;
  end;

  FCommandRunned := True;
  ParseCommands;
  FCommandRunned := False;
  Logger.Log(0, ClassName, 'ReadTimerTimer', 'Finished', ltCall);
end;

procedure TCommonDataModule.ParseCommands;
var
  XMLDocument: TXMLDocument;
  XMLRoot: IXMLNode;
  curBotConnection: TBotConnection;
  curBotID: Integer;
  curCommand: String;
  ObjName: String;
begin
  Logger.Log(0, ClassName, 'ParseCommands', 'Started', ltCall);
  while FCommandBuffer.Count > 0 do
  begin
    curBotID := Integer(FCommandBuffer.Objects[0]);
    curCommand := FCommandBuffer.Strings[0];
    FCommandBuffer.Delete(0);

    if (curCommand <> '') and FindBotConnection(curBotID, curBotConnection, True) then
    try
      XMLDocument := TXMLDocument.Create(Self);
      try
        XMLDocument.XML.Text := curCommand;
        XMLDocument.Active := true;
        XMLRoot := XMLDocument.DocumentElement;
        if lowercase(XMLRoot.NodeName) = 'object' then
        begin
          ObjName := lowercase(XMLRoot.Attributes['name']);
          Logger.Log(curBotID, ClassName, 'ParseCommands',
            'Found "' + ObjName + '" object''s action', ltCall);

          // Dispatch command

          if ObjName = 'process' then
            BotForm.RunCommand(XMLRoot, curBotConnection.UserID)
          else
          if ObjName = 'lobby' then
            FLobbyModule.RunCommand(curBotConnection, XMLRoot)
          else
          if ObjName = 'conversions' then
            Conversions.RunCommand(curBotConnection, XMLRoot)
          else
{
          if ObjName = 'tournament' then
            TournamentModule.RunCommand(XMLRoot)
          else
}
            RunCommand(curBotConnection, XMLRoot);
        end
        else
          Logger.Log(curBotID, ClassName, 'ParseCommands',
            'Did not found known objects', ltError);
      finally
        XMLDocument.Active := False;
        XMLDocument.Free;
      end;
    except
      on E: Exception do
        Logger.Log(curBotID, ClassName, 'ParseCommands', E.Message, ltException);
    end;
  end;

  curCommand := '';
  ObjName    := '';

  Logger.Log(0, ClassName, 'ParseCommands', 'Finished', ltCall);
end;

function TCommonDataModule.CheckCommandResult(BotConnection: TBotConnection; XMLNode: IXMLNode): Boolean;
var
  ErrorCode: Integer;
begin
  ErrorCode := -1;
  if XMLNode <> nil then
    if XMLNode.HasAttribute('result') then
      ErrorCode := strtointdef(XMLNode.Attributes['result'], -1);
  Result := ErrorCode = 0;
  if not Result then
    Logger.Log(BotConnection.BotID, ClassName, 'CheckCommandResult',
      'Error #' + inttostr(ErrorCode), ltError);
end;

procedure TCommonDataModule.RunCommand(BotConnection: TBotConnection; XMLRoot: IXMLNode);
var
  Loop: Integer;
  XMLNode: IXMLNode;
  strNode: String;
begin
  Logger.Log(BotConnection.BotID, ClassName, 'RunCommand', 'Run', ltCall);
  try
    if XMLRoot.ChildNodes.Count > 0 then
      for Loop := 0 to XMLRoot.ChildNodes.Count - 1 do
      begin
        XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
        strNode := XMLNode.NodeName;

        if strNode = 'connect' then
          Run_Connect(BotConnection, XMLNode)
        else
        if strNode = 'message' then
          Run_Message(BotConnection, XMLNode)
        else
        if strNode = 'uologin' then
          Run_Login(BotConnection, XMLNode)
        else
        if (strNode = 'uologout') or (strNode = 'reconnect') then
          Run_Disconnect(BotConnection, XMLNode)
        else
        if strNode = 'uoregister' then
          Run_NewUser(BotConnection, XMLNode)
        else
          Logger.Log(BotConnection.BotID, ClassName, 'RunCommand',
            'Did not found known actions', ltError);
      end;
  except
    on E: Exception do
      Logger.Log(BotConnection.BotID, ClassName, 'RunCommand', E.Message, ltException);
  end;

  strNode := '';
end;

procedure TCommonDataModule.Run_Message(BotConnection: TBotConnection; XMLRoot: IXMLNode);
{
<object name="session">
  <message msg="Text"/>
</object>
}
begin
  if XMLRoot.HasAttribute('msg') then
    Logger.Log(BotConnection.BotID, ClassName, 'Run_Message',
      XMLRoot.Attributes['msg'], ltResponse);
end;

procedure TCommonDataModule.Run_Connect(BotConnection: TBotConnection; XMLRoot: IXMLNode);
{
<object name="session">
  <connect result="0|1001|..." sessionid="1" magicword="passphrase"
   reason="Error reason!!!" tournamentlimit="1"
   processlimit="2" tournamenttablelimit="2" recordhandlimit="1"
   csafileurl="http://www.poker.com/download/updates/poker.exe"
   csafilesize="1890674"/>
</object>
}
begin
  if CheckCommandResult(BotConnection, XMLRoot) then
    BotConnection.RegisteredAs(strtointdef(XMLRoot.Attributes['sessionid'], 0))
  else
    BotConnection.Disconnect;
end;

procedure TCommonDataModule.Run_Login(BotConnection: TBotConnection; XMLRoot: IXMLNode);
{
<object name="user">
  <uologin result="0|..." userid="1213" emailvalidated="0|1">
</object>
}
var
  curBot: TDataList;
begin
  if CheckCommandResult(BotConnection, XMLRoot) then
  begin
    BotConnection.LoggedAs(strtointdef(XMLRoot.Attributes['userid'], 0));
    ParserModule.Send_GetProfile(BotConnection);
    ParserModule.Send_GetStatistics(BotConnection);
    ParserModule.Send_GetBalanceInfo(BotConnection);
    ParserModule.Send_GetMailingAddress(BotConnection);
    SitBotToProcesses(BotConnection);
  end
  else
    if FBotList.Find(BotConnection.BotID, curBot) then
      ParserModule.Send_Register(BotConnection,
        curBot.ValuesAsString[BotLoginName], curBot.ValuesAsString[BotPassword],
        curBot.ValuesAsString[BotFirstName], curBot.ValuesAsString[BotLastName],
        curBot.ValuesAsString[BotEMail], curBot.ValuesAsString[BotLocation],
        curBot.ValuesAsBoolean[BotShowLocation], curBot.ValuesAsInteger[BotSexID]);
end;

procedure TCommonDataModule.Run_NewUser(BotConnection: TBotConnection; XMLRoot: IXMLNode);
{
<object name="user">
  <uoregister result="0|..." userid="1213">
</object>
}
begin
  if CheckCommandResult(BotConnection, XMLRoot) then
  begin
    BotConnection.LoggedAs(strtointdef(XMLRoot.Attributes['userid'], 0));
    ParserModule.Send_GetProfile(BotConnection);
    ParserModule.Send_GetStatistics(BotConnection);
    ParserModule.Send_GetBalanceInfo(BotConnection);
    ParserModule.Send_GetMailingAddress(BotConnection);
  end
  else
    DisconnectBot(BotConnection.BotID);
end;

// BotConnections

function TCommonDataModule.FindBotConnection(BotID: Integer;
  var BotConnection: TBotConnection; LogError: Boolean = False): Boolean;
var
  Loop: Integer;
  curBotConnection: TBotConnection;
begin
  BotConnection := nil;
  Result := False;
  for Loop := FBotConnections.Count - 1 downto 0 do
  begin
    curBotConnection := TBotConnection(FBotConnections.Items[Loop]);
    if curBotConnection.BotID = BotID then
    begin
      BotConnection := curBotConnection;
      Result := True;
      Exit;
    end;
  end;
  if LogError then
    Logger.Log(BotID, ClassName, 'FindBotConnection', 'Did not found', ltError);
end;

function TCommonDataModule.FindBotConnectionByUserID(UserID: Integer;
  var BotConnection: TBotConnection; LogError: Boolean): Boolean;
var
  Loop: Integer;
  curBotConnection: TBotConnection;
begin
  BotConnection := nil;
  Result := False;
  for Loop := FBotConnections.Count - 1 downto 0 do
  begin
    curBotConnection := TBotConnection(FBotConnections.Items[Loop]);
    if curBotConnection.UserID = UserID then
    begin
      BotConnection := curBotConnection;
      Result := True;
      Exit;
    end;
  end;
  if LogError then
    Logger.Log(UserID, ClassName, 'FindBotConnectionByUserID', 'Did not found', ltError);
end;

function TCommonDataModule.ConnectBot(BotID: Integer): TBotConnection;
var
  curBot: TDataList;
begin
  if BotList.Find(BotID, curBot) then
    if not FindBotConnection(BotID, Result) then
    begin
      Result := TBotConnection.Create(BotID, curBot.ValuesAsString[BotLoginName]);
      FBotConnections.Add(Result);
    end;
end;

function TCommonDataModule.ReconnectBot(BotID: Integer): TBotConnection;
var
  curBot: TDataList;
begin
  if BotList.Find(BotID, curBot) then
    if FindBotConnection(BotID, Result) then
      Result.Disconnect;
end;

procedure TCommonDataModule.DisconnectBot(BotID: Integer);
var
  curBotConnection: TBotConnection;
begin
  if FindBotConnection(BotID, curBotConnection, True) then
    FBotConnections.Remove(curBotConnection);
  if FBotConnections.Count = 0 then
end;

procedure TCommonDataModule.CheckBotConnections;
var
  Loop: Integer;
  curBotConnection: TBotConnection;
  maxNewConnections: Integer;
  KeepConnected: Boolean;
  ConnectingCount: Integer;
  curBot: TDataList;
  TimeInterval: Integer;
  CurrentTime: Integer;
begin
  ConnectingCount := 0;
  KeepConnected := FSessionSettings.ValuesAsBoolean[BotKeepConnected];
  maxNewConnections := FSessionSettings.ValuesAsInteger[BotNewConnectionsPerSecond];

  TimeInterval := -1;
  if FSessionSettings.ValuesAsBoolean[BotEmulateLobby] then
  begin
    if FSessionSettings.ValuesAsInteger[BotEmulateLobbyType] = 0 then
      TimeInterval := UpdateInfoTimeSec
    else
      TimeInterval := UpdateInfoTimeSec * 10;
  end;

  for Loop := 0 to FBotConnections.Count - 1 do
    if TBotConnection(FBotConnections.Items[Loop]).ConnectionState = csConnecting then
      Inc(ConnectingCount);

  for Loop := 0 to FBotConnections.Count - 1 do
  begin
    curBotConnection := TBotConnection(FBotConnections.Items[Loop]);
    if (curBotConnection.ConnectionState = csNone) or
      ((curBotConnection.ConnectionState = csDisconnected) and KeepConnected) then
      begin
        if ConnectingCount <= maxNewConnections then
        begin
          curBotConnection.Connect;
          Inc(ConnectingCount);
        end;
      end
    else
    if curBotConnection.ConnectionState = csWaiting then
      curBotConnection.Wait
    else
    if curBotConnection.ConnectionState = csConnected then
      ParserModule.Send_Connect(curBotConnection)
    else
    if curBotConnection.ConnectionState = csRegistered then
    begin
      if FBotList.Find(curBotConnection.BotID, curBot) then
        ParserModule.Send_Login(curBotConnection,
          curBot.ValuesAsString[BotLoginName], curBot.ValuesAsString[BotPassword])
    end
    else
    if (curBotConnection.ConnectionState <> csTerminating) and
      (curBotConnection.ConnectionState <> csDisconnected) and
      (curBotConnection.ConnectionState <> csConnecting) then
      begin
        curBotConnection.Ping;
        if TimeInterval >=0 then
        begin
          CurrentTime := SecondsBetween(Now, curBotConnection.LastUpdateTime) - TimeInterval;
          if (CurrentTime >= (TimeInterval div 2)) or
            ((CurrentTime >= 0) and ((curBotConnection.BotID mod TimeInterval) = CurrentTime)) then
            begin
              FLobbyModule.Do_Refresh(curBotConnection);
              curBotConnection.LastUpdateTime := Now;
            end;
        end;
      end;
  end;
end;


// Bot Generation

procedure TCommonDataModule.GenerateBotsByMask(OnGenerationProgress: TGenerationProgressEvent);
{
LoginName, Password, FirstName, LastName, EMail, Location: String;
ShowLocation, EMailAlerts, BuddyAlerts: Boolean;
AvatarID, SexID: Integer;
}

var
  Loop: Integer;
  curBot: TDataList;
  curBotCount: Integer;
  curBotName: String;
  curBotLoginName: String;
  curBotEmail: String;
  curBotPassword: String;
  curBotLocation: String;
  curBotPrivateLocation: Boolean;
  curBotMale: Boolean;
  curBotIdentity: Integer;
begin
  curBotName := FSessionSettings.ValuesAsString[BotGenerationName];
  curBotPassword := FSessionSettings.ValuesAsString[BotGenerationPassword];
  curBotLocation := FSessionSettings.ValuesAsString[BotGenerationLocation];
  curBotCount := FSessionSettings.ValuesAsInteger[BotGenerationCount];
  curBotPrivateLocation := FSessionSettings.ValuesAsBoolean[BotGenerationPrivate];
  curBotMale := FSessionSettings.ValuesAsBoolean[BotGenerationMale];
  curBotIdentity := FBotList.ValuesAsInteger[BotLastIdentity];

  Logger.Log(0, ClassName, 'GenerateBotsByMask',
    'Name: ' + curBotName + ', Count: ' + inttostr(curBotCount), ltCall);

  for Loop := 1 to curBotCount do
  begin
    curBotLoginName := curBotName + inttostr(Loop);
    curBotEmail := curBotLoginName + '@' + curBotLocation + '.bots-mail.com';
    if CheckBotListForDublicates(curBotName, curBotEmail) then
    begin
      curBot := FBotList.Add(curBotIdentity);
      Inc(curBotIdentity);
      curBot.ValuesAsString[BotLoginName] := curBotLoginName;
      curBot.ValuesAsString[BotPassword] := curBotPassword;
      curBot.ValuesAsString[BotFirstName] := curBotLoginName;
      curBot.ValuesAsString[BotLastName] := curBotLoginName;
      curBot.ValuesAsString[BotEMail] := curBotEmail;
      curBot.ValuesAsString[BotLocation] := curBotLocation;
      curBot.ValuesAsBoolean[BotShowLocation] := curBotPrivateLocation;
      curBot.ValuesAsBoolean[BotEMailAlerts] := False;
      curBot.ValuesAsBoolean[BotBuddyAlerts] := False;
      if curBotMale then
      begin
        curBot.ValuesAsInteger[BotAvatarID] := 1;
        curBot.ValuesAsInteger[BotSexID] := 1;
      end
      else
      begin
        curBot.ValuesAsInteger[BotAvatarID] := 2;
        curBot.ValuesAsInteger[BotSexID] := 2;
      end;
    end;
    if Assigned(OnGenerationProgress) then
      OnGenerationProgress((100*Loop) div curBotCount);
  end;
  FBotList.ValuesAsInteger[BotLastIdentity] := curBotIdentity;
  FBotList.SaveToFile(FAppPath + BotListFileName, 'BotList');
  SaveToRegistry;
  if Assigned(FOnBotListUpdate) then
    FOnBotListUpdate;

  curBotName      := '';
  curBotLoginName := '';
  curBotEmail     := '';
  curBotPassword  := '';
  curBotLocation  := '';
end;

procedure TCommonDataModule.GenerateBotsFromFile(OnGenerationProgress: TGenerationProgressEvent;
  FileName: String);
var
  NewRobots: TDataList;
  BotIdentity: Integer;
  Loop: Integer;
  curBot: TDataList;
begin
  if FileExists(FileName) then
  begin
    Logger.Log(0, ClassName, 'GenerateBotsFromFile', FileName, ltCall);
    NewRobots := TDataList.Create(0, nil);
    NewRobots.LoadFromFile(FileName);

    BotIdentity := FBotList.ValuesAsInteger[BotLastIdentity];
    for Loop := 0 to NewRobots.Count - 1 do
    begin
      curBot := NewRobots.Items(Loop);
      if CheckBotListForDublicates(curBot.ValuesAsString[BotLoginName],
        curBot.ValuesAsString[BotEMail]) then
      begin
        FBotList.Clone(curBot, BotIdentity);
        Inc(BotIdentity);
      end;
      if Assigned(OnGenerationProgress) then
        OnGenerationProgress((100*(Loop + 1)) div NewRobots.Count);
    end;

    FBotList.ValuesAsInteger[BotLastIdentity] := BotIdentity;
    FBotList.SaveToFile(FAppPath + BotListFileName, 'BotList');
    NewRobots.Free;
    if Assigned(FOnBotListUpdate) then
      FOnBotListUpdate;
  end;
end;

function TCommonDataModule.CheckBotListForDublicates(LoginName, EMail: String): Boolean;
// Check on LoginName or EMail
var
  Loop: Integer;
  curBot: TDataList;
  strLoginName: String;
  strEMail: String;
begin
  Result := True;
  strLoginName := lowercase(LoginName);
  strEMail := lowercase(EMail);
  for Loop := 0 to FBotList.Count - 1 do
  begin
    curBot := FBotList.Items(Loop);
    if (lowercase(curBot.ValuesAsString[BotLoginName]) = strLoginName) or
      (lowercase(curBot.ValuesAsString[BotEMail]) = strEMail) then
    begin
      Result := False;
      Break;
    end;
  end;

  strLoginName := '';
  strEMail     := '';
end;


// Bot Connections
{
  TConnectionState = (csNone, csTerminating, csConnecting, csConnected, csDisconnected,
    csRegistering, csRegistered, csLogging, csLogged);
}

function TCommonDataModule.BotsDisconnected: Integer;

var
  Loop: Integer;
  curBotConnection: TBotConnection;
begin
  Result := 0;
  for Loop := 0 to FBotConnections.Count - 1 do
  begin
    curBotConnection := TBotConnection(FBotConnections.Items[Loop]);
    if (curBotConnection.ConnectionState = csNone) or
      (curBotConnection.ConnectionState = csTerminating) or
      (curBotConnection.ConnectionState = csConnecting) or
      (curBotConnection.ConnectionState = csDisconnected) then
      Inc(Result);
  end;
end;

function TCommonDataModule.BotsConnected: Integer;
var
  Loop: Integer;
  curBotConnection: TBotConnection;
begin
  Result := 0;
  for Loop := 0 to FBotConnections.Count - 1 do
  begin
    curBotConnection := TBotConnection(FBotConnections.Items[Loop]);
    if (curBotConnection.ConnectionState = csConnected) or
      (curBotConnection.ConnectionState = csRegistering) or
      (curBotConnection.ConnectionState = csRegistered) or
      (curBotConnection.ConnectionState = csLogging) or
      (curBotConnection.ConnectionState = csLogged) then
      Inc(Result);
  end;
end;

function TCommonDataModule.BotsRegistered: Integer;
var
  Loop: Integer;
  curBotConnection: TBotConnection;
begin
  Result := 0;
  for Loop := 0 to FBotConnections.Count - 1 do
  begin
    curBotConnection := TBotConnection(FBotConnections.Items[Loop]);
    if (curBotConnection.ConnectionState = csRegistered) or
      (curBotConnection.ConnectionState = csLogging) or
      (curBotConnection.ConnectionState = csLogged) then
      Inc(Result);
  end;
end;

function TCommonDataModule.BotsLogged: Integer;
var
  Loop: Integer;
  curBotConnection: TBotConnection;
begin
  Result := 0;
  for Loop := 0 to FBotConnections.Count - 1 do
  begin
    curBotConnection := TBotConnection(FBotConnections.Items[Loop]);
    if curBotConnection.ConnectionState = csLogged then
      Inc(Result);
  end;
end;

procedure TCommonDataModule.BotsSummary(var ConnectedCount,
  DisconnectedCount, RegisteredCount, LoggedCount: Integer);
var
  Loop: Integer;
  curBotConnection: TBotConnection;
begin
  ConnectedCount := 0;
  RegisteredCount := 0;
  LoggedCount := 0;

  for Loop := 0 to FBotConnections.Count - 1 do
  begin
    curBotConnection := TBotConnection(FBotConnections.Items[Loop]);
    if (curBotConnection.ConnectionState = csConnected) or
      (curBotConnection.ConnectionState = csRegistering) then
    begin
      Inc(ConnectedCount);
    end;

    if (curBotConnection.ConnectionState = csRegistered) or
      (curBotConnection.ConnectionState = csLogging) then
    begin
      Inc(ConnectedCount);
      Inc(RegisteredCount);
    end;

    if curBotConnection.ConnectionState = csLogged then
    begin
      Inc(ConnectedCount);
      Inc(RegisteredCount);
      Inc(LoggedCount);
    end;
  end;

  DisconnectedCount := FBotConnections.Count - ConnectedCount;
end;


// Refresh

procedure TCommonDataModule.RefreshAll;
var
  curBotConnection: TBotConnection;
  Loop: Integer;
begin
  // Refresh timer interval
  RefreshTimer.Enabled := False;
  RefreshTimer.Interval := 1000 * FSessionSettings.ValuesAsInteger[BotRefreshInterval];

  AutoJoinBotsToProcesses;

  RefreshTimer.Enabled := True;

  // Refresh references
  if FBotConnections.Count > 0 then
  begin
    curBotConnection := TBotConnection(FBotConnections.Items[RandomRange(0, FBotConnections.Count - 1)]);
    if curBotConnection.ConnectionState = csLogged then
    begin
      if LobbyModule.CurrentProcesses = nil then
      begin
        ParserModule.Send_GetReferences(curBotConnection);
        FLobbyModule.Do_Refresh(curBotConnection);
      end
      else
      begin
        FLobbyModule.Do_Refresh(curBotConnection);
        if CommonDataModule.SessionSettings.ValuesAsBoolean[BotRestrictByNames] then
          for Loop := 0 to LobbyModule.CurrentProcesses.Count - 1 do
            ParserModule.Send_GetProcessInfo(curBotConnection,
              LobbyModule.CurrentProcesses.Items(Loop).ID);
      end;
    end;
  end;

  if Assigned(FOnBotConnectedUpdate) then
    FOnBotConnectedUpdate;
end;

procedure TCommonDataModule.RefreshTimerTimer(Sender: TObject);
var
  Loop: Integer;
  Loop2: Integer;
  strBotList: String;
  strBotProcessList: String;
  curBotConnection: TBotConnection;
begin
  RefreshAll;

  if MinutesBetween(Now, FStartTime) > CommonDataModule.SessionSettings.ValuesAsInteger[BotMaximumWorkTime] then
  begin
    SaveToRegistry;
    if CommonDataModule.SessionSettings.ValuesAsBoolean[BotStopAfterMaximumWorkTime] then
    begin
      if CommonDataModule.SessionSettings.ValuesAsBoolean[BotRestartAfterMaximumWorkTime] then
      begin
        strBotList := '';
        for Loop := 0 to FBotConnections.Count - 1 do
        begin
          curBotConnection := TBotConnection(FBotConnections.Items[Loop]);
          if strBotList <> '' then
            strBotList := strBotList + ',';
          strBotProcessList := '';
          for Loop2 := 0 to curBotConnection.ProcessIDs.Count - 1 do
            strBotProcessList := strBotProcessList + ':' +
              inttostr(Integer(curBotConnection.ProcessIDs.Items[Loop2]));
          strBotList := strBotList + inttostr(curBotConnection.BotID) + strBotProcessList;
        end;
        ShellExecute(0, pchar('open'), pchar(FAppPath + AppFileName), pchar(strBotList), pchar(FAppPath), SW_HIDE);
      end;

      FApplicationTerminationAllowed := True;
      Application.Terminate;
    end;
  end;
end;


// Bot Actions

procedure TCommonDataModule.JoinBotToProcess(BotID, ProcessID: Integer; ProcessName: String);
var
  curBotConnection: TBotConnection;
begin
  if FindBotConnection(BotID, curBotConnection, True) then
  begin
    BotForm.BotEntry(ProcessName,  curBotConnection.BotName, ProcessID, curBotConnection.UserID);
    curBotConnection.JoinToProcess(ProcessID);

    Logger.Log(BotID, ClassName, 'JoinnBotToProcess',
      'Bot has been Joined to process: ' + inttostr(ProcessID), ltCall);
  end;
end;

procedure TCommonDataModule.BotProcessorResponse(UserID, ProcessId: Integer; sResponse: string; aResponseType: TFixAction);
var
  curBotConnection: TBotConnection;
  ActionNode: String;
begin
  Logger.Log(UserID, ClassName, 'BotProcessorResponse',
    'Command was resived from BotProcessor: Params: UserID=' + IntToStr(UserID) + '; Command=[' + sResponse + ']',
    ltCall
  );
  if (UserID > 0) and (sResponse <> '') then
    if FindBotConnectionByUserID(UserID, curBotConnection, True) then
    begin
      if aResponseType = ACT_LEAVETABLE then curBotConnection.LeaveTable(ProcessId);

      ActionNode := sResponse;
      if lowercase(Copy(sResponse, 1, 10)) = '<gaaction ' then
      begin
        ActionNode := '<gaaction userid="' + inttostr(UserID) +
          '" sessionid="' + inttostr(curBotConnection.SessionID) + '" ' +
          Copy(sResponse, 11, MAXINT);
      end;

      if CommonDataModule.SessionSettings.ValuesAsBoolean[BotUseHeaders] then
        curBotConnection.SendCommand('%' + inttostr(ProcessID) + ',0*' +
        ActionNode)
      else
        curBotConnection.SendCommand('<objects><object name="gameadapter">' +
           ActionNode + '</object></objects>');
    end;
end;


procedure TCommonDataModule.ConnectionsTimerTimer(Sender: TObject);
begin
  ConnectionsTimer.Enabled := False;
  CheckBotConnections;
  ConnectionsTimer.Enabled := True;
end;

procedure TCommonDataModule.GetFirstEmptyTable(var ProcessID, CountJoinedBots: Integer;
  var ProcessName: string);
var
  Loop, Loop2, curADID: Integer;
  curProcess: TDataList;
  ADIDSupported: Boolean;
  curPlayers: Integer;
  curExtBots, curBots, curNeededBots: Integer;
  MaximumPlayers: Integer;
begin
  ProcessID := 0;
  CountJoinedBots := 0;
  ProcessName := '';
  if (FLobbyModule.CurrentProcesses = nil) then Exit;
  MaximumPlayers := CommonDataModule.SessionSettings.ValuesAsInteger[BotAutoSitGamers];
  curNeededBots := CommonDataModule.SessionSettings.ValuesAsInteger[BotAutoSitCount];

  for Loop:=0 to FLobbyModule.CurrentProcesses.Count - 1 do
  begin
    curProcess := FLobbyModule.CurrentProcesses.Items(Loop);
    curADID := curProcess.ValuesAsInteger[XMLNODENAME_ACTIONDISPATCHERID];
    ADIDSupported := Length(FSupportedADList) = 0;
    if not ADIDSupported then
      for Loop2 := 0 to Length(FSupportedADList) - 1 do
        if curADID = FSupportedADList[Loop] then
          ADIDSupported := True;

    curPlayers := curProcess.ValuesAsInteger[inttostr(StatID_PlayersCount)];
    if ADIDSupported and (curPlayers <= 10) then
    begin
      curBots := CountJoinedBotsToProcess(curProcess.ID);
      curExtBots := curProcess.ValuesAsInteger[XMLNODENAME_BOTSCOUNT];
      if curExtBots > curBots then
        curBots := curExtBots;
      if (curPlayers - curBots <= MaximumPlayers) and (curBots < curNeededBots) then
      begin
        ProcessID := curProcess.ID;
        CountJoinedBots := curBots;
        ProcessName := curProcess.Name;
        Exit;
      end;
    end;
  end;
end;

function TCommonDataModule.GetFirstNotJoinedBotID(ProcessID: Integer): Integer;
var
  Loop: Integer;
  MinCount: Integer;
  curBotConnection: TBotConnection;
begin
  Result := -1;
  if FBotConnections.Count < 1 then
    Exit;

  if CommonDataModule.SessionSettings.ValuesAsBoolean[BotAllowManyTables] then
  begin
    if FBotConnections.Count = 1 then
    begin
      curBotConnection := TBotConnection(FBotConnections.Items[0]);
      if curBotConnection.ProcessIDs.IndexOf(Pointer(ProcessID)) < 0 then
        Result := curBotConnection.BotID;
      Exit;
    end;

    curBotConnection := TBotConnection(FBotConnections.Items[0]);
    Result := curBotConnection.BotID;
    MinCount := curBotConnection.ProcessIDs.Count;
    if MinCount = 0 then
      Exit;

    for Loop := 1 to FBotConnections.Count - 1 do
    begin
      curBotConnection := TBotConnection(FBotConnections.Items[Loop]);
      if curBotConnection.ProcessIDs.Count = 0 then
      begin
        Result := curBotConnection.BotID;
        Exit;
      end;

      if (curBotConnection.ProcessIDs.IndexOf(Pointer(ProcessID)) < 0) and
        (curBotConnection.ProcessIDs.Count < MinCount) then
      begin
        Result := curBotConnection.BotID;
        MinCount := curBotConnection.ProcessIDs.Count;
      end;
    end;
  end
  else
  for Loop:=0 to FBotConnections.Count - 1 do
  begin
    curBotConnection := TBotConnection(FBotConnections.Items[Loop]);
    if (curBotConnection.UserID > 0) and (curBotConnection.ProcessIDs.Count = 0) then
    begin
      Result := curBotConnection.BotID;
      Exit;
    end
  end;
end;

procedure TCommonDataModule.AutoJoinBotsToProcesses;
var
  ProcessID, BotID, CntNotJoinedBots, CntJoinedBotsToProcess, IterCount: Integer;
  ProcessName: string;
begin
  if (FBotConnections.Count <= 0) then Exit;

  IterCount := 0;
  repeat
    CntNotJoinedBots := CountNotJoinedBots;
    if (CntNotJoinedBots < 1) then
      Exit;

    GetFirstEmptyTable(ProcessID, CntJoinedBotsToProcess, ProcessName);
    if (ProcessID <= 0) then
      Exit;

    // join bots
    BotID := GetFirstNotJoinedBotID(ProcessID);
    if BotID >= 0 then
      JoinBotToProcess(BotID, ProcessID, ProcessName);

    Inc(IterCount);
  until (IterCount > 10);

  ProcessName := '';
end;

function TCommonDataModule.CountJoinedBotsToProcess(ProcessID: Integer): Integer;
var
  Loop: Integer;
  curBotConnection: TBotConnection;
begin
  Result := 0;
  for Loop := 0 to FBotConnections.Count - 1 do
  begin
    curBotConnection := TBotConnection(FBotConnections.Items[Loop]);

    if curBotConnection.ProcessIDs.IndexOf(Pointer(ProcessID)) >= 0 then
      Inc(Result);
  end;
end;

function TCommonDataModule.GetCountNotJoinedBots: Integer;
var
  Loop: Integer;
  curBotConnection: TBotConnection;
begin
  Result := 0;
  if CommonDataModule.SessionSettings.ValuesAsBoolean[BotAllowManyTables] then
    Result := FBotConnections.Count
  else
  for Loop:=0 to FBotConnections.Count - 1 do
  begin
    curBotConnection := TBotConnection(FBotConnections.Items[Loop]);

    if (curBotConnection.UserID > 0) and (curBotConnection.ProcessIDs.Count = 0) then
      Inc(Result);
  end;
end;

procedure TCommonDataModule.Run_Disconnect(BotConnection: TBotConnection;
  XMLRoot: IXMLNode);
begin
  BotConnection.Disconnect;
end;

procedure TCommonDataModule.ConnectBots(BotIDs: String);
var
  Loop: Integer;
  Loop2: Integer;
  strBotList: TStringList;
  strBotProcessList: TStringList;
  curBotConnection: TBotConnection;
  curID: Integer;
begin
  strBotList := TStringList.Create;
  strBotProcessList := TStringList.Create;
  strBotList.Text := StringReplace(BotIDs, ',', #13#10, [rfReplaceAll, rfIgnoreCase]);
  for Loop := 0 to strBotList.Count - 1 do
  begin
    strBotProcessList.Text := StringReplace(strBotList.Strings[Loop], ':', #13#10, [rfReplaceAll, rfIgnoreCase]);
    if strBotProcessList.Count > 0 then
    begin
      curID := strtointdef(strBotProcessList.Strings[0], 0);
      if curID > 0 then
      begin
        curBotConnection := ConnectBot(curID);
        if strBotProcessList.Count > 1 then
          for Loop2 := 1 to strBotProcessList.Count - 1 do
          begin
            curID := strtointdef(strBotProcessList.Strings[Loop2], 0);
            if curID > 0 then
              curBotConnection.ProcessIDs.Add(Pointer(curID));
          end;
      end;
    end;
  end;
  strBotProcessList.Free;
  strBotList.Free;
end;

procedure TCommonDataModule.SitBotToProcesses(BotConnection: TBotConnection);
var
  Loop: Integer;
begin
  for Loop := 0 to BotConnection.ProcessIDs.Count - 1 do
    JoinBotToProcess(BotConnection.BotID, Integer(BotConnection.ProcessIDs.Items[Loop]),
      'Process #' + inttostr(Integer(BotConnection.ProcessIDs.Items[Loop])));
end;

procedure TCommonDataModule.FillADList;
var
  Loop: Integer;
  strADList: TStringList;
  RealCount: Integer;
  ADID: Integer;
begin
  strADList := TStringList.Create;
  strADList.Text := StringReplace(FSessionSettings.ValuesAsString[BotActionDispatcherIDList],
    ',', #13#10, [rfReplaceAll, rfIgnoreCase]);
  SetLength(FSupportedADList, strADList.Count);

  RealCount := 0;
  for Loop := 0 to strADList.Count - 1 do
  begin
    ADID := strtointdef(strADList.Strings[Loop], 0);
    if ADID > 0 then
    begin
      FSupportedADList[RealCount] := ADID;
      Inc(RealCount);
    end;
  end;
  SetLength(FSupportedADList, RealCount);
  strADList.Free;
end;

end.

