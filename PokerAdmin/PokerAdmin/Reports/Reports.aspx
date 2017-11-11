<%@ Register TagPrefix="cr" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=9.1.5000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>
<%@ Page language="c#" Codebehind="Reports.aspx.cs" AutoEventWireup="false" Inherits="Admin.Reports.Reports" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="GPC" TagName="GridPager" Src="../Controls/GridPager.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Reports</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="<%=GetCssPageUrl()%>" type=text/css 
rel=stylesheet>
		<!-- #include file="calendar.js" -->
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="Form1" method="post" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="100%">
				<tr>
					<td>
						<table class="cssTextMain" borderColor="#3399ff" cellSpacing="0" cellPadding="2" align="center"
							border="1">
							<tr>
								<td align="center" colSpan="2">Reports: &nbsp;
									<SELECT id="ddReport" onclick="ItemSelected();" name="ddReport" runat="server">
									</SELECT>
								</td>
							</tr>
							<tr>
								<td align="center" colSpan="2"><asp:label id="Label1" runat="server">Date From:</asp:label><INPUT id="txdtFrom" type="text" runat="server">
									<INPUT class="cButton" id="selBtFrom" onclick="CurrentFieldName='txdtFrom';set_today(this);"
										type="button" value="..." runat="server">
									<asp:label id="Label2" runat="server"> To: </asp:label><INPUT id="txdtTo" type="text" runat="server">
									<INPUT class="cButton" id="selBtTo" onclick="CurrentFieldName='txdtTo';set_today(this);"
										type="button" value="..." runat="server">
									<table class="cssTextMain" width="100%">
										<tr>
											<td align="center"><INPUT id="chMoney" type="checkbox" name="chMoney" runat="server">Money&nbsp;
												<INPUT id="chPlayMoney" type="checkbox" name="Checkbox1" runat="server">Play 
												Money<INPUT id="chnoBots" type="checkbox" name="chnoBots" runat="server">Exclude 
												Bots
											</td>
										</tr>
										<tr>
											<td align="center"><asp:panel id="pn" Runat="server" BorderWidth="1" Font-Size="XX-Small">
													<TABLE style="FONT-SIZE: x-small">
														<TR>
															<TD align="center"><INPUT id="chValueAsList" type="checkbox" runat="server">&nbsp;Values 
																as list by coma</TD>
														</TR>
														<TR>
															<TD align="center">Player ID:&nbsp;<INPUT id="txPID" style="WIDTH: 195px; HEIGHT: 22px" type="text" size="27" runat="server">&nbsp;Login 
																Name:&nbsp; <INPUT id="txLoginName" style="WIDTH: 184px; HEIGHT: 22px" type="text" size="8" runat="server">
															</TD>
														</TR>
														<TR>
															<TD align="center">MAC Address:&nbsp;<INPUT id="txtMACAddress" style="WIDTH: 195px; HEIGHT: 22px" type="text" size="27" runat="server">
															</TD>
														</TR>
													</TABLE>
												</asp:panel></td>
										</tr>
										<tr>
											<td align="center">Interval:&nbsp; <INPUT id="txDiscretCount" type="text" runat="server">&nbsp; 
												Interval type:&nbsp;
												<SELECT id="slIntrType" runat="server">
												</SELECT></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="center"><CBC:BUTTONIMAGE id="btnCreateReport" onclick="btnCreateReport_Click" runat="server" Target="_blank"
							Text="Create Report"></CBC:BUTTONIMAGE></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align="center"><asp:label id="lbResult" runat="server"></asp:label></td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER><INPUT id="hdnCurrDate" type="hidden" runat="server">
			<script language="javascript">
		       
     function ItemSelected()
     {
           document.Form1.txdtFrom.disabled =false; 
           document.Form1.txdtTo.disabled =false; 
		   document.Form1.selBtTo.disabled =false; 
		   document.Form1.selBtFrom.disabled =false; 
           document.Form1.chMoney.disabled =false;
           document.Form1.chPlayMoney.disabled =false;
           document.Form1.txPID.disabled =true;
           document.Form1.txLoginName.disabled =true;
           document.Form1.txDiscretCount.disabled =true;
           document.Form1.slIntrType.disabled =true;
           document.Form1.txtMACAddress.disabled =true;
           document.Form1.chValueAsList.checked =false;
            
           switch(document.Form1.ddReport.value)
           {
                case "0":
			           document.Form1.txdtFrom.disabled =false; 
					   document.Form1.txdtTo.disabled =false; 
			           document.Form1.chMoney.disabled =true;
					   document.Form1.chPlayMoney.disabled =true;
						break;
				case "3":
					document.Form1.chMoney.disabled =true;
					document.Form1.chPlayMoney.disabled =true;
					document.Form1.txDiscretCount.disabled=false;
					document.Form1.slIntrType.disabled =false;
					break;
                case "1":
				case "5":
				case "6":
			           document.Form1.chMoney.disabled =true;
					   document.Form1.chPlayMoney.disabled =true;
					   break;
				case "2":
				case "11": 
			           document.Form1.txPID.disabled =false;
					   document.Form1.txLoginName.disabled =false;
					   break;
				case "7":	   
				case "8":	   
			           document.Form1.chMoney.disabled =true;
					   document.Form1.chPlayMoney.disabled =true;
			           document.Form1.txPID.disabled =false;
					   document.Form1.txLoginName.disabled =false;
					   break;
				case "9":	   
			           document.Form1.chMoney.disabled =true;
					   document.Form1.chPlayMoney.disabled =true;
			           document.Form1.txPID.disabled =false;
					   document.Form1.txLoginName.disabled =false;
					   break;
				case "10":	   
				case "13":	   
				case "14":	   
				case "15":	   
			           document.Form1.chMoney.disabled =true;
					   document.Form1.chPlayMoney.disabled =true;
					   break;
			   case "16":
			           document.Form1.chMoney.disabled =true;
					   document.Form1.chPlayMoney.disabled =true;
			           document.Form1.txLoginName.disabled =false;
			           document.Form1.txPID.disabled =false;
			           document.Form1.chValueAsList.checked =true;
					   break;
			   case "17":
			   case "18":
			           document.Form1.txLoginName.disabled =false;
			           document.Form1.txPID.disabled =false;
			           document.Form1.txdtFrom.disabled =true; 
					   document.Form1.txdtTo.disabled =true; 
					   document.Form1.selBtTo.disabled =true; 
					   document.Form1.selBtFrom.disabled =true; 
			           document.Form1.chValueAsList.checked =true;
					   break;
			   case "19":
			   case "20":
			           document.Form1.txtMACAddress.disabled =false;
			           document.Form1.txPID.disabled =false;
					   document.Form1.txLoginName.disabled =false;
			           document.Form1.chValueAsList.checked =true;
   			           document.Form1.chMoney.disabled =true;
					   document.Form1.chPlayMoney.disabled =true;
			           break;
			   case "21":
			   case "22":
			           document.Form1.txtMACAddress.disabled =true;
			           document.Form1.txPID.disabled =false;
					   document.Form1.txLoginName.disabled =false;
			           document.Form1.chValueAsList.checked =true;
   			           document.Form1.chMoney.disabled =true;
					   document.Form1.chPlayMoney.disabled =true;
			           break;
			   case "23":
			           document.Form1.txPID.disabled =false;
					   document.Form1.txLoginName.disabled =false;
			           document.Form1.chValueAsList.checked =true;
   			           document.Form1.chMoney.disabled =false;
					   document.Form1.chPlayMoney.disabled =false;
			           break;
				   }
			}
			ItemSelected();
			</script>
		</form>
		<IFRAME style="LEFT: 10px; VISIBILITY: hidden; POSITION: absolute; TOP: 10px" name="calendar"
			marginWidth="0" marginHeight="0" width="5" scrolling="no" height="5"></IFRAME>
	</body>
</HTML>
