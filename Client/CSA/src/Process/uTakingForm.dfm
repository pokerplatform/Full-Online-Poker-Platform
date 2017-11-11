object TakingForm: TTakingForm
  Left = 327
  Top = 330
  AutoScroll = False
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'BikiniPoker'
  ClientHeight = 100
  ClientWidth = 350
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
  object StatusLabel: TTeLabel
    Left = 0
    Top = 62
    Width = 350
    Height = 38
    Performance = kspNoBuffer
    Align = alBottom
    AutoSize = False
    Caption = 'StatusLabel'
    Color = clBtnFace
    ParentColor = False
    Layout = tlBottom
    ThemeObject = 'BoldLabel'
    WordWrap = True
  end
  object BackgroundPanel: TTeHeaderPanel
    Left = 0
    Top = 0
    Width = 347
    Height = 65
    Performance = kspNoBuffer
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
    ThemeObject = 'CopyOfConfirmMessagePanel'
    NormalHeight = {00000000}
  end
end
