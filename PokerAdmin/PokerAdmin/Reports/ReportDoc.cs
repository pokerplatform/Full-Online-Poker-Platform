using CrystalDecisions.CrystalReports.Engine;   
using CrystalDecisions.Shared;
using System.Data.SqlClient ; 
using System.Data; 
using System;
using Common;

namespace Admin.Reports
{
	public class ReportDoc
	{

		public struct struDBLogon
		{
			public string User;
			public string Password;
			public string Server;
			public string Database;
		}

		protected string m_cnString="";
		protected int m_CommandTimeout=-1;
		public struDBLogon m_DBLogonInfo=new struDBLogon();
		protected Common.Db.Base  m_oDb;

		TableLogOnInfo crTableLogOnInfo = new TableLogOnInfo();
		ConnectionInfo crConnectionInfo = new ConnectionInfo();

		//CrystalDecisions.CrystalReports.Engine.Database crDatabase;
	//	CrystalDecisions.CrystalReports.Engine.Tables crTables;

 
		public  Common.Db.Base  oDb
		{
			get{return m_oDb;}
		}

		public ReportDoc(string cnString, int pCommandTimeout, Common.Db.Base oDb)
		{
			Init(cnString, pCommandTimeout,oDb);
		}
		public ReportDoc(string cnString, Common.Db.Base oDb)
		{
			Init(cnString,-1,oDb);
		}
        
		protected void Init(string cnString, int pCommandTimeout, Common.Db.Base oDb)
		{
			        m_oDb=oDb;
			        m_cnString = cnString;
                    ParseConnectionString();
                    m_CommandTimeout = pCommandTimeout;
			        oDb.CommandTimeOut =pCommandTimeout;
                    InitClass();
		}

		protected void InitClass()
		{
		}

		protected void ParseConnectionString()
		{
			if (m_cnString.Length <= 0) return;
			string[] prm = m_cnString.Split(';');
			int l;
			int pos;
			String sStr;
			String rStr;
			for (l = 0;l<prm.Length;l++)
			{
				pos = prm[l].IndexOf("=");
				if (pos >= 0)
				{
					sStr = prm[l].Substring(0, pos).ToLower().Trim();
					rStr = prm[l].Substring(pos + 1);
					if (sStr.StartsWith("database"))  m_DBLogonInfo.Database = rStr;
					if (sStr.StartsWith("user"))  m_DBLogonInfo.User = rStr;
					if (sStr.StartsWith("password"))  m_DBLogonInfo.Password = rStr;
					if (sStr.StartsWith("server"))  m_DBLogonInfo.Server = rStr;
				}
			}
		}

		public DataSet CreateReportSource(string qwString ,string TableName , object []  prm)
		{
			DataTable dt; 
			try
			{
				dt=m_oDb.GetDataTable(qwString,prm); 
				dt.TableName=TableName;
				DataSet ds=new DataSet(TableName); 
				ds.Tables.Add(dt);
				return ds;
			}
			catch(Exception ex)
			{
				Log.Write(this,ex); 
				return null;
			}
		}

		public CrystalDecisions.CrystalReports.Engine.ReportDocument GetReportDocument(string repFile, DataSet pDSet) 
		{
			try
			{
				if (pDSet.Tables.Count <= 0)
				{
					if (Config.GetConfigValue("TestRegime")== "true")
					{
						Log.Write(this,"DataSet Tables Count 0");   
					}
					 return null;
				}
				CrystalDecisions.CrystalReports.Engine.ReportDocument  oRepDoc =
					new CrystalDecisions.CrystalReports.Engine.ReportDocument();
				oRepDoc.Load(repFile);
				if (Config.GetConfigValue("TestRegime")== "true")
				{
					Log.Write(this,"Report File: "+repFile+" loaded");   
				}
		//		if (m_DBLogonInfo.Server != String.Empty)
			//		oRepDoc.SetDatabaseLogon(m_DBLogonInfo.User, m_DBLogonInfo.Password, m_DBLogonInfo.Server, m_DBLogonInfo.Database);

/*
				crConnectionInfo.ServerName = m_DBLogonInfo.Server;
				crConnectionInfo.DatabaseName = m_DBLogonInfo.Database;
				crConnectionInfo.UserID = m_DBLogonInfo.User;
				crConnectionInfo.Password = m_DBLogonInfo.Password;
				crDatabase = oRepDoc.Database;
				crTables = crDatabase.Tables;

				foreach(CrystalDecisions.CrystalReports.Engine.Table crTable in crTables)
				{
					crTableLogOnInfo = crTable.LogOnInfo;
					crTableLogOnInfo.ConnectionInfo = crConnectionInfo;
					crTable.ApplyLogOnInfo(crTableLogOnInfo);
				}
*/
				oRepDoc.SetDataSource(pDSet);
				if (Config.GetConfigValue("TestRegime")== "true")
				{
					Log.Write(this,"DataSource was set");   
				}

				return oRepDoc;
			}
			catch(Exception ex)
			{
				Log.Write(this,ex); 
				return null;
			}
		}

		public void SetReportDatabaseLogon(string pUser,string pPassword, string pServer,string pDatabase)
		{
			m_DBLogonInfo.Database = pDatabase;
			m_DBLogonInfo.Password = pPassword;
			m_DBLogonInfo.Server = pServer;
			m_DBLogonInfo.User = pUser;
			m_cnString = String.Format("Server={0};Database={1};User ID={2};Password={3}", pServer, pDatabase, pUser, pPassword);
			InitClass(); 
		}

	}
}
