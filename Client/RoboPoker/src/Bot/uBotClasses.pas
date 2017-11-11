unit uBotClasses;

interface

uses Contnrs, XMLDoc, XMLIntF, XMLDom, Classes
  //
  , uBotConstants
  , uBotActions
  ;

type

//******************************************************
// Bot Predeclaration type block
//******************************************************
  TBotTable = class;
  TBotChairList = class;
  TBotChair = class;
  TBotUserList = class;
  TBotUser = class;
  TBotCardList = class;

//******************************************************
// Cards type declaration block
//******************************************************

  TBotCard = class
  private
    FOwner: TBotCardList;
    FSuit: TFixCardSuit;
    FValue: TFixCardValue;
    FOpen: Boolean;
    procedure SetSuit(const Value: TFixCardSuit);
    procedure SetValue(const Value: TFixCardValue);
    procedure SetOpen(const Value: Boolean);
    function GetName: string;
    function GetOpenName: string;
  public
    property Suit: TFixCardSuit read FSuit write SetSuit;
    property Value: TFixCardValue read FValue write SetValue;
    property Open: Boolean read FOpen write SetOpen;
    // read only
    property Name: string read GetName;
    property OpenName: string read GetOpenName;
    property Owner: TBotCardList read FOwner;
    // methods
    function SetContextByName(sName: string): Integer;
    procedure SetContextByObject(aCard: TBotCard);
    //
    function MemorySize: Integer;
    procedure DumpMemory(Level: Integer = 0; sPrefix: string = '');
    //
    constructor Create(aSuit: TFixCardSuit = CS_UNKNOWN; aValue: TFixCardValue = CV_UNKNOWN;
      bOpen: Boolean = False; aOwner: TBotCardList = nil);
  end;

  TBotCardList = class(TObjectList)
  private
    function GetItems(nIndex: Integer): TBotCard;
    function GetItemsByName(sName: string): TBotCard;
    function GetCardNames: string;
    function GetAllOpenCardNames: string;
    function GetAllCloseCardNames: string;
    function GetCountVisible: Integer;
  public
    property Items[nIndex: Integer]: TBotCard read GetItems;
    property ItemsByName[sName: string]: TBotCard read GetItemsByName;
    property CardNames: string read GetCardNames;
    property AllOpenCardNames: string read GetAllOpenCardNames;
    property AllCloseCardNames: string read GetAllCloseCardNames;
    property CountVisible: Integer read GetCountVisible;
    //
    function Add(aCard: TBotCard): TBotCard;
    function Ins(nIndex: Integer; aCard: TBotCard): TBotCard;
    procedure Del(aCard: TBotCard);
    procedure DelByInd(nIndex: Integer);
    //
    function SetContextByNames(sNames: string): Integer;
    procedure SetContextByObject(aCards: TBotCardList);
    //
    function MemorySize: Integer;
    procedure DumpMemory(Level: Integer = 0; sPrefix: string = '');
    //
    constructor Create;
    destructor Destroy; override;
  end;

//******************************************************
// Bot Table type block
//******************************************************
  TBotTableList = class;

  TBotTable = class
  private
    FAllIn: Boolean;
    FStakeType: TFixStakeType;
    FCurrencyID: Integer;
    FChairsCount: Integer;
    FPrevHandID: Integer;
    FRake: Integer;
    FGameType: TFixGameType;
    FMinBuyIn: Integer;
    FProcessID: Integer;
    FRound: Integer;
    FMaxBuyIn: Integer;
    FMaxStake: Integer;
    FTournamentRake: Integer;
    FHandID: Integer;
    FTournamentType: TFixTournamentType;
    FMinStake: Integer;
    FDefBuyIn: Integer;
    FTournamentBuyIn: Integer;
    FEngineVersion: string;
    FCurrencySign: string;
    FName: string;
    FCards: TBotCardList;
    FChairs: TBotChairList;
    FUsers: TBotUserList;
    FProcesses: TBotTableList;
    FTournamentChips: Integer;
    FProcInitStatus: TFixProcInitStatus;
    FProcStateStatus: TFixProcStateStatus;
    FCustomAnswer: Boolean;
    FMoveBetsIsShow: Boolean;
    FPotsIsShow: Boolean;
    FTimeOutForSitDown: TDateTime;
    FLastTimeActivity: TDateTime;
    procedure SetAllIn(const Value: Boolean);
    procedure SetChairsCount(const Value: Integer);
    procedure SetCurrencyID(const Value: Integer);
    procedure SetCurrencySign(const Value: string);
    procedure SetDefBuyIn(const Value: Integer);
    procedure SetEngineVersion(const Value: string);
    procedure SetHandID(const Value: Integer);
    procedure SetTournamentType(const Value: TFixTournamentType);
    procedure SetMaxBuyIn(const Value: Integer);
    procedure SetMaxStake(const Value: Integer);
    procedure SetMinBuyIn(const Value: Integer);
    procedure SetMinStake(const Value: Integer);
    procedure SetName(const Value: string);
    procedure SetGameType(const Value: TFixGameType);
    procedure SetPrevHandID(const Value: Integer);
    procedure SetProcessID(const Value: Integer);
    procedure SetRake(const Value: Integer);
    procedure SetRound(const Value: Integer);
    procedure SetStakeType(const Value: TFixStakeType);
    procedure SetTournamentBuyIn(const Value: Integer);
    procedure SetTournamentRake(const Value: Integer);
    procedure SetTournamentChips(const Value: Integer);
    procedure SetProcInitStatus(const Value: TFixProcInitStatus);
    procedure SetProcStateStatus(const Value: TFixProcStateStatus);
    procedure SetCustomAnswer(const Value: Boolean);
    procedure SetTimeOutForSitDown(const Value: TDateTime);
    procedure SetLastTimeActivity(const Value: TDateTime);
  public
    property ProcessID: Integer read FProcessID write SetProcessID;
    property EngineVersion: string read FEngineVersion write SetEngineVersion;
    property Name: string read FName write SetName;
    property GameType: TFixGameType read FGameType write SetGameType;
    property ChairsCount: Integer read FChairsCount write SetChairsCount;
    property CurrencyID: Integer read FCurrencyID write SetCurrencyID;
    property CurrencySign: string read FCurrencySign write SetCurrencySign;
    property StakeType: TFixStakeType read FStakeType write SetStakeType;
    property AllIn: Boolean read FAllIn write SetAllIn;
    property MaxBuyIn: Integer read FMaxBuyIn write SetMaxBuyIn; // Cents
    property MinBuyIn: Integer read FMinBuyIn write SetMinBuyIn; // Cents
    property DefBuyIn: Integer read FDefBuyIn write SetDefBuyIn; // Cents
    //
    property TournamentType: TFixTournamentType read FTournamentType write SetTournamentType;
    property TournamentBuyIn: Integer read FTournamentBuyIn write SetTournamentBuyIn; // Cents
    property TournamentRake: Integer read FTournamentRake write SetTournamentRake;    // Cents
    property TournamentChips: Integer read FTournamentChips write SetTournamentChips; // Cents
    //
    property HandID: Integer read FHandID write SetHandID;
    property PrevHandID: Integer read FPrevHandID write SetPrevHandID;
    property Round: Integer read FRound write SetRound;
    property MinStake: Integer read FMinStake write SetMinStake; // Cents
    property MaxStake: Integer read FMaxStake write SetMaxStake; // Cents
    property Rake: Integer read FRake write SetRake;             // Cents
    //
    property ProcInitStatus: TFixProcInitStatus read FProcInitStatus write SetProcInitStatus;
    property ProcStateStatus: TFixProcStateStatus read FProcStateStatus write SetProcStateStatus;
    property CustomAnswer: Boolean read FCustomAnswer write SetCustomAnswer;
    property TimeOutForSitDown: TDateTime read FTimeOutForSitDown write SetTimeOutForSitDown;
    property LastTimeActivity: TDateTime read FLastTimeActivity write SetLastTimeActivity;
    //
    property Cards: TBotCardList read FCards;
    property Chairs: TBotChairList read FChairs;
    property Users: TBotUserList read FUsers;
    property Processes: TBotTableList read FProcesses;
    // methods
    procedure SetContextByObject(aTable: TBotTable);
    function GameTypeName: string;
    function StakeTypeName: string;
    function TournamentTypeName: string;
    // Perform methods based on input actions XML
    procedure PerformStandUpAllBots(NeedLeaveTableResponse: Boolean = False);
    procedure PerformStandUpAllNotBots;
    //
    function ValidateAction(aAction: TBotInputAction; WithActionsType: TFixActionSet;
      var aChair: TBotChair; var aUser: TBotUser): Boolean;
    procedure PerformGaCrash(aAction: TBotInputAction);
    procedure PerformProcClose(aAction: TBotInputAction);
    procedure PerformProcInit(aAction: TBotInputAction);
    procedure PerformProcState(aAction: TBotInputAction);
    procedure PerformCommunityCards(aNode: IXMLNode; nHandID, nRound: Integer);
    procedure PerformFinalPot(aNode: IXMLNode;
      nUserID, nHandID, nRound: Integer);
    procedure PerformRake(aNode: IXMLNode; nHandID, nRound: Integer);
    procedure PerformChairs(aNode: IXMLNode; aPersonUser: TBotUser = nil);
    procedure PerformChair(aNode: IXMLNode; aChair: TBotChair = nil; aPersonUser: TBotUser = nil);
    function PerformSetActivePlayer(aAction: TBotInputAction): string;
    function PerformMoveBets(aAction: TBotInputAction): string;
    function PerformDialCards(aAction: TBotInputAction): string;
    function PerformEndRound(aAction: TBotInputAction): string;
    function PerformFinishHand(aAction: TBotInputAction): string;
    function PerformMessage(aAction: TBotInputAction): string;
    function PerformWinner(aNode: IXMLNode; nHandID, nRound: Integer): string;
    function PerformRanking(aAction: TBotInputAction): string;
    // perform game actions
    function PerformSitOut(aAction: TBotInputAction): string;
    function PerformSitOutNextHand(aAction: TBotInputAction): string;
    function PerformMoreChips(aAction: TBotInputAction): string;
    function PerformWaitBB(aAction: TBotInputAction): string;
    function PerformFold(aAction: TBotInputAction): string;
    function PerformChangeAmountActions(aAction: TBotInputAction): string;
    function PerformShowDownActions(aAction: TBotInputAction): string;
    //
    function BotMoreChips(aUser: TBotUser; Amount: Currency): string;
    function BotBackToGame(aUser: TBotUser): string;
    function GetActionNodeByAnswerButton(aButton: TBotAvailableAnswer): string;
    //
    function MemorySize: Integer;
    procedure DumpMemory(Level: Integer = 0; sPrefix: string = '');
    //
    constructor Create(aProcesses: TBotTableList = nil);
    destructor Destroy; override;
  end;

  TBotTableList = class(TObjectList)
  private
    FImmResponses: TBotResponseList;
    FWaitResponses: TBotResponseList;
    function GetItems(nIndex: Integer): TBotTable;
  public
    property Items[nIndex: Integer]: TBotTable read GetItems;
    //
    property ImmResponses: TBotResponseList read FImmResponses;
    property WaitResponses: TBotResponseList read FWaitResponses;
    //
    function Add(aTable: TBotTable): TBotTable;
    function Ins(nIndex: Integer; aTable: TBotTable): TBotTable;
    procedure Del(aTable: TBotTable);
    procedure DelByInd(nIndex: Integer);
    //
    function TableByProcessID(nProcessID: Integer): TBotTable;
    //
    procedure OnResponse(sResponse: string;
      aType: TFixVisualizationType; aActionType: TFixAction;
      DateEntry: TDateTime; nProcessID, nUserID: Integer
    );
    //
    function MemorySize: Integer;
    procedure DumpMemory(Level: Integer = 0; sPrefix: string = '');
    //
    constructor Create(aImmResp, aWaitResp: TBotResponseList);
    destructor Destroy; override;
  end;


//******************************************************
// Bot Chairs type block
//******************************************************
  TBotChair = class
  private
    FUserID: Integer;
    FReservationUserID: Integer;
    FChairs: TBotChairList;
    FState: TFixChairState;
    FIsDialer: Integer;
    FPosition: Integer;
    FIsActive: Boolean;
    FTurnTime: Integer;
    FTimeBank: Integer;
    procedure SetReservationUserID(const Value: Integer);
    procedure SetUserID(const Value: Integer);
    procedure SetState(const Value: TFixChairState);
    procedure SetIsDialer(const Value: Integer);
    procedure SetPosition(const Value: Integer);
    function GetTable: TBotTable;
    function GetUser: TBotUser;
    procedure SetIsActive(const Value: Boolean);
    function GetProcessID: Integer;
    function GetProcInitStatus: TFixProcInitStatus;
    function GetProcStateStatus: TFixProcStateStatus;
    procedure SetTimeBank(const Value: Integer);
    procedure SetTurnTime(const Value: Integer);
  public
    property Position: Integer read FPosition write SetPosition;
    property State: TFixChairState read FState write SetState;
    property UserID: Integer read FUserID write SetUserID;
    property ReservationUserID: Integer read FReservationUserID write SetReservationUserID;
    property IsDialer: Integer read FIsDialer write SetIsDialer;  // 0 - is not dialer; 1 - is dialer
    property IsActive: Boolean read FIsActive write SetIsActive;
    property TimeBank: Integer read FTimeBank write SetTimeBank;
    property TurnTime: Integer read FTurnTime write SetTurnTime;
    //
    property Chairs: TBotChairList read FChairs; // owner
    property Table: TBotTable read GetTable;
    property User: TBotUser read GetUser;
    property ProcessID: Integer read GetProcessID;
    property ProcInitStatus: TFixProcInitStatus read GetProcInitStatus;
    property ProcStateStatus: TFixProcStateStatus read GetProcStateStatus;
    //
    procedure SetContextByObject(aChair: TBotChair);
    function StateName: string;
    //
    function MemorySize: Integer;
    procedure DumpMemory(Level: Integer = 0; sPrefix: string = '');
    //
    constructor Create(aChairs: TBotChairList = nil);
  end;

  TBotChairList = class(TObjectList)
  private
    FTable: TBotTable;
    function GetItems(nIndex: Integer): TBotChair;
    function GetCountOfBuzy: Integer;
    function GetCountOfNotBots: Integer;
  public
    property Items[nIndex: Integer]: TBotChair read GetItems;
    property Table: TBotTable read FTable;
    property CountOfBuzy: Integer read GetCountOfBuzy;
    property CountOfNotBots: Integer read GetCountOfNotBots;
    //
    function Add(aChair: TBotChair): TBotChair;
    function Ins(nIndex: Integer; aChair: TBotChair): TBotChair;
    procedure Del(aChair: TBotChair);
    procedure DelByInd(nIndex: Integer);
    //
    procedure SetContextByObject(aChairs: TBotChairList);
    function ChairByPosition(nPosition: Integer): TBotChair;
    function ChairByUserID(nUserID: Integer): TBotChair;
    //
    function MemorySize: Integer;
    procedure DumpMemory(Level: Integer = 0; sPrefix: string = '');
    //
    constructor Create(aTable: TBotTable = nil);
    destructor Destroy; override;
  end;

//******************************************************
// Bot users type declaration block
//******************************************************

  TBotUser = class
  private
    FState: TFixUserState;
    FBetsAmmount: Integer;
    FCurrAmmount: Integer;
    FCards: TBotCardList;
    FGameQualification: TFixGameQualify;
    FInGame: Integer;
    FPosition: Integer;
    FUserID: Integer;
    FUsers: TBotUserList;
    FProcInitStatus: TFixProcInitStatus;
    FProcStateStatus: TFixProcStateStatus;
    FCharacter: TFixUserCharacter;
    FAvailableAnwers: TBotAvailableAnswerList;
    FIsBot: Boolean;
    FLastAction: TFixAction;
    FName: string;
    FConnected: Boolean;
    FAutoSitDown: Boolean;
    FBlaffersEvent: Integer;
    procedure SetBetsAmmount(const Value: Integer);
    procedure SetCurrAmmount(const Value: Integer);
    procedure SetState(const Value: TFixUserState);
    procedure SetGameQualification(const Value: TFixGameQualify);
    function GetChair: TBotChair;
    procedure SetInGame(const Value: Integer);
    function GetChairs: TBotChairList;
    procedure SetUserID(const Value: Integer);
    procedure SetPosition(const Value: Integer);
    function GetTable: TBotTable;
    procedure SetProcInitStatus(const Value: TFixProcInitStatus);
    procedure SetProcStateStatus(const Value: TFixProcStateStatus);
    function GetIsWatcher: Boolean;
    procedure SetCharacter(const Value: TFixUserCharacter);
    function GetNameOfCharacter: string;
    function GetNameOfQualification: string;
    procedure SetIsBot(const Value: Boolean);
    procedure SetLastAction(const Value: TFixAction);
    function GetNameOfState: string;
    procedure SetName(const Value: string);
    function GetIsActive: Boolean;
    function GetTimeBank: Integer;
    function GetTurnTime: Integer;
    procedure SetConnected(const Value: Boolean);
    procedure SetAutoSitDown(const Value: Boolean);
    procedure SetBlaffersEvent(const Value: Integer);
  public
    // game state properties
    property Name: string read FName write SetName;
    property UserID: Integer read FUserID write SetUserID;
    property Position: Integer read FPosition write SetPosition;
    property State: TFixUserState read FState write SetState;
    property CurrAmmount: Integer read FCurrAmmount write SetCurrAmmount; // is Cents
    property BetsAmmount: Integer read FBetsAmmount write SetBetsAmmount; // is Cents
    property InGame: Integer read FInGame write SetInGame;
    property ProcInitStatus: TFixProcInitStatus read FProcInitStatus write SetProcInitStatus;
    property ProcStateStatus: TFixProcStateStatus read FProcStateStatus write SetProcStateStatus;
    property Connected: Boolean read FConnected write SetConnected;
    // special properties
    property IsBot: Boolean read FIsBot write SetIsBot;
    property GameQualification: TFixGameQualify read FGameQualification write SetGameQualification;
    property Character: TFixUserCharacter read FCharacter write SetCharacter;
    property AvailableAnwers: TBotAvailableAnswerList read FAvailableAnwers;
    property LastAction: TFixAction read FLastAction write SetLastAction;
    property AutoSitDown: Boolean read FAutoSitDown write SetAutoSitDown;
    property BlaffersEvent: Integer read FBlaffersEvent write SetBlaffersEvent;
    // read only
    property NameOfState: string read GetNameOfState;
    property NameOfQualification: string read GetNameOfQualification;
    property NameOfCharacter: string read GetNameOfCharacter;
    property IsWatcher: Boolean read GetIsWatcher;
    property TimeBank: Integer read GetTimeBank;
    property TurnTime: Integer read GetTurnTime;
    property IsActive: Boolean read GetIsActive;
    property Users: TBotUserList read FUsers;
    property Cards: TBotCardList read FCards;
    property Table: TBotTable read GetTable;
    property Chairs: TBotChairList read GetChairs;
    property Chair: TBotChair read GetChair;
    //
    procedure SetContextByObject(aUser: TBotUser);
    procedure SetContextByNodePlayer(aNode: IXMLNode);
    //
    function PositionUnderDealer: Integer; // 0-EARLY; 1-MIDDLE; 2-LATE
    //
    function MemorySize: Integer;
    procedure DumpMemory(Level: Integer = 0; sPrefix: string = '');
    //
    constructor Create(aUsers: TBotUserList);
    destructor Destroy; override;
  end;

  TBotUserList = class(TObjectList)
  private
    FTable: TBotTable;
    function GetItems(nIndex: Integer): TBotUser;
  public
    property Items[nIndex: Integer]: TBotUser read GetItems;
    property Table: TBotTable read FTable;
    // methods
    function Add(aUser: TBotUser): TBotUser;
    function Ins(nIndex: Integer; aUser: TBotUser): TBotUser;
    procedure Del(aUser: TBotUser);
    procedure DelByInd(nIndex: Integer);
    //
    function UserByPosition(nPos: Integer): TBotUser;
    function UserByID(nID: Integer): TBotUser;
    procedure SetContextByObject(aUsers: TBotUserList);
    function SitDownUser(nUserID, Position, Amount: Integer): TBotUser;
    function StandUpUser(Position: Integer): TBotUser;
    procedure KickOfUser(aUser: TBotUser);
    // count functions
    function CountOfBots: Integer;
    function CountOfActive: Integer;
    function CountOfBotWatchers: Integer;
    function CountWatchers: Integer;
    function CountWithLastAction(aLastAction: TFixAction): Integer;
    //
    function MemorySize: Integer;
    procedure DumpMemory(Level: Integer = 0; sPrefix: string = '');
    //
    constructor Create(aTable: TBotTable = nil);
    destructor Destroy; override;
  end;

implementation

uses SysUtils, DateUtils, Math, StrUtils
  //
  , uResponseProcessor
  , uBotForm
  , uConstants
  , uCommonDataModule
  , uLogger;

{ TBotCard }

constructor TBotCard.Create(aSuit: TFixCardSuit; aValue: TFixCardValue;
  bOpen: Boolean; aOwner: TBotCardList);
begin
  inherited Create;
  FSuit  := aSuit;
  FValue := aValue;
  FOpen  := bOpen;
  FOwner := aOwner;
end;

procedure TBotCard.DumpMemory(Level: Integer; sPrefix: string);
var
  sShift: string;
begin
  if Level > 0 then sShift := DupeString(Shift_string_On_DumpMemory, Level) else sShift := '';
  Logger.Log(0, ClassName, 'DumpMemory',
    sShift + '[SIZE]: ' + IntToStr(MemorySize), ltCall);

  sShift := '';
end;

function TBotCard.GetName: string;
begin
  if ( (FValue = CV_UNKNOWN) and (FSuit = CS_UNKNOWN) ) or (not FOpen) then begin
    Result := 'back';
  end else begin
    Result := GetFixCardValueAsString(FValue) + GetFixCardSuitAsString(FSuit);
  end;
end;

function TBotCard.GetOpenName: string;
begin
  if (FValue = CV_UNKNOWN) and (FSuit = CS_UNKNOWN) then begin
    Result := 'back';
  end else begin
    Result := GetFixCardValueAsString(FValue) + GetFixCardSuitAsString(FSuit);
  end;
end;

function TBotCard.MemorySize: Integer;
begin
  Result :=
    SizeOf(FSuit) +
    SizeOf(FValue) +
    SizeOf(FOpen);
end;

function TBotCard.SetContextByName(sName: string): Integer;
var
  TempName: string;
begin
  Result := 0;
  TempName := '';

  // validation name
  if Length(sName) < 2 then begin
    Result := 1;
    Exit;
  end;

  TempName := AnsiUpperCase(Trim(sName));
  if not (TempName = 'BACK') then begin
    if not (TempName[1] in ['2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A']) then begin
      Result := 2;
      TempName := '';
      Exit;
    end;

    if not (TempName[2] in ['C', 'D', 'H', 'S']) then begin
      Result := 3;
      TempName := '';
      Exit;
    end;

    // set card value
    case TempName[1] of
      '2': FValue := CV_2;
      '3': FValue := CV_3;
      '4': FValue := CV_4;
      '5': FValue := CV_5;
      '6': FValue := CV_6;
      '7': FValue := CV_7;
      '8': FValue := CV_8;
      '9': FValue := CV_9;
      'T': FValue := CV_10;
      'J': FValue := CV_JACK;
      'Q': FValue := CV_QUEEN;
      'K': FValue := CV_KING;
      'A': FValue := CV_ACE;
    end;

    // set card suit
    case TempName[2] of
      'C': FSuit := CS_CLUB;
      'D': FSuit := CS_DIAMOND;
      'H': FSuit := CS_HEART;
      'S': FSuit := CS_SPADE;
    end;

    FOpen := True;
  end else begin
    FSuit  := CS_UNKNOWN;
    FValue := CV_UNKNOWN;
    FOpen  := False;
  end;

  TempName := '';
end;

procedure TBotCard.SetContextByObject(aCard: TBotCard);
begin
  if aCard = nil then Exit;

  FOwner := aCard.FOwner;
  FSuit  := aCard.FSuit;
  FValue := aCard.FValue;
  FOpen  := aCard.FOpen;
end;

procedure TBotCard.SetOpen(const Value: Boolean);
begin
  FOpen := Value;
end;

procedure TBotCard.SetSuit(const Value: TFixCardSuit);
begin
  FSuit := Value;
end;

procedure TBotCard.SetValue(const Value: TFixCardValue);
begin
  FValue := Value;
end;

{ TBotCardList }

function TBotCardList.Add(aCard: TBotCard): TBotCard;
begin
  Result := aCard;
  Result.FOwner := Self;
  inherited Add(Result as TObject);
end;

constructor TBotCardList.Create;
begin
  inherited Create;
end;

procedure TBotCardList.Del(aCard: TBotCard);
begin
  inherited Remove(aCard);
end;

procedure TBotCardList.DelByInd(nIndex: Integer);
var
  aCard: TBotCard;
begin
  aCard := Items[nIndex];
  Del(aCard);
end;

destructor TBotCardList.Destroy;
begin
  Clear;
  inherited;
end;

function TBotCardList.GetItemsByName(sName: string): TBotCard;
var
  I: Integer;
  TmpName: string;
  aCard: TBotCard;
begin
  Result := nil;
  TmpName := Trim(AnsiUpperCase(sName));
  for I:=0 to Count - 1 do begin
    aCard := Items[I];
    if (TmpName = aCard.Name) then begin
      Result := aCard;
      TmpName := '';
      Exit;
    end;
  end;

  TmpName := '';
end;

function TBotCardList.GetItems(nIndex: Integer): TBotCard;
begin
  Result := inherited Items[nIndex] as TBotCard;
end;

function TBotCardList.Ins(nIndex: Integer; aCard: TBotCard): TBotCard;
begin
  Result := aCard;
  Result.FOwner := Self;
  inherited Insert(nIndex, (Result as TObject));
end;

function TBotCardList.SetContextByNames(sNames: string): Integer;
var
  sText, sCardName: string;
  nPos: Integer;
  aCardList: TBotCardList;
  aCard: TBotCard;
  I: Integer;
begin
//---------------------------------------
// WARNING: Context be setting on new items
//---------------------------------------
  Result := 0;

  sText := Trim(sNames);
  if (sText = '') then begin
    Clear;
    sText := '';
    sCardName := '';
    Exit;
  end;

  // validate
  if (Length(sText) < 2) then begin
    Result := 1;
    sText := '';
    sCardName := '';
    Exit;
  end;

  aCardList := TBotCardList.Create;

  while (Length(sText) > 1) do begin
    nPos := Pos(DELIMETER, sText);
    if nPos > 0 then sCardName := Trim(Copy(sText, 1, nPos - 1))
    else sCardName := Trim(sText);

    aCard := TBotCard.Create();
    if aCard.SetContextByName(sCardName) <> 0 then begin
      sText := ''; //for exit
      aCard.Free;
      Result := 2;
    end else begin
      aCardList.Add(aCard);
      if nPos > 0 then sText := Trim(Copy(sText, nPos + 1, MaxInt))
      else sText := '';
    end;
  end;

  Clear;
  if (Result = 0) then begin
    for I:=0 to aCardList.Count - 1 do begin
      aCard := aCardList.Items[I];
      aCard := TBotCard.Create(aCard.FSuit, aCard.FValue, aCard.FOpen, Self);
      Add(aCard);
    end;
  end;

  aCardList.Clear;
  aCardList.Free;

  sText := '';
  sCardName := '';
end;

procedure TBotCardList.SetContextByObject(aCards: TBotCardList);
var
  I: Integer;
  aCard: TBotCard;
begin
//---------------------------------------
// WARNING: Context be setting on new items
//---------------------------------------
  Clear;
  for I:=0 to aCards.Count - 1 do begin
    aCard := aCards.Items[I];
    aCard := TBotCard.Create(aCard.FSuit, aCard.FValue, aCard.FOpen, Self);
    Add(aCard);
  end;
end;

function TBotCardList.GetCardNames: string;
var
  I: Integer;
begin
  Result := '';
  if (Count <= 0) then Exit;
  for I:=0 to Count - 1 do begin
    if (I < (Count - 1)) then
      Result := Result + Items[I].Name + ','
    else
      Result := Result + Items[I].Name;
  end;
end;

function TBotCardList.GetAllOpenCardNames: string;
var
  I: Integer;
begin
  Result := '';
  if (Count <= 0) then Exit;
  for I:=0 to Count - 1 do begin
    if (I < (Count - 1)) then
      Result := Result + Items[I].OpenName + ','
    else
      Result := Result + Items[I].OpenName;
  end;
end;

function TBotCardList.GetAllCloseCardNames: string;
var
  I: Integer;
begin
  Result := '';
  if (Count <= 0) then Exit;
  for I:=0 to Count - 1 do begin
    if (I < (Count - 1)) then
      Result := Result + 'back,'
    else
      Result := Result + 'back';
  end;
end;

function TBotCardList.GetCountVisible: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I:=0 to Count - 1 do
    if Items[I].FOpen then Inc(Result);
end;

procedure TBotCardList.DumpMemory(Level: Integer; sPrefix: string);
var
{$IFDEF DumpItems_ON_MemoryDump}
  I: Integer;
{$ENDIF}
  sShift: string;
begin
  if Level > 0 then sShift := DupeString(Shift_string_On_DumpMemory, Level) else sShift := '';
  Logger.Log(0, ClassName, 'DumpMemory',
    sShift + sPrefix + '[SIZE]: ' + IntToStr(MemorySize), ltCall);

{$IFDEF DumpItems_ON_MemoryDump}
  for I:=0 to Count - 1 do
    Items[I].DumpMemory(Level + 1, sPrefix + '; Items(' + IntToStr(I) + ')');
{$ENDIF}

  sShift := '';
end;

function TBotCardList.MemorySize: Integer;
var
  I: Integer;
begin
  Result := SizeOf(Self);
  for I:=0 to Count - 1 do
    Result := Result + Items[I].MemorySize;
end;

{ TBotUser }

constructor TBotUser.Create(aUsers: TBotUserList);
begin
  inherited Create;

  FName := '';

  FUsers := aUsers;
  FCards := TBotCardList.Create;
  FAvailableAnwers := TBotAvailableAnswerList.Create;

  // defoult values initialize
  FIsBot := False;
  FState := US_SITOUT;
  FBetsAmmount := 0;
  FCurrAmmount := 10000;
  FGameQualification := PQ_AUTOMAT;
  FCharacter := UCH_NORMAL;
  FInGame := 0;
  FPosition := -1;
  FProcInitStatus := PIS_NEEDREQUEST;
  FProcStateStatus := PSS_NEEDREQUEST;
  FConnected := True;
  FAutoSitDown := False;
  FBlaffersEvent := MIN_COUNT_ONBLAFFERS + Random(MAX_COUNT_ONBLAFFERS - MIN_COUNT_ONBLAFFERS);
end;

destructor TBotUser.Destroy;
begin
  FName := '';

  FCards.Free;
  FAvailableAnwers.Free;
  inherited;
end;

function TBotUser.GetChair: TBotChair;
begin
  Result := nil;
  if (FPosition < 0) then Exit;
  if (Chairs = nil) then Exit;

  Result := Chairs.Items[FPosition];
end;

function TBotUser.GetChairs: TBotChairList;
begin
  Result := nil;
  if (Table = nil) then Exit;

  Result := Table.FChairs;
end;

function TBotUser.GetIsWatcher: Boolean;
begin
  Result := ((FUserID <= 0) or (FPosition < 0));
end;

function TBotUser.GetTable: TBotTable;
begin
  Result := nil;
  if (FUsers = nil) then Exit;

  Result := FUsers.FTable;
end;

procedure TBotUser.SetBetsAmmount(const Value: Integer);
begin
  FBetsAmmount := Value;
end;

procedure TBotUser.SetContextByObject(aUser: TBotUser);
begin
  FState             := aUser.FState;
  FBetsAmmount       := aUser.FBetsAmmount;
  FCurrAmmount       := aUser.FCurrAmmount;

  FCards.SetContextByObject(aUser.FCards);

  FGameQualification := aUser.FGameQualification;
  FCharacter         := aUser.FCharacter;
  FInGame            := aUser.FInGame;
  FPosition          := aUser.FPosition;
  FUserID            := aUser.FUserID;
  FProcInitStatus    := aUser.FProcInitStatus;
  FProcStateStatus   := aUser.FProcStateStatus;
end;

procedure TBotUser.SetCurrAmmount(const Value: Integer);
begin
  FCurrAmmount := Value;
end;

procedure TBotUser.SetGameQualification(const Value: TFixGameQualify);
begin
  FGameQualification := Value;
end;

procedure TBotUser.SetInGame(const Value: Integer);
begin
  FInGame := Value;
end;

procedure TBotUser.SetProcInitStatus(const Value: TFixProcInitStatus);
begin
  FProcInitStatus := Value;
  if (Value = PIS_NEEDREQUEST) then FProcStateStatus := PSS_NEEDREQUEST;
end;

procedure TBotUser.SetProcStateStatus(const Value: TFixProcStateStatus);
begin
  FProcStateStatus := Value;
end;

procedure TBotUser.SetPosition(const Value: Integer);
begin
  FPosition := Value;
end;

procedure TBotUser.SetState(const Value: TFixUserState);
begin
  FState := Value;
end;

procedure TBotUser.SetUserID(const Value: Integer);
begin
  FUserID := Value;
end;

procedure TBotUser.SetContextByNodePlayer(aNode: IXMLNode);
var
  sAttrValue: string;
begin
  if (aNode.NodeName <> NODE_PLAYER) then Exit;

  FCurrAmmount := 0;
  if aNode.HasAttribute(ATTR_BALANCE) then
    FCurrAmmount := Trunc( StrToCurrDef(aNode.Attributes[ATTR_BALANCE], 0) * 100 );
  if (FCurrAmmount < 0) then FCurrAmmount := 0;

  FBetsAmmount := 0;
  if aNode.HasAttribute(ATTR_BET) then
    FBetsAmmount := Trunc( StrToCurrDef(aNode.Attributes[ATTR_BET], 0) * 100 );

  FCards.Clear;
  if aNode.HasAttribute(ATTR_CARDS) then
    FCards.SetContextByNames(aNode.Attributes[ATTR_CARDS]);

  FState := US_SITOUT;
  if aNode.HasAttribute(ATTR_STATUS) then begin
    sAttrValue := aNode.Attributes[ATTR_STATUS];
    if (sAttrValue = NAME_PLAYING) then FState := US_PLAYING else
    if (sAttrValue = NAME_DISCONNECTED) then FState := US_DISCONNECTED;
  end;

  FInGame := 0;
  if aNode.HasAttribute(ATTR_INGAME) then
    FInGame := StrToIntDef(aNode.Attributes[ATTR_INGAME], 0);

  FName := '';
  if aNode.HasAttribute(ATTR_NAME) then
    FName := aNode.Attributes[ATTR_NAME];

  sAttrValue := '';
end;

procedure TBotUser.SetCharacter(const Value: TFixUserCharacter);
begin
  FCharacter := Value;
end;

function TBotUser.GetNameOfCharacter: string;
begin
  Result := GetFixUserCharacter(FCharacter);
end;

function TBotUser.GetNameOfQualification: string;
begin
  Result := GetFixGameQualifyAsString(FGameQualification);
end;

procedure TBotUser.SetIsBot(const Value: Boolean);
begin
  FIsBot := Value;
end;

procedure TBotUser.SetLastAction(const Value: TFixAction);
begin
  FLastAction := Value;
end;

function TBotUser.GetNameOfState: string;
begin
  Result := GetFixUserStateAsString(FState);
end;

procedure TBotUser.SetName(const Value: string);
begin
  FName := Value;
end;

function TBotUser.GetIsActive: Boolean;
var
  aChair: TBotChair;
begin
  Result := False;
  aChair := Chair;
  if (aChair <> nil) then Result := aChair.FIsActive;
end;

function TBotUser.GetTimeBank: Integer;
var
  aChair: TBotChair;
begin
  Result := -1; // undefined
  aChair := Chair;
  if (aChair <> nil) then Result := aChair.FTimeBank;
end;

function TBotUser.GetTurnTime: Integer;
var
  aChair: TBotChair;
begin
  Result := -1; // undefined
  aChair := Chair;
  if (aChair <> nil) then Result := aChair.FTurnTime;
end;

procedure TBotUser.SetConnected(const Value: Boolean);
begin
  FConnected := Value;
end;

function TBotUser.PositionUnderDealer: Integer;
var
  I, nChPos, nVal, nActiveCnt: Integer;
  aDealer, aUser: TBotUser;
  aChair: TBotChair;
begin
  Result := 2;
  if (FUsers = nil) then Exit;

  nActiveCnt := FUsers.CountOfActive;
  if (nActiveCnt < 3) then begin
    Result := 0;
    Exit;
  end;

  if (Chairs = nil) then Exit;
  { search dialer }
  aDealer := nil;
  for I:=0 to Chairs.Count - 1 do begin
    aChair := Chairs.Items[I];
    if (aChair.FIsDialer > 0) then begin
      aDealer := aChair.User;
      Break;
    end;
  end;
  if (aDealer = nil) then Exit;
  if (aDealer.Position < 0) then Exit;

  nVal := -1;
  for I := aDealer.FPosition to (aDealer.FPosition + Chairs.Count - 1) do begin
    nChPos := IfThen(I < Chairs.Count, I, I - Chairs.Count);
    aChair := Chairs.Items[nChPos];
    aUser  := aChair.User;
    if (aUser = nil) then Continue;
    if aUser.IsWatcher or (aUser.FInGame <= 0) then Continue;

    nVal := nVal + 1;
    if (aUser = Self) then Break;
  end;

  case nVal of
    1..3: Result := 0;
    4..7: Result := 1;
  else
    Result := IfThen(nActiveCnt < 6, 1, 2);
  end;
end;

procedure TBotUser.SetAutoSitDown(const Value: Boolean);
begin
  FAutoSitDown := Value;
end;

procedure TBotUser.SetBlaffersEvent(const Value: Integer);
begin
  FBlaffersEvent := Value;
end;

procedure TBotUser.DumpMemory(Level: Integer; sPrefix: string);
var
  sShift: string;
begin
  if Level > 0 then sShift := DupeString(Shift_string_On_DumpMemory, Level) else sShift := '';
  Logger.Log(0, ClassName, 'DumpMemory',
    sShift + '[SIZE]: ' + IntToStr(MemorySize), ltCall);

  FCards.DumpMemory(Level + 1, sPrefix + '; Cards of UserID' + IntToStr(FUserID) + '; Count=' + IntToStr(FCards.Count));
  FAvailableAnwers.DumpMemory(Level + 1, sPrefix + '; Ansvers of UserID' + IntToStr(FUserID) + '; Count=' + IntToStr(FAvailableAnwers.Count));

  sShift := '';
end;

function TBotUser.MemorySize: Integer;
begin
  Result :=
    SizeOf(FState) +
    SizeOf(FBetsAmmount) +
    SizeOf(FCurrAmmount) +
    SizeOf(FGameQualification) +
    SizeOf(FInGame) +
    SizeOf(FPosition) +
    SizeOf(FUserID) +
    SizeOf(FProcInitStatus) +
    SizeOf(FProcStateStatus) +
    SizeOf(FCharacter) +
    SizeOf(FIsBot) +
    SizeOf(FLastAction) +
    Length(FName) * SizeOf(Char) +
    SizeOf(FConnected) +
    SizeOf(FAutoSitDown) +
    SizeOf(FBlaffersEvent) +
    SizeOf(FUsers);

  Result := Result +
    FCards.MemorySize +
    FAvailableAnwers.MemorySize;
end;

{ TBotChair }

constructor TBotChair.Create(aChairs: TBotChairList);
begin
  inherited Create;
  FChairs := aChairs;

  FUserID := -1;
  FReservationUserID := -1;
  FState := CHS_FREE;
  FIsDialer := 0;
  if aChairs = nil then
    FPosition := -1
  else
    FPosition := aChairs.Count;
  FIsActive := False;
end;

function TBotChair.GetProcInitStatus: TFixProcInitStatus;
begin
  Result := PIS_NEEDREQUEST;
  if (User <> nil) then Result := User.FProcInitStatus;
end;

function TBotChair.GetProcStateStatus: TFixProcStateStatus;
begin
  Result := PSS_NEEDREQUEST;
  if (User <> nil) then Result := User.FProcStateStatus;
end;

function TBotChair.GetProcessID: Integer;
begin
  Result := Table.FProcessID;
end;

function TBotChair.GetTable: TBotTable;
begin
  if FChairs = nil then Result := nil
  else Result := FChairs.FTable;
end;

function TBotChair.GetUser: TBotUser;
begin
  Result := nil;
  if (FUserID > 0) then begin
    if (Table <> nil) then begin
      Result := Table.FUsers.UserByID(FUserID);
    end;
  end;
end;

procedure TBotChair.SetContextByObject(aChair: TBotChair);
begin
  FUserID            := aChair.FUserID;
  FReservationUserID := aChair.FReservationUserID;
  FState             := aChair.FState;
  FIsDialer          := aChair.FIsDialer;
  FPosition          := aChair.FPosition;
end;

procedure TBotChair.SetIsActive(const Value: Boolean);
var
  I: Integer;
  aChair: TBotChair;
begin
  FIsActive := Value;
  if (FChairs = nil) then Exit;
  if not FIsActive then Exit;
  for I:=0 to FChairs.Count - 1 do begin
    aChair := FChairs.Items[I];
    if (aChair <> Self) then aChair.FIsActive := False;
  end;
end;

procedure TBotChair.SetIsDialer(const Value: Integer);
begin
  FIsDialer := Value;
end;

procedure TBotChair.SetPosition(const Value: Integer);
begin
  FPosition := Value;
end;

procedure TBotChair.SetReservationUserID(const Value: Integer);
begin
  FReservationUserID := Value;
end;

procedure TBotChair.SetState(const Value: TFixChairState);
begin
  FState := Value;
end;

procedure TBotChair.SetUserID(const Value: Integer);
begin
  FUserID := Value;
end;

function TBotChair.StateName: string;
begin
  Result := GetFixChairStateAsString(FState);
end;

procedure TBotChair.SetTimeBank(const Value: Integer);
begin
  FTimeBank := Value;
end;

procedure TBotChair.SetTurnTime(const Value: Integer);
begin
  FTurnTime := Value;
end;

procedure TBotChair.DumpMemory(Level: Integer; sPrefix: string);
var
  sShift: string;
begin
  if Level > 0 then sShift := DupeString(Shift_string_On_DumpMemory, Level) else sShift := '';
  Logger.Log(0, ClassName, 'DumpMemory',
    sShift + sPrefix + '[SIZE]: ' + IntToStr(MemorySize), ltCall);

  sShift := '';
end;

function TBotChair.MemorySize: Integer;
begin
  Result :=
    SizeOf(FUserID) +
    SizeOf(FReservationUserID) +
    SizeOf(FChairs) +
    SizeOf(FState) +
    SizeOf(FIsDialer) +
    SizeOf(FPosition) +
    SizeOf(FIsActive) +
    SizeOf(FTurnTime) +
    SizeOf(FTimeBank);
end;

{ TBotChairList }

function TBotChairList.Add(aChair: TBotChair): TBotChair;
begin
  Result := aChair;
  Result.FChairs := Self;
  inherited Add(Result as TObject);
  Result.FPosition := IndexOf(Result);
end;

function TBotChairList.ChairByPosition(nPosition: Integer): TBotChair;
var
  aChair: TBotChair;
  I: Integer;
begin
  Result := nil;
  for I:=0 to Count - 1 do begin
    aChair := Items[I];
    if (aChair.FPosition = nPosition) then begin
      Result := aChair;
      Exit;
    end;
  end;
end;

function TBotChairList.ChairByUserID(nUserID: Integer): TBotChair;
var
  aChair: TBotChair;
  I: Integer;
begin
  Result := nil;
  for I:=0 to Count - 1 do begin
    aChair := Items[I];
    if (aChair.FUserID = nUserID) then begin
      Result := aChair;
      Exit;
    end;
  end;
end;

constructor TBotChairList.Create(aTable: TBotTable);
begin
  inherited Create;
  FTable := aTable;
end;

procedure TBotChairList.Del(aChair: TBotChair);
begin
  inherited Remove(aChair);
end;

procedure TBotChairList.DelByInd(nIndex: Integer);
var
  aChair: TBotChair;
begin
  aChair := Items[nIndex];
  inherited Remove(aChair);
end;

destructor TBotChairList.Destroy;
begin
  inherited;
end;

procedure TBotChairList.DumpMemory(Level: Integer; sPrefix: string);
var
{$IFDEF DumpItems_ON_MemoryDump}
  I: Integer;
{$ENDIF}
  sShift: string;
begin
  if Level > 0 then sShift := DupeString(Shift_string_On_DumpMemory, Level) else sShift := '';
  Logger.Log(0, ClassName, 'DumpMemory',
    sShift + sPrefix + '[SIZE]: ' + IntToStr(MemorySize), ltCall);

{$IFDEF DumpItems_ON_MemoryDump}
  for I:=0 to Count - 1 do
    Items[I].DumpMemory(Level + 1, sPrefix + '; Items(' + IntToStr(I) + ')');
{$ENDIF}

  sShift := '';
end;

function TBotChairList.GetCountOfBuzy: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I:=0 to Count - 1 do begin
    if (Items[I].User <> nil) then Inc(Result);
  end;
end;

function TBotChairList.GetCountOfNotBots: Integer;
var
  I: Integer;
  aUser: TBotUser;
begin
  Result := 0;
  for I:=0 to Count - 1 do begin
    aUser := Items[I].User;
    if (aUser = nil) then Continue;
    if (aUser.IsBot or aUser.IsWatcher) then Continue;
    Inc(Result);
  end;
end;

function TBotChairList.GetItems(nIndex: Integer): TBotChair;
begin
  Result := inherited Items[nIndex] as TBotChair;
end;

function TBotChairList.Ins(nIndex: Integer; aChair: TBotChair): TBotChair;
begin
  Result := aChair;
  Result.FChairs := Self;
  inherited Insert(nIndex, (Result as TObject));
  Result.FPosition := IndexOf(Result);
end;

function TBotChairList.MemorySize: Integer;
var
  I: Integer;
begin
  Result := SizeOf(Self);
  for I:=0 to Count - 1 do
    Result := Result + Items[I].MemorySize;
end;

procedure TBotChairList.SetContextByObject(aChairs: TBotChairList);
var
  I: Integer;
  aChair: TBotChair;
begin
  Clear;
  for I:=0 to aChairs.Count - 1 do begin
    aChair := aChairs.Items[I];
    Add(aChair);
  end;
end;

{ TBotTable }

procedure TBotTable.SetAllIn(const Value: Boolean);
begin
  FAllIn := Value;
end;

procedure TBotTable.SetChairsCount(const Value: Integer);
begin
  FChairsCount := Value;
end;

procedure TBotTable.SetCurrencyID(const Value: Integer);
begin
  FCurrencyID := Value;
end;

procedure TBotTable.SetCurrencySign(const Value: string);
begin
  FCurrencySign := Value;
end;

procedure TBotTable.SetDefBuyIn(const Value: Integer);
begin
  FDefBuyIn := Value;
end;

procedure TBotTable.SetEngineVersion(const Value: string);
begin
  FEngineVersion := Value;
end;

procedure TBotTable.SetHandID(const Value: Integer);
begin
  FHandID := Value;
end;

procedure TBotTable.SetTournamentType(const Value: TFixTournamentType);
begin
  FTournamentType := Value;
end;

procedure TBotTable.SetMaxBuyIn(const Value: Integer);
begin
  FMaxBuyIn := Value;
end;

procedure TBotTable.SetMaxStake(const Value: Integer);
begin
  FMaxStake := Value;
end;

procedure TBotTable.SetMinBuyIn(const Value: Integer);
begin
  FMinBuyIn := Value;
end;

procedure TBotTable.SetMinStake(const Value: Integer);
begin
  FMinStake := Value;
end;

procedure TBotTable.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TBotTable.SetGameType(const Value: TFixGameType);
begin
  FGameType := Value;
end;

procedure TBotTable.SetPrevHandID(const Value: Integer);
begin
  FPrevHandID := Value;
end;

procedure TBotTable.SetProcessID(const Value: Integer);
begin
  FProcessID := Value;
end;

procedure TBotTable.SetRake(const Value: Integer);
begin
  FRake := Value;
end;

procedure TBotTable.SetRound(const Value: Integer);
begin
  FRound := Value;
end;

procedure TBotTable.SetStakeType(const Value: TFixStakeType);
begin
  FStakeType := Value;
end;

procedure TBotTable.SetTournamentBuyIn(const Value: Integer);
begin
  FTournamentBuyIn := Value;
end;

procedure TBotTable.SetTournamentRake(const Value: Integer);
begin
  FTournamentRake := Value;
end;

constructor TBotTable.Create(aProcesses: TBotTableList);
begin
  inherited Create;

  FEngineVersion := '';
  FCurrencySign  := '';
  FName          := '';

  FProcesses := aProcesses;

  FCards  := TBotCardList.Create;
  FChairs := TBotChairList.Create(Self);
  FUsers  := TBotUserList.Create(Self);

  // default value initialize
  FAllIn := True;
  FStakeType := ST_FIX_LIMIT;
  FCurrencyID := 1;
  FChairsCount := 8;
  FPrevHandID := -1;
  FRake := 0;
  FGameType := GT_TEXAS;
  FMinBuyIn := 1000;
  FMaxBuyIn := 200000;
  FDefBuyIn := 100000;
  FProcessID := -1;
  FRound := 0;
  FMaxStake := 0;
  FTournamentRake := 200;
  FHandID := -1;
  FTournamentType := TT_NO;
  FMinStake := 0;
  FTournamentBuyIn := 2000;
  FCurrencySign := '';
  FName := 'Unknown';
  FCustomAnswer := False;
  FTimeOutForSitDown := IncSecond(Now, CommonDataModule.SessionSettings.ValuesAsInteger[BotAutoSitTimeOut]);
//  FTimeOutForSitDown := IncSecond(Now, TIME_OUT_FORSITDOWN);
  FLastTimeActivity  := Now;
  FMoveBetsIsShow := False;
  FPotsIsShow := False;
end;

destructor TBotTable.Destroy;
begin
  FEngineVersion := '';
  FCurrencySign  := '';
  FName          := '';

  FCards.Free;
  FChairs.Free;
  FUsers.Free;

  inherited;
end;

procedure TBotTable.SetContextByObject(aTable: TBotTable);
begin
  FAllIn           := aTable.FAllIn;
  FStakeType       := aTable.FStakeType;
  FCurrencyID      := aTable.FCurrencyID;
  FChairsCount     := aTable.FChairsCount;
  FPrevHandID      := aTable.FPrevHandID;
  FRake            := aTable.FRake;
  FGameType        := aTable.FGameType;
  FMinBuyIn        := aTable.FMinBuyIn;
  FProcessID       := aTable.FProcessID;
  FRound           := aTable.FRound;
  FMaxBuyIn        := aTable.FMaxBuyIn;
  FMaxStake        := aTable.FMaxStake;
  FTournamentRake  := aTable.TournamentRake;
  FHandID          := aTable.FHandID;
  FTournamentType  := aTable.FTournamentType;
  FMinStake        := aTable.FMinStake;
  FDefBuyIn        := aTable.FDefBuyIn;
  FTournamentBuyIn := aTable.FTournamentBuyIn;
  FEngineVersion   := aTable.FEngineVersion;
  FCurrencySign    := aTable.FCurrencySign;
  FName            := aTable.FName;

  FCards.SetContextByObject(aTable.FCards);
  FChairs.SetContextByObject(aTable.FChairs);
  FUsers.SetContextByObject(aTable.FUsers);
end;

function TBotTable.StakeTypeName: string;
begin
  Result := GetFixGameStakeTypeAsString(FStakeType);
end;

function TBotTable.GameTypeName: string;
begin
  Result := GetFixGameTypeAsString(FGameType);
end;

function TBotTable.TournamentTypeName: string;
begin
  Result := GetFixTournamentAsString(FTournamentType);
end;

procedure TBotTable.PerformProcInit(aAction: TBotInputAction);
var
  I, nCnt: Integer;
  aNode: IXMLNode;
  sValue, sName: string;
  nChairsCount: Integer;
  aChair: TBotChair;
  aUser: TBotUser;
begin
//------------------------------------------------------------------------------
// WARNING: this command can be reinitialize information for table as ALL
//------------------------------------------------------------------------------
  if (aAction = nil) then begin
    Logger.Log(0, ClassName, 'PerformProcInit', '[ERROR]: Action is nil. Command was ignored.', ltError);
    Exit;
  end;
  if (FProcInitStatus = PIS_RESPONSED) then begin
    { set procinit status  }
    aUser := Users.UserByID(aAction.UserID);
    if (aUser <> nil) then aUser.FProcInitStatus := PIS_RESPONSED;

    Logger.Log(aAction.UserID, ClassName, 'PerformProcInit', 'ProcInitStatus already responsed. Command was ignored.', ltCall);
    Exit;
  end;

  for I:=0 to aAction.ActionNode.ChildNodes.Count - 1 do begin
    aNode := aAction.ActionNode.ChildNodes[I];
    sName := aNode.NodeName;
    sValue := '';
    if aNode.HasAttribute(ATTR_VALUE) then sValue := aNode.Attributes[ATTR_VALUE];

    if       (sName = NODE_GE_VERSION) then begin
      FEngineVersion := sValue;
      Continue;
    end else if (sName = NODE_NAME) then begin
      FName := sValue;
      Continue;
    end else if (sName = NODE_POKERTYPE) then begin
      FGameType := TFixGameType(StrToIntDef(sValue, 1) - 1);
      Continue;
    end else if (sName = NODE_PLAYERCOUNT) then begin
      nChairsCount := StrToIntDef(sValue, -1);
      if (nChairsCount <= 0) then begin
        Logger.Log(aAction.UserID, ClassName, 'PerformProcInit', '[ERROR]: Attribute PlayerCount is not correct. Command was ignored=' + aAction.ActionNode.XML, ltError);
        sValue := '';
        sName  := '';
        Exit; // non correct attribute value
      end;

      if (nChairsCount <> Chairs.Count) then begin
        Chairs.Clear;
        for nCnt:=0 to nChairsCount - 1 do begin
          // reinitialization all chairs
          aChair := TBotChair.Create(Chairs);
          Chairs.Add(aChair);
        end;

        FProcStateStatus := PSS_WAITRESPONSE;
      end;

      FChairsCount := nChairsCount;
      Continue;
    end else if (sName = NODE_CURRENCYID) then begin
      FCurrencyID := StrToIntDef(sValue, 1);
      Continue;
    end else if (sName = NODE_CURRENCYSIGN) then begin
      FCurrencySign := sValue;
      Continue;
    end else if (sName = NODE_STAKETYPE) then begin
      FStakeType := TFixStakeType( StrToIntDef(sValue, 1) - 1 );
      Continue;
    end else if (sName = NODE_ALLIN) then begin
      FAllIn := Boolean( StrToIntDef(sValue, 1) );
      Continue;
    end else if (sName = NODE_MAXBUYIN) then begin
      FMaxBuyIn := Trunc( StrToCurrDef(sValue, 0) * 100 );
      Continue;
    end else if (sName = NODE_MINBUYIN) then begin
      FMinBuyIn := Trunc( StrToCurrDef(sValue, 0) * 100 );
      Continue;
    end else if (sName = NODE_DEFBUYIN) then begin
      FDefBuyIn := Trunc( StrToCurrDef(sValue, 0) * 100 );
      Continue;
    end else if (sName = NODE_ISTOURNAMENT) then begin
      FTournamentType  := TFixTournamentType( StrToIntDef(sValue, 0) );

      FTournamentRake  := 0;
      if aNode.HasAttribute(ATTR_RAKE) then
        FTournamentRake  := Trunc( StrToCurrDef(aNode.Attributes[ATTR_RAKE], 0) * 100 );

      FTournamentBuyIn := 0;
      if aNode.HasAttribute(ATTR_BUYIN) then
        FTournamentBuyIn := Trunc( StrToCurrDef(aNode.Attributes[ATTR_BUYIN], 0) * 100 );

      FTournamentChips := 0;
      if aNode.HasAttribute(ATTR_CHIPS) then
        FTournamentChips := Trunc( StrToCurrDef(aNode.Attributes[ATTR_CHIPS], 0) * 100 );
      Continue;
    end;
  end; // for (I)

  { set procinit status  }
  FProcInitStatus := PIS_RESPONSED;
  aUser := Users.UserByID(aAction.UserID);
  if (aUser <> nil) then aUser.FProcInitStatus := PIS_RESPONSED;

  sValue := '';
  sName  := '';
end;

procedure TBotTable.SetTournamentChips(const Value: Integer);
begin
  FTournamentChips := Value;
end;

procedure TBotTable.SetProcInitStatus(const Value: TFixProcInitStatus);
begin
  FProcInitStatus := Value;
end;

procedure TBotTable.SetProcStateStatus(const Value: TFixProcStateStatus);
begin
  FProcStateStatus := Value;
end;

procedure TBotTable.PerformProcClose(aAction: TBotInputAction);
var
  aUser: TBotUser;
begin
  if (aAction = nil) then Exit;

  { only personification work }
  aUser := FUsers.UserByID(aAction.UserID);
  if (aUser = nil) then Exit;
  Users.StandUpUser(aUser.Position);
  aUser.AutoSitDown := True;
end;

procedure TBotTable.PerformProcState(aAction: TBotInputAction);
var
  aNode: IXMLNode;
  I: Integer;
  sName: string;
  aUser: TBotUser;
  nHandID, nPrevHandID, nRound: Integer;
begin
//------------------------------------------------------------------------------
// WARNING: this command reinitialize all information about Table
//------------------------------------------------------------------------------
  Logger.Log(aAction.UserID, ClassName, 'PerformProcState',
    'Entry with action: ' + aAction.ActionNode.XML, ltCall);

  if (aAction = nil) then begin
    Logger.Log(aAction.UserID, ClassName, 'PerformProcState',
      '[ERROR]: Action is nil. Command will be ignored', ltError);

    Exit;
  end;

  aUser := FUsers.UserByID(aAction.UserID);

  { common info }
  nHandID := FHandID;
  nPrevHandID := FPrevHandID;
  nRound := FRound;
  aNode := aAction.ActionNode;
  if aNode.HasAttribute(ATTR_HANDID     ) then
    FHandID      := StrToIntDef(aNode.Attributes[ATTR_HANDID], -1);
  if aNode.HasAttribute(ATTR_ROUND      ) then
    FRound       := StrToIntDef(aNode.Attributes[ATTR_ROUND], 0);
  if aNode.HasAttribute(ATTR_PREVHANDID ) then
    FPrevHandID  := StrToIntDef(aNode.Attributes[ATTR_PREVHANDID], -1);
  if aNode.HasAttribute(ATTR_MINSTAKE   ) then
    FMinStake    := Trunc( StrToCurrDef(aNode.Attributes[ATTR_MINSTAKE], 0) * 100 );
  if aNode.HasAttribute(ATTR_MAXSTAKE   ) then
    FMaxStake    := Trunc( StrToCurrDef(aNode.Attributes[ATTR_MAXSTAKE], 0) * 100 );

  if (FHandID <> nHandID) or (FPrevHandID <> nPrevHandID) or (FRound <> nRound) then begin
  { Set all procstate statuses to waitresponse on change hand or round }
    FProcStateStatus := PSS_WAITRESPONSE;
    if (aUser <> nil) then aUser.FProcStateStatus := PSS_WAITRESPONSE;
  end;

  if (FRound < 0) then FRound := 0;

  { sub node info }
  for I:=0 to aAction.ActionNode.ChildNodes.Count - 1 do begin
    aNode := aAction.ActionNode.ChildNodes[I];
    sName := aNode.NodeName;

    if not (FProcStateStatus = PSS_RESPONSED) then begin
      if (sName = NODE_COMMUNITYCARDS) then begin
        PerformCommunityCards(aNode, aAction.HandID, aAction.Round);
        Continue;
      end;
      if (sName = NODE_RAKE) then begin
        PerformRake(aNode, aAction.HandID, aAction.Round);
        Continue;
      end;
    end;

    if (sName = NODE_CHAIRS) then begin
      PerformChairs(aNode, aUser);
      Continue;
    end;
  end; // for (I)

  { set procstate status }
  FProcStateStatus := PSS_RESPONSED;
  FMoveBetsIsShow := False;
  FPotsIsShow := False;
  if (aUser <> nil) then aUser.FProcStateStatus := PSS_RESPONSED;

  sName := '';
end;

procedure TBotTable.PerformCommunityCards(aNode: IXMLNode; nHandID, nRound: Integer);
var
  sValue: string;
begin
  if (nHandID = FHandID) and (nRound = FRound) then Exit;

  Cards.Clear;
  sValue := '';
  if aNode.HasAttribute(ATTR_VALUE) then sValue := aNode.Attributes[ATTR_VALUE];
  Cards.SetContextByNames(sValue);

  sValue := '';
end;

procedure TBotTable.PerformRake(aNode: IXMLNode; nHandID, nRound: Integer);
begin
  if (nHandID = FHandID) and (nRound = FRound) then Exit;
  if (aNode.NodeName <> NODE_RAKE) then Exit;

  FRake := 0;
  if aNode.HasAttribute(ATTR_AMOUNT) then
    FRake := Trunc( StrToCurrDef(aNode.Attributes[ATTR_AMOUNT], 0) * 100 );
end;

procedure TBotTable.PerformChairs(aNode: IXMLNode; aPersonUser: TBotUser);
var
  I: Integer;
  aNodeCh: IXMLNode;
  aChair: TBotChair;
begin
//**********************************************
// WARNING: aPersonUser is for personification
//**********************************************

  { validation }
  if (aNode.NodeName <> NODE_CHAIRS) then Exit;
  for I:=0 to aNode.ChildNodes.Count - 1 do begin
    aNodeCh := aNode.ChildNodes[I];
    if (aNodeCh.NodeName <> NODE_CHAIR) then Exit;
  end;

  { check on chairs count values }
  if (FChairs.Count <> aNode.ChildNodes.Count) then begin
    // reinitialization chairs
    FChairs.Clear;

    for I:=0 to aNode.ChildNodes.Count - 1 do begin
      aNodeCh := aNode.ChildNodes[I];
      aChair := TBotChair.Create(FChairs);
      FChairs.Add(aChair);
      PerformChair(aNodeCh, aChair);
    end;

    FChairsCount := FChairs.Count;
    Exit;
  end;

  FChairsCount := FChairs.Count;
  for I:=0 to aNode.ChildNodes.Count - 1 do begin
    aNodeCh := aNode.ChildNodes[I];
    PerformChair(aNodeCh, nil, aPersonUser);
  end;
end;

procedure TBotTable.PerformChair(aNode: IXMLNode; aChair: TBotChair; aPersonUser: TBotUser);
var
  aCh: TBotChair;
  nPos, nID: Integer;
  nBalanse: Integer;
  sVal: string;
  aNodeCh: IXMLNode;
  aUser: TBotUser;
begin
//***********************************************
// WARNING: aPersonUser is for personification
//***********************************************
  if (aNode.NodeName <> NODE_CHAIR) then Exit;
  if (ProcStateStatus = PSS_RESPONSED) and (aPersonUser = nil) then Exit;

  nPos := -1;
  if aNode.HasAttribute(ATTR_POSITION) then nPos := StrToIntDef(aNode.Attributes[ATTR_POSITION], -1);
  if (nPos < 0) then Exit;
  { chair validation }
  if (aChair = nil) then begin
    aCh := FChairs.ChairByPosition(nPos);
    if (aCh = nil) then Exit;
  end else begin
    aCh := aChair;
  end;

  { working only with personal chair or non bot }
  aUser := aCh.User;
  if (aUser <> nil) then begin
    if aUser.IsBot and (aUser <> aPersonUser) and aUser.Connected then Exit;
  end;

  aCh.FPosition := nPos;

  aCh.FIsDialer := 0;
  if aNode.HasAttribute(ATTR_ISDEALER) then aCh.FIsDialer := StrToIntDef(aNode.Attributes[ATTR_ISDEALER], 0);

  if aNode.HasAttribute(ATTR_STATUS) then begin
    sVal := aNode.Attributes[ATTR_STATUS];

    aCh.FUserID := -1;
    aCh.FState  := CHS_FREE;

    if (sVal = NAME_BUSY    ) then begin
      if aNode.HasChildNodes then begin
        aNodeCh := aNode.ChildNodes[0];

        if (aNodeCh.NodeName = NODE_PLAYER) then begin
          nID := -1;
          if aNodeCh.HasAttribute(ATTR_ID) then
            nID := StrToIntDef(aNodeCh.Attributes[ATTR_ID], -1);

          nBalanse := 0;
          if aNodeCh.HasAttribute(ATTR_BALANCE) then
            nBalanse := Trunc( StrToCurrDef(aNodeCh.Attributes[ATTR_BALANCE], 0) * 100 );

          if (nID > 0) then begin
            aUser := FUsers.SitDownUser(nID, nPos, nBalanse);
            aUser.SetContextByNodePlayer(aNodeCh);

            { check and if needing perform morechips & back to table }
            if aUser.FIsBot then begin
              if (aUser.FInGame <= 0) then begin
                if (aUser.FCurrAmmount < FMinBuyIn) then begin
                  BotMoreChips(aUser, (FDefBuyIn / 100));
                end;
                BotBackToGame(aUser);
              end;
            end;
          end else begin
            aUser := FUsers.UserByPosition(nPos);
            if (aUser <> nil) then FUsers.KickOfUser(aUser);
          end;
        end; //if
      end;
    end else if (sVal = NAME_RESERVED) then begin
      FUsers.StandUpUser(nPos);
      if aNode.HasChildNodes then begin
        aNodeCh := aNode.ChildNodes[0];

        nID := -1;
        if aNodeCh.HasAttribute(ATTR_ID) then
          nID := StrToIntDef(aNodeCh.Attributes[ATTR_ID], -1);
        if (nID > 0) then
          aCh.FState := CHS_RESERVED;
      end; //if
    end else if (sVal = NAME_HIDDEN) then begin
      aUser := aCh.User;
      if (aUser <> nil) then begin
        aUser.FState := US_SITOUT;
        aUser.FCards.Clear;
        aUser.FInGame := 0;
        aUser.FAvailableAnwers.Clear;
      end;
    end else begin // free status
      FUsers.StandUpUser(nPos);
    end;
  end;

  sVal := '';
end;

function TBotTable.PerformSetActivePlayer(aAction: TBotInputAction): string;
var
  aUser: TBotUser;
  aAutoResponse: TBotAutoResponse;
  aRespType: TFixAction;
  aButton: TBotAvailableAnswer;
  aDateEntry: TDateTime;
  aChair: TBotChair;

  procedure OnExit(aAction: TBotInputAction; sMsg: string);
  begin
    Logger.Log(aAction.UserID, ClassName, 'PerformSetActivePlayer',
      sMsg + '. Action: ' + aAction.ActionNode.XML, ltCall);
  end;

begin
  Logger.Log(aAction.UserID, ClassName, 'PerformSetActivePlayer',
    'Entry: Action=[' + aAction.ActionNode.XML + ']', ltCall);

  Result := '';
  if (aAction.ActionNode.NodeName <> NODE_SETACTIVEPLAYER) then begin
    OnExit(aAction, 'Action is not setactive player');
    Exit;
  end;
  if (aAction.Position < 0) then begin
    OnExit(aAction, 'Position is invalid');
    Exit;
  end;

  aUser := FUsers.UserByPosition(aAction.Position);
  if (aUser = nil) then begin // user not found;
    OnExit(aAction, 'User by position not found');
    Exit;
  end;
  if (aUser.FInGame <= 0) then begin // user have not been atctivity
    OnExit(aAction, 'User is not in game');
    Exit;
  end;

//  aUser.FAvailableAnwers := aAction.AvailableButtons;
  aUser.FAvailableAnwers.SetContextByAnswers(aAction.AvailableButtons);
  if (aUser.FAvailableAnwers.Count = 0) then begin
    OnExit(aAction, 'Available answers is empty');
    Exit;
  end;
  aChair := aUser.Chair;
  if (aChair = nil) then begin
    OnExit(aAction, 'Chair not found');
    Exit;
  end;

  if aChair.FIsActive then begin // Already resive command
    OnExit(aAction, 'Chair allready is active.');
    Exit;
  end;
  if (aAction.UserID <> aUser.UserID) then begin // No need in answer
    OnExit(aAction, 'UserId by action (' + IntToStr(aAction.UserID) + ') attribute and UserId (' + IntToStr(aUser.UserID) + ') by Chair is not equels. ProcessId=' + IntToStr(FProcessID));
    Exit;
  end;

  aChair.IsActive := True;
  aChair.TimeBank := aAction.TimeBank;
  aChair.TurnTime := aAction.TurnTime;

//  if (aAction.UserID <> aUser.UserID) then Exit; // No need in answer

  { get answer }
  aRespType := ACT_UNKNOWN;
  if aUser.IsBot then begin
    aDateEntry := Now;
    aAutoResponse := TBotAutoResponse.Create(Self, aUser);

    aButton   := aAutoResponse.Answer;
    if (aButton <> nil) then begin
      aRespType := aButton.AnswerType;
      Result    := GetActionNodeByAnswerButton(aButton);;
    end;

    if (Result <> '') then begin
      { for responses }
      if (aRespType <> ACT_UNKNOWN) then
        Processes.OnResponse(Result, VST_ACTION, aRespType, aDateEntry, Self.FProcessID, aUser.FUserID);
    end;

    aAutoResponse.Free;
  end else begin
    OnExit(aAction, 'User is not bot');
    { for vizualization buttons on forms }
//    if Assigned(FProcesses.FOnVisualizationButtons) then begin
//      FProcesses.FOnVisualizationButtons(aUser.FAvailableAnwers);
//    end;
  end;
end;

function TBotTable.PerformSitOut(aAction: TBotInputAction): string;
var
  aChair: TBotChair;
  aUser: TBotUser;
begin
  Result := '';
  { validation action }
  if not ValidateAction(aAction, [ACT_SITOUT], aChair, aUser) then Exit;
  { set last action}
  aUser.FLastAction := aAction.ActionType;

  if not aUser.FIsBot then Exit;

  { response is i'm back action }
  Result :=
    GetGaActionOpenNodeAsString(FProcessID) +
      GetActionNodeAsString(ACT_NAME_SITOUTNEXTHAND, FHandID, aAction.Position, -1, -1, -1, 0) +
    GetGaActionCloseNodeAsString;
end;

function TBotTable.PerformSitOutNextHand(aAction: TBotInputAction): string;
var
  aChair: TBotChair;
  aUser : TBotUser;
begin
  Result := '';
  { validation action }
  if not ValidateAction(aAction, [ACT_SITOUTNEXTHAND], aChair, aUser) then Exit;

  { check on bot }
  if not aUser.FIsBot then Exit;
  if (aAction.Value < 1) then Exit;

  { response is i'm back action }
  Result :=
    GetGaActionOpenNodeAsString(FProcessID) +
      GetActionNodeAsString(ACT_NAME_SITOUTNEXTHAND, FHandID, aAction.Position, -1, -1, -1, 0) +
    GetGaActionCloseNodeAsString;
end;

function TBotTable.PerformMoreChips(aAction: TBotInputAction): string;
var
  aChair: TBotChair;
  aUser: TBotUser;
begin
  Result := '';
  { validation action }
  if not ValidateAction(aAction, [ACT_MORECHIPS], aChair, aUser) then Exit;

  if (aAction.Amount < 0) then
    aUser.FCurrAmmount := 0
  else
    aUser.FCurrAmmount := aAction.Amount;
end;

function TBotTable.PerformWaitBB(aAction: TBotInputAction): string;
var
  aChair: TBotChair;
  aUser: TBotUser;
begin
  Result := '';
  { validation action }
  if not ValidateAction(aAction, [ACT_WAITBB], aChair, aUser) then Exit;
  { manipulation with data }
  aUser.FLastAction := aAction.ActionType;
  aUser.InGame := 0;
end;

function TBotTable.PerformFold(aAction: TBotInputAction): string;
var
  aChair: TBotChair;
  aUser: TBotUser;
begin
  Result := '';
  { validation action }
  if not ValidateAction(aAction, [ACT_FOLD], aChair, aUser) then Exit;
  { manipulation with data }
  aUser.FLastAction := aAction.ActionType;
  aUser.InGame := 0;
  aUser.FCards.Clear;
end;

function TBotTable.ValidateAction(aAction: TBotInputAction; WithActionsType: TFixActionSet;
  var aChair: TBotChair; var aUser: TBotUser): Boolean;
var
  Position: Integer;
begin
  Result := False;
  if (aAction = nil) then Exit;
  if not (aAction.ActionType in WithActionsType) then Exit;

  Position := aAction.Position;
  aChair := FChairs.ChairByPosition(Position);
  if (aChair = nil) then Exit;
  if (aChair.FState <> CHS_BUSY) then Exit;

  aUser := aChair.User;
  if (aUser = nil) then Exit;

  Result := True;
end;

function TBotTable.PerformChangeAmountActions(aAction: TBotInputAction): string;
var
  aChair: TBotChair;
  aUser: TBotUser;
  aActionSet: TFixActionSet;
  nBet, nStake, nAmount: Integer;
begin
  Result := '';
  { validation action }
  aActionSet :=
    [ACT_POSTSB, ACT_POSTBB, ACT_ANTE, ACT_BRINGIN,
     ACT_POST, ACT_POSTDEAD, ACT_BET, ACT_CALL,
     ACT_RAISE, ACT_CHECK];

  if not ValidateAction(aAction, aActionSet, aChair, aUser) then Exit;
  if (aUser.InGame < 1) then Exit; // user was can't to take activity
  if not aUser.IsActive then begin
    Exit;
  end;

  { manipulation with data }
  aUser.FLastAction := aAction.ActionType;
  if (aUser.FLastAction <> ACT_CHECK) then begin
    nBet := aAction.Bet;
    nStake := aAction.Stake;
    nAmount := aAction.Amount;
    if (nStake > 0) then begin
      aUser.FBetsAmmount := aUser.FBetsAmmount + nStake;
      if ((aUser.FCurrAmmount - nStake) < 0) then
        aUser.FCurrAmmount := 0
      else
        aUser.FCurrAmmount := aUser.FCurrAmmount - nStake;
    end else begin
      if (nBet >= 0) then aUser.FBetsAmmount := nBet;
      if (nAmount >= 0) then
        aUser.FCurrAmmount := nAmount
      else
        aUser.FCurrAmmount := 0;
    end;
  end;

  aChair.FIsActive := False;
end;

function TBotTable.PerformShowDownActions(aAction: TBotInputAction): string;
var
  aChair: TBotChair;
  aUser: TBotUser;
  aActionSet: TFixActionSet;
  I: Integer;
begin
  Result := '';
  { validation action }
  aActionSet := [ACT_SHOW, ACT_SHOWSHUFFLED, ACT_DONTSHOW, ACT_MUCK];
  if not ValidateAction(aAction, aActionSet, aChair, aUser) then Exit;
  if (aUser.InGame < 1) then Exit; // user was can't to take activity
  { manipulation with data }
  aUser.FLastAction := aAction.ActionType;
  case aAction.ActionType of
    ACT_SHOW:
    begin
      for I:=0 to aUser.FCards.Count - 1 do begin
        aUser.FCards.Items[I].FOpen := True;
      end; // for(I)
    end;

    ACT_MUCK, ACT_DONTSHOW: aUser.FCards.Clear;

    ACT_SHOWSHUFFLED:
    begin
      aUser.FCards.Clear;
      aUser.FCards.SetContextByNames(aAction.Cards);
    end;
  end;
end;

function TBotTable.PerformMoveBets(aAction: TBotInputAction): string;
var
  I, nPos, nAmmount, nNewBallance: Integer;
  aUser: TBotUser;
  aNode: IXMLNode;
begin
  Result := '';
  if (aAction.NameOfNode <> NODE_MOVEBETS) then Exit;
  if FMoveBetsIsShow then Exit;
//  if (aAction.HandID = FHandID) and (aAction.Round = FRound) then Exit;

  for I := 0 to aAction.ActionNode.ChildNodes.Count - 1 do begin
    aNode := aAction.ActionNode.ChildNodes[I];

    nPos := -1;
    if aNode.HasAttribute(ATTR_POSITION) then nPos := StrToIntDef(aNode.Attributes[ATTR_POSITION], -1);
    aUser := FUsers.UserByPosition(nPos);
    if (aUser = nil) then Continue;

    nAmmount := GetCurrencyAttrAsInteger(aNode, ATTR_AMOUNT);
    if (nAmmount < 0) then Continue;

    if (aNode.NodeName = NODE_MOVE) then begin
      if (aUser.FBetsAmmount <= 0) then begin
        aUser.FBetsAmmount := 0;
        Continue;
      end;
      if (aUser.FBetsAmmount < nAmmount) then begin
        aUser.FBetsAmmount := 0;
        Continue;
      end;

      aUser.FBetsAmmount := aUser.FBetsAmmount - nAmmount;
    end else begin
      nNewBallance := GetCurrencyAttrAsInteger(aNode, NODE_NEWBALANCE);
      aUser.FCurrAmmount := IfThen(nNewBallance <= 0, 0, nNewBallance);
      aUser.FBetsAmmount := IfThen((aUser.FBetsAmmount - nAmmount) <= 0, 0, aUser.FBetsAmmount - nAmmount);
    end;
  end;

  FMoveBetsIsShow := True;
end;

function TBotTable.PerformDialCards(aAction: TBotInputAction): string;
var
  sName, sCards: string;
  aNode: IXMLNode;
  I: Integer;
  nPos: Integer;
  aUser: TBotUser;
begin
  Result := '';
  if (aAction = nil) then Exit;
//  if (aAction.HandID = FHandID) and (aAction.Round = FRound) then Exit;

  sName := aAction.ActionNode.NodeName;
  if (sName <> NODE_DIALCARDS) then Exit;
  if not aAction.ActionNode.HasChildNodes then Exit;

  for I:=0 to aAction.ActionNode.ChildNodes.Count - 1 do begin
    aNode := aAction.ActionNode.ChildNodes[I];
    sName := aNode.NodeName;

    if (sName = NODE_COMMUNITYCARDS) then begin
      PerformCommunityCards(aNode, aAction.HandID, aAction.Round);
      Continue;
    end;

    if (sName = NODE_DIAL) then begin
      nPos := -1;
      if aNode.HasAttribute(ATTR_POSITION) then nPos := StrToIntDef(aNode.Attributes[ATTR_POSITION], -1);
      if (nPos < 0) then Continue;

      aUser := FUsers.UserByPosition(nPos);
      if (aUser = nil) then Continue;
      if aUser.IsBot and (aUser.FUserID <> aAction.UserID) then Continue; // only personification

      sCards := '';
      if aNode.HasAttribute(ATTR_CARDS) then sCards := aNode.Attributes[ATTR_CARDS];

      aUser.FCards.Clear;
      aUser.FCards.SetContextByNames(sCards);

      Continue;
    end;
  end;

  sName  := '';
  sCards := '';
end;

function TBotTable.PerformEndRound(aAction: TBotInputAction): string;
var
  nRound: Integer;
  aNode, aNodeCH: IXMLNode;
  I: Integer;
begin
  Result := '';
  if (aAction = nil) then Exit;
  if (aAction.NameOfNode <> NODE_ENDROUND) then Exit;
//  if (aAction.HandID = FHandID) and (aAction.Round = FRound) then Exit;

  aNode := aAction.ActionNode;

  nRound := 0;
  if aNode.HasAttribute(ATTR_ROUND) then nRound := StrToIntDef(aNode.Attributes[ATTR_ROUND], 0);

  { set last action of users to NONE }
  for I:=0 to FUsers.Count - 1 do begin
    FUsers.Items[I].FLastAction := ACT_UNKNOWN;
  end;
  { clear active status for all chairs }
  for I:=0 to FChairs.Count - 1 do begin
    FChairs.Items[I].FIsActive := False;
  end;

  if not aNode.HasChildNodes then Exit;

  for I:=0 to aNode.ChildNodes.Count - 1 do begin
    aNodeCH := aNode.ChildNodes[I];
    if (aNodeCH.NodeName = NODE_RAKE) then begin
      PerformRake(aNodeCH, aAction.HandID, aAction.Round);
    end;
  end;

  FRound := nRound;
  FMoveBetsIsShow := False;
  FPotsIsShow := False;
end;

function TBotTable.PerformFinishHand(aAction: TBotInputAction): string;
var
  aNode, aNodeChild, aNodeTh: IXMLNode;
  I, J: Integer;
  aChair: TBotChair;
  aUser: TBotUser;
begin
  Result := '';
  if (aAction = nil) then Exit;
  if (aAction.NameOfNode <> NODE_FINISHHAND) then Exit;
//  if (aAction.HandID = FHandID) and (aAction.Round = FRound) then Exit;

  aNode := aAction.ActionNode;
  for I:=0 to aNode.ChildNodes.Count - 1 do begin
    aNodeChild := aNode.ChildNodes[I];
    if (aNodeChild.NodeName <> NODE_POT) then Continue;

    for J:=0 to aNodeChild.ChildNodes.Count - 1 do begin
      aNodeTh := aNodeChild.ChildNodes[J];

      if (aNodeTh.NodeName = NODE_WINNER) then begin
        PerformWinner(aNodeTh, aAction.HandID, aAction.Round);
        Continue;
      end;
    end; // for(J)
  end; // for(I)

  FRound := 0;
  FPrevHandID := FHandID;
  FRake := 0;
  FCards.Clear;
  FProcStateStatus := PSS_WAITRESPONSE;
  FMoveBetsIsShow := False;
  FPotsIsShow := False;

  for I:=0 to FChairs.Count - 1 do begin
    aChair := FChairs.Items[I];
    aChair.FIsActive := False;

    aUser := aChair.User;
    if (aUser = nil) then Continue;
    aUser.FBetsAmmount := 0;
    aUser.FCards.Clear;
    aUser.FProcStateStatus := PSS_WAITRESPONSE;
  end;

  { set last action of users to NONE and increment Blaffers count }
  for I:=0 to FUsers.Count - 1 do begin
    aUser := FUsers.Items[I];
    aUser.FLastAction := ACT_UNKNOWN;

    if aUser.IsBot and (aUser.BlaffersEvent <= 0) then
      aUser.BlaffersEvent := MIN_COUNT_ONBLAFFERS + Random(MAX_COUNT_ONBLAFFERS - MIN_COUNT_ONBLAFFERS);   
  end;
end;

function TBotTable.PerformWinner(aNode: IXMLNode; nHandID, nRound: Integer): string;
var
  aUser: TBotUser;
  nPos, nNewBalance: Integer;
begin
  Result := '';
  if (aNode.NodeName <> NODE_WINNER) then Exit;
//  if (nHandID = FHandID) and (nRound = FRound) then Exit;

  nPos := -1;
  if aNode.HasAttribute(ATTR_POSITION) then nPos := StrToIntDef(aNode.Attributes[ATTR_POSITION], -1);
  if (nPos < 0) then Exit;

  nNewBalance := -1;
  if aNode.HasAttribute(ATTR_NEWBALANCE) then nNewBalance := GetCurrencyAttrAsInteger(aNode, ATTR_NEWBALANCE);
  if (nNewBalance < 0) then Exit;

  aUser := FUsers.UserByPosition(nPos);
  if (aUser = nil) then Exit;

  { manipulation with data }
  aUser.FCurrAmmount := IfThen(nNewBalance <= 0, 0, nNewBalance);
end;

function TBotTable.PerformMessage(aAction: TBotInputAction): string;
begin
  Result := '';
end;

function TBotTable.PerformRanking(aAction: TBotInputAction): string;
begin
  if (aAction.HandID = FHandID) and (aAction.Round = FRound) then Exit;
end;

function TBotTable.GetActionNodeByAnswerButton(aButton: TBotAvailableAnswer): string;
begin
  Result := '';
  if (aButton = nil) then Exit;
  case aButton.AnswerType of
    ACT_SITOUT,
    ACT_WAITBB,
    ACT_FOLD,
    ACT_SHOW,
    ACT_SHOWSHUFFLED,
    ACT_MUCK,
    ACT_DONTSHOW,
    ACT_CHECK   : Result := GetActionNodeAsString(aButton.Name, FHandID);

    ACT_POSTDEAD: Result := GetActionNodeAsString(aButton.Name, FHandID, -1, -1, aButton.Stake, aButton.Dead);

    ACT_POSTSB,
    ACT_POSTBB,
    ACT_ANTE,
    ACT_BRINGIN,
    ACT_POST,
    ACT_CALL,
    ACT_BET,
    ACT_RAISE    : Result := GetActionNodeAsString(aButton.Name, FHandID, -1, -1, aButton.Stake);
  else
    Result := '';
  end;

  if (Result <> '') then
    Result := GetGaActionOpenNodeAsString(FProcessID) + Result + GetGaActionCloseNodeAsString;
end;

procedure TBotTable.SetCustomAnswer(const Value: Boolean);
begin
  FCustomAnswer := Value;
end;

procedure TBotTable.PerformFinalPot(aNode: IXMLNode;
  nUserID, nHandID, nRound: Integer);
var
  nID: Integer;
  I: Integer;
  aNodeCH: IXMLNode;
begin
//  if (nHandID = FHandID) and (nRound = FRound) then Exit;

  nID := -1;
  if aNode.HasAttribute(ATTR_ID) then
    nID := StrToIntDef(aNode.Attributes[ATTR_ID], -1);
  if (nID < 0) then Exit;
  if not aNode.HasChildNodes then Exit;

  for I:=0 to aNode.ChildNodes.Count - 1 do begin
    aNodeCH := aNode.ChildNodes[I];

    if (aNodeCH.NodeName = NODE_WINNER) then begin
      PerformWinner(aNodeCH, nHandID, nRound);
    end;
  end;
end;

function TBotTable.BotMoreChips(aUser: TBotUser; Amount: Currency): string;
begin
  if (aUser = nil) then Exit;
  { check on procinit(state) status for user }
  if (aUser.ProcInitStatus <> PIS_RESPONSED) then Exit;

  { response }
  Result :=
    GetGaActionOpenNodeAsString(FProcessID) +
      GetActionNodeAsString(ACT_NAME_MORECHIPS, FHandID, -1, Trunc(Amount * 100)) +
    GetGaActionCloseNodeAsString();
  { Visualization response }
  if (Result <> '') then
    FProcesses.OnResponse(Result, VST_ACTION, ACT_MORECHIPS, Now, Self.FProcessID, aUser.UserID);
end;

function TBotTable.BotBackToGame(aUser: TBotUser): string;
begin
  if (aUser = nil) then Exit;
  { check on procinit(state) status for user }
  if (aUser.ProcInitStatus <> PIS_RESPONSED) then begin
    Result :=
      GetGaActionOpenNodeAsString(ProcessID) +
        '<' + NODE_PROCINIT + '/>' +
      GetGaActionCloseNodeAsString;

    { Visualization response }
    if (Result <> '') then
      FProcesses.OnResponse(Result, VST_PROCINIT, ACT_UNKNOWN, Now, FProcessID, aUser.FUserID);
  end;

  { response }
  Result :=
    GetGaActionOpenNodeAsString(FProcessID) +
      GetActionNodeAsString(ACT_NAME_SITOUTNEXTHAND, FHandID, -1, -1, -1, -1, 0) +
    GetGaActionCloseNodeAsString();
  { Visualization response }
  if (Result <> '') then
    FProcesses.OnResponse(Result, VST_ACTION, ACT_SITOUTNEXTHAND, Now, FProcessID, aUser.FUserID);
end;

procedure TBotTable.PerformGaCrash(aAction: TBotInputAction);
begin
  if (aAction = nil) then Exit;

  { Stand Up all users }
  PerformStandUpAllBots;
  PerformStandUpAllNotBots;
end;

procedure TBotTable.SetTimeOutForSitDown(const Value: TDateTime);
begin
  FTimeOutForSitDown := Value;
end;

procedure TBotTable.SetLastTimeActivity(const Value: TDateTime);
begin
  FLastTimeActivity := Value;
end;

procedure TBotTable.PerformStandUpAllBots(NeedLeaveTableResponse: Boolean);
var
  I: Integer;
  aUser: TBotUser;
  sXML: string;
begin
  for I:=0 to FUsers.Count - 1 do begin
    aUser := FUsers.Items[I];
    if not aUser.IsBot then Continue;

    aUser.FProcInitStatus  := PIS_NEEDREQUEST;
    aUser.FProcStateStatus := PSS_NEEDREQUEST;
    FUsers.StandUpUser(aUser.FPosition);
    aUser.AutoSitDown := True;

    if NeedLeaveTableResponse then begin
      { response }
      sXML :=
        GetGaActionOpenNodeAsString(FProcessID) +
          GetActionNodeAsString(ACT_NAME_LEAVETABLE, FHandID) +
        GetGaActionCloseNodeAsString();
      { Visualization response }
      FProcesses.OnResponse(sXML, VST_ACTION, ACT_LEAVETABLE, Now, Self.FProcessID, aUser.FUserID);
    end;
  end;

  FProcInitStatus  := PIS_NEEDREQUEST;
  FProcStateStatus := PSS_NEEDREQUEST;

  sXML := '';
end;

procedure TBotTable.PerformStandUpAllNotBots;
var
  I: Integer;
  aUser: TBotUser;
begin
  I:=0;
  while I < FUsers.Count do begin
    aUser := FUsers.Items[I];
    if not aUser.IsBot then begin
      FUsers.KickOfUser(aUser);
      Continue;
    end;
    Inc(I);
  end;
end;

procedure TBotTable.DumpMemory(Level: Integer; sPrefix: string);
var
  sShift: string;
begin
  if Level > 0 then sShift := DupeString(Shift_string_On_DumpMemory, Level) else sShift := '';
  Logger.Log(0, ClassName, 'DumpMemory',
    sShift + sPrefix + '[SIZE]: ' + IntToStr(MemorySize), ltCall);

  FCards.DumpMemory(Level + 1, sPrefix + '; Cards of ProcessID=' + IntToStr(FProcessID) + '; Count = ' + IntToStr(FCards.Count));
  FChairs.DumpMemory(Level + 1, sPrefix + '; Chairs of ProcessID=' + IntToStr(FProcessID) + '; Count = ' + IntToStr(FChairs.Count));
  FUsers.DumpMemory(Level + 1, sPrefix + '; Users of ProcessID=' + IntToStr(FProcessID) + '; Count = ' + IntToStr(FUsers.Count));

  sShift := '';
end;

function TBotTable.MemorySize: Integer;
begin
  Result :=
    SizeOf(FAllIn) +
    SizeOf(FStakeType) +
    SizeOf(FCurrencyID) +
    SizeOf(FChairsCount) +
    SizeOf(FPrevHandID) +
    SizeOf(FRake) +
    SizeOf(FGameType) +
    SizeOf(FMinBuyIn) +
    SizeOf(FProcessID) +
    SizeOf(FRound) +
    SizeOf(FMaxBuyIn) +
    SizeOf(FMaxStake) +
    SizeOf(FTournamentRake) +
    SizeOf(FHandID) +
    SizeOf(FTournamentType) +
    SizeOf(FMinStake) +
    SizeOf(FDefBuyIn) +
    SizeOf(FTournamentBuyIn) +
    Length(FEngineVersion + FCurrencySign + FName) * SizeOf(Char) +
    SizeOf(FTournamentChips) +
    SizeOf(ProcInitStatus) +
    SizeOf(ProcStateStatus) +
    SizeOf(FCustomAnswer) +
    SizeOf(FTimeOutForSitDown) +
    SizeOf(FLastTimeActivity) +
    SizeOf(FMoveBetsIsShow) +
    SizeOf(FPotsIsShow);
  //
  Result := Result +
    FCards.MemorySize +
    FChairs.MemorySize +
    FUsers.MemorySize;
end;

{ TBotUserList }

function TBotUserList.Add(aUser: TBotUser): TBotUser;
begin
  Result := aUser;
  Result.FUsers := Self;
//  Result.SetContextByObject(aUser);
  inherited Add(Result as TObject);
end;

function TBotUserList.CountOfActive: Integer;
var
  I: Integer;
  aUser: TBotUser;
begin
  Result := 0;
  for I:=0 to Count - 1 do begin
    aUser := Items[I];
    if aUser.IsWatcher then Continue;
    if (aUser.FInGame > 0) then Inc(Result);
  end;
end;

function TBotUserList.CountOfBots: Integer;
var
  I: Integer;
  aUser: TBotUser;
begin
  Result := 0;
  for I:=0 to Count - 1 do begin
    aUser := Items[I];
    if not aUser.FIsBot then Continue;
    Inc(Result);
  end;
end;

function TBotUserList.CountOfBotWatchers: Integer;
var
  I: Integer;
  aUser: TBotUser;
begin
  Result := 0;
  for I:=0 to Count - 1 do begin
    aUser := Items[I];
    if (not aUser.FIsBot) or (not aUser.IsWatcher) then Continue;
    Inc(Result);
  end;
end;

function TBotUserList.CountWatchers: Integer;
var
  I: Integer;
  aUser: TBotUser;
begin
  Result := 0;
  for I:=0 to Count - 1 do begin
    aUser := Items[I];
    if (not aUser.IsWatcher) then Continue;
    Inc(Result);
  end;
end;

function TBotUserList.CountWithLastAction(aLastAction: TFixAction): Integer;
var
  I: Integer;
  aUser: TBotUser;
begin
  Result := 0;
  for I:=0 to Count - 1 do begin
    aUser := Items[I];
    if aUser.IsWatcher then Continue;
    if (aUser.FInGame > 0) and (aUser.LastAction = aLastAction) then
      Inc(Result);
  end;
end;

constructor TBotUserList.Create(aTable: TBotTable);
begin
  inherited Create;
  FTable := aTable;
end;

procedure TBotUserList.Del(aUser: TBotUser);
begin
  inherited Remove(aUser);
end;

procedure TBotUserList.DelByInd(nIndex: Integer);
var
  aUser: TBotUser;
begin
  aUser := Items[nIndex];
  inherited Remove(aUser);
end;

destructor TBotUserList.Destroy;
begin
  inherited;
end;

procedure TBotUserList.DumpMemory(Level: Integer; sPrefix: string);
var
{$IFDEF DumpItems_ON_MemoryDump}
  I: Integer;
{$ENDIF}
  sShift: string;
begin
  if Level > 0 then sShift := DupeString(Shift_string_On_DumpMemory, Level) else sShift := '';
  Logger.Log(0, ClassName, 'DumpMemory',
    sShift + sPrefix + '[SIZE]: ' + IntToStr(MemorySize), ltCall);

{$IFDEF DumpItems_ON_MemoryDump}
  for I:=0 to Count - 1 do
    Items[I].DumpMemory(Level + 1, sPrefix + '; Items(' + IntToStr(I) + ')');
{$ENDIF}

  sShift := '';
end;

function TBotUserList.GetItems(nIndex: Integer): TBotUser;
begin
  Result := inherited Items[nIndex] as TBotUser;
end;

function TBotUserList.Ins(nIndex: Integer; aUser: TBotUser): TBotUser;
begin
  Result := aUser;
  Result.FUsers := Self;
//  Result.SetContextByObject(aUser);
  inherited Insert(nIndex, Result as TObject);
end;

procedure TBotUserList.KickOfUser(aUser: TBotUser);
var
  aChair: TBotChair;
begin
  if (aUser = nil) then Exit;

  // set chair as empty
  if not aUser.IsWatcher then begin
    aChair := FTable.Chairs.ChairByUserID(aUser.UserID);
    if (aChair <> nil) then begin
      aChair.FUserID := -1;
      aChair.FState := CHS_FREE;
      aChair.FIsActive := False;
    end;
  end;

  Del(aUser);
end;

function TBotUserList.MemorySize: Integer;
var
  I: Integer;
begin
  Result :=
    SizeOf(FTable) +
    SizeOf(Self);
  for I:=0 to Count - 1 do Result := Result + Items[I].MemorySize;
end;

procedure TBotUserList.SetContextByObject(aUsers: TBotUserList);
var
  I: Integer;
begin
  Clear;
  for I:=0 to aUsers.Count - 1 do Add(aUsers.Items[I]);
end;

function TBotUserList.SitDownUser(nUserID, Position, Amount: Integer): TBotUser;
var
  aChair: TBotChair;
  aUser: TBotUser;
begin
  Result := nil;

  { search chair }
  aChair := Table.FChairs.ChairByPosition(Position);
  if (aChair = nil) then Exit; // chair position not found
  if (aChair.State = CHS_BUSY) then Exit; // chair already BUZY
  if (aChair.State = CHS_RESERVED) and (aChair.ReservationUserID <> nUserID) then Exit; // chair reserved for other user

  { search user }
  aUser := UserByID(nUserID);
  if (aUser = nil) then begin
    aUser := UserByPosition(Position);
    if (aUser <> nil) then aUser.FUserID := nUserID;
  end;
  if (aUser = nil) then begin
    // it is new user
    aUser := TBotUser.Create(Self);
    Add(aUser);
  end;

  { sitdown to chair with position }
  aUser.FUserID := nUserID;
  aUser.FPosition := Position;
  aUser.FBetsAmmount := 0;
  aUser.FCurrAmmount := IfThen(Amount <= 0, 0, Amount);
  aUser.FCards.Clear;
  aUser.FLastAction := ACT_SITDOWN;


  aChair.FUserID := aUser.FUserID;
  aChair.FReservationUserID := -1;
  aChair.FState := CHS_BUSY;

  Result := aUser;
end;

function TBotUserList.StandUpUser(Position: Integer): TBotUser;
var
  aChair: TBotChair;
  aUser: TBotUser;
begin
  Result := nil;

  { search chair }
  aChair := Table.FChairs.ChairByPosition(Position);
  if (aChair = nil) then Exit; // chair position not found

  { search user }
  aUser := UserByPosition(Position);

  { standut from chair with position }
  if (aUser <> nil) then
    aUser.FPosition := -1;

  aChair.FUserID := -1;
  if (aChair.State = CHS_BUSY) then
    aChair.FState := CHS_FREE;

  Result := aUser;
end;

function TBotUserList.UserByID(nID: Integer): TBotUser;
var
  aUser: TBotUser;
  I: Integer;
begin
  Result := nil;
  for I:=0 to Count - 1 do begin
    aUser := Items[I];
    if (aUser.FUserID = nID) then begin
      Result := aUser;
      Exit;
    end;
  end;
end;

function TBotUserList.UserByPosition(nPos: Integer): TBotUser;
var
  aUser: TBotUser;
  I: Integer;
begin
  Result := nil;
  for I:=0 to Count - 1 do begin
    aUser := Items[I];
    if (aUser.FPosition = nPos) then begin
      Result := aUser;
      Exit;
    end;
  end;
end;

{ TBotTableList }

function TBotTableList.Add(aTable: TBotTable): TBotTable;
begin
  Result := aTable;
  Result.FProcesses := Self;
//  Result.SetContextByObject(aTable);
  inherited Add(Result as TObject);
end;

constructor TBotTableList.Create(aImmResp, aWaitResp: TBotResponseList);
begin
  inherited Create;
  FImmResponses  := aImmResp;
  FWaitResponses := aWaitResp;
end;

procedure TBotTableList.Del(aTable: TBotTable);
begin
  inherited Remove(aTable);
end;

procedure TBotTableList.DelByInd(nIndex: Integer);
var
  aTable: TBotTable;
begin
  aTable := Items[nIndex];
  inherited Remove(aTable);
end;

destructor TBotTableList.Destroy;
begin
  inherited;
end;

procedure TBotTableList.DumpMemory(Level: Integer; sPrefix: string);
var
{$IFDEF DumpItems_ON_MemoryDump}
  I: Integer;
{$ENDIF}
  sShift: string;
begin
  if Level > 0 then sShift := DupeString(Shift_string_On_DumpMemory, Level) else sShift := '';
  Logger.Log(0, ClassName, 'DumpMemory',
    sShift + sPrefix + '[SIZE]: ' + IntToStr(MemorySize), ltCall);

{$IFDEF DumpItems_ON_MemoryDump}
  for I:=0 to Count - 1 do
    Items[I].DumpMemory(Level + 1, sPrefix + '; Items(' + IntToStr(I) + ')');
{$ENDIF}

  sShift := '';
end;

function TBotTableList.GetItems(nIndex: Integer): TBotTable;
begin
  Result := inherited Items[nIndex] as TBotTable;
end;

function TBotTableList.Ins(nIndex: Integer; aTable: TBotTable): TBotTable;
begin
  Result := aTable;
  Result.FProcesses := Self;
//  Result.SetContextByObject(aTable);
  inherited Insert(nIndex, Result as TObject);
end;

function TBotTableList.MemorySize: Integer;
var
  I: Integer;
begin
  Result := SizeOf(Self);
  for I:=0 to Count - 1 do Result := Result + Items[I].MemorySize;
end;

procedure TBotTableList.OnResponse(sResponse: string;
  aType: TFixVisualizationType; aActionType: TFixAction;
  DateEntry: TDateTime; nProcessID, nUserID: Integer);
var
  I: Integer;
  aRsp: TBotResponse;
begin
  if ((nProcessID <= 0) or (nUserID <= 0)) and (sResponse <> '') then begin
    Logger.Log(-1, ClassName, 'OnResponse',
      '[Error]: Try send not empty XML when Process or User is nil. ' +
        'Parameters: XML=[' + sResponse + '], Type=' + GetFixVisualizationTypeAsString(aType) + ', ' +
        'Action=' + GetFixActionAsString(aActionType),
      ltError
    );
    Exit;
  end;

  { add to all list of resposes }
  if (aType in [VST_PROCINIT, VST_PROCSTATE]) or
     ( (aType = VST_ACTION) and
       (aActionType in [ACT_MORECHIPS, ACT_LEAVETABLE, ACT_SITDOWN, ACT_SITOUTNEXTHAND])
     )
  then begin
    if (aActionType = ACT_LEAVETABLE) then begin
      { Clear All Responses for User }
      I:=0;
      CriticalSectionResponse.Enter;
      try
        while I < FImmResponses.Count do begin
          aRsp := FImmResponses.Item[I];
          if (aRsp.UserID = nUserID) then
            FImmResponses.Del(aRsp)
          else
            Inc(I);
        end;
      finally
        CriticalSectionResponse.Leave;
      end;

      I:=0;
      CriticalSectionResponse.Enter;
      try
        while I < FWaitResponses.Count do begin
          aRsp := FWaitResponses.Item[I];
          if (aRsp.UserID = nUserID) then
            FWaitResponses.Del(aRsp)
          else
            Inc(I);
        end;
      finally
        CriticalSectionResponse.Leave;
      end;
    end;

    { immeduteally responses }
    if (sResponse <> '') then begin
      CriticalSectionResponse.Enter;
      try
        FImmResponses.Add(sResponse, aType, aActionType, DateEntry, nProcessID, nUserID);
      finally
        CriticalSectionResponse.Leave;
      end;
    end;
  end else begin
    { set answer of bots }
    if (aType = VST_ACTION) then begin
      if (nProcessID <= 0) or (nUserID <= 0) then begin
        Logger.Log(-1, ClassName, 'OnResponse',
          '[Error]: Try send action answer when Process or user is nil. ' +
            'Parameters: XML=[' + sResponse + '], Type=' + GetFixVisualizationTypeAsString(aType) + ', ' +
            'Action=' + GetFixActionAsString(aActionType),
          ltError
        );
        Exit;
      end else begin
        Logger.Log(nUserID, ClassName, 'OnResponse',
          'Response action will be added to buffer; ' +
            'Parameters: DateEntry=' + DateTimeToStr(DateEntry) + ', XML=[' + sResponse + '], Type=' + GetFixVisualizationTypeAsString(aType) + ', ' +
            'Action=' + GetFixActionAsString(aActionType),
          ltCall
        );
      end;
    end;
    CriticalSectionResponse.Enter;
    try
      FWaitResponses.Add(sResponse, aType, aActionType, DateEntry, nProcessID, nUserID);
    finally
      CriticalSectionResponse.Leave;
    end;
  end;
end;

function TBotTableList.TableByProcessID(nProcessID: Integer): TBotTable;
var
  I: Integer;
  aTable: TBotTable;
begin
  Result := nil;
  for I:=0 to Count - 1 do begin
    aTable := Items[I];
    if (aTable.FProcessID = nProcessID) then begin
      Result := aTable;
      Exit;
    end;
  end;
end;

end.
