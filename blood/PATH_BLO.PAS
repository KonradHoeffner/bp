{Achtung: Geschwindigkeit umgekehrt proportional zu "Genauigkeit" (1-3), 2 Standard}
uses crt,konrad,_32bit,dos,_13h,_3d;

const
      filename='c:\eigene~1\bp\path\objs.dat';
      {ÄÄÄÄÄVorschauÄÄÄÄÄ}
      maus_rotate:boolean=true;
      dorotatex:boolean=false;
      dorotatey:boolean=false;
      dolines:boolean=false;
      dosoft:boolean=true;
      helplines=false;
      anzx=50;anzy=50;
      zoom2:word=7*50 div anzx;
      verz1=1;{je groesser desto mehr Rechenzeit fr Effekte, weniger fr 3d}
      mincol=50;{Minimaler Farbwert der dunklen Stellen}
       {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
      zoom=256;
      dist:integer=600;
      robo_on=true;
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
      Obj_Intensity=40;{shl Verstaerkung}
      shift=3;
      Ziel_Intensity:word=(255 shl shift)-1;

      dec1=10;
      dec2=1;{->1.414213562 }
   obj_maxanz=255;
   obj_anz:byte=2;
   cmul=20;
  blw=5;
 blh=5;

 blood1:array[0..blw*blh-1] of byte =
(0,12,12,12,0,
 12,12,24,12,12,
 12,24,24,24,12,
 12,12,24,12,12,
 0,12,12,12,0
 );

type Karte=array[-1..200,0..159] of word;
     Trect=record
            O,U,L,R:word;
           end;
     TStat=(onroute,backhome);
     TSimRobo=record
               stat:TStat;
               timer:longint;
              end;
    TTable=array[0..360*cmul] of real;
    T3dPoints=array[0..anzy-1,0..anzx-1] of TPos3d;
    TVisPoints=array[0..anzy-1,0..anzx-1] of TPos;
var w:word;
    i:Integer;
    Objekte,Ziel:^Karte;
{Achtung: Bit 15 nicht benutzen, teilweise Integer-Verarbeitung
          Bit 14= Ziel}

    t,h,h2,m,m2,s,s2,hs,hs2:word;
    diff:real;
   count:word;

   o:array[1..obj_maxanz] of tRect; {Hindernisse}
   weg_pkte:array[1..500] of tpos;
   count_pkte:integer;{Anzahl der Wegpkte}
    tcos,tsin:^TTable;
   omaus:TMaus;
   mx,my:integer;
{ÄÄÄÄÄÄÄÄÄ3D VariablenÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
    points3d:^T3dPoints;
    vispoints:^TVisPoints;
    colors:array[0..anzy-1,0..anzx-1] of byte;
    screen1:^tscreen;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄProzedurenÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure PutBlood(var src;x,y:integer;var dest);forward;
Procedure InitTables;Forward;
Procedure RotateZ(var src:TPos3d;wz:real);Forward;
Procedure RotateX(var src:TPos3d;wx:real);Forward;
Procedure RotateY(var src:TPos3d;wy:real);Forward;
Procedure CreateEnv;Forward;
Procedure InitPal;Forward;
Procedure SaveObjs;Forward;
Procedure LoadObjs;Forward;
Procedure DoSave;Forward;
Procedure DoLoad;Forward;
procedure init;Forward;
Procedure Show_Screen2(var source,target);Forward;
Procedure Soft_Down(var obj,target);Forward;
Procedure Soft_Up(var obj,target);Forward;
procedure Final;Forward;
procedure Find_Weg_Langsam;Forward;
procedure show_ziel;Forward;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ3D ProzedurenÄÄÄÄÄÄÄÄÄÄ}
Procedure PointGen;Forward;
Procedure MakeVisual;Forward;
Procedure ShowPoints(var dest:tscreen);Forward;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Procedure PutBlood(var src;x,y:integer;var dest);assembler;
asm
 push ds
 push es
 lds si,src
 les di,dest
 mov ax,320
 mul y
 add ax,x
 add di,ax
 mov dx,blh
@Loop_y:
 mov cx,blw
 @Loop_x:
 mov al,ds:[si]
{ mov al,255}
 mov bl,230
 cmp es:[di],bl
 jae @weiter
 add es:[di],al
 @weiter:
 inc di
 inc si
 dec cx
 jne @Loop_x
 add di,320
 sub di,blw
 dec dx
 jne @Loop_y
 pop es
 pop ds
End;

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
{  fillchar(palette[t*3],3,t shr 2);}setmypalette(t,0,0,t shr 2);
 palette[255*3]:=63;
 palette[255*3+1]:=0;
 palette[255*3+2]:=0;
{ setpal;}
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
 Blockread(f,o,sizeof(o));
 Close(F);
End;


Procedure DoSave;
var i:integer;
Begin
 Textmode(3);
 Writeln('Definieren sie die Objekte');
 Obj_anz:=0;
 repeat
  inc(obj_anz);
  writeln('ÄÄÄObjekt1:ÄÄÄÄÄÄÄ ');
  write('x1: ');readln(o[obj_anz].l);
  write('y1: ');readln(o[obj_anz].o);
  write('x2: ');readln(o[obj_anz].r);
  write('y2: ');readln(o[obj_anz].u);
  writeln('Weiter? (J/N)');
  taste:=readkey;
 until Upcase(taste)='N';
 SaveObjs;
 CreateEnv;
 Init13h;
End;

Procedure DoLoad;
Begin
 LoadObjs;
 CreateEnv;
End;
procedure init;
begin
 getmem(screen1,64000);
 Getmem(Objekte,sizeof(Karte));
 Getmem(Ziel,sizeof(Karte));

 Getmem(Points3d,Sizeof(T3dPoints));
 Getmem(Vispoints,Sizeof(TVisPoints));
 InitTables;
 Maus_Init;
      o[1].L:=30;
      o[1].O:=40;
      o[1].R:=60;
      o[1].U:=60;
      o[2].L:=120;
      o[2].O:=120;
      o[2].R:=140;
      o[2].U:=150;
 Init13h;
 InitPal;
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

  mov cx,200
  add si,320{array beginnt mit "-1"}
  add di,320
  xor bx,bx
@Loop_y:
  mov dx,159{160-1! - kein "die Welt ist rund"-Effekt}
@Loop_x:
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
{ÄÄÄÄÄÄUnten RechtsÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
  sub ax,DEC2
  mov bx,[si+322]
  cmp bx,ax
  jge @weiter3
{Obj??}
  mov bx,es:[di+322]
  or bx,bx
  jne @weiter

  mov [si+322],ax
  @weiter3:

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
  mov cx,200
  add di,320*201
  add si,320*201
@Loop_y:
  mov dx,159
@Loop_x:
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
{ÄÄÄÄÄÄOben LinksÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
  sub ax,DEC2
  mov bx,[si-322]
  cmp bx,ax
  jge @weiter3
{Obj??}
  mov bx,es:[di-322]
  or bx,bx
  jne @weiter3

  mov [si-322],ax
  @weiter3:

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
 for t:=y1 to y2 do fillword(Objekte^[t,x1],x2-x1+1,obj_intensity);
End;
Begin
 Filllongint(Objekte^,sizeof(Karte) shr 2,0);
 Filllongint(Ziel^,sizeof(Karte) shr 2,0);
 Ziel^[ziel_Y,Ziel_X]:=Ziel_Intensity;
 for obj_nr:=1 to obj_anz do with o[obj_nr] do
 PaintObject(L,O,R,U);
End;

procedure Final;
begin
 Textmode(3);
 Freemem(Objekte,sizeof(Karte));
 Freemem(Ziel,sizeof(Karte));
 freemem(screen1,64000);
end;

procedure Find_Weg_Langsam;
const
    anz=8;
    add_matrix:array[1..anz] of array[0..1] of shortint=((-1,-1),(1,1),(1,-1),(-1,1),(0,-1),(0,1),(-1,0),(1,0));

var y,x,current,dx,dy,min,min_nr,dort:integer;
    aenderung:boolean;

procedure show_weg;
begin
 for t:=1 to count_pkte do with weg_pkte[t] do ziel^[y,x]:=255 shl shift;
end;

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
 until (current=ziel_intensity) or (count_pkte>=500);
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

 show_weg;
end;
procedure show_Ziel;
begin
 outtextxy2(Ziel_X,Ziel_Y,'Ziel',255,screen1^);
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
   points3d^[y,x].x:=(x-(anzx shr 1))*zoom2;
   points3d^[y,x].y:=(y-(anzy shr 1))*zoom2;
   {$R-}
   colors[y,x]:=ziel^[my,mx] shr shift;
   if colors[y,x]<mincol then colors[y,x]:=mincol;
   {$R+}
   points3d^[y,x].z:=colors[y,x] shr 1;
  end;

End;
Procedure MakeVisual;
var help:real;
    t:word;
    ix,iy:integer;
Begin
 for iy:=0 to anzy-1 do for
  ix:=0 to anzx-1 do with points3d^[iy,ix] do
 begin
  help:=(z+dist)/zoom;
  if help=0 then help:=0.0001;
{$R-}
  vispoints^[iy,ix].x:=trunc((x)/help)+160;
  vispoints^[iy,ix].y:=-trunc((y)/help)+100;
{$R+}
 end;
End;

Procedure ShowPoints(var dest:tscreen);
const col:byte=50;
var mx,my,dx,dy:integer;
    p1,p2:record x,y:longint; end;
    nicht:boolean;
Procedure MyLine(seg:word;x1,y1,x2,y2:integer;col:byte);
Begin
 if ((x1>0) and (x1<319) and ((x2>0) and (x2<319)))
    and ((y1>0) and (y1<199) and ((y2>0) and (y2<199)))
    then line(seg,x1,y1,x2,y2,col);
End;
Begin
{$R-}
 if dolines then
 begin
 for mx:=0 to anzx-1-1 do
  for my:=0 to anzy-1 do
  begin
   with vispoints^[my,mx] do begin p1.x:=x; p1.y:=y; end;
   with vispoints^[my,mx+1] do begin p2.x:=x; p2.y:=y; end;
   nicht:=false;
   if p2.x-p1.x=0 then inc(p2.x);
   if p2.y-p1.y=0 then inc(p2.y);
{   col:=colors[my,mx];}
   myline(seg(dest),p1.x,p1.y,p2.x,p2.y,col);
  end;
 for mx:=0 to anzx-1 do
  for my:=0 to anzy-1-1 do
  begin
   with vispoints^[my,mx] do begin p1.x:=x; p1.y:=y; end;
   with vispoints^[my+1,mx] do begin p2.x:=x; p2.y:=y; end;
   nicht:=false;
   if p2.x-p1.x=0 then inc(p2.x);
   if p2.y-p1.y=0 then inc(p2.y);
{   col:=colors[my,mx];}
   myline(seg(dest),p1.x,p1.y,p2.x,p2.y,col);
  end;
  end;
   if dosoft then
   for mx:=0 to anzx-1 do
  for my:=0 to anzy-1 do
   with vispoints^[my,mx] do if ((y>0) and (y<199)and ((x>10) and (x<300)))then putblood(blood1,x,y,screen1^);

  if helplines then
  begin
   with vispoints^[0,0] do begin p1.x:=x; p1.y:=y; end;
   with vispoints^[anzy-1,0] do begin p2.x:=x; p2.y:=y; end;
   myline(seg(dest),p1.x,p1.y,p2.x,p2.y,255);
   with vispoints^[0,anzx-1] do begin p2.x:=x; p2.y:=y; end;
   myline(seg(dest),p1.x,p1.y,p2.x,p2.y,255);
   with vispoints^[anzy-1,anzx-1] do begin p1.x:=x; p1.y:=y; end;
   myline(seg(dest),p1.x,p1.y,p2.x,p2.y,255);
   with vispoints^[anzx-1,0] do begin p2.x:=x; p2.y:=y; end;
   with vispoints^[anzy-1,0] do begin p2.x:=x; p2.y:=y; end;
   myline(seg(dest),p1.x,p1.y,p2.x,p2.y,255);
  end;

{$R+}
End;

Procedure _3DAbfrage;
Begin
  case taste of
     'x':dorotatex:=not dorotatex;
   'y':dorotatey:=not dorotatey;
   'm':maus_rotate:=not maus_rotate;
   'l':dolines:=not dolines;
   's':dosoft:=not dosoft;

  end;
End;
Procedure _3DView;
var x,y,mx,my:integer;
    count1,count2:word;

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
  for my:=0 to anzy-1 do with vispoints^[my,mx] do
 begin
  zahl:=round(sin(count1/50)*5);
  zahl2:=round(sin(count1/20)*1);
  if dorotatey then RotateY(Points3d^[my,mx],zahl);
  if dorotatex then RotateX(Points3d^[my,mx],zahl2);
 end;
End;

Procedure Effects;
Begin
 inc(count2);
{ setmypalette(255,32+round(sin(count2/20)*31),(count2 mod 630) div 10,32-round(sin(count2/20)*31));}
 SetMyPalette(0,0,0,8+round(sin((count1+100)/40)*8));
{ outtextxy2(20+round(sin(count1/6)*12),100+round(sin(count2/10)*80),'3d Rotate Beta by Konrad 1999',255,screen1^);}
End;

Begin
 waitretrace;
 PointGen;
 for mx:=0 to anzx-1 do
  for my:=0 to anzy-1 do RotateX(Points3d^[my,mx],80);
 filllongint(screen1^,16000,0);
 repeat
 if keypressed then
 begin
  taste:=readkey;
  _3DAbfrage;
 end;

 if maus_rotate then
 begin
 OMaus:=Maus;
 Maus_abfrage;
 case maus.taste of
  1:begin inc(zoom2);pointgen;end;
  2:begin dec(zoom2);pointgen;end;
 end;
  for mx:=0 to anzx-1 do
  for my:=0 to anzy-1 do
  begin
   RotateY(Points3d^[my,mx],maus.x-omaus.x);
   RotateX(Points3d^[my,mx],-maus.y+omaus.y);
  end;
 end;
 DoRotate;
 MakeVisual;
 ShowPoints(screen1^);
{ Effects;}
 movelongint(screen1^,screen,16000);
 waitretrace;
 filllongint(screen1^,16000,0);
{ ClearPoints(screen1^);}

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
  'L':DoLoad;
  'S':DoSave;
   'x':dorotatex:=not dorotatex;
   'y':dorotatey:=not dorotatey;
   'm':maus_rotate:=not maus_rotate;
   'l':dolines:=not dolines;
   's':dosoft:=not dosoft;
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
 filllongint(screen,16000,0);
repeat
 CreateEnv;
for t:=1 to genauigkeit do
begin
 Soft_Down(objekte^,ziel^);
 Soft_Up(objekte^,ziel^);
end;
 Key_abfrage;
{ find_weg_langsam;}
{ show_screen2(Ziel^,puffer^);}
 PointGen;
 for mx:=0 to anzx-1 do
  for my:=0 to anzy-1 do RotateX(Points3d^[my,mx],80);

 MakeVisual;
 ShowPoints(screen1^);
{ show_Ziel;}
 waitretrace;
 movelongint(screen1^,Screen,16000);
 filllongint(screen1^,16000,0);
until taste=#27;
 Final;
end.