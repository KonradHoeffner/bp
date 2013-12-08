uses crt,modexlib,dos;
const maxbomb=10;
      bomb:array[0..15*15-1]of byte=(0 ,0 ,0 ,00,00,00,00,99,0 ,0 ,0 ,0 ,0 ,0 ,0 ,
                                     0 ,00,00,0 ,0 ,99,99,99,99,99,99,0 ,00,0 ,0 ,
                                     0 ,0 ,0 ,0 ,99,20,20,30,20,20,20,99,0 ,00,0 ,
                                     0 ,0 ,0 ,99,20,20,20,30,20,20,20,00,99,00,0 ,
                                     0 ,0 ,99,20,20,20,99,30,99,20,20,20,20,99,0 ,
                                     0 ,99,20,20,20,30,99,50,99,30,20,20,20,99,0 ,
                                     0 ,99,20,20,20,99,99,99,99,99,20,20,20,99,0 ,
                                     99,99,30,50,99,99,99,99,99,99,50,30,99,99,99,
                                     0 ,0 ,99,20,20,99,99,50,99,99,20,20,20,99,00,
                                     0 ,0 ,0 ,99,20,30,99,30,99,30,20,20,99,20,00,
                                     0 ,0 ,0 ,99,99,20,20,30,20,20,20,99,20,00,0 ,
                                     0 ,0 ,0 ,0 ,99,20,20,30,20,20,99,0 ,0 ,0 ,0 ,
                                     0 ,0 ,0 ,0 ,99,20,20,30,20,99,0 ,0 ,0 ,0 ,0 ,
                                     0 ,0 ,0 ,0 ,0 ,99,99,99,99,0 ,0 ,0 ,0 ,0 ,0 ,
                                     0 ,0 ,0 ,0 ,0 ,0 ,0 ,99,0 ,0 ,0 ,0 ,0 ,0 ,0 );





type screentype=array[0..199,0..319] of byte;
var
    screen1,screen2:^screentype;
    taste:char;
    i,j,x,y:word;
    bombe:array[1..maxbomb] of record
                               x,y:word;
                               count:byte;
                               end;

procedure init;
begin
  for i:=0 to 14 do
  for j:=0 to 14 do
  bomb[i*15+j]:=bomb[i*15+j] shl 2;


 asm
    mov ax,13h
    int 10h
 end;

 fillchar(palette,768,0);
   For i:=0 to 7 do Begin
    Palette[i*3+2]:=i*2;
    Palette[(i+8)*3+2]:=16-i*2;
  End;
  For i:=8 to 31 do
      Palette[i*3]:=(i-8)*63 div 23;
  For i:=32 to 55 do Begin
    Palette[i*3]:=63;
    Palette[i*3+1]:=(i-32)*63 div 23;
  End;
  For i:=56 to 79 do Begin
    Palette[i*3]:=63;
    Palette[i*3+1]:=63;
    Palette[i*3+2]:=(i-56)*63 div 23;
  End;
  FillChar(Palette[80*3],176*3,63);

 setpal;
 getmem(screen1,64000);
 fillchar(screen1^,64000,0);
 getmem(screen2,64000);
 fillchar(screen2^,64000,0);

 screen1:=ptr($a000,0);



 randomize;
end;

begin
 init;
 repeat
 x:=random(320);
 y:=random(180);
 for i:=0 to 14 do move(bomb[i*15],screen1^[y+i,x],15);
 until keypressed;
end.