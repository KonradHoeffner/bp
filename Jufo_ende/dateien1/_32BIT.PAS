{$R-}{$Q-}{$G+}
{ÄÄUnit _32BITÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
 Erlaubt schnelles Speicherkopieren und -fllen durch 386-Befehle
 Grundlage: Pascal-Assembler erlaubt zwar implizit nur 286-Befehle,
 durch Voranstellen des Operand Size Prefixes sind dennoch Operationen
 mit den 32Bit-Registern in beschr„nktem Maáe m”glich
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

unit _32bit;
interface

procedure filllongint(var target;l:word;col:byte);
{Wie fillchar, fllt aber 4 Bytes auf einmal, l ist die Anzahl der
gefllten Longints}
procedure fillreallongint(var target;l:word;col:longint);
{wie Fillchar, fllt aber Longints }
procedure fillword(var target;l:word;col:word);
{wie Fillchar, fllt aber Words }
procedure movelongint(var source,target;count:word);
{wie Move, kopiert aber Longints }
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