object ProcessForm: TProcessForm
  Left = 113
  Top = 96
  AutoScroll = False
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'Process'
  ClientHeight = 580
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object ShockwaveFlash: TShockwaveFlash
    Left = 0
    Top = 0
    Width = 784
    Height = 552
    TabOrder = 0
    OnFSCommand = ShockwaveFlashFSCommand
    ControlData = {
      6755665500030000075100000D39000008000200000000000800020000000000
      080002000000000008000E000000570069006E0064006F00770000000B00FFFF
      0B00FFFF08000A0000004800690067006800000008000200000000000B00FFFF
      080002000000000008000E00000061006C007700610079007300000008001000
      0000530068006F00770041006C006C0000000B0000000B000000080002000000
      0000080002000000000008000200000000000D00000000000000000000000000
      000000000B000100}
  end
  object TeForm: TTeForm
    Active = False
    Animation.EffectKind = '[ RANDOM ] - Random selection'
    BorderIcons = [kbiClose, kbiSystemMenu, kbiMinimize, kbiMaximize, kbiRollup, kbiTray]
    BorderStyle = kbsStandard
    Caption = 'Process'
    SystemMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
    TrayMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
    Performance = ksfpNoBuffer
    StayOnTop = False
    StretchBackground = False
    WindowState = kwsNormal
    ThemeObject = 'default'
    Left = 16
    Top = 16
  end
end
