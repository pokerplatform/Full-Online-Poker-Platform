object TournamentInfoForm: TTournamentInfoForm
  Left = 311
  Top = 107
  Width = 448
  Height = 537
  Caption = 'BikiniPoker - Tournament Info'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 320
    Top = 18
    Width = 68
    Height = 13
    Caption = 'Starting Chips:'
  end
  object StartingChipsCountLabel: TLabel
    Left = 400
    Top = 18
    Width = 21
    Height = 13
    Alignment = taRightJustify
    Caption = 'data'
  end
  object Label3: TLabel
    Left = 16
    Top = 18
    Width = 79
    Height = 13
    Caption = 'Betting Structure'
  end
  object LevelsListView: TListView
    Left = 16
    Top = 40
    Width = 409
    Height = 281
    Color = clWhite
    Columns = <
      item
        Width = 0
      end
      item
        Alignment = taCenter
        Caption = 'Level'
      end
      item
        Alignment = taCenter
        Caption = 'Blinds'
        Width = 210
      end
      item
        Alignment = taCenter
        Caption = 'Ante'
        Width = 70
      end
      item
        Alignment = taCenter
        Caption = 'Minutes'
        Width = 55
      end>
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object PrizesListView: TListView
    Left = 16
    Top = 344
    Width = 409
    Height = 121
    Color = clWhite
    Columns = <
      item
        Width = 0
      end
      item
        Alignment = taCenter
        Caption = 'Place'
        Width = 80
      end
      item
        Alignment = taCenter
        Caption = 'Award'
        Width = 323
      end>
    FlatScrollBars = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
  end
  object CloseButton: TButton
    Left = 184
    Top = 477
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 2
    OnClick = CloseButtonClick
  end
end
