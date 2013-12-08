uses crt,konrad,_32bit,_13h;
const
      showzug:boolean   =false;
      showameise:boolean=false;
      domutier:boolean  =true;
      doneukombi:boolean=true;
      doauto:boolean    =false; {keine ENTER-Abfrage nach jeder Generation}
{----Futter--------------------}
      spot_anz=10;
      spot_size=6;
      spot_food=10;
      fcol=white;
{------------------------------}
      g_anz:word=0;
      gen_anz=8;
      akt_anz=4;
{      zeitverbrauch:array[1..akt_anz] of byte=
      (2,1,1,1
      );}
      am_zeit=700;
      am_anz=50;
      mutier_anz=am_anz div 3;
      width=100;
      height=100;
      zeitprozug=100;
      richt_anz=4;
      nord=1;
      ost=2;
      sued=3;
      west=4;
      vorne=1;
      links=2;
      rechts=3;

      fricht:array[nord..west,vorne..rechts,0..1] of shortint=
      (
      ((00,-1),(-1,00),(01,00)),{norden}
      ((01,00),(00,-1),(00,01)),{osten}
      ((00,01),(01,00),(-1,00)),{s갺en}
      ((-1,00),(00,-1),(00,01)));{westen}

type tgen=array[1..gen_anz] of byte;{Der Gencode f걊 die Ameise}
     tam =record                    {Die Ameise selbst}
           gene:tgen;
           x,y,zeit:integer;
           bpos,gefressen,richtung:byte;
          end;
{richtung:
       1
    4     2
       3

       }

var am:array[1..am_anz] of tam;
    akt:array[1..akt_anz] of pointer;
    f,fquell:array[0..height-1,0..width-1] of byte;{0= kein Futter, 1=Futter}
    screen1:^tscreen;
    a:tam;{Die Ameise f걊 die Aktionen}
    highest:word;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure abfrage;
begin
 if keypressed then taste:=upcase(readkey);
 case taste of
  'A':doauto:=not doauto;
  'S':showzug:=not showzug;
 end;
 if (taste<>#13) and (taste<>#27) then taste:='n';
end;

{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�}
{Achtung: gefressen werden kann auch von akt 4 (vorw꼛ts 2*) aus!!}
procedure fress(var a:tam);
begin
 inc(a.gefressen);
 f[a.y,a.x]:=0;
end;
{컴컴컴컴컴컴컴컴컴컴Aktionsprozeduren컴컴컴컴컴컴컴�}
function moeglich(x,y:integer):boolean;
begin
 if (x>=0) and (x<width) and (y>=0) and (y<height) then moeglich:=true
  else moeglich:=false;
end;

procedure akt1;{nach vorne sehen, wenn futter da ist gehen sonst links drehen}
var i,x,y:integer;
    gefunden:boolean;
begin
 gefunden:=false;
 x:=fricht[a.richtung,vorne,0]+a.x;
 y:=fricht[a.richtung,vorne,1]+a.y;
 if moeglich(x,y) then
 begin
  if f[y,x]=fcol then
  begin
   a.x:=x;
   a.y:=y;
  end else
   begin
    dec(a.richtung);
    if a.richtung<nord then a.richtung:=west;
   end;
 end;
end;

procedure akt2;{links}
var x,y:integer;
begin
 dec(a.richtung);
 if a.richtung<nord then a.richtung:=west;
 x:=fricht[a.richtung,vorne,0]+a.x;
 y:=fricht[a.richtung,vorne,1]+a.y;
 if moeglich(x,y) then
 begin
  a.x:=x;
  a.y:=y;
 end;
end;

procedure akt3;{rechts}
var x,y:integer;
begin
 inc(a.richtung);
 if a.richtung>west then a.richtung:=nord;
 x:=fricht[a.richtung,vorne,0]+a.x;
 y:=fricht[a.richtung,vorne,1]+a.y;
 if moeglich(x,y) then
 begin
  a.x:=x;
  a.y:=y;
 end;
end;

procedure akt4;{vorne 2*}
var i,j,x,y:integer;
begin
 for i:=1 to 2 do
 begin
  x:=fricht[a.richtung,vorne,0]+a.x;
  y:=fricht[a.richtung,vorne,1]+a.y;
  if moeglich(x,y) then
  begin
   a.x:=x;
   a.y:=y;
   if (i=1) and (f[y,x]=fcol) then fress(a);
  end;
 end;
end;

{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure call(p:pointer);assembler;
asm
 call p
End;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure randgen(var a:tam);
var i:integer;
begin
 for i:=1 to gen_anz do a.gene[i]:=random(akt_anz)+1;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure initameise(var a:tam);{setzt alle werte der ameise ausser den genen neu}
begin
 with a do
 begin
  zeit:=0;
  bpos:=1;
  gefressen:=0;
  x:=random(width);
  y:=random(height);
  richtung:=1;
 end;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure init;
var i,j,x,x2,y,y2:integer;
begin
 randomize;
 new(screen1);
 fillchar(fquell,sizeof(fquell),0);
 init13h;
 directvideo:=false;
 for i:=1 to am_anz do
 begin
  initameise(am[i]);
  randgen(am[i]);
 end;
 for i:=1 to spot_anz do
 begin
  x:=random(width);
  y:=random(height);
  for j:=1 to spot_food do
  begin
   repeat
    x2:=x+random(spot_size*2)-spot_size;
    y2:=y+random(spot_size*2)-spot_size;
   until moeglich(x2,y2);
   fquell[y2,x2]:=fcol;
  end;
 end;
 akt[1]:=@akt1;akt[2]:=@akt2;
 akt[3]:=@akt3;akt[4]:=@akt4;
end;

procedure moveall(var am_nr:word);
var j,k:integer;

 procedure zeigealles;
 var i:integer;
 begin
  filllongint(screen1^,80*height,0);
  for i:=0 to height-1 do
  begin
   movelongint(f[i],screen1^[i],width shr 2);
   move(f[i,width-4],screen1^[i,width-4],3);
  end;
  with am[am_nr] do screen1^[y,x]:=red;
  waitretrace;
  movelongint(screen1^,screen,80*height);
 end;

begin
 with am[am_nr] do
 for j:=1 to am_zeit do
 begin
  a:=am[am_nr];
  call(akt[am[am_nr].gene[bpos]]);
  am[am_nr]:=a;
  if f[y,x]=fcol then fress(am[am_nr]);
  inc(bpos);
  if bpos>akt_anz then bpos:=1;
{  delay(zeitprozug);}
  abfrage;
  if showzug then zeigealles;
 end;
 if showameise then zeigealles;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure evo;
var am_nr,i:word;
 procedure sort;
 var dummy:tam;
     i,j:integer;
 begin
  for i:=1 to am_anz-1 do
   for j:=i+1 to am_anz do
    if am[i].gefressen<am[j].gefressen then
    begin
     dummy:=am[i];
     am[i]:=am[j];
     am[j]:=dummy;
    end;
 end;

procedure neukombi(am_nr,anfang,ende:word);
{anfang,ende markieren bereich aus dem neukombiniert wird}
var i,nr:word;
begin
 {-Neue Ameise = alte zuf꼕lige---}
 nr:=random(ende-anfang+1)+anfang+1;
 am[am_nr]:=am[nr];
 {-die erste H꼕fte von einer anderen 갶ernehmen-}
 nr:=random(ende-anfang+1)+anfang+1;
 for i:=1 to gen_anz shr 1 do am[am_nr].gene[i]:=am[nr].gene[i];
end;

begin
 sort;
 {neu initialisieren}
 for am_nr:=1 to am_anz do Initameise(am[am_nr]);
 if doneukombi then
 for am_nr:=am_anz shr 1 to am_anz do neukombi(am_nr,1,am_anz shr 1-1);
 if domutier then
 for i:=1 to mutier_anz do
  am[am_anz shr 1+random(am_anz shr 1)+1].gene[random(gen_anz)+1]:=random(akt_anz)+1;
end;
{컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴}
procedure main;
var am_nr:word;
begin
 repeat
  taste:='n';
  highest:=0;
  inc(g_anz);
  for am_nr:=1 to am_anz do
  begin
   f:=fquell;
   moveall(am_nr);
   if am[am_nr].gefressen>highest then highest:=am[am_nr].gefressen;
   screen[0,0]:=yellow;
   gotoxy(1,10);
   writeln(highest);
   write(am_nr,'/',am_anz);
   waitretrace;
 {  readkey;}
  end;
  gotoxy(1,10);
  writeln('Generation ',g_anz,' ausgef갿rt, highest: ',highest);
  writeln(am_anz,' Ameisen berechnet');
  writeln('Optionen:');
  writeln('S: Bewegungen zeigen aus/an');
  writeln('A: Automatik');
  writeln('ENTER: weiter');
  writeln('Escape = Ende');
  repeat
   abfrage;
  until (taste=#27) or (taste=#13) or (doauto);

  if taste<>#27 then evo;
  filllongint(screen,16000,0);
 until taste=#27;
end;

begin
 init;
 main;
 textmode(3);
end.