program ProjetoClima;

uses
  Vcl.Forms,
  uFrmPrincipal in 'Forms\uFrmPrincipal.pas' {Form1},
  WeatherRequestThread in 'src\Data\WeatherRequestThread.pas',
  WeatherModel in 'Models\WeatherModel.pas',
  Util in 'bin\Util.pas',
  uFrmJsonEditor in 'Forms\uFrmJsonEditor.pas' {FrmJsonEditor},
  HttpServiceIntf in 'Models\HttpServiceIntf.pas',
  RestJson.JsonParser in 'JSON\RestJson.JsonParser.pas' {$R *.res},
  Grijjy.JsonParser in 'JSON\Grijjy.JsonParser.pas',
  JsonParserIntf in 'JSON\JsonParserIntf.pas',
  WeatherViewIntf in 'Interfaces\WeatherViewIntf.pas',
  WeatherControllerIntf in 'Interfaces\WeatherControllerIntf.pas',
  uControllerPrincipal in 'Controllers\uControllerPrincipal.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.CreateForm(TFrmJsonEditor, FrmJsonEditor);
  Application.Run;
  ReportMemoryLeaksOnShutdown := True;
end.
