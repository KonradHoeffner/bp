{ƒƒUnit 3Dƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
 Unit fÅr 3D-Darstellung und Sinus/Kosinustabellen
 Konrad Hîffner 1999/2000
{ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ}
unit _3d;
interface
const
 cmul=20;
 {Genauigkeit der Sinus-/Kosinustabellen, sie enthalten je 360*cmul Elemente}
 screenmid_x=160; {Bildschirmmitte im VGA-Modus 13h}
 screenmid_y=100;
type
 TPos3d=record {Typ fÅr 3-dimensionale Flie·kommakoordinatenangaben}
         x,y,z:single;
        end;
 TPos = record {Typ fÅr 2-dimensionale Integerkoordinatenangaben}
         x,y:integer;
        end;
 TLine3d=array[1..2] of TPos3d;
 {eine Linie kann durch 2 Punkte dargestellt werden}
 TTable=array[0..360*cmul] of single;
var   tcos,tsin:^TTable;
{ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ}
{RotateX/Y/Z rotiert einen Punkt vom Typ TPos3d um die Achse X/Y/Z}
Procedure RotateZ(var src:TPos3d;wz:single);
Procedure RotateY(var src:TPos3d;wy:single);
Procedure RotateX(var src:TPos3d;wx:single);
Procedure InitTables;{Initialisiert die Sinus- und Kosinustabellen}
{Ini}
Procedure MakeVis(var src:array of tpos3d;var dest:array of tpos;anz:word;dist,zoom:integer);
{Projeziert die 3D-Koordinaten eines Arrays auf ein 2D-Koordinatensystem}
Procedure RotateA(var src:array of TPos3d;anz:word;wx,wy,wz:single);
{Rotiert anz Elemente von src um wx/wy/wz Winkelgrade }

{ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ}
implementation

Procedure RotateA(var src:array of TPos3d;anz:word;wx,wy,wz:single);
{Rotiert src um wx/wy/wz Winkelgrade }
var nx,ny,nz:single;{Zwischenspeicher fÅr wx/wy/wz}
    cos_wx,sin_wx,cos_wy,sin_wy,cos_wz,sin_wz:single;
    t:word;
Begin
{-Werte vorberechnen------}
 cos_wx:=cos(wx*pi/180);sin_wx:=sin(wx*pi/180);
 cos_wy:=cos(wy*pi/180);sin_wy:=sin(wy*pi/180);
 cos_wz:=cos(wz*pi/180);sin_wz:=sin(wz*pi/180);
{-Rotation----------------}
 for t:=0 to anz-1 do with src[t] do
 begin
  {x}
  ny:=y*cos_wx-z*sin_wx;
  z:=y*sin_wx+z*cos_wx;
  y:=ny;
  {y}
  nx:=x*cos_wy-z*sin_wy;
  z:=x*sin_wy+z*cos_wy;
  x:=nx;
  {z}
  nx:=x*cos_wz-y*sin_wz;
  y:=x*sin_wz+y*cos_wz;
  x:=nx;
 end;
End;

Procedure InitTables;
var t:word;
Begin

 getmem(tsin,(360+91)*sizeof(single)*cmul);{Speicher reservieren fÅr sin+cos}
 tcos:=@tsin^[89*cmul];inc(tcos);{da sin(x)=cos(x-90)}
 for t:=0 to 360*cmul do {Werte berechnen}
 begin
  tsin^[t]:=sin((t/cmul)*pi/180);{Umwandlung Grad->Bogenma·: alpha*pi/180...}
  tcos^[t]:=cos((t/cmul)*pi/180);{... da Pascal-Funktionen Bogenma· erwarten}
 end;
End;

Procedure RotateZ(var src:TPos3d;wz:single);
{Rotiert einen Punkt um die Z-Achse }
var nx,ny,nz:single;i:integer;
Begin
 {----Index fÅr Winkelfunktionstabellen errechnen----}
 i:=trunc(wz*cmul);
 i:=i mod (360*cmul);
 if i<0 then inc(i,360*cmul);
 {---------------------------------------------------}
 with src do
 begin
  nx:=x*tcos^[i]-y*tsin^[i];
  ny:=x*tsin^[i]+y*tcos^[i];
  x:=nx;
  y:=ny;
 end;
End;

Procedure RotateY(var src:TPos3d;wy:single);
{s. RotateZ, Rotation um Y-Achse}
var nx,ny,nz:single;i:integer;
Begin
 i:=trunc(wy*cmul);
 i:=i mod (360*cmul);
 if i<0 then inc(i,360*cmul);
 with src do
 begin
  nx:=x*tcos^[i]-z*tsin^[i];
  nz:=x*tsin^[i]+z*tcos^[i];
  x:=nx;
  z:=nz;
 end;
End;

Procedure RotateX(var src:TPos3d;wx:single);
{s. RotateZ, Rotation um X-Achse}
var nx,ny,nz:single;i:integer;
Begin
{ wx:=wx-trunc(wx/360)*360;}
 i:=trunc(wx*cmul);
 i:=i mod (360*cmul);
 if i<0 then inc(i,360*cmul);

 with src do
 begin
  ny:=y*tcos^[i]-z*tsin^[i];
  nz:=y*tsin^[i]+z*tcos^[i];
  y:=ny;
  z:=nz;
 end;
End;

Procedure MakeVis(var src:array of tpos3d;var dest:array of tpos;anz:word;dist,zoom:integer);
var t:word;
    help:single; {Hilfsvariable}
Begin
{Grundlage:
3D-Punkt:
    Y  Z
    ≥/
 ƒƒƒ≥ƒƒƒ X
    ≥

Projektion:
Je weiter der Punkt entfernt ist, desto nÑher ist er an der Bildschirmmitte.
-> x(bzw. y)=x(bzw. y)*zoomfaktor/(z+distanz)
Die Distanz entspricht der Entfernung eines Objektes vom Koordinatenursprung (0,0,0)
Um diesen wird rotiert.
}
 for t:=0 to anz-1 do with src[t] do
  if (z+dist)<0 then dest[t].x:=1000 else {1000 ist ungÅltig -> nicht angezeigt}
  begin
   help:=(z+dist)/zoom; {Berechnung des Projektionsfaktors
   fÅr x/y aus der Entfernung }
   if help=0 then help:=0.0001;{Division durch 0 verhindern}
{$R-}
   dest[t].x:=trunc((x)/help)+screenmid_x;{s. Grundlagen}
   dest[t].y:=-trunc((y)/help)+screenmid_y;
   {umgekehrt, da auf y auf dem Bildschirm nach unten hin zunimmt}
{$R+}
  end;
End;

end.
