unit uFrmJsonEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus, Vcl.StdCtrls,
  cxButtons, cxTextEdit, cxMemo, Vcl.ExtCtrls, Vcl.ExtDlgs;

type
  TFrmJsonEditor = class(TForm)
    memoJson: TcxMemo;
    panRodape: TPanel;
    btnSalvar: TcxButton;
    SaveDialog: TSaveDialog;
    procedure btnSalvarClick(Sender: TObject);
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

procedure TFrmJsonEditor.btnSalvarClick(Sender: TObject);
begin
  SaveDialog.Title := 'Salvar JSON';
  SaveDialog.Filter := 'Arquivos JSON (*.json)|*.json|Todos os Arquivos (*.*)|*.*';
  SaveDialog.DefaultExt := 'json';

  if SaveDialog.Execute then
  begin
    if MemoJson.Lines.Count = 0 then
    begin
      ShowMessage('Não há conteúdo no editor para salvar.');
      Exit;
    end;

    try
      MemoJson.Lines.SaveToFile(SaveDialog.FileName, TEncoding.UTF8);

      ShowMessage('Arquivo JSON salvo com sucesso em: ' + SaveDialog.FileName);

    except
      on E: Exception do
      begin
        ShowMessage('Ocorreu um erro ao salvar o arquivo JSON:'#13#10 + E.Message);
      end;
    end;
  end;
end;

procedure TFrmJsonEditor.CarregarEExibirJson(const AJsonString: string);
begin
  memoJson.Lines.Text := AJsonString;
end;

end.
