uses _32bit,crt,konrad,_13h,_3d;
const zoom:integer=256;
      dist:integer=300;
      anz=256;
      rx=0;
      ry=1;
      rz=0;
var p:array[1..anz] of TPos3d;
    vp:array[1..anz] of TPos;
    screen1:^tscreen;
    t:integer;
    values:array[1..anz] of TPos3d;

Procedure InitPos(nr:word);
Begin
 with p[nr] do
 begin
  x:=0;
  y:=-100;
  z:=0;
 end;
 with values[nr] do
 begin
  x:=random*2-1;
  z:=random*1-0.5;
  y:=+1.5+random*1.5;
 end;
End;

procedure domove;
var t:word;
begin
 for t:=1 to anz do with p[t] do
 begin
  values[t].y:=values[t].y-0.03;
  x:=x+values[t].x;
  y:=y+values[t].y;
  z:=z+values[t].z;
  if y<-100 then initpos(t);
 end;
end;

procedure dorotate;
begin
 rotateA(p,anz,rx,ry,rz);
 rotateA(values,anz,rx,ry,rz);
end;

Procedure Init;
Begin
 Randomize;
 Getmem(screen1,64000);
 Init13h;
 for t:=1 to anz do InitPos(t);
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

Procedure Show(var d:tscreen);
var t:integer;
Begin
 for t:=1 to anz do with vp[t] do
 if (x>=0) and (x<320) and (y>=0) and (y<200) then
 d[y,x]:=4;
End;

Procedure Main;
Begin
 repeat
  abfrage;
  domove;
  dorotate;
  makevis(p,vp,anz,dist,zoom);
  show(screen1^);
  waitretrace;
  movelongint(screen1^,screen,16000);
  filllongint(screen1^,16000,0);
 until taste=#27;
End;

begin
 Init;
 Main;
 Final;
end.
