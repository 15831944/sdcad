unit SectionTotal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, frxDSet, frxDBSet, frxClass, math, Buttons,
  ExtCtrls, SUIForm;

type
  TSectionTotalForm = class(TForm)
    suiForm1: TsuiForm;
    btnFenCengJiSuan: TButton;
    btn_Print: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    btn_cancel: TBitBtn;
    frxReport1: TfrxReport;
    frDBTeZhengShu: TfrxDBDataset;
    DSTeZhengShu: TDataSource;
    DSSampleValue: TDataSource;
    frDBSampleValue: TfrxDBDataset;
    DSStratumMaster: TDataSource;
    frDBStratumMaster: TfrxDBDataset;
    tblTeZhengShu: TADOTable;
    tblSampleValue: TADOTable;
    qryStratum: TADOQuery;
    procedure btnFenCengJiSuanClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure frxReport1GetValue(const ParName: String;
      var ParValue: Variant);
    procedure FormCreate(Sender: TObject);
    procedure btn_PrintClick(Sender: TObject);
    procedure frxReport1BeginBand(Band: TfrBand);
    procedure frxReport1EndBand(Band: TfrBand);
  private
    { Private declarations }
    procedure SetTuYangCengHao;
  public
    { Public declarations }
  end;
//yys 20040610 modified 
//const AnalyzeCount=17;
  const AnalyzeCount=19;
//yys 20040610 modified   
var
  SectionTotalForm: TSectionTotalForm;
  m_bPrintRoot: boolean;
implementation

uses MainDM, public_unit, SdCadMath, Preview;

{$R *.dfm}


//ȡ��һ�����������еĲ�ź��ǲ�ź��������ƣ�����������TStringList�����С�
procedure GetAllStratumNo(var AStratumNoList, ASubNoList, AEaNameList: TStringList);
var
  strSQL: string;
begin
  AStratumNoList.Clear;
  ASubNoList.Clear;
  AEaNameList.Clear;
  strSQL:='SELECT id,prj_no,stra_no,sub_no,ea_name FROM stratum_description' 
      +' WHERE prj_no='+''''+stringReplace(g_ProjectInfo.prj_no ,'''','''''',[rfReplaceAll])+''''
      +' ORDER BY id';
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
          AEaNameList.Add(FieldByName('ea_name').AsString);
          next; 
        end;
      close;
    end;
end;

procedure TSectionTotalForm.btnFenCengJiSuanClick(Sender: TObject);

var
  //���          �ǲ��
  lstStratumNo, lstSubNo: TStringList;
  //��׺�   �������   ��ʼ���        �������
  lstDrl_no, lstS_no, lstBeginDepth, lstEndDepth: TStringList;
  //��������      ɰ����(%)    ɰ����(%)      ɰ��ϸ(%)  
  lstShear_type, lstsand_big, lstsand_middle,lstsand_small:Tstringlist;
  //������(%)        ����ϸ(%)     ճ��(%)        ������ϵ��         ����ϵ��         ������ ��������
  lstPowder_big, lstPowder_small, lstClay_grain, lstAsymmetry_coef,lstCurvature_coef, lstEa_name: TStringList;
  i,j,iRecordCount,iCol: integer;
  strSQL, strFieldNames, strFieldValues , strTmp, strSubNo,strStratumNo,strPrjNo: string;
  aAquiferous_rate: TAnalyzeResult;//��ˮ��
  aWet_density    : TAnalyzeResult;//ʪ�ܶ�
  aDry_density    : TAnalyzeResult;//���ܶ�
  aSoil_proportion: TAnalyzeResult;//��������
  aGap_rate       : TAnalyzeResult;//��϶��
  aGap_degree     : TAnalyzeResult;//��϶��
  aSaturation     : TAnalyzeResult;//���϶�
  aLiquid_limit   : TAnalyzeResult;//Һ��
  aShape_limit    : TAnalyzeResult;//����
  aShape_index    : TAnalyzeResult;//����ָ��
  aLiquid_index   : TAnalyzeResult;//Һ��ָ��
  aZip_coef       : TAnalyzeResult;//ѹ��ϵ��
  aZip_modulus    : TAnalyzeResult;//ѹ��ģ��
  aCohesion       : TAnalyzeResult;//������ֱ��
  aFriction_angle : TAnalyzeResult;//Ħ����ֱ��
//yys 20040610 modified  
  aCohesion_gk    : TAnalyzeResult;//�������̿�
  aFriction_gk    : TAnalyzeResult;//Ħ���ǹ̿�
//yys 20040610 modified  
  aWcx_yuanz      : TAnalyzeResult;//�޲��޿�ѹǿ��ԭ״
  aWcx_chsu       : TAnalyzeResult;//�޲��޿�ѹǿ������
  aWcx_lmd        : TAnalyzeResult;//�޲��޿�ѹǿ��������
  
  ArrayAnalyzeResult: Array[0..AnalyzeCount-1] of TAnalyzeResult;  // ����Ҫ�μ�ͳ�Ƶ�TAnalyzeResult
  ArrayFieldNames: Array[0..AnalyzeCount-1] of String; // ����Ҫ�μ�ͳ�Ƶ��ֶ���,��ArrayAnalyzeResult������һһ��Ӧ

  //��ʼ���˹����еı���
  procedure InitVar;
  var 
    iCount: integer;
  begin
    ArrayAnalyzeResult[0]:= aAquiferous_rate;
    ArrayAnalyzeResult[1]:= aWet_density;
    ArrayAnalyzeResult[2]:= aDry_density;
    ArrayAnalyzeResult[3]:= aSoil_proportion;
    ArrayAnalyzeResult[4]:= aGap_rate;
    ArrayAnalyzeResult[5]:= aGap_degree;
    ArrayAnalyzeResult[6]:= aSaturation;
    ArrayAnalyzeResult[7]:= aLiquid_limit;
    ArrayAnalyzeResult[8]:= aShape_index;
    ArrayAnalyzeResult[9]:= aLiquid_index;
    ArrayAnalyzeResult[10]:= aZip_coef;
    ArrayAnalyzeResult[11]:= aZip_modulus;
    ArrayAnalyzeResult[12]:= aCohesion;
    ArrayAnalyzeResult[13]:= aFriction_angle;
//yys 20040610 modified 
    //ArrayAnalyzeResult[14]:= aWcx_yuanz;
    //ArrayAnalyzeResult[15]:= aWcx_chsu;
    //ArrayAnalyzeResult[16]:= aWcx_lmd;
    ArrayAnalyzeResult[14]:= aCohesion_gk;
    ArrayAnalyzeResult[15]:= aFriction_gk;
    ArrayAnalyzeResult[16]:= aWcx_yuanz;
    ArrayAnalyzeResult[17]:= aWcx_chsu;
    ArrayAnalyzeResult[18]:= aWcx_lmd;
//yys 20040610 modified 

    ArrayFieldNames[0]:= 'aquiferous_rate';
    ArrayFieldNames[1]:= 'wet_density';
    ArrayFieldNames[2]:= 'dry_density';
    ArrayFieldNames[3]:= 'soil_proportion';
    ArrayFieldNames[4]:= 'gap_rate';
    ArrayFieldNames[5]:= 'gap_degree';
    ArrayFieldNames[6]:= 'saturation';
    ArrayFieldNames[7]:= 'liquid_limit';
    ArrayFieldNames[8]:= 'shape_index';
    ArrayFieldNames[9]:= 'liquid_index';
    ArrayFieldNames[10]:= 'zip_coef';
    ArrayFieldNames[11]:= 'zip_modulus';
    ArrayFieldNames[12]:= 'cohesion';
    ArrayFieldNames[13]:= 'friction_angle'; 
//yys 20040610 modified
    //ArrayFieldNames[14]:= 'wcx_yuanz';
    //ArrayFieldNames[15]:= 'wcx_chsu';
    //ArrayFieldNames[16]:= 'wcx_lmd';      
    ArrayFieldNames[14]:= 'cohesion_gk';
    ArrayFieldNames[15]:= 'friction_gk';      
    ArrayFieldNames[16]:= 'wcx_yuanz';
    ArrayFieldNames[17]:= 'wcx_chsu';
    ArrayFieldNames[18]:= 'wcx_lmd';
//yys 20040610 modified    
    
    lstStratumNo:= TStringList.Create;
    lstSubNo:= TStringList.Create;
    lstBeginDepth:= TStringList.Create;
    lstEndDepth:= TStringList.Create;
    lstDrl_no:= TStringList.Create;
    lstS_no:= TStringList.Create;
    lstShear_type:= TStringList.Create;
    lstsand_big:= TStringList.Create;
    lstsand_middle:= TStringList.Create;
    lstsand_small:= TStringList.Create;
    lstPowder_big:= TStringList.Create;
    lstPowder_small:= TStringList.Create;
    lstClay_grain:= TStringList.Create;
    lstAsymmetry_coef:= TStringList.Create;
    lstCurvature_coef:= TStringList.Create;
    lstEa_name:= TStringList.Create;
    
    for iCount:=0 to AnalyzeCount-1 do
      ArrayAnalyzeResult[iCount].lstValues := TStringList.Create;
      
    aAquiferous_rate.FormatString := '0.0';
    aWet_density.FormatString := '0.00';
    aDry_density.FormatString := '0.00';
    aSoil_proportion.FormatString := '0.00';
    aGap_rate.FormatString := '0.000';
    aGap_degree.FormatString := '0';
    aSaturation.FormatString := '0';
    aLiquid_limit.FormatString := '0.0';
    aShape_limit.FormatString := '0.0';
    aShape_index.FormatString := '0.0';
    aLiquid_index.FormatString := '0.00';
    aZip_coef.FormatString := '0.000';
    aZip_modulus.FormatString := '0.00';
    aCohesion.FormatString := '0.0';
    aFriction_angle.FormatString := '0.0';
//yys 20040610 modified 
    aCohesion_gk.FormatString := '0.0';
    aFriction_gk.FormatString := '0.0';
//yys 20040610 modified 
    aWcx_yuanz.FormatString := '0.0';
    aWcx_chsu.FormatString := '0.0';
    aWcx_lmd.FormatString := '0.0';
  end;
  
  //�ͷŴ˹����еı���
  procedure FreeStringList;
  var
    iCount: integer;
  begin
    lstStratumNo.Free;
    lstSubNo.Free;
    lstBeginDepth.Free;
    lstEndDepth.Free;
    lstDrl_no.Free;
    lstS_no.Free;
    lstShear_type.Free;
    lstsand_big.Free;
    lstsand_middle.Free;
    lstsand_small.Free;
    lstPowder_big.Free;
    lstPowder_small.Free;
    lstClay_grain.Free;
    lstAsymmetry_coef.Free;
    lstCurvature_coef.Free;
    lstEa_name.Free;
    
    for iCount:=0 to AnalyzeCount-1 do
      ArrayAnalyzeResult[iCount].lstValues.Free;
  end;

begin
  try
    Screen.Cursor := crHourGlass;
    SetTuYangCengHao;
    //��ʼ�����ʱͳ�Ʊ�ĵ�ǰ��������
    //strSQL:= 'TRUNCATE TABLE stratumTmp; TRUNCATE TABLE TeZhengShuTmp; TRUNCATE TABLE earthsampleTmp; TRUNCATE TABLE YangBenZhiTmp ';
    strSQL:= 'DELETE FROM stratumTmp WHERE prj_no = '+''''+stringReplace(g_ProjectInfo.prj_no ,'''','''''',[rfReplaceAll])+''''+';'
            +'DELETE FROM TeZhengShuTmp WHERE prj_no = '+''''+stringReplace(g_ProjectInfo.prj_no ,'''','''''',[rfReplaceAll])+''''+';'
            +'DELETE FROM earthsampleTmp WHERE prj_no = '+''''+stringReplace(g_ProjectInfo.prj_no ,'''','''''',[rfReplaceAll])+'''';
    if not Delete_oneRecord(MainDataModule.qrySectionTotal, strSQL) then 
    begin
      exit;
    end;
  
    InitVar;
    GetAllStratumNo(lstStratumNo, lstSubNo, lstEa_name);
    if lstStratumNo.Count = 0 then 
    begin
      FreeStringList;
      exit;
    end;

    {//����ź��ǲ�ź��������Ʋ�����ʱ����
    for i:=0 to lstStratumNo.Count-1 do
    begin
      strSQL:='INSERT INTO stratumTmp (prj_no,stra_no,sub_no,ea_name) VALUES('
        +''''+stringReplace(g_ProjectInfo.prj_no ,'''','''''',[rfReplaceAll])+''''+','
        +''''+lstStratumNo.Strings[i]+'''' +','
        +''''+lstSubNo.Strings[i]+''''+','
        +''''+lstEa_name.Strings[i]+''''+')';
      Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL);   
    end;}
    strPrjNo := stringReplace(g_ProjectInfo.prj_no ,'''','''''',[rfReplaceAll]);
    for i:=0 to lstStratumNo.Count-1 do
    begin
      strSubNo := stringReplace(lstSubNo.Strings[i],'''','''''',[rfReplaceAll]);
      strStratumNo := lstStratumNo.Strings[i];
      strSQL:='SELECT * FROM earthsample ' 
          +' WHERE prj_no='+''''+strPrjNo+''''
          +' AND stra_no='+''''+strStratumNo+''''
          +' AND sub_no='+''''+strSubNo+''''
          +' AND if_statistic=1';
      iRecordCount := 0;
      lstBeginDepth.Clear;
      lstEndDepth.Clear;
      lstDrl_no.Clear;
      lstS_no.Clear;
      lstShear_type.Clear;
      lstsand_big.Clear;
      lstsand_middle.Clear;
      lstsand_small.Clear;
      lstPowder_big.Clear;
      lstPowder_small.Clear;
      lstClay_grain.Clear;
      lstAsymmetry_coef.Clear;
      lstCurvature_coef.Clear;
      lstEa_name.Clear;
    
      for j:=0 to AnalyzeCount-1 do
        ArrayAnalyzeResult[j].lstValues.Clear;            
          
      with MainDataModule.qryEarthSample do
        begin
          close;
          sql.Clear;
          sql.Add(strSQL);
          open;
          while not eof do
            begin
              inc(iRecordCount);
              lstDrl_no.Add(FieldByName('drl_no').AsString);
              lstS_no.Add(FieldByName('s_no').AsString);            
              lstBeginDepth.Add(FieldByName('s_depth_begin').AsString);
              lstEndDepth.Add(FieldByName('s_depth_end').AsString); 
              lstShear_type.Add(FieldByName('shear_type').AsString);
              lstsand_big.Add(FieldByName('sand_big').AsString);
              lstsand_middle.Add(FieldByName('sand_middle').AsString);
              lstsand_small.Add(FieldByName('sand_small').AsString);
              lstPowder_big.Add(FieldByName('powder_big').AsString);
              lstPowder_small.Add(FieldByName('powder_small').AsString);
              lstClay_grain.Add(FieldByName('clay_grain').AsString);
              lstAsymmetry_coef.Add(FieldByName('asymmetry_coef').AsString);
              lstCurvature_coef.Add(FieldByName('curvature_coef').AsString);
              lstEa_name.Add(FieldByName('ea_name').AsString);
            
              for j:=0 to AnalyzeCount-1 do
                ArrayAnalyzeResult[j].lstValues.Add(FieldByName(ArrayFieldNames[j]).AsString);            
              next; 
            end;
          close;
        end;
      if iRecordCount=0 then //���û��������Ϣ��������ֵ����������
      begin                  //����Ϊ���Ժ�����������TeZhengShuTmp���뾲����̽�ͱ������ʱ��ֻ��UPDATE���Ϳ�����
        for j:= 1 to 6 do
        begin 
          strSQL:='INSERT INTO TeZhengShuTmp (prj_no, stra_no, sub_no, v_id) '
            +'VALUES ('+''''+strPrjNo+''''+','
            +''''+strStratumNo+'''' +','
            +''''+strSubNo+''''+','''+InttoStr(j)+''')';
          Insert_oneRecord(MainDataModule.qryPublic, strSQL);
        end;
        continue;
      end;
     

      //ȡ��������
      for j:=0 to AnalyzeCount-1 do
        getTeZhengShu(ArrayAnalyzeResult[j]);
//      for j:=0 to ArrayAnalyzeResult[15].lstValues.count-1 do
//         caption:= caption + ArrayAnalyzeResult[15].lstValues[j]; 

    {******��ƽ��ֵ����׼�����ϵ�������ֵ��**********}
    {******��Сֵ������ֵ�Ȳ�����������TeZhengShuTmp ****}
      //��ʼȡ��Ҫ������ֶ����ơ�
      strFieldNames:= '';
      for j:=0 to AnalyzeCount-1 do
        strFieldNames:= strFieldNames + ArrayFieldNames[j] + ',';
      strFieldNames:= strFieldNames + 'prj_no, stra_no, sub_no, v_id';

      //��ʼ����ƽ��ֵ
      strFieldValues:= '';
      strSQL:= '';
      for j:=0 to AnalyzeCount-1 do
        strFieldValues:= strFieldValues +FloatToStr(ArrayAnalyzeResult[j].PingJunZhi)+',';
      strFieldValues:= strFieldValues 
        +''''+strPrjNo+''''+','
        +''''+strStratumNo+'''' +','
        +''''+strSubNo+''''+','+'1';
      strSQL:='INSERT INTO TeZhengShuTmp (' + strFieldNames + ')'
        +'VALUES('+strFieldValues+')';
      if not Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL) then 
        continue;
      
      //��ʼ�����׼��
      strFieldValues:= '';
      strSQL:= '';
      for j:=0 to AnalyzeCount-1 do
        strFieldValues:= strFieldValues +FloatToStr(ArrayAnalyzeResult[j].BiaoZhunCha)+',';
      strFieldValues:= strFieldValues 
        +''''+strPrjNo+''''+','
        +''''+strStratumNo+'''' +','
        +''''+strSubNo+''''+','+'2';
      strSQL:='INSERT INTO TeZhengShuTmp (' + strFieldNames + ')'
        +'VALUES('+strFieldValues+')';
      if not Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL) then 
        continue;
      
      //��ʼ�������ϵ��
      strFieldValues:= '';
      strSQL:= '';
      for j:=0 to AnalyzeCount-1 do
        strFieldValues:= strFieldValues +FloatToStr(ArrayAnalyzeResult[j].BianYiXiShu)+',';
      strFieldValues:= strFieldValues 
        +''''+strPrjNo+''''+','
        +''''+strStratumNo+'''' +','
        +''''+strSubNo+''''+','+'3';
      strSQL:='INSERT INTO TeZhengShuTmp (' + strFieldNames + ')'
        +'VALUES('+strFieldValues+')';
      if not Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL) then 
        continue;
      
      //��ʼ�������ֵ
      strFieldValues:= '';
      strSQL:= '';
      for j:=0 to AnalyzeCount-1 do
        strFieldValues:= strFieldValues +FloatToStr(ArrayAnalyzeResult[j].MaxValue)+',';
      strFieldValues:= strFieldValues 
        +''''+strPrjNo+''''+','
        +''''+strStratumNo+'''' +','
        +''''+strSubNo+''''+','+'4';
      strSQL:='INSERT INTO TeZhengShuTmp (' + strFieldNames + ')'
        +'VALUES('+strFieldValues+')';
      if not Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL) then 
        continue;
      
      //��ʼ������Сֵ
      strFieldValues:= '';
      strSQL:= '';
      for j:=0 to AnalyzeCount-1 do
        strFieldValues:= strFieldValues +FloatToStr(ArrayAnalyzeResult[j].MinValue)+',';
      strFieldValues:= strFieldValues 
        +''''+strPrjNo+''''+','
        +''''+strStratumNo+'''' +','
        +''''+strSubNo+''''+','+'5';
      strSQL:='INSERT INTO TeZhengShuTmp (' + strFieldNames + ')'
        +'VALUES('+strFieldValues+')';
      if not Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL) then 
        continue;
      
      //��ʼ��������ֵ
      strFieldValues:= '';
      strSQL:= '';
      for j:=0 to AnalyzeCount-1 do
        strFieldValues:= strFieldValues +FloatToStr(ArrayAnalyzeResult[j].SampleNum)+',';
      strFieldValues:= strFieldValues 
        +''''+strPrjNo+''''+','
        +''''+strStratumNo+'''' +','
        +''''+strSubNo+''''+','+'6';
      strSQL:='INSERT INTO TeZhengShuTmp (' + strFieldNames + ')'
        +'VALUES('+strFieldValues+')';
      if not Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL) then 
        continue;
                  
      {********�Ѿ�����������ֵ������ʱ������**********}
      for j:=0 to iRecordCount-1 do
      begin
        strFieldNames:= '';
        strFieldValues:= '';
        strSQL:= '';
        strFieldNames:='drl_no, s_no, s_depth_begin, s_depth_end,'
          +'shear_type, sand_big, sand_middle, sand_small, powder_big,'
          +'powder_small, clay_grain, asymmetry_coef, curvature_coef,ea_name,';
        if lstDrl_no.Strings[j]='' then continue;
        strFieldNames:= 'drl_no';
        strFieldValues:= strFieldValues +'''' + lstDrl_no.Strings[j] +'''';

        if lstS_no.Strings[j]='' then continue;
        strFieldNames:= strFieldNames + ',s_no';
        strFieldValues:= strFieldValues +','+'''' + lstS_no.Strings[j] +''''; 

        if lstBeginDepth.Strings[j]<>'' then
        begin
          strFieldNames:= strFieldNames + ',s_depth_begin';
          strFieldValues:= strFieldValues +','+'''' + lstBeginDepth.Strings[j] +'''' ;
        end;

        if lstEndDepth.Strings[j]<>'' then
        begin
          strFieldNames:= strFieldNames + ',s_depth_end';
          strFieldValues:= strFieldValues +','+'''' + lstEndDepth.Strings[j] +'''' ;
        end;
//yys 20040610 modified        
        //if lstShear_type.Strings[j]<>'' then
        //  strFieldValues:= strFieldValues +'''' + lstShear_type.Strings[j] +'''' +','
        //else
        //  strFieldValues:= strFieldValues + 'NULL' +',';
//yys 20040610 modified        
        if lstsand_big.Strings[j]<>'' then
        begin
          strFieldNames:= strFieldNames + ',sand_big';
          strFieldValues:= strFieldValues +','+'''' + lstsand_big.Strings[j] +'''';
        end;
        
        if lstsand_middle.Strings[j]<>'' then
        begin
          strFieldNames:= strFieldNames + ',sand_middle';
          strFieldValues:= strFieldValues +','+'''' + lstsand_middle.Strings[j] +'''';
        end;
        if lstsand_small.Strings[j]<>'' then
        begin
          strFieldNames:= strFieldNames + ',sand_small';
          strFieldValues:= strFieldValues +','+'''' + lstsand_small.Strings[j] +'''' ;
        end;

        if lstPowder_big.Strings[j]<>'' then
        begin
          strFieldNames:= strFieldNames + ',Powder_big';
          strFieldValues:= strFieldValues +','+'''' + lstPowder_big.Strings[j] +'''' ;
        end;

        if lstPowder_small.Strings[j]<>'' then
        begin
          strFieldNames:= strFieldNames + ',Powder_small';
          strFieldValues:= strFieldValues +','+'''' + lstPowder_small.Strings[j] +'''' ;
        end;
        if lstClay_grain.Strings[j]<>'' then
        begin
          strFieldNames:= strFieldNames + ',Clay_grain';
          strFieldValues:= strFieldValues +','+''''  + lstClay_grain.Strings[j] +'''';
        end;
               
        if lstAsymmetry_coef.Strings[j]<>'' then
        begin
          strFieldNames:= strFieldNames + ',Asymmetry_coef';
          strFieldValues:= strFieldValues  +','+'''' + lstAsymmetry_coef.Strings[j] +'''';
        end;

        if lstCurvature_coef.Strings[j]<>'' then
        begin
          strFieldNames:= strFieldNames + ',Curvature_coef';
          strFieldValues:= strFieldValues +','+'''' + lstCurvature_coef.Strings[j] +'''' ;
        end;

        if lstEa_name.Strings[j]<>'' then
        begin
          strFieldNames:= strFieldNames + ',Ea_name';
          strFieldValues:= strFieldValues  +','+'''' + lstEa_name.Strings[j] +'''';
        end;
                                                                              
        for iCol:=0 to AnalyzeCount-1 do
        begin
          strTmp := ArrayAnalyzeResult[iCol].lstValues.Strings[j];
          if strTmp <> '' then 
          begin
            strFieldNames:= strFieldNames + ','+ ArrayFieldNames[iCol] ;
            strFieldValues:= strFieldValues +','+ strTmp ;
          end;
        end;
        strFieldNames:= strFieldNames + ',prj_no, stra_no, sub_no';
        strFieldValues:= strFieldValues +','+''''
          +strPrjNo+''''+','
          +''''+strStratumNo+'''' +','
          +''''+strSubNo+'''';

        strSQL:='INSERT INTO earthsampleTmp (' + strFieldNames + ')'
          +'VALUES('+strFieldValues+')';
        if Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL) then 
        else;
      
      end;
       
    end;  // end of for i:=0 to lstStratumNo.Count-1 do
  finally
    FreeStringList;
    screen.Cursor := crDefault;
  end;
end;

procedure TSectionTotalForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TSectionTotalForm.frxReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
  if ParName='prj_name' then
    ParValue:= g_ProjectInfo.prj_name;

end;


procedure TSectionTotalForm.FormCreate(Sender: TObject);
begin
  self.Left := trunc((screen.Width -self.Width)/2);
  self.Top  := trunc((Screen.Height - self.Height)/2);
end;

//�������ֲ�
procedure TSectionTotalForm.SetTuYangCengHao;
var
  iDrillCount,iStratumCount:integer;
  strSQL: string;
  lstDrillsNo,lstStratumNo,lstSubNo,
  lstStratumDepth,lstStratumBottDepth:TStringList;
  procedure GetDrillNo(var AStingList: TStringList);
  begin
    AStingList.Clear;
    with MainDataModule.qryDrills do
      begin
        close;
        sql.Clear;
        //sql.Add('select prj_no,prj_name,area_name,builder,begin_date,end_date,consigner from projects');
        sql.Add('SELECT prj_no,drl_no FROM drills ');
        sql.Add(' WHERE prj_no='+''''+stringReplace(g_ProjectInfo.prj_no ,'''','''''',[rfReplaceAll])+'''');
        open;
        while not Eof do
          begin
            AStingList.Add(FieldByName('drl_no').AsString);
            Next ;
          end;
        close;
      end;    
  end;
  procedure GetStramDepth(const aDrillNo: string;
   var AStratumNoList, ASubNoList, ABottList: TStringList);
  begin
    AStratumNoList.Clear;
    ASubNoList.Clear;
    ABottList.Clear;
    strSQL:='SELECT drl_no,stra_no,sub_no,stra_depth '
      +' FROM stratum '
      +' WHERE prj_no='+''''+stringReplace(g_ProjectInfo.prj_no ,'''','''''',[rfReplaceAll])+''''
      +' AND drl_no='+''''+aDrillNo+''''
      +' ORDER BY stra_depth';
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
            ABottList.Add(FieldByName('stra_depth').AsString);
            next; 
          end;
        close;
      end;
  end;
  procedure FreeStringList;
  begin
    lstDrillsNo.Free;;
    lstStratumNo.Free;
    lstSubNo.Free;
    lstStratumDepth.Free;
    lstStratumBottDepth.Free;
  end;
begin
  lstDrillsNo := TStringList.Create;
  lstStratumNo:= TStringList.Create;
  lstSubNo:= TStringList.Create;
  lstStratumDepth:= TStringList.Create;
  lstStratumBottDepth:= TStringList.Create;  
  GetDrillNo(lstDrillsNo);
  if lstDrillsNo.Count =0 then 
  begin
    FreeStringList;
    exit;
  end;

  try
    //������������������Ĳ���ǲ����Ϣ    
    strSQL:= 'UPDATE earthsample set stra_no=null,sub_no=0 '
      +' WHERE prj_no='+''''+stringReplace(g_ProjectInfo.prj_no ,'''','''''',[rfReplaceAll])+'''';
      with MainDataModule.qryEarthSample do
      begin
        close;
        sql.Clear;
        sql.Add(strSQL);
        ExecSQL;  
        close; 
      end;
    //��ʼ���������ֲ㣬�������������׵���һ�㣬���Ĳ�ž�����һ��.  
    for iDrillCount:= 0 to lstDrillsNo.Count-1 do
      begin
        GetStramDepth(lstDrillsNo.Strings[iDrillCount],
          lstStratumNo, lstSubNo, lstStratumBottDepth);
        if lstStratumNo.Count =0 then continue;

        for iStratumCount:=0 to lstStratumNo.Count -1 do
        begin
          if iStratumCount=0 then
            strSQL:='UPDATE earthsample Set '
              +'stra_no='+''''+lstStratumNo.Strings[iStratumCount]+''''+','
              +'sub_no='+''''+stringReplace(lstSubNo.Strings[iStratumCount],'''','''''',[rfReplaceAll])+''''
              +' WHERE prj_no='+''''+stringReplace(g_ProjectInfo.prj_no ,'''','''''',[rfReplaceAll])+''''
              +' AND drl_no ='+''''+lstDrillsNo.Strings[iDrillCount]+''''
              +' AND s_depth_begin>=0 ' 
              +' AND s_depth_begin<'+lstStratumBottDepth.Strings[iStratumCount]
          else
            strSQL:='UPDATE earthsample Set '
              +'stra_no='+''''+lstStratumNo.Strings[iStratumCount]+''''+','
              +'sub_no='+''''+stringReplace(lstSubNo.Strings[iStratumCount],'''','''''',[rfReplaceAll])+''''
              +' WHERE prj_no='+''''+stringReplace(g_ProjectInfo.prj_no ,'''','''''',[rfReplaceAll])+''''
              +' AND drl_no ='+''''+lstDrillsNo.Strings[iDrillCount]+''''
              +' AND s_depth_begin>=' + lstStratumBottDepth.Strings[iStratumCount-1]
              +' AND s_depth_begin<'+lstStratumBottDepth.Strings[iStratumCount];          
          with MainDataModule.qryEarthSample do
          begin
            close;
            sql.Clear;
            sql.Add(strSQL);
            ExecSQL;
            close;   
          end;
        end;
      end;
    finally
      FreeStringList;
    end;
end;


procedure TSectionTotalForm.btn_PrintClick(Sender: TObject);
var
  strSQL: string;
begin
  strSQL:='SELECT id,prj_no,stra_no,sub_no,ea_name FROM stratum_description' 
      +' WHERE prj_no='+''''+stringReplace(g_ProjectInfo.prj_no ,'''','''''',[rfReplaceAll])+''''
      +' ORDER BY id';
  with qryStratum do
    begin
      close;
      sql.Clear;
      sql.Add(strSQL);
      open;
    end;

  self.tblSampleValue.TableName :='earthsampleTmp';
  tblSampleValue.MasterFields := 'prj_no;stra_no;sub_no';
  self.tblSampleValue.Open;
  self.tblTeZhengShu.TableName :='tezhengshuTmp';
  tblTeZhengShu.MasterFields := 'prj_no;stra_no;sub_no';
  self.tblTeZhengShu.Open;
  frxReport1.LoadFromFile(g_AppInfo.PathOfReports + 'TuFenXiFenCengZongBiao.frf');
  frxReport1.Preview := PreviewForm.frxPreview1;
  if frxReport1.PrepareReport then
  begin
    frxReport1.ShowPreparedReport;
    PreviewForm.ShowModal;
  end;
  
  self.qryStratum.Close;
  self.tblSampleValue.Close;
  self.tblTeZhengShu.Close;

end;

procedure TSectionTotalForm.frxReport1BeginBand(Band: TfrBand);
begin
    if Band.Name = 'ϸ���1' then
       m_bPrintRoot := false;
    if Band.Name ='ҳ��1' then
        Band.Visible := m_bPrintRoot;
        
end;

procedure TSectionTotalForm.frxReport1EndBand(Band: TfrBand);
begin
      if Band.Name ='ҳ��1' then
        m_bPrintRoot := true;
end;

end.
