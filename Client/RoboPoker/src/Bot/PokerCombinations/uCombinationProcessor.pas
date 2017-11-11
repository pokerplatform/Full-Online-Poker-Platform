unit uCombinationProcessor;

interface


uses
//borland
  SysUtils,
  Math,

  //sdk
  uCardEngine;

const
  { Combination Prefix }
  VL_ROYAL_FLUSH      = $F0000000;
  VL_STRAIGHT_FLUSH   = $E0000000;
  VL_FOUR_OF_A_KIND   = $D0000000;
  VL_FULL_HOUSE       = $C0000000;
  VL_FLUSH            = $B0000000;
  VL_STRAIGHT         = $A0000000;
  VL_THREE_OF_A_KIND  = $90000000;
  VL_TWO_PAIR         = $80000000;
  VL_ONE_PAIR         = $70000000;
  VL_HIGH_CARD        = $60000000;

  { Card Value }
  VL_JOKER            = $F;
  VL_ACE              = $E;
  VL_KING             = $D;
  VL_QUEEN            = $C;
  VL_JACK             = $B;
  VL_TEN              = $A;
  VL_NINE             = $9;
  VL_EIGHT            = $8;
  VL_SEVEN            = $7;
  VL_SIX              = $6;
  VL_FIFE             = $5;
  VL_FOUR             = $4;
  VL_THREE            = $3;
  VL_TWO              = $2;
  VL_ONE              = $1;

type

  THiLow = (
            CT_HI,
            CT_LOW
           );

  { Methods }
  function SearchRoyalFlush(CardList: TCardList; HiLow: THiLow; var Points: Int64): Boolean;
  function SearchStraightFlush(CardList: TCardList; HiLow: THiLow; var Points: Int64): Boolean;
  function SearchStraight(CardList: TCardList; HiLow: THiLow; var Points: Int64): Boolean;
  function SearchFlush(CardList: TCardList; HiLow: THiLow; var Points: Int64): Boolean;
  function SearchHighestCard(CardList: TCardList; HiLow: THiLow; var Points: Int64): Boolean;
  function SearchFourOfAKind(CardList: TCardList; HiLow: THiLow; var Points: Int64): Boolean;
  function SearchThreeOfAKind(CardList: TCardList; HiLow: THiLow; var Points: Int64): Boolean;
  function SearchTwoPair(CardList: TCardList; HiLow: THiLow; var Points: Int64): Boolean;
  function SearchOnePair(CardList: TCardList; HiLow: THiLow; var Points: Int64): Boolean;
  function SearchFullHouse(CardList: TCardList; HiLow: THiLow; var Points: Int64): Boolean;


  function Hi_SearchRoyalFlush(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
  function Hi_SearchStraightFlush(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
  function Hi_SearchStraight(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
  function Hi_SearchHighestCard(CardList, ExternalCards: TCardList; var Points: Int64; var Probability: double): Boolean;
  function Hi_SearchFourOfAKind(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
  function Hi_SearchThreeOfAKind(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
  function Hi_SearchOnePair(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
  function Hi_SearchTwoPair(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
  function Hi_SearchFullHouse(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
  function Hi_SearchFlush(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;

  function Low_SearchRoyalFlush(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
  function Low_SearchStraightFlush(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
  function Low_SearchStraight(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
  function Low_SearchHighestCard(CardList, ExternalCards: TCardList; var Points: Int64; var Probability: double): Boolean;
  function Low_SearchFlush(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
  function Low_SearchFourOfAKind(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
  function Low_SearchThreeOfAKind(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
  function Low_SearchOnePair(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
  function Low_SearchTwoPair(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
  function Low_SearchFullHouse(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;


  function _SearchFlush(CardList, ExternalCards : TCardList; PartOfCombo: Integer; IsHi: Boolean; var Points: Int64; var Probability: double): Boolean;
  function _SearchFourOfAKind(CardList, ExternalCards : TCardList; PartOfCombo: Integer; IsHi: Boolean; var Points: Int64; var Probability: double): Boolean;
  function _SearchThreeOfAKind(CardList, ExternalCards : TCardList; PartOfCombo: Integer; IsHi: Boolean; var Points: Int64; var  Probability: double): Boolean;
  function _SearchOnePair(CardList, ExternalCards : TCardList; PartOfCombo: Integer; IsHi: Boolean; var Points: Int64; var Probability: double): Boolean;
  function _SearchTwoPair(CardList, ExternalCards : TCardList; PartOfCombo: Integer; IsHi: Boolean; var Points: Int64; var Probability: double): Boolean;
  function _SearchFullHouse(CardList, ExternalCards : TCardList; PartOfCombo: Integer; IsHi: Boolean; var Points: Int64; var Probability: double): Boolean;

  // probability
  function CardToValue(Card: TCard): Integer;
  function CardsToPoints(ValueCombos: Int64; Cards: TCardList): Int64;
  //
  procedure Hi_SearchRoyalFlushProbability(CardList, ExternalCards : TCardList; NumberExternalCards: Integer;
    var MaxPoints: Int64; var Probability, RankSumProbabilityPoints: Double);
  procedure Hi_SearchStraightFlushProbability(CardList, ExternalCards : TCardList; NumberExternalCards: Integer;
    var MaxPoints: Int64; var Probability, RankSumProbabilityPoints: Double);
  procedure Hi_SearchFourOfAKindProbability(CardList, ExternalCards : TCardList; NumberExternalCards: Integer;
    var MaxPoints: Int64; var Probability, RankSumProbabilityPoints: Double);
  procedure Hi_SearchFullHouseProbability(CardList, ExternalCards : TCardList; NumberExternalCards: Integer;
    var MaxPoints: Int64; var Probability, RankSumProbabilityPoints: Double);
  procedure Hi_SearchFlushProbability(CardList, ExternalCards : TCardList; NumberExternalCards: Integer;
    var MaxPoints: Int64; var Probability, RankSumProbabilityPoints: Double);
  procedure Hi_SearchStraightProbability(CardList, ExternalCards : TCardList; NumberExternalCards: Integer;
    var MaxPoints: Int64; var Probability, RankSumProbabilityPoints: Double);
  procedure Hi_SearchThreeOfAKindProbability(CardList, ExternalCards : TCardList; NumberExternalCards: Integer;
    var MaxPoints: Int64; var Probability, RankSumProbabilityPoints: Double);
  procedure Hi_SearchTwoPairProbability(CardList, ExternalCards : TCardList; NumberExternalCards: Integer;
    var MaxPoints: Int64; var Probability, RankSumProbabilityPoints: Double);
  procedure Hi_SearchOnePairProbability(CardList, ExternalCards : TCardList; NumberExternalCards: Integer;
    var MaxPoints: Int64; var Probability, RankSumProbabilityPoints: Double);
  //
  procedure Hi_SearchAnyOfAKindProbability(CardList, ExternalCards : TCardList; NumberExternalCards, TypeKind: Integer;
    var MaxPoints: Int64; var Probability, RankSumProbabilityPoints: Double);
  procedure Hi_SearchAnyOfPairAKindProbability(CardList, ExternalCards : TCardList;
    NumberExternalCards, FirstKind: Integer;
    var MaxPoints: Int64; var Probability, RankSumProbabilityPoints: Double);
  procedure GetHiCardsForAnyOfAKind(CardList, ExternalCards, HiCards: TCardList;
    CurrRank: TCardRankType; NumberExternalCards, TypeKind: Integer);
  procedure GetHiCardsForAnyPairAKind(CardList, ExternalCards, HiCards: TCardList;
    FirstRank, SecondRank: TCardRankType; NumberExternalCards, FirstKind: Integer);
  procedure GetOneTypeKindOrSuitProbability(var CurrPropability: Double;
    CountExtCards, CountEddingCards, CountNeedingCards, CountExistingCards: Integer);

implementation

uses Classes;


type
  TComboType = (CT_RoyalFlush,
                CT_StraightFlush,
                CT_Flush,
                CT_FourOfAKind,
                CT_ThreeOfAKind,
                CT_OnePair,
                CT_TwoPair,
                CT_FullHouse);
{ TOOLS }


{ Return next number with same amount of 1 in it }
function GetNextNumber(var Number: array of Byte; ButtomBorder: Integer): Boolean;
var
  smallest, ripple, ones: Integer;
  x: Integer;
  nIndx: Integer;
begin

  x:= 0;
  for nIndx:= (Length(Number)-1) downto 0 do
    x:= x + Number[nIndx]*(1 shl ((Length(Number)-1)-nIndx));

  if (x = 0)or(x >= ButtomBorder) then begin
    Result:= False;
    Exit;
  end;//if

  smallest  := x and (-x);
  ripple    := x + smallest;
  ones      := x xor ripple;
  ones      := (ones shr 2) div smallest;
  x         := ripple or ones;

  Result:= (x <= ButtomBorder);

  for nIndx:= (Length(Number)-1) downto 0 do begin
    Number[nIndx]:= 0;
    Number[nIndx]:= (x and 1);
    x:= x shr 1;
  end;//for

end;//


{Tools}
function RankToInt64(Rank: TCardRankType; Pos: Integer): Int64;
begin
  Result:= (Int64(CRT_ONE) - Int64(Rank) + 1) shl (4*(8-Pos));
end;//


{ Determin if exists such set of cards }
function SearchByTemplate(SearchTemplate: TCardList; CardList: TCardList; Kickers: Integer; IsHi: Boolean; var Points: Int64): Boolean;
var
  nTmplIndx,
  nIndx: Integer;
  clTemp: TCardList;
  nFounded: Integer;
begin
  clTemp:= TCardList.Create(False);
  clTemp.Assign(CardList);

  nFounded:= 0;
  Points:= 0;

  if (IsHi) then SearchTemplate.Sort(ST_RANK_HI) else
    SearchTemplate.Sort(ST_RANK_LOW);

  for nTmplIndx:= 0 to (SearchTemplate.Count-1) do begin
    if (clTemp.IsInCards(SearchTemplate[nTmplIndx], True, True) > 0) then begin
      Inc(nFounded);
      Points:= Points or RankToInt64(SearchTemplate[nTmplIndx].Rank, nFounded+1)
    end;//if
  end;//for

  for nIndx:= 0 to (Kickers-1) do begin;
    if (nIndx >= clTemp.Count) then break;
    Points:= Points or RankToInt64(clTemp[nIndx].Rank, SearchTemplate.Count+nIndx+2);
  end;//

  clTemp.Free;

  Result:= (nFounded = SearchTemplate.Count);
  if (not Result) then Points:= 0;
end;//

function Fact(N: Integer): double;
var
  nIndx: Integer;
begin
  Result:= 1;
  for nIndx:= 2 to N do
    Result:= Result * nIndx;
end;

{ Determin Should }
function Should(N, M: Integer): double;
begin
  Result:= 0;
  if ((N-M) < 0) then Exit;
  if (N<0)or(M<0) then Exit;
  Result:= Fact(N) / (Fact(M)* Fact(N-M));
end;//

{ Determin Probability Of Appearence }
function DetectProbabilityOfAppearence(CardList, Cards: TCardList; ComboType: TComboType): double;
begin
  Result:= 0.0;

  if (not Assigned(CardList))or
     (not Assigned(Cards))then Exit;
  if (CardList.Count = 0) then Exit;

  Result:= IfThen((CardList.FindCombination(Cards) > 0), 1 / Should(CardList.Count, Cards.Count), 0);
end;

{ Combos Processor Functions }
function SearchXFlush(PossibleSuits: TCardSuitType; StartRank: TCardRankType; CardList, ExternalCards : TCardList; PartOfCombo: Integer; IsHi: Boolean; Kikers: Integer; var MaxPoints: Int64; var MaxProbability: double): Boolean;
var
  arCombo: array [0..4] of Byte;
  arRankCombo: array [0..13] of Byte;
  nIndx,
  nTmlpIndx: Integer;

  arRoyalFlush: array [0..4] of TCard;
  arTemplate: TCardList;

  Points: Int64;
//  Probability: double;
  SearchCards: TCardList;

//  ComboType: TComboType;
begin

  { Prepare }
//  ComboType:= CT_RoyalFlush; {default}

  if (StartRank <> CRT_NONE) then begin

    if (IsHi) then begin
//      if (StartRank = CRT_ACE) then ComboType:= CT_RoyalFlush
//      else ComboType:= CT_StraightFlush;

      for nIndx:= Integer(StartRank) to (Integer(StartRank)+4) do
        arRoyalFlush[nIndx - Integer(StartRank)]:= TCard.Create(PossibleSuits, TCardRankType(nIndx));
    end else begin
//      if (StartRank = CRT_ONE) then ComboType:= CT_RoyalFlush
//      else ComboType:= CT_StraightFlush;

      for nIndx:= Integer(StartRank) downto (Integer(StartRank)-4) do
        arRoyalFlush[nIndx - (Integer(StartRank)-4)]:= TCard.Create(PossibleSuits, TCardRankType(nIndx));
    end;//if

  end else begin
//    if (StartRank = CRT_ONE) then ComboType:= CT_Flush;

    for nIndx:= 0 to 4 do
      arRoyalFlush[nIndx]:= TCard.Create(PossibleSuits, CRT_NONE);

    for nIndx:= 0 to 8 do
      arRankCombo[nIndx]:= 0;

    arRankCombo[ 9]:= 1;
    arRankCombo[10]:= 1;
    arRankCombo[11]:= 1;
    arRankCombo[12]:= 1;
    arRankCombo[13]:= 1;
  end;//if

  { Fill Combo }
  for nIndx:= 4 downto 0 do
    arCombo[4-nIndx]:= Integer(PartOfCombo > nIndx);

  MaxPoints:= IfThen(IsHi, 0, $FFFFFFFF);
  MaxProbability:= 0.0;

  Result:= False;

  if (StartRank <> CRT_NONE) then begin
    repeat
      SearchCards:= TCardList.Create(False);
      arTemplate:= TCardList.Create(False);

      { Fill Template }
      for nIndx:= 0 to 4 do begin
        if (arCombo[nIndx] > 0) then begin
          arTemplate.Add(arRoyalFlush[nIndx]);
        end else begin
          SearchCards.Add(arRoyalFlush[nIndx]);
        end;//if
      end;//for

      Points:= 0;
      if (SearchByTemplate(arTemplate, CardList, Kikers, IsHi, Points)) then begin
         Result:= True;
         //MaxProbability:= MaxProbability + DetectProbabilityOfAppearence(ExternalCards, SearchCards, ComboType);
         if (IsHi)and(Points > MaxPoints) then MaxPoints:= Points;
         if (not IsHi)and(Points < MaxPoints) then MaxPoints:= Points;
      end;//if

      SearchCards.Free;
      arTemplate.Free;
    until (not GetNextNumber(arCombo, 31));
  end else begin


    repeat
      { Fill Template }
      nTmlpIndx:= 0;
      for nIndx:= 0 to 13 do begin
        if (arRankCombo[nIndx] > 0) then begin
          arRoyalFlush[nTmlpIndx].Rank:= TCardRankType(Integer(CRT_ACE) + nIndx);
          Inc(nTmlpIndx);
        end;
      end;//for


      repeat
        SearchCards:= TCardList.Create(False);
        arTemplate:= TCardList.Create(False);

        { Fill Template }
        for nIndx:= 0 to 4 do begin
          if (arCombo[nIndx] > 0) then begin
            arTemplate.Add(arRoyalFlush[nIndx]);
          end else begin
            SearchCards.Add(arRoyalFlush[nIndx]);
          end;//if
        end;//for

        Points:= 0;
        if (SearchByTemplate(arTemplate, CardList, Kikers, IsHi, Points)) then begin
           Result:= True;
           //MaxProbability:= MaxProbability + DetectProbabilityOfAppearence(ExternalCards, SearchCards, ComboType);
           if (IsHi)and(Points > MaxPoints) then MaxPoints:= Points;
           if (not IsHi)and(Points < MaxPoints) then MaxPoints:= Points;
        end;//if

        SearchCards.Free;
        arTemplate.Free;
      until (not GetNextNumber(arCombo, 31));
    until (not GetNextNumber(arRankCombo, 16383));

  end;//if

  { Release }

  for nIndx:= 0 to 4 do
    arRoyalFlush[nIndx].Free;

end;//if

function SearchNOfAKind(Amount: Integer; Rank: TCardRankType; CardList, ExternalCards : TCardList; PartOfCombo: Integer; IsHi: Boolean; var Points: Int64; var MaxProbability: double): Boolean;
var
  arCombo: array [0..3] of Byte;
  nIndx: Integer;
  arNOfAKind: TCardList;
  nPoints,
  nMaxPoints: Int64;
//  Probability: Double;
  SearchCards: TCardList;
begin

  Result:= False;
  Points:= 0;
  MaxProbability:= 0.0;

  { Fill Combo }
  for nIndx:= 3 downto 0 do
    arCombo[3-nIndx]:= Integer(Amount > nIndx);

  nMaxPoints:= IfThen(IsHi, 0, $FFFFFFFF);

  {}
  repeat
    SearchCards:= TCardList.Create(True);
    arNOfAKind:= TCardList.Create(True);

    { Fill Template }
    for nIndx:= 0 to 3 do begin
      if (arCombo[nIndx] > 0) then begin
        arNOfAKind.Add(TCard.Create(AllSuits[nIndx], Rank));
      end else begin
        SearchCards.Add(TCard.Create(AllSuits[nIndx], Rank))
      end;//if
    end;//for

    if (SearchByTemplate(arNOfAKind, CardList, 5-Amount, IsHi, nPoints)) then begin
      Result:= True;
      MaxProbability:= MaxProbability + DetectProbabilityOfAppearence(ExternalCards, SearchCards, CT_FourOfAKind);
      if (IsHi)and(nMaxPoints < nPoints) then nMaxPoints:= nPoints;
      if (not IsHi)and(nMaxPoints > nPoints) then nMaxPoints:= nPoints;
    end;//if

    SearchCards.Free;
    arNOfAKind.Free;
  until (not GetNextNumber(arCombo, 15));

  Points:= nMaxPoints;
end;//


{ Hi Variant }
function Hi_SearchHighestCard(CardList, ExternalCards: TCardList; var Points: Int64; var Probability: double): Boolean;
begin
  Result:= False;

  if (CardList.Sorted <> ST_RANK_HI) then raise Exception.Create('Cards Should Be Sorted With ST_RANK_HI first [use TCardList.Sort Method]');
  if (CardList.Count > 0) then begin
    Points:= VL_HIGH_CARD or RankToInt64(CardList[0].Rank, 2);
    Result:= True;
    Probability:= 0.0;
  end;//if
end;


function Hi_SearchRoyalFlush(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
var
  nSuitIndx: Integer;
  nPoints,
  nMaxPoints: Int64;
  nProbability,
  nMaxPropability: double;
begin
  Result:= False;

  nMaxPoints:= 0;
  Points:= 0;

  nMaxPropability:= 0.0;
  Probability:= 0.0;

  if (CardList.Sorted <> ST_RANK_HI) then raise Exception.Create('Cards Should Be Sorted With ST_RANK_HI first [use TCardList.Sort Method]');
  if (PartOfCombo < 1)or(PartOfCombo > 5)or(CardList.Count < PartOfCombo) then Exit;

  for nSuitIndx:= Integer(CST_SPADES) to Integer(CST_DIAMANDS) do begin
    Result:= Boolean(Integer(Result) or Integer(SearchXFlush(TCardSuitType(nSuitIndx), CRT_ACE, CardList, ExternalCards, PartOfCombo, True, 0, nPoints, nProbability)));
    if (nPoints > nMaxPoints) then nMaxPoints:= nPoints;
//    if (nProbability > mMaxPropability) then mMaxPropability:= nProbability;
    nMaxPropability:= nMaxPropability + nProbability;
  end;//for

  if (Result) then begin
    Points:= VL_ROYAL_FLUSH or nMaxPoints;
    Probability:= nMaxPropability;
  end;//
end;//

function Hi_SearchStraightFlush(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
var
  nSuitIndx,
  nRankIndx: Integer;
  nPoints,
  nMaxPoints: Int64;
  nProbability,
  nMaxPropability: double;
begin
  Result:= False;

  nMaxPoints:= 0;
  Points:= 0;

  nMaxPropability:= 0.0;
  Probability:= 0.0;

  if (CardList.Sorted <> ST_RANK_HI) then raise Exception.Create('Cards Should Be Sorted With ST_RANK_HI first [use TCardList.Sort Method]');
  if (PartOfCombo < 1)or(PartOfCombo > 5)or(CardList.Count < PartOfCombo) then Exit;

  for nSuitIndx:= Integer(CST_SPADES) to Integer(CST_DIAMANDS) do
    for nRankIndx:= Integer(CRT_KING) to Integer(CRT_FIFE) do begin
      Result:= Boolean(Integer(Result) or Integer(SearchXFlush(TCardSuitType(nSuitIndx), TCardRankType(nRankIndx), CardList, ExternalCards, PartOfCombo, True, 0, nPoints, nProbability)));
      if (nPoints > nMaxPoints) then nMaxPoints:= nPoints;
//      if (nProbability > nMaxPropability) then nMaxPropability:= nProbability;
      nMaxPropability:= nMaxPropability + nProbability;
    end;//for

  if (Result) then begin
    Points:= VL_STRAIGHT_FLUSH or nMaxPoints;
    Probability:= nMaxPropability;
  end;//
end;//

function Hi_SearchStraight(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
var
  nRankIndx: Integer;
  nPoints,
  nMaxPoints: Int64;
  nProbability,
  nMaxPropability: double;
begin
  Result:= False;
  nMaxPoints:= 0;
  Points:= 0;
  nMaxPropability:= 0.0;
  Probability:= 0.0;

  if (CardList.Sorted <> ST_RANK_HI) then raise Exception.Create('Cards Should Be Sorted With ST_RANK_HI first [use TCardList.Sort Method]');
  if (PartOfCombo < 1)or(PartOfCombo > 5)or(CardList.Count < PartOfCombo) then Exit;

  for nRankIndx:= Integer(CRT_ACE) to Integer(CRT_FIFE) do begin
    Result:= Boolean(Integer(Result) or Integer(SearchXFlush(CST_NONE, TCardRankType(nRankIndx), CardList, ExternalCards, PartOfCombo, True, 0, nPoints, nProbability)));
    if (nPoints > nMaxPoints) then nMaxPoints:= nPoints;
    nMaxPropability:= nMaxPropability + nProbability;
  end;//for

  if (Result) then begin
    Points:= VL_STRAIGHT or nMaxPoints;
    Probability:= nMaxPropability;
  end;//
end;


function SearchFourOfAKind(CardList: TCardList; HiLow: THiLow; var Points: Int64): Boolean;
var
  nIndx: Integer;
  nPoints: Int64;
begin
  Result:= False;
  Points:= 0;

  if (HiLow = CT_HI)  then if (CardList.Sorted <> ST_RANK_HI) then CardList.Sort(ST_RANK_HI);
  if (HiLow = CT_LOW) then if (CardList.Sorted <> ST_RANK_LOW) then CardList.Sort(ST_RANK_LOW);

  nPoints:= 0;

  for nIndx:= 0 to (CardList.Count-4) do
    if (CardList[nIndx].Rank = CardList[nIndx+1].Rank)and
       (CardList[nIndx+1].Rank = CardList[nIndx+2].Rank)and
       (CardList[nIndx+2].Rank = CardList[nIndx+3].Rank)then begin
      nPoints:= nPoints or RankToInt64(CardList[nIndx].Rank, 2);
      nPoints:= nPoints or RankToInt64(CardList[nIndx+1].Rank, 3);
      nPoints:= nPoints or RankToInt64(CardList[nIndx+2].Rank, 4);
      nPoints:= nPoints or RankToInt64(CardList[nIndx+3].Rank, 5);
      Points:= nPoints or VL_FOUR_OF_A_KIND;
      Result:= True;
      Exit;
    end;//if
end;//


function SearchThreeOfAKind(CardList: TCardList; HiLow: THiLow; var Points: Int64): Boolean;
var
  nIndx: Integer;
  nPoints: Int64;
begin
  Result:= False;
  Points:= 0;

  if (HiLow = CT_HI)  then if (CardList.Sorted <> ST_RANK_HI) then CardList.Sort(ST_RANK_HI);
  if (HiLow = CT_LOW) then if (CardList.Sorted <> ST_RANK_LOW) then CardList.Sort(ST_RANK_LOW);

  nPoints:= 0;

  for nIndx:= 0 to (CardList.Count-3) do
    if (CardList[nIndx].Rank = CardList[nIndx+1].Rank)and
       (CardList[nIndx+1].Rank = CardList[nIndx+2].Rank)then begin
      nPoints:= nPoints or RankToInt64(CardList[nIndx].Rank, 2);
      nPoints:= nPoints or RankToInt64(CardList[nIndx+1].Rank, 3);
      nPoints:= nPoints or RankToInt64(CardList[nIndx+2].Rank, 4);
      Points:= nPoints or VL_THREE_OF_A_KIND;
      Result:= True;
      Exit;
    end;//if
end;//


function SearchTwoPair(CardList: TCardList; HiLow: THiLow; var Points: Int64): Boolean;
var
  nIndx: Integer;

  FrequencyCount: Array [0..15] of Integer;
  RanklCount: Array [0..15] of TCardRankType;
  nOffset: Integer;

  nTreeOfKind,
  nTwoOfKing: Integer;
begin
  Result:= False;
  Points:= 0;

  if (HiLow = CT_HI)  then if (CardList.Sorted <> ST_RANK_HI) then CardList.Sort(ST_RANK_HI);
  if (HiLow = CT_LOW) then if (CardList.Sorted <> ST_RANK_LOW) then CardList.Sort(ST_RANK_LOW);

  if (CardList.Count = 0) then Exit;

  nOffset:= 1;
  FrequencyCount[0]:= CardList.IsInCards(CST_NONE, CardList[0].Rank);
  RanklCount[0]:= CardList[0].Rank;

  for nIndx:= 1 to 15 do begin
    FrequencyCount[nIndx]:= 0;
    RanklCount[nIndx]:= CRT_NONE;
  end;//for

  for nIndx:= 1 to (CardList.Count-1) do begin
    if (CardList[nIndx].Rank <> CardList[nIndx-1].Rank) then begin
      FrequencyCount[nOffset]:= CardList.IsInCards(CST_NONE, CardList[nIndx].Rank);
      RanklCount[nOffset]:= CardList[nIndx].Rank;
      Inc(nOffset);
    end;//if
  end;//for

  nTreeOfKind:= -1;
  nTwoOfKing:= -1;
  
  for nIndx:= 0 to 15 do begin
    if (FrequencyCount[nIndx] > 1) then begin
      nTreeOfKind:= nIndx;
      Break;
    end;//if
  end;//if

  for nIndx:= 0 to 15 do begin
    if (nIndx <> nTreeOfKind)and(FrequencyCount[nIndx] > 1) then begin
      nTwoOfKing:= nIndx;
      Break;
    end;//if
  end;//if

  if (nTreeOfKind <> -1)and(nTwoOfKing <> -1) then begin
    if ((RanklCount[nTreeOfKind] in [CRT_ACE, CRT_ONE]) and
        (RanklCount[nTwoOfKing] in [CRT_ACE, CRT_ONE])) then begin
        Points:= 0;
        Result:= False;
        Exit;
    end;//if

    Points:= Points or RankToInt64(RanklCount[nTreeOfKind], 2);
    Points:= Points or RankToInt64(RanklCount[nTreeOfKind], 3);
    Points:= Points or RankToInt64(RanklCount[nTreeOfKind], 4);
    Points:= Points or RankToInt64(RanklCount[nTwoOfKing],  5);
    Points:= Points or RankToInt64(RanklCount[nTwoOfKing],  6);

    Points:= Points or VL_TWO_PAIR;
    Result:= True;
  end;//if

end;

function SearchFullHouse(CardList: TCardList; HiLow: THiLow; var Points: Int64): Boolean;
var
  nIndx: Integer;

  FrequencyCount: Array [0..15] of Integer;
  RanklCount: Array [0..15] of TCardRankType;
  nOffset: Integer;

  nTreeOfKind,
  nTwoOfKing: Integer;
begin
  Result:= False;
  Points:= 0;

  if (HiLow = CT_HI)  then if (CardList.Sorted <> ST_RANK_HI) then CardList.Sort(ST_RANK_HI);
  if (HiLow = CT_LOW) then if (CardList.Sorted <> ST_RANK_LOW) then CardList.Sort(ST_RANK_LOW);

  if (CardList.Count = 0) then Exit;

  nOffset:= 1;
  FrequencyCount[0]:= CardList.IsInCards(CST_NONE, CardList[0].Rank);
  RanklCount[0]:= CardList[0].Rank;

  for nIndx:= 1 to 15 do begin
    FrequencyCount[nIndx]:= 0;
    RanklCount[nIndx]:= CRT_NONE;
  end;//for

  for nIndx:= 1 to (CardList.Count-1) do begin
    if (CardList[nIndx].Rank <> CardList[nIndx-1].Rank) then begin
      FrequencyCount[nOffset]:= CardList.IsInCards(CST_NONE, CardList[nIndx].Rank);
      RanklCount[nOffset]:= CardList[nIndx].Rank;
      Inc(nOffset);
    end;//if
  end;//for

  nTreeOfKind:= -1;
  nTwoOfKing:= -1;
  
  for nIndx:= 0 to 15 do begin
    if (FrequencyCount[nIndx] > 2) then begin
      nTreeOfKind:= nIndx;
      Break;
    end;//if
  end;//if

  for nIndx:= 0 to 15 do begin
    if (nIndx <> nTreeOfKind)and(FrequencyCount[nIndx] > 1) then begin
      nTwoOfKing:= nIndx;
      Break;
    end;//if
  end;//if

  if (nTreeOfKind <> -1)and(nTwoOfKing <> -1) then begin
    if ((RanklCount[nTreeOfKind] in [CRT_ACE, CRT_ONE]) and
        (RanklCount[nTwoOfKing] in [CRT_ACE, CRT_ONE])) then begin
        Points:= 0;
        Result:= False;
        Exit;
    end;//if

    Points:= Points or RankToInt64(RanklCount[nTreeOfKind], 2);
    Points:= Points or RankToInt64(RanklCount[nTreeOfKind], 3);
    Points:= Points or RankToInt64(RanklCount[nTreeOfKind], 4);
    Points:= Points or RankToInt64(RanklCount[nTwoOfKing],  5);
    Points:= Points or RankToInt64(RanklCount[nTwoOfKing],  6);

    Points:= Points or VL_FULL_HOUSE;
    Result:= True;
  end;//if

end;




function SearchOnePair(CardList: TCardList; HiLow: THiLow; var Points: Int64): Boolean;
var
  nIndx: Integer;
  nPoints: Int64;
begin
  Result:= False;
  Points:= 0;

  if (HiLow = CT_HI)  then if (CardList.Sorted <> ST_RANK_HI) then CardList.Sort(ST_RANK_HI);
  if (HiLow = CT_LOW) then if (CardList.Sorted <> ST_RANK_LOW) then CardList.Sort(ST_RANK_LOW);

  nPoints:= 0;

  for nIndx:= 0 to (CardList.Count-2) do
    if (CardList[nIndx].Rank = CardList[nIndx+1].Rank) then begin
      nPoints:= nPoints or RankToInt64(CardList[nIndx].Rank, 2);
      nPoints:= nPoints or RankToInt64(CardList[nIndx+1].Rank, 3);
      Points:= nPoints or VL_ONE_PAIR;
      Result:= True;
      Exit;
    end;//if
end;//


function SearchHighestCard(CardList: TCardList; HiLow: THiLow; var Points: Int64): Boolean;
begin
  Points:= 0;
  Result:= False;

  if (HiLow = CT_HI) then if (CardList.Sorted <> ST_RANK_HI) then CardList.Sort(ST_RANK_HI);
  if (HiLow = CT_LOW) then if (CardList.Sorted <> ST_RANK_LOW) then CardList.Sort(ST_RANK_LOW);

  if (CardList.Count > 0) then begin
    Points:= Points or VL_HIGH_CARD;
    Points:= Points or RankToInt64(CardList[0].Rank, 2);
    Result:= True;
  end;//if
end;


function SearchStraight(CardList: TCardList; HiLow: THiLow; var Points: Int64): Boolean;
var
  _CardList: TCardList;
  nIndx: Integer;
begin
  Points:= 0;
  Result:= False;

  if (HiLow = CT_HI) then if (CardList.Sorted <> ST_RANK_HI) then CardList.Sort(ST_RANK_HI);
  if (HiLow = CT_LOW) then if (CardList.Sorted <> ST_RANK_LOW) then CardList.Sort(ST_RANK_LOW);

  _CardList:= TCardList.Create(True);

  for nIndx:= 0 to (CardList.Count-1) do
    _CardList.Add(TCard.Create(CST_NONE, CardList[nIndx].Rank), True);

  if (_CardList.Count > 4) then begin
    if (Abs(Integer(_CardList[0].Rank) - Integer(_CardList[1].Rank)) = 1)and
       (Abs(Integer(_CardList[1].Rank) - Integer(_CardList[2].Rank)) = 1)and
       (Abs(Integer(_CardList[2].Rank) - Integer(_CardList[3].Rank)) = 1)and
       (Abs(Integer(_CardList[3].Rank) - Integer(_CardList[4].Rank)) = 1)then begin
      Result:= True;
      Points:= Points or RankToInt64(_CardList[0].Rank, 2);
      Points:= Points or RankToInt64(_CardList[1].Rank, 3);
      Points:= Points or RankToInt64(_CardList[2].Rank, 4);
      Points:= Points or RankToInt64(_CardList[3].Rank, 5);
      Points:= Points or RankToInt64(_CardList[4].Rank, 6);
      Points:= VL_STRAIGHT or Points;
    end;//if
  end;//if

  _CardList.Free;
end;//


function SearchRoyalFlush(CardList: TCardList; HiLow: THiLow; var Points: Int64): Boolean;
var
  _CardList: TCardList;
  nSuits: TCardSuitType;
begin
  Result          := False;
  Points          := 0;

  if (HiLow = CT_HI) then if (CardList.Sorted <> ST_RANK_HI) then CardList.Sort(ST_RANK_HI);
  if (HiLow = CT_LOW) then if (CardList.Sorted <> ST_RANK_LOW) then CardList.Sort(ST_RANK_LOW);

  for nSuits:= CST_SPADES to CST_DIAMANDS do begin
    if (CardList.IsInCards(nSuits, False, False) >= 5) then begin
      _CardList:= CardList.GetCardsOfSuit(nSuits);

      if ((_CardList[0].Rank = CRT_ACE)or(_CardList[0].Rank = CRT_ONE))and
         (Abs(Integer(_CardList[0].Rank) - Integer(_CardList[1].Rank)) = 1)and
         (Abs(Integer(_CardList[1].Rank) - Integer(_CardList[2].Rank)) = 1)and
         (Abs(Integer(_CardList[2].Rank) - Integer(_CardList[3].Rank)) = 1)and
         (Abs(Integer(_CardList[3].Rank) - Integer(_CardList[4].Rank)) = 1)then begin
        Result:= True;
        Points:= Points or RankToInt64(_CardList[0].Rank, 2);
        Points:= Points or RankToInt64(_CardList[1].Rank, 3);
        Points:= Points or RankToInt64(_CardList[2].Rank, 4);
        Points:= Points or RankToInt64(_CardList[3].Rank, 5);
        Points:= Points or RankToInt64(_CardList[4].Rank, 6);
      end;//if

      _CardList.Free;
    end;//if

    if (Result) then Break;
  end;//for

  if (Result) then Points:= (VL_ROYAL_FLUSH or Points) else Points:= 0;
end;//

function SearchStraightFlush(CardList: TCardList; HiLow: THiLow; var Points: Int64): Boolean;
var
  _CardList: TCardList;
  nSuits: TCardSuitType;
  MaxPoints: Int64;
begin
  Result          := False;
  Points          := 0;

  if (HiLow = CT_HI) then if (CardList.Sorted <> ST_RANK_HI) then CardList.Sort(ST_RANK_HI);
  if (HiLow = CT_LOW) then if (CardList.Sorted <> ST_RANK_LOW) then CardList.Sort(ST_RANK_LOW);

  MaxPoints := 0;
  for nSuits:= CST_SPADES to CST_DIAMANDS do begin
    if (CardList.IsInCards(nSuits, False, False) >= 5) then begin
      _CardList:= CardList.GetCardsOfSuit(nSuits);

      if (_CardList.Count > 4) then begin
        if (_CardList[0].Rank = CRT_ACE) then begin
          _CardList[0].Rank := CRT_ONE;
          if (HiLow = CT_HI) then _CardList.Sort(ST_RANK_HI);
          if (HiLow = CT_LOW) then _CardList.Sort(ST_RANK_LOW);
        end;

        if (Abs(Integer(_CardList[0].Rank) - Integer(_CardList[1].Rank)) = 1)and
           (Abs(Integer(_CardList[1].Rank) - Integer(_CardList[2].Rank)) = 1)and
           (Abs(Integer(_CardList[2].Rank) - Integer(_CardList[3].Rank)) = 1)and
           (Abs(Integer(_CardList[3].Rank) - Integer(_CardList[4].Rank)) = 1)then begin
          Result:= True;
          Points:= Points or RankToInt64(_CardList[0].Rank, 2);
          Points:= Points or RankToInt64(_CardList[1].Rank, 3);
          Points:= Points or RankToInt64(_CardList[2].Rank, 4);
          Points:= Points or RankToInt64(_CardList[3].Rank, 5);
          Points:= Points or RankToInt64(_CardList[4].Rank, 6);
          Points:= VL_STRAIGHT or Points;
        end;//if

        if (_CardList[_CardList.Count - 1].Rank = CRT_ONE) then
          _CardList[_CardList.Count - 1].Rank := CRT_ACE;
      end;//if

      _CardList.Free;
    end;//if

    MaxPoints := Max(Points, MaxPoints);

  end;//for

  if (Result) then Points:= (VL_ROYAL_FLUSH or MaxPoints) else Points:= 0;
end;

function SearchFlush(CardList: TCardList; HiLow: THiLow; var Points: Int64): Boolean;
var
  MaxComboPoints,
  ComboPoints,
  nIndx,
  nFounded        : Integer;

  nSuits: TCardSuitType;
begin
  Result          := False;
  Points          := 0;
  MaxComboPoints  := 0;

  if (HiLow = CT_HI) then if (CardList.Sorted <> ST_RANK_HI) then CardList.Sort(ST_RANK_HI);
  if (HiLow = CT_LOW) then if (CardList.Sorted <> ST_RANK_LOW) then CardList.Sort(ST_RANK_LOW);


  for nSuits:= CST_SPADES to CST_DIAMANDS do begin
    if (CardList.IsInCards(nSuits, False, False) >= 5) then begin
      ComboPoints:= 0;

      nFounded:= 0;
      for nIndx:= 0 to (CardList.Count-1) do begin
        if (nFounded > 5) then Break;
        if (CardList[nIndx].Suit = nSuits) then begin
          Inc(nFounded);
          ComboPoints:= ComboPoints or RankToInt64(CardList[nIndx].Rank, nFounded+1);
        end;//if
      end;//for

      if (MaxComboPoints < ComboPoints) then MaxComboPoints:= ComboPoints;
    end;//if
   end;//for

  if (MaxComboPoints > 0) then begin
    Points:= VL_FLUSH or MaxComboPoints;
    Result:= True;
  end;//if
end;//

function Hi_SearchFourOfAKind(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
begin
  Result:= _SearchFourOfAKind(CardList, ExternalCards, PartOfCombo, True, Points, Probability);
end;//

function Hi_SearchThreeOfAKind(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
begin
  Result:= _SearchThreeOfAKind(CardList, ExternalCards, PartOfCombo, True, Points, Probability);
end;//

function Hi_SearchOnePair(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
begin
  Result:= _SearchOnePair(CardList, ExternalCards, PartOfCombo, True, Points, Probability);
end;//

function Hi_SearchTwoPair(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
begin
  Result:= _SearchTwoPair(CardList, ExternalCards, PartOfCombo, True, Points, Probability);
end;//

function Hi_SearchFullHouse(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
begin
  Result:= _SearchFullHouse(CardList, ExternalCards, PartOfCombo, True, Points, Probability);
end;//

function Hi_SearchFlush(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
begin
  Result := _SearchFlush(CardList, ExternalCards, PartOfCombo, True, Points, Probability);
end;

function _SearchFlush(CardList, ExternalCards : TCardList; PartOfCombo: Integer; IsHi: Boolean; var Points: Int64; var Probability: double): Boolean;
var
  nSuitIndx: Integer;
  nPoints,
  nMaxPoints: Int64;
  nProbability,
  nMaxPropability: double;
begin
  Result:= False;
  nMaxPoints:= IfThen(IsHi, 0, $FFFFFFFF);
  Points:= 0;
  nMaxPropability:= 0.0;
  nProbability:= 0.0;

  if (IsHi)and(CardList.Sorted <> ST_RANK_HI) then raise Exception.Create('Cards Should Be Sorted With ST_RANK_HI first [use TCardList.Sort Method]');
  if (not IsHi)and(CardList.Sorted <> ST_RANK_LOW) then raise Exception.Create('Cards Should Be Sorted With ST_RANK_LOW first [use TCardList.Sort Method]');

  if (PartOfCombo < 1)or(PartOfCombo > 5)or(CardList.Count < PartOfCombo) then Exit;

  for nSuitIndx:= Integer(CST_SPADES) to Integer(CST_DIAMANDS) do begin
    Result:= Boolean(Integer(Result) or Integer(SearchXFlush(TCardSuitType(nSuitIndx), CRT_NONE, CardList, ExternalCards, PartOfCombo, IsHi, 0, nPoints, nProbability)));
    if (IsHi)and(nPoints > nMaxPoints) then nMaxPoints:= nPoints;
    if (not IsHi)and(nPoints < nMaxPoints) then nMaxPoints:= nPoints;
//    if (nProbability > mMaxPropability) then mMaxPropability:= nProbability;
    nMaxPropability:= nMaxPropability + nProbability;
  end;//for

  if (Result) then begin
    Points:= VL_FLUSH or nMaxPoints;
    Probability:= nMaxPropability;
  end;//
end;//

function _SearchFourOfAKind(CardList, ExternalCards : TCardList; PartOfCombo: Integer; IsHi: Boolean; var Points: Int64; var Probability: double): Boolean;
var
  nRankIndx: Integer;
  nPoints,
  nMaxPoints: Int64;
  nStart,
  nStop: Integer;
  nProbability,
  nMaxPropability: double;
begin
  {Check Params}
  Result:= False;
  nMaxPoints:= IfThen(IsHi, 0, $FFFFFFFF);
  Points:= 0;
  nMaxPropability:= 0.0;
  nProbability:= 0.0;

  if (IsHi)and(CardList.Sorted <> ST_RANK_HI) then raise Exception.Create('Cards Should Be Sorted With ST_RANK_HI first [use TCardList.Sort Method]');
  if (not IsHi)and(CardList.Sorted <> ST_RANK_LOW) then raise Exception.Create('Cards Should Be Sorted With ST_RANK_LOW first [use TCardList.Sort Method]');

  if (PartOfCombo < 1)or(PartOfCombo > 4)or(CardList.Count < PartOfCombo) then Exit;

  if (IsHi) then begin
    nStart  := Integer(CRT_ACE);
    nStop   := Integer(CRT_TWO);
  end else begin
    nStart  := Integer(CRT_KING);
    nStop   := Integer(CRT_ONE);
  end;

  for nRankIndx:= nStart to nStop do begin
    Result:= Boolean(Integer(Result) or Integer(SearchNOfAKind(4, TCardRankType(nRankIndx), CardList, ExternalCards, PartOfCombo, IsHi, nPoints, nProbability)));
    if (IsHi)and(nPoints > nMaxPoints) then nMaxPoints:= nPoints;
    if (not IsHi)and(nPoints < nMaxPoints) then nMaxPoints:= nPoints;
    nMaxPropability:= nMaxPropability + nProbability;
  end;//for

  if (Result) then begin
    Points:= VL_FOUR_OF_A_KIND or nMaxPoints;
    Probability:= nMaxPropability;
  end;//
end;//

function _SearchThreeOfAKind(CardList, ExternalCards : TCardList; PartOfCombo: Integer; IsHi: Boolean; var Points: Int64; var Probability: double): Boolean;
var
  nRankIndx: Integer;
  nPoints,
  nMaxPoints: Int64;
  nStart,
  nStop: Integer;
  nProbability,
  nMaxPropability: double;
begin
  {Check Params}
  Result:= False;
  nMaxPoints:= IfThen(IsHi, 0, $FFFFFFFF);
  Points:= 0;
  nMaxPropability:= 0.0;
  nProbability:= 0.0;

  if (IsHi)and(CardList.Sorted <> ST_RANK_HI) then raise Exception.Create('Cards Should Be Sorted With ST_RANK_HI first [use TCardList.Sort Method]');
  if (not IsHi)and(CardList.Sorted <> ST_RANK_LOW) then raise Exception.Create('Cards Should Be Sorted With ST_RANK_LOW first [use TCardList.Sort Method]');

  if (PartOfCombo < 1)or(PartOfCombo > 3)or(CardList.Count < PartOfCombo) then Exit;

  if (IsHi) then begin
    nStart  := Integer(CRT_ACE);
    nStop   := Integer(CRT_TWO);
  end else begin
    nStart  := Integer(CRT_KING);
    nStop   := Integer(CRT_ONE);
  end;

  for nRankIndx:= nStart to nStop do begin
    Result:= Boolean(Integer(Result) or Integer(SearchNOfAKind(3, TCardRankType(nRankIndx), CardList, ExternalCards, PartOfCombo, IsHi, nPoints, nProbability)));
    if (IsHi)and(nPoints > nMaxPoints) then nMaxPoints:= nPoints;
    if (not IsHi)and(nPoints < nMaxPoints) then nMaxPoints:= nPoints;
    nMaxPropability:= nMaxPropability + nProbability;
//    if (nProbability > nMaxPropability) then nMaxPropability:= nProbability;
  end;//for

  if (Result) then begin
    Points:= VL_THREE_OF_A_KIND or nMaxPoints;
    Probability:= nMaxPropability;
  end;//
end;//

function _SearchOnePair(CardList, ExternalCards : TCardList; PartOfCombo: Integer; IsHi: Boolean; var Points: Int64; var Probability: double): Boolean;
var
  nRankIndx: Integer;
  nPoints,
  nMaxPoints: Int64;
  nStart,
  nStop: Integer;
  nProbability,
  nMaxPropability: double;
  str: String;
begin
  {Check Params}
  Result:= False;
  nMaxPoints:= IfThen(IsHi, 0, $FFFFFFFF);
  Points:= 0;
  nMaxPropability:= 0.0;
  nProbability:= 0.0;

  if (IsHi)and(CardList.Sorted <> ST_RANK_HI) then raise Exception.Create('Cards Should Be Sorted With ST_RANK_HI first [use TCardList.Sort Method]');
  if (not IsHi)and(CardList.Sorted <> ST_RANK_LOW) then raise Exception.Create('Cards Should Be Sorted With ST_RANK_LOW first [use TCardList.Sort Method]');
  if (PartOfCombo < 1)or(PartOfCombo > 2)or(CardList.Count < PartOfCombo) then Exit;

  if (IsHi) then begin
    nStart  := Integer(CRT_ACE);
    nStop   := Integer(CRT_TWO);
  end else begin
    nStart  := Integer(CRT_KING);
    nStop   := Integer(CRT_ONE);
  end;

  for nRankIndx:= nStart to nStop do begin
    Result:= Boolean(Integer(Result) or Integer(SearchNOfAKind(2, TCardRankType(nRankIndx), CardList, ExternalCards, PartOfCombo, IsHi, nPoints, nProbability)));
    if (IsHi)and(nPoints > nMaxPoints) then nMaxPoints:= nPoints;

    if (not IsHi)and(nPoints < nMaxPoints) then nMaxPoints:= nPoints;

    nMaxPropability:= nMaxPropability + nProbability;
//    if (nProbability > nMaxPropability) then nMaxPropability:= nProbability;
    str:= IntToHex(nMaxPoints, 8);
  end;//for

  if (Result) then begin
    Points:= VL_ONE_PAIR or nMaxPoints;
    Probability:= nMaxPropability;
  end;//

  str := '';
end;//

function _SearchTwoPair(CardList, ExternalCards : TCardList; PartOfCombo: Integer; IsHi: Boolean; var Points: Int64; var Probability: double): Boolean;
var
  nFirstRankIndx,
  nSecondRankIndx: Integer;

  arTwoPair: array [0..3] of TCard;
  arTemplate: TCardList;

  arFPSCombo,
  arSPSCombo: array [0..3] of Byte;
  arTwoPairCombo: array [0..3] of Byte;

  nTmlpIndx,
  nIndx: Integer;

  nPoints,
  nMaxPoints: Int64;

//  nProbability: double;
  SearchCards: TCardList;
begin
  Result:= False;
  Points:= 0;
  Probability:= 0.0;

  if (IsHi)and(CardList.Sorted <> ST_RANK_HI) then raise Exception.Create('Cards Should Be Sorted With ST_RANK_HI first [use TCardList.Sort Method]');
  if (not IsHi)and(CardList.Sorted <> ST_RANK_LOW) then raise Exception.Create('Cards Should Be Sorted With ST_RANK_LOW first [use TCardList.Sort Method]');

  if (PartOfCombo < 0)or(PartOfCombo > 4)or(CardList.Count < PartOfCombo) then Exit;

  arTwoPair[0]:= TCard.Create(CST_NONE, CRT_NONE);
  arTwoPair[1]:= TCard.Create(CST_NONE, CRT_NONE);
  arTwoPair[2]:= TCard.Create(CST_NONE, CRT_NONE);
  arTwoPair[3]:= TCard.Create(CST_NONE, CRT_NONE);


  arTwoPairCombo[0]:= Integer(PartOfCombo > 3);
  arTwoPairCombo[1]:= Integer(PartOfCombo > 2);
  arTwoPairCombo[2]:= Integer(PartOfCombo > 1);
  arTwoPairCombo[3]:= Integer(PartOfCombo > 0);

  nMaxPoints:= 0;

  repeat
    {}
    arFPSCombo[0]:= 0;
    arFPSCombo[1]:= 0;
    arFPSCombo[2]:= 1;
    arFPSCombo[3]:= 1;

    repeat

        arSPSCombo[0]:= 0;
        arSPSCombo[1]:= 0;
        arSPSCombo[2]:= 1;
        arSPSCombo[3]:= 1;

      repeat

        for nFirstRankIndx:= Integer(CRT_ACE) to Integer(CRT_ONE) do begin

          for nSecondRankIndx:= Integer(CRT_ACE) to Integer(CRT_ONE) do
            if (nFirstRankIndx <> nSecondRankIndx) then begin

              { First Pair Template }
              arTwoPair[0].Rank:= TCardRankType(nFirstRankIndx);
              arTwoPair[1].Rank:= TCardRankType(nFirstRankIndx);

              { second Pair Template }
              arTwoPair[2].Rank:= TCardRankType(nSecondRankIndx);
              arTwoPair[3].Rank:= TCardRankType(nSecondRankIndx);

              { Fill Suit Template For First Pair }
              nTmlpIndx:= 0;
              for nIndx:= 0 to 3 do begin
                if (arFPSCombo[nIndx] > 0) then begin
                  arTwoPair[nTmlpIndx].Suit:= AllSuits[nIndx];
                  Inc(nTmlpIndx);
                end;
              end;//for

              { Fill Suit Template For First Pair }
              nTmlpIndx:= 2;
              for nIndx:= 0 to 3 do begin
                if (arSPSCombo[nIndx] > 0) then begin
                  arTwoPair[nTmlpIndx].Suit:= AllSuits[nIndx];
                  Inc(nTmlpIndx);
                end;
              end;//for


              SearchCards:= TCardList.Create(False);
              arTemplate:= TCardList.Create(False);

              { Fill Two Pair Template For First Pair }
              //nTmlpIndx:= 0;
              for nIndx:= 0 to 3 do begin
                if (arTwoPairCombo[nIndx] > 0) then begin
                  arTemplate.Add(arTwoPair[nIndx]);
                  //arTemplate[nTmlpIndx]:= arTwoPair[nIndx];
                  //Inc(nTmlpIndx);
                end else begin
                  SearchCards.Add(arTwoPair[nIndx]);
                end;//if
              end;//for

              if (SearchByTemplate(arTemplate, CardList, 1, IsHi, nPoints)) then begin
                Result:= True;
                Probability:= Probability + DetectProbabilityOfAppearence(ExternalCards, SearchCards, CT_TwoPair);
                if (nPoints > nMaxPoints) then nMaxPoints:= nPoints;
              end;//

              SearchCards.Free;
              arTemplate.Free;
            end;//for

        end;//for

      until (not GetNextNumber(arSPSCombo, 15));
    until (not GetNextNumber(arFPSCombo, 15));
  until (not GetNextNumber(arTwoPairCombo, 15));


  { Release All }
  for nIndx:= 0 to 3 do
    arTwoPair[nIndx].Free;

  if (Result) then Points:= VL_TWO_PAIR or nMaxPoints;
end;//


function _SearchFullHouse(CardList, ExternalCards : TCardList; PartOfCombo: Integer; IsHi: Boolean; var Points: Int64; var Probability: double): Boolean;
var
  nFirstRankIndx,
  nSecondRankIndx: Integer;

  arFullHouse: array [0..4] of TCard;
  arTemplate: TCardList;

  arFPSCombo,
  arSPSCombo: array [0..3] of Byte;

  arFullHouseCombo: array [0..4] of Byte;

  nTmlpIndx,
  nIndx: Integer;

  nPoints,
  nMaxPoints: Int64;

//  nProbability: double;
  SearchCards: TCardList;
begin
  Result:= False;
  Points:= 0;
  Probability:= 0.0;

  if (IsHi)and(CardList.Sorted <> ST_RANK_HI) then raise Exception.Create('Cards Should Be Sorted With ST_RANK_HI first [use TCardList.Sort Method]');
  if (not IsHi)and(CardList.Sorted <> ST_RANK_LOW) then raise Exception.Create('Cards Should Be Sorted With ST_RANK_LOW first [use TCardList.Sort Method]');

  if (PartOfCombo < 0)or(PartOfCombo > 5)or(CardList.Count < PartOfCombo) then Exit;

  arFullHouse[0]:= TCard.Create(CST_NONE, CRT_NONE);
  arFullHouse[1]:= TCard.Create(CST_NONE, CRT_NONE);
  arFullHouse[2]:= TCard.Create(CST_NONE, CRT_NONE);
  arFullHouse[3]:= TCard.Create(CST_NONE, CRT_NONE);
  arFullHouse[4]:= TCard.Create(CST_NONE, CRT_NONE);


  arFullHouseCombo[0]:= Integer(PartOfCombo > 4);
  arFullHouseCombo[1]:= Integer(PartOfCombo > 3);
  arFullHouseCombo[2]:= Integer(PartOfCombo > 2);
  arFullHouseCombo[3]:= Integer(PartOfCombo > 1);
  arFullHouseCombo[4]:= Integer(PartOfCombo > 0);

  nMaxPoints:= IfThen(IsHi, 0, $FFFFFFFF);

  repeat

    { Suit Combinaion For First Group }
    arFPSCombo[0]:= 0;
    arFPSCombo[1]:= 1;
    arFPSCombo[2]:= 1;
    arFPSCombo[3]:= 1;

    repeat

        { Suit Combinaion For Second Group }
        arSPSCombo[0]:= 0;
        arSPSCombo[1]:= 0;
        arSPSCombo[2]:= 1;
        arSPSCombo[3]:= 1;

      repeat

        for nFirstRankIndx:= Integer(CRT_ACE) to Integer(CRT_ONE) do begin

          for nSecondRankIndx:= Integer(CRT_ACE) to Integer(CRT_ONE) do
            if (nFirstRankIndx <> nSecondRankIndx) then begin

              { First Pair Template }
              arFullHouse[0].Rank:= TCardRankType(nFirstRankIndx);
              arFullHouse[1].Rank:= TCardRankType(nFirstRankIndx);
              arFullHouse[2].Rank:= TCardRankType(nFirstRankIndx);

              { second Pair Template }
              arFullHouse[3].Rank:= TCardRankType(nSecondRankIndx);
              arFullHouse[4].Rank:= TCardRankType(nSecondRankIndx);


              { Fill Suit Template For First Pair }
              nTmlpIndx:= 0;
              for nIndx:= 0 to 3 do begin
                if (arFPSCombo[nIndx] > 0) then begin
                  arFullHouse[nTmlpIndx].Suit:= AllSuits[nIndx];
                  Inc(nTmlpIndx);
                end;
              end;//for

              { Fill Suit Template For First Pair }
              nTmlpIndx:= 3;
              for nIndx:= 0 to 3 do begin
                if (arSPSCombo[nIndx] > 0) then begin
                  arFullHouse[nTmlpIndx].Suit:= AllSuits[nIndx];
                  Inc(nTmlpIndx);
                end;
              end;//for

              SearchCards:= TCardList.Create(False);
              arTemplate:= TCardList.Create(False);

              { Fill Two Pair Template For First Pair }
              //nTmlpIndx:= 0;
              for nIndx:= 0 to 4 do begin
                if (arFullHouseCombo[nIndx] > 0) then begin
                  //arTemplate[nTmlpIndx]:= arFullHouse[nIndx];
                  arTemplate.Add(arFullHouse[nIndx]);
                  //Inc(nTmlpIndx);
                end else begin
                  SearchCards.Add(arFullHouse[nIndx]);
                end;//if
              end;//for

              if (SearchByTemplate(arTemplate, CardList, 0, True, nPoints)) then begin
                Result:= True;
                Probability:= Probability + DetectProbabilityOfAppearence(ExternalCards, SearchCards, CT_FullHouse);
                if (IsHi)and(nPoints > nMaxPoints) then nMaxPoints:= nPoints;
                if (not IsHi)and(nPoints < nMaxPoints) then nMaxPoints:= nPoints;
              end;//

              SearchCards.Free;
              arTemplate.Free;
            end;//for

        end;//for

      until (not GetNextNumber(arSPSCombo, 15));
    until (not GetNextNumber(arFPSCombo, 15));
  until (not GetNextNumber(arFullHouseCombo, 31));


  { Release All }
  for nIndx:= 0 to 4 do
    arFullHouse[nIndx].Free;

  if (Result) then Points:= VL_FULL_HOUSE or nMaxPoints;
end;//


{ Low Variant }
function Low_SearchHighestCard(CardList, ExternalCards: TCardList; var Points: Int64; var Probability: double): Boolean;
begin
  Result:= False;
  Points:= 0;
  Probability:= 0.0;

  if (CardList.Sorted <> ST_RANK_LOW) then raise Exception.Create('Cards Should Be Sorted With ST_RANK_LOW first [use TCardList.Sort Method]');
  if (CardList.Count > 0) then begin
    Points:= VL_HIGH_CARD or RankToInt64(CardList[0].Rank, 2);
    Result:= True;
    Probability:= 0.0;
  end;//if
end;

function Low_SearchRoyalFlush(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
var
  nSuitIndx: Integer;
  nPoints,
  nMaxPoints: Int64;
  nProbability,
  nMaxPropability: double;
begin
  Result:= False;
  nMaxPoints:= $FFFFFFFF;
  Points:= 0;

  Probability:= 0.0;
  nMaxPropability:= 0.0;

  if (CardList.Sorted <> ST_RANK_LOW) then raise Exception.Create('Cards Should Be Sorted With ST_RANK_LOW first [use TCardList.Sort Method]');
  if (PartOfCombo < 1)or(PartOfCombo > 5)or(CardList.Count < PartOfCombo) then Exit;

  for nSuitIndx:= Integer(CST_SPADES) to Integer(CST_DIAMANDS) do begin
    Result:= Boolean(Integer(Result) or Integer(SearchXFlush(TCardSuitType(nSuitIndx), CRT_ONE, CardList, ExternalCards, PartOfCombo, False, 0, nPoints, nProbability)));
    if (nPoints < nMaxPoints) then nMaxPoints:= nPoints;
//    if (nProbability > nMaxPropability) then nMaxPropability:= nProbability;
    nMaxPropability:= nMaxPropability + nProbability;
  end;//for

  if (Result) then begin
    Points:= VL_ROYAL_FLUSH or nMaxPoints;
    Probability:= nMaxPropability;
  end;//if
end;//

function Low_SearchStraightFlush(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
var
  nSuitIndx,
  nRankIndx: Integer;
  nPoints,
  nMaxPoints: Int64;
  nProbability,
  nMaxPropability: double;
begin
  Result:= False;
  nMaxPoints:= $FFFFFFFF;
  Points:= 0;

  nMaxPropability:= 0.0;
  Probability:= 0.0;

  if (CardList.Sorted <> ST_RANK_LOW) then raise Exception.Create('Cards Should Be Sorted With ST_RANK_LOW first [use TCardList.Sort Method]');
  if (PartOfCombo < 1)or(PartOfCombo > 5)or(CardList.Count < PartOfCombo) then Exit;

  for nSuitIndx:= Integer(CST_SPADES) to Integer(CST_DIAMANDS) do
    for nRankIndx:= Integer(CRT_TWO) downto Integer(CRT_FIFE) do begin
      Result:= Boolean(Integer(Result) or Integer(SearchXFlush(TCardSuitType(nSuitIndx), TCardRankType(nRankIndx), CardList, ExternalCards, PartOfCombo, False, 0, nPoints, nProbability)));
      if (nPoints < nMaxPoints) then nMaxPoints:= nPoints;
      nMaxPropability:= nMaxPropability + nProbability;
      //      if (nProbability > nMaxPropability) then nMaxPropability:= nProbability;
    end;//for

  if (Result) then begin
    Points:= VL_STRAIGHT_FLUSH or nMaxPoints;
    Probability:= nProbability;
  end;//if
end;//


function Low_SearchStraight(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
var
  nRankIndx: Integer;
  nPoints,
  nMaxPoints: Int64;
  nProbability,
  nMaxPropability: double;
begin
  Result:= False;
  nMaxPoints:= $FFFFFFFF;
  Points:= 0;

  nMaxPropability:= 0.0;
  Probability:= 0.0;

  if (CardList.Sorted <> ST_RANK_LOW) then raise Exception.Create('Cards Should Be Sorted With ST_RANK_LOW first [use TCardList.Sort Method]');
  if (PartOfCombo < 1)or(PartOfCombo > 5)or(CardList.Count < PartOfCombo) then Exit;

  for nRankIndx:= Integer(CRT_ONE) downto Integer(CRT_FIFE) do begin
    Result:= Boolean(Integer(Result) or Integer(SearchXFlush(CST_NONE, TCardRankType(nRankIndx), CardList, ExternalCards, PartOfCombo, False, 0, nPoints, nProbability)));
    if (nPoints < nMaxPoints) then nMaxPoints:= nPoints;
    nMaxPropability:= nMaxPropability + nProbability;
    //if (nProbability > nMaxPropability) then nMaxPropability:= nProbability;
  end;//for

  if (Result) then begin
    Points:= VL_STRAIGHT or nMaxPoints;
    Probability:= nMaxPropability;
  end;//if
end;


function Low_SearchFlush(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
begin
  Result:= _SearchFlush(CardList, ExternalCards, PartOfCombo, False, Points, Probability);
end;//

function Low_SearchFourOfAKind(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
begin
  Result:= _SearchFourOfAKind(CardList, ExternalCards, PartOfCombo, False, Points, Probability);
end;//

function Low_SearchThreeOfAKind(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
begin
  Result:= _SearchThreeOfAKind(CardList, ExternalCards, PartOfCombo, False, Points, Probability);
end;//

function Low_SearchOnePair(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
begin
  Result:= _SearchOnePair(CardList, ExternalCards, PartOfCombo, False, Points, Probability);
end;//

function Low_SearchTwoPair(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
begin
  Result:= _SearchTwoPair(CardList, ExternalCards, PartOfCombo, False, Points, Probability);
end;//

function Low_SearchFullHouse(CardList, ExternalCards : TCardList; PartOfCombo: Integer; var Points: Int64; var Probability: double): Boolean;
begin
  Result:= _SearchFullHouse(CardList, ExternalCards, PartOfCombo, False, Points, Probability);
end;//

// probability
function CardToValue(Card: TCard): Integer;
begin
  case Card.Rank of
    CRT_JOKER: Result := VL_JOKER;
    CRT_ACE  : Result := VL_ACE;
    CRT_KING : Result := VL_KING;
    CRT_QUEEN: Result := VL_QUEEN;
    CRT_JACK : Result := VL_JACK;
    CRT_TEN  : Result := VL_TEN;
    CRT_NINE : Result := VL_NINE;
    CRT_EIGHT: Result := VL_EIGHT;
    CRT_SEVEN: Result := VL_SEVEN;
    CRT_SIX  : Result := VL_SIX;
    CRT_FIFE : Result := VL_FIFE;
    CRT_FOUR : Result := VL_FOUR;
    CRT_THREE: Result := VL_THREE;
    CRT_TWO  : Result := VL_TWO;
    CRT_ONE  : Result := VL_ONE;
  else
    Result := 0;
  end;
end;

function CardsToPoints(ValueCombos: Int64; Cards: TCardList): Int64;
var
  I, nVal: Integer;
begin
  Result := 0;
  for I:=0 to 4 do begin
    if (I >= Cards.Count) then
      nVal := 0
    else
      nVal := CardToValue(Cards.Items[I]);
    Result := Result + (nVal Shl ((6-I)*4));
  end;
  Result := ValueCombos or Result;
end;

procedure GetOneTypeKindOrSuitProbability(var CurrPropability: Double;
  CountExtCards, CountEddingCards, CountNeedingCards, CountExistingCards: Integer);
var
  nM, nN: Integer;
  Numerator, Denominator: Double;
begin
  if (CountExtCards < 0) or (CountEddingCards < 0) or
     (CountExtCards < CountEddingCards) or (CountExtCards < CountNeedingCards)
  then begin
    CurrPropability := 0;
    Exit;
  end;
  if (CountExtCards = CountNeedingCards) then Exit; // without change of CurrProbability

  Denominator := Should(CountExtCards, CountEddingCards);

  nN := CountExistingCards;
  nM := CountNeedingCards;
  Numerator := 1;
  if (nN >= 0) and (nM >= 0) and (nN >= nM) then Numerator := Should(nN, nM);

  nN := CountExtCards    - CountExistingCards;
  nM := CountEddingCards - CountNeedingCards;
  if (nN >= 0) and (nM >= 0) and (nN >= nM) then Numerator := Numerator * Should(nN, nM);

  CurrPropability := CurrPropability * Numerator / Denominator;
end;

procedure Hi_SearchRoyalFlushProbability(CardList, ExternalCards : TCardList; NumberExternalCards: Integer;
  var MaxPoints: Int64; var Probability, RankSumProbabilityPoints: Double);
var
  aCards, aExCards, aPointCards, aSpecCards: TCardList;
  I, J, nCountOfFounds, nN, nM, nRemovedCards: Integer;
  aCard: TCard;
  Denominator, Numerator: Double;
  I_S: TCardSuitType;
  I_R: TCardRankType;
  nPoints: Int64;
  nProbability: Double;
begin
  MaxPoints      := 0;
  Probability := 0;
  RankSumProbabilityPoints := 0;
  if (CardList.Count + NumberExternalCards) < 5 then Exit;
  if (NumberExternalCards < 0) then NumberExternalCards := 0;

  aCards := TCardList.Create(False);
  aExCards := TCardList.Create(False);

  { delete from CardList }
  for I:=0 to CardList.Count - 1 do begin
    aCard := CardList.Items[I];
    if (aCard.Rank < CRT_NINE) then aCards.Add(aCard);
  end;
  I:=0;
  while I < aCards.Count do begin
    I_S := aCards.Items[I].Suit;
    if (aCards.CountOfSuit(I_S) + NumberExternalCards) < 5 then begin
      { delete suit }
      for J := aCards.Count - 1 downto 0 do begin
        aCard := aCards.Items[J];
        if (aCard.Suit = I_S) then aCards.Remove(aCard);
      end;
    end else begin
      Inc(I);
    end;
  end;

  if (aCards.Count + NumberExternalCards) < 5 then begin
    { Has no royal flash }
    aCards.Free;
    aExCards.Free;
    Exit;
  end;

  { delete from ExternalCards }
  for I:=0 to ExternalCards.Count - 1 do begin
    aCard := ExternalCards.Items[I];
    if (aCard.Rank < CRT_NINE) then aExCards.Add(aCard);
  end;

  Denominator := Should(ExternalCards.Count, NumberExternalCards);

  { Special case }
  if (aCards.Count >= 5) then begin
    aCards.Sort(ST_RANK_HI);
    if SearchRoyalFlush(aCards, CT_HI, nPoints) then begin
      MaxPoints := nPoints;
      Probability := 1;
      RankSumProbabilityPoints := MaxPoints * Probability;

      aCards.Free;
      aExCards.Free;

      Exit;
    end;
  end;

  { for every card }
  nRemovedCards := 0;
  aSpecCards := TCardList.Create(True);
  aPointCards := TCardList.Create(True);
  for I_S:=CST_SPADES to CST_DIAMANDS do begin
    if (aCards.CountOfSuit(I_S) + NumberExternalCards) < 5 then Continue;

    aSpecCards.Clear;
    aPointCards.Clear;
    { 5 cards for working }
    nCountOfFounds := 0;
    for I_R:=CRT_ACE to CRT_TEN do begin
      if (aCards.IsInCards(I_S, I_R, True, False) <= 0) then begin
        aSpecCards.Add( TCard.Create(I_S, I_R) );
      end else begin
        Inc(nCountOfFounds);
        aPointCards.Add( TCard.Create(I_S, I_R) );
      end;
    end;
    { validate }
    if (nCountOfFounds + NumberExternalCards) < 5 then Continue;

    Numerator := aSpecCards.IsInCards(aExCards);
    if (Numerator <= 0) then Continue;

    nM := Max(5 - nCountOfFounds, 0);
    if (nM = 0) then begin
      nN := ExternalCards.Count - nRemovedCards;
      nM := NumberExternalCards;
    end else begin
      nN := ExternalCards.Count - nM - nRemovedCards;
      nM := NumberExternalCards - nM;
      nRemovedCards := nRemovedCards + nM;
    end;

    if (nN >= 0) and (nM >= 0) and (nN >= nM) then
      Numerator := Numerator * Should(nN, nM)
    else
      Numerator := 1;

    for J := aSpecCards.Count - 1 downto 0 do begin
      aCard := aSpecCards.Items[J];
      aPointCards.Add( TCard.Create(aCard) );
      aSpecCards.Remove(aCard);
    end;

    nPoints := CardsToPoints(VL_ROYAL_FLUSH, aPointCards);
    if (nPoints > MaxPoints) then MaxPoints := nPoints;
    nProbability := Numerator / Denominator;
    Probability := Probability + nProbability;
    RankSumProbabilityPoints := RankSumProbabilityPoints + nPoints * nProbability;

    { delete from aExCards all current suit cards }
    for I:=aExCards.Count - 1 downto 0 do begin
      aCard := aExCards.Items[I];
      if (aCard.Suit = I_S) and (aCard.Rank in [CRT_ACE..CRT_TEN]) then aExCards.Remove(aCard);
    end;
  end;

  aSpecCards.Free;
  aPointCards.Free;
  aCards.Free;
  aExCards.Free;
end;

procedure Hi_SearchStraightFlushProbability(CardList, ExternalCards : TCardList; NumberExternalCards: Integer;
  var MaxPoints: Int64; var Probability, RankSumProbabilityPoints: Double);
var
  aCards, aExCards, aSpecCards, aPointCards: TCardList;
  I, J, nCountOfFounds, nN, nM, nRemovedCards: Integer;
  aCard: TCard;
  Denominator, Numerator: Double;
  I_S: TCardSuitType;
  I_R, I_R_1: TCardRankType;
  nPoints: Int64;
  nProbability: Double;
begin
  MaxPoints      := 0;
  Probability := 0;
  RankSumProbabilityPoints := 0;
  if (CardList.Count + NumberExternalCards) < 5 then Exit;
  if (NumberExternalCards < 0) then NumberExternalCards := 0;

  aCards := TCardList.Create(False);
  aExCards := TCardList.Create(False);

  { create memory CardList }
  for I:=0 to CardList.Count - 1 do begin
    aCard := CardList.Items[I];
    if (aCard.Rank > CRT_ACE) then aCards.Add(aCard);
  end;
  if (aCards.Count + NumberExternalCards) < 5 then begin
    { Has not strait flash }
    aCards.Free;
    aExCards.Free;
    Exit;
  end;

  { Fillind aExCards  }
  for I:=0 to ExternalCards.Count - 1 do begin
    aCard := ExternalCards.Items[I];
    aExCards.Add(aCard);
  end;

  Denominator := Should(ExternalCards.Count, NumberExternalCards);

  { Special case }
  if (aCards.Count >= 5) then begin
    aCards.Sort(ST_RANK_HI);
    if SearchStraightFlush(aCards, CT_HI, nPoints) then begin
      MaxPoints := nPoints;
      Probability := 1;
      RankSumProbabilityPoints := MaxPoints * Probability;

      aCards.Free;
      aExCards.Free;

      Exit;
    end;
  end;

  { for every card }
  nRemovedCards := 0;
  aSpecCards := TCardList.Create(True);
  aPointCards := TCardList.Create(True);
  for I_S:=CST_SPADES to CST_DIAMANDS do begin
    if (aCards.CountOfSuit(I_S) + NumberExternalCards) < 5 then Continue;

    for I_R:=CRT_KING to CRT_SIX do begin
      aSpecCards.Clear;
      aPointCards.Clear;

      { 5 cards for working }
      nCountOfFounds := 0;
      for I_R_1:=I_R to TCardRankType(Integer(I_R) + 5 - 1) do begin
        if (aCards.IsInCards(I_S, I_R_1, True, False) <= 0) then begin
          aSpecCards.Add( TCard.Create(I_S, I_R_1) );
        end else begin
          Inc(nCountOfFounds);
          aPointCards.Add( TCard.Create(I_S, I_R_1) );
        end;
      end;
      { validate }
      if (nCountOfFounds + NumberExternalCards) < 5 then Continue;

      Numerator := aSpecCards.IsInCards(aExCards);
      if (Numerator <= 0) then Continue;

      nCountOfFounds := Min(5, nCountOfFounds);
      nM := 5 - nCountOfFounds;
      if (nM = 0) then begin
        nN := ExternalCards.Count - nRemovedCards;
        nM := NumberExternalCards;
      end else begin
        nN := ExternalCards.Count - nM - nRemovedCards;
        nM := NumberExternalCards - nM;
        nRemovedCards := nRemovedCards + 1;
      end;
      if (nN >= 0) and (nM >= 0) and (nN >= nM) then
        Numerator := Numerator * Should(nN, nM)
      else
        Numerator := 1;

      for J := aSpecCards.Count - 1 downto 0 do begin
        aCard := aSpecCards.Items[J];
        aPointCards.Add( TCard.Create(aCard) );
        aSpecCards.Remove(aCard);
      end;

      nPoints := CardsToPoints(VL_STRAIGHT_FLUSH, aPointCards);
      if (nPoints > MaxPoints) then MaxPoints := nPoints;
      nProbability := Numerator / Denominator;
      Probability := Probability + nProbability;
      RankSumProbabilityPoints := RankSumProbabilityPoints + nPoints * nProbability;
    end;

    { delete from aExCards all current suit cards }
    for I:=aExCards.Count - 1 downto 0 do begin
      aCard := aExCards.Items[I];
      if (aCard.Suit = I_S) and (aCard.Rank in []) then aExCards.Remove(aCard);
    end;
  end;
  aSpecCards.Free;
  aPointCards.Free;
  aCards.Free;
  aExCards.Free;
end;

procedure Hi_SearchStraightProbability(CardList, ExternalCards : TCardList; NumberExternalCards: Integer;
  var MaxPoints: Int64; var Probability, RankSumProbabilityPoints: Double);
var
  aCards, aExCards, aSpecCards, aPointCards: TCardList;
  I, J, nCntOfRank, nExCnt, nN, nM: Integer;
  aCard: TCard;
  Denominator, Numerator: Double;
  I_R, I_R_1: TCardRankType;
  nPoints: Int64;
  nProbability: Double;
begin
  MaxPoints      := 0;
  Probability := 0;
  RankSumProbabilityPoints := 0;
  if (CardList.Count + NumberExternalCards) < 5 then Exit;
  if (NumberExternalCards < 0) then NumberExternalCards := 0;

  aCards := TCardList.Create(False);
  aExCards := TCardList.Create(False);

  { create memory CardList }
  for I:=0 to CardList.Count - 1 do begin
    aCard := CardList.Items[I];
    aCards.Add(aCard);
  end;

  { Fillind aExCards  }
  for I:=0 to ExternalCards.Count - 1 do begin
    aCard := ExternalCards.Items[I];
    aExCards.Add(aCard);
  end;

  Denominator := Should(ExternalCards.Count, NumberExternalCards);

  { Special case }
  if (aCards.Count >= 5) then begin
    aCards.Sort(ST_RANK_HI);
    if SearchStraight(aCards, CT_HI, nPoints) then begin
      MaxPoints := nPoints;
      Probability := 1;
      RankSumProbabilityPoints := MaxPoints * Probability;

      aCards.Free;
      aExCards.Free;

      Exit;
    end;
  end;

  { for every card }
  aSpecCards := TCardList.Create(True);
  aPointCards := TCardList.Create(True);
  for I_R:=CRT_ACE to CRT_SIX do begin
    aSpecCards.Clear;
    aPointCards.Clear;
    { 5 cards for working }
    nCntOfRank := 0;
    for I_R_1:=I_R to TCardRankType(Integer(I_R) + 5 - 1) do begin
      if (aCards.IsInCards(CST_NONE, I_R_1, True, False) <= 0) then begin
        aSpecCards.Add( TCard.Create(CST_NONE, I_R_1), True );
      end else begin
        Inc(nCntOfRank);
        aPointCards.Add( TCard.Create(CST_NONE, I_R_1) );
      end;
    end;

    { validate on rank }
    if (nCntOfRank + NumberExternalCards) < 5 then Continue;

    Numerator := aSpecCards.IsInCards(aExCards);
    if (Numerator > 0) then begin { 5 cards if found }
      { recalc for suits }
      Numerator := 1;
      nExCnt := 0;
      for I_R_1:=I_R to TCardRankType(Integer(I_R) + 5 - 1) do begin
        if (aPointCards.IsInCards(CST_NONE, I_R_1) <= 0) then begin
          nM := aExCards.CountOfRank(I_R_1);
          nExCnt := nExCnt + nM;
          Numerator := Numerator * nM;
        end;
      end;
      nCntOfRank := Min(5, nCntOfRank);

      nM := Max(5 - nCntOfRank, 0);
      nN := ExternalCards.Count - nExCnt;
      nM := NumberExternalCards - nM;
      if (nN >= 0) and (nM >= 0) and (nN >= nM) then
        Numerator := Numerator * Should(nN, nM)
      else
        Numerator := 0;

      for J := aSpecCards.Count - 1 downto 0 do begin
        aCard := aSpecCards.Items[J];
        aPointCards.Add( TCard.Create(aCard) );
        aSpecCards.Remove(aCard);
      end;

      nPoints := CardsToPoints(VL_STRAIGHT, aPointCards);
      if (nPoints > MaxPoints) then MaxPoints := nPoints;
      nProbability := Numerator / Denominator;
      Probability := Probability + nProbability;
      RankSumProbabilityPoints := RankSumProbabilityPoints + nPoints * nProbability;
    end;
    { delete from aExCards all current suit cards }
    for I:=aExCards.Count - 1 downto 0 do begin
      aCard := aExCards.Items[I];
      if (aCard.Rank = I_R) then aExCards.Remove(aCard);
    end;
  end;
  aSpecCards.Free;
  aPointCards.Free;
  aCards.Free;
  aExCards.Free;
end;

procedure Hi_SearchFlushProbability(CardList, ExternalCards : TCardList; NumberExternalCards: Integer;
  var MaxPoints: Int64; var Probability, RankSumProbabilityPoints: Double);
var
  aCards, aExCards, aPointCards: TCardList;
  I, nCntOfSuits, nExCntOfSuits,
  nN, nM: Integer;
  aCard: TCard;
  I_S: TCardSuitType;
  nPoints: Int64;
  nProbability, Numerator, Denominator: Double;
begin
  MaxPoints   := 0;
  Probability := 0;
  RankSumProbabilityPoints := 0;
  if (CardList.Count + NumberExternalCards) < 5 then Exit;
  if (NumberExternalCards < 0) then NumberExternalCards := 0;

  aCards := TCardList.Create(False);
  aExCards := TCardList.Create(False);

  { create memory CardList }
  for I:=0 to CardList.Count - 1 do begin
    aCard := CardList.Items[I];
    aCards.Add(aCard);
  end;
  { Fillind aExCards  }
  for I:=0 to ExternalCards.Count - 1 do begin
    aCard := ExternalCards.Items[I];
    aExCards.Add(aCard);
  end;

  { Special case }
  if (aCards.Count >= 5) then begin
    aCards.Sort(ST_RANK_HI);
    if SearchFlush(aCards, CT_HI, nPoints) then begin
      MaxPoints := nPoints;
      Probability := 1;
      RankSumProbabilityPoints := MaxPoints * Probability;

      aCards.Free;
      aExCards.Free;

      Exit;
    end;
  end;

  Denominator := Should(ExternalCards.Count, NumberExternalCards);

  { for every card }
  aPointCards := TCardList.Create(False);
  for I_S:=CST_SPADES to CST_DIAMANDS do begin // for every suit
    nCntOfSuits   := aCards.CountOfSuit(I_S);
    nExCntOfSuits := aExCards.CountOfSuit(I_S);
    if (nCntOfSuits + NumberExternalCards) < 5 then Continue;
    if (nCntOfSuits + nExCntOfSuits) < 5 then Continue;

    nCntOfSuits   := Min(5, nCntOfSuits);

    nN := nExCntOfSuits;
    nM := 5-nCntOfSuits;
    if (nM >= 0) and (nN >= 0) and (nN >= nM) then
      Numerator := Should(nN, nM)
    else
      Numerator := 0;

    if (Numerator <= 0) then Continue;

    nM := Max(5 - nCntOfSuits, 0);
    if (nM = 0) then begin
      nN := ExternalCards.Count;
      nM := NumberExternalCards;
    end else begin
      nN := ExternalCards.Count - nExCntOfSuits;
      nM := NumberExternalCards - nM; // without needing suits
    end;
    if (nM >= 0) and (nN >= 0) and (nN >= nM) then
      Numerator := Numerator * Should(nN, nM)
    else
      Numerator := 1;

    { define better cards for current I_S }
    aPointCards.Clear;
    for I:=aCards.Count - 1 downto 0 do begin
      aCard := aCards.Items[I];
      if (aCard.Suit = I_S) then begin
        aPointCards.Add(aCard);
        aCards.Remove(aCard);
      end;
    end;
    for I:=aExCards.Count - 1 downto 0 do begin
      aCard := aExCards.Items[I];
      if (aCard.Suit = I_S) then begin
        aPointCards.Add(aCard);
        aExCards.Remove(aCard);
      end;
    end;

    aPointCards.Sort(ST_RANK_HI);
    if (aPointCards.Count < 5) then Continue;
    for I:=aPointCards.Count - 1 downto 5 do
      aPointCards.Remove(aPointCards.Items[I]);

    nPoints := CardsToPoints(VL_FLUSH, aPointCards);
    if (nPoints > MaxPoints) then MaxPoints := nPoints;
    nProbability := Numerator / Denominator;
    Probability := Probability + nProbability;
    RankSumProbabilityPoints := RankSumProbabilityPoints + nPoints * nProbability;

    { remove All cards of current suit from aExCards }
    for I:=aExCards.Count - 1 downto 0 do begin
      aCard := aExCards.Items[I];
      if (aCard.Suit = I_S) then aExCards.Remove(aCard);
    end;
  end;
  aPointCards.Free;
  aCards.Free;
  aExCards.Free;
end;

procedure Hi_SearchFourOfAKindProbability(CardList, ExternalCards : TCardList; NumberExternalCards: Integer;
  var MaxPoints: Int64; var Probability, RankSumProbabilityPoints: Double);
begin
  Hi_SearchAnyOfAKindProbability(CardList, ExternalCards, NumberExternalCards, 4,
    MaxPoints, Probability, RankSumProbabilityPoints);
end;

procedure Hi_SearchThreeOfAKindProbability(CardList, ExternalCards : TCardList; NumberExternalCards: Integer;
  var MaxPoints: Int64; var Probability, RankSumProbabilityPoints: Double);
begin
  Hi_SearchAnyOfAKindProbability(CardList, ExternalCards, NumberExternalCards, 3,
    MaxPoints, Probability, RankSumProbabilityPoints);
end;

procedure Hi_SearchOnePairProbability(CardList, ExternalCards : TCardList; NumberExternalCards: Integer;
  var MaxPoints: Int64; var Probability, RankSumProbabilityPoints: Double);
begin
  Hi_SearchAnyOfAKindProbability(CardList, ExternalCards, NumberExternalCards, 2,
    MaxPoints, Probability, RankSumProbabilityPoints);
end;

procedure Hi_SearchAnyOfAKindProbability(CardList, ExternalCards : TCardList; NumberExternalCards, TypeKind: Integer;
  var MaxPoints: Int64; var Probability, RankSumProbabilityPoints: Double);
var
  aCards, aExCards, aPointCards: TCardList;
  I, nCntOfRanks, nExCntOfRanks,
  nM, nN: Integer;
  aCard: TCard;
  I_R, I_R_2: TCardRankType;
  nMemProb, Numerator, Denominator: Double;
  Probabilities: array [CRT_ACE..CRT_TWO] of Double;
  Points: array [CRT_ACE..CRT_TWO] of Int64;
  nPoints: Int64;
  IsHiCombination: Boolean;

  bNeedRecalc: Boolean;
begin
  MaxPoints      := 0;
  Probability := 0;
  RankSumProbabilityPoints := 0;
  if (TypeKind < 2) then TypeKind := 2;
  if (TypeKind > 4) then TypeKind := 4;
  if (CardList.Count + NumberExternalCards) < TypeKind then Exit;
  if (NumberExternalCards < 0) then NumberExternalCards := 0;

  aCards := TCardList.Create(False);
  aExCards := TCardList.Create(False);

  { create memory CardList }
  for I:=0 to CardList.Count - 1 do begin
    aCard := CardList.Items[I];
    aCards.Add(aCard);
  end;
  { Fillind aExCards  }
  for I:=0 to ExternalCards.Count - 1 do begin
    aCard := ExternalCards.Items[I];
    aExCards.Add(aCard);
  end;

  { Special case }
  if (aCards.Count >= TypeKind) then begin
    aCards.Sort(ST_RANK_HI);
    nPoints := 0;
    IsHiCombination := False;
    case TypeKind of
      2: IsHiCombination := SearchOnePair(aCards, CT_HI, nPoints);
      3: IsHiCombination := SearchThreeOfAKind(aCards, CT_HI, nPoints);
      4: IsHiCombination := SearchFourOfAKind(aCards, CT_HI, nPoints);
    end;

    if IsHiCombination then begin
      MaxPoints := nPoints;
      Probability := 1;
      RankSumProbabilityPoints := MaxPoints * Probability;

      aCards.Free;
      aExCards.Free;

      Exit;
    end;
  end;

  if (aExCards.Count <= 0) then begin
    aCards.Free;
    aExCards.Free;

    Exit;
  end;

  nN := ExternalCards.Count;
  nM := NumberExternalCards;
  if (nN <= nM) then Denominator := 1 else Denominator := Should(nN, nM);

  bNeedRecalc := (NumberExternalCards >= (TypeKind * 2));

  { for every card }
  aPointCards := TCardList.Create(False);
  for I_R:=CRT_ACE to CRT_TWO do begin // for every ranks
    Probabilities[I_R] := 0;
    nCntOfRanks   := Min(aCards.CountOfRank(I_R), TypeKind);
    nExCntOfRanks := aExCards.CountOfRank(I_R);

    if (nCntOfRanks + NumberExternalCards) < TypeKind then Continue;
    if (nCntOfRanks + Min( Min(nExCntOfRanks, TypeKind), NumberExternalCards )) < TypeKind then Continue;

    nN := nExCntOfRanks;
    nM := TypeKind - nCntOfRanks;
    if (nN >= 0) and (nM >= 0) and (nN >= nM) then
      Numerator := Should(nN, nM)
    else
      Numerator := 0;

    if (Numerator <= 0) then Continue;

    nM := TypeKind - nCntOfRanks;
    if (nM = 0) then begin
      nN := ExternalCards.Count;
      nM := NumberExternalCards;
    end else begin
      nN := ExternalCards.Count - nExCntOfRanks;
      nM := NumberExternalCards - nM;
    end;
    if (nN >= 0) and (nM >= 0) and (nN >= nM) then Numerator := Numerator * Should(nN, nM);

    { define better cards for current I_R }
    aPointCards.Clear;
    GetHiCardsForAnyOfAKind(aCards, aExCards, aPointCards, I_R, NumberExternalCards, TypeKind);
    if (aPointCards.Count < TypeKind) then Continue;

    case TypeKind of
      2: Points[I_R] := CardsToPoints(VL_ONE_PAIR, aPointCards);
      3: Points[I_R] := CardsToPoints(VL_THREE_OF_A_KIND, aPointCards);
      4: Points[I_R] := CardsToPoints(VL_FOUR_OF_A_KIND, aPointCards);
    end;
    MaxPoints := Max(Points[I_R], MaxPoints);
    Probabilities[I_R] := Numerator / Denominator;

    { remove from memory external cards for current rank for speed}
    for I:=aExCards.Count - 1 downto 0 do begin
      aCard := aExCards.Items[I];
      if (aCard.Rank = I_R) then aExCards.Remove(aCard);
    end;
  end;

  aPointCards.Free;
  aCards.Free;
  aExCards.Free;

  Probability := 0;
  for I_R:=CRT_ACE to CRT_TWO do begin
    nMemProb := Probabilities[I_R];
    if bNeedRecalc then begin
      for I_R_2:=CRT_ACE to CRT_TWO do begin
        if (I_R = I_R_2) then Continue;
        if Probabilities[I_R] < 1 then begin
          nMemProb := nMemProb * (1 - Probabilities[I_R_2]);
        end;
      end;
    end;
    Probability := Probability + nMemProb;
    RankSumProbabilityPoints := RankSumProbabilityPoints + Points[I_R] * nMemProb;
  end;
end;

procedure GetHiCardsForAnyOfAKind(CardList, ExternalCards, HiCards: TCardList;
  CurrRank: TCardRankType; NumberExternalCards, TypeKind: Integer);
var
  aCard,
  aMaxCard_1, aMaxCard_2, aMaxCard_3,
  aExMaxCard_1, aExMaxCard_2, aExMaxCard_3: TCard;
  I: Integer;
  aMaxCards: TCardList;
begin
  HiCards.Clear;

  { get 3 not kind max cards in CardList }
  aMaxCard_1 := nil;
  aMaxCard_2 := nil;
  aMaxCard_3 := nil;
  for I:=CardList.Count - 1 downto 0 do begin
    aCard := CardList.Items[I];
    if (aCard.Rank = CurrRank) and (HiCards.Count < TypeKind) then begin
      HiCards.Add(aCard);
    end else begin
      if (aMaxCard_1 = nil) then begin
        aMaxCard_3 := aMaxCard_2;
        aMaxCard_2 := aMaxCard_1;
        aMaxCard_1 := aCard;
      end else if (aMaxCard_1.Rank > aCard.Rank) then begin
        aMaxCard_3 := aMaxCard_2;
        aMaxCard_2 := aMaxCard_1;
        aMaxCard_1 := aCard;
      end else if (aMaxCard_2 = nil) then begin
        aMaxCard_3 := aMaxCard_2;
        aMaxCard_2 := aCard;
      end else if (aMaxCard_2.Rank > aCard.Rank) then begin
        aMaxCard_3 := aMaxCard_2;
        aMaxCard_2 := aCard;
      end else if (aMaxCard_3 = nil) then begin
        aMaxCard_3 := aCard;
      end else if (aMaxCard_3.Rank > aCard.Rank) then begin
        aMaxCard_3 := aCard;
      end;
    end;
  end;
  for I:=CardList.Count - 1 downto 0 do begin
    aCard := CardList.Items[I];
    if (aCard.Rank = CurrRank) then CardList.Remove(aCard);
  end;

  { in external cards }
  aExMaxCard_1 := nil;
  aExMaxCard_2 := nil;
  aExMaxCard_3 := nil;
  if (NumberExternalCards > 0) then begin
    for I:=ExternalCards.Count - 1 downto 0 do begin
      aCard := ExternalCards.Items[I];
      if (aCard.Rank = CurrRank) and (HiCards.Count < TypeKind) then begin
        HiCards.Add(aCard);
      end else begin
        if (aExMaxCard_1 = nil) then begin
          aExMaxCard_3 := aExMaxCard_2;
          aExMaxCard_2 := aExMaxCard_1;
          aExMaxCard_1 := aCard;
        end else if (aExMaxCard_1.Rank > aCard.Rank) then begin
          aExMaxCard_3 := aExMaxCard_2;
          aExMaxCard_2 := aExMaxCard_1;
          aExMaxCard_1 := aCard;
        end else if (aExMaxCard_2 = nil) then begin
          aExMaxCard_3 := aExMaxCard_2;
          aExMaxCard_2 := aCard;
        end else if (aExMaxCard_2.Rank > aCard.Rank) then begin
          aExMaxCard_3 := aExMaxCard_2;
          aExMaxCard_2 := aCard;
        end else if (aExMaxCard_3 = nil) then begin
          aExMaxCard_3 := aCard;
        end else if (aExMaxCard_3.Rank > aCard.Rank) then begin
          aExMaxCard_3 := aCard;
        end;
        { check on break }
        if (HiCards.Count < TypeKind) then Continue;
        if (aExMaxCard_1.Rank = CRT_ACE) and ((NumberExternalCards = 1) or (TypeKind = 4)) then Break;
        if (aExMaxCard_2 <> nil) and (TypeKind = 3) then begin
          if (aExMaxCard_1.Rank = CRT_ACE) and (aExMaxCard_2.Rank = CRT_ACE) then Break;
        end;
        if (aExMaxCard_3 <> nil) and (TypeKind = 2) then begin
          if (aExMaxCard_1.Rank = CRT_ACE) and
             (aExMaxCard_2.Rank = CRT_ACE) and
             (aExMaxCard_3.Rank = CRT_ACE)
          then Break;
        end;
      end;
    end;
  end;

  if (  aMaxCard_1 = nil) and (  aMaxCard_2 = nil) and (  aMaxCard_3 = nil) and
     (aExMaxCard_1 = nil) and (aExMaxCard_2 = nil) and (aExMaxCard_3 = nil)
  then Exit;

  aMaxCards := TCardList.Create(False);

  if (aMaxCard_1 <> nil) then aMaxCards.Add(aMaxCard_1);
  if (aMaxCard_2 <> nil) then aMaxCards.Add(aMaxCard_2);
  if (aMaxCard_3 <> nil) then aMaxCards.Add(aMaxCard_3);

  if (NumberExternalCards = 1) then begin
    if (aExMaxCard_1 <> nil) then aMaxCards.Add(aExMaxCard_1);
  end else if (NumberExternalCards = 2) then begin
    if (aExMaxCard_1 <> nil) then aMaxCards.Add(aExMaxCard_1);
    if (aExMaxCard_2 <> nil) then aMaxCards.Add(aExMaxCard_2);
  end else if (NumberExternalCards > 2) then begin
    if (aExMaxCard_1 <> nil) then aMaxCards.Add(aExMaxCard_1);
    if (aExMaxCard_2 <> nil) then aMaxCards.Add(aExMaxCard_2);
    if (aExMaxCard_3 <> nil) then aMaxCards.Add(aExMaxCard_3);
  end;
  aMaxCards.Sort(ST_RANK_HI);
  for I:=0 to Min(aMaxCards.Count - 1, 4-TypeKind) do HiCards.Add(aMaxCards.Items[I]);

  aMaxCards.Free;
end;

procedure GetHiCardsForAnyPairAKind(CardList, ExternalCards, HiCards: TCardList;
  FirstRank, SecondRank: TCardRankType; NumberExternalCards, FirstKind: Integer);
var
  aCard, aFirstPair, aSecondPair,
  aMaxCard, aExMaxCard: TCard;
  I, nCnt_1, nCnt_2, SecondKind: Integer;
  aMaxCards: TCardList;
begin
  HiCards.Clear;
  if not (FirstKind in [2,3]) then Exit;
  SecondKind := 2;

  aMaxCard   := nil;
  aExMaxCard := nil;
  nCnt_1 := 0;
  nCnt_2 := 0;

  { get 1 not kinds max cards in CardList }
  for I:=CardList.Count - 1 downto 0 do begin
    aCard := CardList.Items[I];
    if (aCard.Rank = FirstRank) and (nCnt_1 < FirstKind) then begin
      HiCards.Add(aCard);
      Inc(nCnt_1);
    end else if (aCard.Rank = SecondRank) and (nCnt_2 < SecondKind) then begin
      HiCards.Add(aCard);
      Inc(nCnt_2);
    end else if (FirstKind = 2) then begin
      if (aMaxCard = nil) then aMaxCard := aCard else
      if (aMaxCard.Rank > aCard.Rank) then aMaxCard := aCard;
    end;
  end;

  { in external cards }
  if (NumberExternalCards > 0) and ((nCnt_1 < FirstKind) or (nCnt_2 < SecondKind)) then begin
    for I:=ExternalCards.Count - 1 downto 0 do begin
      aCard := ExternalCards.Items[I];
      if (aCard.Rank = FirstRank) and (nCnt_1 < FirstKind) then begin
        HiCards.Add(aCard);
        Inc(nCnt_1);
      end else if (aCard.Rank = SecondRank) and (nCnt_2 < SecondKind) then begin
        HiCards.Add(aCard);
        Inc(nCnt_2);
      end else if (FirstKind = 2) then begin
        if (aExMaxCard = nil) then aExMaxCard := aCard else
        if (aExMaxCard.Rank > aCard.Rank) then aExMaxCard := aCard;
        { check on break }
        if (nCnt_1 >= FirstKind) and (nCnt_2 >= SecondKind) then begin
          if (FirstKind > 2) then begin
            Break;
          end else begin
            if (aExMaxCard <> nil) then
              if (aExMaxCard.Rank = CRT_ACE) then Break;
          end;
        end;
      end else begin
        { check on break }
        if (nCnt_1 >= FirstKind) and (nCnt_2 >= SecondKind) then Break;
      end;
    end;
  end;

  { sort by rank for any pair of a kind}
  HiCards.Sort(ST_RANK_HI);
  aFirstPair  := HiCards.Items[0];
  aSecondPair := HiCards.Items[HiCards.Count-1];
  if (FirstKind = 2) then begin
    if (aFirstPair.Rank > aSecondPair.Rank) then begin
      for I:=0 to 1 do begin
        aCard := HiCards.Items[0];
        HiCards.Remove(aCard);
        HiCards.Add(aCard);
      end;
    end;
  end else begin
    nCnt_1 := HiCards.CountOfRank(aFirstPair.Rank);
    nCnt_2 := HiCards.CountOfRank(aSecondPair.Rank);
    if (nCnt_1 < nCnt_2) then begin
      for I:=0 to 1 do begin
        aCard := HiCards.Items[0];
        HiCards.Remove(aCard);
        HiCards.Add(aCard);
      end;
    end;
  end;

  { define max card among a[XX]MaxCard only for 2x2 }
  if (FirstKind > 2) then Exit;
  if (aMaxCard = nil) and (aExMaxCard = nil) then Exit;

  aMaxCards := TCardList.Create(False);

  if (  aMaxCard <> nil) then aMaxCards.Add(aMaxCard);
  if (aExMaxCard <> nil) then aMaxCards.Add(aExMaxCard);
  aMaxCards.Sort(ST_RANK_HI);
  HiCards.Add(aMaxCards.Items[0]);

  aMaxCards.Free;
end;

procedure Hi_SearchAnyOfPairAKindProbability(CardList, ExternalCards : TCardList;
  NumberExternalCards, FirstKind: Integer;
  var MaxPoints: Int64; var Probability, RankSumProbabilityPoints: Double);
var
  aCards, aExCards, aPointCards: TCardList;
  I, nCnt_1, nCnt_2,
  nExCnt_1, nExCnt_2,
  SecondKind, nRemoveFirst, nRemoveSecond,
  nN, nM: Integer;
  aCard: TCard;
  I_R_1, I_R_2, I_R_3, I_R_4: TCardRankType;
  nPoints: Int64;
  nProbability, Numerator, Denominator: Double;

  arrProbabilies: array [CRT_ACE..CRT_TWO, CRT_ACE..CRT_TWO] of Double;
  arrPoints: array [CRT_ACE..CRT_TWO, CRT_ACE..CRT_TWO] of Int64;
  bNeedRecalc: Boolean;
  IsHiCombination: Boolean;
begin
  MaxPoints   := 0;
  Probability := 0;
  RankSumProbabilityPoints := 0;
  if not (FirstKind in [2,3]) then Exit;
  SecondKind := 2;
  if (CardList.Count + NumberExternalCards) < (FirstKind + SecondKind) then Exit;
  if (NumberExternalCards < 0) then NumberExternalCards := 0;

  aCards := TCardList.Create(False);
  aExCards := TCardList.Create(False);

  { create memory CardList }
  for I:=0 to CardList.Count - 1 do begin
    aCard := CardList.Items[I];
    aCards.Add(aCard);
  end;
  { Fillind aExCards  }
  for I:=0 to ExternalCards.Count - 1 do begin
    aCard := ExternalCards.Items[I];
    aExCards.Add(aCard);
  end;

  { Special case }
  if (aCards.Count >= 4) then begin
    aCards.Sort(ST_RANK_HI);
    case FirstKind of
      2: IsHiCombination := SearchTwoPair(aCards, CT_HI, nPoints);
      3: IsHiCombination := SearchFullHouse(aCards, CT_HI, nPoints);
    else
      Exit;
    end;
    if IsHiCombination then begin
      MaxPoints := nPoints;
      Probability := 1;
      RankSumProbabilityPoints := MaxPoints * Probability;

      aCards.Free;
      aExCards.Free;

      Exit;
    end;
  end;

  if (aExCards.Count <= 0) then begin
    aCards.Free;
    aExCards.Free;

    Exit;
  end;

  Denominator := Should(ExternalCards.Count, NumberExternalCards);

  bNeedRecalc := (NumberExternalCards >= (FirstKind + 2 * SecondKind));

  { for every card }
  aPointCards := TCardList.Create(False);
  for I_R_1:=CRT_ACE to CRT_TWO do begin // for every ranks first of pair
    for I_R_2:=CRT_ACE to CRT_TWO do begin // for every ranks second of pair

      arrProbabilies[I_R_1, I_R_2] := 0;
      arrPoints[I_R_1, I_R_2] := 0;

      { check on bounds }
      if (I_R_1 = I_R_2) then Continue;
      if (FirstKind = 2) and ((I_R_2 <= I_R_1) or (I_R_1 > CRT_THREE)) then Continue;

      nCnt_1   := Min(aCards.CountOfRank(I_R_1), FirstKind);
      nCnt_2   := Min(aCards.CountOfRank(I_R_2), SecondKind);
      nExCnt_1 := aExCards.CountOfRank(I_R_1);
      nExCnt_2 := aExCards.CountOfRank(I_R_2);

      { validate on two of kind }
      if ((nCnt_1 + nCnt_2 + NumberExternalCards) < (FirstKind + SecondKind)) then Continue;
      nN := nCnt_1 + Min( Min(nExCnt_1, FirstKind ), NumberExternalCards );
      if (nN < FirstKind ) then Continue;
      nN := nCnt_2 + Min( Min(nExCnt_2, SecondKind), NumberExternalCards );
      if (nN < SecondKind) then Continue;
        { define by rest NumberExternalCards }
      nM := FirstKind - nCnt_1; // need for first kind (can not be < 0)
      nN := nCnt_2 + Min( Min(nExCnt_2, SecondKind), NumberExternalCards - nM);
      if (nN < SecondKind) then Continue;

      { First Kind }
      nM := Max(FirstKind - nCnt_1, 0);
      nN := nExCnt_1;
      Numerator := 1;
      if (nN >= 0) and (nM >= 0) and (nN >= nM) then
        Numerator := Numerator * Should(nN, nM)
      else
        Continue;

      { Second Kind }
      nM := Max(SecondKind - nCnt_2, 0);
      nN := nExCnt_2;
      if (nN >= 0) and (nM >= 0) and (nN >= nM) then
        Numerator := Numerator * Should(nN, nM)
      else
        Continue;

      { rest of NumberExternalCards without First and Second Kind }
      nM := Max(FirstKind - nCnt_1, 0) + Max(SecondKind - nCnt_2, 0);
      if (nM = 0) then begin
        nM := NumberExternalCards;
        nN := ExternalCards.Count;
      end else begin
        nM := NumberExternalCards - nM;
        nN := ExternalCards.Count - nExCnt_1 - nExCnt_2;
      end;
      if (nN >= 0) and (nM >= 0) and (nN >= nM) then
        Numerator := Numerator * Should(nN, nM);

      { define better cards for current I_R }
      aPointCards.Clear;
      GetHiCardsForAnyPairAKind(aCards, aExCards, aPointCards,
        I_R_1, I_R_2, NumberExternalCards, FirstKind
      );
      if (aPointCards.Count < (FirstKind + SecondKind)) then Continue;

      /////////
      arrProbabilies[I_R_1, I_R_2] := (Numerator / Denominator);

      if (FirstKind = 2) then
        arrPoints[I_R_1, I_R_2] := CardsToPoints(VL_TWO_PAIR, aPointCards)
      else
        arrPoints[I_R_1, I_R_2] := CardsToPoints(VL_FULL_HOUSE, aPointCards);

      MaxPoints := Max(MaxPoints, arrPoints[I_R_1, I_R_2]);
    end;
  end;

  aPointCards.Free;
  aCards.Free;
  aExCards.Free;

  for I_R_1:=CRT_ACE to CRT_TWO do begin
    for I_R_2:=CRT_ACE to CRT_TWO do begin

      nProbability := arrProbabilies[I_R_1, I_R_2];
      { calculate the multiplied of probabilities }
      if bNeedRecalc then begin
        for I_R_3:=CRT_ACE to CRT_TWO do begin
          for I_R_4:=CRT_ACE to CRT_TWO do begin
            if (I_R_1 = I_R_3) and (I_R_2 = I_R_4) then Continue;
            if (arrProbabilies[I_R_1, I_R_2] < 1) then begin
              nProbability := nProbability * (1 - arrProbabilies[I_R_3, I_R_4]);
            end;
          end;
        end;
      end;

      Probability := Probability + nProbability;
      RankSumProbabilityPoints := RankSumProbabilityPoints + arrPoints[I_R_1, I_R_2] * nProbability;
    end;
  end;
end;

procedure Hi_SearchTwoPairProbability(CardList, ExternalCards : TCardList; NumberExternalCards: Integer;
  var MaxPoints: Int64; var Probability, RankSumProbabilityPoints: Double);
begin
  Hi_SearchAnyOfPairAKindProbability(CardList, ExternalCards, NumberExternalCards, 2,
    MaxPoints, Probability, RankSumProbabilityPoints);
end;

procedure Hi_SearchFullHouseProbability(CardList, ExternalCards : TCardList; NumberExternalCards: Integer;
  var MaxPoints: Int64; var Probability, RankSumProbabilityPoints: Double);
begin
  Hi_SearchAnyOfPairAKindProbability(CardList, ExternalCards, NumberExternalCards, 3,
    MaxPoints, Probability, RankSumProbabilityPoints);
end;

end.
