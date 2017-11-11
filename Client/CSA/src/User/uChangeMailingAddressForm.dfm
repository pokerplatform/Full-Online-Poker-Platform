object ChangeMailingAddressForm: TChangeMailingAddressForm
  Left = 343
  Top = 181
  AutoScroll = False
  BorderIcons = [biMinimize]
  Caption = 'BikiniPoker-Change mailing address'
  ClientHeight = 345
  ClientWidth = 283
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object TeLabel10: TTeLabel
    Left = 8
    Top = 8
    Width = 193
    Height = 13
    Performance = kspNoBuffer
    Caption = ' Enter your updated address information: '
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'BoldLabel'
  end
  object TeLabel2: TTeLabel
    Left = 54
    Top = 32
    Width = 46
    Height = 13
    Performance = kspNoBuffer
    Caption = 'Player ID:'
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'Label'
  end
  object TeLabel3: TTeLabel
    Left = 48
    Top = 57
    Width = 51
    Height = 13
    Performance = kspNoBuffer
    Caption = 'First name:'
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'Label'
  end
  object TeLabel4: TTeLabel
    Left = 23
    Top = 107
    Width = 75
    Height = 13
    Performance = kspNoBuffer
    Caption = 'Address (line 1):'
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'Label'
  end
  object TeLabel5: TTeLabel
    Left = 23
    Top = 132
    Width = 75
    Height = 13
    Performance = kspNoBuffer
    Caption = 'Address (line 2):'
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'Label'
  end
  object TeLabel1: TTeLabel
    Left = 79
    Top = 157
    Width = 20
    Height = 13
    Performance = kspNoBuffer
    Caption = 'City:'
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'Label'
  end
  object TeLabel6: TTeLabel
    Left = 6
    Top = 232
    Width = 95
    Height = 13
    Performance = kspNoBuffer
    Caption = 'or non-US province:'
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'Label'
  end
  object TeLabel7: TTeLabel
    Left = 59
    Top = 182
    Width = 39
    Height = 13
    Performance = kspNoBuffer
    Caption = 'Country:'
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'Label'
  end
  object TeLabel8: TTeLabel
    Left = 23
    Top = 257
    Width = 80
    Height = 13
    Performance = kspNoBuffer
    Caption = 'ZIP/postal code:'
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'Label'
  end
  object TeLabel9: TTeLabel
    Left = 29
    Top = 282
    Width = 72
    Height = 13
    Performance = kspNoBuffer
    Caption = 'Phone number:'
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'Label'
  end
  object TeLabel11: TTeLabel
    Left = 49
    Top = 82
    Width = 52
    Height = 13
    Performance = kspNoBuffer
    Caption = 'Last name:'
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'Label'
  end
  object TeLabel12: TTeLabel
    Left = 72
    Top = 207
    Width = 28
    Height = 13
    Performance = kspNoBuffer
    Caption = 'State:'
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'Label'
  end
  object PlayerIDLabel: TTeLabel
    Left = 110
    Top = 32
    Width = 43
    Height = 13
    Performance = kspNoBuffer
    Caption = 'Player ID'
    Color = clBtnFace
    ParentColor = False
    ThemeObject = 'BoldLabel'
  end
  object FirstNameEdit: TTeEdit
    Tag = 50
    Left = 108
    Top = 53
    Width = 170
    Height = 23
    Cursor = crIBeam
    Performance = kspNoBuffer
    OnKeyPress = PlayerIDEditKeyPress
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
    ParentFont = False
    PasswordKind = pkNone
    ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
    TabOrder = 0
    ThemeObject = 'default'
  end
  object Address1Edit: TTeEdit
    Tag = 50
    Left = 108
    Top = 103
    Width = 170
    Height = 23
    Cursor = crIBeam
    Performance = kspNoBuffer
    OnKeyPress = PlayerIDEditKeyPress
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
    ParentFont = False
    PasswordKind = pkNone
    ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
    TabOrder = 2
    ThemeObject = 'default'
  end
  object Address2Edit: TTeEdit
    Tag = 50
    Left = 108
    Top = 128
    Width = 170
    Height = 23
    Cursor = crIBeam
    Performance = kspNoBuffer
    OnKeyPress = PlayerIDEditKeyPress
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
    ParentFont = False
    PasswordKind = pkNone
    ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
    TabOrder = 3
    ThemeObject = 'default'
  end
  object CityEdit: TTeEdit
    Tag = 50
    Left = 108
    Top = 153
    Width = 170
    Height = 23
    Cursor = crIBeam
    Performance = kspNoBuffer
    OnKeyPress = PlayerIDEditKeyPress
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
    ParentFont = False
    PasswordKind = pkNone
    ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
    TabOrder = 4
    ThemeObject = 'default'
  end
  object ProvinceEdit: TTeEdit
    Tag = 50
    Left = 108
    Top = 228
    Width = 170
    Height = 23
    Cursor = crIBeam
    Performance = kspNoBuffer
    OnKeyPress = PlayerIDEditKeyPress
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
    ParentFont = False
    PasswordKind = pkNone
    ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
    TabOrder = 7
    ThemeObject = 'default'
  end
  object ZIPEdit: TTeEdit
    Tag = 50
    Left = 108
    Top = 253
    Width = 170
    Height = 23
    Cursor = crIBeam
    Performance = kspNoBuffer
    OnKeyPress = PlayerIDEditKeyPress
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
    ParentFont = False
    PasswordKind = pkNone
    ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
    TabOrder = 8
    ThemeObject = 'default'
  end
  object PhoneEdit: TTeEdit
    Tag = 50
    Left = 108
    Top = 278
    Width = 170
    Height = 23
    Cursor = crIBeam
    Performance = kspNoBuffer
    OnKeyUp = PhoneEditKeyUp
    OnKeyPress = PlayerIDEditKeyPress
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
    ParentFont = False
    PasswordKind = pkNone
    ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
    TabOrder = 9
    ThemeObject = 'default'
  end
  object CountryComboBox1: TTeComboBox
    Left = 108
    Top = 178
    Width = 170
    Height = 19
    Cursor = crIBeam
    Performance = kspNoBuffer
    Visible = False
    AutoSelect = False
    AutoSize = True
    BevelSides = [kbsLeft, kbsTop, kbsRight, kbsBottom]
    BevelInner = kbvNone
    BevelOuter = kbvNone
    BevelKind = kbkNone
    BevelWidth = 1
    BorderWidth = 3
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    PasswordKind = pkNone
    ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
    ReadOnly = True
    TabOrder = 5
    ThemeObject = 'SimpComboBox'
    OnChange = CountryComboBox1Change
    AutoComplete = False
    ComboStyle = kcsDropDown
    DropDownCount = 8
    ItemHeight = 15
    Flat = False
    ItemIndex = -1
    ListStyle = lbStandard
    ShowCheckBoxes = False
    WordWrap = False
  end
  object LastNameEdit: TTeEdit
    Tag = 50
    Left = 108
    Top = 78
    Width = 170
    Height = 23
    Cursor = crIBeam
    Performance = kspNoBuffer
    OnKeyPress = PlayerIDEditKeyPress
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
    ParentFont = False
    PasswordKind = pkNone
    ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
    TabOrder = 1
    ThemeObject = 'default'
  end
  object StateComboBox1: TTeComboBox
    Left = 108
    Top = 203
    Width = 170
    Height = 19
    Cursor = crIBeam
    Performance = kspNoBuffer
    Visible = False
    AutoSelect = False
    AutoSize = True
    BevelSides = [kbsLeft, kbsTop, kbsRight, kbsBottom]
    BevelInner = kbvNone
    BevelOuter = kbvNone
    BevelKind = kbkNone
    BevelWidth = 1
    BorderWidth = 3
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    PasswordKind = pkNone
    ContextMenuOptions.Animation.EffectKind = '[ RANDOM ] - Random selection'
    ReadOnly = True
    TabOrder = 6
    ThemeObject = 'SimpComboBox'
    OnChange = StateComboBox1Change
    AutoComplete = False
    ComboStyle = kcsDropDown
    DropDownCount = 8
    ItemHeight = 15
    Flat = False
    ItemIndex = -1
    ListStyle = lbStandard
    ShowCheckBoxes = False
    WordWrap = False
  end
  object CancelButton: TTeButton
    Left = 196
    Top = 313
    Width = 80
    Height = 23
    Cursor = crHandPoint
    Performance = kspDoubleBuffer
    OnClick = CancelButtonClick
    BlackAndWhiteGlyph = False
    Caption = 'Cancel'
    ThemeObject = 'default'
    TabOrder = 11
    WordWrap = False
  end
  object SaveButton: TTeButton
    Left = 110
    Top = 313
    Width = 80
    Height = 23
    Cursor = crHandPoint
    Performance = kspDoubleBuffer
    OnClick = SaveButtonClick
    BlackAndWhiteGlyph = False
    Caption = 'Save'
    ThemeObject = 'default'
    TabOrder = 10
    WordWrap = False
  end
  object CountryComboBox: TComboBox
    Left = 109
    Top = 177
    Width = 173
    Height = 21
    ItemHeight = 13
    TabOrder = 12
    OnChange = CountryComboBox1Change
  end
  object StateComboBox: TComboBox
    Left = 109
    Top = 202
    Width = 173
    Height = 21
    ItemHeight = 13
    TabOrder = 13
    OnChange = StateComboBox1Change
  end
end
