unit uBotClasses;

interface

uses Contnrs, XMLDoc, XMLIntF, XMLDom, Classes
  //SDK
  , uBotConstants
//  , uBotActions
  //System
  , uPokerBase
  , uPokerGameEngine
  ;

type

//******************************************************
// All Available Answer
//******************************************************
  TBotAvailableAnswerList = class;

  TBotAvailableAnswer = class
  private
    FMaxStake: Integer;
    FStake: Integer;
    FDead: Integer;
    FAnswerType: TFixAction;
    FOwner: TBotAvailableAnswerList;
    FTag: Integer;
    procedure SetAnswerType(const Value: TFixAction);
    procedure SetMaxStake(const Value: Integer);
    procedure SetStake(const Value: Integer);
    procedure SetDead(const Value: Integer);
    procedure SetTag(const Value: Integer);
    function GetName: string;
  public
    property AnswerType: TFixAction read FAnswerType write SetAnswerType;
    property Stake: Integer read FStake write SetStake;          // in cents
    property MaxStake: Integer read FMaxStake write SetMaxStake; // in cents
    property Dead: Integer read FDead write SetDead;             // in cents
    property Tag: Integer read FTag write SetTag;
    //
    property Name: string read GetName;
    property Owner: TBotAvailableAnswerList read FOwner;
    //
    procedure SetContextByAnswer(aAnswer: TBotAvailableAnswer);
    //
    constructor Create(aNodeAction: IXMLNode = nil; aOwner: TBotAvailableAnswerList = nil);

    destructor Destroy; override;
  end;

  TBotAvailableAnswerList = class(TObjectList)
  private
    function GetItems(nIndex: Integer): TBotAvailableAnswer;
    procedure Swap(nIndBeg, nIndEnd: Integer);
  public
    property Items[nIndex: Integer]: TBotAvailableAnswer read GetItems;
    //
    function Add(aAnswer: TBotAvailableAnswer): TBotAvailableAnswer;
    function Ins(nIndex: Integer; aAnswer: TBotAvailableAnswer): TBotAvailableAnswer;
    procedure Del(aAnswer: TBotAvailableAnswer);
    procedure DelByInd(nIndex: Integer);
    //
    function AddByNode(aNode: IXMLNode): TBotAvailableAnswer;
    function InsByNode(nIndex: Integer; aNode: IXMLNode): TBotAvailableAnswer;
    procedure ReInitializeBySetActivePlayer(aNode: IXMLNode);
    procedure SetContextByAnswers(aAnswers: TBotAvailableAnswerList);
    procedure SortByActionType;
    //
    function FindAnswerType(aAnsverType: TFixAction): TBotAvailableAnswer;
    function GetHighAnswer: TBotAvailableAnswer;
    function GetMidleAnswer: TBotAvailableAnswer;
    function GetLowAnswer: TBotAvailableAnswer;
    function GetNames: string;
    //
    function IndexByType(aAnswerType: TFixAction): Integer;
    //
    constructor Create; overload;
    constructor Create(aGamerActions: TpoGamerActions); overload;



    destructor Destroy; override;
  end;

//******************************************************
// Bot Predeclaration type block
//******************************************************
  TBotTable = class;
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
    constructor Create;
    destructor Destroy; override;
  end;

//******************************************************
// Bot Table type block
//******************************************************
  TBotTable = class
  public
    Cards     : TBotCardList;
    Round     : Integer;
    Users     : TBotUserList;
    GameType  : TFixGameType;
    StakeType : TFixStakeType;

    constructor Create(XMLSetActivePlayerNode: IXMLNode; aBasicGameEngine: TpoBasicGameEngine; nActiveUserID: Integer);
    destructor  Destroy; override;
  end;

//******************************************************
// Bot users type declaration block
//******************************************************

  TBotUser = class
  public
    AvailableAnwers   : TBotAvailableAnswerList;
    Cards             : TBotCardList;
    IsBot             : Boolean;
    IsWatcher         : Boolean;
    InGame            : Integer;
    BlaffersEvent     : Integer;
    Character         : TFixUserCharacter;
    CountOfRases      : Integer;

    constructor Create(XMLSetActivePlayerNode: IXMLNode; aGamer: TpoGamer);
    destructor Destroy; override;
  end;


  TBotUserList = class(TObjectList)
  private
    function GetItems(nIndex: Integer): TBotUser;
  public
    property Items[nIndex: Integer]: TBotUser read GetItems;

    function Add(User: TBotUser): TBotUser;

    constructor Create();
  end;


implementation

uses SysUtils, DateUtils, Math, StrUtils
  //
  , uResponseProcessor;

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
      '2': FValue := uBotConstants.CV_2;
      '3': FValue := uBotConstants.CV_3;
      '4': FValue := uBotConstants.CV_4;
      '5': FValue := uBotConstants.CV_5;
      '6': FValue := uBotConstants.CV_6;
      '7': FValue := uBotConstants.CV_7;
      '8': FValue := uBotConstants.CV_8;
      '9': FValue := uBotConstants.CV_9;
      'T': FValue := uBotConstants.CV_10;
      'J': FValue := uBotConstants.CV_JACK;
      'Q': FValue := uBotConstants.CV_QUEEN;
      'K': FValue := uBotConstants.CV_KING;
      'A': FValue := uBotConstants.CV_ACE;
    end;

    // set card suit
    case TempName[2] of
      'C': FSuit := uBotConstants.CS_CLUB;
      'D': FSuit := uBotConstants.CS_DIAMOND;
      'H': FSuit := uBotConstants.CS_HEART;
      'S': FSuit := uBotConstants.CS_SPADE;
    end;

    FOpen := True;
  end else begin
    FSuit  := uBotConstants.CS_UNKNOWN;
    FValue := uBotConstants.CV_UNKNOWN;
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

{ TBotUserList }
function TBotUserList.Add(User: TBotUser): TBotUser;
var
  nIndx: Integer;
begin
  Result:= nil;
  nIndx:= inherited Add(User);
  if (nIndx <> -1) then Result:= User;
end;

constructor TBotUserList.Create;
begin
  inherited Create(True);
end;

function TBotUserList.GetItems(nIndex: Integer): TBotUser;
begin
  Result := inherited Items[nIndex] as TBotUser;
end;

{ TBotTable }

constructor TBotTable.Create(XMLSetActivePlayerNode: IXMLNode; aBasicGameEngine: TpoBasicGameEngine; nActiveUserID: Integer);
var
  nIndx: Integer;
  aGamer: TpoGamer;
begin
  inherited Create();

  GameType := TFixGameType(Integer(aBasicGameEngine.Croupier.PokerType) - 1);
  StakeType := TFixStakeType(Integer(aBasicGameEngine.Croupier.StakeType) - 1);
  Round    := aBasicGameEngine.Table.Hand.RoundID;

  Cards:= TBotCardList.Create();
  if not Assigned(Cards) then raise Exception.Create('Error creating cards list');
  Cards.SetContextByNames(aBasicGameEngine.Table.Hand.CommunityCards.FormSeries(False));

  Users:= TBotUserList.Create();
  if not Assigned(Users) then raise Exception.Create('Error creating users list');

  for nIndx:= 0 to (aBasicGameEngine.Table.Chairs.Count-1) do begin
    aGamer := aBasicGameEngine.Table.Chairs[nIndx].Gamer;
    if (aGamer = nil) or (aGamer.Cards.Count = 0) then Continue;
    if (nActiveUserID = aGamer.UserID) then Continue;
{      Users.Add(TBotUser.Create(XMLSetActivePlayerNode, aGamer));
      Continue;
    end;}

    Users.Add(TBotUser.Create(nil, aGamer));
  end;
end;

destructor TBotTable.Destroy;
begin
  Users.Free;
  Cards.Free;
  inherited;
end;

{ TBotUser }

constructor TBotUser.Create(XMLSetActivePlayerNode: IXMLNode; aGamer: TpoGamer);
begin
  inherited Create();

  Cards:= TBotCardList.Create();
  Cards.SetContextByNames(aGamer.Cards.FormSeries(True));

  IsBot     := aGamer.IsBot;
  IsWatcher := ((aGamer.UserID <= 0) or (aGamer.ChairID < 0));
  InGame    := Integer((aGamer.State = GS_PLAYING) and not aGamer.PassCurrentHand);
  BlaffersEvent := aGamer.BotBlaffersEvent;
  CountOfRases  := aGamer.CountOfRases;

  AvailableAnwers:= TBotAvailableAnswerList.Create;
  if not Assigned(AvailableAnwers) then raise Exception.Create('Error creating User Available Anwers list');

  AvailableAnwers.ReInitializeBySetActivePlayer(XMLSetActivePlayerNode);

  { TODO 5 -oLex -cTweak : add to game engine following properties }
  (*
  //- In Game Engine: BlaffersEvent: Integer;
  //- In Game Engine: Character: TFixUserCharacter;
  BlaffersEvent:= aGamer.BlaffersEvent;
  Character:= aGamer.Character;
  *)
end;

destructor TBotUser.Destroy;
begin
  Cards.Free;
  AvailableAnwers.Free;
  inherited;
end;

{ TBotAvailableAnswer }

constructor TBotAvailableAnswer.Create(aNodeAction: IXMLNode; aOwner: TBotAvailableAnswerList);
var
  sActName: string;
begin
  inherited Create;

  FOwner := aOwner;

  { initial values }
  FTag   := 0;
  AnswerType := ACT_UNKNOWN;
  FStake    := -1;
  FMaxStake := -1;
  FDead     := -1;

  if (aNodeAction = nil) then Exit;

  { real values }
  sActName := aNodeAction.NodeName;
  if (sActName = ACT_NAME_POSTSB        ) then AnswerType := ACT_POSTSB         else
  if (sActName = ACT_NAME_POSTBB        ) then AnswerType := ACT_POSTBB         else
  if (sActName = ACT_NAME_SITOUT        ) then AnswerType := ACT_SITOUT         else
  if (sActName = ACT_NAME_BACK          ) then AnswerType := ACT_BACK           else
  if (sActName = ACT_NAME_SITOUTNEXTHAND) then AnswerType := ACT_SITOUTNEXTHAND else
  if (sActName = ACT_NAME_MORECHIPS     ) then AnswerType := ACT_MORECHIPS      else
  if (sActName = ACT_NAME_LEAVETABLE    ) then AnswerType := ACT_LEAVETABLE     else
  if (sActName = ACT_NAME_SITDOWN       ) then AnswerType := ACT_SITDOWN        else
  if (sActName = ACT_NAME_ENTRY         ) then AnswerType := ACT_ENTRY          else
  if (sActName = ACT_NAME_DISCONNECT    ) then AnswerType := ACT_DISCONNECT     else
  if (sActName = ACT_NAME_RECONNECT     ) then AnswerType := ACT_RECONNECT      else
  if (sActName = ACT_NAME_ANTE          ) then AnswerType := ACT_ANTE           else
  if (sActName = ACT_NAME_BRINGIN       ) then AnswerType := ACT_BRINGIN        else
  if (sActName = ACT_NAME_WAITBB        ) then AnswerType := ACT_WAITBB         else
  if (sActName = ACT_NAME_POST          ) then AnswerType := ACT_POST           else
  if (sActName = ACT_NAME_POSTDEAD      ) then AnswerType := ACT_POSTDEAD       else
  if (sActName = ACT_NAME_FOLD          ) then AnswerType := ACT_FOLD           else
  if (sActName = ACT_NAME_CHECK         ) then AnswerType := ACT_CHECK          else
  if (sActName = ACT_NAME_BET           ) then AnswerType := ACT_BET            else
  if (sActName = ACT_NAME_CALL          ) then AnswerType := ACT_CALL           else
  if (sActName = ACT_NAME_RAISE         ) then AnswerType := ACT_RAISE          else
  if (sActName = ACT_NAME_DISCARD       ) then AnswerType := ACT_DISCARD        else
  if (sActName = ACT_NAME_SHOW          ) then AnswerType := ACT_SHOW           else
  if (sActName = ACT_NAME_SHOWSHUFFLED  ) then AnswerType := ACT_SHOWSHUFFLED   else
  if (sActName = ACT_NAME_DONTSHOW      ) then AnswerType := ACT_DONTSHOW       else
  if (sActName = ACT_NAME_MUCK          ) then AnswerType := ACT_MUCK           else
    AnswerType := ACT_UNKNOWN;

  FStake    := GetCurrencyAttrAsInteger(aNodeAction, ATTR_STAKE);
  FMaxStake := GetCurrencyAttrAsInteger(aNodeAction, ATTR_MAXSTAKE);
  FDead     := GetCurrencyAttrAsInteger(aNodeAction, ATTR_DEAD);
end;

destructor TBotAvailableAnswer.Destroy;
begin
  //
  inherited;
end;

function TBotAvailableAnswer.GetName: string;
begin
  Result := GetFixActionAsString(FAnswerType);
end;

procedure TBotAvailableAnswer.SetAnswerType(const Value: TFixAction);
begin
  FAnswerType := Value;
end;

procedure TBotAvailableAnswer.SetContextByAnswer(aAnswer: TBotAvailableAnswer);
begin
  FMaxStake   := aAnswer.FMaxStake;
  FStake      := aAnswer.FStake;
  FDead       := aAnswer.FDead;
  FAnswerType := aAnswer.FAnswerType;
end;

procedure TBotAvailableAnswer.SetDead(const Value: Integer);
begin
  FDead := Value;
end;

procedure TBotAvailableAnswer.SetMaxStake(const Value: Integer);
begin
  FMaxStake := Value;
end;

procedure TBotAvailableAnswer.SetStake(const Value: Integer);
begin
  FStake := Value;
end;

procedure TBotAvailableAnswer.SetTag(const Value: Integer);
begin
  FTag := Value;
end;

{ TBotAvailableAnswerList }

function TBotAvailableAnswerList.Add(
  aAnswer: TBotAvailableAnswer): TBotAvailableAnswer;
begin
  Result := aAnswer;
  Result.FOwner := Self;
  inherited Add(Result);
end;

function TBotAvailableAnswerList.AddByNode(aNode: IXMLNode): TBotAvailableAnswer;
begin
  Result := TBotAvailableAnswer.Create(aNode, Self);
  Add(Result);
end;

constructor TBotAvailableAnswerList.Create;
begin
  inherited Create;
end;

constructor TBotAvailableAnswerList.Create(aGamerActions: TpoGamerActions);

  procedure AddIfInSet(Action: TpoGamerAction; AnswerType: TFixAction);
  var
    Answer: TBotAvailableAnswer;
  begin
    if not (Action in aGamerActions) then Exit;

    Answer:= TBotAvailableAnswer.Create(nil, self);
    Answer.AnswerType:= AnswerType;

    Add(Answer);
  end;

begin
  inherited Create;

  AddIfInSet(GA_POST_SB, ACT_POSTSB);
  AddIfInSet(GA_POST_BB, ACT_POSTBB);
  AddIfInSet(GA_SIT_OUT, ACT_SITOUT);
  AddIfInSet(GA_BACK, ACT_BACK);
  AddIfInSet(GA_LEAVE_TABLE, ACT_LEAVETABLE);
  AddIfInSet(GA_ANTE, ACT_ANTE);
  AddIfInSet(GA_BRING_IN, ACT_BRINGIN);
  AddIfInSet(GA_WAIT_BB, ACT_WAITBB);
  AddIfInSet(GA_POST, ACT_POST);
  AddIfInSet(GA_POST_DEAD, ACT_POSTDEAD);
  AddIfInSet(GA_FOLD, ACT_FOLD);
  AddIfInSet(GA_CHECK, ACT_CHECK);
  AddIfInSet(GA_BET, ACT_BET);
  AddIfInSet(GA_CALL, ACT_CALL);
  AddIfInSet(GA_RAISE, ACT_RAISE);
  AddIfInSet(GA_DISCARD_CARDS, ACT_DISCARD);
  AddIfInSet(GA_SHOW_CARDS, ACT_SHOW);
  AddIfInSet(GA_SHOW_CARDS_SHUFFLED, ACT_SHOWSHUFFLED);
  AddIfInSet(GA_DONT_SHOW, ACT_DONTSHOW);
  AddIfInSet(GA_MUCK, ACT_MUCK);

end;

procedure TBotAvailableAnswerList.Del(aAnswer: TBotAvailableAnswer);
begin
  inherited Remove(aAnswer);
end;

procedure TBotAvailableAnswerList.DelByInd(nIndex: Integer);
var
  aAnswer: TBotAvailableAnswer;
begin
  aAnswer := Items[nIndex];
  inherited Remove(aAnswer);
end;

destructor TBotAvailableAnswerList.Destroy;
begin
  Clear;
  inherited;
end;

function TBotAvailableAnswerList.FindAnswerType(aAnsverType: TFixAction): TBotAvailableAnswer;
var
  I: Integer;
  aAnswer: TBotAvailableAnswer;
begin
  Result := nil;
  for I:=0 to Count - 1 do begin
    aAnswer := Items[I];
    if (aAnswer.FAnswerType = aAnsverType) then begin
      Result := aAnswer;
      Exit;
    end;
  end;
end;

function TBotAvailableAnswerList.GetHighAnswer: TBotAvailableAnswer;
var
  aAnswer: TBotAvailableAnswer;
begin
  aAnswer := FindAnswerType(ACT_RAISE);
  if (aAnswer <> nil) then begin
    Result := aAnswer;
    Exit;
  end;

  aAnswer := FindAnswerType(ACT_BET);
  if (aAnswer <> nil) then begin
    Result := aAnswer;
    Exit;
  end;

  aAnswer := FindAnswerType(ACT_POST);
  if (aAnswer <> nil) then begin
    Result := aAnswer;
    Exit;
  end;

  aAnswer := FindAnswerType(ACT_POSTDEAD);
  if (aAnswer <> nil) then begin
    Result := aAnswer;
    Exit;
  end;

  aAnswer := FindAnswerType(ACT_BRINGIN);
  if (aAnswer <> nil) then begin
    Result := aAnswer;
    Exit;
  end;

  aAnswer := FindAnswerType(ACT_ANTE);
  if (aAnswer <> nil) then begin
    Result := aAnswer;
    Exit;
  end;

  aAnswer := FindAnswerType(ACT_POSTBB);
  if (aAnswer <> nil) then begin
    Result := aAnswer;
    Exit;
  end;

  aAnswer := FindAnswerType(ACT_POSTSB);
  if (aAnswer <> nil) then begin
    Result := aAnswer;
    Exit;
  end;

  aAnswer := FindAnswerType(ACT_CALL);
  if (aAnswer <> nil) then begin
    Result := aAnswer;
    Exit;
  end;

  aAnswer := FindAnswerType(ACT_CHECK);
  if (aAnswer <> nil) then begin
    Result := aAnswer;
    Exit;
  end;

  if (Count > 0) then
    Result := Items[Count-1]
  else
    Result := nil;
end;

function TBotAvailableAnswerList.GetItems(nIndex: Integer): TBotAvailableAnswer;
begin
  Result := inherited Items[nIndex] as TBotAvailableAnswer;
end;

function TBotAvailableAnswerList.GetLowAnswer: TBotAvailableAnswer;
var
  aAnswer: TBotAvailableAnswer;
begin
  aAnswer := FindAnswerType(ACT_CHECK);
  if (aAnswer <> nil) then begin
    Result := aAnswer;
    Exit;
  end;

  aAnswer := FindAnswerType(ACT_FOLD);
  if (aAnswer <> nil) then begin
    Result := aAnswer;
    Exit;
  end;

  if (Count > 0) then
    Result := Items[0]
  else
    Result := nil;
end;

function TBotAvailableAnswerList.GetMidleAnswer: TBotAvailableAnswer;
var
  aAnswer: TBotAvailableAnswer;
begin
  aAnswer := FindAnswerType(ACT_CALL);
  if (aAnswer <> nil) then begin
    Result := aAnswer;
    Exit;
  end;

  aAnswer := FindAnswerType(ACT_CHECK);
  if (aAnswer <> nil) then begin
    Result := aAnswer;
    Exit;
  end;

  case Count of
      1: Result := Items[0];
    2,3: Result := Items[1];
  else
    Result := nil;
  end;
end;

function TBotAvailableAnswerList.GetNames: string;
var
  I: Integer;
begin
  Result := '';
  for I:=0 to Count - 1 do begin
    Result := Result + ' ' + Items[I].Name;
  end;
  Result := Trim(Result);
end;

function TBotAvailableAnswerList.IndexByType(aAnswerType: TFixAction): Integer;
var
  aAnswer: TBotAvailableAnswer;
  I: Integer;
begin
  Result := -1; // unfound
  for I:=0 to Count - 1 do begin
    aAnswer := Items[I];
    if (aAnswer.FAnswerType = aAnswerType) then begin
      Result := I;
      Exit;
    end;
  end;
end;

function TBotAvailableAnswerList.Ins(nIndex: Integer;
  aAnswer: TBotAvailableAnswer): TBotAvailableAnswer;
begin
  Result := aAnswer;
  Result.FOwner := Self;
  inherited Insert(nIndex, Result);
end;

function TBotAvailableAnswerList.InsByNode(nIndex: Integer;
  aNode: IXMLNode): TBotAvailableAnswer;
begin
  Result := TBotAvailableAnswer.Create(aNode, Self);
  Ins(nIndex, Result);
end;

procedure TBotAvailableAnswerList.ReInitializeBySetActivePlayer(
  aNode: IXMLNode);
var
  sActName: string;
  aNodeCh, aNodeAns: IXMLNode;
  I: Integer;
begin
  Clear;
  if (aNode = nil) then Exit;

  sActName := aNode.NodeName;
  if (sActName = NODE_SETACTIVEPLAYER) then begin
    if (aNode.ChildNodes.Count > 0) then begin
      if (aNode.ChildNodes[0].NodeName = NODE_ACTIONS) then begin
        aNodeCh := aNode.ChildNodes[0];
        for I:=0 to aNodeCh.ChildNodes.Count - 1 do begin
          aNodeAns := aNodeCh.ChildNodes[I];
          AddByNode(aNodeAns);
        end; //for
      end;
    end;
  end;

  sActName := '';
end;

procedure TBotAvailableAnswerList.SetContextByAnswers(aAnswers: TBotAvailableAnswerList);
var
  I: Integer;
  aAnsw: TBotAvailableAnswer;
begin
  Clear;
  for I:=0 to aAnswers.Count - 1 do begin
    aAnsw := TBotAvailableAnswer.Create;
    aAnsw.SetContextByAnswer(aAnswers.Items[I]);
    Add(aAnsw);
  end;
end;

procedure TBotAvailableAnswerList.SortByActionType;
var
  nIndBeg, nIndEnd: Integer;
  aActType: TFixAction;
  aAnswer: TBotAvailableAnswer;
begin
  nIndBeg := 0;
  for aActType:=ACT_FOLD to ACT_UNKNOWN do begin
    aAnswer := FindAnswerType(aActType);
    if (aAnswer <> nil) then begin
      nIndEnd := IndexOf(aAnswer);
      Swap(nIndBeg, nIndEnd);
      Inc(nIndBeg);
    end;
  end;
end;

procedure TBotAvailableAnswerList.Swap(nIndBeg, nIndEnd: Integer);
var
  aAnswer: TBotAvailableAnswer;
begin
  aAnswer := TBotAvailableAnswer.Create;
  aAnswer.SetContextByAnswer(Items[nIndBeg]);
  Items[nIndBeg].SetContextByAnswer(Items[nIndEnd]);
  Items[nIndEnd].SetContextByAnswer(aAnswer);
  aAnswer.Free;
end;

end.
