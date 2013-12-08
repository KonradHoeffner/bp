type p15x15=array[0..224]of byte;
     screent=array[0..63999] of byte;
const
      x:word=20;
      y:word=50;
      pnz:p15x15=              (0,0,0,0,0,2,2,2,2,2,0,0,0,0,0,
                                0,0,0,0,3,3,3,3,3,3,1,0,0,0,0,
                                0,0,0,4,4,4,4,4,4,1,1,0,0,0,0,
                                0,0,3,3,3,5,5,5,5,5,3,3,0,0,0,
                                0,3,3,5,6,6,6,6,6,6,6,3,1,0,0,
                                2,3,3,5,6,7,7,7,7,7,6,3,4,0,2,
                                2,3,3,5,6,7,8,8,8,7,6,5,4,3,2,
                                2,3,4,5,6,7,8,9,8,7,6,3,4,3,2,
                                2,3,4,5,6,7,8,8,8,7,6,3,4,3,2,
                                2,3,4,5,6,7,7,7,7,7,6,3,4,3,2,
                                0,3,4,5,6,6,6,6,6,6,6,3,4,1,0,
                                0,0,3,5,5,5,5,5,5,5,5,3,1,0,0,
                                0,0,2,3,3,3,3,4,3,3,3,1,1,1,0,
                                0,0,0,0,1,1,1,2,3,2,1,0,1,0,0,
                                0,0,0,0,0,1,2,2,2,1,0,0,0,0,0);
var
    schild:byte;
    palette:array[0..767] of byte;
    screen:^screent;

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
 getmem(screen,64000);
 fillchar(screen^,64000,0);
 for x:=1 to 255 do palette[x*3+2]:=x+220; {Blaupalette}
asm
 mov ax,13h
 int 10h
 call setpal    {Pal. setzen}
 mov x,50
 mov y,50
@links:
 cmp x,15
 je @weiter
 dec x
 jmp @weiter
@rechts:
 cmp x,305
 je @weiter
 inc x
 jmp @weiter
@oben:
 cmp y,15
 je @weiter
 dec y
 jmp @weiter
@unten:
 cmp y,185
 je @weiter
 inc y
@weiter:
 mov ax,seg screen
 mov es,ax
{컴Panzer훥etzen컴}
 mov ax,320
 mul y
 add ax,x
 mov di,ax
 mov bx,15
 mov ax,seg pnz
 mov ds,ax
 mov si,offset pnz
@panz_y:
 mov cx,7
 rep movsw
 movsb
 add di,305 {320-15}
 inc si
 dec bx
 or bx,bx
 jnz @panz_y
 {컴컴컴컴컴컴}
 mov ax,0a000h
 mov es,ax
 xor di,di
 lds si,screen
 mov cx,64000
 rep movsb
 {컴Eingabe컴�}
 mov ax,0100h
 int 16h
 je @weiter
 xor ax,ax
 int 16h
 cmp ah,75
 je @links
 cmp ah,77
 je @rechts
 cmp ah,72
 je @oben
 cmp ah,80
 je @unten
 cmp al,27
 jne @weiter
@Ende:
 mov ax,3
 int 10h
end;
end.
