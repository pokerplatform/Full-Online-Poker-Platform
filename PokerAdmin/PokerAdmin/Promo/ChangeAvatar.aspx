<%@ Page language="c#" Codebehind="ChangeAvatar.aspx.cs" AutoEventWireup="false" Inherits="Promo.ChangeAvatar" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Change Avatar</title>
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
			<table cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
				<tr>
					<td width="150"><asp:image id="oImageLogo" Runat="server"></asp:image></td>
					<td class="cssPageName" align="center">Change Avatar</td>
				</tr>
			</table>
			<table width="60%" align="center" border="0">
				<tr>
					<td>
						<table align="center">
							<tr>
								<td><asp:button id="btnChangeAvatar" runat="server" Text="Change Avatar"></asp:button></td>
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
							<tr>
								<td style="WIDTH: 220px" align="left">Login</td>
								<td align="left"><asp:textbox id="txtLogin" Runat="server" Width="100%" MaxLength="50"></asp:textbox></td>
							</tr>
							<tr>
								<td style="WIDTH: 220px" align="left">Password</td>
								<td align="left"><asp:textbox id="txtPassword" Runat="server" Width="100%" MaxLength="50" textmode="Password"></asp:textbox></td>
							</tr>
							<tr>
								<td style="WIDTH: 220px" align="left">Avatar</td>
								<td align="left"><INPUT id="iFile" type="file" size="30" runat="server"></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<input id="hdnUserID" type="hidden" name="hdnUserID" runat="server"> <INPUT id="hdnLoginName" type="hidden" runat="server">
		</form>
	</body>
</HTML>
