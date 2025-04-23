unit FrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, WeatherRequestThread, WeatherModel, Util,
  Vcl.Imaging.pngimage, uFrmJsonEditor, JsonParserIntf, RestJson.JsonParser, System.NetEncoding;

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
    lbStatus: TcxLabel;
    btnExibirJson: TcxButton;
    procedure btnBuscaComRestJsonClick(Sender: TObject);
    procedure btnExibirJsonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FParser: IJsonParser;
    FCurrentWeatherData: TWeatherModel;
    procedure HandleThreadTerminate(Sender: TObject);
    procedure MostraResultados(const WeatherData: Tweathermodel);
    procedure DownloadAndDisplayImage(const ImageURL: string);
    procedure UpdateStatus(const AMsg: string);
  public
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

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

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
  FParser := TRestJsonParser.Create;
  FCurrentWeatherData := nil;
end;

procedure TFormPrincipal.FormDestroy(Sender: TObject);
begin
  FParser := nil;
  FreeAndNil(FCurrentWeatherData);
  inherited;
end;

procedure TFormPrincipal.HandleThreadTerminate(Sender: TObject);
var
  LThread: TWeatherRequestThread;
  LSuccess: Boolean;
  LContent, LErrorMsg: string;
  LParsedData: TWeatherModel;
  LParserError: string;
begin
  if not (Sender is TWeatherRequestThread) then
    Exit;
  LThread   := Sender as TWeatherRequestThread;
  LSuccess  := LThread.Success;
  LContent  := LThread.ResponseContent;
  LErrorMsg := LThread.ErrorMessage;
  if LSuccess then
  begin
    UpdateStatus('Resposta recebida. Analisando JSON...');
    if not Assigned(FParser) then
    begin
       ShowMessage('Erro interno: Parser não inicializado!');
       UpdateStatus('Falha ao analisar dados.');
       Exit;
    end;
    LParsedData := nil;
    try
      LParsedData  := FParser.ParseWeatherData(LContent);
      LParserError := FParser.GetLastError;
      if Assigned(LParsedData) and (LParserError = '') then
      begin
        FreeAndNil(FCurrentWeatherData);
        FCurrentWeatherData := LParsedData;
        MostraResultados(FCurrentWeatherData);
        UpdateStatus('Dados carregados com sucesso.');
        btnExibirJson.Enabled := True;
      end
      else
      begin
        if Assigned(LParsedData) then FreeAndNil(LParsedData);
        if LParserError = '' then LParserError := 'Parser não retornou dados válidos.';
        ShowMessage('Erro ao analisar os dados recebidos: ' + LParserError);
        UpdateStatus('Falha ao processar resposta.');
      end;
    except
      on E: Exception do
      begin
         if Assigned(LParsedData) then FreeAndNil(LParsedData);
         ShowMessage('Erro durante análise do JSON: ' + E.Message);
         UpdateStatus('Falha ao processar resposta.');
      end;
    end;
  end
  else
  begin
    ShowMessage('Erro ao buscar dados da API: ' + LErrorMsg);
    UpdateStatus('Falha ao buscar dados.');
  end;
end;

procedure TFormPrincipal.btnBuscaComRestJsonClick(Sender: TObject);
var
  LCity, LURL, LApiKey: string;
  LThread: TWeatherRequestThread;
begin
  if Trim(edCidade.Text) = '' then
  begin
    ShowMessage('Por favor, informe o nome da cidade.');
    edCidade.SetFocus;
    Exit;
  end;
  // tirar a key desse form
  LApiKey := 'b809c9b15772403e8e810413240512';
  LCity := TNetEncoding.URL.Encode(Trim(edCidade.Text));
  LURL := Format('http://api.weatherapi.com/v1/current.json?key=%s&q=%s&aqi=yes&lang=pt', [LApiKey, LCity]);
  UpdateStatus('Buscando dados para ' + edCidade.Text + '...');
  try
    LThread := TWeatherRequestThread.Create(True, LURL);
    LThread.OnTerminate := HandleThreadTerminate;
    LThread.Start;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao iniciar a busca: ' + E.Message);
      UpdateStatus('Falha ao iniciar busca.');
    end;
  end;
end;

procedure TFormPrincipal.btnExibirJsonClick(Sender: TObject);
begin
  //chamada para visualizador editor do json
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

procedure TFormPrincipal.UpdateStatus(const AMsg: string);
begin
  lbStatus.Caption := AMsg;
end;

end.

