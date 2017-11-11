object RegisterNewUserForm: TRegisterNewUserForm
  Left = 389
  Top = 184
  AutoScroll = False
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'BikiniPoker-Register new user'
  ClientHeight = 307
  ClientWidth = 319
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object BackgroundPanel: TTeHeaderPanel
    Left = 0
    Top = 0
    Width = 319
    Height = 307
    Performance = kspNoBuffer
    Align = alClient
    AnimateRoll = False
    BevelWidth = 0
    BorderWidth = 0
    ButtonKind = kpbkRollUp
    Caption = 'BackgroundPanel'
    Rolled = False
    ParentRoll = False
    ShowBevel = False
    ShowButton = False
    ShowCaption = False
    ThemeObject = 'TranspPanel'
    NormalHeight = {00000000}
    object TeLabel1: TTeLabel
      Left = 49
      Top = 47
      Width = 46
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Player ID:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TeLabel2: TTeLabel
      Left = 47
      Top = 71
      Width = 49
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Password:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TeLabel3: TTeLabel
      Left = 17
      Top = 16
      Width = 165
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Please enter your registration info...'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'BoldLabel'
    end
    object TeLabel4: TTeLabel
      Left = 7
      Top = 95
      Width = 86
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Confirm password:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TeLabel5: TTeLabel
      Left = 43
      Top = 143
      Width = 51
      Height = 13
      Performance = kspNoBuffer
      Caption = 'First name:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TeLabel6: TTeLabel
      Left = 44
      Top = 167
      Width = 52
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Last name:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TeLabel7: TTeLabel
      Left = 53
      Top = 191
      Width = 44
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Location:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TeLabel8: TTeLabel
      Left = 75
      Top = 240
      Width = 21
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Sex:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TeLabel9: TTeLabel
      Left = 69
      Top = 119
      Width = 28
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Email:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TeLabel10: TTeLabel
      Left = 27
      Top = 215
      Width = 70
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Show location:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object PlayerIDEdit: TTeEdit
      Left = 102
      Top = 43
      Width = 210
      Height = 23
      Cursor = crIBeam
      Performance = kspNoBuffer
      OnKeyUp = EditKeyUp
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
      MaxLength = 11
      ParentFont = False
      PasswordKind = pkNone
      ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
      TabOrder = 0
      ThemeObject = 'default'
    end
    object PasswordEdit: TTeEdit
      Left = 102
      Top = 67
      Width = 210
      Height = 23
      Cursor = crIBeam
      Performance = kspNoBuffer
      OnKeyUp = EditKeyUp
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
      MaxLength = 30
      ParentFont = False
      PasswordKind = pkCircle
      ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
      TabOrder = 1
      ThemeObject = 'default'
    end
    object RegisterButton: TTeButton
      Left = 107
      Top = 271
      Width = 95
      Height = 25
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = RegisterButtonClick
      BlackAndWhiteGlyph = False
      Caption = 'Register'
      ThemeObject = 'default'
      TabOrder = 11
      WordWrap = False
    end
    object CancelButton: TTeButton
      Left = 214
      Top = 271
      Width = 95
      Height = 25
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = CancelButtonClick
      BlackAndWhiteGlyph = False
      Caption = 'Cancel'
      ThemeObject = 'default'
      TabOrder = 12
      WordWrap = False
    end
    object ConfirmEdit: TTeEdit
      Left = 102
      Top = 91
      Width = 210
      Height = 23
      Cursor = crIBeam
      Performance = kspNoBuffer
      OnKeyUp = EditKeyUp
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
      MaxLength = 30
      ParentFont = False
      PasswordKind = pkCircle
      ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
      TabOrder = 2
      ThemeObject = 'default'
    end
    object FirstNameEdit: TTeEdit
      Left = 102
      Top = 139
      Width = 210
      Height = 23
      Cursor = crIBeam
      Performance = kspNoBuffer
      OnKeyUp = EditKeyUp
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
      MaxLength = 30
      ParentFont = False
      PasswordKind = pkNone
      ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
      TabOrder = 4
      ThemeObject = 'default'
    end
    object LastNameEdit: TTeEdit
      Left = 102
      Top = 163
      Width = 210
      Height = 23
      Cursor = crIBeam
      Performance = kspNoBuffer
      OnKeyUp = EditKeyUp
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
      MaxLength = 30
      ParentFont = False
      PasswordKind = pkNone
      ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
      TabOrder = 5
      ThemeObject = 'default'
    end
    object LocationEdit: TTeEdit
      Left = 102
      Top = 187
      Width = 210
      Height = 23
      Cursor = crIBeam
      Performance = kspNoBuffer
      OnKeyUp = EditKeyUp
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
      MaxLength = 25
      ParentFont = False
      PasswordKind = pkNone
      ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
      TabOrder = 6
      ThemeObject = 'default'
    end
    object MaleRadioButton: TTeRadioButton
      Left = 106
      Top = 237
      Width = 49
      Height = 20
      Performance = kspNoBuffer
      Caption = 'Male'
      Alignment = kalLeftJustify
      Checked = True
      GroupIndex = 2
      Spacing = 5
      ThemeObject = 'BlackRadioButton'
      TabOrder = 9
      TabStop = True
      WordWrap = False
    end
    object FemaleRadioButton: TTeRadioButton
      Left = 160
      Top = 237
      Width = 56
      Height = 20
      Performance = kspNoBuffer
      Caption = 'Female'
      Alignment = kalLeftJustify
      Checked = False
      GroupIndex = 2
      Spacing = 5
      ThemeObject = 'BlackRadioButton'
      TabOrder = 10
      WordWrap = False
    end
    object EMailEdit: TTeEdit
      Left = 102
      Top = 115
      Width = 210
      Height = 23
      Cursor = crIBeam
      Performance = kspNoBuffer
      OnKeyUp = EditKeyUp
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
      MaxLength = 100
      ParentFont = False
      PasswordKind = pkNone
      ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
      TabOrder = 3
      ThemeObject = 'default'
    end
    object LocationYesRadioButton: TTeRadioButton
      Left = 106
      Top = 212
      Width = 42
      Height = 20
      Performance = kspNoBuffer
      Caption = 'Yes'
      Alignment = kalLeftJustify
      Checked = True
      GroupIndex = 1
      Spacing = 5
      ThemeObject = 'BlackRadioButton'
      TabOrder = 7
      TabStop = True
      WordWrap = False
    end
    object LocationNoRadioButton: TTeRadioButton
      Left = 160
      Top = 212
      Width = 120
      Height = 20
      Performance = kspNoBuffer
      Caption = 'No, make me private'
      Alignment = kalLeftJustify
      Checked = False
      GroupIndex = 1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Spacing = 5
      ThemeObject = 'BlackRadioButton'
      TabOrder = 8
      WordWrap = False
    end
  end
end
