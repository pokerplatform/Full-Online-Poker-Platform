object UserModule: TUserModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 438
  Top = 179
  Height = 150
  Width = 215
  object LoginActionDelayTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = LoginActionDelayTimerTimer
    Left = 56
    Top = 8
  end
end
