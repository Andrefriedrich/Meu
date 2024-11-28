object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 319
  ClientWidth = 516
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnPostMessage: TButton
    Left = 40
    Top = 178
    Width = 150
    Height = 30
    Caption = 'PostMessage'
    TabOrder = 0
    OnClick = btnPostMessageClick
  end
  object btnSendMessage: TButton
    Left = 40
    Top = 228
    Width = 150
    Height = 30
    Caption = 'SendMessage'
    TabOrder = 1
    OnClick = btnSendMessageClick
  end
  object Button1: TButton
    Left = 40
    Top = 123
    Width = 150
    Height = 33
    Caption = 'Abre Form2'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 248
    Top = 123
    Width = 129
    Height = 33
    Caption = 'consome Json'
    TabOrder = 3
    OnClick = Button2Click
  end
end
