unit unitConsMovimentacao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ToolWin, Vcl.Mask, Vcl.ExtCtrls,
  System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Data.Win.ADODB;

type
  TformConsMovimentacao = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    lbl: TLabel;
    consultar: TButton;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    ActionList1: TActionList;
    ImageList1: TImageList;
    btn_consultar: TAction;
    quConsMov: TADOQuery;
    DataSource1: TDataSource;
    quConsMovid: TAutoIncField;
    quConsMovtipo: TStringField;
    quConsMovdata_hora: TDateTimeField;
    quConsMovresponsavel: TStringField;
    quConsMovobs: TStringField;
    quConsMovstatus: TStringField;
    e_data_final: TDateTimePicker;
    e_data_inicial: TDateTimePicker;
    quConsMovProd: TADOQuery;
    DataSource2: TDataSource;
    quConsMovProdid: TAutoIncField;
    quConsMovProdid_movimentacao: TIntegerField;
    quConsMovProdid_produto: TIntegerField;
    quConsMovProdqtd: TIntegerField;
    Label1: TLabel;
    txt_total_movimentacoes: TLabel;
    quConsMovProdnomeProduto: TStringField;
    Label3: TLabel;
    txt_total_produtos: TLabel;
    procedure pegaDados;
    procedure pegaProdutos;
    procedure FormShow(Sender: TObject);
    procedure btn_consultarExecute(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
//    procedure calculaTotais;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formConsMovimentacao: TformConsMovimentacao;

implementation

{$R *.dfm}

uses unitDM;

procedure TformConsMovimentacao.btn_consultarExecute(Sender: TObject);
begin
  pegaDados;
  pegaProdutos;
end;

procedure TformConsMovimentacao.DBGrid1CellClick(Column: TColumn);
begin
  pegaProdutos;
end;

procedure TformConsMovimentacao.FormShow(Sender: TObject);
begin
  pegaDados;
  pegaProdutos;

end;

procedure TformConsMovimentacao.PegaDados;
var
  calculaTotais : integer;

begin
  calculaTotais := 0;

  if QuotedStr(DateToStr(e_data_inicial.Date)) > QuotedStr(DateToStr(e_data_final.Date)) then
  begin
    ShowMessage('A data inicial não pode ser maior que a data final ');
    exit;
  end;

  begin
  with quConsMov do
  begin
    close;
    SQL.Text:= 'select * from movimentacoes' +
    ' where data_hora between ' + QuotedStr(DateToStr(e_data_inicial.Date) + ' 0:0:0' ) + ' and ' +
    QuotedStr(DateToStr(e_data_final.Date) + ' 23:59:59' );
    open;
    end;
    txt_total_movimentacoes.Caption := inttostr(quConsMov.RecordCount);  // retorna no caption da label a contagem de registros da QuConsMov
  end;
end;

procedure TformConsMovimentacao.PegaProdutos;

begin
  with quConsMovProd do
  begin
    Close;
    SQL.Text:= 'select * from movimentacoes_produtos' +
    ' where id_movimentacao =' + QuotedStr(quConsMov.FieldByName('id').AsString);
    Open;
  end;
    txt_total_produtos.Caption := IntToStr(quConsMovProd.RecordCount);
end;

end.
