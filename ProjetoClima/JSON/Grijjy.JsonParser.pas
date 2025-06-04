unit Grijjy.JsonParser;

interface

uses
  System.SysUtils, System.Classes, Grijjy.Bson, System.WideStrUtils,
  JsonParserIntf, WeatherModel;

type
  TGrijjyJsonParser = class(TInterfacedObject, IJsonParser)
  private
    FLastError: string;
    LLocation: TLocation;
    LCurrent: TCurrent;

    procedure CarregarJson(var AJsonFileString: string);
    procedure ProcessaJsonLocation(const AJson: TgoBsonDocument);
    procedure ProcessaJsonCurrent(const AJson: TgoBsonDocument);
    procedure ProcessaJsonCondition(const AJson: TgoBsonDocument);
    procedure ProcessaJsonAirQuality(const AJson: TgoBsonDocument);
  public
    function ParseWeatherData(const AJson: string): TWeatherModel;
    function SerializeWeatherData(const AWeatherData: TWeatherModel): string;
    function GetLastError: string;
    function GetParserName: string;
    property Location: TLocation read LLocation write LLocation;
    property Current: TCurrent read LCurrent write LCurrent;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TGrijjyJsonParser }

procedure TGrijjyJsonParser.CarregarJson(var AJsonFileString: string);
var
  AJsonDocument, AJsonCurrent, AJsonLocation: TgoBsonDocument;
begin
  if IsUTF8String(AJsonFileString) then
    AJsonFileString := UTF8Decode(AJsonFileString);

  if TgoBsonDocument.TryParse(AJsonFileString, AJsonDocument) then
  begin
    if AJsonDocument.Contains('location') then
    begin
      AJsonLocation := AJsonDocument['location'].AsBsonDocument;
      ProcessaJsonLocation(AJsonLocation);
    end;

    if AJsonDocument.Contains('current') then
    begin
      AJsonCurrent := AJsonDocument['current'].AsBsonDocument;
      ProcessaJsonCurrent(AJsonCurrent);

      if AJsonCurrent.Contains('condition') then
        ProcessaJsonCondition(AJsonCurrent['condition'].AsBsonDocument);

      if AJsonCurrent.Contains('air_quality') then
        ProcessaJsonAirQuality(AJsonCurrent['air_quality'].AsBsonDocument);
    end;
  end;
end;

constructor TGrijjyJsonParser.Create;
begin
  LLocation := TLocation.Create;
  LCurrent  := TCurrent.Create;
end;

destructor TGrijjyJsonParser.Destroy;
begin
  LLocation.Free;
  LCurrent.Free;
  inherited;
end;

procedure TGrijjyJsonParser.ProcessaJsonAirQuality(const AJson: TgoBsonDocument);
begin
  LCurrent.AirQuality.CO           := AJson['co'].ToDouble();
  LCurrent.AirQuality.NO2          := AJson['no2'].ToDouble();
  LCurrent.AirQuality.O3           := AJson['o3'].ToDouble();
  LCurrent.AirQuality.SO2          := AJson['so2'].ToDouble();
  LCurrent.AirQuality.PM2_5        := AJson['pm2_5'].ToDouble();
  LCurrent.AirQuality.PM10         := AJson['pm10'].ToDouble();
  LCurrent.AirQuality.USEPAIndex   := AJson['us-epa-index'].ToInteger();
  LCurrent.AirQuality.GBDefraIndex := AJson['gb-defra-index'].ToInteger();
end;

procedure TGrijjyJsonParser.ProcessaJsonCondition(const AJson: TgoBsonDocument);
begin
  LCurrent.Condition.Text := AJson['text'].ToString();
  LCurrent.Condition.Icon := AJson['icon'].ToString();
  LCurrent.Condition.Code := AJson['code'].ToInteger();
end;

procedure TGrijjyJsonParser.ProcessaJsonCurrent(const AJson: TgoBsonDocument);
begin
  LCurrent.TempC      := AJson['temp_c'].ToDouble();
  LCurrent.TempF      := AJson['temp_f'].ToDouble();
  LCurrent.IsDay      := AJson['is_day'].ToInteger();
  LCurrent.WindMph    := AJson['wind_mph'].ToDouble();
  LCurrent.WindKph    := AJson['wind_kph'].ToDouble();
  LCurrent.WindDegree := AJson['wind_degree'].ToInteger();
  LCurrent.WindDir    := AJson['wind_dir'].ToString();
  LCurrent.PressureMb := AJson['pressure_mb'].ToDouble();
  LCurrent.PressureIn := AJson['pressure_in'].ToDouble();
  LCurrent.PrecipMm   := AJson['precip_mm'].ToDouble();
  LCurrent.PrecipIn   := AJson['precip_in'].ToDouble();
  LCurrent.Humidity   := AJson['humidity'].ToInteger();
  LCurrent.Cloud      := AJson['cloud'].ToInteger();
  LCurrent.FeelsLikeC := AJson['feelslike_c'].ToDouble();
  LCurrent.FeelsLikeF := AJson['feelslike_f'].ToDouble();
  LCurrent.WindChillC := AJson['windchill_c'].ToDouble();
  LCurrent.WindChillF := AJson['windchill_f'].ToDouble();
  LCurrent.HeatIndexC := AJson['heatindex_c'].ToDouble();
  LCurrent.HeatIndexF := AJson['heatindex_f'].ToDouble();
  LCurrent.DewPointC  := AJson['dewpoint_c'].ToDouble();
  LCurrent.DewPointF  := AJson['dewpoint_f'].ToDouble();
  LCurrent.VisKm      := AJson['vis_km'].ToDouble();
  LCurrent.VisMiles   := AJson['vis_miles'].ToDouble();
  LCurrent.UV         := AJson['uv'].ToDouble();
  LCurrent.GustMph    := AJson['gust_mph'].ToDouble();
  LCurrent.GustKph    := AJson['gust_kph'].ToDouble();
end;

procedure TGrijjyJsonParser.ProcessaJsonLocation(const AJson: TgoBsonDocument);
begin
  LLocation.Name      := AJson['name'].ToString();
  LLocation.Region    := AJson['region'].ToString();
  LLocation.Country   := AJson['country'].ToString();
  LLocation.Lat       := AJson['lat'].ToDouble();
  LLocation.Lon       := AJson['lon'].ToDouble();
  LLocation.LocalTime := AJson['localtime'].ToString();
end;

function TGrijjyJsonParser.ParseWeatherData(const AJson: string): TWeatherModel;
var
  LJson: string;
begin
  try
    LJson := AJson;
    CarregarJson(LJson);

    Result := TWeatherModel.Create;
    Result.Location := LLocation;
    Result.Current := LCurrent;
    FLastError := '';
  except
    on E: Exception do
    begin
      FLastError := 'Erro ao fazer parse do JSON: ' + E.Message;
    end;
  end;
end;

function TGrijjyJsonParser.SerializeWeatherData(const AWeatherData: TWeatherModel): string;
var
  Doc, LocationDoc, CurrentDoc, ConditionDoc, AirDoc: TgoBsonDocument;
begin
  Result := '';
  try
    Doc := TgoBsonDocument.Create;

    LocationDoc := TgoBsonDocument.Create;
    LocationDoc.Add('name', AWeatherData.Location.Name);
    LocationDoc.Add('region', AWeatherData.Location.Region);
    LocationDoc.Add('country', AWeatherData.Location.Country);
    LocationDoc.Add('lat', AWeatherData.Location.Lat);
    LocationDoc.Add('lon', AWeatherData.Location.Lon);
    LocationDoc.Add('localtime', AWeatherData.Location.LocalTime);
    Doc.Add('location', LocationDoc);

    CurrentDoc := TgoBsonDocument.Create;
    with AWeatherData.Current do
    begin
      CurrentDoc.Add('temp_c', TempC);
      CurrentDoc.Add('temp_f', TempF);
      CurrentDoc.Add('is_day', IsDay);
      CurrentDoc.Add('wind_mph', WindMph);
      CurrentDoc.Add('wind_kph', WindKph);
      CurrentDoc.Add('wind_degree', WindDegree);
      CurrentDoc.Add('wind_dir', WindDir);
      CurrentDoc.Add('pressure_mb', PressureMb);
      CurrentDoc.Add('pressure_in', PressureIn);
      CurrentDoc.Add('precip_mm', PrecipMm);
      CurrentDoc.Add('precip_in', PrecipIn);
      CurrentDoc.Add('humidity', Humidity);
      CurrentDoc.Add('cloud', Cloud);
      CurrentDoc.Add('feelslike_c', FeelsLikeC);
      CurrentDoc.Add('feelslike_f', FeelsLikeF);
      CurrentDoc.Add('windchill_c', WindChillC);
      CurrentDoc.Add('windchill_f', WindChillF);
      CurrentDoc.Add('heatindex_c', HeatIndexC);
      CurrentDoc.Add('heatindex_f', HeatIndexF);
      CurrentDoc.Add('dewpoint_c', DewPointC);
      CurrentDoc.Add('dewpoint_f', DewPointF);
      CurrentDoc.Add('vis_km', VisKm);
      CurrentDoc.Add('vis_miles', VisMiles);
      CurrentDoc.Add('uv', UV);
      CurrentDoc.Add('gust_mph', GustMph);
      CurrentDoc.Add('gust_kph', GustKph);

      ConditionDoc := TgoBsonDocument.Create;
      ConditionDoc.Add('text', Condition.Text);
      ConditionDoc.Add('icon', Condition.Icon);
      ConditionDoc.Add('code', Condition.Code);
      CurrentDoc.Add('condition', ConditionDoc);

      AirDoc := TgoBsonDocument.Create;
      AirDoc.Add('co', AirQuality.CO);
      AirDoc.Add('no2', AirQuality.NO2);
      AirDoc.Add('o3', AirQuality.O3);
      AirDoc.Add('so2', AirQuality.SO2);
      AirDoc.Add('pm2_5', AirQuality.PM2_5);
      AirDoc.Add('pm10', AirQuality.PM10);
      AirDoc.Add('us-epa-index', AirQuality.USEPAIndex);
      AirDoc.Add('gb-defra-index', AirQuality.GBDefraIndex);
      CurrentDoc.Add('air_quality', AirDoc);
    end;

    Doc.Add('current', CurrentDoc);

    Result := Doc.ToJson;
    FLastError := '';
  except
    on E: Exception do
    begin
      FLastError := 'Erro ao serializar WeatherData: ' + E.Message;
      Result := '';
    end;
  end;
end;

function TGrijjyJsonParser.GetLastError: string;
begin
  Result := FLastError;
end;

function TGrijjyJsonParser.GetParserName: string;
begin
  Result := 'TGrijjyJsonParser';
end;

end.

