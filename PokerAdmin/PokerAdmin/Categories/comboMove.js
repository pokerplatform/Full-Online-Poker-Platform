//Add to curent statistic list
function Attach()
{
	Copy(srcObj, destObj);
}

//Remove from curent statistic list
function Detach()
{
	Copy(destObj, srcObj);
}


//Move selected rows to one line up
function UpRow()
{
	Move(destObj, -1);
}

//Move selected rows to one line down
function DownRow()
{
	Move(destObj, 1);
}


//Serialize combo to string of values
function SerializeToString(obj)
{
  ret = '';
  for(var i=0; i<obj.length; i++)
  {
    if (ret!='') ret += ',';
    ret += obj.options[i].value;
  }
  return ret;
}


//Move selected element(s) up and down inside list
function Move(obj, step)
{
  theLength = obj.length;
  for(var z=0; z<theLength; z++)
  {
    if (step < 0) i = z
    else i = theLength -1 - z;
    if (obj.options[i].selected)
    {
		j = i + step;
		if ((j >= 0) && (j < theLength))
		{
			theText  = obj.options[j].text;
			theValue = obj.options[j].value;
			theSelected = obj.options[j].selected;
			obj.options[j].text  = obj.options[i].text;
			obj.options[j].value = obj.options[i].value;
			obj.options[i].text  = theText;
			obj.options[i].value = theValue;
			obj.options[i].selected = theSelected;
			obj.options[j].selected = true;
		}
    }
  }
}


//Copy selected element(s) from one list to another
function Copy(src,dest,obj1,obj2)
{
  for(var i=0; i<src.length; i++)
  {
    if(src.options[i].selected)
    {
        tmp = new Option(src.options[i].text);
        tmp.value=src.options[i].value;
        dest.options[dest.length]=tmp;
    }
  }
  Remove(src);
}


//remove selected rows 
function Remove(Obj){
  var selArr = new Array();
  for(var i=0; i<Obj.length; i++){
    selArr[i] = Obj.options[i].selected;
    Obj.options[i].selected = false;
  }
  j = 0;
  for(var i=0; i<Obj.length; i++){
    if(selArr[j]) {Obj.options[i]=null;i--;}
    j++;
  }
}

