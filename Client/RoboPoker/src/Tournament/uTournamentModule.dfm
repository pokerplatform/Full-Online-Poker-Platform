object TournamentModule: TTournamentModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 223
  Top = 168
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
end
