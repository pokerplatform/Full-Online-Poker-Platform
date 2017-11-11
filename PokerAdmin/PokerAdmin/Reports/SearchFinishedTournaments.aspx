<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Page language="c#" Codebehind="SearchFinishedTournaments.aspx.cs" AutoEventWireup="false" Inherits="Admin.Reports.SearchFinishedTournaments" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Search Finished Tournaments</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="Form1" style="FONT-SIZE: 14px" method="post" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="50%" align="center">
				<tr>
					<td align="center" colSpan="2"><CBC:BUTTONIMAGE id="btnSearchAgain" onclick="btnSearch_Click" runat="server" Text="Search"></CBC:BUTTONIMAGE></td>
				</tr>
				<tr>
					<td align="center" colSpan="2">
						<asp:Label id="lbInfo" runat="server" ForeColor="red"></asp:Label></td>
				</tr>
				<tr>
					<td>
						<table style="FONT-SIZE: 14px" borderColor="#3399ff" cellSpacing="0" cellPadding="2" width="100%"
							align="center" border="1">
							<tr>
								<td width="30%">Tournament name</td>
								<td><asp:textbox id="txtTrnName" runat="server" Width="100%"></asp:textbox></td>
							</tr>
							<tr>
								<td width="30%">Start date</td>
								<td>
									<div>From:&nbsp;<asp:TextBox id="txtStFrom" runat="server" Width="85%"></asp:TextBox></div>
									<div>To:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:TextBox id="txtTo" runat="server" Width="85%"></asp:TextBox></div>
								</td>
							</tr>
							<tr>
								<td width="30%">End date</td>
								<td>
									<div>From:&nbsp;<asp:TextBox id="txtEndFrom" runat="server" Width="85%"></asp:TextBox></div>
									<div>To:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:TextBox id="txtEndTo" runat="server" Width="85%"></asp:TextBox></div>
								</td>
							</tr>
							<tr>
								<td>
									Currency type
								</td>
								<td>
									<asp:DropDownList id="ddCurrency" runat="server" Width="100%"></asp:DropDownList>
								</td>
							</tr>
							<tr>
								<td width="30%">Player Login Name</td>
								<td><asp:textbox id="txtLoginName" runat="server" Width="100%"></asp:textbox></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<table align="center">
				<TR>
					<td align="center">
						<asp:datagrid id="oGrid" runat="server" PageSize="50" CssClass="cssReport cssTextMain" BorderColor="#3399FF"
							CellPadding="2" HorizontalAlign="Center" AutoGenerateColumns="False">
							<AlternatingItemStyle CssClass="cssReportItemOdd"></AlternatingItemStyle>
							<ItemStyle CssClass="cssReportItem"></ItemStyle>
							<HeaderStyle CssClass="cssReportHeader"></HeaderStyle>
							<Columns>
								<asp:BoundColumn DataField="ID" HeaderText="ID"></asp:BoundColumn>
								<asp:BoundColumn DataField="Name" HeaderText="Name"></asp:BoundColumn>
								<asp:BoundColumn DataField="TournamentStartTime" HeaderText="Start Time"></asp:BoundColumn>
								<asp:BoundColumn DataField="TournamentFinishTime" HeaderText="Finish Time"></asp:BoundColumn>
								<asp:BoundColumn DataField="Currency" HeaderText="Currency"></asp:BoundColumn>
								<asp:BoundColumn DataField="GameType" HeaderText="Game"></asp:BoundColumn>
								<asp:BoundColumn DataField="CountPrizes" HeaderText="Count Prizes"></asp:BoundColumn>
								<asp:BoundColumn DataField="TotalPrize" HeaderText="Total Prize"></asp:BoundColumn>
								<asp:BoundColumn DataField="TotalFee" HeaderText="Total Fee"></asp:BoundColumn>
							</Columns>
							<PagerStyle HorizontalAlign="Left" Mode="NumericPages"></PagerStyle>
						</asp:datagrid>
					</td>
				</TR>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER></form>
	</body>
</HTML>
