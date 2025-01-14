unit WeatherController;

interface

uses
  System.SysUtils, WeatherModel, WeatherRequestThread, System.Classes;

type
  TWeatherController = class
  private
    FCity, FURL : String;
    Fresponse : String;
    function GetURL: String;
  public
    function ParseWithGrijjy: TWeatherModel;
    function ParseWithRestJson: TWeatherModel;
    Procedure Get;
    constructor Create(City : String);

    procedure GetImagem;
    procedure SetURL(const URL: String);
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

procedure TWeatherController.SetURL(const URL: String);
begin
  FURL := URL; // Permite redefinir a URL diretamente
end;

procedure TWeatherController.GetImagem;
var
  Request: TWeatherRequest;
begin
  Request := TWeatherRequest.Create(FURL);
  try
    FResponse := Request.Get; // Realiza a requisição e salva a resposta
  finally
    Request.Free;
  end;
end;

procedure TWeatherController.SaveResponseToStream(Stream: TStream);
var
  ResponseBytes: TBytes;
begin
  if not FResponse.IsEmpty then
  begin
    ResponseBytes := TEncoding.UTF8.GetBytes(FResponse);
    Stream.WriteBuffer(ResponseBytes[0], Length(ResponseBytes));
  end;
end;

end.

