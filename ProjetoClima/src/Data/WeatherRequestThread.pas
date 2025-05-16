unit WeatherRequestThread;

interface

uses
  System.Classes, System.SysUtils, JsonParserIntf;

type
  TWeatherRequestThread = class(TThread)
  private
    FURL: string;
    FResponseContent: string;
    FErrorMessage: string;
    FSuccess: Boolean;
    FParserParaEstaThread: IJsonParser;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean; const AURL: string; AParser: IJsonParser);
    property ResponseContent: string read FResponseContent;
    property ErrorMessage: string read FErrorMessage;
    property Success: Boolean read FSuccess;
    property ParserParaEstaThread: IJsonParser read FParserParaEstaThread;
  end;

implementation

uses
  IdHTTP;

constructor TWeatherRequestThread.Create(CreateSuspended: Boolean; const AURL: string; AParser: IJsonParser);
begin
  inherited Create(CreateSuspended);
  Self.FreeOnTerminate := True;

  FURL             := AURL;
  FSuccess         := False;
  FResponseContent := '';
  FErrorMessage    := '';
  FParserParaEstaThread := AParser;
  FreeOnTerminate := True;
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
