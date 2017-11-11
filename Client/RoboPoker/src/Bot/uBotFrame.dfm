object BotFrame: TBotFrame
  Left = 0
  Top = 0
  Width = 443
  Height = 277
  Align = alClient
  TabOrder = 0
  object PanelTables: TPanel
    Left = 0
    Top = 0
    Width = 201
    Height = 600
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object sgTables: TStringGrid
      Left = 0
      Top = 78
      Width = 201
      Height = 522
      Align = alClient
      ColCount = 2
      Ctl3D = True
      DefaultColWidth = 198
      DefaultRowHeight = 16
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
      ParentCtl3D = False
      TabOrder = 0
      OnClick = sgTablesClick
    end
    object GrBoxTablesFilter: TGroupBox
      Left = 0
      Top = 0
      Width = 201
      Height = 78
      Align = alTop
      Caption = ' Table Filters '
      TabOrder = 1
      object Label1: TLabel
        Left = 9
        Top = 20
        Width = 55
        Height = 13
        Caption = 'Poker Type'
      end
      object Label2: TLabel
        Left = 9
        Top = 50
        Width = 55
        Height = 13
        Caption = 'Stake Type'
      end
      object ComboBoxPokerType: TComboBox
        Left = 72
        Top = 17
        Width = 122
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'All '
        OnChange = ComboBoxPokerTypeChange
        Items.Strings = (
          'All '
          'Texas Hold"em'
          'Omaha '
          'Omaha Hi/Low'
          'Seven Stud'
          'Seven Stud Hi/Low')
      end
      object ComboBoxStakeType: TComboBox
        Left = 72
        Top = 46
        Width = 122
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = 'All'
        OnChange = ComboBoxStakeTypeChange
        Items.Strings = (
          'All'
          'Fixed'
          'Pot Limit'
          'No Limit')
      end
    end
  end
  object PanelInfo: TPanel
    Left = 201
    Top = 0
    Width = 599
    Height = 600
    BevelOuter = bvLowered
    TabOrder = 1
    object PanelTableInfo: TPanel
      Left = 1
      Top = 1
      Width = 597
      Height = 96
      Align = alTop
      TabOrder = 2
      object Label6: TLabel
        Left = 7
        Top = 45
        Width = 61
        Height = 13
        Caption = 'Stake Type: '
      end
      object lbTableStakeType: TLabel
        Left = 70
        Top = 45
        Width = 13
        Height = 13
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 34
        Top = 2
        Width = 34
        Height = 13
        Caption = 'Name: '
      end
      object lbTableName: TLabel
        Left = 70
        Top = 2
        Width = 13
        Height = 13
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label4: TLabel
        Left = 51
        Top = 18
        Width = 17
        Height = 13
        Caption = 'ID: '
      end
      object lbTableID: TLabel
        Left = 70
        Top = 18
        Width = 13
        Height = 13
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 38
        Top = 31
        Width = 30
        Height = 13
        Caption = 'Type: '
      end
      object lbTableType: TLabel
        Left = 70
        Top = 31
        Width = 13
        Height = 13
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label7: TLabel
        Left = 20
        Top = 60
        Width = 48
        Height = 13
        Caption = 'Currency: '
      end
      object lbTableCurrencySign: TLabel
        Left = 70
        Top = 60
        Width = 13
        Height = 13
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label9: TLabel
        Left = 184
        Top = 16
        Width = 47
        Height = 13
        Caption = 'Use Allin: '
      end
      object lbTableUseAllIn: TLabel
        Left = 234
        Top = 16
        Width = 13
        Height = 13
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label10: TLabel
        Left = 178
        Top = 30
        Width = 53
        Height = 13
        Caption = 'Min BuyIn: '
      end
      object lbTableMinBuyIn: TLabel
        Left = 234
        Top = 30
        Width = 13
        Height = 13
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbTableMaxBuyIn: TLabel
        Left = 234
        Top = 44
        Width = 13
        Height = 13
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label11: TLabel
        Left = 175
        Top = 44
        Width = 56
        Height = 13
        Caption = 'Max BuyIn: '
      end
      object Label12: TLabel
        Left = 178
        Top = 59
        Width = 53
        Height = 13
        Caption = 'Def BuyIn: '
      end
      object lbTableDefBuyIn: TLabel
        Left = 234
        Top = 59
        Width = 13
        Height = 13
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label8: TLabel
        Left = 4
        Top = 74
        Width = 64
        Height = 13
        Caption = 'Tourn. Type: '
      end
      object lbTableTournamentType: TLabel
        Left = 70
        Top = 74
        Width = 13
        Height = 13
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbTableHandID: TLabel
        Left = 382
        Top = 18
        Width = 13
        Height = 13
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label13: TLabel
        Left = 335
        Top = 18
        Width = 46
        Height = 13
        Caption = 'Hand ID: '
      end
      object Label14: TLabel
        Left = 310
        Top = 32
        Width = 71
        Height = 13
        Caption = 'Prev.Hand ID: '
      end
      object lbTablePrevHandID: TLabel
        Left = 382
        Top = 32
        Width = 13
        Height = 13
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label15: TLabel
        Left = 343
        Top = 46
        Width = 38
        Height = 13
        Caption = 'Round: '
      end
      object lbTableRound: TLabel
        Left = 382
        Top = 46
        Width = 13
        Height = 13
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label16: TLabel
        Left = 349
        Top = 61
        Width = 32
        Height = 13
        Caption = 'Rake: '
      end
      object lbTableRake: TLabel
        Left = 382
        Top = 61
        Width = 13
        Height = 13
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label20: TLabel
        Left = 171
        Top = 76
        Width = 87
        Height = 13
        Caption = 'Community Cards: '
      end
      object lbTableCards: TLabel
        Left = 261
        Top = 76
        Width = 9
        Height = 13
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object MemoTablePots: TMemo
        Left = 456
        Top = 1
        Width = 140
        Height = 94
        TabStop = False
        Align = alRight
        Alignment = taCenter
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clBtnFace
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        Lines.Strings = (
          'Pots:')
        OEMConvert = True
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
    end
    object PanelCommonInfo: TPanel
      Left = 1
      Top = 153
      Width = 597
      Height = 446
      Align = alClient
      TabOrder = 0
      object SplitterUser: TSplitter
        Left = 343
        Top = 1
        Height = 444
        Align = alRight
      end
      object Panel1: TPanel
        Left = 1
        Top = 1
        Width = 342
        Height = 444
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 0
        object Label17: TLabel
          Left = 2
          Top = 185
          Width = 338
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = 'Watchers:'
        end
        object Label18: TLabel
          Left = 2
          Top = 2
          Width = 338
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = 'Chairs:'
        end
        object sgUsers: TStringGrid
          Left = 2
          Top = 198
          Width = 338
          Height = 244
          Align = alClient
          ColCount = 4
          Ctl3D = True
          DefaultColWidth = 40
          DefaultRowHeight = 14
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
          ParentCtl3D = False
          TabOrder = 1
          OnClick = sgUsersClick
          OnDrawCell = sgUsersDrawCell
          OnEnter = sgUsersEnter
          ColWidths = (
            40
            112
            91
            86)
        end
        object sgChairs: TStringGrid
          Left = 2
          Top = 15
          Width = 338
          Height = 170
          Align = alTop
          Ctl3D = True
          DefaultColWidth = 24
          DefaultRowHeight = 14
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
          ParentCtl3D = False
          TabOrder = 0
          OnClick = sgChairsClick
          OnDrawCell = sgChairsDrawCell
          OnEnter = sgChairsEnter
          ColWidths = (
            24
            58
            24
            77
            147)
        end
      end
      object Panel2: TPanel
        Left = 346
        Top = 1
        Width = 250
        Height = 444
        Align = alRight
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 1
        object lbAvalableActionsUser: TLabel
          Left = 124
          Top = 135
          Width = 84
          Height = 13
          Alignment = taCenter
          Caption = 'Available Actions:'
          Visible = False
        end
        object Label21: TLabel
          Left = 48
          Top = 5
          Width = 17
          Height = 13
          Caption = 'ID: '
        end
        object lbUserID: TLabel
          Left = 69
          Top = 5
          Width = 13
          Height = 13
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label23: TLabel
          Left = 31
          Top = 21
          Width = 34
          Height = 13
          Caption = 'Name: '
        end
        object lbUserName: TLabel
          Left = 69
          Top = 21
          Width = 13
          Height = 13
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label25: TLabel
          Left = 133
          Top = 6
          Width = 43
          Height = 13
          Caption = 'Position: '
        end
        object lbUserPosition: TLabel
          Left = 180
          Top = 6
          Width = 13
          Height = 13
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label27: TLabel
          Left = 34
          Top = 39
          Width = 31
          Height = 13
          Caption = 'State: '
        end
        object lbUserState: TLabel
          Left = 69
          Top = 39
          Width = 13
          Height = 13
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label29: TLabel
          Left = 131
          Top = 40
          Width = 46
          Height = 13
          Caption = 'In Game: '
        end
        object lbUserInGame: TLabel
          Left = 181
          Top = 40
          Width = 13
          Height = 13
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label31: TLabel
          Left = 15
          Top = 58
          Width = 50
          Height = 13
          Caption = 'Ammount: '
        end
        object lbUserAmmount: TLabel
          Left = 69
          Top = 58
          Width = 13
          Height = 13
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label33: TLabel
          Left = 38
          Top = 75
          Width = 27
          Height = 13
          Caption = 'Bets: '
        end
        object lbUserBetsAmmount: TLabel
          Left = 69
          Top = 75
          Width = 13
          Height = 13
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label22: TLabel
          Left = 144
          Top = 58
          Width = 33
          Height = 13
          Caption = 'Is Bot: '
        end
        object lbUserIsBot: TLabel
          Left = 181
          Top = 58
          Width = 13
          Height = 13
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label26: TLabel
          Left = 118
          Top = 75
          Width = 59
          Height = 13
          Caption = 'Last Action: '
        end
        object lbUserLastAction: TLabel
          Left = 181
          Top = 75
          Width = 13
          Height = 13
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label30: TLabel
          Left = 12
          Top = 109
          Width = 33
          Height = 13
          Caption = 'Cards: '
        end
        object lbUserCards: TLabel
          Left = 49
          Top = 109
          Width = 13
          Height = 13
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lbQualifyUser: TLabel
          Left = 13
          Top = 135
          Width = 62
          Height = 13
          Caption = 'Answer Type'
          Visible = False
        end
        object lbCharacterUser: TLabel
          Left = 12
          Top = 175
          Width = 46
          Height = 13
          Caption = 'Character'
          Visible = False
        end
        object lbUserButtons: TListBox
          Left = 122
          Top = 149
          Width = 107
          Height = 80
          BevelInner = bvNone
          BevelOuter = bvNone
          Ctl3D = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 13
          Items.Strings = (
            'Sit Down'
            'Leave Table'
            'More Chips')
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
          Visible = False
        end
        object cbUserQualify: TComboBox
          Left = 10
          Top = 149
          Width = 103
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 1
          TabOrder = 1
          Text = 'Compute '
          Visible = False
          OnChange = cbUserQualifyChange
          Items.Strings = (
            'Random'
            'Compute '
            'Cheater')
        end
        object cbUserCharacter: TComboBox
          Left = 10
          Top = 189
          Width = 103
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 1
          TabOrder = 2
          Text = 'Normal'
          Visible = False
          OnChange = cbUserCharacterChange
          Items.Strings = (
            'Cautious'
            'Normal'
            'Aggressive')
        end
        object grbChat: TGroupBox
          Left = 2
          Top = 276
          Width = 246
          Height = 166
          Align = alBottom
          Caption = ' Chat '
          TabOrder = 3
          object Label19: TLabel
            Left = 7
            Top = 45
            Width = 22
            Height = 13
            Caption = 'Filter'
          end
          object leChatEnter: TLabeledEdit
            Left = 37
            Top = 16
            Width = 202
            Height = 21
            EditLabel.Width = 25
            EditLabel.Height = 13
            EditLabel.Caption = 'Enter'
            LabelPosition = lpLeft
            LabelSpacing = 6
            TabOrder = 0
            OnKeyPress = leChatEnterKeyPress
          end
          object cbChatFilter: TComboBox
            Left = 37
            Top = 41
            Width = 202
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 1
            TabOrder = 1
            Text = 'Dealer: Normal'
            OnChange = cbChatFilterChange
            Items.Strings = (
              'Dealer: Everything'
              'Dealer: Normal'
              'Dealer: Silent'
              'No Player chat'
              'Totally silent')
          end
          object MemoChat: TMemo
            Left = 2
            Top = 73
            Width = 242
            Height = 91
            Align = alBottom
            ReadOnly = True
            ScrollBars = ssBoth
            TabOrder = 2
          end
        end
        object TrackBarUserMoney: TTrackBar
          Left = 3
          Top = 250
          Width = 116
          Height = 22
          Max = 1000
          Min = 20
          Position = 100
          TabOrder = 4
          Visible = False
          OnChange = TrackBarUserMoneyChange
        end
        object leUserMoney: TLabeledEdit
          Left = 10
          Top = 231
          Width = 102
          Height = 21
          EditLabel.Width = 84
          EditLabel.Height = 13
          EditLabel.Caption = 'Money (Sit Down)'
          LabelSpacing = 0
          TabOrder = 5
          Text = '100'
          Visible = False
        end
        object btExecuteAction: TButton
          Left = 123
          Top = 231
          Width = 106
          Height = 19
          Caption = 'Execute Action'
          TabOrder = 6
          Visible = False
          OnClick = btExecuteActionClick
        end
        object pbTimeLimit: TProgressBar
          Left = 124
          Top = 253
          Width = 105
          Height = 16
          Max = 15
          TabOrder = 7
        end
      end
    end
    object PanelCheckers: TPanel
      Left = 1
      Top = 97
      Width = 597
      Height = 56
      Align = alTop
      TabOrder = 1
      object Label24: TLabel
        Left = 370
        Top = 10
        Width = 118
        Height = 13
        Caption = 'Wait On Response (Sec)'
      end
      object cbUseCustomBotAnswer: TCheckBox
        Left = 16
        Top = 25
        Width = 97
        Height = 17
        Caption = 'Custom Answer'
        TabOrder = 0
        OnClick = cbUseCustomBotAnswerClick
      end
      object btAllocateAllWatchers: TButton
        Left = 128
        Top = 24
        Width = 113
        Height = 25
        Caption = 'Allocate All Watchers'
        TabOrder = 1
        OnClick = btAllocateAllWatchersClick
      end
      object btLeaveTableAll: TButton
        Left = 246
        Top = 24
        Width = 111
        Height = 25
        Caption = 'Leave Table All'
        TabOrder = 2
        OnClick = btLeaveTableAllClick
      end
      object seWaitOnResponse: TSpinEdit
        Left = 368
        Top = 25
        Width = 121
        Height = 22
        MaxValue = 20
        MinValue = 1
        TabOrder = 3
        Value = 2
      end
    end
  end
  object TimerAnswer: TTimer
    Enabled = False
    Interval = 200
    OnTimer = TimerAnswerTimer
    Left = 48
    Top = 200
  end
end
