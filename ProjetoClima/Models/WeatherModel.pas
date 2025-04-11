unit WeatherModel;

interface

uses
  System.SysUtils, System.Classes;

type
  TCondition = class
  private
    FText: string;
    FIcon: string;
    FCode: Integer;
  public
    property Text: string  read FText write FText;
    property Icon: string  read FIcon write FIcon;
    property Code: Integer read FCode write FCode;
  end;

  TAirQuality = class
  private
    FCO: Double;
    FNO2: Double;
    FO3: Double;
    FSO2: Double;
    FPM2_5: Double;
    FPM10: Double;
    FUSEPAIndex: Integer;
    FGBDefraIndex: Integer;
  public
    property CO: Double  read FCO  write FCO;
    property NO2: Double read FNO2 write FNO2;
    property O3: Double  read FO3  write FO3;
    property SO2: Double read FSO2 write FSO2;
    property PM2_5: Double read FPM2_5 write FPM2_5;
    property PM10: Double  read FPM10  write FPM10;
    property USEPAIndex: Integer   read FUSEPAIndex   write FUSEPAIndex;
    property GBDefraIndex: Integer read FGBDefraIndex write FGBDefraIndex;
  end;

  TCurrent = class
  private
    FLast_Updated_Epoch: Int64;
    FLast_Updated: string;
    FTemp_C: Double;
    FTemp_F: Double;
    FIs_Day: Integer;
    FCondition: TCondition;
    FWind_Mph: Double;
    FWind_Kph: Double;
    FWind_Degree: Integer;
    FWind_Dir: string;
    FPressure_Mb: Double;
    FPressure_In: Double;
    FPrecip_Mm: Double;
    FPrecip_In: Double;
    FHumidity: Integer;
    FCloud: Integer;
    FFeelsLikeC: Double;
    FFeelsLikeF: Double;
    FWindChillC: Double;
    FWindChillF: Double;
    FHeatIndexC: Double;
    FHeatIndexF: Double;
    FDewPointC: Double;
    FDewPointF: Double;
    FVisKm: Double;
    FVisMiles: Double;
    FUV: Double;
    FGustMph: Double;
    FGustKph: Double;
    FAir_Quality: TAirQuality;
  public
    property LastUpdatedEpoch: Int64 read FLast_Updated_Epoch write FLast_Updated_Epoch;
    property LastUpdated: string     read FLast_Updated       write FLast_Updated;
    property TempC: Double           read FTemp_C             write FTemp_C;
    property TempF: Double           read FTemp_F             write FTemp_F;
    property IsDay: Integer          read FIs_Day             write FIs_Day;
    property Condition: TCondition   read FCondition          write FCondition;
    property WindMph: Double         read FWind_Mph           write FWind_Mph;
    property WindKph: Double         read FWind_Kph           write FWind_Kph;
    property WindDegree: Integer     read FWind_Degree        write FWind_Degree;
    property WindDir: string         read FWind_Dir           write FWind_Dir;
    property PressureMb: Double      read FPressure_Mb        write FPressure_Mb;
    property PressureIn: Double      read FPressure_In        write FPressure_In;
    property PrecipMm: Double        read FPrecip_Mm          write FPrecip_Mm;
    property PrecipIn: Double        read FPrecip_In          write FPrecip_In;
    property Humidity: Integer       read FHumidity           write FHumidity;
    property Cloud: Integer          read FCloud              write FCloud;
    property FeelsLikeC: Double      read FFeelsLikeC         write FFeelsLikeC;
    property FeelsLikeF: Double      read FFeelsLikeF         write FFeelsLikeF;
    property WindChillC: Double      read FWindChillC         write FWindChillC;
    property WindChillF: Double      read FWindChillF         write FWindChillF;
    property HeatIndexC: Double      read FHeatIndexC         write FHeatIndexC;
    property HeatIndexF: Double      read FHeatIndexF         write FHeatIndexF;
    property DewPointC: Double       read FDewPointC          write FDewPointC;
    property DewPointF: Double       read FDewPointF          write FDewPointF;
    property VisKm: Double           read FVisKm              write FVisKm;
    property VisMiles: Double        read FVisMiles           write FVisMiles;
    property UV: Double              read FUV                 write FUV;
    property GustMph: Double         read FGustMph            write FGustMph;
    property GustKph: Double         read FGustKph            write FGustKph;
    property AirQuality: TAirQuality read FAir_Quality        write FAir_Quality;

    constructor Create;
    destructor Destroy; override;
  end;

  TLocation = class
  private
    FName: string;
    FRegion: string;
    FCountry: string;
    FLat: Double;
    FLon: Double;
    FTzId: string;
    FLocalTimeEpoch: Int64;
    FLocalTime: string;
  public
    property Name: string          read FName write FName;
    property Region: string        read FRegion write FRegion;
    property Country: string       read FCountry write FCountry;
    property Lat: Double           read FLat write FLat;
    property Lon: Double           read FLon write FLon;
    property TzId: string          read FTzId write FTzId;
    property LocalTimeEpoch: Int64 read FLocalTimeEpoch write FLocalTimeEpoch;
    property LocalTime: string     read FLocalTime write FLocalTime;
  end;

  TWeatherModel = class
  private
    FLocation: TLocation;
    FCurrent: TCurrent;
  public
    property Location: TLocation read FLocation write FLocation;
    property Current: TCurrent read FCurrent write FCurrent;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

constructor TCurrent.Create;
begin
  FCondition  := TCondition.Create;
  FAir_Quality := TAirQuality.Create;
end;

destructor TCurrent.Destroy;
begin
  FCondition.Free;
  FAir_Quality.Free;
  inherited;
end;

constructor TWeatherModel.Create;
begin
  FLocation := TLocation.Create;
  FCurrent  := TCurrent.Create;
end;

destructor TWeatherModel.Destroy;
begin
  FLocation.Free;
  FCurrent.Free;
  inherited;
end;

end.

