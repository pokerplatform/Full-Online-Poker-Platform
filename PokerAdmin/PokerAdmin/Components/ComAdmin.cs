using System;
using System.Collections;
using COMAdmin;

namespace Admin.Components
{
	/// <summary>
	/// Summary description for Remoting.
	/// </summary>
	public class ComAdmin
	{
		private ICOMAdminCatalog oComAdmin = null;
		private COMAdminCatalogCollection oAppCollection = null;
		private COMAdminCatalogCollection oCollection = null;

		private string sLogin = string.Empty;
		private string sPassword = string.Empty;
		private string sDomain = string.Empty;
		private string sServer = "";//Config.ComServer;

		public ComAdmin(){}
		public ComAdmin(string sServerName)
		{
			sServer = sServerName;
		}
		public ComAdmin(string sServerName, string sLogin, string sPassword, string sDomain)
		{
			this.sServer = sServerName;
			this.sLogin = sLogin;
			this.sPassword = sPassword;
			this.sDomain = sDomain;
		}

		public ICOMAdminCatalog GetCatalog()
		{
			if ( oComAdmin == null )
			{
				oComAdmin = (ICOMAdminCatalog)new COMAdminCatalog();
				oComAdmin.Connect(sServer);
			}
			return oComAdmin;
		}
		public COMAdminCatalogCollection GetCatalogCollection()
		{
			if ( oAppCollection == null )
			{
				oAppCollection = (COMAdminCatalogCollection)GetCatalog().GetCollection("Applications");
				oAppCollection.Populate();
			}
			return oAppCollection;
		}

		public COMAdminCatalogCollection GetAppItems()
		{
			if ( oCollection == null )
			{
				try
				{
					COMAdminCatalogCollection appColl = GetCatalogCollection();
					foreach(COMAdminCatalogObject app in appColl )
					{
						if ( app.Name.ToString().ToLower() == "")//Config.ComApplication.ToLower() )
						{
							oCollection = (COMAdminCatalogCollection)appColl.GetCollection("Components", app.Key);
							oCollection.Populate();
							break;
						}
					}
				}
				catch(Exception oEx)
				{
					Common.Log.Write(this, oEx);
				}
			}
			return oCollection;
		}

		public ArrayList GetAppItemsList()
		{
			COMAdminCatalogCollection oList = GetAppItems();
			ArrayList oRes = new ArrayList();
			if ( oList != null )
			{
				foreach(COMAdminCatalogObject obj in oList )
				{
					oRes.Add(obj.Name);
				}
			}
			else
			{
				Common.Log.Write(this, "Can't retrieve remote COM list");
			}
			return oRes;
		}
	}
}
