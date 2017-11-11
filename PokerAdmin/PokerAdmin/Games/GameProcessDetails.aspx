<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Page language="c#" Codebehind="GameProcessDetails.aspx.cs" AutoEventWireup="false" Inherits="Admin.Games.GameProcessDetails" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title>Game Process Details</title>
		<meta content="False" name="vs_showGrid">
		<meta content="Microsoft Visual Studio 7.0" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
  </HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="UserDetails" method="post" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="70%" align="center" border="0">
				<tr>
					<td>
						<table align="center">
							<tr>
								<td><CBC:BUTTONIMAGE id="btnSave" onclick="btnSave_Click" runat="server" Text="Save"></CBC:BUTTONIMAGE></td>
								<TD><CBC:BUTTONIMAGE id="btnInvitedU" onclick="btnInvitedU_click" runat="server" Text="Invited Users"
										CausesValidation="false"></CBC:BUTTONIMAGE></TD>
								<TD><CBC:BUTTONIMAGE id="btnReInit" onclick="btnReInit_click" runat="server" Text="ReInit" CausesValidation="false"></CBC:BUTTONIMAGE></TD>
								<td><CBC:BUTTONIMAGE id="btnCancel" onclick="bntGoBack_Click" runat="server" Text="Back" CausesValidation="false"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="center"><asp:label id="lblInfo" EnableViewState="False" ForeColor="Red" Runat="server"></asp:label></td>
				</tr>
				<tr>
					<td>
						<table class="cssReport cssTextMain" borderColor="#3399ff" cellSpacing="0" cellPadding="2"
							width="100%" align="center" border="1">
							<tr>
								<td width="40%">Engine</td>
								<td align="left"><asp:dropdownlist id="comboEngine" Runat="server" AutoPostBack="True"></asp:dropdownlist></td>
							</tr>
							<tr>
								<td><asp:requiredfieldvalidator id="RequiredFieldValidator1" runat="server" ErrorMessage="Enter " ControlToValidate="txtName"
										Display="Dynamic"></asp:requiredfieldvalidator>Name</td>
								<td align="left"><asp:textbox id="txtName" Runat="server" MaxLength="50"></asp:textbox></td>
							</tr>
							<TR>
								<TD>Currency</TD>
								<TD align="left"><asp:dropdownlist id="comboCurrency" Runat="server"></asp:dropdownlist></TD>
							</TR>
							<TR>
								<TD>SubCategory</TD>
								<TD align="left"><asp:dropdownlist id="comboSubCategory" Runat="server"></asp:dropdownlist></TD>
							</TR>
							<TR>
								<TD>Action Dispatcher</TD>
								<TD align="left"><asp:dropdownlist id="comboActDisp" Runat="server"></asp:dropdownlist></TD>
							</TR>
							<TR>
								<TD><asp:requiredfieldvalidator id="RequiredFieldValidator2" runat="server" ErrorMessage="Enter" ControlToValidate="txtActivatedTime"></asp:requiredfieldvalidator>Activated 
									Time</TD>
								<TD align="left"><asp:textbox id="txtActivatedTime" runat="server"></asp:textbox></TD>
							</TR>
							<TR>
								<TD>Protected Code</TD>
								<TD align="left"><asp:textbox id="txtProtCode" runat="server" MaxLength="50"></asp:textbox></TD>
							</TR>
        <TR>
          <TD>Reward</TD>
          <TD align=left>
<asp:textbox id=txtReward runat="server" MaxLength="50"></asp:textbox></TD></TR>
							<TR>
								<TD>Visible</TD>
								<TD align="left"><asp:checkbox id="chVisible" runat="server"></asp:checkbox></TD>
							</TR>
							<TR>
								<TD>Creator</TD>
								<TD align="left"><asp:textbox id="txtCreator" runat="server" ReadOnly="True"></asp:textbox></TD>
							</TR>
							<TR>
								<TD>Protected Mode</TD>
								<TD align="left"><asp:dropdownlist id="ddProtectedM" runat="server">
										<asp:ListItem Value="0">Regular table</asp:ListItem>
										<asp:ListItem Value="1">Private table</asp:ListItem>
										<asp:ListItem Value="2">Rewarded table</asp:ListItem>
									</asp:dropdownlist></TD>
							</TR>
							<TR>
								<TD>Highlighted Mode</TD>
								<TD align="left"><asp:dropdownlist id="ddHighlightedM" runat="server">
										<asp:ListItem Value="0">Regular table</asp:ListItem>
										<asp:ListItem Value="1">Highlighted table</asp:ListItem>
									</asp:dropdownlist></TD>
							</TR>
							<TR>
								<TD>Mass Watching Allowed
								</TD>
								<TD align="left"><asp:dropdownlist id="ddMassWatchingAllowed" runat="server">
										<asp:ListItem Value="0">Limited watchers...</asp:ListItem>
										<asp:ListItem Value="1">Table is available for mass watching using Watching Web Service</asp:ListItem>
									</asp:dropdownlist></TD>
							</TR>
							<TR>
								<TD align="center" colSpan="2">
									<FIELDSET style="BORDER-LEFT-COLOR: #3399ff; BORDER-BOTTOM-COLOR: #3399ff; BORDER-TOP-STYLE: solid; BORDER-TOP-COLOR: #3399ff; BORDER-RIGHT-STYLE: solid; BORDER-LEFT-STYLE: solid; BORDER-RIGHT-COLOR: #3399ff; BORDER-BOTTOM-STYLE: solid"><LEGEND align="center">Game 
											Engine Properties</LEGEND><asp:table id="table" runat="server" EnableViewState="False" BorderColor="#3399FF" CssClass="cssReport cssTextMain cssTextAlignLeft"
											CellSpacing="5" CellPadding="0"></asp:table></FIELDSET>
								</TD>
							</TR>
						</table>
					</td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER><input id="hdnGameProcessID" type="hidden" name="hdnGameProcessID" runat="server">
		</form>
	</body>
</HTML>
