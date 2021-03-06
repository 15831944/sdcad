unit DrillsXY;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, StdCtrls, Buttons, ComObj;

type
  TDrillsXYForm = class(TForm)
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
    OpenDialog1: TOpenDialog;
    procedure btnFileOpenClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DrillsXYForm: TDrillsXYForm;

implementation

uses MainDM, public_unit;

{$R *.dfm}

procedure TDrillsXYForm.btnFileOpenClick(Sender: TObject);
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

procedure TDrillsXYForm.btnLoadClick(Sender: TObject);
var
  ExcelApp: Variant;
  Sheet: Variant;
  SFileName,strDrl_no,str_x,str_y, strSQLWhere,strSQLSet,strSQL, strTemp:string;
  J, iMsg, i:integer;

begin
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

    J:=2;  //从第2行开始//若钻孔编号为空，则结束

    while (Sheet.Cells[J,1].text<>'') and (Sheet.Cells[J,2].text<>'') and (Sheet.Cells[J,3].text<>'')   DO
    BEGIN
      strDrl_no := Sheet.Cells[J,1].text;
      str_x:= Sheet.Cells[J,2].text;
      str_y:= Sheet.Cells[J,3].text;
      with MainDataModule.qryDrills do
      begin
        close;
        sql.Clear;
        strSQLWhere:=' WHERE prj_no='+''''+g_ProjectInfo.prj_no_ForSQL+''''
               +' AND drl_no =' +''''+ stringReplace(strDrl_no,'''','''''',[rfReplaceAll])+'''';
        strSQLSet:='UPDATE drills SET drl_x=' + str_x + ', drl_y=' + str_y;
        strSQL := strSQLSet + strSQLWhere;
        sql.Add(strSQL);
        try
          try
            ExecSQL;
            //MessageBox(self.Handle,'更新数据成功！','更新数据',MB_OK+MB_ICONINFORMATION);
            sgResult.Cells[0,j-1] := IntToStr(j-1);
            sgResult.Cells[1,j-1] := strDrl_no;
            sgResult.Cells[2,j-1] := str_x;
            sgResult.Cells[3,j-1] := str_y;
            sgResult.RowCount := sgResult.RowCount + 1;
          except
            //MessageBox(self.Handle,'数据库错误，更新数据失败。','数据库错误',MB_OK+MB_ICONERROR);
          end;
        finally
          close;
        end;
      end;

      J := J + 1;
    end;

  finally
    ExcelApp.Quit;
    ExcelApp := Unassigned;
    screen.Cursor := crDefault;
  end;
end;

procedure TDrillsXYForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= CaFree;
end;

procedure TDrillsXYForm.FormCreate(Sender: TObject);
begin
   self.Left := trunc((screen.Width -self.Width)/2);
   self.Top  := trunc((Screen.Height - self.Height)/2);

   sgResult.ColCount :=4;
   sgResult.ColWidths[0]:= 30;
   sgResult.Cells[0,0]:= '序号';
   sgResult.Cells[1,0]:= '钻孔号';
   sgResult.ColWidths[1]:= 120;
      sgResult.Cells[2,0]:= '坐标X';
   sgResult.ColWidths[2]:= 100;
      sgResult.Cells[3,0]:= '坐标Y';
   sgResult.ColWidths[3]:= 100;
end;

procedure TDrillsXYForm.btnCancelClick(Sender: TObject);
begin
  Close;
end;

end.
