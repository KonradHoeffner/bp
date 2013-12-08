{$G+}
Uses Crt,ModeXLib;

Type Block=Array[0..199,0..319] of Byte;

Var
  Src_Frame,                    {vorheriges Bild}
  Dest_Frame:^Block;            {aktuelles Bild}
  taste:char;
  x,y,i:integer;

  speedx,speedy:shortint;

Procedure Scroll_Up;assembler;
{scrollt das Bild um eine Zeile nach oben und interpoliert}
asm
  push ds
  les di,Dest_Frame             {Zeiger auf Zielbild laden}
  lds si,Src_Frame              {Zeiger auf Quellbild}
  add si,320                    {im Quellbild auf Zeile 1}
  mov cx,320*198                 {99 Zeilen scrollen}
  xor bl,bl                     {wird als Dummy fr High-Byte ben”tigt}
@lp1:
  xor ax,ax
  xor bx,bx
  mov al,[si]
  mov bl,[si+319]
  add ax,bx
  mov bl,[si+320]
  adc ax,bx
  mov bl,[si+321]
  adc ax,bx
  shr ax,2

  or ax,ax                      {bereits 0 ?}
  je @null
  dec al                        {wenn nein, dann verringern}
@null:
  stosb                         {Wert ins Ziel}
  inc si                        {n„chsten Punkt}
  dec cx                        {weitere Punkte ?}
  jne @lp1
  pop ds
End;


Procedure Show_Screen;          {kopiert fertigen Bilschirm auf VGA}
Var temp:Pointer;               {zum Tauschen der Zeiger}
Begin
asm
  push ds
  lds si,Dest_Frame             {fertiges Bild als Quelle}
  mov ax,0a000h                 {VGA als Ziel}
  mov es,ax
  xor di,di
  mov cx,320*200/4              {100 Zeilen als Dwords kopieren}
db 66h                          {Operand Size Prefix (32 Bit)}
  rep movsw                     {kopieren}
  pop ds
End;
  temp:=Dest_Frame;             {Zeiger auf Quell- und Zielbild tauschen}
  Dest_Frame:=Src_Frame;
  Src_Frame:=temp;
End;

Procedure Prep_Pal;             {Palette auf Flames vorbereiten}
Var i:Word;
Begin
  FillChar(Palette,80*3,0);     {Grundlage: alles schwarz}
  For i:=0 to 7 do Begin
    Palette[i*3+2]:=i*2;        {Farbe 0-7: Anstieg Blau}
    Palette[(i+8)*3+2]:=16-i*2; {Farbe 0-7: abfallendes Blau}
  End;
  For i:=8 to 31 do             {Farbe 8 -31: Anstieg Rot}
    Palette[i*3]:=(i-8)*63 div 23;
  For i:=32 to 55 do Begin      {Farbe 32-55: Anstieg Grn, Rot konstant}
    Palette[i*3]:=63;
    Palette[i*3+1]:=(i-32)*63 div 23;
  End;
  For i:=56 to 79 do Begin      {Farbe 56-79: Anstieg Blau,Rot u. Blau konst.}
    Palette[i*3]:=63;
    Palette[i*3+1]:=63;
    Palette[i*3+2]:=(i-56)*63 div 23;
  End;
  FillChar(Palette[80*3],176*3,63);  {Rest weiá}
  SetPal;                       {fertige Palette setzen}
End;


procedure feuer;assembler;
asm
 les di,dest_frame
 mov ax,320
 mul y
 add ax,x
 add di,ax
 mov cx,14
 mov ax,06464h {100/100}
 rep stosw
 mov bx,5
@l:
 mov cx,14
 add di,292
 rep stosw
 dec bx
 or bx,bx
 jne @l
 mov di,63360
 mov cx,321
 xor ax,ax
 rep stosw
end;

begin
  Randomize;
  GetMem(Src_Frame,320*200);    {Speicher fr Quellbild holen und l”schen}
  FillChar(Src_Frame^,320*200,0);
  GetMem(Dest_Frame,320*200);   {Speicher fr Ziellbild holen und l”schen}
  FillChar(Dest_Frame^,320*200,0);
  speedx:=0;
  speedx:=0;
  asm
   mov ax,13h
   int 10h
  end;
  Prep_Pal;
  x:=10;
  y:=10;
  Repeat
    inc(i);
    Scroll_Up;
    if keypressed then taste:=readkey else taste:='1';
    case taste of
     #75:dec(speedx,4);
     #77:inc(speedx,4);
     #72:dec(speedy,4);
     #80:inc(speedy,4);
    end;
    asm
     cmp i,4
     jne @weiter
     mov i,0
     or speedy,0
     jng @y1
     dec speedy
    @y1:
     jnl @y2
     inc speedy
    @y2:
     or speedx,0
     jng @x1
     dec speedx
    @x1:
     jnl @x2
     inc speedx
    @x2:
    @weiter:
    end;
    inc(x,speedx);
    inc(y,speedy);
    asm
     cmp y,198
     jng @prally1
     mov y,198
     neg speedy
    @prally1:  {wenn y ganz unten ->Abprall}
     cmp y,0
     jnl @prally2
     mov y,0
     neg speedy
    @prally2:


     cmp x,291
     jng @prallx1
     mov x,291
     neg speedx
    @prallx1:
     cmp x,0
     jnl @prallx2
     mov x,0
     neg speedx
    @prallx2:

    end;
    feuer;
    Show_Screen;                {fertigen Bildschirm zeigen}
  Until taste=#27;
  TextMode(3);
end.
