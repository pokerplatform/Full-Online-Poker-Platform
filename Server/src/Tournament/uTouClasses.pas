unit uTouClasses;

interface

uses Classes, Contnrs, SysUtils, XMLIntf, XMLDoc
// PO
  , uSQLAdapter
  , uXMLActions
  , uBotConstants
  ;

type
// *************************************
// User context item
// *************************************
  TpoTournUser = class(TObject)
  private
    // user
    FUserID: Integer;
    FChips: Currency;
    FPlace: Integer;
    FMemPlace: Integer;
    FChipsBeforeLost: Currency;
    FProcessIDOnLost: Integer;
    FAvatarID: Integer;
    FSexID: Integer;
    FSessionId: Integer;
    FLoginName: string;
    FLocation: string;
    FProcessID: Integer;
    FLostTime: TDateTime;
    FIsKickOffByAdministrator: Boolean;
    FIsBot: Boolean;
    FBotBlaffersEvent: Integer;
    FBotID: Integer;
    FBotCharacter: TFixUserCharacter;
    FIsTakedSit: Boolean;
    FRebuyAuto: Boolean;
    FRebuyCount: Integer;
    FRebuyAddOnceUsed: Boolean;
    FLevelID: Integer;
    FIcons: TStringList;
    procedure SetProcessID(const Value: Integer);
    procedure SetUserID(const Value: Integer);
    procedure SetAvatarID(const Value: Integer);
    procedure SetChips(const Value: Currency);
    procedure SetLostTime(const Value: TDateTime);
    procedure SetChipsBeforeLost(const Value: Currency);
    procedure SetProcessIDOnLost(const Value: Integer);
    procedure SetLocation(const Value: string);
    procedure SetLoginName(const Value: string);
    procedure SetPlace(const Value: Integer);
    procedure SetSessionId(const Value: Integer);
    procedure SetSexID(const Value: Integer);
    function GetIsFinished: Integer;

    // Internal functionalities
    procedure GetDataFromNode(Node: IXMLNode);
    procedure SetAsLost(LostTM: TDateTime; nOrder: Integer);

    // Get XML NODE TEXT informations
    function GetNodeOnCommand_GE_XML(const ProcessID: Integer; sNodeName: string; RebuyChips: Currency = 0): string;
    function toGetPlayers_LOBBY_XML: string;
    function toGetProcessPlayers_LOBBY_XML(const ProcessID: Integer): string;
    // notification
    function ProcCloseNotify(ByProcessID: Boolean; Msg: string; aResponce: TXMLRespActions): Integer;
    procedure SetIsKickOffByAdministrator(const Value: Boolean);
    // bots
    procedure SetBotBlaffersEvent(const Value: Integer);
    procedure SetBotCharacter(const Value: TFixUserCharacter);
    procedure SetBotID(const Value: Integer);
    procedure SetIsBot(const Value: Boolean);
    procedure SetIsTakedSit(const Value: Boolean);
    procedure SetRebuyAuto(const Value: Boolean);
    procedure SetRebuyCount(const Value: Integer);
    function GetBuyInCount: Integer;
    procedure SetRebuyAddOnceUsed(const Value: Boolean);
    procedure SetLevelID(const Value: Integer);
//    function MessageBoxNotify(Msg: string; aResponce: TXMLRespActions): Integer;

  public
    // Functionalities with DB
    function StoreToDB(const TournamentID: Integer; SQLAdapter: TSQLAdapter): Integer;
    function LoadFromDB(const TournamentID: Integer; SQLAdapter: TSQLAdapter): Integer;

  public
    // process context
    property ProcessID: Integer read FProcessID write SetProcessID;
    property ProcessIDOnLost: Integer read FProcessIDOnLost write SetProcessIDOnLost;

    // user context data
    property UserID: Integer read FUserID write SetUserID;
    property Place: Integer read FPlace write SetPlace;
    property Chips: Currency read FChips write SetChips;
    property RebuyAuto: Boolean read FRebuyAuto write SetRebuyAuto;
    property RebuyCount: Integer read FRebuyCount write SetRebuyCount;
    property RebuyAddOnceUsed: Boolean read FRebuyAddOnceUsed write SetRebuyAddOnceUsed;
    property LostTime: TDateTime read FLostTime write SetLostTime;
    property SexID: Integer read FSexID write SetSexID;
    property AvatarID: Integer read FAvatarID write SetAvatarID;
    property LevelID: Integer read FLevelID write SetLevelID;
    property Icons: TStringList read FIcons;
    property Location: string read FLocation write SetLocation;
    property LoginName: string read FLoginName write SetLoginName;
    property SessionId: Integer read FSessionId write SetSessionId;
    property ChipsBeforeLost: Currency read FChipsBeforeLost write SetChipsBeforeLost;
    property IsKickOffByAdministrator: Boolean read FIsKickOffByAdministrator write SetIsKickOffByAdministrator;
    property IsTakedSit: Boolean read FIsTakedSit write SetIsTakedSit;
    // bots context
    property IsBot: Boolean read FIsBot write SetIsBot;
    property BotCharacter: TFixUserCharacter read FBotCharacter write SetBotCharacter;
    property BotBlaffersEvent: Integer read FBotBlaffersEvent write SetBotBlaffersEvent;
    property BotID: Integer read FBotID write SetBotID;

    // read only property
    property IsFinished: Integer read GetIsFinished;
    property BuyInCount: Integer read GetBuyInCount;

    // Internal functionalities
    function SetContextByObject(FromUser: TpoTournUser): Integer;
    // constructor & destructor
    constructor Create;
    destructor Destroy; override;
  end;

// *************************************
// User list context
// *************************************
  TpoTournUserList = class(TObjectList)
  private
    function GetItems(Index: Integer): TpoTournUser;

    // private block for working with DB
    function RegisterParticipantIntoDB(TournamentID, FromTournamentID, UserID: Integer;
      Chips, BuyIn, Fee: Currency; CurrencyTypeID, BotID, BotCharacter, BotBlaffers: Integer;
      SQLAdapter: TSQLAdapter): Integer;
    function UnRegisterParticipantFromDB(TournamentID, UserID: Integer;
      BuyIn, Fee: Currency; CurrencyTypeID: Integer;
      SQLAdapter: TSQLAdapter): Integer;

    function GetCountOnProcess(nProcessID: Integer): Integer;
    function GetActiveCount: Integer;
    // Get XML NODE TEXT informations
    function GetNodeListOnCommand_GE_XML(const ProcessID: Integer; sNodeName: string;
      RebuyChips: Currency = 0): string;
    function GetNodeListOnKickOffByAdministrator(const ProcessID: Integer; sNodeName: string): string;
    // notification
    function ProcCloseNotify(ByProcessID: Boolean; Msg: string; aResponce: TXMLRespActions): Integer;
    function GetMinChips(nProcessID: Integer): Currency;
    function GetMaxChips(nProcessID: Integer): Currency;
    function GetAvgChips(nProcessID: Integer): Currency;
    // internal functions
    function GetFirstUserByProcessID(nProcessID: Integer): TpoTournUser;
    function GetUserByProcessIDAndPlace(nProcessID, nPlace: Integer): TpoTournUser;
    function GetLostCount: Integer;
    // Bots
    function RegisterBots(nTournamentID, nBotCount: Integer;
      Chips, BuyIn, Fee: Currency; CurrencyTypeID, BotCharacter: Integer;
      SQLAdapter: TSQLAdapter): Integer;
    function GetBotsData(aTempUsers: TpoTournUserList): Integer;
    function GetBuyInCount: Integer;
  public
    property Items[Index: Integer]: TpoTournUser read GetItems;

    // read only properties
    property CountOnProcess[nProcessID: Integer]: Integer read GetCountOnProcess;
    property ActiveCount: Integer read GetActiveCount;
    property LostCount: Integer read GetLostCount;
    property BuyInCount: Integer read GetBuyInCount;

    // Sort functions
    function SortByPlace(Ascending: Boolean): Integer;
    function SortByLostTime(Ascending: Boolean): Integer;
    function SortByChips(Ascending: Boolean): Integer;
    function SortByChipsBeforeLost(Ascending: Boolean): Integer;
    //
    procedure Del(Item: TpoTournUser);
    // Add Item to the lists
    function Add: TpoTournUser;
    function Ins(Index: Integer): TpoTournUser;

    // Functionalities with DB
    function LoadFromDB( TournamentID: Integer; SQLAdapter: TSQLAdapter): Integer;
    function StoreToDB( TournamentID: Integer; SQLAdapter: TSQLAdapter): Integer;
    function RegisterParticipant(TournamentID, FromTournamentID, UserID: Integer;
      Chips, BuyIn, Fee: Currency; CurrencyTypeID, BotID, BotCharacter, BotBlaffers: Integer;
      SQLAdapter: TSQLAdapter): Integer;
    function UnRegisterParticipant(TournamentID, UserID: Integer;
      BuyIn, Fee: Currency; CurrencyTypeID: Integer;
      SQLAdapter: TSQLAdapter): Integer;

    // Internal functionalities
    function SetContextByObject(FromObj: TpoTournUserList): Integer;
    function GetUserByID(nID: Integer): TpoTournUser;
    function GetUserByBotID(nBotID: Integer): TpoTournUser;
    function GetUserByName(sName: string): TpoTournUser;
    // constructor & destructor
    constructor Create;
    destructor Destroy; override;
  end;

// *************************************
// Tournament Process context
// *************************************
  TpoTournProcess = class(TObject)
  private
    //
    FMinStack: Currency;
    FMaxStack: Currency;
    FAvgStack: Currency;
    FHandCount: Integer;
    FTournamentID: Integer;
    FStatusID: Integer;
    FProcessID: Integer;
    FName: string;
    FLevel: Integer;
    FStartResumeTime: TDateTime;
    procedure SetAvgStack(const Value: Currency);
    procedure SetMaxStack(const Value: Currency);
    procedure SetMinStack(const Value: Currency);
    procedure SetHandCount(const Value: Integer);
    procedure SetProcessID(const Value: Integer);
    procedure SetStatusID(const Value: Integer);
    procedure SetTournamentID(const Value: Integer);
    procedure SetName(const Value: string);
    procedure SetLevel(const Value: Integer);
    procedure SetStartResumeTime(const Value: TDateTime);
    function GetIsRunning: Boolean;
    function GetIsUnused: Boolean;
    function GetIsWaiting: Boolean;

    procedure GetDataFromNode(Node: IXMLNode);
    // Get XML NODE TEXT informations
    function GetCommandToGameEngine(
      Command, Msg, ChatMsg, Event, ExceptUserIDs: string;
      Stake, Ante, RebuyChips: Currency; CountPlaces, ActionDispatcherID, BreakDuration: Integer;
      PlayersIn, PlayersOut: TpoTournUserList): string;
    function toGetProcesses_LOBBY_XML(Players: TpoTournUserList; ActionDispatcherID: Integer): string;

  public
    // Tournament context; EXTERNAL (sets on add in list)
    property TournamentID: Integer read FTournamentID write SetTournamentID;

    // process context
    property ProcessID: Integer read FProcessID write SetProcessID;
    property Name: string read FName write SetName;
    // ----------------------------------------------------------
    //  pstUnused  = 0;  // GameProcess unused by any Tournament
    //  pstRunning = 1;  // GameProcess is running (hand active)
    //  pstWaiting = 2;  // GameProcess is waiting - DEFAULT
    property StatusID: Integer read FStatusID write SetStatusID;
    property Level: Integer read FLevel write SetLevel;
    property StartResumeTime: TDateTime read FStartResumeTime write SetStartResumeTime;
    // read only properties
    property IsUnused: Boolean read GetIsUnused;
    property IsRunning: Boolean read GetIsRunning;
    property IsWaiting: Boolean read GetIsWaiting;
    // ----------------------------------------------------------

    // stats context
    property MinStack: Currency read FMinStack write SetMinStack; // DEFAULT (0)
    property AvgStack: Currency read FAvgStack write SetAvgStack; // DEFAULT (0)
    property MaxStack: Currency read FMaxStack write SetMaxStack; // DEFAULT (0)
    property HandCount: Integer read FHandCount write SetHandCount; // DEFAULT (1)

    // Internal functionalities
    function SetContextByObject(FromObj: TpoTournProcess): Integer;
    // constructor & destructor
    constructor Create;

  public
    // Functionalities with DB
    function StoreToDB(const TournamentID: Integer; SQLAdapter: TSQLAdapter): Integer;
    function LoadFromDB(const TournamentID: Integer; SQLAdapter: TSQLAdapter): Integer;

  end;

// *************************************
// Tournament Processes context
// *************************************
  TpoTournProcessList = class(TObjectList)
  private
    FTournamentID: Integer;
    FLargestStack: Currency;
    FSmallestStack: Currency;
    FAverageStack: Currency;
    FSumAllHand: Integer;
    function GetItems(Index: Integer): TpoTournProcess;
    procedure SetTournamentID(const Value: Integer);

    // Sort functions
    function SortByName(Ascending: Boolean): Integer;
    // stats context
    procedure SetAverageStack(const Value: Currency);
    procedure SetLargestStack(const Value: Currency);
    procedure SetSmallestStack(const Value: Currency);
    // read only
    function GetActiveCount: Integer;
    function GetWatingCount: Integer;
    // Get XML NODE TEXT informations
    function toGetProcesses_LOBBY_XML(Players: TpoTournUserList; ActionDispatcherID: Integer): string;
    procedure SetSumAllHand(const Value: Integer);
    function GetAverageStack: Currency;

  public
    property TournamentID: Integer read FTournamentID write SetTournamentID;
    property Items[Index: Integer]: TpoTournProcess read GetItems;

    // stats context
	  property SmallestStack: Currency read FSmallestStack write SetSmallestStack;
	  property AverageStack: Currency read FAverageStack write SetAverageStack;
	  property LargestStack: Currency read FLargestStack write SetLargestStack;
    property SumAllHand: Integer read FSumAllHand write SetSumAllHand;

    // read only property
	  property ActiveCount: Integer read GetActiveCount;
	  property WatingCount: Integer read GetWatingCount;

    // methods
    procedure Del(Item: TpoTournProcess);
    // Add Item to the list
    function Add: TpoTournProcess;
    function Ins(Index: Integer): TpoTournProcess;

    // Functionalities with DB
    function LoadFromDB(SQLAdapter: TSQLAdapter): Integer;
    function StoreToDB(SQLAdapter: TSQLAdapter): Integer;
    function RegistrationProcess(EngineID: Integer; nStartStack: Currency;
      Name: string; SQLAdapter: TSQLAdapter): Integer;

    // Internal functionalities
    function SetContextByObject(FromObj: TpoTournProcessList): Integer;
    function GetProcessByID(nID: Integer): TpoTournProcess;
    // constructor & destructor
    constructor Create(TournamentID: Integer);
    destructor Destroy; override;
  end;

// ************************************************
// Pay schema and betting structure context record
// ************************************************
  TtsTournament = class;

// *************************************
// Betting schema context record
// *************************************
  TpoTournBettingList = class;

  TpoTournBetting = class(TObject)
  private
    FStake: Currency;
    FAnte: Currency;
    FLevel: Integer;
    FBettingList: TpoTournBettingList;
    procedure SetAnte(const Value: Currency);
    procedure SetStake(const Value: Currency);
    procedure SetLevel(const Value: Integer);
    //
    function SetContextByNode(aNode: IXMLNode): Integer;
    function GetStakeInfo(LevelInterval: Integer): string;
  public
    property Level: Integer read FLevel write SetLevel;
    property Stake: Currency read FStake write SetStake;
    property Ante: Currency read FAnte write SetAnte;
    property BettingList: TpoTournBettingList read FBettingList;
    // Internal functionalities
    function SetContextByObject(FromObj: TpoTournBetting): Integer;
    // constructor & destructor
    constructor Create(aBettingList: TpoTournBettingList);
  end;

// *************************************
// Betting schema context record list
// *************************************
  TpoTournBettingList = class(TObjectList)
  private
    FCoefficient: Currency;
    FOwner: TtsTournament;
    function GetItems(Index: Integer): TpoTournBetting;
    procedure SetCoefficient(const Value: Currency);
    //
    procedure SetDefault;
    function GetStakeInfoByCoefficientAsXml(nLevel, LevelInterval: Integer): string;
    procedure SortAndUpdateLevels;
    function GetAnte(nLevel: Integer): Currency;
    function GetStake(nLevel: Integer): Currency;
    procedure SetInitialStake(const Value: Currency);
    function GetInitialStake: Currency;
  public
    property Owner: TtsTournament read FOwner;
    property InitialStake: Currency read GetInitialStake write SetInitialStake;
    property Coefficient: Currency read FCoefficient write SetCoefficient;
    //
    property Items[Index: Integer]: TpoTournBetting read GetItems;
    property Stake[nLevel: Integer]: Currency read GetStake;
    property Ante[nLevel: Integer]: Currency read GetAnte;
    //
    procedure Del(Item: TpoTournBetting);
    function Add: TpoTournBetting;
    // load & store
    function LoadFromDB(const TournamentID: Integer; SQLAdapter: TSQLAdapter): Integer;
    function StoreIntoDB(TournamentID: Integer; sData: string; SQLAdapter: TSQLAdapter): Integer;
    function LoadFromAdmSiteXML(sXML: string): Integer;
    function LoadFromNode(aNode: IXMLNode): Integer;
    // Internal functionalities
    function SetContextByObject(FromObj: TpoTournBettingList): Integer;
    function GetStakeInfo(nLevel, LevelInterval: Integer; IsXML: Boolean = False): string;
    // constructor & destructor
    constructor Create(aOwner: TtsTournament);
    destructor Destroy; override;
  end;

// *************************************
// Pay schema context record
// *************************************
  TpoTournPrizeRateList = class;

  TpoTournPrizeRate = class(TObject)
  private
    //
    FPrizeRate: Currency;
    FPlace: Integer;
    FIsHandForHand: Boolean;
    FPrizeList: TpoTournPrizeRateList;
    FNonCurrencyPrize: string;
    procedure SetPlace(const Value: Integer);
    procedure SetPrizeRate(const Value: Currency);
    procedure SetIsHandForHand(const Value: Boolean);
    // for Lobby
    function GetPrizePool_NodeXMLToLobby(TotalPrize: Currency; isShortData: Boolean = False): string;
    procedure SetNonCurrencyPrize(const Value: string);

  public
    property Place: Integer read FPlace write SetPlace;
    property PrizeRate: Currency read FPrizeRate write SetPrizeRate;
    property NonCurrencyPrize: string read FNonCurrencyPrize write SetNonCurrencyPrize;
    property IsHandForHand: Boolean read FIsHandForHand write SetIsHandForHand;
    property PrizeList: TpoTournPrizeRateList read FPrizeList;
    // Internal functionalities
    function PrizeValue(TotalPrize: Currency): Currency;
    function SetContextByObject(FromObj: TpoTournPrizeRate): Integer;
    // constructor & destructor
    constructor Create(aPrizeList: TpoTournPrizeRateList);
  end;

// *************************************
// Pay schema context record list
// *************************************
  TpoTournPrizeRateList = class(TObjectList)
  private
    FPrizePoolXML: string;
    FPrizeValueType: Integer;
    FCurrencyTypeID: Integer;
    FPrizeTypeID: Integer;
    FCurrencySign: string;
    FName: string;
    FNumberOfPlayersForFinish: Integer;
    FCurrencyName: string;
    //
    function GetItems(Index: Integer): TpoTournPrizeRate;
    procedure SetDefault;
    procedure SetSatelited(aTournament: TtsTournament);
    procedure SetPrizePoolXML(const Value: string);
    procedure SetCurrencyTypeID(const Value: Integer);
    procedure SetPrizeValueType(const Value: Integer);
    procedure SetPrizeTypeID(const Value: Integer);
    procedure SetCurrencySign(const Value: string);
    procedure SetName(const Value: string);
    // for Lobby
    function GetDataPrizePool_ToLobby(TotalPrize: Currency; isShortData: Boolean = False): string;
    procedure SetNumberOfPlayersForFinish(const Value: Integer);
    procedure SetCurrencyName(const Value: string);
  public
    property PrizePoolXML: string read FPrizePoolXML write SetPrizePoolXML;
    property CurrencyTypeID: Integer read FCurrencyTypeID write SetCurrencyTypeID;
    property PrizeValueType: Integer read FPrizeValueType write SetPrizeValueType;
    property PrizeTypeID: Integer read FPrizeTypeID write SetPrizeTypeID;
    property Name: string read FName write SetName;
    property CurrencySign: string read FCurrencySign write SetCurrencySign;
    property CurrencyName: string read FCurrencyName write SetCurrencyName;
    property NumberOfPlayersForFinish: Integer read FNumberOfPlayersForFinish write SetNumberOfPlayersForFinish;
    //
    property Items[Index: Integer]: TpoTournPrizeRate read GetItems;
    //
    procedure Del(Item: TpoTournPrizeRate);
    function Add: TpoTournPrizeRate;
    function Ins(Index: Integer): TpoTournPrizeRate;
    function ItemsByPlace(nPlace: Integer): TpoTournPrizeRate;

    // load & store
//    function LoadFromDB(const TournamentID: Integer; SQLAdapter: TSQLAdapter): Integer;
    function LoadFromAdmSiteXML(FTournament: TtsTournament): Integer;
    // Internal functionalities
    function SetContextByObject(FromObj: TpoTournPrizeRateList): Integer;
    // constructor & destructor
    constructor Create(TournamentID: Integer);
    destructor Destroy; override;
  end;

// *************************************
// All Rules Pay schema context record list
// *************************************
  TpoTournPrizeRulesList = class(TObjectList)
  private
    FTournamentID: Integer;
    function GetItems(Index: Integer): TpoTournPrizeRateList;
    procedure SetTournamentID(const Value: Integer);
    // for Lobby
    function GetDataPrizePool_ToLobby(TotalPrize: Currency;isShortData: Boolean = False): string;
    function GetNumberOfPlayersForFinish: Integer;
  public
    property TournamentID: Integer read FTournamentID write SetTournamentID;
    property NumberOfPlayersForFinish: Integer read GetNumberOfPlayersForFinish;
    property Items[Index: Integer]: TpoTournPrizeRateList read GetItems;
    //
    procedure Del(Item: TpoTournPrizeRateList);
    function Add(sName, sCurrSign, sCurrName: string): TpoTournPrizeRateList;
    function Ins(Index: Integer; sName, sCurrSign, sCurrName: string): TpoTournPrizeRateList;
    // load & store
    function LoadFromDB(SQLAdapter: TSQLAdapter): Integer;
    function StoreIntoDB(SQLAdapter: TSQLAdapter; sData: string): Integer;
    function LoadFromAdmSiteXML(FTournament: TtsTournament): Integer;
    // Internal functionalities
    function SetContextByObject(FromObj: TpoTournPrizeRulesList): Integer;
    function FindItemByTypeID(nTypeID: Integer): TpoTournPrizeRateList;
    // constructor & destructor
    constructor Create(TournamentID: Integer);
    destructor Destroy; override;
  end;

// *************************************
// Tournament record context
// *************************************
  TtsTournamentList = class;
  //
  TtsTournament = class(TObject)
  private
    //
    FFee: Currency;
    FInitialStake: Currency;
    FBuyIn: Currency;
    FChips: Currency;
    FBreakDuration: Integer;
    FTournamentInterval: Integer;
    FBreakInterval: Integer;
    FCurrencyTypeID: Integer;
    FStakeType: Integer;
    FTournamentID: Integer;
    FGameEngineID: Integer;
    FSittingDuration: Integer;
    FTournamentStatusID: Integer;
    FPlayerPerTable: Integer;
    FTournamentTypeID: Integer;
    FTournamentLevel: Integer;
    FMasterTournamentID: Integer;
    FHandForHandPlayers: Integer;
    FLevelInterval: Integer;
    FStatusID: Integer;
    FName: string;
    FTournamentStartTime: TDateTime;
    FRegistrationStartTime: TDateTime;
    FTournamentFinishTime: TDateTime;
    FNextBreakTime: TDateTime;
    FNextLevelTime: TDateTime;
    FStakeName: string;
    FGameTypeName: string;
    FMasterFee: Currency;
    FMasterBuyIn: Currency;
    FPrizes: TpoTournPrizeRulesList;
    FProcesses: TpoTournProcessList;
    FPlayers: TpoTournUserList;
    FNextAutosaveTime: TDateTime;
    FStartPauseByAdmin: TDateTime;
    FPrevTournamentStatusID: Integer;
    FMaxRegisteredLimit: Integer;
    FBettings: TpoTournBettingList;
    FTournamentStartEvent: Integer;
    FActionDispatcherID: Integer;
    FTournamentCategory: Integer;
    FActions: TXMLRespActions;
    FOwner: TtsTournamentList;
    FPassword: string;
    FCurrencySign: string;
    FCurrencyName: string;
    FTimeOutForKickOff: Integer;
    FStartKickOffNotTakedSit: TDateTime;
    FRebuyIsAllowed: Boolean;
    FMaximumRebuyCount: Integer;
    FAddOnIsAllowed: Boolean;
    FRebuyWasAllowedOnCreate: Boolean;
    FAddOnWasAllowedOnCreate: Boolean;
    FPauseCount: Integer;
    procedure SetBreakDuration(const Value: Integer);
    procedure SetTimeOutForKickOff(const Value: Integer);
    procedure SetBreakInterval(const Value: Integer);
    procedure SetBuyIn(const Value: Currency);
    procedure SetChips(const Value: Currency);
    procedure SetCurrencyTypeID(const Value: Integer);
    procedure SetFee(const Value: Currency);
    procedure SetGameEngineID(const Value: Integer);
    procedure SetHandForHandPlayers(const Value: Integer);
    procedure SetInitialStake(const Value: Currency);
    procedure SetLevelInterval(const Value: Integer);
    procedure SetMasterTournamentID(const Value: Integer);
    procedure SetName(const Value: string);
    procedure SetNextBreakTime(const Value: TDateTime);
    procedure SetNextLevelTime(const Value: TDateTime);
    procedure SetPlayerPerTable(const Value: Integer);
    procedure SetRegistrationStartTime(const Value: TDateTime);
    procedure SetSittingDuration(const Value: Integer);
    procedure SetStakeType(const Value: Integer);
    procedure SetStatusID(const Value: Integer);
    procedure SetTournamentFinishTime(const Value: TDateTime);
    procedure SetTournamentID(const Value: Integer);
    procedure SetTournamentInterval(const Value: Integer);
    procedure SetTournamentLevel(const Value: Integer);
    procedure SetTournamentStartTime(const Value: TDateTime);
    procedure SetTournamentStatusID(const Value: Integer);
    procedure SetTournamentTypeID(const Value: Integer);
    procedure SetStakeName(const Value: string);
    procedure SetGameTypeName(const Value: string);
    procedure SetNextAutosaveTime(const Value: TDateTime);
    function GetIsAnnouncing: Boolean;
    function GetIsBreak: Boolean;
    function GetIsCompleted: Boolean;
    function GetIsStopped: Boolean;
    function GetIsRegistration: Boolean;
    function GetIsResuming: Boolean;
    function GetIsRunning: Boolean;
    function GetIsSitting: Boolean;
    function GetIsStartKickingOff: Boolean;
    function GetIsNoEntrants: Boolean;
    function GetIsPauseByAdmin: Boolean;
    function GetNameOfState: string;
    procedure SetMasterBuyIn(const Value: Currency);
    procedure SetMasterFee(const Value: Currency);
    procedure SetPlayers(const Value: TpoTournUserList);
    procedure SetPrizes(const Value: TpoTournPrizeRulesList);
    procedure SetProcesses(const Value: TpoTournProcessList);
    function GetEntrants: Integer;
    function GetTotalPrize: Currency;
    function GetTotalFee: Currency;
    function GetAverageStack: Currency;
    function GetLargestStack: Currency;
    function GetSmallestStack: Currency;
    function GetActivePlayers: Integer;
    function GetActiveProcesses: Integer;
    function GetOptimalTables: Integer;
    function GetOptimalMinPlayersPerTable: Integer;
    function GetOptimalMaxPlayersPerTable: Integer;
    function GetOptimalRestPlayersPerTable(RestCountTables, RestCountPlayers: Integer): Integer;
    function GetNumberOfPlayersForFinish: Integer;
    //
    function GetIsHandForHand: Boolean;
    function GetStake: Currency;
    function GetNextBreakEndTime: TDateTime;
    //
    // for function toGetInfo_LOBBY_XML only
    function LOBBY_toGetInfo_Base: string;
    function LOBBY_toGetInfo_PrizeRules: string;
    function LOBBY_toGetInfo_Advanced: string;
    function LOBBY_toGetInfo_PrizePool: string;
    function toGetPlayers_LOBBY_XML: string;
    function toGetProcessPlayers_LOBBY_XML(const ProcessID: Integer): string;
    //
    // private Functionalities with DB
    function StopTournament_SQL(SQLAdapter: TSQLAdapter): Integer;
    function FinishTournament_SQL(SQLAdapter: TSQLAdapter; aResponce: TXMLRespActions): Integer;
    function MakeTournamentMoneyTransactions_SQL(CurrTypeID, CntExec: Integer; SQLAdapter: TSQLAdapter; aResponce: TXMLRespActions): Integer;
    //
    procedure InitializeNewOnFinish(SQLAdapter: TSQLAdapter);
    function InitializeNewOnFinish_SQL(NewStartTime: TDateTime; SQLAdapter: TSQLAdapter;
      var NewTournamentID: Integer): Integer;
    // Internal functionalities
    procedure GetDataFromNode(Node: IXMLNode);
    function GetFirstEmptyPlaceOnProcess(nProcessID: Integer): Integer;
    procedure ResittingAllPlayersFromTable(aFromPrc: TpoTournProcess;
      aResponce: TXMLRespActions; SQLAdapter: TSQLAdapter);
    procedure ResittingRichersPlayersFromTable(
      aFromPrc: TpoTournProcess; CntResitting: Integer;
      aResponce: TXMLRespActions; SQLAdapter: TSQLAdapter);
    function SeekMinCountPlayersProcess(NotUseProcessID: Integer): TpoTournProcess;
    procedure FreeProcess(aPrc: TpoTournProcess; aResponce: TXMLRespActions);
    procedure CheckOfResitingPlayersFromProcess(
      WasHandForHand: Boolean; aProcess: TpoTournProcess;
      aResponce: TXMLRespActions; SQLAdapter: TSQLAdapter);
    procedure StartAllProcessAfterBreak(NeedCheckWaitings, NeedSendEndBreak: Boolean;
      sMsg: String; aResponce: TXMLRespActions);
    procedure SortPlayersOnFinish(aPlayers: TpoTournUserList);
    // Get XML TEXT informations
    function GetCurrentValuesXML: string;
    // tournament logic functionalities
    function StartRegistration(aActions: TXMLRespActions): Integer;
    procedure AutoRegistrationFromSatelited;
    function StartSitting(aActions: TXMLRespActions): Integer;
    function StartRunning(aActions: TXMLRespActions): Integer;
    function StartKickingOff(aActions: TXMLRespActions): Integer;
    function StartBreak: Integer;
    function StartBreakEnd(aActions: TXMLRespActions): Integer;
    function StartAutosave: Integer;
    procedure SetStartPauseByAdmin(const Value: TDateTime);
    procedure SetMaxRegisteredLimit(const Value: Integer);
    function GetIsSitAndGO: Boolean;
    procedure SetBettings(const Value: TpoTournBettingList);
    function GetAnte: Currency;
    procedure SetTournamentStartEvent(const Value: Integer);
    procedure SetActionDispatcherID(const Value: Integer);
    procedure SetTournamentCategory(const Value: Integer);
    procedure SetStartKickOffNotTakedSit(const Value: TDateTime);
    //
    function GetPrizeValue(PrizeNumber, Place: Integer; TotalPrize: Currency): Currency;
    function GetNonCurrencyPrizeValue(PrizeNumber, Place: Integer): string;
    procedure SendCongratilationNotifyAndMail(aResponce: TXMLRespActions;
      sNonCurrPrize, sCurSign: string; nMoney: Currency; nUserID, nPlace: Integer);
    procedure SetPassword(const Value: string);
    function GetTypesForLobby: string;
    procedure SetCurrencySign(const Value: string);
    procedure SetCurrencyName(const Value: string);
    //
    function KickOffUserByID(nUserID: Integer; FSQL: TSQLAdapter; var Msg: string): Integer;
    // Bots
    function BotGetTournamentInfo: string;
    function BotsRegister(nBotCharacter, nBotPerProcess: Integer;
      SqlAdapter: TSQLAdapter; var errCode: Integer): string;
    function BotStandUp(aInpAction: TXMLAction;
      FSql: TSQLAdapter; var errCode: Integer): string;
    function BotStandUpAll(nTournamentID: Integer;
      FSql: TSQLAdapter; var errCode: Integer): string;
    function BotPolicy(aInpAction: TXMLAction;
      FSql: TSQLAdapter; var errCode: Integer): string;
    //
    function Flash_GAAction_Chair(sStatus, sPlayerNode: string;
      nProcessID, nPosition: Integer): string;
    procedure UpdateLobbyInfo(FSql: TSQLAdapter);
    procedure SetMaximumRebuyCount(const Value: Integer);
    procedure SetRebuyIsAllowed(const Value: Boolean);
    function LOBBY_toRebuy_SQL(nUserID, nValue, nRebuyAddOnceUsed: Integer;
      SQLAdapter: TSQLAdapter): Integer;
    procedure SetAddOnIsAllowed(const Value: Boolean);
  public
    //-------------------------------------------------------
    // Actions and owner context
    //-------------------------------------------------------
    property Actions: TXMLRespActions read FActions;
    property Owner: TtsTournamentList read FOwner;
    //
    //-------------------------------------------------------
    // Tournament context; EXTERNAL (sets on add in list)
    //-------------------------------------------------------
    property TournamentID: Integer read FTournamentID write SetTournamentID;
    property ActionDispatcherID: Integer read FActionDispatcherID write SetActionDispatcherID;
    //
	  property Name: string read FName write SetName;
    property MaxRegisteredLimit: Integer read FMaxRegisteredLimit write SetMaxRegisteredLimit;
	  property GameEngineID: Integer read FGameEngineID write SetGameEngineID;
    //
    //-------------------------------------------------------
    // Base tournament event properties
    //-------------------------------------------------------
	  property RegistrationStartTime: TDateTime read FRegistrationStartTime write SetRegistrationStartTime;
	  property TournamentFinishTime: TDateTime read FTournamentFinishTime write SetTournamentFinishTime;
	  property TournamentStartTime: TDateTime read FTournamentStartTime write SetTournamentStartTime;
    property TournamentCategory: Integer read FTournamentCategory write SetTournamentCategory;
    property TournamentStartEvent: Integer read FTournamentStartEvent write SetTournamentStartEvent;
	  property TournamentInterval: Integer read FTournamentInterval write SetTournamentInterval;
    // Level, Break, Durations event properties (in min)
	  property SittingDuration: Integer read FSittingDuration write SetSittingDuration;
	  property LevelInterval: Integer read FLevelInterval write SetLevelInterval;
	  property BreakInterval: Integer read FBreakInterval write SetBreakInterval;
	  property BreakDuration: Integer read FBreakDuration write SetBreakDuration;
	  property TimeOutForKickOff: Integer read FTimeOutForKickOff write SetTimeOutForKickOff;
    //DEFAULT (0)
	  property NextBreakTime: TDateTime read FNextBreakTime write SetNextBreakTime;
    //DEFAULT (0)
	  property NextLevelTime: TDateTime read FNextLevelTime write SetNextLevelTime;
    //DEFAULT (const AUTOSAVEINTERVAL min after now)
	  property NextAutosaveTime: TDateTime read FNextAutosaveTime write SetNextAutosaveTime;
    property StartPauseByAdmin: TDateTime read FStartPauseByAdmin write SetStartPauseByAdmin;
    property StartKickOffNotTakedSit: TDateTime read FStartKickOffNotTakedSit write SetStartKickOffNotTakedSit;

    //-------------------------------------------------------
    // Base tournament propeties
    //-------------------------------------------------------
    //DEFAULT (1) reserved
	  property StatusID: Integer read FStatusID write SetStatusID;

    //DEFAULT (1)
    // tstAnnouncing ($1), tstRegistration ($2),
    // tstSitting    ($3), tstRunning      ($4),
    // tstBreak      ($5), tstCompleted    ($6),
    // tstResuming   ($7)
	  property TournamentStatusID: Integer read FTournamentStatusID write SetTournamentStatusID;

    //DEFAULT (1)
	  property TournamentLevel: Integer read FTournamentLevel write SetTournamentLevel;
    // Regular (1), Sattelite (2)
	  property TournamentTypeID: Integer read FTournamentTypeID write SetTournamentTypeID;
	  property CurrencyTypeID: Integer read FCurrencyTypeID write SetCurrencyTypeID;
	  property CurrencySign: string read FCurrencySign write SetCurrencySign;
	  property CurrencyName: string read FCurrencyName write SetCurrencyName;
	  property BuyIn: Currency read FBuyIn write SetBuyIn;
	  property Fee: Currency read FFee write SetFee;
    property RebuyIsAllowed: Boolean read FRebuyIsAllowed write SetRebuyIsAllowed;
    property RebuyWasAllowedOnCreate: Boolean read FRebuyWasAllowedOnCreate write FRebuyWasAllowedOnCreate;
    property AddOnIsAllowed: Boolean read FAddOnIsAllowed write SetAddOnIsAllowed;
    property AddOnWasAllowedOnCreate: Boolean read FAddOnWasAllowedOnCreate write FAddOnWasAllowedOnCreate;
    property MaximumRebuyCount: Integer read FMaximumRebuyCount write SetMaximumRebuyCount;
    property PauseCount: Integer read FPauseCount write FPauseCount;
	  property Chips: Currency read FChips write SetChips;
	  property NumberOfPlayersForFinish: Integer read GetNumberOfPlayersForFinish;
	  property PlayerPerTable: Integer read FPlayerPerTable write SetPlayerPerTable;
    //DEFAULT (0)
	  property HandForHandPlayers: Integer read FHandForHandPlayers write SetHandForHandPlayers;

    //-------------------------------------------------------
    // properties for satelite only
    //-------------------------------------------------------
	  property MasterTournamentID: Integer read FMasterTournamentID write SetMasterTournamentID;
	  property MasterBuyIn: Currency read FMasterBuyIn write SetMasterBuyIn;
	  property MasterFee: Currency read FMasterFee write SetMasterFee;

    //-------------------------------------------------------
    // properties for restricted only
    //-------------------------------------------------------
	  property Password: string read FPassword write SetPassword;

    //-------------------------------------------------------
    // properties from GE
    //-------------------------------------------------------
    //DEFAULT (1)
	  property GameTypeName: string read FGameTypeName write SetGameTypeName;
	  property StakeName: string read FStakeName write SetStakeName;
	  property StakeType: Integer read FStakeType write SetStakeType;
	  property InitialStake: Currency read FInitialStake write SetInitialStake;

    //-------------------------------------------------------
    // List structure components
    //-------------------------------------------------------
    property Prizes: TpoTournPrizeRulesList read FPrizes write SetPrizes;
    property Bettings: TpoTournBettingList read FBettings write SetBettings;
    property Players: TpoTournUserList read FPlayers write SetPlayers;
    property Processes: TpoTournProcessList read FProcesses write SetProcesses;

    // Read only property about State tournament
    property IsSitAndGO: Boolean read GetIsSitAndGO;
    property IsAnnouncing: Boolean read GetIsAnnouncing;
    property IsRegistration: Boolean read GetIsRegistration;
    property IsSitting: Boolean read GetIsSitting;
    property IsRunning: Boolean read GetIsRunning;
    property IsBreak: Boolean read GetIsBreak;
    property IsCompleted: Boolean read GetIsCompleted;
    property IsStopped: Boolean read GetIsStopped;
    property IsResuming: Boolean read GetIsResuming;
    property IsNoEntrants: Boolean read GetIsNoEntrants;
    property IsPauseByAdmin: Boolean read GetIsPauseByAdmin;
    property IsStartKickingOff: Boolean read GetIsStartKickingOff;
    property PrevTournamentStatusID: Integer read FPrevTournamentStatusID;
    property NameOfState: string read GetNameOfState;
    //
	  property Entrants: Integer read GetEntrants;
	  property ActivePlayers: Integer read GetActivePlayers;
	  property TotalPrize: Currency read GetTotalPrize;
	  property TotalFee: Currency read GetTotalFee;
    property ActiveProcesses: Integer read GetActiveProcesses;
    //
    property OptimalTables: Integer read GetOptimalTables;
    property OptimalMinPlayersPerTable: Integer read GetOptimalMinPlayersPerTable;
    property OptimalMaxPlayersPerTable: Integer read GetOptimalMaxPlayersPerTable;
    //
    property IsHandForHand: Boolean read GetIsHandForHand;
    property Stake: Currency read GetStake;
    property Ante: Currency read GetAnte;
    property NextBreakEndTime: TDateTime read GetNextBreakEndTime;

    //-------------------------------------------------------
    // Stats properties (read only)
    //-------------------------------------------------------
	  property LargestStack: Currency read GetLargestStack;
	  property AverageStack: Currency read GetAverageStack;
	  property SmallestStack: Currency read GetSmallestStack;

    // constructor & destructor
    constructor Create(nTournamentID: Integer; aOwner: TtsTournamentList);
    destructor Destroy; override;

  public
    function CheckOnTimeEvent(aActions: TXMLRespActions): Integer;
    function EndOfHandAction(InpAction: TXMLAction;
      aResponce: TXMLRespActions; SQLAdapter: TSQLAdapter): Integer;
    // Functionalities with DB
    function StoreToDB(SQLAdapter: TSQLAdapter): Integer;
    function LoadFromDB(SQLAdapter: TSQLAdapter): Integer;
    // Internal functionalities
    function SetContextByObject(FromObj: TtsTournament): Integer;
    function StopTournament(SQLAdapter: TSQLAdapter; aResponce: TXMLRespActions; sMsg: string = ''): Integer;
    procedure FinishTournament(sExceptUserIDs: string; aResponce: TXMLRespActions;
      SQLAdapter: TSQLAdapter);
    // functions for LOBBY
    function LOBBY_toGetInfo: string;
    function LOBBY_toGetLevelsInfo: string;
    function LOBBY_toGetPlayers: string;
    function LOBBY_toGetProcesses: string;
    function LOBBY_toGetProcessPlayers(nProcID: Integer): string;
    function LOBBY_toGetTournamentInfo: string;
    function LOBBY_toGetTournaments(nTournamentKind: Integer = 0): string;
    function LOBBY_toRegister(nUserID, nFromTournamentID: Integer; sPassword: string;
      SQLAdapter: TSQLAdapter; var nErrCode: Integer): string;
    function LOBBY_toUnRegister(nUserID: Integer; SQLAdapter: TSQLAdapter): string;
    function LOBBY_toAutoRebuy(nUserID, nValue: Integer;
      SQLAdapter: TSQLAdapter; var errCode: Integer): string;
    function LOBBY_toRebuy(nUserID, nValue: Integer;
      SQLAdapter: TSQLAdapter; var errCode: Integer): string;
    function LOBBY_toTournamentEvent(sAction, sMsg: string;
      nProcessID, nOldProcessID, nOldTournamentID: Integer; sProcessName: string): string;
    // functions for Admin
    function KickOffUser(aInpAction: TXMLAction): Integer;
    function PauseByAdmin(aInpAction: TXMLAction; aRespActions: TXMLRespActions; aSql: TSQLAdapter): Integer;
    function EndPauseByAdmin(aInpAction: TXMLAction; aRespActions: TXMLRespActions; aSql: TSQLAdapter): Integer;
    function PauseByAdminOnDestroy(aSql: TSQLAdapter): Integer;
    function EndPauseByAdminOnCreate(aSql: TSQLAdapter): Integer;
    //
    procedure Execute;
  end;

// *************************************
// Tournament with Thread Executor context
// *************************************
  TtsTournamentList = class(TObjectList)
  private
    { no properties private block }
    function AddProperty(TargetNode : IXMlNode; NodeName : string;
      NodeType : integer; NodeValue : variant; IsTournament: Integer) : IXMLNode;
    function AddXMLItem(sXml: string; Node: IXMLNode): Integer;
    function GetCurrencies(var Data : string): Integer;
    function GetDefaultProperties(sGuid: string): Integer;
    //
    function GetNameOfValue(NodeProp: IXMLNode): string;
    function RegistrationTournament(FSQL: TSQLAdapter;
      ActionDispatcherID, MastID, GameEngineID, TournamentTypeID,
      GameTypeID, CurrencyTypeID, MaxRegistered, CategoryTypeID: Integer;
      TournamentName, GameEngineXML: string; TournamentStartTime: TDateTime;
      BuyIn, Fee: Currency;
      var TournamentID: Integer; var MastBuyIn, MastFee: Currency;
      var CurrencySign, CurrencyName: string
    ): Integer;
    function StoreSettingsXML(FSQL: TSQLAdapter;
      TournamentID: Integer; SettingsXML: string): Integer;
    function StoreCurrentValuesXML(FSQL: TSQLAdapter;
      TournamentID: Integer; CurrentValuesXML: string): Integer;
    function InitTournament(aInpAction: TXMLAction): Integer;
  private
    function GetItems(Index: Integer): TtsTournament;
    function GetTournamentsXML(nTournamentKind: Integer = 0): string;
    function SortByStartTime(Ascending: Boolean): Integer;
    procedure AdminCommandPause(aInpAction: TXMLAction; FSQL: TSQLAdapter);
    procedure AdminCommandPauseAll(aInpAction: TXMLAction; FSQL: TSQLAdapter);
    procedure AdminStopTournament(aInpAction: TXMLAction; FSQL: TSQLAdapter);
    procedure DropTournament(aTournament: TtsTournament; FSQL: TSQLAdapter);
    procedure AdminKickOffUser(aInpAction: TXMLAction);
    procedure CommandInitPrizePool(aInpAction: TXMLAction; FSQL: TSQLAdapter);
    procedure CommandInitBettings(aInpAction: TXMLAction; FSQL: TSQLAdapter);
    procedure CommandRegisterParticipant(aInpAction: TXMLAction;
      FSQL: TSQLAdapter; aTournament: TtsTournament);
    procedure CommandUnRegisterParticipant(aInpAction: TXMLAction;
      FSQL: TSQLAdapter; aTournament: TtsTournament);
    procedure CommandRebuy(aInpAction: TXMLAction; FSQL: TSQLAdapter; aTournament: TtsTournament);
    procedure CommandAutoRebuy(aInpAction: TXMLAction; FSQL: TSQLAdapter; aTournament: TtsTournament);
    //
    function LOBBY_toGetTournamentInfo(aTournament: TtsTournament): string;
    // Bots command
    procedure CommandBotGetTournamentInfo(aInpAction: TXMLAction; aTournament: TtsTournament);
    procedure CommandBotRegister(aInpAction: TXMLAction;
      aTournament: TtsTournament; FSQL: TSQLAdapter);
    procedure CommandBotStandUp(aInpAction: TXMLAction;
      aTournament: TtsTournament; FSQL: TSQLAdapter);
    procedure CommandBotStandUpAll(aInpAction: TXMLAction;
      aTournament: TtsTournament; FSQL: TSQLAdapter);
    procedure CommandBotPolicy(aInpAction: TXMLAction;
      aTournament: TtsTournament; FSQL: TSQLAdapter);

    procedure StoreLobbyInfo_SQL(nTournamentID, nTournamentCategoryID, nInfoID: Integer;
      sData: String; FSql: TSQLAdapter);

  public
    property Items[Index: Integer]: TtsTournament read GetItems;
    // methods
    procedure Del(Item: TtsTournament);
    // Add Item to the list
    function Add(nTID: Integer): TtsTournament;
    function Ins(Index: Integer; nTID: Integer): TtsTournament;
    function GetItemByTournamentID(nTID: Integer): TtsTournament;
    //
    function ProcessAction(aInpAction: TXMLAction): Boolean;
    procedure Execute;
    procedure UpdateLobbyInfo;
    // Functionalities with DB
    function StoreToDB(SQLAdapter: TSQLAdapter): Integer;
    function LoadFromDB(SQLAdapter: TSQLAdapter): Integer;
    // constructor & destructor
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  ComObj, DateUtils, StrUtils, DB, Math, Variants
//
{$IFDEF __TEST__}
  , uTournamentTest
{$ENDIF}
  , uGameConnector
  , uCommonFunctions
  , uTouConstants
  , uErrorConstants
  , uCommonDataModule
  , uLogger
  , uXMLConstants
  , uInfoCash
  , uEMail, uAPI;

{ tools }

function CompareBettingsByLevel(Item1, Item2: Pointer): Integer;
var
  nLevel1, nLevel2: Integer;
begin
  Result := 0;
  if (TObject(Item1) is TpoTournBetting) and (TObject(Item2) is TpoTournBetting) then begin
    nLevel1 := TpoTournBetting( Item1 ).FLevel;
    nLevel2 := TpoTournBetting( Item2 ).FLevel;
    Result := nLevel1 - nLevel2;
  end;
end;

{ TpoTournUser }

procedure TpoTournUser.SetAvatarID(const Value: Integer);
begin
  FAvatarID := Value;
end;

procedure TpoTournUser.SetChips(const Value: Currency);
begin
  FChips := Value;
end;

procedure TpoTournUser.SetChipsBeforeLost(const Value: Currency);
begin
  FChipsBeforeLost := Value;
end;

procedure TpoTournUser.SetProcessIDOnLost(const Value: Integer);
begin
  FProcessIDOnLost := Value;
end;

procedure TpoTournUser.SetLocation(const Value: string);
begin
  FLocation := Value;
end;

procedure TpoTournUser.SetLoginName(const Value: string);
begin
  FLoginName := Value;
end;

procedure TpoTournUser.SetPlace(const Value: Integer);
begin
  FPlace := Value;
end;

procedure TpoTournUser.SetProcessID(const Value: Integer);
begin
  FProcessID := Value;
end;

procedure TpoTournUser.SetSessionId(const Value: Integer);
begin
  FSessionId := Value;
end;

procedure TpoTournUser.SetSexID(const Value: Integer);
begin
  FSexID := Value;
end;

procedure TpoTournUser.SetUserID(const Value: Integer);
begin
  FUserID := Value;
end;

function TpoTournUser.StoreToDB(const TournamentID: Integer;
  SQLAdapter: TSQLAdapter): Integer;
begin
{$IFDEF __TEST__}
  Result := 0;
  Exit;
{$ENDIF}

  try

    SQLAdapter.SetProcName('srvtouSetUserContext');
    SQLAdapter.AddParInt('RETURN_VALUE',0,ptResult);
    SQLAdapter.AddParInt('TournamentID', TournamentID, ptInput);
    SQLAdapter.AddParInt('GameProcessID', FProcessID, ptInput);
    SQLAdapter.AddParInt('UserID', FUserID, ptInput);
    SQLAdapter.AddParam('AmountOfChips', FChips, ptInput, ftCurrency);
    SQLAdapter.AddParam('RebuyAuto', Integer(FRebuyAuto), ptInput, ftInteger);
    SQLAdapter.AddParam('RebuyCount', FRebuyCount, ptInput, ftInteger);
    SQLAdapter.AddParam('RebuyAddOnceUsed', Integer(FRebuyAddOnceUsed), ptInput, ftInteger);
    SQLAdapter.AddParString('LostTimeStr', DateTimeToODBCStr(FLostTime), ptInput);
    SQLAdapter.AddParInt('PlaceAtTable', FPlace, ptInput);
    SQLAdapter.AddParam('ChipsBeforeLost', FChipsBeforeLost, ptInput, ftCurrency);
    SQLAdapter.AddParInt('GameProcessIDOnLost', FProcessIDOnLost, ptInput);
    SQLAdapter.AddParInt('IsKickOffByAdm', Integer(FIsKickOffByAdministrator), ptInput);
    SQLAdapter.AddParInt('IsTakedSit', Integer(FIsTakedSit), ptInput);
    SQLAdapter.AddParInt('BotID', FBotID, ptInput);
    SQLAdapter.AddParInt('BotCharacter', FBotCharacter, ptInput);
    SQLAdapter.AddParInt('BotBlaffersEvent', FBotBlaffersEvent, ptInput);

    SQLAdapter.ExecuteCommand;

    Result := SQLAdapter.GetParam('RETURN_VALUE');

    if (Result <> 0) then begin
      LogException( '{924E36E0-8063-4E17-A616-53F727521452}',
        ClassName, 'StoreToDB', 'SQL result = ' + IntToStr(Result)
      );
    end;

  except on E: Exception do
    begin
      Result := TS_ERR_SQLERROR;
      LogException( '{4A07CA50-06DD-4F95-8AEE-FDEF05B18964}',
        ClassName, 'StoreToDB', E.Message
      );
    end;
  end;

end;

procedure TpoTournUser.SetLostTime(const Value: TDateTime);
begin
  FLostTime := Value;

// on set lost time
  if (FProcessIDOnLost <= 0) then FProcessIDOnLost := ProcessID;
  ProcessID := -1;
  if (FChipsBeforeLost <= 0) then FChipsBeforeLost := Chips;
  Chips := 0;
  Place := -1;
end;

function TpoTournUser.toGetPlayers_LOBBY_XML: string;
var
  AmountStr: string;
begin

  if IsFinished = 1 then
    AmountStr := ''
//    AmountStr := 'out'
  else
    AmountStr := CurrToStrF(FChips, ffFixed, 2);

  Result :=
    '<player' +
      ' userid="' + IntToStr(FUserID) + '"' +
      ' name="' + XMLSafeEncode(FLoginName) + '"' +
      ' city="' + XMLSafeEncode(FLocation) + '"' +
      ' amount="' + AmountStr + '"' +
      ' finished="' + IntToStr(IsFinished) + '"' +
      ' place="' + IntToStr(FPlace) + '"' +
      ' processid="' + IntToStr(FProcessID) + '"' +
      ' autorebuy="' + IntToStr(Integer(FRebuyAuto)) + '"' +
      ' value="' + AmountStr + '"' +
    '/>';

end;

function TpoTournUser.toGetProcessPlayers_LOBBY_XML(const ProcessID: Integer): string;
begin

  Result := '';
  if ProcessID <> FProcessID then exit;

  Result :=
    '<player' +
      ' userid="' + IntToStr(FUserID) + '"' +
      ' place="' + IntToStr(FPlace) + '"' +
      ' value="' + CurrToStrF(FChips, ffFixed, 2) + '"' +
      ' name="' + XMLSafeEncode(FLoginName) + '"' +
      ' city="' + XMLSafeEncode(FLocation) + '"' +
    '/>'

end;

function TpoTournUser.GetIsFinished: Integer;
begin
  if FLostTime > 0 then Result := 1 else Result := 0;
end;

function TpoTournUser.LoadFromDB(const TournamentID: Integer;
  SQLAdapter: TSQLAdapter): Integer;
var
  Node: IXMLNode;
  sSQL, StrData: string;
  XML: IXMLDocument;
begin
{$IFDEF __TEST__}
	Result := 0;
  Exit;
{$ENDIF}

	Result := 0;

  // try to execute store procedure
  sSQL := 'exec srvtouGetUserContextXML ' + IntToStr(TournamentID) + ', ' + IntToStr(UserID);
  try
    StrData := SQLAdapter.ExecuteForXML(sSql);
  except on E: Exception do
    begin
      Result := TS_ERR_SQLERROR;
      LogException( '{EDCF5472-F9BC-4C9D-A54E-D48CDA4713B2}',
        ClassName, 'LoadFromDB',
        E.Message + ': On Execute ' + sSQL
      );
    end;
  end;

  if StrData = '' then
  begin
    LogException( '{9D56C7DA-825F-4FBF-A2B4-51E14B9AC225}',
      ClassName, 'LoadFromDB', 'SQL procedure: [' + sSQL + '] return empty result.'
    );

    Result := TS_ERR_SQLERROR;
    Exit;
  end;

  // XML Parcer
  try

    XML := TXMLDocument.Create(nil);
	  XML.XML.Text := StrData;
    XML.Active   := true;

   	Node := XML.DocumentElement;

    // user context from xml to data
    GetDataFromNode(Node);

    XML.Active := False;
    XML        := nil;

  except on E: Exception do
    begin
      Result := TS_ERR_XMLPARCEERROR;
      LogException( '{F780F53D-4993-43A2-BDCA-155B26F1F587}',
        ClassName, 'LoadFromDB',
        'XML Parser error: ' + E.Message + ': XML=' + StrData
      );

      XML.Active := False;
      XML        := nil;
    end;
  end;
end;

procedure TpoTournUser.GetDataFromNode(Node: IXMLNode);
var
  nBotChr: Integer;
begin
  try
    FProcessID     	:= Node.Attributes['processid'];
    FProcessIDOnLost	:= Node.Attributes['processidonlost'];
    FUserID          := Node.Attributes['userid'];
 	  FPlace 	        := Node.Attributes['place'];
    FChips 	        := Node.Attributes['chips'];
    FRebuyAuto      := Boolean(StrToIntDef(Node.Attributes['rebuyauto'], 0));
    FRebuyCount     := Node.Attributes['rebuycount'];
    FRebuyAddOnceUsed := Boolean(StrToIntDef(Node.Attributes['addonceused'], 0));
    FLostTime        := ODBCStrToDateTimeDef(Node.Attributes['losttime'], 0);
    FChipsBeforeLost := Node.Attributes['chipsbeforelost'];
    FIsKickOffByAdministrator := False;
    if Node.HasAttribute('kickoffbyadm') then
      FIsKickOffByAdministrator := Boolean(StrToIntDef(Node.Attributes['kickoffbyadm'], 0));
    FIsTakedSit := False;
    if Node.HasAttribute('istakedsit') then
      FIsTakedSit := Boolean(StrToIntDef(Node.Attributes['istakedsit'], 0));
    FSexID 	         := Node.Attributes['sexid'];
   	FAvatarID        := Node.Attributes['avatarid'];
    FLevelID         := Node.Attributes['levelid'];

    FIcons.Clear;
    if Node.HasAttribute('icon1') then
      FIcons.Add(Node.Attributes['icon1']);
    if Node.HasAttribute('icon2') then
      FIcons.Add(Node.Attributes['icon2']);
    if Node.HasAttribute('icon3') then
      FIcons.Add(Node.Attributes['icon3']);
    if Node.HasAttribute('icon4') then
      FIcons.Add(Node.Attributes['icon4']);

	  FSessionID       := Node.Attributes['sessionid'];
    FLocation        := Node.Attributes['city'];
    FLoginName       := Node.Attributes['name'];
    // bots
    if Node.HasAttribute('botid') then
      FBotID := Node.Attributes['botid']
    else
      FBotID := 0;
    FIsBot := (FBotID > 0);
    nBotChr := 1;
    if Node.HasAttribute('botcharacter') then
      nBotChr := StrToIntDef(Node.Attributes['botcharacter'], 1);
    if not (nBotChr in [Integer(Low(TFixUserCharacter))..Integer(High(TFixUserCharacter))]) then
      nBotChr := 1;
    FBotCharacter := TFixUserCharacter(nBotChr);
    if Node.HasAttribute('botblaffers') then
      FBotBlaffersEvent := Node.Attributes['botblaffers'];
      
  except
    on E: Exception do begin
      CommonDataModule.Log(ClassName, 'GetDataFromNode',
        '[EXCEPTION] : ' + E.Message + '; Params: Node=' + Node.XML,
        ltException
      );
    end;
  end;
end;

function TpoTournUser.SetContextByObject(FromUser: TpoTournUser): Integer;
begin
  if FromUser = nil then
  begin
    LogException( '{AFA2F8D1-5005-4636-9239-936FAA5BD2F1}',
      ClassName, 'SetContextByObject', 'Try to take context from nil object'
    );

    Result := 1;
    Exit;
  end;

  // process context
  FProcessID := FromUser.FProcessID;
  FProcessIDOnLost := FromUser.FProcessIDOnLost;
  // user context data
  FUserID := FromUser.FUserID;
  FPlace := FromUser.FPlace;
  FChips := FromUser.FChips;
  FRebuyAuto := FromUser.FRebuyAuto;
  FRebuyCount := FromUser.FRebuyCount;
  FRebuyAddOnceUsed := FromUser.FRebuyAddOnceUsed;
  FLostTime := FromUser.FLostTime;
  FSexID := FromUser.FSexID;
  FAvatarID := FromUser.FAvatarID;
  FLevelID := FromUser.FLevelID;
  FIcons.Text := FromUser.FIcons.Text;
  FLocation := FromUser.FLocation;
  FLoginName := FromUser.FLoginName;
  FSessionId := FromUser.FSessionId;
  FChipsBeforeLost := FromUser.FChipsBeforeLost;
  FIsKickOffByAdministrator := FromUser.FIsKickOffByAdministrator;
  FIsTakedSit := FromUser.FIsTakedSit;
  // bots
  FIsBot := FromUser.FIsBot;
  FBotID := FromUser.FBotID;
  FBotCharacter := FromUser.FBotCharacter;
  FBotBlaffersEvent := FromUser.FBotBlaffersEvent;

  Result := 0;

end;

function TpoTournUser.ProcCloseNotify(ByProcessID: Boolean; Msg: string; aResponce: TXMLRespActions): Integer;
var
  ProcCloseXML: string;
  nPrcID: Integer;
begin
  Log(ClassName, 'ProcCloseNotify', 'Entry: msg=' + Msg);

  Result := 0;
  nPrcID := FProcessID;
  if not ByProcessID then nPrcID := FProcessIDOnLost;
  if nPrcID <= 0 then Exit;

  ProcCloseXML :=
      '<object name="' + APP_PROCESS + '" id="' + IntToStr(FProcessID) + '">' +
          '<gaaction processid="' + IntToStr(nPrcID) + '">' +
            '<procclose reason="' + XMLSafeEncode(Msg) + '"/>' +
          '</gaaction>' +
      '</object>';

  aResponce.Add(ProcCloseXML, -1, FUserID);
//  CommonDataModule.NotifyUserByID(FUserID, ProcCloseXML);

  Log(ClassName, 'ProcCloseNotify',
    'Exit: ProcClose action was sended to process=' + IntToStr(ProcessID) + ': Msg=[' + Msg + ']'
  );
end;

function TpoTournUser.GetNodeOnCommand_GE_XML(const ProcessID: Integer;
  sNodeName: string; RebuyChips: Currency): string;
var
  nMoney: Currency;
  I: Integer;
begin

  Result := '';
  if ProcessID <> FProcessID then Exit;

  if (sNodeName = 'rebuy') then
    nMoney := RebuyChips
  else
    nMoney := FChips;

  Result :=
    '<' + sNodeName +
      ' userid="' + IntToStr(FUserID) + '"' +
      ' money="' + CurrToStrF(nMoney, ffFixed, 2) + '"' +
      ' sexid="' + IntToStr(FSexID) + '"' +
      ' avatarid="' + IntToStr(FAvatarID) + '"' +
      ' city="' + XMLSafeEncode(FLocation) + '"' +
      ' name="' + XMLSafeEncode(FLoginName) + '"' +
      ' sessionid="0"' +
      ' place="' + IntToStr(FPlace) + '"' +
      ' isbot="' + IntToStr(Integer(FIsBot)) + '"' +
      ' botid="' + IntToStr(FBotID) + '"' +
      ' botblaffers="' + IntToStr(FBotBlaffersEvent) + '"' +
      ' botcharacter="' + IntToStr(Integer(FBotCharacter)) + '"' +
      ' levelid="' + IntToStr(FLevelID) + '"' +
    '>';

  for I:=0 to FIcons.Count - 1 do
    Result := Result + '<icon icon="' + FIcons[I] + '"/>';

  Result := Result + '</' + sNodeName + '>';
end;

procedure TpoTournUser.SetAsLost(LostTM: TDateTime; nOrder: Integer);
begin
  FPlace := -1;
  if (FProcessIDOnLost <= 0) then FProcessIDOnLost := FProcessID;
  FProcessID := -1;
  if (FChipsBeforeLost <= 0) then FChipsBeforeLost := FChips;
  FChips := 0;
  FRebuyAuto := False;
  FRebuyAddOnceUsed := True;
  if (FLostTime <= 0) then FLostTime := LostTM;
  FMemPlace := nOrder;
end;

constructor TpoTournUser.Create;
begin
  inherited Create;

  FPlace := -1;
  FProcessIDOnLost := -1;
  FProcessID := -1;
  FChipsBeforeLost := 0;
  FIsKickOffByAdministrator := False;
  FIsTakedSit := False;
  FChips := 0;
  FRebuyAuto := False;
  FRebuyCount := 0;
  FRebuyAddOnceUsed := False;
  FLostTime := 0;
  FMemPlace := -1;
  FLevelID := 0;
  FIcons := TStringList.Create;
  // Bots
  FIsBot := False;
  FBotBlaffersEvent := MIN_COUNT_ONBLAFFERS + Random(MAX_COUNT_ONBLAFFERS - MIN_COUNT_ONBLAFFERS);
  FBotID := 0;
  FBotCharacter := UCH_NORMAL;
end;

destructor TpoTournUser.Destroy;
begin
  FIcons.Clear;
  FIcons.Free;
  inherited;
end;

(* Can be used in future
function TpoTournUser.MessageBoxNotify(Msg: string; aResponce: TXMLRespActions): Integer;
var
  MessageXML: string;
begin
  Log(ClassName, 'MessageBoxNotify', 'Entry: msg=' + Msg);

  Result := 0;
  MessageXML :=
    '<object name="session">' +
      '<message msg="' + XMLSafeEncode(Msg) + '"/>' +
    '</object>';

  aResponce.Add(MessageXML, -1, FUserID);

  Log(ClassName, 'MessageBoxNotify',
    'Exit: MessageBoxNotify action was sended to user=' + IntToStr(UserID) + ': Msg=[' + Msg + ']'
  );
end;
*)

procedure TpoTournUser.SetIsKickOffByAdministrator(const Value: Boolean);
begin
  FIsKickOffByAdministrator := Value;
end;

procedure TpoTournUser.SetBotBlaffersEvent(const Value: Integer);
begin
  FBotBlaffersEvent := Value;
end;

procedure TpoTournUser.SetBotCharacter(const Value: TFixUserCharacter);
begin
  FBotCharacter := Value;
end;

procedure TpoTournUser.SetBotID(const Value: Integer);
begin
  FBotID := Value;
end;

procedure TpoTournUser.SetIsBot(const Value: Boolean);
begin
  FIsBot := Value;
end;

procedure TpoTournUser.SetIsTakedSit(const Value: Boolean);
begin
  FIsTakedSit := Value;
end;

procedure TpoTournUser.SetRebuyAuto(const Value: Boolean);
begin
  FRebuyAuto := Value;
end;

procedure TpoTournUser.SetRebuyCount(const Value: Integer);
begin
  FRebuyCount := Value;
end;

function TpoTournUser.GetBuyInCount: Integer;
begin
  Result := 1 + FRebuyCount;
end;

procedure TpoTournUser.SetRebuyAddOnceUsed(const Value: Boolean);
begin
  FRebuyAddOnceUsed := Value;
end;

procedure TpoTournUser.SetLevelID(const Value: Integer);
begin
  FLevelID := Value;
end;

{ TpoTournUserList }

function TpoTournUserList.Add: TpoTournUser;
begin
  Result := TpoTournUser.Create;
  inherited Add(Result);
end;

procedure TpoTournUserList.Del(Item: TpoTournUser);
begin
  inherited Remove(Item);
end;

function TpoTournUserList.Ins(Index: Integer): TpoTournUser;
begin
  Result := TpoTournUser.Create;
  inherited Insert(Index, Result);
end;

function TpoTournUserList.GetItems(Index: Integer): TpoTournUser;
begin
  Result := (inherited Items[Index]) as TpoTournUser;
end;

constructor TpoTournUserList.Create;
begin
  inherited Create;
end;

function TpoTournUserList.LoadFromDB(TournamentID: Integer;
  SQLAdapter: TSQLAdapter): Integer;
var
  sSQL: string;
  StrData: string;
  XML  : IXMLDocument;
  Node : IXMLNode;
  i: Integer;
  aUser: TpoTournUser;
begin
	Result := 0;

{$IFDEF __TEST__}
  Exit;
{$ENDIF}

  // clear list before all
  Clear;

  // try to execute store procedure
  sSQL := 'exec srvtouGetTournamentUsersXML ' + IntToStr(TournamentID);
  try
    StrData := SQLAdapter.ExecuteForXML(sSql);
  except on E: Exception do
    begin
      Result := TS_ERR_SQLERROR;
      LogException( '{C746D617-9B72-4372-8072-C9F63B7B20AD}',
        ClassName, 'LoadFromDB', E.Message + ': On SQL=' + sSQL
      );
    end;
  end;

  if StrData = '' then Exit;

  // XML Parcer
  try
    XML := TXMLDocument.Create(nil);
	  XML.XML.Text := '<tournament>'+StrData+'</tournament>';
    XML.Active   := true;

  	for i := 0 to (XML.DocumentElement.ChildNodes.Count-1) do
    begin
    	Node := XML.DocumentElement.ChildNodes[i];

      // add new user into collectionlist
      aUser := Self.Add;

      // user context from node xml to data
      aUser.GetDataFromNode(Node);
    end;

    XML.Active := False;
    XML        := nil;

  except on E: Exception do
    begin
      Result := TS_ERR_XMLPARCEERROR;
      LogException( '{F780F53D-4993-43A2-BDCA-155B26F1F587}',
        ClassName, 'LoadFromDB',
        'XML Parser error: ' + E.Message + ': XML=' + XML.DocumentElement.XML
      );

      XML.Active := False;
      XML        := nil;
    end;
  end;

end;

function TpoTournUserList.StoreToDB(TournamentID: Integer;
  SQLAdapter: TSQLAdapter): Integer;
var
  I: Integer;
  aUser: TpoTournUser;
begin
  Result := 0;

{$IFDEF __TEST__}
  Exit;
{$ENDIF}

  try
    for I := 0 to Self.Count - 1 do
    begin
      aUser := Items[I];
      Result := Result + aUser.StoreToDB(TournamentID, SQLAdapter);
    end;
  except on E: Exception do
  end;

end;

function TpoTournUserList.RegisterParticipant(TournamentID, FromTournamentID, UserID: Integer;
  Chips, BuyIn, Fee: Currency; CurrencyTypeID, BotID, BotCharacter, BotBlaffers: Integer;
  SQLAdapter: TSQLAdapter): Integer;
var
  aUser: TpoTournUser;
begin
//*****************************************************************
// WARNING: Check on tournament status is not doing in this module
//*****************************************************************

  Log(ClassName, 'RegisterParticipant',
    ' Parameters: TournamentID=' + IntToStr(TournamentID) +
    ', UserID=' + IntToStr(UserID)
  );

  // add user into DB
  Result := RegisterParticipantIntoDB(TournamentID, FromTournamentID,
    UserID, Chips, BuyIn, Fee, CurrencyTypeID,
    BotID, BotCharacter, BotBlaffers,
    SQLAdapter
  );
  if Result <> 0 then Exit; // logerror already created

  // add user into buffer
  aUser := Add;
  // set minimal user context
  aUser.FUserID    := UserID;
  aUser.FIsBot := (BotID > 0);
  aUser.FIsTakedSit := (BotID > 0);
  // set all user context
  Result := aUser.LoadFromDB(TournamentID, SQLAdapter);

end;

function TpoTournUserList.RegisterParticipantIntoDB(TournamentID, FromTournamentID, UserID: Integer;
  Chips, BuyIn, Fee: Currency; CurrencyTypeID, BotID, BotCharacter, BotBlaffers: Integer;
  SQLAdapter: TSQLAdapter): Integer;
begin
// try to register participant in DataBase
{$IFDEF __TEST__}
  Result := 0;
  Exit;
{$ENDIF}
  try

    SQLAdapter.SetProcName('srvtouRegisterationParticipant');
    SQLAdapter.AddParInt('RETURN_VALUE',0, ptResult);
    SQLAdapter.AddParInt('TournamentID', TournamentID, ptInput);
    SQLAdapter.AddParInt('FromTournamentID', FromTournamentID, ptInput);
    SQLAdapter.AddParInt('UserID', UserID, ptInput);
    SQLAdapter.AddParam('Chips', Chips, ptInput, ftCurrency);
    SQLAdapter.AddParam('BuyIn', BuyIn, ptInput, ftCurrency);
    SQLAdapter.AddParam('Fee', Fee, ptInput, ftCurrency);
    SQLAdapter.AddParInt('CurrencyTypeID', CurrencyTypeID, ptInput);
    SQLAdapter.AddParInt('BotID', BotID, ptInput);
    SQLAdapter.AddParInt('BotCharacter', BotCharacter, ptInput);
    SQLAdapter.AddParInt('BotBlaffers', BotBlaffers, ptInput);

    SQLAdapter.ExecuteCommand;

    Result  := SQLAdapter.GetParam('RETURN_VALUE');

    if      Result = 1 then Result := TS_ERR_WROUNGTOURNAMENTID
    else if Result = 2 then Result := TS_ERR_USERALREADYREGISTERED
    else if Result = 3 then Result := TS_ERR_NOACCOUNT
    else if Result = 4 then Result := TS_ERR_NOTENOUGHMONEY;

  except on e : Exception do
    begin
      LogException( '{F7ABA074-1DB2-4E9B-8AA5-4739EC49BCD4}',
        ClassName,
        'RegisterParticipantInDB. Params: TournamentID=' + IntToStr(TournamentID) +
          ', UserID=' + IntToStr(UserID) + ';',
        E.Message
      );

      Result := TS_ERR_SQLERROR;
      Exit;
    end;
  end;

end;

function TpoTournUserList.GetNodeListOnCommand_GE_XML(const ProcessID: Integer; sNodeName: string; RebuyChips: Currency): string;
var
  I: Integer;
  aUser: TpoTournUser;
begin
  Result := '';
  // Filling XML
  for I := 0 to Self.Count - 1 do begin
    aUser := Items[I];
    if aUser.FProcessID = ProcessID then begin
      Result := Result + aUser.GetNodeOnCommand_GE_XML(ProcessID, sNodeName, RebuyChips);
    end;
  end;
end;

function TpoTournUserList.GetNodeListOnKickOffByAdministrator(const ProcessID: Integer; sNodeName: string): string;
var
  I: Integer;
  aUser: TpoTournUser;
begin
  Result := '';
  // Filling XML
  for I := 0 to Self.Count - 1 do begin
    aUser := Items[I];
    if (aUser.FProcessID = ProcessID) and
       aUser.FIsKickOffByAdministrator and
       (aUser.IsFinished <= 0)
    then begin
      Result := Result + aUser.GetNodeOnCommand_GE_XML(ProcessID, sNodeName);
    end;
  end;
end;

function TpoTournUserList.SortByChips(Ascending: Boolean): Integer;
var
  TopInd: Integer;
  I, J: Integer;
  aUser: TpoTournUser;
begin
  for I := 0 to Count - 1 do
  begin
    TopInd := I;

    // search next top index
    for J := I+1 to Count - 1 do
    begin
      aUser := Items[J];

      if Ascending then begin
        if Items[TopInd].FChips > aUser.FChips then TopInd := IndexOf(aUser);
      end else begin
        if Items[TopInd].FChips < aUser.FChips then TopInd := IndexOf(aUser);
      end;
    end;

    // swap
    if (TopInd <> I) then begin
      aUser := TpoTournUser.Create;
      aUser.SetContextByObject(Items[TopInd]);
      Items[TopInd].SetContextByObject(Items[I]);
      Items[I].SetContextByObject(aUser);
      aUser.Free;
    end;
  end;

  Result := 0;

end;

function TpoTournUserList.SortByChipsBeforeLost(Ascending: Boolean): Integer;
var
  TopInd: Integer;
  I, J: Integer;
  aUser: TpoTournUser;
begin
  for I := 0 to Count - 1 do
  begin
    TopInd := I;

    // search next top index
    for J := I+1 to Count - 1 do
    begin
      aUser := Items[J];

      if Ascending then begin
        if Items[TopInd].FChipsBeforeLost > aUser.FChipsBeforeLost then TopInd := IndexOf(aUser);
      end else begin
        if Items[TopInd].FChipsBeforeLost < aUser.FChipsBeforeLost then TopInd := IndexOf(aUser);
      end;
    end;

    // swap
    if (TopInd <> I) then begin
      aUser := TpoTournUser.Create;
      aUser.SetContextByObject(Items[TopInd]);
      Items[TopInd].SetContextByObject(Items[I]);
      Items[I].SetContextByObject(aUser);
      aUser.Free;
    end;
  end;

  Result := 0;

end;

function TpoTournUserList.SortByPlace(Ascending: Boolean): Integer;
var
  TopInd: Integer;
  I, J: Integer;
  aUser: TpoTournUser;
begin
  for I := 0 to Count - 1 do
  begin
    TopInd := I;

    // search next top index
    for J := I+1 to Count - 1 do
    begin
      aUser := Items[J];

      if Ascending then begin
        if Items[TopInd].FPlace > aUser.FPlace then TopInd := IndexOf(aUser);
      end else begin
        if Items[TopInd].FPlace < aUser.FPlace then TopInd := IndexOf(aUser);
      end;
    end;

    // swap indexes
    if (TopInd <> I) then begin
      aUser := TpoTournUser.Create;
      aUser.SetContextByObject(Items[TopInd]);
      Items[TopInd].SetContextByObject(Items[I]);
      Items[I].SetContextByObject(aUser);
      aUser.Free;
    end;
  end;

  Result := 0;

end;

function TpoTournUserList.SortByLostTime(Ascending: Boolean): Integer;
var
  TopInd: Integer;
  I, J: Integer;
  aUser: TpoTournUser;
begin
  for I := 0 to Count - 1 do
  begin
    TopInd := I;

    // search next top index
    for J := I+1 to Count - 1 do
    begin
      aUser := Items[J];

      if Ascending then begin
        if Items[TopInd].FLostTime > aUser.FLostTime then TopInd := IndexOf(aUser);
      end else begin
        if Items[TopInd].FLostTime < aUser.FLostTime then TopInd := IndexOf(aUser);
      end;
    end;

    // swap indexes
    if (TopInd <> I) then begin
      aUser := TpoTournUser.Create;
      aUser.SetContextByObject(Items[TopInd]);
      Items[TopInd].SetContextByObject(Items[I]);
      Items[I].SetContextByObject(aUser);
      aUser.Free;
    end;
  end;

  Result := 0;

end;

function TpoTournUserList.GetCountOnProcess(nProcessID: Integer): Integer;
var
  I: Integer;
  aUser: TpoTournUser;
begin
  Result := 0;
  for I := 0 to Count - 1 do begin
    aUser := Items[I];
    if nProcessID = aUser.FProcessID then Inc(Result);
  end;
end;

function TpoTournUserList.GetActiveCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I:=0 to Count - 1 do begin
    Result := Result + (1 - Items[I].IsFinished);
  end;
end;

function TpoTournUserList.SetContextByObject(
  FromObj: TpoTournUserList): Integer;
var
  I: Integer;
begin
  if FromObj = nil then
  begin
    LogException( '{D7249E9B-C96B-400C-9560-9E1039DB3BBA}',
      ClassName, 'SetContextByObject', 'Try to take context from nil object'
    );

    Result := 1;
    Exit;
  end;

  Clear;
  for I := 0 to FromObj.Count - 1 do begin
    Add.SetContextByObject(FromObj.Items[I]);
  end;

  Result := 0;

end;

function TpoTournUserList.ProcCloseNotify(ByProcessID: Boolean; Msg: string; aResponce: TXMLRespActions): Integer;
var
  I: Integer;
  aUser: TpoTournUser;
begin
  CommonDataModule.Log(ClassName, 'ProcCloseNotify',
    'Entry: Send msg=' + Msg + ' to all users', ltCall);

  Result := 0;
  for I:=0 to Count - 1 do begin
    aUser := Items[I];
    if aUser.IsBot then Continue;
    Result := aUser.ProcCloseNotify(ByProcessID, Msg, aResponce);
  end;

  CommonDataModule.Log(ClassName, 'ProcCloseNotify',
    'Exit: ProcClose action has been sending to all users: Msg=[' + Msg + ']',
    ltCall
  );
end;

function TpoTournUserList.GetUserByID(nID: Integer): TpoTournUser;
var
  I: Integer;
  aUsr: TpoTournUser;
begin
  Result := nil;
  for I:=0 to Count - 1 do begin
    aUsr := Items[I];
    if aUsr.UserID = nID then begin
      Result := aUsr;
      Exit;
    end;
  end;
end;

function TpoTournUserList.GetUserByName(sName: string): TpoTournUser;
var
  I: Integer;
  aUsr: TpoTournUser;
begin
  Result := nil;
  for I:=0 to Count - 1 do begin
    aUsr := Items[I];
    if aUsr.LoginName = sName then begin
      Result := aUsr;
      Exit;
    end;
  end;
end;

function TpoTournUserList.GetFirstUserByProcessID(
  nProcessID: Integer): TpoTournUser;
var
  I: Integer;
  aUsr: TpoTournUser;
begin
  Result := nil;
  for I:=0 to Count - 1 do begin
    aUsr := Items[I];
    if aUsr.FProcessID = nProcessID then begin
      Result := aUsr;
      Exit;
    end;
  end;
end;

function TpoTournUserList.GetUserByProcessIDAndPlace(nProcessID,
  nPlace: Integer): TpoTournUser;
var
  I: Integer;
  aUsr: TpoTournUser;
begin
  Result := nil;
  for I:=0 to Count - 1 do begin
    aUsr := Items[I];
    if (aUsr.FProcessID = nProcessID) and (aUsr.FPlace = nPlace) then begin
      Result := aUsr;
      Exit;
    end;
  end;
end;

destructor TpoTournUserList.Destroy;
begin
  Clear;
  inherited;
end;

function TpoTournUserList.UnRegisterParticipant(TournamentID, UserID: Integer;
  BuyIn, Fee: Currency; CurrencyTypeID: Integer;
  SQLAdapter: TSQLAdapter): Integer;
var
  aUser: TpoTournUser;
begin
//*****************************************************************
// WARNING: Check on tournament status is not doing in this module
//*****************************************************************

  Log(ClassName, 'UnRegisterParticipant',
    ' Parameters: TournamentID=' + IntToStr(TournamentID) +
    ', UserID=' + IntToStr(UserID)
  );

  // delete user from DB
  Result := UnRegisterParticipantFromDB(TournamentID, UserID, BuyIn, Fee, CurrencyTypeID, SQLAdapter);
  if Result <> 0 then begin
    Log(ClassName, 'UnRegisterParticipant', 'Exit. With result=' + IntToStr(Result));
    Exit;
  end;

  // add user into buffer
  aUser := GetUserByID(UserID);
  if (aUser <> nil) then Del(aUser);

  Log(ClassName, 'UnRegisterParticipant', 'Exit. All right; result=' + IntToStr(Result));
end;

function TpoTournUserList.UnRegisterParticipantFromDB(TournamentID, UserID: Integer;
  BuyIn, Fee: Currency; CurrencyTypeID: Integer;
  SQLAdapter: TSQLAdapter): Integer;
begin
// try to unregister participant in DataBase
{$IFDEF __TEST__}
  Result := 0;
  Exit;
{$ENDIF}

  CommonDataModule.Log(ClassName, 'UnRegisterParticipantFromDB', 'Entry.', ltCall);
  try

    SQLAdapter.SetProcName('srvtouUnRegistrationParticipant');
    SQLAdapter.AddParInt('RETURN_VALUE', 0, ptResult);
    SQLAdapter.AddParInt('TournamentID', TournamentID, ptInput);
    SQLAdapter.AddParInt('UserID', UserID, ptInput);
    SQLAdapter.AddParam('BuyIn', BuyIn, ptInput, ftCurrency);
    SQLAdapter.AddParam('Fee', Fee, ptInput, ftCurrency);
    SQLAdapter.AddParInt('CurrencyTypeID', CurrencyTypeID, ptInput);

    SQLAdapter.ExecuteCommand;

    Result  := SQLAdapter.GetParam('RETURN_VALUE');

    if      Result = 1 then Result := TS_ERR_WROUNGTOURNAMENTID
    else if Result = 2 then Result := TS_ERR_USERNOTFOUND
    else if Result = 3 then Result := TS_ERR_NOACCOUNT
    else if Result = 4 then Result := TS_ERR_SQLERROR;
  except on e : Exception do
    begin
      LogException( '{B4DB8D22-E705-46EB-9D7C-C7B637EB5BCD}',
        ClassName,
        'UnRegisterParticipantFromDB. Params: TournamentID=' + IntToStr(TournamentID) +
          ', UserID=' + IntToStr(UserID) + ';',
        E.Message
      );

      Result := TS_ERR_SQLERROR;
      Exit;
    end;
  end;

  CommonDataModule.Log(ClassName, 'UnRegisterParticipantFromDB', 'Exit. Result=' + IntToStr(Result), ltCall);
end;

function TpoTournUserList.GetMinChips(nProcessID: Integer): Currency;
var
  I: Integer;
  aUsr: TpoTournUser;
begin
  Result := 0;
  for I:=0 to Count - 1 do begin
    aUsr := Items[I];
    if (aUsr.FProcessID <> nProcessID) then Continue;

    if (Result = 0) then
      Result := aUsr.FChips
    else
      Result := Min(Result, aUsr.FChips);
  end;
end;

function TpoTournUserList.GetMaxChips(nProcessID: Integer): Currency;
var
  I: Integer;
  aUsr: TpoTournUser;
begin
  Result := 0;
  for I:=0 to Count - 1 do begin
    aUsr := Items[I];
    if (aUsr.FProcessID <> nProcessID) then Continue;

    Result := Max(Result, aUsr.FChips);
  end;
end;

function TpoTournUserList.GetAvgChips(nProcessID: Integer): Currency;
var
  I, nCnt: Integer;
  aUsr: TpoTournUser;
begin
  Result := 0;
  nCnt := 0;
  for I:=0 to Count - 1 do begin
    aUsr := Items[I];
    if (aUsr.FProcessID <> nProcessID) then Continue;

    Result := Result + aUsr.FChips;
    Inc(nCnt);
  end;

  if (nCnt > 0) then
    Result := Result / nCnt
  else
    Result := 0;
end;

function TpoTournUserList.GetLostCount: Integer;
begin
  Result := Count - ActiveCount;
end;

function TpoTournUserList.RegisterBots(nTournamentID, nBotCount: Integer;
  Chips, BuyIn, Fee: Currency; CurrencyTypeID, BotCharacter: Integer;
  SQLAdapter: TSQLAdapter): Integer;
var
  I, nCountForSitDown: Integer;
  sName: string;
  aTempUsers: TpoTournUserList;
  aUser: TpoTournUser;
begin
  { filling buffered memo }
  aTempUsers := TpoTournUserList.Create;
  Result := GetBotsData(aTempUsers);
  if (Result <> 0) then begin
    aTempUsers.Free;
    Exit;
  end;

  // delete exists bots by name
  for I:=0 to Count - 1 do begin
    sName := Items[I].FLoginName;
    aUser := aTempUsers.GetUserByName(sName);

    if (aUser <> nil) then aTempUsers.Del(aUser);
  end;

  if (aTempUsers.Count <= 0) then begin
    aTempUsers.Free;
    CommonDataModule.Log(ClassName, 'RegisterBots',
      '[ERROR]: Not enough bots for registration.',
      ltError
    );
    Result := TS_ERR_NOTENOGHBOTSFORREGISTRATION;
    Exit;
  end;

  nCountForSitDown := Min(nBotCount, aTempUsers.Count);
  while nCountForSitDown > 0 do begin
    I := Random(aTempUsers.Count - 1);
    aUser := aTempUsers.Items[I];

    { registration bot }
    RegisterParticipant(nTournamentID, 0, aUser.FUserID,
      Chips, BuyIn, Fee, CurrencyTypeID,
      aUser.FBotID, BotCharacter, aUser.FBotBlaffersEvent,
      SQLAdapter
    );

    aTempUsers.Remove(aUser);

    Dec(nCountForSitDown);
  end;

end;

function TpoTournUserList.GetBotsData(aTempUsers: TpoTournUserList): Integer;
var
  XMLDoc: IXMLDocument;
  aNode, aRoot: IXMLNode;
  sData: string;
  I, nUserID, nBotID, nSexID, nAvatarID, BotsCount: Integer;
  sBotName, sCity: string;
  aUser: TpoTournUser;
  FApi: TAPI;
begin
  Result := 0;

  FApi := CommonDataModule.ObjectPool.GetAPI;
  sData := FApi.GetBotsDataXMLString;
  CommonDataModule.ObjectPool.FreeAPI(FApi);

  aTempUsers.Clear;

  XMLDoc := TXMLDocument.Create(nil);
  try
    XMLDoc.XML.Text := sData;
    XMLDoc.Active := True;
    aRoot := XMLDoc.DocumentElement;
    BotsCount := aRoot.ChildNodes.Count;
    for I:=0 to BotsCount - 1 do begin
      aNode := aRoot.ChildNodes[I];

      if not aNode.HasAttribute('id') then Continue;
      nBotID := aNode.Attributes['id'];

      nUserID := MaxInt - nBotID - 10;
      sBotName := 'Bot ' + IntToStr(I);
      if aNode.HasAttribute('loginname') then
        sBotName := aNode.Attributes['loginname'];
      nSexID := 1;
      if aNode.HasAttribute('sexid') then
        nSexID := StrToIntDef(aNode.Attributes['sexid'], 1);
      sCity := 'BotLand';
      if aNode.HasAttribute('location') then
        sCity := aNode.Attributes['location'];
      nAvatarID := Random(100);
      if aNode.HasAttribute('avatarid') then
        nAvatarID := StrToIntDef(aNode.Attributes['avatarid'], 1);

      aUser := aTempUsers.Add;

      aUser.FUserID := nUserID;
      aUser.FAvatarID := nAvatarID;
      aUser.FLevelID := 0;
      aUser.FSexID := nSexID;
      aUser.FSessionId := nUserID;
      aUser.FLoginName := sBotName;
      aUser.FLocation := sCity;
      aUser.FIsBot := True;
      aUser.FBotID := nBotID;

    end;
  except
    on E: Exception do begin
      aTempUsers.Clear;
      XMLDoc := nil;
      Result := TS_ERR_XMLPARCEERROR;
      CommonDataModule.Log(ClassName, 'GetBotsData',
        '[EXCEPTION]: with message=' + E.Message,
        ltException
      );
      Exit;
    end;
  end;

  XMLDoc := nil;
end;

function TpoTournUserList.GetUserByBotID(nBotID: Integer): TpoTournUser;
var
  I: Integer;
  aUsr: TpoTournUser;
begin
  Result := nil;
  if (nBotID <= 0) then Exit;
  for I:=0 to Count - 1 do begin
    aUsr := Items[I];
    if aUsr.BotID = nBotID then begin
      Result := aUsr;
      Exit;
    end;
  end;
end;

function TpoTournUserList.GetBuyInCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I:=0 to Count - 1 do
    Result := Result + Items[I].BuyInCount;
end;

{ TpoTournProcess }

constructor TpoTournProcess.Create;
begin
  inherited;

  // set default values
  FStatusID := pstWaiting;
  FLevel    := 1;
  FMinStack := 0;
  FAvgStack := 0;
  FMaxStack := 0;
  FHandCount := 1;
  FStartResumeTime := 0;
end;

procedure TpoTournProcess.GetDataFromNode(Node: IXMLNode);
begin
  try
    FProcessID := Node.Attributes['processid'];
    FName      := Node.Attributes['name'];
    FStatusID  := Node.Attributes['statusid'];
    FMinStack  := Node.Attributes['minstack'];
    FAvgStack  := Node.Attributes['avgstack'];
    FMaxStack  := Node.Attributes['maxstack'];
    // is not saved in DB
    FHandCount := 1;
    FLevel     := 1;
  except
    on E: Exception do begin
      CommonDataModule.Log(ClassName, 'GetDataFromNode',
        '[EXCEPTION]: ' + E.Message + '; Params: Node=' + Node.XML,
        ltException
      );
    end;
  end;
end;

function TpoTournProcess.GetIsRunning: Boolean;
begin
  Result := (FStatusID = 1);
end;

function TpoTournProcess.GetIsUnused: Boolean;
begin
  Result := (FStatusID = 0);
end;

function TpoTournProcess.GetIsWaiting: Boolean;
begin
  Result := (FStatusID = 2);
end;

function TpoTournProcess.LoadFromDB(const TournamentID: Integer;
  SQLAdapter: TSQLAdapter): Integer;
var
  Node: IXMLNode;
  sSQL, StrData: string;
  XML: IXMLDocument;
begin
{$IFDEF __TEST__}
	Result := 0;
  Exit;
{$ENDIF}

	Result := 0;

  // try to execute store procedure
  sSQL := 'exec srvtouGetProcessContextXML ' + IntToStr(TournamentID) + ', ' + IntToStr(ProcessID);
  try
    StrData := SQLAdapter.ExecuteForXML(sSql);
  except on E: Exception do
    begin
      Result := TS_ERR_SQLERROR;
      LogException( '{D23C57F7-3748-4D3C-9AE0-40BAEFBCE6CB}',
        ClassName, 'LoadFromDB',
        E.Message + ': On SQL=' + sSQL
      );
    end;
  end;

  if StrData = '' then
  begin
    LogException( '{B5939144-9181-49DA-AEB6-E941B394A786}',
      ClassName, 'LoadFromDB', 'SQL procedure: [' + sSQL + '] return empty result.'
    );

    Result := TS_ERR_SQLERROR;
    Exit;
  end;

  // XML Parcer
  try

    XML := TXMLDocument.Create(nil);
	  XML.XML.Text := StrData;
    XML.Active   := true;

   	Node := XML.DocumentElement;

    // user context from xml to data
    GetDataFromNode(Node);

    XML.Active := False;
    XML        := nil;

  except on E: Exception do
    begin
      Result := TS_ERR_XMLPARCEERROR;
      LogException( '{6ED2AAFD-0302-4A2D-8E1C-FF18CA13335A}',
        ClassName, 'LoadFromDB',
        'XML Parser error: ' + E.Message + ': XML=' + XML.DocumentElement.XML
      );

      XML.Active := False;
      XML        := nil;
    end;
  end;
end;

procedure TpoTournProcess.SetAvgStack(const Value: Currency);
begin
  FAvgStack := Value;
end;

function TpoTournProcess.SetContextByObject(FromObj: TpoTournProcess): Integer;
begin
  if FromObj = nil then
  begin
    LogException( '{39477D02-E94F-4217-AA0D-4736E80D7C03}',
      ClassName, 'SetContextByObject', 'Try to take context from nil object'
    );

    Result := 1;
    Exit;
  end;

  // Tournament context; EXTERNAL (sets on add in list)
  FTournamentID := FromObj.FTournamentID;
  // process context
  FProcessID := FromObj.FProcessID;
  FName      := FromObj.FName;
  FStatusID  := FromObj.FStatusID;
  FLevel     := FromObj.FLevel;
  FMinStack  := FromObj.FMinStack;
  FAvgStack  := FromObj.FAvgStack;
  FMaxStack  := FromObj.FMaxStack;
  FHandCount := FromObj.FHandCount;

  Result := 0;
end;

procedure TpoTournProcess.SetMaxStack(const Value: Currency);
begin
  FMaxStack := Value;
end;

procedure TpoTournProcess.SetMinStack(const Value: Currency);
begin
  FMinStack := Value;
end;

procedure TpoTournProcess.SetHandCount(const Value: Integer);
begin
  FHandCount := Value;
end;

procedure TpoTournProcess.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TpoTournProcess.SetProcessID(const Value: Integer);
begin
  FProcessID := Value;
end;

procedure TpoTournProcess.SetStatusID(const Value: Integer);
begin
  // check on constraint
  if not (Value in [pstUnused, pstRunning, pstWaiting]) then begin
    LogException('{D754DA6A-B3C0-4089-9567-26E31412E8A8}',
      ClassName, 'SetStatusID',
      'Try to set unknown process status = ' + IntToStr(Value)
    );

    Exit;
  end;

  FStatusID := Value;
end;

procedure TpoTournProcess.SetTournamentID(const Value: Integer);
begin
  FTournamentID := Value;
end;

function TpoTournProcess.StoreToDB(const TournamentID: Integer;
  SQLAdapter: TSQLAdapter): Integer;
begin
{$IFDEF __TEST__}
	Result := 0;
  Exit;
{$ENDIF}

  Result := 0;
  try

    SQLAdapter.SetProcName('srvtouSetProcessContext');
    SQLAdapter.AddParInt('RETURN_VALUE',Result,ptResult);
    SQLAdapter.AddParInt('TournamentID', TournamentID, ptInput);
    SQLAdapter.AddParInt('ProcessID', FProcessID, ptInput);
    SQLAdapter.AddParInt('StatusID', FStatusID, ptInput);
    SQLAdapter.AddParam('MinStack', FMinStack, ptInput, ftCurrency);
    SQLAdapter.AddParam('AvgStack', FAvgStack, ptInput, ftCurrency);
    SQLAdapter.AddParam('MaxStack', FMaxStack, ptInput, ftCurrency);

    SQLAdapter.ExecuteCommand;

    Result := SQLAdapter.GetParam('RETURN_VALUE');

    if (Result <> 0) then begin
      LogException( '{059B3DCE-D3FF-45DB-99AC-D8800BF14470}',
        ClassName, 'StoreToDB',
        'SQL result = ' + IntToStr(Result) + '; Params: TournamentID=' + IntToStr(TournamentID) + ', ProcessID=' + IntToStr(ProcessID) + ', StatusID=' + IntToStr(StatusID) + ' ...'
      );
    end;

  except on E: Exception do
    begin
      Result := TS_ERR_SQLERROR;
      LogException( '{58644219-5A4D-48A0-8388-AF24A4BBB44D}',
        ClassName, 'StoreToDB',
        E.Message +
        '; Params: TournamentID=' + IntToStr(TournamentID) + ', ProcessID=' + IntToStr(ProcessID) + ', StatusID=' + IntToStr(StatusID) + ' ...'
      );
    end;
  end;

end;

function TpoTournProcess.GetCommandToGameEngine(
  Command, Msg, ChatMsg, Event, ExceptUserIDs: string;
  Stake, Ante, RebuyChips: Currency; CountPlaces, ActionDispatcherID, BreakDuration: Integer;
  PlayersIn, PlayersOut: TpoTournUserList): string;
var
  CommandXML: string;
  AGuid: TGuid;
  sGuid: string;
begin
  CommonDataModule.Log(ClassName, 'GetCommandToGameEngine',
    'Entry with command: ' + Command, ltCall );

  Result := '';

  // Validate
  if (Command <> cmdInit)   and (Command <> cmdPlay) and
     (Command <> cmdResume) and (Command <> cmdChangePlace) and
     (Command <> cmdEnd)    and (Command <> cmdFree) and
     (Command <> cmdBreak)  and (Command <> cmdEvent) and
     (Command <> cmdRebuy)  and (Command <> cmdKickOffUsers) and
     (Command <> cmdStandUp)
  then begin
    CommonDataModule.Log(ClassName, 'GetCommandToGameEngine',
      'EXCEPTION: Uncnown command=[' + Command + '].', ltException );

    Exit;
  end;

  if (PlayersIn = nil) and
     ((Command = cmdInit) or (Command = cmdPlay) or (Command = cmdRebuy))
  then begin
    CommonDataModule.Log(ClassName, 'GetCommandToGameEngine',
      'EXCEPTION: On command=[' + Command + '] Players in game can not be nil.', ltException );

    Exit;
  end;
  if (((PlayersIn = nil) and (PlayersOut = nil)) and (Command = cmdChangePlace)) or
     ((PlayersOut = nil) and (Command = cmdKickOffUsers)) or
     ((PlayersOut = nil) and (Command = cmdStandUp))
  then begin
    CommonDataModule.Log(ClassName, 'GetCommandToGameEngine',
      'EXCEPTION: On command=[' + Command + '] Players in and out game can not be nil.', ltException );

    Exit;
  end;

  if (FProcessID <= 0) or (FStatusID = 0) then begin
    CommonDataModule.Log(ClassName, 'GetCommandToGameEngine',
      'EXCEPTION: Command=[' + Command + '] can not be sending to unused process.; ' +
        'Parameters: ProcessID=' + IntToStr(FProcessID) + ', StatusID=' + IntToStr(FStatusID),
      ltException );

    Exit;
  end;
  // End of Validate

  CreateGUID(AGuid);
  sGuid := GUIDToString(AGuid);
  if (Command = cmdEvent) then begin
    CommandXML :=
      '<tournamentaction command="' + Command + '" ' +
          'event="' + Event + '" reason="' + Msg + '" chat="' + ChatMsg + '" ';
    if (Event = eventBreak) or (Event = eventStart) then
      CommandXML := CommandXML + 'breakduration="' + IntToStr(BreakDuration) + '" ';
    if Event = eventFinishTournament then
      CommandXML := CommandXML + 'exceptuserids="' + ExceptUserIDs + '" ';
  end else begin
    CommandXML :=
      '<tournamentaction command="' + Command + '" ' +
          'stake="' + CurrToStr(Stake) + '" ante="' + CurrToStr(Ante) + '" ' +
          'reason="' + Msg + '" chat="' + ChatMsg + '" ';
  end;
  if (Command = cmdResume) or
     ((Command = cmdChangePlace) and (PlayersOut <> nil)) or
     ((Command = cmdKickOffUsers) and (PlayersOut <> nil)) or
     ((Command = cmdStandUp) and (PlayersOut <> nil))
  then begin
    CommandXML := CommandXML +
        'countofplaces="' + IntToStr(CountPlaces) + '" ';
  end;
  CommandXML := CommandXML +
        'actiondispatcherid="' + IntToStr(ActionDispatcherID) + '" ' +
        'seq_id="' + sGuid + '">';

  if (Command = cmdInit) or (Command = cmdPlay) then begin
    CommandXML := CommandXML +
      PlayersIn.GetNodeListOnCommand_GE_XML(FProcessID, 'player');
  end else
  if (Command = cmdRebuy) then begin
    CommandXML := CommandXML +
      PlayersIn.GetNodeListOnCommand_GE_XML(FProcessID, 'rebuy', RebuyChips);
  end else
  if (Command = cmdChangePlace) then begin
    if PlayersOut <> nil then
      CommandXML := CommandXML +
        PlayersOut.GetNodeListOnCommand_GE_XML(FProcessID, 'standup');

    if PlayersIn <> nil then
      CommandXML := CommandXML +
        PlayersIn.GetNodeListOnCommand_GE_XML(FProcessID, 'sitdown');
  end else
  if (Command = cmdStandUp) then begin
    if PlayersOut <> nil then
      CommandXML := CommandXML +
        PlayersOut.GetNodeListOnCommand_GE_XML(FProcessID, 'standup');
  end else
  if (Command = cmdKickOffUsers) then begin
    if PlayersOut <> nil then
      CommandXML := CommandXML +
        PlayersOut.GetNodeListOnKickOffByAdministrator(FProcessID, 'kickoff');
  end;

  // close tournamentaction node
  CommandXML := CommandXML + '</tournamentaction>';

  CommandXML :=
    '<objects>' +
      '<object name="' + OBJ_GameAdapter + '" id="' + IntToStr(FProcessID) + '">' +
        '<gaaction sessionid="0" userid="0" processid="' + IntToStr(FProcessID) + '" ' +
                  'tournamentid="' + IntToStr(FTournamentID) + '" ' +
                  'actiondispatcherid="' + IntToStr(ActionDispatcherID) + '">' +
          CommandXML +
        '</gaaction>' +
      '</object>' +
    '</objects>';

  Result := CommandXML;

  CommonDataModule.Log(ClassName, 'GetCommandToGameEngine',
    'Exit; Command was creating: ' + Result, ltCall );
end;

function TpoTournProcess.toGetProcesses_LOBBY_XML(Players: TpoTournUserList;
  ActionDispatcherID: Integer): string;
begin
  Result := '';

  if Players = nil then begin
    LogException('{18999411-84B1-4549-9D16-31BCE85CF3BF}',
      ClassName, 'toGetProcesses_LOBBY_XML', 'Parameter "Players" is nil'
    );

    Exit;
  end;

  if Self.IsUnused then begin
    CommonDataModule.Log(ClassName, 'toGetProcesses_LOBBY_XML',
      'Found Unused process in List. Foggot drop it.', ltError);

    Exit;
  end;

  Result := Result +
    '<process ' +
      'id="' + IntToStr(FProcessID) + '" ' +
      'actiondispatcherid="' + IntToStr(ActionDispatcherID) + '" ' +
      'name="' + XMLSafeEncode(Name) + '" ' +
      'playerscount="' + IntToStr(Players.CountOnProcess[FProcessID]) + '" ' +
      'minstack="' + FloatToStrF(FMinStack, ffFixed, 12, 2) + '" ' +
      'avgstack="' + FloatToStrF(FAvgStack, ffFixed, 12, 2) + '" ' +
      'maxstack="' + FloatToStrF(FMaxStack, ffFixed, 12, 2) + '" ' +
    '/>';
end;

procedure TpoTournProcess.SetLevel(const Value: Integer);
begin
  FLevel := Value;
end;

procedure TpoTournProcess.SetStartResumeTime(const Value: TDateTime);
begin
  FStartResumeTime := Value;
end;

{ TpoTournProcessList }

function TpoTournProcessList.Add: TpoTournProcess;
begin
  Result := TpoTournProcess.Create;
  inherited Add(Result);
  Result.FTournamentID := Self.FTournamentID;
  Log( ClassName, 'Add',
    'New process has been added to list: TournamentID=' + IntToStr(Result.TournamentID) + ', ProcessId=' + IntToStr(Result.ProcessID)
  );
end;

constructor TpoTournProcessList.Create(TournamentID: Integer);
begin
  inherited Create;
  FTournamentID := TournamentID;
  // initial
  FSmallestStack := 0;
  FLargestStack := 0;
  FAverageStack := 0;
  FSumAllHand := 1;
end;

procedure TpoTournProcessList.Del(Item: TpoTournProcess);
begin
  Log( ClassName, 'Del', 'Drop process from the list: TournamentID=' + IntToStr(Item.TournamentID) + ', ProcessID=' + IntToStr(Item.ProcessID) + ', Index=' + IntToStr(IndexOf(Item)));
  inherited Remove(Item);
end;

destructor TpoTournProcessList.Destroy;
begin
  Clear;
  inherited;
end;

function TpoTournProcessList.GetActiveCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I:=0 to Count - 1 do begin
    if not Items[I].IsUnused then Result := Result + 1;
  end;
end;

function TpoTournProcessList.GetAverageStack: Currency;
var
  I: Integer;
begin
  Result := 0;
  if Count <= 0 then Exit;
  for I:=0 to Count - 1 do
    Result := Result + Items[I].FAvgStack;
  Result := Result / Count;
end;

function TpoTournProcessList.GetItems(Index: Integer): TpoTournProcess;
begin
  Result := TpoTournProcess(inherited Items[Index]);
end;

function TpoTournProcessList.GetProcessByID(nID: Integer): TpoTournProcess;
var
  I: Integer;
  aPrc: TpoTournProcess;
begin
  Result := nil;
  for I:=0 to Count - 1 do begin
    aPrc := Items[I];
    if aPrc.FProcessID = nID then begin
      Result := aPrc;
      Exit;
    end;
  end;
end;

function TpoTournProcessList.GetWatingCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I:=0 to Count - 1 do begin
    if Items[I].IsWaiting then Result := Result + 1;
  end;
end;

function TpoTournProcessList.Ins(Index: Integer): TpoTournProcess;
begin
  Result := TpoTournProcess.Create;
  inherited Insert(Index, Result);
  Result.TournamentID := Self.TournamentID;
  Log( ClassName, 'Insert', 'New process has been inserted to list at index: ' + IntToStr(Index));
end;

function TpoTournProcessList.LoadFromDB(SQLAdapter: TSQLAdapter): Integer;
var
  sSQL: string;
  StrData: string;
  XML  : IXMLDocument;
  Node : IXMLNode;
  i: Integer;
  aProcess: TpoTournProcess;
begin
{$IFDEF __TEST__}
	Result := 0;
  Exit;
{$ENDIF}

	Result := 0;

  // clear list before all
  Clear;

  // try to execute store procedure
  sSQL := 'exec srvtouGetTournamentProcessesXML ' + IntToStr(TournamentID);
  try
    StrData := SQLAdapter.ExecuteForXML(sSql);
  except on E: Exception do
    begin
      Result := TS_ERR_SQLERROR;
      LogException( '{84DB4EC4-E237-43E5-B11A-00BEF9ADDE98}',
        ClassName, 'LoadFromDB',
        E.Message + ': On SQL=' + sSQL
      );
    end;
  end;

  if StrData = '' then Exit;

  // XML Parcer
  try
    XML := TXMLDocument.Create(nil);
	  XML.XML.Text := '<tournament>'+StrData+'</tournament>';
    XML.Active   := true;

  	for i := 0 to (XML.DocumentElement.ChildNodes.Count-1) do
    begin
    	Node := XML.DocumentElement.ChildNodes[i];

      // add new user into list
      aProcess := Self.Add;

      // user context from node xml to data
      aProcess.GetDataFromNode(Node);
    end;

    SortByName(True);

    XML.Active := False;
    XML        := nil;

  except on E: Exception do
    begin
      Result := TS_ERR_XMLPARCEERROR;
      LogException( '{28477D26-D186-44B3-9225-77BF0DFA4487}',
        ClassName, 'LoadFromDB',
        'XML Parser error: ' + E.Message + ': XML=' + XML.DocumentElement.XML
      );

      XML.Active := False;
      XML        := nil;
    end;
  end;

end;

function TpoTournProcessList.RegistrationProcess(EngineID: Integer; nStartStack: Currency;
  Name: string; SQLAdapter: TSQLAdapter): Integer;
var
  aProcess: TpoTournProcess;
  EngineComName: string;
  sReason: String;
  InitProcessXML: String;
  aEngObj: TGameConnector;
begin
  // add to list
  aProcess := Add;
  if Name = '' then begin
    aProcess.FName := IntToStr(TournamentID) + ' ' + IntToStr(IndexOf(aProcess));
  end else begin
    aProcess.FName := Name + ' ' + IntToStr(IndexOf(aProcess));
  end;

  // exec stored procedure
  // state, stats records in DB will be deleted
{$IFDEF __TEST__}
  aProcess.FProcessID := Self.Count;
  aProcess.FStatusID  := pstWaiting;

  // get engine com name for use
  EngineComName := 'EngineComName';
  InitProcessXML := '';

  Result := 0;
  Exit;
{$ENDIF}

  aProcess.FMinStack  := nStartStack;
  aProcess.FAvgStack  := nStartStack;
  aProcess.FMaxStack  := nStartStack;

  FSmallestStack := nStartStack;
  FAverageStack  := nStartStack;
  FLargestStack  := nStartStack;

  try

    SQLAdapter.SetProcName('srvtouRegistrationGameProcess');
    SQLAdapter.AddParInt('RETURN_VALUE',0,ptResult);
    SQLAdapter.AddParInt('TournamentID', FTournamentID, ptInput);
    SQLAdapter.AddParInt('GameEngineID', EngineID, ptInput);
    SQLAdapter.AddParString('Name', aProcess.FName, ptInput);
    SQLAdapter.AddParInt('GameProcessID',0,ptOutput);
    SQLAdapter.AddParString('EngineComName','',ptOutput);
    SQLAdapter.AddParString('InitProcessXML','',ptOutput);

    SQLAdapter.ExecuteCommand;

    Result := SQLAdapter.GetParam('RETURN_VALUE');

    if (Result <> 0) then begin
      LogException( '{BDC82B13-B3CE-4B18-A997-FDEB74A4F99F}',
        ClassName, 'RegistrationProcess',
        'On Execute srvtouRegistrationGameProcess result = ' + IntToStr(Result) +
        '; Params: TournamentID=' + IntToStr(TournamentID) + ', TableNum=' + IntToStr(IndexOf(aProcess) + 1) +
          ', EngineID=' + IntToStr(EngineID) + ', Name=' + aProcess.Name
      );

      Del(aProcess); // delete from list on error
      Exit;
    end;

    aProcess.FProcessID := SQLAdapter.GetParam('GameProcessID');
    aProcess.FStatusID  := pstWaiting;

    // get engine com name for use
    EngineComName := SQLAdapter.GetParam('EngineComName');
    InitProcessXML := SQLAdapter.GetParam('InitProcessXML');

  except on E: Exception do
    begin
      LogException( '{BB6F8AEB-2103-4D9F-940F-DEF302284A0C}',
        ClassName, 'RegistrationProcess',
        E.Message +
        ': On Execute srvtouRegistrationGameProcess ' +
        '; Params: TournamentID=' + IntToStr(TournamentID) + ', TableNum=' + IntToStr(IndexOf(aProcess) + 1)
      );

      Result := TS_ERR_SQLERROR;
      Del(aProcess); // delete from list on error

      Exit;
    end;
  end;

  // Call InitGameProcess from gameengine
  // state, stats records in DB will be created
  try
    aEngObj := CreateGameConnector(ClassName, EngineComName);
    Result := aEngObj.InitGameProcess(aProcess.FProcessID, InitProcessXML, sReason);

    if Result <> 0 then begin
      LogException('{0B81D984-3542-43E2-A286-3692F2A8CA23}',
        ClassName, 'RegistrationProcess',
        'ComObject "' + EngineComName + '" return error result = ' + IntToStr(Result) + ', Reason = ' + sReason
      );

      Del(aProcess); // delete from list on error
      Exit;
    end;

  except on E: Exception do
    begin
      LogException('{621AF472-52C2-4C5B-B881-CABE783896B2}',
        ClassName, 'RegistrationProcess',
        'ComObject "' + EngineComName + '" raise exception: ' + sReason
      );

      Result := TS_ERR_ONEXECUTEINITENGINE;
      Del(aProcess); // delete from list on error
      Exit;
    end;
  end;
end;

procedure TpoTournProcessList.SetAverageStack(const Value: Currency);
begin
  FAverageStack := Value;
end;

function TpoTournProcessList.SetContextByObject(
  FromObj: TpoTournProcessList): Integer;
var
  I: Integer;
begin
  if FromObj = nil then
  begin
    LogException( '{AF744439-52CC-4EB1-83AD-7DB8C3A2A176}',
      ClassName, 'SetContextByObject', 'Try to take context from nil object'
    );

    Result := 1;
    Exit;
  end;

  Clear;
  for I := 0 to FromObj.Count - 1 do begin
    Add.SetContextByObject(FromObj.Items[I]);
  end;

  Result := 0;

end;

procedure TpoTournProcessList.SetLargestStack(const Value: Currency);
begin
  FLargestStack := Value;
end;

procedure TpoTournProcessList.SetSmallestStack(const Value: Currency);
begin
  FSmallestStack := Value;
end;

procedure TpoTournProcessList.SetSumAllHand(const Value: Integer);
begin
  FSumAllHand := Value;
end;

procedure TpoTournProcessList.SetTournamentID(const Value: Integer);
begin
  FTournamentID := Value;
end;

function TpoTournProcessList.SortByName(Ascending: Boolean): Integer;
var
  TopInd: Integer;
  I, J: Integer;
  aProcess: TpoTournProcess;
begin
  for I := 0 to Count - 1 do
  begin
    TopInd := I;

    // search next top index
    for J := I+1 to Count - 1 do
    begin
      aProcess := Items[J];

      if Ascending then begin
        if Items[TopInd].FName > aProcess.FName then TopInd := IndexOf(aProcess);
      end else begin
        if Items[TopInd].FName < aProcess.FName then TopInd := IndexOf(aProcess);
      end;
    end;

    // swap indexes
    if (TopInd <> I) then begin
      aProcess := TpoTournProcess.Create;
      aProcess.SetContextByObject(Items[TopInd]);
      Items[TopInd].SetContextByObject(Items[I]);
      Items[I].SetContextByObject(aProcess);
      aProcess.Free;
    end;
  end;

  Result := 0;

end;

function TpoTournProcessList.StoreToDB(SQLAdapter: TSQLAdapter): Integer;
var
  I: Integer;
  aProcess: TpoTournProcess;
begin
{$IFDEF __TEST__}
	Result := 0;
  Exit;
{$ENDIF}

  Result := 0;
  try
    for I := 0 to Self.Count - 1 do
    begin
      aProcess := Items[I];
      Result := Result + aProcess.StoreToDB(TournamentID, SQLAdapter);
    end;
  except on E: Exception do
  end;

end;

function TpoTournProcessList.toGetProcesses_LOBBY_XML(Players: TpoTournUserList; ActionDispatcherID: Integer): string;
var
  I: Integer;
  aProcess: TpoTournProcess;
  Data: string;
begin
// *********************************
// WARNING: it is not XML
// *********************************

  Data := '';

  // Filling XML
  for I := 0 to Count - 1 do begin
    aProcess := Items[I];
    Data := Data + aProcess.toGetProcesses_LOBBY_XML(Players, ActionDispatcherID);
  end;

  Result := Data;

end;

{ TpoTournPrizeRate }

constructor TpoTournPrizeRate.Create(aPrizeList: TpoTournPrizeRateList);
begin
  inherited Create;
  FPrizeList := aPrizeList;
end;

function TpoTournPrizeRate.GetPrizePool_NodeXMLToLobby(TotalPrize: Currency;isShortData: Boolean): string;
var                                                                         //if true gets only prizes
  sRest, sCurrSign: string;
  RestPlace: Char;
begin
  sRest := IntToStr(Place);
  RestPlace := sRest[Length(sRest)];
  case RestPlace of
    '1': sRest := 'st';
    '2': sRest := 'nd';
    '3': sRest := 'rd';
  else
    sRest := 'th';
  end;

  sCurrSign := '';
  if (PrizeList <> nil) then sCurrSign := PrizeList.FCurrencySign;

  if not isShortData then
    if (FNonCurrencyPrize = '') then
      Result := '<data value="' + IntToStr(FPlace) + sRest + ' - ' + sCurrSign + FloatToStrF(PrizeValue(TotalPrize), ffFixed, 12, 2) + '"/>'
    else
      Result := '<data value="' + IntToStr(FPlace) + sRest + ' - ' + sCurrSign + FloatToStrF(PrizeValue(TotalPrize), ffFixed, 12, 2) + ' (' + FNonCurrencyPrize + ')"/>'
  else
    Result := '<data value="' + sCurrSign + FloatToStrF(PrizeValue(TotalPrize), ffFixed, 12, 2) + '"/>';
end;

function TpoTournPrizeRate.PrizeValue(TotalPrize: Currency): Currency;
begin
  Result := (TotalPrize * FPrizeRate) / 100;
  if (FPrizeList = nil) then Exit;

  case FPrizeList.FPrizeValueType of
    prvTypeFixedValue: Result := FPrizeRate;
  end;
end;

function TpoTournPrizeRate.SetContextByObject(
  FromObj: TpoTournPrizeRate): Integer;
begin
  if FromObj = nil then
  begin
    LogException( '{1468130E-5B6D-4246-B919-88920F32957C}',
      ClassName, 'SetContextByObject', 'Try to take context from nil object'
    );

    Result := 1;
    Exit;
  end;

  // properties
  FPlace     := FromObj.FPlace;
  FPrizeRate := FromObj.FPrizeRate;
  FNonCurrencyPrize := FromObj.FNonCurrencyPrize;
  FIsHandForHand := FromObj.FIsHandForHand;

  Result := 0;
end;

procedure TpoTournPrizeRate.SetIsHandForHand(const Value: Boolean);
begin
  FIsHandForHand := Value;
end;

procedure TpoTournPrizeRate.SetNonCurrencyPrize(const Value: string);
begin
  FNonCurrencyPrize := Value;
end;

procedure TpoTournPrizeRate.SetPlace(const Value: Integer);
begin
  FPlace := Value;
end;

procedure TpoTournPrizeRate.SetPrizeRate(const Value: Currency);
begin
  FPrizeRate := Value;
end;

{ TpoTournPrizeRateList }

function TpoTournPrizeRateList.Add: TpoTournPrizeRate;
begin
  Result := TpoTournPrizeRate.Create(Self);
  inherited Add(Result);
end;

constructor TpoTournPrizeRateList.Create(TournamentID: Integer);
begin
  inherited Create;
  SetDefault;
end;

procedure TpoTournPrizeRateList.Del(Item: TpoTournPrizeRate);
begin
  inherited Remove(Item);
end;

function TpoTournPrizeRateList.GetItems(Index: Integer): TpoTournPrizeRate;
begin
  Result := TpoTournPrizeRate(inherited Items[Index]);
end;

function TpoTournPrizeRateList.Ins(Index: Integer): TpoTournPrizeRate;
begin
  Result := TpoTournPrizeRate.Create(Self);
  inherited Insert(Index, Result);
end;

function TpoTournPrizeRateList.LoadFromAdmSiteXML(FTournament: TtsTournament): Integer;
var
  XML: IXMLDocument;
  Root, Node, CurrNode: IXMLNode;
  I, J: Integer;
  nFrom, nTo, nPlayersForFinish: Integer;
  Rate: Currency;
  aPrizeRate: TpoTournPrizeRate;
  sNonCurrencyPrize: string;
begin
  if FTournament = nil then begin
    LogException( '{D9926BB1-28D4-4959-92C3-FC1BC5A89AE6}',
      ClassName, 'LoadFromAdmSiteXML', 'Tournament object is empty.'
    );

    Result := 1;
    SetDefault;
    Exit;
  end;

  if PrizePoolXML = '' then begin
    Result := 0;
    SetDefault;
    Exit;
  end;

  Clear;
  Result := 0;

  // initial values
  FCurrencyTypeID := 1;
  FPrizeValueType := prvTypeFixedValue;
  FPrizeTypeID    := 0;

  Node := nil;
  try
    XML := TXMLDocument.Create(nil);
    XML.XML.Text := PrizePoolXML;
    XML.Active := True;

    // search for needing node correspond registered players
    Root := XML.DocumentElement;
    if Root.HasAttribute(Attr_CurrType) then
      FCurrencyTypeID := StrToIntDef(Root.Attributes[Attr_CurrType]      , 1);
    if Root.HasAttribute(Attr_PrizeValueType) then
      FPrizeValueType := StrToIntDef(Root.Attributes[Attr_PrizeValueType], prvTypePercent);
    if Root.HasAttribute(Attr_PrizeTypeID) then
      FPrizeTypeID    := StrToIntDef(Root.Attributes[Attr_PrizeTypeID]   , 0);

    CurrNode := nil;
    for I:= 0 to Root.ChildNodes.Count - 1 do begin
      CurrNode := Root.ChildNodes[I];
      nFrom := StrToIntDef(CurrNode.Attributes['from'], 0);
      nPlayersForFinish := StrToIntDef(CurrNode.Attributes['playersforfinish'], 0);

      if (nFrom <= 0) or (nPlayersForFinish <= 0) then Continue;
      if FTournament.Entrants < nFrom then begin
        if I = 0 then Node := CurrNode;
        Break;
      end;
      FNumberOfPlayersForFinish := nPlayersForFinish;
      Node := CurrNode;
    end;

    if Node <> nil then begin
      Root := Node;
      for I:= 0 to Root.ChildNodes.Count - 1 do begin
        Node := Root.ChildNodes[I];
        nFrom := Node.Attributes['from'];
        nTo   := Node.Attributes['to'];
        Rate  := StrToCurrDef(Node.Attributes['prizeRate'], 0);
        sNonCurrencyPrize := '';
        if Node.HasAttribute('noncurrencyprize') then
          sNonCurrencyPrize := Node.Attributes['noncurrencyprize'];

        if Rate < 0 then Continue;

        if nFrom = nTo then begin
          aPrizeRate := Add;
          aPrizeRate.FPlace := Count;
          aPrizeRate.FPrizeRate := Rate;
          aPrizeRate.FNonCurrencyPrize := sNonCurrencyPrize;
          aPrizeRate.FIsHandForHand := False;
        end else begin
          Rate := Rate / (nTo - nFrom + 1);
          for J := nFrom to nTo do begin
            aPrizeRate := Add;
            aPrizeRate.FPlace := Count;
            aPrizeRate.FPrizeRate := Rate;
            aPrizeRate.FNonCurrencyPrize := sNonCurrencyPrize;
          end;
          Self.Items[Count-1].FIsHandForHand := True;
        end;
      end;
    end;

    if Self.Count = 0 then // set defaulf
      SetDefault;
    Self.Items[Count-1].FIsHandForHand := True;

    XML.Active := False;
    XML := nil;
    Exit;

  except on E: Exception do
    begin
      Result := TS_ERR_XMLPARCEERROR;
      LogException( '{51FD5904-C348-44A0-9727-612F86B317B5}',
        ClassName, 'LoadFromAdmSiteXML',
        'XML Parser error: ' + E.Message +
        ': XML=' + PrizePoolXML + ', TournamentID=' + IntToStr(FTournament.TournamentID) + ', Entrants=' + IntToStr(FTournament.Entrants)
      );

      XML.Active := False;
      XML := nil;

      // set defaulf
      SetDefault;
      Exit;
    end;
  end;
end;

procedure TpoTournPrizeRateList.SetDefault;
var
  aPrizeRate: TpoTournPrizeRate;
  sXML: string;
begin
  sXML := PrizePoolXML;
  Self.Clear;

  // default values
  FCurrencyTypeID := 1;
  FPrizeValueType := prvTypeFixedValue;
  FPrizeTypeID    := 0;
  FNumberOfPlayersForFinish := 1;

  aPrizeRate := Add;
  FPrizePoolXML := sXML;
  aPrizeRate.FPlace := Count;
  aPrizeRate.FPrizeRate := 0;
  {only fo test}
(*
  if aPrizeRate.FPlace = 1 then
    aPrizeRate.FNonCurrencyPrize := 'Test big'
  else
    aPrizeRate.FNonCurrencyPrize := '';
  *)
  aPrizeRate.FNonCurrencyPrize := '';
  aPrizeRate.FIsHandForHand := True;
end;

function TpoTournPrizeRateList.GetDataPrizePool_ToLobby(TotalPrize: Currency; isShortData: Boolean): string;
var
  I: Integer;
begin
// ********************************
// WARNIG: it is not XML
// ********************************

  Result := '';
  for I:=0 to Count - 1 do begin
    Result := Result + Items[I].GetPrizePool_NodeXMLToLobby(TotalPrize, isShortData)
  end;
  if isShortData then
    Result := '<prize name="' + FName + '">' +  Result + '</prize>'
end;

procedure TpoTournPrizeRateList.SetPrizePoolXML(const Value: string);
begin
  FPrizePoolXML := Value;
end;

function TpoTournPrizeRateList.SetContextByObject(
  FromObj: TpoTournPrizeRateList): Integer;
var
  I: Integer;
begin
  if FromObj = nil then
  begin
    LogException( '{D43F9749-CD22-4BA8-896B-9DD4E80BCA52}',
      ClassName, 'SetContextByObject', 'Try to take context from nil object'
    );

    Result := 1;
    Exit;
  end;

  Clear;
  FPrizePoolXML := FromObj.FPrizePoolXML;
  FCurrencyTypeID := FromObj.FCurrencyTypeID;
  FPrizeValueType := FromObj.FPrizeValueType;
  FPrizeTypeID    := FromObj.FPrizeTypeID;
  FName           := FromObj.FName;
  FCurrencySign   := FromObj.FCurrencySign;
  FCurrencyName   := FromObj.FCurrencyName;
  for I:=0 to FromObj.Count - 1 do begin
    Add.SetContextByObject(FromObj.Items[I]);
  end;

  Result := 0;
end;

destructor TpoTournPrizeRateList.Destroy;
begin
  Clear;
  inherited;
end;

(*
function TpoTournPrizeRateList.LoadFromDB(const TournamentID: Integer;
  SQLAdapter: TSQLAdapter): Integer;
var
  StrData, sSQL: string;
begin
  Result := 0;
  sSQL := 'exec srvtouGetTournamentPaySchemaXML ' + IntToStr(TournamentID);
  try
    StrData := SQLAdapter.ExecuteForXML(sSql);
  except on E: Exception do
    begin
      Result := TS_ERR_SQLERROR;
      LogException( '{F5E59CCE-E187-4A20-8593-41EC1A2AD167}',
        ClassName, 'LoadFromDB',
        E.Message + ': On Execute SQL=' + sSQL
      );
      Exit;
    end;
  end;

  if StrData = '' then
  begin
    LogException( '{4D7F1983-542A-43C8-ACF0-999AE947B0D5}',
      ClassName, 'LoadFromDB', 'SQL procedure: [' + sSQL + '] return empty result.'
    );

    Result := TS_ERR_SQLERROR;
    Exit;
  end;

  PrizePoolXML := StrData;
end;
*)
procedure TpoTournPrizeRateList.SetPrizeValueType(const Value: Integer);
begin
  FPrizeValueType := Value;
end;

procedure TpoTournPrizeRateList.SetCurrencyTypeID(const Value: Integer);
begin
  FCurrencyTypeID := Value;
end;

procedure TpoTournPrizeRateList.SetPrizeTypeID(const Value: Integer);
begin
  FPrizeTypeID := Value;
end;

procedure TpoTournPrizeRateList.SetCurrencySign(const Value: string);
begin
  FCurrencySign := Value;
end;

procedure TpoTournPrizeRateList.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TpoTournPrizeRateList.SetNumberOfPlayersForFinish(const Value: Integer);
begin
  FNumberOfPlayersForFinish := Value;
end;

procedure TpoTournPrizeRateList.SetCurrencyName(const Value: string);
begin
  FCurrencyName := Value;
end;

function TpoTournPrizeRateList.ItemsByPlace(nPlace: Integer): TpoTournPrizeRate;
var
  I: Integer;
  aPrize: TpoTournPrizeRate;
begin
  Result := nil;
  for I:=0 to Count - 1 do begin
    aPrize := Items[I];
    if aPrize.FPlace = nPlace then begin
      Result := aPrize;
      Exit;
    end;
  end;
end;

procedure TpoTournPrizeRateList.SetSatelited(aTournament: TtsTournament);
var
  nCntForFinish: Integer;
  nMasterBuyInFee, nBuyInFee: Currency;
  nAdditionalMoney, nMasterMoney: Currency;
  sAdditional: string;
begin
  nMasterBuyInFee := aTournament.FMasterBuyIn + aTournament.FMasterFee;
  nBuyInFee := aTournament.FBuyIn + aTournament.FFee;
  if (nMasterBuyInFee <= 0) or (nBuyInFee <= 0) then begin
    nCntForFinish := 1;
    nAdditionalMoney := 0;
    nMasterMoney := aTournament.TotalPrize;
  end else begin
    nCntForFinish := Trunc(aTournament.Entrants / (nMasterBuyInFee / nBuyInFee));
    if (nCntForFinish > 0) then begin
      nMasterMoney := nCntForFinish * nMasterBuyInFee;
      nAdditionalMoney := Trunc((aTournament.TotalPrize - nCntForFinish * nMasterBuyInFee) * 100) / 100;
    end else begin
      nCntForFinish := 1;
      nMasterMoney := aTournament.TotalPrize;
      nAdditionalMoney := 0;
    end;
  end;

  sAdditional := '';
  if (nAdditionalMoney > 0) then
    sAdditional :=
      '<place from="' + IntToStr(nCntForFinish + 1) + '" to="' + IntToStr(nCntForFinish + 1) + '" ' +
        'prizeRate="' + CurrToStr(nAdditionalMoney) + '" noncurrencyprize=""/>';

  FPrizePoolXML :=
    '<tournamentprize prizetype="' + IntToStr(FPrizeTypeID) + '" ' +
          'currencytype="' + IntToStr(aTournament.FCurrencyTypeID) + '" ' +
          'valuetype="' + IntToStr(prvTypeFixedValue)  + '">' +
      '<players from="' + IntToStr(aTournament.Entrants) + '" ' +
          'playersforfinish="' + IntToStr(nCntForFinish) + '">' +
        '<place from="1" to="' + IntToStr(nCntForFinish) + '" ' +
          'prizeRate="' + CurrToStr(nMasterMoney) + '" noncurrencyprize=""/>' +
        sAdditional +
      '</players>' +
    '</tournamentprize>';
end;

{ TtsTournament }

constructor TtsTournament.Create(nTournamentID: Integer; aOwner: TtsTournamentList);
begin
  inherited Create;
  FOwner := aOwner;
  //
  FTournamentID := nTournamentID;
  FActionDispatcherID := 1;
  //-------------------------------------------------------
  // Tournament context; EXTERNAL (sets on add in list)
  //-------------------------------------------------------
  FNextBreakTime := 0;
	FNextLevelTime := 0;
  FStartPauseByAdmin := 0;
  FNextAutosaveTime := IncMinute(Now, AUTOSAVEINTERVAL);
  FStartKickOffNotTakedSit := 0; // disabled
  FAddOnIsAllowed := False;
  FPauseCount := 0;
  //-------------------------------------------------------
  // Base tournament propeties
  //-------------------------------------------------------
  FStatusID := 1;
  FTournamentStatusID := tstAnnouncing;
  FPrevTournamentStatusID := 0;
	FTournamentLevel := 1;
  FHandForHandPlayers := 1;
  FRebuyIsAllowed := False;
  //-------------------------------------------------------
  // properties from GE for auto lost user detect
  //-------------------------------------------------------
  FStakeType := 1;
  FStakeName := '';
  FGameTypeName := '';
  //-------------------------------------------------------
  // List structure components
  //-------------------------------------------------------
  FActions   := TXMLRespActions.Create;
  FPrizes    := TpoTournPrizeRulesList.Create(FTournamentID);
  FBettings  := TpoTournBettingList.Create(Self);
  FPlayers   := TpoTournUserList.Create;
  FProcesses := TpoTournProcessList.Create(FTournamentID);
end;

destructor TtsTournament.Destroy;
begin
  FPrizes.Free;
  FBettings.Free;
  FPlayers.Free;
  Processes.Free;
  FActions.Free;

  inherited;
end;

procedure TtsTournament.GetDataFromNode(Node: IXMLNode);
begin

  try
    //-------------------------------------------------------
    // Tournament context; EXTERNAL (sets on add in list)
    //-------------------------------------------------------
    FTournamentID       := Node.Attributes['tournamentid'];
    FActionDispatcherID := Node.Attributes['actiondispatcherid'];
    FName               := Node.Attributes['name'];
    FMaxRegisteredLimit := Node.Attributes['maxregistered'];
    FGameEngineID       := Node.Attributes['gameengineid'];
    //-------------------------------------------------------
    // Base tournament event properties
    //-------------------------------------------------------
	  FRegistrationStartTime := Node.Attributes['registrationstarttime'];
  	FTournamentFinishTime  := StrToFloatDef(Node.Attributes['tournamentfinishtime'], 0);
	  FTournamentStartTime   := Node.Attributes['tournamentstarttime'];
	  FTournamentCategory    := Node.Attributes['category'];
    FTournamentStartEvent  := Node.Attributes['starteventid'];
  	FTournamentInterval    := Node.Attributes['tournamentinterval'];
	  FSittingDuration       := Node.Attributes['sittingduration'];
    // Level and Break event properties
  	FLevelInterval := Node.Attributes['levelinterval'];
	  FBreakInterval := Node.Attributes['breakinterval'];
  	FBreakDuration := Node.Attributes['breakduration'];
    if Node.HasAttribute('onkickoff') then
    	FTimeOutForKickOff := Node.Attributes['onkickoff']
    else
    	FTimeOutForKickOff := 0;
	  FNextBreakTime := StrToFloatDef(Node.Attributes['nextbreaktime'], 0);
  	FNextLevelTime := StrToFloatDef(Node.Attributes['nextleveltime'], 0);
    if Node.HasAttribute('startpausebyadmin') then
      FStartPauseByAdmin := StrToFloatDef(Node.Attributes['startpausebyadmin'], 0)
    else
      FStartPauseByAdmin := 0;
    if Node.HasAttribute('startkickoff') then
      FStartKickOffNotTakedSit := StrToFloatDef(Node.Attributes['startkickoff'], 0)
    else
      FStartKickOffNotTakedSit := 0;

    //-------------------------------------------------------
    // Base tournament propeties
    //-------------------------------------------------------
	  FStatusID            := Node.Attributes['statusid'];
  	FTournamentStatusID  := Node.Attributes['tournamentstatusid'];
    if Node.HasAttribute('prevtournstatusid') then
      FPrevTournamentStatusID := Node.Attributes['prevtournstatusid']
    else
      FPrevTournamentStatusID := 0;
	  FTournamentLevel     := Node.Attributes['tournamentlevel'];
  	FTournamentTypeID    := Node.Attributes['tournamenttypeid'];
	  FCurrencyTypeID      := Node.Attributes['currencytypeid'];
    FCurrencySign        := '';
    if Node.HasAttribute('currencysign') then
      FCurrencySign        := Node.Attributes['currencysign'];
    FCurrencyName        := '';
    if Node.HasAttribute('currencyname') then
      FCurrencyName        := Node.Attributes['currencyname'];
	  FBuyIn               := Node.Attributes['buyin'];
  	FFee                 := Node.Attributes['fee'];

    if Node.HasAttribute('rebuyisallowed') then
      FRebuyIsAllowed      := Boolean(StrToInt(Node.Attributes['rebuyisallowed']))
    else
      FRebuyIsAllowed      := False;
    if Node.HasAttribute('rebuyallowedoncreate') then
      FRebuyWasAllowedOnCreate := Boolean(StrToInt(Node.Attributes['rebuyallowedoncreate']))
    else
      FRebuyWasAllowedOnCreate := False;

    if Node.HasAttribute('addonisallowed') then
      FAddOnIsAllowed    := Boolean(StrToInt(Node.Attributes['addonisallowed']))
    else
      FAddOnIsAllowed    := False;
    if Node.HasAttribute('addonallowedoncreate') then
      FAddOnWasAllowedOnCreate := Boolean(StrToInt(Node.Attributes['addonallowedoncreate']))
    else
      FAddOnWasAllowedOnCreate := False;

    if Node.HasAttribute('rebuycount') then
      FMaximumRebuyCount   := Node.Attributes['rebuycount']
    else
      FMaximumRebuyCount   := 0;

    if Node.HasAttribute('pausecount') then
      FPauseCount   := Node.Attributes['pausecount']
    else
      FPauseCount   := 0;

	  FChips               := Node.Attributes['chips'];
//	  FNumberOfPlayersForFinish := Node.Attributes['numberofplayersforfinish'];
  	FPlayerPerTable      := Node.Attributes['playerpertable'];
  	FHandForHandPlayers  := Node.Attributes['handforhandplayers'];
    //-------------------------------------------------------
    // properties for satelite only
    //-------------------------------------------------------
  	FMasterTournamentID  := Node.Attributes['mastertournamentid'];
  	FMasterBuyIn         := Node.Attributes['masterbuyin'];
  	FMasterFee           := Node.Attributes['masterfee'];
    //-------------------------------------------------------
    // properties for restricted only
    //-------------------------------------------------------
    if Node.HasAttribute('password') then
      FPassword            := Node.Attributes['password']
    else
      FPassword            := '';
    //-------------------------------------------------------
    // properties from GE for auto lost user detect
    //-------------------------------------------------------
  	FStakeType     := Node.Attributes['staketype'];
    FStakeName     := Node.Attributes['stakename'];
    FGameTypeName  := Node.Attributes['gametypename'];
	  FInitialStake  := Node.Attributes['initialstake'];
  except
    on E: Exception do begin
      CommonDataModule.Log(ClassName, 'GetDataFromNode', '[EXCEPTION]: ' + E.Message, ltException);
    end;
  end;

end;

function TtsTournament.LoadFromDB(SQLAdapter: TSQLAdapter): Integer;
var
  Node: IXMLNode;
  sSQL, StrData: string;
  XML: IXMLDocument;
begin
{$IFDEF __TEST__}
	Result := 0;
  Exit;
{$ENDIF}

	Result := 0;

  // try to execute store procedure
  sSQL := 'exec srvtouGetTournamentContextXML ' + IntToStr(TournamentID);
  try
    StrData := SQLAdapter.ExecuteForXML(sSql);
  except on E: Exception do
    begin
      Result := TS_ERR_SQLERROR;
      LogException( '{8C916590-9B68-4E9A-A5AE-7AD0DF317ACD}',
        ClassName, 'LoadFromDB',
        E.Message + ': On Execute SQL=' + sSQL
      );
      Exit;
    end;
  end;

  if StrData = '' then
  begin
    LogException( '{81E173AA-49B1-488A-A065-8D6CB6A90859}',
      ClassName, 'LoadFromDB', 'SQL procedure: [' + sSQL + '] return empty result.'
    );

    Result := TS_ERR_SQLERROR;
    Exit;
  end;

  // XML Parcer
  try

    XML := TXMLDocument.Create(nil);
	  XML.XML.Text := StrData;
    XML.Active   := true;

   	Node := XML.DocumentElement;

    // tournament context from xml to data
    GetDataFromNode(Node);

    XML.Active := False;
    XML        := nil;

  except on E: Exception do
    begin
      Result := TS_ERR_XMLPARCEERROR;
      LogException( '{BE10F6D7-0E83-4694-8BD8-8552D1B098C4}',
        ClassName, 'LoadFromDB',
        'XML Parser error: ' + E.Message + ': XML=' + StrData
      );

      XML.Active := False;
      XML        := nil;
      Exit;
    end;
  end;

// load list components
//----------------------------------
  // try to load Bettings
  Bettings.LoadFromDB(TournamentID, SQLAdapter);
  // try to load Process list
  Processes.LoadFromDB(SQLAdapter);
  // try to load Players list
  Players.LoadFromDB(TournamentID, SQLAdapter);
  // try to load Prizes list
  Prizes.LoadFromDB(SQLAdapter);
  Prizes.LoadFromAdmSiteXML(Self);
//----------------------------------
end;

procedure TtsTournament.SetBreakDuration(const Value: Integer);
begin
  FBreakDuration := Value;
end;

procedure TtsTournament.SetBreakInterval(const Value: Integer);
begin
  FBreakInterval := Value;
end;

procedure TtsTournament.SetBuyIn(const Value: Currency);
begin
  FBuyIn := Value;
end;

procedure TtsTournament.SetChips(const Value: Currency);
begin
  FChips := Value;
end;

function TtsTournament.SetContextByObject(
  FromObj: TtsTournament): Integer;
var
  I: Integer;
begin
  //-------------------------------------------------------
  // Tournament context; EXTERNAL (sets on add in list)
  //-------------------------------------------------------
  //
  FActionDispatcherID := FromObj.FActionDispatcherID;
	FName := FromObj.FName;
	FGameEngineID := FromObj.FGameEngineID;
  //-------------------------------------------------------
  // Base tournament event properties
  //-------------------------------------------------------
  FMaxRegisteredLimit := FromObj.FMaxRegisteredLimit;
	FRegistrationStartTime := FromObj.FRegistrationStartTime;
  FTournamentCategory := FromObj.FTournamentCategory;
  FTournamentStartEvent := FromObj.FTournamentStartEvent;
	FTournamentFinishTime := FromObj.FTournamentFinishTime;
	FTournamentStartTime := FromObj.FTournamentStartTime;
  FTournamentStartEvent := FromObj.FTournamentStartEvent;
	FTournamentInterval := FromObj.FTournamentInterval;
	FSittingDuration := FromObj.FSittingDuration;
	FLevelInterval := FromObj.FLevelInterval;
	FBreakInterval := FromObj.FBreakInterval;
	FBreakDuration := FromObj.FBreakDuration;
  FTimeOutForKickOff := FromObj.FTimeOutForKickOff;
	FNextBreakTime := FromObj.FNextBreakTime;
	FNextLevelTime := FromObj.FNextLevelTime;
  FStartPauseByAdmin := FromObj.FStartPauseByAdmin;
  FStartKickOffNotTakedSit := FromObj.FStartKickOffNotTakedSit;

  //-------------------------------------------------------
  // Base tournament propeties
  //-------------------------------------------------------
	FStatusID := FromObj.FStatusID;
	FTournamentStatusID := FromObj.FTournamentStatusID;
  FPrevTournamentStatusID := FromObj.FPrevTournamentStatusID;

	FTournamentLevel := FromObj.FTournamentLevel;
	FTournamentTypeID := FromObj.FTournamentTypeID;
	FCurrencyTypeID := FromObj.FCurrencyTypeID;
  FCurrencySign := FromObj.FCurrencySign;
  FCurrencyName := FromObj.FCurrencyName;
	FBuyIn := FromObj.FBuyIn;
	FFee := FromObj.FFee;
  FRebuyIsAllowed := FromObj.FRebuyIsAllowed;
  FRebuyWasAllowedOnCreate := FromObj.FRebuyWasAllowedOnCreate;
  FAddOnIsAllowed := FromObj.FAddOnIsAllowed;
  FAddOnWasAllowedOnCreate := FromObj.FAddOnWasAllowedOnCreate;
  FMaximumRebuyCount := FromObj.FMaximumRebuyCount;
  FPauseCount := FromObj.FPauseCount;
	FChips := FromObj.FChips;
//	FNumberOfPlayersForFinish := FromObj.FNumberOfPlayersForFinish;
	FPlayerPerTable := FromObj.FPlayerPerTable;
	FHandForHandPlayers := FromObj.FHandForHandPlayers;
  //-------------------------------------------------------
  // properties for satelite only
  //-------------------------------------------------------
	FMasterTournamentID := FromObj.FMasterTournamentID;
 	FMasterBuyIn        := FromObj.FMasterBuyIn;
 	FMasterFee          := FromObj.FMasterFee;
  //-------------------------------------------------------
  // properties for restricted only
  //-------------------------------------------------------
  FPassword           := FromObj.FPassword;
  //-------------------------------------------------------
  // properties from GE for auto lost user detect
  //-------------------------------------------------------
	FStakeType := FromObj.FStakeType;
  FStakeName := FromObj.FStakeName;
  FGameTypeName := FromObj.FGameTypeName;
	FInitialStake := FromObj.FInitialStake;

  //-------------------------------------------------------
  // List structure components
  //-------------------------------------------------------
  FPrizes.SetContextByObject(FromObj.FPrizes);
  FBettings.SetContextByObject(FromObj.FBettings);
  FPlayers.SetContextByObject(FromObj.FPlayers);
  FProcesses.SetContextByObject(FromObj.FProcesses);
  // set level for processes
  for I:= 0 to FProcesses.Count -1 do
    FProcesses.Items[I].FLevel := FTournamentLevel;

  // Tread (actions) context
  Result := FActions.SetContextByObject(FromObj.FActions);
  // as property at last
  TournamentID := FromObj.FTournamentID;
  //
  if Result <> 0 then begin
    CommonDataModule.Log(ClassName, 'SetContextByObject',
      '[ERROR] Actions.SetContextByObject return result=' + IntToStr(Result) +
        '; Params: TournamentID=' + IntToStr(FromObj.TournamentID),
      ltCall);

    Exit;
  end;

  Result := 0;

end;

procedure TtsTournament.SetCurrencyTypeID(const Value: Integer);
begin
  FCurrencyTypeID := Value;
end;

procedure TtsTournament.SetFee(const Value: Currency);
begin
  FFee := Value;
end;

procedure TtsTournament.SetGameEngineID(const Value: Integer);
begin
  FGameEngineID := Value;
end;

procedure TtsTournament.SetHandForHandPlayers(const Value: Integer);
begin
  FHandForHandPlayers := Value;
end;

procedure TtsTournament.SetInitialStake(const Value: Currency);
begin
  FInitialStake := Value;
end;

procedure TtsTournament.SetLevelInterval(const Value: Integer);
begin
  FLevelInterval := Value;
end;

procedure TtsTournament.SetMasterTournamentID(const Value: Integer);
begin
  FMasterTournamentID := Value;
end;

procedure TtsTournament.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TtsTournament.SetNextBreakTime(const Value: TDateTime);
begin
  FNextBreakTime := Value;
end;

procedure TtsTournament.SetNextLevelTime(const Value: TDateTime);
begin
  FNextLevelTime := Value;
end;

procedure TtsTournament.SetPlayerPerTable(const Value: Integer);
begin
  FPlayerPerTable := Value;
end;

procedure TtsTournament.SetRegistrationStartTime(const Value: TDateTime);
begin
  FRegistrationStartTime := Value;
end;

procedure TtsTournament.SetSittingDuration(const Value: Integer);
begin
  FSittingDuration := Value;
end;

procedure TtsTournament.SetStakeType(const Value: Integer);
begin
  FStakeType := Value;
end;

procedure TtsTournament.SetStatusID(const Value: Integer);
begin
  FStatusID := Value;
end;

procedure TtsTournament.SetTournamentFinishTime(const Value: TDateTime);
begin
  FTournamentFinishTime := Value;
end;

procedure TtsTournament.SetTournamentID(const Value: Integer);
var
  I: Integer;
begin
  FTournamentID := Value;
  if FPrizes <> nil then FPrizes.FTournamentID := FTournamentID;
  if FProcesses <> nil then FProcesses.FTournamentID := FTournamentID;
  for I:=0 to FProcesses.Count - 1 do FProcesses.Items[I].FTournamentID := FTournamentID;
end;

procedure TtsTournament.SetTournamentInterval(const Value: Integer);
begin
  FTournamentInterval := Value;
end;

procedure TtsTournament.SetTournamentLevel(const Value: Integer);
begin
  FTournamentLevel := Value;
end;

procedure TtsTournament.SetTournamentStartTime(const Value: TDateTime);
begin
  FTournamentStartTime := Value;
end;

procedure TtsTournament.SetTournamentStatusID(const Value: Integer);
begin
  FTournamentStatusID := Value;
end;

procedure TtsTournament.SetTournamentTypeID(const Value: Integer);
begin
  FTournamentTypeID := Value;
end;

function TtsTournament.StoreToDB(SQLAdapter: TSQLAdapter): Integer;
var
  CurrentValuesXML: string;
begin
{$IFDEF __TEST__}
	Result := 0;
  Exit;
{$ENDIF}

  FNextAutosaveTime := IncMinute(Now, AUTOSAVEINTERVAL);
  CurrentValuesXML := GetCurrentValuesXML;

  try

    SQLAdapter.SetProcName('srvtouSetTournamentCurrentValuesXML');
    SQLAdapter.AddParInt('RETURN_VALUE',0,ptResult);
    SQLAdapter.AddParInt('TournamentID', FTournamentID, ptInput);
    SQLAdapter.AddParInt('StatusID', FStatusID, ptInput);
    SQLAdapter.AddParString('CurrentValuesXML', CurrentValuesXML, ptInput);

    SQLAdapter.ExecuteCommand;

    Result := SQLAdapter.GetParam('RETURN_VALUE');

    if (Result <> 0) then begin
      LogException( '{211C8013-73A7-445E-B0B4-B85B69239E93}',
        ClassName, 'StoreToDB',
        'SQL result = ' + IntToStr(Result) + '; Params: TournamentId = ' + IntToStr(TournamentID)
      );
    end;

  except on E: Exception do
    begin
      Result := TS_ERR_SQLERROR;
      LogException( '{87A638AA-E69E-417E-B7D7-9244F6A0BD9A}',
        ClassName, 'StoreToDB',
        'SQL: srvtouSetTournamentXML raise exception: ' + E.Message +
        '; Params: TournamentId = ' + IntToStr(FTournamentID)
      );

      Exit;
    end;
  end;

  // Store additional data for AdminSite
  try
    SQLAdapter.SetProcName('srvtouSetTournamentAdminSiteContext');
    SQLAdapter.AddParInt('RETURN_VALUE',0,ptResult);
    SQLAdapter.AddParInt('TournamentID', FTournamentID, ptInput);
    SQLAdapter.AddParInt('MasterTournamentID', FMasterTournamentID, ptInput);
    SQLAdapter.AddParam('MasterBuyIn', FMasterBuyIn, ptInput, ftCurrency);
    SQLAdapter.AddParam('MasterFee', FMasterFee, ptInput, ftCurrency);
    SQLAdapter.AddParInt('GameEngineID', FGameEngineID, ptInput);
    SQLAdapter.AddParString('Name', FName, ptInput);
    SQLAdapter.AddParInt('TournamentTypeID', FTournamentTypeID, ptInput);
    SQLAdapter.AddParString('TournamentStartTime', DateTimeToODBCStr(FTournamentStartTime), ptInput);
    SQLAdapter.AddParString('TournamentFinishTime', DateTimeToODBCStr(FTournamentFinishTime), ptInput);
    SQLAdapter.AddParam('TotalPrize', Self.TotalPrize, ptInput, ftCurrency);
    SQLAdapter.AddParInt('TournamentLevel', FTournamentLevel, ptInput);
    SQLAdapter.AddParInt('TournamentStatusID', FTournamentStatusID, ptInput);
    SQLAdapter.AddParInt('CountPrizes', FPrizes.Count, ptInput);
    SQLAdapter.AddParam('TotalFee', Self.TotalFee, ptInput, ftCurrency);
    SQLAdapter.AddParInt('CurrencyTypeID', FCurrencyTypeID, ptInput);
    SQLAdapter.AddParInt('MaxRegisteredGamers', FMaxRegisteredLimit, ptInput);
    SQLAdapter.AddParInt('ActionDispatcherID', FActionDispatcherID, ptInput);
    SQLAdapter.AddParInt('CategoryTypeID', FTournamentCategory, ptInput);

    SQLAdapter.ExecuteCommand;

    Result := SQLAdapter.GetParam('RETURN_VALUE');

    if (Result <> 0) then begin
      LogException( '{211C8013-73A7-445E-B0B4-B85B69239E93}',
        ClassName, 'StoreToDB [srvtouSetTournamentAdminSiteContext]',
        'SQL result = ' + IntToStr(Result) + '; Params: TournamentId = ' + IntToStr(TournamentID)
      );
    end;

  except on E: Exception do
    begin
      Result := TS_ERR_SQLERROR;
      LogException( '{87A638AA-E69E-417E-B7D7-9244F6A0BD9A}',
        ClassName, 'StoreToDB [srvtouSetTournamentAdminSiteContext]',
        'SQL: srvtouSetTournamentAdminSiteContext raise exception: ' + E.Message +
        '; Params: TournamentId = ' + IntToStr(FTournamentID)
      );

      Exit;
    end;
  end;

//---------------------------------
  // Store list structure
  // Prizes & Bettings update only on registration tournament or special commands

  Result := Result + Processes.StoreToDB(SQLAdapter);
  Result := Result + Players.StoreToDB(FTournamentID, SQLAdapter);
//---------------------------------

end;

function TtsTournament.GetCurrentValuesXML: string;
begin

  Result :=
    '<ttstournament ' +
      'tournamentid="' + IntToStr(FTournamentID) + '" ' +
      'actiondispatcherid="' + IntToStr(FActionDispatcherID) + '" ' +
  	  'name="' + FName + '" ' +
      'maxregistered="' + IntToStr(FMaxRegisteredLimit) + '" ' +
	    'gameengineid="' + IntToStr(FGameEngineID) + '" ' +
  	  'registrationstarttime="' + FloatToStr(FRegistrationStartTime) + '" ' +
  	  'tournamentfinishtime="' + FloatToStr(FTournamentFinishTime) + '" ' +
  	  'tournamentstarttime="' + FloatToStr(FTournamentStartTime) + '" ' +
      'category="' + IntToStr(FTournamentCategory) + '" ' +
      'starteventid="' + IntToStr(FTournamentStartEvent) + '" ' +
  	  'tournamentinterval="' + IntToStr(FTournamentInterval) + '" ' +
  	  'sittingduration="' + IntToStr(FSittingDuration) + '" ' +
  	  'levelinterval="' + IntToStr(FLevelInterval) + '" ' +
  	  'breakinterval="' + IntToStr(FBreakInterval) + '" ' +
  	  'breakduration="' + IntToStr(FBreakDuration) + '" ' +
  	  'onkickoff="' + IntToStr(FTimeOutForKickOff) + '" ' +
  	  'nextbreaktime="' + FloatToStr(FNextBreakTime) + '" ' +
  	  'nextleveltime="' + FloatToStr(FNextLevelTime) + '" ' +
  	  'startpausebyadmin="' + FloatToStr(FStartPauseByAdmin) + '" ' +
  	  'startkickoff="' + FloatToStr(FStartKickOffNotTakedSit) + '" ' +
  	  'statusid="' + IntToStr(FStatusID) + '" ' +
  	  'tournamentstatusid="' + IntToStr(FTournamentStatusID) + '" ' +
  	  'prevtournstatusid="' + IntToStr(FPrevTournamentStatusID) + '" ' +
  	  'tournamentlevel="' + IntToStr(FTournamentLevel) + '" ' +
  	  'tournamenttypeid="' + IntToStr(FTournamentTypeID) + '" ' +
  	  'mastertournamentid="' + IntToStr(FMasterTournamentID) + '" ' +
      'password="' + FPassword + '" ' +
  	  'masterbuyin="' + FloatToStr(FMasterBuyIn) + '" ' +
  	  'masterfee="' + FloatToStr(FMasterFee) + '" ' +
  	  'currencytypeid="' + IntToStr(FCurrencyTypeID) + '" ' +
  	  'currencysign="' + FCurrencySign + '" ' +
  	  'currencyname="' + FCurrencyName + '" ' +
  	  'buyin="' + FloatToStr(FBuyIn) + '" ' +
  	  'fee="' + FloatToStr(FFee) + '" ' +
      'rebuyisallowed="' + IntToStr(Integer(RebuyIsAllowed)) + '" ' +
      'rebuyallowedoncreate="' + IntToStr(Integer(FRebuyWasAllowedOnCreate)) + '" ' +
      'addonisallowed="' + IntToStr(Integer(AddOnIsAllowed)) + '" ' +
      'addonallowedoncreate="' + IntToStr(Integer(FAddOnWasAllowedOnCreate)) + '" ' +
      'rebuycount="' + IntToStr(MaximumRebuyCount) + '" ' +
      'pausecount="' + IntToStr(FPauseCount) + '" ' +
  	  'chips="' + FloatToStr(FChips) + '" ' +
  	  'playerpertable="' + IntToStr(FPlayerPerTable) + '" ' +
  	  'handforhandplayers="' + IntToStr(FHandForHandPlayers) + '" ' +
  	  'staketype="' + IntToStr(FStakeType) + '" ' +
      'stakename="' + FStakeName + '" ' +
      'gametypename="' + FGameTypeName + '" ' +
  	  'initialstake="' + FloatToStr(FInitialStake) + '" ' +
    '/>';

end;

procedure TtsTournament.SetStakeName(const Value: string);
begin
  FStakeName := Value;
end;

function TtsTournament.LOBBY_toGetInfo: string;
begin
//----------------------
// Used Notification
//----------------------

  // open root <object> and <togetinfo>
  Result :=
//      '<object name="' + APP_TOURNAMENT + '" id="0">' +
        '<togetinfo ' +
              'result="0" tournamentid="' + IntToStr(FTournamentID) + '" ' +
              'type="' + IntToStr(FTournamentTypeID) + '" ' +
              'state="' + IntToStr(FTournamentStatusID) + '" ' +
              'currencytypeid="' + IntToStr(FCurrencyTypeID) + '" ' +
              'buyin="' + FloatToStrF(FBuyIn, ffFixed, 12, 2) + '" ' +
              'fee="' + FloatToStrF(FFee, ffFixed, 12, 2) + '" ' +
              'rebuyallowed="' + IntToStr(Integer(FRebuyIsAllowed)) + '" ' +
              'addonallowed="' + IntToStr(Integer(FAddOnIsAllowed)) + '" ' +
              'rebuycount="' + IntToStr(FMaximumRebuyCount) + '">';
  Result := Result + LOBBY_toGetInfo_Base;
  Result := Result + LOBBY_toGetInfo_PrizeRules;
  Result := Result + LOBBY_toGetInfo_Advanced;
  Result := Result + LOBBY_toGetInfo_PrizePool;

  // close  <object> and <togetinfo>
  Result := Result + '</togetinfo>';
//  </object>';

end;

function TtsTournament.LOBBY_toGetLevelsInfo: string;
begin
  Result :=
//    '<object name="' + APP_TOURNAMENT + '" id="0">' +
      '<togetlevelsinfo ' +
         'result="0" tournamentid="' + IntToStr(FTournamentID) + '" ' +
          'startingchips="'+ CurrToStr(FChips) +'">';

  Result := Result +
    '<levels>' +
      FBettings.GetStakeInfo(FTournamentLevel, FLevelInterval, True) +
    '</levels>';

  Result := Result +
    '<prizes>' +
      FPrizes.GetDataPrizePool_ToLobby(TotalPrize,true) +
    '</prizes>';

  Result := Result +
      '</togetlevelsinfo>';
//    '</object>';
end;

procedure TtsTournament.SetGameTypeName(const Value: string);
begin
  FGameTypeName := Value;
end;

function TtsTournament.GetIsAnnouncing: Boolean;
begin
  Result := ( (FTournamentStatusID and $F) = tstAnnouncing ) and (not IsPauseByAdmin);
end;

function TtsTournament.GetIsBreak: Boolean;
begin
  Result := ( (FTournamentStatusID and $F) = tstBreak ) and (not IsPauseByAdmin);
end;

function TtsTournament.GetIsPauseByAdmin: Boolean;
begin
  Result := ( (FTournamentStatusID and $F0) = tstAdminPause);
end;

function TtsTournament.GetIsCompleted: Boolean;
begin
  Result := ( (FTournamentStatusID and $F) = tstCompleted );
end;

function TtsTournament.GetIsStopped: Boolean;
begin
  Result := ( (FTournamentStatusID and $F) = tstStopped );
end;

function TtsTournament.GetIsRegistration: Boolean;
begin
  Result := ( (FTournamentStatusID and $F) = tstRegistration ) and (not IsPauseByAdmin);
end;

function TtsTournament.GetIsResuming: Boolean;
begin
  Result := ( (FTournamentStatusID and $F0) = tstResuming );
end;

function TtsTournament.GetIsNoEntrants: Boolean;
begin
  Result := ( (FTournamentStatusID and $F00) = tstNoEntrants );
end;

function TtsTournament.GetIsRunning: Boolean;
begin
  Result := ( (FTournamentStatusID and $F) = tstRunning ) and (not IsPauseByAdmin);
end;

function TtsTournament.GetIsSitting: Boolean;
begin
  Result := ( (FTournamentStatusID and $F) = tstSitting ) and (not IsPauseByAdmin);
end;

function TtsTournament.GetNameOfState: string;
begin
  Result := '';
  if Self.IsAnnouncing   then Result := 'Announced' else
  if Self.IsRegistration then Result := 'Registering' else
  if Self.IsSitting      then Result := 'Closed' else
  if Self.IsRunning      then Result := 'Running' else
  if Self.IsBreak        then Result := 'Break started' else
  if Self.IsPauseByAdmin then Result := 'Pause by admin' else
  if Self.IsCompleted    then Result := 'Completed';
  if Self.IsStopped      then Result := 'Stopped';
end;

procedure TtsTournament.SetMasterBuyIn(const Value: Currency);
begin
  FMasterBuyIn := Value;
end;

procedure TtsTournament.SetMasterFee(const Value: Currency);
begin
  FMasterFee := Value;
end;

function TtsTournament.LOBBY_toGetInfo_Advanced: string;
var
  sText: string;
begin

  // open root node
  Result := '<advanced>';

  if Self.IsPauseByAdmin then begin
    // About registration start time data
    sText := 'Pause by admin.';
    Result := Result + '<data value="' + sText + '"/>';
  end;

  if Self.IsSitAndGO then begin
    sText := 'Sit and Go';
    Result := Result + '<data value="' + sText + '"/>';
  end;

  if Self.IsAnnouncing then begin
    // About registration start time data
    DateTimeToString(sText, 'mmmm	d, yyyy	h:nn am/pm', FRegistrationStartTime);
    sText := 'Registration will start: ' + sText + #13#10 +
      ' (' + GetDiffTime(FRegistrationStartTime) + ')';

    Result := Result + '<data value="' + sText + '"/>';
  end;

  if (not Self.IsCompleted) and (not Self.IsRunning) and
     (not Self.IsBreak)     and (not Self.IsStopped) then begin
    // About tournament start time data
    if Self.IsSitAndGO and (FMaxRegisteredLimit > Players.Count) then begin
      sText := 'Tournay will start:' + #13#10 +
        'when ' + IntToStr(FMaxRegisteredLimit - Players.Count) + ' players register';
    end else begin
    DateTimeToString(sText, 'mmmm	d, yyyy	h:nn am/pm', FTournamentStartTime);
    sText := 'Tournament will start: ' + sText + #13#10 +
      ' (' + GetDiffTime(FTournamentStartTime) + ')';
  end;
  Result := Result + '<data value="' + sText + '"/>';
  end else begin
    // About tournament start time data
    DateTimeToString(sText, 'mmmm	d, yyyy	h:nn am/pm', FTournamentStartTime);
    sText := 'Tournament started: ' + sText;

    Result := Result + '<data value="' + sText + '"/>';
  end;

  if Self.IsAnnouncing or Self.IsRegistration then begin
    // About sitting lost time data
    sText := 'Seats will be available : ' + IntToStr(FSittingDuration) + ' min before tournament begins';

    Result := Result + '<data value="' + sText + '"/>';
  end;

  if Self.IsRegistration or Self.IsSitting then begin
    // About currently registered players data
    sText := '# of Currently registered players: ' + IntToStr(Entrants);

    Result := Result + '<data value="' + sText + '"/>';
  end;

  if Self.IsRunning or Self.IsBreak then begin
    // About next breack data
    if not Self.IsBreak then begin
      sText := 'Next break in: ' + GetNextTimeEvent(FNextBreakTime);
    end else begin
      DateTimeToString(sText, 'mmmm	d, yyyy	h:nn am/pm', FNextBreakTime);
      sText := 'Break started at: ' + sText;
    end;
    Result := Result + '<data value="' + sText + '"/>';

    // About level data
    sText := 'Level ' + IntToStr(FTournamentLevel) + ' : ' + FBettings.GetStakeInfo(FTournamentLevel, FLevelInterval, False);
    Result := Result + '<data value="' + sText + '"/>';

    // About Next level data
    sText := 'Next level in ' + GetNextTimeEvent(FNextLevelTime) + ' : ' + FBettings.GetStakeInfo(FTournamentLevel+1, FLevelInterval, False);
    Result := Result + '<data value="' + sText + '"/>';

    // About players data
    sText := IntToStr(Entrants) + ' entrants, currently ' + IntToStr(ActivePlayers) + ' player';
    if ActivePlayers > 1 then sText := sText + 's';
    sText := sText + ' on ' + IntToStr(ActiveProcesses) + ' table';
    if ActiveProcesses > 1 then sText := sText + 's';
    Result := Result + '<data value="' + sText + '"/>';

    // About stats data
    sText :=
      'Stacks : ' +
        FloatToStrF(LargestStack, ffFixed, 12, 2) + ' - largest,' +
//        FloatToStrF(AverageStack, ffFixed, 12, 2) + ' - average, ' +
        FloatToStrF(SmallestStack, ffFixed, 12, 2) + ' - smallest';
    Result := Result + '<data value="' + sText + '"/>';
  end;

  if Self.IsCompleted then begin
    // About finish tournamnt data
    DateTimeToString(sText, 'mmmm	d, yyyy	h:nn am/pm', FTournamentFinishTime);
    sText := 'Tournament ended: ' + sText;
    Result := Result + '<data value="' + sText + '"/>';

    // About Entrants data
    sText := IntToStr(Entrants) + ' entrants';
    Result := Result + '<data value="' + sText + '"/>';
    if Self.IsNoEntrants then begin
      sText := 'There were no entrants for start.';
      Result := Result + '<data value="' + sText + '"/>';
      sText := 'All the money was returned.';
      Result := Result + '<data value="' + sText + '"/>';
    end;
  end;

  if Self.IsStopped then begin
    // About stopped tournamnt data
    DateTimeToString(sText, 'mmmm	d, yyyy	h:nn am/pm', FTournamentFinishTime);
    sText := 'Tournament stopped: ' + sText;
    Result := Result + '<data value="' + sText + '"/>';
    sText := 'By technical reason.';
    Result := Result + '<data value="' + sText + '"/>';
    sText := 'All the money was returned.';
    Result := Result + '<data value="' + sText + '"/>';
    sText := 'We appologize for inconvinience.';
    Result := Result + '<data value="' + sText + '"/>';

    // About Entrants data
    sText := IntToStr(Entrants) + ' entrants';
    Result := Result + '<data value="' + sText + '"/>';
  end;

  // close root node
  Result := Result + '</advanced>';

end;

procedure TtsTournament.SetPlayers(const Value: TpoTournUserList);
begin
  FPlayers := Value;
end;

procedure TtsTournament.SetPrizes(const Value: TpoTournPrizeRulesList);
begin
  FPrizes := Value;
end;

procedure TtsTournament.SetProcesses(const Value: TpoTournProcessList);
begin
  FProcesses := Value;
end;

function TtsTournament.GetEntrants: Integer;
begin
  Result := Players.Count;
end;

function TtsTournament.GetTotalPrize: Currency;
begin
  Result := FBuyIn * FPlayers.BuyInCount;
end;

function TtsTournament.GetTotalFee: Currency;
begin
  Result := FFee * Entrants;
end;

function TtsTournament.GetAverageStack: Currency;
begin
  Result := Processes.AverageStack;
end;

function TtsTournament.GetLargestStack: Currency;
begin
  Result := Processes.LargestStack;
end;

function TtsTournament.GetSmallestStack: Currency;
begin
  Result := Processes.SmallestStack;
end;

function TtsTournament.GetActivePlayers: Integer;
begin
  Result := Players.ActiveCount;
end;

function TtsTournament.GetActiveProcesses: Integer;
begin
  Result := Processes.ActiveCount;
end;

function TtsTournament.GetOptimalMinPlayersPerTable: Integer;
var
  CntOptTables: Integer;
  CntActivePl: Integer;
begin
  CntOptTables := OptimalTables;
  CntActivePl  := ActivePlayers;
  Result := CntActivePl div CntOptTables;
end;

function TtsTournament.GetOptimalMaxPlayersPerTable: Integer;
var
  CntOptTables: Integer;
  CntActivePl: Integer;
begin
  CntOptTables := OptimalTables;
  CntActivePl  := ActivePlayers;
  Result := CntActivePl div CntOptTables;;
  if (Result * CntOptTables) < CntActivePl then Inc(Result);
end;

function TtsTournament.GetIsHandForHand: Boolean;
var
  I, ActCnt: Integer;
  aPrize: TpoTournPrizeRate;
  aPrizeRateBase: TpoTournPrizeRateList;
begin
  Result := False;
  if (Processes.Count <= 1) then Exit;
  if (Processes.WatingCount <= 0) then Exit;

  if (FPrizes.Count <= 0) then begin
    FPrizes.Add('Default Prize', '$', 'Dollars').SetDefault;
  end;
  aPrizeRateBase := FPrizes.Items[0];
  if (aPrizeRateBase.Count  + FHandForHandPlayers) <= FPlayerPerTable then Exit;

  ActCnt := Players.ActiveCount;
  for I:=(aPrizeRateBase.Count-1) downto 0 do begin
    aPrize := aPrizeRateBase.Items[I];
    if aPrize.FIsHandForHand then begin
      if (ActCnt > aPrize.FPlace) and (ActCnt <= (aPrize.FPlace + FHandForHandPlayers))
      then begin
        Result := True;
        Exit;
      end;
    end;
  end;

end;

function TtsTournament.GetStake: Currency;
begin
  Result := FBettings.Stake[FTournamentLevel];
end;

function TtsTournament.GetNextBreakEndTime: TDateTime;
begin
  Result := IncMinute(FNextBreakTime, BreakDuration);
end;

function TtsTournament.GetOptimalRestPlayersPerTable(RestCountTables,
  RestCountPlayers: Integer): Integer;
begin
  if RestCountTables <= 0 then begin
    Result := 0;
    Exit;
  end;
  Result := RestCountPlayers div RestCountTables;
  if (Result * RestCountTables) < RestCountPlayers then Inc(Result);
end;

function TtsTournament.GetOptimalTables: Integer;
var
  CntActivePl: Integer;
begin
  CntActivePl := ActivePlayers;
  Result := CntActivePl div FPlayerPerTable;
  if (CntActivePl - (Result*FPlayerPerTable)) > 0 then Inc(Result);
end;

function TtsTournament.LOBBY_toGetInfo_Base: string;
var
  sNameTourn, sNameProc, sNameRebuy, sNameAddOn: string;
  sCurrSign: string;
begin
  // set name attribute of tournament
  if Name = '' then begin
    sNameTourn := 'Tournament #' + IntToStr(FTournamentID);
    if FTournamentTypeID = ttpSattelite then
      sNameTourn := sNameTourn + ' satellite to ' + IntToStr(FMasterTournamentID);
  end
  else sNameTourn := Name;

  if FPrizes.Count > 0 then sCurrSign := FPrizes.Items[0].FCurrencySign;
  // set name attribute of process
  sNameProc := FStakeName + ' ' + FGameTypeName + #13#10 +
    'Buy-In: ' + CurrencySign + FloatToStrF(FBuyIn, ffFixed, 12, 2) +
    '+' +
    CurrencySign + FloatToStrF(FFee, ffFixed, 12, 2);

  sNameRebuy := '';
  if FRebuyIsAllowed then begin
    if (MaximumRebuyCount = 0) then
      sNameRebuy := 'Allowed no limit rebuy'
    else
      sNameRebuy := 'Allowed maximum ' + IntToStr(FMaximumRebuyCount) + ' of rebuy';
  end;

  sNameAddOn := '';
  if FAddOnWasAllowedOnCreate then
    sNameAddOn := 'Add-On is allowed';

  // open root node base
  Result := '<base>';
  Result := Result + '<data value="' + XMLSafeEncode(sNameTourn) + '"/>';
  Result := Result + '<data value="' + XMLSafeEncode(sNameProc) + '"/>';
  Result := Result + '<data value="' + XMLSafeEncode(sNameRebuy) + '"/>';
  Result := Result + '<data value="' + XMLSafeEncode(sNameAddOn) + '"/>';
  Result := Result + '<data value="' + XMLSafeEncode(NameOfState) + '"/>';
  // close root
  Result := Result + '</base>';

end;

function TtsTournament.LOBBY_toGetInfo_PrizeRules: string;
begin

  // open root prizerules
  Result := '<prizerules>';

  Result := Result + '<data value="The prize pool structure has been modified."/>';
  Result := Result + '<data value="Click the ''Tournament info'' button to view detailed info."/>';
  Result := Result + '<data value=""/>';
  Result := Result + '<data value="Good luck!"/>';

  // close root prizerules
  Result := Result + '</prizerules>';

end;

function TtsTournament.LOBBY_toGetInfo_PrizePool: string;
var
  aPrizeBase: TpoTournPrizeRateList;
begin
  if (FPrizes.Count <= 0) then FPrizes.Add('Default Prize', '$', 'Dollars').SetDefault;
  aPrizeBase := FPrizes.Items[0];
  // open Root prizepool
  Result := '<prizepool pot="' + CurrencySign +
    FloatToStrF(TotalPrize, ffFixed, 12, 2) + '" ' +
    'winnerscount="' + IntToStr(aPrizeBase.Count) + '">';

  if Self.IsAnnouncing or Self.IsRegistration then begin
    Result := Result + '<data value="Registration was not ended."/>';
    Result := Result + '<data value="Distribution of prizes varies dynamically."/>';
    // refresh Prizes
    FPrizes.LoadFromAdmSiteXML(Self);
  end;

  Result := Result + FPrizes.GetDataPrizePool_ToLobby(TotalPrize);

  // close Root prizepool
  Result := Result + '</prizepool>';

end;

function TtsTournament.LOBBY_toGetPlayers: string;
begin
  Result :=
//    '<object name="' + APP_TOURNAMENT + '" id="0">' +
      '<togetplayers tournamentid="' + IntToStr(FTournamentID) + '" result="0">' +
        toGetPlayers_LOBBY_XML +
      '</togetplayers>';
//    '</object>';
end;

function TtsTournament.LOBBY_toGetProcesses: string;
begin
  Result :=
//    '<object name="' + APP_TOURNAMENT + '" id="0">' +
      '<togetprocesses tournamentid="' + IntToStr(FTournamentID) + '" result="0">' +
        Processes.toGetProcesses_LOBBY_XML(Players, FActionDispatcherID) +
      '</togetprocesses>';
//    '</object>';
end;

function TtsTournament.LOBBY_toGetProcessPlayers(nProcID: Integer): string;
begin
  Result :=
    '<object name="' + APP_TOURNAMENT + '" id="0">' +
      '<togetprocessplayers tournamentid="' + IntToStr(FTournamentID) + '" processid="' + IntToStr(nProcID) + '" result="0">' +
        toGetProcessPlayers_LOBBY_XML(nProcID) +
      '</togetprocessplayers>' +
    '</object>';
end;


function TtsTournament.LOBBY_toGetTournamentInfo: string;
var
  sName: string;
begin
//////////////////////////////////////////////////////
// WARNING: Is not XML;  Result is a list of nodes
// Must be plased into paren node
//////////////////////////////////////////////////////

  Result := '';

  if Self.IsPauseByAdmin then
  begin
    Result := Result + '<data value="Pause by admin."/>';
  end
  else if (Self.IsAnnouncing or Self.IsRegistration or Self.IsSitting) then
  begin
    if Self.IsSitAndGO and (FMaxRegisteredLimit > Entrants) then begin
      Result := Result + '<data value="Sit and Go"/>';
      Result := Result + '<data value="Seats will be available:"/>';
      Result := Result + '<data value="when ' + IntToStr(FMaxRegisteredLimit - Entrants) + ' players"/>';
      Result := Result + '<data value="will be registered"/>';
    end else begin
      Result := Result + '<data value="Tournament Starts"/>';
    DateTimeToString(sName, 'dddd', FTournamentStartTime);
    Result := Result + '<data value="On ' + sName + '"/>';

    DateTimeToString(sName, 'mmmm dd yyyy hh:nn am/pm', FTournamentStartTime);
    Result := Result + '<data value="' + sName + '"/>'; //' ET"/>';

    sName := GetStrBetweenDateTime(Now, FTournamentStartTime);
    if sName <> '' then
      Result := Result + '<data value="( in ' + sName + ' )"/>';
  end;

    if Self.IsRegistration then begin
      Result := Result + '<data value=" "/>';
      Result := Result + '<data value="Open for registration"/>';
    end;
  end
  else if Self.IsRunning or Self.IsBreak then begin
    Result := Result + '<data value="Tournament Started:"/>';

    DateTimeToString(sName, 'dddd', FTournamentStartTime);
    Result := Result + '<data value="On ' + sName + '"/>';

    DateTimeToString(sName, 'mmmm dd yyyy hh:nn am/pm', FTournamentStartTime);
    Result := Result + '<data value="' + sName + '"/>'; //' CST"/>';
    Result := Result + '<data value="Running:"/>';

    sName := GetStrBetweenDateTime(FTournamentStartTime, Now);
    if sName <> '' then
      Result := Result + '<data value="' + sName + '"/>';

    Result := Result + '<data value="Registration closed."/>';
  end
  else if Self.IsCompleted then begin
    Result := Result + '<data value="Tournament completed."/>';
    Result := Result + '<data value="See tournament lobby"/>';
    Result := Result + '<data value="for more detail"/>';
    Result := Result + '<data value="Players: '+IntToStr(Players.Count)+'"/>';
    Result := Result + '<data value="Good Luck!"/>';
  end;
end;

function TtsTournament.CheckOnTimeEvent(aActions: TXMLRespActions): Integer;
var
  aNow: TDateTime;
  I: Integer;
  aPrc: TpoTournProcess;
  FSQL: TSQLAdapter;
begin
  aNow := Now;

  Result := 0;

  if Self.IsCompleted or Self.IsStopped then begin
    Exit;
  end;

  if not Self.IsPauseByAdmin then begin
    // check on tournament start Registration event
    if Self.IsAnnouncing then begin
      if FRegistrationStartTime <= aNow then begin
        StartRegistration(aActions);
      end;
    end;

    // check on tournament start Sitting event
    if Self.IsRegistration then begin
      if (FTournamentStartEvent = tseByEnroled) and
         Self.IsSitAndGO and
         (FMaxRegisteredLimit > Self.Entrants)
      then Exit;

      if IncMinute(FTournamentStartTime, -SittingDuration) <= aNow then begin
        StartSitting(aActions);
      end;
    end;

    // check on tournament start Running event
    if Self.IsSitting then begin
      if FTournamentStartTime <= aNow then begin
        StartRunning(aActions);
      end;
    end;

    if Self.IsRunning or Self.IsBreak then begin
      // check on tournament start Break event
      if not Self.IsBreak then begin
        if FNextBreakTime <= aNow then StartBreak;
      end;

      // check on tournament start Level event
      if FNextLevelTime <= aNow then begin
        if Self.IsBreak then begin //shift levelup on breakduration
          FNextLevelTime := IncMinute(aNow, FBreakDuration);
        end else begin
          FNextLevelTime := IncMinute(aNow, FLevelInterval);
          Inc(FTournamentLevel);
        end;
      end;
    end;

    // check on tournament end Break event
    if Self.IsBreak then begin
      if Self.NextBreakEndTime <= aNow then begin
        StartBreakEnd(aActions);
      end;
    end else begin
{$IFNDEF __TEST__}
      if Self.IsStartKickingOff then begin
        StartKickingOff(aActions);
      end;
{$ENDIF}
    end;
  end;

{$IFDEF __TEST__}
Exit;
{$ENDIF}

  // check on tournament autosave event
  if Self.NextAutosaveTime <= aNow then begin
    StartAutosave;
  end;

  // check on process responce
  if Self.IsRunning or Self.IsBreak and (not Self.IsPauseByAdmin) then begin
    for I:= 0 to Processes.Count - 1 do begin
      aPrc := Processes.Items[I];
      if aPrc.IsRunning and (aPrc.FStartResumeTime <> 0) and
         (IncMinute(aPrc.FStartResumeTime, WAITRESPONSEENDOFHAND) <= Now)
      then begin
        CommonDataModule.Log(ClassName, 'CheckOnTimeEvent',
        'TimeWait response endofhand more then ' + IntToStr(WAITRESPONSEENDOFHAND) + ' min' +
        ': processid=' + IntToStr(aPrc.FProcessID), ltException);

{$IFDEF __TEST__}
        FSQL := nil;
{$ELSE}
        FSQL := CommonDataModule.ObjectPool.GetSQLAdapter;
{$ENDIF}
//
        StopTournament(FSQL, aActions);
//
{$IFNDEF __TEST__}
        CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
{$ENDIF}
      end;
    end;
  end;

end;

function TtsTournament.StartSitting(aActions: TXMLRespActions): Integer;
var
  SQLAdapter: TSQLAdapter;
  I, J, Cnt: Integer;
  RestPlayers, RestTables, ScrPlPerTables: Integer;
  aProcess: TpoTournProcess;
  aPlayer: TpoTournUser;
  ActTxt: string;
begin
  CommonDataModule.Log(ClassName, 'StartSitting', 'Entry', ltCall);

{$IFDEF __TEST__}
  SQLAdapter := nil;
{$ELSE}
  SQLAdapter := CommonDataModule.ObjectPool.GetSQLAdapter;
{$ENDIF}

  if not Self.IsRegistration then begin
    CommonDataModule.Log(ClassName, 'StartSitting',
      '[EXCEPTION]: Tournament is not in registration status.', ltException);

    Result := StopTournament(SQLAdapter, aActions);
    if Result <> 0 then begin
      CommonDataModule.Log(ClassName, 'StartSitting',
        '[WARNING!!!]: On exception can not to stop tournament. Error result=' + IntToStr(Result), ltCall);
    end else begin
      Result := TS_ERR_CANNOTSETSITTINGSTATUS;
    end;

{$IFNDEF __TEST__}
    CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);
{$ENDIF}

    Exit;
  end;

  // check on entrants
//  if (Self.Entrants = 0) or (Self.Entrants < FPlayerPerTable) then begin
  if (Self.Entrants = 0) or (Self.Entrants < 2) then begin
    // No Entrants -> Stop
    // stop without status tstStopped & return money

    Result := StopTournament_SQL(SQLAdapter);
    if Result <> 0 then begin
      CommonDataModule.Log(ClassName, 'StartSitting',
        '[WARNING!!!]: On exception can not to stop tournament. Error result=' + IntToStr(Result), ltCall);
    end;

    //   3) set user as Lost
    for I:=0 to Players.Count - 1 do begin
      Players.Items[I].FLostTime := Now;
    end;

    //   4) Set Processes as UnUsed and drop it
    for I := Processes.Count - 1 downto 0 do begin
      Processes.Items[I].FStatusID := pstUnused;
      Processes.Del(Processes.Items[I]);
    end;

    //   5) completing tournament
    FTournamentStatusID := tstCompleted + tstNoEntrants;
    FStatusID := 3; // not used
    FTournamentFinishTime := Now;
    StartAutosave;

{$IFNDEF __TEST__}
    CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);
{$ENDIF}

    Exit;
  end;

  FRebuyIsAllowed := FRebuyWasAllowedOnCreate;

  // allocate Tables on start sitting (registration processes)
  RestPlayers := ActivePlayers;
  RestTables  := OptimalTables;
  Processes.Clear;
  for I:=0 to RestTables - 1 do begin
    // registration process (GameEngine.InitProcess will be executed)
    Result := Processes.RegistrationProcess(FGameEngineID, FChips, FName, SQLAdapter);
    if Result <> 0 then begin
      Result := TS_ERR_CANNOTSETSITTINGSTATUS;
      CommonDataModule.Log(ClassName, 'StartSitting',
        '[EXCEPTION]: Error on execute Processes.RegistrationProcess result=' + IntToStr(Result) +
          '; params: EngineID=' + IntToStr(GameEngineID) + ', Name=' + Name,
        ltCall);

      StopTournament(SQLAdapter, aActions);

{$IFNDEF __TEST__}
      CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);
{$ENDIF}

      Exit;
    end;
  end;

  // Allocate Players on tables
  Cnt := 0;
  for I:=0 to Processes.Count - 1 do begin
    ScrPlPerTables := GetOptimalRestPlayersPerTable(RestTables, RestPlayers);
    for J:=0 to ScrPlPerTables - 1 do begin
      aPlayer := FPlayers.Items[Cnt];
      aPlayer.FPlace := J;
      aPlayer.FProcessID := Processes.Items[I].FProcessID;
      Cnt := Cnt + 1;
    end;
    RestTables := RestTables -1;
    RestPlayers := RestPlayers - ScrPlPerTables;
  end;

  FTournamentLevel := 1;
  // send init command to all processes
  for I:=0 to Processes.Count - 1 do begin
    aProcess := Processes.Items[I];
    aProcess.FLevel := FTournamentLevel;

    ActTxt := aProcess.GetCommandToGameEngine(cmdInit,
      'Tournament will started in ' + IntToStr(SittingDuration) + ' seconds. Take you place.',
      '', '', '',
      FBettings.Stake[FTournamentLevel], FBettings.Ante[FTournamentLevel], 0,
      Players.CountOnProcess[aProcess.FProcessID], FActionDispatcherID, 0,
      Players, nil
    );

    if ActTxt = '' then begin
      Result := TS_ERR_CANNOTSETSITTINGSTATUS;
      CommonDataModule.Log(ClassName, 'StartSitting',
        '[EXCEPTION]: Error on execute aProcess.GetCommandToGameEngine' +
          '; on process: ProcessID=' + IntToStr(aProcess.FProcessID),
        ltCall);

      StopTournament(SQLAdapter, aActions);

{$IFNDEF __TEST__}
      CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);
{$ENDIF}
      Exit;
    end;

    // add to action buffer
    aActions.Add(ActTxt, -1, -1);

    // add event to action buffer
    ActTxt := aProcess.GetCommandToGameEngine(cmdEvent,
      'Tournament will started in ' + IntToStr(FSittingDuration * 60) + ' seconds. Take you place.',
      '', eventStart, '', -1, -1, 0, 0,
      FActionDispatcherID, FSittingDuration * 60, nil, nil
    );
    aActions.Add(ActTxt, -1, -1);
  end;

  // refresh prizes
  FPrizes.LoadFromAdmSiteXML(Self);
  // set sitting
  FTournamentStatusID := tstSitting;
  StoreToDB(SQLAdapter);

{$IFNDEF __TEST__}
  CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);
{$ENDIF}

  Result := 0;

  CommonDataModule.Log(ClassName, 'StartSitting', 'Exit: All right.', ltCall);
end;

function TtsTournament.StopTournament(SQLAdapter: TSQLAdapter; aResponce: TXMLRespActions; sMsg: string): Integer;
var
  I: Integer;
  sMessage: string;
begin
//************************************************
// On Error or stop service !!!!!!!!!!!!!!
// Goal:
//   1) return money for all registered users
//   2) notification about it
//   3) Set User as lost
//   4) Set Processes as UnUsed and drop it
//   5) stop tournament
//************************************************

  FRebuyIsAllowed := False;
  FAddOnIsAllowed := False;

  // 1) return money for all registered users
  Result := StopTournament_SQL(SQLAdapter);
  if Result <> 0 then begin
    CommonDataModule.Log( ClassName, 'StopTournament',
      'On execute [StopTournament_SQL] Result=' + IntToStr(Result),
      ltCall
    );
  end;

  //   2) notification about it (procclose)
  if sMsg = '' then begin
    sMessage :=
      'By technical reason the tournament was stopped. ' +
      'All the money for the registration will be returned to you. ' +
      'We appologize for inconvinience.';
  end else begin
    sMessage := sMsg;
  end;
  Players.ProcCloseNotify(True, sMessage, aResponce);
  //   3) set user as Lost
  for I:=0 to Players.Count - 1 do begin
    Players.Items[I].FLostTime := Now;
  end;

  //   4) Set Processes as UnUsed and drop it
  for I := Processes.Count - 1 downto 0 do begin
    Processes.Items[I].FStatusID := pstUnused;
    Processes.Del(Processes.Items[I]);
  end;

  //   5) stop tournament
  FTournamentStatusID := tstStopped;
  FTournamentFinishTime := Now;
  FStatusID := 3; // not used
  StoreToDB(SQLAdapter);
end;

function TtsTournament.StopTournament_SQL(SQLAdapter: TSQLAdapter): Integer;
begin
{$IFDEF __TEST__}
	Result := 0;
  Exit;
{$ENDIF}

  try

    SQLAdapter.SetProcName('srvtouAbortTournament');
    SQLAdapter.AddParInt('RETURN_VALUE',0,ptResult);
    SQLAdapter.AddParInt('TournamentID', FTournamentID, ptInput);

    SQLAdapter.ExecuteCommand;

    Result := SQLAdapter.GetParam('RETURN_VALUE');

    if (Result <> 0) then begin
      LogException( '{62C9185B-3339-498A-B256-E29445844794}',
        ClassName, 'AbortTournament_SQL',
        'SQL result = ' + IntToStr(Result) +
        '; Params: TournamentId = ' + IntToStr(TournamentID)
      );
    end;

  except on E: Exception do
    begin
      Result := TS_ERR_SQLERROR;
      LogException( '{20496162-082D-4AD4-BC07-7C98497588B5}',
        ClassName, 'AbortTournament_SQL',
        'SQL: srvtouAbortTournament raise exception: ' + E.Message +
        '; Params: TournamentId = ' + IntToStr(TournamentID)
      );

      Exit;
    end;
  end;

end;

function TtsTournament.StartRunning(aActions: TXMLRespActions): Integer;
var
  SQLAdapter: TSQLAdapter;
  I: Integer;
  aProcess: TpoTournProcess;
  ActTxt: string;
begin
  CommonDataModule.Log(ClassName, 'StartRunning', 'Entry', ltCall);

{$IFDEF __TEST__}
  SQLAdapter := nil;
{$ELSE}
  SQLAdapter := CommonDataModule.ObjectPool.GetSQLAdapter;
{$ENDIF}

  if not Self.IsSitting then begin
    CommonDataModule.Log(ClassName, 'StartRunning',
      '[EXCEPTION]: Tournament is not in sitting status.', ltException);

    Result := StopTournament(SQLAdapter, aActions);
    if Result <> 0 then begin
      CommonDataModule.Log(ClassName, 'StartRunning',
        '[WARNING!!!]: On exception can not to stop tournament. Error result=' + IntToStr(Result), ltCall);
    end else begin
      Result := TS_ERR_CANNOTSETRUNNINGSTATUS;
    end;

{$IFNDEF __TEST__}
    CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);
{$ENDIF}
    Exit;
  end;

  // set start time for kicking off not taked sits
  if (FTimeOutForKickOff > 0) then
    FStartKickOffNotTakedSit := IncMinute(Now, FTimeOutForKickOff)
  else
    FStartKickOffNotTakedSit := 0;

  // send resume command to all processes
  for I:=0 to Processes.Count - 1 do begin
    aProcess := Processes.Items[I];

    ActTxt := aProcess.GetCommandToGameEngine(cmdResume,
      'Tournament has been started. Current level is ' + IntToStr(aProcess.FLevel),
      '', '', '', Self.Stake, Self.Ante, 0, Players.CountOnProcess[aProcess.FProcessID],
      FActionDispatcherID, 0, nil, nil
    );

    if ActTxt = '' then begin
      Result := TS_ERR_CANNOTSETRUNNINGSTATUS;
      CommonDataModule.Log(ClassName, 'StartRunning',
        '[EXCEPTION]: Error on execute aProcess.GetCommandToGameEngine' +
          '; on process: ProcessID=' + IntToStr(aProcess.FProcessID),
        ltCall);

      StopTournament(SQLAdapter, aActions);

{$IFNDEF __TEST__}
      CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);
{$ENDIF}

      Exit;
    end;

    aActions.Add(ActTxt, -1, -1);
    aProcess.FStartResumeTime := Now;
    aProcess.FStatusID := pstRunning;
  end;

  // set running
  FTournamentStatusID := tstRunning;
  // set next level and break event
  FNextLevelTime := IncMinute(Now, FLevelInterval);
  FNextBreakTime := IncMinute(Now, FBreakInterval);

{$IFNDEF __TEST__}
  CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);
{$ENDIF}

  Result := 0;

  CommonDataModule.Log(ClassName, 'StartRunning', 'Exit: All right.', ltCall);
end;

function TtsTournament.StartBreak: Integer;
begin
  //shift levelup on breakduration
  if (FStartKickOffNotTakedSit > 0) then
    FStartKickOffNotTakedSit := IncMinute(FStartKickOffNotTakedSit, FBreakDuration);
  FNextLevelTime := IncMinute(FNextLevelTime, FBreakDuration);
  Self.TournamentStatusID := tstBreak;

  // turn off rebuying
  FAddOnIsAllowed := FAddOnWasAllowedOnCreate and (FPauseCount <= 0);
  FRebuyIsAllowed := False;
  FPauseCount := FPauseCount + 1;

  Result := 0;
end;

function TtsTournament.StartBreakEnd(aActions: TXMLRespActions): Integer;
var
  SQLAdapter: TSQLAdapter;
  I: Integer;
  aPrc: TpoTournProcess;
begin

  CommonDataModule.Log(ClassName, 'StartBreakEnd', 'Entry', ltCall);

{$IFDEF __TEST__}
  SQLAdapter := nil;
{$ELSE}
  SQLAdapter := CommonDataModule.ObjectPool.GetSQLAdapter;
{$ENDIF}

  Result := 0;
  if Self.IsPauseByAdmin then Exit;

  if not Self.IsBreak then begin
    CommonDataModule.Log(ClassName, 'StartBreakEnd',
      '[EXCEPTION]: Tournament is not in break status.', ltException);

    Result := StopTournament(SQLAdapter, aActions);
    if Result <> 0 then begin
      CommonDataModule.Log(ClassName, 'StartBreakEnd',
        '[WARNING!!!]: On exception can not to stop tournament. Error result=' + IntToStr(Result), ltCall);
    end else begin
      Result := TS_ERR_CANNOTSETBREAKEND;
    end;

{$IFNDEF __TEST__}
    CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);
{$ENDIF}

    Exit;
  end;

  FAddOnIsAllowed := False;

  //shift next break start time
  FNextBreakTime := IncMinute(Now, FBreakInterval);
  Self.TournamentStatusID := tstRunning;

  // check on resiting after break for all table
  for I:=FProcesses.Count - 1 downto 0 do begin
    aPrc := FProcesses.Items[I];
    CheckOfResitingPlayersFromProcess(False, aPrc, aActions, SQLAdapter);
    // on resitt may be stop tournament
    if Self.IsStopped then begin
      Result := 1;
      Exit;
    end;
  end;

  // send resume command to all processes
  StartAllProcessAfterBreak(True, True,
    'Resume after break. Current level is ' + IntToStr(FTournamentLevel),
    aActions
  );

{$IFNDEF __TEST__}
  CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);
{$ENDIF}

  Result := 0;
  CommonDataModule.Log(ClassName, 'StartBreakEnd', 'Exit: All right', ltCall);
end;

procedure TtsTournament.SetNextAutosaveTime(const Value: TDateTime);
begin
  FNextAutosaveTime := Value;
end;

function TtsTournament.StartAutosave: Integer;
var
  SQLAdapter: TSQLAdapter;
begin
  CommonDataModule.Log(ClassName, 'StartAutosave', 'Entry', ltCall);

{$IFDEF __TEST__}
  SQLAdapter := nil;
{$ELSE}
  SQLAdapter := CommonDataModule.ObjectPool.GetSQLAdapter;
{$ENDIF}

  Result := StoreToDB(SQLAdapter);

{$IFNDEF __TEST__}
  CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);
{$ENDIF}

  CommonDataModule.Log(ClassName, 'StartAutosave', 'Exit: All right', ltCall);
end;

function TtsTournament.LOBBY_toGetTournaments(nTournamentKind: Integer): string;
var
  sName, sNameOfEntrance, shortStakeName: string;
begin
//**********************************************************
// WARNING: it's not full xml for notify. Only process node
//**********************************************************
  DateTimeToString(sName, 'mmm dd hh:nn a/p', FTournamentStartTime);
  if (FMaxRegisteredLimit > 0) and Self.IsSitAndGO and
     (TournamentStatusID in [tstAnnouncing, tstRegistration])
  then
    sNameOfEntrance := IntToStr(Players.Count) + ' of ' + IntToStr(FMaxRegisteredLimit)
  else
    sNameOfEntrance := IntToStr(Players.Count);

  //sName := sName + ' ET';
  if StakeName = 'Fixed Limit' then
    shortStakeName := 'Fixed'
  else
  if StakeName = 'Pot Limit' then
    shortStakeName := 'PL'
  else
  if StakeName = 'No Limit' then
    shortStakeName := 'NL';

  Result :=
    '<process id="' + IntToStr(TournamentID) + '" ' +
        'name="' + XMLSafeEncode(Name) + '" ' +
        'currencyid="' + IntToStr(CurrencyTypeID) + '" ' +
        'groupid="1" ' +
        'types="' + GetTypesForLobby + '">' +
      '<stats id="200" value="' + IntToStr(TournamentID) + '"/>';

  if (nTournamentKind <> 2) then
    Result := Result +
      '<stats id="201" value="' + sName + '"/>';

  Result := Result +
      '<stats id="202" value="' + XMLSafeEncode(GameTypeName) + '"/>' +
      '<stats id="203" value="' + XMLSafeEncode(shortStakeName) + '"/>' +
      '<stats id="204" value="' + CurrencySign + CurrToStr(FBuyIn) +
        '+' +
        CurrencySign + CurrToStr(FFee) + '"/>' +
      '<stats id="205" value="' + XMLSafeEncode(NameOfState) + '"/>' +
      '<stats id="206" value="' + sNameOfEntrance + '"/>' +
    '</process>';

end;

function TtsTournament.LOBBY_toRegister(nUserID, nFromTournamentID: Integer; sPassword: string;
  SQLAdapter: TSQLAdapter; var nErrCode: Integer): string;
var
  FApi: TAPI;
  nAccess: Integer;
begin
  nErrCode := 0;

  Result :=
      '<object name="' + APP_TOURNAMENT + '" id="0">' +
        '<toregister ' +
          'tournamentid="' + IntToStr(TournamentID) + '" ' +
          'userid="' + IntToStr(nUserID) + '" ';

  nAccess := 1;
  if (FTournamentTypeID = ttpRestricted) then begin
    FApi := CommonDataModule.ObjectPool.GetAPI;
    try
      FApi.CheckOnAccessByInvitedUsers(TournamentID, 1, nUserID, nAccess);
    finally
      CommonDataModule.ObjectPool.FreeAPI(FApi);
    end;
  end;

  if not Self.IsRegistration then begin
    CommonDataModule.Log(ClassName, 'ProcessAction',
      'Tournament have not status Registering; Params: TournamentID=' + IntToStr(TournamentID),
      ltCall);

    nErrCode := TS_ERR_NOTREGISTERATIONSTATUS;
    Result := Result + 'result="' + IntToStr(nErrCode) + '"/>';
  end else
{.$IFDEF __TEST__}
//  if Self.IsSitAndGO and (Players.Count > FMaxRegisteredLimit) then begin
{.$ELSE}
//  if Self.IsSitAndGO and (Players.Count >= FMaxRegisteredLimit) then begin
  if (Players.Count >= FMaxRegisteredLimit) and (FMaxRegisteredLimit > 0) then begin
{.$ENDIF}
    CommonDataModule.Log(ClassName, 'ProcessAction',
      'Maximum registered is allowed; Params: TournamentID=' + IntToStr(TournamentID),
      ltCall);

    nErrCode := TS_ERR_MAXIMUMREGISTEREDALLOWED;
    Result := Result + 'result="' + IntToStr(nErrCode) + '"/>';
  end else
  if (FTournamentTypeID = ttpRestricted) and (FPassword <> sPassword) then begin
    nErrCode := TS_ERR_PASSWORDISNOTVALID;
    Result := Result + 'result="' + IntToStr(nErrCode) + '"/>';
  end else
  if (FTournamentTypeID = ttpRestricted) and (nAccess <= 0) then begin
    nErrCode := TS_ERR_ACCESSDENIEDBYINVITEDUSERS;
    Result := Result + 'result="' + IntToStr(nErrCode) + '"/>';
  end else begin
{$IFDEF __TEST__}
    nErrCode := 0;
{$ELSE}
    nErrCode := Players.RegisterParticipant(
      TournamentID, nFromTournamentID, nUserID,
      FChips, FBuyIn, FFee, FCurrencyTypeID, 0, 1, 2, SQLAdapter
    );
{$ENDIF}

    if nErrCode <> 0 then begin
      CommonDataModule.Log(ClassName, 'ProcessAction',
        '[ERROR]: Players.RegisterParticipant return result=' + IntToStr(nErrCode) +
          '; Params: TournamentID=' + IntToStr(FTournamentID) +
          ', UserID=' + IntToStr(nUserID),
        ltError);

      Result := Result + 'result="' + IntToStr(nErrCode) + '"/>';
    end else begin
      Result := Result + 'result="0"/>';
      if Self.IsSitAndGO and
         (FTournamentStartEvent <> tseByTime) and
         (Players.Count >= FMaxRegisteredLimit) then
      begin
        FTournamentStartTime := IncMinute(Now, SittingDuration);
      end;
    end;

    { send autoregistration event }
    if (nFromTournamentID > 0) and (nErrCode = 0) then begin
      Actions.Add(
        LOBBY_toTournamentEvent(eventAutoRegistration,
          'You succesfull registered to satelited tournament.',
          -1, -1, nFromTournamentID, FName
        ),
        -1, nUserID
      );
    end;

  end;

  Result := Result + '</object>';
end;

function TtsTournament.LOBBY_toUnRegister(nUserID: Integer; SQLAdapter: TSQLAdapter): string;
var
  nRes: Integer;
begin

  Result :=
      '<object name="' + APP_TOURNAMENT + '" id="0">' +
        '<tounregister ' +
          'tournamentid="' + IntToStr(TournamentID) + '" ' +
          'userid="' + IntToStr(nUserID) + '" ';

  if not Self.IsRegistration then begin
    CommonDataModule.Log(ClassName, 'ProcessAction',
      '[ERROR]: Tournament have not status Registering; Params: TournamentID=' + IntToStr(TournamentID),
      ltException);

    Result := Result + 'result="' + IntToStr(TS_ERR_NOTREGISTERATIONSTATUS) + '"/>';
  end else begin
    nRes := Players.UnRegisterParticipant(
      TournamentID, nUserID,
      FBuyIn, FFee,
      FCurrencyTypeID, SQLAdapter
    );

    if nRes <> 0 then begin
      CommonDataModule.Log(ClassName, 'ProcessAction',
        '[ERROR]: Players.UnRegisterParticipant return result=' + IntToStr(nRes) +
          '; Params: TournamentID=' + IntToStr(FTournamentID) +
          ', UserID=' + IntToStr(nUserID),
        ltException);

      Result := Result + 'result="' + IntToStr(nRes) + '"/>';
    end else begin
      Result := Result + 'result="0"/>';
    end;
  end;

  Result := Result + '</object>';
end;

function TtsTournament.LOBBY_toTournamentEvent(sAction, sMsg: string;
  nProcessID, nOldProcessID, nOldTournamentID: Integer; sProcessName: string): string;
begin
  Result :=
    '<object name="' + APP_TOURNAMENT + '" id="' + IntToStr(FTournamentID) + '">' +
      '<totournamentevent action="' + XMLSafeEncode(sAction) + '" ' +
      'msg="' + sMsg + '" ' +
      'tournamentid="' + IntToStr(TournamentID) + '" ' +
      'actiondispatcherid="' + IntToStr(FActionDispatcherID) + '" ' +
      'tournamentname="' + XMLSafeEncode(Name) + '" ' +
      'processid="' + IntToStr(nProcessID) + '" ' +
      'processname="' + XMLSafeEncode(sProcessName) + '" ';
  if sAction = 'changetable' then
    Result := Result + 'oldprocessid="' + IntToStr(nOldProcessID) + '"';
  if sAction = eventAutoRegistration then
    Result := Result + 'oldtournamentid="' + IntToStr(nOldTournamentID) + '"';
  Result := Result + '/>' +
    '</object>';
end;

function TtsTournament.EndOfHandAction(InpAction: TXMLAction;
  aResponce: TXMLRespActions; SQLAdapter: TSQLAdapter): Integer;
var
  TID, PID, UserID, nPlace: Integer;
  nMoney: Currency;
  aPrc: TpoTournProcess;
  aUsr: TpoTournUser;
  I: Integer;
  Node: IXMLNode;
  EOHTime: TDateTime;
  FXML: IXMLDocument;
  Action: IXMLNode;
  WasHandForHand: Boolean;
  //
  ALostUsersOnCommand: TpoTournUserList;
  nCountActiveBefore: Integer;
  sMsg, sExceptUserIDs, sNonCurrPrize: string;
  nBotBlaffers: Integer;
  bUserWasTakingSit: Boolean;
  errCode: Integer;
  bIsLost: Boolean;
begin
  CommonDataModule.Log(ClassName, 'EndOfHandAction',
    'Entry. ProcessID=' + IntToStr(InpAction.ProcessID) +
      ', TournamentID=' + IntToStr(InpAction.TournamentID),
    ltCall);

  Result := 0;
  WasHandForHand := Self.IsHandForHand;

  // XML Parser
  FXML := TXMLDocument.Create(nil);
  FXML.XML.Text := InpAction.Action;
  try
    FXML.Active := True;
  except
    on E: Exception do begin
      CommonDataModule.Log(ClassName, 'EndOfHandAction',
        '[EXCEPTION] On open XML document: ' + e.Message +
        '; Params: XML=' + InpAction.Action,
        ltException);

      Result := TS_ERR_XMLPARCEERROR;
      FXML := nil;
      Exit;
    end;
  end;

  Action := FXML.DocumentElement;
//  if Action.HasChildNodes then Action := Action.ChildNodes[0];

//*****************************
// Before: validate
//*****************************
  TID := Action.Attributes['tournamentid'];
  PID := Action.Attributes['processid'];
{
  if Action.HasAttribute('handfinishstamp') then
    EOHTime := StrToFloatDef(Action.Attributes['handfinishstamp'], Now)
  else EOHTime := Now;
}
  EOHTime := Now;
//
  if not (Self.IsRunning or Self.IsBreak or Self.IsPauseByAdmin) then begin
    CommonDataModule.Log(ClassName, 'EndOfHandAction',
      '[Error]: EndOfHand has not running status; Params: ' +
        'TournamentID=' + IntToStr(TID) + ', processID=' + IntToStr(PID),
      ltError);

    Result := TS_ERR_COMMON;
    FXML := nil;
    Exit;
  end;

  aPrc := Processes.GetProcessByID(PID);
  if aPrc = nil then begin
    CommonDataModule.Log(ClassName, 'EndOfHandAction',
      '[Error]: Process not found; Params: ' +
        'TournamentID=' + IntToStr(TID) + ', processID=' + IntToStr(PID),
      ltError);

    Result := TS_ERR_CANNOTFOUNDPROCESS;
    FXML := nil;
    Exit;
  end;

  if aPrc.FStatusID <> pstRunning then begin
    CommonDataModule.Log(ClassName, 'EndOfHandAction',
      '[Error]: Process have not status Running; Params: ' +
        'TournamentID=' + IntToStr(TID) + ', processID=' + IntToStr(PID),
      ltError);

    Result := TS_ERR_COMMON;
    FXML := nil;
    Exit;
  end;

//*****************************
// Next: set wating status
//*****************************
  aPrc.FStatusID := pstWaiting;

//*****************************
// next: lost & play users
//*****************************
  ALostUsersOnCommand := TpoTournUserList.Create;
  sExceptUserIDs := '';
  for I:=0 to Action.ChildNodes.Count - 1 do begin
    Node := Action.ChildNodes[I];
    UserID := StrToIntDef(Node.Attributes['userid'], 0);

    sExceptUserIDs := sExceptUserIDs + IntToStr(UserID) + ',';

    nPlace := StrToIntDef(Node.Attributes['place'], -1);

    bUserWasTakingSit := False;
    if Node.HasAttribute('istakedsit') then
      bUserWasTakingSit := Boolean(StrToIntDef(Node.Attributes['istakedsit'], 0));

    if Node.NodeName = 'lost' then begin
      nMoney := 0;
    end else begin
      nMoney := StrToCurrDef(Node.Attributes['money'], 0);
    end;
    if (UserID <= 0) or (nPlace < 0) then begin
      CommonDataModule.Log(ClassName, 'EndOfHandAction',
        '[ERROR]: Parameters is incorrect; ' +
          'UserID=' + IntToStr(UserID) + ', Place=' + IntToStr(nPlace),
        ltError);

      ALostUsersOnCommand.Free;
      StopTournament(SQLAdapter, aResponce);

      Result := TS_ERR_CANNOTFOUNDUSER;
      FXML := nil;
      Exit;
    end;

    aUsr := Players.GetUserByID(UserID);
    if (aUsr = nil) then begin
      CommonDataModule.Log(ClassName, 'EndOfHandAction',
        '[ERROR]: User not found. ' +
          'UserID=' + IntToStr(UserID) + ', Place=' + IntToStr(nPlace) +
          ', TournamentID=' + IntToStr(TID) +
          ', ProcessID=' + IntToStr(PID),
        ltError);

      ALostUsersOnCommand.Free;
      StopTournament(SQLAdapter, aResponce);

      Result := TS_ERR_CANNOTFOUNDUSER;
      FXML := nil;
      Exit;
    end;

    if (aUsr.FProcessID <> PID) then begin
      CommonDataModule.Log(ClassName, 'EndOfHandAction',
        '[ERROR]: Real User data is not equal XML node data; ' +
          'UserID=' + IntToStr(UserID) + ', Real Place=' + IntToStr(aUsr.Place) +
          ', Node Place=' + IntToStr(nPlace) +
          ', Real ProcessID=' + IntToStr(aUsr.FProcessID) +
          ', Node ProcessID=' + IntToStr(PID) +
          ', TournamentID=' + IntToStr(TID),
        ltError);

      ALostUsersOnCommand.Free;
      StopTournament(SQLAdapter, aResponce);

      Result := TS_ERR_CANNOTFOUNDUSER;
      FXML := nil;
      Exit;
    end;

    if (aUsr.FPlace <> nPlace) then begin
      if Node.NodeName = 'lost' then begin
        CommonDataModule.Log(ClassName, 'EndOfHandAction',
          '[WARNING]: Real User data is not equal XML node data; ' +
            'UserID=' + IntToStr(UserID) + ', Real Place=' + IntToStr(aUsr.Place) +
            ', Node Place=' + IntToStr(nPlace) +
            ', Real ProcessID=' + IntToStr(aUsr.FProcessID) +
            ', Node ProcessID=' + IntToStr(PID) +
            ', TournamentID=' + IntToStr(TID),
          ltError);
      end else begin
        CommonDataModule.Log(ClassName, 'EndOfHandAction',
          '[ERROR]: Real User data is not equal XML node data; ' +
            'UserID=' + IntToStr(UserID) + ', Real Place=' + IntToStr(aUsr.Place) +
            ', Node Place=' + IntToStr(nPlace) +
            ', Real ProcessID=' + IntToStr(aUsr.FProcessID) +
            ', Node ProcessID=' + IntToStr(PID) +
            ', TournamentID=' + IntToStr(TID),
          ltError);

        ALostUsersOnCommand.Free;
        StopTournament(SQLAdapter, aResponce);

        Result := TS_ERR_CANNOTFOUNDUSER;
        FXML := nil;
        Exit;
      end;
    end;

    bIsLost := (Node.NodeName = 'lost');
    if bIsLost then begin
      errCode := 1;
      if FRebuyIsAllowed and
         aUsr.FRebuyAuto and
         not aUsr.IsBot and
         not aUsr.FIsKickOffByAdministrator
      then begin
        LOBBY_toRebuy(aUsr.FUserID, 1, SQLAdapter, errCode);
        bIsLost := (errCode <> 0);
        if not bIsLost then begin
          nMoney := FChips;
        end;
      end;
    end;
    if bIsLost then begin
      { chair state change notify to flash }
      aResponce.Add(
        Flash_GAAction_Chair('hidden', '', aUsr.FProcessID, aUsr.FPlace),
        -1, aUsr.FUserID
      );

      aUsr.SetAsLost(EOHTime, FPlayers.GetActiveCount);
      ALostUsersOnCommand.Add.SetContextByObject(aUsr);
    end else begin
      try
        nBotBlaffers := Node.Attributes['botblaffers'];
      except
        nBotBlaffers := aUsr.FBotBlaffersEvent;
      end;

      if (nBotBlaffers <= 0) then
        nBotBlaffers := MIN_COUNT_ONBLAFFERS + Random(MAX_COUNT_ONBLAFFERS - MIN_COUNT_ONBLAFFERS);

      aUsr.FIsTakedSit := aUsr.FIsTakedSit or bUserWasTakingSit;

      aUsr.FChips := nMoney;
      aUsr.FBotBlaffersEvent := nBotBlaffers;
    end;
  end;
  sExceptUserIDs := Copy(sExceptUserIDs, 1, Length(sExceptUserIDs) - 1);

  SortPlayersOnFinish(ALostUsersOnCommand);
  nCountActiveBefore := Players.ActiveCount;
  { notification about lost and place }
  for I:=0 to ALostUsersOnCommand.Count - 1 do begin
    Inc(nCountActiveBefore);
    nMoney := GetPrizeValue(0, nCountActiveBefore, Self.TotalPrize);
    sNonCurrPrize := GetNonCurrencyPrizeValue(0, nCountActiveBefore);
    if (nMoney <= 0) then begin
      sMsg := 'You finished Tournament in ' + PlaceAsString(nCountActiveBefore) +
        ' Place.' + #13#10 + 'Thank You for Playing.';
      aResponce.Add(
        LOBBY_toTournamentEvent(eventUserLost, sMsg, -1, -1, -1, ''),
        -1, ALostUsersOnCommand.Items[I].FUserID
      );
    end else begin
      SendCongratilationNotifyAndMail(aResponce,
        sNonCurrPrize, FPrizes.Items[0].FCurrencySign, nMoney,
        ALostUsersOnCommand.Items[I].FUserID, nCountActiveBefore
      );
    end;
  end;

  { send standup command to gameengine }
  if (ALostUsersOnCommand.Count > 0) then begin
    { restore processid to lost users }
    for I:=0 to ALostUsersOnCommand.Count - 1 do begin
      aUsr := ALostUsersOnCommand.Items[I];
      aUsr.ProcessID := aUsr.ProcessIDOnLost;
    end;
    FActions.Add(
      aPrc.GetCommandToGameEngine(cmdStandUp,
        '', '', '', '',
        Self.Stake, Self.Ante, 0, Players.CountOnProcess[aPrc.FProcessID],
        FActionDispatcherID, 0, nil, ALostUsersOnCommand ),
        -1, -1
    );
  end;

  ALostUsersOnCommand.Free;

  FXML.Active := False;
  FXML := nil;

//*****************************
// next: Set statistic values
//*****************************
  aPrc.FMinStack := FPlayers.GetMinChips(aPrc.FProcessID);
  aPrc.FMaxStack := FPlayers.GetMaxChips(aPrc.FProcessID);
  aPrc.FAvgStack := FPlayers.GetAvgChips(aPrc.FProcessID);
  // MEMO: start value of aPrc.FHandCount and Processes.SumAllHand is 1
  aPrc.FHandCount := aPrc.FHandCount + 1;

  if Processes.FSmallestStack <= 0 then begin
    Processes.FSmallestStack := aPrc.FMinStack;
  end else begin
    Processes.FSmallestStack := Min(Processes.FSmallestStack, aPrc.FMinStack);
  end;
  Processes.FLargestStack := Max(Processes.FLargestStack, aPrc.FMaxStack);
  Processes.FAverageStack := Processes.GetAverageStack;
  Processes.SumAllHand := Processes.SumAllHand + 1;

//*****************************
// Next: check on finish tournament
//*****************************
  if Self.ActivePlayers <= NumberOfPlayersForFinish then begin
    if Processes.WatingCount = Processes.Count then begin
      FinishTournament(sExceptUserIDs, aResponce, SQLAdapter);

      CommonDataModule.Log(ClassName, 'EndOfHandAction',
        'Exit. All right (finish). ProcessID=' + IntToStr(PID) +
          ', TournamentID=' + IntToStr(FTournamentID),
        ltCall);

      Exit;
    end else begin // wait answ. from other processes
      aResponce.Add(
        aPrc.GetCommandToGameEngine(cmdBreak,
          'Tournament completed. Wait while all other tables finish their hands.',
          '', '', '', Self.Stake, Self.Ante, 0, 0, FActionDispatcherID, 0, nil, nil ),
        -1, -1
      );

      CommonDataModule.Log(ClassName, 'EndOfHandAction',
        'Exit. All right (finish, wait next processes). ProcessID=' + IntToStr(PID) +
          ', TournamentID=' + IntToStr(FTournamentID),
        ltCall);
      Exit;
    end;
  end;

//*****************************
// Next: command if break started or pause by admin
//*****************************
  if Self.IsPauseByAdmin then begin
    aResponce.Add(
      aPrc.GetCommandToGameEngine(cmdBreak,
        'Pause by admin has been started.', '', '', '',
        Self.Stake, Self.Ante, 0, Players.CountOnProcess[aPrc.FProcessID], FActionDispatcherID, 0, nil, nil ),
      -1, -1
    );
  end else if Self.IsBreak then begin
    aResponce.Add(
      aPrc.GetCommandToGameEngine(cmdBreak,
        'Break has been started.', '', '', '',
        Self.Stake, Self.Ante, 0, Players.CountOnProcess[aPrc.FProcessID], FActionDispatcherID, 0, nil, nil ),
      -1, -1
    );
    aResponce.Add(
      aPrc.GetCommandToGameEngine(cmdEvent,
        'Break has been started.', '', eventBreak, '', -1, -1, 0, 0, FActionDispatcherID,
        SecondsBetween(Now, NextBreakEndTime), nil, nil
      ),
      -1, -1
    );

  end;

//*****************************
// Next: check on need resitting
//*****************************
  CheckOfResitingPlayersFromProcess(WasHandForHand, aPrc, aResponce, SQLAdapter);
  // on resitt may be stop tournament
  if Self.IsStopped then Exit;

//*****************************
// Next: check on Hand for Hand
//*****************************
  if Self.IsHandForHand then begin
    if Processes.WatingCount = Processes.Count then begin
      StartAllProcessAfterBreak(True, False, '', aResponce);
    end else begin
      // send command to GE
      aResponce.Add(
        aPrc.GetCommandToGameEngine(cmdBreak,
          'Hand For Hand in Progress.', '', '', '',
          Self.Stake, Self.Ante, 0, Players.CountOnProcess[aPrc.FProcessID], FActionDispatcherID, 0, nil, nil),
        -1, -1
      );
    end;

    CommonDataModule.Log(ClassName, 'EndOfHandAction',
      'Exit. All right (handforhand). ProcessID=' + IntToStr(PID) +
        ', TournamentID=' + IntToStr(FTournamentID),
      ltCall);

    Exit;
  end;

//*****************************
// Next: send resume command
//*****************************
  StartAllProcessAfterBreak(False, False, '', aResponce);

  CommonDataModule.Log(ClassName, 'EndOfHandAction',
    'Exit. All right (resume). ProcessID=' + IntToStr(PID) +
      ', TournamentID=' + IntToStr(FTournamentID),
    ltCall);
end;

procedure TtsTournament.FinishTournament(sExceptUserIDs: string; aResponce: TXMLRespActions;
  SQLAdapter: TSQLAdapter);
var
  I, nPrCnt, nMinCntPrizes: Integer;
  aUsr: TpoTournUser;
  aPrc: TpoTournProcess;
  aPrize: TpoTournPrizeRate;
  aPrizeRateList: TpoTournPrizeRateList;
  sCurrSign, sNonCurrPrize, sRegXML: string;
  nMoney: Currency;
  bIsSatelited: Boolean;
//  aMasterTournament: TtsTournament;
begin
  CommonDataModule.Log(ClassName, 'FinishTournament',
    'Entry', ltCall);

  FRebuyIsAllowed := False;
  FAddOnIsAllowed := False;

  if (FPrizes.Count <= 0) then FPrizes.Add('Default Prize', '$', 'Dollars').SetDefault;

  // winners on finish (prizes)
  SortPlayersOnFinish(FPlayers);

  { send messages about winners before recalculation }
  sCurrSign := FPrizes.Items[0].FCurrencySign; // base prize
  for I:=0 to Players.Count - 1 do begin
    aUsr := Players.Items[I];
    if (aUsr.IsFinished >= 1) then Break;

    sNonCurrPrize := GetNonCurrencyPrizeValue(0, I + 1);
    nMoney := GetPrizeValue(0, I + 1, TotalPrize);

    SendCongratilationNotifyAndMail(aResponce,
      sNonCurrPrize, sCurrSign, nMoney,
      aUsr.FUserID, I + 1
    );
  end;

  // Multy prizes
  for nPrCnt := FPrizes.Count - 1 downto 0 do begin
    aPrizeRateList := FPrizes.Items[nPrCnt];

    nMinCntPrizes := Min(aPrizeRateList.Count, Players.Count);
    for I:=0 to nMinCntPrizes - 1 do begin
      aUsr := Players.Items[I];
      aPrize := aPrizeRateList.Items[I];
      if aUsr.IsFinished = 0 then begin
        if (aUsr.FChipsBeforeLost <= 0) then aUsr.FChipsBeforeLost := aUsr.FChips;
        if (aUsr.FProcessIDOnLost <= 0) then aUsr.FProcessIDOnLost := aUsr.FProcessID;
      end;
      aUsr.FChips := aPrize.PrizeValue(TotalPrize);
      aUsr.FPlace := aPrize.FPlace;
      aUsr.FProcessID := -1;
      aUsr.FLostTime  := 0;
    end;
    // LOST on finish (for any case)
    for I:=aPrizeRateList.Count to Players.Count - 1 do begin
      aUsr := Players.Items[I];
      if aUsr.IsFinished = 0 then begin
        aUsr.SetAsLost(Now, FPlayers.GetActiveCount);
      end;
    end;
    Players.StoreToDB(TournamentID, SQLAdapter);

    // make money transactions
    MakeTournamentMoneyTransactions_SQL(
      aPrizeRateList.FCurrencyTypeID, nPrCnt, SQLAdapter, aResponce
    );
  end;

  // processes on finish
  for I:=0 to Processes.Count - 1 do begin
    aPrc := Processes.Items[I];

    aResponce.Add(
      aPrc.GetCommandToGameEngine(cmdEvent,
        'Tournament is Over. Thank You for Playing.', '',
        eventFinishTournament, sExceptUserIDs,
        0, 0, 0, 0, FActionDispatcherID, 0, nil, nil ),
      -1, -1
    );

    aResponce.Add(
//      aPrc.GetCommandToGameEngine(cmdEnd,
      aPrc.GetCommandToGameEngine(cmdFree,
        '', '', '', '',
//        'Tournament is Over.', '', '',
        Self.Stake, Self.Ante, 0, 0, FActionDispatcherID, 0, nil, nil ),
      -1, -1
    );
    aPrc.FStatusID := pstUnused;
  end;

  { send procclose all winners  }
  for I:=0 to Players.Count - 1 do begin
    aUsr := Players.Items[I];
    if (aUsr.IsFinished >= 1) then Break;
    aUsr.ProcCloseNotify(False, '', aResponce);
  end;

  Processes.StoreToDB(SQLAdapter);
  Processes.Clear;

  // Self
  FTournamentFinishTime := Now;
  FTournamentStatusID := tstCompleted;
  StoreToDB(SQLAdapter);

  // Create new tournament on finish
  bIsSatelited := (FMasterTournamentID > 0) and (FTournamentTypeID = ttpSattelite);
  if Self.IsSitAndGO or ((FTournamentInterval > 0) and not bIsSatelited) then
    InitializeNewOnFinish(SQLAdapter);

  // finish tournament
  FinishTournament_SQL(SQLAdapter, aResponce);

  if bIsSatelited then begin
    for I:=0 to FPlayers.Count - 1 do begin
      aUsr := FPlayers.Items[I];
      if (aUsr.IsFinished > 0) then Break;
      if (aUsr.FChips < (FMasterBuyIn + FMasterFee)) then Continue;

      sRegXML := '<objects><object name="' + OBJ_TOURNAMENT + '">' +
        '<toregister tournamentid="' + IntToStr(FMasterTournamentID) + '" ' +
          'userid="' + IntToStr(aUsr.FUserID) + '" ' +
          'fromtournamentid="' + IntToStr(FTournamentID) + '"/>' +
        '</object></objects>';
      CommonDataModule.ProcessAction(sRegXML);
    end;
  end;
  sRegXML := '';

  CommonDataModule.Log(ClassName, 'FinishTournament',
    'Exit: Tournament finished successfull', ltCall);
end;

function TtsTournament.FinishTournament_SQL(
  SQLAdapter: TSQLAdapter; aResponce: TXMLRespActions): Integer;
var
  nFeeMoney: Currency;
  I, nRegistrationToMaster, IsSatelited: Integer;
  aUser: TpoTournUser;
begin
  CommonDataModule.Log(ClassName, 'FinishTournament_SQL',
    'Entry.', ltCall);

{$IFDEF __TEST__}
	Result := 0;
  Exit;
{$ENDIF}

  Result := 0;
  nFeeMoney := TotalFee;
  IsSatelited := 0;
  if (FMasterTournamentID > 0) and (FTournamentTypeID = ttpSattelite) then begin
    nRegistrationToMaster := 0;
    for I:=0 to FPlayers.Count - 1 do begin
      aUser := FPlayers.Items[I];
      if (aUser.FChips >= (FMasterBuyIn + FMasterFee)) then
        Inc(nRegistrationToMaster);
    end;
    nFeeMoney := nFeeMoney - nRegistrationToMaster * FMasterFee;
    IsSatelited := 1;
  end;

  try
    SQLAdapter.SetProcName('srvtouFinishTournament');
    SQLAdapter.AddParInt('RETURN_VALUE', Result, ptResult);
    SQLAdapter.AddParInt('TournamentID', TournamentID, ptInput);
    SQLAdapter.AddParam('TotalFee', nFeeMoney, ptInput, ftCurrency);
    SQLAdapter.AddParInt('IsSatelited', IsSatelited, ptInput);
    SQLAdapter.AddParam('MasterBuyIn', FMasterBuyIn, ptInput, ftCurrency);
    SQLAdapter.AddParam('MasterFee', FMasterFee, ptInput, ftCurrency);

    SQLAdapter.ExecuteCommand;

    Result := SQLAdapter.GetParam('RETURN_VALUE');
    if Result <> 0 then begin
      CommonDataModule.Log(ClassName, 'FinishTournament_SQL',
      '[EXCEPTION] srvtouFinishTournament return error result=' + IntToStr(Result) +
        '; TournamentID=' + IntToStr(TournamentID),
      ltException);

      StopTournament(SQLAdapter, aResponce);
      Exit;
    end;
  except
    on E: Exception do begin
      CommonDataModule.Log(ClassName, 'FinishTournament_SQL',
      '[EXCEPTION] on execure srvtouFinishTournament raise: ' + E.Message +
        '; TournamentID=' + IntToStr(TournamentID),
      ltException);

      Result := TS_ERR_SQLERROR;
      StopTournament(SQLAdapter, aResponce);
      Exit;
    end;
  end;

  CommonDataModule.Log(ClassName, 'FinishTournament_SQL',
    'Exit: FinishTournament_SQL executed successfull.', ltCall);

end;

procedure TtsTournament.ResittingAllPlayersFromTable(aFromPrc: TpoTournProcess;
  aResponce: TXMLRespActions; SQLAdapter: TSQLAdapter);
var
  I, J: Integer;
  aUsr: TpoTournUser;
  aPrc: TpoTournProcess;
  nRestPrc, nRestUsr, nOptUsr: Integer;
  nCntOnPrc, nCntOnFromPrc: Integer;
  aUsrsIn: TpoTournUserList;
  nNewPlace: Integer;
begin

  if Processes.Count <= 1 then Exit;

  CommonDataModule.Log(ClassName, 'ResittingAllPlayersFromTable',
    'Entry.', ltCall);

  // validate
  if aFromPrc = nil then begin
    CommonDataModule.Log(ClassName, 'ResittingAllPlayersFromTable',
      '[EXCEPTION] Process for resitting is nil', ltException);
    Exit;
  end;
  if Players.CountOnProcess[aFromPrc.FProcessID] = 0 then begin
    CommonDataModule.Log(ClassName, 'ResittingAllPlayersFromTable',
      '[ERROR] Process have not players', ltError);

    FreeProcess(aFromPrc, aResponce);
    Exit;
  end;

  // send changeplace action to GE
  nRestPrc := Processes.Count - 1;
  nRestUsr := ActivePlayers;
  nOptUsr  := GetOptimalRestPlayersPerTable(nRestPrc, nRestUsr);
  nCntOnFromPrc := Players.CountOnProcess[aFromPrc.FProcessID];
  for I:=0 to Processes.Count - 1 do begin
    aPrc := Processes.Items[I];
    if aPrc <> aFromPrc then begin
      nCntOnPrc := Players.CountOnProcess[aPrc.FProcessID];
      if nCntOnPrc < nOptUsr then begin
        aUsrsIn := TpoTournUserList.Create;
        for J:=0 to Min(nOptUsr - nCntOnPrc, nCntOnFromPrc) - 1  do begin
          aUsr := Players.GetFirstUserByProcessID(aFromPrc.FProcessID);
          if aUsr = nil then begin
            CommonDataModule.Log(ClassName, 'ResittingAllPlayersFromTable',
              '[ERROR IN ALGORITHM] Rest of players on processid=' + IntToStr(aFromPrc.FProcessID) +
                ' is less then needing',
              ltError
            );

            // free buffer
            aUsrsIn.Free;
            Exit;
          end;

          nNewPlace := GetFirstEmptyPlaceOnProcess(aPrc.FProcessID);
          if nNewPlace < 0 then begin
            CommonDataModule.Log(ClassName, 'ResittingAllPlayersFromTable',
              '[ERROR IN ALGORITHM] Not free places on resit to processid=' + IntToStr(aPrc.FProcessID),
              ltException
            );

            StopTournament(SQLAdapter, aResponce);
            // free buffer
            aUsrsIn.Free;
            Exit;
          end;

          aUsr.FPlace := nNewPlace;
          aUsr.FProcessID := aPrc.FProcessID;
          aUsrsIn.Add.SetContextByObject(aUsr);

        end;
        // send to GE
        aResponce.Add(
          aPrc.GetCommandToGameEngine(cmdChangePlace,
            'Place is changed. Please Take Your Sit.', '', '', '',
            Self.Stake, Self.Ante, 0, nCntOnPrc, FActionDispatcherID, 0, aUsrsIn, nil ),
          -1, -1
        );
        // send command to lobby (by notification)
        for J:=0 to aUsrsIn.Count - 1 do begin
          aResponce.Add(
            LOBBY_toTournamentEvent(eventChangeTable,
              'Place is changed. Please Take Your Sit.',
              aPrc.FProcessID, aFromPrc.FProcessID, -1, aPrc.Name),
            -1, aUsrsIn.Items[J].FUserID
          );
        end;
        // free buffer
        aUsrsIn.Free;
      end;
      // refresh local data
      nRestPrc := nRestPrc - 1;
      nRestUsr := nRestUsr - Players.CountOnProcess[aPrc.FProcessID];
      nOptUsr  := GetOptimalRestPlayersPerTable(nRestPrc, nRestUsr);
      nCntOnFromPrc := Players.CountOnProcess[aFromPrc.FProcessID];
    end;
  end;

  CommonDataModule.Log(ClassName, 'ResittingAllPlayersFromTable',
    'Exit: All Right.', ltCall);

end;

procedure TtsTournament.FreeProcess(aPrc: TpoTournProcess; aResponce: TXMLRespActions);
begin
  CommonDataModule.Log(ClassName, 'FreeProcess',
    'Entry.', ltCall);

  // validate
  if aPrc = nil then begin
    CommonDataModule.Log(ClassName, 'FreeProcess',
      '[ERROR] Process is nil', ltError);
    Exit;
  end;

  // send command Free to GE
  aResponce.Add(
    aPrc.GetCommandToGameEngine(cmdFree,
// old version      'Sorry, that table no longer exists. Please select another one.', '',
     '', '', '', '', // procclose without show reason window
      Self.Stake, Self.Ante, 0, 0, FActionDispatcherID, 0, nil, nil ),
    -1, -1
  );
end;

function TtsTournament.GetFirstEmptyPlaceOnProcess(
  nProcessID: Integer): Integer;
var
  I: Integer;
  aUsr: TpoTournUser;
begin
  Result := -1;
  for I:=0 to PlayerPerTable - 1 do begin
    aUsr := Players.GetUserByProcessIDAndPlace(nProcessID, I);
    if aUsr = nil then begin
      Result := I;
      Exit;
    end;
  end;
end;

procedure TtsTournament.ResittingRichersPlayersFromTable(
  aFromPrc: TpoTournProcess; CntResitting: Integer;
  aResponce: TXMLRespActions; SQLAdapter: TSQLAdapter);
var
  I: Integer;
  aUsrsBuff, aUsrIn: TpoTournUserList;
  aUsr, aPlayer: TpoTournUser;
  aPrc: TpoTournProcess;
begin
  if Processes.Count <= 1 then Exit;

  CommonDataModule.Log(ClassName, 'ResittingRichersPlayersFromTable',
    'Entry.', ltCall);

  // validate
  if aFromPrc = nil then begin
    CommonDataModule.Log(ClassName, 'ResittingRichersPlayersFromTable',
      '[EXCEPTION] Process for resitting is nil', ltException);
    Exit;
  end;
  if Players.CountOnProcess[aFromPrc.FProcessID] = 0 then begin
    CommonDataModule.Log(ClassName, 'ResittingRichersPlayersFromTable',
      '[ERROR] Process have not players', ltError);

    FreeProcess(aFromPrc, aResponce);
    Exit;
  end;

  // Create Buffer
  aUsrsBuff := TpoTournUserList.Create;
  for I:=0 to Players.Count - 1 do begin
    aUsr := Players.Items[I];
    if aUsr.FProcessID = aFromPrc.FProcessID then begin
      aUsrsBuff.Add.SetContextByObject(aUsr);
    end;
  end;
  // Sort Buffer (descending)
  aUsrsBuff.SortByChips(False);
  // delete from buffer not resitting
  for I:= aUsrsBuff.Count - 1 downto CntResitting do begin
    aUsr := aUsrsBuff.Items[I];
    aUsrsBuff.Del(aUsr);
  end;

  // send changeplace (standUP) action to GE
  aResponce.Add(
    aFromPrc.GetCommandToGameEngine(cmdChangePlace, '', '', '', '',
      Self.Stake, Self.Ante, 0, Players.CountOnProcess[aFromPrc.FProcessID],
      FActionDispatcherID, 0, nil, aUsrsBuff),
    -1, -1
  );
  // send changeplace (sitdown) action to GE
  for I:=aUsrsBuff.Count - 1 downto 0 do begin
    aPrc := SeekMinCountPlayersProcess(aFromPrc.FProcessID);
    // validate
    if aPrc = nil then begin
      CommonDataModule.Log(ClassName, 'ResittingRichersPlayersFromTable',
        '[ERROR] SeekMinCountPlayersProcess function return nil.', ltException
      );

      StopTournament(SQLAdapter, aResponce);
      aUsrsBuff.Free;
      Exit;
    end;

    aUsr := aUsrsBuff.Items[I];
    aUsr.FProcessID := aPrc.FProcessID;
    aUsr.FPlace := GetFirstEmptyPlaceOnProcess(aPrc.FProcessID);

    // buffer for sitdown
    aUsrIn := TpoTournUserList.Create;
    aUsrIn.Add.SetContextByObject(aUsr);

    // send command to GE
    aResponce.Add(
      aPrc.GetCommandToGameEngine(cmdChangePlace,
        'Place is changed. Please Take Your Sit.', '', '', '',
        Self.Stake, Self.Ante, 0, Players.CountOnProcess[aPrc.FProcessID],
        FActionDispatcherID, 0, aUsrIn, nil),
      -1, -1
    );

    aUsrIn.Free;

    // send to lobby (by notification)
    aResponce.Add(
      LOBBY_toTournamentEvent(eventChangeTable,
        'Place is changed. Please Take Your Sit.',
        aUsr.FProcessID, aFromPrc.FProcessID, -1, aPrc.Name),
      -1, aUsr.FUserID
    );

    // set new data
    aPlayer := Players.GetUserByID(aUsr.FUserID);
    aPlayer.FPlace := aUsr.FPlace;
    aPlayer.FProcessID := aUsr.FProcessID;
  end;

  // Free Buffer
  aUsrsBuff.Free;

  CommonDataModule.Log(ClassName, 'ResittingRichersPlayersFromTable',
    'Exit. All Right', ltCall);
end;

function TtsTournament.SeekMinCountPlayersProcess(
  NotUseProcessID: Integer): TpoTournProcess;
var
  I: Integer;
  aPrc: TpoTournProcess;
  CntTop, ITop: Integer;
begin
  Result := nil;
  if Processes.Count <= 0 then Exit;

  Result := Processes.Items[0];
  ITop := 1;
  if Result.FProcessID = NotUseProcessID then begin
    Result := nil;
    if Processes.Count <= 1 then Exit;

    Result := Processes.Items[1];
    ITop := 2;
  end;
  CntTop := Players.CountOnProcess[Result.FProcessID];

  for I:=ITop to Processes.Count - 1 do begin
    aPrc := Processes.Items[I];
    if aPrc.FProcessID = NotUseProcessID then Continue;

    if Players.CountOnProcess[aPrc.FProcessID] < CntTop then begin
      Result := aPrc;
      CntTop := Players.CountOnProcess[Result.FProcessID];
    end;
  end;
end;

function TtsTournament.toGetPlayers_LOBBY_XML: string;
var
  I, MemoPlace: Integer;
  aUser, aPl: TpoTournUser;
  aPlayUsers, aLostUsers: TpoTournUserList;
begin
// *****************************
// WARNING: it is not XML
// *****************************

  Result := '';

  // Create buffer
  aPlayUsers := TpoTournUserList.Create;
  aLostUsers := TpoTournUserList.Create;

  // Filling buffers
  //--------------------------------------------
  for I := 0 to Players.Count - 1 do begin
    aPl := Players.Items[I];
    if aPl.IsFinished = 0 then begin
      aUser := aPlayUsers.Add;
      aUser.SetContextByObject(aPl);
    end else begin
      aUser := aLostUsers.Add;
      aUser.SetContextByObject(aPl);
    end;
  end;

  aPlayUsers.SortByChips(False);
  aLostUsers.SortByLostTime(False);

  // Filling XML for playing users before
  for I := 0 to aPlayUsers.Count - 1 do begin
    aUser := aPlayUsers.Items[I];
    aUser.FPlace := I + 1;
    Result := Result + aUser.toGetPlayers_LOBBY_XML;
  end;
  MemoPlace := aPlayUsers.Count;
  aPlayUsers.Clear;
  aPlayUsers.Free;

  // Filling XML, for lost players
  for I := 0 to aLostUsers.Count - 1 do begin
    aUser := aLostUsers.Items[I];
    aUser.Place := I + 1 + MemoPlace;
    Result := Result + aUser.toGetPlayers_LOBBY_XML;
  end;
  aLostUsers.Clear;
  aLostUsers.Free;
end;

function TtsTournament.toGetProcessPlayers_LOBBY_XML(
  const ProcessID: Integer): string;
var
  I: Integer;
  aUser: TpoTournUser;
  aPl: TpoTournUser;
  aFilteredUsers: TpoTournUserList;
begin
// *****************************
// WARNING: it is not XML
// *****************************

  Result := '';

  // Create Buffer
  aFilteredUsers := TpoTournUserList.Create;
  // Filling buffer, filtered on ProcessID
  for I := 0 to Players.Count - 1 do begin
    aPl := Players.Items[I];
    if ProcessID = aPl.FProcessID then begin
      aUser := aFilteredUsers.Add;
      aUser.SetContextByObject(aPl);
    end;
  end;

  // Filling XML
  aFilteredUsers.SortByPlace(True);
  for I := 0 to aFilteredUsers.Count - 1 do begin
    aUser := aFilteredUsers.Items[I];
    Result := Result + aUser.toGetProcessPlayers_LOBBY_XML(ProcessID);
  end;

  // dispose buffer
  aFilteredUsers.Free;
end;



procedure TtsTournament.CheckOfResitingPlayersFromProcess(
  WasHandForHand: Boolean; aProcess: TpoTournProcess;
  aResponce: TXMLRespActions; SQLAdapter: TSQLAdapter);
var
  nRealPl, nOptPl: Integer;
begin
  // No waiting process can not be resiting
  if not aProcess.IsWaiting then Exit;

  CommonDataModule.Log(ClassName, 'ChecnOfResitingPlayersFromProcess',
    'Entry. ProcessID=' + IntToStr(aProcess.FProcessID) +
      ', TournamentID=' + IntToStr(FTournamentID),
    ltCall);

  if Self.OptimalTables < Processes.Count then begin
    // need resitting all players from table to another
    ResittingAllPlayersFromTable(aProcess, aResponce, SQLAdapter);

    // delete process
    if not Self.IsStopped then begin
      // send command free to GE
      aResponce.Add(
        aProcess.GetCommandToGameEngine(cmdFree,
//old          'The Table has been closed.', '',
          'The Table has been closed.', '', '', '', // without show reason window
          Self.Stake, Self.Ante, 0, 0, FActionDispatcherID, 0, nil, nil ),
        -1, -1
      );
      aProcess.StatusID := pstUnused;
      aProcess.StoreToDB(TournamentID, SQLAdapter);
      Processes.Del(aProcess);
    end;

    if WasHandForHand and not Self.IsHandForHand then begin
      StartAllProcessAfterBreak(False, True, '', aResponce);
    end;

    CommonDataModule.Log(ClassName, 'ChecnOfResitingPlayersFromProcess',
      'Exit. All right (Free table). ProcessID=' + IntToStr(aProcess.FProcessID) +
        ', TournamentID=' + IntToStr(FTournamentID),
      ltCall);

    Exit; // Hand for Hand not use in this case
  end else begin
    nRealPl := Players.CountOnProcess[aProcess.FProcessID];
    nOptPl  := Self.OptimalMaxPlayersPerTable;
    if (nRealPl > nOptPl) then begin
      // resit richers players
      ResittingRichersPlayersFromTable(aProcess, (nRealPl-nOptPl),
        aResponce, SQLAdapter);
    end;
  end;

  CommonDataModule.Log(ClassName, 'ChecnOfResitingPlayersFromProcess',
    'Exit. All right. ProcessID=' + IntToStr(aProcess.FProcessID) +
      ', TournamentID=' + IntToStr(FTournamentID),
    ltCall);
end;

procedure TtsTournament.StartAllProcessAfterBreak(NeedCheckWaitings, NeedSendEndBreak: Boolean;
  sMsg: String; aResponce: TXMLRespActions);
var
  I: Integer;
  aPrc: TpoTournProcess;
  sText: string;
begin
  if Self.IsBreak or Self.IsPauseByAdmin then Exit;

  if NeedCheckWaitings then
    if Processes.WatingCount < Processes.Count then Exit;

  // Restart all Processes after break
  for I:=0 to Processes.Count - 1 do begin
    aPrc := Processes.Items[I];
    if not aPrc.IsWaiting then Continue;
    if (Players.CountOnProcess[aPrc.ProcessID] <= 1) then Continue;

    if sMsg = '' then begin
      sText := '';
      if aPrc.FLevel <> FTournamentLevel then sText := 'Level up. ';
      sText := sText + 'Current level is ' + IntToStr(FTournamentLevel) + '.';
    end else begin
      sText := sMsg;
    end;

    // set data
    aPrc.FLevel := FTournamentLevel;
    aPrc.FStartResumeTime := Now;
    aPrc.StatusID := pstRunning;

    if NeedSendEndBreak then begin
    aResponce.Add(
        aPrc.GetCommandToGameEngine(cmdEvent,
          '', '', eventEndBreak, '', -1, -1, 0, 0, FActionDispatcherID,
          0, nil, nil
        ),
      -1, -1
    );
    end;

    aResponce.Add(
      aPrc.GetCommandToGameEngine(cmdResume, sText, '', '', '',
        Self.Stake, Self.Ante, 0, Players.CountOnProcess[aPrc.FProcessID],
        FActionDispatcherID, 0, nil, nil
      ),
      -1, -1
    );
  end;
end;

procedure TtsTournament.SortPlayersOnFinish(aPlayers: TpoTournUserList);
var
  TopInd: Integer;
  I, J: Integer;
  aUser: TpoTournUser;
  aItm: TpoTournUser;
  aPlayUsrs: TpoTournUserList;
  aLostUsrs: TpoTournUserList;
begin
  // Create Buffers
  aPlayUsrs := TpoTournUserList.Create;
  aLostUsrs := TpoTournUserList.Create;

  for I := 0 to aPlayers.Count - 1 do begin
    aUser := aPlayers.Items[I];
    if aUser.IsFinished = 1 then begin
      aLostUsrs.Add.SetContextByObject(aUser);
    end else begin
      aPlayUsrs.Add.SetContextByObject(aUser);
    end;
  end;
  aPlayers.Clear;

  aPlayUsrs.SortByChips(False);

  // Sort Lost Users by date & chips & FMemPlace
  with aLostUsrs do begin
    for I := 0 to Count - 1 do
    begin
      TopInd := I;

      // search next top index
      for J := I+1 to Count - 1 do
      begin
        aUser := Items[J];

        aItm := Items[TopInd];
        if (aItm.FLostTime < aUser.FLostTime) then begin
          TopInd := IndexOf(aUser);
        end else
        if (aItm.FLostTime = aUser.FLostTime) and
           (aItm.FChips < aUser.FChips)
        then begin
          TopInd := IndexOf(aUser);
        end else
        if (aItm.FLostTime = aUser.FLostTime) and
           (aItm.FChips = aUser.FChips) and
           (aItm.FChipsBeforeLost < aUser.FChipsBeforeLost)
        then begin
          TopInd := IndexOf(aUser);
        end else
        if (aItm.FLostTime = aUser.FLostTime) and
           (aItm.FChips = aUser.FChips) and
           (aItm.FChipsBeforeLost = aUser.FChipsBeforeLost) and
           (aItm.FMemPlace > aUser.FMemPlace)
        then begin
          TopInd := IndexOf(aUser);
        end;
      end;

      // swap
      if (TopInd <> I) then begin
        aUser := TpoTournUser.Create;
        aUser.SetContextByObject(Items[TopInd]);
        Items[TopInd].SetContextByObject(Items[I]);
        Items[I].SetContextByObject(aUser);
        aUser.Free;
      end;
    end;
  end; // with

  for I:=0 to aPlayUsrs.Count - 1 do begin
    aUser := aPlayUsrs.Items[I];
    aPlayers.Add.SetContextByObject(aUser);
  end;
  aPlayUsrs.Free;

  for I:=0 to aLostUsrs.Count - 1 do begin
    aUser := aLostUsrs.Items[I];
    aPlayers.Add.SetContextByObject(aUser);
  end;
  aLostUsrs.Free;
end;

procedure TtsTournament.InitializeNewOnFinish(SQLAdapter: TSQLAdapter);
var
  NewStartTime, NewRegistrationTime: TDateTime;
  NewTournamentID, nInterval: Integer;
  Res: Integer;
  aNewTrn: TtsTournament;
  Packet: string;
begin
  CommonDataModule.Log(ClassName, 'InitializeNewOnFinish', 'Entry.', ltCall);

  // define registration and start time for new tournament
  nInterval := FTournamentInterval;
  if not Self.IsSitAndGO then begin
    NewRegistrationTime := IncDay(FRegistrationStartTime, nInterval);
    if NewRegistrationTime <= Now then begin
      while NewRegistrationTime <= Now do begin
        NewRegistrationTime := IncDay(NewRegistrationTime, 1);
        Inc(nInterval);
      end;
    end;
    NewStartTime := IncDay(FTournamentStartTime, nInterval);
  end else begin
    NewRegistrationTime := IncMinute(Now, PropDef_RegistrationTimeShift);
    NewStartTime := IncMinute(Now, PropDef_TournamentStartShift);
  end;

  // clone new tournament data
  Res := InitializeNewOnFinish_SQL(NewStartTime, SQLAdapter, NewTournamentID);
  if Res <> 0 then begin
    CommonDataModule.Log(ClassName, 'InitializeNewOnFinish',
      '[ERROR] On execute InitializeNewOnFinish_SQL; Result = ' + IntToStr(Res),
      ltError);
    Exit;
  end;

  // create and filling
  aNewTrn := TtsTournament.Create(NewTournamentID, FOwner);
  try
    aNewTrn.SetContextByObject(Self);
    // reseting properties for clone tournament
    aNewTrn.TournamentID := NewTournamentID;
    aNewTrn.FRegistrationStartTime := NewRegistrationTime;
    aNewTrn.FTournamentFinishTime := 0;
    aNewTrn.FTournamentStartTime := NewStartTime;
    aNewTrn.FNextBreakTime := 0;
    aNewTrn.FNextLevelTime := 0;
    aNewTrn.FStartKickOffNotTakedSit := 0; // disable while not started
    aNewTrn.FStatusID := 1;
    aNewTrn.FRebuyIsAllowed := FRebuyWasAllowedOnCreate;
    aNewTrn.FRebuyWasAllowedOnCreate := FRebuyWasAllowedOnCreate;
    aNewTrn.FAddOnIsAllowed := False;
    aNewTrn.FAddOnWasAllowedOnCreate := FAddOnWasAllowedOnCreate;
    aNewTrn.FPauseCount := 0;
    aNewTrn.FTournamentStatusID := tstAnnouncing;
    aNewTrn.FTournamentLevel := 0;
    //
    aNewTrn.FPrizes.Clear;
    aNewTrn.FBettings.Clear;
    aNewTrn.FPlayers.Clear;
    aNewTrn.FProcesses.Clear;

    // store context into DB
    aNewTrn.StoreToDB(SQLAdapter);

    // initialization in list structure
    Packet :=
      '<objects>' +
        '<object name="' + OBJ_TOURNAMENT + '" id="0">' +
          '<tsinittournament tournamentid="' + IntToStr(aNewTrn.FTournamentID) + '" ' +
            'actiondispatcherid="' + IntToStr(aNewTrn.FActionDispatcherID) + '"/>' +
        '</object>' +
      '</objects>';
    CommonDataModule.ProcessAction(Packet);
  finally
    aNewTrn.Free;
  end;

  CommonDataModule.Log(ClassName, 'InitializeNewOnFinish',
    'Exit. New tournament was created successfull.', ltCall);
end;

function  TtsTournament.InitializeNewOnFinish_SQL(NewStartTime: TDateTime; SQLAdapter: TSQLAdapter;
  var NewTournamentID: Integer): Integer;
var
  StrNewStartTime: string;
begin
  CommonDataModule.Log(ClassName, 'InitializeNewOnFinish_SQL',
    'Entry.', ltCall);

	Result := 0;
{$IFDEF __TEST__}
  NewTournamentID := TournamentID + 1;
  Exit;
{$ENDIF}
  StrNewStartTime := DateTimeToODBCStr(NewStartTime);
  try
    SQLAdapter.SetProcName('srvtouCloneTournamentOnFinish');

    SQLAdapter.AddParInt('RETURN_VALUE', Result, ptResult);
    SQLAdapter.AddParInt('TournamentID', TournamentID, ptInput);
    SQLAdapter.AddParString('NewStartTime', StrNewStartTime, ptInput);
    SQLAdapter.AddParInt('NewTournamentID', NewTournamentID, ptOutput);
    SQLAdapter.AddParInt('ActionDispatcherID', FActionDispatcherID, ptOutput);

    SQLAdapter.ExecuteCommand;

    Result := SQLAdapter.GetParam('RETURN_VALUE');
    if Result <> 0 then begin
      CommonDataModule.Log(ClassName, 'InitializeNewOnFinish_SQL',
      '[EXCEPTION] srvtouCloneTournamentOnFinish return error result=' + IntToStr(Result) +
        '; TournamentID=' + IntToStr(TournamentID),
      ltException);

      Exit;
    end;

    NewTournamentID := SQLAdapter.GetParam('NewTournamentID');

  except
    on E: Exception do begin
      CommonDataModule.Log(ClassName, 'InitializeNewOnFinish_SQL',
      '[EXCEPTION] on execure srvtouCloneTournamentOnFinish raise: ' + E.Message +
        '; TournamentID=' + IntToStr(TournamentID),
      ltException);

      Result := TS_ERR_SQLERROR;
      Exit;
    end;
  end;

  CommonDataModule.Log(ClassName, 'InitializeNewOnFinish_SQL',
    'Exit: InitializeNewOnFinish_SQL executed successfull.', ltCall);
end;

function TtsTournament.MakeTournamentMoneyTransactions_SQL(CurrTypeID, CntExec: Integer;
  SQLAdapter: TSQLAdapter; aResponce: TXMLRespActions): Integer;
var
  IsSatelited: Integer;
begin
  CommonDataModule.Log(ClassName, 'MakeTournamentMoneyTransactions_SQL',
    'Entry.', ltCall);

{$IFDEF __TEST__}
	Result := 0;
  Exit;
{$ENDIF}

  Result := 0;

  IsSatelited := 0;
  if (FMasterTournamentID > 0) and (FTournamentTypeID = ttpSattelite) then
  IsSatelited := 1;

  try
    SQLAdapter.SetProcName('srvtouMakeMoneyTransactions');
    SQLAdapter.AddParInt('RETURN_VALUE', Result, ptResult);
    SQLAdapter.AddParInt('TournamentID', TournamentID, ptInput);
    SQLAdapter.AddParam('TotalFee', TotalFee, ptInput, ftCurrency);
    SQLAdapter.AddParInt('CurrencyTypeID', CurrTypeID, ptInput);
    SQLAdapter.AddParam('Fee', FFee, ptInput, ftCurrency);
    SQLAdapter.AddParam('BuyIn', FBuyIn, ptInput, ftCurrency);
    SQLAdapter.AddParInt('IsSatelited', IsSatelited, ptInput);
    SQLAdapter.AddParam('MasterBuyIn', FMasterBuyIn, ptInput, ftCurrency);
    SQLAdapter.AddParam('MasterFee', FMasterFee, ptInput, ftCurrency);
    SQLAdapter.AddParInt('CountOfExecute', CntExec, ptInput);

    SQLAdapter.ExecuteCommand;

    Result := SQLAdapter.GetParam('RETURN_VALUE');
    if Result <> 0 then begin
      CommonDataModule.Log(ClassName, 'MakeTournamentMoneyTransactions_SQL',
      '[EXCEPTION] srvtouMakeMoneyTransactions return error result=' + IntToStr(Result) +
        '; TournamentID=' + IntToStr(TournamentID),
      ltException);

      StopTournament(SQLAdapter, aResponce);
      Exit;
    end;
  except
    on E: Exception do begin
      CommonDataModule.Log(ClassName, 'MakeTournamentMoneyTransactions_SQL',
      '[EXCEPTION] on execure srvtouMakeMoneyTransactions raise: ' + E.Message +
        '; TournamentID=' + IntToStr(TournamentID),
      ltException);

      Result := TS_ERR_SQLERROR;
      StopTournament(SQLAdapter, aResponce);
      Exit;
    end;
  end;

  CommonDataModule.Log(ClassName, 'MakeTournamentMoneyTransactions_SQL',
    'Exit: FinishTournament_SQL executed successfull.', ltCall);
end;

function TtsTournament.GetNumberOfPlayersForFinish: Integer;
begin
  Result := Prizes.GetNumberOfPlayersForFinish;
end;

function TtsTournament.KickOffUser(aInpAction: TXMLAction): Integer;
var
  Msg: string;
  nUserID: Integer;
  sGuid: string;
begin
  nUserID := aInpAction.UserID;
  sGuid   := aInpAction.Guid;

  CommonDataModule.Log(ClassName, 'KickOffUser', 'Entry with params: UserID=' + IntToStr(nUserID), ltCall);

  Result := KickOffUserByID(nUserID, nil, Msg);

  Msg :=
    '<admtournamentkickoff' +
      ' tournamentid="' + IntToStr(TournamentID) + '"' +
      ' userid="' + IntToStr(nUserID) + '"' +
      ' result="' + IntToStr(Result)  + '"' +
      ' msg="' + Msg + '"' +
      ' guid="' + sGuid + '"' +
    '/>';
  if sGuid <> '' then begin
{$IFDEF __TEST__}
    fMain.MemoOutput.Lines.Add('***************************************');
    fMain.MemoOutput.Lines.Add(FormatXMLData(Msg));
{$ELSE}
    CommonDataModule.SendAdminMSMQ(Msg, sGuid);
{$ENDIF}
  end;

  { notify user }
  Msg := 'You has been kick off from multy tournament (' + Name + ') by administrator.';
  Msg :=
    '<object name="session">' +
      '<message msg="' + Msg + '"/>' +
    '</object>';

{$IFDEF __TEST__}
  fMain.MemoOutput.Lines.Add('***************************************');
  fMain.MemoOutput.Lines.Add(FormatXMLData(Msg));
{$ELSE}
  if (Result = 0) then CommonDataModule.NotifyUserByID(nUserID, Msg);
{$ENDIF}

  CommonDataModule.Log(ClassName, 'KickOffUser', 'Entry with params: UserID=' + IntToStr(nUserID), ltCall);
end;

function TtsTournament.PauseByAdmin(aInpAction: TXMLAction;
  aRespActions: TXMLRespActions; aSql: TSQLAdapter): Integer;
begin
  Result := 0;
  if Self.IsCompleted or Self.IsStopped then begin
    Exit;
  end;

  if not (Self.IsRunning  or
          Self.IsBreak    or
          Self.IsResuming or
          Self.IsHandForHand
         ) or Self.IsPauseByAdmin
  then begin
    Result := 1;
    Exit;
  end;

  FPrevTournamentStatusID := FTournamentStatusID;
  FStartPauseByAdmin := Now;
  FTournamentStatusID := tstAdminPause;

  { store into DB }
  Result := StoreToDB(aSql);
end;

procedure TtsTournament.SetStartPauseByAdmin(const Value: TDateTime);
begin
  FStartPauseByAdmin := Value;
end;

function TtsTournament.EndPauseByAdmin(aInpAction: TXMLAction;
  aRespActions: TXMLRespActions; aSql: TSQLAdapter): Integer;
var
  nPauseSeconds: Integer;
begin
  Result := 0;
  if Self.IsCompleted or Self.IsStopped or (not Self.IsPauseByAdmin) then begin
    Exit;
  end;

  { shift datetime event }
  nPauseSeconds := SecondsBetween(FStartPauseByAdmin, Now);
  case FPrevTournamentStatusID of
    tstAnnouncing, tstRegistration:
    begin
      FRegistrationStartTime := IncSecond(FRegistrationStartTime, nPauseSeconds);
      FTournamentStartTime   := IncSecond(FTournamentStartTime, nPauseSeconds);
    end;
    tstSitting: FTournamentStartTime := IncSecond(FTournamentStartTime, nPauseSeconds);
  else
    FNextBreakTime   := IncSecond(FNextBreakTime, nPauseSeconds);
    FNextLevelTime   := IncSecond(FNextLevelTime, nPauseSeconds);
  end;
  if (FStartKickOffNotTakedSit > 0) then
    FStartKickOffNotTakedSit := IncSecond(FStartKickOffNotTakedSit, nPauseSeconds);
  FStartPauseByAdmin := 0;
  FTournamentStatusID := FPrevTournamentStatusID;
  FPrevTournamentStatusID := 0;

  { Resume processes }
  StartAllProcessAfterBreak(False, False,
    'Resume after pause by admin. Current level is ' + IntToStr(FTournamentLevel),
    aRespActions
  );

  { store into DB }
  Result := StoreToDB(aSql);
end;

procedure TtsTournament.SetMaxRegisteredLimit(const Value: Integer);
begin
  FMaxRegisteredLimit := Value;
end;

function TtsTournament.GetIsSitAndGO: Boolean;
begin
  Result := (FMaxRegisteredLimit > 0) and (FTournamentCategory = tsCategorySitAndGo);
end;

procedure TtsTournament.SetBettings(const Value: TpoTournBettingList);
begin
  FBettings := Value;
end;

function TtsTournament.GetAnte: Currency;
begin
  Result := FBettings.Ante[FTournamentLevel];
end;

procedure TtsTournament.SetTournamentStartEvent(const Value: Integer);
begin
  FTournamentStartEvent := Value;
end;

procedure TtsTournament.SetActionDispatcherID(const Value: Integer);
begin
  FActionDispatcherID := Value;
end;

procedure TtsTournament.SetTournamentCategory(const Value: Integer);
begin
  FTournamentCategory := Value;
end;

function TtsTournament.EndPauseByAdminOnCreate(aSql: TSQLAdapter): Integer;
var
  nPauseSeconds: Integer;
begin
  Result := 0;
  if Self.IsCompleted or Self.IsStopped or (not Self.IsPauseByAdmin) then begin
    Exit;
  end;

  { shift datetime event }
  nPauseSeconds := SecondsBetween(FStartPauseByAdmin, Now);
  case FPrevTournamentStatusID of
    tstAnnouncing, tstRegistration:
    begin
      FRegistrationStartTime := IncSecond(FRegistrationStartTime, nPauseSeconds);
      FTournamentStartTime   := IncSecond(FTournamentStartTime, nPauseSeconds);
    end;
  end;
  if (FStartKickOffNotTakedSit > 0) then
    FStartKickOffNotTakedSit := IncSecond(FStartKickOffNotTakedSit, nPauseSeconds);
  FStartPauseByAdmin := 0;
  FTournamentStatusID := FPrevTournamentStatusID;
  FPrevTournamentStatusID := 0;

  { store into DB }
  Result := StoreToDB(aSql);
end;

function TtsTournament.PauseByAdminOnDestroy(aSql: TSQLAdapter): Integer;
begin
  Result := 0;
  if Self.IsCompleted or Self.IsStopped then begin
    Exit;
  end;

  if not (Self.IsAnnouncing or Self.IsRegistration)
  then begin
    Result := 1;
    Exit;
  end;

  FPrevTournamentStatusID := FTournamentStatusID;
  FStartPauseByAdmin := Now;
  FTournamentStatusID := tstAdminPause;

  { store into DB }
  Result := StoreToDB(aSql);
end;

function TtsTournament.GetPrizeValue(PrizeNumber, Place: Integer; TotalPrize: Currency): Currency;
var
  aPrize: TpoTournPrizeRate;
begin
  aPrize := FPrizes.Items[PrizeNumber].ItemsByPlace(Place);
  if aPrize = nil then
    Result := 0
  else
    Result := aPrize.PrizeValue(TotalPrize);
end;

function TtsTournament.GetNonCurrencyPrizeValue(PrizeNumber, Place: Integer): string;
var
  aPrize: TpoTournPrizeRate;
begin
  aPrize := FPrizes.Items[PrizeNumber].ItemsByPlace(Place);
  if aPrize = nil then
    Result := ''
  else
    Result := aPrize.FNonCurrencyPrize;
end;

procedure TtsTournament.SendCongratilationNotifyAndMail(aResponce: TXMLRespActions;
  sNonCurrPrize, sCurSign: string; nMoney: Currency; nUserID, nPlace: Integer);
var
  sMsg: string;
  aEMail: TEMail;
  aUsr: TpoTournUser;
begin
  sMsg := 'Congratulations! You ended in the ' + PlaceAsString(nPlace) + ' pisition';
  if (nMoney > 0) and (sNonCurrPrize = '') then begin
    sMsg := sMsg +
      ' and will be awarded a prize of ' +
      sCurSign + CurrToStr(nMoney);
  end else
  if (nMoney > 0) and (sNonCurrPrize <> '') then begin
    sMsg := sMsg +
      ' and will be awarded a prize of ' +
      sCurSign + CurrToStr(nMoney) +
      ' and ' + sNonCurrPrize;
  end else
  if (nMoney <= 0) and (sNonCurrPrize <> '') then begin
    sMsg := sMsg +
      ' and will be awarded a prize of ' + sNonCurrPrize;
  end;
    sMsg := sMsg + '!';

  { Response to Lobby }
  aResponce.Add(
    LOBBY_toTournamentEvent(eventCongratulations, sMsg, -1, -1, -1, ''),
    -1, nUserID
  );

  { Send Email to admin }
  if (sNonCurrPrize <> '') then begin
    aEMail := CommonDataModule.ObjectPool.GetEmail;
    aUsr := FPlayers.GetUserByID(nUserID);
    sMsg := 'User "' + aUsr.FLoginName + '" with UserID="' + IntToStr(nUserID) + '" awarded a "' + sNonCurrPrize + '" for ' + PlaceAsString(nPlace) + ' pisition of "' + FName + '" multi-tournay.<br>';

    try
      aEMail.SendAdminEmail(-1, nUserID, 'Multi-tournay prize report - "' + aUsr.FLoginName + '"', sMsg);
    finally
      CommonDataModule.ObjectPool.FreeEmail(aEMail);
    end;
  end;
end;

function TtsTournament.StartRegistration(aActions: TXMLRespActions): Integer;
begin
  FTournamentStatusID := tstRegistration;
  StartAutosave;
  AutoRegistrationFromSatelited;
  Result := 0;
end;

procedure TtsTournament.Execute;
begin
  while (FActions.Count > 0) do begin
    FActions.Item[0].SendAction;
    FActions.Del(Actions.Item[0]);
  end;
end;

procedure TtsTournament.AutoRegistrationFromSatelited;
var
  I, nRes: Integer;
  nUserID, nTouID: Integer;
  sRegXML: string;
  //
  FSql: TSQLAdapter;
  RS: TDataSet;
  aUsers: TpoTournUserList;
  aUsr: TpoTournUser;
begin
  RS := nil;

{$IFDEF __TEST__}
  FSQL := nil;
  Exit;
{$ELSE}
  FSQL := CommonDataModule.ObjectPool.GetSQLAdapter;
{$ENDIF}
  try
    // stored procedure srvtouGetTournaments
    FSql.SetProcName('srvtouOnStartRegistration');
    FSql.AddParam('RETURN_VALUE', 0, ptResult, ftInteger);
    FSql.AddParInt('TournamentID', FTournamentID, ptInput);
    FSql.AddParam('BuyIn', FBuyIn, ptInput, ftCurrency);
    FSql.AddParam('Fee', FFee, ptInput, ftCurrency);

    RS := FSql.ExecuteCommand;

    nRes := FSql.GetParam('RETURN_VALUE');
    if (nRes <> 0) then begin
      CommonDataModule.Log(ClassName, 'AutoRegistrationFromSatelited',
        '[ERROR] On execute srvtouOnStartRegistration: TournamentID=' + IntToStr(FTournamentID),
        ltError
      );
      Exit;
    end;

    if RS.Eof then Exit;

    aUsers := TpoTournUserList.Create;
    while not RS.Eof do begin
      nUserID := RS.FieldByName('UserID').AsInteger;
      nTouID  := RS.FieldByName('TournamentID').AsInteger;

      aUsr := aUsers.GetUserByID(nUserID);
      if (aUsr = nil) then begin
        aUsr := aUsers.Add;
        aUsr.FUserID    := nUserID;
        aUsr.FProcessID := nTouID;
      end;

      RS.Next;
    end;

    for I:=0 to aUsers.Count - 1 do begin
      aUsr := aUsers.Items[I];
      sRegXML := '<objects><object name="' + OBJ_TOURNAMENT + '">' +
        '<toregister tournamentid="' + IntToStr(FTournamentID) + '" ' +
          'userid="' + IntToStr(aUsr.FUserID) + '" ' +
          'fromtournamentid="' + IntToStr(aUsr.FProcessID) + '"/>' +
        '</object></objects>';
      CommonDataModule.ProcessAction(sRegXML);
    end;

    aUsers.Clear;
    aUsers.Free;
  finally
    if RS <> nil then RS.Close;
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  end;
end;

procedure TtsTournament.SetPassword(const Value: string);
begin
  FPassword := Value;
end;

function TtsTournament.GetTypesForLobby: string;
begin
  Result := '';
  if not Self.IsSitAndGO then begin
    if (FTournamentTypeID = ttpRegular) then
      Result := Result + '1,'; // is regular
    if (FTournamentTypeID = ttpSattelite) then
      Result := Result + '2,'; // is satelited
    // special was undefined (3)
    if (FBuyIn + FFee <= 0) then
      Result := Result + '4,'; // is freeroll
    if (FCurrencyTypeID = 4) then
      Result := Result + '5,'; // is loyaltypoitns
    if (FTournamentTypeID = ttpRestricted) then
      Result := Result + '6,'; // is private
  end else begin
    if (FMaxRegisteredLimit <= FPlayerPerTable) then
      Result := Result + '7,' // is 1-Table
    else if (FMaxRegisteredLimit <= (2 * FPlayerPerTable)) then
      Result := Result + '8,'; // is 2-Table
    if (FMaxRegisteredLimit = 2) then
      Result := Result + '9,'; // is HeadsUp
    if (FTournamentTypeID = ttpSattelite) then
      Result := Result + '2,'; // is satelited
    if (FCurrencyTypeID = 4) then
      Result := Result + '5,'; // is loyaltypoitns
    if (FCurrencyTypeID = 1) then
      Result := Result + '10,'; // is play money
  end;

  if Result = '' then
    Result := ',0,'
  else
    Result := ',' + Result;
end;

procedure TtsTournament.SetCurrencySign(const Value: string);
begin
  FCurrencySign := Value;
end;

procedure TtsTournament.SetCurrencyName(const Value: string);
begin
  FCurrencyName := Value;
end;

function TtsTournament.BotGetTournamentInfo: string;
var
  I: Integer;
  aUser: TpoTournUser;
  nProcessID: Integer;
begin
  Result := '';
  for I:=0 to FPlayers.Count - 1 do begin
    aUser := FPlayers.Items[I];
    if not aUser.FIsBot then Continue;

    nProcessID := aUser.FProcessID;
    if (nProcessID <= 0) then nProcessID := 0;

    Result := Result +
      '<bot ' +
        'id="' + IntToStr(aUser.FBotID) + '" ' +
        'loginname="' + aUser.FLoginName + '" ' +
        'type="' + IntToStr(Integer(aUser.FBotCharacter)) + '" ' +
        'processid="' + IntToStr(nProcessID) + '"' +
      '/>';
  end;
end;

function TtsTournament.BotsRegister(nBotCharacter, nBotPerProcess: Integer;
  SqlAdapter: TSQLAdapter; var errCode: Integer): string;
begin
  Result := '';
  errCode := 0;

  if not Self.IsRegistration then begin
    CommonDataModule.Log(ClassName, 'BotsRegister',
      'Tournament have not status Registering; Params: TournamentID=' + IntToStr(TournamentID),
      ltCall);

    errCode := 1;
    Result :=
      '<' + anBot_Sitdown + ' result="1" message="Tournament has not status registering."/>';

    Exit;
  end;
  if Self.IsSitAndGO and (Players.Count >= FMaxRegisteredLimit) then begin
    CommonDataModule.Log(ClassName, 'BotsRegister',
      'Maximum registered is allowed; Params: TournamentID=' + IntToStr(TournamentID),
      ltCall);

    ErrCode := TS_ERR_MAXIMUMREGISTEREDALLOWED;
    Result :=
      '<' + anBot_Sitdown + ' result="' + IntToStr(ErrCode) + '" message="Maximum registered is allowed."/>';

    Exit;
  end;

  if not (nBotCharacter in [Integer(Low(TFixUserCharacter))..Integer(High(TFixUserCharacter))]) then begin
    CommonDataModule.Log(ClassName, 'BotsRegister',
      'Incorrect param Integer(Low(TFixUserCharacter)=' + IntToStr(nBotCharacter) + '; Params: TournamentID=' + IntToStr(TournamentID),
      ltError);

    ErrCode := TS_ERR_COMMON;
    Result :=
      '<' + anBot_Sitdown + ' result="' + IntToStr(ErrCode) + '" message="Attribute of type is incorrect."/>';

    Exit;
  end;

  if (FMaxRegisteredLimit > 0) then
    nBotPerProcess := Min(nBotPerProcess, FMaxRegisteredLimit - FPlayers.Count);

  ErrCode := FPlayers.RegisterBots(FTournamentID, nBotPerProcess,
    FChips, FBuyIn, FFee, FCurrencyTypeID, nBotCharacter, SqlAdapter
  );
  if ErrCode <> 0 then begin
    CommonDataModule.Log(ClassName, 'BotsRegister',
      '[ERROR]: Players.RegisterBots return result=' + IntToStr(ErrCode) +
        '; Params: nBotPerProcess=' + IntToStr(nBotPerProcess) +
        '; nBotCharacter=' + IntToStr(nBotCharacter),
      ltError);

    Result :=
      '<' + anBot_Sitdown + ' result="' + IntToStr(ErrCode) + '" message="Not enogh bots for registration."/>';
    Exit;
  end;

  if Self.IsSitAndGO and
    (FTournamentStartEvent <> tseByTime) and
    (FPlayers.Count >= FMaxRegisteredLimit) then
  begin
    FTournamentStartTime := IncMinute(Now, SittingDuration);
  end;

  Result := '<' + anBot_Sitdown + ' result="' + IntToStr(errCode) + '"/>';
end;

function TtsTournament.BotStandUp(aInpAction: TXMLAction;
  FSql: TSQLAdapter; var errCode: Integer): string;
var
  aXML: IXMLDocument;
  aNode, aRoot: IXMLNode;
  I, nBotID: Integer;
  aUsr: TpoTournUser;
  sGuid, sMsg, sMsgOnKickOff: string;
begin
  Result := '';
  errCode := 0;
  sMsg := '';
  sGuid := aInpAction.Guid;

  aXML := TXMLDocument.Create(nil);
  aXML.XML.Text := aInpAction.Action;
  try
    aXML.Active := True;
    aRoot := aXML.DocumentElement;
    for I:=0 to aRoot.ChildNodes.Count - 1 do begin
      aNode := aRoot.ChildNodes[I];
      if aNode.NodeName <> 'bot' then Continue;
      if not aNode.HasAttribute('id') then Continue;

      nBotID := StrToIntDef(aNode.Attributes['id'], 0);
      if (nBotID <= 0) then Continue;
      aUsr := FPlayers.GetUserByBotID(nBotID);
      if (aUsr = nil) then begin
        errCode := errCode + 1;
        sMsg := sMsg + #13#10 + 'Bot with id=' + IntToStr(nBotID) + ' was not found';
        Continue;
      end;
      if not aUsr.IsBot then begin
        errCode := errCode + 1;
        sMsg := sMsg + #13#10 + 'Gamer with BotId=' + IntToStr(nBotID) + ' is not bot';
        Continue;
      end;

      errCode := errCode + KickOffUserByID(aUsr.UserID, FSql, sMsgOnKickOff);
      if (sMsgOnKickOff <> '') then sMsg := sMsg + #13#10 + sMsgOnKickOff;
    end;
  finally
    aXML := nil;
  end;

  Result := '<' + anBot_StandUp + ' result="' + IntToStr(errCode) + '"';
  if sMsg <> '' then
    Result := Result + ' message="' + sMsg + '"';
  Result := Result + ' guid="' + sGuid + '"/>';
end;

function TtsTournament.BotStandUpAll(nTournamentID: Integer;
  FSql: TSQLAdapter; var errCode: Integer): string;
var
  I: Integer;
  aUser: TpoTournUser;
  sMsg, sMsgOnKickOff: string;
begin
  Result := '';
  errCode := 0;
  sMsg := '';

  for I := FPlayers.Count - 1 downto 0 do begin
    aUser := FPlayers.Items[I];

    if aUser.IsBot then begin
      errCode := errCode + KickOffUserByID(aUser.FUserID, FSql, sMsgOnKickOff);
      sMsg := sMsg + #13#19 + sMsgOnKickOff;
    end;
  end;

  Result := '<' + anBot_StandUp_All + ' result="' + IntToStr(errCode) + '"';
  if sMsg <> '' then
    Result := Result + ' message="' + sMsg + '"';
  Result := Result + '/>';
end;

function TtsTournament.BotPolicy(aInpAction: TXMLAction; FSql: TSQLAdapter;
  var errCode: Integer): string;
var
  aXML: IXMLDocument;
  aNode, aRoot: IXMLNode;
  I, nBotID, nType: Integer;
  aUsr: TpoTournUser;
  aPrc: TpoTournProcess;
  sGuid, sMsg: string;
begin
  Result := '';
  errCode := 0;
  sMsg := '';
  sGuid := aInpAction.Guid;
  nType := StrToIntDef(aInpAction.TypeOfRequest, -1);
  if not (nType in [Integer(Low(TFixUserCharacter))..Integer(High(TFixUserCharacter))]) then
  begin
    errCode := 1;
    sMsg := 'Attribute type is incorrect (' + aInpAction.TypeOfRequest + ').';
    nType := 1;
  end;

  aXML := TXMLDocument.Create(nil);
  aXML.XML.Text := aInpAction.Action;
  try
    aXML.Active := True;
    aRoot := aXML.DocumentElement;
    for I:=0 to aRoot.ChildNodes.Count - 1 do begin
      aNode := aRoot.ChildNodes[I];
      if aNode.NodeName <> 'bot' then Continue;
      if not aNode.HasAttribute('id') then Continue;

      nBotID := StrToIntDef(aNode.Attributes['id'], 0);
      if (nBotID <= 0) then Continue;
      aUsr := FPlayers.GetUserByBotID(nBotID);
      if (aUsr = nil) then begin
        errCode := errCode + 1;
        sMsg := sMsg + #13#10 + 'Bot with id=' + IntToStr(nBotID) + ' was not found';
        Continue;
      end;
      if not aUsr.IsBot then begin
        errCode := errCode + 1;
        sMsg := sMsg + #13#10 + 'Gamer with BotId=' + IntToStr(nBotID) + ' is not bot';
        Continue;
      end;

      aUsr.FBotCharacter := TFixUserCharacter(nType);

      if (aUsr.ProcessID <= 0) then Continue;

      aPrc := FProcesses.GetProcessByID(aUsr.FProcessID);
      if aPrc = nil then Continue;

      FActions.Add(
        '<objects>' +
          '<object name="gameadapter">' +
           '<gaaction processid="' + IntToStr(aUsr.FProcessID) + '" sessionid="0">' +
            '<bot_policy type="' + IntToStr(nType) + '" guid="">' +
             '<bot id="' + IntToStr(nBotID) + '"/>' +
            '</bot_policy>' +
           '</gaaction>' +
          '</object>' +
        '</objects>',
        -1, -1
      );

    end;
  finally
    aXML := nil;
  end;

  Result := '<' + anBot_Policy + ' result="' + IntToStr(errCode) + '"';
  if sMsg <> '' then
    Result := Result + ' message="' + sMsg + '"';
  Result := Result + ' guid="' + sGuid + '"/>';

end;

function TtsTournament.KickOffUserByID(nUserID: Integer; FSQL: TSQLAdapter; var Msg: string): Integer;
var
  aUser: TpoTournUser;
  aPrc: TpoTournProcess;
  aPlayersKickOff: TpoTournUserList;
  bSQLIsNill: Boolean;
begin
  Result := 0;
  Msg := '';
  if not Self.IsRegistration then begin
    if Self.IsAnnouncing then begin
      Result := 1;
      Msg := 'Tournament has status announsed. Can not kickoff user.';
    end else
    if Self.IsCompleted then begin
      Result := 2;
      Msg := 'Tournament has status comleted. Can not kickoff user.';
    end else
    if Self.IsStopped then begin
      Result := 3;
      Msg := 'Tournament has status stoped. Can not kickoff user.';
    end else
    if (Self.IsSitting or Self.IsRunning or Self.IsBreak or Self.IsResuming or Self.IsPauseByAdmin) then begin
      aUser := FPlayers.GetUserByID(nUserID);
      if (aUser = nil) then begin
        Result := 4;
        Msg := 'User not found.';
      end else begin
        aPrc := FProcesses.GetProcessByID(aUser.FProcessID);
        if (aUser.IsFinished > 0) or (aUser.FProcessID <= 0) or (aPrc = nil) then begin
          Result := 5;
          Msg := 'User is finished tournament.';
        end else begin
          aUser.FIsKickOffByAdministrator := True;
          // send to GE
          aPlayersKickOff := TpoTournUserList.Create;
          aPlayersKickOff.Add.SetContextByObject(aUser);

          try
            FActions.Add(
              aPrc.GetCommandToGameEngine(cmdKickOffUsers,
                aUser.FLoginName + ' has been kick off from tournament by administrator.',
                '', '', '', Self.Stake, Self.Ante, 0,
                Players.CountOnProcess[aPrc.FProcessID], FActionDispatcherID,
                0, nil, aPlayersKickOff
              ),
              -1, -1
            );
          finally
            aPlayersKickOff.Free;
          end;
        end;
      end;
    end else
    begin
      Result := 6;
      Msg := 'Tournament has not status registration. Can not kickoff user.';
    end;
  end else begin
    aUser := FPlayers.GetUserByID(nUserID);
    if (aUser = nil) then begin
      Result := 4;
      Msg := 'User not found.';
    end else begin
{$IFDEF __TEST__}
      FSQL := nil;
{$ELSE}
      bSQLIsNill := (FSQL = nil);
      if bSQLIsNill then FSQL := CommonDataModule.ObjectPool.GetSQLAdapter;
{$ENDIF}

      FPlayers.UnRegisterParticipant(TournamentID, nUserID, FBuyIn, FFee, FCurrencyTypeID, FSql);

{$IFNDEF __TEST__}
      if bSQLIsNill then CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
{$ENDIF}
    end;
  end;
end;

function TtsTournament.Flash_GAAction_Chair(sStatus, sPlayerNode: string;
  nProcessID, nPosition: Integer): string;
begin
{
 <gaaction processid="3854" seq_gahandid="28952" seq_garound="-1">
  <chair position="1" status="busy" isdealer="1">
    <player id="2147483621" name="16" city="16" sex="1" avatarid="1" userimageversion="0" balance="2600" bet="0" status="playing" ingame="0" cards=""/>
  </chair><chat src="0" priority="0" msg="16 has joined the table"/>
</gaaction>
}
  Result :=
    '<object name="' + APP_PROCESS + '" id="' + IntToStr(nProcessID) + '">' +
      '<gaaction processid="' + IntToStr(nProcessID) + '">' +
        '<chair position="' + IntToStr(nPosition) + '" status="' + sStatus + '" isdealer="0">' +
          sPlayerNode +
        '</chair>' +
      '</gaaction>' +
    '</object>';
end;

procedure TtsTournament.SetTimeOutForKickOff(const Value: Integer);
begin
  FTimeOutForKickOff := Value;
end;

procedure TtsTournament.SetStartKickOffNotTakedSit(const Value: TDateTime);
begin
  FStartKickOffNotTakedSit := Value;
end;

function TtsTournament.GetIsStartKickingOff: Boolean;
begin
  Result :=
    (FStartKickOffNotTakedSit > 0) and
    (FTimeOutForKickOff > 0) and
    not IsPauseByAdmin and
    (FStartKickOffNotTakedSit < Now);
end;

function TtsTournament.StartKickingOff(aActions: TXMLRespActions): Integer;
var
  I: Integer;
  aUser: TpoTournUser;
  sMsg: string;
begin
  Result := 0;
  FStartKickOffNotTakedSit := 0; // disable
  if Self.IsRegistration then Exit;

  for I:=0 to FPlayers.Count - 1 do begin
    aUser := FPlayers.Items[I];
    if aUser.FIsBot then Continue;
    if aUser.FIsTakedSit then Continue;

    { send kick off command to game engine }
    Result := Result + KickOffUserByID(aUser.FUserID, nil, sMsg);
  end;
  sMsg := '';
end;

procedure TtsTournament.UpdateLobbyInfo(FSql: TSQLAdapter);
var
  sData: string;
begin
  { Update togetinfo }
  sData := LOBBY_toGetInfo;
  Owner.StoreLobbyInfo_SQL(FTournamentID, 0, 4, sData, FSql);

  { Update togetlevelsinfo }
  sData := LOBBY_toGetLevelsInfo;
  Owner.StoreLobbyInfo_SQL(FTournamentID, 0, 5, sData, FSql);

  { Update togetplayers }
  sData := LOBBY_toGetPlayers;
  Owner.StoreLobbyInfo_SQL(FTournamentID, 0, 6, sData, FSql);

  { Update togetprocesses }
  sData := LOBBY_toGetProcesses;
  Owner.StoreLobbyInfo_SQL(FTournamentID, 0, 7, sData, FSql);

  { Update togettournamentinfo }
  sData := Owner.LOBBY_toGetTournamentInfo(Self);
  Owner.StoreLobbyInfo_SQL(FTournamentID, 0, 8, sData, FSql);

  sData := '';
end;

procedure TtsTournament.SetMaximumRebuyCount(const Value: Integer);
begin
  FMaximumRebuyCount := Value;
end;

procedure TtsTournament.SetRebuyIsAllowed(const Value: Boolean);
begin
  FRebuyIsAllowed := Value;
end;

function TtsTournament.LOBBY_toAutoRebuy(nUserID, nValue: Integer;
  SQLAdapter: TSQLAdapter; var errCode: Integer): string;
var
  aUsr: TpoTournUser;
begin
  ErrCode := 0;

  Result :=
      '<object name="' + APP_TOURNAMENT + '" id="0">' +
        '<toautorebuy ' +
          'tournamentid="' + IntToStr(TournamentID) + '" ' +
          'userid="' + IntToStr(nUserID) + '" ' +
          'value="' + IntToStr(nValue) + '" ';

  if not Self.FRebuyIsAllowed then begin
    errCode := TS_ERR_REBUYISNOTALLOWED;
    Result := Result + 'result="' + IntToStr(errCode) + '"/></object>';
    Exit;
  end;

  if Self.IsAnnouncing then begin
    errCode := TS_ERR_NOTREGISTERATIONSTATUS;
    Result := Result + 'result="' + IntToStr(errCode) + '"/></object>';
    Exit;
  end;

  if not (nValue in [0,1]) then begin
    errCode := TS_ERR_WRONGATTRIBUTE;
    Result := Result + 'result="' + IntToStr(errCode) + '"/></object>';
    Exit;
  end;

  aUsr := FPlayers.GetUserByID(nUserID);
  if (aUsr = nil) then begin
    errCode := TS_ERR_USERNOTFOUND;
    Result := Result + 'result="' + IntToStr(errCode) + '"/></object>';
    Exit;
  end;

  if (aUsr.IsFinished > 0) then begin
    errCode := TS_ERR_USERFINISHEDTOURNAY;
    Result := Result + 'result="' + IntToStr(errCode) + '"/></object>';
    Exit;
  end;

  aUsr.FRebuyAuto := Boolean(nValue);
  Result := Result + 'result="' + IntToStr(errCode) + '"/></object>';
end;

function TtsTournament.LOBBY_toRebuy(nUserID, nValue: Integer;
  SQLAdapter: TSQLAdapter; var errCode: Integer): string;
var
  aUsr: TpoTournUser;
  aPrc: TpoTournProcess;
  aPlayersBuff: TpoTournUserList;
  nRestOfRebuy: Integer;
  RebuyChips: Currency;
  nAddOnceUsed: Integer;
begin
  ErrCode := 0;

  Result :=
      '<object name="' + APP_TOURNAMENT + '" id="0">' +
        '<torebuy ' +
          'tournamentid="' + IntToStr(TournamentID) + '" ' +
          'userid="' + IntToStr(nUserID) + '" ' +
          'value="' + IntToStr(nValue) + '" ';

  if not (Self.FRebuyIsAllowed or Self.FAddOnIsAllowed) then begin
    errCode := TS_ERR_REBUYISNOTALLOWED;
    Result := Result + 'result="' + IntToStr(errCode) + '"/></object>';
    Exit;
  end;

  if Self.IsAnnouncing then begin
    errCode := TS_ERR_NOTREGISTERATIONSTATUS;
    Result := Result + 'result="' + IntToStr(errCode) + '"/></object>';
    Exit;
  end;

  if nValue <= 0 then begin
    errCode := TS_ERR_WRONGATTRIBUTE;
    Result := Result + 'result="' + IntToStr(errCode) + '"/></object>';
    Exit;
  end;

  aUsr := FPlayers.GetUserByID(nUserID);
  if (aUsr = nil) then begin
    errCode := TS_ERR_USERNOTFOUND;
    Result := Result + 'result="' + IntToStr(errCode) + '"/></object>';
    Exit;
  end;

  if (aUsr.IsFinished > 0) then begin
    errCode := TS_ERR_USERFINISHEDTOURNAY;
    Result := Result + 'result="' + IntToStr(errCode) + '"/></object>';
    Exit;
  end;

  nRestOfRebuy := nValue;
  nAddOnceUsed := 0;
  if FRebuyIsAllowed then begin
    if (aUsr.Chips > FChips) then begin
      errCode := TS_ERR_USERHASFULLCHIPS;
      Result := Result + 'result="' + IntToStr(errCode) + '"/></object>';
      Exit;
    end;

    if (FMaximumRebuyCount > 0) then
      nRestOfRebuy := FMaximumRebuyCount - aUsr.FRebuyCount;
    if (nRestOfRebuy <= 0) then begin
      errCode := TS_ERR_MAXIMUMREBUYCOUNTED;
      Result := Result + 'result="' + IntToStr(errCode) + '"/></object>';
      Exit;
    end;

    if (nRestOfRebuy > nValue) then nRestOfRebuy := nValue;
  end else if FAddOnIsAllowed then begin
    if Self.IsBreak then begin
      nAddOnceUsed := 1;
      if aUsr.FRebuyAddOnceUsed then begin
        errCode := TS_ERR_MAXIMUMREBUYCOUNTED;
        Result := Result + 'result="' + IntToStr(errCode) + '"/></object>';
        Exit;
      end;
    end else begin
      nAddOnceUsed := Integer(aUsr.FRebuyAddOnceUsed);
    end;
  end else begin
    errCode := TS_ERR_REBUYISNOTALLOWED;
    Result := Result + 'result="' + IntToStr(errCode) + '"/></object>';
    Exit;
  end;

  errCode := LOBBY_toRebuy_SQL(nUserID, nRestOfRebuy, nAddOnceUsed, SQLAdapter);
  if (errCode <> 0) then begin
    Result := Result + 'result="' + IntToStr(errCode) + '"/></object>';
    Exit;
  end;

  RebuyChips := nRestOfRebuy * FChips;
  aUsr.FChips := aUsr.FChips + RebuyChips;
  aUsr.FRebuyCount := aUsr.FRebuyCount + nRestOfRebuy;
  aUsr.FRebuyAddOnceUsed := Boolean(nAddOnceUsed);

  // send rebuy action to GE
  aPrc := nil;
  if (aUsr.FProcessID > 0) then
    aPrc := FProcesses.GetProcessByID(aUsr.FProcessID);

  if (aPrc <> nil) then begin
    aPlayersBuff := TpoTournUserList.Create;
    aPlayersBuff.Add.SetContextByObject(aUsr);

    FActions.Add(
      aPrc.GetCommandToGameEngine(cmdRebuy, '', '', '', '',
        Self.Stake, 0, RebuyChips, Players.CountOnProcess[aPrc.FProcessID],
        FActionDispatcherID, 0, aPlayersBuff, nil),
      -1, -1
    );

    aPlayersBuff.Free;
  end;

  Result := Result + 'result="' + IntToStr(errCode) + '"/></object>';
end;

function TtsTournament.LOBBY_toRebuy_SQL(nUserID, nValue, nRebuyAddOnceUsed: Integer;
  SQLAdapter: TSQLAdapter): Integer;
var
  bNeedCreateSQL: Boolean;
begin
  bNeedCreateSQL := (SQLAdapter = nil);
  if bNeedCreateSQL then
    SQLAdapter := CommonDataModule.ObjectPool.GetSQLAdapter;

  try
    try
      SQLAdapter.SetProcName('srvtouMakeRebuy');
      SQLAdapter.AddParInt('RETURN_VALUE',0,ptResult);
      SQLAdapter.AddParInt('TournamentID', TournamentID, ptInput);
      SQLAdapter.AddParInt('UserID', nUserID, ptInput);
      SQLAdapter.AddParInt('RebuyCount', nValue, ptInput);
      SQLAdapter.AddParInt('RebuyAddOnceUsed', nRebuyAddOnceUsed, ptInput);
      SQLAdapter.AddParam('BuyIn', FBuyIn, ptInput, ftCurrency);
      SQLAdapter.AddParam('Chips', FChips, ptInput, ftCurrency);
      SQLAdapter.AddParInt('CurrencyTypeID', FCurrencyTypeID, ptInput);

      SQLAdapter.ExecuteCommand;

      Result := SQLAdapter.GetParam('RETURN_VALUE');
      case Result of
        1: Result := TS_ERR_WROUNGTOURNAMENTID;
        2: Result := TS_ERR_USERNOTFOUND;
        3: Result := TS_ERR_NOACCOUNT;
        4: Result := TS_ERR_NOTENOUGHMONEY;
      end;
    except
      on E: Exception do begin
        CommonDataModule.Log(ClassName, 'LOBBY_toRebuy_SQL',
        '[EXCEPTION] On exec srvtouMakeRebuy: Params:',
        ltException);

        Result := TS_ERR_SQLERROR;
      end;
    end;
  finally
    if bNeedCreateSQL then
      CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);
  end;
end;

procedure TtsTournament.SetAddOnIsAllowed(const Value: Boolean);
begin
  FAddOnIsAllowed := Value;
end;

{ TpoTournPrizeRulesList }

function TpoTournPrizeRulesList.Add(sName, sCurrSign, sCurrName: string): TpoTournPrizeRateList;
begin
  Result := TpoTournPrizeRateList.Create(FTournamentID);
  Result.FName := sName;
  Result.FCurrencySign := sCurrSign;
  Result.FCurrencyName := sCurrName;
  inherited Add(Result);
end;

constructor TpoTournPrizeRulesList.Create(TournamentID: Integer);
begin
  inherited Create;
  FTournamentID := TournamentID;
end;

procedure TpoTournPrizeRulesList.Del(Item: TpoTournPrizeRateList);
begin
  inherited Remove(Item);
end;

destructor TpoTournPrizeRulesList.Destroy;
begin
  Clear;
  inherited;
end;

function TpoTournPrizeRulesList.GetDataPrizePool_ToLobby(TotalPrize: Currency;isShortData: Boolean): string;
var                                                                           //Added parameter isShortData
  I: Integer;                                                                 // if true gets only prizes without names
  aPrizeList: TpoTournPrizeRateList;
begin
// ********************************
// WARNIG: it is not XML
// ********************************

  Result := '';
  for I:=0 to Count - 1 do begin
    aPrizeList := Items[I];
    if not isShortData then
    begin
      Result := Result + '<data value="' + aPrizeList.FName + ' - ' + aPrizeList.FCurrencyName + '"/>';
      Result := Result + aPrizeList.GetDataPrizePool_ToLobby(TotalPrize, isShortData);
    end else begin
      Result := Result + aPrizeList.GetDataPrizePool_ToLobby(TotalPrize, isShortData);
    end
  end;
end;

function TpoTournPrizeRulesList.GetItems(Index: Integer): TpoTournPrizeRateList;
begin
  Result := TpoTournPrizeRateList(inherited Items[Index]);
end;

function TpoTournPrizeRulesList.GetNumberOfPlayersForFinish: Integer;
begin
  if Count <= 0 then
    Result := 1
  else
    Result := Items[0].FNumberOfPlayersForFinish;
end;

function TpoTournPrizeRulesList.Ins(Index: Integer; sName, sCurrSign, sCurrName: string): TpoTournPrizeRateList;
begin
  Result := TpoTournPrizeRateList.Create(FTournamentID);
  Result.FName := sName;
  Result.FCurrencySign := sCurrSign;
  Result.FCurrencyName := sCurrName;
  inherited Insert(Index, Result);
end;

function TpoTournPrizeRulesList.LoadFromAdmSiteXML(FTournament: TtsTournament): Integer;
var
  I: Integer;
  aPrizeList: TpoTournPrizeRateList;
begin
  if FTournament = nil then begin
    LogException( '{99F9014E-E8EA-41C6-82EA-100DF0F780A3}',
      ClassName, 'LoadFromAdmSiteXML', 'Tournament object is empty.'
    );

    Result := 1;
    Clear;
    Add('Default Prize', '$', 'Dollars').SetDefault;
    Exit;
  end;

  Result := 0;
  if (Count <= 0) then begin
    Add('Default Prize', '$', 'Dollars').SetDefault;
  end;

  for I:=0 to Count - 1 do begin
    aPrizeList := Items[I];
    if (FTournament.FTournamentTypeID = ttpSattelite) then begin
      { Prize Pool from DB will iggnored }
      if I = 0 then
        aPrizeList.SetSatelited(FTournament)
      else
        aPrizeList.SetDefault;
    end;
    aPrizeList.LoadFromAdmSiteXML(FTournament);
  end;
end;

function TpoTournPrizeRulesList.LoadFromDB(SQLAdapter: TSQLAdapter): Integer;
var
  RS: TDataSet;
  sName, sCurrSign, sCurrName: string;
begin
  Result := 0;
  RS := nil;

  try
    // stored procedure srvtouGetTournaments
    SQLAdapter.SetProcName('srvtouGetTournamentPrizeRules');
    SqlAdapter.AddParam('RETURN_VALUE',0,ptResult,ftInteger);
    SQLAdapter.AddParInt('TournamentID', FTournamentID, ptInput);
    RS := SQLAdapter.ExecuteCommand;
  except
    on E : Exception do begin
      CommonDataModule.Log(ClassName, 'LoadFromDB',
        '[EXCEPTION] on execute srvtouGetTournamentPrizeRules: ' + E.Message,
        ltException);

      if (RS <> nil) then RS.Close;
      Result := TS_ERR_SQLERROR;

      { add default item }
      Clear;
      Add('Default Prize', '$', 'Dollars').SetDefault;

      Exit;
    end;
  end;

  { insert prizerate list items }
  Clear;
  while not RS.EOF do begin
    sName     := RS.FieldValues['NamePaySchema'];
    sCurrSign := RS.FieldValues['CurrencySign'];
    sCurrName := RS.FieldValues['CurrencyName'];
    Add(sName, sCurrSign, sCurrName).FPrizePoolXML := RS.FieldValues['PaySchemaXML'];
    RS.Next;
  end;

  RS.Close;

  if (Count <= 0) then begin
    Add('Default Prize', '$', 'Dollars').SetDefault;
  end;

end;

function TpoTournPrizeRulesList.StoreIntoDB(SQLAdapter: TSQLAdapter; sData: string): Integer;
var
  XML: IXMLDocument;
  Node: IXMLNode;
  strPrize: string;
  nPrizeType,
  CurrencyType,
  ValueType: Integer;
begin
  XML := TXMLDocument.Create(nil);
  try
    try
      XML.XML.Text := sData;
      XML.Active := True;
    except
      on E: Exception do begin
        CommonDataModule.Log(ClassName, 'StoreIntoDB',
          'EXCEPTION: With message: ' + E.Message + '; On parsing XML=[' + sData + ']',
          ltException);
        Result := TO_ERR_WRONGXMLFILE;
        Exit;
      end;
    end;

    Node := XML.DocumentElement;
    if (Node.NodeName = anInitPrizePool) and Node.HasChildNodes then begin
      Node := Node.ChildNodes[0];
    end;
    strPrize := Node.XML;
    nPrizeType   := 0;
    CurrencyType := 1;
    ValueType    := prvTypePercent;
    if Node.HasAttribute(Attr_PrizeTypeID) then
      nPrizeType   := StrToIntDef(Node.Attributes[Attr_PrizeTypeID], 0);
    if Node.HasAttribute(Attr_CurrType) then
      CurrencyType   := StrToIntDef(Node.Attributes[Attr_CurrType], 1);
    if Node.HasAttribute(Attr_PrizeValueType) then
      ValueType   := StrToIntDef(Node.Attributes[Attr_PrizeValueType], prvTypePercent);

    SQLAdapter.SetProcName('srvtouSetTournamentPrizePoolXML');
    SQLAdapter.AddParInt('RETURN_VALUE', 0, ptResult);
    SQLAdapter.AddParInt('TournamentID', TournamentID, ptInput);
    SQLAdapter.AddParInt('PrizeTypeID', nPrizeType, ptInput);
    SQLAdapter.AddParInt('CurrencyType', CurrencyType, ptInput);
    SQLAdapter.AddParInt('ValueType', ValueType, ptInput);
    SQLAdapter.AddParString('Data', strPrize, ptInput);

    SQLAdapter.ExecuteCommand;
    Result := SQLAdapter.GetParam('RETURN_VALUE');
    if Result <> 0 then begin
      CommonDataModule.Log(ClassName, 'StoreIntoDB',
        '[ERROR: On execute srvtouSetTournamentPrizePoolXML]: Params: ' +
          'TournamentID=' + IntToStr(TournamentID) + '; ' +
          'PrizeType=' + IntToStr(nPrizeType) + '; ' +
          'CurrencyType=' + IntToStr(CurrencyType) + '; ' +
          'ValueType=' + IntToStr(ValueType) + '; ' +
          'Data=[' + strPrize + ']',
        ltError
      );

      Result := TO_ERR_SQLCOMMANDERROR;
      Exit;
    end;
  finally
    XML.Active := False;
    XML := nil;
  end;
end;

function TpoTournPrizeRulesList.SetContextByObject(FromObj: TpoTournPrizeRulesList): Integer;
var
  I: Integer;
begin
  if FromObj = nil then
  begin
    LogException( '{BED5F747-B53C-46E6-8121-5DFC80E55C9B}',
      ClassName, 'SetContextByObject', 'Try to take context from nil object'
    );

    Result := 1;
    Exit;
  end;

  Clear;
  for I:=0 to FromObj.Count - 1 do begin
    Add('', '', '').SetContextByObject(FromObj.Items[I]);
  end;

  Result := 0;
end;

procedure TpoTournPrizeRulesList.SetTournamentID(const Value: Integer);
begin
  FTournamentID := Value;
end;

function TpoTournPrizeRulesList.FindItemByTypeID(nTypeID: Integer): TpoTournPrizeRateList;
var
  I: Integer;
  aItem: TpoTournPrizeRateList;
begin
  Result := nil;
  for I:=0 to Count - 1 do begin
    aItem := Items[I];
    if (nTypeID = aItem.FPrizeTypeID) then begin
      Result := aItem;
      Exit;
    end;
  end;
end;

{ TpoTournBetting }

constructor TpoTournBetting.Create(aBettingList: TpoTournBettingList);
begin
  inherited Create;
  FBettingList := aBettingList; // list owner
end;

function TpoTournBetting.GetStakeInfo(LevelInterval: Integer): string;
var
  sb, bb, ant: Currency;
begin
  sb  := Trunc(FStake * 100) / 100;
  bb  := Trunc(FStake * 200) / 100;
  ant := Trunc(FAnte * 100) / 100;

  Result :=
    '<level number="'+IntToStr(FLevel)+'" ' +
      'blinds="' + CurrToStr(sb) + ' / ' + CurrToStr(bb) + '" ' +
      'ante="' + CurrToStr(ant) + '" ' +
      'time="'+ IntToStr(LevelInterval) +
    '"/>';
end;

procedure TpoTournBetting.SetAnte(const Value: Currency);
begin
  FAnte := Value;
end;

function TpoTournBetting.SetContextByNode(aNode: IXMLNode): Integer;
begin
  try
    FLevel := StrToInt(aNode.Attributes['num']);
    FStake := StrToCurr(aNode.Attributes['blind']);
    FAnte := StrToCurr(aNode.Attributes['ante']);
  except
    on E: Exception do begin
      Result := TS_ERR_XMLPARCEERROR;
      LogException( '{59C28529-94E3-484D-AEB1-4D0A36832961}',
        ClassName, 'LoadFromAdmSiteXML', 'Error on get level data: ' + E.Message + ': XMLNode=' + aNode.XML
      );
      Exit;
    end;
  end;

  Result := 0;
end;

function TpoTournBetting.SetContextByObject(FromObj: TpoTournBetting): Integer;
begin
  if FromObj = nil then
  begin
    LogException( '{E504D1DF-E4BD-4983-881A-07DDE96F61C0}',
      ClassName, 'SetContextByObject', 'Try to take context from nil object'
    );

    Result := 1;
    Exit;
  end;

  // properties
  FLevel := FromObj.FLevel;
  FStake := FromObj.FStake;
  FAnte  := FromObj.FAnte;

  Result := 0;
end;

procedure TpoTournBetting.SetStake(const Value: Currency);
begin
  FStake := Value;
end;

procedure TpoTournBetting.SetLevel(const Value: Integer);
begin
  FLevel := Value;
end;

{ TpoTournBettingList }

function TpoTournBettingList.Add: TpoTournBetting;
begin
  Result := TpoTournBetting.Create(Self);
  inherited Add(Result);
end;

constructor TpoTournBettingList.Create(aOwner: TtsTournament);
begin
  inherited Create;
  FOwner := aOwner;
  SetDefault;
end;

procedure TpoTournBettingList.Del(Item: TpoTournBetting);
begin
  inherited Remove(Item);
end;

destructor TpoTournBettingList.Destroy;
begin
  Clear;
  inherited;
end;

function TpoTournBettingList.GetAnte(nLevel: Integer): Currency;
begin
  if (Count <= 0) then begin
    Result := 0;
  end else begin
    if (nLevel >= Count) then
      Result := Items[Count - 1].FAnte
    else
      Result := Items[nLevel - 1].FAnte
  end;
end;

function TpoTournBettingList.GetInitialStake: Currency;
begin
  if (FOwner = nil) then
    Result := 2
  else
    Result := FOwner.FInitialStake;
end;

function TpoTournBettingList.GetItems(Index: Integer): TpoTournBetting;
begin
  Result := TpoTournBetting(inherited Items[Index]);
end;

function TpoTournBettingList.GetStake(nLevel: Integer): Currency;
var
  I: Integer;
begin
  if (Count <= 0) then begin
    Result := InitialStake;
    if (nLevel > 1) then
      for I:=1 to (nLevel-1) do Result := Result * FCoefficient;
  end else begin
    if (nLevel >= Count) then I := Count - 1 else I := nLevel - 1;
    Result := Items[I].FStake * 2;
  end;
end;

function TpoTournBettingList.GetStakeInfo(nLevel, LevelInterval: Integer; IsXML: Boolean): string;
var
  I: Integer;
  sb, bb: Currency;
begin
  Result := '';

  if IsXML then begin
    if Count > 0 then begin
      for I:=0 to Count - 1 do
        Result := Result + Items[I].GetStakeInfo(LevelInterval)
    end else begin
      for I:=0 to DefCountOfBettingsOnCoefficient - 1 do
        Result := Result + GetStakeInfoByCoefficientAsXml(I+1, LevelInterval);
    end;
  end else begin
    bb := Stake[nLevel];
    sb := Trunc(bb / 2);
    Result := 'blinds ' + CurrToStr(sb) + '/' + CurrToStr(bb);
  end
end;

function TpoTournBettingList.GetStakeInfoByCoefficientAsXml(nLevel, LevelInterval: Integer): string;
var
  bb, sb: Currency;
begin
  bb := Stake[nLevel];
  bb  := Trunc(bb * 100        ) / 100;
  sb  := Trunc(bb / 2);

  Result :=
    '<level number="'+IntToStr(nLevel)+'" ' +
      'blinds="' + CurrToStr(sb) + ' / ' + CurrToStr(bb) + '" ' +
      'ante="0" ' +
      'time="'+ IntToStr(Trunc(LevelInterval)) +
    '"/>';
end;

function TpoTournBettingList.LoadFromAdmSiteXML(sXML: string): Integer;
var
  XML: IXMLDocument;
  Root: IXMLNode;
begin
  SetDefault;
  //
  XML := TXMLDocument.Create(nil);
  XML.XML.Text := sXML;
  try
    XML.Active := True;

    Root := XML.DocumentElement;
    Result := LoadFromNode(Root);
  except
    on E: Exception do begin
      Result := TS_ERR_XMLPARCEERROR;
      LogException( '{BF1144F8-CB60-46B7-A300-89A6940F886D}',
        ClassName, 'LoadFromAdmSiteXML', 'XML Parser error: ' + E.Message + ': XML=' + sXML
      );

      XML.Active := False;
      XML := nil;

      // set defaulf
      SetDefault;
      Exit;
    end;
  end;

  XML.Active := False;
  XML := nil;
end;

function TpoTournBettingList.LoadFromDB(const TournamentID: Integer; SQLAdapter: TSQLAdapter): Integer;
var
  StrData, sSQL: string;
  NeedCreateSQL: Boolean;
begin
  Result := 0;
{$IFDEF __TEST__}
  StrData :=
    '<tsbettings tournamentid="1" coefficient="2">' +
      '<level num="1" blind="2" ante="0"/>' +
      '<level num="3" blind="6" ante="0"/>' +
      '<level num="5" blind="10" ante="0.25"/>' +
      '<level num="7" blind="32" ante="0.5"/>' +
      '<level num="8" blind="80" ante="2"/>' +
      '<level num="9" blind="100" ante="6"/>' +
      '<level num="10" blind="400" ante="10"/>' +
      '<level num="11" blind="1200" ante="10"/>' +
      '<level num="12" blind="2400" ante="20"/>' +
      '<level num="13" blind="4000" ante="40"/>' +
      '<level num="14" blind="6000" ante="40"/>' +
    '</tsbettings>';
  LoadFromAdmSiteXML(StrData);
  Exit;
{$ENDIF}

  NeedCreateSQL := (SQLAdapter = nil);
  if NeedCreateSQL then SQLAdapter := CommonDataModule.ObjectPool.GetSQLAdapter;

  sSQL := 'exec srvtouGetTournamentBettingsXML ' + IntToStr(TournamentID);
  try
    StrData := SQLAdapter.ExecuteForXML(sSql);
  except on E: Exception do
    begin
      Result := TS_ERR_SQLERROR;
      if NeedCreateSQL then CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);

      LogException( '{4E6815FD-43E0-4BBB-A77C-620E9BE55405}',
        ClassName, 'LoadFromDB',
        E.Message + ': On Execute SQL=' + sSQL
      );
      Exit;
    end;
  end;

  if StrData = '' then
  begin
    if NeedCreateSQL then CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);

    LogException( '{09E98311-D07E-4AF6-B730-D18758881A96}',
      ClassName, 'LoadFromDB', 'SQL procedure: [' + sSQL + '] return empty result.'
    );

    Result := TS_ERR_SQLERROR;
    Exit;
  end;

  if NeedCreateSQL then CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);

  LoadFromAdmSiteXML(StrData);
end;

function TpoTournBettingList.LoadFromNode(aNode: IXMLNode): Integer;
var
  ChildNode: IXMLNode;
  I: Integer;
  aBettingLevel: TpoTournBetting;
begin
  if aNode.HasAttribute('coefficient') then
    FCoefficient := StrToCurrDef(aNode.Attributes['coefficient'], 2)
  else
    FCoefficient := 2;

  { adding items }
  for I:=0 to aNode.ChildNodes.Count - 1 do begin
    ChildNode := aNode.ChildNodes.Get(I);

    aBettingLevel := Add;
    if aBettingLevel.SetContextByNode(ChildNode) <> 0 then begin
      Result := TS_ERR_XMLPARCEERROR;
      SetDefault;
      Exit;
    end;
  end;

  SortAndUpdateLevels;

  Result := 0;
end;

procedure TpoTournBettingList.SetCoefficient(const Value: Currency);
begin
  FCoefficient := Value;
end;

function TpoTournBettingList.SetContextByObject(FromObj: TpoTournBettingList): Integer;
var
  I: Integer;
begin
  if FromObj = nil then
  begin
    LogException( '{6D2EADC2-6404-4FDF-8ACB-7B2934E263C8}',
      ClassName, 'SetContextByObject', 'Try to take context from nil object'
    );

    Result := 1;
    Exit;
  end;

  FCoefficient := FromObj.FCoefficient;
  Clear;
  for I:=0 to FromObj.Count - 1 do begin
    Add.SetContextByObject(FromObj.Items[I]);
  end;

  Result := 0;
end;

procedure TpoTournBettingList.SetDefault;
begin
  Self.Clear;
  // default values
  FCoefficient := 2;
end;

procedure TpoTournBettingList.SetInitialStake(const Value: Currency);
begin
  if (FOwner <> nil) then FOwner.FInitialStake := Value;
end;

procedure TpoTournBettingList.SortAndUpdateLevels;
var
  I: Integer;
begin
  inherited Sort(CompareBettingsByLevel);

  for I:=0 to Count - 1 do Items[I].FLevel := I + 1;
end;

function TpoTournBettingList.StoreIntoDB(TournamentID: Integer; sData: string; SQLAdapter: TSQLAdapter): Integer;
var
  NeedCreateSQL: Boolean;
  sSql: string;
begin
  Result := 0;
{$IFDEF __TEST__}
  Exit;
{$ENDIF}

  NeedCreateSQL := (SQLAdapter = nil);
  if NeedCreateSQL then SQLAdapter := CommonDataModule.ObjectPool.GetSQLAdapter;

  sSQL := 'exec srvtouSetTournamentBettingsXML ' + IntToStr(TournamentID) + ', ''' + sData + '''';
  try
    SQLAdapter.Execute(sSql);
  except on E: Exception do
    begin
      Result := TS_ERR_SQLERROR;
      if NeedCreateSQL then CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);

      LogException( '{999BD81F-E673-4CF2-9EF7-D9141BE58E18}',
        ClassName, 'StoreIntoDB',
        E.Message + ': On Execute SQL=' + sSQL
      );
      Exit;
    end;
  end;

end;

{ TtsTournamentList }

function TtsTournamentList.Add(nTID: Integer): TtsTournament;
begin
  Result := TtsTournament.Create(nTID, Self);
  inherited Add(Result);
  CommonDataModule.Log(ClassName, 'Add',
    'New item has been added to list: TournamentID=' + IntToStr(Result.TournamentID),
    ltCall
  );
end;

function TtsTournamentList.AddProperty(TargetNode: IXMlNode;
  NodeName: string; NodeType: integer; NodeValue: variant;
  IsTournament: Integer): IXMLNode;
var
    CurrNode : IXMLNode;
begin
  try
    CurrNode := TargetNode.AddChild('property');
    CurrNode.SetAttribute('name',NodeName);
    CurrNode.SetAttribute('type',NodeType);

    if NodeType = ptDateTime then
      CurrNode.SetAttribute('value', FormatDateTime('mm/dd/yyyy hh:nn:ss ampm', VarToDateTime(NodeValue)))
    else
      CurrNode.SetAttribute('value', VarToStr(NodeValue));
    CurrNode.SetAttribute('istournament',IntToStr(IsTournament));
  except on e : Exception do
    begin
      CommonDataModule.Log( ClassName, 'AddProperty', E.Message, ltException);
    end;
  end;

  Result := CurrNode;
end;

function TtsTournamentList.AddXMLItem(sXml: string;
  Node: IXMLNode): Integer;
var
  aXML: IXMLDocument;
  Root, clNode: IXMLNode;
begin
  Result := 0;
  try
    aXML := TXMLDocument.Create(nil);
    aXML.XML.Text := sXML;
    aXML.Active := True;
    Root := aXML.DocumentElement;
  except
    on E: Exception do begin
      CommonDataModule.Log( ClassName, 'AddXMLItem', E.Message + '; Params: sXML = ' + sXml, ltException);

      aXML.Active := False;
      aXML := nil;

      Result := 1;
      Exit;
    end;
  end;

  try
    clNode := Root.CloneNode(true);
    Node.ChildNodes.Add( clNode );

    aXML.Active := False;
    aXML := nil;
  except on E: Exception do
    begin
      CommonDataModule.Log(ClassName, 'AddXMLItem', E.Message + '; Params: sXML = ' + sXml, ltException);

      aXML.Active := False;
      aXML := nil;

      Result := 2;
      Exit;
    end;
  end;
end;

constructor TtsTournamentList.Create;
begin
  inherited Create;
end;

procedure TtsTournamentList.Del(Item: TtsTournament);
begin
  CommonDataModule.Log(ClassName, 'Del',
    'Drop item from the list: TournamentID=' + IntToStr(Item.TournamentID) + ', Index=' + IntToStr(IndexOf(Item)),
    ltCall
  );
  inherited Remove(Item);
end;

destructor TtsTournamentList.Destroy;
begin
  Clear;
  inherited;
end;

procedure TtsTournamentList.Execute;
var
  I: Integer;
begin
  for I:= 0 to Count - 1 do Items[I].Execute;
end;

function TtsTournamentList.GetCurrencies(var Data: string): Integer;
var
  SQLAdapter: TSQLAdapter;
begin
  CommonDataModule.Log(ClassName, 'GetCurrencies', 'Entry', ltCall);

  Result := 0;

{$IFDEF __TEST__}
  Data :=
    '<currencies>' +
      '<item id="1" name="Play Money"/>' +
      '<item id="2" name="Dollars"/>' +
      '<item id="3" name="Bonus Money"/>' +
    '</currencies>';
  CommonDataModule.Log( ClassName, 'GetCurrencies', 'All right', ltCall);
  Exit;
{$ENDIF}

  // select data from DB
  SQLAdapter := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    Data := '<currencies>' + SQLAdapter.ExecuteForXML('exec srvtouGetCurrenciesXML') + '</currencies>';
  except on e : Exception do
    begin
      CommonDataModule.Log(ClassName, 'GetCurrencies',
        'GetCurrencies.FSql.Execute exception: ' + e.Message, ltException);

      CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);
      Result := TO_ERR_SQLCOMMANDERROR;
      Exit;
    end;
  end;
  CommonDataModule.ObjectPool.FreeSQLAdapter(SQLAdapter);

  CommonDataModule.Log( ClassName, 'GetCurrencies', 'All right', ltCall);
end;

function TtsTournamentList.GetDefaultProperties(sGuid: string): Integer;
var
  XMLData,XMLCurrency,
  GameEngineProp   : IXMLDocument;
  CurNode,
  PropNode,
  GeNode,
  SubNode          : IXMLNode;
  Response,
  GameEngineData   : string;
  i                : integer;
  s,ComName        : string;
  CData, Data			 : string;
  //
  FGameConnector: TGameConnector;

begin
  CommonDataModule.Log( ClassName, 'GetDefaultProperties', 'Entry', ltCall);

  Result := GetCurrencies(CData);
  if Result <> 0 then Exit;

//  creating XML file for admin
  XMLData        := TXMLDocument.Create(nil);
  XMLData.Active := true;
  PropNode       := XMLData.AddChild('properties');  // root node

//  properties for tournament
  AddProperty(PropNode, PropName_TournamentName, ptString, '', 1);
  AddProperty(PropNode, PropName_MaxRegisteredGamers, ptInteger, PropDef_MaxRegisteredGamers, 1);
  AddProperty(PropNode, PropName_RegistrationStartAt, ptDateTime, IncMinute(Now, PropDef_RegistrationTimeShift), 1);
  AddProperty(PropNode, PropName_TournamentStartAt, ptDateTime, IncMinute(Now, PropDef_TournamentStartShift), 1);
  SubNode := AddProperty(PropNode, PropName_TournamentCategory, ptComboBox, tsCategoryTournament, 1);
    AddXMLItem('<item id ="1" value="Tournament"/>', SubNode);
    AddXMLItem('<item id ="2" value="Sit and Go"/>', SubNode);
{  SubNode := AddProperty(PropNode, PropName_TournamentStartType, ptComboBox, tseByTime, 1);
    AddXMLItem('<item id ="1" value="Start date and time"/>', SubNode);
    AddXMLItem('<item id ="2" value="Maximum registered players"/>', SubNode);
    AddXMLItem('<item id ="3" value="Both (fist happened)"/>', SubNode);
}
  AddProperty(PropNode, PropName_IntervalBetweenTournaments, ptInteger, PropDef_IntervalBetweenTournaments, 1);
  AddProperty(PropNode, PropName_DurationRegistration_Start, ptInteger, PropDef_DurationRegistration_Start, 1);
  AddProperty(PropNode, PropName_IntervalBetweenLevels, ptInteger, PropDef_IntervalBetweenLevels, 1);
  AddProperty(PropNode, PropName_IntervalBetweenBreaks, ptInteger, PropDef_IntervalBetweenBreaks, 1);
  AddProperty(PropNode, PropName_BreakDuration, ptInteger, PropDef_BreakDuration, 1);
  AddProperty(PropNode, PropName_TimeOutForKickOff, ptInteger, PropDef_TimeOutForKickOff, 1);
  SubNode := AddProperty(PropNode, PropName_TypeOfTournament, ptComboBox, ttpRegular, 1);
    AddXMLItem('<item id ="1" value="Regular"/>', SubNode);
    AddXMLItem('<item id ="2" value="Satelitte"/>', SubNode);
    AddXMLItem('<item id ="3" value="Restricted"/>', SubNode);
  AddProperty(PropNode, PropName_MasterTournamentID, ptInteger, 0, 1);
  AddProperty(PropNode, PropName_Password, ptString, '', 1);
  AddProperty(PropNode, PropName_BuyIn, ptCurrency, PropDef_BuyIn, 1);
  AddProperty(PropNode, PropName_Fee, ptCurrency, PropDef_Fee, 1);
  AddProperty(PropNode, PropName_RebuyIsAllowed, ptCheckBox, PropDef_RebuyIsAllowed, 1);
  AddProperty(PropNode, PropName_AddOnIsAllowed, ptCheckBox, PropDef_AddOnIsAllowed, 1);
  AddProperty(PropNode, PropName_MaximumCountRebuy, ptInteger, PropDef_MaximumCountRebuy, 1);
  AddProperty(PropNode, PropName_AmountChipsForParticipant, ptCurrency, PropDef_AmountChipsForParticipant, 1);
  SubNode := AddProperty(PropNode, PropName_CurrencyType, ptComboBox, PropDef_CurrencyType, 1);

  XMLCurrency := TXMLDocument.Create(nil);
  XMLCurrency.XML.Text := CData;
  XMLCurrency.Active := true;
  for i := 0 to (XMLCurrency.DocumentElement.ChildNodes.Count-1) do
  begin
  	CurNode := XMLCurrency.DocumentElement.ChildNodes[i];
  	s := CurNode.XML;
    AddXMLItem(s, SubNode);
  end;
  XMLCurrency.Active := False;
  XMLCurrency := nil;

// getting properties from game engine
  FGameConnector := TGameConnector.Create;
  try
   	Result := FGameConnector.GetDefaultProperties(GameEngineData, Response);
		FGameConnector.Free;

    if Result <> 0 then begin
      CommonDataModule.Log( ClassName, 'GetDefaultProperty',
        ComName +  ' return error result=' + IntToStr(Result) + '; Responce=' + Response,
      ltError);

      Exit;
    end;
  except
    on e : Exception do begin
      CommonDataModule.Log( ClassName, 'GetDefaultProperty',
        ' On ' + ComName + '.GetDefaultProcess: ' + e.Message, ltException);
      Result  := TO_ERR_GETDEFAULTPROPERTYFAILED;

      XMLData.Active := False;
      XMLData := nil;
  		FGameConnector.Free;
      Exit;
    end;
  end;

//  adding gameengine properties
  try
    GameEngineProp          := TXMLDocument.Create(nil);
    GameEngineProp.XML.Text := GameEngineData;
    GameEngineProp.Active   := true;
    GeNode                  := GameEngineProp.DocumentElement.ChildNodes.Nodes[0];

    for I := 0 to (GeNode.ChildNodes.Count-1) do begin
      Result := AddXMLItem(GeNode.ChildNodes.Nodes[i].XML, PropNode);
      if Result <> 0 then begin
        Result      := TO_ERR_WRONGXMLFILE;
        XMLData.Active := False;
        XMLData     := nil;
        Exit;
      end;
    end;

  except on e : Exception do
    begin
      CommonDataModule.Log( ClassName, 'GetDefaultProperty',
        'On adding GameEngine Properties: ' + e.message, ltException
      );

      Result      := TO_ERR_WRONGXMLFILE;
      XMLData.Active := False;
      XMLData     := nil;
      Exit;
    end;
  end;

  Data    := XMLData.DocumentElement.XML;

  XMLData.Active := False;
  XMLData := nil;

  { send MSMQ message to admin }
  CommonDataModule.SendAdminMSMQ(Data, sGuid);

  Result  := 0;

  CommonDataModule.Log( ClassName, 'GetDefaultProperty', 'Exit', ltCall);
end;

function TtsTournamentList.GetItemByTournamentID(nTID: Integer): TtsTournament;
var
  I: Integer;
  aItem: TtsTournament;
begin
  Result := nil;
  for I:= 0 to Count - 1 do begin
    aItem := Items[I];
    if aItem.TournamentID = nTID then begin
      Result := aItem;
      Exit;
    end;
  end;
end;

function TtsTournamentList.GetItems(Index: Integer): TtsTournament;
begin
  Result := TtsTournament(inherited Items[Index]);
end;

function TtsTournamentList.GetNameOfValue(NodeProp: IXMLNode): string;
var
  Value: string;
  I: Integer;
  Node: IXMLNode;
begin
  Result := '';
  if NodeProp.HasAttribute('value') then
    Value := NodeProp.Attributes['value']
  else begin
    Exit;
  end;

  for I:= 0 to NodeProp.ChildNodes.Count - 1 do begin
    Node := NodeProp.ChildNodes[I];
    if Value = Node.Attributes['id'] then begin
      Result := Node.Attributes['value'];
      Exit;
    end;
  end;
end;

function TtsTournamentList.GetTournamentsXML(nTournamentKind: Integer): string;
var
  I: Integer;
  TouKindCount, TouPlayersCount: Integer;
  sProcessAll: string;
  aTournament: TtsTournament;
begin
  TouPlayersCount := 0;
  TouKindCount := 0;
  sProcessAll := '';
  for I:=0 to Count - 1 do begin
    aTournament := Items[I];

    if ((nTournamentKind = 1) and     aTournament.IsSitAndGO) or
       ((nTournamentKind = 2) and not aTournament.IsSitAndGO)
    then Continue; // filtered

    if (aTournament.FTournamentCategory = nTournamentKind) or (nTournamentKind = 0) then begin
      TouPlayersCount := TouPlayersCount + aTournament.Players.Count;
      TouKindCount := TouKindCount + 1;
      sProcessAll := sProcessAll + aTournament.LOBBY_toGetTournaments(nTournamentKind);
    end;
  end;

  Result :=
//    '<object name="lobby" id="0">' +
      '<togettournaments kind="' + IntToStr(nTournamentKind) + '" result="0" ' +
          'activetournamentscount="' + IntToStr(TouKindCount) + '" ' +
          'activaplayerscount="' + IntToStr(TouPlayersCount) + '">' +
        '<columns>' +
          '<stats id="200" order="1"/>';

  if nTournamentKind <> 2 then
    Result := Result +
          '<stats id="201" order="2"/>';

  Result := Result +
          '<stats id="1" order="3"/>' +
          '<stats id="202" order="4"/>' +
          '<stats id="203" order="5"/>' +
          '<stats id="204" order="6"/>' +
          '<stats id="205" order="7"/>' +
          '<stats id="206" order="8"/>' +
        '</columns>' +
        '<processes>' +
           sProcessAll +
        '</processes>' +
      '</togettournaments>';
//    '</object>';
end;

function TtsTournamentList.InitTournament(aInpAction: TXMLAction): Integer;
var
  DataXML, GEXML: IXMLDocument;
  TournamentName, CurrentValueXML: string;
  nMaxRegisteredGamers: Integer;
  Root, Node, PropNode: IXMLNode;
  I: Integer;
  NameTourTypeGE: string;
  nTouTypeID, nTouCategory: Integer;
  MastTID: Integer;
  BuyIn, Fee, MastBuyIn, MastFee: Currency;
  RebuyIsAllowed, AddOnIsAllowed: Boolean;
  MaximumRebuyCount: Integer;
  RegStart, TouStart: TDateTime;
  nCurrencyTypeID: Integer;
  nGameTypeID: Integer;
  TournamentID: Integer;
  ActionDispatcherID: Integer;
  FSQL: TSQLAdapter;
  sSettings, sPassword: string;
  sCurrencySign, sCurrencyName: string;

  procedure OnExit(FSQLToFree: TSQLAdapter; TID, nRes: Integer; sGuid: string);
  var
    sBody: string;
  begin
    if FSQLToFree <> nil then
      CommonDataModule.ObjectPool.FreeSQLAdapter(FSQLToFree);

    if sGuid <> '' then begin
      { send MSMQ response about tournamentid }
      sBody := '<setdefprop result="' + IntToStr(nRes) + '" id="' + IntToStr(TID) + '"/>';

      CommonDataModule.SendAdminMSMQ(sBody, sGuid);
    end;
  end;

begin
  CommonDataModule.Log(ClassName, 'InitTournament', 'Init tournament on <setdefprop>',
    ltCall);

  // initial values
  TournamentID := 0;
  ActionDispatcherID := aInpAction.ActionDispatcherID;

  MastTID := 0;
  BuyIn := 0;
  Fee := 0;
  MastBuyIn := 0;
  MastFee := 0;
  nTouTypeID := ttpRegular;

  // create SQL
{$IFDEF __TEST__}
  FSQL := nil;
{$ELSE}
  FSQL := CommonDataModule.ObjectPool.GetSQLAdapter;
{$ENDIF}

  // Open request XML
  try
    DataXML := TXMLDocument.Create(nil);
    DataXML.XML.Text := aInpAction.Action;
    DataXML.Active := True;
  except
    on E: Exception do begin
      CommonDataModule.Log( ClassName, 'InitTournament', 'On Open XML [' + aInpAction.Action + '] exception: ' + E.Message, ltException);
      DataXML.Active := False;
      DataXML := nil;

      Result := TO_ERR_WRONGXMLFILE;
      OnExit(FSQL, TournamentID, Result, aInpAction.Guid);
      Exit;
    end;
  end;

  Root := DataXML.DocumentElement.ChildNodes[0];
  sSettings := Root.XML;

  // Create GEXML
  GEXML := TXMLDocument.Create(nil);
  GEXML.Active := True;
  PropNode := GEXML.AddChild('properties');

  // Fill CurrentValuesXML text and GEXML
  // Open root of CurrentValueXML
  CurrentValueXML := '<ttstournament ';

  nTouCategory := 1;
  RegStart := Now;
  TouStart := Now;
  nCurrencyTypeID := 1;
  nGameTypeID := 1;
  nMaxRegisteredGamers := 0;
  for I:=0 to Root.ChildNodes.Count - 1 do begin
    Node := Root.ChildNodes[I];
    if not Node.HasAttribute('istournament') then begin
      AddXMLItem(Node.XML, PropNode);
    end;

    if      Node.Attributes['name'] = PropName_TournamentName then begin
      TournamentName := Node.Attributes['value'];
    end
    else if Node.Attributes['name'] = PropName_MaxRegisteredGamers then
      nMaxRegisteredGamers := StrToIntDef(Node.Attributes['value'], 0)
    else if Node.Attributes['name'] = PropName_RegistrationStartAt then
      RegStart := StrToDateTime(Node.Attributes['value'], Commondatamodule.AmericanDateTimeFormatSettings)
    else if Node.Attributes['name'] = PropName_TournamentStartAt then
      TouStart := StrToDateTime(Node.Attributes['value'], Commondatamodule.AmericanDateTimeFormatSettings)
    else if Node.Attributes['name'] = PropName_TournamentCategory then begin
      nTouCategory := StrToIntDef(Node.Attributes['value'], tsCategoryTournament);
      if (nMaxRegisteredGamers < 2) and (nTouCategory = tsCategorySitAndGo) then begin
        CommonDataModule.Log( ClassName, 'InitTournament', 'Max registered must be > 2 for sit and go category', ltException);
        GEXML.Active := False;
        GEXML := nil;


        Result := TO_ERR_NOTMULTYTABLE;
        OnExit(FSQL, TournamentID, Result, aInpAction.Guid);
        Exit;
      end;
      CurrentValueXML := CurrentValueXML + 'category="' + IntToStr(nTouCategory) + '" ';
      case nTouCategory of
        tsCategoryTournament: CurrentValueXML := CurrentValueXML + 'starteventid="' + IntToStr(tseByTime) + '" ';
        tsCategorySitAndGo  : CurrentValueXML := CurrentValueXML + 'starteventid="' + IntToStr(tseByEnroled) + '" ';
      end;
{    else if Node.Attributes['name'] = PropName_TournamentStartType then
      CurrentValueXML := CurrentValueXML + 'starteventid="' + Node.Attributes['value'] + '" '
}
    end
    else if Node.Attributes['name'] = PropName_IntervalBetweenTournaments then
      CurrentValueXML := CurrentValueXML + 'tournamentinterval="' + Node.Attributes['value'] + '" '
    else if Node.Attributes['name'] = PropName_DurationRegistration_Start then
      CurrentValueXML := CurrentValueXML + 'sittingduration="' + Node.Attributes['value'] + '" '
    else if Node.Attributes['name'] = PropName_IntervalBetweenLevels then
      CurrentValueXML := CurrentValueXML + 'levelinterval="' + Node.Attributes['value'] + '" '
    else if Node.Attributes['name'] = PropName_IntervalBetweenBreaks then
      CurrentValueXML := CurrentValueXML + 'breakinterval="' + Node.Attributes['value'] + '" '
    else if Node.Attributes['name'] = PropName_BreakDuration then
      CurrentValueXML := CurrentValueXML + 'breakduration="' + Node.Attributes['value'] + '" '
    else if Node.Attributes['name'] = PropName_TimeOutForKickOff then
      CurrentValueXML := CurrentValueXML + 'onkickoff="' + Node.Attributes['value'] + '" '
    else if Node.Attributes['name'] = PropName_TypeOfTournament then
    begin
      nTouTypeID := StrToIntDef(Node.Attributes['value'], ttpRegular);
      CurrentValueXML := CurrentValueXML + 'tournamenttypeid="' + Node.Attributes['value'] + '" '
    end
    else if Node.Attributes['name'] = PropName_MasterTournamentID then
      MastTID := StrToIntDef(Node.Attributes['value'], 0)
    else if Node.Attributes['name'] = PropName_Password then
      sPassword := Node.Attributes['value']
    else if Node.Attributes['name'] = PropName_BuyIn then
    begin
      BuyIn := StrToCurrDef(Node.Attributes['value'], 0);
      CurrentValueXML := CurrentValueXML + 'buyin="' + CurrToStr(BuyIn) + '" '
    end
    else if Node.Attributes['name'] = PropName_Fee then
    begin
      Fee := StrToCurrDef(Node.Attributes['value'], 0);
      CurrentValueXML := CurrentValueXML + 'fee="' + CurrToStr(Fee) + '" ';
    end
    else if Node.Attributes['name'] = PropName_RebuyIsAllowed then
    begin
      RebuyIsAllowed := (LowerCase(Node.Attributes['value']) = 'true');
      CurrentValueXML := CurrentValueXML + 'rebuyisallowed="0" ';
      CurrentValueXML := CurrentValueXML + 'rebuyallowedoncreate="' + IntToStr(Integer(RebuyIsAllowed)) + '" ';
    end
    else if Node.Attributes['name'] = PropName_AddOnIsAllowed then
    begin
      AddOnIsAllowed := (LowerCase(Node.Attributes['value']) = 'true');
      CurrentValueXML := CurrentValueXML + 'addonisallowed="0" ';
      CurrentValueXML := CurrentValueXML + 'addonallowedoncreate="' + IntToStr(Integer(AddOnIsAllowed)) + '" ';
    end
    else if Node.Attributes['name'] = PropName_MaximumCountRebuy then
    begin
      MaximumRebuyCount := StrToIntDef(Node.Attributes['value'], PropDef_MaximumCountRebuy);
      CurrentValueXML := CurrentValueXML + 'rebuycount="' + IntToStr(MaximumRebuyCount) + '" ';
    end
    else if Node.Attributes['name'] = PropName_AmountChipsForParticipant then
      CurrentValueXML := CurrentValueXML + 'chips="' + Node.Attributes['value'] + '" '
    else if Node.Attributes['name'] = PropName_CurrencyType then begin
      if Node.Attributes['value'] = '' then begin
        CommonDataModule.Log(ClassName, 'InitTournament', '[ERROR] CurrencyTypeID is empty', ltError);
      end;
      nCurrencyTypeID := StrToIntDef(Node.Attributes['value'], 1);
      CurrentValueXML := CurrentValueXML + 'currencytypeid="' + IntToStr(nCurrencyTypeID) + '" '
    end
    // from GE
    else if Node.Attributes['name'] = PropName_PokerType then begin
      nGameTypeID := StrToIntDef(Node.Attributes['value'], 1);
      CurrentValueXML := CurrentValueXML + 'gametypename="' + GetNameOfValue(Node) + '" ';
    end
    else if Node.Attributes['name'] = PropName_TypeOfStakes then begin
      CurrentValueXML := CurrentValueXML + 'staketype="' + Node.Attributes['value'] + '" ';
      CurrentValueXML := CurrentValueXML + 'stakename="' + GetNameOfValue(Node) + '" ';
    end
    else if Node.Attributes['name'] = PropName_LowerLimitOfStakes then
      CurrentValueXML := CurrentValueXML + 'initialstake="' + Node.Attributes['value'] + '" '
    else if Node.Attributes['name'] = PropName_MaximumChairsCount then
      CurrentValueXML := CurrentValueXML + 'playerpertable="' + Node.Attributes['value'] + '" '
    else if Node.Attributes['name'] = PropName_TournamentType then begin
      NameTourTypeGE := GetNameOfValue(Node);
      if NameTourTypeGE <> 'Multi Table' then begin
        CommonDataModule.Log( ClassName, 'InitTournament', 'Tournament type is not Multi Table', ltException);
        GEXML.Active := False;
        GEXML := nil;


        Result := TO_ERR_NOTMULTYTABLE;
        OnExit(FSQL, TournamentID, Result, aInpAction.Guid);
        Exit;
      end;
    end;

  end;

  if nTouCategory = 2 then begin
    RegStart := IncMinute(Now, PropDef_RegistrationTimeShift);
    TouStart := IncMinute(Now, PropDef_TournamentStartShift);
    MastTID  := 0;
    if (nTouTypeID = ttpSattelite) then nTouTypeID := ttpRegular;
  end;

  if (RegStart >= TouStart) then begin
    CommonDataModule.Log( ClassName, 'InitTournament',
      'Registration start time is more then tournament start time',
      ltException);

    GEXML.Active := False;
    GEXML := nil;

    Result := TO_ERR_REGISTRATIONISMORETHENSTART;
    OnExit(FSQL, TournamentID, Result, aInpAction.Guid);
    Exit;
  end;

  CurrentValueXML := CurrentValueXML + 'pausecount="0" ';
  CurrentValueXML := CurrentValueXML + 'numberofplayersforfinish="1" ';
  CurrentValueXML := CurrentValueXML + 'registrationstarttime="' + FloatToStr(RegStart) + '" ';
  CurrentValueXML := CurrentValueXML + 'tournamentstarttime="' + FloatToStr(TouStart) + '" ';

  // analis of tournamentType
  if nTouTypeID <> ttpSattelite then MastTID := 0; // tournament is not satelite
  if (MastTID <= 0) and (nTouTypeID = ttpSattelite) then nTouTypeID := ttpRegular;
  CurrentValueXML := CurrentValueXML + 'mastertournamentid="' + IntToStr(MastTID) + '" ';

  if (nTouTypeID <> ttpRestricted) then sPassword := '';
  CurrentValueXML := CurrentValueXML + 'password="' + sPassword + '" ';

  if TournamentName = '' then TournamentName := 'New';
  CurrentValueXML := CurrentValueXML + 'name="' + TournamentName + '" ';
  CurrentValueXML := CurrentValueXML + 'maxregistered="' + IntToStr(nMaxRegisteredGamers) + '" ';

  // from Parameters
  CurrentValueXML := CurrentValueXML + 'gameengineid="3" ';
  // Default values
  CurrentValueXML := CurrentValueXML + 'tournamentfinishtime="" ';
  CurrentValueXML := CurrentValueXML + 'nextbreaktime="" ';
  CurrentValueXML := CurrentValueXML + 'nextleveltime="" ';
  CurrentValueXML := CurrentValueXML + 'statusid="1" ';
  CurrentValueXML := CurrentValueXML + 'tournamentstatusid="1" ';
  CurrentValueXML := CurrentValueXML + 'tournamentlevel="1" ';
  CurrentValueXML := CurrentValueXML + 'handforhandplayers="1" ';

  // Next properties will be filling after execute SQL
  // SQL store procedure execute
  Result := RegistrationTournament(
    FSQL,
    ActionDispatcherID, MastTID, 3, nTouTypeID,
    nGameTypeID, nCurrencyTypeID, nMaxRegisteredGamers, nTouCategory, TournamentName,
    '<gameengine>' + GEXML.DocumentElement.XML + '</gameengine>', TouStart, BuyIn, Fee,
    TournamentID, MastBuyIn, MastFee, sCurrencySign, sCurrencyName);

  GEXML.Active := False;
  GEXML := nil;

  if Result <> 0 then begin
    CommonDataModule.Log(ClassName, 'InitTournament', 'RegistrationTournament return error', ltError);
    OnExit(FSQL, TournamentID, Result, aInpAction.Guid);
    Exit;
  end;

  Result := StoreSettingsXML(FSQL, TournamentID, sSettings);
  if Result <> 0 then begin
    CommonDataModule.Log(ClassName, 'InitTournament', 'StoreSettingsXML return error', ltError);
    OnExit(FSQL, TournamentID, Result, aInpAction.Guid);
    Exit;
  end;

  CurrentValueXML := CurrentValueXML + 'tournamentid="' + IntToStr(TournamentID) +'" ';
  CurrentValueXML := CurrentValueXML + 'actiondispatcherid="' + IntToStr(ActionDispatcherID) + '" ';
  CurrentValueXML := CurrentValueXML + 'masterbuyin="' + CurrToStr(MastBuyIn) +'" ';
  CurrentValueXML := CurrentValueXML + 'masterfee="' + CurrToStr(MastFee) +'" ';
  CurrentValueXML := CurrentValueXML + 'currencysign="' + sCurrencySign +'" ';
  CurrentValueXML := CurrentValueXML + 'currencyname="' + sCurrencyName +'" ';

  // Close CurrentValueXML
  CurrentValueXML := CurrentValueXML + '/>';;
  Result := StoreCurrentValuesXML(FSQL, TournamentID, CurrentValueXML);
  if Result <> 0 then begin
    CommonDataModule.Log(ClassName, 'InitTournament', 'StoreCurrentValuesXML return error', ltError);
    OnExit(FSQL, TournamentID, Result, aInpAction.Guid);
    Exit;
  end;

  { add tournament into list }
  if GetItemByTournamentID(TournamentID) = nil then
    Add(TournamentID).LoadFromDB(FSQL);

  // Send MSMQ response to admin Service
  OnExit(FSQL, TournamentID, 0, aInpAction.Guid);

  CommonDataModule.Log(ClassName, 'InitTournament', 'All Right', ltCall);
end;

function TtsTournamentList.Ins(Index: Integer;
  nTID: Integer): TtsTournament;
begin
  Result := TtsTournament.Create(nTID, Self);
  inherited Insert(Index, Result);
  CommonDataModule.Log(ClassName, 'Insert',
    'New item has been inserted to list at index: ' + IntToStr(Index) +
      ', TournamentID=' + IntToStr(Result.TournamentID),
    ltCall
  );
end;

function TtsTournamentList.LoadFromDB(SQLAdapter: TSQLAdapter): Integer;
var
  I: Integer;
  RS: TDataSet;
  nCnt: Integer;
  aTrn: TtsTournament;
  arrIDs: array of Integer;
begin
{$IFDEF __TEST__}
	Result := 0;
  Exit;
{$ENDIF}

  try
    // stored procedure srvtouGetTournaments
    SQLAdapter.SetProcName('srvtouGetTournaments');
    SQLAdapter.AddParam('RETURN_VALUE',0,ptResult,ftInteger);
    RS := SQLAdapter.ExecuteCommand;
  except
    on E : Exception do begin
      CommonDataModule.Log(ClassName, 'LoadFromDB',
        '[EXCEPTION] on execute srvtouGetTournaments: ' + E.Message,
        ltException);

      Result := TS_ERR_SQLERROR;
      Exit;
    end;
  end;

  if RS.EOF then // not enough messages
  begin
    RS.Close;
    Result := 0;
    Exit;
  end;

  nCnt := 0;
  while not RS.EOF do
  begin
    Inc(nCnt);
    SetLength(arrIDs, nCnt);
    arrIDs[nCnt - 1] := RS.FieldValues['ID'];

    RS.Next;
  end;

  RS.Close;

  for I:=0 to Length(arrIDs) - 1 do begin
    Add(arrIDs[I]).LoadFromDB(SQLAdapter);
  end;

  // delete finished tournaments
  for I:= Count - 1 downto 0 do begin
    aTrn := Items[I];
    if (IncHour(aTrn.TournamentFinishTime, DELETEONFINISHINTERVAL) <= Now)
      and (aTrn.TournamentFinishTime <> 0)
    then begin
      aTrn.StatusID := 3; // not used
      aTrn.StoreToDB(SQLAdapter);
      Del(aTrn);
      Continue;
    end;
  end;

  Result := 0;
//  Result := SortByStartTime(True);

end;

function TtsTournamentList.ProcessAction(aInpAction: TXMLAction): Boolean;
var
  aTournament: TtsTournament;
  FSQL: TSQLAdapter;
begin
  CommonDataModule.Log(ClassName, 'ProcessAction',
    'Entry', ltCall);

{$IFDEF __TEST__}
  FSQL := nil;
{$ELSE}
  FSQL := CommonDataModule.ObjectPool.GetSQLAdapter;
{$ENDIF}

  Result := False;
  try
    if aInpAction.Name = anInitTournament then begin
      if GetItemByTournamentID(aInpAction.TournamentID) = nil then
        Add(aInpAction.TournamentID).LoadFromDB(FSQL);
    end else if aInpAction.Name = anGetDefaultProperty then begin
      GetDefaultProperties(aInpAction.Guid);
    end else if aInpAction.Name = anSetDefaultProperty then begin
      InitTournament(aInpAction);
    end else if aInpAction.Name = anDropTournament then begin
      AdminStopTournament(aInpAction, FSQL);
    end else if aInpAction.Name = anInitPrizePool then begin
      CommandInitPrizePool(aInpAction, FSQL);
    end else if aInpAction.Name = anBettings then begin
      CommandInitBettings(aInpAction, FSQL);
    end else if aInpAction.Name = anAmdKickoffUser then begin
      AdminKickOffUser(aInpAction);
    end else if aInpAction.Name = anAdmPause then begin
      AdminCommandPause(aInpAction, FSQL);
    end else if aInpAction.Name = anAdmPauseAll then begin
      AdminCommandPauseAll(aInpAction, FSQL);
    end else begin
      // next: must have tournamentItem
      aTournament := GetItemByTournamentID(aInpAction.TournamentID);
      if aTournament = nil then begin
        CommonDataModule.Log(ClassName, 'ProcessAction',
          'Tournament not found by ID=' + IntToStr(aInpAction.TournamentID),
          ltCall);
        Exit;
      end;

      if aInpAction.Name = anEndOfHand then begin
        aTournament.EndOfHandAction(
          aInpAction,
          aTournament.FActions, FSQL
        );
      end else if aInpAction.Name = anProcessCrash then begin
        CommonDataModule.Log(ClassName, 'ProcessAction',
          'Income action Process Crash: TournamentID=' + IntToStr(aTournament.TournamentID) +
            ', ProcessID=' + IntToStr(aInpAction.ProcessID) + '; Tournament will be stop.',
          ltCall);

        aTournament.StopTournament(FSQL, aTournament.FActions);

        Exit;
      end else if aInpAction.Name = TO_REGISTER then begin
        CommandRegisterParticipant(aInpAction, FSQL, aTournament);
      end else if aInpAction.Name = TO_UNREGISTER then begin
        CommandUnRegisterParticipant(aInpAction, FSQL, aTournament);
      end else if aInpAction.Name = TO_REBUY then begin
        CommandRebuy(aInpAction, FSQL, aTournament);
      end else if aInpAction.Name = TO_AUTO_REBUY then begin
        CommandAutoRebuy(aInpAction, FSQL, aTournament);
      end else if aInpAction.Name = anBot_GetTableInfo then begin
        CommandBotGetTournamentInfo(aInpAction, aTournament);
      end else if aInpAction.Name = anBot_Sitdown then begin
        CommandBotRegister(aInpAction, aTournament, FSQL);
      end else if aInpAction.Name = anBot_StandUp then begin
        CommandBotStandUp(aInpAction, aTournament, FSQL);
      end else if aInpAction.Name = anBot_StandUp_All then begin
        CommandBotStandUpAll(aInpAction, aTournament, FSQL);
      end else if aInpAction.Name = anBot_Policy then begin
        CommandBotPolicy(aInpAction, aTournament, FSQL);
      end
      else begin
        CommonDataModule.Log( ClassName, 'ProcessAction',
          'Action Is Uncknown: Action=[' + aInpAction.Action + ']',
          ltError
        );
      end;
    end;
  finally
{$IFNDEF __TEST__}
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSQL);
{$ENDIF}
  end;

  Result := True;

  CommonDataModule.Log(ClassName, 'ProcessAction',
    'Exit: All Right', ltCall);
end;

function TtsTournamentList.RegistrationTournament(FSQL: TSQLAdapter;
  ActionDispatcherID, MastID, GameEngineID, TournamentTypeID,
  GameTypeID, CurrencyTypeID, MaxRegistered, CategoryTypeID: Integer;
  TournamentName, GameEngineXML: string; TournamentStartTime: TDateTime;
  BuyIn, Fee: Currency;
  var TournamentID: Integer; var MastBuyIn, MastFee: Currency;
  var CurrencySign, CurrencyName: string
): Integer;
begin
  try
    FSQL.SetProcName('srvtouRegistrationTournament');
    FSQL.AddParInt('RETURN_VALUE', '', ptResult);
    FSQL.AddParInt('ActionDispatcherID', ActionDispatcherID, ptInput);
    FSQL.AddParInt('MasterTournamentID', MastID, ptInput);
    FSQL.AddParInt('GameEngineID', GameEngineID, ptInput);
    FSQL.AddParInt('GameTypeID', GameTypeID, ptInput);
    FSQL.AddParInt('CurrencyTypeID', CurrencyTypeID, ptInput);
    FSQL.AddParInt('MaxRegisteredGamers', MaxRegistered, ptInput);
    FSQL.AddParInt('CategoryTypeID', CategoryTypeID, ptInput);
    FSQL.AddParString('Name', TournamentName, ptInput);
    FSQL.AddParString('GameEngineXML', GameEngineXML, ptInput);
    FSQL.AddParInt('TournamentTypeID', TournamentTypeID, ptInput);
    FSQL.AddParString('TournamentStartTime', DateTimeToODBCStr(TournamentStartTime), ptInput);
    FSQL.AddParam('BuyIn', BuyIn, ptOutput, ftCurrency);
    FSQL.AddParam('Fee', Fee, ptOutput, ftCurrency);
    FSQL.AddParInt('TournamentID', TournamentID, ptOutput);
    FSQL.AddParam('MasterBuyIn', MastBuyIn, ptOutput, ftCurrency);
    FSQL.AddParam('MasterFee', MastFee, ptOutput, ftCurrency);
    FSQL.AddParString('CurrencySign', CurrencySign, ptOutput);
    FSQL.AddParString('CurrencyName', CurrencyName, ptOutput);

    FSQL.ExecuteCommand;

    Result := FSQL.GetParam('RETURN_VALUE');
    if Result <> 0 then begin
      CommonDataModule.Log( ClassName, 'RegistrationTournament',
        'SQL srvtouRegistrationTournament return error result=' + IntToStr(Result) +
        '; Parameters: GameEngineXML=[' + GameEngineXML + ']',
        ltException);

      Result := TO_ERR_SQLCOMMANDERROR;
      Exit;
    end;

    TournamentID := FSQL.GetParam('TournamentID');
    MastBuyIn := FSQL.GetParam('MasterBuyIn');
    MastFee := FSQL.GetParam('MasterFee');
    CurrencySign := FSQL.GetParam('CurrencySign');
    CurrencyName := FSQL.GetParam('CurrencyName');

  except
    on E: Exception do begin
      CommonDataModule.Log( ClassName, 'RegistrationTournament',
        'SQL srvtouRegistrationTournament return exception: ' + E.Message +
        '; Parameters: GameEngineXML=[' + GameEngineXML + ']',
        ltException);

      Result := TO_ERR_SQLCOMMANDERROR;
    end;
  end;
end;

function TtsTournamentList.SortByStartTime(Ascending: Boolean): Integer;
var
  TopInd: Integer;
  I, J: Integer;
  aObj: TtsTournament;
begin
  for I := 0 to Count - 1 do
  begin
    TopInd := I;

    // search next top index
    for J := I+1 to Count - 1 do
    begin
      aObj := Items[J];

      if Ascending then begin
        if Items[TopInd].TournamentStartTime > aObj.TournamentStartTime then TopInd := IndexOf(aObj);
      end else begin
        if Items[TopInd].TournamentStartTime < aObj.TournamentStartTime then TopInd := IndexOf(aObj);
      end;
    end;

    // swap indexes
    aObj := TtsTournament.Create(Items[TopInd].TournamentID, Self);
    aObj.SetContextByObject(Items[TopInd]);
    Items[TopInd].SetContextByObject(Items[I]);
    Items[I].SetContextByObject(aObj);
    aObj.Free;
  end;

  Result := 0;

end;

function TtsTournamentList.StoreCurrentValuesXML(FSQL: TSQLAdapter;
  TournamentID: Integer; CurrentValuesXML: string): Integer;
begin
  try

    FSQL.SetProcName('srvtouSetTournamentCurrentValuesXML');
    FSQL.AddParInt('RETURN_VALUE',0,ptResult);
    FSQL.AddParInt('TournamentID', TournamentID, ptInput);
    FSQL.AddParInt('StatusID', 1, ptInput); // used statusid
    FSQL.AddParString('CurrentValuesXML', CurrentValuesXML, ptInput);

    FSQL.ExecuteCommand;

    Result := FSQL.GetParam('RETURN_VALUE');

    if (Result <> 0) then begin
      CommonDataModule.Log( ClassName, 'StoreCurrentValuesXML',
        'SQL result = ' + IntToStr(Result) + 'Params: TournamentId = ' + IntToStr(TournamentID),
        ltException
      );
    end;

  except on E: Exception do
    begin
      Result := TO_ERR_SQLCOMMANDERROR;
      CommonDataModule.Log( ClassName, 'StoreCurrentValuesXML',
        'SQL: srvtouSetTournamentCurrentValuesXML raise exception: ' + E.Message + 'Params: TournamentId = ' + IntToStr(TournamentID),
        ltException
      );
    end;
  end;

end;

function TtsTournamentList.StoreSettingsXML(FSQL: TSQLAdapter;
  TournamentID: Integer; SettingsXML: string): Integer;
begin
  try
    FSQL.SetProcName('srvtouSetTournamentSettingsXML');
    FSQL.AddParInt('RETURN_VALUE',0,ptResult);
    FSQL.AddParInt('TournamentID', TournamentID, ptInput);
    FSQL.AddParString('SettingsXML', SettingsXML, ptInput);

    FSQL.ExecuteCommand;

    Result := FSQL.GetParam('RETURN_VALUE');

    if (Result <> 0) then begin
      CommonDataModule.Log( ClassName, 'StoreSettingsXML',
        'SQL result = ' + IntToStr(Result) + 'Params: TournamentId = ' + IntToStr(TournamentID),
        ltError
      );
    end;

  except on E: Exception do
    begin
      Result := TO_ERR_SQLCOMMANDERROR;
      CommonDataModule.Log( ClassName, 'StoreSettingsXML',
        'SQL: srvtouSetTournamentSettingsXML raise exception: ' + E.Message + 'Params: TournamentId = ' + IntToStr(TournamentID),
        ltException
      );
    end;
  end;

end;

function TtsTournamentList.StoreToDB(SQLAdapter: TSQLAdapter): Integer;
var
  I: Integer;
begin
{$IFDEF __TEST__}
	Result := 0;
  Exit;
{$ENDIF}

  Result := 0;
  for I:=0 to Count - 1 do begin
    Result := Items[I].StoreToDB(SQLAdapter);

    if Result <> 0 then begin
      CommonDataModule.Log(ClassName, 'StoreToDB',
        '[ERROR] Result=' + IntToStr(Result) + '; On item: TournamentID=' + IntToStr(Items[I].TournamentID),
        ltCall
      );
      Exit;
    end;
  end;
end;

procedure TtsTournamentList.AdminCommandPause(aInpAction: TXMLAction; FSQL: TSQLAdapter);
var
  aTournament: TtsTournament;
begin
  if aInpAction.Status in [1, 2] then begin
    aTournament := GetItemByTournamentID(aInpAction.TournamentID);
    if aTournament = nil then begin
      if aInpAction.Guid <> '' then begin
        CommonDataModule.SendAdminMSMQ(
          '<' + anAdmPause +
            ' tournamentid="' + IntToStr(aInpAction.TournamentID) + '"' +
            ' result="1"' +
            ' msg="Tournament not found."' +
            ' guid="' + aInpAction.Guid + '"' +
          '/>',
          aInpAction.Guid
        );
      end;
      CommonDataModule.Log(ClassName, 'ProcessAction',
        '[ERROR] On Pause by admin XML: Tournament not found; ID=' + IntToStr(aInpAction.TournamentID),
        ltError
      );

      Exit;
    end;

    case aInpAction.Status of
      1: aTournament.EndPauseByAdmin(aInpAction, aTournament.FActions, FSQL);
      2: aTournament.PauseByAdmin(aInpAction, aTournament.FActions, FSQL);
    end;
  end else if aInpAction.Status = 3 then begin
    AdminStopTournament(aInpAction, FSQL);
  end else begin
    CommonDataModule.Log(ClassName, 'AdminCommandPause',
      '[ERROR]: Admin command has incorrect attribute Status. Command=' + aInpAction.Action,
      ltError
    );
  end;
end;

procedure TtsTournamentList.DropTournament(aTournament: TtsTournament; FSQL: TSQLAdapter);
begin
  if aTournament = nil then Exit;
  
  aTournament.StopTournament( FSQL, aTournament.FActions,
    'The tournament has been stoped by administrator.' +
    'All the money for the registration will be returned to you. ' +
    'We appologize for inconvinience.' +
    'Thank you for your understanding.'
  );

  Del(aTournament);
end;

procedure TtsTournamentList.CommandInitPrizePool(aInpAction: TXMLAction; FSQL: TSQLAdapter);
var
  aTournament: TtsTournament;
begin
  aTournament := GetItemByTournamentID(aInpAction.TournamentID);
  if aTournament = nil then begin
    CommonDataModule.Log(ClassName, 'InitPrizePool',
      '[ERROR] On Init prizePool XML Tournament not found; ID=' + IntToStr(aInpAction.TournamentID),
      ltError
    );

  end else begin
    aTournament.Prizes.StoreIntoDB(FSQL, aInpAction.Action);
    aTournament.Prizes.LoadFromDB(FSQL);
    aTournament.Prizes.LoadFromAdmSiteXML(aTournament as TtsTournament);
  end;
end;

procedure TtsTournamentList.CommandInitBettings(aInpAction: TXMLAction; FSQL: TSQLAdapter);
var
  aTournament: TtsTournament;
begin
  aTournament := GetItemByTournamentID(aInpAction.TournamentID);
  if aTournament = nil then begin
    CommonDataModule.Log(ClassName, 'CommandInitBettings',
      '[ERROR] On Init Bettings XML, Tournament not found; ID=' + IntToStr(aInpAction.TournamentID),
      ltError
    );

  end else begin
    aTournament.Bettings.StoreIntoDB(aInpAction.TournamentID, aInpAction.Action, FSQL);
    aTournament.Bettings.LoadFromDB(aInpAction.TournamentID, FSQL);
  end;
end;

procedure TtsTournamentList.AdminKickOffUser(aInpAction: TXMLAction);
var
  aTournament: TtsTournament;
begin
  aTournament := GetItemByTournamentID(aInpAction.TournamentID);
  if aTournament = nil then begin
    if aInpAction.Guid <> '' then begin
      CommonDataModule.SendAdminMSMQ(
        '<' + anAmdKickoffUser +
          ' tournamentid="' + IntToStr(aInpAction.TournamentID) + '"' +
          ' userid="' + IntToStr(aInpAction.UserID) + '"' +
          ' result="1"' +
          ' msg="Tournament not found."' +
          ' guid="' + aInpAction.Guid + '"' +
        '/>',
        aInpAction.Guid
      );
    end;
    CommonDataModule.Log(ClassName, 'ProcessAction',
      '[ERROR] On Kickoff User XML: Tournament not found; ID=' + IntToStr(aInpAction.TournamentID),
      ltError
    );
  end else begin
    aTournament.KickOffUser(aInpAction);
  end;
end;

procedure TtsTournamentList.AdminCommandPauseAll(aInpAction: TXMLAction; FSQL: TSQLAdapter);
var
  I: Integer;
  aTournament: TtsTournament;
begin
  for I:=0 to Count - 1 do begin
    aTournament := Items[I];

    case aInpAction.Status of
      1: aTournament.EndPauseByAdmin(aInpAction, aTournament.FActions, FSQL);
      2: aTournament.PauseByAdmin(aInpAction, aTournament.FActions, FSQL);
      3: DropTournament(aTournament, FSQL);
    else
      CommonDataModule.Log(ClassName, 'AdminCommandPauseAll',
        '[ERROR]: Admin command has incorrect attribute Status. Command=' + aInpAction.Action,
        ltError
      );
    end;
  end;
end;

procedure TtsTournamentList.AdminStopTournament(aInpAction: TXMLAction; FSQL: TSQLAdapter);
var
  aTournament: TtsTournament;
begin
  aTournament := GetItemByTournamentID(aInpAction.TournamentID);
  if aTournament = nil then
    CommonDataModule.Log(ClassName, 'ProcessAction',
      '[ERROR] On Drop by administrator, Tournament not found; ID=' + IntToStr(aInpAction.TournamentID),
      ltError
    )
  else
    DropTournament(aTournament, FSQL);
end;

function TtsTournamentList.LOBBY_toGetTournamentInfo(aTournament: TtsTournament): string;
var
  aMasterTourn: TtsTournament;
  sName: string;
begin
  // open '<object>' and '<togettournamentinfo>'
  Result :=
//    '<object name="' + APP_LOBBY + '" id="0">' +
      '<togettournamentinfo tournamentid="' + IntToStr(aTournament.TournamentID) + '" ' +
        'kind="' + IntToStr(aTournament.TournamentCategory) + '" result="0">';

  Result := Result + aTournament.LOBBY_toGetTournamentInfo;

  if (aTournament.TournamentTypeID = ttpSattelite) and (aTournament.MasterTournamentID > 0) then begin
    aMasterTourn := Self.GetItemByTournamentID(aTournament.MasterTournamentID);
    if (aMasterTourn <> nil) then begin
      Result := Result + '<data value=""/>';
      Result := Result + '<data value=""/>';
      Result := Result + '<data value=""/>';
      Result := Result +
        '<data value="Satellite to " ' +
          'valueref="tournament ' + IntToStr(aTournament.MasterTournamentID) + '" ' +
          'mastertournamentid="' + IntToStr(aTournament.MasterTournamentID) + '"/>';

      sName := FormatDateTime('mmmm dd yyyy	hh:nn am/pm', aMasterTourn.TournamentStartTime);
      sName := StringReplace(sName, #9, ' ', [rfReplaceAll]);
      Result := Result +
        '<data value="(' + sName + ')"/>';
    end;
  end;

  // close '<togettournamentinfo>', '<object>'
  Result := Result + '</togettournamentinfo>'; //</object>';
end;

procedure TtsTournamentList.CommandRegisterParticipant(aInpAction: TXMLAction;
  FSQL: TSQLAdapter; aTournament: TtsTournament);
var
  sResp: string;
  nErrCode: Integer;
begin
  // next: must have UserID
  if aInpAction.UserID <= 0 then begin
    CommonDataModule.Log(ClassName, 'CommandRegisterParticipant',
      'User ID is incorrect ID=' + IntToStr(aInpAction.UserID) +
      '; Action=' + aInpAction.Name,
      ltError);

    Exit;
  end;

  if (aTournament = nil) then begin
    CommonDataModule.Log(ClassName, 'CommandRegisterParticipant',
      'Tournament object is nil: UserID=' + IntToStr(aInpAction.UserID) +
      '; Action=' + aInpAction.Name,
      ltError);

    Exit;
  end;

  sResp := aTournament.LOBBY_toRegister(
    aInpAction.UserID, aInpAction.FromTournamentID, aInpAction.Password,
    FSQL, nErrCode
  );

  if (aInpAction.FromTournamentID <= 0) then
    aTournament.FActions.Add(sResp, aInpAction.SessionID, aInpAction.UserID);
  if (nErrCode = 0) then
    aTournament.Prizes.LoadFromAdmSiteXML(aTournament as TtsTournament);
end;

procedure TtsTournamentList.CommandUnRegisterParticipant(
  aInpAction: TXMLAction; FSQL: TSQLAdapter; aTournament: TtsTournament);
begin
  // next: must have UserID
  if aInpAction.UserID <= 0 then begin
    CommonDataModule.Log(ClassName, 'CommandUnRegisterParticipant',
      'User ID is incorrect ID=' + IntToStr(aInpAction.UserID) +
      '; Action=' + aInpAction.Name,
      ltError);

    Exit;
  end;
  if (aTournament = nil) then begin
    CommonDataModule.Log(ClassName, 'CommandUnRegisterParticipant',
      'Tournament object is nil: UserID=' + IntToStr(aInpAction.UserID) +
      '; Action=' + aInpAction.Name,
      ltError);

    Exit;
  end;

  aTournament.FActions.Add(
    aTournament.LOBBY_toUnRegister(aInpAction.UserID, FSQL),
    aInpAction.SessionID, aInpAction.UserID
  );

  aTournament.Prizes.LoadFromAdmSiteXML(aTournament as TtsTournament);
end;

procedure TtsTournamentList.CommandBotGetTournamentInfo(aInpAction: TXMLAction; aTournament: TtsTournament);
var
  sBody, sGuid, sName: string;
begin
{	<bot_gettableinfo tournamentid="..." guid="..."/> }

  sName := aInpAction.Name;
  sGuid := aInpAction.Guid;
  sBody :=
    '<' + sName + ' result="0" guid="' + sGuid + '">' +
      aTournament.BotGetTournamentInfo +
    '</' + sName + '>';

  CommonDataModule.SendAdminMSMQ(sBody, sGuid);

  { clear strings }
  sName := '';
  sGuid := '';
  sBody := '';
end;

procedure TtsTournamentList.CommandBotRegister(aInpAction: TXMLAction;
  aTournament: TtsTournament; FSQL: TSQLAdapter);
var
  sBody, sGuid: string;
  nErrCode: Integer;
begin
  if (aTournament = nil) then begin
    CommonDataModule.Log(ClassName, 'CommandBotRegister',
      'Tournament object is nil: Command=[' + aInpAction.Action + ']',
      ltError);

    Exit;
  end;

  sGuid := aInpAction.Guid;
  sBody := aTournament.BotsRegister(
    StrToIntDef(aInpAction.TypeOfRequest, 1),
    aInpAction.BotPerProcess, FSQL, nErrCode
  );
  if (nErrCode = 0) then
    aTournament.Prizes.LoadFromAdmSiteXML(aTournament as TtsTournament);

  if (sGuid <> '') then
    CommonDataModule.SendAdminMSMQ(sBody, sGuid);
end;

procedure TtsTournamentList.CommandBotStandUp(aInpAction: TXMLAction;
  aTournament: TtsTournament; FSQL: TSQLAdapter);
var
  sGuid, sBody: string;
  nErrCode: Integer;
begin
{ <bot_standup tournamentid=".." guid="..">
        <bot id="%d"/>
  </bot_standup>
}

  if (aTournament = nil) then begin
    CommonDataModule.Log(ClassName, 'CommandBotStandUp',
      'Tournament object is nil: Command=[' + aInpAction.Action + ']',
      ltError);

    Exit;
  end;

  sGuid := aInpAction.Guid;
  sBody := aTournament.BotStandUp(aInpAction, FSql, nErrCode);
  if (nErrCode = 0) then
    aTournament.Prizes.LoadFromAdmSiteXML(aTournament as TtsTournament);

  if (sGuid <> '') then
    CommonDataModule.SendAdminMSMQ(sBody, sGuid);
end;

procedure TtsTournamentList.CommandBotPolicy(aInpAction: TXMLAction;
  aTournament: TtsTournament; FSQL: TSQLAdapter);
var
  sGuid, sBody: string;
  nErrCode: Integer;
begin
{ <bot_policy  tournamentid=".." type=".." guid="...">
      <bot id=".."/>
  </bot_policy>
}

  if (aTournament = nil) then begin
    CommonDataModule.Log(ClassName, 'CommandBotPolicy',
      'Tournament object is nil: Command=[' + aInpAction.Action + ']',
      ltError);

    Exit;
  end;

  sGuid := aInpAction.Guid;
  sBody := aTournament.BotPolicy(aInpAction, FSql, nErrCode);
  if (nErrCode = 0) then
    aTournament.Prizes.LoadFromAdmSiteXML(aTournament as TtsTournament);

  if (sGuid <> '') then
    CommonDataModule.SendAdminMSMQ(sBody, sGuid);
end;

procedure TtsTournamentList.CommandBotStandUpAll(aInpAction: TXMLAction;
  aTournament: TtsTournament; FSQL: TSQLAdapter);
var
  sGuid, sBody: string;
  nErrCode: Integer;
begin
{ <bot_standup_all  tournamentid=".." guid="..."/> }

  if (aTournament = nil) then begin
    CommonDataModule.Log(ClassName, 'CommandBotStandUpAll',
      'Tournament object is nil: Command=[' + aInpAction.Action + ']',
      ltError);

    Exit;
  end;

  sGuid := aInpAction.Guid;
  sBody := aTournament.BotStandUpAll(aTournament.FTournamentID, FSql, nErrCode);
  if (nErrCode = 0) then
    aTournament.Prizes.LoadFromAdmSiteXML(aTournament as TtsTournament);

  if (sGuid <> '') then
    CommonDataModule.SendAdminMSMQ(sBody, sGuid);
end;

procedure TtsTournamentList.UpdateLobbyInfo;
var
  I: Integer;
  sData: string;
  FSql: TSQLAdapter;
begin
  FSql := CommonDataModule.ObjectPool.GetSQLAdapter;
  try
    { update togettournaments for category 0 (common) }
    sData := GetTournamentsXML(0);
    StoreLobbyInfo_SQL(0, 0, 1, sData, FSql);

    { update togettournaments for category 1 (tournaments) }
    sData := GetTournamentsXML(1);
    StoreLobbyInfo_SQL(0, 1, 2, sData, FSql);

    { update togettournaments for category 2 (Sit and Go) }
    sData := GetTournamentsXML(2);
    StoreLobbyInfo_SQL(0, 2, 3, sData, FSql);

    { update lobby info for every tournay }
    for I:=0 to Count - 1 do Items[I].UpdateLobbyInfo(FSql);
  finally
    CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  end;

  sData := '';
end;

procedure TtsTournamentList.StoreLobbyInfo_SQL(nTournamentID, nTournamentCategoryID, nInfoID: Integer;
  sData: String; FSql: TSQLAdapter);
var
  SqlNotAssigned: Boolean;
begin
  SqlNotAssigned := (FSql = nil);
  if SqlNotAssigned then FSql := CommonDataModule.ObjectPool.GetSQLAdapter;

  try
    try
      FSql.SetProcName('srvtouSetTournamentInfo');
      FSql.AddParam('RETURN_VALUE', 0, ptResult, ftInteger);
      FSql.AddParInt('TournamentID', nTournamentID, ptInput);
      FSql.AddParam('TournamentCategoryID', nTournamentCategoryID, ptInput, ftInteger);
      FSql.AddParam('InfoID', nInfoID, ptInput, ftInteger);
      FSql.AddParam('Data', sData, ptInput, ftString);

      FSql.ExecuteCommand;
    except
      on e: Exception do begin
        CommonDataModule.Log(ClassName, 'StoreLobbyInfo_SQL',
          '[EXCEPTION] On exec srvtouSetTournamentInfo: ' + e.Message +
            '; Params: TournamentID=' + IntToStr(nTournamentID) +
            ', TournamentCategoryID=' + IntToStr(nTournamentCategoryID) +
            ', InfoID=' + IntToStr(nInfoID) +
            ', Data=' + sData,
          ltException);
      end;
    end;
  finally
    if SqlNotAssigned then CommonDataModule.ObjectPool.FreeSQLAdapter(FSql);
  end;
end;

procedure TtsTournamentList.CommandAutoRebuy(aInpAction: TXMLAction;
  FSQL: TSQLAdapter; aTournament: TtsTournament);
var
  sResp: string;
  nErrCode: Integer;
begin
  // next: must have UserID
  if aInpAction.UserID <= 0 then begin
    CommonDataModule.Log(ClassName, 'CommandAutoRebuy',
      '[ERROR]: Incorrect attribute userid for command=[' + aInpAction.Action + ']',
      ltError);
    Exit;
  end;

  if (aTournament = nil) then begin
    CommonDataModule.Log(ClassName, 'CommandAutoRebuy',
      'Tournament object is nil: UserID=' + IntToStr(aInpAction.UserID) +
      '; Action=' + aInpAction.Name,
      ltError);
    Exit;
  end;

  sResp := aTournament.LOBBY_toAutoRebuy(
    aInpAction.UserID, aInpAction.Value, FSQL, nErrCode
  );

  aTournament.FActions.Add(sResp, aInpAction.SessionID, aInpAction.UserID);
end;

procedure TtsTournamentList.CommandRebuy(aInpAction: TXMLAction;
  FSQL: TSQLAdapter; aTournament: TtsTournament);
var
  sResp: string;
  nErrCode: Integer;
begin
  // next: must have UserID
  if aInpAction.UserID <= 0 then begin
    CommonDataModule.Log(ClassName, 'CommandRebuy',
      '[ERROR]: Incorrect attribute userid for command=[' + aInpAction.Action + ']',
      ltError);
    Exit;
  end;

  if (aTournament = nil) then begin
    CommonDataModule.Log(ClassName, 'CommandRebuy',
      'Tournament object is nil: UserID=' + IntToStr(aInpAction.UserID) +
      '; Action=' + aInpAction.Name,
      ltError);
    Exit;
  end;

  if aTournament.FAddOnIsAllowed then begin
    sResp := aTournament.LOBBY_toRebuy(
      aInpAction.UserID, 1, FSQL, nErrCode
    );
  end else begin
    sResp := aTournament.LOBBY_toRebuy(
      aInpAction.UserID, aInpAction.Value, FSQL, nErrCode
    );
  end;

  aTournament.FActions.Add(sResp, aInpAction.SessionID, aInpAction.UserID);
end;

end.
