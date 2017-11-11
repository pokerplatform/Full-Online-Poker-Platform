object UsersForm: TUsersForm
  Left = 102
  Top = 132
  Width = 672
  Height = 454
  Caption = 'RoboPoker'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MainSplitter: TSplitter
    Left = 250
    Top = 0
    Width = 4
    Height = 400
    AutoSnap = False
    Color = clAppWorkSpace
    ParentColor = False
    ResizeStyle = rsUpdate
  end
  object BotListPanel: TPanel
    Left = 0
    Top = 0
    Width = 250
    Height = 400
    Align = alLeft
    BevelOuter = bvNone
    Constraints.MinHeight = 400
    Constraints.MinWidth = 250
    TabOrder = 0
    object BotListCaptionLabel: TLabel
      Left = 0
      Top = 0
      Width = 250
      Height = 20
      Align = alTop
      AutoSize = False
      Caption = ' Bot list'
      Color = clAppWorkSpace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
    end
    object BotListActionPanel: TPanel
      Left = 0
      Top = 342
      Width = 250
      Height = 58
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object BotListDeleteButton: TSpeedButton
        Left = 165
        Top = 29
        Width = 80
        Height = 25
        Cursor = crHandPoint
        Caption = 'Delete'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = BotListDeleteButtonClick
      end
      object BotListConnectButton: TSpeedButton
        Left = 85
        Top = 29
        Width = 80
        Height = 25
        Cursor = crHandPoint
        Caption = 'Connect'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = BotListConnectButtonClick
      end
      object BotListSelectAllButton: TSpeedButton
        Left = 5
        Top = 4
        Width = 64
        Height = 25
        Cursor = crHandPoint
        Caption = 'Select all'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = BotListSelectAllButtonClick
      end
      object BotListClearSelectionAllButton: TSpeedButton
        Left = 69
        Top = 4
        Width = 96
        Height = 25
        Cursor = crHandPoint
        Caption = 'Clear selection'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = BotListClearSelectionAllButtonClick
      end
      object BotListEditButton: TSpeedButton
        Left = 205
        Top = 4
        Width = 40
        Height = 25
        Cursor = crHandPoint
        Caption = 'Edit'
        Enabled = False
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = BotListEditButtonClick
      end
      object BotListAddButton: TSpeedButton
        Left = 165
        Top = 4
        Width = 40
        Height = 25
        Cursor = crHandPoint
        Caption = 'Add'
        Enabled = False
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = BotListAddButtonClick
      end
      object BotListGenerateButton: TSpeedButton
        Left = 5
        Top = 29
        Width = 80
        Height = 25
        Cursor = crHandPoint
        Caption = 'Generate'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = BotListGenerateButtonClick
      end
    end
    object BotListView: TListView
      Left = 0
      Top = 20
      Width = 250
      Height = 322
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Columns = <
        item
          Caption = 'ID'
          Width = 40
        end
        item
          Caption = 'Login name'
          Width = 180
        end>
      ColumnClick = False
      FlatScrollBars = True
      GridLines = True
      HideSelection = False
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 1
      ViewStyle = vsReport
    end
  end
  object ConnectedBotsPanel: TPanel
    Left = 254
    Top = 0
    Width = 410
    Height = 400
    Align = alClient
    BevelOuter = bvNone
    Constraints.MinWidth = 400
    TabOrder = 1
    object SplitterBots: TSplitter
      Left = 0
      Top = 263
      Width = 410
      Height = 5
      Cursor = crVSplit
      Align = alBottom
      AutoSnap = False
      Color = clAppWorkSpace
      ParentColor = False
      ResizeStyle = rsUpdate
    end
    object ActionPageControl: TPageControl
      Left = 0
      Top = 268
      Width = 410
      Height = 132
      Cursor = crHandPoint
      ActivePage = ConnectionsTabSheet
      Align = alBottom
      Constraints.MinHeight = 132
      Constraints.MinWidth = 410
      HotTrack = True
      Style = tsFlatButtons
      TabOrder = 0
      object ConnectionsTabSheet: TTabSheet
        Caption = 'Connections'
        object ConnectedDisconnectButton: TSpeedButton
          Left = 120
          Top = 4
          Width = 95
          Height = 24
          Cursor = crHandPoint
          Caption = 'Disconnect'
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = ConnectedDisconnectButtonClick
        end
        object ConnectedReconnectButton: TSpeedButton
          Left = 120
          Top = 28
          Width = 95
          Height = 24
          Cursor = crHandPoint
          Caption = 'Reconnect'
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = ConnectedReconnectButtonClick
        end
        object ConnectedSelectAllButton: TSpeedButton
          Left = 120
          Top = 52
          Width = 95
          Height = 24
          Cursor = crHandPoint
          Caption = 'Select all'
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = ConnectedSelectAllButtonClick
        end
        object ConnectedClearSelectionButton: TSpeedButton
          Left = 120
          Top = 76
          Width = 95
          Height = 24
          Cursor = crHandPoint
          Caption = 'Clear selection'
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = ConnectedClearSelectionButtonClick
        end
        object ConnectedInfoEdit: TLabeledEdit
          Left = 73
          Top = 29
          Width = 40
          Height = 21
          BevelInner = bvSpace
          BevelKind = bkFlat
          BevelOuter = bvRaised
          BorderStyle = bsNone
          Color = clBtnFace
          EditLabel.Width = 55
          EditLabel.Height = 13
          EditLabel.Caption = 'Connected:'
          LabelPosition = lpLeft
          ReadOnly = True
          TabOrder = 0
          Text = '0'
        end
        object DisconnectedInfoEdit: TLabeledEdit
          Left = 73
          Top = 4
          Width = 40
          Height = 21
          BevelInner = bvSpace
          BevelKind = bkFlat
          BevelOuter = bvRaised
          BorderStyle = bsNone
          Color = clBtnFace
          EditLabel.Width = 69
          EditLabel.Height = 13
          EditLabel.Caption = 'Disconnected:'
          LabelPosition = lpLeft
          ReadOnly = True
          TabOrder = 1
          Text = '0'
        end
        object RegisteredInfoEdit: TLabeledEdit
          Left = 73
          Top = 54
          Width = 40
          Height = 21
          BevelInner = bvSpace
          BevelKind = bkFlat
          BevelOuter = bvRaised
          BorderStyle = bsNone
          Color = clBtnFace
          EditLabel.Width = 54
          EditLabel.Height = 13
          EditLabel.Caption = 'Registered:'
          LabelPosition = lpLeft
          ReadOnly = True
          TabOrder = 2
          Text = '0'
        end
        object LoggedInfoEdit: TLabeledEdit
          Left = 73
          Top = 79
          Width = 40
          Height = 21
          BevelInner = bvSpace
          BevelKind = bkFlat
          BevelOuter = bvRaised
          BorderStyle = bsNone
          Color = clBtnFace
          EditLabel.Width = 50
          EditLabel.Height = 13
          EditLabel.Caption = 'Logged in:'
          LabelPosition = lpLeft
          ReadOnly = True
          TabOrder = 3
          Text = '0'
        end
        object RefreshGroupBox: TGroupBox
          Left = 221
          Top = 0
          Width = 182
          Height = 100
          Caption = ' Process List  '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
          object RefreshNowButton: TSpeedButton
            Left = 84
            Top = 67
            Width = 90
            Height = 25
            Cursor = crHandPoint
            Caption = 'Refresh now'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            OnClick = RefreshNowButtonClick
          end
          object RefreshEditButton: TSpeedButton
            Left = 7
            Top = 67
            Width = 77
            Height = 25
            Cursor = crHandPoint
            Caption = 'Edit'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            OnClick = RefreshEditButtonClick
          end
          object EmulateCheckBox: TCheckBox
            Left = 8
            Top = 21
            Width = 161
            Height = 17
            Caption = 'Emulate Client application as:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object EmulateComboBox: TComboBox
            Left = 8
            Top = 41
            Width = 165
            Height = 21
            Style = csDropDownList
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ItemHeight = 13
            ParentFont = False
            TabOrder = 1
            Items.Strings = (
              'Active Lobby'
              'Minimized Lobby')
          end
        end
      end
      object ProcessesTabSheet: TTabSheet
        Caption = 'Processes'
        ImageIndex = 1
        object ProcessListPanel: TPanel
          Left = 0
          Top = 27
          Width = 402
          Height = 74
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object ProcessesSplitter: TSplitter
            Left = 265
            Top = 0
            Width = 4
            Height = 74
            Align = alRight
            AutoSnap = False
            Color = clAppWorkSpace
            ParentColor = False
            ResizeStyle = rsUpdate
          end
          object ProcessesListView: TListView
            Left = 0
            Top = 0
            Width = 265
            Height = 74
            Align = alClient
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Columns = <
              item
              end
              item
                Width = 120
              end
              item
                Width = 100
              end>
            ColumnClick = False
            GridLines = True
            HideSelection = False
            ReadOnly = True
            RowSelect = True
            TabOrder = 0
            ViewStyle = vsReport
            OnClick = ProcessesListViewClick
          end
          object ProcessInfoMemo: TMemo
            Left = 269
            Top = 0
            Width = 133
            Height = 74
            Align = alRight
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Color = clBtnFace
            TabOrder = 1
            WordWrap = False
          end
        end
        object ProcessesActionPanel: TPanel
          Left = 0
          Top = 0
          Width = 402
          Height = 27
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          DesignSize = (
            402
            27)
          object CategoryLabel: TLabel
            Left = 1
            Top = 6
            Width = 45
            Height = 13
            Caption = 'Category:'
          end
          object JoinProcessButton: TSpeedButton
            Left = 214
            Top = 0
            Width = 90
            Height = 25
            Cursor = crHandPoint
            Anchors = [akTop, akRight]
            Caption = 'Join Bots'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            OnClick = JoinProcessButtonClick
          end
          object ShowTablesButton: TSpeedButton
            Left = 310
            Top = 0
            Width = 90
            Height = 25
            Cursor = crHandPoint
            Anchors = [akTop, akRight]
            Caption = 'Show Tables'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            OnClick = ShowTablesButtonClick
          end
          object CategoryComboBox: TComboBox
            Left = 50
            Top = 2
            Width = 148
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 0
            TabOrder = 0
            Text = 'Holdem'
            OnChange = CategoryComboBoxChange
            Items.Strings = (
              'Holdem')
          end
        end
      end
    end
    object PanelBots: TPanel
      Left = 0
      Top = 0
      Width = 410
      Height = 263
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object ConnectedBotsCaptionLabel: TLabel
        Left = 0
        Top = 0
        Width = 410
        Height = 20
        Align = alTop
        AutoSize = False
        Caption = '  Connected bots'
        Color = clAppWorkSpace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindow
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Layout = tlCenter
      end
      object ConnectedBotListView: TListView
        Left = 0
        Top = 20
        Width = 410
        Height = 243
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Columns = <
          item
            Caption = 'ID'
            Width = 35
          end
          item
            Caption = 'Session ID'
            Width = 65
          end
          item
            Caption = 'User ID'
            Width = 65
          end
          item
            Caption = 'Login Name'
            Width = 75
          end
          item
            Caption = 'Status'
            Width = 70
          end
          item
            Caption = 'Disconnects'
          end
          item
            Caption = 'Processes'
          end>
        ColumnClick = False
        FlatScrollBars = True
        GridLines = True
        HideSelection = False
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
  end
  object MainMenu: TMainMenu
    Left = 232
    object Bots1: TMenuItem
      Caption = 'Bots'
      object GenerateBotsItem: TMenuItem
        Caption = 'Generate...'
        OnClick = GenerateBotsItemClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Quit1: TMenuItem
        Caption = 'Exit'
        ShortCut = 32883
      end
    end
    object ables1: TMenuItem
      Caption = 'Tables'
      object ablelist1: TMenuItem
        Caption = 'Table list'
      end
      object Runn1: TMenuItem
        Caption = 'Playing tables'
      end
    end
    object ournaments1: TMenuItem
      Caption = 'Tournaments'
      object Singletabletournaments1: TMenuItem
        Caption = 'Single-table tournaments'
      end
      object Multitabletournaments1: TMenuItem
        Caption = 'Multi-table tournaments'
      end
    end
    object Settings1: TMenuItem
      Caption = 'Settings'
      object ConnectionSettingsItem: TMenuItem
        Caption = 'Settings...'
        OnClick = ConnectionSettingsItemClick
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object About1: TMenuItem
        Caption = 'About'
      end
    end
  end
  object CloseTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = CloseTimerTimer
    Left = 56
    Top = 56
  end
end
