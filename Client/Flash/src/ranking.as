// ****************************************************************************
// Poker Engine Library
// Card Combinations Ranking
// ****************************************************************************
// 
var CCK_EMPTY = 0;
var CCK_HIGH_CARD = 1;
var CCK_ONE_PAIR = 2;
var CCK_TWO_PAIR = 3;
var CCK_3_OF_A_KIND = 4;
var CCK_STRAIGHT = 5;
var CCK_FLUSH = 6;
var CCK_FULL_HOUSE = 7;
var CCK_4_OF_A_KIND = 8;
var CCK_STRAIGHT_FLUSH = 9;
var CCK_ROYAL_FLUSH = 10;
var CCK_LO_COMBINATION = 11;
//
var CS_SPADE = "s";
var CS_HEART = "h";
var CS_DIAMOND = "d";
var CS_CLUB = "c";
// 
var CV_LO_ACE = 1;
var CV_2 = 2;
var CV_3 = 3;
var CV_4 = 4;
var CV_5 = 5;
var CV_6 = 6;
var CV_7 = 7;
var CV_8 = 8;
var CV_9 = 9;
var CV_10 = 10;
var CV_JACK = 11;
var CV_QUEEN = 12;
var CV_KING = 13;
var CV_ACE = 14;
// 
var C_HI = 1;
var C_LO = 0;
// 
var S_ASCENDING = 1;
var S_DESCENDING = 0;
// 
var CC_GREATER = 1;
var CC_EQUAL = 0;
var CC_LESS = -1;
//
var bDetectLoCombination = false;
//
// ============================================================================
// 
// ============================================================================
function getBestCombination (arrSharedCards, arrUserCards)
{
	//
	bDetectLoCombination = false;
	//
	var arrResults = createCombinations (arrSharedCards, arrUserCards, C_HI);
	// 
	if (arrResults == null || arrResults.length == 0)
	{
		return null;
	}
	// 
	sortArray (arrResults, "compareCombinations", S_DESCENDING);
	// 
	return arrResults.shift ();
}
// ============================================================================
// 
// ============================================================================
function getWorstCombination (arrSharedCards, arrUserCards)
{
	// 
	bDetectLoCombination = true;
	//
	var arrResults = createCombinations (arrSharedCards, arrUserCards, C_LO);
	// 
	if (arrResults == null || arrResults.length == 0)
	{
		return null;
	}
	// looking for Lo hands
	sortArray (arrResults, "compareCombinations");
	// 
	return arrResults.shift ();
}
// ============================================================================
// 
// ============================================================================
function detectCombination (arrCards, nHiLo)
{
	// 
	arrCards.Kind == CCK_EMPTY;
	// 
	for (var i = 0; i < arrCards.length; i++)
	{
		// 
		var valueCnt = 0;
		var suitCnt = 0;
		// 
		for (var j = 0; j < arrCards.length; j++)
		{
			// 
			if (arrCards[i].Value == arrCards[j].Value)
			{
				valueCnt++;
			}
			// 
			if (arrCards[i].Suit == arrCards[j].Suit)
			{
				suitCnt++;
			}
			// 
		}
		// 
		arrCards[i].valueCnt = valueCnt;
		arrCards[i].suitCnt = suitCnt;
		// 
	}
	// 
	sortArray (arrCards, "sortCards", S_DESCENDING);
	// 
	// start looking for the combination
	if (arrCards[0].valueCnt == 4)
	{
		// four of a kind
		arrCards.Kind = CCK_4_OF_A_KIND;
		// 
	}
	else if (arrCards[0].valueCnt == 3)
	{
		// tree of a kind
		arrCards.Kind = CCK_3_OF_A_KIND;
		// 
		if (arrCards.length == 5)
		{
			if (arrCards[3].valueCnt == 2)
			{
				// full house
				arrCards.Kind = CCK_FULL_HOUSE;
				// 
			}
		}
		// 
	}
	else if (arrCards[0].valueCnt == 2)
	{
		// one pair
		arrCards.Kind = CCK_ONE_PAIR;
		// 
		if (arrCards.length > 2 && arrCards[2].valueCnt == 2)
		{
			// two pair
			arrCards.Kind = CCK_TWO_PAIR;
			// 
		}
		// 
	}
	else if (arrCards[0].valueCnt == 1 && arrCards.length == 5)
	{
		// high card
		arrCards.Kind = CCK_HIGH_CARD;
		// 
		if (nHiLo == C_HI)
		{
			if (arrCards[0].suitCnt == 5)
			{
				// flush
				arrCards.Kind = CCK_FLUSH;
				// 
			}
			// 
			var bStraight = false;
			// 
			if ((arrCards[0].Value - arrCards[4].Value) == 4)
			{
				// 
				bStraight = true;
				// 
			}
			else if (arrCards[0].Value == CV_ACE && arrCards[1].Value == CV_5 && arrCards[2].Value == CV_4 && arrCards[3].Value == CV_3 && arrCards[4].Value == CV_2)
			{
				// 
				bStraight = true;
				var First = arrCards.shift ();
				arrCards.push (First);
				// 
			}
			// 
			if (bStraight)
			{
				// 
				if (arrCards.Kind == CCK_FLUSH)
				{
					// straight flush
					arrCards.Kind = CCK_STRAIGHT_FLUSH;
					// 
					if (arrCards[0].Value == CV_ACE)
					{
						// royal flush
						arrCards.Kind = CCK_ROYAL_FLUSH;
						// 
					}
					// 
				}
				else
				{
					// straight
					arrCards.Kind = CCK_STRAIGHT;
					// 
				}
				// 
			}
			// 
		}
		else if (nHiLo == C_LO)
		{
			// 
			if (arrCards[0].Value < CV_9)
			{
				// Lo
				arrCards.Kind = CCK_LO_COMBINATION;
				// 
			}
			else if (arrCards[0].Value == CV_ACE && arrCards[1].Value < CV_9)
			{
				// Lo
				arrCards.Kind = CCK_LO_COMBINATION;
				// 
				var First = arrCards.shift ();
				//First.Value = CV_LO_ACE;
				arrCards.push (First);
				// 
			}
			// 
		}
		// 
	}
	return arrCards;
}
// ============================================================================
// 
// ============================================================================
function combinationToStr (arrCombination)
{
	// 
	var arrCombinationsMap = new Array ("Unknown", "High card", "One pair", "Two pair", "Three of a kind", "Straight", "Flush", "Full House", "Four of a kind", "Straight Flush", "Royal Flush", "");
	var sResult = "";
	// 
	if (arrCombination.Kind > 0 && arrCombination.Kind < 12)
	{
		// 
		sResult = arrCombinationsMap[arrCombination.Kind];
		switch (arrCombination.Kind)
		{
		case CCK_HIGH_CARD :
			sResult += ", " + cardValueToStr (arrCombination[0].Value) + " high";
			break;
		case CCK_ONE_PAIR :
			sResult += ", " + cardsPluralForm (arrCombination[0]);
			break;
		case CCK_TWO_PAIR :
			sResult += ", " + cardsPluralForm (arrCombination[0]) + " and " + cardsPluralForm (arrCombination[2]);
			break;
		case CCK_3_OF_A_KIND :
			sResult += ", " + cardsPluralForm (arrCombination[0]);
			break;
		case CCK_STRAIGHT :
			sResult += ", " + cardValueToStr (arrCombination[arrCombination.length - 1].Value) + " to " + cardValueToStr (arrCombination[0].Value);
			break;
		case CCK_FLUSH :
			sResult += ", " + cardValueToStr (arrCombination[0].Value) + " high";
			break;
		case CCK_FULL_HOUSE :
			sResult += ", " + cardsPluralForm (arrCombination[0]) + " full of " + cardsPluralForm (arrCombination[3]);
			break;
		case CCK_4_OF_A_KIND :
			sResult += ", " + cardsPluralForm (arrCombination[0]);
			break;
		case CCK_STRAIGHT_FLUSH :
			sResult += ", " + cardValueToStr (arrCombination[0].Value) + " high";
			break;
		case CCK_LO_COMBINATION :
			sResult = arrCombination[0].Value + "," + arrCombination[1].Value + "," + arrCombination[2].Value + "," + arrCombination[3].Value + ",";
			if (arrCombination[4].Value == CV_ACE)
			{
				sResult += "A";
			}
			else
			{
				sResult += arrCombination[4].Value;
			}
			break;
		}
		// 
	}
	else
	{
		// 
		sResult = arrCombinationsMap[0];
		// 
	}
	// 
	return sResult;
}
// ============================================================================
// 
// ============================================================================
function createCombinations (arrSharedCards, arrUserCards, nHiLo)
{
	// 
	if (arrUserCards == undefined || arrUserCards.length == 0 || arrUserCards.nActiveCards == 0)
	{
		return null;
	}
	// 
	if (arrUserCards.length < arrUserCards.nActiveCards)
	{
		arrUserCards.nActiveCards = arrUserCards.length;
	}
	// 
	if (arrSharedCards.length < arrSharedCards.nActiveCards)
	{
		arrSharedCards.nActiveCards = arrSharedCards.length;
	}
	// 
	var arrSharedCombinations = new Array ();
	var arrUserCombinations = new Array ();
	// 
	if (arrSharedCards <> undefined && arrSharedCards.length > 0)
	{
		arrSharedCombinations = getCombinations (arrSharedCards, arrSharedCards.nActiveCards);
	}
	// 
	arrUserCombinations = getCombinations (arrUserCards, arrUserCards.nActiveCards);
	var arrResults = new Array ();
	// 
	for (var i = 0; i < arrUserCombinations.length; i++)
	{
		if (arrSharedCombinations.length > 0)
		{
			for (var j = 0; j < arrSharedCombinations.length; j++)
			{
				// 
				var arrTempCombination = arrUserCombinations[i].concat (arrSharedCombinations[j]);
				// 
				detectCombination (arrTempCombination, nHiLo);
				// save result
				if (nHiLo == C_HI || (nHiLo == C_LO && arrTempCombination.Kind == CCK_LO_COMBINATION))
				{
					arrResults.push (arrTempCombination);
				}
				// 
			}
		}
		else
		{
			// 
			detectCombination (arrUserCombinations[i], nHiLo);
			// save result
			if (nHiLo == C_HI || (nHiLo == C_LO && arrUserCombinations[i].Kind == CCK_LO_COMBINATION))
			{
				arrResults.push (arrUserCombinations[i]);
			}
			// 
		}
		// 
	}
	// 
	return arrResults;
}
// ============================================================================
// 
// ============================================================================
function sortCards (a, b)
{
	// 
	var nResult = CC_EQUAL;
	// 
	if (a.valueCnt > b.valueCnt)
	{
		// 
		nResult = CC_GREATER;
		// 
	}
	else if (a.valueCnt < b.valueCnt)
	{
		// 
		nResult = CC_LESS;
		// 
	}
	else if (a.valueCnt == b.valueCnt)
	{
		// 
		if (a.Value > b.Value)
		{
			// 
			nResult = CC_GREATER;
			// 
		}
		else if (a.Value < b.Value)
		{
			// 
			nResult = CC_LESS;
			// 
		}
		else if (a.Value == b.Value)
		{
			// 
			if (a.Suit > b.Suit)
			{
				// 
				nResult = CC_GREATER;
				// 
			}
			else if (a.Suit < b.Suit)
			{
				// 
				nResult = CC_LESS;
				// 
			}
			else if (a.Suit == b.Suit)
			{
				// 
			}
			// 
		}
		// 
	}
	// 
	return nResult;
}
// ============================================================================
// 
// ============================================================================
function getCombinations (arrElements, nCnt)
{
	// 
	var arrResult = new Array ();
	// 
	for (var i = 0; i < arrElements.length; i++)
	{
		if (nCnt > 1)
		{
			// 
			var arrTempElements = arrElements.slice (i + 1);
			// 
			if (arrTempElements.length >= nCnt - 1)
			{
				// recursive call
				var arrTempResult = getCombinations (arrTempElements, nCnt - 1);
				// 
				for (var j = 0; j < arrTempResult.length; j++)
				{
					arrResult.push (arrTempResult[j].concat (arrElements[i]));
				}
				// 
			}
			// 
		}
		else
		{
			// 
			var arrTempResult = new Array ();
			arrTempResult.push (arrElements[i]);
			// 
			arrResult.push (arrTempResult);
			// 
		}
	}
	// 
	return arrResult;
}
// ============================================================================
// 
// ============================================================================
function compareCombinations (a, b)
{
	// 
	var nResult = CC_EQUAL;
	// 
	if (a.Kind > b.Kind)
	{
		// 
		nResult = CC_GREATER;
		// 
	}
	else if (a.Kind < b.Kind)
	{
		// 
		nResult = CC_LESS;
		// 
	}
	else if (a.Kind == b.Kind)
	{
		// 
		for (var i = 0; i < a.length; i++)
		{
			// 
			if (bDetectLoCombination && a[i].Value <> b[i].Value && (a[i].Value == CV_ACE || b[i].Value == CV_ACE))
			{
				//
				if (a[i].Value == CV_ACE)
				{
					//
					nResult = CC_LESS;
					break;
					//
				}
				else if (b[i].Value == CV_ACE)
				{
					//
					nResult = CC_GREATER;
					break;
					//
				}
				//
			}
			else if (a[i].Value > b[i].Value)
			{
				// 
				nResult = CC_GREATER;
				break;
				// 
			}
			else if (a[i].Value < b[i].Value)
			{
				// 
				nResult = CC_LESS;
				break;
				// 
			}
			else if (a[i].Value == b[i].Value)
			{
				// 
				if (a[i].Suit > b[i].Suit)
				{
					// 
					nResult = CC_GREATER;
					break;
					// 
				}
				else if (a[i].Suit < b[i].Suit)
				{
					// 
					nResult = CC_LESS;
					break;
					// 
				}
				else if (a[i].Suit == b[i].Suit)
				{
					// 
				}
			}
			// 
		}
		// 
	}
	// 
	return nResult;
}
// ============================================================================
// 
// ============================================================================
function cardsPluralForm (objCard)
{
	// 
	var sResult = "";
	// 
	if (objCard.Value <> CV_6)
	{
		sResult = cardValueToStr (objCard.Value) + "s";
	}
	else
	{
		sResult = cardValueToStr (objCard.Value) + "es";
	}
	// 
	return sResult;
}
// ============================================================================
// 
// ============================================================================
function cardValueToStr (nValue)
{
	// 
	var sResult = "";
	var arrCardsMap = new Array ("deuce", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "jack", "queen", "king", "ace");
	// 
	if (nValue > 1 && nValue < 15)
	{
		sResult = arrCardsMap[nValue - 2];
	}
	// 
	return sResult;
}
// ============================================================================
// 
// ============================================================================
function sortArray (arrSort, sSortFunction, nMethod)
{
	// 
	var arrResult = new Array ();
	// 
	if (nMethod == undefined)
	{
		nMethod = S_ASCENDING;
	}
	//
	// sort array using bubble sort
	for (var i = 0; i < arrSort.length; i++)
	{
		for (var j = arrSort.length - 1; j > i; j--)
		{
			if (sSortFunction == undefined || sSortFunction == "")
			{
				if (arrSort[j - 1] > arrSort[j])
				{
					swapElementsOfArray (arrSort, j - 1, j);
				}
			}
			else
			{
				// 
				if (sSortFunction == "sortCards")
				{
					if (sortCards (arrSort[j - 1], arrSort[j]) == CC_GREATER)
					{
						swapElementsOfArray (arrSort, j - 1, j);
					}
				}
				else if (sSortFunction == "compareCombinations")
				{
					if (compareCombinations (arrSort[j - 1], arrSort[j]) == CC_GREATER)
					{
						swapElementsOfArray (arrSort, j - 1, j);
					}
				}
				// 
			}
		}
	}
	//
	if (nMethod == S_DESCENDING)
	{
		//
		arrSort.reverse ();
		//
	}
	// 
}
// ============================================================================
// 
// ============================================================================
function swapElementsOfArray (array, i1, i2)
{
	// 
	var temp = array[i1];
	// 
	array[i1] = array[i2];
	// 
	array[i2] = temp;
	// 
}
// ****************************************************************************
//
function getUserBestCombination (arrSharedCards, nSharedCards, arrUserCards, nUserCards)
{
	//
	arrSharedCards.nActiveCards = nSharedCards;
	arrUserCards.nActiveCards = nUserCards;
	//
	var arrBest = new Array ();
	arrBest = getBestCombination (arrSharedCards, arrUserCards);
	//
	arrBest.sCombination = "";
	if (arrBest <> null)
	{
		arrBest.sCombination = combinationToStr (arrBest);
	}
	//
	return arrBest;
}
//
function getUserWorstCombination (arrSharedCards, nSharedCards, arrUserCards, nUserCards)
{
	//
	arrSharedCards.nActiveCards = nSharedCards;
	arrUserCards.nActiveCards = nUserCards;
	//
	var arrWorst = new Array ();
	arrWorst = getWorstCombination (arrSharedCards, arrUserCards);
	//
	arrWorst.sCombination = "";
	if (arrWorst <> null)
	{
		arrWorst.sCombination = combinationToStr (arrWorst);
	}
	//
	return arrWorst;
}
//
function showHandRank ()
{
	//
	clearInterval (nHandRankInterval);
	//
	if (!objUser.isPlaying && !objUser.isAllIn)
	{
		return;
	}
	//
	var arrBestCards = new Array ();
	var arrWorstCards = new Array ();
	//
	if (objTable.studPoker)
	{
		//
		if (arrSits[objUser.numSit].arrCards.length > 4)
		{
			//
			var arrUserCards = arrShareCards.concat (arrSits[objUser.numSit].arrCards);
			//
			arrBestCards = getUserBestCombination (new Array (), 0, arrUserCards, 5);
			//
			if (objTable.bHiLoPoker)
			{
				//
				mcMsgRanking.setLabel ("HI: " + arrBestCards.sCombination);
				//
				arrWorstCards = getUserWorstCombination (new Array (), 0, arrUserCards, 5);
				//
				if (arrWorstCards <> undefined)
				{
					//
					mcMsgRanking.setLabel (mcMsgRanking.getLabel () + "\nLO: " + arrWorstCards.sCombination);
					objUser.rankCardsLo = arrWorstCards.sCombination;
					//
				}
				//
			}
			else
			{
				//
				mcMsgRanking.setLabel (arrBestCards.sCombination);
				//
			}
			//
		}
		//
	}
	else if (objTable.pokerType == 1)
	{
		//
		if (arrSits[objUser.numSit].arrCards.length == 2 && arrShareCards.length > 2)
		{
			//
			var arrUserCards = arrShareCards.concat (arrSits[objUser.numSit].arrCards);
			//
			arrBestCards = getUserBestCombination (new Array (), 0, arrUserCards, 5);
			//
			mcMsgRanking.setLabel (arrBestCards.sCombination);
			//
		}
		//
	}
	else if (objTable.pokerType == 2 || objTable.pokerType == 3)
	{
		//
		if (arrShareCards.length > 2)
		{
			//
			var arrUserCards = arrSits[objUser.numSit].arrCards.slice (0);
			//
			arrBestCards = getUserBestCombination (arrShareCards, 3, arrUserCards, 2);
			//
			if (objTable.bHiLoPoker)
			{
				//
				mcMsgRanking.setLabel ("HI: " + arrBestCards.sCombination);
				//
				arrWorstCards = getUserWorstCombination (arrShareCards, 3, arrUserCards, 2);
				//
				if (arrWorstCards <> undefined)
				{
					//
					mcMsgRanking.setLabel (mcMsgRanking.getLabel () + "\nLO: " + arrWorstCards.sCombination);
					objUser.rankCardsLo = arrWorstCards.sCombination;
					//
				}
				//
			}
			else
			{
				//
				mcMsgRanking.setLabel (arrBestCards.sCombination);
				//
			}
			//
		}
		//
	}
	//
}
