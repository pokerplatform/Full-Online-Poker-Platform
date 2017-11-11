using System;
using System.Collections;
using System.Xml;
using System.Web;
using System.Text; 
using System.IO;

namespace Admin.CommonUse
{
	/// <summary>
	///  XmlTool.
	/// </summary>
	public class CXmlTool
	{

		public static string  XML2String(XmlDocument XmlDoc )
		{
			StringBuilder sb=new StringBuilder(""); 
			StringWriter sw=new StringWriter(sb);
			XmlDoc.Save(sw);
			return sw.ToString(); 
		}

		public static void GetSelectOptions(XmlNode n,ref ArrayList a,  string type,string name,string optname)
		{		
			a.Clear();
			foreach (XmlElement e in n.SelectNodes("//element [@type='"+type+"'] [@name='"+name+"'] "+optname))
			{
				XmlNodeList nl= e.ChildNodes;
				foreach(XmlNode en in nl)
				{
					a.Add(en.InnerText); 
				}
			}
		}

		public static void GetSelectOptionsAll(XmlNode n,ref ArrayList a,  string type,string name)
		{			
			a.Clear();
			foreach (XmlElement e in n.SelectNodes("//element[@type='" + type + "'] [@name='"+name+"']"))
			{
				XmlNodeList nl= e.ChildNodes;
				foreach(XmlNode en in nl)
				{
					a.Add(en.InnerText); 
				}
			}			
		}

		public static void GetParameters(XmlNode n, ref string parameters, string[] type) 
		{			
			for(int i=0; i<type.Length; i++) 
			{
				get_parameters(n, ref parameters, type[i]);
			}			
		}
		public static void GetParameters(XmlNode n, ref string parameters, string type)
		{
			get_parameters(n, ref parameters, type);
		}
		private static void get_parameters(XmlNode n, ref string parameters, string type)
		{			
			ArrayList a = new ArrayList();
			foreach (XmlElement e in n.SelectNodes("//element[@type='" + type + "']"))
			{
				if(a.IndexOf(e.GetAttribute("name"))==-1)
				{
					a.Add(e.GetAttribute("name"));
					if (parameters != String.Empty) parameters += "&";
					parameters += String.Format("{0}={1}",
						e.GetAttribute("name"), 
						HttpUtility.UrlEncode(e.SelectSingleNode("value").InnerText));
				}
			}			
		}

		public static string GetParameter(XmlElement  e, string prm) 
		{
			string retstr="";
			
			retstr= e.SelectSingleNode(prm).InnerText;
						
			return retstr;
		}

		public static XmlElement GetElement(XmlNode  e, string eltype,int idx) 
		{
			XmlElement retel=null;
			int l=0;
			
			foreach (XmlElement t in e.SelectNodes("//element[@type='" + eltype + "']"))
			{
				if (l==idx)
				{
					retel= t;
					break;
				}
				l++;
			}
			
			return retel;
		}

		public static int  GetElementsCount(XmlNode  e, string eltype) 
		{
			return e.SelectNodes("//element[@type='" + eltype + "']").Count;
		}

		public static string GetParameter(XmlNode  e, string elname,string prm) 
		{
			string retstr="";
			
			foreach (XmlElement t in e.SelectNodes("//element[@name='" + elname + "']"))
			{
				retstr= t.SelectSingleNode(prm).InnerText;
				break;
			}
			
			return retstr;
		}

		public static void SetParameter(XmlElement e, string elname,string prm, string v) 
		{			
			foreach (XmlElement t in e.SelectNodes("//element[@name='" + elname + "']"))
				t.SelectSingleNode(prm).InnerText = v;		
		}

		public static void SetParameter(XmlElement e, string p, int v)
		{
			SetParameter(e, p, v.ToString().Trim());
		}

		public static void SetParameter(XmlElement e, string p, string v) 
		{			
			foreach (XmlElement t in e.SelectNodes("//element[@name='" + p + "']"))
				t.SelectSingleNode("value").InnerText = v;		
		}

	}
}
