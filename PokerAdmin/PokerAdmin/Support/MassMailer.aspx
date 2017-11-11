<%@ Page language="c#" Codebehind="MassMailer.aspx.cs" AutoEventWireup="false" Inherits="Admin.Support.MassMailer" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title>Mass Mailer</title>
<meta content="Microsoft Visual Studio .NET 7.1" name=GENERATOR>
<meta content=C# name=CODE_LANGUAGE>
<meta content=JavaScript name=vs_defaultClientScript>
<meta content=http://schemas.microsoft.com/intellisense/ie5 name=vs_targetSchema>
  </HEAD>
<body MS_POSITIONING="GridLayout">
<form id=Form1 method=post runat="server"><CDC:PAGEHEADER id=oPageHeader runat="server"></CDC:PAGEHEADER>
<table width="60%" align=center>
  <tr>
    <TD align=center><CBC:BUTTONIMAGE id=btnSent onclick=btnSend_Click runat="server" Text="Send Mail"></CBC:BUTTONIMAGE></TD></TR>
  <tr>
    <td align=center><asp:label id=lblInfo Runat="server" ForeColor="Red" EnableViewState="False"></asp:label><br 
      ><asp:label id=lbNotSent Runat="server" ForeColor="Red" EnableViewState="False"></asp:label></TD></TR>
  <tr>
    <td>Enter list of email addresses separated by coma 
    </TD></TR>
  <tr>
    <td>
      <table borderColor=#3399ff cellSpacing=0 cellPadding=0 width="100%" 
      align=center border=1>
        <tr>
          <td><asp:textbox id=txtAdr runat="server" TextMode="MultiLine" Width="100%" Columns="80" Rows="5"></asp:textbox></TD></TR></TABLE>
  <tr>
    <td>Subject: <asp:textbox id=txtSubject runat="server" Width="65%"></asp:textbox>
    Send as:<asp:dropdownlist id=ddSendAs runat="server"></asp:dropdownlist></TD></TR>
  <tr>
    <td>
      <table borderColor=#3399ff cellSpacing=0 cellPadding=2 width="100%" 
      align=center border=1>
        <tr>
          <td><asp:textbox id=txtmessage runat="server" TextMode="MultiLine" Width="100%" Columns="80" Rows="10"></asp:textbox></TD></TR></TABLE></TD></TR>
  <tr>
    <td>From Email Template <asp:dropdownlist id=ddTmpl runat="server"></asp:dropdownlist><asp:button id=btFill runat="server" Text="  Fill   "></asp:button></TD></TR></TABLE><CDC:PAGEFOOTER id=oPageFooter runat="server"></CDC:PAGEFOOTER></FORM>
	</body>
</HTML>
