object TCPSocketModule: TTCPSocketModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 349
  Top = 329
  Height = 150
  Width = 358
  object ElSecureClient: TElSecureClient
    OnSend = ElSecureClientSend
    OnReceive = ElSecureClientReceive
    OnData = ElSecureClientData
    OnCloseConnection = ElSecureClientCloseConnection
    OnOpenConnection = ElSecureClientOpenConnection
    OnCertificateValidate = ElSecureClientCertificateValidate
    Left = 136
    Top = 8
  end
  object ClientSocket: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = ClientSocketConnect
    OnDisconnect = ClientSocketDisconnect
    OnRead = ClientSocketRead
    OnWrite = ClientSocketWrite
    OnError = ClientSocketError
    Left = 24
    Top = 8
  end
end
