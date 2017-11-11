unit uActionDispatcher;

interface

uses
  Classes, SysUtils, Contnrs, SyncObjs,
  xmldom, XMLIntf, msxmldom, XMLDoc,
  uClientAdapter, uActionClient, uActionServer,
  uMSMQReader, uMSMQWriter, uReminder, uTournament, uGameAdapter, uSettings, uLocker;

type
  TActionProcesss = record
    ActionDispatcherID: Integer;
    ProcessID: Integer;
  end;

  TActionDispatcher = class
  private
    FRunning: Boolean;
    FGracefullyStopped: Boolean;
    FFullyStopped: Boolean;
    FLastResumeTime: TDateTime;
    ClientAdapter: TClientAdapter;
    ActionServer: TActionServer;
    MSMQReader: TMSMQReader;
    MSMQWriter: TMSMQWriter;
    Reminder: TReminder;
    Tournament: TTournament;
    GameAdapter: TGameAdapter;
    ActionClient: TActionClient;
    ActionClientList: TObjectList;
    LastConnectedStatus: Boolean;
    ActionProcessesList: array of TActionProcesss;
    ActionProcessesList_CriticalSection: TLocker;

    procedure ClearPointers;
    procedure CheckIsConnected;
    procedure ConnectAllActionClients;
  public
    procedure RingUp;
    procedure SendToAllActionClients(Data: String);
    procedure SendToAllActionServers(Data: String);
    procedure ProcessAction(XMLNode: IXMLNode; var Handled: Boolean);
    function DispatchGameAction(ProcessID, ActionDispatcherID: Integer;
      const ActionText: String): Boolean;
    procedure ProcessGameAction(ProcessID: Integer; const ActionText: String);
    procedure NotifyUsers(SessionIDs, UserIDs: array of Integer; const Data: String;
      UseLocalClientAdapter: Boolean = False);
    procedure NotifyClients(SessionIDs: array of Integer; const Data: String);

    constructor Create;
    destructor Destroy; override;
  end;

var
  ActionDispatcher: TActionDispatcher;

    
implementation

uses
  uCommonDataModule, uXMLConstants, uErrorConstants, uLogger,
  TypInfo, uSQLAdapter, DateUtils, DB;


{ TActionDispatcher }

constructor TActionDispatcher.Create;
var
  FSql: TSQLAdapter;
  RS: TDataSet;
  aSQL: String;
  curID: Integer;
  curIP: String;
  curPort: String;
  curActionClient: TActionClient;
begin
  inherited;
  FRunning := False;

  try
    ClearPointers;
    FGracefullyStopped := False;
    FFullyStopped := False;
    LastConnectedStatus := False;
    FLastResumeTime := Now;

    ActionClientList := TObjectList.Create;
    SetLength(ActionProcessesList, 0);
    ActionProcessesList_CriticalSection := CommonDataModule.ThreadLockHost.Add('actiondispatcher');

    if stActionDispatcher in CommonDataModule.ServiceModes then
      ActionServer := TActionServer.Create
    else
    begin
      FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
      try
        aSQL:='exec apiGetActionDispatchersList';
        RS := FSql.Execute(aSQL);
        RS.First;
        while not RS.Eof do
        begin
          curID := RS.FieldByName('ID').AsInteger;
          curIP := RS.FieldByName('IP').AsString;
          curPort := inttostr(RS.FieldByName('port').AsInteger);
          curActionClient := TActionClient.Create(curID, curIP, curPort);
          ActionClientList.Add(curActionClient);
          if curID = CommonDataModule.ActionDispatcherID then
            ActionClient := curActionClient;
          RS.Next;
        end;
      except
        on E:Exception do
          CommonDataModule.Log(ClassName, 'Create', E.Message, ltException);
      end;

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      aSQL := '';

      if ActionClientList.Count = 0 then
        CommonDataModule.Log(ClassName, 'Create', 'ActionClientList is empty', ltError);
    end;

    ConnectAllActionClients;

    if stMSMQReader in CommonDataModule.ServiceModes then
      MSMQReader := TMSMQReader.Create;

    if stMSMQWriter in CommonDataModule.ServiceModes then
      MSMQWriter := TMSMQWriter.Create;

    if stReminder in CommonDataModule.ServiceModes then
      Reminder := TReminder.Create;

    if stClientAdapter in CommonDataModule.ServiceModes then
      ClientAdapter := TClientAdapter.Create;

    if stGameAdapter in CommonDataModule.ServiceModes then
      GameAdapter := TGameAdapter.Create;

    if stTournament in CommonDataModule.ServiceModes then
      Tournament := TTournament.Create;

    CommonDataModule.Log(ClassName, 'Create', 'Created successfully', ltBase);
    FRunning := True;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Create',E.Message, ltException);
  end;
end;

destructor TActionDispatcher.Destroy;
begin
  FRunning := False;
  try
    ActionClientList.Clear;

    if GameAdapter <> nil then
      FreeAndNil(GameAdapter);

    if Tournament <> nil then
      FreeAndNil(Tournament);

    if Reminder <> nil then
      FreeAndNil(Reminder);

    if MSMQReader <> nil then
      FreeAndNil(MSMQReader);

    if MSMQWriter <> nil then
      FreeAndNil(MSMQWriter);

    if ActionServer <> nil then
      FreeAndNil(ActionServer);

    if ClientAdapter <> nil then
      FreeAndNil(ClientAdapter);

    ClearPointers;
    ActionClientList.Free;
    SetLength(ActionProcessesList, 0);
    
    CommonDataModule.ThreadLockHost.Del(ActionProcessesList_CriticalSection);
    CommonDataModule.Log(ClassName, 'Destroy', 'Destroyed successfully', ltBase);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Destroy', E.Message, ltException);
  end;

  inherited;
end;

procedure TActionDispatcher.ClearPointers;
begin
  ActionServer := nil;
  ActionClient := nil;
  MSMQReader := nil;
  MSMQWriter := nil;
  Reminder := nil;
  Tournament := nil;
  GameAdapter := nil;
end;

procedure TActionDispatcher.ProcessAction(XMLNode: IXMLNode; var Handled: Boolean);
var
  XMLRoot: IXMLNode;
  strNode: String;
  ADSignatureCount: Integer;
  curProcessID: Integer;
  curActionDispatcherID: Integer;
  Loop: Integer;
begin
  Handled := False;
  if not FRunning then
    Exit;

  strNode := lowercase(XMLNode.Attributes[PO_ATTRNAME]);
  XMLRoot := XMLNode.OwnerDocument.DocumentElement;
  ADSignatureCount := 0;
  if XMLRoot.HasAttribute(AD_Signatute) then
    ADSignatureCount := strtointdef(XMLRoot.Attributes[AD_Signatute], 1);

  if (strNode = OBJ_GameAdapter) and (GameAdapter <> nil) and
    (stGameAdapter in CommonDataModule.ServiceModes) and (ADSignatureCount > 0) then
  begin
    Handled := True;
    GameAdapter.ProcessAction(XMLNode);
  end
  else
  if (strNode = OBJ_ClientAdapter) and (ClientAdapter <> nil) and
    (stClientAdapter in CommonDataModule.ServiceModes) then
  begin
    Handled := True;
    ClientAdapter.ProcessAction(XMLNode);
  end
  else
  if (strNode = OBJ_Tournament) and (Tournament <> nil) and
    (stTournament in CommonDataModule.ServiceModes) then
  begin
    Handled := True;
    Tournament.ProcessAction(XMLNode);
  end
  else
  if (strNode = OBJ_Reminder) and (Reminder <> nil) and
    (stReminder in CommonDataModule.ServiceModes) then
  begin
    Handled := True;
    Reminder.ProcessAction(XMLNode);
  end
  else
  if (strNode = OBJ_MSMQWriter) and (MSMQWriter <> nil) and
    (stMSMQWriter in CommonDataModule.ServiceModes) then
  begin
    Handled := True;
    MSMQWriter.ProcessAction(XMLNode);
  end
  else
  if (strNode = OBJ_ACTIONDISP) and (ActionServer <> nil) and
    (stActionDispatcher in CommonDataModule.ServiceModes) then
  begin
    Handled := True;
    ActionServer.ProcessAction(XMLNode);
  end;

  if not Handled then
  begin
    if ADSignatureCount > 10 then
    begin
      Handled := True;
      CommonDataModule.Log(ClassName, 'ProcessAction', 'ADSignatureCount > 10', ltError);
    end
    else
    begin
      XMLRoot.Attributes[AD_Signatute] := ADSignatureCount + 1;

      if ActionServer <> nil then
      begin
        Handled := True;
        ActionServer.DispatchAction(XMLRoot);
      end
      else
      begin
        if XMLRoot.ChildNodes.Nodes[0].HasAttribute('sendtoall') then
        begin
          Handled := True;
          SendToAllActionServers(XMLRoot.XML);
        end
        else
          if strNode = OBJ_GameAdapter then
          begin
            curProcessID := 0;
            if XMLNode.ChildNodes.Nodes[0].HasAttribute(PO_ATTRPROCESSID) then
              curProcessID := strtointdef(XMLNode.ChildNodes.Nodes[0].
                Attributes[PO_ATTRPROCESSID], 0);

            curActionDispatcherID := 0;
            if XMLNode.ChildNodes.Nodes[0].HasAttribute(AD_ActionDispatcherID) then
              curActionDispatcherID := strtointdef(XMLNode.ChildNodes.Nodes[0].
                Attributes[AD_ActionDispatcherID], 0);

            for Loop := 0 to XMLNode.ChildNodes.Count - 1 do
              Handled := Handled or DispatchGameAction(curProcessID, curActionDispatcherID,
                XMLNode.ChildNodes.Nodes[Loop].XML);
          end
          else
            if ActionClient <> nil then
            begin
              ActionClient.SendAction(XMLRoot.XML);
              Handled := True;
            end;
      end;
    end;
  end;
  strNode := '';
end;

procedure TActionDispatcher.CheckIsConnected;
var
  Loop: Integer;
  IsConnected: Boolean;
begin
  IsConnected := False;
  try
    IsConnected := ActionServer <> nil;

    if not IsConnected then
    begin
      IsConnected := True;
      for Loop := 0 to ActionClientList.Count - 1 do
        with TActionClient(ActionClientList.Items[Loop]) do
        if not Connected then
        begin
          IsConnected := False;
          Break;
        end;
    end;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'CheckIsConnected', E.Message, ltException);
  end;
  CommonDataModule.Connected := IsConnected;
end;

procedure TActionDispatcher.ConnectAllActionClients;
var
  Loop: Integer;
begin
  try
    for Loop := 0 to ActionClientList.Count - 1 do
      TActionClient(ActionClientList.Items[Loop]).Connect;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'ConnectAllActionClients', E.Message, ltException);
  end;
end;

procedure TActionDispatcher.SendToAllActionServers(Data: String);
var
  Loop: Integer;
begin
  if not FRunning then
    Exit;

  for Loop := 0 to ActionClientList.Count - 1 do
  try
    TActionClient(ActionClientList.Items[Loop]).SendAction(Data);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'SendToAllActionServers', E.Message, ltException);
  end
end;

procedure TActionDispatcher.SendToAllActionClients(Data: String);
begin
  if not FRunning then
    Exit;

  if ActionServer <> nil then
    ActionServer.SendToAll(Data);
end;

procedure TActionDispatcher.RingUp;
begin
  if not FRunning then
    Exit;

  try
    CheckIsConnected;
    if CommonDataModule.Connected <> LastConnectedStatus then
    begin
      if CommonDataModule.Connected then
      begin
        if ClientAdapter <> nil then
          ClientAdapter.Continue;
      end
      else
      begin
        if ClientAdapter <> nil then
          ClientAdapter.Pause;
        if GameAdapter <> nil then
          GameAdapter.Stop;
      end;
      LastConnectedStatus := CommonDataModule.Connected;
    end;

    if GameAdapter <> nil then
      GameAdapter.RingUp;

    if ClientAdapter <> nil then
      ClientAdapter.RingUp;

    if ActionServer <> nil then
      ActionServer.RingUp;

    ConnectAllActionClients;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'RingUp', E.Message, ltException);
  end;
end;

procedure TActionDispatcher.NotifyClients(SessionIDs: array of Integer; const Data: String);
begin
  if not FRunning then
    Exit;

  if ClientAdapter <> nil then
    ClientAdapter.NotifyClients(SessionIDs, Data)
  else
    CommonDataModule.Log(ClassName, 'NotifyClients', 'ClientAdapter does not exists', ltError);
end;

procedure TActionDispatcher.NotifyUsers(SessionIDs, UserIDs: array of Integer;
  const Data: String; UseLocalClientAdapter: Boolean = False);
var
  Handled: Boolean;

  Destinations: String;
  Loop: Integer;

begin
  Handled := False;
  if not FRunning then
    Exit;

  if UseLocalClientAdapter and (ClientAdapter <> nil) and
    (Length(SessionIDs) = 1) and (Length(UserIDs) = 0) then
    ClientAdapter.NotifyClient(SessionIDs[0], Data, Handled);

  if (not Handled) and (ActionServer <> nil) then
  begin
    ActionServer.NotifyUsers(SessionIDs, UserIDs, Data);
    Handled := True;
  end;

  if (not Handled) and (ActionClient <> nil) then
  begin
    Destinations := '';

    // Fill sessions
    if Length(SessionIDs) > 0 then
    begin
      for Loop := 0 to Length(SessionIDs) - 1 do
      begin
        Destinations := Destinations + inttostr(SessionIDs[Loop]);
        if Loop < (Length(SessionIDs) - 1) then
          Destinations := Destinations + ',';
      end;
    end;
    Destinations := Destinations + ';';

    // Fill users
    if Length(UserIDs) > 0 then
    begin
      for Loop := 0 to Length(UserIDs) - 1 do
      begin
        Destinations := Destinations + inttostr(UserIDs[Loop]);
        if Loop < (Length(UserIDs) - 1) then
          Destinations := Destinations + ',';
      end;
    end;

    ActionClient.SendAction(cntHeaderClientAdapterSignature + Destinations +
      cntHeaderEndSignature + Data);
  end;
end;

procedure TActionDispatcher.ProcessGameAction(ProcessID: Integer; const ActionText: String);
begin
  if not FRunning then
    Exit;

  if GameAdapter <> nil then
    GameAdapter.ProcessGameAction(ProcessID, ActionText)
  else
    CommonDataModule.Log(ClassName, 'ProcessGameAction', 'GameAdapter does not exists', ltError);
end;

function TActionDispatcher.DispatchGameAction(ProcessID, ActionDispatcherID: Integer;
  const ActionText: String): Boolean;
var
  curActionDispatcherID: Integer;
  FSql: TSQLAdapter;
  errCode: integer;
  Loop: Integer;
  strAction: String;
begin
  Result := False;
  if not FRunning then
    Exit;

  if ActionServer <> nil then
  begin
    ActionServer.ProcessGameAction(ProcessID, ActionText);
    Result := True;
  end
  else
  begin
    if ProcessID <= 0 then
      curActionDispatcherID := CommonDataModule.ActionDispatcherID
    else
      curActionDispatcherID := ActionDispatcherID;

    if (ProcessID > 0) and (curActionDispatcherID = 0) then
    begin
      ActionProcessesList_CriticalSection.Lock;
      try
        for Loop := 0 to Length(ActionProcessesList) - 1 do
          if ActionProcessesList[Loop].ProcessID = ProcessID then
          begin
            curActionDispatcherID := ActionProcessesList[Loop].ActionDispatcherID;
            Break;
          end;
      finally
        ActionProcessesList_CriticalSection.UnLock;
      end;

      if curActionDispatcherID = 0 then
      try
        FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
        try
          FSql.SetProcName('apiGetActionDispatcherIDbyProcessID');
          FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
          FSql.addparam('ProcessID',ProcessID,ptInput,ftInteger);
          FSql.addparam('ActionDispatcherID',curActionDispatcherID,ptOutput,ftInteger);
          FSql.executecommand();
          errCode := FSql.Getparam('RETURN_VALUE');
          if errCode = PO_NOERRORS then
            curActionDispatcherID := FSql.Getparam('ActionDispatcherID');
        finally
          CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
        end;

        ActionProcessesList_CriticalSection.Lock;
        try
          Loop := Length(ActionProcessesList);
          SetLength(ActionProcessesList, Loop + 1);
          ActionProcessesList[Loop].ActionDispatcherID := curActionDispatcherID;
          ActionProcessesList[Loop].ProcessID := ProcessID;
        finally
          ActionProcessesList_CriticalSection.UnLock;
        end;
      except
        on E:Exception do
          CommonDataModule.Log(ClassName, 'ProcessAction', E.Message, ltException);
      end;
    end;

    if curActionDispatcherID > 0 then
    begin
      strAction := cntHeaderGameAdapterSignature + inttostr(ProcessID) +
        cntHeaderEndSignature + ActionText;
      if (curActionDispatcherID = CommonDataModule.ActionDispatcherID) and
        (ActionClient <> nil) then
      begin
        ActionClient.SendAction(strAction);
        Result := True;
      end
      else
        for Loop := 0 to ActionClientList.Count - 1 do
          if TActionClient(ActionClientList.Items[Loop]).
            ActionDispatcherID = curActionDispatcherID then
          begin
            TActionClient(ActionClientList.Items[Loop]).SendAction(strAction);
            Result := True;
            Break;
          end;
    end;
  end;
end;


end.

