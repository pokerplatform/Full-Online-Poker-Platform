object ChangePlayerLogoForm: TChangePlayerLogoForm
  Left = 235
  Top = 212
  AutoScroll = False
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'BikiniPoker-Change player logo...'
  ClientHeight = 385
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ShockwaveFlash: TShockwaveFlash
    Left = 0
    Top = 0
    Width = 400
    Height = 385
    TabOrder = 0
    OnFSCommand = ShockwaveFlashFSCommand
    ControlData = {
      675566550003000057290000CA270000080002000000000008000E0000005700
      69006E0064006F007700000008000E000000570069006E0064006F0077000000
      08000E0000004F007000610071007500650000000B0000000B00000008000A00
      00004800690067006800000008000200000000000B0000000800020000000000
      08000E00000061006C00770061007900730000000800100000004E006F005300
      630061006C00650000000B0000000B0000000800020000000000080002000000
      000008000200000000000D00000000000000000000000000000000000B000100}
  end
  object TimeOutTimer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = TimeOutTimerTimer
    Left = 40
    Top = 8
  end
end
