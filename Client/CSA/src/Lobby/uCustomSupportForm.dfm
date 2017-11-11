object CustomSupportForm: TCustomSupportForm
  Left = 335
  Top = 200
  AutoScroll = False
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'BikiniPoker-Custom support'
  ClientHeight = 185
  ClientWidth = 430
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TeLabel2: TTeLabel
    Left = 10
    Top = 39
    Width = 72
    Height = 13
    Performance = kspNoBuffer
    Caption = 'Message body:'
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'Label'
  end
  object TeLabel1: TTeLabel
    Left = 10
    Top = 15
    Width = 39
    Height = 13
    Performance = kspNoBuffer
    Caption = 'Subject:'
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'Label'
  end
  object SubjectEdit: TTeEdit
    Left = 61
    Top = 11
    Width = 359
    Height = 23
    Cursor = crIBeam
    Performance = kspNoBuffer
    AutoSize = True
    BevelSides = [kbsLeft, kbsTop, kbsRight, kbsBottom]
    BevelInner = kbvLowered
    BevelOuter = kbvLowered
    BevelKind = kbkSingle
    BevelWidth = 1
    BorderWidth = 3
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxLength = 150
    ParentFont = False
    PasswordKind = pkNone
    ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
    TabOrder = 0
    ThemeObject = 'default'
  end
  object SendButton: TTeButton
    Left = 261
    Top = 154
    Width = 75
    Height = 23
    Cursor = crHandPoint
    Performance = kspDoubleBuffer
    OnClick = SendButtonClick
    BlackAndWhiteGlyph = False
    Caption = 'Send'
    ThemeObject = 'default'
    TabOrder = 1
    WordWrap = False
  end
  object MessageMemo: TTeMemo
    Left = 10
    Top = 56
    Width = 411
    Height = 90
    MaxLength = 8000
    TabOrder = 2
    ThemeObject = 'default'
  end
  object CancelButton: TTeButton
    Left = 345
    Top = 154
    Width = 75
    Height = 23
    Cursor = crHandPoint
    Performance = kspDoubleBuffer
    OnClick = CancelButtonClick
    BlackAndWhiteGlyph = False
    Caption = 'Cancel'
    ThemeObject = 'default'
    TabOrder = 5
    WordWrap = False
  end
end
