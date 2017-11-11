var aspnm_floatOffsetX = _floating_offsetX; 
var aspnm_floatOffsetY = _floating_offsetY;
var aspnm_floatAlignment = _floating_alignment; 
var aspnm_floatingMenu = _floating_menu_; 
var aspnm_floatingTopGroup = _main_group_; 
var oFloatingMenu = document.getElementById(aspnm_floatingMenu); 

aspnm_adjustMenu(); 
oFloatingMenu.style.visibility = 'visible'; 
var aspnm_intervalID = setInterval(aspnm_adjustMenu, 250); 

function aspnm_adjustMenu()
{
  aspnm_positionMenu(document.getElementById(aspnm_floatingMenu), aspnm_floatAlignment, aspnm_floatOffsetX, aspnm_floatOffsetY); 
}
