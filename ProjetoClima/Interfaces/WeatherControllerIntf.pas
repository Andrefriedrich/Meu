unit WeatherControllerIntf;

interface

uses
  WeatherViewIntf, JsonParserIntf;

type
  TParserType = (ptRestJson, ptGrijjyJson);

  IWeatherController = interface
    procedure SetView(AView: IWeatherView);
    procedure InicializarParsers;
    procedure IniciarBuscaClima(AParserType: TParserType);
    procedure ExibirJsonAtual;
    procedure Finalizar;
  end;

implementation

end.
