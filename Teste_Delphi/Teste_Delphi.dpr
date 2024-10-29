program Teste_Delphi;

uses
  Vcl.Forms,
  UnPrincipal in 'UnPrincipal.pas' {frmPrincipal},
  unDMPedidos in 'unDMPedidos.pas' {dmPedidos: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Cadastro de Pedidos';
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TdmPedidos, dmPedidos);
  Application.Run;
end.
