namespace Admin.Controls
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;
	using System.Data.SqlClient;  
	using System.Web.UI;

	/// <summary>
	///		Summary description for PrizeGrid.
	/// </summary>
	public class PrizeGrid : System.Web.UI.UserControl
	{

        private DataTable grTable=null;
		private DataTable hdrTable=null;

		protected System.Web.UI.HtmlControls.HtmlTable tablePrize; 
		protected System.Web.UI.WebControls.TextBox txFrom;
		protected System.Web.UI.WebControls.TextBox txToFinish;
		protected System.Web.UI.HtmlControls.HtmlTable TableH;
		protected System.Web.UI.HtmlControls.HtmlTable TbFloor;
		protected System.Web.UI.HtmlControls.HtmlInputButton btn_AddRow;
		protected System.Web.UI.HtmlControls.HtmlInputButton btnDeletePrize;
		protected System.Web.UI.HtmlControls.HtmlInputButton btn_DeleteRow;

		protected System.Web.UI.HtmlControls.HtmlSelect PrefList;

		private const int tbFixedRows=1;

		private void Page_Load(object sender, System.EventArgs e)
		{
		}

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion


	/*	public bool SaveData()
		{
              hdrTable.Rows.Clear();  
			  int nFrom=Common.Utils.GetInt( txFrom.Text);  
			  int nToFinish=Common.Utils.GetInt( txToFinish.Text);  
			  if ( nFrom <=0 ) nFrom=nToFinish;
			  if ( nToFinish<=0 ) nToFinish=nFrom;
			  if ( nFrom <=0 ) nFrom=1;
			  if ( nToFinish<=0 ) nToFinish=1;
				hdrTable.Rows.Add(new object [] {nFrom,nToFinish});  

				grTable.Rows.Clear();  
			    int l =0 , sum=0;
			for(l=1;l<tablePrize.Rows.Count;l++)
			{
				 TextBox tb=(TextBox) tablePrize.Rows[l].Cells[0].Controls[0];  
				 TextBox tb1=(TextBox) tablePrize.Rows[l].Cells[1].Controls[0];
				 TextBox tb2=(TextBox) tablePrize.Rows[l].Cells[2].Controls[0];
				  nFrom=Common.Utils.GetInt( tb.Text);  
				  nToFinish=Common.Utils.GetInt( tb1.Text);  
				  if (nFrom<=0) continue;
				  if (nToFinish<=0) nToFinish= nFrom;
				  int nPerc=Common.Utils.GetInt( tb2.Text);  
				  if (nPerc<=0) continue;
					grTable.Rows.Add(new object [] {nFrom,nToFinish,nPerc});  
				   sum+=nPerc;
			}

			if (sum > 100)
			{
				for(l=0;l< grTable.Rows.Count ;l++)
				{
					int ff=(int) grTable.Rows[l]["Prize Percent"];   
					if (ff-sum<0)
					{
						sum-=ff;
						grTable.Rows[l]["Prize Percent"]=0;
					}
					else
					{
						sum-=ff;
						grTable.Rows[l]["Prize Percent"]=ff-sum;
					}
					if(sum==0) break;
				}
			}

			return true;
		}
*/
		public void IInit(object sender, System.EventArgs e)
		{
			PrefList.Items.Add(((TextBox)sender).ClientID.Replace("txFrom","") );   
		}

		private void DoDataBind()
		{
			ClearRows();
			txFrom.Text =hdrTable.Rows[0]["From"].ToString();  
			txToFinish.Text =hdrTable.Rows[0]["To Finish"].ToString();  
			int k;
			for(k=0;k< grTable.Rows.Count ;k++)
			{
                DataRow dr=grTable.Rows[k];
				HtmlTableRow  row = new HtmlTableRow();
					for (int i=0; i<4; i++) 
					{
						HtmlTableCell cell = new HtmlTableCell();
						TextBox tb= new TextBox();
						tb.ID =grTable.TableName+"_tb_"+ k.ToString() + "_"+i.ToString();
						tb.Text =dr[i].ToString();
						cell.Controls.Add(tb);
						row.Cells.Add(cell);
				}
				tablePrize.Rows.Add(row);
			}
		}

		private void ClearRows()
		{
			if(tablePrize==null) return;
			if(tablePrize.Rows ==null) return;
			int l=0;
			for(l=tablePrize.Rows.Count-1;l>tbFixedRows;l--)
			{
                tablePrize.Rows.RemoveAt(l); 
			}
		}

		public void InitControl(DataTable tb,DataTable hdrtb,System.Web.UI.HtmlControls.HtmlSelect pref)
		{
			 PrefList=pref;
			 grTable=tb;
			 hdrTable=hdrtb;
			 DoDataBind();
		}

	}
}
