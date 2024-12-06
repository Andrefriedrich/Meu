unit WeatherController;

interface

uses
  System.SysUtils, WeatherModel;

type
  TWeatherController = class
  public
    function ParseWithGrijjy(const Json: string): TWeatherModel;
    function ParseWithRestJson(const Json: string): TWeatherModel;
  end;

implementation

uses
  Grijjy.Bson.Serialization,grijjy.Bson.IO ,Rest.Json;

{ TWeatherController }

function TWeatherController.ParseWithGrijjy(const Json: string): TWeatherModel;
begin
  Result := TJson.JsonToObject<TWeatherModel>(Json);
end;

function TWeatherController.ParseWithRestJson(const Json: string): TWeatherModel;
begin
  Result := TJson.JsonToObject<TWeatherModel>(Json);
end;

end.

