unit WeatherModel;

interface

uses
  System.SysUtils, System.Classes, System.JSON;

type
  TWeatherModel = class
  private
    FJson: TJSONObject;
    function GetSubObject(const Path: string): TJSONObject;
  public
    constructor Create(const AJson: string);
    destructor Destroy;

    function GetLocationName: string;
    function GetRegion: string;
    function GetCountry: string;
    function GetLatitude: Double;
    function GetLongitude: Double;
    function GetTimeZone: string;
    function GetLocalTimeEpoch: Int64;
    function GetLocalTime: string;

    function GetLastUpdated: string;
    function GetTemperatureC: Double;
    function GetTemperatureF: Double;
    function GetIsDay: Integer;
    function GetConditionText: string;
    function GetConditionIcon: string;
    function GetWindMph: Double;
    function GetWindKph: Double;
    function GetWindDegree: Integer;
    function GetWindDir: string;
    function GetPressureMb: Double;
    function GetPressureIn: Double;
    function GetPrecipMm: Double;
    function GetPrecipIn: Double;
    function GetHumidity: Integer;
    function GetCloud: Integer;
    function GetFeelsLikeC: Double;
    function GetFeelsLikeF: Double;
    function GetVisibilityKm: Double;
    function GetVisibilityMiles: Double;
    function GetUVIndex: Double;
    function GetGustMph: Double;
    function GetGustKph: Double;

    function GetAirQualityCO: Double;
    function GetAirQualityNO2: Double;
    function GetAirQualityO3: Double;
    function GetAirQualitySO2: Double;
    function GetAirQualityPM25: Double;
    function GetAirQualityPM10: Double;
    function GetAirQualityUSEPAIndex: Integer;
    function GetAirQualityGBDefraIndex: Integer;
  end;

implementation

constructor TWeatherModel.Create(const AJson: string);
begin
  inherited Create;
  try
    FJson := TJSONObject.ParseJSONValue(AJson) as TJSONObject;
    if not Assigned(FJson) then
      raise Exception.Create('Formato invalido.');
  except
    on E: Exception do
      raise Exception.Create('Erro: ' + E.Message);
  end;
end;

destructor TWeatherModel.Destroy;
begin
  FJson.Free;
end;

function TWeatherModel.GetSubObject(const Path: string): TJSONObject;
var
  SubObject: TJSONValue;
begin
  SubObject := FJson.FindValue(Path);
  if not Assigned(SubObject) or not (SubObject is TJSONObject) then
    raise Exception.Create(Format('Sub-object "%s" not found or is invalid.', [Path]));
  Result := SubObject as TJSONObject;
end;

function TWeatherModel.GetLocationName: string;
begin
  Result := FJson.GetValue<string>('location.name');
end;

function TWeatherModel.GetRegion: string;
begin
  Result := FJson.GetValue<string>('location.region');
end;

function TWeatherModel.GetCountry: string;
begin
  Result := FJson.GetValue<string>('location.country');
end;

function TWeatherModel.GetLatitude: Double;
begin
  Result := FJson.GetValue<Double>('location.lat');
end;

function TWeatherModel.GetLongitude: Double;
begin
  Result := FJson.GetValue<Double>('location.lon');
end;

function TWeatherModel.GetTimeZone: string;
begin
  Result := FJson.GetValue<string>('location.tz_id');
end;

function TWeatherModel.GetLocalTimeEpoch: Int64;
begin
  Result := FJson.GetValue<Int64>('location.localtime_epoch');
end;

function TWeatherModel.GetLocalTime: string;
begin
  Result := FJson.GetValue<string>('location.localtime');
end;

function TWeatherModel.GetLastUpdated: string;
begin
  Result := FJson.GetValue<string>('current.last_updated');
end;

function TWeatherModel.GetTemperatureC: Double;
begin
  Result := FJson.GetValue<Double>('current.temp_c');
end;

function TWeatherModel.GetTemperatureF: Double;
begin
  Result := FJson.GetValue<Double>('current.temp_f');
end;

function TWeatherModel.GetIsDay: Integer;
begin
  Result := FJson.GetValue<Integer>('current.is_day');
end;

function TWeatherModel.GetConditionText: string;
begin
  Result := FJson.GetValue<string>('current.condition.text');
end;

function TWeatherModel.GetConditionIcon: string;
begin
  Result := FJson.GetValue<string>('current.condition.icon');
end;

function TWeatherModel.GetWindMph: Double;
begin
  Result := FJson.GetValue<Double>('current.wind_mph');
end;

function TWeatherModel.GetWindKph: Double;
begin
  Result := FJson.GetValue<Double>('current.wind_kph');
end;

function TWeatherModel.GetWindDegree: Integer;
begin
  Result := FJson.GetValue<Integer>('current.wind_degree');
end;

function TWeatherModel.GetWindDir: string;
begin
  Result := FJson.GetValue<string>('current.wind_dir');
end;

function TWeatherModel.GetPressureMb: Double;
begin
  Result := FJson.GetValue<Double>('current.pressure_mb');
end;

function TWeatherModel.GetPressureIn: Double;
begin
  Result := FJson.GetValue<Double>('current.pressure_in');
end;

function TWeatherModel.GetPrecipMm: Double;
begin
  Result := FJson.GetValue<Double>('current.precip_mm');
end;

function TWeatherModel.GetPrecipIn: Double;
begin
  Result := FJson.GetValue<Double>('current.precip_in');
end;

function TWeatherModel.GetHumidity: Integer;
begin
  Result := FJson.GetValue<Integer>('current.humidity');
end;

function TWeatherModel.GetCloud: Integer;
begin
  Result := FJson.GetValue<Integer>('current.cloud');
end;

function TWeatherModel.GetFeelsLikeC: Double;
begin
  Result := FJson.GetValue<Double>('current.feelslike_c');
end;

function TWeatherModel.GetFeelsLikeF: Double;
begin
  Result := FJson.GetValue<Double>('current.feelslike_f');
end;

function TWeatherModel.GetVisibilityKm: Double;
begin
  Result := FJson.GetValue<Double>('current.vis_km');
end;

function TWeatherModel.GetVisibilityMiles: Double;
begin
  Result := FJson.GetValue<Double>('current.vis_miles');
end;

function TWeatherModel.GetUVIndex: Double;
begin
  Result := FJson.GetValue<Double>('current.uv');
end;

function TWeatherModel.GetGustMph: Double;
begin
  Result := FJson.GetValue<Double>('current.gust_mph');
end;

function TWeatherModel.GetGustKph: Double;
begin
  Result := FJson.GetValue<Double>('current.gust_kph');
end;

function TWeatherModel.GetAirQualityCO: Double;
begin
  Result := FJson.GetValue<Double>('current.air_quality.co');
end;

function TWeatherModel.GetAirQualityNO2: Double;
begin
  Result := FJson.GetValue<Double>('current.air_quality.no2');
end;

function TWeatherModel.GetAirQualityO3: Double;
begin
  Result := FJson.GetValue<Double>('current.air_quality.o3');
end;

function TWeatherModel.GetAirQualitySO2: Double;
begin
  Result := FJson.GetValue<Double>('current.air_quality.so2');
end;

function TWeatherModel.GetAirQualityPM25: Double;
begin
  Result := FJson.GetValue<Double>('current.air_quality.pm2_5');
end;

function TWeatherModel.GetAirQualityPM10: Double;
begin
  Result := FJson.GetValue<Double>('current.air_quality.pm10');
end;

function TWeatherModel.GetAirQualityUSEPAIndex: Integer;
begin
  Result := FJson.GetValue<Integer>('current.air_quality.us-epa-index');
end;

function TWeatherModel.GetAirQualityGBDefraIndex: Integer;
begin
  Result := FJson.GetValue<Integer>('current.air_quality.gb-defra-index');
end;

end.

