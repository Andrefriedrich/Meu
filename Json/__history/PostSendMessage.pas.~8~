unit PostSendMessage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, REST.Client, REST.JSON, REST.Types, Data.Bind.Components,
  Data.Bind.ObjectScope, System.JSON, Unit2, Grijjy.Bson, cxGraphics,
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
    btnPostMessage: TButton;
    btnSendMessage: TButton;
    Button1: TButton;
    Button2: TButton;
    lbTitulo: TcxLabel;
    lbTexto1: TcxLabel;
    lbTexto2: TcxLabel;
    lbTexto3: TcxLabel;
    procedure btnPostMessageClick(Sender: TObject);
    procedure btnSendMessageClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private
    procedure ConsomeJSONComBson;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Form2: TForm2;  // Declaração de Form2 para garantir que está acessível


implementation

{$R *.dfm}

const
  WM_USER_MESSAGE = WM_USER + 1;

procedure TForm1.btnPostMessageClick(Sender: TObject);
begin
  // Enviar mensagem para Form2 usando PostMessage
  PostMessage(Form2.Handle, WM_USER_MESSAGE, 0,
    LPARAM(PChar('PostMessage: Envia a mensagem de forma assíncrona, ou seja, a função retorna imediatamente, sem esperar que a mensagem seja processada.')));
end;

procedure TForm1.btnSendMessageClick(Sender: TObject);
begin
  // Enviar mensagem para Form2 usando SendMessage
  SendMessage(Form2.Handle, WM_USER_MESSAGE, 0,
    LPARAM(PChar('SendMessage: Envia a mensagem de forma síncrona, ou seja, o código aguarda até que a mensagem seja processada antes de continuar.')));
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if not Assigned(Form2) then
    Form2 := TForm2.Create(nil);
  Form2.Show;
end;

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

