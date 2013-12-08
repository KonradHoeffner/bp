{ÄFeld_opt.pasÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
 2D- und 3d- Simulation des Naviagationssystems
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
{Achtung: Geschwindigkeit umgekehrt proportional zu "Genauigkeit" (1-3), 2 Standard}
uses crt,_32bit,_3d,konrad,_13h;

const
      breite=160;{Maáe des Graphikmodus 13h}
      hoehe=200;
      {ÄÄÄÄÄVorschauÄÄÄÄÄ}
      maus_rotate=true;{Darstellung kann mit der Maus rotiert werden}
      helplines=true;{zeigt Rahmen um Gitterkarte an}
      anzx=30;anzy=30;{Anzahl der Linien der Gitterkarte}
      zoom2=7*50 div anzx;{Zoomfaktor fr 3D-2D-Projektion bei der Generation
                           der Gitternetzkarte}
      verz1=1;{je groesser desto mehr Rechenzeit fr Effekte, weniger fr 3d}
      mincol=50;{Minimaler Farbwert der dunklen Stellen}
       {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
      filename={c:\eigene~1\bp\path\}'demo.bar';
      zoom=256;{Zomm}
      dist:integer=600;{Virtuelle Distanz des Koordinatenursprungs
      vom Auge des Betrachters, s. Grundlagen der 2D-Projektion (Unit 3D)}
      robo_on:boolean=true;{simuliertes Fahren des Roboters an/aus}
      robo_fast=true;{Wenn True dann Speed=gesch sonst Speed=1/Verz}
      verz=2;
      gesch=1;
      gesch_count:byte=1;
      genauigkeit=2;{Anzahl der Ausfhrungen des Iterationsalgorithmus'}
      {Standard Start- u. Zielpositionen}
      start_x:integer =20;
      start_y:integer =50;
      Ziel_X: integer =10;
      Ziel_Y: integer =10;
      {Maximum=1000 -> /4 =250}
{      ShiftRight=0;}
      shift=4;{bestimmt maximale Entfernung des Roboters vom Zielpunkt
      auf der bestm”glichen Route, diese ist 254*2^shift-1 Planquadrate,
      bei shift=4 also theoretisch ber 400m, da dieser Wert allerdings bei
      derzeitiger Anwendung nie erreicht wird, ist die maximale Entfernung
      durch die Routenfindung auf 200m begrenzt}
      oi=254 shl shift;{shl Verstaerkung}
      Ziel_Intensity:word=(255 shl shift)-1;{Wert, den das Ziel zugewiesen bekommt}
      dec1=10;
      dec2=1;{->1.414213562 }
   obj_maxanz=255;
   obj_anz:integer=2;
   unmoeglich:boolean=false;{wird auf true gesetzt wenn keine Wegberechnung
   m”glich ist, weil der Roboter in einem Hindernis plaziert wurde}
   kreuz:array[0..2,0..2] of byte= {Fadenkreuz-Cursor}
   ((0,1,0),
    (1,1,1),
    (0,1,0));
type Karte=array[-1..200,0..159] of word; {Struktur der Navigationskarte}
     Trect=record                         {Typ eines Rechtecks}
            x1,y1,x2,y2:word;
           end;
{-fr evtl. zuknftige Erweiterungen reserviert-----}
     TStat=(onroute,backhome);
     TSimRobo=record
               stat:TStat;
               timer:longint;
              end;
{---------------------------------------------------}

var w:word;{w,i - Hauptschleifenvariablen}
    i:Integer;
    Objekte,Ziel:^Karte; {Objekte enth„lt Hindernisinformationen,
                         Ziel die Entfernungswerte fr die Wegberechnung}
{Achtung: Bit 15 des Words nicht benutzen, teilweise Integer-Verarbeitung
          Bit 14= Ziel}

   count:word;

   o:array[1..obj_maxanz] of tRect; {Hindernisse}
   puffer:^tscreen; {Virtuelle Bildschirmseite, s„mtliche
   Graphikoperationen der 3D-Sim. laufen zun„chst dort ab, danach wird
   sie auf den Bildspeicher kopiert}
   weg_pkte:array[1..2000] of tpos;
   count_pkte:integer;{Anzahl der Wegpkte}
    omaus:TMaus;
   kx,ky:word;
   p,pz:tpos;

Procedure CreateEnv;Forward;

Procedure InitPal; {Farbenpalette setzen fr 2D-Simulation}
Begin
 Fillchar(Palette,3,0);
 for t:=1 to 254 do
  fillchar(palette[t*3],3,t shr 2);
 palette[255*3]:=63;
 palette[255*3+1]:=0;
 palette[255*3+2]:=0;
 setpal;
End;

Procedure SaveObjs; {Objekte speichern}
var f:file;t:word;
Begin
 Assign(F,filename);
 Rewrite(F,1);
 Blockwrite(f,obj_anz,sizeof(obj_anz));
 Blockwrite(f,o,sizeof(o));
 Close(F);
End;

Procedure LoadObjs; {Objekte laden}
var f:file;t:word;
Begin
 Assign(F,filename);
 Reset(F,1);
 blockread(f,P,sizeof(p));{p.x:=2;p.y:=198;}
 blockread(f,PZ,sizeof(pz));{pz.x:=30;pz.y:=180;}
 start_x:=p.x;start_y:=p.y;
 ziel_x:=pz.x;ziel_y:=p.y;
 Blockread(f,obj_anz,sizeof(obj_anz));
 Blockread(f,o,sizeof(trect)*obj_anz);
 Close(F);
End;

Procedure DoLoad; {Objekte laden und Karte aktualisieren}
Begin
 LoadObjs;
 CreateEnv;
End;

procedure init; {Initialisierung des Programmes}
var x,y:integer;
begin
 for x:=0 to 2 do for y:=0 to 2 do {Fadencursorfarbe „ndern}
 kreuz[y,x]:=kreuz[y,x]*255;
{-Speicher reservierenÄÄÄÄÄÄÄÄÄ}
 Getmem(Objekte,sizeof(Karte));
 Getmem(Ziel,sizeof(Karte));
 Getmem(puffer,64000);
{-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
 InitTables; {Sinus- und Kosinustabellen erstellen}
 Maus_Init;
 {Standardobjekte einsetzen:}
      o[1].x1:=30;
      o[1].y1:=40;
      o[1].x2:=60;
      o[1].y2:=60;
      o[2].x1:=120;
      o[2].y1:=120;
      o[2].y2:=140;
      o[2].y1:=150;
 Init13h;
 InitPal;
 randomize;
end;

Procedure Show_Screen2(var source,target);          {kopiert fertigen Bilschirm auf VGA}
{Var temp:Pointer;}               {zum Tauschen der Zeiger}
Begin
asm
  push ds
  lds si,source
  add si,320               {in source auf die 2. Zeile (zeile 0)}
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


Procedure Soft_Down(var obj,target);assembler;
asm
  push ds
  lds si,target             {Zeiger auf Zielbild laden}
  les di,obj

  mov cx,hoehe
  add si,320   {in 2. Zeile (Zeile 0)}
  add di,320   {..}
  xor bx,bx
{damit es nicht zu Entfernungswertbertragungen links<->rechts koomt,
ist die Schleife in eine x- und eine y-Schleife gegliedert,
sonst k„me es zu einem Effekt, als wrde der Roboter auf
einem riesigen Zylinder fahren.
Durch Entfernen des Randes oben und unten, w„re der Roboter dann theoretisch
auf einem kugelf”rmigen Objekt (wie z.B. der ganzen Erde) einsetzbar.
}
@Loop_y:
  mov dx,breite-1 {dx ist Laufvariable fr x}
@Loop_x:
{---Objekt auf xy? Weiter!!----}
  mov ax,es:[di]
  or ax,ax
  jne @Null
{------------}
  mov ax,[si]
  or ax,ax
  jz @Null
  sub ax,DEC1
{ÄÄÄÄÄÄUntenÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
  mov bx,[si+320]
  cmp bx,ax
  jge @weiter
{Objekt auf betrachteter Position?}
  mov bx,es:[di+320]
  or bx,bx
  jne @weiter
  mov [si+320],ax
  @weiter:
{ÄÄÄÄÄÄRechtsÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
  mov bx,[si+2]
  cmp bx,ax
  jge @weiter2
{Objekt auf betrachteter Position?}
  mov bx,es:[di+2]
  or bx,bx
  jne @weiter2

  mov [si+2],ax
  @weiter2:

  @Null:
  add si,2
  add di,2
  dec dx
  jne @loop_x
  add si,2 {letztes Feld wird ausgelassen}
  add di,2
  dec cx
  jne @loop_y
  pop ds
End;

Procedure Soft_Up(var obj,target);assembler;
asm
  push ds
  lds si,Target             {Zeiger auf Zielbild laden}
  les di,obj
  mov cx,hoehe
  add di,320*(hoehe+1)
  add si,320*(hoehe+1)
@Loop_y:
  mov dx,breite-1
@Loop_x:
{---Objekt auf xy? Weiter!!----}
  mov ax,es:[di]
  or ax,ax
  jne @Null
{------------}
  mov ax,[si]
  or ax,ax
  jz @Null
  sub ax,DEC1
{ÄÄÄÄÄÄObenÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
  mov bx,[si-320]
  cmp bx,ax
  jge @weiter
{Obj??}
  mov bx,es:[di-320]
  or bx,bx
  jne @weiter

  mov [si-320],ax
  @weiter:
{ÄÄÄÄÄÄLinksÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
  mov bx,[si-2]
  cmp bx,ax
  jge @weiter2
{Obj??}
  mov bx,es:[di-2]
  or bx,bx
  jne @weiter2
  mov [si-2],ax
  @weiter2:

  @Null:
  sub si,2
  sub di,2
  dec dx
  jne @Loop_X
  sub si,2
  sub di,2
  dec cx
  jne @Loop_Y
  pop ds
End;


Procedure CreateEnv; {Belegung der Navigationsfelder mit Standardwerten}
var obj_nr:word;
Procedure Paintobject(x1,y1,x2,y2:Integer);
var t:word;
begin
 for t:=y1 to y2 do fillword(Objekte^[t,x1],x2-x1+1,oi);
End;
Begin
 Filllongint(Objekte^,sizeof(Karte) shr 2,0);
 Filllongint(Ziel^,sizeof(Karte) shr 2,0);
 for obj_nr:=1 to obj_anz do with o[obj_nr] do
 PaintObject(x1,y1,x2,y2);

{ while objekte^[ziel_y,ziel_x]<>0 do begin ziel_x:=random(160); ziel_y:=random(200);end;}
 while objekte^[start_y,start_x]<>0 do begin start_x:=random(160); start_y:=random(200);end;
 Ziel^[ziel_Y,Ziel_X]:=Ziel_Intensity;
End;

procedure Final;
begin
 Textmode(3);
{Speicher freigeben}
 Freemem(Objekte,sizeof(Karte));
 Freemem(Ziel,sizeof(Karte));
end;

procedure show_weg(var dest:tscreen);
{Zeigt die geplante Route an}
begin
 for t:=1 to count_pkte do with weg_pkte[t] do
 begin
  dest[y,x shl 1]:=255;
  dest[y,x shl 1+1]:=255;
 end;
end;

procedure Find_Weg;
{Berechnet die Route zum Ziel anhand der Entfernungsangaben der
Navigationskarte}
const
    anz=8;
    add_matrix:array[1..anz] of array[0..1] of shortint=((-1,-1),(1,1),(1,-1),(-1,1),(0,-1),(0,1),(-1,0),(1,0));
var y,x,current,dx,dy,min,min_nr,dort:integer;
    aenderung:boolean;

Procedure Add(nx,ny:shortint); {Fgt der geplanten Route einen Punkt hinzu}
Begin
 inc(count_pkte);
 inc(x,nx);
 inc(y,ny);
 weg_pkte[count_pkte].x:=x;
 weg_pkte[count_pkte].y:=y;
 current:=ziel^[y,x];
 aenderung:=true;
End;
Procedure DoIt(Nr:word;wert:integer);
{speichert Entfernungswert und dessen relative Koordinate}
Begin
 min_nr:=nr;
 min:=wert;
End;

begin
 y:=start_y;
 x:=start_x;
 count_pkte:=0;
 if objekte^[ziel_y,ziel_x]=0 then {wenn Roboter im Hindernis plaziert}
 begin
  unmoeglich:=false;
 repeat
  dx:=ziel_x-start_x;
  dy:=ziel_y-start_y;
  aenderung:=false;
  current:=ziel^[y,x];
  min:=current;
  {Alle Punkte um den Ausgangspunkt werden untersucht,
  derjenige mit der geringsten Entfernung wird gespeichert}
  dort:=ziel^[y-1,x-1]; if dort>min then DoIt(1,dort);
  dort:=ziel^[y+1,x+1]; if dort>min then DoIt(2,dort);
  dort:=ziel^[y-1,x+1]; if dort>min then DoIt(3,dort);
  dort:=ziel^[y+1,x-1]; if dort>min then DoIt(4,dort);
  dort:=ziel^[y-1,x]; if dort>min then DoIt(5,dort);
  dort:=ziel^[y+1,x]; if dort>min then DoIt(6,dort);
  dort:=ziel^[y,x-1]; if dort>min then DoIt(7,dort);
  dort:=ziel^[y,x+1]; if dort>min then DoIt(8,dort);
  {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
  if min<>current then Add(add_matrix[min_nr][0],add_matrix[min_nr][1]);
  {wenn dessen Entfernungswert nicht gleich dem der Ausgangsposition ist,
  wird dieser Punkt auf der Route eingetragen}
  if not aenderung then inc(count_pkte);
  {Durchlaufz„hler erh”hen, sofern noch nicht geschehen}
 until (current=ziel_intensity) or (count_pkte>=2000);
 if robo_on then
 if robo_fast then
 begin
  start_x:=weg_pkte[gesch].x;
  start_y:=weg_pkte[gesch].y;
 end
  else
 begin
  inc(gesch_count);
  if (gesch_count mod verz)=0 then
  begin
   gesch_count:=0;
   start_x:=weg_pkte[1].x;
   start_y:=weg_pkte[1].y;
  end;
 end;
{ show_weg;}
 end else unmoeglich:=true;
end;

Procedure _3DView;
{Die 3D-Simulation}
var x,y,mx,my:integer;
    points3d:array[0..anzy-1,0..anzx-1] of TPos3d;{enth„lt 3D-Koordinatenangaben}
    vispoints:array[0..anzy-1,0..anzx-1] of TPos;{enth„lt 2D-Koordinatenangaben}
    colors:array[0..anzy-1,0..anzx-1] of byte;{Farben der einzelnen Linien}
    count1,count2:word;

Procedure PointGen; {Generiert 3D-Koordinaten aus den Entfernungswerten der
                    Navigationskarte}
var mx,my,x,y:integer;
    nr:word;
Begin
 for y:=0 to anzy-1 do
  for x:=0 to anzx-1 do
  begin
   mx:=round(x*159/anzx);
   my:=round(y*199/anzy);
{   nr:=x+anzx*y;}
   points3d[y,x].x:=(x-(anzx shr 1))*zoom2;
   points3d[y,x].y:=(y-(anzy shr 1))*zoom2;
   {$R-}
   colors[y,x]:=ziel^[my,mx] shr shift;
   if colors[y,x]<mincol then colors[y,x]:=mincol;
   {$R+}
   points3d[y,x].z:=colors[y,x] shr 1;
  end;

End;
Procedure MakeVisual;
var help:single;
    t:word;
    ix,iy:integer;
{Angepasste Version von Makevis aus _3d.pas}
Begin
 for ix:=0 to anzx-1 do for iy:=0 to anzy-1 do with points3d[iy,ix] do
 begin
  help:=(z+dist)/zoom;
  if help=0 then help:=0.0001;
  vispoints[iy,ix].x:=trunc((x)/help)+160;
  vispoints[iy,ix].y:=-trunc((y)/help)+100;
 end;
End;

Procedure ShowPoints(var dest:tscreen);
{stellt die Gitternetzkarte dar}
const col:byte=254;
var mx,my,dx,dy:integer;
    p1,p2:TPos;
    nicht:boolean;
Procedure MyLine(var ziel;x1,y1,x2,y2:integer;col:byte);
{Linie wird nicht dargestellt wenn einer der Punkte auáerhalb des Bildschirms}
Begin
 if ((x1>0) and (x1<319) and ((x2>0) and (x2<319)))
    and ((y1>0) and (y1<199) and ((y2>0) and (y2<199)))
    then line(ziel,x1,y1,x2,y2,col);
End;
Begin
{$R-}
 for mx:=0 to anzx-1-1 do
  for my:=0 to anzy-1 do
  begin
   with vispoints[my,mx] do begin p1.x:=x; p1.y:=y; end;
   with vispoints[my,mx+1] do begin p2.x:=x; p2.y:=y; end;
   nicht:=false;
   if p2.x-p1.x=0 then inc(p2.x);
   if p2.y-p1.y=0 then inc(p2.y);
   col:=colors[my,mx];
   myline(dest,p1.x,p1.y,p2.x,p2.y,col);

  end;
 for mx:=0 to anzx-1 do
  for my:=0 to anzy-1-1 do
  {Linien zeichnen}
  begin
   with vispoints[my,mx] do begin p1.x:=x; p1.y:=y; end;
   with vispoints[my+1,mx] do begin p2.x:=x; p2.y:=y; end;
   nicht:=false;
   if p2.x-p1.x=0 then inc(p2.x);
   if p2.y-p1.y=0 then inc(p2.y);
   col:=colors[my,mx];
   myline(dest,p1.x,p1.y,p2.x,p2.y,col);
  end;
  if helplines then
  {Rahmen zeichnen}
  begin
   with vispoints[0,0] do begin p1.x:=x; p1.y:=y; end;
   with vispoints[anzy-1,0] do begin p2.x:=x; p2.y:=y; end;
   myline(dest,p1.x,p1.y,p2.x,p2.y,255);
   with vispoints[0,anzx-1] do begin p2.x:=x; p2.y:=y; end;
   myline(dest,p1.x,p1.y,p2.x,p2.y,255);
   with vispoints[anzy-1,anzx-1] do begin p1.x:=x; p1.y:=y; end;
   myline(dest,p1.x,p1.y,p2.x,p2.y,255);
   with vispoints[anzx-1,0] do begin p2.x:=x; p2.y:=y; end;
   with vispoints[anzy-1,0] do begin p2.x:=x; p2.y:=y; end;
   myline(dest,p1.x,p1.y,p2.x,p2.y,255);
  end;

{$R+}
End;

Procedure ClearPoints(var dest:tscreen);
{L”schen des Bilschirms}
var mx,my,mx2,my2:integer;
Begin
 filllongint(dest,16000,0);
End;

Procedure Effects;
Begin
 inc(count2);
{ setmypalette(255,32+round(sin(count2/20)*31),(count2 mod 630) div 10,32-round(sin(count2/20)*31));}
 SetMyPalette(0,0,0,8+round(sin((count1+100)/40)*8));
End;

Begin
 waitretrace;
 PointGen;
 for my:=0 to anzy-1 do for mx:=0 to anzx-1 do RotateX(Points3d[my,mx],80);
 filllongint(puffer^,16000,0);
 repeat
 if keypressed then taste:=readkey;
 if maus_rotate then
 begin
 OMaus:=Maus; {Mausstatus speichern }
 Maus_abfrage;
  for mx:=0 to anzx-1 do
  for my:=0 to anzy-1 do
 {Rotieren um Differenz der Mausposition und der alten Mausposition}
  begin
   RotateY(Points3d[my,mx],maus.x-omaus.x);
   RotateX(Points3d[my,mx],-maus.y+omaus.y);
  end;
 end;
 MakeVisual;
 ShowPoints(puffer^);
 Effects; {Spezialeffekte}
 movelongint(puffer^,screen,16000);
 filllongint(puffer^,16000,0);
 until taste=#27;
 taste:='n';
 InitPal;
End;


procedure Key_Abfrage;
begin
 if keypressed then
 taste:=readkey else taste:='n';
 case taste of
  'v':_3DView;
  'l':DoLoad;
  'r':robo_on:=not robo_on;
 end;
 Maus_Abfrage;
 Ziel_X:=Maus.X shr 2+1;
 if Ziel_X>158 then begin Ziel_X:=158;end;
 Ziel_Y:=Maus.Y;
{ Start_x:=Ziel_X;
 Start_y:=ziel_y;}
end;

begin
 Init;
 count:=0;
repeat
 CreateEnv;
for t:=1 to genauigkeit do {Iterationsalgorithmus ausfhren}
begin
 Soft_Down(objekte^,ziel^);
 Soft_Up(objekte^,ziel^);
end;
 Key_Abfrage; {Benutzersteuerung}
 find_weg;
 show_screen2(Ziel^,puffer^);
 show_weg(puffer^);
 if unmoeglich then
 begin
  show_screen2(objekte^,puffer^);
  outtextxy2(10,10,'Wegberechnung nicht m”glich!',255,puffer^);
  for ky:=0 to 2 do for kx:=0 to 2 do if kreuz[ky,kx]>0 then
  if (maus.y>0) and (maus.x>0) and (maus.x<636) and (maus.y<200) then puffer^[maus.y-1+ky,(maus.x shr 1)-1+kx]:=kreuz[ky,kx];
 end;
 waitretrace;
 movelongint(Puffer^,Screen,16000);
until taste=#27;
 Final;
end.