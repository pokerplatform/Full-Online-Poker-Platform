<%@ Control Language="c#" AutoEventWireup="false" Codebehind="GameHistory.ascx.cs" Inherits="Admin.Transactions.GameHistory" TargetSchema="http://schemas.microsoft.com/intellisense/ie5"%>
<SCRIPT language="JavaScript" id="clientEventHandlersJS" src="../DHTML/include/dhtmled.js"></SCRIPT>
<SCRIPT language="JavaScript" id="clientEventHandlersJS1" src="../DHTML/include/editjs.js"></SCRIPT>
<table>
	<tr>
		<td align="center"><asp:Label id="lblName" runat="server"></asp:Label></td>
	</tr>
	<TR>
		<TD align="center">
			<OBJECT id="DHTMLSafe1" style="Z-INDEX: 1" height="400" width="600" classid="clsid:2D360201-FFF5-11d1-8D03-00A0C959BC0A"
				VIEWASTEXT>
				<PARAM NAME="ActivateApplets" VALUE="0">
				<PARAM NAME="ActivateActiveXControls" VALUE="0">
				<PARAM NAME="ActivateDTCs" VALUE="-1">
				<PARAM NAME="ShowDetails" VALUE="0">
				<PARAM NAME="ShowBorders" VALUE="0">
				<PARAM NAME="Appearance" VALUE="1">
				<PARAM NAME="Scrollbars" VALUE="-1">
				<PARAM NAME="ScrollbarAppearance" VALUE="0">
				<PARAM NAME="SourceCodePreservation" VALUE="0">
				<PARAM NAME="AbsoluteDropMode" VALUE="0">
				<PARAM NAME="SnapToGrid" VALUE="0">
				<PARAM NAME="SnapToGridX" VALUE="50">
				<PARAM NAME="SnapToGridY" VALUE="50">
				<PARAM NAME="UseDivOnCarriageReturn" VALUE="0">
			</OBJECT>
		</TD>
	</TR>
	<tr>
		<td></td>
	</tr>
</table>
<INPUT id="hdnLogData" type="hidden" name="hdnLogData" runat="server">
<SCRIPT>
			var content = document.all["gameHistory:hdnLogData"];
			var DHTMLSafe=document.all["DHTMLSafe1"];

			function FillEditor(){
				if(DHTMLSafe.Busy){
					setTimeout("FillEditor();",100);	
					return;
				}
				
				DHTMLSafe.DOM.body.innerHTML = content.value;
			}

			DHTMLSafe.NewDocument();
			FillEditor();
</SCRIPT>
