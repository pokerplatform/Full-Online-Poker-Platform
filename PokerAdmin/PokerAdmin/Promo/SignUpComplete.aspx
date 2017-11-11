<%@ Page language="c#" Codebehind="SignUpComplete.aspx.cs" AutoEventWireup="false" Inherits="Promo.SignupComplete" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Signup Complete</title>
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
					<td colSpan="2"><asp:image id="oImg" Runat="server" ImageUrl="img/001-bikini-poker_nofree.gif"></asp:image></td>
				</tr>
				<tr>
					<td colSpan="2"><asp:image id="Image1" Runat="server" ImageUrl="img/002-bikini-poker.gif"></asp:image></td>
				</tr>
				<tr>
					<td vAlign="top" bgcolor="#86a8ce" width="22%"><asp:image id="Image2" Runat="server" ImageUrl="img/body_girl-poker.gif"></asp:image></td>
					<td rowSpan="1" valign="top">
						<table style="BORDER-RIGHT: #86a8ce 1px solid; BORDER-TOP: #86a8ce 1px solid; BORDER-LEFT: #013567 1px solid; BORDER-BOTTOM: #86a8ce 1px solid"
							width="97%" align="left">
							<tr>
								<td align="center">
									<table style="FONT-SIZE: x-small" height="100%">
										<tr>
											<td align="center"><br>
												<br>
												<font style="FONT-WEIGHT: bold; FONT-SIZE: large">Thank you for your application.</font>
											</td>
										</tr>
										<tr>
											<td>
												<BR>
												We will review and either approve or deny &nbsp;your application within 48 
												hours.&nbsp;
												<BR>
												Thanks again and look forward to working with you.<BR>
												<BR>
												Kind Regards,<BR>
												&nbsp;&nbsp;&nbsp; Administrator
											</td>
										</tr>
										<tr>
											<td style="FONT-WEIGHT: bold"><br>
												To signup new affiliate, please click <a href="affiliatesignup.aspx">here</a></td>
										</tr>
										<tr>
											<td style="FONT-WEIGHT: bold">To login to affiliate state page, please click <a href="affiliatestate.aspx">
													here</a></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td align="center" style="FONT-SIZE: x-small"><br><br>On any questions do not hesitate to 
									address to us , <a href="mailto:<%=GetSuppEmail()%>">
										<%=GetSuppEmail()%>
									</a>
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
