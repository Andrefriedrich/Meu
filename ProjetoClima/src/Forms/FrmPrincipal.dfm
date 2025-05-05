object FormPrincipal: TFormPrincipal
  Left = 0
  Top = 0
  ClientHeight = 353
  ClientWidth = 650
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
    Left = 349
    Top = 196
    Width = 69
    Height = 70
  end
  object edCidade: TcxTextEdit
    Left = 212
    Top = 77
    TabOrder = 0
    Width = 206
  end
  object btnBuscaComRestJson: TcxButton
    Left = 457
    Top = 112
    Width = 88
    Height = 25
    Caption = ' Rest.Json'
    TabOrder = 1
    OnClick = btnBuscaComRestJsonClick
  end
  object btnBuscaComGrijjy: TcxButton
    Left = 457
    Top = 75
    Width = 88
    Height = 25
    Caption = 'Grijjy'
    TabOrder = 2
    OnClick = btnBuscaComGrijjyClick
  end
  object lbUltimaAtualizacao: TcxLabel
    Left = 24
    Top = 163
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
    Top = 253
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
    Left = 24
    Top = 191
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
    Left = 215
    Top = 254
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
    Top = 222
    Caption = 'Dire'#231#227'o do vento:'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Segoe UI'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object edUltimaAtualizacao: TEdit
    Left = 231
    Top = 168
    Width = 187
    Height = 21
    Color = clScrollBar
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 8
  end
  object edTemperatura: TEdit
    Left = 169
    Top = 258
    Width = 38
    Height = 21
    Color = clScrollBar
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 9
  end
  object edClima: TEdit
    Left = 80
    Top = 196
    Width = 254
    Height = 21
    Color = clScrollBar
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 10
  end
  object edIndiceUV: TEdit
    Left = 294
    Top = 258
    Width = 40
    Height = 21
    Color = clScrollBar
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 11
  end
  object edDirecaoVento: TEdit
    Left = 157
    Top = 226
    Width = 177
    Height = 21
    Color = clScrollBar
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 12
  end
  object cxLabel1: TcxLabel
    Left = 24
    Top = 73
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
    Top = 139
    Caption = 
      '________________________________________________________________' +
      '________________________________________________________________' +
      '_'
  end
  object edPais: TEdit
    Left = 212
    Top = 112
    Width = 206
    Height = 21
    Color = clScrollBar
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 15
  end
  object cxLabel3: TcxLabel
    Left = 168
    Top = 110
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
    Left = 24
    Top = 16
    Caption = 'Consulte o clima da cidade!'
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
    Top = 75
    Width = 88
    Height = 25
    Caption = 'Exibir Json'
    TabOrder = 18
    OnClick = btnExibirJsonClick
  end
end
