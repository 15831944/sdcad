unit login;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, dialogs, Controls, StdCtrls, 
  Buttons, ExtCtrls,Inifiles;

type
  TLoginForm = class(TForm)
    lblUserName: TLabel;
    lblPass: TLabel;
    lblServerName: TLabel;
    Label1: TLabel;
    edtUserName: TEdit;
    edtPassword: TEdit;
    edtServerName: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    edtPort: TEdit;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtUserNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure edtPasswordKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoginForm: TLoginForm;

implementation

uses public_unit, MainDM, main;

{$R *.dfm}
procedure getLastOpenedPrj;
var
  ini_file:TInifile;
  strProjectNo: string;
  aPrj_no,aPrj_name,aPrj_name_en,aPrj_type: string;
begin

    //��server.ini�ļ��б���򿪵Ĺ��̱��,�´δ򿪴˴���ʱֱ�Ӷ�λ���˹���.  
    ini_file := TInifile.Create(g_AppInfo.PathOfIniFile);
    try
      strProjectNo := ini_file.ReadString('project','no','');
      with MainDataModule.qryProjects do
        begin
          close;
          sql.Clear;
          sql.Add('select prj_no,prj_name,prj_name_en,prj_type from projects');
          sql.Add(' where prj_no=' + ''''+stringReplace(strProjectNo,'''','''''',[rfReplaceAll])+''''); 
          open;
      
          if not Eof then
          begin 
            aprj_no  := strProjectNo;
            aprj_name:= FieldByName('prj_name').AsString;
            aPrj_name_en:= FieldByName('prj_name_en').AsString;
            if FieldByName('prj_type').AsString<>'' then
            begin
               if FieldByName('prj_type').AsBoolean  then
                   aprj_type := '1'
               else
                   aprj_type := '0'
            end
        else
            aprj_type := '0';
          end;
          close;
        end;
      g_ProjectInfo.setProjectInfo(aPrj_no,aPrj_name,aPrj_name_en,aPrj_type);
      if g_ProjectInfo.prj_no<>'' then 
        MainForm.StatusBar1.Panels[0].Text := '��ǰ���̣���ţ�'
          + g_ProjectInfo.prj_no + ' ; ���ƣ�'
          + g_ProjectInfo.prj_name + ';';
    finally
      ini_file.Free;
    end;
end;
procedure TLoginForm.btnOkClick(Sender: TObject);
var 
  strErrorConn: string;
  ini_file:TInifile;
begin
  if trim(edtServerName.Text)='' then
  begin
    Messagebox(self.Handle,'�����������ݿ���������ƻ�IP��ַ��','ϵͳ��ʾ',MB_OK+MB_ICONINFORMATION);
    edtServerName.SetFocus;
    exit;
  end;
  if trim(edtPort.Text)='' then
  begin
    Messagebox(self.Handle,'�����������ݿ�˿ںš�','ϵͳ��ʾ',MB_OK+MB_ICONINFORMATION);
    edtPort.SetFocus;
    exit;
  end;
  if trim(edtUserName.Text)='' then
  begin
    Messagebox(self.Handle,'���������û�����','ϵͳ��ʾ',MB_OK+MB_ICONINFORMATION);
    edtUserName.SetFocus;
    exit;
  end;
  Screen.Cursor := crHourGlass;
  try
    strErrorConn:=MainDataModule.Connect_Database
      (trim(edtServerName.Text),trim(edtPort.Text),trim(edtUserName.Text) ,trim(edtPassword.Text)); 
    if strErrorConn<>'' then
    begin
    showmessage(strErrorConn);
    exit;
    end;
    getLastOpenedPrj;
  finally
    Screen.Cursor := crDefault;
  end;

  ini_file := TInifile.Create(g_AppInfo.PathOfIniFile);
  ini_file.WriteString('server','name',trim(edtServerName.Text));
  ini_file.WriteString('server','port',trim(edtPort.Text));
  ini_file.Free;
    
  self.ModalResult := mrOk;   
end;

procedure TLoginForm.btnCancelClick(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TLoginForm.edtUserNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  change_focus(key,self);
end;

procedure TLoginForm.FormCreate(Sender: TObject);
var 
  ini_file:TInifile;
begin
  if fileexists(g_AppInfo.PathOfIniFile) then
  begin
    ini_file := TInifile.Create(g_AppInfo.PathOfIniFile);
    edtServerName.Text := ini_file.ReadString('server','name','');
    edtPort.Text := ini_file.ReadString('server','port','');
    ini_file.Free;
  end;  
end;

procedure TLoginForm.edtPasswordKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then
    btnOK.Click;
end;

end.
