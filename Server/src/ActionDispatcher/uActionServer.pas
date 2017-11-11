unit uActionServer;

interface

uses
  SysUtils, Classes, ExtCtrls, Forms, ActiveX, WinSock, SyncObjs,
  Windows, Messages, Graphics, Controls, SvcMgr, Dialogs, DateUtils,
  xmldom, XMLIntf, msxmldom, XMLDoc, Variants,
  uSessionServer, uSessionProcessor, uCommonDataModule, uSettings, uLocker;

const
  cntUpdateInterval_Sec = 1000;
  cntDefaultID = -1;
  cntSpecialID = -2;

type
  TActionService = record
    ServiceIP: String;
    ServicePort: Integer;
    ServiceName: String;
    SupportedModes: TServiceModes;
    ActionDispatcherID: Integer;
    SessionProcessor: TSessionProcessor;
  end;

  TGameProcess = record
    ServiceID: Integer;
    ProcessID: Integer;
  end;

  TClientSession = record
    ServiceID: Integer;
    SessionID: Integer;
  end;

  TUserSession = record
    SessionID: Integer;
    UserID: Integer;
  end;

  TActionServer = class
  private
    FServices: array of TActionService;
    FServices_CriticalSection: TLocker;

    FClientConnections: array of TClientSession;
    FConnections_CriticalSection: TLocker;

    FProcesses: array of TGameProcess;
    FProcesses_CriticalSection: TLocker;

    FUserSessions: array of TUserSession;
    FUserSessions_CriticalSection: TLocker;

    FLastUpdateTime: TDateTime;
    FSessionServer: TSessionServer;

    procedure OnSessionOpened(ASessionProcessor: TSessionProcessor; var ASessionID: Integer);
    procedure OnSessionClosed(ASessionProcessor: TSessionProcessor);
    procedure OnSessionCommand(ASessionProcessor: TSessionProcessor; const ACommand: String);

    procedure Clear;
    procedure SaveSystemState(InitialCall: Boolean; SelectedSessionID: Integer);

    procedure ServiceConnected(SessionID: Integer; ActionXML: IXMLNode);
    procedure RecognizeAction(ActionXML: IXMLNode);

    procedure DoSendToAll(ActionXML: IXMLNode);
    procedure DoSendToAllGameAdapters(ActionXML: IXMLNode);
    procedure DoSendToAllClientAdapters(ActionXML: IXMLNode);
    procedure DoClientConnect(ActionXML: IXMLNode);
    procedure DoClientDisconnect(ActionXML: IXMLNode);
    procedure DoChangeConnectionsAllowedStatus(ActionXML: IXMLNode);
    procedure DoNotify(ActionXML: IXMLNode);
    procedure DoNotifyAll(ActionXML: IXMLNode);
    procedure NotifyAllClients(ActionText: String);

    procedure DeleteUserSessions;
    procedure DoProcessStopped(ActionXML: IXMLNode);
    procedure NotifyAllProcesses(ActionText: String);
  public
    procedure RingUp;
    procedure SendToAll(Data: String);
    procedure ProcessAction(ActionXML: IXMLNode);
    procedure DispatchAction(ActionXML: IXMLNode);
    procedure NotifyUsers(SessionIDs, UserIDs: array of Integer; Data: String);
    procedure ProcessGameAction(curProcessID: Integer; const ActionText: String);

    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  uXMLConstants, uErrorConstants, uLogger, uAPI, uServiceDataModule,
  uActionDispatcher, uObjectPool, uSQLAdapter, uGameAdapter, DB;

{ TActionServer }

constructor TActionServer.Create;
begin
  inherited;

  try
    // Create and Initialize FSessionServer
    FSessionServer := TSessionServer.Create(10, 3,
      False, CommonDataModule.ActionDispatcherPort,
      OnSessionOpened, OnSessionClosed, OnSessionCommand);
    FSessionServer.Start;

    SetLength(FClientConnections, 0);
    FConnections_CriticalSection := CommonDataModule.ThreadLockHost.Add('connectioncriticalsection');
    SetLength(FProcesses, 0);
    FProcesses_CriticalSection := CommonDataModule.ThreadLockHost.Add('processescriticalsection');
    SetLength(FServices, 0);
    FServices_CriticalSection := CommonDataModule.ThreadLockHost.Add('servicescriticalsection');
    SetLength(FUserSessions, 0);
    FUserSessions_CriticalSection := CommonDataModule.ThreadLockHost.Add('usersessioncriticalsection');
    FLastUpdateTime := Now;

    if CommonDataModule.ActionDispatcherID = cntDefaultActionDispatcherID then
    begin
      Clear;
      ReinitAllProcesses;
    end;

    SaveSystemState(True, 0);

    CommonDataModule.Log(ClassName, 'Create',
      'Server started on ' + CommonDataModule.LocalHost + ':' +
      inttostr(CommonDataModule.ActionDispatcherPort), ltBase);
      CommonDataModule.Log(ClassName, 'Create', 'Created successfully', ltBase);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Create',E.Message, ltException);
  end;
end;

destructor TActionServer.Destroy;
begin
  try
    FSessionServer.Stop;
    CommonDataModule.Connected := False;
    SaveSystemState(False, 0);

    if CommonDataModule.ActionDispatcherID = cntDefaultActionDispatcherID then
    begin
      ReinitAllProcesses;
      Clear;
    end;

    FSessionServer.Free;

    FClientConnections := nil;

    FProcesses := nil;

    FServices := nil;
    
    FUserSessions := nil;


    CommonDataModule.ThreadLockHost.Del(FConnections_CriticalSection);

    CommonDataModule.ThreadLockHost.Del(FProcesses_CriticalSection);

    CommonDataModule.ThreadLockHost.Del(FServices_CriticalSection);

    CommonDataModule.ThreadLockHost.Del(FUserSessions_CriticalSection);

    CommonDataModule.Log(ClassName, 'Destroy', 'Destroyed successfully', ltBase);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Destroy', E.Message, ltException);
  end;

  inherited;
end;

procedure TActionServer.Clear;
var
  SQL: TSQLAdapter;
begin
  if CommonDataModule.ActionDispatcherID = cntDefaultActionDispatcherID then
  try
    SQL := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      SQL.Execute('delete from [ClientSession]');
      SQL.Execute('UPDATE GameProcessData SET ServerIP=''''');
      SQL.Execute('UPDATE Services SET IsConnected=0,IsClientAdapter=0,IsActionProcessor=0' +
        ',IsActionDispatcher=0,IsMSMQReader=0,IsMSMQWriter=0,IsReminder=0' +
        ',IsTournament=0,IsGameAdapter=0');
    finally
      CommonDataModule.ObjectPool.FreeSQLAdapter(SQL);
    end;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Clear', E.Message, ltException);
  end;
end;


// Save services states and data for charts

procedure TActionServer.RingUp;
var
  FSQL: TSQLAdapter;
begin
  try
    if SecondsBetween(Now, FLastUpdateTime) > cntUpdateInterval_SEC then
    begin
      CommonDataModule.Log(ClassName, 'RingUp',
      'Services: ' + inttostr(Length(FServices)) + ', ' +
      'Client Sessions: ' + inttostr(Length(FClientConnections)) + ', ' +
      'User Sessions: ' + inttostr(Length(FUserSessions)) + ', ' +
      'Processes: ' + inttostr(Length(FProcesses)), ltBase);
      FLastUpdateTime := Now;
      DeleteUserSessions;

      try
        FSQL := CommonDataModule.ObjectPool.GetSQLAdapter;
        try
          FSQL.Execute('exec apiCheckPrivateTablesExpiration');
        finally
          CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
        end;
      except
        on E: Exception do
          CommonDataModule.Log(ClassName, 'RingUp', E.Message, ltException);
      end;

    end;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'RingUp', E.Message, ltException);
  end;
end;

procedure TActionServer.SaveSystemState(InitialCall: Boolean; SelectedSessionID: Integer);
var
  Loop: Integer;
  SQL: TSQLAdapter;
  WorkFinished: Boolean;
  curServicePort: Integer;
  curServiceIP: String;
  curServiceName: String;
  curModes: TServiceModes;
begin
  begin
    SQL := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      SQL.Execute('exec adsSaveServiceDetails ''' +
        CommonDataModule.LocalIP + ''',' + inttostr(CommonDataModule.ClientAdapterPort) + ',''' +
        CommonDataModule.ServiceName + ''',' +
        CommonDataModule.BoolAsStr(CommonDataModule.Connected) + ',' +
        CommonDataModule.BoolAsStr(stClientAdapter in CommonDataModule.ServiceModes) + ',' +
        CommonDataModule.BoolAsStr(stActionProcessor in CommonDataModule.ServiceModes) + ',' +
        CommonDataModule.BoolAsStr(stActionDispatcher in CommonDataModule.ServiceModes) + ',' +
        CommonDataModule.BoolAsStr(stMSMQReader in CommonDataModule.ServiceModes) + ',' +
        CommonDataModule.BoolAsStr(stMSMQWriter in CommonDataModule.ServiceModes) + ',' +
        CommonDataModule.BoolAsStr(stReminder in CommonDataModule.ServiceModes) + ',' +
        CommonDataModule.BoolAsStr(stTournament in CommonDataModule.ServiceModes) + ',' +
        CommonDataModule.BoolAsStr(stGameAdapter in CommonDataModule.ServiceModes));

      if InitialCall then
        SQL.Execute('UPDATE [Services] SET LastRestart=''' + DateTimeToStr(Now) +
          ''' where MachineIP=''' + CommonDataModule.LocalIP + ''' and ClientAdapterPort=' +
          inttostr(CommonDataModule.ClientAdapterPort));

      if CommonDataModule.ActionDispatcherID = cntDefaultActionDispatcherID then
      begin
        Loop := 0;
        WorkFinished := False;
        repeat
          curServicePort := 0;
          curServiceIP := '';
          curServiceName := '';
          curModes := [];

          FServices_CriticalSection.Lock;
          try
            if Loop >= Length(FServices) then
              WorkFinished := True
            else
              with FServices[Loop] do
              begin
                curServiceIP := ServiceIP;
                curServicePort := ServicePort;
                curServiceName := ServiceName;
                curModes := SupportedModes;
              end;
          finally
            FServices_CriticalSection.UnLock;
          end;

          if (not WorkFinished) and (curServiceIP <> '') then
          begin
            SQL.Execute('exec adsSaveServiceDetails ''' + curServiceIP + ''',' +
              inttostr(curServicePort) +',''' + curServiceName + ''',1,' +
              CommonDataModule.BoolAsStr(stClientAdapter in curModes) + ',' +
              CommonDataModule.BoolAsStr(stActionProcessor in curModes) + ',' +
              CommonDataModule.BoolAsStr(stActionDispatcher in curModes) + ',' +
              CommonDataModule.BoolAsStr(stMSMQReader in curModes) + ',' +
              CommonDataModule.BoolAsStr(stMSMQWriter in curModes) + ',' +
              CommonDataModule.BoolAsStr(stReminder in curModes) + ',' +
              CommonDataModule.BoolAsStr(stTournament in curModes) + ',' +
              CommonDataModule.BoolAsStr(stGameAdapter in curModes));

            if SelectedSessionID = Loop then
              SQL.Execute('UPDATE [Services] SET LastRestart=''' + DateTimeToStr(Now) +
                ''' where MachineIP=''' + curServiceIP + ''' and ClientAdapterPort=' +
                inttostr(curServicePort));
            Inc(Loop);
          end;
        until WorkFinished;
      end;
    except
      on E: Exception do
        CommonDataModule.Log(ClassName, 'SaveSystemState', E.Message, ltException);
    end;

    CommonDataModule.ObjectPool.FreeSQLAdapter(SQL);
  end;
end;


// Connections

procedure TActionServer.OnSessionOpened(ASessionProcessor: TSessionProcessor;
  var ASessionID: Integer);
var
  Loop: Integer;
  EmptyIndex: Integer;
begin
  CommonDataModule.Log(ClassName, 'OnSessionOpened',
    'Service Connected: ' + ASessionProcessor.RemoteHost, ltBase);

  FServices_CriticalSection.Lock;
  try
    Loop := 0;
    EmptyIndex := -1;

    while Loop < Length(FServices) do
    begin
      if (FServices[Loop].ServiceIP = '') and (FSessionServer.GetConnection(Loop) = nil) then
      begin
        EmptyIndex := Loop;
        Break;
      end;
      Inc(Loop);
    end;

    if EmptyIndex = -1 then
    begin
      EmptyIndex := Length(FServices);
      SetLength(FServices, EmptyIndex + 1);
    end;

    with FServices[EmptyIndex] do
    begin
      ASessionID := EmptyIndex;
      ServiceIP := ASessionProcessor.RemoteHost;
      ServicePort := 0;
      ServiceName := '';
      SupportedModes := [];
      ActionDispatcherID := 0;
      SessionProcessor := ASessionProcessor;
    end;
  finally
    FServices_CriticalSection.UnLock;
  end;
end;

procedure TActionServer.OnSessionClosed(ASessionProcessor: TSessionProcessor);
var
  Loop: Integer;
  SQL: TSQLAdapter;
  curServiceID: Integer;
  curServiceIP: String;
  curServiceFullIP: String;
  curServiceName: String;
  curServicePort: Integer;
  ProcessIDs: array of Integer;
  ProcessCount: Integer;
begin
  curServiceID := ASessionProcessor.SessionID;
  curServiceIP := '';
  curServicePort := 0;
  curServiceName := '';

  FServices_CriticalSection.Lock;
  try
    if (curServiceID >= 0) and
      (curServiceID < Length(FServices)) then
      with FServices[curServiceID] do
      begin
        curServiceIP := ServiceIP;
        curServiceName := ServiceName;
        curServicePort := ServicePort;

        ServiceIP := '';
        ServiceName := '';
        ServicePort := 0;
        SupportedModes := [];
        ActionDispatcherID := 0;
        SessionProcessor := nil;
      end;
  finally
    FServices_CriticalSection.UnLock;
  end;

  if curServiceIP <> '' then
  begin
    curServiceFullIP := curServiceIP + ':' + inttostr(curServicePort);
    CommonDataModule.Log(ClassName, 'OnSessionClosed',
      'Service Disconnected: ' + curServiceFullIP, ltBase);
    try
      SQL := CommonDataModule.ObjectPool.GetSQLAdapter;
      try
        SQL.Execute('exec adsSaveServiceDetails ''' + curServiceIP + ''',' +
          inttostr(curServicePort) + ',''' + curServiceName + ''',0');
        SQL.Execute('exec gaUnRegisterProcesses ''' + curServiceFullIP + '''');
      finally
        CommonDataModule.ObjectPool.FreeSQLAdapter(SQL);
      end;
    except
      on e: Exception do
        CommonDataModule.Log(ClassName, 'OnSessionClosed',
          'On execute SQL for ' + curServiceFullIP + ': Message: ' + e.Message, ltException);
    end;

    // Client connections
    FConnections_CriticalSection.Lock;
    try
      for Loop := 0 to Length(FClientConnections) - 1 do
        if FClientConnections[Loop].ServiceID = curServiceID then
        begin
          FClientConnections[Loop].ServiceID := cntDefaultID;
          FClientConnections[Loop].SessionID := cntDefaultID;
        end;
    finally
      FConnections_CriticalSection.UnLock;
    end;
    DeleteUserSessions;

    // Processes
    SetLength(ProcessIDs, 100);
    ProcessCount := 0;

    FProcesses_CriticalSection.Lock;
    try
      for Loop := 0 to Length(FProcesses) - 1 do
        if FProcesses[Loop].ServiceID = curServiceID then
        begin
          ProcessIDs[ProcessCount] := FProcesses[Loop].ProcessID;
          Inc(ProcessCount);
          if ProcessCount >= Length(ProcessIDs) - 1 then
            SetLength(ProcessIDs, Length(ProcessIDs) + 10);
          FProcesses[Loop].ServiceID := cntDefaultID;
          FProcesses[Loop].ProcessID := cntDefaultID;
        end;
    finally
      FProcesses_CriticalSection.UnLock;
    end;

    for Loop := 0 to ProcessCount - 1 do
      CommonDataModule.ProcessAction(
        '<objects><object name="gameadapter" processid="' + inttostr(ProcessIDs[Loop]) +
        '"><gaaction processid="' + inttostr(ProcessIDs[Loop]) +
        '"><timerevent name="checktimeoutactivity"  handid="0" round="-1"/></gaaction></object></objects>');
  end
  else
    CommonDataModule.Log(ClassName, 'OnSessionClosed',
      'Service not found: ' + inttostr(ASessionProcessor.SessionID) + ': ' +
        ASessionProcessor.RemoteHost, ltBase);
end;


// Dispatch command

procedure TActionServer.OnSessionCommand(ASessionProcessor: TSessionProcessor; const ACommand: String);
var
  XMLDoc: IXMLDocument;
  XMLRoot: IXMLNode;
  Loop: Integer;
  EndPos: Integer;
  ProcessID: Integer;
  Command: String;
  Destinations: String;
  DestinationList: TStringList;
  SessionIDs, UserIDs: array of Integer;
  curServiceID: Integer;
begin
  curServiceID := ASessionProcessor.SessionID;

  if CommonDataModule.Logging then
    if (curServiceID >= 0) and
      (curServiceID < Length(FServices)) then
      CommonDataModule.Log(ClassName, 'OnSessionCommand',
        FServices[curServiceID].ServiceIP + ':' +
        inttostr(FServices[curServiceID].ServicePort) + ': ' +
        ACommand, ltRequest);

  if ACommand[1] = cntHeaderClientAdapterSignature then
  begin
    EndPos := Pos(cntHeaderEndSignature, ACommand);
    Command := copy(ACommand, EndPos + 1, MAXINT);
    Destinations := copy(ACommand, 2, EndPos - 2);
    EndPos := Pos(';', Destinations);
    SetLength(SessionIDs, 0);
    SetLength(UserIDs, 0);
    DestinationList := TStringList.Create;
    if EndPos > 1 then
    begin
      DestinationList.Text := StringReplace(copy(Destinations, 1, EndPos - 1),
        ',', #13#10, [rfReplaceAll, rfIgnoreCase]);
      if DestinationList.Count > 0 then
      begin
        SetLength(SessionIDs, DestinationList.Count);
        for Loop := 0 to DestinationList.Count - 1 do
          SessionIDs[Loop] := strtointdef(DestinationList.Strings[Loop], 0);
      end;
    end;
    if EndPos < Length(Destinations) then
    begin
      DestinationList.Text := StringReplace(copy(Destinations, EndPos + 1, MAXINT),
        ',', #13#10, [rfReplaceAll, rfIgnoreCase]);
      if DestinationList.Count > 0 then
      begin
        SetLength(UserIDs, DestinationList.Count);
        for Loop := 0 to DestinationList.Count - 1 do
          UserIDs[Loop] := strtointdef(DestinationList.Strings[Loop], 0);
      end;
    end;
    DestinationList.Free;
    NotifyUsers(SessionIDs, UserIDs, Command);
  end
  else
  if ACommand[1] = cntHeaderGameAdapterSignature then
  begin
    EndPos := Pos(cntHeaderEndSignature, ACommand);
    ProcessID := strtointdef(copy(ACommand, 2, EndPos - 2), 0);
    Command := copy(ACommand, EndPos + 1, MAXINT);
    ProcessGameAction(ProcessID, Command);
  end
  else
  try
    XMLDoc := TXMLDocument.Create(nil);
    try
      XMLDoc.XML.Text := ACommand;
      XMLDoc.Active := True;
      XMLRoot := XMLDoc.DocumentElement;

      if XMLRoot.NodeName = PO_OBJECTS then
      begin
        XMLRoot.ChildNodes.Nodes[0].ChildNodes.Nodes[0].Attributes[AD_ServiceID] :=
          inttostr(curServiceID);
        RecognizeAction(XMLRoot);
      end
      else
      if XMLRoot.NodeName = PO_CONNECT then
        ServiceConnected(curServiceID, XMLRoot)
      else
        CommonDataModule.Log(ClassName, 'TCPSocketCommand',
          'Unknown XML packet: ' + ACommand, ltError);

    finally
      XMLDoc.Active := False;
      XMLDoc := nil;
    end;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'TCPSocketCommand',
        E.Message + ', Action:' + ACommand, ltException);
  end;
end;

procedure TActionServer.ServiceConnected(SessionID: Integer; ActionXML: IXMLNode);
var
  strType: String;
  Loop: Integer;
  curSupportedModes: TServiceModes;
  curPort: Integer;
  curServiceName: String;
  curActionDispatcherID: Integer;
begin
  curSupportedModes := [];
  curServicename := ActionXML.Attributes[AD_ServiceName];
  curActionDispatcherID := ActionXML.Attributes[AD_ActionDispatcherID];
  curPort := StrToIntDef(ActionXML.Attributes['port'], 0);
  if curPort = 0 then
    curPort := SessionID;

  for Loop := 0 to ActionXML.ChildNodes.Count - 1 do
  begin
    strType := lowercase(ActionXML.ChildNodes.Nodes[Loop].Attributes[PO_ATTRNAME]);
    if strType = OBJ_ACTIONProcessor then
      curSupportedModes := curSupportedModes + [stActionProcessor];
    if strType = OBJ_ACTIONDISPATCHER then
      curSupportedModes := curSupportedModes + [stActionDispatcher];
    if strType = OBJ_CLIENTADAPTER then
      curSupportedModes := curSupportedModes + [stClientAdapter];
    if strType = OBJ_MSMQReader then
      curSupportedModes := curSupportedModes + [stMSMQReader];
    if strType = OBJ_MSMQWriter then
      curSupportedModes := curSupportedModes + [stMSMQWriter];
    if strType = OBJ_REMINDER then
      curSupportedModes := curSupportedModes + [stReminder];
    if strType = OBJ_TOURNAMENT then
      curSupportedModes := curSupportedModes + [stTournament];
    if strType = OBJ_GameAdapter then
      curSupportedModes := curSupportedModes + [stGameAdapter];
  end;

  FServices[SessionID].SupportedModes := curSupportedModes;
  FServices[SessionID].ServicePort := curPort;
  FServices[SessionID].ServiceName := curServicename;
  FServices[SessionID].ActionDispatcherID := curActionDispatcherID;

  SaveSystemState(False, SessionID);
end;

procedure TActionServer.RecognizeAction(ActionXML: IXMLNode);
begin
  if ActionXML.NodeName <> PO_OBJECTS then
  begin
    CommonDataModule.Log(ClassName, 'RecognizeAction',
      'Can not recognise the objects action: ' + ActionXML.XML, ltError);
    Exit;
  end;

  if ActionXML.ChildNodes.Count = 0 then
  begin
    CommonDataModule.Log(ClassName, 'RecognizeAction',
      'Action packet was arrived without child nodes: ' + ActionXML.XML, ltError);
    Exit;
  end;

  CommonDataModule.ProcessXMLAction(ActionXML);
end;


// Dispatch

procedure TActionServer.DispatchAction(ActionXML: IXMLNode);
var
  strNode: String;
  Loop: Integer;
  curMode: TServiceMode;
  XMLSent: Boolean;
  ActionText: String;
  ProcessID: Integer;
begin
  if ActionXML.ChildNodes.Count = 0 then
  begin
    CommonDataModule.Log(ClassName, 'DispatchAction',
      'Action packet was arrived without child nodes: ' + ActionXML.XML, ltError);
    Exit;
  end;

  strNode := lowercase(ActionXML.ChildNodes.Nodes[0].Attributes[PO_ATTRNAME]);

  if strNode = OBJ_GameAdapter then
  begin
    with ActionXML.ChildNodes.Nodes[0].ChildNodes.Nodes[0] do
    begin
      ProcessID := 0;
      if HasAttribute(PO_ATTRPROCESSID) then
        ProcessID := strtointdef(Attributes[PO_ATTRPROCESSID], 0);
      ActionText := XML;
    end;
    ProcessGameAction(ProcessID, ActionText)
  end
  else
  if strNode = OBJ_ClientAdapter then
    NotifyAllClients(ActionXML.XML)
  else
  begin
    if strNode = OBJ_Tournament then
      curMode := stTournament
    else
    if strNode = OBJ_Reminder then
      curMode := stReminder
    else
    if strNode = OBJ_MSMQWriter then
      curMode := stMSMQWriter
    else
      curMode := stActionProcessor;

    XMLSent := False;
    ActionText := ActionXML.XML;
    for Loop := 0 to Length(FServices) - 1 do
      if (FServices[Loop].ServiceIP <> '') and (curMode in FServices[Loop].SupportedModes) then
      begin
        try
          FServices[Loop].SessionProcessor.SendCommand(ActionText);
          CommonDataModule.Log(ClassName, 'DispatchAction',
            'Sent to:' + FServices[Loop].ServiceIP + ':' + inttostr(FServices[Loop].ServicePort) +
            '; Action: ' + ActionText, ltResponse);
        except
          on E: Exception do
            CommonDataModule.Log(ClassName, 'DispatchAction', E.Message, ltException);
        end;
        XMLSent := True;
      end;

    if not XMLSent then
      CommonDataModule.Log(ClassName, 'DispatchAction',
        'ActionClient Service was not found for the action: ' + ActionText, ltError);
  end;
end;


// Specific actions

procedure TActionServer.ProcessAction(ActionXML: IXMLNode);
var
  Loop: Integer;
  XMLNode: IXMLNode;
  XMLName: String;
  curServiceID: Integer;
begin
  if ActionXML.ChildNodes.Count = 0 then
  begin
    CommonDataModule.Log(ClassName, 'ProcessAction',
      'Action packet was arrived without child nodes', ltError);
    Exit;
  end;

  curServiceID := cntSpecialID;
  for Loop := 0 to ActionXML.ChildNodes.Count - 1 do
  try
    XMLNode := ActionXML.ChildNodes.Nodes[Loop];
    XMLName := XMLNode.NodeName;
    if Loop = 0 then
      if XMLNode.HasAttribute(AD_ServiceID) then
        curServiceID := strtointdef(XMLNode.Attributes[AD_ServiceID], cntSpecialID);

    XMLNode.Attributes[AD_ServiceID] := inttostr(curServiceID);

    // To Client adapter
    if XMLName = CA_NOTIFY then
      DoNotify(XMLNode)
    else
    if XMLName = CA_NOTIFYALL then
      DoNotifyAll(XMLNode)
    else
    // Original
    if XMLName = AD_ClientConnect then
      DoClientConnect(XMLNode)
    else
    if XMLName = AD_ClientDisconnect then
      DoClientDisconnect(XMLNode)
    else
    if XMLName = AD_ProcessStopped then
      DoProcessStopped(XMLNode)
    else
    if XMLName = AD_SendToAll then
      DoSendToAll(XMLNode)
    else
    if XMLName = AD_SendToAllGameAdapters then
      DoSendToAllGameAdapters(XMLNode)
    else
    if XMLName = AD_SendToAllClientAdapters then
      DoSendToAllClientAdapters(XMLNode)
    else
    if XMLName = CA_CONNECTIONSALLOWED then
      DoChangeConnectionsAllowedStatus(XMLNode);

  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'ProcessAction',
        E.Message + ' On processing action:' + ActionXML.XML, ltException);
  end;

  XMLName := '';
end;

procedure TActionServer.SendToAll(Data: String);
begin
  try
    FSessionServer.SendCommandToAll(Data);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'SendToAll', E.Message, ltException);
  end;
end;

procedure TActionServer.DoSendToAll(ActionXML: IXMLNode);
var
  Loop: Integer;
begin
  for Loop := 0 to ActionXML.ChildNodes.Count - 1 do
    SendToAll(ActionXML.ChildNodes.Nodes[Loop].XML);
end;

procedure TActionServer.DoSendToAllClientAdapters(ActionXML: IXMLNode);
var
  Loop: Integer;
begin
  for Loop := 0 to ActionXML.ChildNodes.Count - 1 do
    NotifyAllClients(ActionXML.ChildNodes.Nodes[Loop].XML);
end;

procedure TActionServer.DoSendToAllGameAdapters(ActionXML: IXMLNode);
var
  Loop: Integer;
  sXml: string;
begin
  for Loop := 0 to ActionXML.ChildNodes.Count - 1 do begin
    sXml := ActionXML.ChildNodes[Loop].XML;
    NotifyAllProcesses(sXml);
  end
end;


// Client connections

procedure TActionServer.DoClientConnect(ActionXML: IXMLNode);
var
  curSessionID: Integer;
  curServiceID: Integer;
  Loop: Integer;
  EmptyIndex: Integer;
begin
  curSessionID := strtointdef(ActionXML.Attributes[PO_ATTRSESSIONID], cntDefaultID);
  curServiceID := strtointdef(ActionXML.Attributes[AD_ServiceID], cntDefaultID);

  if (curSessionID <> cntDefaultID) and (curServiceID <> cntDefaultID) then
  begin
    FConnections_CriticalSection.Lock;
    try
      EmptyIndex := -1;
      for Loop := 0 to Length(FClientConnections) - 1 do
        if FClientConnections[Loop].SessionID = cntDefaultID then
        begin
          EmptyIndex := Loop;
          Break;
        end;

      if EmptyIndex = -1 then
      begin
        EmptyIndex := Length(FClientConnections);
        SetLength(FClientConnections, EmptyIndex + 10);
        for Loop := EmptyIndex + 1 to Length(FClientConnections) - 1 do
          with FClientConnections[Loop] do
          begin
            SessionID := cntDefaultID;
            ServiceID := cntDefaultID;
          end;
      end;

      with FClientConnections[EmptyIndex] do
      begin
        SessionID := curSessionID;
        ServiceID := curServiceID;
      end;
    finally
      FConnections_CriticalSection.UnLock;
    end;
  end
  else
    CommonDataModule.Log(ClassName, 'DoClientConnect', 'curSessionID=' + inttostr(curSessionID) +
      ', curServiceID=' + inttostr(curServiceID), ltError);
end;

procedure TActionServer.DoClientDisconnect(ActionXML: IXMLNode);
var
  curSessionID : Integer;
  Loop: Integer;
begin
  curSessionID := strtointdef(ActionXML.Attributes[PO_ATTRSESSIONID], cntDefaultID);

  FConnections_CriticalSection.Lock;
  try
    for Loop := 0 to Length(FClientConnections) - 1 do
      with FClientConnections[Loop] do
        if SessionID = curSessionID then
        begin
          SessionID := cntDefaultID;
          ServiceID := cntDefaultID;
        end;
  finally
    FConnections_CriticalSection.UnLock;
  end;

  FUserSessions_CriticalSection.Lock;
  try
    for Loop := 0 to Length(FUserSessions) - 1 do
      with FUserSessions[Loop] do
        if SessionID = curSessionID then
        begin
          SessionID := cntDefaultID;
          UserID := cntDefaultID;
        end;
  finally
    FUserSessions_CriticalSection.UnLock;
  end;
end;

procedure TActionServer.DeleteUserSessions;
begin
  FUserSessions_CriticalSection.Lock;
  try
    SetLength(FUserSessions, 0);
  finally
    FUserSessions_CriticalSection.UnLock;
  end;
  CommonDataModule.Log(ClassName, 'DeleteUserSessions', 'Cleared', ltBase);
end;


// To Client adapter

procedure TActionServer.DoChangeConnectionsAllowedStatus(ActionXML: IXMLNode);
begin
  CommonDataModule.ClientConnectionsAllowedStatus :=
    StrToIntDef(ActionXML.Attributes['statusid'],
    CommonDataModule.ClientConnectionsAllowedStatus);
end;

procedure TActionServer.DoNotify(ActionXML: IXMLNode);
var
  Loop: Integer;
  DestinationsList: TStringList;
  SessionIDsText: String;
  UserIDsText: String;
  SessionIDs: array of Integer;
  UserIDs: array of Integer;
begin
  DestinationsList := TStringList.Create;
  try
    SessionIDsText := '';
    if ActionXML.HasAttribute(CA_SessionIDs) then
      SessionIDsText := ActionXML.Attributes[CA_SessionIDs];
    UserIDsText := '';
    if ActionXML.HasAttribute(CA_UserIDs) then
      UserIDsText := ActionXML.Attributes[CA_UserIDs];

    // Filling SessionIDs array with list of SessionID from node
    DestinationsList.Text := StringReplace(SessionIDsText, ',', #13#10,
      [rfReplaceAll, rfIgnoreCase]);
    SetLength(SessionIDs, DestinationsList.Count);
    if Length(SessionIDs) > 0 then
      for Loop := 0 to DestinationsList.Count - 1 do
        SessionIDs[Loop] := strtointdef(DestinationsList.Strings[Loop], 0);

    // Adding UserIDs from node
    DestinationsList.Clear;
    DestinationsList.Text := StringReplace(UserIDsText, ',', #13#10,
      [rfReplaceAll, rfIgnoreCase]);
    SetLength(UserIDs, DestinationsList.Count);
    if Length(UserIDs) > 0 then
      for Loop := 0 to DestinationsList.Count - 1 do
        UserIDs[Loop] := strtointdef(DestinationsList.Strings[Loop], 0);

    for Loop := 0 to ActionXML.ChildNodes.Count - 1 do
      NotifyUsers(SessionIDs, UserIDs, ActionXML.ChildNodes.Nodes[Loop].XML);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'DoNotify', E.Message, ltException);
  end;

  UserIDs := nil;
  SessionIDs := nil;
  DestinationsList.Free;
end;

procedure TActionServer.NotifyUsers(SessionIDs, UserIDs: array of Integer; Data: String);
var
  Loop: Integer;
  Loop2: Integer;
  Loop3: Integer;

  FSql: TSQLAdapter;
  errCode: integer;

  curSessionID: Integer;
  curUserID: Integer;
  DestinationSessionIDs: array of Integer;
  SessionsCounter: Integer;
  EmptyIndex: Integer;

  Destinations: String;
begin
  FSql := nil;

  SessionsCounter := Length(SessionIDs);
  SetLength(DestinationSessionIDs, SessionsCounter + Length(UserIDs));
  if SessionsCounter > 0 then
    for Loop := 0 to Length(SessionIDs) - 1 do
      DestinationSessionIDs[Loop] := SessionIDs[Loop];

  try
    if Length(UserIDs) > 0 then
    begin
      for Loop := 0 to Length(UserIDs) - 1 do
      begin
        curUserID := UserIDs[Loop];
        curSessionID := 0;

        // Detecting SessionID by UserID
        FUserSessions_CriticalSection.Lock;
        try
          for Loop2 := 0 to Length(FUserSessions) - 1 do
            if FUserSessions[Loop2].UserID = curUserID then
            begin
              curSessionID := FUserSessions[Loop2].SessionID;
              Break;
            end;
        finally
          FUserSessions_CriticalSection.UnLock;
        end;

        //Use Database to find SessionID by UserID from Database
        if curSessionID = 0 then
        begin
          if FSql = nil then
          try
            FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
          except
            on E: Exception do
              CommonDataModule.Log(ClassName, 'NotifyUsers', E.Message, ltException);
          end;

          if FSql <> nil then
          begin
            FSql.SetProcName('apiGetUserSession');
            FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
            FSql.addparam('userId',curUserID,ptInput,ftInteger);
            FSql.addparam('sessionId',curSessionID,ptOutput,ftInteger);
            FSql.addparam('ClientAdapterIP','',ptOutput,ftString);
            FSql.executecommand();
            errCode := FSql.Getparam('RETURN_VALUE');
            if errCode = PO_NOERRORS then
              curSessionID := FSql.Getparam('SessionId');

            if curSessionID > 0 then
            begin
              // Save SessionID for UserID to FUserSessions array
              EmptyIndex := -1;
              FUserSessions_CriticalSection.Lock;
              try
                for Loop2 := 0 to Length(FUserSessions) - 1 do
                  with FUserSessions[Loop2] do
                  begin
                    if UserID = curUserID then
                    begin
                      SessionID := cntDefaultID;
                      UserID := cntDefaultID;
                    end;
                    if (UserID = cntDefaultID) and (EmptyIndex = -1) then
                      EmptyIndex := Loop2;
                  end;

                if EmptyIndex = -1 then
                begin
                  EmptyIndex := Length(FUserSessions);
                  SetLength(FUserSessions, EmptyIndex + 10);
                  for Loop2 := EmptyIndex + 1 to Length(FUserSessions) - 1 do
                    with FUserSessions[Loop] do
                    begin
                      SessionID := cntDefaultID;
                      UserID := cntDefaultID;
                    end;
                end;

                with FUserSessions[EmptyIndex] do
                begin
                  SessionID := curSessionID;
                  UserID := curUserID;
                end;

              finally
                FUserSessions_CriticalSection.UnLock;
              end;
            end;
          end;
        end;

        if curSessionID > 0 then
        begin
          DestinationSessionIDs[SessionsCounter] := curSessionID;
          Inc(SessionsCounter);
        end;
      end;
      SetLength(DestinationSessionIDs, SessionsCounter);
    end;

    // Sending action
    if (SessionsCounter > 0) and (stClientAdapter in CommonDataModule.ServiceModes) then
    begin
      CommonDataModule.NotifyClients(DestinationSessionIDs, Data);

      if Length(FServices) > 0 then
      begin
        for Loop2 := 0 to Length(FClientConnections) - 1 do
          if FClientConnections[Loop2].ServiceID = cntSpecialID then
          begin
            curSessionID := FClientConnections[Loop2].SessionID;
            if curSessionID > 0 then
              for Loop3 := 0 to Length(DestinationSessionIDs) - 1 do
                if curSessionID = DestinationSessionIDs[Loop3] then
                  Dec(SessionsCounter);
          end;
      end
      else
        SessionsCounter := 0;

      if CommonDataModule.Logging then
        CommonDataModule.Log(ClassName, 'NotifyUsers',
          'Processed locally; Action: ' + Data, ltResponse);
    end;

    if (SessionsCounter > 0) and (Length(FServices) > 0) then
      for Loop := 0 to Length(FServices) - 1 do
        with FServices[Loop] do
        begin
          if (ServiceIP <> '') and (stClientAdapter in SupportedModes) then
          begin
            Destinations := '';
            FConnections_CriticalSection.Lock;
            try
              for Loop2 := 0 to Length(FClientConnections) - 1 do
              begin
                if FClientConnections[Loop2].ServiceID = Loop then
                begin
                  curSessionID := FClientConnections[Loop2].SessionID;
                  if curSessionID > 0 then
                    for Loop3 := 0 to Length(DestinationSessionIDs) - 1 do
                      if curSessionID = DestinationSessionIDs[Loop3] then
                      begin
                        if Destinations <> '' then
                          Destinations := Destinations + ',';
                        Destinations := Destinations + inttostr(curSessionID);
                        Dec(SessionsCounter);
                        Break;
                      end;
                end;
                if SessionsCounter = 0 then
                  Break;
              end;
            finally
              FConnections_CriticalSection.UnLock;
            end;

            if Destinations <> '' then
            try
              SessionProcessor.SendCommand(cntHeaderClientAdapterSignature + Destinations +
                cntHeaderEndSignature + Data);

              if CommonDataModule.Logging then
                CommonDataModule.Log(ClassName, 'NotifyUsers',
                  'Sent to Service: ' + ServiceIP + ':' + inttostr(ServicePort) + 
                  '; SessionIDs: ' + Destinations +
                  '; Action: ' + Data, ltResponse);
            except
              on E: Exception do
                CommonDataModule.Log(ClassName, 'NotifyUsers', E.Message, ltException);
            end;
          end;
        end;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'NotifyUsers', E.Message, ltException);
  end;

  if FSQL <> nil then
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);

  if SessionsCounter > 0 then
    if CommonDataModule.Logging then
      CommonDataModule.Log(ClassName, 'NotifyUsers',
        'Action did not sent to all recipients', ltError);
end;

procedure TActionServer.DoNotifyAll(ActionXML: IXMLNode);
begin
  if ActionXML.ChildNodes.Count = 0 then
  begin
    CommonDataModule.Log(ClassName, 'DoNotifyAll',
      'Action packet was arrived without child nodes', ltError);
    Exit;
  end;

  ActionXML.OwnerDocument.DocumentElement.ChildNodes.Nodes[0].
    Attributes[PO_ATTRNAME] := OBJ_CLIENTADAPTER;
  NotifyAllClients(ActionXML.OwnerDocument.DocumentElement.XML);
end;

procedure TActionServer.NotifyAllClients(ActionText: String);
var
  Loop: Integer;
begin
  for Loop := 0 to Length(FServices) - 1 do
  with FServices[Loop] do
    if (ServiceIP <> '') and (stClientAdapter in SupportedModes) then
    try
      SessionProcessor.SendCommand(ActionText);
    except
      on E: Exception do
        CommonDataModule.Log(ClassName, 'NotifyAllClients', E.Message, ltException);
    end;

  if stClientAdapter in CommonDataModule.ServiceModes then
    CommonDataModule.ProcessAction(ActionText);

  CommonDataModule.Log(ClassName, 'NotifyAllClients',
    '; Action: ' + ActionText, ltResponse);
end;



// Processes

procedure TActionServer.DoProcessStopped(ActionXML: IXMLNode);
var
  curProcessID: Integer;
  Loop: Integer;
  SQL: TSQLAdapter;
begin
  curProcessID := strtointdef(ActionXML.Attributes[PO_ATTRPROCESSID], 0);

  FProcesses_CriticalSection.Lock;
  try
    for Loop := 0 to Length(FProcesses) - 1 do
      with FProcesses[Loop] do
        if ProcessID = curProcessID then
        begin
          ProcessID := cntDefaultID;
          ServiceID := cntDefaultID;
        end;
  finally
    FProcesses_CriticalSection.UnLock;
  end;

  SQL := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    SQL.Execute('exec gaUnRegisterProcess ' + inttostr(curProcessID));
  except
    on e: Exception do
      CommonDataModule.Log(ClassName, 'DoProcessStopped',
        '[EXCEPTION] On execute gaUnRegisterProcess ' +
          inttostr(curProcessID) + ': Message: ' + E.Message, ltException);
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(SQL);

  CommonDataModule.Log(ClassName, 'ProcessGameAction',
    'ProcessID=' + inttostr(curProcessID) + ' processing was stopped', ltBase);
end;

// To Game Adapter
procedure TActionServer.ProcessGameAction(curProcessID: Integer; const ActionText: String);
var
  Loop: Integer;
  Loop2: Integer;
  curServiceID: Integer;
  SendResult: String;
  ActionSent: Boolean;
  fndServices: array of Integer;
  fndProcesses: array of Integer;
  nCount: Integer;
  MinIndex: Integer;
  SQL: TSQLAdapter;
  FoundProcess: Boolean;
  EmptyIndex: Integer;
  FullServiceIP: String;
begin
  if CommonDataModule.Logging then
    CommonDataModule.Log(ClassName, 'ProcessGameAction', 'Processing ProcessID=' +
      inttostr(curProcessID) + '; Action=' + ActionText, ltCall);

  curServiceID := cntDefaultID;
  FProcesses_CriticalSection.Lock;
  try
    for Loop := 0 to Length(FProcesses) - 1 do
      with FProcesses[Loop] do
        if ProcessID = curProcessID then
          if ServiceID = cntDefaultID then
            ProcessID := cntDefaultID
          else
          begin
            curServiceID := ServiceID;
            Break;
          end;
  finally
    FProcesses_CriticalSection.UnLock;
  end;

  if curServiceID = cntDefaultID then
  begin
    SetLength(fndServices, Length(FServices) + 1);
    nCount := 0;

    for Loop := 0 to Length(FServices) - 1 do
      with FServices[Loop] do
        if (ServiceIP <> '') and (stGameAdapter in SupportedModes) and
          (ActionDispatcherID = CommonDataModule.ActionDispatcherID) then
        begin
          fndServices[nCount] := Loop;
          Inc(nCount);
        end;

    if stGameAdapter in CommonDataModule.ServiceModes then
    begin
      fndServices[nCount] := cntSpecialID;
      Inc(nCount);
    end;

    if nCount = 0 then
    begin
      CommonDataModule.Log(ClassName, 'ProcessGameAction',
        'Service with GameAdapter mode did not found in Services List', ltError);
      Exit;
    end
    else
    if nCount = 1 then
      curServiceID := fndServices[0]
    else
    begin
      SetLength(fndServices, nCount);
      SetLength(fndProcesses, nCount);

      FProcesses_CriticalSection.Lock;
      try
        for Loop := 0 to nCount - 1 do
        begin
          fndProcesses[Loop] := 0;
          for Loop2 := 0 to Length(FProcesses) - 1 do
            if FProcesses[Loop2].ServiceID = fndServices[Loop] then
              Inc(fndProcesses[Loop]);
        end;
      finally
        FProcesses_CriticalSection.UnLock;
      end;

      MinIndex := 0;
      for Loop := 1 to nCount - 1 do
        if fndProcesses[Loop] < fndProcesses[MinIndex] then
          MinIndex := Loop;

      curServiceID := fndServices[MinIndex];
    end;

    FoundProcess := False;
    EmptyIndex := -1;
    FProcesses_CriticalSection.Lock;
    try
      for Loop := 0 to Length(FProcesses) - 1 do
        with FProcesses[Loop] do
        begin
          if curProcessID = ProcessID then
          begin
            curServiceID := ServiceID;
            if curServiceID <> cntDefaultID then
            begin
              FoundProcess := True;
              Break;
            end
            else
              ProcessID := cntDefaultID;
            if (EmptyIndex = -1) and
              (ProcessID = cntDefaultID) and (curServiceID = cntDefaultID) then
              EmptyIndex := Loop;
          end;
        end;

      if not FoundProcess then
      begin
        if EmptyIndex = -1 then
        begin
          EmptyIndex := Length(FProcesses);
          SetLength(FProcesses, EmptyIndex + 10);
          for Loop2 := EmptyIndex + 1 to Length(FProcesses) - 1 do
            with FProcesses[Loop2] do
            begin
              ProcessID := cntDefaultID;
              ServiceID := cntDefaultID;
            end;
        end;

        with FProcesses[EmptyIndex] do
        begin
          ProcessID := curProcessID;
          ServiceID := curServiceID;
        end;
      end;
    finally
      FProcesses_CriticalSection.UnLock;
    end;

    if not FoundProcess then
    try
      if curServiceID = cntSpecialID then
        FullServiceIP := CommonDataModule.LocalIP
      else
        FullServiceIP := FServices[curServiceID].ServiceIP + ':' +
        inttostr(FServices[curServiceID].ServicePort);

      SQL := CommonDataModule.ObjectPool.GetSQLAdapter;
      try
        SQL.Execute('exec gaRegisterProcess ' + inttostr(curProcessID) + ',''' +
          FullServiceIP + '''');

        CommonDataModule.Log(ClassName, 'ProcessGameAction',
          'ProcessID=' + inttostr(curProcessID) + ' processing was started on ' +
          FullServiceIP, ltBase);
      finally
        CommonDataModule.ObjectPool.FreeSQLAdapter(SQL);
      end;
    except
      on e: Exception do
        CommonDataModule.Log(ClassName, 'DoProcessStopped', E.Message, ltException);
    end;
  end;

  if curServiceID <> cntDefaultID then
  try
    SendResult := '';
    ActionSent := False;

    if curServiceID = cntSpecialID then
    begin
      // Processed locally
      CommonDataModule.ProcessGameAction(curProcessID, ActionText);
      SendResult := 'Processed locally';
      ActionSent := True;
    end
    else
    // Send to ActionClient
    try
      FServices[curServiceID].SessionProcessor.SendCommand(cntHeaderGameAdapterSignature +
        inttostr(curProcessID) + cntHeaderEndSignature + ActionText);
      ActionSent := True;

      if CommonDataModule.Logging then
        if ActionSent then
          CommonDataModule.Log(ClassName, 'ProcessGameAction',
            'Sent to Service:' + FServices[curServiceID].ServiceIP + ':' +
            inttostr(FServices[curServiceID].ServicePort) +
            '; ProcessID:' + inttostr(curProcessID) +
            '; Action: ' + ActionText, ltCall);
    except
      on E: Exception do
        CommonDataModule.Log(ClassName, 'ProcessGameAction', E.Message, ltException);
    end;

    if CommonDataModule.Logging then
      if not ActionSent then
        CommonDataModule.Log(ClassName, 'ProcessGameAction',
          'Action did not sent: ' + ActionText, ltError);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'ProcessGameAction', E.Message, ltException);
  end
  else
    CommonDataModule.Log(ClassName, 'ProcessGameAction',
      'Game action was not processed', ltError);

  fndServices := nil;
  fndProcesses := nil;
end;


procedure TActionServer.NotifyAllProcesses(ActionText: String);
var
  Loop: Integer;
begin
  for Loop := 0 to Length(FServices) - 1 do
  with FServices[Loop] do
    if (ServiceIP <> '') and (stGameAdapter in SupportedModes) then
    try
      SessionProcessor.SendCommand(ActionText);
    except
      on E: Exception do
        CommonDataModule.Log(ClassName, 'NotifyAllProcesses', E.Message, ltException);
    end;

  if stGameAdapter in CommonDataModule.ServiceModes then
    CommonDataModule.ProcessAction(ActionText);

  CommonDataModule.Log(ClassName, 'NotifyAllProcesses','Action: ' + ActionText, ltResponse);
end;

end.
