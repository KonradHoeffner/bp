uses konrad,crt,_32bit,_13h;
const
zoom=256;
dist:integer=600;
cs=10;
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
type TPos3d=record
             x,y,z:real;
            end;


var punkt:TPos3d;
    wuerfel:array[1..8] of TPos3d;
    pos:TPos;
    screen1:^tscreen;
    w:word;
Procedure Keys;
Begin
  if keypressed then
  begin
   taste:=readkey;
   with punkt do case taste of
{    TLeft:dec(x,cs);
    TRight:inc(x,cs);
    TUp:dec(y,cs);
    TDown:inc(y,cs);}
    '+':dec(dist,cs);
    '-':inc(dist,cs);
   end;
  end;
End;

Procedure Init;
Begin
 Init13h;
 Getmem(screen1,64000);
 filllongint(screen1^,16000,0);
 move(cwuerfel,wuerfel,sizeof(cwuerfel));
 with punkt do
 Begin
  x:=50;
  y:=70;
  z:=100;
 End;
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

Procedure RotateY(var src:TPos3d;wy:real);
var nx,ny,nz:real;
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

Procedure ShowWuerf(var src:TScreen;dx:real;dy:real;color:byte);
var mx,my:array[1..8] of integer;
    help:real;

Begin
 for t:=1 to 8 do
 with wuerfel[t] do
 begin
  help:=(z+dist)/zoom;
  if help=0 then help:=0.0001;
  mx[t]:=trunc((x-dx)/help)+160;
  my[t]:=-trunc((y+dy)/help)+100;
 end;
{ for t:=1 to 8 do src[my[t],mx[t]]:=15;}

 for t:=1 to 3 do line(src,mx[t],my[t],mx[t+1],my[t+1],color);
 for t:=5 to 7 do line(src,mx[t],my[t],mx[t+1],my[t+1],color);
 line(src,mx[4],my[4],mx[1],my[1],color);
 line(src,mx[5],my[5],mx[8],my[8],color);
 for t:=1 to 4 do line(src,mx[t],my[t],mx[t+4],my[t+4],color);


End;

begin
 Init;
 w:=1;
 repeat
  inc(w);
  for t:=1 to 8 do rotateZ(wuerfel[t],2.5);
  for t:=1 to 8 do rotateY(wuerfel[t],round(sin(w/20)*3));
  for t:=1 to 8 do rotateX(wuerfel[t],2);
  Keys;
  filllongint(screen1^,16000,0);
  ShowWuerf(screen1^,10,0,red);
  ShowWuerf(screen1^,10,0,blue);
  waitretrace;
  movelongint(screen1^,screen,16000);
 until taste=#27;
 Freemem(screen1,64000);
 Textmode(3);
end.