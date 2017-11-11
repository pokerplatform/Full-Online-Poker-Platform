//      Project: Poker
//
//      Company: Offshore Creations
//    Developer: Maxim L. Korablev
//
//    Class(es): Project file
//  Description: Initialize and run application;
//               Check for another application running, and show it if found
//               else run itself;
//               Update itself.
//
program PokerSatellites;



uses
  Forms,
  Dialogs,
  uCashierForm in 'Cashier\uCashierForm.pas' {CashierForm},
  uCashierModule in 'Cashier\uCashierModule.pas' {CashierModule: TDataModule},
  uDepositForm in 'Cashier\uDepositForm.pas' {DepositForm},
  uTransactionHistoryForm in 'Cashier\uTransactionHistoryForm.pas' {TransactionHistoryForm},
  uWithdrawalForm in 'Cashier\uWithdrawalForm.pas' {WithdrawalForm},
  uConstants in 'Common\uConstants.pas',
  uLogger in 'Common\uLogger.pas' {Logger: TDataModule},
  uMessageForm in 'Common\uMessageForm.pas' {MessageForm},
  uThemeEngineModule in 'Common\uThemeEngineModule.pas' {ThemeEngineModule: TDataModule},
  uConversions in 'DataStore\uConversions.pas',
  uDataList in 'DataStore\uDataList.pas',
  uFileManagerModule in 'FileManager\uFileManagerModule.pas' {FileManagerModule: TDataModule},
  uHTTPGetFileThread in 'FileManager\uHTTPGetFileThread.pas',
  uBlackJackLobbyForm in 'Lobby\uBlackJackLobbyForm.pas' {BlackJackLobbyForm},
  uBlackJackWelcomeForm in 'Lobby\uBlackJackWelcomeForm.pas' {BlackJackWelcomeForm},
  uCustomSupportForm in 'Lobby\uCustomSupportForm.pas' {CustomSupportForm},
  uLobbyForm in 'Lobby\uLobbyForm.pas' {LobbyForm},
  uLobbyModule in 'Lobby\uLobbyModule.pas' {LobbyModule: TDataModule},
  uPictureMessageForm in 'Lobby\uPictureMessageForm.pas' {PictureMessageForm},
  uProcessForm in 'Process\uProcessForm.pas' {ProcessForm},
  uProcessModule in 'Process\uProcessModule.pas' {ProcessModule: TDataModule},
  uProcessStatisticsForm in 'Process\uProcessStatisticsForm.pas' {ProcessStatisticsForm},
  uRecordedHandsForm in 'Process\uRecordedHandsForm.pas' {RecordedHandsForm},
  uRequestHandHistoryForm in 'Process\uRequestHandHistoryForm.pas' {RequestHandHistoryForm},
  uTakingForm in 'Process\uTakingForm.pas' {TakingForm},
  uWaitingListJoinForm in 'Process\uWaitingListJoinForm.pas' {WaitingListJoinForm},
  uWaitingListTakePlaceForm in 'Process\uWaitingListTakePlaceForm.pas' {WaitingListTakePlaceForm},
  uServerErrorMessages in 'Server\uServerErrorMessages.pas',
  uZipCrypt in 'Session\uZipCrypt.pas',
  uConnectingForm in 'Session\uConnectingForm.pas' {ConnectingForm},
  uDebugForm in 'Session\uDebugForm.pas' {DebugForm},
  uExitForm in 'Session\uExitForm.pas' {ExitForm},
  uMacTool in 'Session\uMacTool.pas',
  uParserModule in 'Session\uParserModule.pas' {ParserModule: TDataModule},
  uSessionModule in 'Session\uSessionModule.pas' {SessionModule: TDataModule},
  uSessionUtils in 'Session\uSessionUtils.pas',
  uTCPSocketModule in 'Session\uTCPSocketModule.pas' {TCPSocketModule: TDataModule},
  uWelcomeMessageForm in 'Session\uWelcomeMessageForm.pas' {WelcomeMessageForm},
  fcMemoryStream in 'Session\fcMemoryStream.pas',
  uTournamentInfoForm in 'Tournament\uTournamentInfoForm.pas' {TournamentInfoForm},
  uTournamentLobbyForm in 'Tournament\uTournamentLobbyForm.pas' {TournamentLobbyForm},
  uTournamentModule in 'Tournament\uTournamentModule.pas' {TournamentModule: TDataModule},
  uAboutForm in 'User\uAboutForm.pas' {AboutForm},
  uChangeMailingAddressForm in 'User\uChangeMailingAddressForm.pas' {ChangeMailingAddressForm},
  uChangePasswordForm in 'User\uChangePasswordForm.pas' {ChangePasswordForm},
  uChangePlayerImageForm in 'User\uChangePlayerImageForm.pas' {ChangePlayerImageForm},
  uChangePlayerLogoForm in 'User\uChangePlayerLogoForm.pas' {ChangePlayerLogoForm},
  uChangeProfileForm in 'User\uChangeProfileForm.pas' {ChangeProfileForm},
  uChangeValidateEmailForm in 'User\uChangeValidateEmailForm.pas' {ChangeValidateEmailForm},
  uFindPlayerForm in 'User\uFindPlayerForm.pas' {FindPlayerForm},
  uForgotPasswordForm in 'User\uForgotPasswordForm.pas' {ForgotPasswordForm},
  uLoginForm in 'User\uLoginForm.pas' {LoginForm},
  uRegisterNewUserForm in 'User\uRegisterNewUserForm.pas' {RegisterNewUserForm},
  uSelectLogoImage in 'User\uSelectLogoImage.pas' {SelectLogoImageForm},
  uTournamentLeaderBoardForm in 'User\uTournamentLeaderBoardForm.pas' {TournamentLeaderBoardForm},
  uTournLeaderPointsForm in 'User\uTournLeaderPointsForm.pas' {TournLeaderPointsForm},
  uTransferFundsForm in 'User\uTransferFundsForm.pas' {TransferFundsForm},
  uUserModule in 'User\uUserModule.pas' {UserModule: TDataModule},
  uLoyaltyStore in 'Cashier\uLoyaltyStore.pas' {LoyaltyStoreForm},
  uHTTPPostThread in 'User\uHTTPPostThread.pas',
  uPasswordForm in 'User\uPasswordForm.pas' {PasswordForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'PokerSatellites';
  Application.CreateForm(TSessionModule, SessionModule);
  Application.CreateForm(TLogger, Logger);
  if SessionModule.CheckForValidApplicationFile then
  try
    Application.CreateForm(TConnectingForm, ConnectingForm);
    ConnectingForm.Show;
    Application.ProcessMessages;

    Application.CreateForm(TTCPSocketModule, TCPSocketModule);
    Application.CreateForm(TParserModule, ParserModule);
    Application.CreateForm(TFileManagerModule, FileManagerModule);

    Application.CreateForm(TThemeEngineModule, ThemeEngineModule);

    Application.CreateForm(TLobbyModule, LobbyModule);
    Application.CreateForm(TLobbyForm, LobbyForm);
    Application.CreateForm(TCustomSupportForm, CustomSupportForm);

    Application.CreateForm(TProcessModule, ProcessModule);
    Application.CreateForm(TProcessStatisticsForm, ProcessStatisticsForm);
    Application.CreateForm(TWaitingListJoinForm, WaitingListJoinForm);
    Application.CreateForm(TWaitingListTakePlaceForm, WaitingListTakePlaceForm);
    Application.CreateForm(TRequestHandHistoryForm, RequestHandHistoryForm);
    Application.CreateForm(TRecordedHandsForm, RecordedHandsForm);

    Application.CreateForm(TTournamentModule, TournamentModule);

    Application.CreateForm(TUserModule, UserModule);
    Application.CreateForm(TLoginForm, LoginForm);
    Application.CreateForm(TRegisterNewUserForm, RegisterNewUserForm);
    Application.CreateForm(TChangeValidateEmailForm, ChangeValidateEmailForm);
    Application.CreateForm(TChangePasswordForm, ChangePasswordForm);
    Application.CreateForm(TForgotPasswordForm, ForgotPasswordForm);
    Application.CreateForm(TChangeProfileForm, ChangeProfileForm);

    Application.CreateForm(TCashierModule, CashierModule);
    Application.CreateForm(TCashierForm, CashierForm);
    Application.CreateForm(TTransactionHistoryForm, TransactionHistoryForm);
    Application.CreateForm(TDepositForm, DepositForm);
    Application.CreateForm(TWithdrawalForm, WithdrawalForm);
    Application.CreateForm(TChangeMailingAddressForm, ChangeMailingAddressForm);

    Application.CreateForm(TExitForm, ExitForm);
    Application.CreateForm(TWelcomeMessageForm, WelcomeMessageForm);
    Application.CreateForm(TBlackJackLobbyForm, BlackJackLobbyForm);
    Application.CreateForm(TBlackJackWelcomeForm, BlackJackWelcomeForm);

    Application.CreateForm(TTransferFundsForm, TransferFundsForm);

    Application.CreateForm(TChangePlayerImageForm, ChangePlayerImageForm);
    Application.CreateForm(TSelectLogoImageForm, SelectLogoImageForm);
    Application.CreateForm(TFindPlayerForm, FindPlayerForm);
    Application.CreateForm(TTournLeaderPointsForm, TournLeaderPointsForm);
    Application.CreateForm(TTournamentLeaderBoardForm, TournamentLeaderBoardForm);
    Application.CreateForm(TAboutForm, AboutForm);
    Application.CreateForm(TPictureMessageForm, PictureMessageForm);
    Application.CreateForm(TLoyaltyStoreForm, LoyaltyStoreForm);

    Application.CreateForm(TPasswordForm, PasswordForm);

    SessionModule.StartApplication;
    Application.ShowMainForm := false;
    Application.Run;
  except
  end;
end.
