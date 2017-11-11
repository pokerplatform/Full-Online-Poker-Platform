<%@ Register TagPrefix="uc1" TagName="TournamentHistory" Src="../Tournaments/TournamentHistory.ascx" %>
<%@ Page language="c#" Codebehind="TxHistoryDetails.aspx.cs" AutoEventWireup="false" Inherits="Admin.Transactions.TxHistoryDetails" %>
<%@ Register TagPrefix="uc1" TagName="GameHistory" Src="GameHistory.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Transaction History Details</title>
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
					<td align="middle"><CBC:BUTTONIMAGE id="btnCancel" NavigateUrl="javascript:history.go(-1)" runat="server" Text="Back" CausesValidation="false"></CBC:BUTTONIMAGE></td>
				</tr>
				<TR>
					<TD align="middle">
						<asp:Label id="lblInfo" runat="server"></asp:Label></TD>
				</TR>
				<tr>
					<td align="middle">
						<TABLE class="cssReport cssTextMain" id="Table1" borderColor="#3399ff" cellSpacing="0" cellPadding="2" width="100%" align="center" border="1">
							<TR>
								<TD>User</TD>
								<TD align="left">
									<asp:TextBox id="txtUser" runat="server" ReadOnly="True" Width="200px"></asp:TextBox></TD>
								<TD align="left">Amount</TD>
								<TD align="left">
									<asp:TextBox id="txtAmount" runat="server" ReadOnly="True" Width="200px"></asp:TextBox></TD>
							</TR>
							<TR>
								<TD>Transaction Type</TD>
								<TD align="left">
									<asp:TextBox id="txtType" runat="server" ReadOnly="True" Width="200px"></asp:TextBox></TD>
								<TD align="left">Date</TD>
								<TD align="left">
									<asp:TextBox id="txtDate" runat="server" ReadOnly="True" Width="200px"></asp:TextBox></TD>
							</TR>
							<TR>
								<TD>Document</TD>
								<TD align="left" colSpan="3">
									<asp:textbox id="txtDocument" ReadOnly="True" Columns="60" Rows="3" TextMode="MultiLine" MaxLength="1000" Runat="server"></asp:textbox></TD>
							</TR>
							<TR>
								<TD align="middle" colSpan="4">
									<FIELDSET style="BORDER-LEFT-COLOR: #3399ff; BORDER-BOTTOM-COLOR: #3399ff; BORDER-TOP-STYLE: solid; BORDER-TOP-COLOR: #3399ff; BORDER-RIGHT-STYLE: solid; BORDER-LEFT-STYLE: solid; BORDER-RIGHT-COLOR: #3399ff; BORDER-BOTTOM-STYLE: solid"><LEGEND align="center">Transaction 
											Details</LEGEND>
										<uc1:GameHistory id="gameHistory" runat="server" Visible="False"></uc1:GameHistory>
										<uc1:TournamentHistory id="tournamentHistory" runat="server" Visible="False"></uc1:TournamentHistory>
										<asp:Label id="lblNothing" runat="server" Visible="False" CssClass="cssTextBig">No details available</asp:Label></FIELDSET>
								</TD>
							</TR>
						</TABLE>
					</td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER><input id="hdnTxID" type="hidden" name="hdnTxID" runat="server">
		</form>
	</body>
</HTML>
