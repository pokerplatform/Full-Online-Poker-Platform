
function ae_m_out(src) {
	//mouse out button style
	if(src.state==0) return;	
	if(src.state==2) { src.className="latched"; return; }
	if(src.type=="btn") {
		window.status="";
		src.className="flat";
	}
}

function ae_m_over(src) {
	//mouse over button style
	if(src.state==0) return;
	if(src.state==2) return;
	if(src.type=="btn") {
		//window.status=src.status;
		src.className="outset";
	}
}

function ae_m_down(src) {
	//mouse down button style
	if(src.state==0) return;
	if(src.type=="btn") {
		src.className="inset";
	}
}

function ae_m_up(src) {
	//mouse up button style
	if(src.state==0) return;
	if(src.state==2) { src.className="latched"; return; }
	if(src.type=="btn") {
		src.className="outset";
	}
}

function set_tbstates(num) {
	var pbtn;
	var cid;
	var state;
	var DHTMLSafe=document.all["DHTMLSafe1"];
	ae_tbar=eval("ae_tbar1");
	if(DHTMLSafe.QueryStatus(5002)!=DHTMLSafe.QueryStatus(5003)) return;

	for(var i=0;i<ae_tbar.all.length;i++) {
		pbtn= ae_tbar.all(i);
		cid=pbtn.cid;
		if(cid < 6000&&cid!=DECMD_HYPERLINK) {
			pbtn.style.visibility="visible";
			state=DHTMLSafe.QueryStatus(cid)
			
	   		if(state == DECMDF_DISABLED || state == DECMDF_NOTSUPPORTED) {
				if(pbtn.state!=0) {
						pbtn.className = "disabled";
						pbtn.state = 0;
				}
			}else if(state == DECMDF_ENABLED || state == DECMDF_NINCHED){
				if(pbtn.state!=1) {
					pbtn.className = "flat";
					pbtn.state = 1;
				}
			}else {   //latched
				if(pbtn.state!=2) {
					pbtn.className = "latched";
					pbtn.state = 2;
				}
			}
		}
	}
	
}

function ae_onCommand(cmdId) {
	//no buttons should work in html mode
	DHTMLSafe=document.all["DHTMLSafe1"];
	
	if(cmdId==null) cmdid=eval(window.event.srcElement.cid);
	else cmdid=cmdId;

	doFocus=true;	
		
	switch(parseInt(cmdid)) {
		case DECMD_IMAGE:
			oSel = DHTMLSafe.DOM.selection;
			if (oSel.type == "Control") {
				ae_imageProperties(num);
			}
			else {
				//DHTMLSafe.DOM.selection.createRange().collapse(false);
				onImagewin(num);
			}
			doFocus=false;
			break;
		case DECMD_INSERTTABLE:
			onTableWin(num);
			doFocus=false;
			break;
		case DECMD_EDITSOURCE:
			if(tabview[num]) ae_editsourceinline(num);
			else { 
				ae_editsource(num);
				doFocus=false;
			}
			break;
		case DECMD_ABOUT:
			ae_about();
			doFocus=false;
			break;
		case DECMD_HELP:
			ae_help();
			doFocus=false;
			break;
		case DECMD_TOGGLE_DETAILS:
			ae_onToggleDetails(null, num);
			break;
		case DECMD_EDITTABLE:
			editTableWin(num);
			doFocus=false;
			break;
		case DECMD_SPELLCHECK:
			ae_spellcheckwin(num);
			doFocus=false;
			break;
		case DECMD_SPECIAL_CHARS:
			ae_specialchars();
			doFocus=false;
			break;
		case DECMD_IMAGE_PROPERTIES:
			oSel = DHTMLSafe.DOM.selection.createRange();
			for (i=0; i<oSel.length; i++) {
				if (oSel(i).tagName == "IMG") {
					//alert(oSel(i).src);
					ae_imageProperties(num);
					doFocus=false;
				}
   			}
			break;
		case DECMD_PASTE:
   			ae_onPaste(num);
   			doFocus=false;
   			break;
		case DECMD_HR:
			ae_onHr(num);
			doFocus=false;
			break;
		default:
			if(DHTMLSafe.QueryStatus(cmdid)!=DECMDF_DISABLED) {
				DHTMLSafe.ExecCommand(cmdid, OLECMDEXECOPT_DODEFAULT);
			}
			break;
	}
	if (doFocus) {
		DHTMLSafe.focus();
		DHTMLSafe.DOM.body.focus();
	}
}

function ae_onkeypress(num) {
	var sel;
	DHTMLSafe=document.all["DHTMLSafe1"];
	switch(DHTMLSafe.DOM.parentWindow.event.keyCode) {
		case 10:
			DHTMLSafe.DOM.parentWindow.event.keyCode = 13;			
			break;
		case 13:
			if(DHTMLSafe.QueryStatus(DECMD_UNORDERLIST)!=DECMDF_LATCHED) {
				DHTMLSafe.DOM.parentWindow.event.returnValue = false;		
				sel = DHTMLSafe.DOM.selection.createRange();
				sel.pasteHTML("<BR>");
				sel.collapse(false);
				sel.select();
			}
			break;
		default:
			break;
	}
}

function ae_onclick(num) {
	set_tbstates(num);
}

function ae_ondisplaychange(num) {
 	set_tbstates(num);
}

function SetContextMenu() {
	// Build the context menu. 
	DHTMLSafe=document.all["DHTMLSafe1"];
	DHTMLSafe.SetContextMenu(menuStrings, menuStates);	
}

function ContextMenuAction(num){
	DHTMLSafe=document.all["DHTMLSafe1"];
	DHTMLSafe.DOM.selection.createRange().pasteHTML(mergeTags[num]);
}