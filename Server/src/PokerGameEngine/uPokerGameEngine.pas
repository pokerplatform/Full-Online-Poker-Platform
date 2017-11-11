unit uPokerGameEngine;

interface

uses
//added state stamp

//RTL
  Windows, Classes, SysUtils, Variants,
	XMLDoc, XMLIntF, XMLDom, Contnrs, SyncObjs

//Poker
  , uPokerDefs
  , uPokerBase
  , uErrorHandling
  , uApi
  ;

////////////////////////////////////////////////////////////////////////////////
const
  PV_GAME_ENGINE_VERSION = '1.904';
  UNDEFINED_PROCESS_ID = -1;
//  TIME_OUT_GAMERS_ACTIVITY = 300;
//  TIME_OUT_GAMERS_ACTIVITY = 600;
  ID_TIME_OUT_GAMERS_ACTIVITY = 23;
//  MAXIMUM_WATCHERS_ALLOWED = 25;
  ID_MAXIMUM_WATCHERS_ALLOWED = 22;
//  TIME_OUT_GAMERS_ACTIVITY = 60;
  ID_EMAILVALIDATED_ON_ENTRY   = 13;
  ID_EMAILVALIDATED_ON_SITDOWN = 14;
  ID_STORING_GAMELOG_WITH_BOTSONLY = 24;
  ID_MAXIMUM_CHAIRS_COUNT = 26;

////////////////////////////////////////////////////////////////////////////////
// Messaging Facility
////////////////////////////////////////////////////////////////////////////////
type
  TpoMessageList = class;

  TpoMessage = class
  private
    FSessionID: Integer;
    FMsgBody: String;
    FUserID: Integer;
    FRespGroup: string;
    FIncludeRequester: Boolean;
    FTime: TDateTime;
    FOwner: TpoMessageList;
    procedure SetMsgBody(const Value: String);
    procedure SetSessionID(const Value: Integer);
    procedure SetUserID(const Value: Integer);
    procedure SetRespGroup(const Value: string);
    procedure SetIncludeRequester(const Value: Boolean);
    procedure SetTime(const Value: TDateTime);
  protected
		function Load(aReader: TReader): Boolean;
		function Store(aWriter: TWriter): Boolean;
  public
    property SessionID: Integer read FSessionID write SetSessionID;
    property MsgBody: String read FMsgBody write SetMsgBody;
    property UserID: Integer read FUserID write SetUserID;
    property RespGroup: string read FRespGroup write SetRespGroup;
    property IncludeRequester: Boolean read FIncludeRequester write SetIncludeRequester;
    property Time: TDateTime read FTime write SetTime;
    property Owner: TpoMessageList read FOwner;

  //generic
    constructor Create(aOwner: TpoMessageList;
      sRespGroup: string; nSessionID: Integer;
      sMsgBody: String; nUserID: Integer = UNDEFINED_USER_ID;
      bIncludeRequester: Boolean = True
    );
    destructor Destroy; override;
  end;//TpoMessage


  TpoMessageList = class(TObjectList)
  private
    function GetItems(nIndex: Integer): TpoMessage;
  protected
		function Load(aReader: TReader): Boolean;
		function Store(aWriter: TWriter): Boolean;
  public
    property Items[nIndex: Integer]: TpoMessage read GetItems;
    function PushMessage(aMessage: TpoMessage): TpoMessage;
    //
    constructor Create;
    destructor Destroy; override;
  end;//TpoMessageList

////////////////////////////////////////////////////////////////////////////////
// Properties:
////////////////////////////////////////////////////////////////////////////////
// Game Property Constraint tags
const
	GPC_MIN_VAL 	 = 'MinValue';
  GPC_MIN_VAL_DEF= '10';
	GPC_MAX_VAL 	 = 'MaxValue';
  GPC_MAX_VAL_DEF= '100';
	GPC_CHOICE_VAL = 'AvailableValue';

//action attrubutes
const
  AA_NAME       = 'name';
  AA_COMMAND    = 'command';

type
	TGamePropertyConstraint = class
	protected
		function Load(aReader: TReader): Boolean; virtual;
		function Store(aWriter: TWriter): Boolean; virtual;

	public
		Name, Value: String;

	//generic
		constructor Create(sName, sValue: String);
    destructor Destroy; override;
	end;//TGamePropertyConstraint


const
  SBG_TIME_FORMAT = 'hh:nn:ss';

type
	TGamePropertyType = (
		GPT_UNDEFINED,//
		GPT_INT,			//
		GPT_REAL, 		//
		GPT_CURRENCY, //
		GPT_STRING,   //
		GPT_COMBOBOX, //
		GPT_CHECKBOX, //
		GPT_DATE,     //
		GPT_TIME,     //
		GPT_SPINEDIT, //              sdsd
    GPT_RANDOMSEED
	);


function GamePropertyType2Str(nPropType: TGamePropertyType): String;
function Str2GamePropertyType(aPropType: String): TGamePropertyType;


type
	TGamePropertyModifier = (
		GPM_NORMAL,
		GPM_READONLY,
		GPM_HIDDEN,
    GPM_NOT_EXPOSED,
		GPM_UNDEFINED
	);

function GamePropertyModifier2Str(nPropMod: TGamePropertyModifier): String;
function Str2GamePropertyModifier(sPropMod: String): TGamePropertyModifier;

type
  TTimeUnits = (
    TU_SEC, TU_MIN, TU_HOURS, TU_DAYS
  );

type
	TGameProperty = class(TObjectList)
	private
    FValue: String;
    FName: String;
    FModifier: TGamePropertyModifier;
    FPropType: TGamePropertyType;
    FTimeUnits: TTimeUnits;
    FAlias: String;
    FIsModified: Boolean;
		function GetConstraint(Index: Integer): TGamePropertyConstraint;
		function GetConstraintCount: Integer;
		function GetBoolToNumber: Integer;
    function GetAsBoolean: Boolean;
    function GetAsTimeString: String;
    function GetIsNumber: Boolean;
    function GetAsInteger: Integer;
    procedure SetAsInteger(const Value: Integer);
    procedure SetModifier(const Value: TGamePropertyModifier);
    procedure SetName(const Value: String);
    procedure SetPropType(const Value: TGamePropertyType);
    procedure SetValue(const Value: String);
    procedure SetTimeUnits(const Value: TTimeUnits);
    function GetAsDouble: Double;
    procedure SetAsDouble(const Value: Double);
    procedure SetAlias(const Value: String);
    procedure SetIsModified(const Value: Boolean);

	protected
		function Load(aReader: TReader): Boolean; virtual;
		function Store(aWriter: TWriter): Boolean; virtual;

	public
		property Name    : String read FName write SetName;
    property Alias   : String read FAlias write SetAlias;
		property PropType: TGamePropertyType read FPropType write SetPropType;
		property Modifier: TGamePropertyModifier read FModifier write SetModifier;
		property Value   : String read FValue write SetValue;
    property IsModified: Boolean read FIsModified write SetIsModified;
		property Constraint[Index: Integer]: TGamePropertyConstraint
      read GetConstraint;
    property TimeUnits: TTimeUnits read FTimeUnits write SetTimeUnits;

		property ConstraintCount: Integer read GetConstraintCount;
		property BoolStringToNumber: Integer read GetBoolToNumber;
    property AsBoolean: Boolean read GetAsBoolean;
    property IsNumber: Boolean read GetIsNumber;
    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    property AsDouble: Double read GetAsDouble write SetAsDouble;
    property AsTimeString: String read GetAsTimeString;

		function AddConstraint(sName, sValue: String): TGamePropertyConstraint;
		function ConstraintByName(sName: String): TGamePropertyConstraint;

	//generic
		constructor Create(
			sName, sValue: String;
			sPropType: TGamePropertyType;
			sModifier: TGamePropertyModifier = GPM_NORMAL
		);
    destructor Destroy; override;
	end;//TGameProperty


	TGameProperties = class(TObjectList)
	private
		function GetProperty(Index: Integer): TGameProperty;

	protected
		function Load(aReader: TReader): Boolean; virtual;
		function Store(aWriter: TWriter): Boolean; virtual;

	public
		property Properties[Index: Integer]: TGameProperty read GetProperty; default;
		function PropertyByName(sName: String): TGameProperty;

		function AddProperty(
			sName, sValue: String;
			sPropType: TGamePropertyType     = GPT_INT;
			sModifier: TGamePropertyModifier = GPM_NORMAL
		): TGameProperty;

	//generic
		constructor Create;
    destructor Destroy; override;
	end;//TGameProperties


////////////////////////////////////////////////////////////////////////////////
// Stats:
////////////////////////////////////////////////////////////////////////////////
  TpoGameStatItem = class(TGameProperty)
  private
    FIsStandard: Boolean;
    FID: Integer;
    procedure SetID(const Value: Integer);
    procedure SetIsStandard(const Value: Boolean);

  protected
		function Load(aReader: TReader): Boolean;  override;
		function Store(aWriter: TWriter): Boolean; override;

  public
    property ID: Integer read FID write SetID;
    property IsStandard: Boolean read FIsStandard write SetIsStandard;

  //generic
    constructor Create(
      nID: Integer;
			sName: String;
			sPropType: TGamePropertyType;
      bIsStandard: Boolean = True;
			sModifier: TGamePropertyModifier = GPM_NORMAL
    );
    destructor Destroy; override;
  end;//TpoGameStatItem


  TpoGameStats = class(TObjectList)
  private
    function GetByID(ID: Integer): TpoGameStatItem;
    function GetStats(Index: Integer): TpoGameStatItem;

  protected
		function Load(aReader: TReader): Boolean; virtual;
		function Store(aWriter: TWriter): Boolean; virtual;

  public
    property ByID[ID: Integer]: TpoGameStatItem read GetByID;
    property Stats[Index: Integer]: TpoGameStatItem read GetStats; default;

  //utility
    function AddStatItem(
      nID: Integer = 0;
			sName: String = '';
			sPropType: TGamePropertyType = GPT_UNDEFINED;
      bIsStandard: Boolean = True;
			sModifier: TGamePropertyModifier = GPM_NORMAL
    ): TpoGameStatItem;
    procedure HideAllStats();

  //generic
    constructor Create;
    destructor Destroy; override;
  end;//TpoGameStats


////////////////////////////////////////////////////////////////////////////////
// Actions:
////////////////////////////////////////////////////////////////////////////////
  TOnExecuteAction = function (
    nSessionID, nUserID: Integer; aActionInfo: IXMLNode
  ): IXMLNode of object;

  TpoBasicGameEngine = class;
  TpoGameActions = class;
  TpoGameAction = class
  private
    FName: String;
    FOnExecute: TOnExecuteAction;
    procedure SetName(const Value: String);
    procedure SetOnExecute(const Value: TOnExecuteAction);
    function Execute(nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;

  protected
    FSubActions: TpoGameActions;
    FEngine: TpoBasicGameEngine;
    function DefaultExecuteHandler(nSessionID: Integer; aActionInfo: IXMLNode): IXMLNode; virtual;

  public
    property Name: String read FName write SetName;
    property OnExecute: TOnExecuteAction read FOnExecute write SetOnExecute;

  //generic
    constructor Create(aEngine: TpoBasicGameEngine); reintroduce;
    destructor Destroy; override;
  end;//TpoGameAction


  TpoGameActions = class(TstringList)
  private
    FAttributeName: String;
    function GetActions(sName: String): TpoGameAction;
    procedure SetAttributeName(const Value: String);

  protected
    FEngine: TpoBasicGameEngine;

  public
    property Actions[sName: String]: TpoGameAction read GetActions; default;
    property AttributeName: String read FAttributeName write SetAttributeName;

  //utility
    function ActionByName(sActionName: String): TpoGameAction;
    function AddAction(sActionName: String; aAction: TpoGameAction): TpoGameAction; overload;
    function AddAction(sActionName: String; aHandler: TOnExecuteAction): TpoGameAction; overload;

    function AddSubAction(
      sActionName, sSubActionName: String; aHandler: TOnExecuteAction; sActionAttribute: String = AA_NAME
    ): TpoGameAction; overload;

    function IsSupported(aActionInfo: IXMLNode): Boolean; overload;
    function IsSupported(sActionName: String): Boolean; overload;
    function DispatchAction(nOriginatorID, nUserIDAttr: Integer; aAction: IXMLNode): IXMLNode;

  //generic
    procedure Clear; override;
    constructor Create(aEngine: TpoBasicGameEngine);
    destructor Destroy; override;
  end;//TpoGameActions


////////////////////////////////////////////////////////////////////////////////
// Scheduler
////////////////////////////////////////////////////////////////////////////////
  TpoReminder = class
  private
    FReminderName: String;
    FReminderID: string;
    FRemindTime: TDateTime;
    FExpired: Boolean;
    FSessionID: Integer;
    FUserID: Integer;
    FGamerActions: TpoGamerActions;
    FData: string;
    
    procedure SetReminderName(const Value: String);
    procedure SetReminderID(const Value: string);
    procedure SetRemindTime(const Value: TDateTime);
    procedure SetExpired(const Value: Boolean);
    procedure SetSessionID(const Value: Integer);
    procedure SetUserID(const Value: Integer);
    procedure SetGamerActions(const Value: TpoGamerActions);
    procedure SetData(const Value: string);    

  protected
		function Load(aReader: TReader): Boolean; virtual;
		function Store(aWriter: TWriter): Boolean; virtual;

  public
    property ReminderName: String read FReminderName write SetReminderName;
    property ReminderID: string read FReminderID write SetReminderID;
    property RemindTime: TDateTime read FRemindTime write SetRemindTime;
    property SessionID: Integer read FSessionID write SetSessionID;
    property UserID: Integer read FUserID write SetUserID;
    property Expired: Boolean read FExpired write SetExpired;
    property GamerActions: TpoGamerActions read FGamerActions write SetGamerActions;
    property Data: string read FData write SetData;    

  //
    constructor Create;
    destructor Destroy; override;
  end;//TpoReminder

  TpoReminders = class(TObjectList)
  private
    function GetReminder(nReminderID: String;
      sReminderName: String): TpoReminder;
    function GetItem(Index: Integer): TpoReminder;

  protected
		function Load(aReader: TReader): Boolean; virtual;
		function Store(aWriter: TWriter): Boolean; virtual;
    function GetByName(sReminderName: string): TpoReminder;

  public
    property Item[Index: Integer]: TpoReminder read GetItem;
    property Reminder[nReminderID: String; sReminderName: String]: TpoReminder read GetReminder;
    function AddReminder(sReminderName: string; sReminderID: String; sData: string; nRemindTime: TDateTime; nSessionID: Integer): TpoReminder; overload;
    function AddReminder(aReminder: TpoReminder): TpoReminder; overload;
    function GetReminderByUserIDAndName(nUserID: Integer; sName: String = ''): TpoReminder;
    function DeleteReminder(sReminderID: String): Boolean; // return - reminder was found

  //generic
    constructor Create;
    destructor Destroy; override;
  end;//TpoReminder


////////////////////////////////////////////////////////////////////////////////
// Persistence facility (Api wrapper)
////////////////////////////////////////////////////////////////////////////////
  TpoApiStateManager = class(TpoStateManager)
  private
    FStateID: Integer;
    FServiceStateID: Integer;
    FServiceState: String;
    FCachedState: String;

    procedure SetStateID(const Value: Integer);
    function GetInStream: TReader;
    function GetOutStream: TWriter;
    procedure SetServiceStateID(const Value: Integer);
    function GetOutServiceStream: TWriter;
    procedure SetServiceState(const Value: String);
    procedure SetCachedState(const Value: String);

  protected
    FTransactionStarted: Boolean;
    FUseApi: Boolean;
    FEngine: TpoBasicGameEngine;
    FInCache, FoutCache, FOutServiceCache: TStringStream;
    FInStream: TReader;
    FOutStream: TWriter;
    FoutServiceStream: TWriter;
    FProcessID: Integer;

    procedure RollbackChanges();
  public
    property InStream: TReader read GetInStream;
    property OutStream: TWriter read GetOutStream;
    property OutServiceStream: TWriter read GetOutServiceStream;
    property StateID: Integer read FStateID write SetStateID;
    property ServiceStateID: Integer read FServiceStateID write SetServiceStateID;
    PROPERTY ServiceState: String read FServiceState write SetServiceState;
    property ProcessID: Integer read FProcessID;
    property CachedState: String read FCachedState write SetCachedState;

  //util
    //!!use it for state init only!!
    function InitState(): Boolean;

    //in/out
    function CacheState(): Boolean; overload;
    function CacheState(StrState: string): Boolean; overload;

    function FlushState(): Boolean; overload;
    function FlushState(var StrState: string; var StrServiceState: string): Boolean; overload;

  //generic
    constructor Create(nProcessID: Integer; aEngine: TpoBasicGameEngine); reintroduce;
    destructor Destroy; override;
  end;//TpoApiStateManager



////////////////////////////////////////////////////////////////////////////////
// Gamer table deposit unreservation
////////////////////////////////////////////////////////////////////////////////
  TpoGamerDeposit = class
  private
    FAmount: Integer;
    FSessionID: Integer;
    FUserID: Integer;
    procedure SetAmount(const Value: Integer);
    procedure SetSessionID(const Value: Integer);
    procedure SetUserID(const Value: Integer);

  public
    property UserID: Integer read FUserID write SetUserID;
    property SessionID: Integer read FSessionID write SetSessionID;
    property Amount: Integer read FAmount write SetAmount;

    constructor Create;
    destructor Destroy; override;
  end;//TpoGamerDeposit

  TpoGamerDeposits = class(TObjectList)
  private
    function GetItems(Index: Integer): TpoGamerDeposit;

  public
    property Items[Index: Integer]: TpoGamerDeposit read GetItems; default;
  //utils
    function Add(nUserID, nSessionID: Integer; nAmount: Integer): TpoGamerDeposit;

  //generic
    constructor Create;
    destructor Destroy; override;
  end;//TpoGamerDeposits


////////////////////////////////////////////////////////////////////////////////
// Api suspended operations classes:
////////////////////////////////////////////////////////////////////////////////

  TTypeApiSuspendedOperation = (
    SO_RegisterParticipant,
    SO_UnRegisterParticipant,
    SO_UpdateParticipantCount
  );

  TTypeTournayApiSuspendedOperation = (
    TSO_Reservation,
    TSO_UnReservation,
    TSO_Prizes,
    TSO_ReInit
   );

  TTypeHandAndRakesSuspendedOperation = (
    HRSO_HandResult,
    HRSO_UserRakes
  );

  TpoApiSuspendedOperationList = class;

  TpoApiSuspendedOperation = class
  private
    FUserID: Integer;
    FSessionID: Integer;
    FChairID: Integer;
    FOwner: TpoApiSuspendedOperationList;
    FTypeOperation: TTypeApiSuspendedOperation;
    procedure SetChairID(const Value: Integer);
    procedure SetSessionID(const Value: Integer);
    procedure SetTypeOperation(const Value: TTypeApiSuspendedOperation);
    procedure SetUserID(const Value: Integer);
  public
    property TypeOperation: TTypeApiSuspendedOperation read FTypeOperation write SetTypeOperation;
    property SessionID: Integer read FSessionID write SetSessionID;
    property UserID: Integer read FUserID write SetUserID;
    property ChairID: Integer read FChairID write SetChairID;
    // read only
    property Owner: TpoApiSuspendedOperationList read FOwner;
    //
    constructor Create(aOwner: TpoApiSuspendedOperationList);
  end;

  TpoApiSuspendedOperationList = class(TObjectList)
  private
    function GetItems(nIndex: Integer): TpoApiSuspendedOperation;
  public
    property Items[nIndex: Integer]: TpoApiSuspendedOperation read GetItems;
    //
    function Add(aType: TTypeApiSuspendedOperation;
      nSessionID: Integer = UNDEFINED_SESSION_ID;
      nUserID   : Integer = UNDEFINED_USER_ID;
      nChairID  : Integer = UNDEFINED_POSITION_ID
    ): TpoApiSuspendedOperation;
    procedure Del(aOperation: TpoApiSuspendedOperation);
    function SearchByType(aType: TTypeApiSuspendedOperation): TpoApiSuspendedOperation;
    //
    constructor Create;
    destructor Destroy; override;
  end;

  TpoTournayApiSuspendedOperationList = class;

  TpoTournayApiSuspendedOperation = class
  private
    FHandID: Integer;
    FData: string;
    FComment: string;
    FOwner: TpoTournayApiSuspendedOperationList;
    FTypeOperation: TTypeTournayApiSuspendedOperation;
    procedure SetComment(const Value: string);
    procedure SetData(const Value: string);
    procedure SetHandID(const Value: Integer);
    procedure SetTypeOperation(
      const Value: TTypeTournayApiSuspendedOperation);
  public
    property TypeOperation: TTypeTournayApiSuspendedOperation read FTypeOperation write SetTypeOperation;
    property HandID: Integer read FHandID write SetHandID;
    property Data: string read FData write SetData;
    property Comment: string read FComment write SetComment;
    // read only
    property Owner: TpoTournayApiSuspendedOperationList read FOwner;
    //
    constructor Create(aOwner: TpoTournayApiSuspendedOperationList);
  end;

  TpoTournayApiSuspendedOperationList = class(TObjectList)
  private
    function GetItems(nIndex: Integer): TpoTournayApiSuspendedOperation;
  public
    property Items[nIndex: Integer]: TpoTournayApiSuspendedOperation read GetItems;
    //
    function Add(aType: TTypeTournayApiSuspendedOperation;
      nHandID: Integer; sData: string; sComment: string = ''
    ): TpoTournayApiSuspendedOperation;
    procedure Del(aOperation: TpoTournayApiSuspendedOperation);
    function SearchByType(aType: TTypeTournayApiSuspendedOperation): TpoTournayApiSuspendedOperation;
    //
    destructor Destroy; override;
  end;

  TpoHandAndRakesSuspendedOperationList = class;

  TpoHandAndRakesSuspendedOperation = class
  private
    FHandID: Integer;
    FOwner: TpoHandAndRakesSuspendedOperationList;
    FData: TStringList;
    FTypeOperation: TTypeHandAndRakesSuspendedOperation;
    FIsRaked: Boolean;
    procedure SetData(const Value: TStringList);
    procedure SetHandID(const Value: Integer);
    procedure SetTypeOperation(const Value: TTypeHandAndRakesSuspendedOperation);
    procedure SetIsRaked(const Value: Boolean);
  public
    property TypeOperation: TTypeHandAndRakesSuspendedOperation read FTypeOperation write SetTypeOperation;
    property HandID: Integer read FHandID write SetHandID;
    property Data: TStringList read FData write SetData;
    property IsRaked: Boolean read FIsRaked write SetIsRaked;
    // read only
    property Owner: TpoHandAndRakesSuspendedOperationList read FOwner;
    //
    function GetXMLAsString: string;
    //
    constructor Create(aOwner: TpoHandAndRakesSuspendedOperationList);
    destructor Destroy; override;
  end;

  TpoHandAndRakesSuspendedOperationList = class(TobjectList)
  private
    function GetItems(nIndex: Integer): TpoHandAndRakesSuspendedOperation;
  public
    property Items[nIndex: Integer]: TpoHandAndRakesSuspendedOperation read GetItems;
    //
    function Add(aType: TTypeHandAndRakesSuspendedOperation;
      nHandID: Integer; sData: string; IsRaked: Boolean = False; sComment: string = ''
    ): TpoHandAndRakesSuspendedOperation;
    procedure Del(aOperation: TpoHandAndRakesSuspendedOperation);
    function SearchByType(aType: TTypeHandAndRakesSuspendedOperation): TpoHandAndRakesSuspendedOperation;
    //
    constructor Create;
    destructor Destroy; override;
  end;

  TpoMoreChipsSuspendedOperationList = class;

  TpoMoreChipsSuspendedOperation = class
  private
    FOwner: TpoMoreChipsSuspendedOperationList;
    FUserID: Integer;
    procedure SetUserID(const Value: Integer);
  public
    property UserID: Integer read FUserID write SetUserID;
    // read only
    property Owner: TpoMoreChipsSuspendedOperationList read FOwner;
    //
    constructor Create(aOwner: TpoMoreChipsSuspendedOperationList);
    destructor Destroy; override;
  end;

  TpoMoreChipsSuspendedOperationList = class(TobjectList)
  private
    function GetItems(nIndex: Integer): TpoMoreChipsSuspendedOperation;
  public
    property Items[nIndex: Integer]: TpoMoreChipsSuspendedOperation read GetItems;
    //
    function Add(nUserID: Integer): TpoMoreChipsSuspendedOperation;
    procedure Del(aOperation: TpoMoreChipsSuspendedOperation);
    function SearchByUserID(nUserID: Integer): TpoMoreChipsSuspendedOperation;
    //
    constructor Create;
    destructor Destroy; override;
  end;




////////////////////////////////////////////////////////////////////////////////
// TpoBasicGameEngine:
////////////////////////////////////////////////////////////////////////////////
  TResponseBroadcasting = (
    RB_REQUESTER,
    RB_HAND_PARTICIPANTS,
    RB_TABLE,
    RB_ALL
  );

  TpoBasicGameEngine = class(TComponent)
  private
    FUpdateactivePlayer: Boolean;
    FProcessID: Integer;
    FEngineID: Integer;
    FCurrencyID: Integer;
    FCurrencyTypeID: Integer;
    FCurrencySymbol: String;
    FCurrencyName: String;
    FProcessName: String;
    FGroupID: Integer;
    FTournamentID: Integer;
    FEngineStateID: Integer;
    FEngineResetMode: Boolean;
    FPassword: string;
    FIsWatchingAllowed: Boolean;
    FProtectedMode: Integer;
    FIsHighlighted: Integer;
    procedure SetProcessID(const Value: Integer);
    procedure SetEngineID(const Value: Integer);
    procedure SetCurrencyID(const Value: Integer);
    procedure SetCurrencyName(const Value: String);
    procedure SetCurrencySymbol(const Value: String);
    procedure SetCurrencyTypeID(const Value: Integer);
    procedure SetProcessName(const Value: String);
    procedure SetGroupID(const Value: Integer);
    function GetTournamentType: TpoTournamentType;
    procedure SetCroupier(const Value: TpoGenericCroupier);
    function GetMandatoryAnte: Integer;
    procedure SetMandatoryAnte(const Value: Integer);
    function GetTableStake: Integer;
    procedure SetTableStake(const Value: Integer);
    procedure SetTournamentID(const Value: Integer);
    function GetTournamentBuyIn: Integer;
    function GetTournamentChips: Integer;
    function GetTournamentFee: Integer;
    procedure SetEngineResetMode(const Value: Boolean);
    function FormatAmount(nAmount: Integer;
      nCurrencyCode: Integer): String;
    function GetDefAmountConstraint: Currency;
    function GetMaxAmountConstraint: Currency;
    function GetMinAmountConstraint: Currency;
    function GetUseAmountConstraint: Boolean;
    procedure SetStatses(const Value: string);
    // for recinsile affiliate rakes
    function AddingAffiliateFeeNodesAsString(TotalFee: Integer): string;
    //
    function GetTournamentBaseFirstPlace: Currency;
    function GetTournamentBasePaymentType: TpoTournamentPaymentType;
    function GetTournamentBaseSecondPlace: Currency;
    function GetTournamentBaseThirdPlace: Currency;
    function GetTournamentBonusFirstPlace: Currency;
    function GetTournamentBonusPaymentType: TpoTournamentPaymentType;
    function GetTournamentBonusSecondPlace: Currency;
    function GetTournamentBonusThirdPlace: Currency;
    function GetTournamentUseBasePrizes: Boolean;
    function GetTournamentUseBonusPrizes: Boolean;
    { remove all timeoutactivity reminders }
    procedure DeleteAllCheckOnTimeOutReminders;
    { Bots private functions }
    function GetBotsData(aTempGamers: TpoGamers): Integer;
    function GetBotsTimeOutAnswer(aAction: TpoGamerAction; nInitial: Integer = 0): Integer;
    procedure SetPassword(const Value: string);
    procedure SetIsWatchingAllowed(const Value: Boolean);
  protected
  //----------------------------------------------------------------------------
  // Scheduler
  //----------------------------------------------------------------------------
    FCheckTimeOutActivity : String;
    FLastTimeActivity: TDateTime;
  protected
    //reusable packets
    FActionDoc: IXMLDocument;
    FResponseDoc: IXMLDocument;
    FResponseRoot: IXMLNode;

    //packets encoding/decoding and navigation
    function GetTopParent(aNode: IXMLNode): IXMLNode;
    function GetRootNode(sPacket: string): IXMLNode;

    //returs action node
    function PrepareOutputPacket(nBroadcastTo: TResponseBroadcasting; bIncludeRequester: Boolean):IXMLNode;
    function PrepareOutputPacketTournamentEvent(BroadcastTo: TResponseBroadcasting; EventName, Msg: string; ActionDispatcherID, nDuration: Integer):IXMLNode;
    //parts
    function PreparePotPartsPacket(aParent: IXMLNode): IXMLNode;

    function PrepareChairsPacket(
      aParent: IXMLNode; nTargetSessionID: Integer): IXMLNode;

    function PrepareBusyOnSitDownPacket(aParent: IXMLNode;
      nPosition, nUserID: Integer): IXMLNode;

    function PrepareSetActivePlayerPacket(
      aParent: IXMLNode; nTargetSessionID: Integer): IXMLNode;

    //aggregate packets
    function PrepareCheckEnterPacket(aParent: IXMLNode; nPassword, nInvited, nLimited: Integer): IXMLNode;
    function PrepareProcInitPacket(aParent: IXMLNode): IXMLNode;
    function PrepareProcStatePacket(aParent: IXMLNode; nTargetSessionID: Integer): IXMLNode;
    function PreparePushingContentPacket(aParent: IXMLNode): IXMLNode;

    function PrepareChairStatusPacket(
      aParent: IXMLNode; nPositionID: Integer; sLeftUserName: String;
      bIssueChatPackets: Boolean = True; nPersonificationSessionID: Integer = 0
    ): IXMLNode;

    function PrepareMoveBetsPacket(aParent: IXMLNode; sContext: String): IXMLNOde;

    function PrepareFinishRoundPacket(aParent: IXMLNode): IXMLNOde;

    function PrepareFinalPotPacket(aParent: IXMLNode; nPotID: Integer; sContext: String): IXMLNode;
    function PrepareFinishHandPacket(aParent: IXMLNode; sContext: String): IXMLNode;
    function PrepareDrinksPacket(aParent: IXMLNode; sName: string; nPosition, nID: Integer): IXMLNode;
    function PrepareDrinksChairsPacket(aParent: IXMLNode): IXMLNode;

    function PrepareChatPacket(
      aParent: IXMLNode;
      sMsg: String;
      nSource: TpoMessageOriginator = MO_DEALER;
      nPriority: Integer = 0;
      nUserID: Integer = UNDEFINED_USER_ID
    ): IXMLNode;

    function PrepareShowCardsPacket(aParent: IXMLNode; aGamer: TpoGamer): IXMLNOde;
    function PrepareTurnCardsOverPacket(aParent: IXMLNode; aGamer: TpoGamer): IXMLNode;

    function PrepareMuckPacket(aParent: IXMLNode; aGamer: TpoGamer): IXMLNOde;
    function PrepareDontShowCardsPacket(aParent: IXMLNode; aGamer: TpoGamer): IXMLNOde;
    function PrepareSitOutPacket(aParent: IXMLNode; aGamer: TpoGamer): IXMLNOde;
    function PrepareLeaveTablePacket(aParent: IXMLNode; aGamer: TpoGamer): IXMLNOde;
    function PrepareProcClosePacket(aParent: IXMLNode; sReason: String): IXMLNOde;

    function PrepareStatsPacket(aParent: IXMLNode; bIncludeModifiedOnly: Boolean): IXMLNode;

    //generic
    function PrepareGamerActionPacket(
      aParent: IXMLNode; aGamer: TpoGamer; nAction: TpoGamerAction
    ): IXMLNOde; overload;

    function PrepareGamerActionPacket(
      aParent: IXMLNode; aGamer: TpoGamer; nAction: TpoGamerAction; nStake: Integer
    ): IXMLNOde; overload;

    function PrepareGamerActionPacket(
      aParent: IXMLNode; aGamer: TpoGamer; nAction: TpoGamerAction; nPostStake, nPostDeadStake: Integer
    ): IXMLNOde; overload;


    //return top-parent node
    function PrepareSchedulerPacket(sActionName: string): IXMLNode;
    function PrepareSchedulerPacketEx(sReminderTemplate, sTargetSubsystemName: string; aAction: IXMLNode): IXMLNode;

    function PrepareDealCardsPacket(aParent: IXMLNode; nTargetSessionID: Integer; nRoundID: Integer; bOnStartRound: Boolean): IXMLNOde;
    function PrepareGamerRankingPacket(aParent: IXMLNode; aGamer: TpoGamer): IXMLNode;
    function PrepareMoreChipsPacket(aParent: IXMLNode; aGamer: TpoGamer): IXMLNOde;
    function PrepareGamerPopUpPacket(
      aParent: IXMLNode; sCaption: String; aGamer: TpoGamer; sText: String; nType: Integer
    ): IXMLNOde;

    //service packet
    function PrepareServiceStatePacket(): String;

    //waiting list
    function PrepareWLTakePlacePacket(nTimeOut: Integer = GT_GAMER_RESERVATION_TIMEOUT): IXMLNode;
    function PrepareWLCancelPacket(): IXMLNode;

    //tournaments
    function PrepareFinishTournamentHandPacket(aParent: IXMLNode; vInfo: Variant): IXMLNode;
    function PrepareSTTournamentReservationPacket(aParent: IXMLNode; aGAmer: TpoGamer): IXMLNode;
    function PrepareSTTournamentUnreservationPacket(aGAmer: TpoGamer): string;
    function PrepareSTTournamentPrizePacket: string;
    function PrepareSTTournamentUserRakes: string;

  protected
    procedure CheckForTournament(sAnchor: string);

  //----------------------------------------------------------------------------
  //persistence and stats
  //----------------------------------------------------------------------------
  protected
    FStateID: Integer;
    FStateManager: TpoApiStateManager;
    FStatses: string;
    procedure CreateState();
    procedure RollbackState();
    procedure PopulateGameStats();
    procedure UpdateGameStats(); overload;
    procedure UpdateGameStats(var sStatses: string); overload;
    function UpdateParticipantInfo(nSessionID, nUserIDAttr: Integer; bNeedUpdateFromDB: Boolean): TpoGamer; overload;
    function UpdateParticipantInfo(aGamer: TpoGamer; bNeedUpdateFromDB: Boolean): TpoGamer; overload;
    function CheckAndHandleReservations(): Boolean; virtual;
    //
    procedure DumpCachedStateToFile(sState: string; bOnExcept: Boolean = true);
    procedure OnDumpCachedStateToFile;
    procedure StoreStateAsCached;
  //published for unit test purposes
  public
    property Statses: string read FStatses write SetStatses;
    function Setup(LogFile: WideString; const Api: TApi): Integer;

    procedure LoadState(nProcessID: Integer); overload;
    procedure LoadState(StrState: string); overload;

    procedure StoreState(); overload;
    procedure StoreState(var StrState: string; var StrServiceState: string); overload;

  //----------------------------------------------------------------------------
  // Interface to subsystems
  //----------------------------------------------------------------------------
  //connectors
{$IFDEF __TESTGE__}
  public
    FApi: TApi;
{$ELSE}
  protected
    FApi: TApi;
{$ENDIF}
  protected
    procedure SetupCroupier(aCroupier: TpoGenericCroupier); virtual;

  protected
  //messaging
    FMessageList: TpoMessageList;
    procedure PushResponse(sRespGroup: string; nSessionID: Integer; sMsgBody: String;
      nUserID: Integer = UNDEFINED_USER_ID; bIncludeRequester: Boolean = True);
    procedure SendResponse(sRespGroup: string; nSessionID: Integer; sMsgBody: String;
      nUserID: Integer = UNDEFINED_USER_ID; bIncludeRequester: Boolean = True);
    function DispatchQueuedMessage(aMsg: TpoMessage): TpoMessage;
    function FlushResponseQueue: Integer;
    procedure HandleCachedPackets(); virtual;
    procedure PostProcessGamerActionExpired(aGamer: TpoGamer); virtual;

  //History
{$IFDEF __TESTGE__}
  public
    FHistoryList: TpoMessageList;
{$ELSE}
  protected
    FHistoryList: TpoMessageList;
{$ENDIF}

  protected
    procedure PushHistoryEntry(nsessionID: Integer; NodeBody: IXMLNode);
    procedure SendHistories(sBody: String);
    function FlushHistoryQueue: Integer;

  protected
  //sync
    HSemaphore: THandle;
    FMutex: THandle;
    procedure __lock__();
    procedure __unlock__();

  //----------------------------------------------------------------------------
  // Engine core:
  //----------------------------------------------------------------------------
  protected
    FApiSuspendedOperations: TpoApiSuspendedOperationList;
    FApiHandAndRakesSuspendedOperations: TpoHandAndRakesSuspendedOperationList;

    FProperties: TGameProperties;
    FActions, FSubActions: TpoGameActions;
    FStats: TpoGameStats;
    FTable: TpoTable;
    FCroupier: TpoGenericCroupier;
    FReminders: TpoReminders;
    FDeposits: TpoGamerDeposits;

    FActionActivation: TDateTime;

    procedure ReCreateResponceDocument;
    //
    function ProcessActionPrim(
      var aGaActions: IXMLNode;
      sHost: String; nID, nUserIDAttr: Integer
    ): Integer; virtual;

  //----------------------------------------------------------------------------
  // Propritary Engine stuff:
  //----------------------------------------------------------------------------
  protected
    procedure SpecifyProcessAttributes(); virtual;

  //feedback form functions
    function DispatchResponse(
      nFromSessionID: Integer;
      aResponseInfo: IXMLNode;
      bInstantPost: Boolean = False;
      nUserID: Integer = UNDEFINED_USER_ID
    ): Boolean; virtual;

    function DispatchException(
      aException: Exception;
      bInstantPost: Boolean
    ): Boolean; virtual;

  //game engine generic functionality
  //!!should be overriden stuff!!
    //construction time initiators
    procedure InitGameProperties(); virtual;
    procedure InitGameActions(); virtual;

    //stats (can rely on established properties)
    procedure InitGameStats(); virtual;
    procedure RecalculateStats(); virtual;

    procedure InitRakeRules;

    //final item in init game sequence
    //logic switches based upon established properties
    procedure MakeInitialGameArrangements(); virtual;

    //proprietary persistence
		function Load(aReader: TReader): Boolean; virtual;
		function Store(aWriter: TWriter): Boolean; virtual;

  //----------------------------------------------------------------------------
  // packet handlers
  //----------------------------------------------------------------------------
  protected
    function HandleDummy(nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
    function HandleCheckEnter(nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
    function HandleProcInit(nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
    function HandleProcState(nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
    function HandleChat(nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
    function HandleEventGamerActionExpired(nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
    function HandleEventBotActionExpired(nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
    function HandleChatAllow(nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
    function HandleGetDefaultProperty(nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
    function HandleSetDefaultProperty(nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
    function HandleDrinks(nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode):  IXMLNode;

    function CheckActionAgainstHandContext(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode; bValidForRunningHand, bValidateStepRight: Boolean
    ): TpoGamer;
    function CheckActionOnHandIDContext(nSessionID: Integer; aActionInfo: IXMLNode): Boolean;

    function GetActionGamer(
      nSessionID, nUserIDAttr: Integer; bValidateStepRight, bNeedUpdateFromDB: Boolean
    ): TpoGamer;

    procedure OnChatMessage(sMsg: String; sTitle: String = ''; aGamer: TpoGamer =
        nil; nOriginator: TpoMessageOriginator = MO_DEALER; nPriority: Integer = 0);

    procedure OnGamerAction(aGamer: TpoGamer; nAction: TpoGamerAction; vInfo: Array
        of Variant);

    function OnBotSetActivePlayer(aGamer: TpoGamer; XMLSetActivePlayer: IXMLNode;
      var nBotStake, nBotDead: Integer): TpoGamerAction;
  //----------------------------------------------------------------------------
  //properties
  //----------------------------------------------------------------------------
  public
    //scalar
    property EngineID: Integer read FEngineID write SetEngineID;
    property ProcessID: Integer read FProcessID write SetProcessID;
    property GroupID: Integer read FGroupID write SetGroupID;
    property TournamentID: Integer read FTournamentID write SetTournamentID;
    property ProcessName: String read FProcessName write SetProcessName;
    property CurrencyID: Integer read FCurrencyID write SetCurrencyID;
    property CurrencyTypeID: Integer read FCurrencyTypeID write SetCurrencyTypeID;
    property CurrencyName: String read FCurrencyName write SetCurrencyName;
    property CurrencySymbol: String read FCurrencySymbol write SetCurrencySymbol;
    property Password: string read FPassword write SetPassword;
    property IsWatchingAllowed: Boolean read FIsWatchingAllowed write SetIsWatchingAllowed;
    property EngineResetMode: Boolean read FEngineResetMode write SetEngineResetMode;
    property ProtectedMode: Integer read FProtectedMode;
    property IsHighlighted: Integer read FIsHighlighted;

    //aggregate
    property GameProperties: TGameProperties read FProperties;
    property Table: TpoTable read FTable;
    property Croupier: TpoGenericCroupier read FCroupier write SetCroupier;
    property TournamentType: TpoTournamentType read GetTournamentType;
    property MandatoryAnte: Integer read GetMandatoryAnte write SetMandatoryAnte;
    property TableStake: Integer read GetTableStake write SetTableStake;
    property UseAmountConstraint: Boolean read GetUseAmountConstraint;
    property MinAmountConstraint: Currency read GetMinAmountConstraint;
    property MaxAmountConstraint: Currency read GetMaxAmountConstraint;
    property DefAmountConstraint: Currency read GetDefAmountConstraint;
    //
    property TournamentBuyIn: Integer read GetTournamentBuyIn;
    property TournamentFee: Integer read GetTournamentFee;
    property TournamentChips: Integer read GetTournamentChips;
    // Quick Search BS
    property TournamentUseBasePrizes: Boolean read GetTournamentUseBasePrizes;
    property TournamentBasePaymentType: TpoTournamentPaymentType read GetTournamentBasePaymentType;
    property TournamentBaseFirstPlace: Currency read GetTournamentBaseFirstPlace;
    property TournamentBaseSecondPlace: Currency read GetTournamentBaseSecondPlace;
    property TournamentBaseThirdPlace: Currency read GetTournamentBaseThirdPlace;
    //
    property TournamentUseBonusPrizes: Boolean read GetTournamentUseBonusPrizes;
    property TournamentBonusPaymentType: TpoTournamentPaymentType read GetTournamentBonusPaymentType;
    property TournamentBonusFirstPlace: Currency read GetTournamentBonusFirstPlace;
    property TournamentBonusSecondPlace: Currency read GetTournamentBonusSecondPlace;
    property TournamentBonusThirdPlace: Currency read GetTournamentBonusThirdPlace;

  //----------------------------------------------------------------------------
  // Pluggable engine API:
  //----------------------------------------------------------------------------
    function GetDefaultEngineProperties(
      var PropXML: string; var Reason: string;
      nGameType: Integer = 0;
      nTournamentType: Integer = 0
    ): Integer; virtual;

    //absolete; reserved
    function GetProcessInfo(var InfoXML, Reason: String): Integer; virtual;

     //sState param is for test purposes
    procedure SendProcClosePacketToALL;
    function InitGameProcess(
      ProcessID: Integer; const InitXML: String;
      var Reason: String
    ): Integer; virtual;

    //absolete; reserved
    function ProcessEvent(
      EventID: Integer; const EventXML: String;
      var Reason: String
    ): Integer; virtual;

    function Get_AboutGE: WideString; virtual;
    function Get_Version: Single; virtual;

  //IBGE2
    function GetContext(var StrState: string; var StrServiceState: string;
      var sReason: String): Integer;

    function ProcessActions(
      const nProcessID: Integer;
      const sInActions: String;
      var sOutActions: String;
      var sReason: String
    ): Integer;

    function SetContext(var StrState: string; var sReason: String): Integer;
    function UpdateProcState(): Integer;


  //----------------------------------------------------------------------------
  //utils
  //----------------------------------------------------------------------------
  //scheduler:
    function ScheduleSecInterval(
      nSessionID, nInterval: Integer; sActionName: String
    ): TpoReminder;

    function ScheduleSecIntervalEx(
      sReminderTemplate, sTargetSubsystemName: String; nInterval: Integer;
      aAction: IXMLNode; NeedAddingToList: Boolean
    ): TpoReminder;

    function RescheduleSecInterval(
      sReminderID: string;
      nInterval: Integer
    ): TpoReminder;

    // Return value - reminder was found
    function DeleteInterval(sReminderID: string): Boolean;
    function DeleteIntervalByUserIDAndName(nUserID: Integer; sRemindName: string = ''): Boolean;
    procedure DeleteAllRemindersOnFree;
    procedure CreateAllRemindersOnLoad;
    //

    function SetupGamerActionTimeout(
      aGamer: TpoGamer; nActions: TpoGamerActions;
      nTimeout: Integer = GT_GAMER_ACTION_TIMEOUT;
      bRegular: Boolean = True
    ): TpoReminder;

    function SetupBotActionTimeout(aGamer: TpoGamer;
      nAction: TpoGamerAction; nStake, nMaxStake, nDead, nTag: Integer;
      nTimeout: Integer = GT_GAMER_ACTION_TIMEOUT; bRegular: Boolean = True
    ): TpoReminder;

    function SetupBotsSitDownForMiniTournayActionTimeout(nTypeBots, nBotsCount, nTimeOut: Integer): TpoReminder;

    procedure DeleteGamerActionTimeout(
      aGamer: TpoGamer; nAction: TpoGamerAction
    );

    procedure DeleteBotActionTimeout(
      aGamer: TpoGamer; nAction: TpoGamerAction
    );

    function SetupGamerReservationTimeout(
      nChairID, nUserID, nSessionID: Integer; nTimeout: Integer = GT_GAMER_RESERVATION_TIMEOUT
    ): TpoReminder;

    procedure DeleteGamerReservationTimeout(aGamer: TpoGamer); overload;
    procedure DeleteGamerReservationTimeout(nUserID: Integer); overload;

  //convertors
    function ActionNameToGamerAction(sName: string): TpoGamerAction;
    function GamerActionToActionName(nAction: TpoGamerAction): String;

    function AutoActionNameToGamerAutoAction(sName: string): TpoGamerAutoAction;
    function GamerAutoActionToAutoActionName(nAutoAction: TpoGamerAutoAction): String;

  //generic
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;

  end;//TpoBasicGameEngine


////////////////////////////////////////////////////////////////////////////////
// TpoBasicPokerGameEngine
////////////////////////////////////////////////////////////////////////////////
type
  TpoGenericPokerGameEngine = class(TpoBasicGameEngine)
  private
  protected
    function DispatchGamerActionResponse(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode; bValidateStepRight: Boolean;
      bAddPosition: Boolean = True;
      bAddStakesAndBalance: Boolean = False;
      nStakeAmount: Integer = 0;
      bNotifyRequesterOnly: Boolean = False
    ): TpoGamer;

  //---------------------------------------------------------------------------
  // Engine core:
  //----------------------------------------------------------------------------
  protected
    FStartHandReminderID  : String;
    FGamerActionReminderID: String;
    FExposeCardDeals      : Boolean;
    FExposedCardRoundID   : Integer;
    FExposedCardsOnRoundStart: Boolean;
    FExposeMoveBets       : Boolean;
    FMOveBetsContext      : string;
    FOnFinishRoundPacket  : Boolean;
    FExposeRanking        : Boolean;
    FOpenRoundGamerMessage: String;

    procedure PrepareAndDispatchReorderedPackets(aGamer: TpoGamer);
    function RetrieveStake(aActionInfo: IXMLNode; aGamer: TpoGamer; nGameraction: TpoGameraction): Integer;
    procedure SetupCroupier(aCroupier: TpoGenericCroupier); override;
    function DecodeTournamentParticipants(var nCnt: Integer; aGamers: IXMLNode; sNodeName: string = ''): Variant;
    function CheckAndHandleReservations(): Boolean; override;
    procedure PostProcessGamerActionExpired(aGamer: TpoGamer); override;

  protected
    FMoreChipsSuspendedOperations: TpoMoreChipsSuspendedOperationList;
    FTournayApiSuspendedOperations: TpoTournayApiSuspendedOperationList;
    //
    FReInitSingeleTableTournament: Boolean;
    procedure HandleCachedPackets(); override;

  //----------------------------------------------------------------------------
  // packet handlers
  //----------------------------------------------------------------------------
  protected
    //gamer actions
    //sit managements

    function HandleActionSitDown(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleActionLeaveTable(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleActionSitOut(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleActionBack(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleActionSitOutNextHand(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleActionWaitBB(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

  //accounting
    function HandleActionCheck(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleActionPostSB(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleActionPostBB(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleActionCall(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleActionRaise(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleActionBet(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleActionPost(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleActionPostDead(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleActionAnte(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleActionBringIn(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleActionFold(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    //Showdown stage actions
    function HandleActionShowCards(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleActionShowCardsShuffled(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleActionDontShowCards(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleActionMuck(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleMoreChips(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    //recovery
    function HandleFinishTable(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    //gamer autoactions
    function HandleGamerAutoAction(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    //gamer status
    function HandleSetParticipantAsLoggedIn(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleGamerDisconnect(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleGamerReconnect(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    //waiting list
    function HandleWLDecline(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;
    function HandleWLDeclineOnDisconnect(nSessionID, nUserID: Integer): Boolean;

    //reminders
    function HandleEventStartHand(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleCheckTimeOutActivity(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleEventGamerReservationExpired(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleUseTimeBank(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    //tournament actions
    function HandleTournamentActionInit(
      nTournamentID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleTournamentActionPlay(
      nTournamentID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleTournamentActionBreak(
      nTournamentID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleTournamentActionResume(
      nTournamentID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleTournamentActionEvent(
      nTournamentID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleTournamentActionEnd(
      nTournamentID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleTournamentActionFree(
      nTournamentID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleTournamentCloseTable(
      nTournamentID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleTournamentChangePlace(
      nTournamentID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleTournamentStandUpToWatcher(
      nTournamentID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleTournamentRebuy(
      nTournamentID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleTournamentKickOffUsers(
      nTournamentID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleKickOffUser(nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;

    function HandleGALeaveTable(nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;

    // Bots actions
    function HandleActionBotsSitDown(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleActionBotsStandupAll(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleActionBotStandup(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleActionBotPolicy(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

    function HandleActionBotGetTableInfo(
      nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
    ): IXMLNode;

  // additional procedures
  protected
    procedure CheckTimeOutActivityForSingleTournay(nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode);
    procedure CheckTimeOutActivityForNotTournay(nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode);

  //----------------------------------------------------------------------------
  // Engine overriden stuff
  //----------------------------------------------------------------------------
  protected
    procedure InitGameProperties(); override;
    procedure InitGameActions(); override;
    procedure InitGameStats(); override;
    procedure RecalculateStats(); override;

    //
		function Load(aReader: TReader): Boolean; override;
		function Store(aWriter: TWriter): Boolean; override;

  protected
    //hand
    procedure OnHandFinish(sContext: String);
    procedure OnHandStarting(aSender: TObject; vTimeoutInfo: Variant);
    procedure OnHandStarted(aSender: TObject; vInfo: Variant);
    procedure OnAbandonHandStarting(aSender: TObject);
    procedure OnHandStart(aSender: TObject);
    procedure OnSetActivePlayer(Sender: TObject);

    //round context
    procedure OnDealCards(aSender: TObject; vInfo: Variant);
    procedure OnMoveBets(sContext: String);
    procedure OnRoundFinish(aSender: TObject);

    //Showdown
    procedure OnShowCards(aGamer: TpoGamer);
    procedure OnMuck(aGamer: TpoGamer);
    procedure OnDontShowCards(aGamer: TpoGamer);
    procedure OnSitOut(aGamer: TpoGamer);
    procedure OnLeaveTable(aGamer: TpoGamer);
    procedure OnGamerSitOut(aGamer: TpoGamer);
    procedure OnGamerBack(aGamer: TpoGamer);

    //chips
    procedure DealMoreChips(nUserID: Integer);
    procedure DealMoreChipsForMultiTournament(nUserID: Integer);
    procedure OnMoreChips(aGamer: TpoGamer);

    //player
    procedure OnChairStateChange(aSender: TObject; vInfo: Variant);
    procedure OnRanking(aSender: TObject);
    procedure OnOpenRoundGamer(sMsg: String);

    procedure OnGamerKickOff(aGamer: TpoGamer; sMsg: string);
    procedure OnGamerLeaveTable(aGAmer: TpoGamer);

    //account operation (reserve tracking during hand)
    procedure OnHandReconcileOperation(
      nHandID: Integer; aGamer: TpoGamer; sOpCode: String; nAmount: Integer;
      sComment: String = ''
    );

    procedure OnUpdateGamerDetails(aGamer: TpoGamer);

    //service
    procedure OnGamerPopUp(
      aGamer: TpoGamer;
      sCaption: String;
      sText: String;
      nType: Integer = 0
    );

    procedure OnProcCloseAction(sMsg: String);

    procedure OnChangeGamersCount(Sender: TObject);
    procedure OnPotReconcileFinish(nPotID: Integer; sContext: String);

    function OnCheckGamerAllins(aGamer: TpoGamer): Boolean;

    //tournament
    procedure OnTournamentHandFinish(aSender: TObject; vInfo: Variant);
    procedure OnSingleTableTournamentStart(aSender: TObject);
    procedure OnSingleTableTournamentFinish(aSender: TObject);
    procedure OnSingleTableTournamentFinishForBots(aSender: TObject);
    procedure OnPrepareReorderedPackets(aGamer: TpoGamer);
    procedure OnMultyTournamentProcState(aGamer: TpoGamer);

  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;

  end;//TpoGenericPokerGameEngine



////////////////////////////////////////////////////////////////////////////////
// Proprietary Fame Actions
////////////////////////////////////////////////////////////////////////////////
type
  TpoPokerProcInitAction = class(TpoGameAction)
  public
  end;//TpoPokerProcInitAction

  TpoPokerProcStateAction = class(TpoGameAction)
  end;//TpoPokerProcStateAction

  TpoPokerPlayerStateAction = class(TpoGameAction)
  end;//TpoPokerPlayerStateAction

  TpoPokerPlayerActionAction = class(TpoGameAction)
  end;//TpoPokerPlayerActionAction


////////////////////////////////////////////////////////////////////////////////
implementation

uses
  ActiveX, ComObj, Math, DateUtils, StrUtils
  // po
  , uSessionUtils
  , uCommonDataModule
  , uLogger
  , uObjectPool
  , uBotConstants
  , uBotClasses
  , uResponseProcessor
  , uCardEngine
  ;


////////////////////////////////////////////////////////////////////////////////
// Globals
////////////////////////////////////////////////////////////////////////////////
const
  GENERIC_ENGINE_ACTION_SYNC = 'GENERIC_ENGINE_ACTION_SYNC';

//Engine metrics
const
  GEM_VERSION               = 10;
  GEM_ABOUT_INFO            = 'Version: '+PV_GAME_ENGINE_VERSION;

//poker paket nodes
const
//roots
  PPTN_GAME_ENGINE          = 'gameengine';
//sub-roots
  PPTN_PROPERTIES           = 'properties';
  PPTN_PROPERTY             = 'property';
  PPTN_CONSTRAINT           = 'item';
  PPTN_GAME_ACTION          = 'gaaction';
  PPTN_TOURNAMENT_EVENT     = 'totournamentevent';
  PPTN_RESPONSE_ROOT        = 'object';

//action nodes
  PPTN_CHECK_ENTER          = 'gacheckenter';
  PPTN_PROC_INIT            = 'procinit';
  PPTN_PROC_STATE           = 'procstate';
  PPTN_SET_ACTIVE_PLAYER    = 'setactiveplayer';
  PPTN_PLAYER_ACTION        = 'playeraction';
  PPTN_PUSHING_CONTENT      = 'pushingcontent';

//action packet subnodes nodes
const
  PPTN_VERSION        = 'geversion';
  PPTN_NAME           = 'name';
  PPTN_POKER_TYPE     = 'pokertype';
  PPTN_PLAYER_COUNT   = 'playercount';
  PPTN_CURRENCY_ID    = 'currencyid';
  PPTN_CURRENCY_SIGN  = 'currencysign';
  PPTN_MIN_STAKE      = 'minstake';
  PPTN_MAX_STAKE      = 'maxstake';
  PPTN_STAKE_TYPE     = 'staketype';
  PPTN_ALLIN          = 'allin';
  PPTN_MAX_BUYIN      = 'maxbuyin';
  PPTN_MIN_BUYIN      = 'minbuyin';
  PPTN_DEF_BUYIN      = 'defbuyin';
  PPTN_PROTECTED_MODE = 'protectedmode';
  PPTN_IS_HIGHLIGHTED = 'ishighlighted';


//procstate nodes
  PPTN_POTS           = 'pots';
  PPTN_POT            = 'pot';
  PPTN_COMMUNITY_CARDS= 'communitycards';
  PPTN_RAKE           = 'rake';
  PPTN_CHAIRS         = 'chairs';
  PPTN_CHAIR          = 'chair';
  PPTN_PLAYER         = 'player';
  PPTN_ICON           = 'icon';
//set active player
  PPTN_ACTIONS        = 'actions';
  PPTN_POST_SB        = 'postsb';
  PPTN_POST_BB        = 'postbb';
  PPTN_SIT_OUT        = 'sitout';
  PPTN_ANTE           = 'ante';
  PPTN_WAIT_BB        = 'waitbb';
  PPTN_POST           = 'post';
  PPTN_POST_DEAD      = 'postdead';
  PPTN_FOLD           = 'fold';
  PPTN_CHECK          = 'check';
  PPTN_BET            = 'bet';
  PPTN_CALL           = 'call';
  PPTN_RAISE          = 'raise';
  PPTN_SHOW_CARDS     = 'showcards';
  PPTN_SHOW_CARDS_SHUFFLED  = 'showcardsshuffled';
  PPTN_MUCK           = 'muck';
  PPTN_DONT_SHOW      = 'dontshow';
  PPTN_DISCARD_CARDS  = 'discardcards';
  PPTN_BRING_IN       = 'bringin';

  PPTN_AUTO_ACTION    = 'autoaction';

  PPTN_CHAT           = 'chat';
  PPTN_GAMER_ACTION   = 'action';
  PPTN_TIMER_EVENT    = 'timerevent';
  PPTN_BOT_EVENT      = 'botevent';
  PPTN_DEAL_CARDS     = 'dealcards';
  PPTN_DEAL           = 'deal';
  PPTN_ROUND_FINISH   = 'endround';

  PPTN_MOVE_BETS      = 'movebets';
  PPTN_MOVE_BET       = 'move';
  PPTN_RETURN_BET     = 'returnbet';

  PPTN_FINISH_HAND    = 'finishhand';
  PPTN_WINNER         = 'winner';
  PPTN_IS_TOURNAMENT  = 'istournament';
  PPTN_PROC_CLOSE     = 'procclose';
  PPTN_GAMER_MESSAGE  = 'message';
  PPTN_STAT_ITEM      = 's';
  PPTN_STATS          = 'ss';
  PPTN_PROCESS_ID     = 'processid';
  PPTN_PROCESS        = 'process';
  PPTN_TOURNAMENT_ID  = 'tournamentid';

//debug
  PPTN_DUMMY                    = 'dummy';
//
  PPTN_DATA                     = 'data';
  PPTN_SET_PARTICIPANT_AS_LOGGED = 'gasetparticipantaslogged';
  PPTN_GAMER_DISCONNECT         = 'gadisconnect';
  PPTN_GAMER_RECONNECT          = 'gareconnect';
  PPTN_END_OF_HAND              = 'endofhand';
  PPTN_USER_RAKES               = 'userrakes';
  PPTN_USER                     = 'user';
  PPTN_FEE                      = 'fee';
  PPTN_AFFILIATE_FEE            = 'affiliatefee';
  PPTN_RANKING                  = 'ranking';
  PPTN_TURN_CARDS_OVER          = 'turncardsover';
  PPTN_FINAL_POT                = 'finalpot';
  PPTN_FINISH_TABLE             = 'finishtable';
  PPTN_CHATALLOW                = 'gachatallow';
  PPTN_KICKOFUSER               = 'gakickofuser';
  PPTN_GALEAVETABLE             = 'galeavetable';
  PPTN_GAGETDEFPROP             = 'getdefprop';
  PPTN_GASETDEFPROP             = 'setdefprop';
  PPTN_DRINKS                   = 'drinks';

//tournament
  PPTN_TOURNAMENT               = 'tournament';
  PPTN_TOURNAMENT_ACTION        = 'tournamentaction';
  PPTN_FINISH_TOURNAMENT_HAND   = 'endofhand';
  PPTN_LOST                     = 'lost';
  PPTN_STANDUP                  = 'standup';
  PPTN_REBUY                    = 'rebuy';
  PPTN_KICK_OFF                 = 'kickoff';
  PPTN_SITDOWN                  = 'sitdown';
  PPTN_TAKE_PLACE               = 'wltakeplace';
  PPTN_WL_CANCEL                = 'wlcancel';
  PPTN_WL_DECLINE               = 'wldecline';
  PPTN_ST_TOURNAMENT_RESERVE    = 'singletournamentreserv';
  PPTN_ST_TOURNAMENT_UNRESERVE  = 'singletournamentreserv';
  PPTN_ST_TOURNAMENT_PRIZE      = 'singletournamentprize';
  PPTN_OBJECT                   = 'object';
  PPTN_OBJECTS                  = 'objects';
  PPTN_RANK                     = 'rank';

//Bots
  PPTN_BOT_SITDOWN              = 'bot_sitdown';
  PPTN_BOT_STANDUP_ALL          = 'bot_standup_all';
  PPTN_BOT_STANDUP              = 'bot_standup';
  PPTN_BOT_POLICY               = 'bot_policy';
  PPTN_BOT_GET_TABLE_INFO       = 'bot_gettableinfo';

  PPTA_GAMER_AMOUNT             = 'gameramount';

//poker attributes
const
  PPTA_NAME                 = 'name';
  PPTA_TYPE                 = 'type';
  PPTA_TIME                 = 'time';
  PPTA_PAUSE                = 'pause';
  PPTA_VALUE                = 'value';
  PPTA_ID                   = 'id';
  PPTA_PROCESS_ID           = 'processid';
  PPTA_TIMEOUT              = 'timeout';
  PPTA_PLAYERS_COUNT        = 'playerscount';
  PPTA_PROCESS_NAME         = 'processname';
  PPTA_OBJTYPE              = 'objtype';
  PPTA_ENGINETYPE           = 'enginetype';
  PPTA_GUID                 = 'guid';
  PPTA_SEQ_GAHANDID         = 'seq_gahandid';
  PPTA_SEQ_GAROUND          = 'seq_garound';

  //hand attrs
  PPTA_HAND_ID              = 'handid';
  PPTA_ROUND                = 'round';
  PPTA_PREV_HAND_ID         = 'prevhandid';
  PPTA_MIN_STAKE            = 'minstake';
  PPTA_MAX_STAKE            = 'maxstake';
  PPTA_USE_PASSWORD         = 'usepassword';
  PPTA_PASSWORD             = 'password';
  PPTA_INVITED              = 'invited';
  PPTA_LIMITED              = 'limited';
  PPTA_TABLE_NAME           = 'tablename';
  PPTA_AMOUNT               = 'amount';
  PPTA_RAKE_AMOUNT          = 'rakeamount';
  PPTA_TOTAL_RAKE           = 'totalrake';
  PPTA_POSITION             = 'position';
  PPTA_POT_ID               = 'potid';
  PPTA_STATUS               = 'status';
  PPTA_STATEID              = 'stateid';
  PPTA_LOGINNAME            = 'loginname';
  PPTA_DEALER_FLAG          = 'isdealer';
  PPTA_CITY                 = 'city';
  PPTA_SEX                  = 'sex';
  PPTA_AVATAR_ID            = 'avatarid';
  PPTA_LEVEL_ID             = 'levelid';
  PPTA_USER_IMAGE_VERSION   = 'userimageversion';
  PPTA_BALANCE              = 'balance';
  PPTA_BET                  = 'bet';
  PPTA_CARDS                = 'cards';
  PPTA_LO_CARDS             = 'locards';
  PPTA_IN_GAME              = 'ingame';

//setactiveplayer attributes
  PPTA_STAKE                = 'stake';
  PPTA_ANTE                 = 'ante';
  PPTA_DEAD                 = 'dead';

//chat attrs
//<chat src="[0|1|2]" priority="[0|1|2]" msg="Something..." [userid="12" username="Igor"]/>
  PPTA_SOURCE               = 'src';
  PPTA_PRIORITY             = 'priority';
  PPTA_MSG                  = 'msg';
  PPTA_LO_MSG               = 'lomsg';
  PPTA_USER_ID              = 'userid';
  PPTA_SESSION_ID           = 'sessionid';
  PPTA_USER_NAME            = 'username';
  PPTA_NEW_BALANCE          = 'newbalance';
  PPTA_POSITION_ID          = 'position';
  PPTA_ACTION_SEQ_ID        = 'action_seq_id';
  PPTA_REGULAR_TIMEOUT      = 'regular';

  PPTA_SRC                  = 'src';
  PPTA_RESULT               = 'result';
  PPTA_MONEY                = 'money';
  PPTA_COMMENT              = 'comment';
  PPTA_REASON               = 'reason';
  PPTA_CHAT                 = 'chat';
  PPTA_EVENT                = 'event';
  PPTA_ACTIONDISPATCHERID   = 'actiondispatcherid';
  PPTA_BREAKDURATION        = 'breakduration';
  PPTA_EXCEPTUSERIDS        = 'exceptuserids';
  PPTA_ACTION               = 'action';
  PPTA_CAPTION              = 'title';
  PPTA_TEXT                 = 'text';
  PPTA_MSG_TYPE             = 'type';
  PPTA_MSG_BODY             = 'body';
  PPTA_MESSAGE              = 'message';

//tournament
  PPTA_COMMAND              = 'command';
  PPTA_PLACE                = 'place';
  PPTA_TOURNAMENT_ID        = 'tournamentid';
  PPTA_TOURNAMENT_NAME      = 'tournamentname';
  PPTA_BUYIN                = 'buyin';
  PPTA_RAKE                 = 'rake';
  PPTA_CHIPS                = 'chips';
  PPTA_STARTED              = 'started';
  PPTA_LEVEL                = 'level';
  PPTA_HAND                 = 'hand';
  PPTA_WINNER_CANDIDATES    = 'wc';
  PPTA_IS_TAKED_SIT         = 'istakedsit';

//scheduler
  PPTA_START_HAND           = 'starthand';
  PPTA_TOURNAMENT_FEE       = 'fee';
  PPTA_TOURNAMENT_PRIZE     = 'prize';
  PPTA_TOURNAMENT_BONUSPRIZE= 'bonusprize';
  PPTA_TOURNAMENT_FINISH_STAMP =  'handfinishstamp';
  PPTA_TOURNAMENT_STACK     = 'stack';
  PPTA_BALANCE_BEFORE_HAND  = 'ballancebeforehand';
  PPTA_COUNT_OF_PLACES      = 'countofplaces';
  PPTA_IS_RAKED             = 'israked';
  PPTA_TURN_TIMEOUT         = 'turntime';
  PPTA_TIMEBANK             = 'timebank';
  PPTA_HI_RANK              = 'hirank';
  PPTA_LO_RANK              = 'lorank';
  PPTA_HI_RANK_CARDS        = 'hicards';
  PPTA_LO_RANK_CARDS        = 'locards';
  PPTA_SEQ_ID               = 'seq_id';
  PPTA_HOST                 = 'host';
  PPTA_ICON                 = 'icon';

//Bots
  PPTA_MAX_PER_PROCESS      = 'maxnumberperprocess';
  PPTA_IS_BOT               = 'isbot';
  PPTA_BOT_ID               = 'botid';
  PPTA_BOT_BLAFFERS         = 'botblaffers';
  PPTA_BOT_CHARACTER        = 'botcharacter';
  PPTA_LOGIN_NAME           = 'loginname';
  PPTA_SEX_ID               = 'sexid';
  PPTA_LOCATION             = 'location';

//gamer action selector
const
  PPTV_POST_SB              =  'postsb';
  PPTV_POST_BB              =  'postbb';
  PPTV_SIT_OUT              =  'sitout';
  PPTV_ANTE                 =  'ante';
  PPTV_BRING_IN             =  'bringin';
  PPTV_WAIT_BB              =  'waitbb';
  PPTV_POST                 =  'post';
  PPTV_POST_DEAD            =  'postdead';
  PPTV_FOLD                 =  'fold';
  PPTV_CHECK                =  'check';
  PPTV_BET                  =  'bet';
  PPTV_CALL                 =  'call';
  PPTV_RAISE                =  'raise';
  PPTV_SHOW_CARDS           =  'showcards';
  PPTV_SHOW_CARDS_SHUFFLED  =  'showcardsshuffled';
  PPTV_MUCK                 =  'muck';
  PPTV_DONT_SHOW            =  'dontshow';
  PPTV_DISCARD_CARDS        =  'discardcards';
  PPTV_LEAVE_TABLE          =  'leavetable';
  PPTV_SIT_DOWN             =  'sitdown';
  PPTV_BUSY_ON_SIT_DOWN     =  'busyonsitdown';
  PPTV_SIT_OUT_NEXT_HAND    =  'sitoutnexthand';
  PPTV_BACK                 =  'back';
  PPTV_MORE_CHIPS           =  'morechips';
  PPTV_TURN_CARDS_OVER      =  'turncardsover';
  PPTV_ALL_IN               =  'allin';
  PPTV_USE_TIMEBANK         =  'usetimebank';
  PPTV_NONE                 =  'none';

//gamer auto action selector
  PPTV_AUTO_FOLD            =  'fold';
  PPTV_AUTO_CHECK           =  'check';
  PPTV_CHECK_OR_FOLD        =  'fold,check';
  PPTV_CHECK_OR_CALL        =  'call,check';
  PPTV_AUTO_BET             =  'bet';
  PPTV_AUTO_RAISE           =  'raise';
  PPTV_AUTO_CALL            =  'call';
  PPTV_BET_OR_RAISE         =  'bet,raise';

  PPTV_POST_BLINDS          =  'postblind';
  PPTV_POST_ANTE            =  'postante';
  PPTV_MUCK_LOSING_HANDS    =  'muck';
  PPTV_SITOUT_NEXT_HAND     =  'sitoutnexthand'; //reserved
  PPTV_AUTO_WAIT_BB         =   PPTV_WAIT_BB;

  PPTV_AUTO_LEAVE_TABLE     =  'leavetable';

//reminders
  PPTV_START_HAND           = 'starthand';
  PPTV_CHECK_TIMEOUT_ACTIVITY = 'checktimeoutactivity';
  PPTV_GAMER_ACTION         = 'gameraction';
  PPTV_GAMER_RESERVATION    = 'gamerreservation';

//winner packets
  PPTV_RESULT_WINNER        = 'w';
  PPTV_RESULT_LOSER         = 'l';

//tournament action selectors
  PPTV_INIT                 = 'init';
  PPTV_PLAY                 = 'play';
  PPTV_BREAK                = 'break';
  PPTV_RESUME               = 'resume';
  PPTV_EVENT                = 'event';
  PPTV_END                  = 'end';
  PPTV_FREE                 = 'free';
  PPTV_CLOSE_TABLE          = 'closetable';
  PPTV_CHANGE_PLACE         = 'changeplace';
  PPTV_STANDUP              = 'standup';
  PPTV_REBUY                = 'rebuy';
  PPTV_KICK_OFF_USERS       = 'kickoffusers';

//command dispatcher
  PPTV_CD_NAME              = 'name';
  PPTV_CD_COMMAND           = 'command';
  PPTV_PROCESS              = 'process';

//service attributes
//response broadcasting options
const
  PPTA_RESPONSE_GROUP       = 'rsp_group';
  PPTA_SEND_TO_REQUESTER    = 'send_to_rq';
  PPTV_REQUESTER            = 'requester';  //just requester
  PPTV_HAND_PARTICIPANTS    = 'hand';       //just gamers
  PPTV_TABLE                = 'table';      //all gamers sitting and logged watchers(excluding unlogged watchers)
  PPTV_ALL                  = 'all';        //all at the table (including watchers)

var
  nBroadcastToToAttr: Array [TResponseBroadcasting] of String = (
    PPTV_REQUESTER,         //   = 'requester';  //just requester
    PPTV_HAND_PARTICIPANTS, //   = 'hand';       //just gamers
    PPTV_TABLE,             //   = 'table';      //all gamers sitting and logged watchers(excluding unlogged watchers)
    PPTV_ALL                //   = 'all';        //all at the table (including watchers)
  );

//subsystems
const
  PPTV_GAME_ADAPTOR = 'gameadapter';
  PPTV_TOURNAMENT   = 'tournament';


//poker packet templates
const
  PPTT_GAME_ENGINE = '<'+PPTN_GAME_ENGINE+'/>';
  PPTT_OUTPUT_PACKET = '<'+PPTN_RESPONSE_ROOT+' name="process"/>';
  PPTT_SCHEDULER_PACKET_EX =
    '<objects>'+
    '  <object name="%s">'+
    '      <gaaction processid="%d">'+
               '%s'+
    '      </gaaction>'+
    '  </object>'+
    '</objects>'+
    ''
  ;

  PPTT_TOURNAMENT_SCHEDULER_PACKET =
    '<objects>'+
    '  <object name="%s">'+
               '%s'+
    '  </object>'+
    '</objects>'+
    ''
  ;

  PPTT_PROCESS_OBJECT_PACKET = '<object name="process"/>';

//------------------------------------------------------------------------------
//poker properties
//------------------------------------------------------------------------------
const
  PP_POKER_TYPE                    = 'Poker Type';
  PPT_POKER_TYPE                   = TGamePropertyType(5);
    PPCN_POKER_TYPE_TEXAS          =  '1'; 
      PPCV_POKER_TYPE_TEXAS        = 'Hold''em';
    PPCN_POKER_TYPE_OMAHA          =  '2'; 
      PPCV_POKER_TYPE_OMAHA         = 'Omaha';
    PPCN_POKER_TYPE_OMAXA_HL       =  '3'; 
      PPCV_POKER_TYPE_OMAXA_HL      = 'Omaha Hi\Lo';
    PPCN_POKER_TYPE_SEVEN_STUD     =  '4'; 
      PPCV_POKER_TYPE_SEVEN_STUD    = '7 Stud';
    PPCN_POKER_TYPE_SEVEN_STUD_HL  =  '5'; 
      PPCV_POKER_TYPE_SEVEN_STUD_HL = '7 Stud Hi\Lo';
//    PPCN_POKER_TYPE_FIVE_CARD_DRAW =  '6'; PPCV_POKER_TYPE_FIVE_CARD_DRAW   = 'Five Card Draw';
//    PPCN_POKER_TYPE_FIVE_CARD_STUD =  '7'; PPCV_POKER_TYPE_FIVE_CARD_STUD   = 'Five Card Stud';
//    PPCN_POKER_TYPE_CRAZY_PINE     =  '8'; PPCV_POKER_TYPE_CRAZY_PINE       = 'Crazy Pineapple';

////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////
  PPDV_POKER_TYPE                  = PPCN_POKER_TYPE_OMAHA;
////////////////////////////////////////////////////////////////////////////////

  PP_TOURNAMENT_TYPE               = 'Tournament Type';
  PPT_TOURNAMENT_TYPE              = TGamePropertyType(5);
    PPCN_NOT_TURNAMENT             =  '0';
      PPCV_NOT_TURNAMENT           =  'No Tournament';
    PPCN_TURNAMENT_SINGLE_TABLE    =  '1';
      PPCV_TURNAMENT_SINGLE_TABLE  =  'Single Table';
    PPCN_TURNAMENT_MULTY_TABLE     =  '2';
      PPCV_TURNAMENT_MULTY_TABLE   =  'Multi Table';
  PPDV_TOURNAMENT_TYPE             =  '0';

  PP_MAX_CHAIRS_COUNT              = 'Maximum Chairs Count';
  PPDV_MAX_CHAIRS_COUNT            = '10';
  PPT_MAX_CHAIRS_COUNT             = TGamePropertyType(1);

  PP_MIN_GAMERS_FOR_START          = 'Minimum Gamers To Start Hand';
  PPDV_MIN_GAMERS_FOR_START        = '2';
  PPT_MIN_GAMERS_FOR_START         = TGamePropertyType(1);

  PP_TYPE_OF_STAKES                = 'Type of Stakes';
  PPDV_TYPE_OF_STAKES              = '1';
  PPT_TYPE_OF_STAKES               = TGamePropertyType(5);
    PPCN_TYPE_OF_STAKES_FIXED_LIMIT   =  '1';
      PPCV_TYPE_OF_STAKES_FIXED_LIMIT   =  'Fixed Limit';
    PPCN_TYPE_OF_STAKES_POT_LIMIT     =  '2';
      PPCV_TYPE_OF_STAKES_POT_LIMIT     =  'Pot Limit';
    PPCN_TYPE_OF_STAKES_NO_LIMIT      =  '3';
      PPCV_TYPE_OF_STAKES_NO_LIMIT      =  'No Limit';

  PP_STATISTIC                = 'Name statistic of "Stakes"';
  PPDV_STATISTIC              = 'Play';
  PPT_STATISTIC               = TGamePropertyType(4);


  PP_LOWER_STAKES_LIMIT       = 'Lower Limit Of The Stakes';
  PPDV_LOWER_STAKES_LIMIT     = '2';
  PPT_LOWER_STAKES_LIMIT      = TGamePropertyType(2);

  PP_GAMER_AMOUNT_CONSTRAINT  = 'Use Gamer Amount Constraint (Pot/No Limit)';
  PPDV_GAMER_AMOUNT_CONSTRAINT= 'true';
  PPT_GAMER_AMOUNT_CONSTRAINT = TGamePropertyType(2);

  PP_MINIMUM_GAMER_AMOUNT     = 'Minimum Gamer Amount';
  PPDV_MINIMUM_GAMER_AMOUNT   = '10';
  PPT_MINIMUM_GAMER_AMOUNT    = TGamePropertyType(2);

  PP_MAXIMUM_GAMER_AMOUNT     = 'Maximum Gamer Amount';
  PPDV_MAXIMUM_GAMER_AMOUNT   = '1000';
  PPT_MAXIMUM_GAMER_AMOUNT    = TGamePropertyType(2);

  PP_DEFAULT_GAMER_AMOUNT     = 'Default Gamer Amount';
  PPDV_DEFAULT_GAMER_AMOUNT   = '100';
  PPT_DEFAULT_GAMER_AMOUNT    = TGamePropertyType(2);

  PP_USE_ALL_INS              = 'Use All-Ins';
  PPDV_USE_ALL_INS            = 'true';
  PPT_USE_ALL_INS             = TGamePropertyType(6);

  //tournament specific:
  PP_ST_TOURNAMENT_BUY_IN     = 'Buy-In (single table tournament only)';
  PPDV_ST_TOURNAMENT_BUY_IN   = '5';
  PPT_ST_TOURNAMENT_BUY_IN    = TGamePropertyType(2);


  PP_ST_TOURNAMENT_FEE        = 'Fee (single table tournament only)';
  PPDV_ST_TOURNAMENT_FEE      = '1';
  PPT_ST_TOURNAMENT_FEE       = TGamePropertyType(2);

  PP_ST_TOURNAMENT_CHIPS      = 'Chips (single table tournament only)';
  PPDV_ST_TOURNAMENT_CHIPS    = '800';
  PPT_ST_TOURNAMENT_CHIPS     = TGamePropertyType(1);

// Quick Search BS
  PP_ST_TOURNAMENT_UseBasePrizes   = 'Use Base Prizes (single table tournament only)';
  PPDV_ST_TOURNAMENT_UseBasePrizes = 'true';
  PPT_ST_TOURNAMENT_UseBasePrizes  = TGamePropertyType(6);

  PP_ST_TOURNAMENT_BasePayment     = 'Type of Base Prizes Payment (single table tournament only)';
  PPDV_ST_TOURNAMENT_BasePayment   = '0';
  PPT_ST_TOURNAMENT_BasePayment    = TGamePropertyType(5);
    PPCN_ST_TOURNAMENT_BasePaymentPercent = '0';
      PPCV_ST_TOURNAMENT_BasePaymentPercent = 'Percent';
    PPCN_ST_TOURNAMENT_BasePaymentFixVal  = '1';
      PPCV_ST_TOURNAMENT_BasePaymentFixVal  = 'Fixed Value';

  PP_ST_TOURNAMENT_BasePrizeFirst   = '1st Place of Base Prize (single table tournament only)';
  PPDV_ST_TOURNAMENT_BasePrizeFirst = '50';
  PPT_ST_TOURNAMENT_BasePrizeFirst  = TGamePropertyType(2);

  PP_ST_TOURNAMENT_BasePrizeSecond   = '2nd Place of Base Prize (single table tournament only)';
  PPDV_ST_TOURNAMENT_BasePrizeSecont = '30';
  PPT_ST_TOURNAMENT_BasePrizeSecond  = TGamePropertyType(2);

  PP_ST_TOURNAMENT_BasePrizeThird   = '3rd Place of Base Prize (single table tournament only)';
  PPDV_ST_TOURNAMENT_BasePrizeThird = '20';
  PPT_ST_TOURNAMENT_BasePrizeThird  = TGamePropertyType(2);

  PP_ST_TOURNAMENT_UseBonusPrizes   = 'Use Bonus Prizes (single table tournament only)';
  PPDV_ST_TOURNAMENT_UseBonusPrizes = 'false';
  PPT_ST_TOURNAMENT_UseBonusPrizes  = TGamePropertyType(6);

  PP_ST_TOURNAMENT_BonusPayment     = 'Type of Bonus Prizes Payment (single table tournament only)';
  PPDV_ST_TOURNAMENT_BonusPayment   = '1';
  PPT_ST_TOURNAMENT_BonusPayment    = TGamePropertyType(5);
    PPCN_ST_TOURNAMENT_BonusPaymentPercent = '0';
      PPCV_ST_TOURNAMENT_BonusPaymentPercent = 'Percent';
    PPCN_ST_TOURNAMENT_BonusPaymentFixVal  = '1';
      PPCV_ST_TOURNAMENT_BonusPaymentFixVal  = 'Fixed Value';

  PP_ST_TOURNAMENT_BonusPrizeFirst   = '1st Place of Bonus Prize (single table tournament only)';
  PPDV_ST_TOURNAMENT_BonusPrizeFirst = '50';
  PPT_ST_TOURNAMENT_BonusPrizeFirst  = TGamePropertyType(2);

  PP_ST_TOURNAMENT_BonusPrizeSecond   = '2nd Place of Bonus Prize (single table tournament only)';
  PPDV_ST_TOURNAMENT_BonusPrizeSecont = '30';
  PPT_ST_TOURNAMENT_BonusPrizeSecond  = TGamePropertyType(2);

  PP_ST_TOURNAMENT_BonusPrizeThird   = '3rd Place of Bonus Prize (single table tournament only)';
  PPDV_ST_TOURNAMENT_BonusPrizeThird = '20';
  PPT_ST_TOURNAMENT_BonusPrizeThird  = TGamePropertyType(2);

//packet attributes
//game property attribute type
const
  GPTA_TYPE_UNDEFINED       = '-';
	GPTA_TYPE_INTEGER    		  = 'integernumeric';
	GPTA_TYPE_REAL       		  = 'realnumeric';
	GPTA_TYPE_CURRENCY   		  = 'currency';
	GPTA_TYPE_STRING     		  = 'string';
	GPTA_TYPE_COMBOBOX   		  = 'combobox';
	GPTA_TYPE_CHECKBOX   		  = 'checkbox';
	GPTA_TYPE_DATE       		  = 'date';
	GPTA_TYPE_TIME       		  = 'time';
	GPTA_TYPE_SPINEDIT   		  = 'spinedit';
  GPTA_TYPE_RANDOM_SEED     = 'randomseed';

//property modificators
const
	GPTA_MOD_NORMAL           = 'normal';
	GPTA_MOD_READONLY         = 'readonly';
	GPTA_MOD_HIDDEN           = 'hidden';

var
	GamePropertyTypeMap: Array[TGamePropertyType] of String =(
    GPTA_TYPE_UNDEFINED ,
		GPTA_TYPE_INTEGER   ,
		GPTA_TYPE_REAL      ,
		GPTA_TYPE_CURRENCY  ,
		GPTA_TYPE_STRING    ,
		GPTA_TYPE_COMBOBOX  ,
		GPTA_TYPE_CHECKBOX  ,
		GPTA_TYPE_DATE      ,
		GPTA_TYPE_TIME      ,
		GPTA_TYPE_SPINEDIT  ,
    GPTA_TYPE_RANDOM_SEED
	);//GamePropertyTypeMap


function GamePropertyType2Str(nPropType: TGamePropertyType): String;
begin
	Result:= GamePropertyTypeMap[nPropType];
end;//

function Str2GamePropertyType(aPropType: String): TGamePropertyType;
var
  I: TGamePropertyType;
begin
	for I:= GPT_INT to GPT_SPINEDIT do begin
    if GamePropertyTypeMap[I] = aPropType then begin
      Result:= I;
      Exit;
    end;//if
	end;//for
	Result:= GPT_UNDEFINED;
end;//

var
	GamePropertyModifierMap: Array [TGamePropertyModifier] of String = (
		GPTA_MOD_NORMAL   ,
		GPTA_MOD_READONLY ,
		GPTA_MOD_HIDDEN   ,
    '',
    '-'
	);

function GamePropertyModifier2Str(nPropMod: TGamePropertyModifier): String;
begin
	Result:= GamePropertyModifierMap[nPropMod];
end;//

function Str2GamePropertyModifier(sPropMod: String): TGamePropertyModifier;
var
  I: TGamePropertyModifier;
begin
  Result:= GPM_UNDEFINED;
  for I:= GPM_NORMAL to GPM_HIDDEN do begin
    if GamePropertyModifierMap[I] = sPropMod then begin
      Result:= I;
      Exit;
		end;//if
  end;//for
end;//Str2GamePropertyModifier

//------------------------------------------------------------------------------
// P_oker S_tats
//------------------------------------------------------------------------------
const
//  PSID_TABLE    = 1  ; PSN_TABLE    = 'Table    '; PSST_TABLE     = Boolean(1); PST_TABLE    = TGamePropertyType(4); PSD_TABLE     = 'Name of gameprocess';
//  PSID_GAMERS   = 2  ; PSN_GAMERS   = 'Gamers   '; PSST_GAMERS    = Boolean(1); PST_GAMERS   = TGamePropertyType(4); PSD_GAMERS    = 'Active Participant Count';
//  PSID_CURRENCY = 3  ; PSN_CURRENCY = 'Currency '; PSST_CURRENCY  = Boolean(1); PST_CURRENCY = TGamePropertyType(3); PSD_CURRENCY  = 'Game Process Currency Type';
  PSID_STAKES   = 102; PSN_STAKES   = 'Stakes   '; PSST_STAKES    = Boolean(0); PST_STAKES   = TGamePropertyType(4); PSD_STAKES    = 'Name of gameprocess stakes';
  PSID_AVG_POT  = 103; PSN_AVG_POT  = 'Avg Pot  '; PSST_AVG_POT   = Boolean(0); PST_AVG_POT  = TGamePropertyType(3); PSD_AVG_POT   = 'Average pot of gameprocess (sets only game engine)';
  PSID_PIRS_FLOP= 104; PSN_PIRS_FLOP= 'PIrs/Flop'; PSST_PIRS_FLOP = Boolean(0); PST_PIRS_FLOP= TGamePropertyType(4); PSD_PIRS_FLOP = 'Average procent value of gamers that is not flop before show of table cards (represented as string. sets only game engine)';
  PSID_PIRS_4TH = 107; PSN_PIRS_4TH = 'PIrs/4th' ; PSST_PIRS_4TH  = Boolean(0); PST_PIRS_4TH = TGamePropertyType(4); PSD_PIRS_4TH  = 'Average procent value of gamers that is not flop before show of table cards (represented as string. sets only game engine)';

  PSID_WAIT     = 105; PSN_WAIT     = 'Wait     '; PSST_WAIT      = Boolean(0); PST_WAIT     = TGamePropertyType(1); PSD_WAIT      = 'Count of Waiting List for gameprocess';
  PSID_H_HR     = 106; PSN_H_HR     = 'H/hr     '; PSST_H_HR      = Boolean(0); PST_H_HR     = TGamePropertyType(1); PSD_H_HR      = 'Round to integer the value of hands by hour (sets only by game engine)';
  PSID_ID       = 200; PSN_ID       = 'ID       '; PSST_ID        = Boolean(0); PST_ID       = TGamePropertyType(1); PSD_ID        = 'Tournament ID';
  PSID_DATE     = 201; PSN_DATE     = 'Date     '; PSST_DATE      = Boolean(0); PST_DATE     = TGamePropertyType(7); PSD_DATE      = 'Tournament Start date';
  PSID_GAME     = 202; PSN_GAME     = 'Game     '; PSST_GAME      = Boolean(0); PST_GAME     = TGamePropertyType(4); PSD_GAME      = 'Tournament Game Name';
  PSID_LIMIT    = 203; PSN_LIMIT    = 'Limit    '; PSST_LIMIT     = Boolean(0); PST_LIMIT    = TGamePropertyType(5); PSD_LIMIT     = 'Limit Type';
  PSID_BUY_IN   = 204; PSN_BUY_IN   = 'Buy-In   '; PSST_BUY_IN    = Boolean(0); PST_BUY_IN   = TGamePropertyType(3); PSD_BUY_IN    = 'Amount of Money to enter tournament';
  PSID_STATE    = 205; PSN_STATE    = 'State    '; PSST_STATE     = Boolean(0); PST_STATE    = TGamePropertyType(5); PSD_STATE     = 'Tournament state';
  PSID_ENROLLED = 206; PSN_ENROLLED = 'Enrolled '; PSST_ENROLLED  = Boolean(0); PST_ENROLLED = TGamePropertyType(1); PSD_ENROLLED  = 'Participants number';


////////////////////////////////////////////////////////////////////////////////
// Classes
////////////////////////////////////////////////////////////////////////////////

{ TpoBasicGameEngine }

constructor TpoBasicGameEngine.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  try
    FProcessID:= UNDEFINED_PROCESS_ID;

  {$IFDEF __TESTGE__}
    FApi:= nil;
  {$ELSE}
    FApi:= CommonDataModule.ObjectPool.GetAPI;
  {$ENDIF}

  //engine core
    FDeposits:= TpoGamerDeposits.Create;
    FProperties:= TGameProperties.Create;
    FActions:= TpoGameActions.Create(Self);
    FSubActions:= TpoGameActions.Create(Self);
    FStats:= TpoGameStats.Create;
    FTable:= TpoTable.Create;
    FReminders:= TpoReminders.Create;

  // scheduler on time out activity
    FCheckTimeOutActivity := '';
    FLastTimeActivity := 0;

  //messages
    FMessageList:= TpoMessageList.Create;
    FHistoryList:= TpoMessageList.Create;

  //init game context
    InitGameProperties();
    InitGameActions();

  //check
    FApiSuspendedOperations := TpoApiSuspendedOperationList.Create;
    FApiHandAndRakesSuspendedOperations := TpoHandAndRakesSuspendedOperationList.Create;;

  //packets cache
    FResponseDoc:= TXMLDocument.Create(nil);
    FResponseDoc.Active:= False;
    FResponseDoc.XML.Text:= '<rsp/>';
    FResponseDoc.Active:= True;
    FResponseRoot:= FResponseDoc.DocumentElement;
    FActionDoc:= TXMLDocument.Create(nil);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Create', E.Message, ltException);
  end;
end;//TpoBasicPokerGameEngine.Create


destructor TpoBasicGameEngine.Destroy;
begin
//packets cache
  try
    if FActionDoc.Active then FActionDoc.DocumentElement.ChildNodes.Clear;
    FActionDoc:= nil;

    if FResponseDoc.Active then FResponseDoc.DocumentElement.ChildNodes.Clear;
    FResponseRoot:= nil;
    FResponseDoc.Active:= False;
    FResponseDoc:= nil;

    if FStateManager<> nil then FStateManager.Free;
    FDeposits.Free;

  //messaging
    FHistoryList.Free;
    FMessageList.Free;

  //suspended api operations
    FApiSuspendedOperations.Free;
    FApiHandAndRakesSuspendedOperations.Free;

  //Delete all reminders; Fapi must be exists
    DeleteAllRemindersOnFree;

  //down core
    FReminders.Free;
    FCroupier.Free;
    FTable.Free;
    FStats.Free;
    FSubactions.Free;
    FActions.Free;
    FProperties.Free;

  //turn subsystems
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Destroy', E.Message, ltException);
  end;

  {$IFNDEF __TESTGE__}
    CommonDataModule.ObjectPool.FreeAPI(FApi);
  {$ENDIF}
  inherited;
end;//TpoBasicPokerGameEngine.Destroy


function TpoBasicGameEngine.Get_AboutGE: WideString;
begin
  Result:= GEM_ABOUT_INFO;
end;

function TpoBasicGameEngine.Get_Version: Single;
begin
  Result:= GEM_VERSION;
end;

function TpoBasicGameEngine.GetDefaultEngineProperties(
  var PropXML, Reason: string;
  nGameType: Integer;
  nTournamentType: Integer
): Integer;
var
  d: IXMLDocument;
  rn, pln, pn, cn: IXMLNode;
  i, j: Integer;

begin
  Result:= 0;
  __lock__();
  try
  	d:=	TXMLDocument.Create(nil);
	  d.Active		:=	False;
	  d.XML.Text	:=	PPTT_GAME_ENGINE;
	  d.Active		:=	True;
    rn:= d.DocumentElement;
    pln:= rn.AddChild(PPTN_PROPERTIES);

    for i:= 0 to FProperties.Count-1 do begin
      pn:= pln.AddChild(PPTN_PROPERTY);
      pn.Attributes[PPTA_NAME]:= FProperties[i].Name;
      pn.Attributes[PPTA_TYPE]:= IntToStr(Ord(FProperties[i].FPropType));

      try
        if FProperties[i].Name = PP_POKER_TYPE then begin
          pn.Attributes[PPTA_VALUE]:= FProperties[i].Constraint[nGameType].Name;
        end else if FProperties[i].Name = PP_TOURNAMENT_TYPE then begin
          pn.Attributes[PPTA_VALUE]:= FProperties[i].Constraint[nTournamentType].Name;
        end else begin
          pn.Attributes[PPTA_VALUE]:= FProperties[i].Value;
        end;
      except
          pn.Attributes[PPTA_VALUE]:= FProperties[i].Value;
      end;

      for j:= 0 to FProperties[i].ConstraintCount-1 do begin
        cn:= pn.AddChild(PPTN_CONSTRAINT);
        cn.Attributes[PPTA_ID]:= FProperties[i].Constraint[j].Name;
        cn.Attributes[PPTA_VALUE]:= FProperties[i].Constraint[j].Value;
      end;//for
    end;//for
  except
    on e: EpoException do begin
      Result:= (e as EpoException).Code;
      Reason:= e.Message+' '+e.Location;
    end;//
    on e: Exception do begin
      Reason:= e.Message;
      Result:= GE_ERR_NOT_DEFINED;
    end;//
  end;//try

  PropXMl:= rn.XML;
  __unlock__();

  rn:= nil;
  d.Active:=FALSE;
  d := nil;
end;

//reserved
function TpoBasicGameEngine.GetProcessInfo(var InfoXML, Reason: String): Integer;
begin
  Result:= GetDefaultEngineProperties(
    InfoXML,
    Reason
  );
end;

procedure TpoBasicGameEngine.SendProcClosePacketToALL;
var
  n: IXMLNode;
begin
  { procclose notyfication on init process }
  n := PrepareProcClosePacket(PrepareOutputPacket(RB_ALL, True), 'Table has been reinit by administator.');
  DispatchResponse(0, n, True);
end;

function TpoBasicGameEngine.InitGameProcess(
  ProcessID: Integer; const InitXML: String; var Reason: String): Integer;
var
  rn, pln: IXMLNode;
  i: Integer;
  gp: TGameProperty;
begin
  CommonDataModule.Log(ClassName, 'InitGameProcess', 'InitProcess: '+InitXML, ltCall);

  Result:= 0;
  Reason:= '';

  { initialization }
  try
    SendProcClosePacketToALL;
  //0. check input
    FActionDoc.Active:= False;
    FActionDoc.XML.Text:= InitXML;
    FActionDoc.Active:= True;
    rn:= FActionDoc.DocumentElement;
    pln:= rn.ChildNodes.FindNode(PPTN_PROPERTIES);
    if pln = nil then begin
      EscalateFailure(
        EpoException,
        'Properties section not found inside init packet',
        '{7532FDDD-EAB9-4458-A3EF-F414CA7A426B}',
        GE_ERR_WRONG_PACKET
      );
    end;//if

   //1. Init properties
    for i:= 0 to pln.ChildNodes.Count-1 do begin
      gp:= FProperties.PropertyByName(pln.ChildNodes[i].Attributes[PPTA_NAME]);
      if gp = nil then begin
        EscalateFailure(
          EpoException,
          'Unknown property ('+pln.ChildNodes[i].Attributes[PPTA_NAME]+') inside init packet',
          '{7E3E68BF-A016-421E-871F-BAD44A508A23}',
          GE_ERR_WRONG_PACKET
        );
      end;//if
      gp.Value:= pln.ChildNodes[i].Attributes[PPTA_VALUE];
    end;//for

  //2. Init process ID
    Self.ProcessID:= ProcessID;
    SpecifyProcessAttributes();

  //3. Init game stats
    InitGameStats();
    PopulateGameStats();

  //4 init Rake rules
    InitRakeRules;

  //5 init and fix game state
    MakeInitialGameArrangements();
    CreateState();
    StoreState();
    FApi.SetGameType(FProcessID, Integer(FCroupier.PokerType), FCroupier.Chairs.Count);

  //6 Update stats
    UpdateGameStats();

  except
    on e: EpoException do begin
      Reason:= e.Message+' '+e.Location;
      CommonDataModule.Log(ClassName, 'InitGameProcess', '[EXCEPTION]: ' + Reason, ltException);
      RollbackState();
      Result:= (e as EpoException).Code;
    end;//
    on e: Exception do begin
      Reason:= e.Message;
      CommonDataModule.Log(ClassName, 'InitGameProcess', '[EXCEPTION]: ' + Reason, ltException);
      RollbackState();
      Result:= GE_ERR_NOT_DEFINED;
    end;//
  end;//try

  pln:= nil;
  rn:= nil;
end;

//absolete; reserved
function TpoBasicGameEngine.ProcessEvent(
  EventID: Integer; const EventXML: String; var Reason: String): Integer;
begin
  Result:= 0;
end;

function TpoBasicGameEngine.PrepareOutputPacket(
  nBroadcastTo: TResponseBroadcasting; bIncludeRequester: Boolean): IXMLNode;
begin
  Result:= FResponseRoot.AddChild(PPTN_RESPONSE_ROOT);
  Result.Attributes[PPTA_NAME]:= PPTV_PROCESS;
  Result.Attributes[PPTA_RESPONSE_GROUP]:= nBroadcastToToAttr[nBroadcastTo];
  Result.Attributes[PPTA_SEND_TO_REQUESTER]:= IntToStr(Integer(bIncludeRequester));
  Result:= Result.AddChild(PPTN_GAME_ACTION);
  Result.Attributes[PPTA_PROCESS_ID]:= IntToStr(ProcessID);
  Result.Attributes[PPTA_SEQ_GAHANDID]:= IntToStr(Table.Hand.HandID);
  Result.Attributes[PPTA_SEQ_GAROUND]:= IntToStr(Table.Hand.RoundID);
end;

procedure TpoBasicGameEngine.InitGameActions();
begin
  FActions.AddAction(PPTN_DUMMY, HandleDummy);

//generic actions sctions
  FActions.AddAction(PPTN_CHECK_ENTER, HandleCheckEnter);
  FActions.AddAction(PPTN_PROC_INIT, HandleProcInit);
  FActions.AddAction(PPTN_PROC_STATE, HandleProcState);
  FActions.AddAction(PPTN_CHAT, HandleChat);
  FActions.AddAction(PPTN_CHATALLOW, HandleChatAllow);
  FActions.AddAction(PPTN_GAGETDEFPROP, HandleGetDefaultProperty);
  FActions.AddAction(PPTN_GASETDEFPROP, HandleSetDefaultProperty);
  FActions.AddSubAction(PPTN_TIMER_EVENT, PPTV_GAMER_ACTION, HandleEventGamerActionExpired);
  FActions.AddAction(PPTN_DRINKS, HandleDrinks);
  FActions.AddAction(PPTN_BOT_EVENT, HandleEventBotActionExpired);
end;


function TpoBasicGameEngine.DispatchResponse(
  nFromSessionID: Integer;
  aResponseInfo: IXMLNode; bInstantPost: Boolean; nUserID: Integer): Boolean;
var
  sRespGroup: String;
  bIncludeRequester: Boolean;
begin
  Result:= True;
  if aResponseInfo = nil then Exit;

  aResponseInfo:= GetTopParent(aResponseInfo);
  sRespGroup:= aResponseInfo.Attributes[PPTA_RESPONSE_GROUP];
  if aResponseInfo.Attributes[PPTA_SEND_TO_REQUESTER] <> '' then begin
    bIncludeRequester:= aResponseInfo.Attributes[PPTA_SEND_TO_REQUESTER]
  end else begin
    bIncludeRequester:= False;
  end;

  if NOT bInstantPost then
    PushResponse(sRespGroup, nFromSessionID, aResponseInfo.xml, nUserID, bIncludeRequester)
  else
    SendResponse(sRespGroup, nFromSessionID, aResponseInfo.xml, nUserID, bIncludeRequester);
end;

procedure TpoBasicGameEngine.LoadState(nProcessID: Integer);
begin
  if FStateManager = nil then
    FStateManager:= TpoApiStateManager.Create(nProcessID, Self);
  try
    if FStateManager.CacheState then begin
      Load(FStateManager.InStream);
    end;//if
  except
    on e: Exception do begin
      raise;
    end;//
  end;//try
end;

procedure TpoBasicGameEngine.StoreState;
begin
  try
    Store(FStateManager.OutStream);
    FStateManager.ServiceState:=  PrepareServiceStatePacket();
    FStateManager.FlushState;
  except
    on e: Exception do begin
      raise;
    end;//
  end;//try
end;

procedure TpoBasicGameEngine.StoreState(var StrState: string; var StrServiceState: string);
begin
  try
    Store(FStateManager.OutStream);
    FStateManager.ServiceState := PrepareServiceStatePacket();
    FStateManager.FlushState(StrState, StrServiceState);
  except
    on e: Exception do begin
      raise;
    end;//
  end;//try
end;//

function TpoBasicGameEngine.Load(aReader: TReader): Boolean;
begin
  FEngineStateID := aReader.ReadInteger();
  FProcessID     := aReader.ReadInteger();
  FEngineID      := aReader.ReadInteger();
  FCurrencyID    := aReader.ReadInteger();
  FCurrencyTypeID:= aReader.ReadInteger();
  FCurrencySymbol:= aReader.ReadString ();
  FCurrencyName  := aReader.ReadString ();
  FPassword      := aReader.ReadString ();
  FIsWatchingAllowed := aReader.ReadBoolean();
  FProcessName   := aReader.ReadString ();
  FGroupID       := aReader.ReadInteger();
  FTournamentID  := aReader.ReadInteger();
  FProtectedMode := aReader.ReadInteger();
  FIsHighlighted := aReader.ReadInteger();

  FProperties.Load(aReader);
  FStats.Load(aReader);
  FTable.Load(aReader);

//croupier selection
  if Croupier <> nil then Croupier.Free;
  Croupier:= TpoCroupierFactory.GetCroupierClass(TournamentType).Create(Ftable);
  Croupier.Load(aReader);
  Croupier.CurrencySymbol := FCurrencySymbol;

//
  DeleteAllRemindersOnFree;
  FReminders.Load(aReader);
  CreateAllRemindersOnLoad;
  
//
  FCheckTimeOutActivity := aReader.ReadString;
  FLastTimeActivity     := aReader.ReadDate;
//
  FHistoryList.Load(aReader);
//
  Result:= True;
end;


function TpoBasicGameEngine.Store(aWriter: TWriter): Boolean;
begin
  Inc(FEngineStateID);
  aWriter.WriteInteger(FEngineStateID );
  aWriter.WriteInteger(FProcessID     );
  aWriter.WriteInteger(FEngineID      );
  aWriter.WriteInteger(FCurrencyID    );
  aWriter.WriteInteger(FCurrencyTypeID);
  aWriter.WriteString (FCurrencySymbol);
  aWriter.WriteString (FCurrencyName  );
  aWriter.WriteString (FPassword      );
  aWriter.WriteBoolean(FIsWatchingAllowed );
  aWriter.WriteString (FProcessName   );
  aWriter.WriteInteger(FGroupID       );
  aWriter.WriteInteger(FTournamentID  );
  aWriter.WriteInteger(FProtectedMode );
  aWriter.WriteInteger(FIsHighlighted );

  FProperties.Store(aWriter);
  FStats.Store(aWriter);
  FTable.Store(aWriter);
  FCroupier.Store(aWriter);
  FReminders.Store(aWriter);
//
  aWriter.WriteString(FCheckTimeOutActivity);
  aWriter.WriteDate(FLastTimeActivity);
//
  FHistoryList.Store(aWriter);
//
  Result:= True;
end;

procedure TpoBasicGameEngine.InitGameStats;
begin
//TBO:
end;

procedure TpoBasicGameEngine.CreateState;
var
  sReason: string;
begin
  sReason:= '';
  Table.Hand.Reset;
  Table.Chairs.KickOffAllGamers;
  Table.Gamers.Clear;
  if FStateManager = nil then
    FStateManager:= TpoApiStateManager.Create(ProcessID, Self);
  FstateManager.InitState;
end;

procedure TpoBasicGameEngine.SetEngineID(const Value: Integer);
begin
  FEngineID := Value;
end;

procedure TpoBasicGameEngine.SetCurrencyID(const Value: Integer);
begin
  FCurrencyID := Value;
  FTable.CurrencyID:= FCurrencyID;
end;

procedure TpoBasicGameEngine.SetCurrencyName(const Value: String);
begin
  FCurrencyName := Value;
end;

procedure TpoBasicGameEngine.SetCurrencySymbol(const Value: String);
begin
  FCurrencySymbol := Value;
end;

procedure TpoBasicGameEngine.SetCurrencyTypeID(const Value: Integer);
begin
  FCurrencyTypeID := Value;
end;

procedure TpoBasicGameEngine.SetProcessName(const Value: String);
begin
  FProcessName := Value;
  FTable.Name:= Value;
end;

procedure TpoBasicGameEngine.SpecifyProcessAttributes;
var
  sReason: String;

  sProcessName: string;
  sCurrencyName: string;
  sCurrencySymbol: string;
  sPassword: string;
  nIsWatchingAllowed: Integer;

begin
  sReason:= '';
  FApi.GetProcessInfo(
    ProcessID, FEngineID, FGroupID,  sProcessName,
    sPassword, nIsWatchingAllowed, FCurrencyID, FProtectedMode, FIsHighLighted
  );

  FApi.GetCurrency(
    FCurrencyID, sCurrencyName, sCurrencySymbol );

  FProcessName:= sProcessName;
  FCurrencyName:= sCurrencyName;
  FCurrencySymbol:= sCurrencySymbol;
  FPassword := sPassword;
  FIsWatchingAllowed := (nIsWatchingAllowed > 0);

  //setup table limits
  //correct tabel stake for tournaments
  //12/09/2003

  FTable.MinBuyIn:= Trunc(FProperties.PropertyByName(PP_MINIMUM_GAMER_AMOUNT).AsDouble * 100);
  FTable.MaxBuyIn:= Trunc(FProperties.PropertyByName(PP_MAXIMUM_GAMER_AMOUNT).AsDouble * 100);
  FTable.DefBuyIn:= Trunc(FProperties.PropertyByName(PP_DEFAULT_GAMER_AMOUNT).AsDouble * 100);
  CurrencyID:= FCurrencyID;

  //adjust croupier
  Croupier:= TpoCroupierFactory.GetCroupierClass(TournamentType).Create(Ftable);
  Croupier.PokerType:= TpoPokerType(FProperties.PropertyByName(PP_POKER_TYPE).AsInteger);
  Croupier.StakeType:= TpoStakeType(FProperties.PropertyByName(PP_TYPE_OF_STAKES).AsInteger);
  Croupier.CurrencySymbol := FCurrencySymbol;
  Croupier.MinGamersForStartHand := Max(FProperties.PropertyByName(PP_MIN_GAMERS_FOR_START).AsInteger, 2);
  Croupier.MinGamersForStartHand := Min(FProperties.PropertyByName(PP_MAX_CHAIRS_COUNT).AsInteger, Croupier.MinGamersForStartHand);

  if TournamentType = TT_SINGLE_TABLE then begin
    if TpoPokerType(FProperties.PropertyByName(PP_POKER_TYPE).AsInteger) IN [PT_TEXAS_HOLDEM, PT_OMAHA, PT_OMAHA_HILO] then begin
      FProperties.PropertyByName(PP_LOWER_STAKES_LIMIT).AsDouble:= 15;
    end else begin
      FProperties.PropertyByName(PP_LOWER_STAKES_LIMIT).AsDouble:= 10;
    end;//if

    (Fcroupier as TpoGenericTournamentCroupier).TournamentFee:= TournamentFee;
    (Fcroupier as TpoGenericTournamentCroupier).TournamentBuyIn:= TournamentBuyIn;
    // Quick Search BS
    (Fcroupier as TpoGenericTournamentCroupier).TournamentUseBasePrizes:= TournamentUseBasePrizes;
    (Fcroupier as TpoGenericTournamentCroupier).TournamentBasePaymentType:= TournamentBasePaymentType;
    (Fcroupier as TpoGenericTournamentCroupier).TournamentBaseFirstPlace:= TournamentBaseFirstPlace;
    (Fcroupier as TpoGenericTournamentCroupier).TournamentBaseSecondPlace:= TournamentBaseSecondPlace;
    (Fcroupier as TpoGenericTournamentCroupier).TournamentBaseThirdPlace:= TournamentBaseThirdPlace;
    //
    (Fcroupier as TpoGenericTournamentCroupier).TournamentUseBonusPrizes:= TournamentUseBonusPrizes;
    (Fcroupier as TpoGenericTournamentCroupier).TournamentBonusPaymentType:= TournamentBonusPaymentType;
    (Fcroupier as TpoGenericTournamentCroupier).TournamentBonusFirstPlace:= TournamentBonusFirstPlace;
    (Fcroupier as TpoGenericTournamentCroupier).TournamentBonusSecondPlace:= TournamentBonusSecondPlace;
    (Fcroupier as TpoGenericTournamentCroupier).TournamentBonusThirdPlace:= TournamentBonusThirdPlace;
  end;//if

  TableStake:= Trunc( FProperties.PropertyByName(PP_LOWER_STAKES_LIMIT).AsDouble * 100 );
  MandatoryAnte := 0;

  //check for exception
  EscalateFailure(EpoException, sReason, '{BA661A68-CB59-48C7-8B4E-FD5AFB52A1AC}');
end;


procedure TpoBasicGameEngine.MakeInitialGameArrangements;
begin
  FTable.Chairs.Count:= FProperties.PropertyByName(PP_MAX_CHAIRS_COUNT).AsInteger;
end;

procedure TpoBasicGameEngine.PopulateGameStats;
var
  i: Integer;
  sReason: WideString;
begin
  sReason:= '';
  for I:= 0 to FStats.Count-1 do begin
    if FStats[I].Modifier = GPM_NORMAL then begin
      FApi.CreateStats(ProcessID, FStats[I].ID, FStats[I].Value);
      if sReason <> '' then begin
        EscalateFailure(
          EpoException,
          'Error occured during stat creation {'+sReason+'}',
          '{6FF80C9E-46E2-48DB-A224-671686C66D93}'
        );
      end;//if
    end;//if
  end;//for
end;


function TpoBasicGameEngine.HandleProcInit(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
  nUserID, nSexID: Integer;
  I: Integer;
  nAvatarID, nImageVersion: Integer;
  sUserName, sCity: string;
  bChatAllow: Boolean;
  bEmailValidated: Boolean;
  nAffiliateID: Integer;
  nLevelID: Integer;
  n, cn, an: IXMLNode;

  sDenyNonEmailValidated: string;
  sConfigData: string;
  nRes: Integer;

  sHost : WideString;
  sIP : string;
  sPassword: string;
  GamerIsBot: Boolean;
  MaxWatchersAllowed: Integer;
  TimeOutGamersActivity: Integer;
  nIsAllowed: Integer;
  aIcons: TStringList;
  sIcon1, sIcon2, sIcon3, sIcon4: string;
begin
  CommonDataModule.Log(ClassName, 'HandleProcInit',
    'enter: HandleProcInit, SessionID: '+IntToStr(nSessionID), ltCall);

  GamerIsBot := False;

  for I := 0 to FTable.Gamers.Count-1 do begin
    CommonDataModule.Log(ClassName, 'HandleProcInit',
      'UserID: '+IntToStr(FTable.Gamers[I].UserID)+
      '  SessionID: '+IntToStr(FTable.Gamers[I].SessionID), ltCall);
  end;//for

  { get common System data }
  nRes := FApi.GetSystemOption(ID_EMAILVALIDATED_ON_ENTRY, sConfigData);
  if (nRes <> NO_ERROR) then begin
    CommonDataModule.Log(ClassName, 'HandleProcInit',
      '[ERROR] On execute FApi.GetSystemOption: Result=' + IntToStr(nRes) + '; Params: OptionID=' + IntToStr(ID_EMAILVALIDATED_ON_ENTRY) + '.',
      ltError);
    sConfigData := '0';
  end;
  sDenyNonEmailValidated := sConfigData;

  sConfigData := '10';
  nRes := FApi.GetSystemOption(ID_TIME_OUT_GAMERS_ACTIVITY, sConfigData);
  if (nRes <> NO_ERROR) then begin
    CommonDataModule.Log(ClassName, 'HandleProcInit',
      '[ERROR] On execute FApi.GetSystemOption: Result=' + IntToStr(nRes) +
      '; Params: OptionID=' + IntToStr(ID_TIME_OUT_GAMERS_ACTIVITY) + '.',
      ltError);
    sConfigData := '10';
  end;
  TimeOutGamersActivity := StrToIntDef(sConfigData, 10) * 60;

  sConfigData := '10';
  nRes := FApi.GetSystemOption(ID_MAXIMUM_WATCHERS_ALLOWED, sConfigData);
  if (nRes <> NO_ERROR) then begin
    CommonDataModule.Log(ClassName, 'HandleProcInit',
      '[ERROR] On execute FApi.GetSystemOption: Result=' + IntToStr(nRes) +
      '; Params: OptionID=' + IntToStr(ID_MAXIMUM_WATCHERS_ALLOWED) + '.',
      ltError);
    sConfigData := '10';
  end;
  MaxWatchersAllowed := StrToIntDef(sConfigData, 10);

  { Check Table last activity timeout}
  if (FCroupier.TournamentType <> TT_MULTI_TABLE) and (FTable.Gamers.Count <= 0)then begin
    if (FCroupier.TournamentType = TT_SINGLE_TABLE) then FLastTimeActivity := IncSecond(Now, -1);
    if (FTable.Gamers.Count <= 0) or (FCheckTimeOutActivity = '') then begin
      DeleteAllCheckOnTimeOutReminders;
      FCheckTimeOutActivity := ScheduleSecInterval(0, TimeOutGamersActivity, PPTV_CHECK_TIMEOUT_ACTIVITY).ReminderID;
    end;
  end;

  Result:= nil;
  g:= FTable.Gamers.GamerBySessionID(nSessionID);
  if (g = nil) and (nUserIDAttr > 0) then g := FTable.Gamers.GamerByUserID(nUserIDAttr);
  nUserID:= UNDEFINED_USER_ID;
  sUserName:= '';
  sCity:= '';
  nSexID:= 1;
  nAvatarID:= 1;
  nImageVersion := 0;
  bChatAllow := True;
  nAffiliateID := 1;
  bEmailValidated := False;
  nLevelID := 0;

  //update gamers list
  if g = nil then begin
    nRes := FApi.GetParticipantInfo(
      nSessionID, nUserID, sUserName, sCity, nSexID, nAvatarID, nImageVersion, sIP,
      bChatAllow, nAffiliateID, bEmailValidated, nLevelID,
      sIcon1, sIcon2, sIcon3, sIcon4
    );
    if (nRes <> NO_ERROR) then begin
      CommonDataModule.Log(ClassName, 'HandleProcInit',
        '[ERROR] On Execute FApi.GetParticipantInfo: SessionID=' + IntToStr(nSessionID),
        ltError);
      Exit;
    end;

    g:= Table.Gamers.GamerByUserID(nUserID);
    if (g <> nil) then begin
      CommonDataModule.Log(ClassName, 'HandleProcInit',
        'Gamer is found among gamers; state: ' + g.StateAsString, ltCall);

      if (TournamentType = TT_NOT_TOURNAMENT) AND (Table.Hand.State <> HST_IDLE) AND
         (g.ChairID <> UNDEFINED_POSITION_ID) AND (g.HandIDWhenLeft = FTable.Hand.HandID) then
      begin
        n:= PrepareProcClosePacket(
          PrepareOutputPacket(RB_REQUESTER, True),
          'Please wait for the current hand to finish before returning to the table.'
        );
        DispatchResponse(nSessionID, n);
        Exit;
      end;//if

      GamerIsBot := g.IsBot;
      if not GamerIsBot then begin
        aIcons := TStringList.Create;
        aIcons.Add(sIcon1);
        aIcons.Add(sIcon2);
        aIcons.Add(sIcon3);
        aIcons.Add(sIcon4);

        FTable.Gamers.UpdateGamer(
          nSessionID, sHost, nUserID, sUserName, nSexID, sCity, nAvatarID, nImageVersion,
          sIP, bChatAllow, nAffiliateID, bEmailValidated, nLevelID, aIcons
        );
        aIcons.Clear;
        aIcons.Free;
      end;

    end else begin
      { validate password on procinit }
      sPassword := '';
      if aActionInfo.HasAttribute(PPTA_PASSWORD) then
        sPassword := aActionInfo.Attributes[PPTA_PASSWORD];

      if (FPassword <> '') and (FPassword <> sPassword) then begin
        n:= PrepareProcClosePacket(
          PrepareOutputPacket(RB_REQUESTER, True),
          'Password is incorrect. Please reopen the table and reenter the password again.'
        );
        DispatchResponse(nSessionID, n, False, nUserIDAttr);

        Exit; //Password is incorrect
      end;

      { validate access by invitedusers }
      FApi.CheckOnAccessByInvitedUsers(ProcessID, 0, nUserID, nIsAllowed);
      if (nIsAllowed <= 0) then begin
        n:= PrepareProcClosePacket(
          PrepareOutputPacket(RB_REQUESTER, True),
          'Access denied. Table is not allowed for you.'
        );
        DispatchResponse(nSessionID, n, False, nUserIDAttr);
        Exit; //not invited
      end;

      if (FTable.Gamers.CountOfWatchers >= MaxWatchersAllowed) then begin
      { maximum watchers is allowed }
        n:= PrepareProcClosePacket(
          PrepareOutputPacket(RB_REQUESTER, True),
          'The watching feature for this table is currently unavailable, please select another table.'
        );
        DispatchResponse(nSessionID, n);
        Exit;
      end;

      if (sDenyNonEmailValidated <> '0') then begin
      // Need for check on email validation
      { User with not email validated can not entry to process }
        if not bEmailValidated then begin
          n:= PrepareProcClosePacket(
            PrepareOutputPacket(RB_REQUESTER, True),
            'You can not enter the table while your email is not validated.'
          );
          DispatchResponse(nSessionID, n);
          Exit;
        end;
      end;

      aIcons := TStringList.Create;
      aIcons.Add(sIcon1);
      aIcons.Add(sIcon2);
      aIcons.Add(sIcon3);
      aIcons.Add(sIcon4);

      g:= FTable.Gamers.RegisterGamer(
        nSessionID, sHost, nUserID, sUserName, nSexID, sCity, nAvatarID, nImageVersion,
        bChatAllow, nAffiliateID, bEmailValidated, nLevelID, aIcons
      );
      aIcons.Clear;
      aIcons.Free;
    end;//if
  end else begin
    CommonDataModule.Log(ClassName, 'HandleProcInit',
      'Gamer is found among gamers; state: ' + g.StateAsString, ltCall);
    if (TournamentType = TT_NOT_TOURNAMENT) AND (Table.Hand.State <> HST_IDLE) AND
       (g.ChairID <> UNDEFINED_POSITION_ID) AND (g.HandIDWhenLeft = FTable.Hand.HandID) then
    begin
      n:= PrepareProcClosePacket(
        PrepareOutputPacket(RB_REQUESTER, True),
        'Please wait for the current hand to finish before returning to the table.'
      );
      DispatchResponse(nSessionID, n);
      Exit;
    end;//

    nUserID:= g.UserID;
    GamerIsBot := g.IsBot;

    if not GamerIsBot then begin
      nRes := FApi.GetParticipantInfo(
        nSessionID, nUserID, sUserName, sCity, nSexID, nAvatarID, nImageVersion, sIP,
        bChatAllow, nAffiliateID, bEmailValidated, nLevelID,
        sIcon1, sIcon2, sIcon3, sIcon4
      );
    end else begin
      nRes := NO_ERROR;
    end;
    if (nRes <> NO_ERROR) then begin
      CommonDataModule.Log(ClassName, 'HandleProcInit',
        '[ERROR] On Execute FApi.GetParticipantInfo: SessionID=' + IntToStr(nSessionID),
        ltError);
      Exit;
    end;
    if not GamerIsBot then begin
      aIcons := TStringList.Create;
      aIcons.Add(sIcon1);
      aIcons.Add(sIcon2);
      aIcons.Add(sIcon3);
      aIcons.Add(sIcon4);

      FTable.Gamers.UpdateGamer(
        nSessionID, sHost, nUserID, sUserName, nSexID, sCity, nAvatarID, nImageVersion, sIP,
        bChatAllow, nAffiliateID, bEmailValidated, nLevelID, aIcons
      );
      aIcons.Clear;
      aIcons.Free;
    end;
  end;//if

  //Update gamer stats
  if not GamerIsBot then
    FApiSuspendedOperations.Add(SO_RegisterParticipant, nSessionID);
  FApiSuspendedOperations.Add(SO_UpdateParticipantCount);
  //

  //prepare proc init packet
  if not GamerIsBot then begin
    cn:= PrepareOutputPacket(RB_REQUESTER, True);
    PrepareProcInitPacket(cn);
    PrepareProcStatePacket(cn, nSessionID);
    Result:= cn;
    //
    FCroupier.HandleGamerProcInit(g);

    //prepare set active player
    if Table.Hand.ActiveGamer <> nil then begin
      an:= PrepareOutputPacket(RB_REQUESTER, True);
      PrepareSetActivePlayerPacket(an, nSessionID);
      DispatchResponse(nSessionID, an);
    end;//if
  end; //if


  //bot char on gamer enter table
  PostRandomAnswerOnCategory(g, BCP_JOIN_TABLE);

  CommonDataModule.Log(ClassName, 'HandleProcInit', 'leave: HandleProcInit', ltCall);
end;//TpoBasicGameEngine.HandleProcInit

function TpoBasicGameEngine.GetTopParent(aNode: IXMLNode): IXMLNode;
begin
  Result:= aNode;
  while (Result.NodeName <> PPTN_RESPONSE_ROOT) and (Result.ParentNode <> nil)
    do Result:= Result.ParentNode;
end;

function TpoBasicGameEngine.PrepareProcInitPacket(
  aParent: IXMLNode): IXMLNode;
var
  cn: IXMLNode;
begin
  if aParent <> nil then Result:= aParent.AddChild(PPTN_PROC_INIT)
  else Result:= FResponseRoot.AddChild(PPTN_PROC_INIT);

  cn:= Result.AddChild(PPTN_VERSION);
    cn.Attributes[PPTA_VALUE]:= PV_GAME_ENGINE_VERSION;

  cn:= Result.AddChild(PPTN_NAME);
    cn.Attributes[PPTA_VALUE]:= ProcessName;
  cn:= Result.AddChild(PPTN_POKER_TYPE);
    cn.Attributes[PPTA_VALUE]:= FProperties.PropertyByName(PP_POKER_TYPE).Value;
  cn:= Result.AddChild(PPTN_PLAYER_COUNT);
    cn.Attributes[PPTA_VALUE]:= IntToStr(FTable.Chairs.Count);
  cn:= Result.AddChild(PPTN_CURRENCY_ID);
    cn.Attributes[PPTA_VALUE]:= IntToStr(CurrencyID);
  cn:= Result.AddChild(PPTN_CURRENCY_SIGN);
    cn.Attributes[PPTA_VALUE]:= CurrencySymbol;

  cn:= Result.AddChild(PPTN_STAKE_TYPE);
    cn.Attributes[PPTA_VALUE]:= FProperties.PropertyByName(PP_TYPE_OF_STAKES).Value;

  cn:= Result.AddChild(PPTN_ALLIN);
    cn.Attributes[PPTA_VALUE]:= FProperties.PropertyByName(PP_USE_ALL_INS).Value;

  cn:= Result.AddChild(PPTN_MAX_BUYIN);
    cn.Attributes[PPTA_VALUE]:= FCroupier.NormalizeAmount(Trunc(FProperties.PropertyByName(PP_MAXIMUM_GAMER_AMOUNT).AsDouble * 100));

  cn:= Result.AddChild(PPTN_MIN_BUYIN);
    cn.Attributes[PPTA_VALUE]:= FCroupier.NormalizeAmount(Trunc(FProperties.PropertyByName(PP_MINIMUM_GAMER_AMOUNT).AsDouble * 100));

  cn:= Result.AddChild(PPTN_DEF_BUYIN);
    cn.Attributes[PPTA_VALUE]:= FCroupier.NormalizeAmount(Trunc(FProperties.PropertyByName(PP_DEFAULT_GAMER_AMOUNT).AsDouble * 100));

  cn:= Result.AddChild(PPTN_PROTECTED_MODE);
    cn.Attributes[PPTA_VALUE]:= FProtectedMode;

  cn:= Result.AddChild(PPTN_IS_HIGHLIGHTED);
    cn.Attributes[PPTA_VALUE]:= FIsHighlighted;

  cn:= Result.AddChild(PPTN_IS_TOURNAMENT);
    cn.Attributes[PPTA_VALUE]:= Ord(TournamentType);

  //added through single table tournament changes
  if TournamentType = TT_SINGLE_TABLE then begin
    cn.Attributes[PPTA_BUYIN]  := FloatToStr(TournamentBuyIn / 100);
    cn.Attributes[PPTA_RAKE]   := FloatToStr(TournamentFee / 100);
    cn.Attributes[PPTA_CHIPS]  := FloatToStr(TournamentChips / 100);
  end;//if
end;

function TpoBasicGameEngine.PrepareProcStatePacket(
  aParent: IXMLNode; nTargetSessionID: Integer): IXMLNode;
var
  cn: IXMLNode;
  nLowStake, nHiStake, nUsePassword: Integer;
begin
  if aParent <> nil then Result:= aParent.AddChild(PPTN_PROC_STATE)
  else Result:= FResponseRoot.AddChild(PPTN_PROC_STATE);

  //<procstate handid=”10” round="1" prevhandid="7" minstake=”3” maxstake="6" >
  Result.Attributes[PPTA_HAND_ID]     := IntToStr(FTable.Hand.HandID);
  Result.Attributes[PPTA_ROUND]       := IntToStr(FTable.Hand.RoundID);
  Result.Attributes[PPTA_PREV_HAND_ID]:= IntToStr(FTable.Hand.PrevHandID);

  if (FCroupier.TournamentType = TT_MULTI_TABLE) then begin
    nLowStake := FCroupier.GetSmallBlindStakeValue;
    nHiStake  := FCroupier.GetBigBlindStakeValue;
    nUsePassword := 0;
  end else begin
    nLowStake := FTable.SmallBetValue;
    nHiStake  := FTable.BigBetValue;
    nUsePassword := Integer(FPassword <> '');
  end;
  Result.Attributes[PPTA_MIN_STAKE]   := FloatToStr(nLowStake/100);
  Result.Attributes[PPTA_MAX_STAKE]   := FloatToStr(nHiStake/100);
  Result.Attributes[PPTA_USE_PASSWORD] := nUsePassword;

  cn:= Result.AddChild(PPTN_COMMUNITY_CARDS);
    cn.Attributes[PPTA_VALUE]:= FTable.Hand.CommunityCards.FormSeries(True);

  PreparePotPartsPacket(Result);
  cn:= Result.AddChild(PPTN_RAKE);
  cn.Attributes[PPTA_AMOUNT] := FormatFloat('0.##', FCroupier.NormalizeAmount(FTable.Hand.Pot.RakesToCharge));

  PrepareChairsPacket(Result, nTargetSessionID);
  PrepareDrinksChairsPacket(Result);

//tournament addition
//<tournament started="0/1" level="1...10" hand="1...10" ... />
  if TournamentType = TT_SINGLE_TABLE then begin
    cn:= Result.AddChild(PPTN_TOURNAMENT);
    cn.Attributes[PPTA_STARTED] := Integer((Croupier as TpoSingleTableTournamentCroupier).TournamentStatus = TST_RUNNING);
    cn.Attributes[PPTA_LEVEL]   := (Croupier as TpoSingleTableTournamentCroupier).GetTournamentLevel;
    cn.Attributes[PPTA_HAND]    := (Croupier as TpoSingleTableTournamentCroupier).GetHandInsideLevel+1;
  end;//

//  PreparePushingContentPacket(Result);
end;

function TpoBasicGameEngine.PreparePotPartsPacket(
  aParent: IXMLNode): IXMLNode;
var
  I: Integer;
  pn: IXMLNode;
begin
  Result:= aParent.AddChild(PPTN_POTS);
  for I:= 0 to FTable.Hand.Pot.SidePots.Count-1 do begin
    pn:=Result.AddChild(PPTN_POT);
    pn.Attributes[PPTA_ID]:= IntToStr(I);
    pn.Attributes[PPTA_AMOUNT]:= FormatFloat('0.##',
      FCroupier.NormalizeAmount(FTable.Hand.Pot.SidePots[I].Balance-FTable.Hand.Pot.SidePots[I].RakesToCharge)
    );
  end;//for
end;

function TpoBasicGameEngine.PrepareChairsPacket(aParent: IXMLNode; nTargetSessionID: Integer): IXMLNode;
var
  I: Integer;
begin
  Result:= aParent.AddChild(PPTN_CHAIRS);
  for I:= 0 to FTable.Chairs.Count-1 do begin
    PrepareChairStatusPacket(Result, I, '', False, nTargetSessionID);
  end;//for
end;

function TpoBasicGameEngine.HandleProcState(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
begin
  try
    UpdateParticipantInfo(nSessionID, nUserIDAttr, True);
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'HandleProcState', E.Message, ltException);
  end;

  Result:= PrepareOutputPacket(RB_REQUESTER, True);
  PrepareProcStatePacket(Result, nSessionID);
  DispatchResponse(nSessionID, Result);

  if Table.Hand.ActiveGamer <> nil then begin
    Result:= PrepareOutputPacket(RB_REQUESTER, True);
    PrepareSetActivePlayerPacket(Result, nSessionID);
    DispatchResponse(nSessionID, Result);
  end;//if
end;

function TpoBasicGameEngine.PrepareSetActivePlayerPacket(aParent: IXMLNode;
  nTargetSessionID: Integer): IXMLNode;
var
  cn,
  an: IXMLNode;
  g: TpoGAmer;
  ga: TpoGamerActions;
  nAmount: Integer;
begin
  Result:= aParent.AddChild(PPTN_SET_ACTIVE_PLAYER);

  an:= Result.AddChild(PPTN_ACTIONS);
  g:= Table.ActiveGamer;
  if g <> nil then begin
    ga:= FCroupier.GetValidGamerActions(g);
    Result.Attributes[PPTA_POSITION]:= g.ChairID;
    Result.Attributes[PPTA_TURN_TIMEOUT]:= IntToStr(GT_GAMER_ACTION_TIMEOUT);
    if TournamentType = TT_NOT_TOURNAMENT then
      Result.Attributes[PPTA_TIMEBANK]:= IntToStr(0)
    else
      Result.Attributes[PPTA_TIMEBANK]:= IntToStr(g.TournamentTimebank);

		if GA_SIT_OUT       IN ga then begin
      an.AddChild(PPTN_SIT_OUT);
    end;//if

		if GA_POST_SB       IN ga then begin
      cn:= an.AddChild(PPTN_POST_SB);
      cn.Attributes[PPTA_STAKE]:= FormatFloat('0.##', FCroupier.NormalizeAmount(FCroupier.GetSmallBlindstakeValue));
    end;//if

		if GA_POST_BB       IN ga then begin
      cn:= an.AddChild(PPTN_POST_BB);
      cn.Attributes[PPTA_STAKE]:= FormatFloat('0.##', FCroupier.NormalizeAmount(FCroupier.GetBigBlindStakeValue));
    end;//if

		if GA_ANTE          IN ga then begin
      cn:= an.AddChild(PPTN_ANTE);
      cn.Attributes[PPTA_STAKE]:= FormatFloat('0.##', FCroupier.NormalizeAmount(FCroupier.GetAnteStakeValue));
    end;//if

		if GA_WAIT_BB       IN ga then begin
      an.AddChild(PPTN_WAIT_BB);
    end;//if

		if GA_POST          IN ga then begin
      cn:= an.AddChild(PPTN_POST);
      cn.Attributes[PPTA_STAKE]:= FormatFloat('0.##', FCroupier.NormalizeAmount(FCroupier.GetPostStakeValue));
    end;//if

		if GA_POST_DEAD     IN ga then begin
      cn:= an.AddChild(PPTN_POST_DEAD);
      if g.SkippedSBStake AND (NOT g.SkippedBBStake) then begin
        cn.Attributes[PPTA_STAKE]:= FormatFloat('0.##', FCroupier.NormalizeAmount(FCroupier.GetSmallBlindStakeValue));
        cn.Attributes[PPTA_DEAD]:=  FormatFloat('0.##', FCroupier.NormalizeAmount(FCroupier.GetSmallBlindStakeValue));
      end else begin
        cn.Attributes[PPTA_STAKE]:= FormatFloat('0.##', FCroupier.NormalizeAmount(FCroupier.GetPostStakeValue+FCroupier.GetPostDeadStakeValue));
        cn.Attributes[PPTA_DEAD]:= FormatFloat('0.##', FCroupier.NormalizeAmount(FCroupier.GetPostDeadStakeValue));
      end;//if
    end;//if

		if GA_FOLD          IN ga then begin
      an.AddChild(PPTN_FOLD);
    end;//if

		if GA_CHECK         IN ga then begin
      an.AddChild(PPTN_CHECK);
    end;//if

		if GA_CALL          IN ga then begin
      cn:= an.AddChild(PPTN_CALL);
      cn.Attributes[PPTA_STAKE]:= FormatFloat('0.##',
        FCroupier.NormalizeAmount(FCroupier.GetCallStakeValue(g))
      );
    end;//if

    if GA_BRING_IN IN ga then begin
      cn:= an.AddChild(PPTN_BRING_IN);
      cn.Attributes[PPTA_STAKE]:= FormatFloat('0.##', FCroupier.NormalizeAmount(FCroupier.GetBringInStakeValue));
    end;//if

		if GA_BET           IN ga then begin
      cn:= an.AddChild(PPTN_BET);
      nAmount:= FCroupier.GetBetStakeValue(g);
      cn.Attributes[PPTA_STAKE]:= FormatFloat('0.##', FCroupier.NormalizeAmount(nAmount));
      if FCroupier.StakeType IN [ST_POT_LIMIT, ST_NO_LIMIT] then begin
        cn.Attributes[PPTA_MAX_STAKE]:= FormatFloat('0.##', FCroupier.NormalizeAmount(FCroupier.GetStakeLimit(g, nAmount)));
      end;//if
    end;//if

		if GA_RAISE         IN ga then begin
      cn:= an.AddChild(PPTN_RAISE);
      nAmount:= FCroupier.GetRaiseStakeValue(g);
      cn.Attributes[PPTA_STAKE]:= FormatFloat('0.##', FCroupier.NormalizeAmount(nAmount));
      if FCroupier.StakeType IN [ST_POT_LIMIT, ST_NO_LIMIT] then begin
        cn.Attributes[PPTA_MAX_STAKE]:= FormatFloat('0.##', FCroupier.NormalizeAmount(FCroupier.GetStakeLimit(g, nAmount)));
      end;//if
    end;//if

		if GA_SHOW_CARDS    IN ga then begin
      an.AddChild(PPTN_SHOW_CARDS);
    end;//if

		if GA_SHOW_CARDS_SHUFFLED  IN ga then begin
      an.AddChild(PPTN_SHOW_CARDS_SHUFFLED);
    end;//if

		if GA_MUCK          IN ga then begin
      an.AddChild(PPTN_MUCK);
    end;//if

		if GA_DONT_SHOW     IN ga then begin
      an.AddChild(PPTN_DONT_SHOW);
    end;//if

		if GA_DISCARD_CARDS IN ga then begin
      an.AddChild(PPTN_DISCARD_CARDS);
    end;//if
  end;//if
end;


function TpoBasicGameEngine.PrepareChairStatusPacket(
  aParent: IXMLNode; nPositionID: Integer; sLeftUserName: String;
  bIssueChatPackets: Boolean; nPersonificationSessionID: Integer): IXMLNode;
var
  c: TpoChair;
  g: TpoGamer;
  cn, IconNode: IXMLNode;
  I: Integer;
//<chair position="5" status="busy" isdealer="0">
//	<player id="45" name="Eugene2" city="Simferopol" sex="1" balance="100"
//bet="0" status="playing" ingame="0"/>
begin
  Result:= nil;
  if nPositionID = UNDEFINED_POSITION_ID then begin
    Exit;
  end;//
  c:= FTable.Chairs[nPositionID];

  if aParent <> nil then Result:= aParent.AddChild(PPTN_CHAIR)
  else Result:= FResponseRoot.AddChild(PPTN_CHAIR);

  Result.Attributes[PPTA_POSITION]:= IntToStr(nPositionID);
  Result.Attributes[PPTA_STATUS]:= c.StateAsString;
  Result.Attributes[PPTA_DEALER_FLAG]:= IntToStr(Integer(c.IsDealer));
  if c.State = CS_BUSY then begin
    g:= c.Gamer;
    cn:= Result.AddChild(PPTN_PLAYER);
    cn.Attributes[PPTA_ID]:= IntToStr(g.UserID);
    cn.Attributes[PPTA_NAME]:= g.UserName;
    cn.Attributes[PPTA_CITY]:= g.City;
    cn.Attributes[PPTA_SEX] := IntToStr(g.SexID);
    cn.Attributes[PPTA_AVATAR_ID]:= IntToStr(g.AvatarID);
    cn.Attributes[PPTA_LEVEL_ID]:= IntToStr(g.LevelID);
    cn.Attributes[PPTA_USER_IMAGE_VERSION] := IntToStr(g.ImageVersion);
    cn.Attributes[PPTA_BALANCE]:= FormatFloat('0.##', FCroupier.NormalizeAmount(g.Account.Balance));
    cn.Attributes[PPTA_BET]:= FormatFloat('0.##', FCroupier.NormalizeAmount(g.Bets));
      //'0';//TBD: what is this for?
    cn.Attributes[PPTA_STATUS]:= g.StateAsString;
    cn.Attributes[PPTA_IN_GAME]:= IntToStr(Integer( (g.State = GS_PLAYING) and not g.PassCurrentHand) );
    cn.Attributes[PPTA_CARDS]:= g.Cards.FormSeries((nPersonificationSessionID = g.SessionID));

    for I:=0 to g.Icons.Count - 1 do begin
      IconNode := cn.AddChild(PPTN_ICON);
      IconNode.Attributes[PPTA_ID] := I + 1;
      IconNode.Attributes[PPTA_ICON] := g.Icons[I];

      if (I >= (GS_COUNT_OF_USER_ICONS - 1)) then Break;
    end;
    for I := g.Icons.Count to GS_COUNT_OF_USER_ICONS - 1 do begin
      IconNode := cn.AddChild(PPTN_ICON);
      IconNode.Attributes[PPTA_ID] := I + 1;
      IconNode.Attributes[PPTA_ICON] := '';
    end;

    if bIssueChatPackets then begin
      if g.State <> GS_LEFT_TABLE then  PrepareChatPacket(aParent, g.UserName+' has joined the table', MO_DEALER)
      else begin
        PrepareChatPacket(aParent, g.UserName+' has left the table', MO_DEALER);
      end;//
    end;//if
  end else
  if c.State = CS_RESERVED then begin
    cn:= Result.AddChild(PPTN_PLAYER);
    cn.Attributes[PPTA_ID]:= c.ReservationUserID;
  end;//if

end;

function TpoBasicGameEngine.PrepareChatPacket(aParent: IXMLNode;
  sMsg: String; nSource: TpoMessageOriginator; nPriority,
  nUserID: Integer): IXMLNode;
begin
  Result:= aParent.AddChild(PPTN_CHAT);
  Result.Attributes[PPTA_SOURCE]    := IntToStr(Ord(nSource));
  Result.Attributes[PPTA_PRIORITY]  := IntToStr(nPriority);
  Result.Attributes[PPTA_MSG]       := sMsg;

  if nUserID <> UNDEFINED_USER_ID then begin
    Result.Attributes[PPTA_USER_ID]   := nUserID;
    Result.Attributes[PPTA_USER_NAME] := Table.Gamers.GamerByUserID(nUserID).UserName;
  end;//if
end;

function TpoBasicGameEngine.HandleChat(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
  sTxt, sMsg: string;
begin
  g:= FTable.Gamers.GamerBySessionID(nSessionID);
  if (g <> nil) then if not g.ChatAllow then Exit;

  sTxt := aActionInfo.XML;
  sMsg := aActionInfo.Attributes[PPTA_MSG];

  PushHistoryEntry(nSessionID, aActionInfo);

  Result:= PrepareOutputPacket(RB_ALL, True);
  Result.ChildNodes.Add(aActionInfo.CloneNode(True));

  //bot chat post
  if not Assigned(g) then Exit;
  if (not g.IsBot) then begin
    PostRandomAnswerOnKeywords(g, sMsg);
  end;//if

  sTxt := '';
  sMsg := '';
end;

function TpoBasicGameEngine.PrepareSchedulerPacket(
  sActionName: string): IXMLNode;
var
  sn: IXMLNode;
begin
  Result:= FResponseRoot.AddChild(PPTN_OBJECTS);
  sn:= Result.AddChild(PPTN_OBJECT);
  sn.Attributes[PPTA_NAME]:= PPTV_GAME_ADAPTOR;
  sn:= sn.AddChild(PPTN_GAME_ACTION);
  sn.Attributes[PPTA_PROCESS_ID]:= ProcessID;
  sn:= sn.AddChild(PPTN_TIMER_EVENT);
  sn.Attributes[PPTA_NAME]:= sActionName;
  sn.Attributes[PPTA_HAND_ID]:= IntToStr(Table.Hand.HandID);
  sn.Attributes[PPTA_ROUND]:= IntToStr(Table.Hand.RoundID);
  sn:= nil;
end;

function TpoBasicGameEngine.ScheduleSecInterval(nSessionID, nInterval: Integer;
  sActionName: String): TpoReminder;
var
  im: TDateTime;
  sReason: WideString;
  sRemindID, sData: string;
  nRes: Integer;
begin
  im := IncSecond(Now, nInterval);
  sReason:= '';
  sData := PrepareSchedulerPacket(sActionName).XML;
  nRes:= FAPi.CreateRemind(
     nSessionID,
     ProcessID,
     im,
     sData,
     sRemindID
  );

  EscalateFailure(
    nRes,
    EpoException,
    sReason,
    '{FE26E4CF-90D8-4191-A30F-09150B523CEF}'
  );

  Result:= FReminders.AddReminder(sActionName, sRemindID, sData, im, nSessionID);

  CommonDataModule.Log(ClassName, 'ScheduleSecInterval',
    'New reminder was created; ID=' + sRemindID + ', name=' + sActionName + ', ExecTime=' + DateTimeToStr(im) + ', SessionID=' + IntToStr(nSessionID),
    ltCall);
end;

function TpoBasicGameEngine.PrepareDealCardsPacket(aParent: IXMLNode;
  nTargetSessionID: Integer; nRoundID: Integer; bOnStartRound: Boolean): IXMLNOde;
var
  I: Integer;
  cn: IXMLNode;
  bAsOpen: Boolean;
  aGamerTarget: TpoGamer;
begin
  if aParent <> nil then Result:= aParent.AddChild(PPTN_DEAL_CARDS)
  else Result:= FResponseRoot.AddChild(PPTN_DEAL_CARDS);

  if bOnStartRound then Result.Attributes[PPTA_ROUND]:= nRoundID
  else Result.Attributes[PPTA_ROUND]:= nRoundID+1;

//community cards
  if FTable.Hand.CommunityCards.Modified then begin
    cn:= Result.AddChild(PPTN_COMMUNITY_CARDS);
    if (FCroupier.PokerType in [PT_SEVEN_STUD, PT_SEVEN_STUD_HILO]) then begin
      aGamerTarget := FTable.Gamers.GamerBySessionID(nTargetSessionID);
      bAsOpen := False;
      if (aGamerTarget <> nil) then
        bAsOpen := (aGamerTarget.Cards.Count < 7);
      cn.Attributes[PPTA_VALUE]:= FTable.Hand.CommunityCards.FormSeries(bAsOpen);
    end else begin
      cn.Attributes[PPTA_VALUE]:= FTable.Hand.CommunityCards.FormSeries(True);
    end;
  end;//if

//gamer cards
  for I:= 0 to FTable.Gamers.Count-1 do begin
    if FTable.Gamers[I].Cards.Count = 0 then Continue;
    if NOT FTable.Gamers[I].Cards.Modified then Continue;
    if FTable.Gamers[I].State = GS_FOLD then Continue;
    if FTable.Gamers[I].State = GS_LEFT_TABLE then Continue;

    cn:= Result.AddChild(PPTN_DEAL);
    cn.Attributes[PPTA_POSITION]:= IntToStr(FTable.Gamers[I].ChairID);
    cn.Attributes[PPTA_CARDS]   :=
      FTable.Gamers[I].Cards.FormSeries((FTable.Gamers[I].SessionID = nTargetSessionID) OR (nTargetSessionID = SHARED_HISTORY_SESSION_ID));
  end;//for
end;

function TpoBasicGameEngine.PrepareFinishRoundPacket(
  aParent: IXMLNode): IXMLNOde;
var
  cn: IXMLNode;
begin
  Result:= aParent.AddChild(PPTN_ROUND_FINISH);
  Result.Attributes[PPTA_ROUND]:= Table.Hand.RoundID+1;
  Result.Attributes[PPTA_WINNER_CANDIDATES]:= FCroupier.WinnerCandidatesCount;

  cn:= Result.AddChild(PPTN_RAKE);
    cn.Attributes[PPTA_AMOUNT]        := FormatFloat('0.##', FCroupier.NormalizeAmount(FTable.Hand.Pot.RakesToCharge));
end;


function TpoBasicGameEngine.RescheduleSecInterval(
  sReminderID: string;
  nInterval: Integer
  ): TpoReminder;
var
  im: TDateTime;
  ts: TTimeStamp;
  sReason: WideString;
  aReminder: TpoReminder;
  nRes: Integer;
begin
  ts:= DateTimeToTimeStamp(Now);
  aReminder:= FReminders.Reminder[sReminderID, ''];

  ts.Time:= ts.Time+nInterval*1000; //convert to ms
  im:= TimeStampToDateTime(ts);
  sReason:= '';
  nRes:= FAPi.ResetRemind(im, sReminderID);
  EscalateFailure(
    nRes,
    EpoException,
    sReason,
    '{EA673E2C-23CB-46E8-87C4-8DAEDF2A03AB}'
  );
  aReminder.RemindTime:= im;
  aReminder.ReminderID:= sReminderID;
  Result:= aReminder;
end;

function TpoBasicGameEngine.DeleteInterval(sReminderID: string): Boolean;
begin
//===================================
// return value - reminder was found
//===================================
  FAPi.RemoveRemind(sReminderID);
  Result := FReminders.DeleteReminder(sReminderID);
end;

function TpoBasicGameEngine.DeleteIntervalByUserIDAndName(nUserID: Integer; sRemindName: string = ''): Boolean;
var
  rm: TpoReminder;
begin
//===================================
// return value - reminder was found
//===================================
  rm := FReminders.GetReminderByUserIDAndName(nUserID, sRemindName);
  Result := (rm <> nil);
  if Result then begin
    FAPi.RemoveRemind(rm.FReminderID);
    FReminders.DeleteReminder(rm.FReminderID);
  end;
end;

procedure TpoBasicGameEngine.DeleteAllRemindersOnFree;
var
  I: Integer;
begin
  for I := (FReminders.Count - 1) downto 0 do
    DeleteInterval(FReminders.Item[I].FReminderID);
end;

procedure TpoBasicGameEngine.CreateAllRemindersOnLoad;
var
  I: Integer;
  aRmd: TpoReminder;
  sRmdID: string;
begin
  for I:=0 to FReminders.Count - 1 do begin
    aRmd := FReminders.Item[I];
    FApi.CreateRemind(aRmd.FSessionID, FProcessID, aRmd.FRemindTime, aRmd.Data, sRmdID);
    aRmd.FReminderID := sRmdID;
  end;
end;

function TpoBasicGameEngine.HandleDummy(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
begin
  Result:= PrepareOutputPacket(RB_REQUESTER, True);
end;

procedure TpoBasicGameEngine.RollbackState;
begin
  if FStateManager <> nil then FStateManager.RollbackChanges;
end;

function TpoBasicGameEngine.PrepareMoveBetsPacket(aParent: IXMLNode;
  sContext: String): IXMLNOde;
var
  I: Integer;
  cn: IXMLNode;
  tr: TpoTransaction;
  acc: TpoAccount;
  g: TpoGamer;
begin
  Result:= aParent.AddChild(PPTN_MOVE_BETS);
  Table.Hand.Pot.Transactions.ContextFilter:= sContext;

  for I:= 0 to TAble.Hand.Pot.Transactions.Count-1 do begin
    tr:= TAble.Hand.Pot.Transactions[I];
    if tr.Description = 'return' then begin
      acc:= TAble.Hand.Pot.Bets.AccountByName(tr.SourceAccountName);
      cn:= Result.AddChild(PPTN_RETURN_BET);
      cn.Attributes[PPTA_AMOUNT]      := FormatFloat('0.##', FCroupier.NormalizeAmount(tr.Amount));
      g:= FTable.Gamers.GamerByUserID((acc as TpoUserSettlementAccount).UserID);
      cn.Attributes[PPTA_NEW_BALANCE] := FormatFloat('0.##', FCroupier.NormalizeAmount(g.Account.Balance));
      cn.Attributes[PPTA_POSITION]    := g.ChairID;
    end else begin
      acc:= TAble.Hand.Pot.SidePots.AccountByName(tr.TargetAccountName);
      cn:= Result.AddChild(PPTN_MOVE_BET);
      cn.Attributes[PPTA_POSITION]:= tr.SenderChairID;
      cn.Attributes[PPTA_POT_ID]  := acc.IndexOf;
      cn.Attributes[PPTA_AMOUNT]  := FormatFloat('0.##', FCroupier.NormalizeAmount(tr.Amount));
    end;//if
  end;//for

  Table.Hand.Pot.Transactions.ContextFilter:= '';
end;

function TpoBasicGameEngine.PrepareFinishHandPacket(aParent: IXMLNode;
  sContext: String): IXMLNOde;
var
  n: IXMLNode;
begin
  Result:= aParent.AddChild(PPTN_FINISH_HAND);
  if Table.Hand.Pot.Transactions.MessageContext <> '' then begin
    n := Result.AddChild(PPTN_GAMER_MESSAGE);
    n.Attributes[PPTA_CAPTION] := 'title';
    n.Attributes[PPTA_MSG_BODY] := Table.Hand.Pot.Transactions.MessageContext;
  //  n.Attributes[PPTA_TEXT] := Table.Hand.Pot.Transactions.MessageContext;
  end;

  { not used allready }
  Table.Hand.Pot.Transactions.MessageContext := '';
end;

function TpoBasicGameEngine.DispatchException(
  aException: Exception; bInstantPost: Boolean): Boolean;
var
  n: IXMLNode;
  nSessionID: Integer;
begin
  nSessionID:= 0;
  Result:= True;
  if EngineResetMode then Exit;
  if aException is EpoSessionException then begin
    CommonDataModule.Log(ClassName, 'DispatchException',
      '[ERROR]: ' + (aException as EpoSessionException).Message +
        '; Anchor=' + (aException as EpoSessionException).Anchor +
        '; Code=' + IntToStr((aException as EpoSessionException).Code) +
        '; SessionID=' + IntToStr((aException as EpoSessionException).SessionID),
      ltError
    );

//    n:= PrepareGamerPopUpPacket(
//      PrepareOutputPacket(RB_REQUESTER, True), 'Warning:', nil, aException.Message, 0
//    );
//    nSessionID:= (aException as EpoSessionException).SessionID;
  end else begin
    n:= PrepareProcClosePacket(PrepareOutputPacket(RB_ALL, True), aException.Message);
    DispatchResponse(nSessionID, n, bInstantPost);
  end;//
end;

function TpoBasicGameEngine.PrepareShowCardsPacket(aParent: IXMLNode;
  aGamer: TpoGamer): IXMLNOde;
begin
  Result:= PrepareGamerActionPacket(aParent, aGamer, GA_SHOW_CARDS);
end;

function TpoBasicGameEngine.PrepareMuckPacket(aParent: IXMLNode;
  aGamer: TpoGamer): IXMLNOde;
begin
  Result:= PrepareGamerActionPacket(aParent, aGamer, GA_MUCK);
end;

function TpoBasicGameEngine.PrepareDontShowCardsPacket(aParent: IXMLNode;
  aGamer: TpoGamer): IXMLNOde;
begin
  Result:= PrepareGamerActionPacket(aParent, aGamer, GA_DONT_SHOW);
end;

function TpoBasicGameEngine.PrepareSitOutPacket(aParent: IXMLNode;
  aGamer: TpoGamer): IXMLNOde;
begin
  Result:= PrepareGamerActionPacket(aParent, aGamer, GA_SIT_OUT);
end;

function TpoBasicGameEngine.PrepareLeaveTablePacket(aParent: IXMLNode;
  aGamer: TpoGamer): IXMLNOde;
begin
  Result:= PrepareGamerActionPacket(aParent, aGamer, GA_LEAVE_TABLE);
end;

function TpoBasicGameEngine.PrepareMoreChipsPacket(aParent: IXMLNode;
  aGamer: TpoGamer): IXMLNOde;
begin
  Result:= aParent.AddChild(PPTN_GAMER_ACTION);
  Result.Attributes[PPTA_NAME]    := PPTV_MORE_CHIPS;
  Result.Attributes[PPTA_POSITION]:= aGamer.ChairID;
  Result.Attributes[PPTA_BALANCE] := FormatFloat('0.##', FCroupier.NormalizeAmount(aGamer.Account.Balance));
end;

function TpoBasicGameEngine.PrepareServiceStatePacket: String;
var
  pin, dn: IXMLNode;
  I, bc: Integer;

begin
  Result:= '';

//addition for tournament
//    <group name="Single tournament status:" value=""/>
//      <data name="runing" city="" value=""/>
//    </group>
  if TournamentType = TT_SINGLE_TABLE then begin
    pin:= FResponseRoot.AddChild('group');
    pin.Attributes[PPTA_NAME]:= 'Single tournament status:';
    pin.Attributes[PPTA_VALUE]:= '';

    dn:= pin.AddChild(PPTN_DATA);
    dn.Attributes[PPTA_NAME]:= (Croupier as TpoSingleTableTournamentCroupier).TournamentStatusAsString;
    dn.Attributes[PPTA_CITY]:= '';
    dn.Attributes[PPTA_VALUE]:= '';
  //
    Result:= Result+pin.XML;
  end;//if

//    <group name="Players:" value="4">
//      <data name="Player 1" city="Sim-City" value="$1000"/>
//      <data name="Player 2" city="Sim-Town" value="$2000"/>
//      <data name="Player 3" city="Sim-Village" value="$3000"/>
//    </group>
  pin:= FResponseRoot.AddChild('group');
  pin.Attributes[PPTA_NAME]:= 'Players:';
  bc:= FTable.Chairs.BusyChairsCount;
  pin.Attributes[PPTA_VALUE]:= bc;
  for I:= 0 to FTable.Chairs.Count-1 do begin
    if NOT FTable.Chairs[I].IsBusy then Continue;
    if (FTable.Chairs[I].Gamer = nil) then Continue;
    dn:= pin.AddChild(PPTN_DATA);

    if TournamentType = TT_SINGLE_TABLE then begin
      if FTable.Chairs[I].Gamer.TournamentPlace > 0 then begin
        dn.Attributes[PPTA_NAME]  := 'Place: '+IntToStr(FTable.Chairs[I].Gamer.TournamentPlace)+' '+FTable.Chairs[I].Gamer.UserName;
        dn.Attributes[PPTA_CITY]  := '';
        dn.Attributes[PPTA_VALUE] := '';
      end else begin
        dn.Attributes[PPTA_NAME]:= FTable.Chairs[I].Gamer.UserName;
        dn.Attributes[PPTA_CITY]:= FTable.Chairs[I].Gamer.City;
        dn.Attributes[PPTA_VALUE]:=
          FormatAmount( FTable.Chairs[I].Gamer.Account.Balance, CurrencyID );
      end;//
    end else begin
      dn.Attributes[PPTA_NAME]:= FTable.Chairs[I].Gamer.UserName;
      dn.Attributes[PPTA_CITY]:= FTable.Chairs[I].Gamer.City;
      dn.Attributes[PPTA_VALUE]:= FormatAmount( FTable.Chairs[I].Gamer.Account.Balance, CurrencyID );
    end;//if
  end;//for
  Result:= Result+pin.XML;
end;

function TpoBasicGameEngine.UpdateParticipantInfo(nSessionID, nUserIDAttr: Integer; bNeedUpdateFromDB: Boolean): TpoGamer;
var
  nUserID, nSexID: Integer;
  sUserName, sCity: string;
  nAvatarID, nImageVersion: Integer;
  nRes: Integer;
  sHost : WideString;
  sIP : string;
  bChatAllow: Boolean;
  nAffiliateID : Integer;
  bEmailValidated: Boolean;
  nLevelID: Integer;
  aIcons: TStringList;
  sIcon1, sIcon2, sIcon3, sIcon4: string;
begin
  Result:= nil;
  if (nUserIDAttr > 0) then Result := FTable.Gamers.GamerByUserID(nUserIDAttr);
  if Result <> nil then begin
    Result.SessionID := nSessionID;
    UpdateParticipantInfo(Result, bNeedUpdateFromDB);
    Exit;
  end;

  nRes:= FApi.GetParticipantInfo(nSessionID,
    nUserID, sUserName, sCity, nSexID, nAvatarID, nImageVersion, sIP,
    bChatAllow, nAffiliateID, bEmailValidated, nLevelID,
    sIcon1, sIcon2, sIcon3, sIcon4
  );

  if (nRes <> NO_ERROR) then begin
    CommonDataModule.Log(ClassName, 'UpdateParticipantInfo', '[ERROR] On exec FApi.GetParticipantInfo: Result=' + IntToStr(nRes) + '; SessionID=' + IntToStr(nSessionID),
      ltError);
    EscalateFailure(
      nRes,
      EpoSessionException,
      '[ERROR] On exec FApi.GetParticipantInfo: Result=' + IntToStr(nRes) + '; SessionID=' + IntToStr(nSessionID),
      '{827817C3-E13A-42A8-A670-FFAF620032CD}'
    );
  end;

  if nUserID > UNDEFINED_USER_ID then begin
    aIcons := TStringList.Create;
    aIcons.Add(sIcon1);
    aIcons.Add(sIcon2);
    aIcons.Add(sIcon3);
    aIcons.Add(sIcon4);

    Result:= FTable.Gamers.UpdateGamer(
      nSessionID, sHost, nUserID, sUserName, nSexID, sCity, nAvatarID, nImageVersion, sIP,
      bChatAllow, nAffiliateID, bEmailValidated, nLevelID, aIcons
    );

    aIcons.Clear;
    aIcons.Free;
  end;//if
end;

function TpoBasicGameEngine.FlushResponseQueue: Integer;
var
  msg: TpoMessage;
  I: Integer;
begin
  Result:= 0;
  for I:=0 to FMessageList.Count - 1 do begin
    msg:= FMessageList.Items[I];

    try
      DispatchQueuedMessage(msg);
    except
      on e: EpoUnexpectedActionException do begin
        CommonDataModule.Log(ClassName, 'FlushResponseQueue',
          'Unexpected action: '+e.Message+' '+e.Anchor,
          ltError
        );
      end;//
    end;//try
    Inc(Result);
  end;//while
  FMessageList.Clear;
end;//TpoBasicGameEngine.FlushResponseQueue


procedure TpoBasicGameEngine.PushResponse(sRespGroup: string; nSessionID: Integer;
  sMsgBody: String; nUserID: Integer; bIncludeRequester: Boolean
);
begin
  FMessageList.PushMessage(
    TpoMessage.Create(FMessageList, sRespGroup, nSessionID, sMsgBody, nUserID, bIncludeRequester)
  );
end;

function TpoBasicGameEngine.DispatchQueuedMessage(aMsg: TpoMessage): TpoMessage;
begin
  Result:= aMsg;
  if (aMsg = nil) then exit;
  SendResponse(aMsg.FRespGroup, aMsg.FSessionID, aMsg.FMsgBody, aMsg.FUserID, aMsg.FIncludeRequester);
end;

procedure TpoBasicGameEngine.UpdateGameStats;
var
  sStats: String;
begin
  try
    RecalculateStats();
    sStats:= PrepareStatsPacket(nil, True).XML;
    CommonDataModule.Log(ClassName, 'UpdateGameStats', sStats, ltCall);
    FAPi.SetStatses(ProcessID, sStats);
  except
  //TBD: recallthis in the futire
  end;//
end;

procedure TpoBasicGameEngine.UpdateGameStats(var sStatses: string);
begin
//
end;

procedure TpoBasicGameEngine.RecalculateStats;
begin
//TBO:
end;


function TpoBasicGameEngine.PrepareProcClosePacket(aParent: IXMLNode;
  sReason: String): IXMLNOde;
begin
  Result:= aParent.AddChild(PPTN_PROC_CLOSE);
  Result.Attributes[PPTA_REASON]:= sReason;
end;

procedure TpoBasicGameEngine.SendResponse(sRespGroup: string;
  nSessionID: Integer; sMsgBody: String; nUserID: Integer; bIncludeRequester: Boolean
);
var
  aGamer: TpoGamer;
  I, nLenUsersID, nLenSessionsID: Integer;
  aUsersID: array of integer;
  aSessionsID: array of integer;
begin
  nLenUsersID    := 0;
  nLenSessionsID := 0;
  if (sRespGroup = PPTV_REQUESTER) OR (sRespGroup = '') then begin
    if (nUserID > UNDEFINED_USER_ID) then begin
      aGamer := FTable.Gamers.GamerByUserID(nUserID);
      if (aGamer <> nil) then begin
        if not aGamer.IsBot then FApi.NotifyUserByID(nUserID, sMsgBody);
      end else begin
        if (nUserID > 0) then FApi.NotifyUserByID(nUserID, sMsgBody);
      end;
    end else begin
      aGamer := FTable.Gamers.GamerBySessionID(nSessionID);
      if (aGamer <> nil) then begin
        if not aGamer.IsBot then FApi.NotifyUser(nSessionID, sMsgBody, False);
      end else begin
        if (nSessionID > 0) then FApi.NotifyUser(nSessionID, sMsgBody, False);
      end;
    end;
  end else
  if (sRespGroup = PPTV_HAND_PARTICIPANTS) or
     (sRespGroup = PPTV_TABLE) or
     (sRespGroup = PPTV_ALL)
  then begin
    for I:= 0 to FTable.Gamers.Count - 1 do    // Iterate
    begin
      aGamer := FTable.Gamers[I];
      if aGamer.IsWatcher and not (sRespGroup = PPTV_ALL) then Continue;
      if aGamer.IsBot then Continue;
      if (aGamer.SessionID = nSessionID) AND (NOT bIncludeRequester) then Continue;
      if aGamer.UserID > UNDEFINED_USER_ID then
        Inc(nLenUsersID)
      else
        Inc(nLenSessionsID);
    end;    // for
    if (nLenUsersID <= 0) and (nLenSessionsID <= 0) then Exit;

    SetLength(aUsersID, nLenUsersID);
    SetLength(aSessionsID, nLenSessionsID);

    { filling arrays }
    nLenUsersID    := 0;
    nLenSessionsID := 0;
    for I:= 0 to FTable.Gamers.Count - 1 do    // Iterate
    begin
      aGamer := FTable.Gamers[I];
      if aGamer.IsWatcher and not (sRespGroup = PPTV_ALL) then Continue;
      if aGamer.IsBot then Continue;
      if (aGamer.SessionID = nSessionID) AND (NOT bIncludeRequester) then Continue;
      if aGamer.UserID > UNDEFINED_USER_ID then begin
        aUsersID[nLenUsersID] := aGamer.UserID;
        Inc(nLenUsersID);
      end else begin
        aSessionsID[nLenSessionsID] := aGamer.SessionID;
        Inc(nLenSessionsID);
      end;
    end;    // for

    { notify }
    if (nLenUsersID    > 0) then FApi.NotifyUsersByID(aUsersID, sMsgBody);
    if (nLenSessionsID > 0) then FApi.NotifyUsers(aSessionsID , sMsgBody);
  end;
  SetLength(aUsersID, 0);
  aUsersID := nil;
  SetLength(aSessionsID, 0);
  aSessionsID := nil;
end;

procedure TpoBasicGameEngine.SetGroupID(const Value: Integer);
begin
  FGroupID := Value;
end;

function TpoBasicGameEngine.PrepareGamerRankingPacket(aParent: IXMLNode;
  aGamer: TpoGamer): IXMLNode;
var
  lgc, hgc: TpoCardCombination;

begin
  Result:= nil;
  hgc:= aGamer.Combinations.BestCombination(True);
  if hgc = nil then Exit;

  Result:= aParent.AddChild(PPTN_RANKING);
  Result.Attributes[PPTA_POSITION]:= aGamer.ChairID;
  Result.Attributes[PPTA_MSG]:= hgc.ToString;
  Result.Attributes[PPTA_CARDS]:= hgc.FormSeries(True);

  if FCroupier.PokerType IN [PT_OMAHA_HILO, PT_SEVEN_STUD_HILO] then begin
    lgc:= aGamer.Combinations.BestCombination(False);
    if lgc = nil then Exit;
    Result.Attributes[PPTA_LO_MSG]:= lgc.FormLoSeries;
    Result.Attributes[PPTA_LO_CARDS]:= lgc.FormSeries(True);
  end;//if
end;

function TpoBasicGameEngine.GetTournamentType: TpoTournamentType;
begin
  Result:= TpoTournamentType(FProperties.PropertyByName(PP_TOURNAMENT_TYPE).AsInteger);
end;

procedure TpoBasicGameEngine.SetupCroupier(aCroupier: TpoGenericCroupier);
begin
  FCroupier:= aCroupier;
  FCroupier.CurrencySymbol := FCurrencySymbol;
end;

procedure TpoBasicGameEngine.SetCroupier(const Value: TpoGenericCroupier);
begin
  SetupCroupier(Value);
end;

procedure TpoBasicGameEngine.__lock__;
begin
  Exit;

  repeat
    FMutex:= CreateMutex(nil, False, GENERIC_ENGINE_ACTION_SYNC);
    if (FMutex = 0) OR (GetLastError <> 0) then Sleep(2)
    else Break;
  until False;
end;

procedure TpoBasicGameEngine.__unlock__;
begin
  Exit;

  CloseHandle(FMutex);
end;

procedure TpoBasicGameEngine.CheckForTournament(sAnchor: string);
begin
  if TournamentType IN [TT_NOT_TOURNAMENT] then begin
    EscalateFailure(
      EpoException,
      'Not a tournament mode',
      sAnchor
    );
  end;//
end;

function TpoBasicGameEngine.GetTableStake: Integer;
begin
  Result:= FTable.SmallBetValue;
end;

procedure TpoBasicGameEngine.SetTableStake(const Value: Integer);
begin
  FTable.SmallBetValue:= Value;
  FTable.BigBetValue:= FTable.SmallBetValue*2;
  FProperties.PropertyByName(PP_LOWER_STAKES_LIMIT).AsDouble:= Value / 100;
end;

function TpoBasicGameEngine.GetDefAmountConstraint: Currency;
var
  gp: TGameProperty;
begin
  Result := 0;

  gp := FProperties.PropertyByName(PP_DEFAULT_GAMER_AMOUNT);
  if gp <> nil then begin
    Result := StrToCurrDef(gp.FValue, 0);
  end;
end;

function TpoBasicGameEngine.GetMaxAmountConstraint: Currency;
var
  gp: TGameProperty;
begin
  Result := 0;

  gp := FProperties.PropertyByName(PP_MAXIMUM_GAMER_AMOUNT);
  if gp <> nil then begin
    Result := StrToCurrDef(gp.FValue, 0);
  end;
end;

function TpoBasicGameEngine.GetMinAmountConstraint: Currency;
var
  gp: TGameProperty;
begin
  Result := 0;

  gp := FProperties.PropertyByName(PP_MINIMUM_GAMER_AMOUNT);
  if gp <> nil then begin
    Result := StrToCurrDef(gp.FValue, 0);
  end;
end;

function TpoBasicGameEngine.GetUseAmountConstraint: Boolean;
var
  gp: TGameProperty;
begin
  Result := False;

  gp := FProperties.PropertyByName(PP_GAMER_AMOUNT_CONSTRAINT);
  if gp <> nil then begin
    if AnsiLowerCase(gp.FValue) = 'true' then Result := True;
  end;
end;

function TpoBasicGameEngine.UpdateParticipantInfo(aGamer: TpoGamer; bNeedUpdateFromDB: Boolean): TpoGamer;
var
  nUserID, nSexID: Integer;
  sUserName, sCity: string;
  nAvatarID, nImageVersion: Integer;
  nRes: Integer;
  sIP : string;
  nSessionID: Integer;
  bChatAllow: Boolean;
  nAffiliateID: Integer;
  bEmailValidated: Boolean;
  nLevelID: Integer;
  aIcons: TStringList;
  sIcon1, sIcon2, sIcon3, sIcon4: string;
begin
  Result:= aGamer;
  nUserID:= UNDEFINED_USER_ID;
  if (aGamer = nil) then begin
    CommonDataModule.Log(ClassName, 'UpdateParticipantInfo', 'Gamer is nil.', ltError);
    EscalateFailure(
      1,
      EpoSessionException,
      'Gamer is nil.',
      '{C9066EBF-7466-449F-B1AF-1A8C8D75F50B}'
    );
    Exit;
  end;

  { TODO : WARNING: Update user info by SQL is blocked when UserName <> '' }
  if (aGamer.UserName <> '') and not bNeedUpdateFromDB then begin
    Exit;
  end;
  { if Gamer is bot then no need update info }
  if aGamer.IsBot then Exit;

  if aGamer.UserID <> UNDEFINED_USER_ID then begin
    nUserID:= aGamer.UserID;

    nRes:= FApi.GetUserInfo(aGamer.UserID,
      sUserName, sCity, nSexID, nAvatarID, nImageVersion, nSessionID,
      bChatAllow, nAffiliateID, bEmailValidated, nLevelID,
      sIcon1, sIcon2, sIcon3, sIcon4
    );

    if (nRes <> NO_ERROR) then begin
      CommonDataModule.Log(ClassName, 'UpdateParticipantInfo',
        '[ERROR] On exec FApi.GetUserInfo: Result=' + IntToStr(nRes) + ', UserID=' + IntToStr(aGamer.UserID),
        ltError);
    end;

    EscalateFailure(
      nRes,
      EpoSessionException,
      '[ERROR] On exec FApi.GetUserInfo: Result=' + IntToStr(nRes) + ', UserID=' + IntToStr(aGamer.UserID),
      '{C9066EBF-7466-449F-B1AF-1A8C8D75F50B}'
    );

    aIcons := TStringList.Create;
    aIcons.Add(sIcon1);
    aIcons.Add(sIcon2);
    aIcons.Add(sIcon3);
    aIcons.Add(sIcon4);

    Result:= FTable.Gamers.UpdateGamer(
      aGamer, nSessionID, '', nUserID, sUserName, nSexID, sCity, nAvatarID, nImageVersion, sIP,
      bChatAllow, nAffiliateID, bEmailValidated, nLevelID, aIcons
    );

    aIcons.Clear;
    aIcons.Free;
  end else
  if aGamer.SessionID <> UNDEFINED_SESSION_ID then begin
    nRes:= FApi.GetParticipantInfo(aGamer.SessionID,
      nUserID, sUserName, sCity, nSexID, nAvatarID, nImageVersion, sIP,
      bChatAllow, nAffiliateID, bEmailValidated, nLevelID,
      sIcon1, sIcon2, sIcon3, sIcon4
    );

    if (nRes <> NO_ERROR) then begin
      CommonDataModule.Log(ClassName, 'UpdateParticipantInfo', '[ERROR] On exec FApi.GetUserInfo: Result=' + IntToStr(nRes) + ', UserID=' + IntToStr(aGamer.UserID),
        ltError);
    end;
    EscalateFailure(
      nRes,
      EpoSessionException,
      '[ERROR] On exec FApi.GetParticipantInfo: Result=' + IntToStr(nRes) + ', SessionID=' + IntToStr(aGamer.SessionID),
      '{7A50DF49-53D3-4DBE-993D-948E53176029}'
    );

    aIcons := TStringList.Create;
    aIcons.Add(sIcon1);
    aIcons.Add(sIcon2);
    aIcons.Add(sIcon3);
    aIcons.Add(sIcon4);

    Result:= FTable.Gamers.UpdateGamer(
      aGamer, nSessionID, '', nUserID, sUserName, nSexID, sCity, nAvatarID, nImageVersion, sIP,
      bChatAllow, nAffiliateID, bEmailValidated, nLevelID, aIcons
    );

    aIcons.Clear;
    aIcons.Free;
  end;//if
end;

procedure TpoBasicGameEngine.SetTournamentID(const Value: Integer);
begin
  FTournamentID := Value;
end;

function TpoBasicGameEngine.PrepareFinishTournamentHandPacket(
  aParent: IXMLNode; vInfo: Variant): IXMLNode;
var
  I: Integer;
  pn: IXMLNode;
  aGamer: TpoGamer;
begin
  if aParent <> nil then Result:= aParent.AddChild(PPTN_FINISH_TOURNAMENT_HAND)
  else Result:= FResponseRoot.AddChild(PPTN_FINISH_TOURNAMENT_HAND);

  Result.Attributes[PPTA_TOURNAMENT_ID] := TournamentID;
  Result.Attributes[PPTA_PROCESS_ID]    := ProcessID;
  Result.Attributes[PPTA_TOURNAMENT_STACK] := FloatToStrF(FTable.SourcePot, ffFixed, 12, 2);
  Result.Attributes[PPTA_TOURNAMENT_FINISH_STAMP]:= FloatToStr(Now());
  Result.Attributes[PPTA_SEQ_ID]        :=
    (FCroupier as TpoGenericTournamentCroupier).FTournamentSeqID;

  for I:= 0 to Table.Chairs.Count-1 do begin
    aGamer := Table.Chairs[I].Gamer;

    if (aGamer = nil)  then Continue;
    if (aGamer.FinishedTournament)  then Continue;
    if aGamer.IsWatcher then Continue;

    if (aGamer.Account.Balance <= 0) then begin
      Table.Gamers.AllInsCount:= Table.Gamers.AllInsCount+1;
      aGamer.AllInOrder:= Table.Gamers.AllInsCount;
    end;//if

    if (aGamer.Account.Balance > 0) and (not aGamer.KickOffFromTournament) then begin
      pn:= Result.AddChild(PPTN_PLAYER);
      pn.Attributes[PPTA_USER_ID]  := aGamer.UserID;
      pn.Attributes[PPTA_PLACE]    := aGamer.ChairID;
      pn.Attributes[PPTA_MONEY]    := FormatFloat('0.##', FCroupier.NormalizeAmount(aGamer.Account.Balance));
    end else begin
      pn:= Result.AddChild(PPTN_LOST);
      pn.Attributes[PPTA_USER_ID]  := aGamer.UserID;
      pn.Attributes[PPTA_PLACE]    := aGamer.ChairID;
      pn.Attributes[PPTA_BALANCE_BEFORE_HAND]:= FloatToStr(aGamer.BalanceBeforeLastHand);
    end;//if
    pn.Attributes[PPTA_IS_TAKED_SIT] := Integer(aGamer.IsTakedSit);
    pn.Attributes[PPTA_BOT_BLAFFERS] := aGamer.BotBlaffersEvent;
  end;//for
end;

function TpoBasicGameEngine.FormatAmount(nAmount: Integer; nCurrencyCode: Integer): String;
var
  sMask: String;
begin
  if Frac(nAmount/100) = 0 then sMask:= '0.##'
  else sMask:= '0.#0';
  Result:= FCurrencySymbol + FormatFloat(sMask, FCroupier.NormalizeAmount(nAmount));
end;//

function TpoBasicGameEngine.ScheduleSecIntervalEx(
  sReminderTemplate, sTargetSubsystemName: String; nInterval: Integer;
  aAction: IXMLNode; NeedAddingToList: Boolean
): TpoReminder;
var
  im: TDateTime;
  sRemindID, sData: string;
  nRes: Integer;
begin
  im := IncSecond(Now, nInterval);
  sData := PrepareSchedulerPacketEx(sReminderTemplate, sTargetSubsystemName, aAction).XML;
  if (nInterval > 0) then begin
    nRes:= FAPi.CreateRemind(0, ProcessID, im, sData, sRemindID)
  end else begin
    nRes := 0;
    sRemindID := '{50922A23-EE50-4187-8A16-90B8523FD1B3}';
  end;

  EscalateFailure(
    nRes,
    EpoException,
    '',
    '{F49430E3-1FE9-414E-BBD5-9F9D193C397F}'
  );

  Result:= nil;
  if NeedAddingToList then
    Result:= FReminders.AddReminder(aAction.NodeName, sRemindID, sData, im, 0);
end;

function TpoBasicGameEngine.PrepareSchedulerPacketEx(
  sReminderTemplate, sTargetSubsystemName: string; aAction: IXMLNode): IXMLNode;
var
  sn: IXMLNode;
begin
  if sReminderTemplate = PPTT_TOURNAMENT_SCHEDULER_PACKET then begin
(*
    '<objects>'+
    '  <object name="%s">'+
               '%s'+
    '  </object>'+
    '</objects>'+
*)
    Result:= FResponseRoot.AddChild(PPTN_OBJECTS);
    sn:= Result.AddChild(PPTN_OBJECT);
    sn.Attributes[PPTA_NAME]:= sTargetSubsystemName;
    sn.ChildNodes.Add(aAction.CloneNode(True));
    sn:= nil;
  end else begin
    Result:= FResponseRoot.AddChild(PPTN_OBJECTS);
    sn:= Result.AddChild(PPTN_OBJECT);
    sn.Attributes[PPTA_NAME]:= sTargetSubsystemName;
    sn:= sn.AddChild(PPTN_GAME_ACTION);
    sn.Attributes[PPTA_PROCESS_ID]:= ProcessID;
    sn.ChildNodes.Add(aAction.CloneNode(True));
    sn:= nil;
  end;//
end;

function TpoBasicGameEngine.PrepareGamerActionPacket(aParent: IXMLNode;
  aGamer: TpoGamer; nAction: TpoGamerAction; nStake: Integer): IXMLNOde;
begin
  Result:= PrepareGamerActionPacket(aParent, aGamer, nAction);
  Result.Attributes[PPTA_STAKE] := FormatFloat('0.##', FCroupier.NormalizeAmount(nStake));
end;

function TpoBasicGameEngine.SetupGamerActionTimeout(
  aGamer: TpoGamer;
  nActions: TpoGamerActions;
  nTimeout: Integer;
  bRegular: Boolean
  ): TpoReminder;
var
  n: IXMLNode;
begin
  //remove previous action for same game
  DeleteGamerActionTimeout(aGamer, GA_NONE);

  n:= FResponseRoot.AddChild(PPTN_TIMER_EVENT);
  n.Attributes[PPTA_NAME]:= PPTV_GAMER_ACTION;
  n.Attributes[PPTA_HAND_ID]:= IntToStr(Table.Hand.HandID);
  n.Attributes[PPTA_USER_ID]:= IntToStr(aGamer.UserID);
  n.Attributes[PPTA_REGULAR_TIMEOUT]:= IntToStr(Integer(bRegular));
  Table.Hand.IncHandAction();
  n.Attributes[PPTA_ACTION_SEQ_ID]:= Table.Hand.HandActionSeqID;

  Result:= ScheduleSecIntervalEx(PPTT_SCHEDULER_PACKET_EX, PPTV_GAME_ADAPTOR, nTimeout, n, True);
  Result.UserID:= aGamer.UserID;
  Result.GamerActions:= nActions;
end;

procedure TpoBasicGameEngine.DeleteGamerActionTimeout(aGamer: TpoGamer;
  nAction: TpoGamerAction);
var
  rm: TpoReminder;
begin
  if aGamer = nil then Exit;
  aGamer.RegularTimeoutExpired:= False;
  aGamer.RegularTimeoutActivated:= False;
  aGamer.ActivateTimeBank:= False;
  rm:= FReminders.GetReminderByUserIDAndName(aGamer.UserID, PPTN_TIMER_EVENT);

  if aGamer.TimeBankActivated then begin
    CommonDataModule.Log(ClassName, 'DeleteGamerActionTimeout',
      'Reminder stamp: '+FormatDateTime('hh:nn:ss.zzz', rm.FRemindTime), ltCall);
    CommonDataModule.Log(ClassName, 'DeleteGamerActionTimeout',
      'Action Activation stamp: '+FormatDateTime('hh:nn:ss.zzz', FActionActivation), ltCall);
    aGamer.TournamentTimebank:= SecondsBetween(FActionActivation, rm.FRemindTime) + 1;
    if (FActionActivation > rm.FRemindTime) then aGamer.TournamentTimebank := - aGamer.TournamentTimebank;
    if aGamer.TournamentTimebank < 0  then aGamer.TournamentTimebank:= 0;
    if aGamer.TournamentTimebank > GT_GAMER_TOURNAMENT_TIMEBANK then aGamer.TournamentTimebank:= GT_GAMER_TOURNAMENT_TIMEBANK;
    aGamer.TimeBankActivated:= False;
  end;//if

  if (rm <> nil) then begin
    DeleteInterval(rm.ReminderID);
  end;//if
end;

var
  nActionNamesMap: Array [TpoGamerAction] of String = (
  //async
    PPTV_SIT_OUT,
    PPTV_WAIT_BB,
    PPTV_BACK,
    PPTV_LEAVE_TABLE,
  //ordered actions
    PPTV_POST_SB,
    PPTV_POST_BB,
    PPTV_ANTE,
    PPTV_POST,
    PPTV_POST_DEAD,
    PPTV_FOLD,
    PPTV_CHECK,
    PPTV_BET,
    PPTV_CALL,
    PPTV_RAISE,
    PPTV_SHOW_CARDS,
    PPTV_SHOW_CARDS_SHUFFLED,
    PPTV_MUCK,
    PPTV_DONT_SHOW,
    PPTV_DISCARD_CARDS,
    PPTV_BRING_IN,

  //surrogate
    PPTV_TURN_CARDS_OVER,
    PPTV_ALL_IN,
  //
    PPTV_USE_TIMEBANK,
  //stub
    PPTV_NONE
  );

function TpoBasicGameEngine.ActionNameToGamerAction(
  sName: string): TpoGamerAction;
var
  I: TpoGamerAction;
begin
  Result:= GA_NONE;
  for I:= GA_SIT_OUT to GA_NONE do begin
    if nActionNamesMap[I] = sName then begin
      Result:= I;
      Exit;
    end;//
  end;//for
end;

function TpoBasicGameEngine.GamerActionToActionName(
  nAction: TpoGamerAction): String;
begin
  Result:= nActionNamesMap[nAction];
end;


function TpoBasicGameEngine.PrepareGamerActionPacket(aParent: IXMLNode;
  aGamer: TpoGamer; nAction: TpoGamerAction): IXMLNOde;
var
  s: String;
begin
  if aParent <> nil then Result:= aParent.AddChild(PPTN_GAMER_ACTION)
  else Result:=  FResponseRoot.AddChild(PPTN_GAMER_ACTION);

  Result.Attributes[PPTA_POSITION]:= aGamer.ChairID;
  Result.Attributes[PPTA_NAME]    := GamerActionToActionName(nAction);
  Result.Attributes[PPTA_HAND_ID] := FTable.Hand.HandID;

  if NOT (nAction IN SHOW_DOWN_ACTIONS) then begin
    if Table.Hand.State = HST_RUNNING then
      Result.Attributes[PPTA_BET]     := FormatFloat('0.##', FCroupier.NormalizeAmount(aGamer.Bets))
    else
      Result.Attributes[PPTA_BET]     := 0;
  end;//if

  if NOT (nAction IN [GA_SHOW_CARDS, GA_SHOW_CARDS_SHUFFLED, GA_DONT_SHOW, GA_MUCK])
  then Result.Attributes[PPTA_BALANCE] := FormatFloat('0.##', FCroupier.NormalizeAmount(aGamer.Account.Balance));

  if nAction in [GA_SHOW_CARDS, GA_SHOW_CARDS_SHUFFLED, GA_TURN_CARDS_OVER] then begin
    Result.Attributes[PPTA_CARDS]   := aGamer.Cards.FormSeries(True);
  end;//if

//add ranking
  if nAction in [GA_SHOW_CARDS, GA_SHOW_CARDS_SHUFFLED] then begin
    if aGamer.Combinations.Count > 0 then begin
      s:= aGamer.Combinations.Bestcombination(True).ToString;

      if aGamer.Combinations.Bestcombination(True).Description <> '' then s:= s+' - '+
        aGamer.Combinations.Bestcombination(True).Description;

      Result.Attributes[PPTA_HI_RANK]:= s;
      Result.Attributes[PPTA_HI_RANK_CARDS]:=
        aGamer.Combinations.Bestcombination(True).FormSeries(True);

      if (FCroupier.PokerType IN [PT_OMAHA_HILO, PT_SEVEN_STUD_HILO]) AND
        (aGamer.Combinations.Bestcombination(False) <> nil) then
      begin
        s:= aGamer.Combinations.Bestcombination(False).ToString;
        Result.Attributes[PPTA_LO_RANK]:= s;
        Result.Attributes[PPTA_LO_RANK_CARDS]:=
          aGamer.Combinations.Bestcombination(False).FormSeries(True);
      end;//if
    end;//if
  end;//if
end;

function TpoBasicGameEngine.PrepareGamerActionPacket(aParent: IXMLNode;
  aGamer: TpoGamer; nAction: TpoGamerAction; nPostStake, nPostDeadStake: Integer): IXMLNOde;
begin
  Result:= PrepareGamerActionPacket(aParent, aGamer, nAction);
  if (nPostStake >= 0) then
    Result.Attributes[PPTA_STAKE]   := FormatFloat('0.##', FCroupier.NormalizeAmount(nPostStake));
  if (nPostDeadStake >= 0) then
    Result.Attributes[PPTA_DEAD]    := FormatFloat('0.##', FCroupier.NormalizeAmount(nPostDeadStake));
end;

function TpoBasicGameEngine.HandleEventGamerActionExpired(
  nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
  nActionSeqID: Integer;
  nUserID: Integer;
  bReminderWasFound: Boolean;
begin
  Result:= nil;
  nUserID := StrToIntDef(aActionInfo.Attributes[PPTA_USER_ID], -1);
  bReminderWasFound := DeleteIntervalByUserIDAndName(nUserID);

  g:= Table.Gamers.GamerByUserID(nUserID);

  nActionSeqID:= aActionInfo.Attributes[PPTA_ACTION_SEQ_ID];
  if nActionSeqID <> FTable.Hand.HandActionSeqID then begin
    Exit;
  end;//

  if g = nil then Exit;//gamer left current process
  if bReminderWasFound then begin
    if (FTable.Hand.ActiveGamer = nil) OR (FTable.Hand.ActiveGamer <> g) then Exit;
    if Table.Hand.State <> HST_RUNNING then Exit;

    if g.RegularTimeoutActivated then g.RegularTimeoutExpired:= True;

    if g.ActivateTimeBank AND (g.TournamentTimebank > 0) AND (NOT  g.TimeBankActivated) then begin
      OnChatMessage('Regular time for player '+g.UserName+' has expired, TIME BANK has been activated');
      OnGamerAction(g, GA_USE_TIMEBANK, []);
    end else begin
      if g.TimeBankActivated then g.TournamentTimebank:= 0;
      g.TimeBankActivated       := False;
      g.RegularTimeoutActivated := False;
      g.RegularTimeoutExpired   := False;
      FCroupier.HandleGamerActionExpired(g);
      PostProcessGamerActionExpired(g);
    end;//if
  end;//
end;

function TpoBasicGameEngine.CheckActionOnHandIDContext(nSessionID: Integer; aActionInfo: IXMLNode): Boolean;
var
  nHandID: Integer;
begin
  Result := True;
  if aActionInfo.HasAttribute(PPTA_HAND_ID) then begin
    nHandID:= aActionInfo.Attributes[PPTA_HAND_ID];
    Result := (nHandID = FTable.Hand.HandID);
    if not Result then begin
      Result := False;
      CommonDataModule.Log(ClassName, 'CheckActionOnHandIDContext',
        'User action context (SessionID: ' + IntToStr(nSessionID) +
          '; HandID: '+IntToStr(nHandID) +
          '; CurrHandID: ' + IntToStr(Table.Hand.HandID) +
          ') does not correspond current hand'
        , ltError);
      EscalateFailure(
        EpoUnexpectedActionException,
        'User action context (HandID: '+IntToStr(nHandID)+') does not correspond current hand',
        '{E7B0626B-AC6A-499A-855F-EE5A1F3F8943}'
      );
    end;//if
  end;//
end;

function TpoBasicGameEngine.CheckActionAgainstHandContext(
  nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode; bValidForRunningHand, bValidateStepRight: Boolean): TpoGamer;
begin
  if nSessionID = UNDEFINED_SESSION_ID then begin
    Result:= nil;
    CommonDataModule.Log(ClassName, 'CheckActionAgainstHandContext',
      'Undefined session on action context (SessionID: ' + IntToStr(nSessionID) +
        '; CurrHandID: ' + IntToStr(FTable.Hand.HandID)
      , ltError);
    EscalateFailure(
      EpoUnexpectedActionException,
      'Undefined session on action context (HandID: '+IntToStr(FTable.Hand.HandID)+')',
      '{E7B0626B-AC6A-499A-855F-EE5A1F3F8943}'
    );
  end else begin
    Result:= GetActionGamer(nSessionID, nUserIDAttr, bValidateStepRight, False);
    DeleteGamerActionTimeout(Result, ActionNameToGamerAction(aActionInfo.Attributes[PPTA_NAME]));
  end;

  if bValidForRunningHand then begin //action is hand sensitive
    if (FTable.Hand.State = HST_RUNNING) then begin
      CheckActionOnHandIDContext(nSessionID, aActionInfo);
    end else begin
    Exit;
      CommonDataModule.Log(ClassName, 'CheckActionAgainstHandContext',
        'Hand state is not running. (SessionID: ' + IntToStr(nSessionID) +
          '; HandState: ' + FTable.Hand.StateAsString +
          '; CurrHandID: ' + IntToStr(FTable.Hand.HandID)
        , ltError);
      EscalateFailure(
        EpoUnexpectedActionException,
        'Hand state is not running (HandID: '+IntToStr(Table.Hand.HandID)+')',
        '{E7B0626B-AC6A-499A-855F-EE5A1F3F8943}'
      );
    end;
  end;
end;//TpoBasicGameEngine.HandleEventGamerActionExpired


procedure TpoBasicGameEngine.PushHistoryEntry(nsessionID: Integer;
  NodeBody: IXMLNode);
var
  aMsg: TpoMessage;
  nPause: Integer;
begin
  nPause := 0;
  if (FHistoryList.Count > 0) then begin
    aMsg := FHistoryList.Items[FHistoryList.Count - 1];
    nPause := MilliSecondsBetween(aMsg.FTime, Now);
  end;

  if (FTable.Hand.HandID <> UNDEFINED_HAND_ID) AND (FTable.Hand.State IN [HST_RUNNING, HST_FINISHED]) then begin
    NodeBody.Attributes[PPTA_TIME] := Now;
    NodeBody.Attributes[PPTA_PAUSE] := nPause;
    aMsg := TpoMessage.Create(FHistoryList, '', nSessionID, NodeBody.XML);
    FHistoryList.PushMessage(aMsg);
  end;
end;

procedure TpoBasicGameEngine.SendHistories(sBody: String);
begin
  EscalateFailure(
    FApi.CreateActionLogOnFinishHand(FTable.Hand.HandID, sBody),
    EpoException,
    '',
    '{952C564F-B5C5-462A-B432-148E0080C642}'
  );
end;

function TpoBasicGameEngine.FlushHistoryQueue: Integer;
var
  msg: TpoMessage;
  sMessages: string;
  bNeedStoringHistory: Boolean;
  sOptionData: string;
  nConfigData: Integer;
  nRes: Integer;
  I: Integer;
  aGamer: TpoGamer;
begin
  Result:= 0;
  sMessages := '';
  for I:=0 to FHistoryList.Count - 1 do begin
    msg:= FHistoryList.Items[I];
    sMessages := sMessages + msg.MsgBody;
    Inc(Result);
  end;//while
  FHistoryList.Clear;

  sOptionData := '0';
  nRes := FApi.GetSystemOption(ID_STORING_GAMELOG_WITH_BOTSONLY, sOptionData);
  if (nRes <> NO_ERROR) then begin
    CommonDataModule.Log(ClassName, 'FlushHistoryQueue',
      '[ERROR] On execute FApi.GetSystemOption: Result=' + IntToStr(nRes) +
      '; Params: OptionID=' + IntToStr(ID_STORING_GAMELOG_WITH_BOTSONLY) + '.',
      ltError);
    sOptionData := '0';
  end;
  nConfigData := StrToIntDef(sOptionData, 0);

  if (nConfigData <= 0) then begin
    bNeedStoringHistory := False;
    for I:=0 to FTable.Chairs.Count - 1 do begin
      aGamer := FTable.Chairs[I].Gamer;
      if (aGamer = nil) then Continue;
      if aGamer.IsBot then Continue;

      bNeedStoringHistory := True;
      Break;
    end;
  end else begin
    bNeedStoringHistory := True;
  end;

  if bNeedStoringHistory then SendHistories(sMessages);
end;

procedure TpoBasicGameEngine.DeleteGamerReservationTimeout(
  aGamer: TpoGamer);
var
  rm: TpoReminder;
begin
  if aGamer = nil then Exit;
  rm:= FReminders.GetReminderByUserIDAndName(aGamer.UserID, PPTN_TIMER_EVENT);
  if (rm <> nil) then begin
    DeleteInterval(rm.ReminderID);
  end;//if
end;

procedure TpoBasicGameEngine.DeleteGamerReservationTimeout(
  nUserID: Integer);
var
  rm: TpoReminder;
begin
  if nUserID <= UNDEFINED_USER_ID then Exit;
  rm:= FReminders.GetReminderByUserIDAndName(nUserID, PPTN_TIMER_EVENT);
  if (rm <> nil) then begin
    DeleteInterval(rm.ReminderID);
  end;//if
end;

function TpoBasicGameEngine.SetupGamerReservationTimeout(
  nChairID, nUserID, nSessionID, nTimeout: Integer): TpoReminder;
var
  n: IXMLNode;
begin
  n:= FResponseRoot.AddChild(PPTN_TIMER_EVENT);
  n.Attributes[PPTA_NAME]:= PPTV_GAMER_RESERVATION;
  n.Attributes[PPTA_USER_ID]:= IntToStr(nUserID);
  n.Attributes[PPTA_POSITION_ID]:= IntToStr(nChairID);
  n.Attributes[PPTA_SESSION_ID]:= IntToStr(nSessionID);

  Result:= ScheduleSecIntervalEx(PPTT_SCHEDULER_PACKET_EX, PPTV_GAME_ADAPTOR, nTimeout, n, True);
  Result.UserID:= nUserID;
end;//TpoBasicGameEngine.SetupGamerReservationTimeout


function TpoBasicGameEngine.PrepareWLTakePlacePacket(nTimeOut: Integer): IXMLNode;
var
  wln: IXMLNode;
  nGamsersCnt, nWatchersCnt: Integer;
begin
(*
<object name="process">
  <wltakeplace processid="1213" timeout="200" playerscount="7"
   processname="Holdem 'Green Beach' table 3/6"/>
</object>
*)
  FTable.Gamers.CalcGamerStats(nGamsersCnt, nWatchersCnt);
  //'<object name="process"/>';
  Result:= FResponseRoot.AddChild(PPTN_OBJECT);
  Result.Attributes[PPTA_NAME]:= PPTV_PROCESS;

  wln:= Result.AddChild(PPTN_TAKE_PLACE);
  wln.Attributes[PPTA_PROCESS_ID]:= ProcessID;
  wln.Attributes[PPTA_TIMEOUT]:= nTimeOut;
  wln.Attributes[PPTA_PLAYERS_COUNT]:= nGamsersCnt;
  wln.Attributes[PPTA_PROCESS_NAME]:= ProcessName;
end;

function TpoBasicGameEngine.PrepareWLCancelPacket: IXMLNode;
var
  wln: IXMLNode;
begin
(*
<object name="process">
  <wlcancel processid="1213"/>
</object>
*)
  Result:= FResponseRoot.AddChild(PPTN_OBJECT);
  Result.Attributes[PPTA_NAME]:= PPTV_PROCESS;
  wln:= Result.AddChild(PPTN_WL_CANCEL);
  wln.Attributes[PPTA_PROCESS_ID]:= ProcessID;
end;


function TpoBasicGameEngine.CheckAndHandleReservations: Boolean;
begin
  Result:= True;
end;

procedure TpoBasicGameEngine.HandleCachedPackets;
var
  nGamersCnt,
  nWatchersCnt: Integer;
  nRes: Integer;
  aOper: TpoApiSuspendedOperation;
  aHandOper: TpoHandAndRakesSuspendedOperation;
  wsComment, sData: string;
begin
  while (FApiSuspendedOperations.Count > 0) do begin
    aOper := FApiSuspendedOperations.Items[0];
    case aOper.FTypeOperation of
      SO_RegisterParticipant:
      begin
        nRes := FApi.RegisterParticipant(ProcessID, aOper.FSessionID, aOper.FUserID, aOper.FChairID);
        { check on error }
        if (nRes <> NO_ERROR) and (aOper.FTypeOperation = SO_RegisterParticipant)  then begin
          sData := '[ERROR] On execute FApi.RegisterParticipant, result=' + IntToStr(nRes) +
            '; Params: ProcessID=' + IntToStr(ProcessID) +
            ', SessionID=' + IntToStr(aOper.FSessionID) +
            ', UserID=' + IntToStr(aOper.FUserID) +
            ', ChairID=' + IntToStr(aOper.FChairID);
          DumpCachedStateToFile(FStateManager.CachedState);
          CommonDataModule.Log(ClassName, 'HandleCachedPackets', sData, ltError);

          Exit;
        end;
      end;
      SO_UnRegisterParticipant:
      begin
        FApi.UnregisterParticipant(ProcessID, aOper.FSessionID, aOper.FUserID, aOper.FChairID);
      end;
      SO_UpdateParticipantCount:
      begin
        FTable.Gamers.CalcGamerStats(nGamersCnt, nWatchersCnt);
        FApi.SetParticipantCount(ProcessID, nGamersCnt, nWatchersCnt);
      end;
    end;

    FApiSuspendedOperations.Remove(aOper);
  end;

  { hand result and user rakes packets }
  while (FApiHandAndRakesSuspendedOperations.Count > 0) do begin
    aHandOper := FApiHandAndRakesSuspendedOperations.Items[0];
    sData := aHandOper.GetXMLAsString;
    nRes := NO_ERROR;
    if sData <> '' then begin
      case aHandOper.FTypeOperation of
        HRSO_HandResult:
        begin
          wsComment := 'Hand Result';
          CommonDataModule.Log(ClassName, 'HandleCachedPackets', 'Hand Result=[' + sData + ']', ltCall);
          nRes:= FApi.HandResult(ProcessID, aHandOper.FHandID, wsComment, sData);
        end;
        HRSO_UserRakes:
        begin
          CommonDataModule.Log(ClassName, 'HandleCachedPackets', 'User Rakes=[' + sData + ']', ltCall);
          nRes:= FApi.HandResultUserRakes(Table.Hand.HandID, sData);
        end;
      end;

      { check on error }
      if (nRes <> NO_ERROR) then begin
        FApiHandAndRakesSuspendedOperations.Clear;
        EscalateFailure(nRes, EpoException, '', '{C3651902-6D11-447E-84E7-282A7D592E5A}');
        Exit;
      end;
    end;

    FApiHandAndRakesSuspendedOperations.Remove(aHandOper);
  end;
end;

function TpoBasicGameEngine.GetTournamentBuyIn: Integer;
begin
  Result:= Trunc(FProperties.PropertyByName(PP_ST_TOURNAMENT_BUY_IN).AsDouble * 100);
end;

function TpoBasicGameEngine.GetTournamentChips: Integer;
begin
  Result:= Trunc(FProperties.PropertyByName(PP_ST_TOURNAMENT_CHIPS).AsDouble * 100);
end;

function TpoBasicGameEngine.GetTournamentFee: Integer;
begin
  Result:= Trunc( FProperties.PropertyByName(PP_ST_TOURNAMENT_FEE).AsDouble * 100 );
end;

function TpoBasicGameEngine.PrepareSTTournamentReservationPacket(
  aParent: IXMLNode; aGAmer: TpoGamer): IXMLNode;
begin
  if aParent <> nil then Result:= aParent.AddChild(PPTN_ST_TOURNAMENT_RESERVE)
  else Result:= FResponseRoot.AddChild(PPTN_ST_TOURNAMENT_RESERVE);

  Result.Attributes[PPTA_PROCESS_ID]:= ProcessID;
  Result.Attributes[PPTA_USER_ID]   := aGamer.UserID;
  Result.Attributes[PPTA_BUYIN]     := FloatToStr( (TournamentBuyIn+TournamentFee) / 100 );
end;

function TpoBasicGameEngine.PrepareSTTournamentPrizePacket: string;
var
  I: Integer;
  nPrizeFoundAmount: Integer;
  nFeeFoundAmount: Integer;
  nPlace: Integer;
  aGamer: TpoGamer;

begin
  {
    <singletournamentprize processid="..."  fee="BuyInRake * ChairCount">
       <user userid="111" prize="50"  comment="..."/>
       <user userid="222" prize="30"  comment="..."/>
       <user userid="333" prize="20"  comment="..."/>
    </singletournamentprize>
  }
  Result :=
    '<' + PPTN_ST_TOURNAMENT_PRIZE + ' ' +
      PPTA_PROCESS_ID     + '="' + IntToStr(ProcessID) + '" ' +
      PPTA_TOURNAMENT_FEE + '="' + FormatFloat('0.##', FCroupier.NormalizeAmount(TournamentFee*Table.Chairs.Count)) + '">';

  nPrizeFoundAmount:= TournamentBuyIn*Table.Chairs.Count;
  for I:= 0 to Table.Chairs.Count-1 do begin
    aGamer := Table.Chairs[I].Gamer;
    if aGamer = nil then Continue;
    if aGamer.IsBot then Continue;
    if (aGamer.TournamentPrizePercentage <= 0) and
       (aGamer.TournamentPrizeBonus <= 0)
    then Continue;

    Result := Result +
      '<' + PPTN_USER + ' ' +
        PPTA_USER_ID + '="' + IntToStr(aGamer.UserID) + '"';
    { base prize }
    if aGamer.TournamentPrizePercentage > 0 then begin
      if (TournamentBasePaymentType = TPT_PERCENT) then begin
        Result := Result + ' ' +
          PPTA_TOURNAMENT_PRIZE + '="' + FormatFloat('0.##', FCroupier.NormalizeAmount(nPrizeFoundAmount) * aGamer.TournamentPrizePercentage / 100) + '"';
      end else begin
        Result := Result + ' ' +
          PPTA_TOURNAMENT_PRIZE + '="' + FloatTostr(aGamer.TournamentPrizePercentage) + '"';
      end;
    end;//if
    { bonus prize }
    if aGamer.TournamentPrizeBonus > 0 then begin
      if (TournamentBonusPaymentType = TPT_PERCENT) then begin
        Result := Result + ' ' +
          PPTA_TOURNAMENT_BONUSPRIZE + '="' + FormatFloat('0.##', FCroupier.NormalizeAmount(nPrizeFoundAmount) * aGamer.TournamentPrizeBonus / 100) + '"';
      end else begin
        Result := Result + ' ' +
          PPTA_TOURNAMENT_BONUSPRIZE + '="' + FloatTostr(aGamer.TournamentPrizeBonus) + '"';
      end;
    end;//if

    Result := Result + ' ' +
      PPTA_COMMENT + '="Single tournament prize for';
    nPlace := aGamer.TournamentPlace;
    case nPlace of
      1: Result := Result + ' 1st place."';
      2: Result := Result + ' 2nd place."';
      3: Result := Result + ' 3rd Place."';
    else
      Result := Result + ' ' + IntToStr(nPlace) + 'th Place."';
    end;

    Result := Result + '/>';
  end;//for

  // adding fee node (new - for affiliate)
  nFeeFoundAmount:= TournamentFee*Table.Chairs.Count;
  Result := Result +
      '<' + PPTN_FEE + ' ' + PPTA_PROCESS_ID + '="' + IntToStr(ProcessID) + '">' +
        AddingAffiliateFeeNodesAsString(nFeeFoundAmount) +
      '</' + PPTN_FEE + '>' +
    '</' + PPTN_ST_TOURNAMENT_PRIZE + '>';
end;

function TpoBasicGameEngine.PrepareSTTournamentUserRakes: string;
var
  I: Integer;
  g: TpoGamer;
begin
  for I:= 0 to Table.Chairs.Count-1 do begin
    g := Table.Chairs[I].Gamer;
    if g = nil then Continue;
    if g.IsBot then Continue;

    Result :=
      '<' + PPTN_USER + ' ' +
        PPTA_ID         + '="' + IntToStr(g.UserID) + '" ' +
        PPTA_AMOUNT     + '="' + FormatFloat('0.##', FCroupier.NormalizeAmount(TournamentBuyIn + TournamentFee)) + '" ' +
        PPTA_TOTAL_RAKE + '="' + FormatFloat('0.##', FCroupier.NormalizeAmount(TournamentFee * Table.Chairs.Count)) + '" ' +
        PPTA_RAKE_AMOUNT+ '="' + FormatFloat('0.##', FCroupier.NormalizeAmount(TournamentFee)) + '"' +
      '/>';

    FApiHandAndRakesSuspendedOperations.Add(HRSO_UserRakes, FTable.Hand.HandID, Result, True, 'Single Table User Rakes.');
  end;//for
end;

procedure TpoBasicGameEngine.PostProcessGamerActionExpired(aGamer: TpoGamer);
begin
//TBO
end;

function TpoBasicGameEngine.PrepareSTTournamentUnreservationPacket(aGAmer: TpoGamer): string;
begin
  Result :=
    '<' + PPTN_ST_TOURNAMENT_UNRESERVE + ' ' +
      PPTA_PROCESS_ID + '="' + IntToStr(ProcessID)     + '" ' +
      PPTA_USER_ID    + '="' + IntToStr(aGamer.UserID) + '" ' +
      PPTA_BUYIN      + '="' + FloatToStr( (TournamentBuyIn+TournamentFee) / 100 ) + '"' +
    '/>';
end;


var
  nAutoActionNamesMap: Array [TpoGamerAutoAction] of String = (
  //one turn
    PPTV_AUTO_FOLD,
    PPTV_AUTO_CHECK,
    PPTV_CHECK_OR_FOLD,
    PPTV_CHECK_OR_CALL,
    PPTV_AUTO_BET,
    PPTV_AUTO_RAISE,
    PPTV_AUTO_CALL,
    PPTV_BET_OR_RAISE,

  //persistent
    PPTV_POST_BLINDS,
    PPTV_POST_ANTE,
    PPTV_MUCK_LOSING_HANDS,
    PPTV_SITOUT_NEXT_HAND,
    PPTV_AUTO_WAIT_BB,

  //
    PPTV_AUTO_LEAVE_TABLE,
  //stub
    PPTV_NONE
  );

function TpoBasicGameEngine.AutoActionNameToGamerAutoAction(
  sName: string): TpoGamerAutoAction;
var
  I: TpoGamerAutoAction;
begin
  Result:= GAA_NONE;
  for I:= GAA_AUTO_FOLD to GAA_NONE do begin
    if nAutoActionNamesMap[I] = sName then begin
      Result:= I;
      Exit;
    end;//
  end;//for
end;

function TpoBasicGameEngine.GamerAutoActionToAutoActionName(
  nAutoAction: TpoGamerAutoAction): String;
begin
  Result:= nAutoActionNamesMap[nAutoAction];
end;

function TpoBasicGameEngine.PrepareGamerPopUpPacket(aParent: IXMLNode;
  sCaption: String; aGamer: TpoGamer; sText: String; nType: Integer): IXMLNOde;
begin
  if aParent <> nil then Result:= aParent.Addchild(PPTN_GAMER_MESSAGE)
  else Result:= FResponseRoot.AddChild(PPTN_GAMER_MESSAGE);
  Result.Attributes[PPTA_CAPTION]:= sCaption;
  Result.Attributes[PPTA_TEXT]:= sText;
  Result.Attributes[PPTA_MSG_TYPE]:= IntToStr(nType);
end;

function TpoBasicGameEngine.PrepareTurnCardsOverPacket(aParent: IXMLNode;
  aGamer: TpoGamer): IXMLNode;
begin
  Result:= PrepareGamerActionPacket(aParent, aGamer, GA_TURN_CARDS_OVER);
end;

function TpoBasicGameEngine.PrepareFinalPotPacket(
  aParent: IXMLNode; nPotID: Integer; sContext: String): IXMLNOde;
var
  nTxID: Integer;
  pn, wn, cn: IXMLNode;
  tr: TpoTransaction;
  g: TpoGamer;

  function FormatWinnerAmount(nAmount: Currency; nCurrencyCode: Integer): String;
  var
    sMask: String;
  begin
    if Frac(nAmount) = 0 then sMask:= '0.##'
    else sMask:= '0.#0';
    Result:= FormatFloat(sMask, nAmount);
    if TournamentType = TT_NOT_TOURNAMENT then begin
      Result:= FCurrencySymbol + Result;
    end else begin
      Result:= Result+' chips';
    end;//if
  end;//

  function FormWinnerMessage(
    aGamer: TpoGamer;
    bIsSingleWinner: Boolean;
    bSinglePotMode: Boolean;
    nAmount: Currency;
    nPotID: Integer;
    bHiNomination: Boolean;
    bIsCongratulation: Boolean): String;

  begin
    if FCroupier.WinnerCandidatesCount > 1 then begin
      Result:= aGamer.UserName;
      if bIsSingleWinner then Result:= Result+' wins'
      else Result:= Result+' ties';

      if Croupier.PokerType IN [PT_OMAHA_HILO, PT_SEVEN_STUD_HILO] then begin
        if bHiNomination then Result:= Result+' Hi'
        else Result:= Result+' Lo';
      end;//if

      if NOT bSinglePotMode then begin
        if nPotID = 0 then Result:= Result+' main pot'
        else Result:= Result+' side pot-'+InttoStr(nPotID);
      end;//if

      if bIsCongratulation then
        Result:= Result+' ('+FormatWinnerAmount(nAmount, FTable.CurrencyID)+') with '
      else
        Result:= Result+' '+FormatWinnerAmount(nAmount, FTable.CurrencyID)+' with '
//        Result:= Result+' with '
    end else begin
      if bIsCongratulation then
        Result:= aGamer.UserName + ' take it down ('+FormatWinnerAmount(nAmount, FTable.CurrencyID)+')'
      else
        Result:= aGamer.UserName + ' take it down ' + FormatWinnerAmount(nAmount, FTable.CurrencyID);
//        Result:= 'Take it down, '+aGamer.UserName;
    end;//
  end;//FormWinnerMessage

var
  sMsg, sMsgContext, sMsgFinalPot: string;
  bIsHiNomination: Boolean;
  nTmpWinnersCount: Integer;
  nHiWinnersCount, nLoWinnersCount: Integer;

begin
  if aParent <> nil then Result:= aParent.AddChild(PPTN_FINAL_POT)
  else Result:= FResponseRoot.AddChild(PPTN_FINAL_POT);

  pn:= Result;
  pn.Attributes[PPTA_ID]:= nPotID;

  Table.Hand.Pot.Transactions.ContextFilter:= sContext+IntToStr(nPotID);

//define winner candidates count
  nHiWinnersCount:= 0;
  nLoWinnersCount:= 0;
  if Croupier.PokerType IN [PT_OMAHA_HILO, PT_SEVEN_STUD_HILO] then begin
    for nTxID:= 0 to Table.Hand.Pot.Transactions.Count-1 do begin
      tr:= TAble.Hand.Pot.Transactions[nTxID];
      if Boolean(StrToInt(Trim(tr.Description))) then Inc(nHiWinnersCount)
      else Inc(nLoWinnersCount);
    end;//for
  end;//if

  sMsg := '';
  sMsgContext := '';
  sMsgFinalPot := '';
  for nTxID:= 0 to Table.Hand.Pot.Transactions.Count-1 do begin
    wn:= pn.AddChild(PPTN_WINNER);
    tr:= TAble.Hand.Pot.Transactions[nTxID];
    g:= Table.Chairs[tr.SenderChairID].Gamer;
    wn.Attributes[PPTA_POSITION]:= tr.SenderChairID;
    wn.Attributes[PPTA_AMOUNT]:= FormatFloat('0.##', FCroupier.NormalizeAmount(tr.Amount));
    wn.Attributes[PPTA_NEW_BALANCE]:= FormatFloat('0.##', FCroupier.NormalizeAmount(tr.Amount+g.Account.Balance));

    bIsHiNomination:= Boolean(StrToInt(Trim(tr.Description)));
    if g.ShowCardsAtShowdown AND (FCroupier.WinnerCandidatesCount > 1) then begin
      if bIsHiNomination then
        wn.Attributes[PPTA_CARDS]:= g.Combinations.BestCombination(True).FormSeries(True)
      else
        wn.Attributes[PPTA_CARDS]:= g.Combinations.BestCombination(False).FormSeries(True);
    end;//if

    cn:= pn.AddChild(PPTN_CHAT);
    cn.Attributes[PPTA_SRC]     := '0';
    cn.Attributes[PPTA_PRIORITY]:= '0';

  //insert hi result
    if Croupier.PokerType IN [PT_OMAHA_HILO, PT_SEVEN_STUD_HILO] then begin
      if bIsHiNomination then nTmpWinnersCount:= nHiWinnersCount
      else nTmpWinnersCount:= nLoWinnersCount
    end else begin
      nTmpWinnersCount:= Table.Hand.Pot.Transactions.Count;
    end;//if

    sMsg:= FormWinnerMessage(
      g,
      nTmpWinnersCount= 1,
      Table.Hand.Pot.SidePots.Count = 1,
      FCroupier.NormalizeAmount(tr.Amount),
      nPotID,
      bIsHiNomination,
      True
    );//FormWinnerMessage
    if sMsgFinalPot <> '' then
      sMsgFinalPot := sMsgFinalPot + ', ' +
        FormWinnerMessage(
          g, nTmpWinnersCount= 1, Table.Hand.Pot.SidePots.Count = 1,
          FCroupier.NormalizeAmount(tr.Amount), nPotID, bIsHiNomination, False
        )
    else
      sMsgFinalPot :=
        FormWinnerMessage(
          g, nTmpWinnersCount= 1, Table.Hand.Pot.SidePots.Count = 1,
          FCroupier.NormalizeAmount(tr.Amount), nPotID, bIsHiNomination, False
        );

    if FCroupier.WinnerCandidatesCount > 1 then begin
      if g.Combinations.BestCombination(bIsHiNomination) <> nil then begin
        if bIsHiNomination then begin
          sMsg:= sMsg+g.Combinations.BestCombination(bIsHiNomination).ToString;
          sMsgFinalPot := sMsgFinalPot + g.Combinations.BestCombination(bIsHiNomination).ToString;
        end else begin
          sMsg:= sMsg+g.Combinations.BestCombination(bIsHiNomination).FormLoSeries;
          sMsgFinalPot := sMsgFinalPot + g.Combinations.BestCombination(bIsHiNomination).FormLoSeries;
        end;
      end;//
    end;//if

    cn.Attributes[PPTA_MSG]:=  '#'+IntToStr(FTAble.Hand.HandID)+': '+sMsg;

    if (sMsg <> '') then sMsgContext := sMsgContext + ', ' + sMsg;
  end;//for

  sMsg := '';
  if Croupier.PokerType IN [PT_OMAHA_HILO, PT_SEVEN_STUD_HILO] then begin
    if (nLoWinnersCount = 0) AND (FCroupier.WinnerCandidatesCount > 1) then begin
      cn:= pn.AddChild(PPTN_CHAT);
      cn.Attributes[PPTA_SRC]     := '0';
      cn.Attributes[PPTA_PRIORITY]:= '0';
      sMsg:= 'No low hand ';
      if Table.Hand.Pot.SidePots.Count = 1 then begin
      end else begin
        if nPotID = 0 then sMsg:= sMsg+'for main pot '
        else sMsg:= sMsg+'for side pot('+IntToStr(nPotID)+') ';
      end;//
      sMsg:= sMsg+'qualified';
      cn.Attributes[PPTA_MSG]:=  '#'+IntToStr(FTAble.Hand.HandID)+': '+sMsg;
    end;//if
  end;//if

  { message node }
  if sMsgFinalPot <> '' then begin
    cn:= pn.AddChild(PPTN_GAMER_MESSAGE);
    cn.Attributes[PPTA_TEXT]:= sMsgFinalPot;
  //  cn.Attributes[PPTA_TEXT]:= 'Congratulation:' + #13#10 + sMsgFinalPot;
  end;
  sMsgFinalPot := '';

  if (sMsg <> '') then sMsgContext := sMsgContext + ', ' + sMsg;
  if (sMsgContext <> '') then
    Table.Hand.Pot.Transactions.MessageContext := 'Congratulation:' + sMsgContext
  else
    Table.Hand.Pot.Transactions.MessageContext := '';

  Table.Hand.Pot.Transactions.ContextFilter:= '';
  sMsg := '';
  sMsgContext := '';
end;


function TpoBasicGameEngine.PrepareStatsPacket(aParent: IXMLNode;
  bIncludeModifiedOnly: Boolean): IXMLNode;
var
  I: Integer;
  sn: IXMLNode;

begin
  if aParent <> nil then Result:= aParent.AddChild(PPTN_STATS)
  else Result:= FResponseRoot.AddChild(PPTN_STATS);

  for I:= 0 to FStats.Count-1 do begin
    if (NOT FStats[I].IsModified) AND bIncludeModifiedOnly then Continue;
    sn:= Result.AddChild(PPTN_STAT_ITEM);
    sn.Attributes[PPTA_ID]:= FStats[I].ID;
    sn.Attributes[PPTA_VALUE]:= FStats[I].Value;
  end;//for
end;


procedure TpoBasicGameEngine.SetEngineResetMode(const Value: Boolean);
begin
  FEngineResetMode := Value;
end;

function TpoBasicGameEngine.GetRootNode(sPacket: string): IXMLNode;
var
  doc: IXMLDocument;
begin
  doc:= TXMLDocument.Create(nil);
  doc.Active:= False;
  doc.XML.Text:= sPacket;
  doc.Active:= True;
  Result:= doc.DocumentElement;
end;


function TpoBasicGameEngine.GetContext(var StrState: string; var StrServiceState: string;
  var sReason: String): Integer;
begin
  __lock__();
  try
    sReason:= '';
    StoreState(StrState, StrServiceState);
    UpdateGameStats;
    Result:= 0;
  except
    on e: EpoException do begin
      DumpCachedStateToFile(FStateManager.CachedState);
      sReason:= e.Message+' '+e.Location;
      if EngineResetMode then
        CommonDataModule.Log(ClassName, 'GetContext',
          '== RESET ENGINE MODE - silent exceptions ==', ltError);
      CommonDataModule.Log(ClassName, 'GetContext', sReason, ltError);

      DispatchException(e, True);
      if EngineResetMode then begin
        sReason:= '';
        Result:= 0;
      end else Result:= (e as EpoException).Code;
    end;//
    on e: Exception do begin
      DumpCachedStateToFile(FStateManager.CachedState);
      sReason:= e.Message;

      if EngineResetMode then
        CommonDataModule.Log(ClassName, 'GetContext',
          '== RESET ENGINE MODE - silent exceptions ==', ltError);
      CommonDataModule.Log(ClassName, 'GetContext', sReason, ltError);

      DispatchException(e, True);

      if EngineResetMode then begin
        sReason:= '';
        Result:= 0
      end else Result:= GE_ERR_NOT_DEFINED;
    end;//
  end;//try
  __unlock__();
end;

function TpoBasicGameEngine.ProcessActions(
  const nProcessID: Integer;
  const sInActions: String;
  var sOutActions: String;
  var sReason: String
  ): Integer;
var
  I: Integer;
  asp,
  ap: IXMLNode;
  sHost: string;
  nSessionOrTourID: Integer;
  nUserID: Integer;
begin
  CommonDataModule.Log(ClassName, 'ProcessActions', 'Entry. XML:[' + sInActions + ']', ltCall);
  try
    if FProcessID = UNDEFINED_PROCESS_ID then EscalateFailure(
      EpoException,
      'Enging is not initialized. Looks like stage is not loaded.',
      '{B9DD819C-51F2-4144-AD69-14869F2CA6C5}'
    );//

    if FProcessID <> nProcessID then EscalateFailure(
      EpoException,
      'Process ID passed ('+InttoStr(nprocessID)+') does not correspond internal one ('+IntToStr(FProcessID)+').',
      '{BADB1B30-4CBF-49A5-A4B5-08DA06137B3C}'
    );//
    asp:= GetRootNode(sInActions);

    StoreStateAsCached;
    
    for I:= 0 to asp.ChildNodes.Count-1 do begin
      ap:= asp.ChildNodes.Get(I);
      sHost:= '';
      nSessionOrTourID:= -1;
      nUserID := 0;

      if ap.HasAttribute(PPTA_TOURNAMENT_ID) then
        nSessionOrTourID:= ap.Attributes[PPTA_TOURNAMENT_ID];
      if ap.HasAttribute(PPTA_SESSION_ID) and (nSessionOrTourID <= 0) then begin
        nSessionOrTourID:= ap.Attributes[PPTA_SESSION_ID];
        if (nSessionOrTourID < 0) then begin
          CommonDataModule.Log(ClassName, 'ProcessActions',
            '[ERROR] Undefined sessionID=' + IntToStr(nSessionOrTourID) +
              ': On command=[' + ap.XML + ']',
            ltError
          );
          Continue;
        end;
      end;
      if ap.HasAttribute(PPTA_USER_ID) then nUserID:= StrToIntDef(ap.Attributes[PPTA_USER_ID], 0);
      if ap.HasAttribute(PPTA_HOST) then sHost:= ap.Attributes[PPTA_HOST];

      ProcessActionPrim(ap, sHost, nSessionOrTourID, nUserID);
    end;//for

    Result:= 0;
  except
    on e: EpoException do begin
      DumpCachedStateToFile(FStateManager.CachedState);
      sReason:= e.Message+' '+e.Location;

      if EngineResetMode then
        CommonDataModule.Log(ClassName, 'ProcessActions',
          '== RESET ENGINE MODE - silent exceptions ==', ltError);
      CommonDataModule.Log(ClassName, 'ProcessActions', sReason, ltError);

      DispatchException(e, True);
      if EngineResetMode then begin
        sReason:= '';
        Result:= 0
      end else Result:= (e as EpoException).Code;
    end;//
    on e: Exception do begin
      DumpCachedStateToFile(FStateManager.CachedState);
      sReason:= e.Message;

      if EngineResetMode then
        CommonDataModule.Log(ClassName, 'ProcessActions',
          '== RESET ENGINE MODE - silent exceptions ==', ltError);
      CommonDataModule.Log(ClassName, 'ProcessActions', sReason, ltError);

      DispatchException(e, True);

      if EngineResetMode then begin
        sReason:= '';
        Result:= 0
      end else Result:= GE_ERR_NOT_DEFINED;
    end;//
  end;//try
  __unlock__();
end;

function TpoBasicGameEngine.SetContext(var StrState: string; var sReason: string): Integer;
begin
  __lock__();
  try
    sReason:= '';
    LoadState(StrState);
    Result:= 0;
  except
    on e: EpoException do begin
      DumpCachedStateToFile(FStateManager.CachedState);
      sReason:= e.Message+' '+e.Location;

      if EngineResetMode then
        CommonDataModule.Log(ClassName, 'SetContext',
          '== RESET ENGINE MODE - silent exceptions ==', ltError);
      CommonDataModule.Log(ClassName, 'SetContext', sReason, ltError);

      DispatchException(e, True);
      if EngineResetMode then begin
        sReason:= '';
        Result:= 0;
      end else Result:= (e as EpoException).Code;
    end;//
    on e: Exception do begin
      DumpCachedStateToFile(FStateManager.CachedState);
      sReason:= e.Message;

      if EngineResetMode then
        CommonDataModule.Log(ClassName, 'SetContext',
          '== RESET ENGINE MODE - silent exceptions ==', ltError);
      CommonDataModule.Log(ClassName, 'SetContext', sReason, ltError);

      DispatchException(e, True);

      if EngineResetMode then begin
        sReason:= '';
        Result:= 0
      end else Result:= GE_ERR_NOT_DEFINED;
    end;//
  end;//try
  __unlock__();
end;


procedure TpoBasicGameEngine.LoadState(StrState: string);
begin
  if FStateManager = nil then
    FStateManager:= TpoApiStateManager.Create(UNDEFINED_PROCESS_ID, Self);
  try
    if FStateManager.CacheState(StrState) then begin
      Load(FStateManager.InStream);
    end;//if
  except
    on e: Exception do begin
      EscalateFailure(EpoException, e.Message, '{23B8EC3B-5332-4B34-9646-FC62DD9641FF}');
    end;//
  end;//try
end;

function TpoBasicGameEngine.ProcessActionPrim(
  var aGaActions: IXMLNode;
  sHost: String; nID, nUserIDAttr: Integer
  ): Integer;
var
  I: Integer;
  aOutActionPacket: IXMLNode;
begin
  CommonDataModule.Log(ClassName, 'ProcessActionPrim', 'Entry. XML:[' + aGaActions.XML + ']', ltCall);

  FActionActivation:= Now;

  //reinit packets cache
//8888888888********** BS
  ReCreateResponceDocument;
//8888888888********** BS

  Result := 0;
  for I:= 0 to aGaActions.ChildNodes.Count-1 do begin
    try
      aOutActionPacket:= FActions.DispatchAction(nID, nUserIDAttr, aGaActions.ChildNodes.Get(I));
      if aOutActionPacket <> nil then begin
        DispatchResponse(nID, aOutActionPacket, True);
      end;//if
    except
      on e: EpoSessionException do begin
        DispatchException(e, False);
      end;//
      on e: EpoUnexpectedActionException do begin
         CommonDataModule.Log(ClassName, 'ProcessActionPrim',
           'Unexpected action: '+e.Message+' '+e.Anchor, ltError);
         CommonDataModule.Log(ClassName, 'ProcessActionPrim',
          aGaActions.ChildNodes.Get(I).XML+'('+aGaActions.XML+')', ltError);
      end;
    end;//
  end;//for

//----------------------------------------------------------------------------
//setup timeout for active gamer actions
//----------------------------------------------------------------------------
  if (Table.Hand.ActiveGamer <> nil) AND (Table.Hand.State = HST_RUNNING)
  then begin
    if (NOT Table.Hand.ActiveGamer.RegularTimeoutActivated) then begin
      CommonDataModule.Log(ClassName, 'ProcessActionPrim',
        'Setting up regular gamer action timeout - '+
        IntToStr(FCroupier.GetGamerActionTimeout(Table.Hand.ActiveGamer))+' s'
        , ltCall);
      SetupGamerActionTimeout(
        Table.Hand.ActiveGamer,
        FCroupier.GetValidGamerActions(Table.Hand.ActiveGamer),
        FCroupier.GetGamerActionTimeout(Table.Hand.ActiveGamer),
        True
      );
      Table.Hand.ActiveGamer.RegularTimeoutExpired:= False;
      Table.Hand.ActiveGamer.RegularTimeoutActivated:= True;
    end else
    if Table.Hand.ActiveGamer.ActivateTimeBank AND
      (NOT Table.Hand.ActiveGamer.TimeBankActivated) AND
      (Table.Hand.ActiveGamer.RegularTimeoutExpired)
    then begin
      CommonDataModule.Log(ClassName, 'ProcessActionPrim',
        'Setting up timebank gamer action timeout - '+
        IntToStr(Table.Hand.ActiveGamer.TournamentTimebank)+' s'
        , ltCall);

      SetupGamerActionTimeout(
        Table.Hand.ActiveGamer,
        FCroupier.GetValidGamerActions(Table.Hand.ActiveGamer),
        Table.Hand.ActiveGamer.TournamentTimebank,
        False
      );//SetupGamerActionTimeout
      Table.Hand.ActiveGamer.TimeBankActivated:= True;
      CommonDataModule.Log(ClassName, 'ProcessActionPrim',
        'Timebank Reminder stamp timeout - '+FormatDateTime('hh:nn:ss', Now())
        , ltCall);

    end;//if
  end;//if
  if (Table.Hand.ActiveGamer = nil) AND (Table.Hand.State = HST_RUNNING) then begin
     //strange condition: active player is not defined
     CommonDataModule.Log(ClassName, 'ProcessActionPrim', 'Active player is not defined.', ltCall);
     Table.Gamers.DumpGamers;
     CommonDataModule.Log(ClassName, 'ProcessActionPrim', '-----------------------------', ltCall);
  end;//if

  CheckAndHandleReservations();
  HandleCachedPackets();
  FlushResponseQueue();
end;//ProcessActionPrim


function TpoBasicGameEngine.Setup(LogFile: WideString;
  const Api: TApi): Integer;
begin
  FApi:= Api;
  Result:= 0;
end;

function TpoBasicGameEngine.HandleChatAllow(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
  nUserID: Integer;
  nChatAllow: Integer;
begin
  Result:= nil;
  nUserID := nUserIDAttr;
  // chatallow attribute
  if not aActionInfo.HasAttribute('chatallow') then begin
    CommonDataModule.Log(ClassName, 'HandleChatAllow',
    '[ERROR] On chat allow action: attribute "chatallow" is not found.',
    ltError);
    Exit;
  end;

  nChatAllow := StrToIntDef(aActionInfo.Attributes['chatallow'], 0);
  g := FTable.Gamers.GamerByUserID(nUserID);
  if g = nil then begin
    CommonDataModule.Log(ClassName, 'HandleChatAllow',
    '[ERROR] On chat allow action: Gamer by userid=' + IntToStr(nUserID) + ' not found.',
    ltError);
    Exit;
  end;
  g.ChatAllow := (nChatAllow > 0);
end;

procedure TpoBasicGameEngine.SetStatses(const Value: string);
begin
  FStatses := Value;
end;

function TpoBasicGameEngine.PrepareBusyOnSitDownPacket(aParent: IXMLNode;
  nPosition, nUserID: Integer): IXMLNode;
begin
  Result:= aParent.AddChild(PPTN_GAMER_ACTION);
  Result.Attributes[PPTA_NAME] := PPTV_BUSY_ON_SIT_DOWN;
  Result.Attributes[PPTA_POSITION] := IntToStr(nPosition);
  Result.Attributes[PPTA_USER_ID] := IntToStr(nUserID);
end;

function TpoBasicGameEngine.AddingAffiliateFeeNodesAsString(TotalFee: Integer): string;
var
  g: TpoGamer;
  I, J, nCount, nInd: Integer;
  nAffFee: Integer;
  bFound: Boolean;

  arrAffiliates: array of array of Integer;
begin

  { initialization array of affiliates }
  nCount := FTable.Chairs.Count;
  SetLength(arrAffiliates, nCount, 2);
  { self affiliate }
  for I:=0 to nCount - 1 do begin
    arrAffiliates[I, 0] := -1;  // (index - 0) id of affiliate
    arrAffiliates[I, 1] :=  0;  // (index - 1) count of gamers with affiliate
  end;

  { calc of count non self affiliates among gamers }
  nInd := 0;
  nCount := 0;
  for I:=0 to FTable.Chairs.Count - 1 do begin
    g := FTable.Chairs.Chairs[I].Gamer;
    if (g = nil) then Continue; // Chair is empty

    bFound := False;
    for J:=Low(arrAffiliates) to High(arrAffiliates) do begin
      if (arrAffiliates[J, 0] = g.AffiliateID) then begin
        bFound := True;
        arrAffiliates[J, 1] := arrAffiliates[J, 1] + 1;

        Break;
      end;
    end;

    if not bFound then begin
      arrAffiliates[nInd, 0] := g.AffiliateID;
      arrAffiliates[nInd, 1] := arrAffiliates[nInd, 1] + 1;

      nInd := nInd + 1;
    end;

    nCount := nCount + 1;
  end;

  { calc Sum of rakes withowt self affiliate }
  Result := '';
  for I:=Low(arrAffiliates) to High(arrAffiliates) do begin
    if (arrAffiliates[I, 0] > 0) and (arrAffiliates[I, 1] > 0) then begin
      nAffFee  := Round(TotalFee * arrAffiliates[I, 1] / nCount);

      Result := Result +
        '<' + PPTN_AFFILIATE_FEE + ' ' +
          PPTA_ID    + '="' + IntToStr(arrAffiliates[I, 0]) + '" ' +
          PPTA_MONEY + '="' + FormatFloat('0.##', FCroupier.NormalizeAmount(nAffFee)) + '"' +
        '/>';
    end else begin
      Break;
    end
  end;
end;

function TpoBasicGameEngine.HandleGetDefaultProperty(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  nObjType: Integer;
  sData, sGuid, Reason: string;
begin
  CommonDataModule.Log(ClassName, 'HandleGetDefaultProperty',
    'Entry with xml:[' + aActionInfo.XML + ']',
    ltCall);

  Result := nil;

  nObjType := 0;
  if aActionInfo.HasAttribute(PPTA_OBJTYPE) then
    nObjType := StrToIntDef(aActionInfo.Attributes[PPTA_OBJTYPE], 0);

  if not (nObjType in [0, 1]) then begin
    CommonDataModule.Log(ClassName, 'HandleGetDefaultProperty',
      '[ERROR]: Attribute "objtype" has incorrect value (' + IntToStr(nObjType) + ')'
      , ltError);
  end;

  sGuid := '';
  if aActionInfo.HasAttribute(PPTA_GUID) then
    sGuid := aActionInfo.Attributes[PPTA_GUID];

  CommonDataModule.Log(ClassName, 'HandleGetDefaultProperty',
    'Before GetProcessInfo.',
    ltCall);
  GetProcessInfo(sData, Reason);
  CommonDataModule.Log(ClassName, 'HandleGetDefaultProperty',
    'After GetProcessInfo. sData=[' + sData + ']',
    ltCall);

  CommonDataModule.SendAdminMSMQ(sData, sGuid);

  CommonDataModule.Log(ClassName, 'HandleGetDefaultProperty',
    'Exit. AllRight',
    ltCall);
end;

function TpoBasicGameEngine.HandleSetDefaultProperty(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  nProcessID: Integer;
  sData, sGuid, Reason: string;
  nRes: Integer;
begin
  CommonDataModule.Log(ClassName, 'HandleSetDefaultProperty',
    'Entry with xml:[' + aActionInfo.XML + ']',
    ltCall);

  Result := nil;

  sGuid := '';
  if aActionInfo.HasAttribute(PPTA_GUID) then
    sGuid := aActionInfo.Attributes[PPTA_GUID];

  nProcessID := -1;
  if aActionInfo.HasAttribute(PPTA_PROCESS_ID) then
    nProcessID := StrToIntDef(aActionInfo.Attributes[PPTA_PROCESS_ID], -1);

  if (nProcessID <= 0) then begin
    CommonDataModule.Log(ClassName, 'HandleSetDefaultProperty',
      '[ERROR]: Incorrect or not exist attribute processid; ActionInfo=[' + aActionInfo.XML + ']',
      ltError);

    sData :=
        '<setdefprop result="' + IntToStr(GE_WRONG_PROCESS_ID) +'"/>';
    CommonDataModule.SendAdminMSMQ(sData, sGuid);
    Exit;
  end;

  if not aActionInfo.HasChildNodes then begin
    CommonDataModule.Log(ClassName, 'HandleSetDefaultProperty',
      '[ERROR]: ActionInfo has not child nodes; ActionInfo=[' + aActionInfo.XML + ']',
      ltError);

    sData := '<setdefprop result="' + IntToStr(GE_ERR_HAS_NOT_CHILD_NODES) + '"/>';
    CommonDataModule.SendAdminMSMQ(sData, sGuid);

    Exit;
  end;

  nRes := InitGameProcess(nProcessID, aActionInfo.ChildNodes[0].XML, Reason);
  if (nRes <> NO_ERROR) then begin
    CommonDataModule.Log(ClassName, 'HandleSetDefaultProperty',
      '[ERROR]: ActionInfo has not child nodes; ActionInfo=[' + aActionInfo.XML + ']',
      ltError);

    sData := '<setdefprop result="' + IntToStr(nRes) + '"/>';
    CommonDataModule.SendAdminMSMQ(sData, sGuid);

    Exit;
  end;

  sData := '<setdefprop result="0"/>';
  CommonDataModule.Log(ClassName, 'HandleSetDefaultProperty',
    'Before execute CommonDataModule.SendAdminMSMQUsingDispatcher: sData=' + sData,
    ltCall);

  CommonDataModule.SendAdminMSMQ(sData, sGuid);

  CommonDataModule.Log(ClassName, 'HandleSetDefaultProperty',
    'After execute CommonDataModule.SendAdminMSMQUsingDispatcher',
    ltCall);

  CommonDataModule.Log(ClassName, 'HandleSetDefaultProperty',
    'Exit. All right.',
    ltCall);
end;

function TpoBasicGameEngine.GetTournamentBaseFirstPlace: Currency;
var
  gp: TGameProperty;
begin
  Result := 0;

  gp := FProperties.PropertyByName(PP_ST_TOURNAMENT_BasePrizeFirst);
  if gp <> nil then begin
    Result := StrToCurrDef(gp.FValue, 0);
  end;
end;

function TpoBasicGameEngine.GetTournamentBasePaymentType: TpoTournamentPaymentType;
begin
  Result:= TpoTournamentPaymentType(FProperties.PropertyByName(PP_ST_TOURNAMENT_BasePayment).AsInteger);
end;

function TpoBasicGameEngine.GetTournamentBaseSecondPlace: Currency;
var
  gp: TGameProperty;
begin
  Result := 0;

  gp := FProperties.PropertyByName(PP_ST_TOURNAMENT_BasePrizeSecond);
  if gp <> nil then begin
    Result := StrToCurrDef(gp.FValue, 0);
  end;
end;

function TpoBasicGameEngine.GetTournamentBaseThirdPlace: Currency;
var
  gp: TGameProperty;
begin
  Result := 0;

  gp := FProperties.PropertyByName(PP_ST_TOURNAMENT_BasePrizeThird);
  if gp <> nil then begin
    Result := StrToCurrDef(gp.FValue, 0);
  end;
end;

function TpoBasicGameEngine.GetTournamentBonusFirstPlace: Currency;
var
  gp: TGameProperty;
begin
  Result := 0;

  gp := FProperties.PropertyByName(PP_ST_TOURNAMENT_BonusPrizeFirst);
  if gp <> nil then begin
    Result := StrToCurrDef(gp.FValue, 0);
  end;
end;

function TpoBasicGameEngine.GetTournamentBonusPaymentType: TpoTournamentPaymentType;
begin
  Result:= TpoTournamentPaymentType(FProperties.PropertyByName(PP_ST_TOURNAMENT_BonusPayment).AsInteger);
end;

function TpoBasicGameEngine.GetTournamentBonusSecondPlace: Currency;
var
  gp: TGameProperty;
begin
  Result := 0;

  gp := FProperties.PropertyByName(PP_ST_TOURNAMENT_BonusPrizeSecond);
  if gp <> nil then begin
    Result := StrToCurrDef(gp.FValue, 0);
  end;
end;

function TpoBasicGameEngine.GetTournamentBonusThirdPlace: Currency;
var
  gp: TGameProperty;
begin
  Result := 0;

  gp := FProperties.PropertyByName(PP_ST_TOURNAMENT_BonusPrizeThird);
  if gp <> nil then begin
    Result := StrToCurrDef(gp.FValue, 0);
  end;
end;

function TpoBasicGameEngine.GetTournamentUseBasePrizes: Boolean;
var
  gp: TGameProperty;
begin
  Result := True;

  gp := FProperties.PropertyByName(PP_ST_TOURNAMENT_UseBasePrizes);
  if gp <> nil then begin
    if AnsiLowerCase(gp.FValue) = 'false' then Result := False;
  end;
end;

function TpoBasicGameEngine.GetTournamentUseBonusPrizes: Boolean;
var
  gp: TGameProperty;
begin
  Result := False;

  gp := FProperties.PropertyByName(PP_ST_TOURNAMENT_UseBonusPrizes);
  if gp <> nil then begin
    if AnsiLowerCase(gp.FValue) = 'true' then Result := True;
  end;
end;

procedure TpoBasicGameEngine.InitRakeRules;
var
  aRakeRoot: TpoRakeRulesRoot;
  aRakeItem: TpoRakeRulesItem;
  //
  I, nRes, nGameRakeRuleTypeID: Integer;
  sData: string;
begin
  CommonDataModule.Log(ClassName, 'InitRakeRules', 'Entry.', ltCall);

  { init by default }
  FTable.RakeRules.SetDefault;

  { must be corresponded to GameRakeRulesType table }
  case FCroupier.StakeType of
    ST_UNDEFINED, ST_FIXED_LIMIT: nGameRakeRuleTypeID := 1;
  else
    nGameRakeRuleTypeID := 2;
  end;

  { get api rake rules }
  nRes := FApi.GetGameRakeRules(nGameRakeRuleTypeID, sData);
  if nRes <> 0 then begin
    CommonDataModule.Log(ClassName, 'InitRakeRules',
      '[Error] On execute FApi.GetGameRakeRules with result=' +
        IntToStr(nRes) + ': Params: GameRakeRuleTypeID=' +
        IntToStr(nGameRakeRuleTypeID),
      ltCall
    );
    Exit;
  end;

  { search on RakeRulesItem }
  aRakeRoot := TpoRakeRulesRoot.Create;
  aRakeRoot.SetContextByXMLText(sData);
  if (aRakeRoot.Count <= 0) then begin
    aRakeRoot.Free;
    CommonDataModule.Log(ClassName, 'InitRakeRules',
      '[Error]: Invalid XML. Rake Rules is initialized by default. XML=[' + sData + ']',
      ltError);
    Exit;
  end;

  aRakeRoot.SortAll;
  aRakeItem := aRakeRoot.Items[0];
  for I:=1 to aRakeRoot.Count - 1 do begin
    if (FTable.SmallBetValue >= aRakeRoot.Items[I].LowerLimitStake) then begin
      aRakeItem := aRakeRoot.Items[I];
    end;
  end;
  if (aRakeItem.Count <= 0) then begin
    aRakeRoot.Free;
    CommonDataModule.Log(ClassName, 'InitRakeRules',
      '[Error]: Invalid XML. Rake Rules Item is empty and is initialized by default.' +
        ' LowerLimitStake=' + FloatToStr(aRakeItem.LowerLimitStake / 100) +
        '; XML=[' + sData + ']',
      ltError);
    Exit;
  end;

  FTable.RakeRules.SetContextByObject(aRakeItem);

  aRakeRoot.Free;

  CommonDataModule.Log(ClassName, 'InitRakeRules', 'Exit. Rake Rules is initialized.', ltCall);
end;

procedure TpoBasicGameEngine.DeleteAllCheckOnTimeOutReminders;
var
  aReminder: TpoReminder;
begin
  aReminder := FReminders.GetByName(PPTV_CHECK_TIMEOUT_ACTIVITY);
  while (aReminder <> nil) do begin
    DeleteInterval(aReminder.FReminderID);
    aReminder := FReminders.GetByName(PPTV_CHECK_TIMEOUT_ACTIVITY);
  end;
  FCheckTimeOutActivity := '';
  CommonDataModule.Log(ClassName, 'DeleteAllCheckOnTimeOutReminders',
    'All reminders on check of timeout activity was deleted.', ltCall);
end;

function TpoBasicGameEngine.HandleDrinks(nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  sName: string;
  nPosition, nID: Integer;
  aChair: TpoChair;
begin
{ it is input
  <drinks name="coffe|vodka|cigar|..." position="0|1|..."/>
}
  sName := '';
  nPosition := UNDEFINED_POSITION_ID;
  nID       := -1;
  if aActionInfo.HasAttribute(PPTA_NAME)    then
    sName     := aActionInfo.Attributes[PPTA_NAME];
  if aActionInfo.HasAttribute(PPTA_ID)      then
    nID       := StrToIntDef(aActionInfo.Attributes[PPTA_ID], -1);
  if aActionInfo.HasAttribute(PPTA_POSITION)      then
    nPosition := StrToIntDef(aActionInfo.Attributes[PPTA_POSITION], UNDEFINED_POSITION_ID);

  if not (nPosition in [0..(FTable.Chairs.Count-1)]) then begin
    CommonDataModule.Log(ClassName, 'HandleDrinks',
      '[ERROR]: Chair with position=' + IntToStr(nPosition) + ' not found on table; Packet: [' + aActionInfo.XML + ']',
      ltError
    );
    Exit;
  end else begin
    aChair := FTable.Chairs[nPosition];
  end;

  if (aChair.UserID = UNDEFINED_USER_ID) then begin
    CommonDataModule.Log(ClassName, 'HandleDrinks',
      '[ERROR]: Chair with position=' + IntToStr(nPosition) + ' is empty; Packet: [' + aActionInfo.XML + ']',
      ltError
    );
    Exit;
  end;

  aChair.DrinksName := sName;
  aChair.DrinksID   := nID;

  { response to all }
  Result:= PrepareDrinksPacket(nil, sName, nPosition, nID);
end;

function TpoBasicGameEngine.PrepareDrinksPacket(aParent: IXMLNode;
  sName: string; nPosition, nID: Integer
): IXMLNode;
begin
{ it is output none
  <drinks name="coffe|vodka|cigar|..." position="0|1|..."/>
}
  if aParent = nil then
    Result := PrepareOutputPacket(RB_ALL, True)
  else
    Result := aParent;

  Result := Result.AddChild(PPTN_DRINKS);
  Result.Attributes[PPTA_NAME] := sName;
  if (nID >= 0) then Result.Attributes[PPTA_ID] := IntToStr(nID);
  Result.Attributes[PPTA_POSITION] := IntToStr(nPosition);
end;

function TpoBasicGameEngine.PrepareDrinksChairsPacket(aParent: IXMLNode): IXMLNode;
var
  I: Integer;
  aChair: TpoChair;
begin
  for I:=0 to FTable.Chairs.Count - 1 do begin
    aChair := FTable.Chairs[I];
    if (aChair.UserID <= UNDEFINED_USER_ID) then
      PrepareDrinksPacket(aParent, '', I, -1)
    else
      PrepareDrinksPacket(aParent, aChair.DrinksName, I, aChair.DrinksID);
  end;
end;

procedure TpoBasicGameEngine.DumpCachedStateToFile(sState: string; bOnExcept: Boolean);
{$IFDEF __COMMONDATAMODULE__}
var
  st: TFileStream;
  AYear, AMonth, ADay, AHour,
  AMinute, ASecond, AMilliSecond: Word;
  sFileName: string;
{$ENDIF}
begin
{$IFDEF __COMMONDATAMODULE__}
  st := nil;
  DecodeDateTime(now, AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);
  sFileName := CommonDataModule.LogFolder + '\' + CommonDataModule.ServiceName + '\' +
    FormatFloat('0000', AYear) + '_' + FormatFloat('00', AMonth) + '_' + FormatFloat('00', ADay) +
    '[' + FormatFloat('00', AHour) + '_' + FormatFloat('00', AMinute) + '].state';
  sFileName := sFileName + IfThen(bOnExcept, '(ex)', '');
  try
    st:= TFileStream.Create(sFileName, fmCreate);
    st.Write(sState[1], Length(sState));
  finally
    st.Free;
  end;//try
{$ENDIF}
end;

procedure TpoBasicGameEngine.OnDumpCachedStateToFile;
begin
  DumpCachedStateToFile(FStateManager.FCachedState);
end;

procedure TpoBasicGameEngine.ReCreateResponceDocument;
begin
  if (FResponseDoc <> nil) then begin
    if FResponseDoc.Active then FResponseDoc.DocumentElement.ChildNodes.Clear;
    FResponseRoot:= nil;
    FResponseDoc.Active:= False;
    FResponseDoc:= nil;
  end;

  FResponseDoc:= TXMLDocument.Create(nil);
  FResponseDoc.Active:= False;
  FResponseDoc.XML.Text:= '<rsp/>';
  FResponseDoc.Active:= True;
  FResponseRoot:= FResponseDoc.DocumentElement;
end;

function TpoBasicGameEngine.UpdateProcState: Integer;
var
  I: Integer;
  n: IXMLNode;
  g: TpoGamer;
begin
  Result := 0;
  ReCreateResponceDocument;

  //notify gamers about hand
  for I:= 0 to FTable.Gamers.Count-1 do begin
    g := FTable.Gamers[I];

    n:= PrepareOutputPacket(RB_REQUESTER, True);
    PrepareProcStatePacket(n, g.SessionID);
    DispatchResponse(g.SessionID, n, True, g.UserID);
  end;//for

  if Table.Hand.ActiveGamer <> nil then begin
    n:= PrepareOutputPacket(RB_ALL, True);
    PrepareSetActivePlayerPacket(n, 0);
    DispatchResponse(0, n, True);
  end;
end;

procedure TpoBasicGameEngine.SetMandatoryAnte(const Value: Integer);
begin
  FTable.MandatoryAnte := Value;
end;

function TpoBasicGameEngine.GetMandatoryAnte: Integer;
begin
  Result := FTable.MandatoryAnte;
end;

function TpoBasicGameEngine.PrepareOutputPacketTournamentEvent(BroadcastTo: TResponseBroadcasting;
  EventName, Msg: string; ActionDispatcherID, nDuration: Integer): IXMLNode;
var
  n: IXMLNode;
begin
  Result:= FResponseRoot.AddChild(PPTN_RESPONSE_ROOT);
  Result.Attributes[PPTA_NAME]:= PPTV_TOURNAMENT;
  Result.Attributes[PPTA_RESPONSE_GROUP]:= nBroadcastToToAttr[BroadcastTo];
  Result.Attributes[PPTA_SEND_TO_REQUESTER]:= IntToStr(Integer(True));

  n := Result.AddChild(PPTN_TOURNAMENT_EVENT);
  n.Attributes[PPTA_ACTION]          := EventName;
  n.Attributes[PPTA_MSG]             := Msg;
  n.Attributes[PPTA_BREAKDURATION]   := nDuration;
  n.Attributes[PPTA_TOURNAMENT_ID]   := TournamentID;
  n.Attributes[PPTA_ACTIONDISPATCHERID] := ActionDispatcherID;
  n.Attributes[PPTA_TOURNAMENT_NAME] := '';
  n.Attributes[PPTA_PROCESS_ID]      := ProcessID;
  n.Attributes[PPTA_PROCESS_NAME]    := ProcessName;
end;

function TpoBasicGameEngine.GetBotsData(aTempGamers: TpoGamers): Integer;
var
  XMLDoc: IXMLDocument;
  aNode, aRoot: IXMLNode;
  sData: string;
  I, nUserID, nBotID, nSexID, nAvatarID, BotsCount: Integer;
  sBotName, sCity: string;
  aGamer: TpoGamer;
begin
  Result := 0;
  sData := FApi.GetBotsDataXMLString;
  aTempGamers.Clear;

  XMLDoc := TXMLDocument.Create(nil);
  try
    XMLDoc.XML.Text := sData;
    XMLDoc.Active := True;
    aRoot := XMLDoc.DocumentElement;
    BotsCount := aRoot.ChildNodes.Count;
    for I:=0 to BotsCount - 1 do begin
      aNode := aRoot.ChildNodes[I];

      if not aNode.HasAttribute(PPTA_ID) then Continue;
      nBotID := aNode.Attributes[PPTA_ID];

      nUserID := MaxInt - nBotID - 10;
      sBotName := 'Bot ' + IntToStr(I);
      if aNode.HasAttribute(PPTA_LOGIN_NAME) then
        sBotName := aNode.Attributes[PPTA_LOGIN_NAME];
      nSexID := 1;
      if aNode.HasAttribute(PPTA_SEX_ID) then
        nSexID := StrToIntDef(aNode.Attributes[PPTA_SEX_ID], 1);
      sCity := 'BotLand';
      if aNode.HasAttribute(PPTA_LOCATION) then
        sCity := aNode.Attributes[PPTA_LOCATION];
      nAvatarID := Random(100);
      if aNode.HasAttribute(PPTA_AVATAR_ID) then
        nAvatarID := StrToIntDef(aNode.Attributes[PPTA_AVATAR_ID], 1);

      aGamer := aTempGamers.RegisterGamer(
        nBotID, '', nUserID, sBotName, nSexID, sCity,
        nAvatarID, 0, True, 1, True, 0, nil
      );

      aGamer.IsBot := True;
    end;
  except
    on E: Exception do begin
      aTempGamers.Clear;
      XMLDoc := nil;
      Result := GE_ERR_WRONG_PACKET;
      CommonDataModule.Log(ClassName, 'GetBotsData',
        '[EXCEPTION]: with message=' + E.Message,
        ltException
      );
      Exit;
    end;
  end;

  XMLDoc := nil;
end;

function TpoBasicGameEngine.SetupBotActionTimeout(aGamer: TpoGamer;
  nAction: TpoGamerAction; nStake, nMaxStake, nDead, nTag: Integer;
  nTimeout: Integer; bRegular: Boolean): TpoReminder;
var
  n: IXMLNode;
begin
  //remove previous action for same game
  DeleteBotActionTimeout(aGamer, GA_NONE);
  n := PrepareGamerActionPacket(FResponseRoot, aGamer, nAction, nStake, nDead);

  n:= FResponseRoot.AddChild(PPTN_BOT_EVENT);
  n.Attributes[PPTA_NAME]:= PPTV_GAMER_ACTION;
  n.Attributes[PPTA_ACTION] := Integer(nAction);
  n.Attributes[PPTA_HAND_ID]:= IntToStr(Table.Hand.HandID);
  n.Attributes[PPTA_USER_ID]:= IntToStr(aGamer.UserID);
  n.Attributes[PPTA_REGULAR_TIMEOUT]:= IntToStr(Integer(bRegular));
  n.Attributes[PPTA_STAKE] := IntToStr(nStake);
  n.Attributes[PPTA_MAX_STAKE] := IntToStr(nMaxStake);
  n.Attributes[PPTA_DEAD] := IntToStr(nDead);

  Result:= ScheduleSecIntervalEx(PPTT_SCHEDULER_PACKET_EX, PPTV_GAME_ADAPTOR, nTimeout, n, True);
  Result.UserID:= aGamer.UserID;
  Result.GamerActions:= [nAction];
end;

procedure TpoBasicGameEngine.DeleteBotActionTimeout(aGamer: TpoGamer;
  nAction: TpoGamerAction);
var
  rm: TpoReminder;
begin
  if aGamer = nil then Exit;
  rm:= FReminders.GetReminderByUserIDAndName(aGamer.UserID, PPTN_BOT_EVENT);
  if (rm <> nil) then begin
    DeleteInterval(rm.ReminderID);
  end;//if
end;

function TpoBasicGameEngine.GetBotsTimeOutAnswer(aAction: TpoGamerAction; nInitial: Integer = 0): Integer;
var
  nRndType, nRndType2: Integer;
begin
  { ShowDown action }
  if aAction in [GA_SHOW_CARDS, GA_SHOW_CARDS_SHUFFLED, GA_MUCK, GA_DONT_SHOW, GA_DISCARD_CARDS] then begin
    Result := 1;
    Exit;
  end;

  if nInitial > 0 then begin
    Result := nInitial;
    if nInitial > GT_GAMER_ACTION_TIMEOUT then Result := GT_GAMER_ACTION_TIMEOUT - 5;
    Exit;
  end;

  if (aAction in [GA_POST_SB, GA_POST_BB]) then begin
    Result := Random(1);
    Exit;
  end;

  { Another action }
  nRndType := Random(999);
  Result := 1;
  case nRndType of
    0..9: Result := 0;
    10..991:
    begin
      nRndType2 := Random(999);
      case nRndType2 of
        0..399: Result := 1 + Random(1);
        400..699: Result := 2 + Random(1);
        700..899: Result := 2 + Random(2);
        900..999: Result := 3 + Random(2);
      end;
    end;
    992..996: Result := 6 + Random(4);
    997..998: Result := 11 + Random(4);
    999: Result := 16 + Random(4);
  end;
  Result := Result + 2;
  if (Result > 20) then Result := 20;
end;

function TpoBasicGameEngine.OnBotSetActivePlayer(aGamer: TpoGamer; XMLSetActivePlayer: IXMLNode;
  var nBotStake, nBotDead: Integer): TpoGamerAction;
var
  aBotTable: TBotTable;
  aBotUser: TBotUser;
  aBotAutoResponse: TBotAutoResponse;
  aAvailableAnswer: TBotAvailableAnswer;

  function ConvertBotActionToEngineAction(aBotAction: TFixAction): TpoGamerAction;
  begin
    case aBotAction of
      ACT_FOLD: Result := GA_FOLD;
      ACT_CHECK: Result := GA_CHECK;
      ACT_WAITBB: Result := GA_WAIT_BB;
      ACT_POSTDEAD: Result := GA_POST_DEAD;
      ACT_POSTSB: Result := GA_POST_SB;
      ACT_POSTBB: Result := GA_POST_BB;
      ACT_ANTE: Result := GA_ANTE;
      ACT_BRINGIN: Result := GA_BRING_IN;
      ACT_CALL: Result := GA_CALL;
      ACT_POST: Result := GA_POST;
      ACT_BET: Result := GA_BET;
      ACT_RAISE: Result := GA_RAISE;
      ACT_DISCARD: Result := GA_DISCARD_CARDS;
      ACT_SHOW: Result := GA_SHOW_CARDS;
      ACT_SHOWSHUFFLED: Result := GA_SHOW_CARDS_SHUFFLED;
      ACT_MUCK: Result := GA_MUCK;
      ACT_DONTSHOW: Result := GA_DONT_SHOW;
      ACT_SITOUT: Result := GA_SIT_OUT;
      ACT_BACK: Result := GA_BACK;
      ACT_LEAVETABLE: Result := GA_LEAVE_TABLE;
    else
      Result := GA_NONE;
    end;
  end;

  function ConvertPoSuitToCardEngineSuit(aSuit: TpoCardSuit): TCardSuitType;
  begin
    case aSuit of
      uPokerBase.CS_CLUB     : Result := CST_CLUBS;
      uPokerBase.CS_DIAMOND  : Result := CST_DIAMANDS;
      uPokerBase.CS_HEART    : Result := CST_HEARTS;
      uPokerBase.CS_SPADE    : Result := CST_SPADES;
    else
      Result := CST_NONE;
    end;
  end;

  function ConvertPoValueToCardEngineRank(aValue: TpoCardValue): TCardRankType;
  var
    nInd: Integer;
  begin
    nInd := Integer(aValue);
    Result := TCardRankType(15 - nInd);
  end;

var
  nSecTimeout: Integer;
  aCardPack: TCardList;
  aCard: TCard;
  aPoCard: TpoCard;
  I: Integer;
  nMaxStake, nTag: Integer;
begin
  aBotTable := TBotTable.Create(XMLSetActivePlayer, Self, aGamer.UserID);
  aBotUser  := TBotUser.Create(XMLSetActivePlayer, aGamer);

  aCardPack := TCardList.Create(True);
  for I:=0 to FTable.Hand.CardsToDeal.Count - 1 do begin
    aPoCard := FTable.Hand.CardsToDeal.Cards[I];
    aCard := TCard.Create(
      ConvertPoSuitToCardEngineSuit(aPoCard.Suit),
      ConvertPoValueToCardEngineRank(aPoCard.Value)
    );
    aCardPack.Add(aCard);
  end;

  FTable.Hand.CardsToDeal.FormSeries(True);
  aBotAutoResponse := TBotAutoResponse.Create(aBotTable, aBotUser, aCardPack);

  aAvailableAnswer := aBotAutoResponse.Answer;
  Result := ConvertBotActionToEngineAction(aAvailableAnswer.AnswerType);
  aGamer.BotBlaffersEvent := aBotUser.BlaffersEvent;
  aGamer.CountOfRases := aBotUser.CountOfRases;

  nSecTimeout := GetBotsTimeOutAnswer(Result);

  nBotStake := aAvailableAnswer.Stake;
  nBotDead  := aAvailableAnswer.Dead;
  nMaxStake := aAvailableAnswer.MaxStake;
  nTag      := aAvailableAnswer.Tag;
  if (Croupier.StakeType in [ST_POT_LIMIT, ST_NO_LIMIT]) and
     (aAvailableAnswer.AnswerType = ACT_RAISE)
  then begin
    if (aGamer.BotBlaffersEvent <= 0) then begin
      if ((aGamer.Account.Balance - 2) > nBotStake) then
        nBotStake := aGamer.Account.Balance - 2;
    end else begin
      if (aGamer.CountOfRases > 1) then
        nBotStake := aGamer.Account.Balance
      else
        nBotStake := nBotStake + Random(aGamer.Account.Balance);
      if (nBotStake > aGamer.Account.Balance) then
        nBotStake := aGamer.Account.Balance;
    end
  end;

  // aCardPack no need delete (deleted in TBotAutoResponse object)
  aBotAutoResponse.Free;
  aBotUser.Free;
  aBotTable.Free;

  { Create reminder for bot answer by Result as timeout }
  if (nSecTimeout > 0) then begin
    SetupBotActionTimeout(aGamer,
      Result,
      nBotStake, nMaxStake, nBotDead,
      nTag, nSecTimeout
    );
    Result := GA_NONE;
  end else begin
    (FCroupier as TpoSingleTableCroupier).InvokeBotAction(aGamer, Result, nBotStake, nBotDead);
  end;
end;

function TpoBasicGameEngine.HandleEventBotActionExpired(nSessionID,
  nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
  nUserID: Integer;
  bReminderWasFound: Boolean;
  nAction: TpoGamerAction;
  nBotStake, nBotDead: Integer;
begin
  Result:= nil;

  nUserID := StrToIntDef(aActionInfo.Attributes[PPTA_USER_ID], -1);
  bReminderWasFound := DeleteIntervalByUserIDAndName(nUserID, PPTN_BOT_EVENT);
  DeleteIntervalByUserIDAndName(nUserID);
  nAction := GA_NONE;
  if aActionInfo.HasAttribute(PPTA_ACTION) then
    nAction := TpoGamerAction(StrToInt(aActionInfo.Attributes[PPTA_ACTION]));
  nBotStake  := -1;
  if aActionInfo.HasAttribute(PPTA_STAKE) then
    nBotStake  := StrToIntDef(aActionInfo.Attributes[PPTA_STAKE], -1);
  nBotDead   := -1;
  if aActionInfo.HasAttribute(PPTA_DEAD) then
    nBotDead   := StrToIntDef(aActionInfo.Attributes[PPTA_DEAD], -1);

  if nAction = GA_NONE then Exit;

  g:= Table.Gamers.GamerByUserID(nUserID);
  if g = nil then Exit;//gamer left current process
  if bReminderWasFound then begin
    if (FTable.Hand.ActiveGamer = nil) OR (FTable.Hand.ActiveGamer <> g) then Exit;
    if Table.Hand.State <> HST_RUNNING then Exit;

    (FCroupier as TpoSingleTableCroupier).InvokeBotAction(g, nAction, nBotStake, nBotDead);
    PostProcessGamerActionExpired(g);
  end;//
end;

function TpoBasicGameEngine.SetupBotsSitDownForMiniTournayActionTimeout(
  nTypeBots, nBotsCount, nTimeOut: Integer): TpoReminder;
var
  nch, n: IXMLNode;
begin
  n := FResponseRoot.AddChild(PPTN_BOT_SITDOWN);
  n.Attributes[PPTA_TYPE] := nTypeBots;
  n.Attributes[PPTA_MAX_PER_PROCESS] := nBotsCount;

  nch := n.AddChild(PPTN_PROCESS);
  nch.Attributes[PPTA_ID] := ProcessID;

  Result:= ScheduleSecIntervalEx(PPTT_TOURNAMENT_SCHEDULER_PACKET, PPTV_GAME_ADAPTOR, nTimeOut, n, False);
end;

procedure TpoBasicGameEngine.SetPassword(const Value: string);
begin
  FPassword := Value;
end;

function TpoBasicGameEngine.HandleCheckEnter(nSessionID,
  nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  aGamer: TpoGamer;
  nInvited: Integer;
  nPassword: Integer;
  nLimited: Integer;
  sConfigData: string;
  nRes: Integer;
  nWatchersCount: Integer;
  MaxWatchersAllowed: Integer;
  nUserID: Integer;
begin

  nUserID := -1;
  if aActionInfo.HasAttribute(PPTA_USER_ID) then
    nUserID := StrToIntDef(aActionInfo.Attributes[PPTA_USER_ID], -1);

  { check on exists gamer with userID }
  aGamer := FTable.Gamers.GamerByUserID(nUserID);
  if (aGamer <> nil) then begin
    Result := PrepareOutputPacket(RB_REQUESTER, True);
    PrepareCheckEnterPacket(Result, 0, 1, 0);
    DispatchResponse(nSessionID, Result, False, nUserID);
    Exit;
  end;


  { get system options }
  sConfigData := '10';
  nRes := FApi.GetSystemOption(ID_MAXIMUM_WATCHERS_ALLOWED, sConfigData);
  if (nRes <> NO_ERROR) then begin
    CommonDataModule.Log(ClassName, 'HandleCheckEnter',
      '[ERROR] On execute FApi.GetSystemOption: Result=' + IntToStr(nRes) +
      '; Params: OptionID=' + IntToStr(ID_MAXIMUM_WATCHERS_ALLOWED) + '.',
      ltError);
    sConfigData := '10';
  end;
  MaxWatchersAllowed := StrToIntDef(sConfigData, 10);

  { validate access by invitedusers }
  nWatchersCount := FTable.Gamers.CountOfWatchers;
  FApi.CheckOnAccessByInvitedUsers(ProcessID, 0, nUserID, nInvited);
  if (nInvited <= 0) or (nWatchersCount >= MaxWatchersAllowed) then begin
    nPassword := 0;
    nInvited := 0;
    nLimited := Integer(not FIsWatchingAllowed);
  end else begin
    nPassword := Integer(FPassword <> '');
    nInvited := 1;
    nLimited := 0;
  end;

  Result := PrepareOutputPacket(RB_REQUESTER, True);
  PrepareCheckEnterPacket(Result, nPassword, nInvited, nLimited);
  DispatchResponse(nSessionID, Result, False, nUserID);
end;

procedure TpoBasicGameEngine.SetIsWatchingAllowed(const Value: Boolean);
begin
  FIsWatchingAllowed := Value;
end;

function TpoBasicGameEngine.PrepareCheckEnterPacket(aParent: IXMLNode;
  nPassword, nInvited, nLimited: Integer): IXMLNode;
begin
  if aParent <> nil then Result:= aParent.AddChild(PPTN_CHECK_ENTER)
  else Result:= FResponseRoot.AddChild(PPTN_CHECK_ENTER);

  Result.Attributes[PPTA_PASSWORD] := nPassword;
  Result.Attributes[PPTA_INVITED] := nInvited;
  Result.Attributes[PPTA_LIMITED] := nLimited;
  Result.Attributes[PPTA_TABLE_NAME] := ProcessName;
end;

procedure TpoBasicGameEngine.StoreStateAsCached;
begin
  Store(FStateManager.OutStream);
  FStateManager.OutStream.FlushBuffer;
  FStateManager.CachedState := FStateManager.FOutCache.DataString;
end;

function TpoBasicGameEngine.PreparePushingContentPacket(aParent: IXMLNode): IXMLNode;
var
  XML: IXMLDocument;
  aNode: IXMLNode;
  sData: string;
  nRes, I: Integer;
begin
  try
    nRes := FApi.GetPushingContentFiles(2, ProcessID, 0, sData);
    if (nRes <> 0) then begin
      CommonDataModule.Log(ClassName, 'PreparePushingContentPacket',
        '[ERROR] on exec FApi.GetPushingContentFiles: Result=' + IntToStr(nRes) +
        ' ; Params: nType=2, ProcessID=' + IntToStr(ProcessID) +
        ', UserID=0, RootNodeName="' + PPTN_PUSHING_CONTENT,
        ltError
      );
      sData := '<' + PPTN_PUSHING_CONTENT + '/>';
    end;

  except
    on E: Exception do begin
      CommonDataModule.Log(ClassName, 'PreparePushingContentPacket',
        '[EXCEPTION] on exec FApi.GetPushingContentFiles: Message=[' + E.Message +
        ' ; Params: nType=2, ProcessID=' + IntToStr(ProcessID) +
        ', UserID=0, RootNodeName="' + PPTN_PUSHING_CONTENT,
        ltException
      );
      sData := '<' + PPTN_PUSHING_CONTENT + '/>';
    end;
  end;

  XML := TXMLDocument.Create(nil);
  try
    XML.XML.Text := sData;
    XML.Active := True;
  except
    on E: Exception do begin
      CommonDataModule.Log(ClassName, 'PreparePushingContentPacket',
        '[EXCEPTION] on get data as XML: Message=[' + E.Message +
        ' ; Data=[' + sData + ']',
        ltException
      );

      XML := nil;
      { empty child nodes }
      if aParent <> nil then Result:= aParent.AddChild(PPTN_PUSHING_CONTENT)
      else Result:= FResponseRoot.AddChild(PPTN_PUSHING_CONTENT);
      Exit;
    end;
  end;

  if aParent <> nil then Result:= aParent.AddChild(PPTN_PUSHING_CONTENT)
  else Result:= FResponseRoot.AddChild(PPTN_PUSHING_CONTENT);

  for I:=0 to XML.DocumentElement.ChildNodes.Count - 1 do begin
    aNode := XML.DocumentElement.ChildNodes[I];
    Result.ChildNodes.Add(aNode.CloneNode(True));
  end;

  XML := nil;
end;

{ TGameProperty }

function TGameProperty.AddConstraint(sName, sValue: String): TGamePropertyConstraint;
var
  gpc: TGamePropertyConstraint;
begin
  gpc:= ConstraintByName(sName);
  if (gpc = nil) OR ((sName = GPC_CHOICE_VAL) AND (gpc.Value <> sValue)) then begin
    Result:= TGamePropertyConstraint.Create(sName, sValue);
  	Add(Result);
  end else begin
    Result:= gpc;
    Result.Value:= sValue;
  end;//
end;

function TGameProperty.ConstraintByName(
  sName: String): TGamePropertyConstraint;
var
  I: Integer;
begin
  Result:= nil;
  for I:= 0 to Count-1 do begin
    if Constraint[I].Name = sName then begin
      Result:= Constraint[I];
      Exit;
    end;//if
	end;//for
end;

constructor TGameProperty.Create(
	sName, sValue: String;
	sPropType: TGamePropertyType; sModifier: TGamePropertyModifier
);
begin
	inherited Create;
  OwnsObjects := TRUE;
	Name				:= sName;
	Value				:= sValue;
	PropType		:= sPropType;
	Modifier		:= sModifier;
end;

destructor TGameProperty.Destroy;
begin
  Clear;
  inherited;
end;

function TGameProperty.GetAsBoolean: Boolean;
begin
  Result:= Boolean(GetBoolToNumber())
end;

function TGameProperty.GetAsDouble: Double;
var
  sVal: String;
begin
  ThousandSeparator:= ',';
  DecimalSeparator:= '.';
  sVal:= UpperCase(Trim(Value));
  if sVal <> '' then
  begin
    if NOT (sVal[1] IN ['0'..'9', '+', '-', 'E', '.']) then
      sVal[1]:= ' ';
    sVal:= UpperCase(Trim(sVal));
    Result:= StrToFloat(sVal);
  end
  else
    Result := 0;
end;

function TGameProperty.GetAsInteger: Integer;
begin
  if Trim(Value) = '' then Result:= 0
  else Result:= StrToInt(Value);
end;

function TGameProperty.GetAsTimeString: String;
begin
  if NOT IsNumber then Result:= Value
  else Result:= FormatDateTime(SBG_TIME_FORMAT, EncodeTime(0, AsInteger, 0, 0));
end;

function TGameProperty.GetBoolToNumber: Integer;
begin
	Result:= 0;
	if UpperCase(Trim(Value)) = 'TRUE' then Result:= 1
  else
  if Trim(Value) = '1' then Result:= 1;
end;

function TGameProperty.GetConstraint(
	Index: Integer): TGamePropertyConstraint;
begin
	Result:= Items[Index] as TGamePropertyConstraint;
end;

function TGameProperty.GetConstraintCount: Integer;
begin
	Result:= Count;
end;

function TGameProperty.GetIsNumber: Boolean;
begin
  Result:= True;
  try
    StrToFloat(Value);
  except
    Result:= False;
  end;//try
end;

function TGameProperty.Load(aReader: TReader): Boolean;
var
	I, nCnt: Integer;
begin
  Clear;
	Name				:= aReader.ReadString;
  Alias       := aReader.ReadString;
	Value				:= aReader.ReadString;
	PropType		:= TGamePropertyType(aReader.ReadInteger);
	Modifier		:= TGamePropertyModifier(aReader.ReadInteger);
	nCnt        := aReader.ReadInteger;
	for I:= 0 to nCnt-1 do AddConstraint('', '').Load(aReader);
  TimeUnits   := TTimeUnits(aReader.ReadInteger());
	Result:= True;
end;//TGameProperty.Load

procedure TGameProperty.SetAlias(const Value: String);
begin
  FAlias := Value;
end;

procedure TGameProperty.SetAsDouble(const Value: Double);
begin
  ThousandSeparator:= ',';
  DecimalSeparator:= '.';
  Self.Value:= Format('%f', [Value]);
end;

procedure TGameProperty.SetAsInteger(const Value: Integer);
begin
  Self.Value:= IntToStr(Value);
end;

procedure TGameProperty.SetIsModified(const Value: Boolean);
begin
  FIsModified := Value;
end;

procedure TGameProperty.SetModifier(const Value: TGamePropertyModifier);
begin
  FModifier := Value;
end;

procedure TGameProperty.SetName(const Value: String);
begin
  FName := Value;
end;

procedure TGameProperty.SetPropType(const Value: TGamePropertyType);
begin
  FPropType := Value;
end;

procedure TGameProperty.SetTimeUnits(const Value: TTimeUnits);
begin
  FTimeUnits := Value;
end;

procedure TGameProperty.SetValue(const Value: String);
begin
  if FValue <> Value then FIsModified:= True;
  FValue := Value;
end;

function TGameProperty.Store(aWriter: TWriter): Boolean;
var
	I: Integer;
begin
	aWriter.WriteString (Name);
	aWriter.WriteString (Alias);
	aWriter.WriteString (Value);
	aWriter.WriteInteger(Integer(PropType));
	aWriter.WriteInteger(Integer(Modifier));
	aWriter.WriteInteger(Count);

	for I:= 0 to Count-1 do Constraint[I].Store(aWriter);
  aWriter.WriteInteger(Integer(TimeUnits));

	Result:= True;
end;


{ TGamePropertyConstraint }

constructor TGamePropertyConstraint.Create(sName, sValue: String);
begin
	inherited Create;
	Name:= sName;
	Value:= sValue;
end;

destructor TGamePropertyConstraint.Destroy;
begin
  inherited;
end;

function TGamePropertyConstraint.Load(aReader: TReader): Boolean;
begin
	Name:= aReader.ReadString;
	Value:= aReader.ReadString;
	Result:= True;
end;

function TGamePropertyConstraint.Store(aWriter: TWriter): Boolean;
begin
	aWriter.WriteString(Name);
	aWriter.WriteString(Value);
	Result:= True;
end;

{ TGameProperties }

function TGameProperties.AddProperty(
	sName, sValue: String;
	sPropType: TGamePropertyType; sModifier: TGamePropertyModifier
): TGameProperty;
begin
  Result:= PropertyByName(sName);
  if Result = nil then begin
  	Result:= TGameProperty.Create(sName, sValue, sPropType, sModifier);
    Result.Alias:= sName;
	  Add(Result);
  end else Result.Value:= sValue;
end;

constructor TGameProperties.Create;
begin
	inherited Create;
  OwnsObjects := TRUE;
end;

destructor TGameProperties.Destroy;
begin
  Clear;
	inherited;
end;

function TGameProperties.GetProperty(Index: Integer): TGameProperty;
begin
	Result:= Items[Index] as TGameProperty;
end;

function TGameProperties.Load(aReader: TReader): Boolean;
var
	I, nCnt: Integer;
begin
  Clear;
	nCnt:= aReader.ReadInteger;
	for I:= 0 to nCnt-1 do AddProperty('', '').Load(aReader);
	Result:= True;
end;//TGameProperties.Load


function TGameProperties.PropertyByName(sName: String): TGameProperty;
var
	I: Integer;
begin
	Result:= nil;
	for I:= 0 to Count-1 do begin
		if (Properties[I].Alias = sName) OR (Properties[I].Name = sName) then begin
			Result:= Properties[I];
			Exit;
		end;//
	end;//for
end;

function TGameProperties.Store(aWriter: TWriter): Boolean;
var
	I: Integer;
begin
	aWriter.WriteInteger(Count);
	for I:= 0 to Count-1 do Properties[I].Store(aWriter);
	Result:= True;
end;//TGameProperties.Store

{ TpoApiStateManager }

const
  DEF_STATE_NUMBER = 1;
  SERVICE_STATE_NUMBER = 999;

function TpoApiStateManager.CacheState(): Boolean;
var
  sReason: WideString;
  nRes: Integer;
  sStrData: String;
begin
  sReason:= '';
  CommonDataModule.Log(ClassName, 'CacheState', 'CacheState: without FEngine.FApi.BeginTransaction', ltCall);

  FTransactionStarted:= True;

  nRes:= FEngine.FApi.GetState(ProcessID, DEF_STATE_NUMBER, sStrData);

  EscalateFailure(
    nRes,
    EpoException,
    sReason,
    '{A42F69CF-4A0E-42CD-ADCE-798A0B7D2A72}',
    GE_ERR_STATE_LOAD_FAILURE
  );//EscalateFailure

  FCachedState:= sStrData;
  if FInStream <> nil then FInStream.Free;
  if FInCache <> nil then FInCache.Free;
  FInCache:= TStringStream.Create(sStrData);
  FInStream:= TReader.Create(FInCache, 500);
  Result:= True;
end;


function TpoApiStateManager.CacheState(StrState: string): Boolean;
var
  sStrData: String;
begin
  sStrData:= StrState;
  FCachedState:= sStrData;
  if FInStream <> nil then FInStream.Free;
  if FInCache <> nil then FInCache.Free;

  FInCache:= TStringStream.Create(sStrData);
  FInStream:= TReader.Create(FInCache, 500);
  Result:= True;
end;

constructor TpoApiStateManager.Create(
  nProcessID: Integer; aEngine: TpoBasicGameEngine);
begin
  inherited Create;
  FProcessID:= nProcessID;
  FUseApi:= True;
  FEngine:= aEngine;
end;

destructor TpoApiStateManager.Destroy;
begin
  FInStream.Free;
  FInCache.Free;
  FOutStream.Free;
  FoutCache.Free;
  inherited;
end;

procedure TpoBasicGameEngine.SetProcessID(const Value: Integer);
begin
  FProcessID := Value;
end;

procedure TpoBasicGameEngine.InitGameProperties();
var
  gp: TGameProperty;
  sConfigData: string;
  nRes: Integer;
begin
//init proprietary
//init generic properties
  gp:= Fproperties.AddProperty(
    PP_POKER_TYPE, PPDV_POKER_TYPE, PPT_POKER_TYPE
  );

  gp.AddConstraint(
    PPCN_POKER_TYPE_TEXAS, PPCV_POKER_TYPE_TEXAS
  );
  gp.AddConstraint(
    PPCN_POKER_TYPE_OMAHA         , PPCV_POKER_TYPE_OMAHA
  );
  gp.AddConstraint(
    PPCN_POKER_TYPE_OMAXA_HL      , PPCV_POKER_TYPE_OMAXA_HL
  );
  gp.AddConstraint(
    PPCN_POKER_TYPE_SEVEN_STUD    , PPCV_POKER_TYPE_SEVEN_STUD
  );
  gp.AddConstraint(
    PPCN_POKER_TYPE_SEVEN_STUD_HL , PPCV_POKER_TYPE_SEVEN_STUD_HL
  );

  gp:= FProperties.AddProperty(
    PP_TOURNAMENT_TYPE, PPDV_TOURNAMENT_TYPE, PPT_TOURNAMENT_TYPE
  );

  gp.AddConstraint(
    PPCN_NOT_TURNAMENT         , PPCV_NOT_TURNAMENT
  );
  gp.AddConstraint(
    PPCN_TURNAMENT_SINGLE_TABLE, PPCV_TURNAMENT_SINGLE_TABLE
  );

  gp.AddConstraint(
     PPCN_TURNAMENT_MULTY_TABLE , PPCV_TURNAMENT_MULTY_TABLE
  );


  { get common System data }
  nRes := FApi.GetSystemOption(ID_MAXIMUM_CHAIRS_COUNT, sConfigData);
  if (nRes <> NO_ERROR) then begin
    CommonDataModule.Log(ClassName, 'InitGameProperties',
      '[ERROR] On execute FApi.GetSystemOption: Result=' + IntToStr(nRes) + '; Params: OptionID=' + IntToStr(ID_MAXIMUM_CHAIRS_COUNT) + '.',
      ltError);
    sConfigData := PPDV_MAX_CHAIRS_COUNT;
  end;
  FProperties.AddProperty(
    PP_MAX_CHAIRS_COUNT, sConfigData, PPT_MAX_CHAIRS_COUNT
  );

  FProperties.AddProperty(
    PP_MIN_GAMERS_FOR_START, PPDV_MIN_GAMERS_FOR_START, PPT_MIN_GAMERS_FOR_START
  );

  gp:= FProperties.AddProperty(
    PP_TYPE_OF_STAKES, PPDV_TYPE_OF_STAKES, PPT_TYPE_OF_STAKES
  );

  gp.AddConstraint(
    PPCN_TYPE_OF_STAKES_FIXED_LIMIT, PPCV_TYPE_OF_STAKES_FIXED_LIMIT
  );
  gp.AddConstraint(
    PPCN_TYPE_OF_STAKES_POT_LIMIT  , PPCV_TYPE_OF_STAKES_POT_LIMIT
  );
  gp.AddConstraint(
    PPCN_TYPE_OF_STAKES_NO_LIMIT   , PPCV_TYPE_OF_STAKES_NO_LIMIT
  );


  FProperties.AddProperty(
    PP_STATISTIC, PPDV_STATISTIC, PPT_STATISTIC
  );

  FProperties.AddProperty(
    PP_LOWER_STAKES_LIMIT, PPDV_LOWER_STAKES_LIMIT, PPT_LOWER_STAKES_LIMIT
  );

  FProperties.AddProperty(
    PP_GAMER_AMOUNT_CONSTRAINT, PPDV_GAMER_AMOUNT_CONSTRAINT, PPT_GAMER_AMOUNT_CONSTRAINT
  );

  FProperties.AddProperty(
    PP_MINIMUM_GAMER_AMOUNT, PPDV_MINIMUM_GAMER_AMOUNT, PPT_MINIMUM_GAMER_AMOUNT
  );

  FProperties.AddProperty(
    PP_MAXIMUM_GAMER_AMOUNT, PPDV_MAXIMUM_GAMER_AMOUNT, PPT_MAXIMUM_GAMER_AMOUNT
  );

  FProperties.AddProperty(
    PP_DEFAULT_GAMER_AMOUNT, PPDV_DEFAULT_GAMER_AMOUNT, PPT_DEFAULT_GAMER_AMOUNT
  );

  FProperties.AddProperty(
    PP_USE_ALL_INS, PPDV_USE_ALL_INS, PPT_USE_ALL_INS
  );

  FProperties.AddProperty(
    PP_ST_TOURNAMENT_BUY_IN, PPDV_ST_TOURNAMENT_BUY_IN, PPT_ST_TOURNAMENT_BUY_IN
  );

  FProperties.AddProperty(
    PP_ST_TOURNAMENT_FEE, PPDV_ST_TOURNAMENT_FEE, PPT_ST_TOURNAMENT_FEE
  );

  FProperties.AddProperty(
    PP_ST_TOURNAMENT_CHIPS, PPDV_ST_TOURNAMENT_CHIPS, PPT_ST_TOURNAMENT_CHIPS
  );

  FProperties.AddProperty(
    PP_ST_TOURNAMENT_UseBasePrizes, PPDV_ST_TOURNAMENT_UseBasePrizes, PPT_ST_TOURNAMENT_UseBasePrizes
  );

  gp:= FProperties.AddProperty(
    PP_ST_TOURNAMENT_BasePayment, PPDV_ST_TOURNAMENT_BasePayment, PPT_ST_TOURNAMENT_BasePayment
  );
  gp.AddConstraint(
    PPCN_ST_TOURNAMENT_BasePaymentPercent, PPCV_ST_TOURNAMENT_BasePaymentPercent
  );
  gp.AddConstraint(
    PPCN_ST_TOURNAMENT_BasePaymentFixVal , PPCV_ST_TOURNAMENT_BasePaymentFixVal
  );

  FProperties.AddProperty(
    PP_ST_TOURNAMENT_BasePrizeFirst, PPDV_ST_TOURNAMENT_BasePrizeFirst, PPT_ST_TOURNAMENT_BasePrizeFirst
  );

  FProperties.AddProperty(
    PP_ST_TOURNAMENT_BasePrizeSecond, PPDV_ST_TOURNAMENT_BasePrizeSecont, PPT_ST_TOURNAMENT_BasePrizeSecond
  );

  FProperties.AddProperty(
    PP_ST_TOURNAMENT_BasePrizeThird, PPDV_ST_TOURNAMENT_BasePrizeThird, PPT_ST_TOURNAMENT_BasePrizeThird
  );

  FProperties.AddProperty(
    PP_ST_TOURNAMENT_UseBonusPrizes, PPDV_ST_TOURNAMENT_UseBonusPrizes, PPT_ST_TOURNAMENT_UseBonusPrizes
  );

  gp:= FProperties.AddProperty(
    PP_ST_TOURNAMENT_BonusPayment, PPDV_ST_TOURNAMENT_BonusPayment, PPT_ST_TOURNAMENT_BonusPayment
  );
  gp.AddConstraint(
    PPCN_ST_TOURNAMENT_BonusPaymentPercent, PPCV_ST_TOURNAMENT_BonusPaymentPercent
  );
  gp.AddConstraint(
    PPCN_ST_TOURNAMENT_BonusPaymentFixVal , PPCV_ST_TOURNAMENT_BonusPaymentFixVal
  );

  FProperties.AddProperty(
    PP_ST_TOURNAMENT_BonusPrizeFirst, PPDV_ST_TOURNAMENT_BonusPrizeFirst, PPT_ST_TOURNAMENT_BonusPrizeFirst
  );

  FProperties.AddProperty(
    PP_ST_TOURNAMENT_BonusPrizeSecond, PPDV_ST_TOURNAMENT_BonusPrizeSecont, PPT_ST_TOURNAMENT_BonusPrizeSecond
  );

  FProperties.AddProperty(
    PP_ST_TOURNAMENT_BonusPrizeThird, PPDV_ST_TOURNAMENT_BonusPrizeThird, PPT_ST_TOURNAMENT_BonusPrizeThird
  );
end;

function TpoBasicGameEngine.GetActionGamer(
  nSessionID, nUserIDAttr: Integer; bValidateStepRight, bNeedUpdateFromDB: Boolean): TpoGamer;
var
  aGamer: TpoGamer;
begin
  Result:= Table.Gamers.GamerBySessionID(nSessionID);

  if (Result = nil) or bNeedUpdateFromDB then begin //special case - gamer is reconnected
    Result:= UpdateParticipantInfo(nSessionID, nUserIDAttr, bNeedUpdateFromDB);
    if Result = nil then begin
      CommonDataModule.Log(ClassName, 'GetActionGamer',
        'There is no gamer with corresponding session ID=' + IntToStr(nSessionID), ltError);
      EscalateFailure(
        EpoSessionException, 'There is no gamer with corresponding session ID', '{E89A8DFD-F3CF-45BD-86C7-DD3F494E679C}'
      );
      Exit;
    end;//if
  end else begin
    if (nUserIDAttr > 0) and (Result.UserID <= 0) then begin
      aGamer := FTable.Gamers.GamerByUserID(nUserIDAttr);
      if (aGamer <> nil) then begin
        Result := aGamer;
      end else begin
        Result.UserID := nUserIDAttr;
      end;
      UpdateParticipantInfo(Result, bNeedUpdateFromDB);
    end;
  end;//if

//check inputs
  if bValidateStepRight then begin
    if Table.ActiveGamer = nil then begin
      EscalateFailure(
        EpoUnexpectedActionException, 'Step right gamer is not defined', '{735570BE-5B2E-4245-8384-BD4F13A01795}'
      );
    end;//
    if (Result <> nil) then begin
      if Result <> Table.ActiveGamer then begin
        CommonDataModule.Log(ClassName, 'GetActionGamer',
          'Action gamer does not have step right: SessionID=' + IntToStr(nSessionID), ltError);
        EscalateFailure(
          EpoSessionException, 'Action gamer does not have step right', '{3725E258-3948-4EA8-8262-8505FE8A72F0}'
        );
      end;//
    end;
  end;//
end;//TpoGenericPokerGameEngine.GetActionGamer

procedure TpoBasicGameEngine.OnChatMessage(sMsg, sTitle: String; aGamer:
    TpoGamer; nOriginator: TpoMessageOriginator; nPriority: Integer);
var
  nUserID: Integer;
  n: IXMLNode;
begin
  if sMsg = '' then Exit;
  if aGamer <> nil then nUserID:= aGamer.UserID
  else nUserID:= UNDEFINED_USER_ID;
  n:= PrepareChatPacket(PrepareOutputPacket(RB_ALL, True), sMsg, nOriginator, nPriority, nUserID);
  DispatchResponse(0, n);
  PushHistoryEntry(0, n);
end;

procedure TpoBasicGameEngine.OnGamerAction(aGamer: TpoGamer; nAction:
    TpoGamerAction; vInfo: array of Variant);
var
  pn, n: IXMLNode;
  sLogStakeInfo: String;
begin
  pn:= PrepareOutputPacket(RB_ALL, True);
  sLogStakeInfo:= '';
  case Length(vInfo) of
    0:
      begin
        n:= PrepareGamerActionPacket(pn, aGamer, nAction);
      end;//
    1:
      begin
        n:= PrepareGamerActionPacket(pn, aGamer, nAction, vInfo[0]);
        sLogStakeInfo:= 'Stake: '+FloatToStr(vInfo[0]/100);
      end;//
    2:
      begin
        n:= PrepareGamerActionPacket(pn, aGamer, nAction, vInfo[0], vInfo[1]);
        sLogStakeInfo:= 'Stake (post): '+FloatToStr(vInfo[0]/100)+' Stake (dead): '+FloatToStr(vInfo[1]/100);
      end;//
  end;//case

  if (nAction = GA_ALL_IN) and not aGamer.IsBot then begin
    FApi.UserMakeAllIn(aGamer.UserID);
  end;//if

  if nAction = GA_USE_TIMEBANK then begin
    n.Attributes[PPTA_TIMEBANK]:= aGamer.TournamentTimebank;
  end;//if

  DispatchResponse(aGamer.SessionID, n);

  PushHistoryEntry(aGamer.SessionID, n);
end;

function TpoApiStateManager.FlushState: Boolean;
var
  sReason: WideString;
  nRes: Integer;
  sStrData: string;
begin
  if FOutCache = nil then
  EscalateFailure(
    EpoException,
    'Output cache is not initialized - there is nothing to store',
    '{56C30994-F723-4C7B-AC42-735546B5EAFE}',
    GE_ERR_STATE_STORE_FAILURE
  );

//save base state
  sReason:= '';
  FOutStream.FlushBuffer;
  sStrData:= FOutCache.DataString;

  nRes:= FEngine.FApi.SetState(ProcessID, DEF_STATE_NUMBER, sStrData);
  EscalateFailure(
    nRes,
    EpoException,
    sReason,
    '{427BCA7D-1E20-4208-B8C8-AF4BF9AF1B9A}',
    GE_ERR_STATE_STORE_FAILURE
  );

  FOutStream.Free; FOutStream:= nil;
  FOutCache.Free; FOutCache:= nil;

//save service state
  sReason:= '';
  nRes:= FEngine.FApi.SetState(ProcessID, SERVICE_STATE_NUMBER, FServiceState);

  EscalateFailure(
    nRes,
    EpoException,
    sReason,
    '{6B441928-AC44-4E57-882D-4BA787F3C380}',
    GE_ERR_STATE_STORE_FAILURE
  );

  Result:= True;
end;//TpoApiStateManager.FlushState


function TpoApiStateManager.FlushState(var StrState: string; var StrServiceState: string): Boolean;

var
  sStrData: string;
begin
  if FOutCache = nil then
  EscalateFailure(
    EpoException,
    'Output cache is not initialized - there is nothing to store',
    '{F2ADBFDF-7AD7-4493-919E-499582BA1A20}',
    GE_ERR_STATE_STORE_FAILURE
  );

//save base state
  FOutStream.FlushBuffer;
  sStrData:= FOutCache.DataString;
  StrState:= sStrData;

//save service state
  StrServiceState:= FServiceState;

//clean up
  FOutStream.Free; FOutStream:= nil;
  FOutCache.Free; FOutCache:= nil;
  Result:= True;
end;

function TpoApiStateManager.GetInStream: TReader;
begin
  Result:= FInStream;
  if Result = nil then begin
    EscalateFailure(
      EpoException,
      'Game state must be cached before being accessed. Use CacheState before.',
      '{B8079437-0E1A-477E-B6C8-D90A1C813020}',
      GE_ERR_STATE_LOAD_FAILURE
    );
  end;//if
end;

function TpoApiStateManager.GetOutServiceStream: TWriter;
begin
  if FOutServiceStream = nil then begin
    if FOutServiceCache = nil then FOutServiceCache:= TStringStream.Create('');
    FOutServiceStream:= TWriter.Create(FOutServiceCache, 500);
  end;//
  Result:= FOutServiceStream;
end;

function TpoApiStateManager.GetOutStream: TWriter;
begin
  if FOutStream = nil then begin
    if FOutCache = nil then FOutCache:= TStringStream.Create('');
    FOutStream:= TWriter.Create(FOutCache, 500);
  end;//
  Result:= FOutStream;
end;


function TpoApiStateManager.InitState(): Boolean;
var
  sReason: WideString;
begin
  Result:= True;
  sReason:= '';
  if FUseApi then begin
    CommonDataModule.Log(ClassName, 'InitState', 'InitState: without FEngine.FApi.BeginTransaction', ltCall);

    FEngine.FApi.CreateState(FProcessID, DEF_STATE_NUMBER, FStateID);
    EscalateFailure(EpoException, sReason, '{7A616A29-A1EE-4B88-AB8E-3ADDF99E0592}');
    FEngine.FApi.CreateState(FProcessID, SERVICE_STATE_NUMBER, FServiceStateID);
    EscalateFailure(EpoException, sReason, '{FD073081-3ABC-4920-B778-14086BE6D810}');
  end;//if
end;


procedure TpoApiStateManager.RollbackChanges;
begin
  Exit;
  try
    EscalateFailure(
      FEngine.FApi.RollbackTransaction(),
      EpoException,
      '',
      '{D3C91A07-BE56-4FF7-9662-E468747FFF62}'
    );
  except
    on e: Exception do begin
      CommonDataModule.Log(ClassName, 'RollbackChanges', '[EXCEPTION]: ' + e.Message, ltException);
    end;//
  end;//try
end;

procedure TpoApiStateManager.SetCachedState(const Value: String);
begin
  FCachedState := Value;
end;

procedure TpoApiStateManager.SetServiceState(const Value: String);
begin
  FServiceState := Value;
end;

procedure TpoApiStateManager.SetServiceStateID(const Value: Integer);
begin
  FServiceStateID := Value;
end;

procedure TpoApiStateManager.SetStateID(const Value: Integer);
begin
  FStateID := Value;
end;

{ TpoGenericPokerGameEngine }

constructor TpoGenericPokerGameEngine.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FMoreChipsSuspendedOperations  := TpoMoreChipsSuspendedOperationList.Create;
  FTournayApiSuspendedOperations := TpoTournayApiSuspendedOperationList.Create;
end;

procedure TpoGenericPokerGameEngine.SetupCroupier(aCroupier: TpoGenericCroupier);
begin
  inherited SetupCroupier(aCroupier);

//setup event hooks
  FCroupier.OnHandFinish         :=  OnHandFinish         ;
  FCroupier.OnHandStarting       :=  OnHandStarting       ;
  FCroupier.OnHandStarted        :=  OnHandStarted        ;
  FCroupier.OnAbandonHandStarting:=  OnAbandonHandStarting;
  FCroupier.OnHandStart          :=  OnHandStart          ;
  FCroupier.OnChairStateChange   :=  OnChairStateChange   ;
  FCroupier.OnSetActivePlayer    :=  OnSetActivePlayer    ;
  FCroupier.OnRoundFinish        :=  OnRoundFinish        ;
  FCroupier.OnMoveBets           :=  OnMoveBets           ;
  FCroupier.OnDealCards          :=  OnDealCards          ;
  FCroupier.OnChatMessage        :=  OnChatMessage        ;
  FCroupier.OnGamerSitOut        :=  OnGamerSitOut        ;
  FCroupier.OnGamerBack          :=  OnGamerBack          ;
  //
  FCroupier.OnShowCards          :=  OnShowCards          ;
  FCroupier.OnDontShowCards      :=  OnDontShowCards      ;
  FCroupier.OnMuck               :=  OnMuck               ;
  FCroupier.OnSitOut             :=  OnSitOut             ;
  FCroupier.OnLeaveTable         :=  OnLeaveTable         ;
  FCroupier.OnMoreChips          :=  OnMoreChips          ;
  FCroupier.OnProcCloseAction    :=  OnProcCloseAction    ;
  FCroupier.OnDumpCachedStateToFile := OnDumpCachedStateToFile;

  //
  FCroupier.OnUpdateGamerDetails :=  OnUpdateGamerDetails ;
  FCroupier.OnGamerAction        :=  OnGamerAction        ;
  FCroupier.OnOpenRoundGamer     :=  OnOpenRoundGamer     ;
  FCroupier.OnGamerKickOff       :=  OnGamerKickOff       ;
  FCroupier.OnGamerLeaveTable    :=  OnGamerLeaveTable    ;

  FCroupier.OnChangeGamersCount  :=  OnChangeGamersCount  ;
  FCroupier.OnPotReconcileFinish :=  OnPotReconcileFinish ;

  FCroupier.OnCheckGamerAllins   :=  OnCheckGamerAllins;
  FCroupier.OnPrepareReorderedPackets:= OnPrepareReorderedPackets;

  if FCroupier is TpoMultiTableTournamentCroupier then begin
    (FCroupier as TpoMultiTableTournamentCroupier).OnTournamentHandFinish:= OnTournamentHandFinish;
    (FCroupier as TpoMultiTableTournamentCroupier).OnMultyTournamentProcState:= OnMultyTournamentProcState;
  end;

  if (FCroupier is TpoSingleTableTournamentCroupier) then begin
    (FCroupier as TpoSingleTableTournamentCroupier).OnTournamentStart  := OnSingleTableTournamentStart;
    (FCroupier as TpoSingleTableTournamentCroupier).OnTournamentFinish := OnSingleTableTournamentFinish;
    (FCroupier as TpoSingleTableTournamentCroupier).OnTournamentFinishForBots := OnSingleTableTournamentFinishForBots;
  end;

  if TournamentType = TT_NOT_TOURNAMENT then begin
    FCroupier.OnHandReconcileOperation:= OnHandReconcileOperation;
  end;//

end;//TpoGenericPokerGameEngine.SetupCroupier

destructor TpoGenericPokerGameEngine.Destroy;
begin
  FTournayApiSuspendedOperations.Free;
  FMoreChipsSuspendedOperations.Free;

  inherited;
end;

function TpoGenericPokerGameEngine.DispatchGamerActionResponse(
  nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode; bValidateStepRight: Boolean; bAddPosition: Boolean; bAddStakesAndBalance: Boolean;
  nStakeAmount: Integer; bNotifyRequesterOnly: Boolean
  ): TpoGamer;
var
  rn, gan: IXMLNode;
  g: TpoGamer;
begin
  Result:= GetActionGamer(nSessionID, nUserIDAttr, bValidateStepRight, False);
  if NOT bNotifyRequesterOnly then begin
    rn:= PrepareOutputPacket(RB_ALL, True);
  end else begin
    rn:= PrepareOutputPacket(RB_REQUESTER, True);
  end;//if
  gan:= aActionInfo.CloneNode(True);
  if bAddPosition then begin
    gan.Attributes[PPTA_POSITION]:= Result.ChairID;
  end;//if
  if bAddStakesAndBalance then begin
    gan.Attributes[PPTA_STAKE]:= FormatFloat('0.##', FCroupier.NormalizeAmount(nStakeAmount));
    g:= GetActionGamer(nSessionID, nUserIDAttr, False, False);
    if g <> nil then begin
      gan.Attributes[PPTA_BET]:= FormatFloat('0.##', FCroupier.NormalizeAmount(Table.Hand.Pot.Bets.GetAccountByUserID(g.UserID).Balance));
      gan.Attributes[PPTA_BALANCE]:= FormatFloat('0.##', FCroupier.NormalizeAmount(g.Account.Balance));
      Result:= g;
    end;//if
  end;//if
  rn.ChildNodes.Add(gan);
  DispatchResponse(nSessionID, rn);
end;

function TpoGenericPokerGameEngine.HandleActionBack(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
begin
  Result:= nil;
  g:= GetActionGamer(nSessionID, nUserIDAttr, False, False);
  Croupier.HandleGamerBack(g);
end;

function TpoGenericPokerGameEngine.HandleActionBet(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
  nStake: Integer;
begin
//check inputs
  Result:= nil;
  g:= CheckActionAgainstHandContext(nSessionID, nUserIDAttr, aActionInfo, True, True);
  nStake:= RetrieveStake(aActionInfo, g, GA_BET);
  Croupier.HandleGamerBet(g, nStake);
  PrepareAndDispatchReorderedPackets(g);
end;

function TpoGenericPokerGameEngine.HandleActionCall(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
  nStake: Integer;
begin
//check inputs
  Result:= nil;
  g:= CheckActionAgainstHandContext(nSessionID, nUserIDAttr, aActionInfo, True, True);
  nStake:= RetrieveStake(aActionInfo, g, GA_CALL);
  Croupier.HandleGamerCall(g, nStake);
  PrepareAndDispatchReorderedPackets(g);
end;

function TpoGenericPokerGameEngine.HandleActionCheck(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
begin
  Result:= nil;
  g:= CheckActionAgainstHandContext(nSessionID, nUserIDAttr, aActionInfo, True, True);
  FCroupier.HandleGamerCheck(g);
  PrepareAndDispatchReorderedPackets(g);
end;

function TpoGenericPokerGameEngine.HandleActionFold(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
begin
//check inputs
  Result:= nil;
  g:= CheckActionAgainstHandContext(nSessionID, nUserIDAttr, aActionInfo, True, True);
  Croupier.HandleGamerFold(g);
  PrepareAndDispatchReorderedPackets(g);

//bot char on gamer folds
  PostRandomAnswerOnCategory(g, BCP_FOLDS);
end;


function TpoGenericPokerGameEngine.HandleActionLeaveTable(
  nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
begin
  Result:= nil;
  //detect gamer
  try
    g:= GetActionGamer(nSessionID, nUserIDAttr, False, False);
  except
    on e: EpoSessionException do begin
      Exit;
    end;//
    on e: Exception do begin
      raise;
    end;//
  end;//try
  if g = nil then Exit;
  if not g.IsBot then
    FApiSuspendedOperations.Add(SO_UnRegisterParticipant, nSessionID, g.UserID, g.ChairID);
  OnChangeGamersCount(nil);
  //handle post packets
  if g <> nil then Croupier.HandleGamerLeaveTable(g);
  PrepareAndDispatchReorderedPackets(nil);

//bot chat post on gamer table leave
//  PostRandomAnswerOnCategory(g, BCP_LEAVE_TABLE);

end; //TpoGenericPokerGameEngine.HandleActionLeaveTable


function TpoGenericPokerGameEngine.HandleActionPostBB(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
  nStake: Integer;
begin
//check inputs
  Result:= nil;
  g:= CheckActionAgainstHandContext(nSessionID, nUserIDAttr, aActionInfo, True, True);
  nStake:= RetrieveStake(aActionInfo, g, GA_POST_BB);
  Croupier.HandleGamerPostBB(g, nStake);
  PrepareAndDispatchReorderedPackets(g);
end;

function TpoGenericPokerGameEngine.HandleActionPostSB(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
  nStake: Integer;
begin
  Result:= nil;
  g:= CheckActionAgainstHandContext(nSessionID, nUserIDAttr, aActionInfo, True, True);
  nStake:= RetrieveStake(aActionInfo, g, GA_POST_SB);
  Croupier.HandleGamerPostSB(g, nStake);
  PrepareAndDispatchReorderedPackets(g);
end;

function TpoGenericPokerGameEngine.HandleActionRaise(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
  nStake: Integer;
begin
  Result:= nil;
  g:= CheckActionAgainstHandContext(nSessionID, nUserIDAttr, aActionInfo, True, True);
  nStake:= RetrieveStake(aActionInfo, g, GA_RAISE);
  Croupier.HandleGamerRaise(g, nStake);
  PrepareAndDispatchReorderedPackets(g);
end;

function TpoGenericPokerGameEngine.HandleActionSitDown(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
  nNewBalance, nActualBuyIn, nNewBuyIn: Currency;
  nBuyIn: Integer;
  nRes: Integer;
  sReason, sDataPacket: String;
  nParticipantCount: Integer;
  nPosition: Integer;
  n: IXMLNode;
  sDenyNonEmailValidated: string;

  function ValidatePositionForSeat(g: TpoGamer; var nPos: Integer): Boolean;
  begin
    Result := True;
    if (g.ChairID <> UNDEFINED_POSITION_ID) then begin
      nPos:= g.ChairID;
      Exit;
    end;//if
    if (FTable.Chairs[nPosition].State = CS_BUSY) OR
      ((FTable.Chairs[nPosition].State = CS_RESERVED) AND (FTable.Chairs[nPos].ReservationUserID <> g.UserID))
    then begin
      Result := False;
      (*
      EscalateFailure(
        EpoUnexpectedActionException, g.SessionID,
        'Chair with position #'+IntToStr(nPosition)+' already busy or reserved under another gamer.',
        '{891243C9-0787-4F0B-BB04-FBE8060930C6}'
      );
      *)
    end;//if
  end;//

begin
  Result:= nil;

  { get common System data }
  nRes := FApi.GetSystemOption(ID_EMAILVALIDATED_ON_SITDOWN, sDenyNonEmailValidated);
  if (nRes <> NO_ERROR) then begin
    CommonDataModule.Log(ClassName, 'HandleActionSitDown',
      '[ERROR] On execute FApi.GetSystemOption: Result=' + IntToStr(nRes) + '; Params: OptionID=' + IntToStr(ID_EMAILVALIDATED_ON_SITDOWN) + '.',
      ltError);
    sDenyNonEmailValidated := '0';
  end;

  { validate password on sitdown }
(*  sPassword := '';
  if aActionInfo.HasAttribute(PPTA_PASSWORD) then
    sPassword := aActionInfo.Attributes[PPTA_PASSWORD];

  if (FPassword <> '') and (FPassword <> sPassword) then begin
    n:= PrepareGamerPopUpPacket(
      PrepareOutputPacket(RB_REQUESTER, True),
      'Warning:', nil,
      'Access denied. Password is incorrect.',
      0
    );
    DispatchResponse(nSessionID, n, False, nUserIDAttr);

    Exit; //Password is incorrect
  end;
*)
  UpdateParticipantInfo(nSessionID, nUserIDAttr, True);

//check inputs
  if aActionInfo.Attributes[PPTA_AMOUNT] = '' then nBuyIn:= 0
  else nBuyIn:= Trunc(StrToFloat(aActionInfo.Attributes[PPTA_AMOUNT]) * 100);

  g:= GetActionGamer(nSessionID, nUserIDAttr, False, False);
  if (g.ChairID <> UNDEFINED_POSITION_ID) then begin
    OnGamerPopUp(g, 'Warning:', 'Gamer already has position ('+IntTostr(g.ChairID)+') at the table.');
    Exit; //gamer already has position
  end;//
  { validation of bot for any case }
  if g.IsBot then begin
    CommonDataModule.Log(ClassName, 'HandleActionSitDown',
      '[ERROR]: Action SitDown is blocked for bots.', ltError);
    Exit; //is bot
  end;

  if (sDenyNonEmailValidated <> '0') then begin // Need for check on email validation
  { User with not email validated can not entry to process }
    if not g.IsEmailValidated then begin
      OnGamerPopUp(g, 'Warning:', 'You can not enter the table while your email is not validated. Please validate your email and then re-open the table.');
      Exit;
    end;
  end;

  nPosition:= aActionInfo.Attributes[PPTA_POSITION];
  if not ValidatePositionForSeat(g, nPosition) then begin
    n:= PrepareBusyOnSitDownPacket(
      PrepareOutputPacket(RB_REQUESTER, True), nPosition, g.UserID
    );
    DispatchResponse(nSessionID, n);

    n:= PrepareGamerPopUpPacket(
      PrepareOutputPacket(RB_REQUESTER, True),
      'Warning:',
      nil,
      'Chair with position #'+IntToStr(nPosition)+' already busy or reserved under another gamer.',
      0
    );
    DispatchResponse(nSessionID, n);
    Exit;
  end;

//reserve money
  if TournamentType IN [TT_NOT_TOURNAMENT] then begin
    CommonDataModule.Log(ClassName, 'HandleActionSitDown',
      'Try to reserve money: UserID: '+IntToStr(g.UserID) +
      '; UserID: '+IntToStr(g.UserID)+' Amount: '+FloatToStr(nBuyIn),
      ltCall
    );
    sReason:= 'Error result on execute FApi.GetReservedAmount.';
    nRes:= FApi.GetReservedAmount(nSessionID, ProcessID, g.UserID, nActualBuyIn);
    if nRes = 0 then begin
      CommonDataModule.Log(ClassName, 'HandleActionSitDown',
        'Befor reservation: UserID: '+IntToStr(g.UserID), ltCall);
      CommonDataModule.Log(ClassName, 'HandleActionSitDown',
        'UserID: '+IntToStr(g.UserID)+
        ' Amount: '+FloatToStr(nBuyIn)+
        ' Old Reserve: '+FloatToStr(nActualBuyIn)+
        ' Old Amount: '+FloatToStr(nNewBalance)
        , ltCall);
    end else begin
      CommonDataModule.Log(ClassName, 'HandleActionSitDown',
        'FApi.GetReservedAmount Failed; Reason: '+sReason, ltError);
    end;//if
    EscalateFailure(nRes, EpoSessionException, sReason, '{83C10BA6-AE25-4F8F-90E3-9BC1AA79ABC0}');
    if nActualBuyIn > 0 then begin
      nRes:= FApi.UnreserveMoney(nSessionID, ProcessID, g.UserID, CurrencyID, nActualBuyIn, nNewBuyIn, nNewBalance);
      EscalateFailure(nRes, EpoSessionException, 'Error on execute FApi.UnreserveMoney.', '{08F660EB-9646-45FD-9048-E42EA505287C}');
    end;

    sReason:= 'Error result on execute FApi.ReserveMoney.';
    nRes:= FApi.ReserveMoney(
      nSessionID, ProcessID, g.UserID,
      FCroupier.NormalizeAmount(nBuyIn),
      nActualBuyIn, nNewBalance
    );
    if nRes = 0 then begin
      CommonDataModule.Log(ClassName, 'HandleActionSitDown',
        'After reservation: UserID: '+IntToStr(g.UserID), ltCall);
      CommonDataModule.Log(ClassName, 'HandleActionSitDown',
        'UserID: '+IntToStr(g.UserID)+
        ' Amount: '+FloatToStr(nBuyIn)+
        ' New Reserve: '+FloatToStr(nActualBuyIn)+
        ' New Amount: '+FloatToStr(nNewBalance)
        , ltCall);
    end else begin
      CommonDataModule.Log(ClassName, 'HandleActionSitDown',
        'Reservation Failed; Reason: '+sReason, ltError);
    end;//if
    EscalateFailure(nRes, EpoSessionException, sReason, '{F9DC709B-8BBD-4491-83CA-19CA31277CD5}');

    if (nActualBuyIn < (FTable.MinBuyIn / 100)) OR (nActualBuyIn > (FTable.MaxBuyIn / 100)) then begin
      CommonDataModule.Log(ClassName, 'HandleActionSitDown',
        'Gamer buy in must be between min and max values for the particular table; SessionID=' + IntToStr(g.SessionID),
        ltError
      );
      EscalateFailure(
        EpoSessionException,
        g.SessionID,
        'Gamer buy in must be between min and max values for the particular table',
        '{4AFF1936-1E87-4E20-9D0A-F3D70E7D81F2}'
      );
    end;//if
  end else
  if TournamentType = TT_SINGLE_TABLE then begin
    if g = nil then Exit;
    if not g.IsBot then begin
      sDataPacket := PrepareSTTournamentReservationPacket(nil, g).XML;
      FTournayApiSuspendedOperations.Add(TSO_Reservation, FTable.Hand.HandID, sDataPacket);
    end;
  end;//if reservation is performed by game engine

//correct gamer attrs
  nActualBuyIn := Trunc(nActualBuyIn*100) / 100;
  nNewBalance  := Trunc(nNewBalance *100) / 100;
  aActionInfo.Attributes[PPTA_AMOUNT]  := FloatToStr(nActualBuyIn);
  aActionInfo.Attributes[PPTA_BALANCE] := FloatToStr(nNewBalance);

//handle waiting list
  DeleteGamerReservationTimeout(g);
  FTable.Chairs.ClearGamerReservations(g.UserID);
  nRes:= FApi.UnregisterFromWaitingList(g.UserID, ProcessID, GroupID, nParticipantCount);
  if nRes <> NO_ERROR then begin
    DumpCachedStateToFile(FStateManager.CachedState);
    CommonDataModule.Log(ClassName, 'HandleActionSitDown',
      '[ERROR] On execute FApi.UnregisterFromWaitingList: Result=' + IntToStr(nRes) +
      ', UserID=' + IntToStr(g.UserID) + ', processID=' + IntToStr(ProcessID) +
      ', GroupID=' + IntToStr(GroupID) + ', ParticipaintCount=' + IntToStr(nParticipantCount),
      ltError);
  end;

(*  EscalateFailure(
    nRes,
    EpoException,
    sReason,
    '{5117A8B3-B173-4EA9-B1DF-FBADB44F5D85}'
  );//EscalateFailure
*)
//assign values
  if TournamentType = TT_SINGLE_TABLE then begin
    FCroupier.HandleGamerSitDown(g, nPosition, TournamentChips)
  end else begin
    FCroupier.HandleGamerSitDown(g, nPosition, Trunc(nActualBuyIn*100));
  end;//

  if g <> nil then begin
    { Check Table last activity timeout}
    g.LastTimeActivity := IncSecond(Now, -1);
    FLastTimeActivity := IncSecond(Now, -1);
    if not g.IsBot then
      FApiSuspendedOperations.Add(SO_RegisterParticipant, g.SessionID, g.UserID, g.ChairID);
  end;//if

//update gamer stats
  FApiSuspendedOperations.Add(SO_UpdateParticipantCount);

//response
  DispatchGamerActionResponse(nSessionID, nUserIDAttr, aActionInfo, False, False);

//bot chat post for gamer sit down
  PostRandomAnswerOnCategory(g, BCP_SIT_DOWN);

end;//TpoGenericPokerGameEngine.HandleActionSitOut


function TpoGenericPokerGameEngine.HandleActionSitOut(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
begin
  Result:= nil;
  g:= GetActionGamer(nSessionID, nUserIDAttr, False, False);
  Croupier.HandleGamerSitOut(g);
  PrepareAndDispatchReorderedPackets(g);

//bot chat post for gamer sit out
  PostRandomAnswerOnCategory(g, BCP_SIT_OUT);
end;

function TpoGenericPokerGameEngine.HandleActionSitOutNextHand(
  nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
  bStatus: Boolean;
begin
  Result:= nil;
  g:= GetActionGamer(nSessionID, nUserIDAttr, False, False);
  bStatus:= Boolean(StrToInt(aActionInfo.Attributes[PPTA_VALUE]));
  FCroupier.HandleGamerSitOutNextHand(g, bstatus);
end;

function TpoGenericPokerGameEngine.HandleEventStartHand(
  nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  nHandID: Integer;
  sReason: WideString;
  nRes: Integer;

begin
  Result:= nil;
  sReason:= '';
  if Table.Hand.State <> HST_STARTING then Exit;

  FLastTimeActivity := IncSecond(Now, -1);

  nRes:= FAPi.StartHand(ProcessID, IntToStr(System.RandSeed), nHandID);
  EscalateFailure(
    nRes,
    EpoException, sReason, '{13A404BE-7851-45C4-838B-CAFBB1ED85C8}'
  );

  DeleteInterval(FStartHandReminderID);

  CommonDataModule.Log(ClassName, 'HandleEventStartHand',
    'Shuffle seed: '+IntToStr(System.RandSeed), ltCall);

  FCroupier.StartHand(nHandID);

  PrepareAndDispatchReorderedPackets(nil);
end;

procedure TpoGenericPokerGameEngine.CheckTimeOutActivityForNotTournay(
  nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode);
var
  I: Integer;
  aGamer: TpoGamer;
  sMsg: String;
  nTimeOutValue, nHandID, nRound: Integer;
  bNeedReinitTable: Boolean;
  nRes: Integer;
  TimeOutGamersActivity: Integer;
  sConfigData: string;
begin
  if (FCroupier.TournamentType <> TT_NOT_TOURNAMENT) then Exit;

  nHandID := UNDEFINED_HAND_ID;
  if aActionInfo.HasAttribute(PPTA_HAND_ID) then begin
    nHandID := StrToIntDef(aActionInfo.Attributes[PPTA_HAND_ID], UNDEFINED_HAND_ID);
  end;
  nRound := UNDEFINED_ROUND_ID;
  if aActionInfo.HasAttribute(PPTA_ROUND) then begin
    nRound := StrToIntDef(aActionInfo.Attributes[PPTA_ROUND], UNDEFINED_ROUND_ID);
  end;

  sConfigData := '10';
  nRes := FApi.GetSystemOption(ID_TIME_OUT_GAMERS_ACTIVITY, sConfigData);
  if (nRes <> NO_ERROR) then begin
    CommonDataModule.Log(ClassName, 'CheckTimeOutActivityForNotTournay',
      '[ERROR] On execute FApi.GetSystemOption: Result=' + IntToStr(nRes) +
      '; Params: OptionID=' + IntToStr(ID_TIME_OUT_GAMERS_ACTIVITY) + '.',
      ltError);
    sConfigData := '10';
  end;
  TimeOutGamersActivity := StrToIntDef(sConfigData, 10) * 60;

  { Check Table last activity timeout}
  nTimeOutValue := SecondsBetween(FLastTimeActivity, Now) + 1;
  bNeedReinitTable :=
    (FTable.Hand.State <> HST_RUNNING) or
    ((nHandID = FTable.Hand.HandID) and (nRound = FTable.Hand.RoundID));
  if (nTimeOutValue >= TimeOutGamersActivity) and bNeedReinitTable then begin
    // Kick Off all users
    sMsg := 'This table is closing due to no activity in the last ' +
      IntToStr(TimeOutGamersActivity div 60) + ' minutes. Return to ' +
      'the lobby to join an active table.';
    if FTable.Hand.State <> HST_IDLE then begin
      CommonDataModule.Log(ClassName, 'CheckTimeOutActivityForNotTournay',
        '[ERROR]: ' + sMsg + ' But hand state is not idle; State=' + FTable.Hand.StateAsString, ltError
      );
      EscalateFailure(GE_TIMEOUT_ON_NOTFINISHEDHAND, EpoException, sMsg, '{E4797480-06B0-48F2-A646-9BDF54D818B0}');
      Exit;
    end;
    for I:=FTable.Gamers.Count - 1 downto 0 do begin
      aGamer := FTable.Gamers[I];
      if not aGamer.IsBot then begin
        DispatchResponse(
          aGamer.SessionID,
          PrepareProcClosePacket(PrepareOutputPacket(RB_REQUESTER, True), sMsg),
          True, aGamer.UserID
        );
      end;
      HandleActionLeaveTable(aGamer.SessionID, aGamer.UserID, nil);
    end;//for

    Exit;
  end;//if

  { Check individual gamers activity timeout }
  sMsg := 'Your player has been inactive for more than ' + IntToStr(TimeOutGamersActivity div 60) + ' minutes and has been returned to the lobby.';
  for I:=FTable.Gamers.Count - 1 downto 0 do begin
    aGamer := FTable.Gamers[I];
    nTimeOutValue := SecondsBetween(aGamer.LastTimeActivity, Now) + 1;
    if (nTimeOutValue >= TimeOutGamersActivity) then begin
      if Croupier.ChairIsWinnerCandidate(aGamer.Chair) then Continue;

      if not aGamer.IsBot then begin
        DispatchResponse(
          aGamer.SessionID,
          PrepareProcClosePacket(PrepareOutputPacket(RB_REQUESTER, True), sMsg),
          True, aGamer.UserID
        );
      end;

      HandleActionLeaveTable(aGamer.SessionID, aGamer.UserID, nil);
    end;//if
  end;//for

  { next scheduler on check of timeout }
  FLastTimeActivity := IncSecond(Now, -1);
  FCheckTimeOutActivity := ScheduleSecInterval(0, TimeOutGamersActivity, PPTV_CHECK_TIMEOUT_ACTIVITY).ReminderID;
end;

procedure TpoGenericPokerGameEngine.CheckTimeOutActivityForSingleTournay(
  nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode);
var
  I: Integer;
  aGamer: TpoGamer;
  sMsg: String;
  nTimeOutValue, nHandID: Integer;
  aTouStatus: TpoTournamentStatus;
  sConfigData: string;
  TimeOutGamersActivity: Integer;
  nRes: Integer;
begin
  if (FCroupier.TournamentType <> TT_SINGLE_TABLE) then Exit;

  nHandID := 0;
  if aActionInfo.HasAttribute(PPTA_HAND_ID) then begin
    nHandID := StrToIntDef(aActionInfo.Attributes[PPTA_HAND_ID], 0);
  end;
  aTouStatus := (FCroupier as TpoSingleTableTournamentCroupier).TournamentStatus;
  if (aTouStatus <> TST_IDLE) then Exit;
  if (FTable.Hand.HandID <> nHandID) then Exit;

  { Get System options }
  sConfigData := '10';
  nRes := FApi.GetSystemOption(ID_TIME_OUT_GAMERS_ACTIVITY, sConfigData);
  if (nRes <> NO_ERROR) then begin
    CommonDataModule.Log(ClassName, 'CheckTimeOutActivityForNotTournay',
      '[ERROR] On execute FApi.GetSystemOption: Result=' + IntToStr(nRes) +
      '; Params: OptionID=' + IntToStr(ID_TIME_OUT_GAMERS_ACTIVITY) + '.',
      ltError);
    sConfigData := '10';
  end;
  TimeOutGamersActivity := StrToIntDef(sConfigData, 10) * 60;

  { Check Table last activity timeout}
  nTimeOutValue := SecondsBetween(FLastTimeActivity, Now) + 1;
  if (nTimeOutValue >= (10 * TimeOutGamersActivity)) and (FTable.Hand.State <> HST_RUNNING) then begin
    // Kick Off all users
    sMsg := 'This table is closing due to no activity in the last ' +
      IntToStr((10*TimeOutGamersActivity) div 60) + ' minutes. Return to ' +
      'the lobby to join an active table.';
    for I:=FTable.Gamers.Count - 1 downto 0 do begin
      aGamer := FTable.Gamers[I];
      if not aGamer.IsBot then begin
        DispatchResponse(
          aGamer.SessionID,
          PrepareProcClosePacket(PrepareOutputPacket(RB_REQUESTER, True), sMsg),
          True, aGamer.UserID
        );
      end;
      HandleActionLeaveTable(aGamer.SessionID, aGamer.UserID, nil);
    end;//for

    Exit;
  end;//if

  { Check individual watchers activity timeout }
  for I:=FTable.Gamers.Count - 1 downto 0 do begin
    aGamer := FTable.Gamers[I];
    if not aGamer.IsWatcher then Continue;

    nTimeOutValue := SecondsBetween(aGamer.LastTimeActivity, Now) + 1;
    sMsg := 'Your player has been inactive for more than ' + IntToStr(nTimeOutValue div 60) + ' minutes and has been returned to the lobby.';
    if (nTimeOutValue >= TimeOutGamersActivity) then begin
      if not aGamer.IsBot then begin
        DispatchResponse(
          aGamer.SessionID,
          PrepareProcClosePacket(PrepareOutputPacket(RB_REQUESTER, True), sMsg),
          True, aGamer.UserID
        );
      end;

      HandleActionLeaveTable(aGamer.SessionID, aGamer.UserID, nil);
    end;//if
  end;//for

  { next scheduler on check of timeout }
  FCheckTimeOutActivity := ScheduleSecInterval(0, TimeOutGamersActivity, PPTV_CHECK_TIMEOUT_ACTIVITY).ReminderID;
end;

function TpoGenericPokerGameEngine.HandleCheckTimeOutActivity(
  nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
begin
  CommonDataModule.Log(ClassName, 'HandleCheckTimeOutActivity',
    'Check On Timeout gamers activity sheduler expiared: '+#13#10+aActionInfo.XML, ltCall);

  Result:= nil;

  if (FLastTimeActivity = 0) then FLastTimeActivity := IncSecond(Now, -1);

  DeleteAllCheckOnTimeOutReminders;

  if (Table.Gamers.Count <= 0) then Exit;

  case FCroupier.TournamentType of
    TT_NOT_TOURNAMENT: CheckTimeOutActivityForNotTournay(nSessionID, nUserIDAttr, aActionInfo);
    TT_SINGLE_TABLE  : CheckTimeOutActivityForSingleTournay(nSessionID, nUserIDAttr, aActionInfo);
  else
    Exit;
  end;

  CommonDataModule.Log(ClassName, 'HandleCheckTimeOutActivity',
    'New Timeout gamers activity sheduler created: ReminderID='+FCheckTimeOutActivity, ltCall);
end;

procedure TpoGenericPokerGameEngine.InitGameActions();
begin
  inherited;
  FActions.AddAction(PPTN_SET_PARTICIPANT_AS_LOGGED, HandleSetParticipantAsLoggedIn);
  FActions.AddAction(PPTN_GAMER_DISCONNECT, HandleGamerDisconnect);
  FActions.AddAction(PPTN_GAMER_RECONNECT, HandleGamerReconnect);
  FActions.AddAction(PPTN_FINISH_TABLE, HandleFinishTable);
  FActions.AddAction(PPTN_KICKOFUSER, HandleKickOffUser);
  FActions.AddAction(PPTN_GALEAVETABLE, HandleGALeaveTable);

  FActions.AddAction(PPTN_WL_DECLINE, HandleWLDecline);

//gamer status
  FActions.AddSubAction(PPTN_GAMER_ACTION, PPTV_SIT_DOWN, HandleActionSitDown);
  FActions.AddSubAction(PPTN_GAMER_ACTION, PPTV_LEAVE_TABLE, HandleActionLeaveTable);
  FActions.AddSubAction(PPTN_GAMER_ACTION, PPTV_SIT_OUT_NEXT_HAND, HandleActionSitOutNextHand);
  FActions.AddSubAction(PPTN_GAMER_ACTION, PPTV_SIT_OUT, HandleActionSitOut);
  FActions.AddSubAction(PPTN_GAMER_ACTION, PPTV_BACK, HandleActionBack);
  FActions.AddSubAction(PPTN_GAMER_ACTION, PPTV_WAIT_BB, HandleActionWaitBB);

//money related actions
  FActions.AddSubAction(PPTN_GAMER_ACTION, PPTV_CHECK, HandleActionCheck);
  FActions.AddSubAction(PPTN_GAMER_ACTION, PPTV_POST_SB, HandleActionPostSB);
  FActions.AddSubAction(PPTN_GAMER_ACTION, PPTV_POST_BB, HandleActionPostBB);
  FActions.AddSubAction(PPTN_GAMER_ACTION, PPTV_CALL, HandleActionCall);
  FActions.AddSubAction(PPTN_GAMER_ACTION, PPTV_RAISE, HandleActionRaise);
  FActions.AddSubAction(PPTN_GAMER_ACTION, PPTV_BET, HandleActionBet);
  FActions.AddSubAction(PPTN_GAMER_ACTION, PPTV_POST, HandleActionPost);
  FActions.AddSubAction(PPTN_GAMER_ACTION, PPTV_FOLD, HandleActionFold);
  FActions.AddSubAction(PPTN_GAMER_ACTION, PPTV_POST_DEAD, HandleActionPostDead);
  FActions.AddSubAction(PPTN_GAMER_ACTION, PPTV_ANTE, HandleActionAnte);
  FActions.AddSubAction(PPTN_GAMER_ACTION, PPTV_BRING_IN, HandleActionBringIn);

//Showdown actions
  FActions.AddSubAction(PPTN_GAMER_ACTION, PPTV_SHOW_CARDS, HandleActionShowCards);
  FActions.AddSubAction(PPTN_GAMER_ACTION, PPTV_SHOW_CARDS_SHUFFLED, HandleActionShowCardsShuffled);
  FActions.AddSubAction(PPTN_GAMER_ACTION, PPTV_DONT_SHOW, HandleActionDontShowCards);
  FActions.AddSubAction(PPTN_GAMER_ACTION, PPTV_MUCK, HandleActionMuck);

//
  FActions.AddSubAction(PPTN_GAMER_ACTION, PPTV_MORE_CHIPS, HandleMoreChips);

  FActions.AddSubAction(PPTN_GAMER_ACTION, PPTV_USE_TIMEBANK, HandleUseTimeBank);

//autoactions
  FActions.AddAction(PPTN_AUTO_ACTION, HandleGamerAutoAction);

//timer handling
  FActions.AddSubAction(PPTN_TIMER_EVENT, PPTV_START_HAND, HandleEventStartHand);
  FActions.AddSubAction(PPTN_TIMER_EVENT, PPTV_CHECK_TIMEOUT_ACTIVITY, HandleCheckTimeOutActivity);
  FActions.AddSubAction(PPTN_TIMER_EVENT, PPTV_GAMER_RESERVATION, HandleEventGamerReservationExpired);

//tournaments
  FActions.AddSubAction(PPTN_TOURNAMENT_ACTION, PPTV_INIT,   HandleTournamentActionInit,   AA_COMMAND);
  FActions.AddSubAction(PPTN_TOURNAMENT_ACTION, PPTV_PLAY,   HandleTournamentActionPlay,   AA_COMMAND);
  FActions.AddSubAction(PPTN_TOURNAMENT_ACTION, PPTV_BREAK,  HandleTournamentActionBreak,  AA_COMMAND);
  FActions.AddSubAction(PPTN_TOURNAMENT_ACTION, PPTV_RESUME, HandleTournamentActionResume, AA_COMMAND);
  FActions.AddSubAction(PPTN_TOURNAMENT_ACTION, PPTV_EVENT,  HandleTournamentActionEvent,  AA_COMMAND);
  FActions.AddSubAction(PPTN_TOURNAMENT_ACTION, PPTV_END,    HandleTournamentActionEnd,    AA_COMMAND);
  FActions.AddSubAction(PPTN_TOURNAMENT_ACTION, PPTV_FREE,   HandleTournamentActionFree,   AA_COMMAND);
  FActions.AddSubAction(PPTN_TOURNAMENT_ACTION, PPTV_CLOSE_TABLE,   HandleTournamentCloseTable,   AA_COMMAND);
  FActions.AddSubAction(PPTN_TOURNAMENT_ACTION, PPTV_CHANGE_PLACE,  HandleTournamentChangePlace,  AA_COMMAND);
  FActions.AddSubAction(PPTN_TOURNAMENT_ACTION, PPTV_STANDUP,  HandleTournamentStandUpToWatcher,  AA_COMMAND);
  FActions.AddSubAction(PPTN_TOURNAMENT_ACTION, PPTV_REBUY,  HandleTournamentRebuy,  AA_COMMAND);
  FActions.AddSubAction(PPTN_TOURNAMENT_ACTION, PPTV_KICK_OFF_USERS, HandleTournamentKickOffUsers, AA_COMMAND);

//Bots
  FActions.AddAction(PPTN_BOT_SITDOWN, HandleActionBotsSitDown);
  FActions.AddAction(PPTN_BOT_STANDUP_ALL, HandleActionBotsStandupAll);
  FActions.AddAction(PPTN_BOT_STANDUP, HandleActionBotStandup);
  FActions.AddAction(PPTN_BOT_POLICY, HandleActionBotPolicy);
  FActions.AddAction(PPTN_BOT_GET_TABLE_INFO, HandleActionBotGetTableInfo);

end;

procedure TpoGenericPokerGameEngine.InitGameProperties();
begin
  inherited InitGameProperties();
end;//

procedure TpoGenericPokerGameEngine.InitGameStats;
begin
  inherited;
  FStats.AddStatItem(PSID_WAIT);
  FStats.AddStatItem(PSID_STAKES);
  FStats.AddStatItem(PSID_AVG_POT);
  FStats.AddStatItem(PSID_H_HR);
  FStats.AddStatItem(PSID_LIMIT);

  case TpoPokerType(FProperties.PropertyByName(PP_POKER_TYPE).AsInteger) of
    PT_UNDEFINED      :    //0 - undefined
      begin
      end;

    PT_TEXAS_HOLDEM   ,    //1 - Texas Hold'em
    PT_OMAHA          ,    //2 – Omaha
    PT_OMAHA_HILO     :    //3 - Omaha Hi Lo
      begin
        FStats.AddStatItem(PSID_PIRS_FLOP);
      end;//

    PT_SEVEN_STUD     ,    //4 - Seven Stud
    PT_SEVEN_STUD_HILO:    //5 - Seven Stud Hi Lo
      begin
      //Table, Stakes, Gamers, Avg Pot, Plrs/Flop, Wait, H/hr
        FStats.AddStatItem(PSID_PIRS_4TH);
        FStats.AddStatItem(PSID_PIRS_FLOP);
      end;


    PT_FIVE_CARD_DRAW :    //6 - Five Card Draw
      begin
      //TBD:
      end;

    PT_FIVE_CARD_STUD :    //7 - Five Card Stud
      begin
      //TBD:
      end;

    PT_CRAZY_PINEAPPLE:    //8 - Crazy Pineapple
      begin
      //TBD:
      end;
  end;//case

  if TournamentType = TT_SINGLE_TABLE then begin
    FStats.AddStatItem(PSID_GAME);
    FStats.AddStatItem(PSID_BUY_IN);
    FStats.AddStatItem(PSID_STATE);
    FStats.AddStatItem(PSID_ENROLLED);
  end;//if
end;

function TpoGenericPokerGameEngine.Load(aReader: TReader): Boolean;
begin
  Result:= inherited Load(aReader);
  FStartHandReminderID  := aReader.ReadString;
  FGamerActionReminderID:= aReader.ReadString;
end;//TpoGenericPokerGameEngine.Load


procedure TpoGenericPokerGameEngine.OnAbandonHandStarting(
  aSender: TObject);
begin
  if aSender <> nil then DeleteInterval(FStartHandReminderID);
  DispatchResponse(0, PrepareChatPacket(PrepareOutputPacket(RB_ALL, True), 'Game is cancelled -- not enough players.'));//if
  DispatchResponse(0, PrepareChatPacket(PrepareOutputPacket(RB_ALL, True), 'Waiting for more players before starting the next game.'));
end;

procedure TpoGenericPokerGameEngine.OnChairStateChange(aSender: TObject; vInfo: Variant);
var
  g: TpoGamer;
  n, np: IXMLNode;
  nSessionID, nChairID: Integer;
  sUserName: string;
  GamerLeftTable: Boolean;
begin
  n:= PrepareOutputPacket(RB_ALL, False);
  GamerLeftTable := False;
  if aSender <> nil then begin
    g:= aSender as TpoGamer;
    GamerLeftTable := (g.State = GS_LEFT_TABLE);
    if GamerLeftTable then nChairID:= g.PrevChairID
    else nChairID:= g.ChairID;
    nSessionID:= g.SessionID;
    sUserName:= g.UserName;
  end else begin //reservation
    nSessionID:= UNDEFINED_SESSION_ID;
    sUserName:= '';
    nChairID:= vInfo;
  end;//if

  PrepareChairStatusPacket(n, nChairID, sUserName);
  DispatchResponse(nSessionID, n);

//update history
  PushHistoryEntry(0, n);
// personification packet about chair state
  if not GamerLeftTable then begin
    np := PrepareOutputPacket(RB_REQUESTER, True);
    PrepareChairStatusPacket(np, nChairID, sUserName, True, nSessionID);
    DispatchResponse(nSessionID, np);
  end;
end;

procedure TpoGenericPokerGameEngine.OnDealCards(aSender: TObject; vInfo: Variant);
var
  I: Integer;
  n: IXMLNode;
  bOnStartRound: Boolean;
  aGamer: TpoGamer;
begin
  FExposedCardRoundID:= vInfo[0]; //fixup round
  bOnStartRound:= vInfo[1]; //fixup round
  if FExposedCardRoundID = -1 then begin//preliminary
    for I:= 0 to Table.Gamers.Count-1 do begin
      aGamer := Table.Gamers[I];
      if aGamer.IsBot then Continue;
      n:= PrepareDealCardsPacket(PrepareOutputPacket(RB_REQUESTER, True), aGamer.SessionID, FExposedCardRoundID, bOnStartRound);
      DispatchResponse(aGamer.SessionID, n, False, aGamer.UserID);
    end;//for

    //update history
    n:= PrepareDealCardsPacket(nil, SHARED_HISTORY_SESSION_ID, FExposedCardRoundID, bOnStartRound);
    PushHistoryEntry(0, n);
    FCroupier.ClearCardsModifiedState;
  end else begin
    FExposeCardDeals:= True;
    FExposedCardsOnRoundStart:= bOnStartRound;
    OnRanking(aSender);
  end;//if
end;

procedure TpoGenericPokerGameEngine.OnHandFinish(sContext: String);
var
  sReason: WideString;
  nRes: Integer;
  n: IXMLNode;
begin
  n:= PrepareFinishHandPacket(PrepareOutputPacket(RB_ALL, False), sContext);
  DispatchResponse(0, n);
  nRes:= FApi.FinishHand(FTable.Hand.HandID);
  EscalateFailure(
    nRes, EpoException, sReason, '{1E2A6185-AB3B-4982-8518-01D1B73C002C}'
  );

//update history
  PushHistoryEntry(0, n);
  FlushHistoryQueue();
end;

procedure TpoGenericPokerGameEngine.OnHandStart(aSender: TObject);
var
  I: Integer;
  n: IXMLNode;
  aGamer: TpoGamer;
begin
//notify gamers about hand
  for I:= 0 to FTable.Gamers.Count-1 do begin
    aGamer := FTable.Gamers[I];
    if aGamer.IsBot then Continue;
    n:= PrepareOutputPacket(RB_REQUESTER, True);
    PrepareProcStatePacket(n, FTable.Gamers[I].SessionID);
    DispatchResponse(aGamer.SessionID, n);
  end;//for

//update history
  PushHistoryEntry(0, PrepareProcInitPacket(nil));
  PushHistoryEntry(0, PrepareProcStatePacket(nil, SHARED_HISTORY_SESSION_ID));
  PushHistoryEntry(0, PreparePushingContentPacket(nil));
end;

procedure TpoGenericPokerGameEngine.OnHandStarting(aSender: TObject; vTimeoutInfo: Variant);
begin
  CommonDataModule.Log(ClassName, 'OnHandStarting',
    'Setting start hand interval (timeout - '+IntToStr(vTimeoutInfo)+') s', ltCall);
  FStartHandReminderID:= ScheduleSecInterval(0, vTimeoutInfo, PPTV_START_HAND).ReminderID;
end;

procedure TpoGenericPokerGameEngine.OnHandStarted(aSender: TObject; vInfo: variant);
var
  n: IXMLNOde;
begin
  n:= PrepareChatPacket(
    PrepareOutputPacket(RB_ALL, True), 'Starting a new hand #'+IntToStr(vInfo)
  );
  DispatchResponse(0, n);//if
end;//

procedure TpoGenericPokerGameEngine.OnMoveBets(sContext: String);
begin
  FExposeMoveBets:= True;
  FMOveBetsContext:= sContext;
end;

procedure TpoGenericPokerGameEngine.OnRoundFinish(aSender: TObject);
begin
  FOnFinishRoundPacket:= True;
  OnRanking(aSender);
  PrepareAndDispatchReorderedPackets(nil); //12.03.2003
end;

function TpoGenericPokerGameEngine.Store(aWriter: TWriter): Boolean;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteString(FStartHandReminderID  );
  aWriter.WriteString(FGamerActionReminderID);
end;//TpoGenericPokerGameEngine.Store


procedure TpoGenericPokerGameEngine.OnShowCards(aGamer: TpoGamer);
var
  n: IXMLNode;
begin
  n:= PrepareShowCardsPacket(PrepareOutputPacket(RB_ALL, True), aGamer);
  DispatchResponse(aGamer.SessionID, n);
  PrepareAndDispatchReorderedPackets(aGamer);
  PushHistoryEntry(0, n);
end;

function TpoGenericPokerGameEngine.HandleActionShowCards(
  nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
begin
//check inputs
  Result:= nil;
  g:= CheckActionAgainstHandContext(nSessionID, nUserIDAttr, aActionInfo, True, True);

  if (g = nil) then Exit;
  if g.ShowDownPassed or not FCroupier.IsShowdownRound then Exit;

  Croupier.HandleGamerShowCards(g);
  PrepareAndDispatchReorderedPackets(g);
end;

function TpoGenericPokerGameEngine.HandleActionDontShowCards(
  nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
begin
//check inputs
  Result:= nil;
  g:= CheckActionAgainstHandContext(nSessionID, nUserIDAttr, aActionInfo, True, True);

  if (g = nil) then Exit;
  if g.ShowDownPassed or not FCroupier.IsShowdownRound then Exit;

  Croupier.HandleGamerDontShowCards(g);
  PrepareAndDispatchReorderedPackets(g);
end;

function TpoGenericPokerGameEngine.HandleActionMuck(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
begin
//check inputs
  Result:= nil;
  g:= CheckActionAgainstHandContext(nSessionID, nUserIDAttr, aActionInfo, True, True);

  if (g = nil) then Exit;
  if g.ShowDownPassed or not FCroupier.IsShowdownRound then Exit;

  Croupier.HandleGamerMuck(g);
  PrepareAndDispatchReorderedPackets(g);
end;

procedure TpoGenericPokerGameEngine.OnMuck(aGamer: TpoGamer);
var
  n: IXMLNode;
begin
  n:= PrepareMuckPacket(PrepareOutputPacket(RB_ALL, True), aGamer);
  DispatchResponse(aGamer.SessionID, n);
  PrepareAndDispatchReorderedPackets(aGamer);
  PushHistoryEntry(0, n);
end;

procedure TpoGenericPokerGameEngine.OnDontShowCards(aGamer: TpoGamer);
var
  n: IXMLNOde;
begin
  n:= PrepareDontShowCardsPacket(PrepareOutputPacket(RB_ALL, True), aGamer);
  DispatchResponse(aGamer.SessionID, n);
  PrepareAndDispatchReorderedPackets(aGamer);
  PushHistoryEntry(0, n);
end;

procedure TpoGenericPokerGameEngine.OnSitOut(aGamer: TpoGamer);
var
  n: IXMLNode;
begin
  n:= PrepareSitOutPacket(PrepareOutputPacket(RB_ALL, True), aGamer);
  DispatchResponse(aGamer.SessionID, n);
  PushHistoryEntry(0, n);
end;

procedure TpoGenericPokerGameEngine.OnLeaveTable(aGamer: TpoGamer);
var
  n: IXMLNode;
begin
  n:= PrepareLeaveTablePacket(PrepareOutputPacket(RB_ALL, True), aGamer);
  DispatchResponse(aGamer.SessionID, n);
  PrepareAndDispatchReorderedPackets(aGamer);
  PushHistoryEntry(0, n);
end;

procedure TpoGenericPokerGameEngine.DealMoreChips(nUserID: Integer);
var
  nRes: Integer;
  nCurrentReservation, nNewAmount, nNewReserv, AmountToAdding: Currency;
  MaxAmountIngame: Currency;
  aGamer: TpoGamer;

  procedure NotificationAboutCanNotMoreChips(aGamer: TpoGamer);
  var
    sMsg: string;
    n: IXMLNode;
  begin
    sMsg := 'You can not get more chips.';
    n:= PrepareChatPacket(
      PrepareOutputPacket(RB_REQUESTER, True),
      sMsg,
      MO_DEALER,
      0,
      aGamer.UserID
    );
    DispatchResponse(aGamer.SessionID, n);
  end;
begin
  aGamer := FTable.Gamers.GamerByUserID(nUserID);
  if (aGamer = nil) then Exit;

  if Self.UseAmountConstraint then begin
    MaxAmountIngame := Self.MaxAmountConstraint;
    if not aGamer.IsBot then begin
      nRes:= FApi.GetReservedAmount(
        aGamer.SessionID, ProcessID, aGamer.UserID, nCurrentReservation
      );
    end else begin
      nRes := NO_ERROR;
      nCurrentReservation := 0;
    end;
    if (nRes <> NO_ERROR) then begin
      CommonDataModule.Log(ClassName, 'DealMoreChips',
        '[ERROR] On exec FApi.GetReservedAmount: Result=' + IntToStr(nRes) +
        ', SessionID=' + IntToStr(aGamer.SessionID) + ', UserID=' + IntToStr(aGamer.UserID) +
        ', ProcessID=' + IntToStr(ProcessID),
        ltError
      );
      NotificationAboutCanNotMoreChips(aGamer);
      aGamer.DuringGameAddedMoney:= 0;
      Exit;
    end;

    if nCurrentReservation < MaxAmountIngame then begin
      AmountToAdding :=
        Min(
          MaxAmountIngame - nCurrentReservation,
          FCroupier.NormalizeAmount(aGamer.DuringGameAddedMoney)
        );
    end else begin
      NotificationAboutCanNotMoreChips(aGamer);
      aGamer.DuringGameAddedMoney:= 0;
      Exit;
    end;
  end else begin
    AmountToAdding := FCroupier.NormalizeAmount(aGamer.DuringGameAddedMoney);
  end;

  if not aGamer.IsBot then begin
    nRes:= FApi.ReserveMoney(
      aGamer.SessionID, FProcessID, aGamer.UserID,
      AmountToAdding, nNewReserv, nNewAmount
    );
  end else begin
    nRes := 0;
  end;
  if nRes <> NO_ERROR then begin
    CommonDataModule.Log(ClassName, 'DealMoreChips',
      '[ERROR] on execute FApi.ReserveMoney: Result=' + IntToStr(nRes) + ', SessionID=' + IntToStr(aGamer.SessionID) + ', UserID=' + IntToStr(aGamer.UserID) + ', ProcessID=' + IntToStr(ProcessID)
      , ltError
    );
    NotificationAboutCanNotMoreChips(aGamer);
    aGamer.DuringGameAddedMoney:= 0;
    Exit;
  end;

  aGamer.Account.AddFunds(Trunc(AmountToAdding * 100));
  if not aGamer.IsBot and (Trunc(nNewReserv * 100) <> aGamer.Account.Balance) then begin
    CommonDataModule.Log(ClassName, 'DealMoreChips',
      '[ERROR]: Current Gamer balance not correspond DataBase value after reservation.' +
        '; Params: ProcessID=' + IntToStr(FProcessID) +
        ', UserID=' + IntToStr(aGamer.UserID) +
        ', Balance=' + CurrToStr(aGamer.Account.Balance/100) +
        ', Reserved=' + CurrToStr(nNewReserv),
      ltError
    );
  end;
  aGamer.DuringGameAddedMoney:= 0;

  DispatchResponse(aGamer.SessionID, PrepareMoreChipsPacket(PrepareOutputPacket(RB_ALL, True), aGamer));
end;

procedure TpoGenericPokerGameEngine.DealMoreChipsForMultiTournament(nUserID: Integer);
var
  aGamer: TpoGamer;
begin
  aGamer := FTable.Gamers.GamerByUserID(nUserID);
  if (aGamer = nil) then Exit;

  aGamer.Account.AddFunds(aGamer.DuringGameAddedMoney);
  aGamer.DuringGameAddedMoney:= 0;
  if (aGamer.State = GS_ALL_IN) then aGamer.State := GS_IDLE;
  if aGamer.FinishedTournament then aGamer.FinishedTournament := False;

  DispatchResponse(aGamer.SessionID, PrepareMoreChipsPacket(PrepareOutputPacket(RB_ALL, True), aGamer));
end;

procedure TpoGenericPokerGameEngine.OnMoreChips(aGamer: TpoGamer);
begin
  if (aGamer = nil) then Exit;
  FMoreChipsSuspendedOperations.Add(aGamer.UserID);
end;

function TpoGenericPokerGameEngine.HandleMoreChips(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  nAmount: Currency;
  g: TpoGamer;
  n: IXMLNode;
  sMsg: string;
begin
  nAmount := 0;
  if aActionInfo.HasAttribute(PPTA_AMOUNT) then begin
    nAmount := StrToFloatDef(aActionInfo.Attributes[PPTA_AMOUNT], 0);
  end;

  if nAmount <= 0 then Exit;

  Result:= nil;
  g:= GetActionGamer(nSessionID, nUserIDAttr, False, False);
  if g = nil then Exit;
  if g.IsWatcher then Exit;

  if NOT( TournamentType = TT_NOT_TOURNAMENT ) then Exit;
  //define current reservation for gamer

  g.DuringGameAddedMoney:= g.DuringGameAddedMoney + Trunc(nAmount * 100);
  if g.IsSitOut or (g.State in [GS_IDLE, GS_SITOUT, GS_FOLD]) then begin
    OnMoreChips(g);
    Exit;
  end;

  if (g.DuringGameAddedMoney > 0) then begin
    // notification about adding
    sMsg := 'Requested ' +
      CurrToStr(g.DuringGameAddedMoney/100) + ' ' + CurrencyName +
      ' will be added next hand.';
    n:= PrepareChatPacket(
      PrepareOutputPacket(RB_REQUESTER, True),
      sMsg,
      MO_DEALER,
      0,
      g.UserID
    );
    DispatchResponse(g.SessionID, n);
  end;
end;//TpoGenericPokerGameEngine.HandleMoreChips


function TpoGenericPokerGameEngine.RetrieveStake(
  aActionInfo: IXMLNode; aGamer: TpoGamer; nGameraction: TpoGameraction): Integer;
var
  nStake: Integer;
  nDead : Integer;
begin
  Result:= 0;

  if aActionInfo.HasAttribute(PPTA_STAKE) then nStake := Trunc( StrToCurrDef(aActionInfo.Attributes[PPTA_STAKE], 0) * 100 )
  else nStake := 0;
  if nStake < 0 then nStake := 0;

  //If attribute has been set explicitely then use it
  if (nStake > 0) AND (nGameraction <> GA_POST_DEAD) then Result:= nStake
  else  begin
  //esle calc it
    case nGameraction of
      GA_POST_SB:
        begin
          Result:= FCroupier.GetSmallBlindStakeValue;
        end;//

      GA_POST_BB:
        begin
          Result:= FCroupier.GetBigBlindStakeValue();
        end;//

      GA_ANTE:
        begin
          Result:= FCroupier.GetAnteStakeValue();
        end;//

      GA_BRING_IN:
        begin
          Result:= FCroupier.GetBringInStakeValue();
        end;//

      GA_BET:
        begin
          Result:= FCroupier.GetBetStakeValue(aGamer);
        end;//

      GA_POST:
        begin
          if nStake > 0 then Result := nStake
          else begin
            if (NOT aGamer.SkippedSBStake) AND (NOT aGamer.SkippedBBStake) then
              Result:= FCroupier.GetBigBlindStakeValue()
            else if aGamer.SkippedSBStake AND (NOT aGamer.SkippedBBStake) then
              Result:= FCroupier.GetSmallBlindStakeValue
            else
              Result:= FCroupier.GetBigBlindStakeValue()+FCroupier.GetSmallBlindStakeValue;
          end;//if
        end;//

      GA_POST_DEAD:
        begin
          if aActionInfo.HasAttribute(PPTA_DEAD) then nDead := Trunc(StrToCurrDef(aActionInfo.Attributes[PPTA_DEAD], 0) * 100)
          else nDead := 0;
          if nDead < 0 then nDead := 0;

          if (nDead > 0) then Result:= nDead
          else begin
            if (NOT aGamer.SkippedSBStake) AND (NOT aGamer.SkippedBBStake) then
              Result:= 0
            else if aGamer.SkippedSBStake AND (NOT aGamer.SkippedBBStake) then
              Result:= 0
            else
              Result:= FCroupier.GetSmallBlindStakeValue;
          end;//if
        end;//if

      GA_CALL:
        begin
          Result:= FCroupier.GetCallStakeValue(aGamer);
        end;//

      GA_RAISE:
        begin
          Result:= FCroupier.GetRaiseStakeValue(aGamer);
        end;//
    end;//
  end;//if
end;

procedure TpoGenericPokerGameEngine.PrepareAndDispatchReorderedPackets(aGamer: TpoGamer);
var
  I: Integer;
  n, apn: IXMLNode;
  g: TpoGamer;
begin
//move bets
  if FExposeMoveBets then begin
  //-- update bets: --
    n:= PrepareMoveBetsPacket(PrepareOutputPacket(RB_ALL, False), FMoveBetsContext);
    DispatchResponse(0, n);
    PushHistoryEntry(0, n);
  //-- update pots: --
    n:= PreparePotPartsPacket(PrepareOutputPacket(RB_ALL, False));
    DispatchResponse(0, n);
    PushHistoryEntry(0, n);
  //clear flag
    FExposeMoveBets:= False;
  end;//if

//cards deal
  if FExposeCardDeals then begin
    for I:= 0 to Table.Gamers.Count-1 do begin
      g := Table.Gamers[I];
      if g.IsBot then Continue;
      n:= PrepareDealCardsPacket(
        PrepareOutputPacket(RB_REQUESTER, True), g.SessionID,
        FExposedCardRoundID, FExposedCardsOnRoundStart
      );
      DispatchResponse(g.SessionID, n);
    end;//for

  //update history
    n:= PrepareDealCardsPacket(
      nil, SHARED_HISTORY_SESSION_ID,
      FExposedCardRoundID, FExposedCardsOnRoundStart
    );
    PushHistoryEntry(0, n);
  //clear flag
    FCroupier.ClearCardsModifiedState;
    FExposeCardDeals:= False;
  end;//if

  if FOpenRoundGamerMessage <> '' then begin
    OnChatMessage(FOpenRoundGamerMessage);
    FOpenRoundGamerMessage:= '';
  end;//

//finish round
  if FOnFinishRoundPacket then begin
    if FTable.Hand.RoundID > 0 then begin
      n:= PrepareFinishRoundPacket(PrepareOutputPacket(RB_ALL, False));
      DispatchResponse(0, n);
    //update history
      PushHistoryEntry(0, n);
    end;//if
    FOnFinishRoundPacket:= False;
  end;//if

//active Player
  if FUpdateActivePlayer then begin
    apn:= nil;
    if (FTable.Hand.State = HST_RUNNING) AND (FTable.Hand.ActiveGamer <> nil) then begin
    //notify gamers about hand
      for I:= 0 to FTable.Gamers.Count-1 do begin
        g := FTable.Gamers[I];
        n:= PrepareOutputPacket(RB_REQUESTER, True);
        apn:= PrepareSetActivePlayerPacket(n, g.SessionID);
        //TBD: optimize packetr generation and dispatching here
        //personified for table sitters and one for all watchers
        if g.IsBot then Continue;
        DispatchResponse(g.SessionID, n);
      end;//for
    //update history
      if (apn <> nil) then begin
        PushHistoryEntry(0, apn);
      end;
    end;//if
    FUpdateactivePlayer:= False;
  end;//if

//ranking
  if FExposeRanking then FExposeRanking:= False;
end;

function TpoGenericPokerGameEngine.HandleSetParticipantAsLoggedIn(
  nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
begin
  HandleGamerReconnect(nSessionID, nUserIDAttr, aActionInfo);
end;


procedure TpoGenericPokerGameEngine.OnSetActivePlayer(Sender: TObject);
var
  g: TpoGamer;
  nAction: TpoGamerAction;
  nBotStake, nBotDead: Integer;
  XMLSetActivePlayer: IXMLNode;
begin
  FLastTimeActivity := IncSecond(Now, -1);

  g := FTable.ActiveGamer;
  nAction := GA_NONE;
  if g.IsBot then begin
    XMLSetActivePlayer := PrepareSetActivePlayerPacket(FResponseRoot, g.SessionID);
    nAction := OnBotSetActivePlayer(g, XMLSetActivePlayer, nBotStake, nBotDead);
    XMLSetActivePlayer := nil; // no need request
  end;

  if (nAction = GA_NONE) then begin
    FUpdateActivePlayer:= True;
  end;
end;

function TpoGenericPokerGameEngine.HandleActionPost(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
  nStake: Integer;
begin
//check inputs
  Result:= nil;
  g:= CheckActionAgainstHandContext(nSessionID, nUserIDAttr, aActionInfo, True, True);
  nStake:= RetrieveStake(aActionInfo, g, GA_POST);
  Croupier.HandleGamerPost(g, nStake);
  PrepareAndDispatchReorderedPackets(g);
end;


procedure TpoGenericPokerGameEngine.OnGamerSitOut(aGamer: TpoGamer);
var
  n: IXMLNode;
begin
  if aGamer.IsBot then Exit;

  n:= FResponseRoot.AddChild(PPTN_GAMER_ACTION);
  n.Attributes[PPTA_NAME]:=  PPTV_SIT_OUT;
  n.Attributes[PPTA_POSITION]:= IntToStr(aGamer.ChairID);

  DispatchGamerActionResponse(
    aGamer.SessionID, aGamer.UserID,
    n,
    False,
    True
  );
  PushHistoryEntry(0, n);
end;


procedure TpoGenericPokerGameEngine.RecalculateStats;

  function FormatStakes(nLoStake, nHiStake: Integer): String;
  begin
    Result:= '';
    case Croupier.StakeType of
      ST_FIXED_LIMIT:
        begin
          Result:= '';
          Result:= Result+FormatAmount(nLoStake, CurrencyID)+'/'+FormatAmount(nHiStake, CurrencyID);
        end;//
      ST_POT_LIMIT:
        begin
          Result:= 'PL ';
          Result:= Result+FormatAmount(nLoStake, CurrencyID);
//          Result:= Result+FormatAmount(FTable.MinBuyIn, CurrencyID);
        end;//
      ST_NO_LIMIT:
        begin
          Result:= 'NL ';
          Result:= Result+FormatAmount(nLoStake, CurrencyID);
//          Result:= Result+FormatAmount(FTable.MinBuyIn, CurrencyID);
        end;//if
    end;//case
  end;//if

  var
    nLowStake: Integer;

begin
  inherited;

  if FCroupier.TournamentType = TT_MULTI_TABLE then
    nLowStake := FCroupier.GetSmallBlindStakeValue
  else
    nLowStake := FCroupier.GetBigBlindStakeValue;

  FStats.ByID[PSID_STAKES].Value:= FormatStakes(nLowStake, nLowStake*2);
  FStats.ByID[PSID_AVG_POT].Value:= IntToStr(Round(FTable.AveragePot));

  if FCroupier.StakeType = ST_FIXED_LIMIT then
    FStats.ByID[PSID_LIMIT].Value := 'Fixed'
  else
  if FCroupier.StakeType = ST_POT_LIMIT then
   FStats.ByID[PSID_LIMIT].Value := 'PL'
  else
  if FCroupier.StakeType = ST_NO_LIMIT then
   FStats.ByID[PSID_LIMIT].Value := 'NL';

  if FTable.HandsPerHour > 120 then FStats.ByID[PSID_AVG_POT].Value:= '120+'
  else FStats.ByID[PSID_AVG_POT].Value:= IntToStr(FTable.HandsPerHour);

  FStats.ByID[PSID_AVG_POT].Value:= IntToStr(Round(FTable.AveragePot));

  if Croupier.PokerType IN [PT_TEXAS_HOLDEM, PT_OMAHA, PT_OMAHA_HILO,PT_SEVEN_STUD,PT_SEVEN_STUD_HILO] then FStats.ByID[PSID_PIRS_FLOP].Value:= FloatToStr(FTable.AvgPlayersAtFlop)+'%'
  else FStats.ByID[PSID_PIRS_4TH].Value:= FloatToStr(FTable.AvgPlayersAtFlop)+'%';

  if TournamentType = TT_SINGLE_TABLE then begin
    FStats.ByID[PSID_STATE].Value  := (FCroupier as TpoSingleTableTournamentCroupier).TournamentStatusAsString;
    FStats.ByID[PSID_WAIT].Value   := InttoStr(FTable.Chairs.GetFreeChairsCount);
    FStats.ByID[PSID_ENROLLED].Value := InttoStr(FCroupier.ReadyToPlayChairsCount)+' of '+InttoStr(FTable.Chairs.Count);
    FStats.ByID[PSID_GAME].Value   := FCroupier.PokerTypeAsString;
    FStats.ByID[PSID_BUY_IN].Value := FormatAmount(
      (Fcroupier as TpoGenericTournamentCroupier).TournamentBuyIn, CurrencyID
    );
  end;//if

  if (Table.Hand.State = HST_IDLE) OR (Table.HandsPerHour = 0) then FStats.ByID[PSID_H_HR].Value:= ''
  else FStats.ByID[PSID_H_HR].Value:= IntToStr(Table.HandsPerHour)//
end;

procedure TpoGenericPokerGameEngine.OnHandReconcileOperation(
  nHandID: Integer; aGamer: TpoGamer; sOpCode: String; nAmount: Integer;
  sComment: String
);
var
  bIsRaked: Boolean;
  nUserRakeAmount: Integer;
  sHandResult, sUserRakes: string;
begin
  if TournamentType = TT_NOT_TOURNAMENT then begin
    {
    <endofhand>
      <user userid="123" result="w|l|b" money="12.25" comment=""/>
      <fee  money="12.25" comment=""/>
    </endofhand>
    }

    sHandResult := '';
    sUserRakes  := '';
    bIsRaked := False;

    if Table.Hand.Pot.CasinoSettleAccount <> nil then begin
        bIsRaked := (Table.Hand.Pot.CasinoSettleAccount.Balance > 0);
    end;//if

    if aGamer <> nil then begin
      { Reconcile hand for bots is blocked }
      if aGamer.IsBot then Exit;

      { hand result packet }
      sHandResult := sHandResult + '<' + PPTN_USER + ' ' +
        PPTA_USER_ID      + '="' + IntToStr(aGamer.UserID) + '" ' +
        PPTA_GAMER_AMOUNT + '="' + FormatFloat('0.##', FCroupier.NormalizeAmount(aGamer.Account.Balance)) + '" ' +
        PPTA_RESULT       + '="' + sOpCode + '" ' +
        PPTA_MONEY        + '="' + FormatFloat('0.##', FCroupier.NormalizeAmount(nAmount)) + '" ' +
        PPTA_COMMENT      + '="' + sComment + '"/>';
      FApiHandAndRakesSuspendedOperations.Add(HRSO_HandResult, FTable.Hand.HandID, sHandResult, bIsRaked, sComment);

      { user rake packet }
      if bIsRaked then begin
        nUserRakeAmount :=
          Trunc
          (
            Table.Hand.Pot.CasinoSettleAccount.Balance *
            aGamer.Account.CreditBalance               /
            (Table.Hand.Pot.TotalAmount + Table.Hand.Pot.CasinoSettleAccount.Balance)
          );

        if (nUserRakeAmount > 0) then begin
          sUserRakes := sUserRakes + '<' + PPTN_USER + ' ' +
            PPTA_ID          + '="' + IntToStr(aGamer.UserID) + '" ' +
            PPTA_AMOUNT      + '="' + FormatFloat('0.##', FCroupier.NormalizeAmount(aGamer.Account.CreditBalance)) + '" ' +
            PPTA_TOTAL_RAKE  + '="' + FormatFloat('0.##', FCroupier.NormalizeAmount(Table.Hand.Pot.CasinoSettleAccount.Balance)) + '" ' +
            PPTA_RAKE_AMOUNT + '="' + FormatFloat('0.##', FCroupier.NormalizeAmount(nUserRakeAmount)) + '"/>';

          FApiHandAndRakesSuspendedOperations.Add(HRSO_UserRakes, FTable.Hand.HandID, sUserRakes, bIsRaked, sComment);
        end;
      end;
    end else begin
      sHandResult := sHandResult +
        '<' + PPTN_FEE + ' ' +
          PPTA_PROCESS_ID + '="' + IntToStr(ProcessID) + '" ' +
          PPTA_HAND_ID    + '="' + IntToStr(FTable.Hand.HandID) + '" ' +
          PPTA_MONEY      + '="' + FormatFloat('0.##', FCroupier.NormalizeAmount(nAmount)) + '" ' +
          PPTA_COMMENT    + '="' + sComment + '">' +
            AddingAffiliateFeeNodesAsString(nAmount) +
        '</' + PPTN_FEE + '>';
      FApiHandAndRakesSuspendedOperations.Add(HRSO_HandResult, FTable.Hand.HandID, sHandResult, bIsRaked, sComment);
    end;//if
  end;//
end;


function TpoGenericPokerGameEngine.HandleActionWaitBB(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
begin
  Result:= nil;
  g:= GetActionGamer(nSessionID, nUserIDAttr, True, False);
  FCroupier.HandleGamerWaitBB(g);
  PrepareAndDispatchReorderedPackets(g);
end;

function TpoGenericPokerGameEngine.HandleActionPostDead(
  nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
  nPostStake, nDeadStake: Integer;
begin
//check inputs
  Result:= nil;
  g:= CheckActionAgainstHandContext(nSessionID, nUserIDAttr, aActionInfo, True, True);
  nPostStake:= RetrieveStake(aActionInfo, g, GA_POST);
  nDeadStake:= RetrieveStake(aActionInfo, g, GA_POST_DEAD);
  Croupier.HandleGamerPostDead(g, nPostStake, nDeadStake);
  PrepareAndDispatchReorderedPackets(g);
end;

function TpoGenericPokerGameEngine.HandleActionAnte(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
  nStake: Integer;
begin
//check inputs
  Result:= nil;
  g:= CheckActionAgainstHandContext(nSessionID, nUserIDAttr, aActionInfo, True, True);
  nStake:= RetrieveStake(aActionInfo, g, GA_ANTE);
  Croupier.HandleGamerAnte(g, nStake);
  PrepareAndDispatchReorderedPackets(g);
end;

function TpoGenericPokerGameEngine.HandleActionBringIn(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
  nStake: Integer;
begin
//check inputs
  Result:= nil;
  g:= CheckActionAgainstHandContext(nSessionID, nUserIDAttr, aActionInfo, True, True);
  nStake:= RetrieveStake(aActionInfo, g, GA_BRING_IN);
  Croupier.HandleGamerBringIn(g, nStake);
  PrepareAndDispatchReorderedPackets(g);
end;

function TpoGenericPokerGameEngine.HandleActionShowCardsShuffled(
  nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
begin
  Result:= nil;
  g:= CheckActionAgainstHandContext(nSessionID, nUserIDAttr, aActionInfo, True, True);

  if (g = nil) then Exit;
  if g.ShowDownPassed or not FCroupier.IsShowdownRound then Exit;

  Croupier.HandleGamerShowCardsShuffled(g);
  PrepareAndDispatchReorderedPackets(g);
end;

procedure TpoGenericPokerGameEngine.OnRanking(aSender: TObject);
begin
  FExposeRanking := True;
end;

function TpoGenericPokerGameEngine.HandleTournamentActionInit(
  nTournamentID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  aParticipants: Variant;
  nCnt: Integer;
begin
  Result:= nil;
  CheckForTournament('{D91421AD-886F-48E3-8262-29AD809BE55D}');
  if aActionInfo.HasAttribute(PPTA_STAKE) AND
     (aActionInfo.Attributes[PPTA_STAKE] <> '')
  then TableStake:= Trunc(StrToFloat(aActionInfo.Attributes[PPTA_STAKE]) * 100);

  if aActionInfo.HasAttribute(PPTA_ANTE) AND
     (aActionInfo.Attributes[PPTA_ANTE] <> '')
  then MandatoryAnte:= Trunc(StrToFloat(aActionInfo.Attributes[PPTA_ANTE]) * 100);

  if aActionInfo.HAsAttribute(PPTA_SEQ_ID) then begin
    (FCroupier as TpoGenericTournamentCroupier).TournamentSeqID:=
       aActionInfo.Attributes[PPTA_SEQ_ID];
  end;//if

  TournamentID:= nTournamentID;
  aParticipants := DecodeTournamentParticipants(nCnt, aActionInfo);

  if (nCnt <= 0) then begin
    EscalateFailure(
      EpoException,
      'There are not gamers for init tournament participant.',
      '{B64E56F6-DB01-4831-9BCF-5F813DEE91C6}'
    );
  end;

  (FCroupier as TpoGenericTournamentCroupier).HandleTournamentInit(
    aParticipants, aActionInfo.Attributes[PPTA_REASON]
  );

  PrepareAndDispatchReorderedPackets(nil);
end;

function TpoGenericPokerGameEngine.HandleTournamentActionBreak(
  nTournamentID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
begin
  Result:= nil;
  CheckForTournament('{9B4AD657-305B-45F5-AE21-09E6F99AF2C3}');
  if aActionInfo.HasAttribute(PPTA_STAKE) AND
     (aActionInfo.Attributes[PPTA_STAKE] <> '')
  then TableStake:= Trunc(StrToFloat(aActionInfo.Attributes[PPTA_STAKE]) * 100);

  if aActionInfo.HasAttribute(PPTA_ANTE) AND
     (aActionInfo.Attributes[PPTA_ANTE] <> '')
  then MandatoryAnte:= Trunc(StrToFloat(aActionInfo.Attributes[PPTA_ANTE]) * 100);

  (FCroupier as TpoGenericTournamentCroupier).HandleTournamentBreak(
    aActionInfo.Attributes[PPTA_REASON]
  );

  PrepareAndDispatchReorderedPackets(nil);
end;

function TpoGenericPokerGameEngine.HandleTournamentActionEnd(
  nTournamentID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
begin
  Result:= nil;
  CheckForTournament('{1A55D960-12E4-468E-8145-4E02DC64D6C7}');
  if aActionInfo.HasAttribute(PPTA_STAKE) AND
     (aActionInfo.Attributes[PPTA_STAKE] <> '')
  then TableStake:= Trunc(StrToFloat(aActionInfo.Attributes[PPTA_STAKE])*100);

  if aActionInfo.HasAttribute(PPTA_ANTE) AND
     (aActionInfo.Attributes[PPTA_ANTE] <> '')
  then MandatoryAnte:= Trunc(StrToFloat(aActionInfo.Attributes[PPTA_ANTE]) * 100);

  (FCroupier as TpoGenericTournamentCroupier).HandleTournamentEnd(
    aActionInfo.Attributes[PPTA_REASON]
  );

  PrepareAndDispatchReorderedPackets(nil);
end;

function TpoGenericPokerGameEngine.HandleTournamentActionFree(
  nTournamentID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  sReason: String;
begin
//checks and init
  Result:= nil;
  CheckForTournament('{F6A7E659-6FC2-473A-BD86-FAAD34C45BF3}');

  if aActionInfo.HasAttribute(PPTA_STAKE) AND
     (aActionInfo.Attributes[PPTA_STAKE] <> '')
  then TableStake:= Trunc(StrToFloat(aActionInfo.Attributes[PPTA_STAKE]) * 100);

  if aActionInfo.HasAttribute(PPTA_ANTE) AND
     (aActionInfo.Attributes[PPTA_ANTE] <> '')
  then MandatoryAnte:= Trunc(StrToFloat(aActionInfo.Attributes[PPTA_ANTE]) * 100);

  if aActionInfo.HasAttribute(PPTA_REASON) then begin
    sReason:= aActionInfo.Attributes[PPTA_REASON];
  end else begin
    sReason:= 'The Game on this tournament table has finished so table have to be closed.';
  end;//if

  (FCroupier as TpoGenericTournamentCroupier).HandleTournamentFree(sReason);
  PrepareAndDispatchReorderedPackets(nil);
end;//TpoGenericPokerGameEngine.HandleTournamentActionFree


function TpoGenericPokerGameEngine.HandleTournamentActionPlay(
  nTournamentID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  nHandID: Integer;
  sReason: WideString;
  nRes, nCnt: Integer;
  sPlayReason: String; //message for watchers mustbe closed
  aParticipants: Variant;
begin
  Result:= nil;
  sPlayReason:= 'Table has finished tournament and has been closed.';

//check inputs
  CheckForTournament('{6ECFC709-A882-4C51-9A1E-93345A133CFD}');

  if aActionInfo.HasAttribute(PPTA_STAKE) AND
     (aActionInfo.Attributes[PPTA_STAKE] <> '')
  then TableStake:= Trunc(StrToFloat(aActionInfo.Attributes[PPTA_STAKE]) * 100);

  if aActionInfo.HasAttribute(PPTA_ANTE) AND
     (aActionInfo.Attributes[PPTA_ANTE] <> '')
  then MandatoryAnte:= Trunc(StrToFloat(aActionInfo.Attributes[PPTA_ANTE]) * 100);

  if aActionInfo.HAsAttribute(PPTA_SEQ_ID) then begin
    (FCroupier as TpoGenericTournamentCroupier).TournamentSeqID:=
       aActionInfo.Attributes[PPTA_SEQ_ID];
  end;//if

  if aActionInfo.HasAttribute(PPTA_REASON) then begin
    sPlayReason:= aActionInfo.Attributes[PPTA_REASON];
  end;//if

  TournamentID:= nTournamentID;

  CommonDataModule.Log(ClassName, 'HandleTournamentActionPlay',
    'Shuffle seed: '+IntToStr(System.RandSeed), ltCall);

  nRes:= FApi.StartHand(ProcessID, IntToStr(System.RandSeed), nHandID);

  EscalateFailure(nRes, EpoException, sReason, '{AC441C32-20AF-4EFF-8872-08AADF30F01C}');

  aParticipants := DecodeTournamentParticipants(nCnt, aActionInfo);
  if (nCnt <= 0) then begin
    EscalateFailure(
      EpoException,
      'There are not gamers for play command.',
      '{B49A4788-8822-4C6F-9DDE-CCA0D763ED8A}'
    );
  end;

  (FCroupier as TpoGenericTournamentCroupier).HandleTournamentPlay(
    nHandID, aParticipants, sPlayReason
  );

  PrepareAndDispatchReorderedPackets(nil);
end;//TpoGenericPokerGameEngine.HandleTournamentActionPlay


function TpoGenericPokerGameEngine.HandleTournamentActionResume(
  nTournamentID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  nHandID: Integer;
  sReason: WideString;
  nRes: Integer;
  nPlrsCnt: Integer;
  vLostPlrs: Array of Variant;
  I: Integer;
begin
  Result:= nil;

  CheckForTournament('{8F164C6B-7DF7-4409-B95B-24B23ED15B15}');
  if aActionInfo.HasAttribute(PPTA_STAKE) AND
     (aActionInfo.Attributes[PPTA_STAKE] <> '')
  then TableStake:= Trunc(StrToFloat(aActionInfo.Attributes[PPTA_STAKE]) * 100);

  if aActionInfo.HasAttribute(PPTA_ANTE) AND
     (aActionInfo.Attributes[PPTA_ANTE] <> '')
  then MandatoryAnte:= Trunc(StrToFloat(aActionInfo.Attributes[PPTA_ANTE]) * 100);

  if aActionInfo.HAsAttribute(PPTA_SEQ_ID) then begin
    (FCroupier as TpoGenericTournamentCroupier).TournamentSeqID:=
       aActionInfo.Attributes[PPTA_SEQ_ID];
  end;//if

  CommonDataModule.Log(ClassName, 'HandleTournamentActionResume',
    'Shuffle seed: '+IntToStr(System.RandSeed), ltCall);

  TournamentID:= nTournamentID;
  nRes:= FApi.StartHand(ProcessID, IntToStr(System.RandSeed), nHandID);
  EscalateFailure(nRes, EpoException, sReason, '{AC441C32-20AF-4EFF-8872-08AADF30F01C}');

//detect
  nPlrsCnt:= -1;
  SetLength(vLostPlrs, 0);
  if aActionInfo.HasAttribute(PPTA_COUNT_OF_PLACES) AND (aActionInfo.Attributes[PPTA_COUNT_OF_PLACES] <> '') then begin
    nPlrsCnt:= StrToIntDef(aActionInfo.Attributes[PPTA_COUNT_OF_PLACES], -1);
  end;//if

  if aActionInfo.ChildNodes.Count > 0 then begin
    SetLength(vLostPlrs, aActionInfo.ChildNodes.Count);
    for I:= 0 to aActionInfo.ChildNodes.Count-1 do begin
      vLostPlrs[I]:= StrToInt(aActionInfo.ChildNodes[I].Attributes[PPTA_USER_ID]);
    end;//for
  end;//if

  (FCroupier as TpoGenericTournamentCroupier).HandleTournamentResume(
    nHandID, aActionInfo.Attributes[PPTA_REASON], nPlrsCnt, vLostPlrs
  );

  PrepareAndDispatchReorderedPackets(nil);
end;

function TpoGenericPokerGameEngine.DecodeTournamentParticipants(var nCnt: Integer;
  aGamers: IXMLNode; sNodeName: string = ''): Variant;
var
  I, J, nLoop: Integer;
  aNode, aNodeIcon: IXMLNode;
  nLevelID: Integer;
  arrIcons: array [0..3] of string;
begin
  nCnt := aGamers.ChildNodes.Count; // initial
  if (sNodeName <> '') then begin
  // calc count of nodes
    nCnt := 0;
    for I:=0 to aGamers.ChildNodes.Count-1 do begin
      if (aGamers.ChildNodes[I].NodeName = sNodeName) then Inc(nCnt);
    end;
  end;
  if (nCnt <= 0) then Exit;

  Result:= VarArrayCreate([0, (nCnt-1)], varVariant);
  nLoop := 0;
  for I:= 0 to aGamers.ChildNodes.Count - 1 do begin
    aNode := aGamers.ChildNodes[I];
    if (aNode.NodeName <> sNodeName) and (sNodeName <> '') then Continue;
    nLevelID := 0;
    if aNode.HasAttribute(PPTA_LEVEL_ID) then
      nLevelID := aNode.Attributes[PPTA_LEVEL_ID];

    for J:=0 to High(arrIcons) do arrIcons[J] := '';
    for J:=0 to aNode.ChildNodes.Count - 1 do begin
      aNodeIcon := aNode.ChildNodes[J];
      if aNodeIcon.HasAttribute(PPTA_ICON) then
        arrIcons[J] := aNodeIcon.Attributes[PPTA_ICON];
      if (J >= High(arrIcons)) then Break;
    end;

    Result[nLoop]:= VarArrayOf([
      aNode.Attributes[PPTA_USER_ID],
      aNode.Attributes[PPTA_SESSION_ID],
      aNode.Attributes[PPTA_PLACE],
      aNode.Attributes[PPTA_MONEY],
      // after added bots
      aNode.Attributes[PPTA_IS_BOT],
      aNode.Attributes[PPTA_BOT_ID],
      aNode.Attributes[PPTA_BOT_BLAFFERS],
      aNode.Attributes[PPTA_BOT_CHARACTER],
      //
      aNode.Attributes[PPTA_SEX_ID],
      aNode.Attributes[PPTA_AVATAR_ID],
      aNode.Attributes[PPTA_CITY],
      aNode.Attributes[PPTA_NAME],
      nLevelID,
      arrIcons[0],
      arrIcons[1],
      arrIcons[2],
      arrIcons[3]
    ]);

    Inc(nLoop);
  end;//for
end;

procedure TpoGenericPokerGameEngine.OnUpdateGamerDetails(aGamer: TpoGamer);
begin
  UpdateParticipantInfo(aGamer, False);
end;

procedure TpoGenericPokerGameEngine.OnTournamentHandFinish(
  aSender: TObject; vInfo: Variant);
begin
  ScheduleSecIntervalEx(
    PPTT_TOURNAMENT_SCHEDULER_PACKET,
    PPTV_TOURNAMENT, GT_INTER_TOURNAMENT_INTERVAL, PrepareFinishTournamentHandPacket(nil, vInfo),
    False
  );
end;

procedure TpoGenericPokerGameEngine.OnProcCloseAction(sMsg: String);
var
  n: IXMLNode;
  nSessionID: Integer;
begin
  nSessionID:= 0;
  n:= PrepareProcClosePacket(PrepareOutputPacket(RB_ALL, True), sMsg);
  DispatchResponse(nSessionID, n, True);
end;

procedure TpoGenericPokerGameEngine.OnGamerBack(aGamer: TpoGamer);
var
  n: IXMLNode;
begin
  if aGamer = nil then EscalateFailure(EpoException, 'Gamer is not defined', '{2B8A5554-78A5-4DCA-AFCA-4D3E3631EA2C}');
  n:= FResponseRoot.AddChild(PPTN_GAMER_ACTION);
  n.Attributes[PPTA_NAME]:= PPTV_BACK;
  n.Attributes[PPTA_POSITION]:= IntToStr(aGamer.ChairID);
  DispatchGamerActionResponse(
    aGamer.SessionID, aGamer.UserID,
    n,
    False,
    True
  );
  PushHistoryEntry(0, n);
end;

function TpoGenericPokerGameEngine.HandleEventGamerReservationExpired(
  nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  nUserID: Integer;
  nAttrSessID: Integer;
  nParticipantCount: Integer;
  nRes: Integer;
  n: IXMLNode;
  bReminderWasFound: Boolean;
begin
  nUserID:= StrToIntDef(aActionInfo.Attributes[PPTA_USER_ID], UNDEFINED_USER_ID);
  nAttrSessID := StrToIntDef(aActionInfo.Attributes[PPTA_SESSION_ID], UNDEFINED_SESSION_ID);

  bReminderWasFound := DeleteIntervalByUserIDAndName(nUserID);

  if bReminderWasFound then begin
    FTable.Chairs.ClearGamerReservations(nUserID);

    nRes:= FApi.UnregisterFromWaitingList(
      nUserID, ProcessID, GroupID, nParticipantCount
    );

    if nRes <> NO_ERROR then begin
      DumpCachedStateToFile(FStateManager.CachedState);
      CommonDataModule.Log(ClassName, 'HandleEventGamerReservationExpired',
        '[ERROR] On execute FApi.UnregisterFromWaitingList: Result=' + IntToStr(nRes) +
        ', UserID=' + IntToStr(nUserID) + ', ProcessID=' + IntToStr(ProcessID) +
        ', GroupID=' + IntToStr(GroupID) + ', ParticipaintCount=' + IntToStr(nParticipantCount),
        ltError);
    end;
(*    EscalateFailure(
      nRes, EpoException, sReason, '{CFA2BBBB-B8D6-4BAB-A822-9759B99DB10A}'
    );
*)
    n:= PrepareWLCancelPacket();
    PushResponse(PPTV_REQUESTER, nAttrSessID, n.XML, nUserID, True);
  end;//if

  Result:= nil;
end;

function TpoGenericPokerGameEngine.CheckAndHandleReservations(): Boolean;
var
  nRes: Integer;
  nUserID, nSessionId: Integer;
  nGamersCount, nWatchersCount: Integer;
  nParticipantCount: Integer;
  ch: TpoChair;
  n: IXMLNode;
  CntIter: Integer;
begin
  Result:= False;
  if (FCroupier.TournamentType = TT_MULTI_TABLE) then Exit;

{ TODO : Uncoment "Exit" when waiting list will be anabling }
  Exit;

  FTable.Gamers.CalcGamerStats(nGamersCount, nWatchersCount);

  n:= PrepareWLTakePlacePacket();
  CntIter := -1;
  repeat
    Inc(CntIter);
    if (CntIter > (2 * FTable.Chairs.Count + 1)) then begin
      DumpCachedStateToFile(FStateManager.CachedState);
      CommonDataModule.Log(ClassName, 'CheckAndHandleReservations',
      '[WARNING - CIRCLE]: Count of iterations in REPEAT statment more then needing. Iteration count=' + IntToStr(CntIter) + ', Chair count=' + IntToStr(FTable.Chairs.Count) +
        'Dialer=' + IntToStr(FCroupier.Hand.DealerChairID) + ', Active=' + IntToStr(FCroupier.Hand.ActiveChairID) +
        'ProcessID=' + IntToStr(ProcessID) + ', HandID=' + IntToStr(FCroupier.Hand.HandID) +
        ', Round=' +IntToStr(FCroupier.Hand.RoundID),
      ltError);

      Exit;
(*
      EscalateFailure(
        EpoException,
        'Count of iterations in REPEAT statment more then needing. Iteration count=' + IntToStr(CntIter) + ', Chair count=' + IntToStr(FTable.Chairs.Count),
        '{8B86F3D7-A139-41BA-9F8E-143F453012D0}'
      );
*)
    end;

    ch:= FTable.Chairs.GetFirstFreeChair();
    if ch = nil then Exit;

    nUserID := UNDEFINED_USER_ID;
    nSessionId := UNDEFINED_SESSION_ID;
    nParticipantCount := 0;
    nRes:= FApi.GetNextFromWaitingListAndLock(
      ProcessID, GroupID, nGamersCount, nUserID, nSessionId, nParticipantCount
    );

    FStats.ByID[PSID_WAIT].Value:= IntToStr(nParticipantCount);

    if (nRes = 0) AND (nUserID <> UNDEFINED_USER_ID) then begin
      if nSessionId = UNDEFINED_SESSION_ID then begin
        CommonDataModule.Log(ClassName, 'CheckAndHandleReservations',
          'FApi.GetNextFromWaitingListAndLock return SessionID=0 for UserID=' + IntToStr(nUserID) + ' from Waiting List.',
          ltCall
        );
        Continue;
      end;

      ch.SetReservation(nUserID);
      SetupGamerReservationTimeout(ch.IndexOf, nUserID, nSessionId);
    //notify gamer about reservation
      PushResponse(PPTV_REQUESTER, nSessionId, n.XML, nUserID, True);
    end else Begin
      CommonDataModule.Log(ClassName, 'CheckAndHandleReservations',
        'FApi.GetNextFromWaitingListAndLock return SessionID=0 for UserID=' + IntToStr(nUserID) + ' from Wating List.',
        ltCall
      );
      Exit;
    end;
  until False;

  Result:= True;
end;

function TpoGenericPokerGameEngine.HandleWLDecline(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  ch: TpoChair;
  nRes: Integer;
  nParticipantCount, nUserID: Integer;
begin
//check inputs
  Result:= nil;
  nUserID := StrToIntDef(aActionInfo.Attributes[PPTA_USER_ID], UNDEFINED_USER_ID);
  if (nUserID <= UNDEFINED_USER_ID) then begin
    CommonDataModule.Log(ClassName, 'HandleWLDecline',
      '[ERROR]: Incorrect attribute [userid]. InputAction=[' + aActionInfo.Text + '].',
      ltError
    );

    Exit;
  end;

  ch := FTable.Chairs.GetReservedChairByUserID(nUserID);
  if ch = nil then begin
    CommonDataModule.Log(ClassName, 'HandleWLDecline',
      '[ERROR]: User with ID=' + IntToStr(nUserID) + ' not found among waiting list for ProcessID=' + IntToStr(ProcessID),
      ltError
    );

    Exit;
  end;

//
  DeleteGamerReservationTimeout(nUserID);
  FTable.Chairs.ClearGamerReservations(nUserID);
  nRes:= FApi.UnregisterFromWaitingList(nUserID, ProcessID, GroupID, nParticipantCount);
  if nRes <> NO_ERROR then begin
    DumpCachedStateToFile(FStateManager.CachedState);
    CommonDataModule.Log(ClassName, 'HandleWLDecline',
      '[ERROR] On execute FApi.UnregisterFromWaitingList: Result=' + IntToStr(nRes) +
      ', UserID=' + IntToStr(nUserID) + ', ProcessID=' + IntToStr(ProcessID) +
      ', GroupID=' + IntToStr(GroupID) + ', ParticipaintCount=' + IntToStr(nParticipantCount),
      ltError);
  end;
end;

function TpoGenericPokerGameEngine.HandleWLDeclineOnDisconnect(nSessionID, nUserID: Integer): Boolean;
var
  ch: TpoChair;
  nRes: Integer;
  nParticipantCount: Integer;
begin
  //check inputs
  Result:= True;
  ch := FTable.Chairs.GetReservedChairByUserID(nUserID);
  if ch = nil then begin
    CommonDataModule.Log(ClassName, 'HandleWLDecline',
      '[ERROR]: User with ID=' + IntToStr(nUserID) + ' not found among waiting list for ProcessID=' + IntToStr(ProcessID),
      ltError
    );

    Exit;
  end;

//
  DeleteGamerReservationTimeout(nUserID);
  FTable.Chairs.ClearGamerReservations(nUserID);
  nRes:= FApi.UnregisterFromWaitingList(nUserID, ProcessID, GroupID, nParticipantCount);
  if nRes <> NO_ERROR then begin
    DumpCachedStateToFile(FStateManager.CachedState);
    CommonDataModule.Log(ClassName, 'HandleWLDecline',
      '[ERROR] On execute FApi.UnregisterFromWaitingList: Result=' + IntToStr(nRes) +
      ', UserID=' + IntToStr(nUserID) + ', ProcessID=' + IntToStr(ProcessID) +
      ', GroupID=' + IntToStr(GroupID) + ', ParticipaintCount=' + IntToStr(nParticipantCount),
      ltError);
  end;
end;

procedure TpoGenericPokerGameEngine.HandleCachedPackets;
var
  wsComment: string;
  nRes: Integer;
  nActualAmount,
  nLastBalance: Currency;
  I: Integer;
  aOper: TpoTournayApiSuspendedOperation;
  aChipsOper: TpoMoreChipsSuspendedOperation;
  FTournamentReinitPacket: IXMLNode;
  aGamer: TpoGamer;

  function GetReasonOnError(aOperOnError: TpoTournayApiSuspendedOperation; nRes: Integer): string;
  begin
    case aOper.FTypeOperation of
      TSO_Reservation:
        Result := '[ERROR] On execute FApi.ReserveForTournament, result=' + IntToStr(nRes) +
          '; Params: ProcessID=' + IntToStr(ProcessID) +
          ', Data=[' + aOperOnError.FData + ']';
      TSO_UnReservation:
        Result := '[ERROR] On execute FApi.UnreserveForTournament, result=' + IntToStr(nRes) +
          '; Params: ProcessID=' + IntToStr(ProcessID) +
          ', Data=[' + aOperOnError.FData + ']';
      TSO_Prizes:
        Result := '[ERROR] On execute FApi.TournamentPrize, result=' + IntToStr(nRes) +
          '; Params: ProcessID=' + IntToStr(ProcessID) +
          ', Data=[' + aOperOnError.FData + ']';
    else
      Result := '';
    end;
  end;

begin
  inherited;
  wsComment:= '';

  { On more chips suspended operation }
  while (FMoreChipsSuspendedOperations.Count > 0) do begin
    aChipsOper := FMoreChipsSuspendedOperations.Items[0];
    if (Self.TournamentType = TT_MULTI_TABLE) then
      DealMoreChipsForMultiTournament(aChipsOper.FUserID)
    else
      DealMoreChips(aChipsOper.FUserID);

    FMoreChipsSuspendedOperations.Remove(aChipsOper);
  end;

  while (FTournayApiSuspendedOperations.Count > 0) do begin
    aOper := FTournayApiSuspendedOperations.Items[0];
    nRes := NO_ERROR;
    case aOper.FTypeOperation of
      TSO_Reservation:
      begin
        CommonDataModule.Log(ClassName, 'HandleCachedPackets', 'Tournament reservation=[' + aOper.FData + ']', ltCall);
        nRes:= FApi.ReserveForTournament(ProcessID, aOper.FData);
      end;
      TSO_UnReservation:
      begin
        CommonDataModule.Log(ClassName, 'HandleCachedPackets', 'Tournament Un-reservation=[' + aOper.FData + ']', ltCall);
        nRes:= FApi.UnreserveForTournament(ProcessID, aOper.FData);
      end;
      TSO_Prizes:
      begin
        CommonDataModule.Log(ClassName, 'HandleCachedPackets', 'Tournament Prize=[' + aOper.FData + ']', ltCall);
        nRes:= FApi.TournamentPrize(ProcessID, aOper.FData);
      end;
    end;

    { check on error }
    if (nRes <> NO_ERROR) then begin
      FTournayApiSuspendedOperations.Clear;

      EscalateFailure(nRes, EpoException,
        GetReasonOnError(aOper, nRes), '{C3651902-6D11-447E-84E7-282A7D592E5A}'
      );

      Exit;
    end;

    FTournayApiSuspendedOperations.Remove(aOper);
  end;

  //return deposits of left gamers
  for I := 0 to FDeposits.Count-1 do begin
    CommonDataModule.Log(ClassName, 'HandleCachedPackets',
      'Return deposit: UserID: '+IntToStr(FDeposits[I].UserID)+
      'SessionID: '+IntToStr(FDeposits[I].SessionID)+
      'Amount: '+FloatToStr(FDeposits[I].Amount/100)
      , ltCall);

    nRes := FApi.UnreserveMoney(
      FDeposits[I].SessionID,
      ProcessID,
      FDeposits[I].UserID,
      CurrencyID,
      FDeposits[I].Amount/100,
      nActualAmount,
      nLastBalance
    );//FApi.UnreserveMoney

    if (nRes <> NO_ERROR) then
      CommonDataModule.Log(ClassName, 'HandleCachedPackets',
        '[ERROR] on execute FApi.UnreserveMoney: Result=' + IntToStr(nRes) +
          '; ProcessID=' + IntToStr(ProcessID) +
          '; SessionID=' + IntToStr(FDeposits[I].SessionID) +
          '; UserID=' + IntToStr(FDeposits[I].UserID) +
          '; CurrencyID=' + IntToStr(CurrencyID) +
          '; Amount=' + CurrToStr(FDeposits[I].Amount/100),
        ltError
      );
  end;//for
  FDeposits.Clear;

  if FReInitSingeleTableTournament then begin
    FTournamentReinitPacket:= PrepareOutputPacket(RB_REQUESTER, True);
    PrepareProcStatePacket(
      FTournamentReinitPacket,  UNDEFINED_SESSION_ID
    );

    for I:= 0 to Table.Gamers.Count-1 do begin
      aGamer := Table.Gamers[I];
      if aGamer.IsBot then Continue;
      DispatchResponse(
        aGamer.SessionID, FTournamentReinitPacket
      );
    end;//for
    FTournamentReinitPacket:= nil;
    FReInitSingeleTableTournament := False;
  end;//if
end;
procedure TpoGenericPokerGameEngine.OnSingleTableTournamentStart(aSender: TObject);
var
  I: Integer;
  aGamer: TpoGamer;
begin
  DeleteAllCheckOnTimeOutReminders;
  { increment Timeout activity }
  FLastTimeActivity := IncSecond(Now, -1);
  for I:=0 to FTable.Gamers.Count - 1 do begin
    aGamer := FTable.Gamers[I];
    aGamer.LastTimeActivity := IncSecond(Now, -1);
  end;
end;

procedure TpoGenericPokerGameEngine.OnSingleTableTournamentFinish(aSender: TObject);
var
  I: Integer;
  aGamer: TpoGamer;
  nRes: Integer;
  TimeOutGamersActivity: Integer;
  sConfigData: string;
begin
  FTournayApiSuspendedOperations.Add(TSO_Prizes, FTable.Hand.HandID, PrepareSTTournamentPrizePacket());
  PrepareSTTournamentUserRakes();

  //restore stake
  TableStake:= Trunc(FProperties.PropertyByName(PP_LOWER_STAKES_LIMIT).AsDouble * 100);
  MandatoryAnte := 0;

  DeleteAllCheckOnTimeOutReminders;
  { increment Timeout activity }
  FLastTimeActivity := IncSecond(Now, -1);
  for I:=0 to FTable.Gamers.Count - 1 do begin
    aGamer := FTable.Gamers[I];
    aGamer.LastTimeActivity := IncSecond(Now, -1);
  end;

  { Get System options }
  sConfigData := '10';
  nRes := FApi.GetSystemOption(ID_TIME_OUT_GAMERS_ACTIVITY, sConfigData);
  if (nRes <> NO_ERROR) then begin
    CommonDataModule.Log(ClassName, 'CheckTimeOutActivityForNotTournay',
      '[ERROR] On execute FApi.GetSystemOption: Result=' + IntToStr(nRes) +
      '; Params: OptionID=' + IntToStr(ID_TIME_OUT_GAMERS_ACTIVITY) + '.',
      ltError);
    sConfigData := '10';
  end;
  TimeOutGamersActivity := StrToIntDef(sConfigData, 10) * 60;

  { create new reminders Timeout activity }
  FCheckTimeOutActivity := ScheduleSecInterval(0, TimeOutGamersActivity, PPTV_CHECK_TIMEOUT_ACTIVITY).ReminderID;

  FReInitSingeleTableTournament:= True;
  FTournayApiSuspendedOperations.Add(TSO_ReInit, FTable.Hand.HandID, '');
  FApiSuspendedOperations.Add(SO_UpdateParticipantCount);
end;

procedure TpoGenericPokerGameEngine.OnSingleTableTournamentFinishForBots(aSender: TObject);
var
  I: Integer;
  aGamer: TpoGamer;
  nBotsCount: Integer;
begin
  { remove bots }
  nBotsCount := 0;
  for I:=FTable.Gamers.Count - 1 downto 0 do begin
    aGamer := FTable.Gamers[I];
    if aGamer.IsBot then begin
      if not aGamer.KickOffFromTournament then Inc(nBotsCount);
      FCroupier.HandleLeftGamers(True);
      FTable.Gamers.Remove(aGamer);
    end;
  end;

  { create new remind for sitdown bots }
  if (nBotsCount > 0) then begin
    SetupBotsSitDownForMiniTournayActionTimeout(
      1, nBotsCount, 4 + Random(2)
    );
  end;
end;

procedure TpoGenericPokerGameEngine.OnOpenRoundGamer(sMsg: String);
begin
  FOpenRoundGamerMessage:= sMsg;
end;

procedure TpoGenericPokerGameEngine.PostProcessGamerActionExpired(
  aGamer: TpoGamer);
begin
  inherited;
  PrepareAndDispatchReorderedPackets(aGamer);
end;

procedure TpoGenericPokerGameEngine.OnGamerKickOff(aGamer: TpoGamer;
  sMsg: string);
begin
  if aGamer.IsBot then Exit;
  DispatchResponse(
    aGamer.SessionID,
    PrepareProcClosePacket(PrepareOutputPacket(RB_REQUESTER, True), sMsg)
  );
end;


function TpoGenericPokerGameEngine.HandleGamerAutoAction(
  nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  nAutoAction: TpoGamerAutoAction;
  nStake: Integer;
  nValue: Integer;
  nHandID: Integer;

  g: TpoGamer;
begin
  Result:= nil;

//retrieve and check params
  g:= GetActionGamer(nSessionID, nUserIDAttr, False, False);
  nAutoAction:= AutoActionNameToGamerAutoAction(aActionInfo.Attributes[PPTA_NAME]);
  if aActionInfo.HasAttribute(PPTA_STAKE) then begin
    nStake:= Trunc(StrToFloat(aActionInfo.Attributes[PPTA_STAKE]) * 100);
  end else begin
    nStake:= PL_UNDEFINED_STAKE_AMOUNT;
  end;
  nValue:= aActionInfo.Attributes[PPTA_VALUE];
  nHandID:= aActionInfo.Attributes[PPTA_HAND_ID];

  if nAutoAction IN TURN_LEVEL_AUTO_ACTIONS then begin
    if (Table.Hand.State <> HST_RUNNING) OR (Table.Hand.HandID <> nHandID) //OR
    then begin
      EscalateFailure(
        EpoUnexpectedActionException,
        'Auto action is out of context.',
        '{1D3FE16B-951A-4B61-84F8-6D0A5888DD82}'
      );
    end;//if
  end;//if

//handle
  FCroupier.HandleGamerAutoAction(g, nAutoAction, nStake, nValue > 0);
end;


procedure TpoGenericPokerGameEngine.OnGamerLeaveTable(aGAmer: TpoGamer);
var
  nAmount: Integer;
  sDataPacket: string;
begin
//unreserve gamer money
  if aGAmer.IsBot then Exit;

  if (TournamentType = TT_NOT_TOURNAMENT)
  then begin
    nAmount:= aGamer.Account.Balance;

    if nAmount > 0 then begin
      FDeposits.Add(aGamer.UserID, aGamer.SessionID, nAmount);
    end;//
  end else
  if (TournamentType = TT_SINGLE_TABLE) AND ((Croupier as TpoSingleTableTournamentCroupier).TournamentStatus = TST_IDLE) then begin
    if not aGAmer.IsWatcher then begin
      sDataPacket := PrepareSTTournamentUnreservationPacket(aGamer);
      FTournayApiSuspendedOperations.Add(TSO_UnReservation, FTable.Hand.HandID, sDataPacket);
    end;
  end;//if reservation is performed by game engine
end;

procedure TpoGenericPokerGameEngine.OnGamerPopUp(aGamer: TpoGamer;
  sCaption, sText: String; nType: Integer);
var
  nUserID: Integer;
  n: IXMLNode;
  nSessionID: Integer;
begin
  if aGamer <> nil then begin
    if aGamer.IsBot then Exit;

    nUserID:= aGamer.UserID;
    nSessionID:= aGamer.SessionID;
  end else begin
    nUserID:= UNDEFINED_USER_ID;
    nsessionID:= UNDEFINED_SESSION_ID;
  end;//

  n:= PrepareGamerPopUpPacket(
    PrepareOutputPacket(RB_REQUESTER, True), sCaption, aGamer, sText, nType
  );
  DispatchResponse(nSessionID, n, False, nUserID);
end;


procedure TpoGenericPokerGameEngine.OnChangeGamersCount(Sender: TObject);
begin
  FApiSuspendedOperations.Add(SO_UpdateParticipantCount);
end;

procedure TpoGenericPokerGameEngine.OnPotReconcileFinish(nPotID: Integer;
  sContext: String);
var
  n: IXMLNode;
begin
  n:= PrepareFinalPotPacket(PrepareOutputPacket(RB_ALL, False), nPotID, sContext);
  DispatchResponse(0, n);

//update history
  PushHistoryEntry(0, n);
end;


function TpoGenericPokerGameEngine.HandleGamerDisconnect(
  nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
  nUserID: Integer;

  procedure UnregisterOnDisconnect(nSessionID: Integer; aGamer: TpoGamer);
  var
    nUserID, nChairID: Integer;
  begin
    // Api unregister participaint
    nUserID  := UNDEFINED_USER_ID;
    if (aGamer <> nil) then nUserID := aGamer.UserID;
    nChairID := UNDEFINED_POSITION_ID;
    if (aGamer <> nil) then nChairID := aGamer.ChairID;

    if (nUserID > UNDEFINED_USER_ID) then begin
      HandleWLDeclineOnDisconnect(nSessionID, nUserID);
    end;

    FApiSuspendedOperations.Add(SO_UnRegisterParticipant, nSessionID, nUserID, nChairID);
    FApiSuspendedOperations.Add(SO_UpdateParticipantCount);

    // internal
    FTable.Gamers.UnregisterGamer(nSessionID);
  end;

begin
  Result:= nil;

  g := nil;
  if aActionInfo.HasAttribute(PPTA_USER_ID) then begin
    nUserID := StrToIntDef(aActionInfo.Attributes[PPTA_USER_ID], UNDEFINED_USER_ID);
    g := FTable.Gamers.GamerByUserID(nUserID);
    if g = nil then begin
      g := FTable.Gamers.GamerBySessionID(nSessionID);
    end else begin
      if (g.UserID = UNDEFINED_USER_ID) and not g.IsBot then begin
        g.Disconnected:= True;
        UnregisterOnDisconnect(nSessionID, g);
        Exit;
      end;
    end;
    if g = nil then begin
      UnregisterOnDisconnect(nSessionID, g);
      Exit;
    end;
  end;

  if g = nil then begin
    try
      g:= GetActionGamer(nSessionID, nUserIDAttr, False, False);
    except
      g := nil;
    end;
  end;

  { UnSubscribe session from process }
  if (g = nil) then begin
    UnregisterOnDisconnect(nSessionID, g);
    Exit;
  end;

  g.Disconnected:= True;
  if g.IsWatcher and not g.IsBot then begin
    if (g.UserID <= 0) then UnregisterOnDisconnect(nSessionID, g);
    Exit;
  end;
  OnChatMessage(g.UserName+' has been disconnected');
end;

function TpoGenericPokerGameEngine.HandleGamerReconnect(
  nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
  I: Integer;
  bNeedUpdateParticipantCount: Boolean;
begin
  Result:= nil;
  try
    g:= GetActionGamer(nSessionID, nUserIDAttr, False, False);
  except
    g:= nil;
  end;
  if (g = nil) then begin
    FApiSuspendedOperations.Add(SO_UpdateParticipantCount);
    FApiSuspendedOperations.Add(SO_UnRegisterParticipant, nSessionID);
    DispatchResponse(nSessionID,
      PrepareProcClosePacket(
        PrepareOutputPacket(RB_REQUESTER, True),
        'You are not found among gamers. Please entry to table again.'
      )
    );
    Exit;
  end;

  bNeedUpdateParticipantCount := False;
  for I := FTable.Gamers.Count -1 downto 0 do begin
    g := FTable.Gamers[I];
    if (g.SessionID = nSessionID) then begin
      if (g.UserID = UNDEFINED_USER_ID) then begin
        FTable.Gamers.DeleteGamer(g);
        bNeedUpdateParticipantCount := True;
      end;
    end;
  end; //for
  if bNeedUpdateParticipantCount then
    FApiSuspendedOperations.Add(SO_UpdateParticipantCount);

  g.Disconnected:= False;
  if Table.Hand.ActiveGamer <> nil then begin
    Result:= PrepareOutputPacket(RB_REQUESTER, True);
    PrepareSetActivePlayerPacket(Result, nSessionID);
    DispatchResponse(nSessionID, Result);
  end;//if
end;

function TpoGenericPokerGameEngine.OnCheckGamerAllins(
  aGamer: TpoGamer): Boolean;
var
  nRes: Integer;
  nItCan: Integer;
begin
  nRes:= FAPi.CanUserMakeAllIn(aGamer.UserID, nItCan);
  Result:= (nRes = 0) AND (nItCan > 0);
end;


function TpoGenericPokerGameEngine.HandleFinishTable(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  I: Integer;
begin
  Result:= nil;
  EngineResetMode:= True;
  //block all possible exceptions for finish - to prevent loopback
  try
  //stop hand
    Table.Hand.Reset();
  //kickoff gamers with unreservation
    for I:= 0 to Table.Chairs.Count-1 do begin
      if Table.Chairs[I].Gamer = nil then Continue
      else Table.Chairs[I].Gamer.State:= GS_LEFT_TABLE;
    end;//for
    FCroupier.HandleLeftGamers(True);
    Table.Chairs.KickOffAllGamers(True);
    Table.Gamers.Clear;
    OnChangeGamersCount(Self);
  except
  end;//try
end;

function TpoGenericPokerGameEngine.HandleUseTimeBank(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  g: TpoGamer;
begin
  Result:= nil;
//retrieve and check params
  g:= GetActionGamer(nSessionID, nUserIDAttr, False, False);
  if g = nil then Exit;
  FCroupier.HandleGamerUseTimeBank(g);
end;

procedure TpoGenericPokerGameEngine.OnPrepareReorderedPackets(
  aGamer: TpoGamer);
begin
  PrepareAndDispatchReorderedPackets(aGamer);
end;

function TpoGenericPokerGameEngine.HandleTournamentCloseTable(
  nTournamentID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  sReason: String;
  I: Integer;
begin
  Result:= nil;
  CheckForTournament('{C4BFF0F5-039F-41DC-B5B5-3106D82DAFF5}');
  sReason:= 'Table has finished tournament and has been closed.';

  if aActionInfo.HasAttribute(PPTA_REASON) then
    sReason:= aActionInfo.Attributes[PPTA_REASON];

    CommonDataModule.Log(ClassName, 'HandleTournamentCloseTable',
      'tournament table closed (reason: '+sReason+')', ltCall);

//close all wathers
  for I:= Table.Gamers.Count-1 downto 0 do begin
    if (Table.Gamers[I].ChairID = UNDEFINED_POSITION_ID) OR
      (Table.Gamers[I].FinishedTournament) then
    begin
      OnGamerKickOff(Table.Gamers[I], sReason);
      Table.Gamers.DeleteGamer(Table.Gamers[I]);
    end;//if
  end;//for
end;

function TpoGenericPokerGameEngine.HandleTournamentChangePlace(
  nTournamentID, nUserIDAttr: Integer; aActionInfo: IXMLNode
): IXMLNode;
var
  nPlrsCnt, nCntOperation: Integer;
  vStandUpPlrs: Variant;
  vSitDownPlrs: Variant;
  sChatMsg: string;
begin
  Result:= nil;

  CheckForTournament('{8F164C6B-7DF7-4409-B95B-24B23ED15B15}');
  if aActionInfo.HasAttribute(PPTA_STAKE) AND
     (aActionInfo.Attributes[PPTA_STAKE] <> '')
  then TableStake:= Trunc(StrToFloat(aActionInfo.Attributes[PPTA_STAKE]) * 100);

  if aActionInfo.HasAttribute(PPTA_ANTE) AND
     (aActionInfo.Attributes[PPTA_ANTE] <> '')
  then MandatoryAnte:= Trunc(StrToFloat(aActionInfo.Attributes[PPTA_ANTE]) * 100);

  if aActionInfo.HAsAttribute(PPTA_SEQ_ID) then begin
    (FCroupier as TpoGenericTournamentCroupier).TournamentSeqID:=
       aActionInfo.Attributes[PPTA_SEQ_ID];
  end;//if

  CommonDataModule.Log(ClassName, 'HandleTournamentChangePlace', 'tournament table change place', ltCall);

  TournamentID:= nTournamentID;
//detect
  nPlrsCnt:= -1;
  if aActionInfo.HasAttribute(PPTA_COUNT_OF_PLACES) AND (aActionInfo.Attributes[PPTA_COUNT_OF_PLACES] <> '') then begin
    nPlrsCnt:= StrToIntDef(aActionInfo.Attributes[PPTA_COUNT_OF_PLACES], -1);
  end;//if

  sChatMsg := '';
  if aActionInfo.HasAttribute(PPTA_CHAT) then
    sChatMsg := aActionInfo.Attributes[PPTA_CHAT];

  // standUP
  vStandUpPlrs := DecodeTournamentParticipants(nCntOperation, aActionInfo, PPTN_STANDUP);
  if (nCntOperation > 0) then begin
    (FCroupier as TpoGenericTournamentCroupier).HandleTournamentStandUp(
      '', nPlrsCnt, False, vStandUpPlrs);
    if (sChatMsg <> '') then OnChatMessage(sChatMsg);
  end;

  // SitDown
  vSitDownPlrs := DecodeTournamentParticipants(nCntOperation, aActionInfo, PPTN_SITDOWN);
  if (nCntOperation > 0) then begin
    (FCroupier as TpoGenericTournamentCroupier).HandleTournamentSitDown(
      '', nPlrsCnt, vSitDownPlrs);
  end;//if

  PrepareAndDispatchReorderedPackets(nil);
//
end;

function TpoGenericPokerGameEngine.HandleTournamentKickOffUsers(
  nTournamentID, nUserIDAttr: Integer; aActionInfo: IXMLNode
): IXMLNode;
var
  nPlrsCnt, nCntOperation: Integer;
  vKickedOff: Variant;
begin
  Result:= nil;

  CheckForTournament('{6BEEF3AD-867F-4748-BDC6-8516125A54B4}');
  if aActionInfo.HasAttribute(PPTA_STAKE) AND
     (aActionInfo.Attributes[PPTA_STAKE] <> '')
  then TableStake:= Trunc(StrToFloat(aActionInfo.Attributes[PPTA_STAKE]) * 100);

  if aActionInfo.HasAttribute(PPTA_ANTE) AND
     (aActionInfo.Attributes[PPTA_ANTE] <> '')
  then MandatoryAnte:= Trunc(StrToFloat(aActionInfo.Attributes[PPTA_ANTE]) * 100);

  if aActionInfo.HAsAttribute(PPTA_SEQ_ID) then begin
    (FCroupier as TpoGenericTournamentCroupier).TournamentSeqID:=
       aActionInfo.Attributes[PPTA_SEQ_ID];
  end;//if

  CommonDataModule.Log(ClassName, 'HandleTournamentKickOffUsers', 'Tournament KickOff command was arrived', ltCall);

  TournamentID:= nTournamentID;
  //detect
  nPlrsCnt:= -1;
  if aActionInfo.HasAttribute(PPTA_COUNT_OF_PLACES) AND (aActionInfo.Attributes[PPTA_COUNT_OF_PLACES] <> '') then begin
    nPlrsCnt:= StrToIntDef(aActionInfo.Attributes[PPTA_COUNT_OF_PLACES], -1);
  end;//if

  // kick off by command from tournament
  vKickedOff := DecodeTournamentParticipants(nCntOperation, aActionInfo, PPTN_KICK_OFF);
  if (nCntOperation > 0) then begin
    (FCroupier as TpoGenericTournamentCroupier).HandleTournamentKickOff(
      '', nPlrsCnt, vKickedOff);
  end;

  PrepareAndDispatchReorderedPackets(nil);
//
end;

procedure TpoGenericPokerGameEngine.OnMultyTournamentProcState(
  aGamer: TpoGamer);
begin
  if aGamer.IsBot then Exit;
  HandleProcState(aGamer.SessionID, aGamer.UserID, nil);
end;

function TpoGenericPokerGameEngine.HandleKickOffUser(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
begin
  Result := nil;
  if aActionInfo.HasAttribute('userid') then begin
    CommonDataModule.Log(ClassName, 'HandleKickOffUser',
      'Command KickOffUserFromProcess was arrived for UserID=' + aActionInfo.Attributes['userid'],
      ltCall);

    HandleGALeaveTable(nSessionID, nUserIDAttr, aActionInfo);
  end else begin
    CommonDataModule.Log(ClassName, 'HandleKickOffUser',
      '[ERROR]: Command KickOffUserFromProcess was arrived for uncnown user.',
      ltError);
  end;
end;

function TpoGenericPokerGameEngine.HandleGALeaveTable(nSessionID, nUserIDAttr: Integer;
  aActionInfo: IXMLNode): IXMLNode;
var
  nUserID, nSID: Integer;
  sHost: string;
  aGamer: TpoGamer;
  sMsg: string;
  vKickedOffPlayers: array of variant;
begin
  Result := nil;
  if aActionInfo.HasAttribute('userid') then begin
    CommonDataModule.Log(ClassName, 'HandleGALeaveTable',
      'Command galeavetable was arrived for UserID=' + aActionInfo.Attributes['userid'],
      ltCall);

    nUserID := StrToIntDef(aActionInfo.Attributes['userid'], 0);
    if (nUserID <= 0) then begin
      CommonDataModule.Log(ClassName, 'HandleGALeaveTable',
        '[ERROR]: Command [galevetable] was arrived for uncnown user.; userid=' + aActionInfo.Attributes['userid'],
        ltError);
      FApiSuspendedOperations.Add(SO_UnRegisterParticipant, nSessionID);
      OnChangeGamersCount(nil);
      Exit;
    end;

    aGamer := Table.Gamers.GamerByUserID(nUserID);
    if (aGamer = nil) then begin
      CommonDataModule.Log(ClassName, 'HandleGALeaveTable',
        '[ERROR]: Command [galevetable] was arrived for not registered user.; userid=' + aActionInfo.Attributes['userid'],
        ltError);
      Table.Gamers.DumpGamers;

      FApiSuspendedOperations.Add(SO_UnRegisterParticipant, nSessionID);
      OnChangeGamersCount(nil);
      Exit;
    end;

    //update game partisipant
    if not aGamer.IsBot then
      FApiSuspendedOperations.Add(SO_UnRegisterParticipant, aGamer.SessionID,
        aGamer.UserID, aGamer.ChairID
      );
    OnChangeGamersCount(nil);

    //handle post packets
    sMsg := '';
    if aActionInfo.HasAttribute('message') then sMsg := aActionInfo.Attributes['message'];
    if sMsg = '' then sMsg := 'You have been left the table.';
    nSID  := aGamer.SessionID;
    sHost := aGamer.SessionHost;

    if (FCroupier.TournamentType = TT_SINGLE_TABLE) then begin
      SetLength(vKickedOffPlayers, 1);
      vKickedOffPlayers[0] := aGamer.UserID;
      (Croupier as TpoGenericTournamentCroupier).HandleTournamentKickOff('', 0, vKickedOffPlayers);
    end else begin
      Croupier.HandleGamerLeaveTable(aGamer);
    end;

    if not aGamer.IsBot then begin
      DispatchResponse(
        nSID,
        PrepareProcClosePacket(PrepareOutputPacket(RB_REQUESTER, True), sMsg),
        True, nUserID
      );
    end;
    PrepareAndDispatchReorderedPackets(nil);
  end else begin
    FApiSuspendedOperations.Add(SO_UnRegisterParticipant, nSessionID);
    OnChangeGamersCount(nil);
    CommonDataModule.Log(ClassName, 'HandleGALeaveTable',
      '[ERROR]: Command [galevetable] was arrived for uncnown user.',
      ltError);
  end;
end;

function TpoGenericPokerGameEngine.HandleTournamentActionEvent(
  nTournamentID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  sMsg, sEventName, sExceptUserIDs: string;
  I, nActionDispatcherID, nDuration: Integer;
  n: IXMLNode;
  aGamer: TpoGamer;

begin
  Result:= nil;

  CheckForTournament('{8F164C6B-7DF7-4409-B95B-24B23ED15B15}');
  TournamentID:= nTournamentID;

  sMsg := '';
  if aActionInfo.HasAttribute(PPTA_MSG) then
    sMsg := aActionInfo.Attributes[PPTA_MSG];

  sEventName := '';
  if aActionInfo.HasAttribute(PPTA_EVENT) then
    sEventName := aActionInfo.Attributes[PPTA_EVENT];

  nActionDispatcherID := 1;
  if aActionInfo.HasAttribute(PPTA_ACTIONDISPATCHERID) then
    nActionDispatcherID := aActionInfo.Attributes[PPTA_ACTIONDISPATCHERID];

  nDuration := 0;
  if aActionInfo.HasAttribute(PPTA_BREAKDURATION) then
    nDuration := aActionInfo.Attributes[PPTA_BREAKDURATION];

  sExceptUserIDs := '';
  if aActionInfo.HasAttribute(PPTA_EXCEPTUSERIDS) then
    sExceptUserIDs := aActionInfo.Attributes[PPTA_EXCEPTUSERIDS];

  { output xml packet }
  if sEventName <> 'finishtournament' then begin
    n := PrepareOutputPacketTournamentEvent(RB_ALL, sEventName, sMsg, nActionDispatcherID, nDuration);
    DispatchResponse(-1, n);
  end else begin
    sExceptUserIDs := ',' + Trim(sExceptUserIDs) + ',';
    for I:=0 to FTable.Gamers.Count - 1 do begin
      aGamer := FTable.Gamers[I];
      if not aGamer.IsWatcher then Continue;
      if (aGamer.UserID > 0) and (Pos(',' + IntToStr(aGamer.UserID) + ',', sExceptUserIDs) > 0) then Continue;

      n := PrepareOutputPacketTournamentEvent(RB_REQUESTER,
        sEventName, sMsg, nActionDispatcherID, nDuration
      );
      if not aGamer.IsBot then DispatchResponse(aGamer.SessionID, n, False, aGamer.UserID);
    end;
  end;
end;

function TpoGenericPokerGameEngine.HandleActionBotsSitDown(nSessionID,
  nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  I, nCountForSitDown, nType, nRes: Integer;
  aBotCharacter: TFixUserCharacter;
  //
  aBuffChairs: TObjectList;
  aTempGamers: TpoGamers;
  aChair: TpoChair;
  aGamer, aBot: TpoGamer;
  nCountOfEmpty, nPosition, nMoney: Integer;
  sName: string;
begin
{
  <bot_sitdown maxnumberperprocess="%d" type="0|1|2"/>
}
  nCountForSitDown := 0;
  if aActionInfo.HasAttribute(PPTA_MAX_PER_PROCESS) then
    nCountForSitDown := StrToIntDef(aActionInfo.Attributes[PPTA_MAX_PER_PROCESS], 0);
  nType := -1;
  if aActionInfo.HasAttribute(PPTA_TYPE) then
    nType := StrToIntDef(aActionInfo.Attributes[PPTA_TYPE], -1);

  { validate action }
  if (nCountForSitDown <= 0) or not
     (nType in [Integer(Low(TFixUserCharacter))..Integer(High(TFixUserCharacter))])
  then begin
    CommonDataModule.Log(ClassName, 'HandleActionBotsSitDown',
      '[ERROR]: Input action has incorrect attributes: Action=[' + aActionInfo.XML + ']',
      ltError);
    Exit;
  end;

  aBotCharacter := TFixUserCharacter(nType);

  nCountOfEmpty := FTable.Chairs.GetFreeChairsCount;
  if (nCountOfEmpty <= 0) then begin
    CommonDataModule.Log(ClassName, 'HandleActionBotsSitDown',
      '[WARNING] On ' + aActionInfo.NodeName + ' action: Empty chairs not found; ProcessID=' + IntToStr(ProcessID) + '; Action=[' + aActionInfo.XML + ']',
      ltCall);
    Exit;
  end;

  { filling buffered memo }
  aTempGamers := TpoGamers.Create(FTable);
  nRes := GetBotsData(aTempGamers);
  if (nRes <> NO_ERROR) then begin
    aTempGamers.Free;
    Exit;
  end;
  for I:=0 to FTable.Gamers.Count - 1 do begin
  // delete exists bots by name
    sName := FTable.Gamers[I].UserName;
    aGamer := aTempGamers.GamerByName(sName);

    if (aGamer <> nil) then aTempGamers.Remove(aGamer);
  end;
  if (aTempGamers.Count <= 0) then begin
    aTempGamers.Free;
    CommonDataModule.Log(ClassName, 'HandleActionBotsSitDown',
      '[ERROR]: Not enough bots for allocations.',
      ltError
    );
    Exit;
  end;

  aBuffChairs := TObjectList.Create(False);
  for I:=0 to FTable.Chairs.Count - 1 do begin
    aChair := FTable.Chairs[I];
    if (aChair.State = CS_EMPTY) then begin
      aBuffChairs.Add(aChair as TObject);
    end;
  end;

  nCountForSitDown := Min(nCountForSitDown, nCountOfEmpty);
  nCountForSitDown := Min(nCountForSitDown, aTempGamers.Count);
  while nCountForSitDown > 0 do begin
    I := Random(aBuffChairs.Count - 1);
    aChair := aBuffChairs.Items[I] as TpoChair;
    nPosition := aChair.ID;
    I := Random(aTempGamers.Count - 1);
    aGamer := aTempGamers[I];
    nMoney := FTable.MinBuyIn + Random(FTable.MaxBuyIn - FTable.MinBuyIn);

    { registration bot }
    aBot := FTable.Gamers.RegisterGamer(
      aGamer.UserID, '', aGamer.UserID, aGamer.UserName, aGamer.SexID,
      aGamer.City, aGamer.AvatarID, aGamer.ImageVersion, aGamer.ChatAllow,
      aGamer.AffiliateID, aGamer.IsEmailValidated, 0, nil
    );
    aBot.IsBot := True;
    aBot.BotCharacter := aBotCharacter;
    aBot.BotBlaffersEvent := MIN_COUNT_ONBLAFFERS + Random(MAX_COUNT_ONBLAFFERS - MIN_COUNT_ONBLAFFERS);
    aBot.BotID := aGamer.SessionID;
    aBot.LastTimeActivity := IncSecond(Now, -1);


    { bot sitdown }
    if TournamentType = TT_SINGLE_TABLE then begin
      FCroupier.HandleGamerSitDown(aBot, nPosition, TournamentChips)
    end else begin
      FCroupier.HandleGamerSitDown(aBot, nPosition, nMoney);
    end;//

    //response
    DispatchGamerActionResponse(aBot.SessionID, aBot.UserID, aActionInfo, False, False);

    aBuffChairs.Remove(aChair as TObject);
    aTempGamers.Remove(aGamer);

    Dec(nCountForSitDown);
  end;

  aBuffChairs.Free;
  aTempGamers.Free;

  FLastTimeActivity := IncSecond(Now, -1);
  FApiSuspendedOperations.Add(SO_UpdateParticipantCount);
end;

function TpoGenericPokerGameEngine.HandleActionBotsStandupAll(
  nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode
): IXMLNode;
var
  I: Integer;
  aGamer: TpoGamer;
  aChair: TpoChair;
  bNeedChangeGamersCount: Boolean;
  vKickedOffBots: Array of Variant;
begin
{ <bot_standup_all/> }
  Result := nil;

  bNeedChangeGamersCount := False;
  for I:=0 to FTable.Chairs.Count - 1 do begin
    aChair := FTable.Chairs[I];
    aGamer := aChair.Gamer;
    if (aGamer = nil) then Continue;
    if not aGamer.IsBot then Continue;

    bNeedChangeGamersCount := True;

    if (FCroupier.TournamentType = TT_SINGLE_TABLE) then begin
      SetLength(vKickedOffBots, 1);
      vKickedOffBots[0] := aGamer.UserID;
      (Croupier as TpoGenericTournamentCroupier).HandleTournamentKickOff('', 0, vKickedOffBots);
    end else begin
      Croupier.HandleGamerLeaveTable(aGamer);
    end;

    PrepareAndDispatchReorderedPackets(nil);
  end;
  if bNeedChangeGamersCount then OnChangeGamersCount(nil);
end;


function TpoGenericPokerGameEngine.HandleActionBotStandup(nSessionID,
  nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  aGamer: TpoGamer;
  nBotID: Integer;
  sGuid: string;
  vKickedOffBots: Array of Variant;

  procedure SendAdminMSMQ(nResult: Integer; sMsg, sGuid: string; aActionInfo: IXMLNode);
  var
    sBody: string;
    aMemNode: IXMLNode;
  begin
    if (sGuid = '') then Exit;
    aMemNode := aActionInfo.CloneNode(False);
    aMemNode.Attributes[PPTA_RESULT] := nResult;
    aMemNode.Attributes[PPTA_GUID] := sGuid;
    if (nResult <> 0) and (sMsg <> '') then
      aMemNode.Attributes[PPTA_MESSAGE] := sMsg;

    sBody := aMemNode.XML;
    aMemNode := nil;

    CommonDataModule.SendAdminMSMQ(sBody, sGuid);
  end;
begin
{ <bot_standup botid="%d" guid="..."/> }
  Result := nil;

  sGuid := '';
  if aActionInfo.HasAttribute(PPTA_GUID) then
    sGuid := aActionInfo.Attributes[PPTA_GUID];
  nBotID := -1;
  if aActionInfo.HasAttribute(PPTA_BOT_ID) then
    nBotID := StrToIntDef(aActionInfo.Attributes[PPTA_BOT_ID], -1);
  { validate }
  if (nBotID <= 0) then begin
    CommonDataModule.Log(ClassName, 'HandleActionBotStandup',
      '[ERROR]: Illegal attribute botid; Action=[' + aActionInfo.XML + ']', ltError);
    SendAdminMSMQ(1, 'Incorrect attribute botid.', sGuid, aActionInfo);
    Exit;
  end;

  aGamer := FTable.Gamers.GamerByBotID(nBotID);
  if (aGamer = nil) then begin
    CommonDataModule.Log(ClassName, 'HandleActionBotStandup',
      '[ERROR]: Bot by botid not found.; Action=[' + aActionInfo.XML + ']', ltError);
    SendAdminMSMQ(1, 'Bot not found among gamers of processid = ' + IntToStr(ProcessID), sGuid, aActionInfo);
    Exit;
  end;
  if not aGamer.IsBot then begin
    CommonDataModule.Log(ClassName, 'HandleActionBotStandup',
      '[ERROR]: Founded Gamer by botid is not bot.; Action=[' + aActionInfo.XML + ']', ltError);
    SendAdminMSMQ(1, 'Gamer with botid=' + IntToStr(nBotID) + ' is not bot for process = ' + IntToStr(ProcessID), sGuid, aActionInfo);
    Exit;
  end;

  if (FCroupier.TournamentType = TT_SINGLE_TABLE) then begin
    SetLength(vKickedOffBots, 1);
    vKickedOffBots[0] := aGamer.UserID;
    (Croupier as TpoGenericTournamentCroupier).HandleTournamentKickOff('', 0, vKickedOffBots);
  end else begin
    Croupier.HandleGamerLeaveTable(aGamer);
  end;

  { response }
  SendAdminMSMQ(0, '', sGuid, aActionInfo);

  OnChangeGamersCount(nil);
  PrepareAndDispatchReorderedPackets(nil);
end;

function TpoGenericPokerGameEngine.HandleActionBotPolicy(nSessionID,
  nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  aGamer: TpoGamer;
  nBotID: Integer;
  sGuid: string;
  BotNode: IXMLNode;
  I: Integer;
  sMsg: string;
  aBotType: TFixUserCharacter;
  nType: Integer;

  procedure SendAdminMSMQ(nResult: Integer; sMsg, sGuid: string; aActionInfo: IXMLNode);
  var
    aMemNode: IXMLNode;
    sBody: string;
  begin
    if (sGuid = '') then Exit;
    aMemNode := aActionInfo.CloneNode(False);
    aMemNode.Attributes[PPTA_RESULT] := nResult;
    aMemNode.Attributes[PPTA_GUID] := sGuid;
    if (nResult <> 0) and (sMsg <> '') then
      aMemNode.Attributes[PPTA_MESSAGE] := sMsg;

    sBody := aMemNode.XML;
    aMemNode := nil;

    CommonDataModule.SendAdminMSMQ(sBody, sGuid);
  end;

begin
{
  <bot_policy type="0|1|2" guid="...">
		<bot id="%d"/>
			...
		</bot_policy>
}
  Result := nil;
  if (aActionInfo.ChildNodes.Count <= 0) then begin
    CommonDataModule.Log(ClassName, 'HandleActionBotPolicy',
      '[ERROR]: There are no bot nodes; Action=[' + aActionInfo.XML + ']', ltError);
    SendAdminMSMQ(1, 'There are no bot nodes', sGuid, aActionInfo);
    Exit;
  end;

  if not aActionInfo.HasAttribute(PPTA_TYPE) then begin
    CommonDataModule.Log(ClassName, 'HandleActionBotPolicy',
      '[ERROR]: Attribute type not found; Action=[' + aActionInfo.XML + ']', ltError);
    SendAdminMSMQ(1, 'Not founded attribute type.', sGuid, aActionInfo);
    Exit;
  end;
  nType := StrToIntDef(aActionInfo.Attributes[PPTA_TYPE], -1);
  if not (nType in [0..2]) then begin
    CommonDataModule.Log(ClassName, 'HandleActionBotPolicy',
      '[ERROR]: Attribute type is incorrect; Action=[' + aActionInfo.XML + ']', ltError);
    SendAdminMSMQ(1, 'Attribute type is incorrect.', sGuid, aActionInfo);
    Exit;
  end;
  aBotType := TFixUserCharacter(nType);

  sGuid := '';
  if aActionInfo.HasAttribute(PPTA_GUID) then
    sGuid := aActionInfo.Attributes[PPTA_GUID];

  sMsg := '';
  for I:=0 to aActionInfo.ChildNodes.Count - 1 do begin
    BotNode := aActionInfo.ChildNodes[I];

    nBotID := -1;
    if BotNode.HasAttribute(PPTA_ID) then
      nBotID := StrToIntDef(BotNode.Attributes[PPTA_ID], -1);
    { validate }
    if (nBotID <= 0) then begin
      CommonDataModule.Log(ClassName, 'HandleActionBotPolicy',
        '[ERROR]: Illegal attribute botid; Action=[' + BotNode.XML + ']', ltError);
      sMsg := sMsg + #13#10 + 'Incorrect attribute botid.';
      Continue;
    end;

    aGamer := FTable.Gamers.GamerByBotID(nBotID);
    if (aGamer = nil) then begin
      CommonDataModule.Log(ClassName, 'HandleActionBotPolicy',
        '[ERROR]: Bot by botid not found.; Action=[' + BotNode.XML + ']', ltError);
      sMsg := sMsg + #13#10 + 'Bot not found (botid=' + IntToStr(nBotID) + ')';
      Continue;
    end;
    if not aGamer.IsBot then begin
      CommonDataModule.Log(ClassName, 'HandleActionBotPolicy',
        '[ERROR]: Founded Gamer by botid is not bot.; Action=[' + BotNode.XML + ']', ltError);
      sMsg := sMsg + #13#10 + 'Gamer with botid=' + IntToStr(nBotID) + ' is not bot';
      Continue;
    end;

    aGamer.BotCharacter := aBotType;
  end;

  { response }
  if (sMsg <> '') then begin
    SendAdminMSMQ(1, sMsg, sGuid, aActionInfo);
  end else begin
    SendAdminMSMQ(0, '', sGuid, aActionInfo);
  end;
end;

function TpoGenericPokerGameEngine.HandleActionBotGetTableInfo(nSessionID,
  nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  sBody: string;
  sGuid: string;
  aMemNode: IXMLNode;
  aChairNode: IXMLNode;
  I: Integer;
  aGamer: TpoGamer;
  aChair: TpoChair;
begin
{	<bot_gettableinfo guid="..."/> }
  Result := nil;
  sGuid := '';
  if aActionInfo.HasAttribute(PPTA_GUID) then
    sGuid := aActionInfo.Attributes[PPTA_GUID];

  aMemNode := aActionInfo.CloneNode(False);
  aMemNode.Attributes[PPTA_RESULT] := 0;
  aMemNode.Attributes[PPTA_GUID] := sGuid;

  for I:=0 to FTable.Chairs.Count - 1 do begin
    aChair := FTable.Chairs[I];
    aGamer := aChair.Gamer;

    aChairNode := aMemNode.AddChild(PPTN_CHAIR);
    aChairNode.Attributes[PPTA_POSITION] := aChair.ID;

    if (aGamer = nil) or (aChair.State = CS_EMPTY) then begin
      aChairNode.Attributes[PPTA_STATEID] := 0;
      aChairNode.Attributes[PPTA_LOGINNAME] := '';
    end else if aGamer.IsBot then begin
      aChairNode.Attributes[PPTA_STATEID] := 2;
      aChairNode.Attributes[PPTA_LOGINNAME] := aGamer.UserName;
      aChairNode.Attributes[PPTA_ID] := aGamer.BotID;
      aChairNode.Attributes[PPTA_TYPE] := Integer(aGamer.BotCharacter);
    end else begin
      aChairNode.Attributes[PPTA_STATEID] := 1;
      aChairNode.Attributes[PPTA_LOGINNAME] := aGamer.UserName;
      aChairNode.Attributes[PPTA_ID] := aGamer.UserID;
    end;
  end;

  sBody := aMemNode.XML;
  aMemNode := nil;

  CommonDataModule.SendAdminMSMQ(sBody, sGuid);
end;

function TpoGenericPokerGameEngine.HandleTournamentRebuy(nTournamentID,
  nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  nPlrsCnt, nCntOperation: Integer;
  vRebuyPlrs: Variant;
begin
  Result:= nil;

  CheckForTournament('{6BEEF3AD-867F-4748-BDC6-8516125A54B4}');
  if aActionInfo.HasAttribute(PPTA_STAKE) AND
     (aActionInfo.Attributes[PPTA_STAKE] <> '')
  then TableStake:= Trunc(StrToFloat(aActionInfo.Attributes[PPTA_STAKE]) * 100);

  if aActionInfo.HasAttribute(PPTA_ANTE) AND
     (aActionInfo.Attributes[PPTA_ANTE] <> '')
  then MandatoryAnte:= Trunc(StrToFloat(aActionInfo.Attributes[PPTA_ANTE]) * 100);

  if aActionInfo.HAsAttribute(PPTA_SEQ_ID) then begin
    (FCroupier as TpoGenericTournamentCroupier).TournamentSeqID:=
       aActionInfo.Attributes[PPTA_SEQ_ID];
  end;//if

  TournamentID:= nTournamentID;
//detect
  nPlrsCnt:= -1;
  if aActionInfo.HasAttribute(PPTA_COUNT_OF_PLACES) AND (aActionInfo.Attributes[PPTA_COUNT_OF_PLACES] <> '') then begin
    nPlrsCnt:= StrToIntDef(aActionInfo.Attributes[PPTA_COUNT_OF_PLACES], -1);
  end;//if

  // Rebuy
  vRebuyPlrs := DecodeTournamentParticipants(nCntOperation, aActionInfo, PPTN_REBUY);
  if (nCntOperation > 0) then begin
    (FCroupier as TpoGenericTournamentCroupier).HandleTournamentRebuy(
      '', nPlrsCnt, vRebuyPlrs);
  end;//if

  PrepareAndDispatchReorderedPackets(nil);
end;

function TpoGenericPokerGameEngine.HandleTournamentStandUpToWatcher(nTournamentID,
  nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
var
  nPlrsCnt, nCntOperation: Integer;
  vStandUpPlrs: Variant;
  sChatMsg: string;
begin
  Result:= nil;

  CheckForTournament('{8F164C6B-7DF7-4409-B95B-24B23ED15B15}');
  if aActionInfo.HasAttribute(PPTA_STAKE) AND
     (aActionInfo.Attributes[PPTA_STAKE] <> '')
  then TableStake:= Trunc(StrToFloat(aActionInfo.Attributes[PPTA_STAKE]) * 100);

  if aActionInfo.HasAttribute(PPTA_ANTE) AND
     (aActionInfo.Attributes[PPTA_ANTE] <> '')
  then MandatoryAnte:= Trunc(StrToFloat(aActionInfo.Attributes[PPTA_ANTE]) * 100);

  if aActionInfo.HAsAttribute(PPTA_SEQ_ID) then begin
    (FCroupier as TpoGenericTournamentCroupier).TournamentSeqID:=
       aActionInfo.Attributes[PPTA_SEQ_ID];
  end;//if

  CommonDataModule.Log(ClassName, 'HandleTournamentChangePlace', 'tournament table change place', ltCall);

  TournamentID:= nTournamentID;
//detect
  nPlrsCnt:= -1;
  if aActionInfo.HasAttribute(PPTA_COUNT_OF_PLACES) AND (aActionInfo.Attributes[PPTA_COUNT_OF_PLACES] <> '') then begin
    nPlrsCnt:= StrToIntDef(aActionInfo.Attributes[PPTA_COUNT_OF_PLACES], -1);
  end;//if

  sChatMsg := '';
  if aActionInfo.HasAttribute(PPTA_CHAT) then
    sChatMsg := aActionInfo.Attributes[PPTA_CHAT];

  // standUP without delete
  vStandUpPlrs := DecodeTournamentParticipants(nCntOperation, aActionInfo, PPTN_STANDUP);
  if (nCntOperation > 0) then begin
    (FCroupier as TpoGenericTournamentCroupier).HandleTournamentStandUp(
      '', nPlrsCnt, True, vStandUpPlrs);
    if (sChatMsg <> '') then OnChatMessage(sChatMsg);
  end;

  PrepareAndDispatchReorderedPackets(nil);
//
end;

{ TpoGameActions }

function TpoGameActions.ActionByName(sActionName: String): TpoGameAction;
var
  nID: Integer;
begin
  nID:= IndexOf(sActionName);
  if nID >= 0 then Result:= Objects[nID] as TpoGameAction
  else Result:= nil;
end;

function TpoGameActions.AddAction(sActionName: String;
  aAction: TpoGameAction): TpoGameAction;
var
  nID: Integer;
begin
  nID:= IndexOf(sActionName);
  Result:= aAction;
  Result.Name:= sActionName;
  if nID >= 0 then begin
    Objects[nID].Free;
    Delete(nID);
  end;//if
  AddObject(sActionName, Result);
end;

function TpoGameActions.AddAction(sActionName: String;
  aHandler: TOnExecuteAction): TpoGameAction;
begin
  Result:= TpoGameAction.Create(FEngine);
  Result.Name:= sActionName;
  Result.OnExecute:= aHandler;
  AddAction(sActionName, Result);
end;

function TpoGameActions.AddSubAction(
  sActionName, sSubActionName: String; aHandler: TOnExecuteAction;
  sActionAttribute: String): TpoGameAction;
var
  sa: TpoGameAction;
begin
  Result:= ActionByName(sActionName);
  if Result = nil then begin
    Result:= TpoGameAction.Create(FEngine);
    Result.Name:= sActionName;
    AddAction(sActionName, Result);
  end;//

  if sSubActionName = '' then Result.OnExecute:= aHandler
  else begin
    Result.OnExecute:= nil;
    if Result.FSubActions = nil then begin
      Result.FSubActions:= TpoGameActions.Create(FEngine);
      Result.FSubActions.AttributeName:= sActionAttribute;
    end;//if
    sa:= TpoGameAction.Create(FEngine);
    sa.Name:= sSubActionName;
    sa.OnExecute:= aHandler;
    Result.FSubActions.AddAction(sSubActionName, sa);
  end;//if
end;

procedure TpoGameActions.Clear;
var
  I: Integer;
begin
  for I := 0 to Count-1 do begin
    TpoGameAction(Objects[I]).Free;
  end;//for
  inherited;
end;

constructor TpoGameActions.Create(
  aEngine: TpoBasicGameEngine);
begin
  inherited Create;
  FEngine:= aEngine;
  Sorted:= True;
end;

destructor TpoGameActions.Destroy;
begin
  Clear;
  inherited;
end;

function TpoGameActions.DispatchAction(
  nOriginatorID, nUserIDAttr: Integer; aAction: IXMLNode): IXMLNode;
var
  sActionName: String;
begin
  Result:= nil;
  if AttributeName = '' then sActionName:= aAction.NodeName
  else sActionName:= aAction.Attributes[AttributeName];
  sActionName:= Trim(sActionName);
  if sActionName = '' then Exit;
  Result:= Actions[sActionName].Execute(nOriginatorID, nUserIDAttr, aAction);
end;

function TpoGameActions.GetActions(sName: String): TpoGameAction;
begin
  Result:= ActionByName(sName);
  if Result = nil then begin
    EscalateFailure(
      EpoUnexpectedActionException,
      'Unsupported action {'+sName+'}.',
      '{8AD7B487-E2D7-436F-A538-3197266732CD}',
      GE_ERR_UNSUPPORTED_ACTION
    );
  end;//if
end;

function TpoGameActions.IsSupported(aActionInfo: IXMLNode): Boolean;
begin
  Result:= IsSupported(aactionInfo.NodeName);
end;

function TpoGameActions.IsSupported(sActionName: String): Boolean;
begin
  Result:= ActionByName(sActionName) <> nil;
end;

procedure TpoGameActions.SetAttributeName(const Value: String);
begin
  FAttributeName := Value;
end;

{ TpoGameAction }

constructor TpoGameAction.Create(
  aEngine: TpoBasicGameEngine);
begin
  inherited Create;
  FEngine:= aEngine;
end;

function TpoGameAction.DefaultExecuteHandler(nSessionID: Integer;
  aActionInfo: IXMLNode): IXMLNode;
begin
  Result:= FEngine.PrepareOutputPacket(RB_REQUESTER, True);
  Result.ChildNodes.Add(aActionInfo.CloneNode(True));
end;

destructor TpoGameAction.Destroy;
begin
  if FSubActions <> nil then FSubActions.Free;
  inherited;
end;

function TpoGameAction.Execute(nSessionID, nUserIDAttr: Integer; aActionInfo: IXMLNode): IXMLNode;
begin
  if (aActionInfo[PPTA_NAME] = '') OR (FSubActions = nil) then begin
    if Assigned(OnExecute) then Result:= OnExecute(nSessionID, nUserIDAttr, aActionInfo)
    else DefaultExecuteHandler(nSessionID, aActionInfo);
  end else begin
    Result:= FSubActions.DispatchAction(nSessionID, nUserIDAttr, aActionInfo);
  end;//if
end;

procedure TpoGameAction.SetName(const Value: String);
begin
  FName := Value;
end;

procedure TpoGameAction.SetOnExecute(const Value: TOnExecuteAction);
begin
  FOnExecute := Value;
end;


{ TpoGameStatItem }

constructor TpoGameStatItem.Create(
  nID: Integer; sName: String;
  sPropType: TGamePropertyType; bIsStandard: Boolean;
  sModifier: TGamePropertyModifier);

begin
  inherited Create(sName, '0', sPropType, sModifier);

  FIsStandard:= bIsStandard;
  FID:= nID;
end;

destructor TpoGameStatItem.Destroy;
begin
  inherited;
end;

function TpoGameStatItem.Load(aReader: TReader): Boolean;
begin
  Result:= inherited Load(aReader);
  FIsStandard:= aReader.ReadBoolean;
  FID:= aReader.ReadInteger;
end;

procedure TpoGameStatItem.SetID(const Value: Integer);
begin
  FID := Value;
end;

procedure TpoGameStatItem.SetIsStandard(const Value: Boolean);
begin
  FIsStandard := Value;
end;

function TpoGameStatItem.Store(aWriter: TWriter): Boolean;
begin
  Result:= inherited Store(aWriter);
  aWriter.WriteBoolean(FIsStandard);
  aWriter.WriteInteger(FID        );
end;

{ TpoGameStats }

function TpoGameStats.AddStatItem(
  nID: Integer; sName: String;
  sPropType: TGamePropertyType; bIsStandard: Boolean;
  sModifier: TGamePropertyModifier): TpoGameStatItem;
begin
  Result:= TpoGameStatItem.Create(nID, sName, sPropType, bIsStandard, sModifier);
  Add(Result);
end;

constructor TpoGameStats.Create;
begin
  inherited Create;
end;

destructor TpoGameStats.Destroy;
begin
  inherited;
end;

function TpoGameStats.GetByID(ID: Integer): TpoGameStatItem;
var
  i: Integer;
begin
  Result:= nil;
  for I:= 0 to Count-1 do begin
    if (Items[I] as TpoGameStatItem).ID = ID then begin
      Result:= Items[I] as TpoGameStatItem;
      Exit;
    end;//if
  end;//for
end;

function TpoGameStats.GetStats(Index: Integer): TpoGameStatItem;
begin
  Result:= Items[Index] as TpoGameStatItem;
end;

procedure TpoGameStats.HideAllStats;
var
  i: Integer;
begin
  for I:= 0 to Count-1 do begin
    Stats[I].Modifier := GPM_NOT_EXPOSED;
  end;//for
end;

function TpoGameStats.Load(aReader: TReader): Boolean;
var
	I, nCnt: Integer;
begin
  Clear;
	nCnt:= aReader.ReadInteger;
	for I:= 0 to nCnt-1 do AddStatItem().Load(aReader);
	Result:= True;
end;

function TpoGameStats.Store(aWriter: TWriter): Boolean;
var
	I: Integer;
begin
	aWriter.WriteInteger(Count);
	for I:= 0 to Count-1 do Stats[I].Store(aWriter);
	Result:= True;
end;

{ TpoReminder }

constructor TpoReminder.Create;
begin
  inherited Create;
end;

destructor TpoReminder.Destroy;
begin
  inherited;
end;

function TpoReminder.Load(aReader: TReader): Boolean;
begin
  FReminderName := aReader.ReadString;
  FReminderID   := aReader.ReadString;
  FRemindTime   := aReader.ReadDate;
  FSessionID    := aReader.ReadInteger;
  FUserID       := aReader.ReadInteger;
  FExpired      := aReader.ReadBoolean;
  FData         := aReader.ReadString;
  aReader.Read(FGamerActions, SizeOf(FGamerActions));
  Result:= True;
end;

procedure TpoReminder.SetData(const Value: string);
begin
  FData := Value;
end;

procedure TpoReminder.SetExpired(const Value: Boolean);
begin
  FExpired := Value;
end;

procedure TpoReminder.SetGamerActions(const Value: TpoGamerActions);
begin
  FGamerActions := Value;
end;

procedure TpoReminder.SetReminderID(const Value: string);
begin
  FReminderID := Value;
end;

procedure TpoReminder.SetReminderName(const Value: String);
begin
  FReminderName := Value;
end;

procedure TpoReminder.SetRemindTime(const Value: TDateTime);
begin
  FRemindTime := Value;
end;

procedure TpoReminder.SetSessionID(const Value: Integer);
begin
  FSessionID := Value;
end;

procedure TpoReminder.SetUserID(const Value: Integer);
begin
  FUserID := Value;
end;

function TpoReminder.Store(aWriter: TWriter): Boolean;
begin
  aWriter.WriteString(FReminderName);
  aWriter.WriteString(FReminderID);
  aWriter.WriteDate(FRemindTime);
  aWriter.WriteInteger(FSessionID);
  aWriter.WriteInteger(FUserID);
  aWriter.WriteBoolean(FExpired);
  aWriter.WriteString(FData);
  aWriter.Write(FGamerActions, SizeOf(FGamerActions));
  Result:= True;
end;

{ TpoReminders }

function TpoReminders.AddReminder(sReminderName: string; sReminderID: String; sData: string;
  nRemindTime: TDateTime; nSessionID: Integer): TpoReminder;
begin
  Result:= Reminder[sReminderID, sReminderName];
  if Result = nil then Result:= TpoReminder.Create;
  Result.ReminderName:= sReminderName;
  Result.ReminderID:= sReminderID;
  Result.FRemindTime:= nRemindTime;
  Result.SessionID  := nSessionID;
  Result.Data := sData;
  Add(Result);
end;

function TpoReminders.AddReminder(aReminder: TpoReminder): TpoReminder;
begin
  Result:= aReminder;
  Add(Result);
end;

constructor TpoReminders.Create;
begin
  inherited Create;
end;

function TpoReminders.DeleteReminder(sReminderID: String): Boolean;
var
  aReminder: TpoReminder;
begin
  aReminder:= Reminder[sReminderID, ''];
  Result := (aReminder <> nil);
  if Result then Remove(aReminder);
end;

destructor TpoReminders.Destroy;
begin
  Clear;
  inherited;
end;

function TpoReminders.GetByName(sReminderName: string): TpoReminder;
var
  I: Integer;
begin
  Result:= nil;
  for I:= 0 to Count-1 do begin
    if (Item[I].FReminderName = sReminderName) then begin
      Result:= Item[I];
      Exit;
    end;//
  end;//for
end;

function TpoReminders.GetItem(Index: Integer): TpoReminder;
begin
  Result:= Items[Index] as TpoReminder;
end;

function TpoReminders.GetReminder(nReminderID: String;
  sReminderName: String): TpoReminder;
var
  I: Integer;
begin
  Result:= nil;
  for I:= 0 to Count-1 do begin
    if (Item[I].FReminderID = nReminderID) AND ((Item[I].FReminderName = sReminderName) OR (sReminderName = ''))then begin
      Result:= Item[I];
      Exit;
    end;//
  end;//for
end;

function TpoReminders.GetReminderByUserIDAndName(nUserID: Integer; sName: String): TpoReminder;
var
  I: Integer;
begin
  Result:= nil;
  for I:= 0 to Count-1 do begin
    if (Item[I].UserID = nUserID) AND ((Item[I].ReminderName = sName) OR (sName = '')) then begin
      Result:= Item[I];
      Exit;
    end;//if
  end;//
end;

function TpoReminders.Load(aReader: TReader): Boolean;
var
  I, cnt: Integer;
  r: TpoReminder;
begin
  Clear;
  cnt:= aReader.ReadInteger;
  for I:= 0 to cnt-1 do begin
    r:= TpoReminder.Create;
    r.Load(aReader);
    AddReminder(r);
  end;//for
  Result:= True;
end;

function TpoReminders.Store(aWriter: TWriter): Boolean;
var
  I: Integer;
begin
  aWriter.WriteInteger(Count);
  for I:= 0 to Count-1 do begin
    Item[I].Store(aWriter);
  end;//for
  Result:= true;
end;

{ TpoMessage }

constructor TpoMessage.Create(aOwner: TpoMessageList;
  sRespGroup: string; nSessionID: Integer;
  sMsgBody: String; nUserID: Integer; bIncludeRequester: Boolean);
begin
  inherited Create;
  FRespGroup := sRespGroup;
  FSessionID:= nSessionID;
  FMsgBody  := sMsgBody;
  FUserID   := nUserID;
  FIncludeRequester := bIncludeRequester;
  FTime := Now;
  //
  FOwner := aOwner;
end;

destructor TpoMessage.Destroy;
begin
  FMsgBody := '';
  FRespGroup := '';
  inherited;
end;

function TpoMessage.Load(aReader: TReader): Boolean;
begin
  FSessionID := aReader.ReadInteger;
  FMsgBody   := aReader.ReadString;
  FUserID    := aReader.ReadInteger;
  FRespGroup := aReader.ReadString;
  FIncludeRequester := aReader.ReadBoolean;
  FTime := aReader.ReadDate;

	Result:= True;
end;

procedure TpoMessage.SetIncludeRequester(const Value: Boolean);
begin
  FIncludeRequester := Value;
end;

procedure TpoMessage.SetMsgBody(const Value: String);
begin
  FMsgBody := Value;
end;

procedure TpoMessage.SetRespGroup(const Value: string);
begin
  FRespGroup := Value;
end;

procedure TpoMessage.SetSessionID(const Value: Integer);
begin
  FSessionID := Value;
end;

procedure TpoMessage.SetTime(const Value: TDateTime);
begin
  FTime := Value;
end;

procedure TpoMessage.SetUserID(const Value: Integer);
begin
  FUserID := Value;
end;

function TpoMessage.Store(aWriter: TWriter): Boolean;
begin
  aWriter.WriteInteger(FSessionID);
  aWriter.WriteString(FMsgBody);
  aWriter.WriteInteger(FUserID);
  aWriter.WriteString(FRespGroup);
  aWriter.WriteBoolean(FIncludeRequester);
  aWriter.WriteDate(FTime);

	Result:= True;
end;

{ TpoMessageQueue }


constructor TpoMessageList.Create;
begin
  inherited Create;
end;

destructor TpoMessageList.Destroy;
begin
  Clear;
  inherited;
end;

function TpoMessageList.GetItems(nIndex: Integer): TpoMessage;
begin
  Result := TpoMessage(inherited Items[nIndex]);
end;

function TpoMessageList.Load(aReader: TReader): Boolean;
var
  I, nCnt: Integer;
  aMsg: TpoMessage;
begin
  nCnt := aReader.ReadInteger;
  Clear;
  for I:=0 to nCnt - 1 do begin
    aMsg := TpoMessage.Create(Self, '', 0, '');
    aMsg.Load(aReader);
    PushMessage(aMsg);
  end;
  Result := True;
end;

function TpoMessageList.PushMessage(aMessage: TpoMessage): TpoMessage;
begin
  Result:= aMessage;
  inherited Add(aMessage as TObject);
end;

function TpoMessageList.Store(aWriter: TWriter): Boolean;
var
  I: Integer;
  aMsg: TpoMessage;
begin
  aWriter.WriteInteger(Count);
  for I:=0 to Count - 1 do begin
    aMsg := Items[I];
    aMsg.Store(aWriter);
  end;//while

  Result := True;
end;

{ TpoGamerDeposit }

constructor TpoGamerDeposit.Create;
begin
  inherited Create;
end;

destructor TpoGamerDeposit.Destroy;
begin
  inherited;
end;

procedure TpoGamerDeposit.SetAmount(const Value: Integer);
begin
  FAmount := Value;
end;

procedure TpoGamerDeposit.SetSessionID(const Value: Integer);
begin
  FSessionID := Value;
end;

procedure TpoGamerDeposit.SetUserID(const Value: Integer);
begin
  FUserID := Value;
end;

{ TpoGamerDeposits }

function TpoGamerDeposits.Add(nUserID, nSessionID: Integer;
  nAmount: Integer): TpoGamerDeposit;
begin
  Result:= TpoGamerDeposit.Create;
  Result.Amount:= nAmount;
  Result.SessionID:= nSessionID;
  Result.UserID:= nUserID;
  inherited Add(Result);
end;

constructor TpoGamerDeposits.Create;
begin
  inherited Create;
end;

destructor TpoGamerDeposits.Destroy;
begin
  inherited;
end;

function TpoGamerDeposits.GetItems(Index: Integer): TpoGamerDeposit;
begin
  Result:= inherited Items[Index] as TpoGamerDeposit;
end;

{ TpoApiSuspendedOperation }

constructor TpoApiSuspendedOperation.Create(aOwner: TpoApiSuspendedOperationList);
begin
  inherited Create;

  FOwner     := aOwner;
  FSessionID := UNDEFINED_SESSION_ID;
  FUserID    := UNDEFINED_USER_ID;
  FChairID   := UNDEFINED_POSITION_ID;
end;

procedure TpoApiSuspendedOperation.SetChairID(const Value: Integer);
begin
  FChairID := Value;
end;

procedure TpoApiSuspendedOperation.SetSessionID(const Value: Integer);
begin
  FSessionID := Value;
end;

procedure TpoApiSuspendedOperation.SetTypeOperation(const Value: TTypeApiSuspendedOperation);
begin
  FTypeOperation := Value;
end;

procedure TpoApiSuspendedOperation.SetUserID(const Value: Integer);
begin
  FUserID := Value;
end;

{ TpoApiSuspendedOperationList }

function TpoApiSuspendedOperationList.Add(aType: TTypeApiSuspendedOperation;
  nSessionID, nUserID, nChairID: Integer): TpoApiSuspendedOperation;
begin
  // for following only 1 must be exists
  Result := nil;
  case aType of
    SO_UpdateParticipantCount: Result := SearchByType(SO_UpdateParticipantCount);
  end;

  if Result <> nil then begin
    Result.FSessionID := nSessionID;
    Result.FUserID := nUserID;
    Result.FChairID := nChairID;
    Exit;
  end;

  Result := TpoApiSuspendedOperation.Create(Self);

  Result.FTypeOperation := aType;
  Result.FSessionID := nSessionID;
  Result.FUserID := nUserID;
  Result.FChairID := nChairID;

  inherited Add(Result as TObject);
end;

constructor TpoApiSuspendedOperationList.Create;
begin
  inherited Create;
end;

procedure TpoApiSuspendedOperationList.Del(aOperation: TpoApiSuspendedOperation);
begin
  inherited Remove(aOperation as TObject);
end;

destructor TpoApiSuspendedOperationList.Destroy;
begin
  Clear;
  inherited;
end;

function TpoApiSuspendedOperationList.GetItems(nIndex: Integer): TpoApiSuspendedOperation;
begin
  Result := TpoApiSuspendedOperation(inherited Items[nIndex]);
end;

function TpoApiSuspendedOperationList.SearchByType(aType: TTypeApiSuspendedOperation): TpoApiSuspendedOperation;
var
  aOper: TpoApiSuspendedOperation;
  I: Integer;
begin
  Result := nil;
  for I:=0 to Count - 1 do begin
    aOper := Items[I];
    if (aType = aOper.FTypeOperation) then begin
      Result := aOper;
      Exit;
    end;
  end;
end;

{ TpoTournayApiSuspendedOperation }

constructor TpoTournayApiSuspendedOperation.Create(aOwner: TpoTournayApiSuspendedOperationList);
begin
  inherited Create;
  FOwner := aOwner;
end;

procedure TpoTournayApiSuspendedOperation.SetComment(const Value: string);
begin
  FComment := Value;
end;

procedure TpoTournayApiSuspendedOperation.SetData(const Value: string);
begin
  FData := Value;
end;

procedure TpoTournayApiSuspendedOperation.SetHandID(const Value: Integer);
begin
  FHandID := Value;
end;

procedure TpoTournayApiSuspendedOperation.SetTypeOperation(const Value: TTypeTournayApiSuspendedOperation);
begin
  FTypeOperation := Value;
end;

{ TpoTournayApiSuspendedOperationList }

function TpoTournayApiSuspendedOperationList.Add(aType: TTypeTournayApiSuspendedOperation;
  nHandID: Integer; sData, sComment: string): TpoTournayApiSuspendedOperation;
begin
  // for following only 1 must be exists
  Result := nil;
  case aType of
    TSO_Prizes,
    TSO_ReInit: Result := SearchByType(aType);
  end;

  if Result <> nil then begin
    Result.FHandID := nHandID;
    Result.FData := sData;
    Result.FComment := sComment;
    Exit;
  end;

  Result := TpoTournayApiSuspendedOperation.Create(Self);

  Result.FTypeOperation := aType;
  Result.FHandID := nHandID;
  Result.FData := sData;
  Result.FComment := sComment;

  inherited Add(Result as TObject);
end;

procedure TpoTournayApiSuspendedOperationList.Del(aOperation: TpoTournayApiSuspendedOperation);
begin
  inherited Remove(aOperation as TObject);
end;

destructor TpoTournayApiSuspendedOperationList.Destroy;
begin
  Clear;
  inherited;
end;

function TpoTournayApiSuspendedOperationList.GetItems(nIndex: Integer): TpoTournayApiSuspendedOperation;
begin
  Result := TpoTournayApiSuspendedOperation(inherited Items[nIndex]);
end;

function TpoTournayApiSuspendedOperationList.SearchByType(aType: TTypeTournayApiSuspendedOperation): TpoTournayApiSuspendedOperation;
var
  I: Integer;
  aOper: TpoTournayApiSuspendedOperation;
begin
  Result := nil;
  for I:=0 to Count - 1 do begin
    aOper := Items[I];
    if (aOper.FTypeOperation = aType) then begin
      Result := aOper;
      Exit;
    end;
  end;
end;

{ TpoHandAndRakesSuspendedOperation }

constructor TpoHandAndRakesSuspendedOperation.Create(aOwner: TpoHandAndRakesSuspendedOperationList);
begin
  Inherited Create;
  FOwner := aOwner;
  FData  := TStringList.Create;
end;

destructor TpoHandAndRakesSuspendedOperation.Destroy;
begin
  FData.Clear;
  FData.Free;
  inherited;
end;

function TpoHandAndRakesSuspendedOperation.GetXMLAsString: string;
var
  I: Integer;
  sRootName: string;
begin
  Result := '';
  if FData.Count <= 0 then Exit;

  case FTypeOperation of
    HRSO_HandResult: sRootName := PPTN_END_OF_HAND;
    HRSO_UserRakes : sRootName := PPTN_USER_RAKES;
  end;

  Result :=
    '<' + sRootName + ' ' +
      PPTA_IS_RAKED + '="' + IntToStr(Integer(FIsRaked)) + '" ' +
      PPTA_HAND_ID  + '="' + IntToStr(FHandID) + '"' +
    '>';
  for I:=0 to FData.Count - 1 do begin
    Result := Result + FData.Strings[I];
  end;
  Result := Result + '</' + sRootName + '>';
end;

procedure TpoHandAndRakesSuspendedOperation.SetData(const Value: TStringList);
begin
  FData := Value;
end;

procedure TpoHandAndRakesSuspendedOperation.SetHandID(const Value: Integer);
begin
  FHandID := Value;
end;

procedure TpoHandAndRakesSuspendedOperation.SetIsRaked(const Value: Boolean);
begin
  FIsRaked := Value;
end;

procedure TpoHandAndRakesSuspendedOperation.SetTypeOperation(const Value: TTypeHandAndRakesSuspendedOperation);
begin
  FTypeOperation := Value;
end;

{ TpoHandAndRakesSuspendedOperationList }

function TpoHandAndRakesSuspendedOperationList.Add(aType: TTypeHandAndRakesSuspendedOperation;
  nHandID: Integer; sData: string; IsRaked: Boolean = False; sComment: string = ''
): TpoHandAndRakesSuspendedOperation;
begin
  Result := SearchByType(aType);
  if Result <> nil then begin
    Result.FHandID := nHandID;
    Result.FIsRaked := IsRaked;
    Result.FData.Add(sData);

    Exit;
  end;

  Result := TpoHandAndRakesSuspendedOperation.Create(Self);

  Result.FTypeOperation := aType;
  Result.FHandID := nHandID;
  Result.FIsRaked := IsRaked;
  Result.FData.Add(sData);

  inherited Add(Result as TObject);
end;

constructor TpoHandAndRakesSuspendedOperationList.Create;
begin
  inherited Create;
end;

procedure TpoHandAndRakesSuspendedOperationList.Del(aOperation: TpoHandAndRakesSuspendedOperation);
begin
  inherited Remove(aOperation as TObject);
end;

destructor TpoHandAndRakesSuspendedOperationList.Destroy;
begin
  Clear;
  inherited;
end;

function TpoHandAndRakesSuspendedOperationList.GetItems(nIndex: Integer): TpoHandAndRakesSuspendedOperation;
begin
  Result := inherited Items[nIndex] as TpoHandAndRakesSuspendedOperation;
end;

function TpoHandAndRakesSuspendedOperationList.SearchByType(aType: TTypeHandAndRakesSuspendedOperation): TpoHandAndRakesSuspendedOperation;
var
  I: Integer;
  aOper: TpoHandAndRakesSuspendedOperation;
begin
  Result := nil;
  for I:=0 to Count - 1 do begin
    aOper := Items[I];
    if aOper.FTypeOperation = aType then begin
      Result := aOper;
      Exit;
    end;
  end;
end;

{ TpoMoreChipsSuspendedOperation }

constructor TpoMoreChipsSuspendedOperation.Create(aOwner: TpoMoreChipsSuspendedOperationList);
begin
  Inherited Create;
  FOwner := aOwner;
end;

destructor TpoMoreChipsSuspendedOperation.Destroy;
begin
  inherited;
end;

procedure TpoMoreChipsSuspendedOperation.SetUserID(const Value: Integer);
begin
  FUserID := Value;
end;

{ TpoMoreChipsSuspendedOperationList }

function TpoMoreChipsSuspendedOperationList.Add(nUserID: Integer): TpoMoreChipsSuspendedOperation;
begin
  Result := SearchByUserID(nUserID);
  if Result <> nil then begin
    Exit;
  end;

  Result := TpoMoreChipsSuspendedOperation.Create(Self);
  Result.FUserID := nUserID;

  inherited Add(Result as TObject);
end;

constructor TpoMoreChipsSuspendedOperationList.Create;
begin
  inherited Create;
end;

procedure TpoMoreChipsSuspendedOperationList.Del(aOperation: TpoMoreChipsSuspendedOperation);
begin
  inherited Remove(aOperation as TObject);
end;

destructor TpoMoreChipsSuspendedOperationList.Destroy;
begin
  Clear;
  inherited;
end;

function TpoMoreChipsSuspendedOperationList.GetItems(nIndex: Integer): TpoMoreChipsSuspendedOperation;
begin
  Result := inherited Items[nIndex] as TpoMoreChipsSuspendedOperation;
end;

function TpoMoreChipsSuspendedOperationList.SearchByUserID(nUserID: Integer): TpoMoreChipsSuspendedOperation;
var
  I: Integer;
  aOper: TpoMoreChipsSuspendedOperation;
begin
  Result := nil;
  for I:=0 to Count - 1 do begin
    aOper := Items[I];
    if (aOper.FUserID = nUserID) then begin
      Result := aOper;
      Exit;
    end;
  end;
end;

initialization
  DecimalSeparator:= '.';


finalization

end.
