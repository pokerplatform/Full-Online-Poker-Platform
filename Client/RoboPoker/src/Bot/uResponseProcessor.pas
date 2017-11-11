unit uResponseProcessor;

interface

uses Contnrs, SysUtils
  //
  , uBotClasses
  , uBotActions
  , uBotConstants
  , uCardEngine
  ;

type
  TFixTypeCombination = (
    CT_RoyalFlush,
    CT_StraightFlush,
    CT_FourOfAKind,
    CT_FullHouse,
    CT_Flush,
    CT_Strait,
    CT_ThreeOfAKind,
    CT_TwoPair,
    CT_OnePair,
    CT_HiCard
  );

  TFixCorrectiveCoefficient = array [TFixTypeCombination] of Double;
  TFixCharacterCorrectiveCoefficient = array [TFixUserCharacter] of TFixCorrectiveCoefficient;

const

  { correspond to order of combinations }
  CorrectiveCoefficientsCombinationsBeforeFlop: TFixCharacterCorrectiveCoefficient =
    (
      (1, 0.1, 0.01, 0.001, 0.0001, 0.00001, 0.000001, 0.0000001, 0.00000001, 0), // Cautious
      (1, 0.1, 0.01, 0.001, 0.0001, 0.00001, 0.000001, 0.0000001, 0.00000001, 0), // Normal
      (1, 0.1, 0.01, 0.001, 0.0001, 0.00001, 0.000001, 0.0000001, 0.00000001, 0)  // Aggresive
    );

  { correspond to order of combinations }
  CorrectiveCoefficientsCombinationsAfterFlop: TFixCharacterCorrectiveCoefficient =
    (
      (1, 0.1, 0.01, 0.001, 0.0001, 0.00001, 0.000001, 0.0000001, 0.00000001, 0), // Cautious
      (1, 0.1, 0.01, 0.001, 0.0001, 0.00001, 0.000001, 0.0000001, 0.00000001, 0), // Normal
      (1, 0.1, 0.01, 0.001, 0.0001, 0.00001, 0.000001, 0.0000001, 0.00000001, 0)  // Aggresive
    );

  { Texas Hold'm }
  TexasOpponentCnfBeforeFlop: array [TFixUserCharacter] of Double =
    (1.000 {64.50 % fold}, 0.850 {46.75 % fold}, 0.800 {33.14 % fold});
  TexasOpponentCnfAfterFlop: array [TFixUserCharacter] of Double =
    (1.000 {Unknown fold}, 0.850 {Unknown fold}, 0.800 {Unknown fold});
  TexasPointsForRaiseBeforeFlop: array [TFixUserCharacter] of Integer =
    (5000000, 2000000, 2000000);
  TexasPointsForRaiseAfterFlop: array [TFixUserCharacter] of Integer =
    (5000000, 2000000,     800);

  { Omaha }
  OmahaOpponentCnfBeforeFlop: array [TFixUserCharacter] of Double =
    (4.900 {64.57 % fold}, 1.710 {46.03 % fold}, 1.465 {33.25 % fold});
  OmahaOpponentCnfAfterFlop: array [TFixUserCharacter] of Double =
    (4.900 {Unknown fold}, 1.710 {Unknown fold}, 1.465 {Unknown fold});

  OmahaPointsForRaiseBeforeFlop: array [TFixUserCharacter] of Integer =
    ( 500000, 500000, 500000);
  OmahaPointsForRaiseAfterFlop: array [TFixUserCharacter] of Integer =
    ( 500000, 400000, 100000);

  { Seven Stud }
  SevenOpponentCnfBeforeFlop: array [TFixUserCharacter] of Double =
    (0.420 {64.48 % fold}, 0.242 {46.50 % fold}, 0.217 {33.14 % fold});
  SevenOpponentCnfAfterFlop: array [TFixUserCharacter] of Double =
    (0.420 {Unknown fold}, 0.242 {Unknown fold}, 0.217 {Unknown fold});

  SevenPointsForRaiseBeforeFlop: array [TFixUserCharacter] of Integer =
    (1000000, 1000000, 1000000);
  SevenPointsForRaiseAfterFlop: array [TFixUserCharacter] of Integer =
    (1000000, 1000000,   10000);

type

  TBotAutoResponse = class
  private
    FTable: TBotTable;
    FUser: TBotUser;
    FCardPack: TCardList;
    FCardView: TCardList;
    FAvailableAnswers: TBotAvailableAnswerList;
    function GetAnswer: TBotAvailableAnswer;
    // random answer
    function GetRandomAnswer: TBotAvailableAnswer;
    // automat answer
    function GetAutomatAnswer: TBotAvailableAnswer;
    // Cheater answer
    function GetCheaterAnswer: TBotAvailableAnswer;
    //
    procedure PreparationCardListsForAnswer;
    //
    function GetHihgAnswerResult: TBotAvailableAnswer;
    function GetLowAnswerResult: TBotAvailableAnswer;
    function GetMidleAnswerResult: TBotAvailableAnswer;
    function HaveObligatoryStake: TBotAvailableAnswer;
    function HaveShowDownAnswer: TBotAvailableAnswer;
    //
  public
    procedure GetAdditionalParameters(var RestCards, OpponentRestCards, PointsForRaise: Integer;
      var CorrCoefficient: Double; var CorrCfntCombos: TFixCorrectiveCoefficient);
    //
    procedure CalcFullCombinationNew(OnSelfAdditionalCards, OnOppSelfAdditionalCards: Integer;
      CorrectivCoefficients: TFixCorrectiveCoefficient;
      var Points: Int64; var Probability, Value: Double;
      var OppPoints: Int64; var OppProbability, OppValue: Double);
    function CalcFullCombinationProbabilityNew(
      aCards: TCardList; OnUnknownCards: Integer; CorrectivCoefficients: TFixCorrectiveCoefficient;
      var HiPoints: Int64; var SumProbability: Double): Double;
    function CalcHiFullCombinationProbabilityNew(
      aCards: TCardList; OnUnknownCards: Integer; CorrectivCoefficients: TFixCorrectiveCoefficient;
      var HiPoints: Int64; var SumProbability: Double): Double;
    function CalcLoFullCombinationProbability(aCards: TCardList; var HiPoints: Int64; var HiProbability: Double): Double;
  private
    function ConvertBotCardToCardEngine(aBotCard: TBotCard): TCard;
    function ConvertBotSuitToCardEngineSuit(aBotSuit: TFixCardSuit): TCardSuitType;
    function ConvertBotValueToCardEngineRank(aBotValue: TFixCardValue): TCardRankType;
    function CardRankByPoints(nPoints: Int64; nPos: Integer): Integer;
  public
    property Table: TBotTable read FTable;
    property User: TBotUser read FUser;
    property CardPack: TCardList read FCardPack;
    property CardView: TCardList read FCardView;
    property AvailableAnswers: TBotAvailableAnswerList read FAvailableAnswers;
    // response
    property Answer: TBotAvailableAnswer read GetAnswer;
    //
    constructor Create(aTable: TBotTable; aUser: TBotUser);
    destructor Destroy; override;
  end;

implementation

uses Classes
  , Math, DateUtils
//
  , uConstants
  , uLogger
  , uCombinationProcessor
  ;

{ TBotResponse }

function TBotAutoResponse.CalcLoFullCombinationProbability(aCards: TCardList;
  var HiPoints: Int64; var HiProbability: Double): Double;
var
  nPoints: Int64;
  nProbability: Double;
  nOnNumberCards: Integer;
begin
  Result := 0;
  HiPoints := 0;
  HiProbability := 0;
  if (aCards.Sorted <> ST_RANK_LOW) then aCards.Sort(ST_RANK_LOW);

{
  if (FTable.GameType in [GT_OMAHA, GT_OMAHA_HL]) then
    nOnNumberCards := (9 - aCards.Count)
  else
    nOnNumberCards := (7 - aCards.Count);
}

  nOnNumberCards := IfThen(aCards.Count < 5, aCards.Count, 5);
  if Low_SearchRoyalFlush(aCards, FCardPack, nOnNumberCards, nPoints, nProbability) then begin
    Result := Result + (VL_ROYAL_FLUSH - VL_HIGH_CARD) * nProbability;
    if (nPoints > HiPoints) then begin
      HiPoints := nPoints;
      HiProbability := nProbability;
    end;
  end;
  if Low_SearchStraightFlush(aCards, FCardPack, nOnNumberCards, nPoints, nProbability) then begin
    Result := Result + (VL_STRAIGHT_FLUSH - VL_HIGH_CARD) * nProbability;
    if (nPoints > HiPoints) then begin
      HiPoints := nPoints;
      HiProbability := nProbability;
    end;
  end;

  nOnNumberCards := IfThen(aCards.Count < 4, aCards.Count, 4);
  if Low_SearchFourOfAKind(aCards, FCardPack, nOnNumberCards, nPoints, nProbability) then begin
    Result := Result + (VL_FOUR_OF_A_KIND - VL_HIGH_CARD) * nProbability;
    if (nPoints > HiPoints) then begin
      HiPoints := nPoints;
      HiProbability := nProbability;
    end;
  end;

  nOnNumberCards := IfThen(aCards.Count < 5, aCards.Count, 5);
  if Low_SearchFullHouse(aCards, FCardPack, nOnNumberCards, nPoints, nProbability) then begin
    Result := Result + (VL_FULL_HOUSE - VL_HIGH_CARD) * nProbability;
    if (nPoints > HiPoints) then begin
      HiPoints := nPoints;
      HiProbability := nProbability;
    end;
  end;
  if Low_SearchFlush(aCards, FCardPack, nOnNumberCards, nPoints, nProbability) then begin
    Result := Result + (VL_FLUSH - VL_HIGH_CARD) * nProbability;
    if (nPoints > HiPoints) then begin
      HiPoints := nPoints;
      HiProbability := nProbability;
    end;
  end;
  if Low_SearchStraight(aCards, FCardPack, nOnNumberCards, nPoints, nProbability) then begin
    Result := Result + (VL_STRAIGHT - VL_HIGH_CARD) * nProbability;
    if (nPoints > HiPoints) then begin
      HiPoints := nPoints;
      HiProbability := nProbability;
    end;
  end;

  nOnNumberCards := IfThen(aCards.Count < 3, aCards.Count, 3);
  if Low_SearchThreeOfAKind(aCards, FCardPack, nOnNumberCards, nPoints, nProbability) then begin
    Result := Result + (VL_THREE_OF_A_KIND - VL_HIGH_CARD) * nProbability;
    if (nPoints > HiPoints) then begin
      HiPoints := nPoints;
      HiProbability := nProbability;
    end;
  end;

  nOnNumberCards := IfThen(aCards.Count < 4, aCards.Count, 4);
  if Low_SearchTwoPair(aCards, FCardPack, nOnNumberCards, nPoints, nProbability) then begin
    Result := Result + (VL_TWO_PAIR - VL_HIGH_CARD) * nProbability;
    if (nPoints > HiPoints) then begin
      HiPoints := nPoints;
      HiProbability := nProbability;
    end;
  end;

  nOnNumberCards := IfThen(aCards.Count < 2, aCards.Count, 2);
  if Low_SearchOnePair(aCards, FCardPack, nOnNumberCards, nPoints, nProbability) then begin
    Result := Result + (VL_ONE_PAIR - VL_HIGH_CARD) * nProbability;
    if (nPoints > HiPoints) then begin
      HiPoints := nPoints;
      HiProbability := nProbability;
    end;
  end;
end;

function TBotAutoResponse.CardRankByPoints(nPoints: Int64; nPos: Integer): Integer;
begin
  case nPos of
    0: Result := (nPoints and $0000000F);
    1: Result := (nPoints and $000000F0) shr 4;
    2: Result := (nPoints and $00000F00) shr 8;
    3: Result := (nPoints and $0000F000) shr 12;
    4: Result := (nPoints and $000F0000) shr 16;
    5: Result := (nPoints and $00F00000) shr 20;
    6: Result := (nPoints and $0F000000) shr 24;
    7: Result := (nPoints and $F0000000) shr 28;
  else
    Result := 0;
  end;
end;

function TBotAutoResponse.ConvertBotCardToCardEngine(aBotCard: TBotCard): TCard;
var
  aSuit: TCardSuitType;
  aRank: TCardRankType;
begin
  Result := nil;
  if (aBotCard = nil) then Exit;

  aSuit := ConvertBotSuitToCardEngineSuit(aBotCard.Suit);
  aRank := ConvertBotValueToCardEngineRank(aBotCard.Value);

  Result := TCard.Create(aSuit, aRank);
end;

function TBotAutoResponse.ConvertBotSuitToCardEngineSuit(aBotSuit: TFixCardSuit): TCardSuitType;
begin
  case aBotSuit of
    CS_CLUB   : Result := CST_CLUBS;
    CS_DIAMOND: Result := CST_DIAMANDS;
    CS_HEART  : Result := CST_HEARTS;
    CS_SPADE  : Result := CST_SPADES;
  else
    Result := CST_NONE;
  end;
end;

function TBotAutoResponse.ConvertBotValueToCardEngineRank(aBotValue: TFixCardValue): TCardRankType;
begin
  case aBotValue of
    CV_2    : Result := CRT_TWO;
    CV_3    : Result := CRT_THREE;
    CV_4    : Result := CRT_FOUR;
    CV_5    : Result := CRT_FIFE;
    CV_6    : Result := CRT_SIX;
    CV_7    : Result := CRT_SEVEN;
    CV_8    : Result := CRT_EIGHT;
    CV_9    : Result := CRT_NINE;
    CV_10   : Result := CRT_TEN;
    CV_JACK : Result := CRT_JACK;
    CV_QUEEN: Result := CRT_QUEEN;
    CV_KING : Result := CRT_KING;
    CV_ACE  : Result := CRT_ACE;
  else
    Result := CRT_NONE;
  end;
end;

constructor TBotAutoResponse.Create(aTable: TBotTable; aUser: TBotUser);
var
  aValue: TCardRankType;
  aSuit : TCardSuitType;
  aCard: TCard;
  aBotCard: TBotCard;
  aAnswer: TBotAvailableAnswer;
  I: Integer;
begin
  inherited Create;

  FTable := aTable;
  FUser  := aUser;

  FAvailableAnswers := nil;
  if (FUser <> nil) then begin;
    { create copy of user answers without sitout type }
    FAvailableAnswers := TBotAvailableAnswerList.Create;
    FAvailableAnswers.SetContextByAnswers(FUser.AvailableAnwers);

    I := 0;
    while (I < FAvailableAnswers.Count) do begin
      aAnswer := FAvailableAnswers.Items[I];
      if (aAnswer.AnswerType in [ACT_SITOUT, ACT_BACK, ACT_SITOUTNEXTHAND, ACT_MORECHIPS, ACT_LEAVETABLE, ACT_UNKNOWN])
      then
        FAvailableAnswers.Del(aAnswer)
      else
        Inc(I);
    end;
  end;
  FAvailableAnswers.SortByActionType;

  { create cards for view (self existence) }
  FCardView := TCardList.Create(True);
  if (aTable <> nil) and (aUser <> nil) then begin
    for I:=0 to aTable.Cards.Count - 1 do begin
      aBotCard := aTable.Cards.Items[I];
      aCard := ConvertBotCardToCardEngine(aBotCard);
      FCardView.Add(aCard);
    end;

    for I:=0 to aUser.Cards.Count - 1 do begin
      aBotCard := aUser.Cards.Items[I];
      aCard := ConvertBotCardToCardEngine(aBotCard);
      FCardView.Add(aCard);
    end;
  end;

  { create card pack }
  FCardPack := TCardList.Create(True);
  for aValue := CRT_ACE to CRT_TWO do begin
    for aSuit := CST_SPADES to CST_DIAMANDS do begin
      aCard := TCard.Create(aSuit, aValue);
      FCardPack.Add(aCard);
    end;
  end;
end;

destructor TBotAutoResponse.Destroy;
begin
  FCardPack.Clear;
  FCardPack.Free;

  FCardView.Clear;
  FCardView.Free;

  if (FAvailableAnswers <> nil) then begin
    FAvailableAnswers.Clear;
    FAvailableAnswers.Free;
  end;

  inherited;
end;

function TBotAutoResponse.GetAnswer: TBotAvailableAnswer;
begin
  Result := nil;
  if (FTable = nil) or (FUser = nil) then Exit;
  if (FAvailableAnswers.Count <= 0) then Exit;
  if not FUser.IsBot then Exit;

  if (FAvailableAnswers.Count = 1) then begin
    Result := FAvailableAnswers.Items[0];
    Exit;
  end;

  Result := HaveObligatoryStake;
  if (Result <> nil) then Exit;
  Result := HaveShowDownAnswer;
  if (Result <> nil) then Exit;

  if (FUser.BlaffersEvent <= 0) then begin
    Result := GetHihgAnswerResult;

    Logger.Log(FUser.UserID, ClassName, 'GetAnswer',
      'Blaffers Event was accured; User: ID=' + IntToStr(FUser.UserID) + ' Name=' + FUser.Name +
      ' Character=' + FUser.NameOfCharacter +
      '; Cards: ' + FUser.Cards.CardNames + '; ' + FTable.Cards.CardNames +
      '; Answer=' + Result.Name + '; Available answers: ' + FUser.AvailableAnwers.GetNames,
      ltCall
    );

    Exit;
  end;

  { perform automat answer }
  if (FUser.GameQualification = PQ_RANDOM) then
    Result := GetRandomAnswer
  else
    Result := GetAutomatAnswer;

  if (Result.AnswerType = ACT_FOLD) then begin
    FUser.BlaffersEvent := FUser.BlaffersEvent - 1;
    if (FUser.BlaffersEvent <= 0) then begin
      Result := GetHihgAnswerResult;

      Logger.Log(FUser.UserID, ClassName, 'GetAnswer',
        'Blaffers Event was accured; User: ID=' + IntToStr(FUser.UserID) + ' Name=' + FUser.Name +
        ' Character=' + FUser.NameOfCharacter +
        '; Cards: ' + FUser.Cards.CardNames + '; ' + FTable.Cards.CardNames +
        '; Answer=' + Result.Name + '; Available answers: ' + FUser.AvailableAnwers.GetNames,
        ltCall
      );
    end;
  end;

  if (FUser.GameQualification = PQ_AUTOMAT) then
    Logger.Log(FUser.UserID, ClassName, 'GetAnswer',
      'User: ID=' + IntToStr(FUser.UserID) + ' Name=' + FUser.Name +
      ' Character=' + FUser.NameOfCharacter +
      '; Cards: ' + FUser.Cards.CardNames + '; ' + FTable.Cards.CardNames +
      '; Answer=' + Result.Name + '; Available answers: ' + FUser.AvailableAnwers.GetNames,
      ltCall
    );
end;

function TBotAutoResponse.GetAutomatAnswer: TBotAvailableAnswer;
var
  nRestCards, nOpponentRestCards, nPointsForRaise: Integer;
  nCorrCoefficient: Double;
  nPoints, nOppPoints: Int64;
  nProbability, nCalcAnswer, nOppProbability, nOppCalcAnswer: Double;
  aCorrCfntCombinations: TFixCorrectiveCoefficient;
  nRnd: Integer;
begin
  { delete from card pack all users & opened cards }
  PreparationCardListsForAnswer;

  { additional parameters corresponded to character of user and type of poker }
  GetAdditionalParameters(
    nRestCards, nOpponentRestCards, nPointsForRaise, nCorrCoefficient, aCorrCfntCombinations
  );

  { answer corresponded to probability of posibility combinations }
  CalcFullCombinationNew(
    nRestCards, nOpponentRestCards, aCorrCfntCombinations,
    nPoints, nProbability, nCalcAnswer,
    nOppPoints, nOppProbability, nOppCalcAnswer
  );

  { start value }
  Result := GetLowAnswerResult;

  nCalcAnswer := nCalcAnswer - nOppCalcAnswer * nCorrCoefficient;
  if (nCalcAnswer > 0) then begin
    Result := GetMidleAnswerResult;

    if (nCalcAnswer >= nPointsForRaise) then begin
      nRnd := Random(100);
      case FUser.Character of
        UCH_CAUTIOUS  : if (nRnd < 15) then Result := GetHihgAnswerResult;
        UCH_NORMAL    : if (nRnd < 30) then Result := GetHihgAnswerResult;
        UCH_AGGRESSIVE: if (nRnd < 40) then Result := GetHihgAnswerResult;
      end;
    end;
  end;
end;

function TBotAutoResponse.GetHihgAnswerResult: TBotAvailableAnswer;
begin
  Result := nil;
  if (FAvailableAnswers.Count <= 0) then Exit;
  Result := FAvailableAnswers.Items[FAvailableAnswers.Count-1];
end;

function TBotAutoResponse.GetLowAnswerResult: TBotAvailableAnswer;
begin
  Result := FAvailableAnswers.FindAnswerType(ACT_CHECK);
  if (Result <> nil) then Exit;

  if (FAvailableAnswers.Count <= 0) then Exit;
  Result := FAvailableAnswers.Items[0];
end;

function TBotAutoResponse.GetMidleAnswerResult: TBotAvailableAnswer;
begin
  Result := FAvailableAnswers.FindAnswerType(ACT_CHECK);
  if (Result <> nil) then begin
    Result := GetHihgAnswerResult;
    Exit;
  end;

  if (FAvailableAnswers.Count <= 0) then Exit;
  if (FAvailableAnswers.Count >= 2) then
    Result := FAvailableAnswers.Items[1]
  else
    Result := FAvailableAnswers.Items[0];
end;

function TBotAutoResponse.GetRandomAnswer: TBotAvailableAnswer;
var
  nInd, nCnt, nVal, nMlp: Integer;
begin
  nCnt := FAvailableAnswers.Count * 10;
  nVal := Random(nCnt);
  nMlp := IfThen(FTable.Round < 2, 4, 1);
  if      (nVal < FAvailableAnswers.Count * nMlp) then
    nInd := 0
  else if (nVal < (FAvailableAnswers.Count * 7))  then
    nInd := 1
  else
    nInd := 2;
  if (nInd > (FAvailableAnswers.Count - 1)) then
    nInd := FAvailableAnswers.Count - 1; 

  Result := FAvailableAnswers.Items[nInd];
end;

function TBotAutoResponse.GetCheaterAnswer: TBotAvailableAnswer;
var
  I, nCnt: Integer;
  aBotCard: TBotCard;
  aUser: TBotUser;
  aCard: TCard;
  aSuit: TCardSuitType;
  aRank: TCardRankType;
begin
  { remove from full cardpack all open and cooperative cards }
  for nCnt:=0 to FTable.Users.Count - 1 do begin
    aUser := FTable.Users.Items[nCnt];

    for I:=0 to aUser.Cards.Count - 1 do begin
      aBotCard := aUser.Cards.Items[I];
      if aBotCard.Open or (aUser.IsBot and (aUser.GameQualification = PQ_Cheater)) then begin
        aSuit := ConvertBotSuitToCardEngineSuit(aBotCard.Suit);
        aRank := ConvertBotValueToCardEngineRank(aBotCard.Value);

        aCard := FCardPack.Find(aSuit, aRank);
        if (aCard <> nil) then FCardPack.Remove(aCard);
      end;
    end;
  end;

  for I:=0 to FTable.Cards.Count - 1 do begin
    aBotCard := FTable.Cards.Items[I];
    aSuit := ConvertBotSuitToCardEngineSuit(aBotCard.Suit);
    aRank := ConvertBotValueToCardEngineRank(aBotCard.Value);

    aCard := FCardPack.Find(aSuit, aRank);
    if (aCard <> nil) then FCardPack.Remove(aCard);
  end;

  {}{ TODO : To be continue }
  Result := GetAutomatAnswer;
end;

function TBotAutoResponse.HaveObligatoryStake: TBotAvailableAnswer;
var
  aAnswer: TBotAvailableAnswer;
begin
  Result := nil;
  aAnswer := FAvailableAnswers.FindAnswerType(ACT_POSTSB);
  if (aAnswer <> nil) then begin
    Result := aAnswer;
    Exit;
  end;

  aAnswer := FAvailableAnswers.FindAnswerType(ACT_POSTBB);
  if (aAnswer <> nil) then begin
    Result := aAnswer;
    Exit;
  end;

  aAnswer := FAvailableAnswers.FindAnswerType(ACT_ANTE);
  if (aAnswer <> nil) then begin
    Result := aAnswer;
    Exit;
  end;

  aAnswer := FAvailableAnswers.FindAnswerType(ACT_POSTDEAD);
  if (aAnswer <> nil) then begin
    Result := aAnswer;
    Exit;
  end;

  aAnswer := FAvailableAnswers.FindAnswerType(ACT_WAITBB);
  if (aAnswer <> nil) then begin
    aAnswer := FAvailableAnswers.FindAnswerType(ACT_POST);
    if (aAnswer <> nil) then begin
      Result := aAnswer;
      Exit;
    end;
  end;
end;

function TBotAutoResponse.HaveShowDownAnswer: TBotAvailableAnswer;
var
  nItm: Integer;
begin
  Result := nil;
  if (FAvailableAnswers.FindAnswerType(ACT_SHOW        ) <> nil) or
     (FAvailableAnswers.FindAnswerType(ACT_SHOWSHUFFLED) <> nil) or
     (FAvailableAnswers.FindAnswerType(ACT_MUCK        ) <> nil) or
     (FAvailableAnswers.FindAnswerType(ACT_DONTSHOW    ) <> nil)
  then begin
    nItm := Random(FAvailableAnswers.Count);
    Result := FAvailableAnswers.Items[nItm];
  end;
end;

function TBotAutoResponse.CalcHiFullCombinationProbabilityNew(
  aCards: TCardList; OnUnknownCards: Integer; CorrectivCoefficients: TFixCorrectiveCoefficient;
  var HiPoints: Int64; var SumProbability: Double): Double;
var
  nPoints: Int64;
  nProbability, nProbPoins: Double;
begin
  Result := 0;
  HiPoints := 0;
  SumProbability := 0;
  if (aCards.Sorted <> ST_RANK_HI) then aCards.Sort(ST_RANK_HI);

  Hi_SearchRoyalFlushProbability(aCards, FCardPack, OnUnknownCards, nPoints, nProbability, nProbPoins);
  Result := Result + nProbPoins * CorrectivCoefficients[CT_RoyalFlush];
  HiPoints := Max(nPoints, HiPoints);
  SumProbability := SumProbability + nProbability;

  Hi_SearchStraightFlushProbability(aCards, FCardPack, OnUnknownCards, nPoints, nProbability, nProbPoins);
  Result := Result + nProbPoins * CorrectivCoefficients[CT_StraightFlush];
  HiPoints := Max(nPoints, HiPoints);
  SumProbability := SumProbability + nProbability;

  Hi_SearchFourOfAKindProbability(aCards, FCardPack, OnUnknownCards, nPoints, nProbability, nProbPoins);
  Result := Result + nProbPoins * CorrectivCoefficients[CT_FourOfAKind];
  HiPoints := Max(nPoints, HiPoints);
  SumProbability := SumProbability + nProbability;

  Hi_SearchFullHouseProbability(aCards, FCardPack, OnUnknownCards, nPoints, nProbability, nProbPoins);
  Result := Result + nProbPoins * CorrectivCoefficients[CT_FullHouse];
  HiPoints := Max(nPoints, HiPoints);
  SumProbability := SumProbability + nProbability;

  Hi_SearchFlushProbability(aCards, FCardPack, OnUnknownCards, nPoints, nProbability, nProbPoins);
  Result := Result + nProbPoins * CorrectivCoefficients[CT_Flush];
  HiPoints := Max(nPoints, HiPoints);
  SumProbability := SumProbability + nProbability;

  Hi_SearchStraightProbability(aCards, FCardPack, OnUnknownCards, nPoints, nProbability, nProbPoins);
  Result := Result + nProbPoins * CorrectivCoefficients[CT_Strait];
  HiPoints := Max(nPoints, HiPoints);
  SumProbability := SumProbability + nProbability;

  Hi_SearchThreeOfAKindProbability(aCards, FCardPack, OnUnknownCards, nPoints, nProbability, nProbPoins);
  Result := Result + nProbPoins * CorrectivCoefficients[CT_ThreeOfAKind];
  HiPoints := Max(nPoints, HiPoints);
  SumProbability := SumProbability + nProbability;

  Hi_SearchTwoPairProbability(aCards, FCardPack, OnUnknownCards, nPoints, nProbability, nProbPoins);
  Result := Result + nProbPoins * CorrectivCoefficients[CT_TwoPair];
  HiPoints := Max(nPoints, HiPoints);
  SumProbability := SumProbability + nProbability;

  Hi_SearchOnePairProbability(aCards, FCardPack, OnUnknownCards, nPoints, nProbability, nProbPoins);
  Result := Result + nProbPoins * CorrectivCoefficients[CT_OnePair];
  HiPoints := Max(nPoints, HiPoints);
  SumProbability := SumProbability + nProbability;
end;

procedure TBotAutoResponse.CalcFullCombinationNew(OnSelfAdditionalCards, OnOppSelfAdditionalCards: Integer;
  CorrectivCoefficients: TFixCorrectiveCoefficient;
  var Points: Int64; var Probability, Value: Double;
  var OppPoints: Int64; var OppProbability, OppValue: Double);
var
  I, J, T_1, T_2, T_3, U_1, U_2: Integer;
  aCards: TCardList;
  aOpponent: TBotUser;
  aBotCard: TBotCard;
  aCard: TCard;
  MaxOppPoints: Int64;
  MaxOppProbability, MaxOppValue: Double;

  arrUserCards: array of TCardList;
  arrTableCards: array of TCardList;

  procedure AttachBotCardToCardList(BotCard: TBotCard; CardList: TCardList);
  var
    aCard: TCard;
  begin
    aCard := ConvertBotCardToCardEngine(BotCard);
    CardList.Add(aCard);
  end;

  function Fact_N(N: Integer): Integer;
  var
    I: Integer;
  begin
    Result:= 1;
    for I:= 2 to N do Result:= Result * I;
  end;

  function Should_N_M(N, M: Integer): Integer;
  begin
    Result:= 0;
    if ((N-M) < 0) then Exit;
    if (N<0)or(M<0) then Exit;
    Result:= Integer( Round(Fact_N(N) / (Fact_N(M)* Fact_N(N-M))) );
  end;

var
  nInd: Integer;
begin
  Value := 0;
  Points := 0;
  Probability := 0;

  { Existanse active user combinations }
  if not (FTable.GameType in [GT_OMAHA, GT_OMAHA_HL]) then begin
    Value := CalcFullCombinationProbabilityNew(
      FCardView, OnSelfAdditionalCards, CorrectivCoefficients, Points, Probability
    );
  end else begin
    { only 2 user cards can be used in combination }
    SetLength(arrUserCards, Should_N_M(FUser.Cards.Count, 2));
    nInd := -1;
    for U_1 := 0 to FUser.Cards.Count - 2 do begin
      Inc(nInd);
      arrUserCards[nInd] := TCardList.Create(True);
      AttachBotCardToCardList(FUser.Cards.Items[U_1], arrUserCards[nInd]);

      for U_2 := U_1 + 1 to FUser.Cards.Count - 1 do begin
        if (U_2 - U_1 - 1) > 0 then begin
          Inc(nInd);
          arrUserCards[nInd] := TCardList.Create(True);
          AttachBotCardToCardList(FUser.Cards.Items[U_1], arrUserCards[nInd]);
        end;

        AttachBotCardToCardList(FUser.Cards.Items[U_2], arrUserCards[nInd]);
      end;
    end;

    { only 3 table cards can be used in combination }
    SetLength(arrTableCards, Should_N_M(FTable.Cards.Count, 3));
    nInd := -1;
    for T_1 := 0 to FTable.Cards.Count - 3 do begin
      Inc(nInd);
      arrTableCards[nInd] := TCardList.Create(True);
      AttachBotCardToCardList(FTable.Cards.Items[T_1], arrTableCards[nInd]);

      for T_2 := T_1 + 1 to FTable.Cards.Count - 2 do begin
        if (T_2 - T_1 - 1) > 0 then begin
          Inc(nInd);
          arrTableCards[nInd] := TCardList.Create(True);
          AttachBotCardToCardList(FTable.Cards.Items[T_1], arrTableCards[nInd]);
        end;
        AttachBotCardToCardList(FTable.Cards.Items[T_2], arrTableCards[nInd]);

        for T_3 := T_2 + 1 to FTable.Cards.Count - 1 do begin
          if (T_3 - T_2 - 1) > 0 then begin
            Inc(nInd);
            arrTableCards[nInd] := TCardList.Create(True);
            AttachBotCardToCardList(FTable.Cards.Items[T_1], arrTableCards[nInd]);
            AttachBotCardToCardList(FTable.Cards.Items[T_2], arrTableCards[nInd]);
          end;
          AttachBotCardToCardList(FTable.Cards.Items[T_3], arrTableCards[nInd]);
        end;
      end;
    end;

    MaxOppPoints      := 0;
    MaxOppProbability := 0;
    MaxOppValue       := 0;

    aCards := TCardList.Create(False);

    if (Length(arrUserCards) > 0) and (Length(arrTableCards) > 0) then begin
      { Both user and table cards existance }
      for U_1 := Low(arrUserCards) to High(arrUserCards) do begin
        for T_1 := Low(arrTableCards) to High(arrTableCards) do begin
          aCards.Clear;
          for I:=0 to arrUserCards[U_1].Count - 1 do
            aCards.Add(arrUserCards[U_1].Items[I]);
          for I:=0 to arrTableCards[T_1].Count - 1 do
            aCards.Add(arrTableCards[T_1].Items[I]);

          Value := CalcFullCombinationProbabilityNew(
            aCards, OnSelfAdditionalCards, CorrectivCoefficients, Points, Probability
          );

          if (MaxOppValue < Value) then begin
            MaxOppPoints := Points;
            MaxOppProbability := Probability;
            MaxOppValue := Value;
          end;
        end;
      end;
    end else if (Length(arrUserCards) > 0) and (Length(arrTableCards) <= 0) then begin
      { Only user cards existance }
      for U_1 := Low(arrUserCards) to High(arrUserCards) do begin
        aCards.Clear;
        for I:=0 to arrUserCards[U_1].Count - 1 do
          aCards.Add(arrUserCards[U_1].Items[I]);

        Value := CalcFullCombinationProbabilityNew(
          aCards, OnSelfAdditionalCards, CorrectivCoefficients, Points, Probability
        );

        if (MaxOppValue < Value) then begin
          MaxOppPoints := Points;
          MaxOppProbability := Probability;
          MaxOppValue := Value;
        end;
      end;
    end else if (Length(arrUserCards) <= 0) and (Length(arrTableCards) > 0) then begin
      { Only Table cards existance }
      for T_1 := Low(arrTableCards) to High(arrTableCards) do begin
        aCards.Clear;
        for I:=0 to arrTableCards[T_1].Count - 1 do
          aCards.Add(arrTableCards[T_1].Items[I]);

        Value := CalcFullCombinationProbabilityNew(
          aCards, OnSelfAdditionalCards, CorrectivCoefficients, Points, Probability
        );

        if (MaxOppValue < Value) then begin
          MaxOppPoints := Points;
          MaxOppProbability := Probability;
          MaxOppValue := Value;
        end;
      end;
    end else begin
      MaxOppValue := CalcFullCombinationProbabilityNew(
        FCardView, OnSelfAdditionalCards, CorrectivCoefficients, MaxOppPoints, MaxOppProbability
      );
    end;

    Points := MaxOppPoints;
    Probability := MaxOppProbability;
    Value := MaxOppValue;

    aCards.Clear;
    aCards.Free;
    { free arrays of cardlist }
    for U_1 := Low(arrUserCards ) to High(arrUserCards ) do  arrUserCards[U_1].Free;
    for T_1 := Low(arrTableCards) to High(arrTableCards) do arrTableCards[T_1].Free;
  end;

  aCards := TCardList.Create(True);
  { Existance all others bot user combinations }
  if (FTable.GameType in [GT_SEVEN, GT_SEVEN_HL]) then begin
    MaxOppPoints      := 0;
    MaxOppProbability := 0;
    MaxOppValue       := 0;

    for I:=0 to FTable.Users.Count - 1 do begin
      aOpponent := FTable.Users.Items[I];
      if (aOpponent = FUser) then Continue;
      if (aOpponent.IsWatcher)  then Continue;
      if (aOpponent.InGame < 1) then Continue;
      if (aOpponent.Cards.Count <= 0) then Continue;

      aCards.Clear;

      for J:=0 to aOpponent.Cards.Count - 1 do begin
        aBotCard := aOpponent.Cards.Items[J];
        if (J in [0,1,6]) then Continue;
        aCard := ConvertBotCardToCardEngine(aBotCard);
        aCards.Add(aCard);
      end;

      OppValue := CalcFullCombinationProbabilityNew(
        aCards, OnOppSelfAdditionalCards, CorrectivCoefficients,
        OppPoints, OppProbability
      );

      if (MaxOppValue < OppValue) then begin
        MaxOppPoints := OppPoints;
        MaxOppProbability := OppProbability;
        MaxOppValue := OppValue;
      end;

      aCards.Clear;
    end;

    OppPoints := MaxOppPoints;
    OppProbability := MaxOppProbability;
    OppValue := MaxOppValue;
  end else if (FTable.GameType = GT_TEXAS) then begin
    { search first }
    aCards.Clear;
    for I:=0 to FTable.Cards.Count - 1 do begin
      aBotCard := FTable.Cards.Items[I];
      aCard := ConvertBotCardToCardEngine(aBotCard);
      aCards.Add(aCard);
    end;

    for I:=0 to FCardView.Count - 1 do begin
      aCard := FCardView.Items[I];
      aCard := FCardPack.Find(aCard.Suit, aCard.Rank);
      if (aCard <> nil) then FCardPack.Remove(aCard)
    end;

    OppValue := CalcFullCombinationProbabilityNew(
      aCards, OnOppSelfAdditionalCards, CorrectivCoefficients,
      OppPoints, OppProbability
    );

    aCards.Clear;
  end else begin // Omaha
    MaxOppPoints      := 0;
    MaxOppProbability := 0;
    MaxOppValue       := 0;

    for I:=0 to FCardView.Count - 1 do begin
      aCard := FCardView.Items[I];
      aCard := FCardPack.Find(aCard.Suit, aCard.Rank);
      if (aCard <> nil) then FCardPack.Remove(aCard)
    end;

    { only 3 of a table cards can be used in combination }
    if (FTable.Cards.Count >= 3) then begin
      for T_1 := 0 to FTable.Cards.Count - 3 do begin
        aCards.Clear;
        AttachBotCardToCardList(FTable.Cards.Items[T_1], aCards);

        for T_2 := T_1 + 1 to FTable.Cards.Count - 2 do begin
          AttachBotCardToCardList(FTable.Cards.Items[T_2], aCards);

          for T_3 := T_2 + 1 to FTable.Cards.Count - 1 do begin
            AttachBotCardToCardList(FTable.Cards.Items[T_3], aCards);

            OppValue := CalcFullCombinationProbabilityNew(
              aCards, OnOppSelfAdditionalCards, CorrectivCoefficients,
              OppPoints, OppProbability
            );

            if (MaxOppValue < OppValue) then begin
              MaxOppPoints := OppPoints;
              MaxOppProbability := OppProbability;
              MaxOppValue := OppValue;
            end;

            aCards.Remove(aCards.Items[aCards.Count-1]);
          end;

          aCards.Remove(aCards.Items[aCards.Count-1]);
        end;
      end;
    end else begin
      aCards.Clear;

      OppValue := CalcFullCombinationProbabilityNew(
        aCards, OnOppSelfAdditionalCards, CorrectivCoefficients,
        OppPoints, OppProbability
      );

      MaxOppPoints := OppPoints;
      MaxOppProbability := OppProbability;
      MaxOppValue := OppValue;
    end;

    OppPoints := MaxOppPoints;
    OppProbability := MaxOppProbability;
    OppValue := MaxOppValue;
  end;

  aCards.Clear;
  aCards.Free;
end;

function TBotAutoResponse.CalcFullCombinationProbabilityNew(
  aCards: TCardList; OnUnknownCards: Integer; CorrectivCoefficients: TFixCorrectiveCoefficient;
  var HiPoints: Int64; var SumProbability: Double): Double;
var
  nPoints: Int64;
  nProbability: Double;
  nRes: Double;
begin
  { Probability combinations }
  Result := 0;
  HiPoints := 0;
  nProbability := 0;
  nRes := CalcHiFullCombinationProbabilityNew(
    aCards, OnUnknownCards, CorrectivCoefficients, nPoints, nProbability);
  Result := Result + nRes;
  HiPoints := Max(nPoints, HiPoints);
  SumProbability := nProbability;
  { TODO : Need continued for Low combinations }
{  if (FTable.GameType in [GT_OMAHA_HL, GT_SEVEN_HL]) then begin
    nRes := CalcLoFullCombinationProbability(aCards, nPoints, nProbability);
    Result := Result + nRes;
    if (HiPoints < nPoints) then begin
      HiPoints := nPoints;
      HiProbability := nProbability;
    end;
  end;}
end;

procedure TBotAutoResponse.GetAdditionalParameters(var RestCards, OpponentRestCards, PointsForRaise: Integer;
  var CorrCoefficient: Double; var CorrCfntCombos: TFixCorrectiveCoefficient);
var
  ItIsBeforeFlop: Boolean;
begin
  case FTable.GameType of
    GT_OMAHA, GT_OMAHA_HL:
    begin
//      RestCards         := 9 - FUser.Cards.CountVisible;
      RestCards         := 9 - FCardView.Count;
      OpponentRestCards := RestCards + 2;
      ItIsBeforeFlop    := (FCardView.Count <= 4);
      if ItIsBeforeFlop then begin
        CorrCoefficient := OmahaOpponentCnfBeforeFlop[FUser.Character];
        PointsForRaise  := OmahaPointsForRaiseBeforeFlop[FUser.Character];
      end else begin
        CorrCoefficient := OmahaOpponentCnfAfterFlop[FUser.Character];
        PointsForRaise  := OmahaPointsForRaiseAfterFlop[FUser.Character];
      end;
    end;
    GT_SEVEN, GT_SEVEN_HL:
    begin
      RestCards    := 7 - FUser.Cards.CountVisible;
      if (FTable.Round <= 4) then
        OpponentRestCards := RestCards + 2
      else
        OpponentRestCards := RestCards + 3;
      ItIsBeforeFlop      := (FCardView.Count <= 3);
      if ItIsBeforeFlop then begin
        CorrCoefficient   := SevenOpponentCnfBeforeFlop[FUser.Character];
        PointsForRaise    := SevenPointsForRaiseBeforeFlop[FUser.Character];
      end else begin
        CorrCoefficient   := SevenOpponentCnfAfterFlop[FUser.Character];
        PointsForRaise    := SevenPointsForRaiseAfterFlop[FUser.Character];
      end;
    end;
  else
//    RestCards    := 7 - FUser.Cards.CountVisible;
    RestCards    := 7 - FCardView.Count;
    OpponentRestCards := RestCards + 2;
    ItIsBeforeFlop    := (FCardView.Count <= 2);
    if ItIsBeforeFlop then begin
      CorrCoefficient := TexasOpponentCnfBeforeFlop[FUser.Character];
      PointsForRaise  := TexasPointsForRaiseBeforeFlop[FUser.Character];
    end else begin
      CorrCoefficient := TexasOpponentCnfAfterFlop[FUser.Character];
      PointsForRaise  := TexasPointsForRaiseAfterFlop[FUser.Character];
    end;
  end;

  if ItIsBeforeFlop then
    CorrCfntCombos  := CorrectiveCoefficientsCombinationsBeforeFlop[FUser.Character]
  else
    CorrCfntCombos  := CorrectiveCoefficientsCombinationsAfterFlop[FUser.Character];
end;

procedure TBotAutoResponse.PreparationCardListsForAnswer;
var
  aBotCard: TBotCard;
  aCard: TCard;
  aSuit: TCardSuitType;
  aRank: TCardRankType;
  aUser: TBotUser;
  nCnt, I: Integer;
begin
  { remove from full cardpack all user opened cards }
  for I:=0 to FUser.Cards.Count - 1 do begin
    aBotCard := FUser.Cards.Items[I];
    if aBotCard.Open then begin
      aSuit := ConvertBotSuitToCardEngineSuit(aBotCard.Suit);
      aRank := ConvertBotValueToCardEngineRank(aBotCard.Value);

      aCard := FCardPack.Find(aSuit, aRank);
      if (aCard <> nil) then FCardPack.Remove(aCard);
    end;
  end;

  { remove from cardpack all opponent opened cards (7 stud only) }
  if FTable.GameType in [GT_SEVEN, GT_SEVEN_HL] then begin
    for nCnt:=0 to FTable.Users.Count - 1 do begin
      aUser := FTable.Users.Items[nCnt];
      if (aUser = FUser) then Continue;

      for I:=0 to aUser.Cards.Count - 1 do begin
        if (I in [0,1,6]) then Continue;

        aBotCard := aUser.Cards.Items[I];
        aSuit := ConvertBotSuitToCardEngineSuit(aBotCard.Suit);
        aRank := ConvertBotValueToCardEngineRank(aBotCard.Value);

        aCard := FCardPack.Find(aSuit, aRank);
        if (aCard <> nil) then FCardPack.Remove(aCard);
      end;
    end;
  end;

  for I:=0 to FTable.Cards.Count - 1 do begin
    aBotCard := FTable.Cards.Items[I];
    aSuit := ConvertBotSuitToCardEngineSuit(aBotCard.Suit);
    aRank := ConvertBotValueToCardEngineRank(aBotCard.Value);

    aCard := FCardPack.Find(aSuit, aRank);
    if (aCard <> nil) then FCardPack.Remove(aCard);
  end;
end;

initialization
  Randomize;

end.
