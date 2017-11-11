object ProcessModule: TProcessModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 376
  Top = 200
  Height = 261
  Width = 153
  object FinishProcessTimer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = FinishProcessTimerTimer
    Left = 57
    Top = 8
  end
  object WaitingListTimeOutTimer: TTimer
    Enabled = False
    OnTimer = WaitingListTimeOutTimerTimer
    Left = 57
    Top = 72
  end
  object SaveNotesTimer: TTimer
    OnTimer = SaveNotesTimerTimer
    Left = 56
    Top = 136
  end
end
