unit uDB_grijjy;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  Data.DB,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  DateUtils,
  Grijjy.Bson,
  Generics.Collections;

type
  TBsonDataSetHelper = class helper for TDataSet
  public
    procedure ToFirestore(var B: TgoBsonArray; aFieldMap: TStrings; aExcept: Boolean = False); overload;
    procedure ToFirestore(var B: TgoBsonArray); overload;

    procedure ToBsonDocument(PResult: TgoBsonDocument; const PFieldMap: TStrings = nil; const PFieldIgnoreList: TStrings = nil; const PFieldExportList: TStrings = nil);
    procedure ToBsonArray(PResult: TgoBsonArray; const PFieldMap, PFieldIgnoreList, PFieldExportList: TStrings);

    procedure LoadFromBsonDocument(const PDoc: TgoBsonDocument; const PFieldMap: TStrings = nil; const PFieldIgnoreList: TStrings = nil; const PFieldExportList: TStrings = nil; const PFieldValue: TDictionary<string, Variant> = nil);
  end;

  TBsonFieldHelper = class helper for TField
  public
    procedure ToBson(var B: TgoBsonDocument; aBsonFieldName: string = '');
    procedure FromBson(var B: TgoBsonDocument; aBsonFieldName: string = '');
    procedure ToFirestore(var B: TgoBsonDocument; aBsonFieldName: string = '');
    procedure FromFirestore(var B: TgoBsonDocument; aBsonFieldName: string = '');

    procedure FromBsonDocument(const Doc: TgoBsonDocument; AFieldName: string = '');
    function ToBsonValue: TgoBsonValue;

    procedure LoadFromBase64(const PBase64Text: string);
  end;

  TBsonFieldsHelper = class helper for TFields
  public
    procedure ToBson(var B: TgoBsonDocument; aFieldMap: TStrings; aExcept: Boolean = False; aFirestore: Boolean = False); overload;
    procedure ToBson(var B: TgoBsonDocument; aFirestore: Boolean = False); overload;
    procedure FromBson(var B: TgoBsonDocument; aFieldMap: TStrings; aExcept: Boolean = False; aFirestore: Boolean = False); overload;
    procedure FromBson(var B: TgoBsonDocument; aFirestore: Boolean = False); overload;

    procedure ToFirestore(var B: TgoBsonDocument; aFieldMap: TStrings; aExcept: Boolean = False); overload;
    procedure ToFirestore(var B: TgoBsonDocument; PFieldList: TArray<string>; aExcept: Boolean = False); overload;
    procedure ToFirestore(var B: TgoBsonDocument); overload;
    procedure FromFirestore(var B: TgoBsonDocument; aFieldMap: TStrings; aExcept: Boolean = False); overload;
    procedure FromFirestore(var B: TgoBsonDocument); overload;
  end;

function GetBsonDelta(var Old, New: TgoBsonDocument): TgoBsonDocument;
function GetFieldNameFromMap(const AFieldName: string; const FieldMap: TStrings): string;

implementation

uses
  System.TypInfo,
  System.NetEncoding,
  Soap.EncdDecd,
  SqlTimSt,
  ncDebug;

function GetBsonDelta(var Old, New: TgoBsonDocument): TgoBsonDocument;
var
  LElement: TgoBsonElement;
begin
  Result := TgoBsonDocument.Create;

  for LElement in New do
  begin
    if Old.Contains(LElement.Name) then
    begin
      if Old[LElement.Name].ToJson <> LElement.Value.ToJson then
        Result[LElement.Name] := LElement.Value;
    end
    else
      Result[LElement.Name] := LElement.Value;
  end;
end;

function GetFieldNameFromMap(const AFieldName: string; const FieldMap: TStrings): string;
begin
  Result := FieldMap.Values[AFieldName];

  if Result.IsEmpty then
    Result := AFieldName;

  Result := Result.ToLower;
end;

{ TJsonFieldHelper }

procedure TBsonFieldHelper.FromFirestore(var B: TgoBsonDocument; aBsonFieldName: string);
var
  s: string;
begin
  try
    if aBsonFieldName = '' then
      aBsonFieldName := FieldName;

    aBsonFieldName := aBsonFieldName.ToLower;

    if not B.Contains(aBsonFieldName) then
      Exit;

    if B[aBsonFieldName].IsBsonNull then
    begin
      Self.Clear;
      Exit;
    end;

    if B[aBsonFieldName].IsBsonDocument then
      Exit;

    case DataType of
      ftGuid:
        begin
          s := B[aBsonFieldName].AsString;
          if Copy(s, 1, 1) <> '{' then
            s := '{' + s;
          if Copy(s, Length(s), 1) <> '}' then
            s := s + '}';
        end;
    else
      FromBson(B, aBsonFieldName);
    end;
  except
    on E: Exception do
    begin
      DebugMsg(Self, 'FromFirestore - JsonFieldName: ' + aBsonFieldName);
      DebugMsg(Self, 'FromFirestore - FieldDataType: ' + GetEnumName(TypeInfo(TFieldType), Ord(DataType)));
      DebugEx(Self, 'FromFirestore', E);

      raise;
    end;
  end;
end;

procedure TBsonFieldHelper.ToBson(var B: TgoBsonDocument; aBsonFieldName: string = '');
begin
  try
    if aBsonFieldName = '' then
      aBsonFieldName := FieldName;

    if IsNull then
    begin
      B[aBsonFieldName] := TgoBsonNull.Value;
      Exit;
    end;

    case DataType of
      ftInteger, ftAutoInc, ftSmallint, ftWord, ftShortint, ftByte:
        B[aBsonFieldName] := AsInteger;

      ftLargeint, ftLongWord:
        B[aBsonFieldName] := AsLargeInt;

      TFieldType.ftSingle, ftFloat, ftCurrency:
        B[aBsonFieldName] := AsFloat;

      ftString, ftGuid, ftWideString, ftMemo, ftWideMemo:
        B[aBsonFieldName] := AsWideString;

      ftBoolean:
        B[aBsonFieldName] := AsBoolean;

      ftDate:
        B[aBsonFieldName] := DateToISO8601(AsDateTime);

      ftDateTime, ftTimeStamp:
      begin
        if Frac(AsDateTime) <> 0 then
          B[aBsonFieldName] := DateToISO8601(AsDateTime, False)
        else
          B[aBsonFieldName] := DateToISO8601(AsDateTime);
      end;

      ftGraphic, ftBlob, ftStream:
        B[aBsonFieldName] := TBlobFIeld(Self).AsBytes;
    end;
  except
    on E: Exception do
    begin
      DebugMsg(Self, 'ToBson - JsonFieldName: ' + aBsonFieldName);
      DebugMsg(Self, 'ToBson - FieldDataType: ' + GetEnumName(TypeInfo(TFieldType), Ord(DataType)));
      DebugEx(Self, 'ToBson', E);

      raise;
    end;
  end;
end;

function TBsonFieldHelper.ToBsonValue: TgoBsonValue;
begin
  if IsNull then
  begin
    Result := TgoBsonNull.Value;
    Exit;
  end;

  case DataType of
    ftInteger, ftAutoInc, ftSmallint, ftWord, ftShortint, ftByte:
      Result := AsInteger;

    ftLargeint, ftLongWord:
      Result := AsLargeInt;

    TFieldType.ftSingle, ftFloat, ftCurrency:
      Result := AsFloat;

    ftGuid:
      Result := AsString.Replace('{', '').Replace('}', '');

    ftString, ftWideString, ftMemo, ftWideMemo:
      Result := AsWideString;

    ftBoolean:
      Result := AsBoolean;

    ftDate:
      Result := DateToISO8601(AsDateTime);

    ftDateTime, ftTimeStamp:
    begin
      if Frac(AsDateTime) <> 0 then
        Result := DateToISO8601(AsDateTime, False)
      else
        Result := DateToISO8601(AsDateTime);
    end;

    ftGraphic, ftBlob, ftStream:
      Result := TBlobFIeld(Self).AsBytes;
  end;
end;

procedure TBsonFieldHelper.ToFirestore(var B: TgoBsonDocument; aBsonFieldName: string);
var
  p: Integer;
  s: string;
begin
  try
    if aBsonFieldName = '' then
      aBsonFieldName := FieldName;

    aBsonFieldName := aBsonFieldName.ToLower;

    if IsNull then
    begin
      B[aBsonFieldName] := TgoBsonNull.Value;
      Exit;
    end;

    case DataType of
      TFieldType.ftGuid:
        begin
          s := AsWideString;
          p := pos('{', s);
          if p > 0 then
            delete(s, p, 1);
          p := pos('}', s);
          if p > 0 then
            delete(s, p, 1);
          B[aBsonFieldName] := s;
        end;
    else
      ToBson(B, aBsonFieldName);
    end;
  except
    on E: Exception do
    begin
      DebugMsg(Self, 'ToFirestore - JsonFieldName: ' + aBsonFieldName);
      DebugMsg(Self, 'ToFirestore - FieldDataType: ' + GetEnumName(TypeInfo(TFieldType), Ord(DataType)));
      DebugEx(Self, 'ToFirestore', E);

      raise;
    end;
  end;
end;

procedure TBsonFieldHelper.FromBsonDocument(const Doc: TgoBsonDocument; AFieldName: string = '');
var
  LValue: Variant;
  LName : string;
begin
  LName := FieldName;

  if not AFieldName.IsEmpty then
    LName := AFieldName;

  if not Doc.Contains(LName) then
    if Doc.Contains(LName.ToLower) then
      LName := LName.ToLower
    else
      Exit;

  if Doc[LName].IsBsonNull then
  begin
    Self.Clear;
    Exit;
  end;

  if Doc[LName].IsBsonDocument then
    Exit;

  case DataType of
    ftInteger, ftAutoInc, ftSmallint, ftWord, ftShortint, ftByte:
      AsInteger := Doc[LName].ToInteger;

    ftLargeint, ftLongWord:
      AsLargeInt := Doc[LName].ToInt64;

    TFieldType.ftSingle, ftFloat, ftCurrency:
      AsFloat := Doc[LName].ToDouble;

    ftString, ftWideString, ftMemo, ftWideMemo:
      AsWideString := Doc[LName].AsString;

    ftGuid:
      begin
        if (not Doc[LName].IsBsonNull) and (Doc[LName].AsString > '') then
        begin
          LValue := Doc[LName].AsString;

          if Copy(LValue, 1, 1) <> '{' then
            LValue := '{' + LValue;

          if Copy(LValue, Length(LValue), 1) <> '}' then
            LValue := LValue + '}';

          AsWideString := LValue;
        end;
      end;

    ftBoolean:
      AsBoolean := Doc[LName].AsBoolean;

    ftDate:
      AsDateTime := ISO8601ToDate(Doc[LName].AsString);

    ftDateTime, ftTimeStamp:
    begin
      AsDateTime := ISO8601ToDate(Doc[LName].AsString, False);

      if Doc[LName].AsString.Length = 10 then // 'yyyy-mm-dd'
         AsDateTime := ISO8601ToDate(Doc[LName].AsString);
    end;

    ftGraphic, ftBlob, ftStream:
      LoadFromBase64(Doc[LName]);
  end;
end;

procedure TBsonFieldHelper.FromBson(var B: TgoBsonDocument; aBsonFieldName: string = '');
begin
  try
    if aBsonFieldName = '' then
      aBsonFieldName := FieldName;

    if not B.Contains(aBsonFieldName) then
      Exit;

    if B[aBsonFieldName].IsBsonNull then
    begin
      Self.Clear;
      Exit;
    end;

    if B[aBsonFieldName].IsBsonDocument then
      Exit;

    case DataType of
      ftInteger, ftAutoInc, ftSmallint, ftWord, ftShortint, ftByte:
        AsInteger := B[aBsonFieldName].ToInteger;

      ftLargeint, ftLongWord:
        AsLargeInt := B[aBsonFieldName].ToInt64;

      TFieldType.ftSingle, ftFloat, ftCurrency:
        AsFloat := B[aBsonFieldName].ToDouble;

      ftString, ftGuid, ftWideString, ftMemo, ftWideMemo:
        AsWideString := B[aBsonFieldName].AsString;

      ftBoolean:
        AsBoolean := B[aBsonFieldName].AsBoolean;

      ftDate:
        AsDateTime := ISO8601ToDate(B[aBsonFieldName].AsString);

      ftDateTime, ftTimeStamp:
      begin
        AsDateTime := ISO8601ToDate(B[aBsonFieldName].AsString, False);

        if B[aBsonFieldName].AsString.Length = 10 then // 'yyyy-mm-dd'
          AsDateTime := ISO8601ToDate(B[aBsonFieldName].AsString);
      end;

      ftGraphic, ftBlob, ftStream:
        LoadFromBase64(B[aBsonFieldName]);
    end;
  except
    on E: Exception do
    begin
      DebugMsg(Self, 'FromBson - JsonFieldName: ' + aBsonFieldName);
      DebugMsg(Self, 'FromBson - FieldDataType: ' + GetEnumName(TypeInfo(TFieldType), Ord(DataType)));
      DebugEx(Self, 'FromBson', E);

      raise;
    end;
  end;
end;

{ TJsonFieldsHelper }

procedure TBsonFieldsHelper.ToBson(var B: TgoBsonDocument; aFieldMap: TStrings; aExcept: Boolean = False; aFirestore: Boolean = False);
var
  I: Integer;
  F: TField;
begin
  if aExcept then
  begin
    for I := 0 to Count - 1 do
    begin
      if aFieldMap.IndexOf(Fields[I].FieldName) = -1 then
        if aFirestore then
          Fields[I].ToFirestore(B, Fields[I].FieldName)
        else
          Fields[I].ToBson(B, Fields[I].FieldName);
    end;
  end
  else
    for I := 0 to aFieldMap.Count - 1 do
    begin
      F := FindField(aFieldMap.Names[I]);
      if F <> nil then
        if aFirestore then
          F.ToFirestore(B, aFieldMap.ValueFromIndex[I])
        else
          F.ToBson(B, aFieldMap.ValueFromIndex[I]);
    end;
end;

procedure TBsonFieldsHelper.FromBson(var B: TgoBsonDocument; aFieldMap: TStrings; aExcept: Boolean = False; aFirestore: Boolean = False);
var
  I: Integer;
  F: TField;
begin
  if aExcept then
  begin
    for I := 0 to Count - 1 do
    begin
      if aFieldMap.IndexOf(Fields[I].FieldName) = -1 then
        if aFirestore then
          Fields[I].FromFirestore(B, Fields[I].FieldName)
        else
          Fields[I].FromBson(B, Fields[I].FieldName);
    end;
  end
  else
    for I := 0 to aFieldMap.Count - 1 do
    begin
      F := FindField(aFieldMap.Names[I]);
      if F <> nil then
        if aFirestore then
          F.FromFirestore(B, aFieldMap.ValueFromIndex[I])
        else
          F.FromBson(B, aFieldMap.ValueFromIndex[I]);
    end;
end;

procedure TBsonFieldsHelper.FromBson(var B: TgoBsonDocument; aFirestore: Boolean = False);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    with Fields[I] do
      if aFirestore then
        FromFirestore(B, FieldName)
      else
        FromBson(B, FieldName);
end;

procedure TBsonFieldsHelper.FromFirestore(var B: TgoBsonDocument);
begin
  FromBson(B, True);
end;

procedure TBsonFieldHelper.LoadFromBase64(const PBase64Text: string);
var
  LStreamInput : TStringStream;
  LStreamOutput: TMemoryStream;
begin
  if not(Self is TBlobFIeld) then
    Exit;

  LStreamInput  := TStringStream.Create(PBase64Text);
  LStreamOutput := TMemoryStream.Create;
  try
    DecodeStream(LStreamInput, LStreamOutput);
    LStreamOutput.Position := 0;

    TBlobFIeld(Self).LoadFromStream(LStreamOutput);
  finally
    LStreamInput.Free;
    LStreamOutput.Free;
  end;
end;

procedure TBsonFieldsHelper.FromFirestore(var B: TgoBsonDocument; aFieldMap: TStrings; aExcept: Boolean);
begin
  FromBson(B, aFieldMap, aExcept, True);
end;

procedure TBsonFieldsHelper.ToBson(var B: TgoBsonDocument; aFirestore: Boolean = False);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    with Fields[I] do
      if aFirestore then
        ToFirestore(B, FieldName)
      else
        ToBson(B, FieldName);
end;

procedure TBsonFieldsHelper.ToFirestore(var B: TgoBsonDocument; PFieldList: TArray<string>; aExcept: Boolean);
var
  LList: TStringList;
begin
  LList := TStringList.Create;
  try
    LList.AddStrings(PFieldList);
    ToBson(B, LList, aExcept, True);
  finally
    LList.Free;
  end;
end;

procedure TBsonFieldsHelper.ToFirestore(var B: TgoBsonDocument);
begin
  ToBson(B, True);
end;

procedure TBsonFieldsHelper.ToFirestore(var B: TgoBsonDocument; aFieldMap: TStrings; aExcept: Boolean);
begin
  ToBson(B, aFieldMap, aExcept, True);
end;

{ TBsonDataSetHelper }

procedure TBsonDataSetHelper.LoadFromBsonDocument(const PDoc: TgoBsonDocument; const PFieldMap: TStrings = nil; const PFieldIgnoreList: TStrings = nil; const PFieldExportList: TStrings = nil; const PFieldValue: TDictionary<string, Variant> = nil);
var
  LField    : TField;
  LFieldName: string;
  LException: Boolean;
begin
  LException := False;

  for LField in Fields do
  begin
    try
      LFieldName := LField.FieldName;

      if Assigned(PFieldIgnoreList) then
        if (PFieldIgnoreList.Count > 0) then
          if (PFieldIgnoreList.IndexOf(LFieldName) > -1) then
            Continue;

      if Assigned(PFieldExportList) then
        if (PFieldExportList.Count > 0) then
          if (PFieldExportList.IndexOf(LFieldName) = -1) then
            Continue;

      if Assigned(PFieldValue) then
        if PFieldValue.ContainsKey(LFieldName) then
        begin
          LField.Value := PFieldValue[LFieldName];
          Continue;
        end;

      if Assigned(PFieldMap) then
        LFieldName := GetFieldNameFromMap(LFieldName, PFieldMap);

      LField.FromBsonDocument(PDoc, LFieldName);
    except
      on E: Exception do
      begin
        LException := True;

        DebugMsg(Self, 'LoadFromBsonDocument - FieldName: ' + LField.FieldName);
        DebugMsg(Self, 'LoadFromBsonDocument - DataType: ' + GetEnumName(TypeInfo(TFieldType), Ord(LField.DataType)));
        DebugEx(Self, 'LoadFromBsonDocument', E);
      end;
    end;
  end;

  if LException then
    DebugMsg(Self, 'ToBsonDocument - Exception - Um ou mais erros no registro ' + FieldByName('UID').AsString);
end;

procedure TBsonDataSetHelper.ToBsonDocument(PResult: TgoBsonDocument; const PFieldMap: TStrings = nil; const PFieldIgnoreList: TStrings = nil; const PFieldExportList: TStrings = nil);
var
  LField    : TField;
  LFieldName: string;
  LException: Boolean;
begin
  if PResult.IsNil then
    Exit;

  LException := False;

  for LField in Fields do
  begin
    try
      LFieldName := LField.FieldName;

      if Assigned(PFieldIgnoreList) then
        if (PFieldIgnoreList.Count > 0) then
          if (PFieldIgnoreList.IndexOf(LFieldName) > -1) then
            Continue;

      if Assigned(PFieldExportList) then
        if (PFieldExportList.Count > 0) then
          if (PFieldExportList.IndexOf(LFieldName) = -1) then
            Continue;

      if Assigned(PFieldMap) then
        LFieldName := GetFieldNameFromMap(LFieldName, PFieldMap)
      else
        LFieldName := LFieldName.ToLower;

      PResult[LFieldName] := LField.ToBsonValue;
    except
      on E: Exception do
      begin
        LException := True;

        DebugMsg(Self, 'ToBsonDocument - FieldName: ' + LFieldName);
        DebugMsg(Self, 'ToBsonDocument - DataType: ' + GetEnumName(TypeInfo(TFieldType), Ord(LField.DataType)));
        DebugEx(Self, 'ToBsonDocument', E);
      end;
    end;
  end;

  if LException then
    DebugMsg(Self, 'ToBsonDocument - Exception - Um ou mais erros no registro ' + FieldByName('UID').AsString);
end;

procedure TBsonDataSetHelper.ToBsonArray(PResult: TgoBsonArray; const PFieldMap, PFieldIgnoreList, PFieldExportList: TStrings);
var
  LDocument: TgoBsonDocument;
begin
  if PResult.IsNil then
    Exit;

  while not Eof do
  begin
    try
      LDocument := TgoBsonDocument.Create;

      ToBsonDocument(LDocument, PFieldMap, PFieldIgnoreList, PFieldExportList);

      if not LDocument.IsNil then
        PResult.Add(LDocument);
    except
      on E: Exception do
        DebugEx(Self, 'ToBsonArray', E);
    end;

    Next;
  end;
end;

procedure TBsonDataSetHelper.ToFirestore(var B: TgoBsonArray);
begin
  ToFirestore(B, nil);
end;

procedure TBsonDataSetHelper.ToFirestore(var B: TgoBsonArray; aFieldMap: TStrings; aExcept: Boolean);
var
  LItem: TgoBsonDocument;
begin
  if not Active then
    Exit;

  while not Eof do
  begin
    LItem := TgoBsonDocument.Create;

    if Assigned(aFieldMap) then
      Fields.ToFirestore(LItem, aFieldMap, aExcept)
    else
      Fields.ToFirestore(LItem);

    B.Add(LItem);

    Next;
  end;
end;

end.
