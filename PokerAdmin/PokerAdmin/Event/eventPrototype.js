
// Fill Subcategory combo list from csv string
function FillSubCategory()
{
	ClearItems(SubCategoryObj);
	SubCategoryCSV = hdnSubCategoryObj.value;
    if (SubCategoryCSV==undefined) return;
	betweenRowSeparator = ';';
	while (SubCategoryCSV!=''){
		posFind = SubCategoryCSV.indexOf(betweenRowSeparator);
		if (posFind<0){
			  FillRowFromCSV(SubCategoryCSV);
			  SubCategoryCSV = '';
		}
		else {
		  FillRowFromCSV(SubCategoryCSV.substring(0, posFind));
		  SubCategoryCSV = SubCategoryCSV.substring(posFind + betweenRowSeparator.length, SubCategoryCSV.length);
		}
	}
}

//Fill Outcome Table row from csv string
function FillRowFromCSV(sText)
{
	var RowItems = new Array();
    FromTextSeparatedToArray(sText, ',', RowItems);
	
	if (CategoryObj.value == RowItems[2]) AddItem(RowItems[0], RowItems[1], SubCategoryObj);
}

function AddItem(theName, theValue, theObj)
{
	OptionObj = new Option();
	OptionObj.text = theName;
	OptionObj.value = theValue;
	theObj.options[theObj.length] = OptionObj;
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
		  array[i] = txt.replace(/<comma>/g, ',');
		  txt = '';
		}
		else {
		  array[i] = txt.substring(0,iFind).replace(/<comma>/g, ',');
		  txt = txt.substring(iFind+separator.length,txt.length);
		  i++;
		  if (txt=='') array[i]= txt.replace(/<comma>/g, ',');
		}
	}
}	


function ClearItems(Obj){
  for(i=0;i<Obj.length;i++) 
  {
	Obj.options[i] = null;
	i--;
  }
}









//--------------------------------------------------------
// Fill Home combo list from csv string
function FillHome()
{
	ClearItems(HomeObj);
	SubCategoryCSV = hdnHomeObj.value;
    if (SubCategoryCSV==undefined) return;
	betweenRowSeparator = ';';
	while (SubCategoryCSV!=''){
		posFind = SubCategoryCSV.indexOf(betweenRowSeparator);
		if (posFind<0){
			  FillRowFromCSV(SubCategoryCSV);
			  SubCategoryCSV = '';
		}
		else {
		  FillHomeRowFromCSV(SubCategoryCSV.substring(0, posFind));
		  SubCategoryCSV = SubCategoryCSV.substring(posFind + betweenRowSeparator.length, SubCategoryCSV.length);
		}
	}
}

//Fill Home Table row from csv string
function FillHomeRowFromCSV(sText)
{
	var RowItems = new Array();
    FromTextSeparatedToArray(sText, ',', RowItems);
	
	if (SubCategoryObj.value == RowItems[2]) AddItem(RowItems[0], RowItems[1], HomeObj);
}


function FillAway()
{
	ClearItems(AwayObj);
	SubCategoryCSV = hdnAwayObj.value;
    if (SubCategoryCSV==undefined) return;
	betweenRowSeparator = ';';
	while (SubCategoryCSV!=''){
		posFind = SubCategoryCSV.indexOf(betweenRowSeparator);
		if (posFind<0){
			  FillRowFromCSV(SubCategoryCSV);
			  SubCategoryCSV = '';
		}
		else {
		  FillAwayRowFromCSV(SubCategoryCSV.substring(0, posFind));
		  SubCategoryCSV = SubCategoryCSV.substring(posFind + betweenRowSeparator.length, SubCategoryCSV.length);
		}
	}
}


//Fill Away Table row from csv string
function FillAwayRowFromCSV(sText)
{
	var RowItems = new Array();
    FromTextSeparatedToArray(sText, ',', RowItems);
	
	if (SubCategoryObj.value == RowItems[2]) AddItem(RowItems[0], RowItems[1], AwayObj);
}
