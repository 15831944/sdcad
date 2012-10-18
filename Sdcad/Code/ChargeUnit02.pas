unit ChargeUnit02;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, DB, ADODB,dateutils,shellapi,
  OleServer, Excel2000;

type
  TChargeForm02 = class(TForm)
    AQRP3: TADOQuery;
    AQRP2: TADOQuery;
    AQRP1: TADOQuery;
    SEFDlg: TSaveDialog;
    Label1: TLabel;
    Label2: TLabel;
    Label21: TLabel;
    STPrj1: TStaticText;
    STPrj2: TStaticText;
    GroupBox1: TGroupBox;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Bevel9: TBevel;
    Label12: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label14: TLabel;
    Bevel3: TBevel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label25: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Bevel4: TBevel;
    Label32: TLabel;
    Label33: TLabel;
    Label13: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    BBPrj1: TBitBtn;
    BBPrj2: TBitBtn;
    STPrj4: TStaticText;
    STPrj5: TStaticText;
    STPrj6: TStaticText;
    BBPrj11: TBitBtn;
    STPrj41: TStaticText;
    BBPrj12: TBitBtn;
    STPrj42: TStaticText;
    BBPrj13: TBitBtn;
    STPrj43: TStaticText;
    STPrj44: TStaticText;
    STPrj45: TStaticText;
    STPrj51: TStaticText;
    STPrj46: TStaticText;
    STPrj52: TStaticText;
    STPrj47: TStaticText;
    GroupBox3: TGroupBox;
    Label18: TLabel;
    Bevel11: TBevel;
    Label19: TLabel;
    Label20: TLabel;
    Bevel13: TBevel;
    Bevel14: TBevel;
    Label22: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label7: TLabel;
    Label24: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label23: TLabel;
    Label36: TLabel;
    STPrj8: TStaticText;
    ChBPrj1: TCheckBox;
    RBPrj1: TRadioButton;
    RBPrj2: TRadioButton;
    STPrj7: TStaticText;
    RBPrj3: TRadioButton;
    RBPrj4: TRadioButton;
    EPrj1: TEdit;
    ChBPrj2: TCheckBox;
    BBOther: TBitBtn;
    STOther: TStaticText;
    ChBPrj5: TCheckBox;
    EPrj2: TEdit;
    BBPrj5: TBitBtn;
    BBPrj3: TBitBtn;
    STPrj3: TStaticText;
    GroupBox4: TGroupBox;
    BBPrj4: TBitBtn;
    STReport: TStaticText;
    STDir: TStaticText;
    BBPrj6: TBitBtn;
    ERP1: TEdit;
    BBPrj7: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure EPrj3KeyPress(Sender: TObject; var Key: Char);
    procedure EPrj3Exit(Sender: TObject);
    procedure EPrj2KeyPress(Sender: TObject; var Key: Char);
    procedure ChBPrj1Click(Sender: TObject);
    procedure BBPrj5Click(Sender: TObject);
    procedure BBPrj3Click(Sender: TObject);
    procedure ChBPrj2Click(Sender: TObject);
    procedure RBPrj1Click(Sender: TObject);
    procedure RBPrj2Click(Sender: TObject);
    procedure BBPrj1Click(Sender: TObject);
    procedure BBPrj2Click(Sender: TObject);
    procedure RBPrj3Click(Sender: TObject);
    procedure RBPrj4Click(Sender: TObject);
    procedure EPrj1Exit(Sender: TObject);
    procedure BBPrj11Click(Sender: TObject);
    procedure BBPrj12Click(Sender: TObject);
    procedure BBPrj13Click(Sender: TObject);
    procedure BBPrj6Click(Sender: TObject);
    procedure BBPrj7Click(Sender: TObject);
    procedure BBPrj4Click(Sender: TObject);
    procedure EPrj1KeyPress(Sender: TObject; var Key: Char);
    procedure EPrj1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BBOtherClick(Sender: TObject);
    procedure EPrj2Exit(Sender: TObject);
    procedure ChBPrj5Click(Sender: TObject);
    procedure EPrj1Enter(Sender: TObject);
  private
    { Private declarations }
    isSelAll:boolean;
    //���ݴ����������ؽ��true--�ɹ�,false--ʧ��
    function DataProccess(OnlyAModulus:boolean=false;IsSave:boolean=false):boolean;
    function ReportProcess:boolean;
  public
    { Public declarations }
  end;

var
  ChargeForm02: TChargeForm02;

implementation
   uses Expression02,public_unit,MainDM,UReconMap02,UExperiment02,
  UReconKT02, UReconEWS02,UReconYWCS02,OtherCharges02;
{$R *.dfm}
var
   aSList:tstrings;
   IsFirst:boolean;
   m_RBVal,m_RBVal1:double;
   m_RBID:string;

function TChargeForm02.DataProccess(OnlyAModulus:boolean=false;IsSave:boolean=false):boolean;
var
   aValue:double;
begin
   if not OnlyAModulus then
      begin
      STPrj44.Caption :=formatfloat('0.00',strtofloat(STPrj4.Caption)+strtofloat(STPrj41.Caption)+strtofloat(STPrj42.Caption)+strtofloat(STPrj43.Caption));
      STPrj45.Caption:=formatfloat('0.00',strtofloat(STPrj44.Caption)*strtofloat(STPrj47.Caption)/100);
      STPrj46.Caption:=formatfloat('0.00',strtofloat(STPrj44.Caption)+strtofloat(STPrj45.Caption));
      STPrj51.Caption:=formatfloat('0.00',strtofloat(STPrj5.Caption)*0.1);
      STPrj52.Caption:=formatfloat('0.00',strtofloat(STPrj5.Caption)+strtofloat(STPrj51.Caption));
      end;
   aValue:=strtofloat(STPrj46.Caption)+strtofloat(STPrj52.Caption);
   if not OnlyAModulus then
      STPrj6.Caption :=formatfloat('0.00',aValue);
   STPrj8.Caption := formatfloat('0.00',aValue*strtofloat(STPrj7.Caption)+strtofloat(STOther.caption));
   if IsSave then
      begin
      if not ReopenQryFAcount(MainDataModule.qryFAcount,'select * from adjustment02 where prj_no='''+g_ProjectInfo.prj_no_ForSQL+''' and itemid='''+'00'+'''') then
         begin
         result:=false;
         exit;
         end;
      try
         if MainDataModule.qryFAcount.RecordCount<1 then
            begin
            MainDataModule.qryFAcount.Insert;
            MainDataModule.qryFAcount.FieldByName('prj_no').AsString := g_ProjectInfo.prj_no;
            MainDataModule.qryFAcount.FieldByName('itemid').AsString :='00';
            end
         else
            MainDataModule.qryFAcount.Edit ;
         MainDataModule.qryFAcount.FieldByName('adjustitems').AsString :=aSList.Text ;
         MainDataModule.qryFAcount.FieldByName('adjustmodulus').AsFloat :=strtofloat(STPrj7.Caption);
         MainDataModule.qryFAcount.FieldByName('othercharge').AsFloat := strtofloat(STOther.Caption);
         MainDataModule.qryFAcount.FieldByName('mod1025').AsFloat := strtofloat(trim(ePrj1.Text));
         //MainDataModule.qryFAcount.FieldByName('floatvalue').AsFloat := strtofloat(trim(ePrj2.Text));
         MainDataModule.qryFAcount.Post ;
      except
         result:=false;
         exit;
      end;
      end;
   result:=true;
end;

procedure TChargeForm02.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
aSList.Free ;
Action := caFree;
end;

procedure TChargeForm02.FormCreate(Sender: TObject);
var
   SaveFName,tmp:string;
begin
   datetimetostring(SaveFName,'yymmdd',today);
   datetimetostring(tmp,'hhnnss',time);
   SaveFName:='\rp'+SaveFName+tmp+'.xls';
   tmp:=ExtractFileDir(application.ExeName)+'\Report';
   if not directoryexists(tmp) then
      if not CreateDir(tmp) then tmp:=ExtractFileDir(application.ExeName);
   SaveFName:=tmp+SaveFName;
   ERP1.Text :=SaveFName;
   //---------------------------
   IsFirst:=true;
   isSelAll:=false;
   aSList:=tstringlist.Create;
   //self.Width := 696;
   //self.Height := 640;
  self.Left := trunc((screen.Width -self.Width)/2);
  self.Top  := trunc((Screen.Height - self.Height)/2);

   STPrj1.Caption := g_ProjectInfo.prj_no ;
   STPrj2.Caption := g_ProjectInfo.prj_name ;
   if ReopenQryFAcount(MainDataModule.qryFAcount,'select prj_no,prj_grade from projects where prj_no='''+g_ProjectInfo.prj_no_ForSQL+'''') then
      if MainDataModule.qryFAcount.fieldbyname('prj_grade').AsString='' then
         STPrj3.caption:='��'
      else
         begin
         STPrj3.caption:=MainDataModule.qryFAcount.fieldbyname('prj_grade').AsString+'��';
         if trim(MainDataModule.qryFAcount.fieldbyname('prj_grade').AsString)='��' then
            STPrj47.Caption :='120'
         else if trim(MainDataModule.qryFAcount.fieldbyname('prj_grade').AsString)='��' then
            STPrj47.Caption :='100';
         end;
   if trim(g_ProjectInfo.prj_no)='' then
      begin
      BBPrj1.Enabled :=false;
      BBPrj11.Enabled :=false;
      BBPrj12.Enabled :=false;
      BBPrj13.Enabled :=false;
      BBPrj2.Enabled :=false;
      BBPrj4.Enabled :=false;
      BBPrj6.Enabled :=false;
      BBPrj7.Enabled :=false;
      ERP1.Enabled :=false;
      ChBPrj1.Enabled :=false;
      ChBPrj2.Enabled :=false;
      exit;
      end;
   //--------------��ȡ����ϵ������������----------------
   if ReopenQryFAcount(MainDataModule.qryFAcount,'select * from adjustment02 where prj_no='''+g_ProjectInfo.prj_no_ForSQL+''' and itemid='''+'00'+'''') then
      if MainDataModule.qryFAcount.RecordCount>0 then
         begin
         STOther.Caption := formatfloat('0.00',MainDataModule.qryFAcount.FieldByName('othercharge').AsFloat);
         aSList.Text :=MainDataModule.qryFAcount.FieldByName('adjustitems').AsString;
         if PosStrInList(aSList,'01')>=0 then ChBPrj2.Checked :=true;
         if PosStrInList(aSList,'02')>=0 then
            begin
            RBPrj1.Checked :=true;
            ChBPrj1.Checked :=true;
            end;
         if PosStrInList(aSList,'03')>=0 then
            begin
            RBPrj2.Checked :=true;
            ChBPrj1.Checked :=true;
            end;
         if PosStrInList(aSList,'04')>=0 then
            begin
            RBPrj3.Checked :=true;
            ChBPrj1.Checked :=true;
            end;
         if PosStrInList(aSList,'05')>=0 then
            begin
            RBPrj4.Checked :=true;
            eprj1.Text :=formatfloat('0.00',MainDataModule.qryFAcount.FieldByName('mod1025').AsFloat) ;
            EditFormat(eprj1);
            ChBPrj1.Checked :=true;
            end;
         if PosStrInList(aSList,'31')>=0 then
            begin
            eprj2.Text :=formatfloat('0.00',MainDataModule.qryFAcount.FieldByName('floatvalue').AsFloat) ;
            EditFormat(eprj2);
            ChBPrj5.Checked :=true;
            end;
         end;
   //-------------------��ȡ�����շѺ������շѲ����㼼���Ѻ����շ�-------------------
   if ReopenQryFAcount(MainDataModule.qryFAcount,'select prj_no,itemid,money from charge02 where prj_no='''+g_ProjectInfo.prj_no_ForSQL+''' and (itemid='''+'0101'+''' or itemid='''+'0102321'+''' or itemid='''+'010265'+''' or itemid='''+'0103'+''' or itemid='''+'02'+''')') then
      while not MainDataModule.qryFAcount.Eof do
      begin
         if MainDataModule.qryFAcount.FieldByName('itemid').AsString='0101' then
            STPrj4.Caption :=formatfloat('0.00',MainDataModule.qryFAcount.FieldByName('money').AsFloat)
         else if MainDataModule.qryFAcount.FieldByName('itemid').AsString='0102321' then
            STPrj41.Caption :=formatfloat('0.00',MainDataModule.qryFAcount.FieldByName('money').AsFloat)
         else if MainDataModule.qryFAcount.FieldByName('itemid').AsString='010265' then
            STPrj42.Caption :=formatfloat('0.00',MainDataModule.qryFAcount.FieldByName('money').AsFloat)
         else if MainDataModule.qryFAcount.FieldByName('itemid').AsString='0103' then
            STPrj43.Caption :=formatfloat('0.00',MainDataModule.qryFAcount.FieldByName('money').AsFloat)
         else
            STPrj5.Caption :=formatfloat('0.00',MainDataModule.qryFAcount.FieldByName('money').AsFloat);
         MainDataModule.qryFAcount.Next ;
      end;
   DataProccess;
   IsFirst:=false;
end;
//--------------�Զ������������----------------
procedure TChargeForm02.EPrj3KeyPress(Sender: TObject; var Key: Char);
begin
end;

//--------------��Χ����----------------
procedure TChargeForm02.EPrj3Exit(Sender: TObject);
begin
end;
//--------------�Զ������������----------------
procedure TChargeForm02.EPrj2KeyPress(Sender: TObject; var Key: Char);
begin
end;
//--------------��ʽ��----------------
procedure TChargeForm02.ChBPrj1Click(Sender: TObject);
var
   i:integer;
begin
if ChBPrj1.Checked then
   begin
   RBPrj1.Enabled :=true;
   RBPrj2.Enabled :=true;
   RBPrj3.Enabled :=true;
   RBPrj4.Enabled :=true;
   if RBPrj1.Checked then
      begin
      m_RBID:='02';
      m_RBVal:=0.10;
      end
   else if RBPrj2.Checked then
      begin
      m_RBID:='03';
      m_RBVal:=0.20;
      end
   else if RBPrj3.Checked then
      begin
      m_RBID:='04';
      m_RBVal:=0.30;
      end
   else
      begin
      m_RBID:='05';
      m_RBVal:=strtofloat(trim(EPrj1.Text))-1.00;
      end;
   if PosStrInList(aSList,m_RBID)<0 then aSList.Add(m_RBID);
   STPrj7.Caption :=formatfloat('0.00',strtofloat(STPrj7.Caption)+m_RBVal);
   end
else
   begin
   i:=PosStrInList(aSList,m_RBID);
   if i>=0 then aSList.Delete(i);
   STPrj7.Caption :=formatfloat('0.00',strtofloat(STPrj7.Caption)-m_RBVal);
   RBPrj1.Enabled :=false;
   RBPrj2.Enabled :=false;
   RBPrj3.Enabled :=false;
   RBPrj4.Enabled :=false;
   if m_RBID='05' then EPrj1.Enabled :=false;
   end;
if IsFirst then
   DataProccess(true)
else
   if not DataProccess(true,true) then application.MessageBox(DBERR_NOTSAVE,HINT_TEXT);
end;

procedure TChargeForm02.BBPrj5Click(Sender: TObject);
begin
close;
end;

procedure TChargeForm02.BBPrj3Click(Sender: TObject);
begin
   application.CreateForm(TExpressForm02,ExpressForm02);
   ExpressForm02.ShowModal;
end;

procedure TChargeForm02.ChBPrj2Click(Sender: TObject);
var
   i:integer;
begin
   if ChBPrj2.Checked then
      begin
      if PosStrInList(aSList,'01')<0 then aSList.Add('01');
      STPrj7.Caption:=formatfloat('0.00',strtofloat(STPrj7.Caption)+0.2);
      end
   else
      begin
      i:=PosStrInList(aSList,'01');
      if i>=0 then aSList.Delete(i);
      STPrj7.Caption:=formatfloat('0.00',strtofloat(STPrj7.Caption)-0.2);
      end;
   if IsFirst then
      DataProccess(true)
   else
      if not DataProccess(true,true) then application.MessageBox(DBERR_NOTSAVE,HINT_TEXT);
end;

procedure TChargeForm02.RBPrj1Click(Sender: TObject);
var
   i:integer;
begin
   if IsFirst then exit;
   if m_RBID='05' then EPrj1.Enabled :=false;
   i:=PosStrInList(aSList,m_RBID);
   if i>=0 then aSList.Delete(i);
   if PosStrInList(aSList,'02')<0 then aSList.Add('02');
   m_RBID:='02';
   STPrj7.Caption :=formatfloat('0.00',strtofloat(STPrj7.Caption)+0.10-m_RBVal);
   m_RBVal:=0.1;
   if not DataProccess(true,true) then application.MessageBox(DBERR_NOTSAVE,HINT_TEXT);
end;

procedure TChargeForm02.RBPrj2Click(Sender: TObject);
var
   i:integer;
begin
   if IsFirst then exit;
   if m_RBID='05' then EPrj1.Enabled :=false;
   i:=PosStrInList(aSList,m_RBID);
   if i>=0 then aSList.Delete(i);
   if PosStrInList(aSList,'03')<0 then aSList.Add('03');
   m_RBID:='03';
   STPrj7.Caption :=formatfloat('0.00',strtofloat(STPrj7.Caption)+0.20-m_RBVal);
   m_RBVal:=0.2;
   if not DataProccess(true,true) then application.MessageBox(DBERR_NOTSAVE,HINT_TEXT);
end;

procedure TChargeForm02.BBPrj1Click(Sender: TObject);
begin
   screen.Cursor:=crHourGlass	;
   application.CreateForm(TReconMap02,ReconMap02);
   screen.Cursor:=crDefault;
   ReconMap02.ShowModal;
   STPrj4.Caption := formatfloat('0.00',strtofloat(ReconMap02.STMap4.caption));
   DataProccess ;
end;

procedure TChargeForm02.BBPrj2Click(Sender: TObject);
begin
   screen.Cursor:=crHourGlass	;
   application.CreateForm(TExperiment02,Experiment02);
   screen.Cursor:=crDefault;
   Experiment02.ShowModal;
   STPrj5.Caption := Experiment02.ST_TestMoney.Caption;
   DataProccess ;
end;

procedure TChargeForm02.RBPrj3Click(Sender: TObject);
var
   i:integer;
begin
   if IsFirst then exit;
   if m_RBID='05' then EPrj1.Enabled :=false;
   i:=PosStrInList(aSList,m_RBID);
   if i>=0 then aSList.Delete(i);
   if PosStrInList(aSList,'04')<0 then aSList.Add('04');
   m_RBID:='04';
   STPrj7.Caption :=formatfloat('0.00',strtofloat(STPrj7.Caption)+0.30-m_RBVal);
   m_RBVal:=0.3;
   if not DataProccess(true,true) then application.MessageBox(DBERR_NOTSAVE,HINT_TEXT);
end;

procedure TChargeForm02.RBPrj4Click(Sender: TObject);
var
   i:integer;
begin
   EPrj1.Enabled :=true;
   if IsFirst then exit;
   i:=PosStrInList(aSList,m_RBID);
   if i>=0 then aSList.Delete(i);
   if PosStrInList(aSList,'05')<0 then aSList.Add('05');
   m_RBID:='05';
   STPrj7.Caption :=formatfloat('0.00',strtofloat(STPrj7.Caption)+strtofloat(trim(EPrj1.Text))-1.00-m_RBVal);
   m_RBVal:=strtofloat(trim(EPrj1.Text))-1.00;
   if not DataProccess(true,true) then application.MessageBox(DBERR_NOTSAVE,HINT_TEXT);
end;

procedure TChargeForm02.EPrj1Exit(Sender: TObject);
begin
   if trim(EPrj1.Text)='' then EPrj1.Text:='1.30';
   if strtofloat(trim(EPrj1.Text))<1.30 then
      EPrj1.Text :='1.30';
   EPrj1.Text:=formatfloat('0.00',strtofloat(trim(EPrj1.Text)));
   EditFormat(eprj1);
   STPrj7.Caption :=formatfloat('0.00',strtofloat(STPrj7.Caption)+strtofloat(trim(EPrj1.Text))-1.0-m_RBVal);
   m_RBVal:=strtofloat(trim(EPrj1.Text))-1.0;
   if not DataProccess(true,true) then application.MessageBox(DBERR_NOTSAVE,HINT_TEXT);
end;

procedure TChargeForm02.BBPrj11Click(Sender: TObject);
begin
   screen.Cursor:=crHourGlass	;
   application.CreateForm(TReconKT02,ReconKT02);
   screen.Cursor:=crDefault;
   ReconKT02.ShowModal;
   STPrj41.Caption := formatfloat('0.00',strtofloat(ReconKT02.STRecon3.caption));
   DataProccess ;
end;

procedure TChargeForm02.BBPrj12Click(Sender: TObject);
begin
   screen.Cursor:=crHourGlass	;
   application.CreateForm(TReconEWS02,ReconEWS02);
   screen.Cursor:=crDefault;
   ReconEWS02.ShowModal;
   STPrj42.Caption := formatfloat('0.00',strtofloat(ReconEWS02.STRecon3.caption));
   DataProccess ;
end;

procedure TChargeForm02.BBPrj13Click(Sender: TObject);
begin
   screen.Cursor:=crHourGlass	;
   application.CreateForm(TReconYWCS02,ReconYWCS02);
   screen.Cursor:=crDefault;
   ReconYWCS02.ShowModal;
   STPrj43.Caption := formatfloat('0.00',strtofloat(ReconYWCS02.STYWCS2.Caption));
   DataProccess ;
end;

procedure TChargeForm02.BBPrj6Click(Sender: TObject);
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

procedure TChargeForm02.BBPrj7Click(Sender: TObject);
var
   sfName:string;
begin
   sfName:=trim(ERP1.Text);
   if fileexists(sfName) then
      shellexecute(application.Handle,PAnsiChar(''),PAnsiChar(sfName),PAnsiChar(''),PAnsiChar(''),SW_SHOWNORMAL)
   else
      Application.Messagebox(FILE_NOTEXIST,HINT_TEXT, MB_ICONEXCLAMATION + mb_Ok);
end;

procedure TChargeForm02.BBPrj4Click(Sender: TObject);
var
   aFlag:boolean;
begin
   if fileexists(trim(ERP1.Text)) then
      if Application.Messagebox(FILE_EXIST,HINT_TEXT, MB_ICONEXCLAMATION +MB_YESNO)=IDNO then
         exit
      else
         if not deletefile(trim(ERP1.Text)) then
            begin
            Application.Messagebox(FILE_DELERR,HINT_TEXT, MB_ICONEXCLAMATION +MB_OK);
            exit;
            end;
   STReport.Font.Color :=clNavy;
   STReport.Caption :=REPORT_PROCCESS;
   screen.Cursor:=crHourGlass	;
   aFlag:=ReportProcess;
   STReport.Font.Color :=clRed;
   if aFlag then
      STReport.Caption :=REPORT_SUCCESS
   else
      STReport.Caption :=REPORT_FAIL;
   screen.Cursor:=crDefault;
end;

function TChargeForm02.ReportProcess:boolean;
var
   i,j: integer;
   aSum,sSum,tmpSum,someSum,exSum,m1025,aOther,atmp,AdMod:double;
   aOVValue,aStartCell,aEndCell:olevariant;
   aList:tstrings;
   tmpStr:string;

   ExcelApplication1:TExcelApplication;
   ExcelWorksheet1:TExcelWorksheet;
   ExcelWorkbook1:TExcelWorkbook;
begin
  result:=false;
  if trim(ERP1.Text)='' then exit;
  try
     ExcelApplication1 := TExcelApplication.Create(Application);
     ExcelWorksheet1 := TExcelWorksheet.Create(Application);
     ExcelWorkbook1 := TExcelWorkbook.Create(Application);
     ExcelApplication1.Connect;
  except
     Application.Messagebox(EXCEL_NOTINSTALL,HINT_TEXT, MB_ICONERROR + mb_Ok);
     result:=false;
     exit;
  end;
  try
     ExcelApplication1.Workbooks.Add(xlWBATWorksheet, 0);
     ExcelWorkbook1.ConnectTo(ExcelApplication1.Workbooks[1]);
     ExcelWorksheet1.ConnectTo(ExcelWorkbook1.Worksheets[1] as _worksheet);
     //-------------�ϲ���Ԫ,�����--------------
     aOVValue:=ExcelWorksheet1.Cells.Range['A1','F1'];
     aOVValue.HorizontalAlignment :=  xlCenter;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.MergeCells := true;
     aOVValue.Font.Size:='14';
     aOVValue.FormulaR1C1:=REPORT_TITLE;
     //-------------���̱��---------------
     aOVValue:=ExcelWorksheet1.Cells.Range['A2','B2'];
     aOVValue.HorizontalAlignment :=  xlLeft;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.MergeCells := true;
     aOVValue.FormulaR1C1:='���̱�ţ�'+g_ProjectInfo.prj_no;
     //-------------��������---------------
     aOVValue:=ExcelWorksheet1.Cells.Range['C2','F2'];
     aOVValue.HorizontalAlignment :=  xlRight;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.MergeCells := true;
     aOVValue.FormulaR1C1:='�������ƣ�'+g_ProjectInfo.prj_name;
     //-------------�������̿���---------------
     i:=4;
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
     aOVValue.HorizontalAlignment :=  xlLeft;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.MergeCells := true;
     aOVValue.FormulaR1C1:='һ���������̿���';
     aStartCell:=aOVValue;
     inc(i);

     AQRP3.Close ;
     AQRP3.SQL.Text :='select * from adjustmodulus02';
     AQRP3.Open ;
     aList:=tstringlist.Create ;
     sSum:=0;
     //-------------���̵��ʲ��---------------
     aSum:=0;
     AQRP1.Close ;
     AQRP1.SQL.Text :='select itemname,category,unitprice,adjustuprice,actualvalue,money,prj_no,charge02.itemid from charge02,unitprice02 where (prj_no='''+g_ProjectInfo.prj_no_ForSQL+''') and (substring(charge02.itemid,1,6)='''+'010101'+''') and (charge02.itemid=unitprice02.itemid)';
     AQRP1.Open ;
     if AQRP1.RecordCount>0 then
       begin
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='(һ)�����̵��ʲ��';
        inc(i);
        aOVValue:=ExcelWorksheet1.Cells;
        aOVValue.item[i, 'A'].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 'A']:='��ͼ������';
        aOVValue.item[i, 2].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 2]:='���ӳ̶�';
        aOVValue.item[i, 3].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 3]:='��׼����';
        aOVValue.item[i, 4].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 4]:='��������';
        aOVValue.item[i, 5].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 5].WrapText :=  true;
        aOVValue.item[i, 5]:='��ͼ���(k�O)';
        aOVValue.item[i, 6].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 6]:='���';
        //------------------------------
        inc(i);
        while not AQRP1.Eof do
           begin
           for j:=1 to 6 do
              begin
              if j<=2 then aOVValue.item[i,j].NumberFormatLocal:='@'
              else aOVValue.item[i,j].NumberFormatLocal:='0.00';
              aOVValue.item[i, j]:=AQRP1.fields.Fields[j-1].AsString;
              end;
           aSum:=aSum+AQRP1.fieldbyname('money').AsFloat;
           AQRP1.Next ;
           inc(i);
           end;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='���̵��ʲ��С��';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
        inc(i);
        //-------------
        AQRP2.Close ;
        AQRP2.SQL.Text :='select prj_no,itemid,adjustitems from adjustment02 where prj_no='''+g_ProjectInfo.prj_no_ForSQL+''' and itemid='''+'0101'+'''';
        AQRP2.Open ;
        aList.Clear ;
        aList.Text :=AQRP2.Fieldbyname('adjustitems').AsString ;
        if aList.Count>0 then
           begin
             tmpSum:=0;
             for j:=0 to aList.Count-1 do
                begin
                  AQRP3.Locate('aitemid',aList[j],[loPartialKey]);
                  aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
                  aOVValue.HorizontalAlignment :=  xlLeft;
                  aOVValue.VerticalAlignment :=  xlCenter;
                  aOVValue.MergeCells := true;
                  aOVValue.FormulaR1C1:=AQRP3.Fieldbyname('adjustitems').AsString+'--'+AQRP3.Fieldbyname('description').AsString;
                  //-------------
                  aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
                  aOVValue.HorizontalAlignment :=  xlRight;
                  aOVValue.VerticalAlignment :=  xlCenter;
                  aOVValue.NumberFormatLocal:='0.00';
                  atmp:=aSum*(AQRP3.Fieldbyname('adjustmodulus').AsFloat-1);
                  aOVValue.FormulaR1C1:=formatfloat('0.00',atmp);
                  tmpSum:=tmpSum+atmp;
                  inc(i);
                end;
             aSum:=aSum+tmpSum;
             aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
             aOVValue.HorizontalAlignment :=  xlLeft;
             aOVValue.VerticalAlignment :=  xlCenter;
             aOVValue.MergeCells := true;
             aOVValue.FormulaR1C1:='���̵��ʲ��ϼ�';
             //-------------
             aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
             aOVValue.HorizontalAlignment :=  xlRight;
             aOVValue.VerticalAlignment :=  xlCenter;
             aOVValue.NumberFormatLocal:='0.00';
             aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
             inc(i);
        end;
        //
        sSum:=sSum+aSum;
     end;
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
     aOVValue.MergeCells := true;
     inc(i);
     //-------------�������̿���---------------
     someSum:=0;
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
     aOVValue.HorizontalAlignment :=  xlLeft;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.MergeCells := true;
     aOVValue.FormulaR1C1:='(��)���������̿�̽';
     inc(i);
     //-------------���---------------
     aSum:=0;
     AQRP1.Close ;
     AQRP1.SQL.Text :='select depth_type,drange,category,max(unitprice) as uprice,'''+''+''' as adjustuprice,sum(depth) as sdepth,sum(money) as smoney from drillcharge02  where prj_no='''+g_ProjectInfo.prj_no_ForSQL+''' and drill_type='''+'1'+''' group by depth_type,drange,category order by depth_type,drange,category';
     AQRP1.Open ;
     if AQRP1.RecordCount>0 then
        begin
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='1�����';
        inc(i);
        aOVValue:=ExcelWorksheet1.Cells;
        aOVValue.item[i, 'A'].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 'A']:='��̽���';
        aOVValue.item[i, 2].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 2]:='�ز����';
        aOVValue.item[i, 3].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 3]:='��׼����';
        aOVValue.item[i, 4].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 4]:='��������';
        aOVValue.item[i, 5].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 5].WrapText :=  true;
        aOVValue.item[i, 5]:='������(m)';
        aOVValue.item[i, 6].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 6]:='���';
        //------------------------------
        inc(i);
        while not AQRP1.Eof do
           begin
           for j:=2 to 7 do
              begin
              if j<=3 then aOVValue.item[i,j-1].NumberFormatLocal:='@'
              else aOVValue.item[i,j-1].NumberFormatLocal:='0.00';
              aOVValue.item[i, j-1]:=AQRP1.fields.Fields[j-1].AsString;
              end;
           aSum:=aSum+AQRP1.fieldbyname('smoney').AsFloat;
           AQRP1.Next ;
           inc(i);
           end;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='���С��';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
        inc(i);
        //-------------
        AQRP2.Close ;
        AQRP2.SQL.Text :='select prj_no,itemid,adjustitems,othercharge from adjustment02 where prj_no='''+g_ProjectInfo.prj_no_ForSQL+''' and itemid='''+'010201'+'''';
        AQRP2.Open ;
        aList.Clear ;
        aList.Text :=AQRP2.Fieldbyname('adjustitems').AsString ;
        tmpSum:=0;
        atmp:=0;
        if aList.Count>0 then
           begin
           for j:=0 to aList.Count-1 do
              begin
              AQRP3.Locate('aitemid',aList[j],[loPartialKey]);
              aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
              aOVValue.HorizontalAlignment :=  xlLeft;
              aOVValue.VerticalAlignment :=  xlCenter;
              aOVValue.MergeCells := true;
              if AQRP3.Fieldbyname('description').AsString='' then
                 aOVValue.FormulaR1C1:=AQRP3.Fieldbyname('adjustitems').AsString
              else
                 aOVValue.FormulaR1C1:=AQRP3.Fieldbyname('adjustitems').AsString+'--'+AQRP3.Fieldbyname('description').AsString;
              //-------------
              aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
              aOVValue.HorizontalAlignment :=  xlRight;
              aOVValue.VerticalAlignment :=  xlCenter;
              aOVValue.NumberFormatLocal:='0.00';
              atmp:=aSum*(AQRP3.Fieldbyname('adjustmodulus').AsFloat-1);
              aOVValue.FormulaR1C1:=formatfloat('0.00',atmp);
              tmpSum:=tmpSum+atmp;
              inc(i);
              end;
           aSum:=aSum+tmpSum;
           aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
           aOVValue.HorizontalAlignment :=  xlLeft;
           aOVValue.VerticalAlignment :=  xlCenter;
           aOVValue.MergeCells := true;
           aOVValue.FormulaR1C1:='��׺ϼ�';
           //-------------
           aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
           aOVValue.HorizontalAlignment :=  xlRight;
           aOVValue.VerticalAlignment :=  xlCenter;
           aOVValue.NumberFormatLocal:='0.00';
           aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
           inc(i);
           end;
        someSum:=someSum+aSum;
        end;
     //---------̽��----------
     aSum:=0;
     AQRP1.Close ;
     AQRP1.SQL.Text :='select depth_type,drange,category,max(unitprice) as uprice,'''+''+''' as adjustuprice,sum(depth) as sdepth,sum(money) as smoney from drillcharge02  where prj_no='''+g_ProjectInfo.prj_no_ForSQL+''' and drill_type='''+'2'+''' group by depth_type,drange,category order by depth_type,drange,category';
     AQRP1.Open ;
     if AQRP1.RecordCount>0 then
        begin
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='2��̽��';
        inc(i);
        aOVValue:=ExcelWorksheet1.Cells;
        aOVValue.item[i, 'A'].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 'A']:='������';
        aOVValue.item[i, 2].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 2]:='�ز����';
        aOVValue.item[i, 3].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 3]:='��׼����';
        aOVValue.item[i, 4].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 4]:='��������';
        aOVValue.item[i, 5].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 5].WrapText :=  true;
        aOVValue.item[i, 5]:='������(m)';
        aOVValue.item[i, 6].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 6]:='���';
        //------------------------------
        inc(i);
        while not AQRP1.Eof do
        begin
           for j:=2 to 7 do
              begin
              if j<=3 then aOVValue.item[i,j-1].NumberFormatLocal:='@'
              else aOVValue.item[i,j-1].NumberFormatLocal:='0.00';
              aOVValue.item[i, j-1]:=AQRP1.fields.Fields[j-1].AsString;
              end;
           aSum:=aSum+AQRP1.fieldbyname('smoney').AsFloat;
           AQRP1.Next ;
           inc(i);
        end;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='̽��С��';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
        inc(i);
        //-------------
        AQRP2.Close ;
        AQRP2.SQL.Text :='select prj_no,itemid,adjustitems,othercharge from adjustment02 where prj_no='''+g_ProjectInfo.prj_no_ForSQL+''' and itemid='''+'010202'+'''';
        AQRP2.Open ;
        aList.Clear ;
        aList.Text :=AQRP2.Fieldbyname('adjustitems').AsString ;
        tmpSum:=0;
        atmp:=0;
        if aList.Count>0 then
           begin
           for j:=0 to aList.Count-1 do
              begin
              AQRP3.Locate('aitemid',aList[j],[loPartialKey]);
              aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
              aOVValue.HorizontalAlignment :=  xlLeft;
              aOVValue.VerticalAlignment :=  xlCenter;
              aOVValue.MergeCells := true;
              if AQRP3.Fieldbyname('description').AsString='' then
                 aOVValue.FormulaR1C1:=AQRP3.Fieldbyname('adjustitems').AsString
              else
                 aOVValue.FormulaR1C1:=AQRP3.Fieldbyname('adjustitems').AsString+'--'+AQRP3.Fieldbyname('description').AsString;
              //-------------
              aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
              aOVValue.HorizontalAlignment :=  xlRight;
              aOVValue.VerticalAlignment :=  xlCenter;
              aOVValue.NumberFormatLocal:='0.00';
              atmp:=aSum*(AQRP3.Fieldbyname('adjustmodulus').AsFloat-1);
              aOVValue.FormulaR1C1:=formatfloat('0.00',atmp);
              tmpSum:=tmpSum+atmp;
              inc(i);
              end;
           aSum:=aSum+tmpSum;
           aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
           aOVValue.HorizontalAlignment :=  xlLeft;
           aOVValue.VerticalAlignment :=  xlCenter;
           aOVValue.MergeCells := true;
           aOVValue.FormulaR1C1:='̽���ϼ�';
           //-------------
           aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
           aOVValue.HorizontalAlignment :=  xlRight;
           aOVValue.VerticalAlignment :=  xlCenter;
           aOVValue.NumberFormatLocal:='0.00';
           aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
           inc(i);
           end;
        someSum:=someSum+aSum;
        end;
     //-------------̽��---------------
     aSum:=0;
     AQRP1.Close ;
     AQRP1.SQL.Text :='select itemname,category,unitprice,adjustuprice,actualvalue,money,prj_no,charge02.itemid from charge02,unitprice02 where (prj_no='''+g_ProjectInfo.prj_no_ForSQL+''') and (substring(charge02.itemid,1,6)='''+'010203'+''') and (charge02.itemid=unitprice02.itemid)';
     AQRP1.Open ;
     if AQRP1.RecordCount>0 then
        begin
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='3��̽��';
        inc(i);
        aOVValue:=ExcelWorksheet1.Cells;
        aOVValue.item[i, 'A'].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 'A']:='������';
        aOVValue.item[i, 2].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 2]:='�ز����';
        aOVValue.item[i, 3].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 3]:='��׼����';
        aOVValue.item[i, 4].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 4]:='��������';
        aOVValue.item[i, 5].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 5].WrapText :=  true;
        aOVValue.item[i, 5]:='������(������)';
        aOVValue.item[i, 6].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 6]:='���';
        //------------------------------
        inc(i);
        while not AQRP1.Eof do
           begin
           for j:=1 to 6 do
              begin
              if j<=2 then aOVValue.item[i,j].NumberFormatLocal:='@'
              else aOVValue.item[i,j].NumberFormatLocal:='0.00';
              aOVValue.item[i, j]:=AQRP1.fields.Fields[j-1].AsString;
              end;
           aSum:=aSum+AQRP1.fieldbyname('money').AsFloat;
           AQRP1.Next ;
           inc(i);
           end;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='̽��С��';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
        inc(i);
        //-------------
        tmpSum:=0;
        atmp:=0;
        AQRP2.Close ;
        AQRP2.SQL.Text :='select prj_no,itemid,adjustitems,othercharge from adjustment02 where prj_no='''+g_ProjectInfo.prj_no_ForSQL+''' and itemid='''+'010203'+'''';
        AQRP2.Open ;
        aList.Clear ;
        aList.Text :=AQRP2.Fieldbyname('adjustitems').AsString ;
        if aList.Count>0 then
           begin
           for j:=0 to aList.Count-1 do
              begin
              AQRP3.Locate('aitemid',aList[j],[loPartialKey]);
              aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
              aOVValue.HorizontalAlignment :=  xlLeft;
              aOVValue.VerticalAlignment :=  xlCenter;
              aOVValue.MergeCells := true;
              if AQRP3.Fieldbyname('description').AsString='' then
                 aOVValue.FormulaR1C1:=AQRP3.Fieldbyname('adjustitems').AsString
              else
                 aOVValue.FormulaR1C1:=AQRP3.Fieldbyname('adjustitems').AsString+'--'+AQRP3.Fieldbyname('description').AsString;
              //-------------
              aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
              aOVValue.HorizontalAlignment :=  xlRight;
              aOVValue.VerticalAlignment :=  xlCenter;
              aOVValue.NumberFormatLocal:='0.00';
              atmp:=aSum*(AQRP3.Fieldbyname('adjustmodulus').AsFloat-1);
              aOVValue.FormulaR1C1:=formatfloat('0.00',atmp);
              tmpSum:=tmpSum+atmp;
              inc(i);
              end;
           aSum:=aSum+tmpSum;
           aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
           aOVValue.HorizontalAlignment :=  xlLeft;
           aOVValue.VerticalAlignment :=  xlCenter;
           aOVValue.MergeCells := true;
           aOVValue.FormulaR1C1:='̽�ۺϼ�';
           //-------------
           aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
           aOVValue.HorizontalAlignment :=  xlRight;
           aOVValue.VerticalAlignment :=  xlCenter;
           aOVValue.NumberFormatLocal:='0.00';
           aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
           inc(i);
           end;
        someSum:=someSum+aSum;
        end;
     //-------�������̿�̽��--------
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
     aOVValue.MergeCells := true;
     inc(i);
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
     aOVValue.HorizontalAlignment :=  xlLeft;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.MergeCells := true;
     aOVValue.FormulaR1C1:='�������̿�̽��';
     //-------------
     aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
     aOVValue.HorizontalAlignment :=  xlRight;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.NumberFormatLocal:='0.00';
     aOVValue.FormulaR1C1:=formatfloat('0.00',someSum);
     inc(i);
     //-------------
     tmpSum:=0;
     atmp:=0;
     AQRP2.Close ;
     AQRP2.SQL.Text :='select prj_no,itemid,adjustitems,othercharge,mod1025 from adjustment02 where prj_no='''+g_ProjectInfo.prj_no_ForSQL+''' and itemid='''+'0102321'+'''';
     AQRP2.Open ;
     aList.Clear ;
     aList.Text :=AQRP2.Fieldbyname('adjustitems').AsString ;
     if aList.Count>0 then
        begin
        for j:=0 to aList.Count-1 do
           begin
           AQRP3.Locate('aitemid',aList[j],[loPartialKey]);
           if aList[j]='19' then
              begin
              aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'D'+inttostr(i)];
              aOVValue.HorizontalAlignment :=  xlLeft;
              aOVValue.VerticalAlignment :=  xlCenter;
              aOVValue.WrapText :=  true;
              aOVValue.MergeCells := true;
  //            aOVValue.RowHeight:=30;
              aOVValue.FormulaR1C1:=AQRP3.Fieldbyname('adjustitems').AsString+'--'+AQRP3.Fieldbyname('description').AsString;

              aOVValue:=ExcelWorksheet1.Cells.Item[i,5];
              aOVValue.HorizontalAlignment :=  xlLeft;
              aOVValue.VerticalAlignment :=  xlCenter;
              aOVValue.wraptext:=true;
              aOVValue.FormulaR1C1:='����ϵ��'+trim(AQRP2.FieldByName('mod1025').AsString);
              atmp:=someSum*(AQRP2.FieldByName('mod1025').AsFloat-1);
              end
           else
              begin
              aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
              aOVValue.HorizontalAlignment :=  xlLeft;
              aOVValue.VerticalAlignment :=  xlCenter;
              aOVValue.MergeCells := true;
              if AQRP3.Fieldbyname('description').AsString='' then
                 aOVValue.FormulaR1C1:=AQRP3.Fieldbyname('adjustitems').AsString
              else
                 aOVValue.FormulaR1C1:=AQRP3.Fieldbyname('adjustitems').AsString+'--'+AQRP3.Fieldbyname('description').AsString;
              atmp:=someSum*(AQRP3.Fieldbyname('adjustmodulus').AsFloat-1);
              //-------------
              end;
           aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
           aOVValue.HorizontalAlignment :=  xlRight;
           aOVValue.VerticalAlignment :=  xlCenter;
           aOVValue.NumberFormatLocal:='0.00';
           aOVValue.FormulaR1C1:=formatfloat('0.00',atmp);
           tmpSum:=tmpSum+atmp;
           inc(i);
           end;
        someSum:=someSum+tmpSum;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='�������̿�̽�ϼ�';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',someSum);
        inc(i);
        end;
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
     aOVValue.MergeCells := true;
     inc(i);
     sSum:=sSum+someSum;
     //-------------ȡ����ʯ��ˮ����---------------
     aSum:=0;
     AQRP1.Close ;
     AQRP1.SQL.Text :='select itemname,category,unitprice,actualvalue,money,prj_no,charge02.itemid from charge02,unitprice02 where (prj_no='''+g_ProjectInfo.prj_no_ForSQL+''') and (substring(charge02.itemid,1,6)='''+'010205'+''' or substring(charge02.itemid,1,6)='''+'010206'+''') and (charge02.itemid=unitprice02.itemid) order by charge02.itemid';
     AQRP1.Open ;
     if AQRP1.RecordCount>0 then
        begin
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='(��)��ȡ����ʯ��ˮ����';
        inc(i);
        aOVValue:=ExcelWorksheet1.Cells;
        aOVValue.item[i, 'A'].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 'A']:='ȡ������';
        aOVValue.item[i, 2].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 2]:='�������';
        aOVValue.item[i, 3].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 3]:='ȡ�����(m)';
        aOVValue.item[i, 4].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 4]:='��׼����';
        aOVValue.item[i, 5].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 5].wraptext:=true;
        aOVValue.item[i, 5]:='����(ֻ)';
        aOVValue.item[i, 6].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 6]:='���';
        //------------------------------
        inc(i);
        while not AQRP1.Eof do
           begin
           for j:=1 to 5 do
              if j=1 then
                 begin
                 aOVValue.item[i,j].NumberFormatLocal:='@';
                 aOVValue.item[i,j+1].NumberFormatLocal:='@';
                 aOVValue.item[i,j].WrapText :=  true;
                 aOVValue.item[i,j+1].WrapText :=  true;
                 tmpStr:=AQRP1.fields.Fields[j-1].AsString;
                 if pos('--',tmpStr)>0 then
                    begin
                    aOVValue.item[i, j]:=copy(tmpStr,1,pos('--',tmpStr)-1);
                    aOVValue.item[i, j+1]:=copy(tmpStr,pos('--',tmpStr)+2,length(tmpStr)-(pos('--',tmpStr)+1));
                    end
                 else
                    aOVValue.item[i, j]:=tmpStr;
                 end
              else
                 if j=2 then
                    begin
                    aOVValue.item[i,j+1].NumberFormatLocal:='@';
                    if AQRP1.fields.Fields[j-1].AsString<>'0' then
                       aOVValue.item[i, j+1]:=AQRP1.fields.Fields[j-1].AsString;
                    end
                 else
                    begin
                    aOVValue.item[i,j+1].NumberFormatLocal:='0.00';
                    aOVValue.item[i, j+1]:=AQRP1.fields.Fields[j-1].AsString;
                    end;
           aSum:=aSum+AQRP1.fieldbyname('money').AsFloat;
           AQRP1.Next ;
           inc(i);
           end;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='ȡ����ʯ��ˮ����С��';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
        inc(i);
        //-------------
        tmpSum:=0;
        atmp:=0;
        AQRP2.Close ;
        AQRP2.SQL.Text :='select prj_no,itemid,adjustitems,othercharge,mod1025 from adjustment02 where prj_no='''+g_ProjectInfo.prj_no_ForSQL+''' and itemid='''+'010265'+'''';
        AQRP2.Open ;
        aList.Clear ;
        aList.Text :=AQRP2.Fieldbyname('adjustitems').AsString ;
        if aList.Count>0 then
           begin
           for j:=0 to aList.Count-1 do
              begin
              AQRP3.Locate('aitemid',aList[j],[loPartialKey]);
              if aList[j]='19' then
                 begin
                 aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'D'+inttostr(i)];
                 aOVValue.HorizontalAlignment :=  xlLeft;
                 aOVValue.VerticalAlignment :=  xlCenter;
                 aOVValue.WrapText :=  true;
                 aOVValue.MergeCells := true;
  //               aOVValue.RowHeight:=30;
                 aOVValue.FormulaR1C1:=AQRP3.Fieldbyname('adjustitems').AsString+'--'+AQRP3.Fieldbyname('description').AsString;

                 aOVValue:=ExcelWorksheet1.Cells.Item[i,5];
                 aOVValue.HorizontalAlignment :=  xlLeft;
                 aOVValue.VerticalAlignment :=  xlCenter;
                 aOVValue.wraptext:=true;
                 aOVValue.FormulaR1C1:='����ϵ��'+trim(AQRP2.FieldByName('mod1025').AsString);
                 atmp:=aSum*(AQRP2.FieldByName('mod1025').AsFloat-1);
                 end
              else
                 begin
                 aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
                 aOVValue.HorizontalAlignment :=  xlLeft;
                 aOVValue.VerticalAlignment :=  xlCenter;
                 aOVValue.MergeCells := true;
                 if AQRP3.Fieldbyname('description').AsString='' then
                    aOVValue.FormulaR1C1:=AQRP3.Fieldbyname('adjustitems').AsString
                 else
                    aOVValue.FormulaR1C1:=AQRP3.Fieldbyname('adjustitems').AsString+'--'+AQRP3.Fieldbyname('description').AsString;
                 atmp:=aSum*(AQRP3.Fieldbyname('adjustmodulus').AsFloat-1);
                 end;
                 //-------------
              aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
              aOVValue.HorizontalAlignment :=  xlRight;
              aOVValue.VerticalAlignment :=  xlCenter;
              aOVValue.NumberFormatLocal:='0.00';
              aOVValue.FormulaR1C1:=formatfloat('0.00',atmp);
              tmpSum:=tmpSum+atmp;
              inc(i);
              end;
           aSum:=aSum+tmpSum;
           aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
           aOVValue.HorizontalAlignment :=  xlLeft;
           aOVValue.VerticalAlignment :=  xlCenter;
           aOVValue.MergeCells := true;
           aOVValue.FormulaR1C1:='ȡ����ʯ��ˮ���Ϻϼ�';
           //-------------
           aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
           aOVValue.HorizontalAlignment :=  xlRight;
           aOVValue.VerticalAlignment :=  xlCenter;
           aOVValue.NumberFormatLocal:='0.00';
           aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
           inc(i);
           end;
        end;
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
     aOVValue.MergeCells := true;
     inc(i);
     sSum:=sSum+aSum;
     //-------------ԭλ����---------------
     exSum:=0;
     someSum:=0;
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
     aOVValue.HorizontalAlignment :=  xlLeft;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.MergeCells := true;
     aOVValue.FormulaR1C1:='(��)��ԭλ����';
     inc(i);
     //-------------��׼����---------------
     aSum:=0;
     AQRP1.Close ;
     AQRP1.SQL.Text :='select depth_type,drange,category,max(unitprice) as uprice,'''+''+''' as adjustuprice,sum(depth) as sdepth,sum(money) as smoney from drillcharge02  where prj_no='''+g_ProjectInfo.prj_no_ForSQL+''' and drill_type='''+'5'+''' group by depth_type,drange,category order by depth_type,drange,category';
     AQRP1.Open ;
     if AQRP1.RecordCount>0 then
        begin
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='1����׼����';
        inc(i);
        aOVValue:=ExcelWorksheet1.Cells;
        aOVValue.item[i, 'A'].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 'A']:='�������';
        aOVValue.item[i, 2].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 2]:='�ز����';
        aOVValue.item[i, 3].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 3]:='��׼����';
        aOVValue.item[i, 4].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 4]:='��������';
        aOVValue.item[i, 5].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 5].WrapText :=  true;
        aOVValue.item[i, 5]:='������(����)';
        aOVValue.item[i, 6].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 6]:='���';
        //------------------------------
        inc(i);
        while not AQRP1.Eof do
           begin
           for j:=2 to 7 do
              begin
              if j<=3 then aOVValue.item[i,j-1].NumberFormatLocal:='@'
              else aOVValue.item[i,j-1].NumberFormatLocal:='0.00';
              aOVValue.item[i, j-1]:=AQRP1.fields.Fields[j-1].AsString;
              end;
           aSum:=aSum+AQRP1.fieldbyname('smoney').AsFloat;
           AQRP1.Next ;
           inc(i);
           end;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='��׼����С��';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
        inc(i);
        //-------------
        someSum:=someSum+aSum;
        exSum:=exSum+aSum;
        end;
     //---------������̽----------
     aSum:=0;
     AQRP1.Close ;
     AQRP1.SQL.Text :='select depth_type,drange,category,pt_type,max(unitprice) as uprice,sum(depth) as sdepth,sum(money) as smoney from drillcharge02  where prj_no='''+g_ProjectInfo.prj_no_ForSQL+''' and drill_type='''+'3'+''' group by depth_type,drange,category,pt_type order by depth_type,drange,category,pt_type';
     AQRP1.Open ;
     if AQRP1.RecordCount>0 then
        begin
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='2��������̽';
        inc(i);
        aOVValue:=ExcelWorksheet1.Cells;
        aOVValue.item[i, 'A'].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 'A']:='�������';
        aOVValue.item[i, 2].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 2]:='�ز����';
        aOVValue.item[i, 3].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 3]:='��̽����';
        aOVValue.item[i, 4].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 4]:='��׼����';
        aOVValue.item[i, 5].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 5].WrapText :=  true;
        aOVValue.item[i, 5]:='������(����)';
        aOVValue.item[i, 6].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 6]:='���';
        //------------------------------
        inc(i);
        while not AQRP1.Eof do
           begin
           for j:=2 to 7 do
              begin
              if j<=4 then aOVValue.item[i,j-1].NumberFormatLocal:='@'
              else aOVValue.item[i,j-1].NumberFormatLocal:='0.00';
              aOVValue.item[i, j-1]:=AQRP1.fields.Fields[j-1].AsString;
              end;
           aSum:=aSum+AQRP1.fieldbyname('smoney').AsFloat;
           AQRP1.Next ;
           inc(i);
           end;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='������̽С��';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
        inc(i);
        someSum:=someSum+aSum;
        exSum:=exSum+aSum;
        end;
     //---------������̽----------
     aSum:=0;
     AQRP1.Close ;
     AQRP1.SQL.Text :='select depth_type,drange,category,max(unitprice) as uprice,'''+''+''' as adjustuprice,sum(depth) as sdepth,sum(money) as smoney from drillcharge02  where prj_no='''+g_ProjectInfo.prj_no_ForSQL+''' and drill_type='''+'4'+''' group by depth_type,drange,category order by depth_type,drange,category';
     AQRP1.Open ;
     if AQRP1.RecordCount>0 then
        begin
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='3��������̽';
        inc(i);
        aOVValue:=ExcelWorksheet1.Cells;
        aOVValue.item[i, 'A'].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 'A']:='�������';
        aOVValue.item[i, 2].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 2]:='�ز����';
        aOVValue.item[i, 3].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 3]:='��׼����';
        aOVValue.item[i, 4].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 4]:='��������';
        aOVValue.item[i, 5].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 5].WrapText :=  true;
        aOVValue.item[i, 5]:='������(m)';
        aOVValue.item[i, 6].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 6]:='���';
        //------------------------------
        inc(i);
        while not AQRP1.Eof do
           begin
           for j:=2 to 7 do
              begin
              if j<=3 then aOVValue.item[i,j-1].NumberFormatLocal:='@'
              else aOVValue.item[i,j-1].NumberFormatLocal:='0.00';
              aOVValue.item[i, j-1]:=AQRP1.fields.Fields[j-1].AsString;
              end;
           aSum:=aSum+AQRP1.fieldbyname('smoney').AsFloat;
           AQRP1.Next ;
           inc(i);
           end;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='������̽С��';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
        inc(i);
        //-------------
        AQRP2.Close ;
        AQRP2.SQL.Text :='select prj_no,itemid,adjustitems,othercharge from adjustment02 where prj_no='''+g_ProjectInfo.prj_no_ForSQL+''' and itemid='''+'010303'+'''';
        AQRP2.Open ;
        aList.Clear ;
        aList.Text :=AQRP2.Fieldbyname('adjustitems').AsString ;
        if aList.Count>0 then
           begin
           for j:=0 to aList.Count-1 do
              begin
              AQRP3.Locate('aitemid',aList[j],[loPartialKey]);
              aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
              aOVValue.HorizontalAlignment :=  xlLeft;
              aOVValue.VerticalAlignment :=  xlCenter;
              aOVValue.MergeCells := true;
              if AQRP3.Fieldbyname('description').AsString='' then
                 aOVValue.FormulaR1C1:=AQRP3.Fieldbyname('adjustitems').AsString
              else
                 aOVValue.FormulaR1C1:=AQRP3.Fieldbyname('adjustitems').AsString+'--'+AQRP3.Fieldbyname('description').AsString;
              //-------------
              aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
              aOVValue.HorizontalAlignment :=  xlRight;
              aOVValue.VerticalAlignment :=  xlCenter;
              aOVValue.NumberFormatLocal:='0.00';
              aSum:=aSum*AQRP3.Fieldbyname('adjustmodulus').AsFloat;
              aOVValue.FormulaR1C1:=formatfloat('0.00',atmp);
              inc(i);
              end;
           end;
        someSum:=someSum+aSum;
        exSum:=exSum+aSum;
        end;
     //-------------�����������---------------
     aSum:=0;
     AQRP1.Close ;
     AQRP1.SQL.Text :='select itemname,category,unitprice,adjustuprice,actualvalue,money,prj_no,charge02.itemid from charge02,unitprice02 where (prj_no='''+g_ProjectInfo.prj_no_ForSQL+''') and (substring(charge02.itemid,1,6)='''+'010304'+''') and (charge02.itemid=unitprice02.itemid)';
     AQRP1.Open ;
     if AQRP1.RecordCount>0 then
        begin
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='4�������������';
        inc(i);
        aOVValue:=ExcelWorksheet1.Cells;
        aOVValue.item[i, 'A'].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 'A']:='�������';
        aOVValue.item[i, 2].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 2]:='�ز����';
        aOVValue.item[i, 3].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 3]:='��׼����';
        aOVValue.item[i, 4].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 4]:='��������';
        aOVValue.item[i, 5].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 5].WrapText :=  true;
        aOVValue.item[i, 5]:='������(����)';
        aOVValue.item[i, 6].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 6]:='���';
        //------------------------------
        inc(i);
        while not AQRP1.Eof do
           begin
           for j:=1 to 6 do
              begin
              if j<=2 then aOVValue.item[i,j].NumberFormatLocal:='@'
              else aOVValue.item[i,j].NumberFormatLocal:='0.00';
              aOVValue.item[i, j]:=AQRP1.fields.Fields[j-1].AsString;
              end;
           aSum:=aSum+AQRP1.fieldbyname('money').AsFloat;
           AQRP1.Next ;
           inc(i);
           end;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='�����������С��';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
        inc(i);
        //-------------
        someSum:=someSum+aSum;
        exSum:=exSum+aSum;
        end;
     //---------ʮ�ְ��������----------
     aSum:=0;
     AQRP1.Close ;
     AQRP1.SQL.Text :='select depth_type,drange,category,max(unitprice) as uprice,'''+''+''' as adjustuprice,sum(depth) as sdepth,sum(money) as smoney from drillcharge02  where prj_no='''+g_ProjectInfo.prj_no_ForSQL+''' and drill_type='''+'6'+''' group by depth_type,drange,category order by depth_type,drange,category';
     AQRP1.Open ;
     if AQRP1.RecordCount>0 then
        begin
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='5��ʮ�ְ��������';
        inc(i);
        aOVValue:=ExcelWorksheet1.Cells;
        aOVValue.item[i, 'A'].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 'A']:='�������';
        aOVValue.item[i, 2].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 2]:='�ز����';
        aOVValue.item[i, 3].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 3]:='��׼����';
        aOVValue.item[i, 4].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 4]:='��������';
        aOVValue.item[i, 5].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 5].WrapText :=  true;
        aOVValue.item[i, 5]:='������(����)';
        aOVValue.item[i, 6].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 6]:='���';
        //------------------------------
        inc(i);
        while not AQRP1.Eof do
           begin
           for j:=2 to 7 do
              begin
              if j<=3 then aOVValue.item[i,j-1].NumberFormatLocal:='@'
              else aOVValue.item[i,j-1].NumberFormatLocal:='0.00';
              aOVValue.item[i, j-1]:=AQRP1.fields.Fields[j-1].AsString;
              end;
           aSum:=aSum+AQRP1.fieldbyname('smoney').AsFloat;
           AQRP1.Next ;
           inc(i);
           end;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='ʮ�ְ��������С��';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
        inc(i);
        someSum:=someSum+aSum;
        exSum:=exSum+aSum;
        end;
     //-------------��ѹ����---------------
     aSum:=0;
     AQRP1.Close ;
     AQRP1.SQL.Text :='select itemname,category,unitprice,adjustuprice,actualvalue,money,prj_no,charge02.itemid from charge02,unitprice02 where (prj_no='''+g_ProjectInfo.prj_no_ForSQL+''') and (substring(charge02.itemid,1,6)='''+'010306'+''') and (charge02.itemid=unitprice02.itemid)';
     AQRP1.Open ;
     if AQRP1.RecordCount>0 then
        begin
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='6����ѹ����';
        inc(i);
        aOVValue:=ExcelWorksheet1.Cells;
        aOVValue.item[i, 'A'].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 'A']:='�������';
        aOVValue.item[i, 2].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 2]:='����ѹ��';
        aOVValue.item[i, 3].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 3]:='��׼����';
        aOVValue.item[i, 4].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 4]:='��������';
        aOVValue.item[i, 5].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 5].WrapText :=  true;
        aOVValue.item[i, 5]:='������(����)';
        aOVValue.item[i, 6].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 6]:='���';
        //------------------------------
        inc(i);
        while not AQRP1.Eof do
           begin
           for j:=1 to 6 do
              begin
              if j<=2 then aOVValue.item[i,j].NumberFormatLocal:='@'
              else aOVValue.item[i,j].NumberFormatLocal:='0.00';
              aOVValue.item[i, j]:=AQRP1.fields.Fields[j-1].AsString;
              end;
           aSum:=aSum+AQRP1.fieldbyname('money').AsFloat;
           AQRP1.Next ;
           inc(i);
           end;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='��ѹ����С��';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
        inc(i);
        //-------------
        someSum:=someSum+aSum;
        exSum:=exSum+aSum;
        end;
     //-------------�غ�����---------------
     aSum:=0;
     AQRP1.Close ;
     AQRP1.SQL.Text :='select itemname,category,subno,unitprice,actualvalue,money,prj_no,charge02.itemid from charge02,unitprice02 where (prj_no='''+g_ProjectInfo.prj_no_ForSQL+''') and (substring(charge02.itemid,1,6)='''+'010307'+''') and (charge02.itemid=unitprice02.itemid) order by charge02.itemid';
     AQRP1.Open ;
     if AQRP1.RecordCount>0 then
        begin
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='7���غ�����';
        inc(i);
        aOVValue:=ExcelWorksheet1.Cells;
        aOVValue.item[i, 'A'].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 'A']:='������Ŀ';
        aOVValue.item[i, 2].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 2]:='ˮλ';
        aOVValue.item[i, 3].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 3]:='>20000';
        aOVValue.item[i, 4].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 4]:='��׼����';
        aOVValue.item[i, 5].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 5].WrapText :=  true;
        aOVValue.item[i, 5]:='������(�����)';
        aOVValue.item[i, 6].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 6]:='���';
        //------------------------------
        inc(i);
        while not AQRP1.Eof do
           begin
           for j:=1 to 6 do
              if j<=3 then
                 begin
                 tmpStr:=AQRP1.fields.Fields[j-1].AsString;
                 if j<=2 then
                    begin
                    aOVValue.item[i,j].NumberFormatLocal:='@';
                    aOVValue.item[i, j]:=tmpStr;
                    end
                 else
                    begin
                    aOVValue.item[i,j].NumberFormatLocal:='0.00';
                    if tmpStr>'0' then
                       aOVValue.item[i, j]:=inttostr(5000*strtoint(tmpStr));
                    end;
                 end
              else
                 begin
                 aOVValue.item[i,j].NumberFormatLocal:='0.00';
                 aOVValue.item[i, j]:=AQRP1.fields.Fields[j-1].AsString;
                 end;
           aSum:=aSum+AQRP1.fieldbyname('money').AsFloat;
           AQRP1.Next ;
           inc(i);
           end;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='�غ�����С��';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
        inc(i);
        someSum:=someSum+aSum;
        end;
     //-------------�����ֳ�ֱ������---------------
     aSum:=0;
     AQRP1.Close ;
     AQRP1.SQL.Text :='select itemname,category,unitprice,adjustuprice,actualvalue,money,prj_no,charge02.itemid from charge02,unitprice02 where (prj_no='''+g_ProjectInfo.prj_no_ForSQL+''') and (substring(charge02.itemid,1,6)='''+'010309'+''') and (charge02.itemid=unitprice02.itemid)';
     AQRP1.Open ;
     if AQRP1.RecordCount>0 then
        begin
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='8�������ֳ�ֱ������';
        inc(i);
        aOVValue:=ExcelWorksheet1.Cells;
        aOVValue.item[i, 'A'].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 'A']:='�������';
        aOVValue.item[i, 2].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 2].WrapText:=true;
        aOVValue.item[i, 2]:='Ӧѹ����ˮλ';
        aOVValue.item[i, 3].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 3]:='��׼����';
        aOVValue.item[i, 4].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 4]:='��������';
        aOVValue.item[i, 5].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 5].WrapText :=  true;
        aOVValue.item[i, 5]:='������(����)';
        aOVValue.item[i, 6].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 6]:='���';
        //------------------------------
        inc(i);
        while not AQRP1.Eof do
           begin
           for j:=1 to 6 do
              begin
              if j<=2 then
                 begin
                 aOVValue.item[i,j].NumberFormatLocal:='@';
                 aOVValue.item[i,j].WrapText :=  true;
                 end
              else aOVValue.item[i,j].NumberFormatLocal:='0.00';
              aOVValue.item[i, j]:=AQRP1.fields.Fields[j-1].AsString;
              end;
           aSum:=aSum+AQRP1.fieldbyname('money').AsFloat;
           AQRP1.Next ;
           inc(i);
           end;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='�����ֳ�ֱ������С��';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
        inc(i);
        //-------------
        someSum:=someSum+aSum;
        end;
     //-------------�����������---------------
     aSum:=0;
     AQRP1.Close ;
     AQRP1.SQL.Text :='select itemname,category,subno,unitprice,actualvalue,money,prj_no,charge02.itemid from charge02,unitprice02 where (prj_no='''+g_ProjectInfo.prj_no_ForSQL+''') and (substring(charge02.itemid,1,6)='''+'010310'+''') and (charge02.itemid=unitprice02.itemid) order by charge02.itemid';
     AQRP1.Open ;
     if AQRP1.RecordCount>0 then
        begin
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='9�������������';
        inc(i);
        aOVValue:=ExcelWorksheet1.Cells;
        aOVValue.item[i, 'A'].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 'A']:='������Ŀ';
        aOVValue.item[i, 2].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 2]:='��������';
        aOVValue.item[i, 3].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 3]:='>1000';
        aOVValue.item[i, 4].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 4]:='��׼����';
        aOVValue.item[i, 5].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 5].WrapText :=  true;      
        aOVValue.item[i, 5]:='������(�����)';
        aOVValue.item[i, 6].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 6]:='���';
        //------------------------------
        inc(i);
        while not AQRP1.Eof do
           begin
           for j:=1 to 6 do
              if j<=3 then
                 begin
                 tmpStr:=AQRP1.fields.Fields[j-1].AsString;
                 if j<=2 then
                    begin
                    aOVValue.item[i,j].NumberFormatLocal:='@';
                    if j=2 then
                       aOVValue.item[i, j]:=tmpStr
                    else
                       if pos('--',tmpStr)>0 then
                          aOVValue.item[i, j]:=copy(tmpStr,pos('--',tmpStr)+2,length(tmpStr)-(pos('--',tmpStr)+1))
                       else
                          aOVValue.item[i, j]:=tmpStr;
                    end
                 else
                    begin
                    aOVValue.item[i,j].NumberFormatLocal:='0.00';
                    if tmpStr>'0' then
                       aOVValue.item[i, j]:=inttostr(500*strtoint(tmpStr));
                    end;
                 end
              else
                 begin
                 aOVValue.item[i,j].NumberFormatLocal:='0.00';
                 aOVValue.item[i, j]:=AQRP1.fields.Fields[j-1].AsString;
                 end;
           aSum:=aSum+AQRP1.fieldbyname('money').AsFloat;
           AQRP1.Next ;
           inc(i);
           end;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='�����������С��';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
        inc(i);
        someSum:=someSum+aSum;
        end;
     //-------------����ǿ������---------------
     aSum:=0;
     AQRP1.Close ;
     AQRP1.SQL.Text :='select itemname,category,unitprice,adjustuprice,actualvalue,money,prj_no,charge02.itemid from charge02,unitprice02 where (prj_no='''+g_ProjectInfo.prj_no_ForSQL+''') and (substring(charge02.itemid,1,6)='''+'010311'+''') and (charge02.itemid=unitprice02.itemid)';
     AQRP1.Open ;
     if AQRP1.RecordCount>0 then
        begin
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='10������ǿ������';
        inc(i);
        aOVValue:=ExcelWorksheet1.Cells;
        aOVValue.item[i, 'A'].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 'A']:='������Ŀ';
        aOVValue.item[i, 2].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 2]:='��������';
        aOVValue.item[i, 3].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 3]:='��׼����';
        aOVValue.item[i, 4].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 4]:='��������';
        aOVValue.item[i, 5].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 5].WrapText :=  true;
        aOVValue.item[i, 5]:='������(�����)';
        aOVValue.item[i, 6].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 6]:='���';
        //------------------------------
        inc(i);
        while not AQRP1.Eof do
           begin
           for j:=1 to 6 do
              begin
              if j<=2 then aOVValue.item[i,j].NumberFormatLocal:='@'
              else aOVValue.item[i,j].NumberFormatLocal:='0.00';
              aOVValue.item[i, j]:=AQRP1.fields.Fields[j-1].AsString;
              end;
           aSum:=aSum+AQRP1.fieldbyname('money').AsFloat;
           AQRP1.Next ;
           inc(i);
           end;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='����ǿ������С��';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
        inc(i);
        //-------------
        someSum:=someSum+aSum;
        end;
     //-------------����ǿ������---------------
     aSum:=0;
     AQRP1.Close ;
     AQRP1.SQL.Text :='select itemname,category,unitprice,adjustuprice,actualvalue,money,prj_no,charge02.itemid from charge02,unitprice02 where (prj_no='''+g_ProjectInfo.prj_no_ForSQL+''') and (substring(charge02.itemid,1,6)='''+'010312'+''') and (charge02.itemid=unitprice02.itemid)';
     AQRP1.Open ;
     if AQRP1.RecordCount>0 then
        begin
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='11������ԭλӦ������';
        inc(i);
        aOVValue:=ExcelWorksheet1.Cells;
        aOVValue.item[i, 'A'].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 'A']:='���鷽��';
        aOVValue.item[i, 2].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 2]:='���Զ���';
        aOVValue.item[i, 3].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 3]:='��׼����';
        aOVValue.item[i, 4].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 4]:='��������';
        aOVValue.item[i, 5].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 5].WrapText :=  true;
        aOVValue.item[i, 5]:='������(����)';
        aOVValue.item[i, 6].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 6]:='���';
        //------------------------------
        inc(i);
        while not AQRP1.Eof do
           begin
           for j:=1 to 6 do
              begin
              if j<=2 then
                 begin
                 aOVValue.item[i,j].NumberFormatLocal:='@';
                 aOVValue.item[i,j].WrapText :=  true;
                 end
              else aOVValue.item[i,j].NumberFormatLocal:='0.00';
              aOVValue.item[i, j]:=AQRP1.fields.Fields[j-1].AsString;
              end;
           aSum:=aSum+AQRP1.fieldbyname('money').AsFloat;
           AQRP1.Next ;
           inc(i);
           end;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='����ԭλӦ������С��';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
        inc(i);
        //-------------
        someSum:=someSum+aSum;
        end;
            
     //-------------ѹˮ��עˮ����---------------
     aSum:=0;
     AQRP1.Close ;
     AQRP1.SQL.Text :='select itemname,category,unitprice,adjustuprice,actualvalue,money,prj_no,charge02.itemid from charge02,unitprice02 where (prj_no='''+g_ProjectInfo.prj_no_ForSQL+''') and (substring(charge02.itemid,1,6)='''+'010308'+''') and (charge02.itemid=unitprice02.itemid)';
     AQRP1.Open ;
     if AQRP1.RecordCount>0 then
        begin
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='12��ѹˮ��עˮ����';
        inc(i);
        aOVValue:=ExcelWorksheet1.Cells;
        aOVValue.item[i, 'A'].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 'A']:='��������';
        aOVValue.item[i, 2].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 2]:='���鷽ʽ';
        aOVValue.item[i, 3].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 3]:='��׼����';
        aOVValue.item[i, 4].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 4]:='��������';
        aOVValue.item[i, 5].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 5].WrapText :=  true;
        aOVValue.item[i, 5]:='������(�Ρ���)';
        aOVValue.item[i, 6].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 6]:='���';
        //------------------------------
        inc(i);
        while not AQRP1.Eof do
           begin
           for j:=1 to 6 do
              if j=1 then
                 begin
                 aOVValue.item[i,j].NumberFormatLocal:='@';
                 aOVValue.item[i,j+1].NumberFormatLocal:='@';
                 tmpStr:=AQRP1.fields.Fields[j-1].AsString;
                 if pos('--',tmpStr)>0 then
                    begin
                    aOVValue.item[i, j]:=copy(tmpStr,1,pos('--',tmpStr)-1);
                    aOVValue.item[i, j+1]:=copy(tmpStr,pos('--',tmpStr)+2,length(tmpStr)-(pos('--',tmpStr)+1));
                    end
                 else
                    aOVValue.item[i, j]:=tmpStr;
                 end
              else if j>2 then
                 begin
                 aOVValue.item[i,j].NumberFormatLocal:='0.00';
                 if AQRP1.fields.Fields[j-1].AsFloat<>0 then
                    aOVValue.item[i, j]:=AQRP1.fields.Fields[j-1].AsString;
                 end;
           aSum:=aSum+AQRP1.fieldbyname('money').AsFloat;
           AQRP1.Next ;
           inc(i);
           end;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='ѹˮ��עˮ����С��';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
        inc(i);
        someSum:=someSum+aSum;
        end;
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
     aOVValue.MergeCells := true;
     inc(i);
   
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
     aOVValue.HorizontalAlignment :=  xlLeft;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.MergeCells := true;
     aOVValue.FormulaR1C1:='ԭλ���Լ�';
     //-------------
     aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
     aOVValue.HorizontalAlignment :=  xlRight;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.NumberFormatLocal:='0.00';
     aOVValue.FormulaR1C1:=formatfloat('0.00',someSum);
     inc(i);
     //-------------
     tmpSum:=0;
     atmp:=0;
     AQRP2.Close ;
     AQRP2.SQL.Text :='select prj_no,itemid,adjustitems,othercharge,mod1025 from adjustment02 where prj_no='''+g_ProjectInfo.prj_no_ForSQL+''' and itemid='''+'0103'+'''';
     AQRP2.Open ;
     aList.Clear ;
     aList.Text :=AQRP2.Fieldbyname('adjustitems').AsString ;
     if aList.Count>0 then
        begin
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='���µ���ֻ���"��ᡢ��/��̽�������ʮ�ְ����ѹ"';
        inc(i);
        for j:=0 to aList.Count-1 do
           begin
           AQRP3.Locate('aitemid',aList[j],[loPartialKey]);
           if aList[j]='19' then
              begin
              aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'D'+inttostr(i)];
              aOVValue.HorizontalAlignment :=  xlLeft;
              aOVValue.VerticalAlignment :=  xlCenter;
              aOVValue.WrapText :=  true;
              aOVValue.MergeCells := true;
  //            aOVValue.RowHeight:=30;
              aOVValue.FormulaR1C1:=AQRP3.Fieldbyname('adjustitems').AsString+'--'+AQRP3.Fieldbyname('description').AsString;

              aOVValue:=ExcelWorksheet1.Cells.Item[i,5];
              aOVValue.HorizontalAlignment :=  xlLeft;
              aOVValue.VerticalAlignment :=  xlCenter;
              aOVValue.wraptext:=true;
              aOVValue.FormulaR1C1:='����ϵ��'+trim(AQRP2.FieldByName('mod1025').AsString);
              atmp:=exSum*(AQRP2.FieldByName('mod1025').AsFloat-1);
              end
           else
              begin
              aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
              aOVValue.HorizontalAlignment :=  xlLeft;
              aOVValue.VerticalAlignment :=  xlCenter;
              aOVValue.MergeCells := true;
              if AQRP3.Fieldbyname('description').AsString='' then
                 aOVValue.FormulaR1C1:=AQRP3.Fieldbyname('adjustitems').AsString
              else
                 aOVValue.FormulaR1C1:=AQRP3.Fieldbyname('adjustitems').AsString+'--'+AQRP3.Fieldbyname('description').AsString;
              atmp:=exSum*(AQRP3.Fieldbyname('adjustmodulus').AsFloat-1);
              end;
              //-------------
           aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
           aOVValue.HorizontalAlignment :=  xlRight;
           aOVValue.VerticalAlignment :=  xlCenter;
           aOVValue.NumberFormatLocal:='0.00';
           aOVValue.FormulaR1C1:=formatfloat('0.00',atmp);
           tmpSum:=tmpSum+atmp;
           inc(i);
           end;
        someSum:=someSum+tmpSum;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='ԭλ���Ժϼ�';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',someSum);
        inc(i);
        end;
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
     aOVValue.MergeCells := true;
     sSum:=sSum+someSum;
     //-------���̵��ʿ���ϼ�--------
     inc(i);
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
     aOVValue.HorizontalAlignment :=  xlLeft;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.MergeCells := true;
     aOVValue.FormulaR1C1:='�������̿���ϼ�';
     //-------------
     aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
     aOVValue.HorizontalAlignment :=  xlRight;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.NumberFormatLocal:='0.00';
     aOVValue.FormulaR1C1:=formatfloat('0.00',sSum);
     inc(i);
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
     aOVValue.MergeCells := true;
     inc(i);

     //------------����ʵ��-------------
     exSum:=0;
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
     aOVValue.HorizontalAlignment :=  xlLeft;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.MergeCells := true;
     aOVValue.FormulaR1C1:='��������ʵ��';
     inc(i);
        //-------------��������---------------
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
     aOVValue.HorizontalAlignment :=  xlLeft;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.MergeCells := true;
     aOVValue.FormulaR1C1:='(һ)����������';
     inc(i);
     aSum:=0;
     AQRP1.Close ;
     AQRP1.SQL.Text :='select itemname,category,unitprice,adjustuprice,actualvalue,money,prj_no,charge02.itemid from charge02,unitprice02 where (prj_no='''+g_ProjectInfo.prj_no_ForSQL+''') and (substring(charge02.itemid,1,6)='''+'020101'+''') and (charge02.itemid=unitprice02.itemid)';
     AQRP1.Open ;
     if AQRP1.RecordCount>0 then
        begin
        aOVValue:=ExcelWorksheet1.Cells;
        aOVValue.item[i, 'A'].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 'A']:='������Ŀ';
        aOVValue.item[i, 2].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 2]:='���鷽��';
        aOVValue.item[i, 3].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 3]:='��׼����';
        aOVValue.item[i, 4].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 4]:='��������';
        aOVValue.item[i, 5].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 5].WrapText :=  true;
        aOVValue.item[i, 5]:='����(��/��)';
        aOVValue.item[i, 6].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 6]:='���';
        //------------------------------
        inc(i);
        while not AQRP1.Eof do
           begin
           for j:=1 to 6 do
              if j=1 then
                 begin
                 aOVValue.item[i,j].NumberFormatLocal:='@';
                 aOVValue.item[i,j+1].NumberFormatLocal:='@';
                 tmpStr:=AQRP1.fields.Fields[j-1].AsString;
                 if pos('--',tmpStr)>0 then
                    begin
                    aOVValue.item[i, j]:=copy(tmpStr,1,pos('--',tmpStr)-1);
                    aOVValue.item[i, j+1]:=copy(tmpStr,pos('--',tmpStr)+2,length(tmpStr)-(pos('--',tmpStr)+1));
                    end
                 else
                    aOVValue.item[i, j]:=tmpStr;
                 end
              else if j>2 then
                 begin
                 aOVValue.item[i,j].NumberFormatLocal:='0.00';
                 aOVValue.item[i, j]:=AQRP1.fields.Fields[j-1].AsString;
                 end;
           aSum:=aSum+AQRP1.fieldbyname('money').AsFloat;
           AQRP1.Next ;
           inc(i);
           end;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='��������С��';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
        inc(i);
        exSum:=exSum+aSum;
        end;
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
     aOVValue.MergeCells := true;
     inc(i);
        //-------------ˮ�ʷ���---------------
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
     aOVValue.HorizontalAlignment :=  xlLeft;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.MergeCells := true;
     aOVValue.FormulaR1C1:='(��)��ˮ�ʷ���';
     inc(i);
     aSum:=0;
     AQRP1.Close ;
     AQRP1.SQL.Text :='select itemname,category,unitprice,adjustuprice,actualvalue,money,prj_no,charge02.itemid from charge02,unitprice02 where (prj_no='''+g_ProjectInfo.prj_no_ForSQL+''') and (substring(charge02.itemid,1,6)='''+'020201'+''') and (charge02.itemid=unitprice02.itemid)';
     AQRP1.Open ;
     if AQRP1.RecordCount>0 then
        begin
        aOVValue:=ExcelWorksheet1.Cells;
        aOVValue.item[i, 'A'].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 'A']:='������Ŀ';
        aOVValue.item[i, 2].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 2]:='��������';
        aOVValue.item[i, 3].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 3]:='��׼����';
        aOVValue.item[i, 4].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 4]:='��������';
        aOVValue.item[i, 5].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 5].WrapText :=  true;
        aOVValue.item[i, 5]:='����(��/��)';
        aOVValue.item[i, 6].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 6]:='���';
        //------------------------------
        inc(i);
        while not AQRP1.Eof do
           begin
           for j:=1 to 6 do
              if j=1 then
                 begin
                 aOVValue.item[i,j].NumberFormatLocal:='@';
                 aOVValue.item[i,j+1].NumberFormatLocal:='@';
                 tmpStr:=AQRP1.fields.Fields[j-1].AsString;
                 if pos('--',tmpStr)>0 then
                    begin
                    aOVValue.item[i, j]:=copy(tmpStr,1,pos('--',tmpStr)-1);
                    aOVValue.item[i, j+1]:=copy(tmpStr,pos('--',tmpStr)+2,length(tmpStr)-(pos('--',tmpStr)+1));
                    end
                 else
                    aOVValue.item[i, j]:=tmpStr;
                 end
              else if j>2 then
                 begin
                 aOVValue.item[i,j].NumberFormatLocal:='0.00';
                 aOVValue.item[i, j]:=AQRP1.fields.Fields[j-1].AsString;
                 end;
           aSum:=aSum+AQRP1.fieldbyname('money').AsFloat;
           AQRP1.Next ;
           inc(i);
           end;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='ˮ�ʷ���С��';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
        inc(i);
        exSum:=exSum+aSum;
        end;
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
     aOVValue.MergeCells := true;
     inc(i);
     //-------------��ʯ����---------------
     someSum:=0;
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
     aOVValue.HorizontalAlignment :=  xlLeft;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.MergeCells := true;
     aOVValue.FormulaR1C1:='(��)����ʯ����';
     inc(i);
     //-------------�����ӹ�---------------
     aSum:=0;
     AQRP1.Close ;
     AQRP1.SQL.Text :='select itemname,unitprice,adjustuprice,actualvalue,money,prj_no,charge02.itemid from charge02,unitprice02 where (prj_no='''+g_ProjectInfo.prj_no_ForSQL+''') and (substring(charge02.itemid,1,6)='''+'020301'+''') and (charge02.itemid=unitprice02.itemid)';
     AQRP1.Open ;
     if AQRP1.RecordCount>0 then
        begin
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='1�������ӹ�';
        inc(i);
        aOVValue:=ExcelWorksheet1.Cells;
        aOVValue.item[i, 'A'].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 'A']:='������Ŀ';
        aOVValue.item[i, 2].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 2]:='���(cm)';
        aOVValue.item[i, 3].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 3]:='��׼����';
        aOVValue.item[i, 4].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 4]:='��������';
        aOVValue.item[i, 5].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 5].WrapText :=  true;
        aOVValue.item[i, 5]:='����(��/Ƭ)';
        aOVValue.item[i, 6].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 6]:='���';
        //------------------------------
        inc(i);
        while not AQRP1.Eof do
           begin
           for j:=1 to 5 do
              if j=1 then
                 begin
                 aOVValue.item[i,j].NumberFormatLocal:='@';
                 aOVValue.item[i,j+1].NumberFormatLocal:='@';
                 tmpStr:=AQRP1.fields.Fields[j-1].AsString;
                 if pos('--',tmpStr)>0 then
                    begin
                    aOVValue.item[i, j]:=copy(tmpStr,1,pos('--',tmpStr)-1);
                    aOVValue.item[i, j+1]:=copy(tmpStr,pos('--',tmpStr)+2,length(tmpStr)-(pos('--',tmpStr)+1));
                    end
                 else
                    aOVValue.item[i, j]:=tmpStr;
                 end
              else 
                 begin
                 aOVValue.item[i,j+1].NumberFormatLocal:='0.00';
                 aOVValue.item[i, j+1]:=AQRP1.fields.Fields[j-1].AsString;
                 end;
           aSum:=aSum+AQRP1.fieldbyname('money').AsFloat;
           AQRP1.Next ;
           inc(i);
           end;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='�����ӹ�С��';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
        inc(i);
        //-------------
        someSum:=someSum+aSum;
        end;
     //---------��ʯ������ѧ����----------
     aSum:=0;
     AQRP1.Close ;
     AQRP1.SQL.Text :='select itemname,category,unitprice,adjustuprice,actualvalue,money,prj_no,charge02.itemid from charge02,unitprice02 where (prj_no='''+g_ProjectInfo.prj_no_ForSQL+''') and (substring(charge02.itemid,1,6)='''+'020302'+''') and (charge02.itemid=unitprice02.itemid)';
     AQRP1.Open ;
     if AQRP1.RecordCount>0 then
        begin
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='2����ʯ������ѧ����';
        inc(i);
        aOVValue:=ExcelWorksheet1.Cells;
        aOVValue.item[i, 'A'].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 'A']:='������Ŀ';
        aOVValue.item[i, 2].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 2]:='���鷽��';
        aOVValue.item[i, 3].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 3]:='��׼����';
        aOVValue.item[i, 4].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 4]:='��������';
        aOVValue.item[i, 5].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 5].WrapText :=  true;
  //      aOVValue.RowHeight:=30;
        aOVValue.item[i, 5]:='����(��顢��/��)';
        aOVValue.item[i, 6].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 6]:='���';
        //------------------------------
        inc(i);
        while not AQRP1.Eof do
           begin
           for j:=1 to 6 do
              if j=1 then
                 begin
                 aOVValue.item[i,j].NumberFormatLocal:='@';
                 aOVValue.item[i,j+1].NumberFormatLocal:='@';
                 tmpStr:=AQRP1.fields.Fields[j-1].AsString;
                 if pos('--',tmpStr)>0 then
                    begin
                    aOVValue.item[i, j]:=copy(tmpStr,1,pos('--',tmpStr)-1);
                    aOVValue.item[i, j+1]:=copy(tmpStr,pos('--',tmpStr)+2,length(tmpStr)-(pos('--',tmpStr)+1));
                    end
                 else
                    aOVValue.item[i, j]:=tmpStr;
                 end
              else if j>2 then
                 begin
                 aOVValue.item[i,j].NumberFormatLocal:='0.00';
                 aOVValue.item[i, j]:=AQRP1.fields.Fields[j-1].AsString;
                 end;
           aSum:=aSum+AQRP1.fieldbyname('money').AsFloat;
           AQRP1.Next ;
           inc(i);
           end;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='��ʯ������ѧ����С��';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
        inc(i);
        someSum:=someSum+aSum;
        end;
    //---------��ʯ��ѧ����----------
     aSum:=0;
     AQRP1.Close ;
     AQRP1.SQL.Text :='select itemname,category,unitprice,adjustuprice,actualvalue,money,prj_no,charge02.itemid from charge02,unitprice02 where (prj_no='''+g_ProjectInfo.prj_no_ForSQL+''') and (substring(charge02.itemid,1,6)='''+'020303'+''') and (charge02.itemid=unitprice02.itemid)';
     AQRP1.Open ;
     if AQRP1.RecordCount>0 then
        begin
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='3����ʯ��ѧ����';
        inc(i);
        aOVValue:=ExcelWorksheet1.Cells;
        aOVValue.item[i, 'A'].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 'A']:='������Ŀ';
        aOVValue.item[i, 2].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 2]:='���鷽��';
        aOVValue.item[i, 3].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 3]:='��׼����';
        aOVValue.item[i, 4].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 4]:='��������';
        aOVValue.item[i, 5].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 5].WrapText :=  true;
        aOVValue.item[i, 5]:='����(��)';
        aOVValue.item[i, 6].HorizontalAlignment :=xlCenter;
        aOVValue.item[i, 6]:='���';
        //------------------------------
        inc(i);
        while not AQRP1.Eof do
           begin
           for j:=1 to 6 do
              if j=1 then
                 begin
                 aOVValue.item[i,j].NumberFormatLocal:='@';
                 aOVValue.item[i,j+1].NumberFormatLocal:='@';
                 tmpStr:=AQRP1.fields.Fields[j-1].AsString;
                 if pos('--',tmpStr)>0 then
                    begin
                    aOVValue.item[i, j]:=copy(tmpStr,1,pos('--',tmpStr)-1);
                    aOVValue.item[i, j+1]:=copy(tmpStr,pos('--',tmpStr)+2,length(tmpStr)-(pos('--',tmpStr)+1));
                    end
                 else
                    aOVValue.item[i, j]:=tmpStr;
                 end
              else if j>2 then
                 begin
                 aOVValue.item[i,j].NumberFormatLocal:='0.00';
                 aOVValue.item[i, j]:=AQRP1.fields.Fields[j-1].AsString;
                 end;
           aSum:=aSum+AQRP1.fieldbyname('money').AsFloat;
           AQRP1.Next ;
           inc(i);
           end;
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='��ʯ��ѧ����С��';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
        inc(i);
        someSum:=someSum+aSum;
        end;
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
     aOVValue.MergeCells := true;
     inc(i);

     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
     aOVValue.HorizontalAlignment :=  xlLeft;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.MergeCells := true;
     aOVValue.FormulaR1C1:='��ʯ����ϼ�';
     //-------------
     aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
     aOVValue.HorizontalAlignment :=  xlRight;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.NumberFormatLocal:='0.00';
     aOVValue.FormulaR1C1:=formatfloat('0.00',someSum);
     inc(i);
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
     aOVValue.MergeCells := true;
     exSum:=exSum+someSum;
     //-------��������ϼ�--------
     inc(i);
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
     aOVValue.HorizontalAlignment :=  xlLeft;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.MergeCells := true;
     aOVValue.FormulaR1C1:='���������';
     //-------------
     aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
     aOVValue.HorizontalAlignment :=  xlRight;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.NumberFormatLocal:='0.00';
     aOVValue.FormulaR1C1:=formatfloat('0.00',exSum);
     inc(i);
     //
     AQRP2.Close ;
     AQRP2.SQL.Text :='select prj_no,itemid,adjustitems,adjustmodulus from adjustment02 where prj_no='''+g_ProjectInfo.prj_no_ForSQL+''' and itemid='''+'02'+'''';
     AQRP2.Open ;
     tmpSum:=0;
     if AQRP2.RecordCount>0 then
        begin
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.wraptext:=true;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='������ˮ�ʡ���ʯ���������������ֳ�����--���ӵ���ϵ��1.3';

        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        tmpSum:=exSum*0.3;
        aOVValue.FormulaR1C1:=formatfloat('0.00',tmpSum);
        inc(i);
        end;
     exSum:=exSum+tmpSum;
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
     aOVValue.HorizontalAlignment :=  xlLeft;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.MergeCells := true;
     aOVValue.FormulaR1C1:='��������ϼ�';
     //-------------
     aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
     aOVValue.HorizontalAlignment :=  xlRight;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.NumberFormatLocal:='0.00';
     aOVValue.FormulaR1C1:=formatfloat('0.00',exSum);
     inc(i);
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
     aOVValue.MergeCells := true;
     inc(i);
     //------------�����շ�-------------
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
     aOVValue.MergeCells := true;
     inc(i);
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
     aOVValue.HorizontalAlignment :=  xlLeft;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.MergeCells := true;
     aOVValue.FormulaR1C1:='�����շ�';
     inc(i);
     //-------------�������̿���---------------
     someSum:=0;
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'D'+inttostr(i)];
     aOVValue.HorizontalAlignment :=  xlLeft;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.MergeCells := true;
     aOVValue.FormulaR1C1:='�������̿��켼���շ�';

     aOVValue:=ExcelWorksheet1.Cells.Item[i,5];
     aOVValue.HorizontalAlignment :=  xlLeft;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.wraptext:=true;
  //   aOVValue.RowHeight:=30;
     if trim(STPrj3.Caption)='�׼�' then
        begin
        aOVValue.FormulaR1C1:='�׼�--�շѱ���120%';
        someSum:=sSum*1.2;
        end
     else if trim(STPrj3.Caption)='�Ҽ�' then
        begin
        aOVValue.FormulaR1C1:='�Ҽ�--�շѱ���100%';
        someSum:=sSum;
        end
     else
        begin
        aOVValue.FormulaR1C1:='����--�շѱ���80%';
        someSum:=sSum*0.8;
        end;
     aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
     aOVValue.HorizontalAlignment :=  xlRight;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.NumberFormatLocal:='0.00';
     aOVValue.FormulaR1C1:=formatfloat('0.00',someSum);
     inc(i);
     //-------------��������---------------

     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'D'+inttostr(i)];
     aOVValue.HorizontalAlignment :=  xlLeft;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.MergeCells := true;
     aOVValue.FormulaR1C1:='�������鼼���շ�';

     aOVValue:=ExcelWorksheet1.Cells.Item[i,5];
     aOVValue.HorizontalAlignment :=  xlLeft;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.wraptext:=true;
     aOVValue.FormulaR1C1:='�շѱ���10%';
     aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
     aOVValue.HorizontalAlignment :=  xlRight;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.NumberFormatLocal:='0.00';
     tmpSum:=exSum*0.1;
     aOVValue.FormulaR1C1:=formatfloat('0.00',tmpSum);
     inc(i);
     //
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
     aOVValue.HorizontalAlignment :=  xlLeft;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.MergeCells := true;
     aOVValue.FormulaR1C1:='�����շѺϼ�';
     //
     aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
     aOVValue.HorizontalAlignment :=  xlRight;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.NumberFormatLocal:='0.00';
     aOVValue.FormulaR1C1:=formatfloat('0.00',someSum+tmpSum);
     inc(i);
     //--------------
     sSum:=sSum+exSum+someSum+tmpSum;
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
     aOVValue.MergeCells := true;
     inc(i);
     //-----------�ܺϼ�-----------
     aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
     aOVValue.HorizontalAlignment :=  xlLeft;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.MergeCells := true;
     aOVValue.FormulaR1C1:='���̾����ܼ�';
     //-------------
     aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
     aOVValue.HorizontalAlignment :=  xlRight;
     aOVValue.VerticalAlignment :=  xlCenter;
     aOVValue.NumberFormatLocal:='0.00';
     aOVValue.FormulaR1C1:=formatfloat('0.00',sSum);
     inc(i);
     //---------------
     AQRP2.Close ;
     AQRP2.SQL.Text :='select prj_no,itemid,adjustitems,othercharge,mod1025,floatvalue from adjustment02 where prj_no='''+g_ProjectInfo.prj_no_ForSQL+''' and itemid='''+'00'+'''';
     AQRP2.Open ;
     aList.Clear ;
     aList.Text :=AQRP2.Fieldbyname('adjustitems').AsString ;
     tmpSum:=0;
     atmp:=0;
     if aList.Count>0 then
        begin
        for j:=0 to aList.Count-1 do
           begin
           AQRP3.Locate('aitemid',aList[j],[loPartialKey]);
           if aList[j]='19' then
              begin
              aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'D'+inttostr(i)];
              aOVValue.HorizontalAlignment :=  xlLeft;
              aOVValue.VerticalAlignment :=  xlCenter;
              aOVValue.WrapText :=  true;
              aOVValue.MergeCells := true;
  //            aOVValue.RowHeight:=30;
              aOVValue.FormulaR1C1:=AQRP3.Fieldbyname('adjustitems').AsString+'--'+AQRP3.Fieldbyname('description').AsString;

              aOVValue:=ExcelWorksheet1.Cells.Item[i,5];
              aOVValue.HorizontalAlignment :=  xlLeft;
              aOVValue.VerticalAlignment :=  xlCenter;
              aOVValue.wraptext:=true;
              aOVValue.FormulaR1C1:='����ϵ��'+trim(AQRP2.FieldByName('mod1025').AsString);
              atmp:=sSum*(AQRP2.FieldByName('mod1025').AsFloat-1);
              end
           else if aList[j]='31' then
              begin
              aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'D'+inttostr(i)];
              aOVValue.HorizontalAlignment :=  xlLeft;
              aOVValue.VerticalAlignment :=  xlCenter;
              aOVValue.WrapText :=  true;
              aOVValue.MergeCells := true;
              aOVValue.RowHeight:=30;
              aOVValue.FormulaR1C1:=AQRP3.Fieldbyname('adjustitems').AsString+'--'+AQRP3.Fieldbyname('description').AsString;

              aOVValue:=ExcelWorksheet1.Cells.Item[i,5];
              aOVValue.HorizontalAlignment :=  xlLeft;
              aOVValue.VerticalAlignment :=  xlCenter;
              aOVValue.FormulaR1C1:='����'+trim(AQRP2.FieldByName('FloatValue').AsString)+'%';
              end
           else
              begin
              aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
              aOVValue.HorizontalAlignment :=  xlLeft;
              aOVValue.VerticalAlignment :=  xlCenter;
              aOVValue.WrapText :=  true;
              aOVValue.MergeCells := true;
              if AQRP3.Fieldbyname('description').AsString='' then
                 aOVValue.FormulaR1C1:=AQRP3.Fieldbyname('adjustitems').AsString
              else
                 aOVValue.FormulaR1C1:=AQRP3.Fieldbyname('adjustitems').AsString+'--'+AQRP3.Fieldbyname('description').AsString;
              atmp:=sSum*(AQRP3.Fieldbyname('adjustmodulus').AsFloat-1);
              end;
           //-------------
           aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
           aOVValue.HorizontalAlignment :=  xlRight;
           aOVValue.VerticalAlignment :=  xlCenter;
           aOVValue.NumberFormatLocal:='0.00';
           aOVValue.FormulaR1C1:=formatfloat('0.00',atmp);
           tmpSum:=tmpSum+atmp;
           inc(i);
           end;
        sSum:=sSum+tmpSum;
       //---------��������----------
        aSum:=0;
        AQRP1.Close ;
        AQRP1.SQL.Text :='select oc_item,0,oc_method,0,oc_uprice,oc_money from othercharge02 where prj_no='''+g_ProjectInfo.prj_no_ForSQL+'''';
        AQRP1.Open ;
        if AQRP1.RecordCount>0 then
           begin
           aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
           aOVValue.HorizontalAlignment :=  xlLeft;
           aOVValue.VerticalAlignment :=  xlCenter;
           aOVValue.MergeCells := true;
           aOVValue.FormulaR1C1:='��������';
           inc(i);
           aOVValue:=ExcelWorksheet1.Cells;
           aOVValue.item[i, 'A'].HorizontalAlignment :=xlCenter;
           aOVValue.item[i, 'A']:='��Ŀ';
           aOVValue.item[i, 3].HorizontalAlignment :=xlCenter;
           aOVValue.item[i, 3]:='���㷽��';
           aOVValue.item[i, 5].HorizontalAlignment :=xlCenter;
           aOVValue.item[i, 5].WrapText :=  true;
           aOVValue.item[i, 5]:='����';
           aOVValue.item[i, 6].HorizontalAlignment :=xlCenter;
           aOVValue.item[i, 6]:='���';
           //------------------------------
           inc(i);
           while not AQRP1.Eof do
              begin
              if trim(AQRP1.fieldbyname('oc_item').AsString)='' then
                 begin
                 AQRP1.Next ;
                 continue;
                 end;
              for j:=1 to 6 do
                 if j=1 then
                    begin
                    aOVValue.item[i,j].NumberFormatLocal:='@';
                    tmpStr:=AQRP1.fields.Fields[j-1].AsString;
                    aOVValue.item[i, j]:=tmpStr;
                    end
                 else if (j=2) or (j=4) then continue
                 else
                    begin
                    aOVValue.item[i,j].NumberFormatLocal:='0.00';
                    aOVValue.item[i,j]:=AQRP1.fields.Fields[j-1].AsString;
                    end;
              aSum:=aSum+AQRP1.fieldbyname('oc_money').AsFloat;
              AQRP1.Next ;
              inc(i);
              end;
           aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
           aOVValue.HorizontalAlignment :=  xlLeft;
           aOVValue.VerticalAlignment :=  xlCenter;
           aOVValue.MergeCells := true;
           aOVValue.FormulaR1C1:='��������С��';
           //-------------
           aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
           aOVValue.HorizontalAlignment :=  xlRight;
           aOVValue.VerticalAlignment :=  xlCenter;
           aOVValue.NumberFormatLocal:='0.00';
           aOVValue.FormulaR1C1:=formatfloat('0.00',aSum);
           inc(i);
           sSum:=sSum+aSum;
           end;
        //-----------
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'F'+inttostr(i)];
        aOVValue.MergeCells := true;
        inc(i);
        aOVValue:=ExcelWorksheet1.Cells.Range['A'+inttostr(i),'E'+inttostr(i)];
        aOVValue.HorizontalAlignment :=  xlLeft;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.MergeCells := true;
        aOVValue.FormulaR1C1:='���̾����ܺϼ�';
        //-------------
        aOVValue:=ExcelWorksheet1.Cells.Item[i,6];
        aOVValue.HorizontalAlignment :=  xlRight;
        aOVValue.VerticalAlignment :=  xlCenter;
        aOVValue.NumberFormatLocal:='0.00';
        aOVValue.FormulaR1C1:=formatfloat('0.00',sSum);
        inc(i);
        end;
     //---------------
     ExcelWorksheet1.Columns.Range['A1','A'+inttostr(i)].ColumnWidth:=18;
     ExcelWorksheet1.Range['B1','B'+inttostr(i)].ColumnWidth:=20;
     ExcelWorksheet1.Range['C1','C'+inttostr(i)].ColumnWidth:=9;
     ExcelWorksheet1.Range['D1','D'+inttostr(i)].ColumnWidth:=8;
     ExcelWorksheet1.Range['E1','E'+inttostr(i)].Columns.AutoFit;
     ExcelWorksheet1.Range['F1','F'+inttostr(i)].ColumnWidth:=9;

     aEndCell:=aOVValue;
     //----------------
     aOVValue:=ExcelWorksheet1.Cells.Range[aStartCell,aEndCell];
     aOVValue.font.size:='9';
     aOVValue.Borders[xlEdgeRight].LineStyle := xlNone;
     aOVValue.Borders[xlInsideVertical].LineStyle := xlNone;
     aOVValue.Borders[xlInsideHorizontal].LineStyle := xlNone;
     aOVValue.Borders[xlDiagonalDown].LineStyle := xlNone;
     aOVValue.Borders[xlDiagonalUp].LineStyle := xlNone;
     //
     aOVValue:=ExcelWorksheet1.Cells.Range[aStartCell,aEndCell].Borders[xlEdgeLeft];
     aOVValue.LineStyle := xlContinuous;
     aOVValue.Weight := xlThin;
     aOVValue.ColorIndex := xlAutomatic;
     //
     aOVValue:=ExcelWorksheet1.Cells.Range[aStartCell,aEndCell].Borders[xlEdgeTop];
     aOVValue.LineStyle := xlContinuous;
     aOVValue.Weight := xlThin;
     aOVValue.ColorIndex := xlAutomatic;
     //
     aOVValue:=ExcelWorksheet1.Cells.Range[aStartCell,aEndCell].Borders[xlEdgeBottom];
     aOVValue.LineStyle := xlContinuous;
     aOVValue.Weight := xlThin;
     aOVValue.ColorIndex := xlAutomatic;
     //
     aOVValue:=ExcelWorksheet1.Cells.Range[aStartCell,aEndCell].Borders[xlEdgeRight];
     aOVValue.LineStyle := xlContinuous;
     aOVValue.Weight := xlThin;
     aOVValue.ColorIndex := xlAutomatic;
     //
     aOVValue:=ExcelWorksheet1.Cells.Range[aStartCell,aEndCell].Borders[xlInsideVertical];
     aOVValue.LineStyle := xlContinuous;
     aOVValue.Weight := xlThin;
     aOVValue.ColorIndex := xlAutomatic;
     //
     aOVValue:=ExcelWorksheet1.Cells.Range[aStartCell,aEndCell].Borders[xlInsideHorizontal];
     aOVValue.LineStyle := xlContinuous;
     aOVValue.Weight := xlThin;
     aOVValue.ColorIndex := xlAutomatic;
     //----------------------
     ExcelWorksheet1.SaveAs(trim(ERP1.Text));
     result:=true;
  except
     application.MessageBox(EXCEL_ERROR,HINT_TEXT);
     ExcelApplication1.AutoQuit:=true;
     ExcelWorksheet1.Free;
     ExcelWorkbook1.Free;
     ExcelApplication1.Free;
     exit;
  end;
  ExcelApplication1.AutoQuit:=true;
  ExcelWorksheet1.Free;
  ExcelWorkbook1.Free;
  ExcelApplication1.Disconnect;
  ExcelApplication1.Quit;
  ExcelApplication1.Free;
end;


procedure TChargeForm02.EPrj1KeyPress(Sender: TObject; var Key: Char);
var
  strHead,strEnd,strAll,strFraction:string;
  iDecimalSeparator:integer;
begin
   if Key = #13 then
      begin
      SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
      Key := #0;
      exit;
      end;
  if (TEdit(Sender).Tag=0) and (key='.') then
  begin
     key:=#0;
     exit;
  end;
  if key=' ' then key:=#0;
  if key <>chr(vk_back) then
  try
    strHead := copy(TEdit(Sender).Text,1,TEdit(Sender).SelStart);
    strEnd  := copy(TEdit(Sender).Text,TEdit(Sender).SelStart+TEdit(Sender).SelLength+1,length(TEdit(Sender).Text));
    if (strHead+key+strEnd)='-' then
      begin
         TEdit(Sender).Text :='-';
         TEdit(Sender).SelStart :=2;
         key:=#0;
         exit;
      end;
    strtofloat(strHead+key+strEnd);
    strAll := strHead+key+strEnd;
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
procedure TChargeForm02.EPrj1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   if isSelAll then
      begin
      tedit(sender).SelectAll ;
      isSelAll:=false;
      end;
end;


procedure TChargeForm02.BBOtherClick(Sender: TObject);
begin
   application.CreateForm(TFOtherCharges02,FOtherCharges02);
   FOtherCharges02.ShowModal;
   STOther.Caption := FOtherCharges02.ST_Others.Caption ;
   if not DataProccess(true,true) then application.MessageBox(DBERR_NOTSAVE,HINT_TEXT);
end;

procedure TChargeForm02.EPrj2Exit(Sender: TObject);
begin
   if trim(EPrj1.Text)='' then EPrj1.Text:='20';
   if strtofloat(trim(EPrj2.Text))<20 then
      EPrj2.Text :='20'
   else if strtofloat(trim(EPrj2.Text))>40 then
      EPrj2.Text :='40';
   EditFormat(eprj2);
   STPrj7.Caption :=formatfloat('0.00',strtofloat(STPrj7.Caption)+strtofloat(trim(EPrj2.Text))/100-m_RBVal1/100);
   m_RBVal1:=strtofloat(trim(EPrj2.Text));
   if not DataProccess(true,true) then application.MessageBox(DBERR_NOTSAVE,HINT_TEXT);
end;

procedure TChargeForm02.ChBPrj5Click(Sender: TObject);
var
   i:integer;
begin
if ChBPrj5.Checked then
   begin
   if PosStrInList(aSList,'31')<0 then aSList.Add('31');
   EPrj2.Enabled :=true;
   m_RBVal1:=strtofloat(trim(EPrj2.Text));
   STPrj7.Caption :=formatfloat('0.00',strtofloat(STPrj7.Caption)+m_RBVal1/100);
   end
else
   begin
   i:=PosStrInList(aSList,'45');
   if i>=0 then aSList.Delete(i);
   STPrj7.Caption :=formatfloat('0.00',strtofloat(STPrj7.Caption)-m_RBVal1/100);
   EPrj2.Enabled:=false;
   end;
if IsFirst then
   DataProccess(true)
else
   if not DataProccess(true,true) then application.MessageBox(DBERR_NOTSAVE,HINT_TEXT);
end;

procedure TChargeForm02.EPrj1Enter(Sender: TObject);
begin
tedit(sender).Text :=trim(tedit(sender).Text);
tedit(sender).SelectAll ;
isSelAll:=true;
end;

end.


