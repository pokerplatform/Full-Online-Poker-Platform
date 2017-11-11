<%@ Register TagPrefix="uc1" TagName="Bots" Src="../Controls/Bots.ascx" %>
<%@ Page language="c#" Codebehind="Bots.aspx.cs" AutoEventWireup="false" Inherits="Admin.Games.Bots" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Bots</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="Form1" method="post" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table class="cssTextMain" width="90%" align="center">
				<tr>
					<td align="center"><uc1:bots id="botProcess" runat="server"></uc1:bots></td>
				</tr>
				<tr>
					<td align="center"><uc1:bots id="botTourn" runat="server"></uc1:bots></td>
				</tr>
				<tr>
					<td align="center"><uc1:bots id="botSitGo" runat="server"></uc1:bots></td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER></form>
	</body>
</HTML>
