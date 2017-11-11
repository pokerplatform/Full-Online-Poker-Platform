<%@ Page language="c#" Codebehind="ClosePlayPeriod.aspx.cs" AutoEventWireup="false" Inherits="Admin.Misc.ClosePlayPeriod" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Close Play Period</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="Form1" method="post" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="90%" align="center">
				<tr>
					<td align="center"><br>
						<br>
						<asp:label id="lbStatus" Runat="server"></asp:label></td>
				</tr>
				<tr>
					<td align="center">
						<table>
							<tr>
								<td><CBC:BUTTONIMAGE id="btSystemShut" onclick="btSystemShut_Click" runat="server" Text="Gracefull shutdown"></CBC:BUTTONIMAGE></td>
								<td><CBC:BUTTONIMAGE id="btEnableCln" onclick="btEnableCln_Click" runat="server" Text="Enable Client Connections"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="center"><asp:checkbox id="chAsResendTB" runat="server" Text="Resend report"></asp:checkbox></td>
				</tr>
				<tr>
					<td align="center"><asp:datagrid id="dgPeriod" runat="server" AutoGenerateColumns="False" Width="100%" BorderColor="#3399FF"
							CssClass="cssReport cssTextMain" AllowPaging="True">
							<AlternatingItemStyle CssClass="cssReportItemOdd"></AlternatingItemStyle>
							<ItemStyle CssClass="cssReportItem"></ItemStyle>
							<HeaderStyle CssClass="cssReportHeader"></HeaderStyle>
							<Columns>
								<asp:BoundColumn DataField="ID" ReadOnly="True" HeaderText="ID"></asp:BoundColumn>
								<asp:BoundColumn DataField="DateFrom" HeaderText="Date From" DataFormatString="{0:G}"></asp:BoundColumn>
								<asp:BoundColumn DataField="DateTo" HeaderText="Date To" DataFormatString="{0:G}"></asp:BoundColumn>
								<asp:EditCommandColumn ButtonType="LinkButton" UpdateText="Update" CancelText="Cancel" EditText="Edit"></asp:EditCommandColumn>
								<asp:ButtonColumn Text="Delete" CommandName="Delete"></asp:ButtonColumn>
								<asp:ButtonColumn Text="Report" CommandName="Report"></asp:ButtonColumn>
								<asp:ButtonColumn Text="Close" CommandName="Reset"></asp:ButtonColumn>
								<asp:BoundColumn DataField="IsClosed" ReadOnly="True" HeaderText="Closed"></asp:BoundColumn>
							</Columns>
							<PagerStyle HorizontalAlign="Left" Mode="NumericPages"></PagerStyle>
						</asp:datagrid></td>
				</tr>
				<tr>
					<td align="center"><CBC:BUTTONIMAGE id="btnAddRow" onclick="btnAddRow_Click" runat="server" Text="Add Row"></CBC:BUTTONIMAGE></td>
				</tr>
				<tr>
					<td><br>
						<br>
						<table style="BORDER-TOP-STYLE: solid; BORDER-RIGHT-STYLE: solid; BORDER-LEFT-STYLE: solid; BORDER-BOTTOM-STYLE: solid"
							width="53%" align="center" border="0">
							<tr>
								<td align="center" colSpan="2"><font color="#5d89ac" size="5">Weekly Report</font>
								</td>
							</tr>
							<tr>
								<td align="center" colSpan="2"><asp:checkbox id="chAsSecondary" runat="server" Text="Resend"></asp:checkbox></td>
							</tr>
							<tr>
								<td width="50%">From&nbsp;
									<asp:textbox id="txtFrom" runat="server"></asp:textbox></td>
								<td width="50%">To&nbsp;
									<asp:textbox id="txtTo" runat="server"></asp:textbox></td>
							</tr>
							<tr>
								<td align="center" colSpan="2"><CBC:BUTTONIMAGE id="btnCreateWeekly" onclick="btnCreateWeekly_Click" runat="server" Text="Create Report"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER><INPUT id="hdnDisbledItem" type="hidden" runat="server">
		</form>
	</body>
</HTML>
