unit uBotProcessor;

interface

uses Contnrs, XMLDoc, XMLIntF, XMLDom, ComCtrls, Classes
//
  , uBotConstants
  , uBotActions
  , uBotClasses
  ;

type

  TOnRefresh = procedure(RefreshTables, RefreshChairs, RefreshWatchers: Boolean) of object;

  TBotProcessor = class
  private
    FProcesses: TBotTableList;
    procedure SetProcesses(const Value: TBotTableList);
    //
    function ResponseActionForTable(aAction: TBotInputAction; aTable: TBotTable): string;
    function PerformUnknownAction(aAction: TBotInputAction; aTable: TBotTable): string;
    function PerformSitOut(aAction: TBotInputAction; aTable: TBotTable): string;
    function PerformSitOutNextHand(aAction: TBotInputAction; aTable: TBotTable): string;
    function PerformMoreChips(aAction: TBotInputAction; aTable: TBotTable): string;
    function PerformWaitBB(aAction: TBotInputAction; aTable: TBotTable): string;
    function PerformFold(aAction: TBotInputAction; aTable: TBotTable): string;
    function PerformChangeAmountActions(aAction: TBotInputAction; aTable: TBotTable): string;
    function PerformShowDownActions(aAction: TBotInputAction; aTable: TBotTable): string;
  public
    property Processes: TBotTableList read FProcesses write SetProcesses;
    //
    { functions for define user response; result is responce xml as string }
    function RunCommand(aAction: TBotInputAction; nProcessID: Integer): string; //input gaaction processor
    function BotSitDown(ProcessID, UserID, HandID, Position: Integer; Amount: Currency): string;
    function BotLeaveTable(ProcessID, UserID, HandID: Integer): string;
    function BotEntry(ProcessName, UserName: string; ProcessID, UserID: Integer): string;
    function BotMoreChips(ProcessID, UserID: Integer; Amount: Currency): string;
    function BotDisconnect(UserID: Integer): string;
    function BotReconnect(UserID: Integer): string;
    //
    function MemorySize: Integer;
    procedure DumpMemory(Level: Integer = 0; sPrefix: string = '');
    //
    constructor Create(aImmResp, aWaitResp: TBotResponseList);
    destructor Destroy; override;
  end;

  TBotResponseThread = class(TThread)
  private
    FTimeOutResponse: Integer;
    FImmResponses: TBotResponseList;
    FWaitResponses: TBotResponseList;
  protected
    procedure Execute; override;
  public
    property ImmResponses: TBotResponseList read FImmResponses;
    property WaitResponses: TBotResponseList read FWaitResponses;
    property TimeOutResponse: Integer read FTimeOutResponse;
    //
    function MemorySize: Integer;
    procedure DumpMemory(Level: Integer = 0);
    //
    constructor Create;
    destructor Destroy; override;
  end;

  TBotProcessorThread = class(TThread)
  private
    FInputActions: TBotInputActionList;
    FProcessor: TBotProcessor;
    FFuncActions: TBotFunctionActionList;
  protected
    procedure RunFunctionAction(aAction: TBotFunctionAction);
    procedure Execute; override;
  public
    property InputActions: TBotInputActionList read FInputActions;
    property FuncActions: TBotFunctionActionList read FFuncActions;
    property Processor: TBotProcessor read FProcessor;
    //
    function RunCommand(gaActionNode: IXMLNode; UserID: Integer): string; //input gaaction processor
    function BotSitDown(ProcessID, UserID, HandID, Position: Integer; Amount: Currency): string;
    function BotLeaveTable(ProcessID, UserID, HandID: Integer): string;
    function BotEntry(ProcessName, UserName: string; ProcessID, UserID: Integer): string;
    function BotMoreChips(ProcessID, UserID: Integer; Amount: Currency): string;
    function BotDisconnect(UserID: Integer): string;
    function BotReconnect(UserID: Integer): string;
    //
    function MemorySize: Integer;
    procedure DumpMemory(Level: Integer = 0; sPrefix: string = '');
    //
    // constructor & destructor
    constructor Create(aImmResp, aWaitResp: TBotResponseList);
    destructor Destroy; override;
  end;

  TBotRefreshThread = class(TThread)
  private
    FNeedRefreshChairs: Boolean;
    FNeedRefreshTables: Boolean;
    FNeedRefreshWatchers: Boolean;
    FOnRefresh: TOnRefresh;
    FLastTimeRefresh: TDateTime;
    FTimeOutSeconds: Integer;
    FEnableRefresh: Boolean;
    FProcessorThread: TBotProcessorThread;
    FNeedCloseForm: Boolean;
    procedure SetNeedRefreshChairs(const Value: Boolean);
    procedure SetNeedRefreshTables(const Value: Boolean);
    procedure SetNeedRefreshWatchers(const Value: Boolean);
    procedure SetOnRefresh(const Value: TOnRefresh);
    procedure SetEnableRefresh(const Value: Boolean);
    function GetTables: TBotTableList;
    procedure SetNeedCloseForm(const Value: Boolean);
    function GatEnableRefresh: Boolean;
    procedure SetLastTimeRefresh(const Value: TDateTime);
    function GetNeedRefreshTables: Boolean;
    function GetNeedRefreshChairs: Boolean;
    function GetNeedRefreshWatchers: Boolean;
    //
    procedure UpdateAllList;
    procedure UpdateTableList;
    procedure UpdateChairList;
    procedure UpdateWatchList;
    procedure BotAutoActions;
    procedure Refresh;
  protected
    procedure Execute; override;
  public
    TableList: array [0..1] of TStrings;
    ChairList: array [0..(COUNT_COL_CHAIRS-1)] of TStrings;
    WatchList: array [0..(COUNT_COL_WATCHERS-1)] of TStrings;
    TableIndex: Integer;
    ChairIndex: Integer;
    WatchIndex: Integer;
    AmountForSitDown: Integer;
    CountOfNotBotsForLeavetable: Integer;
    //
    property NeedCloseForm: Boolean read FNeedCloseForm write SetNeedCloseForm;
    property EnableRefresh: Boolean read GatEnableRefresh write SetEnableRefresh;
    property NeedRefreshTables: Boolean read GetNeedRefreshTables write SetNeedRefreshTables;
    property NeedRefreshChairs: Boolean read GetNeedRefreshChairs write SetNeedRefreshChairs;
    property NeedRefreshWatchers: Boolean read GetNeedRefreshWatchers write SetNeedRefreshWatchers;
    property TimeOutSeconds: Integer read FTimeOutSeconds;
    property LastTimeRefresh: TDateTime read FLastTimeRefresh write SetLastTimeRefresh;
    // read only
    property ProcessorThread: TBotProcessorThread read FProcessorThread;
    property Tables: TBotTableList read GetTables;
    //
    property OnRefresh: TOnRefresh read FOnRefresh write SetOnRefresh;
    // functions
    procedure AllocateAllWatchers(ProcessID: Integer);
    procedure LeaveTableAllBots(ProcessID: Integer);
    //
    function MemorySize: Integer;
    procedure DumpMemory(Level: Integer = 0);
    //
    // constructor & destructor
    constructor Create(aBotProcessorThread: TBotProcessorThread);
    destructor Destroy; override;
  end;

implementation

uses SysUtils, DateUtils, Math, StrUtils
  //
  , uBotForm
  , uCommonDataModule
  , uConstants
  , uLogger;

{ TBotProcessor }

function TBotProcessor.BotEntry(ProcessName, UserName: string; ProcessID, UserID: Integer): string;
var
  aTable: TBotTable;
  aUser: TBotUser;
begin
  Result := ''; // initial value
  aTable := FProcesses.TableByProcessID(ProcessID);
  if (aTable = nil) then begin
    aTable := FProcesses.Add( TBotTable.Create(FProcesses) );
    aTable.Name      := ProcessName;
    aTable.ProcessID := ProcessID;
  end;

  aUser := aTable.Users.UserByID(UserID);
  if (aUser = nil) then begin
    aUser := TBotUser.Create(aTable.Users);
    aUser.UserID := UserID;
    aUser.Name := UserName;
    aTable.Users.Add(aUser);
  end;
  aUser.IsBot := True;
  aUser.ProcInitStatus := PIS_WAITRESPONSE;
  aUser.Connected := True;

  aTable.TimeOutForSitDown := IncSecond(
    Now, CommonDataModule.SessionSettings.ValuesAsInteger[BotAutoSitTimeOut]
  );

  Result :=
    GetGaActionOpenNodeAsString(ProcessID) +
      '<' + NODE_PROCINIT + '/>' +
    GetGaActionCloseNodeAsString;

  { Visualization response }
  if (Result <> '') then
    FProcesses.OnResponse(Result, VST_PROCINIT, ACT_UNKNOWN, Now, ProcessID, UserID);
end;

function TBotProcessor.BotLeaveTable(ProcessID, UserID, HandID: Integer): string;
var
  aTable: TBotTable;
  aUser: TBotUser;
begin
  Result := ''; // initial value

  aTable := FProcesses.TableByProcessID(ProcessID);
  if (aTable = nil) then Exit;

  { remove from user list }
  aUser := aTable.Users.UserByID(UserID);
  if (aUser = nil) then Exit;
  aUser.AutoSitDown := False;

  { response }
  Result :=
    GetGaActionOpenNodeAsString(ProcessID) +
      GetActionNodeAsString(ACT_NAME_LEAVETABLE, HandID) +
    GetGaActionCloseNodeAsString();

  { Visualization response }
  if (Result <> '') then
    FProcesses.OnResponse(Result, VST_ACTION, ACT_LEAVETABLE, Now, ProcessID, UserID);

  aTable.Users.Del(aUser);
end;

function TBotProcessor.BotMoreChips(ProcessID, UserID: Integer; Amount: Currency): string;
var
  aTable: TBotTable;
  aUser: TBotUser;
begin
  Result := ''; // initial value

  aTable := FProcesses.TableByProcessID(ProcessID);
  if (aTable = nil) then Exit;
  { check on procinit(state) status for table }
  if (aTable.ProcInitStatus <> PIS_RESPONSED) or (aTable.ProcStateStatus <> PSS_RESPONSED) then Exit;
  { search user }
  aUser := aTable.Users.UserByID(UserID);
  if (aUser = nil) then Exit;
  if not aUser.IsBot or aUser.IsWatcher then Exit;

  aTable.BotMoreChips(aUser, Amount);
end;

function TBotProcessor.BotSitDown(ProcessID, UserID, HandID, Position: Integer; Amount: Currency): string;
var
  aTable: TBotTable;
  aUser: TBotUser;
  aType: TFixVisualizationType;
  aActType: TFixAction;
begin
  Result := ''; // initial value

  aTable := FProcesses.TableByProcessID(ProcessID);
  if (aTable = nil) then Exit;
  { check on procinit(state) status for table }
//  if (aTable.ProcInitStatus <> PIS_RESPONSED) or (aTable.ProcStateStatus <> PSS_RESPONSED) then Exit;

  { sit down user }
  aUser := aTable.Users.SitDownUser(UserID, Position, Trunc(Amount * 100));
  if (aUser = nil) then Exit;
  aUser.IsBot := True;
  aUser.AutoSitDown := True;

  { response }
  aType    := VST_NONE;
  aActType := ACT_UNKNOWN;
  if (aUser.ProcInitStatus = PIS_NEEDREQUEST) then begin
    aType := VST_PROCINIT;
    Result :=
      GetGaActionOpenNodeAsString(ProcessID) +
        GetProcInitNodeAsString +
        GetProcStateNodeAsString +
      GetGaActionCloseNodeAsString;
  end else begin
    if (aUser.ProcStateStatus = PSS_NEEDREQUEST) then begin
      aType := VST_PROCSTATE;
      Result :=
        GetGaActionOpenNodeAsString(ProcessID) +
          GetProcStateNodeAsString +
        GetGaActionCloseNodeAsString;
    end;
  end;

  if (aType = VST_NONE) then begin
    aType    := VST_ACTION;
    aActType := ACT_SITDOWN;
    Result :=
      GetGaActionOpenNodeAsString(ProcessID) +
        GetActionNodeAsString(ACT_NAME_SITDOWN, HandID, Position, Trunc(Amount * 100)) +
      GetGaActionCloseNodeAsString;
  end;

  { Visualization response }
  if (Result <> '') then
    FProcesses.OnResponse(Result, aType, aActType, Now, ProcessID, UserID);
end;

constructor TBotProcessor.Create(aImmResp, aWaitResp: TBotResponseList);
begin
  inherited Create;

  FProcesses := TBotTableList.Create(aImmResp, aWaitResp);
end;

destructor TBotProcessor.Destroy;
begin
  FProcesses.Free;

  inherited;
end;

function TBotProcessor.PerformChangeAmountActions(aAction: TBotInputAction; aTable: TBotTable): string;
begin
  Result := '';
  if (aTable = nil) then Exit;
  { response }
  Result := aTable.PerformChangeAmountActions(aAction);
end;

function TBotProcessor.PerformFold(aAction: TBotInputAction; aTable: TBotTable): string;
begin
  Result := '';
  if (aTable = nil) then Exit;
  { response }
  Result := aTable.PerformFold(aAction);
end;

function TBotProcessor.PerformMoreChips(aAction: TBotInputAction; aTable: TBotTable): string;
begin
  Result := '';
  if (aTable = nil) then Exit;
  { response }
  Result := aTable.PerformMoreChips(aAction);
end;

function TBotProcessor.PerformShowDownActions(aAction: TBotInputAction; aTable: TBotTable): string;
begin
  Result := '';
  if (aTable = nil) then Exit;
  { response }
  Result := aTable.PerformShowDownActions(aAction);
end;

function TBotProcessor.PerformSitOut(aAction: TBotInputAction; aTable: TBotTable): string;
begin
  Result := '';
  if (aTable = nil) then Exit;
  { response }
  Result := aTable.PerformSitOut(aAction);
end;

function TBotProcessor.PerformSitOutNextHand(aAction: TBotInputAction; aTable: TBotTable): string;
begin
  Result := '';
  if (aTable = nil) then Exit;
  { response }
  Result := aTable.PerformSitOutNextHand(aAction);
end;

function TBotProcessor.PerformUnknownAction(aAction: TBotInputAction; aTable: TBotTable): string;
var
  aUser: TBotUser;
begin
  Result := '';
  if aTable = nil then begin
    Logger.Log(aAction.UserID, ClassName, 'PerformUnknownAction',
      '[ERROR]: Table is nil.', ltError);
    Exit;
  end;

  if (aAction.NameOfNode = NODE_GACRASH) then begin
    aTable.PerformGaCrash(aAction);
    Exit;
  end;

  if (aAction.NameOfNode = NODE_PROCCLOSE) then begin
    aTable.PerformProcClose(aAction);
    Exit;
  end;

  if (aAction.NameOfNode = NODE_PROCINIT) then begin
    aTable.PerformProcInit(aAction);
    Exit;
  end;

  if (aAction.NameOfNode = NODE_PROCSTATE) then begin
    aTable.PerformProcState(aAction);
    Exit;
  end;

  if (aTable.ProcInitStatus <> PIS_RESPONSED) or (aTable.ProcStateStatus <> PSS_RESPONSED) then begin
    Logger.Log(aAction.UserID, ClassName, 'PerformUnknownAction',
      'Command was ignored. Table is waiting procinit or procstate action.', ltCall);
    Exit;
  end;

  if (aAction.NameOfNode = NODE_SETACTIVEPLAYER) then begin
    aTable.PerformSetActivePlayer(aAction);
    Exit;
  end;

  if (aAction.NameOfNode = NODE_MOVEBETS) then begin
    aTable.PerformMoveBets(aAction);
    Exit;
  end;

  if (aAction.NameOfNode = NODE_CHAIR) then begin
    { search for persionification of action }
    aUser := aTable.Users.UserByID(aAction.UserID);
    if (aUser <> nil) then begin
      //only personification packets
      aTable.PerformChair(aAction.ActionNode, nil, aUser);
    end;
    Exit;
  end;

  if (aAction.NameOfNode = NODE_DIALCARDS) then begin
    aTable.PerformDialCards(aAction);
    Exit;
  end;

  if (aAction.NameOfNode = NODE_FINALPOT) then begin
    aTable.PerformFinalPot(aAction.ActionNode,
      aAction.UserID, aAction.HandID, aAction.Round
    );
    Exit;
  end;

  if (aAction.NameOfNode = NODE_ENDROUND) then begin
    aTable.PerformEndRound(aAction);
    Exit;
  end;

  if (aAction.NameOfNode = NODE_FINISHHAND) then begin
    aTable.PerformFinishHand(aAction);
    Exit;
  end;

  if (aAction.NameOfNode = NODE_MESSAGE) then begin
    aTable.PerformMessage(aAction);
    Exit;
  end;

  if (aAction.NameOfNode = NODE_RANKING) then begin
    aTable.PerformRanking(aAction);
    Exit;
  end;
end;

function TBotProcessor.PerformWaitBB(aAction: TBotInputAction; aTable: TBotTable): string;
begin
  Result := '';
  if (aTable = nil) then Exit;
  { response }
  Result := aTable.PerformWaitBB(aAction);
end;

function TBotProcessor.ResponseActionForTable(aAction: TBotInputAction; aTable: TBotTable): string;
var
  nUserID: Integer;
begin
  Result := '';
  if (aTable = nil) or (aAction = nil) then begin // check for any case
    if aAction = nil then nUserID := 0 else nUserID := aAction.UserID;
    Logger.Log(nUserID, ClassName, 'ResponseActionForTable',
      '[ERROR]: Table or Action is nil.', ltError);
    Exit;
  end;

  { check on not action node }
  if (aAction.ActionType = ACT_UNKNOWN) then
    PerformUnknownAction(aAction, aTable);

  { check on procinit & procstate status }
  if (aTable.ProcInitStatus <> PIS_RESPONSED) or (aTable.ProcStateStatus <> PSS_RESPONSED) then begin
    Logger.Log(aAction.UserID, ClassName, 'ResponseActionForTable',
      'Command was ignored. ProcInitStatus or ProcStateStatus of Table is not responsed.', ltCall);
    Exit;
  end;

  if (aAction.ActionType <> ACT_UNKNOWN) then aTable.LastTimeActivity := Now;

  case aAction.ActionType of
    { needing response }
    ACT_SITOUT:                                     PerformSitOut(aAction, aTable);
    ACT_SITOUTNEXTHAND:                             PerformSitOutNextHand(aAction, aTable);
    { without response but need manipulation }
    ACT_MORECHIPS:                                  PerformMoreChips(aAction, aTable);
    ACT_WAITBB: PerformWaitBB(aAction, aTable);
    ACT_FOLD: PerformFold(aAction, aTable);
    { without response but change ammount actions }
    ACT_POSTSB, ACT_POSTBB, ACT_ANTE, ACT_BRINGIN,
    ACT_POST, ACT_POSTDEAD, ACT_BET, ACT_CALL,
    ACT_RAISE, ACT_CHECK:                           PerformChangeAmountActions(aAction, aTable);
    { ShowDown round actions }
    ACT_SHOW, ACT_SHOWSHUFFLED, ACT_MUCK:           PerformShowDownActions(aAction, aTable);
  else
    { without any action and response }
    { it is ACT_DISCARD }
    Exit;
  end;
end;

function TBotProcessor.RunCommand(aAction: TBotInputAction; nProcessID: Integer): string;
var
  aTable: TBotTable;
begin
//********************************************************
// WARNING: One packet for one prosessID only
// GOAL: Take in request actions for one processID
//       (gaaction node) and return response XML as string
//********************************************************

  Logger.Log(aAction.UserID, ClassName, 'RunCommand',
    'Entry with action: ' + aAction.ActionNode.XML, ltCall);

  Result := ''; // initial value

  { search for process }
  aTable := FProcesses.TableByProcessID(nProcessID);
  if aTable = nil then begin
    Logger.Log(aAction.UserID, ClassName, 'RunCommand',
      '[ERROR] Table is not found: ProcessID=' + IntToStr(nProcessID) + ', Command will be ignored.', ltError);

    Exit;
  end;

  Result := Result + ResponseActionForTable(aAction, aTable);

  { response }
  if (Result <> '') then begin
    Result :=
      GetGaActionOpenNodeAsString(nProcessID) +
        Result +
      GetGaActionCloseNodeAsString;
  end;
end;

procedure TBotProcessor.SetProcesses(const Value: TBotTableList);
begin
  FProcesses := Value;
end;

function TBotProcessor.BotDisconnect(UserID: Integer): string;
var
  aTable: TBotTable;
  aUser: TBotUser;
  I: Integer;
begin
  { on disconnect user }
  for I:=0 to FProcesses.Count - 1 do begin
    aTable := FProcesses.Items[I];
    aUser  := aTable.Users.UserByID(UserID);
    if (aUser <> nil) then begin
      if not aUser.IsBot then Continue;
      aUser.Connected := False;
      aUser.ProcInitStatus := PIS_NEEDREQUEST;
    end;
  end;
end;

function TBotProcessor.BotReconnect(UserID: Integer): string;
var
  aTable: TBotTable;
  aUser: TBotUser;
  I: Integer;
begin
  { on reconnect user }
  for I:=0 to FProcesses.Count - 1 do begin
    aTable := FProcesses.Items[I];
    aUser  := aTable.Users.UserByID(UserID);
    if (aUser <> nil) then begin
      if not aUser.IsBot then Continue;
      if aUser.IsWatcher then begin
        BotEntry(aTable.Name, aUser.Name, aTable.ProcessID, UserID);
      end else begin
        aUser.Connected := True;
        aUser.ProcInitStatus := PIS_NEEDREQUEST;
        aTable.BotBackToGame(aUser);
      end;
    end;
  end;
end;

procedure TBotProcessor.DumpMemory(Level: Integer; sPrefix: string);
var
  sShift: string;
begin
  if Level > 0 then sShift := DupeString(Shift_string_On_DumpMemory, Level) else sShift := '';
  Logger.Log(0, ClassName, 'DumpMemory',
    sShift + '[SIZE]: ' + IntToStr(MemorySize), ltCall);

  FProcesses.DumpMemory(Level + 1, '; Count=' + IntToStr(FProcesses.Count));

  sShift := '';
end;

function TBotProcessor.MemorySize: Integer;
begin
  Result := FProcesses.MemorySize;
end;

{ TBotResponseThread }

constructor TBotResponseThread.Create;
begin
  FImmResponses := TBotResponseList.Create;
  FWaitResponses := TBotResponseList.Create;
  FTimeOutResponse := 3;

  inherited Create(False);
end;

destructor TBotResponseThread.Destroy;
begin
  FImmResponses.Free;
  FWaitResponses.Free;

  inherited;
end;

procedure TBotResponseThread.DumpMemory(Level: Integer);
var
  sShift: string;
begin
  if Level > 0 then sShift := DupeString(Shift_string_On_DumpMemory, Level) else sShift := '';
  Logger.Log(0, ClassName, 'DumpMemory',
    sShift + '[SIZE]: ' + IntToStr(MemorySize), ltCall);

  FWaitResponses.DumpMemory(Level + 1, 'Wait: Count=' + IntToStr(FWaitResponses.Count));
  FImmResponses.DumpMemory(Level + 1, 'Imme: Count=' + IntToStr(FImmResponses.Count));

  sShift := '';
end;

procedure TBotResponseThread.Execute;
var
  aResponse: TBotResponse;
  I, nUserID, nTableID: Integer;
  sResponse: string;
  aRespType: TFixAction;
begin
  inherited;
  try
    while not Terminated do begin
      { immediately responses }
      FTimeOutResponse := CommonDataModule.SessionSettings.ValuesAsInteger[BotAutoResponseTimeOut];
      while FImmResponses.Count > 0 do begin
        CriticalSectionResponse.Enter;
        try
          try
            aResponse := FImmResponses.Item[0];
            nUserID := aResponse.UserID;
            sResponse := aResponse.XML;
            aRespType := aResponse.ActionType;
            nTableID := aResponse.TableID;
            FImmResponses.Del(aResponse);

            CommonDataModule.BotProcessorResponse(nUserID, nTableID, sResponse, aRespType);
          except
            on E:Exception do begin
              Logger.Log(0, ClassName, 'Execute',
                '[EXCEPTION] In immediate responses main circle: ' + E.Message, ltException);

              FImmResponses.Clear;
            end;
          end;
        finally
          CriticalSectionResponse.Leave;
        end;
      end;

      { waiting responses }
      I := 0;
      while I < FWaitResponses.Count do begin
        CriticalSectionResponse.Enter;
        try
          try
            aResponse := FWaitResponses.Item[I];
            nUserID := aResponse.UserID;
            sResponse := aResponse.XML;
            aRespType := aResponse.ActionType;
            nTableID := aResponse.TableID;

            if (IncSecond(aResponse.DateEntry, TimeOutResponse) <= Now) then begin
              FWaitResponses.Del(aResponse);

              Logger.Log(nUserID, ClassName, 'Execute',
                'Before send command to server: Params: UserID=' + IntToStr(nUserID) + '; Command=[' + sResponse + ']',
                ltCall
              );

              CommonDataModule.BotProcessorResponse(nUserID, nTableID, sResponse, aRespType);
            end else begin
              Inc(I);
            end;
          except
            on E:Exception do begin
              Logger.Log(0, ClassName, 'Execute',
                '[EXCEPTION] In wait responses main circle: ' + E.Message, ltException);
              FWaitResponses.Clear;
            end;
          end;
        finally
          CriticalSectionResponse.Leave;
        end;
      end;

      sResponse := '';

      Sleep(TIME_OUT_SLEEP_THREAD);
    end;
  except
    on E: Exception do
      Logger.Log(0, ClassName, 'Execute',
        '[EXCEPTION] In common catch block: ' + E.Message, ltException);
  end;
  Logger.Log(0, ClassName, 'Execute', 'Finish Execute thread', ltCall );
end;

function TBotResponseThread.MemorySize: Integer;
begin
  Result := SizeOf(FTimeOutResponse) +
    FImmResponses.MemorySize +
    FWaitResponses.MemorySize;
end;

{ TBotProcessorThread }

function TBotProcessorThread.BotDisconnect(UserID: Integer): string;
var
  aAction: TBotFunctionAction;
begin
  CriticalSectionBot.Enter;
  try
    aAction := TBotFunctionAction.Create(ACT_DISCONNECT, 0, UserID, 0, 0, 0, '', '');
    FFuncActions.Add(aAction);
  finally
    CriticalSectionBot.Leave;
  end;
end;

function TBotProcessorThread.BotEntry(ProcessName, UserName: string; ProcessID, UserID: Integer): string;
var
  aAction: TBotFunctionAction;
begin
  CriticalSectionBot.Enter;
  try
    aAction := TBotFunctionAction.Create(ACT_ENTRY, ProcessID, UserID, 0, 0, 0, ProcessName, UserName);
    FFuncActions.Add(aAction);
  finally
    CriticalSectionBot.Leave;
  end;
end;

function TBotProcessorThread.BotLeaveTable(ProcessID, UserID, HandID: Integer): string;
var
  aAction: TBotFunctionAction;
begin
  CriticalSectionBot.Enter;
  try
    aAction := TBotFunctionAction.Create(ACT_LEAVETABLE, ProcessID, UserID, HandID, 0, 0, '', '');
    FFuncActions.Add(aAction);
  finally
    CriticalSectionBot.Leave;
  end;
end;

function TBotProcessorThread.BotMoreChips(ProcessID, UserID: Integer; Amount: Currency): string;
var
  aAction: TBotFunctionAction;
begin
  CriticalSectionBot.Enter;
  try
    aAction := TBotFunctionAction.Create(ACT_MORECHIPS, ProcessID, UserID, 0, 0, Amount, '', '');
    FFuncActions.Add(aAction);
  finally
    CriticalSectionBot.Leave;
  end;
end;

function TBotProcessorThread.BotReconnect(UserID: Integer): string;
var
  aAction: TBotFunctionAction;
begin
  CriticalSectionBot.Enter;
  try
    aAction := TBotFunctionAction.Create(ACT_RECONNECT, 0, UserID, 0, 0, 0, '', '');
    FFuncActions.Add(aAction);
  finally
    CriticalSectionBot.Leave;
  end;
end;

function TBotProcessorThread.BotSitDown(ProcessID, UserID, HandID, Position: Integer; Amount: Currency): string;
var
  aAction: TBotFunctionAction;
begin
  CriticalSectionBot.Enter;
  try
    aAction := TBotFunctionAction.Create(ACT_SITDOWN, ProcessID, UserID, HandID, Position, Amount, '', '');
    FFuncActions.Add(aAction);
  finally
    CriticalSectionBot.Leave;
  end;
end;

constructor TBotProcessorThread.Create(aImmResp, aWaitResp: TBotResponseList);
begin
  FInputActions := TBotInputActionList.Create;
  FFuncActions := TBotFunctionActionList.Create;
  FProcessor := TBotProcessor.Create(aImmResp, aWaitResp);
  inherited Create(False);
end;

destructor TBotProcessorThread.Destroy;
begin
  FInputActions.Free;
  FProcessor.Free;
  FFuncActions.Free;

  inherited;
end;

procedure TBotProcessorThread.DumpMemory(Level: Integer; sPrefix: string);
var
  sShift: string;
begin
  if Level > 0 then sShift := DupeString(Shift_string_On_DumpMemory, Level) else sShift := '';
  Logger.Log(0, ClassName, 'DumpMemory',
    sShift + '[SIZE]: ' + IntToStr(MemorySize), ltCall);

  FInputActions.DumpMemory(Level + 1, 'Input: Count=' + IntToStr(FInputActions.Count));
  FFuncActions.DumpMemory(Level + 1, 'Func: Count=' + IntToStr(FFuncActions.Count));
  FProcessor.DumpMemory(Level + 1, 'Processor: ');

  sShift := '';
end;

procedure TBotProcessorThread.Execute;
var
  aAction: TBotInputAction;
  aFuncAct: TBotFunctionAction;
begin
  inherited;
  try
    while not Terminated do begin
      if FInputActions.Count > 0 then
        while FInputActions.Count > 0 do begin
          CriticalSectionBot.Enter;
          try
            try
              aAction := FInputActions.Items[0];
              FProcessor.RunCommand(aAction, aAction.ProcessID);
              FInputActions.Del(aAction);
            except
              on E:Exception do
              begin
                Logger.Log(0, ClassName, 'Execute',
                  '[EXCEPTION] in Input actions circle: ' + E.Message, ltException);
                FInputActions.Clear;
              end;
            end;
          finally
            CriticalSectionBot.Leave;
          end;
        end;

      if FFuncActions.Count > 0 then
        while FFuncActions.Count > 0 do begin
          CriticalSectionBot.Enter;
          try
            try
              aFuncAct := FFuncActions.Items[0];
              RunFunctionAction(aFuncAct);
              FFuncActions.Del(aFuncAct);
            except
              on E:Exception do
              begin
                Logger.Log(0, ClassName, 'Execute',
                  '[EXCEPTION] in Func actions circle: ' + E.Message, ltException);
                FFuncActions.Clear;
              end;
            end;
          finally
            CriticalSectionBot.Leave;
          end;
        end;

      Sleep(TIME_OUT_SLEEP_THREAD);
    end;
  except
    on E:Exception do
      Logger.Log(0, ClassName, 'Execute',
        '[EXCEPTION] common catch block: ' + E.Message, ltException);

  end;
  Logger.Log(0, ClassName, 'ProcessAction', 'Finish ProcessAction', ltCall );
end;

function TBotProcessorThread.MemorySize: Integer;
begin
  Result :=
    FInputActions.MemorySize +
    FProcessor.MemorySize +
    FFuncActions.MemorySize;
end;

function TBotProcessorThread.RunCommand(gaActionNode: IXMLNode; UserID: Integer): string;
begin
  { Filling Input action list object by gaaction node }
  CriticalSectionBot.Enter;
  try
    FInputActions.AddActionsByNode(gaActionNode, UserID);
  finally
    CriticalSectionBot.Leave;
  end;
end;

procedure TBotProcessorThread.RunFunctionAction(aAction: TBotFunctionAction);
begin
  case aAction.ActionType of
    ACT_ENTRY     : FProcessor.BotEntry(aAction.ProcessName, aAction.UserName, aAction.ProcessID, aAction.UserID);
    ACT_SITDOWN   : FProcessor.BotSitDown(aAction.ProcessID, aAction.UserID, aAction.HandID, aAction.Position, aAction.Amount);
    ACT_LEAVETABLE: FProcessor.BotLeaveTable(aAction.ProcessID, aAction.UserID, aAction.HandID);
    ACT_MORECHIPS : FProcessor.BotMoreChips(aAction.ProcessID, aAction.UserID, aAction.Amount);
    ACT_DISCONNECT: FProcessor.BotDisconnect(aAction.UserID);
    ACT_RECONNECT : FProcessor.BotReconnect(aAction.UserID);
  end;
end;

{ TBotRefreshThread }

procedure TBotRefreshThread.AllocateAllWatchers(ProcessID: Integer);
var
  aUser: TBotUser;
  aChair: TBotChair;
  aTable: TBotTable;
  I, nHandID, nAmount, CntWatchers, CntChairs, nUserID, nPos: Integer;

  arrWatchers: array of integer;
  arrChairs: array of integer;
begin
  { filling internal data }
  CriticalSectionBot.Enter;
  try
    aTable := Tables.TableByProcessID(ProcessID);
    if (aTable = nil) then Exit;
    nHandID := aTable.HandID;

    CntChairs   := 0;
    SetLength(arrChairs, CntChairs);
    for I:=0 to aTable.Chairs.Count - 1 do begin
      aChair := aTable.Chairs.Items[I];
      if (aChair.User = nil) then begin
        Inc(CntChairs);
        SetLength(arrChairs, CntChairs);
        arrChairs[CntChairs-1] := aChair.Position;
      end;
    end;
    if (CntChairs <= 0) then Exit;

    CntWatchers := 0;
    SetLength(arrWatchers, CntWatchers*2);
    for I:=0 to aTable.Users.Count - 1 do begin
      aUser := aTable.Users.Items[I];
      if not (aUser.IsBot and aUser.IsWatcher) then Continue;
      Inc(CntWatchers);
      SetLength(arrWatchers, CntWatchers*2);
      arrWatchers[CntWatchers*2 - 2] := aUser.UserID;

{
      nAmount := AmountForSitDown;
      if (nAmount < aTable.MinBuyIn) or (nAmount > aTable.MaxBuyIn) then
        nAmount := aTable.DefBuyIn;
}
      nAmount := aTable.MaxBuyIn;
      arrWatchers[CntWatchers*2 - 1] := nAmount;
    end;
    if (CntWatchers <= 0) then begin
      // deallocate array
      SetLength(arrChairs, 0);
      Exit;
    end

  finally
    CriticalSectionBot.Leave;
  end;

  for I:=0 to Min(CntChairs - 1, CntWatchers - 1) do begin
    nUserID := arrWatchers[I*2];
    nAmount := arrWatchers[I*2 + 1];
    nPos := arrChairs[I];

    FProcessorThread.BotSitDown(ProcessID, nUserID, nHandID, nPos, nAmount/100);
  end;
  // deallocate arrays
  SetLength(arrChairs, 0);
  SetLength(arrWatchers, 0);
end;

procedure TBotRefreshThread.BotAutoActions;
var
  aTable: TBotTable;
  I, nProcessID, CntTables, CntTablesLeave: Integer;
  arrTablesForSitDown: array of Integer;
  arrTablesForLeave: array of Integer;
begin
  CountOfNotBotsForLeavetable := CommonDataModule.SessionSettings.ValuesAsInteger[BotAutoLeaveOnGamers];
  
  CriticalSectionBot.Enter;
  try
    CntTables := 0;
    CntTablesLeave := 0;
    SetLength(arrTablesForSitDown, CntTables);
    SetLength(arrTablesForLeave, CntTablesLeave);
    for I:=0 to Tables.Count - 1 do begin
      aTable := Tables.Items[I];

      if (aTable.Chairs.CountOfNotBots >= CountOfNotBotsForLeavetable) then begin
        { Leave all bots }
        Inc(CntTablesLeave);
        SetLength(arrTablesForLeave, CntTablesLeave);
        arrTablesForLeave[CntTablesLeave-1] := aTable.ProcessID;
        Continue;
      end;

      if (Now >= IncSecond(aTable.LastTimeActivity, TIME_OUT_FORACTIVITY)) then begin
        { Leave all bots }
        Inc(CntTablesLeave);
        SetLength(arrTablesForLeave, CntTablesLeave);
        arrTablesForLeave[CntTablesLeave-1] := aTable.ProcessID;
        Continue;
(* old version
        aTable.PerformStandUpAllBots(True);
        aTable.LastTimeActivity  := Now;
        aTable.TimeOutForSitDown := Now;
*)
      end;

      if (Now < aTable.TimeOutForSitDown) then Continue;
      aTable.TimeOutForSitDown := IncSecond(
        Now, CommonDataModule.SessionSettings.ValuesAsInteger[BotAutoSitTimeOut]
      );

      if (aTable.Users.CountOfBotWatchers <= 0) or
         (aTable.Chairs.CountOfBuzy >= aTable.Chairs.Count)
      then Continue;

      Inc(CntTables);
      SetLength(arrTablesForSitDown, CntTables);
      arrTablesForSitDown[CntTables-1] := aTable.ProcessID;
    end;
  finally
    CriticalSectionBot.Leave;
  end;

  { leave all bots from tables }
  if CntTablesLeave > 0 then begin
    for I:=0 to CntTablesLeave - 1 do begin
      nProcessID := arrTablesForLeave[I];
      LeaveTableAllBots(nProcessID);
    end;
  end;
  // deallocate array arrTablesForLeave
  SetLength(arrTablesForLeave, 0);

  { allocate watchers }
  if CntTables > 0 then begin
    for I:=0 to CntTables - 1 do begin
      nProcessID := arrTablesForSitDown[I];
      AllocateAllWatchers(nProcessID);
    end;
  end;
  // deallocate array arrTablesForSitDown
  SetLength(arrTablesForSitDown, 0);
end;

constructor TBotRefreshThread.Create(aBotProcessorThread: TBotProcessorThread);
var
  I: Integer;
begin
  FProcessorThread := aBotProcessorThread;
  //
  FNeedCloseForm := True;
  FEnableRefresh := False;
  FNeedRefreshTables := False;
  FNeedRefreshChairs := False;
  FNeedRefreshWatchers := False;
  FLastTimeRefresh := Now;
  FTimeOutSeconds := 1;

  FOnRefresh := nil;
  AmountForSitDown := 10000;
  CountOfNotBotsForLeavetable := 3;

  TableIndex := -1;
  for I:=Low(TableList) to High(TableList) do TableList[I] := TStringList.Create;

  ChairIndex := -1;
  for I:=Low(ChairList) to High(ChairList) do ChairList[I] := TStringList.Create;

  WatchIndex := -1;
  for I:=Low(WatchList) to High(WatchList) do WatchList[I] := TStringList.Create;

  inherited Create(False);
//  inherited Create(True);
end;

destructor TBotRefreshThread.Destroy;
var
  I: Integer;
begin
  FOnRefresh := nil;

  for I:=Low(TableList) to High(TableList) do TableList[I].Free;
  for I:=Low(ChairList) to High(ChairList) do ChairList[I].Free;
  for I:=Low(WatchList) to High(WatchList) do WatchList[I].Free;

  inherited;
end;

procedure TBotRefreshThread.DumpMemory(Level: Integer);
var
  sShift: string;
begin
  if Level > 0 then sShift := DupeString(Shift_string_On_DumpMemory, Level) else sShift := '';
  Logger.Log(0, ClassName, 'DumpMemory',
    sShift + '[SIZE]: ' + IntToStr(MemorySize), ltCall);

  sShift := '';
end;

procedure TBotRefreshThread.Execute;
begin
  inherited;
  try
    while not Terminated do begin
      FTimeOutSeconds := CommonDataModule.SessionSettings.ValuesAsInteger[BotRefreshInterval];
      try
        BotAutoActions;

        { Check on refresh event }
        CriticalSectionRefresh.Enter;
        try
          if (IncSecond(FLastTimeRefresh, FTimeOutSeconds) <= Now) and
             (EnableRefresh or NeedCloseForm)
          then begin
            FNeedRefreshTables := True;
            FNeedRefreshChairs := True;
            FNeedRefreshWatchers := True;
            FLastTimeRefresh := Now;
          end else begin
            if not EnableRefresh then begin
              FNeedRefreshTables := False;
              FNeedRefreshChairs := False;
              FNeedRefreshWatchers := False;
            end;
          end;
        finally
          CriticalSectionRefresh.Leave;
        end;

        { update internal data }
        UpdateAllList;
        { refresh }
        if (FNeedRefreshTables or FNeedRefreshChairs or FNeedRefreshWatchers) and EnableRefresh then
          Synchronize(Refresh);
      except
        on E:Exception do
        begin
          Logger.Log(0, ClassName, 'Execute',
            '[EXCEPTION] in main circle: ' + E.Message, ltException);
        end;
      end;

      Sleep(TIME_OUT_SLEEP_THREAD);
    end;
  except
    on E: Exception do
      Logger.Log(0, ClassName, 'Execute',
        '[EXCEPTION] in common catch block: ' + E.Message, ltException);
  end;
end;

function TBotRefreshThread.GatEnableRefresh: Boolean;
begin
  Result := (FEnableRefresh and not FNeedCloseForm);
end;

function TBotRefreshThread.GetNeedRefreshChairs: Boolean;
begin
  Result := FNeedRefreshChairs and EnableRefresh;
end;

function TBotRefreshThread.GetNeedRefreshTables: Boolean;
begin
  Result := (FNeedRefreshTables and EnableRefresh) or NeedCloseForm;
end;

function TBotRefreshThread.GetNeedRefreshWatchers: Boolean;
begin
  Result := FNeedRefreshWatchers and EnableRefresh;
end;

function TBotRefreshThread.GetTables: TBotTableList;
begin
  Result := FProcessorThread.FProcessor.Processes;
end;

procedure TBotRefreshThread.LeaveTableAllBots(ProcessID: Integer);
var
  I, nCnt: Integer;
  nHandID: Integer;
  aTable: TBotTable;
  aUser: TBotUser;
  //
  arrUsers: array of Integer;
begin
  if ProcessID <= 0 then Exit;

  CriticalSectionBot.Enter;
  try
    aTable := Tables.TableByProcessID(ProcessID);
    if aTable = nil then Exit;
    nHandID := aTable.HandID;

    nCnt := aTable.Users.CountOfBots;
    if nCnt <= 0 then Exit;

    SetLength(arrUsers, nCnt);
    nCnt:=0;
    for I:=0 to aTable.Users.Count - 1 do begin
      aUser := aTable.Users.Items[I];
      if not aUser.IsBot then Continue;

      arrUsers[nCnt] := aUser.UserID;
      Inc(nCnt);
    end;
  finally
    CriticalSectionBot.Leave;
  end;

  for I:=0 to High(arrUsers) do
    FProcessorThread.BotLeaveTable(ProcessID, arrUsers[I], nHandID);
  // deallocate array
  SetLength(arrUsers, 0);
end;

function TBotRefreshThread.MemorySize: Integer;
var
  I: Integer;
begin
  Result :=
    SizeOf(FNeedRefreshChairs) +
    SizeOf(FNeedRefreshTables) +
    SizeOf(FNeedRefreshWatchers) +
    SizeOf(FLastTimeRefresh) +
    SizeOf(FTimeOutSeconds) +
    SizeOf(FEnableRefresh) +
    SizeOf(FProcessorThread) +
    SizeOf(FNeedCloseForm);

  for I:=Low(TableList) to High(TableList) do
    Result := Result + Length(TableList[I].Text) * SizeOf(Char);
  for I:=Low(ChairList) to High(ChairList) do
    Result := Result + Length(ChairList[I].Text) * SizeOf(Char);
  for I:=Low(WatchList) to High(WatchList) do
    Result := Result + Length(WatchList[I].Text) * SizeOf(Char);

  Result := Result +
    SizeOf(TableIndex) +
    SizeOf(ChairIndex) +
    SizeOf(WatchIndex) +
    SizeOf(AmountForSitDown) +
    SizeOf(CountOfNotBotsForLeavetable);
end;

procedure TBotRefreshThread.Refresh;
begin
  if Assigned(FOnRefresh) then begin
    CriticalSectionRefresh.Enter;
    try
      FOnRefresh(FNeedRefreshTables, FNeedRefreshChairs, FNeedRefreshWatchers);
    finally
      CriticalSectionRefresh.Leave;
    end;
  end;
end;

procedure TBotRefreshThread.SetEnableRefresh(const Value: Boolean);
begin
  FEnableRefresh := Value;
end;

procedure TBotRefreshThread.SetLastTimeRefresh(const Value: TDateTime);
begin
  FLastTimeRefresh := Value;
end;

procedure TBotRefreshThread.SetNeedCloseForm(const Value: Boolean);
begin
  FNeedCloseForm := Value;
end;

procedure TBotRefreshThread.SetNeedRefreshChairs(const Value: Boolean);
begin
  FNeedRefreshChairs := Value;
end;

procedure TBotRefreshThread.SetNeedRefreshTables(const Value: Boolean);
begin
  FNeedRefreshTables := Value;
end;

procedure TBotRefreshThread.SetNeedRefreshWatchers(const Value: Boolean);
begin
  FNeedRefreshWatchers := Value;
end;

procedure TBotRefreshThread.SetOnRefresh(const Value: TOnRefresh);
begin
  FOnRefresh := Value;
end;

procedure TBotRefreshThread.UpdateAllList;
begin
  UpdateTableList;
  UpdateChairList;
  UpdateWatchList;
end;

procedure TBotRefreshThread.UpdateChairList;
var
  I, nProcessID: Integer;
  IsWatcher: Boolean;
  aTable: TBotTable;
  aChair: TBotChair;
  aUser : TBotUser;
begin
  CriticalSectionRefresh.Enter;
  try
    if not FNeedRefreshChairs then Exit;
    for I:=Low(ChairList) to High(ChairList) do ChairList[I].Clear;

    if (FProcessorThread = nil) or (TableIndex < 0) then begin
      ChairIndex := -1;
      Exit;
    end;
  finally
    CriticalSectionRefresh.Leave;
  end;

  CriticalSectionBot.Enter;
  try
    nProcessID := StrToInt(TableList[1].Strings[TableIndex]);
    aTable := Tables.TableByProcessID(nProcessID);
    if (aTable = nil) then begin
      ChairIndex := -1;
      Exit;
    end;

    for I:=0 to aTable.Chairs.Count - 1 do begin
      aChair := aTable.Chairs.Items[I];
      aUser := aChair.User;
      IsWatcher := (aUser = nil);
      if not IsWatcher then IsWatcher := (IsWatcher and aUser.IsWatcher);

      CriticalSectionRefresh.Enter;
      try
        ChairList[0].Add(IntToStr(aChair.Position));
        if (aChair.IsDialer = 1) then
          ChairList[1].Add('D')
        else
          ChairList[1].Add('');
        if not IsWatcher then begin
          ChairList[2].Add(aUser.Name);
          ChairList[3].Add(CurrToStr(aUser.CurrAmmount/100));
          ChairList[4].Add(aUser.NameOfQualification);
          ChairList[5].Add(aUser.NameOfCharacter);
          ChairList[6].Add(BoolToStr(aUser.IsBot, True));
        end else begin
          ChairList[2].Add('');
          ChairList[3].Add('');
          ChairList[4].Add('');
          ChairList[5].Add('');
          ChairList[6].Add('');
        end;
      finally
        CriticalSectionRefresh.Leave;
      end;
    end;
  finally
    CriticalSectionBot.Leave;
  end;

  CriticalSectionRefresh.Enter;
  try
    if (ChairList[0].Count <= 0) then ChairIndex := -1;
    if (ChairIndex < 0) and (ChairList[0].Count > 0) then ChairIndex := 0;
    if (ChairIndex >= ChairList[0].Count) then ChairIndex := ChairList[0].Count - 1;
  finally
    CriticalSectionRefresh.Leave;
  end;
end;

procedure TBotRefreshThread.UpdateTableList;
var
  I: Integer;
  aTable: TBotTable;
begin
  CriticalSectionRefresh.Enter;
  try
    if not NeedRefreshTables then Exit;
    for I:=Low(TableList) to High(TableList) do TableList[I].Clear;

    if (FProcessorThread = nil) then Exit;
  finally
    CriticalSectionRefresh.Leave;
  end;

  CriticalSectionBot.Enter;
  try
    I:=0;
    while (I < Tables.Count) do begin
      aTable := Tables.Items[I];
      if aTable.Users.CountOfBots <= 0 then begin
        Tables.Remove(aTable);
        Continue;
      end;

      CriticalSectionRefresh.Enter;
      try
        if (aTable.ProcessID > 0) then begin
          TableList[0].Add(aTable.Name);
          TableList[1].Add(IntToStr(aTable.ProcessID));
        end;
      finally
        CriticalSectionRefresh.Leave;
      end;

      Inc(I);
    end;

    NeedCloseForm := (Tables.Count <= 0);
    if NeedCloseForm then begin
      for I:=Low(TableList) to High(TableList) do TableList[I].Clear;
      for I:=Low(ChairList) to High(ChairList) do ChairList[I].Clear;
      for I:=Low(WatchList) to High(WatchList) do WatchList[I].Clear;
      NeedRefreshTables := True;
      NeedRefreshChairs := True;
      NeedRefreshWatchers := True;
    end;
  finally
    CriticalSectionBot.Leave;
  end;

  CriticalSectionRefresh.Enter;
  try
    if (TableList[1].Count <= 0) then TableIndex := -1;
    if (TableIndex < 0) and (TableList[1].Count > 0) then TableIndex := 0;
    if (TableIndex >= TableList[1].Count) then TableIndex := TableList[1].Count - 1;

    if (TableIndex < 0) then begin
      ChairIndex := -1;
      WatchIndex := -1;
    end;
  finally
    CriticalSectionRefresh.Leave;
  end;
end;

procedure TBotRefreshThread.UpdateWatchList;
var
  I, nProcessID: Integer;
  aTable: TBotTable;
  aUser: TBotUser;
begin
  CriticalSectionRefresh.Enter;
  try
    if not FNeedRefreshWatchers then Exit;
    for I:=Low(WatchList) to High(WatchList) do WatchList[I].Clear;

    if (FProcessorThread = nil) or (TableIndex < 0) then begin
      WatchIndex := -1;
      Exit;
    end;
  finally
    CriticalSectionRefresh.Leave;
  end;

  CriticalSectionBot.Enter;
  try
    nProcessID := StrToInt(TableList[1].Strings[TableIndex]);
    aTable := Tables.TableByProcessID(nProcessID);
    if (aTable = nil) then begin
      WatchIndex := -1;
      Exit;
    end;

    for I:=0 to aTable.Users.Count - 1 do begin
      aUser := aTable.Users.Items[I];
      if not aUser.IsWatcher then Continue;

      WatchList[0].Add(IntToStr(aUser.UserID));
      WatchList[1].Add(aUser.Name);
      if aUser.IsBot then begin
        WatchList[2].Add(aUser.NameOfQualification);
        WatchList[3].Add(aUser.NameOfCharacter);
      end else begin
        WatchList[2].Add('');
        WatchList[3].Add('');
      end;
      WatchList[4].Add(BoolToStr(aUser.IsBot, True));
    end;
  finally
    CriticalSectionBot.Leave;
  end;

  CriticalSectionRefresh.Enter;
  try
    if (WatchList[0].Count <= 0) then WatchIndex := -1;
    if (WatchIndex < 0) and (WatchList[0].Count > 0) then WatchIndex := 0;
    if (WatchIndex >= WatchList[0].Count) then WatchIndex := WatchList[0].Count - 1;
  finally
    CriticalSectionRefresh.Leave;
  end;
end;

end.
