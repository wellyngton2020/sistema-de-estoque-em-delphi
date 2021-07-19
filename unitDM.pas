unit unitDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, Data.Win.ADODB, Vcl.Dialogs;

type
  TDM = class(TDataModule)
    Conexao: TADOConnection;
    tbProdutos: TADOTable;
    dsProdutos: TDataSource;
    tbProdutosid: TAutoIncField;
    tbProdutosnome: TStringField;
    tbProdutosfabricante: TStringField;
    tbProdutosvalidade: TDateTimeField;
    tbProdutosestoque_atual: TIntegerField;
    tbMovimentacoes: TADOTable;
    dsMovimentacoes: TDataSource;
    tbMovProdutos: TADOTable;
    dsMovProdutos: TDataSource;
    quAumentaEstoque: TADOQuery;
    quDiminuiEstoque: TADOQuery;
    quMovimentacoes: TADOQuery;
    dsQuMovimentacoes: TDataSource;
    qu: TADOQuery;
    tbMovimentacoesid: TAutoIncField;
    tbMovimentacoestipo: TStringField;
    tbMovimentacoesdata_hora: TDateTimeField;
    tbMovimentacoesresponsavel: TStringField;
    tbMovimentacoesobs: TStringField;
    tbMovimentacoesstatus: TStringField;
    tbMovProdutosid: TAutoIncField;
    tbMovProdutosid_movimentacao: TIntegerField;
    tbMovProdutosid_produto: TIntegerField;
    tbMovProdutosqtd: TIntegerField;
    tbMovProdutosnomeProduto: TStringField;
    procedure calculaTotais;
    procedure quAfterDelete(DataSet: TDataSet);
    procedure quAfterPost(DataSet: TDataSet);
    procedure tbMovProdutosAfterPost(DataSet: TDataSet);
    procedure tbMovProdutosBeforeDelete(DataSet: TDataSet);
    procedure tbMovimentacoesBeforeDelete(DataSet: TDataSet);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses unitCadMovimentacao, unitCadProduto, unitCadProdutoMov,
  unitConsMovimentacao, unitPrincipal;

{$R *.dfm}

procedure TDM.quAfterDelete(DataSet: TDataSet);
begin
  CalculaTotais;
end;

procedure TDM.quAfterPost(DataSet: TDataSet);
begin
  CalculaTotais;
end;

procedure TDM.tbMovimentacoesBeforeDelete(DataSet: TDataSet);
begin
  if tbMovProdutos.RecordCount > 0 then
  begin
    ShowMessage('Existem produtos cadastrados nessa movimentação. Faça a exclusão primeiros.');
    abort;
  end;
end;

procedure TDM.tbMovProdutosAfterPost(DataSet: TDataSet);
begin
  if (tbMovimentacoes.FieldByName('tipo').Value = 'Entrada no Estoque') then
  begin
    quAumentaEstoque.Parameters.ParamByName('pId').Value := tbMovProdutos.FieldByName('idProduto').Value;
    quAumentaEstoque.Parameters.ParamByName('pQtd').Value := tbMovProdutos.FieldByName('qtd').Value;
    quAumentaEstoque.ExecSQL;
  end;

  if (tbMovimentacoes.FieldByName('tipo').Value = 'Saída do Estoque') then
  begin
    quDiminuiEstoque.Parameters.ParamByName('pId').Value.AssignValues := tbMovProdutos.FieldByName('idProduto').Value;
    quDiminuiEstoque.Parameters.ParamByName('pQtd').Value := tbMovProdutos.FieldByName('qtd').Value;
    quDiminuiEstoque.ExecSQL;
  end;

end;

procedure TDM.tbMovProdutosBeforeDelete(DataSet: TDataSet);
begin
  if (tbMovimentacoes.FieldByName('tipo').Value = 'Entrada no Estoque') then
  begin
    quDiminuiEstoque.Parameters.ParamByName('pId').Value := tbMovProdutos.FieldByName('idProduto').Value;
    quDiminuiEstoque.Parameters.ParamByName('pQtd').Value := tbMovProdutos.FieldByName('qtd').Value;
    quDiminuiEstoque.ExecSQL;
  end;

  if (tbMovimentacoes.FieldByName('tipo').Value = 'Saída do Estoque') then
  begin
    quAumentaEstoque.Parameters.ParamByName('pId').Value := tbMovProdutos.FieldByName('idProduto').Value;
    quAumentaEstoque.Parameters.ParamByName('pQtd').Value := tbMovProdutos.FieldByName('qtd').Value;
    quAumentaEstoque.ExecSQL;
  end;
end;

procedure TDM.calculaTotais;
var
  totais : Integer;
begin
  qu.First;

  while not tbMovProdutos.Eof do
  begin
    totais:= totais + qu.FieldByName('qtd').Value;

    qu.Next;
  end;

  formCadProdutoMov.txt_total_produtos.Caption := IntToStr(totais);

end;

end.
