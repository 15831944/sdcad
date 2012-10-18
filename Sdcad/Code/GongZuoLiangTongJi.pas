unit GongZuoLiangTongJi;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, ComCtrls, StdCtrls, Buttons, shellapi, ComObj;

type
  TGongZuoLiangTongJiForm = class(TForm)
    GroupBox4: TGroupBox;
    btnCreateReport: TBitBtn;
    STDir: TStaticText;
    btnBrowse: TBitBtn;
    ERP1: TEdit;
    btnOpenReport: TBitBtn;
    pbCreateReport: TProgressBar;
    SEFDlg: TSaveDialog;
    ADO02: TADOQuery;
    ADO02_All: TADOQuery;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnOpenReportClick(Sender: TObject);
    procedure btnCreateReportClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    m_FullFileName_TongJi:string;//EXCEL�ļ�XLS�ļ���ȫ·��
    txtFile:textFile;

    strOutTxt:string;
    strPath:string;

    m_intBeginRowOfExcelFile:Integer;
    m_intGeShu_Col:Integer;         //��Excel���и������������ڵ���
    m_intGongZuoLiang_Col:Integer;  //��Excel���й��������ڵ���
    m_isWritenTitle:Boolean;  //��¼�Ƿ�д����ͷ��
    m_strSQL_WhereClause_Drills_IsNot_JieKong:string;//sql ����where �Ӿ��е�һ������ ,��Drills����ѡ����ǰ�����в��ǽ�׵����
    m_JueSuan_FieldName:string; //������ǰ���������ֶ��� �� can_juesuan can_juesuan1 can_juesuan9
    function getOneBoreInfo(strProjectCode: string;strBoreCode: string):integer;
    function getAllBoreInfo(strProjectCode: string;intTag:integer):integer;
    function getAllBoreInfo_Jie(strProjectCode:string;intTag:integer):Integer;
    function getStandardThroughInfo(strProjectCode: string):integer;    //�����׼��������
    function getProveMeasureInfo(strProjectCode: string):integer;       //��̽�����
    function getRomDustTestInfo(strProjectCode: string):integer;
    function getEarthWaterInfo(strProjectCode: string):integer;
    function getZhongLiChuTanInfo(strProjectCode: string):Integer;
  public
    { Public declarations }
    procedure setJueSuanFieldName(iIndex:integer);//�ڲ���������������趨���趨����������������������ֶ�������can_juesuan + ����������ͱ����can_juesuan1 can_juesuan2������ʵ���ֶ���
  end;

var
  GongZuoLiangTongJiForm: TGongZuoLiangTongJiForm;

implementation

uses public_unit;

{$R *.dfm}

procedure TGongZuoLiangTongJiForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TGongZuoLiangTongJiForm.btnBrowseClick(Sender: TObject);
var
   SaveFName:string;
begin

   SEFDlg.DefaultExt :='xls';
   SEFDlg.Title :=FILE_SAVE_TITLE_GZL;
   SEFDlg.FileName :=trim(erp1.text);
   SEFDlg.Filter :='Excel�ļ�(*.xls)|*.xls';
   if not SEFDlg.Execute then exit;
   SaveFName:=SEFDlg.FileName ;
   erp1.text:=SaveFName;
end;

procedure TGongZuoLiangTongJiForm.btnOpenReportClick(Sender: TObject);
var
   sfName:string;
begin
   sfName:=trim(ERP1.Text);
   if fileexists(sfName) then
      shellexecute(application.Handle,PAnsiChar(''),PAnsiChar(sfName),PAnsiChar(''),PAnsiChar(''),SW_SHOWNORMAL)
   else
      Application.Messagebox(FILE_NOTEXIST,HINT_TEXT, MB_ICONEXCLAMATION + mb_Ok);

end;

procedure TGongZuoLiangTongJiForm.btnCreateReportClick(Sender: TObject);
var
    strPath:string;
    intResult:integer;
    i:integer;
    strProjectNo:string;
begin
    ERP1.Text := Trim(ERP1.Text);
    if pos('.xls',ERP1.Text)=0 then ERP1.Text:=ERP1.TEXT+'.xls';

    i:=Length(ERP1.text);
    repeat
        if copy(ERP1.text,i,1)='\' then
        begin
          strPath:=copy(ERP1.text,1,i);
          i:=0;
        end;
        i:=i-1;
    until i<=0;
    if not DirectoryExists(strPath) then   ForceDirectories(strPath);


    copyfile(pChar(ExtractFileDir(Application.Exename)+'\XLS\������ͳ�Ʊ�.xls'),PChar(ERP1.text),false);
    m_FullFileName_TongJi := ERP1.Text;


    strProjectNo := g_ProjectInfo.prj_no_ForSQL;
    pbCreateReport.min:=0;
    pbCreateReport.Max:=110;
    pbCreateReport.Step:=10;

    pbCreateReport.Position:=10;
   //��̽(½��)
   intResult:=getAllBoreInfo(strProjectNo,0);
   pbCreateReport.Position:=20;
   //��̽(ˮ��)
   intResult:=getAllBoreInfo(strProjectNo,1);
   //��̽ ���
   intResult:=getAllBoreInfo_Jie(strProjectNo,2);

   pbCreateReport.Position:=30;
   //���ž�����̽
   intResult:=getAllBoreInfo(strProjectNo,3);
   pbCreateReport.Position:=40;
   //˫�ž�����̽
   intResult:=getAllBoreInfo(strProjectNo,4);
   //������̽  ���
   intResult:=getAllBoreInfo_Jie(strProjectNo,5);

   pbCreateReport.Position:=50;
   //�黨��
   intResult:=getAllBoreInfo(strProjectNo,6);
   //�黨��  ���
   intResult:=getAllBoreInfo_Jie(strProjectNo,7);

   pbCreateReport.Position:=60;
   //�����������
   intResult:=getRomDustTestInfo(strProjectNo);
   //ȡ��,ˮ��
   intResult:=getEarthWaterInfo(strProjectNo);
   pbCreateReport.Position:=70;
   //��׼��������
   intResult:=getStandardThroughInfo(strProjectNo);



   pbCreateReport.Position:=80;
   //������̽����
   intResult:= getZhongLiChuTanInfo(strProjectNo);
   //��̽�����
   //intResult:=getProveMeasureInfo(strProjectNo);


   pbCreateReport.Position:=100;

   pbCreateReport.Position:=110;
   MessageBox(application.Handle,'���㱨���Ѿ����ɡ�','ϵͳ��ʾ',MB_OK+MB_ICONINFORMATION);

end;

function TGongZuoLiangTongJiForm.getAllBoreInfo(strProjectCode: string;
  intTag: integer): integer;
var
    ExcelApplication1:Variant;
    ExcelWorkbook1:Variant;
    range,sheet:Variant;
    xlsFileName:string;
    intDrillCount:Integer;   //��׸���
    dSumDrillDepth:Double; //��������
    intResult:integer;
    intRow,intCol:integer;
    strd_t_no:string;  //����ͺű��
    dblTmp:double;
begin

    if intTag=0 then strd_t_no:='1,4,5';   //½�Ͽ�
    if intTag=1 then strd_t_no:='2';       // ˮ�Ͽ�
    if intTag=3 then strd_t_no:='6';       // ����
    if intTag=4 then strd_t_no:='7';       // ˫��
    if intTag=6 then strd_t_no:='3';       // �黨�꣨С�����꣩

    //������ͳ��
    ADO02_All.Close;
    ADO02_All.SQL.Text:='select * from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''
      +strProjectCode+''' and d_t_no in ('+strd_t_no+')' + m_strSQL_WhereClause_Drills_IsNot_JieKong;
    ADO02_All.Open;

    intDrillCount := 0;
    dSumDrillDepth:= 0;
    while not ADO02_All.Recordset.eof do
    begin
        intDrillCount := intDrillCount +1;
        dSumDrillDepth := dSumDrillDepth + ADO02_All.fieldByName('comp_depth').AsFloat;

        ADO02_All.Next;
    end;

    ADO02_All.Close;


    //׼��������д��ͳ��EXCEL�ļ�
    ExcelApplication1:=CreateOleObject('Excel.Application');
    ExcelWorkbook1:=CreateOleobject('Excel.Sheet');
    xlsFileName:=m_FullFileName_TongJi;
    ExcelWorkbook1:=ExcelApplication1.workBooks.Open(xlsFileName);
    Sheet:= ExcelApplication1.Activesheet;



    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+intTag, m_intGeShu_Col):= IntToStr(intDrillCount);
    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+intTag, m_intGongZuoLiang_Col):= FormatFloat('0.00',dSumDrillDepth);

    ExcelWorkbook1.Save;
    ExcelWorkbook1.Close;
    ExcelApplication1.Quit;
    ExcelApplication1:=Unassigned;


    Result:=0;

end;

function TGongZuoLiangTongJiForm.getEarthWaterInfo(
  strProjectCode: string): integer;
var
    ExcelApplication1:Variant;
    ExcelWorkbook1:Variant;
    xlsFileName:string;
    dblCount:Array[1..10] of double;
    i:integer;
begin

    //ȡ��,ˮ��
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 '  + m_strSQL_WhereClause_Drills_IsNot_JieKong +' AND prj_no='''+strProjectCode+''') '+
            ' and prj_no='''+ strProjectCode + ''' and (not wet_density is null);';
    ADO02.Open;
    dblCount[1]:=ADO02.fieldByName('Num').Value;


//    //ȡ��,ˮ��(������>30��)
//    ADO02.Close;
//    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
//            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
//            'and s_depth_begin>30 and prj_no='''+ strProjectCode + ''' and (not wet_density is null);';
//
//    ADO02.Open;
//    dblCount[2]:=ADO02.fieldByName('Num').Value;

    //�Ŷ���
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 '  + m_strSQL_WhereClause_Drills_IsNot_JieKong +' AND prj_no='''+strProjectCode+''') '+
            'and prj_no='''+ strProjectCode + ''' and wet_density is null;';
    ADO02.Open;
    dblCount[2]:=ADO02.fieldByName('Num').Value;


    //д��EXCEL�ļ�
    ExcelApplication1:=CreateOleObject('Excel.Application');
    ExcelWorkbook1:=CreateOleobject('Excel.Sheet');
    xlsFileName:=ERP1.Text;;
    ExcelWorkbook1:=ExcelApplication1.workBooks.Open(xlsFileName);

    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+8,m_intGeShu_Col):=dblCount[1]; //ԭ״����
    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+9,m_intGeShu_Col):=dblCount[2]; //�Ŷ�����


    ExcelWorkbook1.Save;
    ExcelWorkbook1.Close;
    ExcelApplication1.Quit;
    ExcelApplication1:=Unassigned;
    result:=0;

end;

function TGongZuoLiangTongJiForm.getOneBoreInfo(strProjectCode,
  strBoreCode: string): integer;
begin

end;

function TGongZuoLiangTongJiForm.getProveMeasureInfo(
  strProjectCode: string): integer;
begin

end;

function TGongZuoLiangTongJiForm.getRomDustTestInfo(
  strProjectCode: string): integer;
var
    ExcelApplication1:Variant;
    ExcelWorkbook1:Variant;
    xlsFileName:string;
    dblearthsample:Array[1..50] of double;
    dblEarthSampleTeShu:array[1..50] of Double;//������
    i:integer;
begin

    for i:=1 to 50 do
    begin
      dblearthsample[i]:=0;
      dblEarthSampleTeShu[i]:=0;
    end;
    //��ˮ��
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 ' + m_strSQL_WhereClause_Drills_IsNot_JieKong+' AND prj_no='''+strProjectCode+''' ) '+
            'and prj_no='''+strProjectCode+''' and aquiferous_rate is not null';
    ADO02.Open;
    dblearthSample[1]:=ADO02.fieldByName('Num').Value;  //��ˮ��


    //����
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 '  + m_strSQL_WhereClause_Drills_IsNot_JieKong +' AND prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and wet_density is not null';
    ADO02.Open;
    dblearthSample[2]:=ADO02.fieldByName('Num').Value;  //����


    //Һ��
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 '  + m_strSQL_WhereClause_Drills_IsNot_JieKong +' AND prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and liquid_limit is not null';
    ADO02.Open;
    dblearthSample[3]:=ADO02.fieldByName('Num').Value;  //Һ��

    //����
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 '  + m_strSQL_WhereClause_Drills_IsNot_JieKong +' AND prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and shape_limit is not null';
    ADO02.Open;
    dblearthSample[4]:=ADO02.fieldByName('Num').Value;  //����


    //����
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 '  + m_strSQL_WhereClause_Drills_IsNot_JieKong +' AND prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and soil_proportion is not null';
    ADO02.Open;
    dblearthSample[5]:=ADO02.fieldByName('Num').Value;  //����

    //ֱ��(���)
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 '  + m_strSQL_WhereClause_Drills_IsNot_JieKong +' AND prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and cohesion is not null';
    ADO02.Open;
    dblearthSample[6]:=ADO02.fieldByName('Num').Value;  //ֱ��(���)

    //ֱ��(�̿�)
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 '  + m_strSQL_WhereClause_Drills_IsNot_JieKong +' AND prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and cohesion_gk is not null';
    ADO02.Open;
    dblearthSample[7]:=ADO02.fieldByName('Num').Value;  //ֱ��(�̿�)



    //ѹ��(����)
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 '  + m_strSQL_WhereClause_Drills_IsNot_JieKong +' AND prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (zip_coef is not null or zip_modulus is not null);';
    ADO02.Open;
    dblearthSample[11]:=ADO02.fieldByName('Num').Value;  //ѹ��(����)


    //�ŷ�(���ؼ�)
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 '  + m_strSQL_WhereClause_Drills_IsNot_JieKong +' AND prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (sand_big is not null or sand_middle is not null or sand_small is not null or powder_big is not null or powder_small is not null or clay_grain is not null or li is not null)';
    ADO02.Open;
    dblearthSample[12]:=ADO02.fieldByName('Num').Value;  //�ŷ�(���ؼ�)




    //����Ϊ����������
    //���ڹ̽�ѹ��
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from TeShuYang '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 '  + m_strSQL_WhereClause_Drills_IsNot_JieKong +' AND prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (gygj_pc is not null)';
    ADO02.Open;
    dblEarthSampleTeShu[1]:=ADO02.fieldByName('Num').Value;

    //�̽�ϵ��
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from TeShuYang '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 '  + m_strSQL_WhereClause_Drills_IsNot_JieKong +' AND prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (gjxs50_1 is not null or gjxs100_1 is not null or gjxs200_1 is not null or gjxs400_1 is not null or gjxs50_2 is not null or gjxs100_2 is not null or gjxs200_2 is not null or gjxs400_2 is not null)';
    ADO02.Open;
    dblEarthSampleTeShu[3]:=ADO02.fieldByName('Num').Value;

    //�޲��޿�ѹǿ��
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from TeShuYang '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 '  + m_strSQL_WhereClause_Drills_IsNot_JieKong +' AND prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (wcxkyqd_yz is not null or wcxkyqd_cs is not null or wcxkyqd_lmd is not null)';
    ADO02.Open;
    dblEarthSampleTeShu[4]:=ADO02.fieldByName('Num').Value;

    //��Ȼ�½ǣ�ˮ�ϡ�ˮ�£�
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from TeShuYang '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 '  + m_strSQL_WhereClause_Drills_IsNot_JieKong +' AND prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (trpj_g is not null or trpj_sx is not null)';
    ADO02.Open;
    dblEarthSampleTeShu[6]:=ADO02.fieldByName('Num').Value;

    // ����ѹ�� ���̽᲻��ˮ(UU)
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from TeShuYang '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 '  + m_strSQL_WhereClause_Drills_IsNot_JieKong +' AND prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (szsy_zyl_njl_uu is not null or szsy_zyl_nmcj_uu is not null)';
    ADO02.Open;
    dblEarthSampleTeShu[7]:=ADO02.fieldByName('Num').Value;

    // ����ѹ�� �̽᲻��ˮ(CU)
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from TeShuYang '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 '  + m_strSQL_WhereClause_Drills_IsNot_JieKong +' AND prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (szsy_zyl_njl_cu is not null or szsy_zyl_nmcj_cu is not null)';
    ADO02.Open;
    dblEarthSampleTeShu[8]:=ADO02.fieldByName('Num').Value;

    //��͸����
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from TeShuYang '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 '  + m_strSQL_WhereClause_Drills_IsNot_JieKong +' AND prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (stxs_kv is not null or stxs_kh is not null)';
    ADO02.Open;
    dblEarthSampleTeShu[9]:=ADO02.fieldByName('Num').Value;

    //��ֹ��ѹ��ϵ�� K0
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from TeShuYang '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 '  + m_strSQL_WhereClause_Drills_IsNot_JieKong +' AND prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (jzcylxs is not null)';
    ADO02.Open;
    dblEarthSampleTeShu[11]:=ADO02.fieldByName('Num').Value;

    //����ϵ������ֱ��
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from TeShuYang '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 '  + m_strSQL_WhereClause_Drills_IsNot_JieKong +' AND prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (jcxs_v_005_01 is not null or jcxs_v_01_02 is not null or jcxs_v_02_04 is not null)';
    ADO02.Open;
    dblEarthSampleTeShu[12]:=ADO02.fieldByName('Num').Value;

    //����ϵ����ˮƽ��
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from TeShuYang '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 '  + m_strSQL_WhereClause_Drills_IsNot_JieKong +' AND prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (jcxs_h_005_01 is not null or jcxs_h_01_02 is not null or jcxs_h_02_04 is not null)';
    ADO02.Open;
    dblEarthSampleTeShu[13]:=ADO02.fieldByName('Num').Value;

    ADO02.Close;

    //д��EXCEL�ļ�
    ExcelApplication1:=CreateOleObject('Excel.Application');
    ExcelWorkbook1:=CreateOleobject('Excel.Sheet');
    xlsFileName:=ERP1.Text;
    ExcelWorkbook1:=ExcelApplication1.workBooks.Open(xlsFileName);

    //������
    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+12,m_intGeShu_Col):=dblearthSample[1];  //��ˮ��
    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+13,m_intGeShu_Col):=dblearthSample[2];  //��    �� �� �ܶ�
    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+14,m_intGeShu_Col):=dblearthSample[3];  //Һ    ��
    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+15,m_intGeShu_Col):=dblearthSample[4];  //��    ��
    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+16,m_intGeShu_Col):=dblearthSample[5];  //��    ��
    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+17,m_intGeShu_Col):=dblearthSample[6];  //ֱ�����
    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+18,m_intGeShu_Col):=dblearthSample[7];  //ֱ���̿�
    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+19,m_intGeShu_Col):=dblearthSample[11]; //ѹ������
    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+20,m_intGeShu_Col):=dblearthSample[12]; //�ŷ� ���ؼ�


    //������
    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+21,m_intGeShu_Col):=
      dblEarthSampleTeShu[1]; //���ڹ̽�ѹ��
    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+22,m_intGeShu_Col):=
      dblEarthSampleTeShu[3]; //�̽�ϵ��
    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+23,m_intGeShu_Col):=
      dblEarthSampleTeShu[12]; //����ϵ������ֱ��
    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+24,m_intGeShu_Col):=
      dblEarthSampleTeShu[13]; //����ϵ����ˮƽ��
    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+25,m_intGeShu_Col):=
      dblEarthSampleTeShu[4]; //�޲��޿�ѹǿ��

    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+26,m_intGeShu_Col):=
       FloatToStr(dblEarthSampleTeShu[7]+dblEarthSampleTeShu[8]); //����ѹ��
    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+27,m_intGeShu_Col):=dblEarthSampleTeShu[9]; //��͸����
    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+28,m_intGeShu_Col):=
      dblEarthSampleTeShu[6]; //��Ȼ�½ǣ�ˮ�ϡ�ˮ�£�

    //ExcelApplication1.Cells(28,35):=dblEarthSampleTeShu[1]+dblEarthSampleTeShu[3];  //���ڹ̽�ѹ��(���̽�ϵ������92���㲻һ��
    //ExcelApplication1.Cells(30,35):=dblEarthSampleTeShu[3];  //�̽�ϵ��
    //ExcelApplication1.Cells(32,35):=dblEarthSampleTeShu[4];  //�޲��޿�ѹǿ��
    //ExcelApplication1.Cells(33,35):=dblEarthSampleTeShu[6];  //��Ȼ�½ǣ�ˮ�ϡ�ˮ�£�
    //ExcelApplication1.Cells(34,35):=dblEarthSampleTeShu[7];  //����ѹ�� ���̽᲻��ˮ(UU)
    //ExcelApplication1.Cells(35,35):=dblEarthSampleTeShu[8];  //����ѹ�� �̽᲻��ˮ(CU)
    //ExcelApplication1.Cells(42,26):=dblEarthSampleTeShu[9];  //��͸����
    //ExcelApplication1.Cells(44,26):=dblEarthSampleTeShu[11]; //��ֹ��ѹ��ϵ�� K0


    ExcelWorkbook1.Save;
    ExcelWorkbook1.Close;
    ExcelApplication1.Quit;
    ExcelApplication1:=Unassigned;
    result:=0;

end;

function TGongZuoLiangTongJiForm.getStandardThroughInfo(
  strProjectCode: string): integer;
var
    intMore50:integer;
    intLess50:integer;
    intCount:integer;
    ExcelApplication1:Variant;
    ExcelWorkbook1:Variant;
    xlsFileName:string;
    strSQL: string;

begin


    ADO02.Close;
    ADO02.SQL.Text:='select spt.*,stratum.stra_category from spt join stratum '+
                      'on spt.prj_no=stratum.prj_no and spt.drl_no=stratum.drl_no '+
                      'and spt.stra_no=stratum.stra_no and spt.sub_no=stratum.sub_no '+
                      'where spt.drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 '  + m_strSQL_WhereClause_Drills_IsNot_JieKong +' AND prj_no='''+strProjectCode+''') '+
                      'and spt.prj_no='''+strProjectCode+'''';
    ADO02.Open;
    intCount := 0;
    while not ADO02.eof do
    begin
        intCount := intCount + 1;
        ADO02.Next;
    end;


    //д��EXCEL�ļ�
    ExcelApplication1:=CreateOleObject('Excel.Application');
    ExcelWorkbook1:=CreateOleobject('Excel.Sheet');
    xlsFileName:=ERP1.Text;
    ExcelWorkbook1:=ExcelApplication1.workBooks.Open(xlsFileName);

    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+10,m_intGeShu_Col):=IntToStr(intCount);
    


    ExcelWorkbook1.Save;
    ExcelWorkbook1.Close;
    ExcelApplication1.Quit;
    ExcelApplication1:=Unassigned;

    result:=0;

end;



function TGongZuoLiangTongJiForm.getZhongLiChuTanInfo(
  strProjectCode: string): Integer;
var

    intCount:integer;
    dGongZuoLiang:double;
    dEnd_Begin:Double; //ÿ������Ľ�����ȼ�ȥ��ʼ��ȵ�ֵ
    iStra_category:Integer;//��������
    iPt_type:Integer;//������̽���� 0 ���� 1 ���� 2 ������
    ExcelApplication1:Variant;
    ExcelWorkbook1:Variant;
    xlsFileName:string;
    strSQL: string;

begin


    ADO02.Close;
    ADO02.SQL.Text:='select dpt.*,stratum.stra_category92 FROM dpt JOIN stratum '+
                      'on dpt.prj_no=stratum.prj_no and dpt.drl_no=stratum.drl_no '+
                      'and dpt.stra_no=stratum.stra_no and dpt.sub_no=stratum.sub_no '+
                      'where dpt.drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 '  + m_strSQL_WhereClause_Drills_IsNot_JieKong +' AND prj_no='''+strProjectCode+''') '+
                      'and dpt.prj_no='''+strProjectCode+'''';
    ADO02.Open;
    intCount := 0;
    dGongZuoLiang := 0;
    while not ADO02.eof do
    begin
        intCount := intCount + 1;
        dEnd_Begin:= ADO02.FieldByName('end_depth').AsFloat - ADO02.FieldByName('begin_depth').AsFloat;
        dGongZuoLiang := dGongZuoLiang + dEnd_Begin ;
        ADO02.Next;
    end;

    //д��EXCEL�ļ�
    ExcelApplication1:=CreateOleObject('Excel.Application');
    ExcelWorkbook1:=CreateOleobject('Excel.Sheet');
    xlsFileName:=ERP1.Text;
    ExcelWorkbook1:=ExcelApplication1.workBooks.Open(xlsFileName);


    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+11,m_intGeShu_Col):=IntToStr(intCount);
    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+11,m_intGongZuoLiang_Col):=IntToStr(intCount);
    ExcelWorkbook1.Save;
    ExcelWorkbook1.Close;
    ExcelApplication1.Quit;
    ExcelApplication1:=Unassigned;

    result:=0;

end;

procedure TGongZuoLiangTongJiForm.setJueSuanFieldName(iIndex: integer);
begin
  if iIndex<=0 then
      m_JueSuan_FieldName := 'can_juesuan'
  else
      m_JueSuan_FieldName := 'can_juesuan' + IntToStr(iIndex);
end;

procedure TGongZuoLiangTongJiForm.FormCreate(Sender: TObject);
begin
  setJueSuanFieldName(0);

  m_intBeginRowOfExcelFile :=3;
  m_intGeShu_Col := 6;
  m_intGongZuoLiang_Col := 7;
  m_strSQL_WhereClause_Drills_IsNot_JieKong := ' AND ((isJieKong is null) or (isJieKong<>'+BOOLEAN_True+'))';
end;

function TGongZuoLiangTongJiForm.getAllBoreInfo_Jie(strProjectCode: string;
  intTag: integer): Integer;
var
    ExcelApplication1:Variant;
    ExcelWorkbook1:Variant;
    range,sheet:Variant;
    xlsFileName:string;
    intDrillCount:Integer;   //��׸���
    dSumDrillDepth:Double; //��������
    intResult:integer;
    intRow,intCol:integer;
    strd_t_no:string;  //����ͺű��
    dblTmp:double;
begin

    if intTag=2 then strd_t_no:='1,2,4,5';   //½�Ͽ� ˮ�Ͽ�
    if intTag=5 then strd_t_no:='6,7';       // ���� ˫��
    if intTag=7 then strd_t_no:='3';       // �黨�꣨С�����꣩
     //���ͳ��
    ADO02_All.Close;
    ADO02_All.SQL.Text:='select * from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''
      +strProjectCode+''' and d_t_no in ('+strd_t_no+')' + ' AND isJieKong='+BOOLEAN_True;
    ADO02_All.Open;

    intDrillCount := 0;
    dSumDrillDepth:= 0;
    while not ADO02_All.Recordset.eof do
    begin
        intDrillCount := intDrillCount +1;
        dSumDrillDepth := dSumDrillDepth + ADO02_All.fieldByName('comp_depth').AsFloat;

        ADO02_All.Next;
    end;

    ADO02_All.Close;

    //׼��������д��ͳ��EXCEL�ļ�
    ExcelApplication1:=CreateOleObject('Excel.Application');
    ExcelWorkbook1:=CreateOleobject('Excel.Sheet');
    xlsFileName:=m_FullFileName_TongJi;
    ExcelWorkbook1:=ExcelApplication1.workBooks.Open(xlsFileName);
    Sheet:= ExcelApplication1.Activesheet;


    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+intTag, m_intGeShu_Col):= IntToStr(intDrillCount);
    ExcelApplication1.Cells(m_intBeginRowOfExcelFile+intTag, m_intGongZuoLiang_Col):= FormatFloat('0.00',dSumDrillDepth);


    ExcelWorkbook1.Save;
    ExcelWorkbook1.Close;
    ExcelApplication1.Quit;
    ExcelApplication1:=Unassigned;


    Result:=0;
end;

end.
