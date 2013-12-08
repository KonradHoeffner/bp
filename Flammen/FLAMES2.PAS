uses modexlib;
var i:byte;
procedure line;
begin
for i:=1 to 150 do mem[$a000:62720+random(960)]:=255;
end;

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
End;

begin
  Randomize;
  Prep_Pal;
  asm
   mov ax,13h
   int 10h
   call setpal
   mov ax,0a000h
   mov es,ax
  @schleife1:
   mov cx,160*3
   mov ax,1515h
   mov di,320*196
   rep stosw
   call line
   xor di,di
   xor ax,ax
   xor bx,bx
   mov cx,64000
  @Schleife:
   mov al,es:[di]
   mov bl,es:[di+319]
   add ax,bx
   mov bl,es:[di+320]
   add ax,bx
   mov bl,es:[di+321]
   add ax,bx
   shr ax,2
   mov es:[di],al
   inc di
   loop @schleife
   mov ah,1
   int 16h
   je @schleife1 {zf=0 -> Taste gedrckt}

  end;


  end.
