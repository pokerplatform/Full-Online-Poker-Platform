var MAX_STAKE = 999999;
var numStake = 0;
//
function setLabel (pBtn, label)
{
	var objTextFormat = pBtn.txtLabel.getTextFormat ();
	objTextFormat.size = 13;
	pBtn.txtLabel.setTextFormat (objTextFormat);
	pBtn.txtLabel.text = label;
	//
	if (pBtn.txtLabel.textHeight > 32)
	{
		objTextFormat.size -= 2;
	}
	pBtn.txtLabel.setTextFormat (objTextFormat);
	//
	pBtn.txtLabel._height = pBtn.txtLabel.textHeight + 5;
	pBtn.txtLabel._x = -pBtn.txtLabel._width / 2;
	pBtn.txtLabel._y = -pBtn.txtLabel._height / 2;
}
// 
function setMessage (strMsg)
{
	txtMsg.htmlText = strMsg;
	txtMsg._visible = true;
}
//
function isActionEnable (strNewAction, numNewStake)
{
	for (var i = _root.objUser.arrAutoAction.length - 1; i >= 0; i--)
	{
		if (_root.objUser.arrAutoAction[i] == strNewAction && _root.objUser.numAutoStake >= numNewStake)
		{
			return true;
		}
	}
	return false;
}
//
function onClickSitOut ()
{
	var xmlAction = new XML ();
	xmlAction.parseXML ("<action name=\"sitoutnexthand\" value=\"" + Number (cbxSitOut.getValue ()) + "\" handid=\"" + _root.objTable.handId + "\"/>");
	_root.sendAction (xmlAction);
	cbxSitOut.wasEnable = cbxSitOut.getEnabled ();
	_root.fSetCBXDisable ();
}
//
function onClickAutoPost ()
{
	if (cbxAutoPost.getValue ())
	{
		for (var i = 0; i < arrPbs.length; i++)
		{
			if (_root.strPostActions.indexOf ("=" + arrPbs[i].action + "=") >= 0)
			{
				doAction (arrPbs[i].action, arrPbs[i].stake);
			}
		}
	}
	var strAction = (_root.objTable.studPoker) ? "postante" : "postblind";
	_root.sendAutoAction (strAction, 0, Number (cbxAutoPost.getValue ()));
	cbxAutoPost.wasEnable = cbxMuck.getEnabled ();
	_root.fSetCBXDisable ();
}
//
function onClickMuck ()
{
	if (cbxMuck.getValue () && isActionValid ("muck"))
	{
		doAction ("muck", 0);
	}
	cbxMuck.wasEnable = cbxMuck.getEnabled ();
	_root.sendAutoAction("muck",0,Number(cbxMuck.getValue()));
	_root.fSetCBXDisable ();
}
//
function doAction (action, stake, dead)
{
	_root.hideTurnTimer ();
	hideButtons ();
	clearInterval (_root.nTBankInterval);
	//
	if (action == undefined || action == "")
	{
		return;
	}
	if (autopressInterval <> null)
	{
		clearInterval (autopressInterval);
		autopressInterval = null;
	}
	var xmlAction = new XML ();
	if (_root.strPostActions.indexOf ("=" + action + "=") >= 0)
	{
		_root.objUser.postBlind = true;
		if (_root.autoPostCnt < 2 && !cbxAutoPost.getValue ())
		{
			_root.autoPostCnt++;
			if (_root.autoPostCnt == 2)
			{
				if (_root.studPoker)
				{
					_root.messageBox ("Tip for speeding up game play...", "You may select the 'Auto-post ante' checkbox to automatically ante when it is your turn. \nThe other players will appreciate it.");
				}
				else
				{
					_root.messageBox ("Tip for speeding up game play...", "You may select the 'Auto-post blind' checkbox to have your blinds automatically posted when it is your turn to post. \nThe other players will appreciate it.");
				}
			}
		}
	}
	else
	{
		_root.objUser.postBlind = false;
		_root.objUser.isWaitBB = (action == "waitbb");
	}
	//
	strAction = "<action name=\"" + action + "\"";
	if (action == "postdead")
	{
		strAction += " stake=\"" + stake + "\" dead=\"" + dead + "\"";
	}
	else if (_root.objTable.stakeType <> 1 && stake > 0)
	{
		strAction += " stake=\"" + stake + "\"";
	}
	strAction += " handid=\"" + _root.objTable.handId + "\"/>";
	xmlAction.parseXML (strAction);
	_root.sendAction (xmlAction);
	//
	if (action == "sitout")
	{
		cbxSitOut.setValue (true);
	}
	//
	_root.objUser.arrAutoAction.splice (0);
	_root.objUser.numAutoStake = 0;
	//
	_root.arrSits[_root.objUser.numSit].wait ();
	//this.gotoAndStop("player");
	_root.objUser.inTurn = false;
	Selection.setFocus(_level0.mcChat.txtNewMsg)
	Selection.setSelection (_level0.mcChat.txtNewMsg.length+1,_level0.mcChat.txtNewMsg.length+1);
}
//
