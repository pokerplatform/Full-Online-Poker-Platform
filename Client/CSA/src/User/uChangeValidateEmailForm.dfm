object ChangeValidateEmailForm: TChangeValidateEmailForm
  Left = 273
  Top = 190
  AutoScroll = False
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'BikiniPoker-Change/Validate email address'
  ClientHeight = 304
  ClientWidth = 314
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object TeLabel1: TTeLabel
    Left = 8
    Top = 8
    Width = 297
    Height = 28
    Performance = kspNoBuffer
    AutoSize = False
    Caption = 
      'In order to receive hand histories or open a real money account,' +
      ' your email address must be validated.'
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'Label'
    WordWrap = True
  end
  object TeGroupBox1: TTeGroupBox
    Left = 7
    Top = 40
    Width = 300
    Height = 108
    Performance = kspNoBuffer
    CaptionMargin = 12
    Caption = ' Step1: Enter your email address '
    CheckBoxAlignment = kalLeftJustify
    ThemeObject = 'default'
    Transparent = True
    TabOrder = 0
    UseCheckBox = False
  end
  object TeGroupBox2: TTeGroupBox
    Left = 7
    Top = 155
    Width = 300
    Height = 109
    Performance = kspNoBuffer
    CaptionMargin = 12
    Caption = ' Step 2: Validation code '
    CheckBoxAlignment = kalLeftJustify
    ThemeObject = 'default'
    Transparent = True
    TabOrder = 1
    UseCheckBox = False
  end
  object CancelButton: TTeButton
    Left = 205
    Top = 272
    Width = 90
    Height = 25
    Cursor = crHandPoint
    Performance = kspDoubleBuffer
    OnClick = CancelButtonClick
    BlackAndWhiteGlyph = False
    Caption = 'Close'
    ThemeObject = 'default'
    TabOrder = 2
    WordWrap = False
  end
  object GroupBox1: TGroupBox
    Left = 7
    Top = 40
    Width = 300
    Height = 108
    Caption = ' Step1: Enter your email address '
    TabOrder = 3
    object TeLabel3: TTeLabel
      Left = 17
      Top = 51
      Width = 69
      Height = 13
      Performance = kspNoBuffer
      Caption = 'EMail address:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TeLabel2: TTeLabel
      Left = 38
      Top = 24
      Width = 46
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Player ID:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object PlayerIDLabel: TTeLabel
      Left = 90
      Top = 24
      Width = 43
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Player ID'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'BoldLabel'
    end
    object SendEMailButton: TTeButton
      Left = 163
      Top = 76
      Width = 130
      Height = 25
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = SendEMailButtonClick
      BlackAndWhiteGlyph = False
      Caption = 'Submit your email'
      ThemeObject = 'default'
      TabOrder = 0
      WordWrap = False
    end
    object EMailEdit: TTeEdit
      Left = 90
      Top = 47
      Width = 200
      Height = 23
      Cursor = crIBeam
      Performance = kspNoBuffer
      OnKeyUp = EmailEditKeyUp
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
      MaxLength = 250
      ParentFont = False
      PasswordKind = pkNone
      ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
      TabOrder = 1
      ThemeObject = 'default'
    end
  end
  object GroupBox2: TGroupBox
    Left = 7
    Top = 155
    Width = 300
    Height = 109
    Caption = ' Step 2: Validation code '
    TabOrder = 4
    object TeLabel5: TTeLabel
      Left = 10
      Top = 53
      Width = 76
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Validation code:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TeLabel4: TTeLabel
      Left = 8
      Top = 16
      Width = 245
      Height = 33
      Performance = kspNoBuffer
      AutoSize = False
      Caption = 
        'Once you receive your validation code by email, please enter it ' +
        'here and press "Validate".'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
      WordWrap = True
    end
    object ValidateButton: TTeButton
      Left = 198
      Top = 77
      Width = 90
      Height = 25
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = ValidateButtonClick
      BlackAndWhiteGlyph = False
      Caption = 'Validate'
      ThemeObject = 'default'
      TabOrder = 0
      WordWrap = False
    end
    object ValidationCodeEdit: TTeEdit
      Left = 90
      Top = 49
      Width = 200
      Height = 23
      Cursor = crIBeam
      Performance = kspNoBuffer
      OnKeyUp = ValidationCodeEditKeyUp
      OnKeyPress = ValidationCodeEditKeyPress
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
      MaxLength = 10
      ParentFont = False
      PasswordKind = pkNone
      ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
      TabOrder = 1
      ThemeObject = 'default'
    end
    object TeButton1: TTeButton
      Left = 11
      Top = 76
      Width = 134
      Height = 25
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = SendEMailButtonClick
      BlackAndWhiteGlyph = False
      Caption = 'Resend Validation Code'
      ThemeObject = 'default'
      TabOrder = 2
      WordWrap = False
    end
  end
end
