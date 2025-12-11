object FConfig: TFConfig
  Left = 0
  Top = 0
  Caption = 'Configurar Conex'#227'o'
  ClientHeight = 259
  ClientWidth = 278
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 15
  object Label1: TLabel
    Left = 12
    Top = 15
    Width = 43
    Height = 15
    Caption = 'Servidor'
  end
  object Label2: TLabel
    Left = 12
    Top = 50
    Width = 84
    Height = 15
    Caption = 'Banco de dados'
  end
  object Label3: TLabel
    Left = 12
    Top = 85
    Width = 28
    Height = 15
    Caption = 'Porta'
  end
  object Label4: TLabel
    Left = 12
    Top = 120
    Width = 40
    Height = 15
    Caption = 'Usu'#225'rio'
  end
  object Label5: TLabel
    Left = 12
    Top = 156
    Width = 32
    Height = 15
    Caption = 'Senha'
  end
  object Label6: TLabel
    Left = 12
    Top = 191
    Width = 72
    Height = 15
    Caption = 'Caminho DLL'
  end
  object edServer: TEdit
    Left = 108
    Top = 11
    Width = 159
    Height = 23
    TabOrder = 0
  end
  object edDatabase: TEdit
    Left = 108
    Top = 46
    Width = 159
    Height = 23
    TabOrder = 1
  end
  object edPort: TEdit
    Left = 108
    Top = 81
    Width = 159
    Height = 23
    NumbersOnly = True
    TabOrder = 2
  end
  object edUser: TEdit
    Left = 108
    Top = 116
    Width = 159
    Height = 23
    TabOrder = 3
  end
  object edPass: TEdit
    Left = 108
    Top = 152
    Width = 159
    Height = 23
    PasswordChar = '*'
    TabOrder = 4
  end
  object bOK: TButton
    Left = 34
    Top = 230
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 6
    OnClick = bOKClick
  end
  object bCancelar: TButton
    Left = 168
    Top = 230
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 7
    OnClick = bCancelarClick
  end
  object edDLL: TEdit
    Left = 108
    Top = 187
    Width = 135
    Height = 23
    TabOrder = 5
  end
  object bOpen: TBitBtn
    Left = 248
    Top = 187
    Width = 19
    Height = 23
    Caption = '...'
    TabOrder = 8
    OnClick = bOpenClick
  end
  object FileOpenDialog: TFileOpenDialog
    DefaultExtension = 'DLL'
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'Biblioteca MySQL'
        FileMask = '*.DLL'
      end>
    Options = []
    Title = 'Selecione a DLL do MySQL'
    Left = 160
    Top = 176
  end
end
