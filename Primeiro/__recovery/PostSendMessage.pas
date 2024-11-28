unit PostSendMessage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Unit2,
  REST.Client, REST.JSON, REST.Types, Data.Bind.Components, Data.Bind.ObjectScope;

type
  TForm1 = class(TForm)
    btnPostMessage: TButton;
    btnSendMessage: TButton;
    Button1: TButton;
    Button2: TButton;
    procedure btnPostMessageClick(Sender: TObject);
    procedure btnSendMessageClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ConsomeJson;
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

   TMeuObjeto = class
  public
    modalsucesso_semcupom: string;

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

const
  WM_USER_MESSAGE = WM_USER + 1;

procedure TForm1.btnPostMessageClick(Sender: TObject);
begin
  // Enviar mensagem para Form2 usando PostMessage
  PostMessage(Form2.Handle, WM_USER_MESSAGE, 0, LPARAM(PChar('PostMessage: Envia a mensagem de forma assíncrona, ou seja, a função retorna imediatamente, sem esperar que a mensagem seja processada.')));
end;

procedure TForm1.btnSendMessageClick(Sender: TObject);
begin
  // Enviar mensagem para Form2 usando SendMessage
  SendMessage(Form2.Handle, WM_USER_MESSAGE, 0, LPARAM(PChar('SendMessage: Envia a mensagem de forma síncrona, ou seja, o código aguarda até que a mensagem seja processada antes de continuar.')));
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 Form2.Show;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ConsomeJSON;
end;

procedure TForm1.ConsomeJSON;
var
  Client: TRESTClient;
  Request: TRESTRequest;
  Response: TRESTResponse;
  MyObject: TMeuObjeto;
begin
  Client := TRESTClient.Create('https://docs.nextar.com.br/trial/textos_trial_pt_v2.json');
  Request := TRESTRequest.Create(Client);
  Response := TRESTResponse.Create(Client);
  try
    Request.Response := Response;
    Request.Method := rmGET;
    Request.Execute;
    MyObject := TJson.JsonToObject<TMeuObjeto>(Response.Content);
    try
      ShowMessage(MyObject.modalsucesso_semcupom); // substitua 'key_name' pela chave desejada

    finally
      MyObject.Free;
    end;
  finally
    Response.Free;
    Request.Free;
    Client.Free;
  end;

end;
end.

