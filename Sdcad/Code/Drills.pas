unit Drills;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, Grids, DB, 
  rxToolEdit, strUtils;

type
  TDrillsForm = class(TForm)
    pnlTop: TPanel;
    btn_edit: TBitBtn;
    btn_ok: TBitBtn;
    btn_add: TBitBtn;
    btn_delete: TBitBtn;
    btn_cancel: TBitBtn;
    btn_AllTongJi: TBitBtn;
    btn_allNoTongJi: TBitBtn;
    pnlLeft: TPanel;
    sgDrills: TStringGrid;
    pnlRight: TPanel;
    imgDrill: TImage;
    pnlClient: TPanel;
    lblDrl_no: TLabel;
    lblDrl_elev: TLabel;
    lblD_t_no: TLabel;
    lblDrl_x: TLabel;
    lblDrl_y: TLabel;
    lblFirst_elev: TLabel;
    lblStable_elev: TLabel;
    lblDrl_lczh: TLabel;
    lblComp_depth: TLabel;
    lblBushing_diam: TLabel;
    lblBegin_cal: TLabel;
    lblEnd_Cal: TLabel;
    lblBegin_date: TLabel;
    lblEnd_date: TLabel;
    lblBorer_name: TLabel;
    lblwcy_first_elev: TLabel;
    lblwcy_stable_elev: TLabel;
    edtDrl_no: TEdit;
    dtpBegin_date: TDateTimePicker;
    dtpEnd_date: TDateTimePicker;
    cboD_t_name: TComboBox;
    cboD_t_no: TComboBox;
    cboBorer_name: TComboBox;
    cboBorer_no: TComboBox;
    edtFirst_elev: TEdit;
    edtStable_elev: TEdit;
    edtDrl_lczh: TEdit;
    edtBegin_cal: TEdit;
    edtEnd_Cal: TEdit;
    edtBushing_diam: TEdit;
    edtDrl_elev: TEdit;
    edtComp_depth: TEdit;
    edtDrl_x: TEdit;
    edtDrl_y: TEdit;
    cboD_T_type: TComboBox;
    chk_Can_jueSuan: TCheckBox;
    chk_can_tongji: TCheckBox;
    edtwcy_first_elev: TEdit;
    edtwcy_stable_elev: TEdit;
    chk_IsJieKong: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_cancelClick(Sender: TObject);
    procedure sgDrillsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btn_deleteClick(Sender: TObject);
    procedure btn_addClick(Sender: TObject);
    procedure cboD_t_nameChange(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure edtDrl_noKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboD_t_nameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dtpEnd_dateKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btn_editClick(Sender: TObject);
    procedure edtDrl_elevChange(Sender: TObject);
    procedure edtDrl_elevKeyPress(Sender: TObject; var Key: Char);
    procedure cboBorer_nameChange(Sender: TObject);
    procedure cboBorer_nameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtComp_depthKeyPress(Sender: TObject; var Key: Char);
    procedure edtDrl_noExit(Sender: TObject);
    procedure edtFirst_elevKeyPress(Sender: TObject; var Key: Char);
    procedure btn_AllTongJiClick(Sender: TObject);
    procedure btn_allNoTongJiClick(Sender: TObject);
  private
    { Private declarations }

    procedure Get_oneDrillRecord(aProjectNo: string;aDrillNo: string);
    procedure Get_DrillType;
    procedure Get_BorerType;
    procedure setComponentVisible(aDrillType: string);
    procedure Update_earthSample;
    function Delete_oneDrillRecord(strSQL:string):boolean;
    function Update_oneDrillRecord(strSQL:string):boolean;
    function Insert_oneDrillRecord(strSQL:string):boolean;
    function GetInsertSQL:string;
    function GetUpdateSQL:string;
    function GetDeleteSQL:string;
    function Check_Data:boolean;
    function isExistedDrill(aProjectNo:string;aDrillNo: string):boolean;

  public
    { Public declarations }
    procedure button_status(int_status:integer;bHaveRecord:boolean);
    procedure DrawDrill;
  end;

var
  DrillsForm: TDrillsForm;
  m_iGridSelectedRow: integer;
  m_DataSetState: TDataSetState;
implementation

uses MainDM, public_unit, DrillDiagram;
var m_DrillDiagram: TDrillDiagram;
{$R *.dfm}

procedure TDrillsForm.FormCreate(Sender: TObject);
var
  i: integer;
begin

  self.Left := trunc((screen.Width -self.Width)/2);
  self.Top  := trunc((Screen.Height - self.Height)/2);
  sgDrills.Tag := 1;
  sgDrills.RowHeights[0] := 16;
  sgDrills.Cells[1,0] := '钻孔编号';  
  sgDrills.Cells[2,0] := '钻孔类型';
  sgDrills.ColWidths[0]:=10;
  sgDrills.ColWidths[1]:=125;
  sgDrills.ColWidths[2]:=100;
  
  m_iGridSelectedRow:= -1;
  try
    m_DrillDiagram:= TDrillDiagram.create;
    m_DrillDiagram.Image := imgDrill;
  finally
  end;
  
  Clear_Data(self);
  Get_DrillType;
  Get_BorerType;
  with MainDataModule.qryDrills do
    begin
      close;
      sql.Clear;
      //sql.Add('select prj_no,prj_name,area_name,builder,begin_date,end_date,consigner from projects');
      sql.Add('SELECT d.prj_no as prj_no,d.drl_no as drl_no,d.d_t_no as d_t_no,t.d_t_name as d_t_name');
      sql.Add(' FROM drills as d,drill_type as t ');
      sql.Add(' WHERE d.prj_no='+''''+g_ProjectInfo.prj_no_ForSQL+'''');
      sql.Add(' and d.d_t_no = t.d_t_no ORDER BY drl_no');
      open;
      i:=0;
      sgDrills.Tag := 1;
      while not Eof do
        begin
          i:=i+1;
          sgDrills.RowCount := i +2;
          sgDrills.Cells[1,i] := FieldByName('drl_no').AsString;  
          sgDrills.Cells[2,i] := FieldByName('d_t_name').AsString;
          sgDrills.RowCount := i +1;
          Next ;
        end;
      close;
      sgDrills.Tag :=0;
    end;
  if i>0 then
  begin
    Get_oneDrillRecord(g_ProjectInfo.prj_no,sgDrills.Cells[1,1]);
    DrawDrill;
    sgDrills.Row :=1;
    m_iGridSelectedRow :=1; 
    button_status(1,true);
  end
  else
    button_status(1,false);
    
end;

//控制按钮的工作状态
//int_status,1:浏览状态,2:修改状态,3:增加状态
//bHaveRecord,表示数据表中有没有纪录
procedure TDrillsForm.button_status(int_status:integer;bHaveRecord:boolean);
begin
  case int_status of
    1: //浏览状态
      begin
        btn_edit.Enabled :=bHaveRecord;
        btn_delete.Enabled :=bHaveRecord;
        btn_edit.Caption :='修改';
        btn_ok.Enabled :=false;
        btn_add.Enabled :=true;
        Enable_Components(self,false);
        m_DataSetState := dsBrowse;
      end;
    2: //修改状态
      begin
        btn_edit.Enabled :=true;
        btn_edit.Caption :='放弃';
        btn_ok.Enabled :=true;
        btn_add.Enabled :=false;
        btn_delete.Enabled :=false;
        Enable_Components(self,true);
        m_DataSetState := dsEdit;
      end;
    3: //增加状态
      begin
        btn_edit.Enabled :=true;
        btn_edit.Caption :='放弃';
        btn_ok.Enabled :=true;
        btn_add.Enabled :=false;
        btn_delete.Enabled :=false;
        Enable_Components(self,true);
        m_DataSetState := dsInsert;
      end;
  end;
end;

procedure TDrillsForm.Get_oneDrillRecord(aProjectNo: string;aDrillNo: string);
begin
  if trim(aProjectNo)='' then exit;
  if trim(aDrillNo)='' then exit;
  with MainDataModule.qryDrills do
    begin
      close;
      sql.Clear;
      sql.Add('SELECT * FROM drills');
      sql.Add(' where prj_no=' + ''''+stringReplace(aProjectNo ,'''','''''',[rfReplaceAll])+'''');
      sql.Add(' AND drl_no=' +''''+stringReplace(aDrillNo ,'''','''''',[rfReplaceAll])+'''');
      open;
      
      while not Eof do
      begin 
        edtdrl_no.Text := FieldByName('drl_no').AsString;
        edtDrl_elev.Text := FieldByName('drl_elev').AsString;
        edtDrl_x.Text := FieldByName('drl_x').AsString;
        edtDrl_y.Text := FieldByName('drl_y').AsString;
        edtFirst_elev.Text := FieldByName('first_elev').AsString;
        edtStable_elev.Text := FieldByName('stable_elev').AsString;
        edtwcy_first_elev.Text := FieldByName('wcy_first_elev').AsString;
        edtwcy_stable_elev.Text := FieldByName('wcy_stable_elev').AsString;
        edtBushing_diam.Text := FieldByName('bushing_diam').AsString;
        edtBegin_cal.Text := FieldByName('begin_cal').AsString;  
        edtEnd_cal.Text := FieldByName('end_cal').AsString;
        cboD_t_no.ItemIndex := cboD_t_no.Items.IndexOf(FieldByName('d_t_no').AsString);
        cboD_t_name.ItemIndex := cbod_t_no.ItemIndex;
        cboD_t_type.ItemIndex := cbod_t_no.ItemIndex;
        setComponentVisible(cboD_t_type.Text);
        edtDrl_lczh.Text := FieldByName('drl_lczh').AsString;
        edtComp_depth.Text := FieldByName('comp_depth').AsString;                
        dtpBegin_date.Date := FieldByName('begin_date').AsDateTime;
        dtpEnd_date.Date := FieldByName('end_date').AsDateTime;
        cboBorer_no.ItemIndex := cboBorer_no.Items.IndexOf(FieldByName('borer_no').AsString);
        cboBorer_name.ItemIndex := cboBorer_no.ItemIndex;
        if FieldByName('can_juesuan').AsString=BOOLEAN_True then
            chk_Can_jueSuan.State := cbChecked
        else
            chk_Can_jueSuan.State := cbUnChecked ;

        if FieldByName('can_tongji').AsString=BOOLEAN_True then
            chk_can_tongji.State := cbChecked
        else
            chk_can_tongji.State := cbUnChecked ;

        if FieldByName('isJieKong').AsString = BOOLEAN_True then
            chk_IsJieKong.State := cbChecked
        else
            chk_IsJieKong.State := cbUnChecked ;

        next;
      end;
      close;
    end;  
end;

procedure TDrillsForm.Get_DrillType;
begin
  self.cboD_t_no.Clear;
  self.cboD_t_name.Clear;
  self.cboD_t_type.Clear;
  with MainDataModule.qryDrill_type do
    begin
      close;
      sql.Clear;
      sql.Add('SELECT * FROM drill_type');
      open;
      
      while not Eof do
      begin
        self.cboD_t_no.Items.Add(FieldByName('d_t_no').AsString);
        self.cboD_t_name.Items.Add(FieldByName('d_t_name').AsString);
        self.cboD_t_type.Items.Add(FieldByName('d_t_type').AsString);
        Next;
      end;
    end;
end;

procedure TDrillsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  m_DrillDiagram.Destroy;
  Action := caFree;
end;

procedure TDrillsForm.btn_cancelClick(Sender: TObject);
begin
  self.Close;
end;

procedure TDrillsForm.sgDrillsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if TStringGrid(Sender).Tag = 1 then exit; //设置Tag是因为每次给StringGrid赋值都会触发它的SelectCell事件，为了避免这种情况，
                         //在SelectCell事件中用Tag值来判断是否应该执行在SelectCell中的操作.   
  
  if (ARow <>0) and (ARow<>m_iGridSelectedRow) then
  begin
    if sgDrills.Cells[1,ARow]<>'' then
    begin
      Get_oneDrillRecord(g_ProjectInfo.prj_no, sgDrills.Cells[1,ARow]);
      if sgDrills.Cells[1,ARow]='' then
        Button_status(1,false)
      else
        Button_status(1,true);
    end
    else
      clear_data(self);
    DrawDrill;
  end;
  m_iGridSelectedRow:=ARow;
end;

procedure TDrillsForm.btn_deleteClick(Sender: TObject);
var
  strSQL: string;
begin
  if MessageBox(self.Handle,
  '钻孔一但删除，所有与此钻孔相关的数据（土层等）都会删除，且不能恢复，'
   +#13+ '您确定要删除吗？','警告', MB_YESNO+MB_ICONQUESTION)=IDNO then exit;
  if edtDrl_no.Text <> '' then
    begin
      strSQL := self.GetDeleteSQL;
      if Delete_oneDrillRecord(strSQL) then
        begin
          Clear_Data(self);  
          DeleteStringGridRow(sgDrills,sgDrills.Row);
          self.Get_oneDrillRecord(g_ProjectInfo.prj_no,sgDrills.Cells[1,sgDrills.row]);
          if sgDrills.Cells[1,sgDrills.row]='' then
            button_status(1,false)
          else
            button_status(1,true);
        end;
    end;
      
end;

function TDrillsForm.Delete_oneDrillRecord(strSQL:string): boolean;
begin
  with MainDataModule.qryDrills do
    begin
      close;
      sql.Clear;
      sql.Add(strSQL);

      try
        try
          ExecSQL;
          MessageBox(self.Handle,'删除成功！','删除数据',MB_OK+MB_ICONINFORMATION);
          result := true;
        except
          MessageBox(self.Handle,'数据库错误，不能删除所选数据。','数据库错误',MB_OK+MB_ICONERROR);
          result := false;
        end;
      finally
        close;
      end;
    end;
end;

function TDrillsForm.Update_oneDrillRecord(strSQL:string): boolean;
begin
  with MainDataModule.qryDrills do
    begin
      close;
      sql.Clear;
      sql.Add(strSQL);
      try
        try
          ExecSQL;
          MessageBox(self.Handle,'更新数据成功！','更新数据',MB_OK+MB_ICONINFORMATION);
          result := true;
        except
          MessageBox(self.Handle,'数据库错误，更新数据失败。','数据库错误',MB_OK+MB_ICONERROR);
          result:= false;
        end;
      finally
        close;
      end;
    end;

end;

function TDrillsForm.Check_Data: boolean;
begin
  if trim(edtDrl_no.Text) = '' then
  begin
    messagebox(self.Handle,'请输入钻孔编号！','数据校对',mb_ok);
    edtDrl_no.SetFocus;
    result := false;
    exit;
  end;
  if trim(cboD_t_name.Text) = '' then
  begin
    messagebox(self.Handle,'请选择钻孔类型！','数据校对',mb_ok);
    cboD_t_name.SetFocus;
    result := false;
    exit;
  end;
  {if trim(edtDrl_x.Text) = '' then
  begin
    messagebox(self.Handle,'请输入孔口坐标X！','数据校对',mb_ok);
    edtDrl_x.SetFocus;
    result := false;
    exit;
  end;
  if trim(edtDrl_y.Text) = '' then
  begin
    messagebox(self.Handle,'请输入孔口坐标Y！','数据校对',mb_ok);
    edtDrl_y.SetFocus;
    result := false;
    exit;
  end;  }
  if trim(edtDrl_elev.Text)='' then
  begin
    messagebox(self.Handle,'请输入孔口标高！','数据校对',mb_ok);
    edtDrl_elev.SetFocus;
    result := false;
    exit;    
  end;
  {if trim(edtStable_elev.Text)='' then
  begin
    messagebox(self.Handle,'请输入稳定水位深度！','数据校对',mb_ok);
    edtStable_elev.SetFocus;
    result := false;
    exit;    
  end;}
  result := true;
end;

function TDrillsForm.Insert_oneDrillRecord(strSQL:string): boolean;
begin
  with MainDataModule.qryDrills do
    begin
      close;
      sql.Clear;
      sql.Add(strSQL);
      try
        try
          ExecSQL;
          MessageBox(self.Handle,'增加数据成功！','增加数据',MB_OK+MB_ICONINFORMATION);
          result := true;
        except
          MessageBox(self.Handle,'数据库错误，增加数据失败。','数据库错误',MB_OK+MB_ICONERROR);
          result:= false;
        end;
      finally
        close;
      end;
    end;
end;

function TDrillsForm.isExistedDrill(aProjectNo, aDrillNo: string): boolean;
begin
  with MainDataModule.qryDrills do
    begin
      close;
      sql.Clear;
      sql.Add('SELECT prj_no,drl_no FROM drills WHERE prj_no='+ ''''+stringReplace(aProjectNo ,'''','''''',[rfReplaceAll])+'''');
      sql.Add(' AND drl_no='+ ''''+stringReplace(aDrillNo ,'''','''''',[rfReplaceAll])+'''');
      try
        try
          Open;
          if eof then 
            result:=false
          else
          begin
            result:=true;
            messagebox(self.Handle,'此编号已经存在，请输入新的编号！','数据校对',mb_ok);  
            edtdrl_no.SetFocus;
          end;
        except
          result:=false;
        end;
      finally
        close;
      end;
    end;
end;

procedure TDrillsForm.btn_addClick(Sender: TObject);
begin
  Clear_Data(self);
  chk_Can_jueSuan.State := cbChecked ;
  chk_can_tongji.State := cbChecked ;
  chk_IsJieKong.State := cbUnchecked;
  Button_status(3,true);
  DrawDrill;
  edtDrl_no.SetFocus;
end;

procedure TDrillsForm.cboD_t_nameChange(Sender: TObject);
begin
  cboD_t_no.ItemIndex:= cboD_t_name.ItemIndex;
  cboD_t_type.ItemIndex:= cboD_t_name.ItemIndex;
  setComponentVisible(cboD_t_type.Text);
         

end;
procedure TDrillsForm.Update_earthSample;
var
  strSQLWhere, strSQLSet, strSQL: string;
begin
  strSQLWhere:=' WHERE prj_no='+''''+g_ProjectInfo.prj_no_ForSQL+''''
           +' AND drl_no =' +''''+ stringReplace(sgDrills.Cells[1,sgDrills.Row],'''','''''',[rfReplaceAll])+'''';
  strSQLSet:='UPDATE earthsample SET drl_no=' +''''+stringReplace(trim(edtDrl_no.Text),'''','''''',[rfReplaceAll])+'''';
  strSQL :=  strSQLSet + strSQLWhere ;
  with MainDataModule.qryDrills do
    begin
      close;
      sql.Clear;
      sql.Add(strSQL);
      try
        try
          ExecSQL;
        except
          MessageBox(self.Handle,'数据库错误，更新土试数据失败。','数据库错误',MB_OK+MB_ICONERROR);
        end;
      finally
        close;
      end;
    end;

end;
procedure TDrillsForm.btn_okClick(Sender: TObject);
var
  strSQL: string; 
begin
  if not Check_Data then exit;
  if m_DataSetState = dsInsert then
    begin
      if isExistedDrill(g_ProjectInfo.prj_no,trim(edtDrl_no.Text)) then exit;
      strSQL := GetInsertSQL;
      if Insert_oneDrillRecord(strSQL) then
        begin
          if (sgDrills.RowCount =2) and (sgDrills.Cells[1,1] ='') then
            begin
              m_iGridSelectedRow:= sgDrills.RowCount-1;
            end
          else
            begin
              sgDrills.Tag := 1;
              m_iGridSelectedRow := sgDrills.RowCount;
              sgDrills.RowCount := sgDrills.RowCount+2;
              sgDrills.RowCount := sgDrills.RowCount-1;
            end;
          sgDrills.Row := sgDrills.RowCount-1;
          sgDrills.Tag := 0;
          sgDrills.Cells[1,sgDrills.RowCount-1] := trim(edtDrl_no.Text);
          sgDrills.Cells[2,sgDrills.RowCount-1] := trim(cboD_t_name.Text);
          
          Button_status(1,true);
          btn_add.SetFocus;
        end;
    end
  else if m_DataSetState = dsEdit then
    begin
      if sgDrills.Cells[1,sgDrills.Row]<>trim(edtDrl_no.Text) then
        if isExistedDrill(g_ProjectInfo.prj_no,trim(edtDrl_no.Text)) then exit;
      strSQL := self.GetUpdateSQL;
      if self.Update_oneDrillRecord(strSQL) then
        begin
          Update_earthSample;
          sgDrills.Cells[1,sgDrills.Row] := edtDrl_no.Text ;
          sgDrills.Cells[2,sgDrills.Row] := cboD_t_name.Text ;
          // 开始更新土试数据的钻孔，因为钻孔表和土试表没有关联键（没有钻孔时也能导入土试数据）

          Button_status(1,true);
          btn_add.SetFocus;
        end;
    end;

end;

function TDrillsForm.GetInsertSQL: string;
var 
  strSQLFields,strSQLValues,strSQL:string;
  strFieldName: string;
  i:integer;
begin
  strSQLFields:='prj_no,';
  strSQLValues:=''''+g_ProjectInfo.prj_no_ForSQL +''''+',';
  strFieldName:='';
  strSQL:='';
  for i:=0 to self.ComponentCount-1 do
  begin
    if Components[i] is TEdit then
    begin
      if (trim(TEdit(Components[i]).Text) <>'') and (TEdit(Components[i]).Visible) then
      begin
        strFieldName:= copy(Components[i].Name,4,length(Components[i].Name)-3);
        strSQLFields := strSQLFields + strFieldName + ',';
        strSQLValues := strSQLValues +''''+stringReplace(trim(TEdit(Components[i]).Text),'''','''''',[rfReplaceAll])+''''+',';
      end;
    end;   
  end;
//2005/07/13 yys add 加钻孔是否参与决算
  strSQLFields := strSQLFields + 'can_juesuan,' ;
  if chk_Can_jueSuan.State = cbChecked then
      strSQLValues := strSQLValues + BOOLEAN_True+','
  else
      strSQLValues := strSQLValues + BOOLEAN_False+',' ;
//2005/07/13 yys
//2008/11/21 yys add 加钻孔是否参与各种表格的统计。土分析分层总表、物理力学表
  strSQLFields := strSQLFields + 'can_tongji,' ;
  if chk_Can_tongji.State = cbChecked then
      strSQLValues := strSQLValues + BOOLEAN_True+','
  else
      strSQLValues := strSQLValues + BOOLEAN_False+',' ;
//2008/11/21 yys

//2012/01/04 yys add 加钻孔是否是借的孔
  strSQLFields := strSQLFields + 'isJieKong,' ;
  if chk_IsJieKong.State = cbChecked then
      strSQLValues := strSQLValues + BOOLEAN_True+','
  else
      strSQLValues := strSQLValues + BOOLEAN_False+',' ;
//2012/01/04 yys
    
  strSQLFields := strSQLFields + 'D_t_no' ;
  strSQLValues := strSQLValues + ''''+cboD_t_no.Text+'''';//2004/06/23 hyg
  if dtpBegin_date.Visible then
  begin
    strSQLFields := strSQLFields +','+ 'Begin_date' +',';
    strSQLValues := strSQLValues +','+ ''''+Datetostr(dtpBegin_date.Date)+''''+',';
    strSQLFields := strSQLFields + 'End_date';
    strSQLValues := strSQLValues +''''+Datetostr(dtpEnd_date.Date)+'''';
  end;
  if cboBorer_name.Visible then
  begin
    strSQLFields := strSQLFields +','+ 'borer_no';
    strSQLValues := strSQLValues +','+''''+cboBorer_no.Text+'''';
  end;
  strSQL := 'INSERT INTO drills ('+strSQLFields+') VALUES(' +strSQLValues+')';  
  result := strSQL;
end;

procedure TDrillsForm.edtDrl_noKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  change_focus(key,self);
end;

procedure TDrillsForm.cboD_t_nameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then
    postMessage(self.Handle, wm_NextDlgCtl,0,0);
end;

procedure TDrillsForm.dtpEnd_dateKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then
    postMessage(self.Handle, wm_NextDlgCtl,0,0);
end;

procedure TDrillsForm.btn_editClick(Sender: TObject);
begin
  if btn_edit.Caption ='修改' then
  begin  
    Button_status(2,true);
    edtDrl_elev.SetFocus;
  end
  else
  begin
    clear_data(self);
    Button_status(1,true);
    Get_oneDrillRecord(g_ProjectInfo.prj_no,sgDrills.Cells[1,sgDrills.row]);
  end;
end;

function TDrillsForm.GetUpdateSQL: string;
var 
  strSQLWhere,strSQLSet,strSQL:string;
  strFieldName: string;
  i:integer;
begin
  strSQLWhere:=' WHERE prj_no='+''''+g_ProjectInfo.prj_no_ForSQL+''''
               +' AND drl_no =' +''''+ stringReplace(sgDrills.Cells[1,sgDrills.Row],'''','''''',[rfReplaceAll])+'''';
  strSQLSet:='UPDATE drills SET ';
  strFieldName:='';
  strSQL:='';
  for i:=0 to self.ComponentCount-1 do
  begin
    if Components[i] is TEdit then
    begin
//yys 2006/08/31 修改原因，机钻取土孔中初见水位及稳定水位输入数据后无法删除（删除保存后再打开还有）
//      if (trim(TEdit(Components[i]).Text) <>'') and (TEdit(Components[i]).Visible) then
      if TEdit(Components[i]).Visible then
//yys 2006/08/31 结束修改
      begin
          strFieldName:= copy(Components[i].Name,4,length(Components[i].Name)-3);
          if trim(TEdit(Components[i]).Text)<>'' then
              strSQLSet := strSQLSet + strFieldName+'='+''''+stringReplace(trim(TEdit(Components[i]).Text),'''','''''',[rfReplaceAll])+''''+','
          else
              strSQLSet := strSQLSet + strFieldName+'=null,';
      end;
    end;   
  end;
//2005/07/13 yys add 加钻孔是否参与决算
  if chk_Can_jueSuan.State = cbChecked then
      strSQLSet := strSQLSet + 'can_juesuan = 0,'
  else
      strSQLSet := strSQLSet + 'can_juesuan = 1,' ;
//2005/07/13 yys

//2008/11/21 yys add 加钻孔是否参与各种表格的统计。土分析分层总表、物理力学表
  if chk_Can_tongji.State = cbChecked then
      strSQLSet := strSQLSet + 'can_tongji = 0,'
  else
      strSQLSet := strSQLSet + 'can_tongji = 1,' ;
//2008/11/21 yys

//2012/01/04 yys add 加钻孔是否是借的孔
  if chk_IsJieKong.State = cbChecked then
      strSQLSet := strSQLSet + 'isJieKong = '+ BOOLEAN_True+','
  else
      strSQLSet := strSQLSet + 'isJieKong = '+ BOOLEAN_False+',' ;
//2012/01/04 yys


  if dtpBegin_date.Visible then
  begin
      strSQLSet := strSQLSet + ' Begin_date' +'='+''''+Datetostr(dtpBegin_date.Date)+''''+',';
      strSQLSet := strSQLSet + ' End_date'+'='+''''+Datetostr(dtpEnd_date.Date)+''''+',';
  end;
  if cboBorer_name.Visible then
      strSQLSet := strSQLSet + ' borer_no'+'='+''''+cboBorer_no.Text+''''+',';

  strSQLSet := strSQLSet + ' D_t_no' +'='+''''+cboD_t_no.Text+'''';
  strSQL := strSQLSet+strSQLWhere;
  result := strSQL;
end;

procedure TDrillsForm.DrawDrill;
var
  rTop,rBottom,rTemp: double;
begin
  rTop   := m_DrillDiagram.DrillTop;
  rBottom:= m_DrillDiagram.DrillBottom ;
  
  m_DrillDiagram.clear;
  m_DrillDiagram.DrawDrillDiagram(false); 
  //m_DrillDiagram.SetTopBottom(100,50);
  if (trim(edtDrl_elev.Text) <>'') and (trim(edtDrl_elev.Text) <>'-') then
  begin
    rTemp := strtofloat(edtDrl_elev.Text);
    m_DrillDiagram.DrillStandHeigh := rTemp;
    if rTemp>rTop then
      m_DrillDiagram.SetTopBottom(rTemp,rBottom)
    else
      m_DrillDiagram.SetTopBottom(rTop,rBottom);
    
  end;
  if (trim(edtBushing_diam.Text) <>'') and (trim(edtBushing_diam.Text) <>'-') then
    m_DrillDiagram.PipeDiameter:= strtofloat(edtBushing_diam.Text)*100;
  if (trim(edtComp_depth.Text) <>'') and (trim(edtComp_depth.Text) <>'-') then
     m_DrillDiagram.FinishDepth := strtofloat(edtComp_depth.Text);
  if (trim(edtFirst_elev.Text) <>'') and (trim(edtFirst_elev.Text) <>'-') then
     m_DrillDiagram.FirstWaterHeigh:= abs(strtofloat(edtFirst_elev.Text));
  if (trim(edtStable_elev.Text) <>'') and (trim(edtStable_elev.Text) <>'-') then
     m_DrillDiagram.StableWaterHeigh:= abs(strtofloat(edtStable_elev.Text));

  if (trim(edtDrl_x.Text) <>'') then
     m_DrillDiagram.DrillX:= strtofloat(edtDrl_x.Text);
  if (trim(edtDrl_y.Text) <>'') then
     m_DrillDiagram.DrillY:= strtofloat(edtDrl_y.Text);
 
end;

procedure TDrillsForm.edtDrl_elevChange(Sender: TObject);
begin
  if m_DataSetState in [dsEdit,dsInsert] then
    DrawDrill;
end;

function TDrillsForm.GetDeleteSQL: string;
begin
  result :='DELETE FROM drills '
           +'WHERE prj_no='+ ''''+g_ProjectInfo.prj_no_ForSQL+'''' 
           +' AND drl_no='+ ''''+stringReplace(edtDrl_no.Text,'''','''''',[rfReplaceAll])+'''';
end;

procedure TDrillsForm.edtDrl_elevKeyPress(Sender: TObject; var Key: Char);
begin
  NumberKeyPress(sender,key,true);
end;

procedure TDrillsForm.Get_BorerType;
begin
  self.cboBorer_no.Clear;
  self.cboBorer_name.Clear;
  with MainDataModule.qryBorer do
    begin
      close;
      sql.Clear;
      sql.Add('Select borer_no,borer_name FROM borer');
      open;
      
      while not Eof do
      begin
        self.cboBorer_no.Items.Add(FieldByName('borer_no').AsString);
        self.cboBorer_name.Items.Add(FieldByName('borer_name').AsString);
        Next;
      end;
    end;
end;

procedure TDrillsForm.cboBorer_nameChange(Sender: TObject);
begin
  cboBorer_no.ItemIndex:= cboBorer_name.ItemIndex;
end;

procedure TDrillsForm.cboBorer_nameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then
    postMessage(self.Handle, wm_NextDlgCtl,0,0);
end;

procedure TDrillsForm.edtComp_depthKeyPress(Sender: TObject;
  var Key: Char);
begin
    if (key = chr(vk_space)) or (key='-') then key :=#0;
end;

procedure TDrillsForm.edtDrl_noExit(Sender: TObject);
begin
    edtDrl_no.Text := uppercase(leftbstr(edtDrl_no.Text,1))
    +rightbstr(edtDrl_no.Text,length(edtDrl_no.Text)-1);
end;

procedure TDrillsForm.edtFirst_elevKeyPress(Sender: TObject;
  var Key: Char);
begin
  NumberKeyPress(sender,key,false);
end;

procedure TDrillsForm.setComponentVisible(aDrillType: string);
var
  CanVisible: boolean;
begin
  if (aDrillType = 'A') or (aDrillType = 'C') then
    CanVisible:= true
  else
    CanVisible:= false;
  edtDrl_x.Visible := CanVisible;
  lblDrl_x.Visible := CanVisible;
  edtDrl_y.Visible := CanVisible;
  lblDrl_y.Visible := CanVisible;
  dtpBegin_date.Visible := CanVisible;
//  if DateToStr(dtpBegin_date.Date) ='' then
//    dtpBegin_date.DateTime := now;
  lblBegin_date.Visible := CanVisible;
  dtpEnd_date.Visible := CanVisible;
//  if DateToStr(dtpEnd_date.Date)='' then
//  dtpEnd_date.DateTime := now;
  lblEnd_date.Visible := CanVisible;
  edtFirst_elev.Visible := CanVisible;
  lblFirst_elev.Visible := CanVisible;
  edtStable_elev.Visible := CanVisible;
  lblStable_elev.Visible := CanVisible;
  edtwcy_first_elev.Visible := CanVisible;
  lblwcy_first_elev.Visible := CanVisible;
  edtwcy_stable_elev.Visible := CanVisible;
  lblwcy_stable_elev.Visible := CanVisible ;
  if aDrillType = 'C' then
  begin
      dtpBegin_date.Visible := false;
      lblBegin_date.Visible := false;
      dtpEnd_date.Visible := false;
      lblEnd_date.Visible := false; 
      edtFirst_elev.Visible := false;
      lblFirst_elev.Visible := false;
      edtStable_elev.Visible := false;
      lblStable_elev.Visible := false;
      edtwcy_first_elev.Visible := false;
      lblwcy_first_elev.Visible := false;
      edtwcy_stable_elev.Visible := false;
      lblwcy_stable_elev.Visible := false ;
  end;
     

  edtDrl_lczh.Visible := CanVisible;
  lblDrl_lczh.Visible := CanVisible;
//2008/12/15 yys edit 小螺纹钻孔（麻花钻），勘察院要求加上里程桩号
  if aDrillType = 'B' then
  begin
      edtDrl_lczh.Visible := true;
      lblDrl_lczh.Visible := true;
  end;
//2008/12/15 yys edit END
  edtBushing_diam.Visible := False;
  lblBushing_diam.Visible := False; 
  edtBegin_cal.Visible := False;
  lblBegin_cal.Visible := False;
  edtEnd_Cal.Visible := False;
  lblEnd_Cal.Visible := False;
  cboBorer_name.Visible := False;
  lblBorer_name.Visible := False;
end;

procedure TDrillsForm.btn_AllTongJiClick(Sender: TObject);
var
  strSQL: string;
begin
  strSQL := 'UPDATE drills SET can_tongji=0 Where prj_no='+''''+g_ProjectInfo.prj_no_ForSQL+'''';
  if self.Update_oneDrillRecord(strSQL) then
    begin
      if sgDrills.Cells[1,sgDrills.Row]<>'' then;
         chk_can_tongji.Checked := true;
    end;
end;

procedure TDrillsForm.btn_allNoTongJiClick(Sender: TObject);
var
  strSQL: string;
begin
  strSQL := 'UPDATE drills SET can_tongji=1 Where prj_no='+''''+g_ProjectInfo.prj_no_ForSQL+'''';
  if self.Update_oneDrillRecord(strSQL) then
    begin
      if sgDrills.Cells[1,sgDrills.Row]<>'' then;
         chk_can_tongji.Checked := false;
    end;
end;

end.
