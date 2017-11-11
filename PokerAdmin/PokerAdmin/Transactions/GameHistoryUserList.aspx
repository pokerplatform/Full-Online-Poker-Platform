<%@ Register TagPrefix="GFC" Namespace="Common.WebControls" Assembly = "Common" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="GPC" TagName="SmartGridPager" Src="../Controls/SmartGridPager.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Page language="c#" Codebehind="GameHistoryUserList.aspx.cs" AutoEventWireup="false" Inherits="Admin.Transactions.GameHistoryUserList" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Game History</title>
		<meta content="Microsoft Visual Studio 7.0" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="GameHistoryList" method="post" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="100%">
				<tr>
					<td align="center"><CBC:BUTTONIMAGE id="btnSearchAgain" onclick="btnSearchAgain_Click" runat="server" Text="SearchAgain"></CBC:BUTTONIMAGE></td>
				</tr>
				<tr>
					<td align="center"><GFC:GRIDFILTER id="oFilter" runat="server" Grid="oGrid" MoveHeader="true">
							<GFC:FilterItem id="userName" Type="Edit" GridSourceParameter="@UserName"></GFC:FilterItem>
							<GFC:FilterItem id="gameLogName" Type="Edit" GridSourceParameter="@GameLogName"></GFC:FilterItem>
							<GFC:FilterItem id="gameEngine" Type="Combo" GridSourceParameter="@GameEngineID" ComboSourceQuery="admDictionaryGameEngineAll"
								Cashed="true"></GFC:FilterItem>
							<GFC:FilterItem id="gameStartDate" Type="Edit" GridSourceParameter="@StartDate"></GFC:FilterItem>
						</GFC:GRIDFILTER><asp:datagrid id="oGrid" runat="server" PageSize="50" CssClass="cssReport cssTextMain" BorderColor="#3399FF"
							CellPadding="2" HorizontalAlign="Center" AutoGenerateColumns="False">
							<AlternatingItemStyle CssClass="cssReportItemOdd"></AlternatingItemStyle>
							<ItemStyle CssClass="cssReportItem"></ItemStyle>
							<HeaderStyle CssClass="cssReportHeader"></HeaderStyle>
							<Columns>
								<asp:HyperLinkColumn HeaderText="&lt;nobr&gt;User Name&lt;/nobr&gt;"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="&lt;nobr&gt;Game Log Name&lt;/nobr&gt;"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="&lt;nobr&gt;Engine Name&lt;/nobr&gt;"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Date"></asp:HyperLinkColumn>
							</Columns>
						</asp:datagrid><GPC:SmartGRIDPAGER id="oSGridPager" runat="server" Grid="oGrid" CssClass="cssReport" EditCssClass="cssGridPagerEdit"
							ItemCssClass="cssGridPagerItem" GridFilter="oFilter"></GPC:SmartGRIDPAGER></td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER></form>
	</body>
</HTML>
