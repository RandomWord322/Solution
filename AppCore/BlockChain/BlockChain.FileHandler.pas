unit BlockChain.FileHandler;

interface
 uses
  BlockChain.Types,
  System.Classes,
  System.SyncObjs,
  System.SysUtils,
  System.IOUtils;
type
{$region 'Types'}
  TIndexFile = class
  strict private
    FPath: string;
    FNameOwner: string;
    FIndexFile: file of TIndexData;
    FLock: TMonitor;
    procedure CreateNewFile(const APath, AName: string);
    function  CheckFileSize: boolean;
    function  ReadIndex(index: integer = -1): TIndexData;
    procedure WriteIndex(var index: TIndexData);
  public
    function  TryRead(const from: int64): TIndexData;
    procedure TryWrite(var Data: TIndexData);
    constructor Create(const APath: string);
    destructor Destroy; override;
  end;

  TChainFile = class
  private
    FPath: string;
    FName: string;
    FChainFile: File;
    FIndexFile: TIndexFile;
    FLock: TMonitor;
    function CheckFileSize(var size: int64): boolean;
    function ReadData(index: TIndexData): TBytes;
    procedure WriteData(const Data: TBytes);
  public
    function TryRead(const from: int64; var Data:TBytes): boolean;
    function TryWrite(const Data: TBytes): boolean;
    constructor Create(const APath: string);
    destructor Destroy; override;
  end;
{$endregion}
implementation

{$Region 'TChainFile'}

function TChainFile.CheckFileSize(var size: int64): boolean;
var
  fs: integer;
begin
  Assign(FChainFile, FPath);
  Reset(FChainFile);
  fs := FileSize(FChainFile);
  size := fs;
  CloseFile(FChainFile);
  if fs >= MaxFileSize then
    Result := False
  else
    Result := True;
end;

constructor TChainFile.Create(const APath: string);
begin
  FPath := APath;
  if not tfile.Exists(APath) then
  begin
    AssignFile(FChainFile,Apath);
    Rewrite(FChainFile);
    Close(FChainFile);
  end;
  FIndexFile :=  TIndexFile.Create(APath);
end;

destructor TChainFile.Destroy;
begin
  FPath := '';
  FName := '';
  FIndexFile.Free;
end;


function TChainFile.ReadData(index: TIndexData): TBytes;
var
  StartByte: int64;
begin
  AssignFile(FChainFile,FPath);
  Reset(FChainFile, 1);
  seek(FChainFile,index.StartByte);
  setLength(Result,index.Size);
  BlockRead(FChainFile,Result[0],index.Size);
  CloseFile(FChainFile);
end;


function TChainFile.TryRead(const from: int64; var Data:TBytes): boolean;
var
  index: TIndexData;
begin
  try
    index := FIndexFile.TryRead(from);
    Data := ReadData(index);
  except

  end;
end;

function TChainFile.TryWrite(const Data: TBytes): boolean;
var
  Locked: boolean;
  index: TIndexData;
  shift: integer;
begin
  Result:=False;
  Locked := False;
  try
    Locked := FLock.TryEnter(self);
    if Locked then
    begin
      CheckFileSize(index.StartByte);
      shift := SizeOf(THash);
      move(Data[shift],index.TypeData,1);
      index.Size := length(data);
      WriteData(Data);
      FIndexFile.TryWrite(index);
    end;
  finally
    if Locked then
    begin
      Result := True;
      FLock.Exit(self);
    end;
  end;
end;

procedure TChainFile.WriteData(const Data: TBytes);
begin
  AssignFile(FChainFile, FPath);
  Reset(FChainFile,1);
  BlockWrite(FChainFile, Data[0],length(Data));
  CloseFile(FChainFile);
end;

{$endregion}

{$region 'TIndexFile'}
function TIndexFile.CheckFileSize: boolean;
var
  fs: integer;
begin
  Assign(FIndexFile, FPath);
  fs := FileSize(FIndexFile);
  CloseFile(FIndexFile);
  if fs >= MaxFileSize then
    Result := False
  else
    Result := True;
end;

constructor TIndexFile.Create(const APath: string);
begin
  FPath := APath+'Index';;
  if not TFile.Exists(FPath) then
  begin
    AssignFile(FIndexFile,FPath);
    Rewrite(FIndexFile);
    Close(FIndexFile);
  end;
end;

procedure TIndexFile.CreateNewFile(const APath, AName: string);
var
  PathName: string;
begin
  PathName:= TPath.Combine(APath,AName);
  Assign(FIndexFile,PathName);
  Rewrite(FIndexFile);
  Close(FIndexFile);
end;

destructor TIndexFile.Destroy;
begin
  FPath := '';
  FNameOwner := '';
end;


function TIndexFile.ReadIndex(index: integer = -1): TIndexData;
begin
  AssignFile(FIndexFile,FPath);
  Reset(FIndexFile);
  if index = -1 then
    Seek(FIndexFile,FileSize(FIndexFile)-1)
  else
    Seek(FIndexFile,index);
  Read(FIndexFile, Result);
  CloseFile(FIndexFile);
end;

function TIndexFile.TryRead(const from: int64): TIndexData;
var
  Locked: boolean;
begin
  try
    Locked := FLock.TryEnter(Self);
    Result := ReadIndex(from);
  finally
    FLock.Exit(self);
  end;
end;

procedure TIndexFile.TryWrite(var Data: TIndexData);
var
  Locked: boolean;
begin
  Locked := False;
  try
    Locked := FLock.TryEnter(self);
    if Locked then
    begin
      WriteIndex(Data);
    end;
  finally
    if Locked then
      FLock.Exit(self);
  end;
end;
procedure TIndexFile.WriteIndex(var index: TIndexData);
var
  LastIndex: int64;
begin
  AssignFile(FIndexFile, FPath);
  Reset(FIndexFile);
  index.id := FileSize(FIndexFile);
  Write(FIndexFile, index);
  CloseFile(FIndexFile);
end;

{$endregion}
end.
