unit public_unit;
interface

uses Graphics,SysUtils,forms,windows,messages,DB, ADODB,
     stdctrls,comctrls,Classes, dialogs,
     Grids,
      rxToolEdit, rxCurrEdit, math, strUtils, Inifiles;

const HINT_TEXT         :PAnsiChar='提示';
const TABLE_ERROR       :PAnsiChar='数据库出错，无法读入数据！';
const DBERR_NOTSAVE     :PAnsiChar='数据库错误，无法插入/更新数据！';
const DBERR_NOTREAD     :PAnsiChar='数据库错误，无法正确读取数据！';
const DBERR_NOTDEL      :PAnsiChar='数据库错误，无法删除数据！';
const DEL_CONFIRM       :PAnsiChar='确定删除当前记录吗？';
const REPORT_SUCCESS    :PAnsiChar='成功生成决算报表！';
const REPORT_FAIL       :PAnsiChar='决算报表生成失败！';
const REPORT_OPEN_FAIL  :PAnsiChar='决算报表打开失败！';
const EXCEL_NOTINSTALL  :PAnsiChar='未安装Excel!';
const REPORT_PROCCESS   :PAnsiChar='正在生成决算报表，请稍候...';
const FILE_SAVE_TITLE   :PAnsiChar='决算报表保存';
const FILE_SAVE_TITLE_GZL :PAnsiChar='工作量统计表保存';
const FILE_SAVE_FILTER  :PAnsiChar='Excel文件(*.csv;*.xls)|*.xls;*.csv|Excel文件(*.xls)|*.xls|Excel文件(*.csv)|*.csv';
const FILE_NOTEXIST     :PAnsiChar='文件不存在！';
const FILE_EXIST        :PAnsiChar='文件已经存在，是否覆盖该文件？';
const FILE_DELERR       :PAnsiChar='无法删除(覆盖)文件！';
const EXCEL_ERROR       :PAnsiChar='EXCEL运行中出错，无法生成报表！';
const REPORT_TITLE      :String   ='岩土工程勘察决算表';
const BACKUP_PROJECT_FILE_EXT:string='bak';

const REPORT_PRINT_SPLIT_CHAR: string='^'; //
//为了适应多语言报表的需要，在写INI文件时，
//土层名称是中文加分隔符加外文，例如：素填土^plain fill

type TTongJiFlags = set of (tfTuYang, tfJingTan, tfBiaoGuan, tfTeShuYang, tfTeShuYangBiaoZhuZhi, tfOther);

//在特征数表tezhengshuTmp中v_id字段对应的值
const TEZHENSHU_Flag_PingJunZhi : string='1';
const TEZHENSHU_Flag_BiaoZhunCha: string='2';
const TEZHENSHU_Flag_BianYiXiShu: string='3';
const TEZHENSHU_Flag_MaxValue   : string='4';
const TEZHENSHU_Flag_MinValue   : string='5';
const TEZHENSHU_Flag_SampleNum  : string='6';
const TEZHENSHU_Flag_BiaoZhunZhi: string='7';

//在所有数据表中代表是否的字段对应的值，（是，值是0）（否，值是1）
const BOOLEAN_True : string = '0';
const BOOLEAN_False: string = '1';

type
  TAnalyzeResult=record
    PingJunZhi: double; //平均值
    BiaoZhunCha: double;//标准差
    BianYiXiShu: double;//变异系数
    MaxValue: double;//最大值
    MinValue: double;//最小值
    SampleNum: integer;//样本数
    BiaoZhunZhi:double;//标准值
    FormatString: string; //格式化字符,如'0.00','0.0'
    lstValues: TStringList; //保存所有的值，用来做计算用，因为有不合条件的值会被付空值，所以要用另一个StringList来保存同样的值。
    lstValuesForPrint: TStringList;
    FieldName: String;  //
    //字段名，在土分析分层总表的特征数计算时，因为有关联剔除，所以压根要用名字做标记，其他表的计算可以不设此值
//yys 2005/06/15 add, 当一层只有一个样时，标准差和变异系数不能为0，打印报表时要用空格，物理力学表也一样。
    //strBiaoZhunCha: string;
    //strBianYiXiShu: string;
//yys 2005/06/15
  end;

//报表打印时的语言，暂时有中文和英文两种
type TReportLanguage =(trChineseReport, trEnglishReport); //

const GongMinJian ='0'; //工民建
const LuQiao ='1'; //路桥

const JiZuanQuTuKong = '1'; ////机钻取土孔

//打印到MiniCAD画图程序的报表的标识
const PrintChart_Section         :PAnsiChar='1'; //工程地质剖面图
const PrintChart_ZhuZhuangTu     :PAnsiChar='2'; //钻孔柱状图 工民建
const PrintChart_CPT_ShuangQiao  :PAnsiChar='3'; //双桥钻孔静力触探成果表
const PrintChart_Buzhitu         :PAnsiChar='4'; //工程勘察点平面布置图
const PrintChart_Legend          :PAnsiChar='5'; //图例打印
const PrintChart_CrossBoard      :PAnsiChar='6'; //十字板剪切试验曲线图
const PrintChart_CPT_DanQiao     :PAnsiChar='7'; //单桥钻孔静力触探成果表
const PrintChart_FenCengYaSuo    :PAnsiChar='8'; //分层压缩曲线
const PrintChart_ZhuZhuangTuZhiFangTu     :PAnsiChar='9'; ////钻孔柱状图,带直方图格式 工民建
const PrintChart_ZhuZhuangTuShuangDa2        :PAnsiChar='10'; ////钻孔柱状图,带直方图格式 两个孔并排打印
const PrintChart_ZhuZhuangTuShuangDa1        :PAnsiChar='11'; ////钻孔柱状图,带直方图格式 单孔并排打印

type
  TProjectInfo=class(TObject)
  private
    FPrj_no: string;
    FPrj_no_ForSQL: string;
    FPrj_name: string;
    FPrj_name_en:string;
    FPrj_type: string;
    FPrj_ReportLanguage: TReportLanguage;
    FPrj_ReportLanguageString: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure setProjectInfo(aPrj_no,aPrj_name,aPrj_name_en,aPrj_type: string);
    procedure setReportLanguage(aReportLanguage: TReportLanguage);
    property prj_no :string read FPrj_no;       //工程编号
    property prj_no_ForSQL:string read FPrj_no_ForSQL; //工程编号，为了插入数据库中，替换了真正工程编号中的单引号
    property prj_name:string read FPrj_name;      //工程名称
    property prj_name_en:string read FPrj_name_en;      //工程英文名称
    property prj_type:string read FPrj_type;      //工程类型
    property prj_ReportLanguage: TReportLanguage read FPrj_ReportLanguage;
    property prj_ReportLanguage_String: string read FPrj_ReportLanguageString;
end;

type TZKLXBianHao=record  //钻孔类型编号
  ShuangQiao: string;  //双桥编号
  DanQiao   : string;  //单桥编号
  XiaoZuanKong:string; //小螺纹钻孔（也称作麻花钻）
  end;  

type TAppInfo=record
  PathOfReports: string;     //报表文件存放的路径
  PathOfChartFile: string;  //剖面图等的文本文件存放路径
  CadExeName: string;        //画CAD图的应用程序的路径+程序名(f:\minicad.exe)
  CadExeNameEn:string;       //画CAD图的应用程序的路径+英文程序名(f:\minicad_en.exe)
  PathOfIniFile: string;    //Server.ini 文件的存放路径(f:\server.ini)
end;
const g_cptIncreaseDepth=0.1;  //静力触探每次进入的深度为0.1m

var
  g_ProjectInfo : TProjectInfo; //保存当前打开的工程的工程信息
  //g_Project_no:string;  //保存当前打开的工程的工程编号
  g_AppInfo : TAppInfo; //保存应用程序的一些信息。
  g_ZKLXBianHao: TZKLXBianHao;  //保存钻孔类型表中的钻孔编号

  //将窗口上的所有Label的Transparent属性设为True
  procedure setLabelsTransparent(aForm: TForm);
  //根据在窗口上的按键不同来改变焦点位置。
  procedure change_focus(key:word;frmCurrent: TCustomForm);
  //删除一个StringGrid的一行。
  procedure DeleteStringGridRow(aStringGrid:TStringGrid;aRow:integer);
  
  //清除窗体的一些类型的控件内容，如Edit.Text='',ComboBox.ItemIndex=-1
  procedure Clear_Data(frmCurrent: TCustomForm);
  
  //控制窗体的一些控件可用不可用。
  procedure Enable_Components(frmCurrent:TCustomForm;bEnable:boolean);

  //AlignGridCell,改变StringGrid中某一CELL中的文字水平方向排列方式,同时在垂直方向居中.
  procedure AlignGridCell(AStringGrid:TObject;ACol, ARow:Integer;
   ARect: TRect; Alignment: TAlignment);
  
  //处理数据库的删除、增加、修改操作。
  function Delete_oneRecord(aADOQuery: TADOQuery;strSQL:string):boolean;
  function Update_oneRecord(aADOQuery: TADOQuery;strSQL:string):boolean;
  function Insert_oneRecord(aADOQuery: TADOQuery;strSQL:string):boolean;
  //判断一笔记录在数据库中是否存在。
  function isExistedRecord(aADOQuery: TADOQuery;strSQL:string): boolean; 

  //NumberKeyPress 控制edit控件的的输入，edit中的内容只能是整数或浮点数据.
  //Sender一般为TEdit控件，Key为按下的键值,yunshufuhao是否允许输入负号
  procedure NumberKeyPress(Sender: TObject;var Key: Char; yunshufuhao : boolean);

  //把十六进制字符串转换为TBits
  function HexToBits(aStr:string):TBits;
  //把以分隔符分开的字符串分开放入StringList中。
  procedure DivideString(str,separate:string;var str_list:TStringList);
  
  //把以分隔符分开的字符串分开放入StringList中,其中为空的字符串不放入.
  //如'1,2,,3'这个字符串，用这个过程分开的话会得到一个有三行的StringList
  procedure DivideStringNoEmpty(str,separate:string;var str_list:TStringList);
  function isFloat(ANumber: string): boolean;
  function isInteger(ANumber: string): boolean;
  procedure SetListBoxHorizonbar(aListBox: TCustomListBox);
  
  //判断一个串在一个字符串列表中的位置，并返回位置值（-1--表示列表不没有此串）
  function PosStrInList(aStrList:TStrings;aStr:string):integer;

  //返回一个字符串在另一个字符串中最后出现的位置
  function PosRightEx(const SubStr,S:AnsiString;const Offset:Cardinal=MaxInt):Integer;

  function ComSrtring(aValue,aLen:integer):string;
  function ReopenQryFAcount(aQuery:tadoquery;aSQLStr:string):boolean;
  function SumMoney(aADOQry:tadoquery;aFieldName:string):double;
  procedure EditFormat(aEdit:tedit);
  procedure SetCBWidth(aCBox:tcombobox);

  function getCadExcuteName: string;
  //getCptAverageByDrill
  //从静探表中计算一个孔的每一层的qc和fs的平均值，保存在两个字符串中，每个值用逗号隔开
  procedure getCptAverageByDrill(aDrillNo:string;var aQcAverage,aFsAverage:
  string);
  function AddFuHao(aStr:string):string;
  procedure FenXiFenCeng_TuYiangJiSuan;
  procedure FenXiFenCeng_TeShuYiangJiSuan;
  //在最近版本的 Delphi Pascal 编译器中，Round 函数是以 CPU 的 FPU (浮点部件) 处理器为基础的。
  //这种处理器采用了所谓的 "银行家舍入法"，即对中间值 (如 5.5、6.5) 实施 Round 函数时，
  //处理器根据小数点前数字的奇、偶性来确定舍入与否，如 5.5 Round 结果为 6，而 6.5 Round 结果也为 6, 因为 6 是偶数。
  function DoRound(Value: Extended):Int64;

  function iif(ATest: Boolean; const ATrue: Integer; const AFalse: Integer): Integer; overload;
  function iif(ATest: Boolean; const ATrue: string;  const AFalse: string): string; overload;
  function iif(ATest: Boolean; const ATrue: Boolean; const AFalse: Boolean): Boolean; overload;


implementation

uses MainDM,SdCadMath;

//Delphi 的 Round 函数使用的是银行家算法(Banker's Rounding)
//Round() 的结果并非通常意义上的四舍五入
//If X is exactly halfway between two whole numbers,
//the result is always the even number.
//对于 XXX.5 的情况，整数部分是奇数，那么会 Round Up，偶数会 Round Down，例如：
//x:= Round(17.5) 相当于 x = 18
//x:= Round(12.5) 相当于 x = 12
//做四舍五入处理时请使用 DRound 函数代替 Round
function DoRound(Value: Extended): Int64;
begin
  if Value >= 0 then Result := Trunc(Value + 0.5)
  else Result := Trunc(Value - 0.5);
end;

function iif(ATest: Boolean; const ATrue: Integer; const AFalse: Integer): Integer;
begin
  if ATest then begin
    Result := ATrue;
  end else begin
    Result := AFalse;
  end;
end;

function iif(ATest: Boolean; const ATrue: string; const AFalse: string): string;
begin
  if ATest then begin
    Result := ATrue;
  end else begin
    Result := AFalse;
  end;
end;

function iif(ATest: Boolean; const ATrue: Boolean; const AFalse: Boolean): Boolean;
begin
  if ATest then begin
    Result := ATrue;
  end else begin
    Result := AFalse;
  end;
end;

function getCadExcuteName: string;
begin
  if g_ProjectInfo.prj_ReportLanguage= trChineseReport then
    result := g_AppInfo.CadExeName
  else if g_ProjectInfo.prj_ReportLanguage= trEnglishReport then
    result := g_AppInfo.CadExeNameEn;
end;

procedure setLabelsTransparent(aForm: TForm);
var
  i: integer;
  myComponent: TComponent;
begin
  for i:=0 to aForm.ComponentCount-1 do
  begin
    myComponent:= aForm.Components[i]; 
    if myComponent is TLabel then
      TLabel(myComponent).Transparent := True;    
  end;
end;

//当按回车和向下箭头时移动光标到下一控件，向上箭头时移动光标到上一控件。
procedure change_focus(key:word;frmCurrent: TCustomForm);
begin
  if (key=VK_DOWN) or (key=VK_RETURN) then
    postMessage(frmCurrent.Handle, wm_NextDlgCtl,0,0);
  if key=VK_UP then
    postmessage(frmCurrent.handle,wm_nextdlgctl,1,0);
end;

procedure DeleteStringGridRow(aStringGrid:TStringGrid;aRow:integer);
const
 MaxColCount=100; //一般说来，不会有StringGrid的列超过100列，
                       //这样做是因为有时候隐藏列超出了ColCount,删除数据时不完全;
var
  iCol, iRow:integer;
begin
  if (aRow<1) or (aRow>aStringGrid.RowCount-1) then exit;
  if aStringGrid.RowCount =2 then
  begin
    for iCol:= 0 to MaxColCount do
      aStringGrid.cells[iCol,1] :=''; 
    exit;
  end; 
  if aRow <> aStringGrid.RowCount -1 then
    for iRow := aRow to aStringGrid.RowCount  - 2 do
      for iCol:= 0 to MaxColCount -1 do
        aStringGrid.Cells[iCol,iRow] := aStringGrid.Cells[iCol,iRow+1];
  aStringGrid.RowCount := aStringGrid.RowCount -1;
end;

procedure Clear_Data(frmCurrent: TCustomForm);
var 
  i: integer;
begin
  with frmCurrent do
    for i:=0 to frmCurrent.ComponentCount-1 do
      begin
        if components[i] is TEdit then
          TEdit(components[i]).text:=''
        else if components[i] is TComboBox then
            TComboBox(components[i]).ItemIndex := -1
        else if components[i] is TMemo then
          TMemo(components[i]).Text := ''          
        else if components[i] is TCurrencyEdit then
          TCurrencyEdit(components[i]).Text := ''          
        else if components[i] is TDateTimePicker then
          TDateTimePicker(components[i]).Date :=Now; 
      end;
end;

procedure Enable_Components(frmCurrent:TCustomForm;bEnable:boolean);
var 
  i: integer;
begin
  with frmCurrent do
    for i:=0 to frmCurrent.ComponentCount-1 do
      begin
        if components[i] is TEdit then
          TEdit(components[i]).Enabled := bEnable
        else if components[i] is TCurrencyEdit then
          TCurrencyEdit(components[i]).Enabled := bEnable
        else if components[i] is TComboBox then
          TComboBox(components[i]).Enabled := bEnable
        else if components[i] is TMemo then
          TMemo(components[i]).Enabled := bEnable
        else if components[i] is TListBox then
          TListBox(components[i]).Enabled := bEnable
        else if components[i] is TDateTimePicker then
          TDateTimePicker(components[i]).Enabled :=bEnable
        else if components[i] is TRadioButton then
          TRadioButton(components[i]).Enabled := bEnable
        else if components[i] is TCheckBox then
          TCheckBox(components[i]).Enabled := bEnable
        else if components[i] is TLabel then
          TLabel(components[i]).Enabled := bEnable;

      end;
end;

function Delete_oneRecord(aADOQuery: TADOQuery;strSQL: string): boolean;
begin
  with aADOQuery do
    begin
      close;
      sql.Clear;
      sql.Add(strSQL);

      try
        try
          ExecSQL;
          //MessageBox(application.Handle,'删除成功！','删除数据',MB_OK+MB_ICONINFORMATION);
          result := true;
        except
          MessageBox(application.Handle,'数据库错误，不能删除所选数据。','数据库错误',MB_OK+MB_ICONERROR);
          result := false;
        end;
      finally
        close;
      end;
    end;
end;

function Update_oneRecord(aADOQuery: TADOQuery;strSQL:string):boolean;
begin
  with aADOQuery do
    begin
      close;
      sql.Clear;
      sql.Add(strSQL);
      try
        try
          ExecSQL;
          //MessageBox(application.Handle,'更新数据成功！','更新数据',MB_OK+MB_ICONINFORMATION);
          result := true;
        except
          //MessageBox(application.Handle,'数据库错误，更新数据失败。','数据库错误',MB_OK+MB_ICONERROR);
          result:= false;
        end;
      finally
        close;
      end;
    end;
end;

function Insert_oneRecord(aADOQuery: TADOQuery;strSQL:string):boolean;
var
  ini_file:TInifile;
begin
  with aADOQuery do
    begin
      close;
      sql.Clear;
      sql.Add(strSQL);
      try
        try
          ExecSQL;
          //MessageBox(application.Handle,'增加数据成功！','增加数据',MB_OK+MB_ICONINFORMATION);
          result := true;
        except
          MessageBox(application.Handle,'数据库错误，增加数据失败。','数据库错误',MB_OK+MB_ICONERROR);
  ini_file := TInifile.Create(g_AppInfo.PathOfIniFile);
  ini_file.WriteString('SQL','error',strSQL);
  ini_file.Free;
          result:= false;
        end;
      finally
        close;
      end;
    end;
end;


function isExistedRecord(aADOQuery: TADOQuery;strSQL:string): boolean;
begin
  with aADOQuery do
    begin
      close;
      sql.Clear;
      sql.Add(strSQL);
      try
        try
          Open;
          if eof then 
            result:=false
          else
            result:=true;
        except
          result:=false;
        end;
      finally
        close;
      end;
    end;  
end;

procedure NumberKeyPress(Sender: TObject;var Key: Char; yunshufuhao : boolean);
var
  strHead,strEnd,strAll,strFraction:string;
  iDecimalSeparator:integer;
  
begin
  //如果是整数，直接屏蔽掉小数点。
  if (TEdit(Sender).Tag=0) and (key='.') then
  begin
    key:=#0;
    exit;
  end;
  //屏蔽掉负号。
  if (not yunshufuhao) and (key='-') then 
  begin
    key:=#0;
    exit;
  end;
  //屏蔽掉科学计数法。
  if (lowercase(key)='e') or (key=' ') or(key='+') then
  begin
    key:=#0;
    exit;
  end;

  if key =chr(vk_back) then exit;
  
  try
    strHead := copy(TEdit(Sender).Text,1,TEdit(Sender).SelStart);
    strEnd  := copy(TEdit(Sender).Text,TEdit(Sender).SelStart+TEdit(Sender).SelLength+1,length(TEdit(Sender).Text));
    strAll := strHead+key+strEnd;
    
    if (strAll)='-' then
      begin
         TEdit(Sender).Text :='-';
         TEdit(Sender).SelStart :=2;
         key:=#0;
         exit;
      end;
      
    strtofloat(strAll);
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

function HexToBits(aStr:string):TBits;
var
   i,data,j,rst,inx,l:integer;
   aBits:TBits;
   c:char;
begin
   aBits:=TBits.Create ;
   aBits.Size :=1024;
   inx:=0;
   l:=length(aStr);
   for i:=1 to l do
   begin
      c:=aStr[i];
      case c of
         'f','F':data:=15;
         'e','E':data:=14;
         'd','D':data:=13;
         'c','C':data:=12;
         'b','B':data:=11;
         'a','A':data:=10
      else
         data:=byte(c)-48;
      end;
      rst:=data;
      for j:=0 to 3 do
         begin
         if rst mod 2=1 then
            aBits[inx+3-j]:=true
         else
            aBits[inx+3-j]:=false;
         rst:=rst Div 2;
         end;
      inx:=inx+4;
   end;
   result:=aBits;
end;

//把以分隔符分开的字符串分开放入StringList中。
procedure DivideString(str,separate:string;var str_list:TStringList);
var
  position:integer;
  strTemp:string;
begin
  str_list.Clear;
  while length(str)>0 do
  begin
    position:=pos(separate,str);
    if position=0 then position:=length(str)+1;
    strTemp:=copy(str,1,position-1);
    str_list.Add(trim(strTemp));
    delete(str,1,position);
  end;
end;


procedure DivideStringNoEmpty(str,separate:string;var str_list:TStringList);
var
  position:integer;
  strTemp:string;
begin
  str_list.Clear;
  while length(trim(str))>0 do
  begin
    position:=pos(separate,str);
    if position=0 then position:=length(str)+1;
    strTemp:=copy(str,1,position-1);
    if length(trim(strTemp))>0 then
      str_list.Add(trim(strTemp));
    delete(str,1,position);
  end;
end;

function isFloat(ANumber: string): boolean;
begin
  result:= true;
  try
    StrToFloat(ANumber);
  except
    result:= false;
  end;
end;

function isInteger(ANumber: string): boolean;
begin
  result:= true;
  try
    StrToInt(ANumber);
  except
    result:= false;
  end;
end;

procedure AlignGridCell(AStringGrid:TObject;ACol, ARow:Integer;
   ARect: TRect; Alignment: TAlignment);
var
  strText:String; 
  iLeft,iTop:integer;
begin
  With AStringGrid as TStringGrid do 
  begin
    strText:=Cells[ACol,ARow]; 
    Canvas.FillRect(ARect);
     
    iTop := ARect.Top +(ARect.bottom-ARect.top-Canvas.TextHeight(strText)) shr 1;
    case Alignment of
      taLeftJustify:
        iLeft := ARect.Left + 2;
      taRightJustify:
        iLeft := ARect.Right - Canvas.TextWidth(strText) - 3;
      else { taCenter }
        iLeft := ARect.Left + (ARect.Right - ARect.Left) shr 1
          - (Canvas.TextWidth(strText) shr 1);
    end;
    Canvas.TextOut(iLeft,iTop,strText);
  end;
end;
procedure SetListBoxHorizonbar(aListBox: TCustomListBox);
var 
  i, MaxWidth: integer;
begin
  MaxWidth:=0;
  for i:=0 to aListBox.Count-1 do
    MaxWidth:=Max(MaxWidth,aListBox.Canvas.TextWidth(aListBox.Items[i]));
  SendMessage(aListBox.Handle, LB_SETHORIZONTALEXTENT, MaxWidth+4, 0);
      
end;

function PosRightEx(const SubStr,S:AnsiString;const Offset:Cardinal=MaxInt):Integer;
var
  iPos: Integer;
  i, j,Len,LenS,LenSub: Integer;
  PCharS, PCharSub: PChar;
begin
  Result := 0;
  LenS:=Length(S);
  lenSub := length(Substr);
  if (LenS=0) Or (lenSub=0) then Exit;
  if Offset<LenSub then Exit;

  PCharS := PChar(s);
  PCharSub := PChar(Substr);

  Len:=Offset;
  if Len>LenS then
     Len:=LenS;

  for I := Len-1 downto 0 do
  begin
    if I<LenSub-1 then Exit;
    for j := lenSub - 1 downto 0 do
    if PCharS[i -lenSub+j+1] <> PCharSub[j] then
      break
    else if J=0 then
    begin
      Result:=I-lenSub+2;
      Exit;
    end;
  end;
end;

function PosStrInList(aStrList:TStrings;aStr:string):integer;
var
   i,j:integer;
begin
   j:=-1;
   for i:=0 to aStrList.Count-1 do
   if aStrList[i]=aStr then
      begin
      j:=i;
      break;
      end;
   result:=j;
end;

//打开数据表 ，返回结果true--成功,false--失败
function ReopenQryFAcount(aQuery:tadoquery;aSQLStr:string):boolean;
begin
   aQuery.Close ;
   aQuery.SQL.Clear ;
   aQuery.SQL.Add(aSQLStr);
   try
      aQuery.Open ;
   except
      result:=false;
      exit;
   end;
   result:=true;
end;
function ComSrtring(aValue,aLen:integer):string;
var
   aStr:string;
   slen,i:integer;
begin
   aStr:=inttostr(aValue);
   slen:=length(aStr);
   for i:=1 to aLen-slen do
      aStr:='0'+aStr;
   result:=aStr;
end;
//字段值求和
function SumMoney(aADOQry:tadoquery;aFieldName:string):double;
var
   asum:double;
   aBMark:tbookmark;
begin
   aSum:=0;
   aBMark:=aADOQry.GetBookmark;
   aADOQry.First ;
   while not aADOQry.Eof do
      begin
      aSum:=aSum+aADOQry.fieldbyname(aFieldName).AsFloat;
      aADOQry.Next ;
      end;
   aADOQry.GotoBookmark(aBMark);
   result:=asum;
end;

procedure SetCBWidth(aCBox:tcombobox);
var
   i,maxLen:integer;
begin
   maxLen:=0;
   for i:=0 to acbox.Items.Count-1 do
      if aCBox.Canvas.TextWidth(aCBox.Items[i])>maxLen then maxLen:=aCBox.Canvas.TextWidth(aCBox.Items[i]);
   sendmessage(aCBox.Handle,CB_SETDROPPEDWIDTH,maxLen+55,0);
end;

procedure EditFormat(aEdit:tedit);
begin
   if aEdit.Width>80 then
      aEdit.Text :=stringofchar(' ',((aEdit.Width DIV 6)-length(trim(aEdit.Text)))*2-2)+trim(aEdit.Text)
   else
      aEdit.Text :=stringofchar(' ',((aEdit.Width DIV 6)-length(trim(aEdit.Text)))*2-1)+trim(aEdit.Text);
end;


{ TProjectInfo }

constructor TProjectInfo.Create;
begin
    inherited Create;
    FPrj_ReportLanguage := trChineseReport;
end;

destructor TProjectInfo.Destroy;
begin

  inherited;
end;

procedure TProjectInfo.setProjectInfo(aPrj_no, aPrj_name,aPrj_name_en,
  aPrj_type: string);
begin
  FPrj_no := aPrj_no;
  FPrj_name := aPrj_name;
  FPrj_name_en := aPrj_name_en;
  FPrj_type := aPrj_type;
  FPrj_no_ForSQL := stringReplace(aPrj_no ,'''','''''',[rfReplaceAll]);
end;

procedure TProjectInfo.setReportLanguage(aReportLanguage: TReportLanguage);
begin
  FPrj_ReportLanguage := aReportLanguage;
  if aReportLanguage = trChineseReport then
    FPrj_ReportLanguageString  := 'cn'
  else if aReportLanguage = trEnglishReport then
    FPrj_ReportLanguageString  := 'en';
    
end;

procedure getCptAverageByDrill(aDrillNo:string;var aQcAverage,aFsAverage: string);
var
  iStratumCount,i,j, iCanJoinJiSuanCount:integer;     //iCanJoinJiSuanCount 能参加计算的每层数据的个数，因为一层里面不一定有（距离/0.1）这么多数据，所以为空的数据要去掉
  dBottom: double;
  strSQL, strTmp: string;
  lstStratumNo,lstSubNo,
  lstStratumDepth,lstStratumBottDepth:TStringList;

  strQcAll,strFsAll: String;  //保存锥尖阻力和侧壁摩擦力的整个字符串。
  qcList,fsList: TStringList; //保存锥尖阻力和侧壁摩擦力
  dBeginDepth,dEndDepth:double; //保存开始深度和结束深度
  dqcTotal, dfsTotal, dqcAverage,dfsAverage: double;

  procedure GetStramDepth(const aDrillNo: string;
   var AStratumNoList, ASubNoList, ABottList: TStringList);
  begin
    AStratumNoList.Clear;
    ASubNoList.Clear;
    ABottList.Clear;
    strSQL:='select drl_no,stra_no,sub_no, stra_depth '
        +' FROM stratum ' 
        +' WHERE '
        +' prj_no='+''''+g_ProjectInfo.prj_no_ForSQL+''''
        +' AND drl_no ='+''''+aDrillNo+''''
        +' ORDER BY stra_depth';
        //+' ORDER BY d.drl_no,s.top_elev';
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
    lstStratumNo.Free;
    lstSubNo.Free;
    lstStratumDepth.Free;
    lstStratumBottDepth.Free;
    qcList.Free;
    fsList.Free;
  end;
  
begin

  lstStratumNo:= TStringList.Create;
  lstSubNo:= TStringList.Create;
  lstStratumDepth:= TStringList.Create;
  lstStratumBottDepth:= TStringList.Create;  
  qcList:= TStringList.Create;
  fsList:= TStringList.Create;
  dBeginDepth:=0;
  dEndDepth:=0;
  try      
    GetStramDepth(aDrillNo,
      lstStratumNo, lstSubNo, lstStratumBottDepth);
    if lstStratumNo.Count =0 then exit;

    //开始取得静力触探的数据。
    qcList.Clear;
    fsList.Clear; 
    strSQL:='SELECT prj_no,drl_no,begin_depth,end_depth,qc,fs '
             +'FROM cpt '
             +' WHERE prj_no=' +''''+g_ProjectInfo.prj_no_ForSQL +''''
             +' AND drl_no='  +''''+aDrillNo+'''';
    with MainDataModule.qryCPT do
      begin
        close;
        sql.Clear;
        sql.Add(strSQL);
        open;
        i:=0;
        if not Eof then
          begin
            i:=i+1;
            strQcAll := FieldByName('qc').AsString;
            strFsAll := FieldByName('fs').AsString;
            dBeginDepth := FieldByName('begin_depth').AsFloat;
            dEndDepth := FieldByName('end_depth').AsFloat;
            Next ;
          end;
        close;
      end;
    if i>0 then
    begin
      DivideString(strQcAll,',',qcList);
      DivideString(strFsAll,',',fsList);  
    end
    else
      exit; 

    //开始分层,并计算毎层的qc和fs的平均值
    for iStratumCount:=0 to lstStratumNo.Count -1 do
    begin
      dBottom:= strtofloat(lstStratumBottDepth.Strings[iStratumCount]);
      if (dBottom-dBeginDepth)>=g_cptIncreaseDepth then
      begin
        if dEndDepth>dBottom then
          j:= round((dBottom - dBeginDepth) / g_cptIncreaseDepth)
        else
          j:= round((dEndDepth - dBeginDepth) / g_cptIncreaseDepth);
        dqcTotal:=0;
        dfsTotal:=0;
        iCanJoinJiSuanCount := 0;
        for i:= 1 to j do
        begin
          strTmp:= trim(qcList.Strings[0]);
          if isFloat(strTmp) then
          begin
            dqcTotal:= dqcTotal + strtofloat(strTmp);
            iCanJoinJiSuanCount := iCanJoinJiSuanCount +1;
          end;
          if qcList.Count>0 then
            qcList.Delete(0);
          if fsList.Count>0 then
          begin
            strTmp:= trim(fsList.Strings[0]);
            if isFloat(strTmp) then
              dfsTotal:= dfsTotal + strtofloat(strTmp);
            fsList.Delete(0);
          end;
        end;
        if iCanJoinJiSuanCount > 0 then
        begin
          dqcAverage:= dqcToTal / iCanJoinJiSuanCount;
          dfsAverage:= dfsToTal / iCanJoinJiSuanCount;
          aQcAverage:= aQcAverage + FormatFloat('0.00',dqcAverage) + ',';
          aFsAverage:= aFsAverage + FormatFloat('0.00',dfsAverage) + ',';
        end;
        dBeginDepth:= dBottom;
        if dEndDepth <= dBottom then 
          Break;
                        
      end;
    end;
  finally
    FreeStringList;
    if copy(aQcAverage,length(aQcAverage),1)=',' then
      aQcAverage:= copy(aQcAverage,1,length(aQcAverage)-1);
    if copy(aFsAverage,length(aFsAverage),1)=',' then
      aFsAverage:= copy(aFsAverage,1,length(aFsAverage)-1);      
  end;

end;


  //给字符串减去一个1000，这样数值就负的比较多了，在打印时判断，如果小于-500，这样打印时可以把数值加上1000，再在前面加个*在前面
  //目的就是把打印时把剔除的数据如23变成*23，减去10000的目的是因为正常数值本身就有负数，范围在 -100到正200
function AddFuHao(aStr:string):string;
  begin
//    if Pos('-',aStr)<1 then
//      Result := '-' + aStr
//    else
//      Result := aStr;
    Result := FloatToStr(StrToFloat(aStr)-1000) ;
  end;


procedure FenXiFenCeng_TuYiangJiSuan;
type TGuanLianFlags = set of (tgHanShuiLiang, tgYeXian, tgYaSuoXiShu, tgNingJuLi_ZhiKuai, tgMoCaJiao_ZhiKuai,
  tgNingJuLi_GuKuai, tgMoCaJiao_GuKuai);
  //yys 20040610 modified
//const AnalyzeCount=17;
  const AnalyzeCount=26;
//yys 20040610 modified
var
  //层号          亚层号
  lstStratumNo, lstSubNo: TStringList;
  //钻孔号   土样编号   开始深度        结束深度
  lstDrl_no, lstS_no, lstBeginDepth, lstEndDepth: TStringList;
  //剪切类型      砂粒粗(%)    砂粒中(%)      砂粒细(%)  
  lstShear_type, lstSand_big, lstSand_middle,lstSand_small:Tstringlist;
  //粉粒粗(%)        粉粒细(%)     粘粒(%)        不均匀系数         曲率系数         土类编号 土类名称
  lstPowder_big, lstPowder_small, lstClay_grain, lstAsymmetry_coef,lstCurvature_coef, lstEa_name: TStringList;
  //各级压力  各级压力下变形量  孔隙比         压缩系数     压缩模量
  lstYssy_yali, lstYssy_bxl, lstYssy_kxb, lstYssy_ysxs, lstYssy_ysml: TStringList;

  i,j,iRecordCount,iCol: integer;
  strSQL, strFieldNames, strFieldValues , strTmp, strSubNo,strStratumNo,strPrjNo: string;
  aAquiferous_rate: TAnalyzeResult;//含水量     0
  aWet_density    : TAnalyzeResult;//湿密度     1
  aDry_density    : TAnalyzeResult;//干密度     2
  aSoil_proportion: TAnalyzeResult;//土粒比重   3
  aGap_rate       : TAnalyzeResult;//孔隙比     4
  aGap_degree     : TAnalyzeResult;//孔隙度     5
  aSaturation     : TAnalyzeResult;//饱合度     6
  aLiquid_limit   : TAnalyzeResult;//液限       7
  aShape_limit    : TAnalyzeResult;//塑限       8
  aShape_index    : TAnalyzeResult;//塑性指数   9
  aLiquid_index   : TAnalyzeResult;//液性指数   10
  aZip_coef       : TAnalyzeResult;//压缩系数   11
  aZip_modulus    : TAnalyzeResult;//压缩模量   12
  aCohesion       : TAnalyzeResult;//凝聚力直快 13
  aFriction_angle : TAnalyzeResult;//摩擦角直快 14
//yys 20040610 modified  
  aCohesion_gk    : TAnalyzeResult;//凝聚力固快 15
  aFriction_gk    : TAnalyzeResult;//摩擦角固快 16
//yys 20040610 modified  
  aWcx_yuanz      : TAnalyzeResult;//无侧限抗压强度原状   17
  aWcx_chsu       : TAnalyzeResult;//无侧限抗压强度重塑   18
  aWcx_lmd        : TAnalyzeResult;//无侧限抗压强度灵敏度 19

 	aSand_big       : TAnalyzeResult;//砂粒粗 20
	aSand_middle    : TAnalyzeResult;//砂粒中 21
	aSand_small     : TAnalyzeResult;//砂粒细 22
	aPowder_big     : TAnalyzeResult;//粉粒粗 23
	aPowder_small   : TAnalyzeResult;//粉粒细 24
	aClay_grain     : TAnalyzeResult;//粘粒 25
  
  ArrayAnalyzeResult: Array[0..AnalyzeCount-1] of TAnalyzeResult;  // 保存要参加统计的TAnalyzeResult
  ArrayFieldNames: Array[0..AnalyzeCount-1] of String; // 保存要参加统计的字段名,与ArrayAnalyzeResult的内容一一对应

  //初始化此过程中的变量
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
    ArrayAnalyzeResult[8]:= aShape_limit;
    ArrayAnalyzeResult[9]:= aShape_index;
    ArrayAnalyzeResult[10]:= aLiquid_index;
    ArrayAnalyzeResult[11]:= aZip_coef;
    ArrayAnalyzeResult[12]:= aZip_modulus;
    ArrayAnalyzeResult[13]:= aCohesion;
    ArrayAnalyzeResult[14]:= aFriction_angle;
//yys 20040610 modified 
    //ArrayAnalyzeResult[14]:= aWcx_yuanz;
    //ArrayAnalyzeResult[15]:= aWcx_chsu;
    //ArrayAnalyzeResult[16]:= aWcx_lmd;
    ArrayAnalyzeResult[15]:= aCohesion_gk;
    ArrayAnalyzeResult[16]:= aFriction_gk;
    ArrayAnalyzeResult[17]:= aWcx_yuanz;
    ArrayAnalyzeResult[18]:= aWcx_chsu;
    ArrayAnalyzeResult[19]:= aWcx_lmd;

    ArrayAnalyzeResult[20]:= aSand_big;
    ArrayAnalyzeResult[21]:= aSand_middle;
    ArrayAnalyzeResult[22]:= aSand_small;
    ArrayAnalyzeResult[23]:= aPowder_big;
    ArrayAnalyzeResult[24]:= aPowder_small;
    ArrayAnalyzeResult[25]:= aClay_grain;
//yys 20040610 modified

    ArrayFieldNames[0]:= 'aquiferous_rate';
    ArrayFieldNames[1]:= 'wet_density';
    ArrayFieldNames[2]:= 'dry_density';
    ArrayFieldNames[3]:= 'soil_proportion';
    ArrayFieldNames[4]:= 'gap_rate';
    ArrayFieldNames[5]:= 'gap_degree';
    ArrayFieldNames[6]:= 'saturation';
    ArrayFieldNames[7]:= 'liquid_limit';
    ArrayFieldNames[8]:= 'shape_limit';
    ArrayFieldNames[9]:= 'shape_index';
    ArrayFieldNames[10]:= 'liquid_index';
    ArrayFieldNames[11]:= 'zip_coef';
    ArrayFieldNames[12]:= 'zip_modulus';
    ArrayFieldNames[13]:= 'cohesion';
    ArrayFieldNames[14]:= 'friction_angle'; 
//yys 20040610 modified
    //ArrayFieldNames[14]:= 'wcx_yuanz';
    //ArrayFieldNames[15]:= 'wcx_chsu';
    //ArrayFieldNames[16]:= 'wcx_lmd';      
    ArrayFieldNames[15]:= 'cohesion_gk';
    ArrayFieldNames[16]:= 'friction_gk';      
    ArrayFieldNames[17]:= 'wcx_yuanz';
    ArrayFieldNames[18]:= 'wcx_chsu';
    ArrayFieldNames[19]:= 'wcx_lmd';

    ArrayFieldNames[20]:= 'sand_big';
    ArrayFieldNames[21]:= 'sand_middle';
    ArrayFieldNames[22]:= 'sand_small';
    ArrayFieldNames[23]:= 'powder_big';
    ArrayFieldNames[24]:= 'powder_small';
    ArrayFieldNames[25]:= 'clay_grain';
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
    lstYssy_yali:= TStringList.Create;
    lstYssy_bxl:= TStringList.Create;
    lstYssy_kxb:= TStringList.Create;
    lstYssy_ysxs:= TStringList.Create;
    lstYssy_ysml:= TStringList.Create;

    for iCount:=0 to AnalyzeCount-1 do
    begin
      ArrayAnalyzeResult[iCount].lstValues := TStringList.Create;
      ArrayAnalyzeResult[iCount].lstValuesForPrint := TStringList.Create;
    end;
    aAquiferous_rate.FormatString := '0.0';
    aWet_density.FormatString := '0.00';
    aDry_density.FormatString := '0.00';
    aSoil_proportion.FormatString := '0.00';
    aGap_rate.FormatString := '0.000';
    aGap_degree.FormatString := '0.0';
    aSaturation.FormatString := '0';
    aLiquid_limit.FormatString := '0.0';
    aShape_limit.FormatString := '0.0';
    aShape_index.FormatString := '0.0';
    aLiquid_index.FormatString := '0.00';
    aZip_coef.FormatString := '0.000';
    aZip_modulus.FormatString := '0.00';
    aCohesion.FormatString := '0.00';
    aFriction_angle.FormatString := '0.00';
//yys 20040610 modified 
    aCohesion_gk.FormatString := '0.00';
    aFriction_gk.FormatString := '0.00';
//yys 20040610 modified
    aWcx_yuanz.FormatString := '0.0';
    aWcx_chsu.FormatString := '0.0';
    aWcx_lmd.FormatString := '0.0';

    aSand_big.FormatString := '0.00';
    aSand_middle.FormatString := '0.00';
    aSand_small.FormatString := '0.00';
    aPowder_big.FormatString := '0.00';
    aPowder_small.FormatString := '0.00';
    aClay_grain.FormatString := '0.00';
  end;
  
  //释放此过程中的变量
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
    lstYssy_yali.Free;
    lstYssy_bxl.Free;
    lstYssy_kxb.Free;
    lstYssy_ysxs.Free;
    lstYssy_ysml.Free;

    for iCount:=0 to AnalyzeCount-1 do
    begin
      ArrayAnalyzeResult[iCount].lstValues.Free;
      ArrayAnalyzeResult[iCount].lstValuesForPrint.Free;
    end;
  end;

    //计算临界值
  function CalculateCriticalValue(aValue, aPingjunZhi, aBiaoZhunCha: double): double;
  begin
    if aBiaoZhunCha = 0 then
    begin
      result:= 0;
      exit;
    end;
    result := (aValue - aPingjunZhi) / aBiaoZhunCha;
  end;


  //计算平均值、标准差、变异系数等特征值。关联剔除 就是一个剔除时，另一个也剔除
  //1、压缩系数 在剔除时要同时把压缩模量剔除 ，压缩模量在计算时不再做剔除处理
  //2、凝聚力和摩擦角 都需要剔除，关联剔除
  //3、含水量，液限 若超差要剔除，同时把塑性指数和液性指数剔除 。
  //   3的判别顺序是：先判断含水量，若剔除时也要把液限剔除。后判断液限，若剔除时并不要把含水量剔除。
  //另外，2009/12/29工勘院修改要求，只有凝聚力和摩擦角、标贯、静探需要计算标准值，其他都不在计算标准值，同时报表上这些不要计算标准值的要空白显示。
  procedure GetTeZhengShuGuanLian(var aAnalyzeResult : TAnalyzeResult;Flags: TGuanLianFlags);
  var
    i,iCount,iFirst,iMax:integer;
    dTotal,dValue,dTotalFangCha,dCriticalValue:double;
    strValue: string;
    TiChuGuo: boolean; //数据在计算时是否有过剔除，如果有，那么涉及到关联剔除的另外的数据也要重新计算
  begin
    iMax:=0;
    dTotal:= 0;
    iFirst:= 0;
    TiChuGuo := false;
    dTotalFangCha:=0;
    aAnalyzeResult.PingJunZhi := -1;
    aAnalyzeResult.BiaoZhunCha := -1;
    aAnalyzeResult.BianYiXiShu := -1;
    aAnalyzeResult.MaxValue := -1;
    aAnalyzeResult.MinValue := -1;
    aAnalyzeResult.SampleNum := -1;
    aAnalyzeResult.BiaoZhunZhi:= -1;
    if aAnalyzeResult.lstValues.Count<1 then exit;
    strValue := '';
    for i:= 0 to aAnalyzeResult.lstValues.Count-1 do
        strValue:=strValue + aAnalyzeResult.lstValues.Strings[i];
    strValue := trim(strValue);
    if strValue='' then exit;

  //yys 2005/06/15
    iCount:= aAnalyzeResult.lstValues.Count;
    for i:= 0 to aAnalyzeResult.lstValues.Count-1 do
      begin
        strValue:=aAnalyzeResult.lstValues.Strings[i];
        if strValue='' then
        begin
          iCount:=iCount-1;
        end
        else
        begin
          inc(iFirst);
          dValue:= StrToFloat(strValue);
          if iFirst=1 then
            begin
              aAnalyzeResult.MinValue:= dValue;
              aAnalyzeResult.MaxValue:= dValue;

              iMax := i;
            end
          else
            begin
              if aAnalyzeResult.MinValue>dValue then
              begin
                aAnalyzeResult.MinValue:= dValue;

              end;
              if aAnalyzeResult.MaxValue<dValue then
              begin
                aAnalyzeResult.MaxValue:= dValue;
                iMax := i;
              end;
            end;           
          dTotal:= dTotal + dValue;          
        end;
      end;
    //dTotal:= dTotal - aAnalyzeResult.MinValue - aAnalyzeResult.MaxValue;
    //iCount := iCount - 2;
    if iCount>=1 then
      aAnalyzeResult.PingJunZhi := dTotal/iCount
    else
      aAnalyzeResult.PingJunZhi := dTotal;
    //aAnalyzeResult.lstValues.Strings[iMin]:= '';
    //aAnalyzeResult.lstValues.Strings[iMax]:= '';

    //iCount:= aAnalyzeResult.lstValues.Count;
    for i:= 0 to aAnalyzeResult.lstValues.Count-1 do
    begin
      strValue:=aAnalyzeResult.lstValues.Strings[i];
      if strValue<>'' then
      begin
        dValue := StrToFloat(strValue);
        dTotalFangCha := dTotalFangCha + sqr(dValue-aAnalyzeResult.PingJunZhi);
      end
      //else iCount:= iCount -1;
    end;
    if iCount>1 then
      dTotalFangCha:= dTotalFangCha/(iCount-1);
    aAnalyzeResult.SampleNum := iCount;
    if iCount >1 then
      aAnalyzeResult.BiaoZhunCha := sqrt(dTotalFangCha)
    else
      aAnalyzeResult.BiaoZhunCha := sqrt(dTotalFangCha);
    if not iszero(aAnalyzeResult.PingJunZhi) then
      aAnalyzeResult.BianYiXiShu := strtofloat(formatfloat(aAnalyzeResult.FormatString,aAnalyzeResult.BiaoZhunCha / aAnalyzeResult.PingJunZhi))
    else
      aAnalyzeResult.BianYiXiShu:= 0;
    if iCount>=6 then
    begin //2009/12/29工勘院修改要求，只有凝聚力和摩擦角需要计算标准值，其他都不在计算标准值，同时报表上这些不要计算标准值的要空白显示。
        if (tgNingJuLi_ZhiKuai in Flags) or (tgMoCaJiao_ZhiKuai in Flags) or (tgNingJuLi_GuKuai in Flags) or (tgMoCaJiao_GuKuai in Flags) then
          aAnalyzeResult.BiaoZhunZhi := GetBiaoZhunZhi(aAnalyzeResult.SampleNum , aAnalyzeResult.BianYiXiShu, aAnalyzeResult.PingJunZhi);
    end;
    dValue:= CalculateCriticalValue(aAnalyzeResult.MaxValue, aAnalyzeResult.PingJunZhi,aAnalyzeResult.BiaoZhunCha);
    dCriticalValue := GetCriticalValue(iCount);

  //2005/07/25 yys edit 土样数据剔除时，到6个样就不再剔除，剔除时要先剔除最大的数据，同时关联的其他数据一并剔除

    if (iCount> 6) AND (dValue > dCriticalValue) then
      begin
        aAnalyzeResult.lstValues.Strings[iMax]:= '';
        //if pos('-',aAnalyzeResult.lstValuesForPrint.Strings[iMax])>0 then  //如果本身是负数 则减去1000
        //if (ArrayAnalyzeResult[7].lstValuesForPrint.Strings[iMax]<>'')  then
        if (aAnalyzeResult.lstValuesForPrint.Strings[iMax]<>'')  then
          aAnalyzeResult.lstValuesForPrint.Strings[iMax] := AddFuHao(aAnalyzeResult.lstValuesForPrint.Strings[iMax]) ;
        //else
        //  aAnalyzeResult.lstValuesForPrint.Strings[iMax]:= '-'+aAnalyzeResult.lstValuesForPrint.Strings[iMax];

        TiChuGuo := true;
        if tgHanShuiLiang in Flags then
        begin
          ArrayAnalyzeResult[7].lstValues.Strings[iMax]:= ''; //液限
          ArrayAnalyzeResult[8].lstValues.Strings[iMax]:= ''; //塑限 Shape_limit;
          ArrayAnalyzeResult[9].lstValues.Strings[iMax]:= ''; //塑性指数 Shape_index;
          ArrayAnalyzeResult[10].lstValues.Strings[iMax]:= ''; //液性指数 Liquid_index;
          //打印时负数转换成*加正数 如-10 打印时会转换成*10 ,但是，本身就有负数的液限，塑限， 塑性指数，液性指数单独处理，-1000，打印时也单独处理<-500时加*再加上1000

          if (ArrayAnalyzeResult[7].lstValuesForPrint.Strings[iMax]<>'')  then
            ArrayAnalyzeResult[7].lstValuesForPrint.Strings[iMax] := AddFuHao(ArrayAnalyzeResult[7].lstValuesForPrint.Strings[iMax]); //液限
          if ArrayAnalyzeResult[8].lstValuesForPrint.Strings[iMax]<>'' then
            ArrayAnalyzeResult[8].lstValuesForPrint.Strings[iMax]:=AddFuHao(ArrayAnalyzeResult[8].lstValuesForPrint.Strings[iMax]); //塑限 Shape_limit;
          if ArrayAnalyzeResult[9].lstValuesForPrint.Strings[iMax]<>'' then
            ArrayAnalyzeResult[9].lstValuesForPrint.Strings[iMax]:=AddFuHao(ArrayAnalyzeResult[9].lstValuesForPrint.Strings[iMax]); //塑性指数 Shape_index;
          if ArrayAnalyzeResult[10].lstValuesForPrint.Strings[iMax]<>'' then
            ArrayAnalyzeResult[10].lstValuesForPrint.Strings[iMax]:=AddFuHao(ArrayAnalyzeResult[10].lstValuesForPrint.Strings[iMax]); //液性指数 Liquid_index;
        end
        else if tgYeXian in Flags then
        begin
          ArrayAnalyzeResult[8].lstValues.Strings[iMax]:= ''; //塑限 Shape_limit;
          ArrayAnalyzeResult[9].lstValues.Strings[iMax]:= ''; //塑性指数 Shape_index;
          ArrayAnalyzeResult[10].lstValues.Strings[iMax]:= ''; //液性指数 Liquid_index;

          if ArrayAnalyzeResult[8].lstValuesForPrint.Strings[iMax]<>'' then
            ArrayAnalyzeResult[8].lstValuesForPrint.Strings[iMax]:= AddFuHao(ArrayAnalyzeResult[8].lstValuesForPrint.Strings[iMax]); //塑限 Shape_limit;
          if ArrayAnalyzeResult[9].lstValuesForPrint.Strings[iMax]<>'' then
            ArrayAnalyzeResult[9].lstValuesForPrint.Strings[iMax]:= AddFuHao(ArrayAnalyzeResult[9].lstValuesForPrint.Strings[iMax]); //塑性指数 Shape_index;
          if ArrayAnalyzeResult[10].lstValuesForPrint.Strings[iMax]<>'' then
            ArrayAnalyzeResult[10].lstValuesForPrint.Strings[iMax] := AddFuHao(ArrayAnalyzeResult[10].lstValuesForPrint.Strings[iMax]); //液性指数 Liquid_index;
        end
        else if tgYaSuoXiShu in Flags then
        begin
          ArrayAnalyzeResult[12].lstValues.Strings[iMax]:= ''; //压缩模量 Zip_modulus;
          if ArrayAnalyzeResult[12].lstValuesForPrint.Strings[iMax]<>'' then
            ArrayAnalyzeResult[12].lstValuesForPrint.Strings[iMax] := AddFuHao(ArrayAnalyzeResult[12].lstValuesForPrint.Strings[iMax]);
        end
        else if tgNingJuLi_ZhiKuai in Flags then    //凝聚力直快
        begin
          ArrayAnalyzeResult[14].lstValues.Strings[iMax]:= ''; //摩擦角直快 Friction_angle
          if ArrayAnalyzeResult[14].lstValuesForPrint.Strings[iMax]<>'' then
            ArrayAnalyzeResult[14].lstValuesForPrint.Strings[iMax] := AddFuHao(ArrayAnalyzeResult[14].lstValuesForPrint.Strings[iMax]);
        end
        else if tgMoCaJiao_ZhiKuai in Flags then
        begin
          ArrayAnalyzeResult[13].lstValues.Strings[iMax]:= ''; //凝聚力直快 Cohesion
          if ArrayAnalyzeResult[13].lstValuesForPrint.Strings[iMax]<>'' then
            ArrayAnalyzeResult[13].lstValuesForPrint.Strings[iMax] := AddFuHao(ArrayAnalyzeResult[13].lstValuesForPrint.Strings[iMax]);
        end
        else if tgNingJuLi_GuKuai in Flags then    //凝聚力固快
        begin
          ArrayAnalyzeResult[16].lstValues.Strings[iMax]:= ''; //摩擦角固快 Friction_gk
          if ArrayAnalyzeResult[16].lstValuesForPrint.Strings[iMax]<>'' then
            ArrayAnalyzeResult[16].lstValuesForPrint.Strings[iMax] := AddFuHao(ArrayAnalyzeResult[16].lstValuesForPrint.Strings[iMax]);
        end
        else if tgMoCaJiao_GuKuai in Flags then
        begin
          ArrayAnalyzeResult[15].lstValues.Strings[iMax]:= ''; //凝聚力固快 Cohesion_gk
          if ArrayAnalyzeResult[15].lstValuesForPrint.Strings[iMax]<>'' then
            ArrayAnalyzeResult[15].lstValuesForPrint.Strings[iMax] := AddFuHao(ArrayAnalyzeResult[15].lstValuesForPrint.Strings[iMax]);
        end;
        GetTeZhengShuGuanLian(aAnalyzeResult, Flags);
      end;

    if TiChuGuo then
    begin
      if tgNingJuLi_ZhiKuai in Flags then    //凝聚力直快
      begin
        GetTeZhengShuGuanLian(ArrayAnalyzeResult[14], [tgMoCaJiao_ZhiKuai]); //摩擦角直快 Friction_angle
      end
      else if tgMoCaJiao_ZhiKuai in Flags then
      begin
        GetTeZhengShuGuanLian(ArrayAnalyzeResult[13], [tgNingJuLi_ZhiKuai]);//凝聚力直快 Cohesion
      end
      else if tgNingJuLi_GuKuai in Flags then    //凝聚力固快
      begin
        GetTeZhengShuGuanLian(ArrayAnalyzeResult[16], [tgMoCaJiao_GuKuai]);//摩擦角固快 Friction_gk
      end
      else if tgMoCaJiao_GuKuai in Flags then
      begin
        GetTeZhengShuGuanLian(ArrayAnalyzeResult[15], [tgNingJuLi_GuKuai]);//凝聚力固快 Cohesion_gk
      end;
    end;

  //yys 2005/06/15 add, 当一层只有一个样时，标准差和变异系数不能为0，打印报表时要用空格，物理力学表也一样。所以用-1来表示空值，是因为在报表设计时可以通过判断来表示为空。
    if  iCount=1 then
    begin
       //aAnalyzeResult.strBianYiXiShu  := 'null';
       //aAnalyzeResult.strBiaoZhunCha  := 'null';
       aAnalyzeResult.BianYiXiShu := -1;
       aAnalyzeResult.BiaoZhunCha := -1;
       aAnalyzeResult.BiaoZhunZhi := -1;
    end
    else begin
       //aAnalyzeResult.strBianYiXiShu := FloatToStr(aAnalyzeResult.BianYiXiShu);
      // aAnalyzeResult.strBiaoZhunCha := FloatToStr(aAnalyzeResult.BiaoZhunCha);
    end;
  //yys 2005/06/15 add
  end;

   //取得一个工程中所有的层号和亚层号和土类名称，保存在三个TStringList变量中。
  procedure GetAllStratumNo(var AStratumNoList, ASubNoList, AEaNameList: TStringList);
  var
    strSQL: string;
  begin
    AStratumNoList.Clear;
    ASubNoList.Clear;
    AEaNameList.Clear;
    strSQL:='SELECT id,prj_no,stra_no,sub_no,ISNULL(ea_name,'''') as ea_name FROM stratum_description'
        +' WHERE prj_no='+''''+g_ProjectInfo.prj_no_ForSQL+''''
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

begin
   try
    //开始给土样分层 ,此处注释掉不用是因为已经在其他地方分层了。
    //SetTuYangCengHao;

    //开始清空临时统计表的当前工程数据
    //strSQL:= 'TRUNCATE TABLE stratumTmp; TRUNCATE TABLE TeZhengShuTmp; TRUNCATE TABLE earthsampleTmp; TRUNCATE TABLE earthsampleTmp ';
    strSQL:= 'DELETE FROM stratumTmp WHERE prj_no = '+''''+g_ProjectInfo.prj_no_ForSQL+''''+';'
            +'DELETE FROM TeZhengShuTmp WHERE prj_no = '+''''+g_ProjectInfo.prj_no_ForSQL+''''+';'
            +'DELETE FROM earthsampleTmp WHERE prj_no = '+''''+g_ProjectInfo.prj_no_ForSQL+'''';
    if not Delete_oneRecord(MainDataModule.qrySectionTotal, strSQL) then
    begin
      exit;
    end;

    InitVar;
    GetAllStratumNo(lstStratumNo, lstSubNo, lstEa_name);
    if lstStratumNo.Count = 0 then 
    begin
      //FreeStringList;
      exit;
    end;

    {//将层号和亚层号和土类名称插入临时主表
    for i:=0 to lstStratumNo.Count-1 do
    begin
      strSQL:='INSERT INTO stratumTmp (prj_no,stra_no,sub_no,ea_name) VALUES('
        +''''+g_ProjectInfo.prj_no_ForSQL+''''+','
        +''''+lstStratumNo.Strings[i]+'''' +','
        +''''+lstSubNo.Strings[i]+''''+','
        +''''+lstEa_name.Strings[i]+''''+')';
      Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL);   
    end;}
    strPrjNo := g_ProjectInfo.prj_no_ForSQL;
    for i:=0 to lstStratumNo.Count-1 do
    begin
      strSubNo := stringReplace(lstSubNo.Strings[i],'''','''''',[rfReplaceAll]);
      strStratumNo := lstStratumNo.Strings[i];
      //2008/11/21 yys edit 加入选择条件，钻孔参与统计
      strSQL:='SELECT es.*,et.ea_name_en FROM (SELECT * FROM earthsample '
          +' WHERE prj_no='+''''+strPrjNo+''''
          +' AND stra_no='+''''+strStratumNo+''''
          +' AND sub_no='+''''+strSubNo+''''
          +' AND if_statistic=1 and drl_no in (select drl_no from drills where can_tongji=0 '
          +' AND prj_no='+''''+strPrjNo+''''
          +')) as es '
          +' Left Join earthtype et on es.ea_name=et.ea_name';

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
      lstYssy_yali.Clear;
      lstYssy_bxl.Clear;
      lstYssy_kxb.Clear;
      lstYssy_ysxs.Clear;
      lstYssy_ysml.Clear;
    
      for j:=0 to AnalyzeCount-1 do
      begin
        ArrayAnalyzeResult[j].lstValues.Clear;
        ArrayAnalyzeResult[j].lstValuesForPrint.Clear;
      end;
          
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
              if g_ProjectInfo.prj_ReportLanguage= trChineseReport then
                lstEa_name.Add(FieldByName('ea_name').AsString)
              else if g_ProjectInfo.prj_ReportLanguage= trEnglishReport then
                lstEa_name.Add(FieldByName('ea_name_en').AsString);

              lstYssy_yali.Add(FieldByName('Yssy_yali').AsString);
              lstYssy_bxl.Add(FieldByName('Yssy_bxl').AsString);
              lstYssy_kxb.Add(FieldByName('Yssy_kxb').AsString);
              lstYssy_ysxs.Add(FieldByName('Yssy_ysxs').AsString);
              lstYssy_ysml.Add(FieldByName('Yssy_ysml').AsString);
              for j:=0 to AnalyzeCount-1 do
              begin
                ArrayAnalyzeResult[j].lstValues.Add(FieldByName(ArrayFieldNames[j]).AsString);
                ArrayAnalyzeResult[j].lstValuesForPrint.Add(FieldByName(ArrayFieldNames[j]).AsString);
              end;
              next;
            end;
          close;
        end;
      if iRecordCount=0 then //如果没有土样信息，则插入空值到特征数表，
      begin                  //这是为了以后在特征数表TeZhengShuTmp插入静力触探和标贯数据时，只用UPDATE语句就可以了
        for j:= 1 to 7 do
        begin 
          strSQL:='INSERT INTO TeZhengShuTmp '
            +'VALUES ('+''''+strPrjNo+''''+','
            +''''+strStratumNo+'''' +','
            +''''+strSubNo+''''+','''+InttoStr(j)+'''' + DupeString(',-1', 33)+')';  //此处27是TezhengShuTmp表去掉前面4个列后列数
          Insert_oneRecord(MainDataModule.qryPublic, strSQL);
        end;
        continue;
      end;
     

      //取得特征数
//2007/01/24 下面这两句注释起来是因为
//      for j:=0 to AnalyzeCount-1 do
//        getTeZhengShu(ArrayAnalyzeResult[j], [tfTuYang]);
     GetTeZhengShuGuanLian(ArrayAnalyzeResult[0],[tgHanShuiLiang]); //含水量     0
     GetTeZhengShuGuanLian(ArrayAnalyzeResult[7],[tgYeXian]);       //液限       7
     for j:=1 to 6 do
       getTeZhengShu(ArrayAnalyzeResult[j], [tfTuYang]);
     for j:=8 to 10 do  //塑限       8 塑性指数   9  液性指数   10   不进行剔除
       getTeZhengShu(ArrayAnalyzeResult[j], [tfOther]);
     GetTeZhengShuGuanLian(ArrayAnalyzeResult[11],[tgYaSuoXiShu]);   //压缩系数   11
     getTeZhengShu(ArrayAnalyzeResult[12], [tfOther]);              //压缩模量   12   不进行剔除

     GetTeZhengShuGuanLian(ArrayAnalyzeResult[13],[tgNingJuLi_ZhiKuai]);   //凝聚力直快 13
     GetTeZhengShuGuanLian(ArrayAnalyzeResult[14],[tgMoCaJiao_ZhiKuai]);   //摩擦角直快 14
     GetTeZhengShuGuanLian(ArrayAnalyzeResult[15],[tgNingJuLi_GuKuai]);   //凝聚力固快 15
     GetTeZhengShuGuanLian(ArrayAnalyzeResult[16],[tgMoCaJiao_GuKuai]);   //摩擦角固快 16

     for j:=17 to 19 do
       getTeZhengShu(ArrayAnalyzeResult[j], [tfTuYang]);
     for j:=20 to AnalyzeCount-1 do
       getTeZhengShu(ArrayAnalyzeResult[j], [tfOther]);

//2007/01/24
//      for j:=0 to ArrayAnalyzeResult[15].lstValues.count-1 do
//         caption:= caption + ArrayAnalyzeResult[15].lstValues[j]; 

    {******把平均值、标准差、变异系数、最大值、**********}
    {******最小值、样本值、标准值等插入特征数表TeZhengShuTmp ****}
      //开始取得要插入的字段名称。
      strFieldNames:= '';
      for j:=0 to AnalyzeCount-1 do
        strFieldNames:= strFieldNames + ArrayFieldNames[j] + ',';
      strFieldNames:= strFieldNames + 'prj_no, stra_no, sub_no, v_id';

      //开始插入平均值
      strFieldValues:= '';
      strSQL:= '';
      for j:=0 to AnalyzeCount-1 do
        strFieldValues:= strFieldValues +FloatToStr(ArrayAnalyzeResult[j].PingJunZhi)+',';
      strFieldValues:= strFieldValues
        +''''+strPrjNo+''''+','
        +''''+strStratumNo+'''' +','
        +''''+strSubNo+''''+','+TEZHENSHU_Flag_PingJunZhi;
      strSQL:='INSERT INTO TeZhengShuTmp (' + strFieldNames + ')'
        +'VALUES('+strFieldValues+')';
      if not Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL) then
        continue;
      
      //开始插入标准差
      strFieldValues:= '';
      strSQL:= '';
      for j:=0 to AnalyzeCount-1 do
        strFieldValues:= strFieldValues +FloatToStr(ArrayAnalyzeResult[j].BiaoZhunCha)+',';
        //strFieldValues:= strFieldValues +ArrayAnalyzeResult[j].strBiaoZhunCha+',';

      strFieldValues:= strFieldValues
        +''''+strPrjNo+''''+','
        +''''+strStratumNo+'''' +','
        +''''+strSubNo+''''+','+TEZHENSHU_Flag_BiaoZhunCha;
      strSQL:='INSERT INTO TeZhengShuTmp (' + strFieldNames + ')'
        +'VALUES('+strFieldValues+')';
      if not Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL) then 
        continue;
      
      //开始插入变异系数
      strFieldValues:= '';
      strSQL:= '';
      for j:=0 to AnalyzeCount-1 do
        strFieldValues:= strFieldValues +FloatToStr(ArrayAnalyzeResult[j].BianYiXiShu)+',';
        //strFieldValues:= strFieldValues + ArrayAnalyzeResult[j].strBianYiXiShu+',';
      strFieldValues:= strFieldValues 
        +''''+strPrjNo+''''+','
        +''''+strStratumNo+'''' +','
        +''''+strSubNo+''''+','+TEZHENSHU_Flag_BianYiXiShu;
      strSQL:='INSERT INTO TeZhengShuTmp (' + strFieldNames + ')'
        +'VALUES('+strFieldValues+')';
      if not Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL) then 
        continue;
      
      //开始插入最大值
      strFieldValues:= '';
      strSQL:= '';
      for j:=0 to AnalyzeCount-1 do
        strFieldValues:= strFieldValues +FloatToStr(ArrayAnalyzeResult[j].MaxValue)+',';
      strFieldValues:= strFieldValues 
        +''''+strPrjNo+''''+','
        +''''+strStratumNo+'''' +','
        +''''+strSubNo+''''+','+TEZHENSHU_Flag_MaxValue;
      strSQL:='INSERT INTO TeZhengShuTmp (' + strFieldNames + ')'
        +'VALUES('+strFieldValues+')';
      if not Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL) then 
        continue;
      
      //开始插入最小值
      strFieldValues:= '';
      strSQL:= '';
      for j:=0 to AnalyzeCount-1 do
        strFieldValues:= strFieldValues +FloatToStr(ArrayAnalyzeResult[j].MinValue)+',';
      strFieldValues:= strFieldValues 
        +''''+strPrjNo+''''+','
        +''''+strStratumNo+'''' +','
        +''''+strSubNo+''''+','+TEZHENSHU_Flag_MinValue;
      strSQL:='INSERT INTO TeZhengShuTmp (' + strFieldNames + ')'
        +'VALUES('+strFieldValues+')';
      if not Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL) then 
        continue;
      
      //开始插入样本值
      strFieldValues:= '';
      strSQL:= '';
      for j:=0 to AnalyzeCount-1 do
        strFieldValues:= strFieldValues +FloatToStr(ArrayAnalyzeResult[j].SampleNum)+',';
      strFieldValues:= strFieldValues
        +''''+strPrjNo+''''+','
        +''''+strStratumNo+'''' +','
        +''''+strSubNo+''''+','+TEZHENSHU_Flag_SampleNum;
      strSQL:='INSERT INTO TeZhengShuTmp (' + strFieldNames + ')'
        +'VALUES('+strFieldValues+')';
      if not Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL) then
        continue;

      //开始插入标准值
      strFieldValues:= '';
      strSQL:= '';
      for j:=0 to AnalyzeCount-1 do
        strFieldValues:= strFieldValues +FloatToStr(ArrayAnalyzeResult[j].BiaoZhunZhi)+',';
      strFieldValues:= strFieldValues
        +''''+strPrjNo+''''+','
        +''''+strStratumNo+'''' +','
        +''''+strSubNo+''''+','+TEZHENSHU_Flag_BiaoZhunZhi;
      strSQL:='INSERT INTO TeZhengShuTmp (' + strFieldNames + ')'
        +'VALUES('+strFieldValues+')';
      if not Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL) then
        continue;
                  
      {********把经过舍弃的数值插入临时土样表**********}
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
        strFieldValues:= strFieldValues +'''' + stringReplace(lstDrl_no.Strings[j] ,'''','''''',[rfReplaceAll]) +'''';

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

        if lstYssy_yali.Strings[j]<>'' then
        begin
          strFieldNames:= strFieldNames + ',Yssy_yali';
          strFieldValues:= strFieldValues  +','+'''' + lstYssy_yali.Strings[j] +'''';
        end;

        if lstYssy_bxl.Strings[j]<>'' then
        begin
          strFieldNames:= strFieldNames + ',Yssy_bxl';
          strFieldValues:= strFieldValues  +','+'''' + lstYssy_bxl.Strings[j] +'''';
        end;

        if lstYssy_kxb.Strings[j]<>'' then
        begin
          strFieldNames:= strFieldNames + ',Yssy_kxb';
          strFieldValues:= strFieldValues  +','+'''' + lstYssy_kxb.Strings[j] +'''';
        end;

        if lstYssy_ysxs.Strings[j]<>'' then
        begin
          strFieldNames:= strFieldNames + ',Yssy_ysxs';
          strFieldValues:= strFieldValues  +','+'''' + lstYssy_ysxs.Strings[j] +'''';
        end;

        if lstYssy_ysml.Strings[j]<>'' then
        begin
          strFieldNames:= strFieldNames + ',Yssy_ysml';
          strFieldValues:= strFieldValues  +','+'''' + lstYssy_ysml.Strings[j] +'''';
        end;


        for iCol:=0 to 19 do  // for iCol:=0 to AnalyzeCount-1 do 不要加上颗分数据，上面已经加了
        begin
          strTmp := ArrayAnalyzeResult[iCol].lstValuesForPrint.Strings[j];
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

  end;
end;

procedure FenXiFenCeng_TeShuYiangJiSuan;
type TGuanLianFlags = set of (tgHanShuiLiang, tgYeXian, tgYaSuoXiShu, tgNingJuLi_ZhiKuai, tgMoCaJiao_ZhiKuai,
  tgNingJuLi_GuKuai, tgMoCaJiao_GuKuai);
  //yys 20040610 modified
//const AnalyzeCount=17;
  const AnalyzeCount=44;
//yys 20040610 modified
var
  //层号          亚层号
  lstStratumNo, lstSubNo: TStringList;
  //钻孔号   土样编号   开始深度        结束深度
  lstDrl_no, lstS_no, lstBeginDepth, lstEndDepth: TStringList;
  //剪切类型      砂粒粗(%)    砂粒中(%)      砂粒细(%)
  lstShear_type, lstsand_big, lstsand_middle,lstsand_small:Tstringlist;
  //粉粒粗(%)        粉粒细(%)     粘粒(%)        不均匀系数         曲率系数         土类编号 土类名称
  lstPowder_big, lstPowder_small, lstClay_grain, lstAsymmetry_coef,lstCurvature_coef, lstEa_name: TStringList;
  //各级压力  各级压力下变形量  孔隙比         压缩系数     压缩模量
  lstYssy_yali, lstYssy_bxl, lstYssy_kxb, lstYssy_ysxs, lstYssy_ysml: TStringList;
  i,j,iRecordCount,iCol: integer;
  strSQL, strFieldNames, strFieldValues , strTmp, strSubNo,strStratumNo,strPrjNo: string;
  aGygj_pc    : TAnalyzeResult;//先期固结压力     0
  aGygj_cc    : TAnalyzeResult;//压缩指数     1
  aGygj_cs    : TAnalyzeResult;//回弹指数     2
  aHtml       : TAnalyzeResult;//回弹模量            3
  aGjxs50_1   : TAnalyzeResult;//固结系数50     4
  aGjxs100_1  : TAnalyzeResult;//固结系数100     5
  aGjxs200_1   : TAnalyzeResult;//固结系数200     6
  aGjxs400_1   : TAnalyzeResult;//固结系数400       7
  aGjxs50_2    : TAnalyzeResult;//固结系数50       8
  aGjxs100_2   : TAnalyzeResult;//固结系数100   9
  aGjxs200_2   : TAnalyzeResult;//固结系数200   10
  aGjxs400_2   : TAnalyzeResult;//固结系数400   11

  aJcxs_v_005_01    : TAnalyzeResult;//基床系数（垂直）0.05～0.1   12
  aJcxs_v_01_02     : TAnalyzeResult;//基床系数（垂直）0.1～0.2 13
  aJcxs_v_02_04     : TAnalyzeResult;//基床系数（垂直）0.05～0.1 14
  aJcxs_h_005_01    : TAnalyzeResult;//基床系数（水平）0.05～0.1 15
  aJcxs_h_01_02     : TAnalyzeResult;//基床系数（水平）0.1～0.2 16
  aJcxs_h_02_04     : TAnalyzeResult;//基床系数（水平）0.2～0.4   17

  aJzcylxs          :TAnalyzeResult;  //静止侧压力系数  18

  aWcxkyqd_yz       :TAnalyzeResult; //无侧限抗压强度 原状     19
  aWcxkyqd_cs       :TAnalyzeResult; //无侧限抗压强度 重塑     20
  aWcxkyqd_lmd      :TAnalyzeResult; //无侧限抗压强度 灵敏度   21

  aSzsy_zyl_njl_UU  :TAnalyzeResult;  //总应力粘聚力UU     22
  aSzsy_zyl_nmcj_UU :TAnalyzeResult;  //总应力内摩擦角UU     23
  aSzsy_zyl_njl_CU  :TAnalyzeResult;  //总应力 粘聚力CU        24
  aSzsy_zyl_nmcj_CU :TAnalyzeResult;  //总应力内摩擦角CU      25
  aSzsy_yxyl_njl    :TAnalyzeResult;  //有效应力粘聚力               26
  aSzsy_yxyl_nmcj   :TAnalyzeResult;  //有效应力内摩擦角              27

  aStxs_kv          : TAnalyzeResult;//渗透系数Kv   28
  aStxs_kh          : TAnalyzeResult;//渗透系数KH   29

  aTrpj_g       : TAnalyzeResult;//天然坡角  干   30
  aTrpj_sx      : TAnalyzeResult;//天然坡角  水下 31

  aKlzc_li              : TAnalyzeResult;//颗粒组成（砾）>2 32
  aKlzc_sha_2_05        : TAnalyzeResult;//颗粒组成（砂）2～0.5           33
  aKlzc_sha_05_025      : TAnalyzeResult;//颗粒组成（砂）0.5～0.25        34
  aKlzc_sha_025_0075    : TAnalyzeResult;//颗粒组成（砂）0.25～0.075      35
  aKlzc_fl          :TAnalyzeResult;     //颗粒组成（粉粒）0.075～0.005   36
  aKlzc_nl          :TAnalyzeResult;     //颗粒组成（粘粒） <0.005        37

  aLj_yxlj          :TAnalyzeResult;//有效粒径     38
  aLj_pjlj          :TAnalyzeResult; //平均粒径        39
  aLj_xzlj          :TAnalyzeResult;  //限制粒径      40
  aLj_d70           :TAnalyzeResult; //               41

  aBjyxs   :TAnalyzeResult; //不均匀系数              42
  aQlxs    :TAnalyzeResult;//曲率系数                43
  
  ArrayAnalyzeResult: Array[0..AnalyzeCount-1] of TAnalyzeResult;  // 保存要参加统计的TAnalyzeResult
  ArrayFieldNames: Array[0..AnalyzeCount-1] of String; // 保存要参加统计的字段名,与ArrayAnalyzeResult的内容一一对应
  ArrayToFieldNames: Array[0..AnalyzeCount-1] of String; // 保存要插入到TeShuYangTzsTmp表的字段名，主要是为了剪切实验的UU和CU的总应力
  //初始化此过程中的变量
  procedure InitVar;
  var 
    iCount: integer;
  begin
    ArrayAnalyzeResult[0]:= aGygj_pc;                               ArrayFieldNames[0]:= 'Gygj_pc';
    ArrayAnalyzeResult[1]:= aGygj_cc;                               ArrayFieldNames[1]:= 'Gygj_cc';
    ArrayAnalyzeResult[2]:= aGygj_cs;                               ArrayFieldNames[2]:= 'Gygj_cs';
    ArrayAnalyzeResult[3]:= aHtml;                                  ArrayFieldNames[3]:= 'Html';
    ArrayAnalyzeResult[4]:= aGjxs50_1;                              ArrayFieldNames[4]:= 'Gjxs50_1';
    ArrayAnalyzeResult[5]:= aGjxs100_1;                             ArrayFieldNames[5]:= 'Gjxs100_1';
    ArrayAnalyzeResult[6]:= aGjxs200_1;                             ArrayFieldNames[6]:= 'Gjxs200_1';
    ArrayAnalyzeResult[7]:= aGjxs400_1;                             ArrayFieldNames[7]:= 'Gjxs400_1';
    ArrayAnalyzeResult[8]:= aGjxs50_2;                              ArrayFieldNames[8]:= 'Gjxs50_2';
    ArrayAnalyzeResult[9]:= aGjxs100_2;                             ArrayFieldNames[9]:= 'Gjxs100_2';
    ArrayAnalyzeResult[10]:= aGjxs200_2;                            ArrayFieldNames[10]:= 'Gjxs200_2';
    ArrayAnalyzeResult[11]:= aGjxs400_2;                            ArrayFieldNames[11]:= 'Gjxs400_2';
    ArrayAnalyzeResult[12]:= aJcxs_v_005_01;                        ArrayFieldNames[12]:= 'Jcxs_v_005_01';
    ArrayAnalyzeResult[13]:= aJcxs_v_01_02;                         ArrayFieldNames[13]:= 'Jcxs_v_01_02';
    ArrayAnalyzeResult[14]:= aJcxs_v_02_04;                         ArrayFieldNames[14]:= 'Jcxs_v_02_04';
    ArrayAnalyzeResult[15]:= aJcxs_h_005_01;                        ArrayFieldNames[15]:= 'Jcxs_h_005_01';
    ArrayAnalyzeResult[16]:= aJcxs_h_01_02;                         ArrayFieldNames[16]:= 'Jcxs_h_01_02';
    ArrayAnalyzeResult[17]:= aJcxs_h_02_04;                         ArrayFieldNames[17]:= 'Jcxs_h_02_04';
    ArrayAnalyzeResult[18]:= aJzcylxs;                              ArrayFieldNames[18]:= 'Jzcylxs';
    ArrayAnalyzeResult[19]:= aWcxkyqd_yz;                           ArrayFieldNames[19]:= 'Wcxkyqd_yz';
    ArrayAnalyzeResult[20]:= aWcxkyqd_cs;                           ArrayFieldNames[20]:= 'Wcxkyqd_cs';
    ArrayAnalyzeResult[21]:= aWcxkyqd_lmd;                          ArrayFieldNames[21]:= 'Wcxkyqd_lmd';
    ArrayAnalyzeResult[22]:= aSzsy_zyl_njl_UU;                      ArrayFieldNames[22]:= 'Szsy_zyl_njl_UU';
    ArrayAnalyzeResult[23]:= aSzsy_zyl_nmcj_UU;                     ArrayFieldNames[23]:= 'Szsy_zyl_nmcj_UU';
    ArrayAnalyzeResult[24]:= aSzsy_zyl_njl_CU;                      ArrayFieldNames[24]:= 'Szsy_zyl_njl_CU';
    ArrayAnalyzeResult[25]:= aSzsy_zyl_nmcj_CU;                     ArrayFieldNames[25]:= 'Szsy_zyl_nmcj_CU';
    ArrayAnalyzeResult[26]:= aSzsy_yxyl_njl;                        ArrayFieldNames[26]:= 'Szsy_yxyl_njl';
    ArrayAnalyzeResult[27]:= aSzsy_yxyl_nmcj;                       ArrayFieldNames[27]:= 'Szsy_yxyl_nmcj';
    ArrayAnalyzeResult[28]:= aStxs_kv;                              ArrayFieldNames[28]:= 'Stxs_kv';
    ArrayAnalyzeResult[29]:= aStxs_kh;                              ArrayFieldNames[29]:= 'Stxs_kh';
    ArrayAnalyzeResult[30]:= aTrpj_g;                               ArrayFieldNames[30]:= 'Trpj_g';
    ArrayAnalyzeResult[31]:= aTrpj_sx;                              ArrayFieldNames[31]:= 'Trpj_sx';
    ArrayAnalyzeResult[32]:= aKlzc_li;                              ArrayFieldNames[32]:= 'Klzc_li';
    ArrayAnalyzeResult[33]:= aKlzc_sha_2_05;                        ArrayFieldNames[33]:= 'Klzc_sha_2_05';
    ArrayAnalyzeResult[34]:= aKlzc_sha_05_025;                      ArrayFieldNames[34]:= 'Klzc_sha_05_025';
    ArrayAnalyzeResult[35]:= aKlzc_sha_025_0075;                    ArrayFieldNames[35]:= 'Klzc_sha_025_0075';
    ArrayAnalyzeResult[36]:= aKlzc_fl;                              ArrayFieldNames[36]:= 'Klzc_fl';
    ArrayAnalyzeResult[37]:= aKlzc_nl;                              ArrayFieldNames[37]:= 'Klzc_nl';
    ArrayAnalyzeResult[38]:= aLj_yxlj;                              ArrayFieldNames[38]:= 'Lj_yxlj';
    ArrayAnalyzeResult[39]:= aLj_pjlj;                              ArrayFieldNames[39]:= 'Lj_pjlj';
    ArrayAnalyzeResult[40]:= aLj_xzlj;                              ArrayFieldNames[40]:= 'Lj_xzlj';
    ArrayAnalyzeResult[41]:= aLj_d70;                               ArrayFieldNames[41]:= 'Lj_d70';
    ArrayAnalyzeResult[42]:= aBjyxs;                                ArrayFieldNames[42]:= 'bjyxs';
    ArrayAnalyzeResult[43]:= aQlxs;                                 ArrayFieldNames[43]:= 'qlxs';



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
    lstYssy_yali:= TStringList.Create;
    lstYssy_bxl:= TStringList.Create;
    lstYssy_kxb:= TStringList.Create;
    lstYssy_ysxs:= TStringList.Create;
    lstYssy_ysml:= TStringList.Create;
    
    for iCount:=0 to AnalyzeCount-1 do
    begin
      ArrayAnalyzeResult[iCount].lstValues := TStringList.Create;
      ArrayAnalyzeResult[iCount].lstValuesForPrint := TStringList.Create;
    end;
    aGygj_pc.FormatString := '0.0';
    aGygj_cc.FormatString := '0.0000';
    aGygj_cs.FormatString := '0.0000';
    aHtml.FormatString := '0.0';
    aGjxs50_1.FormatString := '0.000';
    aGjxs100_1.FormatString := '0.000';
    aGjxs200_1.FormatString := '0.000';
    aGjxs400_1.FormatString := '0.000';
    aGjxs50_2.FormatString := '0.000';                   aStxs_kv.FormatString := '0.0000';
    aGjxs100_2.FormatString := '0.000';                  aStxs_kh.FormatString := '0.0000';
    aGjxs200_2.FormatString := '0.000';                  aTrpj_g.FormatString := '0';
    aGjxs400_2.FormatString := '0.000';                  aTrpj_sx.FormatString := '0';
    aJcxs_v_005_01.FormatString := '0.00';
    aJcxs_v_01_02.FormatString := '0.00';                aKlzc_li.FormatString := '0.0';
    aJcxs_v_02_04.FormatString := '0.00';                aKlzc_sha_2_05.FormatString := '0.0';
    aJcxs_h_005_01.FormatString := '0.00';               aKlzc_sha_05_025.FormatString := '0.0';
    aJcxs_h_01_02.FormatString := '0.00';                aKlzc_sha_025_0075.FormatString := '0.0';
    aJcxs_h_02_04.FormatString := '0.00';                aKlzc_fl.FormatString := '0.0';
    aJzcylxs.FormatString := '0.000';                    aKlzc_nl.FormatString := '0.0';
    aWcxkyqd_yz.FormatString := '0.0';
    aWcxkyqd_cs.FormatString := '0.0';                   aLj_yxlj.FormatString := '0.000';
    aWcxkyqd_lmd.FormatString:= '0.00';                  aLj_pjlj.FormatString := '0.000';
    aSzsy_zyl_njl_UU.FormatString := '0.0';              aLj_xzlj.FormatString := '0.000';
    aSzsy_zyl_nmcj_UU.FormatString := '0.0';             aLj_d70.FormatString := '0.000';
    aSzsy_zyl_njl_CU.FormatString := '0.0';
    aSzsy_zyl_nmcj_CU.FormatString := '0.0';             aBjyxs.FormatString := '0.00';
    aSzsy_yxyl_njl.FormatString := '0.0';                aQlxs.FormatString := '0.00';
    aSzsy_yxyl_nmcj.FormatString := '0.0';
    


  end;
  
  //释放此过程中的变量
  procedure FreeStringList;
  var
    iCount: integer;
  begin
    lstStratumNo.Free;        lstPowder_big.Free;
    lstSubNo.Free;            lstPowder_small.Free;
    lstBeginDepth.Free;       lstClay_grain.Free;
    lstEndDepth.Free;         lstAsymmetry_coef.Free;
    lstDrl_no.Free;           lstCurvature_coef.Free;
    lstS_no.Free;             lstEa_name.Free;
    lstShear_type.Free;       lstYssy_yali.Free;
    lstsand_big.Free;         lstYssy_bxl.Free;
    lstsand_middle.Free;      lstYssy_kxb.Free;
    lstsand_small.Free;       lstYssy_ysxs.Free;
                              lstYssy_ysml.Free;

    for iCount:=0 to AnalyzeCount-1 do
    begin
      ArrayAnalyzeResult[iCount].lstValues.Free;
      ArrayAnalyzeResult[iCount].lstValuesForPrint.Free;
    end;
  end;

    //计算临界值
  function CalculateCriticalValue(aValue, aPingjunZhi, aBiaoZhunCha: double): double;
  begin
    if aBiaoZhunCha = 0 then
    begin
      result:= 0;
      exit;
    end;
    result := (aValue - aPingjunZhi) / aBiaoZhunCha;
  end;



  //计算平均值、标准差、变异系数等特征值。关联剔除 就是一个剔除时，另一个也剔除
  //1、压缩系数 在剔除时要同时把压缩模量剔除 ，压缩模量在计算时不再做剔除处理
  //2、凝聚力和摩擦角 都需要剔除，关联剔除
  //3、含水量，液限 若超差要剔除，同时把塑性指数和液性指数剔除 。
  //   3的判别顺序是：先判断含水量，若剔除时也要把液限剔除。后判断液限，若剔除时并不要把含水量剔除。
  //另外，2009/12/29工勘院修改要求，只有凝聚力和摩擦角、标贯、静探需要计算标准值，其他都不在计算标准值，同时报表上这些不要计算标准值的要空白显示。
  //2011/03/09 工勘院修改要求，所有字段都要计算标准值，因为特殊样分层统计表只是内部看，所以数据都要。
  procedure GetTeZhengShuGuanLian(var aAnalyzeResult : TAnalyzeResult;Flags: TGuanLianFlags);
  var
    i,iCount,iFirst,iMax:integer;
    dTotal,dValue,dTotalFangCha,dCriticalValue:double;
    strValue: string;
    TiChuGuo: boolean; //数据在计算时是否有过剔除，如果有，那么涉及到关联剔除的另外的数据也要重新计算
  begin
    iMax:=0;
    dTotal:= 0;
    iFirst:= 0;
    TiChuGuo := false;
    dTotalFangCha:=0;
    aAnalyzeResult.PingJunZhi := -1;
    aAnalyzeResult.BiaoZhunCha := -1;
    aAnalyzeResult.BianYiXiShu := -1;
    aAnalyzeResult.MaxValue := -1;
    aAnalyzeResult.MinValue := -1;
    aAnalyzeResult.SampleNum := -1;
    aAnalyzeResult.BiaoZhunZhi:= -1;
    if aAnalyzeResult.lstValues.Count<1 then exit;
    strValue := '';
    for i:= 0 to aAnalyzeResult.lstValues.Count-1 do
        strValue:=strValue + aAnalyzeResult.lstValues.Strings[i];
    strValue := trim(strValue);
    if strValue='' then exit;

  //yys 2005/06/15
    iCount:= aAnalyzeResult.lstValues.Count;
    for i:= 0 to aAnalyzeResult.lstValues.Count-1 do
      begin
        strValue:=aAnalyzeResult.lstValues.Strings[i];
        if strValue='' then
        begin
          iCount:=iCount-1;
        end
        else
        begin
          inc(iFirst);
          dValue:= StrToFloat(strValue);
          if iFirst=1 then
            begin
              aAnalyzeResult.MinValue:= dValue;
              aAnalyzeResult.MaxValue:= dValue;

              iMax := i;
            end
          else
            begin
              if aAnalyzeResult.MinValue>dValue then
              begin
                aAnalyzeResult.MinValue:= dValue;

              end;
              if aAnalyzeResult.MaxValue<dValue then
              begin
                aAnalyzeResult.MaxValue:= dValue;
                iMax := i;
              end;                            
            end;           
          dTotal:= dTotal + dValue;          
        end;
      end;
    //dTotal:= dTotal - aAnalyzeResult.MinValue - aAnalyzeResult.MaxValue;
    //iCount := iCount - 2;
    if iCount>=1 then
      aAnalyzeResult.PingJunZhi := dTotal/iCount
    else
      aAnalyzeResult.PingJunZhi := dTotal;
    //aAnalyzeResult.lstValues.Strings[iMin]:= '';
    //aAnalyzeResult.lstValues.Strings[iMax]:= '';

    //iCount:= aAnalyzeResult.lstValues.Count;
    for i:= 0 to aAnalyzeResult.lstValues.Count-1 do
    begin
      strValue:=aAnalyzeResult.lstValues.Strings[i];
      if strValue<>'' then
      begin
        dValue := StrToFloat(strValue);
        dTotalFangCha := dTotalFangCha + sqr(dValue-aAnalyzeResult.PingJunZhi);
      end
      //else iCount:= iCount -1;
    end;
    if iCount>1 then
      dTotalFangCha:= dTotalFangCha/(iCount-1);
    aAnalyzeResult.SampleNum := iCount;
    if iCount >1 then
      aAnalyzeResult.BiaoZhunCha := sqrt(dTotalFangCha)
    else
      aAnalyzeResult.BiaoZhunCha := sqrt(dTotalFangCha);
    if not iszero(aAnalyzeResult.PingJunZhi) then
      aAnalyzeResult.BianYiXiShu := strtofloat(formatfloat(aAnalyzeResult.FormatString,aAnalyzeResult.BiaoZhunCha / aAnalyzeResult.PingJunZhi))
    else
      aAnalyzeResult.BianYiXiShu:= 0;
    if iCount>=6 then
    begin //2009/12/29工勘院修改要求，只有凝聚力和摩擦角需要计算标准值，其他都不在计算标准值，同时报表上这些不要计算标准值的要空白显示。
          //2011/03/09 工勘院修改要求,所有的字段都要计算标准值
        //if (tgNingJuLi_ZhiKuai in Flags) or (tgMoCaJiao_ZhiKuai in Flags) or (tgNingJuLi_GuKuai in Flags) or (tgMoCaJiao_GuKuai in Flags) then
          aAnalyzeResult.BiaoZhunZhi := GetBiaoZhunZhi(aAnalyzeResult.SampleNum , aAnalyzeResult.BianYiXiShu, aAnalyzeResult.PingJunZhi);
    end;
    dValue:= CalculateCriticalValue(aAnalyzeResult.MaxValue, aAnalyzeResult.PingJunZhi,aAnalyzeResult.BiaoZhunCha);
    dCriticalValue := GetCriticalValue(iCount);

  //2005/07/25 yys edit 土样数据剔除时，到6个样就不再剔除，剔除时要先剔除最大的数据，同时关联的其他数据一并剔除

    if (iCount> 6) AND (dValue > dCriticalValue) then
      begin
        aAnalyzeResult.lstValues.Strings[iMax]:= '';
        aAnalyzeResult.lstValuesForPrint.Strings[iMax]:= '-'
          +aAnalyzeResult.lstValuesForPrint.Strings[iMax];
        TiChuGuo := true;
        if tgHanShuiLiang in Flags then
        begin
          ArrayAnalyzeResult[7].lstValues.Strings[iMax]:= ''; //液限
          ArrayAnalyzeResult[8].lstValues.Strings[iMax]:= ''; //塑限 Shape_limit;
          ArrayAnalyzeResult[9].lstValues.Strings[iMax]:= ''; //塑性指数 Shape_index;
          ArrayAnalyzeResult[10].lstValues.Strings[iMax]:= ''; //液性指数 Liquid_index;
          //打印时负数转换成*加正数 如-10 打印时会转换成*10
          if ArrayAnalyzeResult[7].lstValuesForPrint.Strings[iMax]<>'' then
            ArrayAnalyzeResult[7].lstValuesForPrint.Strings[iMax]:= '-'
              +ArrayAnalyzeResult[7].lstValuesForPrint.Strings[iMax]; //液限
          if ArrayAnalyzeResult[8].lstValuesForPrint.Strings[iMax]<>'' then
            ArrayAnalyzeResult[8].lstValuesForPrint.Strings[iMax]:= '-'
              +ArrayAnalyzeResult[8].lstValuesForPrint.Strings[iMax]; //塑限 Shape_limit;
          if ArrayAnalyzeResult[9].lstValuesForPrint.Strings[iMax]<>'' then
            ArrayAnalyzeResult[9].lstValuesForPrint.Strings[iMax]:= '-'
              +ArrayAnalyzeResult[9].lstValuesForPrint.Strings[iMax]; //塑性指数 Shape_index;
          if ArrayAnalyzeResult[10].lstValuesForPrint.Strings[iMax]<>'' then
            ArrayAnalyzeResult[10].lstValuesForPrint.Strings[iMax]:= '-'
              +ArrayAnalyzeResult[10].lstValuesForPrint.Strings[iMax]; //液性指数 Liquid_index;
        end
        else if tgYeXian in Flags then
        begin
          ArrayAnalyzeResult[8].lstValues.Strings[iMax]:= ''; //塑限 Shape_limit;
          ArrayAnalyzeResult[9].lstValues.Strings[iMax]:= ''; //塑性指数 Shape_index;
          ArrayAnalyzeResult[10].lstValues.Strings[iMax]:= ''; //液性指数 Liquid_index;

          if ArrayAnalyzeResult[8].lstValuesForPrint.Strings[iMax]<>'' then
            ArrayAnalyzeResult[8].lstValuesForPrint.Strings[iMax]:= '-'
              +ArrayAnalyzeResult[8].lstValuesForPrint.Strings[iMax]; //塑限 Shape_limit;
          if ArrayAnalyzeResult[9].lstValuesForPrint.Strings[iMax]<>'' then
            ArrayAnalyzeResult[9].lstValuesForPrint.Strings[iMax]:= '-'
              +ArrayAnalyzeResult[9].lstValuesForPrint.Strings[iMax]; //塑性指数 Shape_index;
          if ArrayAnalyzeResult[10].lstValuesForPrint.Strings[iMax]<>'' then
          ArrayAnalyzeResult[10].lstValuesForPrint.Strings[iMax]:= '-'
            +ArrayAnalyzeResult[10].lstValuesForPrint.Strings[iMax]; //液性指数 Liquid_index;
        end
        else if tgYaSuoXiShu in Flags then
        begin
          ArrayAnalyzeResult[12].lstValues.Strings[iMax]:= ''; //压缩模量 Zip_modulus;
          if ArrayAnalyzeResult[12].lstValuesForPrint.Strings[iMax]<>'' then
            ArrayAnalyzeResult[12].lstValuesForPrint.Strings[iMax]:= '-'
              +ArrayAnalyzeResult[12].lstValuesForPrint.Strings[iMax];
        end
        else if tgNingJuLi_ZhiKuai in Flags then    //凝聚力直快
        begin
          ArrayAnalyzeResult[14].lstValues.Strings[iMax]:= ''; //摩擦角直快 Friction_angle
          if ArrayAnalyzeResult[14].lstValuesForPrint.Strings[iMax]<>'' then
            ArrayAnalyzeResult[14].lstValuesForPrint.Strings[iMax]:= '-'
              +ArrayAnalyzeResult[14].lstValuesForPrint.Strings[iMax];
        end
        else if tgMoCaJiao_ZhiKuai in Flags then
        begin
          ArrayAnalyzeResult[13].lstValues.Strings[iMax]:= ''; //凝聚力直快 Cohesion
          if ArrayAnalyzeResult[13].lstValuesForPrint.Strings[iMax]<>'' then
            ArrayAnalyzeResult[13].lstValuesForPrint.Strings[iMax]:= '-'
              +ArrayAnalyzeResult[13].lstValuesForPrint.Strings[iMax];
        end
        else if tgNingJuLi_GuKuai in Flags then    //凝聚力固快
        begin
          ArrayAnalyzeResult[16].lstValues.Strings[iMax]:= ''; //摩擦角固快 Friction_gk
          if ArrayAnalyzeResult[16].lstValuesForPrint.Strings[iMax]<>'' then
            ArrayAnalyzeResult[16].lstValuesForPrint.Strings[iMax]:= '-'
              +ArrayAnalyzeResult[16].lstValuesForPrint.Strings[iMax];
        end
        else if tgMoCaJiao_GuKuai in Flags then
        begin
          ArrayAnalyzeResult[15].lstValues.Strings[iMax]:= ''; //凝聚力固快 Cohesion_gk
          if ArrayAnalyzeResult[15].lstValuesForPrint.Strings[iMax]<>'' then
            ArrayAnalyzeResult[15].lstValuesForPrint.Strings[iMax]:= '-'
              +ArrayAnalyzeResult[15].lstValuesForPrint.Strings[iMax];
        end;
        GetTeZhengShuGuanLian(aAnalyzeResult, Flags);
      end;

    if TiChuGuo then
    begin
      if tgNingJuLi_ZhiKuai in Flags then    //凝聚力直快
      begin
        GetTeZhengShuGuanLian(ArrayAnalyzeResult[14], [tgMoCaJiao_ZhiKuai]); //摩擦角直快 Friction_angle
      end
      else if tgMoCaJiao_ZhiKuai in Flags then
      begin
        GetTeZhengShuGuanLian(ArrayAnalyzeResult[13], [tgNingJuLi_ZhiKuai]);//凝聚力直快 Cohesion
      end
      else if tgNingJuLi_GuKuai in Flags then    //凝聚力固快
      begin
        GetTeZhengShuGuanLian(ArrayAnalyzeResult[16], [tgMoCaJiao_GuKuai]);//摩擦角固快 Friction_gk
      end
      else if tgMoCaJiao_GuKuai in Flags then
      begin
        GetTeZhengShuGuanLian(ArrayAnalyzeResult[15], [tgNingJuLi_GuKuai]);//凝聚力固快 Cohesion_gk
      end;
    end;

  //yys 2005/06/15 add, 当一层只有一个样时，标准差和变异系数不能为0，打印报表时要用空格，物理力学表也一样。所以用-1来表示空值，是因为在报表设计时可以通过判断来表示为空。
    if  iCount=1 then
    begin
       //aAnalyzeResult.strBianYiXiShu  := 'null';
       //aAnalyzeResult.strBiaoZhunCha  := 'null';
       aAnalyzeResult.BianYiXiShu := -1;
       aAnalyzeResult.BiaoZhunCha := -1;
       aAnalyzeResult.BiaoZhunZhi := -1;
    end
    else begin
       //aAnalyzeResult.strBianYiXiShu := FloatToStr(aAnalyzeResult.BianYiXiShu);
      // aAnalyzeResult.strBiaoZhunCha := FloatToStr(aAnalyzeResult.BiaoZhunCha);
    end;
  //yys 2005/06/15 add
  end;

   //取得一个工程中所有的层号和亚层号和土类名称，保存在三个TStringList变量中。
  procedure GetAllStratumNo(var AStratumNoList, ASubNoList, AEaNameList: TStringList);
  var
    strSQL: string;
  begin
    AStratumNoList.Clear;
    ASubNoList.Clear;
    AEaNameList.Clear;
    strSQL:='SELECT id,prj_no,stra_no,sub_no,ISNULL(ea_name,'''') as ea_name FROM stratum_description'
        +' WHERE prj_no='+''''+g_ProjectInfo.prj_no_ForSQL+''''
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

begin
  try
    //开始给土样分层 ,此处注释掉不用是因为已经在土样数据修改时分层了。
    //SetTuYangCengHao;

    //开始清空临时统计表的当前工程数据
    //strSQL:= 'TRUNCATE TABLE stratumTmp; TRUNCATE TABLE TeZhengShuTmp; TRUNCATE TABLE earthsampleTmp; TRUNCATE TABLE earthsampleTmp ';
    strSQL:= 'DELETE FROM stratumTmp WHERE prj_no = '+''''+g_ProjectInfo.prj_no_ForSQL+''''+';'
            +'DELETE FROM TeShuYangTzsTmp WHERE prj_no = '+''''+g_ProjectInfo.prj_no_ForSQL+''''+';'
            +'DELETE FROM TeShuYangTmp WHERE prj_no = '+''''+g_ProjectInfo.prj_no_ForSQL+'''';
    if not Delete_oneRecord(MainDataModule.qrySectionTotal, strSQL) then
    begin
      exit;
    end;

    InitVar;
    GetAllStratumNo(lstStratumNo, lstSubNo, lstEa_name);
    if lstStratumNo.Count = 0 then 
    begin
      //FreeStringList;
      exit;
    end;

    {//将层号和亚层号和土类名称插入临时主表
    for i:=0 to lstStratumNo.Count-1 do
    begin
      strSQL:='INSERT INTO stratumTmp (prj_no,stra_no,sub_no,ea_name) VALUES('
        +''''+g_ProjectInfo.prj_no_ForSQL+''''+','
        +''''+lstStratumNo.Strings[i]+'''' +','
        +''''+lstSubNo.Strings[i]+''''+','
        +''''+lstEa_name.Strings[i]+''''+')';
      Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL);   
    end;}
    strPrjNo := g_ProjectInfo.prj_no_ForSQL;
    for i:=0 to lstStratumNo.Count-1 do
    begin
      strSubNo := stringReplace(lstSubNo.Strings[i],'''','''''',[rfReplaceAll]);
      strStratumNo := lstStratumNo.Strings[i];
      //2008/11/21 yys edit 加入选择条件，钻孔参与统计
      strSQL:='SELECT es.*,et.ea_name_en FROM (SELECT * FROM TeShuYang '
          +' WHERE prj_no='+''''+strPrjNo+''''
          +' AND stra_no='+''''+strStratumNo+''''
          +' AND sub_no='+''''+strSubNo+''''
          +' AND if_statistic=1 and drl_no in (select drl_no from drills where can_tongji=0 '
          +' AND prj_no='+''''+strPrjNo+''''
          +')) as es '
          +' Left Join earthtype et on es.ea_name=et.ea_name';

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
      lstYssy_yali.Clear;
      lstYssy_bxl.Clear;
      lstYssy_kxb.Clear;
      lstYssy_ysxs.Clear;
      lstYssy_ysml.Clear;
    
      for j:=0 to AnalyzeCount-1 do
      begin
        ArrayAnalyzeResult[j].lstValues.Clear;
        ArrayAnalyzeResult[j].lstValuesForPrint.Clear;
      end;
          
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
//              lstShear_type.Add(FieldByName('shear_type').AsString);
//              lstsand_big.Add(FieldByName('sand_big').AsString);
//              lstsand_middle.Add(FieldByName('sand_middle').AsString);
//              lstsand_small.Add(FieldByName('sand_small').AsString);
//              lstPowder_big.Add(FieldByName('powder_big').AsString);
//              lstPowder_small.Add(FieldByName('powder_small').AsString);
//              lstClay_grain.Add(FieldByName('clay_grain').AsString);
//              lstAsymmetry_coef.Add(FieldByName('asymmetry_coef').AsString);
//              lstCurvature_coef.Add(FieldByName('curvature_coef').AsString);
              if g_ProjectInfo.prj_ReportLanguage= trChineseReport then
                lstEa_name.Add(FieldByName('ea_name').AsString)
              else if g_ProjectInfo.prj_ReportLanguage= trEnglishReport then
                lstEa_name.Add(FieldByName('ea_name_en').AsString);

//              lstYssy_yali.Add(FieldByName('Yssy_yali').AsString);
//              lstYssy_bxl.Add(FieldByName('Yssy_bxl').AsString);
//              lstYssy_kxb.Add(FieldByName('Yssy_kxb').AsString);
//              lstYssy_ysxs.Add(FieldByName('Yssy_ysxs').AsString);
//              lstYssy_ysml.Add(FieldByName('Yssy_ysml').AsString);
              for j:=0 to AnalyzeCount-1 do
              begin
                ArrayAnalyzeResult[j].lstValues.Add(FieldByName(ArrayFieldNames[j]).AsString);
                ArrayAnalyzeResult[j].lstValuesForPrint.Add(FieldByName(ArrayFieldNames[j]).AsString);
              end;

//              if FieldByName('szsy_syff').AsString = 'UU' then //如果试验方法是UU，那么CU中的总应力和有效应力都应该是空，如果是CU，那么UU的总应力就要设为空的
//              begin
////                    ArrayAnalyzeResult[21]:= aSzsy_zyl_njl_CU;
////                    ArrayAnalyzeResult[22]:= aSzsy_zyl_nmcj_CU;
////                    ArrayAnalyzeResult[23]:= aSzsy_yxyl_njl;
////                    ArrayAnalyzeResult[24]:= aSzsy_yxyl_nmcj;
//                ArrayAnalyzeResult[21].lstValues[ArrayAnalyzeResult[21].lstValues.Count-1] := '';
//                ArrayAnalyzeResult[22].lstValues[ArrayAnalyzeResult[22].lstValues.Count-1] := '';
//                ArrayAnalyzeResult[23].lstValues[ArrayAnalyzeResult[23].lstValues.Count-1] := '';
//                ArrayAnalyzeResult[24].lstValues[ArrayAnalyzeResult[24].lstValues.Count-1] := '';
//              end
//              else if FieldByName('szsy_syff').AsString = 'CU' then
//              begin
//                ArrayAnalyzeResult[19].lstValues[ArrayAnalyzeResult[21].lstValues.Count-1] := '';
//                ArrayAnalyzeResult[20].lstValues[ArrayAnalyzeResult[22].lstValues.Count-1] := '';
//              end;


              next;
            end;
          close;
        end;
      if iRecordCount=0 then //如果没有土样信息，则插入空值到特征数表，
      begin                  //这是为了以后在特征数表TeShuYangTzsTmp插入静力触探和标贯数据时，只用UPDATE语句就可以了
        for j:= 1 to 7 do
        begin 
          strSQL:='INSERT INTO TeShuYangTzsTmp '
            +'VALUES ('+''''+strPrjNo+''''+','
            +''''+strStratumNo+'''' +','
            +''''+strSubNo+''''+','''+InttoStr(j)+'''' + DupeString(',-1', 46)+')';
          Insert_oneRecord(MainDataModule.qryPublic, strSQL);
        end;
        continue;
      end;
     

      //取得特征数
//2007/01/24 下面这两句注释起来是因为
//      for j:=0 to AnalyzeCount-1 do
//        getTeZhengShu(ArrayAnalyzeResult[j], [tfTuYang]);
//     GetTeZhengShuGuanLian(ArrayAnalyzeResult[0],[tgHanShuiLiang]); //含水量     0
//     GetTeZhengShuGuanLian(ArrayAnalyzeResult[7],[tgYeXian]);       //液限       7
//     for j:=1 to 6 do
//       getTeZhengShu(ArrayAnalyzeResult[j], [tfTuYang]);
//     for j:=8 to 10 do  //塑限       8 塑性指数   9  液性指数   10   不进行剔除
//       getTeZhengShu(ArrayAnalyzeResult[j], [tfOther]);
//     GetTeZhengShuGuanLian(ArrayAnalyzeResult[11],[tgYaSuoXiShu]);   //压缩系数   11
//     getTeZhengShu(ArrayAnalyzeResult[12], [tfOther]);              //压缩模量   12   不进行剔除
//
//     GetTeZhengShuGuanLian(ArrayAnalyzeResult[13],[tgNingJuLi_ZhiKuai]);   //凝聚力直快 13
//     GetTeZhengShuGuanLian(ArrayAnalyzeResult[14],[tgMoCaJiao_ZhiKuai]);   //摩擦角直快 14
//     GetTeZhengShuGuanLian(ArrayAnalyzeResult[15],[tgNingJuLi_GuKuai]);   //凝聚力固快 15
//     GetTeZhengShuGuanLian(ArrayAnalyzeResult[16],[tgMoCaJiao_GuKuai]);   //摩擦角固快 16
//     ArrayFieldNames[18]:= 'Jzcylxs';                  ArrayToFieldNames[18]:= 'Jzcylxs';
//    ArrayFieldNames[19]:= 'Szsy_zyl_njl_uu';          ArrayToFieldNames[19]:= 'Szsy_zyl_njl_uu';
//    ArrayFieldNames[20]:= 'Szsy_zyl_nmcj_uu';         ArrayToFieldNames[20]:= 'Szsy_zyl_nmcj_uu';
//    ArrayFieldNames[21]:= 'Szsy_zyl_njl_cu';          ArrayToFieldNames[21]:= 'Szsy_zyl_njl_cu';
//    ArrayFieldNames[22]:= 'Szsy_zyl_nmcj_cu';         ArrayToFieldNames[22]:= 'Szsy_zyl_nmcj_cu';
//    ArrayFieldNames[23]:= 'Szsy_yxyl_njl';            ArrayToFieldNames[23]:= 'Szsy_yxyl_njl';
//    ArrayFieldNames[24]:= 'Szsy_yxyl_nmcj';           ArrayToFieldNames[24]:= 'Szsy_yxyl_nmcj';
//    ArrayFieldNames[25]:= 'Stxs_kv';                  ArrayToFieldNames[25]:= 'Stxs_kv';
//    ArrayFieldNames[26]:= 'Stxs_kh';                  ArrayToFieldNames[26]:= 'Stxs_kh';
     for j:=0 to 21 do
       getTeZhengShu(ArrayAnalyzeResult[j], [tfTeShuYang]);  //1到21的栏目不需要剔除
     for j:=22 to 27 do
       getTeZhengShu(ArrayAnalyzeResult[j], [tfTeShuYangBiaoZhuZhi]); //只有UU和CU的总应力和有效应力需要剔除
     for j:=28 to 43 do
       getTeZhengShu(ArrayAnalyzeResult[j], [tfTeShuYang]);  //渗透系数也不需要剔除

//2007/01/24
//      for j:=0 to ArrayAnalyzeResult[15].lstValues.count-1 do
//         caption:= caption + ArrayAnalyzeResult[15].lstValues[j]; 

    {******把平均值、标准差、变异系数、最大值、**********}
    {******最小值、样本值、标准值等插入特征数表TeZhengShuTmp ****}
      //开始取得要插入的字段名称。
      strFieldNames:= '';
      for j:=0 to AnalyzeCount-1 do
        strFieldNames:= strFieldNames + ArrayFieldNames[j] + ',';
      strFieldNames:= strFieldNames + 'prj_no, stra_no, sub_no, v_id';

      //开始插入平均值
      strFieldValues:= '';
      strSQL:= '';
      for j:=0 to AnalyzeCount-1 do
        strFieldValues:= strFieldValues +FloatToStr(ArrayAnalyzeResult[j].PingJunZhi)+',';
      strFieldValues:= strFieldValues
        +''''+strPrjNo+''''+','
        +''''+strStratumNo+'''' +','
        +''''+strSubNo+''''+','+TEZHENSHU_Flag_PingJunZhi;
      strSQL:='INSERT INTO TeShuYangTzsTmp (' + strFieldNames + ')'
        +'VALUES('+strFieldValues+')';
      if not Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL) then 
        continue;
      
      //开始插入标准差
      strFieldValues:= '';
      strSQL:= '';
      for j:=0 to AnalyzeCount-1 do
        strFieldValues:= strFieldValues +FloatToStr(ArrayAnalyzeResult[j].BiaoZhunCha)+',';
        //strFieldValues:= strFieldValues +ArrayAnalyzeResult[j].strBiaoZhunCha+',';

      strFieldValues:= strFieldValues
        +''''+strPrjNo+''''+','
        +''''+strStratumNo+'''' +','
        +''''+strSubNo+''''+','+TEZHENSHU_Flag_BiaoZhunCha;
      strSQL:='INSERT INTO TeShuYangTzsTmp (' + strFieldNames + ')'
        +'VALUES('+strFieldValues+')';
      if not Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL) then 
        continue;
      
      //开始插入变异系数
      strFieldValues:= '';
      strSQL:= '';
      for j:=0 to AnalyzeCount-1 do
        strFieldValues:= strFieldValues +FloatToStr(ArrayAnalyzeResult[j].BianYiXiShu)+',';
        //strFieldValues:= strFieldValues + ArrayAnalyzeResult[j].strBianYiXiShu+',';
      strFieldValues:= strFieldValues 
        +''''+strPrjNo+''''+','
        +''''+strStratumNo+'''' +','
        +''''+strSubNo+''''+','+TEZHENSHU_Flag_BianYiXiShu;
      strSQL:='INSERT INTO TeShuYangTzsTmp (' + strFieldNames + ')'
        +'VALUES('+strFieldValues+')';
      if not Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL) then 
        continue;
      
      //开始插入最大值
      strFieldValues:= '';
      strSQL:= '';
      for j:=0 to AnalyzeCount-1 do
        strFieldValues:= strFieldValues +FloatToStr(ArrayAnalyzeResult[j].MaxValue)+',';
      strFieldValues:= strFieldValues 
        +''''+strPrjNo+''''+','
        +''''+strStratumNo+'''' +','
        +''''+strSubNo+''''+','+TEZHENSHU_Flag_MaxValue;
      strSQL:='INSERT INTO TeShuYangTzsTmp (' + strFieldNames + ')'
        +'VALUES('+strFieldValues+')';
      if not Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL) then 
        continue;
      
      //开始插入最小值
      strFieldValues:= '';
      strSQL:= '';
      for j:=0 to AnalyzeCount-1 do
        strFieldValues:= strFieldValues +FloatToStr(ArrayAnalyzeResult[j].MinValue)+',';
      strFieldValues:= strFieldValues 
        +''''+strPrjNo+''''+','
        +''''+strStratumNo+'''' +','
        +''''+strSubNo+''''+','+TEZHENSHU_Flag_MinValue;
      strSQL:='INSERT INTO TeShuYangTzsTmp (' + strFieldNames + ')'
        +'VALUES('+strFieldValues+')';
      if not Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL) then 
        continue;
      
      //开始插入样本值
      strFieldValues:= '';
      strSQL:= '';
      for j:=0 to AnalyzeCount-1 do
        strFieldValues:= strFieldValues +FloatToStr(ArrayAnalyzeResult[j].SampleNum)+',';
      strFieldValues:= strFieldValues
        +''''+strPrjNo+''''+','
        +''''+strStratumNo+'''' +','
        +''''+strSubNo+''''+','+TEZHENSHU_Flag_SampleNum;
      strSQL:='INSERT INTO TeShuYangTzsTmp (' + strFieldNames + ')'
        +'VALUES('+strFieldValues+')';
      if not Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL) then
        continue;

      //开始插入标准值
      strFieldValues:= '';
      strSQL:= '';
      for j:=0 to AnalyzeCount-1 do
        strFieldValues:= strFieldValues +FloatToStr(ArrayAnalyzeResult[j].BiaoZhunZhi)+',';
      strFieldValues:= strFieldValues
        +''''+strPrjNo+''''+','
        +''''+strStratumNo+'''' +','
        +''''+strSubNo+''''+','+TEZHENSHU_Flag_BiaoZhunZhi;
      strSQL:='INSERT INTO TeShuYangTzsTmp (' + strFieldNames + ')'
        +'VALUES('+strFieldValues+')';
      if not Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL) then
        continue;
                  
      {********把经过舍弃的数值插入临时土样表**********}
      for j:=0 to iRecordCount-1 do
      begin
        strFieldNames:= '';
        strFieldValues:= '';
        strSQL:= '';
        strFieldNames:='drl_no, s_no, s_depth_begin, s_depth_end,ea_name,';
        if lstDrl_no.Strings[j]='' then continue;
        strFieldNames:= 'drl_no';
        strFieldValues:= strFieldValues +'''' + stringReplace(lstDrl_no.Strings[j] ,'''','''''',[rfReplaceAll]) +'''';

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

        if lstEa_name.Strings[j]<>'' then
        begin
          strFieldNames:= strFieldNames + ',Ea_name';
          strFieldValues:= strFieldValues  +','+'''' + lstEa_name.Strings[j] +'''';
        end;


        for iCol:=0 to AnalyzeCount-1 do
        begin
          strTmp := ArrayAnalyzeResult[iCol].lstValuesForPrint.Strings[j];
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

        strSQL:='INSERT INTO TeShuYangTmp (' + strFieldNames + ')'
          +'VALUES('+strFieldValues+')';
        if Insert_oneRecord(MainDataModule.qrySectionTotal, strSQL) then
        else;
      
      end;
       
    end;  // end of for i:=0 to lstStratumNo.Count-1 do
  finally
    FreeStringList;

  end;
end;

end.
