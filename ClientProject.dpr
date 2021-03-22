program ClientProject;

uses
  System.StartUpCopy,
  FMX.Forms,
  Client in 'Client.pas' {ClientForm},
  IHandlerCore in 'AppCore\NetCore\IHandlerCore.pas',
  UClient in 'AppCore\NetCore\UClient.pas',
  UConnectedClient in 'AppCore\NetCore\UConnectedClient.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TClientForm, ClientForm);
  Application.Run;
end.
