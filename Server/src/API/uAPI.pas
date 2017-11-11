unit uAPI;

interface

uses
  xmldom, XMLIntf, msxmldom, XMLDoc, SYsUtils, Classes, Contnrs, SyncObjs,
  uInfoCash, uAPIActions, uXMLActions, uSQLAdapter, uSQLTools;

type

  TAPI = class
  private
    FRequest: TapiActions;
    FResponse: TapiRespActions;

    function GetResponseXMLOnError(NodeName: string; ErrorCode: Integer): string;
    function AddChildNodesFromXMLChildNodes(XMLData : string          // source
      ; TargetNode : IXMLNode     // target
      ; var ExceptionMessage : string
    ): boolean;

    procedure ProcessGetCategories(Action: TapiAction);
    procedure ProcessGetSummary(Action: TapiAction);
    procedure ProcessGetProcesses(Action: TapiAction);
    procedure ProcessGetProcessInfo(Action: TapiAction);
    procedure ProcessGetCurrencies(Action: TapiAction);
    procedure ProcessGetStats(Action: TapiAction);
    procedure ProcessGetCountries(Action: TapiAction);
    procedure ProcessGetStates(Action: TapiAction);
    procedure ProcessRegisterAtWaitingList(Action: TapiAction);
    procedure ProcessUnregisterFromWaitingList(Action: TapiAction);
    procedure ProcessGetNotes(Action: TapiAction);
    procedure ProcessSaveNotes(Action: TapiAction);
    procedure ProcessCloneProcess(Action: TapiAction);
    procedure ProcessGetRecordedHandHistory(Action: TapiAction);
    procedure ProcessGetRecordedHands(Action: TapiAction);
    procedure ProcessSaveRecordedHands(Action: TapiAction);
    procedure ProcessRequestHandHistory(Action: TapiAction);
    procedure ProcessCheckHandId(Action: TapiAction);
    procedure ProcessCustomSupport(Action: TapiAction);
    procedure ProcessGetWaitingListInfo(Action: TapiAction);
    procedure ProcessDisconnect(Action: TapiAction);
    procedure ForEachProcess(Action: TapiAction);
    procedure ProcessReconnect(Action: TapiAction);
    procedure ProcessSetParticipantAsLogged(Action: TapiAction);
    procedure ProcessChatAllowChanged(Action: TapiAction);
    procedure ProcessKickOff(Action: TapiAction);
    procedure ProcessLeaveTable(Action: TapiAction);
    procedure ProcessResetAllIn(Action: TapiAction);
    procedure ProcessGetLeaderBoard(Action: TapiAction);
    procedure ProcessSaveHandHistoryCasino(Action: TapiAction);
//    procedure ProcessSparkleCheats(Action: TapiAction);
    // tournament processes
    procedure GetTournamentInfo(TournamentID, TournamentCategoryID, InfoID: Integer; var Data: string);
    procedure GetTournamentLeaderBoardInfo(sType: string; var sData: string);
    function GetLeaderPointsToSend(UserID: Integer; FromTime, ToTime: string): Currency;
    procedure GetUserIcons(UserID: Integer; FSql: TSQLAdapter;
      var Icon1, Icon2, Icon3, Icon4: string);
    procedure TouProcessGetInfo(Action: TapiAction);
    procedure TouProcessGetPlayers(Action: TapiAction);
    procedure TouProcessGetProcesses(Action: TapiAction);
    procedure TouProcessGetTournamentInfo(Action: TapiAction);
    procedure TouProcessGetTournaments(Action: TapiAction);
    procedure TouProcessGetLeaderBoard(Action: TapiAction);
    procedure TouProcessGetLeaderPoints(Action: TapiAction);
    procedure TouProcessGetLevelsInfo(Action: TapiAction);
    //
    function GetPushingContentFilesSQL(nType, ProcessID, UserID: Integer; var Data: string): Integer;

    //
    function ReadableXML( source : string ):string;  overload;
    function ReadableXML( source : IXMLNode ):string; overload;

  public
    StateNum : string;
    property Request: TapiActions read FRequest;
    property Response: TapiRespActions read FResponse;
    //
    function ProcessAction(ActionsNode: IXMLNode): Integer; overload;
    function ProcessAction(ActionsText: string): Integer; overload;

    function GetState(ProcessID: Integer; StateNumber: Integer; var Data: String): Integer;
    function CreateState(ProcessID: Integer; StateNumber: Integer; var StateID: Integer): Integer;
    function SetState(ProcessID: Integer; StateNumber: Integer; const Data: String): Integer;
    function SetStateID(StateID: Integer; var Data: String): Integer;
    function GetStats(ProcessID: Integer; StatsTypeID: Integer; var Value: String): Integer;
    function CreateStats(ProcessID: Integer; StatsTypeID: Integer; Value: String): Integer;
    function SetStats(ProcessID: Integer; StatsTypeID: Integer; Value: String): Integer;
    function SetStatses(ProcessID: Integer; Value: String): Integer;
    function SetGameType(ProcessID: Integer; GameTypeID, ChairsCount: Integer): Integer;
    function RegisterParticipant(ProcessID: Integer; theSessionID: Integer; theUserId: Integer;
      placeNumber: Integer): Integer;
    function UnRegisterParticipant(ProcessID: Integer; theSessionID: Integer;
      theUserId: Integer; placeNumber: Integer): Integer;
    function SetParticipantCount(ProcessID: Integer; ActiveUsersCount: Integer;
      PassiveUsersCount: Integer): Integer;
    function SendRemindAction(ActionName: string; ProcessId: integer; theSessionId: integer; execTime: TDateTime; RemindId: string; Data: string):boolean;
    function CreateRemind(theSessionID: Integer; ProcessID: Integer; RemindTime: TDateTime;
      Data: String; var RemindID: String): Integer;
    function ChangeRemind(theSessionID: Integer; ProcessID: Integer; RemindTime: TDateTime;
      Data: String; RemindID: String): Integer;
    function RemoveRemind(RemindID: String): Integer;
    function ResetRemind(RemindTime: TDateTime; RemindID: String): Integer;
    function BeginTransaction: Integer;
    function CommitTransaction: Integer;
    function RollBackTransaction: Integer;
    function GetProcessInfo(ProcessID: Integer;
      var EngineID: Integer; var GroupID: Integer;
      var ProcessName, Password: String;
      var IsWatchingAllowed: Integer;
      var CurrencyTypeID: Integer;
      var ProtectedMode: Integer;
      var IsHighlighted: Integer
    ): Integer;
    function GetCurrency(CurrencyTypeID: Integer; var CurrencyName: String;
      var CurrencySymbol: String): Integer;
    function GetWaitersCount(ProcessID: Integer; var WaitersCount: Integer): Integer;
    function GetParticipantInfo(theSessionID: Integer; var UserID: Integer;
      var UserName: String; var City: String; var SexID: Integer;
      var AvatarID: Integer; var ImageVersion: Integer; var IP: String; var ChatAllow: Boolean;
      var AffiliateID: Integer; var IsEmailValidated: Boolean;
      var LevelID: Integer; var Icon1, Icon2, Icon3, Icon4: string): Integer;
    function GetUserInfo(UserID: Integer; var UserName: String; var City: String;
      var SexID: Integer; var AvatarID: Integer; var ImageVersion: Integer; var SessionID: Integer;
      var ChatAllow: Boolean; var AffiliateID: Integer; var IsEmailValidated: Boolean;
      var LevelID: Integer; var Icon1, Icon2, Icon3, Icon4: string): Integer;
    function GetUserSession(UserID: Integer; var theSessionID: Integer): Integer;
    function GetUserBalance(SessionID: Integer; UserID: Integer; CurrencyTypeID: Integer;
      var Amount: Currency): Integer;
    function GetReservedAmount(SessionID, GameProcessID, UserID: Integer; var Amount: Currency): Integer;
    function ReserveMoney(SessionID: Integer; ProcessID: Integer; UserID: Integer;
      Amount: Currency; var NewReserve: Currency; var NewAmount: Currency): Integer;
    function UnReserveMoney(SessionID: Integer; ProcessID: Integer; UserID: Integer;
      CurrencyID: Integer; Amount: Currency; var NewAmount: Currency;
      var NewReserve: Currency): Integer;
    function HandResult(ProcessID: Integer; HandID: Integer; var Comment: String;
      var Data: String): Integer;
    function HandResultUserRakes(HandID: Integer; var Data: String): Integer;
    function TournamentPrize(ProcessID: Integer; var Data: String): Integer;
    function ReserveForTournament(ProcessID: Integer; var Data: String): Integer;
    function UnReserveForTournament(ProcessID: Integer; var Data: String): Integer;
    function FinishHand(HandID: Integer): Integer;
    function StartHand(ProcessID: Integer; RandomFactor: String; var HandID: Integer): Integer;
    function CreateActionLogOnFinishHand(HandID: Integer; Data: String): Integer;
    function GetHandHistory(HandID: Integer; var Duration: Integer;
      var StartDate, EndDate: TDateTime; var Data: String): Integer;
    function GetPersonalHandHistory(UserID: Integer; HandID: Integer;
      RemoveOtherRanking: Integer; var Data: String): Integer;
    function GetPersonalHandHistoryAsText(UserID: Integer; HandID: Integer;
      var Data: String): Integer;
    function GetGameRakeRules(RakeRulesTypeID: Integer; var Data: String): Integer;
    function LogActivity(ProcessID: Integer; SwitchHand: Integer; HandID: Integer;
      theSessionID: Integer; UserID: Integer; ActivityXML: String;
      BehaviourXML: String): Integer;
    function CloneProcess(ProcessSourceID: Integer; var ProcessTargetID: Integer): Integer;
    function InitProcess(ProcessID: Integer): Integer;
    function RegisterAtWaitingList(UserID: Integer; ProcessID: Integer; GroupID: Integer;
      PlayersCount: Integer; var ParticipantCount: Integer): Integer;
    function GetNextFromWaitingListAndLock(ProcessID: Integer; GroupID: Integer;
      PlayersCount: Integer; var UserID, SessionID, ParticipantCount: Integer): Integer;
    function ReturnToWaitingListAndUnlock(UserID: Integer; ProcessID: Integer;
      GroupID: Integer; var ParticipantCount: Integer): Integer;
    function UnregisterFromWaitingList(UserID: Integer; ProcessID: Integer; GroupID: Integer;
      var ParticipantCount: Integer): Integer;
    function CreateTournamentRemind(tournamentId: Integer; execTime: TDateTime;
      Data: String): Integer;
    function CanUserMakeAllIn(UserID: Integer; var UserCan: Integer): Integer;
    function UserMakeAllIn(UserID: Integer): Integer;
    function SetStateNumber(StateNumber: String): Integer;

    function GetSummaryXMLString(FSQL: TSQLAdapter): String;
    function GetProcessesXMLString(SubCategoryID, TypeId, SessionID: Integer; FSql: TSQLAdapter): String;
    function GetProcessesInfoXMLString(FSql: TSQLAdapter): String;

    function NotifyUser(SessionID: Integer; const Data: String; SendDirectly: Boolean): Integer;
    function NotifyUserByID(UserID: Integer; const Data: String): Integer;
    function NotifyUsers(SessionIDs: array of Integer; const Data: String): Integer;
    function NotifyUsersByID(UserIDs: array of Integer; const Data: String): Integer;
    function NotifyAllUsers(const Data: String): Integer;

    function GetSystemOption(OptionID: Integer; var Data: String): Integer;
    function CheckOnAccessByInvitedUsers(ProcessID, IsTournament, UserID: Integer; var IsAllowed: Integer): Integer;
    function GetPushingContentFiles(nType, ProcessID, UserID: Integer; var Data: string): Integer;

    //Bots
    function GetBotsDataXMLString: string;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses Variants, ActiveX, DateUtils
//PO
  , uCommonFunctions
  , uCommonDataModule
  , uLogger
  , uXMLConstants
  , uErrorConstants
  , uObjectPool
  , uSessionUtils
  , uEMail
  , uAccount
  , uGameConnector
  , uUser
  , StrUtils, DB, uLocker;

{ TAPI }

constructor TAPI.Create;
begin
  inherited;
  FRequest := TapiActions.Create(True);
  FResponse := TapiRespActions.Create(True);
end;

destructor TAPI.Destroy;
begin

  FRequest.Clear;
  FRequest.Free;

  FResponse.Clear;
  FResponse.Free;

  inherited;
end;



// TAPI - client request processing handler

function TAPI.ProcessAction(ActionsNode: IXMLNode): Integer;
var
  i : integer;
  aAction: TapiAction;
begin

  // verify
  if ActionsNode = nil  then begin
    CommonDataModule.Log(ClassName, 'ProcessAction',
      '[ERROR] ActionsNode is nil',
      ltError
    );

    Result := AP_ERR_CORRUPTREQUESTXML;
    Exit;
  end;
  if not ActionsNode.HasChildNodes then begin
    CommonDataModule.Log(ClassName, 'ProcessAction',
      '[ERROR] ActionsNode has not child nodes; Params: ActionsNode=' + ActionsNode.XML,
      ltError
    );

    Result := AP_ERR_CORRUPTREQUESTXML;
    Exit;
  end;

  //free resources
  Request.Clear;

  for I:=0 to ActionsNode.ChildNodes.Count - 1 do begin
    Request.Add.ActionNode := ActionsNode.ChildNodes[I];
  end;

  //....................................................................................
  // Process XML data for each action in action packet
  // Response notification will send by one for action and added to the Response object
  // Action Packet Processing
  //....................................................................................

  for i := 0 to Request.Count-1 do begin // for each action in the packet
    aAction := Request.Item[i];
    // case by action name and executing specific method for each action

    if aAction.Name = AP_GETPROCESSES then begin
      ProcessGetProcesses(aAction);
      continue;
    end;

    if aAction.Name = AP_GETPROCESSINFO then begin
      ProcessGetProcessInfo(aAction);
      continue;
    end;

    if (aAction.Name = AP_GETSUMMARY) or (aAction.Name = AP_UPDATESUMMARY) then begin
      ProcessGetSummary(aAction);
      continue;
    end;

    if aAction.Name = AP_GETCATEGORIES then begin
      ProcessGetCategories(aAction);
      continue;
    end;

    if aAction.Name = AP_GETCURRENCIES then begin
      ProcessGetCurrencies(aAction);
      continue;
    end;

    if aAction.Name = AP_GETSTATS then begin
      ProcessGetStats(aAction);
      continue;
    end;

    if aAction.Name = AP_GETCOUNTRIES then begin
      ProcessGetCountries(aAction);
      continue;
    end;

    if aAction.Name = AP_GETSTATES then begin
      ProcessGetStates(aAction);
      continue;
    end;

    if aAction.Name = AP_DISCONNECT then begin
      ProcessDisconnect(aAction);
      continue;
    end;

    if aAction.Name = AP_RECONNECT then begin
      ProcessReconnect(aAction);
      continue;
    end;

    if aAction.Name = AP_SETPARTICIPANTASLOGGED then begin
      ProcessSetParticipantAsLogged(aAction);
      continue;
    end;

    if aAction.Name = AP_GETWAITINGLISTINFO then begin
      ProcessGetWaitingListInfo(aAction);
      continue;
    end;

    if aAction.Name = AP_REGISTERATWAITINGLIST then begin
      ProcessRegisterAtWaitingList(aAction);
      continue;
    end;

    if aAction.Name = AP_UNREGISTERFROMWAITINGLIST then begin
      ProcessUnregisterFromWaitingList(aAction);
      continue;
    end;

    if aAction.Name = AP_GETNOTES then begin
      ProcessGetNotes(aAction);
      continue;
    end;

    if aAction.Name = AP_SAVENOTES then begin
      ProcessSaveNotes(aAction);
      continue;
    end;

    if aAction.Name = AP_CLONEPROCESS then begin
      ProcessCloneProcess(aAction);
      continue;
    end;

    if aAction.Name = AP_GETRECORDEDHANDHISTORY then begin
      ProcessGetRecordedHandHistory(aAction);
      continue;
    end;

    if aAction.Name = AP_GETRECORDEDHANDS then begin
      ProcessGetRecordedHands(aAction);
      continue;
    end;

    if aAction.Name = AP_SAVERECORDEDHANDS then begin
      ProcessSaveRecordedHands(aAction);
      continue;
    end;

    if aAction.Name = AP_REQUESTHANDHISTORY then begin
      ProcessRequestHandHistory(aAction);
      continue;
    end;

    if aAction.Name = AP_CHECKHANDID then begin
      ProcessCheckHandId(aAction);
      continue;
    end;

    if aAction.Name = AP_CUSTOMSUPPORT then begin
      ProcessCustomSupport(aAction);
      continue;
    end;

    if aAction.Name = AP_CHATALLOW then begin
      ProcessChatAllowChanged(aAction);
      continue;
    end;

    if aAction.Name = AP_KICKOFUSER then begin
      ProcessKickOff(aAction);
      continue;
    end;

    if aAction.Name = AP_LEAVETABLE then begin
      ProcessLeaveTable(aAction);
      continue;
    end;

    if aAction.Name = AP_RESETALLIN then begin
      ProcessResetAllIn(aAction);
      continue;
    end;

    if aAction.Name = AP_GETLEADERBOARD then begin
      ProcessGetLeaderBoard(aAction);
      continue;
    end;

    if aAction.Name = AP_SAVEHANDHISTORY then begin
      ProcessSaveHandHistoryCasino(aAction);
      continue;
    end;

    if aAction.Name = TO_GET_INFO then begin
      TouProcessGetInfo(aAction);
      continue;
    end;

    if aAction.Name = TO_GET_PLAYERS then begin
      TouProcessGetPlayers(aAction);
      continue;
    end;

    if aAction.Name = TO_GET_PROCESSES then begin
      TouProcessGetProcesses(aAction);
      continue;
    end;

    if aAction.Name = TO_GET_TOURNAMENT_INFO then begin
      TouProcessGetTournamentInfo(aAction);
      continue;
    end;

    if aAction.Name = TO_GET_TOURNAMENTS then begin
      TouProcessGetTournaments(aAction);
      continue;
    end;

    if aAction.Name = TO_GET_LEADERBOARD then begin
      TouProcessGetLeaderBoard(aAction);
      continue;
    end;

    if aAction.Name = TO_GET_LEADERPOINTS then begin
      TouProcessGetLeaderPoints(aAction);
      continue;
    end;

    if aAction.Name = TO_GET_LEVELS_INFO then begin
      TouProcessGetLevelsInfo(aAction);
      continue;
    end;

(*
    if aAction.Name = AP_SPARKLECHEATS then begin
      ProcessSparkleCheats(aAction);
      continue;
    end;
*)
    CommonDataModule.Log(ClassName, 'ProcessAction',
      '[WARNING]: Unknown Action = ' + aAction.ActionNode.NodeName, ltError);

  end;
  //free resources
  Request.Clear;

  // notification & clear
  Response.SendActions;

  Result := PO_NOERRORS;
end;


// Notify

function TAPI.NotifyUser(SessionID: Integer; const Data: String; SendDirectly: Boolean): Integer;
begin
  Result := PO_NOERRORS;
  CommonDataModule.NotifyUser(SessionID, Data, SendDirectly);
end;

function TAPI.NotifyUserByID(UserID: Integer; const Data: String): Integer;
begin
  Result := PO_NOERRORS;
  CommonDataModule.NotifyUserByID(UserID, Data);
end;

function TAPI.NotifyUsers(SessionIDs: array of Integer; const Data: String): Integer;
begin
  Result := PO_NOERRORS;
  CommonDataModule.NotifyUsers(SessionIDs, Data);
end;

function TAPI.NotifyUsersByID(UserIDs: array of Integer; const Data: String): Integer;
begin
  Result := PO_NOERRORS;
  CommonDataModule.NotifyUsersByID(UserIDs, Data);
end;

function TAPI.NotifyAllUsers(const Data: String): Integer;
begin
  Result := PO_NOERRORS;
  CommonDataModule.NotifyAllUsers(Data);
end;


// TAPI  -  another procedures

function TAPI.BeginTransaction: Integer;
var
  FSql: TSQLAdapter;
begin
  result := PO_NOERRORS;
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.BeginTrans;
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'BeginTransaction',
        '[EXCEPTION] On exec FSql.BeginTrans:' + e.Message,
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result:=AP_ERR_CANNOTBEGINSQLTRANSACTION;
      Exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
end;

function TAPI.CanUserMakeAllIn(UserID: Integer;
  var UserCan: Integer): Integer;
var
  errCode : integer;
  sql: TSQLAdapter;
begin

  Result:=PO_NOERRORS;
  sql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    sql.SetProcName('apiCanUserMakeAllIn');
    sql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    sql.addparam('userId',userId,ptInput,ftInteger);
    sql.addparam('userCan',userCan,ptOutput,ftInteger);
    sql.ExecuteCommand;
    errCode := sql.Getparam('RETURN_VALUE');
    if errCode<>PO_NOERRORS then begin
      CommonDataModule.Log(ClassName, 'CanUserMakeAllIn',
        '[ERROR] On exec apiCanUserMakeAllIn:  Result=' + IntToStr(errCode) +
        '; Params: userId=' + IntToStr(UserID),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
      result := AP_ERR_USERCANNOUTMAKEALLIN;
      exit;
    end;
    userCan:=sql.getParam('userCan');
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'CanUserMakeAllIn',
        '[EXCEPTION] On exec apiCanUserMakeAllIn:' + e.Message +
        '; Params: userId=' + IntToStr(UserID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
      result := AP_ERR_USERCANNOUTMAKEALLIN;
      exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
end;

function TAPI.ChangeRemind(theSessionID, ProcessID: Integer;
  RemindTime: TDateTime; Data, RemindID: String): Integer;
begin
  result:=PO_NOERRORS;
  if not SendRemindAction ( SC_CHANGEREMIND
                          , ProcessId
                          , theSessionId
                          , RemindTime
                          , RemindId
                          , Data) then begin
    result:=SC_ERR_CANNOTCHANGEREMIND;
    exit;
  end;
end;

function TAPI.CloneProcess(ProcessSourceID: Integer;
  var ProcessTargetID: Integer): Integer;
var
  sql: TSQLAdapter;
begin

  processTargetId := 0;
  sql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    sql.SetProcName('apiCloneGameProcess');
    sql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    sql.addparam('GameProcessID',processSourceId,ptInputOutput,ftInteger);
    sql.executecommand();

    if sql.Getparam('RETURN_VALUE')<>PO_NOERRORS then begin // if not ok
      CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
      result := AP_ERR_CANNOTCLONEGAMEPROCESS;
      exit;
    end;

    processTargetId:=sql.Getparam('GameProcessID');
  except
    on E:Exception do begin
      CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
      result := AP_ERR_CANNOTCLONEGAMEPROCESS;
      exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(sql);

  // try Init New Game Process
  InitProcess(processTargetId);
  Result:=PO_NOERRORS;
end;

function TAPI.CommitTransaction: Integer;
var
  FSql: TSQLAdapter;
begin
  result := PO_NOERRORS;
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.CommitTrans;
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'CommitTransaction',
        '[EXCEPTION] On exec FSql.CommitTrans:' + e.Message,
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result:=PO_ERR_SQLADAPTORINSTANCEFAIL;
      Exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
end;

function TAPI.CreateActionLogOnFinishHand(HandID: Integer; Data: String): Integer;
begin
  Result:=PO_NOERRORS;
  CommonDataModule.ActionLog(HandID, Data);
end;

function TAPI.CreateRemind(theSessionID, ProcessID: Integer;
  RemindTime: TDateTime; Data: String; var RemindID: String): Integer;
var
  theGUID : TGUID;
begin
  result:=PO_NOERRORS;
  CoCreateGUID(theGUID);
  RemindId:=GUIDToString(theGUID);
  if not SendRemindAction ( SC_CREATEREMIND
                          , ProcessId
                          , theSessionId
                          , RemindTime
                          , RemindId
                          , Data) then begin
    result:=SC_ERR_CANNOTADDREMIND;
    exit;
  end;
end;

function TAPI.CreateState(ProcessID, StateNumber: Integer;
  var StateID: Integer): Integer;
var
  errCode : Integer;
  FSql: TSQLAdapter;
begin

  Result:=PO_NOERRORS;
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiCreateGameProcessStateByNumber');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('processId',ProcessId,ptInput,ftInteger);
    FSql.addparam('stateNumber',stateNumber,ptInput,ftInteger);
    FSql.addparam('stateId',stateId,ptOutput,ftInteger);
    FSql.executecommand();
    errCode := FSql.Getparam('RETURN_VALUE');

    if errCode<>PO_NOERRORS then begin // if not ok
      CommonDataModule.Log(ClassName, 'CreateState',
        '[ERROR] On exec apiCreateGameProcessStateByNumber Result=' + IntToStr(errCode) +
        '; Params: ProcessID=' + IntToStr(ProcessID) +
        ', StateNumber=' + IntToStr(StateNumber),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_CANNOTCREATEGAMESTATE;
      exit;
    end;

    stateId:=FSql.Getparam('stateId');
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'CreateState',
        '[EXCEPTION] On exec apiCreateGameProcessStateByNumber:' + e.Message +
        '; Params: ProcessID=' + IntToStr(ProcessID) +
        ', StateNumber=' + IntToStr(StateNumber),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_CANNOTCREATEGAMESTATE;
      exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
end;

function TAPI.CreateStats(ProcessID, StatsTypeID: Integer;
  Value: String): Integer;
var
  FSql: TSQLAdapter;
  errCode: Integer;
begin
  Result:=PO_NOERRORS;
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiCreateGameProcessStatsByType');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('processId',ProcessId,ptInput,ftInteger);
    FSql.addparam('statsTypeId',statsTypeId,ptInput,ftInteger);
    FSql.addparam('value',Value,ptInput,ftString);
    FSql.executecommand();
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'CreateStats',
        '[EXCEPTION] On exec apiCreateGameProcessStatsByType:' + e.Message +
        '; Params: ProcessID=' + IntToStr(ProcessID) +
        ', Value=' + Value,
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_CANNOTCREATEGAMESTATS;
      exit;
    end;
  end;

  errCode := FSql.Getparam('RETURN_VALUE');
  if errCode<>PO_NOERRORS then begin // if not ok
    CommonDataModule.Log(ClassName, 'GetStats',
      '[ERROR] On exec apiCreateGameProcessStatsByType Result=' + IntToStr(errCode) +
      '; Params: ProcessID=' + IntToStr(ProcessID) +
      ', Value=' + Value,
      ltError
    );

    result := AP_ERR_CANNOTCREATEGAMESTATS;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

end;

function TAPI.CreateTournamentRemind(tournamentId: Integer;
  execTime: TDateTime; Data: String): Integer;
var
  RequestXML  : IXMLDocument;
  Root,Node   : IXMLNode;
  RemindData  : string;
  s           : string;
begin

  // Initialization
  Result := 0;

  try
    RequestXML          := TXMLDocument.Create( nil );
    RequestXML.XML.Text := Data;
    RequestXML.Active   := true;
    s := DateTimeToStr(ExecTime);
    Root := RequestXML.DocumentElement;
    Node := Root.ChildNodes.First;
    Node := Node.ChildNodes.First;
    Node.Attributes['exectime'] := s;
    RemindData := RequestXML.DocumentElement.XML;
    RequestXML := nil;
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'CreateTournamentRemind',
        '[EXCEPTION] On open XMX Data:' + e.Message +
        '; Params: tournamentId=' + IntToStr(tournamentId) +
        ', execTime=' + DateTimeToStr(execTime) +
        ', Data=' + Data,
        ltException
      );
      Result:=AP_ERR_CANNOTCREATETOURNEYREMIND;
    end;
  end;

  CommonDataModule.ProcessAction(RemindData);

end;

function TAPI.FinishHand(HandID: Integer): Integer;
var
  FSql: TSQLAdapter;
  errCode: Integer;
begin
  Result:=PO_NOERRORS;
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiFinishHand');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('handId',handId,ptInput,ftInteger);
    FSql.executecommand();
    errCode := FSql.Getparam('RETURN_VALUE');
    if errCode<>PO_NOERRORS then begin
      CommonDataModule.Log(ClassName, 'FinishHand',
        '[ERROR] On exec apiFinishHand Result=' + IntToStr(errCode) +
        '; Params: HandID=' + IntToStr(HandID),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_CANNOTFINISHHAND;
      exit;
    end;

  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'FinishHand',
        '[EXCEPTION] On exec apiFinishHand or :' + e.Message +
        '; Params: HandID=' + IntToStr(HandID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_CANNOTFINISHHAND;
      exit;
    end;
  end;

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
end;

function TAPI.GetCurrency(CurrencyTypeID: Integer; var CurrencyName,
  CurrencySymbol: String): Integer;
var
  FSql: TSQLAdapter;
begin
  currencyName:='';
  currencySymbol:='';
  Result:=PO_NOERRORS;

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiGetCurrencyInfo');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('currencyTypeId',currencyTypeId,ptInput,ftInteger);
    FSql.addparam('currencyName','',ptOutput,ftString);
    FSql.addparam('currencySymbol','',ptOutput,ftString);
    FSql.ExecuteCommand;
    if FSql.Getparam('RETURN_VALUE')<>PO_NOERRORS then begin
        result := AP_ERR_CANNOTGETCURRENCYINFO;
        CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
        exit;
    end;
    currencyName:=FSql.getParam('currencyName');
    CurrencySymbol:=FSql.getParam('currencySymbol');
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'GetCurrency',
        '[EXCEPTION] On exec apiGetCurrencyInfo:' + e.Message +
        '; Params: currencyTypeId=' + IntToStr(currencyTypeId),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_CANNOTGETCURRENCYINFO;
      exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
end;

function TAPI.GetHandHistory(HandID: Integer; var Duration: Integer;
  var StartDate, EndDate: TDateTime; var Data: String): Integer;
var
  FSql    : TSQLAdapter;
  RS: TDataSet;
begin
  Result:=PO_NOERRORS;

  Data := '';
  StartDate := 0;
  EndDate := 0;
  Duration := 0;
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    RS := FSql.Execute(
      'Select [Data], [StartDate], [EndDate] from GameLog (nolock) ' +
      'where [id] = ' + IntToStr(HandID));
    RS.First;
    while not RS.Eof do
    begin
      if (StartDate = 0) then begin
        StartDate := RS.FieldByName('StartDate').AsDateTime;;
        EndDate := RS.FieldByName('EndDate').AsDateTime;;
      end;
      Data := Data + RS.FieldByName('Data').AsString;
      RS.Next;
    end;
    Data := CommonDataModule.UnCompress(Data);
    Duration := SecondsBetween(StartDate, EndDate);
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'GetHandHistory',
        '[EXCEPTION]:' + e.Message +
        '; Params: HandID=' + IntToStr(HandID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result:= AP_ERR_CANNOTGETHANDHISTORY;
      exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

  Data :=
    '<gamelog ' +
        'handid="' + inttostr(handId) + '" ' +
        'startdate="' + FormatDateTime('MM/dd/yyyy hh:mm:ss', StartDate) + '" ' +
        'enddate="' + FormatDateTime('MM/dd/yyyy hh:mm:ss', EndDate) + '" ' +
        'duration="' + IntToStr(Duration) + '">' +
      Data +
    '</gamelog>'; //  return outcome activity
end;


function TAPI.GetNextFromWaitingListAndLock(ProcessID, GroupID,
  PlayersCount: Integer; var UserID, SessionID, ParticipantCount: Integer): Integer;
var
  errCode : integer;
  sql: TSQLAdapter;
begin
  Result:=PO_NOERRORS;
  participantCount := 0;
  SessionID        := 0;
  userId           := 0;
  Exit;


  sql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try

    sql.SetProcName('apiGetNextFromWaitingListAndLock');
    sql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    sql.addparam('userId',0,ptOutput,ftInteger);
    sql.addparam('processId',processId,ptInput,ftInteger);
    sql.addparam('groupId',groupId,ptInput,ftInteger);
    sql.addparam('playersCount',playersCount,ptInput,ftInteger);
    sql.addparam('participantCount',0,ptOutput,ftInteger);
    sql.addparam('sessionid',0,ptOutput,ftInteger);
    sql.executecommand();
    errCode          := sql.Getparam('RETURN_VALUE');
    participantCount := sql.Getparam('participantCount');
    SessionID        := sql.Getparam('sessionid');
    userId           := sql.Getparam('userId');
    if errCode<>PO_NOERRORS then begin // participant is not logged on
      CommonDataModule.Log(ClassName, 'GetNextFromWaitingListAndLock',
        '[ERROR] On exec apiGetNextFromWaitingListAndLock:  Result=' + IntToStr(errCode) +
        '; Params: playersCount=' + IntToStr(playersCount) +
        ', processId=' + IntToStr(ProcessID) +
        ', groupId=' + IntToStr(GroupID),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
      result:= AP_ERR_CANNOTGETNEXTFROMWAITINGLIST;
      exit;
    end;
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'GetNextFromWaitingListAndLock',
        '[EXCEPTION] On exec apiGetNextFromWaitingListAndLock:' + e.Message +
        '; Params: playersCount=' + IntToStr(playersCount) +
        ', processId=' + IntToStr(ProcessID) +
        ', groupId=' + IntToStr(GroupID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
      result:= AP_ERR_CANNOTGETNEXTFROMWAITINGLIST;
      exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
end;

function TAPI.GetParticipantInfo(theSessionID: Integer;
  var UserID: Integer; var UserName, City: String; var SexID,
  AvatarID: Integer; var ImageVersion: Integer; var IP: String; var ChatAllow: Boolean;
  var AffiliateID: Integer; var IsEmailValidated: Boolean;
  var LevelID: Integer; var Icon1, Icon2, Icon3, Icon4: string): Integer;
var
  errCode : integer;
  FSql: TSQLAdapter;
  nChatAllow: Integer;
  nIsEmailValidated: Integer;
begin

  userId:=0;
  userName:='';
  city:='';
  LevelID := 0;
  Icon1 := '';
  Icon2 := '';
  Icon3 := '';
  Icon4 := '';

  Result:=PO_NOERRORS;

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiGetParticipantInfo');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('sessionId',theSessionId,ptInput,ftInteger);
    FSql.addparam('host','',ptOutput,ftString);
    FSql.addparam('userId',0,ptOutput,ftInteger);
    FSql.addparam('userName','',ptOutput,ftString);
    FSql.addparam('city','',ptOutput,ftString);
    FSql.addparam('sexId',0,ptOutput,ftInteger);
    FSql.addparam('avatarId',0,ptOutput,ftInteger);
    FSql.addparam('ImageVersion',0,ptOutput,ftInteger);
    FSql.addparam('IP','',ptOutput,ftString);
    FSql.addparam('ChatAllow',0,ptOutput,ftInteger);
    FSql.addparam('AffiliateID',0,ptOutput,ftInteger);
    FSql.addparam('IsEmailValidated',0,ptOutput,ftInteger);
    FSql.addparam('LevelID',0,ptOutput,ftInteger);
    FSql.executecommand();

    errCode := FSql.Getparam('RETURN_VALUE');
    if errCode<>PO_NOERRORS then begin // participant is not logged on
      CommonDataModule.Log(ClassName, 'GetParticipantInfo',
        '[ERROR] On exec apiGetParticipantInfo Result=' + IntToStr(errCode) +
        '; Params: theSessionID=' + IntToStr(theSessionID) + ', Session is disconnected.',
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result:= AP_ERR_PARTICIPANTISNOTLOGGEDON;
      exit;
    end;

    userID         := FSql.Getparam('userId');
    userName       := FSql.Getparam('username');
    city           := FSql.Getparam('city');
    sexID          := FSql.Getparam('sexId');
    avatarID       := FSql.Getparam('avatarId');
    ImageVersion   := FSql.Getparam('ImageVersion');
    IP             := FSql.Getparam('IP');
    nChatAllow     := FSql.Getparam('ChatAllow');
    AffiliateID   := FSql.Getparam('AffiliateID');
    nIsEmailValidated := FSql.Getparam('IsEmailValidated');
    LevelID        := FSql.Getparam('LevelID');

    if nChatAllow > 0 then ChatAllow := True else ChatAllow := False;
    if nIsEmailValidated > 0 then IsEmailValidated := True else IsEmailValidated := False;

  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'GetParticipantInfo',
        '[EXCEPTION] On exec apiGetParticipantInfo:' + e.Message +
        '; Params: theSessionID=' + IntToStr(theSessionID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_CANNOTGETPARTICIPANTINFO;
      exit;
    end;
  end;

  GetUserIcons(UserID, FSql, Icon1, Icon2, Icon3, Icon4);

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

end;

function TAPI.GetPersonalHandHistory(UserID, HandID,
  RemoveOtherRanking: Integer; var Data: String): Integer;
var
  hist : IXMLDocument;
  root : IXMLNode;
  handTemplate                : String;
  s                           : string;
  i,j,k                       : integer;
  pokerType                   : integer;
  isPresented                 : boolean;
  position                    : integer;
  lastCardNumber              : integer;
  procstate
  ,chairs
  ,chair
  ,procinit
  ,ranking
  ,dealcards
  ,dealcard                   : IXMLNode;
  isRemoved                   : boolean;
  errCode                     : integer;
  errMessage                  : string;
  //..........................................................................
  function toBackTemplate(pokerType : integer;var lastCardNumber:integer;cards:string):string;
  var
    sIn         : string;
    sOut        : string;
    theCard     : string;
    delim       : string;
    dot         : integer;
    index       : integer;
  begin
    //################################
    index:=1;
    sIn:=cards;
    sOut:='';
    theCard:='';
    delim:='';
    dot:=pos(',',sIn);
    while dot>0 do begin
      theCard:=copy(sIn,1,dot-1);
      sIn:=copy(sIn,dot+1,length(sIn));
      if (pokerType>3) and (index>2) and (index<7) then begin
        sOut:=sOut+delim+theCard;
      end
      else begin
        sOut:=sOut+delim+'back';
      end;
      dot:=pos(',',sIn);
      delim:=',';
      inc(index);
    end;

    if length(sIn)<>0 then begin
      if (pokerType>3) and (index>2) and (index<7) then begin
        sOut:=sOut+delim+sIn;
      end
      else begin
        sOut:=sOut+delim+'back';
      end;
    end;

    result := sOut; // Important It's harcode and should be changed in test
    //################################
  end;

var
  StartDate, EndDate: TDateTime;
  nDuration: Integer;
begin

  hist:=TXMLDocument.Create(nil);
  hist.Active:=false;
  hist.XML.Text:='<gaaction/>';
  hist.Active:=true;
  root:=hist.DocumentElement;
  root.Attributes['result']:='0';
  data := root.XML;

  errCode := GetHandHistory(handId, nDuration, StartDate, EndDate, handTemplate);
  if errCode<>PO_NOERRORS then begin
    CommonDataModule.Log(ClassName, 'GetPersonalHandHistory',
      '[ERROR] On exec GetHandHistory Result=' + IntToStr(errCode) +
      '; Params: HandID=' + IntToStr(HandID),
      ltError
    );
    result := errCode;
    exit;
  end;

  root.Attributes['startdate'] := FormatDateTime('MM/dd/yyyy hh:mm:ss', StartDate);
  root.Attributes['enddate'] := FormatDateTime('MM/dd/yyyy hh:mm:ss', EndDate);
  root.Attributes['duration'] := nDuration;

  s:=handTemplate;

  with root do begin
    // when XML packet string is prepared we have to insert it to the response packet
    if not AddChildNodesFromXMLChildNodes(s,root,errMessage) then begin
      result:=AP_ERR_CANNOTADDXMLCHILDNODE;
      exit;
    end;
  end; //with resp.ActionNode

  // Analyze handTemplate
  try
    //================
    // Init
    pokerType:=0; // undefined
    isPresented:=false;
    position:=-1;

    with root do begin
      if HasChildNodes then begin
        i:=0;
        while i<=ChildNodes.Count-1 do begin
         isRemoved:=false;

          //===============
          // Proc Init - look for poker type
          if (ChildNodes.Nodes[i].NodeName='procinit') and (pokerType=0) then begin
            procinit:=ChildNodes.Nodes[i];
            try
              pokerType:=procinit.ChildNodes.Nodes['pokertype'].Attributes['value'];
            except
              on E:Exception do begin
                result:=AP_ERR_POKERTYPEUNDEFINED;
                exit;
              end;
            end;
          end; // if ChildNodes.Nodes[i].NodeName='procinit' then begin

          //===============
          // Proc State - look for participant
          if (ChildNodes.Nodes[i].NodeName='procstate')
            and (not isPresented) then begin

            procState:=ChildNodes.Nodes[i];
            try
              if procState.HasChildNodes then begin
                for j:=0 to procState.ChildNodes.Count-1 do begin
                  if procState.ChildNodes.Nodes[j].NodeName='chairs' then begin
                    chairs:=procState.ChildNodes.Nodes[j];
                    if chairs.HasChildNodes then begin
                      for k:=0 to chairs.ChildNodes.Count-1 do begin
                        chair:=chairs.ChildNodes.Nodes[k];
                        if chair.Attributes['status']='busy' then begin
                          if chair.ChildNodes.Nodes['player'].Attributes['id']=userId then begin
                            isPresented:=true;
                            position:=chair.Attributes['position'];
                          end;
                        end;
                        if isPresented then break;
                      end;
                    end; // if chairs.HasChildNodes then begin
                    if isPresented then break;
                  end; // if procState.ChildNodes.Nodes[j].NodeName='chairs'
                  if isPresented then break;
                end; // for j:=0 to procState.ChildNodes.Count-1
              end; // if ChildNodes.Nodes[i].HasChildNodes
            except
              on E:Exception do begin
                result:=AP_ERR_POKERTYPEUNDEFINED;
                exit;
              end;
            end;
          end; // if ChildNodes.Nodes[i].NodeName='procstate' then begin

          //===============
          // Deal Cards - change deck
          if (ChildNodes.Nodes[i].NodeName='dealcards') then begin
            if pokerType=0 then begin
                result:=AP_ERR_POKERTYPEUNDEFINED;
                exit;
            end;

            dealcards:=ChildNodes.Nodes[i];
            try
              if dealcards.HasChildNodes then begin
                for j:=0 to dealcards.ChildNodes.Count-1 do begin
                  dealcard:=dealcards.ChildNodes.Nodes[j];
                  if dealcard.NodeName='deal' then begin
                    if dealCard.Attributes['position']<>position then begin
                      dealCard.Attributes['cards']:=toBackTemplate(pokerType,lastCardNumber,dealCard.Attributes['cards']);
                    end;
                  end;
                end; // for j:=0 to dealcards.ChildNodes.Count-1 do begin
              end; // if dealcards.HasChildNodes then begin
            except
                on E:Exception do begin
                    result:=AP_ERR_POKERTYPEUNDEFINED;
                    exit;
                end;
            end;
          end; // if ChildNodes.Nodes[i].NodeName='procinit' then begin

          //===============
          // Ranking - remove alien steps
          if (removeOtherRanking = 1) and (ChildNodes.Nodes[i].NodeName='ranking') then begin

            if pokerType=0 then begin
              result:=AP_ERR_POKERTYPEUNDEFINED;
              exit;
            end;

            ranking:=ChildNodes.Nodes[i];
            try
              if ranking.Attributes['position']<>position then begin
                isRemoved:=true;
                ChildNodes.Remove(ranking);
              end;
            except
              on E:Exception do begin
                result:=AP_ERR_POKERTYPEUNDEFINED;
                exit;
              end;
            end;
          end; // if ChildNodes.Nodes[i].NodeName='procinit' then begin

          if not isRemoved then begin
            i:=i+1;
          end;

        end; // while i<=ChildNodes.Count-1 do begin
      end; // if HasChildNodes then begin
    end; // with resp.ActionNode do begin
  except
    on E:Exception do begin
      result:=AP_ERR_CANNOTCORRECTHANDHISTORY;
      exit;
    end;
  end; // main try

  data := root.XML;
  hist:=nil;
  result := PO_NOERRORS;

end;

function TAPI.GetPersonalHandHistoryAsText(UserID, HandID: Integer;
  var Data: String): Integer;
type
  //....................................................................................
  TUser = record
    userId          : integer ;
    position        : integer;
    userName        : string;
    city            : string;
    startBalance    : currency;
    stake           : currency;
    cards           : string;
    lastAction      : string;
    rankingPhrase   : string;
    rankingPhraseLo : string;
    isdealer        : integer;
    isWinner        : integer;
    summary         : string;
    won             : currency;
  end;
  //....................................................................................
  TCommon = record
    handId        : integer;
    processId     : integer;
    processName   : string;
    pokerType     : integer;
    currencyId    : integer;
    currencyName  : string;
    playercount   : integer;
    startDate     : string;
    endDate       : string;
    minStake      : string;
    maxStake      : string;
    pot           : array of currency;
    rake          : currency;
    commonCards   : array of string;
  end;
  //....................................................................................
const
  DelimeterLineLength = 90;
var
  hist   : IXMLDocument;
  cmn    : TCommon;
  usr    : array of TUser;
  input  : String;
  output : string;
  root   : IXMLNode;

  s,ss                    : string;
  i,j,k,l                 : integer;
  procstate
  ,chairs
  ,chair
  ,procinit
  ,dealcards
  ,chat
  ,action
  ,endround
  ,finishhand
  ,finalpot
  ,deal
  ,node
  ,pot
  ,winner
  ,movebets
  ,move                       : IXMLNode;
  delta                       : currency;
  fg                          : TReplaceFlags;
  sql: TSQLAdapter;
  //....................................................................................
  procedure Print(msg:string);
  begin
      output := output + msg;
  end; // procedure Print
  //....................................................................................
  procedure PrintLn(msg:string);
  begin
      output := output + msg + '<br>';
  end; // procedure PrintLn
  //....................................................................................
  function Clone(msg: string; RepeatCount: integer):string;
  var i1: integer;
      s1: string;
  begin
      s1:='';
      for i1 := 0 to RepeatCount do begin
          s1 := s1 + msg;
      end;
      result := s1;
  end; // function Clone
  //....................................................................................
  procedure ToCommonCards(cards:string);
  var
    sIn         : string;
    delim       : string;
    dot         : integer;
    card        : string;
    i1          : integer;
  begin
    //################################
    sIn:=cards;
    delim:='';
    dot:=pos(',',sIn);
    i1:=0;
    while dot>0 do begin
      card:=copy(sIn,0,dot-1);
      sIn:=copy(sIn,dot+1,length(sIn));
      if length(cmn.commonCards)<(i1+1) then setLength(cmn.commonCards,length(cmn.commonCards)+1);
      cmn.commonCards[i1]:=card;
      dot:=pos(',',sIn);
      i1:=i1+1;
    end;

    if length(sIn)<>0 then begin
      if length(cmn.commonCards)<(i1+1) then setLength(cmn.commonCards,length(cmn.commonCards)+1);
      cmn.commonCards[i1]:=sIn;
    end;
  end; // procedure ToCommonCards
  //....................................................................................
  function needShowDeeling(userPosition: integer;input:string; var output:string):boolean;
  var
    sIn         : string;
    delim       : string;
    dot         : integer;
    card        : string;
    anyOpened   : boolean;
    index       : integer;
  begin
    //################################

    anyOpened:=true;
    sIn:=input;
    delim:='';
    dot:=pos(',',sIn);
    output:='';
    index:=1;
    while dot>0 do begin
      card:=copy(sIn,0,dot-1);
      sIn:=copy(sIn,dot+1,length(sIn));
      if cmn.pokerType>3 then begin
          if (card='back') then begin
              card := 'XX';
          end;
          anyOpened:=false;
      end
      else begin
          if (card<>'back') then begin
              anyOpened:=false;
          end
          else begin
              card := 'XX';
          end;
      end;

      output:=output+delim+card;
      delim:=' ';
      dot:=pos(',',sIn);
      inc(index);
    end;

    if length(sIn)<>0 then begin
      if cmn.pokerType>3 then begin
        if (sIn='back') then begin
            sIn := 'XX';
        end;
        anyOpened:=false;
      end
      else begin
        if (sIn<>'back') then begin
            anyOpened:=false;
        end
        else begin
            sIn := 'XX';
        end;
      end;
      if (cmn.pokerType>3) and (index>4) then begin
          delim:=' ] [ ';
      end;
      output:=output+delim+sIn;
    end;

    usr[userPosition].cards:=output;
    result := not anyOpened;

  end; // function needShowDeeling
  //....................................................................................
  function Bold(msg:string):string;
  begin
      result:=msg;
      //result:='<b>'+msg+'</b>';
  end; // function B
  //....................................................................................
  function Italic(msg:string):string;
  begin
      result:=msg;
      //result:='<i>'+msg+'</i>';
  end;
  //....................................................................................
  function Red(msg:string):string;
  begin
      result:=msg;
      //result:='<font color="#FF0000">'+msg+'</font>';
  end;
  //....................................................................................
  function Blue(msg:string):string;
  begin
      result:=msg;
      //result:='<font color="#0000FF">'+msg+'</font>';
  end;
  //....................................................................................
  function DarkBlue(msg:string):string;
  begin
      result:=msg;
      //result:='<font color="#000099">'+msg+'</font>';
  end;
  //....................................................................................
  function Green(msg:string):string;
  begin
      result:=msg;
      //result:=Bold('<font color="#007700">'+msg+'</font>');
  end;
  //....................................................................................
  function Magenta(msg:string):string;
  begin
      result:=msg;
      //result:='<font color="#CC00FF">'+msg+'</font>';
  end;
  //....................................................................................
  function Orange(msg:string):string;
  begin
      result:=msg;
      //result:='<font color="#CC0000">'+msg+'</font>';
  end;
  //....................................................................................
  function Cyan(msg:string):string;
  begin
      result:=msg;
      //result:='<font color="#6699FF">'+msg+'</font>';
  end;
  //....................................................................................
  function Money(msg:string):string;
  begin
      result:=msg;
      //result:='<font color="#006600">'+msg+'</font>';
  end;
  //....................................................................................
  function ToCard(msg:string):string;
  var
    sIn         : string;
    sOut        : string;
    dot         : integer;
    card        : string;
    function ChangeChar(source:string;color:string;oldChar:string;newChar:string):string;
    var s: string;
    begin
      s:='';
      if pos(oldChar,source)>0 then begin
        s:=s+stringReplace(source,oldChar,newChar,[rfReplaceAll]);
        s:='&nbsp;'+s+'&nbsp;';
        //s:='<font color="'+color+'" face="Times" size="4">'+s+'</font>';
      end;
      result:=s;
    end;
  begin
    //################################
    sIn:=msg;
    sOut:='';
    dot:=pos(' ',sIn);
    while dot>0 do begin
      card:=copy(sIn,0,dot-1);
      sIn:=copy(sIn,dot+1,length(sIn));
      card:=stringReplace(card,'T','10',[rfReplaceAll]);

      //if pos('XX',card)>0 then sOut:=sOut+ChangeChar(card,'#CC6600','XX','XX');
      if pos('back',card)>0 then sOut:=sOut+ChangeChar(card,'#CC6600','back','XX');
      if pos('back',card)=0 then sOut:=sOut+ChangeChar(card,'#CC6600',card,card);

      //if pos('s',card)>0 then sOut:=sOut+ChangeChar(card,'#000000','s','&#9824;');
      //if pos('c',card)>0 then sOut:=sOut+ChangeChar(card,'#000000','c','&#9827;');
      //if pos('h',card)>0 then sOut:=sOut+ChangeChar(card,'#FF0000','h','&#9829;');
      //if pos('d',card)>0 then sOut:=sOut+ChangeChar(card,'#FF0000','d','&#9830;');
      //sOut:=sOut+card;
      dot:=pos(' ',sIn);
    end;

    if length(sIn)<>0 then begin

      card:=sIn;
      card:=stringReplace(card,'T','10',[rfReplaceAll]);
      //if pos('XX',card)>0 then sOut:=sOut+ChangeChar(card,'#CC6600','XX','XX');
      if pos('back',card)>0 then sOut:=sOut+ChangeChar(card,'#CC6600','back','XX');
      if pos('back',card)=0 then sOut:=sOut+ChangeChar(card,'#CC6600',card,card);
      //if pos('s',card)>0 then sOut:=sOut+ChangeChar(card,'#000000','s','&#9824;');
      //if pos('c',card)>0 then sOut:=sOut+ChangeChar(card,'#000000','c','&#9827;');
      //if pos('h',card)>0 then sOut:=sOut+ChangeChar(card,'#FF0000','h','&#9829;');
      //if pos('d',card)>0 then sOut:=sOut+ChangeChar(card,'#FF0000','d','&#9830;');
      //sOut:=sOut+card;
    end;

    result:=sOut;
  end;

  procedure Log(msg: string);
  begin
    // Now all game logs output is disabled
    CommonDataModule.Log(ClassName, 'GetPersonalHandHistoryAsText', msg, ltCall);
  end;

begin

    // defaults
    data   :='';
    fg     := [rfReplaceAll];

    //*********************************
    //**  Preparing, Initialization  **
    //*********************************
    try
        result:=GetPersonalHandHistory(userId,handId,0,input);
        Log('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
        Log(ReadableXML(input));
        Log('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
        hist:=TXMLDocument.Create(nil);
        hist.Active:=false;
        hist.XML.Text:=input;
        hist.Active:=true;
        root:=hist.DocumentElement;
    except
        on E:Exception do begin
            result := AP_ERR_TEXTHISTCANNOTINIT;
            exit;
        end;
    end;

//    requesterPos:=-1;
    cmn.handId:=0;
    cmn.processId:=0;
    cmn.processName:='';
    cmn.pokerType:=0;
    cmn.currencyId:=0;
    cmn.currencyName:='';
    cmn.startDate:='';
    cmn.endDate:='';
    cmn.minStake:='0';
    cmn.maxStake:='0';
    setLength(cmn.pot,1);
    cmn.pot[0]:=0;
    cmn.rake:=0;
    cmn.playercount:=0;

    ////log('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    ////log('Start XML Is:');
    ////log(readableXML(root.xml));
    ////log('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');

    // Start Getting XML Info
    // Analyze handTemplate
    try

        //***********************
        //**  Data Recognizing **
        //***********************

        with root do begin
            if HasChildNodes then begin
                i:=0;
                while i<=ChildNodes.Count-1 do begin

                    //===============
                    // Proc Init - look for poker type
                    if (ChildNodes.Nodes[i].NodeName='procinit')
                       and (cmn.pokerType=0) then begin
                        procinit:=ChildNodes.Nodes[i];
                        try
                            cmn.pokerType:=procinit.ChildNodes.Nodes['pokertype'].Attributes['value'];
                            cmn.currencyId:=procinit.ChildNodes.Nodes['currencyid'].Attributes['value'];
                            cmn.playercount:=procinit.ChildNodes.Nodes['playercount'].Attributes['value'];
                        except
                            on E:Exception do begin
                                result:=AP_ERR_POKERTYPEUNDEFINED;
                                exit;
                            end;
                        end;
                    end; // if ChildNodes.Nodes[i].NodeName='procinit' then begin


                    //===============
                    // Proc State - look for participant
                    if (ChildNodes.Nodes[i].NodeName='procstate') and (cmn.pokerType<>0) and (cmn.handId=0) then begin

                        procState:=ChildNodes.Nodes[i];

                        try
                            cmn.handId:=procState.Attributes['handid'];
                            cmn.minStake:=procState.Attributes['minstake'];
                            cmn.maxStake:=procState.Attributes['maxstake'];
                        except
                            on E:Exception do begin
                                result:=AP_ERR_WRONGPROCSTATE;
                                exit;
                            end;
                        end;

                        try
                            if procState.HasChildNodes then begin
                                for j:=0 to procState.ChildNodes.Count-1 do begin
                                    if procState.ChildNodes.Nodes[j].NodeName='chairs' then begin
                                        chairs:=procState.ChildNodes.Nodes[j];
                                        if chairs.HasChildNodes then begin
                                            for k:=0 to chairs.ChildNodes.Count-1 do begin
                                                chair:=chairs.ChildNodes.Nodes[k];
                                                setLength(usr,length(usr)+1);
                                                l:=length(usr)-1;
                                                usr[l].position:=chair.Attributes['position'];
                                                usr[l].isdealer:=chair.Attributes['isdealer'];
                                                usr[l].stake:=0;
                                                usr[l].lastAction:='';
                                                usr[l].rankingPhrase:='';
                                                usr[l].rankingPhraseLo:='';
                                                usr[l].isWinner:=0;
                                                usr[l].summary:='';
                                                usr[l].won:=0;
                                                if chair.Attributes['status']='busy' then begin
                                                    usr[l].userId:=chair.ChildNodes.Nodes['player'].Attributes['id'];
//                                                    if usr[l].userId=userId then requesterPos:=l;
                                                    usr[l].userName:=chair.ChildNodes.Nodes['player'].Attributes['name'];
                                                    usr[l].city:=chair.ChildNodes.Nodes['player'].Attributes['city'];
                                                    usr[l].startBalance:=chair.ChildNodes.Nodes['player'].Attributes['balance'];
                                                    usr[l].isdealer:=chair.Attributes['isdealer'];
                                                end
                                                else begin
                                                    usr[l].userId:=0;
                                                    usr[l].userName:='';
                                                    usr[l].city:='';
                                                    usr[l].startBalance:=0;
                                                    usr[l].isdealer:=0;
                                                end;
                                            end;
                                        end; // if chairs.HasChildNodes then begin
                                    end; // if procState.ChildNodes.Nodes[j].NodeName='chairs'
                                end; // for j:=0 to procState.ChildNodes.Count-1
                            end; // if ChildNodes.Nodes[i].HasChildNodes
                        except
                            on E:Exception do begin
                                result:=AP_ERR_WRONGPROCSTATE;
                                exit;
                            end;
                        end;
                    end; // if ChildNodes.Nodes[i].NodeName='procstate' then begin

                    i:=i+1; // Next step

                end; // while i<=ChildNodes.Count-1 do begin
            end; // if HasChildNodes then begin
        end; // with root do begin

        //***************************************
        //**  Getting Additional Info From SQL **
        //***************************************
        sql := CommonDataModule.ObjectPool.GetSQLAdapter;
        try
            sql.SetProcName('apiGetAdditioanlHandInfo');
            sql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
            sql.addparam('handId',cmn.handId,ptInput,ftInteger);
            sql.addparam('currencyId',cmn.currencyId,ptInput,ftInteger);
            sql.addparam('processId',0,ptOutput,ftInteger);
            sql.addparam('processName','',ptOutput,ftString);
            sql.addparam('currencyName','',ptOutput,ftString);
            sql.addparam('startDate','',ptOutput,ftString);
            sql.addparam('endDate','',ptOutput,ftString);
            sql.executecommand();
            cmn.processId    := sql.Getparam('processId');
            cmn.processName  := sql.Getparam('processName');
            cmn.currencyName := sql.Getparam('currencyName');
            cmn.startDate    := sql.Getparam('startDate');
            cmn.endDate      := sql.Getparam('endDate');
            if sql.Getparam('RETURN_VALUE')<>PO_NOERRORS then begin
                CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
                exit;
            end;
        except
            on E:Exception do begin
                CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
                result:=AP_ERR_CANNOTGETADDITIONALINFOFROMSQL;
                exit;
            end;
        end;
        CommonDataModule.ObjectPool.FreeSQLAdapter(sql);


        //********************
        //**  Report Output **
        //********************
        // 1. Common
        try
            //PrintLn('<hr>');
            Print('Game '+('#'+(inttostr(cmn.handId)))+' - '+Magenta((cmn.minStake))+'/'+Magenta((cmn.maxStake))+' ');
            case cmn.PokerType of
                1: Print(('Hold''em'));
                2: Print(('Omaha'));
                3: Print(('Omaha Hi/Lo'));
                4: Print(('7 Stud'));
                5: Print(('7 Stud Hi/Lo'));
                6: Print(('Five Card Draw'));
                7: Print(('Five Card Stud'));
                8: Print(('Crazy Pineapple'));
            end;
            Println(' ('+Magenta(cmn.startDate)+')');
            Print('Table "'+Bold((cmn.processName))+'" ');
            case cmn.currencyId of
                1: Print('(Play chips)');
                2: Print('(Money chips)');
                else Print(cmn.currencyName);
            end;
            for i:=0 to length(usr)-1 do begin
                if usr[i].isdealer=1 then begin
                    Print('-- Seat '+(inttostr(i+1))+' is the button');
                end;
            end;
            PrintLn('');
            for i:=0 to length(usr)-1 do begin
                if usr[i].userId<>0 then begin
                    PrintLn('Seat '+inttostr(i+1)+': '+(Green(usr[i].userName))+' ('+Money(floattostr(usr[i].startBalance))+' in chips)');
                end;
            end;

        except
            on E:Exception do begin
                result:=AP_ERR_CANNOTPREPAREHANDTEXTOUTPUT;
                exit;
            end;
        end;
        // 2. Show Game Process Body


        with root do begin
            if HasChildNodes then begin
                i:=0;
                while i<=ChildNodes.Count-1 do begin

                    (*
                    // Ranking - chat message
                    if (ChildNodes.Nodes[i].NodeName='ranking') then begin
                        ranking:=ChildNodes.Nodes[i];
                        j:=ranking.Attributes['position'];
                        usr[j].rankingPhrase:=ranking.Attributes['msg'];
                        if ranking.HasAttribute('lomsg') then begin
                            usr[j].rankingPhraseLo:=ranking.Attributes['lomsg'];
                        end;
                    end; // if (ChildNodes.Nodes[i].NodeName='chat') then begin
                    *)


                    //===============
                    // MoveBets - move bets
                    if (ChildNodes.Nodes[i].NodeName='movebets') then begin
                        movebets:=ChildNodes.Nodes[i];
                        if movebets.HasChildNodes then begin
                            for j:=0 to movebets.ChildNodes.Count-1 do begin
                                move:=movebets.ChildNodes.Nodes[j];
                                if move.NodeName='move' then begin
                                    k:=move.Attributes['position'];
                                    usr[k].stake:=usr[k].stake+move.Attributes['amount'];
                                end;
                            end;
                        end;
                    end; // if (ChildNodes.Nodes[i].NodeName='chat') then begin

                    //===============
                    // Chat - chat message
                    if (ChildNodes.Nodes[i].NodeName='chat') then begin
                        chat:=ChildNodes.Nodes[i];
                        if chat.Attributes['src']='2' then begin
                            PrintLn(Green((chat.Attributes['username']))+((' said'))+':"'+chat.Attributes['msg']+'"');
                        end;
                    end; // if (ChildNodes.Nodes[i].NodeName='chat') then begin

                    //===============
                    // Action - game action
                    if (ChildNodes.Nodes[i].NodeName='action') then begin
                        action:=ChildNodes.Nodes[i];
                        j:=action.Attributes['position'];

                        if action.Attributes['name']='call' then begin
                           Print(Green((usr[j].userName))+' : '+(('Call'))+' ('+Money(action.Attributes['stake'])+')');
                           if action.Attributes['balance']='0' then begin
                               PrintLn(' All-In');
                           end
                           else begin
                               PrintLn(' ');
                           end;
                        end;

                        if action.Attributes['name']='check' then begin
                           Print(Green((usr[j].userName))+' : '+(('Check')));
                           if action.Attributes['balance']='0' then begin
                               PrintLn(' All-In');
                           end
                           else begin
                               PrintLn(' ');
                           end;
                        end;

                        if action.Attributes['name']='bet' then begin
                            Print(Green((usr[j].userName))+' : '+(('Bet'))+' ('+Money(action.Attributes['stake'])+')');
                            if action.Attributes['balance']='0' then begin
                               PrintLn(' All-In');
                            end
                            else begin
                               PrintLn(' ');
                            end;
                        end;

                        if action.Attributes['name']='raise' then begin
                            Print(Green((usr[j].userName))+' : '+(('Raise'))+' ('+Money(action.Attributes['stake'])+')');
                            if action.Attributes['balance']='0' then begin
                               PrintLn(' All-In');
                            end
                            else begin
                               PrintLn(' ');
                            end;
                        end;

                        if action.Attributes['name']='postsb' then begin
                            Print(Green((usr[j].userName))+' : '+(('Post Small Blind'))+' ('+Money(action.Attributes['stake'])+')');
                            if action.Attributes['balance']='0' then begin
                               PrintLn(' All-In');
                            end
                            else begin
                               PrintLn(' ');
                            end;
                        end;

                        if action.Attributes['name']='postbb' then begin
                            Print(Green((usr[j].userName))+' : '+(('Post Big Blind'))+' ('+Money(action.Attributes['stake'])+')');
                            if action.Attributes['balance']='0' then begin
                               PrintLn(' All-In');
                            end
                            else begin
                               PrintLn(' ');
                            end;
                        end;

                        if action.Attributes['name']='post' then begin
                            Print(Green((usr[j].userName))+' : '+(('Post'))+' ('+Money(action.Attributes['stake'])+')');
                            if action.Attributes['balance']='0' then begin
                               PrintLn(' All-In');
                            end
                            else begin
                               PrintLn(' ');
                            end;
                        end;

                        if action.Attributes['name']='postdead' then begin
                            Print(Green((usr[j].userName))+' : '+(('Post Both'))+' ('+Money(action.Attributes['stake'])+')');
                            if action.Attributes['balance']='0' then begin
                               PrintLn(' All-In');
                            end
                            else begin
                               PrintLn(' ');
                            end;
                        end;

                        if action.Attributes['name']='ante' then begin
                            Print(Green((usr[j].userName))+' : '+(('Ante'))+' ('+Money(action.Attributes['stake'])+')');
                            if action.Attributes['balance']='0' then begin
                               PrintLn(' All-In');
                            end
                            else begin
                               PrintLn(' ');
                            end;
                        end;

                        if action.Attributes['name']='bringin' then begin
                            Print(Green((usr[j].userName))+' : '+(('Bring-In'))+' ('+Money(action.Attributes['stake'])+')');
                            if action.Attributes['balance']='0' then begin
                               PrintLn(' All-In');
                            end
                            else begin
                               PrintLn(' ');
                            end;
                        end;

                        if action.Attributes['name']='fold' then begin
                            PrintLn(Green((usr[j].userName))+' : '+(('Fold')));
                            usr[j].lastAction:='('+('folded')+')';
                        end;

                        if (action.Attributes['name']='showcards')
                            or (action.Attributes['name']='showcardsshuffled') then begin

                            s:=stringReplace(action.Attributes['cards'],',',' ',fg);
                            //PrintLn(usr[j].userName+' : Show Cards [ '+s+' ]');
                            usr[j].lastAction:='(showed hand) [ '+(ToCard(s))+' ]';

                            usr[j].rankingPhrase := '';
                            if action.HasAttribute('hirank') then
                              usr[j].rankingPhrase:=action.Attributes['hirank'];
                            if action.HasAttribute('lorank') then begin
                                usr[j].rankingPhraseLo:=action.Attributes['lorank'];
                            end
                            else begin
                                usr[j].rankingPhraseLo:='';
                            end;

{                            //===============
                            // Ranking - chat message
                            if (ChildNodes.Nodes[i].NodeName='ranking') then begin
                                ranking:=ChildNodes.Nodes[i];
                                j:=ranking.Attributes['position'];
                                usr[j].rankingPhrase:=ranking.Attributes['msg'];
                                if ranking.HasAttribute('lomsg') then begin
                                    usr[j].rankingPhraseLo:=ranking.Attributes['lomsg'];
                                end;
                            end; // if (ChildNodes.Nodes[i].NodeName='chat') then begin
 }

                        end;


                        if action.Attributes['name']='muck' then begin
                            PrintLn(Green(usr[j].userName)+' : '+(('Muck ')));
                            usr[j].lastAction:='('+('muck')+')';
                        end;

                    end; // if (ChildNodes.Nodes[i].NodeName='action') then begin

                    if (ChildNodes.Nodes[i].NodeName='pots') then begin
                        if ChildNodes.Nodes[i].HasChildNodes then begin
                            for k:=0 to ChildNodes.Nodes[i].ChildNodes.Count-1 do begin
                                pot:=ChildNodes.Nodes[i].ChildNodes.nodes[k];
                                if (length(cmn.pot) < k+1) then begin
                                    setLength(cmn.pot,length(cmn.pot)+1);
                                end;
                                cmn.pot[k]:=pot.Attributes['amount'];
                                Log('GETPOT:::'+pot.Attributes['amount']);
                            end; // for
                        end; // if
                    end; // if


                    //===============
                    // Dealcards - dealing
                    if (ChildNodes.Nodes[i].NodeName='dealcards') then begin
                        dealcards:=ChildNodes.Nodes[i];
                        PrintLn('Dealing ...');
                        if dealCards.HasChildNodes then begin
                            for j:=0 to dealCards.ChildNodes.Count-1 do begin
                                deal:=dealCards.ChildNodes.Nodes[j];
                                if deal.NodeName='deal' then begin
                                    k:=deal.Attributes['position'];
                                    s:=stringReplace(deal.Attributes['cards'],',',' ',fg);

                                    Log('###Deal::'+s);

                                    usr[k].lastAction:='';
                                    if (needShowDeeling(k,deal.Attributes['cards'],s)) or (cmn.pokerType>3) then begin
                                        usr[k].lastAction:='('+('showed hand')+') [ '+(ToCard(s))+' ]';
                                        PrintLn('  &nbsp;&nbsp;&nbsp; '+Green((usr[k].userName))+': [ '+ToCard(((s)))+' ]');
                                    end;

                                end;
                                if deal.NodeName='communitycards' then begin
                                    ToCommonCards(deal.Attributes['value']);
                                    //cmn.commonCards;
                                    // !!! IMPORTANT Here should be fold storing
                                    s:=s+ ': ['+ss+' ]';
                                end;
                            end;
                        end;
                    end; // if (ChildNodes.Nodes[i].NodeName='dealcards') then begin

                    //===============
                    // EndRound - flop
                    if (ChildNodes.Nodes[i].NodeName='endround') then begin
                        endround:=ChildNodes.Nodes[i];
                        s:='';
                        if (cmn.pokerType>=1) and (cmn.pokerType<=3) then begin
                            if endRound.Attributes['round']=2 then  s:='FLOP';
                            if endRound.Attributes['round']=3 then  s:='TURN';
                            if endRound.Attributes['round']=4 then  s:='RIVER';
                            if endRound.Attributes['round']=5 then  s:='SUMMARY';
                        end
                        else begin
                            if endRound.Attributes['round']=1 then  s:='3th STREET';
                            if endRound.Attributes['round']=2 then  s:='4th STREET';
                            if endRound.Attributes['round']=3 then  s:='5th STREET';
                            if endRound.Attributes['round']=4 then  s:='6th STREET';
                            if endRound.Attributes['round']=5 then  s:='RIVER';
                        end;

                        s:=(Bold('*** '+s+' ***'));

                        if endround.HasChildNodes then begin
                            for j:=0 to endround.ChildNodes.Count-1 do begin
                                node:=endround.ChildNodes.Nodes[j];

                                ss:='';

                                if Length(cmn.commonCards)>0 then begin
                                    for k:=0 to length(cmn.commonCards)-1 do begin
                                        if (k = length(cmn.commonCards)-1) and (k > 2) then begin
                                            ss:=ss+' ] [ '+ToCard((cmn.commonCards[k]))+' ';
                                        end
                                        else begin
                                            ss:=ss+ToCard(('&nbsp;'+cmn.commonCards[k]+'&nbsp;'));
                                        end
                                    end;
                                    //cmn.commonCards;
                                    // !!! IMPORTANT Here should be fold storing
                                    if ss<>'' then begin
                                        s:=s+ ': ['+ss+' ]';
                                    end;
                                end;
                                {
                                if node.NodeName = 'communitycards' then begin
                                    ToCommonCards(node.Attributes['value']);
                                    for k:=0 to length(cmn.commonCards)-1 do begin
                                        if (k = length(cmn.commonCards)-1) and (k > 2) then begin
                                            ss:=ss+' ] [ '+ToCard((cmn.commonCards[k]))+' ';
                                        end
                                        else begin
                                            ss:=ss+ToCard((' '+cmn.commonCards[k]+' '));
                                        end
                                    end;
                                    //cmn.commonCards;
                                    // !!! IMPORTANT Here should be fold storing
                                    if ss<>'' then begin
                                        s:=s+ ': ['+ss+' ]';
                                    end;
                                end;
                                }

                                {
                                if node.NodeName = 'pots' then begin
                                    for k:=0 to node.ChildNodes.Count-1 do begin
                                        pot:=node.ChildNodes.nodes[k];
                                        if (length(cmn.pot) < k+1) then begin
                                            setLength(cmn.pot,length(cmn.pot)+1);
                                        end;
                                        cmn.pot[k]:=pot.Attributes['amount'];
                                    end;
                                end;
                                }

                                if node.NodeName = 'rake' then begin
                                    cmn.rake:=node.Attributes['amount'];
                                end;

                            end; // for j:=0 to endround.ChildNodes.Count-1 do begin
                        end; // if endround.HasChildNodes then begin

                        if (cmn.pokerType>=1)
                             and (cmn.pokerType<=3)
                             and (endRound.Attributes['round']<5) then begin
                            PrintLn(s);
                        end;
                        if  (cmn.pokerType>3)
                             and (endRound.Attributes['round']<6) then begin
                            PrintLn(s);
                        end;


                    end; // if (ChildNodes.Nodes[i].NodeName='endround') then begin

                    //===============
                    // Final Pot
                    if (ChildNodes.Nodes[i].NodeName='finalpot') then begin
                        finalpot := ChildNodes.Nodes[i];
                        if finalpot.HasChildNodes then begin
                            for k:=0 to finalpot.ChildNodes.Count-1 do begin
                                if finalpot.ChildNodes.Nodes[k].NodeName='winner' then begin
                                    winner:=finalpot.ChildNodes.Nodes[k];
                                    l:=winner.Attributes['position'];
                                    s:=(Green(usr[l].userName))+' bet '+Money(floattostr(usr[l].stake));
                                    s:=s+', collected '+Money(floattostr(winner.Attributes['amount']));
                                    usr[l].won:=usr[l].won+winner.Attributes['amount'];
                                    delta := usr[l].won - usr[l].stake;
                                    s:=s+', net ';
                                    if delta>0 then s:=s+'+';
                                    if delta<0 then s:=s+'-';
                                    s:=s+Money(floattostr(delta));
                                    s:=s +' '+ usr[l].lastAction;
                                    if pos('showed hand',usr[l].lastAction)>0 then begin
                                        if usr[l].rankingPhraseLo='' then begin
                                            if (cmn.pokerType=3) or (cmn.pokerType=5) then begin
                                                s:=s +'<br>Hi:&nbsp;'+usr[l].rankingPhrase;
                                            end
                                            else begin
                                                s:=s +'&nbsp;'+usr[l].rankingPhrase;
                                            end;
                                        end
                                        else begin
                                            s:=s +'<br>Hi:&nbsp;'+usr[l].rankingPhrase;
                                            s:=s +'<br>Lo:&nbsp;'+usr[l].rankingPhraseLo;
                                        end;
                                    end;
                                    usr[l].summary:=s;
                                    usr[l].iswinner:=1;
                                end; // if pot.ChildNodes.Nodes[k].NodeName='winner' then begin
                            end;
                        end;

                    end; // if (ChildNodes.Nodes[i].NodeName='finalpot') then begin


                    //===============
                    // Finishhand -
                    if (ChildNodes.Nodes[i].NodeName='finishhand') then begin
                        PRINTLN((Bold('*** SUMMARY *** '))+' '+Magenta(cmn.endDate));
                        //if endRound.Attributes['round']=5 then  s:='SUMMARY';
                        finishhand:=ChildNodes.Nodes[i];

                        {
                        if finishHand.HasChildNodes then begin
                            for j:=0 to finishHand.ChildNodes.Count-1 do begin
                                pot:=finishHand.ChildNodes.Nodes[j];
                                if pot.HasChildNodes then begin
                                    for k:=0 to pot.ChildNodes.Count-1 do begin
                                        if pot.ChildNodes.Nodes[k].NodeName='winner' then begin
                                            winner:=pot.ChildNodes.Nodes[k];
                                            l:=winner.Attributes['position'];
                                            s:=(Green(usr[l].userName))+' bet '+Money(floattostr(usr[l].stake));
                                            s:=s+', collected '+Money(floattostr(winner.Attributes['amount']));
                                            usr[l].won:=usr[l].won+winner.Attributes['amount'];
                                            delta := usr[l].won - usr[l].stake;
                                            s:=s+', net ';
                                            if delta>0 then s:=s+'+';
                                            if delta<0 then s:=s+'-';
                                            s:=s+Money(floattostr(delta));
                                            s:=s +' '+ usr[l].lastAction;
                                            if pos('showed hand',usr[l].lastAction)>0 then begin
                                                if usr[l].rankingPhraseLo='' then begin
                                                    if (cmn.pokerType=3) or (cmn.pokerType=5) then begin
                                                        s:=s +'<br>Hi:&nbsp;'+usr[l].rankingPhrase;
                                                    end
                                                    else begin
                                                        s:=s +'&nbsp;'+usr[l].rankingPhrase;
                                                    end;
                                                end
                                                else begin
                                                    s:=s +'<br>Hi:&nbsp;'+usr[l].rankingPhrase;
                                                    s:=s +'<br>Lo:&nbsp;'+usr[l].rankingPhraseLo;
                                                end;
                                            end;
                                            usr[l].summary:=s;
                                            usr[l].iswinner:=1;
                                        end; // if pot.ChildNodes.Nodes[k].NodeName='winner' then begin
                                    end;
                                end;
                            end;
                        end; //if finishHand.HasChildNodes then begin
                        }

                        // Prepare result set
                        for k:=0 to length(usr)-1 do begin
                            if (usr[k].userId<>0) and (usr[k].isWinner=0) then begin
                                if usr[k].stake>0 then begin
                                    s:=' lost '+Money(floattostr(usr[k].stake));
                                end
                                else begin
                                    s:=' didn''t bet' ;
                                end;
                                    usr[k].summary:=(Green(usr[k].userName))
                                                    +s
                                                    +' '+(usr[k].lastaction);
                                    if pos('showed hand',usr[k].lastAction)>0 then begin
                                        if usr[k].rankingPhraseLo='' then begin
                                            if (cmn.pokerType=3) or (cmn.pokerType=5) then begin
                                                usr[k].summary:=usr[k].summary +'<br>Hi:&nbsp;'+usr[k].rankingPhrase;
                                            end
                                            else begin
                                                usr[k].summary:=usr[k].summary +' '+usr[k].rankingPhrase;
                                            end;
                                        end
                                        else begin
                                            usr[k].summary:=usr[k].summary +'<br>Hi:&nbsp;'+usr[k].rankingPhrase;
                                            usr[k].summary:=usr[k].summary +'<br>Lo:&nbsp;'+usr[k].rankingPhraseLo+'<br>';
                                        end;


                                    end;
                                    if (pos('fold',usr[k].lastAction)>0) and (cmn.pokerType>3) then begin
                                        usr[k].summary:=usr[k].summary +' [ '+ToCard(usr[k].cards)+' ]';
                                    end;
                            end;
                        end;

                    end; // if (ChildNodes.Nodes[i].NodeName='finishhand') then begin

                    i:=i+1; // Next step

                end; // while i<=ChildNodes.Count-1 do begin
            end; // if HasChildNodes then begin
        end; // with root do begin



        // 3. Show Total
        for i:=0 to length(cmn.Pot)-1 do begin
            Log('POT:::'+floattostr(cmn.Pot[i]));
            if i=0 then s:='Pot:' else s:='Side Pot '+inttostr(i)+' :';
            s:=s+Money((floattostr(cmn.Pot[i])));
            if i=0 then s:=s+' | Rake: '+Money((floattostr(cmn.rake)));
            PrintLn(s);
        end;

        s:='';
        for i:=0 to length(cmn.commonCards)-1 do begin
            s:=s+' '+cmn.commonCards[i]+' ';
        end;
        PrintLn('Board: ['+((toCard(s)))+']');

        for i:=0 to length(usr)-1 do begin
            if usr[i].userId<>0 then begin
                PrintLn(usr[i].summary);
            end;
        end;

    except
        on E:Exception do begin
            result:=AP_ERR_CANNOTMAKEPROCESSSTRINGINFO;
            exit;
        end;
    end; // main try

    data:=output;
    //data := '<font face="Helvetica" size="2">'+output+'</font>';

    Log('=======================================================');
    Log('REQUESTED HAND HISTORY');
    Log('-------------------------------------------------------');
    Log(data);
    Log('=======================================================');

    hist:=nil;
    result := PO_NOERRORS;

end;

function TAPI.GetProcessInfo(ProcessID: Integer; var EngineID,
  GroupID: Integer; var ProcessName, Password: String;
  var IsWatchingAllowed: Integer;
  var CurrencyTypeID: Integer;
  var ProtectedMode: Integer;
  var IsHighlighted: Integer
): Integer;
var
  errCode: Integer;
  FSql: TSQLAdapter;
begin

  EngineId:=0;
  ProcessName:='';
  currencyTypeId:=0;
  Result:=PO_NOERRORS;

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiGetGameProcessInfo');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('processId',ProcessId,ptInput,ftInteger);
    FSql.addparam('engineId',engineId,ptOutput,ftInteger);
    FSql.addparam('processName',processName,ptOutput,ftString);
    FSql.addparam('Password', Password, ptOutput, ftString);
    FSql.addparam('IsWatchingAllowed', IsWatchingAllowed, ptOutput, ftInteger);
    FSql.addparam('currencyTypeId',currencyTypeId,ptOutput,ftInteger);
    FSql.addparam('groupid',0,ptOutput,ftInteger);
    FSql.addparam('subcategoryid',0,ptOutput,ftInteger);
    FSql.addparam('ProtectedMode',0,ptOutput,ftInteger);
    FSql.addparam('IsHighlighted',0,ptOutput,ftInteger);
    FSql.executecommand();
    engineID       := FSql.Getparam('engineId');
    groupID        := FSql.Getparam('groupId');
    processName    := FSql.Getparam('processName');
    Password       := FSql.Getparam('Password');
    IsWatchingAllowed := FSql.Getparam('IsWatchingAllowed');
    currencyTypeId := FSql.Getparam('currencyTypeId');
    ProtectedMode  := FSql.Getparam('ProtectedMode');
    IsHighlighted  := FSql.Getparam('IsHighlighted');
    errCode := FSql.Getparam('RETURN_VALUE');
    if errCode<>PO_NOERRORS then begin
      CommonDataModule.Log(ClassName, 'GetProcessInfo',
        '[ERROR] On exec apiGetGameProcessInfo Result=' + IntToStr(errCode) +
        '; Params: ProcessId=' + IntToStr(ProcessId),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_CANNOTGETPROCESSINFO;
      exit;
    end;
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'GetProcessInfo',
        '[EXCEPTION] On exec apiGetGameProcessInfo:' + e.Message +
        '; Params: ProcessID=' + IntToStr(ProcessID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_CANNOTGETPROCESSINFO;
      exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
end;

function TAPI.GetState(ProcessID, StateNumber: Integer; var Data: String): Integer;
var
  FSQL: TSQLAdapter;
  sSQL: String;
  RS: TDataSet;
begin
  Data := '';
  try
    FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      if stateNumber <> 1 then
        sSQL := 'select data from gameProcessInfo (nolock) where gameProcessId=' +
          inttostr(ProcessId)
      else
        sSQL := 'select data from gameProcessState (nolock) where gameProcessId=' +
          inttostr(ProcessId);

      RS := FSql.Execute(sSQL);
      RS.First;
      while not RS.Eof do
      begin
        Data := Data + RS.FieldByName('data').AsString;
        RS.Next;
      end;

      Data := DecodeBase64(Data);
      Result := PO_NOERRORS;
    finally
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
    end;
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'GetState', E.Message, ltException);
      Result := AP_ERR_CANNOTGETGAMESTATE;
    end;
  end;
end;

function TAPI.GetStats(ProcessID, StatsTypeID: Integer; var Value: String): Integer;
var
  FSql: TSQLAdapter;
  errCode: Integer;
begin

  Result:=PO_NOERRORS;
  Value :='';

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiGetGameProcessStatsByType');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('processId',ProcessId,ptInput,ftInteger);
    FSql.addparam('statsTypeId',statsTypeId,ptInput,ftInteger);
    FSql.addparam('value',Value,ptOutput,ftString);
    FSql.executecommand();
    Value := FSql.Getparam('value');

  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'GetStats',
        '[EXCEPTION] On exec apiGetGameProcessStatsByType:' + e.Message +
        '; Params: ProcessID=' + IntToStr(ProcessID) +
        ', statsTypeId=' + IntToStr(StatsTypeID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_CANNOTGETGAMESTATS;
      exit;
    end;
  end;

  errCode := FSql.Getparam('RETURN_VALUE');
  if errCode<>PO_NOERRORS then begin // if not ok
    CommonDataModule.Log(ClassName, 'GetStats',
      '[ERROR] On exec apiGetGameProcessStatsByType Result=' + IntToStr(errCode) +
      '; Params: ProcessID=' + IntToStr(ProcessID) +
      ', statsTypeId=' + IntToStr(StatsTypeID),
      ltError
    );

    result := AP_ERR_GAMESTATSNOTFOUND;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

end;

function TAPI.GetUserBalance(SessionID, UserID, CurrencyTypeID: Integer;
  var Amount: Currency): Integer;
var
  FAcc: TAccount;
begin
  {$IFDEF DEADACCOUNT}
  // ***********************
  // ** DEAD DUMMY
  // ***********************
  result:=0;
  amount:=10000000;
  exit;
  // ***********************
  // ** DEAD DUMMY
  // ***********************
  {$ENDIF}

  FAcc := CommonDataModule.ObjectPool.GetAccount;
  result := FAcc.GetUserCurrencyBalance(SessionID, UserID, CurrencyTypeID, Amount);
  CommonDataModule.ObjectPool.FreeAccount(FAcc);

  if Result <> PO_NOERRORS then begin
    CommonDataModule.Log(ClassName, 'GetUserBalance',
      '[ERROR] On exec acc.GetUserCurrencyBalance Result=' + IntToStr(Result) +
      '; Params: UserID=' + IntToStr(UserID) +
      ', SessionID=' + IntToStr(SessionID) +
      ', CurrencyTypeID=' + IntToStr(CurrencyTypeID),
      ltCall
    );
  end;

end;

function TAPI.GetUserInfo(UserID: Integer; var UserName, City: String;
  var SexID, AvatarID, ImageVersion, SessionID: Integer; var ChatAllow: Boolean;
  var AffiliateID: Integer; var IsEmailValidated: Boolean;
  var LevelID: Integer; var Icon1, Icon2, Icon3, Icon4: string
): Integer;
var
  errCode : integer;
  FSql: TSQLAdapter;
  nChatAllow: Integer;
  nIsEmailValidated: Integer;
begin

//    userId:=0;
  userName:='';
  city:='';
  Icon1 := '';
  Icon2 := '';
  Icon3 := '';
  Icon4 := '';

  Result:=PO_NOERRORS;

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiGetUserInfo');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('userId',userId,ptInput,ftInteger);
    FSql.addparam('userName',userName,ptOutput,ftString);
    FSql.addparam('city',city,ptOutput,ftString);
    FSql.addparam('sexId',sexId,ptOutput,ftInteger);
    FSql.addparam('avatarId',sexId,ptOutput,ftInteger);
    FSql.addparam('ImageVersion', ImageVersion, ptOutput, ftInteger);
    FSql.addparam('sessionId',0,ptOutput,ftInteger);
    FSql.addparam('ClientAdapterIP','',ptOutput,ftString);
    FSql.addparam('ChatAllow',0,ptOutput,ftInteger);
    FSql.addparam('AffiliateID',0,ptOutput,ftInteger);
    FSql.addparam('IsEmailValidated',0,ptOutput,ftInteger);
    FSql.addparam('LevelID',0,ptOutput,ftInteger);

    FSql.executecommand();
    errCode        := FSql.Getparam('RETURN_VALUE');
    if errCode<>PO_NOERRORS then begin // participant is not logged on
      CommonDataModule.Log(ClassName, 'GetUserInfo',
        '[ERROR] On exec apiGetUserInfo Result=' + IntToStr(errCode) +
        '; Params: UserID=' + IntToStr(UserID),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result:= AP_ERR_USERNOTFOUND;
      exit;
    end;

    userName       := FSql.Getparam('username');
    city           := FSql.Getparam('city');
    sexID          := FSql.Getparam('sexId');
    avatarID       := FSql.Getparam('avatarId');
    ImageVersion   := FSql.Getparam('ImageVersion');
    SessionId      := FSql.Getparam('sessionId');
    nChatAllow     := FSql.Getparam('ChatAllow');
    AffiliateID   := FSql.Getparam('AffiliateID');
    nIsEmailValidated := FSql.Getparam('IsEmailValidated');
    LevelID        := FSql.Getparam('LevelID');

    if nChatAllow > 0 then ChatAllow := True else ChatAllow := False;
    if nIsEmailValidated > 0 then IsEmailValidated := True else IsEmailValidated := False;

  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'GetUserInfo',
        '[EXCEPTION] On exec apiGetUserInfo:' + e.Message +
        '; Params: UserID=' + IntToStr(UserID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_USERNOTFOUND;
      exit;
    end;
  end;

  GetUserIcons(UserID, FSql, Icon1, Icon2, Icon3, Icon4);

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
end;

function TAPI.GetUserSession(UserID: Integer;
  var theSessionID: Integer): Integer;
var
  errCode : integer;
  FSql: TSQLAdapter;
begin
  theSessionID:=0;
  Result:=PO_NOERRORS;

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiGetUserSession');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('userId',userId,ptInput,ftInteger);
    FSql.addparam('sessionId',theSessionId,ptOutput,ftInteger);
    FSql.addparam('ClientAdapterIP','',ptOutput,ftString);
    FSql.executecommand();
    errCode := FSql.Getparam('RETURN_VALUE');
    if errCode<>PO_NOERRORS then begin // participant is not logged on
      CommonDataModule.Log(ClassName, 'GetUserSession',
        '[ERROR] On exec apiGetUserSession Result=' + IntToStr(errCode) +
        '; Params: UserID=' + IntToStr(UserID),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result:= PO_NOERRORS;
      thesessionId:=0;
      exit;
    end;

    theSessionID := FSql.Getparam('SessionId');

  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'GetUserSession',
        '[EXCEPTION] On exec apiGetUserSession:' + e.Message +
        '; Params: UserID=' + IntToStr(UserID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_CANNOTGETUSERSESSION;
      exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  CommonDataModule.Log(ClassName, 'GetUserSession',
    'UserID=' + inttostr(UserID) + ' -> SessionID=' + inttostr(theSessionID), ltCall);
end;

function TAPI.GetWaitersCount(ProcessID: Integer;
  var WaitersCount: Integer): Integer;
var
  FSql: TSQLAdapter;
  errCode: Integer;
begin
  Result:=PO_NOERRORS;
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    waiterscount := 0;
    FSql.SetProcName('apiGetGameProcessWaitersCount');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('processId',ProcessId,ptInput,ftInteger);
    FSql.addparam('waiterscount',0,ptOutput,ftInteger);
    FSql.executecommand();
    waiterscount := FSql.Getparam('waiterscount');
    errCode := FSql.Getparam('RETURN_VALUE');
    if errCode<>PO_NOERRORS then begin
      CommonDataModule.Log(ClassName, 'GetWaitersCount',
        '[ERROR] On exec apiGetGameProcessWaitersCount Result=' + IntToStr(errCode) +
        '; Params: ProcessId=' + IntToStr(ProcessId),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      waiterscount:=0;
      result := AP_ERR_CANNOTGETWAITERSCOUNT;
      exit;
    end;
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'GetWaitersCount',
        '[EXCEPTION] On exec apiGetGameProcessWaitersCount:' + e.Message +
        '; Params: ProcessId=' + IntToStr(ProcessId),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      waiterscount:=0;
      result := AP_ERR_CANNOTGETWAITERSCOUNT;
      exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
end;

function TAPI.HandResult(ProcessID, HandID: Integer; var Comment,
  Data: String): Integer;
var
  FAcc: TAccount;
begin

  {$IFDEF DEADACCOUNT}
  // ***********************
  // ** DEAD DUMMY
  // ***********************
  result:=0;
  exit;
  // ***********************
  // ** DEAD DUMMY
  // ***********************
  {$ENDIF}

  FAcc := CommonDataModule.ObjectPool.GetAccount;
  Result := FAcc.HandResult(processId, handId, comment, data);
  CommonDataModule.ObjectPool.FreeAccount(FAcc);

  if Result <> PO_NOERRORS then begin
    CommonDataModule.Log(ClassName, 'HandResult',
      '[ERROR] On exec FAcc.HandResult Result=' + IntToStr(Result) +
      '; Params: processId=' + IntToStr(processId) +
      ', handId=' + IntToStr(handId) +
      ', comment=' + comment +
      ', data=' + data,
      ltError
    );
  end;
end;

function TAPI.InitProcess(ProcessID: Integer): Integer;
var
  aSQL                  : string;
  EngineComName         : string;
  //engine                : variant;
  rs                    : TDataSet;
  SettingsXML           : String;
  GameConnector         : TGameConnector;
  sql: TSQLAdapter;
  respreas: string;
begin

  sql := CommonDataModule.ObjectPool.GetSQLAdapter;

  //=====================
  // get Process Info
  try
    aSQL := 'exec apiGetProcessInfoForInitialization '+inttostr(processId);
    rs := sql.Execute(aSQL);
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'InitProcess',
        '[EXCEPTION] On exec apiGetProcessInfoForInitialization:' + e.Message +
        '; Params: processId=' + IntToStr(ProcessID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
      result := AP_ERR_CANNOTINITGAMEPROCESS;
      exit; // if exception when executing
    end;
  end;

  rs.First;
  if not rs.Eof then begin
    EngineComName:= string(rs.FieldValues[ 'ComName' ]);
    SettingsXML:= string(rs.FieldValues[ 'SettingsXML' ]);
  end
  else begin
    CommonDataModule.Log(ClassName, 'InitProcess',
      '[ERROR]: Game process not found' +
      '; Params: processId=' + IntToStr(ProcessID),
      ltError
    );

    CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
    result := AP_ERR_CANNOTINITGAMEPROCESS;
    exit; // if exception when executing
  end;

  //=====================
  // clear all participants from process
  try
    aSQL := 'Delete From [Location] Where ([GameProcessID] = ' + inttostr(processId) + ')';
    sql.Execute(aSQL);
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'InitProcess',
        '[EXCEPTION] On ' + aSQL + ': ' + e.Message +
        '; Params: processId=' + IntToStr(ProcessID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
      result := AP_ERR_CANNOTINITGAMEPROCESS;
      exit; // if exception when executing
    end;
  end;

  // clear WaitingList from process
  try
    aSQL := 'Delete From [WaitingList] Where ([GameProcessID] = ' + inttostr(processId) + ')';
    sql.Execute(aSQL);
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'InitProcess',
        '[EXCEPTION] On ' + aSQL + ': ' + e.Message +
        '; Params: processId=' + IntToStr(ProcessID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
      result := AP_ERR_CANNOTINITGAMEPROCESS;
      exit; // if exception when executing
    end;
  end;

  CommonDataModule.ObjectPool.FreeSQLAdapter(sql);

  // provide packet to the game engine
  GameConnector := TGameConnector.Create;

  // try Init Game process
  result := GameConnector.InitGameProcess(processId, SettingsXML, respreas);
  GameConnector.Free;

end;

function TAPI.LogActivity(ProcessID, SwitchHand, HandID, theSessionID,
  UserID: Integer; ActivityXML, BehaviourXML: String): Integer;
var
  aSQL     : string;
  rplFlags : TReplaceFlags;
  sql: TSQLAdapter;
begin

  Result:=PO_NOERRORS;
  sql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    rplFlags:=[rfReplaceAll];
    aSQL := 'insert into processActivityLog ';
    aSQL := aSQL + '(processId,startHand,handId,sessionId,userId,activityXML,behaviourXML) ';
    aSQL := aSQL + 'values (';
    aSQL := aSQL + inttostr(ProcessId) + ',';
    aSQL := aSQL + inttostr(SwitchHand) + ',';
    aSQL := aSQL + inttostr(HandId) + ',';
    aSQL := aSQL + inttostr(theSessionId) + ',';
    if UserId=0 then begin
        aSQL := aSQL + 'null,';
    end
    else begin
        aSQL := aSQL + inttostr(UserId) + ',';
    end;
    aSQL := aSQL + '''' + StringReplace(activityXML,'''','''''',rplFlags) + ''',';
    aSQL := aSQL + '''' + StringReplace(behaviourXML,'''','''''',rplFlags) + ''')';

    ////log(aSQL);

    sql.Execute(aSQL);

  except
    on E:Exception do begin
      result := AP_ERR_CANNOTLOGACTIVITY;
      CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
      exit;
    end;
  end;

  CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
end;

function TAPI.RegisterAtWaitingList(UserID, ProcessID, GroupID,
  PlayersCount: Integer; var ParticipantCount: Integer): Integer;
var
  errCode : integer;
  sql: TSQLAdapter;

  function GetErrorCode(sqlErrorResult: Integer): Integer;
  begin
    case sqlErrorResult of
       1: Result := AP_ERR_ALLREADYRESERVED_BYPROCESS_ONWAITINGLIST;
       2: Result := AP_ERR_ALLREADYGAMER_BYPROCESS_ONWAITINGLIST;
       3: Result := AP_ERR_MAXIMUM_MEMBERS_IS_OCCURED_ATWAITINGLIST;
      10: Result := AP_ERR_ALLREADYRESERVED_BYGROUP_ONWAITINGLIST;
      20: Result := AP_ERR_ALLREADYGAMER_BYGROUP_ONWAITINGLIST;
    else
      Result := AP_ERR_CANNOTREGISTERATWAITINGLIST;
    end;
  end;

begin

  Result:=PO_NOERRORS;
//  Exit;

  sql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    sql.SetProcName('apiRegisterAtWaitingList');
    sql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    sql.addparam('userId',userId,ptInput,ftInteger);
    sql.addparam('processId',processId,ptInput,ftInteger);
    sql.addparam('groupId',groupId,ptInput,ftInteger);
    sql.addparam('playersCount',playersCount,ptInput,ftInteger);
    sql.addparam('participantCount',0,ptOutput,ftInteger);
    sql.executecommand();
    errCode        := sql.Getparam('RETURN_VALUE');
    participantCount :=  sql.Getparam('participantCount');
    if errCode<>PO_NOERRORS then begin // participant is not logged on
      CommonDataModule.Log(ClassName, 'RegisterAtWaitingList',
        '[ERROR] On exec apiRegisterAtWaitingList:  Result=' + IntToStr(errCode) +
        '; Params: userId=' + IntToStr(UserID) +
        ', processId=' + IntToStr(ProcessID) +
        ', groupId=' + IntToStr(GroupID),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
      result:= GetErrorCode(errCode);
      exit;
    end;
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'RegisterAtWaitingList',
        '[EXCEPTION] On exec apiRegisterAtWaitingList:' + e.Message +
        '; Params: userId=' + IntToStr(UserID) +
        ', processId=' + IntToStr(ProcessID) +
        ', groupId=' + IntToStr(GroupID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
      result:= AP_ERR_CANNOTREGISTERATWAITINGLIST;
      exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
end;

function TAPI.RegisterParticipant(ProcessID, theSessionID, theUserId,
  placeNumber: Integer): Integer;
var
  FSql: TSQLAdapter;
  errCode: Integer;
begin
  Result:=PO_NOERRORS;
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiRegisterParticipant');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('processId',ProcessId,ptInput,ftInteger);
    FSql.addparam('sessionId',theSessionId,ptInput,ftInteger);
    FSql.addparam('placeNumber',placenumber,ptInput,ftInteger);
    FSql.executecommand();
    errCode := FSql.Getparam('RETURN_VALUE');
    if errCode<>PO_NOERRORS then begin
      CommonDataModule.Log(ClassName, 'RegisterParticipant',
        '[ERROR] On exec apiRegisterParticipant Result=' + IntToStr(errCode) +
        '; Params: ProcessID=' + IntToStr(ProcessID) +
        ', theSessionId=' + IntToStr(theSessionId) +
        ', placenumber=' + IntToStr(placenumber),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_CANNOTATTACHPARTICIPANTTOTHEPROCESS;
      exit;
    end;
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'RegisterParticipant',
        '[EXCEPTION] On exec apiRegisterParticipant:' + e.Message +
        '; Params: ProcessID=' + IntToStr(ProcessID) +
        ', theSessionId=' + IntToStr(theSessionId) +
        ', placenumber=' + IntToStr(placenumber),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_CANNOTATTACHPARTICIPANTTOTHEPROCESS;
      exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
end;

function TAPI.RemoveRemind(RemindID: String): Integer;
begin
  result:=PO_NOERRORS;
  if not SendRemindAction ( SC_REMOVEREMIND
                          , 0 // dummy value
                          , 0 // dummy value
                          , 0 // dummy value
                          , RemindId
                          , '' // dummy value
                          ) then begin
    result:=SC_ERR_CANNOTREMOVEREMIND;
    exit;
  end;
end;

function TAPI.ReserveForTournament(ProcessID: Integer;
  var Data: String): Integer;
var
  FAcc: TAccount;
begin

  FAcc := CommonDataModule.ObjectPool.GetAccount;
  Result := FAcc.ReservForTournament(ProcessID, Data);
  CommonDataModule.ObjectPool.FreeAccount(FAcc);

  if Result <> PO_NOERRORS then begin
    CommonDataModule.Log(ClassName, 'ReservForTournament',
      '[ERROR] On exec FAcc.ReservForTournament Result=' + IntToStr(Result) +
      '; Params: processId=' + IntToStr(processId) +
      ', data=' + Data,
      ltCall
    );
  end;
end;

function TAPI.GetReservedAmount(SessionID, GameProcessID, UserID: Integer;
  var Amount: Currency): Integer;
var
  FAcc: TAccount;
begin
  Facc := CommonDataModule.ObjectPool.GetAccount;
  Result := Facc.GetReservedAmount(SessionID, UserID, GameProcessID, Amount);
  CommonDataModule.ObjectPool.FreeAccount(FAcc);
end;

function TAPI.ReserveMoney(SessionID, ProcessID, UserID: Integer;
  Amount: Currency; var NewReserve, NewAmount: Currency): Integer;
var
  FAcc: TAccount;
begin

  {$IFDEF DEADACCOUNT}
  // ***********************
  // ** DEAD DUMMY
  // ***********************
  result:=0;
  NEWRESERVE:=1000;
  NEWAMOUNT:=10000000;
  exit;
  // ***********************
  // ** DEAD DUMMY
  // ***********************
  {$ENDIF}

  FAcc := CommonDataModule.ObjectPool.GetAccount;
  Result := FAcc.ReservAmount(SessionId, userid, processid, amount, newAmount, newReserve);
  CommonDataModule.ObjectPool.FreeAccount(FAcc);
end;

function TAPI.ResetRemind(RemindTime: TDateTime;
  RemindID: String): Integer;
begin
  result:=PO_NOERRORS;
  if not SendRemindAction ( SC_RESETREMIND
                          , 0 // dummy value
                          , 0 // dummy value
                          , RemindTime
                          , RemindId
                          , '' // dummy value
                          ) then begin
    result:=SC_ERR_CANNOTRESETREMIND;
    exit;
  end;
end;

function TAPI.ReturnToWaitingListAndUnlock(UserID, ProcessID,
  GroupID: Integer; var ParticipantCount: Integer): Integer;
var
  errCode : integer;
  sql: TSQLAdapter;
begin

  Result:=PO_NOERRORS;
  sql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    sql.SetProcName('apiReturnToWaitingListAndUnlock');
    sql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    sql.addparam('userId',userId,ptInput,ftInteger);
    sql.addparam('processId',processId,ptInput,ftInteger);
    sql.addparam('groupId',groupId,ptInput,ftInteger);
    sql.addparam('participantCount',0,ptOutput,ftInteger);
    sql.executecommand();
    errCode        := sql.Getparam('RETURN_VALUE');
    participantCount :=  sql.Getparam('participantCount');
    if errCode<>PO_NOERRORS then begin // participant is not logged on
      CommonDataModule.Log(ClassName, 'ReturnToWaitingListAndUnlock',
        '[ERROR] On exec apiReturnToWaitingListAndUnlock:  Result=' + IntToStr(errCode) +
        '; Params: userId=' + IntToStr(UserID) +
        ', processId=' + IntToStr(ProcessID) +
        ', groupId=' + IntToStr(GroupID),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
      result:= AP_ERR_CANNOTRETURNTOWAITINGLISTANDUNLOCK;
      exit;
    end;
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'ReturnToWaitingListAndUnlock',
        '[EXCEPTION] On exec apiReturnToWaitingListAndUnlock:' + e.Message +
        '; Params: userId=' + IntToStr(UserID) +
        ', processId=' + IntToStr(ProcessID) +
        ', groupId=' + IntToStr(GroupID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
      result:= AP_ERR_CANNOTRETURNTOWAITINGLISTANDUNLOCK;
      exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
end;

function TAPI.RollBackTransaction: Integer;
var
  FSql: TSQLAdapter;
begin
  result := PO_NOERRORS;
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.RollbackTrans;
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'RollBackTransaction',
        '[EXCEPTION] On exec FSql.RollbackTrans:' + e.Message,
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result:=PO_ERR_SQLADAPTORINSTANCEFAIL;
      Exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
end;

function TAPI.SetParticipantCount(ProcessID, ActiveUsersCount,
  PassiveUsersCount: Integer): Integer;
var
  EmptyGroupTablesCount : integer;
  TargetProcessID: Integer;
  FSql: TSQLAdapter;
  errCode: Integer;
begin

  Result:=PO_NOERRORS;

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiSetParticipantCount');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('processId',ProcessId,ptInput,ftInteger);
    FSql.addparam('activeUsersCount',activeUsersCount,ptInput,ftInteger);
    FSql.addparam('passiveUsersCount',passiveUsersCount,ptInput,ftInteger);
    FSql.addparam('emptyGroupTablesCount',0,ptOutput,ftInteger);
    FSql.executecommand();
    EmptyGroupTablesCount := FSql.Getparam('emptyGroupTablesCount');
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'SetParticipantCount',
        '[EXCEPTION] On exec apiSetParticipantCount:' + e.Message +
        '; Params: ProcessID=' + IntToStr(ProcessID) +
        ', activeUsersCount=' + IntToStr(ActiveUsersCount) +
        ', passiveUsersCount=' + IntToStr(PassiveUsersCount),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_CANNOTSETPARTICIPANTCOUNT;
      exit;
    end;
  end;

  errCode := FSql.Getparam('RETURN_VALUE');
  if errCode<>PO_NOERRORS then begin // if not ok
    CommonDataModule.Log(ClassName, 'SetParticipantCount',
      '[ERROR] On exec apiSetParticipantCount Result=' + IntToStr(errCode) +
      '; Params: ProcessID=' + IntToStr(ProcessID) +
      ', activeUsersCount=' + IntToStr(ActiveUsersCount) +
      ', passiveUsersCount=' + IntToStr(PassiveUsersCount),
      ltError
    );

    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
    result := AP_ERR_CANNOTSETPARTICIPANTCOUNT;
    exit;
  end;

  if EmptyGroupTablesCount = 0 then
    CloneProcess(processId, TargetProcessID);

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
end;

function TAPI.SetState(ProcessID, StateNumber: Integer; const Data: String): Integer;
var
  FSql: TSQLAdapter;
  sSQL: String;
begin

    try
    FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
      try // save state info
        if stateNumber = 1 then
          sSQL := 'update gameProcessState set [data]=''' + EncodeBase64(Data) +
            ''' where gameProcessId=' + inttostr(ProcessId)
        else
          sSQL := 'update gameProcessInfo set [data]=''' + EncodeBase64(Data) +
            ''' where gameProcessId=' + inttostr(ProcessId);

        FSQL.Execute(sSQL);
        Result := PO_NOERRORS;
      finally
        CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      end;
    except
      on E:Exception do begin
        CommonDataModule.Log(ClassName, 'SetState',E.Message, ltException);
        result := AP_ERR_CANNOTSAVEGAMESTATE;
      end;
    end;

end;

function TAPI.SetStateID(StateID: Integer; var Data: String): Integer;
begin
  Data := '';
  result := AP_ERR_METHODDONTSUPPORT;
end;

function TAPI.SetStateNumber(StateNumber: String): Integer;
begin
  StateNum:=StateNumber;
  result := 0;
end;

function TAPI.SetStats(ProcessID, StatsTypeID: Integer; Value: String): Integer;
var
  FSql: TSQLAdapter;
  errCode: Integer;
begin
  Result:=PO_NOERRORS;


    FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      FSql.SetProcName('apiSetGameProcessStatsByType');
      FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
      FSql.addparam('processId',ProcessId,ptInput,ftInteger);
      FSql.addparam('statsTypeId',statsTypeId,ptInput,ftInteger);
      FSql.addparam('value',Value,ptInput,ftString);
      FSql.executecommand();
    except
      on E:Exception do begin
        CommonDataModule.Log(ClassName, 'SetStats',
          '[EXCEPTION] On exec apiSetGameProcessStatsByType:' + e.Message +
          '; Params: ProcessID=' + IntToStr(ProcessID) +
          ', statsTypeId=' + IntToStr(statsTypeId) +
          ', Value=' + Value,
          ltException
        );

        CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
        result := AP_ERR_CANNOTSETGAMESTATS;
        exit;
      end;
    end;

    errCode := FSql.Getparam('RETURN_VALUE');
    if errCode<>PO_NOERRORS then begin // if not ok
      CommonDataModule.Log(ClassName, 'SetStats',
        '[ERROR] On exec apiSetGameProcessStatsByType Result=' + IntToStr(errCode) +
        '; Params: ProcessID=' + IntToStr(ProcessID) +
          ', statsTypeId=' + IntToStr(statsTypeId) +
          ', Value=' + Value,
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_CANNOTSETGAMESTATS;
      exit;
    end;

    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

end;

function TAPI.SetStatses(ProcessID: Integer; Value: String): Integer;
var
  doc          : IXMLDocument;
  root         : IXMLNode;
  node         : IXMLNode;
  i            : integer;
  StatsTypeId  : integer;
  StatsValue   : string;
  pp           : string;
  FSql: TSQLAdapter;
  errCode: Integer;
begin
  Result:=PO_NOERRORS;

    // analyse request
    try
      doc:=TXMLDocument.Create(nil);
      doc.Active:=false;
      doc.XML.Text:= Value;
      doc.Active:=true;
      root:=doc.DocumentElement;
    except
      on E:Exception do begin
        CommonDataModule.Log(ClassName, 'SetStatses',
          '[EXCEPTION] On Open handle XML:' + e.Message +
          '; Params: XML=' + Value,
          ltException
        );

        result := AP_ERR_CORRUPTREQUESTXML;
        doc:=nil;
        exit;
      end;
    end;

    //
    node:=root;

    pp:='';
    FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
    if node.HasChildNodes then begin
      for i:= 0 to node.ChildNodes.Count-1 do begin
        pp := pp + node.ChildNodes.Nodes[i].XML;
        statsTypeId := node.ChildNodes.Nodes[i].Attributes['id'];
        StatsValue := node.ChildNodes.Nodes[i].Attributes['value'];

        try
          FSql.SetProcName('apiSetGameProcessStatsByType');
          FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
          FSql.addparam('processId',ProcessId,ptInput,ftInteger);
          FSql.addparam('statsTypeId',StatsTypeId,ptInput,ftInteger);
          FSql.addparam('value',StatsValue,ptInput,ftString);
          FSql.executecommand();
          errCode := FSql.Getparam('RETURN_VALUE');
          if errCode<>PO_NOERRORS then begin // if not ok
            CommonDataModule.Log(ClassName, 'SetStatses',
              '[ERROR] On exec apiSetGameProcessStatsByType Result=' + IntToStr(errCode) +
              '; Params: ProcessID=' + IntToStr(ProcessID) +
                ', statsTypeId=' + IntToStr(statsTypeId) +
                ', Value=' + Value,
              ltError
            );

            CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
            result := AP_ERR_CANNOTSETGAMESTATS;
            doc:=nil;
            exit;
          end;

        except
          on E:Exception do begin
            CommonDataModule.Log(ClassName, 'SetStatses',
              '[EXCEPTION] On exec apiSetGameProcessStatsByType:' + e.Message +
              '; Params: ProcessID=' + IntToStr(ProcessID) +
                ', statsTypeId=' + IntToStr(statsTypeId) +
                ', Value=' + Value,
              ltException
            );

            CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
            result := AP_ERR_CANNOTSETGAMESTATS;
            doc:=nil;
            exit;
          end;
        end;
      end; // for
    end; // if

    doc:=nil;
    StatsValue := '';
    pp := '';
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
 
end;

function TAPI.SetGameType(ProcessID, GameTypeID, ChairsCount: Integer): Integer;
var
  FSql: TSQLAdapter;
  errCode: Integer;
begin
  Result:=PO_NOERRORS;
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiSetGameTypeIDToTheGameProcess');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('processId',ProcessID,ptInput,ftInteger);
    FSql.addparam('GameTypeID',GameTypeID,ptInput,ftInteger);
    FSql.addparam('ChairsCount',ChairsCount,ptInput,ftInteger);
    FSql.executecommand();
    errCode := FSql.Getparam('RETURN_VALUE');
    if errCode<>PO_NOERRORS then begin
      CommonDataModule.Log(ClassName, 'SetGameType',
        '[ERROR] On exec apiSetGameTypeIDToTheGameProcess Result=' + IntToStr(errCode) +
        '; Params: ProcessID=' + IntToStr(ProcessID) +
          ', GameTypeID=' + IntToStr(GameTypeID),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_CANNOTSETGAMETYPEID;
      exit;
    end;
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'RegisterParticipant',
        '[EXCEPTION] On exec apiAttachParticipantToTheGameProcess:' + e.Message +
        '; Params: ProcessID=' + IntToStr(ProcessID) +
          ', GameTypeID=' + IntToStr(GameTypeID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_CANNOTSETGAMETYPEID;
      exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
end;

function TAPI.StartHand(ProcessID: Integer; RandomFactor: String;
  var HandID: Integer): Integer;
var
  FSql: TSQLAdapter;
  errCode: Integer;
begin
  Result:=PO_NOERRORS;
  handId:=0;

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiStartHand');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('processId',processId,ptInput,ftInteger);
    FSql.addparam('randomFactor',RandomFactor,ptInput,ftString);
    FSql.addparam('handId',0,ptOutput,ftInteger);
    FSql.executecommand();
    errCode := FSql.Getparam('RETURN_VALUE');
    if errCode<>PO_NOERRORS then begin
      CommonDataModule.Log(ClassName, 'StartHand',
        '[ERROR] On exec apiStartHand Result=' + IntToStr(errCode) +
        '; Params: processId=' + IntToStr(ProcessID) +
        ', RandomFactor=' + RandomFactor,
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_CANNOTSTARTHAND;
      exit;
    end;
    handId:=FSql.Getparam('handId');
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'StartHand',
        '[EXCEPTION] On exec StartHand:' + e.Message +
        '; Params: processId=' + IntToStr(ProcessID) +
        ', RandomFactor=' + RandomFactor,
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_CANNOTSTARTHAND;
      exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
end;

function TAPI.TournamentPrize(ProcessID: Integer;
  var Data: String): Integer;
var
  FAcc: TAccount;
begin

  FAcc := CommonDataModule.ObjectPool.GetAccount;
  Result := FAcc.TournamentPrize(ProcessID, Data);
  CommonDataModule.ObjectPool.FreeAccount(FAcc);

  if Result <> PO_NOERRORS then begin
    CommonDataModule.Log(ClassName, 'TournamentPrize',
      '[ERROR] On exec FAcc.TournamentPrize Result=' + IntToStr(Result) +
      '; Params: processId=' + IntToStr(processId) +
      ', data=' + Data,
      ltCall
    );
  end;
end;

function TAPI.UnregisterFromWaitingList(UserID, ProcessID,
  GroupID: Integer; var ParticipantCount: Integer): Integer;
var
  errCode : integer;
  sql: TSQLAdapter;
begin

  Result:=PO_NOERRORS;
  sql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    sql.SetProcName('apiUnregisterFromWaitingList');
    sql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    sql.addparam('userId',userId,ptInput,ftInteger);
    sql.addparam('processId',processId,ptInput,ftInteger);
    sql.addparam('groupId',groupId,ptInput,ftInteger);
    sql.addparam('participantCount',0,ptOutput,ftInteger);
    sql.executecommand();
    errCode        := sql.Getparam('RETURN_VALUE');
    participantCount :=  sql.Getparam('participantCount');
    if errCode<>PO_NOERRORS then begin // participant is not logged on
      CommonDataModule.Log(ClassName, 'UnregisterFromWaitingList',
        '[ERROR] On exec apiUnregisterFromWaitingList:  Result=' + IntToStr(errCode) +
        '; Params: userId=' + IntToStr(UserID) +
        ', processId=' + IntToStr(ProcessID) +
        ', groupId=' + IntToStr(GroupID),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
      result:= AP_ERR_CANNOTUNREGISTERFROMWAITINGLIST;
      exit;
    end;
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'UnregisterFromWaitingList',
        '[EXCEPTION] On exec apiUnregisterFromWaitingList:' + e.Message +
        '; Params: userId=' + IntToStr(UserID) +
        ', processId=' + IntToStr(ProcessID) +
        ', groupId=' + IntToStr(GroupID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
      result:= AP_ERR_CANNOTUNREGISTERFROMWAITINGLIST;
      exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
end;

function TAPI.UnRegisterParticipant(ProcessID, theSessionID, theUserId,
  placeNumber: Integer): Integer;
var
  FSql: TSQLAdapter;
  ErrCode: Integer;
begin
  Result:=PO_NOERRORS;
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;

  try
    FSql.SetProcName('apiUnRegisterParticipant');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('processId',ProcessId,ptInput,ftInteger);
    FSql.addparam('sessionId',theSessionId,ptInput,ftInteger);
    FSql.addparam('userId',theUserId,ptInput,ftInteger);
    FSql.executecommand();
    ErrCode := FSql.Getparam('RETURN_VALUE');
    if ErrCode<>PO_NOERRORS then begin
      CommonDataModule.Log(ClassName, 'UnRegisterParticipant',
        '[ERROR] On exec apiUnRegisterParticipant Result=' + IntToStr(errCode) +
        '; Params: ProcessID=' + IntToStr(ProcessID) +
        ', theSessionId=' + IntToStr(theSessionId) +
        ', theUserId=' + IntToStr(theUserId),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_CANNOTDETACHPARTICIPANTFROMTHEPROCESS;
      exit;
    end;
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'UnRegisterParticipant',
        '[EXCEPTION] On exec apiUnRegisterParticipant:' + e.Message +
        '; Params: ProcessID=' + IntToStr(ProcessID) +
        ', theSessionId=' + IntToStr(theSessionId) +
        ', theUserId=' + IntToStr(theUserId),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_CANNOTDETACHPARTICIPANTFROMTHEPROCESS;
      exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
end;

function TAPI.UnReserveForTournament(ProcessID: Integer;
  var Data: String): Integer;
var
  FAcc: TAccount;
begin

  FAcc := CommonDataModule.ObjectPool.GetAccount;
  Result := FAcc.UnReserveForTournament(ProcessID, Data);
  CommonDataModule.ObjectPool.FreeAccount(FAcc);

  if Result <> PO_NOERRORS then begin
    CommonDataModule.Log(ClassName, 'UnReserveForTournament',
      '[ERROR] On exec FAcc.UnReserveForTournament Result=' + IntToStr(Result) +
      '; Params: processId=' + IntToStr(processId) +
      ', data=' + Data,
      ltCall
    );
  end;
end;

function TAPI.UnReserveMoney(SessionID, ProcessID, UserID,
  CurrencyID: Integer; Amount: Currency; var NewAmount,
  NewReserve: Currency): Integer;
var
  FAcc: TAccount;
begin
  FAcc := CommonDataModule.ObjectPool.GetAccount;
  Result := FAcc.ReturnAmount(
    SessionId, userid, processid, amount, newAmount, newReserve
  );
  CommonDataModule.ObjectPool.FreeAccount(FAcc);

  if Result <> PO_NOERRORS then begin
    CommonDataModule.Log(ClassName, 'UnReserveMoney',
      '[ERROR] On exec FAcc.ReturnAmount Result=' + IntToStr(Result) +
      '; Params: UserID=' + IntToStr(UserID) +
      ', SessionID=' + IntToStr(SessionID) +
      ', processid=' + IntToStr(ProcessID) +
      ', CurrencyID=' + IntToStr(CurrencyID) +
      ', amount=' + CurrToStr(Amount),
      ltCall
    );
  end;
end;

function TAPI.UserMakeAllIn(UserID: Integer): Integer;
var
  errCode : integer;
  sql: TSQLAdapter;
begin

  Result:=PO_NOERRORS;
  sql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    sql.SetProcName('apiUserMakeAllIn');
    sql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    sql.addparam('userId',userId,ptInput,ftInteger);
    sql.ExecuteCommand;
    errCode := sql.Getparam('RETURN_VALUE');
    if errCode<>PO_NOERRORS then begin
      CommonDataModule.Log(ClassName, 'UserMakeAllIn',
        '[ERROR] On exec apiUserMakeAllIn:  Result=' + IntToStr(errCode) +
        '; Params: userId=' + IntToStr(UserID),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
      result := AP_ERR_USERCANNOUTMAKEALLIN;
      exit;
    end;
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'UserMakeAllIn',
        '[EXCEPTION] On exec apiUserMakeAllIn:' + e.Message +
        '; Params: userId=' + IntToStr(UserID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(sql);
      result := AP_ERR_USERCANNOUTMAKEALLIN;
      exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(sql);

end;

procedure TAPI.ProcessGetCategories(Action: TapiAction);
var
  sText: string;
  sSQL : string;
  FSql : TSQLAdapter;
begin
  if CommonDataModule.ObjectPool.GetCategoriesCache.GetCachedString(1, sText) then
  begin
    // get Category info
    FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
    sSQL := 'exec apiGetCategories';  // prepare query

    try
      sText :=
        '<' + Action.Name + ' result="0">' +
          FSql.ExecuteForXML(sSQL) +
        '</' + Action.Name + '>';
    except
      on E: Exception do begin
        CommonDataModule.Log(ClassName, 'ProcessGetCategories',
          '[EXCEPTION]: On exec apiGetCategories:' + E.Message,
          ltException
        );
        CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
        sText := GetResponseXMLOnError(Action.Name, PO_ERR_GETTINGXMLASSTRINGFROMSQL);
        Exit;
      end;
    end;
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
    CommonDataModule.ObjectPool.GetCategoriesCache.SetCachedString(1, sText);
  end;

  Response.Add(sText, Action.SessionID, Action.UserID).ObjName := APP_LOBBY;
  sText := '';
  sSQL := '';
end;

procedure TAPI.ProcessGetSummary(Action: TapiAction);
var
  sText: string;
  FSQL: TSQLAdapter;
begin
  if CommonDataModule.ObjectPool.GetSummaryCache.GetCachedString(1, sText) then
  begin
    FSQL := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      sText := GetSummaryXMLString(FSQL);
    finally
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
    end;
    CommonDataModule.ObjectPool.GetSummaryCache.SetCachedString(1, sText);
  end;

  Response.Add(sText, Action.SessionID, Action.UserID).ObjName := APP_LOBBY;
end;

function TAPI.GetSummaryXMLString(FSQL: TSQLAdapter): String;
var
  processesCount: integer;
  gamersCount: integer;
begin
  gamersCount     := 0;
  processesCount  := 0;
  FSQL.SetProcName('apiGetSystemSummary');
  FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
  FSQL.addparam('gamersCount',gamersCount,ptOutput,ftInteger);
  FSQL.addparam('processesCount',processesCount,ptOutput,ftString);
  FSQL.executecommand();
  gamersCount := FSQL.Getparam('gamersCount');
  processesCount:= FSQL.Getparam('processesCount');

  Result :=
    '<' + AP_UPDATESUMMARY + ' result="0" ' +
      'players="' + IntToStr(gamersCount) + '" ' +
      'processes="' + IntToStr(processesCount) + '" ' +
      'servertime="' + FormatDateTime('hh:nn AM/PM',Now)+'" '+
      'serverlongdatetime="' + FormatDateTime('mmmm dd yyyy hh:nn AM/PM',Now) +
      '"/>';
//  CommonDataModule.Log(ClassName, 'GetSummaryXMLString', Result, ltCall);
end;

function TAPI.GetResponseXMLOnError(NodeName: string;
  ErrorCode: Integer): string;
begin
  Result :=
    '<' + NodeName + ' result="' + IntToStr(ErrorCode) + '"/>';
end;

//----------------------------------------------------------------------------------------
// All Child Nodes XMLData packet will added to the Target Node as child nodes.
// The XMLData packet must have one root node.
// If adding is impossible then result is false and exception Message contain reason.
// If adding is success then result is true.
function TAPI.AddChildNodesFromXMLChildNodes( XMLData : string          // source
  ; TargetNode : IXMLNode     // target
  ; var ExceptionMessage : string
  ): boolean;
var
  doc                 : IXMLDocument;
  root , node         : IXMLNode;
  i                   : integer;
begin
  Result := false;
  doc := TXMLDocument.Create(nil);
  Try
    doc.Active:=false;
    doc.XML.Text:=XMLData;
    doc.Active:=true;
    root:=doc.DocumentElement;
  except
    on E:Exception do begin
      ExceptionMessage:=E.Message;
      exit;
    end;
  end;

  try
    for i := 0 to root.ChildNodes.Count-1 do begin
      if root.ChildNodes.Nodes[ i ].NodeType = ntElement then begin
        node:=root.ChildNodes.Nodes[ i ].CloneNode( true );
        //node.DeclareNamespace('','nsActions');
        TargetNode.ChildNodes.Add( node );
      end;
    end;
  except
    on E : Exception do begin
      ExceptionMessage := E.Message;
      Result := false;
      Exit;
    end;
  end;
  Result:=true;
  doc:=nil;
  root:=nil;
end;

procedure TAPI.ProcessGetProcesses(Action: TapiAction);
{
Request:
<objects>
  <object name="api">
      <apgetprocesses subcategoryid="1" type="0|1|2|3|4"/>
  </object>
</objects>
where:
0 - All tables
1 - Real money tables ("Poker Tables" tab);
2 - Play money tables ("Practice Tables" tab);
3 - Rewarded tables ("Special" tab);
4 - Private tables ("Player tables" tab).

Response:
<object name="lobby">
  <apgetprocesses  subcategoryid="1" type="0|1|2|3" result="0|...">
    <columns>
      <stats id="1" order="1"/>
      <stats id="2" order="4"/>
      <stats id="3" order="2"/>
      <stats id="4" order="3"/>
    </columns>
    <processes>
      <process id="1" name="Money table #123" currencyid="1" groupid="1" masswatchingallowed="1" highlightedmode="1">
        <stats id="1" value="12"/>
        <stats id="2" value="2.57"/>
        <stats id="4" value="456"/>
        <stats id="7" value="Waiting..."/>
      </process>
        …
    </processes>
  </apgetprocesses>
</object>
}

var
  SubCategoryId : integer;
  TypeId : integer;
  MemoryID: integer;
  StatsText     : string;
  ProcessesText : string;
  FSql: TSQLAdapter;
  RS: TDataSet;
begin
  FSql := nil;
  try
    // Get Request Info
    SubCategoryId := StrToIntDef(Action.ActionNode.Attributes['subcategoryid'], 0);
    if Action.ActionNode.HasAttribute('type') then
      TypeID := StrToIntDef(Action.ActionNode.Attributes['type'], 0)
    else
      TypeID := 0;
    if SubCategoryId <= 0 then begin
      CommonDataModule.Log(ClassName, 'ProcessGetProcesses',
        '[ERROR]: Incorrect attribute "subcategoryid"', ltError);

      Response.Add(
        GetResponseXMLOnError(Action.Name, AP_ERR_CORRUPTREQUESTARGUMENTS),
        Action.SessionID, Action.UserID).ObjName := APP_LOBBY;
      Exit;
    end;

    // get SubCategory format info
    if CommonDataModule.ObjectPool.GetSubCategoryStatsCache.GetCachedString(
      SubCategoryId, StatsText) then
    begin
      StatsText := '<columns>';
      FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
      RS := FSql.Execute('exec apiGetSubCategoryStatsFormat '+IntToStr(SubCategoryId));
      while not RS.Eof do begin
        StatsText := StatsText +
          '<stats order="' + RS.FieldByName('norder').AsString + '" id="' +
          RS.FieldByName('id').AsString + '"/>';
        RS.Next;
      end;
      StatsText := StatsText + '</columns>';
      CommonDataModule.ObjectPool.GetSubCategoryStatsCache.SetCachedString(
        SubCategoryId, StatsText);
    end;

    // get SubCategory Game Process Stats List
    if TypeId = 4 then
      MemoryID := Action.SessionID
    else
      MemoryID := - TypeId;
    if CommonDataModule.ObjectPool.GetProcessesCache.GetCachedString(
      SubCategoryId, ProcessesText, MemoryID) then
    begin
      ProcessesText := '';
      if FSQL = nil then
        FSql := CommonDataModule.ObjectPool.GetSQLAdapter;

      ProcessesText := GetProcessesXMLString(SubCategoryID, TypeId, Action.SessionID, FSql);

      CommonDataModule.ObjectPool.GetProcessesCache.SetCachedString(
        SubCategoryId, ProcessesText, MemoryID);
    end;

    // collect response packet
    Response.Add(
      '<' + Action.Name + ' subcategoryid="' + IntToStr(SubCategoryId) +
      '" type="' + IntToStr(TypeId) + '" result="0">' +
      StatsText + ProcessesText + '</' + Action.Name + '>',
      Action.SessionID, Action.UserID).ObjName := APP_LOBBY;
  finally
    if FSQL <> nil then
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
  end;
end;

function TAPI.GetProcessesXMLString(SubCategoryID, TypeId, SessionID: Integer; FSql: TSQLAdapter): String;
var
  SQLProcName: String;
  RS: TDataSet;
  bNeedCloseNode: Boolean;
  UserID: Integer;
  SpecialUser: Integer;
begin
  Result := '';

  UserID := 0;
  SpecialUser := 0;
  if TypeId = 4 then
  begin
    FSQL.SetProcName('apiGetSubCategoryGameProcessesPrivatePrepare');
    FSQL.AddParam('ClientSessionId', SessionID, ptInput, ftInteger);
    FSQL.AddParam('UserID', UserID, ptInputOutput, ftInteger);
    FSQL.AddParam('SpecialUser', SpecialUser, ptInputOutput, ftInteger);
    FSQL.ExecuteCommand;
    UserID := StrToIntDef(FSQL.Getparam('UserID'), 0);
    SpecialUser := StrToIntDef(FSQL.Getparam('SpecialUser'), 0);
  end;

  bNeedCloseNode := False;
  SQLProcName := 'apiGetSubCategoryGameProcesses';
  case TypeId of
    1: SQLProcName := 'apiGetSubCategoryGameProcessesRealMoney';
    2: SQLProcName := 'apiGetSubCategoryGameProcessesPlayMoney';
    3: SQLProcName := 'apiGetSubCategoryGameProcessesRewarded';
    4: SQLProcName := 'apiGetSubCategoryGameProcessesPrivate ' +
      inttostr(SessionID) + ',' +
      inttostr(UserID) + ',' +
      inttostr(SpecialUser) + ',';
  end;
  RS := FSql.Execute('exec ' + SQLProcName + ' ' + inttostr(SubCategoryId));
  while not RS.Eof do begin
    if RS.FieldByName('tag').AsString = 'process' then begin
      if bNeedCloseNode then Result := Result + '</process>';
      Result := Result +
        '<process id="' + RS.FieldByName('id').AsString +
          '" actiondispatcherid="' + RS.FieldByName('actiondispatcherid').AsString +
          '" gametypeid="' + RS.FieldByName('gametypeid').AsString +
          '" chairscount="' + RS.FieldByName('chairscount').AsString +
          '" name="' + RS.FieldByName('name').AsString +
          '" ismasswatchingallowed="' + inttostr(rsBit(RS, 'ismasswatchingallowed')) +
          '" ishighlighted="' + inttostr(rsBit(RS, 'ishighlighted')) +
          '" creatoruserid="' + RS.FieldByName('creatoruserid').AsString +
          '" protectedmode="' + RS.FieldByName('protectedmode').AsString +
          '" currencyid="' + RS.FieldByName('currencyid').AsString +
          '" groupid="' + RS.FieldByName('groupid').AsString + '">';
      bNeedCloseNode := True;
    end else begin
      Result := Result +
        '<stats id="' + RS.FieldByName('stats_id').AsString +
          '" value="' + RS.FieldByName('stats_value').AsString + '"/>';
    end;
    RS.Next;
  end;

  if Result <> '' then
    Result := Result + '</process>';
  Result := '<processes>' + Result + '</processes>';

//  CommonDataModule.Log(ClassName, 'GetProcessesXMLString', Result, ltCall);
end;

function TAPI.GetProcessesInfoXMLString(FSql: TSQLAdapter): String;
var
  RS: TDataSet;
begin
  Result := '<processesinfo>';
  RS := FSql.Execute(
    'select * from GameProcessInfo gpi (nolock)' +
    'inner join [GameProcess] gp (nolock) on gp.[ID] = gpi.[GameProcessID]' +
    'where gp.StatusID=1');
  while not RS.Eof do begin
    Result := Result + '<processinfo processid="' +
      RS.FieldByName('GameProcessID').AsString + '">' +
      RS.FieldByName('Data').AsString + '</processinfo>';
    RS.Next;
  end;
  Result := Result + '</processesinfo>';
end;

procedure TAPI.ProcessGetProcessInfo(Action: TapiAction);
var
  watchers,waithers,waitherposition: integer;
  errCode: integer;
  CommonData: String;
  PersonalData: String;
  //
  FSql: TSQLAdapter;
  ProcessID: Integer;
begin
  // Get Request Info
  ProcessId := Action.ProcessID;
  if ProcessId <= 0 then begin
    CommonDataModule.Log(ClassName, 'ProcessGetProcessInfo',
      '[ERROR]: Incorrect attribute "processid"', ltError);
    Response.Add(GetResponseXMLOnError(Action.Name, AP_ERR_CORRUPTREQUESTARGUMENTS),
      Action.SessionID, Action.UserID).ObjName := APP_LOBBY;
    Exit;
  end;

  if CommonDataModule.ObjectPool.GetProcessInfoCache.GetCachedString(ProcessId, CommonData) then
  begin
    // Get Common Data
    errCode := GetState(ProcessId, 999, CommonData);
    if errCode <> PO_NOERRORS then
    begin
      CommonDataModule.Log(ClassName, 'ProcessGetProcessInfo',
        '[ERROR]: GetState return error=' + IntToStr(AP_ERR_CANNOTGETGAMESTATE) +
        '; Params: ProcessID=' + IntToStr(ProcessID) +
        ', StateID=999, LockState=0', ltError);

      Response.Add(GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTGETGAMESTATE),
        Action.SessionID, Action.UserID).ObjName := APP_LOBBY;
      Exit;
    end;
    CommonDataModule.ObjectPool.GetProcessInfoCache.SetCachedString(ProcessId, CommonData);
  end;

  //...........................................................
  // Get Personal Data
  if CommonDataModule.ObjectPool.GetProcessInfoPersonalCache.GetCachedString(
    ProcessId, PersonalData, Action.SessionID) then
  begin
    FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      FSql.SetProcName('apiGetGameProcessCommonInfo');
      FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
      FSql.addparam('processId',ProcessID,ptInput,ftInteger);
      FSql.addparam('sessionId',Action.SessionID,ptInput,ftInteger);
      FSql.addparam('watchers',0,ptOutput,ftInteger);
      FSql.addparam('waiters',0,ptOutput,ftInteger);
      FSql.addparam('waiterPosition',0,ptOutput,ftInteger);

      FSql.executecommand();

      watchers        := FSql.Getparam('watchers');
      waithers        := FSql.Getparam('waiters');
      waitherposition := FSql.Getparam('waiterPosition');
      errCode := FSql.Getparam('RETURN_VALUE');
      if errCode <> PO_NOERRORS then begin
        CommonDataModule.Log(ClassName, 'ProcessGetProcessInfo',
          '[ERROR]: On exec apiGetGameProcessCommonInfo return error=' + IntToStr(errCode) +
          '; Params: ProcessID=' + IntToStr(ProcessID) +
          ', SessionID=' + IntToStr(Action.SessionID), ltError);

        CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
        Response.Add(GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTGETPROCESSINFO),
          Action.SessionID, Action.UserID).ObjName := APP_LOBBY;
        Exit;
      end;
    except
      on E:Exception do begin
        CommonDataModule.Log(ClassName, 'ProcessGetProcessInfo',
          '[EXCEPTION]: On exec apiGetGameProcessCommonInfo:' + e.Message +
          '; Params: ProcessID=' + IntToStr(ProcessID) +
          ', SessionID=' + IntToStr(Action.SessionID), ltException);

        CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
        Response.Add(GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTGETPROCESSINFO),
          Action.SessionID, Action.UserID).ObjName := APP_LOBBY;
        Exit;
      end;
    end;

    CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);

    PersonalData := '<group name="Waiting list:" ';
    if waitherposition<>0 then
      PersonalData := PersonalData +
        'value="' + IntToStr(waitherposition)+'/'+inttostr(waithers) + '"'
    else
      PersonalData := PersonalData +
        'value="' + IntToStr(waithers) + '"';
    PersonalData := PersonalData + '/><group name="Watchers:" value="' +
      IntToStr(watchers) + '"/>';

    CommonDataModule.ObjectPool.GetProcessInfoPersonalCache.SetCachedString(
      ProcessId, PersonalData, Action.SessionID);
  end;

  Response.Add('<' + Action.Name + ' processid="' + IntToStr(ProcessID) + '" result="0">' +
    CommonData +  PersonalData + '</' + Action.Name + '>',
    Action.SessionID, Action.UserID).ObjName := APP_LOBBY;
end;

procedure TAPI.ProcessGetCurrencies(Action: TapiAction);
var
  sText: string;
  sSQL : string;
  FSql: TSQLAdapter;
begin
  if CommonDataModule.ObjectPool.GetCurrenciesCache.GetCachedString(1, sText) then
  begin
    // get Category info
    FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
    sSQL := 'exec apiGetCurrencies ';  // prepare query

    try
      sText := FSql.ExecuteForXML(sSQL);
      if sText = '' then begin
        CommonDataModule.Log(ClassName, 'ProcessGetCurrencies',
          '[WARNING]: Return value of ' + sSQL + ' is empty',
          ltError
        );
      end;
    except
      on E: Exception do begin
        CommonDataModule.Log(ClassName, 'ProcessGetCurrencies',
          '[EXCEPTION] On execute ' + sSQL + ': Message=' + E.Message,
          ltException);
        sText := '';
      end;
    end;

    sText := '<' + Action.Name + ' result="0">' + sText + '</' + Action.Name + '>';

    CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
    CommonDataModule.ObjectPool.GetCurrenciesCache.SetCachedString(1, sText);
  end;

  Response.Add(sText, Action.SessionID, Action.UserID).ObjName := APP_CONVERSIONS;
end;

procedure TAPI.ProcessGetStats(Action: TapiAction);
var
  sText : string;
  sSQL : string;
  FSql : TSQLAdapter;
  RS: TDataSet;
begin
  if CommonDataModule.ObjectPool.GetStatsCache.GetCachedString(1, sText) then
  begin
    sSQL := 'exec apiGetStatsList ';  // prepare query
    FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      RS := FSql.Execute(sSQL);
      sText := '';
      while not RS.Eof do begin
        sText := sText +
          '<stats id="' + RS.FieldByName('id').AsString + '" ' +
            'name="' + RS.FieldByName('name').AsString + '" ' +
            'propertyid="' + RS.FieldByName('propertyid').AsString + '" ' +
          '/>';

        RS.Next;
      end;
    except
      on e: Exception do begin
        CommonDataModule.Log(ClassName, 'ProcessGetStats',
          '[EXCEPTION] On exec ' + sSQL + ': Message=' + e.Message,
          ltException
        );
        sText := '';
      end;
    end;

    CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);

    if sText = '' then begin
      CommonDataModule.Log(ClassName, 'ProcessGetStats',
        '[WARNING]: Return value of ' + sSQL + ' is empty',
        ltError
      );
    end;

    sText := '<' + Action.Name + ' result="0">' + sText + '</' + Action.Name + '>';
    CommonDataModule.ObjectPool.GetStatsCache.SetCachedString(1, sText);
  end;

  Response.Add(sText, Action.SessionID, Action.UserID).ObjName := APP_LOBBY;
end;

procedure TAPI.ProcessGetCountries(Action: TapiAction);
var
  sText : string;
  sSQL : string;
  FSql : TSQLAdapter;
  RS: TDataSet;
begin
  if CommonDataModule.ObjectPool.GetCountriesCache.GetCachedString(1, sText) then
  begin
    sSQL := 'exec apiGetCountries ';  // prepare query
    FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      sText := '';
      RS := FSql.Execute(sSQL);
      while not RS.Eof do begin
        sText := sText +
          '<country ' +
            'id="' + RS.FieldByName('id').AsString + '" ' +
            'name="' + RS.FieldByName('name').AsString + '" ' +
            'usa="' + RS.FieldByName('usa').AsString + '" ' +
          '/>';

        RS.Next;
      end;
    except
      on e: Exception do begin
        CommonDataModule.Log(ClassName, 'ProcessGetCountries',
          '[EXCEPTION] On exec ' + sSQL + ': Message=' + e.Message,
          ltException
        );
        sText := '';
      end;
    end;

    CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);

    if sText = '' then begin
      CommonDataModule.Log(ClassName, 'ProcessGetCountries',
        '[WARNING]: Return value of ' + sSQL + ' is empty',
        ltError
      );
    end;

    sText := '<' + Action.Name + ' result="0">' + sText + '</' + Action.Name + '>';
    CommonDataModule.ObjectPool.GetCountriesCache.SetCachedString(1, sText);
  end;

  Response.Add(sText, Action.SessionID, Action.UserID).ObjName := APP_CASHIER;
end;

procedure TAPI.ProcessGetStates(Action: TapiAction);
var
  sText : string;
  sSQL : string;
  FSql : TSQLAdapter;
  RS: TDataSet;
begin
  if CommonDataModule.ObjectPool.GetStatesCache.GetCachedString(1, sText) then
  begin
    sSQL := 'exec apiGetStates ';  // prepare query
    FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      RS := FSql.Execute(sSQL);
      sText := '';
      while not RS.Eof do begin
        sText := sText +
          '<state id="' + RS.FieldByName('id').AsString + '" ' +
            'name="' + RS.FieldByName('name').AsString + '" ' +
            'longname="' + RS.FieldByName('longname').AsString + '" ' +
            'isfundsallowed="' + RS.FieldByName('isfundsallowed').AsString + '" ' +
            'isUnitedStates="' + RS.FieldByName('isUnitedStates').AsString + '" ' +
          '/>';

        RS.Next;
      end;
    except
      on e: Exception do begin
        CommonDataModule.Log(ClassName, 'ProcessGetStates',
          '[EXCEPTION] On exec ' + sSQL + ': Message=' + e.Message,
          ltException
        );
        sText := '';
      end;
    end;
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);

    if sText = '' then begin
      CommonDataModule.Log(ClassName, 'ProcessGetStates',
        '[WARNING]: Return value of ' + sSQL + ' is empty',
        ltError
      );
    end;

    sText := '<' + Action.Name + ' result="0">' + sText + '</' + Action.Name + '>';
    CommonDataModule.ObjectPool.GetStatesCache.SetCachedString(1, sText);
  end;

  Response.Add(sText, Action.SessionID, Action.UserID).ObjName := APP_CASHIER;
end;

procedure TAPI.ProcessRegisterAtWaitingList(Action: TapiAction);
var
  errCode           : Integer;
  ProcessId
  ,GroupId
  ,PlayersCount
  ,participantCount : integer;
  FSql              : TSQLAdapter;
  UserID            : Integer;
  sTxt              : string;
begin

  ProcessId    := Action.ProcessID;
  GroupId      := StrToIntDef(Action.ActionNode.Attributes['groupid'], 0);
  PlayersCount := StrToIntDef(Action.ActionNode.Attributes['playerscount'], 0);
  if PlayersCount < 0 then PlayersCount := 0;

  if (ProcessId <= 0) and (GroupId <= 0) then begin
    CommonDataModule.Log(ClassName, 'ProcessRegisterAtWaitingList',
      '[ERROR]: Incorrect attribute value [ProcessId, GroupId]' +
      '; Params: Action=' + Action.ActionNode.XML,
      ltError
    );

    sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CORRUPTREQUESTARGUMENTS);
    Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

    Exit;
  end;

  // get userid by session id
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiGetParticipantInfo');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('sessionId',Action.SessionID,ptInput,ftInteger);
    FSql.addparam('host','',ptOutput,ftString);
    FSql.addparam('userId',0,ptOutput,ftInteger);
    FSql.addparam('username','',ptOutput,ftString);
    FSql.addparam('city','',ptOutput,ftString);
    FSql.addparam('sexId',0,ptOutput,ftInteger);
    FSql.addparam('avatarId',0,ptOutput,ftInteger);
    FSql.addparam('ImageVersion',0,ptOutput,ftInteger);
    FSql.addparam('IP','',ptOutput,ftString);
    FSql.addparam('ChatAllow',0,ptOutput,ftInteger);
    FSql.addparam('AffiliateID',0,ptOutput,ftInteger);
    FSql.addparam('IsEmailValidated',0,ptOutput,ftInteger);
    FSql.executecommand();
    errCode := FSql.Getparam('RETURN_VALUE');
    if errCode <> PO_NOERRORS then begin
      CommonDataModule.Log(ClassName, 'ProcessRegisterAtWaitingList',
        '[ERROR]: On exec apiGetParticipantInfo Result=' + IntToStr(errCode) +
        '; Params: SessionID=' + IntToStr(Action.SessionID),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTGETUSERIDBYSESSIONID);
      Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

      Exit;
    end;

    UserID := FSql.Getparam('userid');
    if UserId = 0 then begin // user isn't loggen on
      CommonDataModule.Log(ClassName, 'ProcessRegisterAtWaitingList',
        '[ERROR]: cannot get userId by SessionId when user isn''t logged on' +
        '; Params: SessionID=' + IntToStr(Action.SessionID),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTGETUSERIDBYSESSIONID);
      Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

      Exit;
    end;
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'ProcessRegisterAtWaitingList',
        '[EXCEPTION] On exec apiGetParticipantInfo:' + e.Message +
        '; Params: SessionID=' + IntToStr(Action.SessionID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTGETUSERIDBYSESSIONID);
      Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

      Exit;
    end;
  end; //  try user id getting

  // try register at the waiting list
  errCode := RegisterAtWaitingList( UserId,
    processId, groupId, playersCount, participantCount
  );
  if errCode <> PO_NOERRORS then begin
    CommonDataModule.Log(ClassName, 'ProcessRegisterAtWaitingList',
      '[ERROR] On RegisterAtWaitingList Result=' + IntToStr(errCode) + ': cannot register at waiting list' +
      '; Params: UserID=' + IntToStr(UserID) +
      ', processId=' + IntToStr(ProcessId) +
      ', groupId=' + IntToStr(GroupId) +
      ', playersCount=' + IntToStr(PlayersCount) +
      ', participantCount='  + IntToStr(participantCount),
      ltError
    );

    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
    sTxt := GetResponseXMLOnError(Action.Name, errCode);
    Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

    Exit;
  end;

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

  sTxt :=
    '<' + Action.Name + ' result="0" ' +
      'userid="' + IntToStr(UserID) + '" ' +
      'processid="' + IntToStr(ProcessId) + '" ' +
      'groupid="' + IntToStr(GroupId) + '" ' +
      'playerscount="' + IntToStr(PlayersCount) + '" ' +
      'participantCount="' + IntToStr(participantCount) + '" ' +
    '/>';

  Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

end;

procedure TAPI.ProcessUnregisterFromWaitingList(Action: TapiAction);
var
  errCode            : Integer;
  processId
  , groupId
  , UserID
  , playersCount
  , participantCount : integer;
  FSql               : TSQLAdapter;
  sTxt               : string;
begin

  playerscount := 0;
  ProcessId := Action.ProcessID;
  GroupId := StrToIntDef(Action.ActionNode.Attributes['groupid'], 0);
  if (processId <= 0) and (groupId <= 0) then begin
    CommonDataModule.Log(ClassName, 'ProcessUnregisterFromWaitingList',
      '[ERROR]: invalid request data' +
      '; Params: XML=' + Action.ActionNode.XML,
      ltError
    );

    sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CORRUPTREQUESTARGUMENTS);
    Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_LOBBY;

    Exit;
  end;

  // get userid by session id
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiGetParticipantInfo');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('sessionId',Action.SessionID,ptInput,ftInteger);
    FSql.addparam('host','',ptOutput,ftString);
    FSql.addparam('userId',0,ptOutput,ftInteger);
    FSql.addparam('username','',ptOutput,ftString);
    FSql.addparam('city','',ptOutput,ftString);
    FSql.addparam('sexId',0,ptOutput,ftInteger);
    FSql.addparam('avatarId',0,ptOutput,ftInteger);
    FSql.addparam('ImageVersion',0,ptOutput,ftInteger);
    FSql.addparam('IP','',ptOutput,ftString);
    FSql.addparam('ChatAllow',0,ptOutput,ftInteger);
    FSql.addparam('AffiliateID',0,ptOutput,ftInteger);
    FSql.addparam('IsEmailValidated',0,ptOutput,ftInteger);
    FSql.executecommand();
    errCode := FSql.Getparam('RETURN_VALUE');
    if errCode <> PO_NOERRORS then begin
      CommonDataModule.Log(ClassName, 'ProcessUnregisterFromWaitingList',
        '[ERROR] On execute apiGetParticipantInfo Result=' + IntToStr(errCode) +
          ': cannot get userId by SessionId' +
          '; Params: SessionID=' + IntToStr(Action.SessionID),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTGETUSERIDBYSESSIONID);
      Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_LOBBY;

      Exit;
    end;

    UserID := FSql.Getparam('userid');
    if UserId <= 0 then begin // user isn't loggen on
      CommonDataModule.Log(ClassName, 'ProcessUnregisterFromWaitingList',
        '[ERROR]: cannot get userId by SessionId when user isn''t logged on' +
        '; Params: SessionID=' + IntToStr(Action.SessionID),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTGETUSERIDBYSESSIONID);
      Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_LOBBY;

      Exit;
    end;
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'ProcessUnregisterFromWaitingList',
        '[EXCEPTION] On exec apiGetParticipantInfo:' + e.Message +
        '; Params: SessionID=' + IntToStr(Action.SessionID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTGETUSERIDBYSESSIONID);
      Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_LOBBY;

      Exit;
    end;
  end; //  try user id getting

  // try register at the waiting list
  errCode := UnregisterFromWaitingList(UserID,
    processId, groupId, participantCount
  );
  if errCode <> PO_NOERRORS then begin
    CommonDataModule.Log(ClassName, 'ProcessUnregisterFromWaitingList',
      '[ERROR] On exec UnregisterFromWaitingList Result=' + IntToStr(errCode) +
      ': cannot unregister from waiting list' +
      '; Params: UserID=' + IntToStr(UserID) +
      ', processId=' + IntToStr(processId) +
      ', groupId=' + IntToStr(groupId) +
      ', participantCount=' + IntToStr(participantCount),
      ltError
    );

    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
    sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTUNREGISTERFROMWAITINGLIST);
    Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_LOBBY;

    Exit;
  end;

  { responce to process }
  sTxt :=
    '<' + Action.Name + ' result="0" ' +
      'userid="' + IntToStr(UserID) + '" ' +
      'processid="' + IntToStr(ProcessId) + '" ' +
      'groupid="' + IntToStr(GroupId) + '" ' +
      'playerscount="' + IntToStr(PlayersCount) + '" ' +
      'participantCount="' + IntToStr(participantCount) + '" ' +
    '/>';
  Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

  { send command to gameadapter }
  sTxt :=
    '<objects><object name="' + OBJ_GameAdapter + '">' +
      '<gaaction processid="' + IntToStr(ProcessId) + '">' +
        '<wldecline reason="unjoin" userid="' + IntToStr(UserID) + '"/>' +
      '</gaaction>' +
    '</object></objects>';
  CommonDataModule.ProcessAction(sTxt);

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
end;

procedure TAPI.ProcessGetNotes(Action: TapiAction);
var
  UserID, errCode
  , forUserId : integer;
  note        : string;
  FSql        : TSQLAdapter;
  sTxt        : string;
begin

  UserId := Action.UserID;
  forUserId := StrToIntDef(Action.ActionNode.Attributes['foruserid'], 0);
  if (UserID <= 0) or (forUserId <= 0) then begin
    CommonDataModule.Log(ClassName, 'ProcessGetNotes',
      '[ERROR]: invalid request data' +
      '; Params: XML=' + Action.ActionNode.XML,
      ltError
    );

    sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CORRUPTREQUESTARGUMENTS);
    Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

    Exit;
  end;

  // get userid by session id
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiGetUserNote');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('userId',UserId,ptInput,ftInteger);
    FSql.addparam('foruserId',forUserId,ptInput,ftInteger);
    FSql.addparam('note','',ptOutput,ftString);
    FSql.executecommand();
    errCode := FSql.Getparam('RETURN_VALUE');
    if errCode <> PO_NOERRORS then begin
      CommonDataModule.Log(ClassName, 'ProcessGetNotes',
        '[ERROR] On execute apiGetUserNote Result=' + IntToStr(errCode) +
          ': cannot get userId note for some user' +
          '; Params: UserID=' + IntToStr(UserID) +
          ', ForUserID=' + IntToStr(forUserId),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTGETUSERNOTE);
      Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

      Exit;
    end;
    note := FSql.Getparam('note');
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'ProcessGetNotes',
        '[EXCEPTION] On exec apiGetUserNote:' + e.Message +
          '; Params: UserID=' + IntToStr(UserID) +
          ', ForUserID=' + IntToStr(forUserId),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTGETUSERNOTE);
      Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

      Exit;
    end;
  end; //  try user id getting

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  // response
  sTxt :=
    '<' + Action.Name + ' result="0" ' +
      'userid="' + IntToStr(UserID) + '" ' +
      'foruserid="' + IntToStr(forUserId) + '" ' +
      'notes="' + note + '" ' +
    '/>';

  Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

end;

procedure TAPI.ProcessSaveNotes(Action: TapiAction);
var
  UserID, errCode,
  forUserId : integer;
  note      : string;
  sTxt      : string;
  FSql      : TSQLAdapter;
begin

  UserId := Action.UserID;
  forUserId := StrToIntDef(Action.ActionNode.Attributes['foruserid'], 0);
  if Action.ActionNode.HasAttribute('notes') then
    note := Action.ActionNode.Attributes['notes']
  else
    note := '';

  if (UserID <= 0) or (forUserId <= 0) then begin
    CommonDataModule.Log(ClassName, 'ProcessSaveNotes',
      '[ERROR]: invalid request data' +
      '; Params: XML=' + Action.ActionNode.XML,
      ltError
    );

    sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CORRUPTREQUESTARGUMENTS);
    Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

    Exit;
  end;

  // get userid by session id
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiSaveUserNote');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('userId',UserId,ptInput,ftInteger);
    FSql.addparam('forUserId',forUserId,ptInput,ftInteger);
    FSql.addparam('note',note,ptInput,ftString);
    FSql.executecommand();
    errCode := FSql.Getparam('RETURN_VALUE');
    if errCode<>PO_NOERRORS then begin
      CommonDataModule.Log(ClassName, 'ProcessSaveNotes',
        '[ERROR] On execute apiSaveUserNote Result=' + IntToStr(errCode) +
          ': cannot save note for some user' +
          '; Params: UserID=' + IntToStr(UserID) +
          ', ForUserID=' + IntToStr(forUserId) +
          ', Note=' + note,
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTSAVEUSERNOTE);
      Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

      Exit;
    end;
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'ProcessSaveNotes',
        '[EXCEPTION] On exec apiSaveUserNote:' + e.Message +
          '; Params: UserID=' + IntToStr(UserID) +
          ', ForUserID=' + IntToStr(forUserId) +
          ', Note=' + note,
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTSAVEUSERNOTE);
      Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

      Exit;
    end;
  end; //  try user id getting

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  // response
  sTxt :=
    '<' + Action.Name + ' result="0" ' +
      'userid="' + IntToStr(UserID) + '" ' +
      'foruserid="' + IntToStr(forUserId) + '" ' +
    '/>';

  Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

end;

procedure TAPI.ProcessCloneProcess(Action: TapiAction);
var
  errCode         : Integer;
  processTargetId : integer;
  ProcessID       : Integer;
//  sTxt            : string;
begin
  // get request data
  ProcessId := Action.ProcessID;
  if ProcessID <= 0 then begin
    CommonDataModule.Log(ClassName, 'ProcessCloneProcess',
      '[ERROR]: invalid request data' +
      '; Params: XML=' + Action.ActionNode.XML,
      ltError
    );

    Exit;
  end;

  errCode := CloneProcess(ProcessId, processTargetId);

  if errCode<>PO_NOERRORS then begin
    CommonDataModule.Log(ClassName, 'ProcessCloneProcess',
      '[ERROR] Process with such name already exists On exec CloneProcess Result=' + IntToStr(errCode) +
      '; Params: ProcessID=' + IntToStr(ProcessID),
      ltError
    );

    Exit;
  end;

end;

procedure TAPI.ProcessGetRecordedHandHistory(Action: TapiAction);
var
  handId                      : integer;
  errCode                     : integer;
  handTemplate                : String;
  UserID: Integer;
  sTxt: string;
  FSql: TSQLAdapter;
  ProcessID: Integer;
begin

  UserId := Action.UserID;
  handId := StrToIntDef(Action.ActionNode.Attributes['handid'], 0);
  if (UserID <= 0) or (handId <= 0) then begin
    CommonDataModule.Log(ClassName, 'ProcessGetRecordedHandHistory',
      '[ERROR]: invalid request data' +
      '; Params: XML=' + Action.ActionNode.XML,
      ltError
    );

    sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CORRUPTREQUESTARGUMENTS);
    Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

    Exit;
  end;

  // Check for processId
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiGetProcessIdByHandId');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('handId',handId,ptInput,ftInteger);
    FSql.addparam('processId',0,ptOutput,ftInteger);
    FSql.executecommand();
    errCode:=FSql.Getparam('RETURN_VALUE');
    if errCode<>PO_NOERRORS then begin
      CommonDataModule.Log(ClassName, 'ProcessGetRecordedHandHistory',
        '[ERROR] On exec apiGetProcessIdByHandId Result=' + IntToStr(errCode) + ': Hand Not Found' +
        '; Params: HandID=' + IntToStr(handId),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_HANDNOTFOUND);
      Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

      Exit;
    end;
    ProcessID := FSql.Getparam('processId');
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'ProcessGetRecordedHandHistory',
        '[EXCEPTION] On exec apiGetProcessIdByHandId:' + e.Message +
        '; Params: HandID=' + IntToStr(handId),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTGETPROCESSIDBYHANDID);
      Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

      Exit;
    end;
  end;

  // Get Personified hand history
  errCode := GetPersonalHandHistory(UserID,handId,1,handTemplate);
  if errCode<>PO_NOERRORS then begin
    CommonDataModule.Log(ClassName, 'ProcessGetRecordedHandHistory',
      '[ERROR] On exec GetPersonalHandHistory Result=' + IntToStr(errCode) + ': Cannot get hand histrory' +
      '; Params: UserID=' + IntToStr(UserID) +
      ', HandID=' + IntToStr(handId) +
      ', RemoveOtherRanking=1',
      ltError
    );

    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
    sTxt := GetResponseXMLOnError(Action.Name, errCode);
    Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

    Exit;
  end;

  sTxt :=
    '<' + Action.Name + ' result="0" ' +
      'userid="' + IntToStr(UserID) + '" ' +
      'handid="' + IntToStr(handId) + '" ' +
      'processid="' + IntToStr(ProcessID) + '">' +
      handTemplate +
    '</' + Action.Name + '>';
  Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
end;

procedure TAPI.ProcessGetRecordedHands(Action: TapiAction);
var
  sTxt: string;
  sSQL: string;
  FSql: TSQLAdapter;
  UserID: Integer;
begin

  UserId := Action.UserID;
  if UserID <= 0 then begin
    CommonDataModule.Log(ClassName, 'ProcessGetRecordedHands',
      '[ERROR]: invalid request data' +
      '; Params: XML=' + Action.ActionNode.XML,
      ltError
    );

    sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CORRUPTREQUESTARGUMENTS);
    Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

    Exit;
  end;

  sSQL := 'exec apiGetRecordedHands @userId='+inttostr(UserId);  // prepare query
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    sTxt := FSql.ExecuteForXML(sSQL);
  except
    on e: Exception do begin
      CommonDataModule.Log(ClassName, 'ProcessGetRecordedHands',
        '[EXCEPTION] On exec ' + sSQL + ': Message=' + e.Message,
        ltException
      );
      sTxt := '';
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

{
  if sTxt = '' then begin
    CommonDataModule.Log(ClassName, 'ProcessGetRecordedHands',
      '[WARNING]: Return value of ' + sSQL + ' is empty',
      ltError
    );
  end;
}
  sTxt :=
    '<' + Action.Name + ' result="0" userid="' + IntToStr(UserID) + '">' +
      sTxt +
    '</' + Action.Name + '>';
  Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

end;

procedure TAPI.ProcessSaveRecordedHands(Action: TapiAction);
var
  order
  ,handid   : integer;
  comment  : string;
  i, UserID : integer;
  FSql: TSQLAdapter;
  sTxt: string;
begin

  UserId := Action.UserID;
  if UserID <= 0 then begin
    CommonDataModule.Log(ClassName, 'ProcessSaveRecordedHands',
      '[ERROR]: invalid request data' +
      '; Params: XML=' + Action.ActionNode.XML,
      ltError
    );

    sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CORRUPTREQUESTARGUMENTS);
    Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

    Exit;
  end;

  // Remove all exists favorite games
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiRemoveFavoriteGames');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('userId',UserId,ptInput,ftInteger);
    FSql.executecommand();
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'ProcessSaveRecordedHands',
        '[EXCEPTION] On exec apiRemoveFavoriteGames:' + e.Message +
        '; Params: UserId=' + IntToStr(UserId),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTREMOVEEXISTSFAVORITEGAMES);
      Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

      Exit;
    end;
  end;

  // Store new favorite games
  with Action.ActionNode do begin
    if HasChildNodes then begin
      for i:=0 to ChildNodes.Count-1 do begin
        if not (
          ChildNodes.Nodes[i].HasAttribute('order') and
          ChildNodes.Nodes[i].HasAttribute('handid') and
          ChildNodes.Nodes[i].HasAttribute('comment') )
        then begin
          CommonDataModule.Log(ClassName, 'ProcessSaveRecordedHands',
            '[ERROR]: invalid request data' +
            '; Params: ChildNodes.XML=' + ChildNodes.Nodes[i].XML,
            ltError
          );

          sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CORRUPTREQUESTARGUMENTS);
          Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

          Exit;
        end;

        order := ChildNodes.Nodes[i].Attributes['order'];
        handid := ChildNodes.Nodes[i].Attributes['handid'];
        comment  := ChildNodes.Nodes[i].Attributes['comment'];

        try
          FSql.SetProcName('apiSaveFavoriteGame');
          FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
          FSql.AddParInt('userId',UserId,ptInput);
          FSql.AddParInt('horder',order,ptInput);
          FSql.AddParInt('gameLogId',handid,ptInput);
          FSql.AddParam('description',comment,ptInput, ftUnknown);
          FSql.executecommand;

        except
          on E:Exception do begin
            CommonDataModule.Log(ClassName, 'ProcessSaveRecordedHands',
              '[EXCEPTION] On exec apiSaveFavoriteGame:' + e.Message +
              '; Params: UserId=' + IntToStr(UserId) +
              ', order=' + IntToStr(order) +
              ', gamelogid=' + IntToStr(handid) +
              ', description=' + comment,
              ltException
            );

            CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
            sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTSTOREFAVORITEGAMES);
            Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

            Exit;
          end;
        end;

      end; // for i:=0 to ChildNodes.Count-1 do begin
    end; // if HasChildNodes
  end; // with resp.ActionNode

  sTxt :=
    '<' + Action.Name + ' result="0" userid="' + IntToStr(UserID) + '"/>';
  Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
end;

procedure TAPI.ProcessRequestHandHistory(Action: TapiAction);
var
  sTxt       : string;
  handHist   : String;
  lastHands  : integer;
  handId     : integer;
  direction  : integer;
  subject    : string;
  header     : string;
  screenname : string;
  fullname   : string;
  eml        : string;
  FSql       : TSQLAdapter;
  rs         : TDataSet;
  sSQL       : string;
  UserID     : Integer;
  errCode    : Integer;
  FEMail     : TEMail;
begin

  UserId := Action.UserID;
  lastHands := StrToIntDef(Action.ActionNode.Attributes['lasthands'], 0);
  handId := StrToIntDef(Action.ActionNode.Attributes['handid'], 0);
  direction := StrToIntDef(Action.ActionNode.Attributes['direction'], 0);
  if (UserID <= 0) or ((lastHands + handId) <= 0) then begin
    CommonDataModule.Log(ClassName, 'ProcessRequestHandHistory',
      '[ERROR]: invalid request data' +
      '; Params: XML=' + Action.ActionNode.XML,
      ltError
    );

    sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CORRUPTREQUESTARGUMENTS);
    Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

    Exit;
  end;

  sTxt := '';
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  if handId<>0 then begin
    errCode := GetPersonalHandHistoryAsText(UserId, handId, handHist);
    if errCode<>PO_NOERRORS then begin
      CommonDataModule.Log(ClassName, 'ProcessRequestHandHistory',
        '[ERROR]: On exec GetPersonalHandHistoryAsText Result=' + IntToStr(errCode) +
        '; Params: UserId=' + IntToStr(UserID) +
        ', handId=' + IntToStr(handId),
        ltError
      );
    end;
    sTxt := handHist;
  end
  else begin

    sSQL:='exec apiGetLastHandsOfUser @userId='+inttostr(UserId) +
      ' ,@lastHands='+inttostr(lastHands) + ' ,@direction='+inttostr(direction);

    try

      rs := FSql.Execute(sSQL);

      while not rs.Eof do begin
        handId := rs.FieldByName('handId').AsInteger;
        handHist := '';
        errCode := GetPersonalHandHistoryAsText(UserId, handId, handHist);
        if errCode<>PO_NOERRORS then begin
          CommonDataModule.Log(ClassName, 'ProcessRequestHandHistory',
            '[ERROR]: On exec GetPersonalHandHistoryAsText Result=' + IntToStr(errCode) +
            '; Params: UserId=' + IntToStr(UserID) +
            ', handId=' + IntToStr(handId),
            ltError
          );
        end;
        sTxt := sTxt + chr(13) + handHist;
        rs.Next;
      end;
    except
      on E:Exception do begin
        CommonDataModule.Log(ClassName, 'ProcessRequestHandHistory',
          '[EXCEPTION] On exec apiGetLastHandsOfUser=' + sSQL + ' or GetPersonalHandHistoryAsText:' + e.Message +
          '; Params: UserId=' + IntToStr(UserId) +
          ', handid=' + IntToStr(handid),
          ltException
        );

        CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
        sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTGETHANDHISTORY);
        Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

        Exit;
      end;
    end;
  end;

  subject :='';
  header :='';
  try
    FSql.SetProcName('apiGetEmailRequesterInfo');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('userId',UserId,ptInput,ftInteger);
    FSql.addparam('screenname','',ptOutput,ftString);
    FSql.addparam('fullname','',ptOutput,ftString);
    FSql.addparam('email','',ptOutput,ftString);
    FSql.executecommand();
    errCode := FSql.Getparam('RETURN_VALUE');
    if errCode<>PO_NOERRORS then begin
      CommonDataModule.Log(ClassName, 'ProcessRequestHandHistory',
        '[ERROR]: On exec apiGetEmailRequesterInfo Result=' + IntToStr(errCode) +
        '; Params: UserId=' + IntToStr(UserID),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CORRUPTREQUESTARGUMENTS);
      Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

      Exit;
    end;

    screenname := FSql.Getparam('screenname');
    fullName := FSql.Getparam('fullname');
    eml := FSql.Getparam('email');


    header:='Transcription ';
    if lastHands = 0 then begin
      header:=header+'of hand #'+inttostr(handId);
      subject:='Poker hand history transcription of hand #'+inttostr(handId)+' for '+fullName+' ('+screenName+')';
    end
    else begin
      header:=header+'of last '+inttostr(lastHands)+' games ';
      subject:='Poker hand history transcriptions of last '+inttostr(lastHands)+' games  for '+fullName+' ('+screenName+')';
    end;

    header:=header+' requested by '+fullName+' ('+screenName+').'+chr(13) ;
    header:=header+' This email was computer generated and emailed to '+eml+chr(13) ;
    if direction = 0 then begin
      header:=header+' Ordering: Oldest to Newest'+chr(13);
    end
    else begin
      header:=header+' Ordering: Newest to Oldest'+chr(13);
    end;

  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'ProcessRequestHandHistory',
        '[EXCEPTION] On exec apiGetEmailRequesterInfo:' + e.Message +
        '; Params: UserId=' + IntToStr(UserId),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTPREPARESUBJECTANDHEADER);
      Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

      Exit;
    end;
  end;

  FEMail := CommonDataModule.ObjectPool.GetEmail;
  errCode := FEMail.SendUserEmail(Action.SessionID, UserID, subject, String(header+sTxt));
  if errCode<>PO_NOERRORS then begin
    CommonDataModule.Log(ClassName, 'ProcessRequestHandHistory',
      '[ERROR]: On exec FEMail.SendUserEmail Result=' + IntToStr(errCode) +
      '; Params: SessionId=' + IntToStr(Action.SessionID) +
      ', UserId=' + IntToStr(UserID),
      ltError
    );

    CommonDataModule.ObjectPool.FreeEmail(FEMail);
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
    sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTSENDEMAIL);
    Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

    Exit;
  end;

  CommonDataModule.ObjectPool.FreeEmail(FEMail);
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

  sTxt := '<' + Action.Name + ' result="0"/>';
  Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

end;

procedure TAPI.ProcessCheckHandId(Action: TapiAction);
var
  order
  ,handid : integer;
  comment : string;
  FSql    : TSQLAdapter;
  errCode : Integer;
  sTxt    : string;
begin

  handId := StrToIntDef(Action.ActionNode.Attributes['handid'], 0);
  order := StrToIntDef(Action.ActionNode.Attributes['order'], 0);
  comment := Action.ActionNode.Attributes['comment'];
  if handid <= 0 then begin
    CommonDataModule.Log(ClassName, 'ProcessCheckHandId',
      '[ERROR]: invalid request data' +
      '; Params: XML=' + Action.ActionNode.XML,
      ltError
    );

    sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CORRUPTREQUESTARGUMENTS);
    Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

    Exit;
  end;

  // Remove all exists favorite games
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiCheckHandId');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('handId',handId,ptInput,ftInteger);
    FSql.executecommand();
    errCode := FSql.Getparam('RETURN_VALUE');
    if errCode<>PO_NOERRORS then begin
      CommonDataModule.Log(ClassName, 'ProcessCheckHandId',
        '[ERROR] On exec apiCheckHandId Result=' + IntToStr(errCode) +
        '; Params: handId=' + IntToStr(handid),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_HANDNOTFOUND);
      Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

      Exit;
    end;
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'ProcessCheckHandId',
        '[EXCEPTION] On exec apiCheckHandId:' + e.Message +
        '; Params: handid=' + IntToStr(handid),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTREMOVEEXISTSFAVORITEGAMES);
      Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

      Exit;
    end;
  end;

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

  sTxt :=
    '<' + Action.Name +
      ' result="0" handid="' + IntToStr(handid) + '"' +
      ' order="' + IntToStr(order) + '"' +
      ' comment="' + comment + '"' +
    '/>';

  Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

end;

procedure TAPI.ProcessCustomSupport(Action: TapiAction);
var
  subject  : string;
  message_ : string;
  FSql     : TSQLAdapter;
  FEMail   : TEMail;
  errCode  : Integer;
  sTxt     : string;
begin

  if not (Action.ActionNode.HasAttribute('subject') and Action.ActionNode.HasAttribute('message')) then begin
    CommonDataModule.Log(ClassName, 'ProcessCustomSupport',
      '[ERROR]: invalid request data' +
      '; Params: XML=' + Action.ActionNode.XML,
      ltError
    );

    sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CORRUPTREQUESTARGUMENTS);
    Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_LOBBY;

    Exit;
  end;
  subject  := Action.ActionNode.Attributes['subject'];
  message_ := Action.ActionNode.Attributes['message'];

  // get userid by session id
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiCustomSupport');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('sessionId',Action.SessionID,ptInput,ftInteger);
    FSql.addparam('subject',subject,ptInput,ftString);
    FSql.addparam('message',message_,ptInput,ftString);
    FSql.executecommand();
    errCode := FSql.Getparam('RETURN_VALUE');
    if errCode<>PO_NOERRORS then begin
      CommonDataModule.Log(ClassName, 'ProcessCustomSupport',
        '[ERROR] On exec apiCustomSupport Result=' + IntToStr(errCode) + ': cannot save message' +
        '; Params: sessionid=' + IntToStr(Action.SessionID) +
        ', subject=' + subject +
        ', message=' + message_,
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTSAVESUBJECT);
      Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_LOBBY;

      Exit;
    end;
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'ProcessCustomSupport',
        '[EXCEPTION] On exec apiCustomSupport:' + e.Message +
        '; Params: sessionid=' + IntToStr(Action.SessionID) +
        ', subject=' + subject +
        ', message=' + message_,
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTSAVESUBJECT);
      Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_LOBBY;

      Exit;
    end;
  end; //  try user id getting

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

  FEMail := CommonDataModule.ObjectPool.GetEmail;
  errCode := FEMail.PostEmailMessage(FEMail.GetEmailAddress(Action.UserID),
    FEMail.GetEmailFromAddress(Action.UserID), subject, message_);
  if errCode<>PO_NOERRORS then begin
    CommonDataModule.Log(ClassName, 'ProcessCustomSupport',
      '[ERROR] On exec FEMail.SendAdminEmail Result=' + IntToStr(errCode) + ': Cannot send email to support.' +
      '; Params: sessionid=' + IntToStr(Action.SessionID) +
      ', subject=' + subject +
      ', message=' + message_,
      ltError
    );

    CommonDataModule.ObjectPool.FreeEmail(FEMail);
    sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTSAVESUBJECT);
    Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_LOBBY;

    Exit;
  end;

  CommonDataModule.ObjectPool.FreeEmail(FEMail);

  sTxt :=
    '<' + Action.Name +
      ' result="0" subject="' + subject + '"' +
    '/>';
  Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_LOBBY;

end;

procedure TAPI.ProcessGetWaitingListInfo(Action: TapiAction);
var
  state               : integer;
  groupid             : integer;
  processname         : string;
  waitingplayerscount : integer;
  FSql                : TSQLAdapter;
  ProcessID, errCode  : Integer;
  sTxt                : string;
begin

  ProcessID := Action.ProcessID;
  if ProcessID <= 0 then begin
    CommonDataModule.Log(ClassName, 'ProcessGetWaitingListInfo',
      '[ERROR]: invalid request data' +
      '; Params: XML=' + Action.ActionNode.XML,
      ltError
    );

    sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CORRUPTREQUESTARGUMENTS);
    Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

    Exit;
  end;

  // get userid by session id
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiGetWaitingListInfo');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('sessionId',Action.SessionID,ptInput,ftInteger);
    FSql.addparam('processId',ProcessId,ptInput,ftInteger);
    FSql.addparam('state',0,ptOutput,ftInteger);
    FSql.addparam('groupId',0,ptOutput,ftInteger);
    FSql.addparam('processName',processname,ptOutput,ftString);
    FSql.addparam('waitingPlayersCount',0,ptOutput,ftInteger);
	  FSql.executecommand();
    errCode := FSql.Getparam('RETURN_VALUE');
    if errCode<>PO_NOERRORS then begin
      CommonDataModule.Log(ClassName, 'ProcessGetWaitingListInfo',
        '[ERROR] On exec apiGetWaitingListInfo Result=' + IntToStr(errCode) +
        ': perharps user is not logged on' +
        '; Params: XML=' + Action.ActionNode.XML,
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTGETWAITINGLISTINFO);
      Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

      Exit;
    end;

    state := FSql.Getparam('state');
    groupid := FSql.Getparam('groupid');
    processname := FSql.Getparam('processname');
    waitingplayerscount := FSql.Getparam('waitingplayerscount');
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'ProcessGetWaitingListInfo',
        '[EXCEPTION] On exec apiGetWaitingListInfo:' + e.Message +
        '; Params: sessionid=' + IntToStr(Action.SessionID) +
        ', ProcessId=' + IntToStr(ProcessID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      sTxt := GetResponseXMLOnError(Action.Name, AP_ERR_CANNOTGETWAITINGLISTINFO);
      Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

      Exit;
    end;
  end; //  try user id getting

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);

  // response
  sTxt :=
    '<' + Action.Name +
      ' result="0"' +
      ' processid="' + IntToStr(ProcessID) + '"' +
      ' state="' + IntToStr(state) + '"' +
      ' groupid="' + IntToStr(groupid) + '"' +
      ' processname="' + XMLSafeEncode(processname) + '"' +
      ' waitingplayerscount="' + IntToStr(waitingplayerscount) + '"' +
    '/>';
  Response.Add(sTxt, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;

end;

procedure TAPI.ProcessDisconnect(Action: TapiAction);
var
  SqlAdapter: TSQLAdapter;
begin
  CommonDataModule.Log(ClassName, 'ProcessDisconnect',
    'SessionID=' + inttostr(Action.SessionId), ltCall);
  ForEachProcess(Action);
  SqlAdapter := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    // removing client registration
    SqlAdapter.SetProcName('apiUnRegisterLocation');
    SqlAdapter.AddParam('RETURN_VALUE',0,ptResult,ftInteger);
    SqlAdapter.AddParam('SessionId', Action.SessionId, ptInput, ftInteger);
    SqlAdapter.ExecuteCommand;
  except
    on e:Exception do
      CommonDataModule.Log(ClassName, 'ProcessDisconnect',
        'SessionID=' + inttostr(Action.SessionId) + ', ' + e.Message, ltException);
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdapter);
end;

procedure TAPI.ProcessKickOff(Action: TapiAction);
begin
  ForEachProcess(Action);
end;

procedure TAPI.ProcessLeaveTable(Action: TapiAction);
begin
  ForEachProcess(Action);
end;

procedure TAPI.ForEachProcess(Action: TapiAction);
var
  rs            : TDataSet; //recordset
  errCode       : integer;
  packet        : string;
  FSql: TSQLAdapter;
  ProcessID: Integer;
  ActionName: String;
  strExtAttributes: String;
begin
  errCode:=0;
  //=====================
  // get Process List
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiGetParticipantProcessList');
    FSql.addparam('RETURN_VALUE',errCode,ptResult,ftInteger);
    FSql.addparam('SessionID',Action.SessionID,ptInput,ftInteger);
    FSql.addparam('UserID',Action.UserID,ptInput,ftInteger);
    FSql.addparam('real_userid',0,ptOutput,ftInteger);
    FSql.addparam('real_sessionid',0,ptOutput,ftInteger);

    rs := FSql.ExecuteCommand();

    errCode:=FSql.Getparam('RETURN_VALUE');
    Action.UserID:=FSql.Getparam('real_userid');
    if Action.SessionID <= 0 then
      Action.SessionID:=FSql.Getparam('real_sessionid');

    if errCode<>PO_NOERRORS then begin
      CommonDataModule.Log(ClassName, 'ForEachProcess',
        '[ERROR] On exec apiGetParticipantProcessList Result=' + IntToStr(errCode) +
        '; Params: SessionID=' + IntToStr(Action.SessionID) +
        ', UserID=' + IntToStr(Action.UserID) +
        ', actionName=' + Action.Name,
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      Exit;
    end;
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'ForEachProcess',
        '[EXCEPTION] On exec apiGetParticipantProcessList:' + e.Message +
        '; Params: SessionID=' + IntToStr(Action.SessionID) +
        ', UserID=' + IntToStr(Action.UserID) +
        ', actionName=' + Action.Name,
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      Exit;
    end;
  end;

  // Process action for each packet
  // Here XML preparing is hardcode because it is simple
  strExtAttributes := '';
  ActionName := Action.Name;
  if ActionName = AP_DISCONNECT then ActionName := GA_DISCONNECT;
  if ActionName = AP_KICKOFUSER then
  begin
    ActionName := GA_KICKOFUSER;
    if Action.ActionNode.HasAttribute('message') then
      strExtAttributes := ' message="' + Action.ActionNode.Attributes['message'] + '"';
  end;
  if ActionName = AP_LEAVETABLE then ActionName := GA_LEAVETABLE;
  if ActionName = AP_SETPARTICIPANTASLOGGED then ActionName := GA_SETPARTICIPANTASLOGGED;
  if ActionName = AP_CHATALLOW then
  begin
    ActionName := GA_CHATALLOW;
    if Action.ActionNode.HasAttribute('chatallow') then
      strExtAttributes := ' chatallow="' + Action.ActionNode.Attributes['chatallow'] + '"'
    else
    begin
      strExtAttributes := ' chatallow="1"';
      CommonDataModule.Log(ClassName, 'ForEachProcess',
        'Action do not have attribute "chatallow"', ltError);
    end;
  end;

  while not rs.Eof do begin
    // get process data
    ProcessId := rs.FieldByName('GameProcessID').AsInteger;
    //EngineComName := string(rs.Fields.Item[ 'comName' ].Value);
    packet :=
      '<objects>' +
        '<object name="' + OBJ_GameAdapter + '" id="' + IntToStr(ProcessID) + '">' +
          '<' + GA_ACTION + ' processid="' + IntToStr(ProcessID) + '" ' +
            'userid="' + IntToStr(Action.UserID) + '" ' +
            'sessionid="' + inttostr(Action.SessionID) + '">' +
            '<'+ ActionName + ' userid="' + IntToStr(Action.UserID) + '"' + strExtAttributes + '/>' +
          '</' + GA_ACTION + '>' +
        '</object>' +
      '</objects>';

    CommonDataModule.Log(ClassName, 'ForEachProcess', packet, ltResponse);
    CommonDataModule.ProcessSessionAction(Action.SessionID, packet);

    rs.Next;
  end; // for each process

  if ActionName = GA_DISCONNECT then
    FSql.Execute('delete from [waitinglist] where [userid]=' + inttostr(Action.UserID));

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  packet := '';
  ActionName := '';
  strExtAttributes := '';
end; // function ForEachProcess

procedure TAPI.ProcessReconnect(Action: TapiAction);
begin
  ForEachProcess(Action);
end;

procedure TAPI.ProcessSetParticipantAsLogged(Action: TapiAction);
begin
  ForEachProcess(Action);
end;

function TAPI.ProcessAction(ActionsText: string): Integer;
var
  XML: IXMLDocument;
  Node: IXMLNode;
begin
  XML := TXMLDocument.Create(nil);
  XML.XML.Text := ActionsText;
  try
    XML.Active := True;
  except
    on E: Exception do begin
      CommonDataModule.Log(ClassName, 'ProcessAction [as text]',
        '[EXCEPTION] On open XML:' + e.Message +
        '; Params: XML=' + ActionsText,
        ltException
      );

      Result := AP_ERR_CORRUPTREQUESTXML;
      XML := nil;
      Exit;
    end;
  end;

  Node := XML.DocumentElement;
  if not Node.HasChildNodes then begin
    CommonDataModule.Log(ClassName, 'ProcessAction [as text]',
      '[ERROR] ActionsText has not child nodes; Params: ActionsText=' + ActionsText,
      ltError
    );

    Result := AP_ERR_CORRUPTREQUESTXML;
    Exit;
  end;

  Result := ProcessAction(Node.CloneNode(True));
  XML := nil;
end;

function TAPI.SendRemindAction(ActionName: string; ProcessId,
  theSessionId: integer; execTime: TDateTime; RemindId,
  Data: string): boolean;
var
  sTxt: string;
begin
  result := true;

  sTxt :=
    '<objects><object name="' + OBJ_REMINDER + '">' +
    '<' + ActionName + ' id="' + RemindId + '" exectime="' + datetimetostr(execTime) +
    '" processid="' + IntToStr(ProcessId) + '" sessionid="' + IntToStr(theSessionId) + '">' +
    Data +
    '</' + ActionName + '></object></objects>';

  CommonDataModule.ProcessAction(sTxt);
end;

function TAPI.ReadableXML(source: string): string;
var
  theDoc  : IXMLDocument;
  xmlRoot : IXMLNode;
  target  : string;
begin
  try // validate XML
    theDoc:=TXMLDocument.Create(nil);
    theDoc.Active:=false;
    theDoc.XML.Text :=source;
    theDoc.Active:=true;

    xmlRoot:=theDoc.DocumentElement;
    target := string(FormatXMLData(xmlRoot.XML));
  except
    on E:Exception do begin
      target:=source;
    end;
  end;
  result:=target;
  theDoc:=nil;
end;

function TAPI.ReadableXML(source: IXMLNode): string;
var
  target : string;
begin
  try
    target := string(FormatXMLData(source.XML));
  except
    on E:Exception do begin
      target:=source.XML;
    end;
  end;
  result:=target;
end;

procedure TAPI.ProcessChatAllowChanged(Action: TapiAction);
var
  FUser: TUser;
  UserID: Integer;
begin
  FUser := CommonDataModule.ObjectPool.GetUser;

  try
    // get userid
    UserID := StrToIntDef(Action.ActionNode.Attributes['userid'], 0);
    if UserID <= 0 then begin
      CommonDataModule.Log(ClassName, 'ProcessChatAllowChanged',
        '[ERROR] UserID attribute not valid (' +
          Action.ActionNode.Attributes['userid'] + ')',
        ltError);
      Exit;
    end;

    // send user profile
    FUser.SendUserProfile(UserID);
    // notify Engine about change chatallow
    ForEachProcess(Action);
  finally
    CommonDataModule.ObjectPool.FreeUser(FUser);
  end;
end;

procedure TAPI.ProcessResetAllIn(Action: TapiAction);
var
  EMail: TEMail;
begin
  EMail := CommonDataModule.ObjectPool.GetEmail;
  EMail.SendAdminEmail(Action.SessionID, Action.UserID,
    'Reset all-in request from UserID=' + inttostr(Action.UserID), '');
  CommonDataModule.ObjectPool.FreeEmail(EMail);
end;

function TAPI.GetSystemOption(OptionID: Integer; var Data: String): Integer;
var
  SqlAdapter: TSQLAdapter;
  RS: TDataSet;
begin
  Result := PO_NOERRORS;
  if CommonDataModule.ObjectPool.GetConfigValues.GetCachedString(OptionID, Data) then
  begin
    SqlAdapter := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      RS := SqlAdapter.Execute('admGetConfigValue ' + inttostr(OptionID));
      Data := RS.FieldByName('PropertyValue').AsString;
    except
      on e:Exception do
      begin
        Result := PO_ERR_SQLADAPTORINSTANCEFAIL;
        CommonDataModule.Log(ClassName, 'GetSystemOption',
          'OptionID=' + inttostr(OptionID) + ', ' + e.Message, ltException);
      end;
    end;
    CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdapter);
    CommonDataModule.ObjectPool.GetTournamentProcesses.SetCachedString(OptionID, Data);
  end;
end;

function TAPI.GetPushingContentFilesSQL(nType, ProcessID, UserID: Integer; var Data: string): Integer;
var
  FSql: TSQLAdapter;
  DS  : TDataSet;
begin
  {Error result before}
  Result := 0;
  Data   := '';

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    try
      FSql.SetProcName('fmGetPushingContent');
      FSql.AddParInt('UserID', UserID, ptInput);
      FSql.AddParInt('ProcessID', ProcessID, ptInput);
      FSql.AddParInt('TypeID', nType, ptInput);

      DS := FSql.ExecuteCommand;
      DS.First;
      while not DS.Eof do begin
        Data := Data +
          '<file ' +
            'fileid="' + inttostr(rsInt(DS, 'fileID')) + '" ' +
            'name="' + rsStr(DS, 'name') + '" ' +
            'location="' + rsStr(DS, 'location') + '" ' +
            'version="' + inttostr(rsInt(DS, 'version')) + '" ' +
            'size="' + inttostr(rsInt(DS, 'size')) + '" ' +
            'pushingcontenttypeid="' + inttostr(rsInt(DS, 'pushingcontenttypeid')) + '" ' +
          '/>';
        DS.Next;
      end;
    except
      on E: Exception do begin
        CommonDataModule.Log(ClassName, 'GetPushingContentFiles',
          '[EXCEPTION] On execute fmGetPushingContent: Message=' + '[' + E.Message + ']' +
          ',Parameters: UserID=' + inttostr(UserID) + ',ProcessID=' + inttostr(ProcessID) +
          ',Type=' + inttostr(nType)
          ,ltException);

        Result := AP_ERR_SQLERROR;
        Data := '';
      end;
    end;
  finally
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  end;

  Data :=
    '<fmgetpushingcontentfiles ' +
      'result="' + IntToStr(Result) + '" ' +
      'userid="' + IntToStr(UserID) + '" ' +
      'type="' + IfThen(nType = 1, 'lobby', 'table') + '" ' +
      'processid="' + IntToStr(ProcessID) + '">' +
      Data +
    '</fmgetpushingcontentfiles>';
end;

function TAPI.HandResultUserRakes(HandID: Integer; var Data: String): Integer;
var
  FSql: TSQLAdapter;
  aXML: IXMLDocument;
  Root, UserNode: IXMLNode;
  I: Integer;
  // internal XML variables
  nUserID: Integer;
//  nRes: Integer;
  nAmmount,
  nRakeAmmount,
  nTotalRake: Currency;
  sSQL: string;
begin
{ Data is XML like follow
//************************
  <userrakes handid="...">
    <user id="..." amount="..." rakeamount="..." totalrake="..."/>
    ...
    <user id="..." amount="..." rakeamount="..." totalrake="..."/>
  </userrakes>
//************************
}
  CommonDataModule.Log(ClassName, 'HandResultUserRakes', 'Entry: XML=[' + Data + ']', ltCall);

  Result := PO_NOERRORS;

  { Open Data as XML }
  aXML := TXMLDocument.Create(nil);
  aXML.XML.Text := Data;
  try
    aXML.Active := True;
  except
    on E: Exception do begin
      CommonDataModule.Log(ClassName, 'HandResultUserRakes',
        '[EXCEPTION] On open XML document: Message=[' + E.Message + ']',
        ltException
      );

      Result := AP_ERR_CORRUPTREQUESTXML;
      aXML := nil;

      Exit;
    end;
  end;

  { parsing XML }
  Root := aXML.DocumentElement;

  sSQL := '';
  for I:=0 to Root.ChildNodes.Count - 1 do begin
    UserNode := Root.ChildNodes[I];

    nUserID       := -1;
    nAmmount      := -1;
    nTotalRake    := -1;
    nRakeAmmount  := -1;

    if UserNode.HasAttribute('id') then
      nUserID := StrToIntDef(UserNode.Attributes['id'], -1);
    if UserNode.HasAttribute('amount') then
      nAmmount := StrToCurrDef(UserNode.Attributes['amount'], -1);
    if UserNode.HasAttribute('totalrake') then
      nTotalRake := StrToCurrDef(UserNode.Attributes['totalrake'], -1);
    if UserNode.HasAttribute('rakeamount') then
      nRakeAmmount := StrToCurrDef(UserNode.Attributes['rakeamount'], -1);

    { validation UserNode attributes }
    if (nUserID < 0) or (nAmmount < 0) or (nRakeAmmount < 0) or (nTotalRake < 0) then begin
      CommonDataModule.Log(ClassName, 'HandResultUserRakes',
        '[ERROR]: Not correct values of user node attributes; UserNode=[' + UserNode.XML + ']',
        ltError
      );

      Continue;
    end;

    sSQL := sSQL +
      'exec apiHandResultUserRakes ' + IntToStr(nUserID) +
        ', ' + IntToStr(HandID) +
        ', ' + CurrToStr(nAmmount) +
        ', ' + CurrToStr(nTotalRake) +
        ', ' + CurrToStr(nRakeAmmount) + #13#10;
  end;

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    if (sSQL <> '') then FSql.Execute(sSQL);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'HandResultUserRakes',
        '[EXCEPTION] On exec ' + sSQL + ': Message=' + e.Message,
        ltException);
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  aXML := nil;

  CommonDataModule.Log(ClassName, 'HandResultUserRakes', 'Exit: All right.', ltCall);
end;

function TAPI.GetGameRakeRules(RakeRulesTypeID: Integer; var Data: String): Integer;
var
  FSql: TSQLAdapter;
  errCode: Integer;
begin
  Result:=PO_NOERRORS;

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiGetGameRakeRules');
    FSql.addparam('RETURN_VALUE',0,ptResult,ftInteger);
    FSql.addparam('GameRakeRulesTypeID', RakeRulesTypeID, ptInput, ftInteger);
    FSql.addparam('Data', Data, ptOutput, ftString);
    FSql.executecommand();
    errCode := FSql.Getparam('RETURN_VALUE');
    if errCode<>PO_NOERRORS then begin
      CommonDataModule.Log(ClassName, 'GetGameRakeRules',
        '[ERROR] On exec apiGetGameRakeRules Result=' + IntToStr(errCode) +
        '; Params: RakeRulesTypeID=' + IntToStr(RakeRulesTypeID),
        ltError
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_UNKNOWNACTION;
      exit;
    end;
    Data := FSql.Getparam('Data');
  except
    on E:Exception do begin
      CommonDataModule.Log(ClassName, 'GetGameRakeRules',
        '[EXCEPTION] On exec apiGetGameRakeRules :' + e.Message +
        '; Params: RakeRulesTypeID=' + IntToStr(RakeRulesTypeID),
        ltException
      );

      CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
      result := AP_ERR_UNKNOWNACTION;
      exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
end;

procedure TAPI.ProcessGetLeaderBoard(Action: TapiAction);
var
  sText, sItems: string;
  FSql : TSQLAdapter;
  RS: TDataSet;
  RecDate: TDateTime;
  nPos: Integer;
  bIsYesterdayFound: Boolean;
begin
  if CommonDataModule.ObjectPool.GetLeaderBoardCache.GetCachedString(1, sText) then
  begin
    // get Category info
    RecDate := 0;
    nPos := 0;
    bIsYesterdayFound := False;
    sText := '<apgetleaderboard><leaderboardtoday>';
    sItems := '';
    FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      RS := FSql.Execute('execute apiGetLeaderBoardData');
      while not RS.Eof do begin
        if (RecDate = 0) then RecDate := RS.FieldByName('Date').AsDateTime;
        if (RecDate <> RS.FieldByName('Date').AsDateTime) then begin
          nPos := 0;
          bIsYesterdayFound := True;
          RecDate := RS.FieldByName('Date').AsDateTime;
          sText := sText + sItems + '</leaderboardtoday><leaderboardyesterday>';
          sItems := '';
        end;
        Inc(nPos);

        sItems := sItems +
          '<item position="' + IntToStr(nPos) + '" ' +
            'name="' + RS.FieldByName('UserName').AsString + '" ' +
            'amount="' + RS.FieldByName('Balance').AsString + '"' +
          '/>';

        RS.Next;
      end;

      if not bIsYesterdayFound then
        sText := sText + sItems + '</leaderboardtoday><leaderboardyesterday>';
      sText := sText + sItems + '</leaderboardyesterday></apgetleaderboard>';
    except
      on E: Exception do begin
        CommonDataModule.Log(ClassName, 'ProcessGetLeaderBoard',
          '[EXCEPTION]: On exec apiGetLeaderBoardData:' + E.Message,
          ltException
        );
        CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
        sText := GetResponseXMLOnError(Action.Name, PO_ERR_GETTINGXMLASSTRINGFROMSQL);
        Exit;
      end;
    end;
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
    CommonDataModule.ObjectPool.GetLeaderBoardCache.SetCachedString(1, sText);
  end;

  Response.Add(sText, Action.SessionID, Action.UserID).ObjName := APP_PROCESS;
  sText := '';
end;
(*
procedure TAPI.ProcessSparkleCheats(Action: TapiAction);
var
  sProcessName: string;
  nUserID, nProcessNumber: Integer;
  FSql : TSQLAdapter;
  errCode: Integer;
begin
  nUserID := Action.UserID;

  sProcessName := Action.ActionNode.Attributes['processname'];
  if (sProcessName = 'blackjack') then
    nProcessNumber := 1
  else if (sProcessName = 'roulette') then
    nProcessNumber := 2
  else
    Exit;

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiSetUserSparkleCheats');
    FSql.AddParInt('RETURN_VALUE', 0, ptResult);
    FSql.AddParInt('UserID', nUserID, ptInput);
    FSql.AddParInt('ProcessNumber', nProcessNumber, ptInput);

    FSql.ExecuteCommand;

    errCode := FSql.GetParam('RETURN_VALUE');
    if errCode <> 0 then begin
      CommonDataModule.Log(ClassName, 'ProcessSparkleCheats',
        '[ERROR] Error result on exec apiSetSparkleCheats: result=' + IntToStr(errCode),
        ltError
      );
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
      Exit;
    end;
  except
    on E: Exception do begin
      CommonDataModule.Log(ClassName, 'ProcessSparkleCheats',
          '[EXCEPTION]: On exec apiSetSparkleCheats:' + E.Message,
        ltException
      );
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
      Exit;
    end;
  end;

  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
end;
*)

function TAPI.GetBotsDataXMLString: string;
var
  sText: string;
  FSql: TSQLAdapter;
  RS: TDataSet;
begin
  Result := '';
  if CommonDataModule.ObjectPool.GetBotNames.GetCachedString(1, sText) then
  begin
    sText := '<botsdata>';
    FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
    try
      RS := FSql.Execute('execute apiGetBotsData');
      while not RS.Eof do begin
        sText := sText +
          '<bot id="' + RS.FieldByName('ID').AsString + '" ' +
            'firstname="' + RS.FieldByName('FirstName').AsString + '" ' +
            'lastname="' + RS.FieldByName('LastName').AsString + '" ' +
            'loginname="' + RS.FieldByName('LoginName').AsString + '" ' +
            'location="' +  RS.FieldByName('Location').AsString + '" ' +
            'avatarid="' +  RS.FieldByName('AvatarID').AsString + '" ' +
            'sexid="' + RS.FieldByName('SexID').AsString + '" ' +
          '/>';
        RS.Next;
      end;
      sText := sText + '</botsdata>';
    except
      on E: Exception do begin
        CommonDataModule.Log(ClassName, 'GetBotNamesXMLString',
          '[EXCEPTION]: On exec apiGetBotNamesData:' + E.Message,
          ltException
        );
        CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
        Exit;
      end;
    end;
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
    CommonDataModule.ObjectPool.GetBotNames.SetCachedString(1, sText);
  end;

  Result := sText;
  sText := '';
end;

procedure TAPI.ProcessSaveHandHistoryCasino(Action: TapiAction);
var
  FSql : TSQLAdapter;
  nUserID, nSessionID, nGameTypeID: Integer;
  sSql, sData, sGameTypeName: string;
begin
  CommonDataModule.Log(ClassName, 'ProcessSaveHandHistoryCasino',
    'Entry with parameters: UserID=' + IntToStr(Action.UserID) +
    '; SessionID=' + IntToStr(Action.SessionID),
    ltCall
  );

  nUserID := Action.UserID;
  nSessionID := Action.SessionID;

  sGameTypeName := '';
  if Action.ActionNode.HasAttribute('gametype') then
    sGameTypeName := Action.ActionNode.Attributes['gametype'];
  if sGameTypeName = 'blackjack' then
    nGameTypeID := 6
  else if sGameTypeName = 'roulette'  then
    nGameTypeID := 7
  else
    nGameTypeID := 0;
  if nGameTypeID <= 0 then begin
    CommonDataModule.Log(ClassName, 'ProcessSaveHandHistoryCasino',
      '[ERROR]: Invalid attribute "gametype". Command=[' + Action.ActionNode.XML + ']',
      ltError
    );
    Exit;
  end;

  sData := Action.ActionNode.XML;
  sSql := 'execute apiSaveGameLogCasino ''' + sData + ''', ' +
      IntToStr(nUserID) + ', ' +
      IntToStr(nSessionID) + ', ' +
      IntToStr(nGameTypeID);

  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    { execute stored procedure }
    FSql.Execute(sSql);
  finally
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  end;

  CommonDataModule.Log(ClassName, 'ProcessSaveHandHistoryCasino',
    'Exit with parameters: UserID=' + IntToStr(Action.UserID) +
    '; SessionID=' + IntToStr(Action.SessionID),
    ltCall
  );
end;

function TAPI.CheckOnAccessByInvitedUsers(ProcessID, IsTournament, UserID: Integer;
  var IsAllowed: Integer): Integer;
var
  FSql: TSQLAdapter;
begin
  Result := PO_NOERRORS;
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    FSql.SetProcName('apiCheckOnAccessByInvitedUsers');
    FSql.AddParam('RETURN_VALUE', 0, ptResult, ftInteger);
    FSql.AddParam('ProcessID', ProcessID, ptInput, ftInteger);
    FSql.AddParam('IsTournament', IsTournament, ptInput, ftInteger);
    FSql.AddParam('UserID', UserID, ptInput, ftInteger);
    FSql.AddParam('IsAllowed', IsAllowed, ptOutput, ftInteger);
    FSql.ExecuteCommand();
    IsAllowed := FSql.GetParam('IsAllowed');
  except
    on e:Exception do
    begin
      Result := PO_ERR_SQLADAPTORINSTANCEFAIL;
      CommonDataModule.Log(ClassName, 'CheckOnAccessByInvitedUsers',
        '[EXCEPTION] On exec apiCheckOnAccessByInvitedUsers: ' + e.Message +
          '; Params: ProcessID=' + IntToStr(ProcessID) +
          ', IsTournament=' + IntToStr(IsTournament) +
          ', UserID=' + IntToStr(UserID),
        ltException);
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
end;

procedure TAPI.GetTournamentInfo(TournamentID, TournamentCategoryID,
  InfoID: Integer; var Data: string);
var
  SqlAdapter: TSQLAdapter;
  sSql: string;
  RS: TDataSet;
begin
  Data := '';
  SqlAdapter := CommonDataModule.ObjectPool.GetSQLAdapter;
  sSql :=
    'exec apiGetTournamentInfo ' +
      IntToStr(TournamentID) + ', ' +
      IntToStr(TournamentCategoryID) + ', ' +
      IntToStr(InfoID);
  try
    try
      RS := SqlAdapter.Execute(sSql);

      Data := '';
      while not RS.Eof do begin
        Data := Data + RS.FieldByName('Data').AsString;
        RS.Next;
      end
    except
      on e: Exception do begin
        CommonDataModule.Log(ClassName, 'GetTournamentInfo',
        '[EXCEPTION] On exec apiGetTournamentInfo: ' + e.Message +
        '; Params: TournamentID=' + IntToStr(TournamentID) +
        ', TournamentCategoryID=' + IntToStr(TournamentCategoryID) +
        ', InfoID=' + IntToStr(InfoID),
        ltException);
      end;
    end;
  finally
    CommonDataModule.ObjectPool.FreeSQLAdapter(SqlAdapter);
  end;
end;

procedure TAPI.GetTournamentLeaderBoardInfo(sType: string;
  var sData: string);
var
  SQL: TSQLAdapter;
  sSQL: String;
  StrData: String;
  TimeFrom,TimeTo : String;
  TimeFromtoLobby,TimeTotoLobby : String;
  year, month, day, weekOfYear,dayOfWeek, dayOfYear: word;
  tempDate: TDateTime;
begin
  if sType = 'thisweek' then begin
    DecodeDateWeek(Now,year,month,dayOfWeek);
    if DayOfWeek = 7 then DayOfWeek := 0;
    TimeTo := DateTimeToODBCStr(Now); //FormatDateTime('mm/dd/yyyy',Now);
    TimeTotoLobby := FormatDateTime('mmmm dd yyyy hh:nn am/pm',Now);
    TimeFrom := FormatDateTime('mm/dd/yyyy',IncDay(Now,-dayOfWeek));{}
    TimeFromtoLobby := FormatDateTime('mmmm dd yyyy', IncDay(Now,-dayOfWeek));

  end else if sType = 'thismonth' then begin
    DecodeDate(Now,year,month,day);
    TimeTo := DateTimeToODBCStr(Now); // FormatDateTime('mm/dd/yyyy',Now);
    TimeTotoLobby := FormatDateTime('mmmm dd yyyy hh:nn am/pm',Now);
    TimeFrom := FormatDateTime('mm/dd/yyyy',IncDay(Now,-day+1));{}
    TimeFromtoLobby := FormatDateTime('mmmm dd yyyy', IncDay(Now,-day+1));

  end else if sType = 'thisyear' then begin
    DecodeDateDay(Now,year,dayOfYear);
    TimeTo := DateTimeToODBCStr(Now); // FormatDateTime('mm/dd/yyyy',Now);;
    TimeTotoLobby := FormatDateTime('mmmm dd yyyy hh:nn am/pm',Now);
    TimeFrom := FormatDateTime('mm/dd/yyyy',IncDay(Now,-dayOfYear+1));{}
    TimeFromtoLobby := FormatDateTime('mmmm dd yyyy', IncDay(Now,-dayOfYear+1));

  end else if sType = 'previousweek' then begin
    DecodeDateWeek(Now,year,weekOfYear,dayOfWeek);
    if DayOfWeek = 7 then DayOfWeek := 0;
    TimeTo := DateTimeToODBCStr(IncDay(Now,-dayOfWeek-1)); // FormatDateTime('mm/dd/yyyy',IncDay(Now,-dayOfWeek-1));
    TimeTotoLobby := FormatDateTime('mmmm dd yyyy hh:nn am/pm',IncDay(Now,-dayOfWeek-1));
    TimeFrom := FormatDateTime('mm/dd/yyyy',IncDay(Now,-dayOfWeek-7));{}
    TimeFromtoLobby := FormatDateTime('mmmm dd yyyy',IncDay(Now,-dayOfWeek-7));

  end else if sType = 'previousmonth' then begin
    DecodeDate(Now,year,month,day);
    TimeTo := DateTimeToODBCStr(IncDay(Now,-day)); // FormatDateTime('mm/dd/yyyy',IncDay(Now,-day));
    TimeTotoLobby := FormatDateTime('mmmm dd yyyy hh:nn am/pm',IncDay(Now,-day));
    tempDate := IncDay(Now,-day);
    DecodeDate(tempDate,year,month,day);
    TimeFrom := FormatDateTime('mm/dd/yyyy',IncDay(tempDate,-day+1));{}
    TimeFromtoLobby := FormatDateTime('mmmm dd yyyy', IncDay(tempDate,-day+1));

  end else if sType = 'previousyear' then begin
    DecodeDateDay(Now,year,dayOfYear);
    TimeTo := DateTimeToODBCStr(IncDay(Now,-dayOfYear)); // FormatDateTime('mm/dd/yyyy',IncDay(Now,-dayOfYear));
    TimeTotoLobby := FormatDateTime('mmmm dd yyyy hh:nn am/pm',IncDay(Now,-dayOfYear));
    tempDate := IncDay(Now,-dayOfYear);
    DecodeDateDay(tempDate,year,dayOfYear);
    TimeFrom := FormatDateTime('mm/dd/yyyy',IncDay(tempDate,-dayOfYear+1));{}
    TimeFromtoLobby := FormatDateTime('mmmm dd yyyy', IncDay(tempDate,-dayOfYear+1));
  end;

  SQL := CommonDataModule.ObjectPool.GetSQLAdapter;
  sSQL := 'exec srvtouGetTournamentLeaderBoard ' + ''''+TimeFrom+'''' + ', ''' + TimeTo+'''';
  try
    try
      StrData := SQL.ExecuteForXML(sSql);
    except on E: Exception do
      begin
        StrData := '';
        LogException( '{84DB4EC4-E237-43E5-B11A-00BEF9ADDE98}',
          ClassName, 'GetLeaderBoard',
          E.Message + ': On SQL=' + sSQL
        );
      end;
    end;
  finally
    CommonDataModule.ObjectPool.FreeSQLAdapter(SQL);
  end;

  sData :=
    '<togetleaderboard fromtime="' + TimeFromtoLobby + '" ' +
        'totime="' + TimeTotoLobby + '" ' +
        'requesttype="' + sType + '">' +
      StrData +
    '</togetleaderboard>';
end;

function TAPI.GetLeaderPointsToSend(UserID: Integer; FromTime, ToTime: string): Currency;
var
  FSQL: TSQLAdapter;
  Points: Currency;
begin
  Points := 0;

  FSQL := CommonDataModule.ObjectPool.GetSQLAdapter;
  try //finally
    try
      FSQL.SetProcName('srvtouGetTournamentUserLeaderPoints');
      FSQL.AddParam('RETURN_VALUE', 0, ptResult, ftInteger);
      FSQL.AddParInt('UserID', UserId, ptInput);
      FSQL.AddParString('FromTime', FromTime, ptInput);
      FSQL.AddParString('ToTime', ToTime, ptInput);
      FSQL.AddParam('Points', Points, ptOutput, ftCurrency);

      FSql.ExecuteCommand;
      Points := FSQL.GetParam('Points');
    except
      on e : Exception do begin
        LogException('{F3ABC12F-0C1C-4916-8251-F3F2C41B0B46}',
          ClassName, 'GetLeaderPointsToSend',
          '[EXCEPTION]: ' + e.Message + ', UserID = ' + IntToStr(UserID)
        );
      end;
    end;
  finally
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  end;

  Result := Points;
end;

procedure TAPI.TouProcessGetInfo(Action: TapiAction);
var
  sText: string;
  nTournamentID: Integer;
  nTournamentKind: Integer;
begin
  nTournamentID := Action.TournamentID;
  nTournamentKind := 0;
  if Action.ActionNode.HasAttribute('kind') then
    nTournamentKind := StrToIntDef(Action.ActionNode.Attributes['kind'], 0);

  if CommonDataModule.ObjectPool.GetTournamentInfo.GetCachedString(nTournamentID, sText) then
  begin
    GetTournamentInfo(nTournamentID, nTournamentKind, 4, sText);
    CommonDataModule.ObjectPool.GetTournamentInfo.SetCachedString(nTournamentID, sText);
  end;
  Response.Add(sText, Action.SessionID, Action.UserID).ObjName := APP_TOURNAMENT;
  sText := '';
end;

procedure TAPI.TouProcessGetPlayers(Action: TapiAction);
var
  sText: string;
  nTournamentID: Integer;
  nTournamentKind: Integer;
begin
  nTournamentID := Action.TournamentID;
  nTournamentKind := 0;
  if Action.ActionNode.HasAttribute('kind') then
    nTournamentKind := StrToIntDef(Action.ActionNode.Attributes['kind'], 0);

  if CommonDataModule.ObjectPool.GetTournamentPlayers.GetCachedString(nTournamentID, sText) then
  begin
    GetTournamentInfo(nTournamentID, nTournamentKind, 6, sText);
    CommonDataModule.ObjectPool.GetTournamentPlayers.SetCachedString(nTournamentID, sText);
  end;
  Response.Add(sText, Action.SessionID, Action.UserID).ObjName := APP_TOURNAMENT;
  sText := '';
end;

procedure TAPI.TouProcessGetProcesses(Action: TapiAction);
var
  sText: string;
  nTournamentID: Integer;
  nTournamentKind: Integer;
begin
  nTournamentID := Action.TournamentID;
  nTournamentKind := 0;
  if Action.ActionNode.HasAttribute('kind') then
    nTournamentKind := StrToIntDef(Action.ActionNode.Attributes['kind'], 0);

  if CommonDataModule.ObjectPool.GetTournamentProcesses.GetCachedString(nTournamentID, sText) then
  begin
    GetTournamentInfo(nTournamentID, nTournamentKind, 7, sText);
    CommonDataModule.ObjectPool.GetTournamentProcesses.SetCachedString(nTournamentID, sText);
  end;
  Response.Add(sText, Action.SessionID, Action.UserID).ObjName := APP_TOURNAMENT;
  sText := '';
end;

procedure TAPI.TouProcessGetTournamentInfo(Action: TapiAction);
var
  sText: string;
  nTournamentID: Integer;
  nTournamentKind: Integer;
begin
  nTournamentID := Action.TournamentID;
  nTournamentKind := 0;
  if Action.ActionNode.HasAttribute('kind') then
    nTournamentKind := StrToIntDef(Action.ActionNode.Attributes['kind'], 0);

  if CommonDataModule.ObjectPool.GetTournamentInfoAdditional.GetCachedString(nTournamentID, sText) then
  begin
    GetTournamentInfo(nTournamentID, nTournamentKind, 8, sText);
    CommonDataModule.ObjectPool.GetTournamentInfoAdditional.SetCachedString(nTournamentID, sText);
  end;
  Response.Add(sText, Action.SessionID, Action.UserID).ObjName := APP_LOBBY;
  sText := '';
end;

procedure TAPI.TouProcessGetTournaments(Action: TapiAction);
var
  sText: string;
  nTournamentKind: Integer;
begin
  nTournamentKind := 0;
  if Action.ActionNode.HasAttribute('kind') then
    nTournamentKind := StrToIntDef(Action.ActionNode.Attributes['kind'], 0);

  if CommonDataModule.ObjectPool.GetTournaments.GetCachedString(nTournamentKind, sText) then
  begin
    GetTournamentInfo(0, nTournamentKind, nTournamentKind + 1, sText);
    CommonDataModule.ObjectPool.GetTournaments.SetCachedString(nTournamentKind, sText);
  end;
  Response.Add(sText, Action.SessionID, Action.UserID).ObjName := APP_LOBBY;
  sText := '';
end;

procedure TAPI.TouProcessGetLeaderBoard(Action: TapiAction);
var
  sText: string;
  sType: string;
begin
  sType := '';
  if Action.ActionNode.HasAttribute('type') then
    sType := Action.ActionNode.Attributes['type'];

  if CommonDataModule.ObjectPool.GetTournamentLeaderBoard.GetCachedString(1, sText) then
  begin
    GetTournamentLeaderBoardInfo(sType, sText);
    CommonDataModule.ObjectPool.GetTournamentLeaderBoard.SetCachedString(1, sText);
  end;
  Response.Add(sText, Action.SessionID, Action.UserID).ObjName := APP_LOBBY;
  sText := '';
end;

procedure TAPI.TouProcessGetLeaderPoints(Action: TapiAction);
var
  EMail: TEMail;
  Points: Currency;
  mail: string;
  FromTime, ToTime: string;
  nUserID, nSessionID: Integer;
  sText: string;
begin
  nUserID := Action.UserID;
  nSessionID := Action.SessionID;
  FromTime := '';
  ToTime := '';
  if Action.ActionNode.HasAttribute('fromtime') then
    FromTime := Action.ActionNode.Attributes['fromtime'];
  if Action.ActionNode.HasAttribute('totime') then
    ToTime := Action.ActionNode.Attributes['totime'];

  if (FromTime = '') or (ToTime = '') then begin
    CommonDataModule.Log(ClassName, 'GetTournamentLeaderPointsInfo',
      '[ERROR]: Attributes fromtime or to time is not exists or incorrect.' +
        '; Action=[' + Action.ActionNode.XML + ']',
      ltError);
    Exit;
  end;

  EMail := CommonDataModule.ObjectPool.GetEmail;
  try
    Points := GetLeaderPointsToSend(nUserID, FromTime, ToTime);
    EMail.SendUserEmail(
      nSessionID, nUserID,
      'Points',
      'From: ' + FromTime + ' To: ' + ToTime +
      ' Your amount of points is = ' + CurrToStr(Points)
    );

    mail := EMail.GetEmailAddress(nUserID);
  finally
    CommonDataModule.ObjectPool.FreeEmail(EMail);
  end;

  sText :=
    '<togetleaderpoints>' +
      '<data message="Tournament Leader Points has been sent to: '+ mail +'"/>'+
    '</togetleaderpoints>';
  Response.Add(sText, nSessionID, nUserID).ObjName := APP_LOBBY;
end;

procedure TAPI.TouProcessGetLevelsInfo(Action: TapiAction);
var
  sText: string;
  nTournamentID: Integer;
  nTournamentKind: Integer;
begin
  nTournamentID := Action.TournamentID;
  nTournamentKind := 0;
  if Action.ActionNode.HasAttribute('kind') then
    nTournamentKind := StrToIntDef(Action.ActionNode.Attributes['kind'], 0);

  if CommonDataModule.ObjectPool.GetTournamentLevelsInfo.GetCachedString(nTournamentID, sText) then
  begin
    GetTournamentInfo(nTournamentID, nTournamentKind, 5, sText);
    CommonDataModule.ObjectPool.GetTournamentLevelsInfo.SetCachedString(nTournamentID, sText);
  end;
  Response.Add(sText, Action.SessionID, Action.UserID).ObjName := APP_TOURNAMENT;
  sText := '';
end;


procedure TAPI.GetUserIcons(UserID: Integer; FSql: TSQLAdapter;
  var Icon1, Icon2, Icon3, Icon4: string);
var
  SqlWasNil: Boolean;
begin
  Icon1 := '';
  Icon2 := '';
  Icon3 := '';
  Icon4 := '';

  SqlWasNil := (FSql = nil);
  if SqlWasNil then FSql := CommonDataModule.ObjectPool.GetSQLAdapter;

  try
    try
      FSql.SetProcName('apiGetUserIcons');
      FSql.AddParam('RETURN_VALUE', 0, ptResult, ftInteger);
      FSql.AddParInt('UserID', UserID, ptInput);
      FSql.AddParString('Icon1', Icon1, ptOutput);
      FSql.AddParString('Icon2', Icon2, ptOutput);
      FSql.AddParString('Icon3', Icon3, ptOutput);
      FSql.AddParString('Icon4', Icon4, ptOutput);

      FSql.ExecuteCommand();

      Icon1 := FSql.GetParam('Icon1');
      Icon2 := FSql.GetParam('Icon2');
      Icon3 := FSql.GetParam('Icon3');
      Icon4 := FSql.GetParam('Icon4');
    except
      on E:Exception do begin
        CommonDataModule.Log(ClassName, 'GetUserIcons',
          '[EXCEPTION] On exec apiGetUserIcons:' + e.Message +
          '; Params: UserID=' + IntToStr(UserID),
          ltException
        );
      end;
    end;
  finally
    if SqlWasNil then CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  end;
end;

function TAPI.GetPushingContentFiles(nType, ProcessID, UserID: Integer; var Data: string): Integer;
begin
  // Get Cached Data
  Result := 0;
  if nType = 1 then begin
    if CommonDataModule.ObjectPool.GetPushingContentLobbyCache.GetCachedString(UserID, Data) then begin
      Result := GetPushingContentFilesSQL(nType, ProcessID, UserID, Data);
      CommonDataModule.ObjectPool.GetPushingContentLobbyCache.SetCachedString(UserID, Data);
    end;
  end else begin
    if CommonDataModule.ObjectPool.GetPushingContentTableCache.GetCachedString(ProcessID, Data, UserID) then begin
      Result := GetPushingContentFilesSQL(nType, ProcessID, UserID, Data);
      CommonDataModule.ObjectPool.GetPushingContentTableCache.SetCachedString(ProcessID, Data, UserID);
    end;
  end;
end;

end.
