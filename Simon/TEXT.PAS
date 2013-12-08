uses crt,konrad;
const anz=5;
      menu:array[1..anz] of string
      =('1. Neue Datei',
        '2. ...',
        '3. Datei anzeigen',
        '',
        'Esc: Ende');
type ttext=text;
var f:ttext;
    s:string;
    t:word;
    taste:char;
    zaehl:byte;
procedure neu;
begin
 write('Dateiname (Endung: .tst): ');readln(s);
 if pos('.',s)=0 then s:=s+'.tst';
 assign(f,s);
 rewrite(f);
 writeln('Bitte Text eingeben... nichts=fertig');
 writeln('------------------------------------');
 repeat
  readln(s);
  write(f,s);
 until s='';
 close(f);
end;

procedure anzeig;
begin
 writeln;
 writeln('Datei anzeigen');
 writeln('컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�');
 writeln;
 write('Name der Datei: ');readln(s);
 writeln('---------------------------------');
 if pos('.',s)=0 then s:=s+'.tst';
 assign(f,s);
 {$i-}
 reset(f);
 {$i+}
 if ioresult <>0 then
 begin
 writeln('Fehler: Datei nicht vorhanden...');
 writeln('---------------------------------');
 end
 else
 begin
 while not eof(f) do
 begin
  readln(f,s);
  writeln(s);
 end;
 writeln('------------- Ende -------------');
 close(f);
 end;
 readkey;
end;

procedure showmenu;
begin
 textcolor(white);
 writeln('Textedit');
 textcolor(lightgray);
 for t:=101 to 180 do
 begin
 textcolor(t);
 write('�');
 end;
 textcolor(lightgray);
 writeln;
 for t:=1 to anz do
 writeln(menu[t]);
 taste:=readkey;
 if taste='1' then neu;
 if taste='3' then anzeig;
end;

begin
 zaehl:=101;

 repeat
  waitretrace;
  clrscr;
  showmenu;
  inc(zaehl);
  if zaehl=181 then zaehl:=101;
  palette[(zaehl-1)*3+2]:=0;
  palette[zaehl*3+2]:=255;

 until taste=#27;
end.