unit BlockChain.Account;

interface
uses
  BlockChain.Types,
  BlockChain.FileHandler,
  System.IOUtils,
  System.SysUtils;
type
  TAccountInfo = record
    ID: int64;
    PublicKey: TKey;
    Address: THash;
    function GetSize: int64;
    function AsBytes: TBytes;
    procedure SetBytes(const Bytes: TBytes);
  end;

  TBlockAccountV1<T> = record
    Header: THeader;
    Data: T;
    IDSigned: integer;
    Sign: TSign;
  end;

  TAccountChain = class
  strict private
    ChainFile: TChainFile;
    FPath: string;
    FName: string;
  public
    procedure SetBlock(ABlock: TBlockAccountV1<TAccountInfo>);
    function  GetBlock(Ind: int64): TBlockAccountV1<TAccountInfo>;
    constructor Create;
    destructor Destroy;override;
  end;

implementation

{$Region 'TChainTrx'}

constructor TAccountChain.Create;
begin
  FName :=  'AccountChain';
  FPath :=  TPath.Combine(GetCurrentDir,FName);
  ChainFile:= TChainFile.Create(FPath);
end;

destructor TAccountChain.Destroy;
begin
  ChainFile.Destroy;
end;

function TAccountChain.GetBlock(Ind: int64): TBlockAccountV1<TAccountInfo>;
var
  Block :TBlockAccountV1<TAccountInfo>;
  Data: TBytes;
begin
  ChainFile.TryRead(Ind,Data);
  Move(Data[0],block.Header,SizeOf(THeader));
  Data := Copy(Data,SizeOf(THeader),Length(Data)-SizeOf(THeader));
  Block.Data.SetBytes(Data);
  Result := Block;
end;

procedure TAccountChain.SetBlock(ABlock: TBlockAccountV1<TAccountInfo>);
var
  Data: TBytes;
  SizeDataWithHeader: int64;
  Counter: integer;
begin
  case ABlock.Header.TypeData of
  0:
    begin
      SizeDataWithHeader := SizeOf(Ablock.Header) + Ablock.Data.GetSize;
      SetLength(Data,SizeDataWithHeader);
      Counter:=0;
      Move(Ablock.Header,Data[Counter],SizeOf(Ablock.Header));
      inc(Counter,SizeOf(Ablock.Header));
      Move(Ablock.Data.AsBytes[0],Data[Counter],Ablock.Data.GetSize);
    end;
  end;

  ChainFile.TryWrite(Data);
end;
{$endregion}


function TAccountInfo.AsBytes: TBytes;
var
  Data: TBytes;
begin
  SetLength(Data, SizeOf(self));
  Move(self,Data[0],SizeOf(self));
  Result := Data;
end;

function TAccountInfo.GetSize: int64;
begin
  Result := SizeOf(self);
end;

procedure TAccountInfo.SetBytes(const Bytes: TBytes);
begin
  Move(Bytes[0],self,SizeOf(self));
end;

end.
