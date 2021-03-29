unit Net.ConnectedClient;

interface

uses
  System.SysUtils,
  System.Types,
  System.Classes,
  System.Threading,
  System.Net.Socket,
  System.Generics.Collections;

type
  TConnectedClient = class
  private
    Socket: TSocket;
    FHandle: TProc<TBytes>;
    Data: TBytes;
    DataSize: integer;
    Id: Integer;
    FAfterDisconnect: TProc<Integer>;
  public
    procedure Disconnect;
    constructor Create(ASocket: TSocket);

    property AfterDisconnect: TProc<Integer> read FAfterDisconnect write FAfterDisconnect;
    property IdInArray: Integer read Id write Id;
    property Handle: TProc<TBytes> read FHandle write FHandle;
    function GetSocketIP: String;
    property SocketIP: String read GetSocketIP;
    procedure CallBack(const ASyncResult: IAsyncResult);
    procedure StartReceive;
    procedure SendMessage(const AData: TBytes);
    destructor Destroy; override;
  end;

implementation

{$REGION 'TConnectedClient'}

procedure TConnectedClient.CallBack(const ASyncResult: IAsyncResult);
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
    Self.Destroy;
end;

constructor TConnectedClient.Create(ASocket: TSocket);
begin
  Socket := ASocket;
  DataSize := 0;
  SetLength(Data,DataSize);
end;

destructor TConnectedClient.Destroy;
begin
  FHandle := nil;
  setLength(Data,0);
  DataSize := 0;
  AfterDisconnect(Id);
  Socket.Destroy;
  Socket := nil;
end;

procedure TConnectedClient.Disconnect;
begin
  if Assigned(Socket) then
    Socket.Close;
end;

function TConnectedClient.GetSocketIP: String;
begin
  try
    Result := '';
    if Assigned(Socket) then
      Result := Socket.Endpoint.Address.Address;
  except
    Result := '';
  end;
end;

procedure TConnectedClient.SendMessage(const AData: TBytes);
var
  Len: integer;
begin
  Len := Length(AData);
  Socket.Send(Len, SizeOf(Len));
  Socket.Send(AData);
end;

procedure TConnectedClient.StartReceive;
begin
  Socket.BeginReceive(CallBack);
end;

{$ENDREGION}


end.
