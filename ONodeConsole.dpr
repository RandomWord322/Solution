program ONodeConsole;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  App.Abstractions in 'AppCore\App.Abstractions.pas',
  App.Core in 'AppCore\App.Core.pas',
  App.Globals in 'AppCore\App.Globals.pas',
  App.Types in 'AppCore\App.Types.pas',
  UI.ConsoleUI in 'AppCore\UICore\UI.ConsoleUI.pas',
  UI.GUI in 'AppCore\UICore\UI.GUI.pas',
  UI.CommandLineParser in 'AppCore\UICore\UI.CommandLineParser.pas',
  UI.ParserCommand in 'AppCore\UICore\UI.ParserCommand.pas',
  UI.Types in 'AppCore\UICore\UI.Types.pas',
  Net.IHandlerCore in 'AppCore\NetCore\Net.IHandlerCore.pas',
  Net.Client in 'AppCore\NetCore\Net.Client.pas',
  Net.ConnectedClient in 'AppCore\NetCore\Net.ConnectedClient.pas',
  Net.Core in 'AppCore\NetCore\Net.Core.pas',
  Net.Server in 'AppCore\NetCore\Net.Server.pas',
  App.Meta in 'AppCore\App.Meta.pas',
  Crypto.RSA in 'AppCore\CryptoCore\Crypto.RSA.pas',
  CryptoEntity in 'AppCore\CryptoCore\CryptoEntity.pas',
  RSA.cEncrypt in 'AppCore\CryptoCore\RSA.cEncrypt.pas',
  RSA.cHash in 'AppCore\CryptoCore\RSA.cHash.pas',
  RSA.cHugeInt in 'AppCore\CryptoCore\RSA.cHugeInt.pas',
  RSA.cRandom in 'AppCore\CryptoCore\RSA.cRandom.pas',
  RSA.main in 'AppCore\CryptoCore\RSA.main.pas',
  BlockChain.Account in 'AppCore\BlockChain\BlockChain.Account.pas',
  BlockChain.Core in 'AppCore\BlockChain\BlockChain.Core.pas',
  BlockChain.Types in 'AppCore\BlockChain\BlockChain.Types.pas',
  BlockChain.FileHandler in 'AppCore\BlockChain\BlockChain.FileHandler.pas',
  Net.HandlerCore in 'AppCore\NetCore\Net.HandlerCore.pas';

begin
  try
    AppCore := TAppCore.Create;
    AppCore.DoRun;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
