uses _32bit,crt,konrad,_13h,_3d;
const zoom:integer=256;
      dist:integer=600;
      max=4;
      anz:word=max;
mauer:array[1..max,1..3] of Real=(
(-200,+100,0),
(-200,-100,0),
(+200,+100,0),
(+200,-100,0));
var p:array[1..max] of TPos3d;
    vp:array[1..max] of TPos;
    screen1:^tscreen;
    t:integer;

Procedure InitPos;
Begin
 move(mauer,p,sizeof(mauer));
End;
Procedure Init;
Begin
 Getmem(screen1,64000);
 InitTables;
 Init13h;
 InitPos;
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

Procedure Move;
var t:integer;
Begin
 for t:=1 to max do with p[t] do
 begin
   rotatey(p[t],1);
 end;
End;

Procedure Show(var d:tscreen);
var t:integer;
    y,x,dx1,dx2,dy1,dy2,mx,my:integer;
    anstieg:real;
Begin
 dy1:=vp[2].y-vp[1].y;
 dy2:=vp[4].y-vp[3].y;
 dx1:=vp[3].x-vp[1].x;
 dx2:=vp[4].x-vp[2].x;
 if dx1=0 then dx1:=1;
 if dx2=0 then dx2:=1;

 if vp[1].x<vp[3].x then
  for y:=0 to dy1 do
  begin
   anstieg:=(dy2-dy1)/dy1;
   line(seg(d),vp[1].x,y+vp[1].y,vp[3].x,vp[1].y+round(y*anstieg/2),15);
  end;
 for t:=1 to anz do with vp[t] do d[y,x]:=red;
End;

Procedure Main;
Begin
 repeat
  abfrage;
  move;
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
