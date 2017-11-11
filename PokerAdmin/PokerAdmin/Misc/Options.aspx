<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Page language="c#" Codebehind="Options.aspx.cs" AutoEventWireup="false" Inherits="Admin.Misc.Options" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Options</title>
		<meta content="Microsoft Visual Studio 7.0" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="MiscMaintenance" method="post" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="100%" align="center">
				<tr>
					<td align="middle">
						<CBC:BUTTONIMAGE id="btnSave" onclick="btnSave_click" runat="server" Text="Save"></CBC:BUTTONIMAGE>
					</td>
				</tr>
				<tr>
					<td align="middle"><asp:Label ID="lblError" Runat="server"></asp:Label></td>
				</tr>
				<tr>
					<td align="middle">
						<asp:Table ID="tblMain" CellSpacing="0" GridLines="Both" CellPadding="2" HorizontalAlign="Center" BorderColor="#3399FF" CssClass="cssReport cssTextMain" Runat="server">
							<asp:TableRow CssClass="cssReportHeader">
								<asp:TableCell Width="15%">&nbsp;</asp:TableCell>
								<asp:TableCell Width="15%">&nbsp;</asp:TableCell>
								<asp:TableCell Width="70%">&nbsp;</asp:TableCell>
							</asp:TableRow>
						</asp:Table>
						<asp:datagrid id="oGrid" runat="server" AutoGenerateColumns="False" CellSpacing="0" CellPadding="2" HorizontalAlign="Center" BorderColor="#3399FF" CssClass="cssReport cssTextMain">
							<ItemStyle CssClass="cssReportItemOdd"></ItemStyle>
							<HeaderStyle CssClass="cssReportHeader"></HeaderStyle>
							<Columns>
								<asp:BoundColumn ItemStyle-Width="0%" Visible="False" DataField="PropertyTypeID"></asp:BoundColumn>
								<asp:BoundColumn ItemStyle-Width="0%" Visible="False" DataField="ID"></asp:BoundColumn>
								<asp:TemplateColumn ItemStyle-Width="15%">
									<ItemTemplate>
										<%#GetObjectName(Container.DataItem)%>
									</ItemTemplate>
								</asp:TemplateColumn>
								<asp:BoundColumn ItemStyle-Width="15%" DataField="PropertyName" />
								<asp:TemplateColumn ItemStyle-Width="70%">
									<ItemTemplate>
										<%#GetEdit(Container.DataItem)%>
									</ItemTemplate>
								</asp:TemplateColumn>
							</Columns>
						</asp:datagrid>
					</td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER></form>
	</body>
</HTML>
