uses _13h,_32bit,konrad,crt;
const anz=2;
      p:tPos=(x:0;y:0);
var screen1:^tscreen;
    map:array[1..anz] of ^tscreen;
    t:integer;
Procedure Init;
var y:word;
Begin
{ Getmem(screen1,64000);}
 for t:=1 to anz do Getmem(map[t],64000);
 for t:=1 to anz do for y:=0 to 199 do fillchar(map[t]^[y,0],320,y);
 maus_init;
 setmaus(320,100);
 Init13h;
End;

Procedure Final;
Begin
 for t:=1 to anz do Freemem(map[t],64000);
{ Freemem(screen1,64000);}
 Textmode(3);
End;

Procedure Abfrage;
Begin
 maus_abfrage;maus.x:=maus.x shr 1;
 inc(p.y,maus.y-100);
 if p.y<0 then p.y:=0;
 setmaus(320,100);
 if keypressed then
 begin
  taste:=readkey;
 end else taste:='n';
End;

Procedure Main;
Begin
 repeat
  abfrage;
  screen1:=@map[1]^[p.y,p.x];
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