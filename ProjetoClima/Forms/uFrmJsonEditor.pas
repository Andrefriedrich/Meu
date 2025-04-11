unit uFrmJsonEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus, Vcl.StdCtrls,
  cxButtons, cxTextEdit, cxMemo, Vcl.ExtCtrls;

type
  TFrmJsonEditor = class(TForm)
    memoJson: TcxMemo;
    panRodape: TPanel;
    btnSalvar: TcxButton;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure CarregarEExibirJson(const AJsonString: string);
  end;

var
  FrmJsonEditor: TFrmJsonEditor;

implementation

{$R *.dfm}

{ TFrmJsonEditor }

procedure TFrmJsonEditor.CarregarEExibirJson(const AJsonString: string);
begin
  memoJson.Lines.Text := AJsonString;
end;

end.
