<%@ Register TagPrefix="dgg" Namespace="DataGridCustomColumns" Assembly="DataGridCustomColumns" %>
<%@ Register TagPrefix="GFC" Namespace="Common.WebControls" Assembly = "Common" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Page language="c#" Codebehind="PushingContent.aspx.cs" AutoEventWireup="false" Inherits="Admin.Misc.PushingContent" %>
<%@ Register TagPrefix="dgg" Namespace="DataGridCustomColumns" Assembly="DataGridCustomColumns" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Pushing Content</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="Form1" method="post" runat="server" encType="multipart/form-data">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="100%">
				<TBODY>
					<tr>
						<td align="center" height="27">
							<table width="53%" align="center" border="0">
								<tr>
									<td align="center"><CBC:BUTTONIMAGE id="btnAdd" onclick="btnAdd_Click" runat="server" Text="Add"></CBC:BUTTONIMAGE></td>
									<td align="center"><CBC:BUTTONIMAGE id="btnDelete" onclick="btnDelete_Click" runat="server" Text="Delete"></CBC:BUTTONIMAGE></td>
								</tr>
								<tr>
									<td></td>
									<td align="center" style="FONT-SIZE: xx-small">You Must remove all files<br>
										before delete the Content</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td align="center"><asp:datagrid id="oGrid" runat="server" AllowPaging="false" CssClass="cssReport cssTextMain" BorderColor="#3399FF"
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
									<asp:EditCommandColumn ButtonType="LinkButton" UpdateText="Update" CancelText="Cancel" EditText="Edit"></asp:EditCommandColumn>
									<asp:BoundColumn DataField="id" ReadOnly="True" HeaderText="ID"></asp:BoundColumn>
									<asp:BoundColumn DataField="name" HeaderText="Name"></asp:BoundColumn>
									<asp:BoundColumn DataField="ActivateDate" HeaderText="Activate Date"></asp:BoundColumn>
									<asp:ButtonColumn Text="Files" CommandName="Select"></asp:ButtonColumn>
									<asp:HyperLinkColumn DataTextField="UsersCount" HeaderText="Players"></asp:HyperLinkColumn>
									<asp:HyperLinkColumn DataTextField="ProcessesCount" HeaderText="Processes"></asp:HyperLinkColumn>
								</Columns>
								<PagerStyle HorizontalAlign="Left" Mode="NumericPages"></PagerStyle>
							</asp:datagrid></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="center"><asp:label id="lbStatus" runat="server" EnableViewState="false"></asp:label></td>
					</tr>
					<tr>
						<td></td>
					</tr>
					<tr>
						<td align="center" height="27">
							<asp:Panel id="pnUpload" runat="server">
								<TABLE width="53%" align="center" border="0">
									<TR>
										<TD align="center">
											<TABLE>
												<TR>
													<TD><NOBR>Upload New:</NOBR></TD>
													<TD>
														<asp:DropDownList id="ddContentType" runat="server"></asp:DropDownList></TD>
													<TD><INPUT style="WIDTH: 300px" type="file" name="0"></TD>
													<TD>
														<CBC:BUTTONIMAGE id="btnAddFile" onclick="btnAddFile_Click" runat="server" Text="Add"></CBC:BUTTONIMAGE></TD>
												</TR>
											</TABLE>
										</TD>
									</TR>
									<TR>
										<TD align="center">
											<CBC:BUTTONIMAGE id="btnDeleteFile" onclick="btnDeleteFile_Click" runat="server" Text="Delete"></CBC:BUTTONIMAGE></TD>
									</TR>
								</TABLE>
							</asp:Panel>
						</td>
					</tr>
					<tr>
						<td align="center"><asp:datagrid id="vGrid" runat="server" AllowPaging="True" CssClass="cssReport cssTextMain" BorderColor="#3399FF"
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
									<asp:EditCommandColumn ButtonType="LinkButton" UpdateText="Update" CancelText="Cancel" EditText="Edit"></asp:EditCommandColumn>
									<asp:BoundColumn DataField="id" ReadOnly="True" HeaderText="ID"></asp:BoundColumn>
									<asp:BoundColumn DataField="Name" HeaderText="Name" ReadOnly="true"></asp:BoundColumn>
									<dgg:DropDownColumn DataField="PushingContentTypeID" DataTextField="Name" DataValueField="id" HeaderText="Content Type"
										WithEmptyItem="False"></dgg:DropDownColumn>
									<asp:BoundColumn DataField="Version" HeaderText="Version" ReadOnly="true"></asp:BoundColumn>
									<asp:BoundColumn DataField="FileSize" HeaderText="Size" ReadOnly="true"></asp:BoundColumn>
									<asp:BoundColumn DataField="Width" HeaderText="Width"></asp:BoundColumn>
									<asp:BoundColumn DataField="Height" HeaderText="Height"></asp:BoundColumn>
									<asp:TemplateColumn>
										<ItemTemplate>
											<%#BrowseHtml(Container.DataItem)%>
										</ItemTemplate>
									</asp:TemplateColumn>
								</Columns>
								<PagerStyle HorizontalAlign="Left" Mode="NumericPages"></PagerStyle>
							</asp:datagrid></td>
					</tr>
				</TBODY>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER></form>
	</body>
</HTML>
