{Konrad Hîffner 1998 - neueste Kreation}
{Hallo Simon!
Hier mein Beispielprogramm
Wie du wÅnschtest, ausfÅhrlich kommentiert
- Maus habe ich hier noch mit drin
        DOS-Maustreiber nicht vergessen!
         Der Rest des Programms kommt noch + Fehlerbehebung (Bereichs
                                                            Åberschreitungen)
        Ruf doch mal an!}


uses crt;
type screentype=array[0..199,0..319] of byte; {Bildschirmvariablentyp
                                              fÅr 13h
     wegen der Arraystruktur kommt y zuerst}
var  palette:array[0..767] of byte;
     screen:screentype absolute $a000:0; { $a000:0 ist der
      Bildspeicher. Bedeutet: wenn ich die Variable Ñndere, Ñndert
      sich auch der Bildspeicher, da die Variable die 320*200=64000 Bytes
      des Bildspeichers Åberdeckt}

     x,y:word;
     maus:boolean;
     knopf:byte;        {Maustaste}
     taste:char;  {    72
                    75    77    <- Cursor's
                       80    }


{also...  256 Farben, je 1Byte fÅr Rot,GrÅn,Blau (in dieser Reihenfolge)
Beispiel: Farbe 4 soll ein mittleres GrÅn sein

Allgemein:
palette[farbe*3-1+0 bei Rot, 1 bei GrÅn, 2 bei Blau]:=0..255
                                                  (0=nichts, 255 am hellsten)
zurÅck zum Beispiel->palette[4*3-1]:=0; Rot auf 0
                     palette[4*3-1+1]:=128; GrÅn auf die HÑlfte
                     palette[4*3-1+2]:=0; Blau auf 0

                     alles verstanden? - OK, weiter}

procedure setpal;assembler;{Ziemlich kompliziert,Tipp's einfach ab.
                           Kurzfassung: Palette als Variablenarray
                           -> in Graphikspeicher der Graphikkarte
                           wenn du's trotzdem wissen willst, etwas erklÑrt:}
asm                         {Assembler folgt}
 push si
 mov si,offset palette      {Zeiger auf Palettenadr.}
 mov cx,256*3               {ZÑhler cx (sowas wie'n word) auf's Ende von Pal.}
 xor al,al                  {al auf 0... na ja, ist dir hier alles }
 mov dx,03c8h               {vielleicht zu kompliziert mit Assembler und so}
 out dx,al
 inc dx
 rep outsb
 pop si
end;

procedure waitvret; {als Delay-Ersatz}
begin
repeat until (port[$3da] and 8) =0; {wartet, bis Elektronenstrahl des
Monitors gerade auf den Bildschim schreibt}
repeat until (port[$3da] and 8) <>0;
{wartet, bis Elektronenstrahl des
Monitors gerade wieder hochgeht}
end;
{Zusammenfassung: Wenn dein Monitor mit 85Hz lÑuft, wartets 'ne
                  85'stel Sekunde -> garantiert kein Flackern/Flimmern
                  wenn's schnell genug ist, da am Ende der Prozedur gerade
                  nicht auf den Bildschirm geschrieben wird, ist also
                  vielseitig verwendbar.
                  Wenn's nur nicht flimmern soll, nimm mal nur Zeile 2}
procedure maus_an;assembler;
asm  {ja, schon wieder Assembler... muss aber sein}
  {stell dir ax/bx/cx/dx als Word-Variablen vor}
  mov ax,0 {ax:=0 (xor ax,ax wÑre ein paar Takte schneller)}
  mov bx,0 {bx:=0}
  int 33h  {33h=33 hexadezimal ($33), da sitzt der Maustreiber}
end;

procedure mausxy; {fragt Maus ab}

begin
 asm
  mov ax,3  {sagt dem Maustreiber, das ich die Positionen haben will}
  int 33h
  mov x,cx  {x-Position wird in cx abgelegt}
  mov y,dx  {y in dx}
  mov knopf, bl {wenn Taste gedrÅckt, bl>0 -> knopf auch}
 end;
end;


begin {los geht's:}
 y:=10;
 x:=10;
 maus_an;
 knopf:=0;
 writeln('Konrad''s Tolles Beispielprogramm');
 writeln;
 writeln('1: Tastatur');
 writeln('2: Maus');
 taste:=readkey;
 if taste='1' then maus:=false else maus:=true;
  asm {nochmal Assembler}
   mov ax,13h {Modus 13h: 320*200 mit 256Farben (mov ax,3 wÑre Textmodus)}
   int 10h    {Graphikkarteninterrupt}
  end;
 repeat
  if not maus then
  begin
   taste:=readkey;
   case taste of                   {    72     }
    #72:dec(y);                    { 75    77  }
    #80:inc(y);                    {    80    }
    #75:dec(x);
    #77:inc(x);
   end;
  end;
  if maus then mausxy;
  screen[y,x]:=15;
 until (knopf>0) or (taste=#27); {bis Maustaste oder Esc}
end.