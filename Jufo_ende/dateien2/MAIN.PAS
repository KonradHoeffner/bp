uses crt,navigate,hardware,drive,konrad,utext,_32bit,dos;
const lowmem:boolean=false;
      filename='test.bar';
      dovisual=false;
      ende:boolean=false;
      m_anz=9;
      ktime=1*18;{1 Sekunde Verz”gerung}
      cm=10;
m_items:array[1..M_anz] of string=(
'&Hindern. zeigen',
'&Feld+Route',
'&Go!',
'&Sensorbyte',
'&PReset',
'St&art',
'&Ziel',
'&KSim!!',
'&End'
);
var pal_sim:array[0..767] of byte;

procedure show_weg(var dest:tscreen);
{Stellt die geplante Route dar}
begin
 for t:=1 to count do with wp[t] do
 begin
  dest[y,x shl 1]:=254;
  dest[y,x shl 1+1]:=0;
 end;
end;

Procedure DR_ShowScreen(var source,target);
{Zeigt die Navigationskarte an}
Begin
asm
  push ds
  lds si,source             {fertiges Bild als Objekte}
  add si,320
  les di,target
  mov cx,160*200
  @Loop1:
  mov ax,[si]              {Word aus Quelle laden}
  shr ax,Shift             {durch 2^shift teilen, Ergebnis<255 ->Byte}
  mov ah,al                {Lo-Byte des Words auf Hi-Byte kopieren}
  mov es:[di],ax           {2 aufeinanderfolgende Pixel setzen}
  add di,2                 {Zeiger um 2 Bytes erh”hen}
  add si,2                 {...}
  dec cx
  jnz @Loop1
  pop ds
End;
End;

procedure Drivescript;
{F„hrt die geplante Route ab}
var t:integer;
begin
 if drivevis then
 begin
   asm mov ax,13h
       int 10h end;
  waitretrace;
  move(pal_sim,palette,768);setpal;
  DR_showscreen(ziel^,screen);
  show_weg(screen);
 end;
{ for t:=1 to count do} {Richtungsbefehle an "DR_Dreh" bermitteln}
 t:=1;
 with wp[1] do fillchar(screen[y,x shl 1],2,255);
 p:=wp[t];
 repeat
  {Vorw„rts fahren mit Zeitdauer abh„ngig von der Roboterausrichtung}
  case rf of
   -4,-2,0,2,4:r_drive(dvor);
   else r_drive(dvor2);
  end;
  if not terminated then
  begin
   inc(t);
   p:=wp[t];
  end else readkey;
  if drivevis then with p do fillchar(screen[y,x shl 1],2,255);
  case script[t] of
   xv:DR_dreh(0);
   xr:DR_dreh(4);
   xlv:DR_dreh(-1);
   xllv:DR_dreh(-2);
   xlllv:DR_dreh(-3);
   xrv:DR_dreh(1);
   xrrv:DR_dreh(2);
   xrrrv:DR_dreh(3);
  end;
{  writeln(f,'Vorw„rts fahren');}
  r_reset;{Motoren ausstellen}
  if keypressed then taste:=readkey;
  if taste=#8 then taste:=readkey;
 until (t=count) or (taste=#13);
 if drivevis then begin textmode(3); inc(windmax,256);end;
 p:=wp[t];
end;

function getvidmode:byte;
{gibt den aktuellen Videomodus zurck}
var dummy:byte;
begin
 asm
  mov ax,0f00h
   int 10h
  mov dummy,al
 end;
 getvidmode:=dummy;
End;

procedure Load_CFG;
{L„dt die Konfigurationsdatei}
var cfg:text;
begin
 assign(cfg,'config.txt');
 reset(cfg);
 readln(cfg,base);
 close(cfg);
end;

function FileExist(FileName: String): Boolean;
var f:file;
begin
 assign(f,filename);
 {$i-}
 reset(f);
 {$i+}
 if ioresult=0 then fileexist:=true else fileexist:=false;
end;

procedure init;
begin
{ kcount:=0;}
 clrscr;
 writeln('Robotersoftware wird initialisiert:');
 writeln('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
 writeln('Aktueller Videomodus: ',getvidmode);
 if fileexist('config.txt') then
 begin
  write('Laden von config.txt...');
  Load_CFG;writeln('Paralleler Basisport ',base);
 end else writeln('config.txt nicht gefunden - Standardwerte werden verwendet');
 writeln('Freier Speicher: ',memavail shr 10,'kb');
 if (memavail shr 10)<150 then
 begin
  textcolor(white);writeln('Achtung: Speicher kritisch !!!');textcolor(lightgray);
  write('Trotzdem weiter (J/N)? ');taste:=upcase(readkey);
  if taste<>'J' then halt;
  {lowmem:=true;}
 end;
 write('R_Reset wird durchgefhrt...'); r_reset;writeln('bereit');
 write('Initialisierung des Navigationssystems NS_Init...');NS_Init;writeln('bereit');
 write('Laden der Objekte aus ',filename,'...');NS_LoadMap(filename);writeln(obj_count,' Objekte geladen');
 writeln('Freier Speicher: ',memavail shr 10,'kb');
 write('Wavealgorithmus wird durchgefhrt...');NS_Wave;writeln('bereit');
 write('Krzeste Route wird berechnet...');NS_Findroute;writeln(' ',count,' Schritte n”tig');
 writeln;writeln('Enter fr weiter...');readln;
{----------}
  for t:=1 to 254 do
  {Palette vorbereiten}
  begin
   pal_sim[t*3]:=t shr 2;
   pal_sim[t*3+1]:=t shr 2;
   pal_sim[t*3+2]:=t shr 2;
  end;
  fillchar(pal_sim[0],3,0);
  fillchar(pal_sim[255*3],3,0);
  pal_sim[255*3]:=63;
end;

Procedure VisObjs;
{Objekte anzeigen}
Begin
 init13h;
 setmypalette(254,0,0,0);
 setmypalette(0,30,30,30);
 DR_showscreen(objekte^,screen);
 readln;
 textmode(3);
 inc(windmax,256);
end;

Procedure Visualize;
{Navigationskarte und geplante Route anzeigen}
var t:word;
    b:byte;
Begin
 init13h;
 waitretrace;
 for t:=1 to 254 do setmypalette(t,t shr 2,t shr 2,t shr 2);
 setmypalette(0,0,0,0);
 setmypalette(255,255,0,0);
 DR_showscreen(ziel^,screen);
 show_weg(screen);
 readkey;
 textmode(3);
 inc(windmax,256);
End;

Procedure Go; {Auftrag des Roboters ausfhren}
begin
 NS_Wave;
 NS_Findroute;
 DR_PktetoScript;
 DriveScript;
end;

Procedure S_Show;
{Sensorbyte anzeigen}
var t:word;
Begin
 repeat
  waitretrace;
  clrscr;
  gotoxy(1,1);
  eb:=port[base+1];
  for t:=7 downto 0 do if testbit(eb,t) then write('1') else write('0');
 until keypressed;
end;

Procedure PReset;
{Neufinden der Route}
Begin
 P:=Pstart;
 NS_Findroute;
End;

Procedure ClickPos(var p:tpos);
{Maus anzeigen}
var col:byte;
Begin
 init13h;
 move(pal_sim,palette,768);
 setpal;
 DR_Showscreen(ziel^,screen);
 repeat
  maus_abfrage;maus.x:=maus.x shr 1;
  col:=screen[maus.y,maus.x];
  screen[maus.y,maus.x]:=255;
  waitretrace;
  screen[maus.y,maus.x]:=col;
 until maus.taste=1;
 p.x:=maus.x shr 1;
 p.y:=maus.y;
 filllongint(ziel^,16000,0);
 Ziel^[pZiel.Y,pZiel.X]:=Ziel_Intensity;
End;


Procedure Menu;
var t:word;
Begin
 waitretrace;
 if getvidmode<>3 then begin textmode(3); inc(windmax,256); end else clrscr;
 writeln('Robotersteuerungsprogramm');
 writeln('ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');writeln;
 writeln('Momentane Routenl„nge: ',count,' (',count*cm div 100,'m)');
 writeln;writeln('Ende mit Esc');

 gotoxy(80,24);write('³');
 gotoxy(1,23);write('Ú');for t:=1 to 78 do write('Ä');write('¿');
 gotoxy(1,25);write('À');for t:=1 to 78 do write('Ä');write('Ù');
 gotoxy(1,24);write('³');
 for t:=1 to m_anz do
 begin
  Mwrite(M_Items[t]+' ');
  gotoxy(wherex,wherey-1);write('Â');
  gotoxy(wherex-1,wherey+2);write('Á');
  gotoxy(wherex-1,wherey-1);write('³');
 end;
 gotoxy(1,26);
 taste:=upcase(readkey);
 case taste of
  'H':VisObjs;
  'F':Visualize;
  'G':begin Go; end;
  'S':S_Show;
  'E':ende:=true;
  'P':PReset;
  'A':begin ClickPos(p); pstart:=p; NS_Wave;NS_Findroute;end;
  'Z':begin ClickPos(pziel); NS_Wave;NS_Findroute;end;
 end;
 if taste=#27 then ende:=true;
End;

Procedure Main;
begin
 inc(windmax,256); {Automatisches scrollen ausschalten}
 repeat
  Menu;
 until ende;
end;

begin
 init;
 main;
 close(f);
 R_reset;
 setintvec(28,saveint28); {alten Interrupt wiederherstellen}
end.