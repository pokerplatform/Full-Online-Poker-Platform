
// It adds row or column
function AddNew()
{
  rowID = getSelectedRow();
  if (rowID>=0) {
    AddRow(rowID);
    return;
  }
  colID = getSelectedColumn();
  if (colID>=0) {
    AddColumn(colID);
    return;
  }
  alert('Please select some row or column.');
}


// It delete row ort column
function DeleteSelected()
{
  rowID = getSelectedRow();
  if (rowID>=0) {
    DeleteRow(rowID);
    return;
  }
  colID = getSelectedColumn();
  if (colID>=0) {
    DeleteColumn(colID);
    return;
  }
  alert('Please select some row or column.');
}


// It return mumber of selected row if exists
function getSelectedRow()
{
	for(i=1;i<tTable.rows.length;i++)
	{
	  chkSelect = tTable.rows[i].cells[0];
	  if (tTable.rows[i].style.display!="none")
	  {
		//  ---
	    if (chkSelect.children[0])
	    {
			if (chkSelect.children[0].checked)
		    {
				chkSelect.children[0].checked = false;
				return i;
			}
		}
	    if (chkSelect.children[0].children[0])
	    {
			if (chkSelect.children[0].children[0].checked)
			{
				chkSelect.children[0].children[0].checked = false;
				return i;
			}
		}
		// ---
	  }
	}
	return -1;
}
	
// It return mumber of selected column if exists
function getSelectedColumn()
{
	for(i=1;i<tTable.rows[0].cells.length;i++)
	{
	  chkSelect = tTable.rows[0].cells[i];
	  if (chkSelect.style.display!="none")
	  {
	    // ---
	    if (chkSelect.children[0].children[0])
	    {
			if (chkSelect.children[0].children[0].checked)
			{
				chkSelect.children[0].children[0].checked = false;
				return i;
			}
		}
	    if (chkSelect.children[0])
	    {
			if (chkSelect.children[0].checked)
		    {
				chkSelect.children[0].checked = false;
				return i;
			}
		}
	    // ---
	  }
	}
	return -1;
}


//It Adds new row in the table
function AddRow(insertAfter)
{
	tAddAfterRow = tTable.rows[insertAfter];
    row = tTable.insertRow(insertAfter+1); 
    row.className = tAddAfterRow.className;
    
   	for(col=0;col<tAddAfterRow.cells.length;col++)
   	{
	    tdObject = document.createElement("TD")
	    tdObject.className = tAddAfterRow.cells[col].className;
	    tdObject.style.display = tAddAfterRow.cells[col].style.display;
   		theID = 'edt_' + (insertAfter+1) + '_' + col;
   		if (col==0)
   		{
		    radioFirst = document.createElement('<input type="radio" name="' + radioGroupName + '">');
			radioFirst.id = 'radio_' + theID;
			radioFirst.className = '"' + tAddAfterRow.cells[col].children[0].className + '"';
	 	    tdObject.appendChild(radioFirst);
	 	}
	    txtValue = document.createElement('input');
		txtValue.type = 'text';
		txtValue.ID = theID;
		if (col==0)
			txtValue.className = tAddAfterRow.cells[col].children[1].className;
		else	
			txtValue.className = tAddAfterRow.cells[col].children[0].className;
	    tdObject.appendChild(txtValue);
	    row.appendChild(tdObject);
   	}
}


//It Adds new column in table
function AddColumn(insertAfter)
{
	for(row=0;row<tTable.rows.length;row++)
	{
	    tdObject = tTable.rows(row).insertCell(insertAfter+1);
	    tdObject.className = tTable.rows[row].cells[insertAfter].className;
	    theID = 'edt_' + row + '_' + (insertAfter+1);
	    if (row==0)
	    {
		    radioFirst = document.createElement('<input type="radio" name="' + radioGroupName + '">');
			radioFirst.id = 'radio_' + theID;
			radioFirst.className = '"' + tTable.rows[row].cells[insertAfter].children[0].className + '"';
	 	    tdObject.appendChild(radioFirst);
	    }
	    txtValue = document.createElement('input');
		txtValue.type = 'text';
		txtValue.ID = theID;
        if (row==0) 
			txtValue.className = tTable.rows[row].cells[insertAfter].children[1].className;
		else
			txtValue.className = tTable.rows[row].cells[insertAfter].children[0].className;
 	    tdObject.appendChild(txtValue);
	}
	return;
}


//It hides row marked for delete
function DeleteRow(deleteAfter)
{
	realRowCount = 0;
	for(row=0;row<tTable.rows.length;row++)
	{
	   if (tTable.rows[row].style.display != "none") realRowCount++;
	}
	if (realRowCount<=2) return;
	tTable.rows[deleteAfter].style.display = "none";
}

//It hides rows marked for delete
function DeleteColumn(deleteAfter)
{
	realColCount = 0;
	for(col=0;col<tTable.rows[0].cells.length;col++)
	{
	   if (tTable.rows[0].cells[col].style.display != "none") realColCount++;
	}
	if (realColCount<=2) return;
	for(row=0;row<tTable.rows.length;row++)
	{
		tTable.rows[row].cells[deleteAfter].style.display = "none";
	}
}



function getFromValue(sTitle)
{
  pos = sTitle.indexOf('-',0);   
  if (pos<0) pos = sTitle.length;
  ret = parseFloat(sTitle.substring(0, pos));
  if (isNaN(ret)) return -1;
  return ret;
}
function getToValue(sTitle)
{
  pos = sTitle.indexOf('-',0);   
  if (pos<0) pos = -1;
  ret = parseFloat(sTitle.substring(pos+1, sTitle.length));
  if (isNaN(ret)) return -1;
  return ret;
}

//
function SerializeTableToXML()
{
	retXML = '<' + topMostNodeName + '>';
	colReal = 1;
	rowReal = 1;
	for(col=1;col<tTable.rows[0].cells.length;col++)
	{
		if (tTable.rows[0].cells[col].style.display != "none"){
			columnTitle = tTable.rows[0].cells[col].children[1].value;
			fromValue = getFromValue(columnTitle);
			toValue = getToValue(columnTitle);
			if ((fromValue<0) || (toValue<0))
			{
				alert('Value in cell (' + colReal + ',0) is not numeric');
				return '';
			}
			retXML += '<players from="' + fromValue + '" to="' + toValue + '">';
			rowReal = 1;
			cellSum = 0.0;
			for(row=1;row<tTable.rows.length;row++)
			{
				if (tTable.rows[row].style.display != "none"){
					rowTitle = tTable.rows[row].cells[0].children[1].value;
					fromValue = getFromValue(rowTitle);
					toValue = getToValue(rowTitle);
					if ((fromValue<0) || (toValue<0))
					{
						alert('Value in cell (0,' + rowReal + ') is not numeric');
						return '';
					}
					cellValue = tTable.rows[row].cells[col].children[0].value;
					if (cellValue!=''){
						floatValue = parseFloat(cellValue);
						if (isNaN(floatValue)){
							alert('Value in cell (' + colReal + ',' + rowReal + ') is not numeric');
							return '';
						}
						cellSum += floatValue;
					}
					retXML += '<place from="' + fromValue + '" to="' + toValue + '" prizeRate="' + cellValue + '"/>';
					rowReal++;
				}
			}
			if (checkSum)
			{
				if (cellSum>100.0)
				{
						alert('Sum in column ' + colReal + ' is more that 100%');
						return '';
				}
			}
			retXML += '</players>'
			colReal++;
		}
	}
	retXML += '</' + topMostNodeName + '>';
	return retXML;
}


