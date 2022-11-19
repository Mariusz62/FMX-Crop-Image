unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.Layouts, Unit2, FMX.Objects;

type
  TForm1 = class(TForm)
    Layout1: TLayout;
    ToolBar1: TToolBar;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Layout1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure Layout1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Single);
    procedure Layout1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Single);
  private
    { Private declarations }
  public
    Frame2: TFrame2;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Layout1.CanFocus := true;
  Frame2 := TFrame2.Create(nil);
  Layout1.AddObject( Frame2 );
  if FileExists('1.jpg') then
    Image1.Bitmap.LoadFromFile('1.jpg');
end;

procedure TForm1.Layout1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Single);
var
  U: TPointF;
begin
  if ssLeft in Shift then
  begin
    U := TPointF.Create(X,Y);
    U := Layout1.LocalToAbsolute( U );

    U := Frame2.AbsoluteToLocal( U );
    Frame2.ToDown(U);

    if Frame2.State > TLineState.lsNone then
      Layout1.Repaint;
  end;
end;

procedure TForm1.Layout1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
var
  U: TPointF;
begin
  if not (ssLeft in Shift) then Exit;
  U := TPointF.Create(X, Y);
  U := Layout1.LocalToAbsolute( U );
  U := Frame2.AbsoluteToLocal( U );

  Frame2.ToMove(U);

  if Frame2.State > TLineState.lsNone then
    Layout1.Repaint;
end;

procedure TForm1.Layout1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Single);
var
  U: TPointF;
begin
  //if not (ssLeft in Shift) then Exit;
  U := TPointF.Create(X, Y);
  U := Layout1.LocalToAbsolute( U );
  U := Frame2.AbsoluteToLocal( U );
  Frame2.ToUp(U);
end;

end.
