unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, Vcl.Menus, Vcl.StdCtrls,
  cxButtons, Vcl.ExtCtrls, Vcl.Imaging.pngimage, WeatherModel, Util,
  WeatherViewIntf, WeatherControllerIntf, uControllerPrincipal;

type
  TFormPrincipal = class(TForm, IWeatherView)
    edCidade: TcxTextEdit;
    btnBuscaComRestJson: TcxButton;
    btnBuscaComGrijjy: TcxButton;
    ImagemClima: TImage;
    lbUltimaAtualizacao: TcxLabel;
    lbTemperatura: TcxLabel;
    lbClima: TcxLabel;
    lbIndiceUV: TcxLabel;
    lbDirecaoVento: TcxLabel;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    lbStatus: TcxLabel;
    btnExibirJson: TcxButton;
    cxLabel4: TcxLabel;
    lbCidade: TcxLabel;
    lbPais: TcxLabel;
    lbDataHoraDados: TcxLabel;
    lbDescricaoClima: TcxLabel;
    lbVento: TcxLabel;
    lbUV: TcxLabel;
    lbTempC: TcxLabel;
    cxLabel5: TcxLabel;
    procedure btnBuscaComRestJsonClick(Sender: TObject);
    procedure btnExibirJsonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnBuscaComGrijjyClick(Sender: TObject);
  private
    FController: IWeatherController;
    function GetCidadeParaBusca: string;
    procedure SetStatus(const AMsg: string);
    procedure ExibirDadosClima(const AWeatherData: TWeatherModel);
    procedure ExibirIconeClima(AImagem: TGraphic);
    procedure LimparExibicaoClima;
    procedure HabilitarBotaoExibirJson(AEnabled: Boolean);
    procedure MostrarMensagemErro(const AMsg: string);
    procedure MostrarMensagemInfo(const AMsg: string);
    procedure FocarNoCampoCidade;
  public
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

procedure TFormPrincipal.btnBuscaComRestJsonClick(Sender: TObject);
begin
  if Assigned(FController) then
    FController.IniciarBuscaClima(ptRestJson);
end;

procedure TFormPrincipal.btnBuscaComGrijjyClick(Sender: TObject);
begin
  if Assigned(FController) then
    FController.IniciarBuscaClima(ptGrijjyJson);
end;

procedure TFormPrincipal.btnExibirJsonClick(Sender: TObject);
begin
  if Assigned(FController) then
    FController.ExibirJsonAtual;
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
  FController := TWeatherController.Create;
  FController.SetView(Self);
  FController.InicializarParsers;
  LimparExibicaoClima;
  SetStatus('Pronto.');
  HabilitarBotaoExibirJson(False);
end;

procedure TFormPrincipal.FormDestroy(Sender: TObject);
begin
  if Assigned(FController) then
  begin
    FController.Finalizar;
  end;
  FController := nil;
  inherited;
end;

function TFormPrincipal.GetCidadeParaBusca: string;
begin
  Result := Trim(edCidade.Text);
end;

procedure TFormPrincipal.SetStatus(const AMsg: string);
begin
  lbStatus.Caption := AMsg;
end;

procedure TFormPrincipal.ExibirDadosClima(const AWeatherData: TWeatherModel);
begin
  if not Assigned(AWeatherData) then
  begin
    LimparExibicaoClima;
    SetStatus('Dados climáticos não disponíveis.');
    Exit;
  end;

  if Assigned(AWeatherData.Location) then
  begin
    lbDataHoraDados.Caption := AWeatherData.Location.LocalTime;
    lbPais.Caption          := AWeatherData.Location.Country;
    lbCidade.Caption        := AWeatherData.Location.Name;
  end
  else
  begin
    lbDataHoraDados.Caption := '';
    lbPais.Caption          := '';
  end;

  if Assigned(AWeatherData.Current) then
  begin
    lbTempC.Caption := AWeatherData.Current.TempC.ToString;
    lbVento.Caption := TUtil.GetDirecaoVentoText(AWeatherData.Current.WindDir);
    lbUV.Caption    := AWeatherData.Current.UV.ToString;

    if Assigned(AWeatherData.Current.Condition) then
    begin
      lbDescricaoClima.Caption := AWeatherData.Current.Condition.Text;
    end
    else
    begin
      lbDescricaoClima.Caption := '';
    end;
  end
  else
  begin
    lbTempC.Caption          := '';
    lbDescricaoClima.Caption := '';
    lbVento.Caption          := '';
    lbUV.Caption             := '';
  end;
end;

procedure TFormPrincipal.ExibirIconeClima(AImagem: TGraphic);
begin
  if Assigned(AImagem) then
  begin
    ImagemClima.Picture.Assign(AImagem);
  end
  else
  begin
    ImagemClima.Picture := nil;
  end;
end;

procedure TFormPrincipal.LimparExibicaoClima;
begin
  lbDataHoraDados.Caption  := '';
  lbPais.Caption           := '';
  lbTempC.Caption          := '';
  lbDescricaoClima.Caption := '';
  lbVento.Caption          := '';
  lbUV.Caption             := '';
  edCidade.Text            := '';
  ImagemClima.Picture      := nil;

end;

procedure TFormPrincipal.HabilitarBotaoExibirJson(AEnabled: Boolean);
begin
  btnExibirJson.Enabled := AEnabled;
end;

procedure TFormPrincipal.MostrarMensagemErro(const AMsg: string);
begin
  MessageDlg(AMsg, mtError, [mbOK], 0);
end;

procedure TFormPrincipal.MostrarMensagemInfo(const AMsg: string);
begin
  MessageDlg(AMsg, mtInformation, [mbOK], 0);
end;

procedure TFormPrincipal.FocarNoCampoCidade;
begin
  edCidade.SetFocus;
end;

end.
