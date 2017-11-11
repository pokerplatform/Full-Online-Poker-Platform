
<!-------------------------------------------------------------------------------------------------
//
//  ASP.NET Menu client-side script for Netscape Navigator 6+. 
//  Copyright 2002-2003 CYBERAKT INC. All Rights Reserved.
//  Version 1.1
//
//------------------------------------------------------------------------------------------------>

// Global variables -------------------------------------------------------------------------------
var aspnm_expandedObjects = new Array();  // array of expanded groups 
var aspnm_expandCount = 0;                // expanded group count 


// Event handlers ---------------------------------------------------------------------------------

// Positions the subgroup for the given item, and initiates its expansion 
function aspnm_itemMsOver(item, subGroup, expandDirection, horAdj, verAdj, expandDelay) 
{
  var newLeft = 0; 
  var newTop = 0; 
  var oItem = document.getElementById(item); 
  var oSubGroup = document.getElementById(subGroup); 

  switch (expandDirection)
  {
    case 'belowleft': 
      newLeft = aspnm_pageX(oItem); 
      newTop = aspnm_pageY(oItem) + oItem.offsetHeight; 
      break; 
    case 'belowright': 
      newLeft = aspnm_pageX(oItem) + oItem.offsetWidth - oSubGroup.offsetWidth; 
      newTop =  aspnm_pageY(oItem) + oItem.offsetHeight; 
      break; 
    case 'aboveleft': 
      newLeft = aspnm_pageX(oItem); 
      newTop =  aspnm_pageY(oItem) - oSubGroup.offsetHeight; 
      break; 
    case 'aboveright': 
      newLeft = aspnm_pageX(oItem) + oItem.offsetWidth - oSubGroup.offsetWidth; 
      newTop =  aspnm_pageY(oItem) - oSubGroup.offsetHeight; 
      break; 
    case 'rightdown': 
      newLeft = aspnm_pageX(oItem) + oItem.offsetWidth; 
      newTop = aspnm_pageY(oItem); 
      break; 
    case 'rightup': 
      newLeft = aspnm_pageX(oItem) + oItem.offsetWidth; 
      newTop = aspnm_pageY(oItem) - oSubGroup.offsetHeight + oItem.offsetHeight; 
      break; 
    case 'leftdown': 
      newLeft = aspnm_pageX(oItem) - oSubGroup.offsetWidth; 
      newTop = aspnm_pageY(oItem); 
      break; 
    case 'leftup': 
      newLeft = aspnm_pageX(oItem) - oSubGroup.offsetWidth; 
      newTop = aspnm_pageY(oItem) - oSubGroup.offsetHeight + oItem.offsetHeight; 
      break; 
    default: 
      newLeft = aspnm_pageX(oItem) + oItem.offsetWidth; 
      newTop = aspnm_pageY(oItem); 
      break; 
  }  

  newLeft += horAdj; 
  if (verAdj < 0) newTop += verAdj; 
  if (!(navigator.userAgent.indexOf('Netscape6') > 0))   {    var cs = window.getComputedStyle(oSubGroup, ''); 
    var topCorrection = parseInt(cs.getPropertyValue('border-top-width').replace('px', ''));  
    var leftCorrection = parseInt(cs.getPropertyValue('border-left-width').replace('px', ''));  
    newLeft += topCorrection;     newTop += topCorrection;   }
  oSubGroup.style.left = newLeft + 'px'; 
  oSubGroup.style.top = newTop + 'px'; 
  
  aspnm_expand(subGroup); 
}

// If the mouse pointer is not over the given item or its subGroup, 
// this function initiates the collapse of the subGroup. 
function aspnm_itemMsOut(item, group, subGroup, expandDelay, evt)
{
  if (!(aspnm_isMouseOnObject(subGroup, evt)))
    aspnm_collapse(subGroup);
}

// Not needed if expand delay is not implemented. 
function aspnm_groupMsOver(group)
{

}

// If the mouse pointer is on the given group, its subGroup, or its parent item this function 
// does nothing. If the pointer is over the parent group, but outside the parent item, then it
// initiates the collapse of itself and its subGroup (if any). 
// Otherwise, the pointer is outside the menu structure and it initiates the collapse of all 
// expanded objects. 
function aspnm_groupMsOut(group, parentItem, parentGroup, expandDelay, evt)
{ 
  var subGroup = aspnm_expandedObjects[aspnm_expandCount]; 
  if (subGroup == group) subGroup = null; 

  
  if (aspnm_isMouseOnObject(group, evt) || aspnm_isMouseOnObject(subGroup, evt) || aspnm_isMouseOnObject(parentItem, evt))
    ; //alert('do nothing');   // do nothing 
  else if (aspnm_isMouseOnObject(parentGroup, evt))
  {
    aspnm_collapse(group); 
    aspnm_collapse(subGroup); 
  }
  else
  {
    aspnm_collapseAll(); 
  }
}

// Core functions ---------------------------------------------------------------------------------

// Expands the given menu group 
function aspnm_expand(group)
{
  var oGroup = document.getElementById(group); 
  if (oGroup.style.visibility != 'visible')
  {
    aspnm_hideSelectElements(group); 
    oGroup.style.visibility = 'visible'; 
    aspnm_expandCount++; 
    aspnm_expandedObjects[aspnm_expandCount] = group; 
  }  
}

// Collapses the given menu group 
function aspnm_collapse(group)
{
  var oGroup = document.getElementById(group); 
  if (group != null && group) 
    if (oGroup.style.visibility != 'hidden')
    {
      oGroup.style.visibility = 'hidden';     
      aspnm_expandCount--; 
    }  
  if (!(aspnm_contextUp) && aspnm_expandCount == 0) 
    aspnm_restoreSelectElements(); 
}

// Collapses all expanded menu groups 
function aspnm_collapseAll()
{
  for (var i = aspnm_expandCount; i >= 1; i--)
  {
    var oGroup = document.getElementById(aspnm_expandedObjects[i]); 
    oGroup.style.visibility = 'hidden';
  }
  aspnm_expandCount = 0;   
  if (!(aspnm_contextUp) && aspnm_expandCount == 0) 
    aspnm_restoreSelectElements(); 
}

// Hides all menu groups prior to calling ClientSideOnClick event handler
function aspnm_hideAllGroups()
{
  aspnm_collapseAll(); 
}

// Utilities --------------------------------------------------------------------------------------

// Determines whether the mouse pointer is currently over the given object 
function aspnm_isMouseOnObject(objName, evt)
{
  if (objName != null)
  {
    var obj = document.getElementById(objName); 
    var objLeft = aspnm_pageX(obj) - 1; 
    var objTop = aspnm_pageY(obj) - 1; 
    var objRight = objLeft + obj.offsetWidth + 1; 
    var objBottom = objTop + obj.offsetHeight + 1;
    
    if ((evt.pageX > objLeft) && (evt.pageX < objRight) && 
        (evt.pageY > objTop) && (evt.pageY < objBottom))
      return true; 
    else  
      return false; 
  }
  else
    return false; 
}

// Calculates the absolute page x coordinate of any element
function aspnm_pageX(element)
{
  var x = 0;
  do 
  {
    if (element.style.position == 'absolute') 
    {
      return x + element.offsetLeft; 
    }
    else
    {
      x += element.offsetLeft;
      if (element.offsetParent) 
        if (element.offsetParent.tagName == 'TABLE') 
          if (parseInt(element.offsetParent.border) > 0)
          {
            x += 1; 
          }
    }
  }
  while ((element = element.offsetParent));
  return x; 
}

// Calculates the absolute page y coordinate of any element
function aspnm_pageY(element)
{
  var y = 0;
  do 
  {
    if (element.style.position == 'absolute') 
    {
      return y + element.offsetTop; 
    }
    else
    {
      y += element.offsetTop;
      if (element.offsetParent) 
        if (element.offsetParent.tagName == 'TABLE') 
          if (parseInt(element.offsetParent.border) > 0)
          {
            y += 1; 
          }
    }
  }
  while ((element = element.offsetParent));
  return y; 
}


// Hides HTML select elements that are overlapping the given menu group 
function aspnm_hideSelectElements(group)
{
  if (document.getElementsByTagName) 
  {
    var arrElements = document.getElementsByTagName('select'); 
    if (aspnm_hideSelectElems) 
      for (var i = 0; i < arrElements.length; i++) 
        if (aspnm_objectsOverlapping(document.getElementById(group), arrElements[i]))
          arrElements[i].style.visibility = 'hidden'; 
  }
}

// Whether the given objects are overlapping 
function aspnm_objectsOverlapping(obj1, obj2)
{
  var result = true; 
  var obj1Left = aspnm_pageX(obj1); 
  var obj1Top = aspnm_pageY(obj1); 
  var obj1Right = obj1Left + obj1.offsetWidth; 
  var obj1Bottom = obj1Top + obj1.offsetHeight;
  var obj2Left = aspnm_pageX(obj2); 
  var obj2Top = aspnm_pageY(obj2); 
  var obj2Right = obj2Left + obj2.offsetWidth; 
  var obj2Bottom = obj2Top + obj2.offsetHeight;
  
  if (obj1Right <= obj2Left || obj1Bottom <= obj2Top || 
      obj1Left >= obj2Right || obj1Top >= obj2Bottom) 
    result = false; 
  return result; 
}

// Restores all HTML select elements on the page 
function aspnm_restoreSelectElements()
{
  if (document.getElementsByTagName) 
  {
    var arrElements = document.getElementsByTagName('select'); 
    if (aspnm_hideSelectElems) 
      for (var i = 0; i < arrElements.length; i++) 
        arrElements[i].style.visibility = 'visible'; 
  }
}

// Positions the menu based on the alignment, offsetX, and offsetY properties
function aspnm_positionMenu(menu, alignment, offsetX, offsetY)
{
  if (aspnm_dragging) return false; 
  var scrlLeft = window.pageXOffset; 
  var scrlTop = window.pageYOffset;
  var clientW = window.innerWidth; 
  var clientH = window.innerHeight; 
  var menuWidth = menu.offsetWidth; 
  var menuHeight = menu.offsetHeight; 
  var newLeft = 0; 
  var newTop = 0; 

  switch (alignment)
  {
    case 'topleft': 
      newLeft = scrlLeft;
      newTop = scrlTop;
      break; 
    case 'topmiddle': 
      newLeft = (clientW - menuWidth) / 2 + scrlLeft;
      newTop = scrlTop;
      break; 
    case 'topright': 
      newLeft = clientW + scrlLeft - menuWidth;
      newTop = scrlTop;
      break; 
    case 'bottomleft': 
      newLeft = scrlLeft;
      newTop = clientH + scrlTop - menuHeight;
      break; 
    case 'bottommiddle': 
      newLeft = (clientW - menuWidth) / 2 + scrlLeft;
      newTop = clientH + scrlTop - menuHeight;
      break; 
    case 'bottomright': 
      newLeft = clientW + scrlLeft - menuWidth;
      newTop = clientH + scrlTop - menuHeight;
      break; 
    default: 
      newLeft = clientW + scrlLeft;
      newTop = clientH + scrlTop;
      break; 
  }    
  
  newLeft += offsetX; 
  newTop += offsetY; 
  menu.style.left = newLeft; 
  menu.style.top = newTop; 
}
