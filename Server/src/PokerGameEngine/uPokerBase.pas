////////////////////////////////////////////////////////////////////////////////
// Defines basic classes for poker-type game infrastructure
//
//
//------------------------------------------------------------------------------
// $Rev 0.0.5
// by Pavel Perov
// Modify by BS
////////////////////////////////////////////////////////////////////////////////
unit uPokerBase;

interface

uses
//RTL
  Classes,
  SysUtils,
  Math,
  Contnrs,
  Variants,
  XMLDoc, XMLIntF, XMLDom,
//po
  uPokerDefs,
  uErrorHandling,
  uBotConstants
;

////////////////////////////////////////////////////////////////////////////////
// Game Timeouts
////////////////////////////////////////////////////////////////////////////////
const
//  GT_HAND_START_FROM_IDLE         =   30;
  GT_HAND_START_FROM_IDLE         =   5; // For Bikini
  GT_HAND_START_FOR_FULL_TABLE    =   2;
  GT_HAND_START_AFTER_COMPLETION  =   5;
  GT_GAMER_ACTION_TIMEOUT         =  25;
  GT_INTER_TOURNAMENT_INTERVAL    =   5;
  GT_GAMER_RESERVATION_TIMEOUT    = 200;
  GT_GAMER_TOURNAMENT_TIMEBANK    =  60;
  GS_START_ST_TOURNAMENT_TIMEOUT  =   2;
  GS_COUNT_OF_USER_ICONS          =   4;

////////////////////////////////////////////////////////////////////////////////
// Poker Limits
////////////////////////////////////////////////////////////////////////////////
const
  PL_ANTE_THRESHOLD  = 0.5;
  PL_ANTE_MULTIPLIER = 8;

  //!! must be 100% in sum!!
  PL_ST_TOURNAMENT_1ST_PLACE_PRIZE_PERC = 50.0;
  PL_ST_TOURNAMENT_2ND_PLACE_PRIZE_PERC = 30.0;
  PL_ST_TOURNAMENT_3D_PLACE_PRIZE_PERC  = 20.0;

  PL_SKIPPED_BLINDS_TO_BOUNCE   = 3;
  PL_SKIPPED_ANTE_TO_BOUNCE     = 15;

  //rakes
  PL_RAKES_THRESHOLD  = 20;
  PL_RAKES_LIMIT      =  3;
  PL_RAKES_RATE       =  1;

  PL_UNDEFINED_STAKE_AMOUNT = -1;

const
  HANDS_PER_TOURNAMENT_LAYER = 10;
  MAX_TOURNAMENT_RAISE_LEVEL = 7;


////////////////////////////////////////////////////////////////////////////////
// Game logic manipulators
////////////////////////////////////////////////////////////////////////////////
const
  GLM_COMPARE_SUIT = False;


////////////////////////////////////////////////////////////////////////////////
// Base
////////////////////////////////////////////////////////////////////////////////
type
  TpoMessageOriginator = (
    MO_DEALER, MO_ADMIN, MO_GAMERS
  );

type
  TpoTournamentPaymentType = (
    TPT_PERCENT,
    TPT_FIXEDVALUE
  ); //TpoTournamentPaymentType

  TpoTournamentType = (
//    TT_UNDEFINED,
    TT_NOT_TOURNAMENT,
    TT_SINGLE_TABLE,
    TT_MULTI_TABLE
  );//TTournamentType

//custom event hooks
type
  TpoGamer = class;

  TOnMessageDispatch = procedure (
    sMsg: String;
    sTitle: String = '';
    aGamer: TpoGamer = nil;
    nOriginator: TpoMessageOriginator = MO_DEALER;
    nPriority: Integer = 0
  ) of object;

  TOnChatMessage  = procedure (sMsg: String) of object;
  TOnProcCloseAction = procedure (sMsg: String) of object;
  TOnDumpCachedStateToFile = procedure of object;

  TOnPotOperation     = procedure(sContext: String) of object;
  TOnSidePotOperation = procedure(nPotID: Integer; sContext: String) of object;

  TOnGamerOperation = procedure(aGamer: TpoGamer) of object;
  TOnGamerLeaveTable = procedure(aGamer: TpoGamer) of object;

  TOnGamerMessage = procedure(aGamer: TpoGamer; sText: String) of object;
  TOnGamerPopUp = procedure (aGamer: TpoGamer; sCaption, sText: String; nType: Integer) of object;

  TNotifyEventEx = procedure (Sender: Tobject; vInfo: Variant) of object;

  TOnPotReconcileOperation = procedure (
    nUserID: Integer;
    sOpCode: String; nAmount: Integer;
    sComment: String = ''
  ) of object;

  TOnHandReconcileOperation = procedure (
    nHandID: Integer; aGamer: TpoGamer; sOpCode: String; nAmount: Integer;
    sComment: String = ''
  ) of object;

  TOnHandReconcileOperationEx = procedure (vParams: Array of Variant) of object;

  TOnCheckGamerAbility = function (aGamer: TpoGamer): Boolean of object;

  TOnMultyTournamentProcState = procedure (aGamer: TpoGamer) of object;

  TpoStateManager = class
  end;//TpoStateManager

  //base for all gaming objects
  TpoEntity = class(TPersistent)
  private
    FVersion: Integer;
    procedure SetVersion(const Value: Integer);

  protected
    FLoadedVersion: Integer;
    function Load(aReader: TReader): Boolean; virtual;
    function Store(aWriter: TWriter): Boolean; virtual;

  public
    property Version: Integer read FVersion write SetVersion;

  //persitence
    function Serialize(aFiler: TFiler): Boolean;
    function Dump(): String; virtual;

  //generic
    constructor Create;
    destructor Destroy; override;
  end;//TpoEntity


  //TpoAggregate
  //storable class that require fixing links after load
  TpoAggregate = class(TpoEntity)
  protected
    procedure FixElementRefs; virtual; abstract;

  public
    constructor Create;
    destructor Destroy; override;  
  end;//TpoAggregate


////////////////////////////////////////////////////////////////////////////////
// Cards and supplying classes
//
////////////////////////////////////////////////////////////////////////////////
  TpoCardSuit = (
    CS_CLUB, CS_DIAMOND, CS_HEART, CS_SPADE
  );//TpoCardSuit

  TpoCardValue = (//ordered by desc. range
    CV_1, CV_2, CV_3, CV_4, CV_5, CV_6, CV_7, CV_8, CV_9, CV_10,
    CV_JACK, CV_QUEEN, CV_KING, CV_ACE
  );//TpoCardValue

  TPoCardFindFlag = (ffValue, ffSuit, ffBoth);

  TpoCardComparison = (
    CC_LESS,
    CC_EQUAL,
    CC_GREATER
  );

  TpoCardPack = class;
  TpoCard = class(TpoEntity)
  private
    FSuit: TpoCardSuit;
    FValue: TpoCardValue;
    FOpen: Boolean;
    FIsRecycled: Boolean;
    FCustomData: Variant;
    procedure SetSuit(const Value: TpoCardSuit);
    procedure SetValue(const Value: TpoCardValue);
    procedure SetOpen(const Value: Boolean);
    function GetAsString: string;
    procedure SetAsString(const Value: string);
    procedure SetIsRecycled(const Value: Boolean);
    class function CardValueToStrEx(nValue: TpoCardValue): String;
    procedure SetCustomData(const Value: Variant);

  protected
    Fowner: TpoCardPack;
    FShuffleID: Integer;
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;

  public
  //conversion
    class function CardSuiteToStr(nSuit: TpoCardSuit): String;
    class function CardValueToStr(nValue: TpoCardValue): String;
    class function CardValueToStrNatural(nValue: TpoCardValue): String;

    class function StrToCardSuite(sSuite: String): TpoCardSuit;
    class function StrToCardValue(sValue: String): TpoCardValue;

  public
    property Suit: TpoCardSuit read FSuit write SetSuit;
    property Value: TpoCardValue read FValue write SetValue;
    property Open: Boolean read FOpen write SetOpen;
    property AsString: string read GetAsString write SetAsString; //naming: suit_char+card_value
    property IsRecycled: Boolean read FIsRecycled write SetIsRecycled; //out of game

  //general purpose
    property CustomData: Variant read FCustomData write SetCustomData;

  //generic
    //-1 less by range; 0-equal to; 1-greater
    function CompareTo(aCard: TpoCard; bCompareSuit: Boolean = GLM_COMPARE_SUIT): TpoCardComparison;
    //function SwapWith(aCard: TpoCard): Integer;
    function Dump(): String; override;

    constructor Create(
      nSuit: TpoCardSuit;
      nValue: TpoCardValue
    ); reintroduce;
  end;//TpoCard

  //card shot
  TpoCardCollection = class(TpoAggregate)
  private
    FActiveCards: Integer;
    FModified: Boolean;
    function GetByName(Index: String): TpoCard;
    procedure SetActiveCards(const Value: Integer);
    function GetCount: Integer;
    procedure SetModified(const Value: Boolean);
    function GetSeries: String;

  protected
    FOwner: TpoCardPack;
    FCards: TStringList;
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;

  protected
    procedure FixElementRefs; override;
    function GetCards(Index: Integer): TpoCard; virtual;

  public
    property Cards[Index: Integer]: TpoCard read GetCards; default;
    property Count: Integer read GetCount;
    property ByName[Index: String]: TpoCard read GetByName;
    property ActiveCards: Integer read FActiveCards write SetActiveCards; //number of cards used in comb proc
    property RawCards: TStringList read FCards;
    property Series: String read GetSeries;

    //not persistent
    property Modified: Boolean read FModified write SetModified;

    function Find(AValue: TpoCardValue; ASuit: TpoCardSuit; AFindFlag: TPoCardFindFlag; Offset: Integer=0): Integer;
    procedure Shuffle(bClearOpenStatus: Boolean = True);
    procedure Clear; virtual;
    procedure Sort(bCompareSuit: Boolean = GLM_COMPARE_SUIT);
    function AttachCard(aCard: TpoCard): TpoCard;
    function InsertCardAt(aCard: TpoCard; nIndex: Integer): TpoCard;
    function RemoveCardAt(nPosition: Integer): TpoCard;
    function AcqureCardsFrom(aCards: TpoCardCollection): Integer;
    function DealTopCardTo(aCardHolder: TpoCardCollection; bOpen: Boolean): TpoCard;
    function SwapCards(nCard1ID, nCard2ID: Integer): Boolean;
    function ExtractOpenCards(): TpoCardCollection;
    function ExtractClosedCards(): TpoCardCollection;
    function RemoveCard(aCard: TpoCard): Integer;
    procedure RemoveCards(aCards: TpoCardCollection);
    procedure AssignCardName(nID: Integer; sName: String);

    procedure ShuffleOpenCards();
    procedure ShuffleClosedCards();

    function ExtractLowestCard(bUseOpenCards: Boolean): TpoCard;
    function HighCard(bUseOpenCards: Boolean; bHiLoMode: Boolean): TpoCard;
    procedure OpenHand();

  //generic
    function Dump(): String; override;
    function FormSeries(bOwnerMode: Boolean): String;
    function fs(): string;
    function FormLoSeries(): String; //always open, only values
    function IndexOf(aCard: TpoCard): Integer;
    procedure ClearCache();
    procedure ReplaceCardsValue(FromValue, ToValue: TpoCardValue);
    constructor Create(aOwner: TpoCardPack);
    destructor Destroy(); override;
  end;//TpoCardCollection

  //persistens card pack -maintains all cards issued in hand
  TpoCardPack = class(TpoCardCollection)
  private
    function GetByName(Index: string): TpoCard;

  protected
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;
    procedure FixElementRefs; override;
    function GetCards(Index: Integer): TpoCard; override;

  public
    property ByName[Index: string]: TpoCard read GetByName;

  //utils
    procedure Clear; override;
    procedure AllocatePack();
    function AddCard(aCard: TpoCard): TpoCard;

  //generic
    constructor Create;
    destructor Destroy; override;
  end;//TpoCardPack


////////////////////////////////////////////////////////////////////////////////
// Card combination section
////////////////////////////////////////////////////////////////////////////////
//Card Combination Type
  //ordered in desc order by range
  TpoCardCombinationKind = (
    CCK_EMPTY,    //reserved
    CCK_WHEEL,  // for Lo only
    CCK_HIGH_CARD,
    CCK_ONE_PAIR,
    CCK_TWO_PAIR,
    CCK_3_OF_A_KIND,
    CCK_STRAIGHT,
    CCK_FLUSH,
    CCK_FULL_HOUSE,
    CCK_4_OF_A_KIND,
    CCK_STRAIGHT_FLUSH,
    CCK_ROYAL_FLUSH
  );

  TpoCardCombination = class(TpoCardCollection)
  private
    FKind: TpoCardCombinationKind;
    FUserID: Integer;
    FGamer: TpoGamer;
    FDescription: string;
    procedure SetKind(const Value: TpoCardCombinationKind);
    function GetToString: String;
    procedure SetUserID(const Value: Integer);
    procedure SetGamer(const Value: TpoGamer);
    procedure SetDescription(const Value: string);

  protected
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;

  public
    property UserID: Integer read FUserID write SetUserID;
    property Kind: TpoCardCombinationKind read FKind write SetKind;
    property ToString: String read GetToString;
    property Gamer: TpoGamer read FGamer write SetGamer;
    property Description: string read FDescription write SetDescription;

    function Dump(): String; override;
    function CompareTo(ACombination: TpoCardCombination; bCompareSuit: Boolean =
        GLM_COMPARE_SUIT; bBothKickers: Boolean = FALSE): TpoCardComparison;

    function HiBetterThan(ACombination: TpoCardCombination): Boolean;
    function HiBetterOrEqual(ACombination: TpoCardCombination): Boolean;

    function LoBetterThan(ACombination: TpoCardCombination): Boolean;
    function LoBetterOrEqual(ACombination: TpoCardCombination): Boolean;
    function IsLoCombination(): Boolean;

    procedure Clear(); override;
    function AcquireCombination(aCombination: TpoCardCombination): TpoCardCombination;
    function Clone(): TpoCardCombination;
    constructor Create(aOwner: TpoCardPack);
    destructor Destroy; override;
  end;//TpoCardCombination


  TpoCombinations = class(TObjectList)//not storable - calc duty
  private
    function GetCombinations(Index: Integer): TpoCardCombination;

  protected
    FCards: TpoCardPack;
    function Load(aReader: TReader): Boolean;
    function Store(aWriter: TWriter): Boolean;

  public
    property Combinations[Index: Integer]: TpoCardCombination
      read GetCombinations; default;

    function BestCombination(bHiCombination: Boolean; bCompareSuit: Boolean = GLM_COMPARE_SUIT): TpoCardCombination;

  //util
    function AddCombination(aCombination: TpoCardCombination): TpoCardCombination;
    procedure Sort(bCompareSuit: Boolean = GLM_COMPARE_SUIT; bBothKickers: Boolean
        = FALSE);
    procedure SelectWinnerCombinations(
      bUseHiCombinations: Boolean = True;
      b8OrBetter: Boolean = True
    );

  //generic
    procedure ClearAndFree();
    function Dump(): String; virtual;
    constructor Create(aOwner: TpoCardPack);
    destructor Destroy; override;
  end;//TpoCombinations


////////////////////////////////////////////////////////////////////////////////
// Stakes and accounts
////////////////////////////////////////////////////////////////////////////////
  TpoStakeType = (
    ST_UNDEFINED,
    ST_FIXED_LIMIT,
    ST_POT_LIMIT,
    ST_NO_LIMIT,
    ST_SPREAD_LIMIT
  );

  TpoStakeKind = (
    SK_BET,
    SK_RISE,
    SK_RE_RISE,
    SK_CAP
  );

  TpoStake = class(TpoEntity)
  private
    FAmount: Integer;
    FUserID: Integer;
    FPerformedAt: TDateTime;
    FNote: String;
    FStakeType: TpoStakeType;
    FStakeKind: TpoStakeKind;
    procedure SetAmount(Value: Integer);
    procedure SetUserID(Value: Integer);
    procedure SetPerformedAt(const Value: TDateTime);
    procedure SetNote(const Value: String);
    procedure SetStakeType(const Value: TpoStakeType);
    procedure SetStakeKind(const Value: TpoStakeKind);

  protected
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;

  public
    property StakeType: TpoStakeType read FStakeType write SetStakeType;
    property StakeKind: TpoStakeKind read FStakeKind write SetStakeKind;
    property Amount: Integer read FAmount write SetAmount;
    property UserID: Integer read FUserID write SetUserID;
    property PerformedAt: TDateTime read FPerformedAt write SetPerformedAt;
    property Note: String read FNote write SetNote;
  end;//TpoStake


////////////////////////////////////////////////////////////////////////////////
// Gamer
////////////////////////////////////////////////////////////////////////////////
  TpoGamerState = (
  //out of hand
    GS_IDLE,
    GS_SITOUT,
    GS_DISCONNECTED,
    GS_LEFT_TABLE,

  //in hand
    GS_PLAYING,
    GS_ALL_IN,
    GS_FOLD,
    GS_MUCK,
    GS_PASS, //<reserved>
    GS_NONE
  );

//------------------------------------------------------------------------------
// Gamer actions
//------------------------------------------------------------------------------
//playing|sitout|disconnected
  TpoGamerAction = (
  //async
    GA_SIT_OUT,
    GA_WAIT_BB,
    GA_BACK,
    GA_LEAVE_TABLE,

  //ordered actions
    GA_POST_SB,
    GA_POST_BB,
    GA_ANTE,
    GA_POST,
    GA_POST_DEAD,
    GA_FOLD,
    GA_CHECK,
    GA_BET,
    GA_CALL,
    GA_RAISE,

    GA_SHOW_CARDS,
    GA_SHOW_CARDS_SHUFFLED,
    GA_MUCK,
    GA_DONT_SHOW,
    GA_DISCARD_CARDS,
    GA_BRING_IN,

  //surrogate
    GA_TURN_CARDS_OVER,
    GA_ALL_IN,
  //
    GA_USE_TIMEBANK,
  //stub
    GA_NONE
  );//TpoGamerAction

  TpoGamerActions = set of TpoGamerAction;

  TOnGamerAction = procedure (
    aGame: TpoGamer; nAction: TpoGamerAction; vInfo: Array of Variant
  ) of object;


//------------------------------------------------------------------------------
//gamer autoactions
//------------------------------------------------------------------------------
  TpoGamerAutoAction = (
  //one turn
    GAA_AUTO_FOLD,
    GAA_AUTO_CHECK,
    GAA_CHECK_OR_FOLD,
    GAA_CHECK_OR_CALL,
    GAA_AUTO_BET,
    GAA_AUTO_RAISE,
    GAA_AUTO_CALL,
    GAA_BET_OR_RAISE,

  //persistent
    GAA_POST_BLINDS,
    GAA_POST_ANTE,
    GAA_MUCK_LOSING_HANDS,
    GAA_SITOUT_NEXT_HAND,
    GAA_AUTO_WAIT_BB,

  //surrogate
    GAA_AUTO_LEAVE_TABLE,

  //stub
    GAA_NONE
  );//TpoGamerAutoAction

  TpoGamerAutoActions = set of TpoGamerAutoAction;


//------------------------------------------------------------------------------
// Misc
//------------------------------------------------------------------------------
  TpoWinnerNominationType = (
    WNT_NONE,
    WNT_HI_COMBINATION,
    WNT_LO_COMBINATION
  );//TpoWinnerNominationType

  TpoWinnerNominations = set of TpoWinnerNominationType;

//gamer attributes
  TpoChair        = class;
  TpoGamers       = class;
  TpoAccount      = class;
  TpoUserAccount  = class;
  TpoHand         = class;

  TpoTable = class;
  TpoGenericCroupier = class;

  TpoGamer = class(TpoEntity)
  private
    FShowDownPassed: Boolean;
    FChatAllow: Boolean;
    FHandIDWhenLeft: Integer;
    FLastTimeActivity: TDateTime;
    FIsEmailValidated: Boolean;
    FAffiliateID: Integer;
    FIsUpdated: Boolean;
    FImageVersion: Integer;
    FKickOffFromTournament: Boolean;
    FIsBot: Boolean;
    FBotCharacter: TFixUserCharacter;
    FBotBlaffersEvent: Integer;
    FBotID: Integer;
    FIsTakedSit: Boolean;
    FLevelID: Integer;
    FIcons: TStringList;
    FCountOfRases: Integer;
    procedure SetSessionID(const Value: LongInt);
    procedure SetState(const Value: TpoGamerState);
    function GetAttribute(Index: String): String;
    procedure SetAttribute(Index: String; const Value: String);
    procedure SetUserID(const Value: Integer);
    procedure SetUserName(const Value: String);
    procedure SetSexID(const Value: Integer);
    procedure SetCity(const Value: String);
    function GetIsWatcher: Boolean;
    function GetIsDealer: Boolean;
    function GetStateAsString: String;
    function GetIsReadyForHand: Boolean;
    function GetIsAtTheTable: Boolean;
    procedure SetPassCurrentHand(const Value: Boolean);
    procedure SetPassNextHand(const Value: Boolean);
    function GetIndexOf: Integer;
    function GetIsActive: Boolean;
    function GetIsPlaying: Boolean;
    function GetHasBets: Boolean;
    function GetHasBetsInCurrentRound: Boolean;
    function GetIsFirstInRaund: Boolean;
    function GetHand: TpoHand;
    procedure SetDuringGameAddedMoney(const Value: Integer);
    procedure SetShowCardsAtShowdown(const Value: Boolean);
    function GetCroupier: TpoGenericCroupier;
    procedure SetWaitForBigBlind(const Value: Boolean);
    procedure SetMustSetBigBlind(const Value: Boolean);
    procedure SetMustSetPostDead(const Value: Boolean);
    function GetIsSmallBlind: Boolean;
    function GetIsBigBlind: Boolean;
    procedure SetLastActionInRound(const Value: TpoGamerAction);
    procedure SetWinnerNominations(const Value: TpoWinnerNominations);
    procedure SetAllInOrder(const Value: Integer);
    procedure SetAvatarID(const Value: Integer);
    function GetChair: TpoChair;
    function GetNativeStateAsString: String;
    function GetBets: Integer;
    procedure SetIsSitOut(const Value: Boolean);
    procedure StandUp;
    procedure SetMustSetPost(const Value: Boolean);
    procedure SetSkippedRequiredStakes(const Value: Integer);
    procedure SetAutoActionStake(const Value: Integer);
    function GetPassNextHand: Boolean;
    procedure SetDisconnected(const Value: Boolean);
    procedure SetFinishedTournament(const Value: Boolean);
    procedure SetAllInRejectionHandID(const Value: Integer);
    procedure SetActivateTimeBank(const Value: Boolean);
    procedure SetTimeBankActivated(const Value: Boolean);
    procedure SetRegularTimeoutActivated(const Value: Boolean);
    procedure SetRegularTimeoutExpired(const Value: Boolean);
    procedure SetTournamentTimebank(const Value: Integer);
    procedure SetIP(const Value: String);
    procedure SetShowDownPassed(const Value: Boolean);
    procedure SetChatAllow(const Value: Boolean);
    procedure SetHandIDWhenLeft(const Value: Integer);
    procedure SetLastTimeActivity(const Value: TDateTime);
    procedure SetAffiliateID(const Value: Integer);
    procedure SetIsEmailValidated(const Value: Boolean);
    procedure SetIsUpdated(const Value: Boolean);
    procedure SetImageVersion(const Value: Integer);
    procedure SetKickOffFromTournament(const Value: Boolean);
    procedure SetIsBot(const Value: Boolean);
    procedure SetBotCharacter(const Value: TFixUserCharacter);
    procedure SetBotBlaffersEvent(const Value: Integer);
    procedure SetBotID(const Value: Integer);
    procedure SetIsTakedSit(const Value: Boolean);
    function GetIsTakedSit: Boolean;
    procedure SetLevelID(const Value: Integer);
    procedure SetCountOfRases(const Value: Integer);
  protected
    FSessionID: LongInt;
    FState: TpoGamerState;
    FAttributes: TStringList;
    FUserID: Integer;
    FUserName: String;
    FSexID: Integer;
    FAvatarID: Integer;
    FCity: String;
    FChairID: Integer;
    FAccount: TpoUserAccount;
    FGamers: TpoGamers;
    FCards: TpoCardCollection;
    FWaitForBigBlind: Boolean;
    FFinishedHands: Integer;
    FCombinations: TpoCombinations;
    FShowCardsAtShowdown: Boolean;
    FDuringGameAddedMoney: Integer;
    FSkippedHands: Integer;
    FMustSetBigBlind: Boolean;
    FMustSetPostDead: Boolean;
    FWinnerNominations: TpoWinnerNominations;
    FAllInOrder: Integer;
    FIsSitOut: Boolean;
    FMustSetPost: Boolean;

    //
    FPassCurrentHand: Boolean;
    FPassNextHand: Boolean;
    FInitialBalance: Integer;
    FLastActionInRound: TpoGamerAction;
    FPrevChairID: Integer;

    FSkippedRequiredStakes: Integer;
    FAutoActions: TpoGamerAutoActions;

  //tournament addon
    FRegularTimeoutActivated: Boolean;
    FRegularTimeoutExpired: Boolean;
    FTournamentTimebank: Integer;
    FActivateTimeBank: Boolean;
    FTimeBankActivated: Boolean;

    FBalanceBeforeLastHand: Integer;
    FTournamentPlace: Integer;
    FAllInRejectionHandID: Integer;
    FTournamentPrizePercentage: Currency;
    FTournamentPrizeBonus: Currency;
    FFinishedTournamentTime: TDateTime;

  //turn over cards for allin
    FTurnedCardsOver: Boolean;
    FSheduledToLeaveTable: Boolean;
    FSkippedSBStake: Boolean;
    FSkippedBBStake: Boolean;

  //host - dispatch optimization
    FSessionHost: String;
    FAutoActionStake: Integer;
    FDisconnected: Boolean;
    FFinishedTournament: Boolean;
    FIP: String;
    FLastSkippedHandID: Integer;

  protected
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;

  public
    property SessionID: LongInt read FSessionID write SetSessionID;
    property UserID: Integer read FUserID write SetUserID;
    property UserName: String read FUserName write SetUserName;
    property SexID: Integer read FSexID write SetSexID;
    property City: String read FCity write SetCity;
    property AvatarID: Integer read FAvatarID write SetAvatarID;
    property ImageVersion: Integer read FImageVersion write SetImageVersion;
    property IsUpdated: Boolean read FIsUpdated write SetIsUpdated;
    property State: TpoGamerState read FState write SetState;
    property IsSitOut: Boolean read FIsSitOut write SetIsSitOut;
    property Account: TpoUserAccount read FAccount;
    property Attribute[Index: String]: String read GetAttribute
      write SetAttribute; default;
    property Cards: TpoCardCollection read FCards;
    property ChairID: Integer read FChairID;
    property PassCurrentHand: Boolean read FPassCurrentHand write SetPassCurrentHand;
    property PassNextHand: Boolean read GetPassNextHand write SetPassNextHand;
    property ShowDownPassed: Boolean read FShowDownPassed write SetShowDownPassed;
    property ShowCardsAtShowdown: Boolean read FShowCardsAtShowdown write SetShowCardsAtShowdown;
    property Combinations: TpoCombinations read FCombinations;
    property PrevChairID: Integer read FPrevChairID;
    property WaitForBigBlind:Boolean read FWaitForBigBlind write SetWaitForBigBlind;
    property MustSetBigBlind: Boolean read FMustSetBigBlind write SetMustSetBigBlind;
    property MustSetPostDead: Boolean read FMustSetPostDead write SetMustSetPostDead;
    property MustSetPost: Boolean read FMustSetPost write SetMustSetPost;
    property LastActionInRound: TpoGamerAction read FLastActionInRound write SetLastActionInRound;
    property AllInOrder: Integer read FAllInOrder write SetAllInOrder;
    property KickOffFromTournament: Boolean read FKickOffFromTournament write SetKickOffFromTournament;
    property FinishedTournament: Boolean read FFinishedTournament write SetFinishedTournament;
    property FinishedTournamentTime: TDateTime read FFinishedTournamentTime;
    property AllInRejectionHandID: Integer read FAllInRejectionHandID write SetAllInRejectionHandID;
    property IP: String read FIP write SetIP;
    property BalanceBeforeLastHand: Integer read FBalanceBeforeLastHand;
    property ChatAllow: Boolean read FChatAllow write SetChatAllow;
    property AffiliateID: Integer read FAffiliateID write SetAffiliateID;
    property IsEmailValidated: Boolean read FIsEmailValidated write SetIsEmailValidated;
    property LevelID: Integer read FLevelID write SetLevelID;
    property Icons: TStringList read FIcons;
    property CountOfRases: Integer read FCountOfRases write SetCountOfRases;

    property HandIDWhenLeft: Integer read FHandIDWhenLeft write SetHandIDWhenLeft;
    property LastTimeActivity: TDateTime read FLastTimeActivity write SetLastTimeActivity;
    property IsTakedSit: Boolean read GetIsTakedSit write SetIsTakedSit;

    //autoactions
    property AutoActions: TpoGamerAutoActions read FAutoActions write FAutoActions;
    property AutoActionStake: Integer read FAutoActionStake write SetAutoActionStake;
    property Disconnected: Boolean read FDisconnected write SetDisconnected;
    property SkippedSBStake: Boolean read FSkippedSBStake;
    property SkippedBBStake: Boolean read FSkippedBBStake;
    property SessionHost: String read FSessionHost write FSessionHost;

    // Bots
    property IsBot: Boolean read FIsBot write SetIsBot;
    property BotCharacter: TFixUserCharacter read FBotCharacter write SetBotCharacter;
    property BotBlaffersEvent: Integer read FBotBlaffersEvent write SetBotBlaffersEvent;
    property BotID: Integer read FBotID write SetBotID;

    //surrogate props
    property StateAsString: String read GetStateAsString;
    property NativeStateAsString: String read GetNativeStateAsString;
    property IndexOf: Integer read GetIndexOf;
    property Chair: TpoChair read GetChair;

  //checks for turnpoint status
    property IsWatcher: Boolean read GetIsWatcher;
    property IsDealer: Boolean read GetIsDealer;
    property IsActive: Boolean read GetIsActive;
    property IsReadyForHand: Boolean read GetIsReadyForHand;
    property IsAtTheTable: Boolean read GetIsAtTheTable;
    property IsPlaying: Boolean read GetIsPlaying;
    property IsFirstInRaund: Boolean read GetIsFirstInRaund;
    property IsSmallBlind: Boolean read GetIsSmallBlind;
    property IsBigBlind: Boolean read GetIsBigBlind;
    property WinnerNominations: TpoWinnerNominations read FWinnerNominations write SetWinnerNominations;
    property TournamentPlace: Integer read FTournamentPlace;
    property TournamentPrizePercentage: Currency read FTournamentPrizePercentage;
    property TournamentPrizeBonus: Currency read FTournamentPrizeBonus;
    property SkippedRequiredStakes: Integer read FSkippedRequiredStakes
      write SetSkippedRequiredStakes;

    property RegularTimeoutActivated: Boolean read FRegularTimeoutActivated write SetRegularTimeoutActivated;
    property RegularTimeoutExpired: Boolean read FRegularTimeoutExpired write SetRegularTimeoutExpired;
    property TournamentTimebank: Integer read FTournamentTimebank write SetTournamentTimebank;
    property ActivateTimeBank: Boolean read FActivateTimeBank write SetActivateTimeBank;
    property TimeBankActivated: Boolean read FTimeBankActivated write SetTimeBankActivated;


    property HasBets: Boolean read GetHasBets;
    property Bets: Integer read GetBets;
    property HasBetsInCurrentRound: Boolean read GetHasBetsInCurrentRound;
    property Hand: TpoHand read GetHand;
    property DuringGameAddedMoney: Integer read FDuringGameAddedMoney write SetDuringGameAddedMoney;
    property Croupier: TpoGenericCroupier read GetCroupier;

  //gamer actions
    procedure SitDownAt(aChar: TpoChair; nAmount: Integer);
    procedure SitOut;
    procedure Back;
    procedure ClearSkippedBlinds();

  //events
    procedure OnNewHandNotify(aHand: TpoHand);
    procedure OnNewRoundNotify(aHand: TpoHand);
    procedure OnHandFinishNotify(aHand: TpoHand);

  //generic
    function Dump(): String; override;
    constructor Create(aGamers: TpoGamers);
    destructor Destroy; override;
  end;//TpoGamer


  TpoGamers = class(TpoAggregate)
  private
    FAllInsCount: Integer;
    function GetGamers(Index: Integer): TpoGamer;
    function GetCount: Integer;
    procedure SetDealer(const Value: TpoGamer);
    function GetDealer: TpoGamer;
    procedure SetActiveGamerActions(const Value: TpoGamerActions);
    procedure SetInactiveGamerActions(const Value: TpoGamerActions);
    procedure SetWatcherActions(const Value: TpoGamerActions);
    procedure SetAllInsCount(const Value: Integer);

  public
    procedure DumpGamers();

  protected
    FTable: TpoTable;
    FGamers: TObjectList;
    FActiveGamerActions: TpoGamerActions;
    FInactiveGamerActions: TpoGamerActions;
    FWatcherActions: TpoGamerActions;

    procedure ClearLeftGamers(bSuppressNotification: Boolean = False);
    procedure ClearAllInGamers(nAllInThreshold: Integer = 0);

  protected
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;
    procedure FixElementRefs; override;

  public
    property Gamers[Index: Integer]: TpoGamer read GetGamers; default;
    property Count: Integer read GetCount;
    property Dealer: TpoGamer read GetDealer write SetDealer;

    property WatcherActions: TpoGamerActions read FWatcherActions write SetWatcherActions;
    property InactiveGamerActions: TpoGamerActions read FInactiveGamerActions write SetInactiveGamerActions;
    property ActiveGamerActions: TpoGamerActions read FActiveGamerActions write SetActiveGamerActions;
    property AllInsCount: Integer read FAllInsCount write SetAllInsCount;

  //utils
    function GamerByUserID(nID: Integer): TpoGamer;
    function GamerByBotID(nID: Integer): TpoGamer;
    function GamerBySessionID(nSessionID: Integer): TpoGamer;
    function GamerByPosition(nPosition: Integer): TpoGamer;
    function GamerByName(sName: string): TpoGamer;
    function Add(aGamer: TpoGamer): TpoGamer;
    procedure Remove(aGamer: TpoGamer);
    function Extract(aGamer: TpoGamer): TpoGamer;

    function RegisterGamer(
      nSessionID: Integer;
      sHost: String;
      nUserID: Integer;
      sUserName: String;
      nSexID: Integer;
      sCity: String;
      nAvatarID: Integer;
      nImageVersion: Integer;
      bChatAllow: Boolean;
      nAffiliateID: Integer;
      bIsEmailValidated: Boolean;
      nLevelID: Integer;
      aIcons: TStringList
    ): TpoGamer;

    function UnregisterGamer(
      nSessionID: Integer
    ): Boolean;

    function UpdateGamer(
      nSessionID: Integer;
      sHost: String;
      nUserID: Integer;
      sUserName: String;
      nSexID: Integer;
      sCity: String;
      nAvatarID: Integer;
      nImageVersion: Integer;
      sIP: String;
      bChatAllow: Boolean;
      nAffiliateID: Integer;
      bIsEmailValidated: Boolean;
      nLevelID: Integer;
      aIcons: TStringList
    ): TpoGamer; overload;

    function UpdateGamer(
      aGamer: TpoGamer;
      nSessionID: Integer;
      sHost: String;
      nUserID: Integer;
      sUserName: String;
      nSexID: Integer;
      sCity: String;
      nAvatarID: Integer;
      nImageVersion: Integer;
      sIP: String;
      bChatAllow: Boolean;
      nAffiliateID: Integer;
      bIsEmailValidated: Boolean;
      nLevelID: Integer;
      aIcons: TStringList
    ): TpoGamer; overload;

    procedure ClearGamerCards();
    procedure Clear;
    procedure CalcGamerStats(var nGamersCnt, nWatchersCnt: Integer);
    function CountOfWatchers: Integer;
    procedure DeleteGamer(aGamer: TpoGAmer);
  //generic
    function Dump(): String; override;
    constructor Create(aTable: TpoTable);
    destructor Destroy; override;
  end;//TpoGamers


////////////////////////////////////////////////////////////////////////////////
// Gaming workaround - table and chairs
////////////////////////////////////////////////////////////////////////////////
  TpoChairState = (
    CS_EMPTY,
    CS_BUSY,
    CS_RESERVED,
    CS_HIDDEN
  );

  TpoChairs = class;
  TpoChair = class(TpoAggregate)
  private
    FFUserID: Integer;
    FHidden: Boolean;
    FDrinksID: Integer;
    FDrinksName: string;
    procedure SetUserID(const Value: Integer);
    function GetState: TpoChairState;
    function GetID: Integer;
    function GetStateAsString: String;
    function GetIsDealer: Boolean;
    function GetGamer: TpoGamer;
    function GetIsActive: Boolean;
    function GetIsPlaying: Boolean;
    function GetIsAllIn: Boolean;
    function GetIsBusy: Boolean;
    function GetIsSitOut: Boolean;
    procedure SetReservationUserID(const Value: Integer);
    procedure SetHidden(const Value: Boolean);
    procedure SetDrinksID(const Value: Integer);
    procedure SetDrinksName(const Value: string);

  protected
    FReservationUserID: Integer;
    FChairs: TpoChairs;

  protected
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;
    procedure FixElementRefs; override;

  protected
    property IsSitOut: Boolean read GetIsSitOut;
    property IsPlaying: Boolean read GetIsPlaying;
    property IsAllIn: Boolean read GetIsAllIn;

  public
    property ID: Integer read GetID;
    property State: TpoChairState read GetState;
    property UserID: Integer read FFUserID write SetUserID;
    property ReservationUserID: Integer read FReservationUserID write SetReservationUserID;
    property Hidden: Boolean read FHidden write SetHidden;
    //
    property DrinksName: string read FDrinksName write SetDrinksName;
    property DrinksID: Integer read FDrinksID write SetDrinksID;

    //calculated
    property StateAsString: String read GetStateAsString;
    property Gamer: TpoGamer read GetGamer;
    property IsDealer: Boolean read GetIsDealer;
    property IsBusy: Boolean read GetIsBusy;
    property IsActive: Boolean read GetIsActive;

  //reservation
    procedure SetReservation(nUserID: Integer);
    procedure ClearReservation();
    procedure KickOffGamer(bSuppressNotification: Boolean = False);

  //utility
    function IndexOf(): Integer;
    constructor Create;
  end;//TpoChair


  TpoChairs = class(TpoAggregate)
  private
    function GetCount: Integer;
    procedure SetCount(const Value: Integer);
    function GetChairs(Index: Integer): TpoChair;
    function GetBusyChairs: Integer;
    function GetDealerChairID: Integer;
    function GetWithGamerChairsCount: Integer;

  protected
    FTable: TpoTable;
    FChairs: TObjectList;

  protected
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;
    procedure FixElementRefs; override;

  public
    property Chairs[Index: Integer]: TpoChair read GetChairs; default;
    property Count: Integer read GetCount write SetCount;
    property BusyChairsCount: Integer read GetBusyChairs;
    property WithGamerChairsCount: Integer read GetWithGamerChairsCount;
    property DealerChairID: Integer read GetDealerChairID;

  //utils
    procedure KickOffAllGamers(bSuppressNotification: Boolean = False);
    function ClearGamerReservations(nUserID: Integer): Integer;
    function GetFreeChairsCount(): Integer;
    function GetFirstFreeChair(): TpoChair;
    procedure HideAllInChairs(nAllInThreshold: Integer = 0; sMessage: String = '');
    function GetReservedChairByUserID(nUserID: Integer): TpoChair;

  //generic
    constructor Create;
    destructor Destroy; override;
  end;//TpoChairs


  TpoReservation = class(TpoEntity)
  private
    FChairID: Integer;
    FUserID: Integer;
    FPriority: Integer;
    FExpired: Boolean;
    FCanceled: Boolean;
    FUpToTime: TDateTime;
    FCondition: String;
    procedure SetChairID(const Value: Integer);
    procedure SetUserID(const Value: Integer);
    procedure SetPriority(const Value: Integer);
    procedure SetExpired(const Value: Boolean);
    procedure SetCanceled(const Value: Boolean);
    procedure SetUpToTime(const Value: TDateTime);
    procedure SetCondition(const Value: String);

  protected
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;

  public
    property ChairID: Integer read FChairID write SetChairID;
    property UserID: Integer read FUserID write SetUserID;
    property Priority: Integer read FPriority write SetPriority;
    property Expired: Boolean read FExpired write SetExpired;
    property Canceled: Boolean read FCanceled write SetCanceled;
    property Condition: String read FCondition write SetCondition;
    property UpToTime: TDateTime read FUpToTime write SetUpToTime;
  end;//TpoReservation


  TpoReservations = class(TpoAggregate)
  private
    function GetReservations(Index: Integer): TpoReservation;
    function GetCount: Integer;

  protected
    FReservations: TObjectList;

  protected
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;
    procedure FixElementRefs; override;

  public
    property Reservations[Index: Integer]: TpoReservation read GetReservations; default;
    property Count: Integer read GetCount;

  //game
    function PutReservation(nUserID, nChairID: Integer): TpoReservation;
    function RemoveReservation(nUserID, nChairID: Integer): TpoReservation;

  //generic
    constructor Create;
    destructor Destroy; override;
  end;//TpoReservations


  TpoRakes = class;
  TpoRakeRulesItem = class;
  TpoTable = class(TpoAggregate)
  private
    FSourcePot: Integer;
    FValueOfFracsToNextHand: Currency;
    FMandatoryAnte: Integer;
    procedure SetName(const Value: string);
    function GetActiveGamer: TpoGamer;
    procedure SetBigBetValue(const Value: Integer);
    procedure SetSmallBetValue(const Value: Integer);
    procedure SetDefBuyIn(const Value: Integer);
    procedure SetMaxBuyIn(const Value: Integer);
    procedure SetMinBuyIn(const Value: Integer);
    function GetCards: TpoCardPack;
    procedure SetCurrencyID(const Value: Integer);
    procedure SetAveragePot(const Value: Currency);
    procedure SetPlayedHands(const Value: Integer);
    procedure SetAvgPlayersAtFlop(const Value: Integer);
    procedure SetHandsPerHour(const Value: Integer);
    procedure SetSourcePot(const Value: Integer);
    procedure SetValueOfFracsToNextHand(const Value: Currency);
    procedure SetMandatoryAnte(const Value: Integer);

  protected
    FName: string;
    FCasinoAccount: TpoAccount;
    FRakes: TpoRakes;
    FChairs: TpoChairs;
    FGamers: TpoGamers;
    FReservations: TpoReservations;
    FHand: TpoHand;
    FCroupier: TpoGenericCroupier;
    FRakeRulesItem: TpoRakeRulesItem;

    FBigBetValue: Integer;
    FSmallBetValue: Integer;
    FMaxBuyIn: Integer;
    FMinBuyIn: Integer;
    FDefBuyIn: Integer;

    FCurrencyID: Integer;

    FAveragePot: Currency;
    FAvgPlayersAtFlop: Integer;
    FPlayedHands: Integer;
    FHandsPerHour: Integer;
    FLastFinishedHandStamp: TDateTime;

  public
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;
    procedure FixElementRefs; override;

  public
    property Name: string read FName write SetName;
    property Chairs: TpoChairs read FChairs;
    property Gamers: TpoGamers read FGamers;
    property CasinoAccount: TpoAccount read FCasinoAccount;
    property Rakes: TpoRakes read FRakes;
    property Hand: TpoHand read FHand;
    property ActiveGamer: TpoGamer read GetActiveGamer;
    property Cards: TpoCardPack read GetCards;
    property RakeRules: TpoRakeRulesItem read FRakeRulesItem;

    property SmallBetValue: Integer read FSmallBetValue write SetSmallBetValue;
    property BigBetValue: Integer read FBigBetValue write SetBigBetValue;
    property MandatoryAnte: Integer read FMandatoryAnte write SetMandatoryAnte;
    property MinBuyIn: Integer read FMinBuyIn write SetMinBuyIn;
    property MaxBuyIn: Integer read FMaxBuyIn write SetMaxBuyIn;
    property DefBuyIn: Integer read FDefBuyIn write SetDefBuyIn;
    property CurrencyID: Integer read FCurrencyID write SetCurrencyID;

    property ValueOfFracsToNextHand: Currency read FValueOfFracsToNextHand write SetValueOfFracsToNextHand;

  //stats
    property PlayedHands: Integer read FPlayedHands write SetPlayedHands;
    property SourcePot: Integer read FSourcePot write SetSourcePot;
    property AveragePot: Currency read FAveragePot write SetAveragePot;
    property AvgPlayersAtFlop: Integer read FAvgPlayersAtFlop write
        SetAvgPlayersAtFlop;
    property HandsPerHour: Integer read FHandsPerHour write SetHandsPerHour;

  //events
    procedure OnNewHandNotify(aHand: TpoHand);
    procedure OnNewRoundNotify(aHand: TpoHand);
    procedure OnHandFinishNotify(aHand: TpoHand);

  //utils
    function GamerAtTheTableByIP(sIP: String): TpoGamer;

  //generic
    function Dump(): String; override;
    constructor Create;
    destructor Destroy; override;
  end;//TpoTable


////////////////////////////////////////////////////////////////////////////////
// Accounting section
////////////////////////////////////////////////////////////////////////////////
//basic accounts
  TpoAccountCurrency = (
    AC_DEFAULT,
    AC_PLAY_MONEY,
    AC_USD,
    AC_EUR, //reserved
    AC_CHIP //reserved
  );

  TpoAccountType = (
    AT_DEBIT,
    AT_CREDIT,
    AT_MIXED    //reserved for for non-balanced accounts
  );

  TpoAccounts = class;
  TpoAccountClass = class of TpoAccount;
  TpoAccount = class(TpoEntity)
  private
    procedure SetAccountCurrency(const Value: TpoAccountCurrency);
    function GetBalance: Integer;
    function GetIndexOf: Integer;

  protected
    //ref to parent
    FAccounts: TpoAccounts;

  protected
    FAccountCurrency: TpoAccountCurrency;
    FAccountType: TpoAccountType;
    FName: String;
    FDebitBalance,
    FCreditBalance: Integer;
    function GetName: String; virtual;

  protected
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;

  public
    property AccountType: TpoAccountType read FAccountType;
    property AccountCurrency: TpoAccountCurrency read FAccountCurrency write
        SetAccountCurrency;
    property Balance: Integer read GetBalance;
    property CreditBalance: Integer read FCreditBalance;
    property DebitBalance: Integer read FDebitBalance;
    property Name: String read GetName;

    property IndexOf: Integer read GetIndexOf;

    procedure AddFunds(nAmount: Integer);
    procedure ChargeFunds(nAmount: Integer);
    function IsBalanced(): Boolean;
    procedure  Clear(); virtual;

    procedure AssignBalance(nAmount: Integer);
  //generic
    function Dump(): String; override;
    constructor Create(
      sName: String;
      nType: TpoAccountType;
      nCurrency: TpoAccountCurrency
    ); reintroduce; virtual;
  end;//TpoAccount

  TpoAccounts = class(TpoAggregate)
  private
    function GetAccounts(Index: Integer): TpoAccount;
    function GetCount: Integer;

  protected
    FAccounts: TObjectList;
    function GetAccountClass(): TpoAccountClass; virtual;

  protected
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;
    procedure FixElementRefs; override;


  public
    property Accounts[Index: Integer]: TpoAccount read GetAccounts; default;
    property Count: Integer read GetCount;

  //util
    function AllAreBalanced(): Boolean;
    function AddAccount(aAccount: TpoAccount): TpoAccount;
    function AccountByName(sName: String): TpoAccount;
    procedure Clear;
    function TotalBalance: Integer;

  //generic
    function Dump(): String; override;
    constructor Create;
    destructor Destroy; override;
  end;//TpoAccounts


//gamer-specific accounts
  TpoUserAccount = class(TpoAccount)
  protected
    FUserID: Integer;
    function GetName(): String; override;

  protected
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;

  public
    property UserID: Integer read FUserID; //set internally by all objects of this section
    function Dump(): String; override;
  end;//TpoUserAccount


  TpoAccountState = (
    AS_ACTIVE,
    AS_FOLDED,
    AS_ALL_IN
  );

  TpoUserSettlementAccount = class(TpoUserAccount)
  private
    FState: TpoAccountState;
    procedure SetState(const Value: TpoAccountState);
    function GetStateAsString: String;

  protected
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;

  public
    property State: TpoAccountState read FState write SetState;
    property StateAsString: String read GetStateAsString;
    function Dump(): String; override;
  end;//TpoUserPotAccount


  TpoUserPotSubAccount = class(TpoUserAccount)
  private
    FIsWinner: Boolean;
    FInHICategory: Boolean;
    FState: TpoAccountState;
    FInLoCategory: Boolean;
    FLoWinnerSubBalance: Integer;
    FHiWinnerSubBalance: Integer;
    procedure SetIsWinner(const Value: Boolean);
    procedure SetState(const Value: TpoAccountState);
    procedure SetInHICategory(const Value: Boolean);
    function GetStateAsString: String;
    procedure SetInLoCategory(const Value: Boolean);
    procedure SetLoWinnerSubBalance(const Value: Integer);
    procedure SetHiWinnerSubBalance(const Value: Integer);

  protected
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;

  public
    property IsWinner: Boolean read FIsWinner write SetIsWinner;
    property InHiCategory: Boolean read FInHICategory write SetInHICategory;
    property InLoCategory: Boolean read FInLoCategory write SetInLoCategory;
    property State: TpoAccountState read FState write SetState;
    property StateAsString: String read GetStateAsString;
    property HiWinnerSubBalance: Integer read FHiWinnerSubBalance write SetHiWinnerSubBalance;
    property LoWinnerSubBalance: Integer read FLoWinnerSubBalance write SetLoWinnerSubBalance;

  //generic
    function Dump(): String; override;
  end;//TpoUserPotsubAccount


  TpoUserPotSubAccounts = class(TpoAccounts)
  private
    function GetContributorUserID(Index: Integer): Integer;
    function GetSubAccounts(Index: Integer): TpoUserPotSubAccount;

  protected
    function GetAccountClass(): TpoAccountClass; override;

  public
    property SubAccounts[Index: Integer]: TpoUserPotSubAccount read GetSubAccounts; default;
    property ContributorUserID[Index: Integer]: Integer read GetContributorUserID;

    function GetUserSubAccount(nUserID: Integer): TpoUserPotSubAccount;
    function HasAllInSubAccounts(): Boolean;

    function UpdateSubAccount(
      nUserID: Integer; nAmount: Integer
    ): TpoUserPotSubAccount;

  //generic

  end;//TpoUserPotSubAccounts


  TpoUserIDs = Array of Integer;
  TpoPotSettlementAccount = class(TpoAccount)
  private
    FMaxOperationAmount: Integer;
    FSubAccounts: TpoUserPotSubAccounts;
    FRakesToCharge: Integer;
    FOnPotReconcileOperation: TOnPotReconcileOperation;
    FHandledInShowdown: Boolean;
    procedure SetMaxOperationAmount(const Value: Integer);
    function GetHiCategoryWinnersCount: Integer;
    function GetLoCategoryWinnersCount: Integer;
    procedure SetRakesToCharge(const Value: Integer);
    procedure SetOnPotReconcileOperation(
      const Value: TOnPotReconcileOperation);
    procedure SetHandledInShowdown(const Value: Boolean);

  protected
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;

  public
  //props
    property MaxOperationAmount: Integer read FMaxOperationAmount write SetMaxOperationAmount;
    property HiCategoryWinnersCount: Integer read GetHiCategoryWinnersCount;
    property LoCategoryWinnersCount: Integer read GetLoCategoryWinnersCount;
    property RakesToCharge: Integer read FRakesToCharge write SetRakesToCharge;
    property SubAccounts: TpoUserPotSubAccounts read FSubAccounts;
    property HandledInShowdown: Boolean read FHandledInShowdown write SetHandledInShowdown;

  //
    property OnPotReconcileOperation: TOnPotReconcileOperation read FOnPotReconcileOperation write SetOnPotReconcileOperation;

  //
    procedure RegisterWinner(aGamer: TpoGamer; bInHiCategory: Boolean);
    function RearrangeWinnersSubAccounts(pReconsileHook: TOnPotReconcileOperation): Currency;
    function HasAllInSubAccounts(): Boolean;
    function GetPlayingUserIDs(): TpoUserIDs;

    function Dump(): String; override;
    constructor Create(
      sName: String;
      nType: TpoAccountType;
      nCurrency: TpoAccountCurrency
    ); override;
    destructor Destroy; override;
  end;//TpoUserPotAccount


  TpoUserSettlementAccounts = class(TpoAccounts)
  protected
    function GetAccountClass(): TpoAccountClass; override;

  public
    function HasAllInAccounts(): Boolean;
    function GetMinBalance(): Integer;
    function GetMaxBalance(): Integer;
    procedure FoldGamerAccount(nUserID: Integer);
    function GetAccountByUserID(nUserID: Integer): TpoUserSettlementAccount;
    function UnbalancedAccountCount(): Integer;
    function FindFirstUnbalancedAccount(): TpoUserSettlementAccount;
  end;//TpoUserSettlementAccounts


  TpoPot = class;
  TpoPotSettlementAccounts = class(TpoAccounts)
  private
    function GetBalance: Integer;
    function GetSubAccount(Index: Integer): TpoPotSettlementAccount;

  protected
    FPot: TpoPot;
    function GetAccountClass(): TpoAccountClass; override;

  public
    property Balance: Integer read GetBalance;
    property Accounts[Index: Integer]: TpoPotSettlementAccount read GetSubAccount; default;

  //util
    function ActiveSidePot(): TpoPotSettlementAccount;
    function AddSidePot(): TpoPotSettlementAccount;
  end;//TpoCummulativePotAccount


  TpoRakeType = (
    RT_AMOUNT,
    RT_PERCENT
  );

  TpoRake = class(TpoEntity)
  private
    FAmount: Integer;
    FCharged: Boolean;
    FRakeType: TpoRakeType;
    FChargeThreshold: Integer;
    procedure SetAmount(const Value: Integer);
    procedure SetCharged(const Value: Boolean);
    procedure SetRakeType(const Value: TpoRakeType);
    procedure SetChargeThreshold(const Value: Integer);

  protected
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;

  public
    property Amount: Integer read FAmount write SetAmount;
    property RakeType: TpoRakeType read FRakeType write SetRakeType;
    property Charged: Boolean read FCharged write SetCharged;
    property ChargeThreshold: Integer read FChargeThreshold write SetChargeThreshold;
  end;//TpoRake


  TpoRakes = class(TpoAggregate)
  private
    FTotalLimit: Integer;
    procedure SetTotalLimit(const Value: Integer);
    function GetRakes(Index: Integer): TpoRake;
    function GetCount: Integer;

  protected
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;
    procedure FixElementRefs; override;

  protected
    FRakes: TObjectList;

  public
    property Rakes[Index: Integer]: TpoRake read GetRakes; default;
    property Count: Integer read GetCount;
    property TotalLimit: Integer read FTotalLimit write SetTotalLimit;

  //game
    procedure Reset;
    function Add(aRake: TpoRake): TpoRake;

  //generic:
    constructor Create;
    destructor Destroy; override;
  end;//TpoRakes

  { BS rake rules classes }
  TpoRakeRule = class(TObject)
  private
    FValue: Integer;
    FTotalLimit: Integer;
    FThreshold: Integer;
    FOwner: TpoRakeRulesItem;
    FCountOfPlayers: Integer;
    procedure SetThreshold(const Value: Integer);
    procedure SetTotalLimit(const Value: Integer);
    procedure SetValue(const Value: Integer);
    procedure SetCountOfPlayers(const Value: Integer);
    procedure SetContextByObject(aObject: TpoRakeRule);
  protected
    function Load(aReader: TReader): Boolean;
    function Store(aWriter: TWriter): Boolean;
  public
    property Threshold: Integer read FThreshold write SetThreshold;
    property TotalLimit: Integer read FTotalLimit write SetTotalLimit;
    property Value: Integer read FValue write SetValue;
    property CountOfPlayers: Integer read FCountOfPlayers write SetCountOfPlayers;
    //
    property Owner: TpoRakeRulesItem read FOwner;
    // generic
    constructor Create(aOwner: TpoRakeRulesItem);
    destructor Destroy; override;
  end;

  TpoRakeRulesRoot = class;

  TpoRakeRulesItem = class(TObjectList)
  private
    FLowerLimitStake: Integer;
    FOwner: TpoRakeRulesRoot;
    FSorted: Boolean;
    function GetItems(nIndex: Integer): TpoRakeRule;
    procedure SetLowerLimitStake(const Value: Integer);
    procedure SetItem(nIndex: Integer; const Value: TpoRakeRule);
  protected
    function Load(aReader: TReader): Boolean;
    function Store(aWriter: TWriter): Boolean;
  public
    property Items[nIndex: Integer]: TpoRakeRule read GetItems write SetItem;
    property LowerLimitStake: Integer read FLowerLimitStake write SetLowerLimitStake;
    property Owner: TpoRakeRulesRoot read FOwner;
    property Sorted: Boolean read FSorted;
    //
    function AddItem(nThreshold, nTotalLimit, nValue, nCountOfPlayers: Integer): TpoRakeRule;
    procedure DelItem(nIndex: Integer); overload;
    procedure DelItem(aItem: TpoRakeRule); overload;
    //
    procedure SetContextByObject(aObject: TpoRakeRulesItem);
    procedure SortByCountPlayers(Ascending: Boolean = True);
    procedure SetContextByNode(aNodeRoot: IXMLNode);
    procedure SetDefault;
    // generic
    constructor Create(aOwner: TpoRakeRulesRoot);
    destructor Destroy; override;
  end;

  TpoRakeRulesRoot = class(TObjectList)
  private
    FSorted: Boolean;
    FOwner: TpoRakeRulesItem;
    function GetItems(nIndex: Integer): TpoRakeRulesItem;
    procedure SetItem(nIndex: Integer; const Value: TpoRakeRulesItem);
  protected
    function Load(aReader: TReader): Boolean;
    function Store(aWriter: TWriter): Boolean;
  public
    property Items[nIndex: Integer]: TpoRakeRulesItem read GetItems write SetItem;
    property Owner: TpoRakeRulesItem read FOwner;
    property Sorted: Boolean read FSorted;
    //
    function AddItem(nLowerLimitStake: Integer): TpoRakeRulesItem;
    procedure DelItem(nIndex: Integer); overload;
    procedure DelItem(aItem: TpoRakeRulesItem); overload;
    //
    procedure SortByLowerLimitStake(Ascending: Boolean = True);
    procedure SortAll(Ascending: Boolean = True);
    procedure SetContextByNode(aNodeRoot: IXMLNode);
    procedure SetContextByXMLText(sXML: string);
    // generic
    constructor Create;
    destructor Destroy; override;
  end;

  //operations
  TpoTransaction = class(TpoEntity)
  private
    procedure SetDescription(const Value: String);

  protected
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;

  protected
    FTargetAccountName: String;
    FSourceAccountName: String;
    FAmount: Integer;
    FContext: String;
    FStamp: TDateTime;
    FDescription: String;
    FSenderChairID: Integer;

  protected
    FFiltered: Boolean;

  public
    property SourceAccountName: String read FSourceAccountName;
    property TargetAccountName: String read FTargetAccountName;
    property Amount: Integer read FAmount;
    property Context: String read FContext;
    property Stamp: TDateTime read FStamp;
    property Description: String read FDescription write SetDescription;
    property SenderChairID: Integer read FSenderChairID;

  //generic
    constructor Create(
      sSourceAccountName,
      sTargetAccountName: String;
      nAmount: Integer;
      sContext: String
    ); reintroduce;
  end;//TpoTransaction


  TpoTransactions = class(TpoAggregate)
  private
    FContextFilter: String;
    FMessageContext: string;
    function GetTransactions(Index: Integer): TpoTransaction;
    procedure SetContextFilter(const Value: String);
    function GetCount: Integer;
    procedure SetMessageContext(const Value: string);

  protected
    FContexts: TStringList;
    FTransactions: TObjectList;

  protected
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;
    procedure FixElementRefs; override;

  public
    property Transactions[Index: Integer]: TpoTransaction read GetTransactions; default;
    property Count: Integer read GetCount;
    property ContextFilter: String read FContextFilter write SetContextFilter;
    property MessageContext: string read FMessageContext write SetMessageContext;

  //util
    function SourceTotal(sSourceAccountName: String): Integer;
    function TargetTotal(sTargetAccountName: String): Integer;
    function AddTransaction(
      aTransaction: TpoTransaction
    ): TpoTransaction;
    procedure Clear;

  //generic
    constructor Create;
    destructor Destroy; override;
  end;//TpoTransactions


  //TpoPot
  TpoPot = class(TpoAggregate)
  private
    function GetRakesToCharge: Integer;

  protected
    FHand: TpoHand;
    FRakes: TpoRakes;

  protected
    FUserSettleAccounts: TpoUserSettlementAccounts;
    FCasinoSettleAccount: TpoAccount;
    FSidePots: TpoPotSettlementAccounts;
    FTransactions: TpoTransactions;
    FMaxRoundStakeValue: Integer;

  protected
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;
    procedure FixElementRefs; override;

  public
    property Bets: TpoUserSettlementAccounts read FUserSettleAccounts;
    property SidePots: TpoPotSettlementAccounts read FSidePots;
    property CasinoSettleAccount: TpoAccount read FCasinoSettleAccount;
    property Transactions: TpoTransactions read FTransactions;
    property RakesToCharge: Integer read GetRakesToCharge;

  //game
    procedure Reset;
    procedure NewRound;
    function RegisterGamerForSettlement(aGamer: TpoGamer): TpoGamer;

  //fiscal operations
    procedure MoveMoney(
      aSource, aTarget: TpoAccount;
      nAmount: Integer;
      sContext: String = '';
      sDescription: String =''
    );

    function UserHasBets(nUserID: Integer): Boolean;
    function UserHasBetsInRound(nUserID: Integer): Boolean;
    procedure ReconcileWinners(sContext: String);
    procedure CleanUpRakes;

    function IsBalanced(): Boolean;
    procedure ChargeRakes();
    procedure CleanupSettleAccounts();

    //all playing gamers has the same balance
    function BetsAreBalanced(bSkipAllIn: Boolean = True): Boolean;
    function TotalAmount(): Integer;

    function FoldGamerAccounts(nUserID: Integer): Boolean;

  //generic
    function Dump(): String; override;

    constructor Create(
      aHand: TpoHand; aRakes: TpoRakes
    ); reintroduce;

    destructor Destroy; override;
  end;//TpoPot


////////////////////////////////////////////////////////////////////////////////
// Hand context
////////////////////////////////////////////////////////////////////////////////
  TpoHandState = (
  //sigle table
    HST_IDLE, HST_STARTING, HST_RUNNING, HST_FINISHED,
  //tournament
    HST_INIT
  );

  TpoHand = class(TpoAggregate)
  private
    FRaisesInRound: Integer;
    FLastRaiseAmount: Integer;
    FNoFlopNoDropRuleActive: Boolean;
    FPlayersCntAtFlop: Integer;
    procedure SetHandID(const Value: Integer);
    procedure SetState(Value: TpoHandState);
    procedure SetRoundID(const Value: Integer);
    function GetStateAsString: String;

    //stake rates
    procedure SetDealerChairID(const Value: Integer);
    procedure SetActiveChairID(const Value: Integer);
    function GetDealerGamer: TpoGamer;
    procedure SetRoundOpenChairID(const Value: Integer);
    function GetPrevGamerInRound: TpoGamer;
    function GetOpenRoundGamer: TpoGamer;
    function GetSmallBlindGamer: TpoGamer;
    function GetBigBlindGamer: TpoGamer;
    function GetActiveGamer: TpoGamer;
    procedure SetActiveGamer(const Value: TpoGamer);
    procedure SetSmallBlindGamer(const Value: TpoGamer);
    procedure SetOpenRoundGamer(const Value: TpoGamer);
    procedure SetPlayersCntAtStartOfHand(const Value: Integer);
    procedure SetNoFlopNoDropRuleActive(const Value: Boolean);
    procedure SetPlayersCntAtFlop(const Value: Integer);
    procedure SetShuffleSeed(const Value: LongInt);

  protected
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;
    procedure FixElementRefs; override;
    procedure RegisterRaise(nAmount: Integer);

  protected
    FPrevHandID: Integer;
    FHandID: Integer;
    FHandStartingChairID: Integer;
    FState: TpoHandState;
    FCardDeck: TpoCardPack;
    FCardsToDeal: TpoCardCollection;
    FDroppedCards: TpoCardCollection;
    FPot: TpoPot;
    FCommunityCards: TpoCardCollection;
    FBestHiCombination: TpoCardCombination;
    FBestLoCombination: TpoCardCombination;

    FRoundID: Integer;
    FPrevActiveChairID,
    FActiveChairID: Integer;
    FPrevDealerChairID,
    FDealerChairID: Integer;
    FSmallBlindChairID: Integer;
    FBigBlindChairID: Integer;
    FRoundOpenChairID: Integer;

    FUseLoBetting : Boolean;
    FHiBettingCanBeUsed   : Boolean;

  //last action chairs in last betting round
    FLastBettingRoundOpenChair : Integer;
    FLastBettingRoundBetChair  : Integer;
    FLastBettingRoundRaiseChair: Integer;
    FHandActionSeqID           : Integer;
    FHandIsBreaked             : Boolean;
    FPlayersCntAtStartOfHand   : Integer;
    FShuffleSeed               : LongInt;

  protected
    FTable: TpoTable;
    function RegisterGamerForHand(aGamer: TpoGamer): Boolean;
    function PreparePlayingGamers: Boolean;

  public
    property HandID: Integer read FHandID write SetHandID;
    property PrevHandID: Integer read FPrevHandID;
    property State: TpoHandState read FState write SetState;
    property CardDeck: TpoCardPack read FCardDeck;
    property CardsToDeal: TpoCardCollection read FCardsToDeal;
    property DroppedCards: TpoCardCollection read FDroppedCards;
    property CommunityCards: TpoCardCollection read FCommunityCards;
    property RoundID: Integer read FRoundID write SetRoundID;
    property ActiveChairID: Integer read FActiveChairID write SetActiveChairID;
    property DealerChairID: Integer read FDealerChairID write SetDealerChairID;
    property RoundOpenChairID: Integer read FRoundOpenChairID write SetRoundOpenChairID;
    property PlayersCntAtStartOfHand: Integer read FPlayersCntAtStartOfHand write SetPlayersCntAtStartOfHand;
    property PlayersCntAtFlop: Integer read FPlayersCntAtFlop write SetPlayersCntAtFlop;
    property RaisesInRound: Integer read FRaisesInRound;
    property LastRaiseAmount: Integer read FLastRaiseAmount;
    property Pot: TpoPot read FPot;
    property NoFlopNoDropRuleActive: Boolean read FNoFlopNoDropRuleActive write SetNoFlopNoDropRuleActive;
    property ShuffleSeed: LongInt read FShuffleSeed write SetShuffleSeed;

    //calculated
    property StateAsString: String read GetStateAsString;
    property DealerGamer: TpoGamer read GetDealerGamer;
    property SmallBlindGamer: TpoGamer read GetSmallBlindGamer write SetSmallBlindGamer;
    property BigBlindGamer: TpoGamer read GetBigBlindGamer;
    property ActiveGamer: TpoGamer read GetActiveGamer write SetActiveGamer;

    property OpenRoundGamer: TpoGamer read GetOpenRoundGamer write SetOpenRoundGamer;
    property PrevGamerInRound: TpoGamer read GetPrevGamerInRound;
    property HandActionSeqID: Integer read FHandActionSeqID;

  //stake rates
  //can depend on game progress
  //game
    //calc status and register gamers
    procedure ResetCardDeck;
    function Reset(): Boolean;
    procedure NewRound();
    function Start(nHandID: Integer): Boolean;
    function Finish(): Boolean;
    function GetBetForGamer(aGamer: TpoGamer): Integer;
    function GetCurrentStakeValue(): Integer;
    procedure IncHandAction();

  //generic
    function Dump(): String; override;

    constructor Create(aTable: TpoTable); reintroduce;
    destructor Destroy; override;
  end;//TpoHand


////////////////////////////////////////////////////////////////////////////////
// Croupier
////////////////////////////////////////////////////////////////////////////////
  TpoPokerType = (
    PT_UNDEFINED,       //0 - undefined
    PT_TEXAS_HOLDEM,    //1 - Texas Hold'em
    PT_OMAHA,           //2 – Omaha
    PT_OMAHA_HILO,      //3 - Omaha Hi Lo
    PT_SEVEN_STUD,      //4 - Seven Stud
    PT_SEVEN_STUD_HILO, //5 - Seven Stud Hi Lo
    PT_FIVE_CARD_DRAW,  //6 - Five Card Draw
    PT_FIVE_CARD_STUD,  //7 - Five Card Stud
    PT_CRAZY_PINEAPPLE  //8 - Crazy Pineapple
  );

  TpoPokerTypeClass = (
    PTC_OPEN_CARDS_POKER,
    PTC_CLOSED_CARDS_POKER
  );

  TpoGenericCroupierClass = class of TpoGenericCroupier;
  TpoGenericCroupier = class(TpoAggregate)
  private
    FPokerType: TpoPokerType;
    FStakeType: TpoStakeType;
    FOnAbandonHandStarting: TNotifyEvent;
    FOnActivePlayer: TOnGamerOperation;
    FOnChairStateChange: TNotifyEventEx;
    FOnChatMessage: TOnMessageDispatch;
    FOnDealCards: TNotifyEventEx;
    FOnDontShowCards: TOnGamerOperation;
    FOnGamerSitOut: TOnGamerOperation;
    FOnHandFinish: TonPotOperation;
    FOnHandReconcileOperation: TOnHandReconcileOperation;
    FOnHandStart: TNotifyEvent;
    FOnHandStarted: TNotifyEventEx;
    FOnHandStarting: TNotifyEventEx;
    FOnLeaveTable: TOnGamerOperation;
    FOnMoreChips: TOnGamerOperation;
    FOnMoveBets: TonPotOperation;
    FOnMuck: TOnGamerOperation;
    FOnRoundFinish: TNotifyEvent;
    FOnSetActivePlayer: TNotifyEvent;
    FOnShowCards: TOnGamerOperation;
    FOnSitOut: TOnGamerOperation;
    FOnUpdateGamerDetails: TOnGamerOperation;
    FOnProcCloseAction: TOnProcCloseAction;
    FOnDumpCachedStateToFile: TOnDumpCachedStateToFile;
    FOnGamerBack: TOnGamerOperation;
    FOnGamerAction: TOnGamerAction;
    FOnOpenRoundGamer: TOnChatMessage;
    FOnGamerCloseProcess: TNotifyEventEx;
    FOnGamerKickOff: TOnGamerMessage;
    FOnGamerLeaveTable: TOnGamerLeaveTable;
    FOnChangeGamersCount: TNotifyEvent;
    FOnPotReconcileFinish: TOnSidePotOperation;
    FOnCheckGamerAllins: TOnCheckGamerAbility;
    FTournamentType: TpoTournamentType;
    FOnPrepareReorderedPackets: TOnGamerOperation;
    FOnMultyTournamentProcState: TOnMultyTournamentProcState;
    FCurrencySymbol: string;
    FMinGamersForStartHand: Integer;
    procedure SetPokerType(const Value: TpoPokerType);
    function GetPokerClass: TpoPokerTypeClass;
    function GetPokerTypeAsString: string;
    procedure SetStakeType(const Value: TpoStakeType);
    procedure SetOnAbandonHandStarting(const Value: TNotifyEvent);
    procedure SetOnActivePlayer(const Value: TOnGamerOperation);
    procedure SetOnChairStateChange(const Value: TNotifyEventEx);
    procedure SetOnChatMessage(const Value: TOnMessageDispatch);
    procedure SetOnDealCards(const Value: TNotifyEventEx);
    procedure SetOnDontShowCards(const Value: TOnGamerOperation);
    procedure SetOnGamerSitOut(const Value: TOnGamerOperation);
    procedure SetOnHandFinish(const Value: TOnPotOperation);
    procedure SetOnHandReconcileOperation(const Value: TOnHandReconcileOperation);
    procedure SetOnHandStart(const Value: TNotifyEvent);
    procedure SetOnHandStarted(const Value: TNotifyEventEx);
    procedure SetOnHandStarting(const Value: TNotifyEventEx);
    procedure SetOnLeaveTable(const Value: TOnGamerOperation);
    procedure SetOnMoreChips(const Value: TOnGamerOperation);
    procedure SetOnMoveBets(const Value: TonPotOperation);
    procedure SetOnMuck(const Value: TOnGamerOperation);
    procedure SetOnRoundFinish(const Value: TNotifyEvent);
    procedure SetOnSetActivePlayer(const Value: TNotifyEvent);
    procedure SetOnShowCards(const Value: TOnGamerOperation);
    procedure SetOnSitOut(const Value: TOnGamerOperation);
    function GetChairs: TpoChairs;
    function GetGamers: TpoGamers;
    function GetHand: TpoHand;
    procedure SetOnUpdateGamerDetails(const Value: TOnGamerOperation);
    procedure SetOnProcCloseAction(const Value: TOnProcCloseAction);
    procedure SetOnGamerBack(const Value: TOnGamerOperation);
    procedure SetOnGamerAction(const Value: TOnGamerAction);
    procedure SetOnOpenRoundGamer(const Value: TOnChatMessage);
    procedure SetOnGamerCloseProcess(const Value: TNotifyEventEx);
    procedure SetOnGamerKickOff(const Value: TOnGamerMessage);
    procedure SetOnGamerLeaveTable(const Value: TOnGamerLeaveTable);
    procedure SetOnChangeGamersCount(const Value: TNotifyEvent);
    procedure SetOnPotReconcileFinish(const Value: TOnSidePotOperation);
    procedure SetOnCheckGamerAllins(const Value: TOnCheckGamerAbility);
    procedure SetTournamentType(const Value: TpoTournamentType);
    procedure SetOnPrepareReorderedPackets(const Value: TOnGamerOperation);
    procedure SetOnMultyTournamentProcState(const Value: TOnMultyTournamentProcState);
    procedure SetOnDumpCachedStateToFile(const Value: TOnDumpCachedStateToFile);
    procedure SetCurrencySymbol(const Value: string);
    procedure SetMinGamersForStartHand(const Value: Integer);

  protected
    FTable: TpoTable;

    procedure SendMessage(
      sMsg: String; sTitle: String = ''; aGamer: TpoGamer = nil;
      nOriginator: TpoMessageOriginator = MO_DEALER; nPriority: Integer = 0
    );

    procedure SendProcCloseAction(sMsg: string);
    procedure DumpCachedStateToFile;

    procedure CalcGamersShowDownCombinations;
    procedure DealCommunityCards;
    procedure DealGamerCards;
    function IsLastBettingRound: Boolean;
    function IsPreliminaryRound: Boolean;
    function RoundsInHand: Integer;
    function GetBettingTxContextName(nUserID: Integer): String;
    function GetCommunityCardsCntForCombination: Integer;
    function GetGamerCardsCntForCombination(aGamer: TpoGamer): Integer;
    function SitOutCanTakeStepRight(): Boolean; virtual; abstract;
    function MandatoryStakesSkipperMustBeBounced: Boolean; virtual; abstract;
    procedure ChargeRakes(); virtual;

  public
    function IsShowdownRound: Boolean;
    procedure HandleLeftGamers(bSuppressNotification: Boolean = False); virtual; abstract;

  protected
  //pot hook
    procedure OnPotReconcileOperation(
      nUserID: Integer;
      sOpCode: String; nAmount: Integer;
      sComment: String = ''
    ); virtual;

  public
    function StepRightChairsCount(): Integer; virtual; abstract;
    function AllChairsShowDownPassed(): Boolean; virtual; abstract;
    function ReadyToPlayChairsCount(): Integer; virtual; abstract;
    function WinnerCandidatesCount(): Integer; virtual; abstract;
    function ChairCanTakeStepRight(aChair: TpoChair): Boolean; virtual; abstract;
    function ChairIsReadyToPlay(aChair: TpoChair): Boolean; virtual; abstract;
    function ChairIsWinnerCandidate(aChair: TpoChair): Boolean; virtual; abstract;

  public
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;
    procedure FixElementRefs; override;

  public
  //props
    property Chairs: TpoChairs read GetChairs;
    property Gamers: TpoGamers read GetGamers;
    property Hand: TpoHand read GetHand;
    property PokerType: TpoPokerType read FPokerType write SetPokerType;
    property PokerClass: TpoPokerTypeClass read GetPokerClass;
    property PokerTypeAsString: string read GetPokerTypeAsString;
    property StakeType: TpoStakeType read FStakeType write SetStakeType;
    property CurrencySymbol: string read FCurrencySymbol write SetCurrencySymbol;
    property MinGamersForStartHand: Integer read FMinGamersForStartHand write SetMinGamersForStartHand;

  //calculated
    property TournamentType: TpoTournamentType read FTournamentType write SetTournamentType;
  //events
    property OnAbandonHandStarting: TNotifyEvent read FOnAbandonHandStarting write
        SetOnAbandonHandStarting;
    property OnActivePlayer: TOnGamerOperation read FOnActivePlayer write
        SetOnActivePlayer;
    property OnChairStateChange: TNotifyEventEx read FOnChairStateChange write
        SetOnChairStateChange;
    property OnChatMessage: TOnMessageDispatch read FOnChatMessage write
        SetOnChatMessage;
    property OnDealCards: TNotifyEventEx read FOnDealCards write SetOnDealCards;
    property OnDontShowCards: TOnGamerOperation read FOnDontShowCards write
        SetOnDontShowCards;

    property OnGamerSitOut: TOnGamerOperation read FOnGamerSitOut write
        SetOnGamerSitOut;

    property OnGamerBack: TOnGamerOperation read FOnGamerBack write SetOnGamerBack;

    property OnHandFinish: TonPotOperation read FOnHandFinish write SetOnHandFinish;
    property OnPotReconcileFinish: TOnSidePotOperation read FOnPotReconcileFinish
        write SetOnPotReconcileFinish;

    property OnHandReconcileOperation: TOnHandReconcileOperation read
        FOnHandReconcileOperation write SetOnHandReconcileOperation;
    property OnHandStart: TNotifyEvent read FOnHandStart write SetOnHandStart;
    property OnHandStarted: TNotifyEventEx read FOnHandStarted write
        SetOnHandStarted;
    property OnHandStarting: TNotifyEventEx read FOnHandStarting write
        SetOnHandStarting;
    property OnLeaveTable: TOnGamerOperation read FOnLeaveTable write
        SetOnLeaveTable;
    property OnMoreChips: TOnGamerOperation read FOnMoreChips write SetOnMoreChips;
    property OnMoveBets: TonPotOperation read FOnMoveBets write SetOnMoveBets;
    property OnMuck: TOnGamerOperation read FOnMuck write SetOnMuck;
    property OnRoundFinish: TNotifyEvent read FOnRoundFinish write SetOnRoundFinish;
    property OnSetActivePlayer: TNotifyEvent read FOnSetActivePlayer write
        SetOnSetActivePlayer;
    property OnShowCards: TOnGamerOperation read FOnShowCards write SetOnShowCards;
    property OnSitOut: TOnGamerOperation read FOnSitOut write SetOnSitOut;
    property OnUpdateGamerDetails: TOnGamerOperation read FOnUpdateGamerDetails write SetOnUpdateGamerDetails;
    property OnProcCloseAction: TOnProcCloseAction read FOnProcCloseAction write SetOnProcCloseAction;
    property OnDumpCachedStateToFile: TOnDumpCachedStateToFile read FOnDumpCachedStateToFile write SetOnDumpCachedStateToFile;
    property OnGamerAction: TOnGamerAction read FOnGamerAction write SetOnGamerAction;
    property OnOpenRoundGamer: TOnChatMessage read FOnOpenRoundGamer write
        SetOnOpenRoundGamer;
    property OnGamerCloseProcess: TNotifyEventEx read FOnGamerCloseProcess write SetOnGamerCloseProcess;
    property OnGamerKickOff: TOnGamerMessage read FOnGamerKickOff write SetOnGamerKickOff;
    property OnGamerLeaveTable: TOnGamerLeaveTable read FOnGamerLeaveTable write SetOnGamerLeaveTable;
    property OnChangeGamersCount: TNotifyEvent read FOnChangeGamersCount write
        SetOnChangeGamersCount;

    property OnCheckGamerAllins: TOnCheckGamerAbility read FOnCheckGamerAllins write SetOnCheckGamerAllins;
    property OnPrepareReorderedPackets: TOnGamerOperation read FOnPrepareReorderedPackets write SetOnPrepareReorderedPackets;
    property OnMultyTournamentProcState: TOnMultyTournamentProcState read FOnMultyTournamentProcState write SetOnMultyTournamentProcState;

  //methods
    //gand/round
    function StartHand(nHandID: Integer): Boolean; virtual;
    //gamer related

    //stakes
    function GetAnteStakeValue: Integer; virtual;
    function GetBetStakeValue(aGamer: TpoGamer): Integer; virtual;
    function GetBigBlindStakeValue: Integer; virtual;
    function GetBringInStakeValue: Integer; virtual;
    function GetCallStakeValue(aGamer: TpoGamer): Integer; virtual;
    function GetMaxStakeValue(aGamer: TpoGamer): Integer; virtual;
    function GetPostDeadStakeValue: Integer; virtual;
    function GetCommonPostDeadStakeValue: Integer; virtual;
    function GetPostStakeValue: Integer; virtual;
    function GetRaiseStakeValue(aGamer: TpoGamer): Integer; virtual;
    function GetSmallBlindStakeValue: Integer; virtual;
    function GetStakeLimit(aGamer: TpoGamer; nStake: Integer = 0): Integer; virtual;

    //gamers management
    //returns true if hand is ready to start
    function HandleGamerProcInit(aGamer: TpoGamer): TpoGamer; virtual; abstract;
    function HandleGamerProcState(aGamer: TpoGamer): TpoGamer; virtual; abstract;

    function HandleGamerSitDown(aGamer: TpoGamer; nPosition: Integer; nAmount: Integer): Boolean; virtual; abstract;
    function HandleGamerLeaveTable(aGamer: TpoGamer): TpoGamer; virtual;  abstract;
    function HandleGamerSitOut(aGamer: TpoGamer): TpoGamer; virtual;  abstract;
    function HandleGamerSitOutNextHand(aGamer: TpoGamer; bStatus: Boolean): TpoGamer; virtual;  abstract;
    function HandleGamerBack(aGamer: TpoGamer): TpoGamer; virtual;  abstract;
    function HandleGamerWaitBB(aGamer: TpoGamer): TpoGamer; virtual;  abstract;

    //
    function HandleGamerCheck(aGamer: TpoGamer): TpoGamer; virtual;  abstract;
    function HandleGamerPostSB(aGamer: TpoGamer; nStake: Integer): TpoGamer; virtual; abstract;
    function HandleGamerPostBB(aGamer: TpoGamer; nStake: Integer): TpoGamer; virtual; abstract;
    function HandleGamerCall(aGamer: TpoGamer; nStake: Integer): TpoGamer; virtual; abstract;
    function HandleGamerRaise(aGamer: TpoGamer; nStake: Integer): TpoGamer; virtual; abstract;
    function HandleGamerBet(aGamer: TpoGamer; nStake: Integer): TpoGamer; virtual; abstract;
    function HandleGamerPost(aGamer: TpoGamer; nStake: Integer): TpoGamer; virtual; abstract;
    function HandleGamerPostDead(aGamer: TpoGamer; nPostStake, nDeadStake: Integer): TpoGamer; virtual; abstract;
    function HandleGamerFold(aGamer: TpoGamer; bAutoAction: Boolean = False): TpoGamer; virtual; abstract;
    function HandleGamerAnte(aGamer: TpoGamer; nStake: Integer): TpoGamer; virtual; abstract;
    function HandleGamerBringIn(aGamer: TpoGamer; nStake: Integer): TpoGamer; virtual; abstract;
    function HandleGamerAllIn(aGamer: TpoGamer): TpoGamer; virtual; abstract;

    //Showdown
    function HandleGamerShowCards(aGamer: TpoGamer): TpoGamer; virtual; abstract;
    function HandleGamerShowCardsShuffled(aGamer: TpoGamer): TpoGamer; virtual; abstract;
    function HandleGamerDontShowCards(aGamer: TpoGamer): TpoGamer; virtual; abstract;
    function HandleGamerMuck(aGamer: TpoGamer): TpoGamer; virtual; abstract;

    function HandleGamerActionExpired(aGamer: TpoGamer): Boolean; virtual; abstract;
    function HandleGamerUseTimeBank(aGamer: TpoGamer): Boolean; virtual; abstract;

    //autoactions
    function HandleGamerAutoAction(
      aGamer: TpoGamer; nAutoAction: TpoGamerAutoAction; nStake: Integer; bIsON: Boolean
    ): Boolean; virtual; abstract;

    //Bots
    function HandleBotsSitDown(
      aGamer: TpoGamer; nPosition: Integer; nAmount: Integer): Boolean; virtual; abstract;


    //gamer related
    function GetValidGamerActions(aGamer: TpoGamer): TpoGamerActions; virtual; abstract;

    //action timeout
    function HandleGamerActionTimeout(aGamer: TpoGamer): TpoGamer; virtual; abstract;

  //public for unit test
    function HandleStake(aGamer: TpoGamer; nStake: Integer; nDirectPotAmount: Integer = 0): Integer; virtual; abstract;
    procedure MoveRoundBetsToPot(); virtual; abstract;

  //misc
    function RankingIsApplicable(aGamer: TpoGamer): Boolean; virtual; abstract;
    function CalcGamerCombinations(aGamer: TpoGamer): Boolean; virtual; abstract;
    function GetGamerActionTimeout(aGamer: TpoGamer): Integer; virtual; abstract;
    procedure CorrectGamerTimebank(aGamer: TpoGamer; nExpiredTimeout: Integer); virtual;
    function NormalizeAmount(nStake: Integer): Currency;

    procedure ClearCardsModifiedState();

  //generic
    constructor Create(
      aTable: TpoTable; nPokerType: TpoPokerType = PT_TEXAS_HOLDEM;
      sCurrencySymbol: string = ''; nMinGamersForStartHand: Integer = 2
    ); reintroduce; virtual;

    destructor Destroy; override;
  end;//TpoGenericCroupier


  TpoSingleTableCroupier = class(TpoGenericCroupier)
  private
    function FindFirstPostOrPostDeadGamer: TpoGamer;
    function FindSmallBlindGamer: TpoGamer;
    function FindBigBlindCandidate: TpoGamer;
    function FindWinnerCandidateStepRightChairFromSet(
      nUserIDs: array of Integer): TpoChair;
    function AllPlayersHaveMadeActionsInRound: Boolean;
    procedure ClearAllGamersShowDownPassedAndFinishTournament;
    procedure CheckForBotsContinue;
    procedure ClearBigBlindIssues;
    procedure MandatoryAnteStakeOnStartHand;

  protected
    FRoundHasFinished: Boolean;
    FHandIsStartedFromIdle: Boolean;

  protected
  //rounds level service
    function NewRound(): Boolean;
    function FinishRound(): Boolean;
    procedure SetupGamersActions();
    function SelectServerGamerAction(aGamer: TpoGamer): TpoGamerAction; virtual;
    function SelectServerGamerAutoAction(aGamer: TpoGamer): TpoGamerAction; virtual;
    function InvokeGamerAction(aGamer: TpoGamer; nAction: TpoGamerAction; vParams: Array of Variant): Boolean; virtual;
    procedure ClearTurnLevelGamerAutoActions(aGamer: TpoGamer);

  //hand level
    function HandToBeContinued(): Boolean;
    function FinishHand(): Boolean; virtual;
    function GetNextHandStartingTimeout(): Integer;
    procedure DefineGamersAndDealerForCurrentHand(); virtual;
    procedure DefineNextStageInHand();

    function TableIsReadyForHand(): Boolean;
    function MaxBetLimitIsReached(aGamer: TpoGamer): Boolean;
    function TableHasAnte(): Boolean;
    function TableHasPreliminaryRound(): Boolean; virtual;

    //defines winer(s) and posts moneys from pots to their settlement accounts
    procedure DefineAndReconcileHandWinners();
    function MandatoryStakesSkipperMustBeBounced: Boolean; override;
    //rakes calculation
    procedure ChargeRakes(); override;
    function GetRakeRule: TpoRakeRule;
    function GetRakesValue(): Integer;
    function GetRakesLimit(): Integer;

    //returns incoming reminder for next site pot
    function CalcRakesRateForSitePot(
      nRakesCharged, nSitePotAmount, nIncomingReminder: Integer;
      var nSidePotRakeAmount: Integer;
      var bLimitIsReached: Boolean
    ): Integer;

    function GetRakesThreshold(): Integer;

  public
    procedure HandleLeftGamers(bSuppressNotification: Boolean = False); override;

  //stage switching
  public
    function StepRightChairsCount(): Integer; override;
    function AllChairsShowDownPassed: Boolean; override;
    function ReadyToPlayChairsCount(): Integer; override;
    function WinnerCandidatesCount(): Integer; override;

    function ChairCanTakeStepRight(aChair: TpoChair): Boolean; override;
    function ChairIsReadyToPlay(aChair: TpoChair): Boolean; override;
    function ChairIsWinnerCandidate(aChair: TpoChair): Boolean; override;
    // bots
    function InvokeBotAction(aGamer: TpoGamer;
      nAction: TpoGamerAction; Stake, Dead: Integer): Boolean; virtual;

  protected
    function SitOutCanTakeStepRight(): Boolean; override;
    function DefineFirstWinnerCandidate(): TpoGamer;
    function DefineOpenRoundGamer(): TpoGamer;
    function DefineActiveGamer(): TpoGamer;

    function FindStepRightChairLeftToPosition(
      nPositionID: Integer; bDontSkipSitouts: Boolean = False
    ): TpoChair;

    function FindStepRightOrPostChairLeftToPosition(
      nPositionID: Integer; bDontSkipSitouts: Boolean = False
    ): TpoChair;

    procedure TurnGamerCardsOver(aGamer: TpoGamer);
    procedure TurnCardsOfGamersOver();


  //accounting part
  protected
    function GetMoveBetsContext(nRoundID: Integer): String;
    function GetHandReconcileContext(): String;
    procedure CheckIfHandIsRunning(sAnchor: String);

  public
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;
    procedure FixElementRefs; override;

  public
  //props
  //events
  //methods
  //hand management
    function StartHand(nHandID: Integer): Boolean; override;

  //gamers management
    function HandleGamerProcInit(aGamer: TpoGamer): TpoGamer; override;
    function HandleGamerProcState(aGamer: TpoGamer): TpoGamer; override;

    function HandleGamerSitDown(
      aGamer: TpoGamer; nPosition: Integer; nAmount: Integer
    ): Boolean; override;

    function HandleGamerLeaveTable(aGamer: TpoGamer): TpoGamer; override;
    function HandleGamerSitOut(aGamer: TpoGamer): TpoGamer; override;
    function HandleGamerSitOutNextHand(aGamer: TpoGamer; bStatus: Boolean): TpoGamer; override;

    function HandleGamerBack(aGamer: TpoGamer): TpoGamer; override;
    function HandleGamerWaitBB(aGamer: TpoGamer): TpoGamer; override;

    //
    function HandleGamerCheck(aGamer: TpoGamer): TpoGamer; override;
    function HandleGamerPostSB(aGamer: TpoGamer; nStake: Integer): TpoGamer; override;
    function HandleGamerPostBB(aGamer: TpoGamer; nStake: Integer): TpoGamer; override;
    function HandleGamerCall(aGamer: TpoGamer; nStake: Integer): TpoGamer; override;
    function HandleGamerRaise(aGamer: TpoGamer; nStake: Integer): TpoGamer; override;
    function HandleGamerBet(aGamer: TpoGamer; nStake: Integer): TpoGamer; override;
    function HandleGamerPost(aGamer: TpoGamer; nStake: Integer): TpoGamer; override;
    function HandleGamerPostDead(aGamer: TpoGamer; nPostStake, nDeadStake: Integer): TpoGamer; override;
    function HandleGamerFold(aGamer: TpoGamer; bAutoAction: Boolean = False): TpoGamer; override;
    function HandleGamerAnte(aGamer: TpoGamer; nStake: Integer): TpoGamer; override;
    function HandleGamerBringIn(aGamer: TpoGamer; nStake: Integer): TpoGamer; override;
    function HandleGamerAllIn(aGamer: TpoGamer): TpoGamer; override;

    //Showdown
    function HandleGamerShowCards(aGamer: TpoGamer): TpoGamer; override;
    function HandleGamerShowCardsShuffled(aGamer: TpoGamer): TpoGamer; override;
    function HandleGamerDontShowCards(aGamer: TpoGamer): TpoGamer; override;
    function HandleGamerMuck(aGamer: TpoGamer): TpoGamer; override;
    //
    function HandleGamerUseTimeBank(aGamer: TpoGamer): Boolean; override;

    //autoactions
    function HandleGamerAutoAction(
      aGamer: TpoGamer; nAutoAction: TpoGamerAutoAction; nStake: Integer; bIsON: Boolean
    ): Boolean; override;

    //gamer related
    function GetValidGamerActions(aGamer: TpoGamer): TpoGamerActions; override;

    //action timeout
    function HandleGamerActionExpired(aGamer: TpoGamer): Boolean; override;

  //public for unit test
    function HandleStake(aGamer: TpoGamer; nStake: Integer; nDirectPotAmount: Integer = 0): Integer; override;
    procedure MoveRoundBetsToPot(); override;

  //misc
    function RankingIsApplicable(aGamer: TpoGamer): Boolean; override;
    function CalcGamerCombinations(aGamer: TpoGamer): Boolean; override;
    function GetGamerActionTimeout(aGamer: TpoGamer): Integer; override;

  //generic
    constructor Create(
      aTable: TpoTable; nPokerType: TpoPokerType = PT_TEXAS_HOLDEM;
      sCurrencySymbol: string = ''; nMinGamersForStartHand: Integer = 2
    ); override;
  end;//TpoSingleTableCroupier



////////////////////////////////////////////////////////////////////////////////
// Tournament croupiers
////////////////////////////////////////////////////////////////////////////////
  TpoTournamentStatus = (
    TST_IDLE, TST_STARTING, TST_RUNNING, TST_FINISHED
  );

  TpoGenericTournamentCroupier = class(TpoSingleTableCroupier)
  private
    FOnTournamentHandFinish: TNotifyEventEx;
    FOnTournamentStart: TNotifyEvent;
    FOnTournamentFinish: TNotifyEvent;
    FOnTournamentFinishForBots: TNotifyEvent;
    FTournamentFee: Integer;
    FTournamentBuyIn: Integer;
    FTournamentUseBasePrizes: Boolean;
    FTournamentUseBonusPrizes: Boolean;
    FTournamentBonusFirstPlace: Currency;
    FTournamentBonusThirdPlace: Currency;
    FTournamentBonusSecondPlace: Currency;
    FTournamentBaseFirstPlace: Currency;
    FTournamentBaseSecondPlace: Currency;
    FTournamentBaseThirdPlace: Currency;
    FTournamentBasePaymentType: TpoTournamentPaymentType;
    FTournamentBonusPaymentType: TpoTournamentPaymentType;
    procedure SetOnTournamentHandFinish(const Value: TNotifyEventEx);
    procedure DealCardsForTournamentDealerRound();
    function GetTournamentStatusAsString: String;
    procedure SetOnTournamentFinish(const Value: TNotifyEvent);
    procedure SetOnTournamentStart(const Value: TNotifyEvent);
    procedure SetTournamentFee(const Value: Integer);
    procedure SetTournamentBuyIn(const Value: Integer);
    procedure SetOnTournamentFinishForBots(const Value: TNotifyEvent);

  protected
    function SelectServerGamerAction(aGamer: TpoGamer): TpoGamerAction; override;
    function MandatoryStakesSkipperMustBeBounced: Boolean; override;

  protected
    function SitOutCanTakeStepRight(): Boolean; override;
    function DefineDealerForTournament(): Boolean;
    procedure DefineGamersAndDealerForCurrentHand(); override;
    function TableHasPreliminaryRound(): Boolean; override;

  public
  //state
    FTournamentStatus: TpoTournamentStatus;
    FPlayedHandsInTournament: Integer;
    FTournamentSeqID: String;
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;

  protected
    procedure StartTournament(); virtual; abstract;
    procedure FinishTournament(); virtual; abstract;
    procedure ChargeRakes(); override;
    procedure TakeAllInsOffTournament();

  public
  //porops
    property PlayedHandsInTournament: Integer read FPlayedHandsInTournament;
    property TournamentStatus: TpoTournamentStatus read FTournamentStatus;
    property TournamentStatusAsString: String read GetTournamentStatusAsString;
    property TournamentBuyIn: Integer read FTournamentBuyIn write SetTournamentBuyIn;
    property TournamentFee: Integer read FTournamentFee write SetTournamentFee;
    property TournamentSeqID: String read FTournamentSeqID write FTournamentSeqID;
    // Quick Search BS
    property TournamentUseBasePrizes: Boolean read FTournamentUseBasePrizes write FTournamentUseBasePrizes;
    property TournamentBasePaymentType: TpoTournamentPaymentType read FTournamentBasePaymentType write FTournamentBasePaymentType;
    property TournamentBaseFirstPlace: Currency read FTournamentBaseFirstPlace write FTournamentBaseFirstPlace;
    property TournamentBaseSecondPlace: Currency read FTournamentBaseSecondPlace write FTournamentBaseSecondPlace;
    property TournamentBaseThirdPlace: Currency read FTournamentBaseThirdPlace write FTournamentBaseThirdPlace;
    //
    property TournamentUseBonusPrizes: Boolean read FTournamentUseBonusPrizes write FTournamentUseBonusPrizes;
    property TournamentBonusPaymentType: TpoTournamentPaymentType read FTournamentBonusPaymentType write FTournamentBonusPaymentType;
    property TournamentBonusFirstPlace: Currency read FTournamentBonusFirstPlace write FTournamentBonusFirstPlace;
    property TournamentBonusSecondPlace: Currency read FTournamentBonusSecondPlace write FTournamentBonusSecondPlace;
    property TournamentBonusThirdPlace: Currency read FTournamentBonusThirdPlace write FTournamentBonusThirdPlace;

  //events
    property OnTournamentHandFinish: TNotifyEventEx read FOnTournamentHandFinish write SetOnTournamentHandFinish;
    property OnTournamentStart: TNotifyEvent read FOnTournamentStart write SetOnTournamentStart;
    property OnTournamentFinish: TNotifyEvent read FOnTournamentFinish write SetOnTournamentFinish;
    property OnTournamentFinishForBots: TNotifyEvent read FOnTournamentFinishForBots write SetOnTournamentFinishForBots;

  //tournament actions
    function HandleTournamentInit(aParticipants: Variant; sReason: String): boolean; virtual; abstract;
    function HandleTournamentPlay(nHandID: Integer; aParticipants: Variant; sReason: String): boolean; virtual; abstract;

    function HandleTournamentResume(
      nHandID: Integer; sReason: String;
      nPlrsCnt: Integer;
      vLostPlayers: Array of Variant
    ): boolean; virtual; abstract;

    function HandleTournamentStandUp(
      sReason: String; nPlrsCnt: Integer; bSetAsWatcher: Boolean;
      vLostPlayers: Variant
    ): boolean; virtual; abstract;

    function HandleTournamentKickOff(
      sReason: String; nPlrsCnt: Integer;
      vLostPlayers: Variant
    ): boolean; virtual; abstract;

    function HandleTournamentSitDown(
      sReason: String; nPlrsCnt: Integer;
      vNewPlayers: Variant
    ): boolean; virtual; abstract;

    function HandleTournamentRebuy(
      sReason: String; nPlrsCnt: Integer;
      vPlayers: Variant
    ): boolean; virtual; abstract;

    function HandleTournamentBreak(sReason: String): boolean; virtual; abstract;
    function HandleTournamentEnd(sReason: String): boolean; virtual; abstract;
    function HandleTournamentFree(sReason: String): boolean; virtual; abstract;

  //methods
    function ArrangeTournamentParticipants(
      aParticipants: Variant; nInitialGamerState: TpoGamerState;
      sTakeOffReason: String
    ): Boolean; virtual; abstract;

    function StartHand(nHandID: Integer): Boolean; override;
    //gamer related
    function GetValidGamerActions(aGamer: TpoGamer): TpoGamerActions; override;

  //user actions
    function HandleGamerProcInit(aGamer: TpoGamer): TpoGamer; override;
    function HandleGamerProcState(aGamer: TpoGamer): TpoGamer; override;

    function HandleGamerBack(aGamer: TpoGamer): TpoGamer; override;
    function HandleGamerLeaveTable(aGamer: TpoGamer): TpoGAmer; override;
    function HandleGamerSitOut(aGamer: TpoGamer): TpoGamer; override;

    function HandleGamerUseTimeBank(aGamer: TpoGamer): Boolean; override;

  //utility
    function GetGamerActionTimeout(aGamer: TpoGamer): Integer; override;
    function HandleStake(aGamer: TpoGamer; nStake: Integer; nDirectPotAmount: Integer = 0): Integer; override;

  //generic
    constructor Create(
      aTable: TpoTable; nPokerType: TpoPokerType = PT_TEXAS_HOLDEM;
      sCurrencySymbol: string = ''; nMinGamersForStartHand: Integer = 2
    ); override;
  end;//TpoGenericTournamentCroupier

  TpoSingleTableTournamentCroupier = class(TpoGenericTournamentCroupier)
  private
    procedure ClearGamersTournamentFlags;
  protected
    function FinishHand: Boolean; override;
    procedure CorrectBettingLevelsIfProper();
    function GetActiveTournamentParticipantsCount(): Integer;

  public
    function DefineAndReconcileTournamentWinners(): Boolean;

  public
  //state
    function Load(aReader: TReader): Boolean; override;
    function Store(aWriter: TWriter): Boolean; override;

  protected
    procedure StartTournament(); override;
    procedure FinishTournament(); override;

  public
  //props
  //gamer actions
    function HandleGamerLeaveTable(aGamer: TpoGamer): TpoGamer; override;
    function HandleGamerSitDown(
      aGamer: TpoGamer; nPosition: Integer; nAmount: Integer
    ): Boolean; override;

  //tournament actions
    function HandleTournamentInit(aParticipants: Variant; sReason: String): boolean; override;
    function HandleTournamentPlay(nHandID: Integer; aParticipants: Variant; sReason: String): boolean; override;

    function HandleTournamentResume(
      nHandID: Integer; sReason: String;
      nPlrsCnt: Integer;
      vLostPlayers: Array of Variant
    ): boolean; override;

    function HandleTournamentStandUp(
      sReason: String; nPlrsCnt: Integer; bSetAsWatcher: Boolean;
      vLostPlayers: Variant
    ): boolean; override;

    function HandleTournamentKickOff(
      sReason: String; nPlrsCnt: Integer;
      vLostPlayers: Variant
    ): boolean; override;

    function HandleTournamentSitDown(
      sReason: String; nPlrsCnt: Integer; 
      vNewPlayers: Variant
    ): boolean; override;

    function HandleTournamentRebuy(
      sReason: String; nPlrsCnt: Integer;
      vPlayers: Variant
    ): boolean; override;

    function HandleTournamentBreak(sReason: String): boolean; override;
    function HandleTournamentEnd(sReason: String): boolean; override;
    function HandleTournamentFree(sReason: String): boolean; override;
  //
    function StartHand(nHandID: Integer): Boolean; override;
    function GetTournamentLevel(): Integer;
    function GetHandInsideLevel(): Integer;

  //generic
    constructor Create(
      aTable: TpoTable; nPokerType: TpoPokerType = PT_TEXAS_HOLDEM;
      sCurrencySymbol: string = ''; nMinGamersForStartHand: Integer = 2
    ); override;
  end;//TpoSingleTableTournamentCroupier


  TpoMultiTableTournamentCroupier = class(TpoGenericTournamentCroupier)
  public
  //generic
    constructor Create(
      aTable: TpoTable; nPokerType: TpoPokerType = PT_TEXAS_HOLDEM;
      sCurrencySymbol: string = ''; nMinGamersForStartHand: Integer = 2
    ); override;

  protected
    function FinishHand: Boolean; override;
    procedure TakeAllInsOffMultyTournament;
  public
  //gamer actions
    function HandleGamerSitOut(aGamer: TpoGamer): TpoGamer; override;

  //multi table tournament
    function HandleTournamentBreak(sReason: String): boolean; override;
    function HandleTournamentEnd(sReason: String): boolean; override;
    function HandleTournamentFree(sReason: String): boolean; override;
    function HandleTournamentInit(
      aParticipants: Variant; sReason: String
    ): boolean; override;

    function HandleTournamentPlay(
      nHandID: Integer; aParticipants: Variant; sReason: String
    ): boolean; override;

    function HandleTournamentResume(
      nHandID: Integer; sReason: String;
      nPlrsCnt: Integer;
      vLostPlayers: Array of Variant
    ): boolean; override;

    function HandleTournamentStandUp(
      sReason: String; nPlrsCnt: Integer; bSetAsWatcher: Boolean;
      vLostPlayers: Variant
    ): boolean; override;

    function HandleTournamentKickOff(
      sReason: String; nPlrsCnt: Integer;
      vLostPlayers: Variant
    ): boolean; override;

    function HandleTournamentSitDown(
      sReason: String; nPlrsCnt: Integer;
      vNewPlayers: Variant
    ): boolean; override;

    function HandleTournamentRebuy(
      sReason: String; nPlrsCnt: Integer;
      vPlayers: Variant
    ): boolean; override;

    function ArrangeTournamentParticipants(
      aParticipants: Variant;
      nInitialGamerState: TpoGamerState;
      sTakeOffReason: String
    ): Boolean; override;

  end;//TpoMultiTableTournamentCroupier


////////////////////////////////////////////////////////////////////////////////
// TpoCroupierFactory
////////////////////////////////////////////////////////////////////////////////
  TpoCroupierFactory = class
  public
    class function GetCroupierClass(nTournamentType: TpoTournamentType): TpoGenericCroupierClass;
  end;//TpoCroupierFactory


////////////////////////////////////////////////////////////////////////////////
// TpoBotChatPostCategory
////////////////////////////////////////////////////////////////////////////////
  TpoBotChatPostCategory = (
    BCP_JOIN_TABLE,
    BCP_SIT_DOWN,
    BCP_FOLDS,
    BCP_GOES_ALL_IN,
    BCP_SIT_OUT,
    BCP_LEAVE_TABLE
  );

//tools
  function  GetRandomBot(aTable: TpoTable): TpoGamer;
  function  GetRandomPostOnCategory(aCategory: TpoBotChatPostCategory; var aPost: String): Boolean;
  function  GetRandomAnswerByKeyWords(aKeyWords: String; var aPost: String): Boolean;

//posters
  procedure PostRandomAnswerOnCategory(aSource: TpoGamer; aCategory: TpoBotChatPostCategory);
  procedure PostRandomAnswerOnKeywords(aSource: TpoGamer; aMessage: String);




const
  COMBINATION_CARDS_COUNT  = 5;


////////////////////////////////////////////////////////////////////////////////
// Global data and flags:
////////////////////////////////////////////////////////////////////////////////
const
  UNDEFINED_SESSION_ID    =  0;
  SHARED_HISTORY_SESSION_ID = -1;
  UNDEFINED_USER_ID       =  0;
  UNDEFINED_POSITION_ID   = -1;
  UNDEFINED_HAND_ID       =  0;
  UNDEFINED_ROUND_ID      = -1;//first round has ID=1 so that is right

const
  USER_ACCOUNT_TYPE       = AT_DEBIT;
  CASINO_ACCOUNT_TYPE     = AT_CREDIT;

  USER_POT_ACCOUNT_TYPE   = AT_DEBIT;
  CASINO_POT_ACCOUNT_TYPE = AT_CREDIT;
  POT_ACCOUNT_TYPE        = AT_DEBIT;


//account prefixes
const
//outside accounts
  ACC_USER_PREFIX       = '#USER';
  ACC_CASINO_PREFIX     = '#CASINO';

//balanced accounts
  ACC_USER_POT_PREFIX   = '#USER_POT';
  ACC_CASINO_POT_PREFIX = '#CASINO_POT';
  ACC_POT_PREFIX        = '#POT';

//Default transaction contexts
const
  TC_RAKE_DEFAULT       = 'Pot Rake';
  TC_GAME_DEFAULT       = 'Game blind';
  TC_SETTLEMENT_DEFAULT = 'Clear settle accounts';


const
  CpoWatcherActions = [GA_LEAVE_TABLE];

const
  SHOW_DOWN_ACTIONS = [
    GA_SHOW_CARDS,
    GA_SHOW_CARDS_SHUFFLED,
    GA_MUCK,
    GA_DONT_SHOW
  ];

////////////////////////////////////////////////////////////////////////////////
// Autoactions
////////////////////////////////////////////////////////////////////////////////
const
  TURN_LEVEL_AUTO_ACTIONS = [
    GAA_AUTO_FOLD,
    GAA_AUTO_CHECK,
    GAA_CHECK_OR_FOLD,
    GAA_CHECK_OR_CALL,
    GAA_AUTO_BET,
    GAA_AUTO_RAISE,
    GAA_AUTO_CALL,
    GAA_BET_OR_RAISE
  ];

  PERSISTENT_AUTO_ACTIONS = [
    GAA_POST_BLINDS,
    GAA_POST_ANTE,
    GAA_MUCK_LOSING_HANDS,
    GAA_SITOUT_NEXT_HAND,
    GAA_AUTO_WAIT_BB
  ];

var
  nPokerTypeTostringMap: Array[TpoPokerType] of String = (
    'undefined        ',//PT_UNDEFINED,       //0 - undefined
    'Hold''em',//PT_TEXAS_HOLDEM,    //1 - Texas Hold'em
    'Omaha',//PT_OMAHA,           //2 – Omaha
    'Omaha Hi/Lo',//PT_OMAHA_HILO,     //3 - Omaha Hi Lo
    '7 Stud',//PT_SEVEN_STUD,      //4 - Seven Stud
    '7 Stud Hi/Lo',//PT_SEVEN_STUD_HILO, //5 - Seven Stud Hi Lo
    'Five Card Draw   ',//PT_FIVE_CARD_DRAW,  //6 - Five Card Draw
    'Five Card Stud   ',//PT_FIVE_CARD_STUD,  //7 - Five Card Stud
    'Crazy Pineapple  ' //PT_CRAZY_PINEAPPLE  //8 - Crazy Pineapple
  );


implementation

uses
  ActiveX, ComObj
//PO
  , uCommonDataModule
  , uLogger
  , uCombinationProcessor, DateUtils, StrUtils, StdConvs;

const
  LF = #$D#$A;

var
  nAccountStateToStringMap: Array [TpoAccountState] of String = (
    'AS_ACTIVE',
    'AS_FOLDED',
    'AS_ALL_IN'
  );


function GetRandomAnswerByKeyWords(
  aKeyWords: String; var aPost: String): Boolean;
begin
  Result:= CommonDataModule.ObjectPool.GetBotChatPostCache.GetRandomPostByKeyWords(aKeyWords, aPost);
end;

function GetRandomBot(aTable: TpoTable): TpoGamer;
var
  nIndx: Integer;
  aBotsList: TObjectList;
begin
  Result:= nil;
  aBotsList:= TObjectList.Create(False);

  //generate list of bots
  for nIndx:= 0 to (aTable.Gamers.Count-1) do
    if (aTable.Gamers[nIndx].IsBot) then aBotsList.Add(aTable.Gamers[nIndx]);

  //select one of them
  if (aBotsList.Count > 0) then
    Result:= TpoGamer(aBotsList[Random(aBotsList.Count)]);

  aBotsList.Free;    
end;

function GetRandomPostOnCategory(
  aCategory: TpoBotChatPostCategory; var aPost: String): Boolean;
begin
  Result:= CommonDataModule.ObjectPool.GetBotChatPostCache.GetRandomPostByActionType(Integer(aCategory)+1, aPost);
end;

procedure PostRandomAnswerOnCategory(aSource: TpoGamer;
  aCategory: TpoBotChatPostCategory);
var
  gBot: TpoGamer;
  sMsg: String;
begin
//check if post possible
  if (not Assigned(aSource)) then Exit;
  if (aSource.IsBot) then Exit;

//check if there any avaliable bot
  gBot:= GetRandomBot(aSource.FGamers.FTable);
  if not Assigned(gBot) then Exit;

//check if there any avaliable message
  sMsg:= '';
  if (GetRandomPostOnCategory(aCategory, sMsg)) then
    if Assigned(aSource.FGamers.FTable.FCroupier.OnChatMessage) then 
      aSource.FGamers.FTable.FCroupier.OnChatMessage(sMsg, gBot.UserName, gBot, MO_GAMERS);

//free
  sMsg:= '';
end;

procedure PostRandomAnswerOnKeywords(aSource: TpoGamer;
  aMessage: String);
const
  //escaped symbols
  ESC_SPACE         = '%20';
  ESC_PERCENT       = '%25';
  ESC_APOSTROPHE    = '%27';
  ESC_APOSTROPHE_2  = '%60';
  ESC_EXCL_MARK     = '%21';
  ESC_QUEST_MARK    = '%3F';
  ESC_COMMA         = '%2C';
  ESC_DOT           = '%2E';

  //analog symbols
  NRM_SPACE         = ' ';
  NRM_PERCENT       = '%';
  NRM_APOSTROPHE    = '''';
  NRM_APOSTROPHE_2  = '`';
  NMR_EXCL_MARK     = '!';
  NRM_QUEST_MARK    = '?';
  NMR_COMMA         = ',';
  NMR_DOT           = '.';

var
  gBot: TpoGamer;
  sMsg: String;

  procedure FindReplace(var Str: String; SpecStr: String; RepStr: String);
  var
    nPos,
    nLen: Integer;
  begin
    nPos:= Pos(SpecStr, Str);
    nLen:= Length(SpecStr);
    while (nPos > 0) do begin
      Delete(Str, nPos, nLen);
      Insert(RepStr, Str, nPos);
      nPos:= Pos(SpecStr, Str);
    end;//while
  end;//procedure

  function RemoveEscapedSymbuls(sStr: String): String;
  begin
    FindReplace(sStr, ESC_SPACE,        NRM_SPACE);
    FindReplace(sStr, ESC_PERCENT,      NRM_PERCENT);
    FindReplace(sStr, ESC_APOSTROPHE,   NRM_APOSTROPHE);
    FindReplace(sStr, ESC_APOSTROPHE_2, NRM_APOSTROPHE_2);
    FindReplace(sStr, ESC_EXCL_MARK,    NMR_EXCL_MARK);
    FindReplace(sStr, ESC_QUEST_MARK,   NRM_QUEST_MARK);
    FindReplace(sStr, ESC_COMMA,        NMR_COMMA);
    FindReplace(sStr, ESC_DOT,          NMR_DOT);
    Result:= sStr;
  end;//fuction

begin
  if (aSource.IsBot) then Exit;

//check if there any avaliable bot
  gBot:= GetRandomBot(aSource.FGamers.FTable);
  if not Assigned(gBot) then Exit;

//check if there any avaliable message
  sMsg:= '';
  if (GetRandomAnswerByKeyWords(RemoveEscapedSymbuls(aMessage), sMsg)) then
    aSource.FGamers.FTable.FCroupier.OnChatMessage(sMsg, gBot.UserName, gBot, MO_GAMERS);
//free
  sMsg:= '';
end;




function PlaceToStr(nPlace: Integer): string;
begin
  case nPlace of
    1: Result:=  '1st';
    2: Result:=  '2nd';
    3: Result:=  '3d';
    4: Result:=  '4th';
    5: Result:=  '5th';
    6: Result:=  '6th';
    7: Result:=  '7th';
    8: Result:=  '8th';
    9: Result:=  '9th';
    10: Result:= '10th';
  end;//case
end;//

{ TpoEntity }

constructor TpoEntity.Create;
begin
  inherited Create();
end;//TpoEntity.Create

destructor TpoEntity.Destroy;
begin
  inherited;
end;

function TpoEntity.Dump: String;
begin
  Result:= '';
end;

function TpoEntity.Load(aReader: TReader): Boolean;
begin
  Result:= True;
  FLoadedVersion:= aReader.ReadInteger();
end;

function TpoEntity.Serialize(aFiler: TFiler): Boolean;
begin
  if aFiler is TReader then Result:= Load(aFiler as TReader)
  else Result:= Store(aFiler as TWriter);
end;

procedure TpoEntity.SetVersion(const Value: Integer);
begin
  FVersion := Value;
end;

function TpoEntity.Store(aWriter: TWriter): Boolean;
begin
  Result:= True;
  aWriter.WriteInteger(Version);
end;


{ TpoStake }

procedure TpoStake.SetAmount(Value: Integer);
begin
  FAmount := Value;
end;

procedure TpoStake.SetNote(const Value: String);
begin
  FNote := Value;
end;

procedure TpoStake.SetPerformedAt(const Value: TDateTime);
begin
  FPerformedAt := Value;
end;

procedure TpoStake.SetUserID(Value: Integer);
begin
  FUserID := Value;
end;

procedure TpoStake.SetStakeKind(const Value: TpoStakeKind);
begin
  FStakeKind := Value;
end;

procedure TpoStake.SetStakeType(const Value: TpoStakeType);
begin
  FStakeType := Value;
end;

function TpoStake.Load(aReader: TReader): Boolean;
begin
  Result:= inherited Load(aReader);
  FAmount:= aReader.ReadInteger;
  FUserID:= aReader.ReadInteger;
  FPerformedAt:= aReader.ReadDate;
  FNote:= aReader.ReadString;
  FStakeType:= TpoStakeType(aReader.ReadInteger);
  FStakeKind:= TpoStakeKind(aReader.ReadInteger);
end;

function TpoStake.Store(aWriter: TWriter): Boolean;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteInteger(FAmount         );
  aWriter.WriteInteger(FUserID         );
  aWriter.WriteDate   (FPerformedAt    );
  aWriter.WriteString (FNote           );
  aWriter.WriteInteger(Integer(FStakeType ));
  aWriter.WriteInteger(Integer(FStakeKind));
end;

{ TpoGamer }

constructor TpoGamer.Create(aGamers: TpoGamers);
begin
  inherited Create;
  FAttributes:= TStringList.Create;
  FAccount:= TpoUserAccount.Create(
    ACC_USER_PREFIX,
    USER_ACCOUNT_TYPE,
    AC_DEFAULT
  );

  FUserID:= UNDEFINED_USER_ID;
  FChairID:= UNDEFINED_POSITION_ID;
  FGamers:= aGamers;
  FCards:= TpoCardCollection.Create(FGamers.FTable.Cards);
  FLastActionInRound:= GA_NONE;
  FSheduledToLeaveTable := False;
  FKickOffFromTournament := False;

  FTournamentTimebank:= GT_GAMER_TOURNAMENT_TIMEBANK;
  FCombinations:= TpoCombinations.Create(FGamers.FTable.Cards);

  FShowDownPassed := False;
  FChatAllow := True;
  FAffiliateID := 1;
  FIsEmailValidated := False;
  FLevelID := 0;

  FIcons := TStringList.Create;
  FCountOfRases := 0;

  FHandIDWhenLeft := 0;
  FLastTimeActivity := Now;
  FIsUpdated := False;
  FUserName := '';

  FTournamentPrizePercentage := 0;
  FTournamentPrizeBonus := 0;

  FIsTakedSit := False;
  FIsBot := False;
  FBotCharacter := UCH_NORMAL;
  FBotBlaffersEvent := MIN_COUNT_ONBLAFFERS + Random(MAX_COUNT_ONBLAFFERS - MIN_COUNT_ONBLAFFERS);
  FBotID := 0;

  Version:= 10;
end;//TpoGamer.Create


destructor TpoGamer.Destroy;
var
  I: Integer;
begin
  if FCombinations <> nil then begin
    for I:= 0 to FCombinations.Count-1 do begin
      if FCombinations[I] <> nil then
      FCombinations[I].Free;
    end;//for
    FCombinations.Free;
  end;//if
  FCards.Free;
  FAccount.Free;
  FAttributes.Free;

  FIcons.Clear;
  FIcons.Free;

  inherited;
end;

function TpoGamer.GetAttribute(Index: String): String;
begin
  Result:= FAttributes.Values[Index];
end;

function TpoGamer.GetIsDealer: Boolean;
begin
  Result:= FGamers.Dealer = Self;
end;

function TpoGamer.GetIsReadyForHand: Boolean;
begin
  Result:= (NOT IsWatcher) AND (IsAtTheTable);// AND (NOT PassNextHand);
end;

function TpoGamer.GetIsWatcher: Boolean;
begin
  Result:= (UserID = UNDEFINED_USER_ID) OR (ChairID = UNDEFINED_POSITION_ID);
end;

var
  nStateToStringMap: Array[TpoGamerState] of String  = (
  //base
    'playing',      //  GS_IDLE,
    'sitout',       //  CS_SITOUT,
    'disconnected', //  CS_DISCONNECTED,
    'left',         //  GS_LEFT_TABLE

  //surrogate
    'playing',      //  GS_PLAYING,
    'playing',      //  CS_ALL_IN,
    'playing',      //  GS_FOLD,
    'playing',      //  GS_MUCK,
    'playing',       //  CS_PASS
  //
    'none'
  );

var
  nNativeStateToStringMap: Array[TpoGamerState] of String  = (
  //out of hand
    'GS_IDLE',
    'GS_SITOUT',
    'GS_DISCONNECTED',
    'GS_LEFT_TABLE',

  //in hand
    'GS_PLAYING',
    'GS_ALL_IN',
    'GS_FOLD',
    'GS_MUCK',
    'GS_PASS', //<reserved>
    'GS_NONE'
  );

function TpoGamer.GetStateAsString: String;
begin
  if IsSitOut then Result := 'sitout'
  else Result:= nstateToStringMap[State];
end;

function TpoGamer.GetIsAtTheTable: Boolean;
begin
  Result:= (FChairID <> UNDEFINED_POSITION_ID) AND
  (State IN [GS_IDLE, GS_ALL_IN, GS_PLAYING, GS_FOLD, GS_MUCK]);
end;

function TpoGamer.Load(aReader: TReader): Boolean;
var
  I, nCnt: Integer;
begin
  Result:= inherited Load(aReader);
  FSessionID  := aReader.ReadInteger();
  FState      := TpoGamerState(aReader.ReadInteger);
  FAttributes.Text := aReader.ReadString;
  FUserID     := aReader.ReadInteger;
  FUserName   := aReader.ReadString;
  FSexID      := aReader.ReadInteger;
  FCity       := aReader.ReadString;
  FChairID    := aReader.ReadInteger;
  FPassCurrentHand:= aReader.ReadBoolean;
  FWaitForBigBlind:= aReader.ReadBoolean;
  FPassNextHand:= aReader.ReadBoolean;
// by BS
  FShowDownPassed   := aReader.ReadBoolean;
  FChatAllow        := aReader.ReadBoolean;
  FAffiliateID      := aReader.ReadInteger;
  FIsEmailValidated := aReader.ReadBoolean;
  FLevelID          := aReader.ReadInteger;
  FCountOfRases     := aReader.ReadInteger;

  FIcons.Clear;
  nCnt := aReader.ReadInteger;
  for I:=0 to nCnt - 1 do FIcons.Add(aReader.ReadString);
//
  FFinishedHands:= aReader.ReadInteger;
  FInitialBalance:= aReader.ReadInteger;
  FLastActionInRound:= TpoGamerAction(aReader.ReadInteger);
  FCombinations.Load(aReader);
  FShowCardsAtShowdown:= aReader.ReadBoolean;
  FDuringGameAddedMoney:= aReader.ReadInteger;
  FPrevChairID:= aReader.ReadInteger;
  FSkippedHands:= aReader.ReadInteger;
  FMustSetBigBlind:= aReader.ReadBoolean;
  FMustSetPost:= aReader.ReadBoolean;
  FMustSetPostDead:= aReader.ReadBoolean;

  aReader.Read(FWinnerNominations, SizeOf(FWinnerNominations));
  FAllInOrder:= aReader.ReadInteger;
  FAvatarID:= aReader.ReadInteger;
  FImageVersion := aReader.ReadInteger;
  FIsSitOut:= aReader.ReadBoolean;
  FTournamentPlace:= aReader.ReadInteger;
  FAllInRejectionHandID:= aReader.ReadInteger;
  FTournamentPrizePercentage:= aReader.ReadCurrency;
  FTournamentPrizeBonus:= aReader.ReadCurrency;

  //tournament addon
  FTournamentTimebank:= aReader.ReadInteger;
  FBalanceBeforeLastHand:= aReader.ReadInteger;

  //autobounce
  FSkippedRequiredStakes:= aReader.ReadInteger;
  aReader.Read(FAutoActions, SizeOf(FAutoActions));
  FAutoActionStake := aReader.ReadInteger;

  FAccount.Load(aReader);
  FCards.Load(aReader);

  if FLoadedVersion >= 1  then begin
    FTurnedCardsOver:= aReader.ReadBoolean;
  end;//if

  if FLoadedVersion >= 2  then begin
    FSheduledToLeaveTable:= aReader.ReadBoolean;
  end;//if

  if FLoadedVersion >= 3  then begin
    FDisconnected:= aReader.ReadBoolean;
  end;//if

  if FLoadedVersion >= 4  then begin
    FSkippedSBStake:= aReader.ReadBoolean;
    FSkippedBBStake:= aReader.ReadBoolean;
  end;//if

  if FLoadedVersion >= 5  then begin
    FSessionHost:= aReader.Readstring;
  end;//if

  if FLoadedVersion >= 6  then begin
    FKickOffFromTournament:= aReader.ReadBoolean;
    FFinishedTournament:= aReader.ReadBoolean;
    FFinishedTournamentTime:= aReader.ReadDate;
  end;//if

  if FLoadedVersion >= 7  then begin
    FRegularTimeoutActivated:= aReader.ReadBoolean;
    FActivateTimeBank       := aReader.ReadBoolean;
    FTimeBankActivated      := aReader.ReadBoolean;
  end;//if

  if FLoadedVersion >= 8  then begin
    FRegularTimeoutExpired:= aReader.ReadBoolean;
  end;//if

  if FLoadedVersion >= 9  then begin
    FIP:= aReader.Readstring;
  end;//if

  if FLoadedVersion >= 10  then begin
    FLastSkippedHandID:= aReader.ReadInteger;
  end;//if

  FHandIDWhenLeft := aReader.ReadInteger;
  FLastTimeActivity := aReader.ReadDate;

  FIsTakedSit := aReader.ReadBoolean;
  FIsBot := aReader.ReadBoolean;
  FBotCharacter := TFixUserCharacter(aReader.ReadInteger);
  FBotBlaffersEvent := aReader.ReadInteger;
  FBotID := aReader.ReadInteger;
end;//TpoGamer.Load


procedure TpoGamer.OnNewHandNotify(aHand: TpoHand);
begin
  FCards.Clear;
  FRegularTimeoutActivated:= False;
  FCombinations.ClearAndFree;

  FTurnedCardsOver:= False;
  if IsPlaying then FSkippedHands:= 0
  else
  if IsAtTheTable then Inc(FSkippedHands);
  FAllInOrder:= -1;
  FWinnerNominations:= [];

  FBalanceBeforeLastHand:= Account.Balance;
end;

procedure TpoGamer.SetAttribute(Index: String; const Value: String);
begin
  FAttributes.Values[Index]:= Value;
end;

procedure TpoGamer.SetCity(const Value: String);
begin
  FCity := Value;
end;

procedure TpoGamer.SetSessionID(const Value: LongInt);
begin
  FSessionID := Value;
end;

procedure TpoGamer.SetSexID(const Value: Integer);
begin
  FSexID := Value;
end;

procedure TpoGamer.SetState(const Value: TpoGamerState);
var
  sLog: string;
  aChair: TpoChair;
begin
  FState := Value;
  if Value = GS_SITOUT then
    IsSitOut:= True
  else
    if (Value IN [GS_IDLE, GS_PLAYING]) AND IsSitOut then FState := GS_SITOUT;

  if (Value = GS_LEFT_TABLE) then begin
    aChair := Chair;
    if aChair <> nil then begin
      aChair.FDrinksName := '';
      aChair.FDrinksID   := -1;
    end;
  end;

  sLog :=
    'UserID=' + IntToStr(FUserID) + ', SessionID=' + IntToStr(FSessionID) +
    ', State=' + StateAsString + ', IsSitOut=' + IfThen(IsSitOut, '"True"', '"False"');
  CommonDataModule.Log(ClassName, 'SetState', sLog, ltCall);
end;

procedure TpoGamer.SetUserID(const Value: Integer);
begin
  FUserID := Value;
  FAccount.FUserID:= FUserID;
end;

procedure TpoGamer.SetUserName(const Value: String);
begin
  FUserName := Value;
end;

procedure TpoGamer.SitDownAt(aChar: TpoChair; nAmount: Integer);
begin
  if aChar = nil then begin
    EscalateFailure(
      EpoException,
      'Chair is not initialized.',
      '{1365C78E-ABAF-44AB-B935-D775683D872B}'
    );
  end;//if
  FChairID:= aChar.IndexOf();
  FInitialBalance:= nAmount;
  Account.ChargeFunds(Account.Balance);
  Account.AddFunds(nAmount);
  FSkippedRequiredStakes:= 0;
  FFinishedHands:= 0;
  aChar.UserID:= UserID;
  aChar.FHidden := False;
  State:= GS_IDLE;
  FDuringGameAddedMoney := 0;
end;


function TpoGamer.Store(aWriter: TWriter): Boolean;
var
  I: Integer;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteInteger(FSessionID);
  aWriter.WriteInteger(Integer(FState  ));
  aWriter.WriteString (FAttributes.Text);
  aWriter.WriteInteger(FUserID         );
  aWriter.WriteString (FUserName);
  aWriter.WriteInteger(FSexID   );
  aWriter.WriteString (FCity    );
  aWriter.WriteInteger(FChairID);
  aWriter.WriteBoolean(FPassCurrentHand);
  aWriter.WriteBoolean(FWaitForBigBlind);
  aWriter.WriteBoolean(FPassNextHand);
  aWriter.WriteBoolean(FShowDownPassed);
  aWriter.WriteBoolean(FChatAllow);
  aWriter.WriteInteger(FAffiliateID);
  aWriter.WriteBoolean(FIsEmailValidated);
  aWriter.WriteInteger(FLevelID);
  aWriter.WriteInteger(FCountOfRases);

  aWriter.WriteInteger(FIcons.Count);
  for I:=0 to FIcons.Count - 1 do aWriter.WriteString(FIcons[I]);

  aWriter.WriteInteger(FFinishedHands);
  aWriter.WriteInteger(FInitialBalance);
  aWriter.WriteInteger(Integer(FLastActionInRound));
  FCombinations.Store(aWriter);
  aWriter.WriteBoolean(FShowCardsAtShowdown);
  aWriter.WriteInteger(FDuringGameAddedMoney);
  aWriter.WriteInteger(FPrevChairID);
  aWriter.WriteInteger(FSkippedHands);
  aWriter.WriteBoolean(FMustSetBigBlind);
  aWriter.WriteBoolean(FMustSetPost);
  aWriter.WriteBoolean(FMustSetPostDead);

  aWriter.Write(FWinnerNominations, SizeOf(FWinnerNominations));
  aWriter.WriteInteger(FAllInOrder);
  aWriter.WriteInteger(FAvatarID);
  aWriter.WriteInteger(FImageVersion);
  aWriter.WriteBoolean(FIsSitOut);
  aWriter.WriteInteger(FTournamentPlace);
  aWriter.WriteInteger(FAllInRejectionHandID);
  aWriter.WriteCurrency(FTournamentPrizePercentage);
  aWriter.WriteCurrency(FTournamentPrizeBonus);

  //tournament addon
  aWriter.WriteInteger(FTournamentTimebank);
  aWriter.WriteInteger(FBalanceBeforeLastHand);

  //autobounce
  aWriter.WriteInteger(FSkippedRequiredStakes);
  aWriter.Write(FAutoActions, SizeOf(FAutoActions));
  aWriter.WriteInteger(FAutoActionStake);

  FAccount.Store(aWriter);
  FCards.Store(aWriter);

  aWriter.WriteBoolean(FTurnedCardsOver);
  aWriter.WriteBoolean(FSheduledToLeaveTable);
  aWriter.WriteBoolean(FDisconnected);

  aWriter.WriteBoolean(FSkippedSBStake);
  aWriter.WriteBoolean(FSkippedBBStake);

  aWriter.WriteString(FSessionHost);

  aWriter.WriteBoolean(FKickOffFromTournament);
  aWriter.WriteBoolean(FFinishedTournament);
  aWriter.WriteDate(FFinishedTournamentTime);

  aWriter.WriteBoolean(FRegularTimeoutActivated);
  aWriter.WriteBoolean(FActivateTimeBank );
  aWriter.WriteBoolean(FTimeBankActivated);

  aWriter.WriteBoolean(FRegularTimeoutExpired);

  aWriter.WriteString(FIP);

  aWriter.WriteInteger(FLastSkippedHandID);
  aWriter.WriteInteger(FHandIDWhenLeft);
  aWriter.WriteDate(FLastTimeActivity);

  aWriter.WriteBoolean(FIsTakedSit);
  aWriter.WriteBoolean(FIsBot);
  aWriter.WriteInteger(Integer(FBotCharacter));
  aWriter.WriteInteger(FBotBlaffersEvent);
  aWriter.WriteInteger(FBotID);
end;//TpoGamer.Store


procedure TpoGamer.SetPassCurrentHand(const Value: Boolean);
begin
  FPassCurrentHand := Value AND (NOT PassNextHand);
end;

procedure TpoGamer.SetPassNextHand(const Value: Boolean);
begin
  FPassNextHand := Value;
  if Value then AutoActions:= AutoActions+[GAA_SITOUT_NEXT_HAND]
  else AutoActions:= AutoActions-[GAA_SITOUT_NEXT_HAND];
end;

function TpoGamer.GetIndexOf: Integer;
begin
  Result:= FGamers.FGamers.IndexOf(Self);
end;


procedure TpoGamer.OnHandFinishNotify(aHand: TpoHand);
begin
  FRegularTimeoutActivated:= False;
  FRegularTimeoutExpired:= False;
  PassCurrentHand:= False;
  Inc(FFinishedHands);
  Cards.Clear;

  if FDuringGameAddedMoney > 0 then begin // morechips
    if Assigned(FGamers.FTable.FCroupier.OnMoreChips) then FGamers.FTable.FCroupier.OnMoreChips(Self);
  end;

  //correct state after reconcilation
  if (State = GS_ALL_IN) AND (Account.Balance > 0) AND (NOT Disconnected) AND
    (FGamers.FTable.FCroupier.TournamentType = TT_NOT_TOURNAMENT)
  then begin
    State := GS_IDLE;
  end;//

  if (PassNextHand AND (State IN [GS_IDLE, GS_PLAYING, GS_PASS, GS_FOLD, GS_MUCK]))
  then begin
    State:= GS_SITOUT;
    if Assigned(FGamers.FTable.FCroupier.OnGamerSitOut) then FGamers.FTable.FCroupier.OnGamerSitOut(Self);
  end;//if

  if State IN [GS_PLAYING, GS_ALL_IN, GS_PASS, GS_FOLD, GS_MUCK] then begin
    if Account.Balance <= 0 then begin
      if (FGamers.FTable.FCroupier.TournamentType = TT_NOT_TOURNAMENT) AND (State <> GS_SITOUT) then begin
        State:= GS_SITOUT;
        if Assigned(FGamers.FTable.FCroupier.OnGamerSitOut) then FGamers.FTable.FCroupier.OnGamerSitOut(Self);
      end else begin
//      if FGamers.FTable.FCroupier.TournamentType = TT_SINGLE_TABLE then begin
        State:= GS_ALL_IN;
//bot post on all in
        PostRandomAnswerOnCategory(Self, BCP_GOES_ALL_IN);

      end;//if
    end else State:= GS_IDLE;
  end;//

//Post state correction: reatore gaming status
  if (State IN [GS_IDLE, GS_PLAYING]) AND IsSitOut then begin
    State:= GS_SITOUT;
  end;//if
end;//TpoGamer.OnHandFinishNotify


function TpoGamer.GetIsActive: Boolean;
begin
  Result:=
    (FGamers.FTable.FHand.ActiveChairID <> UNDEFINED_POSITION_ID) AND
    (FGamers.FTable.FHand.ActiveChairID = ChairID);
end;

function TpoGamer.GetIsPlaying: Boolean;
begin
  Result:= IsAtTheTable AND (State = GS_PLAYING) AND (NOT PassCurrentHand);
end;

function TpoGamer.GetHasBets: Boolean;
begin
  Result:= FGamers.FTable.FHand.FPot.UserHasBets(UserID);
end;

function TpoGamer.GetHasBetsInCurrentRound: Boolean;
begin
  Result:= FGamers.FTable.FHand.FPot.UserHasBetsInRound(UserID);
end;

function TpoGamer.GetIsFirstInRaund: Boolean;
begin
  Result:= FGamers.FTable.Hand.RoundOpenChairID = ChairID;
end;

function TpoGamer.GetHand: TpoHand;
begin
  Result:= FGamers.FTable.Hand;
end;

procedure TpoGamer.OnNewRoundNotify(aHand: TpoHand);
begin
  FRegularTimeoutActivated:= False;
  FRegularTimeoutExpired:= False;
  FLastActionInRound:= GA_NONE;
  AutoActions:= AutoActions - TURN_LEVEL_AUTO_ACTIONS;//clear auto actions
end;

procedure TpoGamer.SetDuringGameAddedMoney(const Value: Integer);
begin
  FDuringGameAddedMoney:= Value;
end;

procedure TpoGamer.SetShowCardsAtShowdown(const Value: Boolean);
begin
  FShowCardsAtShowdown := Value;
end;

procedure TpoGamer.StandUp;
begin
  if FChairID <> UNDEFINED_POSITION_ID then begin
    FGamers.FTable.Chairs[FChairID].UserID:= UNDEFINED_USER_ID;
  end;//if
  FPrevChairID:= FChairID;
  FChairID:= UNDEFINED_POSITION_ID;
end;

function TpoGamer.GetCroupier: TpoGenericCroupier;
begin
  Result:= FGamers.FTable.FCroupier;
end;

procedure TpoGamer.SetWaitForBigBlind(const Value: Boolean);
begin
  FWaitForBigBlind := Value;
end;

procedure TpoGamer.SetMustSetBigBlind(const Value: Boolean);
begin
  FMustSetBigBlind := Value;
  if NOT Value then begin
    FMustSetPost:= False;
    FMustSetPostDead:= False;
  end;//
end;

procedure TpoGamer.SetMustSetPostDead(const Value: Boolean);
begin
  FMustSetPostDead := Value;
end;

function TpoGamer.GetIsSmallBlind: Boolean;
begin
  Result:= (FGamers.FTable.FHand.FSmallBlindChairID <> UNDEFINED_POSITION_ID)
    AND (FGamers.FTable.FHand.FSmallBlindChairID = ChairID);
end;

function TpoGamer.GetIsBigBlind: Boolean;
begin
  Result:= (FGamers.FTable.FHand.FBigBlindChairID <> UNDEFINED_POSITION_ID)
    AND (FGamers.FTable.FHand.FBigBlindChairID = ChairID);
end;

procedure TpoGamer.SetLastActionInRound(const Value: TpoGamerAction);
begin
  FLastActionInRound := Value;
end;

procedure TpoGamer.SetWinnerNominations(const Value: TpoWinnerNominations);
begin
  FWinnerNominations := Value;
end;

procedure TpoGamer.SetAllInOrder(const Value: Integer);
begin
  FAllInOrder := Value;
end;

procedure TpoGamer.SetAvatarID(const Value: Integer);
begin
  FAvatarID := Value;
end;

function TpoGamer.GetChair: TpoChair;
begin
  Result:= nil;
  if ChairID <> UNDEFINED_POSITION_ID then Result:= FGamers.FTable.Chairs[ChairID];
end;

function TpoGamer.GetNativeStateAsString: String;
begin
  Result:= nNativeStateToStringMap[State];
end;

function TpoGamer.Dump: String;
begin
  Result:= 'UserID: '+IntToStr(UserID)+' SessionID: '+IntToStr(SessionID)+
    ' Position: '+IntToStr(ChairID)+
    ' State: '+NativeStateAsString+ ' Balance: '+FloatToStr(Account.Balance)+
    ' Bets: '+FloatToStr(Bets)+
    ' Is sitting out: '+IntToStr(Integer(FIsSitOut)) +
    ' Last time activity:' + DateTimeToStr(FLastTimeActivity);
end;

function TpoGamer.GetBets: Integer;
var
  acc: TpoAccount;
begin
  if FGamers.FTable.Hand.state = HST_RUNNING then
    acc:= FGamers.FTable.Hand.Pot.Bets.GetAccountByUserID(UserID)
  else acc:= nil;
  if acc <> nil then Result:= acc.Balance
  else Result:= 0;
end;

procedure TpoGamer.SetIsSitOut(const Value: Boolean);
begin
  FIsSitOut := Value;
end;

procedure TpoGamer.Back;
begin
  IsSitOut:= False;
  if State = GS_SITOUT then State := GS_IDLE;
  if Account.Balance <= 0 then begin
    CommonDataModule.Log(ClassName, 'Back', 'Gamer cannot back with zero balance', ltError);
    EscalateFailure(
      EpoSessionException,
      'Gamer cannot back with zero balance',
      '{15BD2947-665D-4D83-93DB-76AA39CED10F}'
    );
  end;//
end;

procedure TpoGamer.SitOut;
begin
  IsSitOut:= True;
  if State IN [GS_PLAYING, GS_ALL_IN, GS_IDLE] then FState:= GS_SITOUT;
end;

procedure TpoGamer.SetMustSetPost(const Value: Boolean);
begin
  FMustSetPost := Value;
end;

procedure TpoGamer.SetSkippedRequiredStakes(const Value: Integer);
begin
  if FLastSkippedHandID = FGamers.FTable.Hand.HandID then Exit;
  FSkippedRequiredStakes := Value;
  FLastSkippedHandID := FGamers.FTable.Hand.HandID;
end;

procedure TpoGamer.SetAutoActionStake(const Value: Integer);
begin
  FAutoActionStake := Value;
end;

function TpoGamer.GetPassNextHand: Boolean;
begin
  Result:= FPassNextHand OR (GAA_SITOUT_NEXT_HAND IN AutoActions);
end;

procedure TpoGamer.SetDisconnected(const Value: Boolean);
begin
  FDisconnected := Value;
end;

procedure TpoGamer.ClearSkippedBlinds;
begin
  FSkippedSBStake:= False;
  FSkippedBBStake:= False;
end;

procedure TpoGamer.SetFinishedTournament(const Value: Boolean);
begin
  FFinishedTournament := Value;
  if FFinishedTournament then begin
    FFinishedTournamentTime := Now;
  end else begin
    FFinishedTournamentTime := 0;
  end;
end;

procedure TpoGamer.SetAllInRejectionHandID(const Value: Integer);
begin
  FAllInRejectionHandID := Value;
end;

procedure TpoGamer.SetActivateTimeBank(const Value: Boolean);
begin
  FActivateTimeBank := Value;
end;

procedure TpoGamer.SetTimeBankActivated(const Value: Boolean);
begin
  FTimeBankActivated := Value;
end;

procedure TpoGamer.SetRegularTimeoutActivated(const Value: Boolean);
begin
  FRegularTimeoutActivated := Value;
end;

procedure TpoGamer.SetRegularTimeoutExpired(const Value: Boolean);
begin
  FRegularTimeoutExpired := Value;
end;

procedure TpoGamer.SetTournamentTimebank(const Value: Integer);
begin
  FTournamentTimebank := Value;
end;

procedure TpoGamer.SetIP(const Value: String);
begin
  FIP := Value;
end;

procedure TpoGamer.SetShowDownPassed(const Value: Boolean);
begin
  FShowDownPassed := Value;
end;

procedure TpoGamer.SetChatAllow(const Value: Boolean);
begin
  FChatAllow := Value;
end;

procedure TpoGamer.SetHandIDWhenLeft(const Value: Integer);
begin
  FHandIDWhenLeft := Value;
end;

procedure TpoGamer.SetLastTimeActivity(const Value: TDateTime);
begin
  FLastTimeActivity := Value;
end;

procedure TpoGamer.SetAffiliateID(const Value: Integer);
begin
  FAffiliateID := Value;
end;

procedure TpoGamer.SetIsEmailValidated(const Value: Boolean);
begin
  FIsEmailValidated := Value;
end;

procedure TpoGamer.SetIsUpdated(const Value: Boolean);
begin
  FIsUpdated := Value;
end;

procedure TpoGamer.SetImageVersion(const Value: Integer);
begin
  FImageVersion := Value;
end;

procedure TpoGamer.SetKickOffFromTournament(const Value: Boolean);
begin
  FKickOffFromTournament := Value;
end;

procedure TpoGamer.SetIsBot(const Value: Boolean);
begin
  FIsBot := Value;
  if FIsBot then FIsTakedSit := True;
end;

procedure TpoGamer.SetBotCharacter(const Value: TFixUserCharacter);
begin
  FBotCharacter := Value;
end;

procedure TpoGamer.SetBotBlaffersEvent(const Value: Integer);
begin
  FBotBlaffersEvent := Value;
end;

procedure TpoGamer.SetBotID(const Value: Integer);
begin
  FBotID := Value;
end;

procedure TpoGamer.SetIsTakedSit(const Value: Boolean);
begin
  if FIsBot then FIsTakedSit := True else FIsTakedSit := Value;
end;

function TpoGamer.GetIsTakedSit: Boolean;
begin
  Result := FIsTakedSit;
  if FIsBot then Result := True;
end;

procedure TpoGamer.SetLevelID(const Value: Integer);
begin
  FLevelID := Value;
end;

procedure TpoGamer.SetCountOfRases(const Value: Integer);
begin
  FCountOfRases := Value;
end;

{ TpoGamers }

function TpoGamers.Add(aGamer: TpoGamer): TpoGamer;
begin
  Result:= aGamer;
  Result.FGamers:= Self;
  FGamers.Add(Result);
end;

procedure TpoGamers.CalcGamerStats(var nGamersCnt, nWatchersCnt: Integer);
var
  I: Integer;
begin
  nGamersCnt   := 0;
  nWatchersCnt := 0;
  for I:= 0 to Count-1 do begin
    if Gamers[I].IsWatcher then Inc(nWatchersCnt)
    else Inc(nGamersCnt);
  end;//for
end;

procedure TpoGamers.Clear;
begin
  FGamers.Clear;
end;

procedure TpoGamers.ClearAllInGamers(nAllInThreshold: Integer);
var
  I: Integer;
  bChanged: Boolean;
  aGamer: TpoGamer;
begin
  bChanged:= False;
  for I:= Count-1 downto 0 do begin
    if (Gamers[I].Account.Balance < nAllInThreshold) then begin
      Gamers[I].State := GS_ALL_IN;

//bot post all in
      PostRandomAnswerOnCategory(Gamers[I], BCP_GOES_ALL_IN);
      
    end;//if

    if Gamers[I].State = GS_ALL_IN then begin
      if Gamers[I].ChairID <> UNDEFINED_POSITION_ID then begin
        FTable.Chairs[Gamers[I].ChairID].UserID:= UNDEFINED_USER_ID;
        FTable.Chairs[Gamers[I].ChairID].Hidden:= True;
        if Assigned(FTable.FCroupier.OnChairStateChange)
        then FTable.FCroupier.OnChairStateChange(Gamers[I], Gamers[I].ChairID);
      end;//if
      aGamer:= TpoGamer(FGamers.Extract(Gamers[I]));
      FreeAndNil(aGamer);
      bChanged:= True;
    end;//
  end;//for
  if bChanged AND Assigned(FTable.FCroupier.OnChangeGamersCount)
  then FTable.FCroupier.OnChangeGamersCount(Self);
end;

procedure TpoGamers.ClearGamerCards;
var
  I: Integer;
begin
  for I:= 0 to Count -1 do begin
    Gamers[I].Cards.Clear;
  end;//for
end;

procedure TpoGamers.ClearLeftGamers(bSuppressNotification: Boolean);
var
  I: Integer;
  bChanged: Boolean;
begin
  bChanged:= False;
  for I:= Count-1 downto 0 do begin
    if Gamers[I].State = GS_LEFT_TABLE then begin
      if Gamers[I].ChairID <> UNDEFINED_POSITION_ID then begin
        Gamers[I].StandUp;
        if Assigned(FTable.FCroupier.OnChairStateChange) AND (NOT bSuppressNotification)
        then FTable.FCroupier.OnChairStateChange(Gamers[I], I);
      end;//if
      FGamers.Remove(Gamers[I]);
      bChanged:= True;
    end;//
  end;//for
  if bChanged AND Assigned(FTable.FCroupier.OnChangeGamersCount)
  then FTable.FCroupier.OnChangeGamersCount(Self);
end;

constructor TpoGamers.Create(aTable: TpoTable);
begin
  inherited Create;
  FGamers:= TObjectList.Create;
  FGamers.OwnsObjects := TRUE;

  FTable:= aTable;
  FActiveGamerActions   := CpoWatcherActions;
  FInactiveGamerActions := CpoWatcherActions;
  FWatcherActions       := CpoWatcherActions;
end;

procedure TpoGamers.DeleteGamer(aGamer: TpoGAmer);
begin
  FGAmers.Remove(aGAmer);
end;

destructor TpoGamers.Destroy;
begin
  FGamers.Clear;
  FGamers.Free;
  inherited;
end;

function TpoGamers.Dump: String;
var
  I: Integer;
begin
  Result:= '';
  for I:= 0 to Count-1 do begin
    Result:= Result+Gamers[I].Dump()+#$D#$A;
  end;//for
end;

procedure TpoGamers.DumpGamers;
var
  I: Integer;
  aGamer: TpoGamer;
begin
  for I:= 0 to Count-1 do begin
    aGamer := Gamers[I];
    CommonDataModule.Log(ClassName, 'DumpGamers',
      '  HandID='+IntTostr(FTable.FHand.FHandID)+', '+
      '  UserID='+IntTostr(aGamer.UserID)+', '+
      '  SessionID='+IntToStr(aGamer.SessionID)+', '+
      '  State='+aGamer.StateAsString+', '+
      '  IsActive='+IntToStr(Integer(aGamer.IsActive))+', '+
      '  IsSitout='+IntToStr(Integer(aGamer.IsSitOut))
      , ltCall);
  end;//for
end;

procedure TpoGamers.FixElementRefs;
begin
//TBD:
end;

function TpoGamers.GamerByPosition(nPosition: Integer): TpoGamer;
var
  I: Integer;
  aGamer: TpoGamer;
begin
  Result := nil;
  if nPosition = UNDEFINED_POSITION_ID then Exit;
  for I:=0 to Count - 1 do begin
    aGamer := Gamers[I];
    if (aGamer.FChairID = nPosition) then begin
      Result := aGamer;
      Exit;
    end;
  end;
end;

function TpoGamers.GamerBySessionID(nSessionID: Integer): TpoGamer;
var
  I: Integer;
begin
  Result:= nil;
  if nSessionID = UNDEFINED_SESSION_ID then Exit;
  for I:= 0 to Count-1 do begin
    if Gamers[I].SessionID = nSessionID then begin
      Result:= Gamers[I];
      Exit;
    end;//if
  end;//for
end;

function TpoGamers.GamerByUserID(nID: Integer): TpoGamer;
var
  I: Integer;
begin
  Result:= nil;
  if nID = UNDEFINED_USER_ID then Exit;
  for I:= 0 to Count-1 do begin
    if Gamers[I].UserID = nID then begin
      Result:= Gamers[I];
      Exit;
    end;//if
  end;//for
end;

function TpoGamers.GamerByBotID(nID: Integer): TpoGamer;
var
  I: Integer;
begin
  Result:= nil;
  if nID = UNDEFINED_USER_ID then Exit;
  for I:= 0 to Count-1 do begin
    if Gamers[I].BotID = nID then begin
      Result:= Gamers[I];
      Exit;
    end;//if
  end;//for
end;

function TpoGamers.GetCount: Integer;
begin
  Result:= FGamers.Count;
end;

function TpoGamers.GetDealer: TpoGamer;
begin
  Result:= nil;
  if (FTable.Hand.DealerChairID <> UNDEFINED_POSITION_ID) AND
  (FTable.Chairs[FTable.Hand.DealerChairID].UserID <> UNDEFINED_USER_ID)
  then begin
    Result:= GamerByUserID(FTable.Chairs[FTable.Hand.DealerChairID].UserID);
  end;//if
end;

function TpoGamers.GetGamers(Index: Integer): TpoGamer;
begin
  Result:= FGamers.Items[Index] as TpoGamer;
end;

function TpoGamers.Load(aReader: TReader): Boolean;
var
  I, cnt: Integer;
begin
  FGamers.Clear;
  Result:= inherited Load(aReader);
  cnt:= aReader.ReadInteger;
  for I:= 0 to cnt-1  do begin
    Add(TpoGamer.Create(Self)).Load(aReader);
  end;//for
  FAllInsCount:= aReader.ReadInteger;

  aReader.Read(FActiveGamerActions,   SizeOf(TpoGamerActions));
  aReader.Read(FInactiveGamerActions, SizeOf(TpoGamerActions));
  aReader.Read(FWatcherActions,       SizeOf(TpoGamerActions));
end;

function TpoGamers.RegisterGamer(
  nSessionID: Integer;
  sHost: String;
  nUserID: Integer;
  sUserName: String; nSexID: Integer; sCity: String; nAvatarID, nImageVersion: Integer;
  bChatAllow: Boolean;
  nAffiliateID: Integer;
  bIsEmailValidated: Boolean;
  nLevelID: Integer;
  aIcons: TStringList
): TpoGamer;
begin
  Result:= TpoGamer.Create(Self);
  Add(Result);
  Result.SessionID:= nSessionID;
  Result.SessionHost:= sHost;
  Result.UserID:= nUserID;
  Result.UserName:= sUserName;
  Result.SexID:= nSexID;
  Result.City:= sCity;
  Result.AvatarID:= nAvatarID;
  Result.ImageVersion:= nImageVersion;
  Result.ChatAllow := bChatAllow;
  Result.FAffiliateID := nAffiliateID;
  Result.FIsEmailValidated := bIsEmailValidated;
  Result.FLevelID := nLevelID;

  Result.FIcons.Clear;
  if (aIcons <> nil) then
    Result.FIcons.Text := aIcons.Text;

  Result.FIsUpdated := True;
end;

procedure TpoGamers.Remove(aGamer: TpoGamer);
begin
  FGamers.Remove(aGamer);
end;

function TpoGamers.Extract(aGamer: TpoGamer): TpoGamer;
begin
  Result:= FGamers.Extract(aGamer) as TpoGamer;
end;

procedure TpoGamers.SetActiveGamerActions(const Value: TpoGamerActions);
begin
  FActiveGamerActions := Value;
end;

procedure TpoGamers.SetAllInsCount(const Value: Integer);
begin
  FAllInsCount := Value;
end;

procedure TpoGamers.SetDealer(const Value: TpoGamer);
begin
  if Value.ChairID = UNDEFINED_POSITION_ID then begin
    EscalateFailure(
      EpoException,
      'User without position cannot be dealer.',
      '{2CDAA88C-E4CD-42D2-884B-77C13359CE0D}'
    );
  end;//
  if Value <> nil then FTAble.Hand.DealerChairID:= Value.ChairID;
end;

procedure TpoGamers.SetInactiveGamerActions(const Value: TpoGamerActions);
begin
  FInactiveGamerActions := Value;
end;

procedure TpoGamers.SetWatcherActions(const Value: TpoGamerActions);
begin
  FWatcherActions := Value;
end;

function TpoGamers.Store(aWriter: TWriter): Boolean;
var
  I: Integer;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteInteger(Count);
  for I:= 0 to Count-1 do begin
    Gamers[I].Store(aWriter);
  end;//dor
  aWriter.WriteInteger(FAllInsCount);

  aWriter.Write(FActiveGamerActions,   SizeOf(TpoGamerActions));
  aWriter.Write(FInactiveGamerActions, SizeOf(TpoGamerActions));
  aWriter.Write(FWatcherActions,       SizeOf(TpoGamerActions));
end;

function TpoGamers.UnregisterGamer(nSessionID: Integer): Boolean;
var
  g: TpoGamer;
begin
  Result:= False;
  g:= GamerBySessionID(nSessionID);
  if g <> nil then begin
    Extract(g).Free;
    Result:= True;
  end;//if
end;

function TpoGamers.UpdateGamer(
  nSessionID: Integer;
  sHost: String;
  nUserID: Integer;
  sUserName: String; nSexID: Integer; sCity: String;
  nAvatarID, nImageVersion: Integer; sIP: String;
  bChatAllow: Boolean;
  nAffiliateID: Integer;
  bIsEmailValidated: Boolean;
  nLevelID: Integer;
  aIcons: TStringList
): TpoGamer;
begin
  Result:= GamerByUserID(nUserID);
  if Result = nil then Result:= GamerBySessionID(nSessionID);
  if Result = nil then begin

    CommonDataModule.Log(ClassName, 'UpdateGamer',
      'Gamer with such SessionID or UserID ('+IntToStr(nSessionID)+':'+IntToStr(nUserID)+') not found among gamers'
      , ltCall);
    DumpGamers;

    EscalateFailure(
      EpoSessionException,
      nSessionID,
      'Gamer with such SessionID or UserID ('+IntToStr(nSessionID)+':'+IntToStr(nUserID)+') not found among gamers',
      '{1BF004E6-9CFF-48C9-96E0-04F3E1DC8516}'
    );

  end;//if

  Result.SessionID:= nSessionID;
  Result.SessionHost:= sHost;
  if (FTable.FCroupier.TournamentType <> TT_MULTI_TABLE) or (nUserID > UNDEFINED_USER_ID) then begin
    Result.UserID:= nUserID;
  end;

  Result.UserName:= sUserName;
  Result.SexID:= nSexID;
  Result.City:= sCity;
  Result.AvatarID:= nAvatarID;
  Result.ImageVersion := nImageVersion;
  Result.IP:= sIP;
  Result.ChatAllow := bChatAllow;
  Result.FAffiliateID := nAffiliateID;
  Result.FIsEmailValidated := bIsEmailValidated;
  Result.FLevelID := nLevelID;

  Result.FIcons.Clear;
  if (aIcons <> nil) then
    Result.FIcons.Text := aIcons.Text;

  Result.IsUpdated := True;
end;

function TpoGamers.UpdateGamer(
  aGamer: TpoGamer;
  nSessionID: Integer;
  sHost: String;
  nUserID: Integer;
  sUserName: String; nSexID: Integer; sCity: String;
  nAvatarID, nImageVersion: Integer; sIP: string; bChatAllow: Boolean;
  nAffiliateID: Integer;
  bIsEmailValidated: Boolean;
  nLevelID: Integer;
  aIcons: TStringList
): TpoGamer;
begin
  Result:= aGamer;
  Result.SessionID:= nSessionID;
  Result.SessionHost:= sHost;
  if (FTable.FCroupier.TournamentType <> TT_MULTI_TABLE) or (nUserID > UNDEFINED_USER_ID) then begin
    Result.UserID:= nUserID;
  end;
  Result.UserName:= sUserName;
  Result.SexID:= nSexID;
  Result.City:= sCity;
  Result.AvatarID:= nAvatarID;
  Result.ImageVersion:= nImageVersion;
  Result.IP:= sIP;
  Result.ChatAllow := bChatAllow;
  Result.FAffiliateID := nAffiliateID;
  Result.FIsEmailValidated := bIsEmailValidated;
  Result.FLevelID := nLevelID;

  Result.FIcons.Clear;
  if aIcons <> nil then
    Result.FIcons.Text := aIcons.Text;

  Result.IsUpdated := True;
end;

function TpoGamers.CountOfWatchers: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I:= 0 to Count-1 do begin
    if Gamers[I].IsWatcher then Inc(Result);
  end;//for
end;

function TpoGamers.GamerByName(sName: string): TpoGamer;
var
  I: Integer;
  aGamer: TpoGamer;
begin
  Result := nil;
  for I:=0 to Count - 1 do begin
    aGamer := Gamers[I];
    if (aGamer.FUserName = sName) then begin
      Result := aGamer;
      Exit;
    end;
  end;
end;

{ TpoCard }

var
  nSuitToCharMap: Array [TpoCardSuit] of String = (
    'c',//CS_CLUB,
    'd',//CS_DIAMOND,
    'h',//CS_HEART,
    's' //CS_SPADE
  );

var
  nCardValueToCharMap: Array[TpoCardValue] of String = (
    'A', //CV_1
    '2', //CV_2
    '3', //CV_3,
    '4', //CV_4,
    '5', //CV_5,
    '6', //CV_6,
    '7', //CV_7,
    '8', //CV_8,
    '9', //CV_9,
    'T', //CV_10,
    'J', //CV_JACK,
    'Q', //CV_QUEEN,
    'K', //CV_KING,
    'A'  //CV_ACE,
  );

var
  nCardValueToCharMapNatural: Array[TpoCardValue] of String = (
    'A', //CV_1
    '2', //CV_2
    '3', //CV_3,
    '4', //CV_4,
    '5', //CV_5,
    '6', //CV_6,
    '7', //CV_7,
    '8', //CV_8,
    '9', //CV_9,
    '10', //CV_10,
    'J', //CV_JACK,
    'Q', //CV_QUEEN,
    'K', //CV_KING,
    'A'  //CV_ACE,
  );

  nCardValueToCharMapEx: Array[TpoCardValue] of String = (
    'ace', //CV_1
    'deuce', //CV_2
    'three', //CV_3,
    'four', //CV_4,
    'five', //CV_5,
    'six', //CV_6,
    'seven', //CV_7,
    'eight', //CV_8,
    'nine', //CV_9,
    'ten', //CV_10,
    'jack', //CV_JACK,
    'queen', //CV_QUEEN,
    'king', //CV_KING,
    'ace'  //CV_ACE,
  );


class function TpoCard.CardSuiteToStr(nSuit: TpoCardSuit): String;
begin
  Result:= nSuitToCharMap[nSuit];
end;

class function TpoCard.CardValueToStr(nValue: TpoCardValue): String;
begin
  Result:= nCardValueToCharMap[nValue];
end;

class function TpoCard.CardValueToStrEx(nValue: TpoCardValue): String;
begin
  Result:= nCardValueToCharMapEx[nValue];
end;


class function TpoCard.CardValueToStrNatural(nValue: TpoCardValue): String;
begin
  Result:= nCardValueToCharMapNatural[nValue];
end;

function TpoCard.CompareTo(aCard: TpoCard; bCompareSuit: Boolean): TpoCardComparison;
begin
  Result:= CC_EQUAL;
  if aCard = nil then begin
    EscalateFailure(
      EpoException,
      'Comparable card cannot be nil.',
      '{C067E230-B41C-4E60-BC06-C6238167CDCC}'
    );
  end;//if

  if Ord(aCard.Value) > Ord(Self.Value) then Result:= CC_LESS
  else
  if Ord(aCard.Value) = Ord(Self.Value) then Result:= CC_EQUAL
  else
  if Ord(aCard.Value) < Ord(Self.Value) then Result:= CC_GREATER;

  if (Result = CC_EQUAL) AND (bCompareSuit) then begin
    if Ord(aCard.Suit) > Ord(Self.Suit) then Result:= CC_LESS
    else
    if Ord(aCard.Suit) = Ord(Self.Suit) then Result:= CC_EQUAL
    else
    if Ord(aCard.Suit) < Ord(Self.Suit) then Result:= CC_GREATER
  end;//if
end;//TpoCard.CompareTo


constructor TpoCard.Create(
  nSuit: TpoCardSuit;
  nValue: TpoCardValue);
begin
  inherited Create;
  Suit:= nSuit;
  Value:= nValue;
end;


function TpoCard.Dump: String;
begin
  Result:= AsString;
end;

function TpoCard.GetAsString: string;
begin
  Result:= CardValueToStr(Value)+CardSuiteToStr(Suit);
end;//TpoCard.GetAsString

function TpoCard.Load(aReader: TReader): Boolean;
begin
  Result:= inherited Load(aReader);
  FSuit:= TpoCardSuit(aReader.ReadInteger);
  FValue:= TpoCardValue(aReader.ReadInteger);
  FOpen:= aReader.ReadBoolean;
  FIsRecycled:= aReader.ReadBoolean;
end;

procedure TpoCard.SetAsString(const Value: string);
begin
  Self.Value:= StrToCardValue(Value[1]);
  Self.Suit := StrToCardSuite(Value[Length(Value)]);
end;//TpoCard.SetAsString

procedure TpoCard.SetCustomData(const Value: Variant);
begin
  FCustomData := Value;
end;

procedure TpoCard.SetIsRecycled(const Value: Boolean);
begin
  FIsRecycled := Value;
end;

procedure TpoCard.SetOpen(const Value: Boolean);
begin
  FOpen := Value;
end;

procedure TpoCard.SetSuit(const Value: TpoCardSuit);
begin
  FSuit := Value;
end;

procedure TpoCard.SetValue(const Value: TpoCardValue);
begin
  FValue := Value;
end;

function TpoCard.Store(aWriter: TWriter): Boolean;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteInteger(Integer(FSuit));
  aWriter.WriteInteger(Integer(FValue));
  aWriter.WriteBoolean(FOpen);
  aWriter.WriteBoolean(FIsRecycled);
end;

class function TpoCard.StrToCardSuite(sSuite: String): TpoCardSuit;
begin
  Result:= CS_CLUB;
  sSuite:= UpperCase(Trim(sSuite));
  case sSuite[1] of
    'C': Result:= CS_CLUB;
    'D': Result:= CS_DIAMOND;
    'H': Result:= CS_HEART;
    'S': Result:= CS_SPADE;
  else
    EscalateFailure(
      EpoException,
      'Unknown card suit.',
      '{2FE53A6F-4BE0-425B-87E5-F38EBC62C58F}'
    );
  end;//case
end;//TpoCard.StrToCardSuite


class function TpoCard.StrToCardValue(sValue: String): TpoCardValue;
begin
  sValue:= UpperCase(Trim(sValue));
  Result:= CV_ACE;
  case sValue[Length(sValue)] of
    'A': Result:= CV_ACE;
    'K': Result:= CV_KING;
    'Q': Result:= CV_QUEEN;
    'J': Result:= CV_JACK;
    'T': Result:= CV_10;
    '9': Result:= CV_9;
    '8': Result:= CV_8;
    '7': Result:= CV_7;
    '6': Result:= CV_6;
    '5': Result:= CV_5;
    '4': Result:= CV_4;
    '3': Result:= CV_3;
    '2': Result:= CV_2;
    '1': Result:= CV_1;
  else
    EscalateFailure(
      EpoException,
      'Unknown card value.',
      '{8E808560-0874-435C-AB99-DBF21A8F4F39}'
    );
  end;//case
end;//TpoCard.StrToCardValue

{ TpoCardPack }

type
  PCard = ^TpoCard;

function TpoCardPack.AddCard(aCard: TpoCard): TpoCard;
begin
  Result:= aCard;
  Result.Fowner:= Self;
  AttachCard(Result);
end;

procedure TpoCardPack.AllocatePack;
var
  s: TpoCardSuit;
  v: TpoCardValue;
  c: TpoCard;
begin
  Clear;
  for s:= CS_SPADE downto CS_CLUB do begin
    for v:= CV_ACE downto CV_2 do begin
      c:= TpoCard.Create(s, v);
      AddCard(c);
    end;//for
  end;//for
end;

procedure TpoCardPack.Clear;
var
  I: Integer;
begin
  for  I:= 0 to Count-1 do Cards[I].Free;
  FCards.Clear;
end;

constructor TpoCardPack.Create;
begin
  inherited Create(nil);
  AllocatePack;
  FCards.Sorted:= True;
end;

destructor TpoCardPack.Destroy;
begin
  Clear;
  inherited;
end;

procedure TpoCardPack.FixElementRefs;
begin
//TBD:
end;

function TpoCardPack.GetByName(Index: string): TpoCard;
var
  I: Integer;
begin
  Result:= nil;
  for I:= 0 to Count-1 do begin
    if Index = Cards[I].AsString then begin
      Result:= Cards[I];
      Exit;
    end;//if
  end;//for
  if Result = nil then
    EscalateFailure(
      EpoException,
      'Card with name '+Index+' not found among cards.',
      '{67695B32-1F2F-4201-9584-8E14ED7BD3FC}'
    );
end;//TpoCardPack.GetByName



function TpoCardPack.GetCards(Index: Integer): TpoCard;
begin
  Result:= FCards.Objects[Index] as TpoCard;
end;

function TpoCardPack.Load(aReader: TReader): Boolean;
var
  I, cnt: Integer;
  c: TpoCard;
begin
  Clear;
  Result:= inherited Load(aReader);
  cnt:= aReader.ReadInteger;
  if cnt <> Count then begin
    EscalateFailure(
      EpoException,
      'Error occured during cardpack load.',
      '{66303E93-CBE9-4463-B5B6-DE173DF8D911}',
      GE_ERR_STATE_LOAD_FAILURE
    );
  end;//if
  for I:= 0 to Count-1 do begin
    c:= TpoCard.Create(CS_CLUB, CV_2);
    c.Fowner:= self;
    c.Load(aReader);
    FCards.Objects[I]:= c;
  end;//for
end;

function TpoCardPack.Store(aWriter: TWriter): Boolean;
var
  I: Integer;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteInteger(FCards.Count);
  for I:= 0 to Count-1 do begin
    Cards[I].Store(aWriter);
  end;//for
end;

{ TpoCardCollection }

function TpoCardCollection.AcqureCardsFrom(aCards: TpoCardCollection): Integer;
var
  nPrevCnt: Integer;
  I: Integer;
begin
  nPrevCnt:= Count;
  Result := 0; //bs
  if aCards = nil then Exit;
  Result:= aCards.FCards.Count;
  for I:= 0 to aCards.Count-1 do begin
    AttachCard(aCards[I]);
  end;//for
  if nPrevCnt <> Count then Modified:= True;
end;

function TpoCardCollection.AttachCard(aCard: TpoCard): TpoCard;
begin
  if FCards.IndexOf(aCard.AsString) <> -1 then begin
    EscalateFailure(
      EpoException,
      'Duplicated card name '+aCard.AsString,
      '{88DCF69D-FAC7-4F32-89F8-ED31F54A27D4}'
    );
  end;//
  FCards.AddObject(aCard.AsString, aCard);
  Result:= aCard;
  Modified:= True;
end;//TpoCardCollection.AttachCard

procedure TpoCardCollection.Clear;
var
  nPrevCnt: Integer;
begin
  nPrevCnt:= Count;
  FCards.Clear;
  if nPrevCnt <> Count then Modified:= True;
end;

constructor TpoCardCollection.Create(aOwner: TpoCardPack);
begin
  inherited Create;
  FCards:= TStringList.Create;
  FOwner:= aOwner;
  fs();
end;

destructor TpoCardCollection.Destroy;
begin
  FCards.Clear;

  FCards.Free;
  inherited;
end;

function TpoCardCollection.Find(AValue: TpoCardValue;
  ASuit: TpoCardSuit; AFindFlag: TPoCardFindFlag; Offset: Integer=0): Integer;
var
  Loop        : Integer;
  FoundValue  : Boolean;
  FoundSuit   : Boolean;
begin

  { return -1 if not found }
  Result := -1;
  for Loop := Offset to Self.Count-1 do
  begin
    FoundSuit:=FALSE;
    FoundValue:=FALSE;
    { checking for card suit }
    if ASuit = Self.Cards[Loop].FSuit then
    begin
      FoundSuit := TRUE;
      if AFindFlag = ffSuit then
      begin
        Result := Loop;
        Exit;
      end;
    end;

    { checking for card value }
    if AValue = Self.Cards[Loop].FValue then
    begin
      FoundValue := TRUE;
      if AFindFlag = ffValue then
      begin
        Result := Loop;
        Exit;
      end;
    end;

    { if value and suit found then exit }
    if (FoundValue and FoundSuit) and (AFindFlag = ffBoth) then
    begin
      Result := Loop;
      Exit;
    end;

  end;//for
end;

procedure TpoCardCollection.FixElementRefs;
begin
  //TBD: (persistence)
end;

function TpoCardCollection.GetByName(Index: String): TpoCard;
var
  nID: Integer;
begin
  nID:= FCards.IndexOf(Index);
  if nID = -1 then
    EscalateFailure(
      EpoException,
      'Card with the name '+Index+' not found inside card collection.',
      '{CEC6F111-131B-4821-9ED4-79F4ACC61695}'
    );
  Result:= Cards[nID];
end;//TpoCardCollection.GetByName


function TpoCardCollection.GetCards(Index: Integer): TpoCard;
begin
  if FCards.Objects[Index] = nil then FCards.Objects[Index]:= FOwner.FCards.Objects[FOwner.FCards.IndexOf(FCards[Index])];
  Result:= FCards.Objects[Index] as TpoCard;
end;//TpoCardCollection.GetCards


procedure TpoCardCollection.Sort(bCompareSuit: Boolean);
var
  i,j: Integer;
begin

  {sort cards using bubble sort }
  for i:=0 to (Self.Count-2) do
  begin
    for j:=0 to (Self.Count-2-i) do
    begin
      if Self.Cards[j+1].CompareTo(Self.Cards[j], bCompareSuit) = CC_GREATER then
        SwapCards(j, j+1);
    end;
  end;
  Modified:= True;
end;

function TpoCardCollection.Load(aReader: TReader): Boolean;
begin
  Clear;
  Result:= inherited Load(aReader);
  FActiveCards:= aReader.ReadInteger;
  FCards.Text:= aReader.ReadString;
end;

function TpoCardCollection.Store(aWriter: TWriter): Boolean;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteInteger(FActiveCards);
  aWriter.WriteString(FCards.Text);
end;

function TpoCardCollection.FormSeries(bOwnerMode: Boolean): String;
var
  i: Integer;
begin
  Result:= '';
  for I := 0 to Count - 1 do    // Iterate
  begin
    if bOwnerMode or Cards[I].Open then Result:= Result+Cards[I].AsString
    else Result:= Result+'back';
    if I < (Count-1) then Result:= Result+',';
  end;// for
end;

function TpoCardCollection.RemoveCardAt(nPosition: Integer): TpoCard;
begin
  Result:= Cards[nPosition];
  FCards.Delete(nPosition);
  Modified:= True;
end;

function TpoCardCollection.DealTopCardTo(aCardHolder: TpoCardCollection;
  bOpen: Boolean): TpoCard;
begin
  Result:= RemoveCardAt(Count-1);
  aCardHolder.AttachCard(Result).Open:= bOpen;
end;

function TpoCardCollection.SwapCards(nCard1ID, nCard2ID: Integer): Boolean;
begin
  Result:= False;
  if (nCard1ID >= Count) OR (nCard2ID >= Count) then Exit;
  FCards.Exchange(nCard1ID, nCard2ID);

  Result:= True;
  Modified:= True;
end;

{ TpoCardCombinationProcessor }


function TpoCardCollection.GetCount: Integer;
begin
  Result:= FCards.Count;
end;

procedure TpoCardCollection.SetActiveCards(const Value: Integer);
begin
  FActiveCards := Value;
end;


function CompareCardShuffleIDs(aList: TStringList; Item1, Item2: Integer): Integer;
var
  c1, c2: TpoCard;
begin
  Result:= 0;
  c1:= aList.Objects[Item1] as TpoCard;
  c2:= aList.Objects[Item2] as TpoCard;
  if c1.FShuffleID < c2.FShuffleID then Result:=1
  else
  if c1.FShuffleID > c2.FShuffleID then Result:=-1
end;//CompareCardShuffleIDs

procedure TpoCardCollection.Shuffle(bClearOpenStatus: Boolean);
var
  I: Integer;
begin
  for I:= 0 to Count-1 do begin
    if bClearOpenStatus then Cards[I].Open:= False;
    Cards[I].FShuffleID:= Random(MaxInt);
  end;//for
//reorder
  FCards.CustomSort(CompareCardShuffleIDs);
  Modified:= True;
end;


function TpoCardCollection.ExtractOpenCards: TpoCardCollection;
var
  I: Integer;
begin
  Result:= TpoCardCollection.Create(FOwner);
  for I:= 0 to Count-1 do begin
    if Cards[I].Open then Result.AttachCard(Cards[I]);
  end;//for
  Result.ActiveCards:= Result.Count;
end;//TpoCardCollection.ExtractOpenCards


procedure TpoCardCollection.ShuffleOpenCards;
var
  cc: TpoCardCollection;
  J, I: Integer;
begin
  cc:= ExtractOpenCards();
  if cc.Count > 0 then begin
    cc.Shuffle(False);
    J:= 0;
    for I:= 0 to Count-1 do begin
      if Cards[I].Open then begin
        SwapCards(I, IndexOf(cc[J]));
        Inc(J);
      end;//
    end;//for
  end;//if
  cc.Free;
end;

function TpoCardCollection.ExtractLowestCard(bUseOpenCards: Boolean): TpoCard;
var
  cc: TpoCardCollection;
  I: Integer;
begin
  Result:= nil;
  if Count = 0 then Exit;
  cc:= TpoCardCollection.Create(FOwner);
  if NOT bUseOpenCards then cc.AcqureCardsFrom(Self)
  else begin
    for I:= 0 to Count-1 do begin
      if Cards[I].Open then cc.AttachCard(Cards[I]);
    end;//for
  end;//if

  cc.Sort(True);
  Result:= cc[cc.Count-1];
  cc.Free;
end;


function TpoCardCollection.HighCard(bUseOpenCards: Boolean; bHiLoMode: Boolean): TpoCard;
var
  cc: TpoCardCollection;
  I: Integer;
begin
  Result:= nil;
  if Count = 0 then Exit;
  cc:= TpoCardCollection.Create(FOwner);

  { copy needed cards to the temp collection }
  for i:=0 to Self.Count-1 do
  begin
    if (bUseOpenCards) then
    begin
      { need to include only opened cards }
      if Self.Cards[I].Open then
      begin
        if bHiLoMode and (Self.Cards[I].Value = CV_ACE) then
          Continue;
        cc.AttachCard(Self.Cards[I]);
      end
    end
    else
    begin
      { include all cards }
      if bHiLoMode and (Self.Cards[I].Value = CV_ACE) then
        Continue;
      cc.AttachCard(Self.Cards[I]);
    end
  end;

  if cc.Count = 0 then
  begin
    cc.Free;
    Exit;
  end;

  Result := cc.Cards[0];
  for I:= 1 to cc.Count-1 do begin
    if cc.Cards[I].CompareTo(Result) = CC_GREATER then Result:= cc.Cards[I];
  end;//for

  cc.Free;
end;

function TpoCardCollection.IndexOf(aCard: TpoCard): Integer;
var
  I: Integer;
begin
  Result:= -1;
  for I:= 0 to Count-1 do begin
    if Cards[I] = aCard then begin
      Result:= I;
      Exit;
    end;//
  end;//
end;

procedure TpoCardCollection.ShuffleClosedCards;
var
  cc: TpoCardCollection;
  J, I: Integer;
  nInitCV: TpoCardValue;
  nInitCS: TpoCardSuit;

begin
  cc:= ExtractClosedCards();
  if cc.Count > 0 then begin
    nInitCV:= cc[0].Value;
    nInitCS:= cc[0].Suit;
    for I:= 0 to 10 do begin
      cc.Shuffle(False);
      if (cc[0].Value <> nInitCV) OR (cc[0].Suit <> nInitCS) then Break;
    end;//for

    J:= 0;
    for I:= 0 to Count-1 do begin
      if NOT Cards[I].Open then begin
        SwapCards(I, IndexOf(cc[J]));
        Inc(J);
      end;//
    end;//for
  end;//if
  cc.Free;
end;

function TpoCardCollection.ExtractClosedCards: TpoCardCollection;
var
  I: Integer;
begin
  Result:= TpoCardCollection.Create(FOwner);
  for I:= 0 to Count-1 do begin
    if NOT Cards[I].Open then Result.AttachCard(Cards[I]);
  end;//for
  Result.ActiveCards:= Result.Count;
end;

function TpoCardCollection.Dump: String;
begin
  Result:= FormSeries(True);
end;

procedure TpoCardCollection.OpenHand;
var
  I: Integer;
begin
  for I:= 0 to Count-1 do begin
    Cards[I].Open:= True;
  end;//for
end;

function TpoCardCollection.FormLoSeries: String;
var
  i: Integer;
begin
  Result:= '';
  for I := 0 to Count - 1 do begin
    Result:= Result+Cards[I].CardValueToStrNatural(Cards[I].Value);
    if I < (Count-1) then Result:= Result+',';
  end;// for
end;

procedure TpoCardCollection.SetModified(const Value: Boolean);
begin
  FModified := Value;
end;

function TpoCardCollection.InsertCardAt(aCard: TpoCard;
  nIndex: Integer): TpoCard;
begin
  if FCards.IndexOf(aCard.AsString) <> -1 then begin
    EscalateFailure(
      EpoException,
      'Duplicated card name '+aCard.AsString,
      '{88DCF69D-FAC7-4F32-89F8-ED31F54A27D4}'
    );
  end;//
  FCards.InsertObject(nIndex, aCard.AsString, aCard);
  Result:= aCard;
  Modified:= True;
end;

procedure TpoCardCollection.ClearCache;
var
  I: Integer;
begin
  for I:= 0 to Count-1 do begin
    FCards.Objects[I]:= nil;
  end;
end;

function TpoCardCollection.RemoveCard(aCard: TpoCard): Integer;
var
  I: Integer;
begin
  Result:= -1;
  for I:= 0 to Count-1 do begin
    if (Cards[I].Value = aCard.Value) AND (Cards[I].Suit = aCard.Suit) then begin
      FCards.Delete(I);
      Result:= 0;
      Exit;
    end;//if
  end;//for
end;

procedure TpoCardCollection.RemoveCards(aCards: TpoCardCollection);
var
  I: Integer;
begin
  for I:= 0 to aCards.Count-1 do begin
    RemoveCard(aCards[I]);
  end;//for
end;

function TpoCardCollection.GetSeries: String;
begin
  Result:= FormSeries(True);
end;

procedure TpoCardCollection.AssignCardName(nID: Integer; sName: String);
begin
  FCards[nID]:= sName;
  FCards.Objects[nID]:= nil;
end;

function TpoCardCollection.fs: string;
begin
  Result:= FormSeries(True);
end;

procedure TpoCardCollection.ReplaceCardsValue(FromValue, ToValue: TpoCardValue);
var
  I: Integer;
  aCard: TpoCard;
begin
  for I:=0 to Count - 1 do begin
    aCard := Cards[I];
    if (aCard.FValue = FromValue) then aCard.FValue := ToValue;
  end;
end;

{ TpoChair }

constructor TpoChair.Create;
begin
  inherited Create;
  UserID:= UNDEFINED_USER_ID;
  FReservationUserID:= UNDEFINED_USER_ID;
  FDrinksName := '';
  FDrinksID := -1;
end;

procedure TpoChair.FixElementRefs;
begin
//TBD:
//must reestablish link to gamer after reload
end;

function TpoChair.GetIsDealer: Boolean;
begin
  Result:= (UserID <> UNDEFINED_USER_ID) AND
    (FChairs.FTable.FHand.DealerChairID <> UNDEFINED_POSITION_ID) AND
    (FChairs.FTable.FHand.DealerChairID = IndexOf);
end;

function TpoChair.GetID: Integer;
begin
  Result:= FChairs.FChairs.IndexOf(Self);
end;

function TpoChair.GetState: TpoChairState;
begin
  if FHidden then Result:= CS_HIDDEN
  else begin
    if UserID = UNDEFINED_USER_ID then begin
      if ReservationUserID <> UNDEFINED_USER_ID then Result:= CS_RESERVED
      else Result := CS_EMPTY;
    end else Result:= CS_BUSY;
  end;
end;

var
  nChairStateToStringMap: Array[TpoChairState] of String = (
    'free',//CS_EMPTY,
    'busy',//CS_BUSY,
    'reserved',//CS_RESERVED
    'hidden'
  );

function TpoChair.GetStateAsString: String;
begin
  Result:= nChairStateToStringMap[State];
end;

function TpoChair.IndexOf: Integer;
begin
  Result:= FChairs.FChairs.IndexOf(Self);
end;

function TpoChair.Load(aReader: TReader): Boolean;
begin
  Result:= inherited Load(aReader);
  UserID:= aReader.ReadInteger;
  ReservationUserID:= aReader.ReadInteger;
  FHidden:= aReader.ReadBoolean;
  FDrinksName := aReader.ReadString;
  FDrinksID := aReader.ReadInteger;
end;

procedure TpoChair.SetUserID(const Value: Integer);
begin
  FFUserID := Value;
  if (FFUserID <= UNDEFINED_USER_ID) then begin
    FDrinksName := '';
    FDrinksID   := -1;
  end;
end;


function TpoChair.Store(aWriter: TWriter): Boolean;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteInteger(UserID);
  aWriter.WriteInteger(FReservationUserID);
  aWriter.WriteBoolean(FHidden);
  aWriter.WriteString(FDrinksName);
  aWriter.WriteInteger(FDrinksID);
end;

function TpoChair.GetGamer: TpoGamer;
begin
  Result:= nil;
  if UserID <> UNDEFINED_USER_ID then begin
    Result:= FChairs.FTable.Gamers.GamerByUserID(UserID);
  end;//
end;

function TpoChair.GetIsActive: Boolean;
begin
  Result:= (FChairs.FTable.Hand.ActiveChairID <> UNDEFINED_POSITION_ID) AND
    (FChairs.FTable.Hand.ActiveChairID = IndexOf);
end;


function TpoChair.GetIsPlaying: Boolean;
begin
  Result:= (UserID <> UNDEFINED_USER_ID) AND (Gamer.State IN [GS_PLAYING, GS_ALL_IN]);
end;

function TpoChair.GetIsAllIn: Boolean;
begin
  Result:= (UserID <> UNDEFINED_USER_ID) AND (Gamer.State = GS_ALL_IN);
end;

function TpoChair.GetIsBusy: Boolean;
begin
  Result:= (State = CS_BUSY);
end;


function TpoChair.GetIsSitOut: Boolean;
begin
  if Gamer = nil then EscalateFailure(EpoException, 'Chair is empty', '{F367C73C-3777-4F19-B9BA-EB8263AB3C34}');
  Result:= (Gamer.State = GS_SITOUT);
end;

procedure TpoChair.ClearReservation;
begin
  ReservationUserID:= UNDEFINED_USER_ID;
  if Assigned(FChairs.FTable.FCroupier.OnChairStateChange)
  then FChairs.FTable.FCroupier.OnChairStateChange(nil, IndexOf());
end;

procedure TpoChair.SetReservation(nUserID: Integer);
begin
  if ReservationUserID <> UNDEFINED_USER_ID then begin
    EscalateFailure(
      'Chair (ID: '+IntToStr(IndexOf)+') is already under reservation',
      '{07136C03-EB53-47FD-BDA4-FC1D63F20A99}'
    );
  end;//if
  ReservationUserID:= nUserID;
  if Assigned(FChairs.FTable.FCroupier.OnChairStateChange)
  then begin
    FChairs.FTable.FCroupier.OnChairStateChange(nil, IndexOf());
  end;//if
end;


procedure TpoChair.SetReservationUserID(const Value: Integer);
begin
  FReservationUserID := Value;
end;

procedure TpoChair.SetHidden(const Value: Boolean);
begin
  FHidden := Value;
end;

procedure TpoChair.KickOffGamer(bSuppressNotification: Boolean);
begin
  if Gamer <> nil then begin
    Gamer.StandUp;
    UserID:= UNDEFINED_USER_ID;

    if FChairs.FTable.FCroupier.FTournamentType <> TT_MULTI_TABLE then begin
      if Hidden then Hidden:= False;
      if Assigned(FChairs.FTable.FCroupier.OnChairStateChange) AND (NOT bSuppressNotification)
      then FChairs.FTable.FCroupier.OnChairStateChange(Gamer, IndexOf);
    end else begin
      Hidden:= True;
    end;
  end;//if
  if FChairs.FTable.FCroupier.FTournamentType <> TT_MULTI_TABLE then begin
    if Hidden then begin
      Hidden:= False;
      if Assigned(FChairs.FTable.FCroupier.OnChairStateChange) AND (NOT bSuppressNotification)
      then FChairs.FTable.FCroupier.OnChairStateChange(Gamer, IndexOf);
    end;//if
  end else begin
    Hidden:= True;
    if Assigned(FChairs.FTable.FCroupier.OnChairStateChange) AND (NOT bSuppressNotification)
    then FChairs.FTable.FCroupier.OnChairStateChange(Gamer, IndexOf);
  end;
end;

procedure TpoChair.SetDrinksID(const Value: Integer);
begin
  FDrinksID := Value;
end;

procedure TpoChair.SetDrinksName(const Value: string);
begin
  FDrinksName := Value;
end;

{ TpoTable }

constructor TpoTable.Create;
begin
  inherited Create;
  FChairs:= TpoChairs.Create;
  FChairs.FTable:= self;
  FGamers:= TpoGamers.Create(Self);
  FGamers.FTable:= Self;

  FCasinoAccount:= TpoAccount.Create(
    ACC_CASINO_PREFIX,
    CASINO_ACCOUNT_TYPE,
    AC_DEFAULT
  );

  FRakes:= TpoRakes.Create;
  FReservations:= TpoReservations.Create;
  FHand:= TpoHand.Create(Self);
  FRakeRulesItem := TpoRakeRulesItem.Create(nil);

  Version:= 1;
end;

destructor TpoTable.Destroy;
begin
  FRakeRulesItem.Free;
  FHand.Free;
  FReservations.Free;
  FRakes.Free;
  FCasinoAccount.Free;
  FGamers.Free;
  FChairs.Free;
  inherited;
end;


function TpoTable.Dump: String;
begin
  Result:= '';
  Result:= Result+LF+
  '== [ Table: ] ==============================================================='+LF;
  Result:= Result+
    ' MandatoryAnte: ' + FloatTostr(MandatoryAnte/100)+
    ' SmallBetValue: ' + FloatTostr(SmallBetValue/100)+
    ' BigBetValue: '   + FloatTostr(BigBetValue/100)  +
    ' MinBuyIn: '      + FloatTostr(MinBuyIn/100)     +
    ' MaxBuyIn: '      + FloatTostr(MaxBuyIn/100)     +
    ' DefBuyIn: '      + FloatTostr(DefBuyIn/100)     ;

  Result:= Result+LF+LF+
  '-- [ Gamers: ] --------------------------------------------------------------'+LF+
  Gamers.Dump()+LF;

  Result:= Result+LF+
  Hand.Dump();
end;

procedure TpoTable.FixElementRefs;
begin
//TBD:
//must reestablish back refs for chairs and gamers on load
end;

function TpoTable.GetActiveGamer: TpoGamer;
begin
  Result:= Hand.ActiveGamer;
end;

function TpoTable.GetCards: TpoCardPack;
begin
  Result:= Hand.CardDeck;
end;

function TpoTable.Load(aReader: TReader): Boolean;
begin
  Result:= inherited Load(aReader);
  FName           := aReader.ReadString;
  MandatoryAnte   := aReader.ReadInteger;
  SmallBetValue   := aReader.ReadInteger;
  BigBetValue     := aReader.ReadInteger;
  FMaxBuyIn       := aReader.ReadInteger;
  FMinBuyIn       := aReader.ReadInteger;
  FDefBuyIn       := aReader.ReadInteger;
  FCurrencyID   := aReader.ReadInteger;

  FValueOfFracsToNextHand := aReader.ReadCurrency;

  FAveragePot   := aReader.ReadCurrency;
  FAvgPlayersAtFlop:= aReader.ReadInteger;
  FPlayedHands  := aReader.ReadInteger;

  FCasinoAccount.Load(aReader);
  FRakes.Load(aReader);
  FChairs.Load(aReader);
  FGamers.Load(aReader);
  FReservations.Load(aReader);
  FHand.Load(aReader);
  FRakeRulesItem.Load(aReader);

  FHandsPerHour:= aReader.ReadInteger();
  FLastFinishedHandStamp:= aReader.ReadDate();
end;

procedure TpoTable.OnHandFinishNotify(aHand: TpoHand);
var
  I: Integer;
  FCurrentFinishStamp: TDateTime;
  ts: TTimeStamp;
  nAverageInterhandPeriod: Integer;
  nInterHandPeriod: Integer;

begin
  for I:= 0 to Gamers.Count-1 do begin
    Gamers[I].OnHandFinishNotify(aHand);
  end;//for

//recalc stats
  FCurrentFinishStamp:= Now;
  if FPlayedHands >= 1 then begin
    ts:= DateTimeToTimeStamp(FLastFinishedHandStamp-FCurrentFinishStamp);
    nInterHandPeriod:= ts.Time; //ms

    if (FHandsPerHour > 0) then begin
      nAverageInterhandPeriod:= Round((1/FHandsPerHour)*60*60*1000);
      nAverageInterhandPeriod:= Round((nAverageInterhandPeriod+nInterHandPeriod)/2);
    end else nAverageInterhandPeriod:= nInterHandPeriod;

    FHandsPerHour:= Round((1.0/nAverageInterhandPeriod)*60*60*1000);
  end else FHandsPerHour:= 0;

  FLastFinishedHandStamp:= FCurrentFinishStamp;
  Inc(FPlayedHands);
end;

procedure TpoTable.OnNewHandNotify(aHand: TpoHand);
var
  I: Integer;
begin
  FRakes.Reset;
  Gamers.AllInsCount:= 0;
  for I:= 0 to Gamers.Count-1 do begin
    Gamers[I].OnNewHandNotify(aHand);
  end;//for
  if FLastFinishedHandStamp = 0 then FLastFinishedHandStamp:= Now;
end;

procedure TpoTable.OnNewRoundNotify(aHand: TpoHand);
var
  I: Integer;
begin
  FRakes.Reset;
  for I:= 0 to Gamers.Count-1 do begin
    Gamers[I].OnNewRoundNotify(aHand);
  end;//for
end;

procedure TpoTable.SetAveragePot(const Value: Currency);
begin
  FAveragePot := Value;
end;

procedure TpoTable.SetBigBetValue(const Value: Integer);
begin
  FBigBetValue := Value;
end;

procedure TpoTable.SetCurrencyID(const Value: Integer);
begin
  FCurrencyID := Value;
end;

procedure TpoTable.SetDefBuyIn(const Value: Integer);
begin
  FDefBuyIn := Value;
end;

procedure TpoTable.SetPlayedHands(const Value: Integer);
begin
  FPlayedHands := Value;
end;

procedure TpoTable.SetMaxBuyIn(const Value: Integer);
begin
  FMaxBuyIn := Value;
end;

procedure TpoTable.SetMinBuyIn(const Value: Integer);
begin
  FMinBuyIn := Value;
end;

procedure TpoTable.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TpoTable.SetAvgPlayersAtFlop(const Value: Integer);
begin
  FAvgPlayersAtFlop := Value;
end;

procedure TpoTable.SetSmallBetValue(const Value: Integer);
begin
  FSmallBetValue := Value;
end;

function TpoTable.Store(aWriter: TWriter): Boolean;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteString(FName);
  aWriter.WriteInteger(MandatoryAnte);
  aWriter.WriteInteger(SmallBetValue);
  aWriter.WriteInteger(BigBetValue);
  aWriter.WriteInteger(FMaxBuyIn);
  aWriter.WriteInteger(FMinBuyIn);
  aWriter.WriteInteger(FDefBuyIn);
  aWriter.WriteInteger(FCurrencyID);

  aWriter.WriteCurrency(FValueOfFracsToNextHand);

  aWriter.WriteCurrency(FAveragePot);
  aWriter.WriteInteger(FAvgPlayersAtFlop);
  aWriter.WriteInteger(FPlayedHands);

  FCasinoAccount.Store(aWriter);
  FRakes.Store(aWriter);
  FChairs.Store(aWriter);
  FGamers.Store(aWriter);
  FReservations.Store(aWriter);
  FHand.Store(aWriter);
  FRakeRulesItem.Store(aWriter);

  aWriter.WriteInteger(FHandsPerHour);
  aWriter.WriteDate(FLastFinishedHandStamp);
end;

procedure TpoTable.SetHandsPerHour(const Value: Integer);
begin
  FHandsPerHour := Value;
end;

function TpoTable.GamerAtTheTableByIP(sIP: String): TpoGamer;
var
  I: Integer;
begin
  Result:= nil;
  for I:= 0 to Chairs.Count-1 do begin
    if (Chairs[I].Gamer <> nil) AND (Chairs[I].Gamer.IP = sIP) then begin
      Result:= Chairs[I].Gamer;
      Exit;
    end;//if
  end;//for
end;

procedure TpoTable.SetSourcePot(const Value: Integer);
begin
  FSourcePot := Value;
end;

procedure TpoTable.SetValueOfFracsToNextHand(const Value: Currency);
begin
  FValueOfFracsToNextHand := Value;
end;

procedure TpoTable.SetMandatoryAnte(const Value: Integer);
begin
  FMandatoryAnte := Value;
end;

{ TpoCardCombination }

var
  sCombinationToStringMap: Array [TpoCardCombinationKind] of String = (
    'Empty',           //CCK_EMPTY    //reserved
    'Wheel',          //CCK_WHEEL,
    'High card',      //CCK_HIGH_CARD,
    'One pair',       //CCK_ONE_PAIR,
    'Two pair',       //CCK_TWO_PAIR,
    'Three of a kind',//CCK_3_OF_A_KIND,
    'Straight',        //CCK_STRAIGHT,
    'Flush',          //CCK_FLUSH,
    'Full House',     //CCK_FULL_HOUSE,
    'Four of a kind', //CCK_4_OF_A_KIND,
    'Straight Flush',  //CCK_STRAIGHT_FLUSH,
    'Royal Flush'    //CCK_ROYAL_FLUSH,
  );

function TpoCardCombination.AcquireCombination(
  aCombination: TpoCardCombination): TpoCardCombination;
begin
  Clear;
  Result:= Self;
  if aCombination = nil then Exit;
  AcqureCardsFrom(aCombination);
  Kind:= aCombination.Kind;
  Description:= aCombination.Description;
  Gamer:= aCombination.Gamer;
  UserID:= aCombination.UserID;
end;//TpoCardCombination.AcquireCombination


function TpoCardCombination.HiBetterOrEqual(
  ACombination: TpoCardCombination): Boolean;
begin
  Result:= CompareTo(ACombination) IN [CC_GREATER, CC_EQUAL];
end;

function TpoCardCombination.HiBetterThan(
  ACombination: TpoCardCombination): Boolean;
begin
  Result:= CompareTo(ACombination) = CC_GREATER;
end;

procedure TpoCardCombination.Clear;
begin
  inherited;
  Kind:= CCK_EMPTY;
end;

function TpoCardCombination.CompareTo(ACombination: TpoCardCombination; 
    bCompareSuit: Boolean = GLM_COMPARE_SUIT; bBothKickers: Boolean = FALSE): 
    TpoCardComparison;
var
  Loop    : Integer;
begin
  if ACombination = nil then begin
    EscalateFailure(
      EpoException,
      'Comparable card combination cannot be nil.',
      '{E69120B1-B2B3-483C-9ABB-2D90B7E6D566}'
    );
  end;//if

  { checking combination rank }
  if not bBothKickers then
  begin
    Self.Description := '';
    ACombination.Description := '';
  end;

  if Self.Kind = CCK_EMPTY then Result:= CC_LESS
  else
  if Self.Kind > ACombination.Kind then Result := CC_GREATER
  else
  if Self.Kind < ACombination.Kind then Result := CC_LESS
  else begin
    { combination ranks are equals }
    { start looking for the kicker }
    Result := CC_EQUAL;
    for Loop := 0 to Self.Count-1 do begin
      if Loop >= ACombination.Count then Break;
      if (Self.Cards[Loop].FValue > ACombination.Cards[Loop].FValue) then
      begin
        Result := CC_GREATER;
        case FKind of
          CCK_HIGH_CARD : if Loop>0 then
                          begin
                            { PATCH FOR ACE LOW }
                            if (Self.Cards[Loop].FValue = CV_ACE) then
                            begin
                              Result := CC_LESS;
                              ACombination.Description := TpoCard.CardValueToStrEx(ACombination.Cards[Loop].Value) + ' kicker';
                              if bBothKickers then
                                Self.Description := TpoCard.CardValueToStrEx(Self.Cards[Loop].Value) + ' kicker';
                            end
                            else
                            begin
                              Self.Description := TpoCard.CardValueToStrEx(Self.Cards[Loop].Value) + ' kicker';
                              if bBothKickers then
                                ACombination.Description := TpoCard.CardValueToStrEx(ACombination.Cards[Loop].Value) + ' kicker';
                            end;
                          end;
          CCK_ONE_PAIR  : if Loop>1 then
                          begin
                            Self.Description := TpoCard.CardValueToStrEx(Self.Cards[Loop].Value) + ' kicker';
                            if bBothKickers then
                              ACombination.Description := TpoCard.CardValueToStrEx(ACombination.Cards[Loop].Value) + ' kicker';
                          end;
          CCK_TWO_PAIR  : if Loop>3 then
                          begin
                            Self.Description := TpoCard.CardValueToStrEx(Self.Cards[Loop].Value) + ' kicker';
                            if bBothKickers then
                              ACombination.Description := TpoCard.CardValueToStrEx(ACombination.Cards[Loop].Value) + ' kicker';
                          end;
          CCK_3_OF_A_KIND: if Loop>2 then
                          begin
                            Self.Description := TpoCard.CardValueToStrEx(Self.Cards[Loop].Value) + ' kicker';
                            if bBothKickers then
                              ACombination.Description := TpoCard.CardValueToStrEx(ACombination.Cards[Loop].Value) + ' kicker';
                          end;
          CCK_FLUSH     : if Loop > 1 then
                          begin
                            Self.Description := TpoCard.CardValueToStrEx(Self.Cards[Loop].Value) + ' plays';
                            if bBothKickers then
                              ACombination.Description := TpoCard.CardValueToStrEx(ACombination.Cards[Loop].Value) + ' plays';
                          end;
        else
          Self.Description := '';
        end;
        Break;
      end
      else if Self.Cards[Loop].FValue < ACombination.Cards[Loop].FValue then
      begin
        Result := CC_LESS;
        case FKind of
          CCK_HIGH_CARD : if Loop>0 then
                          begin
                            { PATCH FOR ACE LOW }
                            if ACombination.Cards[Loop].FValue = CV_ACE then
                            begin
                              Result := CC_GREATER;
                              Self.Description := TpoCard.CardValueToStrEx(Self.Cards[Loop].Value) + ' kicker';
                              if bBothKickers then
                                ACombination.Description := TpoCard.CardValueToStrEx(ACombination.Cards[Loop].Value) + ' kicker';
                            end
                            else
                            begin
                              ACombination.Description := TpoCard.CardValueToStrEx(ACombination.Cards[Loop].Value) + ' kicker';
                              if bBothKickers then
                                Self.Description := TpoCard.CardValueToStrEx(Self.Cards[Loop].Value) + ' kicker';
                            end;

                          end;
          CCK_ONE_PAIR  : if Loop>1 then
                          begin
                            ACombination.Description := TpoCard.CardValueToStrEx(ACombination.Cards[Loop].Value) + ' kicker';
                            if bBothKickers then
                              Self.Description := TpoCard.CardValueToStrEx(Self.Cards[Loop].Value) + ' kicker';
                          end;
          CCK_TWO_PAIR  : if Loop>3 then
                          begin
                            ACombination.Description := TpoCard.CardValueToStrEx(ACombination.Cards[Loop].Value) + ' kicker';
                            if bBothKickers then
                              Self.Description := TpoCard.CardValueToStrEx(Self.Cards[Loop].Value) + ' kicker';
                          end;
          CCK_3_OF_A_KIND: if Loop>2 then
                           begin
                              ACombination.Description := TpoCard.CardValueToStrEx(ACombination.Cards[Loop].Value) + ' kicker';
                              if bBothKickers then
                                Self.Description := TpoCard.CardValueToStrEx(Self.Cards[Loop].Value) + ' kicker';
                           end;
          CCK_FLUSH     : if Loop > 1 then
                          begin
                            ACombination.Description := TpoCard.CardValueToStrEx(ACombination.Cards[Loop].Value) + ' plays';
                            if bBothKickers then
                              Self.Description := TpoCard.CardValueToStrEx(Self.Cards[Loop].Value) + ' plays';
                          end;
        else
          ACombination.Description := ''
        end;
        Break;
      end;
    end;

    if (not bCompareSuit) or (Result <> CC_EQUAL) then Exit;

    { combination are egual - compare by suit }
    for Loop := 0 to Self.Count-1 do
    begin
      if Loop >= ACombination.Count then Break;
      if Self.Cards[Loop].FSuit > ACombination.Cards[Loop].FSuit then
      begin
        Result := CC_GREATER;
        case FKind of
          CCK_HIGH_CARD : if Loop>1 then
                          begin
                            Self.Description := TpoCard.CardValueToStrEx(Self.Cards[Loop].Value) + ' kicker';
                            if bBothKickers then
                              ACombination.Description := TpoCard.CardValueToStrEx(ACombination.Cards[Loop].Value) + ' kicker';
                          end;
          CCK_ONE_PAIR  : if Loop>1 then
                          begin
                            Self.Description := TpoCard.CardValueToStrEx(Self.Cards[Loop].Value) + ' kicker';
                            if bBothKickers then
                              ACombination.Description := TpoCard.CardValueToStrEx(ACombination.Cards[Loop].Value) + ' kicker';
                          end;
          CCK_TWO_PAIR  : if Loop>3 then
                          begin
                            Self.Description := TpoCard.CardValueToStrEx(Self.Cards[Loop].Value) + ' kicker';
                            if bBothKickers then
                              ACombination.Description := TpoCard.CardValueToStrEx(ACombination.Cards[Loop].Value) + ' kicker';
                          end;
          CCK_3_OF_A_KIND: if Loop>2 then
                           begin
                              Self.Description := TpoCard.CardValueToStrEx(Self.Cards[Loop].Value) + ' kicker';
                              if bBothKickers then
                                ACombination.Description := TpoCard.CardValueToStrEx(ACombination.Cards[Loop].Value) + ' kicker';
                           end;
          CCK_FLUSH     : if Loop > 1 then
                          begin
                            Self.Description := TpoCard.CardValueToStrEx(Self.Cards[Loop].Value) + ' plays';
                            if bBothKickers then
                              ACombination.Description := TpoCard.CardValueToStrEx(ACombination.Cards[Loop].Value) + ' plays';
                          end;
        else
          Self.Description := '';
        end;
        Break;
      end
      else if Self.Cards[Loop].FSuit < ACombination.Cards[Loop].FSuit then
      begin
        Result := CC_LESS;
        case FKind of
          CCK_HIGH_CARD : if Loop>1 then
                          begin
                            ACombination.Description := TpoCard.CardValueToStrEx(ACombination.Cards[Loop].Value) + ' kicker';
                            if bBothKickers then
                              Self.Description := TpoCard.CardValueToStrEx(Self.Cards[Loop].Value) + ' kicker';
                          end;
          CCK_ONE_PAIR  : if Loop>1 then
                          begin
                            ACombination.Description := TpoCard.CardValueToStrEx(ACombination.Cards[Loop].Value) + ' kicker';
                            if bBothKickers then
                              Self.Description := TpoCard.CardValueToStrEx(Self.Cards[Loop].Value) + ' kicker';
                          end;
          CCK_TWO_PAIR  : if Loop>3 then
                          begin
                            ACombination.Description := TpoCard.CardValueToStrEx(ACombination.Cards[Loop].Value) + ' kicker';
                            if bBothKickers then
                              Self.Description := TpoCard.CardValueToStrEx(Self.Cards[Loop].Value) + ' kicker';
                          end;
          CCK_3_OF_A_KIND: if Loop>2 then
                            begin
                              ACombination.Description := TpoCard.CardValueToStrEx(ACombination.Cards[Loop].Value) + ' kicker';
                              if bBothKickers then
                                Self.Description := TpoCard.CardValueToStrEx(Self.Cards[Loop].Value) + ' kicker';
                            end;
          CCK_FLUSH     : if Loop > 1 then
                          begin
                            ACombination.Description := TpoCard.CardValueToStrEx(ACombination.Cards[Loop].Value) + ' plays';
                            if bBothKickers then
                              Self.Description := TpoCard.CardValueToStrEx(Self.Cards[Loop].Value) + ' plays';
                          end;
        else
          ACombination.Description := ''
        end;
        Break;
      end;
    end;


  end;
end;

constructor TpoCardCombination.Create(aOwner: TpoCardPack);
begin
  inherited Create(aOwner);
  Kind:= CCK_EMPTY;
  Version:= 2;
end;

function TpoCardCombination.Dump: String;
begin
  Result:= FormSeries(True)+' : '+ToString+' : '+Description;
end;


function TpoCardCombination.GetToString: String;

  function CardsPluralForm(aCard: TpoCard): String;
  begin
    if aCard.Value <> CV_6 then Result:= TpoCard.CardValueToStrEx(aCard.Value) + 's'
    else Result:= TpoCard.CardValueToStrEx(aCard.Value) + 'es';
  end;//CardsPluralForm

begin
  Result:= sCombinationToStringMap[Kind] + ', ';
  case Kind of
    CCK_HIGH_CARD   : Result := Result + TpoCard.CardValueToStrEx(Cards[0].Value) + ' high';
    CCK_ONE_PAIR    :
      begin
        Result := Result + CardsPluralForm(Cards[0]);
      end;//

    CCK_TWO_PAIR    :
      begin
        Result := Result + CardsPluralForm(Cards[0]) + ' and '
                                        + CardsPluralForm(Cards[2]);
      end;//if

    CCK_3_OF_A_KIND :
      begin
        Result := Result + CardsPluralForm(Cards[0]);
      end;//
    CCK_STRAIGHT    : Result := Result + TpoCard.CardValueToStrEx(Cards[Count-1].Value) + ' to ' + TpoCard.CardValueToStrEx(Cards[0].Value);

    CCK_FLUSH       : Result := Result + TpoCard.CardValueToStrEx(Cards[0].Value) + ' high';

    CCK_FULL_HOUSE  :
      begin
        Result := Result + CardsPluralForm(Cards[0]) + ' full of '
                                       + CardsPluralForm(Cards[3]);
      end;

    CCK_4_OF_A_KIND :
      begin
        Result := Result + CardsPluralForm(Cards[0]);
      end;//if

    CCK_STRAIGHT_FLUSH: Result := Result + TpoCard.CardValueToStrEx(Cards[0].Value) + ' high';
  end;
end;

function TpoCardCombination.IsLoCombination: Boolean;
begin
  Result:= (Kind IN [CCK_WHEEL, CCK_HIGH_CARD, CCK_STRAIGHT, CCK_FLUSH, CCK_STRAIGHT_FLUSH]) AND (Cards[0].Value <= CV_8);
end;

function TpoCardCombination.Load(aReader: TReader): Boolean;
var
  sStub: String;//
begin
  Result:= inherited Load(aReader);
  FKind:= TpoCardCombinationKind(aReader.ReadInteger);
  FUserID:= aReader.ReadInteger;
  FDescription:= aReader.Readstring;

  if FLoadedVersion >= 2 then begin
    sStub:= aReader.Readstring;
  end;//of
end;//TpoCardCombination.Load


procedure TpoCardCombination.SetDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TpoCardCombination.SetGamer(const Value: TpoGamer);
begin
  FGamer := Value;
end;

procedure TpoCardCombination.SetKind(const Value: TpoCardCombinationKind);
begin
  FKind := Value;
end;

procedure TpoCardCombination.SetUserID(const Value: Integer);
begin
  FUserID := Value;
end;

function TpoCardCombination.Store(aWriter: TWriter): Boolean;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteInteger(Integer(FKind));
  aWriter.WriteInteger(FUserID);
  aWriter.WriteString(FDescription);

  if Version >= 2 then begin //for compatibility
    aWriter.WriteString('');
  end;//if
end;

function TpoCardCombination.LoBetterOrEqual(
  ACombination: TpoCardCombination): Boolean;
begin
  Result:= (ACombination= nil) OR (ACombination.Kind = CCK_EMPTY) OR (CompareTo(ACombination) IN [CC_LESS, CC_EQUAL]);
end;

function TpoCardCombination.LoBetterThan(
  ACombination: TpoCardCombination): Boolean;
begin
  Result:= CompareTo(ACombination) = CC_LESS;
end;

destructor TpoCardCombination.Destroy;
begin
  Clear;
  inherited;
end;

function TpoCardCombination.Clone: TpoCardCombination;
begin
  Result:= TpoCardCombination.Create(FOwner);
  Result.AcquireCombination(Self);
end;

{ TpoCombinations }

function TpoCombinations.AddCombination(
  aCombination: TpoCardCombination): TpoCardCombination;
begin
  Result:= aCombination;//TpoCardCombination.Create(FCards);
  Add(Result);
end;//TpoCombinations.AddCombination


function TpoCombinations.BestCombination(bHiCombination: Boolean; bCompareSuit: Boolean): TpoCardCombination;
begin
  Sort(bCompareSuit);
  if bHiCombination then Result:= Combinations[0]
  else Result:= Combinations[Count-1];
  if (NOT bHiCombination) AND (NOT Result.IsLoCombination) then Result:= nil;
end;

procedure TpoCombinations.ClearAndFree;
var
  I: Integer;
begin
  for I:= 0 to Count-1 do begin
    Items[I].Free;
    Items[I]:= nil;
  end;//for
  Clear;
end;

constructor TpoCombinations.Create(aOwner: TpoCardPack);
begin
  inherited Create( False );
  FCards:= aOwner;
end;


destructor TpoCombinations.Destroy;
begin
  inherited;
end;

function TpoCombinations.Dump: String;
var
  I: Integer;
begin
  Result:= '';
  for I:= 0 to Count-1 do begin
    Result:= Result+ Combinations[I].Dump()+#$D#$A;
  end;//for
end;

function TpoCombinations.GetCombinations(
  Index: Integer): TpoCardCombination;
begin
  Result:= Items[Index] as TpoCardCombination;
end;


function TpoCombinations.Load(aReader: TReader): Boolean;
var
  I, cnt: Integer;
begin
  cnt:= aReader.ReadInteger;
  for I:= 0 to cnt-1 do begin
    AddCombination(TpoCardCombination.Create(FCards)).Load(aReader);
  end;//for
  Result:= True;
end;//TpoCombinations.Load


procedure TpoCombinations.SelectWinnerCombinations(
  bUseHiCombinations: Boolean;
  b8OrBetter: Boolean
);
var
  TheBest : TpoCardCombination;
  Loop    : Integer;

  procedure FilterLoHand;
  var
    Loop  : Integer;
    n     : Integer;
  begin
    n := 0;
    for Loop := 0 to Self.Count-1 do
    begin
      if (Self.Combinations[n].Kind in [CCK_ONE_PAIR, CCK_TWO_PAIR, CCK_3_OF_A_KIND, CCK_4_OF_A_KIND, CCK_ROYAL_FLUSH])
        or ( Self.Combinations[n].HighCard(False, True).Value >= CV_9 ) then
      begin
        Self.Delete(n);
      end
      else
        Inc(n);
    end;
  end;

begin

    Self.Sort;
    if bUseHiCombinations then
    begin
      { Detecting Hi Hand }
      TheBest := Self.Combinations[0];
      TheBest.Description := '';
      for Loop := Self.Count-1 downto 1 do begin
        if TheBest.Kind > Self.Combinations[Loop].Kind then begin
          Self.Delete(Loop)
        end else begin
          Self.Combinations[Loop].Description := '';
          if TheBest.CompareTo(Self.Combinations[Loop]) = CC_GREATER then begin
            Self.Delete(Loop);
          end;//if
        end;
      end;
    end
    else
    begin
      { detecting Lo Hand }
      FilterLoHand;
      if Self.Count = 0 then
      begin
        { no Lo Hand }
        Exit;
      end;

      TheBest := Self.Combinations[Self.Count-1];
      TheBest.Description := '';
      for Loop := Self.Count-2 downto 0 do begin
        Self.Combinations[Loop].Description := '';
        if TheBest.Kind < Self.Combinations[Loop].Kind then begin
          Self.Delete(Loop)
        end else begin
          if TheBest.CompareTo(Self.Combinations[Loop]) = CC_LESS then
          begin
            { remove combination }
            Self.Delete(Loop);
          end;
        end;
      end;
    end;
end;

procedure TpoCombinations.Sort(bCompareSuit: Boolean = GLM_COMPARE_SUIT;
    bBothKickers: Boolean = FALSE);
var
  i,j : Integer;
begin
  {sort combinations using bubble sort }
  for i:=0 to (Self.Count-2) do
  begin
    for j:=0 to (Self.Count-2) do
    begin
      if ( Combinations[j+1].CompareTo(Combinations[j], bCompareSuit, bBothKickers) = CC_GREATER ) then
        Self.Exchange(j+1, j);
    end;
  end;
end;

function TpoCombinations.Store(aWriter: TWriter): Boolean;
var
  I: Integer;
begin
  aWriter.WriteInteger(Count);
  try
    for I:= 0 to Count-1 do begin
      Combinations[I].Store(aWriter);
    end;//for
  except
  end;//try
  Result:= True;
end;//TpoCombinations.Store


{ TpoChairs }

function TpoChairs.ClearGamerReservations(nUserID: Integer): Integer;
var
  I: Integer;
begin
  Result:= 0;
  if nUserID = UNDEFINED_USER_ID then Exit;
  for I:= 0 to Count-1 do begin
    if Chairs[I].ReservationUserID = nUserID then begin
      Chairs[I].ClearReservation;
    end;//if
  end;//for
end;//TpoChairs.ClearGamerReservations

constructor TpoChairs.Create;
begin
  inherited Create;
  FChairs:= TobjectList.Create;
  
  FChairs.OwnsObjects := TRUE;
end;

destructor TpoChairs.Destroy;
begin
  FChairs.Clear;
  FChairs.Free;
  inherited;
end;

procedure TpoChairs.FixElementRefs;
begin
//TBD:
end;

function TpoChairs.GetFreeChairsCount: Integer;
var
  I: Integer;
begin
  Result:= 0;
  for I:= 0 to Count-1 do begin
    if Chairs[I].State = CS_EMPTY then Inc(Result);
  end;//
end;//TpoChairs.FreeChairsCount


function TpoChairs.GetBusyChairs: Integer;
var
  I: Integer;
begin
  Result:= 0;
  for I:= 0 to Count-1 do begin
    if Chairs[I].State = CS_BUSY then Inc(Result);
  end;//if
end;

function TpoChairs.GetChairs(Index: Integer): TpoChair;
begin
  Result:= FChairs[Index] as TpoChair;
end;

function TpoChairs.GetCount: Integer;
begin
  Result:= FChairs.Count;
end;


function TpoChairs.GetDealerChairID: Integer;
begin
  Result:= FTable.Hand.DealerChairID;
end;

function TpoChairs.GetFirstFreeChair: TpoChair;
var
  I: Integer;
begin
  Result:= nil;
  for I:= 0 to Count-1 do begin
    if Chairs[I].State = CS_EMPTY then begin
      Result:= Chairs[I];
      Exit;
    end;//if
  end;//for
end;


procedure TpoChairs.HideAllInChairs(nAllInThreshold: Integer; sMessage: String);
var
  I: Integer;
  nWinnerCandidates: Integer;
  aChair: TpoChair;
  aGamer: TpoGamer;

  function CalcWinnerCandidatesCnt(): Integer;
  var
    I: Integer;
  begin
    Result:= 0;
    for I:= 0 to Count-1 do begin
      if (Chairs[I].Gamer = nil) then Continue;
      if Chairs[I].Gamer.State <> GS_ALL_IN then Inc(Result);
    end;//if
  end;//

begin
  nWinnerCandidates:= CalcWinnerCandidatesCnt();

  for I:= 0 to Count-1 do begin
    aChair := Chairs[I];
    aGamer := aChair.Gamer;
    if aChair.Hidden then Continue;
    if aGamer = nil then Continue;
    if (aGamer.Account.Balance < nAllInThreshold) OR (aGamer.Account.Balance <= 0) then begin
      aGamer.State := GS_ALL_IN;

//bot post on all in
      PostRandomAnswerOnCategory(aGamer, BCP_GOES_ALL_IN);
    end;//if
    if (aGamer.State = GS_ALL_IN) or (aGamer.KickOffFromTournament) then begin
      aChair.Hidden:= True;
      aGamer.FinishedTournament := True;
      if Assigned(FTable.FCroupier.OnChairStateChange) then
        FTable.FCroupier.OnChairStateChange(aGamer, I);
      if sMessage <> '' then begin
        FTable.FCroupier.SendMessage(
          Format(
            sMessage, [Chairs[I].Gamer.UserName, PlaceToStr(nWinnerCandidates)]
          )
        );
        Dec(nWinnerCandidates);
      end;//if
    end;//if
  end;//for
end;

procedure TpoChairs.KickOffAllGamers(bSuppressNotification: Boolean);
var
  I: Integer;
begin
  for I:= 0 to Count-1 do begin
    Chairs[I].KickOffGamer(bSuppressNotification);
  end;//for
end;

function TpoChairs.Load(aReader: TReader): Boolean;
var
  I, cnt: Integer;
  ch: TpoChair;
begin
  FChairs.Clear;
  Result:= inherited Load(aReader);
  cnt:= aReader.ReadInteger;
  for I := 0 to cnt-1 do begin
    ch:= TpoChair.Create;
    ch.FChairs:= Self;
    ch.Load(aReader);
    FChairs.Add(ch);
  end;//for
end;

procedure TpoChairs.SetCount(const Value: Integer);
var
  c: TpoChair;
begin
  if NOT Value IN [2..10] then begin
    EscalateFailure(
      EpoException,
      'Chairs number is out of bounds',
      '{20CC7AD8-4283-4A16-9FF3-6AA3A689F277}'
    );
  end;//if

  if Value > Count then begin
    while Value > Count do begin
      c:= TpoChair.Create;
      c.FChairs:= Self;
      FChairs.Add(c);
    end;//while
  end else if (Value < Count) AND (Count > 0) then begin
    while Value < Count do begin
      if Chairs[FChairs.Count-1].State <> CS_EMPTY then begin
        EscalateFailure(
          EpoException,
          'Cannot remove chair with the gamer',
          '{58558272-F5CA-4A31-872B-33A0F4052347}'
        );
      end;//if
      FChairs.Delete(FChairs.Count-1);
    end;//while
  end;//if
end;


function TpoChairs.Store(aWriter: TWriter): Boolean;
var
  I: Integer;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteInteger(Count);
  for I:=  0 to Count-1 do begin
    Chairs[I].Store(aWriter);
  end;//for
end;

function TpoChairs.GetReservedChairByUserID(nUserID: Integer): TpoChair;
var
  I: Integer;
  aChair: TpoChair;
begin
  Result := nil;
  for I:=0 to Count-1 do begin
    aChair := Chairs[I];
    if (aChair.ReservationUserID = nUserID) then begin
      Result := aChair;
      Exit;
    end;
  end;
end;

function TpoChairs.GetWithGamerChairsCount: Integer;
var
  I: Integer;
begin
  Result:= 0;
  for I:= 0 to Count-1 do begin
    if Chairs[I].Gamer <> nil then Inc(Result);
  end;//if
end;

{ TpoHand }

constructor TpoHand.Create(aTable: TpoTable);
begin
  inherited Create;

  Version:= 5;

  FTable:= aTable;
  FPot:= TpoPot.Create(Self, FTable.Rakes);

  FCardDeck:= TpoCardPack.Create;

  FCardsToDeal:= TpoCardCollection.Create(FCardDeck);
  FDroppedCards:= TpoCardCollection.Create(FCardDeck);
  FCommunityCards:= TpoCardCollection.Create(FCardDeck);

  FRoundID    := UNDEFINED_ROUND_ID;
  FHandID     := UNDEFINED_HAND_ID;
  FPrevHandID := UNDEFINED_HAND_ID;

  FActiveChairID              := UNDEFINED_POSITION_ID;
  FPrevDealerChairID          := UNDEFINED_POSITION_ID;
  FDealerChairID              := UNDEFINED_POSITION_ID;
  FHandStartingChairID        := UNDEFINED_POSITION_ID;
  FRoundOpenChairID           := UNDEFINED_POSITION_ID;

  FLastBettingRoundOpenChair  := UNDEFINED_POSITION_ID;
  FLastBettingRoundBetChair   := UNDEFINED_POSITION_ID;
  FLastBettingRoundRaiseChair := UNDEFINED_POSITION_ID;

  FSmallBlindChairID := UNDEFINED_POSITION_ID;
  FBigBlindChairID   := UNDEFINED_POSITION_ID;

  FBestHiCombination:= TpoCardCombination.Create(FCardDeck);
  FBestLoCombination:= TpoCardCombination.Create(FCardDeck);
end;//TpoHand.Create

destructor TpoHand.destroy;
begin
  FBestLoCombination.Free;
  FBestHiCombination.Free;
  FCommunityCards.Free;
  FDroppedCards.Free;
  FCardsToDeal.Free;
  FCardDeck.Free;
  FPot.Free;
  inherited;
end;

function TpoHand.Finish: Boolean;
begin
  Result:= True;

  FPot.CleanupSettleAccounts;
  FTable.FSourcePot := FPot.TotalAmount;
//
  Reset;

//clear gamer list
  FTable.OnHandFinishNotify(Self);

  FActiveChairID := UNDEFINED_USER_ID;
  FRoundID  := UNDEFINED_ROUND_ID;
  State:= HST_FINISHED;
  FPrevDealerChairID:= FDealerChairID;
end;


procedure TpoHand.FixElementRefs;
begin
//TBD:
//restore refs on table, pot etc.
end;

function TpoHand.PreparePlayingGamers: Boolean;
var
  I: Integer;
  aGamer: TpoGamer;
begin
//register active gamer inside pot for settlement operations
  for I:= 0 to FTable.Chairs.Count-1 do begin
    aGamer := FTable.Chairs[I].Gamer;
    if aGamer = nil then Continue;

    if FTable.FCroupier.ChairIsReadyToPlay(FTable.Chairs[I])
//       and ((aGamer.State = GS_PLAYING) or (aGamer.IsSitOut and SitOutCan
    then begin
      CommonDataModule.Log(ClassName, 'PreparePlayingGamers',
        'Registering gamer with pot (userid: '+IntToStr(FTable.Chairs[I].Gamer.UserID)+')'
        , ltCall);
      FPot.RegisterGamerForSettlement(FTable.Chairs[I].Gamer);
    end else begin
      CommonDataModule.Log(ClassName, 'PreparePlayingGamers',
        'Gamer is not ready for hand(userid: '+IntToStr(FTable.Chairs[I].Gamer.UserID)+')' +
        '; State: '+FTable.Chairs[I].StateAsString, ltCall);
    end;//if
  end;//for

//define dealer
  Result:= True;
end;//HandleGamers


function TpoHand.Load(aReader: TReader): Boolean;
begin
  Result:= inherited Load(aReader);
  FPrevHandID:= aReader.ReadInteger;
  FHandID:= aReader.ReadInteger;
  FState:= TpoHandState(aReader.ReadInteger);
  FRoundID:= aReader.ReadInteger;

  FPrevActiveChairID:= aReader.ReadInteger;
  FActiveChairID:= aReader.ReadInteger;

  FPrevDealerChairID:= aReader.ReadInteger;
  FDealerChairID:= aReader.ReadInteger;

  //key gamers
  FSmallBlindChairID   := aReader.ReadInteger;
  FBigBlindChairID     := aReader.ReadInteger;
  FHandStartingChairID:= aReader.ReadInteger;
  FRoundOpenChairID   := aReader.ReadInteger;

  //last betting round gamers
  FLastBettingRoundOpenChair := aReader.ReadInteger;
  FLastBettingRoundBetChair  := aReader.ReadInteger;
  FLastBettingRoundRaiseChair:= aReader.ReadInteger;

//
  FUseLoBetting := aReader.ReadBoolean;
  FHiBettingCanBeUsed   := aReader.ReadBoolean;
  FHandActionSeqID:= aReader.ReadInteger;

//ver=1
  FPlayersCntAtStartOfHand:=  aReader.ReadInteger;

  FCardDeck.Load(aReader);
  FCardsToDeal.Load(aReader);
  FDroppedCards.Load(aReader);
  FCommunityCards.Load(aReader);
  FPot.Load(aReader);

  FBestHiCombination.Load(aReader);
  FBestLoCombination.Load(aReader);

//ver=2
  FRaisesInRound:= aReader.ReadInteger;
  FLastRaiseAmount:= aReader.ReadInteger;
  FNoFlopNoDropRuleActive:= aReader.ReadBoolean;
  FPlayersCntAtFlop:=  aReader.ReadInteger;
  FShuffleSeed:= aReader.ReadInteger;
end;

function TpoHand.RegisterGamerForHand(aGamer: TpoGamer): Boolean;
begin
  Result:= False;
//TBD:
//0. Check balance
//1. Add corresponding account to pot
end;

function TpoHand.Reset: Boolean;
begin
  FBestHiCombination.Clear;
  FBestLoCombination.Clear;

  FPot.Reset;
  ResetCardDeck();

  FSmallBlindChairID          := UNDEFINED_POSITION_ID;
  FBigBlindChairID            := UNDEFINED_POSITION_ID;
  RoundOpenChairID            := UNDEFINED_POSITION_ID;
  FHandStartingChairID        := UNDEFINED_POSITION_ID;

  FActiveChairID              := UNDEFINED_POSITION_ID;
  FHandStartingChairID        := UNDEFINED_POSITION_ID;
  FRoundOpenChairID           := UNDEFINED_POSITION_ID;

  FLastBettingRoundOpenChair  := UNDEFINED_POSITION_ID;
  FLastBettingRoundBetChair   := UNDEFINED_POSITION_ID;
  FLastBettingRoundRaiseChair := UNDEFINED_POSITION_ID;

  FUseLoBetting               := False;
  FHiBettingCanBeUsed         := False;
  FHandActionSeqID            := 0;
//
  FRoundID                    := UNDEFINED_ROUND_ID;
  FNoFlopNoDropRuleActive     := False;
  FPlayersCntAtStartOfHand    := 0;
  FPlayersCntAtFlop           := 0;

  Result:= True;
end;

procedure TpoHand.SetState(Value: TpoHandState);
begin
  FState := Value;
end;

procedure TpoHand.SetHandID(const Value: Integer);
begin
  FPrevHandID:= FHandID;
  FHandID := Value;
end;

function TpoHand.Start(nHandID: Integer): Boolean;
begin
  Reset();
  Result:= False;
  HandID:= nHandID;
  RoundID:= UNDEFINED_ROUND_ID;

//prepare gamers
  FTable.OnNewHandNotify(Self);
  PreparePlayingGamers;
//ready to go
  State:= HST_RUNNING;
  //update stats
//  Inc(FTable.FPlayedHands);
end;

function TpoHand.Store(aWriter: TWriter): Boolean;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteInteger(FPrevHandID);
  aWriter.WriteInteger(FHandID    );
  aWriter.WriteInteger(Integer(FState));
  aWriter.WriteInteger(FRoundID);

  aWriter.WriteInteger(FPrevActiveChairID);
  aWriter.WriteInteger(FActiveChairID);

  aWriter.WriteInteger(FPrevDealerChairID);
  aWriter.WriteInteger(FDealerChairID);

  //round level state
  aWriter.WriteInteger(FSmallBlindChairID);
  aWriter.WriteInteger(FBigBlindChairID  );
  aWriter.WriteInteger(FHandStartingChairID);
  aWriter.WriteInteger(FRoundOpenChairID);

  //last betting round gamers
  aWriter.WriteInteger(FLastBettingRoundOpenChair);
  aWriter.WriteInteger(FLastBettingRoundBetChair);
  aWriter.WriteInteger(FLastBettingRoundRaiseChair);

  //
  aWriter.WriteBoolean(FUseLoBetting);
  aWriter.WriteBoolean(FHiBettingCanBeUsed);
  aWriter.WriteInteger(FHandActionSeqID);

//ver=1
  aWriter.WriteInteger(FPlayersCntAtStartOfHand);

//aggregates
  FCardDeck.Store(aWriter);
  FCardsToDeal.Store(aWriter);
  FDroppedCards.Store(aWriter);
  FCommunityCards.Store(aWriter);
  FPot.Store(aWriter);

  FBestHiCombination.Store(aWriter);
  FBestLoCombination.Store(aWriter);

//upgrade
  aWriter.WriteInteger(FRaisesInRound);
  aWriter.WriteInteger(FLastRaiseAmount);
  aWriter.WriteBoolean(FNoFlopNoDropRuleActive);

  aWriter.WriteInteger(FPlayersCntAtFlop);
  aWriter.WriteInteger(FShuffleSeed);
end;//TpoHand.Store


procedure TpoHand.SetRoundID(const Value: Integer);
begin
  FRoundID := Value;
end;

var
  nHandStateToStringMap: Array[TpoHandState] of String = (
    'idle',     //HST_IDLE,
    'starting', //HST_STARTING,
    'running',  //HST_RUNNING
    'finished',  //HST_FINISHED
    'tournament init'
  );

function TpoHand.GetStateAsString: String;
begin
  Result:= nHandStateToStringMap[State];
end;

function TpoHand.GetBetForGamer(aGamer: TpoGamer): Integer;
begin
  Result:= 0;
  //TBD:
end;

function TpoHand.GetCurrentStakeValue: Integer;
begin
  Result:= 0;
end;


procedure TpoHand.SetDealerChairID(const Value: Integer);
begin
  if FDealerChairID <> UNDEFINED_POSITION_ID then FPrevDealerChairID:= FDealerChairID;
  FDealerChairID := Value;
end;

procedure TpoHand.SetActiveChairID(const Value: Integer);
begin
  if Value = FActiveChairID then Exit;
  FPrevActiveChairID:= FActiveChairID;
  FActiveChairID := Value;
end;

function TpoHand.GetDealerGamer: TpoGamer;
begin
  Result:= nil;
  if FDealerChairID <> UNDEFINED_POSITION_ID then begin
    Result:= FTAble.Chairs[FDealerChairID].Gamer;
  end;//
end;

procedure TpoHand.NewRound;
var
  I: Integer;
  aGamer: TpoGamer;
begin
  RoundOpenChairID:= UNDEFINED_POSITION_ID;
  ActiveChairID:= UNDEFINED_POSITION_ID;
  FPrevActiveChairID:= UNDEFINED_POSITION_ID;
  RoundID:= RoundID+1;
  if (RoundID <> 1) OR (FTable.FCroupier.PokerClass = PTC_CLOSED_CARDS_POKER) then begin
    Pot.NewRound();
  end;//if
  FTable.OnNewRoundNotify(Self);
  if RoundID > 1 then begin
    FRaisesInRound:= 0;
    FLastRaiseAmount:= 0;
  end;//if

  { Clear count of rases for bots }
  for I:=0 to FTable.Chairs.Count - 1 do begin
    aGamer := FTable.Chairs[I].Gamer;
    if (aGamer = nil) then Continue;
    aGamer.CountOfRases := 0;
  end;
end;

procedure TpoHand.SetRoundOpenChairID(const Value: Integer);
begin
  FRoundOpenChairID := Value;
end;

function TpoHand.GetPrevGamerInRound: TpoGamer;
begin
  Result:= nil;
  if FPrevActiveChairID <> UNDEFINED_POSITION_ID then begin
    Result:= FTable.Chairs[FPrevActiveChairID].Gamer;
  end;//if
end;

function TpoHand.GetOpenRoundGamer: TpoGamer;
begin
  Result:= nil;
  if FRoundOpenChairID <> UNDEFINED_POSITION_ID then Result:= FTable.Chairs[FRoundOpenChairID].Gamer;
end;

function TpoHand.GetSmallBlindGamer: TpoGamer;
begin
  Result:= nil;
  if FSmallBlindChairID <> UNDEFINED_POSITION_ID then Result:= FTable.Chairs[FSmallBlindChairID].Gamer;
end;

function TpoHand.GetBigBlindGamer: TpoGamer;
begin
  Result:= nil;
  if FBigBlindChairID <> UNDEFINED_POSITION_ID then Result:= FTable.Chairs[FBigBlindChairID].Gamer;
end;

function TpoHand.GetActiveGamer: TpoGamer;
begin
  Result:= nil;
  if (FActiveChairID <> UNDEFINED_POSITION_ID) then Result:= FTable.Chairs[FActiveChairID].Gamer;
end;

procedure TpoHand.SetActiveGamer(const Value: TpoGamer);
begin
  if Value = ActiveGamer then Exit;
  if Value <> nil then begin
    FPrevActiveChairID:= FActiveChairID;
    FActiveChairID:= Value.ChairID;
  end else begin
    FActiveChairID:= UNDEFINED_POSITION_ID;
  end;//if
end;

procedure TpoHand.SetSmallBlindGamer(const Value: TpoGamer);
begin
  FSmallBlindChairID:= Value.ChairID;
end;

procedure TpoHand.SetOpenRoundGamer(const Value: TpoGamer);
begin
  if Value <> nil then FRoundOpenChairID:= Value.ChairID
  else FRoundOpenChairID:= UNDEFINED_POSITION_ID;
end;


procedure TpoHand.ResetCardDeck;
begin
  FCardDeck.AllocatePack();
  FCardsToDeal.Clear;
  FCardsToDeal.AcqureCardsFrom(FCardDeck);
  FShuffleSeed:= System.RandSeed;
  FCardsToDeal.Shuffle;
  FDroppedCards.Clear;
  FCommunityCards.Clear;
end;

function TpoHand.Dump: String;
begin
  Result:=
  '-- [ Hand: ] ----------------------------------------------------------------'+LF+
  '#: '+IntToStr(HandID)+'  RoundID: '+IntToStr(RoundID)+'  Seed: '+IntToStr(FShuffleSeed)+LF+LF+
  Pot.Dump()+LF;
end;


procedure TpoHand.IncHandAction;
begin
  Inc(FHandActionSeqID);
end;

procedure TpoHand.SetPlayersCntAtStartOfHand(const Value: Integer);
begin
  FPlayersCntAtStartOfHand := Value;
end;


procedure TpoHand.RegisterRaise(nAmount: Integer);
begin
  Inc(FRaisesInRound);
  FLastRaiseAmount:= nAmount;
end;

procedure TpoHand.SetNoFlopNoDropRuleActive(const Value: Boolean);
begin
  FNoFlopNoDropRuleActive := Value;
end;

procedure TpoHand.SetPlayersCntAtFlop(const Value: Integer);
begin
  FPlayersCntAtFlop := Value;
end;

procedure TpoHand.SetShuffleSeed(const Value: LongInt);
begin
  FShuffleSeed := Value;
end;

{ TpoAccount }

procedure TpoAccount.AddFunds(nAmount: Integer);
begin
  FDebitBalance:= FDebitBalance + nAmount;
end;

procedure TpoAccount.AssignBalance(nAmount: Integer);
begin
  FCreditBalance:= 0;
  FDebitBalance:= nAmount;
end;

procedure TpoAccount.ChargeFunds(nAmount: Integer);
begin
  if (FAccountType = AT_DEBIT) AND ((Balance - nAmount) < 0) then begin
    EscalateFailure(
      EpoException,
      'Debit balance cannot be negative',
      '{C74E92B9-4CE4-4C58-B88E-E1FA881FD313}'
    );
  end;//if

  FCreditBalance:= FCreditBalance + nAmount;
end;

procedure TpoAccount.Clear;
begin
  FDebitBalance:= 0;
  FCreditBalance:= 0;
end;

constructor TpoAccount.Create(
  sName: String;
  nType: TpoAccountType;
  nCurrency: TpoAccountCurrency
  );
begin
  inherited Create;
  FName:= sName;
  FAccountType:= nType;
  FAccountCurrency:= nCurrency;
end;


function TpoAccount.Dump: String;
begin
  Result:= 'Account: '+Name+ ' balance: '+FloatToStr(Balance);
end;

function TpoAccount.GetBalance: Integer;
begin
  Result:= FDebitBalance - FCreditBalance
end;

function TpoAccount.GetIndexOf: Integer;
begin
  Result:= FAccounts.FAccounts.IndexOf(Self);
end;

function TpoAccount.GetName: String;
begin
  Result:= FName;
end;

function TpoAccount.IsBalanced: Boolean;
begin
  Result:= Balance = 0;
end;

function TpoAccount.Load(aReader: TReader): Boolean;
begin
  Result:= inherited Load(aReader);
  FAccountCurrency:= TpoAccountCurrency(aReader.ReadInteger);
  FAccountType:= TpoAccountType(aReader.ReadInteger);
  FName:= aReader.ReadString;
  FDebitBalance := aReader.ReadInteger;
  FCreditBalance:= aReader.ReadInteger;
end;

procedure TpoAccount.SetAccountCurrency(const Value: TpoAccountCurrency);
begin
  FAccountCurrency := Value;
end;


function TpoAccount.Store(aWriter: TWriter): Boolean;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteInteger(Integer(FAccountCurrency));
  aWriter.WriteInteger(Integer(FAccountType));
  aWriter.WriteString(FName);
  aWriter.WriteInteger(FDebitBalance);
  aWriter.WriteInteger(FCreditBalance);
end;

{ TpoAccounts }

function TpoAccounts.AccountByName(sName: String): TpoAccount;
var
  I: Integer;
begin
  Result:= nil;
  for I:= 0 to Count-1 do begin
    if Accounts[I].Name = sName then begin
      Result:= Accounts[I];
      Exit;
    end;//if
  end;//for
end;

function TpoAccounts.AddAccount(aAccount: TpoAccount): TpoAccount;
begin
  Result:= aAccount;
  if AccountByName(Result.Name) <> nil then
    EscalateFailure(
      EpoException,
      'Account with the name '+Result.Name+' already exists',
      '{24AE2F13-8B9C-4AFF-AB15-41527C2D2A64}'
    );
  Result.FAccounts:= Self;
  FAccounts.Add(Result);
end;//TpoAccounts.AddAccount


function TpoAccounts.AllAreBalanced: Boolean;
var
  I: Integer;
begin
  Result:= True;
  for I:= 0 to Count-1 do begin
    Result:= Result AND (Accounts[I].Balance = 0);
    if not Result then Exit; 
  end;//for
end;//TpoAccounts.AllAreBalanced

procedure TpoAccounts.Clear;
begin
  FAccounts.Clear;
end;

constructor TpoAccounts.Create;
begin
  inherited Create;
  FAccounts:= TObjectList.Create;
  
  FAccounts.OwnsObjects := TRUE;
end;

destructor TpoAccounts.Destroy;
begin
  FAccounts.Clear;
  FAccounts.Free;
  inherited;
end;

function TpoAccounts.Dump: String;
var
  I: Integer;
begin
  Result:= 'Accounts:'+LF;
  for I:= 0 to Count-1 do begin
    Result:= Result+Accounts[I].Dump()+LF;
  end;//for
end;

procedure TpoAccounts.FixElementRefs;
begin
//TBD:
end;

function TpoAccounts.GetAccountClass: TpoAccountClass;
begin
  Result:= TpoAccount;
end;

function TpoAccounts.GetAccounts(Index: Integer): TpoAccount;
begin
  Result:= FAccounts[Index] as TpoAccount;
end;

function TpoAccounts.GetCount: Integer;
begin
  Result:= FAccounts.Count;
end;

function TpoAccounts.Load(aReader: TReader): Boolean;
var
  I, cnt: Integer;
  acc: TpoAccount;
begin
  FAccounts.Clear;
  Result:= inherited Load(aReader);
  cnt:= aReader.ReadInteger;
  for  I:= 0 to cnt-1  do begin
    acc:= GetaccountClass.Create(
      '', AT_DEBIT, AC_DEFAULT //simply stubs
    );
    acc.Load(aReader);
    AddAccount(acc);
  end;//for
end;

function TpoAccounts.Store(aWriter: TWriter): Boolean;
var
  I: Integer;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteInteger(Count);
  for  I:= 0 to Count-1  do begin
    Accounts[I].Store(aWriter);
  end;//for
end;

function TpoAccounts.TotalBalance: Integer;
var
  I: Integer;
begin
  Result:= 0;
  for I:= 0 to Count-1 do begin
    Result:= Result+Accounts[I].Balance;
  end;//for
end;

{ TpoPot }

function TpoPot.BetsAreBalanced(bSkipAllIn: Boolean): Boolean;
var
  I: Integer;
  acc: TpoUserSettlementAccount;
  nMaxBalance: Integer;
  ch: TpoChair;
begin
  nMaxBalance:= Bets.GetMaxBalance;
  if nMaxBalance = 0 then begin
    Result:= True;
    Exit;
  end;//
  Result:= True;
  for I:= 0 to FHand.FTable.Chairs.Count-1 do begin
    ch:= FHand.FTable.Chairs[I];
    if ch.Gamer = nil then Continue;
    if ch.Gamer.FinishedTournament then Continue;
    if ch.Gamer.PassCurrentHand then Continue;
    if (ch.IsPlaying) OR (ch.IsSitOut AND (FHAnd.FTable.FCroupier.SitOutCanTakeStepRight)) then begin
      if (NOT FHand.FTable.Chairs[I].IsAllIn) OR (NOT bSkipAllIn) then begin
        acc:= Bets.GetAccountByUserID(FHand.FTable.Chairs[I].UserID);
        if acc = nil then begin
(*
          CommonDataModule.Log(ClassName, 'BetsAreBalanced',
            'Gamer bet account not found; Chairs N:' + IntToStr(I) +
            '; UserID=' + IntToStr(FHand.FTable.Chairs[I].UserID),
            lterror);
          Continue;
*)
          EscalateFailure(
            EpoException,
            'Gamer bet account not found; Chairs N:' + IntToStr(I) + '; UserID=' + IntToStr(FHand.FTable.Chairs[I].UserID),
            '{B3D8C9EF-D636-44F1-B7E9-78025FCC696D}'
          );

        end;//if
        if acc.State = AS_FOLDED then Continue;
        Result:= Result AND (acc.Balance = nMaxBalance);
      end else Continue;
    end else Continue;
    if NOT Result then Exit;
  end;//for
end;

procedure TpoPot.ChargeRakes;
begin
//TBD: Adjust rakes handling algorithm for multipart pots
end;

procedure TpoPot.CleanupSettleAccounts;
var
  I: Integer;
  g: TpoGamer;
begin
  if CasinoSettleAccount.Balance > 0 then begin
  //register operation
    if Assigned(FHand.FTable.FCroupier.OnHandReconcileOperation) then begin
      FHand.FTable.FCroupier.OnHandReconcileOperation(
        FHand.HandID, nil, '', CasinoSettleAccount.Balance, 'casino reconcile'
      );
    end;//if
  //reconcile
    MoveMoney(
      CasinoSettleAccount,
      FHand.FTable.CasinoAccount,
      CasinoSettleAccount.Balance,
      TC_SETTLEMENT_DEFAULT
    );
  end;//if

  for I:= 0 to Bets.Count-1 do begin
    g:= FHand.FTable.Gamers.GamerByUserID((Bets[I] as TpoUserAccount).UserID);
    if Bets[I].Balance = 0 then begin //handle loser
    //go next bet account
    end else begin //handle winner
      if g = nil then begin
        EscalateFailure(
          EpoException,
          'Gamer not found - don''t know where to move money.',
          '{CAE0F49F-A747-4417-B298-46CCA2DB1B57}'
        );
      end;//if
    //perform operation
      MoveMoney(
        Bets[I], g.Account, Bets[I].Balance, TC_SETTLEMENT_DEFAULT
      );
    end;//if
  end;//for
end;


constructor TpoPot.Create(
  aHand: TpoHand; aRakes: TpoRakes
);
begin
  inherited Create;
  FHand:= aHand;
  FTransactions:= TpoTransactions.Create;
  FUserSettleAccounts:= TpoUserSettlementAccounts.Create;

  FCasinoSettleAccount:= TpoAccount.Create(
    ACC_CASINO_PREFIX,
    CASINO_POT_ACCOUNT_TYPE,
    AC_DEFAULT
  );

  FSidePots:= TpoPotSettlementAccounts.Create;
  FSidePots.FPot:= Self;
  FRakes:= aRakes;
end;

destructor TpoPot.Destroy;
begin
  FSidePots.Free;
  FCasinoSettleAccount.Free;
  FUserSettleAccounts.Free;
  FTransactions.Free;
  inherited;
end;


function TpoPot.Dump: String;
begin
  Result:=
  '--[ Pot: ] ------------------------------------------------------------------'+LF+
  '> Bets:'+LF+
  Bets.Dump()     +LF+
  '> Side Pots: ' +LF+
  SidePots.Dump() +LF;
end;

procedure TpoPot.FixElementRefs;
begin
//TBD:
end;

function TpoPot.FoldGamerAccounts(nUserID: Integer): Boolean;
var
//  I, J: Integer;
  I: Integer;
  acc: TpoUserPotSubAccount;
begin
  Result:= False;
//mark bets as folded
  Bets.FoldGamerAccount(nUserID);

//mark subpots
  for I:= 0 to SidePots.Count-1 do begin
//    for J:= 0 to SidePots[I].FSubAccounts.Count-1 do begin
    acc:= SidePots[I].FSubAccounts.GetUserSubAccount(nUserID);
    if acc <> nil then acc.State:= AS_FOLDED;
//    end;//for
  end;//for
end;

function TpoPot.GetRakesToCharge: Integer;
var
  I: Integer;
begin
  Result:= 0;
  for I:= 0 to FSidePots.Count-1 do begin
    Result:= Result+SidePots[I].RakesToCharge;
  end;//for
end;

function TpoPot.IsBalanced: Boolean;
begin
  Result:= Bets.AllAreBalanced() AND
    CasinoSettleAccount.IsBalanced() AND SidePots.AllAreBalanced();
end;

function TpoPot.Load(aReader: TReader): Boolean;
begin
  Result:= inherited Load(aReader);
  FMaxRoundStakeValue:= aReader.ReadInteger;

  FUserSettleAccounts.Load(aReader);
  FCasinoSettleAccount.Load(aReader);
  FSidePots.Load(aReader);
  FTransactions.Load(aReader);
end;

procedure TpoPot.MoveMoney(aSource, aTarget: TpoAccount;
  nAmount: Integer; sContext: String; sDescription: String);
var
  tr: TpoTransaction;
begin
  aSource.ChargeFunds(nAmount);
  aTarget.AddFunds(nAmount);
  tr:= TpoTransaction.Create(
    aSource.Name,
    aTarget.Name,
    nAmount,
    sContext
  );
  tr.Description:= sDescription;
  FTransactions.AddTransaction(tr);

//
  if (aTarget is TpoPotSettlementAccount) then begin
    if (aSource is TpoUserSettlementAccount) then begin
      (aTarget as TpoPotSettlementAccount).SubAccounts.UpdateSubAccount(
        (aSource as TpoUserSettlementAccount).UserID, nAmount).State :=
        (aSource as TpoUserSettlementAccount).State; //corresp user is all in or folded

      tr.FSenderChairID:= FHand.FTable.Gamers.GamerByUserID((aSource as TpoUserSettlementAccount).UserID).FChairID;
    end;//if
    if (aTarget as TpoPotSettlementAccount).MaxOperationAmount < nAmount then begin
      (aTarget as TpoPotSettlementAccount).MaxOperationAmount := nAmount;
    end;
  end else
  if (aTarget is TpoUserSettlementAccount) then begin
    if nAmount > FMaxRoundStakeValue then FMaxRoundStakeValue:= nAmount;
  end;
  if (aSource is TpoUserPotSubAccount) then begin
    tr.FSenderChairID:= FHand.FTable.Gamers.GamerByUserID((aSource as TpoUserPotSubAccount).UserID).FChairID;
  end;//if
end;

procedure TpoPot.NewRound;
begin
  FMaxRoundStakeValue:= 0;
end;

procedure TpoPot.ReconcileWinners(sContext: String);
var
  I,J: Integer;
  upsa: TpoUserPotSubAccount;
  usa: TpoUserSettlementAccount;
begin
  for I:= SidePots.Count-1 downto 0 do begin
  //charge fee
    if (SidePots[I] as TpoPotSettlementAccount).RakesToCharge > 0 then begin
      MoveMoney(
        SidePots[I],
        CasinoSettleAccount,
        (SidePots[I] as TpoPotSettlementAccount).RakesToCharge,
        '', ''
      );
    end;//if
    (SidePots[I] as TpoPotSettlementAccount).RakesToCharge:= 0; //clen up rakes

  //
    (SidePots[I] as TpoPotSettlementAccount).RearrangeWinnersSubAccounts(FHand.FTable.FCroupier.OnPotReconcileOperation);

    for J:= 0 to (SidePots[I] as TpoPotSettlementAccount).SubAccounts.Count-1 do begin
      upsa:= (SidePots[I] as TpoPotSettlementAccount).SubAccounts[J] as TpoUserPotSubAccount;
      if upsa.IsWinner then begin //reconcile winners
        usa:= Bets.GetAccountByUserID(upsa.UserID);
        if upsa.InHiCategory then begin
          MoveMoney(upsa, usa, upsa.HiWinnerSubBalance, sContext+IntToStr(I), IntToStr(1)); //to split reconcile log on SidePots
        end;//if
        if upsa.InLoCategory then begin
          MoveMoney(upsa, usa, upsa.LoWinnerSubBalance, sContext+IntToStr(I), IntToStr(0)); //to split reconcile log on SidePots
        end;//if
      end;//if
    end;//for
  end;//for
end;

procedure TpoPot.CleanUpRakes;
var
  I: Integer;
begin
  for I:= SidePots.Count-1 downto 0 do begin
    (SidePots[I] as TpoPotSettlementAccount).RakesToCharge:= 0; //clen up rakes
  end;
end;

function TpoPot.RegisterGamerForSettlement(aGamer: TpoGamer): TpoGamer;
begin
  (FUserSettleAccounts.AddAccount(
    TpoUserSettlementAccount.Create(
      IntToStr(aGamer.UserID), USER_POT_ACCOUNT_TYPE, AC_DEFAULT
    )
  ) as TpoUserSettlementAccount).FUserID:= aGamer.UserID;

  Result:= aGamer;
end;

procedure TpoPot.Reset;
begin
//check for all withdrawals being complete
  if NOT Bets.AllAreBalanced then begin
    EscalateFailure(
      EpoException,
      'All acounts must be balanced before cleanup.',
      '{889EE155-8888-4F25-9855-B559C877296C}'
    );
  end;//if

  CasinoSettleAccount.Clear;
  SidePots.Clear;
  Bets.Clear;
  Transactions.Clear;
end;

function TpoPot.Store(aWriter: TWriter): Boolean;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteInteger(FMaxRoundStakeValue);

  FUserSettleAccounts.Store(aWriter);
  FCasinoSettleAccount.Store(aWriter);
  FSidePots.Store(aWriter);
  FTransactions.Store(aWriter);
end;

function TpoPot.TotalAmount: Integer;
var
  I: Integer;
begin
  Result:= 0;
  for I:= 0 to SidePots.Count-1 do begin
    Result:= SidePots.Balance;
  end;//for
end;

function TpoPot.UserHasBets(nUserID: Integer): Boolean;
var
  acc: TpoUserSettlementAccount;
begin
  acc:= FUserSettleAccounts.GetAccountByUserID(nUserID);
  Result:= (acc <> nil) AND (acc.FDebitBalance > 0);
end;

function TpoPot.UserHasBetsInRound(nUserID: Integer): Boolean;
var
  acc: TpoUserSettlementAccount;
begin
  acc:= FUserSettleAccounts.GetAccountByUserID(nUserID);
  Result:= (acc <> nil) AND (acc.Balance > 0);
end;

{ TpoUserAccount }

function TpoUserAccount.Dump: String;
begin
  Result:= inherited Dump()+ ' UserID: '+IntToStr(UserID);
end;

function TpoUserAccount.GetName: String;
begin
  Result:= FName;//+'#'+IntToStr(UserID)
end;

function TpoUserAccount.Load(aReader: TReader): Boolean;
begin
  Result:= inherited Load(aReader);
  FUserID:= aReader.ReadInteger;
end;

function TpoUserAccount.Store(aWriter: TWriter): Boolean;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteInteger(FUserID);
end;

{ TpoTransaction }

constructor TpoTransaction.Create(
  sSourceAccountName,
  sTargetAccountName: String;
  nAmount: Integer;
  sContext: String
);
begin
  inherited Create;
  FStamp:= Now;
  FSourceAccountName:= sSourceAccountName;
  FTargetAccountName:= sTargetAccountName;
  FAmount:= nAmount;
  FContext:= sContext;
end;


function TpoTransaction.Load(aReader: TReader): Boolean;
begin
  Result:= inherited Load(aReader);
  FTargetAccountName:= aReader.ReadString;
  FSourceAccountName:= aReader.ReadString;
  FAmount           := aReader.ReadInteger;
  FContext          := aReader.ReadString;
  FStamp            := aReader.ReadDate;
  FDescription      := aReader.ReadString;
  FFiltered         := aReader.ReadBoolean;
  FSenderChairID    := aReader.Readinteger;
end;

procedure TpoTransaction.SetDescription(const Value: String);
begin
  FDescription := Value;
end;

function TpoTransaction.Store(aWriter: TWriter): Boolean;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteString  (FTargetAccountName);
  aWriter.WriteString  (FSourceAccountName);
  aWriter.WriteInteger (FAmount           );
  aWriter.WriteString  (FContext          );
  aWriter.WriteDate    (FStamp            );
  aWriter.WriteString  (FDescription      );
  aWriter.WriteBoolean (FFiltered         );
  aWriter.WriteInteger (FSenderChairID    );
end;

{ TpoTransactions }

function TpoTransactions.AddTransaction(
  aTransaction: TpoTransaction): TpoTransaction;
begin
  Result:= aTransaction;
  FTransactions.Add(Result);
  if FContexts.IndexOf(Result.Context) = -1 then FContexts.Add(Result.Context);
  if (ContextFilter <> '') AND (Result.Context <> ContextFilter)
  then Result.FFiltered:= True
  else Result.FFiltered:= False;
end;

procedure TpoTransactions.Clear;
begin
  FContexts.Clear;
  FTransactions.Clear;
end;

constructor TpoTransactions.Create;
begin
  inherited Create;
  FContexts:= TStringList.Create;
  FContexts.Sorted:= True;
  FTransactions:= TObjectList.Create;

  FMessageContext := '';
end;

function TpoTransactions.SourceTotal(sSourceAccountName: String): Integer;
var
  I: Integer;
begin
  Result:= 0;
  for I:= 0 to Count-1 do begin
    if Transactions[I].SourceAccountName = sSourceAccountName then
    Result:= Result+Transactions[I].Amount;
  end;//for
end;

function TpoTransactions.TargetTotal(sTargetAccountName: String): Integer;
var
  I: Integer;
begin
  Result:= 0;
  for I:= 0 to Count-1 do begin
    if Transactions[I].TargetAccountName = sTargetAccountName then
    Result:= Result+Transactions[I].Amount;
  end;//for
end;

destructor TpoTransactions.Destroy;
begin
  
  FContexts.Clear;
  FTransactions.Clear;

  FContexts.Free;
  FTransactions.Free;
  inherited;
end;

procedure TpoTransactions.FixElementRefs;
begin
//TBD:
end;

function TpoTransactions.GetCount: Integer;
var
  I: Integer;
begin
  if FContextFilter = '' then Result:= FTransactions.Count
  else begin
    Result:= 0;
    for I:= 0 to FTransactions.Count-1 do begin
      if NOT (FTransactions[I] as TpoTransaction).FFiltered then Inc(Result);
    end;//for
  end;//if
end;


function TpoTransactions.GetTransactions(Index: Integer): TpoTransaction;
var
  I, nNotFiltredID: Integer;
begin
  Result:= nil;
  nNotFiltredID:= -1;
  if FContextFilter = '' then Result:= FTransactions[Index] as TpoTransaction
  else begin
    for I:= 0 to FTransactions.Count-1 do begin
      if NOT (FTransactions[I] as TpoTransaction).FFiltered then Inc(nNotFiltredID);
      if nNotFiltredID = Index then begin
        Result:= FTransactions[I] as TpoTransaction;
        Exit;
      end;//if
    end;//for
  end;//if
end;//TpoTransactions.GetTransactions


procedure TpoTransactions.SetContextFilter(const Value: String);
var
  I: Integer;
begin
  FContextFilter := Value;
  for I:= 0 to FTransactions.Count-1 do begin
    if (FContextFilter = '') OR (FContextFilter = (FTransactions[I] as TpoTransaction).Context)
    then (FTransactions[I] as TpoTransaction).FFiltered := False
    else (FTransactions[I] as TpoTransaction).FFiltered := True;
  end;//for
end;

function TpoTransactions.Load(aReader: TReader): Boolean;
var
  I, cnt: Integer;
  sContextFilter: String;
begin
  FTransactions.Clear;
  Result:= inherited Load(aReader);
  ContextFilter:= '';
  sContextFilter:= aReader.ReadString;
  FContexts.Text:= aReader.ReadString;
  cnt:= aReader.ReadInteger;
  for I:= 0 to cnt-1 do begin
    AddTransaction(TpoTransaction.Create(
      '', '', 0, '')).Load(aReader);
  end;//for
  ContextFilter:= sContextFilter;
end;

function TpoTransactions.Store(aWriter: TWriter): Boolean;
var
  I: Integer;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteString(FContextFilter);
  aWriter.WriteString(FContexts.Text);
  aWriter.WriteInteger(Count);
  for I:= 0 to Count-1 do begin
    Transactions[I].Store(aWriter);
  end;//for
end;

procedure TpoTransactions.SetMessageContext(const Value: string);
begin
  FMessageContext := Value;
end;

{ TpoRake }

function TpoRake.Load(aReader: TReader): Boolean;
begin
  Result:= inherited Load(aReader);
  FAmount         := aReader.ReadInteger;
  FCharged        := aReader.ReadBoolean;
  FRakeType       := TpoRakeType(aReader.ReadInteger);
  FChargeThreshold:= aReader.ReadInteger;
end;

procedure TpoRake.SetAmount(const Value: Integer);
begin
  FAmount := Value;
end;

procedure TpoRake.SetCharged(const Value: Boolean);
begin
  FCharged := Value;
end;

procedure TpoRake.SetChargeThreshold(const Value: Integer);
begin
  FChargeThreshold := Value;
end;

procedure TpoRake.SetRakeType(const Value: TpoRakeType);
begin
  FRakeType := Value;
end;

function TpoRake.Store(aWriter: TWriter): Boolean;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteInteger(FAmount         );
  aWriter.WriteBoolean(FCharged        );
  aWriter.WriteInteger(Integer(FRakeType));
  aWriter.WriteInteger(FChargeThreshold);
end;

{ TpoRakes }

function TpoRakes.Add(aRake: TpoRake): TpoRake;
begin
  Result:= aRake;
  FRakes.Add(Result);
end;

constructor TpoRakes.Create;
begin
  inherited Create;
  FRakes:= TObjectList.Create;
end;

destructor TpoRakes.Destroy;
begin
  
  FRakes.Clear;

  FRakes.Free;
  inherited;
end;

procedure TpoRakes.FixElementRefs;
begin
//TBD:
end;

function TpoRakes.GetCount: Integer;
begin
  Result:= FRakes.Count;
end;

function TpoRakes.GetRakes(Index: Integer): TpoRake;
begin
  Result:= FRakes[Index] as TpoRake;
end;

function TpoRakes.Load(aReader: TReader): Boolean;
var
  I: Integer;
  cnt: Integer;
begin
  FRakes.Clear;
  Result:= inherited Load(aReader);
  FTotalLimit:= aReader.ReadInteger;
  cnt:= aReader.ReadInteger;
  for I:= 0 to cnt-1 do begin
    Add(TpoRake.Create).Load(aReader);
  end;//for
end;

procedure TpoRakes.Reset;
var
  I: Integer;
begin
  for I:= 0 to Count-1 do begin
    Rakes[I].Charged:= False;
  end;//for
end;

procedure TpoRakes.SetTotalLimit(const Value: Integer);
begin
  FTotalLimit := Value;
end;

function TpoRakes.Store(aWriter: TWriter): Boolean;
var
  I: Integer;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteInteger(FTotalLimit);
  aWriter.WriteInteger(Count);
  for I:= 0 to Count-1 do begin
    Rakes[I].Store(aWriter);
  end;//for
end;

{ TpoReservation }

function TpoReservation.Load(aReader: TReader): Boolean;
begin
  Result:= inherited Load(aReader);
  FChairID  := aReader.ReadInteger;
  FUserID   := aReader.ReadInteger;
  FPriority := aReader.ReadInteger;
  FExpired  := aReader.ReadBoolean;
  FCanceled := aReader.ReadBoolean;
  FUpToTime := aReader.ReadDate;
  FCondition:= aReader.ReadString;
end;

procedure TpoReservation.SetCanceled(const Value: Boolean);
begin
  FCanceled := Value;
end;

procedure TpoReservation.SetChairID(const Value: Integer);
begin
  FChairID := Value;
end;

procedure TpoReservation.SetCondition(const Value: String);
begin
  FCondition := Value;
end;

procedure TpoReservation.SetExpired(const Value: Boolean);
begin
  FExpired := Value;
end;

procedure TpoReservation.SetPriority(const Value: Integer);
begin
  FPriority := Value;
end;

procedure TpoReservation.SetUpToTime(const Value: TDateTime);
begin
  FUpToTime := Value;
end;

procedure TpoReservation.SetUserID(const Value: Integer);
begin
  FUserID := Value;
end;

function TpoReservation.Store(aWriter: TWriter): Boolean;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteInteger(FChairID  );
  aWriter.WriteInteger(FUserID   );
  aWriter.WriteInteger(FPriority );
  aWriter.WriteBoolean(FExpired  );
  aWriter.WriteBoolean(FCanceled );
  aWriter.WriteDate   (FUpToTime );
  aWriter.WriteString (FCondition);
end;

{ TpoReservations }

constructor TpoReservations.Create;
begin
  inherited Create;
  FReservations:= TObjectList.Create;
  
  FReservations.OwnsObjects := TRUE;
end;

destructor TpoReservations.Destroy;
begin
  FReservations.Clear;
  FReservations.Free;
  inherited;
end;

procedure TpoReservations.FixElementRefs;
begin
//TBD:
end;

function TpoReservations.GetCount: Integer;
begin
  Result:= FReservations.Count;
end;

function TpoReservations.GetReservations(Index: Integer): TpoReservation;
begin
  Result:= FReservations[Index] as TpoReservation;
end;//TpoReservations.GetReservations


function TpoReservations.Load(aReader: TReader): Boolean;
var
  I, cnt: Integer;
  r: TpoReservation;
begin
  FReservations.Clear;
  Result:= inherited Load(aReader);
  cnt:= aReader.ReadInteger;
  for I:= 0 to cnt-1 do begin
    r:= TpoReservation.Create;
    r.Load(aReader);
    FReservations.Add(r);
  end;//for
end;

function TpoReservations.PutReservation(nUserID,
  nChairID: Integer): TpoReservation;
begin
  Result:= TpoReservation.Create;
  Result.UserID:= nUserID;
  Result.ChairID:= nChairID;
  FReservations.Add(Result);
end;

function TpoReservations.RemoveReservation(nUserID,
  nChairID: Integer): TpoReservation;
var
  I: Integer;
begin
  Result:= nil;
  for I := 0 to Count-1 do begin
    if (Reservations[I].UserID = nUserID) AND (Reservations[I].ChairID = nChairID)
    then begin
      Result:= Reservations[I];
      FReservations.Remove(Result);
    end;//if
  end;//for
end;

function TpoReservations.Store(aWriter: TWriter): Boolean;
var
  I: Integer;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteInteger(Count);
  for I:= 0 to Count-1 do begin
    Reservations[I].Store(aWriter);
  end;//for
end;

{ TpoGenericCroupier }

constructor TpoSingleTableCroupier.Create(
  aTable: TpoTable; nPokerType: TpoPokerType; sCurrencySymbol: string;
  nMinGamersForStartHand: Integer
);
begin
  inherited Create(aTable, nPokerType, sCurrencySymbol, nMinGamersForStartHand);
  TournamentType:= TT_NOT_TOURNAMENT;
  FHandIsStartedFromIdle := True;
end;

function TpoSingleTableCroupier.FindBigBlindCandidate(): TpoGamer;
begin
  Result:= FindSmallBlindGamer;
  if Result <> nil then begin
    Result:= FindStepRightChairLeftToPosition(Result.ChairID).Gamer;
  end;//
end;//if

function TpoSingleTableCroupier.FindFirstPostOrPostDeadGamer(): TpoGamer;
var
  ch: TpoChair;
  bbcand: TpoGamer;
  CntIter: Integer;

begin
  Result:= nil;
  ch:= Chairs[Hand.DealerChairID];
  bbcand:= FindBigBlindCandidate();
  CntIter := -1;
  repeat
    Inc(CntIter);
    if (CntIter > (Chairs.Count + 1)) then begin
      ch:= Chairs[Hand.DealerChairID];
      if (ch.Gamer.State = GS_ALL_IN) then Exit; // no error

      CommonDataModule.Log(ClassName, 'FindFirstPostOrPostDeadGamer',
      '[WARNING - CIRCLE]: Count of iterations in REPEAT statment more then needing. Iteration count=' + IntToStr(CntIter) + ', Chair count=' + IntToStr(Chairs.Count) +
        'Dialer=' + IntToStr(Hand.DealerChairID) + ', Active=' + IntToStr(Hand.FActiveChairID) +
        ', SmallBlind' + IntToStr(Hand.FSmallBlindChairID) + ', BigBlind=' + IntToStr(Hand.FBigBlindChairID) +
        ', HandID=' + IntToStr(Hand.HandID) + ', Round=' +IntToStr(Hand.RoundID),
      ltError);

      EscalateFailure(
        EpoException,
        'Count of iterations in REPEAT statment more then needing. Iteration count=' + IntToStr(CntIter) + ', Chair count=' + IntToStr(Chairs.Count),
        '{AF5ADFA9-D12A-4333-BAB2-591FAEAB5E13}'
      );
    end;

    ch:= FindStepRightChairLeftToPosition(ch.IndexOf);
    if (ch.Gamer.MustSetPost OR (ch.Gamer.MustSetPostDead)) AND
       (NOT ch.Gamer.PassCurrentHand) AND (NOT ch.Gamer.FinishedTournament) then
    begin
      if (ch.Gamer <> bbcand) then begin
        if  ch.Gamer.WaitForBigBlind then begin
          ch.Gamer.State:= GS_IDLE;
          ch.Gamer.PassCurrentHand:= True;
        end else begin
          Result:= ch.Gamer;
          Break;
        end;//if
      end;//if
    end;//if
  until ch.IndexOf = Hand.DealerChairID;
end;//if

procedure TpoSingleTableCroupier.MandatoryAnteStakeOnStartHand;
var
  I: Integer;
  aChair: TpoChair;
  aGamer: TpoGamer;
  nStake: Integer;
begin
  if FTable.MandatoryAnte <= 0 then Exit;

  for I:= 0 to FTable.Chairs.Count-1 do begin
    aChair := FTable.Chairs[I];
    aGamer := aChair.Gamer;
    if not ChairCanTakeStepRight(aChair) then Continue;
    nStake := HandleStake(aGamer, FTable.MandatoryAnte);
    if Assigned(OnGamerAction) then OnGamerAction(aGamer, GA_ANTE, [nStake]);
  end;//for

  MoveRoundBetsToPot;
end;

function TpoSingleTableCroupier.DefineActiveGamer(): TpoGamer;
var
  I, CntIter: Integer;
  ch: TpoChair;
begin
  Result:= Hand.ActiveGamer;
  if Result = nil then Result:= DefineOpenRoundGamer()
  else begin
    if (PokerClass = PTC_OPEN_CARDS_POKER) AND (IsPreliminaryRound) then begin
      if Hand.SmallBlindGamer = nil then Result:= FindFirstPostOrPostDeadGamer()
      else Result:= nil;

      if Result = nil then begin
        if Hand.SmallBlindGamer = nil then Result:= FindSmallBlindGamer
        else begin
          Result := Hand.ActiveGamer;
          CntIter := -1;
          repeat
            Inc(CntIter);
            if (CntIter > (Chairs.Count + 1)) then begin
              CommonDataModule.Log(ClassName, 'DefineActiveGamer',
              '[WARNING - CIRCLE]: Count of iterations in REPEAT statment more then needing. Iteration count=' + IntToStr(CntIter) + ', Chair count=' + IntToStr(Chairs.Count) +
                'Dialer=' + IntToStr(Hand.DealerChairID) + ', Active=' + IntToStr(Hand.FActiveChairID) +
                ', SmallBlind' + IntToStr(Hand.FSmallBlindChairID) + ', BigBlind=' + IntToStr(Hand.FBigBlindChairID) +
                ', HandID=' + IntToStr(Hand.HandID) + ', Round=' +IntToStr(Hand.RoundID),
              ltError);

              EscalateFailure(
                EpoException,
                'Count of iterations in REPEAT statment more then needing. Iteration count=' + IntToStr(CntIter) + ', Chair count=' + IntToStr(Chairs.Count),
                '{B78297DE-4378-424B-9A72-AF4BC5992076}'
              );
            end;

            Result:= FindStepRightChairLeftToPosition(Result.ChairID, True).Gamer;
            if ((Result.State = GS_SITOUT) OR (Result.IsSitOut)) AND (NOT SitOutCanTakeStepRight) then begin
              if Hand.BigBlindGamer = nil then REsult.FSkippedBBStake:= True;
              Continue;
            end else Break;
          until Result = Hand.ActiveGamer;
        end;//
      end;//
    end else begin
      if NOT IsShowdownRound then Result:= FindStepRightChairLeftToPosition(Result.ChairID).Gamer
      else begin
        for I:= Hand.Pot.SidePots.Count-1 downto 0 do begin
          ch:= FindWinnerCandidateStepRightChairFromSet(Hand.Pot.SidePots[I].GetPlayingUserIDs);
          if ch = nil then begin
            if Assigned(OnPotReconcileFinish) then OnPotReconcileFinish(I, GetHandReconcileContext());
            Hand.Pot.SidePots[I].HandledInShowdown:= True;
          end else begin
            Result:= ch.Gamer;
            Break;
          end;//if
        end;//for
      end;//if
    end;//if
  end;
  Hand.ActiveGamer:= Result;
  SetupGamersActions();
end;

procedure TpoSingleTableCroupier.DefineGamersAndDealerForCurrentHand;

  procedure DefineHandCandidates();
  var
    I: Integer;
  begin
    for I:= 0 to Chairs.Count-1 do begin
      if ChairIsReadyToPlay(Chairs[I]) then begin
        if (Chairs[I].Gamer.State = GS_IDLE) AND (NOT Chairs[I].Gamer.FinishedTournament) then begin
          Chairs[I].Gamer.State:= GS_PLAYING;
        end;//
      end;//if
    end;//for
  end;//

  function ReadyToPlayWithoutMustChairsCount(): Integer;
  var
    I: Integer;
    ch: TpoChair;
  begin
    Result:= 0;
    for I:= 0 to Chairs.Count-1 do begin
      ch := Chairs[I];
      if not ChairIsReadyToPlay(ch) then Continue;
      if (ch.Gamer.MustSetPostDead) or (ch.Gamer.MustSetPost) then Continue;
      Inc(Result);
    end;//for
  end;


  function FindDealerCandidate(): TpoGamer;
  var
    ch, cch: TpoChair;
    CntIter: Integer;
  begin
    Result:= nil;
    if (Hand.DealerChairID = UNDEFINED_POSITION_ID) then begin
      ch:= FindStepRightChairLeftToPosition(Chairs.Count); //first from the left
      Hand.DealerChairID:= ch.IndexOf;
      Result:= ch.Gamer;
    end else
    if (Hand.DealerChairID = Hand.FPrevDealerChairID) or
       (not ChairIsReadyToPlay(Chairs[Hand.DealerChairID])) then begin //there was set in prev round
      ch:= FindStepRightChairLeftToPosition(Hand.DealerChairID, True);
      cch:= ch;
      CntIter := -1;
      repeat
        Inc(CntIter);
        if (CntIter > (Chairs.Count + 1)) then begin
          CommonDataModule.Log(ClassName, 'FindDealerCandidate',
          '[WARNING - CIRCLE]: Count of iterations in REPEAT statment more then needing. Iteration count=' + IntToStr(CntIter) + ', Chair count=' + IntToStr(Chairs.Count) +
            'Dialer=' + IntToStr(Hand.DealerChairID) + ', Active=' + IntToStr(Hand.FActiveChairID) +
            ', SmallBlind' + IntToStr(Hand.FSmallBlindChairID) + ', BigBlind=' + IntToStr(Hand.FBigBlindChairID) +
            ', HandID=' + IntToStr(Hand.HandID) + ', Round=' +IntToStr(Hand.RoundID),
          ltError);
          EscalateFailure(
            EpoException,
            'Count of iterations in REPEAT statment more then needing. Iteration count=' + IntToStr(CntIter) + ', Chair count=' + IntToStr(Chairs.Count),
            '{8C609CD7-99CE-45AA-A286-11E63F76B7EB}'
          );
        end;

        if (ch.Gamer.IsSitOut) AND (NOT SitOutCanTakeStepRight) then ch.Gamer.MustSetPostDead:= True;
        if (NOT ch.Gamer.MustSetPostDead) AND (NOT ch.Gamer.MustSetPost) then Break;
        ch:= FindStepRightChairLeftToPosition(ch.IndexOf, True);
        if cch = ch then begin
          ClearBigBlindIssues;
          Break;
        end;//if
      until False;
      if ch = nil then ch:= FindStepRightChairLeftToPosition(Chairs.Count); //first from the left
      Hand.DealerChairID:= ch.IndexOf;
      Result:= ch.Gamer;
    end;//define dealer
  end;//

  procedure DeactivateImproperSmallBlinds();
  var
    ch, cch: TpoChair;
    CntIter: Integer;
  begin
    ch:= FindStepRightChairLeftToPosition(Hand.DealerChairID);
    cch:= ch;
    CntIter := -1;
    repeat
      Inc(CntIter);
      if (CntIter > (Chairs.Count + 1)) then begin
        CommonDataModule.Log(ClassName, 'DeactivateImproperSmallBlinds',
        '[WARNING - CIRCLE]: Count of iterations in REPEAT statment more then needing. Iteration count=' + IntToStr(CntIter) + ', Chair count=' + IntToStr(Chairs.Count) +
          'Dialer=' + IntToStr(Hand.DealerChairID) + ', Active=' + IntToStr(Hand.FActiveChairID) +
          ', SmallBlind' + IntToStr(Hand.FSmallBlindChairID) + ', BigBlind=' + IntToStr(Hand.FBigBlindChairID) +
          ', HandID=' + IntToStr(Hand.HandID) + ', Round=' +IntToStr(Hand.RoundID),
        ltError);
        EscalateFailure(
          EpoException,
          'Count of iterations in REPEAT statment more then needing. Iteration count=' + IntToStr(CntIter) + ', Chair count=' + IntToStr(Chairs.Count),
          '{FE3368B8-3835-4E8D-AC98-6A9A2909D0F8}'
        );
      end;

      if (ch.Gamer.MustSetPostDead OR ch.Gamer.MustSetPost) AND
         (StepRightChairsCount > 2)
      then begin
      //this is new gamer - must wait for big blind
        ch.Gamer.PassCurrentHand:= True;
        ch.Gamer.State := GS_IDLE;
        ch.Gamer.FSkippedSBStake:= True;
        SendMessage(ch.Gamer.UserName+' will be allowed to play after the button.');
      end else Break;
      ch:= FindStepRightChairLeftToPosition(ch.IndexOf);
      if (ch = cch) then Break; //detect round up
    until False;
  end;//DeactivateImproperSmallBlinds()

  procedure GetBackBigBlindWaiter();
  var
    sbch, bbch: TpoChair;
  begin
    sbch:= FindStepRightChairLeftToPosition(Hand.DealerChairID);
    if sbch = nil then Exit;
    bbch:= FindStepRightChairLeftToPosition(sbch.IndexOf, True);
    if (bbch <> nil) AND bbch.Gamer.WaitForBigBlind then begin
      HandleGamerAutoAction(bbch.Gamer, GAA_AUTO_WAIT_BB, 0, False);
      bbch.Gamer.State:= GS_PLAYING;
      bbch.Gamer.PassCurrentHand:= False;
    end;//
  end;//GetBackBigBlindWaiter

begin
  try
  //define candidates for the hand
    DefineHandCandidates();

  //define dealer
    case PokerType of
    //clock wise dealer definition
      PT_TEXAS_HOLDEM,    //1 - Texas Hold'em
      PT_OMAHA,           //2 – Omaha
      PT_OMAHA_HILO:      //3 - Omaha Hi Lo
        begin
          //clen up Big blind issues
          if (ReadyToPlayChairsCount() = 2) OR
             (FHandIsStartedFromIdle)       OR
             (ReadyToPlayWithoutMustChairsCount < 2)
          then ClearBigBlindIssues;

          //define dealer
          FindDealerCandidate();

          // Deactivate small blinds that must set big blinds
          if ReadyToPlayChairsCount() > 2 then begin
            DeactivateImproperSmallBlinds();
          end;//if
        end;//if

      PT_SEVEN_STUD,
      PT_SEVEN_STUD_HILO:
        Hand.DealerChairID:= UNDEFINED_POSITION_ID;
    end;//case
  except
    on E: EpoException do raise;
    on e: Exception do begin
      DumpCachedStateToFile;
      CommonDataModule.Log(ClassName, 'DefineGamersAndDealerForCurrentHand',
        'EXCEPT block of try catch was occured: ' + e.Message + '; State was dumped.', ltException);
    end;
  end;//
end;


function TpoSingleTableCroupier.FinishHand: Boolean;
var
  nStartingTimeout: Integer;
  sStartingMessage: String;
begin
  Result:= True;
  try

  // Clear additionals prop BS
    ClearAllGamersShowDownPassedAndFinishTournament;
    // correct bots
    CheckForBotsContinue;

  //finish hand packet and history
    if Assigned(OnHandFinish) then OnHandFinish(GetHandReconcileContext());

  //clear accounts and adding morechips
    Hand.Finish;

  //Handle left gamers
    HandleLeftGamers();

  //initiate next hand
    FHandIsStartedFromIdle := (FTable.Chairs.WithGamerChairsCount = 0);
    if TableIsReadyForHand() then begin
      if Assigned(OnHandStarting) then
      begin
        nStartingTimeout:= GetNextHandStartingTimeout();
        if Chairs.GetFreeChairsCount = 0
          then sStartingMessage:= 'Let''s go'
          else sStartingMessage:= Format('Game will be started after %d seconds', [nStartingTimeout]);
        OnHandStarting(Self, nStartingTimeout);
      end;//if
//      FHandIsStartedFromIdle:= False;
      Hand.State := HST_STARTING;
    end else begin
      SendMessage('Game is cancelled -- not enough players');
      SendMessage('Waiting for more players before starting the next game');
      Hand.State := HST_IDLE;
      ClearBigBlindIssues;
    end;//if
  except
    on e: EpoException do raise;
    on e: Exception do begin
      DumpCachedStateToFile;
      CommonDataModule.Log(ClassName, 'FinishHand',
        'EXCEPT block of try catch was occured: ' + e.Message + '; State was dumped.', ltException);
    end;
  end;//
end;//TpoGenericCroupier.FinishHand


procedure TpoSingleTableCroupier.FixElementRefs;
begin
//TBD:
end;

function TpoSingleTableCroupier.HandleGamerLeaveTable(aGamer: TpoGamer): TpoGamer;
var
  bIsActive: Boolean;
  nPosition: Integer;
begin
  Result:= aGamer;
  nPosition := aGamer.FChairID;
  Result.FHandIDWhenLeft := Hand.FHandID;

  case (Hand.State) of
    HST_RUNNING:
      begin
        bIsActive:= Result.IsActive;
        if bIsActive then begin
          Result.State:= GS_LEFT_TABLE;
          //0412
          if IsPreliminaryRound then HandleGamerSitOut(aGamer)
          else
          if IsShowdownRound then HandleGamerDontShowCards(aGamer)
          else HandleGamerFold(aGamer, False);
        end else begin
          Result.FSheduledToLeaveTable:= True;
          if ChairCanTakeStepRight(Result.Chair) or (aGAmer.State = GS_ALL_IN)
          then HandleGamerAutoAction(aGAmer, GAA_AUTO_LEAVE_TABLE, 0, True)
          else Result.State:= GS_LEFT_TABLE;

          if (Result.State = GS_LEFT_TABLE) and Result.IsWatcher then begin
            Gamers.DeleteGamer(Result);
          end;//
        end;//if
      end;//HST_RUNNING:

    HST_STARTING:
      begin
        if Assigned(OnGamerAction) then OnGamerAction(Result, GA_LEAVE_TABLE, []);
        if Assigned(OnGamerLeaveTable) then OnGamerLeaveTable(Result);
        Result.StandUp;
        aGamer.State:= GS_LEFT_TABLE;
        if nPosition <> UNDEFINED_POSITION_ID then begin
          if Assigned(OnChairStateChange) then OnChairStateChange(Result, nPosition);
        end;
        FTable.FGamers.ClearLeftGamers;
        Result:= nil;
        if (NOT TableIsReadyForHand) then begin
          Hand.State:= HST_IDLE;
          if Assigned(OnAbandonHandStarting) then OnAbandonHandStarting(Self);
        end;//if
      end;//HST_STARTING:

    HST_IDLE, HST_FINISHED:
      begin
        if Assigned(OnGamerAction) then OnGamerAction(Result, GA_LEAVE_TABLE, []);
        if Assigned(OnGamerLeaveTable) then OnGamerLeaveTable(Result);
        Result.StandUp;
        aGamer.State:= GS_LEFT_TABLE;
        if nPosition <> UNDEFINED_POSITION_ID then begin
          if Assigned(OnChairStateChange) then OnChairStateChange(Result, nPosition);
        end;
        FTable.FGamers.ClearLeftGamers;
        Result:= nil;
      end;//HST_IDLE:
  end;//case

  FHandIsStartedFromIdle := (FTable.Chairs.WithGamerChairsCount = 0);
end;

function TpoSingleTableCroupier.HandleGamerSitDown(aGamer: TpoGamer;
  nPosition: Integer; nAmount: Integer): Boolean;
var
  nStartingTimeout: Integer;
  sStartingMessage: String;
begin
  if (FTable.Chairs[nPosition].State <> CS_EMPTY) AND (FTable.Chairs[nPosition].UserID <> aGamer.UserID) then begin
    CommonDataModule.Log(ClassName, 'HandleGamerSitDown', 'Chair at pos '+IntToStr(nPosition)+' is not empty.', ltError);
    EscalateFailure(
      EpoSessionException,
      aGamer.SessionID,
      'Chair at pos '+IntToStr(nPosition)+' is not empty.',
      '{C9DAABF7-0FCB-4AE9-ABBA-1E0926FE5517}'
    );
  end;//if

  aGamer.SitDownAt(FTable.Chairs[nPosition], nAmount);
  aGamer.FFinishedHands:= 0;

  if FTable.Hand.State = HST_RUNNING then begin
    aGamer.PassCurrentHand:= True;
    aGamer.MustSetPost:= True;
  end else begin
    if (PokerClass = PTC_OPEN_CARDS_POKER) AND
      (ReadyToPlayChairsCount = 1) AND
      ChairIsReadyToPlay(aGamer.Chair)
    then Hand.DealerChairID:= aGamer.ChairID;
  end;//if
  aGamer.ShowDownPassed := True;

  if PokerClass = PTC_OPEN_CARDS_POKER then begin
    aGamer.MustSetBigBlind:= True;
  end;//if

//update chair
  if Assigned(OnChairStateChange) then OnChairStateChange(aGamer, nPosition);

//check for hand start conditions
  if (FTable.Hand.State = HST_IDLE) AND TableIsReadyForHand() then begin
//    FHandIsStartedFromIdle:= True;
    FTable.Hand.State := HST_STARTING;
    if Assigned(OnHandStarting) then begin
      nStartingTimeout:= GetNextHandStartingTimeout();

      if Chairs.GetFreeChairsCount = 0 then sStartingMessage:= 'Let''s go'
      else sStartingMessage:= Format('Game will be started after %d seconds', [nStartingTimeout]);

      SendMessage(sStartingMessage);
      OnHandStarting(Self, nStartingTimeout);
    end;//
  end;//if

  Result:= True;
end;


function TpoSingleTableCroupier.HandleGamerSitOut(aGamer: TpoGamer): TpoGamer;
var
  ch: TpoChair;
begin
  Result:= aGamer;

  if (FTournamentType = TT_NOT_TOURNAMENT) then begin
    if aGamer.IsBot then begin
      HandleGamerBack(aGamer);
      Exit;
    end;
  end;

  if (aGamer.State <> GS_SITOUT) AND (NOT aGamer.IsSitOut) then begin
    if aGamer.State <> GS_LEFT_TABLE then aGamer.State:= GS_SITOUT;
    if Assigned(OnGamerAction) then OnGamerAction(aGamer, GA_SIT_OUT, []);
  end;// else Exit;

  case (Hand.State) of
    HST_RUNNING:
      begin
        if (NOT SitOutCanTakeStepRight)then Hand.Pot.FoldGamerAccounts(aGamer.UserID);

        if Result.IsActive then begin
          if NOT SitOutCanTakeStepRight then begin
            if Hand.SmallBlindGamer = nil then Result.FSkippedSBStake:= True
            else
            if Hand.BigBlindGamer = nil then begin
              Result.FSkippedBBStake:= True;
              Result.SkippedRequiredStakes:= Result.SkippedRequiredStakes+1;
            end;//
          end;//if
        end;//if

        if (NOT SitOutCanTakeStepRight) AND (IsPreliminaryRound() AND (Hand.SmallBlindGamer <> nil) AND (Hand.BigBlindGamer = nil)) then begin
          ch:= FindStepRightOrPostChairLeftToPosition(Hand.ActiveChairID);
          if ch.Gamer.LastActionInRound IN [GA_POST, GA_POST_DEAD] then Hand.FBigBlindChairID:= ch.IndexOf;
        end;//if

      //- 1/29/2004
        if Result.IsActive then begin
          DefineNextStageInHand();
        end;//if
      end;//HST_RUNNING:

    HST_STARTING:
      begin
        if (NOT TableIsReadyForHand) then begin
          Hand.State:= HST_IDLE;
          if Assigned(OnAbandonHandStarting) then OnAbandonHandStarting(Self);
        end;//if
      end;//HST_STARTING:

    HST_IDLE, HST_FINISHED:
      begin
        if aGamer.State <> GS_LEFT_TABLE then  aGamer.State:= GS_SITOUT; //0401
      end;//HST_IDLE:
  end;//case
end;

function TpoSingleTableCroupier.Load(aReader: TReader): Boolean;
begin
  Result:= inherited Load(aReader);
  FPokerType:= TpoPokerType(aReader.ReadInteger);
  FStakeType:= TpoStakeType(aReader.ReadInteger);
  FRoundHasFinished:= aReader.ReadBoolean;
  FHandIsStartedFromIdle:= aReader.ReadBoolean;
  FMinGamersForStartHand := aReader.ReadInteger;
end;

function TpoSingleTableCroupier.MaxBetLimitIsReached(aGamer: TpoGamer): Boolean;
begin
  Result:= False;
  if StakeType = ST_FIXED_LIMIT then begin
    Result:= Hand.Pot.Bets.GetMaxBalance > GetMaxStakeValue(aGamer);
  end else
  if StakeType IN [ST_POT_LIMIT, ST_NO_LIMIT] then begin
    Result:= False;
  end;
end;


function TpoSingleTableCroupier.NewRound: Boolean;
var
  nWinnerCandidates: Integer;
  nPlrsAtFlop: Integer;
begin
  Result := True;
  try
  //inity round related metrics
    FRoundHasFinished:= False;
    Hand.NewRound;

  //manage cards (gamers and community)
    nWinnerCandidates:= WinnerCandidatesCount();

    if (nWinnerCandidates > 1) then begin
      DealGamerCards();
    end;//

    if Hand.RoundID = 1 then begin
      Hand.FPlayersCntAtFlop:= nWinnerCandidates;
    end;//

    if Hand.RoundID = 2 then begin
      nPlrsAtFlop:= Round((nWinnerCandidates/Hand.PlayersCntAtStartOfHand)*100);
      if FTable.FPlayedHands > 1 then begin
        FTable.AvgPlayersAtFlop:= Round((FTable.AvgPlayersAtFlop*(FTable.FPlayedHands-1)+nPlrsAtFlop)/FTable.FPlayedHands);
      end else begin
        FTable.AvgPlayersAtFlop:= nPlrsAtFlop;
      end;//if
    end;//

  //prepare combinations
    if IsShowdownRound then begin //calc gamer combinations
      CalcGamersShowDownCombinations;
      DefineAndReconcileHandWinners();
    end;//if

  //define active gamer or next stage
    DefineNextStageInHand;
    Result:= True;
  except
    on e: EpoException do raise;
    on e: Exception do begin
      DumpCachedStateToFile;
      CommonDataModule.Log(ClassName, 'NewRound',
        'EXCEPT block of try catch was occured: ' + e.Message + '; State was dumped.', ltException);
    end;
  end;//
end;


procedure TpoSingleTableCroupier.SetupGamersActions;
begin
  Gamers.ActiveGamerActions:= CpoWatcherActions;
end;

function TpoSingleTableCroupier.StartHand(nHandID: Integer): Boolean;
begin
  Result := True;
  try
    // Clear additionals prop BS
    ClearAllGamersShowDownPassedAndFinishTournament;

    DefineGamersAndDealerForCurrentHand;
    if Assigned(OnHandStarted) then OnHandStarted(Self, nHandID);

    Hand.Start(nHandID);
    Hand.PlayersCntAtStartOfHand:= ReadyToPlayChairsCount();

    if (Hand.State = HST_RUNNING) AND Assigned(OnHandStart) then OnHandStart(Self);

    { tournament ante after ProcState but before newround}
    MandatoryAnteStakeOnStartHand;

    NewRound();
    Result:= True;
  except
    on E: EpoException do raise;
    on e: Exception do begin
      DumpCachedStateToFile;
      CommonDataModule.Log(ClassName, 'StartHand',
        'EXCEPT block of try catch was occured: ' + e.Message + '; State was dumped.', ltException);
    end;
  end;//
end;

function TpoSingleTableCroupier.Store(aWriter: TWriter): Boolean;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteInteger(Integer(FPokerType));
  aWriter.WriteInteger(Integer(FStakeType));
  aWriter.WriteBoolean(FRoundHasFinished);
  aWriter.WriteBoolean(FHandIsStartedFromIdle);
  aWriter.WriteInteger(FMinGamersForStartHand);
end;

function TpoSingleTableCroupier.TableIsReadyForHand: Boolean;
begin
  if (TournamentType = TT_NOT_TOURNAMENT) and FHandIsStartedFromIdle then begin
    Result := (ReadyToPlayChairsCount() >= FMinGamersForStartHand)
  end else begin
    Result := (ReadyToPlayChairsCount() >= 2);
  end;
end;

{ TpoSettlementAccounts }


{ TpoPotAccounts }

function TpoPotSettlementAccounts.AddSidePot: TpoPotSettlementAccount;
begin
  Result:= AddAccount(TpoPotSettlementAccount.Create(
      ACC_POT_PREFIX+IntToStr(Count), POT_ACCOUNT_TYPE, AC_DEFAULT
  )) as TpoPotSettlementAccount;
  Result.OnPotReconcileOperation:= Fpot.FHand.FTable.FCroupier.OnPotReconcileOperation;
end;

function TpoPotSettlementAccounts.GetAccountClass: TpoAccountClass;
begin
  Result:= TpoPotSettlementAccount;
end;

function TpoPotSettlementAccounts.GetBalance: Integer;
var
  I: Integer;
begin
  Result:= 0;
  for I:= 0 to Count-1 do begin
    Result:= Result+Accounts[I].Balance;
  end;//for
end;

function TpoPotSettlementAccounts.ActiveSidePot: TpoPotSettlementAccount;
begin
  if Count = 0 then  AddSidePot;
  Result:= FAccounts[Count-1] as TpoPotSettlementAccount;
end;

function TpoSingleTableCroupier.GetMoveBetsContext(nRoundID: Integer): String;
begin
  if nRoundID = UNDEFINED_ROUND_ID then nRoundID := Hand.RoundID;
  Result:= 'movebets#'+IntToStr(nRoundID);
end;

function TpoSingleTableCroupier.HandToBeContinued: Boolean;
begin
  Result:= (Hand.State = HST_RUNNING) AND (WinnerCandidatesCount >= 1); //1/29/2004
  if Result and IsShowdownRound then begin
    Result := NOT AllChairsShowDownPassed();
  end;
end;

function TpoSingleTableCroupier.HandleGamerBack(aGamer: TpoGamer): TpoGamer;
var
  nStartingTimeout: Integer;
  sStartingMessage: String ;

begin
  Result:= aGamer;
  if Assigned(OnGamerAction) then OnGamerAction(aGamer, GA_BACK, []);

  aGamer.IsTakedSit := True;

  case Hand.State of
    HST_RUNNING:
      begin
        Result.PassCurrentHand:= True;
        Result.IsSitOut:= False;
        Result.State:= GS_IDLE;
      end;//HST_RUNNING:

    HST_STARTING:
      begin
        Result.PassCurrentHand:= False;
        Result.IsSitOut:= False;
        Result.State:= GS_IDLE;
      end;//HST_STARTING:

    HST_IDLE, HST_FINISHED:
      begin
        Result.PassCurrentHand:= False;
        Result.IsSitOut:= False;
        Result.State:= GS_IDLE;
        if (PokerClass = PTC_OPEN_CARDS_POKER) AND
          ChairIsReadyToPlay(aGamer.Chair) AND
          (ReadyToPlayChairsCount() = 1)
        then begin
          Hand.DealerChairID:= aGamer.ChairID;
        end;//if

        if TableIsReadyForHand then begin
          Hand.State := HST_STARTING;
          nStartingTimeout:= GetNextHandStartingTimeout();

          if Chairs.GetFreeChairsCount = 0 then sStartingMessage:= 'Let''s go'
          else sStartingMessage:= Format('Game will be started after %d seconds', [nStartingTimeout]);
          SendMessage(sStartingMessage);

          if Assigned(OnHandStarting) then OnHandStarting(Self, nStartingTimeout);
        end;//
      end;//HST_IDLE:
  end;//case
end;

function TpoSingleTableCroupier.HandleGamerCheck(aGamer: TpoGamer): TpoGamer;
begin
  Result:= aGamer;
  CheckIfHandIsRunning('{F6650281-8642-408B-853A-86483D59EA0C}');
  Result.FLastActionInRound:= GA_CHECK;
  if Assigned(OnGamerAction) then OnGamerAction(aGamer, Result.FLastActionInRound, []);
  DefineNextStageInHand;
end;

function TpoSingleTableCroupier.FinishRound: Boolean;
var
  bHandContinue: Boolean;
  nWinnerCandidatesCnt: Integer;
begin
  Result:= False;
  try
    if Hand.RoundID = UNDEFINED_ROUND_ID then Exit;
    bHandContinue:= HandToBeContinued();
    nWinnerCandidatesCnt:= WinnerCandidatesCount();
    if (Hand.RoundID = 1) and (nWinnerCandidatesCnt <= 1) then begin
      Hand.NoFlopNoDropRuleActive:= True;
    end;//if

    //open cards for all ins-if there is no further betting
    if (StepRightChairsCount <= 1) AND (nWinnerCandidatesCnt > 1) then TurnCardsOfGamersOver();

    if (NOT IsPreliminaryRound()) OR (PokerClass = PTC_CLOSED_CARDS_POKER) OR (nWinnerCandidatesCnt <= 1) then begin
      if NOT IsShowDownRound then begin
        MoveRoundBetsToPot;
        { Move Table Fracs to main pot }
        if Hand.Pot.SidePots.Count > 0 then begin
          if FTable.ValueOfFracsToNextHand > 1 then begin
            Hand.Pot.SidePots.Accounts[0].AddFunds(Trunc(FTable.ValueOfFracsToNextHand*100));
            FTable.ValueOfFracsToNextHand := FTable.ValueOfFracsToNextHand - Trunc(FTable.ValueOfFracsToNextHand*100)/100;
          end;
        end;
        //
        ChargeRakes();
      end;//if

      if bHandContinue AND (nWinnerCandidatesCnt > 1) then begin
        DealCommunityCards();
      end;//if

      if IsShowdownRound then begin
        if Assigned(OnPotReconcileFinish) then OnPotReconcileFinish(0, GetHandReconcileContext());
      end;//if

      if Assigned(OnRoundFinish) then OnRoundFinish(self);
    end;//if

    if bHandContinue AND (Hand.RoundID < RoundsInHand) then begin
      NewRound();
    end else begin
      FinishHand();
    end;//if

    Result:= True;
  except
    on E: EpoException do raise;
    on e: Exception do begin
      DumpCachedStateToFile;
      CommonDataModule.Log(ClassName, 'FinishRound',
        'EXCEPT block of try catch was occured: ' + e.Message + '; State was dumped.', ltException);
    end;
  end;//
end;//TpoGenericCroupier.FinishRound

function TpoSingleTableCroupier.HandleGamerPostSB(aGamer: TpoGamer;
  nStake: Integer): TpoGamer;
begin
  Result:= aGamer;
  CheckIfHandIsRunning('{5C62067F-556E-4355-AA18-2C4AC4779EF4}');
  if PokerClass = PTC_CLOSED_CARDS_POKER then begin
    CommonDataModule.Log(ClassName, 'HandleGamerPostSB', 'Unsupported action (postsb) for this poker type', ltError);
    EscalateFailure(
      EpoSessionException,
      aGamer.SessionID,
      'Unsupported action (postsb) for this poker type',
      '{BE41BC04-DDDF-4722-BB09-A153991E4E6F}'
    );
  end;//

  Result.FLastActionInRound:= GA_POST_SB;
  nStake:= HandleStake(aGamer, nStake);
  Hand.FSmallBlindChairID:= aGamer.ChairID;

  if Assigned(OnGamerAction) then OnGamerAction(aGamer, Result.FLastActionInRound, [nStake]);
  DefineNextStageInHand;
end;

function TpoSingleTableCroupier.HandleStake(aGamer: TpoGamer; nStake: Integer; nDirectPotAmount: Integer): Integer;
var
  ga: TpoUserSettlementAccount;
begin
  if (aGamer.Account.Balance <= 0) then begin
    CommonDataModule.Log(ClassName, 'HandleStake', 'Gamer ('+aGamer.UserName+') has no money on his account.',
      ltError);
    EscalateFailure(
      EpoSessionException,
      aGamer.UserID,
      'Gamer ('+aGamer.UserName+') has no money on his account.',
      '{42A56B07-9E59-4A53-9E23-F9622E5050C6}'
    );
  end;//if

  nStake:= nStake;//- nDirectPotAmount;
  ga:= Hand.Pot.Bets.GetAccountByUserID(aGamer.UserID) as TpoUserSettlementAccount;

  if ga = nil then begin
    CommonDataModule.Log(ClassName, 'HandleStake', 'Gamer (userid: '+IntToStr(aGamer.UserID)+') account not found', ltError);
    CommonDataModule.Log(ClassName, 'HandleStake', '-- Pot Bets Dump: --', ltError);
    CommonDataModule.Log(ClassName, 'HandleStake', Hand.Pot.Bets.Dump, ltError);

    EscalateFailure(
      EpoSessionException,
      aGamer.UserID,
      'Gamer bet account ('+aGamer.UserName+') not found.'+
      Hand.Pot.Dump,
      '{9E30F21C-77AF-425F-8AA0-D6C0893ECFE4}'
    );
  end;//if

  if nStake > 0 then begin
    if nStake >= aGamer.Account.Balance then begin
      nStake := aGamer.Account.Balance;
      ga.State:= AS_ALL_IN;
      aGamer.State:= GS_ALL_IN;
      Gamers.AllInsCount:= Gamers.AllInsCount+1;
      aGamer.AllInOrder:= Gamers.AllInsCount;

//bot post on all in
      PostRandomAnswerOnCategory(aGamer, BCP_GOES_ALL_IN);

    end;//if
    Hand.Pot.MoveMoney(
      aGamer.Account,
      ga,
      nStake,
      GetBettingTxContextName(aGamer.UserID)
    );
  end;//if



  Result:= nStake;
end;

function TpoSingleTableCroupier.AllPlayersHaveMadeActionsInRound(): Boolean;
var
  I: Integer;
  g: TpoGamer;
begin
  Result:= True;

//if only one gamer in game
  if (NOT IsShowdownRound) then begin
    if (StepRightChairsCount <= 1) AND (Hand.Pot.BetsAreBalanced()) then begin
      Exit;
    end;//if
  end;

  if (IsShowdownRound) then begin
    if AllChairsShowDownPassed() then Exit;
  end;

  if (StepRightChairsCount = 1) AND (IsShowdownRound) then begin
    g:= DefineFirstWinnerCandidate();
    if (g = nil) OR (g.Cards.Count = 0) then Exit;
  end;//if

//usual case - many players
  for I:= 0 to Chairs.Count-1 do begin
    if Chairs[I].Gamer = nil then Continue;
    if NOT ChairCanTakeStepRight(Chairs[I]) then Continue;

    if ChairCanTakeStepRight(Chairs[I]) AND (Chairs[I].Gamer.LastActionInRound = GA_NONE) then begin
      Result:= False;
      Exit;
    end;//if

    if (PokerClass = PTC_OPEN_CARDS_POKER) AND IsPreliminaryRound then begin
      if (Hand.SmallBlindGamer <> nil) AND (Hand.BigBlindGamer <> nil) AND (NOT Chairs[I].Gamer.MustSetBigBlind) then Continue
      else begin
        Result:= False;
        Exit;
      end;//
    end;//
    Result:= Result AND (Chairs[I].Gamer.LastActionInRound IN [GA_POST_SB..GA_BRING_IN]);
  end;//for
  if NOT Result then Exit;
  if (PokerClass = PTC_OPEN_CARDS_POKER) AND (Hand.RoundID = 1) then begin
    Result:= Result AND (Hand.BigBlindGamer <> nil) AND (Hand.BigBlindGamer.LastActionInRound <> GA_POST_BB);
  end;//if
end;//


procedure TpoSingleTableCroupier.DefineNextStageInHand;


  function RoundIsToBeFinished(): Boolean;
  begin
    if IsPreliminaryRound() AND (NOT TableHasPreliminaryRound()) then begin
      Result:= True;
      Exit;
    end;//if
    Result:= AllPlayersHaveMadeActionsInRound();
    if NOT Result then Exit;
    case PokerClass of
      PTC_OPEN_CARDS_POKER:
        begin
          if (NOT IsPreliminaryRound) AND (NOT IsShowdownRound) then begin
            Result:= (Result AND Hand.Pot.BetsAreBalanced()) OR (StepRightChairsCount = 0);
          end;//if
        end;//if

      PTC_CLOSED_CARDS_POKER:
        begin
          if IsPreliminaryRound AND (NOT TableHasAnte) then begin
            Result:= True;
            Exit;
          end;//
          if (NOT IsShowDownRound) then Result:= (Result AND Hand.Pot.BetsAreBalanced()) OR (StepRightChairsCount = 0);
        end;//
    end;//case
  end;//

var
  nAction: TpoGamerAction;
  aActiveGamer: TpoGamer;
  va: TpoGamerActions;

begin
  aActiveGamer:= nil;
//detect end-round situation due gamers state
  if NOT HandToBeContinued() then begin
    FinishRound();
    Exit;
  end;//

//detect end-round situation due stakes
  if RoundIsToBeFinished() then FinishRound()
  else begin
    aActiveGamer:= DefineActiveGamer();
    if (aActiveGamer <> nil) then begin
      va:= GetValidGamerActions(aActiveGamer);

    //check for autoactions
      nAction:= SelectServerGamerAutoAction(aActiveGamer);
      if nAction <> GA_NONE then begin
        if Assigned(OnPrepareReorderedPackets) then OnPrepareReorderedPackets(aActiveGamer);
        ClearTurnLevelGamerAutoActions(aActiveGamer);
        InvokeGamerAction(aActiveGamer, nAction, []);
      end else begin
        if Hand.ActiveGamer <> nil then begin
          if (Hand.ActiveGamer.State = GS_SITOUT) then begin
            if Assigned(OnPrepareReorderedPackets) then OnPrepareReorderedPackets(aActiveGamer);
            HandleGamerActionExpired(Hand.ActiveGamer);
          end;//
          if (Hand.State = HST_RUNNING) AND (Hand.ActiveGamer <> nil) AND
            IsShowdownRound() then
          begin
            aActiveGamer := Hand.ActiveGamer;
            if ((aActiveGamer.State = GS_ALL_IN) OR aActiveGamer.FTurnedCardsOver) OR
               (va = [GA_SHOW_CARDS])
            then begin
              if Assigned(OnPrepareReorderedPackets) then OnPrepareReorderedPackets(aActiveGamer);
              HandleGamerShowCards(Hand.ActiveGamer);
            end else
            if (GA_MUCK in va) and (GAA_MUCK_LOSING_HANDS in aActiveGamer.FAutoActions) then begin
              if Assigned(OnPrepareReorderedPackets) then OnPrepareReorderedPackets(aActiveGamer);
              HandleGamerMuck(Hand.ActiveGamer);
            end else
            if (GA_DONT_SHOW in va) and (GAA_MUCK_LOSING_HANDS in aActiveGamer.FAutoActions) then begin
              if Assigned(OnPrepareReorderedPackets) then OnPrepareReorderedPackets(aActiveGamer);
              HandleGamerDontShowCards(Hand.ActiveGamer);
            end;
          end;//if
        end;//
      end;//if
    end else begin //abnormal situation - there is no active player
      EscalateFailure(
        EpoException,
        'There is no active player detected',
        '{6C903FE6-1664-41A3-98EC-3F1B0DCE31D1}'
      );
    end;//if
  end;//if

  if (aActiveGamer <> nil) AND (Hand.State = HST_RUNNING) then begin
    aActiveGamer.FLastTimeActivity := Now;
    if Assigned(OnSetActivePlayer) then OnSetActivePlayer(Self);
  end;//if
end;


function TpoSingleTableCroupier.HandleGamerPostBB(aGamer: TpoGamer;
  nStake: Integer): TpoGamer;
begin
  Result:= aGamer;
  CheckIfHandIsRunning('{FC722AE2-4942-47ED-8D99-555CCC59B439}');
  Result.FLastActionInRound:= GA_POST_BB;

  Result.MustSetBigBlind:= False;
  Result.MustSetPost:= False;
  Result.MustSetPostDead:= False;
  Result.WaitForBigBlind:= False;
  Result.ClearSkippedBlinds();

  nStake:= HandleStake(aGamer, nStake);
  Hand.RegisterRaise(nStake);//small blinds and post are not calculated in BB raise

  Hand.FBigBlindChairID:= aGamer.ChairID;

  if Assigned(OnGamerAction) then begin
    OnGamerAction(aGamer, Result.FLastActionInRound, [nStake]);
  end;//if
  DefineNextStageInHand;
end;


function TpoSingleTableCroupier.HandleGamerCall(aGamer: TpoGamer;
  nStake: Integer): TpoGamer;
begin
  Result:= aGamer;
  CheckIfHandIsRunning('{CD2A398D-F0C9-4CCB-9747-F023FBE2EE29}');
  Result.FLastActionInRound:= GA_CALL;
  nStake:= HandleStake(aGamer, nStake);
  if Assigned(OnGamerAction) then OnGamerAction(aGamer, Result.FLastActionInRound, [nStake]);
  DefineNextStageInHand;
end;


function TpoSingleTableCroupier.HandleGamerRaise(aGamer: TpoGamer;
  nStake: Integer): TpoGamer;
var
  nRaiseAmount: Integer;
begin
  Result:= aGamer;
  CheckIfHandIsRunning('{880A345F-2A85-44C9-ADE4-3344F0FB181A}');
  Result.FLastActionInRound:= GA_RAISE;

  nRaiseAmount:= GetCallStakeValue(aGamer);
  nStake:= HandleStake(aGamer, nStake);
  Hand.RegisterRaise(nStake-nRaiseAmount);

//register point chair
  if IsLastBettingRound then Hand.FLastBettingRoundRaiseChair:= aGamer.ChairID;

  if Assigned(OnGamerAction) then OnGamerAction(aGamer, Result.FLastActionInRound, [nStake]);
  DefineNextStageInHand();
end;

procedure TpoSingleTableCroupier.MoveRoundBetsToPot;
var
  I: Integer;
  sContext: String;
  acc: TpoUserSettlementAccount;
  usa: TpoUserSettlementAccount;
  nMinBetAmount: Integer;
  g: TpoGamer;
  bBetsMoveIsPerformed: Boolean;
  CntIter: Integer;
begin
  sContext:= GetMoveBetsContext(Hand.RoundID);
  bBetsMoveIsPerformed:= False;

  CntIter := -2;
  while NOT Hand.Pot.Bets.AllAreBalanced do begin
    //handle return
    if Hand.Pot.Bets.UnbalancedAccountCount() = 1 then begin
      usa:= Hand.Pot.Bets.FindFirstUnbalancedAccount;
      g:= Gamers.GamerByUserID(usa.UserID);

      //return money
      Hand.Pot.MoveMoney(
        usa, g.Account, usa.Balance, sContext, 'return'
      );
      bBetsMoveIsPerformed:= True;
      //
      Break; //go out of cycle
    end;//handle return

    //handle multiple unbalanced accounts
    nMinBetAmount:= Hand.Pot.Bets.GetMinBalance();

    if nMinBetAmount = 0 then Break;

    if Hand.Pot.SidePots.ActiveSidePot.HasAllInSubAccounts then  begin
      Hand.Pot.SidePots.AddSidePot;
    end;//

    for I:= 0 to Hand.Pot.Bets.Count-1 do begin
      acc:= Hand.Pot.Bets[I] as TpoUserSettlementAccount;
      if acc.IsBalanced then Continue;
      Hand.Pot.MoveMoney(
        acc, Hand.Pot.SidePots.ActiveSidePot, Min(nMinBetAmount, acc.Balance), sContext
      );

      bBetsMoveIsPerformed:= True;
    end;//for

    Inc(CntIter);
    if (CntIter > (Hand.Pot.Bets.Count + 1)) then begin
      CommonDataModule.Log(ClassName, 'MoveRoundBetsToPot',
        '[WARNING-CIRCLE] Count of iterations in WHILE statement more then needing. Iterations count=' + IntToStr(CntIter) + ', Hand.Pot.Bets.Count=' + IntToStr(Hand.Pot.Bets.Count) +
          'Dialer=' + IntToStr(Hand.DealerChairID) + ', Active=' + IntToStr(Hand.FActiveChairID) +
          ', SmallBlind' + IntToStr(Hand.FSmallBlindChairID) + ', BigBlind=' + IntToStr(Hand.FBigBlindChairID) +
          ', HandID=' + IntToStr(Hand.HandID) + ', Round=' +IntToStr(Hand.RoundID),
        ltError
      );
      EscalateFailure(
        EpoException,
        'Count of iterations in WHILE statment more then needing. Iteration count=' + IntToStr(CntIter) + ', Hand.Pot.Bets.Count=' + IntToStr(Hand.Pot.Bets.Count),
        '{BDC35806-0295-4391-AFD8-D3D356D038B9}'
      );
    end;
  end;//while

  //notify gamers about
  if bBetsMoveIsPerformed then begin
    if Assigned(OnMoveBets) then OnMoveBets(sContext);
  end;//
end;//TpoGenericCroupier.MoveRoundBetsToPot

procedure TpoSingleTableCroupier.DefineAndReconcileHandWinners;
var
  I, J: Integer;
  g, wg: TpoGamer;
  nGamerIDs: TpoUserIDs;
  cc: TpoCombinations;
  nPotAmount: Currency;
begin
//update stats
  nPotAmount:= Hand.Pot.TotalAmount() / 100; // internal amount value is: Integer = RealAmount_Currency*100
  if FTable.FPlayedHands > 0 then begin
    FTable.AveragePot:=
      (FTable.AveragePot*(FTable.FPlayedHands-1)+nPotAmount)/FTable.FPlayedHands;
   end else FTable.AveragePot:= nPotAmount;
  ;
//
  SetLength(nGamerIDs, 0);
//define winners and rearrange their accounts
  if WinnerCandidatesCount() = 1 then begin
    g:= DefineFirstWinnerCandidate();
    for I:= 0 to Hand.Pot.SidePots.Count-1 do begin
      Hand.Pot.SidePots[I].RegisterWinner(g, True);
    end;//for
  end else begin
    cc:= TpoCombinations.Create(FTable.Cards);
    for I:= 0 to Hand.Pot.SidePots.Count-1 do begin
      cc.Clear;
      nGamerIDs:= Hand.Pot.SidePots[I].GetPlayingUserIDs;
    //handle hi combinations
      for J:= Low(nGamerIDs) to High(nGamerIDs) do begin
        g:= Gamers.GamerByUserID(nGamerIDs[J]);
        cc.AddCombination(g.FCombinations.BestCombination(True)).Gamer:= g;
      end;//for
      cc.SelectWinnerCombinations(True);
      for J:= 0 to cc.Count-1 do begin
        wg:= cc[J].Gamer; //cc.BestCombination(True).Gamer;
        wg.WinnerNominations:= wg.WinnerNominations+[WNT_HI_COMBINATION];
        Hand.Pot.SidePots[I].RegisterWinner(wg, True);
      end;//for

    //handle lo combinations if required
      if PokerType IN [PT_OMAHA_HILO, PT_SEVEN_STUD_HILO] then begin
        cc.Clear;
        for J:= Low(nGamerIDs) to High(nGamerIDs) do begin
          g:= Gamers.GamerByUserID(nGamerIDs[J]);
          if g.FCombinations.BestCombination(False) <> nil then begin
            cc.AddCombination(g.FCombinations.BestCombination(False)).Gamer:= g;
          end;//if
        end;//for
        cc.SelectWinnerCombinations(False);
        for J:= 0 to cc.Count-1 do begin
          wg:= cc[J].Gamer; //cc.BestCombination(False).Gamer;
          wg.WinnerNominations:= wg.WinnerNominations+[WNT_LO_COMBINATION];
          Hand.Pot.SidePots[I].RegisterWinner(wg, False);
        end;//for
      end;//if
    end;//for
    cc.Clear;
    cc.Free;
  end;//if

//settle winners
  Hand.Pot.ReconcileWinners(GetHandReconcileContext());
end;

function TpoSingleTableCroupier.GetHandReconcileContext: String;
begin
  Result:= 'handreconcile:#'+IntToStr(Hand.HandID);
end;

function TpoSingleTableCroupier.HandleGamerFold(aGamer: TpoGamer; bAutoAction: Boolean): TpoGamer;
var
  s: string;
begin
  Result:= aGamer;
  CheckIfHandIsRunning('{C287C36D-403A-446A-9BDD-693BEBE45B3D}');
  Hand.Pot.FoldGamerAccounts(aGamer.UserID);

  Result.FLastActionInRound := GA_FOLD;
  Result.ShowDownPassed := True;
  if Assigned(OnGamerAction) then OnGamerAction(aGamer, Result.FLastActionInRound, []);

  if bAutoAction then begin
    if aGamer.State = GS_PLAYING then begin
      aGamer.State:= GS_SITOUT;
      if Assigned(OnGamerSitOut) then OnGamerSitOut(aGamer);
    end;//
  end;//if

  if (aGamer.State IN [GS_PLAYING, GS_SITOUT]) then aGamer.State:= GS_FOLD;
  s := aGamer.Cards.FormSeries(False);
  aGamer.Cards.Clear;
  DefineNextStageInHand; //active player or finish hand
end;

function TpoSingleTableCroupier.HandleGamerBet(aGamer: TpoGamer;
  nStake: Integer): TpoGamer;
var
  nRaiseAmount: Integer;
begin
  Result:= aGamer;
  CheckIfHandIsRunning('{64F6FAB2-FD18-4FBB-8B2C-C61420B64467}');
  Result.FLastActionInRound:= GA_BET;

  nRaiseAmount:= Hand.Pot.Bets.GetMaxBalance;
  nStake:= HandleStake(aGamer, nStake);
  Hand.RegisterRaise(nStake-nRaiseAmount);

//register
  if IsLastBettingRound then Hand.FLastBettingRoundBetChair:= aGamer.ChairID;

  if Assigned(OnGamerAction) then OnGamerAction(aGamer, Result.FLastActionInRound, [nStake]);
  DefineNextStageInHand;
end;

function TpoSingleTableCroupier.HandleGamerShowCards(
  aGamer: TpoGamer): TpoGamer;
var
  sMsg: String;
  ghc, glc: TpoCardCombination;

begin
  Result:= aGamer;
  if aGamer.ShowDownPassed or not IsShowdownRound then Exit;

  Result.FLastActionInRound:= GA_SHOW_CARDS;
  Result.ShowCardsAtShowdown:= True;
  Result.ShowDownPassed:= True;
  if (Result.Combinations.Count = 0) then begin
  //abnormal hand termination - there is no cards
  //to form combination
  end else begin
    if PokerType IN [PT_OMAHA_HILO, PT_SEVEN_STUD_HILO] then begin
      //check for high
        ghc:= Result.Combinations.BestCombination(True);
        if (Hand.FBestHiCombination.CompareTo(ghc) = CC_EQUAL) AND
          (Hand.FBestHiCombination.UserID <> aGamer.UserID)
        then begin
          sMsg:= aGamer.UserName+' shows the same hand';
        end else begin
          sMsg:= aGamer.UserName+' shows '+ghc.ToString;

          if ghc.CompareTo(Hand.FBestHiCombination) = CC_GREATER then begin
            if ghc.Description <> '' then sMsg:= sMsg+' - '+aGamer.FCombinations.BestCombination(True).Description;
            Hand.FBestHiCombination.AcquireCombination(ghc).UserID:= aGamer.UserID;
          end else begin
            if Hand.FBestHiCombination.Description <> '' then sMsg:= sMsg+' - lower kicker';
          end;//if
        end;//if
        SendMessage(sMsg);

      //check for low
        glc:= Result.Combinations.BestCombination(False);
        if (glc <> nil) then begin

          if (Hand.FBestLoCombination.CompareTo(glc) = CC_EQUAL) AND
            (Hand.FBestLoCombination.UserID <> aGamer.UserID)
          then  begin
            sMsg:= aGamer.UserName+' shows the same hand for low';
          end else begin
            if glc.LoBetterOrEqual(Hand.FBestLoCombination) then begin
              Hand.FBestLoCombination.AcquireCombination(glc).UserID:= aGamer.UserID;
            end;//
            sMsg:= aGamer.UserName+' shows '+glc.FormLoSeries +' for low';
          end;//if
          SendMessage(sMsg);
        end;

    end else begin
      ghc:= Result.Combinations.BestCombination(True);
      if (Hand.FBestHiCombination.CompareTo(ghc) = CC_EQUAL) AND
        (Hand.FBestHiCombination.UserID <> aGamer.UserID)
      then  begin
        sMsg:= aGamer.UserName+' shows the same hand';
      end else begin
        sMsg:= aGamer.UserName+' shows '+ghc.ToString;

        if (Hand.FBestHiCombination.UserID <> aGamer.UserID) then begin
          if ghc.CompareTo(Hand.FBestHiCombination) = CC_GREATER then begin
            if ghc.Description <> '' then sMsg:= sMsg+' - '+ghc.Description;
            Hand.FBestHiCombination.AcquireCombination(ghc).UserID:= aGamer.UserID;
          end else begin
            if (Hand.FBestHiCombination.Description <> '') then sMsg:= sMsg+' - lower kicker';
          end;//if
        end;//if

      end;//if
      SendMessage(sMsg);
    end;//if
  end;//if

  if Assigned(OnGamerAction) AND (NOT aGamer.FTurnedCardsOver) then OnGamerAction(aGamer, Result.FLastActionInRound, []);
  DefineNextStageInHand; //active player or finish hand
end;

function TpoSingleTableCroupier.HandleGamerDontShowCards(
  aGamer: TpoGamer): TpoGamer;
begin
  Result:= aGamer;
  if aGamer.ShowDownPassed or not IsShowdownRound then Exit;

  Result.FLastActionInRound:= GA_DONT_SHOW;
  Result.ShowDownPassed:= True;
  if Assigned(OnGamerAction) then OnGamerAction(aGamer, Result.FLastActionInRound, []);
  DefineNextStageInHand; //active player or finish hand
end;

function TpoSingleTableCroupier.HandleGamerMuck(aGamer: TpoGamer): TpoGamer;
begin
  Result:= aGamer;
  if aGamer.ShowDownPassed or not IsShowdownRound then Exit;
  
  Result.FLastActionInRound:= GA_MUCK;
  Result.ShowDownPassed:= True;
  if Assigned(OnGamerAction) then OnGamerAction(aGamer, Result.FLastActionInRound, []);
  DefineNextStageInHand; //active player or finish hand
end;

function TpoSingleTableCroupier.HandleGamerPost(aGamer: TpoGamer;
  nStake: Integer): TpoGamer;
begin
  Result:= aGamer;
  CheckIfHandIsRunning('{3742BE50-867F-43FC-8CDC-30FED9FDCC39}');

  Result.MustSetBigBlind:= False;
  Result.MustSetPost:= False;
  Result.MustSetPostDead:= False;
  Result.WaitForBigBlind:= False;
  Result.ClearSkippedBlinds();

  Result.LastActionInRound:= GA_POST;
  nStake:= HandleStake(aGamer, nStake);

  if Assigned(OnGamerAction) then OnGamerAction(aGamer, Result.FLastActionInRound, [nStake]);
  DefineNextStageInHand;
end;

function TpoSingleTableCroupier.GetValidGamerActions(
  aGamer: TpoGamer): TpoGamerActions;
begin
  Result:= FTable.FGamers.FWatcherActions;
  if aGamer.IsActive then begin
//common
    Result:= FTable.FGamers.FActiveGamerActions;
    if NOT aGamer.HasBets then Result:= Result+[GA_SIT_OUT]
    else begin
      Result:= Result-[GA_SIT_OUT];
      Result:= Result+[GA_FOLD];
    end;//if

//open cards specific
    if PokerClass = PTC_OPEN_CARDS_POKER then begin
      if aGamer.MustSetPostDead AND (aGamer <> FindBigBlindCandidate()) then Result:= Result+[GA_POST_DEAD, GA_SIT_OUT, GA_WAIT_BB]-[GA_POST]
      else
      if (aGamer.MustSetPost) AND (NOT aGamer.MustSetPostDead) AND (aGamer <> FindBigBlindCandidate()) then Result:= Result+[GA_POST, GA_SIT_OUT, GA_WAIT_BB]-[GA_POST_DEAD]
      else
      if Hand.FSmallBlindChairID = UNDEFINED_POSITION_ID then Result:= Result+[GA_POST_SB, GA_SIT_OUT]
      else
      if Hand.FBigBlindChairID = UNDEFINED_POSITION_ID then Result:= Result+[GA_POST_BB, GA_SIT_OUT]
      else begin
        if Hand.Pot.Bets.GetMaxBalance = 0 then Result:= Result+[GA_CHECK, GA_BET]-[GA_RAISE]
        else begin
          if Hand.Pot.BetsAreBalanced then Result:= Result+[GA_CHECK]
          else begin
            if GetCallStakeValue(aGamer) > 0 then Result:= Result+[GA_CALL]
            else Result:= Result+[GA_CHECK];
          end;//if
          if (NOT MaxBetLimitIsReached(aGamer)) then Result:= Result+[GA_RAISE];
        end;//if
      end;//if

      if (Hand.FSmallBlindChairID <> UNDEFINED_POSITION_ID) AND
         (Hand.FBigBlindChairID <> UNDEFINED_POSITION_ID)
      then begin
        Result:= Result-[GA_SIT_OUT]+[GA_FOLD];
      end;//if

    end else begin
//closed cards
      if IsPreliminaryRound then begin
        Result:= Result+[GA_ANTE, GA_SIT_OUT]
      end else begin
        if Hand.Pot.Bets.GetMaxBalance = 0 then begin
          Result:= Result+[GA_BET]-[GA_RAISE];
          if (Hand.FRoundID = 1) AND (aGamer.IsFirstInRaund) then begin
            Result:= [GA_BET, GA_BRING_IN];
          end;
          if (Hand.RoundID > 1) AND Hand.Pot.BetsAreBalanced then Result:= Result+[GA_CHECK];

        //handle special case:
        //2-nd round and Hi betting is applicable
          if (Hand.RoundID = 2) AND (Hand.FHiBettingCanBeUsed) then begin
            Result:= Result+[GA_RAISE];
          end;//if
        end else begin
          if Hand.Pot.BetsAreBalanced then Result:= Result+[GA_CHECK]
          else begin
            if GetCallStakeValue(aGamer) > 0 then Result:= Result+[GA_CALL]
            else Result:= Result+[GA_CHECK];
          end;//if
          if (NOT MaxBetLimitIsReached(aGamer)) then Result:= Result+[GA_RAISE];

        //handle special case:
        //2-nd round and Hi betting is applicable
          if (Hand.RoundID = 2) then begin
            if GetCallStakeValue(aGamer) < GetBetStakeValue(aGamer) then Result:= Result+[GA_BET];
          end;//if
        end;//if
      end;//end of closed cards section
    end;

  //specials:
  //all-in issue
    if GA_RAISE IN Result then begin
      if (aGamer.Account.Balance - GetCallStakeValue(aGamer)) <= 0 then Result:= Result-[GA_RAISE];
      if StepRightChairsCount() = 1 then Result:= Result-[GA_RAISE];
    end;//if

//Showdown proprietary conditions
    if IsShowdownRound then begin
      if WinnerCandidatesCount = 1 then begin
        Result:= [GA_SHOW_CARDS, GA_DONT_SHOW];
        if PokerClass = PTC_CLOSED_CARDS_POKER then Result:= Result+[GA_SHOW_CARDS_SHUFFLED];
      end else begin
      //ranking conmbinations
        if (Hand.PrevGamerInRound = nil) then begin
          Result:= [GA_SHOW_CARDS];

          Hand.FBestHiCombination.AcquireCombination(aGamer.Combinations.BestCombination(True)).UserID:= aGamer.UserID;
          if PokerClass = PTC_CLOSED_CARDS_POKER then Result:= Result+[GA_SHOW_CARDS_SHUFFLED];

          if PokerType IN [PT_OMAHA_HILO, PT_SEVEN_STUD_HILO] then begin
            Hand.FBestLoCombination.AcquireCombination(aGamer.Combinations.BestCombination(False)).UserID:= aGamer.UserID;
          end;//if
        end else begin
        //!! check out for muck absence!!
          if aGamer.Combinations.BestCombination(True).HiBetterOrEqual(Hand.FBestHiCombination)
          then begin
            Result:= [GA_SHOW_CARDS];
          end else begin
            Result:= [GA_MUCK, GA_SHOW_CARDS];
          end;//if

          if PokerClass = PTC_CLOSED_CARDS_POKER then Result:= Result+[GA_SHOW_CARDS_SHUFFLED];

          if PokerType IN [PT_OMAHA_HILO, PT_SEVEN_STUD_HILO] then begin

            if (aGamer.Combinations.BestCombination(False) <> nil) AND  aGamer.Combinations.BestCombination(False).LoBetterOrEqual(Hand.FBestLoCombination)
            then begin
              Result:= Result-[GA_MUCK];
            end;//if
          end;//if
        end;//if
      end;//if
    end;//if

  end else
  if ChairCanTakeStepRight(aGamer.Chair) then begin
    Result:= FTable.FGamers.FInactiveGamerActions;
    if aGamer.HasBets then Result:= Result+[GA_FOLD];
  end else
  if aGamer.IsAtTheTable then begin

    Result:= FTable.FGamers.FWatcherActions;
    if aGamer.State = GS_SITOUT then Result:= Result+[GA_BACK]
    else Result:= Result+[GA_SIT_OUT]
  end else
  if aGamer.State = GS_SITOUT then Result:= Ftable.FGamers.FWatcherActions+[GA_BACK]
  else begin
    Result:= FTable.FGamers.FWatcherActions;
  end;//

//sitout correction
  if aGamer.IsSitOut then Result:= Result+[GA_BACK];
end;


function TpoSingleTableCroupier.FindSmallBlindGamer(): TpoGamer;
var
  ch: TpoChair;
  CntIter: Integer;
begin
  Result:= Hand.SmallBlindGamer;
  if Result = nil then begin
    if Hand.DealerChairID = UNDEFINED_POSITION_ID then Exit;
    if StepRightChairsCount = 2 then begin
      Result:= Hand.DealerGamer;
      Exit;
    end;//if
    ch:= Chairs[Hand.DealerChairID];
    CntIter := 0;
    repeat
      Inc(CntIter);
      if (CntIter > Chairs.Count) then Exit;
      ch:= FindStepRightChairLeftToPosition(ch.IndexOf, True);
      if ch = nil then Exit;
      if ((ch.Gamer.State = GS_SITOUT) OR (ch.Gamer.IsSitOut)) AND (NOT SitOutCanTakeStepRight) then begin
        ch.Gamer.FSkippedSBStake:= True;
        Continue;
      end;//if
      if (NOT ch.Gamer.MustSetPost) AND (NOT ch.Gamer.MustSetPostDead) then begin
        Result:= ch.Gamer;
        Exit;
      end;
      if ch.IndexOf = Hand.DealerChairID then begin
        EscalateFailure(
          EpoException,
          'Opening round gamer not found.',
          '{69EC6701-670E-4975-8DCB-1BB4630AE144}'
        );
      end;//
    until False;
  end;
end;//FindSmallBlindGamer

function TpoSingleTableCroupier.FindWinnerCandidateStepRightChairFromSet(
  nUserIDs: Array of Integer): TpoChair;
var
  I: Integer;
  chID: Integer;
  initChID: Integer;
  ch: TpoChair;
  CntIter: Integer;
begin
  Result:= nil;
  ch:= FindStepRightChairLeftToPosition(Hand.DealerChairID);
  if ch = nil then Exit;
  initChID:= ch.IndexOf;
  chID:= initChID;

  CntIter := -1;
  repeat
    Inc(CntIter);
    if (CntIter > (Chairs.Count + 1)) then begin
      CommonDataModule.Log(ClassName, 'FindWinnerCandidateStepRightChairFromSet',
      '[WARNING - CIRCLE]: Count of iterations in REPEAT statment more then needing. Iteration count=' + IntToStr(CntIter) + ', Chair count=' + IntToStr(Chairs.Count) +
        'Dialer=' + IntToStr(Hand.DealerChairID) + ', Active=' + IntToStr(Hand.FActiveChairID) +
        ', SmallBlind' + IntToStr(Hand.FSmallBlindChairID) + ', BigBlind=' + IntToStr(Hand.FBigBlindChairID) +
        ', HandID=' + IntToStr(Hand.HandID) + ', Round=' +IntToStr(Hand.RoundID),
      ltError);
      EscalateFailure(
        EpoException,
        'Count of iterations in REPEAT statment more then needing. Iteration count=' + IntToStr(CntIter) + ', Chair count=' + IntToStr(Chairs.Count),
        '{019B2F31-8546-4084-BDB0-5BACCD30FED7}'
      );
    end;

    for I:= 0 to High(nUserIDs) do begin
      if Chairs[chID].UserID = nUserIDs[I] then begin
        if Chairs[chID].Gamer.LastActionInRound <> GA_NONE then Continue;
        Result:= Chairs[chID];
        Exit;
      end;//for
    end;//for

    ch:= FindStepRightChairLeftToPosition(chID);
    if ch = nil then Exit;
    ChID:= ch.IndexOf;
  until chID = initChID;
end;//FindWinnerCandidateChairFromSet

function TpoSingleTableCroupier.DefineOpenRoundGamer: TpoGamer;
  function FindGamerNextToDealer(): TpoGamer;
  begin
    Result:= FindStepRightChairLeftToPosition(Hand.DealerChairID).Gamer;
  end;//FindGamerNextToDealer


  function FindGamerNextToBigBlind(): TpoGamer;
  begin
    Result:= Hand.BigBlindGamer;
    if Result = nil then begin
      EscalateFailure(
        EpoException,
        'Big blind position is not defined yet.',
        '{E62825A8-30E2-4929-A0AE-5B9C1DC8F874}'
      );
    end;//
    Result:= FindStepRightChairLeftToPosition(Result.ChairID).Gamer;
  end;//FindGamerNextToBigBlind

  function FindFirstAnteGamer(): TpoGamer;
  var
    ch: TpoChair;
  begin
    ch:= FindStepRightChairLeftToPosition(Chairs.Count-1);
    Result:= ch.Gamer;
  end;//

  function DefineLowestCardGamer(): TpoGamer;
  var
    I: Integer;
    cc: TpoCardCollection;
  begin
    Result:= nil;
    cc:= TpoCardCollection.Create(FTable.Cards);
    for I:= 0 to Chairs.Count-1 do begin
      if NOT ChairCanTakeStepRight(Chairs[I]) then Continue;
      cc.AttachCard(Chairs[I].Gamer.Cards.ExtractLowestCard(True)).CustomData:= I;
    end;//for
    if cc.Count > 0 then begin
      I:= cc.ExtractLowestCard(False).CustomData;
      Result:= Chairs[I].Gamer;
    end;//if
    cc.Free;
  end;//DefineLowestCardGamer

  function DefineBestCombinationGamer(nUserIDs: Array of Integer): TpoGamer;
  var
    ccp: TpoCardCombinationProcessor;
    I: Integer;
    cs: TpoCombinations;
    cc: TpoCardCombination;
    cmbs: TpoCombinations;

    function GamerIsAmongIDs(aGamer: TpoGamer; nUserIDs: Array of Integer): Boolean;
    var
      I, nLen: Integer;
    begin
      Result:= False;
      nLen:= Length(nUserIDs);
      if (aGamer = nil) OR (nLen = 0) then Exit;
      for I:= 0 to nLen-1 do begin
        if aGamer.UserID = nUserIDs[I] then begin
          Result:= True;
          Exit;
        end;//if
      end;//
    end;//GamerIsAmongIDs

  begin
    Result := nil;
    cs := nil;
    ccp := nil;
    try
      ccp:= TpoCardCombinationProcessor.Create(FTable.Cards);
      cs:= TpoCombinations.Create(FTable.Cards);
      cmbs:= TpoCombinations.Create(FTable.Cards);

    //fill combinations
      for I:= 0 to Chairs.Count-1 do begin
        if NOT ChairCanTakeStepRight(Chairs[I]) then Continue;
        if (Length(nUserIDs) > 0) AND (NOT GamerIsAmongIDs(Chairs[I].Gamer, nUserIDs)) then Continue;
        ccp.DetectCombinations(
          nil, Chairs[I].Gamer.Cards.ExtractOpenCards, cmbs
        );
        cs.AddCombination(cmbs.BestCombination(true, True).Clone()).Gamer:= Chairs[I].Gamer;
        cmbs.ClearAndFree();
      end;//for

    //select best combinations
      cc:= cs.BestCombination(True, True);
      Result:= cc.Gamer;

    //handle special case
      if (Hand.RoundID = 2) AND (cc.Kind = CCK_ONE_PAIR) then Hand.FHiBettingCanBeUsed:= True
      else Hand.FHiBettingCanBeUsed:= False;

    //free resources
      cmbs.ClearAndFree();
      cmbs.Free;
      cs.ClearAndFree();
      cs.Free;
      ccp.Free;
    except
    //free resources
      cmbs.ClearAndFree();
      cmbs.Free;
      cs.ClearAndFree();
      cs.Free;
      ccp.Free;
    end;//try
  end;//

  function GetShowDownOpenGamer(): TpoGamer;
  var
    ch: TpoChair;
  begin
    Result:= nil;

    if Hand.FLastBettingRoundRaiseChair <> UNDEFINED_POSITION_ID then Result:= Chairs[Hand.FLastBettingRoundRaiseChair].Gamer
    else
    if Hand.FLastBettingRoundBetChair <> UNDEFINED_POSITION_ID then Result:= Chairs[Hand.FLastBettingRoundBetChair].Gamer
    else begin
      case Pokertype of
        PT_TEXAS_HOLDEM,
        PT_OMAHA,
        PT_OMAHA_HILO:
          begin
            ch:= FindWinnerCandidateStepRightChairFromSet(
              Hand.Pot.SidePots.ActiveSidePot.GetPlayingUserIDs()
            );
            if ch <> nil then Result:= ch.Gamer;
          end;//

        PT_SEVEN_STUD,
        PT_SEVEN_STUD_HILO:
          begin
            Result:= DefineBestCombinationGamer(
              Hand.Pot.SidePots.ActiveSidePot.GetPlayingUserIDs()
            );
          end;//
      end;//case
    end;//
    if NOT ChairIsWinnerCandidate(Result.Chair) then begin
      Result:= FindStepRightChairLeftToPosition(Result.ChairID).Gamer;
    end;//if
  end;//GetShowDownOpenGamer

begin
  Result:= Hand.GetOpenRoundGamer;
  if Result = nil then begin
    if IsPreliminaryRound then begin //zero round
      case Pokertype of
        PT_TEXAS_HOLDEM,
        PT_OMAHA,
        PT_OMAHA_HILO:
          begin
            Result:= FindFirstPostOrPostDeadGamer;
            if Result = nil then Result:= FindSmallBlindGamer();
          end;//

        PT_SEVEN_STUD,
        PT_SEVEN_STUD_HILO:
          begin
            Result:= FindFirstAnteGamer();
          end;//
      end;//case
    end else
    if IsShowDownRound then begin   //final round
      Result:= GetShowDownOpenGamer();
    end else begin                  //betting round
      case Pokertype of
        PT_TEXAS_HOLDEM,
        PT_OMAHA,
        PT_OMAHA_HILO:
          begin
            if Hand.RoundID = 1 then Result:= FindGamerNextToBigBlind()
            else Result:= FindGamerNextToDealer();
          end;//

        PT_SEVEN_STUD,
        PT_SEVEN_STUD_HILO:
          begin
            if Hand.RoundID = 1 then begin
              Result:= DefineLowestCardGamer();
              if Assigned(OnOpenRoundGamer) then begin
                OnOpenRoundGamer(Result.UserName+' opens with the lowest card');
              end;//if
            end else begin
              Result:= DefineBestCombinationGamer([]);
              if Hand.FHiBettingCanBeUsed then begin
                if Assigned(OnOpenRoundGamer) then begin
                  OnOpenRoundGamer('Pair on board - a double bet is allowed');
                end;//
              end;//if
            end;//if
          end;//
      end;//case
    end;//
  end;//if

//fix up open round gamer
  Hand.OpenRoundGamer:= Result;
  if IsLastBettingRound then Hand.FLastBettingRoundOpenChair:= Result.ChairID;
end;

function TpoSingleTableCroupier.TableHasAnte: Boolean;
begin
  Result:= GetAnteStakeValue > 0;
end;

function TpoSingleTableCroupier.HandleGamerWaitBB(aGamer: TpoGamer): TpoGamer;
begin
  Result:= aGamer;
  aGamer.WaitForBigBlind:= True;
  if Assigned(OnGamerAction) then OnGamerAction(aGamer, GA_WAIT_BB, []);
  if aGamer.State = GS_PLAYING then begin
    aGamer.State:= GS_IDLE;
    aGamer.PassCurrentHand:= True;
    DefineNextStageInHand();
  end;//if
end;

function TpoSingleTableCroupier.ChairCanTakeStepRight(aChair: TpoChair): Boolean;
begin
  Result:= False;
  if aChair = nil then Exit;
  if aChair.Gamer = nil then Exit;
  if aChair.Gamer.FinishedTournament then Exit;//
  if (aChair.Gamer.State = GS_ALL_IN) AND (NOT IsShowdownRound()) then Exit;
  if aChair.Gamer.PassCurrentHand then Exit;
  if (aChair.IsPlaying) OR ((aChair.IsSitOut) AND (SitOutCanTakeStepRight())) then begin
    if IsPreliminaryRound AND
      (PokerClass = PTC_OPEN_CARDS_POKER)
    then begin
      if (Hand.SmallBlindGamer <> nil) AND
         (Hand.BigBlindGamer <> nil)
      then Exit;
    end;//if
    Result:= True;
  end;//if
end;//ChairIsApplicable


function TpoSingleTableCroupier.FindStepRightChairLeftToPosition(
  nPositionID: Integer; bDontSkipSitouts: Boolean): TpoChair;

  function GetNextPositionID(nPositionID: Integer): Integer;
  begin
    if nPositionID < Chairs.Count-1 then Result:= nPositionID+1
    else Result:= 0;
  end;//

  function ChairIsInSitoutState(aChair: TpoChair): Boolean;
  begin
    Result:= (aChair.Gamer <> nil) AND ((aChair.Gamer.State = GS_SITOUT) OR (aChair.Gamer.IsSitOut));
  end;//

  function HandleSitoutAndKickOff(aChair: TpoChair): Boolean;
  begin
    Result:= False;
    if (aChair = nil) OR (aChair.Gamer = nil) OR
      (NOT ChairIsInSitoutState(aChair)) OR SitOutCanTakeStepRight
    then Exit;

    if IsPreliminaryRound then begin
      if ((Hand.BigBlindGamer = nil) AND (Hand.SmallBlindGamer <> nil)) OR (PokerClass = PTC_CLOSED_CARDS_POKER)
      then aChair.Gamer.SkippedRequiredStakes:= aChair.Gamer.SkippedRequiredStakes+1;

      if PokerClass = PTC_OPEN_CARDS_POKER then begin
        if Hand.SmallBlindGamer = nil then begin
        end;
        if (Hand.BigBlindGamer = nil) then begin
          if aChair.Gamer.MustSetPost then aChair.Gamer.MustSetPostDead:= True
          else aChair.Gamer.MustSetPost:= True;
        end;//

        if MandatoryStakesSkipperMustBeBounced {AND (Chairs.GetFreeChairsCount = 0)}
          AND (aChair.Gamer.FSkippedRequiredStakes = PL_SKIPPED_BLINDS_TO_BOUNCE) then
        begin
          if Assigned(OnGamerLeaveTable) then OnGamerLeaveTable(aChair.Gamer);
          if Assigned(OnGamerKickOff) then OnGamerKickOff(
            aChair.Gamer,
            'You have been picked up from table for missing 3 big blinds.'
          );
          aChair.KickOffGamer();
          Result:= True;
        end;//if
      end else begin
        if MandatoryStakesSkipperMustBeBounced AND
          (aChair.Gamer.FSkippedRequiredStakes = PL_SKIPPED_ANTE_TO_BOUNCE) then
        begin
          if Assigned(OnGamerLeaveTable) then OnGamerLeaveTable(aChair.Gamer);
          if Assigned(OnGamerKickOff) then OnGamerKickOff(
            aChair.Gamer,
            'You have been picked up form table for missing 15 ante.'
          );
          aChair.KickOffGamer;
          Result:= True;
        end;//if
      end;//
    end;//if
  end;//HandleSioutChair

var
  nNextPosID: Integer;
  CntIter: Integer;
begin
  Result:= nil;
  nNextPosID:= nPositionID;
  CntIter := -1;
  repeat
    Inc(CntIter);
    if (CntIter > (Chairs.Count + 1)) then begin
      CommonDataModule.Log(ClassName, 'FindStepRightChairLeftToPosition',
      '[WARNING - CIRCLE]: Count of iterations in REPEAT statment more then needing. Iteration count=' + IntToStr(CntIter) + ', Chair count=' + IntToStr(Chairs.Count) +
        'Dialer=' + IntToStr(Hand.DealerChairID) + ', Active=' + IntToStr(Hand.FActiveChairID) +
        ', SmallBlind' + IntToStr(Hand.FSmallBlindChairID) + ', BigBlind=' + IntToStr(Hand.FBigBlindChairID) +
        ', HandID=' + IntToStr(Hand.HandID) + ', Round=' +IntToStr(Hand.RoundID),
      ltError);
      EscalateFailure(
        EpoException,
        'Count of iterations in REPEAT statment more then needing. Iteration count=' + IntToStr(CntIter) + ', Chair count=' + IntToStr(Chairs.Count),
        '{5E369C58-DAC1-43F4-A156-58EF0A0B18D8}'
      );
    end;

    nNextPosID:= GetNextPositionID(nNextPosID);
    if ChairCanTakeStepRight(Chairs[nNextPosID]) OR
      (ChairIsInSitoutState(Chairs[nNextPosID]) AND bDontSkipSitouts AND
      (NOT Chairs[nNextPosID].Gamer.FinishedTournament) AND
      (NOT Chairs[nNextPosID].Gamer.PassCurrentHand)) then
    begin
      Result:= Chairs[nNextPosID];
      if NOT HandleSitoutAndKickOff(Result) then Break;
    end;//if
  until nNextPosID = nPositionID;
end;

function TpoSingleTableCroupier.HandleGamerPostDead(aGamer: TpoGamer;
  nPostStake, nDeadStake: Integer): TpoGamer;
var
  nStake: Integer;
var
  ga: TpoUserSettlementAccount;
begin
  Result:= aGamer;
  CheckIfHandIsRunning('{CCD1A4F2-5EE4-4CFC-A1FE-BE35655C7D9E}');

  Result.MustSetBigBlind:= False;
  Result.MustSetPost:= False;
  Result.MustSetPostDead:= False;
  Result.WaitForBigBlind:= False;
  Result.ClearSkippedBlinds();

  Result.FLastActionInRound:= GA_POST_DEAD;
  nStake:= nPostStake;//+nDeadStake;
  nStake:= HandleStake(aGamer, nStake, 0);//nDeadStake);

  if Assigned(OnGamerAction) then OnGamerAction(aGamer, Result.FLastActionInRound, [nStake]);

  if nDeadStake > 0 then begin
    ga:= Hand.Pot.Bets.GetAccountByUserID(aGamer.UserID) as TpoUserSettlementAccount;
    Hand.Pot.MoveMoney(
       ga, Hand.Pot.SidePots.ActiveSidePot, nDeadStake, 'direct charge'
    );
    if Assigned(OnMoveBets) then OnMoveBets('direct charge');
  end;//if


  DefineNextStageInHand;
end;

function TpoSingleTableCroupier.HandleGamerAnte(aGamer: TpoGamer;
  nStake: Integer): TpoGamer;
begin
  Result:= aGamer;
  CheckIfHandIsRunning('{9E1E4E74-4969-455E-BF9D-4429FE7718CE}');
  Result.LastActionInRound:= GA_ANTE;
  nStake:= HandleStake(aGamer, nStake);

  if Assigned(OnGamerAction) then OnGamerAction(aGamer, Result.FLastActionInRound, [nStake]);
  DefineNextStageInHand;
end;

function TpoSingleTableCroupier.HandleGamerBringIn(aGamer: TpoGamer;
  nStake: Integer): TpoGamer;
var
  nRaiseAmount: Integer;
begin
  Result:= aGamer;
  CheckIfHandIsRunning('{EC951859-7FCB-4AB4-BB83-AA338AB71F62}');
  Result.LastActionInRound:= GA_BRING_IN;

  nRaiseAmount:= Hand.Pot.Bets.GetMaxBalance;
  nStake:= HandleStake(aGamer, nStake);
  Hand.RegisterRaise(nStake-nRaiseAmount);

  Hand.FUseLoBetting:= True;
  if Assigned(OnGamerAction) then OnGamerAction(aGamer, Result.FLastActionInRound, [nStake]);
  DefineNextStageInHand();
end;

function TpoSingleTableCroupier.HandleGamerShowCardsShuffled(
  aGamer: TpoGamer): TpoGamer;
var
  sMsg: String;
  ghc, glc: TpoCardCombination;

begin
  Result:= aGamer;
  if aGamer.ShowDownPassed or not IsShowdownRound then Exit;
  
  Result.FLastActionInRound:= GA_SHOW_CARDS_SHUFFLED;
  Result.ShowDownPassed:= True;
  if (Result.Combinations.Count = 0) then begin
  //abnormal hand termination - there is no cards
  //to form combination
  end else begin
    Result.Cards.ShuffleClosedCards;
    Result.ShowCardsAtShowdown:= True;

    if PokerType IN [PT_OMAHA_HILO, PT_SEVEN_STUD_HILO] then begin
      //check for high
        ghc:= Result.Combinations.BestCombination(True);
        if (Hand.FBestHiCombination.CompareTo(ghc) = CC_EQUAL) AND
          (Hand.FBestHiCombination.UserID <> aGamer.UserID)
        then begin
          sMsg:= aGamer.UserName+' shows the same hand';
        end else begin
          sMsg:= aGamer.UserName+' shows '+ghc.ToString;

          if ghc.CompareTo(Hand.FBestHiCombination) = CC_GREATER then begin
            if ghc.Description <> '' then sMsg:= sMsg+' - '+ghc.Description;
            Hand.FBestHiCombination.AcquireCombination(ghc).UserID:= aGamer.UserID;
          end else begin
            if ghc.Description <> '' then sMsg:= sMsg+' - lower kicker';
          end;//if
        end;//if
        SendMessage(sMsg);

      //check for low
        glc:= Result.Combinations.BestCombination(False);
        if (glc <> nil) then begin
          if (Hand.FBestLoCombination.CompareTo(glc) = CC_EQUAL) AND
            (Hand.FBestLoCombination.UserID <> aGamer.UserID)
          then  begin
            sMsg:= aGamer.UserName+' shows the same hand for low';
          end else begin
            if glc.LoBetterOrEqual(Hand.FBestLoCombination) then begin
              Hand.FBestLoCombination.AcquireCombination(glc).UserID:= aGamer.UserID;
            end;//if
            sMsg:= aGamer.UserName+' shows '+glc.FormLoSeries +' for low';
          end;//if
          SendMessage(sMsg);
        end;//
    end else begin
      ghc:= Result.Combinations.BestCombination(True);
      if (Hand.FBestHiCombination.CompareTo(ghc) = CC_EQUAL) AND
        (Hand.FBestHiCombination.UserID <> aGamer.UserID)
      then  begin
        sMsg:= aGamer.UserName+' shows the same hand';
      end else begin
        sMsg:= aGamer.UserName+' shows '+ghc.ToString;
        if (Hand.FBestHiCombination.UserID <> aGamer.UserID) then begin
          if ghc.CompareTo(Hand.FBestHiCombination) = CC_GREATER then begin
            if ghc.Description <> '' then sMsg:= sMsg+' - '+ghc.Description;
            Hand.FBestHiCombination.AcquireCombination(ghc).UserID:= aGamer.UserID;
          end else begin
            if ghc.Kind = Hand.FBestHiCombination.Kind then sMsg:= sMsg+' - lower kicker';
          end;//if
        end;//if

      end;//if
      SendMessage(sMsg);
    end;//if
  end;//if

  if Assigned(OnGamerAction) then OnGamerAction(aGamer, Result.FLastActionInRound, []);
  DefineNextStageInHand; //active player or finish hand
end;

function TpoSingleTableCroupier.RankingIsApplicable(aGamer: TpoGamer): Boolean;
begin
  if IsShowdownRound AND (aGamer <> nil) AND (aGamer.LastActionInRound <> GA_NONE) then begin
    Result:= False;
    Exit;
  end;//if

  Result:= (ChairIsWinnerCandidate(aGamer.Chair)) AND (aGamer.Cards.Count >= GetGamerCardsCntForCombination(aGamer)) AND
    ((aGamer.Cards.Count + Hand.CommunityCards.Count) >= COMBINATION_CARDS_COUNT);
end;//TpoGenericCroupier.RankingIsApplicable


function TpoSingleTableCroupier.CalcGamerCombinations(aGamer: TpoGamer): Boolean;
var
  cp: TpoCardCombinationProcessor;
  cc: TpoCardCollection;
  I: Integer;
begin
  Result:= False;
  if NOT RankingIsApplicable(aGamer) then Exit;
  cp:= TpoCardCombinationProcessor.Create(FTable.Cards);

  case PokerType of
    PT_OMAHA, PT_OMAHA_HILO:
    begin
      Hand.CommunityCards.ActiveCards   := GetCommunityCardsCntForCombination();
      aGamer.Cards.ActiveCards          := GetGamerCardsCntForCombination(aGamer);

      cp.DetectCombinations(Hand.CommunityCards, aGamer.Cards, aGamer.FCombinations);
    end;

    PT_TEXAS_HOLDEM:
    begin
      cc:= TpoCardCollection.Create(FTable.Cards);
      cc.AcqureCardsFrom(Hand.CommunityCards);
      cc.AcqureCardsFrom(aGamer.Cards);
      cc.ActiveCards:= cc.Count;

      cp.DetectCombinations(nil, cc, aGamer.FCombinations);
      cc.Free;
    end;

    PT_SEVEN_STUD, PT_SEVEN_STUD_HILO:
    begin
      cc:= TpoCardCollection.Create(FTable.Cards);
      cc.AcqureCardsFrom(aGamer.Cards);
      if cc.Count < 7 then begin
        for I := Hand.CommunityCards.Count - 1 downto 0 do begin
          if cc.Count >= 7 then Break;
          cc.AttachCard(Hand.CommunityCards[I]);
        end;
      end;
      cc.ActiveCards:= cc.Count;

      cp.DetectCombinations(nil, cc, aGamer.FCombinations);
      cc.Free;
    end;
  end;

  cp.Free;
end;

{ TpoGenericCroupier }

procedure TpoGenericCroupier.FixElementRefs;
begin
  inherited;
end;

function TpoGenericCroupier.Load(aReader: TReader): Boolean;
begin
  Result:= inherited Load(aReader);
end;

function TpoGenericCroupier.Store(aWriter: TWriter): Boolean;
begin
  Result:= inherited Store(aWriter);
end;

procedure TpoGenericCroupier.SetPokerType(const Value: TpoPokerType);
begin
  FPokerType := Value;
end;

function TpoGenericCroupier.GetPokerClass: TpoPokerTypeClass;
begin
  Result:= PTC_OPEN_CARDS_POKER;
  case FPokerType of
    PT_TEXAS_HOLDEM,    //1 - Texas Hold'em
    PT_OMAHA,           //2 – Omaha
    PT_OMAHA_HILO:     //3 - Omaha Hi Lo
      Result:= PTC_OPEN_CARDS_POKER;

    PT_SEVEN_STUD,      //4 - Seven Stud
    PT_SEVEN_STUD_HILO: //5 - Seven Stud Hi Lo
      Result:= PTC_CLOSED_CARDS_POKER;
    //PT_FIVE_CARD_DRAW,  //6 - Five Card Draw
    //PT_FIVE_CARD_STUD,  //7 - Five Card Stud
    //PT_CRAZY_PINEAPPLE  //8 - Crazy Pineapple
  end;//case
end;

function TpoGenericCroupier.GetPokerTypeAsString: string;
begin
  Result:= nPokerTypeTostringMap[FPokerType];
end;

procedure TpoGenericCroupier.SetStakeType(const Value: TpoStakeType);
begin
  FStakeType := Value;
end;


function TpoGenericCroupier.GetAnteStakeValue: Integer;
begin
  if (FTable.FSmallBetValue > (PL_ANTE_THRESHOLD * 100)) then
    Result:= Trunc(FTable.FSmallBetValue/PL_ANTE_MULTIPLIER)
  else Result:= 0;
end;

function TpoGenericCroupier.GetBetStakeValue(aGamer: TpoGamer): Integer;
begin
  Result:= 0;
  if (PokerType IN [PT_TEXAS_HOLDEM, PT_OMAHA, PT_OMAHA_HILO]) then begin
    if Hand.RoundID <= 2 then Result:= FTable.SmallBetValue
    else Result:= FTable.BigBetValue;
  end else//open cards
  if (PokerType IN [PT_SEVEN_STUD, PT_SEVEN_STUD_HILO]) then begin
    if Hand.RoundID <= 2 then Result:= FTable.SmallBetValue
    else Result:= FTable.BigBetValue;

  //handle special case - 3d river
    if (Hand.RoundID = 2) AND (Hand.FHiBettingCanBeUsed) AND
      (GetCallStakeValue(aGamer) >= FTable.SmallBetValue) then
    begin
      Result:= FTable.BigBetValue;
    end;//if
  end;// closed cards
end;

function TpoGenericCroupier.GetBigBlindStakeValue: Integer;
begin
  Result := FTable.FSmallBetValue;
end;

function TpoGenericCroupier.GetBringInStakeValue: Integer;
begin
  Result:= FTable.FSmallBetValue div 2;
end;

function TpoGenericCroupier.GetCallStakeValue(aGamer: TpoGamer): Integer;
var
  acc: TpoAccount;
  nMaxAmount: Integer;
begin
  Result:= 0;
  acc:= Hand.Pot.Bets.GetAccountByUserID(aGamer.UserID);
  nMaxAmount:= Hand.Pot.Bets.GetMaxBalance();
  if acc <> nil then Result:= Result+(nMaxAmount - acc.Balance);
  Result:= Result;
end;//TpoGenericCroupier.GetCallStakeValue


function TpoGenericCroupier.GetMaxStakeValue(aGamer: TpoGamer): Integer;
begin
  Result:= 0;
  if StakeType = ST_FIXED_LIMIT then begin
    Result:= GetBetStakeValue(aGamer)*3;
  end;//
end;

function TpoGenericCroupier.GetPostDeadStakeValue: Integer;
begin
  Result:= GetSmallBlindStakeValue();//TBD:
end;

function TpoGenericCroupier.GetCommonPostDeadStakeValue: Integer;
begin
  Result:= GetSmallBlindStakeValue() + GetBigBlindStakeValue();//BS
end;

function TpoGenericCroupier.GetPostStakeValue: Integer;
begin
  Result:= GetBigBlindStakeValue();
end;

function TpoGenericCroupier.GetRaiseStakeValue(aGamer: TpoGamer): Integer;
var
  nCSV : Integer;
  nRaiseStake: Integer;
begin
  Result:= 0;
  if (StakeType = ST_FIXED_LIMIT) then begin
    nRaiseStake:= GetBetStakeValue(aGamer);
  //handle special case:
  //7-stud - 1st round
    if (PokerClass = PTC_CLOSED_CARDS_POKER) AND (Hand.RoundID = 1) AND (Hand.FUseLoBetting) then begin
      nRaiseStake:= GetBringInStakeValue();
    end;//if
  //handle special case:
  //7-stud - 1st round
    if (PokerClass = PTC_CLOSED_CARDS_POKER) AND (Hand.RoundID = 2) AND (Hand.FHiBettingCanBeUsed) then begin
      nRaiseStake:= FTable.BigBetValue;
    end;//if
    //2/6/2004 - by ticket #62
    Result:= nRaiseStake*(Hand.RaisesInRound+1)-aGamer.Bets;
  end else
  if StakeType IN [ST_NO_LIMIT, ST_POT_LIMIT] then begin
    nCSV := GetCallStakeValue(aGamer);
    if Hand.LastRaiseAmount = 0 then Result:= nCSV+GetBetStakeValue(aGamer)
    else Result:= nCSV+Hand.LastRaiseAmount;
  end;//if
end;


function TpoGenericCroupier.GetSmallBlindStakeValue: Integer;
var
  CurrRes: Currency;
begin
//  if StakeType = ST_FIXED_LIMIT then begin
    CurrRes:= FTable.SmallBetValue / 2;
    if CurrRes > 100 then Result:= Trunc(CurrRes/100) * 100
    else Result:= 100;
//  end else Result:= FTable.FSmallBetValue;
end;

procedure TpoGenericCroupier.SetOnAbandonHandStarting(const Value:
    TNotifyEvent);
begin
  FOnAbandonHandStarting := Value;
end;

procedure TpoGenericCroupier.SetOnActivePlayer(const Value: TOnGamerOperation);
begin
  FOnActivePlayer := Value;
end;

procedure TpoGenericCroupier.SetOnChairStateChange(const Value: TNotifyEventEx);
begin
  FOnChairStateChange := Value;
end;

procedure TpoGenericCroupier.SetOnChatMessage(const Value: TOnMessageDispatch);
begin
  FOnChatMessage := Value;
end;

procedure TpoGenericCroupier.SetOnDealCards(const Value: TNotifyEventEx);
begin
  FOnDealCards := Value;
end;

procedure TpoGenericCroupier.SetOnDontShowCards(const Value: TOnGamerOperation);
begin
  FOnDontShowCards:= Value;
end;

procedure TpoGenericCroupier.SetOnGamerSitOut(const Value: TOnGamerOperation);
begin
  FOnGamerSitOut := Value;
end;

procedure TpoGenericCroupier.SetOnHandFinish(const Value: TOnPotOperation);
begin
  FOnHandFinish := Value;
end;

procedure TpoGenericCroupier.SetOnHandReconcileOperation(const Value:
    TOnHandReconcileOperation);
begin
  FOnHandReconcileOperation := Value;
end;

procedure TpoGenericCroupier.SetOnHandStart(const Value: TNotifyEvent);
begin
  FOnHandStart := Value;
end;

procedure TpoGenericCroupier.SetOnHandStarted(const Value: TNotifyEventEx);
begin
  FOnHandStarted := Value;
end;

procedure TpoGenericCroupier.SetOnHandStarting(const Value: TNotifyEventEx);
begin
  FOnHandStarting := Value;
end;

procedure TpoGenericCroupier.SetOnLeaveTable(const Value: TOnGamerOperation);
begin
  FOnLeaveTable := Value;
end;

procedure TpoGenericCroupier.SetOnMoreChips(const Value: TOnGamerOperation);
begin
  FOnMoreChips := Value;
end;

procedure TpoGenericCroupier.SetOnMoveBets(const Value: TonPotOperation);
begin
  FOnMoveBets := Value;
end;

procedure TpoGenericCroupier.SetOnMuck(const Value: TOnGamerOperation);
begin
  FOnMuck := Value;
end;

procedure TpoGenericCroupier.SetOnRoundFinish(const Value: TNotifyEvent);
begin
  FOnRoundFinish := Value;
end;

procedure TpoGenericCroupier.SetOnSetActivePlayer(const Value: TNotifyEvent);
begin
  FOnSetActivePlayer := Value;
end;

procedure TpoGenericCroupier.SetOnShowCards(const Value: TOnGamerOperation);
begin
  FOnShowCards := Value;
end;

procedure TpoGenericCroupier.SetOnSitOut(const Value: TOnGamerOperation);
begin
  FOnSitOut := Value;
end;

constructor TpoGenericCroupier.Create(
  aTable: TpoTable; nPokerType: TpoPokerType; sCurrencySymbol: string;
  nMinGamersForStartHand: Integer
);
begin
  inherited Create;
  FPokerType:= nPokerType;
  FCurrencySymbol := sCurrencySymbol;
  FMinGamersForStartHand := nMinGamersForStartHand;
  FTable:= aTable;
  FTable.FCroupier:= Self;
end;

function TpoGenericCroupier.GetChairs: TpoChairs;
begin
  Result:= FTable.Chairs;
end;

function TpoGenericCroupier.GetGamers: TpoGamers;
begin
  Result:= FTable.Gamers;
end;

function TpoGenericCroupier.GetHand: TpoHand;
begin
  Result:= FTable.FHand;
end;

function TpoGenericCroupier.NormalizeAmount(nStake: Integer): Currency;
begin
  Result:= nStake/100;
end;

procedure TpoGenericCroupier.SendMessage(sMsg, sTitle: String; aGamer: TpoGamer;
    nOriginator: TpoMessageOriginator; nPriority: Integer);
begin
  if Assigned(OnChatMessage) then OnChatMessage(
    sMsg, sTitle, aGamer, nOriginator, nPriority
  );
  CommonDataModule.Log(ClassName, 'SendMessage', sMsg, ltCall);
end;

function TpoGenericCroupier.StartHand(nHandID: Integer): Boolean;
begin
  Result:= False;
end;

procedure TpoGenericCroupier.CalcGamersShowDownCombinations;
var
  I: Integer;
  aGamer: TpoGamer;
  aChair: TpoChair;
begin
  for I:= 0 to Chairs.Count-1 do begin
    aChair := Chairs[I];
    aGamer := aChair.Gamer;
    if ChairIsWinnerCandidate(aChair) then begin
      aGamer.FCombinations.Clear;
      CalcGamerCombinations(aGamer);
    end;//if
  end;//if
end;


procedure TpoGenericCroupier.DealCommunityCards;
var
  bCardsHasDeal: Boolean;

begin
  bCardsHasDeal:= False;
  case Pokertype of
    PT_TEXAS_HOLDEM,
    PT_OMAHA,
    PT_OMAHA_HILO:
      begin
        case Hand.RoundID of
          1: //frop
            begin
              Hand.CardsToDeal.DealTopCardTo(Hand.CommunityCards, True);
              Hand.CardsToDeal.DealTopCardTo(Hand.CommunityCards, True);
              Hand.CardsToDeal.DealTopCardTo(Hand.CommunityCards, True);
              bCardsHasDeal:= True;
            end;//

          2:
            begin
              Hand.CardsToDeal.DealTopCardTo(Hand.CommunityCards, True);
              bCardsHasDeal:= True;
            end;//
          3:
            begin
              Hand.CardsToDeal.DealTopCardTo(Hand.CommunityCards, True);
              bCardsHasDeal:= True;
            end;//
        end;//
      end;//OMAXA
  end;//case

  if bCardsHasDeal AND Assigned(OnDealCards) AND (NOT IsShowdownRound)  then OnDealCards(Self, VarArrayOf([Hand.RoundID, False]));
end;

procedure TpoGenericCroupier.DealGamerCards;
var
  I, J, CardsCnt: Integer;
  bCardHasDeal: Boolean;
  nWinCandidatesCount: Integer;
  aChair: TpoChair;
begin
  if IsPreliminaryRound then Exit;
  bCardHasDeal:= False;

  case PokerType of
    PT_TEXAS_HOLDEM:
      begin
        if Hand.RoundID > 1 then Exit;
        CardsCnt:= 2;
        for I:= 0 to CardsCnt-1 do begin
          for J:= 0 to Chairs.Count-1 do begin
            aChair := Chairs[J];
            if ChairIsWinnerCandidate(aChair) then begin
              Hand.CardsToDeal.DealTopCardTo(aChair.Gamer.Cards, False);
              bCardHasDeal:= True;
            end;//if
          end;//for
        end;//
      end;//if

    PT_OMAHA,
    PT_OMAHA_HILO:
      begin
        if Hand.RoundID > 1 then Exit;
        CardsCnt:= 4;
        for I:= 0 to CardsCnt-1 do begin
          for J:= 0 to Chairs.Count-1 do begin
            aChair := Chairs[J];
            if ChairIsWinnerCandidate(aChair) then begin
              Hand.CardsToDeal.DealTopCardTo(aChair.Gamer.Cards, False);
              bCardHasDeal:= True;
            end;//if
          end;//for
        end;//
      end;//

    PT_SEVEN_STUD,
    PT_SEVEN_STUD_HILO:
      begin
      //first round - deal 2 closed and one open
        if Hand.RoundID = 1 then begin
          CardsCnt:= 3;
          for I:= 0 to CardsCnt-1 do begin
            for J:= 0 to Chairs.Count-1 do begin
              aChair := Chairs[J];
              if ChairIsWinnerCandidate(aChair) then begin
                Hand.CardsToDeal.DealTopCardTo(aChair.Gamer.Cards,
                  (I=(CardsCnt-1)) OR aChair.Gamer.FTurnedCardsOver
                );
                bCardHasDeal:= True;
              end;//if
            end;//for
          end;//
        end;//

      //second round - deal one open
        if Hand.RoundID = 2 then begin
          for J:= 0 to Chairs.Count-1 do begin
            aChair := Chairs[J];
            if ChairIsWinnerCandidate(aChair) then begin
              Hand.CardsToDeal.DealTopCardTo(aChair.Gamer.Cards, True);
              bCardHasDeal:= True;
            end;//if
          end;//for
        end;//if

      //third round - deal one open
        if Hand.RoundID = 3 then begin
          for J:= 0 to Chairs.Count-1 do begin
            aChair := Chairs[J];
            if ChairIsWinnerCandidate(aChair) then begin
              Hand.CardsToDeal.DealTopCardTo(aChair.Gamer.Cards, True);
              bCardHasDeal:= True;
            end;//if
          end;//for
        end;//if

      //forth round - deal one open
        nWinCandidatesCount := WinnerCandidatesCount();

        if Hand.RoundID = 4 then begin
          if (Hand.CardsToDeal.Count > nWinCandidatesCount) then begin
            for J:= 0 to Chairs.Count-1 do begin
              aChair := Chairs[J];
              if ChairIsWinnerCandidate(aChair) then begin
                Hand.CardsToDeal.DealTopCardTo(aChair.Gamer.Cards, True);
                bCardHasDeal:= True;
              end;//if
            end;//for
          end else begin
            { deal to gamers }
            for J:=0 to (Hand.CardsToDeal.Count - 3) do begin
              aChair := Chairs[J];
              if ChairIsWinnerCandidate(aChair) then begin
                Hand.CardsToDeal.DealTopCardTo(aChair.Gamer.Cards, True);
                Dec(nWinCandidatesCount);
              end;
            end;
            { deal one card to table }
            if (nWinCandidatesCount > 0) then begin
              Hand.CardsToDeal.DealTopCardTo(Hand.CommunityCards, True);
              bCardHasDeal := True;
            end;
          end;
        end;//if

      //fifth round - deal one close
        if Hand.RoundID = 5 then begin
          if (Hand.CardsToDeal.Count >= nWinCandidatesCount) then begin
            for J:= 0 to Chairs.Count-1 do begin
              aChair := Chairs[J];
              if ChairIsWinnerCandidate(aChair) then begin
                Hand.CardsToDeal.DealTopCardTo(
                  aChair.Gamer.Cards, False OR aChair.Gamer.FTurnedCardsOver
                );
                bCardHasDeal:= True;
              end;//if
            end;//for
          end else begin
            { deal to gamers }
            for J:=0 to (Hand.CardsToDeal.Count - 2) do begin
              aChair := Chairs[J];
              if ChairIsWinnerCandidate(aChair) then begin
                Hand.CardsToDeal.DealTopCardTo(
                  aChair.Gamer.Cards,
                  False OR aChair.Gamer.FTurnedCardsOver
                );
                Dec(nWinCandidatesCount);
              end;
            end;
            { deal one card to table }
            if (nWinCandidatesCount > 0) then begin
              Hand.CardsToDeal.DealTopCardTo(Hand.CommunityCards, False);
              bCardHasDeal := True;
            end;
          end;
        end;//if
      end;//case  STUDs
  end;//case

//publish cards
  if bCardHasDeal AND Assigned(OnDealCards) then begin
    OnDealCards(Self, VarArrayOf([Hand.RoundID, True]));
  end;//if
end;

function TpoGenericCroupier.IsLastBettingRound: Boolean;
begin
  Result:= Hand.RoundID = (RoundsInHand()-1);
end;

function TpoGenericCroupier.IsPreliminaryRound: Boolean;
begin
  Result:= Hand.RoundID = 0;
end;

function TpoGenericCroupier.IsShowdownRound: Boolean;
begin
  Result:= RoundsInHand() = Hand.RoundID;
end;

function TpoGenericCroupier.RoundsInHand: Integer;
begin
  Result:= 0;
  case PokerType of
    PT_TEXAS_HOLDEM,
    PT_OMAHA,
    PT_OMAHA_HILO:
      Result:= 5;

    PT_SEVEN_STUD,      //4 - Seven Stud
    PT_SEVEN_STUD_HILO: //5 - Seven Stud Hi Lo
      Result:= 6;
  end;//
  if Result = 0 then begin
    EscalateFailure(
      EpoException,
      'Rounds count cannot be 0',
      '{150AA276-3F8F-440B-8B5D-D40925551684}'
    );
  end;//if
end;

function TpoGenericCroupier.GetBettingTxContextName(nUserID: Integer): String;
begin
  Result:= 'betting#'+IntToStr(nUserID);
end;

function TpoGenericCroupier.GetCommunityCardsCntForCombination: Integer;
begin
  Result:= 0;
  case PokerType  of
    PT_TEXAS_HOLDEM:
      Result:= 5;

    PT_OMAHA,
    PT_OMAHA_HILO:
      Result:= 3;

    PT_SEVEN_STUD,
    PT_SEVEN_STUD_HILO:
      if Hand.CommunityCards.Count > 0 then Result:= 1
      else Result:= 0;
  end;//case
end;

function TpoGenericCroupier.GetGamerCardsCntForCombination(aGamer: TpoGamer): Integer;
begin
  Result:= 0;
  case PokerType  of
    PT_TEXAS_HOLDEM:
      Result:= 2;

    PT_OMAHA,
    PT_OMAHA_HILO:
      Result:= 2;

    PT_SEVEN_STUD,
    PT_SEVEN_STUD_HILO:
      if Hand.CommunityCards.Count > 0 then
        Result := IfThen(aGamer.Cards.Count < 5, aGamer.Cards.Count, 5)
      else Result:= 5;
  end;//case
end;


procedure TpoGenericCroupier.SetOnUpdateGamerDetails(
  const Value: TOnGamerOperation);
begin
  FOnUpdateGamerDetails := Value;
end;

procedure TpoGenericCroupier.SendProcCloseAction(sMsg: string);
begin
  if Assigned(OnProcCloseAction) then OnProcCloseAction(sMsg);
end;

procedure TpoGenericCroupier.SetOnProcCloseAction(
  const Value: TOnProcCloseAction);
begin
  FOnProcCloseAction := Value;
end;

procedure TpoGenericCroupier.SetOnGamerBack(
  const Value: TOnGamerOperation);
begin
  FOnGamerBack := Value;
end;

procedure TpoGenericCroupier.SetOnGamerAction(const Value: TOnGamerAction);
begin
  FOnGamerAction := Value;
end;

procedure TpoGenericCroupier.CorrectGamerTimebank(aGamer: TpoGamer;
  nExpiredTimeout: Integer);
begin
  if aGamer.FTournamentTimebank < 0 then aGamer.FTournamentTimebank:= 0;
end;

procedure TpoGenericCroupier.SetOnOpenRoundGamer(const Value: TOnChatMessage);
begin
  FOnOpenRoundGamer := Value;
end;

procedure TpoGenericCroupier.SetOnGamerCloseProcess(
  const Value: TNotifyEventEx);
begin
  FOnGamerCloseProcess := Value;
end;

procedure TpoGenericCroupier.SetOnGamerKickOff(
  const Value: TOnGamerMessage);
begin
  FOnGamerKickOff := Value;
end;

procedure TpoGenericCroupier.ChargeRakes;
begin
  //TBO:`
end;

procedure TpoGenericCroupier.SetOnGamerLeaveTable(
  const Value: TOnGamerLeaveTable);
begin
  FOnGamerLeaveTable := Value;
end;

function TpoGenericCroupier.GetStakeLimit(aGamer: TpoGamer; nStake: Integer): Integer;
begin
  Result:= 0;
  case Staketype of
    ST_FIXED_LIMIT:
      begin
        Result:= GetCallStakeValue(aGamer)+GetBetStakeValue(aGamer);
      end;//

    ST_POT_LIMIT:
      begin
        Result:= Hand.Pot.Bets.TotalBalance+Hand.Pot.SidePots.TotalBalance+
          GetCallStakeValue(aGamer);
      end;//

    ST_NO_LIMIT:
      begin
        if aGamer.Account.Balance > nStake then Result:= aGamer.Account.Balance
        else Result:= nStake;
      end;//
  end;//case
end;

procedure TpoGenericCroupier.OnPotReconcileOperation(nUserID: Integer;
  sOpCode: String; nAmount: Integer; sComment: String);
begin
  if Assigned(OnHandReconcileOperation) then begin
    OnHandReconcileOperation(Hand.HandID, Gamers.GamerByUserID(nUserID), sOpCode, nAmount, sComment)
  end;//
end;

procedure TpoGenericCroupier.SetOnChangeGamersCount(const Value: TNotifyEvent);
begin
  FOnChangeGamersCount := Value;
end;

procedure TpoGenericCroupier.SetOnPotReconcileFinish(const Value: 
    TOnSidePotOperation);
begin
  FOnPotReconcileFinish := Value;
end;

procedure TpoGenericCroupier.ClearCardsModifiedState;
var
  I: Integer;
begin
  Hand.CommunityCards.Modified:= False;
  for I:= 0 to FTable.Gamers.Count-1 do begin
    FTable.Gamers[I].Cards.Modified:= False;
  end;//
end;

procedure TpoGenericCroupier.SetOnCheckGamerAllins(
  const Value: TOnCheckGamerAbility);
begin
  FOnCheckGamerAllins := Value;
end;

destructor TpoGenericCroupier.Destroy;
begin
  inherited;
end;

procedure TpoGenericCroupier.SetTournamentType(
  const Value: TpoTournamentType);
begin
  FTournamentType := Value;
end;

procedure TpoGenericCroupier.SetOnPrepareReorderedPackets(const Value:
    TOnGamerOperation);
begin
  FOnPrepareReorderedPackets := Value;
end;

procedure TpoGenericCroupier.SetOnMultyTournamentProcState(
  const Value: TOnMultyTournamentProcState);
begin
  FOnMultyTournamentProcState := Value;
end;

procedure TpoGenericCroupier.SetOnDumpCachedStateToFile(const Value: TOnDumpCachedStateToFile);
begin
  FOnDumpCachedStateToFile := Value;
end;

procedure TpoGenericCroupier.DumpCachedStateToFile;
begin
  if Assigned(FOnDumpCachedStateToFile) then FOnDumpCachedStateToFile;
end;

procedure TpoGenericCroupier.SetCurrencySymbol(const Value: string);
begin
  FCurrencySymbol := Value;
end;

procedure TpoGenericCroupier.SetMinGamersForStartHand(
  const Value: Integer);
begin
  FMinGamersForStartHand := Value;
end;

{ TpoUserSettlementAccounts }

function TpoUserSettlementAccounts.FindFirstUnbalancedAccount: TpoUserSettlementAccount;
var
  I: Integer;
begin
  Result:= nil;
  for I:= 0 to Count-1 do begin
    if Accounts[I].Balance > 0 then begin
      Result:= Accounts[I] as TpoUserSettlementAccount;
      Exit;
    end;//
  end;//for
end;

procedure TpoUserSettlementAccounts.FoldGamerAccount(nUserID: Integer);
var
  acc: TpoUserSettlementAccount;
begin
  acc:= GetAccountByUserID(nUserID);
  if acc <> nil then acc.State:= AS_FOLDED;
end;

function TpoUserSettlementAccounts.GetAccountByUserID(
  nUserID: Integer): TpoUserSettlementAccount;
var
  I: Integer;
begin
  Result:= nil;
  for i:= 0 to Count-1 do begin
    if (Accounts[I] as TpoUserSettlementAccount).UserID = nUserID then begin
      Result:= Accounts[I] as TpoUserSettlementAccount;
      Exit;
    end;
  end;//for
end;

function TpoUserSettlementAccounts.GetAccountClass: TpoAccountClass;
begin
  Result:= TpoUserSettlementAccount;
end;


function TpoUserSettlementAccounts.GetMaxBalance: Integer;
var
  I: Integer;
begin
  Result:= 0;
  for I:= 0 to Count-1 do begin
    if (Result < Accounts[I].Balance) then Result:= Accounts[I].Balance;
  end;//for
end;

function TpoUserSettlementAccounts.GetMinBalance: Integer;
var
  I, nCntNotFoldedAndNotBalanced, nMaxFolded: Integer;
  acc: TpoAccount;
begin
  Result:= 0;

  nCntNotFoldedAndNotBalanced  := 0;
  nMaxFolded := 0;
  for I:= 0 to Count-1  do begin
    acc := Accounts[I];
    if acc.IsBalanced then Continue;
    if ((acc as TpoUserSettlementAccount).FState = AS_FOLDED) then begin
      if (acc.Balance > 0) AND ((nMaxFolded < acc.Balance) OR (nMaxFolded = 0)) then
        nMaxFolded := acc.Balance;

      Continue;
    end;

    Inc(nCntNotFoldedAndNotBalanced);
  end;//for

  if nCntNotFoldedAndNotBalanced = 1 then begin
    Result := nMaxFolded;
    Exit;
  end;

  for I:= 0 to Count-1 do begin
    acc := Accounts[I];
    if (acc.Balance > 0) AND ((Result > acc.Balance) OR (Result = 0)) then
    begin
      if ((acc as TpoUserSettlementAccount).FState = AS_FOLDED)// and HasAllInAccounts
      then Continue;

      Result:= acc.Balance;
    end;
  end;//for
end;

function TpoUserSettlementAccounts.HasAllInAccounts: Boolean;
var
  I: Integer;
begin
  Result:= False;
  for I:= 0 to Count-1 do begin
    if (Accounts[I] as TpoUserSettlementAccount).State = AS_ALL_IN then begin
      Result:= True;
      Exit;
    end;//if
  end;//for
end;//

function TpoUserSettlementAccounts.UnbalancedAccountCount: Integer;
var
  I: Integer;
begin
  Result:= 0;
  for I:= 0 to Count-1  do begin
    if Accounts[I].Balance > 0 then begin
      Inc(Result);
    end;//
  end;//for
end;

{ TpoPotSettlementAccount }

constructor TpoPotSettlementAccount.Create(
  sName: String;
  nType: TpoAccountType; nCurrency: TpoAccountCurrency
);
begin
  inherited Create(
    sName, nType, nCurrency
  );
  FSubAccounts:= TpoUserPotSubAccounts.Create;
  Version:= 1;
end;

destructor TpoPotSettlementAccount.Destroy;
begin
  FSubAccounts.Free;
  inherited;
end;

function TpoPotSettlementAccount.GetPlayingUserIDs: TpoUserIDs;
var
  I, nLen: Integer;
  acc: TpoUserPotSubAccount;
begin
  SetLength(Result, 0);
  nLen:= 0;
  for I:= 0 to SubAccounts.Count-1 do begin
    acc:= (SubAccounts[I] as TpoUserPotSubAccount);

    if acc.State = AS_FOLDED then Continue;
    Inc(nLen);
    SetLength(Result, nLen);
    Result[High(Result)]:= acc.UserID;
  end;//for
end;

function TpoPotSettlementAccount.GetHiCategoryWinnersCount: Integer;
var
  I: Integer;
begin
  Result:= 0;
  for I:= 0 to FSubAccounts.Count-1 do begin
    if (FSubAccounts[I] as TpoUserPotSubAccount).IsWinner AND
       ((FSubAccounts[I] as TpoUserPotSubAccount).InHICategory)
    then Inc(Result);
  end;//for
end;


function TpoPotSettlementAccount.HasAllInSubAccounts: Boolean;
begin
  Result:= SubAccounts.HasAllInSubAccounts;
end;

function TpoPotSettlementAccount.Load(aReader: TReader): Boolean;
begin
  Result:= inherited Load(aReader);
  FMaxOperationAmount:= aReader.ReadInteger;
  FRakesToCharge:= aReader.ReadInteger;
  FSubAccounts.Load(aReader);
  if FLoadedVersion >=1 then begin
    FHandledInShowdown:= aReader.ReadBoolean;
  end;//if
end;


function TpoPotSettlementAccount.RearrangeWinnersSubAccounts(pReconsileHook: TOnPotReconcileOperation): Currency;
var
  I, nHiWinnerCount, nLoWinnerCount: Integer;
  nHiWinnersSubBalance, nLoWinnersSubBalance: Integer;
  nHiWinnersPart, nLoWinnersPart: Integer;
  nResultBalance: Integer;
  nWinnerAmount, nGamerAmount: Integer;
  nRestToNextHand: Currency;
begin
//********************************************
// Return value for adding Fracs of Pot accounts
// to next hands
//********************************************
  OnPotReconcileoperation:= pReconsileHook;

//define subbalances
  nResultBalance:= Balance - RakesToCharge;
  nHiWinnerCount:= GetHiCategoryWinnersCount;
  nLoWinnerCount:= GetLoCategoryWinnersCount;
  nHiWinnersSubBalance:= 0;
  nLoWinnersSubBalance:= 0;

  Result := 0;
  //
  if (nLoWinnerCount = 0) AND (nHiWinnerCount = 0) then Exit;
  if (nHiWinnerCount > 0) then begin
    nHiWinnersSubBalance:= nResultBalance;
  end;//fi

  nRestToNextHand := 0;
  if (nLoWinnerCount > 0) then begin
    nHiWinnersSubBalance:= nResultBalance div 2;
    if nHiWinnerssubBalance <> 0 then begin
      nLoWinnersSubBalance:= nResultBalance div 2;
      nRestToNextHand := ((nResultBalance / 2) - nHiWinnersSubBalance) * 2;
    end
    else nLoWinnersSubBalance:= nResultBalance;
  end;//if

//devide pot parts
  if (nHiWinnerCount > 0) then begin
    nHiWinnersPart:= nHiWinnersSubBalance div nHiWinnerCount;
    nRestToNextHand := nRestToNextHand +
      ((nHiWinnersSubBalance/nHiWinnerCount) - nHiWinnersPart) * nHiWinnerCount;
  end else begin
    nHiWinnersPart:= nHiWinnersSubBalance;
  end;

  if (nLoWinnerCount > 0) then begin
    nLoWinnersPart:= nLoWinnersSubBalance div nLoWinnerCount;
    nRestToNextHand := nRestToNextHand +
      ((nLoWinnersSubBalance/nLoWinnerCount) - nLoWinnersPart) * nLoWinnerCount;
  end else begin
    nLoWinnersPart:= nLoWinnersSubBalance;
  end;

  Result := nRestToNextHand;

  for I:= 0 to FSubAccounts.Count-1 do begin
    nGamerAmount:= FSubAccounts[I].Balance;
    if (FSubAccounts[I] as TpoUserPotSubAccount).IsWinner then begin
      nWinnerAmount:= 0;
      FSubAccounts[I].ChargeFunds(nGamerAmount);

      if (FSubAccounts[I] as TpoUserPotSubAccount).InHiCategory then begin
        nWinnerAmount:= nWinnerAmount+nHiWinnersPart;
        FSubAccounts[I].AddFunds(nHiWinnersPart);
        (FSubAccounts[I] as TpoUserPotSubAccount).HiWinnerSubBalance:=
          (FSubAccounts[I] as TpoUserPotSubAccount).HiWinnerSubBalance+nHiWinnersPart;
      end;//else begin
      if (FSubAccounts[I] as TpoUserPotSubAccount).InLoCategory then begin
        nWinnerAmount:= nWinnerAmount+nLoWinnersPart;
        FSubAccounts[I].AddFunds(nLoWinnersPart);
        (FSubAccounts[I] as TpoUserPotSubAccount).LoWinnerSubBalance:=
          (FSubAccounts[I] as TpoUserPotSubAccount).LoWinnerSubBalance+nLoWinnersPart;
      end;//if
      OnPotReconcileOperation(
        (FSubAccounts[I] as TpoUserPotSubAccount).UserID,
        'b',
        nGamerAmount,
        'bet stake'
      );//OnPotReconcileOperation

      OnPotReconcileOperation(
        (FSubAccounts[I] as TpoUserPotSubAccount).UserID,
        'w',
        nWinnerAmount,
        'reconcile winner'
      );//OnPotReconcileOperation
    end else begin
      OnPotReconcileOperation(
        (FSubAccounts[I] as TpoUserPotSubAccount).UserID,
        'l',
        nGamerAmount,
        'reconcile loser'
      );//OnPotReconcileOperation
      FSubAccounts[I].ChargeFunds(FSubAccounts[I].Balance);
    end;//
  end;//for
end;


procedure TpoPotSettlementAccount.RegisterWinner(aGamer: TpoGamer; bInHiCategory: Boolean);
var
  I: Integer;
  usa: TpoUserPotSubAccount;
begin
   for I:= 0 to FSubAccounts.Count-1 do begin
    usa:= FSubAccounts.GetUserSubAccount(aGamer.UserID);
    if usa <> nil then begin
      usa.IsWinner:= True;
      if bInHiCategory then usa.InHICategory:= True
      else usa.InLoCategory:= True;
    end;//if
  end;//for
end;

procedure TpoPotSettlementAccount.SetMaxOperationAmount(
  const Value: Integer);
begin
  FMaxOperationAmount := Value;
end;

function TpoPotSettlementAccount.Store(aWriter: TWriter): Boolean;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteInteger(FMaxOperationAmount);
  aWriter.WriteInteger(FRakesToCharge);
  FSubAccounts.Store(aWriter);
  aWriter.WriteBoolean(FHandledInShowdown);
end;

function TpoPotSettlementAccount.GetLoCategoryWinnersCount: Integer;
var
  I: Integer;
begin
  Result:= 0;
  for I:= 0 to FSubAccounts.Count-1 do begin
    if (FSubAccounts[I] as TpoUserPotSubAccount).IsWinner AND
       ((FSubAccounts[I] as TpoUserPotSubAccount).InLoCategory)
    then Inc(Result);
  end;//for
end;


function TpoPotSettlementAccount.Dump: String;
begin
  Result:= inherited Dump()+LF+
  '-- Pot user sub-accounts: --'+LF+
    SubAccounts.Dump();
end;

procedure TpoPotSettlementAccount.SetRakesToCharge(const Value: Integer);
begin
  FRakesToCharge := Value;
end;

procedure TpoPotSettlementAccount.SetOnPotReconcileOperation(
  const Value: TOnPotReconcileOperation);
begin
  FOnPotReconcileOperation := Value;
end;

procedure TpoPotSettlementAccount.SetHandledInShowdown(
  const Value: Boolean);
begin
  FHandledInShowdown := Value;
end;

{ TpoUserPotsubAccount }

function TpoUserPotSubAccount.Dump: String;
begin
  Result:= inherited Dump()+
    ' IsWinner: '    +IntToStr(Integer(IsWinner))+
    ' InHICategory: '+IntToStr(Integer(InHICategory))+
    ' State: '       +StateAsstring;
end;

function TpoUserPotSubAccount.GetStateAsString: String;
begin
  Result:= nAccountStateToStringMap[State];
end;

function TpoUserPotSubAccount.Load(aReader: TReader): Boolean;
begin
  Result:= inherited Load(aReader);
  FIsWinner:= aReader.ReadBoolean;
  FInHiCategory:= aReader.ReadBoolean;
  FInLoCategory:= aReader.ReadBoolean;
  FState:= TpoAccountState(aReader.ReadInteger);
end;


procedure TpoUserPotSubAccount.SetHiWinnerSubBalance(
  const Value: Integer);
begin
  FHiWinnerSubBalance := Value;
end;

procedure TpoUserPotSubAccount.SetInHICategory(const Value: Boolean);
begin
  FInHICategory := Value;
end;

procedure TpoUserPotSubAccount.SetInLoCategory(const Value: Boolean);
begin
  FInLoCategory := Value;
end;

procedure TpoUserPotSubAccount.SetIsWinner(const Value: Boolean);
begin
  FIsWinner := Value;
end;

procedure TpoUserPotSubAccount.SetLoWinnerSubBalance(
  const Value: Integer);
begin
  FLoWinnerSubBalance := Value;
end;

procedure TpoUserPotSubAccount.SetState(const Value: TpoAccountState);
begin
  FState := Value;
end;

function TpoUserPotSubAccount.Store(aWriter: TWriter): Boolean;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteBoolean(FIsWinner);
  aWriter.WriteBoolean(FInHiCategory);
  aWriter.WriteBoolean(FInLoCategory);
  aWriter.WriteInteger(Integer(State));
end;

{ TpoUserPotSubAccounts }

function TpoUserPotSubAccounts.UpdateSubAccount(nUserID: Integer;
  nAmount: Integer): TpoUserPotSubAccount;
var
  sAccName: string;
  acc: TpoAccount;
begin
  sAccName:= IntToStr(nUserID);
  acc:= AccountByName(sAccName);
  if acc <> nil then Result:= acc as TpoUserPotSubAccount
  else begin
    Result:= TpoUserPotSubAccount.Create(
      sAccName,  POT_ACCOUNT_TYPE, AC_DEFAULT);
    Result.FUserID:= nUserID;
    AddAccount(Result);
  end;//if
  Result.AddFunds(nAmount);
end;

function TpoUserPotSubAccounts.GetAccountClass: TpoAccountClass;
begin
  Result:= TpoUserPotSubAccount;
end;

function TpoUserPotSubAccounts.GetContributorUserID(
  Index: Integer): Integer;
begin
  Result:= StrToInt(Accounts[Index].Name);
end;

function TpoUserPotSubAccounts.GetUserSubAccount(
  nUserID: Integer): TpoUserPotSubAccount;
var
  acc: TpoAccount;
begin
  Result:= nil;
  acc:= AccountByName(IntTostr(nUserID));
  if acc <> nil then Result:= acc as TpoUserPotSubAccount;
end;

function TpoUserPotSubAccounts.HasAllInSubAccounts: Boolean;
var
  I: Integer;
begin
  Result:= False;
  for I:= 0 to Count-1 do begin
    if (Accounts[I] as TpoUserPotSubAccount).State = AS_ALL_IN then begin
      Result:= True;
      Exit;
    end;//if
  end;//for
end;

function TpoUserPotSubAccounts.GetSubAccounts(
  Index: Integer): TpoUserPotSubAccount;
begin
  Result:= Accounts[Index] as TpoUserPotSubAccount;
end;

{ TpoUserSettlementAccount }

function TpoUserSettlementAccount.Dump: String;
begin
  Result:= inherited Dump()+ ' State: '+StateAsString;
end;

function TpoUserSettlementAccount.GetStateAsString: String;
begin
  Result:= nAccountStateToStringMap[State];
end;

function TpoUserSettlementAccount.Load(aReader: TReader): Boolean;
begin
  Result:= inherited Load(aReader);
  FState:= TpoAccountState(aReader.ReadInteger);
end;

procedure TpoUserSettlementAccount.SetState(const Value: TpoAccountState);
begin
  FState := Value;
end;

function TpoUserSettlementAccount.Store(aWriter: TWriter): Boolean;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteInteger(Integer(State));
end;


function TpoPotSettlementAccounts.GetSubAccount(
  Index: Integer): TpoPotSettlementAccount;
begin
  Result:= FAccounts[Index] as TpoPotSettlementAccount;
end;

{ TpoMultiTableTournamentCroupier }

constructor TpoMultiTableTournamentCroupier.Create(
  aTable: TpoTable; nPokerType: TpoPokerType; sCurrencySymbol: string;
  nMinGamersForStartHand: Integer
);
begin
  inherited Create(
    aTable, nPokerType, sCurrencySymbol, nMinGamersForStartHand
  );
  TournamentType:= TT_MULTI_TABLE;
end;

function TpoMultiTableTournamentCroupier.HandleTournamentBreak(sReason: String): boolean;
var
  I: Integer;
begin
  SendMessage(sReason);
  Result:= True;
  if Assigned(OnMultyTournamentProcState) then begin
    for I:=0 to FTable.FGamers.Count - 1 do begin
      OnMultyTournamentProcState(FTable.FGamers[I]);
    end;
  end;
end;

function TpoMultiTableTournamentCroupier.HandleTournamentEnd(sReason: String): 
    boolean;
begin
  Hand.State:= HST_IDLE;
//  if sReason = '' then sReason:= 'Tournament is completed.';
  SendProcCloseAction(sReason);
  Result:= True;
end;

function TpoMultiTableTournamentCroupier.HandleTournamentFree(sReason: String):
    boolean;
var
  I: Integer;
  aGamer: TpoGamer;
begin
  Result := True; 
  for I:= FTable.Gamers.Count-1 downto 0 do begin
    aGamer := FTable.Gamers[I];
    if (aGamer.ChairID = UNDEFINED_POSITION_ID) OR (aGamer.FinishedTournament) then
      OnGamerKickOff(aGamer, sReason);
    if not (aGamer.ChairID = UNDEFINED_POSITION_ID) then
      FTable.FChairs[aGamer.ChairID].KickOffGamer(True);
    FTable.Gamers.DeleteGamer(aGamer);
  end;//for
end;

function TpoMultiTableTournamentCroupier.HandleTournamentInit(aParticipants:
    Variant; sReason: String): boolean;
begin
  Hand.Reset;
  FTournamentStatus:= TST_RUNNING;
  Hand.State:= HST_INIT;
  Hand.DealerChairID:= UNDEFINED_POSITION_ID; //to initiate dealer round
  ArrangeTournamentParticipants(aParticipants, GS_SITOUT, sReason);
  DealCardsForTournamentDealerRound;
  if sReason <> '' then SendMessage(sReason);
  Result:= True;
end;

function TpoMultiTableTournamentCroupier.HandleTournamentPlay(nHandID: Integer;
    aParticipants: Variant; sReason: String): boolean;
begin
  Hand.Reset;
  ArrangeTournamentParticipants(aParticipants, GS_NONE, sReason); //leave statuses
  Result:= HandleTournamentResume(nHandID, sReason, -1, []);
end;

function TpoMultiTableTournamentCroupier.HandleTournamentResume(nHandID:
  Integer; sReason: String;
  nPlrsCnt: Integer;
  vLostPlayers: Array of Variant
  ): boolean;

  function CalcTournamentParticipants(): Integer;
  var
    I: Integer;
  begin
    Result:= 0;
    for I:= 0 to FTable.Chairs.Count-1 do begin
      if (FTable.Chairs[I].Gamer = nil) OR (FTable.Chairs[I].Gamer.FinishedTournament) then Continue;
      Inc(Result);
    end;//for
  end;//for

var
  nPlrsAtTheTable: Integer;
  I: Integer;
  g: TpoGamer;
begin
  SendMessage(sReason);

//add gamer manipulation logic
  if nPlrsCnt <> -1 then begin
    nPlrsAtTheTable:= CalcTournamentParticipants();
    if nPlrsCnt <> nPlrsAtTheTable then begin
      DumpCachedStateToFile;
      CommonDataModule.Log(ClassName, 'HandleTournamentResume',
        '[EXCEPTION] ' +
        'Gamers count on resume does not correspond to actual gamers '+
        'amount at the table ('+IntToStr(nPlrsCnt)+' against '+IntToStr(nPlrsAtTheTable)+')' +
        '; nHandID=' + IntToStr(nHandID) + ', InetrnalHandID=' + IntToStr(Hand.FHandID) +
        ', PrevInternalHandID=' + IntToStr(Hand.PrevHandID),
        ltException);

      EscalateFailure(
        EpoException,
        'Gamers count on resume does not correspond to actual gamers '+
        'amount at the table ('+IntToStr(nPlrsCnt)+' against '+IntToStr(nPlrsAtTheTable)+')',
        '{C515F98E-7D1C-4331-BCA7-411A6D240A34}'
      );

    end;
  end;//if

  if Length(vLostPlayers) > 0 then begin
    for I:= 0 to High(vLostPlayers) do begin
      g:= Gamers.GamerByUserID(vLostPlayers[I]);
      if g = nil then EscalateFailure(
        EpoException,
        'Lost gamer with ID: '+IntToStr(vLostPlayers[I])+' not found amoung table participants.',
        '{C150B4A9-8600-4C2F-B850-8A04DA7F83FC}'
      );//if
      g.State:= GS_ALL_IN;

//bot post on all in
      PostRandomAnswerOnCategory(g, BCP_GOES_ALL_IN);

    end;//for

    TakeAllInsOffMultyTournament;
  end;//if

  Result:= StartHand(nHandID);
end;

function TpoMultiTableTournamentCroupier.HandleTournamentStandUp(
  sReason: String; nPlrsCnt: Integer; bSetAsWatcher: Boolean;
  vLostPlayers: Variant
): boolean;
var
  nPlrsAtTheTable: Integer;
  I: Integer;
  g: TpoGamer;
  sMessage: string;
  vArrLost, vArrData: array of Variant;
  aChair: TpoChair;

  function CalcTournamentParticipants(): Integer;
  var
    I: Integer;
  begin
    Result:= 0;
    for I:= 0 to FTable.Chairs.Count-1 do begin
      if (FTable.Chairs[I].Gamer = nil) OR (FTable.Chairs[I].Gamer.FinishedTournament) then Continue;
      Inc(Result);
    end;//for
  end;//for

begin
//add gamer manipulation logic
  if nPlrsCnt <> -1 then begin
    nPlrsAtTheTable:= CalcTournamentParticipants();
    if nPlrsCnt <> nPlrsAtTheTable then begin
      DumpCachedStateToFile;
      CommonDataModule.Log(ClassName, 'HandleTournamentStandUp',
        '[EXCEPTION] ' +
        'Gamers count on resume does not correspond to actual gamers '+
        'amount at the table ('+IntToStr(nPlrsCnt)+' against '+IntToStr(nPlrsAtTheTable)+')',
        ltException);
(*
      EpoException,
        'Gamers count on resume does not correspond to actual gamers '+
        'amount at the table ('+IntToStr(nPlrsCnt)+' against '+IntToStr(nPlrsAtTheTable)+')',
        '{E0700E25-B242-4C3E-B276-BFE644F48B77}'
      );
*)
    end;
  end;//if

  vArrLost := vLostPlayers;
  SetLength(vArrData, 0);
  if (Length(vArrLost) > 0) then begin
    for I:= 0 to High(vArrLost) do begin
      vArrData := vArrLost[I];
      g:= FTable.Gamers.GamerByUserID(vArrData[0]);
      if (g = nil) then begin
        CommonDataModule.Log(ClassName, 'HandleTournamentStandUp',
          '[ERROR]: Gamer with ID: '+IntToStr(vArrData[0])+' not found.',
          ltError);
        Continue;
      end;

      if g.ChairID <> UNDEFINED_POSITION_ID then begin
        aChair := FTable.Chairs[g.ChairID];
        sMessage := 'Gamer ' + g.FUserName + ' has been moved to another table.';

        g.FinishedTournament := True;
        g.State := GS_IDLE;
        g.FAllInRejectionHandID:= PlayedHandsInTournament;
        aChair.Hidden := True;
        if Assigned(OnChairStateChange) then OnChairStateChange(g, g.ChairID);

        aChair.KickOffGamer;
        if not bSetAsWatcher then begin
          FTable.Gamers.DeleteGamer(g);
          if Assigned(OnChatMessage) then OnChatMessage(sMessage);
        end;
      end;//if
    end;//for
  end;//for
  Result := True;
end;

function TpoMultiTableTournamentCroupier.HandleTournamentKickOff(
  sReason: String; nPlrsCnt: Integer;
  vLostPlayers: Variant
): boolean;
var
  nPlrsAtTheTable: Integer;
  I: Integer;
  g: TpoGamer;
  sMessage: string;
  arrLost, arrLostData: array of Variant;

  function CalcTournamentParticipants(): Integer;
  var
    I: Integer;
  begin
    Result:= 0;
    for I:= 0 to FTable.Chairs.Count-1 do begin
      if (FTable.Chairs[I].Gamer = nil) OR (FTable.Chairs[I].Gamer.FinishedTournament) then Continue;
      Inc(Result);
    end;//for
  end;//for

begin
  SetLength(arrLostData, 0);
  //add gamer manipulation logic
  if nPlrsCnt <> -1 then begin
    nPlrsAtTheTable:= CalcTournamentParticipants();
    if nPlrsCnt <> nPlrsAtTheTable then begin
      DumpCachedStateToFile;
      CommonDataModule.Log(ClassName, 'HandleTournamentKickOff',
        '[EXCEPTION] ' +
        'Gamers count on resume does not correspond to actual gamers '+
        'amount at the table ('+IntToStr(nPlrsCnt)+' against '+IntToStr(nPlrsAtTheTable)+')',
        ltException);
    end;
  end;//if

  arrLost := vLostPlayers;
  if (Length(arrLost) > 0) then begin
    for I:= 0 to High(arrLost) do begin
      arrLostData := arrLost[I];
      g:= FTable.Gamers.GamerByUserID(arrLostData[0]);
      if g = nil then EscalateFailure(
        EpoException,
        'KickOff gamer with ID: '+IntToStr(vLostPlayers[I])+' not found amoung table participants.',
        '{59AEAE0F-67F2-4A65-9AAD-3684CA8DA9F0}'
      );//if

      if g.ChairID <> UNDEFINED_POSITION_ID then begin
        sMessage := g.FUserName + ' will be kicked off by administrator after finish hand.';
        if Assigned(OnChatMessage) then OnChatMessage(sMessage);
        g.KickOffFromTournament := True;
      end;//if
    end;//for
  end;//for
  Result := True;
end;

function TpoMultiTableTournamentCroupier.HandleTournamentSitDown(
  sReason: String; nPlrsCnt: Integer;
  vNewPlayers: Variant
): boolean;
var
  I: Integer;
  g: TpoGamer;

  nCnt: Integer;
  gp, gd: Array of Variant;

  nSessionID, nUserID, nPosition: Integer;
  nAmount: Integer;
  // after added bots
  bIsBot: Boolean;
  nBotID, nBotBlaffers, nBotCharacter, nSexID, nAvatarID, nLevelID: Integer;
  sBotCity, sBotName: string;
  aIcons: TStringList;
begin
  SetLength(gd, 0);
  g:= nil;
  gp:= vNewPlayers;
  nCnt:= High(gp)+1;
  aIcons := TStringList.Create;
//allocate gamers
  for I:= 0 to nCnt-1 do begin
    gd:= gp[I];
    nUserID     := gd[0];
    nSessionID  := gd[1];
    nPosition   := gd[2];
    nAmount     := Trunc(gd[3] * 100);
    if nPosition = UNDEFINED_POSITION_ID then begin
      EscalateFailure(
        EpoException,
        'Position of tournament participant (SessionID: '+IntToStr(nSessionID)+', UserID: '+IntToStr(nUserID)+') is undefined',
        '{EB610C74-0211-42DC-AA5C-16F39F89A271}'
      );
    end;//if
    if nUserID <> UNDEFINED_USER_ID then begin
      g:= FTable.Gamers.GamerByUserID(nUserID);
    end else if nSessionID <> UNDEFINED_SESSION_ID then begin
      g:= FTable.Gamers.GamerBySessionID(nSessionID);
    end else begin
      EscalateFailure(
        EpoException,
        'Tournament participant is undefined - both session and user IDs are unknown.',
        '{EB610C74-0211-42DC-AA5C-16F39F89A271}'
      );
    end;//if

    // bots values
    bIsBot := Boolean(gd[4]);
    nBotID := gd[5];
    nBotBlaffers := gd[6];
    nBotCharacter := gd[7];
    nSexID := gd[8];
    nAvatarID := gd[9];
    sBotCity := gd[10];
    sBotName := gd[11];
    nLevelID := gd[12];

    aIcons.Clear;
    aIcons.Add(gd[13]);
    aIcons.Add(gd[14]);
    aIcons.Add(gd[15]);
    aIcons.Add(gd[16]);

    //add host support for gamers allocation packets
    if g = nil then begin
      if bIsBot then begin
        g:= Gamers.RegisterGamer(nSessionID, '', nUserID, sBotName, nSexID, sBotCity, nAvatarID, 0, True, 1, True, 0, aIcons);
      end else begin
        g:= Gamers.RegisterGamer(nSessionID, '', nUserID, '', 0, '', 0, 0, True, 1, True, nLevelID, aIcons);
      end;
    end else begin
      g.SessionID := nSessionID;
      g.UserID    := nUserID;
    end;//if

    if bIsBot then begin
      g.FIsBot := True;
      g.FBotID := nBotID;
      g.FBotBlaffersEvent := nBotBlaffers;
      if not (nBotCharacter in [Integer(Low(TFixUserCharacter))..Integer(High(TFixUserCharacter))]) then
        nBotCharacter := 1;
      g.FBotCharacter := TFixUserCharacter(nBotCharacter);
    end; //if

    if Assigned(OnUpdateGamerDetails) then OnUpdateGamerDetails(g);

    g.SitDownAt(FTable.Chairs[nPosition], nAmount);
    g.FFinishedHands := 0;

    // set state of gamer on sitdown
    if g.FIsBot then begin
      g.State              := GS_IDLE;
      g.PassNextHand       := False;
      g.FPassCurrentHand   := True;
    end else begin
      g.SitOut;
      g.PassNextHand       := True;
    end;
    // ***********************************************
    // WARNING!!! for PassCurrentHand not use property
    // only use private FPassCurrentHand
    g.FPassCurrentHand   := True;
    // ***********************************************
    g.FinishedTournament := False;

    if Assigned(OnChairStateChange) then OnChairStateChange(g, nPosition);
    if not g.FIsBot then begin
      if Assigned(OnGamerSitOut) then OnGamerSitOut(g);
      if Assigned(OnMultyTournamentProcState) then OnMultyTournamentProcState(g);
    end;
  end;//for

  aIcons.Clear;
  aIcons.Free;

  Result:= True;
end;

function TpoMultiTableTournamentCroupier.ArrangeTournamentParticipants(
    aParticipants: Variant; nInitialGamerState: TpoGamerState;
    sTakeOffReason: String
    ): Boolean;
var
  I, nCnt: Integer;
  gp, gd: Array of Variant;
  g: TpoGamer;

  nSessionID, nUserID, nPosition: Integer;
  nAmount: Integer;
  // after added bots
  bIsBot: Boolean;
  nBotID, nBotBlaffers, nBotCharacter, nSexID, nAvatarID, nLevelID: Integer;
  sBotCity, sBotName: string;
  aIcons: TStringList;
begin
  SetLength(gd, 0);
  g:= nil;
  gp:= aParticipants;
  if NOT (Hand.State IN [HST_IDLE, HST_INIT]) then begin
    EscalateFailure(
      EpoException,
      'Cannot reassign gamers while hand in progress.',
      '{07BBDD06-A5E4-4302-95FB-E6416824FA1A}'
    );
  end;//if

  gp:=  aParticipants;
  nCnt:= Length(gp);
  if (nCnt > Chairs.Count) or (nCnt <= 0) then begin
    EscalateFailure(
      EpoException,
      'Number of participants ('+IntToStr(nCnt)+') is incorrect (Chairs count='+IntToStr(Chairs.Count)+').',
      '{07BBDD06-A5E4-4302-95FB-E6416824FA1A}'
    );
  end;//if

//clear chairs
  Chairs.KickOffAllGamers;

//allocate gamers
  aIcons := TStringList.Create;
  for I:= 0 to nCnt-1 do begin
    gd:= gp[I];
    nUserID     := gd[0];
    nSessionID  := gd[1];
    nPosition   := gd[2];
    nAmount     := Trunc(gd[3] * 100);
    if nPosition = UNDEFINED_POSITION_ID then begin
      EscalateFailure(
        EpoException,
        'Position of tournament participant (SessionID: '+IntToStr(nSessionID)+', UserID: '+IntToStr(nUserID)+') is undefined',
        '{EB610C74-0211-42DC-AA5C-16F39F89A271}'
      );
    end;//if
    if nUserID <> UNDEFINED_USER_ID then begin
      g:= Gamers.GamerByUserID(nUserID);
    end else
    if nSessionID <> UNDEFINED_SESSION_ID then begin
      g:= Gamers.GamerBySessionID(nSessionID);
    end else
    begin
      EscalateFailure(
        EpoException,
        'Tournament participant is undefined - both session and user IDs are unknown.',
        '{EB610C74-0211-42DC-AA5C-16F39F89A271}'
      );
    end;//if

    // bots values
    bIsBot := Boolean(gd[4]);
    nBotID := gd[5];
    nBotBlaffers := gd[6];
    nBotCharacter := gd[7];
    nSexID := gd[8];
    nAvatarID := gd[9];
    sBotCity := gd[10];
    sBotName := gd[11];
    nLevelID := gd[12];

    aIcons.Clear;
    aIcons.Add(gd[13]);
    aIcons.Add(gd[14]);
    aIcons.Add(gd[15]);
    aIcons.Add(gd[16]);

    //add host support for gamers allocation packets
    if g = nil then begin
      if bIsBot then begin
        g:= Gamers.RegisterGamer(nSessionID, '', nUserID, sBotName, nSexID, sBotCity, nAvatarID, 0, True, 1, True, 0, aIcons);
      end else begin
        g:= Gamers.RegisterGamer(nSessionID, '', nUserID, '', 0, '', 0, 0, True, 1, True, nLevelID, aIcons);
      end;
    end else begin
      g.SessionID := nSessionID;
      g.UserID    := nUserID;
    end;//

    if bIsBot then begin
      g.FIsBot := True;
      g.FBotID := nBotID;
      g.FBotBlaffersEvent := nBotBlaffers;
      if not (nBotCharacter in [Integer(Low(TFixUserCharacter))..Integer(High(TFixUserCharacter))]) then
        nBotCharacter := 1;
      g.FBotCharacter := TFixUserCharacter(nBotCharacter);
    end;

    if Assigned(OnUpdateGamerDetails) then OnUpdateGamerDetails(g);

    g.SitDownAt(Chairs[nPosition], nAmount);

    case nInitialGamerState of
      GS_SITOUT :
        begin
          if g.IsBot then g.State:= GS_IDLE else g.SitOut;
        end;//if

      GS_PLAYING:
        begin
          if (g.UserID <> UNDEFINED_USER_ID) AND (g.SessionID <> UNDEFINED_SESSION_ID) then begin
            g.State:= GS_PLAYING
          end else begin
            if g.FIsBot then g.State := GS_IDLE else g.State:= GS_SITOUT;
          end
        end;//

      GS_NONE:; //leave it as is
      else
        if g.FIsBot then g.State := GS_IDLE else g.State:= nInitialGamerState;
    end;//case
  end;//for

  aIcons.Clear;
  aIcons.Free;

//take watchers off the table
  for I:= FTable.Gamers.Count-1 downto 0 do begin
    if (FTable.Gamers[I].ChairID = UNDEFINED_POSITION_ID) OR
      (FTable.Gamers[I].FinishedTournament) then
    begin
      OnGamerKickOff(FTable.Gamers[I], sTakeOffReason);
      FTable.Gamers.DeleteGamer(FTable.Gamers[I]);
    end;//if
  end;//for
//
  Result:= True;
end;//TpoGenericTournamentCroupier.AllocateTournamentParticipants


function TpoMultiTableTournamentCroupier.FinishHand: Boolean;
begin
  Result:= True;
//define winner

  ClearAllGamersShowDownPassedAndFinishTournament;
  // correct bots
  CheckForBotsContinue;

//clear accounts
  Hand.Finish;

  //finish hand packet and history
  if Assigned(OnHandFinish) then OnHandFinish(GetHandReconcileContext());
  //Schedule finish hand to reminder
  if Assigned(OnTournamentHandFinish) then begin
    OnTournamentHandFinish(Self, GetBigBlindStakeValue);
  end;//if

  TakeAllInsOffMultyTournament;

//initiate next hand
  Hand.State := HST_IDLE;
  Hand.ActiveGamer:= nil;
  Hand.ActiveChairID:= UNDEFINED_POSITION_ID;
end;

procedure TpoMultiTableTournamentCroupier.TakeAllInsOffMultyTournament;
var
  I: Integer;
  sMessage: string;
  aChair: TpoChair;
  aGamer: TpoGamer;
begin
  for I:= 0 to FTable.FChairs.Count-1 do begin
    aChair := FTable.FChairs[I];
    aGamer := aChair.Gamer;

    if aGamer = nil then Continue;
    if aGamer.FinishedTournament then Continue;
    if (aGamer.Account.Balance <= 0) then begin
      aGamer.State := GS_ALL_IN;

//bot post on all in
      PostRandomAnswerOnCategory(aGamer, BCP_GOES_ALL_IN);

    end else begin
      aGamer.State := GS_IDLE;
    end;//if

    if (aGamer.State = GS_ALL_IN) or aGamer.KickOffFromTournament then begin
      if aGamer.KickOffFromTournament then
        sMessage := aGamer.UserName + ' kicked off by administrator.'
      else
        sMessage := aGamer.UserName + ' finished tournament.';
      if Assigned(OnChatMessage) then OnChatMessage(sMessage);

//      if aGamer.KickOffFromTournament or ((aGamer.State = GS_ALL_IN) and aGamer.IsBot) then begin
        aGamer.FinishedTournament := True;
        aGamer.State := GS_IDLE;
        aGamer.FAllInRejectionHandID:= PlayedHandsInTournament;

        if aGamer.IsBot or aGamer.KickOffFromTournament then begin
          aChair.Hidden := True;
          aGamer.StandUp;
          if Assigned(OnChairStateChange) then OnChairStateChange(aGamer, I);
        end;
        if aGamer.IsBot then FTable.Gamers.DeleteGamer(aGamer);
//      end;
    end;//if
(* OLD Version
    if (aGamer.State = GS_ALL_IN) or aGamer.KickOffFromTournament then begin
      if aGamer.KickOffFromTournament then
        sMessage := aGamer.UserName + ' kicked off by administrator.'
      else
        sMessage := aGamer.UserName + ' finished tournament.';
      if Assigned(OnChatMessage) then OnChatMessage(sMessage);

      aGamer.FinishedTournament := True;
      aGamer.State := GS_IDLE;
      aGamer.FAllInRejectionHandID:= PlayedHandsInTournament;

      aChair.Hidden := True;
      aGamer.StandUp;
      if Assigned(OnChairStateChange) then OnChairStateChange(aGamer, I);
      if aGamer.IsBot then FTable.Gamers.DeleteGamer(aGamer);
    end;//if
*)
  end;//for
end;

function TpoMultiTableTournamentCroupier.HandleGamerSitOut(
  aGamer: TpoGamer): TpoGamer;
var
  bFolded: Boolean;
begin
  Result:= aGamer;
  bFolded := Result.State = GS_FOLD;
  if Result.IsSitOut then begin
    if (Result.State <> GS_FOLD) then Result.State := GS_SITOUT;
  end else begin
    Result.SitOut;
    if Assigned(OnGamerAction) then OnGamerAction(aGamer, GA_SIT_OUT, []);
    if bFolded then Result.State := GS_FOLD;
  end;//if
end;

function TpoMultiTableTournamentCroupier.HandleTournamentRebuy(
  sReason: String; nPlrsCnt: Integer; vPlayers: Variant): boolean;
var
  I: Integer;
  g: TpoGamer;

  nCnt: Integer;
  gp, gd: Array of Variant;

  nSessionID, nUserID, nPosition: Integer;
  nAmount: Integer;
  bIsBot: Boolean;
begin
  SetLength(gd, 0);
  g:= nil;
  gp:= vPlayers;
  nCnt:= High(gp)+1;
//allocate gamers
  for I:= 0 to nCnt-1 do begin
    gd:= gp[I];
    nUserID     := gd[0];
    nSessionID  := gd[1];
    nPosition   := gd[2];
    nAmount     := Trunc(gd[3] * 100);
    if nPosition = UNDEFINED_POSITION_ID then begin
      EscalateFailure(
        EpoException,
        'Position of tournament participant (SessionID: '+IntToStr(nSessionID)+', UserID: '+IntToStr(nUserID)+') is undefined',
        '{EB610C74-0211-42DC-AA5C-16F39F89A271}'
      );
    end;//if
    if nUserID <> UNDEFINED_USER_ID then begin
      g:= FTable.Gamers.GamerByUserID(nUserID);
    end else if nSessionID <> UNDEFINED_SESSION_ID then begin
      g:= FTable.Gamers.GamerBySessionID(nSessionID);
    end else begin
      EscalateFailure(
        EpoException,
        'Tournament participant is undefined - both session and user IDs are unknown.',
        '{EB610C74-0211-42DC-AA5C-16F39F89A271}'
      );
    end;//if

    if (g = nil) then begin
      EscalateFailure(
        EpoSessionException,
        'Gamer not found for UserID=' + IntToStr(nUserID) + ', SessionID=' + IntToStr(nSessionID),
        '{B607E0D5-EFF3-4AC6-A8F9-983A13B73A09}'
      );
    end;

    // bots values
    bIsBot := Boolean(gd[4]);
    if bIsBot then begin
      CommonDataModule.Log(ClassName, 'HandleTournamentRebuy',
        '[ERROR]: Bot can not perform rebuy action; UserID=' +
        IntToStr(nUserID) + ', SessionID=' + IntToStr(nSessionID),
        ltError);
    end; //if

    g.FDuringGameAddedMoney := g.FDuringGameAddedMoney + nAmount;
    if not (FTable.FHand.State = HST_RUNNING) and Assigned(OnMoreChips) then
      OnMoreChips(g);

    if Assigned(OnChatMessage) then
      OnChatMessage(g.FUserName + ' has just bought ' + CurrToStr(nAmount / 100) + ' chips.');
  end;//for

  Result:= True;
end;

{ TpoSingleTableTournamentCroupier }

constructor TpoSingleTableTournamentCroupier.Create(
  aTable: TpoTable; nPokerType: TpoPokerType; sCurrencySymbol: string;
  nMinGamersForStartHand: Integer
);
begin
  inherited Create(aTable, nPokerType, sCurrencySymbol, nMinGamersForStartHand);
end;

function TpoSingleTableTournamentCroupier.HandleTournamentRebuy(
  sReason: String; nPlrsCnt: Integer; vPlayers: Variant): boolean;
begin
  Result := False;
end;

{ TpoGenericTournamentCroupier }

procedure TpoGenericTournamentCroupier.ChargeRakes;
begin
//Rakes are managed outside of engine
end;

constructor TpoGenericTournamentCroupier.Create(
  aTable: TpoTable; nPokerType: TpoPokerType; sCurrencySymbol: string;
  nMinGamersForStartHand: Integer
);
begin
  inherited Create(
    aTable, nPokerType, sCurrencySymbol, nMinGamersForStartHand
  );
  Version:= 3;
  TournamentType:= TT_SINGLE_TABLE;
end;

procedure TpoGenericTournamentCroupier.DealCardsForTournamentDealerRound;
var
  I: Integer;
  bCardHasDeal: Boolean;
begin
  if PokerClass = PTC_CLOSED_CARDS_POKER then Exit;
  Hand.ResetCardDeck;
  bCardHasDeal:= False;
  for I:= 0 to Chairs.Count -1 do begin
    if Chairs[I].Gamer = nil then Continue;
    Chairs[I].Gamer.Cards.Clear;
    Hand.CardsToDeal.DealTopCardTo(Chairs[I].Gamer.Cards, True);
    bCardHasDeal:= True;
  end;//for
  if bCardHasDeal AND Assigned(OnDealCards) then begin
    OnDealCards(Self, VarArrayOf([-1, True]));
  end;//if
end;

function TpoGenericTournamentCroupier.DefineDealerForTournament: Boolean;
var
  I: Integer;
  cc: TpoCardCollection;
begin
  Result:= False;
  cc:= TpoCardCollection.Create(FTable.Cards);

  if PokerClass = PTC_OPEN_CARDS_POKER then begin
  //gather cards
    for I:= 0 to Chairs.Count-1 do begin
      if NOT Chairs[I].IsBusy then Continue;
      cc.AttachCard(Chairs[I].Gamer.Cards[0]).FCustomData:= I;//mark card by chair ID
    end;//for

  //define dealer
    if cc.Count = 0 then EscalateFailure(
      'There are no gamers registered for tournament',
      '{255B6178-C9EF-4451-8AAA-2CED6E107369}'
    );
    cc.Sort(True);
    Hand.DealerChairID:= cc[0].CustomData;
    Hand.FPrevDealerChairID:= UNDEFINED_POSITION_ID; //break up dealer sequencing
  end else Hand.DealerChairID:= UNDEFINED_POSITION_ID;
  cc.Free;
end;

procedure TpoGenericTournamentCroupier.DefineGamersAndDealerForCurrentHand;

  procedure DefineHandCandidates();
  var
    I: Integer;
  begin
    for I:= 0 to Chairs.Count-1 do begin
      if Chairs[I].Gamer = nil then Continue;
      if (Chairs[I].Gamer.State = GS_IDLE) AND (NOT (Chairs[I].Gamer.FinishedTournament))
      then Chairs[I].Gamer.State := GS_PLAYING;
    end;//for
  end;//

  function FindDealerCandidate(): TpoGamer;
  var
    ch, cch: TpoChair;
    CntIter: Integer;
  begin
    Result:= nil;
    if (Hand.DealerChairID = UNDEFINED_POSITION_ID) then begin
      ch:= FindStepRightChairLeftToPosition(Chairs.Count); //first from the left
      Hand.DealerChairID:= ch.IndexOf;
      Result:= ch.Gamer;
    end else
    if (Hand.DealerChairID = Hand.FPrevDealerChairID) then begin //there was set in prev round
      ch:= FindStepRightChairLeftToPosition(Hand.DealerChairID);
      cch:= ch;

      CntIter := -1;
      repeat
        Inc(CntIter);
        if (CntIter > (Chairs.Count + 1)) then begin
          CommonDataModule.Log(ClassName, 'FindDealerCandidate',
          '[WARNING - CIRCLE]: Count of iterations in REPEAT statment more then needing. Iteration count=' + IntToStr(CntIter) + ', Chair count=' + IntToStr(Chairs.Count) +
            'Dialer=' + IntToStr(Hand.DealerChairID) + ', Active=' + IntToStr(Hand.FActiveChairID) +
            ', SmallBlind' + IntToStr(Hand.FSmallBlindChairID) + ', BigBlind=' + IntToStr(Hand.FBigBlindChairID) +
            ', HandID=' + IntToStr(Hand.HandID) + ', Round=' +IntToStr(Hand.RoundID),
          ltError);
          EscalateFailure(
            EpoException,
            'Count of iterations in REPEAT statment more then needing. Iteration count=' + IntToStr(CntIter) + ', Chair count=' + IntToStr(Chairs.Count),
            '{63C178E8-EFAC-45D7-9A10-67932E089F8B}'
          );
        end;

        if (NOT ch.Gamer.MustSetBigBlind) AND (NOT ch.Gamer.MustSetPostDead) AND (NOT ch.Gamer.MustSetPost) then Break;
        ch:= FindStepRightChairLeftToPosition(ch.IndexOf);
        if cch = ch then begin
          ClearBigBlindIssues;
          Break;
(*
          EscalateFailure(
            EpoException,
            'Undefined dealer candidate',
            '{46F2BA7D-1B2B-469E-B86D-E621FD6CACAA}'
          );
*)
        end;//if
      until False;
      if ch = nil then ch:= FindStepRightChairLeftToPosition(Chairs.Count); //first from the left
      Hand.DealerChairID:= ch.IndexOf;
      Result:= ch.Gamer;
    end;//define dealer
  end;//

begin
//define candidates for the hand
  DefineHandCandidates();

//define dealer
  case PokerType of
  //clock wise dealer definition
    PT_TEXAS_HOLDEM,    //1 - Texas Hold'em
    PT_OMAHA,           //2 – Omaha
    PT_OMAHA_HILO:      //3 - Omaha Hi Lo
      begin
        if Hand.DealerChairID = UNDEFINED_POSITION_ID then DefineDealerForTournament()
        else FindDealerCandidate();
      end;//if

    PT_SEVEN_STUD,
    PT_SEVEN_STUD_HILO:
      Hand.DealerChairID:= UNDEFINED_POSITION_ID;
  end;//case
end;

var
  TournamentStatusToStringMap: Array [TpoTournamentStatus] of String = (
    'Registering', //TST_WAITING,
    'Starting', //TST_STARTING,
    'Running', //TST_RUNNING,
    'Completed' //TST_FINISHED
  );

function TpoGenericTournamentCroupier.GetGamerActionTimeout(
  aGamer: TpoGamer): Integer;
begin
  Result:= inherited GetGamerActionTimeout(aGamer);// + aGamer.FTournamentTimebank;
end;

function TpoGenericTournamentCroupier.GetTournamentStatusAsString: String;
begin
  Result:= TournamentStatusToStringMap[TournamentStatus];
end;

function TpoGenericTournamentCroupier.GetValidGamerActions(
  aGamer: TpoGamer): TpoGamerActions;
begin
  Result:= inherited GetValidGamerActions(aGamer);
  Result:= Result - [GA_SIT_OUT, GA_LEAVE_TABLE];
end;

function TpoGenericTournamentCroupier.HandleGamerBack(
  aGamer: TpoGamer): TpoGamer;
begin
  Result:= aGamer;
  aGamer.IsTakedSit := True;

  if Result.FinishedTournament then Exit;

  Result.Back;
  case Hand.State of
    HST_RUNNING: if Result.State = GS_IDLE then Result.State:= GS_PLAYING;
  else
    if (TournamentType = TT_MULTI_TABLE) then begin
      aGamer.PassNextHand := False;
      aGamer.PassCurrentHand := False;
    end;
  end;//case

  if Assigned(OnGamerBack) then begin
    OnGamerBack(Result);
  end;//if

  if Assigned(OnChairStateChange) then begin
    OnChairStateChange(aGamer, aGamer.ChairID);
  end;//if
end;//TpoGenericTournamentCroupier.HandleGamerBack


function TpoGenericTournamentCroupier.HandleGamerLeaveTable(
  aGamer: TpoGamer): TpoGAmer;
begin
  if TournamentStatus in [TST_STARTING, TST_RUNNING] then Result:= HandleGamerSitOut(aGamer)
  else Result:= inherited HandleGamerLeaveTable(aGamer);
end;

function TpoGenericTournamentCroupier.HandleGamerProcInit(
  aGamer: TpoGamer): TpoGamer;
begin
  Result:= inherited HandleGamerProcInit(aGamer);
  if (aGamer.Account.Balance > 0) AND (aGamer.State = GS_SITOUT) then begin
    if (Hand.State = HST_RUNNING) then aGamer.State:= GS_PLAYING
    else aGamer.State:= GS_IDLE;
  end;//if
end;

function TpoGenericTournamentCroupier.HandleGamerProcState(
  aGamer: TpoGamer): TpoGamer;
begin
  Result:= inherited HandleGamerProcInit(aGamer);
  if (aGamer.Account.Balance > 0) AND (aGamer.State = GS_SITOUT) then begin
    if (Hand.State = HST_RUNNING) then aGamer.State:= GS_PLAYING
    else aGamer.State:= GS_IDLE;
  end;//if
end;

function TpoGenericTournamentCroupier.HandleGamerSitOut(
  aGamer: TpoGamer): TpoGamer;
begin
  Result:= aGamer;
  if Result.IsSitOut then begin
    if (Result.State <> GS_FOLD) then Result.State := GS_SITOUT;
  end else begin
    Result.SitOut;
    if Hand.ActiveGamer = aGamer then HandleGamerActionExpired(aGAmer)
    else if Assigned(OnGamerAction) then OnGamerAction(aGamer, GA_SIT_OUT, []);
  end;//if
end;

function TpoGenericTournamentCroupier.HandleGamerUseTimeBank(
  aGamer: TpoGamer): Boolean;
begin
  if aGamer.TournamentTimebank > 0 then aGamer.ActivateTimeBank:= True;
  Result:= aGamer.ActivateTimeBank;
end;                              

function TpoGenericTournamentCroupier.HandleStake(aGamer: TpoGamer;
  nStake: Integer; nDirectPotAmount: Integer): Integer;
begin
  if (nStake >= aGamer.Account.Balance) then aGamer.FAllInRejectionHandID:= PlayedHandsInTournament;
  Result:= inherited HandleStake(aGamer, nStake, nDirectPotAmount);
end;

function TpoGenericTournamentCroupier.Load(aReader: TReader): Boolean;
begin
  Result:= inherited Load(aReader);
  FTournamentStatus:= TpoTournamentStatus(aReader.ReadInteger);
  FPlayedHandsInTournament:= aReader.ReadInteger;
  FTournamentFee:= aReader.ReadInteger;
  FTournamentBuyIn:= aReader.ReadInteger;
  // Quick Search BS
  FTournamentUseBasePrizes := aReader.ReadBoolean;
  FTournamentBasePaymentType := TpoTournamentPaymentType(aReader.ReadInteger);
  FTournamentBaseFirstPlace := aReader.ReadCurrency;
  FTournamentBaseSecondPlace := aReader.ReadCurrency;
  FTournamentBaseThirdPlace := aReader.ReadCurrency;
  //
  FTournamentUseBonusPrizes := aReader.ReadBoolean;
  FTournamentBonusPaymentType := TpoTournamentPaymentType(aReader.ReadInteger);
  FTournamentBonusFirstPlace := aReader.ReadCurrency;
  FTournamentBonusSecondPlace := aReader.ReadCurrency;
  FTournamentBonusThirdPlace := aReader.ReadCurrency;

  FTournamentSeqID:= aReader.ReadString();
end;//TpoGenericTournamentCroupier.Load

function TpoGenericTournamentCroupier.MandatoryStakesSkipperMustBeBounced: Boolean;
begin
  Result:= False;
end;

function TpoGenericTournamentCroupier.SelectServerGamerAction(
  aGamer: TpoGamer): TpoGamerAction;
var
  va: TpoGamerActions;
begin
  Result:= GA_FOLD;
  if aGamer = nil then begin
    EscalateFailure('Gamer is not defined', '{C6968AE1-B5B1-47F1-83CC-6CB33093B706}');
  end;//

  va:= GetValidGamerActions(aGamer);
  if GA_DONT_SHOW IN va then Result:= GA_DONT_SHOW
  else
  if GA_MUCK IN va then Result:= GA_MUCK
  else
  if GA_SHOW_CARDS_SHUFFLED IN va then Result:= GA_SHOW_CARDS_SHUFFLED
  else
  if GA_SHOW_CARDS IN va then Result:= GA_SHOW_CARDS
  else
  if GA_SIT_OUT IN va then Result:= GA_SIT_OUT
  else
  if GA_POST_SB IN va then Result:= GA_POST_SB
  else
  if GA_POST_BB IN va then Result:= GA_POST_BB
  else
  if GA_ANTE IN va then Result:= GA_ANTE
  else
  if GA_BRING_IN IN va then Result:= GA_FOLD
  else
  if GA_BET IN va then Result:= GA_FOLD
  else
  if GA_FOLD IN va then Result:= GA_FOLD
  else
  if GA_RAISE IN va then Result:= GA_FOLD
  else
  if GA_CALL IN va then Result:= GA_FOLD
  ;
end;

procedure TpoGenericTournamentCroupier.SetOnTournamentFinish(
  const Value: TNotifyEvent);
begin
  FOnTournamentFinish := Value;
end;

procedure TpoGenericTournamentCroupier.SetOnTournamentFinishForBots(
  const Value: TNotifyEvent);
begin
  FOnTournamentFinishForBots := Value;
end;

procedure TpoGenericTournamentCroupier.SetOnTournamentHandFinish(
  const Value: TNotifyEventEx);
begin
  FOnTournamentHandFinish := Value;
end;

procedure TpoGenericTournamentCroupier.SetOnTournamentStart(
  const Value: TNotifyEvent);
begin
  FOnTournamentStart := Value;
end;

procedure TpoGenericTournamentCroupier.SetTournamentBuyIn(
  const Value: Integer);
begin
  FTournamentBuyIn := Value;
end;

procedure TpoGenericTournamentCroupier.SetTournamentFee(
  const Value: Integer);
begin
  FTournamentFee := Value;
end;

function TpoGenericTournamentCroupier.SitOutCanTakeStepRight: Boolean;
begin
  Result:= True;
end;

function TpoGenericTournamentCroupier.StartHand(nHandID: Integer): Boolean;
begin
  Result:= True;
  inherited StartHand(nHandID);
end;

function TpoGenericTournamentCroupier.Store(aWriter: TWriter): Boolean;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteInteger(Integer(FTournamentStatus));
  aWriter.WriteInteger(FPlayedHandsInTournament);
  aWriter.WriteInteger(FTournamentFee);
  aWriter.WriteInteger(FTournamentBuyIn);
  // Quick Search BS
  aWriter.WriteBoolean(FTournamentUseBasePrizes);
  aWriter.WriteInteger(Integer(FTournamentBasePaymentType));
  aWriter.WriteCurrency(FTournamentBaseFirstPlace);
  aWriter.WriteCurrency(FTournamentBaseSecondPlace);
  aWriter.WriteCurrency(FTournamentBaseThirdPlace);
  //
  aWriter.WriteBoolean(FTournamentUseBonusPrizes);
  aWriter.WriteInteger(Integer(FTournamentBonusPaymentType));
  aWriter.WriteCurrency(FTournamentBonusFirstPlace);
  aWriter.WriteCurrency(FTournamentBonusSecondPlace);
  aWriter.WriteCurrency(FTournamentBonusThirdPlace);

  aWriter.WriteString(FTournamentSeqID);
end;

function TpoGenericTournamentCroupier.TableHasPreliminaryRound: Boolean;
begin
  Result:= True;
end;

procedure TpoGenericTournamentCroupier.TakeAllInsOffTournament();
var
  I: Integer;
  aGamer: TpoGamer;
begin
  for I:= 0 to FTable.Chairs.Count-1 do begin
    aGamer := FTable.Chairs[I].Gamer;
    if (aGamer = nil) then Continue;
    if (aGamer.FinishedTournament) then Continue;

    if (aGamer.State = GS_ALL_IN) or aGamer.KickOffFromTournament then begin
      aGamer.State := GS_IDLE;
      aGamer.FinishedTournament:= True;
      aGamer.FAllInRejectionHandID:= PlayedHandsInTournament;
    end;//if
  end;
end;//


function TpoSingleTableTournamentCroupier.HandleTournamentBreak(
  sReason: String): boolean;
begin
  Result:= False;
end;

function TpoSingleTableTournamentCroupier.HandleTournamentEnd(
  sReason: String): boolean;
begin
  Result:= False;
end;

function TpoSingleTableTournamentCroupier.HandleTournamentFree(
  sReason: String): boolean;
begin
  Result:= False;
end;

function TpoSingleTableTournamentCroupier.HandleTournamentInit(
  aParticipants: Variant; sReason: String): boolean;
begin
  Result:= False;
end;

function TpoSingleTableTournamentCroupier.HandleTournamentPlay(
  nHandID: Integer; aParticipants: Variant; sReason: String): boolean;
begin
  Result:= False;
end;

function TpoSingleTableTournamentCroupier.HandleTournamentResume(
  nHandID: Integer; sReason: String;
  nPlrsCnt: Integer;
  vLostPlayers: Array of Variant
  ): boolean;
begin
  Result:= False;
end;

function TpoSingleTableTournamentCroupier.HandleTournamentStandUp(
  sReason: String; nPlrsCnt: Integer; bSetAsWatcher: Boolean;
  vLostPlayers: Variant
): boolean;
begin
  Result := False;
end;

function TpoSingleTableTournamentCroupier.HandleTournamentKickOff(
  sReason: String; nPlrsCnt: Integer;
  vLostPlayers: Variant
): boolean;
var
  I: Integer;
  g: TpoGamer;
  sMessage: string;
  arrLost: array of Variant;
begin
  SetLength(arrLost, 0);
  arrLost := vLostPlayers;
  if (Length(arrLost) > 0) then begin
    for I:= 0 to High(arrLost) do begin
      g:= FTable.Gamers.GamerByUserID(arrLost[I]);
      if g = nil then EscalateFailure(
        EpoException,
        'KickOff gamer with ID: '+IntToStr(arrLost[I])+' not found amoung table participants.',
        '{59AEAE0F-67F2-4A65-9AAD-3684CA8DA9F0}'
      );//if

      if (Hand.State in [HST_IDLE, HST_FINISHED]) or g.IsWatcher then begin
        Self.HandleGamerLeaveTable(g);
        Continue;
      end;

      sMessage := g.FUserName + ' will be kicked off by administrator after finish hand.';
      if Assigned(OnChatMessage) then OnChatMessage(sMessage);
      g.KickOffFromTournament := True;
    end;//for
  end;//for

  Result := True;
end;

function TpoSingleTableTournamentCroupier.HandleTournamentSitDown(
  sReason: String; nPlrsCnt: Integer; 
  vNewPlayers: Variant
): boolean;
begin
  Result := False;
end;

procedure TpoSingleTableTournamentCroupier.ClearGamersTournamentFlags;
var
  I: Integer;
  aGamer: TpoGamer;
begin
  for I:= 0 to Gamers.Count - 1 do begin
    aGamer := Gamers[I];
    aGamer.FinishedTournament := False;
    aGamer.FTournamentPrizePercentage := 0;
    aGamer.FTournamentPrizeBonus := 0;
  end;
end;

function TpoSingleTableTournamentCroupier.FinishHand: Boolean;
var
  nStartingTimeout: Integer;
begin
  Result:= True;

  ClearAllGamersShowDownPassedAndFinishTournament;
  // correct bots
  CheckForBotsContinue;

//clear accounts
  Hand.Finish;

//define winner
  if Assigned(OnHandFinish) then OnHandFinish(GetHandReconcileContext());

  Inc(FPlayedHandsInTournament);

  CorrectBettingLevelsIfProper();

//hide chairs for
  Chairs.HideAllInChairs(0, 'Gamer %s finished tournament.');
  TakeAllInsOffTournament();

//check for tournament finish condition
  if GetActiveTournamentParticipantsCount() <= 1 then begin
    FinishTournament();
  //initiate next hand
    Hand.State := HST_IDLE;
  end else begin
    if Assigned(OnHandStarting) then begin
      nStartingTimeout:= 5;
      OnHandStarting(Self, nStartingTimeout);
    end;//if
    Hand.State := HST_STARTING;
  end;//if
end;


var
  ArabicToRomeDigits: Array [0..10] of String = (
    '0', 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X'
  );

procedure TpoSingleTableTournamentCroupier.CorrectBettingLevelsIfProper;

  function IsBetween(nHandCount, nloBound, nHiBound: Integer): Boolean;
  begin
    Result:= (nHandCount > nloBound) AND (nHandCount <= nHiBound);
  end;//

var
  bLevelApp: Boolean;

begin
  bLevelApp:= False;

  if FPlayedHandsInTournament = (HANDS_PER_TOURNAMENT_LAYER) then begin
    if PokerClass = PTC_OPEN_CARDS_POKER then FTable.SmallBetValue:= FTable.SmallBetValue+1000
    else FTable.SmallBetValue:= FTable.SmallBetValue+1000;
    bLevelApp:= True;
  end else
  if FPlayedHandsInTournament = (2*HANDS_PER_TOURNAMENT_LAYER) then begin
    if PokerClass = PTC_OPEN_CARDS_POKER then FTable.SmallBetValue:= FTable.SmallBetValue*2
    else FTable.SmallBetValue:= FTable.SmallBetValue+1000;
    bLevelApp:= True;
  end
  else
  if FPlayedHandsInTournament = (3*HANDS_PER_TOURNAMENT_LAYER) then begin
    if PokerClass = PTC_OPEN_CARDS_POKER then FTable.SmallBetValue:= FTable.SmallBetValue*2
    else FTable.SmallBetValue:= FTable.SmallBetValue+2000;
    bLevelApp:= True;
  end  else
  if FPlayedHandsInTournament = (4*HANDS_PER_TOURNAMENT_LAYER) then begin
    if PokerClass = PTC_OPEN_CARDS_POKER then FTable.SmallBetValue:= FTable.SmallBetValue*2
    else FTable.SmallBetValue:= FTable.SmallBetValue*2;
    bLevelApp:= True;
  end else
  if FPlayedHandsInTournament = (5*HANDS_PER_TOURNAMENT_LAYER) then begin
    if PokerClass = PTC_OPEN_CARDS_POKER then FTable.SmallBetValue:= FTable.SmallBetValue*2
    else FTable.SmallBetValue:= FTable.SmallBetValue*2;
    bLevelApp:= True;
  end else
  if FPlayedHandsInTournament = (6*HANDS_PER_TOURNAMENT_LAYER) then begin
    if PokerClass = PTC_OPEN_CARDS_POKER then FTable.SmallBetValue:= FTable.SmallBetValue + (FTable.SmallBetValue div 2)
    else FTable.SmallBetValue:= FTable.SmallBetValue*2;
    bLevelApp:= True;
  end else
  if FPlayedHandsInTournament = (7*HANDS_PER_TOURNAMENT_LAYER) then begin
    if PokerClass = PTC_OPEN_CARDS_POKER then FTable.SmallBetValue:= FTable.SmallBetValue+Trunc((FTable.SmallBetValue/1.5))
    else FTable.SmallBetValue:= FTable.SmallBetValue*2;
    bLevelApp:= True;
  end;
  FTable.BigBetValue:= FTable.SmallBetValue*2;

  if bLevelApp then begin
    SendMessage(
      'Next game we go to level '+ArabicToRomeDigits[GetTournamentLevel()]+' and the limits increase'
    );
  end;//if
end;


function TpoSingleTableTournamentCroupier.Load(aReader: TReader): Boolean;
begin
  Result:= inherited Load(aReader);
end;

function TpoSingleTableTournamentCroupier.Store(aWriter: TWriter): Boolean;
begin
  Result:= inherited Store(aWriter);
end;

procedure TpoSingleTableTournamentCroupier.FinishTournament;
begin
  FTournamentStatus:= TST_FINISHED;
  DefineAndReconcileTournamentWinners();

  //update state
  if Assigned(OnTournamentFinish) then begin
    OnTournamentFinish(Self);
  end;//

  //clean up participants
  Chairs.KickOffAllGamers;

  //update state
  ClearGamersTournamentFlags;


  //return tournament status to initial state
  FTournamentStatus:= TST_IDLE;

  //update state
  if Assigned(OnTournamentFinishForBots) then begin
    OnTournamentFinishForBots(Self);
  end;//

  SendMessage('Tournament is finished.');
end;

procedure TpoSingleTableTournamentCroupier.StartTournament;
begin
  DealCardsForTournamentDealerRound();
  FTournamentStatus:= TST_RUNNING;
  FPlayedHandsInTournament:= 0;

  //update state
  if Assigned(OnTournamentStart) then OnTournamentStart(Self);
end;

function TpoSingleTableTournamentCroupier.GetActiveTournamentParticipantsCount: Integer;
var
  I: Integer;
begin
  Result:= 0;
  for I:= 0 to Chairs.Count-1 do begin
    if Chairs[I].Gamer = nil then Continue;
    if (Chairs[I].Gamer.FinishedTournament) then Continue;
    if Chairs[I].Gamer.State = GS_ALL_IN then Continue;
    Inc(Result);
  end;//for
end;

function TpoSingleTableTournamentCroupier.StartHand(
  nHandID: Integer): Boolean;
var
  sMsg: String;
begin
  Result:= False;
  if Hand.State <> HST_STARTING then Exit;

  if (FPlayedHandsInTournament mod HANDS_PER_TOURNAMENT_LAYER) = (HANDS_PER_TOURNAMENT_LAYER-1) then begin
    sMsg:= 'Next game we go to Level '+ArabicToRomeDigits[GetTournamentLevel()+1];
    if (FPlayedHandsInTournament div HANDS_PER_TOURNAMENT_LAYER) < MAX_TOURNAMENT_RAISE_LEVEL then begin
      sMsg:= sMsg+' and the limits will increase.';
    end;//if
    SendMessage(sMsg);
  end;//if

  if FTournamentStatus IN [TST_IDLE, TST_STARTING, TST_FINISHED] then StartTournament;
  Result:= inherited StartHand(nHandID);
end;


function TpoSingleTableTournamentCroupier.HandleGamerSitDown(
  aGamer: TpoGamer; nPosition: Integer; nAmount: Integer): Boolean;
begin
  aGamer.FinishedTournament   := False;
  aGamer.KickOffFromTournament := False;

  if FTable.Chairs[nPosition].State <> CS_EMPTY then begin
    CommonDataModule.Log(ClassName, 'HandleGamerSitDown', 'Chair at pos '+IntToStr(nPosition)+' is not empty.',
      ltError);
    EscalateFailure(
      EpoSessionException,  aGamer.SessionID,
      'Chair at pos '+IntToStr(nPosition)+' is not empty.',
      '{C9DAABF7-0FCB-4AE9-ABBA-1E0926FE5517}'
    );
  end;//if

  aGamer.SitDownAt(FTable.Chairs[nPosition], nAmount);
  aGamer.FFinishedHands:= 0;


  if Assigned(OnChairStateChange) then OnChairStateChange(aGamer, nPosition);

//check start tournament conditions
  if GetActiveTournamentParticipantsCount() = Chairs.Count then begin
    Hand.State:= HST_STARTING;
    if Assigned(OnHandstarting) then OnHandstarting(Self, GS_START_ST_TOURNAMENT_TIMEOUT);
    FTournamentStatus := TST_STARTING;
  end;//if
  Result:= True
end;

function TpoSingleTableTournamentCroupier.HandleGamerLeaveTable(
  aGamer: TpoGamer): TpoGamer;
begin
  if not ((aGamer.FinishedTournament or aGamer.FSheduledToLeaveTable) and
    (Hand.State in [HST_RUNNING, HST_STARTING])) then
    Result := inherited HandleGamerLeaveTable(aGamer)
  else
  begin
    Result := aGamer;
    Result.FSheduledToLeaveTable := True;
  end;
end;

function TpoSingleTableTournamentCroupier.GetHandInsideLevel: Integer;
begin
  Result:= Trunc(FPlayedHandsInTournament - (GetTournamentLevel-1)*10);

  CommonDataModule.Log(ClassName, 'GetHandInsideLevel',
    'Played hands: '+IntToStr(FPlayedHandsInTournament)+' Tournament level: '+
    IntToStr(GetTournamentLevel)+' Hand inside tournament:  '+IntToStr(Result)
    , ltCall);
end;

function TpoSingleTableTournamentCroupier.GetTournamentLevel: Integer;
begin
  Result:= Trunc(FPlayedHandsInTournament / 10)+1;
  if Result > 8 then Result:= 8;
end;


function TpoSingleTableTournamentCroupier.DefineAndReconcileTournamentWinners: Boolean;
var
  I: Integer;
  wl: TList;

  function CompareWinnerCandidates(aChair1, aChair2: TpoChair): Integer;
  begin
    if aChair1.Gamer.FinishedTournamentTime < aChair2.Gamer.FinishedTournamentTime then begin
      Result := -1;
      Exit;
    end;
    if aChair1.Gamer.FinishedTournamentTime = aChair2.Gamer.FinishedTournamentTime then begin
      if          (aChair1.Gamer.BalanceBeforeLastHand < aChair2.Gamer.BalanceBeforeLastHand) then begin
        Result := -1;
      end else if (aChair1.Gamer.BalanceBeforeLastHand = aChair2.Gamer.BalanceBeforeLastHand) then begin
        if aChair1.Gamer.Account.Balance < aChair2.Gamer.Account.Balance then begin
          Result := -1;
        end else if aChair1.Gamer.Account.Balance = aChair2.Gamer.Account.Balance then begin
          Result := 0;
        end else begin
          Result := 1;
        end;
      end else begin
        Result := 1;
      end;

      Exit;
    end;
    Result := 1;
  end;//

  function RegisterWinnerChair(aChair: TpoChair): Integer;
  var
    I: Integer;
    ch: TpoChair;
  begin
    I:= 0;
    while I < wl.Count do begin
      ch:= TpoChair(wl[I]);
      if CompareWinnerCandidates(ch, aChair) < 0 then begin
        wl.Insert(I, aChair);
        Result:= I;
        Exit;
      end;//
      Inc(I);
    end;//while
    wl.Add(aChair);
    Result:= wl.Count-1;
  end;//RegisterWinnerChair

  function FirstPlaceCandidatesCount(): Integer;
  begin
    Result:= wl.Count;
  end;//

  function SecondPlaceCandidatesCount(): Integer;
  var
    I: Integer;
    spc: TpoChair;
  begin
    Result:= 1;
    spc:= TpoChair(wl[0]);
    I:= 1;
    while (CompareWinnerCandidates(spc, TpoChair(wl[I])) = 0) AND (I < wl.Count) do begin
      Inc(I);
      Inc(Result);
    end;//
  end;//

  function ThirdPlaceCandidatesCount(): Integer;
  var
    I: Integer;
    spc: TpoChair;
  begin
    Result:= 1;
    spc:= TpoChair(wl[1]);
    I:= 2;
    while (CompareWinnerCandidates(spc, TpoChair(wl[I])) = 0) AND (I < wl.Count) do begin
      Inc(I);
      Inc(Result);
    end;//
  end;//

  function WinnerCandidatesAreEqual(pCandidate1, pCandidate2: Pointer): Boolean;
  begin
    Result:= CompareWinnerCandidates(TpoChair(pCandidate1), TpoChair(pCandidate2)) = 0;
  end;//

var
  ch: TpoChair;
  n1stPlaceCandidates, n2ndPlaceCandidates, n3dPlaceCandidates: Integer;
  nPrizePercantage, nBonusPrize: Currency;
  nTotalPrize: Integer;
  nPlaceMarker: Integer;
  aGamer: TpoGamer;

  function CalcGamerPrize(nPercentage: Currency; nTotalPrize: Integer; IsPercent: Boolean): Currency;
  begin
    if IsPercent then
      Result:= NormalizeAmount(Trunc(nTotalPrize*nPercentage/100.0))
    else
      Result:= nPercentage;
  end;//CalcGamerPrize

begin
  //Init
  nTotalPrize:= FTable.Chairs.Count*(TournamentBuyIn);//-TournamentFee);
  nPlaceMarker:= 0;

  wl:= TList.Create;
  n1stPlaceCandidates:= 0;
  n2ndPlaceCandidates:= 0;
  n3dPlaceCandidates := 0;

  //reorder candidates
  for I:= 0 to Chairs.Count-1 do begin
    //init
    aGamer := Chairs[I].Gamer;
    if aGamer = nil then Continue;
    aGamer.FTournamentPlace:= 0;
    aGamer.FTournamentPrizePercentage:= 0;
    aGamer.FTournamentPrizeBonus:= 0;
    // redifine not finished tournament time
    if aGamer.FFinishedTournamentTime = 0 then begin
      aGamer.FFinishedTournamentTime := IncSecond(Now, 10);
    end;

    RegisterWinnerChair(Chairs[I]);
  end;//for

  //allocate places
  I:= 0;
  while I < wl.Count do begin
    if (n1stPlaceCandidates = 0) then begin
      Inc(n1stPlaceCandidates);
      TpoChair(wl[I]).Gamer.FTournamentPlace:= 1;
      nPlaceMarker:= 1;
    end
    else if WinnerCandidatesAreEqual(wl[I-1], wl[I]) then begin
      TpoChair(wl[I]).Gamer.FTournamentPlace:= TpoChair(wl[I-1]).Gamer.FTournamentPlace;
      case TpoChair(wl[I]).Gamer.FTournamentPlace of
        1: Inc(n1stPlaceCandidates);
        2: Inc(n2ndPlaceCandidates);
        3: Inc(n3dPlaceCandidates);
      end;//case
    end
    else begin
      Inc(nPlaceMarker);
      TpoChair(wl[I]).Gamer.FTournamentPlace:= nPlaceMarker;
      case TpoChair(wl[I]).Gamer.FTournamentPlace of
        1: Inc(n1stPlaceCandidates);
        2: Inc(n2ndPlaceCandidates);
        3: Inc(n3dPlaceCandidates);
      end;//case
    end;//if
    Inc(I);
  end;//while

  //allocate prizes
  for I:= 0 to wl.Count-1 do begin
    ch:= TpoChair(wl[I]);
    case ch.Gamer.FTournamentPlace of
      1:
      begin
        if (wl.Count = 2) AND (n1stPlaceCandidates < wl.Count) then begin
          //special case: only two plaers in tournament - 1st takes whole bank
          { Base prize }
          if FTournamentUseBasePrizes then begin
            if FTournamentBasePaymentType = TPT_PERCENT then begin
              nPrizePercantage:= 100.0;//full prize
            end else begin
              nPrizePercantage:=
                FTournamentBaseFirstPlace +
                FTournamentBaseSecondPlace +
                FTournamentBaseThirdPlace; //Sum All Fixed value
            end;

            SendMessage(ch.Gamer.UserName+ ' finished in 1st place and won ' + FCurrencySymbol +
              FloatToStr(CalcGamerPrize(nPrizePercantage, nTotalPrize, (FTournamentBasePaymentType = TPT_PERCENT)))
            );
          end else begin
            nPrizePercantage:= 0;
            if not FTournamentUseBonusPrizes then
              SendMessage(ch.Gamer.UserName+ ' finished in 1st place.');
          end;
          ch.Gamer.FTournamentPrizePercentage:= nPrizePercantage;

          { Bonus prize }
          if FTournamentUseBonusPrizes then begin
            if FTournamentBonusPaymentType = TPT_PERCENT then begin
              nBonusPrize:= 100.0;//full prize
            end else begin
              nBonusPrize:=
                FTournamentBonusFirstPlace +
                FTournamentBonusSecondPlace +
                FTournamentBonusThirdPlace; //Sum All Fixed value
            end;

            SendMessage(ch.Gamer.UserName+ ' finished in 1st place and take bonus money '+
              FloatToStr(CalcGamerPrize(nBonusPrize, nTotalPrize, (FTournamentBonusPaymentType = TPT_PERCENT)))
            );
          end else begin
            nBonusPrize := 0;
          end;
          ch.Gamer.FTournamentPrizeBonus:= nBonusPrize;

          TpoChair(wl[I+1]).Gamer.FTournamentPlace:= 0;
          TpoChair(wl[I+1]).Gamer.FTournamentPrizePercentage:= 0;
          SendMessage(TpoChair(wl[I+1]).Gamer.UserName+ ' finished in 2nd place');
          Break;
        end else begin
          { Base prize }
          if FTournamentUseBasePrizes then begin
            nPrizePercantage:= (TournamentBaseFirstPlace / n1stPlaceCandidates);
            if n1stPlaceCandidates >= 2 then begin
              nPrizePercantage:= nPrizePercantage+(TournamentBaseSecondPlace / n1stPlaceCandidates);
            end;//if
            if n1stPlaceCandidates >= 3 then begin
              nPrizePercantage:= nPrizePercantage+(TournamentBaseThirdPlace / n1stPlaceCandidates);
            end;//if
            ch.Gamer.FTournamentPrizePercentage:= nPrizePercantage;

            SendMessage('gamer '+ch.Gamer.UserName+ ' finished in 1st place and won ' + FCurrencySymbol +
              FloatToStr(CalcGamerPrize(ch.Gamer.FTournamentPrizePercentage, nTotalPrize, (FTournamentBasePaymentType = TPT_PERCENT)))
            );
          end else begin
            nPrizePercantage := 0;
            ch.Gamer.FTournamentPrizePercentage:= nPrizePercantage;
            if not FTournamentUseBonusPrizes then
              SendMessage(ch.Gamer.UserName+ ' finished in 1st place.');
          end;

          { Bonus prize }
          if FTournamentUseBonusPrizes then begin
            nBonusPrize:= (TournamentBonusFirstPlace / n1stPlaceCandidates);
            if n1stPlaceCandidates >= 2 then begin
              nBonusPrize:= nBonusPrize+(TournamentBonusSecondPlace / n1stPlaceCandidates);
            end;//if
            if n1stPlaceCandidates >= 3 then begin
              nBonusPrize:= nBonusPrize+(TournamentBonusThirdPlace / n1stPlaceCandidates);
            end;//if
            ch.Gamer.FTournamentPrizeBonus:= nBonusPrize;

            SendMessage('gamer '+ch.Gamer.UserName+ ' finished in 1st place and take bonus money '+
              FloatToStr(CalcGamerPrize(ch.Gamer.FTournamentPrizeBonus, nTotalPrize, (FTournamentBonusPaymentType = TPT_PERCENT)))
            );
          end else begin
            nBonusPrize := 0;
            ch.Gamer.FTournamentPrizeBonus:= nBonusPrize;
          end;
        end;//if
      end;//

      2:
      begin
        { Base prize }
        if FTournamentUseBasePrizes then begin
          nPrizePercantage:= (TournamentBaseSecondPlace / n2ndPlaceCandidates);
          if n2ndPlaceCandidates >= 2 then begin
            nPrizePercantage:= nPrizePercantage+(TournamentBaseThirdPlace / n2ndPlaceCandidates);
          end;//if
          ch.Gamer.FTournamentPrizePercentage:= nPrizePercantage;
          SendMessage('gamer '+ch.Gamer.UserName+ ' finished in 2nd place and won ' + FCurrencySymbol +
            FloatToStr(CalcGamerPrize(ch.Gamer.FTournamentPrizePercentage, nTotalPrize, (FTournamentBasePaymentType = TPT_PERCENT)))
          );
        end else begin
          nPrizePercantage:= 0;
          ch.Gamer.FTournamentPrizePercentage:= nPrizePercantage;
          if not FTournamentUseBonusPrizes then
            SendMessage('gamer '+ch.Gamer.UserName+ ' finished in 2nd place.');
        end;

        { Bonus prize }
        if FTournamentUseBonusPrizes then begin
          nBonusPrize:= (TournamentBonusSecondPlace / n2ndPlaceCandidates);
          if n2ndPlaceCandidates >= 2 then begin
            nBonusPrize:= nBonusPrize+(TournamentBonusThirdPlace / n2ndPlaceCandidates);
          end;//if
          ch.Gamer.FTournamentPrizeBonus:= nBonusPrize;
          SendMessage('gamer '+ch.Gamer.UserName+ ' finished in 2nd place and take bonus money '+
            FloatToStr(CalcGamerPrize(ch.Gamer.FTournamentPrizeBonus, nTotalPrize, (FTournamentBonusPaymentType = TPT_PERCENT)))
          );
        end else begin
          nBonusPrize:= 0;
          ch.Gamer.FTournamentPrizeBonus:= nBonusPrize;
        end;
      end;//

      3:
      begin
        { Base prize }
        if FTournamentUseBasePrizes then begin
          nPrizePercantage:= (TournamentBaseThirdPlace / n3dPlaceCandidates);
          ch.Gamer.FTournamentPrizePercentage:= nPrizePercantage;
          SendMessage('gamer '+ch.Gamer.UserName+ ' finished in 3d place and won ' + FCurrencySymbol +
            FloatToStr(CalcGamerPrize(ch.Gamer.FTournamentPrizePercentage, nTotalPrize, (FTournamentBasePaymentType = TPT_PERCENT)))
          );
        end else begin
          nPrizePercantage:= 0;
          ch.Gamer.FTournamentPrizePercentage:= nPrizePercantage;
          if not FTournamentUseBonusPrizes then
            SendMessage('gamer '+ch.Gamer.UserName+ ' finished in 3d place.');
        end;

        { Bonus prize }
        if FTournamentUseBonusPrizes then begin
          nBonusPrize:= (TournamentBonusThirdPlace / n3dPlaceCandidates);
          ch.Gamer.FTournamentPrizeBonus:= nBonusPrize;
          SendMessage('gamer '+ch.Gamer.UserName+ ' finished in 3d place and take bonus money '+
            FloatToStr(CalcGamerPrize(ch.Gamer.FTournamentPrizeBonus, nTotalPrize, (FTournamentBonusPaymentType = TPT_PERCENT)))
          );
        end else begin
          nBonusPrize:= 0;
          ch.Gamer.FTournamentPrizeBonus:= nBonusPrize;
        end;
      end;//
    else
      SendMessage(ch.Gamer.UserName+ ' finished in '+PlaceToStr(ch.Gamer.FTournamentPlace)+' place');
    end;//case
  end;//for

  //done
  wl.Free;
  Result:= True;
end;//TpoSingleTableTournamentCroupier.DefineAndReconcileTournamentWinners


function TpoSingleTableCroupier.TableHasPreliminaryRound: Boolean;
begin
  if PokerClass = PTC_CLOSED_CARDS_POKER then begin
    Result:= TableHasAnte();
  end else Result:= True;
end;

procedure TpoSingleTableCroupier.CheckIfHandIsRunning(sAnchor: String);
begin
  if Hand.State <> HST_RUNNING then begin
    EscalateFailure(
      EpoUnexpectedActionException, 'Hand is not running',  sAnchor
    );
  end;//
end;

function TpoSingleTableCroupier.SitOutCanTakeStepRight: Boolean;
begin
  Result:= False;
end;

function TpoSingleTableCroupier.StepRightChairsCount: Integer;
var
  I: Integer;
begin
  Result:= 0;
  for I:= 0 to Chairs.Count-1 do begin
    if ChairCanTakeStepRight(Chairs[I]) then Inc(Result);
  end;//for
end;

function TpoSingleTableCroupier.AllChairsShowDownPassed: Boolean;
var
  I: Integer;
begin
  Result:= True;
  for I:= 0 to Chairs.Count-1 do begin
    if Chairs[I].Gamer = nil then Continue;
    if Chairs[I].Gamer.State = GS_SITOUT then Continue;
    if Chairs[I].Gamer.PassCurrentHand then Continue;
    if Chairs[I].Gamer.FinishedTournament then Continue;
    Result := Result and Chairs[I].Gamer.ShowDownPassed;
    if not Result then Exit;
  end;//for
end;

procedure TpoSingleTableCroupier.ClearAllGamersShowDownPassedAndFinishTournament;
var
  I: Integer;
  g: TpoGamer;
begin
  for I:= 0 to Gamers.Count - 1 do begin
    g := Gamers[I];
    if g = nil then Continue;
    g.ShowDownPassed := False;
    if (FTournamentType = TT_NOT_TOURNAMENT) then begin
      g.FinishedTournament := False;
    end;

    g.Account.AssignBalance(g.Account.Balance);
  end;//for
end;

procedure TpoSingleTableCroupier.ClearBigBlindIssues;
var
  I: Integer;
  ch: TpoChair;
begin
  for I:= 0 to Chairs.Count-1 do begin
    ch := Chairs[I];
    if ch.Gamer = nil then Continue;
    ch.Gamer.MustSetBigBlind:= False;
    ch.Gamer.MustSetPost:= False;
    ch.Gamer.MustSetPostDead:= False;
  end;//for
end;

function TpoSingleTableCroupier.ReadyToPlayChairsCount: Integer;
var
  I: Integer;
begin
  Result:= 0;
  for I:= 0 to Chairs.Count-1 do begin
    if ChairIsReadyToPlay(Chairs[I]) then Inc(Result);
  end;//for
end;

function TpoSingleTableCroupier.ChairIsReadyToPlay(
  aChair: TpoChair): Boolean;
begin
  Result:= False;
  if aChair.Gamer = nil then Exit;
  if aChair.Gamer.PassCurrentHand then Exit;
  if aChair.Gamer.FinishedTournament then Exit;
  if aChair.Gamer.State = GS_ALL_IN then Exit;
  if (aChair.Gamer.IsReadyForHand) OR ((aChair.IsSitOut) AND (SitOutCanTakeStepRight())) then begin
    Result:= True;
  end;//if
end;

function TpoSingleTableCroupier.WinnerCandidatesCount: Integer;
var
  I: Integer;
begin
  Result:= 0;
  for I:= 0 to Chairs.Count-1 do begin
    if ChairIsWinnerCandidate(Chairs[I]) then Inc(Result);
  end;//for
end;

function TpoSingleTableCroupier.DefineFirstWinnerCandidate: TpoGamer;
var
  I: Integer;
begin
  Result:= nil;
  for I:= 0 to Chairs.Count-1 do begin
    if ChairIsWinnerCandidate(Chairs[I]) then begin
      Result:= Chairs[I].Gamer;
      Exit;
    end;//ig
  end;//for
end;

function TpoSingleTableCroupier.ChairIsWinnerCandidate(
  aChair: TpoChair): Boolean;
begin
  Result:= False;
  if aChair = nil then Exit;
  if aChair.Gamer = nil then Exit;
  if aChair.Gamer.PassCurrentHand then Exit;
  if aChair.Gamer.FinishedTournament then Exit;
  if aChair.Gamer.State = GS_FOLD then Exit;
  Result:=
    (aChair.Gamer.State IN [GS_PLAYING, GS_ALL_IN]) OR
    ((aChair.Gamer.State = GS_SITOUT) AND (SitOutCanTakeStepRight()));
end;

function TpoSingleTableCroupier.SelectServerGamerAction(
  aGamer: TpoGamer): TpoGamerAction;
var
  va: TpoGamerActions;
begin
  Result:= GA_FOLD;
  if aGamer = nil then begin
    EscalateFailure('Gamer is not defined', '{C6968AE1-B5B1-47F1-83CC-6CB33093B706}');
  end;//

  va:= GetValidGamerActions(aGamer);
  if GA_DONT_SHOW IN va then Result:= GA_DONT_SHOW
  else
  if GA_MUCK IN va then Result:= GA_MUCK
  else
  if GA_SHOW_CARDS_SHUFFLED IN va then Result:= GA_SHOW_CARDS_SHUFFLED
  else
  if GA_SHOW_CARDS IN va then Result:= GA_SHOW_CARDS
  else
  if GA_SIT_OUT IN va then Result:= GA_SIT_OUT
  else
  if GA_POST_SB IN va then Result:= GA_SIT_OUT
  else
  if GA_POST_BB IN va then Result:= GA_SIT_OUT
  else
  if GA_ANTE IN va then Result:= GA_SIT_OUT
  else
  if GA_BRING_IN IN va then Result:= GA_FOLD
  else
  if GA_BET IN va then Result:= GA_FOLD
  else
  if GA_FOLD IN va then begin
    if aGamer.Disconnected AND Assigned(OnCheckGamerAllins) then begin
      if OnCheckGamerAllins(aGamer) then begin
        if aGamer.HasBets then begin
          SendMessage(
            aGamer.UserName+' has been disconnected and was not able to act in time - is being treated as all-in');
          Result:= GA_ALL_IN
        end else begin
          SendMessage(aGamer.UserName+' could not respond in time');
          Result:= GA_FOLD;
        end;//
      end else begin
        SendMessage(aGamer.UserName+' has exeeded all-ins limit on disconnect');
        Result:= GA_FOLD;
      end;//if
    end else begin
      SendMessage(aGamer.UserName+' could not respond in time');
      Result:= GA_FOLD
    end;//
  end else
  if GA_RAISE IN va then Result:= GA_FOLD
  else
  if GA_CALL IN va then Result:= GA_FOLD
  ;
end;

function TpoSingleTableCroupier.HandleGamerProcInit(
  aGamer: TpoGamer): TpoGamer;
begin
  Result:= aGamer;
end;

function TpoSingleTableCroupier.HandleGamerProcState(
  aGamer: TpoGamer): TpoGamer;
begin
  Result:= aGamer;
end;

function TpoSingleTableCroupier.HandleGamerActionExpired(
  aGamer: TpoGamer): Boolean;
var
  nAction: TpoGamerAction;
begin
  Result:= False;
  nAction:= SelectServerGamerAction(aGamer);

  InvokeGamerAction(aGamer, nAction, []);

  if (nAction = GA_FOLD) AND (aGamer <> nil) then begin
    if aGamer.IsBot then
      CommonDataModule.Log(ClassName, 'HandleGamerActionExpired', 'Timerevent for bot was executed', ltError)
    else
      Result:= HandleGamerSitOut(aGamer) <> nil;
  end;//
end;

function TpoSingleTableCroupier.GetNextHandStartingTimeout: Integer;
begin
  Result:= GT_HAND_START_FROM_IDLE;
  if Hand.State = HST_IDLE then Result:= GT_HAND_START_FROM_IDLE
  else
  if Hand.State = HST_FINISHED then Result:= GT_HAND_START_AFTER_COMPLETION;
  if Chairs.GetFreeChairsCount() = 0 then Result:= GT_HAND_START_FOR_FULL_TABLE;
end;

function TpoSingleTableCroupier.GetGamerActionTimeout(
  aGamer: TpoGamer): Integer;
begin
  Result:= GT_GAMER_ACTION_TIMEOUT;
end;

function TpoSingleTableCroupier.MandatoryStakesSkipperMustBeBounced: Boolean;
begin
  Result:= True;
end;

procedure TpoSingleTableCroupier.ChargeRakes;
var
  I: Integer;
  nRakesCharged: Integer;
  nIncomingReminder: Integer;
  nSidePotRakeAmount: Integer;
  bLimitIsReached: Boolean;
begin
  if not (FTable.CurrencyID in [2]) then Exit;
  if Hand.Pot.RakesToCharge >= GetRakesLimit() then begin
    Exit;
  end;//if
  if Hand.NoFlopNoDropRuleActive then Exit;
  nRakesCharged:= 0;
  nIncomingReminder:= 0;
  for I:= 0 to Hand.Pot.SidePots.Count-1 do begin
    nIncomingReminder:= CalcRakesRateForSitePot(
      nRakesCharged, Hand.Pot.SidePots[I].Balance, nIncomingReminder, nSidePotRakeAmount, bLimitIsReached
    );
    nRakesCharged:= nRakesCharged+nSidePotRakeAmount;
    Hand.Pot.SidePots[I].RakesToCharge:= nSidePotRakeAmount;
    if bLimitIsReached then Break;
  end;//for
end;//TpoSingleTableCroupier.ChargeRakes


function TpoSingleTableCroupier.HandleGamerAutoAction(aGamer: TpoGamer;
  nAutoAction: TpoGamerAutoAction; nStake: Integer;
  bIsON: Boolean): Boolean;
begin
  Result:= True;

  if nAutoAction IN TURN_LEVEL_AUTO_ACTIONS then begin
    if aGamer = Hand.ActiveGamer then Exit; //Kill autoaction for active player
    aGamer.AutoActions:= aGamer.AutoActions-TURN_LEVEL_AUTO_ACTIONS;
  end;//if

  if (nAutoAction = GAA_AUTO_WAIT_BB) then begin
    if bIsON then begin
    end else begin
      aGamer.AutoActions:= aGamer.AutoActions-[nAutoAction];
      aGamer.WaitForBigBlind:= False;
      HandleGamerBack(aGamer);
    end;//if
  end else begin
    if bIsON then aGamer.AutoActions:= aGamer.AutoActions+[nAutoAction]
    else aGamer.AutoActions:= aGamer.AutoActions-[nAutoAction];
  end;//if

  aGamer.AutoActionStake:= nStake;
end;


function TpoSingleTableCroupier.SelectServerGamerAutoAction(
  aGamer: TpoGamer): TpoGamerAction;
var
  va: TpoGamerActions;
begin
  Result:= GA_NONE;
  if aGamer.AutoActions = [] then Exit;

  if (GAA_AUTO_RAISE IN aGamer.AutoActions) AND
    (aGamer.AutoActionStake <> GetRaiseStakeValue(aGamer)) AND
    (aGamer.AutoActionStake <> PL_UNDEFINED_STAKE_AMOUNT)
  then Exit;

  va:= GetValidGamerActions(aGamer);

  if GAA_AUTO_LEAVE_TABLE IN aGamer.AutoActions then Result:= GA_LEAVE_TABLE
  else
  if (GA_POST_SB IN va) AND (GAA_POST_BLINDS IN aGamer.AutoActions) then Result:= GA_POST_SB
  else
  if (GA_POST_BB IN va) AND (GAA_POST_BLINDS IN aGamer.AutoActions) then Result:= GA_POST_BB
  else
  if (GA_ANTE IN va) AND (GAA_POST_ANTE IN aGamer.AutoActions) then Result:= GA_ANTE
  else
  if (GAA_AUTO_FOLD IN aGamer.AutoActions) AND (GA_FOLD IN va) then Result := GA_FOLD
  else
  if (GAA_AUTO_CHECK IN aGamer.AutoActions) AND (GA_CHECK IN va) then Result := GA_CHECK
  else
  if (GAA_CHECK_OR_FOLD IN aGamer.AutoActions) then begin
    if GA_CHECK IN va then Result:= GA_CHECK
    else Result:= GA_FOLD;
  end else
  if (GAA_CHECK_OR_CALL IN aGamer.AutoActions) then begin
    if GA_CHECK IN va then Result:= GA_CHECK
    else Result:= GA_CALL;
  end else
  if (GAA_AUTO_BET IN aGamer.AutoActions) AND (GA_BET IN va) then Result:= GA_BET
  else
  if (GAA_AUTO_RAISE IN aGamer.AutoActions) then begin
    if (GA_RAISE IN va) then Result:= GA_RAISE;
  end else
  if (GAA_BET_OR_RAISE IN aGamer.AutoActions) then begin
    if GA_BET IN va then Result:= GA_BET
    else begin
      if (GA_RAISE IN va) then Result:= GA_RAISE;
    end;//if
  end else
  if (GA_RAISE IN va) AND (GAA_AUTO_RAISE IN aGamer.AutoActions) then Result:= GA_RAISE
  else
  if (GA_CALL IN va) AND (GAA_AUTO_CALL IN aGamer.AutoActions) then Result:= GA_CALL
  else
  ;

//check for improper call
  if Result = GA_RAISE then begin
    if (aGamer.AutoActionStake <> GetRaiseStakeValue(aGamer)) AND
       (aGamer.AutoActionStake <> PL_UNDEFINED_STAKE_AMOUNT) AND
       (aGamer.AutoActionStake <> aGamer.Account.Balance)
    then begin
      Result:= GA_NONE;
      Exit;
    end;//if
    if MaxBetLimitIsReached(aGamer) then begin
      Result:= GA_NONE;
      Exit;
    end;//if
  end;//if raise

  if (Result = GA_CALL) AND
    (aGamer.AutoActionStake <> GetCallStakeValue(aGamer)) AND
    (aGamer.AutoActionStake <> PL_UNDEFINED_STAKE_AMOUNT) AND
    (aGamer.AutoActionStake <> aGamer.Account.Balance)
  then begin
    Result:= GA_NONE;
    Exit;
  end;//if
end;

procedure TpoSingleTableCroupier.ClearTurnLevelGamerAutoActions(
  aGamer: TpoGamer);
begin
  aGamer.AutoActions:= aGamer.AutoActions- TURN_LEVEL_AUTO_ACTIONS;
  aGamer.AutoActionStake:= 0;
end;

function TpoSingleTableCroupier.InvokeGamerAction(
  aGamer: TpoGamer; nAction: TpoGamerAction; vParams: Array of Variant): Boolean;
begin
  Result := False;
  case nAction of
  //async
    GA_SIT_OUT            :Result:= HandleGamerSitOut(aGamer) <> nil;
    GA_WAIT_BB            :;
    GA_BACK               :;
    GA_LEAVE_TABLE        :Result:= HandleGamerLeaveTable(aGamer) <> nil;

  //rdered actions
    GA_POST_SB            : Result:= HandleGamerPostSB(aGamer, GetSmallBlindStakeValue()) <> nil;
    GA_POST_BB            : Result:= HandleGamerPostBB(aGamer, GetBigBlindStakeValue()) <> nil;
    GA_ANTE               : Result:= HandleGamerAnte(aGamer, GetAnteStakeValue()) <> nil;
    GA_POST               :;
    GA_POST_DEAD          :;
    GA_FOLD               :
      begin
        HandleGamerFold(aGamer, False);
      end;//

    GA_ALL_IN             : Result:= HandleGamerAllIn(aGamer) <> nil;

    GA_CHECK              : Result:= HandleGamerCheck(aGamer) <> nil;
    GA_BET                : Result:= HandleGamerBet(aGamer, GetBetStakeValue(aGamer)) <> nil;
    GA_CALL               : Result:= HandleGamerCall(aGamer, GetCallStakeValue(aGamer)) <> nil;
    GA_RAISE              : Result:= HandleGamerRaise(aGamer, GetRaiseStakeValue(aGamer)) <> nil;
    GA_SHOW_CARDS         : Result:= HandleGamerShowCards(aGamer) <> nil;
    GA_SHOW_CARDS_SHUFFLED: Result:= HandleGamerShowCardsShuffled(aGamer) <> nil;
    GA_MUCK               : Result:= HandleGamerMuck(aGamer) <> nil;
    GA_DONT_SHOW          : Result:= HandleGamerDontShowCards(aGamer) <> nil;
    GA_DISCARD_CARDS      :;
    GA_BRING_IN           :;

  //stub
    GA_NONE               :;
  end;//case
end;

procedure TpoSingleTableCroupier.HandleLeftGamers(bSuppressNotification: Boolean);
var
  I: Integer;
  aGamer: TpoGamer;
begin

//prepare unreserve instructions
  for I := 0  to Gamers.Count-1 do begin
    aGamer := Gamers[I];
    if aGamer.FSheduledToLeaveTable and (not aGamer.IsWatcher) then aGamer.State := GS_LEFT_TABLE;
    if (aGamer.State = GS_LEFT_TABLE) AND Assigned(OnGamerLeaveTable) then OnGamerLeaveTable(aGamer);
  end;//if

//update chairs
  FTable.Gamers.ClearLeftGamers(bSuppressNotification);
end;

function TpoSingleTableCroupier.HandleGamerSitOutNextHand(aGamer: TpoGamer;
  bStatus: Boolean): TpoGamer;
begin
  Result:= aGamer;

  if (FTournamentType = TT_NOT_TOURNAMENT) then begin
    if aGamer.IsBot then bStatus := False;
  end;

  aGamer.PassNextHand:= bStatus;

  case aGamer.State of
    GS_FOLD:
      begin
        if NOT bStatus then begin
          aGamer.Back;
          aGamer.State:= GS_FOLD;
          aGamer.IsTakedSit := True;
        end;//
      end;//
    GS_IDLE  : if bStatus then HandleGamerSitOut(aGamer);
    GS_SITOUT:
      if NOT bStatus then begin
        HandleGamerBack(aGamer);
      end;//
  end;//case
end;

procedure TpoSingleTableCroupier.TurnGamerCardsOver(aGamer: TpoGamer);
begin
  if (aGamer.FTurnedCardsOver) then Exit;
  if aGamer.Cards.Count = 0 then Exit;
  aGamer.Cards.OpenHand();
  aGamer.FTurnedCardsOver:= True;
  if Assigned(OnGamerAction) then begin
    OnGamerAction(aGamer, GA_TURN_CARDS_OVER, []);
  end;//if
end;

procedure TpoSingleTableCroupier.TurnCardsOfGamersOver;
var
  I: Integer;
begin
  for I:= 0 to Gamers.Count-1 do begin
    TurnGamerCardsOver(Gamers[I]);
  end;//for
end;

function TpoSingleTableCroupier.HandleGamerAllIn(
  aGamer: TpoGamer): TpoGamer;
var
  ga: TpoUserSettlementAccount;
begin
  Result:= aGamer;
  aGamer.State := GS_ALL_IN;
  aGamer.LastActionInRound:= GA_ALL_IN;
  ga:= Hand.Pot.Bets.GetAccountByUserID(aGamer.UserID) as TpoUserSettlementAccount;
  ga.State:= AS_ALL_IN;
  if Assigned(OnGamerAction) then OnGamerAction(aGamer, GA_ALL_IN, []);
  if Result.IsActive then DefineNextStageInHand();

//bot addon
  PostRandomAnswerOnCategory(aGamer, BCP_GOES_ALL_IN);
end;

function TpoSingleTableCroupier.FindStepRightOrPostChairLeftToPosition(
  nPositionID: Integer; bDontSkipSitouts: Boolean): TpoChair;

  function GetNextPositionID(nPositionID: Integer): Integer;
  begin
    if nPositionID < Chairs.Count-1 then Result:= nPositionID+1
    else Result:= 0;
  end;//

  function ChairIsInSitoutState(aChair: TpoChair): Boolean;
  begin
    Result:= (aChair.Gamer <> nil) AND ((aChair.Gamer.State = GS_SITOUT) OR (aChair.Gamer.IsSitOut));
  end;//

var
  nNextPosID: Integer;
  CntIter: Integer;
begin
  Result:= nil;
  nNextPosID:= nPositionID;
  CntIter := -1;
  repeat
    Inc(CntIter);
    if (CntIter > (Chairs.Count + 1)) then begin
      CommonDataModule.Log(ClassName, 'FindStepRightOrPostChairLeftToPosition',
      '[WARNING - CIRCLE]: Count of iterations in REPEAT statment more then needing. Iteration count=' + IntToStr(CntIter) + ', Chair count=' + IntToStr(Chairs.Count) +
        'Dialer=' + IntToStr(Hand.DealerChairID) + ', Active=' + IntToStr(Hand.FActiveChairID) +
        ', SmallBlind' + IntToStr(Hand.FSmallBlindChairID) + ', BigBlind=' + IntToStr(Hand.FBigBlindChairID) +
        ', HandID=' + IntToStr(Hand.HandID) + ', Round=' +IntToStr(Hand.RoundID),
      ltError);
      EscalateFailure(
        EpoException,
        'Count of iterations in REPEAT statment more then needing. Iteration count=' + IntToStr(CntIter) + ', Chair count=' + IntToStr(Chairs.Count),
        '{321E89CA-7479-476B-B76C-44DCDD65622F}'
      );
    end;

    nNextPosID:= GetNextPositionID(nNextPosID);
    if ChairCanTakeStepRight(Chairs[nNextPosID]) OR
      (ChairIsInSitoutState(Chairs[nNextPosID]) AND bDontSkipSitouts) OR
      ((Chairs[nNextPosID].Gamer <> nil) AND ((Chairs[nNextPosID].Gamer.LastActionInRound IN [GA_POST, GA_POST_DEAD])))
    then begin
      Result:= Chairs[nNextPosID];
      Break;
    end;//if
  until nNextPosID = nPositionID;
end;

{ TpoCroupierFactory }

class function TpoCroupierFactory.GetCroupierClass(
  nTournamentType: TpoTournamentType): TpoGenericCroupierClass;
begin
  case nTournamentType of
    TT_NOT_TOURNAMENT: Result:= TpoSingleTableCroupier;
    TT_SINGLE_TABLE  : Result:= TpoSingleTableTournamentCroupier;
    TT_MULTI_TABLE   : Result:= TpoMultiTableTournamentCroupier;
  else
    Result:= TpoGenericCroupier;
  end;//case
end;


{ TpoAggregate }

constructor TpoAggregate.Create;
begin
  inherited Create;
end;

destructor TpoAggregate.Destroy;
begin
  inherited;
end;

function TpoSingleTableCroupier.HandleGamerUseTimeBank(
  aGamer: TpoGamer): Boolean;
begin
  Result:= False;
end;

function TpoSingleTableCroupier.GetRakeRule: TpoRakeRule;
var
  I: Integer;
begin
  { initial }
  if FTable.FRakeRulesItem.Count <= 0 then begin
    Result := nil;
    Exit;
  end else begin
    Result := FTable.FRakeRulesItem.Items[0];
  end;

  { search }
  for I:=1 to FTable.FRakeRulesItem.Count - 1 do begin
    if (Hand.PlayersCntAtFlop <= Result.FCountOfPlayers) then Break;
    Result := FTable.FRakeRulesItem.Items[I];
  end;
end;

function TpoSingleTableCroupier.GetRakesValue: Integer;
var
  aRule: TpoRakeRule;
begin
  aRule := GetRakeRule();
  if aRule = nil then Result := 0 else Result := aRule.FValue;
end;

function TpoSingleTableCroupier.GetRakesLimit: Integer;
var
  aRule: TpoRakeRule;
begin
  aRule := GetRakeRule();
  if aRule = nil then Result := 0 else Result := aRule.FTotalLimit;
end;

function TpoSingleTableCroupier.CalcRakesRateForSitePot(
  nRakesCharged, nSitePotAmount, nIncomingReminder: Integer;
  var nSidePotRakeAmount: Integer;
  var bLimitIsReached: Boolean
  ): Integer;
var
  nPotAmount: Integer;
  nAmountUnderRake: Integer;
  nRakesLimit,
  nRakesThreehold,
  nRakesValue: Integer;
begin
//init
  bLimitIsReached:= False;
  nSidePotRakeAmount:= 0;
  nPotAmount:= nSitePotAmount+nIncomingReminder;
  nRakesLimit:= GetRakesLimit();
  nRakesThreehold := GetRakesThreshold();
  nRakesValue := GetRakesValue();

  nAmountUnderRake:= Trunc(nPotAmount / nRakesThreehold);
  nSidePotRakeAmount:= nAmountUnderRake * nRakesValue;
  bLimitIsReached:= (nSidePotRakeAmount+ nRakesCharged)>= nRakesLimit;
  if bLimitIsReached then nSidePotRakeAmount:= nRakesLimit-nRakesCharged;
  Result:= nPotAmount- nAmountUnderRake*nRakesThreehold;
end;


function TpoSingleTableCroupier.GetRakesThreshold(): Integer;
var
  aRule: TpoRakeRule;
begin
  aRule := GetRakeRule();
  if aRule = nil then Result := 0 else Result := aRule.FThreshold;
end;

{ TpoRakeRule }

constructor TpoRakeRule.Create(aOwner: TpoRakeRulesItem);
begin
  inherited Create;
  FOwner := aOwner;
end;

destructor TpoRakeRule.Destroy;
begin

  inherited;
end;

function TpoRakeRule.Load(aReader: TReader): Boolean;
begin
  Result:= True;

  FThreshold      := aReader.ReadInteger;
  FTotalLimit     := aReader.ReadInteger;
  FValue          := aReader.ReadInteger;
  FCountOfPlayers := aReader.ReadInteger;
end;

procedure TpoRakeRule.SetContextByObject(aObject: TpoRakeRule);
begin
  FThreshold      := aObject.FThreshold;
  FTotalLimit     := aObject.FTotalLimit;
  FValue          := aObject.FValue;
  FCountOfPlayers := aObject.FCountOfPlayers;
end;

procedure TpoRakeRule.SetCountOfPlayers(const Value: Integer);
begin
  FCountOfPlayers := Value;
end;

procedure TpoRakeRule.SetThreshold(const Value: Integer);
begin
  FThreshold := Value;
end;

procedure TpoRakeRule.SetTotalLimit(const Value: Integer);
begin
  FTotalLimit := Value;
end;

procedure TpoRakeRule.SetValue(const Value: Integer);
begin
  FValue := Value;
end;

function TpoRakeRule.Store(aWriter: TWriter): Boolean;
begin
  Result:= True;

  aWriter.WriteInteger(FThreshold);
  aWriter.WriteInteger(FTotalLimit);
  aWriter.WriteInteger(FValue);
  aWriter.WriteInteger(FCountOfPlayers);
end;

{ TpoRakeRulesItem }

function TpoRakeRulesItem.AddItem(nThreshold, nTotalLimit, nValue,
  nCountOfPlayers: Integer): TpoRakeRule;
begin
  FSorted := False;
  Result := TpoRakeRule.Create(Self);

  Result.FValue := nValue;
  Result.FTotalLimit := nTotalLimit;
  Result.FThreshold := nThreshold;
  Result.FCountOfPlayers := nCountOfPlayers;

  inherited Add(Result as TObject);
end;

constructor TpoRakeRulesItem.Create(aOwner: TpoRakeRulesRoot);
begin
  inherited Create;
  FOwner := aOwner;
  FSorted := False;
end;

procedure TpoRakeRulesItem.DelItem(nIndex: Integer);
begin
  DelItem(Items[nIndex]);
end;

procedure TpoRakeRulesItem.DelItem(aItem: TpoRakeRule);
begin
  inherited Remove(aItem as TObject);
end;

destructor TpoRakeRulesItem.Destroy;
begin
  Clear;
  inherited;
end;

function TpoRakeRulesItem.GetItems(nIndex: Integer): TpoRakeRule;
begin
  Result := inherited Items[nIndex] as TpoRakeRule;
end;

function TpoRakeRulesItem.Load(aReader: TReader): Boolean;
var
  I, cnt: Integer;
begin
  Result := True;

  Clear;
  FLowerLimitStake := aReader.ReadInteger;
  FSorted := aReader.ReadBoolean;
  cnt:= aReader.ReadInteger;
  for I:= 0 to cnt-1 do begin
    AddItem(20, 3, 1, 10).Load(aReader);
  end;//for
end;

procedure TpoRakeRulesItem.SetContextByNode(aNodeRoot: IXMLNode);
var
  I: Integer;
  aNode: IXMLNode;
  nThreshold, nTotalLimit, nRakeValue, nCountOfPlayers: Integer;
begin
  Clear;
  for I:=0 to aNodeRoot.ChildNodes.Count - 1 do begin
    aNode := aNodeRoot.ChildNodes[I];

    nThreshold  := 2000;
    nTotalLimit := 300;
    nRakeValue  := 100;
    nCountOfPlayers := 10;

    if aNode.HasAttribute('value') then
      nCountOfPlayers := StrToIntDef(aNode.Attributes['value'], 10);
    if aNode.HasAttribute('threshold') then
      nThreshold := Trunc( StrToFloatDef(aNode.Attributes['threshold'], 20) * 100 );
    if aNode.HasAttribute('totallimit') then
      nTotalLimit := Trunc( StrToFloatDef(aNode.Attributes['totallimit'], 3) * 100 );
    if aNode.HasAttribute('rakevalue') then
      nRakeValue := Trunc( StrToFloatDef(aNode.Attributes['rakevalue'], 1) * 100 );

    AddItem(nThreshold, nTotalLimit, nRakeValue, nCountOfPlayers);
  end;
end;

procedure TpoRakeRulesItem.SetContextByObject(aObject: TpoRakeRulesItem);
var
  I: Integer;
  aItem: TpoRakeRule;
begin
  Clear;
  for I:=0 to aObject.Count - 1 do begin
    aItem := aObject.Items[I];
    AddItem(aItem.FThreshold, aItem.FTotalLimit, aItem.FValue, aItem.FCountOfPlayers);
  end;
  FLowerLimitStake := aObject.FLowerLimitStake;
  FSorted := aObject.FSorted;
end;

procedure TpoRakeRulesItem.SetDefault;
begin
  Clear;
  AddItem(20, 3, 1, 2);
end;

procedure TpoRakeRulesItem.SetItem(nIndex: Integer; const Value: TpoRakeRule);
begin
  Items[nIndex] := Value;
end;

procedure TpoRakeRulesItem.SetLowerLimitStake(
  const Value: Integer);
begin
  FLowerLimitStake := Value;
end;

procedure TpoRakeRulesItem.SortByCountPlayers(Ascending: Boolean);
var
  I, J, TopInd: Integer;
  aItem: TpoRakeRule;
begin
  if FSorted then Exit;

  for I := 0 to Count - 1 do
  begin
    TopInd := I;

    // search next top index
    for J := I+1 to Count - 1 do
    begin
      aItem := Items[J];

      if Ascending then begin
        if Items[TopInd].FCountOfPlayers > aItem.FCountOfPlayers then TopInd := IndexOf(aItem);
      end else begin
        if Items[TopInd].FCountOfPlayers < aItem.FCountOfPlayers then TopInd := IndexOf(aItem);
      end;
    end;

    // swap indexes
    if (TopInd <> I) then begin
      aItem := TpoRakeRule.Create(Self);
      aItem.SetContextByObject(Items[TopInd]);
      Items[TopInd].SetContextByObject(Items[I]);
      Items[I].SetContextByObject(aItem);
      aItem.Free;
    end;
  end;

  FSorted := True;
end;

function TpoRakeRulesItem.Store(aWriter: TWriter): Boolean;
var
  I: Integer;
begin
  Result := True;

  aWriter.WriteInteger(FLowerLimitStake);
  aWriter.WriteBoolean(FSorted);
  aWriter.WriteInteger(Count);
  for I:= 0 to Count-1 do begin
    Items[I].Store(aWriter);
  end;//for
end;

{ TpoRakeRulesRoot }

function TpoRakeRulesRoot.AddItem(nLowerLimitStake: Integer): TpoRakeRulesItem;
begin
  FSorted := False;
  Result := TpoRakeRulesItem.Create(Self);

  Result.FLowerLimitStake := nLowerLimitStake;

  inherited Add(Result as TObject);
end;

constructor TpoRakeRulesRoot.Create;
begin
  inherited Create;
  FSorted := False;
end;

procedure TpoRakeRulesRoot.DelItem(aItem: TpoRakeRulesItem);
begin
  inherited Remove(aItem as TObject); 
end;

procedure TpoRakeRulesRoot.DelItem(nIndex: Integer);
begin
  DelItem(Items[nIndex]);
end;

destructor TpoRakeRulesRoot.Destroy;
begin
  Clear;
  inherited;
end;

function TpoRakeRulesRoot.GetItems(nIndex: Integer): TpoRakeRulesItem;
begin
  Result := inherited Items[nIndex] as TpoRakeRulesItem;
end;

function TpoRakeRulesRoot.Load(aReader: TReader): Boolean;
var
  I, cnt: Integer;
begin
  Result := True;

  Clear;
  FSorted := aReader.ReadBoolean;
  cnt:= aReader.ReadInteger;
  for I:= 0 to cnt-1 do begin
    AddItem(2).Load(aReader);
  end;//for
end;

procedure TpoRakeRulesRoot.SetContextByNode(aNodeRoot: IXMLNode);
var
  I, nLowerLimitOfStake: Integer;
  aNode: IXMLNode;
begin
  Clear;
  for I:=0 to aNodeRoot.ChildNodes.Count - 1 do begin
    aNode := aNodeRoot.ChildNodes[I];
    nLowerLimitOfStake := 0;
    if aNode.HasAttribute('value') then
      nLowerLimitOfStake := Trunc( StrToFloatDef(aNode.Attributes['value'], 0) * 100 );
    AddItem(nLowerLimitOfStake).SetContextByNode(aNode);
  end;
end;

procedure TpoRakeRulesRoot.SetContextByXMLText(sXML: string);
var
  aXML: IXMLDocument;
begin
  aXML := TXMLDocument.Create(nil);

  try
    try
      aXML.XML.Text := sXML;
      aXML.Active := True;
      SetContextByNode(aXML.DocumentElement);
    except
      CommonDataModule.Log(ClassName, 'SetContextByXMLText',
        '[EXCEPTION] On Load rake rules from XML text: Data=[' + sXML + ']',
        ltException
      );
      Clear;
    end;
  finally
    aXML := nil;
  end;
end;

procedure TpoRakeRulesRoot.SetItem(nIndex: Integer; const Value: TpoRakeRulesItem);
begin
  inherited Items[nIndex] := Value as TObject;
end;

procedure TpoRakeRulesRoot.SortAll(Ascending: Boolean);
var
  I: Integer;
begin
  SortByLowerLimitStake(Ascending);
  for I:=0 to Count - 1 do begin
    Items[I].SortByCountPlayers(Ascending);
  end;
end;

procedure TpoRakeRulesRoot.SortByLowerLimitStake(Ascending: Boolean);
var
  I, J, TopInd: Integer;
  aItem: TpoRakeRulesItem;
begin
  if FSorted then Exit;

  for I := 0 to Count - 1 do
  begin
    TopInd := I;

    // search next top index
    for J := I+1 to Count - 1 do
    begin
      aItem := Items[J];

      if Ascending then begin
        if Items[TopInd].FLowerLimitStake > aItem.FLowerLimitStake then TopInd := IndexOf(aItem);
      end else begin
        if Items[TopInd].FLowerLimitStake < aItem.FLowerLimitStake then TopInd := IndexOf(aItem);
      end;
    end;

    // swap indexes
    if (TopInd <> I) then begin
      aItem := TpoRakeRulesItem.Create(Self);
      aItem.SetContextByObject(Items[TopInd]);
      Items[TopInd].SetContextByObject(Items[I]);
      Items[I].SetContextByObject(aItem);
      aItem.Free;
    end;
  end;

  FSorted := True;
end;

function TpoRakeRulesRoot.Store(aWriter: TWriter): Boolean;
var
  I: Integer;
begin
  Result := True;

  aWriter.WriteBoolean(FSorted);
  aWriter.WriteInteger(Count);
  for I:= 0 to Count-1 do begin
    Items[I].Store(aWriter);
  end;//for
end;

function TpoSingleTableCroupier.InvokeBotAction(aGamer: TpoGamer;
  nAction: TpoGamerAction; Stake, Dead: Integer): Boolean;
var
  nRaiseStake: Integer;
begin
  Result := False;

  if Stake < 0 then Stake := 0;
  if Dead  < 0 then Dead  := 0;

  case StakeType of
    ST_POT_LIMIT, ST_NO_LIMIT:
    begin
      nRaiseStake := GetStakeLimit(aGamer, Stake);// GetMaxStakeValue(aGamer);
      if (nRaiseStake > Stake) then
        nRaiseStake := Stake;
    end;
  else
    nRaiseStake := GetRaiseStakeValue(aGamer);
  end;

  case nAction of
  //async
    GA_SIT_OUT            :Result:= HandleGamerSitOut(aGamer) <> nil;
    GA_WAIT_BB            :;
    GA_BACK               :;
  //rdered actions
    GA_POST_SB            : Result:= HandleGamerPostSB(aGamer, GetSmallBlindStakeValue()) <> nil;
    GA_POST_BB            : Result:= HandleGamerPostBB(aGamer, GetBigBlindStakeValue()) <> nil;
    GA_ANTE               : Result:= HandleGamerAnte(aGamer, GetAnteStakeValue()) <> nil;
    GA_POST               : Result:= HandleGamerPost(aGamer, Stake) <> nil;
    GA_POST_DEAD          : Result:= HandleGamerPostDead(aGamer, Stake, Dead) <> nil;
    GA_FOLD               :
      begin
        HandleGamerFold(aGamer, False);
      end;//

    GA_ALL_IN             : Result:= HandleGamerAllIn(aGamer) <> nil;

    GA_CHECK              : Result:= HandleGamerCheck(aGamer) <> nil;
    GA_BET                : Result:= HandleGamerBet(aGamer, GetBetStakeValue(aGamer)) <> nil;
    GA_CALL               : Result:= HandleGamerCall(aGamer, GetCallStakeValue(aGamer)) <> nil;
    GA_RAISE              : Result:= HandleGamerRaise(aGamer, nRaiseStake) <> nil; // GetRaiseStakeValue(aGamer)) <> nil;
    GA_SHOW_CARDS         : Result:= HandleGamerShowCards(aGamer) <> nil;
    GA_SHOW_CARDS_SHUFFLED: Result:= HandleGamerShowCardsShuffled(aGamer) <> nil;
    GA_MUCK               : Result:= HandleGamerMuck(aGamer) <> nil;
    GA_DONT_SHOW          : Result:= HandleGamerDontShowCards(aGamer) <> nil;
    GA_DISCARD_CARDS      :;
    GA_BRING_IN           :  Result:= HandleGamerBringIn(aGamer, GetBringInStakeValue) <> nil;

  //stub
    GA_NONE               :;
  end;//case
end;

procedure TpoSingleTableCroupier.CheckForBotsContinue;
var
  I: Integer;
  aGamer: TpoGamer;
  aChair: TpoChair;
  nMoney: Integer;
begin
  for I:= 0 to Chairs.Count - 1 do begin
    aChair := Chairs[I];
    aGamer := aChair.Gamer;
    if (aGamer = nil) then Continue;
    if not aGamer.IsBot then Continue;

    if (aGamer.BotBlaffersEvent <= 0) then
      aGamer.FBotBlaffersEvent := MIN_COUNT_ONBLAFFERS + Random(MAX_COUNT_ONBLAFFERS - MIN_COUNT_ONBLAFFERS);

    if (FTournamentType = TT_NOT_TOURNAMENT) then begin
      if (aGamer.Account.Balance < GetBigBlindStakeValue) then begin
        nMoney :=
          Hand.FTable.MinBuyIn +
          Random(Hand.FTable.MaxBuyIn - Hand.FTable.MinBuyIn) -
          aGamer.Account.Balance;
        aGamer.FDuringGameAddedMoney := nMoney - aGamer.Account.Balance;

        HandleGamerBack(aGamer);
      end;
    end;
  end;//for
end;

initialization
  Randomize();

finalization

end.
