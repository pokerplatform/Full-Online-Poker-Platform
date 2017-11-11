<%@ Register TagPrefix="fino" Namespace="Controls" Assembly="FOURINONE"%>
<%@ Control Language="c#" AutoEventWireup="false" Codebehind="PageHeader.ascx.cs" Inherits="Admin.Controls.PageHeader" TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>
<!--<%@ OutputCache Duration="1" VaryByParam="None"  %>-->
<LINK href="<%=GetCssPageUrl()%>" type=text/css rel=stylesheet>
<LINK href="../Menu/Styles/default.css" type="text/css" rel="stylesheet">
<table cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
	<tr>
		<td width="150"><asp:image id="oImageLogo" Runat="server"></asp:image></td>
		<td width="5%">&nbsp;</td>
		<td vAlign="top" align="center">
			<fino:FourinOne runat="server" Display="H" Controltype="menu" ID="Fourinone" />
		</td>
	</tr>
	<tr>
		<td class="cssPageName" width="55%" colSpan="6"><%=GetPageName()%></td>
	</tr>
	<tr>
		<td width="50%" colSpan="6"></td>
	</tr>
</table>
