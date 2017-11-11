<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<%@ Page language="c#" Codebehind="AffiliateReport.aspx.cs" AutoEventWireup="false" Inherits="Admin.Affiliate.AffiliateReport" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Affiliate Reports</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<script language="javascript">
		
	   function ChangeEnable(ddAffiliates,chSummary)
	   {
	           ddAffiliates.disabled=document.AffiliateReports.chAllAffiliates.checked;
	           chSummary.disabled=!document.AffiliateReports.chAllAffiliates.checked;
	           if(chSummary.disabled) chSummary.checked=false;
	   }
	   
		</script>
		<form id="AffiliateReports" method="post" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table width="70%" align="center" border="1" BorderColor="#3399ff">
				<tr>
					<td>
						<table width="100%" align="center">
							<TBODY>
								<tr>
									<td align="center" colspan="2">Date from:
										<asp:textbox id="txtDateFrom" runat="server" MaxLength="10"></asp:textbox>&nbsp;to:
										<asp:textbox id="txtDateTo" runat="server" MaxLength="10"></asp:textbox></td>
								</tr>
								<tr>
									<td align="center"><INPUT id="chAllAffiliates" onclick="ChangeEnable(ddAffiliates,chSummary)" type="checkbox"
											runat="server" style="WIDTH: 14px; HEIGHT: 20px">&nbsp;All Affiliates
									</td>
									<td align="center">Select Affiliates&nbsp;<asp:dropdownlist id="ddAffiliates" runat="server" Width="204px"></asp:dropdownlist></td>
								</tr>
								<tr>
									<td align="center" width="40%">
										<INPUT id="chSummary" type="checkbox" runat="server" style="WIDTH: 14px; HEIGHT: 20px"
											NAME="chSummary">
									&nbsp;Total only
									<td></td>
								</tr>
								<tr>
									<td align="center" colspan="2">
										<CBC:ButtonImage id="btnReport" onclick="btnReport_Click" runat="server" Text="Create"></CBC:ButtonImage>
									</td>
								</tr>
							</TBODY>
						</table>
					</td>
				</tr>
			</table>
			<table align="center" width="88%">
				<tr>
					<td align="center">
						<asp:Label id="lbMessage" runat="server" Width="100%" ForeColor="Red" BorderWidth="0" EnableViewState="false"></asp:Label>
					</td>
				</tr>
				<tr>
					<td align="center">
						<asp:DataGrid id="dgAllAffil" runat="server" Width="100%" Visible="False" AutoGenerateColumns="False"
							BorderColor="#3399FF" CssClass="cssReport cssTextMain" PageSize="50" PagerStyle-Mode="NumericPages">
							<AlternatingItemStyle CssClass="cssReportItemOdd"></AlternatingItemStyle>
							<ItemStyle CssClass="cssReportItem"></ItemStyle>
							<HeaderStyle CssClass="cssReportHeader"></HeaderStyle>
							<Columns>
								<asp:BoundColumn DataField="ID" HeaderText="ID"></asp:BoundColumn>
								<asp:BoundColumn DataField="Name" HeaderText="Name"></asp:BoundColumn>
								<asp:BoundColumn DataField="Rake" HeaderText="Rake"></asp:BoundColumn>
							</Columns>
							<PagerStyle Mode="NumericPages"></PagerStyle>
						</asp:DataGrid>
						<asp:DataGrid id="dgAffilPeriod" runat="server" Width="100%" Visible="False" AutoGenerateColumns="False"
							BorderColor="#3399FF" CssClass="cssReport cssTextMain" PageSize="50" PagerStyle-Mode="NumericPages">
							<AlternatingItemStyle CssClass="cssReportItemOdd"></AlternatingItemStyle>
							<ItemStyle CssClass="cssReportItem"></ItemStyle>
							<HeaderStyle CssClass="cssReportHeader"></HeaderStyle>
							<Columns>
								<asp:BoundColumn DataField="ID" HeaderText="ID"></asp:BoundColumn>
								<asp:BoundColumn DataField="Name" HeaderText="Name"></asp:BoundColumn>
								<asp:BoundColumn DataField="Date" HeaderText="Date"></asp:BoundColumn>
								<asp:BoundColumn DataField="ProcessName" HeaderText="Process"></asp:BoundColumn>
								<asp:BoundColumn DataField="GameName" HeaderText="Game"></asp:BoundColumn>
								<asp:BoundColumn DataField="HandID" HeaderText="Hand ID"></asp:BoundColumn>
								<asp:BoundColumn DataField="Rake" HeaderText="Rake"></asp:BoundColumn>
							</Columns>
							<PagerStyle Mode="NumericPages"></PagerStyle>
						</asp:DataGrid>
					</td>
				</tr>
				<tr>
					<td align="right">
						<asp:Label id="lbSumCaption" runat="server" Visible="False">Summa</asp:Label>&nbsp;
						<asp:Label id="lbRakeSum" runat="server" Width="177px" Font-Bold="True" Visible="False">0</asp:Label></td>
				</tr>
			</table>
			<!--	<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER></form>--></form>
	</body>
</HTML>
