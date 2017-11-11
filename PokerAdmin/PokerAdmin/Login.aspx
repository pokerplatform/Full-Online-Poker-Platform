<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="Controls/ButtonImage.ascx" %>
<%@ Page language="c#" Codebehind="Login.aspx.cs" AutoEventWireup="false" Inherits="Admin.Login" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Login area</title>
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="styles.css" type="text/css" rel="stylesheet">
	</HEAD>
	<body>
		<form id="Login" method="post" runat="server">
			<table height="100%" width="100%">
				<tbody>
					<tr height="40%">
						<td valign="top" align="left" colspan="3">
							<asp:image id="oImageLogo" runat="server"></asp:image>
						</td>
					</tr>
					<tr height="20%">
						<td width="30%">&nbsp;
						</td>
						<td align="center" width="40%">
							<table class="cssReport cssTextMain" bordercolor="#3399ff" height="100%" width="100%" align="center">
								<tbody>
									<tr>
										<td class="cssReportHeader" colspan="2">Please enter Login Information Here
										</td>
									</tr>
									<tr>
										<td class="cssError" colspan="2">
											<asp:label id="oError" runat="server"></asp:label>
										</td>
									</tr>
									<tr>
										<td width="50%">Login:
										</td>
										<td width="50%">
											<asp:textbox id="oLogin" runat="server" width="100%"></asp:textbox>
										</td>
									</tr>
									<tr>
										<td>Password:
										</td>
										<td>
											<asp:textbox id="oPassword" runat="server" width="100%" textmode="Password"></asp:textbox>
										</td>
									</tr>
									<tr>
										<td colspan="2">
											<asp:CheckBox id="chSaveLogin" runat="server" Text="Save my Login Info"></asp:CheckBox></td>
									</tr>
								</tbody>
							</table>
						</td>
						<td width="30%">
						</td>
					</tr>
					<tr height="30">
						<td align="center" colspan="3">
							<cbc:buttonimage id="btnLogin" onclick="btnLogin_Click" runat="server" text="Login"></cbc:buttonimage>
						</td>
					</tr>
					<tr height="40%">
						<td colspan="3">
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</body>
</HTML>
