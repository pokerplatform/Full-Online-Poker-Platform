unit uCombinationProcessor;

interface

uses
//RTL
  Dialogs,
  Classes,
  SysUtils,
  Math,
  Contnrs,
//po
  uPokerDefs,
  uPokerBase
;


type
  TpoCardCombinationProcessor = class //not persistent - only calc duty
  private
    function LookingForFlushSuit(ACardCollection: TpoCardCollection): Integer;
    //
    function DetectRoyalFlush(ACardCollection: TpoCardCollection; var ACombinations: TpoCombinations):boolean;
    function DetectStraightFlush(ACardCollection: TpoCardCollection; var ACombinations: TpoCombinations):boolean;
    function DetectFourOfAKind(ACardCollection: TpoCardCollection; var ACombinations: TpoCombinations):boolean;
    function DetectFullHouse(ACardCollection: TpoCardCollection; var ACombinations: TpoCombinations):boolean;
    function DetectFlush(ACardCollection: TpoCardCollection; var ACombinations: TpoCombinations):boolean;
    function DetectStraight(ACardCollection: TpoCardCollection; var ACombinations: TpoCombinations):boolean;
    function DetectThreeOfAKind(ACardCollection: TpoCardCollection; var ACombinations: TpoCombinations):boolean;
    function DetectTwoPair(ACardCollection: TpoCardCollection; var ACombinations: TpoCombinations):boolean;
    function DetectOnePair(ACardCollection: TpoCardCollection; var ACombinations: TpoCombinations):boolean;
    function DetectHighCard(ACardCollection: TpoCardCollection; var ACombinations: TpoCombinations):boolean;
    //
    function DetectStraightFlushWithAceAsOne(ACardCollection: TpoCardCollection; var ACombinations: TpoCombinations):boolean;
    function DetectStraightWithAceAsOne(ACardCollection: TpoCardCollection; var ACombinations: TpoCombinations):boolean;
    //
    function DetectLowCombination(ACardCollection: TpoCardCollection; ACombinations: TpoCombinations): boolean;

  protected
    FCardPack: TpoCardPack;

  public
    function DetectCombinations(aSharedCards, aUserCards: TpoCardCollection; var aResultCombinations:  TpoCombinations): TpoCombinations;

  //generic
    constructor Create(aCardPack: TpoCardPack);
  end;//TpoCardCombinationProcessor

implementation

{ TpoCardCombinationProcessor }

constructor TpoCardCombinationProcessor.Create(aCardPack: TpoCardPack);
begin
  inherited Create;
  FCardPack:= aCardPack;
end;


function TpoCardCombinationProcessor.DetectCombinations(aSharedCards,
  aUserCards: TpoCardCollection; var aResultCombinations:  TpoCombinations): TpoCombinations;
type
  massiv = array of integer;
var
//  Combination     : TpoCardCombination;
  TempCollection: TpoCardCollection;
  Loop            : Integer;
  Loop1           : Integer;
  Loop2           : Integer;
  SharedArray     : Array of massiv;
  UserArray       : Array of massiv;

  xArray    : massiv;
  I, k, m, n: integer;

  Function Search1(x: massiv):boolean;
  Var
    I: integer;
  begin
    Search1 := false;
    for I :=m downto 1 do
      if x[I] <> n-m+I then
      begin
        Search1 := true;
        Break;
      end;
  end;

  Function Search2 (x: massiv): integer;
  Var
    I: integer;
  begin
    I :=m;
    While (x[I] = n-m+I) and (I>0) do
      I:=I-1;
    Search2 := I;
  end;

  procedure AddSharedPositions;
  var
    I: Integer;
  begin
    SetLength(SharedArray, Length(SharedArray)+1);
    SetLength(SharedArray[Length(SharedArray)-1], Length(xArray)-1);
    for I:=1 to Length(xArray)-1 do
      SharedArray[Length(SharedArray)-1][I-1] := xArray[I];
  end;

  procedure AddUserPositions;
  var
    I: Integer;
  begin
    SetLength(UserArray, Length(UserArray)+1);
    SetLength(UserArray[Length(UserArray)-1], Length(xArray)-1);
    for I:=1 to Length(xArray)-1 do
      UserArray[Length(UserArray)-1][I-1] := xArray[I];
  end;

begin

  if aSharedCards <> nil then
  begin
    m := aSharedCards.ActiveCards;
    n := aSharedCards.Count;
  end
  else
  begin
    m := 0;
    n := 0;
  end;

  SetLength(xArray, m+1);

  for I:=1 to m do xArray[I]:=I;
  AddSharedPositions;

  while Search1(xArray) do
  begin
      k:= Search2(xArray);
      xArray[k]:= xArray[k]+1;
      for I:=k+1 to m do
        xArray[I]:= xArray[I-1]+1;
      AddSharedPositions;
  end;

  if aUserCards = nil then
    Exit;
  if aUserCards.Count = 0 then
    Exit;
  if aUserCards.ActiveCards = 0 then
    Exit;

  m := aUserCards.ActiveCards;
  n := aUserCards.Count;

  SetLength(xArray, m+1);

  for I:=1 to m do xArray[I]:=I;
  AddUserPositions;

  while Search1(xArray) do
  begin
      k:= Search2(xArray);
      xArray[k]:= xArray[k]+1;
      for I:=k+1 to m do
        xArray[I]:= xArray[I-1]+1;
      AddUserPositions;
   end;

  Result := aResultCombinations;//TpoCombinations.Create(FCardPack);
  aResultCombinations.ClearAndFree;
  Result.Clear;



  for Loop1 := 0 to Length(UserArray)-1 do
  begin
    for Loop2 := 0 to Length(SharedArray)-1 do
    begin
      { got card numbers in the }
      { creating temporary cards collection }
      TempCollection := TpoCardCollection.Create(FCardPack);

      { copy cards from shared collection to the temporary collection }
      for Loop := 0 to Length(UserArray[Loop1])-1 do
        TempCollection.AttachCard(aUserCards.Cards[ UserArray[Loop1][Loop] - 1 ]);

      { add cards from the user collection the the temporary collection }
      for Loop := 0 to Length(SharedArray[Loop2])-1 do
        TempCollection.AttachCard(aSharedCards.Cards[ SharedArray[Loop2][Loop] - 1 ]);

      { sorting cards by value }
      TempCollection.Sort;

      if not DetectRoyalFlush(TempCollection, Result) then
      if not DetectStraightFlush(TempCollection, Result) then
      if not DetectStraightFlushWithAceAsOne(TempCollection, Result) then
      if not DetectFourOfAKind(TempCollection, Result) then
      if not DetectFullHouse(TempCollection, Result) then
      if not DetectFlush(TempCollection, Result) then
      if not DetectStraight(TempCollection, Result) then
      if not DetectStraightWithAceAsOne(TempCollection, Result) then
      if not DetectThreeOfAKind(TempCollection, Result) then
      if not DetectTwoPair(TempCollection, Result) then
      if not DetectOnePair(TempCollection, Result) then
        DetectHighCard(TempCollection, Result);

      DetectLowCombination(TempCollection, Result);

      { releasing temporary card collection }
      TempCollection.Free;
    end;
  end;

  { sorting combinations collection }
  Result.Sort;

  { leaving only Hi and Lo hands }
  Loop1 := 1;
  if (Result.Count>1) and (Result.Combinations[Result.Count-1].Kind in [CCK_WHEEL, CCK_HIGH_CARD])
    and (Result.Combinations[Result.Count-1].Cards[0].Value < CV_9) then Loop1 := 2;

  while Result.Count > Loop1 do
  begin
    Result.Combinations[1].Free;
    Result.Delete(1);
  end;

  SetLength(UserArray,0);
  SetLength(SharedArray,0);
end;

function TpoCardCombinationProcessor.DetectFlush(ACardCollection: TpoCardCollection;
  var ACombinations: TpoCombinations):boolean;
var
  Loop  : Integer;
//  SpadeCnt  :Integer;
//  ClubCnt   :Integer;
//  HeartCnt  :Integer;
//  DiamondCnt:Integer;

  FlushSuit : TpoCardSuit;
  ACardCombination: TpoCardCombination;
  aCard: TpoCard;
begin
  Result := FALSE;

  if ACardCollection.Count < 5 then Exit;

  { Looking for the flush suit }
  Loop := LookingForFlushSuit(ACardCollection);
  if (Loop < 0) then
    // flush suit not found
    Exit
  else
    FlushSuit := TpoCardSuit(Loop);

  ACardCombination := TpoCardCombination.Create(FCardPack);
(*
  { Looking for the flush suit }
  SpadeCnt  :=0;
  ClubCnt   :=0;
  HeartCnt  :=0;
  DiamondCnt:=0;

  for Loop := 0 to ACardCollection.Count-1 do
  begin
    aCard := ACardCollection.Cards[Loop];

    if aCard.Suit = CS_SPADE    then Inc(SpadeCnt)   else
    if aCard.Suit = CS_HEART    then Inc(HeartCnt)   else
    if aCard.Suit = CS_DIAMOND  then Inc(DiamondCnt) else
    if aCard.Suit = CS_CLUB     then Inc(ClubCnt);

    if (SpadeCnt > 4) or (HeartCnt > 4) or (DiamondCnt > 4) or (ClubCnt > 4) then Break;
  end;

  if (SpadeCnt   > 4) then FlushSuit := CS_SPADE   else
  if (HeartCnt   > 4) then FlushSuit := CS_HEART   else
  if (DiamondCnt > 4) then FlushSuit := CS_DIAMOND else
  if (ClubCnt    > 4) then FlushSuit := CS_CLUB    else
  begin
    { stop scanning           }
    ACardCombination.Clear;
    ACardCombination.Free;
    Exit;
  end;
*)
  ACardCombination.Clear;

  for Loop := 0 to ACardCollection.Count-1 do begin
    aCard := ACardCollection.Cards[Loop];
    if aCard.Suit = FlushSuit then begin
      ACardCombination.AttachCard(aCard);
        if ACardCombination.Count = 5 then Break;
    end;
  end;

  ACardCombination.Kind := CCK_FLUSH;

  { adding to the collection }
  ACombinations.AddCombination(ACardCombination);

  Result := TRUE;
end;

function TpoCardCombinationProcessor.DetectFourOfAKind(ACardCollection: TpoCardCollection;
  var ACombinations: TpoCombinations):boolean;
var
  Loop  : Integer;
  ACardCombination: TpoCardCombination;
  aCardCmb, aCard: TpoCard;
begin
  Result := FALSE;

  if ACardCollection.Count < 4 then Exit;

  ACardCombination := TpoCardCombination.Create(FCardPack);
  aCardCmb := ACardCollection.Cards[0];
  ACardCombination.AttachCard(aCardCmb);

  for Loop:=1 to ACardCollection.Count-1 do begin
    aCard := ACardCollection.Cards[Loop];

    if (aCardCmb.Value = aCard.Value ) then begin
      aCardCmb := aCard;
      ACardCombination.AttachCard(aCardCmb);
    end else begin
      if (ACardCombination.Count < 4) then begin
        ACardCombination.Clear;
        aCardCmb := aCard;
        ACardCombination.AttachCard(aCardCmb);
      end else begin
        Break;
      end;
    end;
  end;

  if ACardCombination.Count<4 then
  begin
    { there is no combination }
    { stop scanning           }
    ACardCombination.Clear;
    ACardCombination.Free;
    Exit;
  end;

  { looking for a high card }
  aCardCmb := ACardCombination.Cards[0];
  for Loop:=0 to ACardCollection.Count-1 do
  begin
    aCard := ACardCollection.Cards[Loop];

    if (aCard.Value <> aCardCmb.Value) then
    begin
      ACardCombination.AttachCard(aCard);
      Break;
    end;
  end;

  ACardCombination.Kind := CCK_4_OF_A_KIND;

  { add to the collection }
  ACombinations.AddCombination(ACardCombination);

  Result := TRUE;
end;

function TpoCardCombinationProcessor.DetectFullHouse(ACardCollection: TpoCardCollection;
  var ACombinations: TpoCombinations):boolean;
var
  Loop  : Integer;
  ACardCombination: TpoCardCombination;
  aCard_0, aCard_1, aCard_2: TpoCard;
begin
  { looking for three of a king }
  Result := FALSE;

  if ACardCollection.Count < 5 then Exit;

  ACardCombination := TpoCardCombination.Create(FCardPack);

  for Loop := 2 to ACardCollection.Count-1 do begin
    aCard_2 := ACardCollection.Cards[Loop-2];
    aCard_1 := ACardCollection.Cards[Loop-1];
    aCard_0 := ACardCollection.Cards[Loop];

    if (aCard_0.Value = aCard_1.Value) and (aCard_0.Value = aCard_2.Value)
    then begin
      ACardCombination.AttachCard(aCard_2);
      ACardCombination.AttachCard(aCard_1);
      ACardCombination.AttachCard(aCard_0);
      Break;
    end;
  end;

  if (ACardCombination.Count < 3) then
  begin
    ACardCombination.Clear;
    ACardCombination.Free;
    Exit;
  end;

  aCard_0 := ACardCombination.Cards[0];
  for Loop := 1 to ACardCollection.Count-1 do begin
    aCard_1 := ACardCollection.Cards[Loop-1];
    aCard_2 := ACardCollection.Cards[Loop];

    if (aCard_0.Value = aCard_1.Value) or (aCard_0.Value = aCard_2.Value) then Continue;

    if (aCard_1.Value = aCard_2.Value) then begin
      ACardCombination.AttachCard(aCard_1);
      ACardCombination.AttachCard(aCard_2);
      Break;
    end;
  end;

  if (ACardCombination.Count < 5) then
  begin
    ACardCombination.Clear;
    ACardCombination.Free;
    Exit;
  end;

  ACardCombination.Kind := CCK_FULL_HOUSE;

  { add to the collection }
  ACombinations.AddCombination(ACardCombination);

  Result := TRUE;

end;

function TpoCardCombinationProcessor.DetectHighCard(ACardCollection: TpoCardCollection;
  var ACombinations: TpoCombinations):boolean;
var
  Loop  : Integer;
  ACardCombination: TpoCardCombination;
begin
  ACardCombination := TpoCardCombination.Create(FCardPack);

  for Loop:=0 to ACardCollection.Count-1 do
    if ACardCombination.Count<5 then
    begin
      ACardCombination.AttachCard(ACardCollection.Cards[Loop]);
    end;

  ACardCombination.Kind := CCK_HIGH_CARD;
  { add to the collection }
  ACombinations.AddCombination(ACardCombination);

  Result := TRUE;
end;

function TpoCardCombinationProcessor.DetectLowCombination(ACardCollection: TpoCardCollection;
  ACombinations: TpoCombinations): boolean;
var
  Loop  : Integer;
  aCard: TpoCard;
  ACardCombination: TpoCardCombination;
  bNeedReplaceAce, bIsWheel: Boolean;
begin
  Result := FALSE;

  if ACardCollection.Count < 5 then Exit;
  if ACombinations = nil then Exit;

  bNeedReplaceAce := (ACardCollection.Cards[0].Value = CV_ACE);

  if bNeedReplaceAce then begin
    ACardCollection.ReplaceCardsValue(CV_ACE, CV_1);
    ACardCollection.Sort;
  end;

    ACardCombination := TpoCardCombination.Create(FCardPack);

  for Loop:=0 to ACardCollection.Count - 1 do begin
    aCard := ACardCollection.Cards[Loop];
    if (aCard.Value >= CV_9) then Continue;
    { except pair of card }
    if (ACardCombination.Find(aCard.Value, aCard.Suit, ffValue) >= 0) then Continue;

    ACardCombination.AttachCard(aCard);
    if ACardCombination.Count >= 5 then Break;
  end;

  try
    if (ACardCombination.Count < 5) then begin
      ACardCombination.Clear;
      ACardCombination.Free;
      Exit;
    end;

    { Check on wheel }
    bIsWheel :=
      (ACardCollection.Find(CV_1, CS_CLUB, ffValue) >= 0) and
      (ACardCollection.Find(CV_2, CS_CLUB, ffValue) >= 0) and
      (ACardCollection.Find(CV_3, CS_CLUB, ffValue) >= 0) and
      (ACardCollection.Find(CV_4, CS_CLUB, ffValue) >= 0) and
      (ACardCollection.Find(CV_5, CS_CLUB, ffValue) >= 0);

    if bIsWheel then
      ACardCombination.Kind := CCK_WHEEL
    else
      ACardCombination.Kind := CCK_HIGH_CARD;
    ACombinations.AddCombination(ACardCombination);
  finally
    if bNeedReplaceAce then begin
      ACardCollection.ReplaceCardsValue(CV_1, CV_ACE);
      ACardCollection.Sort;
    end;
  end;
end;

function TpoCardCombinationProcessor.DetectOnePair(ACardCollection: TpoCardCollection; var ACombinations: TpoCombinations):boolean;
var
  Loop  : Integer;
  ACardCombination: TpoCardCombination;
  aCard_0, aCard_1: TpoCard;
begin
  Result := FALSE;

  if ACardCollection.Count < 2 then Exit;

  ACardCombination := TpoCardCombination.Create(FCardPack);

  for Loop:=1 to ACardCollection.Count-1 do begin
    aCard_1 := ACardCollection.Cards[Loop-1];
    aCard_0 := ACardCollection.Cards[Loop];
    if (aCard_1.Value = aCard_0.Value) then begin
      ACardCombination.AttachCard(aCard_1);
      ACardCombination.AttachCard(aCard_0);
      Break;
    end;
  end;

  if (ACardCombination.Count<2) then
  begin
    ACardCombination.Clear;
    ACardCombination.Free;
    Exit;
  end;

  aCard_0 := ACardCombination.Cards[0];
  for Loop:=0 to ACardCollection.Count - 1 do begin
    aCard_1 := ACardCollection.Cards[Loop];
    if (aCard_1.Value <> aCard_0.Value) then begin
      ACardCombination.AttachCard(aCard_1);
      if ACardCombination.Count >= 5 then Break;
    end;
  end;//for


  ACardCombination.Kind := CCK_ONE_PAIR;

  { add to the colleciton }
  ACombinations.AddCombination(ACardCombination);

  Result := TRUE;
end;

function TpoCardCombinationProcessor.DetectRoyalFlush(ACardCollection: TpoCardCollection;
    var ACombinations: TpoCombinations):boolean;
var
  FlushSuit       : TpoCardSuit;
  Loop            : Integer;
  CardPos         : Integer;
//  SpadeCnt        : Integer;
//  ClubCnt         : Integer;
//  HeartCnt        : Integer;
//  DiamondCnt      : Integer;

//  tmpCount        : Integer;
  CV              : TpoCardValue;
  ACardCombination: TpoCardCombination;
begin
  Result := FALSE;

  if ACardCollection.Count < 5 then Exit;

  { Looking for the flush suit }
  Loop := LookingForFlushSuit(ACardCollection);
  if (Loop < 0) then
    // flush suit not found
    Exit
  else
    FlushSuit := TpoCardSuit(Loop);
{
  SpadeCnt  :=0;
  ClubCnt   :=0;
  HeartCnt  :=0;
  DiamondCnt:=0;

  for Loop := 0 to ACardCollection.Count-1 do
  begin
    if ACardCollection.Cards[Loop].Suit = CS_SPADE then Inc(SpadeCnt)
    else if ACardCollection.Cards[Loop].Suit = CS_HEART then Inc(HeartCnt)
    else if ACardCollection.Cards[Loop].Suit = CS_DIAMOND then Inc(DiamondCnt)
    else if ACardCollection.Cards[Loop].Suit = CS_CLUB then Inc(ClubCnt);
  end;

  if SpadeCnt>4 then FlushSuit:=CS_SPADE
  else if HeartCnt>4 then FlushSuit:=CS_HEART
  else if DiamondCnt>4 then FlushSuit:=CS_DIAMOND
  else if ClubCnt>4 then FlushSuit:=CS_CLUB
  else Exit;
}
  ACardCombination := TpoCardCombination.Create(FCardPack);

  { flush suit has been found                      }
  { continue checking for  straigh from ten to ace }
  for CV:=CV_ACE downto CV_10 do
  begin
    CardPos := ACardCollection.Find(CV, FlushSuit, ffBoth);
    if ( CardPos>=0) then
    begin
      { adding card to the result collection }
      ACardCombination.AttachCard( ACardCollection.Cards[CardPos] );
    end
    else
    begin
      { releasing result collection }
      { and stop searching          }
      ACardCombination.Clear;
      ACardCombination.Free;
      Exit;
    end;
  end;

  ACardCombination.Kind := CCK_ROYAL_FLUSH;

  { adding combination to the collection }
  ACombinations.AddCombination(ACardCombination);

  Result := TRUE;

end;

function TpoCardCombinationProcessor.DetectStraight(ACardCollection: TpoCardCollection;
    var ACombinations: TpoCombinations):boolean;
var
  Loop  : Integer;
  ACardCombination: TpoCardCombination;
  aCardCmb, aCard: TpoCard;
begin
  Result := FALSE;

  if ACardCollection.Count < 5 then Exit;

  ACardCombination := TpoCardCombination.Create(FCardPack);
  aCardCmb := ACardCollection.Cards[0];
  ACardCombination.AttachCard(aCardCmb);

  { checking for straight flush }
  for Loop:=1 to ACardCollection.Count-1 do begin
    aCard := ACardCollection.Cards[Loop];

    if (Ord(aCardCmb.Value) - Ord(aCard.Value) = 1) then begin
      aCardCmb := aCard;
      ACardCombination.AttachCard(aCardCmb);
      if (ACardCombination.Count > 4) then Break;
    end else begin
      if (aCardCmb.Value = aCard.Value) then Continue;
      if (ACardCombination.Count < 4) then begin
        ACardCombination.Clear;
        aCardCmb := aCard;
        ACardCombination.AttachCard(aCardCmb);
      end;
    end;
  end;

  { checking for Lo hand ace }
  if (ACardCombination.Count = 4) and
     (ACardCollection.Find(CV_ACE, CS_SPADE, ffValue) >= 0 ) and
     (ACardCombination.Find(CV_2, CS_SPADE, ffValue) >= 0 )
  then begin
    { found low hand }
    { adding ace as low card }

    ACardCombination.AttachCard(
      ACardCollection.Cards[ACardCollection.Find(CV_ACE, CS_SPADE, ffValue)]
    );
  end;

  if ACardCombination.Count<5 then
  begin
    { there is no straight }
    { stop scanning        }
    ACardCombination.Clear;
    ACardCombination.Free;
    Exit;
  end;

  ACardCombination.Kind := CCK_STRAIGHT;

  { adding to the collection }
  ACombinations.AddCombination( ACardCombination );

  Result := TRUE;
end;

function TpoCardCombinationProcessor.DetectStraightFlush(ACardCollection: TpoCardCollection;
  var ACombinations: TpoCombinations): boolean;
var
  Loop      :Integer;
  ACardCombination: TpoCardCombination;
  aCardCmb, aCard: TpoCard;
  FlushSuit: TpoCardSuit;
begin
  Result := FALSE;

  if ACardCollection.Count < 5 then Exit;

  { Looking for the flush suit }
  Loop := LookingForFlushSuit(ACardCollection);
  if (Loop < 0) then
    // flush suit not found
    Exit
  else
    FlushSuit := TpoCardSuit(Loop);

  ACardCombination := TpoCardCombination.Create(FCardPack);
  aCardCmb := ACardCollection.Cards[0];
  ACardCombination.AttachCard(aCardCmb);

  { checking for straight flush }
  for Loop:=1 to ACardCollection.Count-1 do
  begin
    aCard := ACardCollection.Cards[Loop];

    if (Ord(aCardCmb.Value) - Ord(aCard.Value) = 1) and (aCardCmb.Suit = aCard.Suit)
    then begin
      aCardCmb := aCard;
      ACardCombination.AttachCard(aCardCmb);

      if (ACardCombination.Count >= 5) then Break;
    end else begin
      if ((aCardCmb.Value = aCard.Value) or (Ord(aCardCmb.Value) - Ord(aCard.Value) = 1)) and
         (aCardCmb.Suit = FlushSuit)
      then Continue;
      ACardCombination.Clear;
      aCardCmb := aCard;
      ACardCombination.AttachCard(aCardCmb);
    end;
  end;

  if ACardCombination.Count<5 then
  begin
    { there is no straight }
    { stop scanning        }
    ACardCombination.Clear;
    ACardCombination.Free;
    Exit;
  end;

  ACardCombination.Kind := CCK_STRAIGHT_FLUSH;

  { adding combination to the collection }
  ACombinations.AddCombination(ACardCombination);

  Result := TRUE;
end;

function TpoCardCombinationProcessor.DetectStraightFlushWithAceAsOne(
  ACardCollection: TpoCardCollection;
  var ACombinations: TpoCombinations): boolean;
var
  Loop      :Integer;
  ACardCombination: TpoCardCombination;
  aCard, aCardCmb: TpoCard;
  bNeenReplaceAce: Boolean;
  FlushSuit: TpoCardSuit;
begin
  Result := FALSE;

  if ACardCollection.Count < 5 then Exit;

  bNeenReplaceAce := (ACardCollection.Cards[0].Value = CV_ACE);

  if bNeenReplaceAce then begin
    ACardCollection.ReplaceCardsValue(CV_ACE, CV_1);
    ACardCollection.Sort;
  end;

  { Looking for the flush suit }
  Loop := LookingForFlushSuit(ACardCollection);
  if (Loop < 0) then begin
    // flush suit not found
    if bNeenReplaceAce then begin
      ACardCollection.ReplaceCardsValue(CV_1, CV_ACE);
      ACardCollection.Sort;
    end;
    Exit;
  end else begin
    FlushSuit := TpoCardSuit(Loop);
  end;

  ACardCombination := TpoCardCombination.Create(FCardPack);
  aCardCmb := ACardCollection.Cards[0];
  ACardCombination.AttachCard(aCardCmb);

  { checking for straight flush }
  for Loop:=1 to ACardCollection.Count-1 do
  begin
    aCard := ACardCollection.Cards[Loop];
    if (Ord(aCardCmb.Value) - Ord(aCard.Value) = 1) and (aCardCmb.Suit = aCard.Suit)
    then begin
      aCardCmb := aCard;
      ACardCombination.AttachCard(aCardCmb);

      if (ACardCombination.Count >= 5) then Break;
    end else begin
      if ((aCardCmb.Value = aCard.Value) or (Ord(aCardCmb.Value) - Ord(aCard.Value) = 1)) and
         (aCardCmb.Suit = FlushSuit)
      then Continue;
      ACardCombination.Clear;
      aCardCmb := aCard;
      ACardCombination.AttachCard(aCardCmb);
    end;
  end;

  if ACardCombination.Count<5 then
  begin
    { there is no straight }
    { stop scanning        }
    ACardCombination.Clear;
    ACardCombination.Free;
    if bNeenReplaceAce then begin
      ACardCollection.ReplaceCardsValue(CV_1, CV_ACE);
      ACardCollection.Sort;
    end;
    Exit;
  end;

  ACardCombination.Kind := CCK_STRAIGHT_FLUSH;

  { adding combination to the collection }
  ACombinations.AddCombination(ACardCombination);

  if bNeenReplaceAce then begin
    ACardCollection.ReplaceCardsValue(CV_1, CV_ACE);
    ACardCollection.Sort;
  end;

  Result := TRUE;
end;

function TpoCardCombinationProcessor.DetectStraightWithAceAsOne(ACardCollection: TpoCardCollection;
  var ACombinations: TpoCombinations): boolean;
var
  bNeenReplaceAce: Boolean;
begin
  Result := FALSE;

  if ACardCollection.Count < 5 then Exit;

  bNeenReplaceAce := (ACardCollection.Cards[0].Value = CV_ACE);

  if bNeenReplaceAce then begin
    ACardCollection.ReplaceCardsValue(CV_ACE, CV_1);
    ACardCollection.Sort;
  end;

  Result := DetectStraight(ACardCollection, ACombinations);

  if bNeenReplaceAce then begin
    ACardCollection.ReplaceCardsValue(CV_1, CV_ACE);
    ACardCollection.Sort;
  end;
end;

function TpoCardCombinationProcessor.DetectThreeOfAKind(ACardCollection: TpoCardCollection;
  var ACombinations: TpoCombinations):boolean;
var
  Loop  : Integer;
  ACardCombination: TpoCardCombination;
  aCard_0, aCard_1, aCard_2: TpoCard;
begin
  Result := FALSE;

  if (ACardCollection.Count < 3) then Exit;

  ACardCombination := TpoCardCombination.Create(FCardPack);

  for Loop:=2 to ACardCollection.Count - 1 do
  begin
    aCard_2 := ACardCollection.Cards[Loop-2];
    aCard_1 := ACardCollection.Cards[Loop-1];
    aCard_0 := ACardCollection.Cards[Loop];
    if (aCard_0.Value = aCard_1.Value) and (aCard_0.Value = aCard_2.Value)
    then begin
      ACardCombination.AttachCard(aCard_2);
      ACardCombination.AttachCard(aCard_1);
      ACardCombination.AttachCard(aCard_0);
      Break;
    end;
  end;

  if (ACardCombination.Count < 3) then
  begin
    ACardCombination.Clear;
    ACardCombination.Free;
    Exit;
  end;

  aCard_0 := ACardCombination.Cards[0];
  for Loop:=0 to ACardCollection.Count - 1 do begin
    aCard_1 := ACardCollection.Cards[Loop];
    if (aCard_1.Value <> aCard_0.Value) then begin
      ACardCombination.AttachCard(aCard_1);
      if ACardCombination.Count >= 5 then Break;
    end;
  end;//for


  ACardCombination.Kind := CCK_3_OF_A_KIND;

  { adding to the collection }
  ACombinations.AddCombination( ACardCombination );

  Result := TRUE;
end;

function TpoCardCombinationProcessor.DetectTwoPair(ACardCollection: TpoCardCollection;
  var ACombinations: TpoCombinations):boolean;
var
  Loop      : Integer;
  ACardCombination: TpoCardCombination;
  aCardCmb, aCard_0, aCard_1: TpoCard;
begin
  Result := FALSE;

  if ACardCollection.Count < 4 then Exit;

  ACardCombination := TpoCardCombination.Create(FCardPack);
  aCardCmb := nil;

  Loop := 0;
  while Loop<(ACardCollection.Count-1) do begin
    aCard_0 := ACardCollection.Cards[Loop];
    aCard_1 := ACardCollection.Cards[Loop+1];

    if (aCardCmb <> nil) then begin
      if (aCard_0.Value = aCardCmb.Value) or (aCard_1.Value = aCardCmb.Value)
      then begin
        Loop:=Loop+1;
        Continue;
      end;
    end;

    if aCard_0.Value = aCard_1.Value then begin
      aCardCmb := aCard_0;
      ACardCombination.AttachCard(aCard_0);
      ACardCombination.AttachCard(aCard_1);

      if (ACardCombination.Count=4) then Break;
      Loop := Loop+1
    end;
    Loop:=Loop+1;
  end;

  if (ACardCombination.Count<4) then
  begin
    ACardCombination.Clear;
    ACardCombination.Free;
    Exit;
  end;

  { add rest of cards to the combination }
  aCard_0 := ACardCombination.Cards[0];
  aCard_1 := ACardCombination.Cards[2];
  for Loop:=0 to ACardCollection.Count-1 do begin
    aCardCmb := ACardCollection.Cards[Loop];
    if (aCardCmb.Value <> aCard_0.Value) and (aCardCmb.Value <> aCard_1.Value) then begin
      ACardCombination.AttachCard(aCardCmb);
      Break;
    end;
  end;

  ACardCombination.Kind := CCK_TWO_PAIR;

  { add to the colleciton  }
  ACombinations.AddCombination( ACardCombination );

  Result := TRUE;
end;

function TpoCardCombinationProcessor.LookingForFlushSuit(ACardCollection: TpoCardCollection): Integer;
var
  SpadeCnt, ClubCnt, HeartCnt, DiamondCnt: Integer;
  Loop: Integer;
  FlushSuit: TpoCardSuit;
begin
  // Result is order of TpoCardSuit
  Result := -1; // suit not found

  { Looking for the flush suit }
  SpadeCnt  :=0;
  ClubCnt   :=0;
  HeartCnt  :=0;
  DiamondCnt:=0;

  for Loop := 0 to ACardCollection.Count-1 do
  begin
    if ACardCollection.Cards[Loop].Suit = CS_SPADE then Inc(SpadeCnt)
    else if ACardCollection.Cards[Loop].Suit = CS_HEART then Inc(HeartCnt)
    else if ACardCollection.Cards[Loop].Suit = CS_DIAMOND then Inc(DiamondCnt)
    else if ACardCollection.Cards[Loop].Suit = CS_CLUB then Inc(ClubCnt);
  end;

  if SpadeCnt>4 then FlushSuit := CS_SPADE
  else if HeartCnt>4 then FlushSuit := CS_HEART
  else if DiamondCnt>4 then FlushSuit := CS_DIAMOND
  else if ClubCnt>4 then FlushSuit := CS_CLUB
  else Exit;

  Result := Integer(FlushSuit);
end;

end.
