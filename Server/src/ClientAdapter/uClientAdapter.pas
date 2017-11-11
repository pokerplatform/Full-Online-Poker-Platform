unit uClientAdapter;

interface

uses
  SysUtils, Classes, ExtCtrls, Forms, ActiveX, WinSock, DateUtils,
  Windows, Messages, Graphics, Controls, SvcMgr, Dialogs,
  xmldom, XMLIntf, msxmldom, XMLDoc, Variants, SyncObjs,
  uSessionServer, uSessionProcessor, uSettings, uLocker;

const
  cntRefreshInterval_Sec = 1000;
  LogConnectionsCount_Sec = 1000;

type
  TClientAdapter = class
  private
    FLast_LogConnectionsCount: TDateTime;
    FPreviousConnectionStatus: Integer;
    FConnectClientCounter: Integer;
    FDisconnectClientCounter: Integer;
    FSessionServer: TSessionServer;

    FLastRefreshTime: TDateTime;
    FTournamentLimit: String;
    FProcessLimit: String;
    FTournamentTableLimit: String;
    FRecordHandLimit: String;
    FNearestPlayPeriod: String;
    FUpdateRandomFactor: Integer;
    FRealMoneyTablesMessage: String;
    FLoginUserURL:String;
    FRegisterUserURL:String;
    FFindUserProfileURL:String;

    FPrevCSAID: Integer;
    FPrevAffiliateId: Integer;
    FPrevSize: String;
    FPrevUrl: String;
    FPrevBuild: Integer;
    FPrevSaveTime: TDateTime;
    FPrevCriticalSection: TLocker;

    procedure OnServerOpened(ASessionProcessor: TSessionProcessor; var ASessionID: Integer);
    procedure OnServerClosed(ASessionProcessor: TSessionProcessor);
    procedure OnServerCommand(ASessionProcessor: TSessionProcessor; const ACommand: String);

    procedure DoNewUserConnect(ASessionProcessor: TSessionProcessor; ConnectXML: String);
    procedure GetPlayerList(ASessionProcessor: TSessionProcessor; ConnectXML: String);
    procedure DoProcessAction(SessionID: Integer; const ActionXML: String);
    procedure DoNotify(ActionXML: IXMLNode);
    procedure DoNotifyAll(ActionXML: IXMLNode);
    procedure DoMainChat(ActionXML: IXMLNode);
    procedure DoPrivateChatBuddiListAction(ActionXML: IXMLNode);
    procedure DoPrivateChatMessaging(ActionXML: IXMLNode);
    function  GetLogoutPacket: String;
    procedure SendToAll(const ActionText: String);
    procedure ClearClientSessions;
    function  GetPlayPeriodConclusionPacket: String;
    function  GetReconnectPacket: String;
    procedure RefreshClientSessionOptions;
    procedure UpdateBuddyList(UserID: Integer);

  public
    procedure ProcessAction(ActionXML: IXMLNode);
    procedure NotifyClient(SessionID: Integer; Data: String; var Handled: Boolean);
    procedure NotifyClients(SessionIDs: array of Integer; Data: String);
    procedure RingUp;

    procedure Pause;
    procedure Continue;

    constructor Create;
    destructor Destroy; override;
  end;


implementation

uses
  uCommonDataModule, uLogger, uSQLAdapter, uXMLConstants, uErrorConstants,
  uSQLTools, DB, Math;


constructor TClientAdapter.Create;
begin
  inherited;

  try
    // Create and Initialize FSessionServer
    FSessionServer := TSessionServer.Create(100, 3,
      CommonDataModule.ClientAdapterSSL,
      CommonDataModule.ClientAdapterPort,
      OnServerOpened, OnServerClosed, OnServerCommand);

    CommonDataModule.Log(ClassName, 'Create',
      'Server started on ' + CommonDataModule.LocalHost + ':' +
      inttostr(CommonDataModule.ClientAdapterPort), ltBase);

    // Clear client sessions
    FConnectClientCounter := 0;
    FDisconnectClientCounter := 0;
    ClearClientSessions;
    FLast_LogConnectionsCount := Now - 1;
    FPreviousConnectionStatus := CommonDataModule.ClientConnectionsAllowedStatus;

    FTournamentLimit := '1';
    FProcessLimit := '1';
    FTournamentTableLimit := '1';
    FRecordHandLimit := '1';
    FNearestPlayPeriod := '1';
    FUpdateRandomFactor := 0;
    FRealMoneyTablesMessage := '';
    FLoginUserURL := '';
    FRegisterUserURL := '';
    FFindUserProfileURL := '';
    FLastRefreshTime := Now;
    RefreshClientSessionOptions;

    FPrevCSAID := 0;
    FPrevAffiliateId := 0;
    FPrevSize := '';
    FPrevUrl := '';
    FPrevBuild := 0;
    FPrevSaveTime := Now;
    FPrevCriticalSection := CommonDataModule.ThreadLockHost.Add('clientadapter');

    Randomize;

    CommonDataModule.Log(ClassName, 'Create', 'Created successfully', ltBase);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Create',E.Message, ltException);
  end;
end;

destructor TClientAdapter.Destroy;
begin
  FLast_LogConnectionsCount := Now - 1;

  try
    // Clear client sessions
    ClearClientSessions;
    FSessionServer.Free;
    CommonDataModule.ThreadLockHost.Del(FPrevCriticalSection);
    CommonDataModule.Log(ClassName, 'Destroy', 'Destroyed successfully', ltBase);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Destroy', E.Message, ltException);
  end;

  inherited;
end;

procedure TClientAdapter.ClearClientSessions;
var
  SqlAdapter: TSQLAdapter;
begin
  SqlAdapter := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    SqlAdapter.Execute('exec caDisconnectPlayers ''' +
      CommonDataModule.LocalIP + ':' + inttostr(CommonDataModule.ClientAdapterPort) + '''');
  except
    on e: Exception do
      CommonDataModule.Log(ClassName, 'ClearClientSessions',
        '[EXCEPTION] On exec caDisconnectPlayers "' + CommonDataModule.LocalIP + ':' +
        inttostr(CommonDataModule.ClientAdapterPort) + '": Message=' + e.Message,
        ltException);
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdapter);
  CommonDataModule.Log(ClassName, 'ClearClientSessions',
    'Client sessions for host "' + CommonDataModule.LocalIP
     + ':' + inttostr(CommonDataModule.ClientAdapterPort) + '" were deleted.', ltBase);
end;

// Secure Socket events

procedure TClientAdapter.OnServerOpened(ASessionProcessor: TSessionProcessor; var ASessionID: Integer);
var
  SqlAdapter: TSQLAdapter;
begin
  // registering new session
  try
    SqlAdapter := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      SqlAdapter.SetProcName('caRegisterSession');
      SqlAdapter.AddParam('RETURN_VALUE', 0, ptResult, ftInteger );
      SqlAdapter.AddParam('ClientAdapterIP',
        CommonDataModule.LocalIP + ':' + inttostr(CommonDataModule.ClientAdapterPort),
        ptInput, ftString );
      SqlAdapter.AddParam('ClientIP', ASessionProcessor.RemoteHost, ptInput, ftString );
      SqlAdapter.ExecuteCommand();

      // getting new session id
      ASessionID := SqlAdapter.GetParam('RETURN_VALUE');
    finally
      CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdapter);
    end;
  except
    on e: Exception do
    begin
      CommonDataModule.Log(ClassName, 'OnServerOpened',
        '[EXCEPTION] On exec caRegisterSession for ' +
        ASessionProcessor.RemoteHost + '": Message=' + e.Message,
        ltException);
      ASessionProcessor.Stop;
    end;
  end;

  // Notify ActionDispatcher
  CommonDataModule.SendToAllServers(
    '<objects><object name="' + OBJ_ACTIONDISP + '" sendtoall="1">' +
    '<' + AD_ClientConnect + ' ' +
    PO_ATTRSESSIONID + '="' + inttostr(ASessionProcessor.SessionId) + '"/>' +
    '</object></objects>');

  if CommonDataModule.Logging then
    CommonDataModule.Log(ClassName, 'OnServerOpened',
      'IP=' + ASessionProcessor.RemoteHost + ', SessionID=' + inttostr(ASessionProcessor.SessionId), ltCall);

  InterlockedIncrement(FConnectClientCounter);
end;

procedure TClientAdapter.OnServerClosed(ASessionProcessor: TSessionProcessor);
var
  SqlAdapter    : TSQLAdapter;
begin
  if CommonDataModule.Connected then
  begin
    // Notify game adapter about user disconnection
    CommonDataModule.ProcessAction(
      '<objects><object name="' + OBJ_API + '"><apdisconnect sessionid="' +
      inttostr(ASessionProcessor.SessionId) + '"/></object></objects>');

    // Notify ActionDispatcher
    CommonDataModule.SendToAllServers(
      '<objects><object name="' + OBJ_ACTIONDISP + '" sendtoall="1">' +
      '<' + AD_ClientDisconnect + ' ' + PO_ATTRSESSIONID + '="' +
      inttostr(ASessionProcessor.SessionId) + '"/>' +
      '</object></objects>');
  end;

  // removing client registration
  try
    SqlAdapter := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      SqlAdapter.SetProcName('caUnRegisterSession');
      SqlAdapter.AddParam('RETURN_VALUE',0,ptResult,ftInteger);
      SqlAdapter.AddParam('SessionID', ASessionProcessor.SessionId, ptInput, ftInteger);
      SqlAdapter.ExecuteCommand;
    finally
      CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdapter);
    end;
  except
    on e: Exception do
      CommonDataModule.Log(ClassName, 'ASessionProcessorDisconnect',
        '[EXCEPTION] On exec caUnRegisterSession "' + IntToStr(ASessionProcessor.SessionId) + '"' +
        ': Message=' + e.Message, ltException);
  end;

  if CommonDataModule.Logging then
    CommonDataModule.Log(ClassName, 'ASessionProcessorDisconnect',
      'SessionID=' + IntToStr(ASessionProcessor.SessionId) +
      ' (' + ASessionProcessor.RemoteHost + ') disconnected.', ltCall);

  InterlockedIncrement(FDisconnectClientCounter);
end;

procedure TClientAdapter.OnServerCommand(ASessionProcessor: TSessionProcessor;
  const ACommand: String);
var
  EndPos: Integer;
  DestinationList: TStringList;
begin
  if CommonDataModule.Logging then
    CommonDataModule.Log(ClassName, 'TCPSocketServerCommand',
      'Received (SessionID=' + IntToStr(ASessionProcessor.SessionID) +
      ', ' + ASessionProcessor.RemoteHost + '):' + ACommand, ltCall);

  // Detecting command type
  if ACommand[1] = cntHeaderGameAdapterSignature then
  begin
    EndPos := Pos(cntHeaderEndSignature, ACommand);
    DestinationList := TStringList.Create;
    DestinationList.Text := StringReplace(copy(ACommand, 2, EndPos - 2),
      ',', #13#10, [rfReplaceAll, rfIgnoreCase]);
    if DestinationList.Count = 2 then
      CommonDataModule.DispatchGameAction(strtointdef(DestinationList.Strings[0], 0),
        strtointdef(DestinationList.Strings[1], 0), copy(ACommand, EndPos + 1, MAXINT))
    else
      CommonDataModule.Log(ClassName, 'OnServerCommand', 'Error on parsing game action', ltError);
    DestinationList.Free;
  end
  else
  if lowercase(copy(ACommand, 1, 8)) = '<connect' then
    DoNewUserConnect(ASessionProcessor, ACommand)
  else
  if lowercase(copy(ACommand, 1, 14)) = '<getplayerlist' then
    GetPlayerList(ASessionProcessor, ACommand)
  else
    DoProcessAction(ASessionProcessor.SessionID, ACommand);
end;


// New user connect event

procedure TClientAdapter.DoNewUserConnect(
  ASessionProcessor: TSessionProcessor; ConnectXML: String);
var
  XMLDoc: IXMLDocument;
  CSAID: Integer;
  CSABuild: Integer;
  CurrentBuild: Integer;
  DownloadURL: String;
  DownloadSize: String;
  MACAddress: String;
  InternalClientIP: String;
  InternalClientHost: String;
  AffiliateId: Integer;
  AdvertisementId: Integer;
  SqlAdapter: TSQLAdapter;
  ActionText: String;
  NeedUpdate: Boolean;
begin
  try
    SqlAdapter := CommonDataModule.ObjectPool.GetSQLAdapter;
    XMLDoc := TXMLDocument.Create(nil);
    try
      XMLDoc.XML.Text := ConnectXML;
      XMLDoc.Active := true;

      // getting client application info
      CSAID := StrToIntDef(XMLDoc.DocumentElement.Attributes['csaid'], 1);
      CSABuild := StrToIntDef(XMLDoc.DocumentElement.Attributes['csabuild'], 0);
      AffiliateId := StrToIntDef(XMLDoc.DocumentElement.Attributes['affiliateid'], 1);
      AdvertisementId := StrToIntDef(XMLDoc.DocumentElement.Attributes['advertisementid'], 0);
      MACAddress := XMLDoc.DocumentElement.Attributes['macaddress'];
      InternalClientIP := XMLDoc.DocumentElement.Attributes['internalip'];
      InternalClientHost := XMLDoc.DocumentElement.Attributes['internalhost'];

      if CommonDataModule.ClientConnectionsAllowedStatus <> ccaEnabled then
      begin
        if CommonDataModule.ClientConnectionsAllowedStatus = ccaPPC then
          XMLDoc.XML.Text := GetPlayPeriodConclusionPacket
        else
          XMLDoc.XML.Text := GetLogoutPacket;
        XMLDoc.Active := true;
      end
      else
      begin
        SqlAdapter.SetProcName('caUpdateClientSession');
        SqlAdapter.AddParam('RETURN_VALUE',0,ptResult,ftInteger);
        SqlAdapter.AddParam('SessionID', ASessionProcessor.SessionID, ptInput, ftInteger);
        SqlAdapter.AddParam('CSAID', CSAID, ptInput, ftInteger);
        SqlAdapter.AddParam('CSABuild', CSABuild, ptInput, ftInteger);
        SqlAdapter.AddParam('AffiliateId', AffiliateId, ptInput, ftInteger);
        SqlAdapter.AddParam('AdvertisementId', AdvertisementId, ptInput, ftInteger);
        SqlAdapter.AddParam('MACAddress', MACAddress, ptInput, ftString);
        SqlAdapter.AddParam('InternalClientIP', InternalClientIP, ptInput, ftString);
        SqlAdapter.AddParam('InternalClientHost', InternalClientHost, ptInput, ftString);
        SqlAdapter.ExecuteCommand;

        DownloadSize := '';
        DownloadURL :=  '';
        CurrentBuild := 0;

        FPrevCriticalSection.Lock;
        try
          if (CSAID = FPrevCSAID) and (AffiliateId = FPrevAffiliateId) and
            (SecondsBetween(Now, FPrevSaveTime) < cntRefreshInterval_Sec) then
          begin
            DownloadSize := FPrevSize;
            DownloadURL :=  FPrevUrl;
            CurrentBuild := FPrevBuild;
          end;
        finally
          FPrevCriticalSection.UnLock;
        end;

        if CurrentBuild = 0 then
        begin
          SqlAdapter.SetProcName('caGetAffiliateCSAInfo');
          SqlAdapter.AddParam('RETURN_VALUE',0,ptResult,ftInteger);
          SqlAdapter.AddParam('CSAID', CSAID, ptInput, ftInteger);
          SqlAdapter.AddParam('AffiliateId', AffiliateId, ptInput, ftInteger);
          SqlAdapter.AddParam('Size', 0, ptOutput, ftInteger);
          SqlAdapter.AddParam('Url', '', ptOutput, ftString);
          SqlAdapter.AddParam('Build', 0, ptOutput, ftInteger);
          SqlAdapter.ExecuteCommand;

          DownloadSize := SqlAdapter.GetParam('Size');
          DownloadURL :=  SqlAdapter.GetParam('Url');
          CurrentBuild := SqlAdapter.GetParam('Build');

          FPrevCriticalSection.Lock;
          try
            FPrevCSAID := CSAID;
            FPrevAffiliateId := AffiliateId;
            FPrevSize := DownloadSize;
            FPrevUrl := DownloadURL;
            FPrevBuild := CurrentBuild;
            FPrevSaveTime := Now;
          finally
            FPrevCriticalSection.UnLock;
          end;
        end;

        XMLDoc.Active := false;
        XMLDoc.XML.Text := PO_DEFAULTRESPONSEPACKET;
        XMLDoc.Active := true;
        XMLDoc.DocumentElement.Attributes[PO_ATTRNAME] := 'session';

        NeedUpdate := CurrentBuild > CSABuild;
        if NeedUpdate and (FUpdateRandomFactor > 2) then
          NeedUpdate := RandomRange(1, FUpdateRandomFactor) = 1;

        with XMLDoc.DocumentElement.AddChild('connect') do
          if NeedUpdate then
          begin
            // client have an old version of the application
            Attributes['result'] := 1001;
            Attributes['sessionid'] := 0;
            Attributes['csafileurl'] := DownloadURL;
            Attributes['csafilesize'] := DownloadSize;
          end
          else
          begin
            // generating response
            Attributes['result'] := PO_NOERRORS;
            Attributes['sessionid'] := ASessionProcessor.SessionId;
            Attributes['tournamentlimit'] := FTournamentLimit;
            Attributes['processlimit'] := FProcessLimit;
            Attributes['tournamenttablelimit'] := FTournamentTableLimit;
            Attributes['recordhandlimit'] := FRecordHandLimit;
            Attributes['playperiod'] := FNearestPlayPeriod;
            Attributes['realmoneytablesmsg'] := FRealMoneyTablesMessage;
            Attributes['loginurl'] := FLoginUserURL;
            Attributes['registerurl'] := FRegisterUserURL;
            Attributes['findprofileurl'] := FFindUserProfileURL;
          end;
      end;

      // sending response to the client
      ActionText := XMLDoc.DocumentElement.XML;
      ASessionProcessor.SendCommand(ActionText);
      if CommonDataModule.Logging then
        CommonDataModule.Log(ClassName, 'DoNewUserConnect',
          'Sent (' + ASessionProcessor.RemoteHost + '):' + ActionText, ltResponse);
    finally
      CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdapter);
      XMLDoc.Active := false;
      XMLDoc := nil;
    end;
  except
    on e: Exception do
    begin
      CommonDataModule.Log(ClassName, 'DoNewUserConnect', E.Message, ltException);
      ASessionProcessor.Stop;  
    end;
  end;
end;

procedure TClientAdapter.DoProcessAction(SessionID: Integer; const ActionXML: String);
begin
  try
    CommonDataModule.ProcessSessionAction(SessionID, ActionXML);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'DoProcessAction', E.Message, ltException);
  end;
end;

procedure TClientAdapter.ProcessAction(ActionXML: IXMLNode);
var
  Loop: Integer;
  XMLNode: IXMLNode;
  XMLName: String;
begin
  if ActionXML.ChildNodes.Count = 0 then
  begin
    CommonDataModule.Log(ClassName, 'ProcessAction',
      'Action packet was arrived without child nodes', ltError);
    Exit;
  end;

  for Loop := 0 to ActionXML.ChildNodes.Count - 1 do
  try
    XMLNode := ActionXML.ChildNodes.Nodes[Loop];
    XMLName := XMLNode.NodeName;

    if XMLName = CA_NOTIFY then
      DoNotify(XMLNode)
    else
    if XMLName = CA_NOTIFYALL then
      DoNotifyAll(XMLNode)
    else
    if XMLName = CA_MainChat then
      DoMainChat(XMLNode)
    else
    if (XMLName = CA_PrivateChat) or (XMLName = CA_PrivateMessage) or
      (XMLName = CA_PrivateChatInit) then
      DoPrivateChatMessaging(XMLNode)
    else
    if XMLName = CA_BuddyListAction then
      DoPrivateChatBuddiListAction(XMLNode);

  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'ProcessAction',
        E.Message + ' On processing action:' + ActionXML.XML, ltException);
  end;
end;

procedure TClientAdapter.DoNotify(ActionXML: IXMLNode);
var
  Loop: Integer;
  SessionsIDText: String;
  strSessionsID: TStringList;
  SessionsID: array of Integer;
  ActionText: String;
  SendResult: String;
begin
  SessionsIDText := ActionXML.Attributes[CA_SESSIONIDS];

  strSessionsID := TStringList.Create;
  strSessionsID.Text := StringReplace(SessionsIDText, ',', #13#10, [rfReplaceAll, rfIgnoreCase]);

  if strSessionsID.Count = 0 then
    CommonDataModule.Log(ClassName, 'DoNotify', 'SessionsID is empty', ltError)
  else
  begin
    SetLength(SessionsID, strSessionsID.Count);
    for Loop := 0 to strSessionsID.Count - 1 do
      SessionsID[Loop] := strtointdef(strSessionsID.Strings[Loop], 0);

    for Loop := 0 to ActionXML.ChildNodes.Count - 1 do
    try
      ActionText := ActionXML.ChildNodes.Nodes[Loop].XML;
      FSessionServer.SendCommand(SessionsID, ActionText, SendResult);

      if CommonDataModule.Logging then
        CommonDataModule.Log(ClassName, 'DoNotify',
          'Sent to SessionID:' + SessionsIDText +
          '; with result: ' + SendResult +
          '; Action: ' + ActionText, ltResponse);
    except
      on E: Exception do
        CommonDataModule.Log(ClassName, 'DoNotify', E.Message, ltException);
    end;
  end;

  strSessionsID.Text := '';
  strSessionsID.Free;
  SetLength(SessionsID, 0);
  SessionsID := nil;
  SessionsIDText := '';
  ActionText := '';
  SendResult := '';
end;

procedure TClientAdapter.DoNotifyAll(ActionXML: IXMLNode);
var
  Loop: Integer;
begin
  // sending notification to all registered clients
  for Loop := 0 to ActionXML.ChildNodes.Count - 1 do
    SendToAll(ActionXML.ChildNodes.Nodes[Loop].XML);
end;

procedure TClientAdapter.SendToAll(const ActionText: String);
begin
  try
    FSessionServer.SendCommandToAll(ActionText);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'SendToAll', E.Message, ltException);
  end;
  if CommonDataModule.Logging then
    CommonDataModule.Log(ClassName, 'SendToAll', ActionText, ltResponse);
end;

function TClientAdapter.GetLogoutPacket: String;
begin
  Result :=
    '<object name="user">' +
    '<uologout reason="Sorry but the client connection to the server ' +
    'is temporarily disabled. ' +
    'Please try again later"/>' +
//    '<uologout reason="We apologized for the inconvinience, ' +
//    'however the client connection to the server ' +
//    'is disabled now. Please try again later. Thank you for your understanding."/>' +
    '</object>';
end;

function TClientAdapter.GetReconnectPacket: String;
begin
  Result := '<object name="session"><reconnect/></object>';
end;

function TClientAdapter.GetPlayPeriodConclusionPacket: String;
begin
  Result :=
    '<object name="user">' +
    '<uologout reason="We apologized for the inconvinience, ' +
    'however Play Period is closing now. The client connection to the server ' +
    'is disabled now. Please come back tomorrow."/>' +
    '</object>';
end;

procedure TClientAdapter.RingUp;
begin
  try
    if SecondsBetween(Now, FLast_LogConnectionsCount) > LogConnectionsCount_Sec then
    begin
      CommonDataModule.Log(ClassName, 'RingUp',
        'ActiveConnections=' + inttostr(FSessionServer.ActiveConnections) +
        ', ConnectionCount=' + inttostr(FSessionServer.ConnectionCount) +
        ', ConnectClientCounter=' + inttostr(FConnectClientCounter) +
        ', DisconnectClientCounter=' + inttostr(FDisconnectClientCounter),
        ltBase);
      FLast_LogConnectionsCount := Now;
    end;

    if CommonDataModule.ClientConnectionsAllowedStatus <> FPreviousConnectionStatus then
    begin
      if (CommonDataModule.ClientConnectionsAllowedStatus = ccaEnabled) and
        (CommonDataModule.Connected) then
      begin
        Continue;
        FPreviousConnectionStatus := CommonDataModule.ClientConnectionsAllowedStatus;
      end;

      if CommonDataModule.ClientConnectionsAllowedStatus = ccaOff then
      begin
        SendToAll(GetLogoutPacket);
        FPreviousConnectionStatus := CommonDataModule.ClientConnectionsAllowedStatus;
      end;

      if CommonDataModule.ClientConnectionsAllowedStatus = ccaPPC then
      begin
        SendToAll(GetPlayPeriodConclusionPacket);
        FPreviousConnectionStatus := CommonDataModule.ClientConnectionsAllowedStatus;
      end;
    end;

    if SecondsBetween(Now, FLastRefreshTime) > cntRefreshInterval_Sec then
      RefreshClientSessionOptions;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'RingUp', E.Message, ltException);
  end;
end;

procedure TClientAdapter.RefreshClientSessionOptions;
var
  SqlAdapter: TSQLAdapter;
  RS: TDataSet;
  varPlayPeriod: Variant;
begin
  try
    SqlAdapter := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      // getting tournament limits
      RS := SqlAdapter.Execute('admGetConfigValue 9');
      FTournamentLimit := RS.FieldByName('PropertyValue').AsString;
      // get process limits
      RS := SqlAdapter.Execute('admGetConfigValue 10');
      FProcessLimit := RS.FieldByName('PropertyValue').AsString;
      // get tournament table limits
      RS := SqlAdapter.Execute('admGetConfigValue 11');
      FTournamentTableLimit := RS.FieldByName('PropertyValue').AsString;
      // get record hand limits
      RS := SqlAdapter.Execute('admGetConfigValue 12');
      FRecordHandLimit := RS.FieldByName('PropertyValue').AsString;
      // get client application update random factor
      RS := SqlAdapter.Execute('admGetConfigValue 19');
      FUpdateRandomFactor := StrToIntDef(RS.FieldByName('PropertyValue').AsString, 0);
      // get messsage text for client application when real money table list is empty
      RS := SqlAdapter.Execute('admGetConfigValue 20');
      FRealMoneyTablesMessage := RS.FieldByName('PropertyValue').AsString;
      // get URLs for links on Lobby
      RS := SqlAdapter.Execute('admGetConfigValue 27');
      FLoginUserURL := RS.FieldByName('PropertyValue').AsString;
      RS := SqlAdapter.Execute('admGetConfigValue 28');
      FRegisterUserURL := RS.FieldByName('PropertyValue').AsString;
      RS := SqlAdapter.Execute('admGetConfigValue 29');
      FFindUserProfileURL := RS.FieldByName('PropertyValue').AsString;

      SqlAdapter.SetProcName('apiGetNearestPlayPeriod');
      SqlAdapter.AddParam('RETURN_VALUE', 0, ptResult, ftInteger);
      SqlAdapter.AddParam('DateEnd', 0, ptOutput, ftDateTime);
      SqlAdapter.ExecuteCommand;

      varPlayPeriod := SqlAdapter.GetParam('DateEnd');
      if varPlayPeriod = Unassigned then
        FNearestPlayPeriod := 'Open'
      else
        FNearestPlayPeriod := DateTimeToStr(VarToDateTime(varPlayPeriod));

      FLastRefreshTime := Now;
    finally
      CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdapter);
    end;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'RefreshClientSessionOptions', E.Message, ltException);
  end;
end;

procedure TClientAdapter.Pause;
var
  Loop: Integer;
  strDisconnectPacket: String;
begin
  try
    FSessionServer.Stop;
    SendToAll(GetReconnectPacket);

    // Notify ActionDispatcher
    if FSessionServer.ActiveConnections > 0 then
    begin
      strDisconnectPacket := '<objects><object name="' + OBJ_ACTIONDISP + '" sendtoall="1">';
      for Loop := FSessionServer.ConnectionCount - 1 downto 0 do
        if FSessionServer.Connections(Loop) <> nil then
          strDisconnectPacket := strDisconnectPacket +
            '<' + AD_ClientDisconnect + ' ' + PO_ATTRSESSIONID + '="' +
            inttostr(FSessionServer.Connections(Loop).SessionID) + '"/>';
      strDisconnectPacket := strDisconnectPacket + '</object></objects>';
      CommonDataModule.SendToAllServers(strDisconnectPacket);
    end;
    CommonDataModule.Log(ClassName, 'Pause', 'Service is not accepting client connections', ltBase);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Pause', E.Message, ltException);
  end;
end;

procedure TClientAdapter.Continue;
begin
  try
    FSessionServer.Start;
    CommonDataModule.Log(ClassName, 'Continue', 'Service is accepting client connections', ltBase);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Continue', E.Message, ltException);
  end;
end;

procedure TClientAdapter.NotifyClient(SessionID: Integer; Data: String; var Handled: Boolean);
var
  SendResult: String;
begin
  Handled := FSessionServer.SendCommand([SessionID], Data, SendResult);
  if CommonDataModule.Logging and Handled then
    CommonDataModule.Log(ClassName, 'NotifyClient', 'Sent to SessionID:' + inttostr(SessionID) +
      '; with result: ' + SendResult + '; Action: ' + Data, ltResponse);
end;

procedure TClientAdapter.NotifyClients(SessionIDs: array of Integer; Data: String);
var
  SendResult: String;
begin
  FSessionServer.SendCommand(SessionIDs, Data, SendResult);
  if CommonDataModule.Logging then
    CommonDataModule.Log(ClassName, 'NotifyClients',
      'Sent with result: ' + SendResult + '; Action: ' + Data, ltResponse)
end;


// Main (Lobby) chat

procedure TClientAdapter.DoMainChat(ActionXML: IXMLNode);
begin
  FSessionServer.SendCommandToAll('<object name="lobby">' + ActionXML.XML + '<object>');
end;


// Private chat

procedure TClientAdapter.DoPrivateChatMessaging(ActionXML: IXMLNode);
{
<objects>
  <object name="clientadapter">
    <caprivatechatinit toid="12345" toname="Pavel"/>
  </object>
</objects>

or

<objects>
  <object name="clientadapter">
    <caprivatechat toid="12345" fromid="12347" fromname="Maxim" 
message="Lets play poker games"/>
  </object>
</objects>

or

<objects>
  <object name="clientadapter">
    <caprivatemessage toid="12345" toname="Pavel"
     fromid="12347" fromname="Maxim" message="Lets play poker games"/>
  </object>
</objects>

Errors:
1101 - user login name does not exist.
1102 - user login name exists but does not connected at this moment.
1103 - user login name exists but he blocks the initiator.
1199 - server error was occurred on processing the action.

}
var
  UserID, ToID, ErrorCode: Integer;
  SQLAdapter: TSQLAdapter;
  ToName: String;
  ToAvatarID: Integer;
  ToStatus: Integer;
begin
  ErrorCode := CA_PC_ServerError;
  UserID := StrToIntDef(ActionXML.Attributes['fromid'], 0);
  if ActionXML.HasAttribute('toid') then
    ToID := StrToIntDef(ActionXML.Attributes['toid'], 0)
  else
    ToID := 0;
  if ActionXML.HasAttribute('toname') then
    ToName := ActionXML.Attributes['toname']
  else
    ToName := '';
  ToAvatarID := -1;
  ToStatus := -1;

  if (UserID > 0) and ((ToID > 0) or (ToName <> '')) then
  try
    SQLAdapter := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      // Check that UserID does not block ToID and ToID registered and online
      // Add ToID to User's Buddy List
      SQLAdapter.SetProcName('caCheckPrivateChatting');
      SQLAdapter.AddParam('RETURN_VALUE', 0, ptResult, ftInteger);
      SQLAdapter.AddParam('UserID', UserID, ptInput, ftInteger);
      SQLAdapter.AddParam('ToID', ToID, ptInputOutput, ftInteger);
      SQLAdapter.AddParam('ToName', ToName, ptInputOutput, ftString);
      SQLAdapter.AddParam('ToAvatarID', ToAvatarID, ptInputOutput, ftInteger);
      SQLAdapter.AddParam('ToStatus', ToStatus, ptInputOutput, ftInteger);
      SQLAdapter.ExecuteCommand;
      ErrorCode := SQLAdapter.GetParam('RETURN_VALUE');
      ToID := SQLAdapter.GetParam('ToID');
      ToName := SQLAdapter.GetParam('ToName');
      ToAvatarID := SQLAdapter.GetParam('ToAvatarID');
      ToStatus := SQLAdapter.GetParam('ToStatus');
    finally
      CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);
    end;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'DoPrivateChatMessaging', E.Message, ltException);
  end;

  if (ErrorCode = CA_PC_ServerError) or (ErrorCode = CA_PC_UserDoesNotExists) then
  begin
    CommonDataModule.NotifyUserByID(UserID,
      '<object name="lobby"><caprivatechaterror toid="' + inttostr(ToID) +
      '" errorcode="' + inttostr(ErrorCode) + '"/></object>');
  end
  else with ActionXML.ParentNode do
  begin
    Attributes[PO_ATTRNAME] := APP_CHAT;
    ActionXML.Attributes['toid'] := ToID;
    ActionXML.Attributes['toname'] := ToName;
    ActionXML.Attributes['avatarid'] := ToAvatarID;
    ActionXML.Attributes['status'] := ToStatus;

    if ActionXML.NodeName <> CA_PrivateChatInit then
    begin
      if ErrorCode = CA_PC_UserDisconnected then
      begin
        ActionXML.Attributes['message'] := 'User is disconnected';
        ActionXML.Attributes['fromname'] := 'DEALER';
      end
      else if ErrorCode = CA_PC_UserBlocked then
      begin
        ActionXML.Attributes['message'] := 'This private messaging session is blocked';
        ActionXML.Attributes['fromname'] := 'DEALER';
      end
      else
        CommonDataModule.NotifyUserByID(ToID, ActionXML.ParentNode.XML);
    end;
    if ActionXML.NodeName <> CA_PrivateMessage then
      CommonDataModule.NotifyUserByID(UserID, ActionXML.ParentNode.XML);
  end;
end;

procedure TClientAdapter.UpdateBuddyList(UserID: Integer);
{
<object name="chat">
  <cabuddylistupdate>
    <buddy toid="12345" toname="Maxim" status="0|1|2" avatarid="1023"/>
    ...
  </cabuddylistupdate>
</object>

}
var
  SQLAdapter: TSQLAdapter;
  RS: TDataSet;
  XMLDoc: IXMLDocument;
  XMLRoot: IXMLNode;
begin
  if UserID > 0 then
  try
    XMLDoc := TXMLDocument.Create(nil);
    try
      XMLDoc.XML.Text := '<object name="chat"><cabuddylistupdate/></object>';
      XMLDoc.Active := True;
      XMLRoot := XMLDoc.DocumentElement.ChildNodes.Nodes[0];

      SQLAdapter := CommonDataModule.ObjectPool.GetSQLAdapter;
      try
        SQLAdapter.SetProcName('caGetBuddyList');
        SQLAdapter.AddParam('UserID', UserID, ptInput, ftInteger);
        RS := SQLAdapter.ExecuteCommand;
        RS.First;
        while not RS.Eof do
        try
          with XMLRoot.AddChild('buddy') do
          begin
            Attributes['toid'] := rsInt(RS, 'ToUserID');
            Attributes['toname'] := rsStr(RS, 'LoginName');
            Attributes['avatarid'] := rsInt(RS, 'AvatarID');
            if rsBit(RS, 'IsBlocked') = 1 then
              Attributes['status'] := 2
            else
              if rsInt(RS, 'ToSessionID') = 0 then
                Attributes['status'] := 0
              else
                Attributes['status'] := 1;
          end;
          RS.Next;
        except
          on E: Exception do
            CommonDataModule.Log(ClassName, 'UpdateBuddyList', 'On Getting data: ' +
              E.Message, ltException);
        end;
      finally
        CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);
      end;

      CommonDataModule.NotifyUserByID(UserID, XMLDoc.DocumentElement.XML);
    finally
      XMLDoc.Active := False;
      XMLDoc := nil;
    end;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'UpdateBuddyList', E.Message, ltException);
  end
  else
    CommonDataModule.Log(ClassName, 'UpdateBuddyList', 'UserID=0', ltError);
end;

procedure TClientAdapter.DoPrivateChatBuddiListAction(ActionXML: IXMLNode);
{
<objects>
  <object name="clientadapter">
    <cabuddylistaction toid="12345" toname="Maxim"
     fromid="12347" action="0|1|2|3|4"/>
  </object>
</objects>
}
var
  UserID, ToID, Action: Integer;
  ToName: String;
  SQLAdapter: TSQLAdapter;
begin
  Action := StrToIntDef(ActionXML.Attributes['action'], 0);
  UserID := StrToIntDef(ActionXML.Attributes['fromid'], 0);
  ToID := StrToIntDef(ActionXML.Attributes['toid'], 0);
  ToName := ActionXML.Attributes['toname'];

  if (Action > 0) and (UserID > 0) and ((ToID > 0) or (ToName <> '')) then
  try
    SQLAdapter := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      SQLAdapter.SetProcName('caBuddyListAction');
      SQLAdapter.AddParam('RETURN_VALUE', 0, ptResult, ftInteger);
      SQLAdapter.AddParam('Action', Action, ptInput, ftInteger);
      SQLAdapter.AddParam('UserID', UserID, ptInput, ftInteger);
      SQLAdapter.AddParam('ToID', ToID, ptInput, ftInteger);
      SQLAdapter.AddParam('ToName', ToName, ptInput, ftString);
      SQLAdapter.ExecuteCommand;
    finally
      CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);
    end;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'DoPrivateChatBuddiListAction', E.Message, ltException);
  end;

  UpdateBuddyList(UserID);
end;

procedure TClientAdapter.GetPlayerList(ASessionProcessor: TSessionProcessor; ConnectXML: String);
{
<getplayerlist username="enver" userpassword="qwerty1" adduser="BS" deluser="user" blockuser="Vasya"/>
}
var
  SQLAdapter: TSQLAdapter;
  sSQL: String;
  sText: String;
  XMLDoc: IXMLDocument;
  Response: String;
begin
  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.XML.Text := ConnectXML;
  XMLDoc.Active := true;

  SQLAdapter := CommonDataModule.ObjectPool.GetSQLAdapter;

  sSQL := 'exec caGetPlayerList ' + ''''+ XMLDoc.DocumentElement.Attributes['username'] + ''', ' +
                                   ''''+ XMLDoc.DocumentElement.Attributes['userpassword']+''', ' +
                                   ''''+ XMLDoc.DocumentElement.Attributes['adduser'] + ''', ' +
                                   ''''+ XMLDoc.DocumentElement.Attributes['deluser'] + ''', ' +
                                   ''''+ XMLDoc.DocumentElement.Attributes['blockuser']+ ''', ' +
                                   ''''+ XMLDoc.DocumentElement.Attributes['unblockuser']+ '''';

  try
    sText :=
        '<getplayerlist result="0"><players>' +
          SQLAdapter.ExecuteForXML(sSQL) +
        '</players></getplayerlist>';
  except
      on E: Exception do begin
        CommonDataModule.Log(ClassName, 'ProcessGetPlayerList',
          '[EXCEPTION]: On exec caGetPlayerList:' + E.Message,
          ltException
        );
        CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);
        Exit;
      end;
  end;


  CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);

   ASessionProcessor.SendCommand(sText);
   
   Response := '';
   if XMLDoc.DocumentElement.HasAttribute('gameprocessid') then
   if XMLDoc.DocumentElement.Attributes['gameprocessid'] <> 0  then
   begin
    Response := '<uofindplayer result="0" gameprocessid="'+XMLDoc.DocumentElement.Attributes['gameprocessid']+'"/>';
    sText := '<object name="user">' + Response + '</object>';
    CommonDataModule.NotifyUserByID(XMLDoc.DocumentElement.Attributes['userid'],sText);
   end;

  XMLDoc.Active := false;
  XMLDoc := nil;

  sText := '';
  sSQL := '';

end;


end.
