unit HttpServiceIntf;

interface

type
  THttpResponse = record
    Success: Boolean;
    StatusCode: Integer;
    Content: string;
    ErrorMessage: string;
  end;

  IHttpService = interface
    function Get(const AURL: string): THttpResponse;
  end;

implementation

end.
