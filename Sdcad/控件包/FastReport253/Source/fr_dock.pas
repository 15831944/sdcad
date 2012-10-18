
{******************************************}
{                                          }
{             FastReport v2.53             }
{              Tool controls               }
{                                          }
{Copyright(c) 1998-2004 by FastReports Inc.}
{                                          }
{******************************************}

unit FR_Dock;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, FR_Ctrls;

type
  TfrOrientation = (toAny, toVertOnly, toHorzOnly);

  TfrFloatWindow = class;

  TfrDock = class(TPanel)
  private
    FRowSize: Integer;
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AdjustBounds;
    procedure Paint; override;
  published
    property RowSize: Integer read FRowSize write FRowSize default 26;
  end;

  TfrDragBox = class(TGraphicControl)
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
  end;

  TfrToolBar = class(TPanel)
  private
    FDragBox: TfrDragBox;
    FWindow: TfrFloatWindow;
    FIsFloat: Boolean;
    FDown: Boolean;
    FLastX, FLastY: Integer;
    FOrientation: TfrOrientation;
    FCanFloat: Boolean;
    function ParentAlign: TAlign;
    function FindDock(AOwner: TWinControl; p: TPoint): Boolean;
    procedure MakeFloat;
    function MoveTo(X, Y: Integer): Boolean;
    function GetVisible: Boolean;
    procedure SetVisible(Value: Boolean);
    procedure DockTo(Dock: TfrDock; X, Y: Integer);
    procedure FloatTo(X,Y: Integer);
    procedure DoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DoMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DoResize(Sender: TObject);
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    function GetFloatWindow: TForm;
  protected
    procedure Loaded; override;
    procedure RealignControls;
    function GetClientRect: TRect; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure AdjustBounds;
    procedure AddToDock(Dock: TfrDock);
    property IsFloat: Boolean read FIsFloat;
    property FloatWindow: TForm read GetFloatWindow;
    property IsVisible: Boolean read GetVisible write SetVisible;
  published
    property CanFloat: Boolean read FCanFloat write FCanFloat default True;
    property Orientation: TfrOrientation read FOrientation write FOrientation;
  end;

  TfrTBSeparator = class(TGraphicControl)
  protected
    FDrawBevel: Boolean;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetDrawBevel(Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
  published
    property Align;
    property DrawBevel: Boolean read FDrawBevel write SetDrawBevel default True;
    property Height;
    property Width;
  end;

  TfrTBPanel = class(TPanel)
  protected
    procedure SetParent(AParent:TWinControl); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
  end;

  TfrTBButton = class(TfrSpeedButton)
  protected
    procedure SetParent(AParent:TWinControl); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Flat default True;
  end;

  TfrFloatWindow = class(TForm)
    procedure FormDestroy(Sender: TObject);
  private
    FRect: TRect;
    FDown: Boolean;
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    ToolBar: TfrToolBar;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Capture;
  end;

var
  RegRootKey: String;

const
  rsToolBar             = 'ToolBar\';
  rsForm                = 'Form\';
  rsWidth               = 'Width';
  rsHeight              = 'Height';
  rsTop                 = 'Top';
  rsLeft                = 'Left';
  rsFloat               = 'isFloat';
  rsVisible             = 'isVisible';
  rsX                   = 'XPosition';
  rsY                   = 'YPosition';
  rsDockName            = 'DockName';
  rsMaximized           = 'Maximized';

procedure SaveToolbarPosition(t: TfrToolBar);
procedure RestoreToolbarPosition(t: TfrToolBar);
procedure SaveFormPosition(f: TForm);
procedure RestoreFormPosition(f: TForm);


implementation

{$R *.DFM}

uses Registry;

var
  FloatingToolBars: TList;


procedure AddToToolbarList(t: TfrToolBar);
begin
  if FloatingToolbars.IndexOf(t) <> -1 then
    FloatingToolbars.Add(t);
end;

procedure RemoveFromToolbarList(t: TfrToolBar);
var
  i: Integer;
begin
  i := FloatingToolbars.IndexOf(t);
  if i <> -1 then
    FloatingToolbars.Delete(i);
end;

procedure DestroyToolbarList;
var
  i: Integer;
begin
  for i := 0 to FloatingToolBars.Count-1 do
    TfrToolBar(FloatingToolBars[i]).Free;
end;


procedure SaveToolbarPosition(t: TfrToolBar);
var
  Ini: TRegIniFile;
  X, Y: integer;
  Name: String;
begin
  Ini := TRegIniFile.Create(RegRootKey);
  Name := rsToolbar + t.Name;
  Ini.WriteBool(Name, rsFloat, t.isFloat);
  Ini.WriteBool(Name, rsVisible, t.IsVisible);
  X := t.Left; Y := t.Top;
  if t.IsFloat then
  begin
    X := t.FloatWindow.Left; Y := t.FloatWindow.Top;
  end;
  Ini.WriteInteger(Name, rsX, X);
  Ini.WriteInteger(Name, rsY, Y);
  Ini.WriteInteger(Name, rsWidth, t.Width);
  Ini.WriteInteger(Name, rsHeight, t.Height);
  if t.Parent is TfrDock then
    Ini.WriteString(Name, rsDockName, t.Parent.Name);
  Ini.Free;
end;

procedure RestoreToolbarPosition(t: TfrToolBar);
var
  Ini: TRegIniFile;
  X, Y: Integer;
  DN: string;
  NewDock: TfrDock;
  Name: String;
begin
  Ini := TRegIniFile.Create(RegRootKey);
  Name := rsToolbar + t.Name;
  t.IsVisible := False;
  X := Ini.ReadInteger(Name, rsX, t.Left);
  Y := Ini.ReadInteger(Name, rsY, t.Top);
  t.Width := Ini.ReadInteger(Name, rsWidth, t.Width);
  t.Height := Ini.ReadInteger(Name, rsHeight, t.Height);
  if Ini.ReadBool(Name, rsFloat, False) then
    t.FloatTo(X, Y)
  else
  begin
    t.Left := X;
    t.Top := Y;
    DN := Ini.ReadString(Name, rsDockName, t.Parent.Name);
    if (t.Owner <> nil) then
    begin
      NewDock := t.Owner.FindComponent(DN) as TfrDock;
      if (NewDock <> nil) and (NewDock <> t.Parent) then
        t.DockTo(NewDock, X, Y);
    end;
    t.AdjustBounds;
  end;
  t.IsVisible := Ini.ReadBool(Name, rsVisible, True);
  Ini.Free;
end;

procedure SaveFormPosition(f: TForm);
var
  Ini: TRegIniFile;
  Name: String;
begin
  Ini := TRegIniFile.Create(RegRootKey);
  Name := rsForm + f.ClassName;
  Ini.WriteInteger(Name, rsX, f.Left);
  Ini.WriteInteger(Name, rsY, f.Top);
  Ini.WriteInteger(Name, rsWidth, f.Width);
  Ini.WriteInteger(Name, rsHeight, f.Height);
  Ini.WriteBool(Name, rsMaximized, f.WindowState = wsMaximized);
  Ini.Free;
end;

procedure RestoreFormPosition(f: TForm);
var
  Ini: TRegIniFile;
  Name: String;
  Maximized: Boolean;
begin
  Ini := TRegIniFile.Create(RegRootKey);
  Name := rsForm + f.ClassName;
  Maximized := Ini.ReadBool(Name, rsMaximized, True);
  if not Maximized then
    f.WindowState := wsNormal;
  f.SetBounds(Ini.ReadInteger(Name, rsX, f.Left),
              Ini.ReadInteger(Name, rsY, f.Top),
              Ini.ReadInteger(Name, rsWidth, f.Width),
              Ini.ReadInteger(Name, rsHeight, f.Height));
  Ini.Free;
end;


{--------------------------------------------------------------------------}
constructor TfrDock.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RowSize := 26;
end;

procedure TfrDock.Loaded;
begin
  inherited Loaded;
  AdjustBounds;
end;

procedure TfrDock.AdjustBounds;
var
  i, Line, LineCount, l, dl: Integer;
  CtlOnLine, NewSize: Integer;
  c: TControl;
  ShiftNeeded: Boolean;
begin
  if ControlCount = 0 then
  begin
    if Align in [alTop, alBottom] then
      Height := 1 else
      Width := 1;
    Exit;
  end;
  if Align in [alTop, alBottom] then
    L := Height else
    L := Width;
  LineCount := L div RowSize;
  NewSize := RowSize * LineCount + 1;
  L := 0;
  dL := RowSize;
  if Align in [alRight, alBottom] then
  begin
    dL := -RowSize;
    if Align = alRight then
      L := Width else
      L := Height;
  end;
  Line := 0;
  while Line < LineCount do
  begin
    CtlOnLine := 0;
    for i := 0 to ControlCount-1 do
    begin
      c := Controls[i];
      if c.Visible then
      case Align of
        alLeft:
          if (c.Left = L) or
            ((c.Left < L) and (c.Left + c.Width > L)) then Inc(CtlOnLine);
        alRight:
          if (c.Left + c.Width = L) or
            ((c.Left + c.Width > L) and (c.Left < L)) then Inc(CtlOnLine);
        alTop:
          if (c.Top = L) or
            ((c.Top < L) and (c.Top + c.Height > L)) then Inc(CtlOnLine);
        alBottom:
          if (c.Top + c.Height = L) or
            ((c.Top + c.Height > L) and (c.Top < L)) then Inc(CtlOnLine);
      end;
    end;
    if CtlOnLine = 0 then
    begin
      for i := 0 to ControlCount-1 do
      begin
        c := Controls[i];
        if c.Visible then
        begin
          if ((Align = alLeft) and (c.Left > L)) or
             ((Align = alRight) and (c.Left + c.Width > L)) then
            c.Left := c.Left - RowSize;
          if ((Align = alTop) and (c.Top > L)) or
             ((Align = alBottom) and (c.Top + c.Height > L)) then
            c.Top := c.Top - RowSize;
        end;
      end;
      Dec(NewSize, RowSize);
      Dec(LineCount);
      Dec(Line);
      if Align in [alTop, alLeft] then Dec(L, dL);
    end;
    Inc(Line);
    Inc(L, dL);
  end;

  ShiftNeeded := False;
  for i := 0 to ControlCount-1 do
  begin
    c := Controls[i];
    if c.Visible then
    begin
      if (Align = alRight) and (c.Left < 0) then
      begin
        ShiftNeeded := True;
        L := -c.Left + 1;
        Inc(NewSize, L);
        break;
      end;
      if (Align = alBottom) and (c.Top < 0) then
      begin
        ShiftNeeded := True;
        L := -c.Top + 1;
        Inc(NewSize, L);
        break;
      end;
      if (Align = alTop) and (c.Top + c.Height > NewSize) then
      begin
        NewSize := c.Top + c.Height + 1;
        break;
      end;
      if (Align = alLeft) and (c.Left + c.Width > NewSize) then
      begin
        NewSize := c.Left + c.Width + 1;
        break;
      end;
    end;
  end;
  if ShiftNeeded then
    for i := 0 to ControlCount - 1 do
    begin
      c := Controls[i];
      if c.Visible then
        if Align = alRight then
          c.Left := c.Left + L
        else if Align = alBottom then
          c.Top := c.Top + L;
    end;

  for i := 0 to ControlCount - 1 do
  begin
    c := Controls[i];
    if c.Visible then
    begin
      if (Align = alRight) and (c.Left + c.Width > NewSize) then
        NewSize := c.Left + c.Width;
      if (Align = alBottom) and (c.Top + c.Height > NewSize) then
        NewSize := c.Top + c.Height;
    end;
  end;

  case Align of
    alTop: Height := NewSize;
    alLeft: Width := NewSize;
    alBottom:
      if Height < NewSize then
        SetBounds(0, Top - (NewSize - Height), Width, NewSize)
      else
        Height := NewSize;
    alRight:
      if Width < NewSize then
        SetBounds(Left - (NewSize - Width), Top, NewSize, Height)
      else
        Width := NewSize;
  end;
end;

procedure TfrDock.Paint;
var
  R: TRect;
begin
  with Canvas do
  begin
    Brush.Color := clBtnFace;
    R := Rect(0, 0, Width, Height);
    FillRect(R);
    if csDesigning in ComponentState then
    begin
      Pen.Color := clBtnShadow;
      Rectangle(0, 0, Width, Height);
    end;
  end;
end;


{--------------------------------------------------------------------------}
constructor TfrDragBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 11;
  Height := 11;
end;

procedure TfrDragBox.Paint;
var
  R: TRect;
begin
  with Canvas do
  begin
    Brush.Color := clBtnFace;
    R := Rect(0, 0, Width, Height);
    FillRect(R);
  end;
  if (Parent as TfrToolBar).ParentAlign = alTop then
  begin
    R := Rect(2, 0, 5, Height);
    Frame3D(Canvas, R, clBtnHighlight, clBtnShadow, 1);
    R := Rect(5, 0, 8, Height);
    Frame3D(Canvas, R, clBtnHighlight, clBtnShadow, 1);
  end
  else if (Parent as TfrToolBar).ParentAlign = alLeft then
  begin
    R := Rect(0, 2, Width, 5);
    Frame3D(Canvas, R, clBtnHighlight, clBtnShadow, 1);
    R := Rect(0, 5, Width, 8);
    Frame3D(Canvas, R, clBtnHighlight, clBtnShadow, 1);
  end;
end;

procedure TfrDragBox.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  p: TPoint;
begin
  p := ClientToScreen(Point(X, Y));
  p := Parent.ScreenToClient(p);
  (Parent as TfrToolBar).DoMouseDown(Self, Button, Shift, P.X, P.Y);
end;

procedure TfrDragBox.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  p: TPoint;
begin
  p := ClientToScreen(Point(X, Y));
  p := Parent.ScreenToClient(p);
  (Parent as TfrToolBar).DoMouseMove(Self, Shift, P.X, P.Y);
end;

procedure TfrDragBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  p: TPoint;
begin
  p := ClientToScreen(Point(X, Y));
  p := Parent.ScreenToClient(p);
  (Parent as TfrToolBar).DoMouseUp(Self, Button, Shift, P.X, P.Y);
end;


{--------------------------------------------------------------------------}
constructor TfrToolBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Height := 26;
  FDragBox := TfrDragBox.Create(Self);
  FDragBox.Parent := Self;
  FDragBox.Align := alLeft;
  FullRepaint := False;
  OnMouseDown := DoMouseDown;
  OnMouseMove := DoMouseMove;
  OnMouseUp := DoMouseUp;
  OnResize := DoResize;
  FCanFloat := True;
  FOrientation := toAny;
end;

destructor TfrToolBar.Destroy;
begin
  FDragBox.Free;
  if FWindow <> nil then
  begin
    Parent := nil;
    FWindow.Hide;
    FWindow.Free;
  end;
  inherited Destroy;
end;

procedure TfrToolBar.Loaded;
begin
  inherited Loaded;
  AdjustBounds;
end;

procedure TfrToolBar.Paint;
var
  R: TRect;
begin
  with Canvas do
  begin
    Brush.Color := clBtnFace;
    R := Rect(0, 0, Width, Height);
    FillRect(R);
    if not IsFloat then
      Frame3D(Canvas, R, clBtnHighlight, clBtnShadow, 1);
  end;
end;

function TfrToolBar.ParentAlign: TAlign;
begin
  Result := Parent.Align;
  if Result = alBottom then Result := alTop;
  if Result = alRight then Result := alLeft;
end;

function TfrToolBar.GetClientRect: TRect;
begin
  Result := inherited GetClientRect;
  InflateRect(Result, -1, -1);
end;

function TfrToolBar.GetVisible: Boolean;
begin
  if IsFloat then
    Result := FWindow.Visible else
    Result := Visible;
end;

procedure TfrToolBar.SetVisible(Value: Boolean);
begin
  if IsFloat then
    FWindow.Visible := Value else
    Visible := Value;
end;

procedure TfrToolBar.DockTo(Dock: TfrDock; X, Y: Integer);
var
  oldParent: TfrDock;
begin
  Hide;
  if FWindow <> nil then
  begin
    FWindow.Hide;
    FWindow.Release;
    Parent := nil;
  end;
  FWindow := nil;
  oldParent := nil;
  if (Parent <> nil) and (Parent is TfrDock) then
    oldParent := Parent as TfrDock;
  Parent := Dock;
  if oldParent <> nil then
    oldParent.AdjustBounds;
  FIsFloat := False;
  FDragBox.Show;
  RealignControls;
  Left := X; Top := Y;
  Show;
  Dock.AdjustBounds;
  RemoveFromToolbarList(Self);
end;

procedure TfrToolBar.AddToDock(Dock: TfrDock);
var
  X,Y: Integer;
begin
  X := 0; Y := 0;
  case Dock.Align of
    alTop:
      begin
        X := 0; Y := Dock.Height - 1;
      end;
    alBottom:
      begin
        X := 0; Y := -Height + 1;
      end;
    alLeft:
      begin
        X := Dock.Width - 1; Y := 0;
      end;
    alRight:
      begin
        X := -Width + 1; Y := 0;
      end;
  end;
  DockTo(Dock, X, Y);
end;

function TfrToolBar.FindDock(AOwner: TWinControl; p: TPoint): Boolean;
var
  i: Integer;
  c: TControl;
  d: TfrDock;
begin
  Result := False;
  for i := 0 to AOwner.ControlCount-1 do
  begin
    c := AOwner.Controls[i];
    if c is TfrDock then
      if (p.X >= c.Left) and (p.X <= c.Left + c.Width) and
         (p.Y >= c.Top) and (p.Y <= c.Top + c.Height) then
      begin
        with c as TfrDock do
          if ((FOrientation = toHorzOnly) and (Align in [alLeft, alRight])) or
             ((FOrientation = toVertOnly) and (Align in [alTop, alBottom])) then
            break;
        d := c as TfrDock;
        if d.Align in [alTop,alBottom] then
        begin
          p := Point(p.X - d.Left, d.Height - 1);
          if p.X + Width > d.Width then
            p.X := d.Width - Width;
          if p.X < 0 then p.X := 0;
          if d.Align = alBottom then
            p.Y := -Height + 1;
        end
        else
        begin
          p := Point(d.Width - 1, p.Y - d.Top);
          if p.Y + Height > d.Height then
            p.Y := d.Height - Height;
          if p.Y < 0 then p.Y := 0;
          if d.Align = alRight then
            p.X := -Height + 1;
        end;
        DockTo(d, p.X, p.Y);
        SetCaptureControl(Self);
        DoMouseDown(Self, mbLeft, [], 0, 0);
        Result := True;
        break;
      end;
  end;
end;

procedure TfrToolBar.RealignControls;
var
  i, j, t: Integer;
  TempCtrl: TControl;
  Ctrls: Array[0..100] of TControl;
begin
  for i := 0 to ControlCount - 1 do
    Ctrls[i] := Controls[i];
  for i := 0 to ControlCount - 1 do
    for j := 0 to ControlCount - 2 do
      if Ctrls[j].Visible then
        if Parent.Align in [alTop, alBottom, alNone] then
        begin
          if Ctrls[j].Left > Ctrls[j + 1].Left then
          begin
            TempCtrl := Ctrls[j + 1];
            Ctrls[j + 1] := Ctrls[j];
            Ctrls[j] := TempCtrl;
          end;
        end
        else
        begin
          if (Ctrls[j].Align in [alTop, alBottom]) and
             (Ctrls[j + 1].Align in [alTop, alBottom]) and
             (Ctrls[j].Top > Ctrls[j + 1].Top) then
          begin
            TempCtrl := Ctrls[j];
            Ctrls[j] := Ctrls[j + 1];
            Ctrls[j + 1] := TempCtrl;
          end;
        end;
  case Parent.Align of
    alTop, alBottom, alNone:
    begin
      if Height > Width then
      begin
        t := Width;
        Width := Height;
        Height := t;
      end;
      for t := 0 to ControlCount - 1 do
        if (Ctrls[t] <> nil) and Ctrls[t].Visible then
          if not (Ctrls[t].Align in [alLeft, alRight]) then
            if (Ctrls[t].Align = alBottom) then
              Ctrls[t].Align := alRight
            else
            begin
              Ctrls[t].Left := Ctrls[t].Top;
              Ctrls[t].Align := alLeft;
            end;
    end;
    alLeft, alRight:
    begin
      if Width > Height then
      begin
        t := Width;
        Width := Height;
        Height := t;
      end;
      for t := 0 to ControlCount - 1 do
        if (Ctrls[t] <> nil) and Ctrls[t].Visible then
          if not (Ctrls[t].Align in [alTop, alBottom]) then
            if (Ctrls[t].Align = alRight) then
              Ctrls[t].Align := alBottom
            else
            begin
              Ctrls[t].Top := Ctrls[t].Left;
              Ctrls[t].Align := alTop;
            end;
    end;
  end;
end;

procedure TfrToolBar.AdjustBounds;
var
  i, max: Integer;
  c: TControl;
begin
  RealignControls;
  max := 0;
  for i := 0 to ControlCount - 1 do
  begin
    c := Controls[i];
    if c.Visible then
      if Parent.Align in [alTop, alBottom, alNone] then
        Inc(max, c.Width)
      else
        Inc(max, c.Height);
  end;
  if Parent.Align in [alTop, alBottom, alNone] then
    Width := max + 4 else
    Height := max + 4;
end;

procedure TfrToolBar.MakeFloat;
var
  p: TPoint;
begin
  FIsFloat := True;
  GetCursorPos(p);
  FloatTo(p.X, p.Y);
  FWindow.Capture;
end;

procedure TfrToolBar.FloatTo(X, Y: Integer);
var
  oldParent: TfrDock;
begin
  FIsFloat := True;
  if FWindow = nil then
  begin
    oldParent := nil;
    if (Parent <> nil) and (Parent is TfrDock) then
      oldParent := Parent as TfrDock;
    Hide;
    FDragBox.Hide;
    FWindow := TfrFloatWindow.Create(GetParentForm(Self));
    FWindow.BorderStyle := bsToolWindow;
    FWindow.Left := X;
    FWindow.Top := Y;
    FWindow.Caption := Caption;
    Parent := FWindow;
    RealignControls;
    if oldParent <> nil then
      oldParent.AdjustBounds;
    FWindow.ClientWidth := Width - 11;
    FWindow.ClientHeight := Height;
    FWindow.ToolBar := Self;
    Left := 0; Top := 0;
    Show;
    AddToToolbarList(Self);
  end
  else
    FWindow.SetBounds(X, Y, FWindow.Width, FWindow.Height);
end;

function TfrToolBar.MoveTo(X, Y: Integer): Boolean;
var
  i, n, oldSize, ShiftCount: Integer;
  c: TControl;
  procedure Shift(ax,ay:Integer);
  begin
    x := ax;
    y := ay;
    Inc(ShiftCount);
  end;
begin
  Result := True;
  if IsFloat then Exit;
  n := 0;
  repeat
    ShiftCount := 0;
    if ParentAlign = alTop then
    begin
      if x < -20 then FIsFloat := True;
      if x < 0 then Shift(0, y);
      if x + Width > Parent.Width then Shift(Parent.Width - Width, y);
    end
    else // if ParentAlign = alLeft then
    begin
      if y < -20 then FIsFloat := True;
      if y < 0 then Shift(x, 0);
      if y + Height > Parent.Height then Shift(x, Parent.Height - Height);
    end;
    if not IsFloat then
      for i := 0 to Parent.ControlCount-1 do
      begin
        c := Parent.Controls[i];
        if (c <> Self) and c.Visible then
          if ParentAlign = alTop then
          begin
            if ((y >= c.Top) and (y < c.Top + c.Height)) or
               ((y <= c.Top) and (y + Height > c.Top)) then
            begin
              if (x >= c.Left) and (x < c.Left + c.Width) then
                Shift(c.Left + c.Width, y);
              if (x < c.Left) and (x + Width > c.Left) then
                Shift(c.Left - Width, y);
            end;
          end
          else // if ParentAlign = alLeft then
          begin
            if ((x >= c.Left) and (x < c.Left + c.Width)) or
               ((x <= c.Left) and (x + Width > c.Left)) then
            begin
              if (y >= c.Top) and (y < c.Top + c.Height) then
                Shift(x, c.Top + c.Height);
              if (y < c.Top) and (y + Height > c.Top) then
                Shift(x, c.Top - Height);
            end;
          end;
      end;
    Inc(n);
  until (n > 3) or (ShiftCount = 0) or IsFloat;

  if not FCanFloat then FIsFloat := False;
  if IsFloat then
    MakeFloat
  else
    if n < 3 then
    begin
      if ParentAlign = alTop then
        if (y + Height > Parent.Height) or (y < 0) then
          oldSize := Parent.Height else
          oldSize := 0
      else
        if (x + Width > Parent.Width) or (x < 0) then
          oldSize := Parent.Width else
          oldSize := 0;
      Left := x;
      Top := y;
      (Parent as TfrDock).AdjustBounds;
      if FCanFloat then
        if ((ParentAlign = alTop) and (Parent.Height = oldSize)) or
           ((ParentAlign = alLeft) and (Parent.Width = oldSize)) then
          MakeFloat;
    end
    else Result := False;
end;

procedure TfrToolBar.DoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p: TPoint;
begin
  GetCursorPos(p);
  FLastX := p.X; FLastY := p.Y;
  FDown := True;
end;

procedure TfrToolBar.DoMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  p: TPoint;
  dx, dy: Integer;
  StepX, StepY: Integer;
  b: Boolean;
begin
  if IsFloat then
  begin
    Cursor := crDefault;
    FDown := False;
    Exit;
  end;
  if not FDown then Exit;
  GetCursorPos(p);
  if ParentAlign = alTop then
    StepY := (Parent as TfrDock).RowSize else
    StepY := 1;
  if ParentAlign = alLeft then
    StepX := (Parent as TfrDock).RowSize else
    StepX := 1;
  dx := (p.X - FLastX) div StepX * StepX;
  dy := (p.Y - FLastY) div StepY * StepY;
  b := False;
  if (dx <> 0) or (dy <> 0) then b := MoveTo(Left + dx, Top + dy);
  if b then
  begin
    if dx <> 0 then FLastX := p.X;
    if dy <> 0 then FLastY := p.Y;
  end;
end;

procedure TfrToolBar.DoMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDown := False;
end;

procedure TfrToolBar.DoResize(Sender: TObject);
begin
  if csDestroying in ComponentState then Exit;
  FDragBox.SetBounds(0, 0, 11, 11);
  if ParentAlign = alTop then
    FDragBox.Align := alLeft else
    FDragBox.Align := alTop;
end;

procedure TfrToolBar.WMWindowPosChanged(var Message: TWMWindowPosChanged);
begin
  if csDesigning in ComponentState then
    inherited else
    DefaultHandler(Message);
end;

function TfrToolBar.GetFloatWindow: TForm;
begin
  Result := FWindow;
end;


{ TTBSeparator }

function GetAlign(al: TAlign): TAlign;
begin
  if al in [alLeft, alRight] then
    Result := alTop else
    Result := alLeft;
end;

constructor TfrTBSeparator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Align := alLeft;
  Width := 8;
  Height := 8;
  FDrawBevel := True;
end;

procedure TfrTBSeparator.SetParent(AParent: TWinControl);
begin
  inherited;
  if not (csDestroying in ComponentState) and (AParent <> nil) and (Parent is TPanel) then
    Align := GetAlign(AParent.Parent.Align);
end;

procedure TfrTBSeparator.SetDrawBevel(Value: Boolean);
begin
  FDrawBevel := Value;
  Invalidate;
end;

procedure TfrTBSeparator.Paint;
begin
  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := clBtnFace;
    Pen.Style := psClear;
    Rectangle(0, 0, Width, Height);
    Pen.Style := psSolid;
    if FDrawBevel then
    case Align of
      alLeft, alRight:
      begin
        Pen.Color := clBtnShadow;
        MoveTo(Width div 2 - 1, 2);
        LineTo(Width div 2 - 1, Height - 2);
        Pen.Color := clBtnHighlight;
        MoveTo(Width div 2, 2);
        LineTo(Width div 2, Height - 2);
      end;
      alTop, alBottom:
      begin
        Pen.Color := clBtnShadow;
        MoveTo(2, Height div 2 - 1);
        LineTo(Width - 2, Height div 2 - 1);
        Pen.Color := clBtnHighlight;
        MoveTo(2, Height div 2);
        LineTo(Width - 2, Height div 2);
      end;
    end;
    if csDesigning in ComponentState then
    begin
      Brush.Style := bsClear;
      Pen.Style := psDot;
      Pen.Color := clBtnShadow;
      Rectangle(0, 0, Width - 1, Height - 1);
    end;
  end;
end;

constructor TfrTBPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Align := alLeft;
  Width := 8;
  Height := 8;
end;

procedure TfrTBPanel.SetParent(AParent:TWinControl);
begin
  inherited;
  if not (csDestroying in ComponentState) and (AParent <> nil) and (Parent is TPanel) then
    Align := GetAlign(AParent.Parent.Align);
end;

procedure TfrTBPanel.Paint;
begin
  with Canvas do
  begin
    Brush.Color := clBtnFace;
    FillRect(Rect(0, 0, Width, Height));
    if csDesigning in ComponentState then
    begin
      Brush.Style := bsClear;
      Pen.Style := psDot;
      Pen.Color := clBtnShadow;
      Rectangle(0, 0, Width - 1, Height - 1);
    end;
  end;
end;

{ TTBButton }

constructor TfrTBButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Align := alLeft;
  Flat := True;
end;

procedure TfrTBButton.SetParent(AParent: TWinControl);
begin
  inherited;
  if not (csDestroying in ComponentState) and (AParent <> nil) and (Parent is TPanel) then
    Align := GetAlign(AParent.Parent.Align);
end;


{ TfrFloatWindow }

procedure DrawFrameRect(R: TRect);
var
  DC: HDC;
  i: Integer;
begin
  DC := GetDC(0);
  for i := 0 to 3 do
  begin
    DrawFocusRect(DC, R);
    InflateRect(R, -1, -1);
  end;
  ReleaseDC(0, DC);
end;

procedure TfrFloatWindow.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent := TForm(Owner).Handle;
end;

procedure TfrFloatWindow.Capture;
begin
  SetCaptureControl(Self);
  MouseDown(mbLeft, [], 0, 0);
end;

procedure TfrFloatWindow.WMNCHitTest(var Msg: TWMNCHitTest);
begin
  inherited;
  if Msg.Result = htCaption then Msg.Result := htClient;
end;

procedure TfrFloatWindow.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  p: TPoint;
begin
  GetCursorPos(p);
  FRect := Rect(p.X, p.Y, p.X + Width, p.Y + Height);
  Application.ProcessMessages;
  DrawFrameRect(FRect);
  FDown := True;
end;

procedure TfrFloatWindow.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  p: TPoint;
begin
  if not FDown then Exit;
  GetCursorPos(p);
  DrawFrameRect(FRect);
  FRect := Rect(p.X, p.Y, p.X + Width, p.Y + Height);
  if ToolBar.FindDock(Owner as TWinControl,
    (Owner as TWinControl).ScreenToClient(Point(p.X, p.Y))) then
    Exit;
  DrawFrameRect(FRect);
end;

procedure TfrFloatWindow.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  DrawFrameRect(FRect);
  MoveWindow(Handle, FRect.Left, FRect.Top, Width, Height, True);
  Show;
  FDown := False;
end;

procedure TfrFloatWindow.FormDestroy(Sender: TObject);
begin
  if ToolBar <> nil then
    ToolBar.FWindow := nil;
end;


{----------------------------------------------------------------------------}
initialization
  FloatingToolBars := TList.Create;
  RegRootKey := 'Software\FastReport';

finalization
  DestroyToolbarList;
  FloatingToolBars.Free;

end.
