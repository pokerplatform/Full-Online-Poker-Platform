object TournamentModule: TTournamentModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 224
  Top = 169
  Height = 150
  Width = 269
  object FinishProcessTimer: TTimer
    Enabled = False
    Interval = 10
    OnTimer = FinishProcessTimerTimer
    Left = 48
    Top = 16
  end
  object UpdateTimer: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = UpdateTimerTimer
    Left = 160
    Top = 16
  end
  object RegisterInfoTimer: TTimer
    Enabled = False
    Interval = 11000
    OnTimer = RegisterInfoTimerTimer
    Left = 48
    Top = 72
  end
end
