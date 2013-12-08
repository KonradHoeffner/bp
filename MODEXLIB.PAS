
unit modexlib;
interface
type ptype=array[1..768] of byte;
var palette:ptype;
procedure setpal;
procedure waitretrace;
implementation

procedure setpal;assembler;
asm
 push si
 mov si,offset palette
 mov cx,256*3
 xor al,al
 mov dx,03c8h
 out dx,al
 inc dx
 rep outsb
 pop si
end;

procedure waitretrace;
begin
repeat until (port[$3da] and $08)<>0;
repeat until (port[$3da] and $08)=0;
end;

end.