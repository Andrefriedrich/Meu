unit FrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, WeatherRequestThread, WeatherController, WeatherModel,
  cxMemo;

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
    procedure OnWeatherSuccess(const Json: string; const UseGrijjy: Boolean);
    procedure OnWeatherError(const Msg: string);
  public
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

procedure TFormPrincipal.btnBuscaComGrijjyClick(Sender: TObject);
begin
  FazBusca(True); // entra aqui usa Grijjy
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

  TWeatherRequestThread.Create(
    edCidade.Text,
    procedure(Json: string)
    begin
      OnWeatherSuccess(Json, UseGrijjy);
    end,
    procedure(Msg: string)
    begin
      OnWeatherError(Msg);
    end
  ).Start;
end;

procedure TFormPrincipal.OnWeatherSuccess(const Json: string; const UseGrijjy: Boolean);
var
  Controller: TWeatherController;
  WeatherData: TWeatherModel;
begin
  Controller := TWeatherController.Create;
  try
    try
      if UseGrijjy then
        WeatherData := Controller.ParseWithGrijjy(Json)
      else
        WeatherData := Controller.ParseWithRestJson(Json);

      memResultado.Lines.Add('Horário da consulta: ' + WeatherData.Localtime);
      memResultado.Lines.Add('Cidade: ' + WeatherData.Name);
      memResultado.Lines.Add('Região: ' + WeatherData.Region);
      memResultado.Lines.Add('País: ' + WeatherData.Country);
      memResultado.Lines.Add('Latitude: ' + WeatherData.Lat);
      memResultado.Lines.Add('Longitude: ' + WeatherData.Lon);
      memResultado.Lines.Add('Temperatura: ' + WeatherData.TempC);
    except
      on E: Exception do
        memResultado.Lines.Add('Erro ao processar JSON: ' + E.Message);
    end;
  finally
    Controller.Free;
    WeatherData.Free;
  end;
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

