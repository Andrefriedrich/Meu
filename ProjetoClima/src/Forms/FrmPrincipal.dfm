object FormPrincipal: TFormPrincipal
  Left = 0
  Top = 0
  ClientHeight = 571
  ClientWidth = 868
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object edCidade: TcxTextEdit
    Left = 136
    Top = 51
    TabOrder = 0
    Width = 121
  end
  object btnApagar: TcxButton
    Left = 136
    Top = 89
    Width = 121
    Height = 25
    Caption = 'Apagar Resultado'
    TabOrder = 1
    OnClick = btnApagarClick
  end
  object memResultado: TcxMemo
    Left = 278
    Top = 51
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -19
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
    TabOrder = 2
    Height = 494
    Width = 419
  end
  object btnBuscaComRestJson: TcxButton
    Left = 136
    Top = 120
    Width = 121
    Height = 25
    Caption = 'BuscaComRestJson'
    TabOrder = 3
    OnClick = btnBuscaComRestJsonClick
  end
  object btnBuscaComGrijjy: TcxButton
    Left = 136
    Top = 151
    Width = 121
    Height = 25
    Caption = 'BuscaComGrijjy'
    TabOrder = 4
    OnClick = btnBuscaComGrijjyClick
  end
end
