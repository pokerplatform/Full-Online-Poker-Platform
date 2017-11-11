;start file

!macro BIMAGE IMAGE PARMS
	Push $0
	GetTempFileName $0
	File /oname=$0 "${IMAGE}"
	SetBrandingImage ${PARMS} $0
	Delete $0
	Pop $0
!macroend


Name "BikiniPoker"

#outfile "BikiniPokerInst.exe"

;SetCompressor bzip2

; Install dir
InstallDir "$PROGRAMFILES\BikiniPoker"

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
	Exec "$INSTDIR\BikiniPoker.exe" ; view readme or whatever, if you want.
FunctionEnd


Function un.onInit
    MessageBox MB_YESNO "Are you sure you want to remove BikiniPoker from your computer?" IDYES NoAbort
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

Section "BikiniPoker Program Files" SecCopyUI

; checking flash player version

  GetDllVersion "$SYSDIR\Macromed\Flash\$0" $R0 $R1
  IntOp $R2 $R0 / 0x00010000
  IntOp $R3 $R0 & 0x0000FFFF
  IntOp $R4 $R1 / 0x00010000
  IntOp $R5 $R1 & 0x0000FFFF

  StrCmp $R2 "7" +2
  Call "InstallFlashPlayer" ;installing flash player version 7
  
  SetOutPath "$INSTDIR"
  
File "..\BikiniPoker.exe"


  CreateDirectory "$INSTDIR\Files"
  SetOutPath "$INSTDIR\Files"


File "..\filelist.xml"


  
  SetOutPath "$INSTDIR"
  WriteUninstaller "uninstall.exe"

;---Writing Settings Section
  WriteRegStr HKCU "SOFTWARE\BikiniPoker\Settings" "ssl" "0"
  WriteRegStr HKCU "SOFTWARE\BikiniPoker\Settings" "port" "4001"
  WriteRegStr HKCU "SOFTWARE\BikiniPoker\Settings" "host" "127.0.0.1"
  WriteRegStr HKCU "SOFTWARE\BikiniPoker\Settings" "AffiliateID" ${AffID}

;---Writing Uninstall Section
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\BikiniPoker" "DisplayName" "BikiniPoker"
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\BikiniPoker" "UninstallString" "$INSTDIR\uninstall.exe"
  
; installs the start menu shortcuts
  CreateDirectory "$SMPROGRAMS\BikiniPoker"
  CreateShortCut "$SMPROGRAMS\BikiniPoker\BikiniPoker.exe"
  CreateShortCut "$SMPROGRAMS\BikiniPoker\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  
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

Delete "$INSTDIR\BikiniPoker.exe"

  
  ; Remove Application files
  Delete "$INSTDIR\statistics*.*"
  Delete "$INSTDIR\BikiniPoker*.*"

  ; MUST REMOVE UNINSTALLER TOO
  Delete "$INSTDIR\uninstall.exe"

  ; REMOVING INSTALLATION FOLDER  
  RMDir "$INSTDIR"
  
  ; REMOVING DESKTOP SHORCUT
  Delete "$DESKTOP\BikiniPoker.lnk"

  ; REMOVING START MENU FOLDER
  Delete "$SMPROGRAMS\BikiniPoker\*.*"
  RMDir "$SMPROGRAMS\BikiniPoker"
  
  ; REMOVING REGISTRY KEYS
  DeleteRegKey HKCU "SOFTWARE\BikiniPoker"
  DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\BikiniPoker"
  
SectionEnd

;eof