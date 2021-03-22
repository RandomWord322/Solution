unit Client;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Net.Socket,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.Controls.Presentation,
  FMX.Edit,
  UClient;

type
  TClientForm = class(TForm)
    IPEdit: TEdit;
    IPLabel: TLabel;
    MsgMemo: TMemo;
    PortEdit: TEdit;
    PortLabel: TLabel;
    ConnectButton: TButton;
    SendEdit: TEdit;
    SendButton: TButton;
    DisconnectButton: TButton;
    procedure ConnectButtonClick(Sender: TObject);
    procedure SendButtonClick(Sender: TObject);
    procedure DisconnectButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ClientForm: TClientForm;
  ConClient: TClient;
  Socket: TSocket;

implementation

{$R *.fmx}

procedure TClientForm.ConnectButtonClick(Sender: TObject);
begin
  if not Assigned(ConClient) or ConClient.NilThisClient then
  begin
//    ConClient := nil;
    ConClient := TClient.Create;
    if not ConClient.TryConnect('127.0.0.1', 20000) then
    begin
      MsgMemo.Lines.Add('Client can''t connect (server is not response)');
      ConClient.Destroy;
      ConClient := nil;
    end else
      MsgMemo.Lines.Add('Client is connected now');
  end else
    MsgMemo.Lines.Add('Client is connected already');
end;

procedure TClientForm.DisconnectButtonClick(Sender: TObject);
begin
  if Assigned(ConClient) and ConClient.TryDisconnect then
  begin
    MsgMemo.Lines.Add('Client disconnected');
    ConClient := nil;
  end
  else
    MsgMemo.Lines.Add('Client can''t disconnect');
end;

procedure TClientForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(ConClient) then
    if not ConClient.TryDisconnect then
      ConClient.Destroy;
//  ConClient := nil;
end;

procedure TClientForm.SendButtonClick(Sender: TObject);
var
  Bytes: TBytes;
begin
  Bytes := TEncoding.UTF8.GetBytes(SendEdit.Text);
  ConClient.SendMessage(Bytes);
end;

end.
