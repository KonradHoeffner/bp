{Konrad Hîffner 1999}
{$R-} {BereichsÅberprÅfung fÅr dynamischen Array ausschalten}
uses crt,_13h;
const feld_breite=320;
      feld_hoehe=200;
      weiss=15;
      schwarz=0;
type ttfeld=array[0..feld_hoehe-1,0..feld_breite-1] of byte; {}
     tfeld=^ttfeld;
var fax,folie,nachricht,ergebnis:tfeld;
    t,x,y:word;{Laufvariablen}
    screen:array[0..199,0..319] of byte absolute $a000:0;
procedure erstelle_folie(var ziel:tfeld;breite,hoehe:word);
var x,y:word;
begin
 for y:=0 to hoehe-1 do
  if (y mod 2)=0 then
 begin
  for x:=0 to breite-1 do if (x mod 2)=0
   then
    ziel^[y,x]:=random(2)
   else
    ziel^[y,x]:=ziel^[y,x-1] xor 1;
    ziel^[y,x]:=1;
 end else
  for x:=0 to breite-1 do ziel^[y,x]:=ziel^[y-1,x] xor 1;
end;

procedure init;
begin
 clrscr;
 init13h;
 getmem(folie,feld_breite*feld_hoehe);
 getmem(fax,feld_breite*feld_hoehe);
 getmem(nachricht,feld_breite*feld_hoehe);
 getmem(ergebnis,feld_breite*feld_hoehe);
 fillchar(folie^,feld_breite*feld_hoehe,weiss);
 fillchar(fax^,feld_breite*feld_hoehe,weiss);
 fillchar(nachricht^,feld_breite*feld_hoehe,weiss);
 randomize;
end;

procedure final;
begin
 freemem(folie,feld_breite*feld_hoehe);
 freemem(fax,feld_breite*feld_hoehe);
 freemem(nachricht,feld_breite*feld_hoehe);
 freemem(ergebnis,feld_breite*feld_hoehe);
 textmode(3);
end;

procedure show(var quelle:tfeld);
begin
 for x:=0 to feld_breite-1 do for y:=0 to feld_hoehe-1 do
 begin
  if quelle^[y,x]=1 then screen[y,x]:=weiss else screen[y,x]:=schwarz;
 end;
end;

procedure erstelle_nachricht;
var s:string;
begin
 for y:=50 to 110 do fillchar(nachricht^[y,20],60,schwarz);
 s:='Dies ist ein verschlÅsselter Text';
 outtextxy2(1,1,s,schwarz,nachricht^);
end;

procedure erstelle_fax(quelle1,quelle2,ziel:tfeld);
begin
 for y:=0 to feld_hoehe-1 do
  for x:=0 to feld_breite-1 do
   ziel^[y,x]:=quelle1^[y,x] xor quelle2^[y,x];
end;

procedure erstelle_ergebnis(quelle1,quelle2,ziel:tfeld);
begin
 for y:=0 to feld_hoehe-1 do
  for x:=0 to feld_breite-1 do
   ziel^[y,x]:=quelle1^[y,x] or quelle2^[y,x];
end;

begin
 init;
 erstelle_folie(folie,feld_breite,feld_hoehe);
 erstelle_nachricht;
 erstelle_fax(folie,nachricht,fax);
 erstelle_ergebnis(fax,folie,ergebnis);
 show(nachricht);
  readln;
 show(folie);
  readln;
 show(fax);
  readln;
 show(ergebnis);
 readln;


 final;
end.