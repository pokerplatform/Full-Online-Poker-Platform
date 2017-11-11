unit uBotActions;

interface

uses SysUtils, Contnrs, XMLDoc, XMLIntF, XMLDom
//
  , uBotConstants
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
    function MemorySize: Integer;
    procedure DumpMemory(Level: Integer = 0; sPrefix: string = '');
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
    function MemorySize: Integer;
    procedure DumpMemory(Level: Integer = 0; sPrefix: string = '');
    //
    constructor Create;
    destructor Destroy; override;
  end;

//******************************************************
// All actions type declaration block
//******************************************************
  TBotInputAction = class
  private
    FActionNode: IXMLNode;
    FAvailableButtons: TBotAvailableAnswerList;
    FUserID: Integer;
    FHandID: Integer;
    FRound: Integer;
    FXMLDoc: IXMLDocument;
    FProcessID: Integer;
    function GetNameOfNode: string;
    function GetActionType: TFixAction;
    function GetPosition: Integer;
    function GetStake: Integer;
    function GetAmount: Integer;
    function GetCards: string;
    function GetValue: Integer;
    function GetBalance: Integer;
    function GetBet: Integer;
    procedure SetUserID(const Value: Integer);
    function GetTimeBank: Integer;
    function GetTurnTime: Integer;
    procedure SetHandID(const Value: Integer);
    procedure SetRound(const Value: Integer);
    procedure SetProcessID(const Value: Integer);
  public
    property ProcessID: Integer read FProcessID write SetProcessID;
    property UserID: Integer read FUserID write SetUserID;
    property HandID: Integer read FHandID write SetHandID;
    property Round: Integer read FRound write SetRound;
    property ActionNode: IXMLNode read FActionNode;
    property Position: Integer read GetPosition;
    property Stake: Integer read GetStake;
    property Amount: Integer read GetAmount;
    property Cards: string read GetCards;
    property Value: Integer read GetValue;
    property Bet: Integer read GetBet;
    property Balance: Integer read GetBalance;
    property TimeBank: Integer read GetTimeBank;
    property TurnTime: Integer read GetTurnTime;
    property NameOfNode: string read GetNameOfNode;
    //
    property ActionType: TFixAction read GetActionType;
    property AvailableButtons: TBotAvailableAnswerList read FAvailableButtons;
    //
    function MemorySize: Integer;
    procedure DumpMemory(Level: Integer = 0; sPrefix: string = '');
    //
    constructor Create(aNode: IXMLNode; nUserID, nProcessID, nHandID, nRound: Integer);
    destructor Destroy; override;
  end;

  TBotInputActionList = class(TObjectList)
  private
    function GetItems(nIndex: Integer): TBotInputAction;
  public
    property Items[nIndex: Integer]: TBotInputAction read GetItems;
    //
    function Add(aAction: TBotInputAction): TBotInputAction;
    function Ins(nIndex: Integer; aAction: TBotInputAction): TBotInputAction;
    procedure Del(aAction: TBotInputAction);
    procedure DelByInd(nIndex: Integer);
    //
    procedure AddActionsByNode(GAActionNode: IXMLNode; nUserID: Integer);
    //
    function MemorySize: Integer;
    procedure DumpMemory(Level: Integer = 0; sPrefix: string = '');
    //
    constructor Create;
    destructor Destroy; override;
  end;

  TBotFunctionAction = class
  private
    FUserID: Integer;
    FHandID: Integer;
    FAmount: Currency;
    FProcessName: string;
    FUserName: string;
    FPosition: Integer;
    FProcessID: Integer;
    FActionType: TFixAction;
  public
    property ActionType: TFixAction read FActionType;
    property ProcessID: Integer read FProcessID;
    property UserID: Integer read FUserID;
    property HandID: Integer read FHandID;
    property Position: Integer read FPosition;
    property Amount: Currency read FAmount;
    property ProcessName: string read FProcessName;
    property UserName: string read FUserName;
    //
    function MemorySize: Integer;
    procedure DumpMemory(Level: Integer = 0; sPrefix: string = '');
    //
    constructor Create(aActionType: TFixAction;
      nProcessID, nUserID, nHandID, nPosition: Integer;
      nAmount: Currency; sProcessName, sUserName: string
    );
    destructor Destroy; override;
  end;

  TBotFunctionActionList = class(TObjectList)
  private
    function GetItems(nIndex: Integer): TBotFunctionAction;
  public
    property Items[nIndex: Integer]: TBotFunctionAction read GetItems;
    //
    function Add(aAction: TBotFunctionAction): TBotFunctionAction;
    function Ins(nIndex: Integer; aAction: TBotFunctionAction): TBotFunctionAction;
    procedure Del(aAction: TBotFunctionAction);
    procedure DelByInd(nIndex: Integer);
    //
    function MemorySize: Integer;
    procedure DumpMemory(Level: Integer = 0; sPrefix: string = '');
    //
    constructor Create;
    destructor Destroy; override;
  end;

  TBotResponse = class
  private
    FXML: string;
    FActionType: TFixAction;
    FVisualizationType: TFixVisualizationType;
    FDateEntry: TDateTime;
    FTableID: Integer;
    FUserID: Integer;
    procedure SetActionType(const Value: TFixAction);
    procedure SetXML(const Value: string);
    procedure SetVisualizationType(const Value: TFixVisualizationType);
    procedure SetDateEntry(const Value: TDateTime);
    procedure SetTableID(const Value: Integer);
    procedure SetUserID(const Value: Integer);
  public
    property XML: string read FXML write SetXML;
    property VisualizationType: TFixVisualizationType read FVisualizationType write SetVisualizationType;
    property ActionType: TFixAction read FActionType write SetActionType;
    property DateEntry: TDateTime read FDateEntry write SetDateEntry;
    property TableID: Integer read FTableID write SetTableID;
    property UserID: Integer read FUserID write SetUserID;
    //
    function MemorySize: Integer;
    procedure DumpMemory(Level: Integer = 0; sPrefix: string = '');
    //
    constructor Create;
    destructor Destroy; override;
  end;

  TBotResponseList = class(TObject)
  private
    FResponseList: TObjectList;
    function GetItem(nIndex: Integer): TBotResponse;
    function GetCount: Integer;
  public
    property Item[nIndex: Integer]: TBotResponse read GetItem;
    property Count: Integer read GetCount;
    //
    function Add(strXML: string; aVisualType: TFixVisualizationType; aActionType: TFixAction;
      DateEntry: TDateTime; nTableID, nUserID: Integer): TBotResponse;
    procedure Del(aItem: TBotResponse);
    procedure DelByIndex(nIndex: Integer);
    function Find(aVisualType: TFixVisualizationType; nTableID, nUserID: Integer): TBotResponse;
    function FindByAllType(aVisualType: TFixVisualizationType; aActionType: TFixAction; nTableID, nUserID: Integer): TBotResponse;
    procedure Clear;
    //
    function MemorySize: Integer;
    procedure DumpMemory(Level: Integer = 0; sPrefix: string = '');
    //
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses Classes
  //
  , uLogger
  , uConstants
  , StrUtils;

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

procedure TBotAvailableAnswer.DumpMemory(Level: Integer; sPrefix: string);
var
  sShift: string;
begin
  if Level > 0 then sShift := DupeString(Shift_string_On_DumpMemory, Level) else sShift := '';
  Logger.Log(0, ClassName, 'DumpMemory',
    sShift + sPrefix + '[SIZE]: ' + IntToStr(MemorySize), ltCall);
end;

function TBotAvailableAnswer.GetName: string;
begin
  Result := GetFixActionAsString(FAnswerType);
end;

function TBotAvailableAnswer.MemorySize: Integer;
begin
  Result :=
    SizeOf(FMaxStake) +
    SizeOf(FStake) +
    SizeOf(FDead) +
    SizeOf(FAnswerType) +
    SizeOf(FTag) +
    SizeOf(FOwner);
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

{ TBotInputAction }

constructor TBotInputAction.Create(aNode: IXMLNode; nUserID, nProcessID, nHandID, nRound: Integer);
begin
  inherited Create;

  FXMLDoc := TXMLDocument.Create(nil);
  FXMLDoc.XML.Text := aNode.XML;
  FXMLDoc.Active := True;

  FUserID     := nUserID;
  FProcessID  := nProcessID;
  FHandID     := nHandID;
  FRound      := nRound;
  FActionNode := FXMLDoc.DocumentElement;
  FAvailableButtons := TBotAvailableAnswerList.Create;
  FAvailableButtons.ReInitializeBySetActivePlayer(aNode);
end;

destructor TBotInputAction.Destroy;
begin
  FXMLDoc := nil;
  FAvailableButtons.Free;
  inherited;
end;

procedure TBotInputAction.DumpMemory(Level: Integer; sPrefix: string);
var
  sShift: string;
begin
  if Level > 0 then sShift := DupeString(Shift_string_On_DumpMemory, Level) else sShift := '';
  Logger.Log(0, ClassName, 'DumpMemory',
    sShift + sPrefix + '[SIZE]: ' + IntToStr(MemorySize), ltCall);
  FAvailableButtons.DumpMemory(Level + 1, sPrefix + '; Buttons count = ' + IntToStr(FAvailableButtons.Count));

  sShift := '';
end;

function TBotInputAction.GetActionType: TFixAction;
var
  sActName: string;
begin
  Result := ACT_UNKNOWN;

  if (NameOfNode = NODE_ACTION) then begin
    if FActionNode.HasAttribute(ATTR_NAME) then begin
      sActName := FActionNode.Attributes[ATTR_NAME];

      if (sActName = ACT_NAME_POSTSB        ) then Result := ACT_POSTSB         else
      if (sActName = ACT_NAME_POSTBB        ) then Result := ACT_POSTBB         else
      if (sActName = ACT_NAME_SITOUT        ) then Result := ACT_SITOUT         else
      if (sActName = ACT_NAME_BACK          ) then Result := ACT_BACK           else
      if (sActName = ACT_NAME_SITOUTNEXTHAND) then Result := ACT_SITOUTNEXTHAND else
      if (sActName = ACT_NAME_MORECHIPS     ) then Result := ACT_MORECHIPS      else
      if (sActName = ACT_NAME_LEAVETABLE    ) then Result := ACT_LEAVETABLE     else
      if (sActName = ACT_NAME_ANTE          ) then Result := ACT_ANTE           else
      if (sActName = ACT_NAME_BRINGIN       ) then Result := ACT_BRINGIN        else
      if (sActName = ACT_NAME_WAITBB        ) then Result := ACT_WAITBB         else
      if (sActName = ACT_NAME_POST          ) then Result := ACT_POST           else
      if (sActName = ACT_NAME_POSTDEAD      ) then Result := ACT_POSTDEAD       else
      if (sActName = ACT_NAME_FOLD          ) then Result := ACT_FOLD           else
      if (sActName = ACT_NAME_CHECK         ) then Result := ACT_CHECK          else
      if (sActName = ACT_NAME_BET           ) then Result := ACT_BET            else
      if (sActName = ACT_NAME_CALL          ) then Result := ACT_CALL           else
      if (sActName = ACT_NAME_RAISE         ) then Result := ACT_RAISE          else
      if (sActName = ACT_NAME_SHOW          ) then Result := ACT_SHOW           else
      if (sActName = ACT_NAME_SHOWSHUFFLED  ) then Result := ACT_SHOWSHUFFLED   else
      if (sActName = ACT_NAME_MUCK          ) then Result := ACT_MUCK           else
        Result := ACT_UNKNOWN;
    end;
  end;

  sActName := '';
end;

function TBotInputAction.GetAmount: Integer;
begin
  Result := GetCurrencyAttrAsInteger(FActionNode, ATTR_AMOUNT);
end;

function TBotInputAction.GetBalance: Integer;
begin
  Result := GetCurrencyAttrAsInteger(FActionNode, ATTR_BALANCE);
end;

function TBotInputAction.GetBet: Integer;
begin
  Result := GetCurrencyAttrAsInteger(FActionNode, ATTR_BET);
end;

function TBotInputAction.GetCards: string;
begin
  Result := '';
  if FActionNode.HasAttribute(ATTR_CARDS) then begin
    Result := FActionNode.Attributes[ATTR_CARDS];
  end;
end;

function TBotInputAction.GetNameOfNode: string;
begin
  Result := FActionNode.NodeName;
end;

function TBotInputAction.GetPosition: Integer;
begin
  Result := -1; // undefined
  if FActionNode.HasAttribute(ATTR_POSITION) then begin
    Result := StrToIntDef(FActionNode.Attributes[ATTR_POSITION], -1);
  end;
end;

function TBotInputAction.GetStake: Integer;
begin
  Result := GetCurrencyAttrAsInteger(FActionNode, ATTR_STAKE);
end;

function TBotInputAction.GetTimeBank: Integer;
begin
  Result := -1;
  if FActionNode.HasAttribute(ATTR_TIMEBANK) then begin
    Result := StrToIntDef(FActionNode.Attributes[ATTR_TIMEBANK], -1);
  end;
end;

function TBotInputAction.GetTurnTime: Integer;
begin
  Result := -1;
  if FActionNode.HasAttribute(ATTR_TURNTIME) then begin
    Result := StrToIntDef(FActionNode.Attributes[ATTR_TURNTIME], -1);
  end;
end;

function TBotInputAction.GetValue: Integer;
begin
  Result := -1;
  if FActionNode.HasAttribute(ATTR_VALUE) then begin
    Result := StrToIntDef(FActionNode.Attributes[ATTR_VALUE], -1);
  end;
end;

function TBotInputAction.MemorySize: Integer;
begin
  Result := FAvailableButtons.MemorySize;
  Result := Result +
    SizeOf(FUserID) +
    SizeOf(FHandID) +
    SizeOf(FRound) +
    SizeOf(FProcessID);
  if (FXMLDoc <> nil) then Result := Result + Length(FXMLDoc.DocumentElement.XML) * SizeOf(Char);
end;

procedure TBotInputAction.SetHandID(const Value: Integer);
begin
  FHandID := Value;
end;

procedure TBotInputAction.SetProcessID(const Value: Integer);
begin
  FProcessID := Value;
end;

procedure TBotInputAction.SetRound(const Value: Integer);
begin
  FRound := Value;
end;

procedure TBotInputAction.SetUserID(const Value: Integer);
begin
  FUserID := Value;
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

procedure TBotAvailableAnswerList.DumpMemory(Level: Integer; sPrefix: string);
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

function TBotAvailableAnswerList.MemorySize: Integer;
var
  I: Integer;
begin
  Result := SizeOf(Self);
  for I:=0 to Count - 1 do
    Result := Result + Items[I].MemorySize;
end;

procedure TBotAvailableAnswerList.ReInitializeBySetActivePlayer(
  aNode: IXMLNode);
var
  sActName: string;
  aNodeCh, aNodeAns: IXMLNode;
  I: Integer;
begin
  Clear;
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

{ TBotInputActionList }

function TBotInputActionList.Add(aAction: TBotInputAction): TBotInputAction;
begin
  Result := aAction;
  inherited Add(Result as TObject);
end;

procedure TBotInputActionList.Del(aAction: TBotInputAction);
begin
  inherited Remove(aAction);
end;

procedure TBotInputActionList.DelByInd(nIndex: Integer);
var
  aAction: TBotInputAction;
begin
  aAction := Items[nIndex];
  inherited Remove(aAction);
end;

function TBotInputActionList.GetItems(nIndex: Integer): TBotInputAction;
begin
  Result := inherited Items[nIndex] as TBotInputAction;
end;

function TBotInputActionList.Ins(nIndex: Integer; aAction: TBotInputAction): TBotInputAction;
begin
  Result := aAction;
  inherited Insert(nIndex, Result as TObject);
end;

procedure TBotInputActionList.AddActionsByNode(GAActionNode: IXMLNode; nUserID: Integer);
var
  aAction: TBotInputAction;
  aNodeCh: IXMLNode;
  I, nProcessID, nHandID, nRound: Integer;
begin
  Logger.Log(nUserID, ClassName, 'AddActionsByNode', 'Entry with.', ltCall);
  nProcessID := -1;
  if GAActionNode.HasAttribute(ATTR_PROCESSID) then begin
    nProcessID := StrToIntDef(GAActionNode.Attributes[ATTR_PROCESSID], -1);
  end;
  if nProcessID <= 0 then Exit;

  nHandID := -1;
  if GAActionNode.HasAttribute(ATTR_SEQ_GAHANDID) then
    nHandID := StrToIntDef(GAActionNode.Attributes[ATTR_SEQ_GAHANDID], -1);

  nRound  := 0;
  if GAActionNode.HasAttribute(ATTR_SEQ_GAROUND) then
    nRound := StrToIntDef(GAActionNode.Attributes[ATTR_SEQ_GAROUND], 0);

  if (GAActionNode.NodeName = NODE_GACRASH) then begin
    aAction := TBotInputAction.Create(GAActionNode, nUserID, nProcessID, nHandID, nRound);
    Add(aAction);

    Logger.Log(nUserID, ClassName, 'AddActionsByNode', 'Action was added: ' + aAction.FActionNode.XML, ltCall);

    Exit;
  end;

  for I:=0 to GAActionNode.ChildNodes.Count - 1 do begin
    aNodeCh := GAActionNode.ChildNodes[I];
    aAction := TBotInputAction.Create(aNodeCh, nUserID, nProcessID, nHandID, nRound);

    Add(aAction);

    Logger.Log(nUserID, ClassName, 'AddActionsByNode', 'Action was added: ' + aAction.FActionNode.XML, ltCall);
  end; // for (I)
end;

constructor TBotInputActionList.Create;
begin
  inherited Create;
end;

destructor TBotInputActionList.Destroy;
begin
  Clear;
  inherited;
end;

procedure TBotInputActionList.DumpMemory(Level: Integer; sPrefix: string);
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

function TBotInputActionList.MemorySize: Integer;
var
  I: Integer;
begin
  Result := SizeOf(Self);
  for I:=0 to Count - 1 do
    Result := Result + Items[I].MemorySize;
end;

{ TBotFunctionAction }

constructor TBotFunctionAction.Create(aActionType: TFixAction;
  nProcessID, nUserID, nHandID, nPosition: Integer;
  nAmount: Currency; sProcessName, sUserName: string);
begin
  inherited Create;
  FActionType := aActionType;
  FProcessID  := nProcessID;
  FUserID     := nUserID;
  FHandID     := nHandID;
  FPosition   := nPosition;
  FAmount     := nAmount;
  FProcessName:= sProcessName;
  FUserName   := sUserName;
end;

destructor TBotFunctionAction.Destroy;
begin
  FProcessName := '';
  FUserName    := '';

  inherited;
end;

procedure TBotFunctionAction.DumpMemory(Level: Integer; sPrefix: string);
var
  sShift: string;
begin
  if Level > 0 then sShift := DupeString(Shift_string_On_DumpMemory, Level) else sShift := '';
  Logger.Log(0, ClassName, 'DumpMemory',
    sShift + sPrefix + '[SIZE]: ' + IntToStr(MemorySize), ltCall);

  sShift := '';
end;

function TBotFunctionAction.MemorySize: Integer;
begin
  Result :=
    SizeOf(FUserID) +
    SizeOf(FHandID) +
    SizeOf(FAmount) +
    Length(FProcessName + FUserName) * SizeOf(Char) +
    SizeOf(FPosition) +
    SizeOf(FProcessID) +
    SizeOf(FActionType);
end;

{ TBotFunctionActionList }

function TBotFunctionActionList.Add(aAction: TBotFunctionAction): TBotFunctionAction;
begin
  Result := aAction;
  inherited Add(Result as TObject);
end;

constructor TBotFunctionActionList.Create;
begin
  inherited Create;
end;

procedure TBotFunctionActionList.Del(aAction: TBotFunctionAction);
begin
  inherited Remove(aAction);
end;

procedure TBotFunctionActionList.DelByInd(nIndex: Integer);
var
  aAction: TBotFunctionAction;
begin
  aAction := Items[nIndex];
  inherited Remove(aAction);
end;

destructor TBotFunctionActionList.Destroy;
begin
  Clear;
  inherited;
end;

procedure TBotFunctionActionList.DumpMemory(Level: Integer; sPrefix: string);
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

function TBotFunctionActionList.GetItems(nIndex: Integer): TBotFunctionAction;
begin
  Result := inherited Items[nIndex] as TBotFunctionAction;
end;

function TBotFunctionActionList.Ins(nIndex: Integer; aAction: TBotFunctionAction): TBotFunctionAction;
begin
  Result := aAction;
  inherited Insert(nIndex, Result as TObject);
end;

function TBotFunctionActionList.MemorySize: Integer;
var
  I: Integer;
begin
  Result := SizeOf(Self);
  for I:=0 to Count - 1 do
    Result := Result + Items[I].MemorySize;
end;

{ TBotResponse }

constructor TBotResponse.Create;
begin
  FXML := '';
  inherited Create;
end;

destructor TBotResponse.Destroy;
begin
  FXML := '';
  inherited;
end;

procedure TBotResponse.SetActionType(const Value: TFixAction);
begin
  FActionType := Value;
end;

procedure TBotResponse.SetXML(const Value: string);
begin
  FXML := Value;
end;

procedure TBotResponse.SetVisualizationType(
  const Value: TFixVisualizationType);
begin
  FVisualizationType := Value;
end;

procedure TBotResponse.SetDateEntry(const Value: TDateTime);
begin
  FDateEntry := Value;
end;

procedure TBotResponse.SetTableID(const Value: Integer);
begin
  FTableID := Value;
end;

procedure TBotResponse.SetUserID(const Value: Integer);
begin
  FUserID := Value;
end;

function TBotResponse.MemorySize: Integer;
begin
  Result :=
    Length(FXML) * SizeOf(Char) +
    SizeOf(FActionType) +
    SizeOf(FVisualizationType) +
    SizeOf(FDateEntry) +
    SizeOf(FTableID) +
    SizeOf(FUserID);
end;

procedure TBotResponse.DumpMemory(Level: Integer; sPrefix: string);
var
  sShift: string;
begin
  if Level > 0 then sShift := DupeString(Shift_string_On_DumpMemory, Level) else sShift := '';
  Logger.Log(0, ClassName, 'DumpMemory',
    sShift + sPrefix + '[SIZE]: ' + IntToStr(MemorySize), ltCall);

  sShift := '';
end;

{ TBotResponseList }

function TBotResponseList.Add(strXML: string;
  aVisualType: TFixVisualizationType; aActionType: TFixAction;
  DateEntry: TDateTime; nTableID, nUserID: Integer): TBotResponse;
begin
//  Result := FindByAllType(aVisualType, aActionType, nTableID, nUserID);
//  if (Result = nil) then
  Result := TBotResponse.Create;

  Result.FXML := strXML;
  Result.FVisualizationType := aVisualType;
  Result.FActionType := aActionType;
  Result.FDateEntry := DateEntry;
  Result.FTableID := nTableID;
  Result.FUserID  := nUserID;

  FResponseList.Add(Result);
end;

procedure TBotResponseList.Clear;
begin
  FResponseList.Clear;
end;

constructor TBotResponseList.Create;
begin
  inherited Create;
  FResponseList := TObjectList.Create;
end;

procedure TBotResponseList.Del(aItem: TBotResponse);
begin
  FResponseList.Remove(aItem);
end;

procedure TBotResponseList.DelByIndex(nIndex: Integer);
var
  aResp: TBotResponse;
begin
  aResp := Item[nIndex];
  FResponseList.Remove(aResp);
end;

destructor TBotResponseList.Destroy;
begin
  FResponseList.Clear;
  FResponseList.Free; 
  inherited;
end;

procedure TBotResponseList.DumpMemory(Level: Integer; sPrefix: string);
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
    Item[I].DumpMemory(Level + 1, sPrefix + '; Item(' + IntToStr(I) + ')');
{$ENDIF}

  sShift := '';
end;

function TBotResponseList.Find(aVisualType: TFixVisualizationType;
  nTableID, nUserID: Integer): TBotResponse;
var
  I: Integer;
  aItm: TBotResponse;
begin
  Result := nil;
  for I:=0 to FResponseList.Count - 1 do begin
    aItm := Item[I];
    if (aItm.FVisualizationType = aVisualType) and
       (aItm.FTableID           = nTableID   ) and
       (aItm.FUserID            = nUserID    )
    then begin
      Result := aItm;
      Exit;
    end;
  end;
end;

function TBotResponseList.FindByAllType(aVisualType: TFixVisualizationType;
  aActionType: TFixAction; nTableID, nUserID: Integer): TBotResponse;
var
  I: Integer;
  aItm: TBotResponse;
begin
  Result := nil;
  for I:=0 to FResponseList.Count - 1 do begin
    aItm := Item[I];
    if (aItm.FVisualizationType = aVisualType) and
       (aItm.FActionType        = aActionType) and
       (aItm.FTableID           = nTableID   ) and
       (aItm.FUserID            = nUserID    )
    then begin
      Result := aItm;
      Exit;
    end;
  end;
end;

function TBotResponseList.GetCount: Integer;
begin
  Result := FResponseList.Count;
end;

function TBotResponseList.GetItem(nIndex: Integer): TBotResponse;
begin
  Result := TBotResponse(FResponseList.Items[nIndex]);
//  Result := TBotResponse(inherited Items[nIndex]);
end;

function TBotResponseList.MemorySize: Integer;
var
  I: Integer;
begin
  Result := SizeOf(Self);
  for I:=0 to Count - 1 do
    Result := Result + Item[I].MemorySize;
end;

end.
