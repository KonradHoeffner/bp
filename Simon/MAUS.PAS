{Init: ax,bx=0 int 33h
 Abfrage: ax=3 int 33h x=cx y=dx bl=Knopf}
uses crt;
var maus:record
         x,y:word;
         taste:byte;
         end;

procedure abfrage;assembler;
asm
 mov ax,3
 int 33h
 mov maus.x,cx
 mov maus.y,dx
 mov maus.taste,bl
end;


begin
 asm
  mov ax,0
  mov bx,0
  int 33h
 end;
repeat
 abfrage;
 clrscr;
 writeln(maus.x div 8+1,' ',maus.y div 8+1);
 gotoxy(maus.x div 8+1,maus.y div 8+1);write(#2);
 delay(10);
until maus.taste<>0;
end.