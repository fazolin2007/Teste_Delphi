unit UnPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Phys.MySQLDef,
  FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, Vcl.StdCtrls, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Vcl.Grids, Vcl.DBGrids, FireDAC.Comp.DataSet,
  Vcl.ComCtrls, Vcl.Buttons, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Mask,
  Vcl.WinXPickers, Vcl.NumberBox;

type
  TfrmPrincipal = class(TForm)
    dbgItens: TDBGrid;
    StatusBar: TStatusBar;
    Panel1: TPanel;
    DBNavigator1: TDBNavigator;
    Label1: TLabel;
    edCODPED: TDBEdit;
    Label2: TLabel;
    edCODCLI: TDBLookupComboBox;
    Label3: TLabel;
    edDATA_EMISSAO: TDBEdit;
    Label4: TLabel;
    edVL_TOTAL: TDBEdit;
    Panel2: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    bGravarItem: TButton;
    Label5: TLabel;
    edVL_UNIT: TNumberBox;
    edQTDE: TNumberBox;
    edCodProd: TNumberBox;
    edDescProd: TDBLookupComboBox;
    bCancelar: TButton;
    bGravarPedido: TButton;
    bExcluirPedido: TButton;
    SpeedButton1: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure edDescProdClick(Sender: TObject);
    procedure edCodProdChangeValue(Sender: TObject);
    procedure edQTDEChangeValue(Sender: TObject);
    procedure bGravarItemClick(Sender: TObject);
    procedure dbgItensKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure bCancelarClick(Sender: TObject);
    procedure dbgItensDblClick(Sender: TObject);
    procedure bGravarPedidoClick(Sender: TObject);
    procedure bExcluirPedidoClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Limpar_Itens;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses unDMPedidos;

procedure TfrmPrincipal.edCodProdChangeValue(Sender: TObject);
begin
  if edCodProd.ValueInt < 0 then
    edCodProd.Clear;

  edDescProd.KeyValue:= edCodProd.ValueInt;
end;

procedure TfrmPrincipal.edDescProdClick(Sender: TObject);
begin
  edCodProd.ValueInt:= edDescProd.KeyValue;
end;

procedure TfrmPrincipal.edQTDEChangeValue(Sender: TObject);
begin
  if edQTDE.ValueInt <= 0 then
    edQTDE.ValueInt:= 1;
end;

procedure TfrmPrincipal.Limpar_Itens;
begin
  edCodProd.Clear;
  edQTDE.Clear;
  edVL_UNIT.Clear;
end;

procedure TfrmPrincipal.SpeedButton1Click(Sender: TObject);
var sCodPed: string;
begin
  if (not (dmPedidos.qPedido_Itens.State in [dsInsert, dsEdit])) then
  begin
    if not InputQuery('Buscar Pedido','Informe o Número do Pedido:', sCodPed) then
      Exit;

    if (StrToIntDef(sCodPed, -1) > 0) then
    begin
      if not dmPedidos.qPedidos.Locate('CODIGO', StrToIntDef(sCodPed, -1), []) then
        ShowMessage('Número de Pedido não encontrado!');
    end
    else
      ShowMessage('Número de Pedido inválido!');
  end;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  Limpar_Itens;
end;

procedure TfrmPrincipal.bCancelarClick(Sender: TObject);
begin
  if dmPedidos.qPedido_Itens.State in [dsInsert, dsEdit] then
    dmPedidos.qPedido_Itens.Cancel;

  Limpar_Itens;
end;

procedure TfrmPrincipal.bGravarItemClick(Sender: TObject);
begin
  if edCodProd.ValueInt <= 0 then
  begin
    ShowMessage('Informe um produto!');
    Exit;
  end;

  if edQTDE.ValueInt <= 0 then
  begin
    ShowMessage('Informe a quantidade!');
    Exit;
  end;

  if edVL_UNIT.Value <= 0 then
  begin
    ShowMessage('Informe o Valor Unitário!');
    Exit;
  end;

  if dmPedidos.qPedidos.State in [dsInsert, dsEdit] then
  begin
    if dmPedidos.qPedidos.FieldByName('CODIGO').AsInteger <= 0 then
    begin
      dmPedidos.qPedidos.Post;
      dmPedidos.qPedidos.RefreshRecord;
      dmPedidos.qPedidos.Edit;
    end;

    try
      try
        with dmPedidos.qPedido_Itens do
        begin
          if State = dsBrowse then
            Append;

          if State in [dsInsert, dsEdit] then
          begin
            Post;
          end;
        end;
      Except
        on E: Exception do
          ShowMessage('Erro ao gravar Item: ' + E.Message );
      end;
    finally
      Limpar_Itens;
    end;
  end;
end;

procedure TfrmPrincipal.bGravarPedidoClick(Sender: TObject);
begin
  if dmPedidos.qPedidos.State in [dsInsert, dsEdit] then
    dmPedidos.qPedidos.Post;
end;

procedure TfrmPrincipal.bExcluirPedidoClick(Sender: TObject);
begin
  if not (dmPedidos.qPedidos.State in [dsInsert, dsEdit]) then
    dmPedidos.qPedidos.Delete;
end;

procedure TfrmPrincipal.dbgItensDblClick(Sender: TObject);
begin
  dmPedidos.qPedido_Itens.Append;
end;

procedure TfrmPrincipal.dbgItensKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if dmPedidos.qPedidos.State in [dsInsert, dsEdit] then
  begin
    if (dmPedidos.qPedido_Itens.RecordCount > 0) then
    begin
      if (key = 13) then
      begin
        dmPedidos.qPedido_Itens.Edit;
        edCodProd.SetFocus;
      end
      else
      if (key = VK_DELETE) then
        dmPedidos.qPedido_Itens.Delete;

    end;
  end;
end;

end.


