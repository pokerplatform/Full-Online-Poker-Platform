<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Page language="c#" Codebehind="BanUser.aspx.cs" AutoEventWireup="false" Inherits="Admin.Misc.BanUser" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Ban User</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="Form1" method="post" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="75%" align="center">
				<tr>
					<td align="center">
						<table>
							<tr>
								<td>
									User ID:
									<asp:TextBox id="txtUID" runat="server"></asp:TextBox>
								</td>
								<td>
									IP:
									<asp:TextBox id="txtIP" runat="server"></asp:TextBox>
								</td>
								<td>
									Host:
									<asp:TextBox id="txtHost" runat="server"></asp:TextBox>
								</td>
								<td align="right">
									<CBC:BUTTONIMAGE id="btnAdd" onclick="btnAddBan_Click" runat="server" Text="Add"></CBC:BUTTONIMAGE>
								</td>
							</tr>
							<tr>
								<td align="right" colspan="4">
									<CBC:BUTTONIMAGE id="btnDelete" onclick="btnDeleteBan_Click" runat="server" Text="Delete"></CBC:BUTTONIMAGE>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="center" colSpan="2"><asp:datagrid id="oGrid" runat="server" AllowPaging="True" AutoGenerateColumns="False" HorizontalAlign="Center"
							CellPadding="2" BorderColor="#3399FF" CssClass="cssReport cssTextMain" PageSize="20">
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
								<asp:BoundColumn DataField="ID" HeaderText="ID"></asp:BoundColumn>
								<asp:BoundColumn DataField="UserID" HeaderText="User ID"></asp:BoundColumn>
								<asp:BoundColumn DataField="IP" HeaderText="IP"></asp:BoundColumn>
								<asp:BoundColumn DataField="Host" HeaderText="Host"></asp:BoundColumn>
							</Columns>
							<PagerStyle HorizontalAlign="Left" Mode="NumericPages"></PagerStyle>
						</asp:datagrid></td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER></form>
		</FORM>
	</body>
</HTML>
