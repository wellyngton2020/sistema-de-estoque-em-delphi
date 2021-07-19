unit unitCadProdutoMov;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, System.Actions, Vcl.ActnList,
  System.ImageList, Vcl.ImgList, Data.Win.ADODB;

type
  TformCadProdutoMov = class(TForm)
    Label7: TLabel;
    e_qtde: TEdit;
    Label8: TLabel;
    Label6: TLabel;
    txt_total_produtos: TLabel;
    cb_produto: TComboBox;
    ActionList1: TActionList;
    ImageList1: TImageList;
    btn_fechar: TAction;
    btn_editar: TAction;
    btn_excluir: TAction;
    btn_salvar: TAction;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    ToolButton2: TToolButton;
    ToolButton4: TToolButton;
    ToolButton1: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton3: TToolButton;
    DBGrid1: TDBGrid;
    DS: TDataSource;
    quCadProMov: TADOQuery;
    quCadProMovid: TAutoIncField;
    quCadProMovid_movimentacao: TIntegerField;
    quCadProMovid_produto: TIntegerField;
    quCadProMovqtd: TIntegerField;
    quCadProMovnomeProduto: TStringField;
    add: TButton;
    btn_adicionar: TAction;
    procedure btn_fecharExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pegaProdutos;
    procedure pegaDados;
    procedure limpaCampos;
    procedure calculaTotais;
    procedure btn_salvarExecute(Sender: TObject);
    procedure btn_excluirExecute(Sender: TObject);
    procedure btn_editarExecute(Sender: TObject);
    procedure e_qtdeChange(Sender: TObject);
    procedure btn_adicionarExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    idMovimentacao: integer;
    id : string;
  end;
    TUsrItens = class
    id: string;
  end;

var
  formCadProdutoMov: TformCadProdutoMov;

implementation

{$R *.dfm}

uses unitDM, unitCadMovimentacao;

procedure TformCadProdutoMov.btn_adicionarExecute(Sender: TObject);
begin
   if cb_produto.ItemIndex < 0 then
    begin
      ShowMessage('Preencha o campo Produto');
    end
    else if e_qtde.Text = '' then
    begin
      ShowMessage('Preecha o campo Quantidade');
    end;

  with DM.qu do
  begin
     close;
      if id <> '' then
      begin
        SQL.Text:= 'update movimentacoes_produtos set id_produto =' +
        TUsrItens(cb_produto.Items.Objects[cb_produto.ItemIndex]).id + ',' +
        'qtd =' + QuotedStr(e_qtde.Text) +
        'where id=' + id;
        ShowMessage('Registo editado!');
       end
      else
      begin
        SQL.Text:= 'insert into movimentacoes_produtos (id_movimentacao, id_produto, qtd) values (' +
        IntToStr(idMovimentacao) + ',' + TUsrItens(cb_produto.Items.Objects[cb_produto.ItemIndex]).id + ',' +
        QuotedStr(e_qtde.Text) + ')';
      end;
      ExecSQL;
      id := '';
      limpaCampos;
      pegaDados;
  end;
end;

procedure TformCadProdutoMov.btn_editarExecute(Sender: TObject);
begin
    if quCadProMov.FieldByName('id').AsString = '' then   // para pegar a coluna especificada(id) da query
    begin
    ShowMessage('A tabela está vazia');
    exit; // exit para parar o processo se entrar nesta condição.
    end
    else
    begin
    id:= quCadProMovid.AsString; // conforme o id que estiver setado na dbgrid1 ele traz nos campos as informaçoes
    cb_produto.ItemIndex := cb_produto.Items.IndexOf(quCadProMovnomeProduto.AsString);
    e_qtde.Text := quCadProMovqtd.AsString;
    end;
end;

procedure TformCadProdutoMov.btn_excluirExecute(Sender: TObject);
begin

  if quCadProMov.FieldByName('id').AsString = '' then   // para pegar a coluna especificada(id) da query
  begin
    ShowMessage('A tabela está vazia');
    exit; // exit para parar o processo se entrar nesta condição.
  end;

  with DM.qu do
    begin
      if Application.MessageBox('Tem certeza que deseja excluir o registro selecionado?',
      'Confirmação', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = IDYES then
        begin
         close;
         SQL.Text:='delete movimentacoes_produtos' +
         ' where id =' + quCadProMov.FieldByName('id').AsString; // para pegar o campo id selecionado na qu Cad produtos
         ExecSQL;
         pegaDados;
       end;
    end;
end;

procedure TformCadProdutoMov.btn_fecharExecute(Sender: TObject);
begin
  limpaCampos;
  close;
end;

procedure TformCadProdutoMov.btn_salvarExecute(Sender: TObject);
var
  saldo : string;
begin
  quCadProMov.First;
  while not quCadProMov.eof do
  begin
    with DM.qu do
    begin
      Close;
      SQL.Text:= 'select (select ISNULL(SUM(qtd), 0) qtd from movimentacoes_produtos mp1' +
      ' where (select tipo from movimentacoes where id = mp1.id_movimentacao) =' + QuotedStr('Entrada no Estoque') +
      ' and mp1.id_produto =' + quCadProMovid_produto.AsString +
      ') - ' +
      '(select ISNULL(SUM(qtd), 0) qtd from movimentacoes_produtos mp1 where' +
      '(select tipo from movimentacoes where id = mp1.id_movimentacao) =' +  QuotedStr('Saída do Estoque') +
      ' and mp1.id_produto =' + quCadProMovid_produto.AsString +
      ') saldo ' +
      'from produtos mp where id =' + quCadProMovid_produto.AsString;
      // SubQuery para pegar o saldo do campo qtd para ser armazenado em uma variavel
      Open;
      saldo := DM.qu.FieldByName('saldo').AsString; // variavel armazena o saldo do campo saldo
      close;
      SQL.Text:= 'update produtos set estoque_atual =' + saldo + // atualiza a tabela conforme o saldo armazenado
      ' where id  =' + quCadProMovid_produto.AsString;
      ExecSQL;
    end;
    quCadProMov.Next;
  end;


  limpaCampos;
  pegaDados;
  formCadProdutoMov.close;
end;

procedure TformCadProdutoMov.FormShow(Sender: TObject);
begin
  pegaProdutos;
  pegaDados;
end;

procedure TformCadProdutoMov.pegaProdutos;   // procedure para listar os colaboradores no cb_tipo_fornecedor
var
  iditem: TUsrItens;
begin
  cb_produto.Clear;
  with DM.qu do
  begin
    close;
    SQL.Text:= 'select id, nome, fabricante, validade, estoque_atual, status from produtos where status =' + QuotedStr('Ativo');
    open;
    while not eof do
    begin
      iditem:= TUsrItens.Create;
      iditem.id:= FieldByName('ID').AsString;   // bloco de cod para fazer listar os produtos(nomes) no cb
      cb_produto.AddItem(FieldByName('NOME').AsString, iditem);
      next;
    end;
  end;
end;

procedure TformCadProdutoMov.pegaDados;
var
  calculaTotais : integer;
begin
  calculaTotais := 0;
  with quCadProMov do
    begin
      close;
      SQL.Text:= 'select id, id_produto, id_movimentacao, qtd from movimentacoes_produtos' +
      ' where id_movimentacao = ' + IntToStr(idMovimentacao);
      open;
      while not eof do
      begin
        calculaTotais := calculaTotais + fieldByName('qtd').AsInteger;
        next;
      end;
    end;
    txt_total_produtos.Caption := IntToStr(calculaTotais);
end;

procedure TformCadProdutoMov.limpaCampos;
begin
  cb_produto.ItemIndex :=  -1;
  e_qtde.Clear;
end;

procedure TformCadProdutoMov.calculaTotais;
begin
  with DM.qu do
  begin
  close;
  SQL.Text:= 'select sum(qtd) from movimentacoes_produtos' +
  ' where id_movimentacao = '  +  IntToStr(idMovimentacao);
  Open;
  end;
end;

procedure TformCadProdutoMov.e_qtdeChange(Sender: TObject);
begin
  if e_qtde.Text <> '' then
  begin
    btn_salvar.Enabled := True;
  end;
end;

end.
