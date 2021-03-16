unit UNetCore;

interface
uses
  IHandlerCore,
  UServer,
  UConnectedClient,
  System.SysUtils,
  System.Types,
  System.Classes,
  System.Threading,
  System.Net.Socket,
  System.Generics.Collections;
type
  TNetCore = class
  private
    Server: TServer;
    MonitorConnectedClients: TMonitor;
    FHandler: IBaseHandler;
    procedure Handle(AData: TBytes);
    function GetServerStatus: boolean;
  public
    ConnectedClients: TArray<TConnectedClient>;
    property ServerStarted: boolean read GetServerStatus;
    property Handler: IBaseHandler read FHandler write FHandler;
    procedure Start;
    procedure Stop;
    constructor Create(AHandler: IBaseHandler);
    destructor Destroy;override;
  end;

implementation

{$REGION 'TNetCore'}

constructor TNetCore.Create(AHandler: IBaseHandler);
begin
  SetLength(ConnectedClients,0);
  Server := TServer.Create;
  FHandler := AHandler;
  Server.AcceptHandle :=
  (procedure (ConnectedCli: TConnectedClient)
  begin
    ConnectedCli.Handle := Handle;
    ConnectedClients := ConnectedClients + [ConnectedCli];
  end);
//  Server.NewConnectHandle :=
//  (procedure (ConnectedCli: TConnectedClient)
//  begin
//    ConnectedCli.Handle := Handle;
//    ConnectedClients := ConnectedClients + [ConnectedCli];
//  end);
end;

destructor TNetCore.Destroy;
begin
  Server.Free;
  SetLength(ConnectedClients,0);
end;

function TNetCore.GetServerStatus: boolean;
begin
  GetServerStatus := Server.isActive;
end;

procedure TNetCore.Handle(AData: TBytes);
begin
  FHandler.HandleReceiveData(AData);
end;

procedure TNetCore.Start;
begin
  Server.Start;
end;

procedure TNetCore.Stop;
var
  i: Integer;
begin
  Server.Stop;
  for i := 0 to Length(ConnectedClients) - 1 do
    ConnectedClients[i].Disconnect;
  SetLength(ConnectedClients,0);
end;

{$ENDREGION}

end.
