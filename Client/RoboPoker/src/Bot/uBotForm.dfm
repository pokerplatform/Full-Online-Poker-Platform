object BotForm: TBotForm
  Left = 144
  Top = 86
  BorderStyle = bsSingle
  Caption = 'Bot Form'
  ClientHeight = 548
  ClientWidth = 659
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PanelInfo: TPanel
    Left = 0
    Top = 0
    Width = 659
    Height = 548
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 0
    object PanelCommonInfo: TPanel
      Left = 1
      Top = 85
      Width = 657
      Height = 462
      Align = alClient
      TabOrder = 0
      object SplitterUser: TSplitter
        Left = 496
        Top = 1
        Height = 460
        Align = alRight
      end
      object Panel1: TPanel
        Left = 1
        Top = 1
        Width = 495
        Height = 460
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 0
        object Label17: TLabel
          Left = 2
          Top = 213
          Width = 491
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = 'Watchers:'
        end
        object Label18: TLabel
          Left = 2
          Top = 2
          Width = 491
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = 'Chairs:'
        end
        object sgUsers: TStringGrid
          Left = 2
          Top = 226
          Width = 491
          Height = 232
          Align = alClient
          Ctl3D = True
          DefaultColWidth = 40
          DefaultRowHeight = 14
          Enabled = False
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
          ParentCtl3D = False
          TabOrder = 1
          OnSelectCell = sgUsersSelectCell
          ColWidths = (
            40
            226
            79
            87
            49)
        end
        object sgChairs: TStringGrid
          Left = 2
          Top = 15
          Width = 491
          Height = 198
          Align = alTop
          ColCount = 7
          Ctl3D = True
          DefaultColWidth = 24
          DefaultRowHeight = 14
          Enabled = False
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
          ParentCtl3D = False
          TabOrder = 0
          OnSelectCell = sgChairsSelectCell
          ColWidths = (
            24
            27
            144
            71
            78
            86
            49)
        end
      end
      object Panel2: TPanel
        Left = 499
        Top = 1
        Width = 157
        Height = 460
        Align = alRight
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 1
        object lbQualifyUser: TLabel
          Left = 13
          Top = 138
          Width = 62
          Height = 13
          Caption = 'Answer Type'
        end
        object lbCharacterUser: TLabel
          Left = 12
          Top = 178
          Width = 46
          Height = 13
          Caption = 'Character'
        end
        object cbUserQualify: TComboBox
          Left = 10
          Top = 152
          Width = 137
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 1
          TabOrder = 0
          Text = 'Compute '
          Items.Strings = (
            'Random'
            'Compute '
            'Cheater')
        end
        object cbUserCharacter: TComboBox
          Left = 10
          Top = 192
          Width = 137
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 1
          TabOrder = 1
          Text = 'Normal'
          Items.Strings = (
            'Cautious'
            'Normal'
            'Aggressive')
        end
        object TrackBarUserMoney: TTrackBar
          Left = 3
          Top = 253
          Width = 150
          Height = 22
          Max = 5000
          Min = 10
          Position = 1000
          TabOrder = 2
          OnChange = TrackBarUserMoneyChange
        end
        object leUserMoney: TLabeledEdit
          Left = 10
          Top = 234
          Width = 136
          Height = 21
          EditLabel.Width = 84
          EditLabel.Height = 13
          EditLabel.Caption = 'Money (Sit Down)'
          LabelSpacing = 0
          TabOrder = 3
          Text = '1000'
        end
        object btSitDown: TButton
          Left = 12
          Top = 354
          Width = 135
          Height = 25
          Caption = 'Sit Down User'
          TabOrder = 4
          OnClick = btSitDownClick
        end
        object btLeaveTableGamer: TButton
          Left = 11
          Top = 46
          Width = 135
          Height = 25
          Caption = 'Leave Table Gamer'
          TabOrder = 5
          OnClick = btLeaveTableGamerClick
        end
        object btLeaveTableWatcher: TButton
          Left = 12
          Top = 390
          Width = 135
          Height = 25
          Caption = 'Leave Table Watcher'
          TabOrder = 6
          OnClick = btLeaveTableWatcherClick
        end
        object btSetUpGamer: TButton
          Left = 11
          Top = 17
          Width = 135
          Height = 25
          Caption = 'Setup Gamer'
          TabOrder = 7
          OnClick = btSetUpGamerClick
        end
        object btSetUpWatcher: TButton
          Left = 13
          Top = 319
          Width = 135
          Height = 25
          Caption = 'Setup Watcher'
          TabOrder = 8
          OnClick = btSetUpWatcherClick
        end
      end
    end
    object PanelCheckers: TPanel
      Left = 1
      Top = 1
      Width = 657
      Height = 84
      Align = alTop
      TabOrder = 1
      object Label2: TLabel
        Left = 11
        Top = 56
        Width = 92
        Height = 13
        Caption = 'Select current table'
      end
      object btAllocateAllWatchers: TButton
        Left = 12
        Top = 9
        Width = 111
        Height = 25
        Caption = 'Allocate All Watchers'
        TabOrder = 0
        OnClick = btAllocateAllWatchersClick
      end
      object btLeaveTableAll: TButton
        Left = 133
        Top = 8
        Width = 111
        Height = 25
        Caption = 'Leave Table All'
        TabOrder = 1
        OnClick = btLeaveTableAllClick
      end
      object btRefresh: TButton
        Left = 457
        Top = 48
        Width = 89
        Height = 25
        Caption = 'Refresh Now'
        TabOrder = 2
        OnClick = btRefreshClick
      end
      object cbCurrTable: TComboBox
        Left = 109
        Top = 52
        Width = 332
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 3
        OnSelect = cbCurrTableSelect
      end
    end
  end
end
