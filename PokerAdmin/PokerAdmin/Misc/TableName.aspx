<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Page language="c#" Codebehind="TableName.aspx.cs" AutoEventWireup="false" Inherits="Admin.Misc.TableName" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Table Name</title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="Form1" method="post" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="75%" align="center">
				<tr>
					<td align="right">
						New Table Name: &nbsp;<asp:TextBox id="txtName" runat="server" MaxLength="255"></asp:TextBox></td>
					<td align="left"><CBC:BUTTONIMAGE id="btnAdd" onclick="btnAddTableName_Click" runat="server" Text="Add"></CBC:BUTTONIMAGE></td>
				</tr>
				<tr>
					<td>
					</td>
					<td align="left"><CBC:BUTTONIMAGE id="btnDelete" onclick="btnDeleteTableName_Click" runat="server" Text="Delete"></CBC:BUTTONIMAGE></td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<asp:datagrid id="oGrid" runat="server" PageSize="20" CssClass="cssReport cssTextMain" BorderColor="#3399FF"
							CellPadding="2" HorizontalAlign="Center" AutoGenerateColumns="False" AllowPaging="True">
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
								<asp:BoundColumn DataField="Name" HeaderText="Name"></asp:BoundColumn>
							</Columns>
							<PagerStyle HorizontalAlign="Left" Mode="NumericPages"></PagerStyle>
						</asp:datagrid>
					</td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER></form>
		</FORM>
	</body>
</HTML>
