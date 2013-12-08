uses konrad,_32bit,_13h,crt;
var screen:array[1..4] of ^tscreen;
    w1,w2,t:word;
    s1,s2:string;
    b1,b2:byte;
    c1,c2:char;

Procedure Scroll_Up(src_frame,dest_frame:pointer);assembler;
{scrollt das Bild um eine Zeile nach oben und interpoliert}
asm
  push ds
  les di,Dest_Frame             {Zeiger auf Zielbild laden}
  lds si,Src_Frame              {Zeiger auf Quellbild}
{  add si,320  }                  {im Quellbild auf Zeile 1}
  mov cx,320*198                 {99 Zeilen scrollen}
  xor bl,bl                     {wird als Dummy fÅr High-Byte benîtigt}
@lp1:
  xor ax,ax
  xor bx,bx
  mov al,[si-319]
  mov bl,[si-320]
  add ax,bx
  mov bl,[si-321]
  adc ax,bx
  mov bl,[si-1]
  adc ax,bx
  mov bl,[si+1]
  adc ax,bx
  mov bl,[si+319]
  adc ax,bx
  mov bl,[si+320]
  adc ax,bx
  mov bl,[si+321]
  adc ax,bx

  shr ax,3

  or ax,ax                      {bereits 0 ?}
  je @null
  dec al                        {wenn nein, dann verringern}
@null:
  stosb                         {Wert ins Ziel}
  inc si                        {nÑchsten Punkt}
  dec cx                        {weitere Punkte ?}
  jne @lp1
  pop ds
End;

procedure init;
begin
 init13h;
 for t:=2 to 4 do getmem(screen[t],64000);
 randomize;
end;

procedure ende;
begin
 textmode(3);
 for t:=2 to 4 do freemem(screen[t],64000);
end;

procedure prep_screen;
begin
 for t:=0 to 767 do palette[t*3+2]:=t shr 2;
 setpal;
 for w1:=1 to 319 do for w2:=1 to 199 do screen[2]^[w2,w1]:=random(256);
end;

procedure wisch1;
begin
 scroll_up(screen[2],screen[1]);
 scroll_up(screen[1],screen[2]);
end;

procedure palrot;
begin
 for t:=0 to 255 do inc(palette[t*3+2]);
 setpal;
end;

procedure scroll;
begin
 movelongint(screen[1]^[199,0],screen[2]^,320);
 movelongint(screen[1]^,screen[2]^[1,0],320*199 shr 2);
 movelongint(screen[2]^,screen[1]^,320*200 shr 2);
{ movelongint(screen[1]^[0,0],screen[1]^[5,0],320*199 shr 2);}
end;

procedure schleif;
begin
 repeat
  waitretrace;
  setpal;
  palrot;
  scroll;
 until keypressed;
end;

begin
 init;
 screen[1]:=ptr($a000,0);
 prep_screen;
 for t:=1 to 5 do wisch1;
{ movelongint(screen[2]^,screen[1]^,16000);}
{ for t:=1 to 5 do wisch1;}
 schleif;

 ende;
end.