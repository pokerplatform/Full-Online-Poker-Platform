unit uCardEngine;

interface

uses
//Borland
  Types,
  Classes,
  SysUtils,
  Contnrs,
  XMLIntf,
  XMLDom,
  XMLDoc
//
;

{ XML TEMPLATE }
const
  XML_CARD_LIST = '<cardlist/>';

{ XML TAGS }
const
  XML_TAG_CARD = 'card';

{ XML ATTRIBTES }
const
  XML_ATR_SUIT = 'suit';
  XML_ATR_RANK = 'rank';


type

  TCardSuitType = (
    CST_NONE,
    CST_SPADES,
    CST_HEARTS,
    CST_CLUBS,
    CST_DIAMANDS
  );

  TCardSuits = set of TCardSuitType;

  TCardRankType = (
    CRT_NONE,
    CRT_JOKER,
    CRT_ACE,
    CRT_KING,
    CRT_QUEEN,
    CRT_JACK,
    CRT_TEN,
    CRT_NINE,
    CRT_EIGHT,
    CRT_SEVEN,
    CRT_SIX,
    CRT_FIFE,
    CRT_FOUR,
    CRT_THREE,
    CRT_TWO,
    CRT_ONE
  );

  TCardRanks = set of TCardRankType;

  { Card Unit }
  TCard = class(TObject)
  private
    FSuit: TCardSuitType;
    FRank: TCardRankType;

    function GetAsString: String;

  public

    { Card Attributes }
    property Suit: TCardSuitType read FSuit write FSuit;
    property Rank: TCardRankType read FRank write FRank;

    { Debug Methods }
    property AsString: String read GetAsString;

    { Generic Methids }
    constructor Create(Suit: TCardSuitType; Rank: TCardRankType); overload;
    constructor Create(Card: TCard); overload;
    destructor  Destroy(); override;
  end;//class


  { Sort Type }
  TCardListSortType = (
    ST_NONE,      { Leave cards as they are }
    ST_RANK_HI,   { Highest cards  plaiced in the begining }
    ST_RANK_LOW   { Lowest cards plaiced in the begining }
  );

  { Card List }
  TCardList = class(TObjectList)
  private
    FSorted: TCardListSortType;

    function Get(Index: Integer): TCard;
  public
    property Items[Index: Integer]: TCard read Get; default;
    property Sorted: TCardListSortType read FSorted;

    function Add(Card: TCard; IfNotInList: Boolean = False): Integer;
    function Find(Suit: TCardSuitType; Rank: TCardRankType): TCard;

    procedure GenerateFromXML(CardList: String);

    function IsInCards(Card: TCard; OnlyFirst: Boolean = False; DeleteAfterFind: Boolean = false): Integer; overload;
    function IsInCards(Suit: TCardSuitType; OnlyFirst: Boolean = False; DeleteAfterFind: Boolean = false): Integer; overload;
    function IsInCards(Suit: TCardSuitType; Rank: TCardRankType; OnlyFirst: Boolean = False; DeleteAfterFind: Boolean = false): Integer; overload;
    function IsInCards(Cards: TCardList; DeleteAfterFind: Boolean = false): Integer; overload;

    function CountOfSuit(Suit: TCardSuitType): Integer;
    function CountOfRank(Rank: TCardRankType): Integer;
    function CountOfRankAndSuit(Rank: TCardRankType; Suit: TCardSuitType): Integer;

    function FindCombination(Combination: TCardList): Integer; overload;
    function FindCombination(Suits: array of TCardSuitType; Ranks: array of TCardRankType): Integer; overload;

    function GetCardsOfSuit(Suit: TCardSuitType; DeleteAfterFind: Boolean = False): TCardList;

    procedure Sort(SortType: TCardListSortType);

    constructor Create(aOwner: Boolean);
    destructor Destroy(); override;
  end;//class


  { Heap of Cards }
  TCardHeap = class(TObject)
  private

    { Ingame Cards }
    FHeap: TCardList;

    { Stored Card For Initialization }
    FCards: TCardList;
    function GetCardFromHeapByindex(Index: Integer): TCard;
    function GetCardsCount: Integer;

  public

    { Cards in heap }
    property CardsCount: Integer read GetCardsCount;
    property Cards[Index: Integer]: TCard read GetCardFromHeapByindex; default;

    property CardsHeap: TCardList read FHeap;

    { Generation Method }
    procedure AddCard(Rank: TCardRankType; Copies: Integer; Suits: TCardSuits); overload;
    procedure AddCard(Suit: TCardSuitType; Copies: Integer; Ranks: TCardRanks); overload;
    procedure AddCard(Rank: TCardRankType; Suit: TCardSuitType; Copies: Integer); overload;

    procedure ReshuffleHeap();
    procedure LeaveAsItIs();

    procedure ClearShuffle();
    procedure ClearHeap();

    { Tools }
    function IsInHeap(Rank: TCardRankType; Suit: TCardSuitType): Integer;

    function IsInCards(Cards: TCardList; Card: TCard; OnlyFirst: Boolean = False; DeleteAfterFind: Boolean = false): Integer; overload;
    function IsInCards(Cards: TCardList; Suit: TCardSuitType; OnlyFirst: Boolean = False; DeleteAfterFind: Boolean = false): Integer; overload;

    function GetCardsOfSuit(Cards: TCardList; Suit: TCardSuitType; DeleteAfterFind: Boolean = false): TCardList;

    function FindCombination(Cards: TCardList; Combination: TCardList): Integer; overload;
    function FindCombination(Cards: TCardList; Suits: array of TCardSuitType; Ranks: array of TCardRankType): Integer; overload;

    function GenerateXML(Cards: TCardList): IXMLNode;

    { Generic Methods }
    constructor Create();
    destructor  Destroy(); override;
  end;//class

  { Tools }
  function CardRankToStr(Rank: TCardRankType): String;
  function CardSuitToStr(Suit: TCardSuitType): String;

  function StrToCardRank(Str: String): TCardRankType;
  function StrToCardSuit(Str: String): TCardSuitType;

var
  AllSuits: array [0..3] of TCardSuitType;
  AllRanks: array [0..13] of TCardRankType;
  
implementation


{ Tools }

function SortByRankHi(Item1, Item2: Pointer): Integer;
begin
  Result:= 0;
  if (TObject(Item1) is TCard) and (TObject(Item2) is TCard) then begin
    if (TCard(Item1).FRank > TCard(Item2).FRank) then Result:= 1;
    if (TCard(Item1).FRank < TCard(Item2).FRank) then Result:= -1;
    if (TCard(Item1).FRank = TCard(Item2).FRank) then Result:= 0;
  end;//if
end;//

function SortByRankLow(Item1, Item2: Pointer): Integer;
begin
  Result:= 0;
  if (TObject(Item1) is TCard) and (TObject(Item2) is TCard) then begin
    if (TCard(Item1).FRank > TCard(Item2).FRank) then Result:= -1;
    if (TCard(Item1).FRank < TCard(Item2).FRank) then Result:= 1;
    if (TCard(Item1).FRank = TCard(Item2).FRank) then Result:= 0;
  end;//if
end;//

function CardrankToStr(Rank: TCardRankType): String;
begin
  Result:= '';
  case Rank of
    CRT_JOKER : Result:= 'JK';
    CRT_ACE   : Result:= 'A';
    CRT_KING  : Result:= 'K';
    CRT_QUEEN : Result:= 'Q';
    CRT_JACK  : Result:= 'J';
    CRT_TEN   : Result:= 'T';
    CRT_NINE  : Result:= '9';
    CRT_EIGHT : Result:= '8';
    CRT_SEVEN : Result:= '7';
    CRT_SIX   : Result:= '6';
    CRT_FIFE  : Result:= '5';
    CRT_FOUR  : Result:= '4';
    CRT_THREE : Result:= '3';
    CRT_TWO   : Result:= '2';
    CRT_ONE   : Result:= '1';
  end;//case
end;//

function CardSuitToStr(Suit: TCardSuitType): String;
begin
  Result:= '';
  case Suit of
    CST_SPADES   : Result:= 'S';
    CST_HEARTS   : Result:= 'H';
    CST_CLUBS    : Result:= 'C';
    CST_DIAMANDS : Result:= 'D';
  end;//case
end;//

function StrToCardRank(Str: String): TCardRankType;
begin
  Str:= UpperCase(Str);
  if (Str = 'JK')  then Result:= CRT_JOKER else
  if (Str = 'A')    then Result:= CRT_ACE  else
  if (Str = 'K')   then Result:= CRT_KING  else
  if (Str = 'Q')  then Result:= CRT_QUEEN  else
  if (Str = 'J')   then Result:= CRT_JACK  else
  if (Str = 'T')    then Result:= CRT_TEN  else
  if (Str = '9')   then Result:= CRT_NINE  else
  if (Str = '8')  then Result:= CRT_EIGHT  else
  if (Str = '7')  then Result:= CRT_SEVEN  else
  if (Str = '6')    then Result:= CRT_SIX  else
  if (Str = '5')   then Result:= CRT_FIFE  else
  if (Str = '4')   then Result:= CRT_FOUR  else
  if (Str = '3')  then Result:= CRT_THREE  else
  if (Str = '2')    then Result:= CRT_TWO  else
  if (Str = '1')    then Result:= CRT_ONE  else
    Result:= CRT_NONE;
end;//

function StrToCardSuit(Str: String): TCardSuitType;
begin
  Str:= UpperCase(Str);
  if (Str = 'S')   then Result:= CST_SPADES    else
  if (Str = 'H')   then Result:= CST_HEARTS    else
  if (Str = 'C')    then Result:= CST_CLUBS     else
  if (Str = 'D') then Result:= CST_DIAMANDS  else
    Result:= CST_NONE;
end;//



{ TCardHeap }

procedure TCardHeap.AddCard(Rank: TCardRankType; Copies: Integer; Suits: TCardSuits);
var
  nCount: Integer;
begin
  for nCount:= 1 to Copies do begin
    if (CST_SPADES    in Suits) then FCards.Add(TCard.Create(CST_SPADES, Rank));
    if (CST_HEARTS    in Suits) then FCards.Add(TCard.Create(CST_HEARTS, Rank));
    if (CST_CLUBS     in Suits) then FCards.Add(TCard.Create(CST_CLUBS, Rank));
    if (CST_DIAMANDS  in Suits) then FCards.Add(TCard.Create(CST_DIAMANDS, Rank));
  end;//for
end;

procedure TCardHeap.AddCard(Rank: TCardRankType; Suit: TCardSuitType;
  Copies: Integer);
var
  nCount: Integer;
begin
  for nCount:= 1 to Copies do
    FCards.Add(TCard.Create(Suit, Rank));
end;

procedure TCardHeap.AddCard(Suit: TCardSuitType; Copies: Integer; Ranks: TCardRanks);
var
  nCount: Integer;
begin
  for nCount:= 1 to Copies do begin
    if (CRT_JOKER in Ranks) then FCards.Add(TCard.Create(Suit, CRT_JOKER));
    if (CRT_ACE   in Ranks) then FCards.Add(TCard.Create(Suit, CRT_ACE));
    if (CRT_KING  in Ranks) then FCards.Add(TCard.Create(Suit, CRT_KING));
    if (CRT_QUEEN in Ranks) then FCards.Add(TCard.Create(Suit, CRT_QUEEN));
    if (CRT_JACK  in Ranks) then FCards.Add(TCard.Create(Suit, CRT_JACK));
    if (CRT_TEN   in Ranks) then FCards.Add(TCard.Create(Suit, CRT_TEN));
    if (CRT_NINE  in Ranks) then FCards.Add(TCard.Create(Suit, CRT_NINE));
    if (CRT_EIGHT in Ranks) then FCards.Add(TCard.Create(Suit, CRT_EIGHT));
    if (CRT_SEVEN in Ranks) then FCards.Add(TCard.Create(Suit, CRT_SEVEN));
    if (CRT_SIX   in Ranks) then FCards.Add(TCard.Create(Suit, CRT_SIX));
    if (CRT_FIFE  in Ranks) then FCards.Add(TCard.Create(Suit, CRT_FIFE));
    if (CRT_FOUR  in Ranks) then FCards.Add(TCard.Create(Suit, CRT_FOUR));
    if (CRT_THREE in Ranks) then FCards.Add(TCard.Create(Suit, CRT_THREE));
    if (CRT_TWO   in Ranks) then FCards.Add(TCard.Create(Suit, CRT_TWO));
  end;//for
end;

procedure TCardHeap.ClearHeap;
begin
  FHeap.Clear;
end;

procedure TCardHeap.ClearShuffle;
begin
  FCards.Clear;
end;

constructor TCardHeap.Create;
begin
  { Default Initialization }
  FHeap:= TCardList.Create(True);
  FCards:= TCardList.Create(True);

  Randomize;
end;

destructor TCardHeap.Destroy;
begin

  { Release All }
  FHeap.Free;
  FCards.Free;

  inherited;
end;

function TCardHeap.FindCombination(Cards, Combination: TCardList): Integer;
var
  tCards,
  tCombination: TCardList;
  nIndx2: Integer;

  { Free all lists }
  procedure ReleaseAll();
  begin
    tCards.Free;
    tCombination.Free;
  end;

begin
  //Default value
  Result:= 0;

  //Copy For Comparing
  tCards:= TCardList.Create(False);
  tCards.Assign(Cards, laCopy);

  tCombination:= TCardList.Create(False);
  tCombination.Assign(Combination, laCopy);

  //Search Prcess
  while (tCards.Count > 0) and
        (tCombination.Count > 0) do begin

    nIndx2:= 0;
    while (nIndx2 < tCombination.Count) do begin

       if (IsInCards(tCards, tCombination[nIndx2], True, True) = 0) then begin
         ReleaseAll();
         Exit;
       end;//if

       Inc(nIndx2);
    end;//while

    Inc(Result);
  end;//while

  ReleaseAll();
end;

function TCardHeap.FindCombination(Cards: TCardList; Suits: array of TCardSuitType; Ranks: array of TCardRankType): Integer;
var
  tCombinations: TCardList;

  nRanksLength,
  nSuitsLength: Integer;

  nIndxR,
  nIndxS: Integer;

begin
  Result:= 0;

  nRanksLength:= Length(Ranks) - 1;
  nSuitsLength:= Length(Suits) - 1;
  if (nRanksLength = -1)or(nSuitsLength = -1) then Exit;


  tCombinations:= TCardList.Create(True);

  { Fill With First Suit from Array }
  for nIndxR:= 0 to nRanksLength do
    tCombinations.Add(TCard.Create(Suits[0], Ranks[nIndxR]));

  for nIndxS:= 0 to nSuitsLength do begin
    { Preparing Combinations }
    for nIndxR:= 0 to nRanksLength do
      tCombinations[nIndxR].Suit:= Suits[nIndxS];

    { Check Combinations }  
    Result:= Result + FindCombination(Cards, tCombinations);
  end;//for

  
  { Release All }
  tCombinations.Free;
end;

function TCardHeap.GenerateXML(Cards: TCardList): IXMLNode;
var
  tXMLDocument: IXMLDocument;
  tRootNode,
  tXMLNode: IXMLNode;
  nIndx: Integer;
begin
  tXMLDocument:= LoadXMLData(XML_CARD_LIST);
  tRootNode:= tXMLDocument.DocumentElement;

  for nIndx:= 0 to (Cards.Count-1) do begin
    tXMLNode:= tRootNode.AddChild(XML_TAG_CARD);
    tXMLNode.Attributes[XML_ATR_SUIT]:= CardSuitToStr(Cards[nIndx].Suit);
    tXMLNode.Attributes[XML_ATR_RANK]:= CardRankToStr(Cards[nIndx].Rank);
  end;//for

  Result:= tRootNode;
  tXMLDocument:= nil;
end;

function TCardHeap.GetCardFromHeapByindex(Index: Integer): TCard;
begin
  Result:= TCard(FHeap[Index])
end;

function TCardHeap.GetCardsCount: Integer;
begin
  Result:= FHeap.Count;
end;

function TCardHeap.IsInCards(Cards: TCardList; Card: TCard; OnlyFirst: Boolean; DeleteAfterFind: Boolean): Integer;
var
  nIndx: Integer;
begin
  Result:= 0;

  { Searching For Matches }
  nIndx:= 0;
  while (nIndx < Cards.Count) do begin
    if ((Cards[nIndx].FSuit = Card.Suit) and
        (Cards[nIndx].FRank = Card.Rank)) then begin

      //Card Founded
      Inc(Result);

      if (DeleteAfterFind) then begin
        Cards.Delete(nIndx);
        Dec(nIndx);
      end;//if

      if (OnlyFirst) then Exit;

    end;//if

    Inc(nIndx);
  end;//if

end;

function TCardHeap.GetCardsOfSuit(Cards: TCardList; Suit: TCardSuitType;
  DeleteAfterFind: Boolean): TCardList;
var
  nIndx: Integer;
begin
  Result:= TCardList.Create(False);

  { Searching For Matches }
  nIndx:= 0;
  while (nIndx < Cards.Count) do begin
    if (Cards[nIndx].FSuit = Suit) then begin

      //Card Founded
      Result.Add(Cards[nIndx]);

      if (DeleteAfterFind) then begin
        Cards.Delete(nIndx);
        Dec(nIndx);
      end;//if

    end;//if

    Inc(nIndx);
  end;//if
end;

function TCardHeap.IsInCards(Cards: TCardList; Suit: TCardSuitType; OnlyFirst,
  DeleteAfterFind: Boolean): Integer;
var
  nIndx: Integer;
begin
  Result:= 0;

  { Searching For Matches }
  nIndx:= 0;
  while (nIndx < Cards.Count) do begin
    if (Cards[nIndx].FSuit = Suit) then begin

      //Card Founded
      Inc(Result);

      if (DeleteAfterFind) then begin
        Cards.Delete(nIndx);
        Dec(nIndx);
      end;//if

      if (OnlyFirst) then Exit;

    end;//if

    Inc(nIndx);
  end;//if
end;

function TCardHeap.IsInHeap(Rank: TCardRankType;
  Suit: TCardSuitType): Integer;
var
  nIndx: Integer;
begin
  Result:= 0;
  { Searching For Matches }
  for nIndx:= 0 to (FHeap.Count-1) do begin
    if ((Suit = TCard(FHeap[nIndx]).FSuit) and
        (Rank = TCard(FHeap[nIndx]).FRank)) then Inc(Result);
  end;//for
end;

procedure TCardHeap.LeaveAsItIs;
var
  nIndx: Integer;
begin
  for nIndx:= 0 to (FCards.Count-1) do begin
    FHeap.Add(TCard.Create(TCard(FCards[nIndx])));
  end;//
end;

procedure TCardHeap.ReshuffleHeap;
var
  TempHeap: TCardList;
  nIndx: Integer;
begin
  TempHeap:= TCardList.Create(True);
  FHeap.Clear;

  try
    try
      for nIndx:= 0 to (FCards.Count-1) do
        TempHeap.Add(TCard.Create(FCards[nIndx]));

      while (TempHeap.Count > 0) do begin
        nIndx:= Random(TempHeap.Count);
        FHeap.Add(TCard.Create(TempHeap[nIndx]));
        TempHeap.Delete(nIndx);
      end;//while

    except
    
    end;//try-except

  finally
    TempHeap.Clear;
    TempHeap.Free;
  end;//try-finally

end;

{ TCard }

constructor TCard.Create(Suit: TCardSuitType; Rank: TCardRankType);
begin
  inherited Create();
  Self.FSuit:= Suit;
  Self.FRank:= Rank;
end;

constructor TCard.Create(Card: TCard);
begin
  inherited Create();

  Self.FSuit:= Card.Suit;
  Self.FRank:= Card.Rank;
end;

destructor TCard.Destroy;
begin
  inherited;
end;

function TCard.GetAsString: String;
begin
  Result:= CardRankToStr(FRank) + ' of ' + CardSuitToStr(FSuit);
end;

{ TCardList }

function TCardList.Add(Card: TCard; IfNotInList: Boolean): Integer;
var
  nIndx: Integer;
  fFounded: Boolean;
begin
  Result:= -1;
  fFounded:= False;

  if (IfNotInList) then begin
    for nIndx:= 0 to (Count-1) do
      if  (Items[nIndx].Suit = Card.Suit) and
          (Items[nIndx].Rank = Card.Rank) then begin
        fFounded:= True;
        Break;
      end;//
  end;//

  if not(fFounded) then begin
    Result:= inherited Add(Card);
    FSorted:= ST_NONE;
  end;//if
end;

function TCardList.CountOfSuit(Suit: TCardSuitType): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I:=0 to Count - 1 do begin
    if (Items[I].FSuit = Suit) then Inc(Result);
  end;
end;

function TCardList.CountOfRank(Rank: TCardRankType): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I:=0 to Count - 1 do begin
    if (Items[I].FRank = Rank) then Inc(Result);
  end;
end;

constructor TCardList.Create(aOwner: Boolean);
begin
  inherited Create(aOwner);

  FSorted:= ST_NONE;
end;

destructor TCardList.Destroy;
begin
  inherited;
end;

function TCardList.Find(Suit: TCardSuitType; Rank: TCardRankType): TCard;
var
  nIndx: Integer;
begin
  Result:= nil;

  for nIndx:= 0 to (Count-1) do
    if (Self[nIndx].Suit = Suit)and(Self[nIndx].Rank = Rank) then begin
      Result:= Self[nIndx];
      Exit;
    end;//if
end;

function TCardList.FindCombination(Combination: TCardList): Integer;
var
  tCards,
  tCombination: TCardList;
  nIndx2: Integer;

  { Free all lists }
  procedure ReleaseAll();
  begin
    tCards.Free;
    tCombination.Free;
  end;

begin
  //Default value
  Result:= 0;

  //Copy For Comparing
  tCards:= TCardList.Create(False);
  tCards.Assign(self, laCopy);

  tCombination:= TCardList.Create(False);
  tCombination.Assign(Combination, laCopy);

  //Search Prcess
  while (tCards.Count > 0) and
        (tCombination.Count > 0) do begin

    nIndx2:= 0;
    while (nIndx2 < tCombination.Count) do begin

       if (tCards.IsInCards(tCombination[nIndx2], True, True) = 0) then begin
         ReleaseAll();
         Exit;
       end;//if

       Inc(nIndx2);
    end;//while

    Inc(Result);
  end;//while

  ReleaseAll();
end;

function TCardList.FindCombination(Suits: array of TCardSuitType;
  Ranks: array of TCardRankType): Integer;
var
  tCombinations: TCardList;

  nRanksLength,
  nSuitsLength: Integer;

  nIndxR,
  nIndxS: Integer;

begin
  Result:= 0;

  nRanksLength:= Length(Ranks) - 1;
  nSuitsLength:= Length(Suits) - 1;
  if (nRanksLength = -1)or(nSuitsLength = -1) then Exit;

  tCombinations:= TCardList.Create(True);

  { Fill With First Suit from Array }
  for nIndxR:= 0 to nRanksLength do
    tCombinations.Add(TCard.Create(Suits[0], Ranks[nIndxR]));

  for nIndxS:= 0 to nSuitsLength do begin
    { Preparing Combinations }
    for nIndxR:= 0 to nRanksLength do
      tCombinations[nIndxR].Suit:= Suits[nIndxS];

    { Check Combinations }  
    Result:= Result + Self.FindCombination(tCombinations);
  end;//for


  { Release All }
  tCombinations.Free;
end;

procedure TCardList.GenerateFromXML(CardList: String);
var
  XMLCardList: IXMLDocument;

  XMLCardListNode: IXMLNode;
  XMLCardNode: IXMLNode;
begin
  XMLCardList:= LoadXMLData(CardList);
  XMLCardListNode:= XMLCardList.DocumentElement;

  if Assigned(XMLCardListNode) then begin
    Self.Clear;

    XMLCardNode:= XMLCardListNode.ChildNodes.First;
    while Assigned(XMLCardNode) do begin;
      Self.Add( TCard.Create(
                                StrToCardSuit(XMLCardNode.Attributes[XML_ATR_SUIT]),
                                StrToCardRank(XMLCardNode.Attributes[XML_ATR_RANK])
                              ) );

      XMLCardNode:= XMLCardNode.NextSibling;
    end;//while

  end;//if

  { Relaase All }
  XMLCardNode     := nil;
  XMLCardListNode := nil;
  XMLCardList     := nil;
end;


function TCardList.Get(Index: Integer): TCard;
begin
  Result:= TCard(inherited Items[Index]);
end;

function TCardList.IsInCards(Card: TCard; OnlyFirst, DeleteAfterFind: Boolean): Integer;
var
  nIndx: Integer;
begin
  Result:= 0;

  { Searching For Matches }
  nIndx:= 0;
  while (nIndx < Self.Count) do begin

    if ( ( (Self[nIndx].FSuit = Card.Suit)or(Card.Suit = CST_NONE) ) and
         ( (Self[nIndx].FRank = Card.Rank)or(Card.Rank = CRT_NONE) ) ) then begin

      //Card Founded
      Inc(Result);

      if (DeleteAfterFind) then begin
        Self.Delete(nIndx);
        Dec(nIndx);
      end;//if

      if (OnlyFirst) then Exit;

    end;//if

    Inc(nIndx);
  end;//if
end;

function TCardList.IsInCards(Suit: TCardSuitType; OnlyFirst,
  DeleteAfterFind: Boolean): Integer;
var
  nIndx: Integer;
begin
  Result:= 0;

  { Searching For Matches }
  nIndx:= 0;
  while (nIndx < Self.Count) do begin
    if (Self[nIndx].FSuit = Suit) then begin

      //Card Founded
      Inc(Result);

      if (DeleteAfterFind) then begin
        Self.Delete(nIndx);
        Dec(nIndx);
      end;//if

      if (OnlyFirst) then Exit;

    end;//if

    Inc(nIndx);
  end;//if
end;

function TCardList.IsInCards(Cards: TCardList; DeleteAfterFind: Boolean): Integer;
var
  I: Integer;
  aCard: TCard;
begin
  for I:=0 to Self.Count - 1 do begin
    aCard := Self.Items[I];
    if (Cards.IsInCards(aCard, True, DeleteAfterFind) <= 0) then begin
      Result := 0;
      Exit;
    end;
  end;

  Result := 1;
end;

function TCardList.IsInCards(Suit: TCardSuitType; Rank: TCardRankType;
  OnlyFirst, DeleteAfterFind: Boolean): Integer;
var
  nIndx: Integer;
begin
  Result:= 0;

  { Searching For Matches }
  nIndx:= 0;
  while (nIndx < Self.Count) do begin
    if ((Self[nIndx].FSuit = Suit) or (Suit = CST_NONE)) and
       ((Self[nIndx].FRank = Rank) or (Rank = CRT_NONE)) then begin

      //Card Founded
      Inc(Result);

      if (DeleteAfterFind) then begin
        Self.Delete(nIndx);
        Dec(nIndx);
      end;//if

      if (OnlyFirst) then Exit;

    end;//if

    Inc(nIndx);
  end;//if
end;

procedure TCardList.Sort(SortType: TCardListSortType);
begin
  case SortType of
    ST_RANK_HI  : begin
                    inherited Sort(SortByRankHi);
                    FSorted:= SortType;
                  end;//ST_RANK_HI

    ST_RANK_LOW : begin
                    inherited Sort(SortByRankLow);
                    FSorted:= SortType;
                  end;//ST_RANK_LOW
    else
      FSorted:= ST_NONE;

  end;//case
end;

function TCardList.CountOfRankAndSuit(Rank: TCardRankType;
  Suit: TCardSuitType): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I:=0 to Count - 1 do begin
    if (Items[I].FRank = Rank) and (Items[I].FSuit = Suit) then Inc(Result);
  end;
end;

function TCardList.GetCardsOfSuit(Suit: TCardSuitType;
  DeleteAfterFind: Boolean): TCardList;
var
  nIndx: Integer;
begin
  Result:= TCardList.Create(False);

  { Searching For Matches }
  nIndx:= 0;
  while (nIndx < Self.Count) do begin
    if (Self[nIndx].FSuit = Suit) then begin

      //Card Founded
      Result.Add(Self[nIndx]);

      if (DeleteAfterFind) then begin
        Self.Delete(nIndx);
        Dec(nIndx);
      end;//if

    end;//if

    Inc(nIndx);
  end;//if
end;

initialization

  { Fill Array with All types of Cards Suits }
  AllSuits[0]:= CST_SPADES;
  AllSuits[1]:= CST_HEARTS;
  AllSuits[2]:= CST_CLUBS;
  AllSuits[3]:= CST_DIAMANDS;
end.
