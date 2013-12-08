unit _3d;
interface
const cmul=20;
      screenmid_x=160;
      screenmid_y=100;
type  TPos3d=record
             x,y,z:single;
            end;
      TPos = record
             x,y:integer;
            end;
      TLine3d=array[1..2] of TPos3d;
      TTable=array[0..360*cmul] of single;
var   tcos,tsin:^TTable;
Procedure RotateZ(var src:TPos3d;wz:single);
Procedure RotateY(var src:TPos3d;wy:single);
Procedure RotateX(var src:TPos3d;wx:single);
Procedure InitTables;
Procedure MakeVis(var src:array of tpos3d;var dest:array of tpos;anz:word;dist,zoom:integer);
Procedure RotateA(var src:array of TPos3d;anz:word;wx,wy,wz:single);
Procedure RotateA_Fast(var src:array of TPos3d;anz:word;wx,wy,wz:single);
implementation

Procedure RotateA(var src:array of TPos3d;anz:word;wx,wy,wz:single);
{Rotiert src um wx/wy/wz Winkelgrade }
var nx,ny,nz:single;
    cos_wx,sin_wx,cos_wy,sin_wy,cos_wz,sin_wz:single;
    t:word;
Begin
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

{genausoschnell wie RotateA}
Procedure RotateA_Fast(var src:array of TPos3d;anz:word;wx,wy,wz:single);
{Rotiert src um wx/wy/wz Winkelgrade }
var nx,ny,nz:single;
    cos_wx,sin_wx,cos_wy,sin_wy,cos_wz,sin_wz:single;
    t:word;
    p:^tpos3d;
Begin
 cos_wx:=cos(wx*pi/180);sin_wx:=sin(wx*pi/180);
 cos_wy:=cos(wy*pi/180);sin_wy:=sin(wy*pi/180);
 cos_wz:=cos(wz*pi/180);sin_wz:=sin(wz*pi/180);
 p:=@src;
{-Rotation----------------}
 for t:=0 to anz-1 do with p^ do
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
  inc(p);
 end;
End;


Procedure InitTables;
var t:word;

Begin
 getmem(tsin,sizeof(ttable));
 getmem(tcos,sizeof(ttable));
 for t:=0 to 360*cmul do
 begin
  tsin^[t]:=sin((t/cmul)*pi/180);
  tcos^[t]:=cos((t/cmul)*pi/180);
 end;
End;

Procedure RotateZ(var src:TPos3d;wz:single);
var nx,ny,nz:single;i:integer;
Begin
 i:=trunc(wz*cmul);
 i:=i mod (360*cmul);
 if i<0 then inc(i,360*cmul);
 with src do
 begin
  nx:=x*tcos^[i]-y*tsin^[i];
  ny:=x*tsin^[i]+y*tcos^[i];
  x:=nx;
  y:=ny;
 end;
End;

Procedure RotateY(var src:TPos3d;wy:single);
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
    help:single;
Begin
 for t:=0 to anz-1 do with src[t] do
  if (z+dist)<0 then dest[t].x:=1000 else {1000 ist ungltig -> nicht angezeigt}
  begin
   help:=(z+dist)/zoom;
   if help=0 then help:=0.0001;
{$R-}
   dest[t].x:=trunc((x)/help)+screenmid_x;
   dest[t].y:=-trunc((y)/help)+screenmid_y;
{$R+}
  end;
End;

end.
