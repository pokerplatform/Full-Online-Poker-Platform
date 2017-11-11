<%@ Page language="c#" Codebehind="TxHistoryList.aspx.cs" AutoEventWireup="false" Inherits="Admin.Transactions.TxHistoryList" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="GPC" TagName="SmartGridPager" Src="../Controls/SmartGridPager.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="GFC" Namespace="Common.WebControls" Assembly = "Common" %>
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
					<td align="center"><CBC:BUTTONIMAGE id="btnSearchAgain" onclick="btnSearchAgain_Click" runat="server" Text="SearchAgain"
							DESIGNTIMEDRAGDROP="11"></CBC:BUTTONIMAGE></td>
				</tr>
				<tr>
					<td align="center"><GFC:GRIDFILTER id="oFilter" runat="server" Grid="oGrid" MoveHeader="true">
							<GFC:FilterItem id="userName" Type="Edit" GridSourceParameter="@UserName"></GFC:FilterItem>
							<GFC:FilterItem id="TxType" Type="Combo" GridSourceParameter="@TxTypeID" Cashed="false" ComboSourceQuery="admDictionaryTxTypeAll"></GFC:FilterItem>
							<GFC:FilterItem></GFC:FilterItem>
							<GFC:FilterItem id="TxDate" Type="Edit" GridSourceParameter="@RecordDate"></GFC:FilterItem>
						</GFC:GRIDFILTER>
						<asp:datagrid id="oGrid" runat="server" PageSize="50" CssClass="cssReport cssTextMain" BorderColor="#3399FF"
							CellPadding="2" HorizontalAlign="Center" AutoGenerateColumns="False">
							<AlternatingItemStyle CssClass="cssReportItemOdd"></AlternatingItemStyle>
							<ItemStyle CssClass="cssReportItem"></ItemStyle>
							<HeaderStyle CssClass="cssReportHeader"></HeaderStyle>
							<Columns>
								<asp:HyperLinkColumn HeaderText="User Name"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Transaction Type"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Transaction Amount"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Date"></asp:HyperLinkColumn>
							</Columns>
						</asp:datagrid><GPC:SMARTGRIDPAGER id="oSGridPager" runat="server" Grid="oGrid" CssClass="cssReport" EditCssClass="cssGridPagerEdit"
							ItemCssClass="cssGridPagerItem" GridFilter="oFilter"></GPC:SMARTGRIDPAGER></td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER></form>
	</body>
</HTML>
