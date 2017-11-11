object LoginForm: TLoginForm
  Left = 306
  Top = 239
  AutoScroll = False
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'BikiniPoker-Login'
  ClientHeight = 136
  ClientWidth = 346
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
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
    Width = 346
    Height = 136
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
      Left = 9
      Top = 49
      Width = 46
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Player ID:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TeLabel2: TTeLabel
      Left = 7
      Top = 80
      Width = 49
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Password:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TeLabel3: TTeLabel
      Left = 9
      Top = 22
      Width = 206
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Please enter your Player ID and password...'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object PlayerIDEdit: TTeEdit
      Tag = 20
      Left = 60
      Top = 47
      Width = 132
      Height = 23
      Cursor = crIBeam
      Performance = kspNoBuffer
      OnKeyPress = PlayerIDEditKeyPress
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
    object PasswordEdit: TTeEdit
      Tag = 20
      Left = 59
      Top = 76
      Width = 132
      Height = 23
      Cursor = crIBeam
      Performance = kspNoBuffer
      OnKeyPress = PasswordEditKeyPress
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
      PasswordKind = pkCircle
      ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
      TabOrder = 1
      ThemeObject = 'default'
    end
    object LoginButton: TTeButton
      Left = 199
      Top = 44
      Width = 137
      Height = 25
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = LoginButtonClick
      BlackAndWhiteGlyph = False
      Caption = 'Log in'
      ThemeObject = 'default'
      TabOrder = 3
      WordWrap = False
    end
    object CancelButton: TTeButton
      Left = 199
      Top = 98
      Width = 137
      Height = 25
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = CancelButtonClick
      BlackAndWhiteGlyph = False
      Caption = 'Cancel'
      ThemeObject = 'default'
      TabOrder = 6
      WordWrap = False
    end
    object NewUserButton: TTeButton
      Left = 199
      Top = 71
      Width = 137
      Height = 25
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = NewUserButtonClick
      BlackAndWhiteGlyph = False
      Caption = 'Create new account'
      ThemeObject = 'default'
      TabOrder = 4
      WordWrap = False
    end
    object RememberCheckBox: TTeCheckBox
      Left = 60
      Top = 101
      Width = 132
      Height = 20
      Performance = kspNoBuffer
      Visible = False
      Caption = 'Remember login info'
      AllowGrayed = False
      Alignment = kalLeftJustify
      Checked = True
      Spacing = 5
      State = kcbsChecked
      ThemeObject = 'default'
      TabOrder = 2
      Transparent = True
      WordWrap = False
    end
    object ForgotPasswordButton: TTeButton
      Left = 199
      Top = 98
      Width = 137
      Height = 25
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      Visible = False
      OnClick = ForgotPasswordButtonClick
      BlackAndWhiteGlyph = False
      Caption = 'Forgot password?'
      ThemeObject = 'default'
      TabOrder = 5
      WordWrap = False
    end
  end
end
