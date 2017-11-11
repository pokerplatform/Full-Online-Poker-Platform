object ChangePasswordForm: TChangePasswordForm
  Left = 331
  Top = 203
  AutoScroll = False
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'BikiniPoker-Change password'
  ClientHeight = 246
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
    Left = 8
    Top = 168
    Width = 264
    Height = 46
    Performance = kspNoBuffer
    AutoSize = False
    Caption = 
      'To change your password, you must enter your current password in' +
      ' the top box, then enter your new password twice (to confirm it)' +
      '.'
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'Label'
    WordWrap = True
  end
  object TeGroupBox1: TTeGroupBox
    Left = 10
    Top = 8
    Width = 261
    Height = 153
    Performance = kspNoBuffer
    CaptionMargin = 12
    Caption = ' Enter new password '
    CheckBoxAlignment = kalLeftJustify
    ThemeObject = 'default'
    Transparent = True
    TabOrder = 0
    UseCheckBox = False
  end
  object SaveButton: TTeButton
    Left = 111
    Top = 218
    Width = 75
    Height = 23
    Cursor = crHandPoint
    Performance = kspDoubleBuffer
    OnClick = SaveButtonClick
    BlackAndWhiteGlyph = False
    Caption = 'Save'
    ThemeObject = 'default'
    TabOrder = 1
    WordWrap = False
  end
  object CancelButton: TTeButton
    Left = 196
    Top = 218
    Width = 75
    Height = 23
    Cursor = crHandPoint
    Performance = kspDoubleBuffer
    OnClick = CancelButtonClick
    BlackAndWhiteGlyph = False
    Caption = 'Cancel'
    ThemeObject = 'default'
    TabOrder = 2
    WordWrap = False
  end
  object GroupBox1: TGroupBox
    Left = 10
    Top = 8
    Width = 261
    Height = 153
    Caption = ' Enter New Password'
    TabOrder = 3
    object TeLabel5: TTeLabel
      Left = 8
      Top = 102
      Width = 86
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Confirm password:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TeLabel4: TTeLabel
      Left = 24
      Top = 77
      Width = 73
      Height = 13
      Performance = kspNoBuffer
      Caption = 'New password:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TeLabel3: TTeLabel
      Left = 8
      Top = 53
      Width = 85
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Current password:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TeLabel2: TTeLabel
      Left = 50
      Top = 27
      Width = 46
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Player ID:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object PlayerIDLabel: TTeLabel
      Left = 103
      Top = 27
      Width = 43
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Player ID'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'BoldLabel'
    end
    object RememberCheckBox: TTeCheckBox
      Left = 64
      Top = 120
      Width = 185
      Height = 20
      Performance = kspNoBuffer
      Caption = 'Remember Player ID and password'
      AllowGrayed = False
      Alignment = kalLeftJustify
      Checked = True
      Spacing = 5
      State = kcbsChecked
      ThemeObject = 'default'
      TabOrder = 0
      Transparent = True
      WordWrap = False
    end
    object PasswordEdit: TTeEdit
      Left = 101
      Top = 73
      Width = 150
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
      MaxLength = 30
      ParentFont = False
      PasswordKind = pkCircle
      ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
      TabOrder = 1
      ThemeObject = 'default'
    end
    object CurrentPasswordEdit: TTeEdit
      Left = 101
      Top = 49
      Width = 150
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
      MaxLength = 30
      ParentFont = False
      PasswordKind = pkCircle
      ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
      TabOrder = 2
      ThemeObject = 'default'
    end
    object ConfirmEdit: TTeEdit
      Left = 101
      Top = 98
      Width = 150
      Height = 23
      Cursor = crIBeam
      Performance = kspNoBuffer
      OnKeyUp = ConfirmEditKeyUp
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
      TabOrder = 3
      ThemeObject = 'default'
    end
  end
end
