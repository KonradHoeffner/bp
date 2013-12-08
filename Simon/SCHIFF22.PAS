uses crt;

const maxmax = 250;
      max:byte=60;
      cleben = 5;
      speed=5;
      treffer=100;

var spieler,spieler2 : record
               x,y : byte;
               leben : byte;
               treff:byte;
               punkte:longint;
               name:string;
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
  writeln('Hallo, gib ma den Namen an ! :-)');
  write('Spieler1: ');
  readln(spieler.name);
  write('Spieler2: ');
  readln(spieler2.name);
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
 function endeda:boolean;
 begin
  endeda:=false;
 end;

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
   gotoxy(30,1);
   textcolor(white);
   write(spieler2.name,':  ',spieler2.punkte,'          ');
   write(spieler.name,':  ',spieler.punkte);
   textcolor(lightgray);
   end;
 procedure riesel;
 begin
  for t:=1 to max do with muell[t] do
  begin
   if y<25 then inc(y)
    else begin
          y:=1;
          x:=random(80)+1;
         end;
  end;
 end;
 procedure koli;
  begin
   for t:=1 to max do with muell[t] do
    begin
{--Spieler 1------------------------------------}
     if (spieler.x = x) and (spieler.y = y) then
      begin
       dec(spieler.leben);
       spieler.treff:=treffer;
       inc(spieler2.punkte);
       repeat
        spieler.x:=random(80)+1;
       until screen[spieler.y,spieler.x].zeich<>'±';
       spieler.y:=24;
      end;
{--Spieler 2------------------------------------}
     if (spieler2.x = x) and (spieler2.y = y) then
      begin
       dec(spieler2.leben);
       spieler2.treff:=treffer;
       inc(spieler.punkte);
       repeat
        spieler2.x:=random(80)+1;
       until screen[spieler2.y,spieler2.x].zeich<>'±';
       spieler2.y:=24;
      end;

    end;
  end;
 begin

  repeat
  inc(b);
  if b mod speed = 0 then riesel;
  Show;
  koli;
  tastfrag;
   until (taste=#27) or endeda;
 end;

procedure Ende;
 begin
  clrscr;
  gotoxy(1,1);
  write('Gewonnen hat ');
  if spieler.punkte>spieler2.punkte then
  writeln(spieler.name) else
  writeln(spieler2.name);

  writeln(spieler2.name,': ',spieler2.punkte);
  writeln(spieler.name,': ',spieler.punkte);

  readln;
 end;

begin
 Init;
 Haupt;
 Ende;

end.