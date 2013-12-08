{Init: ax,bx=0 int 33h
 Abfrage: ax=3 int 33h x=cx y=dx bl=Knopf}
uses crt;
begin
 asm
  xor ax,ax
  xor bx,bx
  int 33h
  mov ax,13h
  int 10h
 end;
 repeat
  asm
   mov ax,3
   int 33h
   or bl,bl
   jz @weiter
   mov ax,0a000h
   mov es,ax
   mov ax,320
   mul dx
   add ax,cx
   mov di,ax
   mov ax,0f0fh
   stosw
  @weiter:
  end;
 until keypressed;
end.
 reg.ax:=3;
 intr($33,reg);
 button:=reg.bl;
 x:=reg.cx;
 y:=reg.dx;
