var aspnm_mainContextMenu = document.all['_context_menu_']; 
var aspnm_activeContextMenu; 
var aspnm_contextMenus = new Array(); 
var aspnm_contextControls = new Array(); 
var aspnm_contextMenuCount = 0; 

function document.onmouseup()
{
  if (event.button == 2)
  {
    var contextLeft; 
    var contextTop; 
    var contextMenu = aspnm_getContextMenu(); 
    if (contextMenu == null) return false; 
    
    contextLeft = event.clientX + window.document.body.scrollLeft; 
    if (contextLeft + contextMenu.offsetWidth > window.document.body.clientWidth + window.document.body.scrollLeft) 
      contextLeft -= contextMenu.offsetWidth; 
    
    contextTop = event.clientY + window.document.body.scrollTop; 
    if (contextTop + contextMenu.offsetHeight > window.document.body.clientHeight + window.document.body.scrollTop) 
      contextTop -= contextMenu.offsetHeight; 

    contextMenu.style.left = contextLeft; 
    contextMenu.style.top = contextTop; 
    if (aspnm_activeContextMenu != null) aspnm_hideContext(false); 
    aspnm_hideSelectElements(contextMenu.id); 
    contextMenu.style.visibility = 'visible';     
    aspnm_activeContextMenu = contextMenu; 
    aspnm_contextUp = true; 
  }
  else
  {
    aspnm_hideContext(true);
  }
  
}

function aspnm_hideContext(restoreSelects)
{
  if (aspnm_contextUp && aspnm_restoredGroup == '')
  {
    aspnm_hideAllGroups(); 
    aspnm_activeContextMenu.style.visibility = 'hidden'; 
    aspnm_activeContextMenu = null; 
    if (restoreSelects) aspnm_restoreSelectElements(); 
    aspnm_contextUp = false; 
  }
}

function aspnm_getContextMenu()
{
  var contextMenu = null; 
  for (var i = 0; i < aspnm_contextMenus.length; i++)
  {
    if (aspnm_isMouseOnObject(aspnm_contextControls[i])) 
      contextMenu = document.all[aspnm_contextMenus[i]]; 
  }
  
  if (contextMenu == null) contextMenu = aspnm_mainContextMenu; 
  return contextMenu; 
}

function document.oncontextmenu()
{
  event.returnValue = false; 
  event.cancelBubble = true; 
  return false; 
}

