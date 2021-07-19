unit unitConsMovimentacaoProdutos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids, System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, RpDefine, RpRave, RpCon, RpConDS;

type
  TformConsMovimentacaopProdutos = class(TForm)
    ActionList1: TActionList;
    ImageList1: TImageList;
    btn_consultar: TAction;
    Label1: TLabel;
    d_data_inicial: TDateTimePicker;
    Label2: TLabel;
    d_data_final: TDateTimePicker;
    Button1: TButton;
    quConsMovProduto: TADOQuery;
    quConsMovProdutoNome: TStringField;
    quConsMovProdutoEntrada: TIntegerField;
    quConsMovProdutoSaída: TIntegerField;
    DS: TDataSource;
    DBGrid2: TDBGrid;
    quConsMovProdutoSaldo: TIntegerField;
    RvProject1: TRvProject;
    Button2: TButton;
    btn_imprimir: TAction;
    RvDataSetConnection1: TRvDataSetConnection;
    c_produtos_zerados: TCheckBox;
    c_data: TCheckBox;
    ControlBar1: TControlBar;
    procedure pegaDados;
    procedure btn_consultarExecute(Sender: TObject);
    procedure btn_imprimirExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formConsMovimentacaopProdutos: TformConsMovimentacaopProdutos;

implementation

{$R *.dfm}

uses unitDM;

procedure TformConsMovimentacaopProdutos.btn_consultarExecute(Sender: TObject);
begin
  pegaDados;
end;

procedure TformConsMovimentacaopProdutos.btn_imprimirExecute(Sender: TObject);
begin
  pegaDados;
  RvProject1.SetParam('Data_inicial', DateToStr(d_data_inicial.Date)); // com o rvProject após setar o name data_inicial que está no RAVE, seleciona a variavel do delphi em que vai pegar a data.
  RvProject1.SetParam('Data_final', DateToStr(d_data_final.Date));
  RvProject1.Execute; // executa para chamar o RAVE.
end;

procedure TformConsMovimentacaopProdutos.pegaDados;
var
  filtro, filtro_data : string;
begin
  filtro := '';
  if QuotedStr(DateToStr(d_data_inicial.Date)) > QuotedStr(DateToStr(d_data_final.Date)) then
  begin
    ShowMessage('A data inicial não pode ser maior que a data final ');
    exit;
  end;

  if c_produtos_zerados.Checked = false then
  begin
    filtro :=  ' and ( select ISNULL(SUM(qtd),0) from movimentacoes_produtos mp where id_produto = p.id' +
        ' and ( select tipo from movimentacoes where id = mp.id_movimentacao) =' +
        QuotedStr('Entrada no Estoque') + ')' + '> 0';
  end;

  if c_data.Checked = true then
  begin
    filtro_data := 'and (select data_hora from movimentacoes where id = mp.id_movimentacao) between ' +
    QuotedStr(DateToStr(d_data_inicial.Date) + ' 0:0:0 ' ) + ' and ' + QuotedStr(DateToStr(d_data_final.Date) + ' 23:59:59 ' );
  end;

  with quConsMovProduto do
    begin
        close;
        SQL.Text:= 'select nome as [Nome],' +
	      '(select ISNULL(SUM(qtd),0) from movimentacoes_produtos mp where id_produto = p.id' +
        ' and (select tipo from movimentacoes where id = mp.id_movimentacao) ='
        + QuotedStr('Entrada no Estoque') + filtro_data +  ') as [Entrada], ' +
	      '(select ISNULL(SUM(qtd),0) from movimentacoes_produtos mp where id_produto = p.id' +
		    ' and (select tipo from movimentacoes where id = mp.id_movimentacao) =' + QuotedStr('Saída do Estoque') +
		    filtro_Data +  ' ) as [Saída], ' +
        '(select ISNULL(SUM(qtd),0) from movimentacoes_produtos mp where id_produto = p.id' +
        ' and (select tipo from movimentacoes where id = mp.id_movimentacao) ='
        + QuotedStr('Entrada no Estoque') + filtro_data +
        ') - ' +
        '(select ISNULL(SUM(qtd),0) from movimentacoes_produtos mp where id_produto = p.id' +
        ' and (select tipo from movimentacoes where id = mp.id_movimentacao) =' + QuotedStr('Saída do Estoque') +
        filtro_data +  ') as [Saldo] ' +
        ' from produtos p where nome is not null'  + filtro;
        ShowMessage(SQL.Text);
        open;
    end;
end;

end.
