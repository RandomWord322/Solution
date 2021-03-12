unit UAbstractClient;

interface

uses
  System.SysUtils,
  System.Types,
  System.Classes,
  System.Threading,
  System.Net.Socket,
  System.Generics.Collections;

type
  TBaseTCPClient = class abstract
  protected
    Socket: TSocket;
    FHandle: TProc<TBytes>;
    Data: TBytes;
    DataSize: integer;
  public
    property Handle: TProc<TBytes> read FHandle write FHandle;
    function Connected: Boolean;
    procedure CallBack(const ASyncResult: IAsyncResult);
    procedure StartReceive;
    procedure SendMessage(const AData: TBytes);
    procedure Connect(const AIP: string; APort: Word); virtual; abstract;
    procedure Disconnect; virtual; abstract;
    constructor Create(ASocket: TSocket); virtual; abstract;
    destructor Destroy; override;
  end;

implementation

procedure TBaseTCPClient.CallBack(const ASyncResult: IAsyncResult);
var
  Bytes: TBytes;
begin
  try
    Bytes := Socket.EndReceiveBytes(ASyncResult);
  except
    SetLength(Bytes,0);
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
          Handle(Copy(Data,0,DataSize));
          Data := Copy(Data,DataSize,Length(Data)-DataSize);
          DataSize := 0;
        end
        else
          break;
      end
      else
      begin
        if Length(Data)>=SizeOf(integer) then
        begin
          DataSize := Pinteger(Data)^;
          Data := Copy(Data,SizeOf(DataSize),Length(Data)-SizeOf(DataSize));
        end
        else
          break;
      end;
    end;
    StartReceive;
  end
  else
    Free;
end;

procedure TBaseTCPClient.SendMessage(const AData: TBytes);
var
  Len: integer;
begin
  Len := Length(AData);
  Socket.Send(Len,SizeOf(Len));
  Socket.Send(AData);
end;

destructor TBaseTCPClient.Destroy;
begin
  Socket.Close(Connected);
  Socket.Destroy;
end;

procedure TBaseTCPClient.StartReceive;
begin
  Socket.BeginReceive(CallBack);
end;

function TBaseTCPClient.Connected: Boolean;
begin
  try
    Result := TSocketState.Connected in Socket.State;
  finally
    Result := False;
  end;
end;

end.
