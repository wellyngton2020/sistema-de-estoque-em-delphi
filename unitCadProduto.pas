unit unitCadProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.ComCtrls, Vcl.ToolWin, System.ImageList, Vcl.ImgList, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Data.Win.ADODB;

type
  TformCadProdutos = class(TForm)
    ActionList1: TActionList;
    btn_fechar: TAction;
    btn_excluir: TAction;
    btn_editar: TAction;
    btn_salvar: TAction;
    ImageList1: TImageList;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton5: TToolButton;
    e_fabricante: TEdit;
    e_quantidade_estoque: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    dbgrid: TDBGrid;
    quCadProd: TADOQuery;
    DS: TDataSource;
    e_nome: TEdit;
    quCadProdid: TAutoIncField;
    quCadProdnome: TStringField;
    quCadProdfabricante: TStringField;
    quCadProdvalidade: TDateTimeField;
    quCadProdestoque_atual: TIntegerField;
    dt_validade: TDateTimePicker;
    novo: TToolButton;
    btn_new: TAction;
    btn_inativar: TAction;
    ToolButton4: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    btn_ativar: TAction;
    pageControl: TPageControl;
    tab_produtos: TTabSheet;
    tab_ativar_inativar: TTabSheet;
    CoolBar2: TCoolBar;
    ToolBar2: TToolBar;
    ToolButton10: TToolButton;
    DS2: TDataSource;
    DBGrid1: TDBGrid;
    quAtivarDesativar: TADOQuery;
    quAtivarDesativarid: TAutoIncField;
    quAtivarDesativarnome: TStringField;
    procedure btn_fecharExecute(Sender: TObject);
    procedure btn_salvarExecute(Sender: TObject);
    procedure pegaDados;
    procedure limpaCampos;
    procedure ativar_desativar;
    procedure FormShow(Sender: TObject);
    procedure btn_editarExecute(Sender: TObject);
    procedure btn_excluirExecute(Sender: TObject);
    procedure dbgridCellClick(Column: TColumn);
    procedure btn_newExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_inativarExecute(Sender: TObject);
    procedure btn_ativarExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    id:string;
  end;

var
  formCadProdutos: TformCadProdutos;

implementation

{$R *.dfm}

uses unitDM;

procedure TformCadProdutos.btn_newExecute(Sender: TObject);
begin
  //Ativar os text's
   e_nome.Enabled := True;
   e_fabricante.Enabled := True;
   e_fabricante.Enabled := True;
   dt_validade.Enabled := True;
   LimpaCampos;
end;

procedure TformCadProdutos.btn_ativarExecute(Sender: TObject);
begin

  id:= quAtivarDesativarid.AsString;

  with quAtivarDesativar do
  begin
     if Application.MessageBox('Tem certeza que deseja ativar o produto?',
      'Confirmação', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = IDYES then
       begin
          close;
          SQL.Text := 'update produtos set status =' + QuotedStr('ATIVO') +
          ' where id = ' + id;
          execSQL;
       end;
  end;

  pegaDados;
  ativar_desativar;

end;

procedure TformCadProdutos.btn_editarExecute(Sender: TObject);
begin
   //Ativar os text's
   e_nome.Enabled := True;
   e_fabricante.Enabled := True;
   e_fabricante.Enabled := True;
   dt_validade.Enabled := True;
   //Trazer os campos da tabela nos Text's
   id:= quCadProdid.AsString; // conforme o id que estiver setado na dbgrid1 ele traz nos campos as informaçoes
   e_nome.Text := quCadProdNome.AsString;
   e_fabricante.Text := quCadProdfabricante.AsString;
   e_quantidade_estoque.Text := quCadProdestoque_atual.AsString;
end;

procedure TformCadProdutos.btn_excluirExecute(Sender: TObject);
begin
  if quCadProd.FieldByName('id').AsString = '' then   // para pegar a coluna especificada(id) da query
  begin
    ShowMessage('A tabela está vazia');
    exit; // exit para parar o processo se entrar nesta condição.
    end;

  if e_quantidade_estoque.Text > ('0') then
  begin
    //ShowMessage('Este produto ainda contém estoque. Não é possivel fazer a exclusão!');
    Application.MessageBox('Este produto ainda contém no estoque. Faça a baixa do produto para fazer a exclusão!','Alerta', MB_ICONHAND + MB_OK + MB_SYSTEMMODAL);
    exit;
  end;

  with DM.qu do
    begin
      if Application.MessageBox('Tem certeza que deseja excluir o registro selecionado?',
      'Confirmação', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = IDYES then
          begin
            close;
            SQL.Text:='delete produtos' +
            ' where id =' + quCadProd.FieldByName('id').AsString; // para pegar o campo id selecionado na qu Cad produtos
            ExecSQL;
            limpaCampos;
            pegaDados;
          end;
    end;
end;

procedure TformCadProdutos.btn_fecharExecute(Sender: TObject);
begin
    limpaCampos;
    close;
end;

procedure TformCadProdutos.btn_inativarExecute(Sender: TObject);
begin

  id:= quCadProdid.AsString;

  if quCadProdestoque_atual.Value > 0 then
  begin
    ShowMessage('Não é possivel inativar produtos que ainda tenha unidades no estoque. Favor zerar o estoque!!');
    exit;
  end;

  if Application.MessageBox('Tem certeza que deseja excluir o registro selecionado?',
  'Confirmação', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = IDYES then
  with quCadProd do
  begin
    close;
    SQL.Text := 'update produtos set status =' + QuotedStr('INATIVO') +
    ' where id = ' + id;
    execSQL;
  end;

  pegaDados;
  ativar_desativar;

end;


procedure TformCadProdutos.btn_salvarExecute(Sender: TObject);
begin
    if e_nome.Text = '' then
      begin
      ShowMessage('Por favor preencher o campo Nome!!');
      exit;
      end;

    if e_fabricante.Text = '' then
    begin
      ShowMessage('Por favor preencher o campo Fabricante!!');
      exit;
    end;

    if e_nome.Enabled = False then
    begin
      ShowMessage('Não há nada para ser salvo');
      exit;
    end;

    if e_fabricante.Enabled = False then
    begin
      ShowMessage('Não há nada para ser salvo');
      exit;
    end;

     if dt_validade.Enabled = False then
    begin
      ShowMessage('Não há nada para ser salvo');
      exit;
    end;

    with DM.qu do
      begin
        close;
        if id <> '' then
          begin
            SQL.Text:= 'upadate produtos set nome = ' + QuotedStr(e_nome.Text) + ',' + ' fabricante =' + QuotedStr(e_fabricante.Text) + ',' +
              ' validade =' + DateToStr(dt_validade.DateTime) + ',' + ' estoque_atual =' +  QuotedStr(e_quantidade_estoque.Text) +
              ' where id =' + id;
              ShowMessage('Informações alteradas com sucesso!');
          end
          else
          begin
            SQL.Text:= 'insert into produtos (nome, fabricante, validade, status) values( ' + QuotedStr(e_nome.Text) + ',' +
            QuotedStr(e_fabricante.Text) + ',' + QuotedStr(DateToStr(dt_validade.DateTime) + ' 0:0:0') + ',' + QuotedStr('ATIVO') + ')';
            ShowMessage('Produto Cadastrado com sucesso!!');
          end;
            ExecSQL;
      end;
            limpaCampos;
            pegaDados;
end;

procedure TformCadProdutos.dbgridCellClick(Column: TColumn);
begin
   //Desativar os text's
   e_nome.Enabled := False;
   e_fabricante.Enabled := False;
   e_fabricante.Enabled := False;
   dt_validade.Enabled := False;
   //Trazer nos campos as informacoes da Grid
   e_nome.Text := quCadProdNome.AsString;
   e_fabricante.Text := quCadProdfabricante.AsString;
   e_quantidade_estoque.Text := quCadProdestoque_atual.AsString;
end;

procedure TformCadProdutos.FormCreate(Sender: TObject);
begin
  dt_validade.Date := now;
end;

procedure TformCadProdutos.FormShow(Sender: TObject);
begin
   pageControl.TabIndex := 0;
   pegaDados;
   ativar_desativar;
end;

procedure TformCadProdutos.pegaDados;
begin
  with quCadProd do
    begin
      close;
      SQL.Text:= 'select id, nome, fabricante, validade, estoque_atual, status from produtos' +
      ' where status = ' + QuotedStr('ativo');
      open;
    end;
end;

procedure TformCadProdutos.limpaCampos;
begin
   e_nome.Text:='';
   e_fabricante.Text:='';
   e_quantidade_estoque.Text:='';
end;

procedure TformCadProdutos.ativar_desativar;
begin
  with quAtivarDesativar do
    begin
      close;
      SQL.Text:= 'select  id, nome from produtos' +
      ' where status = ' + QuotedStr('INATIVO');
      open;
    end;
end;

end.
