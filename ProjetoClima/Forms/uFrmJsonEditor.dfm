object FrmJsonEditor: TFrmJsonEditor
  Left = 0
  Top = 0
  Caption = 'Visualizador/Editor JSON'
  ClientHeight = 596
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object memoJson: TcxMemo
    Left = 0
    Top = 0
    Align = alTop
    TabOrder = 0
    Height = 537
    Width = 635
  end
  object panRodape: TPanel
    Left = 0
    Top = 537
    Width = 635
    Height = 59
    Align = alClient
    TabOrder = 1
    ExplicitTop = 543
    object btnSalvar: TcxButton
      Left = 32
      Top = 16
      Width = 105
      Height = 25
      Caption = 'Salvar'
      TabOrder = 0
      OnClick = btnSalvarClick
    end
  end
  object SaveDialog: TSaveDialog
    Left = 440
    Top = 545
  end
end
