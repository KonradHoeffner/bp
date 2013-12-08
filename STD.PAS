uses _13h,_32bit,konrad,crt;
var screen1:^tscreen;
    t:integer;
Procedure Init;
Begin
 Getmem(screen1,64000);
 Init13h;
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

Procedure Main;
Begin
 repeat
  abfrage;
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