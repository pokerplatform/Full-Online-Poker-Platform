object ProcessStatisticsForm: TProcessStatisticsForm
  Left = 267
  Top = 199
  AutoScroll = False
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'BikiniPoker-Statistics'
  ClientHeight = 203
  ClientWidth = 315
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
  object TeHeaderPanel1: TTeHeaderPanel
    Left = 0
    Top = 0
    Width = 315
    Height = 32
    Performance = kspNoBuffer
    OnMouseUp = BackgroundPanelMouseUp
    Align = alTop
    AnimateRoll = False
    BevelWidth = 0
    BorderWidth = 0
    ButtonKind = kpbkRollUp
    Caption = 'TeHeaderPanel1'
    Rolled = False
    ParentRoll = False
    ShowBevel = True
    ShowButton = False
    ShowCaption = False
    ThemeObject = 'TranspPanel'
    NormalHeight = {00000000}
    object SessionStartNameLabel: TTeLabel
      Left = 21
      Top = 1
      Width = 63
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Session start:'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      PopupMenu = StatisticsPopupMenu
      ThemeObject = 'Label'
    end
    object SessionGamesNameLabel: TTeLabel
      Left = 15
      Top = 14
      Width = 72
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Session hands:'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      PopupMenu = StatisticsPopupMenu
      ThemeObject = 'Label'
    end
    object SessionGamesLabel: TTeLabel
      Left = 90
      Top = 14
      Width = 6
      Height = 13
      Performance = kspNoBuffer
      Caption = '0'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      PopupMenu = StatisticsPopupMenu
      ThemeObject = 'BoldLabel'
    end
    object SessionStartLabel: TTeLabel
      Left = 90
      Top = 1
      Width = 6
      Height = 13
      Performance = kspNoBuffer
      Caption = '0'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      PopupMenu = StatisticsPopupMenu
      ThemeObject = 'BoldLabel'
    end
    object Bevel5: TBevel
      Left = 1
      Top = 1
      Width = 248
      Height = 31
      Shape = bsFrame
    end
    object ResetButton: TTeButton
      Left = 250
      Top = 4
      Width = 48
      Height = 22
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = ResetButtonClick
      BlackAndWhiteGlyph = False
      Caption = 'Reset'
      PopupMenu = StatisticsPopupMenu
      ThemeObject = 'default'
      TabOrder = 0
      WordWrap = False
    end
  end
  object TeHeaderPanel2: TTeHeaderPanel
    Left = 0
    Top = 32
    Width = 315
    Height = 32
    Performance = kspNoBuffer
    OnMouseUp = BackgroundPanelMouseUp
    Align = alTop
    AnimateRoll = False
    BevelWidth = 0
    BorderWidth = 0
    ButtonKind = kpbkRollUp
    Caption = 'TeHeaderPanel1'
    Rolled = False
    ParentRoll = False
    ShowBevel = True
    ShowButton = False
    ShowCaption = False
    ThemeObject = 'TranspPanel'
    NormalHeight = {00000000}
    object WinFlopsSeenValueLabel: TTeLabel
      Left = 273
      Top = 15
      Width = 17
      Height = 13
      Performance = kspNoBuffer
      Alignment = taRightJustify
      Caption = '0 %'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      PopupMenu = StatisticsPopupMenu
      ThemeObject = 'BoldLabel'
    end
    object FlopsSeenNameLabel: TTeLabel
      Left = 197
      Top = 2
      Width = 54
      Height = 13
      Performance = kspNoBuffer
      Alignment = taRightJustify
      Caption = 'Flops seen:'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      PopupMenu = StatisticsPopupMenu
      ThemeObject = 'Label'
    end
    object WinFlopsSeenNameLabel: TTeLabel
      Left = 164
      Top = 15
      Width = 87
      Height = 13
      Performance = kspNoBuffer
      Alignment = taRightJustify
      Caption = 'Win % if flop seen:'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      PopupMenu = StatisticsPopupMenu
      ThemeObject = 'Label'
    end
    object FlopsSeenValueLabel: TTeLabel
      Left = 273
      Top = 2
      Width = 17
      Height = 13
      Performance = kspNoBuffer
      Alignment = taRightJustify
      Caption = '0 %'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      PopupMenu = StatisticsPopupMenu
      ThemeObject = 'BoldLabel'
    end
    object Bevel4: TBevel
      Left = 150
      Top = 2
      Width = 149
      Height = 28
      Shape = bsFrame
    end
    object TeHeaderPanel3: TTeHeaderPanel
      Left = 0
      Top = 0
      Width = 150
      Height = 32
      Performance = kspNoBuffer
      OnMouseUp = BackgroundPanelMouseUp
      Align = alLeft
      AnimateRoll = False
      BevelWidth = 0
      BorderWidth = 0
      ButtonKind = kpbkRollUp
      Caption = 'TeHeaderPanel1'
      Rolled = False
      ParentRoll = False
      ShowBevel = True
      ShowButton = False
      ShowCaption = False
      ThemeObject = 'TranspPanel'
      NormalHeight = {00000000}
      object GamesWonNameLabel: TTeLabel
        Left = 30
        Top = 2
        Width = 57
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'Hands won:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        PopupMenu = StatisticsPopupMenu
        ThemeObject = 'Label'
      end
      object ShowdownsWonNameLabel: TTeLabel
        Left = 3
        Top = 15
        Width = 84
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'Showdowns won:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        PopupMenu = StatisticsPopupMenu
        ThemeObject = 'Label'
      end
      object GamesWonLabel: TTeLabel
        Left = 109
        Top = 2
        Width = 17
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = '0 %'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        PopupMenu = StatisticsPopupMenu
        ThemeObject = 'BoldLabel'
      end
      object ShowdownsWonLabel: TTeLabel
        Left = 109
        Top = 15
        Width = 17
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = '0 %'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        PopupMenu = StatisticsPopupMenu
        ThemeObject = 'BoldLabel'
      end
      object Bevel3: TBevel
        Left = 1
        Top = 2
        Width = 147
        Height = 28
        Shape = bsFrame
      end
    end
  end
  object TeHeaderPanel4: TTeHeaderPanel
    Left = 0
    Top = 64
    Width = 315
    Height = 139
    Performance = kspNoBuffer
    OnMouseUp = BackgroundPanelMouseUp
    Align = alClient
    AnimateRoll = False
    BevelWidth = 0
    BorderWidth = 0
    ButtonKind = kpbkRollUp
    Caption = 'TeHeaderPanel1'
    Rolled = False
    ParentRoll = False
    ShowBevel = True
    ShowButton = False
    ShowCaption = False
    ThemeObject = 'TranspPanel'
    NormalHeight = {00000000}
    object WhereYouFoldLabel: TTeLabel
      Left = 157
      Top = 7
      Width = 81
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Where you fold...'
      Color = clBtnFace
      ParentColor = False
      PopupMenu = StatisticsPopupMenu
      ThemeObject = 'BoldLabel'
    end
    object StatsName1Label: TTeLabel
      Left = 212
      Top = 23
      Width = 39
      Height = 13
      Performance = kspNoBuffer
      Alignment = taRightJustify
      Caption = 'Pre-flop:'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      PopupMenu = StatisticsPopupMenu
      ThemeObject = 'Label'
    end
    object StatsValue1Label: TTeLabel
      Left = 273
      Top = 23
      Width = 17
      Height = 13
      Performance = kspNoBuffer
      Alignment = taRightJustify
      Caption = '0 %'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      PopupMenu = StatisticsPopupMenu
      ThemeObject = 'BoldLabel'
    end
    object StatsName2Label: TTeLabel
      Left = 228
      Top = 38
      Width = 23
      Height = 13
      Performance = kspNoBuffer
      Alignment = taRightJustify
      Caption = 'Flop:'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      PopupMenu = StatisticsPopupMenu
      ThemeObject = 'Label'
    end
    object StatsValue2Label: TTeLabel
      Left = 273
      Top = 38
      Width = 17
      Height = 13
      Performance = kspNoBuffer
      Alignment = taRightJustify
      Caption = '0 %'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      PopupMenu = StatisticsPopupMenu
      ThemeObject = 'BoldLabel'
    end
    object StatsName3Label: TTeLabel
      Left = 226
      Top = 53
      Width = 25
      Height = 13
      Performance = kspNoBuffer
      Alignment = taRightJustify
      Caption = 'Turn:'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      PopupMenu = StatisticsPopupMenu
      ThemeObject = 'Label'
    end
    object StatsValue3Label: TTeLabel
      Left = 273
      Top = 53
      Width = 17
      Height = 13
      Performance = kspNoBuffer
      Alignment = taRightJustify
      Caption = '0 %'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      PopupMenu = StatisticsPopupMenu
      ThemeObject = 'BoldLabel'
    end
    object StatsName4Label: TTeLabel
      Left = 223
      Top = 68
      Width = 28
      Height = 13
      Performance = kspNoBuffer
      Alignment = taRightJustify
      Caption = 'River:'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      PopupMenu = StatisticsPopupMenu
      ThemeObject = 'Label'
    end
    object StatsValue4Label: TTeLabel
      Left = 273
      Top = 68
      Width = 17
      Height = 13
      Performance = kspNoBuffer
      Alignment = taRightJustify
      Caption = '0 %'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      PopupMenu = StatisticsPopupMenu
      ThemeObject = 'BoldLabel'
    end
    object StatsName5Label: TTeLabel
      Left = 214
      Top = 83
      Width = 37
      Height = 13
      Performance = kspNoBuffer
      Alignment = taRightJustify
      Caption = 'No fold:'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      PopupMenu = StatisticsPopupMenu
      ThemeObject = 'Label'
    end
    object StatsValue5Label: TTeLabel
      Left = 273
      Top = 83
      Width = 17
      Height = 13
      Performance = kspNoBuffer
      Alignment = taRightJustify
      Caption = '0 %'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      PopupMenu = StatisticsPopupMenu
      ThemeObject = 'BoldLabel'
    end
    object StatsName6Label: TTeLabel
      Left = 248
      Top = 98
      Width = 3
      Height = 13
      Performance = kspNoBuffer
      Alignment = taRightJustify
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      PopupMenu = StatisticsPopupMenu
      ThemeObject = 'default'
    end
    object StatsValue6Label: TTeLabel
      Left = 287
      Top = 98
      Width = 3
      Height = 13
      Performance = kspNoBuffer
      Alignment = taRightJustify
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      PopupMenu = StatisticsPopupMenu
      ThemeObject = 'BoldLabel'
    end
    object Bevel2: TBevel
      Left = 150
      Top = 0
      Width = 149
      Height = 119
      Shape = bsFrame
    end
    object TeHeaderPanel5: TTeHeaderPanel
      Left = 0
      Top = 0
      Width = 150
      Height = 139
      Performance = kspNoBuffer
      OnMouseUp = BackgroundPanelMouseUp
      Align = alLeft
      AnimateRoll = False
      BevelWidth = 0
      BorderWidth = 0
      ButtonKind = kpbkRollUp
      Caption = 'TeHeaderPanel1'
      Rolled = False
      ParentRoll = False
      ShowBevel = True
      ShowButton = False
      ShowCaption = False
      ThemeObject = 'TranspPanel'
      NormalHeight = {00000000}
      object YourActionsLabel: TTeLabel
        Left = 8
        Top = 5
        Width = 68
        Height = 13
        Performance = kspNoBuffer
        Caption = 'Your actions...'
        Color = clBtnFace
        ParentColor = False
        PopupMenu = StatisticsPopupMenu
        ThemeObject = 'BoldLabel'
      end
      object FoldNameLabel: TTeLabel
        Left = 64
        Top = 21
        Width = 23
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'Fold:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        PopupMenu = StatisticsPopupMenu
        ThemeObject = 'Label'
      end
      object FoldLabel: TTeLabel
        Left = 109
        Top = 21
        Width = 17
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = '0 %'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        PopupMenu = StatisticsPopupMenu
        ThemeObject = 'BoldLabel'
      end
      object CheckNameLabel: TTeLabel
        Left = 53
        Top = 36
        Width = 34
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'Check:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        PopupMenu = StatisticsPopupMenu
        ThemeObject = 'Label'
      end
      object CheckLabel: TTeLabel
        Left = 109
        Top = 36
        Width = 17
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = '0 %'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        PopupMenu = StatisticsPopupMenu
        ThemeObject = 'BoldLabel'
      end
      object CallNameLabel: TTeLabel
        Left = 67
        Top = 51
        Width = 20
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'Call:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        PopupMenu = StatisticsPopupMenu
        ThemeObject = 'Label'
      end
      object CallLabel: TTeLabel
        Left = 109
        Top = 51
        Width = 17
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = '0 %'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        PopupMenu = StatisticsPopupMenu
        ThemeObject = 'BoldLabel'
      end
      object BetNameLabel: TTeLabel
        Left = 68
        Top = 66
        Width = 19
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'Bet:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        PopupMenu = StatisticsPopupMenu
        ThemeObject = 'Label'
      end
      object BetLabel: TTeLabel
        Left = 109
        Top = 66
        Width = 17
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = '0 %'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        PopupMenu = StatisticsPopupMenu
        ThemeObject = 'BoldLabel'
      end
      object RaiseNameLabel: TTeLabel
        Left = 57
        Top = 81
        Width = 30
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'Raise:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        PopupMenu = StatisticsPopupMenu
        ThemeObject = 'Label'
      end
      object RaiseLabel: TTeLabel
        Left = 109
        Top = 81
        Width = 17
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = '0 %'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        PopupMenu = StatisticsPopupMenu
        ThemeObject = 'BoldLabel'
      end
      object ReRaiseNameLabel: TTeLabel
        Left = 45
        Top = 96
        Width = 42
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'Re-raise:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        PopupMenu = StatisticsPopupMenu
        ThemeObject = 'Label'
      end
      object ReRaiseLabel: TTeLabel
        Left = 109
        Top = 96
        Width = 17
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = '0 %'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        PopupMenu = StatisticsPopupMenu
        ThemeObject = 'BoldLabel'
      end
      object Bevel1: TBevel
        Left = 1
        Top = 0
        Width = 147
        Height = 119
        Shape = bsFrame
      end
    end
  end
  object StatisticsPopupMenu: TTePopupMenu
    PopupMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
    Left = 160
    object AlwaysOnTopItem: TTeItem
      Caption = 'Always on top'
      Scrolled = False
      ScrollCount = 0
      OnClick = AlwaysOnTopItemClick
    end
    object CustomItem5: TTeItem
      Caption = '-'
      Scrolled = False
      ScrollCount = 0
    end
    object CustomItem2: TTeItem
      Caption = '-'
      Scrolled = False
      ScrollCount = 0
    end
    object SaveToClipboardItem: TTeItem
      Caption = 'Copy statistics to clipboard'
      Scrolled = False
      ScrollCount = 0
      OnClick = SaveToClipboardItemClick
    end
    object ResetStatisticsItem: TTeItem
      Caption = 'Reset statistics'
      Scrolled = False
      ScrollCount = 0
      OnClick = ResetStatisticsItemClick
    end
    object CustomItem1: TTeItem
      Caption = '-'
      Scrolled = False
      ScrollCount = 0
    end
    object PreserveStatisticsItem: TTeItem
      Caption = 'Preserve statistics next session'
      Scrolled = False
      ScrollCount = 0
      OnClick = PreserveStatisticsItemClick
    end
    object StatisticsLoggingItem: TTeItem
      Caption = 'Statistics logging'
      Scrolled = False
      ScrollCount = 0
      OnClick = StatisticsLoggingItemClick
    end
  end
  object ChangeGameTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = ChangeGameTimerTimer
    Left = 200
  end
end
