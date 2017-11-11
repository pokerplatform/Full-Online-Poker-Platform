<%@ Page language="c#" Codebehind="EventDetailsPrototype2.aspx.cs" AutoEventWireup="false" Inherits="Admin.Event.EventDetailsPrototype2" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Sportsbokk Event Details</title>
		<meta content="Microsoft Visual Studio 7.0" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<SCRIPT language="JavaScript" id="clientEventPrototypeJS" src="eventPrototype.js"></SCRIPT>
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
								<TD><CBC:BUTTONIMAGE id="btnProcess" onclick="btnProcess_Click" runat="server" Text="Process"></CBC:BUTTONIMAGE></TD>
								<td><CBC:BUTTONIMAGE id="btnGoBack" NavigateUrl="javascript:history.go(-1)" runat="server" Text="Back" CausesValidation="false"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="middle"><asp:label id="lblInfo" Runat="server" ForeColor="Red" EnableViewState="False"></asp:label></td>
				</tr>
				<tr>
					<td>
						<table class="cssReport cssTextMain" borderColor="#3399ff" cellSpacing="0" cellPadding="2" width="100%" align="center" border="1">
							<tr>
								<td>Event Category</td>
								<td align="left"><asp:dropdownlist id="comboCategory" Runat="server"></asp:dropdownlist></td>
							</tr>
							<tr>
								<td>Event SubCategory</td>
								<td align="left"><asp:dropdownlist id="comboSubCategory" Runat="server"></asp:dropdownlist></td>
							</tr>
							<tr>
								<td width="30%">Away</td>
								<td align="left">
									<asp:dropdownlist id="comboAway" Runat="server"></asp:dropdownlist></td>
							</tr>
							<TR>
								<TD>Home</TD>
								<td align="left">
									<asp:dropdownlist id="comboHome" Runat="server"></asp:dropdownlist></td>
							</TR>
							<tr>
								<td><nobr>Event Date</nobr></td>
								<td align="left"><asp:dropdownlist id="comboDate" Runat="server"></asp:dropdownlist></td>
							</tr>
							<tr>
								<td>Event Time</td>
								<td align="left"><asp:dropdownlist id="comboTime" Runat="server"></asp:dropdownlist></td>
							</tr>
							<TR>
								<TD align="middle" colSpan="2">Outcomes
									<table class="cssReport100 cssTextMain" borderColor="#3399ff" cellSpacing="0" cellPadding="2" width="100%" align="center" border="1">
										<TR>
											<TD align="middle" width="30%">Name</TD>
											<TD align="middle">Points</TD>
											<TD align="middle">Price</TD>
											<TD align="middle" width="15%">BodyWageAllowed</TD>
										</TR>
										<TR>
											<TD width="30%">Home Team Spread</TD>
											<TD align="middle"><asp:dropdownlist id="comboHomeSpread" Runat="server" Width="100%"></asp:dropdownlist></TD>
											<TD align="middle"><asp:textbox id="txtHomeSpread" Runat="server" Width="100%" MaxLength="50"></asp:textbox></TD>
											<TD align="middle">
												<asp:CheckBox id="CheckBox1" runat="server"></asp:CheckBox></TD>
										</TR>
										<TR>
											<TD width="30%">Event Total O/U</TD>
											<td align="middle"><asp:dropdownlist id="comboTotalOU" Runat="server" Width="100%"></asp:dropdownlist></td>
											<TD align="middle"><asp:textbox id="txtTotalOU" Runat="server" Width="100%" MaxLength="50"></asp:textbox></TD>
											<TD align="middle">
												<asp:CheckBox id="CheckBox2" runat="server"></asp:CheckBox></TD>
										</TR>
										<TR>
											<TD width="30%">Home Team M/L</TD>
											<TD align="middle"></TD>
											<TD align="middle"><asp:textbox id="txtHomeTeam" Runat="server" Width="100%" MaxLength="50"></asp:textbox></TD>
											<TD align="middle" vAlign="bottom">
												<asp:CheckBox id="CheckBox3" runat="server"></asp:CheckBox></TD>
										</TR>
										<TR>
											<TD width="30%">Away&nbsp;Team M/L</TD>
											<TD align="middle"></TD>
											<TD align="middle"><asp:textbox id="txtAwayTeam" Runat="server" Width="100%" MaxLength="50"></asp:textbox></TD>
											<TD align="middle"></TD>
										</TR>
									</table>
								</TD>
							</TR>
						</table>
					</td>
				</tr>
				<TR id="rowNewsTable" runat="server">
					<TD align="middle"></TD>
				</TR>
			</table>
			<P>
				<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER><input id="hdnEventID" type="hidden" runat="server">&nbsp;
				<INPUT id="hdnSubCategoryList" type="hidden" name="hdnSubCategoryList" runat="server">
			</P>
			<P>
				<INPUT id="hdnHomeList" type="hidden" name="hdnHomeList" runat="server"> <INPUT id="hdnAwayList" type="hidden" name="hdnAwayList" runat="server"></P>
		</form>
		<script>
	var CategoryObj       = document.all["comboCategory"];
	var SubCategoryObj    = document.all["comboSubCategory"];
	var hdnSubCategoryObj = document.all["hdnSubCategoryList"]
	
	FillSubCategory();
	
	
	var HomeObj    = document.all["comboHome"];
	var hdnHomeObj = document.all["hdnHomeList"]
	var AwayObj    = document.all["comboAway"];
	var hdnAwayObj = document.all["hdnAwayList"]

	FillHome();
	FillAway();
		</script>
	</body>
</HTML>
