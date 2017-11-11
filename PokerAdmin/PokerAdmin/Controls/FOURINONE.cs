/*****************************************************************************************/
//Developer 	: Venkateswaran.M
//Email	  	: venkatsriram@msn.com
//Module  	: Combo Control.
//Date	  	: 18-Dec-2004
//Description 	: Four in one control Tab, Menu, Tree, Panel Bar.
/*****************************************************************************************/

using System;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.Xml;
using System.Data;
using System.IO;
using System.Security;
using System.Security.Permissions;

[assembly:FileIOPermission(SecurityAction.RequestMinimum, Unrestricted=true)]

namespace Admin.Controls {


public class FourinOne: System.Web.UI.UserControl{
	private string document = "Data.xml";
	private string myLoadSchema = "Data.xsd";
	private XmlDataDocument myXmlDataDocument;
	public string MainMenuSelected = "1";
	public string SubMenuSelected = "1";
	public string CongressId = "";
	public string HideSubMenu = "";
	public string Display;
	public string Controltype;
	public String PageTitle = "Test Page Title";
	public string MainMenuIDSelected = "0";
	
	public string SecurityType = "";
	
        public FourinOne(){
		string appPath;
		appPath = this.Context.Request.PhysicalApplicationPath;
		string strXMLPath= "";
		strXMLPath = System.Configuration.ConfigurationSettings.AppSettings["MenuXMLPath"];
		document = strXMLPath + document;
		myLoadSchema = strXMLPath + myLoadSchema;
		myXmlDataDocument = new XmlDataDocument();
		ParseSchema(appPath+myLoadSchema);
		myXmlDataDocument.Load(appPath+document);
		
		if(this.Context.Session["UserType"] == null)
		                this.Context.Response.Redirect("Default.aspx");
		                
		                // To get the security type from the page
                SecurityType = this.Context.Session["UserType"].ToString();
        }

        private void ParseSchema(String schema){
		StreamReader myStreamReader = null;
		try{
			Console.WriteLine("Reading Schema file ...");
			myStreamReader = new StreamReader(schema);
			myXmlDataDocument.DataSet.ReadXmlSchema(myStreamReader);
		}
		catch (Exception e){
			Console.WriteLine ("Exception: {0}", e.ToString());
		}
		finally{
		if (myStreamReader != null)
			myStreamReader.Close();
		}
	}

	   
	private void LoadMainMenu(StringBuilder strRender){
		string strTDClass = "strTDClass";
		string strTDOverClass = "strTDClass";

		DataView myDataView = new DataView(myXmlDataDocument.DataSet.Tables["MainMenu"]);
		myDataView.Sort = "MenuSequence";
	
		
		for (int i = 0; i < myDataView.Count; i++){
			if(isAuthorised(myDataView[i]["MainSecurity"].ToString(),SecurityType)){
				if(myDataView[i]["MenuId"].ToString() == MainMenuSelected){
					MainMenuIDSelected = myDataView[i]["MainMenu_Id"].ToString();
					strTDClass = "Level1TabSelected";
					strTDOverClass = "Level1TabSelectedOver";
				}
				else{
					strTDClass = "Level1Tab";
					strTDOverClass = "Level1TabOver";
				}
				strRender.Append("<td class=\""+strTDClass+"\" onmouseover=\"this.className='"+strTDOverClass+"';\" onmouseout=\"this.className='"+strTDClass+"';\" onmousemove=\"return false;\" ondblclick=\"return false;\" onclick=\"tab_hideAllGroups();document.location.href='"+ myDataView[i]["BaseURL"].ToString() +"';\" id=\"TS1_Level1Tabsi"+myDataView[i]["MenuId"].ToString()+"\">"+ myDataView[i]["Label"].ToString() +"</td>");
				
			}
		}           
        }


	private void LoadSubMenu(StringBuilder strRender){
		string strTDClass = "strTDClass";
		string strTDOverClass = "strTDClass";
		DataView myDataView = new DataView(myXmlDataDocument.DataSet.Tables["SubMenu"]);
		myDataView.Sort = "SubMenuSequence";
		myDataView.RowFilter = "MainMenu_Id = " + MainMenuIDSelected;
		for (int i = 0; i < myDataView.Count; i++){
			if(isAuthorised(myDataView[i]["Security"].ToString(),SecurityType)){
				if((","+HideSubMenu+",").IndexOf(myDataView[i]["SubMenuId"].ToString())<0){
					if(myDataView[i]["SubMenuId"].ToString() == SubMenuSelected){
						strTDClass = "Level2TabSelected";
						strTDOverClass = "Level2TabSelectedOver";

					}
					else{
						strTDClass = "Level2Tab";
						strTDOverClass = "Level2TabOver";
					}
					//strRender.Append("<td class=\""+strTDClass+"\" onmouseover=\"this.className='"+strTDOverClass+"';\" onmouseout=\"this.className='"+strTDClass+"';\" onmousemove=\"return false;\" ondblclick=\"return false;\" onclick=\"tab_hideAllGroups();document.location.href='"+myDataView[i]["URL"].ToString()+"';\" id=\"TS1_Level2Tabsi"+myDataView[i]["SubMenuId"].ToString()+"\">"+myDataView[i]["Label"].ToString()+"</td>");
					strRender.Append("<td class=\""+strTDClass+"\" onmouseover=\"this.className='"+strTDOverClass+"';\" onmouseout=\"this.className='"+strTDClass+"';\" onmousemove=\"return false;\" ondblclick=\"return false;\" onclick=\"tab_hideAllGroups();document.location.href='"+ myDataView[i]["URL"].ToString() +"';\" id=\"TS1_Level1Tabsi"+myDataView[i]["SubMenuId"].ToString()+"\">"+ myDataView[i]["Label"].ToString() +"</td>");
				}
			}
		}
    	}

	private bool isAuthorised(string sSecString, string sSecType){
		return(sSecString.IndexOf(sSecType)>=0);
	}


	protected override void Render(HtmlTextWriter output){
		StringBuilder strRender = new StringBuilder();
		if(Controltype.ToLower()=="menu"){
			strRender.Append("<script type=\"text/javascript\" language=\"JavaScript1.2\" src=\"themes/stm31.js\"></script>");
			strRender.Append("<script type=\"text/javascript\" language=\"JavaScript1.2\">");
			string MainMenuFontColor = System.Configuration.ConfigurationSettings.AppSettings["MainMenuFontColor"];
			string MainMenuShadowColor = System.Configuration.ConfigurationSettings.AppSettings["MainMenuShadowColor"];
			string MainMenubGColor = System.Configuration.ConfigurationSettings.AppSettings["MainMenubGColor"];
			string MainMenuMouseoverColor = System.Configuration.ConfigurationSettings.AppSettings["MainMenuMouseoverColor"];
			string SubmenuBgColor = System.Configuration.ConfigurationSettings.AppSettings["SubmenuBgColor"];
			string SubmenuMouseoverColor = System.Configuration.ConfigurationSettings.AppSettings["SubmenuMouseoverColor"];
			string SubmenuBorderColor = System.Configuration.ConfigurationSettings.AppSettings["SubmenuBorderColor"];
			string SubmenuFontColor = System.Configuration.ConfigurationSettings.AppSettings["SubmenuFontColor"];
			string SubmenuShadowColor = System.Configuration.ConfigurationSettings.AppSettings["SubmenuShadowColor"];
			string SubmenuMouseOverFontColor = System.Configuration.ConfigurationSettings.AppSettings["SubmenuMouseOverFontColor"];
			
			strRender.Append("stm_bm([\"phpjchr\",400,\"\",\"blank.gif\",0,\"\",\"\",0,0,0,0,50,1,0,0,\"\",\"\",0],this);");
			DataView myDataView = new DataView(myXmlDataDocument.DataSet.Tables["MainMenu"]);
			myDataView.Sort = "MenuSequence";
			
			if(Display=="V" || Display=="v")
			strRender.Append("stm_bp(\"p0\",[1,4,0,0,0,4,0,7,71,\"progid:DXImageTransform.Microsoft.Fade(overlap=.5,enabled=0,Duration=1.00)\",-2,\"\",-2,10,1,4,\""+MainMenuShadowColor+"\",\"transparent\",\"\",3,0,0,\""+MainMenuFontColor+"\"]);");
			else if(Display=="H" || Display=="h")
			strRender.Append("stm_bp(\"p0\",[0,4,0,0,0,4,0,7,71,\"progid:DXImageTransform.Microsoft.Fade(overlap=.5,enabled=0,Duration=1.00)\",-2,\"\",-2,10,1,4,\""+MainMenuShadowColor+"\",\"transparent\",\"\",3,0,0,\""+MainMenuFontColor+"\"]);");
			for (int i = 0; i < myDataView.Count; i++){
				if(isAuthorised(myDataView[i]["MainSecurity"].ToString(),SecurityType)){
					strRender.Append("stm_ai(\"p0i0\",[0,'"+myDataView[i]["Label"].ToString()+"',\"\",\"\",-1,-1,0,\""+myDataView[i]["BaseURL"].ToString()+"\",\"_self\",'"+myDataView[i]["BaseURL"].ToString()+"',\"\",\"\",\"\",0,0,0,\"arrow_gray.gif\",\"arrow_gray.gif\",7,7,0,0,1,\""+MainMenubGColor+"\",0,\""+MainMenuMouseoverColor+"\",0,\"\",\"\",3,3,0,0,\""+MainMenubGColor+"\",\""+MainMenuMouseoverColor+"\",\""+MainMenuFontColor+"\",\""+MainMenuFontColor+"\",\"8pt Arial\",\"8pt Arial\",0,0]);");
					DataView mySubDataView = new DataView(myXmlDataDocument.DataSet.Tables["SubMenu"]);
					mySubDataView.Sort = "SubMenuSequence";
					mySubDataView.RowFilter = "MenuId = " + myDataView[i]["MenuId"].ToString();
					if(Display=="V" || Display=="v")
					strRender.Append("stm_bp(\"p1\",[1,2,0,1,0,3,0,0,71,\"progid:DXImageTransform.Microsoft.Wipe(GradientSize=1.0,wipeStyle=1,motion=forward,enabled=0,Duration=1.00)\",5,\"\",-2,10,1,4,\""+SubmenuShadowColor+"\",\"\",\"\",3,1,1,\""+SubmenuBorderColor+"\"]);");
					else if(Display=="H" || Display=="h")
					strRender.Append("stm_bp(\"p1\",[1,4,0,1,0,3,0,0,71,\"progid:DXImageTransform.Microsoft.Wipe(GradientSize=1.0,wipeStyle=1,motion=forward,enabled=0,Duration=1.00)\",5,\"\",-2,10,1,4,\""+SubmenuShadowColor+"\",\"\",\"\",3,1,1,\""+SubmenuBorderColor+"\"]);");					
					for (int j = 0; j < mySubDataView.Count; j++){
						if(isAuthorised(mySubDataView[j]["Security"].ToString(),SecurityType)){					
							strRender.Append("stm_aix(\"p1i0\",\"p0i0\",[0,'"+mySubDataView[j]["Label"].ToString()+"',\"\",\"\",-1,-1,0,\""+mySubDataView[j]["URL"].ToString()+"\",\"\",'"+mySubDataView[j]["URL"].ToString()+"',\"\",\"\",\"\",0,0,0,\"\",\"\",0,0,0,0,1,\""+SubmenuBgColor+"\",0,\""+SubmenuMouseoverColor+"\",0,\"\",\"\",3,3,0,0,\"\",\"\",\""+SubmenuFontColor+"\",\""+SubmenuMouseOverFontColor+"\"]);");	
						}
					}
					strRender.Append("stm_ep();");
				}
			}
			strRender.Append("stm_em();");
			strRender.Append("</script>");
		}
		else if(Controltype.ToLower()=="tab"){
			strRender.Append("<link href=\"helper/menuStyle.css\" type=\"text/css\" rel=\"stylesheet\" />");
			strRender.Append("<script type=\"text/javascript\" language=\"JavaScript1.2\" src=\"themes/menu.js\"></script>");
			strRender.Append("        <table cellspacing=\"0\" cellpadding=\"0\" width=\"100%\" border=\"0\">");
			strRender.Append("            <tbody>");
			strRender.Append("                <tr>");
			strRender.Append("                    <td class=\"TopStripe\" height=\"5\">");
			strRender.Append("                    </td>");
			strRender.Append("                </tr>");
			strRender.Append("                <tr>");
			strRender.Append("                    <td class=\"Level1TabGroup\" height=\"22\">");
			strRender.Append("                        <span id=\"TS1_Level1Tabs\">");
			strRender.Append("                        <table id=\"TS1_Level1Tabsg1\" style=\"Z-INDEX: 999\"  cellspacing=\"0\" cellpadding=\"0\" border=\"0\">");
			strRender.Append("                            <tbody>");
			strRender.Append("                                <tr id=\"MainMenuRow\">");

			LoadMainMenu(strRender);

			strRender.Append("                                </tr>");
			strRender.Append("                            </tbody>");
			strRender.Append("                        </table>");
			strRender.Append("                        </span><span>");
			strRender.Append("                        <table style=\"LEFT: 0px; VISIBILITY: hidden; POSITION: absolute; TOP: 0px\">");
			strRender.Append("                            <tbody>");
			strRender.Append("                                <tr>");
			strRender.Append("                                    <td>");
			strRender.Append("                                    </td>");
			strRender.Append("                                </tr>");
			strRender.Append("                            </tbody>");
			strRender.Append("                        </table>");
			strRender.Append("                        </span></td>");
			strRender.Append("                </tr>");
			strRender.Append("                <tr>");
			strRender.Append("                    <td class=\"Level2TabGroup\" height=\"22\">");
			strRender.Append("                        <img height=\"1\" src=\"images/spacer.gif\" width=\"1\" border=\"0\" /><span id=\"TS1_Level2Tabs\"><table id=\"TS1_Level2Tabsg1\" style=\"Z-INDEX: 999\" onmouseout=\"if (document.readyState == 'complete') tab_groupMsOut('TS1_Level2Tabsg1', null, null, 0);\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\">");
			strRender.Append("                            <tbody>");
			strRender.Append("                                <tr id=\"SubMenuRow\">");

			LoadSubMenu(strRender);

			strRender.Append("                                </tr>");
			strRender.Append("                            </tbody>");
			strRender.Append("                        </table>");
			strRender.Append("                        </span><span>");
			strRender.Append("                        <table style=\"LEFT: 0px; VISIBILITY: hidden; POSITION: absolute; TOP: 0px\">");
			strRender.Append("                            <tbody>");
			strRender.Append("                                <tr>");
			strRender.Append("                                    <td>");
			strRender.Append("                                    </td>");
			strRender.Append("                                </tr>");
			strRender.Append("                            </tbody>");
			strRender.Append("                        </table>");
			strRender.Append("                        </span></td>");
			strRender.Append("                </tr>");
			strRender.Append("                <tr>");
			strRender.Append("                    <td class=\"generaltxtLarge\" align=\"middle\" bgcolor=\"#000088\" colspan=\"2\">");
			strRender.Append(PageTitle);
			strRender.Append("                           </td>");
			strRender.Append("                </tr>");
			strRender.Append("            </tbody>");
			strRender.Append("        </table>");
		}
		else if(Controltype.ToLower()=="tree"){
			strRender.Append("<link href=\"helper/tree.css\" type=\"text/css\" rel=\"stylesheet\" />");
			strRender.Append("<script language=\"JavaScript1.2\">");
			strRender.Append("img1=new Image();");
			strRender.Append("img1.src=\"themes/plusik_L.gif\";");
			strRender.Append("img2=new Image();");
			strRender.Append("img2.src=\"themes/minus_L.gif\";");
			strRender.Append("var ns6=document.getElementById&&!document.all;");
			strRender.Append("var ie4=document.all&&navigator.userAgent.indexOf(\"Opera\")==-1;");
			
			strRender.Append("function checkcontained(e){");
			strRender.Append("var iscontained=0;");
			strRender.Append("cur=ns6? e.target : event.srcElement;");
			strRender.Append("i=0;");
			strRender.Append("if (cur.id==\"foldheader\")");
			strRender.Append("iscontained=1;");
			strRender.Append("else ");
			strRender.Append("while (ns6&&cur.parentNode||(ie4&&cur.parentElement)){");
			strRender.Append("if (cur.id==\"foldheader\"||cur.id==\"foldinglist\"){");
			strRender.Append("iscontained=(cur.id==\"foldheader\")? 1 : 0;");
			strRender.Append("break;");
			strRender.Append("}");
			strRender.Append("cur=ns6? cur.parentNode : cur.parentElement");
			strRender.Append("}");
			strRender.Append("if (iscontained){");
			strRender.Append("var plusik_Lcontent=ns6? cur.nextSibling.nextSibling : cur.all.tags(\"UL\")[0];");
			strRender.Append("if (plusik_Lcontent.style.display==\"none\"){");
			strRender.Append("plusik_Lcontent.style.display=\"\";");
			strRender.Append("cur.style.listStyleImage=\"url(themes/minus_L.gif)\";");
			strRender.Append("}");
			strRender.Append("else{");
			strRender.Append("plusik_Lcontent.style.display=\"none\";");
			strRender.Append("cur.style.listStyleImage=\"url(themes/plusik_L.gif)\";");
			strRender.Append("}}}");
			strRender.Append("if (ie4||ns6) document.onclick=checkcontained;");
			strRender.Append("</script>");
			
			
			strRender.Append("<ul>");
			DataView myDataView = new DataView(myXmlDataDocument.DataSet.Tables["MainMenu"]);
			myDataView.Sort = "MenuSequence";
			for (int i = 0; i < myDataView.Count; i++){
				if(isAuthorised(myDataView[i]["MainSecurity"].ToString(),SecurityType)){
					String link=myDataView[i]["BaseURL"].ToString();
					link.Trim();
					if(link=="") 
						strRender.Append("<li id='foldheader'><img src='"+myDataView[i]["ImageUrl"].ToString()+"' border=0>&nbsp;"+myDataView[i]["Label"].ToString()+"</li>");
					else
						strRender.Append("<li id='foldheader'><a href='"+myDataView[i]["BaseURL"].ToString()+"'><img src='"+myDataView[i]["ImageUrl"].ToString()+"' border=0>&nbsp;"+myDataView[i]["Label"].ToString()+"</a></li>");
					
					strRender.Append("<ul id='foldinglist' style=\"display:none\" >");
					
					DataView mySubDataView = new DataView(myXmlDataDocument.DataSet.Tables["SubMenu"]);
					mySubDataView.Sort = "SubMenuSequence";
					mySubDataView.RowFilter = "MenuId = " + myDataView[i]["MenuId"].ToString();
					
								
					
					for (int j = 0; j < mySubDataView.Count; j++){
						if(isAuthorised(mySubDataView[j]["Security"].ToString(),SecurityType)){
							String Slink=mySubDataView[j]["URL"].ToString();
							Slink.Trim();
							if(Slink=="") 
								strRender.Append("<li><img src='"+mySubDataView[j]["ImageUrl"].ToString()+"' border=0>&nbsp;"+mySubDataView[j]["Label"].ToString()+"</li>");
							else
								strRender.Append("<li><a href='"+mySubDataView[j]["URL"].ToString()+"'><img src='"+mySubDataView[j]["ImageUrl"].ToString()+"' border=0>&nbsp;"+mySubDataView[j]["Label"].ToString()+"</a></li>");
						}
					}
					strRender.Append("</ul>");
				}
			}
			strRender.Append("</ul>");
		}
		else if(Controltype.ToLower()=="panel"){
			strRender.Append("<link href=\"helper/panel.css\" type=\"text/css\" rel=\"stylesheet\" />");
			strRender.Append("<script type=\"text/javascript\">");
			strRender.Append("if (document.getElementById){");
			strRender.Append("document.write('<style type=\"text/css\">');");
			strRender.Append("document.write('.submenu{display: none;}');");
			strRender.Append("document.write('</style>');}");
	
			
			strRender.Append("function SwitchMenu(obj){");
			strRender.Append("if(document.getElementById){");
			strRender.Append("var el = document.getElementById(obj);");
			strRender.Append("var ar = document.getElementById(\"masterdiv\").getElementsByTagName(\"span\"); ");
			strRender.Append("if(el.style.display != \"block\"){");
			strRender.Append("for (var i=0; i<ar.length; i++){");
			strRender.Append("if (ar[i].className==\"submenu\")");
			strRender.Append("ar[i].style.display = \"none\";");
			strRender.Append("}el.style.display = \"block\";");
			strRender.Append("}else{el.style.display = \"none\";");
			strRender.Append("}}}");
			strRender.Append("</script>");
			
			strRender.Append("<div id=\"masterdiv\">");
			DataView myDataView = new DataView(myXmlDataDocument.DataSet.Tables["MainMenu"]);
			myDataView.Sort = "MenuSequence";
			for (int i = 0; i < myDataView.Count; i++){
				if(isAuthorised(myDataView[i]["MainSecurity"].ToString(),SecurityType)){
				
					String link=myDataView[i]["BaseURL"].ToString();
					link.Trim();
					strRender.Append("<div class=\"menutitle\" onclick=\"SwitchMenu("+myDataView[i]["MenuId"].ToString()+")\">"+myDataView[i]["Label"].ToString()+"</div>");
					
					strRender.Append("<span class=\"submenu\" id=\""+myDataView[i]["MenuId"].ToString()+"\">");
					
					DataView mySubDataView = new DataView(myXmlDataDocument.DataSet.Tables["SubMenu"]);
					mySubDataView.Sort = "SubMenuSequence";
					mySubDataView.RowFilter = "MenuId = " + myDataView[i]["MenuId"].ToString();
					
								
					
					for (int j = 0; j < mySubDataView.Count; j++){
						if(isAuthorised(mySubDataView[j]["Security"].ToString(),SecurityType)){
							String Slink=mySubDataView[j]["URL"].ToString();
							Slink.Trim();
							if(Slink=="") 
								strRender.Append(mySubDataView[j]["Label"].ToString()+"<br>");
							else
								strRender.Append("<a href='"+mySubDataView[j]["URL"].ToString()+"'>&nbsp;&nbsp;"+mySubDataView[j]["Label"].ToString()+"</a><br>");
								
						}
					}
					strRender.Append("</span>");
					
				}
			}			
			strRender.Append("</div>");				
			
			
		}
		output.Write(strRender.ToString());
		}
	}
}
