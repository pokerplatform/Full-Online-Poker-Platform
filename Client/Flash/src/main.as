_global.g_sChipsName = "chips";
var winShowInterval = null;
//
function openWinWithDuration (winName, duration_num){
	var nDepth = nWinDurationDepth;
	var nX = gameWidth / 2 + arrWindows.length * 15;
	var nY = gameHeight / 2 + arrWindows.length * 10;
	//
	if (arrWindows.length > 0)
	{
		nDepth = arrWindows[arrWindows.length - 1].getDepth () + 10;
	}
	//
	attachMovie (winName, winName, nDepth);
	var objNewWin = eval (winName);
	objNewWin._x = nX;
	objNewWin._y = nY;
	arrWindows.push (objNewWin);

	clearInterval(winShowInterval);
	winShowInterval = setInterval(clearWinShowInterval, Number(duration_num), winName);
}

function clearWinShowInterval(winName){
	closeWin(eval(winName));
	clearInterval(winShowInterval);
}
//
function openWin (winName)
{
	//
	var nDepth;
	var nX = gameWidth / 2 + arrWindows.length * 15;
	var nY = gameHeight / 2 + arrWindows.length * 10;
	//
	if (arrWindows.length > 0)
	{
		nDepth = arrWindows[arrWindows.length - 1].getDepth () + 10;
	}
	else if (mcWinBack == undefined)
	{
			nDepth = nWinDepth + 10;
			// attach windows back
			attachMovie ("CWinBack", "mcWinBack", nWinDepth - 1);
			mcWinBack._x = gameWidth / 2;
			mcWinBack._y = gameHeight / 2;
	}
	//
	attachMovie (winName, winName, nDepth);
	var objNewWin = eval (winName);
	objNewWin._x = nX;
	objNewWin._y = nY;
	arrWindows.push (objNewWin);
}
//
function closeWin (pWin)
{
	if (pWin <> undefined)
	{
		for (var i = 0; i < arrWindows.length; i++)
		{
			if (arrWindows[i] == pWin)
			{
				trace (arrWindows[i])
				arrWindows.splice (i, 1);
				break;
			}
		}
		pWin.removeMovieClip ();
		if (arrWindows.length == 0) {
			Selection.setFocus(mcChat.txtNewMsg);
			Selection.setSelection (_level0.mcChat.txtNewMsg.length+1,_level0.mcChat.txtNewMsg.length+1);
		}
	}
	if (arrWindows.length == 0 && mcWinBack <> undefined)
	{
		mcWinBack.removeMovieClip ();
	}
}
// =====================================================
function initSounds ()
{
	sndGlobalSound = new Sound ();
	sndDing = new Sound ();
	sndDing.attachSound ("ding");
	sndMoveButton = new Sound ();
	sndMoveButton.attachSound ("moved_button");
	sndSitdown = new Sound ();
	sndSitdown.attachSound ("sitdown");
	sndYourTurn = new Sound ();
	sndYourTurn.attachSound ("your_turn");
	sndWakeUp = new Sound ();
	sndWakeUp.attachSound ("wake_up");
	sndCheck = new Sound ();
	sndCheck.attachSound ("check");
	sndChipsBetting = new Sound ();
	sndChipsBetting.attachSound ("chips_betting");
	sndChipsCalling = new Sound ();
	sndChipsCalling.attachSound ("chips_calling");
	sndChipsSliding = new Sound ();
	sndChipsSliding.attachSound ("chips_sliding");
	sndCardsDealing = new Sound ();
	sndCardsDealing.attachSound ("cards_dealing");
	sndCardsFolding = new Sound ();
	sndCardsFolding.attachSound ("cards_folding");
	sndFlopDealing = new Sound ();
	sndFlopDealing.attachSound ("flop_dealing");
	sndWinning = new Sound ();
	sndWinning.attachSound ("winning");
}
function alertSound ()
{
	sndDing.start ();
}
// ========================================================
function moneyFormat (amount, withCents)
{
	var strAmount = "";
	var strSign = "";
	//
	if (amount < 0)
	{
		strSign = "-";
		amount = Math.abs (amount);
	}
	//
	var numCents = Math.round (100 * (amount % 1));
	var numDollar = Math.floor (amount);
	//
	strAmount = String (numDollar);
	if (strAmount.length > 3)
	{
		strAmount = strAmount.slice (0, -3) + "," + strAmount.slice (-3, strAmount.length);
		if (strAmount.length > 7)
		{
			strAmount = strAmount.slice (0, -7) + "," + strAmount.slice (-7, strAmount.length);
		}
	}
	//
	if (Boolean (withCents))
	{
		if (numCents == 0)
		{
			//strAmount += ".00";
		}
		else if (numCents < 10)
		{
			strAmount += ".0" + String (numCents);
		}
		else
		{
			strAmount += "." + String (numCents);
		}
	}
	strAmount = strSign + strAmount;
	return strAmount;
}
// ========================================================
function doNextAction ()
{
	if (objUser.arrNextActions.length > 0)
	{
		switch (objUser.arrNextActions[0])
		{
		case "login" :
			userLogin ();
			break;
		case "back" :
			objUser.arrNextActions.shift ();
			if (this.mcControls.cbxSitOut.getValue ())
			{
				this.mcControls.cbxSitOut.setValue (false);
			}
			break;
		case "getbalance" :
			getBalance ();
			break;
		case "buyin" :
			objUser.arrNextActions.shift ();
			buyIn ();
			break;
		case "requestprocstate" :
			objUser.arrNextActions.shift ();
			// get procState
			requestProcState ();
			break;
		}
		Selection.setFocus(mcChat.txtNewMsg)
		Selection.setSelection (_level0.mcChat.txtNewMsg.length+1,_level0.mcChat.txtNewMsg.length+1);
	}
}
// ========================================================
function clearTurn ()
{
	hideTurnTimer ();
	if (objTurnSeat <> null)
	{
		objTurnSeat.wait ();
	}
	objTurnSeat = null;
}
//
function hideTurnTimer ()
{
	mcTurnTimer.gotoAndStop ("stop");
	mcTurnTimer._x = mcTurnTimer._y = -100;
}
//
function setTurn (xmlTurn)
{
	clearTurn ();
	arrTurnActions.splice (0);
	//
	if (xmlTurn.attributes.position == undefined || Number (xmlTurn.attributes.position) < 0)
	{
		return;
	}
	//
	var nTurnSeat = Number (xmlTurn.attributes.position);
	var nTurnTime = Number (xmlTurn.attributes.turntime);
	var nTimeBank = Number (xmlTurn.attributes.timebank);
	objTurnSeat = arrSits[nTurnSeat];
	//
	var playerName = objTurnSeat.getPlayerName ();
	if (blnFirstBet)
	{
		mcChat.addMessage (playerName + " will open", 0, 0, "", 10, 0);
		blnFirstBet = false;
	}
	//
	if (objUser.isPlayer)
	{
		for (var i = 0; i < xmlTurn.childNodes.length; i++)
		{
			if (xmlTurn.childNodes[i].nodeName.toLowerCase () == "actions")
			{
				blnTimerEnable = true;
				for (var j = 0; j < xmlTurn.childNodes[i].childNodes.length; j++)
				{
					arrTurnActions.push (xmlTurn.childNodes[i].childNodes[j]);
					var strAction = xmlTurn.childNodes[i].childNodes[j].nodeName.toLowerCase ();
					if (strShowDownActions.indexOf ("=" + strAction + "=") >= 0)
					{
						blnTimerEnable = false;
					}
				}
				if (arrTurnActions.length == 0)
				{
					return;
				}
				if (nTurnSeat == objUser.numSit && !objUser.isSitOut)
				{
					objUser.isPlaying = true;
					objUser.isWaitBB = false;
				}
				//
				if (objUser.isPlaying && !objUser.isSitOut)
				{
					if (nTurnSeat == objUser.numSit)
					{
						objUser.nTurnTime = nTurnTime;
						objUser.nTimeBank = nTimeBank;
						objUser.bUseTimeBank = false;
						//objUser.arrAutoAction = new Array();
						//objUser.numAutoStake = 0;
						mcControls.gotoAndStop ("player");
						mcControls.gotoAndStop ("turn");
						//mcControls.setButtons();
						if (blnTimerEnable)
						{
							mcTurnTimer._x = arrSitCrd[nTurnSeat][0];
							mcTurnTimer._y = arrSitCrd[nTurnSeat][1];
						}
						else
						{
							mcTurnTimer._x = mcTurnTimer._y = -100;
						}
					}
				}
			}
		}
	}
	if (objTurnSeat <> arrSits[objUser.numSit] || objTurnSeat.arrCards.length == 0)
	{
		objTurnSeat.mcStates.gotoAndPlay ("turn");
	}
	if (blnTimerEnable)
	{
		mcTurnTimer.playerName = playerName;
		startTurnTimer = getTimer ();
		mcTurnTimer.gotoAndPlay ("start");
	}
	else
	{
		if (nTurnSeat == objUser.numSit && !objTable.isWindowActive)
		{
			activateWindow ();
			sndGlobalSound.setVolume (100);
			sndYourTurn.start ();
		}
	}
}
//
function getRoundOrd (numSit)
{
	for (var i = 0; i < arrHandSits.length; i++)
	{
		if (arrHandSits[i].numSit == numSit)
		{
			return i;
		}
	}
	return 100;
}
//
function startRound (xmlRound)
{
	if (xmlRound.nodeName <> "startround")
	{
		return;
	}
	objTable.numRound = Number (xmlRound.attributes.round);
	if (objTable.numRound > 1 && objTable.numRound < objTable.numShowDownRound && objUser.isPlaying)
	{
		// set cbx
	}
}
//
function endRound (xmlRound)
{
	if (xmlRound.nodeName <> "endround")
	{
		return;
	}
	objTable.numRound = Number (xmlRound.attributes.round);
	objTable.nWC = Number (xmlRound.attributes.wc);
	clearTurn ();
	//if (objTable.numRound>objTable.numShowDownRound) {return;}
	objUser.acted = false;
	objUser.lastAction == "";
	numBetCnt = 0;
	if (objUser.isPlaying && !objUser.isSitOut && !objUser.isWaitBB)
	{
		if (objTable.numRound > 1 && objTable.numRound < objTable.numShowDownRound && getUserBalance () > 0)
		{
			enableCBXS = true;
		}
		else
		{
			enableCBXS = false;
		}
		mcControls.gotoAndStop ("turn");
		mcControls.gotoAndStop ("player");
		//mcControls.clearCBX ();
		//
		objUser.arrAutoAction = new Array ();
		objUser.numAutoStake = 0;
		//
		if (enableCBXS)
		{
			mcControls.setCBXAction ();
		}
		else
		{
			mcControls.hideCBX ();
		}
	}
	if (objTable.studPoker)
	{
		if (objTable.numRound == arrRoundName.length && objTable.nWC > 1)
		{
			mcChat.addMessage ("*** SHOWDOWN ***", 0, 0, "", 10, 0);
		}
		else if (objTable.numRound > 2)
		{
			blnFirstBet = true;
		}
	}
	else
	{
		if (objTable.numRound == arrRoundName.length && objTable.nWC > 1)
		{
			mcChat.addMessage ("*** SHOWDOWN ***", 0, 0, "", 10, 0);
		}
	}
	for (var i = 0; i < xmlRound.childNodes.length; i++)
	{
		switch (xmlRound.childNodes[i].nodeName.toLowerCase ())
		{
		case "communitycards" :
			var strCards = String (xmlRound.childNodes[i].attributes.value);
			if (strCards <> "")
			{
				dealShareCards (strCards);
			}
			break;
		case "pots" :
			setSharePots (xmlRound.childNodes[i]);
			break;
		case "rake" :
			var rakeAmount = Number (xmlRound.childNodes[i].attributes.amount);
			setRake (rakeAmount);
			break;
		}
	}
}
//
function finishHand (xmlFinish)
{
	if (xmlFinish.nodeName <> "finishhand")
	{
		return;
	}
	clearTurn ();
	nActionsInRound = 0;
	if (objUser.isPlaying && !objUser.isSitOut && !objUser.isSitOut)
	{
		objUser.isAllIn = false;
		enableCBXS = false;
		mcControls.gotoAndStop ("turn");
		mcControls.gotoAndStop ("player");
		//mcControls.clearCBX ();
		//mcControls.hideCBX ();
	}
	objUser.isPlaying = false;
	//
	clearInterval (nClearTableInterval);
	nClearTableInterval = setInterval (clearTable, 6000);
	//
	sendStatsResult ();
}
//
function playerAction (xmlAction)
{
	var bChangeCBX = false;
	var bWasPlaying = objUser.isPlaying;
	var numSit = Number (xmlAction.attributes.position);
	if (arrSits[numSit] == undefined)
	{
		return;
	}
	//if (arrSits[numSit].getSitStatus()<>"busy") {return;}
	var strAction = String (xmlAction.attributes.name).toLowerCase ();
	if (xmlAction.attributes.stake <> undefined)
	{
		numStake = Number (xmlAction.attributes.stake);
	}
	if (xmlAction.attributes.bet <> undefined)
	{
		numBet = Number (xmlAction.attributes.bet);
	}
	if (xmlAction.attributes.balance <> undefined)
	{
		numBalance = Number (xmlAction.attributes.balance);
	}
	// 
	if (strPassiveAction.indexOf ("=" + strAction + "=") == -1)
	{
		nActionsInRound++;
		clearTurn ();
		arrTurnActions.splice (0);
		if (numSit == objUser.numSit && !objUser.isSitOut)
		{
			objUser.arrAutoAction = new Array ();
			objUser.numAutoStake = 0;
		}
		if (strShowAction.indexOf ("=" + strAction + "=") >= 0)
		{
			arrSits[numSit].showAction (strAction);
		}
	}
	//else if (strAction<>"sitoutnexthand" && strAction<>"morechips") {arrSits[numSit].wait();}
	var playerName = arrSits[numSit].getPlayerName ();
	var strDealerMsg = "";
	var numBet = arrSits[numSit].getPot ();
	var numBalance = arrSits[numSit].getBalance ();
	//
	switch (strAction)
	{
	case "usetimebank" :
		var nTimeBank = Number (xmlAction.attributes.timebank);
		if (numSit == objUser.numSit)
		{
			this.mcControls.pbTimeBank._visible = true;
			this.mcControls.pbTimeBank.btnActions.enabled = false;
			objUser.bUseTimeBank = true;
			if (objUser.nTimeBank > 0)
			{
				clearInterval (nTBankInterval);
				nTBankInterval = setInterval (decreaseTimeBank, 1000);
			}
		}
		break;
	case "busyonsitdown" :
		var numUserId = Number (xmlAction.attributes.userid);
		if (numUserId == objUser.userId)
		{
			objUser.numSitdown = -1;
			objUser.isWaitForChips = false;
		}
		break;
	case "morechips" :
		objUser.isWaitForChips = false;
		numBalance = Number (xmlAction.attributes.balance);
		break;
	case "leavetable" :
		arrSits[numSit].foldCards ();
		//arrSits[numSit].setFree ();
		arrSits[numSit].actionInt = setInterval (arrSits[numSit], setFree, 500);
		if (objUser.isPlayer)
		{
			arrSits[numSit].setAlpha (0);
		}
		else
		{
			arrSits[numSit].setAlpha (100);
		}
		break;
	case "sitout" :
		strDealerMsg = playerName + " sits out";
		arrSits[numSit].setPlayerStatus ("sitout");
		if (numSit == objUser.numSit)
		{
			objUser.isPlayer = objUser.isSitOut = true;
			objUser.isPlaying = false;
			mcControls.gotoAndStop ("sitout");
			if (!this.mcControls.cbxSitOut.getValue ())
			{
				this.mcControls.cbxSitOut.setValue (true);
			}
			arrSits[numSit].showFoldCards ();
		}
		else
		{
			arrSits[numSit].foldCards ();
			arrSits[numSit].setAlpha (50);
		}
		break;
	case "back" :
		if (numSit == objUser.numSit)
		{
			objUser.isPlayer = true;
			objUser.isSitOut = objUser.isPlaying = false;
			mcControls.gotoAndStop ("player");
		}
		arrSits[numSit].setAlpha (100);
		arrSits[numSit].setPlayerStatus ("playing");
		strDealerMsg = playerName + " has returned";
		break;
	case "ante" :
		sndChipsBetting.start ();
		numStake = Number (xmlAction.attributes.stake);
		numBet = Number (xmlAction.attributes.bet);
		numBalance = Number (xmlAction.attributes.balance);
		strDealerMsg = playerName + " posts the ante (" + moneyFormat (numStake, 1) + ")";
		break;
	case "postsb" :
		sndChipsBetting.start ();
		numStake = Number (xmlAction.attributes.stake);
		numBet = Number (xmlAction.attributes.bet);
		numBalance = Number (xmlAction.attributes.balance);
		strDealerMsg = playerName + " posts the small blind (" + moneyFormat (numStake, 1) + ")";
		numBetCnt++;
		if (numSit == objUser.numSit)
		{
			objUser.postBlind = true;
		}
		break;
	case "postbb" :
		sndChipsBetting.start ();
		numStake = Number (xmlAction.attributes.stake);
		numBet = Number (xmlAction.attributes.bet);
		numBalance = Number (xmlAction.attributes.balance);
		strDealerMsg = playerName + " posts the big blind (" + moneyFormat (numStake, 1) + ")";
		if (numSit == objUser.numSit)
		{
			objUser.postBlind = true;
		}
		break;
	case "post" :
		sndChipsBetting.start ();
		numStake = Number (xmlAction.attributes.stake);
		numBet = Number (xmlAction.attributes.bet);
		numBalance = Number (xmlAction.attributes.balance);
		strDealerMsg = playerName + " posts (" + moneyFormat (numStake, 1) + ")";
		if (numSit == objUser.numSit)
		{
			objUser.postBlind = true;
		}
		break;
	case "postdead" :
		sndChipsBetting.start ();
		numStake = Number (xmlAction.attributes.stake);
		numBet = Number (xmlAction.attributes.bet);
		numBalance = Number (xmlAction.attributes.balance);
		strDealerMsg = playerName + " posts dead";
		if (numSit == objUser.numSit)
		{
			objUser.postBlind = true;
		}
		break;
	case "bringin" :
		sndChipsBetting.start ();
		numStake = Number (xmlAction.attributes.stake);
		numBet = Number (xmlAction.attributes.bet);
		numBalance = Number (xmlAction.attributes.balance);
		strDealerMsg = playerName + " brings-in low (" + moneyFormat (numStake, 1) + ")";
		numBetCnt++;
		if (numSit == objUser.numSit)
		{
			objUser.acted = true;
		}
		break;
	case "waitbb" :
		strDealerMsg = playerName + " waiting for big blind";
		if (numSit == objUser.numSit)
		{
			objUser.isPlaying = false;
			mcControls.gotoAndStop ("waitbb");
		}
		else
		{
			arrSits[numSit].setAlpha (50);
		}
		break;
	case "muck" :
		arrSits[numSit].foldCards ();
		strDealerMsg = playerName + " mucks";
		if (numSit == objUser.numSit)
		{
			mcMsgRanking.setLabel ("");
		}
		// sit out
		if (objUser.iaAllIn == 0)
		{
			arrSits[numSit].setPlayerStatus ("playing");
		}
		break;
	case "turncardsover" :
		var strCardsName = String (xmlAction.attributes.cards);
		if (strCardsName <> undefined)
		{
			arrSits[numSit].setCards (strCardsName);
		}
		break;
	case "showcards" :
		var strCardsName = String (xmlAction.attributes.cards);
		if (strCardsName <> undefined)
		{
			arrSits[numSit].setCards (strCardsName);
		}
		break;
	case "showcardsshuffled" :
		var strCardsName = String (xmlAction.attributes.cards);
		if (strCardsName <> undefined)
		{
			arrSits[numSit].setCards (strCardsName);
		}
		break;
	case "dontshow" :
		arrSits[numSit].foldCards ();
		strDealerMsg = playerName + " doesn't show ";
		if (arrSits[numSit].objPlayer.numSex == 2)
		{
			strDealerMsg += "her";
		}
		else
		{
			strDealerMsg += "his";
		}
		strDealerMsg += " hand";
		if (numSit == objUser.numSit)
		{
			mcMsgRanking.setLabel ("");
		}
		break;
	case "allin" :
		arrSits[numSit].setPlayerStatus ("allin");
		if (numSit == objUser.numSit)
		{
			objUser.isPlaying = false;
			objUser.isAllIn = true;
		}
		break;
	case "fold" :
		strDealerMsg = playerName + " folds";
		if (numSit == objUser.numSit)
		{
			objUser.acted = true;
			mcMsgRanking.setLabel ("");
			arrSits[numSit].showFoldCards ();
			objUser.isPlaying = false;
			sendStatsAction (strAction);
			objUser.objStats.lastRound = arrRoundName[objTable.numRound - 1];
		}
		else
		{
			arrSits[numSit].foldCards ();
			arrSits[numSit].setAlpha (50);
		}
		// sit out
		if (numBalance == 0)
		{
			arrSits[numSit].setPlayerStatus ("playing");
		}
		break;
	case "check" :
		strDealerMsg = playerName + " checks";
		if (numSit == objUser.numSit)
		{
			objUser.acted = true;
			sendStatsAction (strAction);
		}
		sndCheck.start ();
		break;
	case "call" :
		numStake = Number (xmlAction.attributes.stake);
		numBet = Number (xmlAction.attributes.bet);
		numBalance = Number (xmlAction.attributes.balance);
		if (numBalance > 0)
		{
			strDealerMsg = playerName + " calls";
		}
		else
		{
			strDealerMsg = playerName + " calls all-in";
		}
		if (numSit == objUser.numSit)
		{
			objUser.acted = true;
			sendStatsAction (strAction);
		}
		sndChipsCalling.start ();
		break;
	case "bet" :
		numStake = Number (xmlAction.attributes.stake);
		numBet = Number (xmlAction.attributes.bet);
		numBalance = Number (xmlAction.attributes.balance);
		if (numBalance > 0)
		{
			strDealerMsg = playerName + " bets";
		}
		else
		{
			strDealerMsg = playerName + " bets all-in";
		}
		if (numSit == objUser.numSit)
		{
			objUser.acted = true;
			sendStatsAction (strAction);
		}
		else
		{
			objUser.acted = false;
		}
		sndChipsBetting.start ();
		numBetCnt++;
		break;
	case "raise" :
		numStake = Number (xmlAction.attributes.stake);
		numBet = Number (xmlAction.attributes.bet);
		numBalance = Number (xmlAction.attributes.balance);
		if (numBalance > 0)
		{
			strDealerMsg = playerName + " raises";
		}
		else
		{
			strDealerMsg = playerName + " raises all-in";
		}
		if (numSit == objUser.numSit)
		{
			objUser.acted = true;
			sendStatsAction (strAction);
		}
		else
		{
			objUser.acted = false;
			if (objUser.lastAction == "raise")
			{
				sendStatsAction ("reraise");
			}
		}
		sndChipsBetting.start ();
		numBetCnt++;
		if (numBetCnt >= numBettingCap)
		{
			if (strDealerMsg <> "")
			{
				mcChat.addMessage (strDealerMsg, 0, 0, "", 10, 0);
				strDealerMsg = "";
			}
			mcChat.addMessage ("Betting is capped", 0, 0, "", 10, 0);
		}
		break;
	}
	//
	if (arrSits[numSit].getBalance () <> numBalance)
	{
		arrSits[numSit].setAmount (numBalance);
		if (numBalance == 0)
		{
			arrSits[numSit].setPlayerStatus ("allin");
			if (numSit == objUser.numSit)
			{
				objUser.isPlaying = false;
				objUser.isAllIn = true;
			}
		}
		if (numSit == objUser.numSit)
		{
			setUserBalance (numBalance);
		}
	}
	//
	if (arrSits[numSit].getPot () <> numBet)
	{
		arrSits[numSit].setPot (numBet);
		if ((objUser.isPlaying || objUser.numSit == numSit) && arrSits[numSit].arrCards.length > 0 && objTable.numRound < objTable.numShowDownRound)
		{
			// numSit<>objUser.numSit &&
			bChangeCBX = true;
		}
	}
	//
	if (numSit == objUser.numSit)
	{
		objUser.lastAction = strAction;
	}
	if (strDealerMsg <> "")
	{
		mcChat.addMessage (strDealerMsg, 0, 0, "", 10, 0);
	}
	//
	if (objUser.isPlayer)
	{
		if (bChangeCBX && strPassiveAction.indexOf ("=" + strAction + "=") == -1)
		{
			enableCBXS = true;
			mcControls.gotoAndStop ("turn");
			mcControls.gotoAndStop ("player");
			//mcControls.setCBXAction ();
		}
		else if (bWasPlaying && !objUser.isPlaying && !objUser.isWaitBB && !objUser.isSitOut)
		{
			enableCBXS = false;
			mcControls.gotoAndStop ("turn");
			mcControls.gotoAndStop ("player");
			//mcControls.clearCBX ();
			//mcControls.hideCBX ();
		}
	}
	showTablePotsAmount ();
}
// ====================================================
function initStats ()
{
	var strStats = "<gamestats name=\"gamestarted\" ";
	strStats += "pokertype=\"" + objTable.pokerType + "\"";
	strStats += "gamename=\"" + arrPokerNames[objTable.pokerType] + "\" ";
	if (objTable.pokerType >= 1 && objTable.pokerType <= 3)
	{
		strStats += "flopname=\"Flops seen\" ";
		strStats += "winflopname=\"Win % if flop seen\" >";
		strStats += "<stats name=\"Pre-flop\"/>";
		strStats += "<stats name=\"Flop\"/>";
		strStats += "<stats name=\"Turn\"/>";
		strStats += "<stats name=\"River\"/>";
		strStats += "<stats name=\"No fold\"/>";
	}
	else if (objTable.studPoker)
	{
		if (objTable.pokerType == 4 || objTable.pokerType == 5)
		{
			strStats += "flopname=\"4th street seen\" ";
			strStats += "winflopname=\"Win % if 4th seen\" >";
			strStats += "<stats name=\"Third street\"/>";
			strStats += "<stats name=\"Fourth street\"/>";
			strStats += "<stats name=\"Fifth street\"/>";
			strStats += "<stats name=\"Sixth street\"/>";
			strStats += "<stats name=\"River\"/>";
			strStats += "<stats name=\"No fold\"/>";
		}
	}
	strStats += "</gamestats>";
	// send to CSA stats initialization 
	mcComm.addCSAMsg (new XML (strStats));
	// stats counters and flags
	objUser.objStats.bInHand = false;
	objUser.objStats.lastRound = "No fold";
	objUser.objStats.result = "lose";
	objUser.objStats.bFlopSeen = false;
	objUser.objStats.bFlopParticipate = false;
	objUser.objStats.nShowdownCount = 0;
	objUser.objStats.nWinShowdownCount = 0;
}
//
function sendStatsAction (strAction)
{
	if (strAction <> undefined && strAction <> "")
	{
		mcComm.addCSAMsg (new XML ("<gamestats name=\"gameaction\" action=\"" + strAction + "\" pokertype=\"" + objTable.pokerType + "\"/>"));
	}
}
//
function sendStatsResult ()
{
	var strStats = "<gamestats name=\"gamefinished\" ";
	strStats += " pokertype=\"" + objTable.pokerType + "\"";
	strStats += " result=\"" + objUser.objStats.result + "\"";
	strStats += " flopseen=\"" + Number (objUser.objStats.bFlopseen) + "\" ";
	strStats += " flopparticipate=\"" + Number (objUser.objStats.bFlopParticipate) + "\" ";
	strStats += " showdowncount=\"" + Number (objUser.objStats.nShowdownCount) + "\" ";
	strStats += " winshowdowncount=\"" + Number (objUser.objStats.nWinShowdownCount) + "\" ";
	strStats += " foldon=\"" + objUser.objStats.lastRound + "\"";
	strStats += " />";
	mcComm.addCSAMsg (new XML (strStats));
}
//
function getCurrencySign ()
{
	return objTable.currencySign;
}
//
function loadAvatarLogo(avatar,id){
	for (var i=0; i<arrSits.length; i++){
		if (arrSits[i].objPlayer.numId == id){
			arrSits[i].loadAvatarLogo(avatar);
		}
	}
}
//
function setWindowState (xmlState)
{
	if (xmlState.nodeName <> "windowstate")
	{
		return;
	}
	objTable.isWindowActive = Boolean (xmlState.attributes.active);
	setSound ();
}
//
function openTournamentMsg ()
{
	if (mcTournamentMsg == undefined)
	{
		openWin ("mcTournamentMsg");
	}
}
//
function reminderYourTurn (num)
{
	if (objTurnSeat == arrSits[objUser.numSit])
	{
		if (num == 0)
		{
			if (objUser.soundEnable)
			{
				if (!objTable.isWindowActive)
				{
					sndGlobalSound.setVolume (100);
				}
				sndYourTurn.start ();
			}
		}
		else
		{
			if (num == 11)
			{
				mcChat.addMessage (mcTurnTimer.playerName + " it's your turn. You have <b>" + (25 - num) + "</b> seconds to respond.", 0, 0, "", 2, 0);
				if (objTable.tournament > 0)
				{
					this.mcControls.pbTimeBank._visible = true;
				}
			}
			else if (num == 16 || num == 20)
			{
				if (objTurnSeat.arrCards.length > 0)
				{
					mcChat.addMessage (mcTurnTimer.playerName + " ACT NOW or your hand will be folded in <b>" + (25 - num) + "</b> seconds", 0, 0, "", 2, 0);
				}
				else
				{
					mcChat.addMessage (mcTurnTimer.playerName + " ACT NOW. You have <b>" + (25 - num) + "</b> seconds to respond.", 0, 0, "", 2, 0);
				}
				if (objTable.tournament > 0)
				{
					this.mcControls.pbTimeBank._visible = true;
				}
			}
			sndWakeUp.start ();
		}
		if (!objTable.isWindowActive)
		{
			activateWindow ();
		}
	}
	else
	{
		if (num == 11)
		{
			var strProN = "";
			if (objTurnSeat.getPlayerSex () == 1)
			{
				strProN = "he";
			}
			else if (objTurnSeat.getPlayerSex () == 2)
			{
				strProN = "she";
			}
			mcChat.addMessage ("it's " + mcTurnTimer.playerName + " turn and " + strProN + " has <b>" + (25 - num) + "</b> seconds to act.", 0, 0, "", 2, 0);
		}
	}
}
function turnTimeOut ()
{
	if (objTurnSeat <> arrSits[objUser.numSit])
	{
		return;
	}
	hideTurnTimer ();
	if (!objUser.bUseTimeBank)
	{
		mcControls.hideButtons ();
	}
	// arrSits[objUser.numSit].showFoldCards();
}
//
function moveThis (pObj)
{
	if (getMovingNum (pObj) == -1)
	{
		arrMoving.push (pObj);
	}
}
//
function getMovingNum (pObj)
{
	for (var i = 0; i < arrMoving.length; i++)
	{
		if (arrMoving[i] == pObj)
		{
			return i;
		}
	}
	return -1;
}
//
function decreaseTimeBank ()
{
	objUser.nTimeBank--;
	mcControls.pbTimeBank.txtTimer.text = String (objUser.nTimeBank);
	if (objUser.nTimeBank <= 0)
	{
		objUser.nTimeBank = 0;
		clearInterval (nTBankInterval);
		mcControls.hideButtons ();
	}
}
//
function fSetCBXDisable ()
{
	clearInterval (sendingCBXInt);
	mcControls.cbxMuck.setEnabled (false);
	mcControls.cbxSitOut.setEnabled (false);
	mcControls.cbxAutoPost.setEnabled (false);
	for (var i = 1; i < 7; i++)
	{
		mcControls["cbx" + i].setEnabled (false);
	}
	sendingCBXInt = setInterval (fSetCBXEnable, 1000);
	Selection.setFocus(_level0.mcChat.txtNewMsg)
	Selection.setSelection (_level0.mcChat.txtNewMsg.length+1,_level0.mcChat.txtNewMsg.length+1);
}
//
function fSetCBXEnable ()
{
	clearInterval (sendingCBXInt);
	mcControls.cbxMuck.setEnabled (mcControls.cbxMuck.wasEnable);
	mcControls.cbxSitOut.setEnabled (mcControls.cbxSitOut.wasEnable);
	mcControls.cbxAutoPost.setEnabled (mcControls.cbxAutoPost.wasEnable);
	for (var i = 1; i < 7; i++)
	{
		mcControls["cbx" + i].setEnabled (true);
	}
	Selection.setFocus(_level0.mcChat.txtNewMsg)
	Selection.setSelection (_level0.mcChat.txtNewMsg.length+1,_level0.mcChat.txtNewMsg.length+1);
}
