unit UClient;

interface
uses
  System.SysUtils,
  System.Types,
  System.Classes,
  System.Threading,
  System.Net.Socket,
  System.Generics.Collections;
type
  TClient = class
  private
    FHandle: TProc<TBytes>;
    Socket: TSocket;
    Data: TBytes;
    DataSize: integer;
    FAfterDisconnect: TProc<Boolean>;
    procedure Init;
  public
    property Handle: TProc<TBytes> read FHandle write FHandle;
    function TryConnect(const AIP: string; APort: Word): Boolean;
    procedure Disconnect;
    function TryDisconnect: Boolean;
    constructor Create(ASocket: TSocket = nil);

    property BeforeDestroy: TProc<Boolean> read FAfterDisconnect write FAfterDisconnect;
    function Connected: Boolean;
    procedure CallBack(const ASyncResult: IAsyncResult);
    procedure StartReceive;
    procedure SendMessage(const AData: TBytes);
    destructor Destroy;
  end;

implementation

function TClient.Connected: Boolean;
begin
  try
    if Assigned(Socket) then
      Result := TSocketState.Connected in Socket.State
    else
      Result := False;
  except
    Result := False;
  end;
end;

constructor TClient.Create(ASocket: TSocket = nil);
begin
  Init;
end;

function TClient.TryDisconnect: Boolean;
begin
  if Self.Connected then
    Disconnect;
  Result := not Connected;
end;

destructor TClient.Destroy;
begin
  FHandle := nil;
  setLength(Data,0);
  DataSize := 0;
  Socket.Destroy;
  BeforeDestroy(True);
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

procedure TClient.CallBack(const ASyncResult: IAsyncResult);
var
  Bytes: TBytes;
begin
  try
    Bytes := Socket.EndReceiveBytes(ASyncResult);
  except
    SetLength(Bytes, 0);
  end;

  if Length(Bytes) > 0 then
  begin
    Data := Data + Bytes;
    while True do
    begin
      if DataSize > 0 then
      begin
        if Length(Data) >= DataSize then
        begin
          Handle(Copy(Data, 0, DataSize));
          Data := Copy(Data, DataSize, Length(Data) - DataSize);
          DataSize := 0;
        end
        else
          break;
      end
      else
      begin
        if Length(Data) >= SizeOf(integer) then
        begin
          DataSize := Pinteger(Data)^;
          Data := Copy(Data, SizeOf(DataSize), Length(Data) - SizeOf(DataSize));
        end
        else
          break;
      end;
    end;
    StartReceive;
  end
  else
  if Assigned(Self) then
    Self.Destroy;
end;

procedure TClient.SendMessage(const AData: TBytes);
var
  Len: integer;
begin
  Len := Length(AData);
  Socket.Send(Len, SizeOf(Len));
  Socket.Send(AData);
end;

procedure TClient.StartReceive;
begin
  Socket.BeginReceive(CallBack);
end;

function TClient.TryConnect(const AIP: string; APort: Word): Boolean;
begin
  Result := True;
  try
    Socket.Connect('',AIP,'',APort);
    StartReceive;
  except
    Result := False;
//    on E:Exception do
//      raise Exception.Create(E.Message);
  end;
end;

end.
