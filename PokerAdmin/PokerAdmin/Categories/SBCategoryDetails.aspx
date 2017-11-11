<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Page language="c#" Codebehind="SBCategoryDetails.aspx.cs" AutoEventWireup="false" Inherits="Admin.Categories.SBCategoryDetails" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>BuddyWager Category Details</title>
		<meta content="Microsoft Visual Studio 7.0" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<SCRIPT language="JavaScript" id="clientTableJS" src="../CommonUse/jsTable.js"></SCRIPT>
	</HEAD>
	<body>
		<form id="SBCategoryDatails" method="post" runat="server">
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
					<td align="middle"><asp:label id="lblInfo" Runat="server" ForeColor="Red" EnableViewState="False"></asp:label>
						<asp:customvalidator id="CustomValidator1" runat="server" Display="Dynamic" ControlToValidate="txtName" ClientValidationFunction="BeforeSubmit"></asp:customvalidator></td>
				</tr>
				<tr>
					<td>
						<table class="cssReport cssTextMain" borderColor="#3399ff" cellSpacing="0" cellPadding="2" width="100%" align="center" border="1">
							<tr>
								<td width="30%">
									<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ErrorMessage="Enter " ControlToValidate="txtName" Display="Dynamic"></asp:RequiredFieldValidator>Name</td>
								<td align="left"><asp:textbox id="txtName" Runat="server" MaxLength="50" Width="100%"></asp:textbox></td>
							</tr>
							<TR>
								<TD align="middle" colSpan="2">Teaser</TD>
							</TR>
							<TR>
								<TD align="middle" colSpan="2"><asp:table id="table" runat="server" EnableViewState="False" HorizontalAlign="Center" GridLines="Both" BorderColor="#3399FF" CellPadding="2" CellSpacing="0" CssClass="cssTextMain"></asp:table></TD>
							</TR>
							<TR>
								<TD align="middle" colSpan="2">
									<TABLE id="Table1">
										<TR>
											<TD>
												<CBC:BUTTONIMAGE id="btnAdd" runat="server" Text="Add"></CBC:BUTTONIMAGE></TD>
											<TD>
												<CBC:BUTTONIMAGE id="btnDelete" runat="server" Text="Delete"></CBC:BUTTONIMAGE></TD>
										</TR>
									</TABLE>
								</TD>
							</TR>
						</table>
					</td>
				</tr>
			</table>
			<input id="hdnID" type="hidden" runat="server">
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER><INPUT id="hdnXML" type="hidden" name="hdnXML" runat="server">
		</form>
		<script>
			var tTable = document.all["table"];
			var hdnXML = document.all["hdnXML"];
			var radioGroupName = 'theSameGroup';
			var topMostNodeName = 'tournamentprize';
			var checkSum = false;
			
			function BeforeSubmit(val, args)
			{
				result = SerializeTableToXML();
				if (result=='')	args.IsValid = false;
				else
				{
					hdnXML.value = result;
					args.IsValid =  true;
				}
			}
		</script>
	</body>
</HTML>
