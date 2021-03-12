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
    property Handle: TProc<TBytes> read FHandle write FHandle;
//    procedure Connect(const AIP: string; APort: Word);
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
  Socket.Close(True);
end;

{$ENDREGION}


end.
