unit uConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, IniFiles;

type
  TFConfig = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edServer: TEdit;
    edDatabase: TEdit;
    edPort: TEdit;
    edUser: TEdit;
    edPass: TEdit;
    bOK: TButton;
    bCancelar: TButton;
    Label6: TLabel;
    edDLL: TEdit;
    FileOpenDialog: TFileOpenDialog;
    bOpen: TBitBtn;
    procedure bCancelarClick(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure bOpenClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    procedure CarregarINI;
    procedure GravarINI;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FConfig: TFConfig;
  ArquivoINI: TIniFile;

implementation

{$R *.dfm}

procedure TFConfig.CarregarINI;
var sEXEPath: string;
begin
  sEXEPath:= ExtractFileDir(ParamStr(0));

  ArquivoINI:= TIniFile.Create(sEXEPath + '\Database_Config.ini');

  if not LocaleFileExists(sEXEPath + '\Database_Config.ini') then
  begin
    ArquivoINI.WriteString('CONFIG', 'HostName', '127.0.0.1');
    ArquivoINI.WriteString('CONFIG', 'Port', '3306');
    ArquivoINI.WriteString('CONFIG', 'Database', 'DB_TESTE');
    ArquivoINI.WriteString('CONFIG', 'User_Name', 'sa');
    ArquivoINI.WriteString('CONFIG', 'Password', '');
    ArquivoINI.WriteString('CONFIG', 'DLL_Path', sEXEPath + '\libmysql.dll');
  end;

  edServer.Text:= ArquivoINI.ReadString('CONFIG', 'HostName', '127.0.0.1');
  edDatabase.Text:= ArquivoINI.ReadString('CONFIG', 'Database', 'DB_TESTE');
  edPort.Text:= ArquivoINI.ReadString('CONFIG', 'Port', '3306');
  edUser.Text:= ArquivoINI.ReadString('CONFIG', 'User_Name', 'sa');
  edPass.Text:= ArquivoINI.ReadString('CONFIG', 'Password', '');
  edDLL.Text:= ArquivoINI.ReadString('CONFIG', 'DLL_Path', sEXEPath + '\libmysql.dll');

  ArquivoINI.Free;
end;

procedure TFConfig.GravarINI;
var sEXEPath: string;
begin
  sEXEPath:= ExtractFileDir(ParamStr(0));

  try
    ArquivoINI:= TIniFile.Create(sEXEPath + '\Database_Config.ini');
    ArquivoINI.WriteString('CONFIG', 'HostName' , edServer.Text);
    ArquivoINI.WriteString('CONFIG', 'Port'     , edPort.Text);
    ArquivoINI.WriteString('CONFIG', 'Database' , edDatabase.Text);
    ArquivoINI.WriteString('CONFIG', 'User_Name', edUser.Text);
    ArquivoINI.WriteString('CONFIG', 'Password' , edPass.Text);
    ArquivoINI.WriteString('CONFIG', 'DLL_Path' , edDLL.Text);

    Self.Tag:= mrOk;
    ArquivoINI.Free;
  except
    on E: Exception do
    begin
       ArquivoINI.Free;
       Self.Tag:= mrAbort;
       Application.MessageBox(PChar('Erro ao gravar arquivo INI: ' + #13 + E.Message), 'Arquivo INI');
    end;
  end;
end;

procedure TFConfig.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 13) then
  begin
    Key:= 0;
    if ssShift in Shift then
      Perform(WM_NEXTDLGCTL, 1, 0)
    else
      Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TFConfig.FormShow(Sender: TObject);
begin
  CarregarINI;
end;

procedure TFConfig.bOpenClick(Sender: TObject);
begin
  if FileOpenDialog.Execute then
    edDLL.Text:= FileOpenDialog.FileName;
end;

procedure TFConfig.bOKClick(Sender: TObject);
begin
  GravarINI;
  Close;
end;

procedure TFConfig.bCancelarClick(Sender: TObject);
begin
  Self.Tag:= mrCancel;
  Close;
end;

end.
