<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Page language="c#" Codebehind="ClientApplicationFile.aspx.cs" AutoEventWireup="false" Inherits="Admin.Misc.ClientApplicationFile" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Client Application Files</title>
		<meta content="Microsoft Visual Studio 7.0" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
	</HEAD>
	<body>
		<form id="GameProcessMaintenance" method="post" encType="multipart/form-data" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="100%">
				<TBODY>
					<tr>
						<td align="center" height="27">
							<table width="53%" align="center" border="0">
								<tr>
									<td align="center"><CBC:BUTTONIMAGE id="btnSave" onclick="btnSave_Click" runat="server" Text="Save"></CBC:BUTTONIMAGE></td>
									<TD align="center"><CBC:BUTTONIMAGE id="btnAffiliate" onclick="btnAffiliate_Click" runat="server" Text="Update Skin"></CBC:BUTTONIMAGE></TD>
									<TD align="center"><CBC:BUTTONIMAGE id="btnDelete" onclick="btnDelete_Click" runat="server" Text="Delete"></CBC:BUTTONIMAGE></TD>
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
									<td><asp:dropdownlist id="ddSkins" runat="server" Width="269px"></asp:dropdownlist></td>
									<td><CBC:BUTTONIMAGE id="btnSelectSkin" onclick="btnSelectSkin_Click" runat="server" Text="Show"></CBC:BUTTONIMAGE></td>
								</tr>
							</table>
						</td>
					</tr>
					<TR>
						<TD align="center">
							<TABLE>
								<TR>
									<TD><NOBR>Upload New*:</NOBR></TD>
									<TD><asp:dropdownlist id="combo_0" runat="server"></asp:dropdownlist></TD>
									<TD><INPUT style="WIDTH: 300px" type="file" name="0"></TD>
								</TR>
								<TR>
									<TD></TD>
									<TD></TD>
									<TD align="right">(* you can also upload zip archive)</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
					<TR>
						<TD align="center"><asp:datagrid id="oGrid" runat="server" EnableViewState="False" AutoGenerateColumns="False" HorizontalAlign="Center"
								CellPadding="2" BorderColor="#3399FF" CssClass="cssReport cssTextMain" PageSize="50" AllowPaging="True">
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
									<asp:BoundColumn DataField="Size" HeaderText="Size"></asp:BoundColumn>
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
								<PagerStyle HorizontalAlign="Left" Mode="NumericPages"></PagerStyle>
							</asp:datagrid></TD>
					</TR>
					<TR>
						<TD align="center">
							<TABLE id="Table1" width="53%" align="center" border="0">
								<TR>
									<TD align="center"><CBC:BUTTONIMAGE id="btnSave2" onclick="btnSave_Click" runat="server" Text="Save"></CBC:BUTTONIMAGE></TD>
									<TD align="center"><CBC:BUTTONIMAGE id="btnDelete2" onclick="btnDelete_Click" runat="server" Text="Delete"></CBC:BUTTONIMAGE></TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
				</TBODY>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER><INPUT id="hdnGameEngineID" type="hidden" name="hdnGameEngineID" runat="server" DESIGNTIMEDRAGDROP="61"></form>
		</TR></TBODY></TABLE></FORM>
	</body>
</HTML>
