object CashierForm: TCashierForm
  Left = 210
  Top = 78
  AutoScroll = False
  BorderIcons = [biMinimize]
  Caption = 'BikiniPoker-Cashier'
  ClientHeight = 418
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
    Height = 418
    Performance = kspNoBuffer
    Align = alClient
    AnimateRoll = False
    BevelWidth = 0
    BorderWidth = 0
    ButtonKind = kpbkRollUp
    Caption = 'BackgroundPanel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Rolled = False
    ParentRoll = False
    ShowBevel = False
    ShowButton = False
    ShowCaption = False
    ThemeObject = 'CashierTitledFormBackground'
    NormalHeight = {00000000}
    object TeGroupBox2: TTeGroupBox
      Left = 300
      Top = 98
      Width = 207
      Height = 71
      Performance = kspNoBuffer
      CaptionMargin = 12
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Caption = ' Account status '
      CheckBoxAlignment = kalLeftJustify
      Transparent = True
      TabOrder = 0
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
        Left = 67
        Top = 30
        Width = 42
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'In play:'
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
        Top = 50
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
      Top = 170
      Width = 207
      Height = 70
      Performance = kspNoBuffer
      CaptionMargin = 12
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Caption = ' Play money status '
      CheckBoxAlignment = kalLeftJustify
      Checked = False
      Transparent = True
      TabOrder = 1
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
        Left = 67
        Top = 30
        Width = 42
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = 'In play:'
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
        Top = 50
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
      Left = 12
      Top = 385
      Width = 110
      Height = 25
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = DepositButtonClick
      BlackAndWhiteGlyph = False
      Caption = 'Buy chips'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ThemeObject = 'default'
      ParentFont = False
      TabOrder = 2
      WordWrap = False
    end
    object WithdrawalButton: TTeButton
      Left = 140
      Top = 385
      Width = 110
      Height = 25
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = WithdrawalButtonClick
      BlackAndWhiteGlyph = False
      Caption = 'Cash out'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ThemeObject = 'default'
      ParentFont = False
      TabOrder = 3
      WordWrap = False
    end
    object HistoryButton: TTeButton
      Left = 268
      Top = 385
      Width = 110
      Height = 25
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = HistoryButtonClick
      BlackAndWhiteGlyph = False
      Caption = 'Transactions History'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ThemeObject = 'default'
      ParentFont = False
      TabOrder = 4
      WordWrap = False
    end
    object TeGroupBox4: TTeGroupBox
      Left = 10
      Top = 98
      Width = 280
      Height = 269
      Performance = kspNoBuffer
      CaptionMargin = 12
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Caption = 'Player Information'
      CheckBoxAlignment = kalLeftJustify
      Checked = False
      Transparent = True
      TabOrder = 5
      UseCheckBox = False
      object TeLabel1: TTeLabel
        Left = 61
        Top = 29
        Width = 42
        Height = 13
        Performance = kspNoBuffer
        Caption = 'UserID:'
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
        Left = 109
        Top = 29
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
        Left = 68
        Top = 58
        Width = 33
        Height = 13
        Performance = kspNoBuffer
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
        Left = 109
        Top = 59
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
      object PhoneLabel: TTeLabel
        Left = 109
        Top = 106
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
      object ZIPLabel: TTeLabel
        Left = 109
        Top = 198
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
      object TeLabel8: TTeLabel
        Left = 77
        Top = 162
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
      object TeLabel5: TTeLabel
        Left = 53
        Top = 124
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
      object TeLabel4: TTeLabel
        Left = 64
        Top = 106
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
      object TeLabel3: TTeLabel
        Left = 39
        Top = 90
        Width = 63
        Height = 13
        Performance = kspNoBuffer
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
      object TeLabel21: TTeLabel
        Left = 54
        Top = 216
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
      object TeLabel16: TTeLabel
        Left = 13
        Top = 198
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
      object TeLabel12: TTeLabel
        Left = 13
        Top = 180
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
        Left = 109
        Top = 180
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
      object NameLabel: TTeLabel
        Left = 109
        Top = 90
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
      object CountryLabel: TTeLabel
        Left = 109
        Top = 216
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
      object CityLabel: TTeLabel
        Left = 109
        Top = 162
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
      object AddressLabel: TTeLabel
        Left = 109
        Top = 124
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
    end
    object TeGroupBox5: TTeGroupBox
      Left = 300
      Top = 240
      Width = 207
      Height = 74
      Performance = kspNoBuffer
      CaptionMargin = 12
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Caption = ' Bonus account status '
      CheckBoxAlignment = kalLeftJustify
      Checked = False
      Transparent = True
      TabOrder = 6
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
      object TeLabel24: TTeLabel
        Left = 75
        Top = 56
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
        Left = 114
        Top = 53
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
      Left = 354
      Top = 64
      Width = 153
      Height = 26
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = LeaveCashierButtonClick
      BlackAndWhiteGlyph = False
      Caption = 'Leave Cashier'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ThemeObject = 'default'
      ParentFont = False
      TabOrder = 7
      WordWrap = False
    end
    object FPPButton: TTeButton
      Left = 396
      Top = 385
      Width = 110
      Height = 25
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      BlackAndWhiteGlyph = False
      Caption = 'FPP Store'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ThemeObject = 'default'
      ParentFont = False
      TabOrder = 8
      WordWrap = False
    end
    object TeGroupBox1: TTeGroupBox
      Left = 300
      Top = 317
      Width = 207
      Height = 50
      Performance = kspNoBuffer
      CaptionMargin = 12
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      CheckBoxAlignment = kalLeftJustify
      Checked = False
      Transparent = True
      TabOrder = 9
      UseCheckBox = False
      object TeLabel17: TTeLabel
        Left = 23
        Top = 16
        Width = 86
        Height = 13
        Performance = kspNoBuffer
        Alignment = taRightJustify
        Caption = ' Loyality Points'
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
      object LoyalityPointsTotalLabel: TTeLabel
        Left = 114
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
  end
end
