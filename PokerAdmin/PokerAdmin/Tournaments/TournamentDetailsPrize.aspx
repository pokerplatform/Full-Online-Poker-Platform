<%@ Page language="c#" Codebehind="TournamentDetailsPrize.aspx.cs" AutoEventWireup="false" Inherits="Admin.Tournaments.TournamentDetailsPrize" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Tournament Details (Prize)</title>
		<meta content="Microsoft Visual Studio 7.0" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<SCRIPT language="JavaScript" id="clientTableJS" src="../CommonUse/jsTable.js"></SCRIPT>
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="MiscMaintenance" method="post" runat="server">
			<INPUT id="hdnPostBackType" style="Z-INDEX: 101; LEFT: 178px; POSITION: absolute; TOP: 273px"
				type="hidden" name="hdnPostBackType" runat="server"> <INPUT id="hdnTournamentID" style="Z-INDEX: 102; LEFT: 178px; POSITION: absolute; TOP: 273px"
				type="hidden" name="hdnTournamentID" runat="server"> <INPUT id="hdnTournamentPrizeXML" style="Z-INDEX: 103; LEFT: 348px; POSITION: absolute; TOP: 276px"
				type="hidden" name="hdnTournamentXML" runat="server">
			<select id="PrefList" style="DISPLAY: none" runat="server">
			</select>
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="100%" align="center">
				<tr>
					<td align="center">
						<table>
							<tr>
								<td><CBC:BUTTONIMAGE id="btnSave" runat="server" Text="Save" NavigateUrl="javascript:SaveData('btnSave');"></CBC:BUTTONIMAGE></td>
								<td><CBC:BUTTONIMAGE id="btnCancel" onclick="bntGoBack_Click" runat="server" Text="Back" CausesValidation="false"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="center"><asp:textbox id="lblInfo" runat="server" Height="50" Visible="false" ReadOnly="True" TextMode="MultiLine"
							ForeColor="Red" EnableViewState="False" Width="500"></asp:textbox></td>
				<TR>
					<TD align="center">
						<TABLE cellSpacing="0" cellPadding="2">
							<TR>
								<TD><nobr>Copy from Tournament Prize Template</nobr></TD>
								<TD><asp:dropdownlist id="comboTemplate" Runat="server"></asp:dropdownlist></TD>
								<TD><CBC:BUTTONIMAGE id="btnCopy" onclick="btnCopy_Click" runat="server" Text="Copy"></CBC:BUTTONIMAGE></TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
				<tr>
					<td align="center">
						<br>
						<table>
							<tr>
								<td><asp:label id="Label1" runat="server">Prize value Type:</asp:label><asp:dropdownlist id="ddPrizeValueType" runat="server"></asp:dropdownlist></td>
								<td>&nbsp;</td>
								<td><asp:label id="Label2" runat="server">Currency:</asp:label><asp:dropdownlist id="ddCurrency" runat="server"></asp:dropdownlist></td>
							</tr>
						</table>
						<br>
					</td>
				</tr>
				<tr>
					<td align="center">
						<table cellSpacing="0" cellPadding="0" width="400" border="0">
							<tr>
								<td width="40%">From: &nbsp;<asp:textbox id="txFrom" Width="76px" Runat="server"></asp:textbox></td>
								<td width="40%">To Finish: &nbsp;<asp:textbox id="txToFinish" Width="76px" Runat="server"></asp:textbox></td>
								<td width="20%"><CBC:BUTTONIMAGE id="btnAddPrize" runat="server" Text="Add" NavigateUrl="javascript:SaveData('btnAddPrize');"
										CausesValidation="false"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
						<asp:panel id="panelPrizesList" runat="server" EnableViewState="False" Width="400"></asp:panel></td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER>
			<script>
		
			var tTable = document.all["table"];
			var hdnXML = document.all["hdnTournamentPrizeXML"];
			var radioGroupName = 'theSameGroup';
			var topMostNodeName = 'tournamentprize';
			var checkSum = true;
			
			function GetXML()
			{
				result = SerializeTableToXML();
				if (result != '')	
				{
					hdnXML.value = result;
				}
				__doPostBack('btnSave', '');
				return false;
			}

//--------------------------------------------			
	function SaveData(sFrom)
	{
	    var l;
		var tList = document.all["PrefList"];
		var stag;
		var xmlText='<tournamentprize>';
	     for (l=0;l< tList.length;l++)
	     {
	          stag=tList.all[l].value;
	          if (stag != "")
	          {
	             var tHdr=document.all[stag+"TableH"];
	             var tDet=document.all[stag+"tablePrize"];
	           	 var tFloor=document.all[stag+"TbFloor"];

	             if (tDet != null && tHdr!= null && tFloor.style.display != "none")
	               {
	                 xmlText+=GetXmlBody(stag,tDet,tHdr);
	               }
	          }
	     }    	       
	     xmlText+='</tournamentprize>';
	     tList=document.all["hdnTournamentPrizeXML"];
	     tList.value= xmlText;
	     
	     t_List=document.all["hdnPostBackType"];
	     t_List.value= sFrom;
	     
				__doPostBack('btnAddPrize', '');
	}
//-------------------------------------------	
function getFromValue(sval)
{
  ret = parseFloat(sval);
  if (isNaN(ret)) return -1;
  return ret;
}
//---------------------------------------
  function GetXmlBody(stag,tDet,tHdr)
  {
  	retXML  = '<players from="' ;

  	
  	from_p=getFromValue(tHdr.rows[1].cells[0].children[0].value);
  	to_p=getFromValue(tHdr.rows[1].cells[1].children[0].value);
  	if(from_p<=0) from_p=to_p;
  	if(to_p<=0) to_p=from_p;
  	if (to_p <=0 || from_p<=0) return '';
  	
  	retXML  += from_p  + '" playersforfinish="' + to_p + '">';  
  	
  	buf='';
  	
			for(row=1;row<tDet.rows.length;row++)
			{
			    from_p= getFromValue(tDet.rows[row].cells[0].children[0].value);
			    to_p= getFromValue(tDet.rows[row].cells[1].children[0].value);
			    perc= getFromValue(tDet.rows[row].cells[2].children[0].value);
			    ncurr=tDet.rows[row].cells[3].children[0].value;
			  	if(from_p<=0) from_p=to_p;
			  	if(to_p<=0) to_p=from_p;
			    if (from_p <=0 && to_p<=0 && perc<=0) continue;
			    
		    	 buf += '<place from="' +from_p;
			     buf += '" to="' + to_p;
			     buf += '" prizeRate="' + perc ;
			     buf += '" noncurrencyprize="'+ncurr+ '"/>';
			  }

			   if (buf =='') buf=  '<place from="1" to="1"  prizeRate="100" noncurrencyprize="" />'
			        retXML+=buf; 
					retXML += '</players>';
					
	return retXML;
  }

			</script>
		</form>
	</body>
</HTML>
