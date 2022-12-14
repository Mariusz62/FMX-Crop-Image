unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.Layouts, Unit2, FMX.Objects,  System.UIConsts, SelFile, System.Actions,
  FMX.ActnList, FMX.StdActns, FMX.MediaLibrary.Actions, MobilePermissions.Model.Signature,
  MobilePermissions.Model.Dangerous, MobilePermissions.Model.Standard, MobilePermissions.Component;

type
  TForm1 = class(TForm)
    Layout1: TLayout;
    ToolBar1: TToolBar;
    Image1: TImage;
    Image2: TImage;
    Layout2: TLayout;
    Crop: TButton;
    Panel1: TPanel;
    buSelImage: TButton;
    Label1: TLabel;
    Button1: TButton;
    ActionList1: TActionList;
    TakePhotoFromLibraryAction1: TTakePhotoFromLibraryAction;
    MobilePermissions1: TMobilePermissions;
    procedure FormCreate(Sender: TObject);
    procedure Layout1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure Layout1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Single);
    procedure Layout1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Single);
    procedure CropClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
//    procedure buSelImageClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
    procedure FormShow(Sender: TObject);
  private
    fp :TFP;
    tmpBmp: TBitmap;
    skx, sky : Single;
    procedure DajSkale;
    procedure DoDidFinish(Image: TBitmap);
  public
    Frame2: TFrame2;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.CropClick(Sender: TObject);
var fp: TFP;
  s: string;
  i: integer;
  SrcRect, DstRect : TRectF;
  sRect:TRect;
  bmp: TBitmap;
  img: TImage;
begin
  fp := Frame2.Wycin;
  s := '';
//  for i := 1 to 4 do
//    s := s+Format(' %d[%d1,%d1]',[i, Round(FP[i].X), Round(FP[i].Y)]);
//  Label1.Text := s;
  DajSkale;
  SrcRect := TRectF.Create(fp[1].X*skx, fp[1].Y*sky, fp[3].X*skx, fp[3].Y*sky);

//  s := Format('Src[ Left=%d Top=%d Width=%d Height=%d ]',
//                      [Round(SrcRect.Left), Round(SrcRect.Top),
//                       Round(SrcRect.Width), Round(SrcRect.Height)]);
//  Label1.Text := s;

  DstRect := TRectF.Create(0, 0, Image2.Bitmap.Width, Image2.Bitmap.Height);

//  s := Format('Dst[ Left=%d Top=%d Width=%d Height=%d ]',
//                      [Round(DstRect.Left), Round(DstRect.Top),
//                       Round(DstRect.Width), Round(DstRect.Height)]);
//  Label1.Text := s;

  sRect := Rect( Round(SrcRect.Left), Round(SrcRect.Top),
            Round(SrcRect.Width+SrcRect.Left), Round(SrcRect.Height+SrcRect.Top));

  bmp:= TBitmap.Create;
  bmp.SetSize( sRect.Width, sRect.Height );
  bmp.CopyFromBitmap(tmpBmp, sRect, 0, 0);
  //bmp.SaveToFile('a.png');

  Image2.Bitmap.Assign(bmp);

//  Image2.Bitmap.Clear(TAlphaColors.White);
//  Image2.Bitmap.Canvas.BeginScene;
//  //Image2.Bitmap.Canvas.DrawBitmap(Image1.Bitmap, SrcRect, DstRect, 1);
//  //Image2.Bitmap.Canvas.DrawBitmap(tmpBmp, SrcRect, DstRect, 1);
//  sRect := Rect( Round(SrcRect.Left), Round(SrcRect.Top), Round(SrcRect.Width), Round(SrcRect.Height));
//  Image2.Bitmap.CopyFromBitmap(tmpBmp, sRect, 0, 0);//  Canvas.DrawBitmap(tmpBmp, SrcRect, DstRect, 1);
//
//  Image2.Bitmap.Canvas.EndScene;

//  s := Format('Image2[ Position.X=%d Position.Y=%d Width=%d Height=%d ]',
//                      [Round(Image2.Position.X), Round(Image2.Position.Y),
//                       Round(Image2.Width), Round(Image2.Height)]);
//  Label3.Text := s;
//
//  s := Format('Image2.bitmap[ Width=%d Height=%d ]',
//                      [Round(Image2.Bitmap.Width), Round(Image2.Bitmap.Height)
//                       ]);
//  Label4.Text := s;
end;

procedure TForm1.DajSkale;
begin
  skx := tmpBmp.Width / Image1.Width ;
  sky := tmpBmp.Height / Image1.Height;
end;

procedure TForm1.DoDidFinish(Image: TBitmap);
begin
  tmpBmp.Assign( Image );
  Image1.Bitmap.Assign(Image);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tmpBmp.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Layout1.CanFocus := true;
  Frame2 := TFrame2.Create(nil);
  Layout1.AddObject( Frame2 );
  tmpBmp := TBitmap.Create;

  MobilePermissions1.Dangerous.ReadExternalStorage:=true;
  MobilePermissions1.Apply;
  Image2.Bitmap.SetSize(Round(Image2.Width), Round(Image2.Height));

  if not FileExists('2.png') then Exit;

  Image1.Bitmap.LoadFromFile('2.png');

  tmpBmp.LoadFromFile('2.png');
  DajSkale;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  MobilePermissions1.Dangerous.ReadExternalStorage:=true;
  MobilePermissions1.Apply;
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
  U, p1, p2: TPointF;
  SrcRect, DstRect: TRectF;
  sr : TRect;
  Bmp: TBitmap;
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

procedure TForm1.TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
begin
  DoDidFinish(Image);
end;

end.
