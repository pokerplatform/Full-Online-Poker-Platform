<%@ Page language="c#" Codebehind="ViewForm.aspx.cs" AutoEventWireup="false" Inherits="Admin.Reports.ViewForm" %>
<%@ Register TagPrefix="cr" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=9.1.5000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>View Report</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="Form1" method="post" runat="server">
			<table width="100%" align="center">
				<tr>
					<td><CR:CRYSTALREPORTVIEWER id="CrView" runat="server" Width="350px" Height="50px" DisplayGroupTree="False"></CR:CRYSTALREPORTVIEWER></td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
