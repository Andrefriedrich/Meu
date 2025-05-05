unit FrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, WeatherRequestThread, WeatherModel, Util,
  Vcl.Imaging.pngimage, JsonParserIntf, RestJson.JsonParser, System.NetEncoding, Grijjy.JsonParser,
  uFrmJsonEditor, System.Threading, IdHTTP;

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
    procedure btnBuscaComGrijjyClick(Sender: TObject);
  private
    FRestJsonParser    : IJsonParser;
    FGrijjyJsonParser  : IJsonParser;
    FCurrentWeatherData: TWeatherModel;
    FActiveParser      : IJsonParser;
    procedure HandleThreadTerminate(Sender: TObject);
    procedure MostraResultados(const WeatherData: Tweathermodel);
    procedure DownloadAndDisplayImage(const ImageURL: string);
    procedure UpdateStatus(const AMsg: string);
    procedure InitiateSearch(AParserToUse: IJsonParser);
  public
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

procedure TFormPrincipal.DownloadAndDisplayImage(const ImageURL: string);
var
  LFinalURL: string;
begin
  ImagemClima.Picture := nil;
  UpdateStatus('Baixando imagem...');

  LFinalURL := ImageURL;

  if (Pos('https:', LFinalURL) = 0) then
  begin
    if Copy(LFinalURL,1,2) = '//' then
       LFinalURL := Copy(LFinalURL, 3, Length(LFinalURL));
    LFinalURL := 'http://' + LFinalURL;
  end;

  TTask.Run(procedure
    var
      LHttp: TIdHTTP;
      LStream: TMemoryStream;
      LErrorMsg: string;
    begin
      LHttp := TIdHTTP.Create(nil);
      LStream := TMemoryStream.Create;
      LErrorMsg := '';

      try
        try
          LHttp.Get(LFinalURL, LStream);
        except
          on E: Exception do
          begin
            LErrorMsg := E.Message;
          end;
        end;
      finally
        LHttp.Free;
      end;

      TThread.Queue(nil, procedure
        var
          LPNG: TPngImage;
        begin
          try
            if LErrorMsg = '' then
            begin
              LStream.Position := 0;
              if LStream.Size > 0 then
              begin
                LPNG := TPngImage.Create;
                try
                  LPNG.LoadFromStream(LStream);
                  ImagemClima.Picture.Assign(LPNG);
                  UpdateStatus('Imagem carregada.');
                finally
                  LPNG.Free;
                end;
              end
              else
              begin
                 ImagemClima.Picture := nil;
                 UpdateStatus('Download da imagem retornou vazio.');
              end;
            end
            else
            begin
               ImagemClima.Picture := nil;
               UpdateStatus('Erro ao baixar imagem: ' + LErrorMsg);
            end;
          finally
             LStream.Free;
          end;
        end); // Fim Queue
    end); // Fim TTask.Run
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
  FRestJsonParser     := TRestJsonParser.Create;
  FGrijjyJsonParser   := TGrijjyJsonParser.Create;
  FCurrentWeatherData := nil;
  FActiveParser       := nil;
end;

procedure TFormPrincipal.FormDestroy(Sender: TObject);
begin
  FRestJsonParser   := nil;
  FGrijjyJsonParser := nil;
  FreeAndNil(FCurrentWeatherData);
  inherited;
end;

procedure TFormPrincipal.HandleThreadTerminate(Sender: TObject);
var
  LThread      : TWeatherRequestThread;
  LSuccess     : Boolean;
  LContent     : string;
  LErrorMsg    : string;
  LParsedData  : TWeatherModel;
  LParserError : string;
  LParserName  : string;
begin
  if not (Sender is TWeatherRequestThread) then
    Exit;

  LThread   := Sender as TWeatherRequestThread;
  LSuccess  := LThread.Success;
  LContent  := LThread.ResponseContent;
  LErrorMsg := LThread.ErrorMessage;

  if not Assigned(FActiveParser) then
  begin
     ShowMessage('Erro interno: Nenhum parser ativo definido para processar a resposta.');
     UpdateStatus('Nenhum parser ativo.');
     Exit;
  end;

  LParserName := FActiveParser.GetParserName;

  if LSuccess then
  begin
    UpdateStatus('Resposta recebida. Analisando JSON com ' + LParserName + '...');

    LParsedData := nil;
    try
      LParsedData := FActiveParser.ParseWeatherData(LContent);
      LParserError := FActiveParser.GetLastError;

      if Assigned(LParsedData) and (LParserError = '') then
      begin
        FreeAndNil(FCurrentWeatherData);
        FCurrentWeatherData := LParsedData;

        MostraResultados(FCurrentWeatherData);
        UpdateStatus('Dados carregados com sucesso (' + LParserName + ').');
        btnExibirJson.Enabled := True;

        if Assigned(FCurrentWeatherData.Current) and Assigned(FCurrentWeatherData.Current.Condition) and (FCurrentWeatherData.Current.Condition.Icon <> '') then
           DownloadAndDisplayImage(FCurrentWeatherData.Current.Condition.Icon);
      end
      else
      begin
        if Assigned(LParsedData) then FreeAndNil(LParsedData);
        if LParserError = '' then LParserError := LParserName + ' não retornou dados válidos.';
        ShowMessage('Erro ao analisar os dados recebidos (' + LParserName + '): ' + LParserError);
        UpdateStatus('Falha ao processar resposta.');
        FActiveParser := nil;
      end;
    except
      on E: Exception do
      begin
         if Assigned(LParsedData) then FreeAndNil(LParsedData);
         ShowMessage('Erro durante análise do JSON (' + LParserName + '): ' + E.Message);
         UpdateStatus('Falha ao processar resposta.');
         FActiveParser := nil;
      end;
    end;
  end
  else
  begin
    ShowMessage('Erro ao buscar dados da API: ' + LErrorMsg);
    UpdateStatus('Falha ao buscar dados.');
    FActiveParser := nil;
  end;
end;

procedure TFormPrincipal.btnBuscaComRestJsonClick(Sender: TObject);
begin
  InitiateSearch(FRestJsonParser);
end;

procedure TFormPrincipal.btnBuscaComGrijjyClick(Sender: TObject);
begin
  InitiateSearch(FGrijjyJsonParser);
end;

procedure TFormPrincipal.InitiateSearch(AParserToUse: IJsonParser);
var
  LCity, LURL, LApiKey: string;
  LThread: TWeatherRequestThread;
begin
  if not Assigned(AParserToUse) then
  begin
     ShowMessage('Erro interno: Instância do Parser não fornecida.');
     Exit;
  end;

  if Trim(edCidade.Text) = '' then
  begin
    ShowMessage('Por favor, informe o nome da cidade.');
    edCidade.SetFocus;
    Exit;
  end;

  FActiveParser := AParserToUse;

  // tirar a key desse form
  LApiKey := 'b809c9b15772403e8e810413240512';
  LCity := TNetEncoding.URL.Encode(Trim(edCidade.Text));
  LURL := Format('http://api.weatherapi.com/v1/current.json?key=%s&q=%s&aqi=yes&lang=pt', [LApiKey, LCity]);

  UpdateStatus('Buscando dados (' + FActiveParser.GetParserName + ') para ' + edCidade.Text + '...');

  try
    LThread := TWeatherRequestThread.Create(True, LURL);
    LThread.OnTerminate := HandleThreadTerminate;
    LThread.Start;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao iniciar a busca: ' + E.Message);
      UpdateStatus('Falha ao iniciar busca.');
      FActiveParser := nil;
    end;
  end;
end;

procedure TFormPrincipal.btnExibirJsonClick(Sender: TObject);
var
  LJsonString: string;
  LError: string;
  JsonEditorForm: TFrmJsonEditor;
begin
  try
    LJsonString := FActiveParser.SerializeWeatherData(FCurrentWeatherData);
    LError := FActiveParser.GetLastError;
    if LError <> '' then
      raise Exception.Create('Erro ao gerar JSON: ' + LError);

    JsonEditorForm := TFrmJsonEditor.Create(Application);
    try
      JsonEditorForm.CarregarEExibirJson(LJsonString);
      JsonEditorForm.Show;
    except
      JsonEditorForm.Free;
      raise;
    end;

  except
    on E: Exception do
      ShowMessage('Erro ao preparar/exibir JSON: ' + E.Message);
  end;
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

