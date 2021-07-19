unit unitCadMovimentacao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.ComCtrls, Vcl.ToolWin, Vcl.StdCtrls, System.Actions, Vcl.ActnList,
  System.ImageList, Vcl.ImgList, Data.Win.ADODB;

type
  TformCadMovimentacao = class(TForm)
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ActionList1: TActionList;
    ImageList1: TImageList;
    btn_fechar: TAction;
    btn_editar: TAction;
    btn_excluir: TAction;
    btn_salvar: TAction;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    e_responsavel: TEdit;
    m_obs: TMemo;
    cb_tipo_movimentacao: TComboBox;
    DBGrid1: TDBGrid;
    dt_data_hora: TDateTimePicker;
    quCadMov: TADOQuery;
    quCadMovid: TAutoIncField;
    quCadMovtipo: TStringField;
    quCadMovdata_hora: TDateTimeField;
    quCadMovresponsavel: TStringField;
    quCadMovobs: TStringField;
    quCadMovstatus: TStringField;
    dsCadMov: TDataSource;
    btn_cad_prod_movimentacao: TButton;
    procedure btn_fecharExecute(Sender: TObject);
    procedure btn_salvarExecute(Sender: TObject);
    procedure pegaDados;
    procedure limpaCampos;
    procedure FormShow(Sender: TObject);
    procedure btn_editarExecute(Sender: TObject);
    procedure btn_excluirExecute(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure btn_cad_prod_movimentacaoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    id:string;
  end;
  TUsrItens = class
    id: string;
  end;
var
  formCadMovimentacao: TformCadMovimentacao;

implementation

{$R *.dfm}

uses unitDM, unitCadProdutoMov, unitConsMovimentacao;

procedure TformCadMovimentacao.btn_cad_prod_movimentacaoClick(Sender: TObject);
begin
  formCadProdutoMov.idMovimentacao:=quCadMovid.AsInteger;  // para enviar o id selecionado para o formCadProdutoMov
  formCadProdutoMov.ShowModal;
end;

procedure TformCadMovimentacao.btn_editarExecute(Sender: TObject);
begin
  id:= quCadMovID.AsString; // conforme o id que estiver setado na dbgrid1 ele traz nos campos as informaçoes
  cb_tipo_movimentacao.ItemIndex:= cb_tipo_movimentacao.Items.IndexOf(quCadMovtipo.AsString);  // sempre usar quando for trazer do banco para a tela
  e_responsavel.Text:= quCadMovresponsavel.AsString;
  m_obs.Text:= quCadMovobs.AsString;
  pegaDados;
end;

procedure TformCadMovimentacao.btn_excluirExecute(Sender: TObject);
begin
  if quCadMov.FieldByName('id').AsString = '' then   // para pegar a coluna especificada(id) da query
  begin
    ShowMessage('A tabela está vazia');
    exit; // exit para parar o processo se entrar nesta condição.
  end;

  if Application.MessageBox('Tem certeza que deseja excluir o registro selecionado?',
  'Confirmação', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = IDYES then
  begin
    with DM.qu do
  begin
    close;
    SQL.Text:= 'select * from movimentacoes_produtos' +
    ' where id_movimentacao = ' + quCadMov.FieldByName('id').AsString;
    open;
  if FieldByName('id').AsString <> '' then
  begin
    ShowMessage('Existem produtos nesta movimentação. Favor exclui-los!');
    exit;
  end
  else
    with DM.qu do
    begin
     close;
     SQL.Text:= 'delete movimentacoes' +
     ' where id =' + quCadMov.FieldByName('id').AsString;
     ExecSQL;
     pegaDados;
  end;
  end;
  end;
end;


procedure TformCadMovimentacao.btn_fecharExecute(Sender: TObject);
begin
  close;
end;

procedure TformCadMovimentacao.btn_salvarExecute(Sender: TObject);
begin
  if cb_tipo_movimentacao.ItemIndex = -1 then
  begin
    ShowMessage('Escolha o Tipo da Movimentação!!');
    exit;
  end;
  if e_responsavel.Text = '' then
  begin
    ShowMessage('Preencha o campo Responsavel!!');
    exit;
  end;

  with DM.qu do
    begin
      close;
        if id <> '' then
          begin
            SQL.Text:='update movimentacoes set tipo = ' + QuotedStr(cb_tipo_movimentacao.Text) + ',' +
            'responsavel =' + QuotedStr(e_responsavel.Text) + ',' + 'obs =' + QuotedStr(m_obs.Text) +
            'where id = ' + id;
            ShowMessage('Registro ' + id + ' editado com sucesso!!');
          end
          else
          begin
            SQL.Text:= 'insert into movimentacoes (tipo, data_hora, responsavel, obs, status) values (' +
            QuotedStr(cb_tipo_movimentacao.Text) + ',' + QuotedStr(DateToStr(dt_data_hora.DateTime)) + ',' +
            QuotedStr(e_responsavel.Text) + ',' + QuotedStr(m_obs.Text) + ',' + QuotedStr('Ativo') + ')';
            ShowMessage('Cadastro feito com sucesso!!' + id);
          end;
      ExecSQL;

    end;
  limpaCampos;
  pegaDados;

end;

procedure TformCadMovimentacao.DBGrid1DblClick(Sender: TObject);
begin
  formCadProdutoMov.idMovimentacao:=quCadMovid.AsInteger; // para enviar o id selecionado da qu para o form seguinte.
  formCadProdutoMov.showModal;
end;

procedure TformCadMovimentacao.FormCreate(Sender: TObject);
begin
  dt_data_hora.Date := now;
  m_obs.Text := '';
end;

procedure TformCadMovimentacao.FormShow(Sender: TObject);
begin
  //pegaProdutos;
  pegaDados;
end;

procedure TformCadMovimentacao.pegaDados;
begin
  with quCadMov do
  begin
    close;
    SQL.Text:= 'select  id, tipo, data_hora, responsavel, obs, status from movimentacoes' +
    ' where status = ' + QuotedStr('Ativo');
    Open;
  end;
end;

procedure TformCadMovimentacao.limpaCampos;
begin
  cb_tipo_movimentacao.ItemIndex :=  -1;
  e_responsavel.Clear;
  m_obs.Clear;
end;

end.
