unit WeatherModel;

interface

uses
  System.SysUtils, System.Classes, Grijjy.Bson, System.WideStrUtils;

type
  TWeatherModel = class
  private
    Fname, Fregion, Fcontry, Flat, Flon, Fcountry, Flocaltime,
    FTempC, FText, FIcon, FCode, Fwind_mph, Fwind_kph, Fwind_degree,
    Fwind_dir, Fpressure_mb, Fpressure_in, Fprecip_mm, Fprecip_in,
    Fhumidity, Fcloud, Ffeelslike_c, Ffeelslike_f, Fwindchill_c,
    Fwindchill_f, Fheatindex_c, Fheatindex_f, Fdewpoint_c, Fdewpoint_f,
    Fvis_km, Fvis_miles, Fuv, Fgust_mph, Fgust_kph: String;

    procedure CarregarJson(var AJsonFile: string);
    procedure ProcessaJsonLocation(const AJson : TgoBsonDocument);
    procedure ProcessaJsonCurrent(const AJson : TgoBsonDocument);
    procedure ProcessaJsonCondition(const AJson : TgoBsonDocument);

    procedure Setname         (Const Value: String);
    procedure Setregion       (Const Value: String);
    procedure Setcountry      (Const Value: String);
    procedure Setlat          (Const Value: String);
    procedure Setlon          (Const Value: String);
    procedure SetLocaltime    (const Value: String);
    procedure SetTempC        (Const Value: String);
    procedure SetText         (Const Value: String);
    procedure SetFIcon        (const Value: String);
    procedure SetFCode        (Const Value: String);
    procedure SetCode         (const Value: string);
    procedure SetIcon         (const Value: string);
    procedure Setwind_mph     (const Value: string);
    procedure Setwind_kph     (const Value: string);
    procedure Setwind_degree  (const Value: string);
    procedure Setwind_dir     (const Value: string);
    procedure Setpressure_mb  (const Value: string);
    procedure Setpressure_in  (const Value: string);
    procedure Setprecip_mm    (const Value: string);
    procedure Setprecip_in    (const Value: string);
    procedure Sethumidity     (const Value: string);
    procedure Setcloud        (const Value: string);
    procedure Setfeelslike_c  (const Value: string);
    procedure Setfeelslike_f  (const Value: string);
    procedure Setwindchill_c  (const Value: string);
    procedure Setwindchill_f  (const Value: string);
    procedure Setheatindex_c  (const Value: string);
    procedure Setheatindex_f  (const Value: string);
    procedure Setdewpoint_c   (const Value: string);
    procedure Setdewpoint_f   (const Value: string);
    procedure Setvis_km       (const Value: string);
    procedure Setvis_miles    (const Value: string);
    procedure Setuv           (const Value: string);
    procedure Setgust_mph     (const Value: string);
    procedure Setgust_kph     (const Value: string);

  public
    property Name      : string read FName       write SetName;
    property Region    : string read FRegion     write SetRegion;
    property Country   : string read FCountry    write SetCountry;
    property Lat       : string read FLat        write SetLat;
    property Lon       : string read FLon        write SetLon;
    property Localtime : string read FLocaltime  write SetLocaltime;
    property TempC     : string read FTempC      write SetTempC;
    property Text      : string read FText       write SetText;
    property Icon      : string read FIcon       write SetIcon;
    property Code      : string read FCode       write SetCode;

    property wind_mph    : string read Fwind_mph    write Setwind_mph;
    property wind_kph    : string read Fwind_kph    write Setwind_kph;
    property wind_degree : string read Fwind_degree write Setwind_degree;
    property wind_dir    : string read Fwind_dir    write Setwind_dir;
    property pressure_mb : string read Fpressure_mb write Setpressure_mb;
    property pressure_in : string read Fpressure_in write Setpressure_in;
    property precip_mm   : string read Fprecip_mm   write Setprecip_mm;
    property precip_in   : string read Fprecip_in   write Setprecip_in;
    property humidity    : string read Fhumidity    write Sethumidity;
    property cloud       : string read Fcloud       write Setcloud;
    property feelslike_c : string read Ffeelslike_c write Setfeelslike_c;
    property feelslike_f : string read Ffeelslike_f write Setfeelslike_f;
    property windchill_c : string read Fwindchill_c write Setwindchill_c;
    property windchill_f : string read Fwindchill_f write Setwindchill_f;
    property heatindex_c : string read Fheatindex_c write Setheatindex_c;
    property heatindex_f : string read Fheatindex_f write Setheatindex_f;
    property dewpoint_c  : string read Fdewpoint_c  write Setdewpoint_c;
    property dewpoint_f  : string read Fdewpoint_f  write Setdewpoint_f;
    property vis_km      : string read Fvis_km      write Setvis_km;
    property vis_miles   : string read Fvis_miles   write Setvis_miles;
    property uv          : string read Fuv          write Setuv;
    property gust_mph    : string read Fgust_mph    write Setgust_mph;
    property gust_kph    : string read Fgust_kph    write Setgust_kph;

    constructor Create(aJson: String);
  end;

  implementation


  { TWeatherModel }

procedure TWeatherModel.CarregarJson(var AJsonFile: string);
var
  AJsonDocument, AJsonLocation, AJsonCurrent, AJsonCondition: TgoBsonDocument;
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
  Icon        := AJson['Icon'].ToString();
  Code        := AJson['Code'].ToString();
  wind_mph    := AJson['wind_mph'].ToString();
  wind_kph    := AJson['wind_kph'].ToString();
  wind_degree := AJson['wind_degree'].ToString();
  wind_dir    := AJson['wind_dir'].ToString();
  pressure_mb := AJson['pressure_mb'].ToString();
  pressure_in := AJson['pressure_in'].ToString();
  precip_mm   := AJson['precip_mm'].ToString();
  precip_in   := AJson['precip_in'].ToString();
  humidity    := AJson['humidity'].ToString();
  cloud       := AJson['cloud'].ToString();
  feelslike_c := AJson['feelslike_c'].ToString();
  feelslike_f := AJson['feelslike_f'].ToString();
  windchill_c := AJson['windchill_c'].ToString();
  windchill_f := AJson['windchill_f'].ToString();
  heatindex_c := AJson['heatindex_c'].ToString();
  heatindex_f := AJson['heatindex_f'].ToString();
  dewpoint_c  := AJson['dewpoint_c'].ToString();
  dewpoint_f  := AJson['dewpoint_f'].ToString();
  vis_km      := AJson['vis_km'].ToString();
  vis_miles   := AJson['vis_miles'].ToString();
  uv          := AJson['uv'].ToString();
  gust_mph    := AJson['gust_mph'].ToString();
  gust_kph    := AJson['gust_kph'].ToString();
end;

procedure TWeatherModel.ProcessaJsonCurrent(const AJson: TgoBsonDocument);
begin
  TempC := AJson['temp_c'].ToString();
end;

procedure TWeatherModel.ProcessaJsonLocation(const AJson: TgoBsonDocument);
begin
  Name       := AJson['name'].ToString();
  Region     := AJson['region'].ToString();
  Country    := AJson['country'].ToString();
  Lat        := AJson['lat'].ToString();
  Lon        := AJson['lon'].ToString();
  Localtime  := AJson['localtime'].ToString();
end;

procedure TWeatherModel.SetText(const Value: string);
begin
  FText := Value;
end;

procedure TWeatherModel.Setcloud(const Value: string);
begin
  Fcloud := Value;
end;

procedure TWeatherModel.Setuv(const Value: string);
begin
  Fuv := Value;
end;

procedure TWeatherModel.Setvis_km(const Value: string);
begin
  Fvis_km := Value;
end;

procedure TWeatherModel.Setvis_miles(const Value: string);
begin
  Fvis_miles := Value;
end;

procedure TWeatherModel.Setwindchill_c(const Value: string);
begin
  Fwindchill_c := Value;
end;

procedure TWeatherModel.Setwindchill_f(const Value: string);
begin
  Fwindchill_f := Value;
end;

procedure TWeatherModel.Setwind_degree(const Value: string);
begin
  Fwind_degree := Value;
end;

procedure TWeatherModel.Setwind_dir(const Value: string);
begin
  Fwind_dir := Value;
end;

procedure TWeatherModel.Setwind_kph(const Value: string);
begin
  Fwind_kph := Value;
end;

procedure TWeatherModel.Setwind_mph(const Value: string);
begin
  Fwind_mph := Value;
end;

procedure TWeatherModel.SetCode(const Value: string);
begin
  FCode := Value;
end;

procedure TWeatherModel.Setcountry(const Value: String);
begin
  Fcountry := Value;
end;

procedure TWeatherModel.Setdewpoint_c(const Value: string);
begin
  Fdewpoint_c := Value;
end;

procedure TWeatherModel.Setdewpoint_f(const Value: string);
begin
  Fdewpoint_f := Value;
end;

procedure TWeatherModel.SetFCode(const Value: String);
begin
  FCode := Value;
end;

procedure TWeatherModel.Setfeelslike_c(const Value: string);
begin
  Ffeelslike_c := Value;
end;

procedure TWeatherModel.Setfeelslike_f(const Value: string);
begin
  Ffeelslike_f := Value;
end;

procedure TWeatherModel.SetFIcon(const Value: String);
begin
  FIcon := Value;
end;

procedure TWeatherModel.Setgust_kph(const Value: string);
begin
  Fgust_kph := Value;
end;

procedure TWeatherModel.Setgust_mph(const Value: string);
begin
  Fgust_mph := Value;
end;

procedure TWeatherModel.Setheatindex_c(const Value: string);
begin
  Fheatindex_c := Value;
end;

procedure TWeatherModel.Setheatindex_f(const Value: string);
begin
  Fheatindex_f := Value;
end;

procedure TWeatherModel.Sethumidity(const Value: string);
begin
  Fhumidity := Value;
end;

procedure TWeatherModel.SetIcon(const Value: string);
begin
  FIcon := Value;
end;

procedure TWeatherModel.Setlat(const Value: String);
begin
  Flat := Value;
end;

procedure TWeatherModel.SetLocaltime(const Value: string);
begin
  FLocaltime := Value;
end;

procedure TWeatherModel.Setlon(const Value: String);
begin
  Flon := Value;
end;

procedure TWeatherModel.Setname(const Value: String);
begin
  Fname := Value;
end;

procedure TWeatherModel.Setprecip_in(const Value: string);
begin
  Fprecip_in := Value;
end;

procedure TWeatherModel.Setprecip_mm(const Value: string);
begin
  Fprecip_mm := Value;
end;

procedure TWeatherModel.Setpressure_in(const Value: string);
begin
  Fpressure_in := Value;
end;

procedure TWeatherModel.Setpressure_mb(const Value: string);
begin
  Fpressure_mb := Value;
end;

procedure TWeatherModel.Setregion(const Value: String);
begin
  Fregion := Value;
end;

procedure TWeatherModel.SetTempC(const Value: String);
begin
  FTempC := Value;
end;

end.


