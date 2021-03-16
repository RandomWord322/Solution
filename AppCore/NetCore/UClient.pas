unit UClient;

interface
uses
  System.SysUtils,
  System.Types,
  System.Classes,
  System.Threading,
  System.Net.Socket,
  System.Generics.Collections,
  UAbstractClient;
type
  TClient = class(TBaseTCPClient)
  private
    FHandle: TProc<TBytes>;
    procedure Init;
  public
    property Handle: TProc<TBytes> read FHandle write FHandle;
    procedure Connect(const AIP: string; APort: Word);
    procedure Disconnect;
    function TryDisconnect: Boolean;
    constructor Create(ASocket: TSocket = nil);
  end;

implementation

constructor TClient.Create(ASocket: TSocket = nil);
begin
  init;
end;

function TClient.TryDisconnect: Boolean;
begin
  if Self.Connected then
    Disconnect;
  Result := not Connected;
end;

procedure TClient.Disconnect;
begin
  Socket.Close(True);
end;

procedure TClient.Init;
begin
  if not Assigned(Socket) then
  begin
    Socket := TSocket.Create(TSocketType.TCP,TEncoding.UTF8);
    DataSize := 0;
    SetLength(Data,DataSize);
  end;
end;

procedure TClient.Connect(const AIP: string; APort: Word);
begin
  try
    Socket.Connect('',AIP,'',APort);
    StartReceive;
  except
    on E:Exception do
      raise Exception.Create(E.Message);
  end;
end;

end.
