                 {Palette:
                1-16=Grau (2=Hell 15=Dunkel 16=weiá)
                16=Gelb/Rot(hell)
                17-30=Blau(ab Palettenwert: 3*16=48 wegen 14 Blaustufen )
                31-62=Gelb 63-94=Rot}
uses crt,modexlib;

type screentype=array[0..199,0..319] of byte;

{SterneÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
var
    sterne:array[0..500] of record
                              x,y,ebene:integer;
                            end;
    st_nr:Word;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
    mgegner:array[0..149]of byte;

    screen2:screentype absolute $a000:0;
    taste:char;
    i,j,k:word;
    b:byte;
procedure init;

begin
 asm
    mov ax,13h
    int 10h
 end;

{Palette:
                1=Weiá
                2-15=Grau (2=Hell 15=Dunkel)
                16=Gelb/Rot(hell)
                17-30=Blau(ab Palettenwert: 3*16=48 wegen 14 Blaustufen )
                31-62=Gelb 63-94=Rot
                128-255 Flammen (Rot-Gelb)}




 randomize;

end;

begin
 init;
 repeat
 {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄSterneÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
      For St_nr:=0 to 500 do Begin
      With Sterne[st_nr] do Begin
        screen2[y,x]:=0;
        Dec(x,1);
        if x <= 0 Then Begin
          x:=random(320);
          y:=Random(200);
        End;
        screen2[y,x]:=15 ;
      End;
    End;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}


{    72
  75    80
     80    }

  waitretrace;



 if keypressed then taste:=readkey;

 {move(screen2^,screen1^,64000);}

 until taste=#27;
 textmode(3);
 end.