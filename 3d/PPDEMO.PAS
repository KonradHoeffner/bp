{PII empfohlen}
uses konrad,crt,_32bit,_13h;
const
zoom=256;
dist:integer=0;
cs=10;
speed=30;
anz=1024;
maxx=320*2;
maxy=320*2;
start_z=2000;
min_z=70;
cwuerfel:array[0..8*3-1] of real=(
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
type TPos3d=record
             x,y,z:real;
            end;
var stars,stars2:array[1..anz] of TPos3d;
    wuerfel:array[1..8] of TPos3d;
    screen1:^TScreen;
    t,w1,w2,w3:word;
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
Begin
 SinCosInit;
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

Procedure RotateZ(var src:TPos3d;wz:real);
var nx,ny,nz:real;
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

Procedure RotateY(var src:TPos3d;wy:integer);
var nx,ny,nz:real;
Begin
{ wy:=wy*pi/180;}{Grad->Bogenmaá}
{$R-}
 with src do
 begin
  nx:=x*rcos[wy]-z*rsin[wy];
  nz:=x*rsin[wy]+z*rcos[wy];
  x:=nx;
  z:=nz;
 end;
{$R}
End;

Procedure RotateX(var src:TPos3d;wx:real);
var nx,ny,nz:real;
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

Procedure ShowP(var dest:TScreen);
var mx,my:array[1..anz] of longint;
    help,real1:real;
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
if (((mx[t]>0) and (mx[t]<319)) and ((my[t]>speed) and (my[t]<199))) then
 begin
  if stars2[t].z<start_z then
  begin
   real1:=63-(63*stars2[t].z/start_z);
   farbe:=round(real1);
   dest[my[t],mx[t]]:=farbe;
  end;
 end;{ else InitStar(t);}
{  str(farbe,s);
  outtextxy2(10,0,s,63,dest);}
End;

Procedure ShowWuerf(var src:TScreen);
var mx,my:array[1..8] of integer;
    help:real;
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

 for t:=1 to 3 do line(seg(src),mx[t],my[t],mx[t+1],my[t+1],col);
 for t:=5 to 7 do line(seg(src),mx[t],my[t],mx[t+1],my[t+1],col);
 line(seg(src),mx[4],my[4],mx[1],my[1],col);
 line(seg(src),mx[5],my[5],mx[8],my[8],col);
 for t:=1 to 4 do line(seg(src),mx[t],my[t],mx[t+4],my[t+4],col);


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

Procedure Rotateall;
var help,help2,hlpmaus:double;
    t:word;
Begin
 inc(w1);inc(w2);inc(w3);
  for t:=1 to 8 do rotateZ(wuerfel[t],5);
  for t:=1 to 8 do rotateY(wuerfel[t],5);
  for t:=1 to 8 do rotateX(wuerfel[t],5);

 for t:=1 to anz do
 begin
  RotateY(stars2[t],trunc(sin(w1/100)*50));
{  rotateX(stars2[t],cos(w1/60)*10);
  rotateZ(stars2[t],cos(w1/200)*360);}
 end;
End;
begin
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
  waitretrace;
  MoveLongint(screen1^,screen,16000);
 until taste=#27;
 Freemem(Screen1,64000);
 Textmode(3);
end.