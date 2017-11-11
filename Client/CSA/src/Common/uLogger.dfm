object Logger: TLogger
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 342
  Top = 254
  Height = 150
  Width = 215
  object SaveTimer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = SaveTimerTimer
    Left = 24
    Top = 8
  end
end
