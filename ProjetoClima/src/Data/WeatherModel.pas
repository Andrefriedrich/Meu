unit WeatherModel;

interface

type
  TWeatherModel = class
  private
    FRegion: string;
    FTemp_c: Double;
    FTemp_f: Double;
    FCondition: string;
  public
    property Region: string read FRegion write FRegion;
    property Temp_c: Double read FTemp_c write FTemp_c;
    property Temp_f: Double read FTemp_f write FTemp_f;
    property Condition: string read FCondition write FCondition;
  end;

implementation

end.

