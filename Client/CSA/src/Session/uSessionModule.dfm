object SessionModule: TSessionModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 354
  Top = 180
  Height = 156
  Width = 290
  object ApplicationEvents: TApplicationEvents
    OnActivate = ApplicationEventsActivate
    OnDeactivate = ApplicationEventsDeactivate
    OnException = ApplicationEventsException
    OnMessage = ApplicationEventsMessage
    Left = 56
    Top = 8
  end
  object ReconnectTimer: TTimer
    Enabled = False
    OnTimer = ReconnectTimerTimer
    Left = 168
    Top = 8
  end
  object NonLatinCharTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = NonLatinCharTimerTimer
    Left = 56
    Top = 64
  end
end
