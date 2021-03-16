unit UConnectedClient;

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
  TConnectedClient = class(TBaseTCPClient)
  public
    procedure Disconnect;
    constructor Create(ASocket: TSocket);
  end;

implementation

{$REGION 'TConnectedClient'}

constructor TConnectedClient.Create(ASocket: TSocket);
begin
  Socket := ASocket;
  DataSize := 0;
  SetLength(Data,DataSize);
end;

procedure TConnectedClient.Disconnect;
begin
  if Assigned(Socket) then
    Socket.Close;
end;

{$ENDREGION}


end.
