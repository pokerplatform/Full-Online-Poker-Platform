var objUser = new Object ();
createUser ();
//
function createUser ()
{
	objUser.userId = 0;
	objUser.userLogin = "";
	//
	objUser.isLogged = false;
	objUser.isPlayer = false;
	objUser.isPlaying = false;
	objUser.isSitOut = false;
	objUser.isAllIn = false;
	objUser.isWaitBB = false;
	objUser.inWaitingList = false;
	objUser.isWaitForChips = false;
	objUser.bSitAllowed = false;
	objUser.acted = false;
	objUser.state = "disconnect";
	//
	objUser.balanceRequest = false;
	objUser.balance = 0;
	objUser.outReserved = 0;
	objUser.outBalance = 0;
	objUser.sessionId = 0;
	objUser.numSit = -1;
	objUser.numSitdown = -1;
	objUser.nTurnTime = 25;
	objUser.nTimeBank = 0;
	objUser.bUseTimeBank = false;
	objUser.objSit = new Object ();
	objUser.drinkName = "";
	//
	objUser.animationEnable = true;
	objUser.soundEnable = true;
	objUser.fourColorCards = false;
	objUser.chatBubblesEnable = true;
	objUser.chatMode = 2;
	objUser.deckColor = "purple";
	//
	objUser.remainAllIn = 0;
	objUser.arrNextActions = new Array ();
	objUser.lastAction = "";
	objUser.postBlind = false;
	objUser.arrAutoAction = new Array ();
	objUser.numAutoStake = 0;
	objUser.rankCards = "";
	objUser.rankCardsLo = "";
	//
	objUser.rebuyAllowed = false;
	objUser.autoRebuy = false;
	objUser.addonButtonState = 0;
	//
	objUser.objStats = new Object ();
}
//
function userLogged (xmlLogged)
{
	objUser.userId = Number (xmlLogged.attributes.userid);
	objUser.userLogin = String (xmlLogged.attributes.userlogin);
	if (objUser.userId > 0 && objUser.userLogin <> "")
	{
		objUser.isLogged = true;
	}
	else
	{
		objUser.isLogged = false;
	}
	if (objTable.favHandId == 0)
	{
		objUser.isPlayer = objUser.isPlaying = false;
		if (objUser.isLogged)
		{
			for (var i = 0; i < arrSits.length; i++)
			{
				if (arrSits[i].getUserId () == objUser.userId)
				{
					objUser.numSit = i;
					objUser.isPlayer = true;
					var strUserStatus = arrSits[i].getPlayerStatus ();
					//arrSits[i].setPlayerStatus(strUserStatus);
					if (strUserStatus == "sitout")
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
					break;
				}
			}
			showFreeSit ();
			if (objUser.arrNextActions.length > 0)
			{
				if (objUser.arrNextActions[0] == "requestprocstate")
				{
					doNextAction ();
				}
				else if (objUser.isPlayer)
				{
					objUser.arrNextActions.splice (0);
				}
			}
		}
		else
		{
			objUser.numSitdown = -1;
		}
		if (objTable.favHandId == 0)
		{
			//mcChat.setChatEnable (objUser.isLogged);
			btnFavrHands._visible = btnMoreChips._visible = objUser.isLogged;
			btnMoreChips.enabled = (objUser.isPlayer && objTable.tournament == 0);
		}
	}
}
// ========================================================
function userBalance (xmlBalance)
{
	if (objTable.currencyId == Number (xmlBalance.attributes.id))
	{
		var balance = Number (xmlBalance.attributes.value);
		var reserved = Number (xmlBalance.attributes.reserved);
		objTable.currencySign = String (xmlBalance.attributes.sign);
		//
		objUser.outBalance = (isNaN (balance)) ? 0 : balance;
		objUser.outReserved = (isNaN (reserved)) ? 0 : reserved;
		if (mcBuyIn <> undefined)
		{
			mcBuyIn.setUserBalance (objUser.outBalance);
		}
		else if (mcTournamentBuyIn <> undefined)
		{
			mcTournamentBuyIn.setUserBalance (objUser.outBalance);
		}
		if (objUser.balanceRequest && objUser.arrNextActions.length > 0 && objUser.arrNextActions[0] == "getbalance")
		{
			objUser.arrNextActions.shift ();
			doNextAction ();
		}
		objUser.balanceRequest = false;
	}
}
// ========================================================
function buyIn ()
{
	if (objTable.tournament == 0)
	{
		var userBalance = 0;
		if (objUser.isPlayer)
		{
			userBalance = getUserBalance ();
		}
		//
		if (userBalance >= objTable.maxBuyIn)
		{
			cancelBuyIn ();
			messageBox ("Buy-in to table...", "\n\nYour " + g_sChipsName + " exceed the limit for this table.");
		}
		else
		{
			if (objUser.outBalance + userBalance < objTable.minBuyIn)
			{
				if (objUser.outReserved + userBalance >= objTable.minBuyIn)
				{
					cancelBuyIn ();
					messageBox ("Buy-in to table...", "\n" + g_sChipsName.substr (0, 1).toUpperCase () + g_sChipsName.substr (1) + " at other tables will arrive in your account after the current hand is finished at that table.");
				}
				else
				{
					if (objTable.currencyId == 1)
					{
						if (mcBuyIn == undefined)
						{
							openWin ("mcBuyIn");
						}
						messageBox ("Out of play " + g_sChipsName + "!", "You are running low on free play " + g_sChipsName + ", but are eligible for more!\n\nJust click on the [I need more " + g_sChipsName + "!] button on the Buy-In window.");
					}
					else
					{
						cancelBuyIn ();
						messageBox ("Buy-in to table...", "\n\nYou do not have sufficient " + g_sChipsName + " to bring to the table.");
					}
				}
			}
			else
			{
				if (mcBuyIn == undefined)
				{
					openWin ("mcBuyIn");
				}
			}
		}
	}
	else if (objTable.tournament == 1)
	{
		if (objUser.outBalance <= (objTable.tournamentBuyIn + objTable.tournamentRake))
		{
			//if(objUser.outReserved>0){} else {}
			cancelBuyIn ();
			messageBox ("You don't have enough money...", "You do not have enough money to play tournament!\nBuy-In : " + objTable.currencySign + objTable.tournamentBuyIn + " + " + objTable.currencySign + objTable.tournamentRake);
		}
		else
		{
			if (mcTournamentBuyIn == undefined)
			{
				openWin ("mcTournamentBuyIn");
			}
		}
	}
}
// 
function cancelBuyIn ()
{
	if (mcMessageBox <> undefined)
	{
		closeWin (mcMessageBox);
	}
	closeWin (mcBuyIn);
	objUser.arrNextActions.splice (0);
	//
	if (!objUser.isPlayer && !objUser.isWaitForChips)
	{
		objUser.numSitdown = -1;
	}
}
function okBuyIn (amount)
{
	if (objUser.numSitdown >= 0 && amount > 0)
	{
		objUser.isWaitForChips = true;
		userSitDown (amount);
	}
	doNextAction ();
	cancelBuyIn ();
}
function okMoreChips (amount)
{
	if (objUser.isPlayer && amount > 0)
	{
		objUser.isWaitForChips = true;
		getMoreChips (amount);
	}
	cancelBuyIn ();
}
//
function pressMoreChips ()
{
	if (objUser.isWaitForChips)
	{
		messageBox ("Please wait ...", "You already requested " + g_sChipsName + " to be brought to this table...");
	}
	else
	{
		objUser.arrNextActions.push ("getbalance");
		objUser.arrNextActions.push ("buyin");
		doNextAction ();
	}
}
// ========================================================
function attemptLeaveTable ()
{
	if (objUser.isPlayer)
	{
		if (mcLeaveTable == undefined)
		{
			openWin ("mcLeaveTable");
		}
		mcLeaveTable.txtTitle.text = mcLeaveTable.txtTitleShape.text = "Leave table...";
		if (objTable.tournament > 0)
		{
			mcLeaveTable.txtTitle.text = mcLeaveTable.txtTitleShape.text = "Leaving a tournament...";
			if (objTable.tournamentStarted)
			{
				mcLeaveTable.txtMsg.text = "Do you still wish to leave this table?\nIf you leave the table before the tournament is finished, you will automatically post blinds and fold in turn until you run out of tournament " + g_sChipsName + ".";
			}
			else
			{
				mcLeaveTable.txtMsg.text = "Do you still wish to leave this table?\nIf you leave the table BEFORE the tournament has started, you will receive a full refund of your buy-in and fee.";
			}
		}
		else if (objUser.isPlaying)
		{
			mcLeaveTable.txtMsg.text = "\nIf you leave table now, your hand will be folded";
		}
		else
		{
			mcLeaveTable.txtMsg.text = "\nAre you sure you want to leave your seat?";
		}
	}
	else
	{
		userLeaveTable ();
	}
}
function okLeaveTable ()
{
	if (objUser.isPlaying)
	{
		sendStatsResult ();
	}
	cancelLeaveTable ();
	userLeaveTable ();
}
function cancelLeaveTable ()
{
	_root.closeWin (mcLeaveTable);
}
// ========================================================
function attemptToSit (numSit)
{
	//if (objUser.arrNextActions.length>0 || 
	if (objUser.isPlayer || objUser.numSitdown >= 0 || objUser.isWaitForChips || objTable.favHandId > 0)
	{
		return;
	}
	objUser.numSitdown = numSit;
	objUser.arrNextActions.push ("getbalance");
	objUser.arrNextActions.push ("buyin");
	if (objTable.currencyId == 1)
	{
		doNextAction ();
	}
	else
	{
		if (objTable.tournament == 0 && mcMoneyWarning == undefined)
		{
			openWin ("mcMoneyWarning");
		}
		else
		{
			doNextAction ();
		}
	}
}
//
function setUserBalance (numBalance)
{
	mcMsgYourChips.setLabel ("Your " + g_sChipsName + ": " + objTable.currencySign + moneyFormat (numBalance, 1));
	objUser.balance = numBalance;
}
//
function getUserBalance ()
{
	var nUserBalance = 0;
	if (objUser.isPlayer)
	{
		nUserBalance = arrSits[objUser.numSit].getBalance ();
	}
	return nUserBalance;
}
//
function pressAddOn (){
	trace ("AddOn")
	mcComm.addCSAMsg (new XML ("<addon/>"));
}
function pressAutorebuy (){
	var val = cbxAutoRebuy.getValue();
	trace (val)
	mcComm.addCSAMsg (new XML ("<autorebuy value=\""+val+"\"/>"));
}
function setRebuyAllowed(){
	cbxAutoRebuy._visible = objUser.rebuyAllowed;
}
function setAutoRebuy(){
	trace (objUser.autoRebuy)
	cbxAutoRebuy.setCheckState(objUser.autoRebuy);
}
