uses graph;
var gd,gm:integer;
    testb:byte;
procedure test(var x);assembler;
asm
 les di,x
 mov ax,es
 mov es,ax
 mov al,5
 stosb
end;

begin
 gd:=detect;
{ initgraph(gd,gm,'c:\bp\bgi');}
 test(testb);
 write(testb);
 readln;
end.