program ProjetoClima;

uses
  Vcl.Forms,
  FrmPrincipal in 'src\Forms\FrmPrincipal.pas' {Form1},
  HTTPClient in 'src\Data\HTTPClient.pas',
  OpenWeatherAPI in 'src\Data\OpenWeatherAPI.pas',
  URLBuilderOpenWeather in 'src\Data\URLBuilderOpenWeather.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
