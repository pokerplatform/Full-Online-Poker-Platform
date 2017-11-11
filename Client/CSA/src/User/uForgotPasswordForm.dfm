object ForgotPasswordForm: TForgotPasswordForm
  Left = 305
  Top = 216
  ActiveControl = PlayerIDEdit
  AutoScroll = False
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'BikiniPoker-Forgot password'
  ClientHeight = 221
  ClientWidth = 276
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object TeLabel1: TTeLabel
    Left = 13
    Top = 43
    Width = 46
    Height = 13
    Performance = kspNoBuffer
    Caption = 'Player ID:'
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'Label'
  end
  object TeLabel3: TTeLabel
    Left = 9
    Top = 12
    Width = 200
    Height = 13
    Performance = kspNoBuffer
    Caption = 'Please enter your info to send it to admin...'
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'BoldLabel'
  end
  object TeLabel5: TTeLabel
    Left = 7
    Top = 67
    Width = 51
    Height = 13
    Performance = kspNoBuffer
    Caption = 'First name:'
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'Label'
  end
  object TeLabel6: TTeLabel
    Left = 8
    Top = 91
    Width = 52
    Height = 13
    Performance = kspNoBuffer
    Caption = 'Last name:'
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'Label'
  end
  object TeLabel7: TTeLabel
    Left = 17
    Top = 112
    Width = 44
    Height = 13
    Performance = kspNoBuffer
    Caption = 'Location:'
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'Label'
  end
  object TeLabel8: TTeLabel
    Left = 39
    Top = 164
    Width = 21
    Height = 13
    Performance = kspNoBuffer
    Caption = 'Sex:'
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'Label'
  end
  object TeLabel9: TTeLabel
    Left = 33
    Top = 139
    Width = 28
    Height = 13
    Performance = kspNoBuffer
    Caption = 'Email:'
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'Label'
  end
  object PlayerIDEdit: TTeEdit
    Tag = 20
    Left = 68
    Top = 39
    Width = 205
    Height = 23
    Cursor = crIBeam
    Performance = kspNoBuffer
    OnKeyPress = LocationEditKeyPress
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
    ParentFont = False
    PasswordKind = pkNone
    ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
    TabOrder = 0
    ThemeObject = 'default'
  end
  object SaveButton: TTeButton
    Left = 37
    Top = 194
    Width = 100
    Height = 25
    Cursor = crHandPoint
    Performance = kspDoubleBuffer
    OnClick = SaveButtonClick
    BlackAndWhiteGlyph = False
    Caption = 'Send'
    ThemeObject = 'default'
    TabOrder = 7
    WordWrap = False
  end
  object CancelButton: TTeButton
    Left = 146
    Top = 194
    Width = 100
    Height = 25
    Cursor = crHandPoint
    Performance = kspDoubleBuffer
    OnClick = CancelButtonClick
    BlackAndWhiteGlyph = False
    Caption = 'Cancel'
    ThemeObject = 'default'
    TabOrder = 8
    WordWrap = False
  end
  object FirstNameEdit: TTeEdit
    Tag = 50
    Left = 68
    Top = 63
    Width = 205
    Height = 23
    Cursor = crIBeam
    Performance = kspNoBuffer
    OnKeyPress = LocationEditKeyPress
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
    ParentFont = False
    PasswordKind = pkNone
    ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
    TabOrder = 1
    ThemeObject = 'default'
  end
  object LastNameEdit: TTeEdit
    Tag = 50
    Left = 68
    Top = 87
    Width = 205
    Height = 23
    Cursor = crIBeam
    Performance = kspNoBuffer
    OnKeyPress = LocationEditKeyPress
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
    ParentFont = False
    PasswordKind = pkNone
    ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
    TabOrder = 2
    ThemeObject = 'default'
  end
  object LocationEdit: TTeEdit
    Tag = 255
    Left = 68
    Top = 111
    Width = 205
    Height = 23
    Cursor = crIBeam
    Performance = kspNoBuffer
    OnKeyPress = LocationEditKeyPress
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
    ParentFont = False
    PasswordKind = pkNone
    ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
    TabOrder = 3
    ThemeObject = 'default'
  end
  object MaleRadioButton: TTeRadioButton
    Left = 68
    Top = 162
    Width = 49
    Height = 20
    Performance = kspNoBuffer
    Caption = 'Male'
    Alignment = kalLeftJustify
    Checked = True
    GroupIndex = 1
    Spacing = 5
    ThemeObject = 'default'
    TabOrder = 5
    TabStop = True
    WordWrap = False
  end
  object FemaleRadioButton: TTeRadioButton
    Left = 118
    Top = 162
    Width = 56
    Height = 20
    Performance = kspNoBuffer
    Caption = 'Female'
    Alignment = kalLeftJustify
    Checked = False
    GroupIndex = 1
    Spacing = 5
    ThemeObject = 'default'
    TabOrder = 6
    WordWrap = False
  end
  object EMailEdit: TTeEdit
    Tag = 255
    Left = 68
    Top = 135
    Width = 205
    Height = 23
    Cursor = crIBeam
    Performance = kspNoBuffer
    OnKeyUp = EMailEditKeyUp
    OnKeyPress = LocationEditKeyPress
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
    ParentFont = False
    PasswordKind = pkNone
    ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
    TabOrder = 4
    ThemeObject = 'default'
  end
end
