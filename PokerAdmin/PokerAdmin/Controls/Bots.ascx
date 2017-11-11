<%@ Control Language="c#" AutoEventWireup="false" Codebehind="Bots.ascx.cs" Inherits="Admin.Controls.Bots" TargetSchema="http://schemas.microsoft.com/intellisense/ie5"%>
<%@ Register TagPrefix="CBC" TagName="ButtonImage" Src="../Controls/ButtonImage.ascx" %>
<TABLE class="cssTextMain" style="WIDTH: 642px; HEIGHT: 30px" align="center">
	<TR>
		<TD class="cssTextCaption" align="center"><asp:label id="LbSection" runat="server"></asp:label></TD>
	</TR>
</TABLE>
<TABLE class="cssTextMainWithBorder" style="WIDTH: 642px" align="center">
	<TR>
		<TD>Bot's type:
			<asp:dropdownlist id="ddSitdownType_Auto" runat="server">
				<asp:ListItem Value="0">Cautious</asp:ListItem>
				<asp:ListItem Value="1">Normal</asp:ListItem>
				<asp:ListItem Value="2">Aggressive</asp:ListItem>
			</asp:dropdownlist></TD>
		<TD>Max number per process :
			<asp:dropdownlist id="ddMaxNumber_Auto" runat="server">
				<asp:ListItem Value="2">2</asp:ListItem>
				<asp:ListItem Value="3">3</asp:ListItem>
				<asp:ListItem Value="4">4</asp:ListItem>
				<asp:ListItem Value="5">5</asp:ListItem>
				<asp:ListItem Value="6">6</asp:ListItem>
				<asp:ListItem Value="7">7</asp:ListItem>
				<asp:ListItem Value="8">8</asp:ListItem>
				<asp:ListItem Value="9">9</asp:ListItem>
				<asp:ListItem Value="10">10</asp:ListItem>
			</asp:dropdownlist></TD>
		<TD><asp:checkbox id="chAuto" runat="server" Text="Enable Auto"></asp:checkbox></TD>
	</TR>
	<TR>
		<td align="center" colSpan="3">
			<table align="center">
				<tr>
					<TD><CBC:BUTTONIMAGE id="btnSitdownAuto" onclick="btnSitdownAuto_Click" runat="server" Text="Sitdown Auto"></CBC:BUTTONIMAGE></TD>
					<TD><CBC:BUTTONIMAGE id="btnStandUpwp" onclick="btnStandUpwp_Click" runat="server" Text="Stand Up All"></CBC:BUTTONIMAGE></TD>
				</tr>
			</table>
		</td>
	</TR>
</TABLE>
<TABLE class="cssTextMainWithBorder" style="WIDTH: 642px" align="center">
	<TR>
		<TD align="center">Select target
			<asp:dropdownlist id="ddProcesses" runat="server"></asp:dropdownlist></TD>
	</TR>
	<tr>
		<TD align="center"><CBC:BUTTONIMAGE id="btnStandUpAll" onclick="btnStandUpAll_Click" runat="server" Text="Stand Up All"></CBC:BUTTONIMAGE></TD>
	</tr>
</TABLE>
<table class="cssTextMainWithBorder" style="WIDTH: 642px" align="center">
	<tr>
		<TD align="center">Bot's type:
			<asp:dropdownlist id="ddSitdownType_Add" runat="server">
				<asp:ListItem Value="0">Cautious</asp:ListItem>
				<asp:ListItem Value="1">Normal</asp:ListItem>
				<asp:ListItem Value="2">Aggressive</asp:ListItem>
			</asp:dropdownlist></TD>
		<td align="center">Max number :
			<asp:dropdownlist id="ddMaxNumber_Add" runat="server">
				<asp:ListItem Value="2">2</asp:ListItem>
				<asp:ListItem Value="3">3</asp:ListItem>
				<asp:ListItem Value="4">4</asp:ListItem>
				<asp:ListItem Value="5">5</asp:ListItem>
				<asp:ListItem Value="6">6</asp:ListItem>
				<asp:ListItem Value="7">7</asp:ListItem>
				<asp:ListItem Value="8">8</asp:ListItem>
				<asp:ListItem Value="9">9</asp:ListItem>
				<asp:ListItem Value="10">10</asp:ListItem>
			</asp:dropdownlist>
			<asp:TextBox id="txtMaxNumber" runat="server" Width="118px"></asp:TextBox></td>
		<td align="center"><CBC:BUTTONIMAGE id="btnAddBots" onclick="btnAddBots_Click" runat="server" Text="Add Bots"></CBC:BUTTONIMAGE></td>
	</tr>
</table>
<table class="cssTextMainWithBorder" style="WIDTH: 642px" align="center">
	<TR>
		<TD align="center"><CBC:BUTTONIMAGE id="btnGetInfo" onclick="btnGetInfo_Click" runat="server" Text="Get Info"></CBC:BUTTONIMAGE></TD>
		<td><CBC:BUTTONIMAGE id="btnStandUp" onclick="btnStandUp_Click" runat="server" Text="Stand Up"></CBC:BUTTONIMAGE></td>
		<TD align="center">Bot's type:
			<asp:dropdownlist id="ddSitdownType_Policy" runat="server">
				<asp:ListItem Value="0">Cautious</asp:ListItem>
				<asp:ListItem Value="1">Normal</asp:ListItem>
				<asp:ListItem Value="2">Aggressive</asp:ListItem>
			</asp:dropdownlist></TD>
		<td align="center"><CBC:BUTTONIMAGE id="btnSetupPolicy" onclick="btnSetupPolicy_Click" runat="server" Text="Setup Policy"></CBC:BUTTONIMAGE></td>
	</TR>
</table>
<TABLE class="cssTextMainWithBorder" style="WIDTH: 642px" align="center">
	<tr>
		<td align="center" colSpan="3"><asp:label id="lbState" runat="server" EnableViewState="False" ForeColor="Red"></asp:label></td>
	</tr>
	<TR>
		<TD align="center"><asp:datagrid id="oGrid" runat="server" AllowPaging="True" CssClass="cssReport cssTextMain" BorderColor="#3399FF"
				CellPadding="2" HorizontalAlign="Center" AutoGenerateColumns="False">
				<AlternatingItemStyle CssClass="cssReportItemOdd"></AlternatingItemStyle>
				<ItemStyle CssClass="cssReportItem"></ItemStyle>
				<HeaderStyle CssClass="cssReportHeader"></HeaderStyle>
				<Columns>
					<asp:TemplateColumn>
						<HeaderStyle Width="30px"></HeaderStyle>
						<ItemTemplate>
							<%#GetCheckBoxHtml(Container.DataItem)%>
						</ItemTemplate>
					</asp:TemplateColumn>
					<asp:BoundColumn DataField="ID" HeaderText="Bot's ID"></asp:BoundColumn>
					<asp:BoundColumn DataField="LoginName" HeaderText="Login Name"></asp:BoundColumn>
					<asp:BoundColumn DataField="ChairID" HeaderText="Chair"></asp:BoundColumn>
					<asp:BoundColumn DataField="Type" HeaderText="Type"></asp:BoundColumn>
					<asp:BoundColumn DataField="ProcessID" HeaderText="Process ID"></asp:BoundColumn>
				</Columns>
				<PagerStyle HorizontalAlign="Left" Mode="NumericPages"></PagerStyle>
			</asp:datagrid></TD>
	</TR>
</TABLE>
