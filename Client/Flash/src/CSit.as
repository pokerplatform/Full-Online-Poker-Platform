_global.CSitClass = function ()
{
	if (this.hostComponent == undefined)
	{
		this.hostComponent = (this._parent.controller == undefined) ? this._parent : this._parent.controller;
	}
	this.numSit = 0;
	this.objPlayer = new Object ();
	this.strSitStatus = "free";
	this.sitAvailable = true;
	this.initChair ();
	//
	this.numAmount = 0;
	this.strCurrency = "";
	// objects
	this.arrCards = new Array ();
	this.objPot = new Object ();
	this.numPotAmount = 0;
	this.objWonPot = new Object ();
	this.objWonPot = null;
	//
	this.lastClick = 0;
	this.lastAction = "";
	this.depth = 0;
	this.newAlpha = 100;
	this.alphaStep = 0;
	this.bShowLables = true;
	this.bDoAction = false;
	this.actionInt = 0;
	this.userImageVersion = 0;
	//
	this.objTextFormat1 = new TextFormat ();
	this.objTextFormat1 = this.mcStates.playerState_mc.txtLable1.getTextFormat ();
	//this.arrangeLabels();
	//
	this.tabIndex = -1;
	this.tabEnabled = false;
};
//
CSitClass.prototype = new FUIComponentClass ();
Object.registerClass ("CSit", CSitClass);
//
// =========================================================
//::: PRIVATE METHODS
CSitClass.prototype.arrangeLabels = function ()
{
	this.objTextFormat1.size = 10;
	//this.mcStates.txtLable1.multiline = false;
	//this.mcStates.txtLable1.wordWrap = false;
	this.mcStates.playerState_mc.txtLable1.setTextFormat (this.objTextFormat1);
	//
	for (var i = 0; i < 2; i++)
	{
		if (this.mcStates.playerState_mc.txtLable1.textWidth > 78)
		{
			this.objTextFormat1.size--;
			this.mcStates.playerState_mc.txtLable1.setTextFormat (this.objTextFormat1);
		}
		else
		{
			break;
		}
	}
	//this.mcStates.txtLable1.multiline = true;
	//this.mcStates.txtLable1.wordWrap = true;
	this.mcStates.playerState_mc.txtLable1.setTextFormat (this.objTextFormat1);
	//
	//this.mcStates.txtLable1._height = this.mcStates.txtLable1.textHeight+8;
	//this.mcStates.txtLable2._height = this.mcStates.txtLable2.textHeight+6;
	//
//	this.mcStates.playerState_mc.txtLable1._y = -this.mcStates.playerState_mc.txtLable1._height / 2;
//	this.mcStates.playerState_mc.txtLable2._y = this.mcStates.playerState_mc.txtLable1._y + this.mcStates.txtLable1._height - 5;
};
//
CSitClass.prototype.onRollOver = function ()
{
	_root.showTips (this.getTips ());
};
//
CSitClass.prototype.onRollOut = function ()
{
	_root.hideTips ();
};
//
CSitClass.prototype.onPress = function ()
{
	// hide tips
	_root.hideTips ();
	if (this.objPlayer.numId > 0)
	{
		var now = getTimer ();
		if (now - this.lastClick < 300)
		{
			// double click
			_root.showNotesForPlayer (this.objPlayer.numId);
			this.lastClick = 0;
		}
		else
		{
			// remember last click
			this.lastClick = now;
		}
	}
};
//
CSitClass.prototype.onRelease = function ()
{
	if (this.strSitStatus == "busy" || this.strSitStatus == "hidden" || _root.objUser.isPlayer)
	{
		return;
	}
	if (this.strSitStatus == "reserved" && (this.getUserId () <> _root.objUser.userId || !_root.objUser.bSitAllowed))
	{
		return;
	}
	_root.attemptToSit (this.numSit);
};
//
CSitClass.prototype.onEnterFrame = function ()
{
	if (this.alphaStep <> 0)
	{
		if (Math.abs (this._alpha - this.newAlpha) < Math.abs (this.alphaStep))
		{
			this.alphaStep = 0;
			this._alpha = this.newAlpha;
			if (this._alpha == 0)
			{
				this.bShowLables = false;
			}
		}
		else
		{
			this._alpha += this.alphaStep;
		}
		if (!this.bDoAction)
		{
			this.mcStates.playerState_mc.txtLable1._visible = this.mcStates.playerState_mc.txtLable2._visible = this.bShowLables;
		}
	}
};
CSitClass.prototype.initChair = function ()
{
	this.mcStates.playerState_mc.txtLable1.text = "";
	this.mcStates.playerState_mc.txtLable2.text = "";
	//
	this.objPlayer.numId = 0;
	this.objPlayer.strName = "";
	this.objPlayer.strCity = "";
	this.objPlayer.strNote = "";
	this.objPlayer.strAction = "";
	this.objPlayer.strStatus = "disconnected";
	this.objPlayer.numSex = 0;
	this.objPlayer.avatarId = 0;
	this.objPlayer.userImageVersion = 0; 
	this.objPlayer.active = false;
};
//
// =========================================================
//::: PUBLIC METHODS
CSitClass.prototype.setPlayerProperty = function (name, city, sex, avatar, userImageVersion)
{
	this.objPlayer.strName = name;
	this.objPlayer.strCity = city;
	this.objPlayer.numSex = sex;
	this.objPlayer.userImageVersion = userImageVersion;
	this.mcStates.mcBack.gotoAndStop (this.strSitStatus);
	// asking for avatar logo
	_root.mcComm.addCSAMsg (new XML ("<getavatarlogo userid=\""+this.objPlayer.numId+"\" version=\""+this.objPlayer.userImageVersion+"\"/>"));
	trace (_root.mcComm.addCSAMsg);

	if (isNaN (avatar) && this.mcStates.mcBack.mcBusySit.mcAvatar.pic == undefined)
	{
		trace (sex);
		this.mcStates.mcBack.mcBusySit.mcAvatar.attachMovie (sex, "pic", 1);
	}
	else if (this.objPlayer.avatarId <> avatar)
	{
		this.objPlayer.avatarId = avatar;
//		if (avatar < 3)
//		{
			this.mcStates.mcBack.mcBusySit.mcAvatar.attachMovie (sex, "pic", 1);
//			this.mcStates.mcBack.mcBusySit.mcAvatar.attachMovie (avatar, "pic", 1);
//		}
//		else
//		{
//			this.mcStates.mcBack.mcBusySit.mcAvatar.loadMovie ("img/logo" + avatar + ".jpg");
//			this.mcStates.mcBack.mcBusySit.mcAvatar.pic = "img/logo" + avatar + ".jpg";
//			this.mcStates.mcBack.mcBusySit.mcAvatar.loadMovie ("logo" + avatar + ".swf");
//		}
	}
	//
	this.strCurrency = _root.getCurrencySign ();
	//
	var arrFrame = new Array (1,2,3,4,5,6,7,8,9,10)
	switch (_root.objTable.sitCnt)
	{
	case 9 :
		arrFrame = new Array (1,2,3,4,5,6,7,8,9);
		break;
	case 8 :
		arrFrame = new Array (2,3,4,5,6,7,8,9);
		break;
	case 7 :
		arrFrame = new Array (2,3,4,5,6,7,8);
		break;
	case 6 :
		arrFrame = new Array (2,4,5,6,7,9);
		break;
	case 5 :
		arrFrame = new Array (1,3,5,7,9);
		break;
	case 4 :
		arrFrame = new Array (3,5,6,8);
		break;
	case 3 :
		arrFrame = new Array (3,5,7);
		break;
	case 2 :
		arrFrame = new Array (4,7);
		break;
	}
	this.mcStates.playerState_mc.gotoAndStop(arrFrame[this.numSit]);

	if (this.mcStates.playerState_mc.txtLable1.text <> this.getPlayerName ())
	{
		this.mcStates.playerState_mc.txtLable1.text = this.getPlayerName ();
		this.arrangeLabels ();
	}
};
// LOADING AVATAR LOGO
CSitClass.prototype.loadAvatarLogo = function (avatar){
	this.mcStates.mcBack.mcBusySit.mcAvatar.loadMovie (avatar);
}
//
CSitClass.prototype.getPlayerName = function ()
{
	return this.objPlayer.strName;
};
//
CSitClass.prototype.getPlayerLocation = function ()
{
	return this.objPlayer.strCity;
};
//
CSitClass.prototype.getPlayerSex = function ()
{
	return this.objPlayer.numSex;
};
//
CSitClass.prototype.getPlayerLogo = function ()
{
	return this.objPlayer.avatarId;
};
//
CSitClass.prototype.setUserId = function (num)
{
	this.objPlayer.numId = num;
};
//
CSitClass.prototype.getUserId = function ()
{
	return this.objPlayer.numId;
};
//
CSitClass.prototype.setSitNum = function (num)
{
	this.numSit = num;
};
//
CSitClass.prototype.getTips = function ()
{
	var strTips = "";
	if (this.objPlayer.numId == 0)
	{
		if (this._visible && this._alpha > 0)
		{
			if (_root.objUser.numSit >= 0)
			{
				strTips = "Free seat.";
			}
			else
			{
				strTips = "Click here to sit down and start playing.";
			}
		}
	}
	else
	{
		if (this.strSitStatus == "reserved")
		{
			strTips = "Reserved by waiting list.";
		}
		else
		{
			if (this.objPlayer.strCity <> "")
			{
				strTips = "<B>" + this.objPlayer.strName + "</B> (" + this.objPlayer.strCity + ") " + this.strCurrency + _root.moneyFormat (this.numAmount, 1);
			}
			else
			{
				strTips = "<B>" + this.objPlayer.strName + "</B> " + this.strCurrency + _root.moneyFormat (this.numAmount, 1);
			}
			if (this.objPlayer.strStatus == "sitout")
			{
				strTips += " (sitting out)";
			}
			else if (this.objPlayer.strStatus == "disconnected")
			{
				strTips += " (" + this.objPlayer.strStatus + ")";
			}
			if (this.objPlayer.strNote <> undefined && this.objPlayer.strNote <> "")
			{
				strTips += "\n" + this.objPlayer.strNote;
			}
		}
	}
	return strTips;
};
//
CSitClass.prototype.setAmount = function (amount)
{
	this.numAmount = amount;
	this.setPlayerStatus (this.objPlayer.strStatus);
};
//
CSitClass.prototype.getBalance = function ()
{
	return this.numAmount;
};
//
CSitClass.prototype.setNote = function (note)
{
	this.objPlayer.strNote = note;
};
//
CSitClass.prototype.setReserved = function (userId)
{
	this.strSitStatus = "reserved";
	//
	this.mcStates.playerState_mc.txtLable1.text = "";
	this.mcStates.playerState_mc.txtLable2.text = "";
	//
	this.setUserId (userId);
	this.mcStates.mcBack.gotoAndStop (this.strSitStatus);
	//this.arrangeLabels();
};
//
CSitClass.prototype.setFree = function ()
{
	clearInterval (this.actionInt);
	//
	this.strSitStatus = "free";
	this.initChair ();
	this.mcStates.mcBack.gotoAndStop (this.strSitStatus);
	//this.arrangeLabels();
};
//
CSitClass.prototype.setHidden = function ()
{
	this.strSitStatus = "hidden";
	this.initChair ();
	//this.mcStates.mcBack.gotoAndStop ("free");
	this.setAlpha (0);
};
//
CSitClass.prototype.setBusy = function ()
{
	this.strSitStatus = "busy";
	this.mcStates.mcBack.gotoAndStop (this.strSitStatus);
};
//
CSitClass.prototype.getSitStatus = function ()
{
	return this.strSitStatus;
};
//
CSitClass.prototype.setPlayerStatus = function (status)
{
	var objTextFormat2 = this.mcStates.playerState_mc.txtLable2.getTextFormat ();
	if (status == "disconnected")
	{
		this.objPlayer.strStatus = status;
		this.mcStates.playerState_mc.txtLable2.text = "(Disconnected)";
		objTextFormat2.bold = false;
	}
	else if (status == "sitout")
	{
		this.objPlayer.strStatus = status;
		this.mcStates.playerState_mc.txtLable2.text = "(sitting out)";
		objTextFormat2.bold = false;
	}
	else if (status == "allin")
	{
		this.objPlayer.strStatus = "playing";
		this.mcStates.playerState_mc.txtLable2.text = "All-In";
		objTextFormat2.bold = false;
	}
	else if (status == "playing")
	{
		this.objPlayer.strStatus = status;
		this.mcStates.playerState_mc.txtLable2.text = this.strCurrency + _root.moneyFormat (this.numAmount, Number (_root.objTable.minStake < 2));
		objTextFormat2.bold = true;
	}
	else
	{
		this.objPlayer.strStatus = status;
	}
	this.mcStates.playerState_mc.txtLable2.setTextFormat (objTextFormat2);
	//this.arrangeLabels();
};
//
CSitClass.prototype.getPlayerStatus = function ()
{
	return this.objPlayer.strStatus;
};
//
CSitClass.prototype.showAction = function (action)
{
	this.objPlayer.strAction = this.lastAction = action;
	this.mcStates.gotoAndPlay ("action");
	//this.setBack();
};
//
CSitClass.prototype.wait = function ()
{
	this.mcStates.gotoAndStop ("wait");
};
//
CSitClass.prototype.setCards = function (strCardsName)
{
	if (strCardsName == undefined || strCardsName == "")
	{
		return;
	}
	this.deleteCards ();
	var arrTemp = strCardsName.split (",");
	for (var i = 0; i < arrTemp.length; i++)
	{
		var objCard = this.addCard (arrTemp[i]);
		if (objCard <> undefined)
		{
			objCard._x = objCard.newX;
			objCard._y = objCard.newY;
			objCard.swapDepths (objCard.depth);
			objCard._visible = true;
		}
	}
};
//
CSitClass.prototype.addCard = function (strCardName)
{
	var startX = this._x;
	var startY = this._y;
	var halfCnt = arrTemp.length;
	if (_root.objTable.studPoker)
	{
		if (_root.objTable.pokerType == 7)
		{
			halfCnt = 2;
			startX = this._x + 25 - 5 * 15 / 2;
		}
		else
		{
			halfCnt = 3;
			startX = this._x + 25 - 7 * 15 / 2;
		}
	}
	else
	{
		if (_root.objTable.pokerType == 2 || _root.objTable.pokerType == 3)
		{
			startX = this._x + 25 - 4 * 15 / 2;
			startY = startY - 15;
		}
		else if (_root.objTable.pokerType == 1)
		{
			startX = this._x + 25 - 2 * 15 / 2;
		}
	}
	//
	if (_root.objTable.studPoker)
	{
		if (startX < 30)
		{
			startX += 2;
		}
		else if (startX > 700)
		{
			startX -= 8;
		}
	}
	//else {if (startY<100) {startY += 15;} else if (startY>400) {startY -= 15;}}
	var objCard = _root.newCard (strCardName);
	if (objCard <> undefined)
	{
		objCard.type = "player";
		this.arrCards.push (objCard);
		var numOrd = this.arrCards.length - 1;
		if (_root.objTable.studPoker)
		{
			objCard.depth = this.depth - 10 + numOrd;
			objCard.newX = startX + numOrd * 15;
			objCard.newY = startY - 42 + numOrd * 2;
			if (_root.objTable.pokerType == 7)
			{
				if (numOrd == 0 || numOrd == 4)
				{
					//&& this.numSit == _root.objUser.numSit
					objCard.newY += 10;
					//} else {objCard.newY -= 10;
				}
			}
			else
			{
				if (numOrd <= 1 || numOrd == 6)
				{
					//&& this.numSit == _root.objUser.numSit
					objCard.newY += 10;
					//} else {objCard.newY -= 10;
				}
			}
			//if (numOrd<halfCnt) {objCard.newY = startY-43+(halfCnt-numOrd)*5;
			//} else {objCard.newY = startY-43+(numOrd-halfCnt)*5;}
		}
		else if (objCard.name == "back")
		{
			objCard.newX = _root.arrSmCardCrd[this.numSit][0] + numOrd * 5;
			objCard.newY = _root.arrSmCardCrd[this.numSit][1] + numOrd * 2;
		}
		else
		{
			objCard.newX = startX + numOrd * 15 - 17;
			objCard.newY = startY + numOrd * 2;
			if (objCard.isFold && !_root.objTable.studPoker)
			{
				objCard.newY -= 10;
				if (_root.objTable.pokerType == 1)
				{
					objCard.newX -= 15;
				}
			}
		}
	}
	if (this.numSit == _root.objUser.numSit && this.newAlpha > 0)
	{
		this.setAlpha (0);
	}
	return objCard;
};
//
CSitClass.prototype.deleteCards = function ()
{
	if (this.numSit == _root.objUser.numSit && this.arrCards.length > 0 && this.strSitStatus <> "hidden")
	{
		this.setAlpha (100);
		//this.mcStates.gotoAndStop("wait");
	}
	for (var i = 0; i < this.arrCards.length; i++)
	{
		this.arrCards[i].removeMovieClip ();
	}
	this.arrCards.splice (0);
};
//
CSitClass.prototype.foldCards = function ()
{
	if (this.arrCards.length == 0)
	{
		return;
	}
	var point = _root.getDeckCoordinates ();
	for (var i = 0; i < this.arrCards.length; i++)
	{
		this.arrCards[i].moveCardTo (point.x, point.y);
		this.arrCards[i].nextAction = "remove";
	}
	_root.sndCardsFolding.start ();
	this.arrCards.splice (0);
	//this.mcStates.gotoAndStop("wait");
	if (this.numSit == _root.objUser.numSit)
	{
		this.setAlpha (100);
	}
	else
	{
		this.setAlpha (50);
	}
};
//
CSitClass.prototype.showFoldCards = function ()
{
	if (this.arrCards.length == 0)
	{
		return;
	}
	for (var i = 0; i < this.arrCards.length; i++)
	{
		this.arrCards[i].showCorner ();
		//this.arrCards[i].swapDepths(this.depth-(this.arrCards.length-i));
	}
	_root.sndCardsFolding.start ();
	this.setAlpha (100);
};
//
CSitClass.prototype.setPot = function (amount)
{
	this.numPotAmount = amount;
	this.objPot.setChips (amount);
};
//
CSitClass.prototype.getPot = function ()
{
	return this.numPotAmount;
};
//
CSitClass.prototype.setAlpha = function (alpha)
{
	if (this.newAlpha <> alpha)
	{
		if (_root.objUser.animationEnable)
		{
			this._alpha = this.newAlpha;
			this.alphaStep = Math.floor ((alpha - this.newAlpha) / 10);
		}
		else
		{
			this.alphaStep = alpha - this.newAlpha;
		}
		this.newAlpha = alpha;
	}
	if (alpha > 0)
	{
		this._visible = true;
		this.bShowLables = true;
	}
};
//
CSitClass.prototype.setPotObject = function (pPot)
{
	this.objPot = pPot;
};
