uses konrad,crt,_32bit,_13h;
const
zoom=50;
dist:integer=250;
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
    '+':dec(dist);
    '-':inc(dist);
   end;
  end;
End;

Procedure Init;
Begin
 Init13h;
 move(cwuerfel,wuerfel,sizeof(cwuerfel));
 with punkt do
 Begin
  x:=50;
  y:=70;
  z:=100;
 End;
End;

Procedure RotateX(var src:TPos3d;wx:real);
var nx,ny,nz:real;
Begin
 wx:=wx*pi/180;{Grad->Bogenmaá}
 with src do
 begin
  nx:=x*cos(wx)-y*sin(wx);
  ny:=x*sin(wx)+y*cos(wx);
  x:=nx;
  y:=ny;
 end;
End;

Procedure ShowP;
var mx,my:array[1..8] of integer;
    help:real;

Begin
 for t:=1 to 8 do
 with wuerfel[t] do
 begin
  help:=(z+dist)/zoom;
  if help=0 then help:=0.0001;
  mx[t]:=trunc((x)/help)+160;
  my[t]:=trunc((y)/help)+100;
 end;
 for t:=1 to 8 do screen[my[t],mx[t]]:=15;

 for t:=1 to 3 do line(seg(screen),mx[t],my[t],mx[t+1],my[t+1],15);
 for t:=5 to 7 do line(seg(screen),mx[t],my[t],mx[t+1],my[t+1],15);
 line(seg(screen),mx[4],my[4],mx[1],my[1],15);
 line(seg(screen),mx[5],my[5],mx[8],my[8],15);
 for t:=1 to 4 do line(seg(screen),mx[t],my[t],mx[t+4],my[t+4],15);


End;

begin
 Init;
 repeat
  for t:=1 to 8 do rotateX(wuerfel[t],1);
  Keys;
  waitretrace;
  filllongint(screen,16000,0);
  ShowP;
 until taste=#27;
end.