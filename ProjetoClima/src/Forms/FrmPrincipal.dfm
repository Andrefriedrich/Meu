object FormPrincipal: TFormPrincipal
  Left = 0
  Top = 0
  ClientHeight = 361
  ClientWidth = 724
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object cbLanguage: TcxComboBox
    Left = 120
    Top = 24
    ParentShowHint = False
    Properties.Items.Strings = (
      'sq Albanian'
      'af Afrikaans'
      'ar Arabic'
      'az Azerbaijani'
      'eu Basque'
      'be Belarusian'
      'bg Bulgarian'
      'ca Catalan'
      'zh_cn Chinese Simplified'
      'zh_tw Chinese Traditional'
      'hr Croatian'
      'cz Czech'
      'da Danish'
      'nl Dutch'
      'en English'
      'fi Finnish'
      'fr French'
      'gl Galician'
      'de German'
      'el Greek'
      'he Hebrew'
      'hi Hindi'
      'hu Hungarian'
      'is Icelandic'
      'id Indonesian'
      'it Italian'
      'ja Japanese'
      'kr Korean'
      'ku Kurmanji (Kurdish)'
      'la Latvian'
      'lt Lithuanian'
      'mk Macedonian'
      'no Norwegian'
      'fa Persian (Farsi)'
      'pl Polish'
      'pt Portuguese'
      'pt_br Portugu'#234's Brasil'
      'ro Romanian'
      'ru Russian'
      'sr Serbian'
      'sk Slovak'
      'sl Slovenian'
      'sp, es Spanish'
      'sv, se Swedish'
      'th Thai'
      'tr Turkish'
      'ua, uk Ukrainian'
      'vi Vietnamese'
      'zu Zulu')
    ShowHint = False
    TabOrder = 0
    Text = 'Language'
    Width = 121
  end
  object cbLatitude: TcxTextEdit
    Left = 120
    Top = 51
    TabOrder = 1
    Width = 121
  end
  object edCidade: TcxTextEdit
    Left = 120
    Top = 150
    TabOrder = 2
    Width = 121
  end
  object cxLabel1: TcxLabel
    Left = 23
    Top = 20
    Caption = 'Linguagem'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Segoe UI Semibold'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object lbLatitude: TcxLabel
    Left = 23
    Top = 47
    Caption = 'Latitude'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Segoe UI Semibold'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object lbLongitude: TcxLabel
    Left = 23
    Top = 74
    Caption = 'Longitude'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Segoe UI Semibold'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object lbUnidade: TcxLabel
    Left = 23
    Top = 101
    Caption = 'Unidade'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Segoe UI Semibold'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object cbUnidade: TcxComboBox
    Left = 120
    Top = 105
    Properties.DropDownRows = 2
    Properties.Items.Strings = (
      'Metric (Celsius)'
      'Imperial (Faren..)')
    TabOrder = 7
    Width = 121
  end
  object btnSaveJson: TcxButton
    Left = 120
    Top = 188
    Width = 121
    Height = 25
    Caption = 'Consultar Clima'
    TabOrder = 8
    OnClick = btnSaveJsonClick
  end
  object StaticText1: TStaticText
    Left = 296
    Top = 24
    Width = 167
    Height = 17
    Caption = 'Sao Paulo -23.55052, -46.633308'
    TabOrder = 9
  end
  object memResultado: TcxMemo
    Left = 278
    Top = 51
    Lines.Strings = (
      'memResultado')
    TabOrder = 10
    Height = 302
    Width = 427
  end
  object btnFetchRestJson: TcxButton
    Left = 120
    Top = 219
    Width = 121
    Height = 25
    Caption = 'btnFetchRestJson'
    TabOrder = 11
    OnClick = btnFetchRestJsonClick
  end
  object btnFetchGrijjy: TcxButton
    Left = 120
    Top = 250
    Width = 121
    Height = 25
    Caption = 'btnFetchGrijjy'
    TabOrder = 12
    OnClick = btnFetchGrijjyClick
  end
end
