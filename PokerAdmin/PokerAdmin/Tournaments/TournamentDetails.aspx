<%@ Page language="c#" Codebehind="TournamentDetails.aspx.cs" AutoEventWireup="false" Inherits="Admin.Tournaments.TournamentDetails" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Tournament Details</title>
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
								<TD><CBC:BUTTONIMAGE id="btnInvitedU" onclick="btnInvitedU_click" runat="server" Text="Invited Users"
										CausesValidation="false"></CBC:BUTTONIMAGE></TD>
								<td><CBC:BUTTONIMAGE id="btnCancel" onclick="bntGoBack_Click" runat="server" Text="Back" CausesValidation="false"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="center"><asp:label id="lblInfo" Runat="server" ForeColor="Red" EnableViewState="False"></asp:label></td>
				</tr>
				<tr>
					<td>
						<table class="cssReport cssTextMain" borderColor="#3399ff" cellSpacing="0" cellPadding="2"
							width="100%" align="center" border="1">
							<TBODY>
								<TR>
									<TD>Game Engine</TD>
									<TD align="left"><asp:dropdownlist id="comboEngine" Runat="server" AutoPostBack="True"></asp:dropdownlist></TD>
									<td><CBC:BUTTONIMAGE id="btnPrize1" onclick="btnPrize1_Click" runat="server" Text="Prize 1"></CBC:BUTTONIMAGE></td>
									<td><CBC:BUTTONIMAGE id="btnPrize2" onclick="btnPrize2_Click" runat="server" Text="Prize 2"></CBC:BUTTONIMAGE></td>
								</TR>
								<tr>
									<td>Action Dispatcher</td>
									<TD align="left"><asp:dropdownlist id="comboActDisp" Runat="server" AutoPostBack="True"></asp:dropdownlist></TD>
									<td colSpan="2" align="left"><CBC:BUTTONIMAGE id="btnBettings" onclick="btnBettings_Click" runat="server" Text="Bettings"></CBC:BUTTONIMAGE></td>
								</tr>
								<TR>
									<TD align="center" colSpan="4">
										<FIELDSET style="BORDER-LEFT-COLOR: #3399ff; BORDER-BOTTOM-COLOR: #3399ff; BORDER-TOP-STYLE: solid; BORDER-TOP-COLOR: #3399ff; BORDER-RIGHT-STYLE: solid; BORDER-LEFT-STYLE: solid; BORDER-RIGHT-COLOR: #3399ff; BORDER-BOTTOM-STYLE: solid"><LEGEND align="center">Tournament 
												Properties</LEGEND><asp:table id="table" runat="server" EnableViewState="False" CellPadding="0" CellSpacing="5"
												CssClass="cssReport cssTextMain cssTextAlignLeft" BorderColor="#3399FF"></asp:table></FIELDSET>
									</TD>
								</TR>
							</TBODY>
						</table>
					</td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER><input id="hdnTournamentID" type="hidden" name="hdnTournamentID" runat="server">
		</form>
	</body>
</HTML>
