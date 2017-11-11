function setSharePots (xmlPots)
{
	if (xmlPots.nodeName <> "pots")
	{
		return;
	}
	deleteMovingBets ();
	//
	for (var j = 0; j < xmlPots.childNodes.length; j++)
	{
		if (xmlPots.childNodes[j].nodeName.toLowerCase () == "pot")
		{
			var xmlPot = xmlPots.childNodes[j];
			var numPot = Number (xmlPot.attributes.id);
			var potAmount = Number (xmlPot.attributes.amount);
			//
			var objPot;
			if (eval ("mcSharePot" + numPot) == undefined)
			{
				attachMovie ("CChips", "mcSharePot" + numPot, numChipsDepth + numPot);
				var objPot = eval ("mcSharePot" + numPot);
				//
				objPot.nMaxColumnCnt = 7;
				//
				objPot._x = arrPotCrd[numPot][0];
				objPot._y = arrPotCrd[numPot][1];
				if (numPot == 0)
				{
					objPot.setName ("Main pot");
				}
				else
				{
					objPot.setName ("Side Pot " + numPot);
				}
				objPot.setCurrency (objTable.currencyId);
				objPot.setType ("pot");
				arrMainPots.push (objPot);
			}
			else
			{
				var objPot = eval ("mcSharePot" + numPot);
			}
			objPot.setChips (potAmount);
		}
	}
	showTablePotsAmount ();
}
//
function showTablePotsAmount ()
{
	var strMsg = "";
	var numPotSum = 0;
	for (var i = 0; i < arrMainPots.length; i++)
	{
		numPotSum += arrMainPots[i].getAmount ();
	}
	var numBetSum = getBetAmount ();
	if (numPotSum == 0 && numBetSum == 0)
	{
		txtPotsAmount.text = "";
		txtPotsAmount._visible = false;
	}
	else if (numPotSum == 0)
	{
		txtPotsAmount._visible = true;
		txtPotsAmount.text = "Bets: " + objTable.currencySign + moneyFormat (numBetSum, Number (numBetSum % 1 > 0));
	}
	else if (numBetSum == 0)
	{
		txtPotsAmount._visible = true;
		txtPotsAmount.text = "Pot: " + objTable.currencySign + moneyFormat (numPotSum, Number (numPotSum % 1 > 0));
	}
	else
	{
		txtPotsAmount._visible = true;
		txtPotsAmount.text = "Pot + Bets: " + objTable.currencySign + moneyFormat ((numPotSum + numBetSum), Number ((numPotSum + numBetSum) % 1 > 0));
	}
	//CORRECTION
	if (txtPotsAmount._visible){
		var height = txtPotsAmount.textHeight+3;
		var width = txtPotsAmount.textWidth+5;
		txtPotsAmount._height = height;
		txtPotsAmount._width = width;
		txtPotsAmount._x = 388-txtPotsAmount._width/2;
		txtPotsAmount._y = 11-txtPotsAmount._height/2;
	}
}
//
function setRake (newAmount)
{
	if (mcRake <> undefined)
	{
		mcRake.nMaxColumnCnt = 1;
		if (mcRake.getAmount () <> newAmount)
		{
			mcRake.setCurrency (objTable.currencyId);
			mcRake.setChips (newAmount);
		}
	}
}
//
function addToWonPot (numSit, amount)
{
	if (arrSits[numSit].objWonPot <> null)
	{
		var numSum = arrSits[numSit].objWonPot.getAmount () + amount;
		arrSits[numSit].objWonPot.setChips (numSum);
	}
}
//
function getBetAmount ()
{
	var amount = 0;
	for (var i = 0; i < arrPlayerPots.length; i++)
	{
		amount += arrPlayerPots[i].getAmount ();
	}
	return amount;
}
//
function getMaxBet ()
{
	var maxBet = 0;
	for (var i = 0; i < arrPlayerPots.length; i++)
	{
		maxBet = Math.max (arrPlayerPots[i].getAmount (), maxBet);
	}
	return maxBet;
}
//
function moveBets (xmlBets)
{
	if (xmlBets.nodeName <> "movebets")
	{
		return;
	}
	var numMovingBet = 0;
	var betCnt = 0;
	for (var j = 0; j < xmlBets.childNodes.length; j++)
	{
		if (xmlBets.childNodes[j].nodeName.toLowerCase () == "move")
		{
			betCnt++;
			//
			var numSit = Number (xmlBets.childNodes[j].attributes.position);
			var numPot = Number (xmlBets.childNodes[j].attributes.potid);
			var numAmount = Number (xmlBets.childNodes[j].attributes.amount);
			var currPot = arrSits[numSit].getPot ();
			//
			attachMovie ("CChips", "mcMovingBet" + numMovingBet, numChipsDepth + 500 + numMovingBet);
			var objBet = eval ("mcMovingBet" + numMovingBet);
			numMovingBet++;
			objBet._x = arrPlayerPotCrd[numSit][0];
			objBet._y = arrPlayerPotCrd[numSit][1];
			objBet.setCurrency (objTable.currencyId);
			objBet.setName ("Bet");
			objBet.setType ("bet");
			objBet.numPot = numPot;
			objBet.numSit = numSit;
			objBet.setAlign (arrPlayerPotCrd[numSit][2]);
			objBet.setChips (numAmount);
			//objBet.nextAction = "remove";
			//
			if (arrPotCrd[numPot][0] == undefined || arrPotCrd[numPot][1] == undefined)
			{
				objBet.moveChipsTo (arrPotCrd[0][0], arrPotCrd[0][1]);
			}
			else
			{
				objBet.moveChipsTo (arrPotCrd[numPot][0], arrPotCrd[numPot][1]);
			}
			arrSits[numSit].setPot (currPot - numAmount);
			arrMovingBets.push (objBet);
		}
		else if (xmlBets.childNodes[j].nodeName.toLowerCase () == "returnbet")
		{
			var numSit = Number (xmlBets.childNodes[j].attributes.position);
			var numBalance = Number (xmlBets.childNodes[j].attributes.newbalance);
			var numAmount = Number (xmlBets.childNodes[j].attributes.amount);
			//
			if (!isNaN (numSit) && arrSits[numSit] <> undefined)
			{
				arrSits[numSit].setAmount (numBalance);
				if (objUser.isPlayer && numSit == objUser.numSit)
				{
					setUserBalance (numBalance);
				}
			}
		}
	}
	if (betCnt > 0)
	{
		sndChipsSliding.start ();
	}
}
//
function addToPot (pot, amount)
{
	if (arrMainPots[pot] <> undefined)
	{
		arrMainPots[pot].setChips (amount + arrMainPots[pot].getAmount ());
	}
}
//
function clearBets ()
{
	for (var i = 0; i < arrSits.length; i++)
	{
		arrSits[i].setPot (0);
	}
}
//
function getRoundBet ()
{
	if (objTable.numRound <= 2)
	{
		return objTable.minStake;
	}
	else
	{
		return objTable.maxStake;
	}
}
//
function getMaxRaiseCnt ()
{
	return 4;
}
//
function finalPot (xmlPot)
{
	if (xmlPot.nodeName <> "finalpot")
	{
		return;
	}
	if (objUser.isPlaying)
	{
		mcControls.gotoAndStop ("player");
		enableCBXS = false;
		mcControls.clearCBX ();
		mcControls.hideCBX ();
	}
	//
	mcControls.cbxMuck._visible = false;
	if (getBetAmount () > 0)
	{
		clearBets ();
	}
	deleteMovingBets ();
	//
	var numPot = Number (xmlPot.attributes.id);
	//
	arrMainPots[numPot].clearAll ();
	var bIsWinner = false;
	//
	for (var k = 0; k < xmlPot.childNodes.length; k++)
	{
		if (xmlPot.childNodes[k].nodeName.toLowerCase () == "winner")
		{
			xmlWinner = xmlPot.childNodes[k];
			var numSit = Number (xmlWinner.attributes.position);
			var numPotPart = Number (xmlWinner.attributes.amount);
			var numNewBalance = Number (xmlWinner.attributes.newbalance);
			var strCards = String (xmlWinner.attributes.cards);
			//
			var strPotName = "mcWinnerPot" + String (numPot) + String (k);
			attachMovie ("CChips", strPotName, numChipsDepth + 700 + 10 * numPot + k);
			var objPot = eval (strPotName);
			//
			objPot._x = arrPotCrd[numPot][0];
			objPot._y = arrPotCrd[numPot][1];
			objPot.setCurrency (objTable.currencyId);
			objPot.setName ("Pot");
			objPot.setType ("winpot");
			objPot.numSit = numSit;
			objPot.steps *= 2;
			objPot.setAlign (arrPlayerPotCrd[numSit][2]);
			objPot.setChips (numPotPart);
			//
			objPot.startMoving ();
			//objPot.moveChipsTo(arrPlayerPotCrd[numSit][0], arrPlayerPotCrd[numSit][1]);
			//
			if (arrSits[numSit].objWonPot == null)
			{
				arrSits[numSit].objWonPot = objPot;
			}
			else
			{
				objPot.nextAction = "upwonpot";
			}
			arrWinnerPots.push (objPot);
			sndChipsSliding.start ();
			//
			arrSits[numSit].setAmount (numNewBalance);
			if (objUser.isPlayer && numSit == objUser.numSit)
			{
				setUserBalance (numNewBalance);
				objUser.objStats.result = "won";
				bIsWinner = true;
			}
			//
			if (strCards <> undefined && strCards <> "" && arrSits[numSit].arrCards.length > 0)
			{
				// community's cards
				for (var i = 0; i < arrShareCards.length; i++)
				{
					if (arrShareCards[i].name <> "back" && !arrShareCards[i].won)
					{
						arrShareCards[i].setDark ();
					}
				}
				//player's cards
				for (var i = 0; i < arrSits.length; i++)
				{
					for (var j = 0; j < arrSits[i].arrCards.length; j++)
					{
						if (arrSits[i].arrCards[j].name <> "back" && !arrSits[i].arrCards[j].won && !arrSits[i].arrCards[j].isFold)
						{
							arrSits[i].arrCards[j].setDark ();
						}
					}
				}
				winnerCards (strCards, numSit);
			}
		}
		else if (xmlPot.childNodes[k].nodeName.toLowerCase () == "chat")
		{
			addChat (xmlPot.childNodes[k], 1);
		}
	}
	//
	if (objTable.nWC > 1)
	{
		if (bIsWinner)
		{
			sndWinning.start ();
			if (objUser.objStats.bInHand)
			{
				objUser.objStats.nWinShowdownCount++;
			}
		}
		if (objUser.objStats.bInHand)
		{
			objUser.objStats.nShowdownCount++;
		}
	}
	//
	showTablePotsAmount ();
}
//
function deleteMovingBets ()
{
	for (var i = arrMovingBets.length - 1; i >= 0; i--)
	{
		arrMovingBets[i].removeMovieClip ();
	}
	arrMovingBets.splice (0);
}
