{ÄÄÄÄÄÄÄÄÄÄUnit NavigateÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
šbernimmt die vom Windows-Programm "Easy Control" erstellte
Raumdefinitionsdatei, die Gestalt und Gr”áe des Raumes,
Anzahl, Art und Lage von Hindernissen,
aktuelle und zu erreichende Position des Roboters und bei der
Navigation behilfliche Landmarken. Mit Hilfe dieser Daten wird dann
mit unserem Navigationsalgorithmus das interne Speicherabbild der Umgebung
so bearbeitet, so daá nun jedes Planquadrat sein eigene Entfernung zum Ziel
speichert. Damit sind in diesem Speicherfeld die krzesten Routen von jedem
beliebigen Kartenpunkt zum Ziel gespeichert, da an dieser Stelle nur noch
"Findroute" ansetzen und vom gew„hlten Punkt in Richtung geringerer Entfernung
(=gr”áerer Speicherwerte) durchlaufen muá. Die dabei erreichten Punkte werden
in einem weiteren Feld gespeichert, daá dann an die Unit "Drive" weitergegeben
wird, um diese weiterzuverarbeiten (s. Unit Drive).
Auáerdem ist die Komponente "Navigate" in der Lage, die bei der Navigation
eine Rolle spielenden Werte leicht verst„ndlich in Form von Helligkeits-
abstufungen zu visualisieren.
}
unit navigate;
interface

uses drive,_32bit;
const hoehe=200;
      breite=160;
      dec1=10;{der Werteabstand von 2 direkt benachbarten Feldern
               y
             y x y  x - Feld
               y    y - benachbarte Felder
      }
      obj_maxanz=100;

      oi=254 shl shift;{shl Verstaerkung}
      Ziel_Intensity:word=(255 shl shift)-1;
      unmoeglich:boolean=false;
      genauigkeit=2;
      maxx=159;
      maxy=199;
type Trect=record
            x1,y1,x2,y2:word;
           end;
const anzb=4;
var  o:array[1..obj_maxanz] of tRect; {Hindernisse}
     obj_count:integer;

procedure NS_Init;
procedure NS_findroute;
procedure NS_LoadMap(filename:string);
Procedure NS_Wave;
Procedure NS_blaeh;
implementation

procedure NS_blaeh;
var t:word;
begin
 for t:=1 to obj_count do with o[t] do
 begin
  if x1>anzb then x1:=x1-anzb else x1:=0;
  if y1>anzb then y1:=y1-anzb else y1:=0;
  if x2+anzb<maxx-anzb then inc(x2,anzb) else x2:=maxx;
  if y2+anzb<maxy-anzb then inc(y2,anzb) else y2:=maxy;
 end;
end;

Procedure Soft_Down(var obj,target);assembler;
asm
  push ds
  lds si,target             {Zeiger auf Zielbild laden}
  les di,obj

  mov cx,hoehe
  add si,320{array beginnt mit "-1"}
  add di,320
  xor bx,bx
@Loop_y:
  mov dx,breite-1{160-1! - kein "die Welt ist rund"-Effekt}
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
{Obj??}
  mov bx,es:[di+320]
  or bx,bx
  jne @weiter
  mov [si+320],ax
  @weiter:
{ÄÄÄÄÄÄRechtsÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
  mov bx,[si+2]
  cmp bx,ax
  jge @weiter2
{Obj??}
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

procedure NS_Findroute;
const
    anz=8;
    add_matrix:array[1..anz] of array[0..1] of shortint=((-1,-1),(1,1),(1,-1),(-1,1),(0,-1),(0,1),(-1,0),(1,0));
var y,x,current,dx,dy,min,min_nr,dort:integer;
    aenderung:boolean;
Procedure Add(nx,ny:shortint);
Begin
 inc(count);
 inc(x,nx);
 inc(y,ny);
 wp[count].x:=x;
 wp[count].y:=y;
 current:=ziel^[y,x];
 aenderung:=true;
End;
Procedure DoIt(Nr:word;wert:integer);
Begin
 min_nr:=nr;
 min:=wert;
End;
begin
 y:=p.y;
 x:=p.x;
 count:=0;
 if objekte^[pZiel.y,pZiel.x]=0 then
 begin
  unmoeglich:=false;
 repeat
  dx:=pZiel.x-p.x;
  dy:=pZiel.y-p.y;
  aenderung:=false;
  current:=ziel^[y,x];
  min:=current;
  dort:=ziel^[y-1,x-1]; if dort>min then DoIt(1,dort);
  dort:=ziel^[y+1,x+1]; if dort>min then DoIt(2,dort);
  dort:=ziel^[y-1,x+1]; if dort>min then DoIt(3,dort);
  dort:=ziel^[y+1,x-1]; if dort>min then DoIt(4,dort);
  dort:=ziel^[y-1,x]; if dort>min then DoIt(5,dort);
  dort:=ziel^[y+1,x]; if dort>min then DoIt(6,dort);
  dort:=ziel^[y,x-1]; if dort>min then DoIt(7,dort);
  dort:=ziel^[y,x+1]; if dort>min then DoIt(8,dort);
  if min<>current then Add(add_matrix[min_nr][0],add_matrix[min_nr][1]);

{  ziel^[y,x]:=ziel^[y,x] or $4000;}
  if not aenderung then inc(count);
 until (current=ziel_intensity) or (count>=2000);
{ show_weg;}
 end else unmoeglich:=true;
end;

Procedure NS_Wave;
var t:word;
begin
 for t:=1 to genauigkeit do
 begin
  Soft_Down(objekte^,ziel^);
  Soft_Up(objekte^,ziel^);
 end;
end;

procedure NS_Init;
begin
 Getmem(Objekte,sizeof(Karte));
 Getmem(Ziel,sizeof(Karte));
 filllongint(objekte^,sizeof(karte) shr 2,0);
 filllongint(ziel^,sizeof(karte) shr 2,0);
end;

procedure NS_LoadMap(filename:string);
var f:file;t,obj_nr:integer;
Procedure Paintobject(x1,y1,x2,y2:Integer);
var t:word;
begin
 for t:=y1 to y2 do fillword(Objekte^[t,x1],x2-x1+1,oi);
End;
Begin
 Assign(F,filename);
 Reset(F,1);
 blockread(f,Pstart,sizeof(pstart));{p.x:=2;p.y:=198;}
 p:=pStart;
 blockread(f,pZiel,sizeof(pZiel));{pZiel.x:=30;pZiel.y:=180;}
 Blockread(f,obj_count,sizeof(obj_count));
 Blockread(f,o,sizeof(trect)*obj_count);
 Close(F);
 NS_blaeh; {Aufbl„hen der Objekte !}
 for obj_nr:=1 to obj_count do with o[obj_nr] do
 PaintObject(x1,y1,x2,y2);
 Ziel^[pZiel.Y,pZiel.X]:=Ziel_Intensity;
End;

begin
end.