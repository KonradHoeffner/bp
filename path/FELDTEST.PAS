{Achtung: Geschwindigkeit umgekehrt proportional zu "Genauigkeit" (1-3), 2 Standard}
uses crt,_32bit,_3d,upath;

const
      breite=160;
      hoehe=200;
      {컴컴훆orschau컴컴�}
      maus_rotate=true;
      dorotatex=false;
      dorotatey=false;
      helplines=false;
      anzx=30;anzy=30;
      zoom2=7*50 div anzx;
      verz1=1;{je groesser desto mehr Rechenzeit f걊 Effekte, weniger f걊 3d}
      mincol=50;{Minimaler Farbwert der dunklen Stellen}
       {컴컴컴컴컴컴컴컴컴�}
      filename='bar1.bar';
      zoom=256;
      dist:integer=600;
      robo_on:boolean=true;
      robo_fast=true;{Wenn True dann Speed=gesch sonst Speed=1/Verz}
      verz=2;
      gesch=1;
      gesch_count:byte=1;
      genauigkeit=2;
      start_x:integer =20;
      start_y:integer =50;
      Ziel_X: integer =10;
      Ziel_Y: integer =10;
      Verstaerkung=1;
{Maximum=1000 -> /4 =250}
{      ShiftRight=0;}
      shift=4;
      oi=254 shl shift;{shl Verstaerkung}
      Ziel_Intensity:word=(255 shl shift)-1;

      dec1=10;
      dec2=1;{->1.414213562 }
   obj_maxanz=255;
   obj_anz:integer=2;
   cmul=20;
   unmoeglich:boolean=false;
   kreuz:array[0..2,0..2] of byte=
   ((0,1,0),
    (1,1,1),
    (0,1,0));
type Karte=array[-1..200,0..159] of word;
     Trect=record
            x1,y1,x2,y2:word;
           end;
     TStat=(onroute,backhome);
     TSimRobo=record
               stat:TStat;
               timer:longint;
              end;
    TTable=array[0..360*cmul] of real;

var w:word;
    i:Integer;
    Objekte,Ziel:^Karte;
    x,y,mx,my:integer;
    points3d:array[0..anzy-1,0..anzx-1] of TPos3d;
    vispoints:array[0..anzy-1,0..anzx-1] of TPos;
    colors:array[0..anzy-1,0..anzx-1] of byte;
    screen1:^tscreen;
    count1,count2:word;

{Achtung: Bit 15 nicht benutzen, teilweise Integer-Verarbeitung
          Bit 14= Ziel}

    t,h,h2,m,m2,s,s2,hs,hs2:word;
    diff:real;
   count:word;

   o:array[1..obj_maxanz] of tRect; {Hindernisse}
   puffer:^tscreen;
   weg_pkte:array[1..2000] of tpos;
   count_pkte:integer;{Anzahl der Wegpkte}
    tcos,tsin:^TTable;
    omaus:TMaus;
   kx,ky:word;

Procedure CreateEnv;Forward;

Procedure InitTables;
var t:word;
Begin
 getmem(tsin,sizeof(ttable));
 getmem(tcos,sizeof(ttable));
 for t:=1 to 360*cmul do
 begin
  tsin^[t]:=sin((t/cmul)*pi/180);
  tcos^[t]:=cos((t/cmul)*pi/180);
 end;
End;

Procedure RotateZ(var src:TPos3d;wz:real);
var nx,ny,nz:real;i:integer;
Begin
 if wz<>0 then
 begin
  i:=trunc(wz*cmul);
  i:=i mod (360*cmul);
  if i<0 then inc(i,360*cmul);
  with src do
  begin
   nx:=x*tcos^[i]-y*tsin^[i];
   ny:=x*tsin^[i]+y*tcos^[i];
   x:=nx;
   y:=ny;
  end;
 end;
End;

Procedure RotateY(var src:TPos3d;wy:real);
var nx,ny,nz:real;i:integer;
Begin
 if wy<>0 then
 begin
  i:=trunc(wy*cmul);
  i:=i mod (360*cmul);
  if i<0 then inc(i,360*cmul);
  with src do
  begin
   nx:=x*tcos^[i]-z*tsin^[i];
   nz:=x*tsin^[i]+z*tcos^[i];
   x:=nx;
   z:=nz;
  end;
 end;
End;

Procedure RotateX(var src:TPos3d;wx:real);
var nx,ny,nz:real;i:integer;
Begin
 if wx<>0 then
 begin
  i:=trunc(wx*cmul);
   i:=i mod (360*cmul);
  if i<0 then inc(i,360*cmul);

  with src do
  begin
   ny:=y*tcos^[i]-z*tsin^[i];
   nz:=y*tsin^[i]+z*tcos^[i];
   y:=ny;
   z:=nz;
  end;
 end;
End;

Procedure InitPal;
Begin
 Fillchar(Palette,3,0);
 for t:=1 to 254 do
  fillchar(palette[t*3],3,t shr 2);
 palette[255*3]:=63;
 palette[255*3+1]:=0;
 palette[255*3+2]:=0;
 setpal;
End;
Procedure SaveObjs;
var f:file;t:word;
Begin
 Assign(F,filename);
 Rewrite(F,1);
 Blockwrite(f,obj_anz,sizeof(obj_anz));
 Blockwrite(f,o,sizeof(o));
 Close(F);
End;

Procedure LoadObjs;
var f:file;t:word;
Begin
 Assign(F,filename);
 Reset(F,1);
 Blockread(f,obj_anz,sizeof(obj_anz));
 Blockread(f,o,sizeof(trect)*obj_anz);
 Close(F);
End;

Procedure DoLoad;
Begin
 LoadObjs;
 CreateEnv;
End;
procedure init;
var x,y:integer;
begin
 for x:=0 to 2 do for y:=0 to 2 do
 kreuz[y,x]:=kreuz[y,x]*255;
 Getmem(Objekte,sizeof(Karte));
 Getmem(Ziel,sizeof(Karte));
 Getmem(puffer,64000);
 InitTables;
 Maus_Init;
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
  lds si,source             {fertiges Bild als Objekte}
  add si,320
  les di,target
  mov cx,160*200
  @Loop1:
  mov ax,[si]
  shr ax,Shift{Right}
  mov ah,al
  mov es:[di],ax
  add di,2
  add si,2
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
{컴컴컴Unten컴컴컴컴컴컴컴컴}
  mov bx,[si+320]
  cmp bx,ax
  jge @weiter
{Obj??}
  mov bx,es:[di+320]
  or bx,bx
  jne @weiter
  mov [si+320],ax
  @weiter:
{컴컴컴Rechts컴컴컴컴컴컴컴}
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
{컴컴컴Oben컴컴컴컴컴컴컴�}
  mov bx,[si-320]
  cmp bx,ax
  jge @weiter
{Obj??}
  mov bx,es:[di-320]
  or bx,bx
  jne @weiter

  mov [si-320],ax
  @weiter:
{컴컴컴Links컴컴컴컴컴컴컴�}
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



Procedure CreateEnv;
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
 Freemem(Objekte,sizeof(Karte));
 Freemem(Ziel,sizeof(Karte));
end;

procedure find_weg_asm(var source);assembler;
{Register: AX=Ziel BX=Vergleich}
asm
 cmp taste,72
 jne @Fehler
 lds si,source
 mov ax,160   {}
 mov dx,15
 mul dx   {}{start_y}
 add ax,start_x{Position einstellen}
 shl ax,1
 mov si,ax
@loop_weg:
 mov ax,[si]
 and ax,0100b shr 12+$fff {Bit 14 setzen}
{Oben}
 mov bx,[si-320]
 cmp bx,ax
 jna @weiter_Oben
 sub si,320
 jmp @Put_Pixel
@Weiter_Oben:
{Unten}
 mov bx,[si+320]
 cmp bx,ax
 jna @weiter_Unten
 add si,320
 jmp @Put_Pixel
@Weiter_Unten:
{Links}
 mov bx,[si-1]
 cmp bx,ax
 jna @weiter_Links
 dec si
 jmp @Put_Pixel
@Weiter_Links:
{Rechts}
 mov bx,[si+1]
 cmp bx,ax
 jna @weiter_Rechts
 inc si
 jmp @Put_Pixel
@Weiter_Rechts:
{}
jmp @Fehler {kann ja immer mal was schiefgeh'n...}
@Put_Pixel:
{ mov dx,ax}
{ or dx,0100b shr 12+$fff} {Bit 14 setzen}
{ mov si,dx}
 cmp ax,ziel_intensity
 jne @loop_weg
@Fehler:
end;

procedure show_weg(var dest:tscreen);
begin
 for t:=1 to count_pkte do with weg_pkte[t] do
 begin
  dest[y,x shl 1]:=255;
  dest[y,x shl 1+1]:=255;
 end;
end;

procedure Find_Weg_Langsam;
const
    anz=8;
    add_matrix:array[1..anz] of array[0..1] of shortint=((-1,-1),(1,1),(1,-1),(-1,1),(0,-1),(0,1),(-1,0),(1,0));
var y,x,current,dx,dy,min,min_nr,dort:integer;
    aenderung:boolean;
Procedure Add(nx,ny:shortint);
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
Begin
 min_nr:=nr;
 min:=wert;
End;
begin
 y:=start_y;
 x:=start_x;
 count_pkte:=0;
 if objekte^[ziel_y,ziel_x]=0 then
 begin
  unmoeglich:=false;
 repeat
  dx:=ziel_x-start_x;
  dy:=ziel_y-start_y;
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
  if not aenderung then inc(count_pkte);
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
procedure show_Ziel;
begin
 outtextxy2(Ziel_X,Ziel_Y,'Ziel',255,puffer^);
end;



Procedure PointGen;
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
var help:real;
    t:word;
    ix,iy:integer;
Begin
 for iy:=0 to anzy-1 do for
  ix:=0 to anzx-1 do with points3d[iy,ix] do
 begin
  help:=(z+dist)/zoom;
  if help=0 then help:=0.0001;
{$R-}
  vispoints[iy,ix].x:=trunc((x)/help)+160;
  vispoints[iy,ix].y:=-trunc((y)/help)+100;
{$R+}
 end;
End;

Procedure ShowPoints(var dest:tscreen);
const col:byte=254;
var mx,my,dx,dy:integer;
    p1,p2:TPos;
    nicht:boolean;
Procedure MyLine(seg:word;x1,y1,x2,y2:integer;col:byte);
Begin
 if ((x1>0) and (x1<319) and ((x2>0) and (x2<319)))
    and ((y1>0) and (y1<199) and ((y2>0) and (y2<199)))
    then line(seg,x1,y1,x2,y2,col);


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
   myline(seg(dest),p1.x,p1.y,p2.x,p2.y,col);
  end;
 for mx:=0 to anzx-1 do
  for my:=0 to anzy-1-1 do
  begin
   with vispoints[my,mx] do begin p1.x:=x; p1.y:=y; end;
   with vispoints[my+1,mx] do begin p2.x:=x; p2.y:=y; end;
   nicht:=false;
   if p2.x-p1.x=0 then inc(p2.x);
   if p2.y-p1.y=0 then inc(p2.y);
   col:=colors[my,mx];
   myline(seg(dest),p1.x,p1.y,p2.x,p2.y,col);
  end;
  if helplines then
  begin
   with vispoints[0,0] do begin p1.x:=x; p1.y:=y; end;
   with vispoints[anzy-1,0] do begin p2.x:=x; p2.y:=y; end;
   myline(seg(dest),p1.x,p1.y,p2.x,p2.y,255);
   with vispoints[0,anzx-1] do begin p2.x:=x; p2.y:=y; end;
   myline(seg(dest),p1.x,p1.y,p2.x,p2.y,255);
   with vispoints[anzy-1,anzx-1] do begin p1.x:=x; p1.y:=y; end;
   myline(seg(dest),p1.x,p1.y,p2.x,p2.y,255);
   with vispoints[anzx-1,0] do begin p2.x:=x; p2.y:=y; end;
   with vispoints[anzy-1,0] do begin p2.x:=x; p2.y:=y; end;
   myline(seg(dest),p1.x,p1.y,p2.x,p2.y,255);
  end;

{$R+}
End;

Procedure ClearPoints(var dest:tscreen);
var mx,my,mx2,my2:integer;
Begin
{$R-}
{ for mx:=0 to anzx-1 do
  for my:=0 to anzy-1 do with vispoints[my,mx] do
  dest[y,x]:=0;}
 filllongint(dest,16000,0);
{$R+}
End;

Procedure DoRotate;
var zahl,zahl2:real;
    mx,my:integer;

Begin
 inc(count1);
 if count1 mod verz1 = 0 then
 for mx:=0 to anzx-1 do
  for my:=0 to anzy-1 do with vispoints[my,mx] do
 begin
  zahl:=round(sin(count1/50)*5);
  zahl2:=round(sin(count1/20)*1);
  if dorotatey then RotateY(Points3d[my,mx],zahl);
  if dorotatex then RotateX(Points3d[my,mx],zahl2);
 end;
End;

Procedure Effects;
Begin
 inc(count2);
{ setmypalette(255,32+round(sin(count2/20)*31),(count2 mod 630) div 10,32-round(sin(count2/20)*31));}
 SetMyPalette(0,0,0,8+round(sin((count1+100)/40)*8));
{ outtextxy2(20+round(sin(count1/6)*12),100+round(sin(count2/10)*80),'3d Rotate Beta by Konrad 1999',255,screen1^);}
End;

Procedure _3DView;

Begin
 getmem(screen1,64000);
 waitretrace;
 PointGen;
 for mx:=0 to anzx-1 do
  for my:=0 to anzy-1 do RotateX(Points3d[my,mx],80);
 filllongint(screen1^,16000,0);
 repeat
 if keypressed then taste:=readkey;
 if maus_rotate then
 begin
 OMaus:=Maus;
 Maus_abfrage;
  for mx:=0 to anzx-1 do
  for my:=0 to anzy-1 do
  begin
   RotateY(Points3d[my,mx],maus.x-omaus.x);
   RotateX(Points3d[my,mx],-maus.y+omaus.y);
  end;
 end;
 DoRotate;
 MakeVisual;
 ShowPoints(screen1^);
 Effects;
 movelongint(screen1^,screen,16000);
 waitretrace;
 filllongint(screen1^,16000,0);
{ ClearPoints(screen1^);}

 until taste=#27;
 taste:='n';
 InitPal;
 freemem(screen1,64000);
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
for t:=1 to genauigkeit do
begin
 Soft_Down(objekte^,ziel^);
 Soft_Up(objekte^,ziel^);
end;
 Key_Abfrage;
 find_weg_langsam;
 show_screen2(Ziel^,puffer^);
 show_weg(puffer^);
 if unmoeglich then
 begin
  show_screen2(objekte^,puffer^);
  outtextxy2(10,10,'Wegberechnung nicht m봥lich!',255,puffer^);
  for ky:=0 to 2 do for kx:=0 to 2 do if kreuz[ky,kx]>0 then
  if (maus.y>0) and (maus.x>0) and (maus.x<636) and (maus.y<200) then puffer^[maus.y-1+ky,(maus.x shr 1)-1+kx]:=kreuz[ky,kx];
 end;
 waitretrace;
 movelongint(Puffer^,Screen,16000);
until taste=#27;
 Final;
end.