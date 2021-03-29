program ClientProject;

uses
  System.StartUpCopy,
  FMX.Forms,
  Client in 'Client.pas' {ClientForm},
  Net.IHandlerCore in 'AppCore\NetCore\Net.IHandlerCore.pas',
  Net.Client in 'AppCore\NetCore\Net.Client.pas',
  Net.ConnectedClient in 'AppCore\NetCore\Net.ConnectedClient.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TClientForm, ClientForm);
  Application.Run;
end.
