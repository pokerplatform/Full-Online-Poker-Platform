object ServiceDataModule: TServiceDataModule
  OldCreateOrder = False
  OnCreate = ServiceCreate
  DisplayName = 'PokerService'
  OnContinue = ServiceContinue
  OnPause = ServicePause
  OnShutdown = ServiceShutdown
  OnStart = ServiceStart
  OnStop = ServiceStop
  Left = 2
  Top = 114
  Height = 150
  Width = 215
end
