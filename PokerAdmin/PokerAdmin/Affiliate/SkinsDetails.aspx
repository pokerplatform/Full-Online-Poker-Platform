<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Page language="c#" Codebehind="SkinsDetails.aspx.cs" AutoEventWireup="false" Inherits="Admin.Affiliate.SkinsDetails" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Skins Details</title>
		<meta content="False" name="vs_showGrid">
		<meta content="Microsoft Visual Studio 7.0" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="UserDetails" method="post" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="60%" align="center" border="0">
				<tr>
					<td>
						<table align="center">
							<tr>
								<td><CBC:BUTTONIMAGE id="btnSave" onclick="btnSave_Click" runat="server" Text="Save"></CBC:BUTTONIMAGE></td>
								<td><CBC:BUTTONIMAGE id="btnCancel" onclick="btnReturn_Click" runat="server" Text="Back" CausesValidation="false"></CBC:BUTTONIMAGE></td>
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
							width="100%" align="center" border="1">
							<tr>
								<td align="left" style="WIDTH: 175px">
									<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ErrorMessage="Enter " ControlToValidate="txtName"
										Display="Dynamic"></asp:RequiredFieldValidator>Name</td>
								<td align="left"><asp:textbox id="txtName" Runat="server" MaxLength="50" Width="100%"></asp:textbox></td>
							</tr>
							<tr>
								<td align="left" style="WIDTH: 175px">
									<asp:RequiredFieldValidator id="Requiredfieldvalidator2" runat="server" ErrorMessage="Enter " ControlToValidate="txtEmail"
										Display="Dynamic"></asp:RequiredFieldValidator>Email
									<asp:RegularExpressionValidator id="RegularExpressionValidator1" runat="server" ErrorMessage="Enter valid Email"
										ControlToValidate="txtEmail" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator></td>
								<td align="left"><asp:textbox id="txtEmail" Runat="server" MaxLength="50" Width="100%"></asp:textbox></td>
							</tr>
							<tr>
								<td align="left" style="WIDTH: 175px">Status</td>
								<td align="left">
									<asp:DropDownList id="ddStatus" runat="server"></asp:DropDownList>
									<asp:CheckBox id="chDeny" runat="server" Text="Deny" Enabled="False"></asp:CheckBox></td>
							</tr>
							<tr>
								<td align="left" style="WIDTH: 175px">
									<asp:RequiredFieldValidator id="Requiredfieldvalidator3" runat="server" ErrorMessage="Enter " ControlToValidate="txtDomain"
										Display="Dynamic"></asp:RequiredFieldValidator>Domain</td>
								<td align="left"><asp:textbox id="txtDomain" Runat="server" MaxLength="50" Width="100%"></asp:textbox></td>
							</tr>
							<tr>
								<td align="left" style="WIDTH: 175px">
									<asp:RequiredFieldValidator id="Requiredfieldvalidator4" runat="server" ErrorMessage="Enter " ControlToValidate="txtSuppEmail"
										Display="Dynamic"></asp:RequiredFieldValidator>Support's Email
									<asp:RegularExpressionValidator id="Regularexpressionvalidator2" runat="server" ErrorMessage="Enter valid Email"
										ControlToValidate="txtSuppEmail" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator></td>
								<td align="left"><asp:textbox id="txtSuppEmail" Runat="server" MaxLength="50" Width="100%"></asp:textbox></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER><input id="hdnAffiliateID" type="hidden" name="hdnAffiliateID" runat="server">
			<INPUT type="hidden" id="hdnState" runat="server">
		</form>
	</body>
</HTML>
