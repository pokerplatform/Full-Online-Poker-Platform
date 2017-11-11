<%@ Register TagPrefix="GFC" Namespace="Common.WebControls" Assembly = "Common" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="GPC" TagName="SmartGridPager" Src="../Controls/SmartGridPager.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Page language="c#" Codebehind="InvitedUsers.aspx.cs" AutoEventWireup="false" Inherits="Admin.Games.InvitedUsers" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Invited Users</title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="Form1" method="post" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="100%">
				<tr>
					<td align="center" height="27">
						<table width="67%" align="center" border="0">
							<tr>
								<td>User's Login name to Add:</td>
								<td><asp:TextBox id="txtUserName" runat="server"></asp:TextBox></td>
								<td align="center"><CBC:BUTTONIMAGE id="btnAddUser" onclick="btnAddUser_Click" runat="server" Text="Add User"></CBC:BUTTONIMAGE></td>
								<td align="center"><CBC:BUTTONIMAGE id="btnDelete" onclick="btnDelete_Click" runat="server" Text="Delete Users"></CBC:BUTTONIMAGE></td>
								<td><CBC:BUTTONIMAGE id="btnCancel" onclick="bntGoBack_Click" runat="server" Text="Back" CausesValidation="false"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="center">
						<asp:Label id="lbMessage" runat="server" ForeColor="Red"></asp:Label></td>
				</tr>
				<tr>
					<td align="center">
					<GFC:GRIDFILTER id="oFilter" runat="server" Grid="oGrid" MoveHeader="true">
							<GFC:FilterItem></GFC:FilterItem>
							<GFC:FilterItem id="edt1" Type="Edit" GridSourceParameter="@ProcessID" ></GFC:FilterItem>
							<GFC:FilterItem id="edt2" Type="Edit" GridSourceParameter="@IsTournament" ></GFC:FilterItem>
						</GFC:GRIDFILTER>
					      <asp:datagrid id="oGrid" runat="server" PageSize="50" CssClass="cssReport cssTextMain" BorderColor="#3399FF"
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
								<asp:BoundColumn DataField="UserID" HeaderText="ID"></asp:BoundColumn>
								<asp:BoundColumn DataField="LoginName" HeaderText="Name"></asp:BoundColumn>
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
