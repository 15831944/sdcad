unit TuYangDaoRu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, Grids, StrUtils;

type
  TTuYangDaoRuForm = class(TForm)
    OpenDialog1: TOpenDialog;
    pnlAll: TPanel;
    pnlTop: TPanel;
    Label2: TLabel;
    btnLoad: TBitBtn;
    btnCancel: TBitBtn;
    edtFileName: TEdit;
    btnFileOpen: TBitBtn;
    pnlCen: TPanel;
    Splitter1: TSplitter;
    reSrcFile: TRichEdit;
    sgResult: TStringGrid;
    procedure btnLoadClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure sgResultDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnFileOpenClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  
type TFieldRec=record
  Name: string;
  value: string;
  end;
  
var
  TuYangDaoRuForm: TTuYangDaoRuForm;
  
implementation

uses public_unit, MainDM;

{$R *.dfm}

procedure TTuYangDaoRuForm.btnLoadClick(Sender: TObject);
var
  I: Integer;
  Fields_NO  : array[1..4] of TFieldRec;  //���������ֶ�,�������+��ױ��+ȡ�����
  Fields_WL  : array[1..13] of TFieldRec; //����ɹ������ֶ�,��ˮ��+�ܶ�+���ܶ�+ʪ�ضȵ�
//yys 20040520 modified
  //Fields_ZJ: array[1..3] of TFieldRec;  //ֱ���ɹ������ֶ�,ֱ��ʵ�鷽��+ճ����+Ħ����
  Fields_ZJ  : array[1..5] of TFieldRec;  //ֱ���ɹ������ֶ�,ֱ��ʵ�鷽��+ճ����+Ħ����
//yys 20040520 modified
  Fields_YALI: TFieldRec;  //ѹ������ѹ��
  Fields_BXL : TFieldRec;  //ѹ���������ѹ���µı�����
  Fields_EI  : TFieldRec;  //ѹ���������ѹ���µĿ�϶��
  Fields_AV  : TFieldRec;  //ѹ���������ѹ���µ�ѹ��ϵ��
  Fields_ES  : TFieldRec;  //ѹ���������ѹ���µ�ѹ��ģ��
  Fields_YSXS: array[1..2] of TFieldRec;// ѹ��100��200�µ�ѹ��ϵ��,ѹ��ģ��

  Fields_WCX: array[1..3] of TFieldRec; //�޲��޿�ѹǿ��ԭ״�����ܡ�������
  Fields_KF: array[1..7] of TFieldRec;  //�ŷֳɹ�����
  KF_Class: array[1..7] of double;      //�������ֿŷּ���
  Fields_TU: TFieldRec; //��������
  lstTmp, lstSample, lstKF_Class, lstDrillNo: TStringList;
  j,k, iGridRow,iMsg: integer;
  strDrillNo, strTmp: string;
  bExistedDrillNo: boolean;  //�ж���������׺��Ƿ��������ױ��С�
  strSQLFields,strSQLValues,strSQL:string;
  strFirstStringOfLine: string;  //ÿһ�еĵ�һ������ǰ����ַ� ���磨NO,1--3,J1���е�NO
  ClickedOK: Boolean;
begin
  iMsg := messagebox(self.Handle ,'�����Ҫɾ�����ݿ��е�ǰ���̵�������������,�����µ����ݣ��밴"ȷ��"��'
    +#13#13+'���Ҫ�ϲ����ݣ��밴"��"��'
    +#13#13+'�������ת�����밴"ȡ��"��','������Ϣ',MB_YESNOCANCEL);
  if iMsg=IDCANCEL then exit;
  try
    screen.Cursor := crHourGlass;
    

    //��ʼɾ�������������ݱ��е�ǰ���̵���������
    if iMsg = IDYES then
    begin
      strSQL:= 'DELETE FROM earthsample '
        +' WHERE prj_no=' +''''
        +g_ProjectInfo.prj_no_ForSQL +'''';
      Delete_oneRecord(MainDataModule.qryEarthSample,strSQL);
    end;
    
    lstDrillNo:= TStringList.Create;
    lstDrillNo.Clear;
    //����ױ���ȡ������������׺ţ��Ա��ж��ļ��е���׺��Ƿ��Ѿ����뵽��ױ�
    //û�еĻ���ʾ�û����룬Ȼ����ת���ļ���
    //yys 20040520 modified
    {with MainDataModule.qryDrills do
    begin
      close;
      sql.Clear;
      //sql.Add('select prj_no,prj_name,area_name,builder,begin_date,end_date,consigner from projects');
      sql.Add('SELECT prj_no,drl_no');
      sql.Add(' FROM drills ');
      sql.Add(' WHERE prj_no='+''''
        +stringReplace(g_ProjectInfo.prj_no ,'''','''''',[rfReplaceAll])+'''');
      open;
      while not eof do
      begin
        lstDrillNo.Add(FieldByName('drl_no').AsString);
        Next; 
      end;
    end;
    if lstDrillNo.Count =0 then
    begin
      MessageBox(application.Handle,'��������������봰�����뵱ǰ���̵�������ݣ�'
        +#13+'Ȼ���ٵ��������������ݡ�','��ʾ...',MB_OK+MB_ICONINFORMATION);
      exit;
    end;}
    //yys 20040520 modified
    Fields_NO[1].Name := 'drl_no';          //��׺�
    Fields_NO[2].Name := 's_no';            //�������
    Fields_NO[3].Name := 's_depth_begin';   //ȡ�����ʼ
    Fields_NO[4].Name := 's_depth_end';     //ȡ�����ֹ
   
    Fields_WL[1].Name := 'aquiferous_rate'; //��ˮ��
    Fields_WL[2].Name := 'wet_density';     //ʪ�ܶ�
    Fields_WL[3].Name := 'dry_density';     //���ܶ�
    Fields_WL[4].Name := 'szdu';            //ʪ�ض�
    Fields_WL[5].Name := 'gzdu';            //���ض�
    Fields_WL[6].Name := 'soil_proportion'; //��������
    Fields_WL[7].Name := 'saturation';      //���Ͷ�
    Fields_WL[8].Name := 'gap_rate';        //��϶��
    Fields_WL[9].Name := 'liquid_limit';    //Һ��
    Fields_WL[10].Name:= 'shape_limit';     //����
    Fields_WL[11].Name:= 'shape_index';     //����ָ��
    Fields_WL[12].Name:= 'liquid_index';    //Һ��ָ��
    Fields_WL[13].Name:= 'gap_degree';      //��϶��
    
    Fields_ZJ[1].Name :='shear_type';       //ֱ��ʵ�鷽�� 
    Fields_ZJ[2].Name :='cohesion';         //ֱ��ճ����
    Fields_ZJ[3].Name :='friction_angle';   //ֱ��Ħ����
    //yys 20040609 modified
    Fields_ZJ[4].Name :='cohesion_gk';      //�̿�ճ����
    Fields_ZJ[5].Name :='friction_gk';      //�̿�Ħ����    
    //yys 20040609 modified
    Fields_YALI.Name := 'yssy_yali';      //ѹ������ѹ��
    Fields_BXL.Name  := 'yssy_bxl';       //ѹ���������ѹ���µı�����
    Fields_EI.Name   := 'yssy_kxb';       //ѹ���������ѹ���µĿ�϶��
    Fields_AV.Name   := 'yssy_ysxs';      //ѹ���������ѹ���µ�ѹ��ϵ��
    Fields_ES.Name   := 'yssy_ysml';      //ѹ���������ѹ���µ�ѹ��ģ��
    Fields_YSXS[1].Name := 'zip_coef';    // ѹ��100��200�µ�ѹ��ϵ��
    Fields_YSXS[2].Name := 'zip_modulus'; // ѹ��100��200�µ�ѹ��ģ��

    Fields_WCX[1].Name := 'wcx_yuanz';      //�޲��޿�ѹǿ��ԭ״
    Fields_WCX[2].Name := 'wcx_chsu';       //����
    Fields_WCX[3].Name := 'wcx_lmd';        //������

    Fields_KF[1].Name := 'li';              //��(%) (����5.0~2.0)
    Fields_KF[2].Name := 'sand_big';        //ɰ����(%) (����2.0~0.5)
    Fields_KF[3].Name := 'sand_middle';     //ɰ����(%) (����0.5~0.25)
    Fields_KF[4].Name := 'sand_small';      //ɰ��ϸ(%) (����0.25~0.075)
    Fields_KF[5].Name := 'powder_big';      //������(%) (����0.075~0.05)
    Fields_KF[6].Name := 'powder_small';    //����ϸ(%) (����0.05~0.005)
    Fields_KF[7].Name := 'clay_grain';      //ճ��(%) (����<0.005)
    KF_Class[1]:= 2;
    KF_Class[2]:= 0.5;
    KF_Class[3]:= 0.25;
    KF_Class[4]:= 0.075; //��ʱ���ֵ������0.100,�������KF_Class���治���ˡ�yys 2005/06/10
    KF_Class[5]:= 0.05;
    KF_Class[6]:= 0.005;
    KF_Class[7]:= 0;
    Fields_TU.Name := 'ea_name';
    
    lstTmp:= TStringList.Create;
    lstSample:= TStringList.Create;
    lstKF_Class:= TStringList.Create;
    iGridRow := 1;
    sgResult.RowCount:= 2;
    for i:=1 to sgResult.ColCount-1 do
      for j:=1 to sgResult.RowCount-1 do
        sgResult.Cells[i,j]:= '';
    //ȡ�ÿŷּ������磺20��10��5��2��������0,ʵ���ϴ���С����С��һ��(�����һ����0.005,��0����<0.005����һ��)
    DivideString(reSrcFile.Lines.Strings[1],',',lstKF_Class);
    for i:=0 to 1 do
      lstKF_Class.Delete(0);
    lstKF_Class.Add('0');

//******************��ʼȡ�Ú�һ������������,���������ݿ�********************
    for i:= 2 to reSrcFile.Lines.Count-1 do
    try
      DivideString(reSrcFile.Lines.Strings[i],',',lstTmp);
      if lstTmp.Count > 0 then
        strFirstStringOfLine := lstTmp.Strings[0]
      else
        begin
          strFirstStringOfLine := '';
          continue;
        end;
      //********��������,NO,+���+�������+��ױ��+ȡ�����
      if strFirstStringOfLine='NO' then
      begin
        strTmp:= lstTmp.Strings[3];
        if strTmp<>'' then   //��Ϊ�ڵ�����ļ��У��������������׺���ͬʱ��
        begin                           //��ôֻ�е�һ����������׺���ֵ��������������׺Ŷ�Ϊ��.
          //yys 20040520 modified
          {bExistedDrillNo:= false;
          for j:=0 to lstDrillNo.Count-1 do
            if strTmp=lstDrillNo.Strings[j] then
              bExistedDrillNo:= true;
          if not bExistedDrillNo then  //�����������׺�����ױ��в����ڣ�Ҫ�û������롣
          begin
            MessageBox(application.Handle,pansichar('��������������봰�����뵱ǰ��������׺� '''+strTmp+''' ��'
              +#13+'Ȼ���ٵ��������������ݡ�'),'��ʾ...',MB_OK+MB_ICONINFORMATION);
            DrillsForm:=TDrillsForm.Create(Application);
            Clear_Data(DrillsForm);
            DrillsForm.Button_status(3,true);
            DrillsForm.DrawDrill;
            DrillsForm.edtDrl_no.Text := strTmp;
            DrillsForm.ShowModal;
            //exit;
          end;}
          //yys 20040520 modified
          strDrillNo := '';
          strDrillNo:=strTmp;
          ClickedOK := true;

          ClickedOK := InputQuery('�¿׺�', '', strDrillNo);

        end;
        if strDrillNo='' then ClickedOK := false;

        Fields_NO[1].value := strDrillNo;
        if lstTmp.Strings[2]<>'' then
        begin
          DivideStringNoEmpty(lstTmp.Strings[2],'-',lstSample);
          for j:=1 to lstSample.Count-1 do
            Fields_NO[2].value := Fields_NO[2].value + lstSample.Strings[j]+'-';
          Fields_NO[2].value:= copy(Fields_NO[2].value,1,length(Fields_NO[2].value)-1);
          if lstTmp.Strings[4]<>'' then
          begin
            DivideString(lstTmp.Strings[4],'-',lstSample);
            Fields_NO[3].value := lstSample.Strings[0];
            Fields_NO[4].value := lstSample.Strings[1];
          end;
        end;
        continue;
      end;
      //********�ڶ�������ɹ�����,WL,+��ˮ��+�ܶ�+���ܶ�+ʪ�ضȵ�
      try
        if strFirstStringOfLine='WL' then
          for j:= 1 to High(Fields_WL) do
            Fields_WL[j].value := lstTmp.Strings[j];
      except
        continue;
      end;
      //********�����пŷֳɹ�����
      try
        if strFirstStringOfLine='KF' then
//yys 2005/06/10 �޸ģ�ԭ���ǵ�����ļ���ʱ�ŷּ����ǹ̶���
          //for j:= 6 to lstTmp.Count-1 do
          //   for k:= low(KF_Class) to High(KF_Class) do
          //   begin
          //     if samevalue(StrToFloat(lstKF_Class.Strings[j-6]), KF_Class[k]) then
          //     begin
          //       Fields_KF[k].value := lstTmp.Strings[j];
          //       break;
          //     end;
          //   end;
          for j:= 11 to lstTmp.Count-1 do
              Fields_KF[j-10].Value := lstTmp.Strings[j];
//yys 2005/06/10
      except
        continue;
      end;
      //********������ֱ���ɹ�����,ZJ,+ֱ��ʵ�鷽��+ֱ��ճ����+ ֱ��Ħ����
      try
        if strFirstStringOfLine='ZJ' then
        begin
         Fields_ZJ[1].value := lstTmp.Strings[1];
         //yys 20040520 modified
         //Fields_ZJ[2].value := lstTmp.Strings[10];
         //Fields_ZJ[3].value := lstTmp.Strings[11];
         if Fields_ZJ[1].value = '���' then
         begin
           Fields_ZJ[2].value := lstTmp.Strings[10];
           Fields_ZJ[3].value := lstTmp.Strings[11];
         end
         else if Fields_ZJ[1].value = '�̿�' then
         begin
           Fields_ZJ[4].value := lstTmp.Strings[10];
           Fields_ZJ[5].value := lstTmp.Strings[11];
         end;
         //yys 20040520 modified
        end;
      except
        continue;
      end;

      //********����������ɫ
      try
        if strFirstStringOfLine='TU' then
          Fields_TU.value := lstTmp.Strings[1];
      except
        continue;
      end;
      //********�޲��޿�ѹǿ��ԭ״�����ܡ�������
      try
        if strFirstStringOfLine='WCX' then
        for j:= 1 to High(Fields_WCX) do
          Fields_WCX[j].value := lstTmp.Strings[j];
      except
        continue;
      end;

      //********ѹ���������ѹ��
      try
        if strFirstStringOfLine='YALI' then
        begin
          for j := 2 to lstTmp.Count  - 2 do    // Iterate
          begin
            if trim(lstTmp.Strings[j])<>'' then
              Fields_YALI.value := Fields_YALI.value + trim(lstTmp.Strings[j])
                + ',';
          end;    // for
            if trim(lstTmp.Strings[lstTmp.Count  - 1])<>'' then
              Fields_YALI.value := Fields_YALI.value + trim(lstTmp.Strings[
                lstTmp.Count  - 1])
            else if rightStr(Fields_YALI.value,1)=',' then
              Fields_YALI.value := LeftStr(Fields_YALI.value,Length(Fields_YALI.value)-1);
        end;
      except
        continue;
      end;

      //********ѹ���������ѹ���µı�����
      try
        if strFirstStringOfLine='BXL' then
        begin
          for j := 1 to lstTmp.Count  - 2 do    // Iterate
          begin
            if trim(lstTmp.Strings[j])<>'' then
              Fields_BXL.value := Fields_BXL.value + trim(lstTmp.Strings[j])
                + ',';
          end;    // for
            if trim(lstTmp.Strings[lstTmp.Count  - 1])<>'' then
              Fields_BXL.value := Fields_BXL.value + trim(lstTmp.Strings[
                lstTmp.Count  - 1])
            else if rightStr(Fields_BXL.value,1)=',' then
              Fields_BXL.value := LeftStr(Fields_BXL.value,Length(Fields_BXL.value)-1);
        end;
      except
        continue;
      end;

      //********ѹ���������ѹ���µĿ�϶��
      try
        if strFirstStringOfLine='EI' then
        begin
          for j := 1 to lstTmp.Count  - 2 do    // Iterate
          begin
            if trim(lstTmp.Strings[j])<>'' then
              Fields_EI.value := Fields_EI.value + trim(lstTmp.Strings[j])
                + ',';
          end;    // for
            if trim(lstTmp.Strings[lstTmp.Count  - 1])<>'' then
              Fields_EI.value := Fields_EI.value + trim(lstTmp.Strings[
                lstTmp.Count  - 1])
            else if rightStr(Fields_EI.value,1)=',' then
              Fields_EI.value := LeftStr(Fields_EI.value,Length(Fields_EI.value)-1);
        end;
      except
        continue;
      end;

      //********ѹ���������ѹ���µ�ѹ��ϵ��
      try
        if strFirstStringOfLine='AV' then
        begin
          for j := 1 to lstTmp.Count  - 2 do    // Iterate
          begin
            if trim(lstTmp.Strings[j])<>'' then
              Fields_AV.value := Fields_AV.value + trim(lstTmp.Strings[j])
                + ',';
          end;    // for
            if trim(lstTmp.Strings[lstTmp.Count  - 1])<>'' then
              Fields_AV.value := Fields_AV.value + trim(lstTmp.Strings[
                lstTmp.Count  - 1])
            else if rightStr(Fields_AV.value,1)=',' then
              Fields_AV.value := LeftStr(Fields_AV.value,Length(Fields_AV.value)-1);
        end;
      except
        continue;
      end;

      //********ѹ���������ѹ���µ�ѹ��ģ��
      try
        if strFirstStringOfLine='ES' then
        begin
          for j := 1 to lstTmp.Count  - 2 do    // Iterate
          begin
            if trim(lstTmp.Strings[j])<>'' then
              Fields_ES.value := Fields_ES.value + trim(lstTmp.Strings[j])
                + ',';
          end;    // for
            if trim(lstTmp.Strings[lstTmp.Count  - 1])<>'' then
              Fields_ES.value := Fields_ES.value + trim(lstTmp.Strings[lstTmp.Count  - 1])
            else if rightStr(Fields_ES.value,1)=',' then
              Fields_ES.value := LeftStr(Fields_ES.value,Length(Fields_ES.value)-1);
        end;
      except
        continue;
      end;

      //********ѹ��100��200�µ�ѹ��ϵ��, ѹ��ģ��
      try
        if strFirstStringOfLine='YSXS' then
        begin
          Fields_YSXS[1].value := lstTmp.Strings[4]; //ѹ��ϵ��
          Fields_YSXS[2].value := lstTmp.Strings[5]; //ѹ��ģ��
        end;
      except
        continue;
      end;
      //********ѹ���ι̽�ϵ��, ��һ�е����ݲ��ã�ֱ�Ӱ�ȡ�õ����ݱ��棬���������FieldRec��value
      if strFirstStringOfLine='CGJ' then
        begin
          if ClickedOK then
          begin
              strSQLFields:= '';
              strSQLValues:= '';
              if (Fields_NO[1].value = '') or (Fields_NO[2].value = '')
                or (Fields_NO[3].value = '') or (Fields_NO[4].value = '') then
                continue;

              for j:=low(Fields_NO) to high(Fields_NO) do
              begin
                strSQLFields:= strSQLFields + Fields_NO[j].Name + ',';
                strSQLValues:= strSQLValues + '''' + Fields_NO[j].value + '''' + ',';
              end;
              for j:=low(Fields_WL) to high(Fields_WL) do
                if Fields_WL[j].value <>'' then
                begin
                  strSQLFields:= strSQLFields + Fields_WL[j].Name + ',';
                  strSQLValues:= strSQLValues + '''' + Fields_WL[j].value + '''' + ',';
                end;
              //yys 20040520 modified
              {if Fields_ZJ[1].value<>'' then
              begin
                strSQLFields:= strSQLFields + Fields_ZJ[1].Name + ',';
                if Fields_ZJ[1].value='���' then
                  strSQLValues:= strSQLValues + '''' + '0' + ''''+ ','
                else if Fields_ZJ[1].value='�̿�' then
                  strSQLValues:= strSQLValues + '''' + '1' + ''''+ ','
                else if Fields_ZJ[1].value='����' then
                  strSQLValues:= strSQLValues + '''' + '2' + ''''+ ','
                else
                  strSQLValues:= strSQLValues + '''' + '3' + ''''+ ','
              end;}
              //yys 20040520 modified
              for j:=low(Fields_ZJ)+1 to high(Fields_ZJ) do
                if Fields_ZJ[j].value <>'' then
                begin
                  strSQLFields:= strSQLFields + Fields_ZJ[j].Name + ',';
                  strSQLValues:= strSQLValues + '''' + Fields_ZJ[j].value + '''' + ',';
                end;

              strSQLFields:= strSQLFields + Fields_YALI.Name + ',';
              strSQLValues:= strSQLValues + '''' + Fields_YALI.value + '''' +',';

              strSQLFields:= strSQLFields + Fields_BXL.Name + ',';
              strSQLValues:= strSQLValues + '''' + Fields_BXL.value + '''' +',';

              strSQLFields:= strSQLFields + Fields_EI.Name + ',';
              strSQLValues:= strSQLValues + '''' + Fields_EI.value + '''' +',';

              strSQLFields:= strSQLFields + Fields_AV.Name + ',';
              strSQLValues:= strSQLValues + '''' + Fields_AV.value + '''' +',';

              strSQLFields:= strSQLFields + Fields_ES.Name + ',';
              strSQLValues:= strSQLValues + '''' + Fields_ES.value + '''' +',';

              for j:=low(Fields_YSXS) to high(Fields_YSXS) do
                if Fields_YSXS[j].value <>'' then
                begin
                  strSQLFields:= strSQLFields + Fields_YSXS[j].Name + ',';
                  strSQLValues:= strSQLValues + '''' + Fields_YSXS[j].value + '''' + ',';
                end;
              for j:= low(Fields_WCX) to high(Fields_WCX) do
                if Fields_WCX[j].value <>'' then
                begin
                  strSQLFields:= strSQLFields + Fields_WCX[j].Name + ',';
                  strSQLValues:= strSQLValues + '''' + Fields_WCX[j].value + '''' + ',';
                end;
              for j:= low(Fields_KF) to high(Fields_KF) do
                if Fields_KF[j].value <>'' then
                begin
                  strSQLFields:= strSQLFields + Fields_KF[j].Name + ',';
                  strSQLValues:= strSQLValues + '''' + Fields_KF[j].value + '''' + ',';
                end;
              if Fields_TU.value <> '' then
              begin

                strSQLFields:= strSQLFields + Fields_TU.Name + ',';
                strSQLValues:= strSQLValues + '''' + Fields_TU.value + '''' + ',';
              end;
              //�������ͳ���ֶΣ�ֵΪ1����ʾ����ͳ��
              strSQLFields:= strSQLFields + 'if_statistic';
              strSQLValues:= strSQLValues + '1';
              //���빤�̱��
              strSQLFields:='prj_no,' + strSQLFields;
              strSQLValues:=''''+stringReplace(g_ProjectInfo.prj_no ,'''','''''',[rfReplaceAll]) +''''+',' + strSQLValues;

              strSQL := 'INSERT INTO earthsample ('+strSQLFields+') VALUES(' +strSQLValues+')';
              if Insert_oneRecord(MainDataModule.qryEarthSample,strSQL) then
              begin
                //��ʼ��sgResult��һ�и�ֵ
                Inc(iGridRow);
                sgResult.RowCount := iGridRow;
                sgResult.Cells[0, iGridRow-1]:= IntToStr(iGridRow-1);
                for j:=low(Fields_NO) to high(Fields_NO) do
                  sgResult.Cells[j, iGridRow-1]:= Fields_NO[j].value;
                k:= high(Fields_NO)- low(Fields_NO) + 2; //k��ʾ��һ�ֶ���sgResult���ǵڼ���
                sgResult.Cells[k, iGridRow-1]:= Fields_TU.value;

                for j:=low(Fields_WL) to high(Fields_WL) do
                  sgResult.Cells[j+k, iGridRow-1]:= Fields_WL[j].value;
                k:= k + high(Fields_WL)- low(Fields_WL) + 1;
                for j:=low(Fields_ZJ) to high(Fields_ZJ) do
                  sgResult.Cells[j+k, iGridRow-1]:= Fields_ZJ[j].value;
                k:= k + high(Fields_ZJ)- low(Fields_ZJ) + 1;
                for j:= low(Fields_YSXS) to high(Fields_YSXS) do
                  sgResult.Cells[j+k, iGridRow-1]:= Fields_YSXS[j].value;
                k:= k + high(Fields_YSXS)- low(Fields_YSXS) + 1;
                for j:= low(Fields_WCX) to high(Fields_WCX) do
                  sgResult.Cells[j+k, iGridRow-1]:= Fields_WCX[j].value;
                k:= k + high(Fields_WCX)- low(Fields_WCX) + 1;
                for j:= low(Fields_KF) to high(Fields_KF) do
                  sgResult.Cells[j+k, iGridRow-1]:= Fields_KF[j].value;
              end;
          end;
          //��ʼ�������FieldRec��valueֵ,׼��������һ��������Ϣ
          for j:=low(Fields_NO) to high(Fields_NO) do
            Fields_NO[j].value := '';
          for j:=low(Fields_WL) to high(Fields_WL) do
            Fields_WL[j].value := '';
          for j:=low(Fields_ZJ) to high(Fields_ZJ) do
            Fields_ZJ[j].value := '';
          Fields_YALI.value := '';
          Fields_BXL.value  := '';
          Fields_EI.value   := '';
          Fields_AV.value   := '';
          Fields_ES.value   := '';
          for j:=low(Fields_YSXS) to high(Fields_YSXS) do
            Fields_YSXS[j].value := '';
          for j:= low(Fields_WCX) to high(Fields_WCX) do
            Fields_WCX[j].value := '';
          for j:= low(Fields_KF) to high(Fields_KF) do
            Fields_KF[j].value := '';
          Fields_TU.value := '';
        end;
        continue;
    except
    end;
  finally
    lstTmp.Free;
    lstSample.Free;
    lstKF_Class.Free;
    lstDrillNo.Free;
    screen.Cursor := crDefault;
  end;
  
end;

procedure TTuYangDaoRuForm.btnCancelClick(Sender: TObject);
begin
  self.Close;
end;

procedure TTuYangDaoRuForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= CaFree;
end;

procedure TTuYangDaoRuForm.FormCreate(Sender: TObject);
begin
   self.Left := trunc((screen.Width -self.Width)/2);
   self.Top  := trunc((Screen.Height - self.Height)/2);
   sgResult.FixedCols := 3;
   sgResult.ColCount :=36;
   sgResult.ColWidths[0]:= 30;
   sgResult.Cells[1,0]:= '��׺�';
   sgResult.ColWidths[1]:= 120;  
   sgResult.Cells[2,0]:= '�������';
   sgResult.Cells[3,0]:= 'ȡ�����ʼ';
   sgResult.Cells[4,0]:= 'ȡ�����ֹ';
   sgResult.Cells[5,0]:= '��������';
   sgResult.Cells[6,0]:= '��ˮ��';
   sgResult.Cells[7,0]:= 'ʪ�ܶ�';
   sgResult.Cells[8,0]:= '���ܶ�';
   sgResult.Cells[9,0]:= 'ʪ�ض�';
   sgResult.Cells[10,0]:= '���ض�';
   sgResult.Cells[11,0]:= '��������';
   sgResult.Cells[12,0]:= '���Ͷ�';
   sgResult.Cells[13,0]:= '��϶��';
   sgResult.Cells[14,0]:= 'Һ��';
   sgResult.Cells[15,0]:= '����';
   sgResult.Cells[16,0]:= '����ָ��';
   sgResult.Cells[17,0]:= 'Һ��ָ��';
   sgResult.Cells[18,0]:= '��϶��';
   sgResult.Cells[19,0]:= 'ֱ��ʵ�鷽��';
   sgResult.ColWidths[19]:= sgResult.ColWidths[18]+10;
//yys 20040609 modified
   //sgResult.Cells[20,0]:= 'ֱ��ճ����';
   //sgResult.Cells[21,0]:= 'ֱ��Ħ����';
   sgResult.Cells[20,0]:= 'ֱ��ճ����';
   sgResult.Cells[21,0]:= 'ֱ��Ħ����';
   sgResult.Cells[22,0]:= '�̿�ճ����';
   sgResult.Cells[23,0]:= '�̿�Ħ����';   

   {sgResult.Cells[22,0]:= 'ѹ��ϵ��';
   sgResult.Cells[23,0]:= 'ѹ��ģ��';
   sgResult.Cells[24,0]:= '�޲���ԭ״';
   sgResult.Cells[25,0]:= '�޲�������';
   sgResult.Cells[26,0]:= '�޲���������';
   sgResult.ColWidths[26]:= sgResult.ColWidths[26]+10; 
   sgResult.Cells[27,0]:= '����2.0~0.5';
   sgResult.ColWidths[27]:= sgResult.ColWidths[27]+10;
   sgResult.Cells[28,0]:= '����0.5~0.25';
   sgResult.ColWidths[28]:= sgResult.ColWidths[28]+15;
   sgResult.Cells[29,0]:= '����0.25~0.075';
   sgResult.ColWidths[29]:= sgResult.ColWidths[29]+25;
   sgResult.Cells[30,0]:= '����0.075~0.05';
   sgResult.ColWidths[30]:= sgResult.ColWidths[30]+25;
   sgResult.Cells[31,0]:= '����0.05~0.005';
   sgResult.ColWidths[31]:= sgResult.ColWidths[31]+25;
   sgResult.Cells[32,0]:= '����<0.005';}
   sgResult.Cells[24,0]:= 'ѹ��ϵ��';
   sgResult.Cells[25,0]:= 'ѹ��ģ��';
   sgResult.Cells[26,0]:= '�޲���ԭ״';
   sgResult.Cells[27,0]:= '�޲�������';
   sgResult.Cells[28,0]:= '�޲���������';
   sgResult.ColWidths[28]:= sgResult.ColWidths[28]+10; 
   sgResult.Cells[29,0]:= '����2.0~0.5';
   sgResult.ColWidths[29]:= sgResult.ColWidths[29]+10;
   sgResult.Cells[30,0]:= '����0.5~0.25';
   sgResult.ColWidths[30]:= sgResult.ColWidths[30]+15;
   sgResult.Cells[31,0]:= '����0.25~0.075';
   sgResult.ColWidths[31]:= sgResult.ColWidths[31]+25;
   sgResult.Cells[32,0]:= '����0.075~0.05';
   sgResult.ColWidths[32]:= sgResult.ColWidths[32]+25;
   sgResult.Cells[33,0]:= '����0.05~0.005';
   sgResult.ColWidths[33]:= sgResult.ColWidths[33]+25;
   sgResult.Cells[34,0]:= '����<0.005';  
   sgResult.Cells[35,0]:= 'ճ ��';
   setLabelsTransparent(self);  
//yys 20040609 modified
end;

procedure TTuYangDaoRuForm.sgResultDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if ARow=0 then
    AlignGridCell(Sender,ACol,ARow,Rect,taCenter)
  else
    AlignGridCell(Sender,ACol,ARow,Rect,taRightJustify);
end;

procedure TTuYangDaoRuForm.btnFileOpenClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    edtFileName.Text := OpenDialog1.FileName;
    reSrcFile.Lines.Clear;
    resrcFile.Lines.LoadFromFile(OpenDialog1.FileName);
    if reSrcFile.Lines.Count >0 then
    begin
      btnLoad.Enabled := true;
      btnLoad.SetFocus;
    end;
  end;
end;

end.
