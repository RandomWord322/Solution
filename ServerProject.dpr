program ServerProject;

uses
  System.StartUpCopy,
  FMX.Forms,
  Server in 'Server.pas' {ServerForm},
  TestUConnectedClient in 'AutoTests\TestUConnectedClient.pas',
  Net.IHandlerCore in 'AppCore\NetCore\Net.IHandlerCore.pas',
  Net.Client in 'AppCore\NetCore\Net.Client.pas',
  Net.ConnectedClient in 'AppCore\NetCore\Net.ConnectedClient.pas',
  Net.Core in 'AppCore\NetCore\Net.Core.pas',
  Net.Server in 'AppCore\NetCore\Net.Server.pas',
  BlockChain.Account in 'AppCore\BlockChain\BlockChain.Account.pas',
  BlockChain.Core in 'AppCore\BlockChain\BlockChain.Core.pas',
  BlockChain.Types in 'AppCore\BlockChain\BlockChain.Types.pas',
  BlockChain.FileHandler in 'AppCore\BlockChain\BlockChain.FileHandler.pas';

{$APPTYPE GUI}
{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TServerForm, ServerForm);
  Application.Run;
end.
