program Estoque;

uses
  Vcl.Forms,
  unitPrincipal in 'unitPrincipal.pas' {formPrincipal},
  unitCadProduto in 'unitCadProduto.pas' {formCadProdutos},
  unitCadMovimentacao in 'unitCadMovimentacao.pas' {formCadMovimentacao},
  unitConsMovimentacao in 'unitConsMovimentacao.pas' {formConsMovimentacao},
  unitDM in 'unitDM.pas' {DM: TDataModule},
  unitCadProdutoMov in 'unitCadProdutoMov.pas' {formCadProdutoMov},
  unitConsMovimentacaoProdutos in 'unitConsMovimentacaoProdutos.pas' {formConsMovimentacaopProdutos},
  unitCadUsuario in 'unitCadUsuario.pas' {formCadastroUsuario};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TformPrincipal, formPrincipal);
  Application.CreateForm(TformCadProdutos, formCadProdutos);
  Application.CreateForm(TformCadMovimentacao, formCadMovimentacao);
  Application.CreateForm(TformConsMovimentacao, formConsMovimentacao);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TformCadProdutoMov, formCadProdutoMov);
  Application.CreateForm(TformConsMovimentacaopProdutos, formConsMovimentacaopProdutos);
  Application.CreateForm(TformCadastroUsuario, formCadastroUsuario);
  Application.Run;
end.
