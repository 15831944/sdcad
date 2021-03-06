program sdCad;

uses
  FastMM4,
  VCLFixPack,
  Forms,
  SysUtils,
  main in 'main.pas' {MainForm},
  ProjectOpen in 'ProjectOpen.pas' {ProjectOpenForm},
  splash in 'splash.pas' {SplashForm},
  MainDM in 'MainDM.pas' {MainDataModule: TDataModule},
  public_unit in 'public_unit.pas',
  login in 'login.pas' {LoginForm},
  ProjectNew in 'ProjectNew.pas' {ProjectNewForm},
  Drills in 'Drills.pas' {DrillsForm},
  DrillDiagram in 'DrillDiagram.pas',
  DrillType in 'DrillType.pas' {DrillTypeForm},
  EarthType in 'EarthType.pas' {EarthTypeForm},
  Stratum in 'Stratum.pas' {StratumForm},
  YuanWeiCeShi in 'YuanWeiCeShi.pas' {YuanWeiCeShiForm},
  Borer in 'Borer.pas' {BorerTypeForm},
  Stratum_desc in 'Stratum_desc.pas' {Stratum_descForm},
  DPTCoefficient in 'DPTCoefficient.pas' {DPTCoefficientForm},
  Section in 'Section.pas' {SectionForm},
  SectionDrill in 'SectionDrill.pas' {SectionDrillForm},
  CPT in 'CPT.pas' {CPTForm},
  EarthSampleTeShu in 'EarthSampleTeShu.pas' {EarthSampleTeShuForm},
  SdCadMath in 'SdCadMath.pas',
  SectionTotal in 'SectionTotal.pas' {SectionTotalForm},
  StratumCategory in 'StratumCategory.pas' {StratumCategoryForm},
  CrossBoard in 'CrossBoard.pas' {CrossBoardForm},
  Preview in 'Preview.pas' {PreviewForm},
  ChengZaiLiTeZhengZhi in 'ChengZaiLiTeZhengZhi.pas' {ChengZaiLiTeZhengZhiForm},
  CptPrint in 'CptPrint.pas' {CptPrintForm},
  ZhuZhuangTu in 'ZhuZhuangTu.pas' {ZhuZhuangTuForm},
  TuYangDaoRu in 'TuYangDaoRu.pas' {TuYangDaoRuForm},
  DrillPosition in 'DrillPosition.pas' {DrillPositionForm},
  UReconYWCS02 in 'UReconYWCS02.pas' {ReconYWCS02},
  Expression in 'Expression.pas' {ExpressForm},
  Expression02 in 'Expression02.pas' {ExpressForm02},
  OtherCharges02 in 'OtherCharges02.pas' {FOtherCharges02},
  OtherCharges92 in 'OtherCharges92.pas' {FOtherCharges92},
  UAdjustment in 'UAdjustment.pas' {FAdjustment},
  UCategory02 in 'UCategory02.pas' {FrmCategory02},
  UCategory92 in 'UCategory92.pas' {FrmCategory92},
  UCategoryMap02 in 'UCategoryMap02.pas' {FrmCMap02},
  UExperiment02 in 'UExperiment02.pas' {Experiment02},
  UExperiment92 in 'UExperiment92.pas' {Experiment92},
  UReconCharge92 in 'UReconCharge92.pas' {ReconCharge92},
  UReconEWS02 in 'UReconEWS02.pas' {ReconEWS02},
  UReconKT02 in 'UReconKT02.pas' {ReconKT02},
  UReconMap02 in 'UReconMap02.pas' {ReconMap02},
  WuLiLiXue in 'WuLiLiXue.pas' {WuLiLiXueForm},
  YanTuMiaoShu in 'YanTuMiaoShu.pas' {YanTuMiaoShuForm},
  Legend in 'Legend.pas' {LegendForm},
  Ck_fak in 'Ck_fak.pas' {Ck_fakForm},
  JieKong in 'JieKong.pas' {JieKongForm},
  About in 'About.pas' {AboutForm},
  YanTuMCTiHuan in 'YanTuMCTiHuan.pas' {FormYanTuMCTiHuan},
  JingTanTongJi in 'JingTanTongJi.pas' {JingTanTongJiForm},
  ReportOutput92 in 'ReportOutput92.pas' {frmCharge92},
  ReportOutput02 in 'ReportOutput02.pas' {frmCharge02},
  CrossBoardPrint in 'CrossBoardPrint.pas' {CrossBoardPrintForm},
  ReportLangSelect in 'ReportLangSelect.pas' {ReportLangSelectForm},
  FenCengYaSuo in 'FenCengYaSuo.pas' {FenCengYaSuoForm},
  EarthSample in 'EarthSample.pas' {EarthSampleForm},
  TeShuYangDaoRu in 'TeShuYangDaoRu.pas' {TeShuYangDaoRuForm},
  SectionTotalTeShu in 'SectionTotalTeShu.pas' {SectionTotalTeShuForm},
  DrillsXY in 'DrillsXY.pas' {DrillsXYForm},
  Hashes in 'Hashes.pas',
  Hash in 'Hash.pas',
  Hashtable in 'Hashtable.pas',
  JueSuanKongSheDing in 'JueSuanKongSheDing.pas' {JueSuanKongSheDingForm},
  ExportPrj in 'ExportPrj.pas' {ExportPrjForm},
  GongZuoLiangTongJi in 'GongZuoLiangTongJi.pas' {GongZuoLiangTongJiForm},
  TuYangDaoRuXLS in 'TuYangDaoRuXLS.pas' {TuYangDaoRuXLSForm},
  TuYangDaoRuXLS_GuJie in 'TuYangDaoRuXLS_GuJie.pas' {TuYangDaoRuXLS_GuJieForm};

{$R *.res}
begin
  try
    Application.Initialize;
    Application.Title := '图比特岩土工程勘察信息管理系统 V1.0';
    SplashForm := TSplashForm.Create(Application);
    SplashForm.Show;
    SplashForm.Update;
    while SplashForm.Timer1.Enabled do
      Application.ProcessMessages;
    SplashForm.Hide;
    Application.CreateForm(TMainDataModule, MainDataModule);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TPreviewForm, PreviewForm);
  Application.CreateForm(TCk_fakForm, Ck_fakForm);
  Application.CreateForm(TFormYanTuMCTiHuan, FormYanTuMCTiHuan);
  Application.CreateForm(TJingTanTongJiForm, JingTanTongJiForm);
  Application.CreateForm(TfrmCharge92, frmCharge92);
  Application.CreateForm(TfrmCharge02, frmCharge02);
  finally
    SplashForm.Free;
  end;
  Application.Run;
end.
