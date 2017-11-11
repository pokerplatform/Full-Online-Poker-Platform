
// ASP.NET Menu global variables ------------------------------------------------------------------
var aspnm_expandedObjects = new Array();  // array of expanded groups 
var aspnm_expandCount = 0;                // expanded group count 

var aspnm_expandTimerID = 0;          // timer for the current expanding group 
var aspnm_collapseTimerID = 0;        // timer for the current collapsing group 
var aspnm_collapseAllTimerID = 0;     // timer for collapseAll
var aspnm_expandingGroup = '';        // current expanding group name 
var aspnm_collapsingGroup = '';       // current collapsing group name 
var aspnm_restoredGroup = '';         // group that got focus after collapseAll has been called
var aspnm_collapsingAll = false;      // whether the collapseAll command is pending 
var aspnm_curItem = '';               // current menu item 
var aspnm_hideSelectElems = true;     // whether to hide HTML select elements
var aspnm_overlayWindowed = false;    // whether to overlay windowed controls
var aspnm_shadows = new Array();      // used to hold shadow rectangles
var aspnm_shadowEnabled = false;      // whether shadow is enabled
var aspnm_shadowColor = '#777777';    // shadow color
var aspnm_shadowOffest = 4;           // shadow offset
var aspnm_contextUp = false;          // whether a context menu is up 
var aspnm_mac = false;								// whether the client is a Mac IE
var aspnm_marginX = false;						// Left page margin in pixels (only matters on Macs)
var aspnm_marginY = false;						// Top page margin in pixels (only matters on Macs)