object dmPedidos: TdmPedidos
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object MySQL_DriverLink: TFDPhysMySQLDriverLink
    DriverID = 'MySQL'
    VendorLib = 'C:\Teste_Delphi\LIB\libmysql.dll'
    Left = 64
    Top = 8
  end
  object FDConn: TFDConnection
    ConnectionName = 'MYSQL'
    Params.Strings = (
      'Database=xx'
      'User_Name=xx'
      'Server=127.0.0.1'
      'DriverID=MySQL')
    FormatOptions.AssignedValues = [fvSE2Null, fvFmtDisplayDate]
    FormatOptions.StrsEmpty2Null = True
    FormatOptions.FmtDisplayDate = 'dd/mm/yyyy'
    LoginPrompt = False
    Transaction = FDTransaction1
    Left = 64
    Top = 72
  end
  object qClientes: TFDQuery
    Connection = FDConn
    SQL.Strings = (
      'SELECT * FROM CLIENTES'
      'ORDER BY NOME')
    Left = 64
    Top = 144
  end
  object dsClientes: TDataSource
    AutoEdit = False
    DataSet = qClientes
    Left = 154
    Top = 144
  end
  object qProdutos: TFDQuery
    Connection = FDConn
    SQL.Strings = (
      'SELECT * FROM PRODUTOS'
      'ORDER BY DESCRICAO')
    Left = 64
    Top = 200
  end
  object dsProdutos: TDataSource
    AutoEdit = False
    DataSet = qProdutos
    Left = 154
    Top = 200
  end
  object qPedidos: TFDQuery
    BeforePost = qPedidosBeforePost
    AfterPost = qPedidosAfterPost
    AfterCancel = qPedidosAfterCancel
    BeforeDelete = qPedidosBeforeDelete
    AfterDelete = qPedidosAfterDelete
    AfterScroll = qPedidosAfterScroll
    OnNewRecord = qPedidosNewRecord
    Connection = FDConn
    UpdateObject = FDUpdateSQL_Pedidos
    SQL.Strings = (
      'SELECT * FROM PEDIDOS'
      'ORDER BY CODIGO')
    Left = 64
    Top = 256
  end
  object dsPedidos: TDataSource
    DataSet = qPedidos
    OnStateChange = dsPedidosStateChange
    Left = 154
    Top = 256
  end
  object qPedido_Itens: TFDQuery
    BeforePost = qPedido_ItensBeforePost
    AfterPost = qPedido_ItensAfterPost
    BeforeDelete = qPedido_ItensBeforeDelete
    AfterRefresh = qPedido_ItensAfterRefresh
    OnNewRecord = qPedido_ItensNewRecord
    FieldOptions.PositionMode = poFirst
    MasterSource = dsPedidos
    MasterFields = 'CODIGO'
    Connection = FDConn
    FormatOptions.AssignedValues = [fvSE2Null]
    FormatOptions.StrsEmpty2Null = True
    UpdateObject = FDUpdateSQL_Itens
    SQL.Strings = (
      'SELECT * '
      'FROM PEDIDOS_ITENS'
      'WHERE CODPED = :CODIGO'
      'ORDER BY CODPED, CODIGO')
    Left = 64
    Top = 312
    ParamData = <
      item
        Name = 'CODIGO'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qPedido_ItensCODIGO: TFDAutoIncField
      FieldName = 'CODIGO'
    end
    object qPedido_ItensCODPED: TIntegerField
      FieldName = 'CODPED'
    end
    object qPedido_ItensCODPROD: TIntegerField
      FieldName = 'CODPROD'
    end
    object qPedido_ItensPRODUTO: TStringField
      DisplayLabel = 'Produto'
      FieldKind = fkLookup
      FieldName = 'PRODUTO'
      LookupDataSet = qProdutos
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'DESCRICAO'
      KeyFields = 'CODPROD'
      Size = 80
      Lookup = True
    end
    object qPedido_ItensQTDE: TIntegerField
      FieldName = 'QTDE'
    end
    object qPedido_ItensVL_UNIT: TFloatField
      FieldName = 'VL_UNIT'
      currency = True
    end
    object qPedido_ItensVL_TOTAL: TFloatField
      FieldName = 'VL_TOTAL'
      currency = True
    end
  end
  object dsPedido_Itens: TDataSource
    DataSet = qPedido_Itens
    OnStateChange = dsPedido_ItensStateChange
    Left = 154
    Top = 312
  end
  object FDTransaction1: TFDTransaction
    Options.AutoStop = False
    Connection = FDConn
    Left = 136
    Top = 72
  end
  object FDUpdateSQL_Pedidos: TFDUpdateSQL
    Connection = FDConn
    InsertSQL.Strings = (
      'INSERT INTO PEDIDOS (CODCLI, DATA_EMISSAO, VL_TOTAL)'
      'VALUES'
      '(:CODCLI, :DATA_EMISSAO, :VL_TOTAL)')
    ModifySQL.Strings = (
      'UPDATE PEDIDOS SET'
      '   CODCLI = :CODCLI, '
      '   DATA_EMISSAO = :DATA_EMISSAO, '
      '   VL_TOTAL = :VL_TOTAL'
      'WHERE CODIGO = :CODIGO')
    DeleteSQL.Strings = (
      'DELETE FROM PEDIDOS WHERE CODIGO = :CODIGO')
    Left = 259
    Top = 256
  end
  object FDUpdateSQL_Itens: TFDUpdateSQL
    Connection = FDConn
    InsertSQL.Strings = (
      
        'INSERT INTO PEDIDOS_ITENS (CODPED, CODPROD, QTDE, VL_UNIT, VL_TO' +
        'TAL)'
      'VALUES'
      '(:CODPED, :CODPROD, :QTDE, :VL_UNIT, :VL_TOTAL)')
    ModifySQL.Strings = (
      'UPDATE PEDIDOS_ITENS SET'
      '   CODPROD = :CODPROD,'
      '   QTDE = :QTDE, '
      '   VL_UNIT = :VL_UNIT, '
      '   VL_TOTAL = :VL_TOTAL'
      'WHERE CODIGO = :CODIGO')
    DeleteSQL.Strings = (
      'DELETE FROM PEDIDOS_ITENS WHERE CODIGO = :CODIGO')
    Left = 259
    Top = 312
  end
end
