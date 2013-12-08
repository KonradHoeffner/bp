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
 assign(f,dat_name);
 rewrite(f);
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

procedure menue;
begin
 clrscr;
 gotoxy(20,12);
 write('1. Anlegen einer neuen Datei');
 gotoxy(20,13);
 write('2. Einlesen von Adressen in diese Datei');
 gotoxy(20,14);
 write('3. Ende');
 repeat
  taste:=readkey;
 until (taste>='1') and (taste<='3');
 if taste <>'3' then
  if taste='1' then anlegen
               else einlesen;
end;


begin
 menue;
end.