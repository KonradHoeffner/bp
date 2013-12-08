uses _13h,_32bit,konrad,crt;
type tgras=array[0..9,0..9] of byte;
const
 anzx=160;{5*5 Bildschirme}
 anzy=100;
 gras_anz=2;
 gras:array[1..gras_anz] of tgras=

((
(1,2,1,2,2,1,2,1,2,2),
(2,1,1,2,1,2,1,2,1,2),
(2,1,1,1,1,1,2,2,2,1),
(1,2,2,2,1,1,2,1,1,1),
(2,1,1,1,2,2,2,1,1,1),
(2,2,2,1,1,1,2,1,1,1),
(2,2,2,2,1,1,1,1,1,2),
(2,2,1,1,1,1,1,2,2,2),
(2,2,2,1,1,1,1,2,2,2),
(2,2,2,2,2,1,1,1,1,2
)),
(
(2,2,1,2,1,2,1,2,2,2),
(1,1,1,2,2,2,2,2,1,1),
(2,2,2,2,1,1,1,2,2,1),
(2,2,1,1,2,1,1,1,1,2),
(2,2,2,2,1,1,1,1,1,2),
(2,2,2,1,1,1,2,2,2,1),
(2,2,2,1,1,1,2,2,2,2),
(1,1,2,1,2,1,1,1,2,2),
(1,2,1,1,1,1,2,1,2,1),
(2,1,1,1,1,2,1,2,1,1)));

type tarea=array[0..anzx-1,0..anzy-1] of byte;
var screen1:^tscreen;
    t:integer;
    area:tarea;
    s:record {Spieler}
       x,y:integer;
       xspeed,yspeed:shortint;
      end;

Procedure Prepare_Area;
var x,y:integer;
Begin
 for y:=0 to anzy-1 do
  for x:=0 to anzx-1 do
   area[x,y]:=random(gras_anz)+1;
End;

Procedure Init;
Begin
 randomize;
 s.x:=0;
 s.y:=0;
 s.xspeed:=3;
 s.yspeed:=2;
 Getmem(screen1,64000);
 Init13h;
 setmypalette(1,0,30,0);
 setmypalette(2,0,50,0);
 Prepare_Area;
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

Procedure Show(a:tarea;var d:tscreen);
var x,y:integer;

 Procedure Putgras(x,y:word;nr:byte);
 var my:integer;
 Begin
  for my:=0 to 9 do
   move(gras[nr][my,0],d[y+my,x],10);
 End;

Begin
 for x:=s.x to s.x+31 do
  for y:=s.y to s.y+19 do
   putgras(10*(x-s.x),10*(y-s.y),area[x,y]);
End;

Procedure Move;
Begin
 with s do
 begin
  if xspeed>0 then
  if x<anzx-1-xspeed-32 then inc(x,xspeed)
                        else xspeed:=-xspeed
              else
  if x>=-xspeed          then inc(x,xspeed)
                        else xspeed:=-xspeed;
  if yspeed>0 then
  if y<anzy-1-yspeed-32 then inc(y,yspeed)
                        else yspeed:=-yspeed
              else
  if y>=-yspeed          then inc(y,yspeed)
                        else yspeed:=-yspeed;
 end;
End;

Procedure Main;
var sx,sy:string;
Begin
 repeat
  abfrage;
  move;
  show(area,screen1^);
  delay(200);
  str(s.x,sx);
  str(s.y,sy);
  outtextxy2(0,0,sx+' - '+sy,red,screen1^);
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