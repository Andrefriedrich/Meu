unit RestJson.JsonParser;

interface

uses
  System.SysUtils, System.Classes, System.Json, REST.Json, JsonParserIntf,
  WeatherModel;

type
  TRestJsonParser = class(TInterfacedObject, IJsonParser)
  private
    FLastError: string;
  public
    function ParseWeatherData(const AJson: string): TWeatherModel;
    function SerializeWeatherData(const AWeatherData: TWeatherModel): string;
    function GetLastError: string;
    function GetParserName: string;
  end;

implementation

function TRestJsonParser.GetLastError: string;
begin
  Result := FLastError;
end;

function TRestJsonParser.ParseWeatherData(const AJson: string): TWeatherModel;
begin
  FLastError := '';
  Result := nil;

  if string.IsNullOrWhiteSpace(AJson) or (AJson[1] <> '{') then
  begin
     FLastError := 'JSON inválido';
     Exit;
  end;

  try
    Result := TJson.JsonToObject<TWeatherModel>(AJson);
    FLastError := '';
  except
    on E: Exception do
    begin
      FLastError := 'Erro no parse REST.Json: ' + E.Message;
      Result := nil;
    end;
  end;
end;

function TRestJsonParser.SerializeWeatherData(const AWeatherData: TWeatherModel): string;
begin
  FLastError := '';
  Result := '';

  if not Assigned(AWeatherData) then
  begin
    FLastError := 'objeto WeatherData esta nill.';
    Exit;
  end;

  try
    Result := TJson.ObjectToJsonString(AWeatherData);
    FLastError := '';

     var LJsonValue := TJSONObject.ParseJSONValue(Result);
     try
       Result := LJsonValue.Format(2);
     finally
       LJsonValue.Free;
     end;

  except
    on E: Exception do
    begin
      FLastError := 'Erro ao serializar REST.Json: ' + E.Message;
      Result := '';
    end;
  end;
end;

function TRestJsonParser.GetParserName: string;
begin
  Result := 'TRestJsonParser';
end;
end.
