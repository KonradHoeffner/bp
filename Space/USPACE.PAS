unit uspace;

interface
uses pcx,crt,graphic,_32bit;
const  rakete1:array[0..17] of byte=     (0,1,0,
                                         0,1,0,
                                         0,1,0,
                                         0,2,0,
                                         1,1,1,
                                         0,3,0);



      path      = 'c:\eigene~1\bp\space\'; {Spielverzeichnis}
      startbild      = path+'space.pcx';

      svga_startbild:string = path+'space.gif';
      schiff1        = path+'schiff11.pcx';
      u320x200pcx       = path+'u320x200.pcx';
      u320x200bmp       = path+'u320x200.bmp';
      s_anz          = 300;
      weite          = 40; {Reichweite der Farbverschiebung}

type bild_type=array[0..199,0..319] of byte;
     puffer_type=array[1..64768] of byte;
var  bild,bild2,bild3:^bild_type;
     grau:boolean;
     z,pal,mg_anz,mg_x:byte;
     feuer:byte;
     p:boolean;
     maxx,maxy:word;
     puffer:^puffer_type;
     t,t2,t3:word;
     s:string;
     taste:char;
     palette,paldummy:array[0..767] of byte;
     sterne:array[0..s_anz] of record
                                    x,y,ebene:integer;
                                   end;
     kugeln:array[1..501]  of record
                                    x,y:integer;
                                   end;

     zeile:array[0..319] of byte;
     spieler:record
             x,y:word;
             end;


procedure setpal;
procedure waitretrace;
procedure waitv;
procedure display;
procedure scroll;
procedure prep_wasser;
procedure palrot;
procedure prep_untergrund;
procedure prep_startbild;
procedure show;
procedure mg;
implementation

procedure mg;
begin

 for t:=1 to mg_anz do with kugeln[t] do
 begin
  if y<5 then
  begin
  dec(mg_anz);
  move(kugeln[2],kugeln,mg_anz);
  end else dec(y,random(2)+4);
  grau:=not grau;
  if grau then bild^[y,x]:=255 else bild^[y,x]:=254;
  end;
  waitv;
end;

procedure setpal;assembler;
asm
 push si
 mov si,offset palette
 mov cx,256*3
 xor al,al
 mov dx,03c8h
 out dx,al
 inc dx
 rep outsb
 pop si
end;

procedure waitretrace;
begin
repeat until (port[$3da] and $08)=0;
repeat until (port[$3da] and $08)<>0;
end;

procedure waitv;
begin
repeat until (port[$3da] and $08)<>0;
end;

procedure display;
begin
waitv;
movelongint(bild3^,bild^,16000);
end;

procedure scroll;
begin
if z<199 then inc(z) else z:=0;
movelongint(bild2^,bild3^[z,0],16000-z*80);
movelongint(bild2^[199-z,0],bild3^,z*80+80);
end;

procedure prep_wasser;
begin
fillchar(palette,768,0);
for pal:=1 to 63 do palette[pal*3+2]:=pal;

setpal;
for t:=1 to 64000 do bild3^[(t div 321),t mod 320]:=random(63);
paldummy:=palette;
end;

procedure palrot;
begin
 if p then
 begin
  if pal<weite then inc(pal) else p:=false;
 end
      else
 begin
  if pal>1 then dec(pal) else p:=true;
 end;

 for t:=1 to 200 do if p then inc(palette[t*3+2])  else dec(palette[t*3+2]);

{ for t:=1 to 255 do
 begin}
  {if p then if (palette[t*3+2]+pal)<63 then palette[t*3+2]:=(t shr 2)+pal else} palette[t*3+2]:=63;
{  if not p then palette[t*3+2]:=t shr 2;}
{ end;  }

 waitretrace;
 setpal;
end;

procedure prep_startbild;
begin
 loadpcx(startbild,puffer^,palette);

 setpal;
 movelongint(puffer^,bild^,16000);
 bild2^:=bild^;
 bild3^:=bild^;
 delay(100);
end;

procedure show;
begin
 for t:=0 to 2000 do
 begin
 display;
 outtextxy2(t shr 1,180,'1999 by KH',115,bild^);
 outtextxy2((t shr 1)+1,180,'1999 by KH',255,bild^);
 outtextxy2(t*2,130,'Design: Buschner''s Company',12,bild^);
 outtextxy2(t,150,' Rauchen gef„hrdet die Gesundheit!',115,bild^);
 outtextxy2(0,t,' Hallo ihr!!!!',115,bild^);
 waitretrace;
 if keypressed then break;
 end;
end;

procedure prep_untergrund;
begin
{ loadbmp(u320x200bmp,puffer^);
 move(puffer^[64001],palette,768);
 setpal;
 movelongint(puffer^,bild^,16000);
 bild2^:=bild^;}
end;

begin
 mg_anz:=0;
 p:=true;
 pal:=30;
 getmem(puffer,64768);
 getmem(bild,64000);
 getmem(bild2,64000);
 getmem(bild3,64000);
 bild:=ptr($a000,0);
end.

{FUNCTION  GetModePar(Modus : WORD; VAR ModeParams : ModeInf): BOOLEAN;}
{ getmodepar(t3,mode);
 writeln(mode.xres);
 writeln(mode.yres);
 readkey;}

 { s:=path+svga_startbild;
 setvesamode($103,false);}
{ loadgif(svga_startbild);}
{setvesamode($101,false);}

{ move(puffer^,bild2^,64000);}
 {z:=0;}

