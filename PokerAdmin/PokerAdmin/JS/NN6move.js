var aspnm_NstartX = 0; 
var aspnm_NstartY = 0; 
var aspnm_startX = 0; 
var aspnm_startY = 0; 
var aspnm_dragNavigator = null; 

function aspnm_startDragging(navigator, evt)
{
  aspnm_dragNavigator = document.getElementById(navigator); 
  aspnm_dragging = true; 
  aspnm_NstartX = parseInt(aspnm_dragNavigator.style.left); 
  aspnm_NstartY = parseInt(aspnm_dragNavigator.style.top); 
  aspnm_startX = evt.pageX; 
  aspnm_startY = evt.pageY; 
}

function aspnm_stopDragging(evt)
{
  aspnm_dragging = false; 
  if (_is_floating_menu_)
  {
    aspnm_floatOffsetX += evt.pageX - aspnm_startX; 
    aspnm_floatOffsetY += evt.pageY - aspnm_startY;
  }
}

document.onmousemove = function (evt)
{
  if (aspnm_dragging)
  {
    aspnm_dragNavigator.style.left = aspnm_NstartX + (evt.pageX - aspnm_startX); 
    aspnm_dragNavigator.style.top = aspnm_NstartY + (evt.pageY - aspnm_startY);    
    evt.preventDefault(); 
    return false; 
  }
}
