unit FrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, WeatherRequestThread, WeatherController, WeatherModel, Util,
  Vcl.Imaging.pngimage, uFrmJsonEditor;

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
    edPais: TEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    btnExibirJson: TcxButton;
    procedure btnBuscaComGrijjyClick(Sender: TObject);
    procedure btnBuscaComRestJsonClick(Sender: TObject);
    procedure btnExibirJsonClick(Sender: TObject);
  private
    procedure MostraResultados(const WeatherData: Tweathermodel);
    procedure DownloadAndDisplayImage(const ImageURL: string);
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
        DownloadAndDisplayImage(WeatherData.Current.Condition.Icon);
    end;
  finally
    WeatherData.Free;
    WeatherController.Free;
  end;
end;

procedure TFormPrincipal.DownloadAndDisplayImage(const ImageURL: string);
var
  MemoryStream: TMemoryStream;
  PNGImage: TPngImage;
begin
  MemoryStream := TMemoryStream.Create;
  PNGImage := TPngImage.Create;
  try
    try
      TUtil.GetImagem(ImageURL, MemoryStream);

      if MemoryStream.Size > 0 then
      begin
        MemoryStream.Position := 0;
        PNGImage.LoadFromStream(MemoryStream);
        ImagemClima.Picture.Assign(PNGImage);
      end
      else
        ShowMessage('Erro: imagem não carregou.');
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
var
  WeatherData: TWeatherModel;
  WeatherController: TWeatherController;
begin
  WeatherController := TWeatherController.Create(TUtil.FormatCityNameForURL(edCidade.Text));
  try
    WeatherController.Get;
    WeatherData := WeatherController.ParseWithRestJson;

    if Assigned(WeatherData) then
    begin
      MostraResultados(WeatherData);

      if not WeatherData.Current.Condition.Icon.IsEmpty then
        DownloadAndDisplayImage(WeatherData.Current.Condition.Icon);
    end;
  finally
    WeatherData.Free;
    WeatherController.Free;
  end;
end;

procedure TFormPrincipal.btnExibirJsonClick(Sender: TObject);
begin
  //chamada para frmjsoneditor
end;

procedure TFormPrincipal.MostraResultados(const WeatherData: Tweathermodel);
begin
  edUltimaAtualizacao.Text := WeatherData.Location.LocalTime;
  edPais.Text              := WeatherData.Location.Country;
  edTemperatura.Text       := WeatherData.Current.TempC.ToString;
  edClima.Text             := WeatherData.Current.Condition.Text;
  edDirecaoVento.Text      := TUtil.GetDirecaoVentoText(WeatherData.Current.WindDir);
  edIndiceUV.Text          := WeatherData.Current.UV.ToString;
end;

end.

