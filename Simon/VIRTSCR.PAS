uses _13h,_32bit,konrad,crt;
const max=10000;
      anz:word=max;
var screen1:^tscreen;
    t:integer;
    sprite:array[1..max] of TPos;
    ich:TPos;
Procedure Init;
Begin
 Ich.X:=0;
 Ich.y:=0;
 Getmem(screen1,64000);
 Init13h;
 Randomize;
 maus_init;
 for t:=1 to anz do with sprite[t] do
 begin
  x:=random(640);
  y:=random(400);
 end;
End;

Procedure Final;
Begin
 Freemem(screen1,64000);
 Textmode(3);
End;

Procedure Abfrage;
Begin
 maus_abfrage;maus.x:=maus.x shr 1;
 inc(ich.x,maus.x-160);
 inc(ich.y,maus.y-100);
 setmaus(320,100);
 if keypressed then
 begin
  taste:=readkey;
 end else taste:='n';
End;

Function Sichtbar(x,y:integer):boolean;
Begin
 if (x>=0) and (x<320) and (y>=0) and (y<200) then
  sichtbar:=true else
   sichtbar:=false;
End;

Procedure ShowThings;
var t,vx,vy:integer; {vx=virtuelles X auf dem Bildschirm, vy...}
Begin
 for t:=1 to anz do with sprite[t] do
 begin
  vx:=x-ich.x;
  vy:=y-ich.y;
  if sichtbar(vx,vy) then screen1^[vy,vx]:=15;
 end;
End;
Procedure Main;
Begin
 repeat
  abfrage;
  showthings;
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