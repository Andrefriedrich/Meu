unit WeatherViewIntf;

interface

uses
  System.Classes, Vcl.Graphics, WeatherModel;

type
  IWeatherView = interface
    function GetCidadeParaBusca: string;
    procedure SetStatus(const AMsg: string);
    procedure ExibirDadosClima(const AWeatherData: TWeatherModel);
    procedure ExibirIconeClima(AImagem: TGraphic);
    procedure LimparExibicaoClima;
    procedure HabilitarBotaoExibirJson(AEnabled: Boolean);
    procedure MostrarMensagemErro(const AMsg: string);
    procedure MostrarMensagemInfo(const AMsg: string);
    procedure FocarNoCampoCidade;
  end;

implementation

end.
