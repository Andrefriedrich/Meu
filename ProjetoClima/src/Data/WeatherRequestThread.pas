unit WeatherRequestThread;

interface

uses
  System.Classes, System.SysUtils;

type
  TWeatherRequestThread = class(TThread)
  private
    FCity: string;
    FOnSuccess: TProc<string>;
    FOnError: TProc<string>;
    FResponse: string;
    FErrorMsg: string;
  protected
    procedure Execute; override;
    procedure NotifySuccess;
    procedure NotifyError;
  public
    constructor Create(const City: string; OnSuccess, OnError: TProc<string>);
  end;

implementation

uses
  IdHTTP;

{ TWeatherRequestThread }

constructor TWeatherRequestThread.Create(const City: string; OnSuccess, OnError: TProc<string>);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FCity := City;
  FOnSuccess := OnSuccess;
  FOnError := OnError;
end;

procedure TWeatherRequestThread.Execute;
var
  HTTP: TIdHTTP;
  URL: string;
begin
  HTTP := TIdHTTP.Create(nil);
  try
    try
      URL := Format('http://api.weatherapi.com/v1/current.json?key=b809c9b15772403e8e810413240512&q=%s&aqi=yes&lang=pt', [FCity]);
      FResponse := HTTP.Get(URL);
    except
      on E: Exception do
        FErrorMsg := E.Message;
    end;
  finally
    HTTP.Free;
  end;

  if FErrorMsg = '' then
    Synchronize(NotifySuccess)
  else
    Synchronize(NotifyError);
end;

procedure TWeatherRequestThread.NotifySuccess;
begin
  if Assigned(FOnSuccess) then
    FOnSuccess(FResponse);
end;

procedure TWeatherRequestThread.NotifyError;
begin
  if Assigned(FOnError) then
    FOnError(FErrorMsg);
end;

end.

