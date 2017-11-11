<%@ Control Language="c#" AutoEventWireup="false" Codebehind="GridPager.ascx.cs" Inherits="Admin.Controls.GridPager" TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>
<asp:Table ID="oGridPager" Runat="server">
	<asp:TableRow>
		<asp:TableCell>
			<asp:ImageButton ID="btnFirst" OnClick="OnPageIndexChanged" CommandName="First" Runat="server" />
		</asp:TableCell>
		<asp:TableCell>
			<asp:ImageButton ID="btnPrev" OnClick="OnPageIndexChanged" CommandName="Prev" Runat="server" />
		</asp:TableCell>
		<asp:TableCell>
			<asp:RangeValidator Type="Integer" MinimumValue="1" MaximumValue="55554" ControlToValidate="txtPageNum" id="rvCurrentPage" ErrorMessage="Incorrect current page numeric value" Display="Dynamic" runat="server">&nbsp;Incorrect integer&nbsp;</asp:RangeValidator>
			page&nbsp;<asp:TextBox ID="txtPageNum" Width="40px" MaxLength="4" Runat="server" />
			&nbsp;of&nbsp;<asp:Label ID="lblPageCount" Runat="server">1</asp:Label>
		</asp:TableCell>
		<asp:TableCell>
			<asp:ImageButton ID="btnNext" OnClick="OnPageIndexChanged" CommandName="Next" Runat="server" />
		</asp:TableCell>
		<asp:TableCell>
			<asp:ImageButton ID="btnLast" OnClick="OnPageIndexChanged" CommandName="Last" Runat="server" />
		</asp:TableCell>
		<asp:TableCell></asp:TableCell>
		<asp:TableCell Wrap="False">
			<asp:TextBox ID="txtItemsPerPage" MaxLength="6" Width="40px" Runat="server" />
			&nbsp;Items Per Page&nbsp;<i>(* - all items)</i>
		</asp:TableCell>
		<asp:TableCell Width="30%"></asp:TableCell>
	</asp:TableRow>
</asp:Table>
