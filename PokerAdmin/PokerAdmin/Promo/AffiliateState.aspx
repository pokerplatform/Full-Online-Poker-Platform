<%@ Register TagPrefix="uc1" TagName="Banners" Src="Banners.ascx" %>
<%@ Page language="c#" Codebehind="AffiliateState.aspx.cs" AutoEventWireup="false" Inherits="Promo.AffiliateState" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>Affiliate's State</title>
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
			<table cellSpacing="0" cellPadding="0" width="80%" align="left" border="0">
				<TBODY>
					<tr>
						<td colSpan="2"><asp:image id="oImg" Runat="server" ImageUrl="img/001-bikini-poker_nofree.gif"></asp:image></td>
					</tr>
					<tr>
						<td colSpan="2"><asp:image id="Image1" Runat="server" ImageUrl="img/002-bikini-poker.gif"></asp:image></td>
					</tr>
					<tr>
						<td vAlign="top" bgcolor="#86a8ce" width="22%"><asp:image id="Image2" Runat="server" ImageUrl="img/body_girl-poker.gif"></asp:image></td>
						<td rowSpan="1" valign="top">
							<table style="BORDER-RIGHT: #86a8ce 1px solid; BORDER-TOP: #86a8ce 1px solid; BORDER-LEFT: #013567 1px solid; BORDER-BOTTOM: #86a8ce 1px solid"
								width="97%" align="left">
								<TBODY>
									<tr>
										<td align="center">
											<table cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
												<tr>
													<td class="cssPageName" align="center">Affiliate's State<br>
														<br>
													</td>
												</tr>
											</table>
											<asp:panel id="pnLogin" runat="server" HorizontalAlign="Center">
												<asp:label id="lblInfo" Runat="server" EnableViewState="False" ForeColor="Red"></asp:label>
												<TABLE width="60%" align="center" border="0">
													<TR>
														<TD>
															<TABLE class="cssReport cssTextMain" borderColor="#3399ff" cellSpacing="0" cellPadding="2"
																width="60%" align="center" border="1">
																<TR>
																	<TD style="WIDTH: 79px" align="left">Login</TD>
																	<TD align="left">
																		<asp:textbox id="txtLogin" Runat="server" Width="100%" MaxLength="50"></asp:textbox></TD>
																</TR>
																<TR>
																	<TD style="WIDTH: 79px" align="left">Password</TD>
																	<TD align="left">
																		<asp:textbox id="txtPassword" Runat="server" Width="100%" MaxLength="50" textmode="Password"></asp:textbox></TD>
																</TR>
															</TABLE>
														</TD>
													</TR>
													<TR>
														<TD>
															<TABLE align="center">
																<TR>
																	<TD>
																		<asp:button id="btnSignUp" runat="server" Text="Login"></asp:button></TD>
																</TR>
															</TABLE>
														</TD>
													</TR>
												</TABLE>
											</asp:panel>
											<table width="100%" align="center">
												<tr>
													<td><asp:panel id="pnData" runat="server" Width="100%" Height="100%">
															<asp:LinkButton id="lbtToState" runat="server">Go to Statistic</asp:LinkButton>
															<TABLE align="center">
																<TR>
																	<TD align="center">
																		<uc1:Banners id="Banners1" runat="server"></uc1:Banners></TD>
																</TR>
															</TABLE>
														</asp:panel>
														<asp:Panel id="pnStat" runat="server">
															<asp:LinkButton id="lbtData" runat="server">Go to Banners</asp:LinkButton>
															<TABLE width="97%" align="center">
																<TR>
																	<TD align="center">
																		<asp:Label id="lbInfo" runat="server" ForeColor="Green"></asp:Label></TD>
																</TR>
																<TR>
																	<TD>
																		<TABLE class="cssReport cssTextMain" borderColor="#3399ff" cellSpacing="0" cellPadding="2"
																			width="100%" align="center" border="1">
																			<TR>
																				<TD align="center" colSpan="2">Date from:
																					<asp:textbox id="txtDateFrom" runat="server" MaxLength="10"></asp:textbox><INPUT class="cButton" onclick="CurrentFieldName='txtDateFrom';set_today(this);" type="button"
																						value="..."> &nbsp;to:
																					<asp:textbox id="txtDateTo" runat="server" MaxLength="10"></asp:textbox><INPUT class="cButton" onclick="CurrentFieldName='txtDateTo';set_today(this);" type="button"
																						value="..."></TD>
																			</TR>
																			<TR>
																				<TD align="center">
																					<asp:Button id="btReport" runat="server" Text="Show"></asp:Button></TD>
																			</TR>
																		</TABLE>
																	</TD>
																</TR>
																<TR>
																	<TD align="center">
																		<asp:DataGrid id="dgAffilPeriod" runat="server" Width="100%" PagerStyle-Mode="NumericPages" PageSize="50"
																			CssClass="cssReport cssTextMain" BorderColor="#3399FF" AutoGenerateColumns="False" Visible="True">
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
																		</asp:DataGrid></TD>
																</TR>
																<TR>
																	<TD align="right">
																		<asp:Label id="lbSumCaption" runat="server">Summa</asp:Label>&nbsp;
																		<asp:Label id="lbRakeSum" runat="server" Width="177px" Font-Bold="True">0</asp:Label></TD>
																</TR>
															</TABLE>
														</asp:Panel>
													</td>
												</tr>
											</table>
											<!--						</td>
								</tr>-->
											<!--								<tr>
									<td colspan="1" bgcolor="#86a8ce">&nbsp;</td>
									<td></td>
								</tr>-->
											<!--</table> -->
											<INPUT id="hdnAffID" type="hidden" runat="server"> <INPUT id="hdnSkinsID" type="hidden" runat="server">
		</form>
		<IFRAME name="calendar" WIDTH="5" HEIGHT="5" scrolling="no" marginwidth="0" marginheight="0"
			style="LEFT: 10px; VISIBILITY: hidden; POSITION: absolute; TOP: 10px"></IFRAME>
		</TD></TR></TBODY></TABLE></TD></TR></TBODY></TABLE>
	</body>
</HTML>
