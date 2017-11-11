<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Page language="c#" validateRequest="false" Codebehind="EmailTemplateDetails.aspx.cs" AutoEventWireup="false" Inherits="Admin.EmailTemplates.EmailTemplateDetails" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title>Email Template Details</title>
		<meta content="Microsoft Visual Studio 7.0" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<SCRIPT language="JavaScript" id="clientEventHandlersJS" src="../DHTML/include/dhtmled.js"></SCRIPT>
		<SCRIPT language="JavaScript" id="clientEventHandlersJS1" src="../DHTML/include/editjs.js"></SCRIPT>
</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="TemplateEdit" method="post" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="100%" align="center" border="0">
				<tr>
					<td colSpan="2">
						<table align="center">
							<tr>
								<td><CBC:BUTTONIMAGE id="btnSave" onclick="btnSave_Click" runat="server" Text="Save"></CBC:BUTTONIMAGE></td>
								<td><CBC:BUTTONIMAGE id="btnCancel" onclick="bntGoBack_Click" runat="server" Text="Cancel" CausesValidation="false"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="middle" colSpan="2"><asp:label id="lblError" Runat="server"></asp:label></td>
				</tr>
				<tr>
					<td align="middle">
						<table class="cssReport cssTextMain" borderColor="#3399ff" cellSpacing="0" cellPadding="2" width="60%" align="center" border="1">
							<TR class="cssReportHeader" align="middle">
								<TD colSpan="3" height="22">Email Template Info</TD>
							</TR>
							<TR>
								<TD width="20%">Name</TD>
								<TD align="left" width="70%" colSpan="2"><asp:label id="lblName" Runat="server"></asp:label></TD>
							</TR>
							<tr>
								<td width="20%"><asp:requiredfieldvalidator id="rfvName" runat="server" ControlToValidate="txtSubject" Display="Dynamic" ErrorMessage="RequiredFieldValidator"> Enter</asp:requiredfieldvalidator>Subject 
									*</td>
								<td align="left" width="70%" colSpan="2"><asp:textbox id="txtSubject" Runat="server" MaxLength="50" Columns="70"></asp:textbox></td>
							</tr>
							<tr>
								<td colSpan="3" height="300">
									<table height="100%" cellSpacing="2" cellPadding="0" width="100%" bgColor="#cccccc" border="0">
										<tr vAlign="center" height="10">
											<td><SPAN onmouseup="ae_m_up(window.event.srcElement);" onselectstart="window.event.returnValue=false;" onmousedown="ae_m_down(window.event.srcElement);" id="ae_tbar1" ondragstart="window.event.returnValue=false;" onmouseover="ae_m_over(window.event.srcElement);" onmouseout="ae_m_out(window.event.srcElement);"><NOBR><IMG src="../DHTML/images/toolbar.gif"><IMG class="flat" onclick="ae_onCommand(null);" src="../DHTML/images/fgcolor.gif" cid="5009" type="btn"><IMG class="flat" onclick="ae_onCommand(null);" src="../DHTML/images/bold.gif" cid="5000" type="btn"><IMG class="flat" onclick="ae_onCommand(null);" src="../DHTML/images/italic.gif" cid="5023" type="btn"><IMG class="flat" onclick="ae_onCommand(null);" src="../DHTML/images/under.gif" cid="5048" type="btn"><IMG src="../DHTML/images/space.gif"><IMG class="flat" onclick="ae_onCommand(null);" src="../DHTML/images/deindent.gif" cid="5031" type="btn"><IMG class="flat" onclick="ae_onCommand(null);" src="../DHTML/images/inindent.gif" cid="5018" type="btn"><IMG src="../DHTML/images/space.gif"><IMG class="flat" onclick="ae_onCommand(null);" src="../DHTML/images/left.gif" cid="5025" type="btn"><IMG class="flat" onclick="ae_onCommand(null);" src="../DHTML/images/center.gif" cid="5024" type="btn"><IMG class="flat" onclick="ae_onCommand(null);" src="../DHTML/images/right.gif" cid="5026" type="btn"><IMG class="flat" onclick="ae_onCommand(null);" src="../DHTML/images/bullist.gif" cid="5051" type="btn"><IMG src="../DHTML/images/space.gif"><IMG class="flat" onclick="ae_onCommand(null);" src="../DHTML/images/link.gif" cid="5016" type="btn"></NOBR></SPAN>
											</td>
										</tr>
										<tr>
											<td>
                  <OBJECT id=DHTMLSafe1 style="Z-INDEX: 1" height="100%" 
                  width="100%" 
                  classid=clsid:2D360201-FFF5-11d1-8D03-00A0C959BC0A VIEWASTEXT>
	<PARAM NAME="ActivateApplets" VALUE="0">
	<PARAM NAME="ActivateActiveXControls" VALUE="0">
	<PARAM NAME="ActivateDTCs" VALUE="-1">
	<PARAM NAME="ShowDetails" VALUE="0">
	<PARAM NAME="ShowBorders" VALUE="0">
	<PARAM NAME="Appearance" VALUE="1">
	<PARAM NAME="Scrollbars" VALUE="-1">
	<PARAM NAME="ScrollbarAppearance" VALUE="0">
	<PARAM NAME="SourceCodePreservation" VALUE="-1">
	<PARAM NAME="AbsoluteDropMode" VALUE="0">
	<PARAM NAME="SnapToGrid" VALUE="0">
	<PARAM NAME="SnapToGridX" VALUE="50">
	<PARAM NAME="SnapToGridY" VALUE="50">
	<PARAM NAME="UseDivOnCarriageReturn" VALUE="0">
	</OBJECT>
												<SCRIPT language="javascript" event="onkeypress" for="DHTMLSafe1">
											return ae_onkeypress(1);
												</SCRIPT>
												<SCRIPT language="javascript" event="onclick" for="DHTMLSafe1">
											return ae_onclick(1);
												</SCRIPT>
												<SCRIPT language="javascript" event="DisplayChanged" for="DHTMLSafe1">
											return ae_ondisplaychange(1);
												</SCRIPT>
												<SCRIPT language="javascript" event="ContextMenuAction(itemIndex)" for="DHTMLSafe1">
											return ContextMenuAction(itemIndex);
												</SCRIPT>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>Upload HTML</td>
								<td align="left"><input id="fileHtml" style="WIDTH: 100%" type="file" size="50" runat="server"></td>
								<td align="middle" width="10%"><CBC:BUTTONIMAGE id="btnUpload" onclick="btnUpload_Click" runat="server" Text="Upload"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER><TEXTAREA id="txtBody" style="Z-INDEX: 101; LEFT: 185px; VISIBILITY: hidden; POSITION: absolute; TOP: 602px" name="txtBody" runat="server"></TEXTAREA>
			<INPUT id="hdnFieldTemplateList" style="Z-INDEX: 102; LEFT: 387px; POSITION: absolute; TOP: 605px" type="hidden" name="hdnFieldTemplateList" runat="server"></form>
		<SCRIPT>
			var content = document.all["txtBody"];
			var DHTMLSafe=document.all["DHTMLSafe1"];

			function beforeSubmit(){
				var content = document.all["txtBody"];
				var DHTMLSafe=document.all["DHTMLSafe1"];
				var cont = DHTMLSafe.DOM.body.innerHTML;
				
				if(cont.length) {
					cont = DHTMLSafe.FilterSourceCode(cont);
				}
				content.value=cont;
				__doPostBack('btnSave', '');
				return false;
			}

			function FillEditor(){
				if(DHTMLSafe.Busy){
					setTimeout("FillEditor();",100);	
					return;
				}
				
				DHTMLSafe.DOM.body.innerHTML = content.value;
 				set_tbstates(1);
			 	
 				SetContextMenu();
			}

			DHTMLSafe.NewDocument();

			FillEditor();

		</SCRIPT>
	</body>
</HTML>
