unit WeatherModel;

interface

uses
  System.SysUtils, System.Classes, Grijjy.Bson, System.WideStrUtils;

type
  TWeatherModel = class
  private
    FName, FRegion, FCountry, FLocaltime, FText, FIcon, FWind_dir  :String;

    FCode, FWind_degree, FHumidity, FCloud, FUS_EPA_Index, FGB_DEFRA_Index: Integer;
    FLat, FLon, FTempC, FWind_mph, FWind_kph, FPressure_mb, FPressure_in, FPrecip_mm,
    FPrecip_in, FFeelslike_c, FFeelslike_f, FWindchill_c, FWindchill_f, FHeatindex_c,FHeatindex_f,
    FDewpoint_c, FDewpoint_f, FVis_km, FVis_miles, FUV, FGust_mph, FGust_kph, FCO, FNO2, FO3,
    FSO2, FPM2_5, FPM10: Double;
    procedure CarregarJson(var AJsonFile: string);
    procedure ProcessaJsonLocation(const AJson : TgoBsonDocument);
    procedure ProcessaJsonCurrent(const AJson : TgoBsonDocument);
    procedure ProcessaJsonCondition(const AJson : TgoBsonDocument);
    procedure ProcessaJsonAirQuality(const AJson: TgoBsonDocument);

    procedure SetName             (Const Value: String);
    procedure Setregion           (Const Value: String);
    procedure Setcountry          (Const Value: String);
    procedure Setlat              (Const Value: Double);
    procedure Setlon              (Const Value: Double);
    procedure SetLocaltime        (const Value: String);
    procedure SetTempC            (Const Value: Double);
    procedure SetText             (Const Value: String);
    procedure SetIcon             (const Value: String);
    procedure SetCode             (Const Value: Integer);
    procedure Setwind_mph         (const Value: Double);
    procedure Setwind_kph         (const Value: Double);
    procedure Setwind_degree      (const Value: Integer);
    procedure Setwind_dir         (const Value: String);
    procedure Setpressure_mb      (const Value: Double);
    procedure Setpressure_in      (const Value: Double);
    procedure Setprecip_mm        (const Value: Double);
    procedure Setprecip_in        (const Value: Double);
    procedure Sethumidity         (const Value: Integer);
    procedure Setcloud            (const Value: Integer);
    procedure Setfeelslike_c      (const Value: Double);
    procedure Setfeelslike_f      (const Value: Double);
    procedure Setwindchill_c      (const Value: Double);
    procedure Setwindchill_f      (const Value: Double);
    procedure Setheatindex_c      (const Value: Double);
    procedure Setheatindex_f      (const Value: Double);
    procedure Setdewpoint_c       (const Value: Double);
    procedure Setdewpoint_f       (const Value: Double);
    procedure Setvis_km           (const Value: Double);
    procedure Setvis_miles        (const Value: Double);
    procedure Setuv               (const Value: Double);
    procedure Setgust_mph         (const Value: Double);
    procedure Setgust_kph         (const Value: Double);
    procedure Setco               (const Value: Double);
    procedure Setno2              (const Value: Double);
    procedure Seto3               (const Value: Double);
    procedure Setso2              (const Value: Double);
    procedure Setpm2_5            (const Value: Double);
    procedure Setpm10             (const Value: Double);
    procedure Setus_epa_index     (const Value: Integer);
    procedure Setgb_defra_index   (const Value: Integer);

  public
    property Name      : string read FName       write SetName;
    property Region    : string read FRegion     write SetRegion;
    property Country   : string read FCountry    write SetCountry;
    property Lat       : Double read FLat        write SetLat;
    property Lon       : Double read FLon        write SetLon;
    property Localtime : string read FLocaltime  write SetLocaltime;
    property TempC     : Double read FTempC      write SetTempC;
    property Text      : string read FText       write SetText;
    property Icon      : string read FIcon       write SetIcon;
    property Code      : Integer read FCode       write SetCode;

    property wind_mph    : Double read Fwind_mph    write Setwind_mph;
    property wind_kph    : Double read Fwind_kph    write Setwind_kph;
    property wind_degree : Integer read Fwind_degree write Setwind_degree;
    property wind_dir    : string read Fwind_dir    write Setwind_dir;
    property pressure_mb : Double read Fpressure_mb write Setpressure_mb;
    property pressure_in : Double read Fpressure_in write Setpressure_in;
    property precip_mm   : Double read Fprecip_mm   write Setprecip_mm;
    property precip_in   : Double read Fprecip_in   write Setprecip_in;
    property humidity    : Integer read Fhumidity    write Sethumidity;
    property cloud       : Integer read Fcloud       write Setcloud;
    property feelslike_c : Double read Ffeelslike_c write Setfeelslike_c;
    property feelslike_f : Double read Ffeelslike_f write Setfeelslike_f;
    property windchill_c : Double read Fwindchill_c write Setwindchill_c;
    property windchill_f : Double read Fwindchill_f write Setwindchill_f;
    property heatindex_c : Double read Fheatindex_c write Setheatindex_c;
    property heatindex_f : Double read Fheatindex_f write Setheatindex_f;
    property dewpoint_c  : Double read Fdewpoint_c  write Setdewpoint_c;
    property dewpoint_f  : Double read Fdewpoint_f  write Setdewpoint_f;
    property vis_km      : Double read Fvis_km      write Setvis_km;
    property vis_miles   : Double read Fvis_miles   write Setvis_miles;
    property uv          : Double read Fuv          write Setuv;
    property gust_mph    : Double read Fgust_mph    write Setgust_mph;
    property gust_kph    : Double read Fgust_kph    write Setgust_kph;

    property co             : Double read Fco               write Setco;
    property no2            : Double read Fno2              write Setno2;
    property o3             : Double read Fo3               write Seto3;
    property so2            : Double read Fso2              write Setso2;
    property pm2_5          : Double read Fpm2_5            write Setpm2_5;
    property pm10           : Double read Fpm10             write Setpm10;
    property us_epa_index   : Integer read Fus_epa_index    write Setus_epa_index;
    property gb_defra_index : Integer read Fgb_defra_index  write Setgb_defra_index;

    constructor Create(aJson: String);
  end;

  implementation


  { TWeatherModel }

procedure TWeatherModel.CarregarJson(var AJsonFile: string);
var
  AJsonDocument, AJsonLocation, AJsonCurrent, AJsonCondition, AJsonAirQuality: TgoBsonDocument;
begin
  if IsUTF8String(AJsonFile) then
    AJsonFile := UTF8Decode(AJsonFile);

  if TgoBsonDocument.TryParse(AJsonFile, AJsonDocument) then
  begin
    if AJsonDocument.Contains('location') then
      if TgoBsonDocument.TryParse(AJsonDocument['location'].AsBsonDocument.ToJson, AJsonLocation) then
        ProcessaJsonLocation(AJsonLocation);

    if AJsonDocument.Contains('current') then
    begin
      if TgoBsonDocument.TryParse(AJsonDocument['current'].AsBsonDocument.ToJson, AJsonCurrent) then
        ProcessaJsonCurrent(AJsonCurrent);

      if AJsonCurrent.Contains('condition') then
        if TgoBsonDocument.TryParse(AJsonCurrent['condition'].AsBsonDocument.ToJson, AJsonCondition) then
          ProcessaJsonCondition(AJsonCondition);

      if AJsonCurrent.Contains('air_quality') then
        if TgoBsonDocument.TryParse(AJsonCurrent['air_quality'].AsBsonDocument.ToJson, AJsonAirQuality) then
          ProcessaJsonAirQuality(AJsonAirQuality);
    end;
  end;
end;

constructor TWeatherModel.Create(aJson: String);
begin
  CarregarJson(aJson);
end;

procedure TWeatherModel.ProcessaJsonCondition(const AJson: TgoBsonDocument);
begin
  Text        := AJson['text'].ToString();
  Icon        := AJson['icon'].ToString();
  Code        := AJson['code'].ToInteger();
end;

procedure TWeatherModel.ProcessaJsonCurrent(const AJson: TgoBsonDocument);
begin
  TempC       := AJson['temp_c'].ToDouble();
  wind_mph    := AJson['wind_mph'].ToDouble();
  wind_kph    := AJson['wind_kph'].ToDouble();
  wind_degree := AJson['wind_degree'].ToInteger();
  wind_dir    := AJson['wind_dir'].ToString();
  pressure_mb := AJson['pressure_mb'].ToDouble();
  pressure_in := AJson['pressure_in'].ToDouble();
  precip_mm   := AJson['precip_mm'].ToDouble();
  precip_in   := AJson['precip_in'].ToDouble();
  humidity    := AJson['humidity'].ToInteger();
  cloud       := AJson['cloud'].ToInteger();
  feelslike_c := AJson['feelslike_c'].ToDouble();
  feelslike_f := AJson['feelslike_f'].ToDouble();
  windchill_c := AJson['windchill_c'].ToDouble();
  windchill_f := AJson['windchill_f'].ToDouble();
  heatindex_c := AJson['heatindex_c'].ToDouble();
  heatindex_f := AJson['heatindex_f'].ToDouble();
  dewpoint_c  := AJson['dewpoint_c'].ToDouble();
  dewpoint_f  := AJson['dewpoint_f'].ToDouble();
  vis_km      := AJson['vis_km'].ToDouble();
  vis_miles   := AJson['vis_miles'].ToDouble();
  uv          := AJson['uv'].ToDouble();
  gust_mph    := AJson['gust_mph'].ToDouble();
  gust_kph    := AJson['gust_kph'].ToDouble();
end;

procedure TWeatherModel.ProcessaJsonAirQuality(const AJson: TgoBsonDocument);
begin
  co              := AJson['co'].ToDouble();
  no2             := AJson['no2'].ToDouble();
  o3              := AJson['o3'].ToDouble();
  so2             := AJson['so2'].ToDouble();
  pm2_5           := AJson['pm2_5'].ToDouble();
  pm10            := AJson['pm10'].ToDouble();
  us_epa_index    := AJson['us_epa_index'].ToInteger();
  gb_defra_index  := AJson['gb_defra_index'].ToInteger();
end;

procedure TWeatherModel.ProcessaJsonLocation(const AJson: TgoBsonDocument);
begin
  Name       := AJson['name'].ToString();
  Region     := AJson['region'].ToString();
  Country    := AJson['country'].ToString();
  Lat        := AJson['lat'].ToInteger();
  Lon        := AJson['lon'].ToInteger();
  Localtime  := AJson['localtime'].ToString();
end;

procedure TWeatherModel.SetText(const Value: string);
begin
  FText := Value;
end;

procedure TWeatherModel.Setcloud(const Value: Integer);
begin
  Fcloud := Value;
end;

procedure TWeatherModel.Setco(const Value: Double);
begin
  Fco := Value;
end;

procedure TWeatherModel.Setus_epa_index(const Value: Integer);
begin
  Fus_epa_index := Value;
end;

procedure TWeatherModel.Setuv(const Value: Double);
begin
  Fuv := Value;
end;

procedure TWeatherModel.Setvis_km(const Value: Double);
begin
  Fvis_km := Value;
end;

procedure TWeatherModel.Setvis_miles(const Value: Double);
begin
  Fvis_miles := Value;
end;

procedure TWeatherModel.Setwindchill_c(const Value: Double);
begin
  Fwindchill_c := Value;
end;

procedure TWeatherModel.Setwindchill_f(const Value: Double);
begin
  Fwindchill_f := Value;
end;

procedure TWeatherModel.Setwind_degree(const Value: Integer);
begin
  Fwind_degree := Value;
end;

procedure TWeatherModel.Setwind_dir(const Value: string);
begin
  Fwind_dir := Value;
end;

procedure TWeatherModel.Setwind_kph(const Value: Double);
begin
  Fwind_kph := Value;
end;

procedure TWeatherModel.Setwind_mph(const Value: Double);
begin
  Fwind_mph := Value;
end;

procedure TWeatherModel.SetCode(const Value: Integer);
begin
  FCode := Value;
end;

procedure TWeatherModel.Setcountry(const Value: String);
begin
  Fcountry := Value;
end;

procedure TWeatherModel.Setdewpoint_c(const Value: Double);
begin
  Fdewpoint_c := Value;
end;

procedure TWeatherModel.Setdewpoint_f(const Value: Double);
begin
  Fdewpoint_f := Value;
end;

procedure TWeatherModel.Setfeelslike_c(const Value: Double);
begin
  Ffeelslike_c := Value;
end;

procedure TWeatherModel.Setfeelslike_f(const Value: Double);
begin
  Ffeelslike_f := Value;
end;

procedure TWeatherModel.SetIcon(const Value: String);
begin
  FIcon := Value;
end;

procedure TWeatherModel.Setgb_defra_index(const Value: Integer);
begin
  Fgb_defra_index := Value;
end;

procedure TWeatherModel.Setgust_kph(const Value: Double);
begin
  Fgust_kph := Value;
end;

procedure TWeatherModel.Setgust_mph(const Value: Double);
begin
  Fgust_mph := Value;
end;

procedure TWeatherModel.Setheatindex_c(const Value: Double);
begin
  Fheatindex_c := Value;
end;

procedure TWeatherModel.Setheatindex_f(const Value: Double);
begin
  Fheatindex_f := Value;
end;

procedure TWeatherModel.Sethumidity(const Value: Integer);
begin
  Fhumidity := Value;
end;

procedure TWeatherModel.Setlat(const Value: Double);
begin
  Flat := Value;
end;

procedure TWeatherModel.SetLocaltime(const Value: string);
begin
  FLocaltime := Value;
end;

procedure TWeatherModel.Setlon(const Value: Double);
begin
  Flon := Value;
end;

procedure TWeatherModel.Setname(const Value: String);
begin
  Fname := Value;
end;

procedure TWeatherModel.Setno2(const Value: Double);
begin
  Fno2 := Value;
end;

procedure TWeatherModel.Seto3(const Value: Double);
begin
  Fo3  := Value;
end;

procedure TWeatherModel.Setpm10(const Value: Double);
begin
  Fpm10  := Value;
end;

procedure TWeatherModel.Setpm2_5(const Value: Double);
begin
  Fpm2_5  := Value;
end;

procedure TWeatherModel.Setprecip_in(const Value: Double);
begin
  Fprecip_in := Value;
end;

procedure TWeatherModel.Setprecip_mm(const Value: Double);
begin
  Fprecip_mm := Value;
end;

procedure TWeatherModel.Setpressure_in(const Value: Double);
begin
  Fpressure_in := Value;
end;

procedure TWeatherModel.Setpressure_mb(const Value: Double);
begin
  Fpressure_mb := Value;
end;

procedure TWeatherModel.Setregion(const Value: String);
begin
  Fregion := Value;
end;

procedure TWeatherModel.Setso2(const Value: Double);
begin
  Fso2 := Value;
end;

procedure TWeatherModel.SetTempC(const Value: Double);
begin
  FTempC := Value;
end;

end.


