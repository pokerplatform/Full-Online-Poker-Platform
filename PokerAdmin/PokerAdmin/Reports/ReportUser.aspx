<%@ Page language="c#" Codebehind="ReportUser.aspx.cs" AutoEventWireup="false" Inherits="Admin.Reports.ReportUser" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="GPC" TagName="GridPager" Src="../Controls/GridPager.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="GFC" Namespace="Common.WebControls" Assembly = "Common" %>
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
						<table class="cssTextMain" borderColor="#3399ff" cellSpacing="0" cellPadding="2" width="60%"
							align="center" border="1">
							<TR>
								<TD>Sex</TD>
								<TD align="left"><asp:dropdownlist id="comboSex" Runat="server"></asp:dropdownlist></TD>
							</TR>
							<!--      <TR>
          <TD>Qualification</TD>
          <TD align=left><asp:dropdownlist id=comboQualification Runat="server"></asp:dropdownlist></TD></TR>-->
							<TR>
								<TD>EmailVerified</TD>
								<TD align="left"><asp:dropdownlist id="comboEmailVerified" Runat="server">
										<asp:ListItem Value="-10">All</asp:ListItem>
										<asp:ListItem Value="-1">Non Valid</asp:ListItem>
										<asp:ListItem Value="0">Unknown</asp:ListItem>
										<asp:ListItem Value="1">Valid</asp:ListItem>
									</asp:dropdownlist></TD>
							</TR>
						</table>
						<br>
						<P><CBC:BUTTONIMAGE id="btnApplyFilter" onclick="btnApplyFilter_Click" runat="server" Text="Apply Filter"></CBC:BUTTONIMAGE></P>
					</td>
				</tr>
				<tr>
					<td align="center"><asp:datagrid id="oGrid" runat="server" PageSize="50" CssClass="cssReport cssTextMain" BorderColor="#3399FF"
							CellPadding="2" HorizontalAlign="Center" AutoGenerateColumns="False">
							<AlternatingItemStyle CssClass="cssReportItemOdd"></AlternatingItemStyle>
							<ItemStyle CssClass="cssReportItem"></ItemStyle>
							<HeaderStyle CssClass="cssReportHeader"></HeaderStyle>
							<Columns>
								<asp:BoundColumn DataField="name" HeaderText="Name"></asp:BoundColumn>
								<asp:BoundColumn DataField="TotalUsersCount" HeaderText="Total Users"></asp:BoundColumn>
								<asp:BoundColumn DataField="StandardUsersCount" HeaderText="Standard Users"></asp:BoundColumn>
								<asp:BoundColumn DataField="TotalLoggedDays" HeaderText="Logged Days"></asp:BoundColumn>
								<asp:BoundColumn DataField="TotalDeposited" HeaderText="Total Deposited"></asp:BoundColumn>
							</Columns>
						</asp:datagrid><GPC:GRIDPAGER id="oSGridPager" runat="server" CssClass="cssReport" GridFilter="oFilter" ItemCssClass="cssGridPagerItem"
							EditCssClass="cssGridPagerEdit" Grid="oGrid"></GPC:GRIDPAGER></td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER></form>
	</body>
</HTML>
