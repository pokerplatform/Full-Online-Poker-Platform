<%@ Page language="c#" Codebehind="UsersMaintenance.aspx.cs" AutoEventWireup="false" Inherits="Admin.Users.UsersMaintenance" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="GPC" TagName="SmartGridPager" Src="../Controls/SmartGridPager.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="GFC" Namespace="Common.WebControls" Assembly = "Common" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>User Maintenance</title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio 7.0">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="SubCategoryMaintenance" method="post" runat="server">
			<CDC:PageHeader ID="oPageHeader" runat="server" />
			<table width="100%">
				<tr>
					<td align="center" height="27">
						<table align="center" width="53%" border="0">
							<tr>
								<td align="center"><CBC:ButtonImage ID="btnAdd" Text="Add" OnClick="btnAdd_Click" runat="server" /></td>
								<td align="center"><CBC:ButtonImage ID="btnDelete" Text="Delete" OnClick="btnDelete_Click" runat="server" /></td>
								<td align="center"><CBC:ButtonImage ID="btnEnable" Text="Enable" OnClick="btnEnable_Click" runat="server" /></td>
								<td align="center"><CBC:ButtonImage ID="btnDisable" Text="Disable" OnClick="btnDisable_Click" runat="server" /></td>
								<td align="center"><CBC:ButtonImage ID="btnChatEnable" Text="Chat Enable" OnClick="btnButtonImage_Click" runat="server" /></td>
								<td align="center"><CBC:ButtonImage ID="btnChatDisable" Text="Chat Disable" OnClick="btnButtonImage_Click" runat="server" /></td>
								<td align="center"><CBC:ButtonImage ID="btnKickOff" Text="Kick off" OnClick="btnKickOff_Click" runat="server" /></td>
								<td align="center"><CBC:ButtonImage ID="btnSearchAgain" Text="SearchAgain" OnClick="btnSearchAgain_Click" runat="server" /></td>
								<td align="center"><CBC:ButtonImage id="btnCancel" onclick="bntGoBack_Click" runat="server" Text="Back" CausesValidation="false" /></td>
								<td align="center"><CBC:ButtonImage ID="btnSetBot" Text="Set as Bot" OnClick="btnSetBot_Click" runat="server" /></td>
								<td align="center"><CBC:ButtonImage ID="btnSetNotBot" Text="Set as not Bot" OnClick="btnSetNotBot_Click" runat="server" /></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="center">
						<GFC:gridfilter id="oFilter" runat="server" MoveHeader="true" Grid="oGrid">
							<GFC:FilterItem></GFC:FilterItem>
							<GFC:FilterItem id="edt2" Type="Edit" GridSourceParameter="@ID"></GFC:FilterItem>
							<GFC:FilterItem id="edt3" Type="Edit" GridSourceParameter="@LoginName"></GFC:FilterItem>
							<GFC:FilterItem id="edt4" Type="Edit" GridSourceParameter="@Email"></GFC:FilterItem>
							<GFC:FilterItem id="combo2" Type="Combo" GridSourceParameter="@StatusID" ComboSourceQuery="admGetDictionaryStatusAll"
								Cashed="true"></GFC:FilterItem>
							<GFC:FilterItem id="edtIdProc" Type="Edit" GridSourceParameter="@IDProc"></GFC:FilterItem>
						</GFC:gridfilter>
						<asp:datagrid id="oGrid" runat="server" AutoGenerateColumns="False" HorizontalAlign="Center" CellPadding="2"
							BorderColor="#3399FF" CssClass="cssReport cssTextMain" PageSize="50">
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
								<asp:HyperLinkColumn HeaderText="ID"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Login Name"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Email"></asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Status">
									<HeaderStyle Width="90px"></HeaderStyle>
								</asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="Chat">
									<HeaderStyle Width="90px"></HeaderStyle>
								</asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="LastLoginTime">
									<HeaderStyle Width="80px"></HeaderStyle>
								</asp:HyperLinkColumn>
								<asp:HyperLinkColumn HeaderText="TotalLoggedTime">
									<HeaderStyle Width="80px"></HeaderStyle>
								</asp:HyperLinkColumn>
								<asp:BoundColumn DataField="IsBot" HeaderText=" is Bot"></asp:BoundColumn>
							</Columns>
						</asp:datagrid>
						<GPC:SmartGridPager ID="oSGridPager" Grid="oGrid" GridFilter="oFilter" CssClass="cssReport" ItemCssClass="cssGridPagerItem"
							EditCssClass="cssGridPagerEdit" runat="server" />
					</td>
				</tr>
				<tr>
					<td>
						<br>
						<table align="center" width="53%" border="0" style="BORDER-TOP-STYLE: solid; BORDER-RIGHT-STYLE: solid; BORDER-LEFT-STYLE: solid; BORDER-BOTTOM-STYLE: solid">
							<tr>
								<td colspan="2" align="center">
									<font color="#5d89ac" size="5">Sending Message</font>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<asp:TextBox id="txtMessage" runat="server" Width="100%" TextMode="MultiLine" Height="72px"></asp:TextBox>
								</td>
							</tr>
							<tr>
								<td align="center"><CBC:ButtonImage ID="btnSendMsg" Text="Send message" OnClick="btnSendMsg_Click" runat="server" /></td>
								<td align="center"><CBC:ButtonImage ID="btnSendMsgAll" Text="Send message to All" OnClick="btnSendMsgAll_Click" runat="server" /></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<CDC:PageFooter ID="oPageFooter" runat="server" />
		</form>
	</body>
</HTML>
