unit uControllerPrincipal;

interface

uses
  System.SysUtils, System.Classes, System.Threading, System.NetEncoding,
  IdHTTP, Vcl.Graphics, Vcl.Imaging.pngimage,
  WeatherControllerIntf, WeatherViewIntf, JsonParserIntf,
  RestJson.JsonParser, Grijjy.JsonParser,
  WeatherModel, WeatherRequestThread, uFrmJsonEditor, System.IniFiles, System.IOUtils;

type
  TWeatherController = class(TInterfacedObject, IWeatherController)
  private
    FView: IWeatherView;
    FRestJsonParser: IJsonParser;
    FGrijjyJsonParser: IJsonParser;
    FCurrentWeatherData: TWeatherModel;
    FLastUsedParser: IJsonParser;
    FConfigApiKey: string;
    FConfigBaseURL: string;
    FConfigLang: string;
    FConfigAqi: string;

    procedure LoadConfig;
    procedure HandleThreadTerminate(Sender: TObject);
    procedure DownloadAndDisplayImage(const ImageURL: string);
  public
    constructor Create;
    destructor Destroy; override;

    procedure SetView(AView: IWeatherView);
    procedure InicializarParsers;
    procedure IniciarBuscaClima(AParserType: TParserType);
    procedure ExibirJsonAtual;
    procedure Finalizar;
  end;

implementation

{ TWeatherController }

constructor TWeatherController.Create;
begin
  inherited Create;
  FCurrentWeatherData := nil;
  FLastUsedParser := nil;
  LoadConfig;
end;

destructor TWeatherController.Destroy;
begin
  Finalizar;
  inherited Destroy;
end;

procedure TWeatherController.SetView(AView: IWeatherView);
begin
  FView := AView;
end;

procedure TWeatherController.InicializarParsers;
begin
  FRestJsonParser   := TRestJsonParser.Create;
  FGrijjyJsonParser := TGrijjyJsonParser.Create;
end;

procedure TWeatherController.Finalizar;
begin
  FreeAndNil(FCurrentWeatherData);
  FRestJsonParser   := nil;
  FGrijjyJsonParser := nil;
  FLastUsedParser   := nil;
end;

procedure TWeatherController.IniciarBuscaClima(AParserType: TParserType);
var
  LCidade, LURL: string;
  LThread: TWeatherRequestThread;
  LParserParaUsar: IJsonParser;
begin
  if not Assigned(FView) then
  begin
    Exit;
  end;

  LCidade := FView.GetCidadeParaBusca;
  if Trim(LCidade) = '' then
  begin
    FView.MostrarMensagemInfo('Por favor, informe o nome da cidade.');
    FView.FocarNoCampoCidade;
    Exit;
  end;

  case AParserType of
    ptRestJson: LParserParaUsar := FRestJsonParser;
    ptGrijjyJson: LParserParaUsar := FGrijjyJsonParser;
  else
    FView.MostrarMensagemErro('Tipo de parser desconhecido selecionado.');
    Exit;
  end;

  if not Assigned(LParserParaUsar) then
  begin
    FView.MostrarMensagemErro('Erro interno: Parser não inicializado.');
    Exit;
  end;

  LCidade := TNetEncoding.URL.Encode(Trim(LCidade));

  LURL := Format('%s?key=%s&q=%s&aqi=%s&lang=%s', [FConfigBaseURL, FConfigApiKey, LCidade, FConfigAqi, FConfigLang]);

  FView.SetStatus('Buscando dados (' + LParserParaUsar.GetParserName + ') para ' + FView.GetCidadeParaBusca + '...');
  FView.LimparExibicaoClima;
  FView.HabilitarBotaoExibirJson(False);

  try
    LThread := TWeatherRequestThread.Create(True, LURL, LParserParaUsar);
    LThread.OnTerminate := HandleThreadTerminate;
    LThread.Start;
  except
    on E: Exception do
    begin
      FView.MostrarMensagemErro('Erro ao iniciar a busca: ' + E.Message);
      FView.SetStatus('Falha ao iniciar busca.');
    end;
  end;
end;

procedure TWeatherController.LoadConfig;
var
  LIniFile: TIniFile;
  LIniFileName: string;
begin
  LIniFileName := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), 'config.ini');

  LIniFile := TIniFile.Create(LIniFileName);
  try
    FConfigApiKey    := LIniFile.ReadString('API', 'Key', '');
    FConfigBaseURL   := LIniFile.ReadString('API', 'BaseURL', 'http://api.weatherapi.com/v1/current.json');
    FConfigLang      := LIniFile.ReadString('API', 'Lang', 'pt');
    FConfigAqi       := LIniFile.ReadString('API', 'AQI', 'yes');
  finally
    LIniFile.Free;
  end;
end;

procedure TWeatherController.HandleThreadTerminate(Sender: TObject);
var
  LThread: TWeatherRequestThread;
  LSuccess: Boolean;
  LContent: string;
  LErrorMsg: string;
  LParsedData: TWeatherModel;
  LParserError: string;
  LParserDaThread: IJsonParser;
begin
  if not Assigned(FView) then
    Exit;

  if not (Sender is TWeatherRequestThread) then
    Exit;

  LThread         := Sender as TWeatherRequestThread;
  LSuccess        := LThread.Success;
  LContent        := LThread.ResponseContent;
  LErrorMsg       := LThread.ErrorMessage;
  LParserDaThread := LThread.ParserParaEstaThread;

  if not Assigned(LParserDaThread) then
  begin
    FView.MostrarMensagemErro('Erro interno: Parser não encontrado na thread de resposta.');
    FView.SetStatus('Falha crítica no processamento.');
    Exit;
  end;

  if LSuccess then
  begin
    FView.SetStatus('Resposta recebida. Analisando JSON com ' + LParserDaThread.GetParserName + '...');
    LParsedData := nil;
    try
      LParsedData  := LParserDaThread.ParseWeatherData(LContent);
      LParserError := LParserDaThread.GetLastError;

      if Assigned(LParsedData) and (LParserError = '') then
      begin
        FreeAndNil(FCurrentWeatherData);
        FCurrentWeatherData := LParsedData;
        FLastUsedParser := LParserDaThread;

        FView.ExibirDadosClima(FCurrentWeatherData);
        FView.SetStatus('Dados carregados com sucesso (' + LParserDaThread.GetParserName + ').');
        FView.HabilitarBotaoExibirJson(True);

        if Assigned(FCurrentWeatherData.Current) and
           Assigned(FCurrentWeatherData.Current.Condition) and
           (FCurrentWeatherData.Current.Condition.Icon <> '') then
        begin
          DownloadAndDisplayImage(FCurrentWeatherData.Current.Condition.Icon);
        end;
      end
      else
      begin
        if Assigned(LParsedData) then FreeAndNil(LParsedData);
        FView.MostrarMensagemErro('Erro ao analisar os dados (' + LParserDaThread.GetParserName + '): ' + LParserError);
        FView.SetStatus('Falha ao processar resposta.');
        FreeAndNil(FCurrentWeatherData);
        FLastUsedParser := nil;
      end;
    except
      on E: Exception do
      begin
        if Assigned(LParsedData) then FreeAndNil(LParsedData);
        FView.MostrarMensagemErro('Erro crítico durante análise do JSON (' + LParserDaThread.GetParserName + '): ' + E.Message);
        FView.SetStatus('Falha crítica ao processar resposta.');
        FreeAndNil(FCurrentWeatherData);
        FLastUsedParser := nil;
      end;
    end;
  end
  else
  begin
    FView.MostrarMensagemErro('Erro ao buscar dados da API: ' + LErrorMsg);
    FView.SetStatus('Falha ao buscar dados.');
    FreeAndNil(FCurrentWeatherData);
    FLastUsedParser := nil;
  end;
end;

procedure TWeatherController.DownloadAndDisplayImage(const ImageURL: string);
var
  LFinalURL: string;
begin
  if not Assigned(FView) then Exit;

  FView.SetStatus('Baixando imagem...');
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
    LPNGImage: TPngImage;
  begin
    LHttp := TIdHTTP.Create(nil);
    LStream := TMemoryStream.Create;
    LErrorMsg := '';
    LPNGImage := nil;
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

    if LErrorMsg = '' then
    begin
      LStream.Position := 0;
      if LStream.Size > 0 then
      begin
        LPNGImage := TPngImage.Create;
        try
          LPNGImage.LoadFromStream(LStream);
        except
          on E: Exception do
          begin
            LErrorMsg := 'Erro ao carregar imagem do stream: ' + E.Message;
            FreeAndNil(LPNGImage);
          end;
        end;
      end
      else
      begin
         LErrorMsg := 'Download da imagem retornou vazio.';
      end;
    end;

    TThread.Queue(nil, procedure
    begin
      if not Assigned(FView) then
      begin
         if Assigned(LPNGImage) then FreeAndNil(LPNGImage);
         LStream.Free;
         Exit;
      end;

      try
        if Assigned(LPNGImage) then
        begin
          FView.ExibirIconeClima(LPNGImage);
          FView.SetStatus('Imagem carregada.');
        end
        else
        begin
          FView.ExibirIconeClima(nil);
          FView.SetStatus(LErrorMsg);
        end;
      finally
        FreeAndNil(LPNGImage);
        LStream.Free;
      end;
    end);
  end);
end;

procedure TWeatherController.ExibirJsonAtual;
var
  LJsonString: string;
  LError: string;
  JsonEditorForm: TFrmJsonEditor;
begin
  if not Assigned(FView) then Exit;

  if not Assigned(FCurrentWeatherData) then
  begin
    FView.MostrarMensagemInfo('Não há dados carregados para exibir como JSON.');
    Exit;
  end;

  if not Assigned(FLastUsedParser) then
  begin
    FView.MostrarMensagemErro('Não foi possível determinar o parser para serializar os dados.');
    Exit;
  end;

  try
    LJsonString := FLastUsedParser.SerializeWeatherData(FCurrentWeatherData);
    LError      := FLastUsedParser.GetLastError;

    if LError <> '' then
      raise Exception.Create('Erro ao gerar JSON: ' + LError);

    JsonEditorForm := TFrmJsonEditor.Create(nil);
    try
      JsonEditorForm.CarregarEExibirJson(LJsonString);
      JsonEditorForm.Show;
    except
      JsonEditorForm.Free;
      raise;
    end;
  except
    on E: Exception do
      FView.MostrarMensagemErro('Erro ao preparar/exibir JSON: ' + E.Message);
  end;
end;


end.
