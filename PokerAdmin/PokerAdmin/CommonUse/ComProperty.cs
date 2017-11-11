using System;
using Common;
using Common.Com;
using System.Reflection;
using System.Xml;
using System.Web.UI;
using System.Web.UI.WebControls;




namespace Admin.CommonUse
{
	/// <summary>
	/// Summary description for ComProperty.
	/// </summary>
	public class ComProperty
	{
		public ComProperty()
		{
		}

		/*/// <summary>
		/// Get a string from first out parameter by invoking com method
		/// This is a simple method considers that first out parameter is return value, second out parameter is error description.
		/// If it is not true please use InvokeMemberFull instead
		/// </summary>
		public string InvokeMember(string comName, string methodName, params object[] args)
		{
			return InvokeMemberFull(comName, methodName, -1, -1, args);
		}

		/// <summary>
		/// Get a string from specified out parameter by invoking com method
		/// </summary>
		public string InvokeMemberFull(string comName, string methodName, int retParam, int errorParam, params object[] args)
		{
			//Log.Write(this,string.Format("start InvokeMemberFull({0}, {1}, {2}, {3}), {4}", comName, methodName, retParam, errorParam, args));
			//validate params
			if ((comName==null) || (methodName==null) || (Config.ComServer==null)) return null;

			//get com object
			Object obj = Remote.CreateCom(comName, Config.ComServer);
			if (obj==null)
			{
				Log.Write(this, "Can't create remote COM (NULL returned)");
				return null;
			}

			//creating ParameterModifier list
			ParameterModifier marg = new ParameterModifier(args.Length);
			for (int i=0;i<args.Length;i++)
			{
				if (args[i].ToString()=="") 
				{
					marg[i] = true; //out parameter
					if (retParam<0)
					{
						retParam = i; //first output parameter consider to be parameter to return
					}
					if ((errorParam<0) && (retParam>=0) && (retParam<i))
					{
						errorParam = i;  //second output parameter consider to be parameter with error message
					}
				}
				else 
				{
					if (retParam==i)
					{
						marg[i] = true; //out parameter
					}
					else
					{
						if(errorParam==i)
						{
							marg[i] = true; //out parameter 
						}
						else
						{
							marg[i] = false; //in parameter
						}
					}
				}
			}
			ParameterModifier [] mods = {marg};

			int Result = -1;
			try
			{
				//Invoke Com Method
				Result = (int)obj.GetType().InvokeMember (
					methodName
					,BindingFlags.InvokeMethod
					,null
					,obj
					,args
					,mods
					,null
					,null);
			}
			catch(Exception oEx)
			{
				Log.Write(this, "Com object " + comName + " method " + methodName + " failed. Com Error: " + oEx.Message);
				return null;
			}
			if (Result!=0)  //we have error
			{
				string errMessage = Result.ToString() + " ";
				if ((errorParam>=0) && (errorParam<args.Length))
				{
					errMessage += Convert.ToString(args[errorParam]);  //get error message from com
				}
				Log.Write(this, "Com object " + comName + " method "  + methodName + " failed. Result Error: " + errMessage);
				return null;
			}
			
			//get return paremeter if specified
			if ((retParam>=0) && (retParam<args.Length)) 
			{
				if (args[retParam]==null) return "";
				else return args[retParam].ToString(); 
			}
			else return "";
		}
*/

		/// <summary>
		/// Fill Table with values from xml string with default nodeList
		/// </summary>
		public void FillTable(string xmlString, bool bEnabled, ref Table table)
		{
			FillTable(xmlString, "properties/property", bEnabled, ref table);
		}

		/// <summary>
		/// Fill Table with values from xml string with specified nodeList
		/// </summary>
		public void FillTable(string xmlString, string selectString, bool bEnabled, ref Table table)
		{
			//Common.Files.Access.WriteFile(@"c:\Temp\xml.xml",xmlString); 
			try
			{
				//creating Xml document
				XmlDocument xmlDoc = new XmlDocument();
				xmlDoc.LoadXml(xmlString);

				//getting property list
				XmlNodeList nodeList = xmlDoc.SelectNodes(selectString);
				string attrName, attrValue, attrID;
				int attrType;
				foreach (XmlNode node in nodeList)
				{
					attrName  = node.Attributes["name"].Value;
					attrType  = Convert.ToInt32(node.Attributes["type"].Value);
					attrValue = node.Attributes["value"].Value;
					attrID = attrName.Replace("\"","_");  //sign '"' is not suitable to use in id name. It will replace to sign '_'

					// Create and populate table row
					TableRow row = new TableRow();
					//Populate first column of table with label control
					Label label = new Label();
					label.Text = attrName;
					TableCell labelCell = new TableCell();
					labelCell.Controls.Add(label);
					row.Cells.Add(labelCell);
					//Populate second column with with approciate control
					switch (attrType)
					{
						case 5: //ComboBox
							DropDownList comboBox = new DropDownList();
							comboBox.ID = attrID;
							XmlNodeList comboList = node.SelectNodes("item");
							foreach (XmlNode comboNode in comboList)
							{
								string comboValue  = comboNode.Attributes["id"].Value;
								string comboText  = comboNode.Attributes["value"].Value;
								ListItem item = new ListItem(comboText, comboValue);
								comboBox.Items.Add(item);
								if ((bEnabled)  && (comboText==attrValue)) comboBox.SelectedIndex = comboBox.Items.Count - 1; 
								if ((!bEnabled) && (comboValue==attrValue)) comboBox.SelectedIndex = comboBox.Items.Count - 1; 
							}
							comboBox.Enabled = bEnabled;
							TableCell comboCell = new TableCell();
							comboCell.Controls.Add(comboBox);
							row.Cells.Add(comboCell);
							break;
						case 6: //CheckBox
							CheckBox checkBox = new CheckBox();
							checkBox.ID = attrID;
							checkBox.Checked = Convert.ToBoolean(attrValue);
							checkBox.Enabled = bEnabled;
							TableCell checkCell = new TableCell();
							checkCell.Controls.Add(checkBox);
							row.Cells.Add(checkCell);
							break;
						default: //Text
							TextBox textBox = new TextBox();
							textBox.ID = attrID;
							textBox.Text = attrValue;
							textBox.Enabled = bEnabled;
							TableCell textCell = new TableCell();
							textCell.Controls.Add(textBox);
							row.Cells.Add( textCell );
							break;
					}

					table.Rows.Add(row);
				}
			}catch(Exception oEx)
			{
				Log.Write(this, "Fill Table Error. Error description: " + oEx.Message);
			}
		}



		
		/// <summary>
		///Return xml based on values from request collection and given xml with defaul nodelist
		/// </summary>
		public string getFormXml(string xmlString, Page page)
		{
			return getFormXml(xmlString, "properties/property", page);
		}

		/// <summary>
		///Return xml based on values from request collection and given xml with given nodelist
		/// </summary>
		public string getFormXml(string xmlString, string selectString, Page page)
		{
			//create xml doc document
			XmlDocument xmlDoc = new XmlDocument();
			xmlDoc.LoadXml(xmlString);
			//getting property list
			XmlNodeList nodeList = xmlDoc.SelectNodes(selectString);
			string attrName, attrID, attrValue, attrNewValue;
			int attrType;
			foreach (XmlNode node in nodeList)
			{
				attrName  = node.Attributes["name"].Value;
				attrType  = Convert.ToInt32(node.Attributes["type"].Value);
				attrValue = node.Attributes["value"].Value;
				attrID = attrName.Replace("\"","_");

				attrNewValue = page.Request[attrID];
				if (attrType==6)//CheckBox
				{
					if ((attrNewValue==null) || (attrNewValue==""))
						attrNewValue = "false";
					else
						attrNewValue = "true";
				}

				//rewrite Node
				node.Attributes["value"].Value = attrNewValue;
			}
			return xmlDoc.InnerXml;
		}


		/// <summary>
		///Set value to attribute
		/// </summary>
		public string setAttributeValue(string xmlString, string selectPath , string attributeName, string attrValue)
		{
			//create xml doc document
			XmlDocument xmlDoc = new XmlDocument();
			xmlDoc.LoadXml(xmlString);
			//getting property list
			XmlNodeList nodeList = xmlDoc.SelectNodes(selectPath);
			string attrName;
			int attrType;
			foreach (XmlNode node in nodeList)
			{
				attrName  = node.Attributes["name"].Value;
				if( attrName.ToLower() == attributeName.ToLower())
				{
					attrType  = Convert.ToInt32(node.Attributes["type"].Value);
					if (attrType==6)//CheckBox
					{
						if ((attrValue==null) || (attrValue==""))
							attrValue = "false";
						else
							attrValue = "true";
					}
					//rewrite Node
					node.Attributes["value"].Value = attrValue;
					break;
				}
			}
			return xmlDoc.InnerXml;
		}

	}
}
