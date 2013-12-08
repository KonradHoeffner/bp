uses crt;

type tscore=record
             name:string[15];
             score:word;
            end;
     thiscore=array[1..10] of tscore;
const maxmax = 255;
      max:byte=20;
      cleben = 15;
      speed=8;
      treffer=100;
      path='c:\eigene~1\bp\simon\';

var spieler : record
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
    test2   : integer;
    taste:char;
    screen:array[1..25,1..80] of record
                                  zeich:char;
                                  farbe:byte;
                                 end absolute $b800:0;
   scorefile:file of thiscore;
   hiscore:thiscore;

function exist(s:string):boolean;
begin
 {$I-}
 assign(scorefile,s);
 reset(scorefile);
 if ioresult=0 then exist:=true else exist:=false;
 close(scorefile);

 {$I+}

end;

procedure anlegen;
begin
 assign(scorefile,path+'spiel.txt');
 rewrite(scorefile);
 for t:=1 to 10
 do with hiscore[t] do
 begin
  if random(2)=1 then name:='Konrad H.' else name:='Simon T.';
  score:=((10-t+1)*1000);
 end;
 write(scorefile,hiscore);
 close(scorefile);
end;

procedure scorezeig;
begin
 writeln('HISCORES ',#2);
 writeln('컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴');
 writeln;
 write(' 1. ');
 textcolor(white+blink);
 writeln(hiscore[1].name,'      : ',hiscore[1].score);
 writeln;
 textcolor(lightgray);
 for t:=2 to 10 do with hiscore[t] do
 begin
  gotoxy(1,t+3);
  if t< 10 then write(' ',t,'. ',name) else write(t,'. ',name);
  gotoxy(20,t+3);
  writeln(':  ',score);
 end;

end;

procedure Init;
 begin
  inc(windmax);
  clrscr;
  randomize;
  spieler.punkte:=0;
  spieler.leben:=cleben;
  spieler.x:=40; spieler.y:=24;
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
   for t:=1 to max do screen[muell[t].y,muell[t].x].zeich:='�';
   screen[spieler.y,spieler.x].zeich:='';
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
       until screen[spieler.y,spieler.x].zeich<>'�';
       spieler.y:=24;
      end;
    end;
  end;
 begin
  repeat
  inc(b);
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
  if not exist(path+'spiel.txt') then anlegen else
  begin
  assign(scorefile,path+'Spiel.txt');
  reset(scorefile);
  read(scorefile,hiscore);
  scorezeig;
  readkey;
  close(scorefile);
  end;
{   if spieler.punkte > test2 then
    begin
     assign(scorefile,path+'Spiel.txt');
     rewrite(scorefile);}

{     write(scorefile,spieler.punkte);}
{     close(scorefile);}
{    end;}
 end;

begin
 Init;
 Haupt;
 Ende;

end.