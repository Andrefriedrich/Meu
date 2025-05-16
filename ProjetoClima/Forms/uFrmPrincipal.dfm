object FormPrincipal: TFormPrincipal
  Left = 0
  Top = 0
  ClientHeight = 353
  ClientWidth = 661
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object ImagemClima: TImage
    Left = 451
    Top = 142
    Width = 69
    Height = 70
  end
  object edCidade: TcxTextEdit
    Left = 212
    Top = 22
    AutoSize = False
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -13
    Style.Font.Name = 'Arial'
    Style.Font.Style = []
    Style.IsFontAssigned = True
    TabOrder = 0
    Height = 30
    Width = 206
  end
  object btnBuscaComRestJson: TcxButton
    Left = 457
    Top = 64
    Width = 88
    Height = 25
    Caption = ' Rest.Json'
    TabOrder = 1
    OnClick = btnBuscaComRestJsonClick
  end
  object btnBuscaComGrijjy: TcxButton
    Left = 457
    Top = 27
    Width = 88
    Height = 25
    Caption = 'Grijjy'
    TabOrder = 2
    OnClick = btnBuscaComGrijjyClick
  end
  object lbUltimaAtualizacao: TcxLabel
    Left = 24
    Top = 146
    Caption = 'Ultima atualiza'#231#227'o de dados:'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Segoe UI'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object lbTemperatura: TcxLabel
    Left = 24
    Top = 215
    Caption = 'Temperatura em '#176'C:'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Segoe UI'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object lbClima: TcxLabel
    Left = 364
    Top = 215
    Caption = 'Clima:'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Segoe UI'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object lbIndiceUV: TcxLabel
    Left = 24
    Top = 246
    Caption = 'Indice UV:'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Segoe UI'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object lbDirecaoVento: TcxLabel
    Left = 24
    Top = 182
    Caption = 'Dire'#231#227'o do vento:'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Segoe UI'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object cxLabel1: TcxLabel
    Left = 24
    Top = 29
    Caption = 'Digite o nome da cidade:'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object cxLabel2: TcxLabel
    Left = -8
    Top = 91
    Caption = 
      '________________________________________________________________' +
      '________________________________________________________________' +
      '_'
  end
  object cxLabel3: TcxLabel
    Left = 424
    Top = 114
    Caption = 'Pa'#237's:'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object lbStatus: TcxLabel
    Left = 95
    Top = 315
    Caption = 'Aguardando consulta.'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -21
    Style.Font.Name = 'Franklin Gothic Book'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object btnExibirJson: TcxButton
    Left = 551
    Top = 27
    Width = 88
    Height = 25
    Caption = 'Exibir Json'
    TabOrder = 12
    OnClick = btnExibirJsonClick
  end
  object cxLabel4: TcxLabel
    Left = 24
    Top = 114
    Caption = 'Cidade pesquisada:'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object lbCidade: TcxLabel
    Left = 175
    Top = 114
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object lbPais: TcxLabel
    Left = 468
    Top = 114
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object lbDataHoraDados: TcxLabel
    Left = 231
    Top = 147
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object lbDescricaoClima: TcxLabel
    Left = 414
    Top = 215
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Segoe UI'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object lbVento: TcxLabel
    Left = 155
    Top = 182
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Segoe UI'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object lbUV: TcxLabel
    Left = 103
    Top = 246
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Segoe UI'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object lbTempC: TcxLabel
    Left = 170
    Top = 215
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Segoe UI'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object cxLabel5: TcxLabel
    Left = 24
    Top = 315
    Caption = 'Status:'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -21
    Style.Font.Name = 'Franklin Gothic Book'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
end
