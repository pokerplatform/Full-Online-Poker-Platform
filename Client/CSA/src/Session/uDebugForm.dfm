object DebugForm: TDebugForm
  Left = 209
  Top = 181
  Width = 418
  Height = 395
  Caption = 'Debug'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object XMLMemo: TMemo
    Left = 0
    Top = 0
    Width = 410
    Height = 200
    Align = alClient
    Constraints.MinHeight = 200
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 200
    Width = 410
    Height = 161
    Align = alBottom
    Caption = ' Actions '
    Constraints.MinHeight = 160
    Constraints.MinWidth = 410
    TabOrder = 1
    DesignSize = (
      410
      161)
    object StatusLabel: TLabel
      Left = 328
      Top = 96
      Width = 73
      Height = 57
      Anchors = [akLeft, akTop, akRight, akBottom]
      AutoSize = False
      Caption = 'Ready...'
      WordWrap = True
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 16
      Width = 313
      Height = 65
      Caption = ' Robots '
      TabOrder = 0
      object RobotNameEdit: TLabeledEdit
        Left = 8
        Top = 36
        Width = 121
        Height = 21
        EditLabel.Width = 68
        EditLabel.Height = 13
        EditLabel.Caption = 'Robots Name:'
        TabOrder = 0
        Text = 'Robot'
      end
      object RobotQuantityEdit: TLabeledEdit
        Left = 136
        Top = 36
        Width = 73
        Height = 21
        EditLabel.Width = 79
        EditLabel.Height = 13
        EditLabel.Caption = 'Robots Quantity:'
        TabOrder = 1
        Text = '50'
      end
      object RobotsButton: TButton
        Left = 216
        Top = 34
        Width = 89
        Height = 25
        Caption = 'Create Robots'
        TabOrder = 2
        OnClick = RobotsButtonClick
      end
    end
    object GroupBox3: TGroupBox
      Left = 8
      Top = 88
      Width = 145
      Height = 65
      Caption = ' Server requests '
      TabOrder = 1
      object SrvRqstButton: TButton
        Left = 88
        Top = 32
        Width = 49
        Height = 25
        Caption = 'Go!'
        TabOrder = 0
        OnClick = SrvRqstButtonClick
      end
      object SrvRqstEdit: TLabeledEdit
        Left = 8
        Top = 36
        Width = 73
        Height = 21
        EditLabel.Width = 42
        EditLabel.Height = 13
        EditLabel.Caption = 'Quantity:'
        TabOrder = 1
        Text = '1000'
      end
    end
    object GroupBox4: TGroupBox
      Left = 158
      Top = 88
      Width = 164
      Height = 65
      Caption = ' Server responses '
      TabOrder = 2
      object SrvRspnButton: TButton
        Left = 88
        Top = 32
        Width = 67
        Height = 25
        Caption = 'Run XML'
        TabOrder = 0
        OnClick = SrvRspnButtonClick
      end
      object SrvRspnEdit: TLabeledEdit
        Left = 8
        Top = 36
        Width = 73
        Height = 21
        EditLabel.Width = 42
        EditLabel.Height = 13
        EditLabel.Caption = 'Quantity:'
        TabOrder = 1
        Text = '1'
      end
    end
    object LoadXMLButton: TButton
      Left = 328
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Load XML'
      TabOrder = 3
      OnClick = LoadXMLButtonClick
    end
    object ButtonSaveXML: TButton
      Left = 328
      Top = 56
      Width = 75
      Height = 25
      Caption = 'Save XML'
      TabOrder = 4
      OnClick = ButtonSaveXMLClick
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 'All files (*.*)|*.*'
    Left = 320
    Top = 216
  end
  object SaveDialog: TSaveDialog
    Filter = 'All files (*.*)|*.*'
    Left = 320
    Top = 248
  end
end
