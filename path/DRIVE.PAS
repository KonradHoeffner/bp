{컴컴컴컴컴Unit DRIVE컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
 Bearbeitet eine Liste von anzufahrenden Punkten, die vom Hauptprogramm
 갶ergeben wird, setzt diese in Richtungsbefehle um und errechnet dann
 daraus unter Ber갷ksichtigung der minimalen Roboterrotation die
 entsprechenden n봳igen Steuerbefehle. Diese werden dann mit Hilfe
 der Unit "Hardware" an den Roboter 갶ermittelt, so da� dieser die
 errechnete Route bef꼑rt.
컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
}
unit drive;
interface
uses crt,hardware,konrad,dos;
type {POSS=Possibilities (M봥liche Fahrtrichtungen):
     v=vorne r=8tel-Drehung (45�) nach rechts von Richtung "0" aus, rr=90�...
     l=Drehung um -45�, ll=-90� usw.}
     tposs=(xrv,xrrv,xrrrv,xr,xlv,xllv,xlllv,xv);
     Karte=array[-1..200,0..159] of word;
const anz=2000;{die maximale L꼗ge der Fahrtroute}
      count:integer=1;{Speichert die L꼗ge der Route}
      drivevis:boolean=true;
      shift=4;{}
var wp:array[1..anz] of tpos;{Wegpunkte}
    script:array[1..anz] of tposs;{Liste der Bewegungen}
    Rf:shortint;{Richtung, -4 bis 4, 0=vor -4=4}
    f:text;
    Objekte,Ziel:^Karte;
    p,pZiel,pStart:tpos;
    saveint28:pointer;
    dcount:longint;
{--------------------------}
{Dreht den Roboter auf der Stelle, dabei ist ein negativer Wert
gleichbedeutend mit einer Drehung nach links (Rz*45�), ein positiver bedeutet eine Drehung
nach links. Ein Wert von (-)4 ist eine Drehung um 180�}
procedure DR_dreh(Rz:shortint);
{Wandelt die vorliegenden Wegpunkte in Richtungsbefehle um}
procedure DR_pktetoscript;
{Richtungsbefehle -> Steuerungsbefehle -> Senden an Roboter
Info: diese werden protokolliert in "log.txt"}
procedure r_drive(time:longint);
{--------------------------}
var terminated:boolean;
const
{----Delays----}
 dvor=900{ div 10};{Zeit, die der Roboter f걊 10cm ben봳igt}
 dvor2=round(dvor*1.4142136);
 ddreh=1250{ div 10};{Zeit f걊 8tel Drehung}
implementation
procedure counter;interrupt;
begin
 dcount:=dcount+55;
end;

function kollide:boolean;
{Testet Parallelport auf Kollision}
begin
 eb:=port[base+1];
 if testbit(eb,7) then begin kollide:=true;port[base+1]:=0;end
  else kollide:=false;
{die Taste "k" simuliert eine Kollision im Notfall
 bei sensiblen Hindernissen (Kleinkinder etc.) und erreicht
 damit ein Ausweichman봵er}
  if upcase(taste)='K' then begin kollide:=true; taste:='n'; end;
end;

procedure r_drive(time:longint);
{L꼜st Albert f걊 "time" ms vorw꼛ts fahren und reagiert dabei auf Kollisionen}
var    count2:longint;
begin
 dcount:=0;
 sendb(vor);{Dem Roboter das Signal zum vorw꼛ts fahren senden}
 terminated:=false;
 repeat
  if keypressed then taste:=readkey;
  if kollide then terminated:=true;  {auf Kollision pr갽en}
 until (dcount>=time) or terminated; {bis "time" ms vergangen sind}
 if terminated then {im Kollisionsfall}
 begin
  sendb(rueck); {r갷kw꼛ts fahren bis zum Ausgangspunkt}
  count2:=dcount;
  dcount:=0;
  repeat
  until dcount>=count2;
 end;
 sendb(stop); {Stopbefehl erteilen}
end;

procedure DR_dreh(Rz:shortint);
var Re:shortint;
{Re = effektive Richtung
 Rz = Zielrichtung
旼컴컴컴컴컴�
� Re = Rz-Rf�
읕컴컴컴컴컴�
      0
    -1 +1
   -2   +2
    -3 3
   (-)4
}

begin
 Re:=Rz-Rf;
 {쉇ertragsbehandlung bei 쿝z-Rf�>4   }
 if Re>4 then Re:=Re mod 5-3;
 if Re<-4 then Re:=Re mod 5+3;
 Rf:=Rz;
 if Re>0 then
begin
  sendb(rechts);
  writeln(f,'Drehen nach rechts um ',Re);
  delay(ddreh*Re);
  sendb(stop);
 end else
  if Re<0 then
 begin
  sendb(links);
  writeln(f,'Drehen nach links um ',-Re);
  delay(ddreh*-Re);
  sendb(stop);
 end else writeln(f,'Vorw꼛ts fahren');
end;

procedure DR_pktetoscript;
var t:word;
    pp:tpos;{der letzte Richtungsbefehl}
    s:tposs;{Der aktuelle Richtungsbefehl}
begin
 pp:=wp[1]; {1. Wegpunkt in pp speichern}
 for t:=2 to count do with wp[t] do
 begin
  {Differenz zwischen aktuellem - u. Zielpunkt auswerten:}
  if x-pp.x=1 then
  begin
   if y-pp.y=1 then s:=xrrrv                   {Drehung um 135�, dann vorw꼛ts}
               else if y-pp.y=-1 then s:=xrv   {Drehung um 45�, dann vorw꼛ts}
                                 else s:=xrrv; {Drehung um 90�, dann vorw꼛ts}
  end
   else if x-pp.x=-1 then
  begin
    if y-pp.y=1 then s:=xlllv                  {-135�,vorw꼛ts}
                else if y-pp.y=-1 then s:=xlv  {-45�,vorw꼛ts}
                                  else s:=xllv;{-90�,vorw꼛ts}
  end else
  begin
   if y-pp.y=-1 then s:=xv {vorw꼛ts}
                else s:=xr;{rechts}
  end;
  pp:=wp[t]; {n꼊hsten Wegpunkt bearbeiten}
  script[t-1]:=s;
 end;
end;

begin
 getintvec(28,saveint28);{Alten Int 28 sichern}
 SetIntVec(28,@counter); {Procedur "counter"}
 assign(f,'log.txt'); {"log.txt" erstellen}
 rewrite(f); {wenn vorhanden, 갶erschreiben}
end.