uses _13h,_32bit,konrad,crt;
const anz=256;
var screen1:^tscreen;
    t:integer;
    punkte:array[1..anz] of TPos;
Procedure Init;
Begin
 Randomize;
 Maus_Init;
 fillreallongint(punkte,anz,160+100 shl 16);
 SetMaus(320,100);
 Getmem(screen1,64000);
 Init13h;
 for t:=1 to 255 do setmypalette(t,t shr 2,t shr 3,0);
End;

Procedure Final;
Begin
 Freemem(screen1,64000);
 Textmode(3);
End;

Procedure Abfrage;
Begin
 Maus_Abfrage;Maus.x:=Maus.x shr 1;
 if keypressed then
 begin
  taste:=readkey;
 end else taste:='n';
End;

Procedure Main;
var x1,x2,y1,y2:integer;
Begin
 repeat
  abfrage;
  move(punkte[2],punkte[1],(anz-1)*sizeof(tpos));
  punkte[anz].x:=maus.x;
  punkte[anz].y:=maus.y;
  for t:=1 to anz do with punkte[t] do
  begin
    inc(x,random(3)-1);
    inc(y,random(3)-1);
  end;
  for t:=1 to anz-1 do with punkte[t] do
  begin
   with punkte[t] do begin x1:=x; y1:=y;end;
   with punkte[t+1] do begin x2:=x; y2:=y;end;
   if not ((x1=x2) and (y1=y2)) then
   line(seg(screen1^),x1,y1,x2,y2,t);
  end;
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