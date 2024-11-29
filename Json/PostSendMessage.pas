unit PostSendMessage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, REST.Client, REST.JSON, REST.Types, Data.Bind.Components,
  Data.Bind.ObjectScope, System.JSON, Grijjy.Bson, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxButtons, cxControls,
  cxContainer, cxEdit, cxLabel;

type
  TModalSucessoSemCupom = class
  public
    textotopo: string;
    textocorpo1: string;
    textocorpo2: string;
    textocorpo3: string;
  end;

  TMeuObjeto = class
  public
    modalsucesso_semcupom: TModalSucessoSemCupom;
  end;

  TForm1 = class(TForm)
    Button2: TButton;
    lbTitulo: TcxLabel;
    lbTexto1: TcxLabel;
    lbTexto2: TcxLabel;
    lbTexto3: TcxLabel;
    procedure Button2Click(Sender: TObject);

  private
    procedure ConsomeJSONComBson;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.Button2Click(Sender: TObject);
begin
 ConsomeJSONComBson;
end;

procedure TForm1.ConsomeJSONComBson;
var
  Client: TRESTClient;
  Request: TRESTRequest;
  Response: TRESTResponse;
  JsonDoc: TJSONObject;
  ModalSucesso: TModalSucessoSemCupom;
  JsonValue: TJSONValue;
begin
  Client := TRESTClient.Create('https://docs.nextar.com.br/trial/textos_trial_pt_v2.json');
  Request := TRESTRequest.Create(nil);
  Response := TRESTResponse.Create(nil);
  try
    Request.Client := Client;
    Request.Response := Response;
    Request.Method := rmGET;
    Request.Execute;

    if Response.StatusCode = 200 then
    begin
      try
        JsonDoc := TJSONObject.ParseJSONValue(Response.Content) as TJSONObject;
        if not Assigned(JsonDoc) then
        begin
          ShowMessage('Erro ao parsear o JSON.');
          Exit;
        end;

        ModalSucesso := TModalSucessoSemCupom.Create;
        try
          if JsonDoc.TryGetValue('modalsucesso_semcupom.textotopo', JsonValue) and (JsonValue is TJSONString) then
            ModalSucesso.textotopo := (JsonValue as TJSONString).Value
          else
            ShowMessage('Chave "textotopo" não encontrada.');

          if JsonDoc.TryGetValue('modalsucesso_semcupom.textocorpo1', JsonValue) and (JsonValue is TJSONString) then
            ModalSucesso.textocorpo1 := (JsonValue as TJSONString).Value
          else
            ShowMessage('Chave "textocorpo1" não encontrada.');

          if JsonDoc.TryGetValue('modalsucesso_semcupom.textocorpo2', JsonValue) and (JsonValue is TJSONString) then
            ModalSucesso.textocorpo2 := (JsonValue as TJSONString).Value
          else
            ShowMessage('Chave "textocorpo2" não encontrada.');

          if JsonDoc.TryGetValue('modalsucesso_semcupom.textocorpo3', JsonValue) and (JsonValue is TJSONString) then
            ModalSucesso.textocorpo3 := (JsonValue as TJSONString).Value
          else
            ShowMessage('Chave "textocorpo3" não encontrada.');

          lbTitulo.Caption := ModalSucesso.textotopo;
          lbTexto1.Caption := ModalSucesso.textocorpo1;
          lbTexto2.Caption := ModalSucesso.textocorpo2;
          lbTexto3.Caption := ModalSucesso.textocorpo3;


        finally
          ModalSucesso.free;
        end;
      except
        on E: Exception do
        begin
          ShowMessage('Erro ao processar o JSON: ' + E.Message);
        end;
      end;
    end
    else
      ShowMessage('Erro ao consumir JSON: ' + Response.StatusText);
  finally
    Response.Free;
    Request.Free;
    Client.Free;
  end;
end;

end.

