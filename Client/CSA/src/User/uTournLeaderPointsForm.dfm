object TournLeaderPointsForm: TTournLeaderPointsForm
  Left = 300
  Top = 211
  Width = 308
  Height = 206
  Caption = 'BikiniPoker-Tournament Leader Points'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ErrorLabel: TLabel
    Left = 88
    Top = 112
    Width = 3
    Height = 13
  end
  object Label1: TLabel
    Left = 19
    Top = 45
    Width = 23
    Height = 13
    Caption = 'From'
  end
  object Label2: TLabel
    Left = 24
    Top = 92
    Width = 13
    Height = 13
    Caption = 'To'
  end
  object FromMonthBox: TComboBox
    Left = 48
    Top = 40
    Width = 81
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    OnChange = FromMonthBoxChange
    Items.Strings = (
      'January'
      'February'
      'March'
      'April'
      'May'
      'June'
      'July'
      'August'
      'September'
      'October'
      'Novermber'
      'December')
  end
  object FromDayBox: TComboBox
    Left = 136
    Top = 40
    Width = 49
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    OnChange = FromMonthBoxChange
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12'
      '13'
      '14'
      '15'
      '16'
      '17'
      '18'
      '19'
      '20'
      '21'
      '22'
      '23'
      '24'
      '25'
      '26'
      '27'
      '28'
      '29'
      '30'
      '31')
  end
  object FromYearBox: TComboBox
    Left = 200
    Top = 40
    Width = 65
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    OnChange = FromMonthBoxChange
  end
  object ToMonthBox: TComboBox
    Left = 48
    Top = 88
    Width = 81
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    OnChange = FromMonthBoxChange
    Items.Strings = (
      'January'
      'February'
      'March'
      'April'
      'May'
      'June'
      'July'
      'August'
      'September'
      'October'
      'Novermber'
      'December')
  end
  object ToDayBox: TComboBox
    Left = 136
    Top = 88
    Width = 49
    Height = 21
    ItemHeight = 13
    TabOrder = 4
    OnChange = FromMonthBoxChange
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12'
      '13'
      '14'
      '15'
      '16'
      '17'
      '18'
      '19'
      '20'
      '21'
      '22'
      '23'
      '24'
      '25'
      '26'
      '27'
      '28'
      '29'
      '30'
      '31')
  end
  object ToYearBox: TComboBox
    Left = 200
    Top = 88
    Width = 65
    Height = 21
    ItemHeight = 13
    TabOrder = 5
    OnChange = FromMonthBoxChange
  end
  object OkButton: TButton
    Left = 48
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 6
    OnClick = OkButtonClick
  end
  object CanceButton: TButton
    Left = 178
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 7
    OnClick = CanceButtonClick
  end
end
