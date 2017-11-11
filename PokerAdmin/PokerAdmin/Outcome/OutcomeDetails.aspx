<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Page language="c#" Codebehind="OutcomeDetails.aspx.cs" AutoEventWireup="false" Inherits="Admin.Outcome.OutcomeDetails" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Outcome Details</title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio 7.0">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="OutcomeDetails" method="post" runat="server">
			<CDC:PageHeader ID="oPageHeader" runat="server" />
			<table width="60%" align="center" border="0">
				<tr>
					<td>
						<table align="center">
							<tr>
								<td><CBC:BUTTONIMAGE id="btnSave" onclick="btnSave_Click" runat="server" Text="Save"></CBC:BUTTONIMAGE></td>
								<td><CBC:BUTTONIMAGE id="btnNew" onclick="btnNew_Click" runat="server" Text="New"></CBC:BUTTONIMAGE></td>
								<td><CBC:BUTTONIMAGE id="btnCancel" NavigateUrl="javascript:history.go(-1)" runat="server" Text="Event" CausesValidation="false"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="middle"><asp:label id="lblInfo" EnableViewState="False" ForeColor="Red" Runat="server"></asp:label></td>
				</tr>
				<tr>
					<td>
						<table class="cssReport cssTextMain" borderColor="#3399ff" cellSpacing="0" cellPadding="2" width="100%" align="center" border="1">
							<tr>
								<td width="30%">Name
									<asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ErrorMessage="RequiredFieldValidator" ControlToValidate="txtName" Display="Dynamic"> can not be empty</asp:RequiredFieldValidator></td>
								<td align="left"><asp:textbox id="txtName" Width="100%" Runat="server" MaxLength="150"></asp:textbox></td>
							</tr>
							<tr>
								<td>Bet Type</td>
								<td align="left"><asp:DropDownList ID="comboType" Runat="server">
										<asp:ListItem Value="1">Straight</asp:ListItem>
										<asp:ListItem Value="2">Handicap</asp:ListItem>
										<asp:ListItem Value="3">Over</asp:ListItem>
										<asp:ListItem Value="4">Under</asp:ListItem>
									</asp:DropDownList></td>
							</tr>
							<tr>
								<td>Price
									<asp:RangeValidator id="RangeValidator1" runat="server" ErrorMessage="RangeValidator" ControlToValidate="txtRate" Display="Dynamic" Type="Currency" MinimumValue="-100000" MaximumValue="100000"> is incorrect</asp:RangeValidator>
									<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ErrorMessage="RequiredFieldValidator" ControlToValidate="txtRate" Display="Dynamic"> can not be empty</asp:RequiredFieldValidator></td>
								<td align="left"><asp:TextBox ID="txtRate" Runat="server" MaxLength="20"></asp:TextBox></td>
							</tr>
							<tr id="rowValue">
								<td>Value</td>
								<td align="left"><asp:TextBox ID="txtValue" Runat="server" MaxLength="10"></asp:TextBox></td>
							</tr>
							<tr id="rowWonValue">
								<td>Won Value</td>
								<td align="left"><asp:TextBox ID="txtWonValue" Runat="server" MaxLength="10"></asp:TextBox>
									<asp:DropDownList id="comboResult" Runat="server"></asp:DropDownList></td>
							</tr>
							<tr>
								<td>Description</td>
								<td align="left"><asp:TextBox ID="txtDescription" TextMode="MultiLine" Rows="3" Runat="server"></asp:TextBox></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<input type="hidden" id="hdnID" runat="server" NAME="hdnID"> <input type="hidden" id="hdnEventID" runat="server" NAME="hdnEventID">
			<CDC:PageFooter ID="oPageFooter" runat="server" />
		</form>
		<script language="javascript">
		InitPage();
		function InitPage()
		{
			OnTypeChanged();
		}
		function GetTypeID()
		{
			//document.all.rowValue
			var combo = document.all.comboType;
			return combo.options[combo.selectedIndex].value;
		}
		function OnTypeChanged()
		{
			DisplayValueRow(GetTypeID() > 1);
		}
		function DisplayValueRow(bShow)
		{
			DisplayObject(bShow, document.all.rowValue);
			DisplayObject(bShow, document.all.txtWonValue);
			DisplayObject(!bShow, document.all.comboResult);
		}
		function DisplayObject(bShow, obj)
		{
			if ( bShow )
			{
				obj.style.display = "block";
			}
			else
			{
				obj.style.display = "none";
			}
		}
		</script>
	</body>
</HTML>
