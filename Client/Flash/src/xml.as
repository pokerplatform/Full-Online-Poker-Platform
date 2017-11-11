// ===================================================================
function xmlParser (xmlIn)
{
	//if (xmlIn.status<>0) {return;}
	if (xmlIn.childNodes.length > 0)
	{
		for (var i = 0; i < xmlIn.childNodes.length; i++)
		{
			xmlNodeParser (xmlIn.childNodes[i]);
		}
	}
	else
	{
		xmlNodeParser (xmlIn);
	}
}
// ===================================================================
function xmlNodeParser (xmlNode)
{
	var strNodeName = xmlNode.nodeName.toLowerCase ();
	var xmlNew = new XML ();
	switch (strNodeName)
	{
	case "gaaction" :
		for (var j = 0; j < xmlNode.childNodes.length; j++)
		{
			if (objTable.favHandId > 0)
			{
				var subNodeName = xmlNode.childNodes[j].nodeName.toLowerCase ();
				if (subNodeName == "procinit")
				{
					xmlNodeParser (xmlNode.childNodes[j]);
				}
				else if (subNodeName == "procstate")
				{
					xmlNodeParser (xmlNode.childNodes[j]);
					arrReplay.push (xmlNode.childNodes[j]);
				}
				else
				{
					arrReplay.push (xmlNode.childNodes[j]);
				}
			}
			else
			{
				var procId = Number (xmlNode.attributes.processid);
				xmlNodeParser (xmlNode.childNodes[j]);
			}
		}
		break;
	case "movebets" :
		arrQueue.push (xmlNode);
		xmlNew.parseXML ("<pause timer=\"500\"/>");
		arrQueue.push (xmlNew.firstChild);
		break;
	case "finalpot" :
		arrQueue.push (xmlNode);
		xmlNew.parseXML ("<pause timer=\"1200\"/>");
		arrQueue.push (xmlNew.firstChild);
		break;
	case "dealcards" :
		arrQueue.push (xmlNode);
		var numRound = Number (xmlNode.attributes.round);
		if (numRound > 1 && numRound < arrRoundName.length)
		{
			if (nActionsInRound == 0)
			{
				xmlNew.parseXML ("<pause timer=\"2500\"/>");
			}
			else
			{
				xmlNew.parseXML ("<pause timer=\"1000\"/>");
			}
			arrQueue.push (xmlNew.firstChild);
		}
		else if (numRound == -1)
		{
			if (objTable.tournament > 0 && !objTable.tournamentStarted)
			{
				xmlNew.parseXML ("<pause timer=\"5000\"/>");
				arrQueue.push (xmlNew.firstChild);
			}
		}
		else if (numRound == 1)
		{
			var numCardsCnt = xmlNode.childNodes.length;
			if (numCardsCnt == 0)
			{
				xmlNew.parseXML ("<pause timer=\"1000\"/>");
			}
			else
			{
				if (objTable.pokerType == 1)
				{
					numCardsCnt *= 2;
				}
				else if (objTable.pokerType == 2 || objTable.pokerType == 3)
				{
					numCardsCnt *= 4;
				}
				else if (objTable.pokerType == 4 || objTable.pokerType == 5)
				{
					numCardsCnt *= 3;
				}
				xmlNew.parseXML ("<pause timer=\"" + numCardsCnt * 150 + "\"/>");
			}
			arrQueue.push (xmlNew.firstChild);
		}
		nActionsInRound = 0;
		break;
	case "procstate" :
		arrQueue.push (xmlNode);
		if (!blnReady)
		{
			xmlNew.parseXML ("<pause timer=\"500\"/>");
			arrQueue.push (xmlNew.firstChild);
		}
		else
		{
			xmlNew.parseXML ("<pause timer=\"200\"/>");
			arrQueue.push (xmlNew.firstChild);
		}
		break;
	default :
		arrQueue.push (xmlNode);
	}
}
// ===================================================================
function xmlExecuter (xmlChild)
{
	var strNodeName = xmlChild.nodeName.toLowerCase ();
	if (strNodeName == "pause")
	{
		intQueue = setInterval (execQueue, Number (xmlChild.attributes.timer));
	}
	else
	{
		switch (strNodeName)
		{
		case "procinit" :
			////////////////    from GE      //////////////////////
			initTable (xmlChild);
			break;
		case "procclose" :
			closeTable (xmlChild);
			break;
		case "procstate" :
			stateTable (xmlChild);
			if (!blnReady)
			{
				gotoAndPlay ("showtable");
			}
			else if (mcTournamentMsg <> undefined)
			{
				closeWin (mcTournamentMsg);
			}
			break;
		case "waitinglist" :
			objTable.waitingList = Number (xmlChild.attributes.value);
			if (!objUser.isPlayer && objTable.favHandId == 0)
			{
				mcControls.gotoAndStop ("watcher");
				mcControls.setWatcher ();
			}
			break;
		case "chair" :
			setChair (xmlChild);
			showFreeSit ();
			break;
		case "action" :
			playerAction (xmlChild);
			break;
		case "setactiveplayer" :
			setTurn (xmlChild);
			break;
		case "ranking" :
			// setRanking(xmlChild);
			break;
		case "movebets" :
			moveBets (xmlChild);
			break;
		case "startround" :
			startRound (xmlChild);
			break;
		case "endround" :
			endRound (xmlChild);
			break;
		case "dealcards" :
			dealCards (xmlChild);
			break;
		case "rake" :
			if (xmlChild.attributes.amount <> undefined)
			{
				var rakeAmount = Number (xmlChild.attributes.amount);
				setRake (rakeAmount);
			}
			break;
		case "finishhand" :
			finishHand (xmlChild);
			break;
		case "finalpot" :
			finalPot (xmlChild);
			break;
		case "pots" :
			setSharePots (xmlChild);
			break;
		case "chat" :
			addChat (xmlChild, 0);
			break;
		case "message" :
			messageBox (xmlChild.attributes.title, xmlChild.attributes.text);
			break;
		case "tournament" :
			if (xmlChild.attributes.state <> undefined && String (xmlChild.attributes.state) == "pause")
			{
				openTournamentMsg ();
				mcTournamentMsg.txtMsg.text = "Hand-for-Hand play is in progress.\n\nThe next hand will be dealt when hands at the other tables are completed ...";
			}
			break;
		case "tournamentstart" :
			openWinWithDuration("mcTournamentStartMsg", parseInt(xmlChild.attributes.duration)*1000);
			break;
		case "breakstart" :
			openWinWithDuration("mcWeAreNowABreakMsg", parseInt(xmlChild.attributes.duration)*1000);
			break;
			////////////////    from CSA      //////////////////////
		case "init" :
			procInit (xmlChild);
			break;
		case "connection" :
			// disconnected|connecting|connected
			var strConnectStatus = String (xmlChild.attributes.state);
			if (strConnectStatus == "disconnected")
			{
				if (objUser.isLogged)
				{
					this.btnFavrHands.enabled = false;
					this.btnMoreChips.enabled = false;
					//
					if (objUser.isPlayer && objTurnSeat <> null && objTurnSeat == arrSits[objUser.numSit])
					{
						objTurnSeat = null;
						//this.mcTurnTimer.stop();
					}
				}
				//
				if (objUser.isPlayer == false)
				{
					mcComm.addCSAMsg (new XML ("<gamefinished reason=\"Table was closed because of disconnect.\"/>"));
				}
				else
				{
					this.mcControls.gotoAndStop ("disconnect");
					this.openWin("mcDisconnect");
				}
			}
			else if (strConnectStatus == "connected")
			{
				if (objUser.connection == "disconnected" || objUser.connection == "connecting")
				{
					//
					if (objUser.isLogged)
					{
						if (objUser.isPlayer)
						{
							btnMoreChips.enabled = (objTable.tournament == 0);
						}
						else
						{
							btnMoreChips.enabled = false;
							this.mcControls.gotoAndStop ("watcher");
						}
						this.btnFavrHands.enabled = true;
					}
					else
					{
						this.mcControls.gotoAndStop ("watcher");
					}
					objUser.arrNextActions.push ("requestprocstate");
					this.closeWin(mcDisconnect);
				}
			}
			objUser.connection = strConnectStatus;
			break;
		case "logged" :
			userLogged (xmlChild);
			break;
		case "gamefinished" :
			attemptLeaveTable ();
			break;
		case "options" :
			setOptions (xmlChild);
			break;
		case "getuserbalance" :
			if (objUser.balanceRequest)
			{
				userBalance (xmlChild);
			}
			break;
		case "getnotes" :
			getNotes (xmlChild);
			break;
		case "windowstate" :
			setWindowState (xmlChild);
			break;
		case "waitingliststatus" :
			objUser.inWaitingList = Boolean (xmlChild.attributes.value);
			objUser.bSitAllowed = Boolean (xmlChild.attributes.sitallowed);
			if (!objUser.isPlayer && objTable.favHandId == 0)
			{
				mcControls.gotoAndStop ("watcher");
				mcControls.setWatcher ();
			}
			break;
		case "changetable" :
			openTournamentMsg ();
			mcTournamentMsg.txtMsg.text = String (xmlChild.attributes.reason);
			objTable.procId = Number (xmlChild.attributes.newprocessid);
			objTable.name = String (xmlChild.attributes.processname);
			mcComm.setProcID (objTable.procId);
			break;
		case "chatstate" :
			mcChat.setChatEnable (Boolean (xmlChild.attributes.allow));
			break;
		case "getavatarlogo" :
			trace ("getavatarlogo");
			loadAvatarLogo (String (xmlChild.attributes.path),Number(xmlChild.attributes.userid));
			break;
			////////////////    PRIVATE      //////////////////////
		case "cleartable" :
			clearTable ();
			break;
		case "statsresult" :
			sendStatsResult ();
			break;
		}
		execQueue ();
	}
}
//
function sendAction (xmlAction)
{
	if (xmlAction.status == 0)
	{
		mcComm.addGEMsg (xmlAction);
	}
}
// ========================================================
function procInit (xmlInit)
{
	objUser.sessionId = Number (xmlInit.attributes.sessionid);
	objTable.procId = Number (xmlInit.attributes.processid);
	objTable.name = String (xmlInit.attributes.processname);
	mcComm.setProcID (objTable.procId);
	if (xmlInit.attributes.rhand <> undefined && Number (xmlInit.attributes.rhand) > 0)
	{
		objTable.favHandId = Number (xmlInit.attributes.rhand);
		for (var i = 0; i < xmlInit.childNodes.length; i++)
		{
			if (xmlInit.childNodes[i].nodeName.toLowerCase () == "gaaction")
			{
				var xmlPause = new XML ();
				xmlPause.parseXML ("<pause timer=\"500\"/>");
				xmlNodeParser (xmlPause.firstChild);
				xmlNodeParser (xmlInit.childNodes[i]);
			}
		}
	}
	else if (xmlInit.attributes.processid <> undefined && Number (xmlInit.attributes.processid) > 0)
	{
		mcComm.addGEMsg (new XML ("<procinit/>"));
	}
	gotoAndStop ("initgame");
}
//
function closeTable (xmlClose)
{
	if (xmlClose.nodeName.toLowerCase () <> "procclose")
	{
		return;
	}
	var strReason = xmlClose.attributes.reason;
	mcComm.addCSAMsg (new XML ("<gamefinished reason=\"" + strReason + "\"/>"));
}
function userLogin ()
{
	mcComm.addCSAMsg (new XML ("<login/>"));
}
function getBalance ()
{
	objUser.balanceRequest = true;
	mcComm.addCSAMsg (new XML ("<getuserbalance id=\"" + objTable.currencyId + "\"/>"));
}
function showHelp ()
{
	mcComm.addCSAMsg (new XML ("<help/>"));
}
function resetAllIn ()
{
	mcComm.addCSAMsg (new XML ("<allins action=\"reset\"/>"));
}
function showHandHistory ()
{
	mcComm.addCSAMsg (new XML ("<handhistory handid=\"" + objTable.prevHandId + "\"/>"));
}
function showFavHands ()
{
	mcComm.addCSAMsg (new XML ("<record handid=\"" + objTable.prevHandId + "\"/>"));
}
function userLeaveTable ()
{
	mcComm.addGEMsg (new XML ("<action name=\"leavetable\" handid=\"" + objTable.handId + "\"/>"));
	mcComm.addCSAMsg (new XML ("<gamefinished/>"));
}
function userSitDown (amount)
{
	if (objUser.numSitdown >= 0)
	{
		mcComm.addGEMsg (new XML ("<action name=\"sitdown\" position=\"" + objUser.numSitdown + "\" amount=\"" + amount + "\" handid=\"" + objTable.handId + "\"/>"));
		objUser.numSitdown = -1;
	}
}
function getMoreChips (amount)
{
	if (objUser.isPlayer && amount > 0)
	{
		mcComm.addGEMsg (new XML ("<action name=\"morechips\" amount=\"" + amount + "\" handid=\"" + objTable.handId + "\"/>"));
	}
}
function readyToShow ()
{
	var strCaption = "";
	strCaption += objTable.currencySign + moneyFormat (objTable.minStake, 1) + "/" + objTable.currencySign + moneyFormat (objTable.maxStake, 1) + " " + arrPokerNames[objTable.pokerType];
	if (objTable.tournament > 0)
	{
		strCaption += " - Tournament table";
	}
	else
	{
		strCaption += " - Table";
	}
	mcComm.addCSAMsg (new XML ("<gamestarted caption=\"" + strCaption + "\"/>"));
}
//
function activateWindow ()
{
	if (!bRobot)
	{
		mcComm.addCSAMsg (new XML ("<windowstate active=\"1\"/>"));
	}
}
function requestProcState ()
{
	var xmlRequest = new XML ();
	xmlRequest.parseXML ("<procstate/>");
	mcComm.addGEMsg (xmlRequest);
	//xmlRequest.parseXML("<setactiveplayer/>");mcComm.addGEMsg(xmlRequest);
}
//
function sendAutoAction (action, stake, value)
{
	var xmlAction = new XML ();
	xmlAction.parseXML ("<autoaction name=\"" + action + "\" value=\"" + value + "\" stake=\"" + stake + "\" handid=\"" + objTable.handId + "\" round=\"" + objTable.numRound + "\" />");
	if (xmlAction.status == 0)
	{
		mcComm.addGEMsg (xmlAction);
	}
}
