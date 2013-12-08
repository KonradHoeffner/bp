{Von Meister Konrad und Page Simon
screen1^:array[0..199,0..319] of byte absolute $a000:0}
uses crt,_32bit,konrad;

type Stone = array[1..15,1..15] of byte;

const Stein : Stone=(
(26,26,26,26,26,26,26,26,26,26,26,26,26,26,23),
(26,23,23,23,23,23,23,23,23,23,23,23,23,23,20),
(26,23,23,23,23,23,23,23,23,23,23,23,23,23,20),
(26,23,23,23,23,23,23,23,23,23,23,23,23,23,20),
(26,23,23,23,23,23,23,23,23,23,23,23,23,23,20),
(26,23,23,23,23,23,23,23,23,23,23,23,23,23,20),
(26,23,23,23,23,23,23,23,23,23,23,23,23,23,20),
(26,23,23,23,23,23,23,23,23,23,23,23,23,23,20),
(26,23,23,23,23,23,23,23,23,23,23,23,23,23,20),
(26,23,23,23,23,23,23,23,23,23,23,23,23,23,20),
(26,23,23,23,23,23,23,23,23,23,23,23,23,23,20),
(26,23,23,23,23,23,23,23,23,23,23,23,23,23,20),
(26,23,23,23,23,23,23,23,23,23,23,23,23,23,20),
(26,23,23,23,23,23,23,23,23,23,23,23,23,23,20),
(23,20,20,20,20,20,20,20,20,20,20,20,20,20,20));

var t,t2     : integer;
    key      : char;
    Spieler1 : record
               x,y : integer;
               end;
    Steine   : record
               x,y : integer;
               end;
    old      : record
               x,y : integer;
               end;
    screen1:^screen_type;
    temp:pointer;
const canz=70;
      zeit=500;

type Trichtung = (Links,Rechts,Oben,Unten);

var feld:array[1..canz] of record
                           x,y : integer;
                           Richtung : set of Trichtung;
                           end;

    anz:integer;

procedure Putpixel(x,y:integer; farbe:byte);
 begin
  mem[$a000:320*y+x]:=farbe;
 end;

procedure los;
 procedure Prichtung;
  begin
   if Spieler1.x > Old.x then feld[anz].Richtung:=[Links];
   if Spieler1.x < Old.x then feld[anz].Richtung:=[Rechts];
   if Spieler1.y > Old.y then feld[anz].Richtung:=[Oben];
   if Spieler1.y < Old.y then feld[anz].Richtung:=[Unten];
  end;
begin
 if anz<canz then
 begin
  inc(anz);
 end;
end;

procedure Schuss;
 begin
  putpixel(feld[anz].x,feld[anz].y,15);
  if feld[anz].Richtung=[Links]  then inc(feld[anz].x);
  if feld[anz].Richtung=[Rechts] then dec(feld[anz].x);
  if feld[anz].Richtung=[Oben]   then inc(feld[anz].y);
  if feld[anz].Richtung=[Unten]  then dec(feld[anz].y);
 end;

procedure raus(anz:byte);
var t:word;
    r:byte;
    dummy:integer;
begin
 r:=anz;
 move(feld[r+1],feld[r],canz-r);
 dec(anz);
end;

procedure Init13h;assembler;
 asm
  mov ax,13h
  int 10h
 end;

procedure PaintSteine(x,y:integer; sp:Stone);
var x1,y1 : integer;
 begin
   for y1:=1 to 15 do
    move(sp[y1,1],screen1^[y+y1,x],15);
 end;

procedure Stones;
var t2,x,y:integer;
 begin
  Steine.x:=1; Steine.y:=1;
  for t:=0 to 10 do
   for t2:=0 to 5 do PaintSteine(Steine.x+t*30,Steine.y+t2*30,Stein);
 end;


begin
anz:=0;

getmem(screen1,64000);
filllongint(screen1^,16000,0);
Init13h;
Spieler1.x:=16;
Spieler1.y:=16;
 repeat
  Stones;{Steine werden gemalt}

  if keypressed then key:=readkey else key:='n';
  case key of
  #77 : inc(Spieler1.x,15);
  #75 : dec(Spieler1.x,15);
  #80 : inc(Spieler1.y,15);
  #72 : dec(Spieler1.y,15);
  ' ' : los;
  end;

  for t:=0 to 10 do
   for t2:=0 to 5 do




    begin
     if (Spieler1.x+7 < Steine.x+22+t *30) and
        (Spieler1.x+7 > Steine.x-8 +t *30) and
        (Spieler1.y+7 < Steine.y+22+t2*30) and
        (Spieler1.y+7 > Steine.y-8 +t2*30) then
         begin
          Spieler1.x:=Old.x;
          Spieler1.y:=Old.y;
         end;
     end;
  PaintSteine(Spieler1.x,Spieler1.y,Stein);

{    waitretrace;}
    movelongint(screen1^,screen,16000);
    filllongint(screen1^,16000,0);

    los;
    schuss;
  if keypressed then
   begin
    Old.x:=Spieler1.x;
    Old.y:=Spieler1.y;
   end;
   until key = #27;
 freemem(screen1,64000);
end.