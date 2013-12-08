uses Konrad,_13h,crt;
var x:word;y:byte;
Procedure MyPut(x,y:word;col:byte);near;assembler;
asm
 mov ax,0a000h
 mov es,ax
 lea di,yTbl
 add si,y
 mov ax,[si]
 add ax,x
 mov es:[di],ax
end;
Begin
 InityTbl;
 Init13h;
 DirectVideo:=False;
 fillchar(screen,16000,0);
 Readln;
{ for t:=1 to 200 do
 for y:=0 to 199 do for x:=0 to 319 do
  Put13h(screen,x,y,y+t);
 Readln;}
  for t:=1 to 200 do
 for y:=0 to 199 do for x:=0 to 319 do
  screen[y,x]:=y+t;
 readln;
  for t:=1 to 200 do
for y:=0 to 199 do for x:=0 to 319 do
  mem[seg(screen):yTbl[y]+x]:=y+t;


 Readln;
End.