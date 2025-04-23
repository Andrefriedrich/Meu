unit WeatherRequestThread;

interface

uses
  System.Classes, System.SysUtils;

type
  TWeatherRequestThread = class(TThread)
  private
    FURL: string;
    FResponseContent: string;
    FErrorMessage: string;
    FSuccess: Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean; const AURL: string);
    property ResponseContent: string read FResponseContent;
    property ErrorMessage: string read FErrorMessage;
    property Success: Boolean read FSuccess;
  end;

implementation

uses
  IdHTTP;

constructor TWeatherRequestThread.Create(CreateSuspended: Boolean; const AURL: string);
begin
  inherited Create(CreateSuspended);
  Self.FreeOnTerminate := True;

  FURL             := AURL;
  FSuccess         := False;
  FResponseContent := '';
  FErrorMessage    := '';
end;

procedure TWeatherRequestThread.Execute;
var
  LHttp: TIdHTTP;
begin
  LHttp := TIdHTTP.Create(nil);
  try
    try
      if Self.Terminated then
        Exit;

      FResponseContent := LHttp.Get(FURL);
      FSuccess         := True;
      FErrorMessage    := '';
    except
      on E: Exception do
      begin
        FSuccess         := False;
        FErrorMessage    := E.Message;
        FResponseContent := '';
      end;
    end;
  finally
    LHttp.Free;
  end;
end;

end.
