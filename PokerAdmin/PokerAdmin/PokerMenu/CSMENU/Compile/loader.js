var csFallBackFile = "fallback.js";
var csIE4File = "ie4.js";
var csIE5File = "ie5.js";
var csIE6File = "ie6.js";
var csNN4File = "nn4.js";
var csNN6File = "nn6.js";
var csMoz1File = "moz1.js";

function csBrowserInfo()
{
	var csAppName = String(navigator.appName);
	var csAppVer = String(navigator.appVersion);
	var csPlatform = String(navigator.platform);
	var csUserAgent = String(navigator.userAgent);
	var csVendor = String(navigator.vendor);
	var csProduct = String(navigator.product);
	if(csUserAgent.indexOf("Opera") > -1)
		return 0;
	else if(csUserAgent.indexOf("MSIE 4") > -1 && csPlatform != "MacPPC")
		return 1;
	else if(csUserAgent.indexOf("MSIE 5") > -1)
		return 2;
	else if(csUserAgent.indexOf("MSIE 6") > -1)
		return 5;
	else if(csVendor == "Netscape6")
		return 4;
	else if(csProduct == "Gecko")
		return 6;
	else if(csAppName == "Netscape")
	{
		if(parseFloat(csAppVer) >= 4.06 && parseFloat(csAppVer) < 5)
			return 3;
		else
			return 0;
	}
	else
		return 0;
}
var csBrowserType = csBrowserInfo();
document.write("<style type=\"text/css\">\r\n.cswmDock{display:none;position:absolute;top:0px;left:0px;border:dotted #000000 1px;padding:0px;width:100%;}\r\n.cswmButtons{position:relative;top:0px;left:0px;background-color:#dbd7d0;border-top: solid #808080 1px;border-left: solid #808080 1px;border-bottom: solid #808080 1px;border-right: solid #808080 1px;padding:0px;cursor:default;width:100%;}\r\n.cswmInnerBorder{background-color:#dbd7d0;padding:0px;width:100%;}\r\n.cswmButton{background-color:#dbd7d0;border-top: solid #dbd7d0 1px;border-left: solid #dbd7d0 1px;border-bottom: solid #dbd7d0 1px;border-right: solid #dbd7d0 1px;color:Black;font-family:\"MS Sans Serif\";font-size:14px;font-style:normal;text-decoration:none;font-weight:bold;text-align:center;padding-top:2px;padding-bottom:2px;padding-left:10px;padding-right:10px;}\r\n.cswmHandle{background-color:#dbd7d0;border-top: solid #ffffff 1px;border-left: solid #ffffff 1px;border-bottom: solid #808080 1px;border-right: solid #808080 1px;cursor:move;width:3px;}\r\n.cswmNNDck{position:absolute;border:outset #808080 1px;width:100%;color:#d0d0d0;font-family:\"MS Sans Serif\";font-size:14px;font-style:normal;text-decoration:none;font-weight:bold;text-align:center;text-decoration:none;padding:3px;}\r\n.cswmNNBtns{position:absolute;}\r\n.cswmNNBtn{border-style:outset;border-color:#dbd7d0;border-width:1px;}\r\n.cswmNNBtnTxt{color:Black;font-family:\"MS Sans Serif\";font-size:14px;font-style:normal;text-decoration:none;font-weight:bold;text-align:center;padding-top:2px;padding-bottom:2px;padding-left:10px;padding-right:10px;}\r\n.cswmNNHnd{color:Black;font-family:\"MS Sans Serif\";font-size:14px;font-style:normal;text-decoration:none;font-weight:bold;text-align:center;padding:3px;}\r\n.cswmItem {font-family:MS Sans Serif; font-size:11px; font-weight:bold; font-style:normal; color:#000000; text-decoration:none; padding:5 10 5 10}\r\n.cswmItemOn {font-family:MS Sans Serif; font-size:11px; font-weight:bold; font-style:normal; color:Red; text-decoration:none; padding:5 10 5 10}\r\n.cswmExpand {cursor:default}\r\n.cswmPopupBox {cursor:default; position:absolute; left:-500; display:none; z-index:1999}\r\n.cswmDisabled {color:#808080}\r\n</style>");
document.write("<script language=\"JavaScript\" type=\"text/javascript\" src=\"");
if(csBrowserType == 0)
	document.write(csIncludeDir + "/" + csFallBackFile);
else if(csBrowserType == 1)
	document.write(csIncludeDir + "/" + csIE4File);
else if(csBrowserType == 2)
	document.write(csIncludeDir + "/" + csIE5File);
else if(csBrowserType == 3)
	document.write(csIncludeDir + "/" + csNN4File);
else if(csBrowserType == 4)
	document.write(csIncludeDir + "/" + csNN6File);
else if(csBrowserType == 5)
	document.write(csIncludeDir + "/" + csIE6File);
else if(csBrowserType == 6)
	document.write(csIncludeDir + "/" + csMoz1File);
else
	document.write(csIncludeDir + "/" + csFallBackFile);
document.write("\"></script>");
