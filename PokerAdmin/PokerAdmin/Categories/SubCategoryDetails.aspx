<%@ Page language="c#" Codebehind="SubCategoryDetails.aspx.cs" AutoEventWireup="false" Inherits="Admin.Categories.SubCategoryDetails" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Category Details</title>
		<meta name="vs_showGrid" content="False">
		<meta content="Microsoft Visual Studio 7.0" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<SCRIPT language="JavaScript" id="clientComboJS" src="comboMove.js"></SCRIPT>
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="SubCategoryDetails" method="post" runat="server">
			<INPUT id="hdnStatsList" style="Z-INDEX: 100; LEFT: 329px; POSITION: absolute; TOP: 569px" type="hidden" name="hdnInsertList" runat="server">&nbsp;
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="60%" align="center" border="0">
				<tr>
					<td>
						<table align="center">
							<tr>
								<td><CBC:BUTTONIMAGE id="btnSave" onclick="btnSave_Click" runat="server" Text="Save"></CBC:BUTTONIMAGE></td>
								<td><CBC:BUTTONIMAGE id="btnCancel" onclick="bntGoBack_Click" runat="server" Text="Back" CausesValidation="false"></CBC:BUTTONIMAGE></td>
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
								<td>Name</td>
								<td align="left"><asp:textbox id="txtName" Runat="server" MaxLength="50"></asp:textbox></td>
							</tr>
							<tr>
								<td>Type</td>
								<td align="left"><asp:dropdownlist id="comboCategory" Runat="server"></asp:dropdownlist></td>
							</tr>
							<tr>
								<td>Status</td>
								<td align="left"><asp:dropdownlist id="comboStatus" Runat="server"></asp:dropdownlist></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr id="rowStats" runat="server">
					<td align="middle"><br>
						<table class="cssReport cssTextMain" id="tblStats" borderColor="#3399ff" cellSpacing="0" cellPadding="2" width="100%" align="center" border="1" runat="server">
							<tr>
								<td align="left" colSpan="4"><b>Statistics list:
										<asp:customvalidator id="CustomValidator1" runat="server" ControlToValidate="txtName" Display="Dynamic" ClientValidationFunction="BeforeSubmit"></asp:customvalidator></b></td>
							</tr>
							<tr>
								<td align="middle" width="50%" colSpan="2">Present</td>
								<td align="middle" width="15%">&nbsp;</td>
								<td align="middle" width="35%">Not Present</td>
							</tr>
							<tr>
								<td width="15%"><CBC:BUTTONIMAGE id="btnUp" runat="server"></CBC:BUTTONIMAGE></td>
								<td align="left" rowSpan="2"><asp:listbox id="lstPresentStats" Runat="server" Width="100%" SelectionMode="Multiple" EnableViewState="False"></asp:listbox></td>
								<td align="middle"><CBC:BUTTONIMAGE id="btnAttach" runat="server"></CBC:BUTTONIMAGE></td>
								<td align="right" rowSpan="2"><asp:listbox id="lstOtherStats" Runat="server" Width="100%" SelectionMode="Multiple" EnableViewState="False"></asp:listbox></td>
							</tr>
							<tr>
								<td><CBC:BUTTONIMAGE id="btnDown" runat="server"></CBC:BUTTONIMAGE></td>
								<td align="middle"><CBC:BUTTONIMAGE id="btnDetach" runat="server"></CBC:BUTTONIMAGE></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr id="rowRelatedProcesses" runat="server">
					<td align="middle">
						<br>
						<asp:DataGrid ID="gridRelatedProcess" Runat="server" AutoGenerateColumns="False">
							<ItemStyle CssClass="cssReportItemOdd"></ItemStyle>
							<HeaderStyle CssClass="cssReportHeader"></HeaderStyle>
							<Columns>
								<asp:BoundColumn HeaderText="Nested Tables" DataField="Name" />
							</Columns>
						</asp:DataGrid></td>
				</tr>
			</table>
			<CDC:PageFooter ID="oPageFooter" runat="server" />
			<input type="hidden" id="hdnSubCategoryID" runat="server">
		</form>
		<script>
			var srcObj		  = document.all["lstOtherStats"];
			var destObj		  = document.all["lstPresentStats"];
			var StatsListObj = document.all["hdnStatsList"];
			
			function BeforeSubmit(val, args)
			{
				StatsListObj.value = SerializeToString(destObj);
				args.IsValid =  true;
			}
		</script>
	</body>
</HTML>
