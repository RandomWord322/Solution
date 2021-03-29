unit UI.ConsoleUI;

interface
uses
  System.SysUtils,
  System.Classes,
  App.Types,
  App.Abstractions,
  UI.ParserCommand,
  UI.GUI,
  UI.Types;

type
  TConsoleUI = class(TBaseUI)
  private
    {Fields}
    fversion: string;
    isTerminate: boolean;
    {Instances}
    parser: TCommandsParser;
  public
    procedure DoRun;
    procedure DoTerminate;
    procedure RunCommand(Data: TCommandData);
    constructor Create; override;
    destructor Destroy; override;
  end;
implementation

{$REGION 'TConsoleUI'}

constructor TConsoleUI.Create;
begin
  inherited;
  isTerminate := False;
  parser := TCommandsParser.Create;
end;

destructor TConsoleUI.Destroy;
begin
  Parser.Free;
  inherited;
end;

procedure TConsoleUI.RunCommand(Data: TCommandData);
begin
  case Data.CommandName of
    TCommandsNames.help:
    begin
      case TCommandsNames.AsCommand(Data.Parametrs[0].Name) of
        TCommandsNames.node:
        begin
          ShowMessage('INFO: Node - command for work with node app.');
        end;

      end;
    end;
    TCommandsNames.node:
    begin
    end;
    TCommandsNames.check:
    begin
      ShowMessage('ECHO: check');
    end;
  end;
end;

procedure TConsoleUI.DoRun;
var
  inputString: string;
  args: strings;
begin
  TThread.CreateAnonymousThread(procedure
  begin
    while not isTerminate do
    begin
      readln(inputString);
      args.SetStrings(inputString);
      RunCommand(parser.TryParse(args));
    end;
  end).Start;

  while not isTerminate do
  begin
    CheckSynchronize(100);
  end;
end;

procedure TConsoleUI.DoTerminate;
begin
  isTerminate := True;
end;
{$ENDREGION}

end.
