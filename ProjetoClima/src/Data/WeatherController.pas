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

function TWeatherController.ParseWithGrijjy(const Json: string): TWeatherModel;
begin
  Result := TWeatherModel.Create(Json);
end;

function TWeatherController.ParseWithRestJson(const Json: string): TWeatherModel;
begin
  Result := TWeatherModel.Create(Json);
end;

end.

