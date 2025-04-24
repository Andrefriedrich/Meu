unit JsonParserIntf;

interface

uses WeatherModel;

type
  IJsonParser = interface
    function ParseWeatherData(const AJson: string): TWeatherModel;
    function SerializeWeatherData(const AWeatherData: TWeatherModel): string;
    function GetLastError: string;
  end;

implementation

end.
