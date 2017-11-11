object WaitingListJoinForm: TWaitingListJoinForm
  Left = 331
  Top = 203
  AutoScroll = False
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'BikiniPoker-Join the Hold'#39'em waiting list...'
  ClientHeight = 136
  ClientWidth = 346
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
  object TeGroupBox1: TTeGroupBox
    Left = 9
    Top = 8
    Width = 249
    Height = 121
    Performance = kspNoBuffer
    CaptionMargin = 12
    Caption = ' Join waiting list for ... '
    CheckBoxAlignment = kalLeftJustify
    ThemeObject = 'default'
    Transparent = True
    TabOrder = 0
    UseCheckBox = False
  end
  object JoinButton: TTeButton
    Left = 270
    Top = 78
    Width = 75
    Height = 23
    Cursor = crHandPoint
    Performance = kspDoubleBuffer
    OnClick = JoinButtonClick
    BlackAndWhiteGlyph = False
    Caption = 'Join'
    ThemeObject = 'default'
    TabOrder = 1
    WordWrap = False
  end
  object Cancel: TTeButton
    Left = 270
    Top = 107
    Width = 75
    Height = 23
    Cursor = crHandPoint
    Performance = kspDoubleBuffer
    OnClick = CancelClick
    BlackAndWhiteGlyph = False
    Caption = 'Cancel'
    ThemeObject = 'default'
    TabOrder = 2
    WordWrap = False
  end
  object GroupBox1: TGroupBox
    Left = 9
    Top = 8
    Width = 249
    Height = 121
    Caption = ' Join waiting list for ... '
    TabOrder = 3
    object TeLabel1: TTeLabel
      Left = 33
      Top = 94
      Width = 102
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Minimum # of players:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TablePlayersLabel: TTeLabel
      Left = 31
      Top = 40
      Width = 136
      Height = 13
      Performance = kspNoBuffer
      Caption = 'There are 0 users before you'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TableRadioButton: TTeRadioButton
      Left = 14
      Top = 20
      Width = 227
      Height = 20
      Performance = kspNoBuffer
      OnClick = TableRadioButtonClick
      Caption = 'Selected table'
      Alignment = kalLeftJustify
      Checked = True
      GroupIndex = 0
      Spacing = 5
      ThemeObject = 'default'
      TabOrder = 0
      TabStop = True
      WordWrap = False
    end
    object PlayersSpinEdit: TTeSpinEdit
      Left = 140
      Top = 90
      Width = 47
      Height = 17
      Cursor = crIBeam
      Performance = kspNoBuffer
      AutoSize = True
      BevelSides = [kbsLeft, kbsTop, kbsRight, kbsBottom]
      BevelInner = kbvLowered
      BevelOuter = kbvLowered
      BevelKind = kbkSingle
      BevelWidth = 1
      BorderWidth = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      PasswordKind = pkNone
      ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
      TabOrder = 1
      Text = '2'
      ThemeObject = 'default'
      ParentColor = False
      MaxValue = 9.000000000000000000
      MinValue = 2.000000000000000000
      Value = 2.000000000000000000
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
    object GroupRadioButton: TTeRadioButton
      Left = 14
      Top = 70
      Width = 227
      Height = 20
      Performance = kspNoBuffer
      OnClick = GroupRadioButtonClick
      Caption = 'First available table in process group'
      Alignment = kalLeftJustify
      Checked = False
      GroupIndex = 0
      Spacing = 5
      ThemeObject = 'default'
      TabOrder = 2
      WordWrap = False
    end
  end
end
