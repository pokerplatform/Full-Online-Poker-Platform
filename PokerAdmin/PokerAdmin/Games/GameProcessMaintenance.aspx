<%@ Register TagPrefix="GFC" Namespace="Common.WebControls" Assembly = "Common" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="GPC" TagName="SmartGridPager" Src="../Controls/SmartGridPager.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Page language="c#" Codebehind="GameProcessMaintenance.aspx.cs" AutoEventWireup="false" Inherits="Admin.Games.GameProcessMaintenance" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Game Process Maintenance</title>
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
								<td align="center"><CBC:BUTTONIMAGE id="btnAdd" onclick="btnAdd_Click" runat="server" Text="Add"></CBC:BUTTONIMAGE></td>
								<td align="center"><CBC:BUTTONIMAGE id="btnDelete" onclick="btnDeleteProcess_Click" runat="server" Text="Delete"></CBC:BUTTONIMAGE></td>
								<td align="center"><CBC:BUTTONIMAGE id="btnSearchAgain" onclick="btnSearchAgain_Click" runat="server" Text="SearchAgain"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="center"><GFC:GRIDFILTER id="oFilter" runat="server" Grid="oGrid" MoveHeader="true">
							<GFC:FilterItem></GFC:FilterItem>
							<GFC:FilterItem id="edt1" Type="Edit" GridSourceParameter="@ProcessName"></GFC:FilterItem>
							<GFC:FilterItem id="combo1" Type="Combo" GridSourceParameter="@SubCategoryID" ComboSourceQuery="admDictionarySubCategoryAll"
								Cashed="true"></GFC:FilterItem>
							<GFC:FilterItem id="combo2" Type="Combo" GridSourceParameter="@CurrencyTypeID" ComboSourceQuery="admDictionaryCurrencyAll"
								Cashed="true"></GFC:FilterItem>
							<GFC:FilterItem id="edit2" Type="Edit" GridSourceParameter="@ExcludeSubCategoryID"></GFC:FilterItem>
						</GFC:GRIDFILTER><asp:datagrid id="oGrid" runat="server" PageSize="50" CssClass="cssReport cssTextMain" BorderColor="#3399FF"
							CellPadding="2" HorizontalAlign="Center" AutoGenerateColumns="False">
							<AlternatingItemStyle CssClass="cssReportItemOdd"></AlternatingItemStyle>
							<ItemStyle CssClass="cssReportItem"></ItemStyle>
							<HeaderStyle CssClass="cssReportHeader"></HeaderStyle>
							<Columns>
								<asp:TemplateColumn>
									<HeaderStyle Width="30px"></HeaderStyle>
									<ItemTemplate>
										<%#GetCheckBoxHtml(Container.DataItem)%>
									</ItemTemplate>
								</asp:TemplateColumn>
								<asp:HyperLinkColumn HeaderText="Table Name"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="SubCategory"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Currency Name"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Players Count"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Watchers Count"></asp:HyperLinkColumn>
								<asp:TemplateColumn>
									<HeaderStyle Width="30px"></HeaderStyle>
									<ItemTemplate>
										<CBC:ButtonImage EnableViewState="true" ID="btUsers" Text="Players" runat="server" />
									</ItemTemplate>
								</asp:TemplateColumn>
							</Columns>
						</asp:datagrid>
						<GPC:SMARTGRIDPAGER id="oSGridPager" runat="server" Grid="oGrid" CssClass="cssReport" EditCssClass="cssGridPagerEdit"
							ItemCssClass="cssGridPagerItem" GridFilter="oFilter"></GPC:SMARTGRIDPAGER>
					</td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER>
		</form>
	</body>
</HTML>
