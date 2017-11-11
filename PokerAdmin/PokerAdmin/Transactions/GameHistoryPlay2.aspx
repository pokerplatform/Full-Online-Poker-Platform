<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Page language="c#" Codebehind="GameHistoryPlay.aspx.cs" AutoEventWireup="false" Inherits="Admin.Transactions.GameHistoryPlay" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title>Game History Details</title>
<meta content=False name=vs_showGrid>
<meta content="Microsoft Visual Studio 7.0" name=GENERATOR>
<meta content=C# name=CODE_LANGUAGE>
<meta content=JavaScript name=vs_defaultClientScript>
<meta content=http://schemas.microsoft.com/intellisense/ie5 name=vs_targetSchema>
<LINK href="<%=Admin.Config.CommonCssPath%>" type="text/css" rel="stylesheet">
  </HEAD>
<body onunload=DeleteTemporaryFile(); 
MS_POSITIONING="FlowLayout">
<form id=UserDetails method=post runat="server">
<TABLE id=Table1 width="100%" height="100%" align=center border=0 >
  <TR>
    <TD align=center><asp:label id=lblName runat="server"></asp:label></TD></TR>
  <TR>
    <TD align=center width="100%" height="100%">
      <script>
      var flashobj = '<OBJECT  id=flashobj codeBase=http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0 ';
      flashobj += 'height="100%" width="100%" classid=clsid:D27CDB6E-AE6D-11cf-96B8-444553540000>';
	  flashobj += '<PARAM NAME=movie VALUE="<%=GetPokerSwfUrl()%>">';
	  flashobj += '<PARAM NAME=menu VALUE=false>';
	  flashobj += '<PARAM NAME=quality VALUE=high>';
	  flashobj += '<PARAM NAME=flashvars VALUE="XMLHistoryPath=<%=GetXmlUrl()%>">';
	  flashobj += '</OBJECT>'
	  document.write(flashobj);
    </script>
    </TD></TR>
  <TR>
    <TD align=center><CBC:BUTTONIMAGE id=btnClose onclick=btnClose_click runat="server" CausesValidation="false" Text="Close"></CBC:BUTTONIMAGE></TD></TR></TABLE></form>
<script>
function DeleteTemporaryFile()
{
	window.open('DeleteFile.aspx?filePath=<%=GetXmlPath()%>');
}
</script>






	</body>
</HTML>
