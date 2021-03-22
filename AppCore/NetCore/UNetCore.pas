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
    NeedDestroySelf: Boolean;
    procedure Handle(AData: TBytes);
    procedure NewConHandle(SocketIP: String);
    procedure DeleteConnectedClient(AID: integer);
    function GetServerStatus: boolean;
    function GetFreeArraySell: integer;
  public
    ConnectedClients: TArray<TConnectedClient>;
    property ServerStarted: boolean read GetServerStatus;
    property Handler: IBaseHandler read FHandler write FHandler;
    property DestroyNetCore: Boolean write NeedDestroySelf;
    procedure Start;
    procedure Stop;
    constructor Create(AHandler: IBaseHandler);
    destructor Destroy;
  end;

implementation

{$REGION 'TNetCore'}

constructor TNetCore.Create(AHandler: IBaseHandler);
var
  id: integer;
begin
  NeedDestroySelf := False;
  SetLength(ConnectedClients, 0);
  Server := TServer.Create;
  FHandler := AHandler;
  Server.AcceptHandle := (
    procedure(ConnectedCli: TConnectedClient)
    begin
      ConnectedCli.Handle := Handle;
      id := GetFreeArraySell;
      ConnectedCli.IdInArray := id;
      ConnectedCli.AfterDisconnect := DeleteConnectedClient;
      ConnectedClients[id] := ConnectedCli;
    end);
  Server.NewConnectHandle := NewConHandle;
end;

procedure TNetCore.DeleteConnectedClient(AID: integer);
begin
  ConnectedClients[AID] := nil;
end;

destructor TNetCore.Destroy;
begin
  Server.Destroy;
  Server := nil;
  SetLength(ConnectedClients, 0);
  FHandler := nil;
end;

function TNetCore.GetFreeArraySell: integer;
var
  i, len: integer;
begin
  len := Length(ConnectedClients);
  Result := len;
  for i := 0 to len - 1 do
    if (ConnectedClients[i] = nil) then
    begin
      Result := i;
      exit;
    end;
  SetLength(ConnectedClients, len + 1);
end;

function TNetCore.GetServerStatus: boolean;
begin
  GetServerStatus := Server.isActive;
end;

procedure TNetCore.Handle(AData: TBytes);
begin
  FHandler.HandleReceiveData(AData);
end;

procedure TNetCore.NewConHandle(SocketIP: String);
begin
  FHandler.HandleConnectClient(SocketIP);
end;

procedure TNetCore.Start;
begin
  Server.Start;
end;

procedure TNetCore.Stop;
var
  i: integer;
begin
  for i := 0 to Length(ConnectedClients) - 1 do
    if (ConnectedClients[i] <> nil) then
      ConnectedClients[i].Disconnect;

  Server.Stop;
  if NeedDestroySelf then
    Destroy;
end;

{$ENDREGION}

end.
