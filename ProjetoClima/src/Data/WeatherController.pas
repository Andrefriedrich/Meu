unit WeatherController;

interface

uses
  System.SysUtils, WeatherModel, WeatherRequestThread, System.Classes;

type
  TWeatherController = class
  private
    FCity, FURL : String;
    Fresponse : String;
    FResponseImage: TMemoryStream;
    function GetURL: String;
  public
    function ParseWithGrijjy: TWeatherModel;
    function ParseWithRestJson: TWeatherModel;
    Procedure Get;
    constructor Create(City : String);

    procedure GetImagem;
    procedure SetURLImagem(const URL: String);
    procedure SaveResponseToStream(Stream: TStream);
  end;

implementation

constructor TWeatherController.Create(City: String);
begin
  FCity := City;
end;

procedure TWeatherController.Get;
  var Request : TWeatherRequest;
begin
  Request := TWeatherRequest.Create(GetURL);
  try
    FResponse := Request.Get;
  finally
    Request.Free;
  end;
end;

function TWeatherController.GetURL: String;
begin
  Result := Format('http://api.weatherapi.com/v1/current.json?key=b809c9b15772403e8e810413240512&q=%s&aqi=yes&lang=pt', [FCity]);
end;

function TWeatherController.ParseWithGrijjy: TWeatherModel;
begin
  Result := TWeatherModel.Create(Fresponse);
end;

function TWeatherController.ParseWithRestJson: TWeatherModel;
begin
  //Result := TWeatherModel.Create(Json);
end;

procedure TWeatherController.SetURLImagem(const URL: String);
begin
  FURL := 'https:' + URL;
end;

procedure TWeatherController.GetImagem;
var
  Request: TWeatherRequest;
begin
  FreeAndNil(FResponseImage);
  FResponseImage := TMemoryStream.Create;

  Request := TWeatherRequest.Create(FURL);
  try
    Request.GetImagem(FResponseImage);
  finally
    Request.Free;
  end;
end;

procedure TWeatherController.SaveResponseToStream(Stream: TStream);
begin
  if Assigned(FResponseImage) then
  begin
    FResponseImage.Position := 0;
    Stream.CopyFrom(FResponseImage, FResponseImage.Size);
  end;
end;
end.

