<%@ Page language="c#" Codebehind="AffiliateDetails.aspx.cs" AutoEventWireup="false" Inherits="Admin.Affiliate.AffiliateDetails" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Affiliate Details</title>
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
								<td align="left">Skin</td>
								<td align="left">
									<asp:DropDownList id="ddSkins" runat="server" Width="100%"></asp:DropDownList></td>
							</tr>
							<tr>
								<td align="left">
									<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ErrorMessage="Enter " ControlToValidate="txtName"
										Display="Dynamic"></asp:RequiredFieldValidator>Name</td>
								<td align="left"><asp:textbox id="txtName" Runat="server" MaxLength="50" Width="100%"></asp:textbox></td>
							</tr>
							<tr>
								<td align="left">
									<asp:RequiredFieldValidator id="Requiredfieldvalidator2" runat="server" ErrorMessage="Enter " ControlToValidate="txtEmail"
										Display="Dynamic"></asp:RequiredFieldValidator>Email
									<asp:RegularExpressionValidator id="RegularExpressionValidator1" runat="server" ErrorMessage="Enter valid Email"
										ControlToValidate="txtEmail" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator></td>
								<td align="left"><asp:textbox id="txtEmail" Runat="server" MaxLength="50" Width="100%"></asp:textbox></td>
							</tr>
							<tr>
								<td align="left">Status</td>
								<td align="left">
									<asp:DropDownList id="ddStatus" runat="server"></asp:DropDownList>
									<asp:CheckBox id="chDeny" runat="server" Text="Deny" Enabled="False"></asp:CheckBox></td>
							</tr>
							<tr>
								<td style="WIDTH: 160px" align="left"><asp:requiredfieldvalidator id="Requiredfieldvalidator3" runat="server" ErrorMessage="Enter " ControlToValidate="txtPassword"
										Display="Dynamic"></asp:requiredfieldvalidator>Password</td>
								<td align="left"><asp:textbox id="txtPassword" Runat="server" MaxLength="50" Width="100%" TextMode="Password"></asp:textbox></td>
							</tr>
							<tr>
								<td style="WIDTH: 160px" align="left"><asp:requiredfieldvalidator id="Requiredfieldvalidator9" runat="server" ErrorMessage="Enter " ControlToValidate="txtBeneficiaryName"
										Display="Dynamic"></asp:requiredfieldvalidator>Beneficiary Name
								</td>
								<td align="left"><asp:textbox id="txtBeneficiaryName" Runat="server" MaxLength="50" Width="100%"></asp:textbox></td>
							</tr>
							<tr>
								<td style="WIDTH: 160px" align="left"><asp:requiredfieldvalidator id="Requiredfieldvalidator10" runat="server" ErrorMessage="Enter " ControlToValidate="txtAddress"
										Display="Dynamic"></asp:requiredfieldvalidator>Mailing Address</td>
								<td align="left"><asp:textbox id="txtAddress" Runat="server" MaxLength="255" Width="100%"></asp:textbox></td>
							</tr>
							<tr>
								<td style="WIDTH: 160px" align="left"><asp:requiredfieldvalidator id="Requiredfieldvalidator11" runat="server" ErrorMessage="Enter " ControlToValidate="txtCity"
										Display="Dynamic"></asp:requiredfieldvalidator>City</td>
								<td align="left"><asp:textbox id="txtCity" Runat="server" MaxLength="50" Width="100%"></asp:textbox></td>
							</tr>
							<tr>
								<td style="WIDTH: 160px" align="left">State</td>
								<td align="left">
									<asp:DropDownList id="ddState" runat="server" Width="100%"></asp:DropDownList></td>
							</tr>
							<tr>
								<td style="WIDTH: 160px" align="left"><asp:requiredfieldvalidator id="Requiredfieldvalidator12" runat="server" ErrorMessage="Enter " ControlToValidate="txtZip"
										Display="Dynamic"></asp:requiredfieldvalidator>Zip</td>
								<td align="left"><asp:textbox id="txtZip" Runat="server" MaxLength="50" Width="100%"></asp:textbox></td>
							</tr>
							<tr>
								<td style="WIDTH: 160px" align="left">Country</td>
								<td align="left">
									<asp:DropDownList id="ddCountry" runat="server" Width="100%"></asp:DropDownList></td>
							</tr>
							<tr>
								<td style="WIDTH: 160px" align="left"><asp:requiredfieldvalidator id="Requiredfieldvalidator5" runat="server" ErrorMessage="Enter " ControlToValidate="txtFirstName"
										Display="Dynamic"></asp:requiredfieldvalidator>First Name
								</td>
								<td align="left"><asp:textbox id="txtFirstName" Runat="server" MaxLength="50" Width="100%"></asp:textbox></td>
							</tr>
							<tr>
								<td style="WIDTH: 160px" align="left"><asp:requiredfieldvalidator id="Requiredfieldvalidator6" runat="server" ErrorMessage="Enter " ControlToValidate="txtLastName"
										Display="Dynamic"></asp:requiredfieldvalidator>Last Name
								</td>
								<td align="left"><asp:textbox id="txtLastName" Runat="server" MaxLength="50" Width="100%"></asp:textbox></td>
							</tr>
							<tr>
								<td style="WIDTH: 160px" align="left"><asp:requiredfieldvalidator id="Requiredfieldvalidator7" runat="server" ErrorMessage="Enter " ControlToValidate="txtTitle"
										Display="Dynamic"></asp:requiredfieldvalidator>Title</td>
								<td align="left"><asp:textbox id="txtTitle" Runat="server" MaxLength="50" Width="100%"></asp:textbox></td>
							</tr>
							<tr>
								<td style="WIDTH: 160px" align="left"><asp:requiredfieldvalidator id="Requiredfieldvalidator8" runat="server" ErrorMessage="Enter " ControlToValidate="txtPhone"
										Display="Dynamic"></asp:requiredfieldvalidator>Phone</td>
								<td align="left"><asp:textbox id="txtPhone" Runat="server" MaxLength="50" Width="100%"></asp:textbox></td>
							</tr>
							<tr>
								<td style="WIDTH: 160px" align="left">Fax (Optional)</td>
								<td align="left"><asp:textbox id="txtFax" Runat="server" MaxLength="50" Width="100%"></asp:textbox></td>
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
