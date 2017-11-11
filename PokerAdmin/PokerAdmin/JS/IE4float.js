var aspnm_floatOffsetX = _floating_offsetX; 
var aspnm_floatOffsetY = _floating_offsetY;
var aspnm_floatAlignment = _floating_alignment; 
var aspnm_floatingMenu = _floating_menu_; 
var aspnm_floatingTopGroup = _main_group_; 

aspnm_adjustMenu(); 
document.all[aspnm_floatingMenu].style.visibility = 'visible'; 

function aspnm_adjustMenu()
{
  aspnm_positionFloatingMenu(document.all[aspnm_floatingMenu], aspnm_floatAlignment, aspnm_floatOffsetX, aspnm_floatOffsetY); 
}

function window.onscroll()
{
  aspnm_adjustMenu(); 
}

function window.onresize()
{
  aspnm_adjustMenu(); 
}

// Positions the floating menu based on the alignment, offsetX, and offsetY properties
function aspnm_positionFloatingMenu(menu, alignment, offsetX, offsetY)
{
  var scrlLeft = window.document.body.scrollLeft; 
  var scrlTop = window.document.body.scrollTop;
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
