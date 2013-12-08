uses _32bit,crt,konrad,_13h,_3d;
const zoom:integer=256;
      dist:integer=300;
      anz=256;
var p:array[1..anz] of TPos3d;
    vp:array[1..anz] of TPos;
    screen1:^tscreen;
    t:integer;

Procedure InitPos;
Begin
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

Procedure MoveP;
var t:integer;
Begin
 for t:=1 to anz do with p[t] do
 begin

 end;
End;

Procedure Show(var d:tscreen);
var t:integer;
Begin
 for t:=1 to anz do with vp[t] do
 if (x>=0) and (x<320) and (y>=0) and (y<200) then
 d[y,x]:=255;
End;

Procedure Main;
Begin
 repeat
  abfrage;
  moveP;
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
