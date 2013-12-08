{Konrad H”ffner 1999}
{$R-}{Rangechecking fr dynamischen Array ausschalten}
{Programm zur Simulation der Warteschlangenl„nge eines Skiliftes}
uses crt;
const gruppen_groesse=15;
      keine_gruppe=0;
      insgesamt_personen:word=0;
      lift_personen:word=0;
      wartende_personen:word=0;
      abfahrende_personen:word=0;
      wartezeit=10; {Wartezeit fr eine simulierte Minute in ms}
type
      tstatus=(nichts,warten,lift_fahren,auf_gruppe_warten,ski_fahren);
      {Personen-Typ festlegen}
      tpersonen =array[1..1] of {1..1 fr dynamischen Array}
                record
                 status:tstatus;{was macht die Person gerade}
                 zeit:integer;{vergangene Zeit bei aktueller T„tigkeit}
                 gr_nummer:byte;{Nummer der Gruppe, 0=keine}
                 eintrittszeit:byte;
                end;
      tschlange=array[1..1] of word;
var
    personen:^tpersonen;
    t,u:word;{t ist meine Standard-Laufvariable}
    {Integer-Typ hilft gegenber Word beim ausfinfigmachen  falscher
    Werte (negative Werte z.B)}
    anzahl,gruppen:integer;
    zeit:record
          stunden,minuten:byte;
         end;
    warteschlange:^tschlange;

procedure set_zeit(st,min:byte);
begin
 zeit.stunden:=st;
 zeit.minuten:=min;
end;

procedure inc_zeit;
begin
 inc(zeit.minuten);
 if zeit.minuten=60 then
 begin
  inc(zeit.stunden);
  zeit.minuten:=0;
 end;
end;

procedure init;
 procedure werte_einlesen;
 begin
 clrscr;
 writeln('Xavers Liftsimulation');
 writeln;
 write('Anzahl der Personen: ');readln(anzahl);
 write('Anzahl der Skigruppen: ');readln(gruppen);
 end;
 procedure gruppen_und_anfangszeiten;{Festlegen der Ankunftszeiten}
 begin
  for t:=0 to gruppen-1 do for u:=0 to gruppen_groesse-1 do
   with personen^[t*gruppen_groesse+u+1] do
   begin
    gr_nummer:=t+1;
    eintrittszeit:=random(61);
   end;
  for t:=gruppen_groesse*gruppen+1 to anzahl do
   with personen^[t] do
   begin
    gr_nummer:=keine_gruppe;
    eintrittszeit:=random(61);
   end;
 end;
 procedure variablen_initialisieren;
 begin
  for t:=1 to anzahl do
   personen^[t].status:=nichts;
 end;

 procedure speicher_freigeben;
 begin
  getmem(personen,sizeof(tpersonen)*anzahl);
  getmem(warteschlange,(anzahl+1)*sizeof(word));
 end;

begin
 randomize;
 set_zeit(8,00);
 werte_einlesen;
 speicher_freigeben;
 variablen_initialisieren;
 gruppen_und_anfangszeiten;
 clrscr;
end;

procedure schleife;
var aktuelle_minuten,lift_buegel:byte;
 procedure zeige_situation;
 begin
  gotoxy(1,1);
  writeln('Zeit: ',zeit.stunden,':',zeit.minuten:2,' Uhr','     ');
  writeln('Anzahl der Personen insgesamt: ',insgesamt_personen,'     ');
  writeln('Anzahl Personen in der Warteschlange: ',wartende_personen,'     ');
  writeln('Anzahl Personen im Lift: ',lift_personen,'     ');
  writeln('Anzahl Personen bei der Abfahrt: ',abfahrende_personen,'     ');
 end;
 procedure anstellen(nr:byte);
 begin
  personen^[t].status:=warten;
  inc(wartende_personen);
  warteschlange^[wartende_personen]:=nr;
 end;
 procedure neue_personen;
 begin
  for t:=1 to anzahl do with personen^[t] do
    if (aktuelle_minuten=eintrittszeit) and (status=nichts)
     then
     begin
      inc(insgesamt_personen);
      anstellen(t);
     end;
 end;
 procedure rest_anstellen;
 begin
    for t:=1 to anzahl do with personen^[t] do
    if status=nichts
     then
     begin
      inc(insgesamt_personen);
      anstellen(t);
     end;
 end;
 procedure lift_rein;
  procedure einsteigen(anz:byte);
  var dummy:byte;
  begin
   if wartende_personen<>0 then
   begin
    if wartende_personen=1 then anz:=1;
    inc(lift_personen,anz);
    dummy:=2;
    if wartende_personen>1 then move(warteschlange^[dummy],warteschlange^[1],(wartende_personen-1)*sizeof(word));
    dec(wartende_personen,anz);
    with personen^[warteschlange^[1]] do
    begin
     status:=lift_fahren;
     zeit:=10;
    end;
   end;
  end;
 begin
  case random(100) of {Bgelkapazit„t ermitteln}
   1..80:einsteigen(2);
   81..95:einsteigen(1);
  end;
 end;
 procedure bewegung;
  procedure aussteigen(nr:word);
  begin
   with personen^[t] do
   if gr_nummer=0 then
   begin
    status:=ski_fahren;
    zeit:=random(13)+8;
    dec(lift_personen);
   end else
   begin
    status:=auf_gruppe_warten;
    dec(lift_personen);
   end;
  end;
 begin
  for t:=1 to anzahl do with personen^[t] do
  begin
   if status=lift_fahren then
   begin
    dec(zeit);
    if zeit=0 then aussteigen(t);
   end;

  end;
 end;
 procedure lift_raus;
 begin

 end;
begin
repeat
 aktuelle_minuten:=zeit.minuten;
 zeige_situation;
 delay(50);
 if zeit.stunden=8 then neue_personen;
 if (zeit.stunden=9) and (zeit.minuten=0) then rest_anstellen;
 bewegung;
 for lift_buegel:=1 to 5 do lift_rein;
 inc_zeit;
until (keypressed) or (zeit.stunden=17);
end;

procedure final;
begin
 freemem(personen,sizeof(tpersonen)*anzahl);
end;

begin
 init;
 schleife;
 readln;
 final;
end.