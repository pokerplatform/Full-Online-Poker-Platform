object SettingsForm: TSettingsForm
  Left = 216
  Top = 107
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Settings'
  ClientHeight = 550
  ClientWidth = 526
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object EditButton: TSpeedButton
    Left = 353
    Top = 518
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Caption = 'Edit'
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = EditButtonClick
  end
  object CancelButton: TSpeedButton
    Left = 441
    Top = 518
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Caption = 'Cancel'
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = CancelButtonClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 510
    Height = 113
    Caption = ' Connection '
    TabOrder = 0
    object HostEdit: TLabeledEdit
      Left = 10
      Top = 32
      Width = 255
      Height = 21
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Ctl3D = True
      EditLabel.Width = 59
      EditLabel.Height = 13
      EditLabel.Caption = 'Server Host:'
      ParentCtl3D = False
      TabOrder = 0
      OnKeyUp = HostEditKeyUp
    end
    object PortEdit: TLabeledEdit
      Left = 272
      Top = 32
      Width = 72
      Height = 21
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Ctl3D = True
      EditLabel.Width = 56
      EditLabel.Height = 13
      EditLabel.Caption = 'Server Port:'
      ParentCtl3D = False
      TabOrder = 1
      OnKeyUp = HostEditKeyUp
    end
    object KeepConnectedCheckBox: TCheckBox
      Left = 354
      Top = 27
      Width = 146
      Height = 17
      Caption = 'Reconnect on disconnect'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 2
      OnKeyUp = HostEditKeyUp
    end
    object SSLCheckBox: TCheckBox
      Left = 354
      Top = 9
      Width = 139
      Height = 17
      Caption = 'Use SSL/TLS encryption'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 3
      OnKeyUp = HostEditKeyUp
    end
    object NewEdit: TLabeledEdit
      Left = 316
      Top = 58
      Width = 28
      Height = 21
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Ctl3D = True
      EditLabel.Width = 303
      EditLabel.Height = 13
      EditLabel.Caption = 'Number of bots attempted to connect to server at the same time:'
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 4
      OnKeyPress = NumberEditKeyPress
      OnKeyUp = HostEditKeyUp
    end
    object MaximumWorkTimeEdit: TLabeledEdit
      Left = 153
      Top = 81
      Width = 61
      Height = 21
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Ctl3D = True
      EditLabel.Width = 140
      EditLabel.Height = 13
      EditLabel.Caption = 'Maximum work time (minutes):'
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 5
      OnKeyPress = NumberEditKeyPress
      OnKeyUp = HostEditKeyUp
    end
    object StopCheckBox: TCheckBox
      Left = 221
      Top = 83
      Width = 109
      Height = 17
      Caption = 'Stop on time out'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 6
      OnKeyUp = HostEditKeyUp
    end
    object StartCheckBox: TCheckBox
      Left = 336
      Top = 83
      Width = 168
      Height = 17
      Caption = 'Start new instance on time out'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 7
      OnKeyUp = HostEditKeyUp
    end
    object CompressTrafficCheckBox: TCheckBox
      Left = 354
      Top = 46
      Width = 105
      Height = 17
      Caption = 'Compress traffic'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 8
      OnKeyUp = HostEditKeyUp
    end
    object LoggingCheckBox: TCheckBox
      Left = 354
      Top = 65
      Width = 105
      Height = 17
      Caption = 'Logging'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 9
      OnKeyUp = HostEditKeyUp
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 129
    Width = 510
    Height = 219
    Caption = ' Auto-play '
    TabOrder = 1
    object AutoJoinNumberEdit: TLabeledEdit
      Left = 10
      Top = 32
      Width = 61
      Height = 21
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Ctl3D = True
      EditLabel.Width = 139
      EditLabel.Height = 13
      EditLabel.Caption = 'Number of bots to take seats:'
      ParentCtl3D = False
      TabOrder = 0
      Text = '2'
      OnKeyPress = NumberEditKeyPress
      OnKeyUp = HostEditKeyUp
    end
    object AutoJoinGamersEdit: TLabeledEdit
      Left = 10
      Top = 74
      Width = 61
      Height = 21
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Ctl3D = True
      EditLabel.Width = 235
      EditLabel.Height = 13
      EditLabel.Caption = 'Maximum number of gamers at a table to sit down:'
      ParentCtl3D = False
      TabOrder = 1
      OnKeyPress = NumberEditKeyPress
      OnKeyUp = HostEditKeyUp
    end
    object TimeOutForSitDownEdit: TLabeledEdit
      Left = 285
      Top = 32
      Width = 61
      Height = 21
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Ctl3D = True
      EditLabel.Width = 172
      EditLabel.Height = 13
      EditLabel.Caption = 'Timeout between enter and sit (sec):'
      ParentCtl3D = False
      TabOrder = 2
      OnKeyPress = NumberEditKeyPress
      OnKeyUp = HostEditKeyUp
    end
    object TimeOutOnResponseBotEdit: TLabeledEdit
      Left = 285
      Top = 74
      Width = 61
      Height = 21
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Ctl3D = True
      EditLabel.Width = 159
      EditLabel.Height = 13
      EditLabel.Caption = 'Maximum bot response time (sec):'
      ParentCtl3D = False
      TabOrder = 3
      OnKeyPress = NumberEditKeyPress
      OnKeyUp = HostEditKeyUp
    end
    object TimeOutOnRefreshEdit: TLabeledEdit
      Left = 285
      Top = 114
      Width = 61
      Height = 21
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Ctl3D = True
      EditLabel.Width = 88
      EditLabel.Height = 13
      EditLabel.Caption = 'Refresh time (sec):'
      ParentCtl3D = False
      TabOrder = 4
      OnKeyPress = NumberEditKeyPress
      OnKeyUp = HostEditKeyUp
    end
    object AutoLeaveBotOnGamersEdit: TLabeledEdit
      Left = 10
      Top = 114
      Width = 61
      Height = 21
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Ctl3D = True
      EditLabel.Width = 234
      EditLabel.Height = 13
      EditLabel.Caption = 'Minimum number of gamers at a table to stand up:'
      ParentCtl3D = False
      TabOrder = 5
      OnKeyPress = NumberEditKeyPress
      OnKeyUp = HostEditKeyUp
    end
    object ManyTablesPlayCheckBox: TCheckBox
      Left = 11
      Top = 142
      Width = 190
      Height = 17
      Caption = 'Allow bots to play in many tables'
      TabOrder = 6
    end
    object RestrictByNamesCheckBox: TCheckBox
      Left = 11
      Top = 166
      Width = 318
      Height = 17
      Caption = 
        'Restrict bots to sit to the tables with gamers name started with' +
        ':'
      TabOrder = 7
    end
    object RestrictedNamesEdit: TEdit
      Left = 326
      Top = 164
      Width = 174
      Height = 21
      BevelInner = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      TabOrder = 8
      Text = 'Computer'
      OnKeyUp = HostEditKeyUp
    end
    object ActionDispatcherListEdit: TLabeledEdit
      Left = 190
      Top = 188
      Width = 310
      Height = 21
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Ctl3D = True
      EditLabel.Width = 176
      EditLabel.Height = 13
      EditLabel.Caption = 'List of supported ActionDispatcherID:'
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 9
      OnKeyUp = HostEditKeyUp
    end
    object UseHeadersCheckBox: TCheckBox
      Left = 285
      Top = 141
      Width = 206
      Height = 17
      Caption = 'Use headers instead full XML packets'
      TabOrder = 10
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 356
    Width = 510
    Height = 153
    Caption = ' Event notifications '
    TabOrder = 2
    object Label1: TLabel
      Left = 247
      Top = 21
      Width = 37
      Height = 13
      Caption = 'Mail list:'
    end
    object MailListMemo: TMemo
      Left = 246
      Top = 36
      Width = 252
      Height = 104
      BevelInner = bvNone
      BevelKind = bkFlat
      BorderStyle = bsNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
      WordWrap = False
    end
    object ResponseTimeOutProcessesEdit: TLabeledEdit
      Left = 10
      Top = 37
      Width = 61
      Height = 21
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Ctl3D = True
      EditLabel.Width = 215
      EditLabel.Height = 13
      EditLabel.Caption = 'Get process list maximum response time (sec):'
      ParentCtl3D = False
      TabOrder = 1
      OnKeyPress = NumberEditKeyPress
      OnKeyUp = HostEditKeyUp
    end
    object ResponseTimeOutOnBotEntryEdit: TLabeledEdit
      Left = 10
      Top = 78
      Width = 61
      Height = 21
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Ctl3D = True
      EditLabel.Width = 209
      EditLabel.Height = 13
      EditLabel.Caption = 'Opening table maximum response time (sec):'
      ParentCtl3D = False
      TabOrder = 2
      OnKeyPress = NumberEditKeyPress
      OnKeyUp = HostEditKeyUp
    end
    object TimeOutOnHandTimelineEdit: TLabeledEdit
      Left = 10
      Top = 120
      Width = 61
      Height = 21
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Ctl3D = True
      EditLabel.Width = 140
      EditLabel.Height = 13
      EditLabel.Caption = 'Maximum hand duration (min):'
      ParentCtl3D = False
      TabOrder = 3
      OnKeyPress = NumberEditKeyPress
      OnKeyUp = HostEditKeyUp
    end
  end
end
