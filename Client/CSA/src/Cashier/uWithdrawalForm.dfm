object WithdrawalForm: TWithdrawalForm
  Left = 279
  Top = 189
  AutoScroll = False
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'BikiniPoker-Cash out'
  ClientHeight = 289
  ClientWidth = 381
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BackgroundPanel: TTeHeaderPanel
    Left = 0
    Top = 0
    Width = 381
    Height = 289
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
    object TeLabel1: TTeLabel
      Left = 49
      Top = 195
      Width = 203
      Height = 13
      Performance = kspNoBuffer
      Alignment = taRightJustify
      Caption = 'Total currently available to be cashed out:'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TeLabel2: TTeLabel
      Left = 106
      Top = 216
      Width = 135
      Height = 13
      Performance = kspNoBuffer
      Caption = 'Enter amount to cash out: $'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
    end
    object TeLabel4: TTeLabel
      Left = 15
      Top = 7
      Width = 333
      Height = 65
      Performance = kspNoBuffer
      Caption = 
        'Cash outs can be received in one of four ways: VISA credit, Fire' +
        'Pay, NETeller or check. VISA credit will be used up to the amoun' +
        't of your original VISA purchase. We will attempt to process Mas' +
        'terCard credits. If that is not possible, the cash out will be s' +
        'ent to you via another method.'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
      WordWrap = True
    end
    object TeLabel5: TTeLabel
      Left = 15
      Top = 77
      Width = 347
      Height = 26
      Performance = kspNoBuffer
      Caption = 
        'We process cash outs to FirePay and NETeller accounts each day. ' +
        'From there, you may direct the funds electronically to your bank' +
        ' account.'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
      WordWrap = True
    end
    object TeLabel6: TTeLabel
      Left = 15
      Top = 110
      Width = 357
      Height = 26
      Performance = kspNoBuffer
      Caption = 
        'For check delivery, please allow up to 15 business days. Checks ' +
        'will not be issued for amounts less than $50.00 and are limited ' +
        'to one per week.'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
      WordWrap = True
    end
    object TeLabel7: TTeLabel
      Left = 15
      Top = 144
      Width = 241
      Height = 39
      Performance = kspNoBuffer
      Caption = 
        'If you think you may deposit money over the coming weeks, please' +
        ' consider leaving the money in your account.'
      Color = clBtnFace
      ParentColor = False
      ThemeObject = 'Label'
      WordWrap = True
    end
    object MoneyAvailableLabel: TLabel
      Left = 256
      Top = 194
      Width = 34
      Height = 16
      Caption = '$ 0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object WithdrawalButton: TTeButton
      Left = 117
      Top = 257
      Width = 170
      Height = 25
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = WithdrawalButtonClick
      BlackAndWhiteGlyph = False
      Caption = 'Submit cash out request'
      ThemeObject = 'default'
      TabOrder = 0
      WordWrap = False
    end
    object CancelButton: TTeButton
      Left = 295
      Top = 257
      Width = 80
      Height = 25
      Cursor = crHandPoint
      Performance = kspDoubleBuffer
      OnClick = CancelButtonClick
      BlackAndWhiteGlyph = False
      Caption = 'Cancel'
      ThemeObject = 'default'
      TabOrder = 1
      WordWrap = False
    end
    object AmountEdit: TTeEdit
      Tag = 20
      Left = 266
      Top = 213
      Width = 71
      Height = 23
      Cursor = crIBeam
      Performance = kspNoBuffer
      OnKeyPress = AmountEditKeyPress
      AutoSize = True
      BevelSides = [kbsLeft, kbsTop, kbsRight, kbsBottom]
      BevelInner = kbvLowered
      BevelOuter = kbvLowered
      BevelKind = kbkSingle
      BevelWidth = 1
      BorderWidth = 3
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      PasswordKind = pkNone
      ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
      TabOrder = 2
      ThemeObject = 'default'
    end
  end
end
