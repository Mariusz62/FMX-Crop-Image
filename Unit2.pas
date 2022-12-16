unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Objects;

type
  TLineState = (lsNone, lsMove, lsEnd);

  TFP = Array[1..4] of TPointF;

  TFrame2 = class(TFrame)
    ShowText: TText;

    procedure FramePainting(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
  private
    FP : TFP;
    FPN: integer;
    FState: TLineState;
    function IsShow: Boolean;
    procedure UpDateText(const aT: TText);

  public
    constructor Create( AOwner: TComponent); override;
    procedure ToMove(aXY: TPointF);
    procedure ToDown(aXY: TPointF);
    procedure ToUp(aXY: TPointF);
    property State: TlineState read FState;
    property Wycin: TFP read FP;
  end;

implementation

{$R *.fmx}

constructor TFrame2.Create(AOwner: TComponent);
begin
  inherited;
  FP[1] := PointF(  100, 100 );   //  pf1------pf2
  FP[2] := PointF( 200, 100 );   //   |        |
  FP[3] := PointF( 200, 200);   //   |        |
  FP[4] := PointF( 100, 200);    //  pf4-----pf3
  FPN := 0;
  FState := TLineState.lsNone;
end;

procedure TFrame2.FramePainting(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
var
  S : TCanvasSaveState;
  i: integer;
  D1, D2, D3, D4: TPointF;
  rk: TRectF;
begin
  S := Canvas.SaveState;
  try
    Canvas.Stroke.Kind  := TBrushKind.Solid;
    Canvas.Fill.Kind    := TBrushKind.Solid;

    Canvas.Stroke.Color := TAlphaColors.Red;
    Canvas.DrawLine(FP[1], FP[2], 2);
    Canvas.DrawLine(FP[2], FP[3], 2);
    Canvas.DrawLine(FP[3], FP[4], 2);
    Canvas.DrawLine(FP[4], FP[1], 2);

    for i := 1 to 4 do
    begin
      rk := RectF(FP[i].X-5, FP[i].Y-5, FP[i].X+5, FP[i].Y+5);;
      Canvas.DrawRect(rk, 3, 3, AllCorners, 1);
    end;

    UpDateText(ShowText);

  finally
    Canvas.RestoreState(S);
  end;
end;

function TFrame2.IsShow: Boolean;
begin
  Result := true; //FPS.Distance(FPE) > 2*10;
end;

procedure TFrame2.ToMove(aXY: TPointF);
begin
  case FState of
    lsNone: ;
    lsMove:
    begin
      case FPN of
        1:begin
            FP[1] := aXY; // update End point
            FP[2].Y := aXY.Y;
            FP[4].X := aXY.X;
          end;
        2:begin
            FP[2] := aXY;
            FP[1].Y := aXY.Y;
            FP[3].X := aXY.X;
          end;
        3:begin
            FP[3] := aXY;
            FP[2].X := aXY.X;
            FP[4].Y := aXY.Y;
          end ;
        4:begin
            FP[4] := aXY;
            FP[1].X := aXY.X;
            FP[3].Y := aXY.Y;
          end ;
      end;

    end;
    lsEnd: ;
  end;
end;

procedure TFrame2.ToDown(aXY: TPointF);
var i: integer;
begin
  FPN := 0;
  case FState of
    lsNone:  // szukaj punkt
      begin
        for i:=1 to 4 do
        begin
          if aXY.Distance(FP[i]) < 25 then
          begin
            FPN := i;
            Break;
          end;
        end;
        if FPN>0 then
          FState := TLineState.lsMove;
      end;
    lsMove:
      begin
//        FPE := aXY;
//        FState := TLineState.lsEnd;
      end ;
    lsEnd: ;
  end;
end;

procedure TFrame2.ToUp(aXY: TPointF);
var i: integer;
begin
  FPN := 0;
  FState := TLineState.lsNone;
//  case FState of
//    lsNone:  // szukaj punkt
//      begin
//        for i:=1 to 4 do
//        begin
//          if aXY.Distance(FP[i]) < 15 then
//          begin
//            FPN := i;
//            Break;
//          end;
//        end;
//        if FPN>0 then
//          FState := TLineState.lsMove;
//      end;
//    lsMove:
//      begin
////        FPE := aXY;
////        FState := TLineState.lsEnd;
//      end ;
//    lsEnd: ;
//  end;
end;

procedure TFrame2.UpDateText(const aT: TText);
var s: string;
  i: integer;
begin
  s := '';
  for i := 1 to 4 do
    s := s+Format(' %d[%d1,%d1]',[i, Round(FP[i].X), Round(FP[i].Y)]);
  aT.Text := s;
end;

end.
