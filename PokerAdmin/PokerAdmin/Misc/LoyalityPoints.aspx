<%@ Page language="c#" Codebehind="LoyalityPoints.aspx.cs" AutoEventWireup="false" Inherits="Admin.Misc.LoyalityPoints" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Loyality Points</title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="Form1" method="post" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="100%" align="center">
				<tr>
					<td align="center">
						<CBC:BUTTONIMAGE id="btnSave" onclick="btnSave_click" runat="server" Text="Save"></CBC:BUTTONIMAGE>
					</td>
				</tr>
				<tr>
					<td align="center"><asp:Label ID="lblError" Runat="server"></asp:Label></td>
				</tr>
				<tr>
					<td align="center">
						<asp:Table ID="tblMain" CellSpacing="0" GridLines="Both" CellPadding="2" HorizontalAlign="Center"
							BorderColor="#3399FF" CssClass="cssReport cssTextMain" Runat="server">
							<asp:TableRow CssClass="cssReportHeader">
								<asp:TableCell Width="35%">Name</asp:TableCell>
								<asp:TableCell Width="15%">Min. Value</asp:TableCell>
								<asp:TableCell Width="15%">Points</asp:TableCell>
								<asp:TableCell Width="35%">Name of SQLProcedure</asp:TableCell>
							</asp:TableRow>
						</asp:Table>
					</td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER>
		</form>
	</body>
</HTML>
