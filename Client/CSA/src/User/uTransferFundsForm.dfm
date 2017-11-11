object TransferFundsForm: TTransferFundsForm
  Left = 367
  Top = 237
  AutoScroll = False
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'BikiniPoker-Transfer Funds'
  ClientHeight = 189
  ClientWidth = 311
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BackgroundPanel: TTeHeaderPanel
    Left = 0
    Top = 0
    Width = 311
    Height = 189
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
    ThemeObject = 'TranspPanel'
    NormalHeight = {00000000}
    object TransferCountLabel: TTeLabel
      Left = 99
      Top = 16
      Width = 48
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Transfer $'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object PlayerNameLabel: TTeLabel
      Left = 99
      Top = 58
      Width = 45
      Height = 13
      Performance = kspNoBuffer
      Caption = 'To Player'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object InfoLabel: TTeLabel
      Left = 43
      Top = 96
      Width = 229
      Height = 26
      BiDiMode = bdLeftToRight
      Performance = kspNoBuffer
      ParentBiDiMode = False
      Alignment = taCenter
      Caption = 
        'The transfer will be processed by support after a review and app' +
        'roval'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
      WordWrap = True
    end
    object PlayerNameEdit: TTeEdit
      Left = 160
      Top = 53
      Width = 121
      Height = 23
      Cursor = crIBeam
      Performance = kspDoubleBuffer
      OnKeyPress = PlayerNameEditKeyPress
      AutoSize = True
      BevelSides = [kbsLeft, kbsTop, kbsRight, kbsBottom]
      BevelInner = kbvLowered
      BevelOuter = kbvLowered
      BevelKind = kbkSingle
      BevelWidth = 1
      BorderWidth = 3
      PasswordKind = pkNone
      ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
      TabOrder = 0
      ThemeObject = 'default'
    end
    object OkButton: TTeButton
      Left = 56
      Top = 152
      Width = 75
      Height = 25
      Performance = kspDoubleBuffer
      OnClick = OkButtonClick
      BlackAndWhiteGlyph = False
      Caption = 'Ok'
      ThemeObject = 'default'
      TabOrder = 1
      WordWrap = False
    end
    object AmountEdit: TTeEdit
      Left = 160
      Top = 13
      Width = 121
      Height = 23
      Cursor = crIBeam
      Performance = kspDoubleBuffer
      OnKeyPress = AmountEditKeyPress
      AutoSize = True
      BevelSides = [kbsLeft, kbsTop, kbsRight, kbsBottom]
      BevelInner = kbvLowered
      BevelOuter = kbvLowered
      BevelKind = kbkSingle
      BevelWidth = 1
      BorderWidth = 3
      PasswordKind = pkNone
      ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
      TabOrder = 2
      Text = '10'
      ThemeObject = 'default'
    end
    object CancelButton: TTeButton
      Left = 184
      Top = 152
      Width = 75
      Height = 25
      Performance = kspDoubleBuffer
      OnClick = CancelButtonClick
      BlackAndWhiteGlyph = False
      Caption = 'Cancel'
      ThemeObject = 'default'
      TabOrder = 3
      WordWrap = False
    end
  end
end
