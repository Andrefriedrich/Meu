unit WeatherModel;

interface

uses
  System.SysUtils, System.Classes, Grijjy.Bson, System.WideStrUtils;

type
  TWeatherModel = class
  private
    Fname, Fregion, Fcontry, Flat, Flon, Fcountry, Flocaltime: String;

    procedure CarregarJson(var AJsonFile: string);
    procedure ProcessaJson(const AJson : TgoBsonDocument);
    procedure Setname(Const Value: String);
    procedure Setregion(Const Value: String);
    procedure Setcountry(Const Value: String);
    procedure Setlat(Const Value: String);
    procedure Setlon(Const Value: String);
    procedure SetLocaltime(const Value: string);

  public
    property Name      : string read FName       write SetName;
    property Region    : string read FRegion     write SetRegion;
    property Country   : string read FCountry    write SetCountry;
    property Lat       : string read FLat        write SetLat;
    property Lon       : string read FLon        write SetLon;
    property Localtime : string read FLocaltime  write SetLocaltime;

    constructor Create(aJson: String);
  end;

  implementation


  { TWeatherModel }

procedure TWeatherModel.CarregarJson(var AJsonFile: string);
var
  AJsonDocument, AJsonLocation: TgoBsonDocument;
begin
  if IsUTF8String(AJsonFile) then
    AJsonFile := UTF8Decode(AJsonFile);

  if TgoBsonDocument.TryParse(AJsonFile, AJsonDocument) then
  begin
    if AJsonDocument.Contains('location') then
      if TgoBsonDocument.TryParse(AJsonDocument['location'].AsBsonDocument.ToJson, AJsonLocation) then
        ProcessaJson(AJsonLocation);
  end;
end;

constructor TWeatherModel.Create(aJson: String);
begin
  CarregarJson(aJson);
end;

procedure TWeatherModel.ProcessaJson(const AJson: TgoBsonDocument);
begin
  Name       := AJson['name'].ToString();
  Region     := AJson['region'].ToString();
  Country    := AJson['country'].ToString();
  Lat        := AJson['lat'].ToString();
  Lon        := AJson['lon'].ToString();
  Localtime  := AJson['localtime'].ToString();
end;


procedure TWeatherModel.Setcountry(const Value: String);
begin
  Fcontry := Value;
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

procedure TWeatherModel.Setregion(const Value: String);
begin
  Fregion := Value;
end;



end.


