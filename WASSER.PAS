uses crt,_32bit,konrad;
type tscreen=array[0..199,0..319] of byte;
const anz=8;
      farbe=0; {0=Rot,1=G,2=B}
      text:array[0..11] of string=
      ('Dieser Test wurde',
       'programmiert von',
       '->Konrad   H”ffner<-',
       '            ',
       '',
       '       1997',
       '',
       '     in Leipzig',
       '',
       'mit Borland Pascal 7.0 ',
       '',
       'Dies war ein Test-Text.');

var palette:array[0..767] of byte;
    tcos,tsin:array[0..359] of real;
    b:byte;
    w:word;
    screen1,screen2:^tscreen;

procedure WaitRetrace;assembler;
asm
  mov dx,3dah                   {Input Status Register 1}
@wait1:
  in al,dx                      {Bit 3 wird 0 wenn Strahl beim Bildaufbau}
  test al,08h
  jnz @wait1
@wait2:
  in al,dx                      {Bit 3 wird 1 wenn Retrace}
  test al,08h
  jz @wait2
end;                          {jetzt ist Strahl ganz unten am Bildschirm}



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

procedure w1;
begin
 asm
 les di,screen1
 lds si,screen2
@schl:
 xor di,di
 xor ax,ax
 xor bx,bx
 mov cx,64000
@bild_schl:
 mov al,es:[di-321]
 mov bl,es:[di-320]
 add ax,bx
 mov bl,es:[di-319]
 add ax,bx
 mov bl,es:[di-1]
 add ax,bx
 mov bl,es:[di+1]
 add ax,bx
 mov bl,es:[di+319]
 add ax,bx
 mov bl,es:[di+320]
 add ax,bx
 mov bl,es:[di+321]
 add ax,bx
 shr ax,3
 stosb
 loop @bild_schl
 end;

end;

procedure w2;
begin
 asm
 les di,screen2
 lds si,screen1
@schl:
 xor di,di
 xor ax,ax
 xor bx,bx
 mov cx,64000
@bild_schl:
 mov al,es:[di-321]
 mov bl,es:[di-320]
 add ax,bx
 mov bl,es:[di-319]
 add ax,bx
 mov bl,es:[di-1]
 add ax,bx
 mov bl,es:[di+1]
 add ax,bx
 mov bl,es:[di+319]
 add ax,bx
 mov bl,es:[di+320]
 add ax,bx
 mov bl,es:[di+321]
 add ax,bx
 shr ax,3
 stosb
 loop @bild_schl
 end;
end;
begin
asm
 mov ax,13h
 int 10h
end;
 getmem(screen1,64000);
 getmem(screen2,64000);
 fillchar(palette,768,0);
 for b:=1 to 254 do palette[b*3+farbe]:=b;
 fillchar(palette[255*3],3,255);
 setpal;
 for w:=0 to 359 do
 begin
  tcos[w]:=cos(w*pi/180);
  tsin[w]:=sin(w*pi/180);
 end;                                           {320*100+160(Bildmitte)}
 for b:=1 to 200 do for w:=0 to 359 do screen1^[trunc(100+tsin[w]*b),trunc(tcos[w]*b)]:=255;
 w1;w2;w1;w2;
 movelongint(screen1^,screen,16000);
 repeat
 waitretrace;
 for b:=1 to 254 do inc(palette[b*3+farbe]);
 setpal;
 until keypressed;
end.