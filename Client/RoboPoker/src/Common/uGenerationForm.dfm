object GenerationForm: TGenerationForm
  Left = 281
  Top = 194
  BorderStyle = bsSingle
  Caption = 'Bot generarion'
  ClientHeight = 203
  ClientWidth = 311
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
  object ProgressLabel: TLabel
    Left = 8
    Top = 176
    Width = 67
    Height = 13
    Caption = 'ProgressLabel'
  end
  object BrowseButton: TSpeedButton
    Left = 232
    Top = 9
    Width = 70
    Height = 25
    Cursor = crHandPoint
    Caption = 'Browse...'
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = BrowseButtonClick
    OnMouseUp = FileNameEditMouseUp
  end
  object GenerateButton: TSpeedButton
    Left = 141
    Top = 171
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Caption = 'Generate'
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = GenerateButtonClick
  end
  object CancelButton: TSpeedButton
    Left = 228
    Top = 171
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
  object NameEdit: TLabeledEdit
    Left = 55
    Top = 89
    Width = 90
    Height = 21
    BevelInner = bvSpace
    BevelKind = bkFlat
    BevelOuter = bvRaised
    BorderStyle = bsNone
    Ctl3D = True
    EditLabel.Width = 31
    EditLabel.Height = 13
    EditLabel.Caption = 'Name:'
    LabelPosition = lpLeft
    ParentCtl3D = False
    TabOrder = 1
    OnKeyUp = NameEditKeyUp
    OnMouseUp = NameEditMouseUp
  end
  object MaskRadioButton: TRadioButton
    Left = 10
    Top = 69
    Width = 143
    Height = 17
    Caption = 'Generate robots by mask:'
    Checked = True
    TabOrder = 0
    TabStop = True
  end
  object FileRadioButton: TRadioButton
    Left = 10
    Top = 15
    Width = 103
    Height = 17
    Caption = 'Get info from file:'
    TabOrder = 7
  end
  object LocationEdit: TLabeledEdit
    Left = 55
    Top = 115
    Width = 90
    Height = 21
    BevelInner = bvSpace
    BevelKind = bkFlat
    BevelOuter = bvRaised
    BorderStyle = bsNone
    Ctl3D = True
    EditLabel.Width = 44
    EditLabel.Height = 13
    EditLabel.Caption = 'Location:'
    LabelPosition = lpLeft
    ParentCtl3D = False
    TabOrder = 3
    OnKeyUp = NameEditKeyUp
    OnMouseUp = NameEditMouseUp
  end
  object LocationCheckBox: TCheckBox
    Left = 209
    Top = 120
    Width = 101
    Height = 17
    Caption = 'Private location'
    TabOrder = 5
    OnKeyUp = NameEditKeyUp
    OnMouseUp = NameEditMouseUp
  end
  object FileNameEdit: TEdit
    Left = 28
    Top = 37
    Width = 275
    Height = 21
    BevelInner = bvSpace
    BevelKind = bkFlat
    BevelOuter = bvRaised
    BorderStyle = bsNone
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 8
    OnKeyUp = FileNameEditKeyUp
    OnMouseUp = FileNameEditMouseUp
  end
  object CountEdit: TLabeledEdit
    Left = 55
    Top = 141
    Width = 90
    Height = 21
    BevelInner = bvSpace
    BevelKind = bkFlat
    BevelOuter = bvRaised
    BorderStyle = bsNone
    Ctl3D = True
    EditLabel.Width = 31
    EditLabel.Height = 13
    EditLabel.Caption = 'Count:'
    LabelPosition = lpLeft
    ParentCtl3D = False
    TabOrder = 4
    OnKeyPress = NumberEditKeyPress
    OnKeyUp = NameEditKeyUp
    OnMouseUp = NameEditMouseUp
  end
  object PasswordEdit: TLabeledEdit
    Left = 209
    Top = 88
    Width = 95
    Height = 21
    BevelInner = bvSpace
    BevelKind = bkFlat
    BevelOuter = bvRaised
    BorderStyle = bsNone
    Ctl3D = True
    EditLabel.Width = 49
    EditLabel.Height = 13
    EditLabel.Caption = 'Password:'
    LabelPosition = lpLeft
    ParentCtl3D = False
    TabOrder = 2
    OnKeyUp = NameEditKeyUp
    OnMouseUp = NameEditMouseUp
  end
  object MaleCheckBox: TCheckBox
    Left = 209
    Top = 146
    Width = 45
    Height = 17
    Caption = 'Male'
    TabOrder = 6
    OnKeyUp = NameEditKeyUp
    OnMouseUp = NameEditMouseUp
  end
  object FileOpenDialog: TOpenDialog
    Left = 128
    Top = 16
  end
end
