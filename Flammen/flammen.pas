{$G+}
uses dos;
Type Block=Array[0..199,0..319] of Byte;
Var
  Src_Frame,                    {vorheriges Bild}
  Dest_Frame:^Block;            {aktuelles Bild}
  palette:array[0..767] of byte;
  t,h,h2,m,m2,s,s2,hs,hs2:word;
  diff:real;
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

procedure waitretrace;
begin
repeat until port[$3da] and $08=0;
repeat until port[$3da] and $08<>0;
end;

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
  shr ax,1
  shr ax,1

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

Procedure New_Line;             {baut die untersten Zeilen neu auf}
Var i,x:Word;
Begin
  For x:=0 to 319 do Begin      {untere 3 Zeilen mit zuf„lligen Werten fllen}
    Dest_Frame^[197,x]:=Random(15)+64;
    Dest_Frame^[198,x]:=Random(15)+64;
    Dest_Frame^[199,x]:=Random(15)+64;
  End;
  For i:=0 to Random(45) do Begin {zuf. Anzahl Hotspots einfgen}
    x:=Random(320);             {an zuf„llige Koordinaten}
    asm
      les di,Dest_Frame         {Zielbild adressieren}
      add di,198*320             {Zeile 98 (zweitunterste) bearbeiten}
      add di,x                  {x-Koordinate dazu}
      mov al,0ffh               {hellste Farbe}
      mov es:[di-321],al        {groáen Hotspot erzeugen (9 Punkte)}
      mov es:[di-320],al
      mov es:[di-319],al
      mov es:[di-1],al
      mov es:[di],al
      mov es:[di+1],al
      mov es:[di+319],al
      mov es:[di+320],al
      mov es:[di+321],al
    End;
  End;
End;

Procedure Show_Screen;          {kopiert fertigen Bilschirm auf VGA}
Var temp:Pointer;               {zum Tauschen der Zeiger}
Begin
asm
  push ds
  lds si,Dest_Frame             {fertiges Bild als Quelle}
  mov ax,0a000h                 {VGA als Ziel}
  mov es,ax
{  mov di,320*100}                {ab Zeile 100}
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

begin
  Randomize;                    {Random Seed bestimmen}
  GetMem(Src_Frame,320*200);    {Speicher fr Quellbild holen und l”schen}
  FillChar(Src_Frame^,320*200,0);
  GetMem(Dest_Frame,320*200);   {Speicher fr Ziellbild holen und l”schen}
  FillChar(Dest_Frame^,320*200,0);
  asm
   mov ax,13h
   int 10h
  end;
  Prep_Pal;                     {Palette vorbereiten}
  gettime(h,m,s,hs);
  t:=0;
   asm
   @repeat:
    call Scroll_Up
    call New_Line
    call Show_Screen
{    call waitretrace}
    inc t
    mov ah,1
    int 16h
   jz @repeat
    mov ax,3
    int 10h
   end;
  gettime(h2,m2,s2,hs2);
  diff:=(h2-h)*3600+(m2-m)*60+(s2-s)+(hs2/100-hs/100);
  writeln('ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
  writeln('³Startzeit: ',h:2,':',m:2,':',s:2,':',hs:2,'           ³');
  writeln('³Endzeit  : ',h2:2,':',m2:2,':',s2:2,':',hs2:2,'           ³');
  writeln('³                                 ³');
  writeln('³Vergangene Zeit: ',diff:3:2,' Sekunden   ³');
  writeln('³',t:3,' Durchl„ufe der Schleife      ³');
  writeln('³',t/diff:3:2,' Frames/Sekunde            ³');
  writeln('ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
  readln;
end.
