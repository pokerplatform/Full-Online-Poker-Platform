object WelcomeMessageForm: TWelcomeMessageForm
  Left = 246
  Top = 176
  AutoScroll = False
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'BikiniPoker-Welcome Message'
  ClientHeight = 346
  ClientWidth = 465
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Ok: TTeButton
    Left = 159
    Top = 312
    Width = 134
    Height = 25
    Performance = kspDoubleBuffer
    OnClick = OkClick
    BlackAndWhiteGlyph = False
    Caption = 'Ok'
    ThemeObject = 'default'
    TabOrder = 0
    WordWrap = False
  end
  object MessageBrowser: TWebBrowser
    Left = 7
    Top = 5
    Width = 450
    Height = 300
    TabOrder = 1
    OnBeforeNavigate2 = MessageBrowserBeforeNavigate2
    OnNavigateComplete2 = MessageBrowserNavigateComplete2
    ControlData = {
      4C000000822E0000021F00000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object DonShowtCheckBox: TTeCheckBox
    Left = 9
    Top = 312
    Width = 137
    Height = 20
    Performance = kspDoubleBuffer
    Visible = False
    OnClick = DonShowtCheckBoxClick
    Caption = 'Don'#39't show next time'
    AllowGrayed = False
    Alignment = kalLeftJustify
    Checked = False
    Spacing = 5
    State = kcbsUnChecked
    ThemeObject = 'default'
    TabOrder = 2
    Transparent = True
    WordWrap = False
  end
end
