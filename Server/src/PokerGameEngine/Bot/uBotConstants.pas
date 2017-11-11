unit uBotConstants;

interface

uses XMLDoc, XMLIntF, XMLDom;

const
  TIME_OUT_FORSITDOWN  =  5; // seconds
  TIME_OUT_FORACTIVITY = 300; // seconds
  TIME_OUT_SLEEP_THREAD= 10;  // milli seconds

  COUNT_COL_CHAIRS   = 7;
  COUNT_COL_WATCHERS = 5;

  MIN_COUNT_ONBLAFFERS = 5;
  MAX_COUNT_ONBLAFFERS = 20;

  DELIMETER = ',';
  MAX_COUNT_CHAT = 5;

  NAME_FREE     = 'free';
  NAME_BUSY     = 'busy';
  NAME_RESERVED = 'reserved';
  NAME_HIDDEN   = 'hidden';

  NAME_PLAYING      = 'playing';
  NAME_SITOUT       = 'sitout';
  NAME_DISCONNECTED = 'disconnected';

  ACT_NAME_POSTSB         = 'postsb';
  ACT_NAME_POSTBB         = 'postbb';
  ACT_NAME_SITOUT         = 'sitout';
  ACT_NAME_BACK           = 'back';
  ACT_NAME_SITOUTNEXTHAND = 'sitoutnexthand';
  ACT_NAME_MORECHIPS      = 'morechips';
  ACT_NAME_ANTE           = 'ante';
  ACT_NAME_BRINGIN        = 'bringin';
  ACT_NAME_WAITBB         = 'waitbb';
  ACT_NAME_POST           = 'post';
  ACT_NAME_POSTDEAD       = 'postdead';
  ACT_NAME_FOLD           = 'fold';
  ACT_NAME_CHECK          = 'check';
  ACT_NAME_BET            = 'bet';
  ACT_NAME_CALL           = 'call';
  ACT_NAME_RAISE          = 'raise';
  ACT_NAME_DISCARD        = 'discardcards';
  ACT_NAME_SHOW           = 'showcards';
  ACT_NAME_SHOWSHUFFLED   = 'showcardsshuffled';
  ACT_NAME_DONTSHOW       = 'dontshow';
  ACT_NAME_MUCK           = 'muck';
  ACT_NAME_LEAVETABLE     = 'leavetable';
  ACT_NAME_SITDOWN        = 'sitdown';
  ACT_NAME_ENTRY          = 'entry';
  ACT_NAME_DISCONNECT     = 'disconnect';
  ACT_NAME_RECONNECT      = 'reconnect';
  ACT_NAME_UNKNOWN        = '';

  NODE_GACRASH         = 'gacrash';
  NODE_PROCINIT        = 'procinit';
  NODE_PROCSTATE       = 'procstate';
  NODE_SETACTIVEPLAYER = 'setactiveplayer';
  NODE_PROCCLOSE       = 'procclose';
  NODE_ACTION          = 'action';
  NODE_CHAIR           = 'chair';
  NODE_CHAIRS          = 'chairs';
  NODE_CHAT            = 'chat';
  NODE_MESSAGE         = 'message';
  NODE_RANKING         = 'ranking';
  NODE_DIALCARDS       = 'dealcards';
  NODE_DIAL            = 'deal';
  NODE_MOVEBETS        = 'movebets';
  NODE_MOVE            = 'move';
  NODE_NEWBALANCE      = 'newbalance';
  NODE_ENDROUND        = 'endround';
  NODE_FINISHHAND      = 'finishhand';
  NODE_TOURNAMENT      = 'tournament';
  NODE_ACTIONS         = 'actions';
  NODE_GA_ACTION       = 'gaaction';
  // procinit collection node names
  NODE_GE_VERSION      = 'geversion';
  NODE_NAME            = 'name';
  NODE_POKERTYPE       = 'pokertype';
  NODE_PLAYERCOUNT     = 'playercount';
  NODE_CURRENCYID      = 'currencyid';
  NODE_CURRENCYSIGN    = 'currencysign';
  NODE_STAKETYPE       = 'staketype';
  NODE_ALLIN           = 'allin';
  NODE_MAXBUYIN        = 'maxbuyin';
  NODE_MINBUYIN        = 'minbuyin';
  NODE_DEFBUYIN        = 'defbuyin';
  NODE_ISTOURNAMENT    = 'istournament';
  // procstate collection node names
  NODE_COMMUNITYCARDS  = 'communitycards';
  NODE_POTS            = 'pots';
  NODE_RAKE            = 'rake';
  NODE_PLAYER          = 'player';
  // finish hand collection node names
  NODE_FINALPOT        = 'finalpot';
  NODE_POT             = 'pot';
  NODE_WINNER          = 'winner';

  ATTR_PROCESSID     = 'processid';
  ATTR_SEQ_GAHANDID  = 'seq_gahandid';
  ATTR_SEQ_GAROUND   = 'seq_garound';
  ATTR_NAME          = 'name';
  ATTR_POSITION      = 'position';
  ATTR_STAKE         = 'stake';
  ATTR_MINSTAKE      = 'minstake';
  ATTR_MAXSTAKE      = 'maxstake';
  ATTR_DEAD          = 'dead';
  ATTR_AMOUNT        = 'amount';
  ATTR_CARDS         = 'cards';
  ATTR_VALUE         = 'value';
  ATTR_TIMEBANK      = 'timebank';
  ATTR_TURNTIME      = 'turntime';
  ATTR_BET           = 'bet';
  ATTR_BALANCE       = 'balance';
  ATTR_HANDID        = 'handid';
  ATTR_ROUND         = 'round';
  ATTR_PREVHANDID    = 'prevhandid';
  ATTR_RAKE          = 'rake';
  ATTR_BUYIN         = 'buyin';
  ATTR_CHIPS         = 'chips';
  ATTR_ID            = 'id';
  ATTR_ISDEALER      = 'isdealer';
  ATTR_STATUS        = 'status';
  ATTR_INGAME        = 'ingame';
  ATTR_CARDSPOSITION = 'cardsposition';
  ATTR_POTID         = 'potid';
  ATTR_NEWBALANCE    = 'newbalance';
  // chat collection attributes
  ATTR_SRC           = 'src';
  ATTR_PRIORITY      = 'priority';
  ATTR_MSG           = 'msg';
  ATTR_USERID        = 'userid';
  ATTR_USERNAME      = 'username';

type
  TFixCardSuit = (CS_CLUB, CS_DIAMOND, CS_HEART, CS_SPADE, CS_UNKNOWN);

  TFixCardValue = (//ordered by desc. range
    CV_2, CV_3, CV_4, CV_5, CV_6, CV_7, CV_8, CV_9, CV_10,
    CV_JACK, CV_QUEEN, CV_KING, CV_ACE, CV_UNKNOWN
  );

  TFixGameQualify = (PQ_RANDOM, PQ_AUTOMAT, PQ_CHEATER);
  TFixUserCharacter = (UCH_CAUTIOUS, UCH_NORMAL, UCH_AGGRESSIVE);

  TFixChairState = (CHS_FREE, CHS_BUSY, CHS_RESERVED, CHS_HIDDEN);

  TFixGameType = (
    GT_TEXAS, GT_OMAHA, GT_OMAHA_HL, GT_SEVEN, GT_SEVEN_HL,
    GT_FIVE_DRAW, GT_FIVE_STUD, GT_CRAZY_PIN
  );

  TFixStakeType = (BST_FIX_LIMIT, BST_NO_LIMIT, BST_POTLIMIT);

  TFixTournamentType = (TT_NO, TT_SINGLE, TT_MULTY);

  TFixUserState = (US_PLAYING, US_SITOUT, US_DISCONNECTED);

  TFixAction = ( //sort by value of money
    ACT_FOLD, ACT_CHECK, ACT_WAITBB, ACT_POSTDEAD, ACT_POSTSB, ACT_POSTBB, ACT_ANTE,
    ACT_BRINGIN, ACT_CALL, ACT_POST, ACT_BET, ACT_RAISE,
    ACT_DISCARD, ACT_SHOW, ACT_SHOWSHUFFLED, ACT_MUCK, ACT_DONTSHOW,
    // not set active player actions
    ACT_SITOUT, ACT_BACK, ACT_SITOUTNEXTHAND, ACT_MORECHIPS,
    ACT_LEAVETABLE, ACT_SITDOWN, ACT_ENTRY, ACT_DISCONNECT, ACT_RECONNECT,
    ACT_UNKNOWN
  );

  TFixActionSet = set of TFixAction;

  TFixChat = (Chat0, Chat1, Chat2);
  TFixChatSet = set of TFixChat;

  TFixProcInitStatus  = (PIS_NEEDREQUEST, PIS_WAITRESPONSE, PIS_RESPONSED);
  TFixProcStateStatus = (PSS_NEEDREQUEST, PSS_WAITRESPONSE, PSS_RESPONSED);

  TFixVisualizationType = (
    VST_NONE, VST_GACRASH, VST_PROCCLOSE, VST_PROCINIT, VST_PROCSTATE, VST_COMMUNITYCARDS,
    VST_POTS, VST_RAKE, VST_CHAIR, VST_SETACTIVEPLAYER, VST_ACTION,
    VST_CHAT, VST_RANKING, VST_DEALCARDS, VST_DEAL, VST_MOVEBETS,
    VST_ENDROUND, VST_FINISHHAND, VST_WINNER, VST_MESSAGE, VST_TOURNAMENT
  );

  function GetFixCardSuitAsString(aSuit: TFixCardSuit): string;
  function GetFixCardValueAsString(aValue: TFixCardValue): string;
  function GetFixChairStateAsString(aValue: TFixChairState): string;
  function GetFixGameTypeAsString(aValue: TFixGameType): string;
  function GetFixGameStakeTypeAsString(aValue: TFixStakeType): string;
  function GetFixTournamentAsString(aValue: TFixTournamentType): string;
  function GetFixUserStateAsString(aValue: TFixUserState): string;
  function GetFixActionAsString(aValue: TFixAction): string;
  function GetFixGameQualifyAsString(aValue: TFixGameQualify): string;
  function GetFixVisualizationTypeAsString(aValue: TFixVisualizationType): string;
  function GetFixVisualizationTypeByNode(aNode: IXMLNode): TFixVisualizationType;
  function GetFixUserCharacter(aValue: TFixUserCharacter): string;
  function GetFixProcInitStatusAsString(aValue: TFixProcInitStatus): string;
  function GetFixProcStateStatusAsString(aValue: TFixProcStateStatus): string;
  //
  function GetCurrencyAttrAsInteger(aNode: IXMLNode; sAttrName: string): Integer;
  // get xml node as string for any action
  function GetGaActionOpenNodeAsString(ProcessID: Integer): string;
  function GetGaActionCloseNodeAsString: string;
  function GetActionNodeAsString(sName: string; HandID: Integer;
    Position: Integer = -1; Amount: Integer = -1; Stake: Integer = -1;
    Dead: Integer = -1; Value: Integer = -1; sCards: string = ''
  ): string;
  function GetProcInitNodeAsString: string;
  function GetProcStateNodeAsString: string;

implementation

uses SysUtils;

function GetFixCardSuitAsString(aSuit: TFixCardSuit): string;
begin
  case aSuit of
    CS_CLUB   : Result := 'c';
    CS_DIAMOND: Result := 'd';
    CS_HEART  : Result := 'h';
    CS_SPADE  : Result := 's';
  else
    Result := '';
  end;
end;

function GetFixCardValueAsString(aValue: TFixCardValue): string;
begin
  case aValue of
    CV_2: Result := '2';
    CV_3: Result := '3';
    CV_4: Result := '4';
    CV_5: Result := '5';
    CV_6: Result := '6';
    CV_7: Result := '7';
    CV_8: Result := '8';
    CV_9: Result := '9';
    CV_10   : Result := 'T';
    CV_JACK : Result := 'J';
    CV_QUEEN: Result := 'Q';
    CV_KING : Result := 'K';
    CV_ACE  : Result := 'A';
  else
    Result := '';
  end;
end;

function GetFixChairStateAsString(aValue: TFixChairState): string;
begin
  case aValue of
    CHS_FREE    : Result := NAME_FREE;
    CHS_BUSY    : Result := NAME_BUSY;
    CHS_RESERVED: Result := NAME_RESERVED;
    CHS_HIDDEN  : Result := NAME_HIDDEN;
  else
    Result := '';
  end;
end;

function GetFixGameTypeAsString(aValue: TFixGameType): string;
begin
  case aValue of
    GT_TEXAS    : Result := 'Texas Hold''em';
    GT_OMAHA    : Result := 'Omaha';
    GT_OMAHA_HL : Result := 'Omaha Hi/Low';
    GT_SEVEN    : Result := 'Seven Stud';
    GT_SEVEN_HL : Result := 'Seven Stud Hi/Low';
    GT_FIVE_DRAW: Result := 'Five Card Draw';
    GT_FIVE_STUD: Result := 'Five Card Stud';
    GT_CRAZY_PIN: Result := 'Crazy Pineapple';
  else
    Result := '';
  end;
end;

function GetFixGameStakeTypeAsString(aValue: TFixStakeType): string;
begin
  case aValue of
    BST_FIX_LIMIT: Result := 'Fixed Limit';
    BST_NO_LIMIT : Result := 'No Limit';
    BST_POTLIMIT : Result := 'Pot Limit';
  else
    Result := '';
  end;
end;

function GetFixTournamentAsString(aValue: TFixTournamentType): string;
begin
  case aValue of
    TT_NO    : Result := 'No Tournament';
    TT_SINGLE: Result := 'Single Tournament';
    TT_MULTY : Result := 'Multy Tournament';
  else
    Result := '';
  end;
end;

function GetFixUserStateAsString(aValue: TFixUserState): string;
begin
  case aValue of
    US_PLAYING      : Result := NAME_PLAYING;
    US_SITOUT       : Result := NAME_SITOUT;
    US_DISCONNECTED : Result := NAME_DISCONNECTED;
  else
    Result := '';
  end;
end;

function GetFixActionAsString(aValue: TFixAction): string;
begin
  case aValue of
    ACT_POSTSB        : Result := ACT_NAME_POSTSB;
    ACT_POSTBB        : Result := ACT_NAME_POSTBB;
    ACT_SITOUT        : Result := ACT_NAME_SITOUT;
    ACT_SITOUTNEXTHAND: Result := ACT_NAME_SITOUTNEXTHAND;
    ACT_MORECHIPS     : Result := ACT_NAME_MORECHIPS;
    ACT_LEAVETABLE    : Result := ACT_NAME_LEAVETABLE;
    ACT_SITDOWN       : Result := ACT_NAME_SITDOWN;
    ACT_ENTRY         : Result := ACT_NAME_ENTRY;
    ACT_DISCONNECT    : Result := ACT_NAME_DISCONNECT;
    ACT_RECONNECT     : Result := ACT_NAME_RECONNECT;
    ACT_ANTE          : Result := ACT_NAME_ANTE;
    ACT_BRINGIN       : Result := ACT_NAME_BRINGIN;
    ACT_WAITBB        : Result := ACT_NAME_WAITBB;
    ACT_POST          : Result := ACT_NAME_POST;
    ACT_POSTDEAD      : Result := ACT_NAME_POSTDEAD;
    ACT_FOLD          : Result := ACT_NAME_FOLD;
    ACT_CHECK         : Result := ACT_NAME_CHECK;
    ACT_BET           : Result := ACT_NAME_BET;
    ACT_CALL          : Result := ACT_NAME_CALL;
    ACT_RAISE         : Result := ACT_NAME_RAISE;
    ACT_DISCARD       : Result := ACT_NAME_DISCARD;
    ACT_SHOW          : Result := ACT_NAME_SHOW;
    ACT_SHOWSHUFFLED  : Result := ACT_NAME_SHOWSHUFFLED;
    ACT_MUCK          : Result := ACT_NAME_MUCK;
    ACT_DONTSHOW      : Result := ACT_NAME_DONTSHOW;
  else
    Result := ACT_NAME_UNKNOWN;
  end
end;

function GetCurrencyAttrAsInteger(aNode: IXMLNode; sAttrName: string): Integer;
var
  nCurrVal: Currency;
begin
//******************************************
// result = -1 correspond to undefined value
//******************************************
  Result := -1;
  if aNode.HasAttribute(sAttrName) then begin
    nCurrVal := StrToCurrDef(aNode.Attributes[sAttrName], -1);
    if (nCurrVal > 0) then begin
      Result := Trunc(nCurrVal * 100); // translate to cents
    end;
  end;
end;

function GetFixGameQualifyAsString(aValue: TFixGameQualify): string;
begin
  case aValue of
    PQ_RANDOM : Result := 'Random';
    PQ_AUTOMAT: Result := 'Compute';
    PQ_CHEATER: Result := 'Cheater';
  else
    Result := '';
  end;
end;

function GetFixVisualizationTypeAsString(aValue: TFixVisualizationType): string;
begin
  case aValue of
    VST_GACRASH        : Result := NODE_GACRASH;
    VST_PROCCLOSE      : Result := NODE_PROCCLOSE;
    VST_PROCINIT       : Result := NODE_PROCINIT;
    VST_PROCSTATE      : Result := NODE_PROCSTATE;
    VST_COMMUNITYCARDS : Result := NODE_COMMUNITYCARDS;
    VST_POTS           : Result := NODE_POTS;
    VST_RAKE           : Result := NODE_RAKE;
    VST_CHAIR          : Result := NODE_CHAIR;
    VST_SETACTIVEPLAYER: Result := NODE_SETACTIVEPLAYER;
    VST_ACTION         : Result := NODE_ACTION;
    VST_CHAT           : Result := NODE_CHAT;
    VST_RANKING        : Result := NODE_RANKING;
    VST_DEALCARDS      : Result := NODE_DIALCARDS;
    VST_DEAL           : Result := NODE_DIAL;
    VST_MOVEBETS       : Result := NODE_MOVEBETS;
    VST_ENDROUND       : Result := NODE_ENDROUND;
    VST_FINISHHAND     : Result := NODE_FINISHHAND;
    VST_WINNER         : Result := NODE_WINNER;
    VST_MESSAGE        : Result := NODE_MESSAGE;
    VST_TOURNAMENT     : Result := NODE_TOURNAMENT;
  else
    Result := 'uncknown';
  end;
end;

function GetFixVisualizationTypeByNode(aNode: IXMLNode): TFixVisualizationType;
begin
  Result := VST_NONE;
  if (aNode = nil) then Exit;

  if (aNode.NodeName = NODE_GACRASH         ) then Result := VST_GACRASH         else
  if (aNode.NodeName = NODE_PROCCLOSE       ) then Result := VST_PROCCLOSE       else
  if (aNode.NodeName = NODE_PROCINIT        ) then Result := VST_PROCINIT        else
  if (aNode.NodeName = NODE_PROCSTATE       ) then Result := VST_PROCSTATE       else
  if (aNode.NodeName = NODE_COMMUNITYCARDS  ) then Result := VST_COMMUNITYCARDS  else
  if (aNode.NodeName = NODE_POTS            ) then Result := VST_POTS            else
  if (aNode.NodeName = NODE_RAKE            ) then Result := VST_RAKE            else
  if (aNode.NodeName = NODE_CHAIR           ) then Result := VST_CHAIR           else
  if (aNode.NodeName = NODE_SETACTIVEPLAYER ) then Result := VST_SETACTIVEPLAYER else
  if (aNode.NodeName = NODE_ACTION          ) then Result := VST_ACTION          else
  if (aNode.NodeName = NODE_CHAT            ) then Result := VST_CHAT            else
  if (aNode.NodeName = NODE_RANKING         ) then Result := VST_RANKING         else
  if (aNode.NodeName = NODE_DIALCARDS       ) then Result := VST_DEALCARDS       else
  if (aNode.NodeName = NODE_DIAL            ) then Result := VST_DEAL            else
  if (aNode.NodeName = NODE_MOVEBETS        ) then Result := VST_MOVEBETS        else
  if (aNode.NodeName = NODE_ENDROUND        ) then Result := VST_ENDROUND        else
  if (aNode.NodeName = NODE_FINISHHAND      ) then Result := VST_FINISHHAND      else
  if (aNode.NodeName = NODE_WINNER          ) then Result := VST_WINNER          else
  if (aNode.NodeName = NODE_MESSAGE         ) then Result := VST_MESSAGE         else
  if (aNode.NodeName = NODE_TOURNAMENT      ) then Result := VST_TOURNAMENT;
end;

function GetFixProcInitStatusAsString(aValue: TFixProcInitStatus): string;
begin
  case aValue of
    PIS_NEEDREQUEST : Result := 'Need request';
    PIS_WAITRESPONSE: Result := 'Wait response';
    PIS_RESPONSED   : Result := 'Responsed';
  else
    Result := '';
  end;
end;

function GetFixProcStateStatusAsString(aValue: TFixProcStateStatus): string;
begin
  case aValue of
    PSS_NEEDREQUEST : Result := 'Need request';
    PSS_WAITRESPONSE: Result := 'Wait response';
    PSS_RESPONSED   : Result := 'Responsed';
  else
    Result := '';
  end;
end;

function GetFixUserCharacter(aValue: TFixUserCharacter): string;
begin
  case aValue of
    UCH_CAUTIOUS   : Result := 'Cautious';
    UCH_NORMAL     : Result := 'Normal';
    UCH_AGGRESSIVE : Result := 'Aggressive';
  else
    Result := '';
  end;
end;

function GetGaActionOpenNodeAsString(ProcessID: Integer): string;
begin
  Result := '<' + NODE_GA_ACTION + ' ' + ATTR_PROCESSID + '="' + IntToStr(ProcessID) + '">';
end;

function GetGaActionCloseNodeAsString: string;
begin
  Result := '</' + NODE_GA_ACTION + '>';
end;

function GetActionNodeAsString(sName: string; HandID,
  Position, Amount, Stake, Dead, Value: Integer; sCards: string): string;
begin
  Result :=
    '<' + NODE_ACTION + ' ' + ATTR_NAME + '="' + LowerCase(sName) + '" ' +
      ATTR_HANDID + '="' + IntToStr(HandID) + '"';

  if Position >= 0 then
    Result := Result + ' ' + ATTR_POSITION + '="' + IntToStr(Position) + '"';
  if Amount >= 0 then
    Result := Result + ' ' + ATTR_AMOUNT + '="' + CurrToStr(Amount / 100) + '"';
  if Stake >= 0 then
    Result := Result + ' ' + ATTR_STAKE + '="' + CurrToStr(Stake / 100) + '"';
  if Dead  >= 0 then
    Result := Result + ' ' + ATTR_DEAD + '="' + CurrToStr(Dead / 100) + '"';
  if Value >= 0 then
    Result := Result + ' ' + ATTR_VALUE + '="' + IntToStr(Value) + '"';
  if sCards <> '' then
    Result := Result + ' ' + ATTR_CARDS + '="' + sCards + '"';

  Result := Result + '/>';
end;

function GetProcInitNodeAsString: string;
begin
  Result := '<' + NODE_PROCINIT + '/>';
end;

function GetProcStateNodeAsString: string;
begin
  Result := '<' + NODE_PROCSTATE + '/>';
end;

end.
