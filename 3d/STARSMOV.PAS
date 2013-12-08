uses konrad,crt,_32bit,_13h;
const
dorotate:boolean=true;
dorotatex:boolean=true;
dorotatey:boolean=true;
dorotatez:boolean=true;
doclearscreen:boolean=true;
zoom=256;
dist:integer=0;
cs=10;
speed=40;
anz=512*2;
maxx=320*2;
maxy=320*2;
start_z=2000;
min_z=70;
cmul=20;
type TPos3d=record
             x,y,z:real;
            end;
    TTable=array[0..360*cmul] of real;
    TStars=array[1..anz] of TPos3d;
var stars,stars2:^TStars;
    tcos,tsin:^TTable;
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
 stars^[nr].z:={(start_z shr 1)+random(start_z shr 1)}start_z+random(start_z);
 stars^[nr].x:=-random*maxx*2+maxx;
 stars^[nr].y:=random*maxy*2-maxy;
End;

Procedure Init1;
var t:word;
Procedure Inittables;
var t:word;
Begin
 getmem(stars,sizeof(tstars));
 getmem(stars2,sizeof(tstars));
 getmem(tsin,sizeof(ttable));
 getmem(tcos,sizeof(ttable));
 for t:=1 to 360*cmul do
 begin
  tsin^[t]:=sin((t/cmul)*pi/180);
  tcos^[t]:=cos((t/cmul)*pi/180);
 end;
End;
Begin
 InitTables;
 Maus_Init;
 SetMaus(320,100);
 Randomize;
 Init13h;
 For t:=1 to 63 do setmypalette(t,t,t,t);
 Getmem(Screen1,64000);
 filllongint(screen1^,16000,0);
 for t:=1 to anz do with stars^[t] do
 begin
  z:=(start_z shr 1)+random*start_z/2;
  stars^[t].x:=-random*maxx*2+maxx;
  stars^[t].y:=random*maxy*2-maxy;
 end;
End;

Procedure RotateZ(var src:TPos3d;wz:real);
var nx,ny,nz:real;i:integer;
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

Procedure RotateY(var src:TPos3d;wy:real);
var nx,ny,nz:real;i:integer;
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

Procedure RotateX(var src:TPos3d;wx:real);
var nx,ny,nz:real;i:integer;
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
    help,real1:real;
    t:word;
    farbe:byte;
    s:string;
Begin
 for t:=1 to anz do
  with stars2^[t] do
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
  if stars2^[t].z<start_z then
  begin
   real1:=63-(63*stars2^[t].z/start_z);
   farbe:=round(real1);
   dest[my[t],mx[t]]:=farbe;
  end;
 end;{ else InitStar(t);}
{  str(farbe,s);
  outtextxy2(10,0,s,63,dest);}
End;

Procedure Move;
var t:word;
Begin
 for t:=1 to anz do with stars^[t] do
 if (z<min_z) then initstar(t) else
 begin
  z:=z-speed;
 end
End;

Procedure Rotateall;
var help,help2,hlpmaus:double;
Begin
 inc(w1);inc(w2);inc(w3);
 if dorotate then
 for t:=1 to anz do
 begin
 if dorotatey then RotateY(stars2^[t],sin(w1/100)*50);
 if dorotatex then rotateX(stars2^[t],cos(w1/60)*15);
 if dorotatez then rotateZ(stars2^[t],cos(w1/200)*360);
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
  Movelongint(stars^,stars2^,sizeof(tstars) shr 2);
  RotateAll;
  if doclearscreen then filllongint(screen1^,16000,0);
  ShowP(screen1^);
  waitretrace;
  MoveLongint(screen1^,screen,16000);
 until taste=#27;
 Freemem(Screen1,64000);
 Textmode(3);
end.