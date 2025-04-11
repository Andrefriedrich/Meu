program ProjetoClima;

uses
  Vcl.Forms,
  FrmPrincipal in 'src\Forms\FrmPrincipal.pas' {Form1},
  WeatherRequestThread in 'src\Data\WeatherRequestThread.pas',
  WeatherController in 'src\Data\WeatherController.pas',
  WeatherModel in 'Models\WeatherModel.pas',
  Util in 'bin\Util.pas',
  uFrmJsonEditor in 'Forms\uFrmJsonEditor.pas' {FrmJsonEditor};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.CreateForm(TFrmJsonEditor, FrmJsonEditor);
  Application.Run;
  ReportMemoryLeaksOnShutdown := True;
end.
