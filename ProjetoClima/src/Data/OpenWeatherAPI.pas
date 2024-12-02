unit OpenWeatherAPI;

interface

uses
  HTTPClient, OpenWeatherURLBuilder, System.SysUtils;

type
  TOpenWeatherAPI = class
  private
    FHTTPClient: THTTPClient;
    FURLBuilder: TOpenWeatherURLBuilder;
  public
    constructor Create(APIKey: string);
    destructor Destroy; override;
    function GetWeatherData(Latitude, Longitude: Double): string;
  end;

implementation

{ TOpenWeatherAPI }

constructor TOpenWeatherAPI.Create(APIKey: string);
begin
  inherited Create;
  FHTTPClient := THTTPClient.Create;
  FURLBuilder := TOpenWeatherURLBuilder.Create(APIKey);
end;

destructor TOpenWeatherAPI.Destroy;
begin
  FURLBuilder.Free;
  FHTTPClient.Free;
  inherited Destroy;
end;

function TOpenWeatherAPI.GetWeatherData(Latitude, Longitude: Double): string;
var
  URL: string;
begin
  URL := FURLBuilder.BuildURL(Latitude, Longitude);
  Result := FHTTPClient.Get(URL);
end;

end.

