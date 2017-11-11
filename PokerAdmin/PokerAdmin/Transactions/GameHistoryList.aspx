<%@ Page language="c#" Codebehind="GameHistoryList.aspx.cs" AutoEventWireup="false" Inherits="Admin.Transactions.GameHistoryList" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="GPC" TagName="SmartGridPager" Src="../Controls/SmartGridPager.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="GFC" Namespace="Common.WebControls" Assembly = "Common" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Game History</title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio 7.0">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="GameHistoryList" method="post" runat="server">
			<CDC:PageHeader ID="oPageHeader" runat="server" />
			<table width="100%">
				<tr>
					<td align="center"><CBC:ButtonImage ID="btnSearchAgain" Text="SearchAgain" OnClick="btnSearchAgain_Click" runat="server" /></td>
				</tr>
				<tr>
					<td align="center">
						<GFC:gridfilter id="oFilter" runat="server" MoveHeader="true" Grid="oGrid">
							<GFC:FilterItem id="GameLogName" GridSourceParameter="@GameLogName" Type="Edit"></GFC:FilterItem>
							<GFC:FilterItem id="GameEngine" GridSourceParameter="@GameEngineID" Type="Combo" Cashed="true" ComboSourceQuery="admDictionaryGameEngineAll"></GFC:FilterItem>
							<GFC:FilterItem id="GameStartDate" GridSourceParameter="@StartDate" Type="Edit"></GFC:FilterItem>
						</GFC:gridfilter>
						<asp:datagrid id="oGrid" runat="server" AutoGenerateColumns="False" HorizontalAlign="Center" CellPadding="2"
							BorderColor="#3399FF" CssClass="cssReport cssTextMain" PageSize="50">
							<AlternatingItemStyle CssClass="cssReportItemOdd"></AlternatingItemStyle>
							<ItemStyle CssClass="cssReportItem"></ItemStyle>
							<HeaderStyle CssClass="cssReportHeader"></HeaderStyle>
							<Columns>
								<asp:HyperLinkColumn HeaderText="&lt;nobr&gt;Game Log Name&lt;/nobr&gt;"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="&lt;nobr&gt;Engine Name&lt;/nobr&gt;"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Date"></asp:HyperLinkColumn>
							</Columns>
						</asp:datagrid>
						<GPC:SmartGridPager ID="oSGridPager" Grid="oGrid" GridFilter="oFilter" CssClass="cssReport" ItemCssClass="cssGridPagerItem"
							EditCssClass="cssGridPagerEdit" runat="server" />
					</td>
				</tr>
			</table>
			<CDC:PageFooter ID="oPageFooter" runat="server" />
		</form>
	</body>
</HTML>
