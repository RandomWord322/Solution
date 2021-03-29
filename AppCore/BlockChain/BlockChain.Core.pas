unit BlockChain.Core;

interface
uses
  System.SysUtils,
  System.Hash,
  BlockChain.Account,
  BlockChain.Types;
type
  TBlockChainCore = class
  private
    AccountsChain : TAccountChain;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation


{ TBlockChainCore }

constructor TBlockChainCore.Create;
begin
  AccountsChain := TAccountChain.Create;
end;

destructor TBlockChainCore.Destroy;
begin
  AccountsChain.Free;
  inherited;
end;

end.
