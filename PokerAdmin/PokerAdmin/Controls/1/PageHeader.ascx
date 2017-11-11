<%@ Control Language="c#" AutoEventWireup="false" Codebehind="PageHeader.ascx.cs" Inherits="Admin.Controls.PageHeader" TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>
<LINK href="<%=GetCssPageUrl()%>" type="text/css" rel="stylesheet">
<script>
var csIncludeDir = "<%=GetMenuPath()%>";
function ItemClick(sUrl)
{
	document.location.href='<%=Admin.Config.SiteRoot%>' + sUrl;
}
</script>
<table width="100%" align="center" border="0">
	<tr>
		<td width="150px">
			<asp:Image ID="oImageLogo" Runat="server"></asp:Image>
		</td>
		<td align="center" valign="top">
			<%=GetMainMenuLink()%>
		</td>
		<td width="150px">&nbsp;</td>
	</tr>
	<tr>
		<td class="cssPageName" colspan="3" width="55%"><%=GetPageName()%></td>
	</tr>
	<tr>
		<td width="50%" colspan="3">
