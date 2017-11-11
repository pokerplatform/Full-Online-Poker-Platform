object TransactionHistoryForm: TTransactionHistoryForm
  Left = 188
  Top = 114
  AutoScroll = False
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'BikiniPoker-Transactions history'
  ClientHeight = 349
  ClientWidth = 642
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
  object CancelButton: TTeButton
    Left = 525
    Top = 314
    Width = 110
    Height = 25
    Cursor = crHandPoint
    Performance = kspDoubleBuffer
    OnClick = CancelButtonClick
    BlackAndWhiteGlyph = False
    Caption = 'Close'
    ThemeObject = 'StandardButton'
    TabOrder = 0
    WordWrap = False
  end
  object TeGroupBox1: TTeGroupBox
    Left = 8
    Top = 263
    Width = 385
    Height = 77
    Performance = kspNoBuffer
    CaptionMargin = 12
    Caption = ' Filter '
    CheckBoxAlignment = kalLeftJustify
    ThemeObject = 'ThemeGroupBox'
    Transparent = True
    TabOrder = 1
    UseCheckBox = False
  end
  object UpdateButton: TTeButton
    Left = 525
    Top = 282
    Width = 110
    Height = 25
    Cursor = crHandPoint
    Performance = kspDoubleBuffer
    OnClick = UpdateButtonClick
    BlackAndWhiteGlyph = False
    Caption = 'Update history'
    ThemeObject = 'StandardButton'
    TabOrder = 2
    WordWrap = False
  end
  object HistoryPageControl: TTePageControl
    Left = 0
    Top = 0
    Width = 642
    Height = 257
    Performance = kspNoBuffer
    Align = alTop
    ActivePage = MoneyTabSheet
    MultiLine = True
    Tabs.Strings = (
      '  Account  '
      ' Bonus ')
    TabIndex = 0
    RaggedRight = True
    TabHeight = 20
    ThemeObject = 'default'
    TabOrder = 4
    TabStop = True
    object MoneyTabSheet: TTeTabSheet
      Caption = '  Account  '
      PageIndex = 0
      PageVisible = True
      object HistoryListView: TTeListView
        Left = 0
        Top = 0
        Width = 636
        Height = 229
        Align = alClient
        BorderStyle = bsNone
        Color = clWhite
        Columns = <
          item
            Caption = 'Date'
            Width = 130
          end
          item
            Caption = 'Type'
            Width = 110
          end
          item
            Caption = 'Comment'
            Width = 220
          end
          item
            Alignment = taRightJustify
            Caption = 'Amount'
            Width = 80
          end
          item
            Alignment = taRightJustify
            Caption = 'Balance'
            Width = 80
          end>
        ColumnClick = False
        Ctl3D = False
        GridLines = True
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        ThemeObject = 'default'
      end
    end
    object BonusesTabSheet: TTeTabSheet
      Caption = ' Bonus '
      PageIndex = 1
      PageVisible = True
      object BonusesListView: TTeListView
        Left = 0
        Top = 0
        Width = 636
        Height = 229
        Align = alClient
        BorderStyle = bsNone
        Color = clWhite
        Columns = <
          item
            Caption = 'Date'
            Width = 130
          end
          item
            Caption = 'Type'
            Width = 110
          end
          item
            Caption = 'Comment'
            Width = 220
          end
          item
            Alignment = taRightJustify
            Caption = 'Amount'
            Width = 80
          end
          item
            Alignment = taRightJustify
            Caption = 'Balance'
            Width = 80
          end>
        ColumnClick = False
        Ctl3D = False
        GridLines = True
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        ThemeObject = 'default'
      end
    end
  end
  object CalendarPanel: TTeHeaderPanel
    Left = 384
    Top = 64
    Width = 203
    Height = 176
    Performance = kspNoBuffer
    Visible = False
    AnimateRoll = False
    BevelWidth = 1
    BorderWidth = 1
    ButtonCursor = crHandPoint
    ButtonKind = kpbkClose
    Caption = 'Calendar'
    Rolled = False
    ParentRoll = False
    ShowBevel = True
    ShowButton = True
    ShowCaption = True
    ThemeObject = 'default'
    OnButtonClick = CalendarPanelButtonClick
    NormalHeight = {00000000}
    object MonthCalendar: TMonthCalendar
      Left = 1
      Top = 20
      Width = 201
      Height = 154
      Cursor = crHandPoint
      Date = 37919.740465057870000000
      MaxDate = 47484.000000000000000000
      MinDate = 37895.000000000000000000
      TabOrder = 0
      WeekNumbers = True
      OnClick = MonthCalendarClick
      OnDblClick = MonthCalendarDblClick
      OnKeyPress = MonthCalendarKeyPress
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 263
    Width = 385
    Height = 77
    Caption = ' Filter '
    TabOrder = 5
    object TeLabel4: TTeLabel
      Left = 147
      Top = 24
      Width = 57
      Height = 13
      Performance = kspNoBuffer
      Caption = 'transactions'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object DateToLabel: TTeLabel
      Left = 269
      Top = 50
      Width = 79
      Height = 13
      Performance = kspNoBuffer
      Alignment = taRightJustify
      AutoSize = False
      Caption = '99/99/9999'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object DateFromLabel: TTeLabel
      Left = 161
      Top = 50
      Width = 77
      Height = 13
      Performance = kspNoBuffer
      Alignment = taRightJustify
      AutoSize = False
      Caption = '99/99/9999'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object DateToButton: TTeButton
      Tag = 2
      Left = 352
      Top = 46
      Width = 20
      Height = 21
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = DateButtonClick
      BlackAndWhiteGlyph = False
      Caption = '...'
      ThemeObject = 'default'
      TabOrder = 0
      WordWrap = False
    end
    object TopLastEdit: TTeSpinEdit
      Left = 84
      Top = 20
      Width = 58
      Height = 23
      Cursor = crIBeam
      Performance = kspNoBuffer
      OnClick = TopLastEditClick
      OnKeyUp = TopLastEditKeyUp
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
      MaxLength = 4
      ParentFont = False
      PasswordKind = pkNone
      ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
      TabOrder = 1
      Text = '10'
      ThemeObject = 'default'
      ParentColor = False
      MaxValue = 9999.000000000000000000
      MinValue = 5.000000000000000000
      Value = 10.000000000000000000
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
    object LastRadioButton: TTeRadioButton
      Left = 12
      Top = 21
      Width = 69
      Height = 18
      Performance = kspNoBuffer
      OnClick = LastRadioButtonClick
      Caption = 'Show last'
      Alignment = kalLeftJustify
      Checked = True
      GroupIndex = 0
      Spacing = 5
      ThemeObject = 'default'
      TabOrder = 2
      TabStop = True
      WordWrap = False
    end
    object DateRadioButton: TTeRadioButton
      Left = 12
      Top = 47
      Width = 149
      Height = 20
      Performance = kspNoBuffer
      OnClick = DateRadioButtonClick
      Caption = 'Show transactions from/to:'
      Alignment = kalLeftJustify
      Checked = False
      GroupIndex = 0
      Spacing = 5
      ThemeObject = 'default'
      TabOrder = 3
      WordWrap = False
    end
    object DateFromButton: TTeButton
      Tag = 1
      Left = 243
      Top = 46
      Width = 20
      Height = 21
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = DateButtonClick
      BlackAndWhiteGlyph = False
      Caption = '...'
      ThemeObject = 'default'
      TabOrder = 4
      WordWrap = False
    end
  end
  object CalendarTimer: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = CalendarTimerTimer
    Left = 281
    Top = 64
  end
end
