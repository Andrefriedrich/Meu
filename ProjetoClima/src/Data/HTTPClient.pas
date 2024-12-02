unit HTTPClient;

interface

uses
  System.SysUtils, IdHTTP;

type
  THTTPClient = class
  private
    FIdHTTP: TIdHTTP;
  public
    constructor Create;
    destructor Destroy; override;
    function Get(URL: string): string;
  end;

implementation

{ THTTPClient }

constructor THTTPClient.Create;
begin
  inherited Create;
  FIdHTTP := TIdHTTP.Create(nil);
end;

destructor THTTPClient.Destroy;
begin
  FIdHTTP.Free;
  inherited Destroy;
end;

function THTTPClient.Get(URL: string): string;
begin
  try
    Result := FIdHTTP.Get(URL);
  except
    on E: Exception do
      raise Exception.Create('Erro ao realizar a requisição: ' + E.Message);
  end;
end;

end.

