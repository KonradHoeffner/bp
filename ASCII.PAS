uses dos;
var c:byte;
begin
 asm
  mov ax,3
  int 10h
 end;
 for c:=0 to 255 do write(' ',c,': ',char(c));
 readln;
end.