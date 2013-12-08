

{Init: ax,bx=0 int 33h
 Abfrage: ax=3 int 33h x=cx y=dx bl=Knopf}
uses crt,dos;
var maus:record
          x,y:word;
          taste:byte;
         end;
    r:registers;

{Assembler:}
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

{Das gleiche in Pascal:}

procedure init2;
begin
 r.ax:=0;
 r.bx:=0;
 intr($33,r);
end;

procedure abfrage2;
begin
 r.ax:=3;
 intr($33,r);
 maus.taste:=r.bl;
 maus.x:=r.cx;
 maus.y:=r.dx;
end;

begin
clrscr;
textcolor(15);
init;
with maus do
repeat
 gotoxy(1,1);
 writeln('Mauskoordinaten: x= ',x div 8+1,' y=',y div 8+1,'  ');
 write('Taste: ');
 case taste of
 1:write('Links ');
 2:write('Rechts');
 0:write('keine ');
 end;
 gotoxy(x div 8+1,y div 8+1);
 delay(10);
 write(' ');
 abfrage;
 gotoxy(x div 8+1,y div 8+1);
 write('Û');
 gotoxy(80,24);
 write(' ');
until taste=3;{Maustaste 1 und 2}

end.