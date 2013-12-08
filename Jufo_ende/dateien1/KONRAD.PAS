{$R-}{$Q-}{$G+}
{ÄÄUnit KonradÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
 Universelle Allzweckunit
 Konrad H”ffner 1998/1999/2000
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

unit konrad;

interface
uses crt;
const TUp=#72;   {ASCII-Codes der Cursortastaten}
      TDown=#80; {..}
      TLeft=#75; {..}
      TRight=#77;{..}
      VID_SEG=$0a000;{Segment des Videospeichers}
type TPalette=array[0..767] of byte; {Palettenstruktur des VGA}
     tscreen=array[0..199,0..319] of byte;{Struktur}
     TPuffer=array[0..64767] of byte;{320*200+palette}
     TPos=record                     {Definition eines Punktes}
           x,y:integer;
          end;
     TMaus=record                    {Mauseigenschaften}
          x,y:integer;
          taste:byte;
         end;
     ttextscreen=array[1..25,1..80] of record z:char;a:byte end;
     {Struktur des Videospeichers im Textmodus 3}
var palette:TPalette;
    t,r:word;
    taste:char;
    screen:tscreen absolute $a000:0;{mit "absolute": screen wird auf $a000:0 gelegt,
    Zugriff: screen[y,x]:=farbe}
    screent:ttextscreen absolute $b800:0; {Textscreen beginnt bei $b800:0}
    maus:TMaus;
{ÄGrafikprozedurenÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure init13h; {Initialisiert den Videomodus 13h}
procedure setpal;  {šbertr„gt den Inhalt des arrays "palette" and den VGA-DAC}
procedure waitretrace;
{wartet, bis Kathodenstrahl des Bildschirms beginnt, zurck in die
Anfangsposition zu gleiten
Verwendung: Verhindern von Flimmern}
procedure waitdisplay;
{Wartet, bis Kathodenstrahl nach }
procedure savepal(filename:string);
{Speichert die Palette aus "palette" auf dem Datentr„ger}
procedure loadpal(filename:string);
{l„dt die Palette vom Datentr„ger in "palette"}
Procedure SetmyPalette(nr,r,g,b:byte); {Setzt auf dem VGA-DAC einen Paletteneintrag}
{ÄMausansteuerung, s. Info-Unterricht Kl.7ÄÄÄÄÄÄ}
procedure maus_init; {Initialisiert die Maus}
procedure maus_abfrage;{Abfrage des Mausstatus}
procedure setmaus(x,y:word); {Setzt Maus an x,y}
{ÄSonstigesÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
function FileExist(Filename:String):boolean;
{šberprfung einer Datei auf Existenz}
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
implementation

procedure init13h;assembler;
{Modus $13 der Unterfunktion 0 des Videointerrupts $10: 320x200x8}
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