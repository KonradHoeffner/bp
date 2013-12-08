uses _13h,_32bit,konrad,crt,pcx2;
var screen1:^tscreen;
    t:integer;
Procedure Init;
Begin
 Getmem(screen1,64000);
 Init13h;
 loadpcx('titel.pcx',screen1^,palette);
 setpal;
End;

Procedure Final;
Begin
 Freemem(screen1,64000);
 Textmode(3);
End;

Procedure Main;
Begin
 movelongint(screen1^,screen,16000);
 readkey;
End;

begin
 Init;
 Main;
 Final;
end.