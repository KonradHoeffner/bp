uses konrad;

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

begin
 asm
  mov ax,13h
  int 10h
 end;
 prep_pal;
 writepal('flammen.pal');
 asm
  mov ax,3
  int 10h
 end;
end.