unit TuYangDaoRuXLS_GuJie;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, ExtCtrls, ComObj;

type
  TTuYangDaoRuXLS_GuJieForm = class(TForm)
    pnlAll: TPanel;
    pnlTop: TPanel;
    Label2: TLabel;
    btnLoad: TBitBtn;
    btnCancel: TBitBtn;
    edtFileName: TEdit;
    btnFileOpen: TBitBtn;
    pnlCen: TPanel;
    sgResult: TStringGrid;
    OpenDialog1: TOpenDialog;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnFileOpenClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure sgResultDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnLoadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type TFieldRec=record
  FieldName: string;
  ZhongWen: string;
  end;

var
  TuYangDaoRuXLS_GuJieForm: TTuYangDaoRuXLS_GuJieForm;
  Fields_WL  : array[1..6] of TFieldRec;
implementation

uses public_unit, MainDM, SdCadMath;

{$R *.dfm}

procedure TTuYangDaoRuXLS_GuJieForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= CaFree;
end;

procedure TTuYangDaoRuXLS_GuJieForm.FormCreate(Sender: TObject);
begin
   self.Left := trunc((screen.Width -self.Width)/2);
   self.Top  := trunc((Screen.Height - self.Height)/2);
   sgResult.FixedCols := 3;
   sgResult.ColCount :=36;
   sgResult.ColWidths[0]:= 30;

//    Fields_YALI.Name := 'yssy_yali';      //压缩试验压力
//    Fields_BXL.Name  := 'yssy_bxl';       //压缩试验各级压力下的变形量
//    Fields_EI.Name   := 'yssy_kxb';       //压缩试验各级压力下的孔隙比
//    Fields_AV.Name   := 'yssy_ysxs';      //压缩试验各级压力下的压缩系数
//    Fields_ES.Name   := 'yssy_ysml';      //压缩试验各级压力下的压缩模量


//    Fields_WCX[1].Name := 'wcx_yuanz';      //无侧限抗压强度原状
//    Fields_WCX[2].Name := 'wcx_chsu';       //重塑
//    Fields_WCX[3].Name := 'wcx_lmd';        //灵敏度

   Fields_WL[1].FieldName := 'drl_no';
   Fields_WL[1].ZhongWen := '钻孔号';
   sgResult.Cells[1,0]:= Fields_WL[1].ZhongWen;
   sgResult.ColWidths[1]:= 120;

   Fields_WL[2].FieldName := 's_no';
   Fields_WL[2].ZhongWen := '土样编号';
   sgResult.Cells[2,0]:= Fields_WL[2].ZhongWen;

   Fields_WL[3].FieldName := 'yssy_yali';
   Fields_WL[3].ZhongWen := '压  力';
   sgResult.Cells[3,0]:= Fields_WL[3].ZhongWen;
   sgResult.ColWidths[3]:= 200;

   Fields_WL[4].FieldName := 'yssy_kxb';
   Fields_WL[4].ZhongWen := '孔 隙 比';
   sgResult.Cells[4,0]:= Fields_WL[4].ZhongWen;
   sgResult.ColWidths[4]:= 200;

   Fields_WL[5].FieldName := 'yssy_ysxs';
   Fields_WL[5].ZhongWen := '压 缩 系 数';
   sgResult.Cells[5,0]:= Fields_WL[5].ZhongWen;
   sgResult.ColWidths[5]:= 200;

   Fields_WL[6].FieldName := 'yssy_ysml';
   Fields_WL[6].ZhongWen := '压 缩 模 量';
   sgResult.Cells[6,0]:= Fields_WL[6].ZhongWen;
   sgResult.ColWidths[6]:= 200;
end;

procedure TTuYangDaoRuXLS_GuJieForm.btnFileOpenClick(Sender: TObject);
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

procedure TTuYangDaoRuXLS_GuJieForm.btnCancelClick(Sender: TObject);
begin
  self.Close;
end;

procedure TTuYangDaoRuXLS_GuJieForm.sgResultDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if ARow=0 then
    AlignGridCell(Sender,ACol,ARow,Rect,taCenter)
  else
    AlignGridCell(Sender,ACol,ARow,Rect,taRightJustify);
end;

procedure TTuYangDaoRuXLS_GuJieForm.btnLoadClick(Sender: TObject);
  type T_LeftRight = record
      LelfStr : string;  //左边的字符串
      RightStr   : string;  //右边的字符串
  end;
var
  ExcelApp: Variant;
  Sheet: Variant;
  SFileName, strSQL, strTemp:string;
  strDrillNo_S_No,strDrillNo,s_No:string;
  lstYali,lstKongxibi,lstYsxs,lstYsml:TStringList;
  strYssy_yali,strYssy_kxb,strYssy_ysxs,strYssy_ysml:string;
  kxb_ChuShi,yali_ChuShi,kxb_0,kxb_1,yali_0,yali_1, YaSuoMoLiang ,YaSuoXiShu:Double;
  pTmpBianHao, pTmpShenDu : T_LeftRight;
  J, iMsg, i, iField, iFromCol, iRecCount,iYaLiRow,iMaxCol:integer;   //iFromCol，压力从excel的哪一列开始
  lstTmp, lstSample : TStringList;

  //从字符串中取到钻孔编号和土样编号 str='JZ-31--29' 返回钻孔编号 JZ-31和土样编号 29
  //                             如果str='146-13'    返回钻孔编号 146  和土样编号 13
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
  procedure freeList();
  begin
    lstYali.Free ;
    lstKongxibi.Free;
    lstYsxs.Free;
    lstYsml.Free;
  end;
  function getKxb_ChuShi(aDrillNo,aS_no:string):Double;
  begin
    with MainDataModule.qryEarthSample do
    begin
      if Active then Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM earthsample WHERE prj_no='+''''+g_ProjectInfo.prj_no_ForSQL +'''');
      Open;
    end;
  end;
begin
  lstYali := TStringList.Create;
  lstKongxibi := TStringList.Create;
  lstYsxs := TStringList.Create;
  lstYsml := TStringList.Create;
  try
    screen.Cursor := crHourGlass;

    TRY
      ExcelApp := GetActiveOleObject('Excel.Application');
    except
      ExcelApp := CreateOleObject( 'Excel.Application' );
    end;
    SFileName := edtFileName.Text;
    ExcelApp.WorkBooks.Open(SFileName);
    Sheet := ExcelApp.WorkBooks[ExcelApp.WorkBooks.Count].WorkSheets[1];

      iYaLiRow := 1;//EXCEL中第一行是压力行
      J:=2;  //从第2行开始是孔隙比行//若土样编号为空，则结束
      iMaxCol:= 14;//固结EXCEL表中数据列的最大列数，一般不会超过14
      for i:=2 to iMaxCol do
        if Sheet.Cells[1,i].text<>'' then
        begin
          iFromCol := i;
          Break;
        end;
      strDrillNo := '';
      iMsg := IDCANCEL;//每个钻孔都要给用户选择是不是要导入这个钻孔的土样数据

      iRecCount := 0;
      while (Sheet.Cells[J,1].text<>'') DO
      BEGIN

        strDrillNo_S_No := Sheet.Cells[J,1].Value;
        if Pos('--',strDrillNo_S_No)>1 then
          GetLeftRightStr(strDrillNo_S_No,'--',PTmpBianHao)
        else
          GetLeftRightStr(strDrillNo_S_No,'-',PTmpBianHao);
        //每出现一个新钻孔号，当提示用户选择时用户选择是否导入这个钻孔的特殊样数据选择了否，或者是第一次出现钻孔
        if strDrillNo<>pTmpBianHao.LelfStr then
        begin
          strDrillNo := pTmpBianHao.LelfStr;
          iMsg := messagebox(self.Handle ,PAnsiChar('您要导入钻孔'+ strDrillNo+'的土样数据吗？'),'提示信息',MB_YESNO);

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

        strDrillNo := PTmpBianHao.LelfStr;   //钻孔号
        s_No := PTmpBianHao.RightStr;        //土样号

        strYssy_yali:='';
        strYssy_kxb:='';
        strYssy_ysxs:='';
        strYssy_ysml:='';

        lstYali.Clear;
        lstKongxibi.Clear;
        lstYsxs.Clear;
        lstYsml.Clear;

        with MainDataModule.qryEarthSample do
        begin
          if Active then Close;
          SQL.Clear;
          SQL.Add('SELECT * FROM earthsample WHERE prj_no='+''''+g_ProjectInfo.prj_no_ForSQL +''''
                  +' AND drl_no='+''''+ strDrillNo +''''
                  +' AND s_no='+''''+ s_No +'''');
          Open;
          if MainDataModule.qryEarthSample.RecordCount>0 then
          begin
            iRecCount := iRecCount + 1;
            sgResult.Cells[0,iRecCount] := IntToStr(iRecCount);
            for i:=iFromCol to iMaxCol do
            if Sheet.Cells[J,i].text<>'' then
            begin
              lstYali.Add(Sheet.Cells[iYaLiRow,i].text);
              lstKongxibi.Add(Sheet.Cells[J,i].text);
            end;

            if lstYali.Count<>lstKongxibi.Count then
            begin
              Application.MessageBox('压力和孔隙比的个数不一致，请检查修改！','数据检查',MB_OK);
              exit;
            end
            else if lstYali.Count>1 then
            begin


              yali_0 := StrToFloat(lstYali[0]);
              kxb_ChuShi := StrToFloat(VarToStr(FieldByName('gap_rate').Value ));
              yali_ChuShi := 0;




              yali_0 := StrToFloat(lstYali[0]);
              kxb_0 := StrToFloat(lstKongxibi[0]);
              YaSuoXiShu := getYaSuoXiShu(kxb_ChuShi,kxb_0,yali_ChuShi,yali_0);
              YaSuoMoLiang := getYaSuoMoLiang(kxb_ChuShi,YaSuoXiShu);

              strYssy_yali:= lstYali[0];
              strYssy_kxb := lstKongxibi[0];
              strYssy_ysxs:=FormatFloat('0.000',DoRound(YaSuoXiShu*1000)/1000);
              strYssy_ysml:=FormatFloat('0.00',DoRound(YaSuoMoLiang*100)/100);
              for i:=1 to lstYali.Count-1 do
              begin

                 yali_1 := StrToFloat(lstYali[i]);
                 kxb_1 := StrToFloat(lstKongxibi[i]);
                 YaSuoXiShu := getYaSuoXiShu(kxb_0,kxb_1,yali_0,yali_1);
                 YaSuoMoLiang := getYaSuoMoLiang(kxb_ChuShi,YaSuoXiShu);
                 lstYsxs.Add(FormatFloat('0.000',DoRound(YaSuoXiShu*1000)/1000));
                 lstYsml.Add(FormatFloat('0.00',DoRound(YaSuoMoLiang*100)/100));

                 strYssy_yali:= strYssy_yali+ ',' + lstYali[i];
                 strYssy_kxb := strYssy_kxb+ ',' + lstKongxibi[i];
                 strYssy_ysxs:=strYssy_ysxs+ ',' + lstYsxs[lstYsxs.Count-1];
                 strYssy_ysml:=strYssy_ysml+ ',' + lstYsml[lstYsml.Count-1];

                 yali_0 := StrToFloat(lstYali[i]);
                 kxb_0 := StrToFloat(lstKongxibi[i]);
              end;

              StrSQL:='UPDATE earthsample SET '
                  +' yssy_yali = ' +''''+ strYssy_yali +''','
                  +' yssy_kxb = ' +''''+ strYssy_kxb +''','
                  +' yssy_ysxs = ' +''''+ strYssy_ysxs +''','
                  +' yssy_ysml = ' +''''+ strYssy_ysml +''''
                  +' WHERE prj_no='+''''+g_ProjectInfo.prj_no_ForSQL +''''
                  +' AND drl_no='+''''+ strDrillNo +''''
                  +' AND s_no='+''''+ s_No +'''';

              if Update_oneRecord(MainDataModule.qryPublic, strSQL)  then
              begin
                sgResult.Cells[1,iRecCount] := strDrillNo;
                sgResult.Cells[2,iRecCount] := s_No;
                sgResult.Cells[3,iRecCount] := strYssy_yali;
                sgResult.Cells[4,iRecCount] := strYssy_kxb;
                sgResult.Cells[5,iRecCount] := strYssy_ysxs;
                sgResult.Cells[6,iRecCount] := strYssy_ysml;

                sgResult.RowCount := sgResult.RowCount + 1;
              end;

              
            end;

          end;
        end;
        J := J + 1;
      end;



  finally
    ExcelApp.Quit;
    ExcelApp := Unassigned;
    screen.Cursor := crDefault;
    freeList;
  end;

end;

end.
