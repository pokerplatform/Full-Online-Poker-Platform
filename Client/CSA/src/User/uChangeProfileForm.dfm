object ChangeProfileForm: TChangeProfileForm
  Left = 260
  Top = 175
  AutoScroll = False
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'BikiniPoker-Change profile'
  ClientHeight = 227
  ClientWidth = 304
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
  object BackgroundPanel: TTeHeaderPanel
    Left = 0
    Top = 0
    Width = 304
    Height = 227
    Performance = kspNoBuffer
    Align = alClient
    AnimateRoll = False
    BevelWidth = 0
    BorderWidth = 0
    ButtonKind = kpbkRollUp
    Rolled = False
    ParentRoll = False
    ShowBevel = False
    ShowButton = False
    ShowCaption = False
    ThemeObject = 'TranspPanel'
    NormalHeight = {00000000}
    object TeLabel1: TTeLabel
      Left = 32
      Top = 40
      Width = 46
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Player ID:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TeLabel4: TTeLabel
      Left = 8
      Top = 18
      Width = 120
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Please update your info...'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'BoldLabel'
    end
    object TeLabel6: TTeLabel
      Left = 26
      Top = 64
      Width = 51
      Height = 13
      Performance = kspNoBuffer
      Caption = 'First name:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TeLabel7: TTeLabel
      Left = 27
      Top = 88
      Width = 52
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Last name:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TeLabel8: TTeLabel
      Left = 36
      Top = 112
      Width = 44
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Location:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TeLabel9: TTeLabel
      Left = 58
      Top = 161
      Width = 21
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Sex:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TeLabel11: TTeLabel
      Left = 10
      Top = 137
      Width = 70
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Show location:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object PlayerIDLabel: TTeLabel
      Left = 87
      Top = 40
      Width = 43
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Player ID'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'BoldLabel'
    end
    object SaveButton: TTeButton
      Left = 86
      Top = 189
      Width = 100
      Height = 25
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = SaveButtonClick
      BlackAndWhiteGlyph = False
      Caption = 'Save'
      ThemeObject = 'default'
      TabOrder = 7
      WordWrap = False
    end
    object CancelButton: TTeButton
      Left = 195
      Top = 189
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
      Left = 85
      Top = 60
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
      TabOrder = 0
      ThemeObject = 'default'
    end
    object LastNameEdit: TTeEdit
      Tag = 50
      Left = 85
      Top = 84
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
      TabOrder = 1
      ThemeObject = 'default'
    end
    object LocationEdit: TTeEdit
      Tag = 255
      Left = 85
      Top = 108
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
      MaxLength = 20
      ParentFont = False
      PasswordKind = pkNone
      ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
      TabOrder = 2
      ThemeObject = 'default'
    end
    object MaleRadioButton: TTeRadioButton
      Left = 89
      Top = 158
      Width = 49
      Height = 20
      Performance = kspNoBuffer
      Caption = 'Male'
      Alignment = kalLeftJustify
      Checked = True
      GroupIndex = 3
      Spacing = 5
      ThemeObject = 'default'
      TabOrder = 5
      TabStop = True
      WordWrap = False
    end
    object FemaleRadioButton: TTeRadioButton
      Left = 140
      Top = 158
      Width = 56
      Height = 20
      Performance = kspNoBuffer
      Caption = 'Female'
      Alignment = kalLeftJustify
      Checked = False
      GroupIndex = 3
      Spacing = 5
      ThemeObject = 'default'
      TabOrder = 6
      WordWrap = False
    end
    object LocationYesRadioButton: TTeRadioButton
      Left = 89
      Top = 134
      Width = 42
      Height = 20
      Performance = kspNoBuffer
      Caption = 'Yes'
      Alignment = kalLeftJustify
      Checked = True
      GroupIndex = 2
      Spacing = 5
      ThemeObject = 'default'
      TabOrder = 3
      TabStop = True
      WordWrap = False
    end
    object LocationNoRadioButton: TTeRadioButton
      Left = 140
      Top = 134
      Width = 120
      Height = 20
      Performance = kspNoBuffer
      Caption = 'No, make me private'
      Alignment = kalLeftJustify
      Checked = False
      GroupIndex = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Spacing = 5
      ThemeObject = 'default'
      TabOrder = 4
      WordWrap = False
    end
  end
end
