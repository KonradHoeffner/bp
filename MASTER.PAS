program master;
uses crt;
var z,s,p,f,v,x,y,aa,bb,cc,dd,a,b,c,d,zz,code,i :integer;
    taste                                       :char;

procedure Gitter(sl,zo,sr,zu:integer);
var   i,j:integer;
begin
{Ecken}
     gotoxy(sl,zo);write('Ú');
     gotoxy(sr,zo);write('¿');
     gotoxy(sl,zu);write('À');
     gotoxy(sr,zu);write('Ù');
{obere Kreuze}
    for i:=1 to (sr-sl) div 4 -1 do begin
        gotoxy(i*4+sl,zo);write('Â');
    end;
{untere Kreuze}
    for i:=1 to (sr-sl) div 4 -1 do begin
        gotoxy(i*4+sl,zu);write('Á');
    end;
{innere Kreuze}
    for j:=1 to (zu-zo) div 2 -1 do begin
        for i:=0 to (sr-sl) div 4 -1 do begin
        gotoxy(i*4+sl,zo+j*2);write('Å');
    end;
end;
{Waagerechte}
    for j:=0 to (zu-zo) div 2 do begin
        for i:=0 to (sr-sl) div 4 -1 do begin
        gotoxy(i*4+sl+1,zo+j*2);write('ÄÄÄ');
    end;
end;
{innere Senkrechte}
    for j:=0 to (sr-sl) div 4 do begin
        for i:=1 to (zu-zo) div 2 do begin
        gotoxy(j*4+sl,zo+i*2-1);write('³');
    end;
end;
{linke Senkrechte}
    for i:=1 to (zu-zo) div 2 -1 do begin
        gotoxy(sl,i*2+zo);write('Ã');
    end;
{rechte Senkrechte}
    for i:=1 to (zu-zo) div 2 -1 do begin
        gotoxy(sr,i*2+zo);write('´');
    end;
end;

procedure zufall;
begin
     randomize;
     zz:=random(6);
     zz:=zz+1;
end;

begin
     v:=0;
     clrscr;
     writeln('Programm Master');
     writeln;writeln;writeln;
     writeln('Errate,welche der Ziffern von 1 bis 6 auf welcher Position');
     writeln('stehen. Jede Ziffer darf nur einmal vorkommen.');
     writeln;
     writeln('Viel Spaá bei diesem logischen Spiel!');
     readln;
     clrscr;
     gotoxy(1,1);
     writeln('Programm  ... Master - Mind  ...  Superhirn  ....');
     gitter(1,3,17,23);
     zufall;a:=zz;
     repeat zufall; b:=zz until (b<>a);
     repeat zufall; c:=zz until (c<>a) and (c<>b);
     repeat zufall; d:=zz until (d<>a) and (d<>b) and (d<>c);
     repeat
           p:=0;f:=0;
           v:=V+1;
           y:=2*v+2; x:=3;
           gotoxy(x,y);
           repeat
                 taste:=readkey;
                 val(taste, aa, code);
           until (aa>=1) and (aa<=6);
           write(aa);
           sound(262); delay(100); nosound;
           gotoxy(x+4,y);
           repeat
                 taste:=readkey;
                 val(taste, bb, code);
           until (bb>=1) and (bb<=6) and (bb<>aa);
           write(bb);
           sound(330); delay(100); nosound;
           gotoxy(x+8,y);
           repeat
                 taste:=readkey;
                 val(taste, cc, code);
           until (cc>=1) and (cc<=6) and (bb<>aa);
           write(cc);
           sound(392); delay(100); nosound;
           gotoxy(x+12,y);

          repeat
                taste:=readkey;
                val(taste, dd, code);
          until (dd>=1) and (dd<=6) and (dd<>aa) and (dd<>bb) and (dd<>cc);
          write(dd);
          sound(523); delay(100); nosound;
          if aa=a then p:=p+1;
          if bb=b then p:=p+1;
          if cc=c then p:=p+1;
          if dd=d then p:=p+1;
          if (aa=a) or (bb=a) or (cc=a) or (dd=a) then f:=f+1;
          if (aa=b) or (bb=b) or (cc=b) or (dd=b) then f:=f+1;
          if (aa=c) or (bb=c) or (cc=c) or (dd=c) then f:=f+1;
          if (aa=d) or (bb=d) or (cc=d) or (dd=d) then f:=f+1;
          gotoxy(22,y);
          writeln(f,' Zahlen richtig, davon ',p,' Positionen.');
    until (p=4) or (v=10);
    if p=4 then begin
       gotoxy(1,24);
       writeln('Gratuliere! Du hast es nach ',v,' Versuchen geschafft.');
    end;
    if (v=10) and (p<>4) then begin
       gotoxy (1,24);
       writeln('Schade, nach 10 Versuchen nicht geschafft.');
    end;
    writeln('Die L”sung lautet: ',a,' ',b,' ',c,' ',d,'.');
    readln;
end.