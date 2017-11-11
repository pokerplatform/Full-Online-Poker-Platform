
function tab_itemMsOver(item, subGroup, expandDirection, horAdj, verAdj, expandDelay, effect) 
{
  var newLeft = 0; 
  var newTop = 0; 
  var oItem = document.all[item]; 
  var oSubGroup = document.all[subGroup]; 

  if (tab_curItem != item)
  {
    tab_curItem = item; 
  
		if (tab_mac && oItem.tagName=="TABLE")
			oItem = oItem.parentElement;
		
    switch (expandDirection)
    {
      case 'belowleft': 
        newLeft = tab_pageX(oItem); 
        if (newLeft + oSubGroup.offsetWidth > window.document.body.clientWidth)
          newLeft = tab_pageX(oItem) + oItem.offsetWidth - oSubGroup.offsetWidth; 
        newTop = tab_pageY(oItem) + oItem.offsetHeight; 
        break; 
      case 'belowright': 
        newLeft = tab_pageX(oItem) + oItem.offsetWidth - oSubGroup.offsetWidth; 
        newTop =  tab_pageY(oItem) + oItem.offsetHeight; 
        break; 
      case 'aboveleft': 
        newLeft = tab_pageX(oItem); 
        newTop =  tab_pageY(oItem) - oSubGroup.offsetHeight; 
        break; 
      case 'aboveright': 
        newLeft = tab_pageX(oItem) + oItem.offsetWidth - oSubGroup.offsetWidth; 
        newTop =  tab_pageY(oItem) - oSubGroup.offsetHeight; 
        break; 
      case 'rightdown': 
        newLeft = tab_pageX(oItem) + oItem.offsetWidth; 
        if (newLeft + oSubGroup.offsetWidth > window.document.body.clientWidth)
          newLeft = tab_pageX(oItem) - oSubGroup.offsetWidth; 
        newTop = tab_pageY(oItem); 
        if (newTop + oSubGroup.offsetHeight > window.document.body.clientHeight)
          newTop = tab_pageY(oItem) - oSubGroup.offsetHeight + oItem.offsetHeight; 
        break; 
      case 'rightup': 
        newLeft = tab_pageX(oItem) + oItem.offsetWidth; 
        newTop = tab_pageY(oItem) - oSubGroup.offsetHeight + oItem.offsetHeight; 
        break; 
      case 'leftdown': 
        newLeft = tab_pageX(oItem) - oSubGroup.offsetWidth; 
        newTop = tab_pageY(oItem); 
        break; 
      case 'leftup': 
        newLeft = tab_pageX(oItem) - oSubGroup.offsetWidth; 
        newTop = tab_pageY(oItem) - oSubGroup.offsetHeight + oItem.offsetHeight; 
        break; 
      default: 
        newLeft = tab_pageX(oItem) + oItem.offsetWidth; 
        newTop = tab_pageY(oItem); 
        break; 
    }  
    newLeft += horAdj; 
    newTop += verAdj; 
    if (newTop < 0) 
			newTop = 0; 
    if (newLeft < 0) 
			newLeft = 0; 
    
    oSubGroup.style.left = newLeft + 'px'; 
    oSubGroup.style.top = newTop + 'px';
      
    tab_startExpand(subGroup, expandDelay, effect); 
  }
}

function tab_itemMsOut(item, group, subGroup, expandDelay, effect)
{
  if ((!(tab_isMouseOnObject(item))) && subGroup) 
    if (!(tab_isMouseOnObject(subGroup)))
    {
      tab_curItem = ''; 
      tab_startCollapse(subGroup, expandDelay, effect);
    }  
}

function tab_groupMsOver(group)
{
  if (tab_collapsingAll) tab_restoredGroup = group;

  if (tab_collapsingGroup == group) 
  {
    tab_stopCollapse(); 
    tab_stopExpand(); 
  }
}

function tab_groupMsOut(group, parentItem, parentGroup, expandDelay, effect)
{ 
  if (!(tab_isMouseOnObject(group)))
  {
    tab_curItem = ''; 

    var subGroup = tab_expandedObjects[tab_expandCount]; 
    if (subGroup == group) subGroup = null; 

    if (parentItem == null && parentGroup == null && !(tab_isMouseOnObject(group)))
      tab_startCollapseAll(expandDelay, effect);     
    else if (tab_isMouseOnObject(group) || tab_isMouseOnObject(subGroup) || tab_isMouseOnObject(parentItem))
      ; // do nothing 
    else if (tab_isMouseOnObject(parentGroup))
    {
      tab_startCollapse(group, expandDelay, effect); 
      tab_startCollapse(subGroup, expandDelay, effect); 
    }
    else
      tab_startCollapseAll(expandDelay, effect);     
  }
}

function tab_startExpand(group, interval, effect)
{
  if (group == tab_collapsingGroup) tab_stopCollapse(); 
  if (group != tab_expandingGroup) tab_stopExpand();  
  
  tab_restoredGroup = group; 
  
  tab_expandingGroup = group; 
  if (group) group += '.id'; 
  if (effect) effect = "'" + effect + "'";  
  tab_expandTimerID = setTimeout('tab_expand(' + group + ', ' + effect + ')', interval); 
}

// Initiates the collapse of the given group. 
function tab_startCollapse(group, interval, effect)
{
  if (group == tab_expandingGroup) tab_stopExpand(); 

  if (group) 
    if (document.all[group].style.visibility == 'visible') 
    {
      tab_collapsingGroup = group; 
      group += '.id'; 
      if (effect) effect = "'" + effect + "'";  
      tab_collapseTimerID = setTimeout('tab_collapse(' + group + ', ' + effect + ')', interval); 
    }  
}

// Initiates the collapse of all expanded objects. 
function tab_startCollapseAll(interval, effect)
{
  tab_stopCollapse(); 
  tab_stopExpand(); 
  tab_stopCollapseAll(); 

  tab_collapsingAll = true; 
  if (effect) 
  {
    effect = "'" + effect + "'";  
    tab_collapseAllTimerID = setTimeout('tab_collapseAll(' + effect + ')', interval); 
  }
  else
    tab_collapseAllTimerID = setTimeout('tab_collapseAll(null)', interval); 
}

// Stops the expand of the currently expanding group. 
function tab_stopExpand()
{
  clearTimeout(tab_expandTimerID); 
  tab_expandingGroup = ''; 
}

// Stops the collapse of the currently collapsing group. 
function tab_stopCollapse()
{
  clearTimeout(tab_collapseTimerID); 
  tab_collapsingGroup = ''; 
}

// Stops the collapse of all currently expanding objects. 
function tab_stopCollapseAll()
{
  clearTimeout(tab_collapseAllTimerID); 
  tab_restoredGroup = '';
}


// Core functions ---------------------------------------------------------------------------------

// Expands the given menu group 
function tab_expand(group, effect)
{
  if (document.all[group].style.visibility != 'visible')
  {
    tab_hideSelectElements(group); 
    tab_showOverlay(document.all[group]);
    if (effect) 
    {
      document.all[group].style.filter = effect; 
      document.all[group].filters[0].Apply(); 
    }  
    document.all[group].style.visibility = 'visible'; 
    tab_makeDropShadow(group); 
    if (effect) document.all[group].filters[0].Play(); 
    tab_expandCount++; 
    tab_expandedObjects[tab_expandCount] = group; 
  }  
}

// Collapses the given menu group 
function tab_collapse(group, effect)
{
  if (group) 
  {
    if (document.all[group].style.visibility != 'hidden')
    {
      if (effect)
      {
        document.all[group].style.filter = effect; 
        document.all[group].filters[0].Apply(); 
      }
      document.all[group].style.visibility = 'hidden';     
      if (effect) document.all[group].filters[0].Play();
      if (tab_expandedObjects[tab_expandCount] != group)
				for (var i=0; i<tab_expandCount; i++)
					if (tab_expandedObjects[i] == group)
						tab_expandedObjects[i] = tab_expandedObjects[tab_expandCount];
      tab_expandCount--; 
      tab_hideOverlay(document.all[group]);
      tab_clearDropShadow(group); 
    }      
  }
  if (!(tab_contextUp) && tab_expandCount == 0) 
    tab_restoreSelectElements(); 
}

// Collapses all expanded menu groups 
function tab_collapseAll(effect)
{
  for (var i = tab_expandCount; i >= 1; i--)
  {
    if (tab_expandedObjects[i] == tab_restoredGroup) break; 

    if (effect)
    {
      document.all[tab_expandedObjects[i]].style.filter = effect; 
      document.all[tab_expandedObjects[i]].filters[0].Apply(); 
    }
    document.all[tab_expandedObjects[i]].style.visibility = 'hidden';
    tab_hideOverlay(document.all[tab_expandedObjects[i]]);
    tab_clearDropShadow(tab_expandedObjects[i]); 
    if (effect) document.all[tab_expandedObjects[i]].filters[0].Play(); 
  }

  tab_collapsingAll = false; 
  tab_expandCount = i;
  tab_restoredGroup = ''; 
  if (!(tab_contextUp) && tab_expandCount == 0) 
    tab_restoreSelectElements(); 
}

// Hides all menu groups prior to calling ClientSideOnClick event handler
function tab_hideAllGroups()
{
  tab_curItem = ''; 
  tab_restoredGroup = ''; 
  tab_collapseAll(null); 
}

// Utilities --------------------------------------------------------------------------------------

// Updates menu item class, left icon, and right icon 
function tab_updateCell(Element, NewClassName, LeftImage, LeftImageSrc, RightImage, RightImageSrc, direction)
{  
  if (direction == 'out' && tab_isMouseOnObject(Element))    
    ;   
  else  
  {    
    if (Element != null & NewClassName != '') document.all[Element].className = NewClassName;
    if (LeftImage != null  && LeftImageSrc != '') document.images[LeftImage].src = LeftImageSrc;     
    if (RightImage != null && RightImageSrc != '') document.images[RightImage].src = RightImageSrc;   
  }
}

// Determines whether the mouse pointer is currently over the given object 
function tab_isMouseOnObject(objName)
{
  if (objName)
  {
		var obj = document.all[objName];
		
		if (tab_mac && obj.tagName=="TABLE" && obj.parentElement.tagName=="TD")
			obj = obj.parentElement;
  
    var objLeft = tab_pageX(obj) - window.document.body.scrollLeft + 1; 
    var objTop = tab_pageY(obj) - window.document.body.scrollTop + 1; 
    var objRight = objLeft + obj.offsetWidth - 1; 
    var objBottom = objTop + obj.offsetHeight - 1;
      
    var ex = (tab_mac) ? event.x+2 : event.x;
    var ey = (tab_mac) ? event.y+2 : event.y;
    
    if ((ex > objLeft) && (ex < objRight) && 
        (ey > objTop) && (ey < objBottom))
      return true; 
    else  
      return false; 
  }
  else
    return false; 
}

// Calculates the absolute page x coordinate of any element
function tab_pageX(o)
{
  return ( tab_mac ? tab_macX(o) : tab_winX(o) );
}

// Calculates the absolute page x coordinate of given element for Windows clients
function tab_winX(o)
{
  var x = 0;
  while (o != document.body)
  {
    x += o.offsetLeft;
    o = o.offsetParent;
  }
  return x;
}

// Calculates the absolute page x coordinate of given element for Mac clients
function tab_macX(o)
{
  var x = 0;
  while (o.offsetParent != document.body)
  {
    if ((o.tagName=="TABLE") && (o.offsetParent.tagName=="TD"))
      x += o.clientLeft;
    else
      x += o.offsetLeft;
    o = o.offsetParent;
  }
  x += (o.offsetLeft + tab_pgMrgX());
  return x;
}

// Returns the body's left margin in pixels
function tab_pgMrgX()
{
  if (!tab_marginX)
  {
    if (!document.all["tab_pgMrgMsr"])
			tab_createPgMrgMsr();
		tab_marginX = -document.all["tab_pgMrgMsr"].offsetLeft;
  }
  return tab_marginX;
}

// Calculates the absolute page y coordinate of any element
function tab_pageY(o)
{
  return ( tab_mac ? tab_macY(o) : tab_winY(o) );
}

// Calculates the absolute page y coordinate of given element for Windows clients
function tab_winY(o)
{
  var y = 0;
  while (o != document.body)
  {
    y += o.offsetTop;
    o = o.offsetParent;
  }
  return y;
}

// Calculates the absolute page y coordinate of given element for Mac clients
function tab_macY(o)
{
  var y = 0;
  while (o.offsetParent != document.body)
  {
    if ((o.tagName=="TABLE") && (o.offsetParent.tagName=="TD"))
      y += o.clientTop;
    else
      y += (o.tagName!="TD") ? o.offsetTop : o.parentElement.offsetTop;
    o = o.offsetParent;
  }
  y += (o.offsetTop + tab_pgMrgY());
  return y;
}

// Returns the body's top margin in pixels
function tab_pgMrgY()
{
  if (!tab_marginY)
  {
    if (!document.all["tab_pgMrgMsr"])
			tab_createPgMrgMsr();
		tab_marginY = -document.all["tab_pgMrgMsr"].offsetTop;
  }
  return tab_marginY;
}

// Creates the hidden element necessary to measure the body's margins
function tab_createPgMrgMsr()
{
  document.body.insertAdjacentHTML('beforeEnd',
    '<div id="tab_pgMrgMsr" style="position:absolute;left:0;top:0;z-index:-1000;visibility:hidden">*</div>');
}

// Hides HTML select elements that are overlapping the given menu group 
function tab_hideSelectElements(group)
{
  if (tab_hideSelectElems && document.getElementsByTagName) 
  {
    var arrElements = document.getElementsByTagName('select'); 
    for (var i = 0; i < arrElements.length; i++) 
      if (tab_objectsOverlapping(document.all[group], arrElements[i]))
        arrElements[i].style.visibility = 'hidden';          
  }
}

// Restores all HTML select elements on the page 
function tab_restoreSelectElements()
{
  if (tab_hideSelectElems && document.getElementsByTagName) 
  {
    var arrElements = document.getElementsByTagName('select'); 
    for (var i = 0; i < arrElements.length; i++) 
      arrElements[i].style.visibility = 'visible'; 
  }
}

// Shows a windowed control overlay for the given group
function tab_showOverlay(group)
{
  if (!tab_overlayWindowed) return;
  var overid = group.id + "_over";
  if (!document.all[overid])
    document.body.insertAdjacentHTML("beforeEnd","<iframe id='" +overid+ "' src='javascript:void 0;' style='position:absolute;left:0px;top:0x;z-index:990;display:none' scrolling='no' frameborder='0'></iframe>");
  if (document.all[overid])
  {
    var overs = document.all[overid].style;
    overs.top = group.style.top;
    overs.left = group.style.left;
    overs.width = group.offsetWidth + (tab_shadowEnabled ? tab_shadowOffest : 0);
    overs.height = group.offsetHeight + (tab_shadowEnabled ? tab_shadowOffest : 0);
    overs.filter = 'progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)';
    overs.display = 'block';
  }
}

// Hides a windowed control overlay for the given group
function tab_hideOverlay(group)
{
  if (!tab_overlayWindowed) return;
  var overid = group.id + "_over";
  if (document.all[overid])
    document.all[overid].style.display = 'none';
}

// Whether the given objects are overlapping 
function tab_objectsOverlapping(obj1, obj2)
{
  var result = true; 
  var obj1Left = tab_pageX(obj1) - window.document.body.scrollLeft; 
  var obj1Top = tab_pageY(obj1) - window.document.body.scrollTop; 
  var obj1Right = obj1Left + obj1.offsetWidth; 
  var obj1Bottom = obj1Top + obj1.offsetHeight;
  var obj2Left = tab_pageX(obj2) - window.document.body.scrollLeft; 
  var obj2Top = tab_pageY(obj2) - window.document.body.scrollTop; 
  var obj2Right = obj2Left + obj2.offsetWidth; 
  var obj2Bottom = obj2Top + obj2.offsetHeight;
  
  if (obj1Right <= obj2Left || obj1Bottom <= obj2Top || 
      obj1Left >= obj2Right || obj1Top >= obj2Bottom) 
    result = false; 
  return result; 
}

// Creates a drop shadow for an object 
function tab_makeDropShadow(objName)
{
  if (tab_shadowEnabled) 
  {
    tab_shadows[objName] = new Array(); 
    for (var i = tab_shadowOffest; i > 0; i--)
    {
      var obj = document.all[objName]; 
      var rect = document.createElement('div');
      var rs = rect.style
      rs.position = 'absolute';
      rs.left = (obj.style.posLeft + i) + 'px';
      rs.top = (obj.style.posTop + i) + 'px';
      rs.width = obj.offsetWidth + 'px';
      rs.height = obj.offsetHeight + 'px';
      rs.zIndex = obj.style.zIndex - i;
      rs.backgroundColor = tab_shadowColor;
      var opacity = 1 - i / (i + 1);
      rs.filter = 'alpha(opacity=' + (100 * opacity) + ')';
      obj.insertAdjacentElement('afterEnd', rect);
      tab_shadows[objName][tab_shadows[objName].length] = rect; 
    }
  }
}

// Clears the drop shadow for the given object 
function tab_clearDropShadow(objName)
{
  if (tab_shadowEnabled) 
  {
    var curShadow; 
    for (var i = 0; i < tab_shadows[objName].length; i++)
    {
      curShadow = tab_shadows[objName][i]; 
      curShadow.style.filter = 'alpha(opacity=0)'; 
      curShadow.removeNode(true); 
    }
  }  
}

// Positions the menu based on the alignment, offsetX, and offsetY properties
function tab_positionMenu(menu, alignment, offsetX, offsetY)
{
  var scrlLeft = 0; 
  var scrlTop = 0;
  var clientW = window.document.body.clientWidth; 
  var clientH = window.document.body.clientHeight; 
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


var tab_expandedObjects = new Array();  // array of expanded groups 
var tab_expandCount = 0;                // expanded group count 

var tab_expandTimerID = 0;          // timer for the current expanding group 
var tab_collapseTimerID = 0;        // timer for the current collapsing group 
var tab_collapseAllTimerID = 0;     // timer for collapseAll
var tab_expandingGroup = '';        // current expanding group name 
var tab_collapsingGroup = '';       // current collapsing group name 
var tab_restoredGroup = '';         // group that got focus after collapseAll has been called
var tab_collapsingAll = false;      // whether the collapseAll command is pending 
var tab_curItem = '';               // current menu item 
var tab_hideSelectElems = true;     // whether to hide HTML select elements
var tab_overlayWindowed = false;    // whether to overlay windowed controls
var tab_shadows = new Array();      // used to hold shadow rectangles
var tab_shadowEnabled = false;      // whether shadow is enabled
var tab_shadowColor = '#777777';    // shadow color
var tab_shadowOffest = 4;           // shadow offset
var tab_contextUp = false;          // whether a context menu is up 
var tab_mac = false;								// whether the client is a Mac IE
var tab_marginX = false;						// Left page margin in pixels (only matters on Macs)
var tab_marginY = false;						// Top page margin in pixels (only matters on Macs)

