{$G+}
{
 Konrad's Flammenwerfersimmulation
 ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ

-entwickelt mit Hilfe des Buches
 "PC-Underground"

  LINKS =nach links
  RECHTS=nach rechts
    +   =breiter
    -   =dÅnner
  OBEN  =stÑrker
  UNTEN=schwÑcher

  LEER=Feuer!
                  }
Uses Crt,ModeXLib;
const y=190; {190}
      x=170; {170}
Type Block=Array[0..199,0..319] of Byte;

Var
  Src_Frame,                    {vorheriges Bild}
  Dest_Frame:^Block;            {aktuelles Bild}
  taste:char;
  tsin,tcos:array[0..180] of real;
  i:word;
  winkel,power,breite:byte;
  richtung:shortint;

Procedure Scroll_Up;assembler;
{scrollt das Bild um eine Zeile nach oben und interpoliert}
asm
  push ds
  les di,Dest_Frame             {Zeiger auf Zielbild laden}
  lds si,Src_Frame              {Zeiger auf Quellbild}
  add si,320                    {im Quellbild auf Zeile 1}
  mov cx,320*198                 {99 Zeilen scrollen}
  xor bl,bl                     {wird als Dummy fÅr High-Byte benîtigt}
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
  inc si                        {nÑchsten Punkt}
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
  For i:=32 to 55 do Begin      {Farbe 32-55: Anstieg GrÅn, Rot konstant}
    Palette[i*3]:=63;
    Palette[i*3+1]:=(i-32)*63 div 23;
  End;
  For i:=56 to 79 do Begin      {Farbe 56-79: Anstieg Blau,Rot u. Blau konst.}
    Palette[i*3]:=63;
    Palette[i*3+1]:=63;
    Palette[i*3+2]:=(i-56)*63 div 23;
  End;
  FillChar(Palette[80*3],176*3,63);  {Rest wei·}
  SetPal;                       {fertige Palette setzen}
End;

procedure linie(b:boolean);
begin
 if b=true then
 for i:=1 to 20 do dest_frame^[199-trunc(tsin[winkel-2]*i),170+trunc(tcos[winkel]*i)]:=0
  else for i:=1 to 20 do dest_frame^[190-trunc(tsin[winkel+2]*i),170+trunc(tcos[winkel]*i)]:=0;

 for i:=1 to 20 do dest_frame^[190-trunc(tsin[winkel]*i),170+trunc(tcos[winkel]*i)]:=80;
end;

procedure feuer;
begin
 for i:=1 to 600 do dest_frame^[y-trunc(tsin[winkel]*(i shr 2))
 ,x+trunc(tcos[winkel]*(i shr 2))+random(breite)-breite shr 2]:=power;

end;

begin
  power:=90;
  breite:=30;
  for i:=0 to 180 do
  begin
   tcos[i]:=cos(i*pi/180);
   tsin[i]:=sin(i*pi/180);
  end;
  Randomize;
  GetMem(Src_Frame,320*200);    {Speicher fÅr Quellbild holen und lîschen}
  FillChar(Src_Frame^,320*200,0);
  GetMem(Dest_Frame,320*200);   {Speicher fÅr Ziellbild holen und lîschen}
  FillChar(Dest_Frame^,320*200,0);
  asm
   mov ax,13h
   int 10h
  end;
  Prep_Pal;
  Repeat

    Scroll_Up;
    if keypressed then taste:=readkey else taste:='1';

    case taste of
    #75:richtung:=10;
    #77:richtung:=-10;
    '+': inc(breite);
    '-': dec(breite);
    #72:inc(power);
    #80:dec(power);
{    ' ':feuer;}
    end;
    feuer;

    if richtung<>0 then
    if richtung >0
    then
    begin inc(winkel); dec(richtung); end
    else
    begin dec(winkel); inc(richtung); end;

    Show_Screen;                {fertigen Bildschirm zeigen}




  Until taste=#27;
  TextMode(3);
end.
