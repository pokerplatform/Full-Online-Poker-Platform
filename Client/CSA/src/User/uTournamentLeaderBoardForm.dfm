object TournamentLeaderBoardForm: TTournamentLeaderBoardForm
  Left = 342
  Top = 186
  Width = 457
  Height = 395
  Caption = 'TournamentLeaderBoardForm'
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
  object PeriodLabel: TLabel
    Left = 16
    Top = 8
    Width = 3
    Height = 13
  end
  object DataListView: TListView
    Left = 16
    Top = 32
    Width = 417
    Height = 289
    Color = clBtnFace
    Columns = <
      item
        Width = 0
      end
      item
        Alignment = taCenter
        Caption = 'Place'
        MaxWidth = 50
        MinWidth = 50
      end
      item
        Alignment = taCenter
        Caption = 'Name'
        MaxWidth = 210
        MinWidth = 210
        Width = 210
      end
      item
        Alignment = taCenter
        Caption = 'Points'
        MaxWidth = 140
        MinWidth = 140
        Width = 140
      end>
    Ctl3D = False
    FlatScrollBars = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object Button1: TButton
    Left = 183
    Top = 334
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = Button1Click
  end
end
