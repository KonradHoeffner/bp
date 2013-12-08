program wimpel;
uses crt;
var f,f1,f2,f3,f4,f5,f6:string; i,anzahl:integer;


procedure start;
begin
clrscr;
write ('Anzahl der Farben? ');
readln (anzahl);
write ('Farbe 1 ');
readln(f1);

if anzahl > 1 then write('Farbe2 '); readln(f2);
if anzahl > 2 then write('Farbe3 '); readln(f3);
if anzahl > 3 then write('Farbe4 '); readln(f4);
if anzahl > 4 then write('Farbe5 '); readln(f5);
if anzahl > 5 then write('Farbe6 '); readln(f6);

write('Anzahl der ',f1,'en',' Wimpel ');
readln(

if anzahl >1 then write('Anzahl der ',f2,'en',' Wimpel ');
readln(f2);
if anzahl >2 then write('Anzahl der ',f3,'en',' Wimpel ');
readln(f3);
if anzahl >3 then write('Anzahl der ',f4,'en',' Wimpel ');
readln(f4);
if anzahl >4 then write('Anzahl der ',f5,'en',' Wimpel ');
readln(f5);
if anzahl >5 then write('Anzahl der ',f6,'en',' Wimpel ');
readln(f6);
end;

{ Hauptprogramm}
begin
start;
readln;
end.