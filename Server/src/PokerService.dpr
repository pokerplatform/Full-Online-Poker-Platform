program PokerService;
{%ToDo 'PokerService.todo'}

uses
  nxReplacementMemoryManager,
{$IFDEF _POKERSERVICE_APP_MODE_}
  Forms,
{$ELSE}
  SvcMgr,
{$ENDIF}
  ActiveX,
  uLocker in 'Common\uLocker.pas',
  uServiceDataModule in 'uServiceDataModule.pas' {ServiceDataModule: TService},
  uAccount in 'Account\uAccount.pas',
  uFirePay in 'Account\uFirePay.pas',
  uAPI in 'API\uAPI.pas',
  uClientAdapter in 'ClientAdapter\uClientAdapter.pas',
  uCommonDataModule in 'Common\uCommonDataModule.pas' {CommonDataModule: TDataModule},
  uErrorConstants in 'Common\uErrorConstants.pas',
  uLogger in 'Common\uLogger.pas',
  uObjectPool in 'Common\uObjectPool.pas',
  uSettings in 'Common\uSettings.pas',
  uXMLConstants in 'Common\uXMLConstants.pas',
  uXMLActions in 'Common\uXMLActions.pas',
  uEMail in 'Email\uEMail.pas',
  uFileManager in 'FileManager\uFileManager.pas',
  uSQLAdapter in 'SQLAdapter\uSQLAdapter.pas',
  uSQLTools in 'SQLAdapter\uSQLTools.pas',
  uUser in 'User\uUser.pas',
  uTournament in 'Tournament\uTournament.pas',
  uCommonFunctions in 'Tournament\uCommonFunctions.pas',
  uTouClasses in 'Tournament\uTouClasses.pas',
  uTouConstants in 'Tournament\uTouConstants.pas',
  uTournamentList in 'Tournament\uTournamentList.pas',
  uReminder in 'Reminder\uReminder.pas',
  uMSMQWriter in 'MSMQ\uMSMQWriter.pas',
  uMSMQReader in 'MSMQ\uMSMQReader.pas',
  uAPIActions in 'API\uAPIActions.pas',
  uFMActions in 'FileManager\uFMActions.pas',
  uGameConnector in 'GameConnector\uGameConnector.pas',
  uCombinationProcessor in 'PokerGameEngine\uCombinationProcessor.pas',
  uErrorHandling in 'PokerGameEngine\uErrorHandling.pas',
  uPokerBase in 'PokerGameEngine\uPokerBase.pas',
  uPokerDefs in 'PokerGameEngine\uPokerDefs.pas',
  uPokerGameEngine in 'PokerGameEngine\uPokerGameEngine.pas',
  uActionClient in 'ActionDispatcher\uActionClient.pas',
  uActionDispatcher in 'ActionDispatcher\uActionDispatcher.pas',
  uActionServer in 'ActionDispatcher\uActionServer.pas',
  uInfoCash in 'Common\uInfoCash.pas',
  uGameAdapter in 'GameAdapter\uGameAdapter.pas',
  uGameProcessThread in 'GameAdapter\uGameProcessThread.pas',
  uMainForm in 'uMainForm.pas' {MainForm},
  uSessionUtils in 'Connection\uSessionUtils.pas',
  uSessionProcessor in 'Connection\uSessionProcessor.pas',
  uSessionServer in 'Connection\uSessionServer.pas',
  uMSMQThread in 'MSMQ\uMSMQThread.pas',
  uReminderThread in 'Reminder\uReminderThread.pas',
  uBotClasses in 'PokerGameEngine\Bot\uBotClasses.pas',
  uBotConstants in 'PokerGameEngine\Bot\uBotConstants.pas',
  uResponseProcessor in 'PokerGameEngine\Bot\uResponseProcessor.pas',
  uBotCombinationProcessor in 'PokerGameEngine\Bot\PokerCombinations\uBotCombinationProcessor.pas',
  uCardEngine in 'PokerGameEngine\Bot\PokerCombinations\uCardEngine.pas',
  uCacheContainer in 'Common\uCacheContainer.pas',
  NetCompress_TLB in '..\ext\NetCompress_TLB.pas';


{$R *.RES}

begin
{$IFDEF _POKERSERVICE_APP_MODE_}
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  MainForm.Show;
  StartService;
  Application.Run;
  StopService;
{$ELSE}
  Application.Initialize;
  Application.CreateForm(TServiceDataModule, ServiceDataModule);
  Application.Run;
{$ENDIF}

(*
{$IFDEF _POKERSERVICE_APP_MODE_}
  Forms,
{$ELSE}
  SvcMgr,
{$ENDIF}
*)

end.

