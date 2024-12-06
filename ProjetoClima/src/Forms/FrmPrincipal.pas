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
    cbLanguage: TcxComboBox;
    cbLatitude: TcxTextEdit;
    edCidade: TcxTextEdit;
    cxLabel1: TcxLabel;
    lbLatitude: TcxLabel;
    lbLongitude: TcxLabel;
    lbUnidade: TcxLabel;
    cbUnidade: TcxComboBox;
    btnSaveJson: TcxButton;
    StaticText1: TStaticText;
    memResultado: TcxMemo;
    btnFetchRestJson: TcxButton;
    btnFetchGrijjy: TcxButton;
    procedure btnFetchGrijjyClick(Sender: TObject);
    procedure btnFetchRestJsonClick(Sender: TObject);
    procedure btnSaveJSONClick(Sender: TObject);
  private
    procedure FetchWeather(const UseGrijjy: Boolean);
    procedure OnWeatherSuccess(const Json: string);
    procedure OnWeatherError(const Msg: string);
  public
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

procedure TFormPrincipal.btnFetchGrijjyClick(Sender: TObject);
begin
  FetchWeather(True);
end;
procedure TFormPrincipal.btnFetchRestJsonClick(Sender: TObject);
begin
  FetchWeather(False);
end;
procedure TFormPrincipal.FetchWeather(const UseGrijjy: Boolean);
begin
  memResultado.Clear;
  TWeatherRequestThread.Create(
    edCidade.Text,
    procedure(Json: string)
    begin
      OnWeatherSuccess(Json);
    end,
    procedure(Msg: string)
    begin
      OnWeatherError(Msg);
    end
  ).Start;
end;
procedure TFormPrincipal.OnWeatherSuccess(const Json: string);
var
  Controller: TWeatherController;
  WeatherData: TWeatherModel;
begin
  Controller := TWeatherController.Create;
  try
    if btnFetchGrijjy.Down then
      WeatherData := Controller.ParseWithGrijjy(Json)
    else
      WeatherData := Controller.ParseWithRestJson(Json);
    memResultado.Lines.Add('Region: ' + WeatherData.Region);
    memResultado.Lines.Add('Temp_c: ' + FloatToStr(WeatherData.Temp_c) + '°C');
    memResultado.Lines.Add('Temp_F: ' + FloatToStr(WeatherData.Temp_f) + '°F');
    memResultado.Lines.Add('condition: ' + WeatherData.Condition);
  finally
    Controller.Free;
  end;
end;
procedure TFormPrincipal.OnWeatherError(const Msg: string);
begin
  memResultado.Lines.Add('Erro ao buscar dados: ' + Msg);
end;
procedure TFormPrincipal.btnSaveJSONClick(Sender: TObject);
begin
  memResultado.Lines.SaveToFile('WeatherData.json');
  ShowMessage('Dados salvos em WeatherData.json');
end;
end.
