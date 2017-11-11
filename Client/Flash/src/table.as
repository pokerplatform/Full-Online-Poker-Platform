var objTable = new Object ();
createTable ();
//
function createTable ()
{
	objTable.procId = 0;
	objTable.name = "noname";
	objTable.geVersion = "0.0";
	objTable.pokerType = 1;
	objTable.studPoker = false;
	objTable.bHiLoPoker = false;
	objTable.currencyId = 1;
	objTable.currencySign = "";
	objTable.sitCnt = 10;
	objTable.handId = 0;
	objTable.prevHandId = 0;
	objTable.minStake = 0;
	objTable.maxStake = 0;
	objTable.stakeType = 0;
	objTable.allIn = false;
	objTable.maxBuyIn = 0;
	objTable.minBuyIn = 0;
	objTable.defBuyIn = 0;
	objTable.favHandId = 0;
	objTable.numRound = 0;
	objTable.nWC = objTable.sitCnt;
	objTable.numShowDownRound = 1;
	objTable.cardBackName = "small_";
	objTable.tournament = 0;
	objTable.tournamentBuyIn = 0;
	objTable.tournamentRake = 0;
	objTable.tournamentChips = 0;
	objTable.tournamentLevel = 0;
	objTable.tournamentHandId = 0;
	objTable.tournamentStarted = false;
	objTable.waitingList = 0;
	//objTable.backgroundName = "back1.swf";
}
//
function initTable (xmlInit)
{
	if (xmlInit.nodeName <> "procinit")
	{
		return;
	}
	for (var i = 0; i < xmlInit.childNodes.length; i++)
	{
		switch (xmlInit.childNodes[i].nodeName.toLowerCase ())
		{
		case "geversion" :
			objTable.geVersion = "Engine:" + String (xmlInit.childNodes[i].attributes.value);
			strGEVersion = objTable.geVersion;
			break;
		case "name" :
			objTable.name = String (xmlInit.childNodes[i].attributes.value);
			break;
		case "pokertype" :
			objTable.pokerType = Number (xmlInit.childNodes[i].attributes.value);
			break;
		case "playercount" :
			objTable.sitCnt = Number (xmlInit.childNodes[i].attributes.value);
			break;
		case "currencyid" :
			objTable.currencyId = Number (xmlInit.childNodes[i].attributes.value);
			break;
		case "currencysign" :
			objTable.currencySign = String (xmlInit.childNodes[i].attributes.value);
			break;
		case "staketype" :
			objTable.stakeType = Number (xmlInit.childNodes[i].attributes.value);
			break;
		case "allin" :
			objTable.allIn = Boolean (xmlInit.childNodes[i].attributes.value);
			break;
		case "maxbuyin" :
			objTable.maxBuyIn = Number (xmlInit.childNodes[i].attributes.value);
			break;
		case "minbuyin" :
			objTable.minBuyIn = Number (xmlInit.childNodes[i].attributes.value);
			break;
		case "defbuyin" :
			objTable.defBuyIn = Number (xmlInit.childNodes[i].attributes.value);
			break;
		case "istournament" :
			objTable.tournament = Number (xmlInit.childNodes[i].attributes.value);
			if (objTable.tournament == 1)
			{
				objTable.tournamentBuyIn = Number (xmlInit.childNodes[i].attributes.buyin);
				objTable.tournamentRake = Number (xmlInit.childNodes[i].attributes.rake);
				objTable.tournamentChips = Number (xmlInit.childNodes[i].attributes.chips);
			}
			break;
		}
	}
	objTable.isWindowActive = true;
	//
	clearTable ();
	setObjectsCrd ();
	setPokerType ();
	//
	for (var i = 0; i < arrSits.length; i++)
	{
		arrSits[i].removeMovieClip ();
		arrPlayerPots[i].removeMovieClip ();
	}
	arrSits.splice (0);
	arrHandSits.splice (0);
	arrPlayerPots.splice (0);
	//
	for (var i = 0; i < objTable.sitCnt; i++)
	{
		attachMovie ("CSit", "mcSit" + i, numSitDepth + (i + 1) * 50);
		arrSits[i] = eval ("mcSit" + i);
		arrSits[i].setSitNum (i);
		arrSits[i].depth = numSitDepth + (i + 1) * 50;
		arrSits.crdSit = arrSitCrd[i];
		arrSits[i]._x = arrSitCrd[i][0];
		arrSits[i]._y = arrSitCrd[i][1];
		arrSits[i].setFree ();
		//
		attachMovie ("CChips", "mcPlayerPot" + i, numChipsDepth + 100 + i);
		var newPot = eval ("mcPlayerPot" + i);
		newPot._x = arrPlayerPotCrd[i][0];
		newPot._y = arrPlayerPotCrd[i][1];
		newPot.numSit = i;
		newPot.setCurrency (objTable.currencyId);
		newPot.setName ("Bet");
		newPot.setType ("bet");
		newPot.setAlign (arrPlayerPotCrd[i][2]);
		arrPlayerPots.push (newPot);
		//
		arrSits[i].setPotObject (newPot);
	}
}
// ========================================================
function clearTable ()
{
	//
	clearInterval (nClearTableInterval);
	//
	if (getBetAmount () > 0)
	{
		clearBets ();
	}
	// delete rake
	if (mcRake <> undefined)
	{
		mcRake.setChips (0);
	}
	// delete moving bets
	deleteMovingBets ();
	// delete main pots
	for (var i = 0; i < arrMainPots.length; i++)
	{
		arrMainPots[i].removeMovieClip ();
	}
	arrMainPots.splice (0);
	// delete winner pots
	for (var i = 0; i < arrWinnerPots.length; i++)
	{
		if (arrWinnerPots[i] <> undefined)
		{
			arrWinnerPots[i].removeMovieClip ();
		}
	}
	arrWinnerPots.splice (0);
	//
	txtPotsAmount.text = "";
	//
	clearTurn ();
	objUser.isPlaying = false;
	objUser.postBlind = false;
	objUser.objStats.bInHand = false;
	//
	mcMsgRanking.setLabel ("");
	objUser.rankCards = "";
	objUser.rankCardsLo = "";
	//
	blnFirstBet = false;
	cardsDealed = false;
	objTurnSeat = null;
	// delete share cards
	removeShareCards ();
	// delete players cards
	for (var i = 0; i < arrSits.length; i++)
	{
		arrSits[i].deleteCards ();
		arrSits[i].setPot (0);
		arrSits[i].objWonPot = null;
	}
	numCardCnt = 0;
	objTable.nWC = objTable.sitCnt;
}
//
function showFreeSit ()
{
	var alpha = 100;
	if (objUser.isPlayer || objTable.favHandId > 0 || objTable.tournament > 1 || (objTable.tournament == 1 && objTable.tournamentStarted))
	{
		alpha = 0;
	}
	for (var i = 0; i < arrSits.length; i++)
	{
		if (arrSits[i].getSitStatus () == "free")
		{
			arrSits[i].setAlpha (alpha);
		}
		else if (arrSits[i].getSitStatus () == "hidden")
		{
			arrSits[i].setAlpha (0);
		}
	}
}
//
function getSitByUserId (userId)
{
	if (userId == undefined || userId <= 0)
	{
		return -1;
	}
	for (var i = 0; i < arrSits.length; i++)
	{
		if (arrSits[i].getUserId () == userId)
		{
			return arrSits[i].numSit;
		}
	}
	return -1;
}
//
function setObjectsCrd ()
{
	//
	arrSitCrd = new Array (new Array (581, 48), new Array (721, 126), new Array (737, 265), new Array (670, 375), new Array (510, 408), new Array (280, 408), new Array (120, 375), new Array (49, 265), new Array (68, 126), new Array (208, 48));
	arrButtonCrd = new Array (new Array (534, 77), new Array (665, 117), new Array (707, 225), new Array (673, 322), new Array (465, 374), new Array (234, 374), new Array (113, 320), new Array (80, 220), new Array (121, 115), new Array (254, 75));
	arrSmCardCrd = new Array (new Array (565, 90), new Array (672, 150), new Array (687, 252), new Array (613, 342), new Array (497, 363), new Array (274, 363), new Array (140, 332), new Array (87, 252), new Array (107, 150), new Array (202, 90));
	arrPlayerPotCrd = new Array (new Array (528, 132, "left"), new Array (670, 185, "right"), new Array (645, 255, "right"), new Array (650, 305, "right"), new Array (530, 333, "right"), new Array (230, 333, "left"), new Array (110, 305, "left"), new Array (117, 255, "left"), new Array (95, 185, "left"), new Array (227, 132, "right"));
	//
	var arrDelSit = new Array (1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
	switch (objTable.sitCnt)
	{
	case 9 :
		arrDelSit = new Array (1, 1, 1, 1, 1, 1, 1, 1, 1, 0);
		break;
	case 8 :
		arrDelSit = new Array (0, 1, 1, 1, 1, 1, 1, 1, 1, 0);
		break;
	case 7 :
		arrDelSit = new Array (0, 1, 1, 1, 1, 1, 1, 1, 0, 0);
		break;
	case 6 :
		arrDelSit = new Array (0, 1, 0, 1, 1, 1, 1, 0, 1, 0);
		break;
	case 5 :
		arrDelSit = new Array (1, 0, 1, 0, 1, 0, 1, 0, 1, 0);
		break;
	case 4 :
		arrDelSit = new Array (0, 0, 1, 0, 1, 1, 0, 1, 0, 0);
		break;
	case 3 :
		arrDelSit = new Array (0, 0, 1, 0, 1, 0, 1, 0, 0, 0);
		break;
	case 2 :
		arrDelSit = new Array (0, 0, 0, 1, 0, 0, 1, 0, 0, 0);
		break;
	}
	numShareCardsX = 280;
	for (var i = arrDelSit.length - 1; i >= 0; i--)
	{
		if (arrDelSit[i] == 0)
		{
			arrSitCrd.splice (i, 1);
			arrButtonCrd.splice (i, 1);
			arrSmCardCrd.splice (i, 1);
			arrPlayerPotCrd.splice (i, 1);
		}
	}
}
//
function stateTable (xmlState)
{
	if (xmlState.nodeName <> "procstate")
	{
		return;
	}
	clearTable ();
	if (blnReady)
	{
		numBetCnt = 0;
		mcMsgRanking.setLabel ("");
		objUser.rankCards = "";
		objUser.rankCardsLo = "";
		if (objUser.isPlayer)
		{
			// init stats
			objUser.objStats.bInHand = false;
			objUser.objStats.lastRound = "No fold";
			objUser.objStats.result = "lose";
			objUser.objStats.bFlopSeen = false;
			objUser.objStats.bFlopParticipate = false;
			objUser.objStats.nShowdownCount = 0;
			objUser.objStats.nWinShowdownCount = 0;
			objUser.lastAction = "";
			objUser.acted = false;
		}
	}
	//
	if (objTable.minStake <> Number (xmlState.attributes.minstake) || objTable.maxStake <> Number (xmlState.attributes.maxstake))
	{
		objTable.minStake = Number (xmlState.attributes.minstake);
		objTable.maxStake = Number (xmlState.attributes.maxstake);
		readyToShow ();
	}
	else
	{
		objTable.minStake = Number (xmlState.attributes.minstake);
		objTable.maxStake = Number (xmlState.attributes.maxstake);
	}
	objTable.numRound = Number (xmlState.attributes.round);
	if (objTable.numRound <= 0)
	{
		// new hand
		objTable.numRound = 1;
	}
	//
	objTable.handId = Number (xmlState.attributes.handid);
	objTable.prevHandId = Number (xmlState.attributes.prevhandid);
	if (objTable.handId == 0 || isNaN (objTable.handId))
	{
		mcGameId.txtHandId.text = "";
	}
	else
	{
		mcGameId.txtHandId.text = moneyFormat (objTable.handId, 0);
	}
	if (objTable.tournament == 0)
	{
		if (objTable.prevHandId == objTable.handId || objTable.prevHandId == 0 || isNaN (objTable.prevHandId))
		{
			mcGameId.txtPrevHandId.text = "";
		}
		else
		{
			mcGameId.txtPrevHandId.text = moneyFormat (objTable.prevHandId, 0);
		}
	}
	//
	if (objTable.favHandId == 0)
	{
		mcComm.addCSAMsg (new XML ("<newhand handid=\"" + objTable.handId + "\"/>"));
	}
	//
	for (var i = 0; i < xmlState.childNodes.length; i++)
	{
		if (xmlState.childNodes[i].nodeName.toLowerCase () == "tournament")
		{
			objTable.tournamentLevel = Number (xmlState.childNodes[i].attributes.level);
			objTable.tournamentHandId = Number (xmlState.childNodes[i].attributes.hand);
			objTable.tournamentStarted = Boolean (xmlState.childNodes[i].attributes.started);
			var strLevel = (objTable.tournamentLevel <= 20) ? arrRomanNums[objTable.tournamentLevel - 1] : String (objTable.tournamentLevel);
			mcGameId.txtTournament.text = "Level: " + strLevel + "   Hand#" + objTable.tournamentHandId;
			break;
		}
	}
	for (var i = 0; i < xmlState.childNodes.length; i++)
	{
		switch (xmlState.childNodes[i].nodeName.toLowerCase ())
		{
		case "chairs" :
			setChairs (xmlState.childNodes[i]);
			break;
		case "communitycards" :
			setShareCards (String (xmlState.childNodes[i].attributes.value));
			break;
		case "pots" :
			setSharePots (xmlState.childNodes[i]);
			break;
		case "rake" :
			var rakeAmount = Number (xmlState.childNodes[i].attributes.amount);
			setRake (rakeAmount);
			break;
		case "chat" :
			addChat (xmlState.childNodes[i], 0);
			break;
		}
	}
}
//
function setChairs (xmlChairs)
{
	objTable.dealerSit = -1;
	for (var i = 0; i < xmlChairs.childNodes.length; i++)
	{
		if (xmlChairs.childNodes[i].nodeName.toLowerCase () == "chair")
		{
			setChair (xmlChairs.childNodes[i]);
		}
	}
	//
	if (objTable.dealerSit == -1 || objTable.studPoker)
	{
		mcDButton._x = 390;
		mcDButton._y = 110;
	}
	else
	{
		setDButton (objTable.dealerSit);
	}
	if (objTable.dealerSit == objTable.sitCnt - 1 || objTable.studPoker)
	{
		arrHandSits = arrSits.slice (0);
	}
	else
	{
		arrHandSits = arrSits.slice ((objTable.dealerSit - objTable.sitCnt + 1));
		arrHandSits = arrHandSits.concat (arrSits.slice (0, objTable.dealerSit + 1));
	}
	showFreeSit ();
	showTablePotsAmount ();
}
//
function setChair (xmlChair)
{
	var numSit = Number (xmlChair.attributes.position);
	// dealer "button" position
	if (Boolean (xmlChair.attributes.isdealer))
	{
		objTable.dealerSit = numSit;
	}
	var oldStatus = arrSits[numSit].getSitStatus ();
	var strStatus = String (xmlChair.attributes.status).toLowerCase ();
	//
	if (strStatus == "free" || strStatus == "reserved" || strStatus == "hidden")
	{
		if (oldStatus == "busy")
		{
			ret = mcChat.removeFromPlayerList (arrSits[numSit].getUserId ());
			arrSits[numSit].setNote ("");
			//arrSits[numSit].foldCards ();
			arrSits[numSit].deleteCards ();
		}
		if (objUser.numSit == numSit)
		{
			objUser.isPlayer = false;
			objUser.isPlaying = false;
			objUser.isSitOut = false;
			objUser.numSit = -1;
			mcControls.gotoAndStop ("watcher");
		}
	}
	trace ("strStatus::"+strStatus)
	switch (strStatus)
	{
	case "free" :
		if (oldStatus <> strStatus)
		{
			arrSits[numSit].setFree ();
		}
		//
		if (objTable.tournament > 1 || (objTable.tournament == 1 && objTable.tournamentStarted))
		{
			arrSits[numSit].setAlpha (0);
		}
		break;
	case "hidden" :
		if (oldStatus <> strStatus)
		{
			arrSits[numSit].setHidden ();
		}
		break;
	case "reserved" :
		if (xmlChair.firstChild.nodeName.toLowerCase () == "player")
		{
			var userId = Number (xmlChair.firstChild.attributes.id);
			arrSits[numSit].setReserved (userId);
			arrSits[numSit].setAlpha (100);
		}
		break;
	case "busy" :
		var userId = Number (xmlChair.firstChild.attributes.id);
		arrSits[numSit].setBusy ();
		if (xmlChair.firstChild.nodeName.toLowerCase () == "player")
		{
			setPlayer (numSit, xmlChair.firstChild);
		}
		if (oldStatus <> "busy")
		{
			if (Number (userId) == objUser.userId)
			{
				if (objTable.favHandId == 0)
				{
					mcComm.addCSAMsg (new XML ("<sitdown/>"));
					objUser.bSitAllowed = false;
					objUser.isWaitForChips = false;
					sndSitdown.start ();
					_root.sendAutoAction("muck",0,Number(mcControls.cbxMuck.getValue()));
					
					if (arrSits[numSit].getPlayerStatus () == "sitout")
					{
						objUser.isSitOut = true;
						objUser.isPlaying = false;
						mcControls.gotoAndStop ("sitout");
					}
					else
					{
						objUser.isSitOut = false;
						mcControls.gotoAndStop ("player");
					}
				}
			}
			else if (Number (userId) > 0)
			{
				mcChat.addInPlayerList (arrSits[numSit].getPlayerName (), userId);
				if (objUser.isLogged)
				{
					mcComm.addCSAMsg (new XML ("<getnotes foruserid=\"" + userId + "\"/>"));
				}
				// someone take your seat, sorry
				if (!objUser.isPlayer && objUser.isWaitForChips && objUser.numSitdown == numSit)
				{
					objUser.numSitdown = -1;
					bjUser.isWaitForChips = false;
				}
			}
		}
		break;
	}
}
//
function setPlayer (numSit, xmlPlayer)
{
	var userId = Number (xmlPlayer.attributes.id);
	var userName = String (xmlPlayer.attributes.name);
	var userCity = String (xmlPlayer.attributes.city);
	var userSex = Number (xmlPlayer.attributes.sex);
	var userAvatar = Number (xmlPlayer.attributes.avatarid);
	//
	if (xmlPlayer.attributes.avatarid == undefined)
	{
		userAvatar = userSex;
	}
	//
	var userBalance = Number (xmlPlayer.attributes.balance);
	var userBet = Number (xmlPlayer.attributes.bet);
	var userCards = String (xmlPlayer.attributes.cards);
	// playing|sitout|disconnected
	var userStatus = String (xmlPlayer.attributes.status).toLowerCase ();
	var userInGame = Boolean (xmlPlayer.attributes.ingame);
	//
	arrSits[numSit]._visible = true;
	arrSits[numSit].setUserId (userId);
	arrSits[numSit].setPlayerProperty (userName, userCity, userSex, userAvatar);
	if (arrSits[numSit].getBalance () <> userBalance)
	{
		arrSits[numSit].setAmount (userBalance);
	}
	//
	arrSits[numSit].setCards (userCards);
	//
	if (arrSits[numSit].getPot () <> userBet)
	{
		arrSits[numSit].setPot (userBet);
	}
	//
	var sOldStatus = arrSits[numSit].getPlayerStatus ();
	if (userStatus <> sOldStatus)
	{
		arrSits[numSit].setPlayerStatus (userStatus);
	}
	//
	if (userId == objUser.userId)
	{
		if (objTable.favHandId == 0)
		{
			objUser.isPlayer = true;
			objUser.isPlaying = userInGame;
			btnMoreChips.enabled = (objTable.tournament == 0);
			//
			if (userStatus == "sitout")
			{
				objUser.isSitOut = true;
				objUser.isPlaying = false;
				if (userStatus <> sOldStatus)
				{
					mcControls.gotoAndStop ("sitout");
				}
			}
			else
			{
				objUser.isSitOut = false;
				mcControls.gotoAndStop ("player");
			}
			objUser.numSit = numSit;
			objUser.objSit = arrSits[numSit];
			setUserBalance (userBalance);
		}
		else
		{
			objUser.isPlayer = false;
			btnMoreChips.enabled = false;
			objUser.numSit = -1;
		}
		//
		if (userCards == "")
		{
			//
			arrSits[numSit].mcStates.gotoAndStop ("wait");
			arrSits[numSit].setAlpha (100);
			//
		}
		else
		{
			//
			arrSits[numSit].setAlpha (0);
			//
			if (!bRobot && (objUser.isPlaying || objUser.isAllIn))
			{
				clearInterval (nHandRankInterval);
				nHandRankInterval = setInterval (showHandRank, 100);
			}
			//
		}
	}
	else
	{
		//
		if (userInGame)
		{
			//
			arrSits[numSit].setAlpha (100);
			//
		}
		else
		{
			//
			arrSits[numSit].setAlpha (50);
			//
		}
		//
	}
}
//
function setPokerType ()
{
	if (objTable.tournament > 0)
	{
		if (objTable.sitCnt == 2)
		{
			mcBack.mcTableHeader.gotoAndStop ("tournament11");
		}
		else if (objTable.stakeType == 3)
		{
			mcBack.mcTableHeader.gotoAndStop ("tournamentnolimit");
		}
		else if (objTable.stakeType == 2)
		{
			mcBack.mcTableHeader.gotoAndStop ("tournamentpotlimit");
		}
		else
		{
			mcBack.mcTableHeader.gotoAndStop ("tournament");
		}
		mcControls.cbxAutoPost.setValue (true);
		mcControls.cbxAutoPost.setEnabled (false);
	}
	else if (objTable.pokerType == 8)
	{
		mcBack.mcTableHeader.gotoAndStop ("crazy");
	}
	else if (objTable.pokerType == 7)
	{
		mcBack.mcTableHeader.gotoAndStop ("stud5");
	}
	else if (objTable.stakeType == 3)
	{
		mcBack.mcTableHeader.gotoAndStop ("nolimit");
	}
	else if (objTable.stakeType == 2)
	{
		mcBack.mcTableHeader.gotoAndStop ("potlimit");
	}
	else if (objTable.stakeType == 1)
	{
		if (objTable.currencyId == 1)
		{
			mcBack.mcTableHeader.gotoAndStop ("playmoney");
		}
	}
	if (objTable.currencyId == 1)
	{
		mcBack.mcChipTray.gotoAndStop ("playmoney");
	}
	else
	{
		mcBack.mcChipTray.gotoAndStop ("money");
	}
	//
	if (objTable.pokerType == 3 || objTable.pokerType == 5)
	{
		objTable.bHiLoPoker = true;
	}
	//
	if (objTable.pokerType == 4 || objTable.pokerType == 5 || objTable.pokerType == 7)
	{
		objTable.studPoker = true;
		objTable.cardBackName = "big_";
		arrRoundName = new Array ("3rd street", "4th street", "5th street", "6th street", "River", "Showdown");
		mcDButton._visible = false;
		//
		numShareCardsX += 105;
		for (var i = 0; i < arrPlayerPotCrd.length; i++)
		{
			arrPlayerPotCrd[i][1] -= 13;
		}
	}
	else
	{
		objTable.studPoker = false;
		objTable.cardBackName = "small_";
		arrRoundName = new Array ("Pre-Flop", "Flop", "Turn", "River", "Showdown");
		mcDButton._visible = true;
	}
	//
	if (objTable.tournament > 0)
	{
		mcControls.cbxSitOut.setLabel ("Post & Fold in turn");
		mcGameId.gotoAndStop ("tournament");
	}
	else if (bRobot)
	{
		mcControls.cbxAutoPost.setValue (true);
		mcControls.cbxAutoPost.setEnabled (false);
	}
	//
	if (bRobot)
	{
		mcBack.gotoAndStop ("robot");
	}
	else
	{
		mcBack.gotoAndStop ("human");
	}
	//
	if (objTable.studPoker)
	{
		objTable.numShowDownRound = 6;
		mcControls.cbxAutoPost.setLabel ("Auto-post ante");
	}
	else
	{
		objTable.numShowDownRound = 5;
		mcControls.cbxAutoPost.setLabel ("Auto-post blind");
	}
}
//
function getFreeSitCnt ()
{
	var freeCnt = 0;
	for (var i = 0; i < arrSits.length; i++)
	{
		if (arrSits[i].getSitStatus () == "free")
		{
			freeCnt++;
		}
	}
	return freeCnt;
}
