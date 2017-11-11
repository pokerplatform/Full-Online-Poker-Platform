object PasswordForm: TPasswordForm
  Left = 364
  Top = 237
  Width = 273
  Height = 139
  Caption = 'BikiniPoker - Password'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 223
    Height = 13
    Caption = 'Please enter password to register in tournament'
  end
  object PasswordEdit: TEdit
    Left = 48
    Top = 40
    Width = 169
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
    OnKeyDown = PasswordEditKeyDown
  end
  object OkButon: TButton
    Left = 96
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 1
    OnClick = OkButonClick
  end
end
