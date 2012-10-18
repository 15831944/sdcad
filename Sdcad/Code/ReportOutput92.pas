unit ReportOutput92;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ComCtrls,Dialogs, StdCtrls, ADODB, DB,ComObj,  Buttons,shellapi,
  ExtCtrls;

type
  TfrmCharge92 = class(TForm)
    SEFDlg: TSaveDialog;
    ADO02: TADOQuery;
    ADO02_All: TADOQuery;
    GroupBox4: TGroupBox;
    btnCreateReport: TBitBtn;
    STDir: TStaticText;
    btnBrowse: TBitBtn;
    ERP1: TEdit;
    btnOpenReport: TBitBtn;
    pbCreateReport: TProgressBar;
    procedure btnCreateReportClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnOpenReportClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    strProjectNo:string;
    strProjectName:string;
    strBuilderName:string;
    txtFile:textFile;
    m_FullFileName_TuLeiBieTongJi:string;//�������ͳ��EXCEL�ļ�XLS�ļ���ȫ·��
    strOutTxt:string;
    strPath:string;
    intUseRow:integer;
    intUseRow1:integer;
    intUseRow2:integer;
    intUseRow3:integer;
    intUseRow4:integer;
    intUseRowMax:integer;
    intPublicTag:integer; //0-½��,1-ˮ��,7-���ž�����̽,12-˫�ž�����̽
    zhuantanland_all:Array[0..999] of double;
    zhuantanland_one:Array[0..999] of double;
    strRecord:Array[0..12] of tstrings;
    intoverMax:integer;//������׼��ȵĶ���
    intoverMax_Max:integer;//��ǰ�����г�����׼��ȵ�������
    intoverNum:integer;
    m_intClass_Max:integer;
    m_intRecordCount:integer; //��¼д�뵽����ͳ���ļ��е�����
    m_isWritenTitle:Boolean;  //��¼�Ƿ�д����ͷ��    
    m_JueSuan_FieldName:string; //������ǰ���������ֶ��� �� can_juesuan can_juesuan1 can_juesuan9
    function getOneBoreInfo(strProjectCode: string;strBoreCode: string):integer;
    function getAllBoreInfo(strProjectCode: string;intTag:integer):integer;
    function getStandardThroughInfo(strProjectCode: string):integer;    //�����׼��������
    function getWhorlThroughInfo(strProjectCode: string):integer;       //����������
    function getProveMeasureInfo(strProjectCode: string):integer;       //��̽�����
    function getRomDustTestInfo(strProjectCode: string):integer;
    function getEarthWaterInfo(strProjectCode: string):integer;
    function getZhongLiChuTanInfo(strProjectCode: string):Integer;
    function WritetxtFile():integer;
    function getOneDrillStratumDepth(prj_no,drill_no:string;lstStra_NO,lstSub_NO:TStringList):Integer;
  public
    { Public declarations }
     procedure setJueSuanFieldName(iIndex:integer);//�ڲ���������������趨���趨����������������������ֶ�������can_juesuan + ����������ͱ����can_juesuan1 can_juesuan2������ʵ���ֶ���
  end;

var
  frmCharge92: TfrmCharge92;
  m_dCengShen_in_Class:Array[0..999] of double;  //ĳһ��׵�������ÿһ������еĳ���
implementation
   uses public_unit,MainDM;
{$R *.dfm}

function TfrmCharge92.getOneDrillStratumDepth(prj_no,drill_no:string;lstStra_NO,lstSub_NO:TStringList):Integer;
var
  i:integer;
  intRow:integer;
  intCol:integer;
  dblCount:double;
  intStratumCount:integer;//���̲�����
  dblStratum_begin:double; //ÿһ�㿪ʼ��ȣ�������һ��Ĳ��Ҳ����һ�������λ��
  dblStratum_end:double;   //����������λ��
  intClass:integer;
  intTag:integer;

  intLabel:Array[1..999] of integer;
  intTmp:integer;
  intClass_old:integer;

begin

  try

    intStratumCount := lststra_NO.Count;

    ADO02.Close;
    ADO02.SQL.Text:='select * from stratum '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+prj_no+''') '+
            'and prj_no='''+prj_no+''' and drl_no='''+stringReplace(drill_no ,'''','''''',[rfReplaceAll])+''' order by stra_depth';
    ADO02.Open;


    dblCount:=0;
    dblStratum_end:=0;
    intTag:=0;
    intTmp:=0;
    intClass_old:=0;
    intLabel[1]:=0;intLabel[2]:=10;intLabel[3]:=20;intLabel[4]:=30;
    intLabel[5]:=40;intLabel[6]:=50;intLabel[7]:=60;intLabel[8]:=80;
    intLabel[9]:=100;intLabel[10]:=120;intLabel[11]:=140;intLabel[12]:=160;
    intLabel[13]:=180;//13��һ����02��׼��û�У�ֻ��Ϊ�˳������жϲ������

    //��ʼ���������
    for intRow:=0 to 999 do
      m_dCengShen_in_Class[intRow] := 0;
    dblStratum_begin := 0;
    while not ADO02.Recordset.eof do
    begin
        dblStratum_end:=ADO02.fieldByName('stra_depth').Value;
        for intClass:=1 to 12 do
        begin
          if dblStratum_end>intLabel[intClass+1] then  //��������ĳһ����Χ�Ĵ�ֵ�����жϲ㿪ʼ������ڲ�����һ����
          begin
            if dblStratum_begin<=intLabel[intClass] then //�㿪ʼ����Ȳ�����һ���ڶ���С�ڵ�����һ����Сֵ ,�������һ������ֵ������һ���Ĵ�ֵ-Сֵ
              for i:=0 to intStratumCount-1 do
              begin
                if (ADO02.fieldByName('stra_no').AsString=lstStra_NO[i]) and (ADO02.fieldByName('sub_no').AsString=lstSub_NO[i]) then
                    m_dCengShen_in_Class[(intClass-1)*intStratumCount+i]:=intLabel[intClass+1]-intLabel[intClass];
              end
            else if (dblStratum_begin>intLabel[intClass]) and (dblStratum_begin<=intLabel[intClass+1]) then ////�㿪ʼ���������һ���� ,�������һ������ֵ������һ���Ĵ�ֵ-�㿪ʼ�����
              for i:=0 to intStratumCount-1 do
              begin
                if (ADO02.fieldByName('stra_no').AsString=lstStra_NO[i]) and (ADO02.fieldByName('sub_no').AsString=lstSub_NO[i]) then
                    m_dCengShen_in_Class[(intClass-1)*intStratumCount+i]:=intLabel[intClass+1]-dblStratum_begin;
              end
          end
          else if dblStratum_end>intLabel[intClass] then //����û�г���ĳһ����Χ�Ĵ�ֵ��Ҳ������һ����Сֵ�����жϲ㿪ʼ������ڲ�����һ����
          begin
            if dblStratum_begin<=intLabel[intClass] then  //һ��������intLabel[intClass]~intLabel[intClass+1]�׷�Χ��
              for i:=0 to intStratumCount-1 do
              begin
                if (ADO02.fieldByName('stra_no').AsString=lstStra_NO[i]) and (ADO02.fieldByName('sub_no').AsString=lstSub_NO[i]) then
                    m_dCengShen_in_Class[(intClass-1)*intStratumCount+i]:=dblStratum_end-intLabel[intClass];
              end
            else if (dblStratum_begin>intLabel[intClass]) then  //ȫ������intLabel[intClass]~intLabel[intClass+1]�׷�Χ��
              for i:=0 to intStratumCount-1 do
              begin
                if (ADO02.fieldByName('stra_no').AsString=lstStra_NO[i]) and (ADO02.fieldByName('sub_no').AsString=lstSub_NO[i]) then
                    m_dCengShen_in_Class[(intClass-1)*intStratumCount+i]:=dblStratum_end-dblStratum_begin;
              end
          end;

        end;
        dblStratum_begin := dblStratum_end;
        ADO02.Next;
    end;
    ADO02.Close;
  except
    result:=1;
    exit;
  end;
  result:=0;

end;

 //ȡ��һ�����������еĲ�ź��ǲ�źͲ�ĵȼ���02��׼ѡ02�ĵȼ��ֶΣ������ڶ���TStringList�����С�
procedure GetAllStratumNo(var AStratumNoList, ASubNoList, ACategoryList: TStringList);
var
  strSQL: string;
begin
  AStratumNoList.Clear;
  ASubNoList.Clear;
  ACategoryList.Clear;
  strSQL:='SELECT s.id,s.prj_no,s.stra_no,s.sub_no,s.stra_category,sc.category FROM stratum_description s LEFT JOIN stratumcategory92 sc on s.stra_category92=sc.id '
      +' WHERE s.prj_no='+''''+g_ProjectInfo.prj_no_ForSQL+''''
      +' ORDER BY s.id';
  with MainDataModule.qryStratum do
    begin
      close;
      sql.Clear;
      sql.Add(strSQL);
      open;
      while not eof do
        begin
          AStratumNoList.Add(FieldByName('stra_no').AsString);
          ASubNoList.Add(FieldByName('sub_no').AsString);
          ACategoryList.Add(FieldByName('category').AsString);
          next;
        end;
      close;
    end;
end;


//�õ���ǰ��Ŀ�������(��̽)������(½��,ˮ��,���ž�����̽,˫�ž�����̽һ������)
//strProjectCode:��Ŀ���
//intTag:0-½��,1-ˮ��,7-���ž�����̽,12-˫�ž�����̽
function TfrmCharge92.getAllBoreInfo(strProjectCode:string;intTag:integer):integer;
var
    ExcelApplication1:Variant;
    ExcelWorkbook1:Variant;
    range,sheet:Variant;
    xlsFileName:string;
    intResult:integer;
    intRow,intCol:integer;
    strd_t_no:string;  //����ͺű��
    dblTmp:double;
    i:integer;

    iTmp :Integer;
    //���          �ǲ��    �������
  lstStratumNo, lstSubNo, lstCategory: TStringList;
type
  TTuLeiBie=array[0..10] of string;

const
  iTuLeiBieBeginRow = 6; //�������ͳ���п�ʼд����׺ź͸�����𳤶����� �Ŀ�ʼ��
  iTuLeiBieBeginCol = 1; //�������ͳ���п�ʼд����׺ź͸�����𳤶����� �Ŀ�ʼ��
  //iTuLeiBieColCount = 8; //�������ͳ����ÿ����ȷ�Χ�ڵ����������
  TuLeiBie:TTuLeiBie = ('0~10m' ,'10~20m','20~30m','30~40m','40~50m','50~75m','75~100m','100~120m','120~140m','140~160m','160~180m');

begin
    lstStratumNo:= TStringList.Create;
    lstSubNo:= TStringList.Create;
    lstCategory := TStringList.Create;
    GetAllStratumNo(lstStratumNo,lstSubNo, lstCategory);
    //��ʼ���������
    for intRow:=0 to 999 do
    begin
        zhuantanland_one[intRow]:=0;
        zhuantanland_all[intRow]:=0;
    end;
    if intTag=0 then strd_t_no:='1,4,5';
    if intTag=1 then strd_t_no:='2';
    if intTag=7 then strd_t_no:='6';
    if intTag=12 then strd_t_no:='7';

    ADO02_All.Close;
    ADO02_All.SQL.Text:='select * from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''' and d_t_no in ('+strd_t_no+')';
    ADO02_All.Open;

    //׼����������������д���������ͳ��EXCEL�ļ�
    ExcelApplication1:=CreateOleObject('Excel.Application');
    ExcelWorkbook1:=CreateOleobject('Excel.Sheet');
    xlsFileName:=m_FullFileName_TuLeiBieTongJi;
    ExcelWorkbook1:=ExcelApplication1.workBooks.Open(xlsFileName);
    Sheet:= ExcelApplication1.Activesheet;
    if not m_isWritenTitle then //��ͷֻдһ��
    begin
      m_isWritenTitle := True;
      //���̱�ź͵�λ����
      ExcelApplication1.Cells(1,3):= strProjectNo;
      ExcelApplication1.Cells(2,3):=strProjectName;
      //������ÿһ����ȷ�Χ�������в���ѭ����
      for itmp := 10 downto 0 do  //itmp=0 0~10m ,1 10~20m, 2 20~30m,  3 30~40m,  4 40~50m,  5 50~75m,  6 75~100m,  7 100~120m,  8 120~140m,  9 140~160m,  10 160~180m,
      begin
      //�ϲ���Ԫ��,��ȷ�Χ

        Range:= ExcelApplication1.Range[sheet.cells[3,iTuLeiBieBeginCol+itmp*lstStratumNo.Count+1],sheet.cells[3,iTuLeiBieBeginCol+(itmp+1)*lstStratumNo.Count]];
        //Range.select;
        Range.merge;
        //ExcelApplication1.Cells(3,iTuLeiBieBeginCol+itmp*lstStratumNo.Count+1):= TuLeiBie[iTmp];
        //RangeString:=chr(65+iTuLeiBieBeginCol+itmp*lstStratumNo.Count+1) +'3'
        //  +':'+chr(65+iTuLeiBieBeginCol+(itmp+1)*lstStratumNo.Count+1) + '3';
        //RangeString:= IntToStr(iTuLeiBieBeginCol+itmp*lstStratumNo.Count+1)+':'+inttostr(65+iTuLeiBieBeginCol+(itmp+1)*lstStratumNo.Count+1);
        //ExcelApplication1.Range[Range].Merge;
        Range.FormulaR1C1:=TuLeiBie[iTmp];//�ϲ���д���ı�
        //ExcelApplication1.Range[Range].Borders.LineStyle:=1;
        Range.Borders.LineStyle:=1;//�ӱ߿�
        //Range.merge;
        //һ������°������еĲ��ŵķ�Χ�ӱ߿�
        Range:= ExcelApplication1.Range[sheet.cells[4,iTuLeiBieBeginCol+itmp*lstStratumNo.Count+1],sheet.cells[4,iTuLeiBieBeginCol+(itmp+1)*lstStratumNo.Count]];
        Range.Borders.LineStyle:=1;//�ӱ߿�

        //һ������°������еĲ����ķ�Χ�ӱ߿�
        Range:= ExcelApplication1.Range[sheet.cells[5,iTuLeiBieBeginCol+itmp*lstStratumNo.Count+1],sheet.cells[5,iTuLeiBieBeginCol+(itmp+1)*lstStratumNo.Count]];
        Range.Borders.LineStyle:=1;//�ӱ߿�
      end;
      for itmp := 0 to 10 do
      begin
        for i:=0 to lstStratumNo.Count-1 do
        begin
          ////����
          if lstSubNo[i]='0' then
            ExcelApplication1.Cells(4,iTuLeiBieBeginCol+itmp*lstStratumNo.Count+1+i):= lstStratumNo[i]
          else
            ExcelApplication1.Cells(4,iTuLeiBieBeginCol+itmp*lstStratumNo.Count+1+i):= lstStratumNo[i]+'_'+lstSubNo[i];

          //�����
          ExcelApplication1.Cells(5,iTuLeiBieBeginCol+itmp*lstStratumNo.Count+1+i):= lstCategory[i];
        end;
      end;
    end;
    while not ADO02_All.Recordset.eof do
    begin
        intoverMax:=0;
        intResult := getOneDrillStratumDepth(ADO02_All.fieldByName('prj_no').AsString,ADO02_All.fieldByName('drl_no').AsString,lstStratumNo,lstSubNo);

        intResult:=getOneBoreInfo(ADO02_All.fieldByName('prj_no').AsString,ADO02_All.fieldByName('drl_no').AsString);

        //��׺�
        ExcelApplication1.Cells(iTuLeiBieBeginRow+m_intRecordCount, iTuLeiBieBeginCol):= ADO02_All.fieldByName('drl_no').AsString;
        //���������ͳ�����
        for itmp := 0 to 11*lstStratumNo.Count-1 do  //itmp=0 0~10m ,1 10~20m, 2 20~30m,  3 30~40m,  4 40~50m,  5 50~75m,  6 75~100m,  7 100~120m,  8 120~140m,  9 140~160m,  10 160~180m
        begin
          ExcelApplication1.Cells(iTuLeiBieBeginRow+m_intRecordCount, iTuLeiBieBeginCol+iTmp+1):= FormatFloat('0.00',m_dCengShen_in_Class[iTmp]);
        end;
        //������Ӧ�����  //����ע�������ǣ���Ϊ�����ͳ�ƺ���ǰ��һ���������ǰ��������ͳ����ȣ����ǰ��������ͳ�����
//        for itmp := 0 to 10 do  //itmp=0 0~10m ,1 10~20m, 2 20~30m,  3 30~40m,  4 40~50m,  5 50~75m,  6 75~100m,  7 100~120m,  8 120~140m,  9 140~160m,  10 160~180m,
//        begin
//            ExcelApplication1.Cells(iTuLeiBieBeginRow+intRecordTag, iTuLeiBieBeginCol+iTuLeiBieColCount*iTmp+1):= FormatFloat('0.00',zhuantanland_one[10*iTmp+0]);
//            ExcelApplication1.Cells(iTuLeiBieBeginRow+intRecordTag, iTuLeiBieBeginCol+iTuLeiBieColCount*iTmp+2):= FormatFloat('0.00',zhuantanland_one[10*iTmp+1]);
//            ExcelApplication1.Cells(iTuLeiBieBeginRow+intRecordTag, iTuLeiBieBeginCol+iTuLeiBieColCount*iTmp+3):= FormatFloat('0.00',zhuantanland_one[10*iTmp+2]);
//            ExcelApplication1.Cells(iTuLeiBieBeginRow+intRecordTag, iTuLeiBieBeginCol+iTuLeiBieColCount*iTmp+4):= FormatFloat('0.00',zhuantanland_one[10*iTmp+3]);
//            ExcelApplication1.Cells(iTuLeiBieBeginRow+intRecordTag, iTuLeiBieBeginCol+iTuLeiBieColCount*iTmp+5):= FormatFloat('0.00',zhuantanland_one[10*iTmp+4]);
//            ExcelApplication1.Cells(iTuLeiBieBeginRow+intRecordTag, iTuLeiBieBeginCol+iTuLeiBieColCount*iTmp+6):= FormatFloat('0.00',zhuantanland_one[10*iTmp+5]);
//            ExcelApplication1.Cells(iTuLeiBieBeginRow+intRecordTag, iTuLeiBieBeginCol+iTuLeiBieColCount*iTmp+7):= FormatFloat('0.00',zhuantanland_one[10*iTmp+6]);
//            ExcelApplication1.Cells(iTuLeiBieBeginRow+intRecordTag, iTuLeiBieBeginCol+iTuLeiBieColCount*iTmp+8):= FormatFloat('0.00',zhuantanland_one[10*iTmp+7]);
//        end;

        for intRow:=0 to 999 do
            zhuantanland_all[intRow]:=zhuantanland_all[intRow]+zhuantanland_one[intRow];

        m_intRecordCount:=m_intRecordCount+1;

        ADO02_All.Next;
    end;
    //����д���������ͳ��EXCEL�ļ�
    ExcelWorkbook1.Save;
    ExcelWorkbook1.Close;
    ExcelApplication1.Quit;
    ExcelApplication1:=Unassigned;

    
    for intRow:=0 to 999 do
      zhuantanland_all[intRow]:=StrtoFloat(FormatFloat('0.00',zhuantanland_all[intRow]));

    //д��EXCEL�ļ�
    ExcelApplication1:=CreateOleObject('Excel.Application');
    ExcelWorkbook1:=CreateOleobject('Excel.Sheet');
    xlsFileName:=ERP1.Text;
    ExcelWorkbook1:=ExcelApplication1.workBooks.Open(xlsFileName);
    //���̱�ź͵�λ����
    ExcelApplication1.Cells(3,5):= strProjectNo;
    ExcelApplication1.Cells(4,5):=strProjectName;
    //intTag:0-½��,1-ˮ��,7-���ž�����̽,12-˫�ž�����̽
    intRow:=0;
    if (intTag =0) or (intTag=1) then  // intTag:0-½��,1-ˮ�� ������EXCEL�еĸ�ʽһ����ֻ�ǲ�ͬ��
    begin
      ExcelApplication1.Cells(9,4+intTag):=zhuantanland_all[0];       //��̽,½�Ϲ�����(0~10��,I)
      ExcelApplication1.Cells(10,4+intTag):=zhuantanland_all[1];      //��̽,½�Ϲ�����(0~10��,II)
      ExcelApplication1.Cells(11,4+intTag):=zhuantanland_all[2];      //��̽,½�Ϲ�����(0~10��,III)
      ExcelApplication1.Cells(12,4+intTag):=zhuantanland_all[3];      //��̽,½�Ϲ�����(0~10��,IV)
      ExcelApplication1.Cells(13,4+intTag):=zhuantanland_all[4];      //��̽,½�Ϲ�����(0~10��,V)

      ExcelApplication1.Cells(14,4+intTag):=zhuantanland_all[10];     //��̽,½�Ϲ�����(10~20��,I)
      ExcelApplication1.Cells(15,4+intTag):=zhuantanland_all[11];     //��̽,½�Ϲ�����(10~20��,II)
      ExcelApplication1.Cells(16,4+intTag):=zhuantanland_all[12];     //��̽,½�Ϲ�����(10~20��,III)
      ExcelApplication1.Cells(17,4+intTag):=zhuantanland_all[13];     //��̽,½�Ϲ�����(10~20��,IV)
      ExcelApplication1.Cells(18,4+intTag):=zhuantanland_all[14];     //��̽,½�Ϲ�����(10~20��,V)

      ExcelApplication1.Cells(19,4+intTag):=zhuantanland_all[20];     //��̽,½�Ϲ�����(20~30��,I)
      ExcelApplication1.Cells(20,4+intTag):=zhuantanland_all[21];     //��̽,½�Ϲ�����(20~30��,II)
      ExcelApplication1.Cells(21,4+intTag):=zhuantanland_all[22];     //��̽,½�Ϲ�����(20~30��,III)
      ExcelApplication1.Cells(22,4+intTag):=zhuantanland_all[23];     //��̽,½�Ϲ�����(20~30��,IV)
      ExcelApplication1.Cells(23,4+intTag):=zhuantanland_all[24];     //��̽,½�Ϲ�����(20~30��,V)

      ExcelApplication1.Cells(24,4+intTag):=zhuantanland_all[30];     //��̽,½�Ϲ�����(30~40��,I)
      ExcelApplication1.Cells(25,4+intTag):=zhuantanland_all[31];     //��̽,½�Ϲ�����(30~40��,II)
      ExcelApplication1.Cells(26,4+intTag):=zhuantanland_all[32];     //��̽,½�Ϲ�����(30~40��,III)
      ExcelApplication1.Cells(27,4+intTag):=zhuantanland_all[33];     //��̽,½�Ϲ�����(30~40��,IV)
      ExcelApplication1.Cells(28,4+intTag):=zhuantanland_all[34];     //��̽,½�Ϲ�����(30~40��,V)

      ExcelApplication1.Cells(29,4+intTag):=zhuantanland_all[40];     //��̽,½�Ϲ�����(40~50��,I)
      ExcelApplication1.Cells(30,4+intTag):=zhuantanland_all[41];     //��̽,½�Ϲ�����(40~50��,II)
      ExcelApplication1.Cells(31,4+intTag):=zhuantanland_all[42];     //��̽,½�Ϲ�����(40~50��,III)
      ExcelApplication1.Cells(32,4+intTag):=zhuantanland_all[43];     //��̽,½�Ϲ�����(40~50��,IV)
      ExcelApplication1.Cells(33,4+intTag):=zhuantanland_all[44];     //��̽,½�Ϲ�����(40~50��,V)

      ExcelApplication1.Cells(34,4+intTag):=zhuantanland_all[50];     //��̽,½�Ϲ�����(50~75��,I)
      ExcelApplication1.Cells(35,4+intTag):=zhuantanland_all[51];     //��̽,½�Ϲ�����(50~75��,II)
      ExcelApplication1.Cells(36,4+intTag):=zhuantanland_all[52];     //��̽,½�Ϲ�����(50~75��,III)
      ExcelApplication1.Cells(37,4+intTag):=zhuantanland_all[53];     //��̽,½�Ϲ�����(50~75��,IV)
      ExcelApplication1.Cells(38,4+intTag):=zhuantanland_all[54];     //��̽,½�Ϲ�����(50~75��,V)

      ExcelApplication1.Cells(39,4+intTag):=zhuantanland_all[60];     //��̽,½�Ϲ�����(75~100��,I)
      ExcelApplication1.Cells(40,4+intTag):=zhuantanland_all[61];     //��̽,½�Ϲ�����(75~100��,II)
      ExcelApplication1.Cells(41,4+intTag):=zhuantanland_all[62];     //��̽,½�Ϲ�����(75~100��,III)
      ExcelApplication1.Cells(42,4+intTag):=zhuantanland_all[63];     //��̽,½�Ϲ�����(75~100��,IV)
      ExcelApplication1.Cells(43,4+intTag):=zhuantanland_all[64];     //��̽,½�Ϲ�����(75~100��,V)

      ExcelApplication1.Cells(44,4+intTag):=zhuantanland_all[70];     //��̽,½�Ϲ�����(100~120��,I)
      ExcelApplication1.Cells(45,4+intTag):=zhuantanland_all[71];     //��̽,½�Ϲ�����(100~120��,II)
      ExcelApplication1.Cells(46,4+intTag):=zhuantanland_all[72];     //��̽,½�Ϲ�����(100~120��,III)
      ExcelApplication1.Cells(47,4+intTag):=zhuantanland_all[73];     //��̽,½�Ϲ�����(100~120��,IV)
      ExcelApplication1.Cells(48,4+intTag):=zhuantanland_all[74];     //��̽,½�Ϲ�����(100~120��,V)

      ExcelApplication1.Cells(49,4+intTag):=zhuantanland_all[80];     //��̽,½�Ϲ�����(120~140��,I)
      ExcelApplication1.Cells(50,4+intTag):=zhuantanland_all[81];     //��̽,½�Ϲ�����(120~140��,II)
      ExcelApplication1.Cells(51,4+intTag):=zhuantanland_all[82];     //��̽,½�Ϲ�����(120~140��,III)
      ExcelApplication1.Cells(52,4+intTag):=zhuantanland_all[83];     //��̽,½�Ϲ�����(120~140��,IV)
      ExcelApplication1.Cells(53,4+intTag):=zhuantanland_all[84];     //��̽,½�Ϲ�����(120~140��,V)

      ExcelApplication1.Cells(54,4+intTag):=zhuantanland_all[90];     //��̽,½�Ϲ�����(140~160��,I)
      ExcelApplication1.Cells(55,4+intTag):=zhuantanland_all[91];     //��̽,½�Ϲ�����(140~160��,II)
      ExcelApplication1.Cells(56,4+intTag):=zhuantanland_all[92];     //��̽,½�Ϲ�����(140~160��,III)
      ExcelApplication1.Cells(57,4+intTag):=zhuantanland_all[93];     //��̽,½�Ϲ�����(140~160��,IV)
      ExcelApplication1.Cells(58,4+intTag):=zhuantanland_all[94];     //��̽,½�Ϲ�����(140~160��,V)

      ExcelApplication1.Cells(59,4+intTag):=zhuantanland_all[100];     //��̽,½�Ϲ�����(160~180��,I)
      ExcelApplication1.Cells(60,4+intTag):=zhuantanland_all[101];     //��̽,½�Ϲ�����(160~180��,II)
      ExcelApplication1.Cells(61,4+intTag):=zhuantanland_all[102];     //��̽,½�Ϲ�����(160~180��,III)
      ExcelApplication1.Cells(62,4+intTag):=zhuantanland_all[103];     //��̽,½�Ϲ�����(160~180��,IV)
      ExcelApplication1.Cells(63,4+intTag):=zhuantanland_all[104];     //��̽,½�Ϲ�����(160~180��,V)
    end
    else if intTag=7 then // 7-���ž�����̽
    begin
      ExcelApplication1.Cells(9,11):=zhuantanland_all[0];       //��̽,(0~10��,I)
      ExcelApplication1.Cells(10,11):=zhuantanland_all[1];      //��̽,(0~10��,II)
      ExcelApplication1.Cells(11,11):=zhuantanland_all[2];      //��̽,(0~10��,III)

      ExcelApplication1.Cells(12,11):=zhuantanland_all[10];     //��̽,(10~20��,I)
      ExcelApplication1.Cells(13,11):=zhuantanland_all[11];     //��̽,(10~20��,II)
      ExcelApplication1.Cells(14,11):=zhuantanland_all[12];     //��̽,(10~20��,III)

      ExcelApplication1.Cells(15,11):=zhuantanland_all[20];     //��̽,(20~30��,I)
      ExcelApplication1.Cells(16,11):=zhuantanland_all[21];     //��̽,(20~30��,II)
      ExcelApplication1.Cells(17,11):=zhuantanland_all[22];     //��̽,(20~30��,III)

      ExcelApplication1.Cells(18,11):=zhuantanland_all[30];     //��̽,(30~40��,I)
      ExcelApplication1.Cells(19,11):=zhuantanland_all[31];     //��̽,(30~40��,II)
      ExcelApplication1.Cells(20,11):=zhuantanland_all[32];     //��̽,(30~40��,III)

    end
    else if intTag=12 then // 12-˫�ž�����̽
    begin
      ExcelApplication1.Cells(25,11):=zhuantanland_all[0];       //��̽,(0~10��,I)
      ExcelApplication1.Cells(26,11):=zhuantanland_all[1];      //��̽,(0~10��,II)
      ExcelApplication1.Cells(27,11):=zhuantanland_all[2];      //��̽,(0~10��,III)

      ExcelApplication1.Cells(28,11):=zhuantanland_all[10];     //��̽,(10~20��,I)
      ExcelApplication1.Cells(29,11):=zhuantanland_all[11];     //��̽,(10~20��,II)
      ExcelApplication1.Cells(30,11):=zhuantanland_all[12];     //��̽,(10~20��,III)

      ExcelApplication1.Cells(31,11):=zhuantanland_all[20];     //��̽,(20~30��,I)
      ExcelApplication1.Cells(32,11):=zhuantanland_all[21];     //��̽,(20~30��,II)
      ExcelApplication1.Cells(33,11):=zhuantanland_all[22];     //��̽,(20~30��,III)

      ExcelApplication1.Cells(34,11):=zhuantanland_all[30];     //��̽,(30~40��,I)
      ExcelApplication1.Cells(35,11):=zhuantanland_all[31];     //��̽,(30~40��,II)
      ExcelApplication1.Cells(36,11):=zhuantanland_all[32];     //��̽,(30~40��,III)

      ExcelApplication1.Cells(37,11):=zhuantanland_all[40];       //��̽,(40~50��,I)
      ExcelApplication1.Cells(38,11):=zhuantanland_all[41];      //��̽,(40~50��,II)
      ExcelApplication1.Cells(39,11):=zhuantanland_all[42];      //��̽,(40~50��,III)

      ExcelApplication1.Cells(40,11):=zhuantanland_all[50];     //��̽,(50~75��,I)
      ExcelApplication1.Cells(41,11):=zhuantanland_all[51];     //��̽,(50~75��,II)
      ExcelApplication1.Cells(42,11):=zhuantanland_all[52];     //��̽,(50~75��,III)

      ExcelApplication1.Cells(43,11):=zhuantanland_all[60];     //��̽,(75~100��,I)
      ExcelApplication1.Cells(44,11):=zhuantanland_all[61];     //��̽,(75~100��,II)
      ExcelApplication1.Cells(45,11):=zhuantanland_all[62];     //��̽,(75~100��,III)

      ExcelApplication1.Cells(46,11):=zhuantanland_all[70];     //��̽,(100~120��,I)
      ExcelApplication1.Cells(47,11):=zhuantanland_all[71];     //��̽,(100~120��,II)
      ExcelApplication1.Cells(48,11):=zhuantanland_all[72];     //��̽,(100~120��,III)
    end;


    if (intTag=0) and (m_intClass_Max<>0) then
    begin
        for i:=10 to intoverMax do
        begin
            Sheet:= ExcelApplication1.Activesheet;
            ExcelWorkbook1.Application.Rows[35+intUseRow1*3].insert;
            ExcelWorkbook1.Application.Rows[35+intUseRow1*3].insert;
            ExcelWorkbook1.Application.Rows[35+intUseRow1*3].insert;

            ExcelApplication1.Cells(35+intUseRow1*3,3):='I';
            ExcelApplication1.Cells[35+intUseRow1*3,3].Borders.LineStyle:=1;
            ExcelApplication1.Cells(35+intUseRow1*3+1,3):='II';
            ExcelApplication1.Cells[35+intUseRow1*3+1,3].Borders.LineStyle:=1;
            ExcelApplication1.Cells(35+intUseRow1*3+2,3):='III';
            ExcelApplication1.Cells[35+intUseRow1*3+2,3].Borders.LineStyle:=1;

            ExcelApplication1.Cells(35+intUseRow1*3+1,6):='=R[-3]C*1.2';
            ExcelApplication1.Cells[35+intUseRow1*3+1,6].Borders.LineStyle:=1;
            ExcelApplication1.Cells(35+intUseRow1*3+2,6):='=R[-3]C*1.2';
            ExcelApplication1.Cells[35+intUseRow1*3+2,6].Borders.LineStyle:=1;

            ExcelApplication1.Cells(35+intUseRow1*3,7):='=RC[-3]*RC[-1]';
            ExcelApplication1.Cells[35+intUseRow1*3,7].Borders.LineStyle:=1;
            ExcelApplication1.Cells(35+intUseRow1*3,8):='=RC[-3]*RC[-2]';
            ExcelApplication1.Cells[35+intUseRow1*3,8].Borders.LineStyle:=1;
            ExcelApplication1.Cells(35+intUseRow1*3+1,7):='=RC[-3]*RC[-1]';
            ExcelApplication1.Cells[35+intUseRow1*3+1,7].Borders.LineStyle:=1;
            ExcelApplication1.Cells(35+intUseRow1*3+1,8):='=RC[-3]*RC[-2]';
            ExcelApplication1.Cells[35+intUseRow1*3+1,8].Borders.LineStyle:=1;
            ExcelApplication1.Cells(35+intUseRow1*3+2,7):='=RC[-3]*RC[-1]';
            ExcelApplication1.Cells[35+intUseRow1*3+2,7].Borders.LineStyle:=1;
            ExcelApplication1.Cells(35+intUseRow1*3+2,8):='=RC[-3]*RC[-2]';
            ExcelApplication1.Cells[35+intUseRow1*3+2,8].Borders.LineStyle:=1;

            ExcelApplication1.Cells(35+intUseRow1*3,4):=zhuantanland_all[(intUseRow1+9)*10];
            ExcelApplication1.Cells[35+intUseRow1*3,4].Borders.LineStyle:=1;
            ExcelApplication1.Cells(35+intUseRow1*3+1,4):=zhuantanland_all[(intUseRow1+9)*10+1];
            ExcelApplication1.Cells[35+intUseRow1*3+1,4].Borders.LineStyle:=1;
            ExcelApplication1.Cells(35+intUseRow1*3+2,4):=zhuantanland_all[(intUseRow1+9)*10+2];
            ExcelApplication1.Cells[35+intUseRow1*3+2,4].Borders.LineStyle:=1;
            //�ϲ���Ԫ��

            Range:= ExcelApplication1.Range[sheet.cells[35+intUseRow1*3,2],sheet.cells[35+intUseRow1*3+2,2]];
            Range.merge;
            Range.FormulaR1C1:=PCHAR(FormatFloat('0',(160+intUseRow1*20))) + '~'+PCHAR(FormatFloat('0',(180+intUseRow1*20)))+' m';//�ϲ���д���ı�
            //�ϲ���Ԫ��
            Range.Borders.LineStyle:=1;//�ӱ߿�
            intUseRow1:=intUseRow1+1;
        end;
        if intUseRowMax<intUseRow1 then intUseRowMax:=intUseRow1;
    end;

    if (intTag=1)  and (m_intClass_Max<>0) then
    begin
        for i:=10 to intoverMax do
        begin
            if (i>intoverMax_Max) or (i>intUseRowMax+9) then
            begin
                ExcelWorkbook1.Application.Rows[35+intUseRow2*3].insert;
                ExcelWorkbook1.Application.Rows[35+intUseRow2*3].insert;
                ExcelWorkbook1.Application.Rows[35+intUseRow2*3].insert;

                ExcelApplication1.Cells(35+intUseRow2*3,3):='I';
                ExcelApplication1.Cells[35+intUseRow2*3,3].Borders.LineStyle:=1;
                ExcelApplication1.Cells(35+intUseRow2*3+1,3):='II';
                ExcelApplication1.Cells[35+intUseRow2*3+1,3].Borders.LineStyle:=1;
                ExcelApplication1.Cells(35+intUseRow2*3+2,3):='III';
                ExcelApplication1.Cells[35+intUseRow2*3+2,3].Borders.LineStyle:=1;

                ExcelApplication1.Cells(35+intUseRow2*3+1,6):='=R[-3]C*1.2';
                ExcelApplication1.Cells[35+intUseRow2*3+1,6].Borders.LineStyle:=1;
                ExcelApplication1.Cells(35+intUseRow2*3+2,6):='=R[-3]C*1.2';
                ExcelApplication1.Cells[35+intUseRow2*3+2,6].Borders.LineStyle:=1;
                ExcelApplication1.Cells(35+intUseRow2*3,7):='=RC[-3]*RC[-1]';
                ExcelApplication1.Cells[35+intUseRow2*3,7].Borders.LineStyle:=1;
                ExcelApplication1.Cells(35+intUseRow2*3,8):='=RC[-3]*RC[-2]';
                ExcelApplication1.Cells[35+intUseRow2*3,8].Borders.LineStyle:=1;
                ExcelApplication1.Cells(35+intUseRow2*3+1,7):='=RC[-3]*RC[-1]';
                ExcelApplication1.Cells[35+intUseRow2*3+1,7].Borders.LineStyle:=1;
                ExcelApplication1.Cells(35+intUseRow2*3+1,8):='=RC[-3]*RC[-2]';
                ExcelApplication1.Cells[35+intUseRow2*3+1,8].Borders.LineStyle:=1;
                ExcelApplication1.Cells(35+intUseRow2*3+2,7):='=RC[-3]*RC[-1]';
                ExcelApplication1.Cells[35+intUseRow2*3+2,7].Borders.LineStyle:=1;
                ExcelApplication1.Cells(35+intUseRow2*3+2,8):='=RC[-3]*RC[-2]';
                ExcelApplication1.Cells[35+intUseRow2*3+2,8].Borders.LineStyle:=1;
                ExcelApplication1.Cells(35+intUseRow2*3,5):=zhuantanland_all[(intUseRow2+9)*10];
                ExcelApplication1.Cells[35+intUseRow2*3,5].Borders.LineStyle:=1;
                ExcelApplication1.Cells(35+intUseRow2*3+1,5):=zhuantanland_all[(intUseRow2+9)*10+1];
                ExcelApplication1.Cells[35+intUseRow2*3+1,5].Borders.LineStyle:=1;
                ExcelApplication1.Cells(35+intUseRow2*3+2,5):=zhuantanland_all[(intUseRow2+9)*10+2];
                ExcelApplication1.Cells[35+intUseRow2*3+2,5].Borders.LineStyle:=1;
                //�ϲ���Ԫ��
                Sheet:= ExcelApplication1.Activesheet;
                Range:= ExcelApplication1.Range[sheet.cells[35+intUseRow2*3,2],sheet.cells[35+intUseRow2*3+2,2]];
                Range.merge;
                Range.FormulaR1C1:=PCHAR(FormatFloat('0',(160+intUseRow2*20))) + '~'+PCHAR(FormatFloat('0',(180+intUseRow2*20)))+' m';//�ϲ���д���ı�
                //�ϲ���Ԫ��
                Range.Borders.LineStyle:=1;//�ӱ߿�
                intUseRow2:=intUseRow2+1
            end
            else
            begin
                ExcelApplication1.Cells(35+intUseRow2*3,5):=zhuantanland_all[(intUseRow2+9)*10];
                ExcelApplication1.Cells[35+intUseRow2*3,5].Borders.LineStyle:=1;
                ExcelApplication1.Cells(35+intUseRow2*3+1,5):=zhuantanland_all[(intUseRow2+9)*10+1];
                ExcelApplication1.Cells[35+intUseRow2*3+1,5].Borders.LineStyle:=1;
                ExcelApplication1.Cells(35+intUseRow2*3+2,5):=zhuantanland_all[(intUseRow2+9)*10+2];
                ExcelApplication1.Cells[35+intUseRow2*3+2,5].Borders.LineStyle:=1;
                intUseRow2:=intUseRow2+1;
            end;
         end;
         if intUseRowMax<intUseRow2 then intUseRowMax:=intUseRow2;
    end;

    if (intTag=7)  and (m_intClass_Max<>0) then
    begin
        for i:=9  to intoverMax do
            begin
                if  (i>intoverMax_Max) or (i>intUseRowMax+8) then
                begin
                    ExcelWorkbook1.Application.Rows[35+intUseRow3*3].insert;
                    ExcelWorkbook1.Application.Rows[35+intUseRow3*3].insert;
                    ExcelWorkbook1.Application.Rows[35+intUseRow3*3].insert;

                    ExcelApplication1.Cells(35+intUseRow3*3,10):='I';
                    ExcelApplication1.Cells[35+intUseRow3*3,10].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow3*3+1,10):='II';
                    ExcelApplication1.Cells[35+intUseRow3*3+1,10].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow3*3+2,10):='III';
                    ExcelApplication1.Cells[35+intUseRow3*3+2,10].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow3*3+1,12):='=R[-3]C*1.2';
                    ExcelApplication1.Cells[35+intUseRow3*3+1,12].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow3*3+2,12):='=R[-3]C*1.2';
                    ExcelApplication1.Cells[35+intUseRow3*3+2,12].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow3*3,13):='=RC[-2]*RC[-1]';
                    ExcelApplication1.Cells[35+intUseRow3*3,13].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow3*3+1,13):='=RC[-2]*RC[-1]';
                    ExcelApplication1.Cells[35+intUseRow3*3+1,13].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow3*3+2,13):='=RC[-2]*RC[-1]';
                    ExcelApplication1.Cells[35+intUseRow3*3+2,13].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow3*3,11):=zhuantanland_all[(intUseRow3+8)*10];
                    ExcelApplication1.Cells[35+intUseRow3*3,11].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow3*3+1,11):=zhuantanland_all[(intUseRow3+8)*10+1];
                    ExcelApplication1.Cells[35+intUseRow3*3+1,11].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow3*3+2,11):=zhuantanland_all[(intUseRow3+8)*10+2];
                    ExcelApplication1.Cells[35+intUseRow3*3+2,11].Borders.LineStyle:=1;
                    //�ϲ���Ԫ��
                    Sheet:= ExcelApplication1.Activesheet;
                    Range:= ExcelApplication1.Range[sheet.cells[35+intUseRow3*3,9],sheet.cells[35+intUseRow3*3+2,9]];
                    Range.merge;
                    Range.FormulaR1C1:=PCHAR(FormatFloat('0',(100+intUseRow3*20))) + '~'+PCHAR(FormatFloat('0',(120+intUseRow3*20)))+' m';//�ϲ���д���ı�
                    //�ϲ���Ԫ��
                    Range.Borders.LineStyle:=1;//�ӱ߿�
                    intUseRow3:=intUseRow3+1
                end
                else
                begin

                    ExcelApplication1.Cells(35+intUseRow3*3,10):='I';
                    ExcelApplication1.Cells[35+intUseRow3*3,10].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow3*3+1,10):='II';
                    ExcelApplication1.Cells[35+intUseRow3*3+1,10].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow3*3+2,10):='III';
                    ExcelApplication1.Cells[35+intUseRow3*3+2,10].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow3*3+1,12):='=R[-3]C*1.2';
                    ExcelApplication1.Cells[35+intUseRow3*3+1,12].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow3*3+2,12):='=R[-3]C*1.2';
                    ExcelApplication1.Cells[35+intUseRow3*3+2,12].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow3*3,13):='=RC[-2]*RC[-1]';
                    ExcelApplication1.Cells[35+intUseRow3*3,13].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow3*3+1,13):='=RC[-2]*RC[-1]';
                    ExcelApplication1.Cells[35+intUseRow3*3+1,13].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow3*3+2,13):='=RC[-2]*RC[-1]';
                    ExcelApplication1.Cells[35+intUseRow3*3+2,13].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow3*3,11):=zhuantanland_all[(intUseRow3+8)*10];
                    ExcelApplication1.Cells[35+intUseRow3*3,11].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow3*3+1,11):=zhuantanland_all[(intUseRow3+8)*10+1];
                    ExcelApplication1.Cells[35+intUseRow3*3+1,11].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow3*3+2,11):=zhuantanland_all[(intUseRow3+8)*10+2];
                    ExcelApplication1.Cells[35+intUseRow3*3+2,11].Borders.LineStyle:=1;

                    //�ϲ���Ԫ��
                    Sheet:= ExcelApplication1.Activesheet;
                    Range:= ExcelApplication1.Range[sheet.cells[35+intUseRow3*3,9],sheet.cells[35+intUseRow3*3+2,9]];
                    Range.merge;
                    Range.FormulaR1C1:=PCHAR(FormatFloat('0',(100+intUseRow3*20))) + '~'+PCHAR(FormatFloat('0',(120+intUseRow3*20)))+' m';//�ϲ���д���ı�
                    //�ϲ���Ԫ��
                    Range.Borders.LineStyle:=1;//�ӱ߿�
                    intUseRow3:=intUseRow3+1
                end;
            end;
          if intUseRowMax<intUseRow3 then intUseRowMax:=intUseRow3;
        end;


    if (intTag=12)  and (m_intClass_Max<>0) then
    begin
        for i:=9  to intoverMax do
            begin
                if  (i>intoverMax_Max) or (i>intUseRowMax+8) then
                begin
                    ExcelWorkbook1.Application.Rows[32+intUseRow4*3].insert;
                    ExcelWorkbook1.Application.Rows[32+intUseRow4*3].insert;
                    ExcelWorkbook1.Application.Rows[32+intUseRow4*3].insert;

                    ExcelApplication1.Cells(32+intUseRow4*3,15):='I';
                    ExcelApplication1.Cells[35+intUseRow4*3,15].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(32+intUseRow4*3+1,15):='II';
                    ExcelApplication1.Cells[35+intUseRow4*3,15].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(32+intUseRow4*3+2,15):='III';
                    ExcelApplication1.Cells[35+intUseRow4*3,15].Borders.LineStyle:=1;

                    ExcelApplication1.Cells(32+intUseRow4*3,17):='=R[-3]C*1.2';
                    ExcelApplication1.Cells[32+intUseRow4*3,17].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(32+intUseRow4*3+1,17):='=R[-3]C*1.2';
                    ExcelApplication1.Cells[32+intUseRow4*3+1,17].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(32+intUseRow4*3+2,17):='=R[-3]C*1.2';
                    ExcelApplication1.Cells[32+intUseRow4*3+2,17].Borders.LineStyle:=1;

                    ExcelApplication1.Cells(32+intUseRow4*3,18):='=RC[-2]*RC[-1]';
                    ExcelApplication1.Cells[32+intUseRow4*3,18].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(32+intUseRow4*3+1,18):='=RC[-2]*RC[-1]';
                    ExcelApplication1.Cells[32+intUseRow4*3+1,18].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(32+intUseRow4*3+2,18):='=RC[-2]*RC[-1]';
                    ExcelApplication1.Cells[32+intUseRow4*3+2,18].Borders.LineStyle:=1;

                    ExcelApplication1.Cells(32+intUseRow4*3,16):=zhuantanland_all[(intUseRow4+8)*10];
                    ExcelApplication1.Cells(32+intUseRow4*3+1,16):=zhuantanland_all[(intUseRow4+8)*10+1];
                    ExcelApplication1.Cells(32+intUseRow4*3+2,16):=zhuantanland_all[(intUseRow4+8)*10+2];

                    //�ϲ���Ԫ��
                    Sheet:= ExcelApplication1.Activesheet;
                    Range:= ExcelApplication1.Range[sheet.cells[32+intUseRow4*3,14],sheet.cells[32+intUseRow4*3+2,14]];
                    Range.merge;
                    Range.FormulaR1C1:=PCHAR(FormatFloat('0',(100+intUseRow4*20))) + '~'+PCHAR(FormatFloat('0',(120+intUseRow4*20)))+' m';//�ϲ���д���ı�
                    Range.Borders.LineStyle:=1;//�ӱ߿�
                    //�ϲ���Ԫ��
                    intUseRow4:=intUseRow4+1;
                end
                else
                begin
                    ExcelApplication1.Cells(35+intUseRow4*3,15):='I';
                    ExcelApplication1.Cells[35+intUseRow4*3,15].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow4*3+1,15):='II';
                    ExcelApplication1.Cells[35+intUseRow4*3,15].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow4*3+2,15):='III';
                    ExcelApplication1.Cells[35+intUseRow4*3,15].Borders.LineStyle:=1;

                    ExcelApplication1.Cells(35+intUseRow4*3,17):='=R[-3]C*1.2';
                    ExcelApplication1.Cells[35+intUseRow4*3,17].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow4*3+1,17):='=R[-3]C*1.2';
                    ExcelApplication1.Cells[35+intUseRow4*3+1,17].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow4*3+2,17):='=R[-3]C*1.2';
                    ExcelApplication1.Cells[35+intUseRow4*3+2,17].Borders.LineStyle:=1;

                    ExcelApplication1.Cells(35+intUseRow4*3,18):='=RC[-2]*RC[-1]';
                    ExcelApplication1.Cells[35+intUseRow4*3,18].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow4*3+1,18):='=RC[-2]*RC[-1]';
                    ExcelApplication1.Cells[35+intUseRow4*3+1,18].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow4*3+2,18):='=RC[-2]*RC[-1]';
                    ExcelApplication1.Cells[35+intUseRow4*3+2,18].Borders.LineStyle:=1;

                    ExcelApplication1.Cells(35+intUseRow4*3,16):=zhuantanland_all[(intUseRow4+8)*10];
                    ExcelApplication1.Cells[35+intUseRow4*3,15].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow4*3+1,16):=zhuantanland_all[(intUseRow4+8)*10+1];
                    ExcelApplication1.Cells[35+intUseRow4*3+1,16].Borders.LineStyle:=1;
                    ExcelApplication1.Cells(35+intUseRow4*3+2,16):=zhuantanland_all[(intUseRow4+8)*10+2];
                    ExcelApplication1.Cells[35+intUseRow4*3+2,16].Borders.LineStyle:=1;

                    //�ϲ���Ԫ��
                    Sheet:= ExcelApplication1.Activesheet;
                    Range:= ExcelApplication1.Range[sheet.cells[32+intUseRow4*3,14],sheet.cells[32+intUseRow4*3+2,14]];
                    Range.merge;
                    Range.FormulaR1C1:=PCHAR(FormatFloat('0',(100+intUseRow4*20))) + '~'+PCHAR(FormatFloat('0',(120+intUseRow4*20)))+' m';//�ϲ���д���ı�
                    //�ϲ���Ԫ��
                    Range.Borders.LineStyle:=1;//�ӱ߿�
                    intUseRow4:=intUseRow4+1
                end;
            end;
          if intUseRowMax<intUseRow4 then intUseRowMax:=intUseRow4;
        end;

    ExcelWorkbook1.Save;
    ExcelWorkbook1.Close;
    ExcelApplication1.Quit;
    ExcelApplication1:=Unassigned;


    lstStratumNo.Free;
    lstSubNo.Free;
    lstCategory.Free;

    Result:=0;
end;

//�õ���һ����(��̽)������(½��,ˮ��һ������)
function TfrmCharge92.getOneBoreInfo(strProjectCode: string;strBoreCode: string):integer;
var
    intRow:integer;
    intCol:integer;
    dblCount:double;
    dblNow:double;
    dblNow_old:double;
    intClass:integer;
    intTag:integer;
    intLabel:Array[1..12] of integer;
    intTmp:integer;
    intClass_old:integer;
begin
   try
    ADO02.Close;
    ADO02.SQL.Text:='select * from stratum where prj_no='''+strProjectCode+''' and drl_no='''+strBoreCode+''' order by stra_depth';
    ADO02.Open;
    dblCount:=0;
    dblNow:=0;
    intTag:=0;
    intTmp:=0;
    intClass_old:=0;
    intLabel[1]:=0;
    intLabel[2]:=10;
    intLabel[3]:=20;
    intLabel[4]:=30;
    intLabel[5]:=40;
    intLabel[6]:=50;
    intLabel[7]:=75;
    intLabel[8]:=100;
    intLabel[9]:=120;
    intLabel[10]:=140;
    intLabel[11]:=160;
    intLabel[12]:=180;
    //��ʼ���������
    for intRow:=0 to 99 do
        zhuantanland_one[intRow] := 0;

    intRow:=0;
    while not ADO02.Recordset.eof do
        begin
            dblNow:=ADO02.fieldByName('stra_depth').Value;
            dblNow_old:=dblNow;
            intTag:=0;
             for intClass:=1 to 12 do
             begin
                //intLabel[intClass]~intLabel[intClass+1]�׷�Χ*******************************************************************************
                //dblNowȫ������intLabel[intClass]~intLabel[intClass+1]�׷�Χ��
                intClass_old:=intClass;
                if ((dblCount=intLabel[intClass]) and (dblNow<=intLabel[intClass+1]) and (intTmp=0)) or ((dblNow_old>intLabel[intClass]) and (dblNow_old<=intLabel[intClass+1])) then
                begin
                    if (intTag=0) then
                    begin
                        dblNow:=dblNow-dblCount;
                        intTag:=1;
                    end;
                    case ADO02.fieldByName('stra_category92').AsInteger of
                    0:
                        zhuantanland_one[(intClass-1)*10+0]:=zhuantanland_one[(intClass-1)*10+0]+ dblNow;
                    1:
                        zhuantanland_one[(intClass-1)*10+1]:=zhuantanland_one[(intClass-1)*10+1]+ dblNow;
                    2:
                        zhuantanland_one[(intClass-1)*10+2]:=zhuantanland_one[(intClass-1)*10+2]+ dblNow;
                    3:
                        zhuantanland_one[(intClass-1)*10+3]:=zhuantanland_one[(intClass-1)*10+3]+ dblNow;
                    4:
                        zhuantanland_one[(intClass-1)*10+4]:=zhuantanland_one[(intClass-1)*10+4]+ dblNow;
                    5:
                        zhuantanland_one[(intClass-1)*10+5]:=zhuantanland_one[(intClass-1)*10+5]+ dblNow;
                    6:
                        zhuantanland_one[(intClass-1)*10+6]:=zhuantanland_one[(intClass-1)*10+6]+ dblNow;
                    7:
                        zhuantanland_one[(intClass-1)*10+7]:=zhuantanland_one[(intClass-1)*10+7]+ dblNow;
                    else
                    end;
                    dblCount:=dblCount+dblNow;
                    dblNow:=0;
                end;
                //dblNowһ��������intLabel[intClass]~intLabel[intClass+1]�׷�Χ��
                if ((dblCount>=intLabel[intClass]) and (dblCount<intLabel[intClass+1]) and (dblNow_old>intLabel[intClass+1])) then
                begin
                    if (intTag=0) then
                    begin
                        dblNow:=dblNow-dblCount;
                        intTag:=1;
                    end;
                        if (intTmp=1) then
                        begin

                            case ADO02.fieldByName('stra_category92').AsInteger of
                            0:
                                zhuantanland_one[(intClass-1)*10+0]:=zhuantanland_one[(intClass-1)*10+0]+ intLabel[intClass+1]-intLabel[intClass];
                            1:
                                zhuantanland_one[(intClass-1)*10+1]:=zhuantanland_one[(intClass-1)*10+1]+ intLabel[intClass+1]-intLabel[intClass];
                            2:
                                zhuantanland_one[(intClass-1)*10+2]:=zhuantanland_one[(intClass-1)*10+2]+ intLabel[intClass+1]-intLabel[intClass];
                            3:
                                zhuantanland_one[(intClass-1)*10+3]:=zhuantanland_one[(intClass-1)*10+3]+ intLabel[intClass+1]-intLabel[intClass];
                            4:
                                zhuantanland_one[(intClass-1)*10+4]:=zhuantanland_one[(intClass-1)*10+4]+ intLabel[intClass+1]-intLabel[intClass];
                            5:
                                zhuantanland_one[(intClass-1)*10+5]:=zhuantanland_one[(intClass-1)*10+5]+ intLabel[intClass+1]-intLabel[intClass];
                            6:
                                zhuantanland_one[(intClass-1)*10+6]:=zhuantanland_one[(intClass-1)*10+6]+ intLabel[intClass+1]-intLabel[intClass];
                            7:
                                zhuantanland_one[(intClass-1)*10+7]:=zhuantanland_one[(intClass-1)*10+7]+ intLabel[intClass+1]-intLabel[intClass];
                            else
                            end;
                            dblNow:=dblNow-(intLabel[intClass+1]-intLabel[intClass]);
                            dblCount:=intLabel[intClass+1];
                            intTag:=1;
                            intClass_old:=intClass_old+1;
                            if (dblNow>(intLabel[intClass_old+1]-intLabel[intClass_old])) then
                              intTmp:=1
                            else
                              inttmp:=0;
                        end
                        else
                        begin
                           case ADO02.fieldByName('stra_category92').AsInteger of
                            0:
                                zhuantanland_one[(intClass-1)*10+0]:=zhuantanland_one[(intClass-1)*10+0]+ intLabel[intClass+1]-dblCount;
                            1:
                                zhuantanland_one[(intClass-1)*10+1]:=zhuantanland_one[(intClass-1)*10+1]+ intLabel[intClass+1]-dblCount;
                            2:
                                zhuantanland_one[(intClass-1)*10+2]:=zhuantanland_one[(intClass-1)*10+2]+ intLabel[intClass+1]-dblCount;
                            3:
                                zhuantanland_one[(intClass-1)*10+3]:=zhuantanland_one[(intClass-1)*10+3]+ intLabel[intClass+1]-dblCount;
                            4:
                                zhuantanland_one[(intClass-1)*10+4]:=zhuantanland_one[(intClass-1)*10+4]+ intLabel[intClass+1]-dblCount;
                            5:
                                zhuantanland_one[(intClass-1)*10+5]:=zhuantanland_one[(intClass-1)*10+5]+ intLabel[intClass+1]-dblCount;
                            6:
                                zhuantanland_one[(intClass-1)*10+6]:=zhuantanland_one[(intClass-1)*10+6]+ intLabel[intClass+1]-dblCount;
                            7:
                                zhuantanland_one[(intClass-1)*10+7]:=zhuantanland_one[(intClass-1)*10+7]+ intLabel[intClass+1]-dblCount;
                            else
                            end;
                            dblNow:=dblNow-(intLabel[intClass+1]-dblCount);
                            dblCount:=intLabel[intClass+1];
                            intTag:=1;
                            intClass_old:=intClass_old+1;
                            if (dblNow>(intLabel[intClass_old+1]-intLabel[intClass_old])) then
                            intTmp:=1
                            else
                            inttmp:=0;
                        end;
                  end;
             end;
            intRow:=intRow+1;
            ADO02.Next;
        end;
        ADO02.Close;
   except
      result:=1;
      exit;
   end;
   result:=0;
end;

//ȡ��,ˮ��
function TfrmCharge92.getEarthWaterInfo(strProjectCode: string):integer;
var
    ExcelApplication1:Variant;
    ExcelWorkbook1:Variant;
    xlsFileName:string;
    dblCount:Array[1..10] of double;
    i:integer;
begin
    //�õ�����ָ�����̵����еĿ׺�
    ADO02.Close;
    ADO02.SQL.Text:='select * from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+ strProjectCode + ''' order by drl_no';
    ADO02.Open;
    while not ADO02.eof do
    begin
        strRecord[0].Add(ADO02.fieldByName('drl_no').AsString);
        ADO02.Next;
    end;

    //ȡ��,ˮ��(������<=30��)
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
              'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
              'and s_depth_begin <=50 '+
              'and prj_no='''+ strProjectCode + ''' and (not wet_density is null)';
    ADO02.Open;
    dblCount[1]:=ADO02.fieldByName('Num').Value;

    //TXT ����/////////////////////
    ADO02.Close;
    ADO02.SQL.Text:='select drl_no,count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and s_depth_begin <=50 '+
            'and prj_no='''+ strProjectCode + ''' and (not wet_density is null) '+
            'group by drl_no order by drl_no';
    ADO02.Open;

    for i:=0 to strRecord[0].Count-1 do
    begin
      if UpperCase(strRecord[0][i])=UpperCase(ADO02.FieldByName('drl_no').AsString) then
      begin
          strRecord[1].Add(ADO02.FieldByName('num').AsString);
          ADO02.Next;
      end
      else
          strRecord[1].Add('0');
    end;
    strRecord[1].Add(floattostr(dblCount[1]));

    //ȡ��,ˮ��(������>30��)
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
              'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
              'and s_depth_begin >50 '+
              'and prj_no='''+ strProjectCode + ''' and (not wet_density is null)';
    ADO02.Open;
    dblCount[2]:=ADO02.fieldByName('Num').Value;

    //TXT ����/////////////////////
    ADO02.Close;
    ADO02.SQL.Text:='select drl_no,count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and s_depth_begin >50 '+
            'and prj_no='''+ strProjectCode + ''' and (not wet_density is null) '+
            'group by drl_no order by drl_no';
    ADO02.Open;

    for i:=0 to strRecord[0].Count-1 do
    begin
      if UpperCase(strRecord[0][i])=UpperCase(ADO02.FieldByName('drl_no').AsString) then
      begin
          strRecord[2].Add(ADO02.FieldByName('num').AsString);
          ADO02.Next;
      end
      else
          strRecord[2].Add('0');
    end;
    strRecord[2].Add(floattostr(dblCount[2]));

    //�Ŷ���
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+ strProjectCode + ''' and wet_density is null;';

    ADO02.Open;
    dblCount[3]:=ADO02.fieldByName('Num').Value;

    //�õ�TXT����Ŷ���StrRecord[2]
    ADO02.Close;
    ADO02.SQL.Text:='select drl_no,count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no=''' + strProjectCode + ''' and (wet_density is null) group by drl_no order by drl_no';
    ADO02.Open;
    for i:=0 to strRecord[0].Count-1 do
    begin
      if UpperCase(strRecord[0][i])=UpperCase(ADO02.FieldByName('drl_no').AsString) then
      begin
          strRecord[3].Add(ADO02.FieldByName('num').AsString);
          ADO02.Next;
      end
      else
          strRecord[3].Add('0');
    end;
    strRecord[3].Add(floattostr(dblCount[3]));

    //д��EXCEL�ļ�
    ExcelApplication1:=CreateOleObject('Excel.Application');
    ExcelWorkbook1:=CreateOleobject('Excel.Sheet');
    xlsFileName:=ERP1.Text;;
    ExcelWorkbook1:=ExcelApplication1.workBooks.Open(xlsFileName);

    ExcelApplication1.Cells(48,17):=dblCount[1];
    ExcelApplication1.Cells(51,17):=dblCount[2];
    ExcelApplication1.Cells(54,17):=dblCount[3];

    ExcelWorkbook1.Save;
    ExcelWorkbook1.Close;
    ExcelApplication1.Quit;
    ExcelApplication1:=Unassigned;
    result:=0;
end;

//��׼��������
function TfrmCharge92.getStandardThroughInfo(strProjectCode: string):integer;
var
    intMore50:integer;
    intLess50:integer;
    intguanbiao:Array[1..9] of integer;
    ExcelApplication1:Variant;
    ExcelWorkbook1:Variant;
    xlsFileName:string;
    strSQL: string;
    i:integer;
begin
    for i:=1 to 9 do
      intguanbiao[i]:=0;

    ADO02.Close;
    ADO02.SQL.Text:='select spt.*,stratum.stra_category92 from spt join stratum '+
                      'on spt.prj_no=stratum.prj_no and spt.drl_no=stratum.drl_no '+
                      'and spt.stra_no=stratum.stra_no and spt.sub_no=stratum.sub_no '+
                      'where spt.drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
                      'and spt.prj_no='''+strProjectCode+'''';
    ADO02.Open;

    while not ADO02.eof do
    begin
        if (ADO02.FieldByName('begin_depth').AsFloat<=50.0) and (ADO02.FieldByName('stra_category92').AsInteger=0) then intguanbiao[1]:=intguanbiao[1]+1;
        if (ADO02.FieldByName('begin_depth').AsFloat<=50.0) and (ADO02.FieldByName('stra_category92').AsInteger=1) then intguanbiao[2]:=intguanbiao[2]+1;
        if (ADO02.FieldByName('begin_depth').AsFloat<=50.0) and (ADO02.FieldByName('stra_category92').AsInteger=2) then intguanbiao[3]:=intguanbiao[3]+1;
        if (ADO02.FieldByName('begin_depth').AsFloat<=50.0) and (ADO02.FieldByName('stra_category92').AsInteger=3) then intguanbiao[4]:=intguanbiao[4]+1;

        if (ADO02.FieldByName('begin_depth').AsFloat>50.0) and (ADO02.FieldByName('stra_category92').AsInteger=0) then intguanbiao[5]:=intguanbiao[5]+1;
        if (ADO02.FieldByName('begin_depth').AsFloat>50.0) and (ADO02.FieldByName('stra_category92').AsInteger=1) then intguanbiao[6]:=intguanbiao[6]+1;
        if (ADO02.FieldByName('begin_depth').AsFloat>50.0) and (ADO02.FieldByName('stra_category92').AsInteger=2) then intguanbiao[7]:=intguanbiao[7]+1;
        if (ADO02.FieldByName('begin_depth').AsFloat>50.0) and (ADO02.FieldByName('stra_category92').AsInteger=3) then intguanbiao[8]:=intguanbiao[8]+1;

        ADO02.Next;
    end;
    //���(<=20)/////////////////////
    ADO02.Close;
    ADO02.SQL.Text:='select spt.drl_no,count(spt.drl_no) as num from spt join stratum '+
                    'on spt.prj_no=stratum.prj_no and '+
                    'spt.drl_no=stratum.drl_no and spt.stra_no=stratum.stra_no '+
                    'and spt.sub_no=stratum.sub_no where spt.begin_depth<=20 '+
                    'and spt.drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
                    'and spt.prj_no=''' + strProjectCode + ''' group by spt.drl_no order by spt.drl_no';
    ADO02.Open;

    for i:=0 to strRecord[0].Count-1 do
    begin
      if UpperCase(strRecord[0][i])=UpperCase(ADO02.FieldByName('drl_no').AsString) then
      begin
          strRecord[4].Add(ADO02.FieldByName('num').AsString);
          ADO02.Next;
      end
      else
          strRecord[4].Add('0');
    end;
    strRecord[4].Add(floattostr(intguanbiao[1]+intguanbiao[2]+intguanbiao[3]));

    //���(>20<=50)//////////////////////
    ADO02.Close;
    ADO02.SQL.Text:='select spt.drl_no,count(spt.drl_no) as num from spt join stratum '+
                    'on spt.prj_no=stratum.prj_no and '+
                    'spt.drl_no=stratum.drl_no and spt.stra_no=stratum.stra_no '+
                    'and spt.sub_no=stratum.sub_no where spt.begin_depth>20 and spt.begin_depth<=50'+
                    'and spt.drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
                    'and spt.prj_no=''' + strProjectCode + ''' group by spt.drl_no order by spt.drl_no';
    ADO02.Open;

    for i:=0 to strRecord[0].Count-1 do
    begin
      if UpperCase(strRecord[0][i])=UpperCase(ADO02.FieldByName('drl_no').AsString) then
      begin
          strRecord[5].Add(ADO02.FieldByName('num').AsString);
          ADO02.Next;
      end
      else
          strRecord[5].Add('0');
    end;
    strRecord[5].Add(floattostr(intguanbiao[4]+intguanbiao[5]+intguanbiao[6]));

    //���(>50)//////////////////////
    ADO02.Close;
    ADO02.SQL.Text:='select spt.drl_no,count(spt.drl_no) as num from spt join stratum '+
                    'on spt.prj_no=stratum.prj_no and '+
                    'spt.drl_no=stratum.drl_no and spt.stra_no=stratum.stra_no '+
                    'and spt.sub_no=stratum.sub_no where spt.begin_depth>50 '+
                    'and spt.drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
                    'and spt.prj_no=''' + strProjectCode + ''' group by spt.drl_no order by spt.drl_no';
    ADO02.Open;

    for i:=0 to strRecord[0].Count-1 do
    begin
      if UpperCase(strRecord[0][i])=UpperCase(ADO02.FieldByName('drl_no').AsString) then
      begin
          strRecord[6].Add(ADO02.FieldByName('num').AsString);
          ADO02.Next;
      end
      else
          strRecord[6].Add('0');
    end;
    strRecord[6].Add(floattostr(intguanbiao[7]+intguanbiao[8]+intguanbiao[9]));


    //д��EXCEL�ļ�
    ExcelApplication1:=CreateOleObject('Excel.Application');
    ExcelWorkbook1:=CreateOleobject('Excel.Sheet');
    xlsFileName:=ERP1.Text;
    ExcelWorkbook1:=ExcelApplication1.workBooks.Open(xlsFileName);

    //ExcelApplication1.Cells(18,21):=intguanbiao[1]+intguanbiao[2]+intguanbiao[3]+intguanbiao[4]+intguanbiao[5]+intguanbiao[6];
    //ExcelApplication1.Cells(20,21):=intguanbiao[7]+intguanbiao[8]+intguanbiao[9];
    ExcelApplication1.Cells(53,11):=intguanbiao[1];
    ExcelApplication1.Cells(54,11):=intguanbiao[2];
    ExcelApplication1.Cells(55,11):=intguanbiao[3];
    ExcelApplication1.Cells(56,11):=intguanbiao[4];
    ExcelApplication1.Cells(57,11):=intguanbiao[5];
    ExcelApplication1.Cells(58,11):=intguanbiao[6];
    ExcelApplication1.Cells(59,11):=intguanbiao[7];
    ExcelApplication1.Cells(60,11):=intguanbiao[8];

    ExcelWorkbook1.Save;
    ExcelWorkbook1.Close;
    ExcelApplication1.Quit;
    ExcelApplication1:=Unassigned;

    result:=0;
end;

//������
function TfrmCharge92.getWhorlThroughInfo(strProjectCode: string):integer;
var
    strdrl_no:string;
    dblNow:double;
    dblCount:double;
    intLess50:integer;
    ExcelApplication1:Variant;
    ExcelWorkbook1:Variant;
    xlsFileName:string;
    strSQL: string;
    dblWhorlValue:Array[1..8] of double;
begin
    ADO02.Close;
    ADO02.SQL.Text:='select * from stratum '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+ strProjectCode + ''' and d_t_no=3) '+
            'and prj_no='''+strProjectCode+''' order by prj_no,drl_no,stra_depth';
    ADO02.Open;
    dblCount:=0;
    strdrl_no:='';
    while not ADO02.Recordset.eof do
    begin
        if (ADO02.fieldByName('drl_no').asstring<>strdrl_no) then
        begin
            dblCount:=0;
        end;
        dblNow:=ADO02.fieldByName('stra_depth').Value;
        dblNow:=dblNow-dblCount;
        case  ADO02.fieldByName('stra_category92').AsInteger  of
            0:dblWhorlValue[1]:= dblWhorlValue[1]+dblNow;
            1:dblWhorlValue[2]:= dblWhorlValue[2]+dblNow;
            2:dblWhorlValue[3]:= dblWhorlValue[3]+dblNow;
            3:dblWhorlValue[4]:= dblWhorlValue[4]+dblNow;
            4:dblWhorlValue[5]:= dblWhorlValue[5]+dblNow;
            5:dblWhorlValue[6]:= dblWhorlValue[6]+dblNow;
            6:dblWhorlValue[7]:= dblWhorlValue[7]+dblNow;
            7:dblWhorlValue[8]:= dblWhorlValue[8]+dblNow;
        end;
        dblCount:=dblCount+dblNow;
        strdrl_no:=ADO02.fieldByName('drl_no').AsString;
        ADO02.Next;
    end;

    //д��EXCEL�ļ�
    ExcelApplication1:=CreateOleObject('Excel.Application');
    ExcelWorkbook1:=CreateOleobject('Excel.Sheet');
    xlsFileName:=ERP1.Text;
    ExcelWorkbook1:=ExcelApplication1.workBooks.Open(xlsFileName);

    ExcelApplication1.Cells(61,17):=dblWhorlValue[1];
    ExcelApplication1.Cells(62,17):=dblWhorlValue[2];
    ExcelApplication1.Cells(63,17):=dblWhorlValue[3];

    ExcelWorkbook1.Save;
    ExcelWorkbook1.Close;
    ExcelApplication1.Quit;
    ExcelApplication1:=Unassigned;
    result:=0;
end;

//��̽�����
function TfrmCharge92.getProveMeasureInfo(strProjectCode: string):integer;
var
    intCount:integer;
    intLess50:integer;
    ExcelApplication1:Variant;
    ExcelWorkbook1:Variant;
    xlsFileName:string;
    strSQL: string;
begin
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+'''';
    ADO02.Open;
    intCount:=ADO02.fieldByName('Num').Value;

    //д��EXCEL�ļ�
    ExcelApplication1:=CreateOleObject('Excel.Application');
    ExcelWorkbook1:=CreateOleobject('Excel.Sheet');
    xlsFileName:=ERP1.text;
    ExcelWorkbook1:=ExcelApplication1.workBooks.Open(xlsFileName);

    ExcelApplication1.Cells(31,21):=intCount;
    ExcelWorkbook1.Save;
    ExcelWorkbook1.Close;
    ExcelApplication1.Quit;
    ExcelApplication1:=Unassigned;
    result:=0;
end;

//�����������
function TfrmCharge92.getRomDustTestInfo(strProjectCode: string):integer;
var
    ExcelApplication1:Variant;
    ExcelWorkbook1:Variant;
    xlsFileName:string;
    dblearthsample:Array[1..50] of double;  //��������
    dblEarthSampleTeShu:array[1..50] of Double;//������
    i:integer;
begin
    //��ˮ��
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and aquiferous_rate is not null';
    ADO02.Open;
    dblearthSample[1]:=ADO02.fieldByName('Num').Value;  //��ˮ��
    //TXT�ļ���ˮ��strRecord[7]
    ADO02.Close;
    ADO02.SQL.Text:='select drl_no,count(*) as num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and aquiferous_rate is not null group by drl_no order by drl_no';
    ADO02.Open;
    for i:=0 to strRecord[0].Count-1 do
    begin
      if UpperCase(strRecord[0][i])=UpperCase(ADO02.FieldByName('drl_no').AsString) then
      begin
          strRecord[7].Add(ADO02.FieldByName('num').AsString);
          ADO02.Next;
      end
      else
          strRecord[7].Add('0');
    end;
    strRecord[7].Add(floattostr(dblearthSample[1]));

    //����
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and wet_density is not null';
    ADO02.Open;
    dblearthSample[2]:=ADO02.fieldByName('Num').Value;  //����

    //TXT�ļ�����strRecord[8]
    ADO02.Close;
    ADO02.SQL.Text:='select drl_no,count(*) as num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and wet_density is not null group by drl_no order by drl_no';
    ADO02.Open;
    for i:=0 to strRecord[0].Count-1 do
    begin
      if UpperCase(strRecord[0][i])=UpperCase(ADO02.FieldByName('drl_no').AsString) then
      begin
          strRecord[8].Add(ADO02.FieldByName('num').AsString);
          ADO02.Next;
      end
      else
          strRecord[8].Add('0');
    end;
    strRecord[8].Add(floattostr(dblearthSample[2]));

    //Һ��
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and liquid_limit is not null';
    ADO02.Open;
    dblearthSample[3]:=ADO02.fieldByName('Num').Value;  //Һ��

    //����
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and shape_limit is not null';
    ADO02.Open;
    dblearthSample[4]:=ADO02.fieldByName('Num').Value;  //����

    //TXT�ļ�Һ����strRecord[9]
    ADO02.Close;
    ADO02.SQL.Text:='select drl_no,count(*) as num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and liquid_limit is not null and shape_limit is not null group by drl_no order by drl_no';
    ADO02.Open;
    for i:=0 to strRecord[0].Count-1 do
    begin
      if UpperCase(strRecord[0][i])=UpperCase(ADO02.FieldByName('drl_no').AsString) then
      begin
          strRecord[9].Add(ADO02.FieldByName('num').AsString);
          ADO02.Next;
      end
      else
          strRecord[9].Add('0');
    end;
    strRecord[9].Add(floattostr(dblearthSample[3]));

    //����
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and soil_proportion is not null';
    ADO02.Open;
    dblearthSample[5]:=ADO02.fieldByName('Num').Value;  //����

    //ֱ��(���)
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and cohesion is not null';
    ADO02.Open;
    dblearthSample[6]:=ADO02.fieldByName('Num').Value;  //ֱ��(���)

    //ֱ��(�̿�)
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and cohesion_gk is not null';
    ADO02.Open;
    dblearthSample[7]:=ADO02.fieldByName('Num').Value;  //ֱ��(�̿�)

    //TXT�ļ�����strRecord[9]-----ֱ��(���)
    ADO02.Close;
    ADO02.SQL.Text:='select drl_no,count(*) as num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (cohesion is not null) group by drl_no';
    ADO02.Open;
    //TXT�ļ�����strRecord[9]-----ֱ��(�̿�)
    ADO02_ALL.Close;
    ADO02_ALL.SQL.Text:='select drl_no,count(*) as num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (cohesion_gk is not null) group by drl_no';
    ADO02_ALL.Open;
    for i:=0 to strRecord[0].Count-1 do
    begin
      if (UpperCase(strRecord[0][i])=UpperCase(ADO02.FieldByName('drl_no').AsString)) and (UpperCase(strRecord[0][i])=UpperCase(ADO02_ALL.FieldByName('drl_no').AsString)) then
      begin
          strRecord[11].Add(inttostr(ADO02.FieldByName('num').Value+ADO02_ALL.FieldByName('num').Value));
          ADO02.Next;
          ADO02_ALL.Next;
      end
      else if (UpperCase(strRecord[0][i])=UpperCase(ADO02.FieldByName('drl_no').AsString)) and (UpperCase(strRecord[0][i])<>UpperCase(ADO02_ALL.FieldByName('drl_no').AsString)) then
      begin
          strRecord[11].Add(ADO02.FieldByName('num').AsString);
          ADO02.Next;
      end
      else if (UpperCase(strRecord[0][i])<>UpperCase(ADO02.FieldByName('drl_no').AsString)) and (UpperCase(strRecord[0][i])=UpperCase(ADO02_ALL.FieldByName('drl_no').AsString)) then
      begin
          strRecord[11].Add(ADO02_ALL.FieldByName('num').AsString);
          ADO02_ALL.Next;
      end
      else
          strRecord[11].Add('0');
    end;

    strRecord[11].Add(floattostr(dblearthSample[6]+dblearthSample[7]));

    //ѹ��(����)
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (zip_coef is not null or zip_modulus is not null);';
    ADO02.Open;
    dblearthSample[11]:=ADO02.fieldByName('Num').Value;  //ѹ��(����)

    //TXT�ļ� ѹ��(����)
    ADO02.Close;
    ADO02.SQL.Text:='select drl_no,count(*) as num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (zip_coef is not null or zip_modulus is not null) group by drl_no';
    ADO02.Open;
    for i:=0 to strRecord[0].Count-1 do
    begin
      if UpperCase(strRecord[0][i])=UpperCase(ADO02.FieldByName('drl_no').AsString) then
      begin
          strRecord[10].Add(ADO02.FieldByName('num').AsString);
          ADO02.Next;
      end
      else
          strRecord[10].Add('0');
    end;
    strRecord[10].Add(floattostr(dblearthSample[11]));

    //�ŷ�(���ؼ�)
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (sand_big is not null or sand_middle is not null or sand_small is not null or powder_big is not null or powder_small is not null or clay_grain is not null or li is not null)';
    ADO02.Open;
    dblearthSample[12]:=ADO02.fieldByName('Num').Value;  //�ŷ�(���ؼ�)
    //TXT ���� �ŷ�(���ؼ�)
    ADO02.Close;
    ADO02.SQL.Text:='select drl_no,count(*) as num from earthsample '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (sand_big is not null or sand_middle is not null or sand_small is not null or powder_big is not null or powder_small is not null or clay_grain is not null or li is not null) group by drl_no';
    ADO02.Open;
    for i:=0 to strRecord[0].Count-1 do
    begin
      if UpperCase(strRecord[0][i])=UpperCase(ADO02.FieldByName('drl_no').AsString) then
      begin
          strRecord[12].Add(ADO02.FieldByName('num').AsString);
          ADO02.Next;
      end
      else
          strRecord[12].Add('0');
    end;
    strRecord[12].Add(floattostr(dblearthSample[12]));

    //����Ϊ����������
    //���ڹ̽�ѹ��
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from TeShuYang '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (gygj_pc is not null)';
    ADO02.Open;
    dblEarthSampleTeShu[1]:=ADO02.fieldByName('Num').Value;

    //�̽�ϵ��
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from TeShuYang '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (gjxs50_1 is not null or gjxs100_1 is not null or gjxs200_1 is not null or gjxs400_1 is not null or gjxs50_2 is not null or gjxs100_2 is not null or gjxs200_2 is not null or gjxs400_2 is not null)';
    ADO02.Open;
    dblEarthSampleTeShu[3]:=ADO02.fieldByName('Num').Value;

    //�޲��޿�ѹǿ��
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from TeShuYang '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (wcxkyqd_yz is not null or wcxkyqd_cs is not null or wcxkyqd_lmd is not null)';
    ADO02.Open;
    dblEarthSampleTeShu[4]:=ADO02.fieldByName('Num').Value;

    //��Ȼ�½ǣ�ˮ�ϡ�ˮ�£�
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from TeShuYang '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (trpj_g is not null or trpj_sx is not null)';
    ADO02.Open;
    dblEarthSampleTeShu[6]:=ADO02.fieldByName('Num').Value;

    // ����ѹ�� ���̽᲻��ˮ(UU)
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from TeShuYang '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (szsy_zyl_njl_uu is not null or szsy_zyl_nmcj_uu is not null)';
    ADO02.Open;
    dblEarthSampleTeShu[7]:=ADO02.fieldByName('Num').Value;

    // ����ѹ�� �̽᲻��ˮ(CU)
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from TeShuYang '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (szsy_zyl_njl_cu is not null or szsy_zyl_nmcj_cu is not null)';
    ADO02.Open;
    dblEarthSampleTeShu[8]:=ADO02.fieldByName('Num').Value;

    //��͸����
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from TeShuYang '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (stxs_kv is not null or stxs_kh is not null)';
    ADO02.Open;
    dblEarthSampleTeShu[9]:=ADO02.fieldByName('Num').Value;

    //��ֹ��ѹ��ϵ�� K0
    ADO02.Close;
    ADO02.SQL.Text:='select count(*) as Num from TeShuYang '+
            'where drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
            'and prj_no='''+strProjectCode+''' and (jzcylxs is not null)';
    ADO02.Open;
    dblEarthSampleTeShu[11]:=ADO02.fieldByName('Num').Value;

    ADO02.Close;
    //д��EXCEL�ļ�
    ExcelApplication1:=CreateOleObject('Excel.Application');
    ExcelWorkbook1:=CreateOleobject('Excel.Sheet');
    xlsFileName:=ERP1.Text;
    ExcelWorkbook1:=ExcelApplication1.workBooks.Open(xlsFileName);

    //������
    ExcelApplication1.Cells(28,26):=dblearthSample[1];  //��ˮ��
    ExcelApplication1.Cells(29,26):=dblearthSample[2];  //��    �� �� �ܶ�
    ExcelApplication1.Cells(30,26):=dblearthSample[3];  //Һ    ��
    ExcelApplication1.Cells(31,26):=dblearthSample[4];  //��    ��
    ExcelApplication1.Cells(32,26):=dblearthSample[5];  //��    ��
    ExcelApplication1.Cells(33,26):=dblearthSample[6];  //ֱ�����
    ExcelApplication1.Cells(34,26):=dblearthSample[7];  //ֱ���̿�
    ExcelApplication1.Cells(35,26):=dblearthSample[11]; //ѹ������
    ExcelApplication1.Cells(41,26):=dblearthSample[12]; //�ŷ� ���ؼ�
	

    //������
    ExcelApplication1.Cells(28,35):=dblEarthSampleTeShu[1];  //���ڹ̽�ѹ��
    ExcelApplication1.Cells(30,35):=dblEarthSampleTeShu[3];  //�̽�ϵ��
    ExcelApplication1.Cells(31,35):=dblEarthSampleTeShu[4];  //�޲��޿�ѹǿ��
    ExcelApplication1.Cells(33,35):=dblEarthSampleTeShu[6];  //��Ȼ�½ǣ�ˮ�ϡ�ˮ�£�
    ExcelApplication1.Cells(34,35):=dblEarthSampleTeShu[7];  //����ѹ�� ���̽᲻��ˮ(UU)
    ExcelApplication1.Cells(35,35):=dblEarthSampleTeShu[8];  //����ѹ�� �̽᲻��ˮ(CU)
    ExcelApplication1.Cells(42,26):=dblEarthSampleTeShu[9];  //��͸����
    ExcelApplication1.Cells(44,26):=dblEarthSampleTeShu[11]; //��ֹ��ѹ��ϵ�� K0


    ExcelWorkbook1.Save;
    ExcelWorkbook1.Close;
    ExcelApplication1.Quit;
    ExcelApplication1:=Unassigned;
    result:=0;
end;

function TfrmCharge92.WriteTxtFile():integer;
var
    i:integer;
    j:integer;
    strText:string;
begin
    for i:=0 to strRecord[0].Count do
    begin
        if i=strRecord[0].Count then
            strText :='�ܼ�'+','+strRecord[1][i]+','+strRecord[2][i]+','+
                      strRecord[3][i]+','+strRecord[4][i]+','+
                      strRecord[5][i]+','+strRecord[6][i]+','+
                      strRecord[7][i]+','+strRecord[8][i]+','+
                      strRecord[9][i]+','+strRecord[10][i]+','+ strRecord[11][i]+','+
                      strRecord[12][i]
        else
            strText :=strRecord[0][i]+','+strRecord[1][i]+','+strRecord[2][i]+','+
                      strRecord[3][i]+','+strRecord[4][i]+','+
                      strRecord[5][i]+','+strRecord[6][i]+','+
                      strRecord[7][i]+','+strRecord[8][i]+','+
                      strRecord[9][i]+','+strRecord[10][i]+','+ strRecord[11][i]+
                      ','+strRecord[12][i];
        Writeln(txtFile,strText);
    end;
    result:=0;
end;

procedure TfrmCharge92.btnCreateReportClick(Sender: TObject);
var
    strPath:string;
    intResult:integer;
    i:integer;
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

    //if not FileExists(pChar(ERP1.text)) then
    //begin
        //yys 2011/06/29 93.xls���µľ����ĵ�
        //copyfile(pChar(ExtractFileDir(Application.Exename)+'\XLS\XMJS041018_92.xls'),PChar(ERP1.text),true);
        copyfile(pChar(ExtractFileDir(Application.Exename)+'\XLS\93.xls'),PChar(ERP1.text),false);
        //yys 2011/06/29  �������ͳ��_093.xls ���������ã�Ϊ�˿�����ֱ��
        m_FullFileName_TuLeiBieTongJi := strPath +'\'+g_ProjectInfo.Prj_no+'�������ͳ��_93.xlsx';
        CopyFile(pChar(ExtractFileDir(Application.Exename)+'\XLS\�������ͳ��_93.xlsx'),PChar(m_FullFileName_TuLeiBieTongJi),false);
    //end;
    for i:=0 to 12 do
        strRecord[i]:=TStringList.create;

    m_intRecordCount:=0;//��Ϊͬһ��EXCEL�����ͳ���ļ��򿪶�Σ�Ҫ��¼�´�д�뿪ʼλ��
    m_isWritenTitle := False;

    pbCreateReport.min:=0;
    pbCreateReport.Max:=110;
    pbCreateReport.Step:=10;

    //̨ͷ��Ϣ/////////////////////////////////////////
    ADO02.SQL.Text:='select prj_no,prj_name,area_name,builder,begin_date,end_date,prj_grade,consigner from projects'+
                    ' where prj_no=''' + strProjectNo+'''';
    ADO02.Open;
    strProjectName:=ADO02.FieldByName('prj_name').AsString;
    strBuilderName:=ADO02.FieldByName('builder').AsString;

    //̨ͷ��Ϣ/////////////////////////////////////////


   pbCreateReport.Position:=10;
   //��̽(½��)
   intResult:=getAllBoreInfo(strProjectNo,0);
   pbCreateReport.Position:=20;
   //��̽(ˮ��)
   intResult:=getAllBoreInfo(strProjectNo,1);
   pbCreateReport.Position:=30;
   //���ž�����̽
   intResult:=getAllBoreInfo(strProjectNo,7);
   pbCreateReport.Position:=40;
   //˫�ž�����̽
   intResult:=getAllBoreInfo(strProjectNo,12);

   pbCreateReport.Position:=50;
   //ȡ��,ˮ��
   intResult:=getEarthWaterInfo(strProjectNo);
   pbCreateReport.Position:=60;
   //��׼��������
   intResult:=getStandardThroughInfo(strProjectNo);
   pbCreateReport.Position:=70;
   //������
   intResult:=getWhorlThroughInfo(strProjectNo);
   pbCreateReport.Position:=80;
   //������̽����
   intResult:= getZhongLiChuTanInfo(strProjectNo);
   //��̽�����
   //intResult:=getProveMeasureInfo(strProjectNo);
   pbCreateReport.Position:=90;
   //�����������
   intResult:=getRomDustTestInfo(strProjectNo);
   pbCreateReport.Position:=100;

   pbCreateReport.Position:=110;
   MessageBox(application.Handle,'���㱨���Ѿ����ɡ�','ϵͳ��ʾ',MB_OK+MB_ICONINFORMATION);
end;

procedure TfrmCharge92.btnBrowseClick(Sender: TObject);
var
   SaveFName:string;
begin

   SEFDlg.DefaultExt :='xls';
   SEFDlg.Title :=FILE_SAVE_TITLE;
   SEFDlg.FileName :=trim(erp1.text);
   SEFDlg.Filter :=FILE_SAVE_FILTER;
   if not SEFDlg.Execute then exit;
   SaveFName:=SEFDlg.FileName ;
   erp1.text:=SaveFName;

 end;

procedure TfrmCharge92.btnOpenReportClick(Sender: TObject);
var
   sfName:string;
begin
   sfName:=trim(ERP1.Text);
   if fileexists(sfName) then
      shellexecute(application.Handle,PAnsiChar(''),PAnsiChar(sfName),PAnsiChar(''),PAnsiChar(''),SW_SHOWNORMAL)
   else
      Application.Messagebox(FILE_NOTEXIST,HINT_TEXT, MB_ICONEXCLAMATION + mb_Ok);
end;

procedure TfrmCharge92.FormActivate(Sender: TObject);
begin
    self.Left := trunc((screen.Width -self.Width)/2);
    self.Top  := trunc((Screen.Height - self.Height)/3);
      strProjectNo := g_ProjectInfo.prj_no;
    strPath:=GetCurrentDir;
    strPath:=strPath+'\report\'+strProjectNo;
    ERP1.Text:=strPath+'_92.xls';
    pbCreateReport.Position:=0;
end;

//������̽����
function TfrmCharge92.getZhongLiChuTanInfo(
  strProjectCode: string): Integer;
var
    intMore50:integer;
    intLess50:integer;
    intguanbiao:Array[1..9] of integer;
    dGongZuoLiang_m:Array[0..54] of double;
    dDepth:Double;//��������
    dEnd_Begin:Double; //ÿ������Ľ�����ȼ�ȥ��ʼ��ȵ�ֵ
    iStra_category:Integer;//��������
    iPt_type:Integer;//������̽���� 0 ���� 1 ���� 2 ������
    ExcelApplication1:Variant;
    ExcelWorkbook1:Variant;
    xlsFileName:string;
    strSQL: string;
    i:integer;
begin
    for i:=0 to 54 do
      dGongZuoLiang_m[i]:=0;

    ADO02.Close;
    ADO02.SQL.Text:='select dpt.*,stratum.stra_category92 FROM dpt JOIN stratum '+
                      'on dpt.prj_no=stratum.prj_no and dpt.drl_no=stratum.drl_no '+
                      'and dpt.stra_no=stratum.stra_no and dpt.sub_no=stratum.sub_no '+
                      'where dpt.drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
                      'and dpt.prj_no='''+strProjectCode+'''';
    ADO02.Open;

    while not ADO02.eof do
    begin
        dDepth := ADO02.FieldByName('begin_depth').AsFloat;
        dEnd_Begin:= ADO02.FieldByName('end_depth').AsFloat - ADO02.FieldByName('begin_depth').AsFloat;
        iStra_category := ADO02.FieldByName('stra_category92').AsInteger;
        iPt_type := ADO02.FieldByName('pt_type').AsInteger;

        if (dDepth<=10.0) and (iStra_category=0) and (iPt_type=0) then dGongZuoLiang_m[0]:=dGongZuoLiang_m[0]+dEnd_Begin;
        if (dDepth<=10.0) and (iStra_category=1) and (iPt_type=0) then dGongZuoLiang_m[1]:=dGongZuoLiang_m[1]+dEnd_Begin;
        if (dDepth<=10.0) and (iStra_category=2) and (iPt_type=0) then dGongZuoLiang_m[2]:=dGongZuoLiang_m[2]+dEnd_Begin;

        if (dDepth<=10.0) and (iStra_category=0) and (iPt_type=1) then dGongZuoLiang_m[10]:=dGongZuoLiang_m[10]+dEnd_Begin;
        if (dDepth<=10.0) and (iStra_category=1) and (iPt_type=1) then dGongZuoLiang_m[11]:=dGongZuoLiang_m[11]+dEnd_Begin;
        if (dDepth<=10.0) and (iStra_category=2) and (iPt_type=1) then dGongZuoLiang_m[12]:=dGongZuoLiang_m[12]+dEnd_Begin;
        if (dDepth<=10.0) and (iStra_category=3) and (iPt_type=1) then dGongZuoLiang_m[13]:=dGongZuoLiang_m[13]+dEnd_Begin;
        if (dDepth<=10.0) and (iStra_category=4) and (iPt_type=1) then dGongZuoLiang_m[14]:=dGongZuoLiang_m[14]+dEnd_Begin;

        if (dDepth<=20.0) and (dDepth>10.0) and (iStra_category=0) and (iPt_type=1) then dGongZuoLiang_m[20]:=dGongZuoLiang_m[20]+dEnd_Begin;
        if (dDepth<=20.0) and (dDepth>10.0) and (iStra_category=1) and (iPt_type=1) then dGongZuoLiang_m[21]:=dGongZuoLiang_m[21]+dEnd_Begin;
        if (dDepth<=20.0) and (dDepth>10.0) and (iStra_category=2) and (iPt_type=1) then dGongZuoLiang_m[22]:=dGongZuoLiang_m[22]+dEnd_Begin;
        if (dDepth<=20.0) and (dDepth>10.0) and (iStra_category=3) and (iPt_type=1) then dGongZuoLiang_m[23]:=dGongZuoLiang_m[23]+dEnd_Begin;
        if (dDepth<=20.0) and (dDepth>10.0) and (iStra_category=4) and (iPt_type=1) then dGongZuoLiang_m[24]:=dGongZuoLiang_m[24]+dEnd_Begin;

        if (dDepth<=30.0) and (dDepth>20.0) and (iStra_category=0) and (iPt_type=1) then dGongZuoLiang_m[30]:=dGongZuoLiang_m[30]+dEnd_Begin;
        if (dDepth<=30.0) and (dDepth>20.0) and (iStra_category=1) and (iPt_type=1) then dGongZuoLiang_m[31]:=dGongZuoLiang_m[31]+dEnd_Begin;
        if (dDepth<=30.0) and (dDepth>20.0) and (iStra_category=2) and (iPt_type=1) then dGongZuoLiang_m[32]:=dGongZuoLiang_m[32]+dEnd_Begin;
        if (dDepth<=30.0) and (dDepth>20.0) and (iStra_category=3) and (iPt_type=1) then dGongZuoLiang_m[33]:=dGongZuoLiang_m[33]+dEnd_Begin;
        if (dDepth<=30.0) and (dDepth>20.0) and (iStra_category=4) and (iPt_type=1) then dGongZuoLiang_m[34]:=dGongZuoLiang_m[34]+dEnd_Begin;

        if (dDepth<=40.0) and (dDepth>30.0) and (iStra_category=0) and (iPt_type=1) then dGongZuoLiang_m[40]:=dGongZuoLiang_m[40]+dEnd_Begin;
        if (dDepth<=40.0) and (dDepth>30.0) and (iStra_category=1) and (iPt_type=1) then dGongZuoLiang_m[41]:=dGongZuoLiang_m[41]+dEnd_Begin;
        if (dDepth<=40.0) and (dDepth>30.0) and (iStra_category=2) and (iPt_type=1) then dGongZuoLiang_m[42]:=dGongZuoLiang_m[42]+dEnd_Begin;
        if (dDepth<=40.0) and (dDepth>30.0) and (iStra_category=3) and (iPt_type=1) then dGongZuoLiang_m[43]:=dGongZuoLiang_m[43]+dEnd_Begin;
        if (dDepth<=40.0) and (dDepth>30.0) and (iStra_category=4) and (iPt_type=1) then dGongZuoLiang_m[44]:=dGongZuoLiang_m[44]+dEnd_Begin;

        if (dDepth<=50.0) and (dDepth>40.0) and (iStra_category=0) and (iPt_type=1) then dGongZuoLiang_m[50]:=dGongZuoLiang_m[50]+dEnd_Begin;
        if (dDepth<=50.0) and (dDepth>40.0) and (iStra_category=1) and (iPt_type=1) then dGongZuoLiang_m[51]:=dGongZuoLiang_m[51]+dEnd_Begin;
        if (dDepth<=50.0) and (dDepth>40.0) and (iStra_category=2) and (iPt_type=1) then dGongZuoLiang_m[52]:=dGongZuoLiang_m[52]+dEnd_Begin;
        if (dDepth<=50.0) and (dDepth>40.0) and (iStra_category=3) and (iPt_type=1) then dGongZuoLiang_m[53]:=dGongZuoLiang_m[53]+dEnd_Begin;
        if (dDepth<=50.0) and (dDepth>40.0) and (iStra_category=4) and (iPt_type=1) then dGongZuoLiang_m[54]:=dGongZuoLiang_m[54]+dEnd_Begin;

        ADO02.Next;
    end;
//    //���(<=20)/////////////////////
//    ADO02.Close;
//    ADO02.SQL.Text:='select spt.drl_no,count(spt.drl_no) as num from spt join stratum '+
//                    'on spt.prj_no=stratum.prj_no and '+
//                    'spt.drl_no=stratum.drl_no and spt.stra_no=stratum.stra_no '+
//                    'and spt.sub_no=stratum.sub_no where spt.begin_depth<=20 '+
//                    'and spt.drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
//                    'and spt.prj_no=''' + strProjectCode + ''' group by spt.drl_no order by spt.drl_no';
//    ADO02.Open;
//
//    for i:=0 to strRecord[0].Count-1 do
//    begin
//      if UpperCase(strRecord[0][i])=UpperCase(ADO02.FieldByName('drl_no').AsString) then
//      begin
//          strRecord[4].Add(ADO02.FieldByName('num').AsString);
//          ADO02.Next;
//      end
//      else
//          strRecord[4].Add('0');
//    end;
//    strRecord[4].Add(floattostr(intguanbiao[1]+intguanbiao[2]+intguanbiao[3]));
//
//    //���(>20<=50)//////////////////////
//    ADO02.Close;
//    ADO02.SQL.Text:='select spt.drl_no,count(spt.drl_no) as num from spt join stratum '+
//                    'on spt.prj_no=stratum.prj_no and '+
//                    'spt.drl_no=stratum.drl_no and spt.stra_no=stratum.stra_no '+
//                    'and spt.sub_no=stratum.sub_no where spt.begin_depth>20 and spt.begin_depth<=50'+
//                    'and spt.drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
//                    'and spt.prj_no=''' + strProjectCode + ''' group by spt.drl_no order by spt.drl_no';
//    ADO02.Open;
//
//    for i:=0 to strRecord[0].Count-1 do
//    begin
//      if UpperCase(strRecord[0][i])=UpperCase(ADO02.FieldByName('drl_no').AsString) then
//      begin
//          strRecord[5].Add(ADO02.FieldByName('num').AsString);
//          ADO02.Next;
//      end
//      else
//          strRecord[5].Add('0');
//    end;
//    strRecord[5].Add(floattostr(intguanbiao[4]+intguanbiao[5]+intguanbiao[6]));
//
//    //���(>50)//////////////////////
//    ADO02.Close;
//    ADO02.SQL.Text:='select spt.drl_no,count(spt.drl_no) as num from spt join stratum '+
//                    'on spt.prj_no=stratum.prj_no and '+
//                    'spt.drl_no=stratum.drl_no and spt.stra_no=stratum.stra_no '+
//                    'and spt.sub_no=stratum.sub_no where spt.begin_depth>50 '+
//                    'and spt.drl_no in (select drl_no from drills where '+m_JueSuan_FieldName+'=0 and prj_no='''+strProjectCode+''') '+
//                    'and spt.prj_no=''' + strProjectCode + ''' group by spt.drl_no order by spt.drl_no';
//    ADO02.Open;
//
//    for i:=0 to strRecord[0].Count-1 do
//    begin
//      if UpperCase(strRecord[0][i])=UpperCase(ADO02.FieldByName('drl_no').AsString) then
//      begin
//          strRecord[6].Add(ADO02.FieldByName('num').AsString);
//          ADO02.Next;
//      end
//      else
//          strRecord[6].Add('0');
//    end;
//    strRecord[6].Add(floattostr(intguanbiao[7]+intguanbiao[8]+intguanbiao[9]));
//

    //д��EXCEL�ļ�
    ExcelApplication1:=CreateOleObject('Excel.Application');
    ExcelWorkbook1:=CreateOleobject('Excel.Sheet');
    xlsFileName:=ERP1.Text;
    ExcelWorkbook1:=ExcelApplication1.workBooks.Open(xlsFileName);

    //����
    ExcelApplication1.Cells(9,17) :=dGongZuoLiang_m[0];
    ExcelApplication1.Cells(10,17):=dGongZuoLiang_m[1];
    ExcelApplication1.Cells(11,17):=dGongZuoLiang_m[2];

    //����
    ExcelApplication1.Cells(12,17):=dGongZuoLiang_m[10];
    ExcelApplication1.Cells(13,17):=dGongZuoLiang_m[11];
    ExcelApplication1.Cells(14,17):=dGongZuoLiang_m[12];
    ExcelApplication1.Cells(15,17):=dGongZuoLiang_m[13];
    ExcelApplication1.Cells(16,17):=dGongZuoLiang_m[14];

    ExcelApplication1.Cells(17,17):=dGongZuoLiang_m[20];
    ExcelApplication1.Cells(18,17):=dGongZuoLiang_m[21];
    ExcelApplication1.Cells(19,17):=dGongZuoLiang_m[22];
    ExcelApplication1.Cells(20,17):=dGongZuoLiang_m[23];
    ExcelApplication1.Cells(21,17):=dGongZuoLiang_m[24];

    ExcelApplication1.Cells(22,17):=dGongZuoLiang_m[30];
    ExcelApplication1.Cells(23,17):=dGongZuoLiang_m[31];
    ExcelApplication1.Cells(24,17):=dGongZuoLiang_m[32];
    ExcelApplication1.Cells(25,17):=dGongZuoLiang_m[33];
    ExcelApplication1.Cells(26,17):=dGongZuoLiang_m[34];

    ExcelApplication1.Cells(27,17):=dGongZuoLiang_m[40];
    ExcelApplication1.Cells(28,17):=dGongZuoLiang_m[41];
    ExcelApplication1.Cells(29,17):=dGongZuoLiang_m[42];
    ExcelApplication1.Cells(30,17):=dGongZuoLiang_m[43];
    ExcelApplication1.Cells(31,17):=dGongZuoLiang_m[44];

    ExcelApplication1.Cells(32,17):=dGongZuoLiang_m[50];
    ExcelApplication1.Cells(33,17):=dGongZuoLiang_m[51];
    ExcelApplication1.Cells(34,17):=dGongZuoLiang_m[52];
    ExcelApplication1.Cells(35,17):=dGongZuoLiang_m[53];
    ExcelApplication1.Cells(36,17):=dGongZuoLiang_m[54];

    ExcelWorkbook1.Save;
    ExcelWorkbook1.Close;
    ExcelApplication1.Quit;
    ExcelApplication1:=Unassigned;

    result:=0;

end;

procedure TfrmCharge92.setJueSuanFieldName(iIndex: integer);
begin
  if iIndex<=0 then
      m_JueSuan_FieldName := 'can_juesuan'
  else
      m_JueSuan_FieldName := 'can_juesuan' + IntToStr(iIndex);
end;

end.
