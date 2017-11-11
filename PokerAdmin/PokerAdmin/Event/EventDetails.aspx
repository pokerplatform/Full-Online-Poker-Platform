<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Page language="c#" Codebehind="EventDetails.aspx.cs" AutoEventWireup="false" Inherits="Admin.Event.EventDetails" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>BuddyWager Event Details</title>
		<meta content="Microsoft Visual Studio 7.0" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<SCRIPT language="JavaScript" id="clientEventPrototypeJS" src="event.js"></SCRIPT>
		<script>
			var SubCategoryID = 0;
			var AwayTeamID = 0;
			var HomeTeamID = 0;
			var StartDate = '';
			var StartTime = '';
			
			var PointHomeSpread = '';
			var PointHomeSpreadHalf = '';
			var PointOu = '';
			var PointOuHalf = '';
			var PointMLHome = '';
			
			var DisplayResult = 0;
		</script>
	</HEAD>
	<body>
		<form id="EventDetails" method="post" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="80%" align="center" border="0">
				<tr>
					<td>
						<table align="center">
							<tr>
								<td><CBC:BUTTONIMAGE id="btnSave" onclick="btnSave_Click" runat="server" Text="Save"></CBC:BUTTONIMAGE></td>
								<td><CBC:BUTTONIMAGE id="btnConfirm" onclick="btnConfirm_Click" runat="server" Text="Go For Birds"></CBC:BUTTONIMAGE></td>
								<TD><CBC:BUTTONIMAGE id="btnProcess" onclick="btnProcess_Click" runat="server" Text="Process"></CBC:BUTTONIMAGE></TD>
								<td><CBC:BUTTONIMAGE id="btnCancel" onclick="bntGoBack_Click" runat="server" Text="Back" CausesValidation="false"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="center"><asp:label id="lblInfo" Runat="server" ForeColor="Red" EnableViewState="False"></asp:label><asp:comparevalidator id="CompareValidator1" runat="server" ControlToValidate="comboAway" Display="Dynamic"
							ErrorMessage="CompareValidator" ControlToCompare="comboHome" Operator="NotEqual">Home and Away Teams should be different</asp:comparevalidator></td>
				</tr>
				<tr>
					<td>
						<table class="cssReport cssTextMain" borderColor="#3399ff" cellSpacing="0" cellPadding="2"
							width="100%" align="center" border="1">
							<tr>
								<td>Event Category</td>
								<td align="left"><asp:dropdownlist id="comboCategory" Runat="server"></asp:dropdownlist></td>
							</tr>
							<tr>
								<td><asp:requiredfieldvalidator id="RequiredFieldValidator1" runat="server" ControlToValidate="comboSubCategory"
										Display="Dynamic" ErrorMessage="RequiredFieldValidator">Enter</asp:requiredfieldvalidator>Event 
									SubCategory</td>
								<td align="left"><asp:dropdownlist id="comboSubCategory" Runat="server" EnableViewState="False"></asp:dropdownlist></td>
							</tr>
							<TR>
								<TD><asp:requiredfieldvalidator id="RequiredFieldValidator3" runat="server" ControlToValidate="comboAway" Display="Dynamic"
										ErrorMessage="RequiredFieldValidator">Enter</asp:requiredfieldvalidator>Home</TD>
								<td align="left">
									<table class="cssTextMain" cellSpacing="0" cellPadding="0" width="100%">
										<tr>
											<td align="left"><asp:dropdownlist id="comboHome" Runat="server" EnableViewState="False"></asp:dropdownlist></td>
											<td width="30"><asp:label id="lblHomeScore" runat="server"> Score: </asp:label></td>
											<td width="60"><asp:textbox id="txtHomeScore" Runat="server" CssClass="cssTextAlignRight" Width="60px" MaxLength="50"></asp:textbox></td>
											<td width="59" style="WIDTH: 59px"><asp:label id="lblHomeScoreHalf" runat="server" CssClass="cssDisplayNone"><nobr>
														Half-Time</nobr><br>Score: </asp:label></td>
											<td width="60"><asp:textbox id="txtHomeScoreHalf" Runat="server" CssClass="cssDisplayNone cssTextAlignRight"
													Width="60px" MaxLength="50"></asp:textbox></td>
										</tr>
									</table>
								</td>
							</TR>
							<tr>
								<td width="30%"><asp:requiredfieldvalidator id="RequiredFieldValidator2" runat="server" ControlToValidate="comboHome" Display="Dynamic"
										ErrorMessage="RequiredFieldValidator">Enter</asp:requiredfieldvalidator>Away</td>
								<td align="left">
									<table class="cssTextMain" cellSpacing="0" cellPadding="0" width="100%">
										<tr>
											<td align="left"><asp:dropdownlist id="comboAway" Runat="server" EnableViewState="False"></asp:dropdownlist></td>
											<td width="30"><asp:label id="lblAwayScore" runat="server"> Score: </asp:label></td>
											<td width="60"><asp:textbox id="txtAwayScore" Runat="server" CssClass="cssTextAlignRight" Width="60px" MaxLength="50"></asp:textbox></td>
											<td width="60"><asp:label id="lblAwayScoreHalf" runat="server" CssClass="cssDisplayNone"><nobr>
														Half-Time</nobr><br>Score: </asp:label></td>
											<td width="60"><asp:textbox id="txtAwayScoreHalf" Runat="server" CssClass="cssDisplayNone cssTextAlignRight"
													Width="60px" MaxLength="50"></asp:textbox></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td><nobr>Event Date</nobr></td>
								<td align="left"><asp:dropdownlist id="comboDate" Runat="server" EnableViewState="False"></asp:dropdownlist></td>
							</tr>
							<tr>
								<td>Event Time</td>
								<td align="left"><asp:dropdownlist id="comboTime" Runat="server" EnableViewState="False"></asp:dropdownlist></td>
							</tr>
							<TR>
								<TD align="center" colSpan="2">Outcomes
									<table class="cssReport100 cssTextMain" borderColor="#3399ff" cellSpacing="0" cellPadding="2"
										width="100%" align="center" border="1">
										<TR>
											<TD align="center" width="30%">Name</TD>
											<TD align="center">Play Money</TD>
											<TD align="center">Price</TD>
											<TD id="Result0" align="center" width="15%">Result</TD>
										</TR>
										<TR>
											<TD width="30%">Home Team Spread</TD>
											<TD align="center"><asp:dropdownlist id="comboHomeSpread" Runat="server" EnableViewState="False" Width="100%"></asp:dropdownlist><INPUT id="hdnResultHomeSpread" type="hidden" name="hdnResultHomeSpread" runat="server"></TD>
											<TD align="center"><asp:textbox id="txtHomeSpread" Runat="server" Width="100%" MaxLength="50"></asp:textbox></TD>
											<TD id="Result1" align="center"></TD>
										</TR>
										<TR style="DISPLAY: none">
											<TD width="30%">Home Team Half-Time Spread</TD>
											<TD align="center"><asp:dropdownlist id="comboHomeSpreadHalf" Runat="server" EnableViewState="False" Width="100%"></asp:dropdownlist><INPUT id="hdnResultHomeSpreadHalf" type="hidden" name="hdnResultHomeSpreadHalf" runat="server"></TD>
											<TD align="center"><asp:textbox id="txtHomeSpreadHalf" Runat="server" Width="100%" MaxLength="50"></asp:textbox></TD>
											<TD id="Result2" align="center"></TD>
										</TR>
										<TR>
											<TD width="30%">Event Total O/U</TD>
											<td align="center"><asp:dropdownlist id="comboTotalOU" Runat="server" EnableViewState="False" Width="100%"></asp:dropdownlist><INPUT id="hdnResultTotalOU" type="hidden" name="hdnResultTotalOU" runat="server"></td>
											<TD align="center"><asp:textbox id="txtTotalOU" Runat="server" Width="100%" MaxLength="50"></asp:textbox></TD>
											<TD id="Result3" align="center"></TD>
										</TR>
										<TR style="DISPLAY: none">
											<TD width="30%">Event Half-Time Total O/U</TD>
											<TD align="center"><asp:dropdownlist id="comboTotalOUHalf" Runat="server" EnableViewState="False" Width="100%"></asp:dropdownlist><INPUT id="hdnResultTotalOUHalf" type="hidden" name="hdnResultHomeSpread" runat="server"></TD>
											<TD align="center"><asp:textbox id="txtTotalOUHalf" Runat="server" Width="100%" MaxLength="50"></asp:textbox></TD>
											<TD id="Result4" align="center"></TD>
										</TR>
										<TR>
											<TD width="30%">Home Team M/L</TD>
											<TD align="center"><asp:dropdownlist id="comboHomeTeam" Runat="server" EnableViewState="False" Width="100%">
													<asp:ListItem Selected="True">-Select-</asp:ListItem>
													<asp:ListItem Value="1">Play</asp:ListItem>
												</asp:dropdownlist><INPUT id="hdnResultHomeML" type="hidden" name="hdnResultHomeML" runat="server">
												<INPUT id="hdnResultAwayML" type="hidden" name="hdnResultAwayML" runat="server"></TD>
											<TD align="center"><asp:textbox id="txtHomeTeam" Runat="server" Width="100%" MaxLength="50"></asp:textbox></TD>
											<TD id="Result5" align="center"></TD>
										</TR>
									</table>
								</TD>
							</TR>
						</table>
					</td>
				</tr>
			</table>
			<P><CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER><input id="hdnEventID" type="hidden" runat="server">&nbsp;&nbsp;<INPUT id="hdnStateID" type="hidden" name="hdnStateID" runat="server">&nbsp;
				<INPUT id="hdnGuid" type="hidden" name="hdnGuid" runat="server"></P>
			<P><INPUT id="hdnTeamList" type="hidden" name="hdnTeamList" runat="server"> <INPUT id="hdnSubCategoryList" type="hidden" name="hdnSubCategoryList" runat="server"></P>
			<P>
				<INPUT id="hdnJsInitialize" type="hidden" name="hdnJsInitialize" runat="server"></P>
		</form>
		<script>
			//-----Result constants and bet types -----------------------
			var resultNothing  = 0;  //artificial value that doesn't present in database
			var resultWaiting  = 1;
			var resultPositive = 2;
			var resultNegative = 3;
			var resultReturn   = 4;
			
			var resultWaitingText  = 'Waiting for result';
			var resultPositiveText = 'Positive result';
			var resultNegativeText = 'Negative result';
			var resultReturnText   = 'Return';
			
			var typeML        = 1;
			var typeSpread    = 2;
			var typeOverUnder = 3;
			
		
			//-- Combo Boxes initialization and filling
			var CategoryObj       = document.all["comboCategory"];
			var SubCategoryObj    = document.all["comboSubCategory"];
			var hdnSubCategoryObj = document.all["hdnSubCategoryList"];
	
			var HomeObj    = document.all["comboHome"];
			var AwayObj    = document.all["comboAway"];
			var hdnTeamObj = document.all["hdnTeamList"];

			var DateObj = document.all["comboDate"];
			var TimeObj = document.all["comboTime"];
			
			var homeScoreObj = document.all["txtHomeScore"];
			var awayScoreObj = document.all["txtAwayScore"];
			var homeScoreHalfObj = document.all["txtHomeScoreHalf"];
			var awayScoreHalfObj = document.all["txtAwayScoreHalf"];


			//-- Table fields
			var resultHomeSpreadObj = document.all["hdnResultHomeSpread"];
			var resultHomeSpreadHalfObj = document.all["hdnResultHomeSpreadHalf"];
			var resultTotalOUObj = document.all["hdnResultTotalOU"];
			var resultTotalOUHalfObj = document.all["hdnResultTotalOUHalf"];
			var resultHomeMLObj = document.all["hdnResultHomeML"];
			var resultAwayMLObj = document.all["hdnResultAwayML"];

			var pointHomeSpreadObj = document.all["comboHomeSpread"];
			var pointHomeSpreadHalfObj = document.all["comboHomeSpreadHalf"];
			var pointTotalOUObj = document.all["comboTotalOU"];
			var pointTotalOUHalfObj = document.all["comboTotalOUHalf"];
			var pointHomeMLObj = document.all["comboHomeTeam"];
			
			
			//-- set values in comboBoxes and more
			SetDefaultValues();
			
			//-----Show/Hide Process fields-------------------------
			DisplayValueRow();
			function DisplayValueRow()
			{
				if (parseInt(DisplayResult)==0) bShow = false
				else  bShow = true;
				DisplayObject(bShow, document.all.Result0, null);
				DisplayObject(bShow, document.all.Result1, resultHomeSpreadObj);
				DisplayObject(bShow, document.all.Result2, resultHomeSpreadHalfObj);
				DisplayObject(bShow, document.all.Result3, resultTotalOUObj);
				DisplayObject(bShow, document.all.Result4, resultTotalOUHalfObj);
				DisplayObject(bShow, document.all.Result5, resultHomeMLObj);
			}
			
			
			//--- Confirmation for buttons Confirm and Save
			function getConfirm()
			{
				if (confirm('Are you sure?'))
				{
					__doPostBack('btnConfirm', '');
				}
				return false;
			}
			
			function getProcess()
			{
				if (HasMissedResult()) return false;
				if (confirm('Are you sure?'))
				{
					__doPostBack('btnProcess', '');
				}
				return false;
			}
			

		</script>
	</body>
</HTML>
