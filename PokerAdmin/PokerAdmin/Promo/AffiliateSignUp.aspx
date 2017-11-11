<%@ Page language="c#" Codebehind="AffiliateSignUp.aspx.cs" AutoEventWireup="false" Inherits="Promo.AffiliateSignup" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Affiliate Signup</title>
		<meta content="False" name="vs_showGrid">
		<meta content="Microsoft Visual Studio 7.0" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="<%=GetCssPageUrl()%>" type=text/css 
rel=stylesheet>
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="UserDetails" method="post" runat="server">
			<table cellSpacing="0" cellPadding="0" width="80%" align="left" border="0">
				<tr>
					<td colSpan="2"><asp:image id="oImg" Runat="server" ImageUrl="img/001-bikini-poker.jpg"></asp:image></td>
				</tr>
				<tr>
					<td colSpan="2"><asp:image id="Image1" Runat="server" ImageUrl="img/002-bikini-poker.gif"></asp:image></td>
				</tr>
				<tr>
					<td vAlign="top" bgcolor="#86a8ce"><asp:image id="Image2" Runat="server" ImageUrl="img/body_girl-poker.gif"></asp:image></td>
					<td rowSpan="1" valign="top">
						<table style="BORDER-RIGHT: #86a8ce 1px solid; BORDER-TOP: #86a8ce 1px solid; BORDER-LEFT: #013567 1px solid; BORDER-BOTTOM: #86a8ce 1px solid"
							width="97%" align="left">
							<tr>
								<td>
									<table border="0" >
										<TR>
											<TD align="center" style="FONT-WEIGHT: bolder; FONT-SIZE: x-small">Select Skin:
												<asp:dropdownlist id="ddSkins" runat="server" AutoPostBack="True"></asp:dropdownlist></TD>
										<TR>
											<TD align="center"><asp:label id="lblInfo" Runat="server" EnableViewState="False" ForeColor="Red"></asp:label></TD>
										</TR>
										<TR>
											<TD>
												<br>
												<DIV style="FONT-SIZE: x-small">Enter login id and password to login to the 
													Affiliate Section of the site.</DIV>
												<br>
												<TABLE class="cssReport cssTextMain" borderColor="#0099cc" cellSpacing="0" cellPadding="2"
													width="100%" align="center" border="1">
													<TR>
														<TD style="WIDTH: 160px" align="left"><asp:requiredfieldvalidator id="RequiredFieldValidator1" runat="server" ErrorMessage="Enter " ControlToValidate="txtName"
																Display="Dynamic"></asp:requiredfieldvalidator>Login</TD>
														<TD align="left"><asp:textbox id="txtName" Runat="server" MaxLength="50" Width="100%"></asp:textbox></TD>
													</TR>
													<TR>
														<TD style="WIDTH: 160px" align="left"><asp:requiredfieldvalidator id="Requiredfieldvalidator3" runat="server" ErrorMessage="Enter " ControlToValidate="txtPassword"
																Display="Dynamic"></asp:requiredfieldvalidator>Password</TD>
														<TD align="left"><asp:textbox id="txtPassword" Runat="server" MaxLength="50" Width="100%" TextMode="Password"></asp:textbox></TD>
													</TR>
													<TR>
														<TD style="WIDTH: 160px" align="left"><asp:requiredfieldvalidator id="Requiredfieldvalidator4" runat="server" ErrorMessage="Enter " ControlToValidate="txtPasswordRet"
																Display="Dynamic"></asp:requiredfieldvalidator>Re-Type Password</TD>
														<TD align="left"><asp:textbox id="txtPasswordRet" Runat="server" MaxLength="50" Width="100%" TextMode="Password"></asp:textbox></TD>
													</TR>
												</TABLE>
												<br>
												<DIV style="FONT-SIZE: x-small">Beneficiary Information</DIV>
												<DIV style="FONT-SIZE: x-small">Payments will be made payable to the beneficiary 
													(as written below) at the address provided below.</DIV>
												<br>
												<TABLE class="cssReport cssTextMain" borderColor="#0099cc" cellSpacing="0" cellPadding="2"
													width="100%" align="center" border="1">
													<TR>
														<TD style="WIDTH: 160px" align="left"><asp:requiredfieldvalidator id="Requiredfieldvalidator9" runat="server" ErrorMessage="Enter " ControlToValidate="txtBeneficiaryName"
																Display="Dynamic"></asp:requiredfieldvalidator>Beneficiary Name
														</TD>
														<TD align="left"><asp:textbox id="txtBeneficiaryName" Runat="server" MaxLength="50" Width="100%"></asp:textbox></TD>
													</TR>
													<TR>
														<TD style="WIDTH: 160px" align="left"><asp:requiredfieldvalidator id="Requiredfieldvalidator10" runat="server" ErrorMessage="Enter " ControlToValidate="txtAddress"
																Display="Dynamic"></asp:requiredfieldvalidator>Mailing Address</TD>
														<TD align="left"><asp:textbox id="txtAddress" Runat="server" MaxLength="255" Width="100%"></asp:textbox></TD>
													</TR>
													<TR>
														<TD style="WIDTH: 160px" align="left"><asp:requiredfieldvalidator id="Requiredfieldvalidator11" runat="server" ErrorMessage="Enter " ControlToValidate="txtCity"
																Display="Dynamic"></asp:requiredfieldvalidator>City</TD>
														<TD align="left"><asp:textbox id="txtCity" Runat="server" MaxLength="50" Width="100%"></asp:textbox></TD>
													</TR>
													<TR>
														<TD style="WIDTH: 160px" align="left">State</TD>
														<TD align="left"><asp:dropdownlist id="ddState" runat="server" Width="100%"></asp:dropdownlist></TD>
													</TR>
													<TR>
														<TD style="WIDTH: 160px" align="left"><asp:requiredfieldvalidator id="Requiredfieldvalidator12" runat="server" ErrorMessage="Enter " ControlToValidate="txtZip"
																Display="Dynamic"></asp:requiredfieldvalidator>Zip</TD>
														<TD align="left"><asp:textbox id="txtZip" Runat="server" MaxLength="50" Width="100%"></asp:textbox></TD>
													</TR>
													<TR>
														<TD style="WIDTH: 160px" align="left">Country</TD>
														<TD align="left"><asp:dropdownlist id="ddCountry" runat="server" Width="100%"></asp:dropdownlist></TD>
													</TR>
												</TABLE>
												<br>
												<DIV style="FONT-SIZE: x-small">Enter the name and contact information of person to 
													be responsible for the Affiliate Account and above listed Beneficiary. 
													Communication about payments and promotions will be addressed to this person.</DIV>
												<br>
												<TABLE class="cssReport cssTextMain" borderColor="#0099cc" cellSpacing="0" cellPadding="2"
													width="100%" align="center" border="1">
													<TR>
														<TD style="WIDTH: 160px" align="left"><asp:requiredfieldvalidator id="Requiredfieldvalidator5" runat="server" ErrorMessage="Enter " ControlToValidate="txtFirstName"
																Display="Dynamic"></asp:requiredfieldvalidator>First Name
														</TD>
														<TD align="left"><asp:textbox id="txtFirstName" Runat="server" MaxLength="50" Width="100%"></asp:textbox></TD>
													</TR>
													<TR>
														<TD style="WIDTH: 160px" align="left"><asp:requiredfieldvalidator id="Requiredfieldvalidator6" runat="server" ErrorMessage="Enter " ControlToValidate="txtLastName"
																Display="Dynamic"></asp:requiredfieldvalidator>Last Name
														</TD>
														<TD align="left"><asp:textbox id="txtLastName" Runat="server" MaxLength="50" Width="100%"></asp:textbox></TD>
													</TR>
													<TR>
														<TD style="WIDTH: 160px" align="left"><asp:requiredfieldvalidator id="Requiredfieldvalidator7" runat="server" ErrorMessage="Enter " ControlToValidate="txtTitle"
																Display="Dynamic"></asp:requiredfieldvalidator>Title</TD>
														<TD align="left"><asp:textbox id="txtTitle" Runat="server" MaxLength="50" Width="100%"></asp:textbox></TD>
													</TR>
													<TR>
														<TD style="WIDTH: 160px" align="left"><asp:requiredfieldvalidator id="Requiredfieldvalidator2" runat="server" ErrorMessage="Enter " ControlToValidate="txtEmail"
																Display="Dynamic"></asp:requiredfieldvalidator>Email
															<asp:regularexpressionvalidator id="RegularExpressionValidator1" runat="server" ErrorMessage="Enter valid Email"
																ControlToValidate="txtEmail" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:regularexpressionvalidator></TD>
														<TD align="left"><asp:textbox id="txtEmail" Runat="server" MaxLength="50" Width="100%"></asp:textbox></TD>
													</TR>
													<TR>
														<TD style="WIDTH: 160px" align="left"><asp:requiredfieldvalidator id="Requiredfieldvalidator8" runat="server" ErrorMessage="Enter " ControlToValidate="txtPhone"
																Display="Dynamic"></asp:requiredfieldvalidator>Phone</TD>
														<TD align="left"><asp:textbox id="txtPhone" Runat="server" MaxLength="50" Width="100%"></asp:textbox></TD>
													</TR>
													<TR>
														<TD style="WIDTH: 160px" align="left">Fax (Optional)</TD>
														<TD align="left"><asp:textbox id="txtFax" Runat="server" MaxLength="50" Width="100%"></asp:textbox></TD>
													</TR>
												</TABLE>
											</TD>
										</TR>
										<TR>
											<TD>
												<TABLE align="center">
													<TR>
														<TD style="FONT-WEIGHT: bold; FONT-SIZE: x-small"><asp:checkbox id="chAgree" runat="server" Text="I have read and agreed to the"></asp:checkbox><A href="AffiliateAgreement.aspx">&nbsp;Affiliate 
																Agreement</A>.</TD>
													</TR>
													<TR>
														<TD align="center"><asp:button id="btnSignUp" runat="server" Text="Signup"></asp:button></TD>
													</TR>
												</TABLE>
											</TD>
										</TR>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="1" bgcolor="#86a8ce">&nbsp;</td>
					<td></td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
