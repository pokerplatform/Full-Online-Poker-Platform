object FindPlayerForm: TFindPlayerForm
  Left = 404
  Top = 263
  AutoScroll = False
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'BikiniPoker - Find Player'
  ClientHeight = 117
  ClientWidth = 274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TTeLabel
    Left = 33
    Top = 60
    Width = 3
    Height = 13
    Performance = kspNoBuffer
    Color = clBtnFace
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    ThemeObject = 'label'
  end
  object PlayerIDLabel: TLabel
    Left = 29
    Top = 29
    Width = 52
    Height = 16
    Caption = 'PlayerID:'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object TeLabel1: TTeLabel
    Left = 56
    Top = 8
    Width = 3
    Height = 13
    Performance = kspNoBuffer
    Visible = False
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'default'
  end
  object PlayerIDEdit: TTeEdit
    Left = 96
    Top = 24
    Width = 153
    Height = 23
    Cursor = crIBeam
    Performance = kspDoubleBuffer
    OnKeyPress = PlayerIDEditKeyPress
    AutoSize = True
    BevelSides = [kbsLeft, kbsTop, kbsRight, kbsBottom]
    BevelInner = kbvLowered
    BevelOuter = kbvLowered
    BevelKind = kbkSingle
    BevelWidth = 1
    BorderWidth = 3
    PasswordKind = pkNone
    ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
    TabOrder = 0
    ThemeObject = 'default'
  end
  object FindButton: TTeButton
    Left = 29
    Top = 72
    Width = 75
    Height = 25
    Performance = kspDoubleBuffer
    OnClick = FindButtonClick
    BlackAndWhiteGlyph = False
    Caption = 'Find'
    ThemeObject = 'default'
    TabOrder = 1
    WordWrap = False
  end
  object CancelButton: TTeButton
    Left = 173
    Top = 72
    Width = 75
    Height = 25
    Performance = kspDoubleBuffer
    OnClick = CancelButtonClick
    BlackAndWhiteGlyph = False
    Caption = 'Cancel'
    ThemeObject = 'default'
    TabOrder = 2
    WordWrap = False
  end
  object TeForm: TTeForm
    Active = False
    Animation.EffectKind = '[ RANDOM ] - Random selection'
    BorderIcons = [kbiClose, kbiSystemMenu, kbiMinimize, kbiMaximize, kbiRollup, kbiTray]
    BorderStyle = kbsStandard
    Caption = 'BikiniPoker - Find Player'
    SystemMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
    TrayMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
    Performance = ksfpNoBuffer
    StayOnTop = False
    StretchBackground = False
    WindowState = kwsNormal
    OnMinimize = TeFormMinimize
    OnMaximize = TeFormMaximize
    ThemeObject = 'default'
  end
end
