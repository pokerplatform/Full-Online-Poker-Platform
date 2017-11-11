<%@ Register TagPrefix="GFC" Namespace="Common.WebControls" Assembly = "Common" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="GPC" TagName="GridPager" Src="../Controls/GridPager.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Page language="c#" Codebehind="Chat.aspx.cs" AutoEventWireup="false" Inherits="Admin.Misc.Chat" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Chat</title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
	
	<OBJECT ID="AdminCtrl" CLASSID="CLSID:C2B91220-AB3E-486E-8B73-041F6281DB30" width=1 height=1   VIEWASTEXT>	
</OBJECT>

		<form id="Form1" method="post" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table align="center">
				<tr>
					<td align="center">Games:&nbsp;
						<asp:DropDownList id="ddGames" runat="server" AutoPostBack="True"></asp:DropDownList></td>
				</tr>
			</table>
			<table align="center" width="80%">
				<tr>
					<td align=center ><TEXTAREA rows="12" cols="85" id="txMessages" readOnly></TEXTAREA>
					</td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER>
			<INPUT type="hidden" id="hdnSelGame" runat="server">
		</form>
	</body>
	<script language =javascript >
	   function GetMessages()
	   {
	      var t="";
	      document.Form1.txMessages.value =document.all.AdminCtrl.GetDefaultProperties(t);
	   }
	    GetMessages();
	</script>
</HTML>
