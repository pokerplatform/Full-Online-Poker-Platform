using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Xml;
using System.Data.SqlClient;  

using Common;
using Common.Web;

namespace Admin.CommonUse
{

	public class PrizeData
	{
		public DataSet DetDs=new DataSet(); 
        protected ArrayList m_order=new ArrayList();
           

		public string CheckPercent()
		{
			string steg="";
			string sFldEmpty="";
			string sNoOrder="";
			int row;
			string etName="";

			foreach(DataTable tb in DetDs.Tables)
			{
				if (tb.TableName.IndexOf("play_")>=0)
				{
					int sum=0;
					m_order.Clear(); 
					etName=tb.TableName.Replace("play_","") ;

					for(row=DetDs.Tables[tb.TableName].Rows.Count-1; row>=0; row--)
					{
						DataRow dr=DetDs.Tables[tb.TableName].Rows[row];  
						int iTo=Common.Utils.GetInt(dr["To"]);
						int iFrom= Common.Utils.GetInt(dr["From"]);
						int iPerc = Common.Utils.GetInt(dr["Prize Percent"]);
						if (iTo<=0 || iFrom<=0 || iPerc<=0)
						{
							sFldEmpty+="All or some fields in table " + etName +" is empty . ";
							break;
						}
						IntervalToOrder(iFrom,iTo); 
						sum+= iPerc ; //(Math.Abs(iFrom  - iTo )+1) *iPerc ;   
					}
					if (sum !=100)
						steg+="Table "+ etName+ " , ";

					m_order.Sort();
					if (m_order.Count<=0) 
					{
						sNoOrder+="Table "+ etName+ ": have not records , ";
					}
					else
					{
						DataRow rd=DetDs.Tables[etName].Rows[0];
						if(Common.Utils.GetInt(rd["From"]) < ((int)m_order[m_order.Count-1]) )
						{
							sNoOrder+="Table "+ etName+ ": incorrect order interval  , ";
						}
						else
						{
							for (row=0; row< m_order.Count-1 ;row++)
							{
								if(((int)m_order[row+1])-((int)m_order[row]) >1)
								{
									sNoOrder+="Table "+ etName+ ": incorrect order of Prizes , ";
								}
							}
						}
					}				
				}
			}

			if (steg.Length >0) steg=steg.Substring(0,steg.Length-3)+" not 100% of <Prize Percent>";  

			return sNoOrder+ sFldEmpty+ steg;
		}

		public void IntervalToOrder(int iFrom ,int iTo)  
		{
			 if (iFrom > iTo) return;
			if (iFrom==iTo)
			{
				 if (m_order.Contains(iFrom)) return;
				 m_order.Add(iFrom); 
			}
			int k;
			for (k=iFrom;k<=iTo;k++) 
			    m_order.Add(k); 
		}

		public string DataSetToXML(int pPrizetype,int pCurrencytypeID, int pValuetype)
		{
			string rets="<tournamentprize prizetype=\""+pPrizetype.ToString()+"\" currencytype=\""+ 
				                    pCurrencytypeID.ToString()+ "\" valuetype=\""+pValuetype.ToString()+ "\">";
			foreach(DataTable tb in DetDs.Tables)
			{
				string steg="";
				if (tb.TableName.IndexOf("play_")<0)
				{
					if (DetDs.Tables.Contains("play_"+tb.TableName)==false) continue;
					if (tb.Rows.Count <=0) continue;
					if(Common.Utils.GetInt(tb.Rows[0]["From"]) <=0) continue;
					if(Common.Utils.GetInt(tb.Rows[0]["To Finish"]) <=0) continue;
					if(DetDs.Tables["play_"+tb.TableName].Rows.Count  <=0) continue;
					steg="<players from=\"" + tb.Rows[0]["From"].ToString()+"\" playersforfinish=\""+tb.Rows[0]["To Finish"]+"\">";

					foreach(DataRow dr in  DetDs.Tables["play_"+tb.TableName].Rows)
					{
						if(Common.Utils.GetInt(dr["From"]) <=0 &&
							Common.Utils.GetInt(dr["To"]) <=0 && Common.Utils.GetInt(dr["Prize Percent"]) <=0) continue;
						steg+="<place from=\"" +dr["From"].ToString()+"\" to=\""+dr["To"].ToString()+
							"\" prizeRate=\""+ dr["Prize Percent"].ToString()+
                            "\" noncurrencyprize=\""+dr["Non Currency Prize"].ToString()+"\"/>";
 					}
					steg+="</players>";
				}
				rets+=steg;
			}
			rets+="</tournamentprize>";

			return rets;
		}


		public  void XMLToDataSet(string sXML) 
		{
			DetDs.Tables.Clear();
			if (sXML == String.Empty) return; 
			XmlDocument doc= new XmlDataDocument();
			doc.LoadXml(sXML);
			XmlNodeList ndl=doc.SelectNodes("tournamentprize/players"); 
			GetTableParameters(ndl); 
		}

		public string CreateIntervalTable(string sFrom,string sForFinish) 
		{
			string tn=sFrom+"_"+sForFinish;
			DataTable tb=null;

			if (DetDs.Tables.Contains(tn)) return "";

				tb= new DataTable(tn);
				tb.Columns.Add("From",System.Type.GetType("System.Int32"));   
				tb.Columns.Add("To Finish",System.Type.GetType("System.Int32")); 
				tb.Rows.Add(new object [] {Common.Utils.GetInt( sFrom),Common.Utils.GetInt(sForFinish)});  
			DetDs.Tables.Add(tb);  

			return tn;
		}

		public void GetTableParameters(XmlNodeList  e ) 
		{
			foreach (XmlElement el in e)
			{
				string sFrom=el.Attributes["from"].InnerText;  
				string sForFinish;
				try
				{
					sForFinish=el.Attributes["playersforfinish"].InnerText;  
				}
				catch
				{
					sForFinish=el.Attributes["to"].InnerText;  
				}
				CreateIntervalTable(sFrom,sForFinish);
				XmlNodeList nl= el.ChildNodes;
				GetPlayersParameters( nl , sFrom+"_"+sForFinish);
			}			
		}

		public bool CreateDataTable( string tbname,string sFrom , string sTo, string sPercent,string snoCurPrize,bool withremove)
		{
			DataTable tb=null;

			if(withremove)
			{
				if (DetDs.Tables.Contains("play_"+tbname))
					DetDs.Tables.Remove("play_"+tbname);
			}

			if (DetDs.Tables.Contains("play_"+tbname)==false)
			{
				tb= new DataTable("play_"+tbname);
				tb.Columns.Add("From",System.Type.GetType("System.Int32"));   
				tb.Columns.Add("To",System.Type.GetType("System.Int32"));   
				tb.Columns.Add("Prize Percent",System.Type.GetType("System.Int32"));   
				tb.Columns.Add("Non Currency Prize",System.Type.GetType("System.String"));   
				tb.DefaultView.AllowEdit=true;  
				tb.DefaultView.AllowDelete=true;  
				tb.DefaultView.AllowNew=true;  
				DetDs.Tables.Add(tb);  
			}
			else
			{
				tb=DetDs.Tables["play_"+tbname];
			}

			tb.Rows.Add(new object [] {Common.Utils.GetInt( sFrom),Common.Utils.GetInt(sTo),Common.Utils.GetInt(sPercent),snoCurPrize});  
			return true;
		}

		public void GetPlayersParameters(XmlNodeList  e,string tbname ) 
		{
			if (DetDs.Tables.Contains("play_"+tbname))
					    DetDs.Tables.Remove("play_"+tbname);

			foreach (XmlElement el in e)
			{
				string sFrom=el.Attributes["from"].InnerText;  
				string sTo=el.Attributes["to"].InnerText;  
				string sPercent=el.Attributes["prizeRate"].InnerText;  
				string snoCurPrize=el.Attributes["noncurrencyprize"].InnerText;  
				CreateDataTable(tbname,sFrom,sTo,sPercent,snoCurPrize,false); 
			}			
		}

	}
}
