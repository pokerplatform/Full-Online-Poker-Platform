using System;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Web;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Admin.CommonUse;
using Common;
using Common.Web;

namespace Admin.Misc
{
	/// <summary>
	/// Summary description for GameProcessMaintenance.
	/// </summary>
	public class ClientApplicationFile : Page //Components.MaintenancePage
	{
		protected Label lblInfo;
		protected DataTable oDTContentType = null; 
		PostedFile oPostedFile = null;
		const string chkBoxName = "SelectedID";
		const string chkComboName = "combo_";
		const string edtName = "edt_";
		const int ContentTypeExecutable = 4;
		const string zipExtension = ".zip";
		protected DropDownList ddSkins;
		protected DataGrid oGrid;
		protected DropDownList combo_0;
		protected HtmlInputHidden hdnGameEngineID;

		private int AffID=0;

		#region HTML controls bindings
		public static string EditBoxHtml(object oRow,string columnname)
		{
			string sName  = ((DataRowView)oRow)[Config.SqlDefaultIdColumnName].ToString();
			string sValue = ((DataRowView)oRow)[columnname].ToString();
			return string.Format("<input type='text' style='width:40' name='{0}' value='{1}'>", edtName+sName+"_"+columnname, sValue);
		}

		public static string BrowseHtml(object oRow)
		{
			string sName = ((DataRowView)oRow)[Config.SqlDefaultIdColumnName].ToString();
			return string.Format("<input type='file' style='width:300' name='{0}'>", sName);
		}
		
		public static string CheckBoxHtml(object oRow)
		{
			string sName = ((DataRowView)oRow)[Config.SqlDefaultIdColumnName].ToString();
			return string.Format("<input type='checkbox' name='" + chkBoxName + "' value=\"{0}\">", sName);
		}

		public string ComboBoxHtml(object oRow)
		{
			int contentTypeID = Convert.ToInt32(((DataRowView)oRow)["contentTypeID"]);
			string sOption = "";
			string selected = "";
			foreach(DataRow oRowContent in oDTContentType.Rows)
			{
				selected = "";
				if (Convert.ToInt32(oRowContent["ID"])==contentTypeID) selected = "selected";
				sOption += "<option value='" + oRowContent["ID"].ToString() + "' " + selected + ">" + oRowContent["Name"].ToString() + "</option>";
			}

			string sName = ((DataRowView)oRow)[Config.SqlDefaultIdColumnName].ToString();
			return string.Format("<select name='" + chkComboName + sName + "'>" + sOption + "</select>");
		}

		#endregion

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
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
			this.oGrid.PageIndexChanged += new DataGridPageChangedEventHandler(this.oGrid_PageIndexChanged);
			this.Load += new EventHandler(this.Page_Load);

		}
		#endregion

		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				DBase.FillList(ddSkins ,"admGetDictionarySkins",false); 
				ddSkins.Items.RemoveAt(0);  
				if (ddSkins.Items.Count>0)
				{
					AffID=int.Parse( ddSkins.SelectedValue );
					BindDataGrid();
				}
			}
			else
			{
				AffID=int.Parse( ddSkins.SelectedValue );
				BindDataGrid();
			}
		}

		protected void btnSelectSkin_Click(object sender, EventArgs e)
		{
			AffID=int.Parse( ddSkins.SelectedValue );
			BindDataGrid();
		}

		protected void  BindDataGrid()
		{
			oDTContentType = GetDataTable(Config.DbDictionaryContentType);
			DataView dv = new DataView(oDTContentType);
			DBase.FillList(combo_0, "0", dv);

			DataTable oDT = GetDataTable(Config.DbGetClientApplicationFileList, new object[] {"@SkinsID",AffID });
			oGrid.DataSource = oDT;
			oGrid.DataBind();
		}


		protected void btnSave_Click(object sender, EventArgs e)
		{ 
			int fileID = -1;
			int originalFileID = -1;
			string sKey = "";
			string sError = "";
			string sErrorVersion = "";
			string sErrorContentType = "";
			int iVersion = -1;
			bool bRes = false;
			string tranName = "";
			int iContentType = -1;
			int executableCount = 0;
			string fileList = "";
			DataRow oRow =null;

            if(AffID <=0) return;

			oPostedFile=new PostedFile(AffID);
  
			//1. Content type and version changes
			tranName = "updateClientApplication";
			DBase.BeginTransaction(tranName);
			DataTable oDT = DBase.GetDataTableBatch(String.Format(Config.ClientFilesBatchSQL ,AffID));
			DataColumn[] PrimaryKeyArrayVersion = new DataColumn[1];
			PrimaryKeyArrayVersion[0] = oDT.Columns["ID"];
			oDT.PrimaryKey = PrimaryKeyArrayVersion;
			for (int i=0;i<Request.Form.AllKeys.Length;i++)
			{
				string sFormKey = Request.Form.AllKeys[i];
				string [] tags=sFormKey.TrimStart('_').Split('_');
                
				if (tags.Length <2) continue;
             
				//a. content Type
				if (tags[0] ==chkComboName.TrimEnd('_'))
				{
					fileID = Convert.ToInt32(sFormKey.Substring(chkComboName.Length));
					iContentType = Convert.ToInt32(Request[sFormKey]);
					if ((fileID >0 ) && (iContentType == ContentTypeExecutable)) executableCount++;
					  oRow = oDT.Rows.Find(fileID);
					if ((oRow!=null) &&	(oRow["contentTypeID"]!=DBNull.Value) &&
						(Convert.ToInt32(oRow["contentTypeID"])!=iContentType))
					{
						if (executableCount>1)
						{
							sErrorContentType += "You can not have more than one executable file. Content type of file " + oRow["name"] + " remains the same.<br>";
						}
						else
						{
							oRow["contentTypeID"] = iContentType;
						}
					}
				}
				else if (tags[0] ==edtName.TrimEnd('_'))  //b. File Version
				{
					fileID = Convert.ToInt32(tags[1]);
					oRow = oDT.Rows.Find(fileID);
					if (oRow !=null)
					{
						if (tags[2]=="version")
						{
							iVersion = Utils.GetInt(Request[sFormKey]);
							if (oRow[tags[2]] !=DBNull.Value)
							{
								if (Convert.ToInt32(oRow[tags[2]])>iVersion)
								{
									sErrorVersion += "Version you specified for file: " + oRow["name"] + " is not correct or lower than existing one. File version was not changed.<br>"; 
								}
								else if (Convert.ToInt32(oRow[tags[2]])<iVersion)
								{
									oRow[tags[2]] = iVersion;
								}
							}
							else
								oRow[tags[2]] = iVersion;
						}
						else
						    oRow[tags[2]] =Utils.GetInt(Request[sFormKey]);
					}
				}
			}

			bRes = DBase.Update(oDT);
			if (bRes) DBase.CommitTransaction(tranName);
			else
			{
				DBase.RollbackTransaction(tranName);
				lblInfo.Text = "DataBase error occured during updating table";
				lblInfo.ForeColor = Color.Red;
				return;
			}
			sError += sErrorContentType + sErrorVersion;


			//2. file upload
			for (int i=0; i<Request.Files.Count; i++)
			{
				sKey = Request.Files.AllKeys[i];
				fileID = -1;
				if ((sKey!=null) && (sKey!="")) fileID = Convert.ToInt32(sKey);
				originalFileID = fileID;
				iContentType = -1;
				if (Request[chkComboName + sKey]!=null) iContentType = Convert.ToInt32(Request[chkComboName + sKey]);
				if ((iContentType == ContentTypeExecutable)&& (originalFileID<=0)) executableCount++;
				if ((executableCount > 1) && (originalFileID <= 0))
				{
					sError += "You can not upload one more executable file. New file wasn't upload";
				}
				else
				{
					HttpPostedFile postFile = Request.Files[i];
					if ((postFile.FileName!="") && (postFile.FileName!=null))
					{
						string sErrorUpload = "";
						string fileExtension = Path.GetExtension(postFile.FileName);
						if (fileExtension == zipExtension)
						{
							sErrorUpload = oPostedFile.SaveZipFile(Page, postFile, iContentType, ref fileList);
						}
						else
						{
							sErrorUpload = oPostedFile.SaveFile(Page, postFile, iContentType, ref fileID);
						}
						if (sErrorUpload!="") sError += sErrorUpload + "<br>";
					}
				}
			}

			//File Upload result
			if (sError=="") 
			{
				lblInfo.Text = "File upload succeeded";
				lblInfo.ForeColor = Color.Green;
			}
			else 
			{
				lblInfo.Text = "There were errors during file upload. Some files could not be uploaded. See details below:<br>" + sError;
				lblInfo.ForeColor = Color.Red;
			}
			RunBat();
			BindDataGrid();
		}

		protected bool RunBat()
		{
			string secBat= Config.GetAffiliatePath(AffID ,true,false)+"\\"+Config.FileSecurityBat;
			if (!File.Exists(secBat)) return false;
			string sArguments = string.Format("{0} {1}", Path.GetDirectoryName(secBat), Config.GetAffiliatePath(AffID,false,false));
			return  ExecCommand(secBat, Path.GetDirectoryName(secBat), sArguments);
		}

		protected bool ExecCommand(string sFileToExecute, string workingDirectory, string sArguments)
		{
			bool bRes = false;
			ProcessStartInfo startInfo = new ProcessStartInfo();
			startInfo.CreateNoWindow = true;
			startInfo.UseShellExecute = false;


			startInfo.WorkingDirectory = workingDirectory;
			startInfo.FileName = sFileToExecute;
			startInfo.Arguments = sArguments;

			Process proc = Process.Start(startInfo);
			if ( proc != null )
			{
				proc.WaitForExit(30000);
				if ( proc.ExitCode == 0 )
				{
					bRes = true;
				}
				else
				{
					string sError = string.Format("Process exit code = {0}. Call parameters: {1} {2}", proc.ExitCode, startInfo.FileName, startInfo.Arguments);
					Log.Write(this, sError);
				}
				if ( !proc.HasExited )
				{
					proc.Kill();
				}
			}
			return bRes;
		}

		protected void btnAffiliate_Click(object sender, EventArgs e)
		{
			//Install Shield creating
			Skins oAffiliate = new Skins(Page,AffID);
			string sError = oAffiliate.UpdateSkin();
			if ((sError != "") && (sError != null))
			{
				lblInfo.Text = sError;
				lblInfo.ForeColor = Color.Red;
			}
			else
			{
				lblInfo.Text = "Skins Install files were updated";
				lblInfo.ForeColor = Color.Green;
			}
		}

		protected void btnDelete_Click(object sender, EventArgs e)
		{ 
			if (Request.Form[chkBoxName]!=null)
			{
				if(AffID <=0) return;
				oPostedFile=new PostedFile(AffID);

				int fileID = 0;
				string sError = "";
				string sDelete = Request.Form[chkBoxName].ToString();

				//Delete from File system
				string[] sDeleteArray = sDelete.Split(',');
				for (int i=0;i<sDeleteArray.Length;i++)
				{
					if (sDeleteArray[i]!="") fileID = Convert.ToInt32(sDeleteArray[i]);
					string sErrorDelete = oPostedFile.DeleteFile(Page, fileID);
					if (sErrorDelete!="") sError += sErrorDelete + "<br>";
				}
				if (sError!="")
				{
					lblInfo.Text = "There were errors during file delete. Some files could not be deleted. See details below:<br>" + sError;
					lblInfo.ForeColor = Color.Red;
				}
			}
			BindDataGrid();
		}

		private void oGrid_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
		{
			oGrid.CurrentPageIndex = e.NewPageIndex;
			BindDataGrid();
		}


	}
}
