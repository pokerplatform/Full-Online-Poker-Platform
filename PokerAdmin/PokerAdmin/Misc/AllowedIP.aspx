<%@ Page language="c#" Codebehind="AllowedIP.aspx.cs" AutoEventWireup="false" Inherits="Admin.Misc.AllowedIP" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>AllowedIP</title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio 7.0">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	</HEAD>
	<body>
		<form id="AllowedIP" method="post" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<p align="center">
				<asp:CheckBoxList id="chkIpList" DataTextField="IP" DataValueField="IP" runat="server"></asp:CheckBoxList>
				<asp:TextBox ID="txtIP" Runat="server" MaxLength="24"></asp:TextBox><br>
				<asp:RegularExpressionValidator id="RegularExpressionValidator1" runat="server" ErrorMessage="RegularExpressionValidator" ControlToValidate="txtIP" Display="Dynamic" ValidationExpression="([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])">Invalid IP value</asp:RegularExpressionValidator>
				<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ErrorMessage="RequiredFieldValidator" ControlToValidate="txtIP" Display="Dynamic">IP address required</asp:RequiredFieldValidator>
			</p>
			<CBC:BUTTONIMAGE id="btnAdd" onclick="btnAdd_click" runat="server" Text="Add"></CBC:BUTTONIMAGE>
			<CBC:BUTTONIMAGE id="btnDelete" CausesValidation="False" onclick="btnDelete_click" runat="server" Text="Delete"></CBC:BUTTONIMAGE>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER>
		</form>
	</body>
</HTML>
