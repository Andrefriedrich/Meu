object FormPrincipal: TFormPrincipal
  Left = 0
  Top = 0
  ClientHeight = 311
  ClientWidth = 650
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ImagemClima: TImage
    Left = 349
    Top = 148
    Width = 69
    Height = 70
  end
  object edCidade: TcxTextEdit
    Left = 212
    Top = 29
    TabOrder = 0
    Width = 206
  end
  object btnBuscaComRestJson: TcxButton
    Left = 457
    Top = 39
    Width = 169
    Height = 25
    Caption = 'Retorna dados com RestJson'
    TabOrder = 1
    OnClick = btnBuscaComRestJsonClick
  end
  object btnBuscaComGrijjy: TcxButton
    Left = 457
    Top = 8
    Width = 169
    Height = 25
    Caption = 'Retorna dados com Grijjy'
    TabOrder = 2
    OnClick = btnBuscaComGrijjyClick
  end
  object lbUltimaAtualizacao: TcxLabel
    Left = 24
    Top = 115
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
    Top = 205
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
    Top = 143
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
    Top = 206
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
    Top = 174
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
    Top = 120
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
    Top = 210
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
    Top = 148
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
    Top = 210
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
    Top = 178
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
    Top = 25
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
  object edPais: TEdit
    Left = 212
    Top = 64
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
    Top = 62
    Caption = 'Pa'#237's:'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
end
