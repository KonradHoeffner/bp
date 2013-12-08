uses _13h,_32bit,konrad,crt;
type      trect=record
            x1,y1,x2,y2:integer;
           end;

const o_max=3;
    o_anz:word=0;
    o:array[1..o_max] of Trect=(
    (x1:10;y1:10;x2:100;y2:50),
    (x1:150;y1:60;x2:300;y2:120),
    (x1:30;y1:70;x2:120;y2:170)
    );
    ziel:tpos=(x:160;y:100);
    R_WSpeed=5;
    R_MaxSpeed=2;
type trobo=record
            x,y:integer;
            ultra_r:byte;
            wziel:single;
            winkel,speed:single;
            count:word;
           end;
{0=kein US
1=L
2=R
}
var screen1:^tscreen;
    t:integer;
    r1:trobo;
    oldx,oldy:integer;
Procedure Init;
Begin
 Getmem(screen1,64000);
 Init13h;
 with r1 do
 begin
  winkel:=-90;
  speed:=r_Maxspeed;
  x:={319}0;
  y:={199}0;
 end;
End;

Procedure Final;
Begin
 Freemem(screen1,64000);
 Textmode(3);
End;

Procedure Abfrage;
Begin
 if keypressed then
 begin
  taste:=readkey;
 end else taste:='n';
End;
Procedure Rect(r:trect);
var y,dummy:integer;
Begin
 if r.y1>r.y2 then
 begin
  dummy:=r.y1;
  r.y1:=r.y2;
  r.y2:=dummy;
 end;
 with r do for y:=y1 to y2 do fillchar(screen1^[y,x1],x2-x1+1,15);
End;

Procedure Show;
var i:integer;
Begin
 with r1 do screen1^[y,x]:=4;
 with ziel do screen1^[y,x]:=15;
 if o_anz>0 then for i:=1 to o_anz do rect(o[i]);
 with r1 do line(screen1^,oldx,oldy,x,y,4);
End;

Procedure Sensors;
var dx,dy:integer;
Begin
 with r1 do
 begin
  dx:=ziel.x-x;if dx=0 then dx:=1;
  dy:=ziel.y-y;if dy=0 then dy:=1;
  wziel:=arctan(dy/dx)*180/pi;
{  if dy<0 then winkel:=winkel-180;}
{  if dx<0 then winkel:=winkel-180;}
 end;
End;

Procedure MoveR;
Begin
 with r1 do
 begin
  oldx:=x;
  oldy:=y;
  inc(x,round(cos(winkel*pi/180)*speed));
  dec(y,round(sin(winkel*pi/180)*speed));
  if winkel<wziel then winkel:=winkel+R_wspeed else winkel:=winkel-R_wspeed;
  inc(count,5);
{  winkel:=winkel+sin(count*pi/180)*5;}
 end;

End;

Procedure Main;
Begin
  filllongint(screen1^,16000,0);
 repeat
  abfrage;
  sensors;
  mover;
  show;
  waitretrace;
  movelongint(screen1^,screen,16000);
{  filllongint(screen1^,16000,0);}
 until taste=#27;
End;

begin
 Init;
 Main;
 Final;
end.