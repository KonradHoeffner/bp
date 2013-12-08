{Init: ax,bx=0 int 33h
 Abfrage: ax=3 int 33h x=cx y=dx bl=Knopf}
unit mausu;
interface
uses crt;
var maus:record
          x,y:word;
          taste:byte;
         end;

procedure init;
procedure abfrage;

implementation
procedure init;assembler;
asm
 mov ax,0
 mov bx,0
 int 33h
end;

procedure abfrage;assembler;
asm
 mov ax,3
 int 33h
 mov maus.taste,bl
 mov maus.x,cx
 mov maus.y,dx
end;

begin
end.