<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Page language="c#" Codebehind="sentemaildetails.aspx.cs" AutoEventWireup="false" Inherits="Admin.SentEmail.SentEmailDetails" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Sent Email Details</title>
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
								<td><CBC:BUTTONIMAGE id="btnReturn" onclick="btnReturn_Click" runat="server" Text="Back" CausesValidation="false"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table class="cssReport cssTextMain" borderColor="#3399ff" cellSpacing="0" cellPadding="2"
							align="center" width="100%" border="0">
							<tr>
								<td>Date</td>
								<td align="left"><asp:label id="lblDate" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td>Sent by</td>
								<td align="left"><asp:label id="lblBy" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td>From</td>
								<td align="left"><asp:label id="lblFrom" runat="server"></asp:label></td>
							</tr>
							<TR>
								<TD>To</TD>
								<TD align="left"><asp:label id="lblTo" runat="server"></asp:label></TD>
							</TR>
							<TR>
								<TD>Subject</TD>
								<TD align="left">
									<asp:label id="lblSubject" runat="server"></asp:label></TD>
							</TR>
							<TR>
								<TD align="left" colSpan="2">
									<FIELDSET style="BORDER-LEFT-COLOR: #3399ff; BORDER-BOTTOM-COLOR: #3399ff; BORDER-TOP-STYLE: solid; BORDER-TOP-COLOR: #3399ff; BORDER-RIGHT-STYLE: solid; BORDER-LEFT-STYLE: solid; BORDER-RIGHT-COLOR: #3399ff; BORDER-BOTTOM-STYLE: solid">
										<LEGEND align="center">
											Original Message</LEGEND>
										<TABLE>
											<TR>
												<TD align="left"><asp:textbox id="txtMessageBody" runat="server" Rows="20" TextMode="MultiLine" ReadOnly="True"
														Columns="80"></asp:textbox></TD>
											</TR>
										</TABLE>
									</FIELDSET>
								</TD>
							</TR>
						</table>
					</td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER>
		</form>
	</body>
</HTML>
