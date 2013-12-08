uses _32bit,crt,konrad,_3d,dos,_13h;
const zoom:integer=256;
      dist:integer=1000;
      anz=1024*5;
      wcount:word=0;
      tcount:word=0;
type TFeld=array[1..anz] of TPos3d;
var op,rp:^TFeld;
    vp:array[1..anz] of TPos;
    screen1:^tscreen;
    t:integer;
    wx,wy,wz:single;
{---Frames---}
 r:registers;
 oldint8:pointer;
 act_frames:word;
 fcount:word;
{------------}

Procedure InitPos;
Begin
 for t:=1 to anz do with op^[t] do
 begin
  x:=random*400-200;
  y:=random*400-200;
  z:=random*400-200;
 end;
End;

Procedure FrameCount;interrupt;
Begin
 intr($50,r);
 inc(tcount);
 if tcount>=18 then
 begin
  act_frames:=fcount;
  fcount:=0;
  tcount:=0;
 end;
End;

Procedure Init;
Begin
 Getmem(screen1,64000);
 getmem(op,sizeof(TFeld));
 getmem(rp,sizeof(TFeld));
 InitTables;
 Init13h;
 for t:=1 to 255 do setmypalette(t,t shr 2,t shr 2,t shr 2);
 getintvec($8,oldint8);
 setintvec($50,oldint8);
 Setintvec(8,addr(framecount));
 setmypalette(255,63,63,63);
 InitPos;
 randomize;
End;

Procedure Final;
Begin
 Freemem(screen1,64000);
 setintvec($8,oldint8);
 Textmode(3);
End;

Procedure Abfrage;
Begin
 if keypressed then
 begin
  taste:=readkey;
 end else taste:='n';
End;

Procedure MoveP;
var t:integer;
Begin
 for t:=1 to anz do with op^[t] do
 begin
 end;
End;

Procedure Show(var d:tscreen);
var t:integer;
Begin
 for t:=1 to anz do with vp[t] do
 if (x>=0) and (x<320) and (y>=0) and (y<200) then
 d[y,x]:={255}trunc(rp^[t].z*0.25)-50+205;
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

Procedure Rotate(var src:TPos3d;wx,wy,wz:single);
{Rotiert src um wx/wy/wz Winkelgrade }
var nx,ny,nz:single;ix,iy,iz:integer;
Begin
{----Arrayindizierung----}
 {x}
 ix:=trunc(wx*cmul);
 ix:=ix mod (360*cmul);
 if ix<0 then inc(ix,360*cmul);
 {y}
 iy:=trunc(wy*cmul);
 iy:=iy mod (360*cmul);
 if iy<0 then inc(iy,360*cmul);
 {z}
 iz:=trunc(wz*cmul);
 iz:=iz mod (360*cmul);
 if iz<0 then inc(iz,360*cmul);
{-Rotation----------------}
 with src do
 begin
  {x}
  ny:=y*tcos^[ix]-z*tsin^[ix];
  nz:=y*tsin^[ix]+z*tcos^[ix];
  y:=ny;
  z:=nz;
  {y}
  nx:=x*tcos^[iy]-z*tsin^[iy];
  nz:=x*tsin^[iy]+z*tcos^[iy];
  x:=nx;
  z:=nz;
  {z}
  nx:=x*tcos^[iz]-y*tsin^[iz];
  ny:=x*tsin^[iz]+y*tcos^[iz];
  x:=nx;
  y:=ny;
 end;
End;

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

Procedure RotateP;
Begin
 inc(wcount);
 movelongint(op^,rp^,sizeof(tfeld) shr 2);
 rotateA(rp^,anz,wcount,wcount,wcount);
End;

Procedure MakeVis(var src:array of tpos3d;var dest:array of tpos;anz:word;dist,zoom:integer);
var t:word;
    help:single;
Begin
 for t:=0 to anz-1 do with src[t] do
  if (z+dist)<0 then dest[t].x:=1000 else {1000 ist ungÅltig -> nicht angezeigt}
  begin
   help:=(z+dist)/zoom;
{   if help=0 then help:=0.0001;}
{---->>$R-}
   dest[t].x:=trunc((x)/help)+160;
   dest[t].y:=-trunc((y)/help)+100;
{---->>$R+}
  end;
End;

procedure showframes;
var s:string;
begin
 inc(fcount);
 str(act_frames,s);
 outtextxy2(1,1,'€€€€',0,screen);
 outtextxy2(1,1,s,255,screen1^);
End;

Procedure Main;
Begin
 repeat
  abfrage;
  moveP;
  rotateP;
  makevis(rp^,vp,anz,dist,zoom);
  show(screen1^);
  showframes;
{  waitretrace;}
  movelongint(screen1^,screen,16000);
  filllongint(screen1^,16000,0);
 until taste=#27;
End;

begin
 Init;
 Main;
 Final;
end.
