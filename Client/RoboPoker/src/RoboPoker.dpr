program RoboPoker;

uses
  nxReplacementMemoryManager,
  Forms,
  uConstants in 'Common\uConstants.pas',
  uLogger in 'Common\uLogger.pas',
  uConversions in 'DataStore\uConversions.pas',
  uDataList in 'DataStore\uDataList.pas',
  uTCPSocketModule in 'TCPConnection\uTCPSocketModule.pas' {TCPSocketModule: TDataModule},
  uParserModule in 'Common\uParserModule.pas' {ParserModule: TDataModule},
  uUserForm in 'User\uUserForm.pas' {UsersForm},
  uSettingsForm in 'Common\uSettingsForm.pas' {SettingsForm},
  uGenerationForm in 'Common\uGenerationForm.pas' {GenerationForm},
  uLobbyModule in 'Processes\uLobbyModule.pas' {LobbyModule: TDataModule},
  uCommonDataModule in 'Common\uCommonDataModule.pas' {CommonDataModule: TDataModule},
  uBotConnection in 'TCPConnection\uBotConnection.pas',
  uBotActions in 'Bot\uBotActions.pas',
  uBotClasses in 'Bot\uBotClasses.pas',
  uBotConstants in 'Bot\uBotConstants.pas',
  uBotForm in 'Bot\uBotForm.pas' {BotForm},
  uBotProcessor in 'Bot\uBotProcessor.pas',
  uResponseProcessor in 'Bot\uResponseProcessor.pas',
  uCardEngine in 'Bot\PokerCombinations\uCardEngine.pas',
  uCombinationProcessor in 'Bot\PokerCombinations\uCombinationProcessor.pas',
  uMacTool in 'Common\uMacTool.pas',
  uSessionUtils in 'TCPConnection\uSessionUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TCommonDataModule, CommonDataModule);
  Application.CreateForm(TParserModule, ParserModule);
  Application.CreateForm(TUsersForm, UsersForm);
  Application.CreateForm(TBotForm, BotForm);
  Application.CreateForm(TGenerationForm, GenerationForm);
  Application.CreateForm(TSettingsForm, SettingsForm);
  if ParamStr(1) <> '' then
    CommonDataModule.ConnectBots(ParamStr(1));
  Application.Run;
end.
