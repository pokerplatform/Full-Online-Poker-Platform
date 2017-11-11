var aspnm_mainContextMenu = document.getElementById('_context_menu_'); 
var aspnm_activeContextMenu; 
var aspnm_contextMenus = new Array(); 
var aspnm_contextControls = new Array(); 
var aspnm_contextMenuCount = 0; 

document.onmouseup = function (evt)
{
  if (evt.button == 2)
  {
    var contextLeft; 
    var contextTop; 
    var contextMenu = aspnm_getContextMenu(evt); 
    if (contextMenu == null) return false; 
    
    contextLeft = evt.pageX; 
    if (contextLeft + contextMenu.offsetWidth > window.innerWidth) 
      contextLeft -= contextMenu.offsetWidth; 
    
    contextTop = evt.pageY; 
    if (contextTop + contextMenu.offsetHeight > window.innerHeight) 
      contextTop -= contextMenu.offsetHeight; 

    contextMenu.style.left = contextLeft; 
    contextMenu.style.top = contextTop; 
    aspnm_hideSelectElements(contextMenu.id); 
    if (aspnm_activeContextMenu != null) aspnm_hideContext(); 
    contextMenu.style.visibility = 'visible';     
    aspnm_activeContextMenu = contextMenu; 
    aspnm_contextUp = true; 
  }
  else
    aspnm_hideContext();
}

function aspnm_getContextMenu(evt)
{
  var contextMenu = null; 
  for (var i = 0; i < aspnm_contextMenus.length; i++)
  {
    if (aspnm_isMouseOnObject(aspnm_contextControls[i], evt)) 
      contextMenu = document.getElementById(aspnm_contextMenus[i]); 
  }
  
  if (contextMenu == null) contextMenu = aspnm_mainContextMenu; 
  return contextMenu; 
}

function aspnm_hideContext()
{
  if(aspnm_contextUp)
  {
    aspnm_activeContextMenu.style.visibility = 'hidden'; 
    aspnm_restoreSelectElements(); 
    aspnm_contextUp = false; 
  }
}

document.oncontextmenu = function (evt)
{
  return false; 
}
