uses crt,graph;
type screentype=array[0..199,0..319] of byte;

var screen:screentype absolute $a000:0;
    palette:array[0..767] of byte;



procedure init;
var i:word;


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

begin
 asm
  mov ax,13h
  int 10h
 end;
 for i:=1 to 255 do palette[i*3]:=i;
 setpal;
end;

procedure mainprog;
var x,y:word;

begin
 repeat
  fillchar(screen[198,0],640,12);
  for y:=198 to 199 do for x:=1 to 10 do screen[y,random(320)]:=255;

  for y:= 197 downto 1 do for x:= 1 to 318 do
  screen[y,x]:=(screen[y,x]+screen[y+1,x-1]+screen[y+1,x]+screen[y+1,x+1]) shr 2;

 until keypressed;

end;


begin
init;
mainprog;
closegraph;
end.