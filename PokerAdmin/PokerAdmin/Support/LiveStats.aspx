<%@ Page language="c#" Codebehind="LiveStats.aspx.cs" AutoEventWireup="false" Inherits="Admin.Support.LiveStats" %>
<%@ Register TagPrefix="CDC" TagName="PageHeader" Src="../Controls/PageHeader.ascx" %>
<%@ Register TagPrefix="CDC" TagName="PageFooter" Src="../Controls/PageFooter.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Live Stats</title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="Form1" method="post" runat="server">
			<CDC:PAGEHEADER id="oPageHeader" runat="server"></CDC:PAGEHEADER>
			<table align="center" width="50%" border="1" borderColor="#3399ff" cellSpacing="0" cellPadding="0"
				style="FONT-SIZE: 14px">
				<tr   class ="cssReportHeader">
					<td colspan="2" align="center">
						<%=GetDate()%>
					</td>
				</tr>
				<tr> <!------- 1 row ---------->
					<td align="center"   class ="cssReportHeader">
						Total Active players
					</td>
					<td align="center">
						<table width="100%" style="FONT-SIZE: 14px">
							<tr>
								<td width="70%">
									Real money
								</td>
								<td>
									<asp:Label id="lbTAPReal" runat="server"></asp:Label>
								</td>
							</tr>
							<tr>
								<td>
									Play money
								</td>
								<td>
									<asp:Label id="lbTAPPlay" runat="server"></asp:Label>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr> <!------- 2 row ---------->
					<td align="center"   class ="cssReportHeader">
						Total Active Tables
					</td>
					<td align="center">
						<table width="100%" style="FONT-SIZE: 14px">
							<tr>
								<td width="70%">
									Real money
								</td>
								<td>
									<asp:Label id="lbTATReal" runat="server"></asp:Label>
								</td>
							</tr>
							<tr>
								<td width="70%">
									Play money
								</td>
								<td>
									<asp:Label id="lbTATPlay" runat="server"></asp:Label>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr> <!------- 3 row ---------->
					<td align="center"   class ="cssReportHeader">
						Players today
					</td>
					<td align="center">
						<table width="100%" style="FONT-SIZE: 14px">
							<tr>
								<td width="70%">
									New Signup
								</td>
								<td>
									<asp:Label id="lbPlayersSign" runat="server"></asp:Label>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr> <!------- 4 row ---------->
					<td align="center"   class ="cssReportHeader">
						All Tournaments today
					</td>
					<td align="center">
						<table width="100%" style="FONT-SIZE: 14px">
							<tr>
								<td width="70%">
									Running
								</td>
								<td>
									<asp:Label id="lbTournRun" runat="server"></asp:Label>
								</td>
							</tr>
							<tr>
								<td>
									Finished
								</td>
								<td>
									<asp:Label id="lbTournFinish" runat="server"></asp:Label>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr> <!------- 5 row ---------->
					<td align="center"   class ="cssReportHeader">
						Banking today
					</td>
					<td align="center">
						<table width="100%" style="FONT-SIZE: 14px">
							<tr>
								<td width="70%">
									Deposits
								</td>
								<td>
									<asp:Label id="lbDeposits" runat="server"></asp:Label>
								</td>
							</tr>
							<tr>
								<td>
									Withdrawals
								</td>
								<td>
									<asp:Label id="lbWithdr" runat="server"></asp:Label>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr> <!------- 6 row ---------->
					<td align="center"   class ="cssReportHeader">
						Affiliates today
					</td>
					<td align="center">
						<table width="100%" style="FONT-SIZE: 14px">
							<tr>
								<td width="70%">
									New Affiliates
								</td>
								<td>
									<asp:Label id="lbAffNew" runat="server"></asp:Label>
								</td>
							</tr>
							<tr>
								<td>
									Unapproved affiliates
								</td>
								<td>
									<asp:Label id="lbAffUnapp" runat="server"></asp:Label>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<CDC:PAGEFOOTER id="oPageFooter" runat="server"></CDC:PAGEFOOTER>
		</form>
	</body>
</HTML>
