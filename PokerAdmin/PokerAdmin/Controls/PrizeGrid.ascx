<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Control Language="c#" AutoEventWireup="false" Codebehind="PrizeGrid.ascx.cs" Inherits="Admin.Controls.PrizeGrid" TargetSchema="http://schemas.microsoft.com/intellisense/ie5"%>
<TABLE id="TbFloor" cellSpacing="0" cellPadding="0" width="100%" border="1" runat="server">
	<tr>
		<td>
			<TABLE class="cssReportHeader" id="TableH" cellSpacing="0" cellPadding="0" width="100%"
				runat="server">
				<tr height="5">
					<td colSpan="3"></td>
				</tr>
				<tr vAlign="middle" height="30">
					<td align="center" width="40%">From: &nbsp;<asp:textbox id="txFrom" Runat="server" Width="76px" OnInit="IInit"></asp:textbox></td>
					<td align="center" width="40%">To Finish: &nbsp;<asp:textbox id="txToFinish" Runat="server" Width="76px"></asp:textbox></td>
					<td width="20%"><input id="btnDeletePrize" style="BACKGROUND-IMAGE: url(../Img/btn_bg.gif)" onclick="javascript:HideMe(this);"
							type="button" value="Delete" runat="server"></td>
				</tr>
			</TABLE>
			<TABLE id="tablePrize" cellSpacing="0" cellPadding="3" width="100%" border="1" runat="server">
				<TR>
					<td>From</td>
					<td>To</td>
					<td>Prize</td>
					<td>Non Currency</td>
				</TR>
			</TABLE>
			<table class="cssReportHeader" width="100%" align="center">
				<tr> <!--class="ButtonImageLink" -->
					<td align="center" colSpan="3"><input id="btn_AddRow" style="BACKGROUND-IMAGE: url(../Img/btn_bg.gif)" onclick="javascript:Add_New(this);"
							type="button" value="Add Row" runat="server"> <input id="btn_DeleteRow" style="BACKGROUND-IMAGE: url(../Img/btn_bg.gif)" onclick="javascript:Delete_Row(this);"
							type="button" value="Delete Row" runat="server"></td>
				</tr>
			</table>
		</td>
	</tr>
</TABLE>
<script language="javascript">

function Add_New(tt)
{
   var pref=tt.id.replace("btn_AddRow","")
	var prTable = document.all[pref+"tablePrize"];
    Add_Row(prTable.rows.length-1,prTable);
}

function Delete_Row(tt)
{
   var pref=tt.id.replace("btn_DeleteRow","")
	var prTable = document.all[pref+"tablePrize"];
   if(prTable.rows.length<=2) return;
    prTable.deleteRow(prTable.rows.length-1);
}

//It Adds new row in the table
function Add_Row(insertAfter,prTable)
{
	tAddAfterRow = prTable.rows[insertAfter];
    row = prTable.insertRow(insertAfter+1); 
    row.className = tAddAfterRow.className;
  
   	for(col=0;col<tAddAfterRow.cells.length;col++)
   	{
	    tdObject = document.createElement("TD")
	    tdObject.className = tAddAfterRow.cells[col].className;
	    tdObject.style.display = tAddAfterRow.cells[col].style.display;
   		theID = 'edt_' + (insertAfter+1) + '_' + col;
	    txtValue = document.createElement('input');
		txtValue.type = 'text';
		txtValue.ID = theID;
		txtValue.className = tAddAfterRow.cells[col].children[0].className;
	    tdObject.appendChild(txtValue);
	    row.appendChild(tdObject);
   	}
}

function HideMe(tt)
{
   var pref=tt.id.replace("btnDeletePrize","")
	document.all[pref+"TbFloor"].style.display="none";
}

</script>
