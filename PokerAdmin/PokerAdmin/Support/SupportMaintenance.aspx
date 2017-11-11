<%@ Register TagPrefix="GFC" Namespace="Common.WebControls" Assembly = "Common" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="GPC" TagName="SmartGridPager" Src="../Controls/SmartGridPager.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Page language="c#" Codebehind="SupportMaintenance.aspx.cs" AutoEventWireup="false" Inherits="Admin.Support.SupportMaintenance" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Support Maintenance</title>
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
								<td align="center"><CBC:BUTTONIMAGE id="btnSearchAgain" onclick="btnSearchAgain_Click" runat="server" Text="SearchAgain"></CBC:BUTTONIMAGE></td>
								<td align="center"><CBC:BUTTONIMAGE id="btnDelete" onclick="btnDelete_Click" runat="server" Text="Delete"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="center"><GFC:GRIDFILTER id="oFilter" runat="server" Grid="oGrid" MoveHeader="true">
							<GFC:FilterItem id="date" Type="Edit" GridSourceParameter="@Date"></GFC:FilterItem>
							<GFC:FilterItem id="userName" Type="Edit" GridSourceParameter="@UserName"></GFC:FilterItem>
							<GFC:FilterItem id="subject" Type="Edit" GridSourceParameter="@Subject"></GFC:FilterItem>
							<GFC:FilterItem id="body" Type="Edit" GridSourceParameter="@Body"></GFC:FilterItem>
							<GFC:FilterItem id="supportUserTypeID" Type="Combo" GridSourceParameter="@SupportUserTypeID" Cashed="true"
								ComboSourceQuery="admGetDictionarySupportUserTypeAll"></GFC:FilterItem>
							<GFC:FilterItem id="SupportUserID" Type="Combo" GridSourceParameter="@SupportUserID" Cashed="false"
								ComboSourceQuery="admDictionarySupportUserAll"></GFC:FilterItem>
							<GFC:FilterItem id="supportStatusID" Type="Combo" GridSourceParameter="@SupportStatusID" Cashed="true"
								ComboSourceQuery="admDictionarySupportStatusAll"></GFC:FilterItem>
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
								<asp:HyperLinkColumn HeaderText="Date"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="User Name"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Subject"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Body"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="CS Type"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="CS Name"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Status"></asp:HyperLinkColumn>
							</Columns>
						</asp:datagrid><GPC:SmartGRIDPAGER id="oSGridPager" runat="server" Grid="oGrid" CssClass="cssReport" EditCssClass="cssGridPagerEdit"
							ItemCssClass="cssGridPagerItem" GridFilter="oFilter"></GPC:SmartGRIDPAGER></td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER></form>
	</body>
</HTML>
