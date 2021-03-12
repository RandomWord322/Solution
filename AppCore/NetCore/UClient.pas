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
  public
    property Handle: TProc<TBytes> read FHandle write FHandle;
    procedure Connect(const AIP: string; APort: Word);
    procedure Disconnect;
    constructor Create(ASocket: TSocket = nil);
  end;

implementation

constructor TClient.Create(ASocket: TSocket = nil);
begin

  DataSize := 0;
  SetLength(Data,DataSize);
end;

procedure TClient.Disconnect;
begin
  Socket.Close(True);
end;

procedure TClient.Connect(const AIP: string; APort: Word);
begin
  try
    if not Assigned(Socket) then
      Socket := TSocket.Create(TSocketType.TCP,TEncoding.UTF8);

    Socket.Connect('',AIP,'',APort);
    StartReceive;
  except
    raise Exception.Create('Can''t Connect');
  end;
end;

end.
