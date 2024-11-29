unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm2 = class(TForm)
    Memo1: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure WndProc(var Msg: TMessage); override;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

const
  WM_USER_MESSAGE = WM_USER + 1;

procedure TForm2.WndProc(var Msg: TMessage);
var
  ReceivedMessage: string;
begin
  if Msg.Msg = WM_USER_MESSAGE then
  begin
    // Receber mensagem
    ReceivedMessage := PChar(Msg.LParam);
    Memo1.Lines.Add('Recebido: ' + ReceivedMessage);
  end
  else
    inherited WndProc(Msg);
end;

end.

