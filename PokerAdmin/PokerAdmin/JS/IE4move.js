var aspnm_dragging = false; 
var aspnm_NstartX = 0; 
var aspnm_NstartY = 0; 
var aspnm_startX = 0; 
var aspnm_startY = 0; 
var aspnm_dragNavigator = null; 

function aspnm_startDragging(navigator)
{
  aspnm_dragNavigator = document.all[navigator]; 
  aspnm_dragging = true; 
  aspnm_NstartX = parseInt(aspnm_dragNavigator.style.left); 
  aspnm_NstartY = parseInt(aspnm_dragNavigator.style.top); 
  aspnm_startX = event.clientX; 
  aspnm_startY = event.clientY; 
}

function aspnm_stopDragging()
{
  aspnm_dragging = false; 
  if (_is_floating_menu_)
  {
    aspnm_floatOffsetX += event.clientX - aspnm_startX; 
    aspnm_floatOffsetY += event.clientY - aspnm_startY;
  }
}

function document.onmousemove()
{
  if (aspnm_dragging)
  {
    aspnm_dragNavigator.style.left = aspnm_NstartX + (event.clientX - aspnm_startX); 
    aspnm_dragNavigator.style.top = aspnm_NstartY + (event.clientY - aspnm_startY);    
    return false; 
  }
}
