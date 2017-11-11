<%@ Page language="c#" Codebehind="TournamentDetailsPrize.aspx.cs" AutoEventWireup="false" Inherits="Admin.Tournaments.TournamentDetailsPrize" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Tournament Details (Prize)</title>
		<meta content="Microsoft Visual Studio 7.0" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<SCRIPT language="JavaScript" id="clientTableJS" src="../CommonUse/jsTable.js"></SCRIPT>
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="MiscMaintenance" method="post" runat="server">
			<INPUT id="hdnTournamentID" style="Z-INDEX: 101; LEFT: 178px; POSITION: absolute; TOP: 273px" type="hidden" name="hdnTournamentID" runat="server">
			<INPUT id="hdnTournamentPrizeXML" style="Z-INDEX: 102; LEFT: 348px; POSITION: absolute; TOP: 276px" type="hidden" name="hdnTournamentXML" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="100%" align="center">
				<tr>
					<td align="middle">
						<table>
							<tr>
								<td><CBC:BUTTONIMAGE id="btnSave" onclick="btnSave_click" runat="server" Text="Save"></CBC:BUTTONIMAGE></td>
								<td><CBC:BUTTONIMAGE id="btnCancel" NavigateUrl="javascript:history.go(-1)" runat="server" Text="Back" CausesValidation="false"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="middle"><asp:label id="lblInfo" Runat="server" Width="100%"></asp:label></td>
				</tr>
				<TR>
					<TD align="middle">
						<TABLE cellSpacing="0" cellPadding="2">
							<TR>
								<TD><nobr>Copy from Tournament Prize Template</nobr></TD>
								<TD><asp:dropdownlist id="comboTemplate" Runat="server"></asp:dropdownlist></TD>
								<TD><CBC:BUTTONIMAGE id="btnCopy" onclick="btnCopy_Click" runat="server" Text="Copy"></CBC:BUTTONIMAGE></TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
				<tr>
					<td align="middle"><asp:table id="table" runat="server" EnableViewState="False" CellSpacing="0" CellPadding="2" BorderColor="#3399FF" GridLines="Both" HorizontalAlign="Center" CssClass="cssTextMain"></asp:table></td>
				</tr>
				<TR>
					<TD align="middle">
						<table>
							<tr>
								<td><CBC:BUTTONIMAGE id="btnAdd" runat="server" Text="Add"></CBC:BUTTONIMAGE></td>
								<td><CBC:BUTTONIMAGE id="btnDelete" runat="server" Text="Delete"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</TD>
				</TR>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER></form>
		<script>
			var tTable = document.all["table"];
			var hdnXML = document.all["hdnTournamentPrizeXML"];
			var radioGroupName = 'theSameGroup';
			var topMostNodeName = 'tournamentprize';
			var checkSum = true;
			
			function GetXML()
			{
				result = SerializeTableToXML();
				if (result != '')	
				{
					hdnXML.value = result;
				}
				__doPostBack('btnSave', '');
				return false;
			}
		</script>
	</body>
</HTML>
