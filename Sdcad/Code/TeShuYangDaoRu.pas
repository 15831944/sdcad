unit TeShuYangDaoRu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ExtCtrls, Buttons, ComObj;

type
  TTeShuYangDaoRuForm = class(TForm)
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
    sgResult: TStringGrid;
    procedure btnFileOpenClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TeShuYangDaoRuForm: TTeShuYangDaoRuForm;

implementation

uses MainDM, public_unit;

{$R *.dfm}

procedure TTeShuYangDaoRuForm.btnFileOpenClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    edtFileName.Text := OpenDialog1.FileName;

    if edtFileName.Text<>'' then
    begin
      btnLoad.Enabled := true;
      btnLoad.SetFocus;
    end;
  end;
end;

procedure TTeShuYangDaoRuForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= CaFree;
end;

procedure TTeShuYangDaoRuForm.FormCreate(Sender: TObject);
begin
   self.Left := trunc((screen.Width -self.Width)/2);
   self.Top  := trunc((Screen.Height - self.Height)/2);
   sgResult.FixedCols := 3;

   sgResult.ColCount :=50;
   sgResult.ColWidths[0]:= 30;
   sgResult.Cells[0,0]:= '���';
   sgResult.Cells[1,0]:= '��׺�';
   sgResult.ColWidths[1]:= 120;
   sgResult.Cells[2,0]:= '�������';
   sgResult.Cells[3,0]:= 'ȡ�����ʼ';
   sgResult.Cells[4,0]:= 'ȡ�����ֹ';
   sgResult.Cells[5,0]:= '���ڹ̽�ѹ��';
   sgResult.Cells[6,0]:= 'ѹ��ָ��';
   sgResult.Cells[7,0]:= '�ص�ָ��';
   sgResult.Cells[8,0]:= '�ص�ģ��';
   sgResult.Cells[9,0]:= '�̽�ϵ��50';
   sgResult.Cells[10,0]:= '�̽�ϵ��100';
   sgResult.Cells[11,0]:= '�̽�ϵ��200';
   sgResult.Cells[12,0]:= '�̽�ϵ��400';
   sgResult.Cells[13,0]:= '�̽�ϵ��50';
   sgResult.Cells[14,0]:= '�̽�ϵ��100';
   sgResult.Cells[15,0]:= '�̽�ϵ��200';
   sgResult.Cells[16,0]:= '�̽�ϵ��400';
   sgResult.Cells[17,0]:= '����ϵ������ֱ��0.05��0.1';
   sgResult.Cells[18,0]:= '����ϵ������ֱ��0.1��0.2';
   sgResult.Cells[19,0]:= '����ϵ������ֱ��0.05��0.1';
   sgResult.Cells[20,0]:= '����ϵ����ˮƽ��0.05��0.1';
   sgResult.Cells[21,0]:= '����ϵ����ˮƽ��0.1��0.2';
   sgResult.Cells[22,0]:= '����ϵ����ˮƽ��0.2��0.4';

   sgResult.Cells[23,0]:= '��ֹ��ѹ��ϵ��';
   sgResult.Cells[24,0]:= 'ԭ״';
   sgResult.Cells[25,0]:= '����';
   sgResult.Cells[26,0]:= '������';
   sgResult.Cells[27,0]:= '���鷽��';
   sgResult.Cells[28,0]:= '��Ӧ��ճ����';
   sgResult.Cells[29,0]:= '��Ӧ����Ħ����';
   sgResult.Cells[30,0]:= '��ЧӦ��ճ����';
   sgResult.Cells[31,0]:= '��ЧӦ����Ħ����';

   sgResult.Cells[32,0]:= '��͸ϵ��Kv';
   sgResult.Cells[33,0]:= '��͸ϵ��KH';

   sgResult.Cells[34,0]:= '��Ȼ�½Ǹ�';
   sgResult.Cells[35,0]:= '��Ȼ�½�ˮ��';
   sgResult.Cells[36,0]:= '����>2';
   sgResult.Cells[37,0]:= '����2��0.5';
   sgResult.Cells[38,0]:= '����0.5��0.25';
   sgResult.Cells[39,0]:= '����0.25��0.075';
   sgResult.Cells[40,0]:= '����0.075��0.005';
   sgResult.Cells[41,0]:= '����<0.005';
   sgResult.Cells[42,0]:= 'D10';
   sgResult.Cells[43,0]:= 'D50';
   sgResult.Cells[44,0]:= 'D60';
   sgResult.Cells[45,0]:= 'D70';
   sgResult.Cells[46,0]:= '������ϵ��';
   sgResult.Cells[47,0]:= '����ϵ��';
   sgResult.Cells[48,0]:= '��ע';
   setLabelsTransparent(self);
end;

procedure TTeShuYangDaoRuForm.btnCancelClick(Sender: TObject);
begin
  self.Close;
end;

procedure TTeShuYangDaoRuForm.btnLoadClick(Sender: TObject);
  type T_LeftRight = record
      LelfStr : string;  //��ߵ��ַ���
      RightStr   : string;  //�ұߵ��ַ���
  end;
var
  ExcelApp: Variant;
  Sheet: Variant;
  SFileName, strSQL, strTemp:string;
  strDrillNo_S_No, strShenDu,strDrillNo:string;
  pTmpBianHao, pTmpShenDu : T_LeftRight;
  J, iMsg, i:integer;
  lstTmp, lstSample : TStringList;

  //���ַ�����ȡ����ױ�ź�������� str='JZ-31--29' ������ױ�� JZ-31��������� 29
  //                             ���str='146-13'    ������ױ�� 146  ��������� 13
  procedure GetLeftRightStr(str,separate:string;var pBianHao: T_LeftRight);
  var
    position:integer;
  begin
      position:=PosRightEx(separate,str);
      if position=0 then position:=length(str)+1;
      pBianHao.LelfStr  := copy(str,1,position-1);
      pBianHao.RightStr := copy(str,position+length(separate),length(str)+1);
  end;
  function GetValueFromCell(pCellValue: Variant):Variant;
  begin
    if Trim(VarToStr(pCellValue))<>'' then
      Result := pCellValue
    else
      Result := null;
  end;

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
      strSQL:= 'DELETE FROM TeShuYang '
        +' WHERE prj_no=' +''''
        +g_ProjectInfo.prj_no_ForSQL +'''';
      Delete_oneRecord(MainDataModule.qryEarthSample,strSQL);
    end;
    TRY
      ExcelApp := GetActiveOleObject('Excel.Application');
    except
      ExcelApp := CreateOleObject( 'Excel.Application' );
    end;
    SFileName := edtFileName.Text;
    ExcelApp.WorkBooks.Open(SFileName);
    Sheet := ExcelApp.WorkBooks[ExcelApp.WorkBooks.Count].WorkSheets[1];

    with MainDataModule.qryEarthSample do
    begin
      if Active then Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM TeShuYang WHERE prj_no='+''''+g_ProjectInfo.prj_no_ForSQL +'''');
      Open;

      J:=9;  //�ӵ�9�п�ʼ//���������Ϊ�գ������

      strDrillNo := '';
      iMsg := IDCANCEL;//ÿ����׶�Ҫ���û�ѡ���ǲ���Ҫ���������׵���������
      while (Sheet.Cells[J,2].text<>'') and (sheet.Cells[J,3].text<>'') DO
      BEGIN

        strDrillNo_S_No := Sheet.Cells[J,2].Value;
        if Pos('--',strDrillNo_S_No)>1 then
          GetLeftRightStr(strDrillNo_S_No,'--',PTmpBianHao)
        else
          GetLeftRightStr(strDrillNo_S_No,'-',PTmpBianHao);
        //ÿ����һ������׺ţ�����ʾ�û�ѡ��ʱ�û�ѡ���Ƿ��������׵�����������ѡ���˷񣬻����ǵ�һ�γ������
        if strDrillNo<>pTmpBianHao.LelfStr then 
        begin
          strDrillNo := pTmpBianHao.LelfStr;
          iMsg := messagebox(self.Handle ,PAnsiChar('��Ҫ�������'+ strDrillNo+'������������'),'��ʾ��Ϣ',MB_YESNO);

          if iMsg=IDNO then
          begin
            J := J + 1;
            Continue;
          end;

        end
        else if iMsg = IDNO then
          begin
            J := J + 1;
            Continue;
          end;


        Append;
        FieldByName('prj_no').Value := stringReplace(g_ProjectInfo.prj_no ,'''','''''',[rfReplaceAll]);


        FieldByName('drl_no').Value := PTmpBianHao.LelfStr;
        FieldByName('s_no').Value := PTmpBianHao.RightStr;

        GetLeftRightStr(Sheet.Cells[J,3].Value, '-', pTmpShenDu);
        FieldByName('s_depth_begin').Value := pTmpShenDu.LelfStr;
        FieldByName('s_depth_end').Value := pTmpShenDu.RightStr;

        FieldByName('gygj_pc').Value := GetValueFromCell(Sheet.Cells[J,4].Value);
        FieldByName('gygj_cc').Value := GetValueFromCell(Sheet.Cells[J,5].Value);
        FieldByName('gygj_cs').Value := GetValueFromCell(Sheet.Cells[J,6].Value);

        FieldByName('html').Value := GetValueFromCell(Sheet.Cells[J,7].Value);

        FieldByName('gjxs50_1').Value := GetValueFromCell(Sheet.Cells[J,8].Value);
        FieldByName('gjxs100_1').Value := GetValueFromCell(Sheet.Cells[J,9].Value);
        FieldByName('gjxs200_1').Value := GetValueFromCell(Sheet.Cells[J,10].Value);
        FieldByName('gjxs400_1').Value := GetValueFromCell(Sheet.Cells[J,11].Value);
        FieldByName('gjxs50_2').Value := GetValueFromCell(Sheet.Cells[J,12].Value);
        FieldByName('gjxs100_2').Value := GetValueFromCell(Sheet.Cells[J,13].Value);
        FieldByName('gjxs200_2').Value := GetValueFromCell(Sheet.Cells[J,14].Value);
        FieldByName('gjxs400_2').Value := GetValueFromCell(Sheet.Cells[J,15].Value);

        FieldByName('jcxs_v_005_01').Value := GetValueFromCell(Sheet.Cells[J,16].Value);
        FieldByName('jcxs_v_01_02').Value := GetValueFromCell(Sheet.Cells[J,17].Value);
        FieldByName('jcxs_v_02_04').Value := GetValueFromCell(Sheet.Cells[J,18].Value);
        FieldByName('jcxs_h_005_01').Value := GetValueFromCell(Sheet.Cells[J,19].Value);
        FieldByName('jcxs_h_01_02').Value := GetValueFromCell(Sheet.Cells[J,20].Value);
        FieldByName('jcxs_h_02_04').Value := GetValueFromCell(Sheet.Cells[J,21].Value);
        FieldByName('jzcylxs').Value := GetValueFromCell(Sheet.Cells[J,22].Value);
        FieldByName('wcxkyqd_yz').Value := GetValueFromCell(Sheet.Cells[J,23].Value);
        FieldByName('wcxkyqd_cs').Value := GetValueFromCell(Sheet.Cells[J,24].Value);
        FieldByName('wcxkyqd_lmd').Value := GetValueFromCell(Sheet.Cells[J,25].Value);
        FieldByName('szsy_syff').Value := GetValueFromCell(Sheet.Cells[J,26].Value);
        if FieldByName('szsy_syff').AsString ='UU' then
        begin
          FieldByName('szsy_zyl_njl_uu').Value := GetValueFromCell(Sheet.Cells[J,27].Value);
          FieldByName('szsy_zyl_nmcj_uu').Value := GetValueFromCell(Sheet.Cells[J,28].Value);
        end
        else
        begin
          FieldByName('szsy_zyl_njl_cu').Value := GetValueFromCell(Sheet.Cells[J,27].Value);
          FieldByName('szsy_zyl_nmcj_cu').Value := GetValueFromCell(Sheet.Cells[J,28].Value);
        end;
        FieldByName('szsy_yxyl_njl').Value := GetValueFromCell(Sheet.Cells[J,29].Value);
        FieldByName('szsy_yxyl_nmcj').Value := GetValueFromCell(Sheet.Cells[J,30].Value);

          //Caption := FormatFloat('0.00000000',strtofloat('3.2E-7'));
          //Caption := FloatToStrF(strtofloat('3.2E-7'),ffNumber,18,8); //��ѧ��������EXCEL��XLS�ļ��ж�������
        if Trim(VarToStr(Sheet.Cells[J,31].Value))<>'' then
        begin
          strTemp := Trim(VarToStr(Sheet.Cells[J,31].Value));
          FieldByName('stxs_kv').Value := StrToFloat(strTemp)
        end
        else
          FieldByName('stxs_kv').Value := null;

        if Trim(VarToStr(Sheet.Cells[J,32].Value))<>'' then
        begin
          strTemp := Trim(VarToStr(Sheet.Cells[J,32].Value));
          FieldByName('stxs_kh').Value := StrToFloat(strTemp)
        end
        else
          FieldByName('stxs_kh').Value := null;
        //FieldByName('stxs_kv').Value := GetValueFromCell(Sheet.Cells[J,31].Value);
        //FieldByName('stxs_kh').Value := GetValueFromCell(Sheet.Cells[J,32].Value);
        FieldByName('trpj_g').Value := GetValueFromCell(Sheet.Cells[J,33].Value);
        FieldByName('trpj_sx').Value := GetValueFromCell(Sheet.Cells[J,34].Value);
        FieldByName('klzc_li').Value := GetValueFromCell(Sheet.Cells[J,35].Value);
        FieldByName('klzc_sha_2_05').Value := GetValueFromCell(Sheet.Cells[J,36].Value);
        FieldByName('klzc_sha_05_025').Value := GetValueFromCell(Sheet.Cells[J,37].Value);
        FieldByName('klzc_sha_025_0075').Value := GetValueFromCell(Sheet.Cells[J,38].Value);
        FieldByName('klzc_fl').Value := GetValueFromCell(Sheet.Cells[J,39].Value);
        FieldByName('klzc_nl').Value := GetValueFromCell(Sheet.Cells[J,40].Value);
        FieldByName('lj_yxlj').Value := GetValueFromCell(Sheet.Cells[J,41].Value);
        FieldByName('lj_pjlj').Value := GetValueFromCell(Sheet.Cells[J,42].Value);
        FieldByName('lj_xzlj').Value := GetValueFromCell(Sheet.Cells[J,43].Value);
        FieldByName('lj_d70').Value := GetValueFromCell(Sheet.Cells[J,44].Value);
        FieldByName('bjyxs').Value := GetValueFromCell(Sheet.Cells[J,45].Value);
        FieldByName('qlxs').Value := GetValueFromCell(Sheet.Cells[J,46].Value);
        FieldByName('beizhu').Value := GetValueFromCell(Sheet.Cells[J,47].Value);

        FieldByName('if_statistic').Value := 1;//Ĭ�ϲ���ͳ��1
        sgResult.Cells[0,j-8] := IntToStr(j-8);
        for i:=1 to Fields.Count -5 do
          sgResult.Cells[i,j-8] := VarToStr(FieldValues[Fields[i].FieldName]);
        sgResult.RowCount := sgResult.RowCount + 1;
        J := J + 1;
      end;
      UpdateBatch();
    end;

  finally
    ExcelApp.Quit;
    ExcelApp := Unassigned;
    screen.Cursor := crDefault;
  end;
end;

end.
