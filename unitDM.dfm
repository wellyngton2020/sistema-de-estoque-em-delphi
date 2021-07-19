object DM: TDM
  OldCreateOrder = False
  Height = 675
  Width = 903
  object Conexao: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=sql;Persist Security Info=True;User' +
      ' ID=sa;Initial Catalog=db_cadastro;Data Source=(local)'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 40
    Top = 32
  end
  object tbProdutos: TADOTable
    Active = True
    Connection = Conexao
    CursorType = ctStatic
    TableName = 'produtos'
    Left = 112
    Top = 32
    object tbProdutosid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object tbProdutosnome: TStringField
      FieldName = 'nome'
      Size = 50
    end
    object tbProdutosfabricante: TStringField
      FieldName = 'fabricante'
      Size = 30
    end
    object tbProdutosvalidade: TDateTimeField
      FieldName = 'validade'
    end
    object tbProdutosestoque_atual: TIntegerField
      FieldName = 'estoque_atual'
    end
  end
  object dsProdutos: TDataSource
    DataSet = tbProdutos
    Left = 112
    Top = 96
  end
  object tbMovimentacoes: TADOTable
    Active = True
    Connection = Conexao
    CursorType = ctStatic
    BeforeDelete = tbMovimentacoesBeforeDelete
    TableName = 'movimentacoes'
    Left = 200
    Top = 32
    object tbMovimentacoesid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object tbMovimentacoestipo: TStringField
      FieldName = 'tipo'
    end
    object tbMovimentacoesdata_hora: TDateTimeField
      FieldName = 'data_hora'
    end
    object tbMovimentacoesresponsavel: TStringField
      FieldName = 'responsavel'
      Size = 30
    end
    object tbMovimentacoesobs: TStringField
      FieldName = 'obs'
      Size = 200
    end
    object tbMovimentacoesstatus: TStringField
      FieldName = 'status'
    end
  end
  object dsMovimentacoes: TDataSource
    DataSet = tbMovimentacoes
    Left = 200
    Top = 96
  end
  object tbMovProdutos: TADOTable
    Connection = Conexao
    CursorType = ctStatic
    AfterPost = tbMovProdutosAfterPost
    BeforeDelete = tbMovProdutosBeforeDelete
    TableName = 'movimentacoes_produtos'
    Left = 304
    Top = 32
    object tbMovProdutosid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object tbMovProdutosid_movimentacao: TIntegerField
      FieldName = 'id_movimentacao'
    end
    object tbMovProdutosid_produto: TIntegerField
      FieldName = 'id_produto'
    end
    object tbMovProdutosqtd: TIntegerField
      FieldName = 'qtd'
    end
    object tbMovProdutosnomeProduto: TStringField
      FieldKind = fkLookup
      FieldName = 'nomeProduto'
      LookupDataSet = tbProdutos
      LookupKeyFields = 'id'
      LookupResultField = 'nome'
      KeyFields = 'id_produto'
      Size = 50
      Lookup = True
    end
  end
  object dsMovProdutos: TDataSource
    DataSet = tbMovProdutos
    Left = 296
    Top = 96
  end
  object quAumentaEstoque: TADOQuery
    Parameters = <
      item
        Name = 'pId'
        Size = -1
        Value = Null
      end
      item
        Name = 'qpQtd'
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      
        'update produtos set estoque_atual = estoque_atual + :pQtd where ' +
        'id = :pId')
    Left = 96
    Top = 192
  end
  object quDiminuiEstoque: TADOQuery
    Parameters = <
      item
        Name = 'pId'
        Size = -1
        Value = Null
      end
      item
        Name = 'pQtd'
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      
        'update produtos set estoque_atual = estoque_atual - :pQtd where ' +
        'id = :pId')
    Left = 96
    Top = 248
  end
  object quMovimentacoes: TADOQuery
    Active = True
    Connection = Conexao
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from movimentacoes')
    Left = 248
    Top = 192
  end
  object dsQuMovimentacoes: TDataSource
    DataSet = quMovimentacoes
    Left = 248
    Top = 256
  end
  object qu: TADOQuery
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=sql;Persist Security Info=True;User' +
      ' ID=sa;Initial Catalog=db_cadastro;Data Source=(local)'
    AfterPost = quAfterPost
    AfterDelete = quAfterDelete
    Parameters = <>
    Left = 32
    Top = 96
  end
end
