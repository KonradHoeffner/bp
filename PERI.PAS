uses crt;
const anz=40;{2*Elementanzahl}
type peri=array[1..anz] of string;
const
      a:array[1..anz shr 1] of byte=
      (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
      p:peri=('H','Wasserstoff',
              'He','Helium',
              'Li','Lithium',
              'Be','Beryllium',
              'B','Bor',
              'C','Kohlenstoff',
              'N','Stickstoff',
              'O','Sauerstoff',
              'F','Flour',
              'Ne','Neon',
              'Na','Natrium',
              'Mg','Magnesium',
              'Al','Aluminium',
              'Si','Silicium',
              'P','Phosphor',
              'S','Schwefel',
              'Cl','Chlor',
              'Ar','Argon',
              'K','Kalium',
              'Ca','Calcium');
var w,w2,fehler,eingabe3:word;
    eingabe,eingabe2:string;

procedure Symbol;
begin
 a[w]:=1;
 write('Das Element mit dem Symbol ',p[w*2-1],' hat den Namen: ');readln(Eingabe);
 write('und die Nummer: ');readln(Eingabe3);
 if eingabe=p[w*2] then writeln('Name richtig!') else begin writeln('Name falsch, ',(p[w*2])); inc(fehler) end;
 if eingabe3=w then writeln('Nummer richtig!') else begin writeln('Nummer falsch, ',w); inc(fehler) end;
end;

procedure Name;
begin
 a[w]:=1;
 write('Das Element mit dem Name ',p[w*2],' hat das Symbol: ');readln(Eingabe);
 write('und die Nummer: ');readln(Eingabe3);
 if eingabe=p[w*2-1] then writeln('Symbol richtig!') else begin writeln('Symbol falsch, ',(p[w*2-1])); inc(fehler) end;
 if eingabe3=w then writeln('Nummer richtig!') else begin writeln('Nummer falsch, ',w); inc(fehler) end;

end;

procedure Nummer;
begin
 a[w]:=1;
 write('Das Element mit der Nummer ',w,' hat den Namen: ');readln(Eingabe);
 write('und das Symbol: ');readln(Eingabe2);
 if eingabe=p[w*2] then writeln('Name richtig!') else begin writeln('Name falsch, ',(p[w*2])); inc(fehler) end;
 if eingabe2=p[w*2-1] then writeln('Symbol richtig!') else begin writeln('Symbol falsch, ',p[w*2-1]); inc(fehler) end;
end;

label start;
begin
fehler:=0;
randomize;
clrscr;
writeln('Chemietest - Das Periodensystem');
writeln('컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�');
writeln;
for w:=1 to anz shr 1 do a[w]:=0;
start:
repeat
w:=random(anz shr 1)+1;
until a[w]=0;
randomize; {Zufallsg. hat sonst Probleme}
w2:=random(3)+1;
case w2 of
1:Symbol;
2:Name;
3:Nummer;
end;
for w:=1 to anz shr 1 do if a[w]=0 then goto start;
writeln;
writeln('Du hast ',anz-fehler,' von ',anz,' Punkten erreicht.');
writeln;
write('Du hast die Note ');
textcolor(white+blink);
case round(((anz-fehler)/anz)*100) of
96..100:writeln('1! ');
81..97:writeln('2. ');
0..81:begin write('3');textcolor(lightgray);writeln(' oder schlechter! '); end;
end;
textcolor(lightgray);
readkey;
end.
