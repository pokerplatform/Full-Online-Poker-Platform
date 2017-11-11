
var dm=new dmc();function dmc()
{this.ComponentName='APNSoft Menu 1.5 client script.';this.Version='Version 1.5.11';this.Copyright='Copyright 2003-2005 APNSoft. All rights reserved.';this.ie=(document.all);this.n6=(document.getElementById&&!this.ie);this.mId='';this.tObj;this.mO=1;this.Lvl;this.tnDx=0;this.tnDy=0;this.oDr=1;this.tr='';this.Oms=new Array(10);this.ocM;this.ocD;this.ocMt=600;this.ocDt=300;this.a='';this.ao='';this.tr='';this.cdID='';this.smch=true;this.v=function(w){try{clearTimeout(dm.ocD);dm.ocD=null;clearTimeout(dm.ocM);dm.ocM=null;var cmId=dm.gmId(w);if((dm.mId!=cmId)&&(dm.mId!='')){dm.cAm();dm.rMnu(dm.mId);}
dm.mId=cmId;dm.dAo();dm.dTr();dm.Lvl=dm.cML(w);if(dm.Lvl==1){dm.rsDr();}
dm.mO=dm.gmM(dm.mId);dm.tObj=w;dm.uHmi(w);dm.cIt(w,'e');if(dm.smch==true){dm.Hv(w);}
var i;for(i=1;i<10;i++){if(dm.Oms[i]==dm.tObj.id+'p')
{return;}}
if((dm.mO!=1)||(dm.Lvl>1)){dm.ocD=setTimeout('dm.oChe()',dm.ocDt);}
else{dm.oChe();}}
catch(e)
{}}
this.u=function(w){try{clearTimeout(dm.ocD);dm.ocD=null;clearTimeout(dm.ocM);dm.ocM=null;dm.ocM=setTimeout('dm.cAm()',dm.ocMt);var i;for(i=1;i<10;i++){if(dm.Oms[i]==w.id+'p')
{return;}}}
catch(e)
{}}
this.oChe=function(){try{dm.cCl();dm.oCh(dm.tObj);}
catch(e){}}
this.oCh=function(w){var chOb=dm.Mko(w.id+'p');if(!chOb)return;dm.pzCh(w);var Obj=dm.mAro(chOb);for(k=0;k<Obj.length;k++)
{dm.uHvi(Obj[k]);}

if((dm.tr!='')&&(dm.dBv('ie55p')))
{dm.sDvt(chOb);}
else
{dm.sDvd();}
dm.Oms[dm.Lvl]=w.id+'p';}
this.sDvd=function(){try{var Obj=dm.Mko(dm.tObj.id+'p');Obj.style.filter='';if((!dm.dBv('op5p'))&&(!dm.dBv('saf'))){var Ifr=document.getElementById('dm_'+(dm.Lvl+1)+'f');Ifr.style.filter='';Ifr.style.height=Obj.offsetHeight;Ifr.style.width=Obj.offsetWidth;Ifr.style.top=Obj.style.top;Ifr.style.left=Obj.style.left;dm.sDv(Ifr);}
dm.sDv(Obj);}
catch(e)
{}}
this.sDvt=function(Dv){if(Dv){if(dm.Lvl==1&&(dm.mO==1)){dm.tr=dm.tr.replace('orientation=horizontal','orientation=vertical');dm.tr=dm.tr.replace('direction=right','direction=down');}
else if(dm.oDr==2){dm.tr=dm.tr.replace('motion=rightdown','motion=leftdown');}
Dv.style.filter=dm.tr;Dv.filters[0].Apply();dm.sDv(Dv);Dv.filters[0].Play();if((!dm.dBv('op5p'))&&(!dm.dBv('saf'))){var Ifr=document.getElementById('dm_'+(dm.Lvl+1)+'f');var pz1=dm.tr.indexOf('DXImageTransform.Microsoft.Shadow(');var pz2=dm.tr.indexOf('strength=');var Sd=0;if((pz1<pz2)&&(pz1>-1)){Sd=parseInt(dm.tr.substring(pz2+9));}
Ifr.style.width=Dv.offsetWidth-Sd;Ifr.style.height=Dv.offsetHeight-Sd;Ifr.style.top=Dv.style.top;Ifr.style.left=Dv.style.left;Ifr.style.filter=dm.tr;Ifr.filters[0].Apply();dm.sDv(Ifr);Ifr.filters[0].Play();}}}
this.rMnu=function(id){var Obj=dm.mAro(dm.Mko(id+'_0p'));for(k=0;k<Obj.length;k++)
{dm.uHvi(Obj[k]);}}
this.uHmi=function(w){var Obj=dm.mAr(w);for(k=0;k<Obj.length;k++)
{dm.uHvi(Obj[k]);}}
this.uHvi=function(w){if(w.id=='')return;if(w.className!='')
{dm.cIt(w,'d');}}
this.mAr=function(w){var Obj;cDv=dm.gCd(w);Obj=dm.mAro(cDv);return Obj;}
this.mAro=function(cDv){var ach=cDv.childNodes;var Obj;for(i=0;i<ach.length;i++){var ch=ach[i];ch=ch.childNodes[0].childNodes[0].childNodes[0].childNodes[0];if(ch.tagName=='TABLE'){Obj=ch.rows;if((Obj.length==1)&&(!Obj[0].id)){Obj=Obj[0].cells;return Obj;}
return Obj;}}}
this.cCl=function(){var Ifr;for(i=dm.Lvl;i<10;i++){dm.hDv(dm.Mko(dm.Oms[i]));dm.Oms[i]=undefined;if((!dm.dBv('op5p'))&&(!dm.dBv('saf'))){Ifr=document.getElementById('dm_'+(i+1)+'f');dm.hDv(Ifr);}}}
this.cAm=function(){try{var Ifr;for(i=1;i<10;i++){dm.hDv(dm.Mko(dm.Oms[i]));dm.Oms[i]=undefined;if((!dm.dBv('op5p'))&&(!dm.dBv('saf'))){Ifr=document.getElementById('dm_'+(i+1)+'f');dm.hDv(Ifr);}}
if(dm.mId!=''){dm.Lvl=1;var Obj=dm.mAro(dm.Mko(dm.mId+'_0p'));for(k=0;k<Obj.length;k++)
{dm.uHvi(Obj[k]);}}}
catch(e)
{}}
this.cML=function(w){var Lv=0;var cOb=w;var cId;var dPid='1';while(dPid!='0'){Lv++;cId=dm.gCd(cOb).id;if(Lv==1){if(dm.cdID!=cId){dm.smch=true;dm.cdID=cId;}
else
{dm.smch=false;}}
dPid=cId.substring(cId.lastIndexOf("_")+1,cId.length-1) 
cOb=dm.Mko(cId.substr(0,cId.length-1))}
return Lv;}
this.gCd=function(w){var dOb=w.parentNode;while(dOb.parentNode){if(dOb.tagName=='DIV')return dOb;dOb=dOb.parentNode;}
return null;}
this.dTr=function(){dm.tr='';var tr=eval(dm.mId+'L.'+dm.mId+'tr'); 
if(tr)
dm.tr=tr;}
this.gmM=function(id){return(eval(dm.mId+'L.'+id+'o'));}
this.Hv=function(w){var Obj;var Cdo;var mIt;var Cnt=dm.Lvl;var j,k;for(j=1;j<Cnt;j++){mIt=dm.Mko(dm.Oms[j].substr(0,dm.Oms[j].length-1));Cdo=dm.gCd(mIt);Obj=dm.mAro(Cdo);for(k=0;k<Obj.length;k++)
{dm.uHvi(Obj[k]);}
dm.cIt(mIt,'e');}}
this.gmId=function(w){var Id=w.id;return(Id.substring(0,Id.lastIndexOf('_')));}
this.cIt=function(w,Ind){var Obj;var Ncn;if(w.tagName=='TD'){Obj=w.childNodes[0];if(Obj.tagName=='IMG'){if((w.id+'i')==Obj.name){dm.sSr(w,Ind,1);return;}}
Ncn=w.className.substring(0,w.className.length-1)+Ind;if(w.className!=Ncn)w.className=Ncn;return;}
if(w.tagName=='TR'){Obj=w.childNodes[0].childNodes[0];if(!Obj){Obj=w.childNodes[1].childNodes[0];if(!Obj){Obj=w.childNodes[1]};}
if(!Obj)return;if(Obj.tagName=='IMG'){if((w.id+'i')==Obj.name){dm.sSr(w,Ind,2);return;}}
Ncn=w.className.substring(0,w.className.length-1)+Ind;if(w.className!=Ncn)w.className=Ncn;var IOC=eval(dm.mId+'L.'+dm.mId+'ioc');if(IOC){if(w.childNodes[0].className.indexOf('SubTd')==-1){if(Ind=='e'){w.childNodes[0].className=dm.mId+'MainTd_1';w.childNodes[1].className=dm.mId+'MainTd_2';w.childNodes[2].className=dm.mId+'MainTd_3';}
else{w.childNodes[0].className=dm.mId+'MainTd';w.childNodes[1].className=dm.mId+'MainTd';w.childNodes[2].className=dm.mId+'MainTd';}}
else{if(Ind=='e'){w.childNodes[0].className=dm.mId+'SubTd_1';w.childNodes[1].className=dm.mId+'SubTd_2';w.childNodes[2].className=dm.mId+'SubTd_3';}
else{w.childNodes[0].className=dm.mId+'SubTd';w.childNodes[1].className=dm.mId+'SubTd';w.childNodes[2].className=dm.mId+'SubTd';}}}
if(Ind=='e'){dm.sAr(w,dm.ao);return;}
if(Ind=='d'){dm.sAr(w,dm.a);return;}
return;}}
this.sSr=function(w,Ind,nm){if(nm==1)Srcs=w.childNodes[0];if(nm==2){Srcs=w.childNodes[0].childNodes[0]; 
if(dm.Op&&dm.Lvl>1)Srcs=document.all['dm_'+dm.Lvl+'f'].document.getElementById(w.id).childNodes[0].childNodes[0]; }
var io=Srcs.getAttribute('io');var iu=Srcs.getAttribute('iu');Src=Srcs.src;if(io){if(Ind=='e')
{nSr=Src.substr(0,Src.lastIndexOf("/")+1)+io;}
else
{nSr=Src.substr(0,Src.lastIndexOf("/")+1)+iu;}
if(nm==1)w.childNodes[0].src=nSr;if(nm==2)w.childNodes[0].childNodes[0].src=nSr;}}
this.sAr=function(w,Src){if(Src=='')return;var Obj=w.childNodes[2];var Ob3=Obj.childNodes[0];if(Ob3){if(Ob3.tagName=='FONT')
{Obj.innerHTML=Src;}
if(Ob3.tagName=='IMG'){if(Ob3.src.lastIndexOf('false')!=Ob3.src.length-5){Ob3.src=Src;}}}}
this.dAo=function(){var tr;tr=eval(dm.mId+'L.'+dm.mId+'a'); 
if(!tr)tr='';dm.a=tr;tr=eval(dm.mId+'L.'+dm.mId+'ao'); 
if(!tr)tr='';dm.ao=tr;}
this.trim=function(str){var s = new String(str);if(s=='')return s;s=s.replace(/^\s*/,'').replace(/\s*$/,'');return s;}
this.r=function(u,t){var v;var nh;u=dm.trim(u);t=dm.trim(t);try{var csp=eval(dm.mId+'L.'+dm.mId+'csp'); 
if(csp){eval(csp+'(\''+u+'\',\''+t+'\')');return;}}
catch(e){alert(dm.ComponentName+'\r\nError! Check Client Side Procedure!\r\nDescription: '+e.description+'.');return;}

if(u=='')return;if(t==''){t='_top';}
try
{v=open(u,t);}
catch(e){}}

this.rPb=function(w){var APB=eval(dm.mId+'L.'+dm.mId+'apb');if(APB)
{__doPostBack(dm.mId.replace("__",":"),w.id.replace("__",":"));}}

this.pzCh=function(w){var cOb=dm.Mko(w.id+'p');dm.dCr(w,cOb);}
this.dCr=function(w,cOb){var OvH=-5;var OvV=-4;var Ov=eval(dm.mId+'L.'+dm.mId+'ho');if(Ov!=null)OvH=Ov;Ov=eval(dm.mId+'L.'+dm.mId+'vo');if(Ov!=null)OvV=Ov;var cDw=cOb.offsetWidth;var cDh=cOb.offsetHeight;if(dm.dBv('op5p')){cDw=cOb.childNodes[0].offsetWidth;cDh=cOb.childNodes[0].offsetHeight;}
var wH=600;var wW=800;var dB=document.body;var stY;var stX;var scT=document.body.scrollTop;if(dm.ie){wH=dB.offsetHeight;wW=dB.offsetWidth;}
else if(dm.n6){wH=innerHeight;wW=innerWidth;}
var cObt=cOb.style;var cDo=dm.gCd(w);if(dm.Lvl==1&&dm.mO==1){stY=dm.pY(cDo)+cDo.offsetHeight;stY+=OvV;}
else{if(dm.dBv('saf')){var h1=w.childNodes[0];var h2=w.childNodes[1];if(h1.offsetHeight<h2.offsetHeight)h1=h2;stY=dm.pY(h1);}
else{stY=dm.pY(w);}
if((stY+cDh+8)>(wH+scT))
{stY=(wH+scT)-cDh-8;}}
cObt.top=stY;dm.tnDy=stY;if(!dm.cFt(w,cOb)){dm.rDr();}
if(!dm.cFt(w,cOb)){dm.rDr();}

if(dm.Lvl==1&&dm.mO==1){stX=dm.pX(w);if((wW-dm.pX(w)-30)<cDw){stX=wW-cDw-30;}}
if(dm.Lvl>1||dm.mO!=1){if(dm.oDr==1){stX=dm.pX(cDo)+cDo.childNodes[0].offsetWidth
if(!dm.Op){stX+=OvH;}}
if(dm.oDr==2){stX=dm.pX(cDo)-cDw;if(!dm.Op){stX-=OvH;}}}
cObt.left=stX;dm.tnDx=stX;}
this.rDr=function(){if(dm.oDr==1){dm.oDr=2;}
else{dm.oDr=1;};}
this.rsDr=function(){var dDd=eval(dm.mId+'L.'+dm.mId+'ed');if(dDd)
dm.oDr=dDd;}
this.dTr=function(){dm.tr='';var tr=eval(dm.mId+'L.'+dm.mId+'tr'); 
if(tr)
dm.tr=tr;}
this.cFt=function(w,cOb){var r=true;if(dm.ie){wW=document.body.offsetWidth;}
else if(dm.n6){wW=innerWidth;}
if((dm.Lvl==1)&&(dm.mO==1))return true;var cDo=dm.gCd(w);var CrDvPs=dm.pX(cDo);var cDw=cOb.offsetWidth;if(dm.dBv('op5p')){cDw=cOb.childNodes[0].offsetWidth;}
var crDw=cDo.childNodes[0].offsetWidth;if(dm.oDr==1){if((wW-(CrDvPs+crDw))<(cDw+30))
{r=false;}}
if(dm.oDr==2){if(CrDvPs<(cDw+10))
{r=false;}}
return r;}

this.Mko=function(n){var Ob;try{if(dm.ie)
{Ob=eval('document.all.'+n);}
if(dm.n6)
{Ob=eval('document.getElementById("'+n+'")')}}
catch(e)
{return null;}
return Ob;}
this.pX=function(w){var cl=0;if(w.offsetParent){while(w.offsetParent){cl+=w.offsetLeft
w=w.offsetParent;}}
else if(w.x)
cl+=w.x;return cl;}
this.pY=function(w){var ct=0;if(w.offsetParent){while(w.offsetParent){ct+=w.offsetTop;w=w.offsetParent;}}
else if(w.y)
ct+=w.y;return ct;}
this.sDv=function(w){if(w){w.style.display="block";w.style.visibility="visible";}}
this.hDv=function(w){if(w){w.style.display="";w.style.visibility="hidden";}}
this.dBv=function(nm){var mj = parseInt(navigator.appVersion);var ua=navigator.userAgent.toLowerCase();var op=(ua.indexOf("opera")!=-1);var op2=(ua.indexOf("opera 2")!=-1||ua.indexOf("opera/2")!=-1);var op3=(ua.indexOf("opera 3")!=-1||ua.indexOf("opera/3")!=-1);var op4=(ua.indexOf("opera 4")!=-1||ua.indexOf("opera/4")!=-1);var op5p=(op&&!op2&&!op3&&!op4);var ie=((ua.indexOf("msie")!=-1)&&(ua.indexOf("opera")==-1));var ie3=(ie&&(mj<4));var ie4=(ie&&(mj==4)&&(ua.indexOf("msie 4")!=-1));var ie5=(ie&&(mj==4)&&(ua.indexOf("msie 5.0")!=-1));var ie55p=(ie&&!ie3&&!ie4&&!ie5);var saf=((ua.indexOf('safari')!=-1)&&(ua.indexOf('mac')!=-1))?true:false;return(eval(nm));}}

