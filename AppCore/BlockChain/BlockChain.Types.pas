unit BlockChain.Types;

interface
const
  MaxFileSize = 209715200;
  IndexBaseFileName = 'IndexData';
  ChainBaseFileName = 'ChainData';

type
  THash = array [0..31] of Byte;
  TKey = array [0..31] of Byte;
  TSign = array [0..31] of Byte;

  THeader = record
    PreviosHash: THash;
    TypeData: Byte;
    Size: Int64;
  end;

  TIndexData = packed record
    id: int64;
    StartByte: int64;
    TypeData: Byte;
    VersionData: Byte;
    Size: int64;
  end;

implementation

end.
