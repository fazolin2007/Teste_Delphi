unit unDMPedidos;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Phys.MySQLDef, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, IniFiles, Dialogs, Controls;

type
  TdmPedidos = class(TDataModule)
    MySQL_DriverLink: TFDPhysMySQLDriverLink;
    FDConn: TFDConnection;
    qClientes: TFDQuery;
    dsClientes: TDataSource;
    qProdutos: TFDQuery;
    dsProdutos: TDataSource;
    qPedidos: TFDQuery;
    dsPedidos: TDataSource;
    qPedido_Itens: TFDQuery;
    dsPedido_Itens: TDataSource;
    qPedido_ItensPRODUTO: TStringField;
    qPedido_ItensCODPROD: TIntegerField;
    qPedido_ItensCODPED: TIntegerField;
    qPedido_ItensQTDE: TIntegerField;
    qPedido_ItensVL_UNIT: TFloatField;
    qPedido_ItensVL_TOTAL: TFloatField;
    qPedido_ItensCODIGO: TFDAutoIncField;
    FDTransaction1: TFDTransaction;
    FDUpdateSQL_Pedidos: TFDUpdateSQL;
    FDUpdateSQL_Itens: TFDUpdateSQL;
    procedure DataModuleCreate(Sender: TObject);
    procedure dsPedido_ItensStateChange(Sender: TObject);
    procedure qPedido_ItensBeforePost(DataSet: TDataSet);
    procedure dsPedidosStateChange(Sender: TObject);
    procedure qPedido_ItensNewRecord(DataSet: TDataSet);
    procedure qPedido_ItensBeforeDelete(DataSet: TDataSet);
    procedure qPedidosBeforeDelete(DataSet: TDataSet);
    procedure qPedidosBeforePost(DataSet: TDataSet);
    procedure qPedidosAfterPost(DataSet: TDataSet);
    procedure qPedidosNewRecord(DataSet: TDataSet);
    procedure qPedidosDATASetText(Sender: TField; const Text: string);
    procedure qPedidosAfterCancel(DataSet: TDataSet);
    procedure qPedidosAfterScroll(DataSet: TDataSet);
    procedure qPedido_ItensAfterPost(DataSet: TDataSet);
    procedure qPedido_ItensAfterRefresh(DataSet: TDataSet);
    procedure qPedidosAfterDelete(DataSet: TDataSet);
  private
    procedure Atualizar_StatusBar;
    procedure Totalizar_Pedido;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmPedidos: TdmPedidos;
  ArquivoINI: TIniFile;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses UnPrincipal;

{$R *.dfm}

procedure TdmPedidos.DataModuleCreate(Sender: TObject);
begin
  dmPedidos.FDConn.Close;

  ArquivoINI:= TIniFile.Create('C:\Teste_Delphi\Database_Config.ini');

  if not LocaleFileExists('C:\Teste_Delphi\Database_Config.ini') then
  begin
    ArquivoINI.WriteString('CONFIG', 'HostName', '127.0.0.1');
    ArquivoINI.WriteString('CONFIG', 'Port', '3306');
    ArquivoINI.WriteString('CONFIG', 'Database', 'DB_TESTE');
    ArquivoINI.WriteString('CONFIG', 'User_Name', 'sa');
    ArquivoINI.WriteString('CONFIG', 'Password', '');
    ArquivoINI.WriteString('CONFIG', 'DLL_PATH', 'C:\Teste_Delphi\LIB\libmysql.dll');
  end;

  MySQL_DriverLink.VendorLib:= ArquivoINI.ReadString('CONFIG', 'DLL_PATH', 'C:\Teste_Delphi\LIB\libmysql.dll');
  FDConn.Params.Values['HostName']:= ArquivoINI.ReadString('CONFIG', 'HostName', '127.0.0.1');
  FDConn.Params.Values['Port']:= ArquivoINI.ReadString('CONFIG', 'Port', '3306');
  FDConn.Params.Values['Database']:= ArquivoINI.ReadString('CONFIG', 'Database', 'DB_TESTE');
  FDConn.Params.Values['User_Name']:= ArquivoINI.ReadString('CONFIG', 'User_Name', 'sa');
  FDConn.Params.Values['Password']:= ArquivoINI.ReadString('CONFIG', 'Password', '');

  ArquivoINI.Free;

  dmPedidos.FDConn.Open;

  qClientes.Open;
  qProdutos.Open;
  qPedidos.Open;
  qPedido_Itens.Open;

  TDateTimeField(qPedidos.FieldByName('DATA_EMISSAO')).EditMask:= '99/99/9999';
  TDateTimeField(qPedidos.FieldByName('DATA_EMISSAO')).OnSetText:= qPedidosDATASetText;
  TFloatField(qPedidos.FieldByName('VL_TOTAL')).Currency:= True;
end;

procedure TdmPedidos.qPedidosDATASetText(Sender: TField; const Text: string);
begin
  if StrToDateDef(Text, 0) > 0 then
    Sender.AsDateTime:= StrToDateDef(Text, 0)
  else
  begin
    ShowMessage('Data inválida, digite novamente!');
    Sender.Clear;
  end;
end;

procedure TdmPedidos.dsPedidosStateChange(Sender: TObject);
begin
  frmPrincipal.bGravarItem.Enabled:= (qPedidos.State in [dsInsert, dsEdit]);
  frmPrincipal.bCancelar.Enabled:= frmPrincipal.bGravarItem.Enabled;
  frmPrincipal.edCodProd.Enabled:= frmPrincipal.bGravarItem.Enabled;
  frmPrincipal.edDescProd.Enabled:= frmPrincipal.bGravarItem.Enabled;
  frmPrincipal.edQTDE.Enabled:= frmPrincipal.bGravarItem.Enabled;
  frmPrincipal.edVL_UNIT.Enabled:= frmPrincipal.bGravarItem.Enabled;

  if (qPedidos.State in [dsInsert, dsEdit]) then
     FDConn.Transaction.StartTransaction;
end;

procedure TdmPedidos.dsPedido_ItensStateChange(Sender: TObject);
begin
  if dsPedido_Itens.State = dsEdit then
  begin
    frmPrincipal.bGravarItem.Caption:= 'Alterar';
    frmPrincipal.edCodProd.Value:= qPedido_ItensCODPROD.AsInteger;
    frmPrincipal.edQTDE.Value:= qPedido_ItensQTDE.AsInteger;
    frmPrincipal.edVL_UNIT.Value:= qPedido_ItensVL_UNIT.AsInteger;
  end
  else
  if dsPedido_Itens.State <> dsInsert then
  begin
    frmPrincipal.bGravarItem.Caption:= 'Inserir';
    frmPrincipal.Limpar_Itens;
  end;
end;

procedure TdmPedidos.qPedidosAfterCancel(DataSet: TDataSet);
var iReg: integer;
begin
  FDConn.Transaction.RollbackRetaining;

  qPedidos.RefreshRecord;
  qPedido_Itens.Refresh;
end;

procedure TdmPedidos.qPedidosAfterDelete(DataSet: TDataSet);
begin
  try
    FDConn.Transaction.CommitRetaining;
    ShowMessage('Pedido cancelado!');
  except
     on E: Exception do
     begin
       FDConn.Transaction.RollbackRetaining;
       ShowMessage('Erro ao Cancelar Pedido: ' + E.Message );
     end;
  end;
end;

procedure TdmPedidos.qPedidosAfterPost(DataSet: TDataSet);
begin
  try
    FDConn.Transaction.CommitRetaining;
  except
     on E: Exception do
     begin
       FDConn.Transaction.RollbackRetaining;
       ShowMessage('Erro ao gravar Pedido e seus itens: ' + E.Message );
     end;
  end;
end;

procedure TdmPedidos.Atualizar_StatusBar;
begin
  frmPrincipal.StatusBar.SimpleText:= 'Valor Total do Pedido: R$' + FormatFloat('#,0.00;(,0.00)', qPedidos.FieldByName('VL_TOTAL').AsFloat);
end;

procedure TdmPedidos.qPedidosAfterScroll(DataSet: TDataSet);
begin
  Atualizar_StatusBar;
end;

procedure TdmPedidos.qPedidosBeforeDelete(DataSet: TDataSet);
begin
  if MessageDlg('Tem certeza que deseja cancelar esse Pedido?', mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then
    Abort;

  FDConn.Transaction.StartTransaction;
  with qPedido_Itens do
  begin
     try
       qPedido_Itens.Tag:= 99;
       DisableControls;
       First;
       while not Eof do
          Delete;

       try
          FDConn.Transaction.CommitRetaining;
       except
           on E: Exception do
           begin
             FDConn.Transaction.RollbackRetaining;
             ShowMessage('Erro ao Cancelar Itens do Pedido: ' + E.Message );
           end;
       end;

     finally
       EnableControls;
       qPedido_Itens.Tag:= 0;
     end;
  end;
end;

procedure TdmPedidos.Totalizar_Pedido;
begin
  try
    qPedido_Itens.DisableControls;
    qPedidos.FieldByName('VL_TOTAL').AsFloat:= 0;

    qPedido_Itens.First;
    while not qPedido_Itens.Eof do
    begin
      qPedidos.FieldByName('VL_TOTAL').AsFloat:= qPedidos.FieldByName('VL_TOTAL').AsFloat + qPedido_ItensVL_TOTAL.AsFloat;

      qPedido_Itens.Next;
    end;
    Atualizar_StatusBar;
  finally
    qPedido_Itens.First;
    qPedido_Itens.EnableControls;
  end;
end;

procedure TdmPedidos.qPedidosBeforePost(DataSet: TDataSet);
begin
  if qPedidos.FieldByName('CODCLI').AsInteger <= 0 then
  begin
    ShowMessage('Informe um cliente!');
    Abort;
  end;

  if qPedidos.FieldByName('DATA_EMISSAO').AsDateTime <= 0 then
  begin
    ShowMessage('Informe a data de emissão!');
    Abort;
  end;

  Totalizar_Pedido;
end;

procedure TdmPedidos.qPedidosNewRecord(DataSet: TDataSet);
begin
  qPedidos.FieldByName('DATA_EMISSAO').AsDatetime:= Date;
end;

procedure TdmPedidos.qPedido_ItensAfterPost(DataSet: TDataSet);
begin
  Totalizar_Pedido;
end;

procedure TdmPedidos.qPedido_ItensAfterRefresh(DataSet: TDataSet);
begin
  if qPedido_Itens.Tag = 0 then
    Atualizar_StatusBar;
end;

procedure TdmPedidos.qPedido_ItensBeforeDelete(DataSet: TDataSet);
begin
  if qPedido_Itens.Tag = 0 then
    if MessageDlg('Tem certeza que deseja excluir esse item?', mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo then
      Abort;
end;

procedure TdmPedidos.qPedido_ItensBeforePost(DataSet: TDataSet);
begin
  qPedido_ItensCODPROD.AsInteger:= frmPrincipal.edCodProd.ValueInt;
  qPedido_ItensQTDE.AsInteger:= frmPrincipal.edQTDE.ValueInt;
  qPedido_ItensVL_UNIT.AsFloat:= frmPrincipal.edVL_UNIT.Value;
  qPedido_ItensVL_TOTAL.AsFloat:= frmPrincipal.edVL_UNIT.Value * frmPrincipal.edQTDE.ValueInt;
end;

procedure TdmPedidos.qPedido_ItensNewRecord(DataSet: TDataSet);
begin
  qPedido_ItensCODPED.AsInteger:= qPedidos.FieldByName('CODIGO').AsInteger;
end;

end.
