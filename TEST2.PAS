uses _32bit,crt,konrad,_13h;
var screen1:^tscreen;
    p:pointer;

procedure flip(var x);assembler;
asm
 push ds
 lds si,x
 mov ax,0a000h
 mov es,ax
 xor di,di
 mov cx,64000
 rep movsb
 pop ds
end;


begin
 init13h;
 new(screen1);
 fillchar(screen1^,64000,0);
 screen1^[10,10]:=1;
 flip(screen1^);
 readkey;
end.