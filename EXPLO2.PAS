uses crt,modexlib,dos;
const maxbomb=10;
      bomb:array[0..15*15-1]of byte=(0 ,0 ,0 ,00,00,00,00,99,0 ,0 ,0 ,0 ,0 ,0 ,0 ,
                                     0 ,00,00,0 ,0 ,99,99,99,99,99,99,0 ,00,0 ,0 ,
                                     0 ,0 ,0 ,0 ,99,20,20,30,20,20,20,99,0 ,00,0 ,
                                     0 ,0 ,0 ,99,20,20,20,30,20,20,20,00,99,00,0 ,
                                     0 ,0 ,99,20,20,20,99,30,99,20,20,20,20,99,0 ,
                                     0 ,99,20,20,20,30,99,50,99,30,20,20,20,99,0 ,
                                     0 ,99,20,20,20,99,99,99,99,99,20,20,20,99,0 ,
                                     99,99,30,50,99,99,99,99,99,99,50,30,99,99,99,
                                     0 ,0 ,99,20,20,99,99,50,99,99,20,20,20,99,00,
                                     0 ,0 ,0 ,99,20,30,99,30,99,30,20,20,99,20,00,
                                     0 ,0 ,0 ,99,99,20,20,30,20,20,20,99,20,00,0 ,
                                     0 ,0 ,0 ,0 ,99,20,20,30,20,20,99,0 ,0 ,0 ,0 ,
                                     0 ,0 ,0 ,0 ,99,20,20,30,20,99,0 ,0 ,0 ,0 ,0 ,
                                     0 ,0 ,0 ,0 ,0 ,99,99,99,99,0 ,0 ,0 ,0 ,0 ,0 ,
                                     0 ,0 ,0 ,0 ,0 ,0 ,0 ,99,0 ,0 ,0 ,0 ,0 ,0 ,0 );





type screentype=array[0..199,0..319] of byte;
var
    screen1:^screentype;
    taste:char;
    i,j,x,y,offs:word;
    bombe:array[1..maxbomb] of record
                               x,y:word;
                               count:byte;
                               end;

procedure init;
begin
  for i:=0 to 14 do
  for j:=0 to 14 do
  bomb[i*15+j]:=bomb[i*15+j] shl 2;

 asm
    mov ax,13h
    int 10h
 end;

 fillchar(palette,768,0);
   For i:=0 to 7 do Begin
    Palette[i*3+2]:=i*2;
    Palette[(i+8)*3+2]:=16-i*2;
  End;
  For i:=8 to 31 do
      Palette[i*3]:=(i-8)*63 div 23;
  For i:=32 to 55 do Begin
    Palette[i*3]:=63;
    Palette[i*3+1]:=(i-32)*63 div 23;
  End;
  For i:=56 to 79 do Begin
    Palette[i*3]:=63;
    Palette[i*3+1]:=63;
    Palette[i*3+2]:=(i-56)*63 div 23;
  End;
  FillChar(Palette[80*3],176*3,63);

 setpal;
 randomize;
end;
procedure rand;near;
begin
 offs:=random($ffff);
 asm
 not offs
 rol offs,3
 end;
end;

procedure rep_movsd;near;
begin
inline($F3/$A6);
end;

begin
 init;
 asm
 @start:
  call rand
  mov ax,seg bomb
  mov ds,ax
  mov si,offset bomb

  mov ax,seg screen1
  mov es,ax
  mov di, offset screen1
  add di,offs
  mov dx,15
 @schleif:
  mov cx,15
  rep movsb
  add di,305
  dec dx
  or dx,dx
  jnz @schleif
  {컴컴컴컴컴컴컴컴}
   mov ax,seg screen1
  mov ds,ax
  mov si,offset screen1

  mov ax,0a000h
  mov es,ax
  xor di,di

  mov cx,64000
 @schleif2:
  xor ax,ax
  xor bx,bx

  mov al,[si-321]
  mov bl,[si-320]
  add ax,bx
  mov bl,[si-319]
  add ax,bx

  mov bl,[si-1]
  add ax,bx
  mov bl,[si+1]
  add ax,bx
  mov bl,[si+319]
  add ax,bx
  mov bl,[si+320]
  adc ax,bx
  mov bl,[si+321]
  adc ax,bx

  shr ax,3
  stosb
  inc si
  loop @schleif2
  mov ax,0a000h
  mov ds,ax
  xor si,si
  mov ax,seg screen1
  mov es,ax
  mov di,offset screen1
  mov cx,16000
  call rep_movsd
  {컴컴컴컴컴컴컴컴}
  mov ax,0100h
  int 16h
  je @start
 end;
end.