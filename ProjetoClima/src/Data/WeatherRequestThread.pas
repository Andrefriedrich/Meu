unit WeatherRequestThread;

interface

uses
  System.Classes, System.SysUtils;

type
  TWeatherRequest = class
  private
    FURL: string;

  public
    function Get : String;
    procedure GetImagem(Stream: TStream);
    constructor Create(const URL: string);
  end;

implementation

uses
  IdHTTP;

{ TWeatherRequestThread }

constructor TWeatherRequest.Create(const URL: string);
begin
  FURL := URL;
end;

function TWeatherRequest.Get: String;
var
  HTTP: TIdHTTP;
begin
  Result := '';
  HTTP   := TIdHTTP.Create(nil);
  try
    try
      Result := HTTP.Get(FURL);
    except
//      on E: Exception do
  //      FErrorMsg := E.Message;
    end;
  finally
    HTTP.Free;
  end;
end;

procedure TWeatherRequest.GetImagem(Stream: TStream);
var
  HttpClient: TIdHTTP;
begin
  HttpClient := TIdHTTP.Create;
  try
    HttpClient.Get(FURL, Stream);
  finally
    HttpClient.Free;
  end;
end;

end.

