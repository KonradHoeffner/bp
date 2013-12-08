{PII empfohlen, sonst anz runterstellen oder in Z.193-95 einzelne Rotationen ausklammern}
uses konrad,crt,_32bit,_13h,_3d,frame;
const
zoom=256;
dist:integer=0;
cs=10;
speed=30;
anz=2048;
maxx=320*2;
maxy=320*2;
start_z=2000;
min_z=70;
cmul=20;
cwuerfel:array[0..8*3-1] of single=(
-100,-100,-100,
100,-100,-100,
100,100,-100,
-100,100,-100,
-100,-100,100,
100,-100,100,
100,100,100,
-100,100,100
);
b:byte=0;
type
    TTable=array[0..360*cmul] of single;
var stars,stars2:array[1..anz] of TPos3d;
    wuerfel:array[1..8] of TPos3d;
    screen1:^TScreen;
    t,w1,w2,w3:word;
    tcos,tsin:^TTable;
    s:string;
Procedure Keys;
Begin
  if keypressed then
  begin
   taste:=readkey;
{   with punkt do case taste of
    TLeft:dec(x,cs);
    TRight:inc(x,cs);
    TUp:dec(y,cs);
    TDown:inc(y,cs);
    '+':dec(dist);
    '-':inc(dist);
   end;}
  end;
End;

Procedure InitStar(nr:word);
Begin
 stars[nr].z:={(start_z shr 1)+random(start_z shr 1)}start_z+random(start_z);
 stars[nr].x:=-random*maxx*2+maxx;
 stars[nr].y:=random*maxy*2-maxy;
End;

Procedure Init1;
var t:word;
Procedure InitTables;
var t:word;
Begin
 getmem(tsin,sizeof(ttable));
 getmem(tcos,sizeof(ttable));
 for t:=1 to 360*cmul do
 begin
  tsin^[t]:=sin((t/cmul)*pi/180);
  tcos^[t]:=cos((t/cmul)*pi/180);
 end;
End;
Begin
 Inittables;
 move(cwuerfel,wuerfel,sizeof(cwuerfel));
 Maus_Init;
 SetMaus(320,100);
 Randomize;
 Init13h;
 For t:=1 to 63 do setmypalette(t,t,t,t);
 For t:=64 to 128 do setmypalette(t,0,t,128-t);
 Getmem(Screen1,64000);
 for t:=1 to anz do with stars[t] do
 begin
  z:=(start_z shr 1)+random*start_z/2;
  stars[t].x:=-random*maxx*2+maxx;
  stars[t].y:=random*maxy*2-maxy;
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

Procedure ShowP(var dest:TScreen);
var mx,my:array[1..anz] of longint;
    help,single1:single;
    t:word;
    farbe:byte;
    s:string;
Begin
 for t:=1 to anz do
  with stars2[t] do
 begin
  help:=(z+dist);
  help:=(z+dist)/zoom;
  if help=0 then help:=0.0001;
  mx[t]:=trunc((x)/help)+160;
  my[t]:=-trunc((y)/help)+100;
 end;
for t:=1 to anz do
if (((mx[t]>0) and (mx[t]<319)) and ((my[t]>0) and (my[t]<199))) then
 begin
  if stars2[t].z<start_z then
  begin
   single1:=63-(63*stars2[t].z/start_z);
   farbe:=round(single1);
   dest[my[t],mx[t]]:=farbe;
  end;
 end;{ else InitStar(t);}
{  str(farbe,s);
  outtextxy2(10,0,s,63,dest);}
End;

Procedure ShowWuerf(var src:TScreen);
var mx,my:array[1..8] of integer;
    help:single;
    t:word;
    col:byte;
Begin
 inc(w2);
 col:=64+32+trunc(sin(w2*pi/180)*31);
 for t:=1 to 8 do
 with wuerfel[t] do
 begin
  help:=(z+600)/zoom;
  if help=0 then help:=0.0001;
  mx[t]:=trunc((x)/help)+160;
  my[t]:=-trunc((y)/help)+100;
  dec(mx[t],30-20);
  inc(mx[t],round(sin(w2*pi/180)*60));
 end;
 for t:=1 to 8 do src[my[t],mx[t]]:=col;

 for t:=1 to 3 do line(src,mx[t],my[t],mx[t+1],my[t+1],col);
 for t:=5 to 7 do line(src,mx[t],my[t],mx[t+1],my[t+1],col);
 line(src,mx[4],my[4],mx[1],my[1],col);
 line(src,mx[5],my[5],mx[8],my[8],col);
 for t:=1 to 4 do line(src,mx[t],my[t],mx[t+4],my[t+4],col);


End;

Procedure Move;
var t:word;
Begin
 for t:=1 to anz do with stars[t] do
 if (z<min_z) then initstar(t) else
 begin
  z:=z-speed;
 end
End;

Procedure RotateZold(var src:TPos3d;wz:single);
var nx,ny,nz:single;
Begin
 wz:=wz*pi/180;{Grad->Bogenmaá}
 with src do
 begin
  nx:=x*cos(wz)-y*sin(wz);
  ny:=x*sin(wz)+y*cos(wz);
  x:=nx;
  y:=ny;
 end;
End;

Procedure RotateYold(var src:TPos3d;wy:single);
var nx,ny,nz:single;
Begin
 wy:=wy*pi/180;{Grad->Bogenmaá}
 with src do
 begin
  nx:=x*cos(wy)-z*sin(wy);
  nz:=x*sin(wy)+z*cos(wy);
  x:=nx;
  z:=nz;
 end;
End;

Procedure RotateXold(var src:TPos3d;wx:single);
var nx,ny,nz:single;
Begin
 wx:=wx*pi/180;{Grad->Bogenmaá}
 with src do
 begin
  ny:=y*cos(wx)-z*sin(wx);
  nz:=y*sin(wx)+z*cos(wx);
  y:=ny;
  z:=nz;
 end;
End;
{Procedure RotateA(var src:array of TPos3d;anz:word;wx,wy,wz:single);}
Procedure Rotateall;
var help,help2,hlpmaus:double;
    t:word;
Begin
 inc(w1);inc(w2);inc(w3);
  for t:=1 to 8 do rotateZold(wuerfel[t],5);
  for t:=1 to 8 do rotateYold(wuerfel[t],round(sin(w1/20)*5));
  for t:=1 to 8 do rotateXold(wuerfel[t],5);
  RotateA(stars2,anz,cos(w1/60)*15,sin(w1/100)*50,cos(w1/200)*360);
{ for t:=1 to anz do
 begin
  RotateY(stars2[t],sin(w1/100)*50);
  rotateX(stars2[t],cos(w1/60)*15);
  rotateZ(stars2[t],cos(w1/200)*360);
 end;}
End;
begin
  InitCount;

 Init1;
 w1:=10;
 w2:=40;
 w3:=70;
 repeat
  Keys;
  Move;
  Movelongint(stars,stars2,sizeof(stars) shr 2);
  RotateAll;
  filllongint(screen1^,16000,0);
  ShowP(screen1^);
  ShowWuerf(screen1^);
  str(act_frames,s);
  inc(fcount);
  outtextxy2(5,0,s,255,screen1^);
  waitretrace;
  MoveLongint(screen1^,screen,16000);
 until taste=#27;
 Freemem(Screen1,64000);
 Textmode(3);
 Endcount;
end.