//      Project: Poker
//         Unit: uProcessModule.pas
//
//      Company: Offshore Creations
//    Developer: Maxim L. Korablev
//
//    Class(es): TProcessModule
//  Description: Keep communications with flash,
//               send/receive commands between flash and server
//

unit uProcessModule;

interface

uses
  SysUtils, Classes, Forms, ExtCtrls,
  xmldom, XMLIntf, msxmldom, XMLDoc,
  uTakingForm,
  uHTTPGetFileThread,
  uFileManagerModule,
  uSessionModule,
  uProcessForm,
  uDataList;

type
  TProcessState = (psNone, psDownloading, psLoading,
    psDisconnected, psWaitingProcState, psWorking, psFinishing);
  TProcessType = (ptTable, ptRecordedHand, ptTournamentTable);
  THandHistoryProc = procedure (FirstHandID: Integer) of object;
  TWaitingListProc = procedure (ProcessID, GroupID, WaitingListPlayersCount: Integer;
    ProcessName: String) of object;
  TWaitingListConfirmProc = procedure (const Text: String; Seconds: Integer) of object;

  TGameProcess = class
  public
    ProcessType: TProcessType;
    CurrentState: TProcessState;
    CurrencyID: Integer;

    ProcessID: Integer;
    ProcessHandID: Integer;
    ProcessName: String;
    ProcessOpts: String;
    ProcessForm: TProcessForm;

    RecordedHandID: Integer;
    RecordedHandXML: String;

    TournamentID: Integer;

    ActionDispatcherID: Integer;

    Busy: Boolean;
    SendBuffer: TStringList;
    ActionBuffer: TStringList;

    TakingForm: TTakingForm;
    Files: TStringList;
    DownloadSessionID: Integer;

    TournamentStartDuration: Integer;

    constructor Create(AProcessType: TProcessType;
      AProcessID, AHandID, ATournamentID, AActionDispatcherID: Integer;
      AProcessOpts, AProcessName, ARecordedHandXML: String);
    destructor  Destroy; override;
  end;

  TProcessModule = class(TDataModule)
    FinishProcessTimer: TTimer;
    WaitingListTimeOutTimer: TTimer;
    SaveNotesTimer: TTimer;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure FinishProcessTimerTimer(Sender: TObject);
    procedure WaitingListTimeOutTimerTimer(Sender: TObject);
    procedure SaveNotesTimerTimer(Sender: TObject);
  private
    FProcesses: TList;
    FFlashGameFileName: String;
    FTablesLimit: Integer;
    FRecordedHandsLimit: Integer;
    FTournamentTablesLimit: Integer;

    FFinishingProcessID: Integer;
    FFinishingProcessHandID: Integer;

    FUserNotes: TStringList;

    FProcessStats: TDataList;
    FCurrentGameType: Integer;
    FOnProcessStatsUpdate: TSessionEvent;
    FOnProcessStatsShow: TSessionEvent;

    FOnRequestHandHistory: THandHistoryProc;
    FOnRequestHandHistoryFailed: TSessionEvent;
    FOnRequestHandHistorySent: TSessionEvent;

    FPreviousHands: TDataList;
    FRecordedHands: TDataList;
    FRecordedHandReceived: Boolean;
    FOnRecordedHandsShow: TSessionEvent;
    FOnRecordedHandsUpdate: TSessionEvent;
    FOnRecordHandsSaveFailed: TSessionEvent;
    FOnRecordHandsSaved: TSessionEvent;

    FWaitingListProcesses: TDataList;
    FCurrentTakePlaceProcessID: Integer;
    FOnWaitingList: TWaitingListProc;
    FOnWaitingListHide: TSessionEvent;
    FOnWaitingListClose: TSessionEvent;
    FOnWaitingListConfirm: TWaitingListConfirmProc;

    procedure SetOnWaitingList(const Value: TWaitingListProc);
    procedure SetOnWaitingListConfirm(const Value: TWaitingListConfirmProc);
    procedure SetOnWaitingListClose(const Value: TSessionEvent);
    procedure SetOnWaitingListHide(const Value: TSessionEvent);
    procedure SetOnProcessStatsUpdate(const Value: TSessionEvent);
    procedure SetOnProcessStatsShow(const Value: TSessionEvent);
    procedure SetOnRequestHandHistory(const Value: THandHistoryProc);
    procedure SetOnRequestHandHistorySent(const Value: TSessionEvent);
    procedure SetOnRequestHandHistoryFailed(const Value: TSessionEvent);
    procedure SetOnRecordedHandsShow(const Value: TSessionEvent);
    procedure SetOnRecordHandsSaved(const Value: TSessionEvent);
    procedure SetOnRecordHandsSaveFailed(const Value: TSessionEvent);
    procedure SetOnRecordedHandsUpdate(const Value: TSessionEvent);
    procedure SetRecordedHandsLimit(const Value: Integer);
    procedure SetTablesLimit(const Value: Integer);
    procedure SetTournamentTablesLimit(const Value: Integer);

    procedure StartProcess(ProcessType: TProcessType; ProcessID, HandID,
      TournamentID, ActionDispatcherID: Integer; SubCategoryName, ProcessName, RecordedHandXML: String; TournamentStartDuration: Integer = 0);
    procedure OpenProcess(ProcessObj: TGameProcess);
    function  FindProcess(ProcessID: Integer; HandID: Integer = 0): TGameProcess;
    procedure ReallySend(ProcessObj: TGameProcess);

    function  GetProcessCaption(ProcessObj: TGameProcess): String;
    function  GetLoadingProcessCaption(ProcessObj: TGameProcess): String;
    function  GetUserNotesXML(ForUserID: Integer): String;
    function  GetChangeTableXML(ProcessID: Integer; ProcessName, Reason: String): String;
    procedure SendWaitingListStatusXML(ProcessObj: TGameProcess);
    procedure Send_Balance(ProcessObj: TGameProcess);
    procedure Send_Notes(ForUserID: Integer);
    procedure Send_PlayerLogoInfo(ProcessObj: TGameProcess; UserID: Integer;Path: String);
    procedure Send_TournamentStart(ProcessObj: TGameProcess);
    procedure Send_BreakStart(ProcessObj: TGameProcess;Duration: Integer);

    procedure Do_ReadyToReceive(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_Loaded(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_Action(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_Start(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_Finish(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_Login(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_GetBalance(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_ProcessStats(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_ProcessStatsShow(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_ProcessStatsStarted(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_ProcessStatsAction(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_ProcessStatsFinished(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_Options(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_Help(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_AllIns(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_HandHistory(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_Notes(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_SaveNotes(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_WindowState(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_SitDown(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_NewHand(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_RecordHand(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_WaitingList(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_WaitingListStatus(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
    procedure Do_GetPlayerLogo(ProcessObj: TGameProcess;XMLRoot: IXMLNode);
    procedure Do_AutoRebuy(ProcessObj: TGameProcess;XMLRoot: IXMLNode);

    procedure Run_Action(XMLRoot: IXMLNode);
    procedure Run_Crash(XMLRoot: IXMLNode);
    procedure Run_Notes(XMLRoot: IXMLNode);
    procedure Run_RequestHandHistory(XMLRoot: IXMLNode);

    procedure Run_CheckHandID(XMLRoot: IXMLNode);
    procedure Run_SaveRecordedHands(XMLRoot: IXMLNode);
    procedure Run_GetRecordedHands(XMLRoot: IXMLNode);
    procedure Run_LoadRecordedHand(XMLRoot: IXMLNode);

    procedure Run_GetWaitingListInfo(XMLRoot: IXMLNode);
    procedure Run_RegisterWaitingList(XMLRoot: IXMLNode);
    procedure Run_UnregisterWaitingList(XMLRoot: IXMLNode);
    procedure Run_TakePlaceWaitingList(XMLRoot: IXMLNode);
    procedure Run_CancelWaitingList(XMLRoot: IXMLNode);

    procedure CloseWaitingList(ProcessID: Integer);
    procedure ProcessStatsLoad;
    procedure ProcessStatsSave;
    procedure Send_ProcessInit(ProcessObj: TGameProcess);
    procedure OnUpdatedFilesDownloading(This: TDownloadSession);
    procedure OnPlayerLogoFileDownloaded(This: TDownloadSession);
    procedure SetFlashGameFileName(const Value: String);
    procedure StopLoading(ID1, ID2: Integer);
    procedure UpdateProcessCaption(curProcess: TGameProcess);
    function GetUserNotes(ForUserID: Integer): String;
    procedure SetUserNotes(ForUserID: Integer; Notes: String);
  public
    property  ProcessStats: TDataList read FProcessStats;
    property  CurrentGameType: Integer read FCurrentGameType;
    property  FlashGameFileName: String read FFlashGameFileName write SetFlashGameFileName;

    property  TablesLimit: Integer read FTablesLimit write SetTablesLimit;
    property  TournamentTablesLimit: Integer read FTournamentTablesLimit write SetTournamentTablesLimit;
    property  RecordedHandsLimit: Integer read FRecordedHandsLimit write SetRecordedHandsLimit;

    property  OnWaitingList: TWaitingListProc read FOnWaitingList write SetOnWaitingList;
    property  OnWaitingListConfirm: TWaitingListConfirmProc read FOnWaitingListConfirm write SetOnWaitingListConfirm;
    property  OnWaitingListHide: TSessionEvent read FOnWaitingListHide write SetOnWaitingListHide;
    property  OnWaitingListClose: TSessionEvent read FOnWaitingListClose write SetOnWaitingListClose;

    property  OnRequestHandHistory: THandHistoryProc read FOnRequestHandHistory write SetOnRequestHandHistory;
    property  OnRequestHandHistorySent: TSessionEvent read FOnRequestHandHistorySent write SetOnRequestHandHistorySent;
    property  OnRequestHandHistoryFailed: TSessionEvent read FOnRequestHandHistoryFailed write SetOnRequestHandHistoryFailed;

    property  OnProcessStatsShow: TSessionEvent read FOnProcessStatsShow write SetOnProcessStatsShow;
    property  OnProcessStatsUpdate: TSessionEvent read FOnProcessStatsUpdate write SetOnProcessStatsUpdate;

    property  PreviousHands: TDataList read FPreviousHands;
    property  RecordedHandReceived: Boolean read FRecordedHandReceived;

    property  RecordedHandList: TDataList read FRecordedHands;
    property  OnRecordedHandsShow: TSessionEvent read FOnRecordedHandsShow write SetOnRecordedHandsShow;
    property  OnRecordedHandsUpdate: TSessionEvent read FOnRecordedHandsUpdate write SetOnRecordedHandsUpdate;
    property  OnRecordHandsSaved: TSessionEvent read FOnRecordHandsSaved write SetOnRecordHandsSaved;
    property  OnRecordHandsSaveFailed: TSessionEvent read FOnRecordHandsSaveFailed write SetOnRecordHandsSaveFailed;

    procedure StartTable(ProcessID, ActionDispatcherID: Integer; SubCategoryName, ProcessName: String);
    procedure StartRecordedHand(ProcessID, HandID: Integer;
      HandName, HandComment, RecordedHandXML: String);
    procedure StartTournamentTable(ProcessID,TournamentID, ActionDispatcherID: Integer;
      TournamentName, ProcessName: String; TournamentStartDuration: Integer = 0);
    procedure ChangeTournamentTable(OldProcessID, ProcessID, TournamentID, ActionDispatcherID: Integer;
      TournamentName, ProcessName, Reason: String);
    procedure Send(ProcessObj: TGameProcess; Command: String; IsAction: Boolean = False);
    procedure StopProcess(ProcessID: Integer; HandID: Integer = 0; IsCrash: Boolean = False);

    procedure UpdateConnectingState;
    procedure UpdateOptions;
    function  GetOptionsXML(ProcessObj: TGameProcess): String;
    procedure UpdateLoginState;
    function  GetLoggedXML: String;
    procedure UpdateUserBalance;
    procedure UpdateChatState;
    function  GetChatStateXML: String;
    function  GetOneLineComments(Value: String): String;

    procedure WaitingList(ProcessID: Integer); overload;
    procedure WaitingList; overload;

    procedure RecordedHands;

    procedure RequestHandHistory(HandID: Integer); overload;
    procedure RequestHandHistory; overload;

    procedure RequestAllInsReset;
    procedure AllInsRemaining;
    procedure ViewStatistics;
    procedure LoggedNow;

    procedure Do_ProcessStatsClear;
    procedure Do_ChangeCurrentStatsGameType(NewGameType: Integer);

    procedure Do_PreviousHandPlay(HandID: Integer);

    procedure Do_RequestHandHistory(HandID, LastHands, Direction: Integer);
    procedure Do_RecordedHandsSave;
    procedure Do_RecordHandClear(SlotNo: Integer);
    procedure Do_RecordHandPlay(SlotNo: Integer);
    procedure Do_RecordHandSave(SlotNo, HandID: Integer; Comment: String);

    procedure Do_RegisterWaitingList(ProcessID, GroupID, PlayersCount: Integer);
    procedure Do_TakePlace;
    procedure Do_Unjoin;
    procedure Do_BreakStart(ProcessID: Integer;Duration: Integer);
    procedure Do_ViewLobby(ProcessObj: TGameProcess);


    procedure DoCommand(ProcessObj: TGameProcess; Command: String);

    procedure RunCommand(XMLRoot: IXMLNode);

    procedure UpdateActiveState(ProcessObj: TGameProcess; IsActive: Boolean);
    procedure UpdateActiveStates(IsActive: Boolean);

    function  GetProcessList(ProcessList: TStringList): Boolean;
    function  IsProcessHandle(checkedHandle: THandle): Boolean;
  end;

var
  ProcessModule: TProcessModule;

implementation

uses
  uLogger,
  uConstants,
  uConversions,
  uLobbyModule,
  uCashierModule,
  Controls,
  uTCPSocketModule,
  uWaitingListJoinForm,
  uUserModule,
  uThemeEngineModule,
  uParserModule, uTournamentModule;

{$R *.dfm}


{ TGameProcess }

constructor TGameProcess.Create(AProcessType: TProcessType;
  AProcessID, AHandID, ATournamentID, AActionDispatcherID: Integer;
  AProcessOpts, AProcessName, ARecordedHandXML: String);
begin
  CurrentState := psNone;
  ProcessType := AProcessType;
  CurrencyID := 0;

  ProcessID := AProcessID;
  ProcessHandID := 0;
  RecordedHandID := AHandID;
  RecordedHandXML := ARecordedHandXML;

  TournamentID := ATournamentID;
  ActionDispatcherID := AActionDispatcherID;

  ProcessName := AProcessName;
  ProcessOpts := AProcessOpts;

  ProcessForm := TProcessForm.CreateParented(0);

  SendBuffer := TStringList.Create;
  SendBuffer.Clear;
  ActionBuffer := TStringList.Create;
  ActionBuffer.Clear;
  Busy := false;

  Files := TStringList.Create;
  Files.Clear;

 if ATournamentID = 0 then
 begin
  TakingForm := TTakingForm.CreateParented(0);
  TakingForm.SetOnCloseEvent(ProcessModule.StopLoading, AProcessID, AHandID);
  TakingForm.StatusLabel.Caption := ProcessModule.GetLoadingProcessCaption(Self);
  TakingForm.Show;
 end; 
end;

destructor TGameProcess.Destroy;
begin
  if TakingForm <> nil then
  begin
    TakingForm.OnClose := nil;
    TakingForm.Free;
  end;

  CurrentState := psFinishing;
  if ProcessForm <> nil then
  begin
    ProcessForm.Stop;
    ProcessForm.Free;
  end;
  SendBuffer.Free;
  ActionBuffer.Free;
  Files.Free;
end;


{ TGameProcessModule }

procedure TProcessModule.DataModuleCreate(Sender: TObject);
var
  Loop: Integer;
begin
  FProcesses := TList.Create;
  FFlashGameFileName := '';
  FTablesLimit := 0;
  FRecordedHandsLimit := 0;
  FTournamentTablesLimit := 0;

  FFinishingProcessID := 0;
  FFinishingProcessHandID := 0;

  FUserNotes := TStringList.Create;

  FProcessStats := TDataList.Create(0, nil);
  ProcessStatsLoad;
  FCurrentGameType := 1;
  FOnProcessStatsUpdate := nil;
  FOnProcessStatsShow := nil;

  FRecordedHandReceived := false;
  FOnRequestHandHistory := nil;
  FOnRequestHandHistoryFailed := nil;
  FOnRequestHandHistorySent := nil;

  FPreviousHands := TDataList.Create(0, nil);
  FPreviousHands.LoadFromFile(SessionModule.AppPath + ProcessPrevHandsFileName);

  FRecordedHands := TDataList.Create(0, nil);
  FRecordedHands.ClearItems(10);
  for Loop := 1 to 10 do
    FRecordedHands.AddItem(Loop, Loop - 1);
  FOnRecordedHandsShow := nil;
  FOnRecordedHandsUpdate := nil;
  FOnRecordHandsSaveFailed := nil;
  FOnRecordHandsSaved := nil;

  FWaitingListProcesses := TDataList.Create(0, nil);
  FCurrentTakePlaceProcessID := 0;
  FOnWaitingList := nil;
  FOnWaitingListHide := nil;
  FOnWaitingListClose := nil;
  FOnWaitingListConfirm := nil;
end;

procedure TProcessModule.DataModuleDestroy(Sender: TObject);
var
  ProcessObj: TGameProcess;
begin
  ProcessStatsSave;
  FProcessStats.Free;

  while FProcesses.Count > 0 do
  begin
    ProcessObj := FProcesses.Items[0];
    if ProcessObj <> nil then
      ProcessObj.Free;
    FProcesses.Delete(0);
  end;

  FProcesses.Free;
  FUserNotes.Free;
  FWaitingListProcesses.Free;
  FRecordedHands.Free;
  FPreviousHands.SaveToFile(SessionModule.AppPath + ProcessPrevHandsFileName, 'PreviousHands');
  FPreviousHands.Free;
end;


// Set procedures

procedure TProcessModule.SetFlashGameFileName(const Value: String);
begin
  FFlashGameFileName := Value;
end;

procedure TProcessModule.SetRecordedHandsLimit(const Value: Integer);
begin
  FRecordedHandsLimit := Value;
end;

procedure TProcessModule.SetTablesLimit(const Value: Integer);
begin
  FTablesLimit := Value;
end;

procedure TProcessModule.SetTournamentTablesLimit(const Value: Integer);
begin
  FTournamentTablesLimit := Value;
end;

procedure TProcessModule.SetOnWaitingListConfirm(
  const Value: TWaitingListConfirmProc);
begin
  FOnWaitingListConfirm := Value;
end;

procedure TProcessModule.SetOnWaitingListClose(const Value: TSessionEvent);
begin
  FOnWaitingListClose := Value;
end;

procedure TProcessModule.SetOnWaitingListHide(const Value: TSessionEvent);
begin
  FOnWaitingListHide := Value;
end;

procedure TProcessModule.SetOnWaitingList(const Value: TWaitingListProc);
begin
  FOnWaitingList := Value;
end;

procedure TProcessModule.SetOnRequestHandHistory(
  const Value: THandHistoryProc);
begin
  FOnRequestHandHistory := Value;
end;

procedure TProcessModule.SetOnRequestHandHistoryFailed(
  const Value: TSessionEvent);
begin
  FOnRequestHandHistoryFailed := Value;
end;

procedure TProcessModule.SetOnRequestHandHistorySent(
  const Value: TSessionEvent);
begin
  FOnRequestHandHistorySent := Value;
end;

procedure TProcessModule.SetOnProcessStatsShow(const Value: TSessionEvent);
begin
  FOnProcessStatsShow := Value;
end;

procedure TProcessModule.SetOnProcessStatsUpdate(const Value: TSessionEvent);
begin
  FOnProcessStatsUpdate := Value;
end;

procedure TProcessModule.SetOnRecordedHandsShow(const Value: TSessionEvent);
begin
  FOnRecordedHandsShow := Value;
end;

procedure TProcessModule.SetOnRecordedHandsUpdate(const Value: TSessionEvent);
begin
  FOnRecordedHandsUpdate := Value;
end;

procedure TProcessModule.SetOnRecordHandsSaved(const Value: TSessionEvent);
begin
  FOnRecordHandsSaved := Value;
end;

procedure TProcessModule.SetOnRecordHandsSaveFailed(
  const Value: TSessionEvent);
begin
  FOnRecordHandsSaveFailed := Value;
end;


// Process

function TProcessModule.FindProcess(ProcessID: Integer; HandID: Integer = 0): TGameProcess;
var
  Loop: Integer;
  ProcessObj: TGameProcess;
begin
  Result := nil;
  for Loop := 0 to FProcesses.Count - 1 do
  begin
    ProcessObj := FProcesses.Items[Loop];
    if ProcessObj.ProcessID = ProcessID then
      if (HandID = 0) or ((HandID > 0) and (ProcessObj.RecordedHandID = HandID)) then
      begin
        Result := ProcessObj;
        break;
      end;
  end;
end;

procedure TProcessModule.Send(ProcessObj: TGameProcess; Command: String;
  IsAction: Boolean = False);
begin
  Command := StringReplace(Command, #10, '', [rfReplaceAll, rfIgnoreCase]);
  Command := StringReplace(Command, #13, '', [rfReplaceAll, rfIgnoreCase]);
  Command := Trim(Command);
  if Command <> '' then
  begin
    if not IsAction then
      ProcessObj.SendBuffer.Add(Command)
    else
      ProcessObj.ActionBuffer.Add(Command);
    ReallySend(ProcessObj);
  end
  else
    Logger.Add('Command is EMPTY in Send', llVerbose, True);
end;

procedure TProcessModule.ReallySend(ProcessObj: TGameProcess);
var
  Command: String;
begin
  if (not ProcessObj.Busy) and
    ((ProcessObj.SendBuffer.Count > 0) or (ProcessObj.ActionBuffer.Count > 0)) then
  begin
    ProcessObj.Busy := true;
    Command := '';
    if ProcessObj.SendBuffer.Count > 0 then
    begin
      Command := ProcessObj.SendBuffer.Strings[0];
      ProcessObj.SendBuffer.Delete(0);
    end
    else
    if ProcessObj.ActionBuffer.Count > 0 then
    begin
      Command := ProcessObj.ActionBuffer.Strings[0];
      ProcessObj.ActionBuffer.Delete(0);
    end;

    if Command <> '' then
    begin
      Logger.Add('Sent to Process ID=' + inttostr(ProcessObj.ProcessID) + ':', llExtended, true);
      Logger.Add(Command, llExtended, true);

      ProcessObj.ProcessForm.Send(Command);
    end;
  end;
end;


// Start and stop process

procedure TProcessModule.StartTable(ProcessID, ActionDispatcherID: Integer; SubCategoryName,
  ProcessName: String);
begin
  StartProcess(ptTable, ProcessID, 0, 0, ActionDispatcherID, SubCategoryName, ProcessName, '');
end;

procedure TProcessModule.StartRecordedHand(ProcessID, HandID: Integer; HandName,
  HandComment, RecordedHandXML: String);
begin
  StartProcess(ptRecordedHand, ProcessID, HandID, 0, 0, HandComment, HandName, RecordedHandXML);
end;

procedure TProcessModule.StartTournamentTable(ProcessID,TournamentID, ActionDispatcherID: Integer;
      TournamentName, ProcessName: String; TournamentStartDuration: Integer = 0);
begin
  StartProcess(ptTournamentTable, ProcessID, 0, TournamentID, ActionDispatcherID, TournamentName, ProcessName, '', TournamentStartDuration);
end;

procedure TProcessModule.StartProcess(ProcessType: TProcessType; ProcessID, HandID,
      TournamentID, ActionDispatcherID: Integer; SubCategoryName, ProcessName,
      RecordedHandXML: String; TournamentStartDuration: Integer = 0);
var
  ProcessObj: TGameProcess;
  StartAllowed: Boolean;
  Loop: Integer;
  PCount: Integer;
begin
  if SessionModule.SessionState = poRunning then
  begin
    ProcessObj := FindProcess(ProcessID, HandID);
    if ProcessObj <> nil then
    // Show existing
    begin
      if ProcessObj.CurrentState = psWorking then
        ProcessObj.ProcessForm.Start;
    end
    else
    begin
      StartAllowed := true;

      if (ProcessType = ptTable) and (FTablesLimit > 0) then
      begin
        PCount := 0;
        for Loop := 0 to FProcesses.Count - 1 do
          if TGameProcess(FProcesses.Items[Loop]).ProcessType = ptTable then
            PCount := PCount + 1;

        if PCount >= FTablesLimit then
        begin
          ThemeEngineModule.ShowWarning(cstrLimitation + inttostr(FTablesLimit) + ' tables.' + cstrThanks);
          StartAllowed := false;
        end;
      end;

      if (ProcessType = ptTournamentTable) and (FTournamentTablesLimit > 0) then
      begin
        PCount := 0;
        for Loop := 0 to FProcesses.Count - 1 do
          if TGameProcess(FProcesses.Items[Loop]).ProcessType = ptTournamentTable then
            PCount := PCount + 1;

        if PCount >= FTournamentTablesLimit then
        begin
          ThemeEngineModule.ShowWarning(cstrLimitation + inttostr(FTournamentTablesLimit) + ' tournament tables.' + cstrThanks);
          StartAllowed := false;
        end;
      end;

      if (ProcessType = ptRecordedHand) and (FRecordedHandsLimit > 0) then
      begin
        PCount := 0;
        for Loop := 0 to FProcesses.Count - 1 do
          if TGameProcess(FProcesses.Items[Loop]).ProcessType = ptRecordedHand then
            PCount := PCount + 1;

        if PCount >= FRecordedHandsLimit then
        begin
          ThemeEngineModule.ShowWarning(cstrLimitation + inttostr(FRecordedHandsLimit) + ' recorded hands.' + cstrThanks);
          StartAllowed := false;
        end;
      end;

      if StartAllowed then
      begin
        // Create new
        Logger.Add('ProcessModule.StartProcess ID: ' + inttostr(ProcessID), llBase, true);
        ProcessObj := TGameProcess.Create(ProcessType, ProcessID, HandID, TournamentID,
          ActionDispatcherID, SubCategoryName, ProcessName, RecordedHandXML);
        FProcesses.Add(ProcessObj);
        ProcessObj.TournamentStartDuration := TournamentStartDuration;
        ProcessObj.DownloadSessionID := FileManagerModule.DownloadProcessFiles(
          ProcessID, OnUpdatedFilesDownloading);
      end;
    end;
  end;
end;

procedure TProcessModule.OnUpdatedFilesDownloading(This: TDownloadSession);
var
  Loop: Integer;
  curProcess: TGameProcess;
  ProcessObj: TGameProcess;
begin
  ProcessObj := nil;
  for Loop := 0 to FProcesses.Count - 1 do
  begin
    curProcess := TGameProcess(FProcesses.Items[Loop]);
    if curProcess.DownloadSessionID = This.SessionID then
    begin
      ProcessObj := curProcess;
      Break;
    end;
  end;

  if ProcessObj <> nil then
  case This.SessionState of
    gfStart:
      begin
      end;

    gfDownload:
      begin
        if ProcessObj.TakingForm <> nil then
        ProcessObj.TakingForm.StatusLabel.Caption :=  StringReplace(
          ProcessModule.GetLoadingProcessCaption(ProcessObj), 'loading', 'downloading',
          [rfReplaceAll, rfIgnoreCase]) + inttostr(This.PercentCompleted) + '%';
      end;

    gfFinished:
      begin
        if This.FilesToDownload.Count = 0 then
          ProcessObj.Files.AddObject(
            FileManagerModule.FilesPath + FFlashGameFileName, pointer(1));
        if ProcessObj.TakingForm <> nil then
          ProcessObj.TakingForm.StatusLabel.Caption :=
           ProcessModule.GetLoadingProcessCaption(ProcessObj);
        OpenProcess(ProcessObj);
      end;

    gfFailed:
      begin
        StopProcess(ProcessObj.ProcessID, ProcessObj.RecordedHandID);
      end;
  end;
end;

procedure TProcessModule.OnPlayerLogoFileDownloaded(
  This: TDownloadSession);
var
  ProcessObj,curProcess: TGameProcess;
  Loop: Integer;
begin
  ProcessObj := nil;
  for Loop := 0 to FProcesses.Count - 1 do
  begin
    curProcess := TGameProcess(FProcesses.Items[Loop]);
    if curProcess.DownloadSessionID = This.SessionID then
    begin
      ProcessObj := curProcess;
      Break;
    end;
  end;

  if ProcessObj <> nil then
  begin
    if This.SessionState = gfFinished then
      Send_PlayerLogoInfo(ProcessObj,This.DataID,FileManagerModule.FilesPath + IntToStr(This.DataID) + '.jpg');
  end;
end;


procedure TProcessModule.OpenProcess(ProcessObj: TGameProcess);
var
  nInd: Integer;
  FilePath: String;
begin
  if (SessionModule.SessionState = poRunning) and (ProcessObj <> nil) then
  begin
    Logger.Add('ProcessModule.OpenProcess ID: ' +
      inttostr(ProcessObj.ProcessID), llVerbose, true);

    FilePath := '';
    nInd := ProcessObj.Files.IndexOfObject(pointer(1));
    if nInd >= 0 then
      FilePath := ProcessObj.Files.Strings[nInd];

    if FilePath <> '' then
    begin
      ProcessObj.CurrentState := psLoading;
      ProcessObj.ProcessForm.Load(ProcessObj, FilePath);
    end
    else StopProcess(ProcessObj.ProcessID);
  end;
end;

procedure TProcessModule.ChangeTournamentTable(OldProcessID, ProcessID, TournamentID, ActionDispatcherID: Integer;
      TournamentName, ProcessName, Reason: String);
var
  ProcessObj: TGameProcess;
begin
  ProcessObj := FindProcess(OldProcessID, 0);

  if ProcessObj <> nil then
  begin
    ProcessObj.ProcessID := ProcessID;
    ProcessObj.TournamentID := TournamentID;
    ProcessObj.ProcessName := ProcessName;
    UpdateProcessCaption(ProcessObj);
    Send(ProcessObj, GetChangeTableXML(ProcessID, ProcessObj.ProcessName, Reason));
    if ProcessObj.CurrentState = psWorking then
      ProcessObj.ProcessForm.Start;
  end
  else
    StartTournamentTable(ProcessID, TournamentID, ActionDispatcherID,TournamentName, ProcessName);
end;

function TProcessModule.GetChangeTableXML(ProcessID: Integer; ProcessName, Reason: String): String;
{
<changetable newprocessid="127" processname="1245 5"
  reason="You have been moved to Table 1245 5"/>
}
var
  strXML: String;
  RequestXMLDoc: TXMLDocument;
  XMLNode: IXMLNode;
begin
  strXML := '';
  
  try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      RequestXMLDoc.Active := false;
      RequestXMLDoc.XML.Text := '<changetable/>';
      RequestXMLDoc.Active := true;
      XMLNode := RequestXMLDoc.DocumentElement;
      XMLNode.Attributes['newprocessid'] := ProcessID;
      XMLNode.Attributes['processname'] := ProcessName;
      XMLNode.Attributes['reason'] := Reason;

      strXML := RequestXMLDoc.XML.Text;
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Logger.Add('ProcessModule.GetChangeTableXML failed', llBase);
  end;

  Result := strXML;
end;

procedure TProcessModule.Run_Crash(XMLRoot: IXMLNode);
{
<object name="process">
  <gacrash processid="1213"/>
</object>
}
begin
  StopProcess(strtointdef(XMLRoot.Attributes['processid'], 0), 0, true);
end;

procedure TProcessModule.StopProcess(ProcessID: Integer; HandID: Integer = 0; IsCrash: Boolean = false);
var
  Loop: Integer;
  NeedDelete: Boolean;
  ProcessObj: TGameProcess;
begin
  Loop := 0;
  while Loop < FProcesses.Count do
  begin
    NeedDelete := false;
    ProcessObj := FProcesses.Items[Loop];
    if ProcessObj.ProcessID = ProcessID then
      if (HandID = 0) or ((HandID > 0) and (ProcessObj.RecordedHandID = HandID)) then
      begin
        if IsCrash then
          ThemeEngineModule.ShowWarning(cstrProcessCrashed1 +
            GetProcessCaption(ProcessObj) + cstrProcessCrashed2);
        ProcessObj.Free;
        FProcesses.Delete(Loop);
        NeedDelete := true;
        Logger.Add('ProcessModule.StopProcess ID: ' + inttostr(ProcessID), llBase, true);
      end;
    if not NeedDelete then
      Loop := Loop + 1;
  end;

  if FProcesses.Count = 0 then
    if SessionModule.SessionState = poRunning then
      LobbyModule.ShowLobby;
end;

procedure TProcessModule.UpdateConnectingState;
var
  Loop: Integer;
  Connected: Boolean;
  PacketToSend: String;
  ProcessObj: TGameProcess;
begin
  if SessionModule.SessionState <> poTerminating then
    if FProcesses.Count > 0 then
    begin
      Connected := SessionModule.SessionState = poRunning;
      PacketToSend := 'disconnected';
      if Connected then
        PacketToSend := 'connected';
      PacketToSend := '<connection state="' + PacketToSend + '"/>';

      for Loop := FProcesses.Count - 1 downto 0 do
      begin
        ProcessObj := FProcesses.Items[Loop];
        if ProcessObj <> nil then
        begin
          Send(ProcessObj, PacketToSend);
          if Connected then
          begin
            if ProcessObj.CurrentState = psDisconnected then
              ProcessObj.CurrentState := psWaitingProcState;
          end
          else
            if (ProcessObj.CurrentState = psWorking) or
              (ProcessObj.CurrentState = psWaitingProcState) then
              ProcessObj.CurrentState := psDisconnected;
            if (ProcessObj.CurrentState = psDownloading) or
              (ProcessObj.CurrentState = psLoading) then
            begin
              ProcessObj.Free;
              FProcesses.Delete(Loop);
            end;
        end;
      end;
    end;
end;

procedure TProcessModule.RunCommand(XMLRoot: IXMLNode);
var
  Loop: Integer;
  XMLNode: IXMLNode;
  strNode: String;
begin
  Logger.Add('ProcessModule.RunCommand started', llBase);
  try
    if XMLRoot.ChildNodes.Count > 0 then
      for Loop := 0 to XMLRoot.ChildNodes.Count - 1 do
      begin
        XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
        strNode := XMLNode.NodeName;
        Logger.Add('ProcessModule.RunCommand found ' + strNode, llBase);

        if strNode = 'gaaction' then
          Run_Action(XMLNode)
        else
        if strNode = 'apgetnotes' then
          Run_Notes(XMLNode)
        else
        if strNode = 'gacrash' then
          Run_Crash(XMLNode)
        else
        if strNode = 'aprequesthandhistory' then
          Run_RequestHandHistory(XMLNode)
        else
        if strNode = 'apcheckhandid' then
          Run_CheckHandID(XMLNode)
        else
        if strNode = 'apsaverecordedhands' then
          Run_SaveRecordedHands(XMLNode)
        else
        if strNode = 'apgetrecordedhands' then
          Run_GetRecordedHands(XMLNode)
        else
        if strNode = 'apgetrecordedhandhistory' then
          Run_LoadRecordedHand(XMLNode)
        else
        if strNode = 'apgetwaitinglistinfo' then
          Run_GetWaitingListInfo(XMLNode)
        else
        if strNode = 'apregisteratwaitinglist' then
          Run_RegisterWaitingList(XMLNode)
        else
        if strNode = 'apunregisterfromwaitinglist' then
          Run_UnregisterWaitingList(XMLNode)
        else
        if strNode = 'wltakeplace' then
          Run_TakePlaceWaitingList(XMLNode)
        else
        if strNode = 'wlcancel' then
          Run_CancelWaitingList(XMLNode);

      end;
  except
    Logger.Add('ProcessModule.RunCommand failed', llBase);
  end;
end;

procedure TProcessModule.Run_Action(XMLRoot: IXMLNode);
{
<object name="process">
  <gaaction processid="1213">
    ...
  </gaaction>
</object>
}
var
  ProcessObj: TGameProcess;
begin
  ProcessObj := FindProcess(strtointdef(XMLRoot.Attributes[XMLATTRNAME_PROCESSID], 0), 0);
  if ProcessObj = nil then
  Exit;

  if ProcessObj.CurrentState = psWorking then
    Send(ProcessObj, XMLRoot.XML, True)
  else
    if pos('procclose', XMLRoot.XML) > 0 then
      Send(ProcessObj, XMLRoot.XML, True)
    else
    if (pos('procinit', XMLRoot.XML) > 0) or
      ((ProcessObj.CurrentState = psWaitingProcState) and
      (pos('procstate', XMLRoot.XML) > 0)) then
      begin
        ProcessObj.CurrentState := psWorking;
        Send(ProcessObj, XMLRoot.XML, True);
      end
      else
      begin
        Logger.Add('ProcessModule.Run_Action: action did not send ' +
          'because "procinit" or "procstate" actions did not received on open table:', llExtended, True);
        Logger.Add(XMLRoot.XML, llExtended, True);
      end;
end;

procedure TProcessModule.DoCommand(ProcessObj: TGameProcess; Command: String);
var
  RequestXMLDoc: TXMLDocument;
  XMLRoot: IXMLNode;
  strRoot: String;
begin
  Logger.Add('Received from Process ID=' + inttostr(ProcessObj.ProcessID) + ':', llExtended, true);
  Logger.Add(Command, llExtended, true);

  if Command <> '' then
  try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      RequestXMLDoc.Active := false;
      RequestXMLDoc.XML.Text := Command;
      RequestXMLDoc.Active := true;
      XMLRoot := RequestXMLDoc.DocumentElement;
      strRoot := XMLRoot.NodeName;
      Logger.Add('Received from Process found ' + strRoot);

      if strRoot = 'readytoreceive' then
        Do_ReadyToReceive(ProcessObj, XMLRoot)
      else
      if strRoot = 'gaaction' then
        Do_Action(ProcessObj, XMLRoot)
      else
      if strRoot = 'newhand' then
        Do_NewHand(ProcessObj, XMLRoot)
      else
      if strRoot = 'getuserbalance' then
        Do_GetBalance(ProcessObj, XMLRoot)
      else
      if strRoot = 'sitdown' then
        Do_SitDown(ProcessObj, XMLRoot)
      else
      if strRoot = 'loaded' then
        Do_Loaded(ProcessObj, XMLRoot)
      else
      if strRoot = 'gamestarted' then
        Do_Start(ProcessObj, XMLRoot)
      else
      if strRoot = 'windowstate' then
        Do_WindowState(ProcessObj, XMLRoot)
      else
      if strRoot = 'gamefinished' then
        Do_Finish(ProcessObj, XMLRoot)
      else
      if strRoot = 'gamestats' then
        Do_ProcessStats(ProcessObj, XMLRoot)
      else
      if strRoot = 'getnotes' then
        Do_Notes(ProcessObj, XMLRoot)
      else
      if strRoot = 'savenotes' then
        Do_SaveNotes(ProcessObj, XMLRoot)
      else
      if strRoot = 'options' then
        Do_Options(ProcessObj, XMLRoot)
      else
      if strRoot = 'login' then
        Do_Login(ProcessObj, XMLRoot)
      else
      if strRoot = 'help' then
        Do_Help(ProcessObj, XMLRoot)
      else
      if strRoot = 'allins' then
        Do_AllIns(ProcessObj, XMLRoot)
      else
      if strRoot = 'handhistory' then
        Do_HandHistory(ProcessObj, XMLRoot)
      else
      if strRoot = 'record' then
        Do_RecordHand(ProcessObj, XMLRoot)
      else
      if strRoot = 'waitinglist' then
        Do_WaitingList(ProcessObj, XMLRoot)
      else
      if strRoot = 'waitingliststatus' then
        Do_WaitingListStatus(ProcessObj, XMLRoot)
      else
      if strRoot = 'viewlobby' then
        Do_ViewLobby(ProcessObj)
      else
      if strRoot = 'viewcashier' then
        CashierModule.StartWork
      else
      if strRoot = 'getavatarlogo' then
        Do_GetPlayerLogo(ProcessObj,XMLRoot){}
      else
      if strRoot = 'autorebuy' then
        Do_AutoRebuy(ProcessObj, XMLRoot)
      else
      if strRoot = 'addon' then
        TournamentModule.Do_Addon(ProcessObj.TournamentID,1);

    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Logger.Add('ProcessModule.DoCommand failed', llBase);
  end;
end;

procedure TProcessModule.Do_ReadyToReceive(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
begin
  ProcessObj.Busy := false;
  ReallySend(ProcessObj);
end;

procedure TProcessModule.Do_Action(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
{
<gaaction processid="1213">
...
</gaaction>}
var
  Command: String;
begin
 { if ProcessObj.ProcessType <> ptRecordedHand then
  begin
    XMLRoot.Attributes['userid'] := UserModule.UserID;
    XMLRoot.Attributes[XMLNODENAME_ACTIONDISPATCHERID] := ProcessObj.ActionDispatcherID;
    Command :=
    '<objects>' +
      '<object name="gameadapter">' +
           XMLRoot.XML +
      '</object>' +
    '</objects>';
    TCPSocketModule.Send(Command);
  end;{}
  if ProcessObj.ProcessType <> ptRecordedHand then
  begin
    XMLRoot.Attributes[XMLNODENAME_ACTIONDISPATCHERID] := ProcessObj.ActionDispatcherID;
    XMLRoot.Attributes[XMLATTRNAME_PROCESSID] := ProcessObj.ProcessID;
    XMLRoot.Attributes[XMLATTRNAME_USERID] := UserModule.UserID;
    XMLRoot.Attributes[XMLATTRNAME_SESSIONID] := SessionModule.SessionID;

    Command :=
    '%' + inttostr(ProcessObj.ProcessID) + ',' +
      inttostr(ProcessObj.ActionDispatcherID) + '*' +
      XMLRoot.XML;
{
    '<objects>' +
      '<object name="gameadapter">' +
           XMLRoot.XML +
      '</object>' +
    '</objects>';
}
    TCPSocketModule.Send(Command);
  end;
end;

procedure TProcessModule.Do_Loaded(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
{
<loaded width="790" height="540" version="Game version: 1.1016"/>
}
var
  ProcessWidth: Integer;
  ProcessHeight: Integer;
begin
  if XMLRoot.HasAttribute('version') then
    SessionModule.SessionSettings.ValuesAsString[SessionGameVersion] :=
      XMLRoot.Attributes['version'];
  ProcessWidth := strtointdef(XMLRoot.Attributes['width'], 784);
  ProcessHeight := strtointdef(XMLRoot.Attributes['height'], 552);
  ProcessObj.ProcessForm.SetSize(ProcessWidth, ProcessHeight);

  Send_ProcessInit(ProcessObj);
  Send(ProcessObj, GetOptionsXML(ProcessObj));
  Send(ProcessObj, GetLoggedXML);
  Send(ProcessObj, GetChatStateXML);
  SendWaitingListStatusXML(ProcessObj);
  Send_TournamentStart(ProcessObj);
end;

procedure TProcessModule.Send_ProcessInit(ProcessObj: TGameProcess);
{
  <init avatarid="3" sexid="1">
    <logo filename="logo3.swf"/>
    <file filename="background.swf"/>
    <gaaction.../>
  </init>
}
var
  RequestXMLDoc: TXMLDocument;
  XMLRoot: IXMLNode;
begin
  try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      RequestXMLDoc.Active := false;
      if (ProcessObj.ProcessType = ptRecordedHand) and (ProcessObj.RecordedHandXML <> '') then
        RequestXMLDoc.XML.Text := '<init>' + ProcessObj.RecordedHandXML + '</init>'
      else
        RequestXMLDoc.XML.Text := '<init/>';
      RequestXMLDoc.Active := true;
      XMLRoot := RequestXMLDoc.DocumentElement;
      XMLRoot.Attributes['processid'] := ProcessObj.ProcessID;
      XMLRoot.Attributes['processname'] := ProcessObj.ProcessName;
      XMLRoot.Attributes['subcategoryname'] := ProcessObj.ProcessOpts;
      XMLRoot.Attributes['rhand'] := ProcessObj.RecordedHandID;
      XMLRoot.Attributes['sessionid'] := SessionModule.SessionID;

      FileManagerModule.FillLogoFiles(XMLRoot);
      Send(ProcessObj, XMLRoot.XML);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Logger.Add('ProcessModule.ProcessInit failed', llBase);
  end;
end;

procedure TProcessModule.Do_Start(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
begin
  with ProcessObj do
  begin
    LobbyModule.MinimizeLobby;

    if TakingForm <> nil then
    begin
      TakingForm.Free;
      TakingForm.OnClose := nil;
      TakingForm := nil;
    end;

    if XMLRoot.HasAttribute('caption') and (ProcessType <> ptRecordedHand) then
      ProcessOpts := XMLRoot.Attributes['caption'];
    UpdateProcessCaption(ProcessObj);
    CurrentState := psWorking;
    ProcessForm.Start;
  end;
end;

procedure TProcessModule.Do_Finish(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
begin
  ProcessObj.ProcessForm.Hide;
  FFinishingProcessID := ProcessObj.ProcessID;
  FFinishingProcessHandID := ProcessObj.RecordedHandID;
  FinishProcessTimer.Enabled := true;
  if XMLRoot.HasAttribute('reason') then
    ThemeEngineModule.ShowMessage(XMLRoot.Attributes['reason']);
end;

procedure TProcessModule.StopLoading(ID1, ID2: Integer);
begin
  FFinishingProcessID := ID1;
  FFinishingProcessHandID := ID2;
  FinishProcessTimer.Enabled := true;
end;

procedure TProcessModule.FinishProcessTimerTimer(Sender: TObject);
begin
  FinishProcessTimer.Enabled := false;
  StopProcess(FFinishingProcessID, FFinishingProcessHandID);
end;

function TProcessModule.GetProcessList(ProcessList: TStringList): Boolean;
var
  Loop: Integer;
  ProcessObj: TGameProcess;
begin
  ProcessList.Clear;
  for Loop := 0 to FProcesses.Count - 1 do
  begin
    ProcessObj := FProcesses.Items[Loop];
    ProcessList.AddObject(GeTProcessCaption(ProcessObj), pointer(ProcessObj.ProcessID));
  end;
  Result := ProcessList.Count > 0;
end;

function TProcessModule.GetProcessCaption(ProcessObj: TGameProcess): String;
begin
  Result := GetOneLineComments(ProcessObj.ProcessOpts + ' ' + ProcessObj.ProcessName);
  if SessionModule.SessionSettings.ValuesAsBoolean[RegistryDebugKey] and
    (SessionModule.SessionSettings.ValuesAsString[RegistryDebugIdent] = RegistryDebugVerbose) then
    Result := Result + ' :: ProcessID=' + inttostr(ProcessObj.ProcessID) +
      ', HandID=' + inttostr(ProcessObj.ProcessHandID);
end;

function TProcessModule.GetOneLineComments(Value: String): String;
begin
  Result := StringReplace(Value, #10, ' ', [rfIgnoreCase, rfReplaceAll]);
  Result := StringReplace(Result, #13, ' ', [rfIgnoreCase, rfReplaceAll]);
end;

procedure TProcessModule.Do_GetBalance(ProcessObj: TGameProcess;
  XMLRoot: IXMLNode);
{
<getuserbalance id="1" value="10000" sign=""/>
}
begin
  ProcessObj.CurrencyID := strtointdef(XMLRoot.Attributes[XMLATTRNAME_ID], 0);
  if UserModule.Logged then
    Send_Balance(ProcessObj)
  else
    UserModule.Login;
end;

procedure TProcessModule.UpdateUserBalance;
var
  Loop: Integer;
  ProcessObj: TGameProcess;
  strXML: String;
begin
  strXML := GetLoggedXML;
  if strXML <> '' then
    for Loop := 0 to FProcesses.Count - 1 do
    try
      ProcessObj := FProcesses.Items[Loop];
      if (ProcessObj.CurrentState = psLoading) or (ProcessObj.CurrentState = psWorking) then
        Send_Balance(ProcessObj);
    except
      Logger.Add('ProcessModule.UpdateUserBalance failed', llBase);
    end;
end;

procedure TProcessModule.Send_Balance(ProcessObj: TGameProcess);
{
<getuserbalance id="1" value="10000" sign=""/>
}
var
  curBalance: TDataList;
  curMoney: TDataList;
  strXML: String;
  RequestXMLDoc: TXMLDocument;
  XMLNode   : IXMLNode;
  BalanceAmount: String;
  ReservedAmount: String;
  CurrencySign: String;
begin
  BalanceAmount := '0';
  ReservedAmount := '0';
  CurrencySign := '';

  if CashierModule.Balance.Find(ProcessObj.CurrencyID, curBalance) then
  begin
    BalanceAmount := Conversions.Cur2Str(Conversions.Str2Cur(curBalance.ValuesAsString['balance']));
    ReservedAmount := Conversions.Cur2Str(Conversions.Str2Cur(curBalance.ValuesAsString['reserved']));
  end;

  if Conversions.CurrencyList.Find(ProcessObj.CurrencyID, curMoney) then
    CurrencySign := curMoney.ValuesAsString['sign'];

  try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      RequestXMLDoc.Active := false;
      RequestXMLDoc.XML.Text := '<getuserbalance/>';
      RequestXMLDoc.Active := true;
      XMLNode := RequestXMLDoc.DocumentElement;
      XMLNode.Attributes[XMLATTRNAME_ID] := ProcessObj.CurrencyID;
      XMLNode.Attributes['value'] := BalanceAmount;
      XMLNode.Attributes['reserved'] := ReservedAmount;
      XMLNode.Attributes['sign'] := CurrencySign;

      strXML := RequestXMLDoc.XML.Text;
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    strXML := '';
    Logger.Add('ProcessModule.Do_GetBalance failed', llBase);
  end;

  if strXML <> '' then
    Send(ProcessObj, strXML);
end;

procedure TProcessModule.UpdateOptions;
var
  Loop: Integer;
  ProcessObj: TGameProcess;
  strXML: String;
begin
    for Loop := 0 to FProcesses.Count - 1 do
    try
      ProcessObj := FProcesses.Items[Loop];
      if (ProcessObj.CurrentState = psLoading) or (ProcessObj.CurrentState = psWorking) then
      begin
        strXML := GetOptionsXML(ProcessObj);
        if strXML <> '' then
        Send(ProcessObj, strXML);
      end;
    except
      Logger.Add('ProcessModule.UpdateOptions failed', llBase);
    end;
end;

function TProcessModule.GetOptionsXML(ProcessObj: TGameProcess): String;
{
<options>
  <option name="DeckColor" value="black"/>
  <option name="Use4ColorsDeck" value="0"/>
  <option name="EnableAnimation" value="1"/>
  <option name="EnableChatBubbles" value="1"/>
  <option name="EnableSounds" value="1"/>
  <option name="ReverseStereoPanning" value="0"/>
  <option name="ChatMode" value="2"/>
</options>
}
var
  RequestXMLDoc: TXMLDocument;
  XMLRoot: IXMLNode;
  XMLNode: IXMLNode;
  curTournament: TTournamentProcess;
begin
  try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      RequestXMLDoc.Active := false;
      RequestXMLDoc.XML.Text := '<options/>';
      RequestXMLDoc.Active := true;
      XMLRoot := RequestXMLDoc.DocumentElement;

      XMLNode := XMLRoot.AddChild('option');
      XMLNode.Attributes['name'] := SessionDeckColor;
      XMLNode.Attributes['value'] := SessionModule.SessionSettings.ValuesAsString[SessionDeckColor];

      XMLNode := XMLRoot.AddChild('option');
      XMLNode.Attributes['name'] := SessionUse4ColorsDeck;
      XMLNode.Attributes['value'] := SessionModule.SessionSettings.ValuesAsString[SessionUse4ColorsDeck];

      XMLNode := XMLRoot.AddChild('option');
      XMLNode.Attributes['name'] := SessionEnableAnimation;
      XMLNode.Attributes['value'] := SessionModule.SessionSettings.ValuesAsString[SessionEnableAnimation];

      XMLNode := XMLRoot.AddChild('option');
      XMLNode.Attributes['name'] := SessionEnableChatBubbles;
      XMLNode.Attributes['value'] := SessionModule.SessionSettings.ValuesAsString[SessionEnableChatBubbles];

      XMLNode := XMLRoot.AddChild('option');
      XMLNode.Attributes['name'] := SessionEnableSounds;
      XMLNode.Attributes['value'] := SessionModule.SessionSettings.ValuesAsString[SessionEnableSounds];

      XMLNode := XMLRoot.AddChild('option');
      XMLNode.Attributes['name'] := SessionReverseStereoPanning;
      XMLNode.Attributes['value'] := SessionModule.SessionSettings.ValuesAsString[SessionReverseStereoPanning];

      XMLNode := XMLRoot.AddChild('option');
      XMLNode.Attributes['name'] := SessionChatMode;
      XMLNode.Attributes['value'] := SessionModule.SessionSettings.ValuesAsString[SessionChatMode];

      if ProcessObj <> nil then
      begin
       curTournament := TournamentModule.GetTournament(ProcessObj.TournamentID);
       if (curTournament <> nil) then
       begin
       XMLNode := XMLRoot.AddChild('option');
       XMLNode.Attributes['name'] := 'rebuyallowed';
       if (curTournament.RebuyAllowed) then
         XMLNode.Attributes['value'] := 1
       else
        XMLNode.Attributes['value'] := 0;

       if curTournament.AddonAllowed then
        XMLNode.Attributes['value'] := 1;

       XMLNode := XMLRoot.AddChild('option');
       XMLNode.Attributes['name'] := 'autorebuy';
       if (curTournament.AutoRebuy) then
         XMLNode.Attributes['value'] := 1
       else
        XMLNode.Attributes['value'] := 0;

        XMLNode := XMLRoot.AddChild('option');
       XMLNode.Attributes['name'] := 'addonbuttonstate';
       if (curTournament.AddonAllowed) then
         XMLNode.Attributes['value'] := 1
       else
        XMLNode.Attributes['value'] := 0;
      end;

     end;
      
      Result := RequestXMLDoc.XML.Text;
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Result := '';
    Logger.Add('ProcessModule.GetOptionsXML failed', llBase);
  end;
end;

procedure TProcessModule.Do_Options(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
var
  Loop: Integer;
  XMLNode: IXMLNode;
begin
  if XMLRoot.ChildNodes.Count > 0 then
    for Loop := 0 to XMLRoot.ChildNodes.Count - 1 do
    begin
      XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
      SessionModule.SessionSettings.ValuesAsString[XMLNode.Attributes['name']] :=
       XMLNode.Attributes['value'];
    end;
  SessionModule.SaveToRegistry;
  UpdateOptions;
end;

procedure TProcessModule.UpdateLoginState;
var
  Loop: Integer;
  ProcessObj: TGameProcess;
  strXML: String;
begin
  strXML := GetLoggedXML;
  if strXML <> '' then
    for Loop := 0 to FProcesses.Count - 1 do
    try
      ProcessObj := FProcesses.Items[Loop];
      if (ProcessObj.CurrentState = psLoading) or (ProcessObj.CurrentState = psWorking) then
      begin
        Send(ProcessObj, strXML);
        UpdateProcessCaption(ProcessObj);
      end;
    except
      Logger.Add('ProcessModule.UpdateLoginState failed', llBase);
    end;
end;

function TProcessModule.GetLoggedXML: String;
{
<logged userid="17" userlogin="2blucky"/>
}
var
  RequestXMLDoc: TXMLDocument;
  XMLRoot: IXMLNode;
begin
  try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      RequestXMLDoc.Active := false;
      RequestXMLDoc.XML.Text := '<logged/>';
      RequestXMLDoc.Active := true;
      XMLRoot := RequestXMLDoc.DocumentElement;
      if UserModule.Logged then
      begin
        XMLRoot.Attributes['userid'] := UserModule.UserID;
        XMLRoot.Attributes['userlogin'] := UserModule.UserName;
      end
      else
      begin
        XMLRoot.Attributes['userid'] := 0;
        XMLRoot.Attributes['userlogin'] := '';
      end;
      Result := RequestXMLDoc.XML.Text;
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Result := '';
    Logger.Add('ProcessModule.GetLoggedXML failed', llBase);
  end;
end;

procedure TProcessModule.Do_Help(ProcessObj: TGameProcess;
  XMLRoot: IXMLNode);
{
<help/>
}
begin
  LobbyModule.Do_Action(laHelp);
end;

procedure TProcessModule.Do_NewHand(ProcessObj: TGameProcess;
  XMLRoot: IXMLNode);
{
<newhand handid="1234"/>
}
var
  curHand: TDataList;
  curHandID: Integer;
begin
  curHandID := StrToIntDef(XMLRoot.Attributes['handid'], 0);
  if curHandID = 0 then
    Exit;

  ProcessObj.ProcessHandID := curHandID;
  if not FPreviousHands.Find(curHandID, curHand) then
  begin
    curHand := FPreviousHands.Add(curHandID);
    curHand.Name := ProcessObj.ProcessName;
    curHand.Value := ProcessObj.ProcessOpts;
    curHand.ValuesAsInteger['processid'] := ProcessObj.ProcessID;

    while FPreviousHands.Count > 10 do
      FPreviousHands.Delete(0);

    if Assigned(FOnRecordedHandsUpdate) then
      FOnRecordedHandsUpdate;
  end;
end;

procedure TProcessModule.Do_Login(ProcessObj: TGameProcess;
  XMLRoot: IXMLNode);
begin
  UserModule.Login;
end;


function TProcessModule.IsProcessHandle(checkedHandle: THandle): Boolean;
var
  Loop: Integer;
  ProcessObj: TGameProcess;
begin
  Result := false;
  for Loop := 0 to FProcesses.Count - 1 do
  begin
    ProcessObj := FProcesses.Items[Loop];
    if ProcessObj.ProcessForm.ShockwaveFlash.Handle = checkedHandle then
    begin
      Result := true;
      break;
    end;
  end;
end;


// Game stats

procedure TProcessModule.ProcessStatsLoad;
begin
  if SessionModule.SessionSettings.ValuesAsBoolean[SessionProcessStatsPreserve] then
    FProcessStats.LoadFromFile(SessionModule.AppPath + ProcessStatsFileName);
  FProcessStats.ValuesAsBoolean['ContinueSession'] :=
    SessionModule.SessionSettings.ValuesAsBoolean[SessionProcessStatsPreserve];
end;

procedure TProcessModule.ProcessStatsSave;
var
  XMLDoc: TXMLDocument;
  XMLRoot: IXMLNode;
  XMLNode: IXMLNode;
  LogFileName: String;
  strXML: TStringList;
begin
  FProcessStats.ValuesAsTDateTime['Recorded'] := now;
  FProcessStats.SaveToFile(SessionModule.AppPath + ProcessStatsFileName, ProcessStatsRootName);

  if SessionModule.SessionSettings.ValuesAsBoolean[SessionProcessLogging] then
  try
    LogFileName := SessionModule.AppPath + ProcessStatsLogFileName;
    XMLDoc := TXMLDocument.Create(Self);
    strXML := TStringList.Create;
    try
      XMLDoc.Active := false;
      if FileExists(LogFileName) then
        XMLDoc.XML.LoadFromFile(LogFileName)
      else
        XMLDoc.XML.Text := '<' + ProcessStatsLogRootName + '/>';
      XMLDoc.Active := true;
      XMLRoot := XMLDoc.DocumentElement;
      XMLNode := XMLRoot.AddChild(ProcessStatsRootName);
      FProcessStats.SaveToXML(XMLNode, true);
      strXML.Text := FormatXMLData(XMLRoot.XML);
      strXML.SaveToFile(LogFileName);
    finally
      XMLDoc.Active := false;
      XMLDoc.Free;
      strXML.Free;
    end;
  except
    Logger.Add('ProcessModule.GetLoggedXML failed', llBase);
  end;
end;

procedure TProcessModule.Do_ProcessStatsClear;
var
  Loop: Integer;
  Loop2: Integer;
  curStat: TDataList;
begin
  ProcessStatsSave;

  for Loop := 0 to FProcessStats.Count - 1 do
  begin
    curStat := FProcessStats.Items(Loop);
    for Loop2:= 0 to curStat.ValueCount - 1 do
    begin
      if strtointdef(curStat.Values[Loop2], 0) > 0 then
        curStat.Values[Loop2] := 0;
    end;
  end;

  if Assigned(FOnProcessStatsUpdate) then
    FOnProcessStatsUpdate;

  FProcessStats.ValuesAsBoolean['ContinueSession'] := false;
  ProcessStatsSave;
  FProcessStats.ValuesAsBoolean['ContinueSession'] :=
    SessionModule.SessionSettings.ValuesAsBoolean[SessionProcessStatsPreserve];
end;

procedure TProcessModule.Do_ProcessStats(ProcessObj: TGameProcess;
  XMLRoot: IXMLNode);
var
  strNode: String;
begin
  strNode := XMLRoot.Attributes[XMLATTRNAME_NAME];
  if strNode = 'show' then
    Do_ProcessStatsShow(ProcessObj, XMLRoot)
  else
  if strNode = 'gamestarted' then
    Do_ProcessStatsStarted(ProcessObj, XMLRoot)
  else
  if strNode = 'gameaction' then
    Do_ProcessStatsAction(ProcessObj, XMLRoot)
  else
  if strNode = 'gamefinished' then
    Do_ProcessStatsFinished(ProcessObj, XMLRoot);
end;

procedure TProcessModule.Do_ProcessStatsShow(ProcessObj: TGameProcess;
  XMLRoot: IXMLNode);
{
<gamestats name="show" pokertype="1"/>
}
begin
  FCurrentGameType := strtointdef(XMLRoot.Attributes[XMLATTRNAME_GAMETYPE], 0);

  if Assigned(FOnProcessStatsShow) then
    FOnProcessStatsShow;
end;

procedure TProcessModule.Do_ChangeCurrentStatsGameType(NewGameType: Integer);
begin
  if NewGameType <> FCurrentGameType then
    FCurrentGameType := NewGameType;

  if Assigned(FOnProcessStatsUpdate) then
    FOnProcessStatsUpdate;
end;

procedure TProcessModule.Do_ProcessStatsStarted(ProcessObj: TGameProcess;
  XMLRoot: IXMLNode);
{
<gamestats name="gamestarted"
           pokertype="1|..."
           gamename="Hold'em"
           flopname="Flop|4th street"
           winflopname="Flop|4th street">
  <stats name="Pre-flop"     />
  <stats name="Flop"         />
  <stats name="Turn"         />
  <stats name="River"        />
  <stats name="No fold"      />
  <stats name="Third street" />
  <stats name="Fourth street"/>
  <stats name="Fifth street" />
  <stats name="Sixth street" />
</gamestats>
}
var
  GameID: Integer;
  curGame: TDataList;
  Loop: Integer;
  curStats: String;
begin
  GameID := strtointdef(XMLRoot.Attributes[XMLATTRNAME_GAMETYPE], 0);
  if GameID > 0 then
  begin
    if not FProcessStats.Find(GameID, curGame) then
      curGame := FProcessStats.Add(GameID);

    curGame.ValuesAsString['gamename'] := XMLRoot.Attributes['gamename'];
    curGame.ValuesAsString['flopname'] := XMLRoot.Attributes['flopname'];
    curGame.ValuesAsString['winflopname'] := XMLRoot.Attributes['winflopname'];

    for Loop := 0 to XMLRoot.ChildNodes.Count - 1 do
    begin
      curStats := 'foldon_' + lowercase(XMLRoot.ChildNodes.Nodes[Loop].Attributes[XMLATTRNAME_NAME]);
      if curGame.ValuesAsString[curStats] = '' then
        curGame.ValuesAsString[curStats] := '0';
    end;

    if Assigned(FOnProcessStatsUpdate) then
      FOnProcessStatsUpdate;
  end;
end;

procedure TProcessModule.Do_ProcessStatsAction(ProcessObj: TGameProcess;
  XMLRoot: IXMLNode);
{
<gamestats name="gameaction" pokertype="1|..."
           action="fold|check|call|bet|raise|reraise"/>
}
var
  GameID: Integer;
  curGame: TDataList;
  strAction: String;
begin
  GameID := strtointdef(XMLRoot.Attributes[XMLATTRNAME_GAMETYPE], 0);
  if GameID > 0 then
  begin
    if not FProcessStats.Find(GameID, curGame) then
      curGame := FProcessStats.Add(GameID);

    strAction := XMLRoot.Attributes['action'];
    curGame.ValuesAsInteger[strAction] := curGame.ValuesAsInteger[strAction] + 1;
    curGame.ValuesAsInteger['actionsall'] := curGame.ValuesAsInteger['actionsall'] + 1;
    if Assigned(FOnProcessStatsUpdate) then
      FOnProcessStatsUpdate;
  end;
end;

procedure TProcessModule.Do_ProcessStatsFinished(ProcessObj: TGameProcess;
  XMLRoot: IXMLNode);
{
<gamestats name="gamefinished" 
           pokertype="1|..." 
           result="won|lose"
           showdowncount="3"
           winshowdowncount="3"
           flopseen="0|1"
           flopparticipate="0|1"
           foldon="Pre-flop"/>
}
var
  GameID: Integer;
  curGame: TDataList;
  HandResult: String;
  curStats: String;
begin
  GameID := strtointdef(XMLRoot.Attributes[XMLATTRNAME_GAMETYPE], 0);
  if GameID > 0 then
  begin
    if not FProcessStats.Find(GameID, curGame) then
      curGame := FProcessStats.Add(GameID);

    HandResult := lowercase(XMLRoot.Attributes['result']);
    curGame.ValuesAsInteger[HandResult] := curGame.ValuesAsInteger[HandResult] + 1;
    curGame.ValuesAsInteger['showdowncount'] := curGame.ValuesAsInteger['showdowncount'] +
      strtointdef(XMLRoot.Attributes['showdowncount'], 0);
    curGame.ValuesAsInteger['winshowdowncount'] := curGame.ValuesAsInteger['winshowdowncount'] +
      strtointdef(XMLRoot.Attributes['winshowdowncount'], 0);

    curGame.ValuesAsInteger['flopseen'] := curGame.ValuesAsInteger['flopseen'] + 1;
    if XMLRoot.Attributes['flopparticipate'] = '1' then
    begin
      curGame.ValuesAsInteger['flopparticipate'] := curGame.ValuesAsInteger['flopparticipate'] + 1;
      if HandResult = 'won' then
        curGame.ValuesAsInteger['winflopseen'] := curGame.ValuesAsInteger['winflopseen'] + 1;
    end;

    curStats := 'foldon_' + lowercase(XMLRoot.Attributes['foldon']);
    curGame.ValuesAsInteger[curStats] := curGame.ValuesAsInteger[curStats] + 1;

    if Assigned(FOnProcessStatsUpdate) then
      FOnProcessStatsUpdate;
  end;
end;

procedure TProcessModule.ViewStatistics;
begin
  if Assigned(FOnProcessStatsShow) then
    FOnProcessStatsShow;
end;

procedure TProcessModule.LoggedNow;
begin
  FProcessStats.ValuesAsString['SessionStart'] := DateTimeToStr(now());
  if Assigned(FOnProcessStatsUpdate) then
    FOnProcessStatsUpdate;
  ParserModule.Send_GetRecordedHands;
end;


// Notes

procedure TProcessModule.Run_Notes(XMLRoot: IXMLNode);
{
<object name="process">
  <apgetnotes result="0|..."
   foruserid="1213" notes="He is the best poker player"/>
</object>
}
var
  ForUserID: Integer;
  Notes: String;
begin
  ForUserID := strtointdef(XMLRoot.Attributes['foruserid'], 0);
  Notes := XMLRoot.Attributes['notes'];
  SetUserNotes(ForUserID, Notes);
end;

procedure TProcessModule.Do_Notes(ProcessObj: TGameProcess;
  XMLRoot: IXMLNode);
{
<getnotes foruserid="324"/>
}
var
  ForUserID: Integer;
  nInd: Integer;
begin
  ForUserID := strtointdef(XMLRoot.Attributes['foruserid'], 0);

  nInd := FUserNotes.IndexOfObject(pointer(ForUserID));
  if nInd >= 0 then
    Send(ProcessObj, GetUserNotesXML(ForUserID))
  else
    ParserModule.Send_GetNotes(ForUserID);
end;

procedure TProcessModule.Do_SaveNotes(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
{
<savenotes foruserid="324" notes="He is the best poker player"/>
}
var
  ForUserID: Integer;
  Notes: String;
begin
  ForUserID := strtointdef(XMLRoot.Attributes['foruserid'], 0);
  Notes := XMLRoot.Attributes['notes'];
  SetUserNotes(ForUserID, Notes);

  if SaveNotesTimer.Enabled and (SaveNotesTimer.Tag <> ForUserID) then
    SaveNotesTimerTimer(SaveNotesTimer);
    
  SaveNotesTimer.Enabled := False;
  SaveNotesTimer.Tag := ForUserID;
  SaveNotesTimer.Enabled := True;
end;

procedure TProcessModule.SaveNotesTimerTimer(Sender: TObject);
var
  ForUserID: Integer;
  Notes: String;
begin
  ForUserID := SaveNotesTimer.Tag;
  Notes := GetUserNotes(ForUserID);
  if (ForUserID > 0) and (Notes <> '') then
    ParserModule.Send_SaveNotes(ForUserID, Notes);
  SaveNotesTimer.Enabled := False;
end;

procedure TProcessModule.SetUserNotes(ForUserID: Integer; Notes: String);
var
  nInd: Integer;
begin
  nInd := FUserNotes.IndexOfObject(pointer(ForUserID));
  if nInd >= 0 then
    FUserNotes.Strings[nInd] := Notes
  else
    FUserNotes.AddObject(Notes, pointer(ForUserID));

  Send_Notes(ForUserID);
end;

function TProcessModule.GetUserNotes(ForUserID: Integer): String;
var
  nInd: Integer;
begin
  Result := '';
  nInd := FUserNotes.IndexOfObject(pointer(ForUserID));
  if nInd >= 0 then
    Result := FUserNotes.Strings[nInd];
end;

function TProcessModule.GetUserNotesXML(ForUserID: Integer): String;
{
<getnotes foruserid="1213" notes="He is the best poker player"/>
}
var
  Notes: String;
  RequestXMLDoc: TXMLDocument;
  XMLNode   : IXMLNode;
begin
  Result := '';
  Notes := GetUserNotes(ForUserID);
  try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      RequestXMLDoc.Active := false;
      RequestXMLDoc.XML.Text := '<getnotes/>';
      RequestXMLDoc.Active := true;
      XMLNode := RequestXMLDoc.DocumentElement;
      XMLNode.Attributes['foruserid'] := inttostr(ForUserID);
      XMLNode.Attributes['notes'] := Notes;

      Result := RequestXMLDoc.XML.Text;
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Logger.Add('ProcessModule.GetUserNotesXML failed', llBase);
  end;
end;

procedure TProcessModule.Send_Notes(ForUserID: Integer);
var
  Loop: Integer;
  ProcessObj: TGameProcess;
  strXML: String;
begin
  strXML := GetUserNotesXML(ForUserID);
  if strXML <> '' then
    for Loop := 0 to FProcesses.Count - 1 do
    try
      ProcessObj := FProcesses.Items[Loop];
      if (ProcessObj.CurrentState = psLoading) or (ProcessObj.CurrentState = psWorking) then
        Send(ProcessObj, strXML);
    except
      Logger.Add('ProcessModule.Send_Notes failed', llBase);
    end;
end;

procedure TProcessModule.Send_PlayerLogoInfo(ProcessObj: TGameProcess; UserID: Integer;
  Path: String);
var
  RequestXMLDoc: TXMLDocument;
  XMLNode: IXMLNode;
begin
   try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      RequestXMLDoc.Active := false;
      RequestXMLDoc.XML.Text := '<getavatarlogo/>';
      RequestXMLDoc.Active := true;
      XMLNode := RequestXMLDoc.DocumentElement;
      XMLNode.Attributes['userid'] := inttostr(UserID);
      XMLNode.Attributes['path'] := Path;
      Send(ProcessObj, RequestXMLDoc.XML.Text);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Logger.Add('ProcessModule.GetAvatarLogo failed', llBase);
  end;
end;

procedure TProcessModule.Send_TournamentStart(ProcessObj: TGameProcess);
var
  RequestXMLDoc: TXMLDocument;
  XMLNode: IXMLNode;
begin
  if ProcessObj.TournamentStartDuration > 0 then
  begin
   try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      RequestXMLDoc.Active := false;
      RequestXMLDoc.XML.Text := '<tournamentstart/>';
      RequestXMLDoc.Active := true;
      XMLNode := RequestXMLDoc.DocumentElement;
      XMLNode.Attributes['duration'] := inttostr(ProcessObj.TournamentStartDuration);
      ProcessObj.TournamentStartDuration := 0;
      Send(ProcessObj, RequestXMLDoc.XML.Text);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Logger.Add('ProcessModule.TournamentStart failed', llBase);
  end;
 end;
end;

procedure TProcessModule.Send_BreakStart(ProcessObj: TGameProcess;
  Duration: Integer);
var
  RequestXMLDoc: TXMLDocument;
  XMLNode: IXMLNode;
begin
   try
    RequestXMLDoc := TXMLDocument.Create(Self);
    try
      RequestXMLDoc.Active := false;
      RequestXMLDoc.XML.Text := '<breakstart/>';
      RequestXMLDoc.Active := true;
      XMLNode := RequestXMLDoc.DocumentElement;
      XMLNode.Attributes['duration'] := inttostr(Duration);
      Send(ProcessObj, RequestXMLDoc.XML.Text);
    finally
      RequestXMLDoc.Active := false;
      RequestXMLDoc.Free;
    end;
  except
    Logger.Add('ProcessModule.TournamentStart failed', llBase);
  end;
end;

// All-Ins

procedure TProcessModule.Do_AllIns(ProcessObj: TGameProcess;
  XMLRoot: IXMLNode);
{
<allins action="reset|show"/>
}
var
  strActn: String;
begin
  strActn := XMLRoot.Attributes['action'];

  if strActn = 'show' then
    AllInsRemaining;

  if strActn = 'reset' then
    RequestAllInsReset;
end;

procedure TProcessModule.AllInsRemaining;
begin
  if UserModule.Logged then
  begin
    UserModule.OnActionLogin := nil;
    ThemeEngineModule.ShowMessage('You have ' + inttostr(UserModule.UserAllInsLeft) +
      ' All-In remaining right now.'#13#10#13#10 +
      'You get 1 All-In per 24 hour period.');
  end
  else
  begin
    UserModule.OnActionLogin := AllInsRemaining;
    UserModule.Login;
  end;
end;

procedure TProcessModule.RequestAllInsReset;
begin
  if UserModule.Logged then
  begin
    UserModule.OnActionLogin := nil;
    if UserModule.UserAllInsLeft > 0 then
      ThemeEngineModule.ShowMessage('You have ' + inttostr(UserModule.UserAllInsLeft) +
      ' All-In remaining right now.'#13#10#13#10 +
      'There is no need to have them reset.')
    else
      ParserModule.Send_ResetAllin;
  end
  else
  begin
    UserModule.OnActionLogin := RequestAllInsReset;
    UserModule.Login;
  end;
end;


// Hand History

procedure TProcessModule.Do_HandHistory(ProcessObj: TGameProcess;
  XMLRoot: IXMLNode);
{
<handhistory handid="21312"/>
}
begin
  RequestHandHistory(strtointdef(XMLRoot.Attributes['handid'], 0));
end;

procedure TProcessModule.RequestHandHistory;
begin
  if UserModule.Logged then
  begin
    UserModule.OnActionLogin := nil;
    RequestHandHistory(0);
  end
  else
  begin
    UserModule.OnActionLogin := RequestHandHistory;
    UserModule.Login;
  end;
end;

procedure TProcessModule.RequestHandHistory(HandID: Integer);
begin
  if UserModule.Logged then
  begin
    UserModule.OnActionLogin := nil;

    if Assigned(FOnRequestHandHistory) then
      FOnRequestHandHistory(HandID);
  end
  else
  begin
    UserModule.OnActionLogin := RequestHandHistory;
    UserModule.Login;
  end;
end;

procedure TProcessModule.Do_RequestHandHistory(HandID, LastHands,
  Direction: Integer);
begin
  ParserModule.Send_RequestHandHistory(HandID, LastHands, Direction);
end;

procedure TProcessModule.Run_RequestHandHistory(XMLRoot: IXMLNode);
{
<object name="process">
  <aprequesthandhistory result="0|..."/>
</object>
}
var
  ErrorCode: Integer;
begin
  try
    ErrorCode := -1;
    if ParserModule.GetResult(XMLRoot, ErrorCode, true) then
    begin
      if Assigned(FOnRequestHandHistorySent) then
        FOnRequestHandHistorySent;
    end
    else
      if Assigned(FOnRequestHandHistoryFailed) then
        FOnRequestHandHistoryFailed;
  except
    Logger.Add('ProcessModule.Run_RequestHandHistory failed', llBase);
  end;
end;


// Recorded Hands

procedure TProcessModule.Do_RecordHand(ProcessObj: TGameProcess; XMLRoot: IXMLNode);
{
<record handid="21312"/>
}
begin
  Do_NewHand(ProcessObj, XMLRoot);
  RecordedHands;
end;

procedure TProcessModule.RecordedHands;
begin
  if UserModule.Logged then
  begin
    UserModule.OnActionLogin := nil;
    if Assigned(FOnRecordedHandsShow) then
      FOnRecordedHandsShow;
  end
  else
  begin
    UserModule.OnActionLogin := RecordedHands;
    UserModule.Login;
  end;
end;

procedure TProcessModule.Run_GetRecordedHands(XMLRoot: IXMLNode);
{
<object name="process">
  <apgetrecordedhands result="0">
    <hand order="1" handid="12" comment="I won all players!!!"/>
    <hand order="2" handid="13" comment="I won all players!!!"/>
    <hand order="3" handid="14" comment="I won all players!!!"/>
    <hand order="4" handid="15" comment="I won all players!!!"/>
    <hand order="5" handid="16" comment="I won all players!!!"/>
  </apgetrecordedhands>
</object>
}
var
  ItemsCount: Integer;
  ErrorCode: Integer;

  Loop: Integer;
  XMLNode: IXMLNode;
  curData: TDataList;
begin
  try
    ErrorCode := -1;
    if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
    begin
      FRecordedHandReceived := true;
      ItemsCount := XMLRoot.ChildNodes.Count;
      for Loop := 0 to ItemsCount - 1 do
      begin
        XMLNode := XMLRoot.ChildNodes.Nodes[Loop];
        if FRecordedHands.Find(strtointdef(XMLNode.Attributes['order'], 0), curData) then
          curData.LoadFromXML(XMLNode);
      end;
      if Assigned(FOnRecordedHandsUpdate) then
        FOnRecordedHandsUpdate;
    end;
  except
    Logger.Add('ProcessModule.Run_GetRecordedHands failed', llBase);
  end;
end;

procedure TProcessModule.Do_RecordedHandsSave;
begin
  ParserModule.Send_SaveRecordedHands(FRecordedHands);
end;

procedure TProcessModule.Run_SaveRecordedHands(XMLRoot: IXMLNode);
{
<object name="process">
  <apsaverecordedhands result="0|..."/>
</object>
}
var
  ErrorCode: Integer;
begin
  try
    ErrorCode := -1;
    if ParserModule.GetResult(XMLRoot, ErrorCode, true) then
    begin
      if Assigned(FOnRequestHandHistorySent) then
        FOnRecordHandsSaved;
    end
    else
      if Assigned(FOnRequestHandHistoryFailed) then
        FOnRecordHandsSaveFailed;
  except
    Logger.Add('ProcessModule.Run_SaveRecordedHands failed', llBase);
  end;
end;

procedure TProcessModule.Do_RecordHandSave(SlotNo, HandID: Integer; Comment: String);
begin
  ParserModule.Send_CheckHandID(HandID, SlotNo, Comment);
end;

procedure TProcessModule.Run_CheckHandID(XMLRoot: IXMLNode);
{
<object name="process">
  <apcheckhandid result="0|..." handid="123" order="1" comment="Holdem 3/6"/>
</object>
}
var
  ErrorCode: Integer;
  curData: TDataList;
begin
  try
    ErrorCode := -1;
    if ParserModule.GetResult(XMLRoot, ErrorCode, true) then
    begin
      if FRecordedHands.Find(XMLRoot.Attributes['order'], curData) then
      begin
        curData.ValuesAsInteger['handid'] := strtointdef(XMLRoot.Attributes['handid'], 0);
        curData.ValuesAsString['comment'] := XMLRoot.Attributes['comment'];
      end;

      Do_RecordedHandsSave;
      if Assigned(FOnRecordedHandsUpdate) then
        FOnRecordedHandsUpdate;
    end
    else
      if Assigned(FOnRequestHandHistoryFailed) then
        FOnRecordHandsSaveFailed;
  except
    Logger.Add('ProcessModule.Run_CheckHandID failed', llBase);
  end;
end;

procedure TProcessModule.Do_RecordHandClear(SlotNo: Integer);
var
  curData: TDataList;
begin
  if FRecordedHands.Find(SlotNo, curData) then
    if ThemeEngineModule.AskQuestion(cstrRecordHandErase) then
    begin
      curData.ValuesAsInteger['handid'] := 0;
      curData.ValuesAsString['comment'] := '';
      curData.ValuesAsInteger['processid'] := 0;
      curData.ValuesAsString['InitXML'] := '';

      Do_RecordedHandsSave;
      if Assigned(FOnRecordedHandsUpdate) then
        FOnRecordedHandsUpdate;
    end;
end;

procedure TProcessModule.Do_RecordHandPlay(SlotNo: Integer);
var
  curData: TDataList;
  curXML: String;
  ProcessID: Integer;
  HandID: Integer;
begin
  if FRecordedHands.Find(SlotNo, curData) then
  begin
    ProcessID := curData.ValuesAsInteger['processid'];
    HandID := curData.ValuesAsInteger['handid'];
    curXML := curData.ValuesAsString['InitXML'];
    if HandID > 0 then
      if (ProcessID = 0) or (curXML = '') then
        ParserModule.Send_LoadRecordedHand(HandID)
      else
        StartRecordedHand(ProcessID, HandID, 'Recorded hand #' + inttostr(HandID),
          curData.ValuesAsString['comment'], curXML);
  end;
end;

procedure TProcessModule.Run_LoadRecordedHand(XMLRoot: IXMLNode);
{
<object name="process">
  <apgetrecordedhandhistory result="0|..." processid="1234" handid="123">
   <...>
  </apgetrecordedhandhistory>
</object>
}
var
    Loop: Integer;
  ErrorCode: Integer;
  HandID: Integer;
  curData: TDataList;
  Played: Boolean;

  procedure FillHandItem;
  var
    Loop: Integer;
    curXML: String;
  begin
    curXML := '';
    for Loop := 0 to XMLRoot.ChildNodes.Count - 1 do
      curXML := curXML + XMLRoot.ChildNodes.Nodes[Loop].XML;
    curData.ValuesAsString['InitXML'] := curXML;
    curData.ValuesAsInteger['processid'] := XMLRoot.Attributes['processid'];
  end;

begin
  try
    ErrorCode := -1;
    Played := False;
    if ParserModule.GetResult(XMLRoot, ErrorCode, True) then
    begin
      HandID := strtointdef(XMLRoot.Attributes['handid'], 0);
      // Selected hands
      for Loop := 0 to FRecordedHands.Count - 1 do
      begin
        curData := FRecordedHands.Items(Loop);
        if curData.ValuesAsInteger['handid'] = HandID then
        begin
          FillHandItem;
          if not Played then
          begin
            Do_RecordHandPlay(curData.ID);
            Played := True;
          end;
        end;
      end;

      // Previous hands
      if FPreviousHands.Find(HandID, curData) then
      begin
        FillHandItem;
        if not Played then
          Do_PreviousHandPlay(curData.ID);
      end;
    end;
  except
    Logger.Add('ProcessModule.Run_LoadRecordedHand failed', llBase);
  end;
end;


// Waiting List

procedure TProcessModule.WaitingList;
begin
  if UserModule.Logged then
  begin
    UserModule.OnActionLogin := nil;
    WaitingList(LobbyModule.CurrentProcessID);
  end
  else
  begin
    UserModule.OnActionLogin := WaitingList;
    UserModule.Login;
  end;
end;

procedure TProcessModule.Do_WaitingList(ProcessObj: TGameProcess;
  XMLRoot: IXMLNode);
{
<waitinglist/>
}
begin
  WaitingList(ProcessObj.ProcessID);
end;

procedure TProcessModule.WaitingList(ProcessID: Integer);
begin
  if UserModule.Logged then
    ParserModule.Send_GetWaitingListInfo(ProcessID)
  else
  begin
    UserModule.OnActionLogin := WaitingList;
    UserModule.Login;
  end;
end;

procedure TProcessModule.Run_GetWaitingListInfo(XMLRoot: IXMLNode);
{
<object name="process">
  <apgetwaitinglistinfo result="0|..." state="0|1|2"
   processid="123" processname="Jamaika" waitingplayerscount="3"
   groupid="12"/>
</object>
}
var
  ErrorCode: Integer;
  curState: Integer;
  ProcessID: Integer;
  GroupID: Integer;
  PlayersCount: Integer;
  ProcessName: String;
begin
 try
    ErrorCode := -1;
    if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
    begin
      curState := strtointdef(XMLRoot.Attributes['state'], 0);
      ProcessID := strtointdef(XMLRoot.Attributes['processid'], 0);
      GroupID := strtointdef(XMLRoot.Attributes['groupid'], 0);
      PlayersCount := strtointdef(XMLRoot.Attributes['waitingplayerscount'], 0);
      ProcessName := XMLRoot.Attributes['processname'];

      if curState = 0 then
      begin
        if Assigned(FOnWaitingList) then
          FOnWaitingList(ProcessID, GroupID, PlayersCount, ProcessName);
      end
      else
        if curState = 1 then
        begin
          if ThemeEngineModule.AskQuestion(cstrWaitingListUnregisterTable +
            '"' + ProcessName + '"?') then
            ParserModule.Send_UnregisterWaitingList(ProcessID, 0)
        end
        else
          if curState = 2 then
            if ThemeEngineModule.AskQuestion(cstrWaitingListUnregisterGroup) then
              ParserModule.Send_UnregisterWaitingList(0, GroupID)
    end
    else
      ThemeEngineModule.ShowWarning(cstrWaitingListIsFull);
  except
    Logger.Add('LobbyModule.Run_GetWaitingListInfo failed', llBase);
  end;
end;


// Register/Unregister

procedure TProcessModule.Do_RegisterWaitingList(ProcessID, GroupID, PlayersCount: Integer);
begin
  ParserModule.Send_RegisterWaitingList(ProcessID, GroupID, PlayersCount);
end;

procedure TProcessModule.Run_RegisterWaitingList(XMLRoot: IXMLNode);
{
<object name="process">
  <apregisteratwaitinglist result="0|..."
   processid="" groupid=""/>
</object>
}
var
  ErrorCode: Integer;
  ProcessID: INteger;
  curProcess: TGameProcess;
begin
  try
    ErrorCode := -1;
    if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
    begin
      ProcessID := strtointdef(XMLRoot.Attributes['processid'], 0);
      curProcess := FindProcess(ProcessID, 0);
      FWaitingListProcesses.Add(ProcessID);
      if curProcess <> nil then
        SendWaitingListStatusXML(curProcess);
    end
  except
    Logger.Add('LobbyModule.Run_RegisterWaitingList failed', llBase);
  end;
end;

procedure TProcessModule.Run_UnregisterWaitingList(XMLRoot: IXMLNode);
{
<object name="process">
  <apunregisterfromwaitinglist result="0|..."
   processid="" groupid=""/>
</object>
}
var
  ErrorCode: Integer;
  ProcessID: INteger;
  curProcess: TGameProcess;
begin
  try
    ErrorCode := -1;
    if ParserModule.GetResult(XMLRoot, ErrorCode, false) then
    begin
      ProcessID := strtointdef(XMLRoot.Attributes['processid'], 0);
      CloseWaitingList(ProcessID);
      curProcess := FindProcess(ProcessID, 0);
      if curProcess <> nil then
        SendWaitingListStatusXML(curProcess);
    end
  except
    Logger.Add('LobbyModule.Run_UnregisterWaitingList failed', llBase);
  end;
end;


// Waiting list status

procedure TProcessModule.Do_WaitingListStatus(ProcessObj: TGameProcess;
  XMLRoot: IXMLNode);
{
<waitingliststatus/>
}
begin
  SendWaitingListStatusXML(ProcessObj);
end;

procedure TProcessModule.SendWaitingListStatusXML(ProcessObj: TGameProcess);
{
<waitingliststatus value="0|1" sitallowed="0|1"/>
}
var
  curData: TDataList;
  strIsWaiting: Char;
  strSitAllowed: Char;
begin
  strIsWaiting := '0';
  if FWaitingListProcesses.Find(ProcessObj.ProcessID, curData) then
    strIsWaiting := '1';
  strSitAllowed := '0';
  if ProcessObj.ProcessID = FCurrentTakePlaceProcessID then
    strSitAllowed := '1';
  Send(ProcessObj, '<waitingliststatus value="' + strIsWaiting + '" ' +
    'sitallowed="' + strSitAllowed + '"/>')
end;


// Take place

procedure TProcessModule.Run_TakePlaceWaitingList(XMLRoot: IXMLNode);
{
<object name="process">
  <wltakeplace processid="1213" timeout="200" playerscount="7"
   processname="Holdem 'Green Beach' table 3/6"/>
</object>
}
var
  ProcessID: Integer;
  TimerSecs: Integer;
  ProcessText: String;
  curProcess: TGameProcess;
begin
  try
    ProcessID := StrToIntDef(XMLRoot.Attributes['processid'], 0);
    TimerSecs := StrToIntDef(XMLRoot.Attributes['timeout'], 0);
    ProcessText := XMLRoot.Attributes['processname'] +
      ' Number of players: ' + XMLRoot.Attributes['playerscount'];
    FCurrentTakePlaceProcessID := ProcessID;
    WaitingListTimeOutTimer.Interval := 1000 * TimerSecs;
    WaitingListTimeOutTimer.Enabled := true;
    curProcess := FindProcess(ProcessID, 0);
    FWaitingListProcesses.Add(ProcessID);
    if curProcess <> nil then
      SendWaitingListStatusXML(curProcess);
    if Assigned(FOnWaitingListConfirm) then
      FOnWaitingListConfirm(ProcessText, TimerSecs);
  except
    Logger.Add('LobbyModule.Run_TakePlaceWaitingList failed', llBase);
  end;
end;

procedure TProcessModule.Run_CancelWaitingList(XMLRoot: IXMLNode);
{
<object name="process">
  <wlcancel processid="1213"/>
</object>
}
begin
  WaitingListTimeOutTimer.Enabled := false;
  if XMLRoot.HasAttribute('processid') then
    CloseWaitingList(StrToIntDef(XMLRoot.Attributes['processid'], 0));
end;

procedure TProcessModule.Do_SitDown(ProcessObj: TGameProcess;
  XMLRoot: IXMLNode);
{
<sitdown/>
}
begin
  CloseWaitingList(ProcessObj.ProcessID);
  SendWaitingListStatusXML(ProcessObj);
end;

procedure TProcessModule.CloseWaitingList(ProcessID: Integer);
var
  curProcess: TGameProcess;
begin
  WaitingListTimeOutTimer.Enabled := false;
  FWaitingListProcesses.Remove(ProcessID);
  if Assigned(FOnWaitingListClose) then
    FOnWaitingListClose;
  FCurrentTakePlaceProcessID := 0;
  curProcess := FindProcess(ProcessID, 0);
  if curProcess <> nil then
    SendWaitingListStatusXML(curProcess);
end;

procedure TProcessModule.Do_TakePlace;
var
  curProcess: TGameProcess;
begin
  if Assigned(FOnWaitingListHide) then
    FOnWaitingListHide;
  curProcess := FindProcess(FCurrentTakePlaceProcessID, 0);
  FWaitingListProcesses.Add(FCurrentTakePlaceProcessID);
  if curProcess <> nil then
    SendWaitingListStatusXML(curProcess);
  StartTable(FCurrentTakePlaceProcessID, 0, '', '');
end;

procedure TProcessModule.Do_Unjoin;
begin
  ParserModule.Send_DeclineWaitingList(FCurrentTakePlaceProcessID, 'unjoin');
  CloseWaitingList(FCurrentTakePlaceProcessID);
end;

procedure TProcessModule.Do_BreakStart(ProcessID, Duration: Integer);
var
  ProcessObj: TGameProcess;
begin
  ProcessObj := FindProcess(ProcessID);
 if ProcessObj <> nil then
  Send_BreakStart(ProcessObj,Duration);
end;


procedure TProcessModule.WaitingListTimeOutTimerTimer(Sender: TObject);
begin
  ParserModule.Send_DeclineWaitingList(FCurrentTakePlaceProcessID, 'timeout');
  CloseWaitingList(FCurrentTakePlaceProcessID);
end;


// Form active state

procedure TProcessModule.Do_WindowState(ProcessObj: TGameProcess;
  XMLRoot: IXMLNode);
{
<windowstate active="1"/>
}
begin
  if ProcessObj.CurrentState = psWorking then
    ProcessObj.ProcessForm.Start;
end;

procedure TProcessModule.UpdateActiveStates(IsActive: Boolean);
var
  Loop: Integer;
  ProcessObj: TGameProcess;
  strXML: String;
begin
  for Loop := 0 to FProcesses.Count - 1 do
  try
    ProcessObj := FProcesses.Items[Loop];
    if ProcessObj <> nil then
      if ProcessObj.CurrentState = psWorking then
      begin
        strXML := '<windowstate active="0"/>';
        if IsActive and ProcessObj.ProcessForm.Active then
          strXML := '<windowstate active="1"/>';
        Send(ProcessObj, strXML);
      end;
  except
    Logger.Add('ProcessModule.UpdateOptions failed', llBase);
  end;
end;

procedure TProcessModule.UpdateActiveState(ProcessObj: TGameProcess;
  IsActive: Boolean);
var
  strActive: Char;
begin
  strActive := '0';
  if IsActive then
    strActive := '1';

  if ProcessObj.CurrentState = psWorking then
    Send(ProcessObj, '<windowstate active="' + strActive + '"/>');
end;

procedure TProcessModule.UpdateChatState;
var
  Loop: Integer;
  ProcessObj: TGameProcess;
  strXML: String;
begin
  strXML := GetChatStateXML;
  if strXML <> '' then
    for Loop := 0 to FProcesses.Count - 1 do
    try
      ProcessObj := FProcesses.Items[Loop];
      if (ProcessObj.CurrentState = psLoading) or (ProcessObj.CurrentState = psWorking) then
        Send(ProcessObj, strXML);
    except
      Logger.Add('ProcessModule.UpdateChatState failed', llBase);
    end;
end;

function TProcessModule.GetChatStateXML: String;
var
  csValue: String;
begin
  if UserModule.UserChatAllow then
    csValue := '1'
  else
    csValue := '0';

  Result := '<chatstate allow="' + csValue + '"/>'
end;

procedure TProcessModule.UpdateProcessCaption(curProcess: TGameProcess);
begin
  curProcess.ProcessForm.Caption := GetProcessCaption(curProcess) + UserModule.GetUserSessionInfo;
  //curProcess.ProcessForm.TeForm.Caption := curProcess.ProcessForm.Caption;
  curProcess.ProcessForm.ShockwaveFlash.Invalidate;
end;

procedure TProcessModule.Do_PreviousHandPlay(HandID: Integer);
var
  curData: TDataList;
  curXML: String;
  ProcessID: Integer;
begin
  if FPreviousHands.Find(HandID, curData) then
  begin
    ProcessID := curData.ValuesAsInteger['processid'];
    curXML := curData.ValuesAsString['InitXML'];
    if (ProcessID = 0) or (curXML = '') then
      ParserModule.Send_LoadRecordedHand(HandID)
    else
      StartRecordedHand(ProcessID, HandID, ' - Recorded hand #' + inttostr(HandID),
        curData.Value + ' ' + curData.Name, curXML);
  end;
end;

function TProcessModule.GetLoadingProcessCaption(ProcessObj: TGameProcess): String;
begin
  Result := GetProcessCaption(ProcessObj) + ' is loading...'
end;

procedure TProcessModule.Do_GetPlayerLogo(ProcessObj: TGameProcess;XMLRoot: IXMLNode);
var
  UserID: Integer;
  Version: Integer;
begin
  UserID := XMLRoot.Attributes['userid'];
  Version := XMLRoot.Attributes['version'];
  ProcessObj.DownloadSessionID := FileManagerModule.DownloadPlayerLogoFiles(UserID, Version, OnPlayerLogoFileDownloaded);
  if ProcessObj.DownloadSessionID = -1 then
   Send_PlayerLogoInfo(ProcessObj,UserID,FileManagerModule.FilesPath + IntToStr(UserId) + '.jpg');
end;

procedure TProcessModule.Do_AutoRebuy(ProcessObj: TGameProcess;
  XMLRoot: IXMLNode);
begin
 TournamentModule.Do_AutoRebuy(ProcessObj.TournamentID,XMLRoot.Attributes['value']);
end;

procedure TProcessModule.Do_ViewLobby(ProcessObj: TGameProcess);
begin
  if ProcessObj.TournamentID > 0 then
    TournamentModule.StartTournament(ProcessObj.TournamentID,ProcessObj.ProcessName)
  else
  LobbyModule.StartWork;
end;


end.
