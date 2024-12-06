program ProjetoClima;

uses
  Vcl.Forms,
  FrmPrincipal in 'src\Forms\FrmPrincipal.pas' {Form1},
  WeatherRequestThread in 'src\Data\WeatherRequestThread.pas',
  WeatherController in 'src\Data\WeatherController.pas',
  WeatherModel in 'src\Data\WeatherModel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
