unit beginend;
interface
{------Prozeduren------}
 Procedure BE_Init;
 Procedure BE_Final;
{-----------------------}
implementation
uses vars,konrad,pcx,crt;
{------Prozeduren------}
{----------------------}
Procedure BE_Init;
begin
 asm
  mov ax,13h
  int 10h
 end;
 Maus_Init;
 Getmem(screen1,64000);
End;

Procedure BE_Final;
Begin
 Freemem(screen1,64000);
 asm
  mov ax,3
  int 10h
 end;
End;

end.