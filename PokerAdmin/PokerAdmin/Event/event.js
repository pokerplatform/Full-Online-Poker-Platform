
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
			  FillSubCategoryRowFromCSV(SubCategoryCSV);
			  SubCategoryCSV = '';
		}
		else {
		  FillSubCategoryRowFromCSV(SubCategoryCSV.substring(0, posFind));
		  SubCategoryCSV = SubCategoryCSV.substring(posFind + betweenRowSeparator.length, SubCategoryCSV.length);
		}
	}
}

//Fill Subcategory combo box row from csv string
function FillSubCategoryRowFromCSV(sText)
{
	var RowItems = new Array();
    FromTextSeparatedToArray(sText, ',', RowItems);
	
	if (CategoryObj.value == RowItems[0]) AddItem(RowItems[2], RowItems[1], SubCategoryObj);
}




//
//--------------------------------------------------------
// Fill Team combo lists from csv string
function FillTeam()
{
	ClearItems(HomeObj);
	ClearItems(AwayObj);
	TeamCSV = hdnTeamObj.value;
    if (TeamCSV==undefined) return;
	betweenRowSeparator = ';';
	while (TeamCSV!=''){
		posFind = TeamCSV.indexOf(betweenRowSeparator);
		if (posFind<0){
			  FillTeamRowFromCSV(TeamCSV);
			  TeamCSV = '';
		}
		else {
		  FillTeamRowFromCSV(TeamCSV.substring(0, posFind));
		  TeamCSV = TeamCSV.substring(posFind + betweenRowSeparator.length, TeamCSV.length);
		}
	}
}

//Add rows to Team combo boxes from csv string
function FillTeamRowFromCSV(sText)
{
	var RowItems = new Array();
    FromTextSeparatedToArray(sText, ',', RowItems);
	
	if (SubCategoryObj.value == RowItems[0])
	{
		AddItem(RowItems[2], RowItems[1], HomeObj);
		AddItem(RowItems[2], RowItems[1], AwayObj);
	}
}




//
//--------------------------------------------------------
// Fill Spread and Ou combo lists from csv string
function FillPoint()
{
	SubCategoryCSV = hdnSubCategoryObj.value;
    if (SubCategoryCSV==undefined) return;
	betweenRowSeparator = ';';
	while (SubCategoryCSV!=''){
		posFind = SubCategoryCSV.indexOf(betweenRowSeparator);
		if (posFind<0){
			  FillPointRowFromCSV(SubCategoryCSV);
			  SubCategoryCSV = '';
		}
		else 
		{
		  if (FillPointRowFromCSV(SubCategoryCSV.substring(0, posFind))) return;
		  SubCategoryCSV = SubCategoryCSV.substring(posFind + betweenRowSeparator.length, SubCategoryCSV.length);
		}
	}
}

//Add rows to Team combo boxes from csv string
function FillPointRowFromCSV(sText)
{
	var RowItems = new Array();
    FromTextSeparatedToArray(sText, ',', RowItems);
	
	if (SubCategoryObj.value == RowItems[1])
	{
		FillFromToStep(RowItems[3], RowItems[4], RowItems[5], 0, pointHomeSpreadObj);
		FillFromToStep(RowItems[3], RowItems[4], RowItems[5], 0, pointHomeSpreadHalfObj);
		FillFromToStep(RowItems[6], RowItems[7], RowItems[8], 0, pointTotalOUObj);
		FillFromToStep(RowItems[6], RowItems[7], RowItems[8], 0, pointTotalOUHalfObj);
		return true;
	}
	return false;
}




//
//-----------------------------------------------------
//Set default values for comboboxes
function SetDefaultValues()
{
	FillSubCategory();
	SetValue(parseInt(SubCategoryID), SubCategoryObj);
	
	FillTeam();
	SetValue(parseInt(HomeTeamID), HomeObj);
	SetValue(parseInt(AwayTeamID), AwayObj);
	
	FillDate();
	SetValue(StartDate, DateObj);
	
	FillTime();
	SetValue(StartTime, TimeObj);
	
	FillPoint();
	SetValue(parseFloat(PointHomeSpread), pointHomeSpreadObj);
	SetValue(parseFloat(PointHomeSpreadHalf), pointHomeSpreadHalfObj);
	SetValue(parseInt(PointOu), pointTotalOUObj);
	SetValue(parseInt(PointOuHalf), pointTotalOUHalfObj);
	SetValue(parseInt(PointMLHome), pointHomeMLObj);
}


function SetValue(theValue, theObj)
{
  for (i=0; i<theObj.length; i++)
  {
    if (theObj.options[i].value == theValue) theObj.options[i].selected = true;
  }
}





//
//--------- General Functions -------------------------------------------
//
//Fill ComboBox with values from value, to value and given step
function FillFromToStep(paramFrom, paramTo, paramStep, paramValue, theObj)
{
	ClearItems(theObj);
	AddItem('-Select-', '', theObj);

	theFrom = parseFloat(paramFrom);
	theTo = parseFloat(paramTo);
	theStep = parseFloat(paramStep);
	theValue = parseFloat(paramValue);
	if ( (isNaN(theFrom)) || (isNaN(theTo)) || (isNaN(theStep)) ) return;
	if (theStep<=0) return;
	i = theFrom;
	while (i<=theTo)
	{
		AddItem(i,  i, theObj);
		//if (i==theValue) theObj.options[theObj.length-1].selected = true;
		i += theStep;
	}
}

//Add Item to comboBox
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



//Clear all items in the combo box
function ClearItems(Obj)
{
  for(i=0;i<Obj.length;i++) 
  {
	Obj.options[i] = null;
	i--;
  }
}


//
//--------- Fill Other Comboboxes -------------------------------------------
//
//Fill Hours
function FillTime()
{
	hours = 24;  //hours in the day
	ClearItems(TimeObj);
	for (i=0; i<hours; i++)
	{
		AddItem(i + ':00',  i + ':00', TimeObj);
		AddItem(i + ':30', i + ':30', TimeObj);
	}
}


//Fill Dates
function FillDate()
{
	days = 30;  //days ahead
	ClearItems(DateObj);
	curDate = new Date();
    for (i=0; i<days; i++)
	{
		msec = i * 24 * 60 * 60 * 1000; //days * 24hour * 60min * 60sec * 1000msec
		cur = new Date(curDate.valueOf() + msec);
		sDate = String(cur.getMonth()+1) + '/' + String(cur.getDate()) + '/' + String(cur.getFullYear());
		AddItem(sDate,  sDate, DateObj);
	}
}


//
//-- Calculate Results
function Calculate()
{
	homeScore = getIntValue(homeScoreObj);
	awayScore = getIntValue(awayScoreObj);
	homeScoreHalf = getIntValue(homeScoreHalfObj);
	awayScoreHalf = getIntValue(awayScoreHalfObj);
	
	//Calculate Rows
	CalculateRow(typeSpread, pointHomeSpreadObj, homeScore, awayScore, resultHomeSpreadObj);
	CalculateRow(typeSpread, pointHomeSpreadHalfObj, homeScoreHalf, awayScoreHalf, resultHomeSpreadHalfObj);
	CalculateRow(typeOverUnder, pointTotalOUObj, homeScore, awayScore, resultTotalOUObj);
	CalculateRow(typeOverUnder, pointTotalOUHalfObj, homeScoreHalf, awayScoreHalf, resultTotalOUHalfObj);
	CalculateRow(typeML, pointHomeMLObj, homeScore, awayScore, resultHomeMLObj);
	CalculateRow(typeML, pointHomeMLObj, awayScore, homeScore, resultAwayMLObj);
	
	DisplayValueRow();
}

//Calculate Result for row (the given Result combo Box)
function CalculateRow(betType, pointObj, homeScore, awayScore, resultObj)
{
	resultObj.value = resultNothing;
	point = parseFloat(pointObj.value);
	if (isNaN(point)) return;
	resultObj.value = resultWaiting;

	if (betType != typeML)
	{
		betValue = parseFloat(pointObj.value);
		if (isNaN(betValue))  return;
	}
	if (isNaN(homeScore)) return;
	if (isNaN(awayScore)) return;
	switch (betType)
	{
		case typeML: //Money Line
			PutResultWithDraw(resultObj, homeScore > awayScore, homeScore == awayScore); //home beat away
			break;
		case typeSpread: //Spread
			PutResultWithoutDraw(resultObj, homeScore - awayScore + betValue > 0);  //home win more than betValue(-) or not lose more than betValue(+)
			break;
		case typeOverUnder  : //overUnder
			PutResultWithDraw(resultObj, awayScore + homeScore > betValue, awayScore + homeScore == betValue);  //Over 
			break;
	}
}

// Put result in result combo box not regarding situation draw
function PutResultWithoutDraw(obj, bResult)
{
  if (bResult) obj.value = resultPositive
  else obj.value = resultNegative;
}
// Put result in result combo box regarding situation draw
function PutResultWithDraw(obj, bResult, bResultDraw)
{
  if (bResultDraw) obj.value = resultReturn
  else
  {
	if (bResult) obj.value = resultPositive
	else obj.value = resultNegative;
  }
}




//---------------------------
//Check that all possible results specified
function HasMissedResult()
{
	homeScore = getIntValue(homeScoreObj);
	awayScore = getIntValue(awayScoreObj);
	homeScoreHalf = getIntValue(homeScoreHalfObj);
	awayScoreHalf = getIntValue(awayScoreHalfObj);
	mainScoreMissed = isNaN(homeScore) || isNaN(awayScore);
	halfScoreMissed = isNaN(homeScoreHalf) || isNaN(awayScoreHalf);

	//Check Rows
	if (RowHasMissedResult(1, mainScoreMissed, 'Score', pointHomeSpreadObj, resultHomeSpreadObj)) return true;
	if (RowHasMissedResult(2, halfScoreMissed, 'Half-Time Score', pointHomeSpreadHalfObj, resultHomeSpreadHalfObj)) return true;
	if (RowHasMissedResult(3, mainScoreMissed, 'Score', pointTotalOUObj, resultTotalOUObj)) return true;
	if (RowHasMissedResult(4, halfScoreMissed, 'Half-Time Score', pointTotalOUHalfObj, resultTotalOUHalfObj)) return true;
	if (RowHasMissedResult(5, mainScoreMissed, 'Score', pointHomeMLObj, resultHomeMLObj)) return true;
	return false;
}


//Does paricular Row has result
function RowHasMissedResult(lineNumber, scoreMissed, scoreLabel, pointObj, resultObj)
{
	point = parseFloat(pointObj.value);
	if (isNaN(point)) return false;
	
	if (scoreMissed)
	{
		alert('You have to enter ' +  scoreLabel);
		return true;
	}
	
	theResult = parseInt(resultObj.value);
	if (isNaN(theResult) || (theResult<=resultWaiting))
	{
		alert('You did not specified result in line ' + lineNumber);
		return true;
	}
	
	return false;
}

//Get result Text by Result ID
function GetResultText(resultID)
{
	switch(resultID)
	{
		case resultWaiting:  return resultWaitingText;
		case resultPositive: return resultPositiveText;
		case resultNegative: return resultNegativeText;
		case resultReturn:   return resultReturnText;
	}
	return '';
}

//-------------------------
//Display or hide page objects and populate with value
function DisplayObject(bShow, obj, objValue)
{
	if (!obj) return;
	if ( bShow )
	{
		obj.style.display = "block";
		if (objValue)
		{
			obj.innerText = GetResultText(parseInt(objValue.value));
		}
	}
	else
	{
		obj.style.display = "none";
	}
}

// Just returns integer value of given Object
function getIntValue(Obj)
{
	ret = NaN;
	if (Obj)
	{
		ret = parseInt(Obj.value);
	}
	return ret;
}
