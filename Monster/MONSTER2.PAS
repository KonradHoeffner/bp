                {Palette:
                1-16=Grau (2=Hell 15=Dunkel 16=weiá)
                16=Gelb/Rot(hell)
                17-30=Blau(ab Palettenwert: 3*16=48 wegen 14 Blaustufen )
                31-62=Gelb 63-94=Rot}
uses crt,modexlib,dos;
const          {15*10 Sprite}
 mspieler:array[0..149]of byte=(62,58,40,40,40,34, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                62,62,62,62,62,50,46,50,50, 0, 0, 0, 0, 0, 0,
                                62,62,53,62,62,62,62,62,62,62, 0, 0, 0, 0, 0,
                                62,62,58,58,58,58,58,58,62,62,62,62, 0, 0, 0,
                                62,56,58,58,58,58,20,20,20,57,56,62, 0, 0, 0,
                                43,57,53,58,58,58,20,24,25,20,57,57,62, 0, 0,
                                35,56,55,58,58,58,20,24,24,24,20,57,57,62, 0,
                                35,57,55,53,53,53,20,20,20,20,20,56,57,42, 0,
                                43,56,55,55,55,55,55,84,90,92,94,94,94,62,62,
                                62,60,58,56,54,52,50,50,50,50,52,56,58,60,62);




type screentype=array[0..199,0..319] of byte;

{ÄÄÄÄÄÄÄÄÄÄÄSterneÄÄÄÄÄÄÄ}
var sterne:array[0..500] of record
                              x,y,ebene:integer;
                            end;
    st_nr:Word;
{ÄÄÄÄÄÄÄÄInterruptÄÄÄÄÄÄÄ}
    saveint8:pointer;
    mode:byte absolute $0000:$0449;
    {Videomodus}
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

    mgegner:array[0..149]of byte;
    screen1:^screentype;
    screen2:^screentype;
    s:string;
    taste:char;
    i,j,k,x:word;
    r,b,feuer,e:byte;

    spieler       :record
                    x:word;
                    y:byte;
                    speedx,speedy:shortint;
                   end;


    gegner        :record
                    x:word;
                    y:byte;
                   end;


procedure checkscreen; interrupt;
   var i: Word;
begin
  inline($9C/$FF/$1E/saveint8);
  if feuer>0 then
  begin
   fillchar(screen2^[r,x],200,0);
   fillchar(screen2^[r+2,x],200,0);
  end;
  r:=random(6)+3+spieler.y;
  x:=spieler.x+15;
  if feuer>1 then
  begin
   fillchar(screen2^[r,x],200,255);
   fillchar(screen2^[r+2,x],200,255);
  end;
  if e<255 then inc(e);
end;


procedure init;


begin
 getintvec(8,saveint8);
 setintvec(8,addr(checkscreen));
 {Interrupt verbiegen}
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


 e:=255;
 fillchar(palette,768,0);
 for i:=1 to 16 do
 begin
  palette[i*3]:=i shl 4-1;
  palette[i*3+1]:=i shl 4-1;
  palette[i*3+2]:=i shl 4-1;
 end;
 for i:=17 to 30 do palette[i*3+2]:=(i-14) shl 4-1;
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
 gegner.x:=50;
 gegner.y:=50;
end;

begin
 init;
 repeat
                        waitretrace;

 {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄSterneÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
      For St_nr:=0 to 500 do Begin
      With Sterne[st_nr] do Begin
        screen2^[y,x]:=0;
        Dec(x,Ebene shr 5 + 1);
        if x <= 0 Then Begin
          x:=319;
          y:=Random(199);
          Ebene:=Random(256);
        End;
        screen2^[y,x]:=Ebene shr 4 ;
      End;
    End;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}


{    72
  75    80
     80    }
  fillchar(screen2^[199,e],320,0);
 fillchar(screen2^[199,0],trunc(e / 255*320),128+(e+1) shr 2);

 if keypressed then
 begin
  taste:=readkey;
  case taste of
   #72:if spieler.speedy>-122 then dec(spieler.speedy,3);
   #80:if spieler.speedy<122 then inc(spieler.speedy,3);
   #75:if spieler.speedx>-122 then dec(spieler.speedx,3);
   #77:if spieler.speedx<122 then inc(spieler.speedx,3);
   ' ':if e>15 then begin  e:=e-10; feuer:=15 end;
  end;
 end;
 inc(b);

 if feuer>0 then dec(feuer);
   for i:=0 to 9 do fillchar(screen2^[spieler.y+i,spieler.x],15,0);

   if spieler.speedx<>0 then
   begin inc(spieler.x,spieler.speedx);
   if b mod 5=0 then if spieler.speedx>0 then dec(spieler.speedx) else inc(spieler.speedx);
   end;

   if spieler.speedy<>0 then
   begin inc(spieler.y,spieler.speedy);
   if b mod 5=0 then if spieler.speedy>0 then dec(spieler.speedy) else inc(spieler.speedy);
   end;

  for i:=0 to 9 do move(mspieler[i*15],screen2^[spieler.y+i,spieler.x],15);



{ if (spieler.x >319) or (spieler.y>198) then taste:=#27;}
 until taste=#27;
 textmode(3);

 end.