<%@ Control Language="c#" AutoEventWireup="false" Codebehind="ButtonImage.ascx.cs" Inherits="Admin.Controls.ButtonImage" TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>
<table cellspacing="0" cellpadding="0" align="center">
	<tbody>
		<tr>
			<td><img src="<%= Admin.Config.ButtonImageLeftImage%>"></td>
			<td class=ButtonImageCenter nowrap background="<%= Admin.Config.ButtonImageBodyImage%>"><asp:hyperlink id="oLink" runat="server" cssclass="ButtonImageLink"></asp:hyperlink></td>
			<td><img src="<%= Admin.Config.ButtonImageRightImage%>"></td>
		<tr>
		</tr>
	</tbody>
</table>
