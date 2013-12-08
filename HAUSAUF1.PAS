uses crt;
type etype=record
           Name,Stadt:string[15];
           plz:word;
           Strasse:string[20];
           end;
var E:etype;
    Dat_Name:string[12];
    F:file of etype;
    taste:char;

procedure menue; forward;

procedure anlegen;
begin
 clrscr;
 write('Name der anzulegenden Datei: ');readln(dat_name);
 if pos(dat_name,'.')=0 then dat_name:=dat_name+'.dat';
 {$I-}
 assign(f,dat_name);
 rewrite(f);
 {$I+}
 menue;
end;

procedure einlesen;
begin
 repeat
  clrscr;
  write('Name: ');readln(e.name);
  write('Stadt: ');readln(e.stadt);
  write('Strasse: ');readln(e.strasse);
  write('Postleitzahl: ');readln(e.plz);
  write(f,e);
  write('Weiter(j/n)?');taste:=readkey;
 until taste='n';
 close(f);
 menue;
end;

procedure auslesen;
begin
 clrscr;
 write('Name der auszulesenden Datei: ');readln(dat_name);
 if pos(dat_name,'.')=0 then dat_name:=dat_name+'.dat';
 assign(f,dat_name);
 reset(f);
 while not eof do
 begin
 read(f,e);
 write('Name: ',e.name);
 write('Stadt: ',e.stadt);
 write('Strasse: ',e.strasse);
 write('Plz: ',e.plz);
 end;
 menue;
end;


procedure menue;
begin
 clrscr;
 
 writeln('1. Anlegen einer neuen Datei');
 writeln('2. Einlesen von Adressen in diese Datei');
 writeln('3. Auslesen von Adressen ');
 writeln('4. Ende');
 repeat
  taste:=readkey;
 until (taste>='1') and (taste<='4');
 if taste <>'4' then
 case taste of
  '1':anlegen;
  '2':einlesen;
  '3':auslesen;
 end;
end;


begin
 menue;
end.