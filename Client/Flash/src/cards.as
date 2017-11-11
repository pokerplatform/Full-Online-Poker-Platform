function newCard (name)
{
	var cardName = name;
	if (cardName == "back")
	{
		cardName += String (numCardCnt);
		//} else if (eval(cardName)<>undefined) {return;
	}
	if (eval (cardName) == undefined)
	{
		var card = attachMovie ("CCard", cardName, numCardsDepth + numCardCnt);
	}
	else
	{
		var card = eval (cardName);
		card.nextAction = "";
		card.isFold = false;
		card._alpha = 100;
		card.card.mcMask.gotoAndStop ("all");
		card.swapDepths (numCardsDepth + numCardCnt);
	}
	if (name <> "" && name <> "back")
	{
		card.setCard (name);
		if (objUser.fourColorCards)
		{
			card.card.gotoAndStop ("4colors");
		}
	}
	else
	{
		card.back.gotoAndStop (objTable.cardBackName + objUser.deckColor);
	}
	card._x = numDeckX;
	card._y = numDeckY;
	card._visible = false;
	card.depth = numCardsDepth + numCardCnt;
	numCardCnt++;
	//
	return card;
}
//
function setShareCards (strCardsName)
{
	if (strCardsName == undefined || strCardsName == "")
	{
		return;
	}
	removeShareCards ();
	var arrTemp = strCardsName.split (",");
	for (var i = 0; i < arrTemp.length; i++)
	{
		var objCard = newCard (arrTemp[i]);
		if (objCard <> undefined)
		{
			objCard._x = numShareCardsX + i * numCardWidth;
			objCard._y = numShareCardsY;
			objCard.type = "table";
			objCard._visible = true;
			arrShareCards.push (objCard);
		}
	}
	//
	if (!bRobot && (objUser.isPlaying || objUser.isAllIn))
	{
		clearInterval (nHandRankInterval);
		nHandRankInterval = setInterval (showHandRank, 100);
	}
	//
}
//
function dealShareCards (strCardsName)
{
	var arrTemp = strCardsName.split (",");
	var blnDeal = false;
	if (numRound == 1)
	{
		removeShareCards ();
	}
	for (var i = 0; i < arrTemp.length; i++)
	{
		var blnExists = false;
		for (var j = 0; j < arrShareCards.length; j++)
		{
			if (arrShareCards[j].name == arrTemp[i])
			{
				blnExists = true;
				break;
			}
		}
		if (!blnExists)
		{
			var objCard = _root.newCard (arrTemp[i]);
			if (objCard <> undefined)
			{
				objCard.newX = numShareCardsX + arrShareCards.length * numCardWidth;
				objCard.newY = numShareCardsY;
				objCard.type = "table";
				arrShareCards.push (objCard);
				arrDealingCards.push (objCard);
				blnDeal = true;
			}
			//
		}
	}
	//
	if (blnDeal)
	{
		//
		mcDealCards.gotoAndPlay ("deal");
		sndFlopDealing.start ();
		//
		if (!bRobot && (objUser.isPlaying || objUser.isAllIn))
		{
			clearInterval (nHandRankInterval);
			nHandRankInterval = setInterval (showHandRank, 300);
		}
		//
	}
	//
}
function removeShareCards ()
{
	for (var i = 0; i < arrShareCards.length; i++)
	{
		arrShareCards[i].removeMovieClip ();
	}
	arrShareCards.splice (0);
}
function getDeckCoordinates ()
{
	var deck = new Object ();
	deck.x = numDeckX;
	deck.y = numDeckY;
	return deck;
}
function dealCards (xmlDealCards)
{
	var numRound = String (xmlDealCards.attributes.round);
	//objTable.numRound = numRound;
	var strShareCards = "";
	var poketCards = 0;
	for (var i = 0; i < xmlDealCards.childNodes.length; i++)
	{
		if (xmlDealCards.childNodes[i].nodeName.toLowerCase () == "deal")
		{
			var numSit = Number (xmlDealCards.childNodes[i].attributes.position);
			if (xmlDealCards.childNodes[i].attributes.cards <> undefined)
			{
				var strCards = String (xmlDealCards.childNodes[i].attributes.cards);
				var arrTemp = strCards.split (",");
				for (var c = arrSits[numSit].arrCards.length; c < arrTemp.length; c++)
				{
					//
					arrSits[numSit].addCard (arrTemp[c]);
					poketCards++;
					//
					if (numSit == objUser.numSit)
					{
						objUser.objStats.bInHand = true;
						//
						if (!bRobot)
						{
							clearInterval (nHandRankInterval);
							nHandRankInterval = setInterval (showHandRank, 500);
						}
						//
					}
				}
			}
		}
		else if (xmlDealCards.childNodes[i].nodeName.toLowerCase () == "communitycards")
		{
			strShareCards = String (xmlDealCards.childNodes[i].attributes.value);
		}
	}
	//arrDealingCards.splice(0)
	for (var j = 0; j < 7; j++)
	{
		for (var i = 0; i < arrHandSits.length; i++)
		{
			if (arrHandSits[i].arrCards[j] <> undefined && arrHandSits[i].arrCards[j].newX <> arrHandSits[i].arrCards[j]._x && !arrHandSits[i].arrCards[j].isFold)
			{
				arrHandSits[i].arrCards[j].swapDepths (numCardsMovingDepth + arrDealingCards.length);
				arrDealingCards.push (arrHandSits[i].arrCards[j]);
			}
		}
	}
	if (poketCards > 0)
	{
		if (objTable.studPoker)
		{
			if (numRound == 1)
			{
				mcChat.addMessage ("*** DEALING ***", 0, 0, "", 10, 0);
			}
			else if (numRound > 1 && numRound < arrRoundName.length)
			{
				mcChat.addMessage ("*** DEALING " + arrRoundName[numRound - 1].toUpperCase () + " ***", 0, 0, "", 10, 0);
			}
		}
		else
		{
			if (numRound == 1)
			{
				mcChat.addMessage ("*** DEALING POCKETS ***", 0, 0, "", 10, 0);
			}
		}
	}
	if (strShareCards <> "")
	{
		if (objTable.studPoker)
		{
			mcChat.addMessage ("*** DEALING COMMON RIVER CARD ***", 0, 0, "", 10, 0);
		}
		else
		{
			if (numRound > 1 && numRound < arrRoundName.length)
			{
				mcChat.addMessage ("*** DEALING " + arrRoundName[numRound - 1].toUpperCase () + " ***", 0, 0, "", 10, 0);
			}
		}
		dealShareCards (strShareCards);
	}
	if (numRound == 2 && objUser.objStats.bInHand)
	{
		if (objUser.isPlaying || objUser.isAllIn)
		{
			objUser.objStats.bFlopSeen = true;
		}
		objUser.objStats.bFlopParticipate = true;
	}
	if (poketCards > 0)
	{
		mcDealCards.gotoAndPlay ("deal");
		cardsDealed = true;
		if (objUser.isPlaying && objTable.numRound < objTable.numShowDownRound && getUserBalance () > 0)
		{
			enableCBXS = true;
			mcControls.gotoAndStop ("player");
			mcControls.setCBXAction ();
		}
	}
}
//
function winnerCards (cards, sit)
{
	// select the best cards
	var numEffect = Math.floor (Math.random () * 2);
	var arrTemp = cards.split (",");
	for (var i = 0; i < arrTemp.length; i++)
	{
		objCard = eval (arrTemp[i]);
		if (objCard <> undefined)
		{
			if (!objCard.won)
			{
				//if (!objTable.studPoker) {objCard._y -= 8;}
				objCard.setNormal ();
				objCard.won = true;
			}
			if (sit == objUser.numSit && objUser.animationEnable)
			{
				objCard.showEffect (numEffect);
			}
		}
	}
}
