
//It adds row
function AddNewRow()
{
	tLastRow = tTeam.rows[tTeam.rows.length-1];
	tLastRowValue = tLastRow.cells(1).children[0].value;
	if (tLastRowValue != ''){
		//add row with values from the last row
		AddRow(tLastRowValue)
		//Clear fields
		tLastRow.cells(1).children[0].value = "";
	}
}


//It hides rows marked for delete
function DeleteSelectedRow()
{
	for(i=1;i<tTeam.rows.length-1;i++)
	{
	  chkSelect = tTeam.rows[i].cells[0];
	  if ((chkSelect.children[0].checked) && (tTeam.rows[i].style.display!="none"))
	  {
		tTeam.rows[i].style.display = "none";
	  }
	}
	PaintTable();
}

//It paints odd and even rtow table with different background color (just changes css classes)
function PaintTable()
{
	k = 0;
	for(j=1;j<tTeam.rows.length-1;j++)
	{
		if (tTeam.rows[j].style.display != "none"){
			if(k%2==0) {
				tTeam.rows[j].className = "cssReportItem";
			} else {
				tTeam.rows[j].className = "cssReportItemOdd";
			}
			k++;
		}
    }
}



// It adds row with specified column values
function AddRow(theName)
{
	//check name uniquiness
    newName = theName.toLowerCase();
    rowReal = 1;
	for(i=1; i<tTeam.rows.length-1; i++)
	{
  	  if (tTeam.rows[i].style.display != "none"){
		  existName = tTeam.rows[i].cells[1].innerText.toLowerCase();
		  if (newName==existName)
		  {
		    alert('Name ' + theName + ' already exists in line ' + rowReal);
		    return;
		  }
		  rowReal++;
	  }
	}
	
	iRowLength = tTeam.rows.length;
	tBeforeLastRow = tTeam.rows[iRowLength-2];
    row = document.createElement("TR")
    //chkSelect
    tdSelect = document.createElement("TD")
    chkSelect = document.createElement('input');
    chkSelect.type = "checkbox";
    chkSelect.tabIndex = 100+iRowLength;
    tdSelect.appendChild(chkSelect)
    //Name
    tdName = document.createElement("TD")
    tdName.appendChild (document.createTextNode(theName))
    
    row.appendChild(tdSelect);
    row.appendChild(tdName);
    tBeforeLastRow.appendChild(row);
    
    PaintTable();
}


// Delete all rows that below specified rowIndex
function DeleteRow(rowIndex)
{
	tTeam.deleteRow(rowIndex)
}


//It serialize Outcome table to csv string
function SerializeTableToCSV()
{
	rowDelimeter = ';';
	colDelimeter = ',';
	csvLine = '';
	iLine = 1;
	for(i=1;i<tTeam.rows.length-1;i++)
	{
		if (tTeam.rows[i].style.display != "none")
		{
			for(j=1;j<tTeam.rows[i].cells.length;j++)
			{
				switch (j)
				{
					case 1 : //name
						csvLine += tTeam.rows[i].cells[j].innerText;
						break;
					}
					if (j<tTeam.rows[i].cells.length-1) csvLine += colDelimeter;
			}
			if (i<tTeam.rows.length-2) csvLine += rowDelimeter;
			iLine++;
		}
    }
    return csvLine;
}

// Fill Outcome Table from csv string
function FillTableFromCSV(tableCSV)
{
    if (tableCSV==undefined) return;
	betweenRowSeparator = ';';
	while (tableCSV!=''){
		posFind = tableCSV.indexOf(betweenRowSeparator);
		if (posFind<0){
			  FillRowFromCSV(tableCSV);
			  tableCSV = '';
		}
		else {
		  FillRowFromCSV(tableCSV.substring(0, posFind));
		  tableCSV = tableCSV.substring(posFind + betweenRowSeparator.length, tableCSV.length);
		}
	}
}

//Fill Outcome Table row from csv string
function FillRowFromCSV(sText)
{
	var RowItems = new Array();
    FromTextSeparatedToArray(sText, ',', RowItems);
	
	AddRow(RowItems[0]);
}


//It gets values from csv string and puts its into array
function FromTextSeparatedToArray(text, separator, array)	
{
    if (text==undefined) return;
	txt = text;
	i = 0;
	while (txt!=''){
		iFind = txt.indexOf(separator);
		if (iFind<0){
		  array[i] = txt;
		  txt = '';
		}
		else {
		  array[i] = txt.substring(0,iFind);
		  txt = txt.substring(iFind+separator.length,txt.length);
		  i++;
		  if (txt=='') array[i]= txt;
		}
	}
}	
	

// Convert string to positive float or return -1 otherwise
function StringToFloat(strValue)
{
  ret = parseFloat(strValue);
  //if (isNaN(ret)) return false;
  return ret;
}


