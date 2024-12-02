unit URLBuilderOpenWeather;


interface

uses
  System.SysUtils;

type
  TOpenWeatherURLBuilder = class
  private
    FBaseURL: string;
    FAPIKey: string;
  public
    constructor Create(APIKey: string);
    function BuildURL(Latitude, Longitude: Double): string;
  end;

implementation

{ TOpenWeatherURLBuilder }

constructor TOpenWeatherURLBuilder.Create(APIKey: string);
begin
  inherited Create;
  FBaseURL := 'https://api.openweathermap.org/data/3.0/onecall';
  FAPIKey := APIKey;
end;

function TOpenWeatherURLBuilder.BuildURL(Latitude, Longitude: Double): string;
begin
  Result := Format('%s?lat=%.6f&lon=%.6f&exclude=minutely,hourly,alerts&appid=%s',
    [FBaseURL, Latitude, Longitude, FAPIKey]);
end;

end.

