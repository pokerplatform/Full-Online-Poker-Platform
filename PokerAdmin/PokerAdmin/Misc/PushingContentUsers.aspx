<%@ Register TagPrefix="dgg" Namespace="DataGridCustomColumns" Assembly="DataGridCustomColumns" %>
<%@ Page language="c#" Codebehind="PushingContentUsers.aspx.cs" AutoEventWireup="false" Inherits="Admin.Misc.PushingContentUsers" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="GFC" Namespace="Common.WebControls" Assembly = "Common" %>
<%@ Register TagPrefix="dgg" Namespace="DataGridCustomColumns" Assembly="DataGridCustomColumns" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Pushing Content and Users</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="Form1" method="post" runat="server" encType="multipart/form-data">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="100%">
				<tr>
					<td align="center" height="27">
						<table align="center" border="0">
							<tr>
								<td align="right">User's LoginName:</td>
								<td align="left">
									<asp:TextBox id="txtLoginName" runat="server"></asp:TextBox></td>
								<td align="center"><CBC:BUTTONIMAGE id="btnAdd" onclick="btnAdd_Click" runat="server" Text="Add"></CBC:BUTTONIMAGE></td>
								<td align="center"><CBC:BUTTONIMAGE id="btnDelete" onclick="btnDelete_Click" runat="server" Text="Delete"></CBC:BUTTONIMAGE></td>
								<td align="center"><CBC:BUTTONIMAGE id="btnBack" onclick="btnBack_Click" runat="server" Text="Back"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="center"><asp:label id="lbStatus" runat="server" EnableViewState="false" ForeColor="red"></asp:label></td>
				</tr>
				<tr>
					<td align="center"><asp:datagrid id="oGrid" runat="server" AllowPaging="True" CssClass="cssReport cssTextMain" BorderColor="#3399FF"
							CellPadding="2" HorizontalAlign="Center" AutoGenerateColumns="False">
							<SelectedItemStyle Font-Underline="True"></SelectedItemStyle>
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
								<asp:BoundColumn DataField="id" ReadOnly="True" HeaderText="ID"></asp:BoundColumn>
								<asp:BoundColumn DataField="UserID" HeaderText="User ID"></asp:BoundColumn>
								<asp:BoundColumn DataField="Loginname" HeaderText="Login Name"></asp:BoundColumn>
							</Columns>
							<PagerStyle HorizontalAlign="Left" Mode="NumericPages"></PagerStyle>
						</asp:datagrid></td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER></form>
	</body>
</HTML>
