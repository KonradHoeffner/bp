{Konrad Hîffner 1999}
{$R-}{Rangechecking fÅr dynamische Arrays ausschalten}

{ "t" ist bei mir Standard-Laufvariable}
uses crt;
const max_anzahl=255;{dynamischer Array sinnlos, da nur 6kbyte}
      keine_uebereinstimmung=1;
      volle_uebereinstimmung=2;
      name_ungueltig=1; {FÅr Namen-Nummer-Konvertierung}
type tliste=array[1..max_anzahl] of
            record
             name:string[20]; {Name der Person}
             nummer:longint;  {Telefonnummer}
             uebereinstimmung:boolean; {wenn TRUE dann:
             Nummer stimmt mit Eintragung Åberein}
            end;
var liste:tliste; {Das Listenfeld}
    anzahl,anzahl_unmoeglich:byte; {Anzahl= Anzahl an Personen}
                                   {Anzahl_unmoeglich=
                                   Anzahl an Personen, die in Bezug auf
                                   bisherige Eingabe nicht in Frage kommen}
    taste:char;                    {speichert Tastendruck}
    name,num_str:string;                   {Zwischenspeicher fÅr Namen}

function shl_d(x,n:word):longint;{wie SHL aber fÅr Dezimalzahlen}
var t:byte;ergebnis:longint;
begin
 ergebnis:=x;
 for t:=1 to n-1 do ergebnis:=ergebnis*10;
 shl_d:=ergebnis;
end;

procedure init; {Initialisierungsprozedur, wird am Programmstart ausgefÅhrt}
begin
 clrscr; {Bildschirm lîschen}
 fillchar(liste,sizeof(liste),0); {sicherheitshalber Liste lîschen}
end;

function name_to_number(name:string;var nummer:longint):byte;
{Konvertiert Namen in Pseudo-Namen/Nummer}
var pos:byte;{speichert Position im String "Name"}
begin
 nummer:=0;
 name_to_number:=0;
 for pos:=1 to length(name) do
  case upcase(name[pos]) of
  'A'..'C':inc(nummer,shl_d(2,length(name)-pos+1));
  'D'..'F':inc(nummer,shl_d(3,length(name)-pos+1));
  'G'..'I':inc(nummer,shl_d(4,length(name)-pos+1));
  'J'..'L':inc(nummer,shl_d(5,length(name)-pos+1));
  'M'..'O':inc(nummer,shl_d(6,length(name)-pos+1));
  'P'..'S':inc(nummer,shl_d(7,length(name)-pos+1));
  'T'..'V':inc(nummer,shl_d(8,length(name)-pos+1));
  'W'..'Z':inc(nummer,shl_d(9,length(name)-pos+1));
  else name_to_number:=name_ungueltig;
 end;
end;

procedure eingabe; {Namenseingabe}
var fertig:boolean;{Namenseingabe beendet?}
begin
 anzahl:=0; {Bis jetzt sind noch keine Namen eingegeben}
 fertig:=false;
 repeat     {Eingabe-Schleife}
  liste[anzahl+1].name:='';
  write('Bitte Name Nr.',anzahl+1,' eingeben (ENTER=Ende): ');readln(liste[anzahl+1].name);
  if liste[anzahl+1].name<>'' then {Name eingegeben?}
   begin
    inc(anzahl); {Anzahl aktualisieren}
    {In Pseudo-Namen/Alpha-Nummer konvertieren:}
    while name_to_number(liste[anzahl].name,liste[anzahl].nummer)=name_ungueltig
     do
     begin
      writeln('Name ist ungÅltig, keine Umlaute oder Sonderzeichen!');
      write('Bitte Name Nr.',anzahl,' eingeben: ');readln(liste[anzahl].name);
     end;
   end  else fertig:=true;
 until fertig;{Leerstring: Eingabe beendet}
end;

procedure suche; {Heraussuchen der in Frage kommenden "Telefonnummern anhand
                  einer Eingabe auf der numerischen Tastatur}
var t,anzahl_gefunden,zuletzt_gefunden:word;
    num_laenge:byte;{num_laenge speichert bisher eingegebene Stellen}

 function num_to_char(l:longint;position:byte):char;
 var dummy:string;
 begin
  str(l,dummy);
  num_to_char:=dummy[position];
 end;

 procedure einlesen;{Liest Benutzereingaben ein}
 var t:word;
     eingabe_nummer:longint;
     fehlercode:integer;

 begin
  writeln('Eingabe der Nummer (Leertaste:Eingabe Ñndern): ');
  write('>');
  num_str:='';
  anzahl_unmoeglich:=0;
  num_laenge:=0;
  inc(num_laenge);
  repeat
   repeat taste:=readkey; until (taste in['0'..'9']) or (taste=#13) or (taste=' ');
    write(taste);
    if taste=' ' then
    begin
     num_str:='';
     writeln;
     write('>');
    end;
    if taste<>#13 then num_str:=num_str+taste;
  until taste=#13;
  val(num_str,eingabe_nummer,fehlercode);
  anzahl_gefunden:=0;
  for t:=1 to anzahl do
  begin
   if eingabe_nummer=liste[t].nummer then
    begin
     inc(anzahl_gefunden);
     liste[t].uebereinstimmung:=true;
     zuletzt_gefunden:=t;
    end;
  end;
 end;

 procedure auswahl;
 type tnummer=array[1..1] of word; {fÅr dynamischen Array}
 var person_nr,anzahl_gespeichert:word;
     personen_nummern:^tnummer;
     zwischenspeicher:string;{Zur Vermeidung von Eingabefehlern
                              bei Eingaben von nummerischen Werten}
     fehler_auswahl:integer;
 begin
  {sizeof sichert maximale KompatibilitÑt}
  getmem(personen_nummern,sizeof(word)*anzahl_gefunden);
  person_nr:=0;
  anzahl_gespeichert:=0;
  repeat
   inc(person_nr);
   if liste[person_nr].uebereinstimmung then
   begin
    inc(anzahl_gespeichert);
    personen_nummern^[anzahl_gespeichert]:=person_nr;
   end;
 until anzahl_gespeichert=anzahl_gefunden;
   writeln('Es wurden ',anzahl_gefunden,
           ' öbereinstimmungen mit ihrer Eingabe gefunden.');
   writeln('Bitte wÑhlen sie eine Person aus:');
   writeln;
   for person_nr:=1 to anzahl_gefunden do
   writeln('Person ',person_nr,': ',
            liste[personen_nummern^[person_nr]].name);

  write('Wahl: Person Nr. >');
  repeat
   readln(zwischenspeicher);
   val(zwischenspeicher,person_nr,fehler_auswahl);
   if (fehler_auswahl<>0) then
    begin
     writeln('Bitte richtige Zahl eingeben.');
     write('Person Nr.>');
     person_nr:=1;{Damit nicht noch eine Fehlermeldung erzeugt wird (s. nÑchster Kommentar)}
    end;
   if (person_nr<1) or (person_nr>anzahl_gefunden) {Diese Bedingung wÅrde sonst dafÅr sorgen,
    dass eine zweite Fehlermeldung ausgegeben wÅrde}
    then
    begin
     writeln('Bitte Zahl zwischen 1 und ',anzahl_gefunden,' eingeben!');
     write('Person Nr.>');
    end;
  until (fehler_auswahl=0) and (person_nr in[1..anzahl_gefunden]);
  writeln('Simulierte Verbindung wird hergestellt mit ',
           liste[personen_nummern^[person_nr]].name,'.');
  freemem(personen_nummern,sizeof(word)*anzahl_gefunden);
 end;

begin
 clrscr;
 write('Name:');
 for t:=1 to 16 do write(' ');
 writeln('Nummer:');
 for t:=1 to 80 do write('ƒ');
 for t:=1 to anzahl do with liste[t] do
 begin
  writeln(name:20,' ',nummer);
 end;
 einlesen;
 writeln;
 if anzahl_gefunden=0
  then write('Leider keine öbereinstimmung gefunden.')
  else if anzahl_gefunden=1
   then write('Person gefunden - Name: ',liste[zuletzt_gefunden].name)
   else auswahl;
 readln;
end;

procedure final;
begin
end;

begin
 init;
 eingabe;
 suche;
 final;
end.