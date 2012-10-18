unit JieKong;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, Grids, ExtCtrls, DB, ADODB, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary,
  dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin,
  dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver, dxSkinSpringTime,
  dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData,
  cxDataStorage, cxEdit, cxLabel, cxCheckBox,
  cxGridLevel, cxGridBandedTableView, cxGridCustomTableView,
  cxGridTableView, cxClasses, cxGridCustomView, cxGrid, cxStyles, cxFilter,
  cxData;

type
  TJieKongForm = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    sgProject: TStringGrid;
    Panel2: TPanel;
    lblAllDrills: TLabel;
    Label1: TLabel;
    sgJieDrills: TStringGrid;
    btnAdd: TButton;
    btn_cancel: TBitBtn;
    btnShouGong: TButton;
    btnAddAll: TButton;
    sgAllDrills: TcxGrid;
    sgAllDrillsTableView1: TcxGridTableView;
    sgAllDrillsTableView1Column0: TcxGridColumn;
    cxgrdclmnRowLinecxgrd1TableView1ColumnYuanShi: TcxGridColumn;
    sgAllDrillsBandedTableView1: TcxGridBandedTableView;
    sgAllDrillsBandedTableView1Column1: TcxGridBandedColumn;
    cxgrdlvlGrid1Level1: TcxGridLevel;
    btnCheckAll: TButton;
    btnCheckNone: TButton;
    procedure FormCreate(Sender: TObject);
    procedure sgProjectSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btnAddClick(Sender: TObject);
    procedure btnShouGongClick(Sender: TObject);
    procedure btnAddAllClick(Sender: TObject);
    procedure btnCheckAllClick(Sender: TObject);
    procedure btnCheckNoneClick(Sender: TObject);
  private
    { Private declarations }
    procedure getAllProjects;
    procedure GetAllDrillsByProjectNo(aProjectNo: String);
  public
    { Public declarations }
  end;

var
  JieKongForm: TJieKongForm;

implementation

uses MainDM, public_unit;

{$R *.dfm}

procedure TJieKongForm.FormCreate(Sender: TObject);
begin
  self.Left := trunc((screen.Width -self.Width)/2);
  self.Top  := trunc((Screen.Height - self.Height)/2);  

  sgProject.ColCount := 3;
  sgProject.RowHeights[0] := 16;
  sgProject.Cells[1,0] := '���̱��';  
  sgProject.Cells[2,0] := '��������';
  sgProject.ColWidths[0]:=10;
  sgProject.ColWidths[1]:=100;
  sgProject.ColWidths[2]:=200;

//  sgAllDrills.RowCount :=2;
//  sgAllDrills.ColCount := 2;
//  sgAllDrills.RowHeights[0] := 16;
//  sgAllDrills.Cells[1,0] := '�׺�';
//  //sgAllDrills.Cells[2,0] := '�׿ڱ��(m)';
//  //sgAllDrills.Cells[3,0] := '����(m)';
//  sgAllDrills.ColWidths[0]:=10;
//  sgAllDrills.ColWidths[1]:=120;
  //sgAllDrills.ColWidths[2]:=100;
  //sgAllDrills.ColWidths[2]:=100;

  sgJieDrills.RowCount := 2;
  sgJieDrills.ColCount := 2; 
  sgJieDrills.Cells[1,0] := '�׺�';
  sgJieDrills.RowHeights[0] :=16;
  sgJieDrills.ColWidths[0] :=10;
  sgJieDrills.ColWidths[1] :=120;

  getAllProjects;
  GetAllDrillsByProjectNo(sgProject.Cells[1,sgProject.Row]);

end;

procedure TJieKongForm.GetAllDrillsByProjectNo(aProjectNo: String);
var
  i: integer;
begin
  //sgAllDrills.RowCount :=2;
  //DeleteStringGridRow(sgAllDrills,1);
  sgAllDrillsTableView1.DataController.RecordCount := 0;
  if aProjectNo = '' then exit;
  sgAllDrillsTableView1.DataController.ClearDetails;
  sgAllDrillsTableView1.DataController.BeginFullUpdate;
  with MainDataModule.qryDrills do
    begin
      close;
      sql.Clear;
      //sql.Add('select prj_no,prj_name,area_name,builder,begin_date,end_date,consigner from projects');
      sql.Add('SELECT prj_no,drl_no,drl_elev,comp_depth');
      sql.Add(' FROM drills ');
      sql.Add(' WHERE prj_no='+''''+stringReplace(aProjectNo,'''','''''',[rfReplaceAll])+'''');
      sql.Add(' ORDER BY drl_no');
      open;
      i:=0;
      while not Eof do
        begin

          sgAllDrillsTableView1.DataController.AppendRecord;{����һ��,�����ĵ�һ�в���0��}
          sgAllDrillsTableView1.DataController.Values[i,0]:=FieldByName('drl_no').AsString ; {��һ����������,�ڶ�������}
          sgAllDrillsTableView1.DataController.Values[i,1]:= true;
 //         i:=i+1;
//          sgAllDrills.RowCount := i +2;
//          sgAllDrills.RowCount := i +1;
//          sgAllDrills.Cells[1,i] := FieldByName('drl_no').AsString;
//          sgAllDrills.Cells[2,i] := FieldByName('drl_elev').AsString;
//          sgAllDrills.Cells[3,i] := FieldByName('comp_depth').AsString;
          Next ;
          i := i+1;
        end;
      close;
    end;

    sgAllDrillsTableView1.DataController.Post;{�ύ}
    sgAllDrillsTableView1.DataController.EndFullUpdate;
    sgAllDrillsTableView1.ApplyBestFit();//�����п���ʾȫ�����ݣ����ڵ�ס�����ݡ�

end;

procedure TJieKongForm.getAllProjects;
var 
  i: integer;
  strCurrentPrj_no: string;
begin
  strCurrentPrj_no := stringReplace(g_projectinfo.prj_no,'''','''''',[rfReplaceAll]);
  with MainDataModule.qryProjects do
    begin
      close;
      sql.Clear;
      //sql.Add('select prj_no,prj_name,area_name,builder,begin_date,end_date,consigner from projects');
      sql.Add('select prj_no,prj_name from projects WHERE prj_no<>'''+strCurrentPrj_no+'''');
      open;
      i:=0;
      sgProject.Tag := 1;
      while not Eof do
        begin
          i:=i+1;
          sgProject.RowCount := i+1;
          sgProject.Cells[1,i] := MainDataModule.qryProjects.FieldByName('prj_no').AsString;
          sgProject.Cells[2,i] := MainDataModule.qryProjects.FieldByName('prj_name').AsString;
          Next;
        end;
      close;
      sgProject.Tag := 0; 
      sgProject.Row := 1;
    end;
end;

procedure TJieKongForm.sgProjectSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if TStringGrid(Sender).Tag = 1 then exit; //����Tag����Ϊÿ�θ�StringGrid��ֵ���ᴥ������SelectCell�¼���Ϊ�˱������������
                         //��SelectCell�¼�����Tagֵ���ж��Ƿ�Ӧ��ִ����SelectCell�еĲ���.   

  if (ARow <>0) and (ARow<>TStringGrid(Sender).Row) then
    if TStringGrid(Sender).Cells[1,ARow]<>'' then
    begin
      GetAllDrillsByProjectNo(TStringGrid(Sender).Cells[1,ARow]);
      sgJieDrills.RowCount :=2;
      DeleteStringGridRow(sgJieDrills,1);
    end
    else
    begin
      //clear_data(self);
    end;
end;

procedure getFieldsName(TableName: string; var strAllFields: string;var strOtherFields: string);
const
  SQL_FIELD = 'SELECT column_name FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ';
begin
  strAllFields := '';
  strOtherFields := '';
  with MainDataModule.qryPublic do
    begin
      close;
      sql.Clear;
      sql.Add(SQL_FIELD + '''' + TableName + '''');
      try
        try
          Open;
          while not eof do
          begin
            strAllFields := strAllFields + Fields[0].AsString + ',';
            next;
          end;
          strAllFields := copy(strallfields, 1, strlen(PChar(strallfields)) - 1);
          strOtherFields := copy(strAllFields, pos('drl_no', strAllFields) + 7,
             strlen(PChar(strAllFields)));
        except
        end;
      finally
        close;
      end;
    end;
end;

procedure TJieKongForm.btnAddClick(Sender: TObject);
var
  ClickedOK: Boolean;
  strPrj_NO, strDrill_NO, strCurrentPrj_NO, strCurrentDrl_NO,
  strDrill_NO_Display, strSQL, strCurrentComp_depth: string;
  AllFields, //һ����������ֶ���
  OtherFields: string; //���˹��̺ź���׺�֮��������ֶ�����
  dKongShen:Double;
begin
  strCurrentPrj_NO := stringReplace(g_ProjectInfo.prj_no,'''','''''',[rfReplaceAll]);
  strPrj_NO := stringReplace(sgProject.Cells[1,sgProject.row],'''','''''',[rfReplaceAll]);
  //strDrill_NO := sgAllDrills.Cells[1,sgallDrills.row];
  strDrill_NO := sgAllDrillsTableView1.DataController.Values[sgAllDrillsTableView1.Controller.SelectedRows[0].RecordIndex,0];
  strDrill_NO_Display := '(' + sgProject.Cells[1,sgProject.row] + ')' + strDrill_NO;
// yys modified at 2004/09/09
  //strCurrentDrl_NO := strDrill_NO;
  strCurrentDrl_NO := strDrill_NO_Display;
// yys modified at 2004/09/09
  ClickedOK := InputQuery('�¿׺�', '', strCurrentDrl_NO);
  if not ClickedOK then exit;
  strCurrentComp_depth :='';
  if sgAllDrillsTableView1.DataController.Values[sgAllDrillsTableView1.Controller.SelectedRows[0].RecordIndex,1]=True then
  begin
    ClickedOK := InputQuery('�µ�������','', strCurrentComp_depth);
    if not ClickedOK then exit;
  end;
  strCurrentDrl_NO:= stringReplace(trim(strCurrentDrl_NO),'''','''''',[rfReplaceAll]);
  if strCurrentDrl_NO='' then exit;
  if (strPrj_NO = '') or (strDrill_NO='') then exit;
  strDrill_NO := stringReplace(strDrill_NO,'''','''''',[rfReplaceAll]);


  //��ʼ�������Ŀ׵����ݣ�ֻ�ǰѹ��̺Ż��ɵ�ǰ�򿪵Ĺ��̵ı�š�
  getFieldsName('drills',AllFields,OtherFields);

  strSQL := 'INSERT INTO drills '
      +'(' + AllFields +') '
      +'(SELECT '+''''+strCurrentPrj_NO+'''' + ','
      + ''''+strCurrentDrl_NO+''''
      +','+ OtherFields
      +' FROM drills WHERE (prj_no = '+''''+strPrj_NO +''''
      +') AND (drl_no = '+''''+strDrill_NO+''''+'))';
  if Insert_oneRecord(MainDataModule.qryPublic,strSQL) then
  begin
    //����趨���¿��Ϊ�գ�����������׵�������
    if strCurrentComp_depth<>'' then
    begin
      //strCurrentComp_depth := FloatToStr(StrToFloat(strCurrentComp_depth)+1);
      strSQL := 'UPDATE Drills SET Comp_depth=' + strCurrentComp_depth
           +' WHERE (prj_no = '+''''+strCurrentPrj_NO +''''
           +') AND (drl_no = '+''''+strCurrentDrl_NO+''''+')'
           +' AND (Comp_depth>' + strCurrentComp_depth+')';
      Update_oneRecord(MainDataModule.qryPublic,strSQL);
    end;
    if sgJieDrills.Cells[1,sgJieDrills.RowCount - 1] <> '' then
        sgJieDrills.RowCount := sgJieDrills.RowCount + 1;
    sgJieDrills.Cells[1,sgJieDrills.RowCount - 1] := strCurrentDrl_NO;

    //��������׵�������Ϣ
    getFieldsName('stratum',AllFields,OtherFields);

    strSQL := 'INSERT INTO stratum '
      +'(' + AllFields +') '
      +'('
        +'(SELECT '+''''+strCurrentPrj_NO+'''' + ','+ ''''+strCurrentDrl_NO+''''+','+ OtherFields
            +' FROM stratum WHERE (prj_no = '+''''+strPrj_NO +''''
            +') AND (drl_no = '+''''+strDrill_NO+''')';
    if strCurrentComp_depth<>'' then
      strSQL := strSQL
            +' AND (Stra_depth < '+strCurrentComp_depth+'))'
        +' UNION '  ////����պ��µ���������һ������ĵ��У����������ҲҪ��
        +'(SELECT * FROM (SELECT top 1 '+''''+strCurrentPrj_NO+'''' + ' prj_no,'+ ''''+strCurrentDrl_NO+''''+' drl_no,'+ OtherFields
            +' FROM stratum WHERE (prj_no = '+''''+strPrj_NO +''''
            +') AND (drl_no = '+''''+strDrill_NO+''''
            +') AND (Stra_depth >= '+strCurrentComp_depth+') ORDER BY Stra_depth) AS [lastStratum]))'
    else
     strSQL := strSQL+'))';

    Insert_oneRecord(MainDataModule.qryPublic,strSQL);
    //���һ��Ĳ���Ҫ�޸ĳ�=����
    if strCurrentComp_depth<>'' then
    begin
      strSQL :='UPDATE stratum SET Stra_depth='+strCurrentComp_depth+' WHERE (prj_no = '+''''+strCurrentPrj_NO +''''
        +') AND (drl_no = '+''''+strCurrentDrl_NO+''''
        +') AND (Stra_depth > '+strCurrentComp_depth+')';

      Update_oneRecord(MainDataModule.qryPublic, strSQL);
    end;
//
//    with MainDataModule.qryStratum do
//      begin
//        close;
//        sql.Clear;
//        sql.Add(strSQL);
//        //showmessage(sql.Text);
//        open;
//
//        while not Eof do
//        begin
//          MemDescription.Text  := FieldByName('description').AsString;
//          MemDescription_en.Text  := FieldByName('description_en').AsString;
//          edtStra_fao.Text := FieldByName('Stra_fao').AsString;
//          edtStra_qik.Text := FieldByName('Stra_qik').AsString;
//          next;
//        end;
//        close;
//      end;

    //��������׵ľ�����̽����
    getFieldsName('cpt',AllFields,OtherFields);

    strSQL := 'INSERT INTO cpt '
      +'(' + AllFields +') '
      +'(SELECT '+''''+strCurrentPrj_NO+'''' + ','
      + ''''+strCurrentDrl_NO+''''
      +','+ OtherFields
      +' FROM cpt WHERE (prj_no = '+''''+strPrj_NO +''''
      +') AND (drl_no = '+''''+strDrill_NO+''''+'))';
    Insert_oneRecord(MainDataModule.qryPublic ,strSQL);

    //��������׵�ԭλ��������dpt
    getFieldsName('dpt',AllFields,OtherFields);

    strSQL := 'INSERT INTO dpt '
      +'(' + AllFields +') '
      +'(SELECT '+''''+strCurrentPrj_NO+'''' + ','
      + ''''+strCurrentDrl_NO+''''
      +','+ OtherFields
      +' FROM dpt WHERE (prj_no = '+''''+strPrj_NO +''''
      +') AND (drl_no = '+''''+strDrill_NO+''''+')';
      if strCurrentComp_depth<>'' then
        strSQL := strSQL
        +' AND (End_depth<=' + strCurrentComp_depth + ')';
      strSQL := strSQL+')';
    Insert_oneRecord(MainDataModule.qryPublic ,strSQL);
    //��������׵�ԭλ��������spt
    getFieldsName('spt',AllFields,OtherFields);

    strSQL := 'INSERT INTO spt '
      +'(' + AllFields +') '
      +'(SELECT '+''''+strCurrentPrj_NO+'''' + ','
      + ''''+strCurrentDrl_NO+''''
      +','+ OtherFields
      +' FROM spt WHERE (prj_no = '+''''+strPrj_NO +''''
      +') AND (drl_no = '+''''+strDrill_NO+''''+')';
      if strCurrentComp_depth<>'' then
        strSQL := strSQL
          +' AND (End_depth<=' + strCurrentComp_depth + ')';
      strSQL := strSQL+')';
    Insert_oneRecord(MainDataModule.qryPublic ,strSQL);

    //��������׵�ʮ�ְ�����
    getFieldsName('crossboard',AllFields,OtherFields);

    strSQL := 'INSERT INTO crossboard '
      +'(' + AllFields +') '
      +'(SELECT '+''''+strCurrentPrj_NO+'''' + ','
      + ''''+strCurrentDrl_NO+''''
      +','+ OtherFields
      +' FROM crossboard WHERE (prj_no = '+''''+strPrj_NO +''''
      +') AND (drl_no = '+''''+strDrill_NO+''''+'))';
    Insert_oneRecord(MainDataModule.qryPublic ,strSQL);

    //��������׵�������������
    getFieldsName('earthsample',AllFields,OtherFields);

    strSQL := 'INSERT INTO earthsample '
      +'(' + AllFields +') '
      +'(SELECT '+''''+strCurrentPrj_NO+'''' + ','
      + ''''+strCurrentDrl_NO+''''
      +','+ OtherFields
      +' FROM earthsample WHERE (prj_no = '+''''+strPrj_NO +''''
      +') AND (drl_no = '+''''+strDrill_NO+''''+')';
      if strCurrentComp_depth<>'' then
        strSQL := strSQL + ' AND (S_depth_end<=' +  strCurrentComp_depth + ')';
      strSQL := strSQL + ')';
    Insert_oneRecord(MainDataModule.qryPublic ,strSQL);

    //��������׵�������������������
    getFieldsName('TeShuYang',AllFields,OtherFields);

    strSQL := 'INSERT INTO TeShuYang '
      +'(' + AllFields +') '
      +'(SELECT '+''''+strCurrentPrj_NO+'''' + ','
      + ''''+strCurrentDrl_NO+''''
      +','+ OtherFields
      +' FROM TeShuYang WHERE (prj_no = '+''''+strPrj_NO +''''
      +') AND (drl_no = '+''''+strDrill_NO+''''+')';
      if strCurrentComp_depth<>'' then
        strSQL := strSQL + ' AND (S_depth_end<=' +  strCurrentComp_depth + ')';
      strSQL := strSQL + ')';
    Insert_oneRecord(MainDataModule.qryPublic ,strSQL);
  end;

end;

procedure TJieKongForm.btnShouGongClick(Sender: TObject);
//var
  //NewString, DrillNO, strSQL: string;
  //ClickedOK: Boolean;
  //DrillNoList: TStringList;
  //i,iRowID: Integer;
begin
  // NewString := '';
  // ClickedOK := InputQuery('�����', '��ױ�ţ���ʽΪ C1,C2,C3����', NewString);
  // if ClickedOK and (trim(NewString)<>'') then            { NewString contains new input string }
  // begin
  //   try
  //     DrillNoList := TStringList.Create;
  //     DivideString(trim(NewString),',',DrillNoList);
  //     if DrillNoList.Count >0 then
  //     begin
  //         for I := 0 to DrillNoList.Count - 1 do    // Iterate
  //         begin
  //             DrillNo := DrillNoList.Strings[i];
  //             if sgSectionDrills.Cells[1,1]='' then
  //               begin
  //                 sgSectionDrills.Cells[0,1]:='1';
  //                 sgSectionDrills.Cells[1,1]:=sgDrills.Cells[1,sgDrills.row];                                  
  //               end                                                                                            
  //             else                                                                                             
  //               begin                                                                                          
  //                 sgSectionDrills.RowCount := sgSectionDrills.RowCount +2;                                     
  //                 sgSectionDrills.RowCount := sgSectionDrills.RowCount -1;                                     
  //                 sgSectionDrills.Cells[0,sgSectionDrills.RowCount-1]:=intToStr(sgSectionDrills.RowCount-1);   
  //                 sgSectionDrills.Cells[1,sgSectionDrills.RowCount-1]:=DrillNo;                                
  //               end;                                                                                           
  //                                                                                                              
  //             strSQL := 'INSERT INTO section_drill (prj_no,sec_no,id,drl_no) VALUES('                          
  //               +''''+stringReplace(g_ProjectInfo.prj_no,'''','''''',[rfReplaceAll]) +''''+','                 
  //               +''''+stringReplace(trim(sgSection.Cells[1,sgSection.row]),'''','''''',[rfReplaceAll])+''''+','
  //               +''''+intToStr(sgSectionDrills.RowCount-1)+''''+','                                            
  //               +''''+stringReplace(DrillNo,'''','''''',[rfReplaceAll])+''''+')';                              
  //                                                                                                              
  //             if not Insert_oneRecord(MainDataModule.qrySectionDrill,strSQL) then                              
  //                 sgSectionDrills.RowCount := sgSectionDrills.RowCount -1;                                     
  //         end;    // for                                                                                       
  //         //GetDrillsBySectionNo(sgSection.Cells[1,m_sgSectionSelectedRow]);                                   
  //     end;                                                                                                     
  //   finally                                                                                                    
  //     DrillNoList.Free;                                                                                        
  //   end;                                                                                                       
  // end;

end;

procedure TJieKongForm.btnAddAllClick(Sender: TObject);
var
  ClickedOK: Boolean;
  strPrj_NO, strDrill_NO, strCurrentPrj_NO, strCurrentDrl_NO,
  strDrill_NO_Display, strDrill_PreName, strDrill_PreName_Display, strSQL,strCurrentComp_depth: string;
  AllFields, //һ����������ֶ���
  OtherFields: string; //���˹��̺ź���׺�֮��������ֶ�����
  i: Integer;
  isJieKong:Boolean;
begin
  //ȡ�����н�׵�ǰ׺���ƣ���ʾΪ��������ڵĹ�������
  strDrill_PreName := '(' + sgProject.Cells[1,sgProject.row] + ')';
  ClickedOK := InputQuery('�¿�ǰ׺����', '', strDrill_PreName);
  if not ClickedOK then exit;
  strCurrentComp_depth :='';
  ClickedOK := InputQuery('�µ�������','', strCurrentComp_depth);
  if not ClickedOK then exit;
  //if strCurrentComp_depth<>'' then  //��Ϊ������Ϊ25�Ļ���26���ڵ���Ȳ�Ҫ�õ�
  //  strCurrentComp_depth := FloatToStr(StrToFloat(strCurrentComp_depth)+1);
  strDrill_PreName_Display := strDrill_PreName;
  strDrill_PreName:= stringReplace(trim(strDrill_PreName),'''','''''',[rfReplaceAll]);

  strCurrentPrj_NO := g_ProjectInfo.prj_no_ForSQL;
  strPrj_NO := stringReplace(sgProject.Cells[1,sgProject.row],'''','''''',[rfReplaceAll]);
  if (strPrj_NO = '') then exit;

  try
      Screen.Cursor := crHourGlass;
      for I := 0 to sgAllDrillsTableView1.DataController.RecordCount-1 do    // Iterate
      begin
          //strDrill_NO := sgAllDrills.Cells[1,i];
          strDrill_NO := sgAllDrillsTableView1.DataController.Values[i,0];
          if strDrill_NO='' then continue;
          isJieKong := sgAllDrillsTableView1.DataController.Values[i,1] and (strCurrentComp_depth<>'') ;
          //ȡ���ڽ������ѽ����������ʾ�������
          strDrill_NO_Display := strDrill_PreName_Display + strDrill_NO;
          //ȡ�����ݿ��ѯ���������ԭ�������������������������滻�������ŵ�
          strDrill_NO := stringReplace(strDrill_NO,'''','''''',[rfReplaceAll]);
          strCurrentDrl_NO:= stringReplace(trim(strDrill_NO_Display),'''','''''',[rfReplaceAll]);

          //��ʼ�������Ŀ׵����ݣ�ֻ�ǰѹ��̺Ż��ɵ�ǰ�򿪵Ĺ��̵ı�š�
          getFieldsName('drills',AllFields,OtherFields);
          strSQL := 'INSERT INTO drills '
              +'(' + AllFields +') '
              +'(SELECT '+''''+strCurrentPrj_NO+'''' + ','
              + ''''+strCurrentDrl_NO+''''
              +','+ OtherFields
              +' FROM drills WHERE (prj_no = '+''''+strPrj_NO +''''
              +') AND (drl_no = '+''''+strDrill_NO+''''+'))';
          if Insert_oneRecord(MainDataModule.qryPublic,strSQL) then
          begin

            //����趨���¿��Ϊ�գ�����ѡ���˽ؿ�checkbox,����������׵�������
            if isJieKong  then
            begin
              //strCurrentComp_depth := FloatToStr(StrToFloat(strCurrentComp_depth)+1);
              strSQL := 'UPDATE Drills SET Comp_depth=' + strCurrentComp_depth
                +' WHERE (prj_no = '+''''+strCurrentPrj_NO +''''
                +') AND (drl_no = '+''''+strCurrentDrl_NO+''''+')'
                +' AND (Comp_depth>' + strCurrentComp_depth+')';
              Update_oneRecord(MainDataModule.qryPublic,strSQL);
            end;

            if sgJieDrills.Cells[1,sgJieDrills.RowCount - 1] <> '' then
                sgJieDrills.RowCount := sgJieDrills.RowCount + 1;
            sgJieDrills.Cells[1,sgJieDrills.RowCount - 1] := strDrill_NO_Display;

            //��������׵�������Ϣ
            getFieldsName('stratum',AllFields,OtherFields);

            strSQL := 'INSERT INTO stratum '
              +'(' + AllFields +') '
              +'('
                +'(SELECT '+''''+strCurrentPrj_NO+'''' + ','+ ''''+strCurrentDrl_NO+''''+','+ OtherFields
                    +' FROM stratum WHERE (prj_no = '+''''+strPrj_NO +''''
                    +') AND (drl_no = '+''''+strDrill_NO+''')';
            if isJieKong then
              strSQL := strSQL
                    +' AND (Stra_depth < '+strCurrentComp_depth+'))'
                +' UNION '  ////����պ��µ���������һ������ĵ��У����������ҲҪ��
                +'(SELECT * FROM (SELECT top 1 '+''''+strCurrentPrj_NO+'''' + ' prj_no,'+ ''''+strCurrentDrl_NO+''''+' drl_no,'+ OtherFields
                    +' FROM stratum WHERE (prj_no = '+''''+strPrj_NO +''''
                    +') AND (drl_no = '+''''+strDrill_NO+''''
                    +') AND (Stra_depth >= '+strCurrentComp_depth+') ORDER BY Stra_depth) AS [lastStratum]))'
            else
             strSQL := strSQL+'))';

            Insert_oneRecord(MainDataModule.qryPublic,strSQL);
            //���һ��Ĳ���Ҫ�޸ĳ�=����
            if isJieKong then
            begin
              strSQL :='UPDATE stratum SET Stra_depth='+strCurrentComp_depth+' WHERE (prj_no = '+''''+strCurrentPrj_NO +''''
                +') AND (drl_no = '+''''+strCurrentDrl_NO+''''
                +') AND (Stra_depth > '+strCurrentComp_depth+')';

              Update_oneRecord(MainDataModule.qryPublic, strSQL);
            end;


            //��������׵ľ�����̽����
            getFieldsName('cpt',AllFields,OtherFields);

            strSQL := 'INSERT INTO cpt '
              +'(' + AllFields +') '
              +'(SELECT '+''''+strCurrentPrj_NO+'''' + ','
              + ''''+strCurrentDrl_NO+''''
              +','+ OtherFields
              +' FROM cpt WHERE (prj_no = '+''''+strPrj_NO +''''
              +') AND (drl_no = '+''''+strDrill_NO+''''+'))';
            Insert_oneRecord(MainDataModule.qryPublic ,strSQL);

            //��������׵�ԭλ��������dpt
            getFieldsName('dpt',AllFields,OtherFields);

            strSQL := 'INSERT INTO dpt '
              +'(' + AllFields +') '
              +'(SELECT '+''''+strCurrentPrj_NO+'''' + ','
              + ''''+strCurrentDrl_NO+''''
              +','+ OtherFields
              +' FROM dpt WHERE (prj_no = '+''''+strPrj_NO +''''
              +') AND (drl_no = '+''''+strDrill_NO+''''+')';
              if strCurrentComp_depth<>'' then
                strSQL := strSQL
                +' AND (End_depth<=' + strCurrentComp_depth + ')';
              strSQL := strSQL+')';
            Insert_oneRecord(MainDataModule.qryPublic ,strSQL);
            //��������׵�ԭλ��������spt
            getFieldsName('spt',AllFields,OtherFields);

            strSQL := 'INSERT INTO spt '
              +'(' + AllFields +') '
              +'(SELECT '+''''+strCurrentPrj_NO+'''' + ','
              + ''''+strCurrentDrl_NO+''''
              +','+ OtherFields
              +' FROM spt WHERE (prj_no = '+''''+strPrj_NO +''''
              +') AND (drl_no = '+''''+strDrill_NO+''''+')';
              if strCurrentComp_depth<>'' then
                strSQL := strSQL
                  +' AND (End_depth<=' + strCurrentComp_depth + ')';
              strSQL := strSQL+')';
            Insert_oneRecord(MainDataModule.qryPublic ,strSQL);

            //��������׵�ʮ�ְ�����
            getFieldsName('crossboard',AllFields,OtherFields);

            strSQL := 'INSERT INTO crossboard '
              +'(' + AllFields +') '
              +'(SELECT '+''''+strCurrentPrj_NO+'''' + ','
              + ''''+strCurrentDrl_NO+''''
              +','+ OtherFields
              +' FROM crossboard WHERE (prj_no = '+''''+strPrj_NO +''''
              +') AND (drl_no = '+''''+strDrill_NO+''''+'))';
            Insert_oneRecord(MainDataModule.qryPublic ,strSQL);

            //��������׵�������������
            getFieldsName('earthsample',AllFields,OtherFields);

            strSQL := 'INSERT INTO earthsample '
              +'(' + AllFields +') '
              +'(SELECT '+''''+strCurrentPrj_NO+'''' + ','
              + ''''+strCurrentDrl_NO+''''
              +','+ OtherFields
              +' FROM earthsample WHERE (prj_no = '+''''+strPrj_NO +''''
              +') AND (drl_no = '+''''+strDrill_NO+''''+')';
              if isJieKong then
                strSQL := strSQL + ' AND (S_depth_end<=' +  strCurrentComp_depth + ')';
              strSQL := strSQL + ')';
            Insert_oneRecord(MainDataModule.qryPublic ,strSQL);

            //��������׵�������������������
            getFieldsName('TeShuYang',AllFields,OtherFields);

            strSQL := 'INSERT INTO TeShuYang '
              +'(' + AllFields +') '
              +'(SELECT '+''''+strCurrentPrj_NO+'''' + ','
              + ''''+strCurrentDrl_NO+''''
              +','+ OtherFields
              +' FROM TeShuYang WHERE (prj_no = '+''''+strPrj_NO +''''
              +') AND (drl_no = '+''''+strDrill_NO+''''+')';
              if isJieKong then
                strSQL := strSQL + ' AND (S_depth_end<=' +  strCurrentComp_depth + ')';
              strSQL := strSQL + ')';
            Insert_oneRecord(MainDataModule.qryPublic ,strSQL);
          end;


      end;    // for
  finally
      screen.Cursor := crDefault;
  end;

end;

procedure TJieKongForm.btnCheckAllClick(Sender: TObject);
var
  i:integer;
begin
  sgAllDrillsTableView1.DataController.BeginUpdate;
  for i:=0 to sgAllDrillsTableView1.DataController.RecordCount-1 do
  begin
    sgAllDrillsTableView1.DataController.Values[i,1]:=true;

  end;
  sgAllDrillsTableView1.DataController.Post;{�ύ}
  sgAllDrillsTableView1.DataController.EndUpdate;
end;

procedure TJieKongForm.btnCheckNoneClick(Sender: TObject);
var
  i:integer;
begin
  sgAllDrillsTableView1.DataController.BeginUpdate;
  for i:=0 to sgAllDrillsTableView1.DataController.RecordCount-1 do
  begin
    sgAllDrillsTableView1.DataController.Values[i,1]:=False;

  end;
  sgAllDrillsTableView1.DataController.Post;{�ύ}
  sgAllDrillsTableView1.DataController.EndUpdate;

end;

end.
