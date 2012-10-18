unit ChengZaiLiTeZhengZhi;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, ExtCtrls, DB, ADODB,
  FR_DSet, FR_DBSet, FR_Class;

type
  TChengZaiLiTeZhengZhiForm = class(TForm)
    qryCZLTZZ: TADOQuery;
    DataSource1: TDataSource;
    frReport1: TfrReport;
    frDBDataset1: TfrDBDataset;
    Panel2: TPanel;
    Shape1: TShape;
    Label33: TLabel;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    Shape10: TShape;
    Shape11: TShape;
    Shape12: TShape;
    Shape13: TShape;
    Shape14: TShape;
    Shape15: TShape;
    Shape17: TShape;
    Shape18: TShape;
    Shape19: TShape;
    Shape20: TShape;
    Shape21: TShape;
    Shape22: TShape;
    Shape23: TShape;
    Shape24: TShape;
    Shape25: TShape;
    Shape26: TShape;
    Shape27: TShape;
    Shape28: TShape;
    Shape29: TShape;
    Shape30: TShape;
    Shape16: TShape;
    Label1: TLabel;
    Shape39: TShape;
    Shape40: TShape;
    Shape41: TShape;
    Shape43: TShape;
    Shape44: TShape;
    Shape45: TShape;
    Shape47: TShape;
    Shape48: TShape;
    Shape49: TShape;
    Label2: TLabel;
    Shape31: TShape;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label27: TLabel;
    Label43: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label24: TLabel;
    Label49: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Shape32: TShape;
    Shape33: TShape;
    Shape34: TShape;
    Shape35: TShape;
    Shape36: TShape;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    sgSample: TStringGrid;
    edtnjl_xishu: TEdit;
    edtnjl_pjz: TEdit;
    edtnjl_bzz: TEdit;
    edtmcj_xishu: TEdit;
    edtmcj_pjz: TEdit;
    edtmcj_bzz: TEdit;
    edtspt_xishu: TEdit;
    edtspt_gcxzz: TEdit;
    edtspt_bzz: TEdit;
    edtcpt_xishu: TEdit;
    edtcpt_pjz: TEdit;
    edtcpt_bzz: TEdit;
    edtfak_kjqd: TEdit;
    edtfak_spt: TEdit;
    edtfak_cpt: TEdit;
    edtfak_czljyz: TEdit;
    edtfak_zhqdz: TEdit;
    edtczlbzz_hntyzz: TEdit;
    edtczlbzz_sxzkz: TEdit;
    edtczlbzz_cggzz: TEdit;
    edtczlbzz_gzyzkz: TEdit;
    edtdzlbzz_hntyzz: TEdit;
    edtdzlbzz_szzkz: TEdit;
    edtdzlbzz_cggzz: TEdit;
    edtdzlbzz_gzyzkz: TEdit;
    btnCkfak: TButton;
    Panel3: TPanel;
    btn_edit: TBitBtn;
    btn_ok: TBitBtn;
    btn_rebuild: TBitBtn;
    btn_cancel: TBitBtn;
    btn_Print: TBitBtn;
    procedure btn_cancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure sgSampleSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btn_editClick(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure btn_rebuildClick(Sender: TObject);
    procedure edtnjl_xishuKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtnjl_xishuKeyPress(Sender: TObject; var Key: Char);
    procedure edtnjl_xishuChange(Sender: TObject);
    procedure btn_PrintClick(Sender: TObject);
    procedure btnCkfakClick(Sender: TObject);
  private
    { Private declarations }
    procedure button_status(int_status:integer;bHaveRecord:boolean);
    procedure Get_oneRecord(aProjectNo: string;aStra_no: string;aSub_no:string);
    procedure SelectFromTable;
    procedure CalaculateData;
    function GetUpdateSQL:string;
    function Check_Data:boolean;
  public
    { Public declarations }
  end;
type TChengZaiLiXiShu=record
  Mb: double;
  Md: double;
  Mc: double;
end;
var
  ChengZaiLiTeZhengZhiForm: TChengZaiLiTeZhengZhiForm;
  m_DataSetState: TDataSetState;
  
implementation

uses MainDM, public_unit, SdCadMath, Preview, Ck_fak;

{$R *.dfm}

procedure TChengZaiLiTeZhengZhiForm.btn_cancelClick(Sender: TObject);
begin
  self.Close;
end;

procedure TChengZaiLiTeZhengZhiForm.button_status(int_status: integer;
  bHaveRecord: boolean);
begin
  case int_status of
    1: //���״̬
      begin
        btn_edit.Enabled :=bHaveRecord;
        btn_print.Enabled := bHaveRecord;
        btnCkfak.Enabled := false;
        btn_edit.Caption :='�޸�';
        btn_ok.Enabled :=false;
        btn_rebuild.Enabled :=true;
        Enable_Components(self,false);
        m_DataSetState := dsBrowse;
      end;
    2: //�޸�״̬
      begin
        btn_edit.Enabled :=true;
        btn_print.Enabled :=false;
        btn_edit.Caption :='����';
        btn_ok.Enabled :=true;
        btnCkfak.Enabled := true;
        btn_rebuild.Enabled :=false;
        Enable_Components(self,true);
        m_DataSetState := dsEdit;
      end;
  end;

end;

procedure TChengZaiLiTeZhengZhiForm.CalaculateData;
begin
  //������������׼ֵ
  edtnjl_bzz.Text := '';
  if isFloat(trim(edtnjl_xishu.Text)) and isFloat(trim(edtnjl_pjz.Text)) then
    edtnjl_bzz.Text := FormatFloat('0.00', StrToFloat(edtnjl_xishu.Text) * StrToFloat(edtnjl_pjz.Text));

  //����Ħ���Ǳ�׼ֵ
  edtmcj_bzz.Text := '';
  if isFloat(trim(edtmcj_xishu.Text)) and isFloat(trim(edtmcj_pjz.Text)) then
    edtmcj_bzz.Text := FormatFloat('0.00', StrToFloat(edtmcj_xishu.Text) * StrToFloat(edtmcj_pjz.Text));

  //�����������׼ֵ
  edtspt_bzz.Text := '';
  if isFloat(trim(edtspt_xishu.Text)) and isFloat(trim(edtspt_gcxzz.Text)) then
  begin
    edtspt_bzz.Text := FormatFloat('0', StrToFloat(edtspt_xishu.Text) * StrToFloat(edtspt_gcxzz.Text));
    edtfak_spt.Text := FormatFloat('0',strtoint(edtspt_bzz.Text));
  end;
  //���㾲����̽��׼ֵ
  edtcpt_bzz.Text := '';
  if isFloat(trim(edtcpt_xishu.Text)) and isFloat(trim(edtcpt_pjz.Text)) then
  begin
    edtcpt_bzz.Text := FormatFloat('0.0', StrToFloat(edtcpt_xishu.Text) * StrToFloat(edtcpt_pjz.Text));
  end; 
  //���� 
end;

function TChengZaiLiTeZhengZhiForm.Check_Data: boolean;
begin
  result:= true;
end;

procedure TChengZaiLiTeZhengZhiForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TChengZaiLiTeZhengZhiForm.Get_oneRecord(aProjectNo, aStra_no,
  aSub_no: string);
var 
  strFieldName, strSub_No: string;
  i:integer;
  myComponent: TComponent;
begin
  if trim(aProjectNo)='' then exit;
  if trim(aStra_no)='' then exit;
  if trim(aSub_no)='' then exit;
  strSub_No := stringReplace(trim(aSub_no),'''','''''',[rfReplaceAll]);
  with MainDataModule.qryPublic do
    begin
      close;
      sql.Clear;
      sql.Add('SELECT * from chengzailiTeZhengZhi');
      sql.Add(' where prj_no=' + ''''+stringReplace(aProjectNo ,'''','''''',[rfReplaceAll])+'''');
      sql.Add(' AND stra_no=' +''''+aStra_no+''''); 
      sql.Add(' AND sub_no=' +''''+strSub_No+''''); 
      open;
      
      while not Eof do
      begin 
        strFieldName:='';
        for i:=0 to self.ComponentCount-1 do
        begin
          myComponent:= self.Components[i]; 
          if myComponent is TEdit then
          begin
            strFieldName:= copy(myComponent.Name,4,length(myComponent.Name)-3);
            TEdit(myComponent).Text := FieldByName(strFieldName).AsString;
          end;     
        end;
        next;
      end;
      close;
    end;

end;

function TChengZaiLiTeZhengZhiForm.GetUpdateSQL: string;
var 
  strSQLWhere,strSQLSet,strSQL:string;
  strFieldName: string;
  i:integer;
begin
  strSQLWhere:=' WHERE prj_no='+''''+g_ProjectInfo.prj_no_ForSQL+''''
           +' AND stra_no =' +''''+ sgSample.Cells[1,sgSample.Row]+''''
           +' AND sub_no='  +''''+stringReplace(sgSample.Cells[4,sgSample.Row],'''','''''',[rfReplaceAll])+'''';
  strSQLSet:='UPDATE chengzailiTeZhengZhi SET ';
  strFieldName:='';
  strSQL:='';
  for i:=0 to self.ComponentCount-1 do
  begin
    if Components[i] is TEdit then
    begin
      strFieldName := copy(Components[i].Name,4,length(Components[i].Name)-3);
      if trim(TEdit(Components[i]).Text)<>'' then        
        strSQLSet := strSQLSet + strFieldName+'='+''''+trim(TEdit(Components[i]).Text)+''''+','
      else
        strSQLSet := strSQLSet + strFieldName+'= NULL'+',';
    end;
  end;
  strSQLSet := strSQLSet + ' prj_no' +'='+''''+g_ProjectInfo.prj_no_ForSQL+'''';
  strSQL := strSQLSet+strSQLWhere;
  result := strSQL; 
end;



procedure TChengZaiLiTeZhengZhiForm.FormCreate(Sender: TObject);
begin

  self.Left := trunc((screen.Width -self.Width)/2);
  self.Top  := trunc((Screen.Height - self.Height)/2);

  sgSample.ColCount := 4;
  sgSample.RowHeights[0] := 16;
  sgSample.Cells[1,0] := '����';
  sgSample.Cells[2,0] := '�ǲ�';  
  sgSample.Cells[3,0] := '��������';

  sgSample.ColWidths[0]:=10;
  sgSample.ColWidths[1]:=30;
  sgSample.ColWidths[2]:=30;
  sgSample.ColWidths[3]:=150;
  m_DataSetState := dsBrowse;

  SelectFromTable;
end;

procedure TChengZaiLiTeZhengZhiForm.sgSampleSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  if TStringGrid(Sender).Tag = 1 then exit; //����Tag����Ϊÿ�θ�StringGrid��ֵ���ᴥ������SelectCell�¼���Ϊ�˱������������
                         //��SelectCell�¼�����Tagֵ���ж��Ƿ�Ӧ��ִ����SelectCell�еĲ���.   
  
  if (ARow <>0) and (ARow<>TStringGrid(Sender).Row) then
  begin
    if sgSample.Cells[1,ARow]<>'' then
    begin
      Get_oneRecord(g_ProjectInfo.prj_no_ForSQL,sgSample.Cells[1,ARow],
        sgSample.Cells[4,ARow]);
      if sgSample.Cells[1,ARow]='' then
        Button_status(1,false)
      else
        Button_status(1,true);
    end
    else
      clear_data(self);
  end;
end;

procedure TChengZaiLiTeZhengZhiForm.btn_editClick(Sender: TObject);
begin
  if btn_edit.Caption ='�޸�' then
  begin  
    Button_status(2,true);
    edtnjl_xishu.SetFocus;
  end
  else
  begin
    clear_data(self);
    Button_status(1,true);
    Get_oneRecord(g_ProjectInfo.prj_no,sgSample.Cells[1,sgSample.Row],
        sgSample.Cells[4,sgSample.Row]);
  end;
end;

procedure TChengZaiLiTeZhengZhiForm.btn_okClick(Sender: TObject);
var
  strSQL: string;
  isSavedOk: boolean; 
begin
  isSavedOk := false;
  if not Check_Data then exit;

  if m_DataSetState = dsEdit then
    begin
      strSQL := self.GetUpdateSQL;
      if Update_oneRecord(MainDataModule.qryPublic,strSQL) then
        begin
          isSavedOk := true;
        end;      
    end;
  if isSavedOk then
  begin
    Button_status(1,true);
  end;

end;

//����Ħ���ǵ�ֵ�ڳ�����ϵ������ȡ��ϵ��Mb,Md,Mc
procedure GetChengZaiLiXiShu(aMocajiao:double;var pChengZaiLiXiShu: TChengZaiLiXiShu);
var
  iNum: integer;
  Angle0,Angle1,Mb0,Mb1,Md0,Md1,Mc0,Mc1,tmpAngle,tmpMb,tmpMd,tmpMc: double;
begin
  tmpMb:=0;
  tmpMd:=0;
  tmpMc:=0;
  Angle0:=0;
  Mb0:=0;
  Md0:=0;
  Mc0:=0;
  with MainDataModule.qryPublic do
  begin
    close;
    sql.Clear;
    sql.Add('SELECT angle_value,mb,md,mc FROM ChengZaiLiXiShu');
    open;
    iNum:= 0;
    while not eof do
    begin
      inc(iNum);
      tmpAngle:= FieldbyName('angle_value').AsInteger;
      tmpMb:= FieldbyName('mb').AsFloat;
      tmpMd:= FieldbyName('md').AsFloat;
      tmpMc:= FieldbyName('mc').AsFloat;
      if aMocajiao= tmpAngle then
      begin
        pChengZaiLiXiShu.Mb := tmpMb;
        pChengZaiLiXiShu.Md := tmpMd;
        pChengZaiLiXiShu.Mc := tmpMc;
        close;
        exit;
      end;
      if iNum=1 then 
        begin
          Angle0:= tmpAngle;
          Mb0:= tmpMb;
          Md0:= tmpMd;
          Mc0:= tmpMc;
          if aMocajiao < Angle0 then
          begin
            pChengZaiLiXiShu.Mb := tmpMb;
            pChengZaiLiXiShu.Md := tmpMd;
            pChengZaiLiXiShu.Mc := tmpMc;
            close;
            exit;
          end;
        end
      else //else iNum<>1,�������ǵ�һ�ʼ�¼��
        begin
          if (aMocajiao<tmpAngle) then
            begin
              Angle1:= tmpAngle;
              Mb1:= tmpMb;
              Md1:= tmpMd;
              Mc1:= tmpMc;
              pChengZaiLiXiShu.Mb := StrToFloat(formatfloat('0.00',XianXingChaZhi(Angle0, Mb0, Angle1, Mb1, aMocajiao)));
              pChengZaiLiXiShu.Md := StrToFloat(formatfloat('0.00',XianXingChaZhi(Angle0, Md0, Angle1, Md1, aMocajiao)));
              pChengZaiLiXiShu.Mc := StrToFloat(formatfloat('0.00',XianXingChaZhi(Angle0, Mc0, Angle1, Mc1, aMocajiao)));
              close;
              exit;
            end
          else
            begin
              Angle0:= tmpAngle;
              Mb0:= tmpMb;
              Md0:= tmpMd;
              Mc0:= tmpMc;
            end;
        end; 
      next;
    end;
    close;
  end;
  pChengZaiLiXiShu.Mb := tmpMb;
  pChengZaiLiXiShu.Md := tmpMd;
  pChengZaiLiXiShu.Mc := tmpMc;  
end;

function InitChengZaiLiTable:boolean;
var
  strSQL: string;
  spt_xishu, //�������ͳ������ϵ��
  spt_byxs,   //����������ϵ��
  spt_ybz,    //�����������ֵ
  cpt_xishu,  //������̽ͳ������ϵ��
  cpt_bzz,    //������̽��׼ֵ
  cpt_pjz,    //������̽ƽ��ֵ
  cpt_byxs,   //������̽����ϵ��
  cpt_ybz,    //������̽����ֵ
  njl_xishu, //������ͳ������ϵ��
  njl_bzz,   //��������׼ֵ
  njl_pjz,   //������ƽ��ֵ
  njl_byxs,  //����������ϵ��
  njl_ybz,   //����������ֵ
  mcj_xishu, //Ħ����ͳ������ϵ��
  mcj_bzz,  //Ħ���Ǳ�׼ֵ
  mcj_pjz,   //Ħ����ƽ��ֵ
  mcj_byxs,  //Ħ���Ǳ���ϵ��
  mcj_ybz: double; //Ħ��������ֵ
   
  ChengZaiLiXiShu: TChengZaiLiXiShu; //������ϵ��(Mb,Md,Mc)

  spt_bzz,   //��������׼ֵ
  spt_gcxzz,//�������˳�����ֵ 
  shape_index,  //����ָ��
  TuZhongDu,        //�����������������ضȣ�����ˮλ����ȡ���ضȡ�
  TuJQPJZD: double; //���������������ļ�Ȩƽ���ضȣ�����ˮλ����ȡ���ضȡ�
  fak_kjqd,      //����������ֵ����ǿ�ȼ���ֵ
  fak_spt,       //����������ֵ������ȷ��ֵ
  fak_cpt,       //����������ֵ��̽��ʽ����ֵ
  czlbzz_hntyzz, //׮�ļ��޲�������׼ֵ��������Ԥ��׮��
  czlbzz_sxzkz,  //׮�ļ��޲�������׼ֵ��ˮ�����׮��
  czlbzz_cggzz,  //׮�ļ��޲�������׼ֵ�����ܹ�ע׮��
  czlbzz_gzyzkz, //׮�ļ��޲�������׼ֵ������ҵ���׮��
  dzlbzz_hntyzz, //׮�ļ��޶�������׼ֵ��������Ԥ��׮��
  dzlbzz_szzkz,  //׮�ļ��޶�������׼ֵ��ˮ�����׮��
  dzlbzz_cggzz,  //׮�ļ��޶�������׼ֵ�����ܹ�ע׮��
  dzlbzz_gzyzkz : Integer;  //׮�ļ��޶�������׼ֵ������ҵ���׮��
  
  //���㿹��ǿ��ָ��Ħ���Ǻ�ճ������ͳ������ϵ����aByxs:����ϵ�� aYbz:����ֵ
  function CalculateTongJiXiuZhengXiShu(aByxs: double; aYbz: double): double;
  begin
//yys 2006/12/27 edit
//    if (aByxs=0) or (aYbz=0) then
    if (aByxs<=0) or (aYbz<=0) then
//yys 2006/12/27 edit
    begin
      result:= 0;
      exit;
    end;
    result := 1 - (1.704 / sqrt(aYbz) + 4.678 / sqr(aYbz)) * aByxs;
  end;
begin
  //��ʼ�ӳ���������ֵ��ɾ����ǰ���̵ļ�¼
  strSQL:= 'DELETE FROM chengzailiTeZhengZhi '
    +' WHERE prj_no= '+''''+g_ProjectInfo.prj_no_ForSQL+'''';
  if not Delete_oneRecord(MainDataModule.qryPublic,strSQL) then
  begin
    result:= false;
    exit;
  end;

  //��ʼ������������ȡ�����в��������������������ǿ���е���������Ħ���ǵ�ƽ��ֵ��
  //�������ĸ˳�����ֵ��������̽��ƽ��ֵ�������뵽����������ֵ���С�
  strSQL:= 'SELECT pjz.stra_no,pjz.sub_no,pjz.cohesion as cohesionpjz,'
    +'pjz.friction_angle as friction_anglepjz,'
    +'pjz.spt_amend_num as spt_amend_numpjz,pjz.cpt_qc as cpt_qcpjz,'
    +'pjz.shape_index as shape_indexpjz,'
    +'byxs.cohesion as cohesionbyxs,byxs.friction_angle as friction_anglebyxs,'
    +'byxs.spt_amend_num as spt_amend_numbyxs,byxs.cpt_qc as cpt_qcbyxs,'
    +'ybz.cohesion as cohesionybz,ybz.friction_angle as friction_angleybz,'
    +'ybz.spt_amend_num as spt_amend_numybz,ybz.cpt_qc as cpt_qcybz '
    +' FROM '
    +' (SELECT stra_no,sub_no,cohesion,friction_angle,spt_amend_num,cpt_qc,'
         +'shape_index FROM TeZhengShuTmp'
         +' WHERE v_id=1 '
         +' AND prj_no='+''''+g_ProjectInfo.prj_no_ForSQL+''''
         +')  pjz INNER JOIN '
    +' (SELECT stra_no,sub_no,cohesion,friction_angle,spt_amend_num,cpt_qc'
         +' FROM TeZhengShuTmp WHERE v_id=3'
         +' AND prj_no='+''''+g_ProjectInfo.prj_no_ForSQL+''''
         +') byxs ON pjz.stra_no = byxs.stra_no AND pjz.sub_no = byxs.sub_no INNER JOIN '
    +' (SELECT stra_no,sub_no,cohesion,friction_angle,spt_amend_num,cpt_qc'
    +' FROM TeZhengShuTmp WHERE v_id=6'
    +' AND prj_no='+''''+g_ProjectInfo.prj_no_ForSQL+''''
    +') ybz ON pjz.stra_no = ybz.stra_no AND pjz.sub_no = ybz.sub_no ';
  with MainDataModule.qryEarthSample do
  begin
    close;
    sql.Clear;
    sql.Add(strSQL);
    Open;
    while not eof do
    begin
      //���㿹��ǿ��ָ��Ħ���Ǻ�ճ������ͳ������ϵ���ͱ�׼ֵ 
      njl_pjz   := FieldByName('cohesionpjz').AsFloat;
      njl_byxs  := FieldByName('cohesionbyxs').AsFloat;
      njl_ybz   := FieldByName('cohesionybz').AsFloat;
      njl_xishu := CalculateTongJiXiuZhengXiShu(njl_byxs, njl_ybz);
      njl_bzz   := StrToFloat(FormatFloat('0.0',njl_xishu * njl_pjz));

      mcj_pjz   := FieldByName('friction_anglepjz').AsFloat;
      mcj_byxs  := FieldByName('friction_anglebyxs').AsFloat;
      mcj_ybz   := FieldByName('friction_angleybz').AsFloat;
      mcj_xishu := CalculateTongJiXiuZhengXiShu(mcj_byxs, mcj_ybz);
      mcj_bzz   := StrToFloat(FormatFloat('0.0',mcj_xishu * mcj_pjz));

      GetChengZaiLiXiShu(mcj_bzz, ChengZaiLiXiShu);
      fak_kjqd :=0;//�˴���Ӧ���淶��8-11ҳ�Ĺ�ʽ���㣬�������ضȻ��ضȡ���Ȩƽ���ضȲ�֪��������õ���ֻ�������û����롣
      {fak_kjqd := strtoint(formatfloat('0',
        ChengZaiLiXiShu.Mb*TuZhongDu*3 +ChengZaiLiXiShu.Md*TuJQPJZD*0.5
        + ChengZaiLiXiShu.Mc*njl_bzz));}
      //�����������ͳ������ϵ���ͱ�׼ֵ���ɱ�����ȷ���ĳ���������ֵ
      spt_gcxzz := FieldByName('spt_amend_numpjz').AsInteger;
      spt_byxs  := FieldByName('spt_amend_numbyxs').AsFloat;
      spt_ybz   := FieldByName('spt_amend_numybz').AsFloat;
      spt_xishu := CalculateTongJiXiuZhengXiShu(spt_byxs, spt_ybz);
      spt_bzz   := StrToInt(FormatFloat('0',spt_xishu * spt_gcxzz));
      fak_spt := StrToInt(FormatFloat('0',spt_bzz * 15));
      //���㾲����̽��ͳ������ϵ���ͱ�׼ֵ���ɾ�����̽ȷ���ĳ���������ֵ
      cpt_pjz   := FieldByName('cpt_qcpjz').AsFloat;
      cpt_byxs  := FieldByName('cpt_qcbyxs').AsFloat;
      cpt_ybz   := FieldByName('cpt_qcybz').AsFloat;
      cpt_xishu := CalculateTongJiXiuZhengXiShu(cpt_byxs, cpt_ybz);
      cpt_bzz   := StrToFloat(FormatFloat('0.00',cpt_xishu * cpt_pjz));
      shape_index:=FieldByName('shape_indexpjz').AsFloat;
        //������ж�����ɰ��
      if shape_index>10 then  //ճ��      
        fak_cpt := StrToInt(FormatFloat('0',84 * cpt_pjz + 25))
      else //����
        fak_cpt := StrToInt(FormatFloat('0',20 * cpt_pjz + 50));
        
      strSQL:= 'INSERT INTO chengzailiTeZhengZhi ' 
        + '(prj_no,stra_no,sub_no,njl_xishu,njl_pjz,njl_bzz,'
        + 'mcj_xishu,mcj_pjz,mcj_bzz,spt_xishu,spt_gcxzz,spt_bzz,'
        + 'cpt_xishu,cpt_pjz,cpt_bzz,fak_kjqd,fak_spt,fak_cpt)'
        + ' VALUES('+''''+g_ProjectInfo.prj_no_ForSQL+''''+','+''''+FieldByName('stra_no').AsString+''''+',' 
        + ''''+stringReplace(FieldByName('sub_no').AsString,'''','''''',[rfReplaceAll]) +''''+ ',' 
        + FormatFloat('0.00',njl_xishu)+','+ FormatFloat('0.00',njl_pjz)+','+FormatFloat('0.00',njl_bzz)+','
        + FormatFloat('0.00',mcj_xishu)+','+ FormatFloat('0.00',mcj_pjz)+','+FormatFloat('0.00',mcj_bzz)+','
        + FormatFloat('0.00',spt_xishu)+','+ FormatFloat('0',spt_gcxzz)+','+FormatFloat('0',spt_bzz)+','
        + FormatFloat('0.00',cpt_xishu)+','+ FormatFloat('0.00',cpt_pjz)+','+FormatFloat('0.00',cpt_bzz)+','
        + FormatFloat('0',fak_kjqd)+','+ FormatFloat('0',fak_spt)+','+FormatFloat('0',fak_cpt)+ ')';
      Insert_oneRecord(MainDataModule.qryPublic,strSQL); 
      next;      
    end;
    close;
  end;

  result:= true;
end;
procedure TChengZaiLiTeZhengZhiForm.SelectFromTable;
var
  i: integer;
begin
  sgSample.RowCount := 2;  
  Clear_Data(self);
  //GetStratumsByDrillNo(aDrillNo);
  with MainDataModule.qryPublic do
    begin
      close;
      sql.Clear;
      sql.Add('SELECT c.prj_no,c.stra_no,c.sub_no,s.ea_name,s.id ');
      sql.Add(' FROM chengzailiTeZhengZhi c,stratum_description s');
      sql.Add(' WHERE c.prj_no='+''''+g_ProjectInfo.prj_no_ForSQL+'''');
      sql.Add(' AND c.prj_no=s.prj_no AND c.stra_no=s.stra_no AND c.sub_no=s.sub_no');
      sql.Add(' ORDER BY s.id');
      open;
      i:=0;
      sgSample.Tag := 1;
      while not Eof do
        begin
          i:=i+1;
          sgSample.RowCount := i +2;
          sgSample.Cells[1,i] := FieldByName('stra_no').AsString;
          if FieldByName('sub_no').AsString='0' then
            sgSample.Cells[2,i] := ''
          else
            sgSample.Cells[2,i] := FieldByName('sub_no').AsString;
          sgSample.Cells[3,i] := FieldByName('ea_name').AsString;
          sgSample.Cells[4,i] := FieldByName('sub_no').AsString;  
          sgSample.RowCount := i +1;
          Next ;
        end;
      close;
      sgSample.Tag :=0;
    end;
  if i>0 then
  begin
    Get_oneRecord(g_ProjectInfo.prj_no,sgSample.Cells[1,1],
      sgSample.Cells[4,1]);
    sgSample.Row :=1;
    button_status(1,true);
  end
  else
    button_status(1,false);
end;

procedure TChengZaiLiTeZhengZhiForm.btn_rebuildClick(Sender: TObject);
begin
  if InitChengZaiLiTable then
    SelectFromTable;
end;

procedure TChengZaiLiTeZhengZhiForm.edtnjl_xishuKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  change_focus(key,self);
end;

procedure TChengZaiLiTeZhengZhiForm.edtnjl_xishuKeyPress(Sender: TObject;
  var Key: Char);
var
  strHead,strEnd,strAll,strFraction:string;
  iDecimalSeparator:integer;
begin
  //�����������ֱ�����ε�С���㡣
  if (TEdit(Sender).Tag=0) and (key='.') then
  begin
    key:=#0;
    exit;
  end;
  
  //���ε���ѧ��������
  if (lowercase(key)='e') or (key=' ') then
  begin
    key:=#0;
    exit;
  end;

  if key =chr(vk_back) then exit;
  
  try
    strHead := copy(TEdit(Sender).Text,1,TEdit(Sender).SelStart);
    strEnd  := copy(TEdit(Sender).Text,TEdit(Sender).SelStart+TEdit(Sender).SelLength+1,length(TEdit(Sender).Text));
    strAll := strHead+key+strEnd;
    
    if (strAll)='-' then
      begin
         TEdit(Sender).Text :='-';
         TEdit(Sender).SelStart :=2;
         key:=#0;
         exit;
      end;
      
    strtofloat(strAll);
    iDecimalSeparator:= pos('.',strAll);
    if iDecimalSeparator>0 then
      begin
        strFraction:= copy(strall,iDecimalSeparator+1,length(strall));
        if (iDecimalSeparator>0) and (length(strFraction)>TEdit(Sender).Tag) then
          key:=#0;
      end;
  except
    key:=#0;
  end;
end;

procedure TChengZaiLiTeZhengZhiForm.edtnjl_xishuChange(Sender: TObject);
begin
  if (m_DataSetState = dsInsert) or (m_DataSetState = dsEdit) then
    CalaculateData;
end;

procedure TChengZaiLiTeZhengZhiForm.btn_PrintClick(Sender: TObject);
var 
  strSQL: string;
begin
  strSQL:= 'SELECT c.*,s.ea_name,s.id FROM chengzailiTeZhengZhi c,stratum_description s'
    +' Where c.prj_no='+''''+g_ProjectInfo.prj_no_ForSQL+''''
    +' AND c.prj_no=s.prj_no AND c.stra_no=s.stra_no AND c.sub_no=s.sub_no'
    +' ORDER BY s.id';
    with self.qryCZLTZZ do
    begin
      close;
      sql.Clear;
      sql.Add(strSQL);
      Open;   
    end;
  frReport1.LoadFromFile(g_AppInfo.PathOfReports + 'ChengZaiLiTeZhengZhi.frf');
  frReport1.Preview := PreviewForm.frPreview1;
  if frReport1.PrepareReport then
  begin
    frReport1.ShowPreparedReport;
    PreviewForm.ShowModal;
  end;  

  self.qryCZLTZZ.Close;

end;

procedure TChengZaiLiTeZhengZhiForm.btnCkfakClick(Sender: TObject);
var 
  Ck_fakForm: TCk_fakForm;
  ChengZaiLiXiShu: TChengZaiLiXiShu; //������ϵ��(Mb,Md,Mc)
begin
  if edtnjl_bzz.Text='' then
  begin
    MessageBox(application.Handle,'ճ������׼ֵ����Ϊ�ա�','��ʾ',MB_OK);
    edtnjl_bzz.SetFocus;
    exit;
  end;
  if edtmcj_bzz.Text='' then
  begin
    MessageBox(application.Handle,'Ħ���Ǳ�׼ֵ����Ϊ�ա�','��ʾ',MB_OK);
    edtmcj_bzz.SetFocus;
    exit;
  end;
  Ck_fakForm := TCk_fakForm.Create(self);
  try 
    ck_fakForm.ck := strtofloat(edtnjl_bzz.Text);
    GetChengZaiLiXiShu(strtofloat(edtmcj_bzz.Text), ChengZaiLiXiShu);
    ck_fakForm.mb := ChengZaiLiXiShu.Mb ;
    ck_fakForm.md := ChengZaiLiXiShu.Md ;
    ck_fakForm.mc := ChengZaiLiXiShu.Mc ;
    if Ck_fakForm.ShowModal = mrOk then
      edtfak_kjqd.Text := Ck_fakForm.edtFa.Text;
  finally
    Ck_fakForm.Free;
  end;
    
end;

end.
