object RequestHandHistoryForm: TRequestHandHistoryForm
  Left = 390
  Top = 198
  AutoScroll = False
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'BikiniPoker-Request hand history...'
  ClientHeight = 196
  ClientWidth = 246
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object TeGroupBox1: TTeGroupBox
    Left = 8
    Top = 8
    Width = 233
    Height = 82
    Performance = kspNoBuffer
    CaptionMargin = 12
    Caption = ' Hand history request '
    CheckBoxAlignment = kalLeftJustify
    ThemeObject = 'default'
    Transparent = True
    TabOrder = 0
    UseCheckBox = False
  end
  object TeGroupBox2: TTeGroupBox
    Left = 8
    Top = 96
    Width = 233
    Height = 67
    Performance = kspNoBuffer
    CaptionMargin = 12
    Caption = ' Hand history order '
    CheckBoxAlignment = kalLeftJustify
    ThemeObject = 'default'
    Transparent = True
    TabOrder = 1
    UseCheckBox = False
  end
  object OkButton: TTeButton
    Left = 84
    Top = 171
    Width = 75
    Height = 25
    Performance = kspDoubleBuffer
    OnClick = OkButtonClick
    BlackAndWhiteGlyph = False
    Caption = 'Send'
    ThemeObject = 'default'
    TabOrder = 2
    WordWrap = False
  end
  object CancelButton: TTeButton
    Left = 166
    Top = 171
    Width = 75
    Height = 25
    Performance = kspDoubleBuffer
    OnClick = CancelButtonClick
    BlackAndWhiteGlyph = False
    Caption = 'Cancel'
    ThemeObject = 'default'
    TabOrder = 3
    WordWrap = False
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 233
    Height = 82
    Caption = ' Hand history request '
    TabOrder = 4
    object TeLabel1: TTeLabel
      Left = 138
      Top = 23
      Width = 29
      Height = 13
      Performance = kspNoBuffer
      Caption = 'hands'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'label'
    end
    object LastHandsRadioButton: TTeRadioButton
      Left = 12
      Top = 22
      Width = 58
      Height = 20
      Performance = kspNoBuffer
      OnClick = LastHandsRadioButtonClick
      Caption = 'My last'
      Alignment = kalLeftJustify
      Checked = True
      GroupIndex = 0
      Spacing = 5
      ThemeObject = 'default'
      TabOrder = 0
      TabStop = True
      WordWrap = False
    end
    object LastHandsSpinEdit: TTeSpinEdit
      Left = 75
      Top = 20
      Width = 57
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
      ParentFont = False
      PasswordKind = pkNone
      ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
      TabOrder = 1
      Text = '1'
      ThemeObject = 'default'
      ParentColor = False
      MaxValue = 100.000000000000000000
      MinValue = 1.000000000000000000
      Value = 1.000000000000000000
      ButtonAlign = baRight
      ButtonTransparent = False
      ButtonShowHint = False
      ButtonWidth = 15
      DownGlyph.Data = {
        0E010000424D0E01000000000000360000002800000009000000060000000100
        200000000000D800000000000000000000000000000000000000008080000080
        8000008080000080800000808000008080000080800000808000008080000080
        8000008080000080800000808000000000000080800000808000008080000080
        8000008080000080800000808000000000000000000000000000008080000080
        8000008080000080800000808000000000000000000000000000000000000000
        0000008080000080800000808000000000000000000000000000000000000000
        0000000000000000000000808000008080000080800000808000008080000080
        800000808000008080000080800000808000}
      UpGlyph.Data = {
        0E010000424D0E01000000000000360000002800000009000000060000000100
        200000000000D800000000000000000000000000000000000000008080000080
        8000008080000080800000808000008080000080800000808000008080000080
        8000000000000000000000000000000000000000000000000000000000000080
        8000008080000080800000000000000000000000000000000000000000000080
        8000008080000080800000808000008080000000000000000000000000000080
        8000008080000080800000808000008080000080800000808000000000000080
        8000008080000080800000808000008080000080800000808000008080000080
        800000808000008080000080800000808000}
      ButtonData = (
        False
        0
        ''
        ''
        False
        False
        15)
    end
    object HandNumberRadioButton: TTeRadioButton
      Left = 12
      Top = 50
      Width = 91
      Height = 20
      Performance = kspNoBuffer
      OnClick = HandNumberRadioButtonClick
      Caption = 'Hand number:'
      Alignment = kalLeftJustify
      Checked = False
      GroupIndex = 0
      Spacing = 5
      ThemeObject = 'default'
      TabOrder = 2
      WordWrap = False
    end
    object HandNumberComboBox: TComboBox
      Left = 106
      Top = 49
      Width = 121
      Height = 21
      ItemHeight = 13
      TabOrder = 3
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 96
    Width = 233
    Height = 67
    Caption = ' Hand history request '
    TabOrder = 5
    object NewestFirstRadioButton: TTeRadioButton
      Left = 12
      Top = 40
      Width = 98
      Height = 20
      Performance = kspNoBuffer
      Caption = 'Newest to oldest'
      Alignment = kalLeftJustify
      Checked = False
      GroupIndex = 0
      Spacing = 5
      ThemeObject = 'default'
      TabOrder = 0
      WordWrap = False
    end
    object OldestFirstRadioButton: TTeRadioButton
      Left = 12
      Top = 18
      Width = 98
      Height = 20
      Performance = kspNoBuffer
      Caption = 'Oldest to newest'
      Alignment = kalLeftJustify
      Checked = True
      GroupIndex = 0
      Spacing = 5
      ThemeObject = 'default'
      TabOrder = 1
      TabStop = True
      WordWrap = False
    end
  end
end
