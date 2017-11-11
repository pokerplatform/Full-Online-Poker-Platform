<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Page language="c#" Codebehind="TournamentBettings.aspx.cs" AutoEventWireup="false" Inherits="Admin.Tournaments.TournamentBettings" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Tournament Bettings</title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="Form1" method="post" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="60%" align="center" border="0">
				<tr>
					<td align="center">
						<table>
							<tr>
								<td><CBC:BUTTONIMAGE id="btnAdd" onclick="btnAdd_Click" runat="server" Text="Add"></CBC:BUTTONIMAGE></td>
								<td><CBC:BUTTONIMAGE id="btnSaveBet" onclick="btnSaveBet_Click" runat="server" Text="Save"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<TR>
					<TD align="center">
						<TABLE cellSpacing="0" cellPadding="2">
							<TR>
								<TD><nobr>Copy from Tournament Bettings Template</nobr></TD>
								<TD><asp:dropdownlist id="comboTemplate" Runat="server"></asp:dropdownlist></TD>
								<TD><CBC:BUTTONIMAGE id="btnCopy" onclick="btnCopy_Click" runat="server" Text="Copy"></CBC:BUTTONIMAGE></TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
				<tr>
					<td align="center">
						Coefficient:
						<asp:TextBox id="txtCoeff" runat="server"></asp:TextBox>
					</td>
				</tr>
				<tr>
					<td align="center">
						<asp:datagrid id="oGrid" runat="server" CssClass="cssReport cssTextMain" BorderColor="#3399FF"
							CellPadding="2" HorizontalAlign="Center" AutoGenerateColumns="False">
							<AlternatingItemStyle CssClass="cssReportItemOdd"></AlternatingItemStyle>
							<ItemStyle CssClass="cssReportItem"></ItemStyle>
							<HeaderStyle CssClass="cssReportHeader"></HeaderStyle>
							<Columns>
								<asp:BoundColumn DataField="level" ReadOnly="True" HeaderText="Level"></asp:BoundColumn>
								<asp:BoundColumn DataField="blind" HeaderText="Blind"></asp:BoundColumn>
								<asp:BoundColumn DataField="ante" HeaderText="Ante"></asp:BoundColumn>
								<asp:EditCommandColumn ButtonType="PushButton" UpdateText="Update" CancelText="Cancel" EditText="Edit"></asp:EditCommandColumn>
								<asp:ButtonColumn Text="Delete" ButtonType="PushButton" CommandName="Delete"></asp:ButtonColumn>
							</Columns>
						</asp:datagrid>
					</td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER>
		</form>
	</body>
</HTML>
