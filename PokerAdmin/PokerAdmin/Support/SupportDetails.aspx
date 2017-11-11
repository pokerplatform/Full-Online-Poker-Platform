<%@ Page language="c#" Codebehind="SupportDetails.aspx.cs" AutoEventWireup="false" Inherits="Admin.Support.SupportDetails" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Customer Request Details</title>
		<meta content="Microsoft Visual Studio 7.0" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
	</HEAD>
	<body>
		<form id="SBCategoryDatails" method="post" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table align="center" border="0">
				<tr>
					<td>
						<table align="center">
							<tr>
								<td><CBC:BUTTONIMAGE id="btnSave" onclick="btnSave_Click" runat="server" Text="Save"></CBC:BUTTONIMAGE></td>
								<td><CBC:BUTTONIMAGE id="btnReturn" onclick="btnReturn_Click" runat="server" Text="Back" CausesValidation="false"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="center"><asp:label id="lblInfo" EnableViewState="False" ForeColor="Red" Runat="server"></asp:label></td>
				</tr>
				<tr>
					<td>
						<table class="cssReport cssTextMain" borderColor="#3399ff" cellSpacing="0" cellPadding="2"
							align="center" width="100%" border="0">
							<tr>
								<td>Name</td>
								<td align="left"><asp:label id="lblUserName" runat="server"></asp:label></td>
							</tr>
							<TR>
								<TD>Login</TD>
								<TD align="left"><asp:label id="lblLogin" runat="server"></asp:label></TD>
							</TR>
							<TR>
								<TD>Email</TD>
								<TD align="left">
									<asp:textbox id="txtEmail" Runat="server" MaxLength="50" Width="250px"></asp:textbox></TD>
							</TR>
							<TR>
								<TD align="left" colSpan="2">
									<TABLE id="Table2">
										<TR>
											<TD><CBC:BUTTONIMAGE id="btnUserProfile" runat="server" Text="User Profile"></CBC:BUTTONIMAGE></TD>
											<TD><CBC:BUTTONIMAGE id="btnUser" runat="server" Text="User List"></CBC:BUTTONIMAGE></TD>
											<TD><CBC:BUTTONIMAGE id="btnUserAccount" runat="server" Text="User Account"></CBC:BUTTONIMAGE></TD>
										</TR>
									</TABLE>
								</TD>
							</TR>
							<TR>
								<TD align="left" colSpan="2" style="HEIGHT: 196px">
									<FIELDSET style="BORDER-LEFT-COLOR: #3399ff; BORDER-BOTTOM-COLOR: #3399ff; BORDER-TOP-STYLE: solid; BORDER-TOP-COLOR: #3399ff; BORDER-RIGHT-STYLE: solid; BORDER-LEFT-STYLE: solid; BORDER-RIGHT-COLOR: #3399ff; BORDER-BOTTOM-STYLE: solid">
										<LEGEND align="center">
											Original Message</LEGEND>
										<TABLE>
											<TR>
												<TD class="cssTextMain">Subject:&nbsp;<asp:label id="lblSubject" runat="server" CssClass="cssTextMain"></asp:label></TD>
											</TR>
											<TR>
												<TD align="left"><asp:textbox id="txtMessageBody" runat="server" Rows="6" TextMode="MultiLine" ReadOnly="True"
														Columns="80"></asp:textbox></TD>
											</TR>
										</TABLE>
									</FIELDSET>
								</TD>
							</TR>
							<TR>
								<TD align="left" colSpan="2">
									<FIELDSET style="BORDER-LEFT-COLOR: #3399ff; BORDER-BOTTOM-COLOR: #3399ff; BORDER-TOP-STYLE: solid; BORDER-TOP-COLOR: #3399ff; BORDER-RIGHT-STYLE: solid; BORDER-LEFT-STYLE: solid; BORDER-RIGHT-COLOR: #3399ff; BORDER-BOTTOM-STYLE: solid">
										<LEGEND align="center">
											Reply</LEGEND>
										<TABLE>
											<tr>
												<TD align="left"><asp:textbox id="txtHeader" Runat="server" Width="100%" MaxLength="50"></asp:textbox></TD>
											</tr>
											<TR>
												<TD align="left"><asp:textbox id="txtAnswer" runat="server" Rows="10" TextMode="MultiLine" Columns="80"></asp:textbox></TD>
											</TR>
											<TR>
												<TD align="left">
													<asp:label id="lblFooter" runat="server" CssClass="cssTextMain"></asp:label></TD>
											</TR>
										</TABLE>
									</FIELDSET>
								</TD>
							</TR>
							<TR>
								<TD align="left" colSpan="2">
									<TABLE id="Table1">
										<TR>
											<TD><CBC:BUTTONIMAGE id="btnHandHistory" runat="server" Text="Hand History"></CBC:BUTTONIMAGE></TD>
											<TD><CBC:BUTTONIMAGE id="btnTransactionHistory" runat="server" Text="Transaction History"></CBC:BUTTONIMAGE></TD>
										</TR>
									</TABLE>
								</TD>
							</TR>
						</table>
					</td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER><input id="hdnID" type="hidden" runat="server">
			<INPUT id="hdnUserID" type="hidden" name="hdnUserID" runat="server">
		</form>
	</body>
</HTML>
