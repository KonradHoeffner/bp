{$r-}
uses kcrt,dos,ktools;
const
 maxstern=500;  {Anzahl der Sterne}
 s1x=10;
 s1y=10;
 raum1:array[1..s1x,1..s1y] of byte=
 ((00,00,01,00,01,01,00,01,00,00),
  (00,00,01,01,01,01,01,01,00,00),
  (00,00,01,00,01,01,00,01,00,00),
  (00,01,00,00,01,01,00,00,01,00),
  (01,00,00,00,01,01,00,00,00,01),
  (01,00,00,00,01,01,00,00,00,01),
  (01,00,00,00,01,01,00,00,00,01),
  (01,00,00,00,01,01,00,00,00,01),
  (01,01,01,01,01,01,01,01,01,01),
  (01,00,00,00,00,00,00,00,00,01));
type screentype=array[0..199,0..319] of byte;

{ÄÄÄÄÄÄÄÄÄÄÄSterneÄÄÄÄÄÄÄ}
var sterne:array[0..maxstern] of record
                                  x,y,ebene:integer;
                                 end;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
    st_nr,t,i,x,y:Word;
    palette:array[0..767] of byte;
    screen1:^screentype;
    screen2:^screentype;
    spieler:      record
                    x:word;
                    e,y,live:byte;
                    speedx,speedy:shortint;
                    name:string;
                   end;
    taste:char;


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

procedure put;
begin
  for i:=0 to 9 do move(raum1[i*10],screen1^[spieler.y+i,spieler.x],10);
end;

begin
 asm
  mov ax,13h
  int 10h
 end;
 spieler.speedx:=0;
 spieler.speedy:=0;

 screen2:=ptr($a000,0);
 getmem(screen1,64000);
 fillchar(palette,768,0);
 for t:=15 to 33 do fillchar(palette[t*3],3,(t-15)*3);
 palette[3]:=255;
 setpal;
 For St_nr:=0 to maxstern do sterne[st_nr].y:=199;
 fillchar(screen2^,64000,0);
 fillchar(screen1^,64000,0);
 repeat
  if keypressed then
 begin
  taste:=readkey;
  case taste of
   #72:if spieler.speedy>-122 then dec(spieler.speedy,gesch1);
   #80:if spieler.speedy<122 then inc(spieler.speedy,gesch1);
   #75:if spieler.speedx>-122 then dec(spieler.speedx,gesch1);
   #77:if spieler.speedx<122 then inc(spieler.speedx,gesch1);

 end;
 end;
    if spieler.speedx<>0 then
   begin inc(spieler.x,spieler.speedx);
    if b mod brems=0 then if spieler.speedx>0 then dec(spieler.speedx) else inc(spieler.speedx);
   end;

 {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄSterneÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
      For St_nr:=0 to maxstern do Begin
      With Sterne[st_nr] do Begin
        screen1^[y,x]:=0;
        inc(y,Ebene shr 5 +1 );
        if y >199 Then Begin
          x:=random(319);
          y:=0;
          Ebene:=Random(256);
        End;
        screen1^[y,x]:=Ebene shr 4+16;
      End;
    End;
 put;
 {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
 screen2^:=screen1^;
 waitvret;

 until taste=#27;
 freemem(screen1,64000);
end.