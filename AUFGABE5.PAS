{Aufgabe 4}
uses crt;
const laenge=20; {maximale Seitenl꼗ge des Quadrates}
var s:string;
    a:byte;
    taste:char;
    quadrat_n_s,quadrat_w_o,regen:array[-laenge..laenge,-laenge..laenge] of boolean;
    x,y:shortint; {Koordinaten x=Spalte y=Zeile}

procedure eingabe;
var t:byte;
    f:integer; {Fehlercode beim Umwandeln String->Zahl}
begin
 writeln('Das Wetter in Quadratien');
 writeln('컴컴컴컴컴컴컴컴컴컴컴컴');
 repeat
  writeln;
  write('Seitenl꼗ge(1..',laenge,'): ');
  readln(s);
  val(s,a,f);
  if f <> 0 then writeln('Bitte eine Zahl zwischen 1 und 20 eingeben!');
 until f=0; {Bis Fehlercode=0 (korrekte Zahl eingegeben)}

 t:=1;
 fillchar(quadrat_n_s,sqr(2*laenge+1),false);
 fillchar(quadrat_w_o,sqr(2*laenge+1),false);
 fillchar(regen      ,sqr(laenge),false);

 repeat
  write('Wolke',t,'-Zeile:(0=fertig) ');


  readln(y);
  if y=0 then break; {Abbrechen, wenn y=0}
  if y>a then
  begin
   writeln('Ung걄tige Eingabe'); {Wenn Wolke unterhalb Quadratien}
  end;
  write('Wolke',t,'-Spalte: ');
  readln(x);
  inc(t);
  if y<0 then quadrat_n_s[x,y]:=true {wenn Wolke oberhalb->nach S갺en}
         else quadrat_w_o[x,y]:=true;{sonst (links davon)->nach Osten}
 until x=0;

end; {Eingabe}

procedure berechnung;
var t,i,j:integer;
begin
 for t:=1 to laenge do {Nach laenge* ist jede Wolke sicher aus dem Quadrat verschwunden}
 begin
  for x:=1 to a do for y:=1 to a do
  begin
   if (quadrat_w_o[x,y]) and (quadrat_n_s[x,y]) then
   begin
    quadrat_w_o[x,y]:=false;
    quadrat_n_s[x,y]:=false;
    regen[x,y]:=true;
   end;
  end;
           {Vorr갷ken der Nord->S갺-Wolken um 2 Felder}
  for x:=-laenge to laenge do for y:=laenge downto -laenge+2 do
   quadrat_n_s[x,y]:=quadrat_n_s[x,y-2];

  fillchar(quadrat_n_s,(2*laenge+1)*2,0);           {obere 2 Zeilen leeren}

           {Vorr갷ken der West->Ost-Wolken um 3 Felder}
  for y:=-laenge to laenge do for x:=laenge downto -laenge+3 do
   quadrat_w_o[x,y]:=quadrat_w_o[x-3,y];
    for i:=1 to 2*laenge+1 do fillchar(quadrat_w_o[-laenge,i],3,0);{linke 3 Spalten leeren}

 end;
end; {Berechnung}

procedure ausgabe;
begin
 clrscr;
 write('Es wird regnen an den Stellen: ');
 for x:=1 to a do for y:=1 to a do
  if regen[x,y] then write(y,',',x,' ');
 readkey;
end;

begin
 clrscr;
 eingabe;
 berechnung;
 ausgabe;
end.
