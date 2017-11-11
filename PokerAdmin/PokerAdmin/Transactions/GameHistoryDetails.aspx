<%@ Page language="c#" Codebehind="GameHistoryDetails.aspx.cs" AutoEventWireup="false" Inherits="Admin.Transactions.GameHistoryDetails" %>
<%@ Register TagPrefix="uc1" TagName="GameHistory" Src="GameHistory.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Game History Details</title>
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
					<td align="center"><CBC:BUTTONIMAGE id="btnCancel" NavigateUrl="javascript:history.go(-1)" runat="server" Text="Back"
							CausesValidation="false"></CBC:BUTTONIMAGE></td>
				</tr>
				<tr>
					<td align="center">
						<br>
						<asp:Panel id="pnHandId" runat="server" Width="100%" BorderColor="#3399FF" BorderWidth="1">
							<TABLE>
								<TR>
									<TD align="right">
										<asp:Label id="Label1" runat="server">Hand ID&nbsp;</asp:Label>
										<asp:TextBox id="txtHndID" runat="server"></asp:TextBox></TD>
									<TD align="left">
										<CBC:BUTTONIMAGE id="btGoHand" onclick="btGoHand_Click" runat="server" CausesValidation="false" Text="Go"></CBC:BUTTONIMAGE></TD>
								</TR>
							</TABLE>
						</asp:Panel>
					</td>
				</tr>
				<TR>
					<TD align="center">
						<asp:Label id="lblInfo" runat="server" ForeColor="Red"></asp:Label></TD>
				</TR>
				<tr>
					<td align="center">
						<P>
							<uc1:GameHistory id="gameHistory" runat="server"></uc1:GameHistory></P>
					</td>
				</tr>
				<TR>
					<TD align="center">
						<CBC:BUTTONIMAGE id="btnPlay" onclick="btnPlay_click" runat="server" CausesValidation="false" Text="Play Game"></CBC:BUTTONIMAGE>
					</TD>
				</TR>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER><input id="hdnGameLogID" type="hidden" name="hdnGameLogID" runat="server">
		</form>
	</body>
</HTML>
