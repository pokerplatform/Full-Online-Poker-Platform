object WaitingListTakePlaceForm: TWaitingListTakePlaceForm
  Left = 275
  Top = 208
  AutoScroll = False
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'BikiniPoker-Waiting list'
  ClientHeight = 96
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TextLabel: TTeLabel
    Left = 75
    Top = 10
    Width = 24
    Height = 13
    Performance = kspNoBuffer
    Caption = 'text'
    Color = clBtnFace
    ParentColor = False
    Layout = tlCenter
    ThemeObject = 'BoldLabel'
    WordWrap = True
  end
  object IconPanel: TTeHeaderPanel
    Left = 10
    Top = 10
    Width = 55
    Height = 55
    Performance = kspNoBuffer
    AnimateRoll = False
    BevelWidth = 0
    BorderWidth = 0
    ButtonKind = kpbkRollUp
    Caption = 'TeHeaderPanel1'
    Rolled = False
    ParentRoll = False
    ShowBevel = False
    ShowButton = False
    ShowCaption = False
    ThemeObject = 'ConfirmMessagePanel'
    NormalHeight = {00000000}
  end
  object YesButton: TTeButton
    Left = 10
    Top = 70
    Width = 130
    Height = 25
    Cursor = crHandPoint
    Performance = kspDoubleBuffer
    OnClick = YesButtonClick
    BlackAndWhiteGlyph = False
    Caption = 'I'#39'd like that seat'
    ThemeObject = 'default'
    TabOrder = 1
    WordWrap = False
  end
  object NoButton: TTeButton
    Left = 153
    Top = 70
    Width = 130
    Height = 25
    Cursor = crHandPoint
    Performance = kspDoubleBuffer
    OnClick = NoButtonClick
    BlackAndWhiteGlyph = False
    Caption = 'Take me off list'
    ThemeObject = 'default'
    TabOrder = 2
    WordWrap = False
  end
  object HideButton: TTeButton
    Left = 296
    Top = 70
    Width = 130
    Height = 25
    Cursor = crHandPoint
    Performance = kspDoubleBuffer
    OnClick = HideButtonClick
    BlackAndWhiteGlyph = False
    Caption = 'Let me think about it'
    ThemeObject = 'default'
    TabOrder = 3
    WordWrap = False
  end
  object UpdateTimeTimer: TTimer
    Enabled = False
    OnTimer = UpdateTimeTimerTimer
    Left = 160
    Top = 8
  end
  object ShowAgainTimer: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = ShowAgainTimerTimer
    Left = 208
    Top = 8
  end
end
