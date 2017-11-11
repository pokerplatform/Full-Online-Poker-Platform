object LobbyModule: TLobbyModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 678
  Top = 209
  Height = 221
  Width = 150
  object SendProcessesTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = SendProcessesTimerTimer
    Left = 56
    Top = 64
  end
  object SendProcessInfoTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = SendProcessInfoTimerTimer
    Left = 56
    Top = 128
  end
  object UpdateTimer: TTimer
    Enabled = False
    Interval = 100000
    OnTimer = UpdateTimerTimer
    Left = 56
    Top = 8
  end
end
