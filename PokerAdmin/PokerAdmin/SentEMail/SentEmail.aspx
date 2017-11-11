<%@ Register TagPrefix="GFC" Namespace="Common.WebControls" Assembly = "Common" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="GPC" TagName="SmartGridPager" Src="../Controls/SmartGridPager.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Page language="c#" Codebehind="SentEmail.aspx.cs" AutoEventWireup="false" Inherits="Admin.SentEmail.SentEmail" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Sent Emails</title>
		<meta content="Microsoft Visual Studio 7.0" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="GameProcessMaintenance" method="post" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="100%">
				<tr>
					<td align="center" height="27">
						<table width="53%" align="center" border="0">
							<tr>
								<td align="center"><CBC:BUTTONIMAGE id="btnSearchAgain" onclick="btnSearchAgain_Click" runat="server" Text="Search Again"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="center"><GFC:GRIDFILTER id="oFilter" runat="server" Grid="oGrid" MoveHeader="true">
							<GFC:FilterItem id="DateSent" GridSourceParameter="@Date" Type="Edit"></GFC:FilterItem>
							<GFC:FilterItem id="Subject" GridSourceParameter="@Subject" Type="Edit"></GFC:FilterItem>
							<GFC:FilterItem id="SentTo" GridSourceParameter="@SentTo" Type="Edit"></GFC:FilterItem>
							<GFC:FilterItem id="SentFrom" GridSourceParameter="@SentFrom" Type="Edit"></GFC:FilterItem>
							<GFC:FilterItem id="SentByName" GridSourceParameter="@SentBy" Type="Combo" ComboSourceQuery="admGetDictionaryEmailSentByAll"
								Cashed="true"></GFC:FilterItem>
						</GFC:GRIDFILTER><asp:datagrid id="oGrid" runat="server" PageSize="50" CssClass="cssReport cssTextMain" BorderColor="#3399FF"
							CellPadding="2" HorizontalAlign="Center" AutoGenerateColumns="False">
							<AlternatingItemStyle CssClass="cssReportItemOdd"></AlternatingItemStyle>
							<ItemStyle CssClass="cssReportItem"></ItemStyle>
							<HeaderStyle CssClass="cssReportHeader"></HeaderStyle>
							<Columns>
								<asp:HyperLinkColumn HeaderText="Date"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Subject"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Sent To"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Sent From"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Sent By"></asp:HyperLinkColumn>
							</Columns>
						</asp:datagrid><GPC:SmartGRIDPAGER id="oSGridPager" runat="server" Grid="oGrid" CssClass="cssReport" EditCssClass="cssGridPagerEdit"
							ItemCssClass="cssGridPagerItem" GridFilter="oFilter"></GPC:SmartGRIDPAGER></td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER></form>
	</body>
</HTML>
