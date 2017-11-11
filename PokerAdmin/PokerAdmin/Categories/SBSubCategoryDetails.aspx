<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Page language="c#" Codebehind="SBSubCategoryDetails.aspx.cs" AutoEventWireup="false" Inherits="Admin.Categories.SBSubCategoryDetails" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>BuddyWager SubCategory Details</title>
		<meta content="Microsoft Visual Studio 7.0" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<SCRIPT language="JavaScript" src="table.js"></SCRIPT>
	</HEAD>
	<body>
		<form id="SBSubCategoryDetails" method="post" runat="server">
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
					<td align="middle"><asp:label id="lblInfo" Runat="server" ForeColor="Red" EnableViewState="False"></asp:label></td>
				</tr>
				<tr>
					<td>
						<table class="cssReport cssTextMain" borderColor="#3399ff" cellSpacing="0" cellPadding="2" width="100%" align="center" border="1">
							<tr>
								<td width="30%">Name</td>
								<td align="left"><asp:textbox id="txtName" Runat="server" MaxLength="50" Width="100%"></asp:textbox></td>
							</tr>
							<tr>
								<td>Category</td>
								<td align="left"><asp:dropdownlist id="comboCategory" Runat="server"></asp:dropdownlist></td>
							</tr>
							<TR>
								<td>Spread:</td>
								<TD>
									<table class="cssReport cssTextMain">
										<tr>
											<td>From:</td>
											<td><asp:textbox id="txtSpreadFrom" Runat="server" MaxLength="50" Width="50px">-100</asp:textbox></td>
											<td>To:</td>
											<td><asp:textbox id="txtSpreadTo" Runat="server" MaxLength="50" Width="50px">100</asp:textbox></td>
											<td>Step</td>
											<td><asp:textbox id="txtSpreadStep" Runat="server" MaxLength="50" Width="50px">0.5</asp:textbox></td>
										</tr>
									</table>
								</TD>
							</TR>
							<TR>
								<TD>Total O/U:</TD>
								<TD>
									<TABLE class="cssReport cssTextMain">
										<TR>
											<TD>From:</TD>
											<TD>
												<asp:textbox id="txtOuFrom" Runat="server" MaxLength="50" Width="50px">0</asp:textbox></TD>
											<TD>To:</TD>
											<TD>
												<asp:textbox id="txtOuTo" Runat="server" MaxLength="50" Width="50px">100</asp:textbox></TD>
											<TD>Step</TD>
											<TD>
												<asp:textbox id="txtOuStep" Runat="server" MaxLength="50" Width="50px">1</asp:textbox></TD>
										</TR>
									</TABLE>
								</TD>
							</TR>
							<TR>
								<TD align="middle" colSpan="2"><br>
									Teams
									<asp:customvalidator id="CustomValidator1" runat="server" ControlToValidate="txtName" Display="Dynamic" ClientValidationFunction="beforeSubmit"></asp:customvalidator></TD>
							</TR>
							<TR>
								<TD align="middle" colSpan="2">
									<TABLE id="Table1">
										<TR>
											<TD>
												<asp:table id="tblTeam" runat="server" EnableViewState="False" BorderColor="#3399FF" CellPadding="2" HorizontalAlign="Center" GridLines="Both" CellSpacing="0" CssClass="cssReport cssTextMain">
													<asp:TableRow CssClass="cssReportHeader">
														<asp:TableCell ID="selectID"></asp:TableCell>
														<asp:TableCell Text="Name" ID="Name"></asp:TableCell>
													</asp:TableRow>
													<asp:TableRow CssClass="cssReportHeader">
														<asp:TableCell></asp:TableCell>
														<asp:TableCell Text="&lt;input type=&quot;text&quot; name=&quot;OutcomeNewName&quot; tabIndex=&quot;901&quot; id=&quot;OutcomeNewName&quot;&gt;"></asp:TableCell>
													</asp:TableRow>
												</asp:table></TD>
											<TD vAlign="bottom" align="left">
												<CBC:BUTTONIMAGE id="btnTeamAdd" runat="server" Text="Add"></CBC:BUTTONIMAGE></TD>
										</TR>
									</TABLE>
									<CBC:BUTTONIMAGE id="btnTeamDelete" runat="server" Text="Delete" CausesValidation="false"></CBC:BUTTONIMAGE></TD>
							</TR>
						</table>
					</td>
				</tr>
			</table>
			<input type="hidden" id="hdnID" runat="server" NAME="hdnID">
			<CDC:PageFooter ID="oPageFooter" runat="server" />
			<INPUT id="hdnTeamCSV" type="hidden" name="hdnTeamCSV" runat="server">
		</form>
		<script>
			var	tTeam   = document.all["tblTeam"];
			var csvTeam = document.all["hdnTeamCSV"];
	
			FillTableFromCSV(csvTeam.value);
			
			function beforeSubmit(val, args){
				//serialize Team table to csv string list
				csvTeam.value = SerializeTableToCSV();
				
				args.IsValid = true;
			}

		</script>
	</body>
</HTML>
