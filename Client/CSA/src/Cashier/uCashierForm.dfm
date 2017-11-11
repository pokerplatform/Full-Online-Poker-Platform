object CashierForm: TCashierForm
  Left = 285
  Top = 162
  AutoScroll = False
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'Cashier'
  ClientHeight = 421
  ClientWidth = 517
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BackgroundPanel: TTeHeaderPanel
    Left = 0
    Top = 0
    Width = 517
    Height = 421
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
    ThemeObject = 'CashierTitledFormBackground'
    NormalHeight = {00000000}
    object TeGroupBox1: TTeGroupBox
      Left = 10
      Top = 195
      Width = 280
      Height = 179
      Performance = kspNoBuffer
      CaptionMargin = 0
      Caption = ' Mailing address '
      CheckBoxAlignment = kalLeftJustify
      ThemeObject = 'default'
      Transparent = True
      TabOrder = 0
      UseCheckBox = False
      object TeLabel3: TTeLabel
        Left = 42
        Top = 20
        Width = 63
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'Real name:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ThemeObject = 'WhiteBoldLabel'
      end
      object NameLabel: TTeLabel
        Left = 115
        Top = 20
        Width = 50
        Height = 13
        Performance = kspNoBuffer
        Caption = 'some data'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ThemeObject = 'default'
      end
      object TeLabel5: TTeLabel
        Left = 53
        Top = 56
        Width = 49
        Height = 13
        Performance = kspNoBuffer
        Caption = 'Address:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ThemeObject = 'WhiteBoldLabel'
      end
      object AddressLabel: TTeLabel
        Left = 115
        Top = 56
        Width = 163
        Height = 39
        Performance = kspNoBuffer
        AutoSize = False
        Caption = 'some data'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ThemeObject = 'default'
        WordWrap = True
      end
      object TeLabel8: TTeLabel
        Left = 77
        Top = 94
        Width = 25
        Height = 13
        Performance = kspNoBuffer
        Caption = 'City:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ThemeObject = 'WhiteBoldLabel'
      end
      object CityLabel: TTeLabel
        Left = 115
        Top = 94
        Width = 50
        Height = 13
        Performance = kspNoBuffer
        Caption = 'some data'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ThemeObject = 'default'
      end
      object TeLabel12: TTeLabel
        Left = 13
        Top = 112
        Width = 89
        Height = 13
        Performance = kspNoBuffer
        Caption = 'State/Province:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ThemeObject = 'WhiteBoldLabel'
      end
      object StateLabel: TTeLabel
        Left = 115
        Top = 112
        Width = 50
        Height = 13
        Performance = kspNoBuffer
        Caption = 'some data'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ThemeObject = 'default'
      end
      object TeLabel16: TTeLabel
        Left = 13
        Top = 130
        Width = 89
        Height = 13
        Performance = kspNoBuffer
        Caption = 'Zip/PostalCode:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ThemeObject = 'WhiteBoldLabel'
      end
      object ZIPLabel: TTeLabel
        Left = 115
        Top = 130
        Width = 50
        Height = 13
        Performance = kspNoBuffer
        Caption = 'some data'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ThemeObject = 'default'
      end
      object TeLabel21: TTeLabel
        Left = 54
        Top = 148
        Width = 48
        Height = 13
        Performance = kspNoBuffer
        Caption = 'Country:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ThemeObject = 'WhiteBoldLabel'
      end
      object CountryLabel: TTeLabel
        Left = 115
        Top = 148
        Width = 50
        Height = 13
        Performance = kspNoBuffer
        Caption = 'some data'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ThemeObject = 'default'
      end
      object TeLabel4: TTeLabel
        Left = 64
        Top = 38
        Width = 38
        Height = 13
        Performance = kspNoBuffer
        Caption = 'Phone:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ThemeObject = 'WhiteBoldLabel'
      end
      object PhoneLabel: TTeLabel
        Left = 115
        Top = 38
        Width = 50
        Height = 13
        Performance = kspNoBuffer
        Caption = 'some data'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ThemeObject = 'default'
      end
    end
    object TeGroupBox2: TTeGroupBox
      Left = 300
      Top = 94
      Width = 207
      Height = 70
      Performance = kspNoBuffer
      CaptionMargin = 12
      Caption = ' Account status '
      CheckBoxAlignment = kalLeftJustify
      ThemeObject = 'default'
      Transparent = True
      TabOrder = 1
      UseCheckBox = False
      object TeLabel6: TTeLabel
        Left = 115
        Top = 40
        Width = 85
        Height = 16
        Performance = kspNoBuffer
        Alignment = taRightJustify
        AutoSize = False
        Caption = '--------------'
        Color = clBtnFace
        ParentColor = False
        ThemeObject = 'BigYellowLabel'
      end
      object TeLabel7: TTeLabel
        Left = 54
        Top = 15
        Width = 55
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'Available:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ThemeObject = 'WhiteBoldLabel'
      end
      object TeLabel9: TTeLabel
        Left = 13
        Top = 30
        Width = 96
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'Currently in play:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ThemeObject = 'WhiteBoldLabel'
      end
      object MoneyAvailableLabel: TTeLabel
        Left = 115
        Top = 15
        Width = 85
        Height = 16
        Performance = kspNoBuffer
        Alignment = taRightJustify
        AutoSize = False
        Caption = '$0.00'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ThemeObject = 'BigYellowLabel'
      end
      object TeLabel19: TTeLabel
        Left = 77
        Top = 51
        Width = 32
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'Total:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ThemeObject = 'WhiteBoldLabel'
      end
      object MoneyInPlayLabel: TTeLabel
        Left = 115
        Top = 30
        Width = 85
        Height = 16
        Performance = kspNoBuffer
        Alignment = taRightJustify
        AutoSize = False
        Caption = '$0.00'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ThemeObject = 'BigYellowLabel'
      end
      object MoneyTotalLabel: TTeLabel
        Left = 115
        Top = 50
        Width = 85
        Height = 16
        Performance = kspNoBuffer
        Alignment = taRightJustify
        AutoSize = False
        Caption = '$0.00'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ThemeObject = 'BigYellowLabel'
      end
    end
    object TeGroupBox3: TTeGroupBox
      Left = 300
      Top = 242
      Width = 207
      Height = 70
      Performance = kspNoBuffer
      CaptionMargin = 12
      Caption = ' Play money status '
      CheckBoxAlignment = kalLeftJustify
      Checked = False
      ThemeObject = 'default'
      Transparent = True
      TabOrder = 2
      UseCheckBox = False
      object TeLabel18: TTeLabel
        Left = 115
        Top = 40
        Width = 85
        Height = 16
        Performance = kspNoBuffer
        Alignment = taRightJustify
        AutoSize = False
        Caption = '--------------'
        Color = clBtnFace
        ParentColor = False
        ThemeObject = 'BigYellowLabel'
      end
      object TeLabel10: TTeLabel
        Left = 54
        Top = 15
        Width = 55
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'Available:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ThemeObject = 'WhiteBoldLabel'
      end
      object TeLabel11: TTeLabel
        Left = 13
        Top = 30
        Width = 96
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'Currently in play:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ThemeObject = 'WhiteBoldLabel'
      end
      object PlayMoneyAvailableLabel: TTeLabel
        Left = 115
        Top = 15
        Width = 85
        Height = 16
        Performance = kspNoBuffer
        Alignment = taRightJustify
        AutoSize = False
        Caption = '0.00'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ThemeObject = 'BigYellowLabel'
      end
      object TeLabel14: TTeLabel
        Left = 77
        Top = 51
        Width = 32
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'Total:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ThemeObject = 'WhiteBoldLabel'
      end
      object PlayMoneyTotalLabel: TTeLabel
        Left = 115
        Top = 50
        Width = 85
        Height = 16
        Performance = kspNoBuffer
        Alignment = taRightJustify
        AutoSize = False
        Caption = '0.00'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ThemeObject = 'BigYellowLabel'
      end
      object PlayMoneyInPlayLabel: TTeLabel
        Left = 115
        Top = 30
        Width = 85
        Height = 16
        Performance = kspNoBuffer
        Alignment = taRightJustify
        AutoSize = False
        Caption = '0.00'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ThemeObject = 'BigYellowLabel'
      end
    end
    object DepositButton: TTeButton
      Left = 9
      Top = 386
      Width = 118
      Height = 25
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = DepositButtonClick
      BlackAndWhiteGlyph = False
      Caption = 'Buy chips'
      ThemeObject = 'StandardButton'
      TabOrder = 3
      WordWrap = False
    end
    object WithdrawalButton: TTeButton
      Left = 135
      Top = 386
      Width = 118
      Height = 25
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = WithdrawalButtonClick
      BlackAndWhiteGlyph = False
      Caption = 'Cash out'
      ThemeObject = 'StandardButton'
      TabOrder = 4
      WordWrap = False
    end
    object HistoryButton: TTeButton
      Left = 261
      Top = 386
      Width = 118
      Height = 25
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = HistoryButtonClick
      BlackAndWhiteGlyph = False
      Caption = 'Transactions History'
      ThemeObject = 'StandardButton'
      TabOrder = 5
      WordWrap = False
    end
    object TeGroupBox4: TTeGroupBox
      Left = 10
      Top = 93
      Width = 280
      Height = 97
      Performance = kspNoBuffer
      CaptionMargin = 12
      Caption = ' Session status  '
      CheckBoxAlignment = kalLeftJustify
      ThemeObject = 'ThemeGroupBox'
      Transparent = True
      TabOrder = 6
      UseCheckBox = False
      object TeLabel1: TTeLabel
        Left = 52
        Top = 16
        Width = 52
        Height = 13
        Performance = kspNoBuffer
        Caption = 'PlayerID:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ThemeObject = 'WhiteBoldLabel'
      end
      object PlayerIDLabel: TTeLabel
        Left = 115
        Top = 16
        Width = 50
        Height = 13
        Performance = kspNoBuffer
        Caption = 'some data'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ThemeObject = 'default'
      end
      object TeLabel2: TTeLabel
        Left = 71
        Top = 35
        Width = 33
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'Email:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ThemeObject = 'WhiteBoldLabel'
      end
      object EMailLabel: TTeLabel
        Left = 115
        Top = 35
        Width = 50
        Height = 13
        Performance = kspNoBuffer
        Caption = 'some data'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ThemeObject = 'default'
      end
      object TeLabel13: TTeLabel
        Left = 8
        Top = 54
        Width = 97
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'Last logged time:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ThemeObject = 'WhiteBoldLabel'
      end
      object LoggedTimeLabel: TTeLabel
        Left = 115
        Top = 54
        Width = 50
        Height = 13
        Performance = kspNoBuffer
        Caption = 'some data'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ThemeObject = 'default'
      end
      object TeLabel17: TTeLabel
        Left = 32
        Top = 73
        Width = 73
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'Total logged:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ThemeObject = 'WhiteBoldLabel'
      end
      object TotalLoggedLabel: TTeLabel
        Left = 115
        Top = 73
        Width = 50
        Height = 13
        Performance = kspNoBuffer
        Caption = 'some data'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ThemeObject = 'default'
      end
    end
    object TeGroupBox5: TTeGroupBox
      Left = 300
      Top = 167
      Width = 207
      Height = 70
      Performance = kspNoBuffer
      CaptionMargin = 12
      Caption = ' Bonus account status '
      CheckBoxAlignment = kalLeftJustify
      Checked = False
      ThemeObject = 'default'
      Transparent = True
      TabOrder = 7
      UseCheckBox = False
      object TeLabel15: TTeLabel
        Left = 115
        Top = 40
        Width = 85
        Height = 16
        Performance = kspNoBuffer
        Alignment = taRightJustify
        AutoSize = False
        Caption = '--------------'
        Color = clBtnFace
        ParentColor = False
        ThemeObject = 'BigYellowLabel'
      end
      object TeLabel20: TTeLabel
        Left = 54
        Top = 15
        Width = 55
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'Available:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ThemeObject = 'WhiteBoldLabel'
      end
      object TeLabel22: TTeLabel
        Left = 9
        Top = 30
        Width = 100
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'Currently on hold:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ThemeObject = 'WhiteBoldLabel'
      end
      object BonusAvailableLabel: TTeLabel
        Left = 115
        Top = 15
        Width = 85
        Height = 16
        Performance = kspNoBuffer
        Alignment = taRightJustify
        AutoSize = False
        Caption = '0.00'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ThemeObject = 'BigYellowLabel'
      end
      object TeLabel24: TTeLabel
        Left = 77
        Top = 51
        Width = 32
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'Total:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ThemeObject = 'WhiteBoldLabel'
      end
      object BonusTotalLabel: TTeLabel
        Left = 115
        Top = 49
        Width = 85
        Height = 16
        Performance = kspNoBuffer
        Alignment = taRightJustify
        AutoSize = False
        Caption = '0.00'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ThemeObject = 'BigYellowLabel'
      end
      object BonusInPlayLabel: TTeLabel
        Left = 115
        Top = 30
        Width = 85
        Height = 16
        Performance = kspNoBuffer
        Alignment = taRightJustify
        AutoSize = False
        Caption = '0.00'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ThemeObject = 'BigYellowLabel'
      end
    end
    object LeaveCashierButton: TTeButton
      Left = 6
      Top = 58
      Width = 148
      Height = 26
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = LeaveCashierButtonClick
      BlackAndWhiteGlyph = False
      Caption = 'Leave Cashier'
      ThemeObject = 'StandardButton'
      TabOrder = 8
      WordWrap = False
    end
    object TeButton1: TTeButton
      Left = 389
      Top = 386
      Width = 118
      Height = 25
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = TeButton1Click
      BlackAndWhiteGlyph = False
      Caption = 'Loyalty Store'
      ThemeObject = 'StandardButton'
      TabOrder = 9
      WordWrap = False
    end
    object TeGroupBox6: TTeGroupBox
      Left = 300
      Top = 336
      Width = 207
      Height = 38
      Performance = kspNoBuffer
      CaptionMargin = 12
      CheckBoxAlignment = kalLeftJustify
      Checked = False
      ThemeObject = 'default'
      Transparent = True
      TabOrder = 10
      UseCheckBox = False
      object TeLabel28: TTeLabel
        Left = 26
        Top = 16
        Width = 83
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'Loyalty Points:'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ThemeObject = 'WhiteBoldLabel'
      end
      object LoyalityPointsLabel: TTeLabel
        Left = 115
        Top = 16
        Width = 85
        Height = 16
        Performance = kspNoBuffer
        Alignment = taRightJustify
        AutoSize = False
        Caption = '0.00'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ThemeObject = 'BigYellowLabel'
      end
    end
    object ReloadChipsButton: TTeButton
      Left = 344
      Top = 319
      Width = 120
      Height = 18
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = ReloadChipsButtonClick
      BlackAndWhiteGlyph = False
      ThemeObject = 'ReloadOffButton'
      TabOrder = 11
      WordWrap = False
    end
  end
end
