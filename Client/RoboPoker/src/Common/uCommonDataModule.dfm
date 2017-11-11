object CommonDataModule: TCommonDataModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 72
  Top = 166
  Height = 106
  Width = 572
  object ApplicationEvents: TApplicationEvents
    OnException = ApplicationEventsException
    Left = 56
    Top = 8
  end
  object ReadTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = ReadTimerTimer
    Left = 168
    Top = 8
  end
  object RefreshTimer: TTimer
    Enabled = False
    OnTimer = RefreshTimerTimer
    Left = 272
    Top = 8
  end
  object ConnectionsTimer: TTimer
    OnTimer = ConnectionsTimerTimer
    Left = 376
    Top = 8
  end
end
