<%@ Page language="c#" Codebehind="NewsDetails.aspx.cs" AutoEventWireup="false" Inherits="Admin.News.NewsDetails" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>News Details</title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio 7.0">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="OutcomeDetails" method="post" runat="server">
			<CDC:PageHeader ID="oPageHeader" runat="server" />
			<table width="60%" align="center" border="0">
				<tr>
					<td>
						<table align="center">
							<tr>
								<td><CBC:BUTTONIMAGE id="btnSave" onclick="btnSave_Click" runat="server" Text="Save"></CBC:BUTTONIMAGE></td>
								<td><CBC:BUTTONIMAGE id="btnCancel" NavigateUrl="javascript:history.go(-1)" runat="server" Text="Event" CausesValidation="false"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="middle"><asp:label id="lblInfo" EnableViewState="False" ForeColor="Red" Runat="server"></asp:label></td>
				</tr>
				<tr>
					<td>
						<table class="cssReport cssTextMain" borderColor="#3399ff" cellSpacing="0" cellPadding="2" width="100%" align="center" border="1">
							<tr>
								<td width="30%">Subject&nbsp;
									<asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ErrorMessage="RequiredFieldValidator" ControlToValidate="txtSubject" Display="Dynamic"> can not be empty</asp:RequiredFieldValidator></td>
								<td align="left"><asp:textbox id="txtSubject" Width="100%" Runat="server" MaxLength="150"></asp:textbox></td>
							</tr>
							<tr>
								<td>Body</td>
								<td align="left"><asp:TextBox ID="txtBody" TextMode="MultiLine" Rows="8" Runat="server" Width="100%"></asp:TextBox></td>
							</tr>
							<TR>
								<TD>Date</TD>
								<TD align="left">
									<asp:Label id="lblDate" runat="server"></asp:Label></TD>
							</TR>
						</table>
					</td>
				</tr>
			</table>
			<input type="hidden" id="hdnNewsID" runat="server" NAME="hdnNewsID"> <input type="hidden" id="hdnEventID" runat="server" NAME="hdnEventID">
			<CDC:PageFooter ID="oPageFooter" runat="server" />
		</form>
	</body>
</HTML>
