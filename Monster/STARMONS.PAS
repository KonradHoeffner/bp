                {Palette:
                1=Weiá
                2-15=Grau (2=Hell 15=Dunkel)
                16=Gelb/Rot(hell)
                17-30=Blau(ab Palettenwert: 3*16=48 wegen 14 Blaustufen )
                31-62=Gelb 63-94=Rot}
uses crt,modexlib;
const          {15*10 Sprite}
 mspieler:array[0..149]of byte=(62,58,40,40,40,34, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                62,62,62,62,62,50,46,50,50, 0, 0, 0, 0, 0, 0,
                                62,62,53,62,62,62,62,62,62,62, 0, 0, 0, 0, 0,
                                62,62,58,58,58,58,58,58,62,62,62,62, 0, 0, 0,
                                62,56,58,58,58,58,30,30,30,57,56,62, 0, 0, 0,
                                43,57,53,58,58,58,30,28,28,30,57,57,62, 0, 0,
                                35,56,55,58,58,58,30,30,25,28,30,57,57,62, 0,
                                35,57,55,53,53,53,30,30,28,30,30,56,57,42, 0,
                                43,56,55,55,55,55,55,84,90,92,94,94,94,62,62,
                                62,60,58,56,54,52,50,50,50,50,52,56,58,60,62);




type screentype=array[0..199,0..319] of byte;

var sterne:array[0..500] of record
                              x,y,ebene:integer;
                            end;
    st_nr:Word;
    mgegner:array[0..149]of byte;
    screen1:^screentype;
    screen2:^screentype;
    taste:char;
    i,j,k:word;
    b:boolean;
    spieler       :record
                    x:word;
                    y:byte;
                    speedx,speedy:shortint;
                   end;

    gegner        :record
                    x:word;
                    y:byte;
                   end;

procedure feuer;
var r:byte;
begin
 with spieler do
 begin
  for i:=1 to 15 do begin
  r:=random(6);
  fillchar(screen1^[y+r+3,x+16],200,255);
  waitretrace;

  fillchar(screen1^[y+r+3,x+16],200,0);
  end;

 end;
end;

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

 fillchar(palette,768,0);
 for i:=1 to 15 do
 begin
  palette[i*3]:=(14-i)   shr 4;
  palette[i*3+1]:=(14-i) shr 4;
  palette[i*3+2]:=(14-i) shr 4;
 end;
 for i:=17 to 30 do palette[i*3+2]:=(i-14) shl 4;
 for i:=31 to 62 do
 begin
 palette[i*3]:=i-31 shr 5;
 palette[i*3+1]:=i-31 shr 5;
 end;
 for i:=63 to 94 do palette[i*3]:=(i-63) shl 3;
 for i:=128 to 255 do palette[i*3]:=i shr 2;
 setpal;
 getmem(screen1,64000);
 fillchar(screen1^,64000,0);
 getmem(screen2,64000);
 fillchar(screen2^,64000,0);

 screen2:=ptr($a000,0);

 randomize;
 spieler.x:=10;
 spieler.y:=10;
 spieler.speedx:=0;
 spieler.speedy:=0;

end;

begin
 init;
 repeat

     For St_nr:=0 to 500 do Begin
      With Sterne[st_nr] do Begin
        screen1^[y,x]:=0;
        Dec(x,Ebene shr 5 + 1);
        if x <= 0 Then Begin
          x:=319;
          y:=Random(200);
          Ebene:=Random(256);
        End;
        screen1^[y,x]:=Ebene shr 4 + 16;
      End;
    End;


{    72
  75    80
     80    }

 if keypressed then
 begin
  taste:=readkey;
  case taste of
   #72:if spieler.speedy>-122 then dec(spieler.speedy,1);
   #80:if spieler.speedy<122 then inc(spieler.speedy,1);
   #75:if spieler.speedx>-122 then dec(spieler.speedx,1);
   #77:if spieler.speedx<122 then inc(spieler.speedx,1);
   ' ':feuer;
  end;
 end;
 b:=not b;
  for i:=0 to 9 do fillchar(screen2^[spieler.y+i,spieler.x],15,0);

  if b=true then
  begin
   if spieler.speedx<>0 then begin
   inc(spieler.x,spieler.speedx);end;

   if spieler.speedy<>0 then begin
   inc(spieler.y,spieler.speedy); end;
  end;

  for i:=0 to 9 do move(mspieler[i*15],screen2^[spieler.y+i,spieler.x],15);
    waitretrace;





 {move(screen2^,screen1^,64000);}

 until taste=#27;
 textmode(3);
 end.