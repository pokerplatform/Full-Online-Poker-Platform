<%@ Page language="c#" Codebehind="UserDetailsAccount.aspx.cs" AutoEventWireup="false" Inherits="Admin.Users.UserDetailsAccount" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>User Account Details</title>
		<meta content="False" name="vs_showGrid">
		<meta content="Microsoft Visual Studio 7.0" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="UserAccountDetails" method="post" runat="server">
			<INPUT id="hdnAccountID" style="Z-INDEX: 102; LEFT: 320px; POSITION: absolute; TOP: 736px"
				type="hidden" name="hdnAccountID" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="60%" align="center" border="0">
				<tr>
					<td>
						<table align="center">
							<tr>
								<td><CBC:BUTTONIMAGE id="btnCancel" runat="server" Text="Back" CausesValidation="false" NavigateUrl="javascript:history.go(-1)"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="center"><asp:label id="lblInfo" Runat="server" ForeColor="Red" EnableViewState="False"></asp:label></td>
				</tr>
				<TR>
					<TD align="center"><asp:label id="lblUserName" runat="server"></asp:label></TD>
				</TR>
				<tr>
					<td>
						<table class="cssReport cssTextMain" borderColor="#3399ff" cellSpacing="0" cellPadding="2"
							width="100%" align="center" border="1">
							<tr>
								<td>Currency</td>
								<td align="left"><asp:dropdownlist id="comboCurrency" Runat="server" AutoPostBack="True"></asp:dropdownlist></td>
							</tr>
							<TR>
								<TD>Balance</TD>
								<TD align="left"><asp:label id="lblBalance" runat="server"></asp:label></TD>
							</TR>
							<TR>
								<TD>Today Deposit</TD>
								<TD align="left"><asp:label id="lblTodayDeposit" runat="server"></asp:label></TD>
							</TR>
							<TR>
								<TD>This Week Deposit</TD>
								<TD align="left"><asp:label id="lblWeekDeposit" runat="server"></asp:label></TD>
							</TR>
							<tr>
								<td>This Month Deposit</td>
								<td align="left"><asp:label id="lblMonthDeposit" runat="server"></asp:label></td>
							</tr>
						</table>
					</td>
				</tr>
				<TR>
					<TD>&nbsp;</TD>
				</TR>
				<TR>
					<TD align="center">
						<FIELDSET style="BORDER-LEFT-COLOR: #3399ff; BORDER-BOTTOM-COLOR: #3399ff; BORDER-TOP-STYLE: solid; BORDER-TOP-COLOR: #3399ff; BORDER-RIGHT-STYLE: solid; BORDER-LEFT-STYLE: solid; BORDER-RIGHT-COLOR: #3399ff; BORDER-BOTTOM-STYLE: solid"><LEGEND align="center">Account 
								Changes</LEGEND>
							<TABLE class="cssReport cssTextMain" id="Table1" borderColor="#3399ff" cellSpacing="0"
								cellPadding="2" align="center" border="0">
								<TR>
									<TD>Add To Balance</TD>
									<TD align="left"><asp:textbox id="txtAmount" runat="server" CssClass="cssTextAlignRight"></asp:textbox></TD>
								</TR>
								<TR>
									<TD>Reason</TD>
									<TD align="left"><asp:textbox id="txtReason" runat="server" Columns="40" Rows="4" TextMode="MultiLine"></asp:textbox></TD>
								</TR>
								<TR>
									<TD align="center" colSpan="2"><CBC:BUTTONIMAGE id="btnSave" onclick="btnSave_click" runat="server" Text="Save"></CBC:BUTTONIMAGE></TD>
								</TR>
							</TABLE>
						</FIELDSET>
					</TD>
				</TR>
				<TR>
					<TD align="center">
						<FIELDSET style="BORDER-LEFT-COLOR: #3399ff; BORDER-BOTTOM-COLOR: #3399ff; BORDER-TOP-STYLE: solid; BORDER-TOP-COLOR: #3399ff; BORDER-RIGHT-STYLE: solid; BORDER-LEFT-STYLE: solid; BORDER-RIGHT-COLOR: #3399ff; BORDER-BOTTOM-STYLE: solid"><LEGEND align="center">Transfers 
								between accounts</LEGEND>
							<TABLE class="cssReport cssTextMain" id="Table2" borderColor="#3399ff" cellSpacing="0"
								cellPadding="2" align="center" border="0">
								<tr>
									<td>Transfer to User (login name)
									</td>
									<td align="left"><asp:textbox id="txtUser" runat="server" CssClass="cssTextAlignRight"></asp:textbox></td>
								</tr>
								<TR>
									<TD>Amount</TD>
									<TD align="left"><asp:textbox id="txtAmountTr" runat="server" CssClass="cssTextAlignRight"></asp:textbox></TD>
								</TR>
								<TR>
									<TD>Reason</TD>
									<TD align="left"><asp:textbox id="txtReasonTr" runat="server" Columns="40" Rows="4" TextMode="MultiLine"></asp:textbox></TD>
								</TR>
								<TR>
									<TD align="center" colSpan="2"><CBC:BUTTONIMAGE id="btTransfer" onclick="btnTransfer_click" runat="server" Text="Transfer"></CBC:BUTTONIMAGE></TD>
								</TR>
							</TABLE>
						</FIELDSET>
					</TD>
				</TR>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER><input id="hdnUserID" type="hidden" runat="server">
			<input id="hdnBalance" type="hidden" runat="server">
		</form>
	</body>
</HTML>
