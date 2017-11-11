unit uGameProcessThread;

interface

uses
  Classes, ActiveX, Contnrs, SyncObjs,
  uGameConnector, uLocker;

type
  TProcessState = (psNone, psRunning, psIdle, psStopped);

  TGameProcessThread = class(TThread)
  private
    FProcessID: Integer;
    FProcessLastFailure: Boolean;
    FGameConnector: TGameConnector;
    FGameConnectorState: String;
    FStopSleep: Boolean;

    FInputActions: String;
    FLastTimeActivity: TDateTime;
    FCriticalSection_InputAction: TLocker;

    FProcessState: TProcessState;
    FCriticalSection_ProcessState: TLocker;

    function  SaveProcessContext(SaveProcessState: Boolean= True): Boolean;
    procedure LoadProcessContext;
    procedure ReinitProcess(ErrorString: String);
  protected
    procedure Execute; override;

  public
    property ProcessID: Integer read FProcessID;
    property ProcessState: TProcessState read FProcessState;
    property LastTimeActivity: TDateTime read FLastTimeActivity;

    procedure ProcessAction(ActionXML: String);

    constructor Create(AProcessID: Integer);
    destructor  Destroy; override;
  end;

implementation

uses
  SysUtils, ComObj
  , uCommonDataModule
  , uLogger
  , uSQLAdapter
  , uApi
  , uAccount
  , uEMail
  , uObjectPool
  , uErrorConstants
  , uXMLConstants
  , uSettings
  , uSQLTools
  , DateUtils, DB;

{ TGameProcessThread }

// Create and Destroy

constructor TGameProcessThread.Create(AProcessID: Integer);
begin
  inherited Create(True);

  try
    FProcessID := AProcessID;
    FProcessState := psNone;
    FProcessLastFailure := False;

    FInputActions := '';
    FLastTimeActivity := Now;
    FGameConnectorState := '';
    FCriticalSection_InputAction := CommonDataModule.ThreadLockHost.Add('inputaction');
    FCriticalSection_ProcessState := CommonDataModule.ThreadLockHost.Add('processtate');
    FGameConnector := TGameConnector.Create;
    LoadProcessContext;
    FGameConnector.UpdateProcState;

    CommonDataModule.Log(ClassName, 'Create', 'Created successfully', ltBase);
    FStopSleep := False;
    Resume;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Create',E.Message, ltException);
  end;
end;

destructor TGameProcessThread.Destroy;
begin
  try
    FStopSleep := True;
    Terminate;
    WaitFor;

    FProcessState := psNone;

    FGameConnector.Free;

    CommonDataModule.SendToAllServers(
      '<objects><object name="' + OBJ_ACTIONDISP + '">' +
      '<' + AD_ProcessStopped + ' ' + PO_ATTRPROCESSID + '="' + inttostr(FProcessID) + '"/>' +
      '</object></objects>');

    CommonDataModule.ThreadLockHost.Del(FCriticalSection_InputAction);
    CommonDataModule.ThreadLockHost.Del(FCriticalSection_ProcessState);

    CommonDataModule.Log(ClassName, 'Destroy', 'Destroyed successfully', ltBase);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Destroy', E.Message, ltException);
  end;

  inherited;
end;

// Context

procedure TGameProcessThread.LoadProcessContext;
var
  ErrResult: Integer;
  ErrString: String;

  API: TAPI;
  State: String;

  SQL: TSQLAdapter;
  RS: TDataSet;
begin
  CommonDataModule.Log(ClassName, 'LoadProcessContext',
    'ProcessID=' + IntToStr(ProcessID), ltCall);

  SQL := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    RS := SQL.Execute('select [ID], [StatusId] from GameProcess (nolock) where [ID]=' +
      inttostr(FProcessID));
    RS.First;
    if rsInt(RS, 'StatusId') <> 1 then
      FProcessState := psStopped;
  except
    on E:Exception do
    begin
      CommonDataModule.Log(Classname, 'LoadProcessContext',
         'Get StatusId value failed for Processid=' + IntToStr(ProcessID) +
         ': ' + E.Message, ltException);
      FProcessState := psStopped;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(SQL);

  if FProcessState = psStopped then
  begin
    CommonDataModule.Log(ClassName, 'LoadProcessContext',
      'ProcessID=' + IntToStr(ProcessID) + ' is stopped', ltError);
    Exit;
  end;

  API := CommonDataModule.ObjectPool.GetAPI;
  FCriticalSection_ProcessState.Lock;
  try
    try
      // load state info
      ErrResult := API.GetState(ProcessID, 1, State);
      if ErrResult = PO_NOERRORS then
      begin
        ErrResult := FGameConnector.SetContext(State, ErrString);
        if ErrResult = PO_NOERRORS then
          FGameConnectorState := State;
      end;
    except
      ErrResult := SQ_ERR_STATENOTFOUND;
    end;
  finally
    FCriticalSection_ProcessState.UnLock;
    CommonDataModule.ObjectPool.FreeAPI(API);
  end;

  if ErrResult <> PO_NOERRORS then
    CommonDataModule.Log(ClassName, 'LoadProcessContext',
      'Cant Set Engine context: ' + ErrString, ltError);

  ErrString := '';
  State := '';
end;

function TGameProcessThread.SaveProcessContext(SaveProcessState: Boolean= True): Boolean;
var
  ErrResult: Integer;
  ErrString: String;

  State: String;
  SrvState: String;

  API: TAPI;
begin
  Result := False;
  CommonDataModule.Log(ClassName, 'StoreToDB', 'ProcessID=' + IntToStr(ProcessID), ltCall);

  FCriticalSection_ProcessState.Lock;
  try
    ErrResult := FGameConnector.GetContext(State, SrvState, ErrString);
    if ErrResult <> PO_NOERRORS then
      ReinitProcess('On SaveProcessContext')
    else
      FGameConnectorState := State;

    API := CommonDataModule.ObjectPool.GetAPI;
    try
      if SaveProcessState then
        ErrResult := API.SetState(ProcessID, 1, State)
      else
        ErrResult := PO_NOERRORS;
        
      if ErrResult = PO_NOERRORS then
      begin
        ErrResult := API.SetState(ProcessID, 999, SrvState);
        if ErrResult = PO_NOERRORS then
          Result := True;
      end;
    except
      on E: Exception do
        CommonDataModule.Log(ClassName, 'SaveProcessContext', E.Message, ltException);
    end;
    CommonDataModule.ObjectPool.FreeAPI(API);
  finally
    FCriticalSection_ProcessState.UnLock;
  end;

  ErrString := '';
  State := '';
  SrvState := '';
end;


// Process actions

procedure TGameProcessThread.ReinitProcess(ErrorString: String);
var
  strSQL: string;
  SQL: TSQLAdapter;
  API: TAPI;
  Account: TAccount;
  Email: TEMail;
  curSessionID: Integer;
  TournamentID: Integer;
  Packet: String;
  ErrString: String;
  ErrResult: Integer;
  RS: TDataSet;
  UsersCount: Integer;
begin
  CommonDataModule.Log(ClassName, 'ReinitProcess',
    'ProcessID=' + inttostr(FProcessID), ltCall);

  FInputActions := '';
  UsersCount := 0;
  FProcessState := psStopped;
  try
    SQL := CommonDataModule.ObjectPool.GetSQLAdapter;
    API := CommonDataModule.ObjectPool.GetAPI;
    Account := CommonDataModule.ObjectPool.GetAccount;
    Email := CommonDataModule.ObjectPool.GetEmail;

    ErrResult := PO_NOERRORS;

    try
      // 0 Hide ProcessID if needed
      if FProcessLastFailure then
      try
        SQL.Execute('update gameprocess set statusid=2 where [id]=' + inttostr(FProcessid));
      except
        on E:Exception do
          CommonDataModule.Log(ClassName, 'ReinitProcess', E.Message, ltException);
      end;

      FProcessLastFailure := True;
      // 1 Notify All Participants About Crash
      try
        ErrString := 'Error when Notify All Participants About Crash';
        strSQL := 'exec gaGetParticipantSessionListAfterCrash @processId=' +
          IntToStr(FProcessID);
        Packet :=
          '<object name="process" id="' + IntToStr(FProcessID) +'">' +
          '<gacrash processid="' + IntToStr(FProcessid) + '"/>' +
          '</object>';
        RS := SQL.Execute(strSQL);
        RS.First;
        while not RS.Eof do
        begin
          curSessionID := 0;
          Inc(UsersCount);
          try
            curSessionID := RS.FieldByName('sessionId').AsInteger;
          except
          end;
          if curSessionID > 0 then
          begin
            CommonDataModule.NotifyUser(curSessionID, Packet);
            CommonDataModule.Log(ClassName, 'StopProcess',
              'Notify SessionID=' + IntToStr(curSessionId) +
              ' about Crash of ProcessID=' + inttostr(FProcessID), ltResponse);
          end;
          RS.Next;
        end;
      except
        on E:Exception do
          CommonDataModule.Log(ClassName, 'StopProcess',
            '[EXCEPTION] ' + ErrString + ', ' + E.Message, ltException);
      end;

      // 2 Check for tournament process
      ErrString := 'Error when Check for tournament process';
      SQL.SetProcName('gaGetTournamentInfo');
      SQL.AddParam('RETURN_VALUE',0,ptResult,ftInteger);
      SQL.AddParam('processID',FProcessId,ptInput,ftInteger);
      SQL.AddParam('tournamentId',0,ptOutput,ftInteger);
      SQL.ExecuteCommand();
      TournamentID := SQL.GetParam('tournamentId');

      // 3 Reinit Table
      ErrString := 'Error when Reinit Table';
      if TournamentID = 0 then
      begin
        ErrResult := API.InitProcess(FProcessID);
        API.SetParticipantCount(FProcessID, 0, 0);
      end;

      // 4 Return money to the gamer
      ErrString := 'Error when return money to the gamers';
      if TournamentID = 0 then
        ErrResult := Account.ReturnAllMoneyFromGameProcess(FProcessID)
      else
      begin
        Packet := '<objects><object name="' + OBJ_TOURNAMENT + '" id="0">' +
          '<processcrash tournamentid="' + IntToStr(TournamentID) +
          '" processid="' + IntToStr(FProcessID) + '"/>' +
          '</object></objects>';
        CommonDataModule.ProcessAction(Packet);
      end;

      // 5 Send email to admin
      Email.SendAdminEmail(0, 0,
        'Process #' + IntToStr(FProcessID) + ' was crashed at ' + DateTimeToStr(Now) +
        ' on server: ' + CommonDataModule.LocalIP, ErrorString +
        ' with ' + inttostr(UsersCount) + ' gamers.'#13#10#13#10 +
        'Service Settings: '#13#10 + CommonDataModule.ServiceSettings);

      if ErrResult = PO_NOERRORS then
      begin
        CommonDataModule.Log(ClassName, 'ReinitProcess',
          'Exit: Table reinited successfully', ltBase);
          FProcessState := psIdle;
      end
      else
        CommonDataModule.Log(ClassName, 'ReinitProcess',
          'Exit: Table reiniting failed with Error #' + inttostr(ErrResult) +
          ', ' + ErrString, ltError);
    finally
      // free objects
      CommonDataModule.ObjectPool.FreeSQLAdapter(SQL);
      CommonDataModule.ObjectPool.FreeAPI(API);
      CommonDataModule.ObjectPool.FreeAccount(Account);
      CommonDataModule.ObjectPool.FreeEmail(Email);
    end;
  except
    on E:Exception do
      CommonDataModule.Log(ClassName, 'ReinitProcess',
        '[EXCEPTION] Table reiniting failed: ' + ErrString + ', ' +
        E.Message, ltException);
  end;
end;

procedure TGameProcessThread.ProcessAction(ActionXML: String);
begin
  if FProcessState = psStopped then
  begin
    CommonDataModule.Log(ClassName, 'ProcessAction',
      'ProcessID=' + IntToStr(ProcessID) + ' is stopped', ltError);
    Exit;
  end;

  FCriticalSection_InputAction.Lock;
  try
    FInputActions := FInputActions + ActionXML;
  finally
    FCriticalSection_InputAction.UnLock;
  end;
  
  FStopSleep := True;
end;

procedure TGameProcessThread.Execute;
var
  ErrString: String;
  ErrResult: Integer;
  curInputActions: String;
  OutActions: String;
  NeedFullSave: Boolean;

  LastTimeSaveProcessInfo: TDateTime;
  LastTimeSaveContext: TDateTime;
  IterationCounter: Integer;
begin
  inherited;

  CoInitialize(nil);
  CommonDataModule.Log(ClassName, 'Execute',
    'Thread has been started for ProcessID=' + inttostr(FProcessID), ltBase);

  LastTimeSaveContext := Now;
  LastTimeSaveProcessInfo := Now;
  FProcessState := psIdle;

  // Thread circle
  while not Terminated do
  try
    // Process action
    curInputActions := '';
    if (FInputActions <> '') and (CommonDataModule.ProcessesStatus = 1) then
    begin
      FCriticalSection_InputAction.Lock;
      try
        curInputActions := '<gaactions>' + FInputActions + '</gaactions>';
        FInputActions := '';
      finally
        FCriticalSection_InputAction.UnLock;
      end;
    end;
    
    if curInputActions <> '' then
    try
      FProcessState := psRunning;
      ErrResult := FGameConnector.ProcessActions(FProcessID,
        curInputActions, OutActions, ErrString);

      if ErrResult = PO_NOERRORS then
      begin
        FLastTimeActivity := Now;
        FProcessLastFailure := False;
      end
      else
      if ErrResult = 2050 then
        Break
      else
      begin
        CommonDataModule.Log(ClassName, 'Execute',
          'ProcessID=' + inttostr(FProcessID) + ' failed: ' + ErrString +
          ' when processing: ' + curInputActions, ltError);
        ReinitProcess('ProcessID=' + inttostr(FProcessID) + ' failed: ' + ErrString +
          ' when processing: ' + curInputActions);
      end;
    except
      on E:Exception do
      begin
        CommonDataModule.Log(ClassName, 'Execute',
          'ProcessID=' + inttostr(FProcessID) + ' failed: ' + E.Message +
          ' when processing: ' + curInputActions, ltException);
        ReinitProcess('ProcessID=' + inttostr(FProcessID) + ' failed: ' + E.Message +
          ' when processing: ' + curInputActions);
      end;
    end;

    if (FProcessState = psRunning) and
      (SecondsBetween(Now, LastTimeSaveProcessInfo) > CommonDataModule.RefreshTime) then
    begin
      NeedFullSave :=
        SecondsBetween(Now, LastTimeSaveContext) > (10 * CommonDataModule.RefreshTime);
      if SaveProcessContext(NeedFullSave) then
      begin
        FProcessState := psIdle;
        if NeedFullSave then
          LastTimeSaveContext := Now;
        LastTimeSaveProcessInfo := Now;
      end;
    end;

    FStopSleep := FInputActions <> '';
    
    if not FStopSleep then
    begin
      IterationCounter := 1;
      while (IterationCounter < 10) and (not FStopSleep) do
      begin
        Sleep(100);
        Inc(IterationCounter);
      end;
    end;
  except
    on E:Exception do
    begin
      CommonDataModule.Log(ClassName, 'Execute',
        '[EXCEPTION] Main circle (ProcessID=' + inttostr(FProcessID) + '): ' +
        E.Message, ltException);
      ReinitProcess('ProcessID=' + inttostr(FProcessID) + ' failed on main circle');
    end;
  end; // while not terminated

  SaveProcessContext;
  FProcessState := psStopped;
  CommonDataModule.Log(ClassName, 'Execute',
    'Thread has been finished for ProcessID=' + inttostr(FProcessID), ltBase);

  CoUninitialize;
end;

end.

