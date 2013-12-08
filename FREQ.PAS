{$G+}
{Hallo Hannes, zu deiner Frage, wie man die Vertikal- und Horizontalfrequenz
errechnet, hier die Antwort:}
uses dos,crt;
Var
  t,h,h2,m,m2,s,s2,hs,hs2:word;{die Variablen, die die Zeit speichern}
  diff:real;{die absolute Differenz in Sekunden}

procedure waitretrace;
begin
{    !dieses Bit interessiert uns, wenn es 1 ist, kommt ein Retrace}
{00001000}
repeat until port[$3da] and $08=0;
repeat until port[$3da] and $08<>0;
end;

begin

  clrscr;
  asm{Modus 13h 320*200*256 Achtung:Fr den VGA ist es aber ein 320*400er
   Modus, da jede Zeile 2mal gerastert wird!!}
   mov ax,13h
   int 10h
  end;
{ Du kannst die obere Asm-Quelle auch rausl”schen oder die folgende verwenden:
(VESA 1.2)
  asm
   mov ax,04F02h {VESA 1.2}
{   mov bx,100h  } {100h = Modus 640*400*256;101h = Modus 640*480*256}
{   int 10h
  end;}

  gettime(h,m,s,hs); {Zeit 1}
  for t:=1 to 100 do waitretrace;
{  readkey;}
  gettime(h2,m2,s2,hs2);
  textmode(3);
  diff:=(h2-h)*3600+(m2-m)*60+(s2-s)+(hs2/100-hs/100);
  writeln('ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
  writeln('³Startzeit: ',h:2,':',m:2,':',s:2,':',hs:2,'           ³');
  writeln('³Endzeit  : ',h2:2,':',m2:2,':',s2:2,':',hs2:2,'           ³');
  writeln('³                                 ³');
  writeln('³Vergangene Zeit: ',diff:3:2,' Sekunden   ³');
  writeln('³',t:3,' Durchl„ufe der Schleife      ³');
  writeln('³',t/diff:3:2,'Hz : Vertikalfrequenz  ³');
  writeln('³',(t/diff*400/1000):3:2,'kHz Horizontalfrequenz   ³');
  writeln('ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');

  readln;
end.
