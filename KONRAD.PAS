{$R-}{$Q-}{$G+}
unit konrad;

interface
uses crt;
const TUp=#72;
      TDown=#80;
      TLeft=#75;
      TRight=#77;
      VID_SEG=$0a000;
type TPalette=array[0..767] of byte;
     tscreen=array[0..199,0..319] of byte;
     TPuffer=array[0..64767] of byte;{320*200+palette}
     TPos=record
           x,y:integer;
          end;
     TMaus=record
          x,y:integer;
          taste:byte;
         end;
     ttextscreen=array[1..25,1..80] of record z:char;a:byte end;
var palette:TPalette;
    t,r:word;
    taste:char;
    screen:tscreen absolute $a000:0;
    screent:ttextscreen absolute $b800:0;
    maus:TMaus;
procedure init13h;
procedure setmaus(x,y:word);
procedure setpal;
procedure waitretrace;
procedure waitdisplay;
procedure maus_init;
procedure maus_abfrage;
procedure savepal(filename:string);
procedure loadpal(filename:string);
procedure fade_in(var ZielPal:TPalette;anz:word);
procedure fade_out(anz:word);
function FileExist(Filename:String):boolean;
Procedure SetmyPalette(nr,r,g,b:byte);
implementation

procedure init13h;assembler;
asm
 mov ax,13h
 int 10h
end;

function FileExist(Filename:String):boolean;
var f:File;
begin
 assign(F,Filename);
{$I-}
 Reset(F);
 Close(F);
{$I+}
 If Ioresult=0 then Fileexist:=True else Fileexist:=False;

end;

procedure fade_in(var ZielPal:Tpalette;anz:word);
var t,w:word;
begin
 for t:=1 to anz do
 begin
  waitretrace;
  setpal;
  for w:=0 to 767 do
  palette[w]:=round(zielpal[w]{/anz*t}*sin((t-1.2)/anz*90*pi/180));
{ palette[w]:=round(zielpal[w]/anz*t);}
{ if palette[w]<zielpal[w] then inc(palette[w]);{}
   if keypressed then begin palette:=zielpal;setpal;break;end;
 end;
end;
{}
procedure fade_out(anz:word);
var t,w:word;zielpal:TPalette;
begin
 zielpal:=palette;
 for t:=anz downto 1 do
 begin
  {for w:=0 to 768 do palette[w]:=trunc((t*zielpal[w]) div anz);}
    waitretrace;
    setpal;
  for w:=0 to 767 do
   palette[w]:=round(zielpal[w]{/anz*t}*sin((t-1.2)/anz*90*pi/180));
{   palette[w]:=round(zielpal[w]/anz*t);}
{  if palette[w]<zielpal[w] then inc(palette[w]);{}
   if keypressed then begin fillchar(palette,768,0);setpal;break;end;
 end;

  fillchar(palette,768,0);
  setpal;
end;

procedure setmaus(x,y:word);assembler;
asm
 mov cx,x
 mov dx,y
 mov ax,4
 int 33h
end;

procedure savepal(filename:string);
var f:file;
begin
 if pos('.',filename)=0 then filename:=filename+'.pal';
 assign(f,filename);
 rewrite(f,1);
 blockwrite(f,palette,768);
 close(f);
end;

procedure loadpal(filename:string);
var f:file;
begin
 if pos('.',filename)=0 then filename:=filename+'.pal';
 assign(f,filename);
 reset(f,1);
 blockread(f,palette,768);
 close(f);
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

Procedure SetmyPalette(nr,r,g,b:byte);assembler;
asm
 mov dx,03c8h
 mov al,nr
 out dx,al
 inc dx
 mov al,r
 out dx,al
 mov al,g
 out dx,al
 mov al,b
 out dx,al
End;

procedure waitretrace;
begin
repeat until (port[$3da] and $08)<>0;
repeat until (port[$3da] and $08)=0;
end;

procedure waitdisplay;
begin
repeat until (port[$3da] and $08)=0;
repeat until (port[$3da] and $08)<>0;
end;


procedure maus_init;assembler;
asm
 mov ax,0
 mov bx,0
 int 33h
end;

procedure maus_abfrage;assembler;
asm
 mov ax,3
 int 33h
 mov maus.taste,bl
 mov maus.x,cx
 mov maus.y,dx
end;

end.