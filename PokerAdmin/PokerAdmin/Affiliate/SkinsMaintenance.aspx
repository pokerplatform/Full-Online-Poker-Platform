<%@ Register TagPrefix="GFC" Namespace="Common.WebControls" Assembly = "Common" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="GPC" TagName="SmartGridPager" Src="../Controls/SmartGridPager.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Page language="c#" Codebehind="SkinsMaintenance.aspx.cs" AutoEventWireup="false" Inherits="Admin.Affiliate.SkinsMaintenance" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Skins Maintenance</title>
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
								<td align="center">
									<CBC:ButtonImage id="btnAdd" onclick="btnAdd_Click" runat="server" Text="Add"></CBC:ButtonImage></td>
								<TD align="center">
									<CBC:ButtonImage id="btnDelete" onclick="btnDelete_Click" runat="server" Text="Delete"></CBC:ButtonImage></TD>
								<TD align="center"><CBC:BUTTONIMAGE id="btnSearchAgain" onclick="btnSearchAgain_Click" runat="server" Text="SearchAgain"></CBC:BUTTONIMAGE></TD>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="center">
						<GFC:GRIDFILTER id="oFilter" runat="server" Grid="oGrid" MoveHeader="true">
							<GFC:FilterItem></GFC:FilterItem>
							<GFC:FilterItem id="edt1" Type="Edit" GridSourceParameter="@SkinsName"></GFC:FilterItem>
							<GFC:FilterItem id="Status" Type="Combo" GridSourceParameter="@StatusID" Cashed="true" ComboSourceQuery="admGetDictionaryStatusAll"></GFC:FilterItem>
						</GFC:GRIDFILTER>
						<asp:datagrid id="oGrid" runat="server" AutoGenerateColumns="False" HorizontalAlign="Center" CellPadding="2"
							BorderColor="#3399FF" CssClass="cssReport cssTextMain" PageSize="50">
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
								<asp:HyperLinkColumn HeaderText="Skin Name"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Status" HeaderStyle-Width="30%"></asp:HyperLinkColumn>
							</Columns>
						</asp:datagrid><GPC:SmartGRIDPAGER id="oSGridPager" runat="server" Grid="oGrid" CssClass="cssReport" EditCssClass="cssGridPagerEdit"
							ItemCssClass="cssGridPagerItem" GridFilter="oFilter"></GPC:SmartGRIDPAGER></td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER></form>
	</body>
</HTML>
