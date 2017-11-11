<%@ Page language="c#" Codebehind="TournamentMaintenance.aspx.cs" AutoEventWireup="false" Inherits="Admin.Tournaments.TournamentMaintenance" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="GPC" TagName="SmartGridPager" Src="../Controls/SmartGridPager.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="GFC" Namespace="Common.WebControls" Assembly = "Common" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Tournament Maintenance</title>
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
								<td align="center"><CBC:BUTTONIMAGE id="btnDelete" onclick="btnDeleteTournament_Click" runat="server" Text="Delete"></CBC:BUTTONIMAGE></td>
								<td align="center"><CBC:BUTTONIMAGE id="btnSearchAgain" onclick="btnSearchAgain_Click" runat="server" Text="SearchAgain"></CBC:BUTTONIMAGE></td>
								<td align="center"><CBC:BUTTONIMAGE id="btnTournPause" onclick="btnTournPause_Click" runat="server" Text="Pause"></CBC:BUTTONIMAGE></td>
								<td align="center"><CBC:BUTTONIMAGE id="btnTournResume" onclick="btnTournResume_Click" runat="server" Text="Resume"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="center"><GFC:GRIDFILTER id="oFilter" runat="server" MoveHeader="true" Grid="oGrid">
							<GFC:FilterItem></GFC:FilterItem>
							<GFC:FilterItem id="Name" GridSourceParameter="@TournamentName" Type="Edit"></GFC:FilterItem>
							<GFC:FilterItem id="StartTime" GridSourceParameter="@StartTime" Type="Edit"></GFC:FilterItem>
							<GFC:FilterItem id="FinishTime" GridSourceParameter="@FinishTime" Type="Edit"></GFC:FilterItem>
							<GFC:FilterItem id="Type" GridSourceParameter="@TournamentTypeID" Type="Combo" Cashed="true" ComboSourceQuery="admGetDictionaryTournamentTypeAll"></GFC:FilterItem>
							<GFC:FilterItem id="Level" GridSourceParameter="@TournamentLevel" Type="Edit"></GFC:FilterItem>
							<GFC:FilterItem id="Status" GridSourceParameter="@TournamentStatusID" Type="Combo" Cashed="true"
								ComboSourceQuery="admGetDictionaryTournamentStatusAll"></GFC:FilterItem>
						</GFC:GRIDFILTER><asp:datagrid id="oGrid" runat="server" AutoGenerateColumns="False" HorizontalAlign="Center" CellPadding="2"
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
								<asp:HyperLinkColumn HeaderText="Name"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Start Time"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Finish Time"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Type"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Level"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Status"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Category"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Total Prize"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Players"></asp:HyperLinkColumn>
								<asp:TemplateColumn>
									<HeaderStyle Width="30px"></HeaderStyle>
									<ItemTemplate>
										<CBC:ButtonImage EnableViewState="true" ID="btUsers" Text="Players" runat="server" />
									</ItemTemplate>
								</asp:TemplateColumn>
							</Columns>
						</asp:datagrid><GPC:SMARTGRIDPAGER id="oSGridPager" runat="server" Grid="oGrid" CssClass="cssReport" GridFilter="oFilter"
							ItemCssClass="cssGridPagerItem" EditCssClass="cssGridPagerEdit"></GPC:SMARTGRIDPAGER></td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER></form>
	</body>
</HTML>
