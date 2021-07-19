unit unitPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls;

type
  TformPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    Sistema1: TMenuItem;
    Sair1: TMenuItem;
    Cadastros1: TMenuItem;
    Cadastrodeproduto1: TMenuItem;
    Movimentaes1: TMenuItem;
    GerenciarMovimentaes1: TMenuItem;
    ConsultarMovimentaes1: TMenuItem;
    ConsultarMovimentaesdeProdutos1: TMenuItem;
    Image1: TImage;
    Relatórios: TMenuItem;
    Cadastrodeusuarios1: TMenuItem;
    procedure Sair1Click(Sender: TObject);
    procedure Cadastrodeproduto1Click(Sender: TObject);
    procedure GerenciarMovimentaes1Click(Sender: TObject);
    procedure ConsultarMovimentaes1Click(Sender: TObject);
    procedure ConsultarMovimentaesdeProdutos1Click(Sender: TObject);
    procedure Cadastrodeusuarios1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formPrincipal: TformPrincipal;

implementation

{$R *.dfm}

uses unitCadProduto, unitCadMovimentacao, unitConsMovimentacao, unitDM,
  unitConsMovimentacaoProdutos, unitCadUsuario;

procedure TformPrincipal.Cadastrodeproduto1Click(Sender: TObject);
begin
   formCadProdutos.ShowModal;
end;

procedure TformPrincipal.Cadastrodeusuarios1Click(Sender: TObject);
begin
  formCadastroUsuario.ShowModal;
end;

procedure TformPrincipal.ConsultarMovimentaes1Click(Sender: TObject);
begin
  formConsMovimentacao.ShowModal;
end;

procedure TformPrincipal.ConsultarMovimentaesdeProdutos1Click(Sender: TObject);
begin
  formConsMovimentacaopProdutos.ShowModal;
end;

procedure TformPrincipal.GerenciarMovimentaes1Click(Sender: TObject);
begin
  formCadMovimentacao.ShowModal;
end;

procedure TformPrincipal.Sair1Click(Sender: TObject);
begin
  close;
end;

end.
