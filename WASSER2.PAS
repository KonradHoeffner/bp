uses crt;
type screent=array[0..199,0..319] of byte;
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
    b:byte;
    w:word;

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

begin
asm
 mov ax,13h
 int 10h
end;



 asm
 mov ax,0a000h
 mov es,ax
 mov dx,anz
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
 dec dx
 or dx,dx
 jnz @schl
 end;
 repeat
 waitretrace;
 for b:=1 to 254 do inc(palette[b*3+farbe]);
 setpal;
 until keypressed;
end.