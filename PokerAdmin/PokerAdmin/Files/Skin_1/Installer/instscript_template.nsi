;start file

!macro BIMAGE IMAGE PARMS
	Push $0
	GetTempFileName $0
	File /oname=$0 "${IMAGE}"
	SetBrandingImage ${PARMS} $0
	Delete $0
	Pop $0
!macroend


Name "WinstonPoker"

#outfile "WinstonPokerInst.exe"

;SetCompressor bzip2

; Install dir
InstallDir "$PROGRAMFILES\WinstonPoker"

LicenseBkColor FFFFFF
LicenseText "Terms of use"
LicenseData "images\license.txt"

Page license in.instImage
Page directory in.instImage
Page instfiles

DirText "Select folder to install"

AddBrandingImage left 112

Function in.instImage
	!insertmacro BIMAGE "images\logo.bmp" /RESIZETOFIT
FunctionEnd

Function .onUserAbort
   MessageBox MB_YESNO "Do you really want to quit installation?" IDYES NoCancelAbort
     Abort ; causes installer to not quit.
   NoCancelAbort:
FunctionEnd

Function .onInit
#   MessageBox MB_YESNO "Do you accept the terms of use?$\nTerms can be found here:  http://www.arkadium.com/terms.htm" IDYES AgreeWithTerms
#     Abort ; causes installer to quit.
#   AgreeWithTerms:   
#   MessageBox MB_YESNO "Are you over 18?" IDYES Over18
#     Abort ; causes installer to quit.
#   Over18:
FunctionEnd


Function .onInstSuccess
	Exec "$INSTDIR\WinstonPoker.exe" ; view readme or whatever, if you want.
FunctionEnd


Function un.onInit
    MessageBox MB_YESNO "Are you sure you want to remove WinstonPoker from your computer?" IDYES NoAbort
      Abort ; causes uninstaller to quit.
    NoAbort:
FunctionEnd

Function InstallFlashPlayer
  IfFileExists "$SYSDIR\Macromed\Flash\flash.ocx" FileExists
	  CreateDirectory "$SYSDIR\Macromed\Flash"
	  SetOutPath "$SYSDIR\Macromed\Flash"
	  File "..\flash.ocx"
  FileExists:
	  Exec 'regsvr32.exe /s "$SYSDIR\Macromed\Flash\flash.ocx"'
FunctionEnd

Section "WinstonPoker Program Files" SecCopyUI

; checking flash player version

  GetDllVersion "$SYSDIR\Macromed\Flash\$0" $R0 $R1
  IntOp $R2 $R0 / 0x00010000
  IntOp $R3 $R0 & 0x0000FFFF
  IntOp $R4 $R1 / 0x00010000
  IntOp $R5 $R1 & 0x0000FFFF

  StrCmp $R2 "7" +2
  Call "InstallFlashPlayer" ;installing flash player version 7
  
  SetOutPath "$INSTDIR"
  
File "..\WinstonPoker.exe"


  CreateDirectory "$INSTDIR\Files"
  SetOutPath "$INSTDIR\Files"


File "..\filelist.xml"


  
  SetOutPath "$INSTDIR"
  WriteUninstaller "uninstall.exe"

;---Writing Settings Section
  WriteRegStr HKCU "SOFTWARE\WinstonPoker\Settings" "port" "4001"
  WriteRegStr HKCU "SOFTWARE\WinstonPoker\Settings" "host" "212.1.89.72"
  WriteRegStr HKCU "SOFTWARE\WinstonPoker\Settings" "AffiliateID" ${AffID}

;---Writing Uninstall Section
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WinstonPoker" "DisplayName" "WinstonPoker"
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WinstonPoker" "UninstallString" "$INSTDIR\uninstall.exe"
  
  CreateShortCut "$DESKTOP\WinstonPoker.lnk" "http://212.1.89.72/arkadiumautologin/default.aspx?params=manual"

; installs the start menu shortcuts
  CreateDirectory "$SMPROGRAMS\WinstonPoker"
  CreateShortCut "$SMPROGRAMS\WinstonPoker\WinstonPoker.lnk" "http://212.1.89.72/arkadiumautologin/default.aspx?params=manual"
  CreateShortCut "$SMPROGRAMS\WinstonPoker\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  
SectionEnd


; special uninstall section.

Section "Uninstall"

  !insertmacro BIMAGE "images\logo.bmp" /RESIZETOFIT
  
  ; DELETE FILES from INSTDIR\files\

Delete "$INSTDIR\files\filelist.xml"


  Delete "$INSTDIR\files\download\*.*"
  RMDir "$INSTDIR\files\download"
  RMDir "$INSTDIR\files"


  ; DELETE FILES from INSTDIR\

Delete "$INSTDIR\WinstonPoker.exe"

  
  ; Remove Application files
  Delete "$INSTDIR\statistics*.*"
  Delete "$INSTDIR\WinstonPoker*.*"

  ; MUST REMOVE UNINSTALLER TOO
  Delete "$INSTDIR\uninstall.exe"

  ; REMOVING INSTALLATION FOLDER  
  RMDir "$INSTDIR"
  
  ; REMOVING DESKTOP SHORCUT
  Delete "$DESKTOP\WinstonPoker.lnk"

  ; REMOVING START MENU FOLDER
  Delete "$SMPROGRAMS\WinstonPoker\*.*"
  RMDir "$SMPROGRAMS\WinstonPoker"
  
  ; REMOVING REGISTRY KEYS
  DeleteRegKey HKCU "SOFTWARE\WinstonPoker"
  DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WinstonPoker"
  
SectionEnd

;eof