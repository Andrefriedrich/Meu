unit Util;

interface

uses
  System.Generics.Collections, System.NetEncoding, WeatherRequestThread, System.Classes,
  system.SysUtils;

  type
  TUtil = class
  private
    class procedure SetURLImagem(const URL: String); static;
  public
    class function GetDirecaoVentoText(const Abbreviation: string): string;
    class function FormatCityNameForURL(const CityName: string): string;
    class procedure GetImagem(const aURL: string; AResponseStream: TStream);
    class procedure SaveResponseToStream(AResponseStream: TStream; const DestStream: TStream);
  end;

implementation

var
  Direcao: TDictionary<string, string>;
  FResponseImage: TMemoryStream;
  FURL : String;

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

class function TUtil.GetDirecaoVentoText(const Abbreviation: string): string;
begin
  if not Direcao.TryGetValue(Abbreviation, Result) then
    Result := 'Direção desconhecida';
end;

class function TUtil.FormatCityNameForURL(const CityName: string): string;
begin
  Result := TNetEncoding.URL.Encode(CityName);
end;

class procedure TUtil.GetImagem(const aURL: string; AResponseStream: TStream);
var
  Request: TWeatherRequest;
begin
  if Assigned(AResponseStream) then
  begin
    SetURLImagem(aURL);
    Request := TWeatherRequest.Create(FURL);
    try
      Request.GetImagem(AResponseStream);
    finally
      Request.Free;
    end;
  end;
end;

class procedure TUtil.SaveResponseToStream(AResponseStream: TStream;
  const DestStream: TStream);
begin
  if Assigned(AResponseStream) and Assigned(DestStream) then
  begin
    AResponseStream.Position := 0;
    DestStream.CopyFrom(AResponseStream, AResponseStream.Size);
  end
  else
    raise Exception.Create('SaveResponseToStream deu pau');
end;

class procedure TUtil.SetURLImagem(const URL: String);
begin
  FURL := 'https:' + URL;
end;

initialization
  InitializeDirecao;

finalization
  Direcao.Free;
end.

