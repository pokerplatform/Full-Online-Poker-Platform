<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Page language="c#" Codebehind="GameDetails.aspx.cs" AutoEventWireup="false" Inherits="Admin.Games.GameDetails" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Game Details</title>
		<meta content="False" name="vs_showGrid">
		<meta content="Microsoft Visual Studio 7.0" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="UserDetails" method="post" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="60%" align="center" border="0">
				<tr>
					<td>
						<table align="center">
							<tr>
								<td><CBC:BUTTONIMAGE id="btnSave" onclick="btnSave_Click" runat="server" Text="Save"></CBC:BUTTONIMAGE></td>
								<td><CBC:BUTTONIMAGE id="btnCancel" onclick="bntGoBack_Click" runat="server" Text="Back" CausesValidation="false"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="middle"><asp:label id="lblInfo" EnableViewState="False" ForeColor="Red" Runat="server"></asp:label></td>
				</tr>
				<tr>
					<td>
						<table class="cssReport cssTextMain" borderColor="#3399ff" cellSpacing="0" cellPadding="2" width="100%" align="center" border="1">
							<tr>
								<td>
									<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ErrorMessage="Enter " ControlToValidate="txtName" Display="Dynamic"></asp:RequiredFieldValidator>Name</td>
								<td align="left"><asp:textbox id="txtName" Runat="server" MaxLength="50"></asp:textbox></td>
							</tr>
							<TR>
								<TD>Com Object</TD>
								<TD align="left"><asp:dropdownlist id="comboComName" Runat="server">
										<asp:ListItem Value="poPokerGameEngine.PokerGameEngine">poPokerGameEngine.PokerGameEngine</asp:ListItem>
										<asp:ListItem Value="Test">Test</asp:ListItem>
									</asp:dropdownlist>
									<asp:Label id="lblComName" runat="server"></asp:Label></TD>
							</TR>
							<TR>
								<TD>Version</TD>
								<TD align="left">
									<asp:Label id="lblVersion" runat="server"></asp:Label></TD>
							</TR>
						</table>
					</td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER><input id="hdnGameEngineID" type="hidden" name="hdnGameEngineID" runat="server">
		</form>
	</body>
</HTML>
