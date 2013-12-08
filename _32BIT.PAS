{$R-}{$Q-}{$G+}
unit _32bit;


interface

procedure filllongint(var target;l:word;col:byte);
procedure fillreallongint(var target;l:word;col:longint);
procedure fillword(var target;l:word;col:word);
procedure movelongint(var source,target;count:word);

implementation

procedure filllongint(var target;l:word;col:byte); assembler;
asm
 les di, target
 mov cx, l
 mov ah, col
 mov al, col
 db 66h; shl ax, 16
 mov ah, col
 mov al, col
 db 66h; rep stosw
end;

procedure fillreallongint(var target;l:word;col:longint);assembler;
asm
 les di, target
 mov cx, l
 mov ax, word ptr col+2
 db 66h; shl ax, 16
 mov ax,word ptr col
 db 66h; rep stosw
end;

procedure fillword(var target;l:word;col:word); assembler;
asm
 les di, target
 mov cx,l
 mov ax,col
 rep stosw
end;

procedure movelongint(var source,target;count:word); assembler;

asm
 push ds
 lds si, source
 les di, target
 mov cx, count
db 66h; rep movsw
 pop ds
end;

end.