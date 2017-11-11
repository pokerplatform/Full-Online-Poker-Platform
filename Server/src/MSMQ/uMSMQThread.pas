unit uMSMQThread;

interface

uses
  Classes, DXString, MSMQ_TLB;

type
  TMSMQThread = class(TThread)
  public
    procedure Execute; override;
  end;

implementation

uses
  ActiveX, SysUtils, uLogger, uCommonDataModule, uSettings;

{ TMSMQThread }

procedure TMSMQThread.Execute;
var
  MSMQQuee    : IMSMQQueue2;
  MSMQInfo    : TMSMQQueueInfo;

  Transaction,
  WantDestinationQueue,
  WantBody,
  ReceiveTimeout,
  WantConnectorType: OleVariant;
  MQMessage   : IMSMQMessage2;
  NeedOpen: Boolean;
  Msg: String;
begin
  CommonDataModule.Log(ClassName, 'Execute', 'Thread has been started', ltBase);

  CoInitialize(nil);

  try
    { creating info object }
    MSMQInfo := TMSMQQueueInfo.Create(nil);
    try
      MSMQInfo.PathName := CommonDataModule.MSMQHost + CommonDataModule.MSMQPATH;
      CommonDataModule.Log(ClassName, 'Execute', 'PathName = ' + MSMQInfo.PathName, ltCall);

      MSMQQuee := nil;
      Transaction := MQ_NO_TRANSACTION;
      WantDestinationQueue := FALSE;
      WantBody := TRUE;
      ReceiveTimeout := 10000;
      WantConnectorType := FALSE;

      while not Terminated do
      begin
        try
          NeedOpen := MSMQQuee = nil;
          if not NeedOpen then
            NeedOpen := MSMQQuee.IsOpen <> 1;
          if NeedOpen then
          begin
            MSMQQuee := nil;
            MSMQQuee := MSMQInfo.Open(MQ_RECEIVE_ACCESS, MQ_DENY_NONE);
            CommonDataModule.Log(ClassName, 'Execute', 'Queue has been opened', ltCall);
          end;

          try
              { checking for a MSMQ message }
            MQMessage := MSMQQuee.ReceiveCurrent(Transaction,
              WantDestinationQueue, WantBody,
              ReceiveTimeout, WantConnectorType);
          except
            on E: Exception do
            begin
              // Closting MSMQ connection
              CommonDataModule.Log(ClassName, 'Execute',
                'When wait for a message: ' + e.Message, ltException);
              MSMQQuee.Close;
              MQMessage := nil;
            end;
          end;

          if MQMessage <> nil then
          try
            { firing event }
            Msg := MQMessage.Body;
            if Msg = '' then
              CommonDataModule.Log(ClassName, 'Execute', 'receive empty MSMQ Message', ltError)
            else
            begin
              CommonDataModule.Log(ClassName, 'Execute', 'receive MSMQ Message: ' + Msg, ltCall);
              CommonDataModule.ProcessAction(Msg);
            end;
            MQMessage := nil;
          except
              on E: Exception do
                CommonDataModule.Log(ClassName, 'Execute',
                  'On process action: ' + e.Message, ltException);
          end;
        except
          on E: Exception do
          begin
            CommonDataModule.Log(ClassName, 'Execute',
              'On circle: ' + e.Message, ltException);
            MSMQInfo.PathName := CommonDataModule.MSMQHost + CommonDataModule.MSMQPATH;
          end;
        end;
        
        Sleep(1000);
      end;
    finally
      if MSMQQuee <> nil then
        if MSMQQuee.IsOpen = 1 then
          MSMQQuee.Close;

      MSMQQuee := nil;
      MSMQInfo.Free;
    end;
  except
    on E: Exception do
      CommonDataModule.Log(ClassName, 'Execute',
        'On create: ' + e.Message, ltException);
  end;

  CoUninitialize;
  
  CommonDataModule.Log(ClassName, 'Execute', 'Thread has been finished', ltBase);
end;

end.
