<%@ Page language="c#" Codebehind="GameDetailsFile.aspx.cs" AutoEventWireup="false" Inherits="Admin.Games.GameDetailsFile" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="GPC" TagName="GridPager" Src="../Controls/GridPager.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="GFC" Namespace="Common.WebControls" Assembly = "Common" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Game Files</title>
		<meta content="Microsoft Visual Studio 7.0" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="GameProcessMaintenance" method="post" encType="multipart/form-data" runat="server">
			<INPUT id="hdnGameEngineID" style="Z-INDEX: 101; LEFT: 181px; POSITION: absolute; TOP: 354px"
				type="hidden" name="hdnGameEngineID" runat="server"><CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="100%">
				<tr>
					<td align="center" height="27">
						<table width="53%" align="center" border="0">
							<tr>
								<td align="center"><CBC:BUTTONIMAGE id="btnSave" onclick="btnSave_Click" runat="server" Text="Save"></CBC:BUTTONIMAGE></td>
								<TD align="center"><CBC:BUTTONIMAGE id="btnDelete" onclick="btnDelete_Click" runat="server" Text="Delete"></CBC:BUTTONIMAGE></TD>
								<td align="center"><CBC:BUTTONIMAGE id="btnCancel" NavigateUrl="javascript:history.go(-1)" runat="server" Text="Back"
										CausesValidation="false"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<TR>
					<TD align="center" height="27"><asp:label id="lblInfo" EnableViewState="False" Runat="server" ForeColor="Red"></asp:label></TD>
				</TR>
				<tr>
					<td align="center">
						<table>
							<tr>
								<td align="right">Select Skin:</td>
								<td><asp:DropDownList id="ddSkins" runat="server" Width="269px"></asp:DropDownList></td>
								<td><CBC:BUTTONIMAGE id="btnSelectSkin" onclick="btnSelectSkin_Click" runat="server" Text="Show"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="center"><asp:datagrid id="oGrid" runat="server" EnableViewState="False" AutoGenerateColumns="False" HorizontalAlign="Center"
							CellPadding="2" BorderColor="#3399FF" CssClass="cssReport cssTextMain" PageSize="50">
							<AlternatingItemStyle CssClass="cssReportItemOdd"></AlternatingItemStyle>
							<ItemStyle CssClass="cssReportItem"></ItemStyle>
							<HeaderStyle CssClass="cssReportHeader"></HeaderStyle>
							<Columns>
								<asp:TemplateColumn>
									<HeaderStyle Width="30px"></HeaderStyle>
									<ItemTemplate>
										<%#CheckBoxHtml(Container.DataItem)%>
									</ItemTemplate>
								</asp:TemplateColumn>
								<asp:HyperLinkColumn Target="_blank" DataNavigateUrlField="url" DataTextField="FileName" HeaderText="File Name"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn Target="_blank" DataNavigateUrlField="url" DataTextField="Size" HeaderText="Size"></asp:HyperLinkColumn>
								<asp:TemplateColumn HeaderText="Version">
									<ItemTemplate>
										<%#EditBoxHtml(Container.DataItem,"version")%>
									</ItemTemplate>
								</asp:TemplateColumn>
								<asp:TemplateColumn HeaderText="Content Type">
									<ItemTemplate>
										<%#ComboBoxHtml(Container.DataItem)%>
									</ItemTemplate>
								</asp:TemplateColumn>
								<asp:TemplateColumn HeaderText="Width">
									<ItemTemplate>
										<%#EditBoxHtml(Container.DataItem,"width")%>
									</ItemTemplate>
								</asp:TemplateColumn>
								<asp:TemplateColumn HeaderText="Height">
									<ItemTemplate>
										<%#EditBoxHtml(Container.DataItem,"height")%>
									</ItemTemplate>
								</asp:TemplateColumn>
								<asp:TemplateColumn>
									<ItemTemplate>
										<%#BrowseHtml(Container.DataItem)%>
									</ItemTemplate>
								</asp:TemplateColumn>
							</Columns>
						</asp:datagrid></td>
				</tr>
				<TR>
					<TD align="center">
						<table>
							<tr>
								<td><nobr>Upload New:</nobr></td>
								<TD><asp:dropdownlist id="combo_0" runat="server"></asp:dropdownlist></TD>
								<td><INPUT style="WIDTH: 300px" type="file" name="0"></td>
							</tr>
						</table>
					</TD>
				</TR>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER></form>
	</body>
</HTML>
