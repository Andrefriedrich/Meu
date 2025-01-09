unit FrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, WeatherRequestThread, WeatherController, WeatherModel,
  cxMemo, Util;

type
  TFormPrincipal = class(TForm)
    edCidade: TcxTextEdit;
    btnApagar: TcxButton;
    memResultado: TcxMemo;
    btnBuscaComRestJson: TcxButton;
    btnBuscaComGrijjy: TcxButton;
    procedure btnBuscaComGrijjyClick(Sender: TObject);
    procedure btnBuscaComRestJsonClick(Sender: TObject);
    procedure btnApagarClick(Sender: TObject);
  private
    procedure FazBusca(const UseGrijjy: Boolean);
    procedure OnWeatherError(const Msg: string);
    procedure MostraResultados(const WeatherData: Tweathermodel);
  public
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

procedure TFormPrincipal.btnBuscaComGrijjyClick(Sender: TObject);
var
  WeatherData: TWeatherModel;
  WeatherController: TWeatherController;
begin
  WeatherController := TWeatherController.Create(FormatCityNameForURL(edCidade.Text));
  try
    WeatherController.Get;
    WeatherData := WeatherController.ParseWithGrijjy;
    if Assigned(WeatherData) then
      MostraResultados(WeatherData);
  finally

  end;
end;

procedure TFormPrincipal.btnBuscaComRestJsonClick(Sender: TObject);
begin
  FazBusca(False); // entra aqui usa Rest.Json
end;

procedure TFormPrincipal.FazBusca(const UseGrijjy: Boolean);
begin
  memResultado.Clear;

  if edCidade.Text = '' then
  begin
    memResultado.Lines.Add('Por favor, insira o nome da cidade!');
    Exit;
  end;

end;

procedure TFormPrincipal.MostraResultados(const WeatherData: Tweathermodel);
begin
  memResultado.Lines.Add('Ultima atualização de dados: ' + WeatherData.Localtime);
  memResultado.Lines.Add('Cidade: ' + WeatherData.Name);
  memResultado.Lines.Add('Região: ' + WeatherData.Region);
  memResultado.Lines.Add('País: ' + WeatherData.Country);
  memResultado.Lines.Add('Latitude: ' + WeatherData.Lat.ToString);
  memResultado.Lines.Add('Longitude: ' + WeatherData.Lon.ToString);
  memResultado.Lines.Add('Temperatura: ' + WeatherData.TempC.ToString);
  memResultado.Lines.Add('Clima: ' + WeatherData.Text);
  memResultado.Lines.Add('Vento em km/h: ' + WeatherData.wind_kph.ToString);
  memResultado.Lines.Add('Direção do vento: ' + GetDirecaoVentoText(WeatherData.wind_dir));
  memResultado.Lines.Add('Precipitação: ' + WeatherData.precip_mm.ToString);
  memResultado.Lines.Add('Humidade: ' + WeatherData.humidity.ToString);
  memResultado.Lines.Add('Distancia de visão: ' + WeatherData.vis_km.ToString);
  memResultado.Lines.Add('Indice UV: ' + WeatherData.uv.ToString);

  memResultado.Lines.Add('Qualidade do ar');
  memResultado.Lines.Add('Monoxido de carbono: ' + WeatherData.co.ToString + 'm3');
  memResultado.Lines.Add('Ozonio: ' + WeatherData.o3.ToString + 'm3');
  memResultado.Lines.Add('Dioxido de nidrogenio: ' + WeatherData.no2.ToString + 'm3');
end;

procedure TFormPrincipal.OnWeatherError(const Msg: string);
begin
  memResultado.Lines.Add('Erro ao buscar dados: ' + Msg);
end;

procedure TFormPrincipal.btnApagarClick(Sender: TObject);
begin
  memResultado.Clear;
end;

end.

