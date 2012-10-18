unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnCtrls, ToolWin, ActnMan, ActnMenus, ActnList, ActnColorMaps,
  XPStyleActnCtrls, ImgList, ComCtrls, StdStyleActnCtrls, 
  ExtCtrls, DB, ADODB, FR_DSet, FR_DBSet, FR_Class, Menus, INIFiles, jpeg;

type
  TMainForm = class(TForm)
    ActionManager1: TActionManager;
    XPColorMap1: TXPColorMap;
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionToolBar1: TActionToolBar;
    ImageList1: TImageList;
    ProjectOpen1: TAction;
    ProjectNew1: TAction;
    ProjectExit1: TAction;
    DataDrills: TAction;
    DataStratum: TAction;
    DataImpenetrate: TAction;
    DataPowertouch: TAction;
    DataCPT: TAction;
    DataLMC2001: TAction;
    DataJTWG2: TAction;
    DataSample: TAction;
    DataSection: TAction;
    TableSectionTotal: TAction;
    TableWuLiLiXue: TAction;
    ChartStaticTouch: TAction;
    ChartSectionZip: TAction;
    Chart: TAction;
    ToolSoilType: TAction;
    ToolGroundWaterErode: TAction;
    WindowsTile1: TAction;
    WindowsCascade1: TAction;
    WindowsArrangeicons1: TAction;
    HelpTheme1: TAction;
    HelpRegister1: TAction;
    HelpAbout1: TAction;
    login1: TAction;
    logout1: TAction;
    BaseDrillType: TAction;
    BaseEarthType: TAction;
    BaseBorer: TAction;
    DataAntiTest: TAction;
    DataStratumDesc: TAction;
    CptInput: TAction;
    actJueSuan: TAction;
    DataCrossBoard: TAction;
    TableChengZaiLiTeZhengZhi: TAction;
    ChartZhuZhuangTu: TAction;
    DataFileLoad: TAction;
    ChartDrillPosition: TAction;
    ChartSectionPrint: TAction;
    imgBackGround: TImage;
    BaseEarth_desc: TAction;
    ChartZongTuLi: TAction;
    frReport1: TfrReport;
    frDBDrills: TfrDBDataset;
    qryDrillsPrint: TADOQuery;
    tableKTDCGYLB: TAction;
    ChartCrossboard: TAction;
    DataJieKong: TAction;
    chartYtshjcshchgb: TAction;
    qryYtsjcscgb: TADOQuery;
    frDBYtsjcscgb: TfrDBDataset;
    ChartJingTanTongJi: TAction;
    StatusBar1: TStatusBar;
    chartReportLanguage: TAction;
    qryJingTanShiYan: TADOQuery;
    frDBJingTanShiYan: TfrDBDataset;
    ChartJingTanShiYan: TAction;
    frReportJingTanShiYan: TfrReport;
    ChartBiaoGuanFenCeng: TAction;
    frDBStratumMaster: TfrDBDataset;
    frDBSPT: TfrDBDataset;
    frDBTeZhengShu: TfrDBDataset;
    DSTeZhengShu: TDataSource;
    frReportBaoGuanShiYan: TfrReport;
    tblTeZhengShu: TADOTable;
    tblSPT: TADOTable;
    DSSPT: TDataSource;
    DSStratumMaster: TDataSource;
    qryStratum: TADOQuery;
    qryTeZhengShu: TADOQuery;
    DataSampleTeShu: TAction;
    TeShuFileLoad: TAction;
    TableSectionTotalTeShu: TAction;
    DataDrills_XY: TAction;
    ProjectExport: TAction;
    ProjectImport: TAction;
    tableGongZuoLiangTongJi: TAction;
    DataFileLoadXLS: TAction;
    DataFileLoadXLS_GuJie: TAction;
    procedure WindowsTile1Execute(Sender: TObject);
    procedure WindowsCascade1Execute(Sender: TObject);
    procedure WindowsArrangeicons1Execute(Sender: TObject);
    procedure ProjectOpen1Execute(Sender: TObject);
    procedure ProjectExit1Execute(Sender: TObject);
    procedure login1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure logout1Execute(Sender: TObject);
    procedure ProjectNew1Execute(Sender: TObject);
    procedure DataDrillsExecute(Sender: TObject);
    procedure BaseDrillTypeExecute(Sender: TObject);
    procedure BaseEarthTypeExecute(Sender: TObject);
    procedure DataStratumExecute(Sender: TObject);
    procedure BaseBorerExecute(Sender: TObject);
    procedure DataAntiTestExecute(Sender: TObject);
    procedure DataStratumDescExecute(Sender: TObject);
    procedure DataSectionExecute(Sender: TObject);
    procedure DataSection_drillExecute(Sender: TObject);
    procedure CptInputExecute(Sender: TObject);
    procedure DataCPTExecute(Sender: TObject);
    procedure DataSampleExecute(Sender: TObject);
    procedure TableSectionTotalExecute(Sender: TObject);
    procedure DataCrossBoardExecute(Sender: TObject);
    procedure TableChengZaiLiTeZhengZhiExecute(Sender: TObject);
    procedure ChartStaticTouchExecute(Sender: TObject);
    procedure ChartZhuZhuangTuExecute(Sender: TObject);
    procedure DataFileLoadExecute(Sender: TObject);
    procedure ChartSectionPrintExecute(Sender: TObject);
    procedure actJueSuanExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ChartDrillPositionExecute(Sender: TObject);
    procedure TableWuLiLiXueExecute(Sender: TObject);
    procedure BaseEarth_descExecute(Sender: TObject);
    procedure ChartZongTuLiExecute(Sender: TObject);
    procedure tableKTDCGYLBExecute(Sender: TObject);
    procedure DataJieKongExecute(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure chartYtshjcshchgbExecute(Sender: TObject);
    procedure ChartJingTanTongJiExecute(Sender: TObject);
    procedure ChartCrossboardExecute(Sender: TObject);
    procedure chartReportLanguageExecute(Sender: TObject);
    procedure ChartJingTanShiYanExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ChartSectionZipExecute(Sender: TObject);
    procedure ChartBiaoGuanFenCengExecute(Sender: TObject);
    procedure TeShuFileLoadExecute(Sender: TObject);
    procedure DataSampleTeShuExecute(Sender: TObject);
    procedure TableSectionTotalTeShuExecute(Sender: TObject);
    procedure DataDrills_XYExecute(Sender: TObject);
    procedure ProjectExportExecute(Sender: TObject);
    procedure tableGongZuoLiangTongJiExecute(Sender: TObject);
    procedure DataFileLoadXLSExecute(Sender: TObject);
    procedure DataFileLoadXLS_GuJieExecute(Sender: TObject);
  private
    { Private declarations }
    procedure EnableActions;
    procedure DisableActions;
    procedure OpenForm(FormClass: TFormClass;AOwner:TComponent=nil);
    function getJingTanShiYanQuerySQL:string;
  public
    procedure SetStatusMessage;
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  m_Bitmap: TBitmap;
implementation

uses ProjectOpen, MainDM, public_unit, login, ProjectNew, Drills,
  DrillType, EarthType, Stratum, Borer, Stratum_desc,
  YuanWeiCeShi, Section, SectionDrill, CPT, EarthSample,
  SectionTotal, CrossBoard, ChengZaiLiTeZhengZhi, CptPrint,
  ZhuZhuangTu, TuYangDaoRu, DrillPosition,
  WuLiLiXue, YanTuMiaoShu, Preview, Legend, JieKong, About, JingTanTongJi,
  CrossBoardPrint, ReportLangSelect, FenCengYaSuo,
  TeShuYangDaoRu, EarthSampleTeShu, SectionTotalTeShu, DrillsXY,
  JueSuanKongSheDing, ExportPrj, GongZuoLiangTongJi, TuYangDaoRuXLS,
  TuYangDaoRuXLS_GuJie;

{$R *.dfm}

procedure TMainForm.OpenForm(FormClass: TFormClass;AOwner:TComponent=nil);
//���ݴ���������������,������ڴ�����ֻ�������������OnClose�¼���һ��ҪAction:=CaFree; 
var 
  i: integer;
  Child:TForm; 
begin 
  for i := 0 to Screen.FormCount -1 do 
  if Screen.Forms[i].ClassType=FormClass then 
  begin
    Child:=Screen.Forms[i]; 
    if Child.WindowState=wsMinimized then
    Child.WindowState:=wsNormal;
    Child.BringToFront;
    Child.Setfocus;
    exit;
  end; 
  Child:=TForm(FormClass.NewInstance);
  if not assigned(aowner) then aowner:=application;
  Child.Create(AOwner);
  child.ShowModal;
end;

procedure TMainForm.WindowsTile1Execute(Sender: TObject);
begin
  Tile;
end;

procedure TMainForm.WindowsCascade1Execute(Sender: TObject);
begin
  Cascade;
end;
//
procedure TMainForm.WindowsArrangeicons1Execute(Sender: TObject);
begin
  ArrangeIcons;
end;

procedure TMainForm.ProjectOpen1Execute(Sender: TObject);
begin
  OpenForm(TProjectOpenForm,Application);
end;

procedure TMainForm.ProjectExit1Execute(Sender: TObject);
begin
  self.Close;
end;

procedure TMainForm.login1Execute(Sender: TObject);
begin
  loginForm := TloginForm.Create(self);
  if loginForm.ShowModal = mrOk then
    begin
      EnableActions;
    end
  else
    self.Close;

end;

procedure TMainForm.EnableActions;
var
  ac1 :TAction;
  i:integer;
begin
  for i:= 0 to ActionManager1.ActionCount -1 do
  begin
    ac1 := Taction(ActionManager1.Actions[i]);
    ac1.Enabled := true;
  end;
  login1.Enabled := false;  
end;

procedure TMainForm.DisableActions;
var
  ac1 :TAction;
  i:integer;
begin
  for i:= 0 to ActionManager1.ActionCount -1 do
  begin
    ac1 := Taction(ActionManager1.Actions[i]);
    ac1.Enabled := false;
  end;
  login1.Enabled := true;
  ProjectExit1.Enabled :=true;  
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  sPanel : TStatuspanel;
begin
  m_Bitmap:= TBitmap.Create;
  m_Bitmap.Width := imgBackGround.Picture.Width;
  m_Bitmap.Height := imgBackGround.Picture.Height;
  m_Bitmap.PixelFormat := pf24bit;
  m_Bitmap.Canvas.Draw(0,0,imgBackGround.Picture.Graphic);
  self.Brush.Bitmap := m_Bitmap;

  sPanel := StatusBar1.Panels.Add;
  sPanel.Width := StatusBar1.Width ;
  //imgBackGround.Top := trunc((self.ClientHeight - imgBackGround.Height)/2);
  //imgBackGround.Left := trunc((self.ClientWidth -imgBackGround.Width)/2);
  DisableActions;

end;

procedure TMainForm.logout1Execute(Sender: TObject);
begin
  DisableActions;
  StatusBar1.Panels[0].Text := '';
  MainDataModule.ADOConnection1.Close;
   
end;

procedure TMainForm.ProjectNew1Execute(Sender: TObject);
begin
  openform(TProjectNewForm,Application);
end;

procedure TMainForm.DataDrillsExecute(Sender: TObject);
begin
  Openform(TDrillsForm,Application);
end;

procedure TMainForm.BaseDrillTypeExecute(Sender: TObject);
begin
  Openform(TDrillTypeForm,Application);
end;

procedure TMainForm.BaseEarthTypeExecute(Sender: TObject);
begin
  Openform(TEarthTypeForm,Application);
end;

procedure TMainForm.DataStratumExecute(Sender: TObject);
begin
  Openform(TStratumForm,Application);
end;

procedure TMainForm.BaseBorerExecute(Sender: TObject);
begin
  Openform(TBorerTypeForm,Application); 
end;

procedure TMainForm.DataAntiTestExecute(Sender: TObject);
begin
  Openform(TYuanWeiCeShiForm,Application);
end;

procedure TMainForm.DataStratumDescExecute(Sender: TObject);
begin
  Openform(TStratum_descForm,Application);
end;

procedure TMainForm.DataSectionExecute(Sender: TObject);
begin
  Openform(TSectionForm,Application);
end;

procedure TMainForm.DataSection_drillExecute(Sender: TObject);
begin
  Openform(TSectionDrillForm,Application);
end;

procedure TMainForm.CptInputExecute(Sender: TObject);
begin
  Openform(TCPTForm,Application);
end;

procedure TMainForm.DataCPTExecute(Sender: TObject);
begin
  Openform(TCPTForm,Application);
end;

procedure TMainForm.DataSampleExecute(Sender: TObject);
begin
  Openform(TEarthSampleForm,Application);
end;

procedure TMainForm.TableSectionTotalExecute(Sender: TObject);
begin
  Openform(TSectionTotalForm,Application);
end;

procedure TMainForm.DataCrossBoardExecute(Sender: TObject);
begin
  Openform(TCrossBoardForm,Application);
end;

procedure TMainForm.TableChengZaiLiTeZhengZhiExecute(Sender: TObject);
begin
 Openform(TChengZaiLiTeZhengZhiForm,Application);
end;

procedure TMainForm.ChartStaticTouchExecute(Sender: TObject);
begin
 Openform(TCptPrintForm,Application); 
end;

procedure TMainForm.ChartZhuZhuangTuExecute(Sender: TObject);
begin
  Openform(TZhuZhuangTuForm,Application);
end;

procedure TMainForm.DataFileLoadExecute(Sender: TObject);
begin
  Openform(TTuYangDaoRuForm,Application);
 { for i := 0 to Screen.FormCount -1 do 
  if Screen.Forms[i].ClassType=TEarthSampleForm then 
  begin
    MessageBox(application.Handle,
      '���ڵ�����������ǰ�ر��������������޸Ĵ��ڣ�','ϵͳ��ʾ',MB_OK+MB_ICONINFORMATION);
    exit;
  end;
  TuYangDaoRuForm:= TTuYangDaoRuForm.Create(Application);
  TuYangDaoRuForm.ShowModal;}
  
end;

procedure TMainForm.ChartSectionPrintExecute(Sender: TObject);
begin
  OpenForm(TSectionForm,Application);
end;

procedure TMainForm.actJueSuanExecute(Sender: TObject);
begin
   JueSuanKongSheDingForm:= TJueSuanKongSheDingForm.Create(Application);
   JueSuanKongSheDingForm.ShowModal;

   JueSuanKongSheDingForm.Free;



end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  m_Bitmap.Free;
  Action:= caFree;
end;

procedure TMainForm.ChartDrillPositionExecute(Sender: TObject);
begin
  DrillPositionForm:= TDrillPositionForm.Create(Application);
  DrillPositionForm.ShowModal;
end;

procedure TMainForm.TableWuLiLiXueExecute(Sender: TObject);
begin
  WuLiLiXueForm:= TWuLiLiXueForm.Create(Application);
  WuLiLiXueForm.ShowModal;
end;

procedure TMainForm.BaseEarth_descExecute(Sender: TObject);
begin
  YanTuMiaoShuForm:= TYanTuMiaoShuForm.Create(Application);
  YanTuMiaoShuForm.ShowModal;
end;

procedure TMainForm.ChartZongTuLiExecute(Sender: TObject);
begin
  LegendForm:= TLegendForm.Create(Application);
  LegendForm.ShowModal;

end;

procedure TMainForm.tableKTDCGYLBExecute(Sender: TObject);
begin
  if g_ProjectInfo.prj_no ='' then 
  begin
    MessageBox(application.Handle,'���ȴ�һ�����̡�','ϵͳ��ʾ',MB_OK+MB_ICONERROR);
    exit;    
  end;
  with qryDrillsPrint do
  begin
    close;
    sql.Clear;
//yys 2006/08/31 �޸ģ���̽��ɹ�һ�����ж��黨�ף�Ҳ��С������ף�Ҳ��Ҫͳ��
    sql.Add('SELECT drl_no, drl_x, drl_y, drl_elev, comp_depth, stable_elev, d_t_name '
      +' FROM drills,drill_type '
      +'WHERE drills.prj_no='+ ''''+g_ProjectInfo.prj_no_ForSQL+''''
      +' AND drills.d_t_no= drill_type.d_t_no' );

      //+' AND drills.d_t_no<>'+g_ZKLXBianHao.XiaoZuanKong);
//yys 2006/08/31 �����޸�
    Open;
  end;
  frReport1.LoadFromFile(g_AppInfo.PathOfReports + 'KanTanDanYiLanBiao.frf');
  frReport1.Preview := PreviewForm.frPreview1;
  if frReport1.PrepareReport then
  begin
    frReport1.ShowPreparedReport;
    PreviewForm.ShowModal;
  end;
  qryDrillsPrint.Close;

end;

procedure TMainForm.DataJieKongExecute(Sender: TObject);
begin
  JieKongForm:= TJieKongForm.Create(Application);
  JieKongForm.ShowModal;

end;

procedure TMainForm.HelpAbout1Execute(Sender: TObject);
begin
  AboutForm := TAboutForm.Create(Application);
  AboutForm.ShowModal;
end;

procedure TMainForm.chartYtshjcshchgbExecute(Sender: TObject);
var
  strSQL, prj_no,drl_no,stra_no,sub_no, tmpStratumTableName, strLastCeng_FieldName: string;
  preStra_depth, nowStra_depth: double;
  iIsLastCeng:Integer;
begin
  try
    Screen.Cursor := crHourGlass;
    prj_no := g_ProjectInfo.prj_no_ForSQL;
    iIsLastCeng := 0;//��ʾ����׵����һ��
    strLastCeng_FieldName :=  'isLastCeng';
    tmpStratumTableName := 'Stratum';
    //strSQL := 'Drop Table ' + tmpStratumTableName;
    //Delete_oneRecord(MainDataModule.qryPublic,strSQL);
//    strSQL := 'SELECT * INTO ' + tmpStratumTableName + ' FROM stratum WHERE prj_no=' +''''+ prj_no+'''';
//    Update_oneRecord( MainDataModule.qryPublic,strSQL);
//    strSQL := 'ALTER TABLE '+ tmpStratumTableName +' ADD [' + strLastCeng_FieldName +'] [tinyint]  NULL';
//    Update_oneRecord( MainDataModule.qryPublic,strSQL);

    strSQL:='SELECT prj_no, drl_no, stra_no, sub_no, ea_name, stra_depth '
       +'FROM  ' + tmpStratumTableName
       +' WHERE prj_no=' +''''+ prj_no+''''
       +' ORDER BY drl_no,stra_depth';


    with MainDataModule.qryStratum do
      begin
        close;
        sql.Clear;
        sql.Add(strSQL);
        open;
        preStra_depth:=0;
        while not Eof do
          begin
            if Drl_no<> stringReplace(FieldByName('drl_no').AsString,'''','''''',[rfReplaceAll]) then
            begin
              //2005/07/18 yys add ��Ϊ���һ����һ����û�Ҵ��Ĳ�(�Ҵ�����˼�Ǽ����������˻���˵�������ڿ׵����һ��)�����ܲ���ͳ�ƣ����԰��������Ϊ-1
              //��ô����ͳ�Ʋ�ѯ��ʱ���԰Ѳ��С����Ĳ���ѯ������
              strSQL := 'UPDATE ' + tmpStratumTableName +' SET ' + strLastCeng_FieldName+' = ' + IntToStr(iIsLastCeng)
                        +' WHERE prj_no= ' +''''+ prj_no+''''
                        +' AND drl_no= ' +''''+ drl_no+''''
                        +' AND stra_no= ' +''''+ stra_no+''''
                        +' AND sub_no= ' +''''+ sub_no+'''';
              if Drl_no<>'' then
                Update_oneRecord(MainDataModule.qryPublic,strSQL);
              //2005/07/18 yys add
              preStra_depth := 0;
            end;
            Drl_no := stringReplace(FieldByName('drl_no').AsString,'''','''''',[rfReplaceAll]);
            Stra_no := stringReplace(FieldByName('stra_no').AsString,'''','''''',[rfReplaceAll]);
            Sub_no := stringReplace(FieldByName('sub_no').AsString,'''','''''',[rfReplaceAll]);
            nowStra_depth:= FieldByName('stra_depth').AsFloat;
            strSQL := 'UPDATE  ' + tmpStratumTableName +'  set stra_CengHou = '
              +FormatFloat('0.00',nowStra_depth -preStra_depth)
              +' WHERE prj_no= ' +''''+ prj_no+''''
              +' AND drl_no= ' +''''+ drl_no+'''' 
              +' AND stra_no= ' +''''+ stra_no+''''
              +' AND sub_no= ' +''''+ sub_no+'''';
            Update_oneRecord(MainDataModule.qryPublic,strSQL);
            preStra_depth := nowStra_depth;

            Next ;
          end;

        close;
      end;

    //2005/07/18 yys add ��Ϊ���һ����һ����û�Ҵ��Ĳ㣬���ܲ���ͳ�ƣ����԰��������Ϊ-1
    //��ô����ͳ�Ʋ�ѯ��ʱ���԰Ѳ��С����Ĳ���ѯ������������ȥ�����һ���׵����һ��
//    strSQL := 'UPDATE ' + tmpStratumTableName +' set stra_CengHou = -1'
//              +' WHERE prj_no= ' +''''+ prj_no+''''
//              +' AND drl_no= ' +''''+ drl_no+''''
//              +' AND stra_no= ' +''''+ stra_no+''''
//              +' AND sub_no= ' +''''+ sub_no+'''';
//    if Drl_no<>'' then
//      Update_oneRecord(MainDataModule.qryPublic,strSQL);
    //2005/07/18 yys add

    strSQL := 'SELECT id, stra_no, sub_no,'
     +' MIN(CASE WHEN ' + strLastCeng_FieldName+' = ' + IntToStr(iIsLastCeng) +' THEN NULL ELSE  CengHou END) AS min_cenghou,'
     +' MAX(CASE WHEN ' + strLastCeng_FieldName+' = ' + IntToStr(iIsLastCeng) +' THEN NULL ELSE  CengHou END) AS max_cenghou,'
     +' AVG(CASE WHEN ' + strLastCeng_FieldName+' = ' + IntToStr(iIsLastCeng) +' THEN NULL ELSE  CengHou END) AS avg_cenghou,'
     +' MIN(CASE WHEN ' + strLastCeng_FieldName+' = ' + IntToStr(iIsLastCeng) +' THEN NULL ELSE  cengdi END) AS min_CengDi,'
     +' MAX(CASE WHEN ' + strLastCeng_FieldName+' = ' + IntToStr(iIsLastCeng) +' THEN NULL ELSE  Cengdi END) AS max_CengDi,'
     +' MIN(cengding) AS min_CengDing,'
     +' MAX(cengding) AS max_CengDing,'
     +' MIN(CASE WHEN ' + strLastCeng_FieldName+' = ' + IntToStr(iIsLastCeng) +' THEN NULL ELSE  CengShen END) AS min_cengshen,'
     +' MAX(CASE WHEN ' + strLastCeng_FieldName+' = ' + IntToStr(iIsLastCeng) +' THEN NULL ELSE  CengShen END) AS max_cengshen'
     +' FROM (SELECT stratum_description.id,' + tmpStratumTableName +'.drl_no,'
     +' drills.drl_elev, ' + tmpStratumTableName +'.stra_no, ' + tmpStratumTableName +'.sub_no, '
     + tmpStratumTableName +'.'+ strLastCeng_FieldName+', '
     + tmpStratumTableName +'.stra_cenghou as CengHou, '
     + tmpStratumTableName +'.stra_depth as cengshen, '
     +' drills.drl_elev - ' + tmpStratumTableName +'.stra_depth as cengdi,'
     +' drills.drl_elev - ' + tmpStratumTableName +'.stra_depth + ' + tmpStratumTableName +'.stra_cenghou as cengding'
     +' FROM ' + tmpStratumTableName +' INNER JOIN drills '
     +' ON ' + tmpStratumTableName +'.prj_no = drills.prj_no AND ' + tmpStratumTableName +'.drl_no = drills.drl_no '
     +' INNER JOIN stratum_description '
     +' ON ' + tmpStratumTableName +'.prj_no = stratum_description.prj_no '
     +' AND ' + tmpStratumTableName +'.stra_no = stratum_description.stra_no'
     +' AND ' + tmpStratumTableName +'.sub_no = stratum_description.sub_no'
     +' WHERE (' + tmpStratumTableName +'.prj_no = '+''''+ prj_no+''') '
  //2005/07/18 yys add
     +' AND (' + tmpStratumTableName +'.stra_cenghou>0) '
  //2005/07/18 yys add
  //2008/12/03 yys add ����ѡ����������ײ���ͳ��
     +'AND ' + tmpStratumTableName +'.drl_no in (select drl_no from drills where can_tongji=0 '
          +' AND prj_no='+''''+prj_no+''')'
  //END 2008/12/03 yys
     +' ) newtable GROUP BY id, stra_no, sub_no ORDER BY id';

    with self.qryYtsjcscgb  do
    begin
      close;
      sql.Clear;
      sql.Add(strSQL);
      Open;
    end;
    frReport1.LoadFromFile(g_AppInfo.PathOfReports + 'YanTuSheJiCanShu.frf');
    frReport1.Preview := PreviewForm.frPreview1;
    if frReport1.PrepareReport then
    begin
      frReport1.ShowPreparedReport;
      PreviewForm.ShowModal;
    end;
    qryYtsjcscgb.Close;

  finally
    screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.ChartJingTanTongJiExecute(Sender: TObject);
begin
  JingTanTongJiForm:= TJingTanTongJiForm.Create(Application);
  JingTanTongJiForm.ShowModal;
end;

procedure TMainForm.SetStatusMessage;
var
  ini_file:TInifile;
begin
    StatusBar1.Panels[0].Text := '��ǰ���̣���ţ�'
      + g_ProjectInfo.prj_no + ' ; ���ƣ�'
      + g_ProjectInfo.prj_name + ';';
    //��server.ini�ļ��б���򿪵Ĺ��̱��,�´δ򿪴˴���ʱֱ�Ӷ�λ���˹���.  
    ini_file := TInifile.Create(g_AppInfo.PathOfIniFile);
    ini_file.WriteString('project','no',g_ProjectInfo.prj_no);
    ini_file.WriteString('project','name',g_ProjectInfo.prj_name); 
    ini_file.Free;
end;


procedure TMainForm.ChartCrossboardExecute(Sender: TObject);
begin
  Openform(TCrossBoardPrintForm,Application);
end;

procedure TMainForm.chartReportLanguageExecute(Sender: TObject);
begin
  OpenForm(TReportLangSelectForm, Application);
end;


function TMainForm.getJingTanShiYanQuerySQL:string;
var
  I: Integer;
  drl_no , strSQL,drl_type: string;
  strQcAverage, strFsAverage: string;
  strStra_no: string;
  iDrlStratumCount,  iPrjStratumCount : integer;
  //Drl_no_Array: array of string;
  slProjectCengHao,   //��ǰ���̵���������ź��ǲ�� 1��2
  slDrillCengHao,     //һ���׵���������ź��ǲ�� 1��2
  slRearrangeQc,      //һ���׵�QC��ÿһ���ƽ��ֵ,
                      //�͹����ܵ���������Ӧ���������еõ������磺ԭ����2,3,4 
                      //���ź������ 2,,3,,,,4 ��Ϊһ���׵Ĳ�һ���ȹ����ܵ���
  slRearrangeFs,
  slRearrangePs,
  slQc,               //һ���׵�QC��ÿһ���ƽ��ֵ  ׶������ƽ��ֵ
  slFs,               //һ���׵�FS��ÿһ���ƽ��ֵ  ���Ħ����ƽ��ֵ
  slPs: TStringList;  //һ���׵�PS��ÿһ���ƽ��ֵ
const
  SelectSQL= ' SELECT ';
  FromSQL  = ' FROM cpt ';
  UnionSQL = ' UNION ';
begin
  slProjectCengHao := TStringList.Create ;
  slDrillCengHao   := TStringList.Create ;
  slQc             := TStringList.Create ;
  slFs             := TStringList.Create ;
  slPs             := TStringList.Create ;
  slRearrangeQc    := TStringList.Create ;
  slRearrangeFs    := TStringList.Create ;
  slRearrangePs    := TStringList.Create ;
  result := '';
  try
    //ȡ�õ�ǰ���̵���������ź��ǲ�� 1��2
    with MainDataModule.qryStratum_desc do
      begin
        close;
        sql.Clear;
        sql.Add('select id,prj_no,stra_no,sub_no,ea_name FROM stratum_description');
        sql.Add(' WHERE prj_no=' +''''+g_ProjectInfo.prj_no_ForSQL +'''');
        sql.Add(' ORDER BY id');
        open;
        while not Eof do
          begin
            strStra_no := FieldByName('stra_no').AsString;
            if (FieldByName('sub_no').AsString) <> '0' then
              strStra_no:= strStra_no + '-' + FieldByName('sub_no').AsString;
            slProjectCengHao.Add(strStra_no) ;
            next;
          end;
        close;
      end;

    //ѭ��ȡ��ÿһ���׵Ĳ�ź;�̽����ƽ��ֵ
    with MainDataModule.qryDrills do
      begin
        close;
        sql.Clear;
        //sql.Add('select prj_no,prj_name,area_name,builder,begin_date,end_date,consigner from projects');
        sql.Add(' SELECT drills.drl_no,drills.d_t_no FROM drills,cpt ');
        sql.Add(' WHERE drills.prj_no='+''''+g_ProjectInfo.prj_no_ForSQL+'''');
        sql.Add(' AND drills.drl_no = cpt.drl_no ');
        //2008/11/21 yys edit ����ѡ����������ײ���ͳ��
        sql.Add(' AND drills.prj_no = cpt.prj_no '
               +' AND drills.drl_no in (select drl_no from drills where can_tongji=0 '
                  +' AND prj_no='+''''+g_ProjectInfo.prj_no_ForSQL+'''' + ')');
        sql.Add(' ORDER BY drills.drl_no');
        open;
        i:=0;
        while not Eof do
          begin
            i:=i+1;
            drl_no := stringReplace(FieldByName('drl_no').AsString,'''','''''',[rfReplaceAll]);
            drl_type := FieldByName('d_t_no').AsString;

            slDrillCengHao   := TStringList.Create ;
            slQc             := TStringList.Create ;
            slFs             := TStringList.Create ;
            slPs             := TStringList.Create ;
            slRearrangeQc    := TStringList.Create ;
            slRearrangeFs    := TStringList.Create ;
            slRearrangePs    := TStringList.Create ;

            //ȡ��һ���׵���������ź��ǲ��
            strSQL:='select stra_no,sub_no, stra_depth FROM stratum '
                +' WHERE prj_no='+''''+g_ProjectInfo.prj_no_ForSQL+''''
                +' AND drl_no ='+''''+drl_no+'''' + ' ORDER BY stra_depth';
            with qryDrillsPrint do
              begin
                close;
                sql.Clear;
                sql.Add(strSQL);
                open;
                while not Eof do
                  begin

                    strStra_no := FieldByName('stra_no').AsString;
                    if (FieldByName('sub_no').AsString) <> '0' then
                      strStra_no:= strStra_no + '-' + FieldByName('sub_no').AsString;
                    slDrillCengHao.Add(strStra_no) ;

                    next;
                  end;
                close;   //close qryDrillsPrint
              end;

                //��ʼȡ����׵ľ�����̽�����ƽ��ֵ
            strQcAverage:='';
            strFsAverage:='';

            getCptAverageByDrill(drl_no, strQcAverage, strFsAverage);

            if drl_type = g_ZKLXBianHao.ShuangQiao then
              begin
                if strQcAverage<>'' then
                  DivideString(strQcAverage,',',slQc);
                if strFsAverage<>'' then
                  DivideString(strFsAverage,',',slFs);
              end;
            if drl_type = g_ZKLXBianHao.DanQiao  then
              begin
                if strQcAverage<>'' then
                  DivideString(strQcAverage,',',slPs);
              end;


            //��ȡ�õ���׾�����̽�����ƽ��ֵ�������У��͹��̵��ܲ�����Ӧ
            for iPrjStratumCount := 0 to slProjectCengHao.Count  - 1 do    // Iterate
            begin
              slRearrangeQc.Add('-1');
              slRearrangeFs.Add('-1');
              slRearrangePs.Add('-1');
              for iDrlStratumCount := 0 to slDrillCengHao.Count  - 1 do    // Iterate
              begin
                if slDrillCengHao.Strings[iDrlStratumCount]=slProjectCengHao.Strings[iPrjStratumCount] then
                  begin
                    if drl_type = g_ZKLXBianHao.ShuangQiao then
                      begin
                        if slQc.Count >= (iDrlStratumCount+1) then
                          slRearrangeQc.Strings[iPrjStratumCount] :=
                            slQc.Strings[iDrlStratumCount];
                        if slFs.Count >= (iDrlStratumCount+1) then
                          slRearrangeFs.Strings[iPrjStratumCount] :=
                            slFs.Strings[iDrlStratumCount];
                      end;
                    if drl_type = g_ZKLXBianHao.DanQiao then
                      begin
                        if slPs.Count >= (iDrlStratumCount+1) then
                          slRearrangePs.Strings[iPrjStratumCount] :=
                            slPs.Strings[iDrlStratumCount];
                      end;

                  end;
              end;    // for
            end;    // for

    //        SelectSQL= ' SELECT ';
    //        FromSQL  = ' FROM cpt ';
    //        UnionSQL = ' UNION ';
            if i=1 then //������ڲ������ǵ�һ�����
              Result :=  SelectSQL +'''' + drl_no + '''' + ' AS drl_no,'
            else
              Result := Result + UnionSQL + SelectSQL +'''' + drl_no+''',';
            for iPrjStratumCount := 0 to slProjectCengHao.Count  - 1 do
            begin
              if i=1 then    //������ڲ������ǵ�һ�����,��Ҫ����������
                Result :=Result
                  + slRearrangeQc.Strings[iPrjStratumCount] + ' AS qc'+IntToStr(
                    iPrjStratumCount+1) +','
                  + slRearrangeFs.Strings[iPrjStratumCount] + ' AS fs'+IntToStr(
                    iPrjStratumCount+1) +','
                  + slRearrangePs.Strings[iPrjStratumCount] + ' AS ps'+IntToStr(
                    iPrjStratumCount+1) +','
              else
                Result :=Result
                  + slRearrangeQc.Strings[iPrjStratumCount] +','
                  + slRearrangeFs.Strings[iPrjStratumCount] +','
                  + slRearrangePs.Strings[iPrjStratumCount] +',';
            end;
            result := copy(result,1,length(result)-1);  //ȥ�����һ������
            result := result + FromSQL;

            slDrillCengHao.Free;
            slQc.Free;
            slFs.Free;
            slPs.Free;
            slRearrangeQc.Free;
            slRearrangeFs.Free;
            slRearrangePs.Free;

            Next ;
          end;
        close; //MainDataModule.qryDrills
      end;
    if trim(result) = '' then exit;

    //result := 'SELECT * INTO TempTable FROM (' + result + ') myTempTable'; //
    //����д��Ŀ�����������ı�ת�������һ��ʵ�ʵı���������һ��
  finally // wrap up
    slProjectCengHao.Free;

  end;    // try/finally


end;

procedure TMainForm.ChartJingTanShiYanExecute(Sender: TObject);
var
  i,iLeft,iTop_PageHead_Qc,iHeight,iWidth : integer;
  strText,strSQL,strTemp : string;
  frMemoView   : TfrMemoView;
  //frBandView   : TfrBandView;
  frPage       : TfrPage;

const
  TITLE_TOP         = 20;    //���еĳ�����Ҫ����������е�Band��Ӧ ��JingTanShiYanChengGoTongJiBiao.frf
  TITLE_HEIGHT      = 40;
  MasterHeader_Top     = 144;
  MasterHeader_Height  = 121;
  MasterHeader_FirstMEMO_Width = 70;
  MasterHeader_FirstMEMO_Left  = 5;

  MasterHeader_MEMO_Width = 120;  //
  //MasterHeader_MEMO_WidthҪ�ܱ�3��������Ϊ�������ı��������ź�������
  MasterHeader_MEMO_HEIGHT_Stratum_No = 33;
  MasterHeader_MEMO_HEIGHT_Average  = 33;

  MasterData_Top =364;
  MasterData_MEMO_Height = 25;
  MasterDataName ='qryJingTanShiYan';
begin
  try
    Screen.Cursor := crHourGlass;
    frReportJingTanShiYan.LoadFromFile(g_AppInfo.PathOfReports + 'JingTanShiYanChengGoTongJiBiao.frf');
    frReportJingTanShiYan.Preview := PreviewForm.frPreview1;
//    frReportJingTanShiYan.Pages.Clear;
//    frReportJingTanShiYan.Pages.Add;              // create page
    frPage := frReportJingTanShiYan.Pages[0];
//    frpage.ChangePaper(3,297,420,2,poLandscape);  //A3
    //���ñ���ͷ
//    frBandView := TfrBandView.Create;
//    frBandView.SetBounds(0, TITLE_TOP, 0, TITLE_HEIGHT);
//    frBandView.BandType := btReportTitle;
//    frPage.Objects.Add(frBandView);

    frMemoView := TfrMemoView.Create;             // create memo
    frMemoView.SetBounds(20, TITLE_TOP, 324, TITLE_HEIGHT);
    frMemoView.BandAlign := baCenter;
    frMemoView.Prop['Alignment'] := frtaCenter;   // another way to access properties
    frMemoView.Font.Style  := [fsBold];
    frMemoView.Font.Name   := '����';
    frMemoView.Font.Size   := 16;
    frMemoView.Memo.Add('������̽����ɹ�ͳ�Ʊ�');
    frMemoView.LineSpacing := 10;
    frMemoView.Flags := flUnderlines;
    frPage.Objects.Add(frMemoView);

    //���ñ�������ͷ
//    frBandView := TfrBandView.Create;
//    frBandView.SetBounds(0, MasterHeader_Top, 0, MasterHeader_Height);
//    frBandView.BandType := btPageHeader;
//    frPage.Objects.Add(frBandView);

    frMemoView := TfrMemoView.Create;             // create memo
    iHeight := MasterHeader_MEMO_HEIGHT_Stratum_No +
      MasterHeader_MEMO_HEIGHT_Average;
    frMemoView.SetBounds(MasterHeader_FirstMEMO_Left, MasterHeader_Top,
      MasterHeader_FirstMEMO_Width, iHeight);
    frMemoView.Prop['Alignment'] := frtaCenter;
    frMemoView.Font.Name   := '����';
    frMemoView.Font.Size   := 9;
    frMemoView.FrameTyp   :=15;   //�б߿�
    frMemoView.Memo.Add('���̵��ʲ�');
    frPage.Objects.Add(frMemoView);

    frMemoView := TfrMemoView.Create;             // create memo
    iHeight := MasterHeader_Height-MasterHeader_MEMO_HEIGHT_Stratum_No -
      MasterHeader_MEMO_HEIGHT_Average;
    iTop_PageHead_Qc := MasterHeader_Top + MasterHeader_MEMO_HEIGHT_Stratum_No +
      MasterHeader_MEMO_HEIGHT_Average;
    frMemoView.SetBounds(MasterHeader_FirstMEMO_Left, iTop_PageHead_Qc,
      MasterHeader_FirstMEMO_Width, iHeight);
    frMemoView.Prop['Alignment'] := frtaCenter;
    frMemoView.Font.Name   := '����';
    frMemoView.Font.Size   := 9;
    frMemoView.FrameTyp   :=15;
    frMemoView.Memo.Add('�� ��');
    frPage.Objects.Add(frMemoView);

    //���ñ�����������Band
//    frBandView := TfrBandView.Create;
//    frBandView.SetBounds(0, MasterHeader_Top+MasterHeader_Height,
//       0, MasterData_MEMO_Height);
//    frBandView.BandType := btMasterData;
//    frBandView.DataSet := 'frDBJingTanShiYan';
//    frPage.Objects.Add(frBandView);
    
    //���ñ����������ݵ�һ��Memo
    frMemoView := TfrMemoView.Create;             // create memo
    iHeight := MasterData_MEMO_Height;
    //iTop := MasterHeader_Top + MasterHeader_Height;
    frMemoView.SetBounds(MasterHeader_FirstMEMO_Left, MasterData_Top,
      MasterHeader_FirstMEMO_Width, iHeight);
    frMemoView.Prop['Alignment'] := frtaCenter;
    frMemoView.Font.Name   := '����';
    frMemoView.Font.Size   := 9;
    frMemoView.FrameTyp   :=15;
    frMemoView.Memo.Add('['+MasterDataName+'."drl_No"]');  //��׺�
    frPage.Objects.Add(frMemoView);


    //���ñ�������ͷ�е����ݣ����еĲ��
    with MainDataModule.qryStratum_desc do
      begin
        close;
        sql.Clear;
        sql.Add('select id,prj_no,stra_no,sub_no,ea_name FROM stratum_description');
        sql.Add(' WHERE prj_no=' +''''+g_ProjectInfo.prj_no_ForSQL +'''');
        sql.Add(' ORDER BY id');
        open;
        i:=0;
        while not Eof do
          begin
            i:=i+1;
            //�������мӱ�����ͷ�Ĳ��
            strText := FieldByName('stra_no').AsString;
            if FieldByName('sub_no').AsString='0' then
            else
              strText := strText + '-'+ FieldByName('sub_no').AsString;
            frMemoView := TfrMemoView.Create;             // create memo
            iHeight := MasterHeader_MEMO_HEIGHT_Stratum_No;
            ileft   := MasterHeader_FirstMEMO_Left+MasterHeader_FirstMEMO_Width
              + (i-1)*MasterHeader_MEMO_Width;
            frMemoView.SetBounds(ileft,MasterHeader_Top,
              MasterHeader_MEMO_Width, iHeight);
            frMemoView.Alignment   := frtaCenter;
            frMemoView.Font.Name   := '����';
            frMemoView.Font.Size   := 9;
            frMemoView.FrameTyp    :=15;
            frMemoView.Memo.Add(strText);
            frPage.Objects.Add(frMemoView);

            //�������мӱ�����ͷ�ġ�ƽ��ֵ����������
            frMemoView := TfrMemoView.Create;             // create memo
            iHeight := MasterHeader_MEMO_HEIGHT_Average;
            frMemoView.SetBounds(ileft,MasterHeader_Top+MasterHeader_MEMO_HEIGHT_Stratum_No,
              MasterHeader_MEMO_Width, iHeight);
            frMemoView.Prop['Alignment'] := frtaCenter;
            frMemoView.Font.Name   := '����';
            frMemoView.Font.Size   := 9;
            frMemoView.FrameTyp    :=15;
            frMemoView.Memo.Add('ƽ��ֵ');
            frPage.Objects.Add(frMemoView);

            //�������мӱ�����ͷ�ġ�qc(MPa)����������
            frMemoView := TfrMemoView.Create;             // create memo
            iHeight := MasterHeader_Height-MasterHeader_MEMO_HEIGHT_Stratum_No -
                 MasterHeader_MEMO_HEIGHT_Average;
            //ileft   := MasterHeader_FirstMEMO_Left+MasterHeader_MEMO_Width
            //  + (i-1)*MasterHeader_MEMO_Width;
            iTop_PageHead_Qc := MasterHeader_Top + MasterHeader_MEMO_HEIGHT_Stratum_No
              + MasterHeader_MEMO_HEIGHT_Average;
            iWidth := strtoint(formatfloat('0',MasterHeader_MEMO_Width/3)) ;
            frMemoView.SetBounds(ileft,iTop_PageHead_Qc,iWidth, iHeight);
            frMemoView.Prop['Alignment'] := frtaCenter;
            frMemoView.Font.Name   := '����';
            frMemoView.Font.Size   := 9;
            frMemoView.FrameTyp    :=15;
            frMemoView.Memo.Add('qc'+ #13#10 +'(MPa)');
            frPage.Objects.Add(frMemoView);

            //���ñ����������ݿ׺������Memo,Qc
            frMemoView := TfrMemoView.Create;             // create memo
            //iTop := MasterHeader_Top + MasterHeader_Height;

            frMemoView.SetBounds(iLeft, MasterData_Top,iWidth, MasterData_MEMO_Height);
            frMemoView.Prop['Alignment'] := frtaRight;
            frMemoView.Font.Name   := '����';
            frMemoView.Font.Size   := 9;
            frMemoView.FrameTyp   :=15;
            strTemp := '['+MasterDataName+'."'+'qc'+IntToStr(i)+'"]';
            frMemoView.Memo.Add('[IF('+strTemp
              + '=-1,[''''],[FORMATFLOAT(''0.00'','+strTemp+')])]');
            frPage.Objects.Add(frMemoView);

            //�������мӱ�����ͷ�ġ�fs(KPa)����������
            frMemoView := TfrMemoView.Create;             // create memo
            iLeft   := iLeft+strtoint(formatfloat('0',MasterHeader_MEMO_Width/3));
            frMemoView.SetBounds(ileft,iTop_PageHead_Qc,iWidth, iHeight);
            frMemoView.Prop['Alignment'] := frtaCenter;
            frMemoView.Font.Name   := '����';
            frMemoView.Font.Size   := 9;
            frMemoView.FrameTyp    :=15;
            frMemoView.Memo.Add('fs'+ #13#10 +'(KPa)');
            frPage.Objects.Add(frMemoView);

            //���ñ����������ݿ׺������Memo,fs
            frMemoView := TfrMemoView.Create;             // create memo
            frMemoView.SetBounds(iLeft, MasterData_Top,iWidth, MasterData_MEMO_Height);
            frMemoView.Prop['Alignment'] := frtaRight;
            frMemoView.Font.Name   := '����';
            frMemoView.Font.Size   := 9;
            frMemoView.FrameTyp   :=15;
            strTemp := '['+MasterDataName+'."'+'fs'+IntToStr(i)+'"]';
            frMemoView.Memo.Add('[IF('+strTemp
              + '=-1,[''''],[FORMATFLOAT(''0.00'','+strTemp+')])]');
            frPage.Objects.Add(frMemoView);

            //�������мӱ�����ͷ�ġ�Ps(MPa)����������
            frMemoView := TfrMemoView.Create;             // create memo
            ileft := ileft+strtoint(formatfloat('0',MasterHeader_MEMO_Width/3));
            frMemoView.SetBounds(ileft,iTop_PageHead_Qc,iWidth, iHeight);
            frMemoView.Prop['Alignment'] := frtaCenter;
            frMemoView.Font.Name   := '����';
            frMemoView.Font.Size   := 9;
            frMemoView.FrameTyp    :=15;
            frMemoView.Memo.Add('Ps'+ #13#10 +'(MPa)');
            frPage.Objects.Add(frMemoView);

            //���ñ����������ݿ׺������Memo,ps
            frMemoView := TfrMemoView.Create;             // create memo
            frMemoView.SetBounds(iLeft,MasterData_Top,iWidth, MasterData_MEMO_Height);
            frMemoView.Prop['Alignment'] := frtaRight;
            frMemoView.Font.Name   := '����';
            frMemoView.Font.Size   := 9;
            frMemoView.FrameTyp   :=15;
            strTemp := '['+MasterDataName+'."'+'ps'+IntToStr(i)+'"]';
            frMemoView.Memo.Add('[IF('+strTemp
              + '=-1,[''''],[FORMATFLOAT(''0.00'','+strTemp+')])]');
            frPage.Objects.Add(frMemoView);

            Next ;
          end;
        close;

      end;


//    MainDataModule.DropTableFromDB('TempTable') ;


    strSQL := getJingTanShiYanQuerySQL;
    if strSQL='' then
    begin
      ShowMessage('û������');
      exit;
    end;
//    with MainDataModule.qryPublic do
//    begin
//      close;
//      sql.Clear;
//      sql.Add(strSQL);
//      ExecSQL;
//      close;
//    end;
//
//    strSQL := 'SELECT * FROM TempTable';
    with qryJingTanShiYan do
      begin
        close;
        sql.Clear;
        sql.Add(strSQL);
        open;
        //��ʼ��ӡ����
        if frReportJingTanShiYan.PrepareReport then
        begin
          frReportJingTanShiYan.ShowPreparedReport;
          PreviewForm.ShowModal;
        end;
        close;
      end;
  finally
    screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
//  if g_ProjectInfo.prj_name ='' then
    login1Execute(nil);
end;

procedure TMainForm.ChartSectionZipExecute(Sender: TObject);
begin
  Openform(TFenCengYaSuoForm,Application);
end;

procedure TMainForm.ChartBiaoGuanFenCengExecute(Sender: TObject);
var 
  strSQL: string;
  procedure DeleteTempTable;//ɾ����ʱ��
  begin
    strSQL := 'DROP TABLE #TeZhengShu1';
    with qryTeZhengShu do
    begin
        close;
        sql.Clear;
        sql.Add(strSQL);
        ExecSQL;
        close;
    end;

    strSQL := 'DROP TABLE #SPT1';
    with qryTeZhengShu do
    begin
        close;
        sql.Clear;
        sql.Add(strSQL);
        ExecSQL;
        close;
    end;
  end;
begin
  MainDataModule.DropTableFromDB('WuLiLiXueXingZhiZhiBiao') ;
//yys edit at 2006/04/12 , ����ԺҪ��������ֵ����Сֵ������ȥ��ѡ��������v_id<4 or v_id=6��
  //strSQL:= 'SELECT * INTO WuLiLiXueXingZhiZhiBiao FROM TeZhengShuTmp Where v_id<4 or v_id=6 AND prj_no= '+''''+g_ProjectInfo.prj_no_ForSQL+'''';
  strSQL:= 'SELECT * INTO WuLiLiXueXingZhiZhiBiao FROM TeZhengShuTmp Where prj_no= '+''''+g_ProjectInfo.prj_no_ForSQL+'''';
  with MainDataModule.qryPublic do
  begin
    close;
    sql.Clear;
    sql.Add(strSQL);
    ExecSQL;
    close;
  end;

  if g_ProjectInfo.prj_ReportLanguage= trChineseReport then
    strSQL:='SELECT id,prj_no,stra_no,sub_no,ea_name '
        +' FROM stratum_description'
        +' WHERE prj_no='+''''+g_ProjectInfo.prj_no_ForSQL+''''
        +' ORDER BY id'
  else if g_ProjectInfo.prj_ReportLanguage= trEnglishReport then
    strSQL:='SELECT st.id,st.prj_no,st.stra_no,st.sub_no,ISNULL(et.ea_name_en,'''') as ea_name '
        +' FROM stratum_description st, earthtype et'
        +' WHERE prj_no='+''''+g_ProjectInfo.prj_no_ForSQL+''''
        +' AND st.ea_name = et.ea_name'
        +' ORDER BY id';
  with qryStratum do
    begin
      close;
      sql.Clear;
      sql.Add(strSQL);
      open;
    end;

  //ȡ�ñ�׼������������
  strSQL := 'Select prj_no,drl_no,begin_depth,end_depth,'
    +'pole_len,real_num1+real_num2+real_num3 as real_num,amend_num,stra_no,sub_no Into #SPT1 FROM SPT WHERE prj_no = '
     + ''''+g_ProjectInfo.prj_no_ForSQL+'''' ;
  with qryTeZhengShu do
  begin
      close;
      sql.Clear;
      sql.Add(strSQL);
      ExecSQL;
      close;
  end;    // with
  tblSPT.TableName :='#SPT1';
  tblSPT.MasterFields := 'prj_no;stra_no;sub_no';
  tblSPT.Open;

  strSQL := 'Select * Into #TeZhengShu1 FROM tezhengshuTmp WHERE prj_no = '
     + ''''+g_ProjectInfo.prj_no_ForSQL+'''' + ' AND v_id<7';
  with qryTeZhengShu do
  begin
      close;
      sql.Clear;
      sql.Add(strSQL);
      ExecSQL;
      close;
  end;    // with
  tblTeZhengShu.TableName :='#TeZhengShu1';
  tblTeZhengShu.MasterFields := 'prj_no;stra_no;sub_no';
  //2008/11/21 yys add ���ӱ�׼ֵ��tezhengshuTmp���У������ֵֻ��������ѧ����ָ��һ�����в���Ҫ�������ڷ����ֲ��ܱ���Ҫ���˵����ֵ
  tblTeZhengShu.Open;

  if g_ProjectInfo.prj_ReportLanguage= trChineseReport then
    frReportBaoGuanShiYan.LoadFromFile(g_AppInfo.PathOfReports +
      'BaoGuanShiYanShuJuFenCengZongBiao.frf')
  else if g_ProjectInfo.prj_ReportLanguage= trEnglishReport then
    frReportBaoGuanShiYan.LoadFromFile(g_AppInfo.PathOfReports +
      'BaoGuanShiYanShuJuFenCengZongBiao.frf');
  frReportBaoGuanShiYan.Preview := PreviewForm.frPreview1;
  if frReportBaoGuanShiYan.PrepareReport then
  begin
    frReportBaoGuanShiYan.ShowPreparedReport;
    PreviewForm.ShowModal;
  end;  
  
  self.tblSPT.Close;
  self.tblTeZhengShu.Close;
  self.qryStratum.Close;
  DeleteTempTable;
end;

procedure TMainForm.TeShuFileLoadExecute(Sender: TObject);
begin
  OpenForm(TTeShuYangDaoRuForm, Application);
end;

procedure TMainForm.DataSampleTeShuExecute(Sender: TObject);
begin
  Openform(TEarthSampleTeShuForm,Application);
end;

procedure TMainForm.TableSectionTotalTeShuExecute(Sender: TObject);
begin
  Openform(TSectionTotalTeShuForm,Application);
end;

procedure TMainForm.DataDrills_XYExecute(Sender: TObject);
begin
  Openform(TDrillsXYForm,Application);
end;

procedure TMainForm.ProjectExportExecute(Sender: TObject);
begin
  OpenForm(TExportPrjForm,Application);
end;

procedure TMainForm.tableGongZuoLiangTongJiExecute(Sender: TObject);
begin
  OpenForm(TGongZuoLiangTongJiForm,Application);
end;

procedure TMainForm.DataFileLoadXLSExecute(Sender: TObject);
begin
  Openform(TTuYangDaoRuXLSForm,Application);
end;

procedure TMainForm.DataFileLoadXLS_GuJieExecute(Sender: TObject);
begin
  Openform(TTuYangDaoRuXLS_GuJieForm,Application);
end;

end.
