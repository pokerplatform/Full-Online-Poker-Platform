<%@ Page language="c#" Codebehind="UserDetails.aspx.cs" AutoEventWireup="false" Inherits="Admin.Users.UserDetails" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>User Details</title>
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
				<TBODY>
					<tr>
						<td>
							<table align="center">
								<tr>
									<td><CBC:BUTTONIMAGE id="btnSave" onclick="btnSave_Click" runat="server" Text="Save"></CBC:BUTTONIMAGE></td>
									<td><CBC:BUTTONIMAGE id="btnCancel" onclick="bntGoBack_Click" runat="server" Text="Back" CausesValidation="false"></CBC:BUTTONIMAGE></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td align="center"><asp:label id="lblInfo" Runat="server" ForeColor="Red" EnableViewState="False"></asp:label></td>
					</tr>
					<tr>
						<td>
							<table class="cssReport cssTextMain" borderColor="#3399ff" cellSpacing="0" cellPadding="2"
								width="100%" align="center" border="1">
								<TBODY>
									<tr>
										<td colspan="2" align="center">
											<asp:Label id="lbUserInfo" runat="server" Width="100%"></asp:Label>
										</td>
									</tr>
									<tr>
										<td>
											<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ErrorMessage="Enter " ControlToValidate="txtFirstName"
												Display="Dynamic"></asp:RequiredFieldValidator>FirstName</td>
										<td align="left"><asp:textbox id="txtFirstName" Runat="server" MaxLength="50"></asp:textbox></td>
									</tr>
									<TR>
										<TD>
											<asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ErrorMessage="Enter " ControlToValidate="txtLastName"
												Display="Dynamic"></asp:RequiredFieldValidator>LastName</TD>
										<TD align="left"><asp:textbox id="txtLastName" Runat="server" MaxLength="50"></asp:textbox></TD>
									</TR>
									<TR>
										<TD>
											<asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" ErrorMessage="Enter " ControlToValidate="txtEmail"
												Display="Dynamic"></asp:RequiredFieldValidator>
											<asp:regularexpressionvalidator id="RegularExpressionValidatorEmail" Runat="server" Display="Dynamic" ControlToValidate="txtEmail"
												ErrorMessage="Enter&amp;nbsp;valid&amp;nbsp;" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:regularexpressionvalidator>Email</TD>
										<TD align="left"><asp:textbox id="txtEmail" Runat="server" MaxLength="50"></asp:textbox></TD>
									</TR>
									<TR>
										<TD>Location</TD>
										<TD align="left"><asp:textbox id="txtLocation" Runat="server" MaxLength="50"></asp:textbox></TD>
									</TR>
									<tr>
										<td>Sex</td>
										<td align="left"><asp:dropdownlist id="comboSex" Runat="server"></asp:dropdownlist></td>
									</tr>
									<TR>
										<TD>Address</TD>
										<TD align="left">
											<asp:textbox id="txtAddress" Runat="server" MaxLength="50"></asp:textbox></TD>
									</TR>
									<TR>
										<TD>City</TD>
										<TD align="left">
											<asp:textbox id="txtCity" Runat="server" MaxLength="50"></asp:textbox></TD>
									</TR>
									<TR>
										<TD>State</TD>
										<TD align="left">
											<asp:dropdownlist id="comboState" Runat="server"></asp:dropdownlist></TD>
									</TR>
									<TR>
										<TD>Zip</TD>
										<TD align="left">
											<asp:textbox id="txtZip" Runat="server" MaxLength="50"></asp:textbox></TD>
									</TR>
									<TR>
										<TD>Country</TD>
										<TD align="left">
											<asp:dropdownlist id="comboCountry" Runat="server"></asp:dropdownlist></TD>
									</TR>
									<TR>
										<TD>Phone</TD>
										<TD align="left">
											<asp:textbox id="txtPhone" Runat="server" MaxLength="50"></asp:textbox></TD>
									</TR>
									<tr>
										<td>Status</td>
										<td align="left"><asp:dropdownlist id="comboStatus" Runat="server"></asp:dropdownlist></td>
									</tr>
									<tr>
										<td>Chat</td>
										<td align="left"><asp:CheckBox id="ChatCheck" runat="server" Text=" "></asp:CheckBox></td>
									</tr>
									<TR>
										<TD align="center" colSpan="2">
											<hr>
											<asp:Label id="lblPasswordWarning" runat="server" Font-Size="Smaller">Please left password fields blank if you do not want to change them</asp:Label></TD>
									</TR>
									<TR>
										<TD align="center" colSpan="2">
											<asp:CustomValidator id="CustomValidator1" runat="server" Display="Dynamic" ControlToValidate="txtLogin"
												ErrorMessage="Password and retype password do not match" ClientValidationFunction="ComparePassword"></asp:CustomValidator></TD>
									</TR>
									<TR>
										<TD>
											<asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" ErrorMessage="Enter " ControlToValidate="txtLogin"
												Display="Dynamic"></asp:RequiredFieldValidator>Login</TD>
										<TD align="left">
											<asp:textbox id="txtLogin" Runat="server" MaxLength="50"></asp:textbox></TD>
									</TR>
									<TR>
										<TD>
											<asp:RequiredFieldValidator id="ReqValidatorPassword" runat="server" ErrorMessage="Enter " ControlToValidate="txtPassword"
												Display="Dynamic" Visible="False"></asp:RequiredFieldValidator>Password</TD>
										<TD align="left">
											<asp:textbox id="txtPassword" Runat="server" MaxLength="50" TextMode="Password"></asp:textbox></TD>
									</TR>
									<TR>
										<TD>
											<asp:RequiredFieldValidator id="ReqValidatorRetypePassword" runat="server" ErrorMessage="Enter " ControlToValidate="txtRetypePassword"
												Display="Dynamic" Visible="False"></asp:RequiredFieldValidator>Retype 
											Password</TD>
										<TD align="left">
											<asp:textbox id="txtRetypePassword" Runat="server" MaxLength="50" TextMode="Password"></asp:textbox></TD>
									</TR>
									<TR>
										<TD colSpan="2" width="100">
											<table>
												<tr>
													<td>
														<CBC:BUTTONIMAGE id="btnUserAccount" onclick="btnUserAccount_Click" runat="server" Text="User Account"
															CausesValidation="false"></CBC:BUTTONIMAGE></td>
													<td><CBC:BUTTONIMAGE id="btnUserSession" onclick="btnUserSession_Click" runat="server" Text="User Session"
															CausesValidation="false"></CBC:BUTTONIMAGE></td>
												</tr>
											</table>
										</TD>
									</TR>
								</TBODY>
							</table>
						</td>
					</tr>
					<tr id="rowStats" runat="server">
						<td align="center"></td>
					</tr>
					<tr id="rowRelatedProcesses" runat="server">
						<td align="center"><br>
						</td>
					</tr>
				</TBODY>
			</table>
			<table class="cssReport cssTextMain" borderColor="#3399ff" cellSpacing="0" cellPadding="2"
				width="80%" align="center" border="1">
				<tr>
					<td align="center">
						<asp:datagrid id="oGrid" runat="server" AutoGenerateColumns="False" HorizontalAlign="Center" CellPadding="2"
							BorderColor="#3399FF" CssClass="cssReport cssTextMain" PageSize="15" AllowPaging="True">
							<AlternatingItemStyle CssClass="cssReportItemOdd"></AlternatingItemStyle>
							<ItemStyle CssClass="cssReportItem"></ItemStyle>
							<HeaderStyle CssClass="cssReportHeader"></HeaderStyle>
							<Columns>
								<asp:BoundColumn DataField="SessionID" HeaderText="Session ID"></asp:BoundColumn>
								<asp:BoundColumn DataField="ClientIP" HeaderText="IP"></asp:BoundColumn>
								<asp:BoundColumn DataField="InternalClientHost" HeaderText="Host"></asp:BoundColumn>
								<asp:BoundColumn DataField="SessionStart" HeaderText="Session Start"></asp:BoundColumn>
								<asp:BoundColumn DataField="SessionEnd" HeaderText="Session End"></asp:BoundColumn>
							</Columns>
							<PagerStyle HorizontalAlign="Left" Mode="NumericPages"></PagerStyle>
						</asp:datagrid>
					</td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER><input id="hdnUserID" type="hidden" runat="server">
		</form>
		<script>
  function ComparePassword(val, args){
    args.IsValid = (document.UserDetails.txtPassword.value==document.UserDetails.txtRetypePassword.value);
  }
		</script>
		</TD></TR></TBODY></TABLE></TD></TR></TBODY></TABLE></FORM>
	</body>
</HTML>
