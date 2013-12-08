{Aufgabe 2 Konrad H”ffner 9/2}

uses crt;
const max_soldaten=50; {bis 255 erh”hbar}
type  richtung=(l,r);
var   anzahl,t,t2  :byte;
      soldaten        :array[1..max_soldaten] of richtung;
      zufall  :boolean;


procedure einlesen;
var fehler  :integer;
    zeichen :char;
    s       :string;
begin
 fehler:=0;
 repeat {Eingabe der Startbedingungen}
  clrscr;
  writeln('Seargeant Jackson''s Soldatenberechnungsprogramm');
  writeln;
  if fehler<>0 then writeln('Bitte geben sie eine positive Ganzzahl ein.');
  write('Anzahl der Soldaten (2-',max_soldaten,') : ');
  readln(s);
  val(s,anzahl,fehler);
 until  (anzahl in[2..max_soldaten]) and (fehler=0);
  write('Sollen die Startpositionen zuf„llig berechnet werden (J/N)? ');
  repeat
   zeichen:=readkey;
   zeichen:=upcase(zeichen);
   case zeichen of
    'J':zufall:=true;
    'N':zufall:=false;
   end;
  until zeichen in['J','N'];


 t:=1;

 if zufall then
 begin   {zuf„llige Eingabe}
  randomize;
  repeat
   if trunc(random(2))=1 then soldaten[t]:=l
                         else soldaten[t]:=r;
   inc(t);
  until t=anzahl;
 end
  else
   begin  {Einlesen der Anfangspositionen}
    writeln;
    write('Richtung (L/R): ');
    for t:=1 to anzahl do
    begin
     repeat
      zeichen:=readkey;
      zeichen:=upcase(zeichen);
      case zeichen of
      'L': soldaten[t]:=l;
      'R': soldaten[t]:=r;
      end;
     until zeichen in['L','R'];
    write(zeichen);
    end;
   end;
end;

procedure anzeige;
begin
  for t:=1 to anzahl do if soldaten[t]=l then write('L ')
                                         else write('R ');
end;

procedure ausrechnen;
 function fertig:boolean;
 begin
  fertig:=true;
  for t:=1 to anzahl-1 do if soldaten[t]<>soldaten[t+1] then fertig:=false;
 end;
 procedure dreh(nummer:byte);
 begin
  case soldaten[nummer] of
   l:soldaten[nummer]:=r;
   r:soldaten[nummer]:=l;
  end;
 end;
begin
 repeat
  if (soldaten[1]=r) and (soldaten[2]=l) then dreh(1);
  for t:=2 to anzahl-1 do
  if soldaten[t]=r then if soldaten[t+1]<>soldaten[t] then dreh(t);
  if soldaten[t]=l then if soldaten[t-1]<>soldaten[t] then dreh(t);
  if (soldaten[anzahl]=l) and (soldaten[anzahl-1]=r) then dreh(anzahl);
  anzeige;
 until fertig;
end;


begin
 einlesen;
 ausrechnen;

 clrscr;
 for t:=1 to anzahl do if soldaten[t]=l then write('L ')
                                        else write('R ');
readkey;
end.