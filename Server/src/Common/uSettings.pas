unit uSettings;

interface

const
  cntDefaultMSMQPATH = '\private$\pokerservice';
  cntDefaultAdminMSMQPATH = '\private$\pokeradmin';
  cntDefaultLocalIP = '127.0.0.1';
  cntDefaultActionDispatcherPort = 4001;
  cntDefaultActionDispatcherID = 1;
  cntDefaultSubCategoryID = 1;
  cntDefaultClientAdapterPort = 4000;
  cntDefaultSQLConnectionString = 'Provider=SQLOLEDB.1;'+
    'Password=po_;Persist Security Info=True;User ID=poker;Initial Catalog=poker;'+
    'Data Source=';
  cntDefaultLogFolder = '\Poker\Logs';

  cntDefaultAdminEmailAddress = 'admin@';
  cntDefaultSMTPPort = 25;
  cntDefaultSMTPFrom = 'support@';

  cntIsClientAdapter = 'IsClientAdapter';
  cntIsActionProcessor = 'IsClientAdapter';
  cntIsActionDispatcher = 'IsActionDispatcher';
  cntIsMSMQReader = 'IsMSMQReader';
  cntIsMSMQWriter = 'IsMSMQWriter';
  cntIsReminder = 'IsReminder';
  cntIsTournament = 'IsTournament';
  cntIsGameAdapter = 'IsGameAdapter';

  cntSQLConnectionString = 'SQLConnectionString';
  cntSQLServerHost = 'SQLServerHost';
  cntMSMQHost = 'MSMQHost';
  cntMSMQPath = 'MSMQPath';
  cntAdminMSMQHost = 'AdminMSMQHost';
  cntAdminMSMQPath = 'AdminMSMQPath';
  cntClientAdapterPort = 'ClientAdapterPort';
  cntClientConnectionsAllowedStatus = 'ClientConnectionsAllowedStatus';
  cntClientAdapterSSL = 'ClientAdapterSSL';
  cntProcessesStatus = 'ProcessesStatus';
  cntActionDispatcherHost = 'ActionDispatcherHost';
  cntActionDispatcherPort = 'ActionDispatcherPort';
  cntActionDispatcherID = 'ActionDispatcherID';

  cntLogFolder = 'LogFolder';
  cntLogging = 'Logging';

  cntAdminEmailAddress = 'AdminEmailAddress';
  cntSMTPHost = 'SMTPHost';
  cntSMTPPort = 'SMTPPort';
  cntSMTPFrom = 'SMTPFrom';

  cntConstantIPs = 'ConstantIPs';
  cntRefreshTime = 'RefreshTime';

  cntHeaderGameAdapterSignature: Char = '%';
  cntHeaderClientAdapterSignature: Char = '$';
  cntHeaderEndSignature: Char = '*';
  cntXMLStartSignature: Char = '<';
  cntXMLEndSignature: Char = #0;
  cntZippedPacketSignature: Char = 'x';
  cntUpdatePacketsSignature: Char = '#';

implementation

end.
