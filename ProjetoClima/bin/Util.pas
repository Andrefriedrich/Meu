unit Util;

interface

function GetDirecaoVentoText(const Abbreviation: string): string;
function FormatCityNameForURL(const CityName: string): string;

implementation

uses
  System.Generics.Collections, System.NetEncoding;

var
  Direcao: TDictionary<string, string>;

procedure InitializeDirecao;
begin
  Direcao := TDictionary<string, string>.Create;
  Direcao.Add('N', 'Norte');
  Direcao.Add('E', 'Leste');
  Direcao.Add('S', 'Sul');
  Direcao.Add('W', 'Oeste');
  Direcao.Add('NE', 'Nordeste');
  Direcao.Add('SE', 'Sudeste');
  Direcao.Add('SW', 'Sudoeste');
  Direcao.Add('NW', 'Noroeste');
  Direcao.Add('NNE', 'Norte-Nordeste');
  Direcao.Add('ENE', 'Leste-Nordeste');
  Direcao.Add('ESE', 'Leste-Sudeste');
  Direcao.Add('SSE', 'Sul-Sudeste');
  Direcao.Add('SSW', 'Sul-Sudoeste');
  Direcao.Add('WSW', 'Oeste-Sudoeste');
  Direcao.Add('WNW', 'Oeste-Noroeste');
  Direcao.Add('NNW', 'Norte-Noroeste');
end;

function GetDirecaoVentoText(const Abbreviation: string): string;
begin
  if not Direcao.TryGetValue(Abbreviation, Result) then
    Result := 'Direção desconhecida';
end;

function FormatCityNameForURL(const CityName: string): string;
begin
  Result := TNetEncoding.URL.Encode(CityName);
end;

initialization
  InitializeDirecao;
end.

