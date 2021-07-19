unit unitCadUsuario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ComCtrls, Vcl.ToolWin,
  System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Data.Win.ADODB,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TformCadastroUsuario = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    e_login: TEdit;
    DBGrid1: TDBGrid;
    e_senha: TEdit;
    DS: TDataSource;
    quUsuarios: TADOQuery;
    ActionList1: TActionList;
    ImageList1: TImageList;
    btn_salvar: TAction;
    btn_editar: TAction;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    Panel1: TPanel;
    quUsuariosusuario: TStringField;
    quUsuariosid_cargo: TIntegerField;
    Label3: TLabel;
    cb_cargo: TComboBox;
    procedure pegaDados;
    procedure pegaProdutos;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TUsrItens = class
    id: string;
  end;

var
  formCadastroUsuario: TformCadastroUsuario;

implementation

{$R *.dfm}

uses unitDM;

procedure TformCadastroUsuario.pegaDados;
begin

  with quUsuarios do
  begin
    close;
    SQL.Text:= 'select usuario, id_cargo from usuarios' ;
    open;
  end;

end;

procedure TformCadastroUsuario.FormShow(Sender: TObject);
begin
  pegaProdutos;
  pegaDados;
end;

procedure TformCadastroUsuario.pegaProdutos;   // procedure para listar os colaboradores no cb_tipo_fornecedor
var
  iditem: TUsrItens;
begin
  cb_cargo.Clear;
  with quUsuarios do
  begin
    close;
    SQL.Text:= 'select id, descricao from cargo';
    open;
    while not eof do
    begin
      iditem:= TUsrItens.Create;
      iditem.id:= FieldByName('ID').AsString;   // bloco de cod para fazer listar os produtos(nomes) no cb
      cb_cargo.AddItem(FieldByName('descricao').AsString, iditem);
      next;
    end;
  end;
end;

end.
