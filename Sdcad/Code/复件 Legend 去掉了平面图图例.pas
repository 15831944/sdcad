unit Legend;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SUIListBox, Grids, ExtCtrls, Buttons, SUIForm, StrUtils;

type
  
  TLegendForm = class(TForm)
    suiForm1: TsuiForm;
    btn_Print: TBitBtn;
    btn_ok: TBitBtn;
    btn_cancel: TBitBtn;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    sgPingMian: TStringGrid;
    sgPaoMian: TStringGrid;
    lstLegendAll: TsuiListBox;
    Label1: TLabel;
    btnDefault: TBitBtn;
    procedure sgPingMianExit(Sender: TObject);
    procedure sgPaoMianExit(Sender: TObject);
    procedure lstLegendAllDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sgPingMianDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btn_PrintClick(Sender: TObject);
    procedure btnDefaultClick(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
    procedure GetRecord;
    procedure GetAllLegend;
  public
    { Public declarations }
  end;
type
  TGridCell = record
    Grid: TStringGrid;
    Col : integer;
    Row : integer;
  end;
var
  LegendForm: TLegendForm;
  m_GridCell: TGridCell;
  m_LegendNameList_cn:TStringList;
  m_LegendNameList_en:TStringList;
implementation

uses MainDM, public_unit;

{$R *.dfm}

procedure TLegendForm.sgPingMianExit(Sender: TObject);
begin
  m_GridCell.Grid:= TStringGrid(Sender);
  m_GridCell.Col:= TStringGrid(Sender).Col;
  m_GridCell.Row:= TStringGrid(Sender).Row; 
end;

procedure TLegendForm.sgPaoMianExit(Sender: TObject);
begin
  m_GridCell.Grid:= TStringGrid(Sender);
  m_GridCell.Col:= TStringGrid(Sender).Col;
  m_GridCell.Row:= TStringGrid(Sender).Row;
end;

procedure TLegendForm.lstLegendAllDblClick(Sender: TObject);
begin
  m_GridCell.Grid.Cells[m_GridCell.Col, m_GridCell.Row]:= lstLegendAll.Items[lstLegendAll.ItemIndex];
end;

procedure TLegendForm.FormCreate(Sender: TObject);
begin
  self.Left := trunc((screen.Width -self.Width)/2);
  self.Top  := trunc((Screen.Height - self.Height)/2);
  sgPingMian.RowHeights[0] := 18;
  sgPaoMian.RowHeights[0] := 18;
  sgPingMian.Cells[0,0]:= 'ƽ';
  sgPingMian.Cells[1,0]:= '��';
  sgPingMian.Cells[2,0]:= 'ͼ';
  sgPingMian.Cells[3,0]:= 'ͼ';
  sgPingMian.Cells[4,0]:= '��';
  sgPaoMian.Cells[0,0]:= '��';
  sgPaoMian.Cells[1,0]:= '��';
  sgPaoMian.Cells[2,0]:= 'ͼ';
  sgPaoMian.Cells[3,0]:= 'ͼ';
  sgPaoMian.Cells[4,0]:= '��';
  GetAllLegend;
  GetRecord;
  m_GridCell.Grid:= sgPingMian;
  m_GridCell.Col:= 0;
  m_GridCell.Row:= 1;


end;

procedure TLegendForm.sgPingMianDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if ARow=0 then
    AlignGridCell(Sender,ACol,ARow,Rect,taCenter);
end;

procedure TLegendForm.btn_PrintClick(Sender: TObject);
var
  I: Integer;
  strFileName, strCell, strL_names: string;
  FileList: TStringList;
  aRow, aCol: integer;
begin
  if g_ProjectInfo.prj_no ='' then exit;
  FileList := TStringList.Create;
  strFileName:= g_AppInfo.PathOfChartFile + 'legend.ini';
  try
    FileList.Add('[ͼ��]');

    if g_ProjectInfo.prj_ReportLanguage= trChineseReport then
      FileList.Add('ͼֽ����='+g_ProjectInfo.prj_name+'ͼ��ͼ')
    else if g_ProjectInfo.prj_ReportLanguage= trEnglishReport then
      FileList.Add('ͼֽ����='+g_ProjectInfo.prj_name_en+' Legend');

    FileList.Add('���̱��='+g_ProjectInfo.prj_no);
    if g_ProjectInfo.prj_ReportLanguage= trChineseReport then
      FileList.Add('��������='+g_ProjectInfo.prj_name)
    else if g_ProjectInfo.prj_ReportLanguage= trEnglishReport then
      FileList.Add('��������='+g_ProjectInfo.prj_name_en) ;
    //��ʼ����ƽ��ͼͼ��
    strL_names:='';
    for aRow:=1 to sgPingMian.RowCount-1 do
      for aCol:= 0 to sgPingMian.ColCount-1 do
      begin
        strCell:= trim(sgPingMian.Cells[aCol, aRow]);
        if strCell<>'' then
        begin
          if g_ProjectInfo.prj_ReportLanguage =trEnglishReport then
          begin
            for I := 0 to m_LegendNameList_cn.Count  - 1 do    // Iterate
            begin
              if strCell = m_LegendNameList_cn.Strings[i] then
              begin
                strCell := strCell + REPORT_PRINT_SPLIT_CHAR +
                  m_LegendNameList_en.Strings[i];
                break;
              end;
            end;  // for
          end;
          strL_names:= strL_names + strCell+',';
        end;
      end;
    if copy(ReverseString(strL_names),1,1)=',' then
      delete(strL_names,length(strL_names),1);
    FileList.Add('ƽ��ͼͼ��='+ strL_names);

    //��ʼ��������ͼͼ�� 
    strL_names:='';
    for aRow:=1 to sgPaoMian.RowCount-1 do
      for aCol:= 0 to sgPaoMian.ColCount-1 do
      begin
        strCell:= trim(sgPaoMian.Cells[aCol, aRow]);
        if strCell<>'' then
        begin
          if g_ProjectInfo.prj_ReportLanguage =trEnglishReport then
          begin
            for I := 0 to m_LegendNameList_cn.Count  - 1 do    // Iterate
            begin
              if strCell = m_LegendNameList_cn.Strings[i] then
              begin
                strCell := strCell + REPORT_PRINT_SPLIT_CHAR +
                  m_LegendNameList_en.Strings[i];
                break;
              end;
            end;  // for
          end;
          strL_names:= strL_names + strCell+',';
        end;
      end;
    if copy(ReverseString(strL_names),1,1)=',' then
      delete(strL_names,length(strL_names),1);
    FileList.Add('����ͼͼ��='+ strL_names);
    FileList.SaveToFile(strFileName);    
  finally
    FileList.Free;
  end;
  winexec(pAnsichar(getCadExcuteName+' 5,'+strFileName+ ','  
    + REPORT_PRINT_SPLIT_CHAR),sw_normal);
end;

procedure TLegendForm.GetRecord;
var 
  strSQL,strPingMianAll,strPaoMianAll,strL_type,strL_names: String;
  i,j, iCount: integer;
  LegendList: TStringList;
begin
  strPingMianAll:='';
  strPaoMianAll:='';
  strL_type:='';
  strL_names:='';
  strSQL:='SELECT prj_no,l_type,l_names '
           +'FROM prj_legend '
           +' WHERE prj_no=' 
           +''''+g_ProjectInfo.prj_no_ForSQL +'''';
  with MainDataModule.qryLegend do
    begin
      close;
      sql.Clear;
      sql.Add(strSQL);
      open;
      i:= 0;
      while not Eof do
        begin
          inc(i);
          strL_type:= FieldByName('l_type').AsString;
          strL_names:= FieldByName('l_names').AsString;
          if strL_type='0' then 
            strPingMianAll:= strL_names
          else if strL_type='1' then
            strPaoMianAll:= strL_names;
          next;
        end;
      close;
    end;
  if i>0 then
  begin
    LegendList := TStringList.Create;
    //��ʼ��sgPingMian�ĸ���Cell��ֵ
    if strPingMianAll<>'' then
    begin
      DivideString(strPingMianAll,',',LegendList);
      if LegendList.Count >0 then
      begin
        iCount:= -1;
        for i:= 1 to sgPingMian.RowCount -1 do
          for j:= 0 to sgPingMian.ColCount -1 do
            begin
              Inc(iCount);
              if iCount<LegendList.Count then
                sgPingMian.Cells[j,i]:= LegendList.Strings[iCount];
            end;
      end;      
    end;
    //��ʼ��sgPaoMian�ĸ���Cell��ֵ
    if strPaoMianAll<>'' then
    begin
      DivideString(strPaoMianAll,',',LegendList);
      if LegendList.Count >0 then
      begin
        iCount:= -1;
        for i:= 1 to sgPaoMian.RowCount -1 do
          for j:= 0 to sgPaoMian.ColCount -1 do
            begin
              Inc(iCount);
              if iCount<LegendList.Count then
                sgPaoMian.Cells[j,i]:= LegendList.Strings[iCount];
            end;
      end;      
    end;
    LegendList.Free;
  end;

end;

procedure TLegendForm.GetAllLegend;
var
  strSQL: string;
begin
  m_LegendNameList_cn := TStringList.Create ;
  m_LegendNameList_en := TStringList.Create ;
  strSQL:='SELECT l_type,l_name,l_name_en FROM legend_type';
  with MainDataModule.qryPublic do
    begin
      close;
      sql.Clear;
      sql.Add(strSQL);
      open;
      lstLegendAll.Clear;
      while not eof do
        begin
          lstLegendAll.Items.Add(FieldByName('l_name').AsString);
          m_LegendNameList_cn.Add(FieldByName('l_name').AsString);
          m_LegendNameList_en.Add(FieldByName('l_name_en').AsString);
          next;
        end;
      close;
    end;

  //ȡ�õ�ǰ���̵�����ͼ��
  strSQL:='select et.ea_name,ISNULL(et.ea_name_en,'''') as ea_name_en'
    +' from earthtype et'
    +' inner join (select DISTINCT ea_name from stratum_description'
    +' WHERE prj_no=' +''''+g_ProjectInfo.prj_no_ForSQL +''') as sd'
    +' on sd.ea_name=et.ea_name';
  with MainDataModule.qryPublic do
    begin
      close;
      sql.Clear;
      sql.Add(strSQL);
      open;
      while not eof do
        begin
          lstLegendAll.Items.Add(FieldByName('ea_name').AsString);
          m_LegendNameList_cn.Add(FieldByName('ea_name').AsString);
          m_LegendNameList_en.Add(FieldByName('ea_name_en').AsString);
          next;
        end;
      close;
    end;

  SetListBoxHorizonbar(lstLegendAll);
end;


procedure TLegendForm.btnDefaultClick(Sender: TObject);
var
  strSQL: string;
  aCol,aRow: integer;
  procedure ClearGrid(aStringGrid: TStringGrid);
  var g: integer;
  begin
    for g:= 1 to aStringGrid.RowCount-1 do
      aStringGrid.rows[g].Clear;
  end;
begin
  ClearGrid(sgPingMian);
  ClearGrid(sgPaoMian);
  //ȡ�ù���Ĭ�ϵ�ƽ��ͼͼ����
  strSQL:='SELECT l_type,l_name from legend_type WHERE l_default=0';
  with MainDataModule.qryPublic do
    begin
      close;
      sql.Clear;
      sql.Add(strSQL);
      open;
      aCol:= 0;
      aRow:=1;
      while not eof do
        begin
          if aCol=sgPingMian.ColCount then
          begin
            aCol:=0;
            Inc(aRow);
          end;
          sgPingMian.Cells[aCol, aRow]:=(FieldByName('l_name').AsString);
          Inc(aCol);
          next;
        end;
      close;
    end;
  //ȡ�õ�ǰ���̵�����ͼ��
  strSQL:='SELECT DISTINCT ea_name FROM stratum_description'
    +' WHERE prj_no=' +''''+g_ProjectInfo.prj_no_ForSQL +'''';
  with MainDataModule.qryPublic do
    begin
      close;
      sql.Clear;
      sql.Add(strSQL);
      open;
      aCol:= 0;
      aRow:=1;
      while not eof do
        begin
          if aCol=sgPaoMian.ColCount then
          begin
            aCol:=0;
            Inc(aRow);
          end;
          sgPaoMian.Cells[aCol, aRow]:=(FieldByName('ea_name').AsString);
          Inc(aCol);
          next;
        end;
      close;
    end;
end;

procedure TLegendForm.btn_okClick(Sender: TObject);
var
  strSQL, strCell,strL_names: string;
  aRow,aCol: integer;
begin
  //��ʼ���ӻ����ƽ��ͼͼ��������ͼ�����С�
  strSQL:= 'SELECT * FROM prj_legend WHERE prj_no='
    +''''+g_ProjectInfo.prj_no_ForSQL +''''
    +' AND l_type=0';
  strL_names:='';
  for aRow:=1 to sgPingMian.RowCount-1 do
    for aCol:= 0 to sgPingMian.ColCount-1 do
    begin
      strCell:= trim(sgPingMian.Cells[aCol, aRow]);
      if strCell<>'' then
        strL_names:= strL_names + strCell+',';
    end;
  if copy(ReverseString(strL_names),1,1)=',' then
    delete(strL_names,length(strL_names),1);
  if isExistedRecord(MainDataModule.qryLegend,strSQL) then
  begin
    strSQL:= 'UPDATE prj_legend SET l_names=';
    strSQL:= strSQL +''''+strL_names+''''+ ' WHERE prj_no='
      +''''+g_ProjectInfo.prj_no_ForSQL +''''
      +' AND l_type=0';
    if not Update_onerecord(MainDataModule.qryLegend,strSQL) then
      MessageBox(self.Handle,'ƽ��ͼͼ�����ݸ���ʧ�ܣ����ܱ��档','��ʾ',MB_OK+MB_ICONERROR);
  end
  else //��ǰ��ƽ��ͼͼ����¼�ڹ���ͼ�����в����ڡ�
  begin
    strSQL:= 'INSERT prj_legend (prj_no,l_type,l_names) VALUES(';
    strSQL:= strSQL 
      +''''+g_ProjectInfo.prj_no_ForSQL +'''' +','
      +' 0,'+ ''''+strL_names+''''+ ')'; 
    if not Insert_oneRecord(MainDataModule.qryLegend,strSQL) then
      MessageBox(self.Handle,'ƽ��ͼͼ����������ʧ�ܣ����ܱ��档','��ʾ',MB_OK+MB_ICONERROR);
  end;
   
  //��ʼ���ӻ���²���ͼͼ��������ͼ�����С�
  strSQL:= 'SELECT * FROM prj_legend WHERE prj_no='
    +''''+g_ProjectInfo.prj_no_ForSQL +''''
    +' AND l_type=1';
  strL_names:='';
  for aRow:=1 to sgPaoMian.RowCount-1 do
    for aCol:= 0 to sgPaoMian.ColCount-1 do
    begin
      strCell:= trim(sgPaoMian.Cells[aCol, aRow]);
      if strCell<>'' then
        strL_names:= strL_names + strCell+',';
    end;
  if copy(ReverseString(strL_names),1,1)=',' then
    delete(strL_names,length(strL_names),1);
  if isExistedRecord(MainDataModule.qryLegend,strSQL) then
  begin
    strSQL:= 'UPDATE prj_legend SET l_names=';
    strSQL:= strSQL +''''+strL_names+''''+ ' WHERE prj_no='
      +''''+g_ProjectInfo.prj_no_ForSQL +''''
      +' AND l_type=1';
    if not Update_onerecord(MainDataModule.qryLegend,strSQL) then
      MessageBox(self.Handle,'����ͼͼ�����ݸ���ʧ�ܣ����ܱ��档','��ʾ',MB_OK+MB_ICONERROR);
  end
  else //��ǰ�Ĳ���ͼͼ����¼�ڹ���ͼ�����в����ڡ�
  begin
    strSQL:= 'INSERT prj_legend (prj_no,l_type,l_names) VALUES(';
    strSQL:= strSQL 
      +''''+g_ProjectInfo.prj_no_ForSQL +'''' +','
      +' 1,'+ ''''+strL_names+''''+ ')'; 
    if not Insert_oneRecord(MainDataModule.qryLegend,strSQL) then
      MessageBox(self.Handle,'����ͼͼ����������ʧ�ܣ����ܱ��档','��ʾ',MB_OK+MB_ICONERROR);
  end;
end;

end.
