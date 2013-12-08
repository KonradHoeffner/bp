uses crt;

const maxmax = 250;
      max:byte=20;
      cleben = 5;
      speed=3;
      treffer=100;

var spieler,spieler2 : record
               x,y : byte;
               leben : byte;
               treff:byte;
               punkte:longint;
              end;
    muell   : array[1..maxmax] of record
                               x,y : byte;
                               end;
    herzen  : record
              x,y : byte;
              end;
    t,u     : word;
    taste:char;
    screen:array[1..25,1..80] of record
                                  zeich:char;
                                  farbe:byte;
                                 end absolute $b800:0;

procedure Init;
 begin
  inc(windmax);
  clrscr;
  spieler.punkte:=0;
  spieler.leben:=cleben;
  spieler.x:=60; spieler.y:=24;
  spieler2.leben:=cleben;
  spieler2.x:=20; spieler2.y:=24;
  randomize;
  for t:=1 to max do with muell[t] do
   begin
    x:=random(80)+1;
    y:=random(25)+1;
   end;
 end;

procedure tastfrag;
begin
 if keypressed then taste:=readkey else taste:='n';
 with spieler do
 case taste of
  #77 : inc(x);
  #75 : dec(x);
  #80 : inc(y);
  #72 : dec(y);
  end;

 with spieler2 do
 case taste of
   'f': inc(x);
   's': dec(x);
   'd': inc(y);
   'e': dec(y);
  end;


end;

procedure waitretrace;
 begin
  repeat
  until (port[$3da]) and ($08) <> 0;
  repeat
  until (port[$3da]) and ($08)  = 0;
 end;

procedure Haupt;
var b:byte;
 procedure Show;
  begin
   waitretrace;
   clrscr;
   for t:=1 to max do screen[muell[t].y,muell[t].x].zeich:='±';
   screen[spieler.y,spieler.x].zeich:=#2;
   screen[spieler2.y,spieler2.x].zeich:=#1;
   if spieler.treff>0 then
   begin
    dec(spieler.treff);
    screen[spieler.y,spieler.x].farbe:=blink+yellow;
   end;
   gotoxy(1,1);
   textcolor(red);
   for t:=1 to spieler.leben do
   write(#3);
   gotoxy(60,1);
   textcolor(lightgray);
   write('Punkte: ');
   textcolor(white);
   write(spieler.punkte);
  end;
 procedure riesel;
 begin
  for t:=1 to max do with muell[t] do
  begin
   if y<25 then inc(y)
    else begin
          y:=2;
          x:=random(80)+1;
         end;
  end;
 end;
 procedure koli;
  begin
   for t:=1 to max do with muell[t] do
    begin
     if (spieler.x = x) and (spieler.y = y) then
      begin
       dec(spieler.leben);
       spieler.treff:=treffer;
       repeat
        spieler.x:=random(80)+1;
       until screen[spieler.y,spieler.x].zeich<>'±';
       spieler.y:=24;
      end;
    end;
  end;
 begin
  repeat
  if b mod speed = 0 then riesel;
  inc(spieler.punkte);
  Show;
  koli;
  tastfrag;
   until (taste=#27) or (spieler.leben=0);
 end;

procedure Ende;
 begin
  clrscr;
  gotoxy(1,1);
  write('Spielerpunkte: ',spieler.punkte);
  readln;
 end;

begin
 Init;
 Haupt;
 Ende;

end.