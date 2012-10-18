unit ZhuZhuangTu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TZhuZhuangTuForm = class(TForm)
    lblDrl_no: TLabel;
    lblDrl_no2: TLabel;
    cboDrl_no: TComboBox;
    btn_Print: TBitBtn;
    btn_ok: TBitBtn;
    btn_cancel: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtY_scale: TEdit;
    GroupBox2: TGroupBox;
    rbHor: TRadioButton;
    rbVer: TRadioButton;
    chkOnePage: TCheckBox;
    cboDrl_no2: TComboBox;
    chkZhiFangTu: TCheckBox;
    chkShuangDa: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure cboDrl_noChange(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure btn_PrintClick(Sender: TObject);
    procedure btn_cancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chkZhiFangTuClick(Sender: TObject);
    procedure chkShuangDaClick(Sender: TObject);
  private
    { Private declarations }
    procedure button_status(bHaveRecord:boolean);
    procedure Get_oneRecord(aProjectNo: string;aDrillNo: string);    
  public
    { Public declarations }
  end;

var
  ZhuZhuangTuForm: TZhuZhuangTuForm;

implementation

uses MainDM, public_unit;

{$R *.dfm}

procedure TZhuZhuangTuForm.button_status(bHaveRecord: boolean);
begin
  btn_Print.Enabled := bHaveRecord;
  btn_ok.Enabled := bHaveRecord;
end;

procedure TZhuZhuangTuForm.FormCreate(Sender: TObject);
var
  i: integer;
begin
  self.Left := trunc((screen.Width -self.Width)/2);
  self.Top  := trunc((Screen.Height - self.Height)/2);
  cboDrl_no.Clear;
  cboDrl_no2.Clear;

  Clear_Data(self);
  with MainDataModule.qryCPT do
    begin
      close;
      sql.Clear;
      //sql.Add('select prj_no,prj_name,area_name,builder,begin_date,end_date,consigner from projects');
      sql.Add('SELECT prj_no,drl_no');
      sql.Add(' FROM drills ');
      sql.Add(' WHERE prj_no='+''''+g_ProjectInfo.prj_no_ForSQL+'''');
      sql.Add(' AND d_T_no<>'+''''+g_ZKLXBianHao.DanQiao+'''');
      sql.Add(' AND d_T_no<>'+''''+g_ZKLXBianHao.ShuangQiao+'''');
      sql.Add(' AND d_T_no<>'+''''+g_ZKLXBianHao.XiaoZuanKong+''''); 
      open;
      i:=0;
      cboDrl_no2.Items.Add('');
      while not Eof do
        begin
          i:=i+1;
          cboDrl_no.Items.Add(FieldByName('drl_no').AsString);
          cboDrl_no2.Items.Add(FieldByName('drl_no').AsString);
          Next ;
        end;
      close;
    end;
  if i>0 then
  begin    
    //Get_oneRecord(g_ProjectInfo.prj_no, cboDrl_no.Text); 
    button_status(true);
  end
  else
    button_status(false);

    
end;

procedure TZhuZhuangTuForm.Get_oneRecord(aProjectNo, aDrillNo: string);
var
  strTmpScale: string;
begin
  if trim(aProjectNo)='' then exit;
  if trim(aDrillNo)='' then exit;
  strTmpScale := edtY_scale.Text;
  with MainDataModule.qryDrills do
    begin
      close;
      sql.Clear;
      sql.Add('SELECT y_scale from drills');
      sql.Add(' where prj_no=' + ''''+stringReplace(aProjectNo ,'''','''''',[rfReplaceAll])+'''');
      sql.Add(' AND drl_no=' +''''+stringReplace(aDrillNo ,'''','''''',[rfReplaceAll])+'''');  
      open;
      if not Eof then
      begin
        edtY_scale.Text := FieldByName('Y_scale').AsString;
      end;
      if edtY_scale.Text='' then
         edtY_scale.Text := strTmpScale;


      close;
    end;
end;

procedure TZhuZhuangTuForm.cboDrl_noChange(Sender: TObject);
var
  drl_no: string;
begin
  drl_no:= trim(cboDrl_no.Text);
  if drl_no ='' then
  begin
    button_status(false);
    exit;
  end;
  Get_oneRecord(g_ProjectInfo.prj_no,drl_no);
end;

procedure TZhuZhuangTuForm.btn_okClick(Sender: TObject);
var
  strSQL: string;
begin
  strSQL:= 'UPDATE drills SET y_scale=' + edtY_scale.Text  
    + ' WHERE prj_no='+''''+g_ProjectInfo.prj_no_ForSQL+''''
    + ' AND drl_no =' +''''+ stringReplace(cboDrl_no.Text ,'''','''''',[rfReplaceAll])+'''';
  Update_onerecord(MainDataModule.qryDrills, strSQL);

end;

procedure TZhuZhuangTuForm.btn_PrintClick(Sender: TObject);
var 

  drl_no , strSQL, strTmp, strFileName, strExecute: string;
  strStra_no, strStra_deep, strStra_thickness,strStra_elev, strEa_name,strStra_fao,strStra_qik : string;
  i,DrlCount,iCount: integer;
  dDrl_elev, preStra_depth, nowStra_depth: double;
  FileList, DescList: TStringList;
  function GetFieldValue(aFormatStr: string; aFieldValue: string):string;
  begin
    if aFieldValue='' then
    begin
      result:=' ';
      exit;
    end
    else
      result:= FormatFloat(aFormatStr, StrToFloat(aFieldValue));
  end;
  function GetShearType(aShearType: String): String;
  begin
    if aShearType='' then
    begin
      result:=' ';
      exit;
    end;
    case StrToInt(aShearType) of
      -1: result:='';
      0:  result:='��';
      1:  result:='��';
      2:  result:='��'
      else result:='';
    end;
  end;
begin
  FileList := TStringList.Create;
  DescList := TStringList.Create;
  strFileName:= g_AppInfo.PathOfChartFile + 'ZhuZhuangTu.ini';
  drl_no:= trim(cboDrl_no.Text);
  if drl_no='' then exit;
  dDrl_elev:=0;
  try
    FileList.Add('[ͼֽ��Ϣ]');
    FileList.Add('�������ļ���=��״ͼ' + trim(cboDrl_no.Text));
    FileList.Add('ͼֽ����=�����״ͼ');
    FileList.Add('���̱��='+g_ProjectInfo.prj_no);
    if g_ProjectInfo.prj_ReportLanguage= trChineseReport then
      FileList.Add('��������='+g_ProjectInfo.prj_name)
    else if g_ProjectInfo.prj_ReportLanguage= trEnglishReport then
      FileList.Add('��������='+g_ProjectInfo.prj_name_en) ;
    FileList.Add('��������='+g_ProjectInfo.prj_type);

    FileList.Add('[������]');
    FileList.Add('Y=' + edtY_scale.Text);
    if chkOnePage.Checked then
      FileList.Add('һҳ��ӡ=0') //��ӡ��һҳ�ϣ�����ҳ
    else
      FileList.Add('һҳ��ӡ=1'); //��ʵ��ҳ����ӡ

    if rbVer.Checked then
      FileList.Add('��ӡ����=0') //�����ӡ
    else
      FileList.Add('��ӡ����=1'); //�����ӡ

    DrlCount := 1;
    if trim(cboDrl_no2.Text) <>'' then  DrlCount :=2;

    for iCount := 1 to DrlCount do    // Iterate
    begin
        if iCount=1 then
        begin
            FileList.Add('[���]');
            drl_no := trim(cboDrl_no.Text);
        end
        else
        begin
            FileList.Add('[���2]');
            drl_no := trim(cboDrl_no2.Text);
        end;
        strSQL:= 'SELECT * '
          +'FROM drills '
          +'WHERE prj_no = '+''''+g_ProjectInfo.prj_no_ForSQL+''''
          +' AND drl_no = '+''''+drl_no +'''';
        with MainDataModule.qryDrills do
          begin
            close;
            sql.Clear;
            sql.Add(strSQL);
            Open;
            While not eof do
            begin
              FileList.Add('���='+drl_no);
              FileList.Add('�׿ڱ��='+FieldByName('drl_elev').AsString);
              dDrl_elev:= FieldByName('drl_elev').AsFloat; 
              FileList.Add('����='+FieldByName('comp_depth').AsString);
              FileList.Add('�׿�����X='+FieldByName('drl_x').AsString);
              FileList.Add('�׿�����Y='+FieldByName('drl_y').AsString);
              FileList.Add('��������='+FieldByName('begin_date').AsString);
              FileList.Add('�깤����='+FieldByName('end_date').AsString);
              if FieldByName('d_t_no').AsString= JiZuanQuTuKong then //����ȡ����
              begin
                FileList.Add('���׮��=' + FieldByName('drl_lczh').AsString);
              end;
              if FieldByName('first_elev').AsString<>'' then
              begin
                FileList.Add('����ˮλ='
                  +FormatFloat('0.00',FieldByName('first_elev').AsFloat)
                  +'/'+FormatFloat('0.00',FieldByName('drl_elev').AsFloat
                  -FieldByName('first_elev').AsFloat)+'��m��');
              end;
              if FieldByName('stable_elev').AsString<>'' then
              begin
                FileList.Add('�ȶ�ˮλ='
                  +FormatFloat('0.00',FieldByName('stable_elev').AsFloat)
                  +'/'+FormatFloat('0.00',FieldByName('drl_elev').AsFloat
                  -FieldByName('stable_elev').AsFloat)+'��m��');
              end;

              if FieldByName('wcy_first_elev').AsString<>'' then
              begin
                FileList.Add('΢��ѹ����ˮλ='
                  +FormatFloat('0.00',FieldByName('wcy_first_elev').AsFloat)
                  +'/'+FormatFloat('0.00',FieldByName('drl_elev').AsFloat
                  -FieldByName('wcy_first_elev').AsFloat)+'��m��');
              end;
              if FieldByName('wcy_stable_elev').AsString<>'' then
              begin
                FileList.Add('΢��ѹ�ȶ�ˮλ='
                  +FormatFloat('0.00',FieldByName('wcy_stable_elev').AsFloat)
                  +'/'+FormatFloat('0.00',FieldByName('drl_elev').AsFloat
                  -FieldByName('wcy_stable_elev').AsFloat)+'��m��');
              end;
              next;
            end;
            close;
          end;

        drl_no := stringReplace(drl_no ,'''','''''',[rfReplaceAll]);
        //��ʼ������׵�������Ϣ��
        strSQL:='SELECT st.*,ISNULL(ea.ea_name_en,'''') as ea_name_en  '
           +'FROM stratum st,earthtype ea'
           +' WHERE st.prj_no=' +''''+g_ProjectInfo.prj_no_ForSQL +''''
           +' AND st.drl_no='  +''''+stringReplace(drl_no,'''','''''',[rfReplaceAll])+''''
           +' AND st.ea_name = ea.ea_name '
           +' ORDER BY st.stra_depth';
        strStra_no := '���=';
        strStra_deep:= '������=';
        strStra_thickness:= '���=';
        strStra_elev:='��ױ��=';
        strEa_name:= '�������=';
        strStra_fao:= 'fao=';
        strStra_qik:= 'qik=';
        DescList.Clear;
        with MainDataModule.qryStratum do
          begin
            close;
            sql.Clear;
            sql.Add(strSQL);
            open;
            preStra_depth:=0;
            while not Eof do
              begin
                strStra_no := strStra_no + FieldByName('stra_no').AsString ;
                if (FieldByName('sub_no').AsString) <> '0' then
                  strStra_no:= strStra_no + '-' + FieldByName('sub_no').AsString;
                strStra_no := strStra_no + ',';
                nowStra_depth:= FieldByName('stra_depth').AsFloat;
                strStra_elev:= strStra_elev + FormatFloat('0.00',dDrl_elev - nowStra_depth) + ',';
                strStra_deep := strStra_deep 
                  + FormatFloat('0.00',nowStra_depth)+ ',';

                if FieldByName('stra_fao').AsString='0' then
                  strStra_fao := strStra_fao + ','
                else
                  strStra_fao := strStra_fao + FieldByName('stra_fao').AsString + ',';
                if FieldByName('Stra_qik').AsString='0' then
                  strStra_qik := strStra_qik + ','
                else
                strStra_qik := strStra_qik + FieldByName('stra_qik').AsString + ',';

                strStra_thickness:= strStra_thickness
                  + FormatFloat('0.00',nowStra_depth -preStra_depth) + ',';
                preStra_depth := nowStra_depth;
                if g_ProjectInfo.prj_ReportLanguage= trChineseReport then
                  begin
                    strEa_name := strEa_name + FieldByName('ea_name').AsString +',';
                    DescList.Add(FieldByName('description').AsString);
                  end
                else if g_ProjectInfo.prj_ReportLanguage= trEnglishReport then
                  begin
                    strEa_name := strEa_name + FieldByName('ea_name').AsString
                      +REPORT_PRINT_SPLIT_CHAR+FieldByName('ea_name_en').AsString +',';
                    DescList.Add(FieldByName('description_en').AsString);
                  end;
                Next ;
              end;
            close;
          end;
        if copy(strStra_no,length(strStra_no),1)=',' then
          strStra_no:= copy(strStra_no,1,length(strStra_no)-1);
        FileList.Add(strStra_no);

        if copy(strStra_deep,length(strStra_no),1)=',' then
          strStra_deep:= copy(strStra_deep,1,length(strStra_deep)-1);
        FileList.Add(strStra_deep);

        if copy(strStra_thickness,length(strStra_thickness),1)=',' then
          strStra_thickness:= copy(strStra_thickness,1,length(strStra_thickness)-1);      
        FileList.Add(strStra_thickness);

        if copy(strStra_elev,length(strStra_elev),1)=',' then
          strStra_elev:= copy(strStra_elev,1,length(strStra_elev)-1);      
        FileList.Add(strStra_elev);

        if copy(strEa_name,length(strEa_name),1)=',' then
          strEa_name:= copy(strEa_name,1,length(strEa_name)-1);
        FileList.Add(strEa_name);

        if copy(strStra_fao,length(strStra_fao),1)=',' then
          strStra_fao:= copy(strStra_fao,1,length(strStra_fao)-1);
        FileList.Add(strStra_fao);

        if copy(strStra_qik,length(strStra_qik),1)=',' then
          strStra_qik:= copy(strStra_qik,1,length(strStra_qik)-1);
        FileList.Add(strStra_qik);

        //��ʼ������������
        if iCount=1 then
        begin
            FileList.Add('[��������]');
        end
        else
        begin
            FileList.Add('[��������2]');
        end;

        for i:=0 to DescList.Count-1 do
          FileList.Add(IntToStr(i+1)+'='
            +Stringreplace(DescList.Strings[i],#13#10,'@',[rfReplaceAll]));
        //��ʼ����������Ϣ
        if iCount=1 then
        begin
            FileList.Add('[����]');
        end
        else
        begin
            FileList.Add('[����2]');
        end;
        strSQL:= 'SELECT * FROM earthsample '
          +' WHERE prj_no=' +''''+g_ProjectInfo.prj_no_ForSQL +''''
          +' AND drl_no='  +''''+stringReplace(drl_no,'''','''''',[rfReplaceAll])+'''' + ' ORDER BY s_depth_begin';
        with MainDataModule.qryEarthSample do
        begin
          close;
          sql.Clear;
          sql.Add(strSQL);
          Open;
          i:=0;
          while not eof do
          begin
            Inc(i);
            FileList.Add(IntToStr(i)+'='+FieldByName('s_no').AsString+ ','
              + FormatFloat('0.00',FieldByName('s_depth_begin').AsFloat)+','
              + FormatFloat('0.00',FieldByName('s_depth_end').AsFloat)+','
              + GetFieldValue('0.0',FieldByName('aquiferous_rate').AsString)+','
              + GetFieldValue('0.00',FieldByName('wet_density').AsString)+','
              + GetFieldValue('0.00',FieldByName('dry_density').AsString)+','
              + GetFieldValue('0.00',FieldByName('soil_proportion').AsString)+','
              + GetFieldValue('0.000',FieldByName('gap_rate').AsString)+','
              + GetFieldValue('0',FieldByName('gap_degree').AsString)+','
              + GetFieldValue('0',FieldByName('saturation').AsString)+','
              + GetFieldValue('0.0',FieldByName('liquid_limit').AsString)+','
              + GetFieldValue('0.0',FieldByName('shape_limit').AsString)+','
              + GetFieldValue('0.0',FieldByName('shape_index').AsString)+','
              + GetFieldValue('0.00',FieldByName('liquid_index').AsString)+','
              + GetFieldValue('0.000',FieldByName('zip_coef').AsString)+','
              + GetFieldValue('0.00',FieldByName('zip_modulus').AsString)+','
              + GetFieldValue('0.00',FieldByName('cohesion').AsString)+','
              + GetFieldValue('0.00',FieldByName('friction_angle').AsString)+','
    //yys 20040610 modified       
              //+ GetShearType(FieldByName('shear_type').AsString) + ','
              + GetFieldValue('0.00',FieldByName('cohesion_gk').AsString)+','
              + GetFieldValue('0.00',FieldByName('friction_gk').AsString)+','          
    //yys 20040610 modified           
              + GetFieldValue('0.0',FieldByName('sand_big').AsString)+','
              + GetFieldValue('0.0',FieldByName('sand_middle').AsString)+','
              + GetFieldValue('0.0',FieldByName('sand_small').AsString)+','
              + GetFieldValue('0.0',FieldByName('powder_big').AsString)+','
              + GetFieldValue('0.0',FieldByName('powder_small').AsString)+','
              + GetFieldValue('0.0',FieldByName('clay_grain').AsString) );
            next;
          end;
          close;
          FileList.Add('����='+IntToStr(i));
        end;
        //��ʼ����ԭλ���Ի���/����
        if iCount=1 then
        begin
            FileList.Add('[ԭλ���Ի���]');
        end
        else
        begin
            FileList.Add('[ԭλ���Ի���2]');
        end;
        //��׼��������
        strSQL:='SELECT prj_no,drl_no,begin_depth,end_depth,'
          +'real_num1+real_num2+real_num3 as real_num '
          +' FROM SPT '
          +' WHERE prj_no=' +''''+g_ProjectInfo.prj_no_ForSQL+''''
          +' AND drl_no='  +''''+stringReplace(drl_no,'''','''''',[rfReplaceAll])+'''';
        with MainDataModule.qrySPT do
          begin
            close;
            sql.Clear;
            sql.Add(strSQL);
            open;
            strTmp:= '1=';
            while not Eof do
            begin
              strTmp:= strTmp + FieldByName('real_num').AsString+','
                +FormatFloat('0.00',FieldByName('begin_depth').AsFloat)+','
                +FormatFloat('0.00',FieldByName('end_depth').AsFloat)+',';
              next;
            end;
            close;
          end;
        if copy(strTmp,length(strTmp),1)=',' then
          strTmp:= copy(strTmp,1,length(strTmp)-1);
        FileList.Add(strTmp);

       //������̽����
        strSQL:='SELECT prj_no,drl_no,begin_depth,end_depth,'
          +'real_num1+real_num2+real_num3 as real_num, pt_type '
          +' FROM DPT '
          +' WHERE prj_no=' +''''+g_ProjectInfo.prj_no_ForSQL+''''
          +' AND drl_no='  +''''+stringReplace(drl_no,'''','''''',[rfReplaceAll])+'''';
        with MainDataModule.qryDPT do
          begin
            close;
            sql.Clear;
            sql.Add(strSQL);
            open;
            strTmp:= '0=';
            while not Eof do
            begin
              if FieldByName('pt_type').AsString = '0' then
                  strTmp := strTmp + '63.5,'
              else if FieldByName('pt_type').AsString = '1' then
                  strTmp := strTmp + '63.5,'
              else
                  strTmp := strTmp + '63.5,';
            

              strTmp:= strTmp + FieldByName('real_num').AsString+','
                +FormatFloat('0.00',FieldByName('begin_depth').AsFloat)+','
                +FormatFloat('0.00',FieldByName('end_depth').AsFloat)+',';
              next;
            end;
            close;
          end;
        if copy(strTmp,length(strTmp),1)=',' then
          strTmp:= copy(strTmp,1,length(strTmp)-1);
        FileList.Add(strTmp);

    end;    // for

    FileList.SaveToFile(strFileName);
  finally
    FileList.Free;
    DescList.Free;
  end;

     if chkzhifangtu.Checked then
         //ֱ��ͼ
         strExecute:=getCadExcuteName +' '+PrintChart_ZhuZhuangTuZhiFangTu+','+strFileName +','+ REPORT_PRINT_SPLIT_CHAR
     else if chkShuangda.Checked then
     begin
         //һ������ͼ�ϴ�ӡ���У�Ҳ���Ǳ�������һҳ�ģ������档����������ף���ӡ��һҳ��
         if trim(cboDrl_no2.Text) <>'' then
             strExecute:=getCadExcuteName +' '+PrintChart_ZhuZhuangTuShuangDa2+','+strFileName +','+ REPORT_PRINT_SPLIT_CHAR
         else
             strExecute:=getCadExcuteName +' '+PrintChart_ZhuZhuangTuShuangDa1+','+strFileName +','+ REPORT_PRINT_SPLIT_CHAR;
     end
     else
         //������ӡ
         strExecute:=getCadExcuteName +' '+PrintChart_ZhuZhuangTu+','+strFileName +','+ REPORT_PRINT_SPLIT_CHAR ;

  winexec(pAnsichar(strExecute),sw_normal);
end;

procedure TZhuZhuangTuForm.btn_cancelClick(Sender: TObject);
begin
  self.Close;
end;

procedure TZhuZhuangTuForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TZhuZhuangTuForm.chkZhiFangTuClick(Sender: TObject);
begin
    if chkZhiFangTu.Checked then
        chkshuangda.Checked := false;
      
end;

procedure TZhuZhuangTuForm.chkShuangDaClick(Sender: TObject);
begin
        if chkshuangda.Checked then
           chkZhiFangTu.Checked := false;
end;

end.
