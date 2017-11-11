using System;
using Common;
using Common.Com;
using System.Reflection;
using System.Xml;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;



namespace Admin.CommonUse
{
	/// <summary>
	/// Summary description for PrizeTable.
	/// </summary>
	public class PrizeTable
	{
		const string radioGroupName = "theSameGroup";
		const string defaultXml = "<tournamentprize><players from='1' to='1'><place from='1' to='1' prizeRate=''/></players></tournamentprize>";

		public static string nodeRootName = "tournamentprize";
		public static string nodeColName = "players";
		public static string nodeRowName = "place";
		public static string nodeValueName = "prizeRate";

		public static string tblColName   = "colName";
		public static string tblRowName   = "rowName";
		public static string tblValueName = "value";

		public bool validate100 = true;
		public string rowColNames = "Places / Players";

		public PrizeTable()
		{
		}


		/// <summary>
		/// Fill Table with values from xml string or from Request collection
		/// </summary>
		public string FillTable(ref string xmlString, ref Table table, bool needFill, bool isPostBack)
		{
			//validate
			if ((xmlString=="") || (xmlString==null)) xmlString = defaultXml;

			//creating Xml document
			XmlDocument xmlDoc = new XmlDocument();
			xmlDoc.LoadXml(xmlString);

			// Create and populate table rows
			Page page = table.Page;
			string sError = "";
			string placeFrom = "";
			string placeTo = "";
			string playerFrom = "";
			string playerTo= "";
			int iNodePlace = 1;
			int iNodePlayer = 1;
			decimal iSum = 0;
			TableRow[] rowPlace = null;
			string cellID = "";
			string cellText = "";
			//getting player node list
			XmlNodeList nodePlayerList = xmlDoc.SelectNodes("tournamentprize/players");
			foreach (XmlNode nodePlayer in nodePlayerList)
			{
				if (iNodePlayer==1)	
				{
					int iRowMax = nodePlayer.SelectNodes("place").Count+1;
					rowPlace = new TableRow[iRowMax];
					for (int i=0;i<iRowMax;i++) rowPlace[i] = new TableRow();
					AddLabel(rowColNames, ref rowPlace[0]);  //left top corner label contains name of rows / nome of columns
				}
				
				//first row
				cellID = "edt_0_" + iNodePlayer.ToString(); 
				if (isPostBack) //change attributes of xml document
				{
					cellText = page.Request[cellID];
					GetFromToName(cellText, ref playerFrom, ref playerTo);
					if ((!ValidateDecimal(playerFrom)) || (!ValidateDecimal(playerTo)) || (cellText.Trim()=="-")) 
						sError+= "Value in cell (0," + iNodePlayer.ToString() + ") is not Number." + "<br>";
					SetAttribute(xmlDoc, nodePlayer, "from", playerFrom);
					SetAttribute(xmlDoc, nodePlayer, "to", playerTo);
				}
				playerFrom = GetAttribute(nodePlayer, "from");
				playerTo   = GetAttribute(nodePlayer, "to");
				cellText = GenerateFromToName(playerFrom, playerTo);
				AddTextBoxRadio(cellID, cellText, "cssGridPagerItem cssCellSmall cssSolidBorder", "", "cssReportHeader", ref rowPlace[0]);

				//getting places node list
				XmlNodeList nodePlaceList = nodePlayer.SelectNodes("place");
				iNodePlace = 1;
				iSum = 0;
				foreach (XmlNode nodePlace in nodePlaceList)
				{
					if (iNodePlayer==1)
					{
						//first row
						cellID = "edt_" + iNodePlace + "_0";
						if (isPostBack) //change attributes of xml document
						{
							cellText = page.Request[cellID];
							GetFromToName(cellText, ref placeFrom, ref placeTo);
							if ((!ValidateDecimal(placeFrom)) || (!ValidateDecimal(placeTo)) || (cellText.Trim()=="-")) 
								sError+= "Value in cell (" + iNodePlace.ToString() + ",0) is not Number." + "<br>";
							SetAttribute(xmlDoc, nodePlace, "from", placeFrom);
							SetAttribute(xmlDoc, nodePlace, "to", placeTo);
						}
						placeFrom = GetAttribute(nodePlace, "from");
						placeTo   = GetAttribute(nodePlace, "to");
						cellText = GenerateFromToName(placeFrom, placeTo);
						AddTextBoxRadio(cellID, cellText, "cssGridPagerItem cssCellSmall cssSolidBorder", "", "cssReportHeader", ref rowPlace[iNodePlace]);
					}

					//table content
					cellID = "edt_" + iNodePlace.ToString() + "_" + iNodePlayer;
					if (isPostBack) 
					{
						cellText = page.Request[cellID];
						if (ValidateDecimal(cellText))
						{
							if ((cellText!="") && (cellText!=null))	iSum += Convert.ToDecimal(cellText);
						}
						else sError+= "Value in cell (" + iNodePlace.ToString() + "," + iNodePlayer.ToString() + ") is not Numeric." + "<br>";
						SetAttribute(xmlDoc, nodePlace, "prizeRate", cellText);
					}

					cellText = GetAttribute(nodePlace, "prizeRate");
					AddTextBox(cellID, cellText, "cssTextAlignRight cssCellFill", ref rowPlace[iNodePlace]);

					iNodePlace++;
				}

				if ((validate100) && (isPostBack) && (iSum > 100)) sError+= "Sum in column " + iNodePlayer.ToString() + " is more than 100%." + "<br>";
				iNodePlayer++;
			}

			if ((needFill) && (rowPlace!=null))
			{
				for (int i=0;i<rowPlace.Length;i++) table.Rows.Add(rowPlace[i]);
			}

			xmlString = xmlDoc.InnerXml;
			return sError;
		}




		#region Add Controls To Cell functions
		private void AddLabel(string sText, ref TableRow row)
		{
			Label label = new Label();
			label.Text = sText;  
			TableCell labelCell = new TableCell();
			labelCell.Controls.Add(label);
			row.Cells.Add(labelCell);
		}


		private void AddTextBox(string sID, string sText, string cssClass, ref TableRow row)
		{
			TextBox textBox = new TextBox();
			textBox.ID = sID;
			textBox.Text = sText;
			textBox.CssClass = cssClass;
			TableCell textCell = new TableCell();
			textCell.Controls.Add(textBox);
			row.Cells.Add(textCell);
		}


		private void AddTextBoxRadio(string sID, string sText, string cssTextClass, string cssRadioClass, string cssCellClass, ref TableRow row)
		{
			TextBox textBox = new TextBox();
			textBox.ID = sID;
			textBox.Text = sText;
			textBox.CssClass = cssTextClass;

			RadioButton radio = new RadioButton();
			radio.ID = "radio_" + sID;
			radio.Text = "";
			radio.GroupName = radioGroupName;
			radio.CssClass = cssRadioClass;

			TableCell textCell = new TableCell();
			textCell.Controls.Add(radio);
			textCell.Controls.Add(textBox);
			textCell.CssClass = cssCellClass; 
			row.Cells.Add(textCell);
		}
		#endregion

		#region XmlAttribute functions
		private void SetAttribute(XmlDocument xmlDoc, XmlNode node, string attrName, string attrValue)
		{
			XmlAttribute xmlAttr = node.Attributes[attrName];
			if (xmlAttr==null)
			{
				if (attrValue!=null)  //create new attribute
				{
					XmlAttribute xmlAttrNew  = xmlDoc.CreateAttribute(attrName);
					xmlAttrNew.Value = attrValue;
					node.Attributes.Append(xmlAttrNew);
				}
			}
			else
			{
				if (attrValue==null) node.Attributes.Remove(xmlAttr);  //delete attribute
				else node.Attributes[attrName].Value = attrValue;      //update attribute value
			}
		}


		private string GetAttribute(XmlNode node, string attrName)
		{
			XmlAttribute xmlAttr = node.Attributes[attrName];
			if (xmlAttr==null) return null;
			else return xmlAttr.Value;
		}

		public void ClearNodeAttribute(ref XmlNode node)
		{
			for (int i=0;i<node.Attributes.Count;i++) node.Attributes[i].Value = "";
			for (int j=0;j<node.ChildNodes.Count;j++)
			{
				XmlNode xmlNodeChild = node.ChildNodes[j];
				ClearNodeAttribute(ref xmlNodeChild);
			}
		}
		#endregion

		#region String parsing functions
		private bool ValidateInt(string sText)
		{
			bool result = true;
			if ((sText==null) || (sText=="")) return result;
			int iNumber = 0;
			try
			{
				iNumber = Convert.ToInt32(sText);
			}
			catch
			{
				result = false;
			}
			return result;
		}


		private bool ValidateDecimal(string sText)
		{
			bool result = true;
			if ((sText==null) || (sText=="")) return result;
			decimal iNumber = 0;
			try
			{
				iNumber = Convert.ToDecimal(sText);
				//if (iNumber<0) result = false; 
			}
			catch
			{
				result = false;
			}
			return result;
		}

		private void GetFromToName(string sText, ref string sFrom, ref string sTo)
		{
			sFrom = sText;
			sTo = sText;
			if (sText==null) return;

			int iFind = -1;
			iFind = sText.IndexOf("-");
			if (iFind>=0)
			{
				sFrom = sText.Substring(0,iFind).Trim();
				sTo = sText.Substring(iFind+1).Trim();
				return;
			}
			iFind = sText.IndexOf("<");
			if (iFind>=0)
			{
				sFrom = null;
				sTo = sText.Substring(iFind+1).Trim();
				return;
			}
			iFind = sText.IndexOf(">");
			if (iFind>=0)
			{
				sTo = null;
				sFrom = sText.Substring(0, iFind).Trim();
				return;
			}
		}

		private string GenerateFromToName(string sFrom, string sTo)
		{
			string sName = "-";
			if ( ((sFrom=="") || (sFrom==null)) && ((sTo=="") || (sTo==null)) ) return sName;
			sName = sFrom + " - " + sTo;
			if (sFrom==sTo) sName = sFrom;
			if ((sFrom=="") || (sFrom==null)) sName = "< " + sTo;
			if ((sTo=="") || (sTo==null)) sName = sFrom + " >";
			return sName;
		}

		private void GetRowCol(string sText, ref int iRow, ref int iCol)
		{
			iRow = -1;
			iCol = -1;
			if (sText==null) return;

			string sTemp = sText.Substring(10);
			int iFind = -1;
			iFind = sTemp.IndexOf("_");
			if (iFind>0)
			{
				iRow = Convert.ToInt32(sTemp.Substring(0,iFind).Trim());
				iCol = Convert.ToInt32(sTemp.Substring(iFind+1).Trim()); 
			}
		}
		#endregion

		public string ResizeTable(ref string xmlString, ref Table table, string action)
		{
			//1. Check that some row or column was selected
			Page page = table.Page;
			string radioChk = page.Request[radioGroupName];
			if ((radioChk=="") || (radioChk==null)) 
			{
				FillTable(ref xmlString, ref table, true, true);
				return "Please select some row or column";
			}

			//2. Get actual xml
			FillTable(ref xmlString, ref table, false, true); //third param value set to false tells us that we need only get xml with values from request collection

			//3. Add node to xml
			int iRow = -1;
			int iCol = -1;
			GetRowCol(radioChk, ref iRow, ref iCol);
			NodeAction(action, ref xmlString, iRow, iCol);

			//4. Fill Table
			FillTable(ref xmlString, ref table, true, false);  //show updated table
			return "";
		}


		private void NodeAction(string action, ref string xmlString, int iRow, int iCol)
		{
			//creating Xml document
			XmlDocument xmlDoc = new XmlDocument();
			xmlDoc.LoadXml(xmlString);

			int iNodePlace  = 1;
			int iNodePlayer = 1;
			//getting player node list
			XmlNodeList nodePlayerList = xmlDoc.SelectNodes("tournamentprize/players");
			foreach (XmlNode nodePlayer in nodePlayerList)
			{
				if ((iRow==0) && (iNodePlayer==iCol)) 
				{
					if (action=="add")
					{
						XmlNode clone = nodePlayer.Clone();
						ClearNodeAttribute(ref clone);
						nodePlayer.ParentNode.InsertAfter(clone, nodePlayer);
						break;
					}
					else 
					{
						if (nodePlayerList.Count>1) nodePlayer.ParentNode.RemoveChild(nodePlayer);
						break;
					}
				}
				//getting place node list
				XmlNodeList nodePlaceList = nodePlayer.SelectNodes("place");
				iNodePlace = 1;
				foreach (XmlNode nodePlace in nodePlaceList)
				{
					if ((iCol==0) && (iNodePlace==iRow)) 
					{
						if (action=="add")
						{
							XmlNode clone = nodePlace.Clone(); 
							ClearNodeAttribute(ref clone);
							nodePlace.ParentNode.InsertAfter(clone, nodePlace);
						} 
						else 
						{
							if (nodePlaceList.Count>1) nodePlace.ParentNode.RemoveChild(nodePlace);
						}
					}
					iNodePlace++;
				}
				iNodePlayer++;
			}
			xmlString = xmlDoc.InnerXml;
		}


		public DataTable getDataTable(string xmlString)
		{
			//creating Xml document
			XmlDocument xmlDoc = new XmlDocument();
			xmlDoc.LoadXml(xmlString);

			DataTable oDT = new DataTable();
			oDT.Columns.Add("colName");
			oDT.Columns.Add("rowName");
			oDT.Columns.Add("value");

			string rowName = "";
			string colName = "";
			string cellValue = "";
			int iCol = 0;
			int iRow = 0;

			XmlNodeList nodePlayerList = xmlDoc.SelectNodes("tournamentprize/players");
			foreach (XmlNode nodePlayer in nodePlayerList)
			{
				colName = GetAttribute(nodePlayer, "from");
				XmlNodeList nodePlaceList = nodePlayer.SelectNodes("place");
				iRow = 0;
				foreach (XmlNode nodePlace in nodePlaceList)
				{
					if (iCol==0) rowName   = GetAttribute(nodePlace, "from");
					else rowName = oDT.Rows[iRow][1].ToString();
					cellValue = GetAttribute(nodePlace, "prizeRate");
					oDT.Rows.Add(new object[3]{colName, rowName, cellValue});
					iRow++;
				}
				iCol++;
			}
			return oDT;
		}




	}
}
