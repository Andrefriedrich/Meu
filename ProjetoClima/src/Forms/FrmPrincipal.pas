unit FrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, WeatherRequestThread, WeatherController, WeatherModel,
  cxMemo, Util, Vcl.Imaging.pngimage;

type
  TFormPrincipal = class(TForm)
    edCidade: TcxTextEdit;
    btnBuscaComRestJson: TcxButton;
    btnBuscaComGrijjy: TcxButton;
    ImagemClima: TImage;
    lbUltimaAtualizacao: TcxLabel;
    lbTemperatura: TcxLabel;
    lbClima: TcxLabel;
    lbIndiceUV: TcxLabel;
    lbDirecaoVento: TcxLabel;
    edUltimaAtualizacao: TEdit;
    edTemperatura: TEdit;
    edClima: TEdit;
    edIndiceUV: TEdit;
    edDirecaoVento: TEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    procedure btnBuscaComGrijjyClick(Sender: TObject);
    procedure btnBuscaComRestJsonClick(Sender: TObject);
  private
    procedure FazBusca(const UseGrijjy: Boolean);
    procedure OnWeatherError(const Msg: string);
    procedure MostraResultados(const WeatherData: Tweathermodel);
    procedure DownloadAndDisplayImageWithController(
      WeatherController: TWeatherController; const ImageURL: string);
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
  WeatherController := TWeatherController.Create(TUtil.FormatCityNameForURL(edCidade.Text));
  try
    WeatherController.Get;
    WeatherData := WeatherController.ParseWithGrijjy;
    if Assigned(WeatherData) then
    begin
      MostraResultados(WeatherData);
      if not  WeatherData.Current.Condition.Icon.IsEmpty then
        DownloadAndDisplayImageWithController(WeatherController, WeatherData.Current.Condition.Icon);
    end;
  finally
    WeatherController.Free;
  end;
end;

procedure TFormPrincipal.DownloadAndDisplayImageWithController(WeatherController: TWeatherController; const ImageURL: string);
var
  MemoryStream: TMemoryStream;
  PNGImage: TPngImage;
begin
  MemoryStream := TMemoryStream.Create;
  PNGImage := TPngImage.Create;
  try
    try
      WeatherController.SetURLImagem(ImageURL);
      WeatherController.GetImagem;
      WeatherController.SaveResponseToStream(MemoryStream);
      MemoryStream.Position := 0;
      PNGImage.LoadFromStream(MemoryStream);
      ImagemClima.Picture.Assign(PNGImage);
    except
      on E: Exception do
        ShowMessage('Erro ao baixar a imagem: ' + E.Message);
    end;
  finally
    MemoryStream.Free;
    PNGImage.Free;
  end;
end;

procedure TFormPrincipal.btnBuscaComRestJsonClick(Sender: TObject);
begin
  FazBusca(False); // entra aqui usa Rest.Json
end;

procedure TFormPrincipal.FazBusca(const UseGrijjy: Boolean);
begin

end;

procedure TFormPrincipal.MostraResultados(const WeatherData: Tweathermodel);
begin
  edUltimaAtualizacao.Text := WeatherData.Location.LocalTime;
  edTemperatura.Text       := WeatherData.Current.TempC.ToString;
  edClima.Text             := WeatherData.Current.Condition.Text;
  edDirecaoVento.Text      := TUtil.GetDirecaoVentoText(WeatherData.Current.WindDir);
  edIndiceUV.Text          := WeatherData.Current.UV.ToString;

 { memResultado.Lines.Add('Cidade: ' + WeatherData.Name);
  memResultado.Lines.Add('Região: ' + WeatherData.Region);
  memResultado.Lines.Add('País: ' + WeatherData.Country);
  memResultado.Lines.Add('Latitude: ' + WeatherData.Lat.ToString);
  memResultado.Lines.Add('Longitude: ' + WeatherData.Lon.ToString);
  memResultado.Lines.Add('Temperatura: ' + WeatherData.TempC.ToString);
  memResultado.Lines.Add('Clima: ' + WeatherData.Text);
  memResultado.Lines.Add('Vento em km/h: ' + WeatherData.wind_kph.ToString);
  memResultado.Lines.Add('Direção do vento: ' + TUtil.GetDirecaoVentoText(WeatherData.wind_dir));
  memResultado.Lines.Add('Precipitação: ' + WeatherData.precip_mm.ToString);
  memResultado.Lines.Add('Humidade: ' + WeatherData.humidity.ToString);
  memResultado.Lines.Add('Distancia de visão: ' + WeatherData.vis_km.ToString + 'Km');
  memResultado.Lines.Add('Indice UV: ' + WeatherData.uv.ToString);

  memResultado.Lines.Add('Qualidade do ar');
  memResultado.Lines.Add('Monoxido de carbono: ' + WeatherData.co.ToString + 'm3');
  memResultado.Lines.Add('Ozonio: ' + WeatherData.o3.ToString + 'm3');
  memResultado.Lines.Add('Dioxido de nitrogenio: ' + WeatherData.no2.ToString + 'm3'); }
end;

procedure TFormPrincipal.OnWeatherError(const Msg: string);
begin

end;
end.

