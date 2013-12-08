unit init;{Ver 3.08 vom 02.05.97 letzte énderung: 15:00 Uhr
ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ Anmerkung zu gr- und getmouseposition (button) ÕÕÕÕÕÕÕÕÕÕÕÕÕÕ
 1: linke               Maustaste
 2: rechte              Maustaste
 3: rechte und linke    Maustaste
 4: mittlere            Maustaste
 5: rechte und mittlere Maustaste
 6: linke und mittlere  Maustaste
ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ SVGA des BIOS mit Farben und Speicher ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ
 Grafikmodi  Auflîsung   Farben   Speicher      GranularitÑt  Bytes pro Pixel
   100        640*400     256        256 KByte     64                8
   101        640*480     256        512 KByte     64                8
   102        800*600      16        256 KByte     64                4
   103        800*600     256        512 KByte     64                8
   104       1024*768      16        512 KByte     64                4
   105       1024*768     256          1 MByte     64                8
   106       1280*1024     16          1 MByte     64                4
   107       1280*1024    256       1,25 MByte     64                8
   109        132*25       16     (Textmode)       32
   10a        132*43       16     (Textmode)       32
   110        640*480     32k                      64               15
   111        640*480     64k                      64               16
   112        640*480     16M                      64               32
   113        800*600     32k                      64               15
   114        800*600     64k                      64               16
   115        800*600     16M                      64               32
   116       1024*768     32k                      64               15
   117       1024*768     64k                      64               16
   118       1024*768     16M                      64               32
   119       1280*1024    32k                      64               15
   11a       1280*1024    64k                      64               16
   120       1600*1200    256                      64                8
   201        640*480                              64                8
   202        800*600                              64                4
   203        800*600                              64                8
   204       1024*768                              64                4
   205       1024*768                              64                8
   207       1152*864                              64                8
   208       1280*1024                             64                4
ÕÕÕÕÕÕ Auflîsungen und Farben der von Borland mitgeliferten Treibern ÕÕÕÕÕÕÕÕÕ
 Treiber Modus Auflîsung Farben
 ibm8514   0    640x480    16
 ibm8514   1   1024x768    16
 att       0    320x200     4
 cga       0    720x350     2
 egavga    0    640x200    16
 egavga    1    640x350    16
 egavga    2    640x480    16
 herc      0    720x348   unbekannt
 pc3270    0    720x340     2
 vga256    0    320x200   256
 vesa      0    320x200   256
 vesa      1    640x400   256
 vesa      2    640x480   256
 vesa      3    800x600   256
 vesa      4   1024x768   256
 vesa16    0    800x600    16
 vesa16    1   1024x768    16
 vesa16    2   1280x1024   16
 vesa256   0    320x200   256
 vesa256   1    640x400   256
 vesa256   2    640x480   256
 vesa256   3    800x600   256
 vesa256   4   1024x768   256
 svga386   0    320x200   256
 svga386   1   1024x768   256
 svga386   2    640x400   256
 svga386   3    640x480   256
 svga386   4    800x600   256
 svga256   0    320x200   256
 svga256   1    640x400   256
 svga256   2    640x480   256
 svga256   2    800x600   256
ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ Aufbau einer *.tes Datei ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ
offset grî·e                ErklÑrung
  1      9     Wenn nicht "Dr. Robbe" dann keine Tes Datei (wird ab sofort
               nicht mehr benutzt)
  10     1     Wenn erstes Byte null dann kein Hintergrundbild sonst eins
  11     1     Anzahl der Bilder
  12     2     Grî·e des Hintergrundbildes (nur wenn vorhanden)
  13     n     n = siehe offset 2 mal 2 Breite und Hîhe in Pixel
  14     768   Paletten Daten
  782    n     Hintergrundbild (wenn vorhanden)
  783    n     Weiter bilddaten
         Zum *.dl Format
Das 22 Byte anzahl der Bilder.
Ab 24 Byte Farbepalette.
Und dann Grafikdaten.
ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ Variable Grapherror ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ
    0     =     kein Fehler aufgetretten
    1     =     Mode 13h nicht initiealisert
}

interface

uses dos,crt,graph,modexlib;

const unterstrich=0;
      block=1;
      unsichtbar=2;
      uok:boolean=true;
      pather='C:\BP\BGI';{Path fÅr BGI Dreiber und Fonts}
      gifpath='C:\BP\GIF\';{Path fÅr gepackte Bilder}
      dbmpath='C:\konrad\bp\';{Path fÅr einfache Bilder}
      SCRL=16;{Scroll-Lock-Bit}
      NUML=32;{Num-Lock-Bit}
      CAPL=64;{Caps-Lock-Bit}
      INS=128;{Insert-Bit}
      _virtualvseg:Word=$A000;
      virtualvseg:Word=$A000;
      hexconst:array[0..15]of char=('0','1','2','3','4','5','6','7','8','9',
                                    'A','B','C','D','E','F');
      binconst:array[1..8]of byte=(128,64,32,16,8,4,2,1);
      dubblebinconst:array[1..16]of word=(32768,16384,8192,2096,2048,1024,512,
                                          256,128,64,32,16,8,4,2,1);
      tribblebinconst:array[1..24]of longint=(8388608,4194304,2097152,1048576,
                                              524288,262144,131072,65536,32768,
                                              16384,8192,2096,2048,1024,512,
                                              256,128,64,32,16,8,4,2,1);
      wink=360-45;

type wordf=word;
     codefile=record
               bat:array[1..53]of string;
              end;
     winpal=record
             b,g,r,d:byte;
            end;
     windac=array[0..256]of winpal;
     dospal=record
             r,g,b:byte;
            end;
     dosdac=array[0..256]of dospal;
     farle=array[0..2]of byte;
     tdacblock=array[0..256]of farle;
     hextype=array[0..1]of char;
     binaer=0..1;
     bintype=array[1..8]of binaer;
     dubblebin=array[1..16]of binaer;
     tribblebin=array[1..24]of binaer;
     lw=array[1..26]of boolean;
     vesatype=record
               flag:word;
               w1flag:byte;w2flag:byte;
               movesize:word;
               wsize:word;
               w1seg:word;
               w2seg:word;
               movewindow:pointer;
               bytes:word;
               maxx:word;
               maxy:word;
               dummy:array[0..2]of byte;
               bits:byte;
               dummy2:array[0..2]of byte;
              end;
    trid=0..16777216;

var anzbutton,button,xmouse,ymouse,altxmouse,altymouse:byte;
    mouseok,h13,sb:boolean;orgimode,grapherror:word;
    laufwerke:lw;maxxkoor:word;l:word;

procedure egavgadriverproc;
{1   Bindet egavga.obj mit eine .EXE Datei mit ein}
procedure initbegin;
{2   Initzialisiert den 640x480 Grafikmodus}
procedure initbegin16;
{3   Initzialisiert den 800x600 oder den 1280x1024 Grafikmodus}
procedure initend;
{4   Beendet den Grafikmodus}
procedure initbigdos;
{5   Intizialisiert eine hohe Auflîsung im Textmodus}
procedure endbigdos;
{6   Schlie·t hohe Auflîsung}
procedure dreieck(x1,x2,y1,y2,z1,z2:integer;farbe:word);
{7   Zeichnet ein Dreieck in Farbe}
procedure odreieck(x1,x2,y1,y2,z1,z2:integer;farbe:word);
{8   zeichnet einen Winkel in Farbe}
procedure viereck(w1,w2,x1,x2,y1,y2,z1,z2:integer;farbe:word);
{9   Zeichnet ein viereck in Farbe}
procedure oviereck(w1,w2,x1,x2,y1,y2,z1,z2:integer;farbe:word);
{10  Zeichnet ein offnes Viereck in Farbe}
procedure cline(x1,x2,y1,y2:integer;farbe:word);
{11  Zeichnet eine Linie in Farbe}
procedure ton(hz,ms:integer);
{12  Erzeugt einen Ton}
procedure outtextstyle(x,y:integer;textstring:string;farbe:word;Font,Direction:Word;CharSize:Word);
{13  Schreibt einen Text an einem Ort in Farbe und mit Schriftart}
procedure palrgb;
{14  Setzt eine neu Farbpalette}
procedure palhelp;
{15  Setzt eine neu Farbpalette}
procedure pfeil(nummer:byte;x,y:integer;farbe:word);
{16  Zeichnet einen Pfeil in Farbe}
procedure pfeil2(nummer:byte;x,y:integer;farbe:word);
{17  Zeichnet einen Pfeil in Farbe}
procedure ende;
{18  Endet mit: "Copyright (c) by Robin Ledig 1996"}
procedure ende2;
{19  Endet mit: "Copyright (c) by Thomas Plîtze and Robin Ledig 1996"}
procedure font;
{20  Installiert neue Schriftarten}
procedure font2;
{21  Installiert neue Schriftarten}
procedure kreuz(x,y,a,b:integer;farbe:word);
{22  Zeichnet ein Kreuz in Farbe}
procedure dreipunkt(x,y,i:integer;n:byte);
{23  Zeichnet ein Dreieck um einen Punkt mit Abstand}
procedure rundeck(x1,y1,x2,y2:integer;n:byte;farbe:word);
{24  Zeichnet ein Viereck das abgerundet wird und in Farbe}
procedure cursoron;
{25  Schaltet den Cursor ein}
procedure cursoroff;
{26 Schlatet den Cursor aus}
procedure cursorblock;
{27  Verwandelt den Cursor in einen Block}
procedure mainwindow(header:string);
{28  Legt ein beschriftetes Fenster fest}
procedure statusline(msg:string);
{29  Beschriftet eine Statuszeile}
procedure fenster(x1,y1,x2,y2:integer;n,farbe:byte);
{30  Zeichnet ein Fenster in Farbe}
procedure fenstere(x1,y1,x2,y2:integer;farbe:byte);
{31  Zeichnet ein Fenster in den Bildschirmspeicher}
procedure fensterschatten(x1,y1,x2,y2:integer;f1,f2:byte);
{32  Zeichnet ein Fenster in Farbe mit Schatten}
function kleiningross(str:string):string;
{33  Verwandelt Kleinbuchstaben in Gro·buchstaben}
procedure initmouse(var anzbutton:Byte;var mouseok:boolean);
{34  Initalisiert mouse}
procedure softtextmouse(screenmask,cursormask:word);
{35  Initzialisirt das Aussehen der Maus}
procedure showmouse;
{36  Zeigt Maus}
procedure hidemouse;
{37  Versteckt Maus}
procedure grgetmouseposition(var button:byte;var x,y:word);
{38  Gibt Mausposition im Grafikmodus}
procedure getmouseposition(var button,x,y:byte);
{39  Gibt Mausposition}
procedure grsetmouseposition(x,y:word);
{40  Setzt Maus auf Position im Grafikmodus}
procedure setmouseposition(x,y:byte);
{41  Setzt Maus auf Position}
procedure grmousewindow(x1,y1,x2,y2:word);
{42  Zwingt Maus in Fenster im Grafikmodus}
procedure mousewindow(x1,y1,x2,y2:byte);
{43  Zwingt Maus in Fenster}
procedure wait;
{44  Wartet auf Tastendruck oder Mausdruck}
procedure cursormode(ctyp:byte);
{45  bestimmt den Modus des cursors}
procedure button1(x1,y1,x2,y2:integer;str:string);
{46  Zeichnet einen Knopf mit einer Zeile}
procedure button2(x1,y1,x2,y2:integer;str1,str2:string);
{47  Zeichnet einen Knopf mit zwei Zeilen}
procedure button3(x1,y1,x2,y2:integer;str:string);
{48  Zeichnet einen Knopf mit einer Zeile}
procedure button4(x1,y1,x2,y2:integer;str1,str2:string);
{49  Zeichnet einen Knopf mit zwei Zeilen}
procedure markbutton1(x1,y1,x2,y2:integer;str:string);
{50  Zeichnet einen Markierten Knopf mit einer Zeile}
procedure markbutton2(x1,y1,x2,y2:integer;str1,str2:string);
{51  Zeichnet einen Markierten Knopf mit zwei Zeile}
procedure pressbutton1(x1,y1,x2,y2:integer;str:string);
{52  Zeichnet einen gedrÅckten Knopf mit einer Zeile}
procedure pressbutton2(x1,y1,x2,y2:integer;str1,str2:string);
{53  Zeichnet einen gedrÅckten Knopf mit zwei Zeilen}
procedure pressbutton3(x1,y1,x2,y2:integer;str:string);
{54  Zeichnet einen gedrÅckten Knopf mit einer Zeile}
procedure pressbutton4(x1,y1,x2,y2:integer;str1,str2:string);
{55  Zeichnet einen gedrÅckten Knopf mit zwei Zeilen}
procedure mouserahmen1;
{56  Zeichnet einen Rahmen}
procedure mouserahmen2(ueberschrift:string);
{57  Zeichnet einen Rahmen mit Beschriftung}
procedure mousebegin;
{58  Initzialisirt Maus}
procedure mouseend;
{59  Ver steckt Maus}
procedure circ(x,y,r:integer);
{60  Zeichnet einen AusgefÅllten Kreis}
procedure peep;
{61  Erzeugt einen Ton der wie das drÅcken eines Knopfes klingt}
procedure setdcolor(farbe1,farbe2:word);
{62  Setzt Hintergrund und Textfarbe}
procedure cursor16(x,y,farbe:word);
{63  Procedure zu Maus-cursor im SVGA16 modus}
procedure schreiben(x,y:real;str:string;farbe:word);
{64  Siehe outtextstyle}
procedure graphwin(x1,y1,x2,y2:word;farbe:byte);
{65  Zeichnet ein Fenster im Grafik-Modus}
procedure writexy(x,y:word;str:string);
{66  Schreibt etwas an bestimmter Stelle}
procedure savepicture(x1,y1,x2,y2:integer;datei:string);
{67  Speichert ein Bild in einer Datei}
procedure loadpicture(x,y:integer;datei:string;bitblt:word);
{68  LÑdt ein Bild aus einer Datei und zeigt es auf dem Bildschirm}
function  isfilethere(datei:string):boolean;
{69  Sucht nach einer Datei wenn gefunden den isfilethere ist true sonst false}
procedure erasefile(datei:string);
{70  Lîscht eine Datei wobei der Name anzgeben ist}
procedure filecopy(datei1,datei2:string);
{71  Kopiert eine Datei}
function zahlback(str:string):byte;
{72  Liefert den Koordianaten fÅr '\' zurÅck}
procedure weapen(var viewport:viewporttype);
{73  Zeichnet eine Waffe fÅr ein Spiel}
function mittex:integer;
{74  Ermittelt den Mittelpunkt X-Achse}
function mittey:integer;
{75  Ermittelt den Mittelpunkt Y-Achse}
procedure backwall(n:byte);
{76  Zeichnet die jeweilige Mauer}
procedure stern(x,y:word;farbe:byte);
{77  Zeichnet einen Stern in Farbe}
procedure movein;
{78  Verzert den bildschirm}
procedure moveout;
{79  Verzert den bildschirm}
procedure dickrec(x1,y1,x2,y2:integer;n:word;farbe:byte);
{80  Zeichnet ein dickes Rechteck mit bestimnmter Dicke}
procedure schreib(x,y:byte;str:string;n:byte);
{81  Schreibt in Bildschirmspeicher}
procedure loesche;
{82  Lîscht den Bildschirm schneller durch in Bildschirmspeicher schreiben}
procedure code(name:string);
{83  Abfrage nach Code}
procedure readcode(name:string;var ba:codefile);
{84  Liest die Variable Codefile ein}
function vercode(ba:string;add:char):string;
{85  VerschlÅsselt die Codes}
procedure speicherver(var ba:codefile;name:string);
{86  Speichert die VerschlÅsselte Datei}
procedure ladever(var ba:codefile;name:string);
{87  LÑdt die verschlÅsselte Codedatei}
function entsch(ba:string;add:char):string;
{89  Decodiert die Variablen}
procedure verschluessele(name:string);
{90  VerschlÅsselt ein Datei und Speichert Sie wieder}
procedure abfrage(name:string);
{91  Fragt nach einem Code}
procedure schwarbut(x1,y1,x2,y2:integer;str:string);
{92  Lîscht einen Button und Schreibt einen Pressbutton}
procedure save_screen;
{93  Speichert den Bildschirm}
procedure restore_screen;
{94  lÑdt den gespeicherten Bildschirm}
procedure ramen(rt: byte;startx,starty,dx,dy : integer);
{95  Ñnlich FENSTER}
procedure rahmen(x,y,dx,dy:integer;s:string;rcol,bcol:byte);
{96  Zeichnet einfenster mit anderer Farbe}
function select_datei(dir,mask,mtext,comment:string):string;
{97  Gibt die Mîglichkeit zwischen Dateien einer endung ein auszusuchen}
procedure copyright(s:string);
{98  Schreibt Copyrights}
procedure cls;
{99  Siehe Clrscr}
procedure wri(spalte,zeile:byte;wort:string);
{100 Siehe Writexy}
procedure farbe(spalte,zeile,col:byte;laenge:word);
{101 Siehe Textcolor mit write}
procedure wrif(spalte,zeile:byte;wort:string;color:byte);
{102 Kombination aus Farbe und Wri}
function tan(x:real):real;
{103 Liefert den Tangents des Arguments zurÅck}
function pid1:real;
{104 Errechnet pi/180}
procedure cursor(n:byte);
{105 Setzt Cursor 1: Strich 2: Block 3:Off}
procedure forwad(strecke:real;richtung:integer);
{106 Zeichnet eine Linie von den XY Koordianten}
procedure back(strecke:real;richtung:integer);
{107 FÅhrt forwad RÅckwÑrts aus}
procedure secret_readln(var s:string);
{108 Liest eine Geheimen String ein}
function intrange(min,max,zahl:integer):boolean;
{109 PrÅft ob die Zahl zwischen den Zahlen liegt ist}
function realrange(min,max,zahl:real):boolean;
{110 PrÅft ob die Zahl zwischen den Zahlen liegt ist}
function kleinbuchstabe(ch:char):boolean;
{111 PrÅft ob die Variable ein Kleinbuchstabe ist ist}
function grossbuchstabe(ch:char):boolean;
{112 PrÅft ob die Variable ein Grossbuchstabe ist}
function buchstabe(ch:char):boolean;
{113 PrÅft ob die Variable eine Buchstabe ist}
function ziffer(ch:char):boolean;
{114 PrÅft ob die Variable eine Zahl ist}
function alleleerzentf(st:string):string;
{115 Entfernt alle Leerzeichen aus dem String}
function strtointeger(st:string):integer;
{116 Verwandelt eine String- in eine Integer Varible}
function strtoreal(st:string):real;
{117 Verwandelt eine String- in eine Real Varible}
function numtostr(zahl:real;laenge,nach:byte):string;
{118 Varwandelt eine Realvariable mit Vorgaben in eine String um}
function filemake(dateiname:string):boolean;
{119 öberprÅft ob eine Datei erstellt werden kann}
procedure reade(x,y:byte;var s:string);
{120 Wie Secret_Readln aber Zeichen werden gezeigt}
function copychar(s:string;i:integer):char;
{121 Gibt ein Zeichen aus s zurÅck}
procedure grareade(x,y:integer;var s:string;ab:integer);
{122 Wie reade aber im Grafikmodus}
procedure graareade(x,y:integer;var s:string);
{123 Wie grareade blos mit settextjustify(1,1)}
procedure erkeneerade(x,y:integer;var s:string;ab:integer);
{124 Erkennt die Textausrichtung und fÅhrt grareade oder graareade aus}
function cot(r:real):real;
{125 Liefert den Cotangens des Arguments}
function sec1(x:real):real;
{126 Liefert den Secansfunktion}
function cosec1(x:real):real;
{127 Liefert den Cosecansfunktion}
function sec2(x:real):real;
{128 Liefert den Secansfunktion}
function cosec2(x:real):real;
{129 Liefert den Cosecansfunktion}
procedure circ2(x,y,r:integer;farbe:byte);
{130 Ñhnlich circ}
procedure flacker(x1,y1,x2,y2:integer;s:string;gross,del:word);
{131 Malt ein Flackerndes Fenster mit Text}
procedure graphiright(s:string;farbe:byte);
{132 Schreibt zum beispiel Copyrights im Grafikmodus}
procedure movewad(strecke:real;richtung:integer);
{133 éhnlich Forwad blo· zeichnet keine Linie}
function verschlussele(ch:string):string;
{134 VerschlÅsselt ein String Variable}
function entschlussele(ch:string):string;
{135 EntschlÅsselt ein String Variable}
procedure readefarbe(x,y:byte;var s:string;farbe,hinter:byte);
{136 Liest Variable in Farbe}
procedure fadein(zpal:tdacblock;del:word);
{137 Fadet Bildschirm ein}
procedure fadeout(pal:tdacblock;del:word);
{138 Fadet Bildschirm aus}
procedure fadeto(qpal,zpal:tdacblock;del:word);
{139 Fadet von Quell- in Zielpalette}
procedure fadepicture(p:pointer;x,y:integer);
{140 Fadet picture inc. Palette Åber alten Bildschirm}
procedure schrift(kx,ky,rx,ry:word;s:string;farbe:byte);
{141 Zeigt eine Rundschrift}
procedure circolor(x,y:integer;farbe:byte;r:integer);
{142 Wie circ nur mit Farbe}
procedure inituser(f:string;modes:integer);
{143 Initialisiert externe Grafik}
procedure bootneu;
{144 Bootet neu}
procedure waitohnedelay;
{145 Wartet bis bildaufgebaut ist}
procedure putpixasm(x,y:word;farbe:byte);
{146 Wie Putpixel aber fÅr jeden Grafikmodus in Assemblern}
procedure lineasm(x1,y1,x2,y2,farbe:word);
{147 Zieht Linie und benutzt Assembler und putpixasm}
function timer:longint;
{148 rechnet Zeit in Longint um}
function initvesa(modi:word):boolean;
{149 Initialiesiert Vorgegebenen Grafikmodus}
procedure setflag(flag:byte);
{153 Setzt Flag (Tastaturlampen Leuchten)}
procedure clrflag(flag:byte);
{154 Lîscht Flag (Tastaturlampen Leuchten)}
procedure dicker(x,y,r:integer;farbe:byte);
{155 Zeichnet einen dickeren Kreis (die Dicke der Auflîsung entsprechend)}
function getchar(x,y:byte):char;
{156 Ermittelt Char vom Bildschirmspeicher}
function prim(x:integer):boolean;
{157 Ermittelt ob Zahl Primzahl ist}
procedure wintodos(var f:windac;var s:dosdac);
{158 Wandelt eine Windows in eine Dos Palette um}
procedure dactodacer(var s:dosdac;var t:tdacblock);
{159 Wandelt in Passendes Dacformat um}
procedure setdacblock(startreg:byte;count:integer;var block:tdacblock);
{160 Setzt dac-Block}
procedure vertausch(var a,b:longint);
{161 Vertauscht zwei Variablen}
procedure dreid(var x,y:integer;z:integer);
{162 Wandelt eine Dreidimensionale in eine Zweidimensionale um}
function dreidx(x,y,z:integer):integer;
{163 Wandelt eine Dreidimensionale in eine Zweidimensionale um}
function dreidy(x,y,z:integer):integer;
{164 Wandelt eine Dreidimensionale in eine Zweidimensionale um}
procedure svga386driverproc;
{165 Bindet SVGA386 in *.EXE mit ein}
procedure svga386(mode:byte);
{166 Initziealisiert Svga386}
procedure init13;
{167 Initialisiert Mode 13h}
procedure pixmem(x,y:integer;farbe:byte);
{168 Setzt Pixel auf Koordinate}
procedure ptrtomem(x,y:integer;p:pointer;l:integer);
{169 Kopiert Pointer in Speicher}
function filestring(var f:file;s:string):longint;
{170 Ermittelt an welcher Stelle eine Zeichenfolge in einer Datei steht}
procedure bytetohex(x:byte;var hex:hextype);
{172 Ermittelt aus einer Bytezahl ihre Hexidezimalzahl}
procedure chartohex(x:char;var hex:hextype);
{173 Ermittelt aus einer Charvariable ihre Hexidezimalzahl}
function hextobyte(var hex:hextype):byte;
{174 Ermittelt aus einer Hexidezimalzahl ihre Ordinalzahl}
function hextochar(var hex:hextype):char;
{175 Ermittelt aus einer Hexidezimalzahl ihre Char}
function bintobyte(var x:bintype):byte;
{176 Ermittelt aus einer BinÑrzahl ein Ordinalzahl}
function bintochar(var x:bintype):char;
{177 Ermittelt aus einer BinÑrzahl ein Charvariable}
procedure bytetobin(var x:bintype;f:byte);
{178 Liefert die BinÑhrzahl aus einer byte Zahl}
procedure chartobin(var x:bintype;f:char);
{179 Liefert die BinÑhrzahl aus einer char Variablen}
function dubblebintoword(var x:dubblebin):word;
{180 Ermittelt aus einer BinÑrzahl ein Charvariable}
procedure wordtodubblebin(var x:dubblebin;f:word);
{181 Liefert die BinÑhrzahl aus einer byte Zahl}
function getmaxz:integer;
{182 Ermittelt grî·ten z Wert}
procedure fastline(x,y,x2,y2:word;color:byte);
{183 schnelle linienzeichenrotine in Assemblern}
function rightshift:boolean;
{184 ÅberprÅft ob Taste gedrÅckt}
function leftshift:boolean;
{185 ÅberprÅft ob Taste gedrÅckt}
function control:boolean;
{186 ÅberprÅft ob Taste gedrÅckt}
function alt:boolean;
{187 ÅberprÅft ob Taste gedrÅckt}
function scrolllock:boolean;
{188 ÅberprÅft ob Taste gedrÅckt}
function numlock:boolean;
{189 ÅberprÅft ob Taste gedrÅckt}
function capslock:boolean;
{190 ÅberprÅft ob Taste gedrÅckt}
function insert:boolean;
{191 ÅberprÅft ob Taste gedrÅckt}
function isdirthere(path,chek:dos.pathstr):boolean;
{192 ÅberprÅft ob Path da ist}
function laufwerkda(c:char):boolean;
{193 ermittelt ob laufwerk da ist}
procedure getalldirs;
{194 ermittelt alle Laufwerke}
function tribblebintolongint(var x:tribblebin):longint;
{195 Ermittelt aus einer BinÑrzahl ein Charvariable}
procedure longinttotribblebin(var x:tribblebin;f:longint);
{196 Liefert die BinÑhrzahl aus einer byte Zahl}
procedure svgapixel(x,y:word;farbe:byte);
{197 Zeichnet einen Punkt wenn vorher initvesa aufgerufen wurde}
procedure pointertosvga(x,y:word;var p;laenge:word);
{198 Zeichnet eine Reihe von Punkten wenn vorher initvesa aufgerufen wurde}
procedure puttruepixel(x,y:word;farbe1:word;farbe2:byte);
{199 Setzt einen Pixel bei einer True Color Auflîsung}
procedure intro2(f1,f2:byte;initz:boolean);
{200 Fadet das TPK Logo}
procedure setzerahmen(farbe:byte);
{201 Setzt einen farbigen Rahemen um das geschehen}
procedure showsvgadbm(x,y:word;s:string);
{202 Zeichnet ein Komplettes Bild im Svga-Modus}
procedure lauftip(x,y:word;s1:string);
{203 Zeigt eine Laufschrift wie bei Graareade aber mit vorgegebem Text}
procedure klappeauf(x,y:word;farbe:byte);
{204 ôffnet eine Klappe}
procedure makepal(s:string);
{205 Setzt Palette}
procedure setseite(seite:byte);
{206 setzt eine neu Seite im Svga-Modus}
function getseite:byte;
{207 ermittel die aktuelle Svga-Seite}
procedure offne13hdbm(s:string;pal:boolean);
{208 îffnet eine DBM im 320x200 Modus mit oder ohne Palette}
implementation

const vesa16modes:array[0..2]of word=($0102,$0104,$0106);
      screen_akt:byte=1;

type
  vgaInfoblock=record
    vesasignature:array[0..3]of byte;
    vesaversion:word;
    oemstringptr:pointer;
    capabilities:array[0..3]of byte;
    videomodeptr:pointer;
  end;

var gd,gm,vesa16:integer;
    oldexitproc:pointer;
    filenames:array[1..512]of string[12];
    reg:registers;
    vesa:vesatype;

procedure egavgadriverproc;external;

{$l egavga.obj}

procedure initbegin;

begin
 if registerbgidriver(@egavgadriverproc) < 0 then
 gd:=detect;initgraph(gd,gm,pather);
end;

procedure initbegin16;

function GetHighestCap(Table:Pointer;Modes:Word;Size:Integer):Integer;
near;assembler;

asm
     XOR  AX,AX
     LES  DI,Table
@@1: MOV  SI,Modes
     ADD  SI,Size
     ADD  SI,Size
     MOV  BX,ES:[DI]
     CMP  BX,0FFFFH
     JE   @@4
     INC  DI
     INC  DI
     MOV  CX,Size
@@2: CMP  BX,[SI]
     JZ   @@3
     DEC  SI
     DEC  SI
     LOOP @@2
@@3: CMP  AX,CX
     JA   @@1
     MOV  AX,CX
     JMP  @@1
@@4:
end;

{$IFDEF DPMI}
type TRealRegs=record
      RealEDI:Longint;
      RealESI:Longint;
      RealEBP:Longint;
      Reserved:Longint;
      RealEBX:Longint;
      RealEDX:Longint;
      RealECX:Longint;
      RealEAX:Longint;
      RealFlags:Word;
      RealES:Word;
      RealDS:Word;
      RealFS:Word;
      RealGS:Word;
      RealIP:Word;
      RealCS:Word;
      RealSP:Word;
      RealSS:Word;
    end;

function DetectVesa16:Integer;far;assembler;

var Segment,Selector,VesaCap:Word;

asm
{$IFOPT G+}
     PUSH 0000H
     PUSH 0100H
{$ELSE}
     XOR  AX,AX
     PUSH AX
     INC  AH
     PUSH AX
{$ENDIF}
     CALL GlobalDosAlloc
     MOV  Segment,DX
     MOV  Selector,AX
     MOV  DI,OFFSET RealModeRegs
     MOV  WORD PTR [DI].TRealRegs.RealSP, 0
     MOV  WORD PTR [DI].TRealRegs.RealSS, 0
     MOV  WORD PTR [DI].TRealRegs.RealEAX, 4F00H
     MOV  WORD PTR [DI].TRealRegs.RealES, DX
     MOV  WORD PTR [DI].TRealRegs.RealEDI, 0
     MOV  AX,DS
     MOV  ES,AX
     MOV  AX,0300H
     MOV  BX,0010H
     XOR  CX,CX
     INT  31H
     MOV  DI,OFFSET RealModeRegs
     MOV  AX,grError
     PUSH AX
     CMP  WORD PTR [DI].TRealRegs.RealEAX,004FH
     JNZ  @@Exit
     POP  AX
     MOV  ES,Selector
     XOR  DI,DI
     CMP  ES:[DI].VgaInfoBlock.VESASignature.Word[0], 'EV'
     JNZ  @@Exit
     CMP  ES:[DI].VgaInfoBlock.VESASignature.Word[2], 'AS'
     JNZ  @@Exit
     MOV  AX,0000
     MOV  CX,1
     INT  31H
     MOV  VesaCap,AX
     MOV  DX,ES:[DI].VgaInfoBlock.VideoModePtr.Word[2]
     MOV  CX,4
     XOR  AX,AX
@@Convert:
     SHL  DX,1
     RCL  AX,1
     LOOP @@Convert
     ADD  DX,ES:[DI].VgaInfoBlock.VideoModePtr.Word[0]
     ADC  AX,0
     MOV  CX,AX
     MOV  BX,VesaCap
     MOV  AX,0007H
     INT  31H
     INC  AX
     XOR  CX,CX
     MOV  DX,0FFFFH
     INT  31H
     MOV  ES,BX
     PUSH  ES
     PUSH  DI
{$IFOPT G+}
     PUSH  OFFSET Vesa16Modes
     PUSH  0003H
{$ELSE}
     MOV   SI, OFFSET Vesa16Modes
     PUSH  SI
     MOV   AX, 5
     PUSH  AX
{$ENDIF}
     CALL  GetHighestCap
     PUSH  AX
     MOV   BX,VesaCap
     MOV   AX,0001H
     INT   31H
@@Exit:
     PUSH  Selector
     CALL  GlobalDosFree
     POP   AX
end;
{$ELSE}

function DetectVesa16:Integer;far;assembler;

var VesaInfo:array[0..255]of Byte;

asm
     MOV   AX,SS
     MOV   ES,AX
     LEA   DI,VesaInfo
     MOV   AX,4F00H
     INT   10H
     CMP   AX,004FH
     MOV   AX,grError
     JNZ   @@Exit
     CMP   ES:[DI].VgaInfoBlock.VESASignature.Word[0], 'EV'
     JNZ   @@Exit
     CMP   ES:[DI].VgaInfoBlock.VESASignature.Word[2], 'AS'
     JNZ   @@Exit
     LES   DI,ES:[DI].VgaInfoBlock.VideoModePtr
     PUSH  ES
     PUSH  DI
     MOV   AX, OFFSET Vesa16Modes
     PUSH  AX
     MOV   AX,3
     PUSH  AX
     CALL  GetHighestCap
@@Exit:
end;
{$ENDIF}

{$F+}
procedure MyExitProc;

begin
 ExitProc:=OldExitProc;
 CloseGraph;
end;
{$F-}

procedure Initialize;

var InGraphicsMode:boolean;PathToDriver:string;

begin
 DirectVideo:=False;
 OldExitProc:=ExitProc;
 ExitProc:=@MyExitProc;
 PathToDriver:='C:\BP\BGI';
 repeat
  VESA16:=InstallUserDriver('VESA16',@DetectVESA16);
{$IFDEF Use8514}
  gd:=IBM8514;
  gm:=IBM8514Hi;
{$ELSE}
  gd:=Detect;
{$ENDIF}
  InitGraph(gd,gm,pather);
  if graphresult <> grOK then
  begin
   Writeln('Graphics error: ',GraphErrorMsg(graphresult));
   if graphresult = grFileNotFound then
   begin
    Writeln('Enter full path to BGI driver or type <Ctrl-Break> to quit:');
    Readln(PathToDriver);
    Writeln;
   end else Halt(1);
  end;
 until graphresult = grOK;
end;

begin
 Initialize;
end;

procedure initend;

begin
 cleardevice;
 closegraph;
end;

procedure initbigdos;

begin
 orgimode:=lastmode;
 textmode(lo(lastmode)+font8x8);
end;

procedure endbigdos;

begin
 textmode(orgimode);
end;

procedure dreieck(x1,x2,y1,y2,z1,z2:integer;farbe:word);

begin
 setcolor(farbe);
 line(x1,x2,y1,y2);
 line(y1,y2,z1,z2);
 line(z1,z2,x1,x2);
end;

procedure odreieck(x1,x2,y1,y2,z1,z2:integer;farbe:word);

begin
 setcolor(farbe);
 line(x1,x2,y1,y2);
 line(y1,y2,z1,z2);
end;

procedure viereck(w1,w2,x1,x2,y1,y2,z1,z2:integer;farbe:word);

begin
 setcolor(farbe);
 line(w1,w2,x1,x2);
 line(x1,x2,y1,y2);
 line(y1,y2,z1,z2);
 line(z1,z2,w1,w2);
end;

procedure oviereck(w1,w2,x1,x2,y1,y2,z1,z2:integer;farbe:word);

begin
 setcolor(farbe);
 line(w1,w2,x1,x2);
 line(x1,x2,y1,y2);
 line(y1,y2,z1,z2);
end;

procedure cline(x1,x2,y1,y2:integer;farbe:word);

begin
 setcolor(farbe);
 line(x1,x2,y1,y2);
end;

procedure ton(hz,ms:integer);

begin
 sound(hz);
 delay(ms);
 nosound;
end;

procedure outtextstyle(x,y:integer;textstring:string;farbe:word;Font,Direction:Word;CharSize:Word);

begin
 setcolor(farbe);
 settextstyle(font,direction,charsize);
 outtextxy(x,y,textstring);
end;

procedure palrgb;

begin
 setrgbpalette(0,255,0,0);setrgbpalette(1,255,55,55);setrgbpalette(2,255,110,200);
 setrgbpalette(3,0,255,0);setrgbpalette(4,55,255,55);setrgbpalette(5,110,255,200);
 setrgbpalette(6,200,255,110);setrgbpalette(7,255,200,110);setrgbpalette(8,150,150,150);
 setrgbpalette(9,0,0,255);setrgbpalette(10,55,55,255);setrgbpalette(11,110,200,255);
 setrgbpalette(12,200,110,255);setrgbpalette(13,100,100,100);setrgbpalette(14,100,200,300);
 setrgbpalette(15,300,200,100);
end;

procedure palhelp;

begin
 setrgbpalette(0,$00,$00,$00);setrgbpalette(1,$00,$00,$fc);setrgbpalette(2,$24,$fc,$24);
 setrgbpalette(3,$00,$fc,$fc);setrgbpalette(4,$fc,$14,$14);setrgbpalette(5,$b0,$00,$fc);
 setrgbpalette(6,$70,$48,$00);setrgbpalette(7,$c4,$c4,$c4);setrgbpalette(8,$34,$34,$34);
 setrgbpalette(9,$00,$00,$70);setrgbpalette(10,$00,$70,$00);setrgbpalette(11,$00,$70,$70);
 setrgbpalette(12,$70,$00,$00);setrgbpalette(13,$70,$00,$70);setrgbpalette(14,$fc,$fc,$24);
 setrgbpalette(15,$fc,$fc,$fc);
end;

procedure pfeil(nummer:byte;x,y:integer;farbe:word);
begin
 case nummer of 1: begin {nach oben}
 setcolor(farbe);
 moveto(x-3,y+8);
 lineto(x,y);
 lineto(x+3,y+8);end;
               2: begin {nach rechts}
 setcolor(farbe);
 moveto(x-8,y+3);
 lineto(x,y);
 lineto(x-8,y-3);end;
               3: begin {nach unten}
 setcolor(farbe);
 moveto(x+3,y-8);
 lineto(x,y);
 lineto(x-3,y-8);end;
               4: begin {nach links}
 setcolor(farbe);
 moveto(x+8,y+3);
 lineto(x,y);
 lineto(x+8,y-3);end;end;
end;

procedure pfeil2(nummer:byte;x,y:integer;farbe:word);

begin
 case nummer of 1: begin {nach oben}
 setcolor(farbe);
 moveto(x,y+5);
 lineto(x-3,y+8);
 lineto(x,y);
 lineto(x+3,y+8);
 lineto(x,y+5);end;
               2: begin {nach rechts}
 setcolor(farbe);
 moveto(x-5,y);
 lineto(x-8,y+3);
 lineto(x,y);
 lineto(x-8,y-3);
 lineto(x-5,y);end;
               3: begin {nach unten}
 setcolor(farbe);
 moveto(x,y-5);
 lineto(x+3,y-8);
 lineto(x,y);
 lineto(x-3,y-8);
 lineto(x,y-5);end;
               4: begin {nach links}
 setcolor(farbe);
 moveto(x+5,y);
 lineto(x+8,y+3);
 lineto(x,y);
 lineto(x+8,y-3);
 lineto(x+5,y);end;end;
end;

procedure ende;

var sch:array[1..33]of string;c:integer;

begin
 sch[1]:='c';sch[2]:='o';sch[3]:='p';sch[4]:='y';sch[5]:='r';sch[6]:='i';
 sch[7]:='g';sch[8]:='h';sch[9]:='t';sch[10]:=' ';sch[11]:='(';sch[12]:='c';
 sch[13]:=')';sch[14]:=' ';sch[15]:='b';sch[16]:='y';sch[17]:=' ';sch[18]:='R';
 sch[19]:='o';sch[20]:='b';sch[21]:='i';sch[22]:='n';sch[23]:=' ';sch[24]:='L';
 sch[25]:='e';sch[26]:='d';sch[27]:='i';sch[28]:='g';sch[29]:=' ';sch[30]:='1';
 sch[31]:='9';sch[32]:='9';sch[33]:='6';
 clrscr;for c:= 1 to 33 do
 begin;
  write(sch[c]);
  delay(100);
 end;
 textcolor(0);gotoxy(1,1);
 for c:= 1 to 33 do
 begin;
  write(sch[c]);
  delay(100);
 end;
end;

procedure ende2;

var sch:array[1..51]of string;c:integer;

begin
 sch[1]:='c';sch[2]:='o';sch[3]:='p';sch[4]:='y';sch[5]:='r';sch[6]:='i';
 sch[7]:='g';sch[8]:='h';sch[9]:='t';sch[10]:=' ';sch[11]:='(';sch[12]:='c';
 sch[13]:=')';sch[14]:=' ';sch[15]:='b';sch[16]:='y';sch[17]:=' ';sch[18]:='T';
 sch[19]:='h';sch[20]:='o';sch[21]:='m';sch[22]:='a';sch[23]:='s';sch[24]:=' ';
 sch[25]:='P';sch[26]:='l';sch[27]:='î';sch[28]:='t';sch[29]:='z';sch[30]:='e';
 sch[31]:=' ';sch[32]:='a';sch[33]:='n';sch[34]:='d';sch[35]:=' ';sch[36]:='R';
 sch[37]:='o';sch[38]:='b';sch[39]:='i';sch[40]:='n';sch[41]:=' ';sch[42]:='L';
 sch[43]:='e';sch[44]:='d';sch[45]:='i';sch[46]:='g';sch[47]:=' ';sch[48]:='1';
 sch[49]:='9';sch[50]:='9';sch[51]:='6';
 clrscr;for c:= 1 to 51 do
 begin;
  write(sch[c]);
  delay(100);
 end;
 textcolor(0);gotoxy(1,1);
 for c:= 1 to 51 do
 begin;
  write(sch[c]);
  delay(100);
 end;
end;

procedure font;

var bold,euro,lcom,scri,tscr:integer;

begin
 bold:=installuserfont('c:\bp\bgi\bold');
 euro:=installuserfont('c:\bp\bgi\euro');
 lcom:=installuserfont('c:\bp\bgi\lcom');
 scri:=installuserfont('c:\bp\bgi\scri');
 tscr:=installuserfont('c:\bp\bgi\tscr');
end;

procedure font2;

begin
end;

procedure kreuz(x,y,a,b:integer;farbe:word);

begin
 setcolor(farbe);
 moveto(x-a,y);
 lineto(x+a,y);
 moveto(x,y-b);
 lineto(x,y+b);
end;

procedure dreipunkt(x,y,i:integer;n:byte);

begin
 case n of
 1:
 begin
  moveto(x-i,y+i);
  lineto(x+i,y+i);
  lineto(x,y-i);
  lineto(x-i,y+i);
 end;
 2:
 begin
  moveto(x-i,y-i);
  lineto(x-i,y+i);
  lineto(x+i,y);
  lineto(x-i,y-i);
 end;
 3:
 begin
  moveto(x+i,y-i);
  lineto(x-i,y-i);
  lineto(x,y+i);
  lineto(x+i,y-i);
 end;
 4:
 begin
  moveto(x+i,y+i);
  lineto(x+i,y-i);
  lineto(x-i,y);
  lineto(x+i,y+i);
 end;end;
end;

procedure rundeck(x1,y1,x2,y2:integer;n:byte;farbe:word);

var i:byte;

begin
 setcolor(farbe);
 for i:= 1 to n do
 begin
  rectangle(x1,y1,x2,y2);
  line(x1+i,y1-i,x2-i,y1-i);
  line(x2+i,y1+i,x2+i,y2-i);
  line(x2-i,y2+i,x1+i,y2+i);
  line(x1-i,y1+i,x1-i,y2-i);
 end;
end;

procedure cursoron;assembler;

asm
 mov ah,01h
 mov cx,0607h
 int 10h
end;

procedure cursoroff;assembler;

asm
 xor ax,ax
 mov ah,01h
 mov ch,20h
 mov cl,20h
 int 10h
end;

procedure cursorblock;

label mon;

var index:byte;

begin
 index:=1;
 asm
  xor ax,ax
  mov ah,01h
  mov ch,00h
  mov al,1
  cmp al,index
  jl  mon
  mov cl,07
  jmp @01
mon: mov cl,0d
@01: int 10h
 end;
end;

procedure mainwindow(header:string);

var viewport:viewporttype;

begin
 setcolor(15);
 settextstyle(0,0,1);
 settextjustify(1,2);
 setviewport(0,0,getmaxx,getmaxy,clipon);
 outtextxy(getmaxx div 2,2,header);
 setviewport(0,textheight('M')+4,getmaxx,getmaxy-(textheight('M')+4),clipon);
 setcolor(15);
 setlinestyle(0,0,1);
 getviewsettings(viewport);
 with viewport do
  rectangle(0,0,x2-x1,y2-y1);
 setviewport(1,textheight('M')+5,getmaxx-1,getmaxy-(TextHeight('M')+5),clipon);
end;

procedure statusline(msg:string);

var viewport:viewporttype;

begin
 setviewport(0,0,getmaxx,getmaxy,clipon);
 setcolor(15);
 settextstyle(0,0,1);
 settextjustify(1,2);
 setlinestyle(0,0,1);
 setfillstyle(0,0);
 Bar(0,getmaxy-(textheight('M')+4),getmaxx,getmaxy);
 Rectangle(0,getmaxy-(textheight('M')+4),getmaxx,getmaxy);
 OutTextXY(getmaxx div 2,getmaxy-(textheight('M')+2), msg);
 SetViewPort(1,textheight('M')+5,getmaxx-1,getmaxy-(textheight('M')+5),clipon);
end;

procedure fenster(x1,y1,x2,y2:integer;n,farbe:byte);

var x,y:integer;

begin
 window(1,1,80,25);
 textcolor(farbe);
 case n of
 1:
 begin
  for x:= x1+1 to x2-1 do
  begin
   gotoxy(x,y1);write('Õ');
   gotoxy(x,y2);write('Õ');
  end;
  for y:= y1+1 to y2-1 do
  begin
   gotoxy(x1,y);write('∫');
   gotoxy(x2,y);write('∫');
  end;
  gotoxy(x1,y1);write('…');
  gotoxy(x1,y2);write('»');
  gotoxy(x2,y1);write('ª');
  gotoxy(x2,y2);write('º');
 end;
 2:
 begin
  for x:= x1+1 to x2-1 do
  begin
   gotoxy(x,y1);write('ƒ');
   gotoxy(x,y2);write('ƒ');
  end;
  for y:= y1+1 to y2-1 do
  begin
   gotoxy(x1,y);write('≥');
   gotoxy(x2,y);write('≥');
  end;
  gotoxy(x1,y1);write('⁄');
  gotoxy(x1,y2);write('¿');
  gotoxy(x2,y1);write('ø');
  gotoxy(x2,y2);write('Ÿ');
 end;
 3:
 begin
  for x:= x1+1 to x2-1 do
  begin
   gotoxy(x,y1);write('Õ');
   gotoxy(x,y2);write('Õ');
  end;
  for y:= y1+1 to y2-1 do
  begin
   gotoxy(x1,y);write('≥');
   gotoxy(x2,y);write('≥');
  end;
  gotoxy(x1,y1);write('’');
  gotoxy(x1,y2);write('‘');
  gotoxy(x2,y1);write('∏');
  gotoxy(x2,y2);write('æ');
 end;
 4:
 begin
  for x:= x1+1 to x2-1 do
  begin
   gotoxy(x,y1);write('ƒ');
   gotoxy(x,y2);write('ƒ');
  end;
  for y:= y1+1 to y2-1 do
  begin
   gotoxy(x1,y);write('∫');
   gotoxy(x2,y);write('∫');
  end;
  gotoxy(x1,y1);write('÷');
  gotoxy(x1,y2);write('”');
  gotoxy(x2,y1);write('∑');
  gotoxy(x2,y2);write('Ω');
 end;
 5:
 begin
  for x:= x1+1 to x2-1 do
  begin
   gotoxy(x,y1);write(' ');
   gotoxy(x,y2);write('À');
  end;
  for y:= y1+1 to y2-1 do
  begin
   gotoxy(x1,y);write('π');
   gotoxy(x2,y);write('Ã');
  end;
  gotoxy(x1,y1);write('Œ');
  gotoxy(x1,y2);write('Œ');
  gotoxy(x2,y1);write('Œ');
  gotoxy(x2,y2);write('Œ');
 end;
 6:
 begin
  for x:= x1+1 to x2-1 do
  begin
   gotoxy(x,y1);write('À');
   gotoxy(x,y2);write(' ');
  end;
  for y:= y1+1 to y2-1 do
  begin
   gotoxy(x1,y);write('Ã');
   gotoxy(x2,y);write('π');
  end;
  gotoxy(x1,y1);write('…');
  gotoxy(x1,y2);write('»');
  gotoxy(x2,y1);write('ª');
  gotoxy(x2,y2);write('º');
 end;
 7:
 begin
  for x:= x1+1 to x2-1 do
  begin
   gotoxy(x,y1);write('À');
   gotoxy(x,y2);write(' ');
  end;
  for y:= y1+1 to y2-1 do
  begin
   gotoxy(x1,y);write('Ã');
   gotoxy(x2,y);write('π');
  end;
  gotoxy(x1,y1);write('…');
  gotoxy(x1,y2);write('»');
  gotoxy(x2,y1);write('ª');
  gotoxy(x2,y2);write('º');
  for x:= x1+2 to x2-2 do
  begin
   gotoxy(x,y1+1);write(' ');
   gotoxy(x,y2-1);write('À');
  end;
  for y:= y1+2 to y2-2 do
  begin
   gotoxy(x1+1,y);write('π');
   gotoxy(x2-1,y);write('Ã');
  end;
  gotoxy(x1+1,y1+1);write('Œ');
  gotoxy(x1+1,y2-1);write('Œ');
  gotoxy(x2-1,y1+1);write('Œ');
  gotoxy(x2-1,y2-1);write('Œ');
 end;
 8:
 begin
  for x:= x1+1 to x2-1 do
  begin
   gotoxy(x,y1);write('¡');
   gotoxy(x,y2);write('¬');
  end;
  for y:= y1+1 to y2-1 do
  begin
   gotoxy(x1,y);write('¥');
   gotoxy(x2,y);write('√');
  end;
  gotoxy(x1,y1);write('≈');
  gotoxy(x1,y2);write('≈');
  gotoxy(x2,y1);write('≈');
  gotoxy(x2,y2);write('≈');
 end;
 9:
 begin
  for x:= x1+1 to x2-1 do
  begin
   gotoxy(x,y1);write('¬');
   gotoxy(x,y2);write('¡');
  end;
  for y:= y1+1 to y2-1 do
  begin
   gotoxy(x1,y);write('√');
   gotoxy(x2,y);write('¥');
  end;
  gotoxy(x1,y1);write('⁄');
  gotoxy(x1,y2);write('¿');
  gotoxy(x2,y1);write('ø');
  gotoxy(x2,y2);write('Ÿ');
 end;
 10:
 begin
  for x:= x1+1 to x2-1 do
  begin
   gotoxy(x,y1);write('¬');
   gotoxy(x,y2);write('¡');
  end;
  for y:= y1+1 to y2-1 do
  begin
   gotoxy(x1,y);write('√');
   gotoxy(x2,y);write('¥');
  end;
  gotoxy(x1,y1);write('⁄');
  gotoxy(x1,y2);write('¿');
  gotoxy(x2,y1);write('ø');
  gotoxy(x2,y2);write('Ÿ');
  for x:= x1+2 to x2-2 do
  begin
   gotoxy(x,y1+1);write('¡');
   gotoxy(x,y2-1);write('¬');
  end;
  for y:= y1+2 to y2-2 do
  begin
   gotoxy(x1+1,y);write('¥');
   gotoxy(x2-1,y);write('√');
  end;
  gotoxy(x1+1,y1+1);write('≈');
  gotoxy(x1+1,y2-1);write('≈');
  gotoxy(x2-1,y1+1);write('≈');
  gotoxy(x2-1,y2-1);write('≈');
 end;
 11:
 begin
  for x:=x1 to x2 do
  begin
   gotoxy(x,y1);write('∞');
   gotoxy(x,y2);write('∞');
  end;
  for y:= y1+1 to y2-1 do
  begin
   gotoxy(x1,y);write('∞');
   gotoxy(x2,y);write('∞');
  end;
 end;
 12:
 begin
  for x:=x1 to x2 do
  begin
   gotoxy(x,y1);write('±');
   gotoxy(x,y2);write('±');
  end;
  for y:= y1+1 to y2-1 do
  begin
   gotoxy(x1,y);write('±');
   gotoxy(x2,y);write('±');
  end;
 end;
 13:
 begin
  for x:=x1 to x2 do
  begin
   gotoxy(x,y1);write('≤');
   gotoxy(x,y2);write('≤');
  end;
  for y:= y1+1 to y2-1 do
  begin
   gotoxy(x1,y);write('≤');
   gotoxy(x2,y);write('≤');
  end;
 end;
 14:
 begin
  for x:=x1 to x2 do
  begin
   gotoxy(x,y1);write('€');
   gotoxy(x,y2);write('€');
  end;
  for y:= y1+1 to y2-1 do
  begin
   gotoxy(x1,y);write('€');
   gotoxy(x2,y);write('€');
  end;
 end;
 15:
 begin
  for x:= x1 to x2 do
  begin
   gotoxy(x,y1);write('‹');
   gotoxy(x,y2);write('ﬂ');
  end;
  for y:= y1+1 to y2-1 do
  begin
   gotoxy(x1,y);write('€');
   gotoxy(x2,y);write('€');
  end;
 end;
 end;
end;

procedure fenstere(x1,y1,x2,y2:integer;farbe:byte);

var x,y:integer;

begin
 window(1,1,80,25);
 for x:= x1+1 to x2-1 do
 begin
  schreib(x,y1,'Õ',farbe);
  schreib(x,y2,'Õ',farbe);
 end;
 for y:= y1+1 to y2-1 do
 begin
  schreib(x1,y,'∫',farbe);
  schreib(x2,y,'∫',farbe);
 end;
 schreib(x1,y1,'…',farbe);
 schreib(x1,y2,'»',farbe);
 schreib(x2,y1,'ª',farbe);
 schreib(x2,y2,'º',farbe);
end;

procedure fensterschatten(x1,y1,x2,y2:integer;f1,f2:byte);

var x,y:integer;

begin
 textcolor(f1);
 for x:= x1 to x2 do
 begin
  gotoxy(x,y1);write('ﬂ');
  gotoxy(x,y2);write('‹');
 end;
 for y:= y1 to y2 do
 begin
  gotoxy(x1,y);write('€');
  gotoxy(x2,y);write('€');
 end;
 textcolor(f2);
 for x:=x1+1 to x2+1 do
 begin
  gotoxy(x,y1-1);write('‹');
 end;
 for y:=y1 to y2-1 do
 begin
  gotoxy(x2+1,y);write('€');
 end;
end;

function kleiningross(str:string):string;assembler;

asm
   push  ds
   cld
   lds   si,str
   les   di,@result
   lodsb
   stosb
   xor   ah,ah
   xchg  ax,cx
   jcxz  @3
@1:lodsb
   cmp   al,'a'
   jb    @2
   cmp   al,'z'
   ja    @2
   sub   al,20h
@2:stosb
   loop  @1
@3:pop   ds
end;

procedure initmouse;

begin
 if mem[$0000:$00cc] = 0 then mouseok:=false else
 begin
  reg.ax:=0;
  reg.bx:=0;
  intr($33,reg);
  if reg.ax <> 0
  then mouseok:=true else mouseok:=false;
  anzbutton:=reg.bl;
 end;
end;

procedure softtextmouse;

begin
 reg.ax:=10;
 reg.bx:=0;
 reg.cx:=screenmask;
 reg.dx:=cursormask;
 intr($33,reg);
end;

procedure showmouse;

begin
 reg.ax:=1;
 intr($33,reg);
end;

procedure hidemouse;

begin
 reg.ax:=2;
 intr($33,reg);
end;

procedure grgetmouseposition;

begin
 reg.ax:=3;
 intr($33,reg);
 button:=reg.bl;
 x:=reg.cx;
 y:=reg.dx;
end;

procedure getmouseposition;

begin
 reg.ax:=3;
 intr($33,reg);
 button:=reg.bl;
 x:=succ(reg.cx div 8);
 y:=succ(reg.dx div 8);
end;

procedure grsetmouseposition(x,y:word);

begin
 reg.ax:=4;
 reg.cx:=x;
 reg.dx:=y;
 intr($33,reg);
end;

procedure setmouseposition;

begin
 reg.ax:=4;
 reg.cx:=pred(x)*8;
 reg.dx:=pred(y)*8;
 intr($33,reg);
end;

procedure grmousewindow(x1,y1,x2,y2:word);

begin
 reg.ax:=7;
 reg.cx:=x1;
 reg.dx:=x2;
 intr($33,reg);
 reg.ax:=8;
 reg.cx:=y1;
 reg.dx:=y2;
 intr($33,reg);
end;

procedure mousewindow;

begin
 reg.ax:=7;
 reg.cx:=pred(x1)*8;
 reg.dx:=pred(x2)*8;
 intr($33,reg);
 reg.ax:=8;
 reg.cx:=pred(y1)*14;
 reg.dx:=pred(y2)*14;
 intr($33,reg);
end;

procedure wait;

var x,y,button:Byte;rk:char;

begin
 if mouseok then
 begin
  softtextmouse($80ff,$1f00);
  mousewindow(lo(windmin)+1,hi(windmin)+1,lo(windmax)+1,hi(windmax)+1);
  showmouse;
 end;
 button:=0;
 while keypressed do
  rk:=readkey;
  repeat
   if mouseok THEN getmouseposition(button,x,y);
  until keypressed or (button <> 0);
  Delay(60);
  while keypressed do
   rk:=readkey;
   if mouseok then
   begin
    hidemouse;
    mousewindow(1,1,80,25);
   end;
end;

procedure cursormode;

const hidden=$2020;
      first_call:boolean=true;
      cursor_size:array[unterstrich..unsichtbar]of word=(0,0,0);
      bildschirm_service=$10;

begin
 if first_call then
 begin
  reg.ah := 3;
  intr(bildschirm_service,reg);
  cursor_size[unterstrich]:=reg.cx;
  cursor_size[block]:=reg.cl;
  cursor_size[unsichtbar]:=Hidden;
  first_call:=false;
 end;
 reg.ah:=1;
 reg.bx:=0;
 Reg.cx:=cursor_size[ctyp];
 intr(bildschirm_service,reg);
end;

procedure button1(x1,y1,x2,y2:integer;str:string);

begin
 setfillstyle(1,0 );
 bar(x1,y1,x2,y2);
 setfillstyle(1,15);
 bar(x1,y1,x2,y2);
 setcolor(6);
 rectangle(x1,y1,x2,y2);
 setlinestyle(0,0,3);
 setcolor(7);
 odreieck(x1+2,y2-2,x1+2,y1+2,x2-2,y1+2,7);
 setcolor(0);
 odreieck(x1+2,y2-2,x2-2,y2-2,x2-2,y1+2,0);
 setlinestyle(0,0,1);
 setcolor(6);
 settextjustify(1,1);
 outtextxy((x1+x2)div 2,(y1+y2) div 2,str);
end;

procedure button2(x1,y1,x2,y2:integer;str1,str2:string);

begin
 setfillstyle(1,0 );
 bar(x1,y1,x2,y2);
 setfillstyle(1,15);
 bar(x1,y1,x2,y2);
 setcolor(6);
 rectangle(x1,y1,x2,y2);
 setlinestyle(0,0,3);
 setcolor(7);
 odreieck(x1+2,y2-2,x1+2,y1+2,x2-2,y1+2,7);
 setcolor(0);
 odreieck(x1+2,y2-2,x2-2,y2-2,x2-2,y1+2,0);
 setlinestyle(0,0,1);
 setcolor(6);
 settextjustify(1,1);
 outtextxy((x1+x2)div 2,y1+((y2-y1)div 3)    ,str1);
 outtextxy((x1+x2)div 2,y1+(((y2-y1)div 3)*2),str2);
end;

procedure button3(x1,y1,x2,y2:integer;str:string);

begin
 setfillstyle(1,8 );
 bar(x1+20,y1+20,x2+20,y2+20);
 setfillstyle(1,15);
 bar(x1,y1,x2,y2);
 setlinestyle(0,0,3);
 setcolor(getbkcolor);
 rectangle(x1,y1,x2,y2);
 setlinestyle(0,0,1);
 settextjustify(1,1);
 setcolor(6);
 outtextxy((x1+x2)div 2,(y1+y2)div 2,str);
end;

procedure button4(x1,y1,x2,y2:integer;str1,str2:string);

begin
 setfillstyle(1,8 );
 bar(x1+20,y1+20,x2+20,y2+20);
 setfillstyle(1,15);
 bar(x1,y1,x2,y2);
 setlinestyle(0,0,3);
 setcolor(getbkcolor);
 rectangle(x1,y1,x2,y2);
 setlinestyle(0,0,1);
 settextjustify(1,1);
 setcolor(6);
 outtextxy((x1+x2)div 2,y1+((y2-y1)div 3)    ,str1);
 outtextxy((x1+x2)div 2,y1+(((y2-y1)div 3)*2),str2);
end;

procedure markbutton1(x1,y1,x2,y2:integer;str:string);

begin
 setfillstyle(1,0);
 bar(x1,y1,x2,y2);
 setfillstyle(1,4);
 bar(x1,y1,x2,y2);
 setcolor(6);
 rectangle(x1,y1,x2,y2);
 setlinestyle(0,0,3);
 setcolor(7);
 odreieck(x1+2,y2-2,x1+2,y1+2,x2-2,y1+2,7);
 setcolor(0);
 odreieck(x1+2,y2-2,x2-2,y2-2,x2-2,y1+2,0);
 setlinestyle(0,0,1);
 setcolor(6);
 settextjustify(1,1);
 outtextxy((x1+x2)div 2,(y1+y2)div 2,str);
end;

procedure markbutton2(x1,y1,x2,y2:integer;str1,str2:string);

begin
 setfillstyle(1,0);
 bar(x1,y1,x2,y2);
 setfillstyle(1,4);
 bar(x1,y1,x2,y2);
 setcolor(6);
 rectangle(x1,y1,x2,y2);
 setlinestyle(0,0,3);
 setcolor(7);
 odreieck(x1+2,y2-2,x1+2,y1+2,x2-2,y1+2,7);
 setcolor(0);
 odreieck(x1+2,y2-2,x2-2,y2-2,x2-2,y1+2,0);
 setlinestyle(0,0,1);
 setcolor(6);
 settextjustify(1,1);
 outtextxy((x1+x2)div 2,y1+((y2-y1)div 3)    ,str1);
 outtextxy((x1+x2)div 2,y1+(((y2-y1)div 3)*2),str2);
end;

procedure pressbutton1(x1,y1,x2,y2:integer;str:string);

begin
 setfillstyle(1,0 );
 bar(x1,y1,x2,y2);
 setfillstyle(1,15);
 bar(x1,y1,x2,y2);
 setcolor(6);
 rectangle(x1,y1,x2,y2);
 setlinestyle(0,0,3);
 setcolor(0);
 rectangle(x1+2,y1+2,x2-2,y2-2);
 setlinestyle(0,0,1);
 setcolor(6);
 settextjustify(1,1);
 outtextxy((x1+x2)div 2,(y1+y2)div 2,str);
end;

procedure pressbutton2(x1,y1,x2,y2:integer;str1,str2:string);

begin
 setfillstyle(1,0 );
 bar(x1,y1,x2,y2);
 setfillstyle(1,15);
 bar(x1,y1,x2,y2);
 setcolor(6);
 rectangle(x1,y1,x2,y2);
 setlinestyle(0,0,3);
 setcolor(0);
 rectangle(x1+2,y1+2,x2-2,y2-2);
 setlinestyle(0,0,1);
 setcolor(6);
 settextjustify(1,1);
 outtextxy((x1+x2)div 2,y1+((y2-y1)div 3)    ,str1);
 outtextxy((x1+x2)div 2,y1+(((y2-y1)div 3)*2),str2);
end;

procedure pressbutton3(x1,y1,x2,y2:integer;str:string);

begin
 setfillstyle(1,15);
 bar(x1+20,y1+20,x2+20,y2+20);
 setlinestyle(0,0,3);
 setcolor(getbkcolor);
 rectangle(x1+20,y1+20,x2+20,y2+20);
 setlinestyle(0,0,1);
 setcolor(6);
 settextjustify(1,1);
 outtextxy(((x1+20)+(x2+20))div 2,((y1+20)+(y2+20))div 2,str);
end;

procedure pressbutton4(x1,y1,x2,y2:integer;str1,str2:string);

begin
 setfillstyle(1,15);
 bar(x1+20,y1+20,x2+20,y2+20);
 setlinestyle(0,0,3);
 setcolor(getbkcolor);
 rectangle(x1+20,y1+20,x2+20,y2+20);
 setlinestyle(0,0,1);
 setcolor(6);
 settextjustify(1,1);
 outtextxy(((x1+20)+(x2+20))div 2,y1+((y2-y1)div 3)+20,     str1);
 outtextxy(((x1+20)+(x2+20))div 2,y1+(((y2-y1)div 3)+20)*2,str2);
end;

procedure mouserahmen1;

begin
 setlinestyle(0,0,3);
 setcolor(15);
 rectangle(0,0,getmaxx,getmaxy);
 rectangle(10,13,getmaxx-10,getmaxy-10);
 setfillstyle(1,15);
 floodfill(2,2,15);
 setcolor(4);
 rectangle(0,0,getmaxx,getmaxy);
 rectangle(10,13,getmaxx-10,getmaxy-10);
 settextjustify(1,1);
 outtextstyle(getmaxx div 2,7,'MenÅ fÅr Kîrper- und FlÑchenberechnung',12,0,0,1);
 setlinestyle(0,0,1);
end;

procedure mouserahmen2;

begin
 setlinestyle(0,0,3);
 setcolor(15);
 rectangle(0,0,getmaxx,getmaxy);
 line(10,13,310,13);
 line(330,13,getmaxx-10,13);
 line(getmaxx-10,13,getmaxx-10,getmaxy-10);
 line(getmaxx-10,getmaxy-10,330,getmaxy-10);
 line(310,getmaxy-10,10,getmaxy-10);
 line(10,getmaxy-10,10,13);
 line(310,13,310,getmaxy-10);
 line(330,13,330,getmaxy-10);
 setfillstyle(1,15);
 floodfill(2,2,15);
 setcolor(4);
 rectangle(0,0,getmaxx,getmaxy);
 line(10,13,310,13);
 line(330,13,getmaxx-10,13);
 line(getmaxx-10,13,getmaxx-10,getmaxy-10);
 line(getmaxx-10,getmaxy-10,330,getmaxy-10);
 line(310,getmaxy-10,10,getmaxy-10);
 line(10,getmaxy-10,10,13);
 line(310,13,310,getmaxy-10);
 line(330,13,330,getmaxy-10);
 settextjustify(1,1);
 outtextstyle(getmaxx div 2,7,ueberschrift,12,0,0,1);
 setlinestyle(0,0,1);
end;

procedure mousebegin;

var anzbutton:byte;mouseok:boolean;

begin
 anzbutton:=3;
 mouseok:=true;
 initmouse(anzbutton,mouseok);
 showmouse;
end;

procedure mouseend;

begin
 hidemouse;
end;

procedure circ(x,y,r:integer);

var i:integer;

begin
 for i:= 0 to r do
 begin
  line(x+i,y+trunc(sqrt(sqr(r)-sqr(i))),x+i,y-trunc(sqrt(sqr(r)-sqr(i))));
  line(x-i,y+trunc(sqrt(sqr(r)-sqr(i))),x-i,y-trunc(sqrt(sqr(r)-sqr(i))));
 end;
 circle(x,y,r);
end;

procedure peep;

var l:integer;

begin
 for l:= 1 to 10 do
 begin
  sound(l*15);
  delay(2);
 end;
 for l:= 1 to 10 do
 begin
  sound((20-l)*15);
  delay(2);
 end;
 nosound;
end;

procedure setdcolor(farbe1,farbe2:word);

begin
 setcolor(farbe1);
 setcolor(farbe2);
end;

procedure cursor16;

var a:word;

begin
 for a:= 1 to 11 do
 begin
  putpixel(x+1,y+a,farbe);
 end;
 for a:= 2 to 10 do
 begin
  putpixel(x+2,y+a,farbe);
 end;
 for a:= 3 to 10 do
 begin
  putpixel(x+3,y+a,farbe);
 end;
 for a:= 4 to 10 do
 begin
  putpixel(x+4,y+a,farbe);
 end;
 for a:= 5 to 12 do
 begin
  putpixel(x+5,y+a,farbe);
 end;
 for a:= 6 to 14 do
 begin
  putpixel(x+6,y+a,farbe);
 end;
 for a:= 7 to 9 do
 begin
  putpixel(x+7,y+a,farbe);
 end;
 for a:= 13 to 14 do
 begin
  putpixel(x+7,y+a,farbe);
 end;
 for a:= 8 to 9 do
 begin
  putpixel(x+8,y+a,farbe);
 end;
 putpixel(x+9,y+9,farbe);
end;

procedure schreiben(x,y:real;str:string;farbe:word);

begin
 setcolor(farbe);
 settextjustify(0,2);
 outtextxy(round((x-1)*8),round((y-1)*8),str);
end;

procedure graphwin(x1,y1,x2,y2:word;farbe:byte);

var z:integer;

begin
 for z:=x1+1 to x2-1 do
 begin
  schreiben(z,y1,'Õ',farbe);
  schreiben(z,y2,'Õ',farbe);
 end;
 for z:=y1+1 to y2-1 do
 begin
  schreiben(x1,z,'∫',farbe);
  schreiben(x2,z,'∫',farbe);
 end;
 schreiben(x1,y1,'…',farbe);
 schreiben(x1,y2,'»',farbe);
 schreiben(x2,y1,'ª',farbe);
 schreiben(x2,y2,'º',farbe);
end;

procedure writexy(x,y:word;str:string);

var a,b:word;

begin
 a:=wherex;
 b:=wherey;
 gotoxy(x,y);
 write(str);
 gotoxy(a,b);
end;

procedure savepicture(x1,y1,x2,y2:integer;datei:string);

var p:pointer;f:file of pointer;size:word;

begin
 size:=imagesize(x1,y1,x2,y2);
 getmem(p,size);
 getimage(x1,y1,x2,y2,p^);
 assign(f,datei);
 {$i-}
 rewrite(f);
 if ioresult = 0 then
 begin
  write(f,p);
  close(f);
  {$i+}
 end else
 begin
  close(f);
  exit;
 end;
end;

procedure loadpicture(x,y:integer;datei:string;bitblt:word);

var p:pointer;f:file of pointer;

begin
 assign(f,datei);
 {$i-}
 reset(f);
 if ioresult = 0 then
 begin
  read(f,p);
  putimage(x,y,p^,bitblt);
  close(f);
  {$i+}
 end else
 begin
  close(f);
  exit;
 end;
end;

function isfilethere(datei:string):boolean;

var dummy:searchrec;

begin
 findfirst(datei,0,dummy);
 isfilethere:=doserror=0;
end;

procedure erasefile(datei:string);

var f:file of pointer;

begin
 assign(f,datei);
 {$i-}
 reset(f);
 {$i+}
 close(f);
 erase(f);
end;

procedure filecopy(datei1,datei2:string);

var f1,f2:file;nr,nw:word;b:array[1..2048]of char;

begin
 assign(f1,datei1);
 assign(f2,datei2);
 {$i-}
 reset(f1,1);
 {$i+}
 rewrite(f2,1);
 repeat
  blockread (f1,b,sizeof(b),nr);
  blockwrite(f2,b,nr       ,nw);
 until (nr = 0) or (nw <> nr);
 close(f1);
 close(f2);
end;

function zahlback(str:string):byte;

var x:integer;

begin
 for x:= 1 to length(str) do
 begin
  if (copy(str,x,1)) = '\' then zahlback:=x;
 end;
end;

procedure weapen(var viewport:viewporttype);

begin
 getviewsettings(viewport);
 with viewport do
 begin
  setlinestyle(0,0,1);
  setcolor(7);
  line(mittex+40,mittey,mittex+70,y2);
  line(mittex-40,mittey,mittex-70,y2);
  line(mittex+40,mittey,mittex-40,mittey);
  setfillstyle(1,7);
  floodfill(mittex,mittey+10,7);
  setlinestyle(0,0,3);
  setcolor(0);
  line(mittex+20,mittey+10,mittex+20,mittey+50);
  line(mittex-20,mittey+10,mittex-20,mittey+50);
  line(mittex+20,218,mittex+30,218);
  line(mittex-20,218,mittex-30,218);
  setlinestyle(0,0,1);
  setcolor(8);
  line(mittex-15,mittey-1,mittex-15,mittey-20);
  line(mittex+15,mittey-1,mittex+15,mittey-20);
  line(mittex-15,mittey-1,mittex+15,mittey-1);
  ellipse(mittex,mittey-20,0,360,15,10);
  setfillstyle(1,8);
  floodfill(mittex,mittey-3,8);
 end;
end;

function mittex:integer;

var viewport:viewporttype;

begin
 getviewsettings(viewport);
 with viewport do
 begin
  mittex:=((x1+x2)div 2)-50;
 end;
end;

function mittey:integer;

var viewport:viewporttype;

begin
 getviewsettings(viewport);
 with viewport do
 begin
  mittey:=((y1+y2)div 2)-50;
 end;
end;

procedure backwall(n:byte);

var a:integer;viewport:viewporttype;

begin
 setcolor(3);
 setrgbpalette(3,100,150,10);
 getviewsettings(viewport);
 with viewport do
 begin
  case n of
1: begin
    for a:= mittex-150 to mittex+150 do
    begin
     line(a,mittey-100,a,mittey+100);
    end;
   end;
2: begin
    for a:= mittex-210 to mittex+210 do
    begin
     line(a,mittey-140,a,mittey+140);
    end;
   end;
3: begin
    for a:= mittex-268 to mittex+265 do
    begin
     line(a,mittey-189,a,mittey+186);
    end;
   end;
  end;
 end;
end;

procedure stern(x,y:word;farbe:byte);

begin
 setcolor(farbe);
 line(x-5,y+5,x+5,y-5);
 line(x-5,y-5,x+5,y+5);
 line(x-5,y,x+5,y);
 line(x,y-5,x,y+5);
end;

procedure movein;

var i:byte;

begin
 for i:=15 downto 0 do
 begin
  port[$03d4]:=9;
  port[$03d5]:=i;
  Delay(100);
 end;
end;

procedure moveout;

var i:byte;

begin
 for i:=0 to 15 do
 begin
  port[$03d4]:=9;
  port[$03d5]:=i;
  Delay(100);
 end;
end;

procedure dickrec(x1,y1,x2,y2:integer;n:word;farbe:byte);

var x:integer;

begin
 setcolor(farbe);
 for x:= 0 to n do
 begin
  rectangle(x1+x,y1+x,x2-x,y2-x);
 end;
end;

procedure schreib;

var wortl:byte absolute str;
    lng:byte;

begin
 if str = '' then exit;
 if x > 80 then exit;
 if y > 25 then dec(y,25);
 dec(x);
 dec(y);
 for lng:=0 to wortl-1 do
 mem[$B800:x*2+y*160+lng*2]:=ord(str[lng+1]);
 mem[$B800:x*2+y*160+lng*2+1]:=n;
end;

procedure loesche;

var a,b:byte;s:string;

begin
 s:='';
 for a:=0 to 80 do s:=s+' ';
 for b:=1 to 25 do schreib(1,b,s,7);
end;

procedure code;

var r:string;bate:file of codefile;wort:byte;ch:char;ba:codefile;

begin
 wort:=random(52)+1;
 assign(bate,name);
 {$i-}
 reset(bate);
 {$i+}
 if ioresult <> 0 then
 begin
  clrscr;
  writeln('FÅhlst dich woll gerissen genug die Code-Datei zu lîschen !');
  ch:=readkey;
  halt(1);
 end else
 begin
  read(bate,ba);
  close(bate);
 end;
 clrscr;
 writeln('Geben Sie das Wort ',wort,' ein !');
 readln(r);
 if r = ba.bat[wort] then
 begin
  clrscr;
  writeln('Richtige eingabe !');
  ch:=readkey;
 end else halt(1);
 clrscr;
end;

procedure readcode(name:string;var ba:codefile);

var bate:file of codefile;

begin
 assign(bate,name);
 {$i-}
 reset(bate);
 {$i+}
 if ioresult = 0 then
 begin
  read(bate,ba);
  close(bate);
 end;
end;

function vercode(ba:string;add:char):string;

var li:integer;

begin
 for li:= 1 to 255 do
 begin
  ba[li]:=char(255 xor (ord(ba[li])+ord(add)));
 end;
 vercode:=ba;
end;

procedure speicherver(var ba:codefile;name:string);

var bate:file of codefile;

begin
 if pos('.',name) = 0 then name:=name+'.ASD';
 assign(bate,name);
 {$i-}
 rewrite(bate);
 {$i+}
 if ioresult = 0 then
 begin
  write(bate,ba);
  close(bate);
 end;
end;

procedure ladever(var ba:codefile;name:string);

var bate:file of codefile;ch:char;

begin
 if pos('.',name) = 0 then name:=name+'.ASD';
 assign(bate,name);
 {$i-}
 reset(bate);
 {$i+}
 clrscr;
 if ioresult = 0 then
 begin
  read(bate,ba);
  close(bate);
 end else
 begin
  write('FÅllst dich woll gerissen die Codedatei zu lîschen.');
  ch:=readkey;
 end;
end;

function entsch(ba:string;add:char):string;

var li:integer;

begin
 for li:= 1 to 255 do
 begin
  ba[li]:=char(255 xor (ord(ba[li])-ord(add)));
 end;
 entsch:=ba;
end;

procedure verschluessele(name:string);

var ba,de:codefile;s:string;add:char;li:integer;

begin
 add:=chr(0);
 s:=name;
 if pos('.',name) = 0 then name:=name+'.R&D';
 readcode(name,ba);
 for li:= 1 to 53 do
 begin
  de.bat[li]:=vercode(ba.bat[li],add);
 end;
 name:=s;
 if pos('.',name) = 0 then name:=name+'.ASD';
 speicherver(de,name);
end;

procedure abfrage(name:string);

var add,ch:char;ba:codefile;li:byte;s,r:string;

begin
 add:=chr(0);
 ladever(ba,name);
 li:=random(52)+1;
 s:=entsch(ba.bat[li],add);
 clrscr;
 writeln('Geben Sie den ',li,'. Code ein!');
 readln(r);
 clrscr;
 if r = s then
 begin
  write('Der eingegebene Code ist richtig !');
  ch:=readkey;
 end else
 begin
  write('Der eingegebene Code ist falsch !');
  ch:=readkey;
  halt(1);
 end;
 clrscr;
end;

procedure schwarbut;

begin
 setfillstyle(1,0);
 bar(x1,y1,x2,y2);
 pressbutton1(x1,y1,x2,y2,str);
 peep;
end;

procedure save_screen;

var screen:array[1..4,1..8000]of byte absolute $b800:0000;

begin
 if screen_akt <= 4 then
 begin
  inc(screen_akt);
  move(screen[1],screen[screen_akt],8000);
 end;
end;

procedure restore_screen;

var screen:array[1..4,1..8000]of byte absolute $b800:0000;

begin
 if screen_akt >= 2 then
 begin
  move(screen[screen_akt],screen[1],8000);
  dec(screen_akt);
 end;
end;

procedure ramen(rt:byte;startx,starty,dx,dy:integer);

const frames:array[1..2,1..6]of char =
 (('⁄','ø','Ÿ','¿','ƒ','≥'),
  ('…','ª','º','»','Õ','∫'));

var lx,ly:integer;s:string;

begin;
 s := frames[rt,1];
 for lx := 1 to dx-2 do s := s + frames[rt,5];
 s := s + frames[rt,2];
 gotoxy(startx,starty);
 write(s);
 for ly := 1 to dy-2 do
 begin
  s := frames[rt,6];
  for lx := 1 to dx-2 do s := s + ' ';
  s := s + frames[rt,6];
  gotoxy(startx,starty+ly);
  write(s);
 end;
 s := frames[rt,4];
 for lx := 1 to dx-2 do s := s + frames[rt,5];
 s := s + frames[rt,3];
 gotoxy(startx,starty+dy-1);
 write(s);
end;

procedure rahmen(x,y,dx,dy:integer;s:string;rcol,bcol:byte);

var tlaeng:byte;deltx,tstartpos:byte;

begin
 tlaeng := length(s);
 tstartpos := x + ((dx-tlaeng) shr 1);
 textcolor(rcol);
 textbackground(bcol);
 ramen(1,x,y,dx,dy);
 writexy(tstartpos,y,s);
end;

function select_datei(dir,mask,mtext,comment:string):string;

const zeile:byte=1;spalte:byte=0;start_fndisp:word=0;

var dirinfo:searchrec;count,li,lj:integer;select,nullpos:byte;inp:char;
    retval:string;changed,kasten_gefunden:boolean;end_fndisp:word;

 procedure sort_filenames(start,ende:integer);

 var hilfe:string;l1,l2:integer;

 begin;
  for l1 := start to ende-1 do
  begin
   for l2 := start to ende-1 do
   begin
    if filenames[l2] > filenames[l2+1] then
    begin
     hilfe := filenames[l2];
     filenames[l2] := filenames[l2+1];
     filenames[l2+1] := hilfe;
    end;
   end;
  end;
 end;

begin
 {$I-}
 for li:= 1 to 512 do filenames[li] := ' - - -';
 count:=1;
 if dir <> '' then findfirst(dir+mask,archive,dirinfo) else findfirst(mask,archive,dirinfo);
 while DosError = 0 do
 begin
  filenames[count] := (DirInfo.Name);
  Nullpos := pos(#0,filenames[count]);
  if Nullpos <> 0 then filenames[count]:=copy(filenames[count],0,Nullpos-1);
  inc(count);
  FindNext(DirInfo);
 end;
 {$I+}
 sort_filenames(1,count-1);
 save_screen;
 rahmen(5,4,72,16,comment,black,7);
 textcolor(1);
 writexy(21,5,'         Bitte Datei auswÑhlen');
 textcolor(0);
 inp:=#255;
 changed:=true;
 repeat
  textcolor(0);
  if changed then
  begin
   changed := false;
   for lj := 0 to 4 do
   begin
    for li := 1 to 12 do
    begin
     writexy(7+lj*14,5+li,'            ');
     writexy(7+lj*14,5+li,filenames[lj*12+li+Start_fndisp]);
    end;
   end;
   textcolor(14);
   writexy(7+Spalte*14,5+Zeile,filenames[Spalte*12+Zeile+Start_fndisp]);
  end;
  if keypressed then inp := readkey;
  if ord(inp) = 0 then inp := readkey;
  case ord(inp) of
  32,13:begin
         inp:=#13;
         changed:=true;
         if (pos('- - -',filenames[Spalte*12+Zeile+Start_fndisp]) = 0) then
         retval:=filenames[Spalte*12+Zeile+Start_fndisp] else retval:='xxxx';
        end;
     27:begin
         inp:=#27;
         changed:=true;
         retval:='xxxx';
        end;
     71:begin
         inp:=#255;
         Zeile:=1;
         Spalte:=0;
         changed:=true;
        end;
     72:begin
         inp := #255;
         changed := true;
         if not ((Zeile = 1) and (Spalte = 0)) then dec(Zeile);
         if Zeile = 0 then
         begin
          dec(Spalte);
          Zeile := 12;
         end;
        end;
     73:begin
         if Start_fndisp >= 12 then dec(Start_fndisp,12) else
         begin
          Start_fndisp := 0;
          Zeile := 1;
         end;
         inp := #255;
         changed := true;
        end;
     81:begin
         if ((Spalte+1)*12+Start_fndisp < count) and (Start_fndisp < 500) then
         inc(Start_fndisp,12) else Start_fndisp := count-11;
         inp := #255;
         changed := true;
        end;
     75:begin
         inp := #255;
         changed := true;
         if Spalte = 0 then
         begin
          if Start_fndisp >= 12 then dec(Start_fndisp,12);
         end else
         begin
          if Spalte > 0 then dec(Spalte);
         end;
        end;
     77:begin
         inp := #255;
         changed := true;
         if Spalte = 4 then
         begin
          if ((Spalte+1)*12+Start_fndisp < count) and (Start_fndisp < 500) then inc(Start_fndisp,12);
         end else
         begin
          if (Spalte < 4) and (Zeile+(Spalte+1)*12+Start_fndisp < count) then inc(Spalte);
         end;
        end;
     79:begin
         inp := #255;
         changed := true;
         Spalte := (count-Start_fndisp-12) div 12;
         Zeile := (count-Start_fndisp) - Spalte*12 -1;
        end;
    80:begin
        inp := #255;
        changed := true;
        if ((Zeile = 12) and (Spalte = 4)) then
        begin
         if (Start_fndisp+Zeile+Spalte*12 < count-1) then
         begin
          inc(Start_fndisp,1);
         end;
         end else
         begin
          if (Start_fndisp+Zeile+Spalte*12 < count-1) then inc(Zeile);
         end;
         if Zeile > 12 then
         begin
          inc(Spalte);
          Zeile := 1;
         end;
        end;
     82:begin
         changed := true;
         save_screen;
         textcolor(black);
         ramen(2,16,9,45,5);
         writexy(20,10,' Dateinamen eingeben ('+mtext+')');
         writexy(20,12,'Name: ');
         gotoxy(26,12);readln(retval);
         if retval = '' then retval := 'xxxx';
         restore_screen;
        end;
  end;
 until (inp = #13) or (inp = #27) or (inp = #32) or (inp = #82);
 restore_screen;
 textbackground(black);
 textcolor(7);
 select_datei := retval;
end;

procedure copyright(s:string);

var i,j,n:integer;

begin
 gotoxy(1,1);
 clrscr;
 n:=1;
 for i:= 0 to 1 do
 begin
  for j:= 1 to length(s) do
  begin
   if i = 0 then
   begin
    textcolor(15);
   end;
   if (i = 1) and (n = 1) then
   begin
    textcolor(0);
    gotoxy(1,1);
    n:=0;
   end;
   write(s[j]);
   delay(100);
  end;
 end;
end;

procedure cls;

var lv:word;

begin
 for lv:=0 to 1999 do
 begin
  mem[$B800:lv*2]:=32;
  mem[$B800:lv*2+1]:=7
 end;
end;

procedure wri;

var wortl:byte absolute wort;lng:byte;

begin
 if wort = '' then exit;
 if spalte > 80 then exit;
 if zeile > 25 then dec(zeile,25);
 dec(spalte);
 dec(zeile);
 for lng:=0 to wortl-1 do
 mem[$B800:spalte*2+Zeile*160+lng*2]:=ord(wort[lng+1]);
end;

procedure farbe(spalte,zeile,col:byte;laenge:word);

var lv:word;

begin
 dec(spalte);
 dec(zeile);
 for lv:=1 to laenge do
 mem[$B800:spalte*2+Zeile*160+lv*2-1]:=col
end;

procedure wrif(spalte,zeile:byte;wort:string;color:byte);

begin
 farbe(spalte,zeile,color,length(wort));
 wri(spalte,zeile,wort)
end;

function tan(x:real):real;

begin
 if round(cos(x)) <> 0 then tan:=sin(x)/cos(x) else tan:=0;
end;

function pid1:real;

begin
 pid1:=pi/180;
end;

procedure cursor(n:byte);

begin
 if n = 1 then cursoron;
 if n = 2 then cursorblock;
 if n = 3 then cursoroff;
end;

procedure forwad(strecke:real;richtung:integer);

var x,y:integer;

begin
 x:=round(strecke*cos(richtung*pid1));
 y:=round(strecke*sin(richtung*pid1));
 linerel(x,-y);
end;

procedure back(strecke:real;richtung:integer);

begin
 forwad(-strecke,richtung);
end;

procedure secret_readln(var s:string);

var c:char;li:integer;

begin
 repeat
  c:=readkey;
  if c <> #8 then
  begin
   s:=s+c;
   gotoxy(24,12);
   for li:= 1 to length(s) do write('*');
  end else
  begin
   s:=copy(s,1,length(s)-1);
   gotoxy(24,12);
   for li:= 1 to length(s) do write('*');
   write(' ');
   gotoxy(wherex-1,wherey);
  end;
 until c = #13;
end;

function intrange(min,max,zahl:integer):boolean;

begin
 if (zahl >= min) and (zahl <= max) then intrange:=true else intrange:=false;
end;

function realrange(min,max,zahl:real):boolean;

begin
 if (zahl >= min) and (zahl <= max) then realrange:=true else realrange:=false;
end;

function kleinbuchstabe(ch:char):boolean;

begin
 if ch in['a'..'z','Ñ','î','Å'] then kleinbuchstabe:=true else kleinbuchstabe:=false;
end;

function grossbuchstabe(ch:char):boolean;

begin
 if ch in['A'..'Z','é','ô','ö'] then grossbuchstabe:=true else grossbuchstabe:=false;
end;

function buchstabe(ch:char):boolean;

begin
 if kleinbuchstabe(ch) or grossbuchstabe(ch) then buchstabe:=true else buchstabe:=false;
end;

function ziffer(ch:char):boolean;
begin
 if ch in['0'..'9'] then ziffer:=true else ziffer:=false;
end;

function alleleerzentf(st:string):string;

var helpstr:string;i:byte;

begin
 if length(st) = 0 then helpstr:='' else
 begin
  helpstr:='';
  for i:= 1 to length(st) do
  begin
   if (copy(st,i,1)) <> ' '
   then helpstr:=helpstr+copy(st,i,1);
  end;
 end;
 alleleerzentf:=helpstr;
end;

function strtointeger(st:string):integer;

var erg:real;i:byte;ok:boolean;

 procedure keineintegerzahl;

 begin
  strtointeger:=0;
  uok:=false;
 end;

begin
 st:=alleleerzentf(st);
 ok:=true;
 uok:=true;
 for i:= 1 to length(st) do
 begin
  if (st[i]='.') or (st[i]=',') then ok:=false;
 end;
 if ok then
 begin
  erg:=strtoreal(st);
  if realrange(-32768.0,32767.0,erg) then strtointeger:=trunc(erg) else
  keineintegerzahl;
 end else keineintegerzahl;
end;

function strtoreal(st:string):real;

var realzahl:real;fehler:integer;i:byte;

 procedure keinerealzahl;

 begin
  strtoreal:=0.0;
  uok:=false;
 end;

begin
 uok:=true;
 st:=alleleerzentf(st);
 if length(st) > 0 then
 begin
  for i:= 1 to length(st) do
  begin
   if st[i] = ',' then st[i]:='.';
  end;
  val(st,realzahl,fehler);
  if fehler = 0
  then strtoreal:=realzahl
  else keinerealzahl;
 end
 else keinerealzahl;
end;

function numtostr(zahl:real;laenge,nach:byte):string;

var st:string;

begin
 st:='';
 str(zahl:laenge:nach,st);
 numtostr:=st;
end;

function filemake(dateiname:string):boolean;

var f:file;err:byte;

begin
 assign(f,dateiname);
 {$i+}
 rewrite(f);
 {$i-}
 if ioresult = 0 then
 begin
  filemake:=true;
  {$i+}
  close(f);
  erase(f);
  {$i-}
  err:=ioresult;
 end else filemake:=false;
end;

procedure reade(x,y:byte;var s:string);

var ch:char;li:integer;

begin
 repeat
  ch:=readkey;
  if ch <> #8 then
  begin
   s:=s+ch;
   wrif(x,y,s,15);
  end else
  begin
   s:=copy(s,1,length(s)-1);
   wrif(x,y,s,15);
   wrif(x+length(s),y,' ',0);
  end;
 until ch = #13;
end;

function copychar(s:string;i:integer):char;

begin
 copychar:=s[i];
end;

procedure grareade(x,y:integer;var s:string;ab:integer);

var ch:char;li:integer;

begin
 repeat
  ch:=readkey;
  if ch <> #8 then
  begin
   s:=s+ch;
   setcolor(15);
   outtextxy(x,y,s);
  end else
  begin
   setcolor(0);
   outtextxy(x,y,s);
   s:=copy(s,1,length(s)-1);
   setcolor(15);
   outtextxy(x,y,s);
  end;
 until ch = #13;
 s:=copy(s,1,length(s)-1);
end;

procedure graareade(x,y:integer;var s:string);

var ch:char;li:integer;

begin
 repeat
  ch:=readkey;
  if ch <> #8 then
  begin
   setcolor(0);
   outtextxy(x,y,s);
   s:=s+ch;
   setcolor(15);
   outtextxy(x,y,s);
  end else
  begin
   setcolor(0);
   outtextxy(x,y,s);
   s:=copy(s,1,length(s)-1);
   setcolor(15);
   outtextxy(x,y,s);
  end;
 until ch = #13;
 s:=copy(s,1,length(s)-1);
end;

procedure erkeneerade(x,y:integer;var s:string;ab:integer);

var textsettings:textsettingstype;

begin
 gettextsettings(textsettings);
 with textsettings do
 begin
  if (horiz <> 1) and (vert <> 1) then grareade(x,y,s,ab) else graareade(x,y,s);
 end;
end;

function cot(r:real):real;

begin
 if round(sin(r)) <> 0 then cot:=cos(r)/sin(r) else cot:=0;
end;

function sec1(x:real):real;

begin
 if round(tan(x)) <> 0 then sec1:=cos(x)/tan(x) else sec1:=0;
end;

function cosec1(x:real):real;

begin
 if round(tan(x)) <> 0 then cosec1:=sin(x)/tan(x) else cosec1:=0;
end;

function sec2(x:real):real;

begin
 if round(cot(x)) <> 0 then sec2:=cos(x)/cot(x) else sec2:=0;
end;

function cosec2(x:real):real;

begin
 if round(cot(x)) <> 0 then cosec2:=sin(x)/cot(x) else cosec2:=0;
end;

procedure circ2(x,y,r:integer;farbe:byte);

var i:integer;

begin
 setcolor(farbe);
 for i:= 0 to 360 do
 begin
  moveto(x,y);
  forwad(r,i);
 end;
end;

procedure flacker(x1,y1,x2,y2:integer;s:string;gross,del:word);

var i,j:integer;

begin
 setlinestyle(0,0,3);
 setwritemode(xorput);
 settextjustify(1,1);
 outtextxy((x1+x2)div 2,(y1+y2)div 2,s);
 repeat
  for i:= 1 to gross do
  begin
   j:=0;
   setcolor(15);
   rectangle(x1-i,y1-i,x2+i,y2+i);
   inc(j,2);
   setcolor(10);
   rectangle(x1-(j+i),y1-(j+i),x2+(j+i),y2+(j+i));
   inc(j,2);
   setcolor(2);
   rectangle(x1-(j+i),y1-(j+i),x2+(j+i),y2+(j+i));
   inc(j,2);
   setcolor(9);
   rectangle(x1-(j+i),y1-(j+i),x2+(j+i),y2+(j+i));
   inc(j,2);
   setcolor(1);
   rectangle(x1-(j+i),y1-(j+i),x2+(j+i),y2+(j+i));
   inc(j,2);
   setcolor(9);
   rectangle(x1-(j+i),y1-(j+i),x2+(j+i),y2+(j+i));
   inc(j,2);
   setcolor(2);
   rectangle(x1-(j+i),y1-(j+i),x2+(j+i),y2+(j+i));
   inc(j,2);
   setcolor(10);
   rectangle(x1-(j+i),y1-(j+i),x2+(j+i),y2+(j+i));
   inc(j,2);
   setcolor(15);
   rectangle(x1-(j+i),y1-(j+i),x2+(j+i),y2+(j+i));
   inc(j,2);
   setcolor(10);
   rectangle(x1-(j+i),y1-(j+i),x2+(j+i),y2+(j+i));
   inc(j,2);
   setcolor(2);
   rectangle(x1-(j+i),y1-(j+i),x2+(j+i),y2+(j+i));
   inc(j,2);
   setcolor(9);
   rectangle(x1-(j+i),y1-(j+i),x2+(j+i),y2+(j+i));
   inc(j,2);
   setcolor(1);
   rectangle(x1-(j+i),y1-(j+i),x2+(j+i),y2+(j+i));
   inc(j,2);
   setcolor(9);
   rectangle(x1-(j+i),y1-(j+i),x2+(j+i),y2+(j+i));
   inc(j,2);
   setcolor(2);
   rectangle(x1-(j+i),y1-(j+i),x2+(j+i),y2+(j+i));
   inc(j,2);
   setcolor(10);
   rectangle(x1-(j+i),y1-(j+i),x2+(j+i),y2+(j+i));
   inc(j,2);
   setcolor(15);
   rectangle(x1-(j+i),y1-(j+i),x2+(j+i),y2+(j+i));
   inc(j,2);
   delay(del);
  end;
 until keypressed;
 setwritemode(normalput);
 settextjustify(0,0);
end;

procedure graphiright(s:string;farbe:byte);

var i,j,n:integer;

begin
 moveto(0,0);
 cleardevice;
 n:=1;
 for i:= 0 to 1 do
 begin
  for j:= 1 to length(s) do
  begin
   if i = 0 then
   begin
    setcolor(farbe);
   end;
   if (i = 1) and (n = 1) then
   begin
    setcolor(0);
    moveto(0,0);
    n:=0;
   end;
   outtext(s[j]);
   delay(100);
  end;
 end;
end;

procedure movewad(strecke:real;richtung:integer);

var x,y:integer;

begin
 x:=round(strecke*cos(richtung*pid1));
 y:=round(strecke*sin(richtung*pid1));
 moverel(x,-y);
end;

function verschlussele(ch:string):string;

var add:char;li:integer;ba:string;

begin
 add:=chr(0);
 for li:= 1 to length(ch) do
 begin
  ch[li]:=char(255 xor (ord(ch[li])+ord(add)));
 end;
 verschlussele:=ch;
end;

function entschlussele(ch:string):string;

var add:char;li:integer;ba:string;

begin
 add:=chr(0);
 for li:= 1 to length(ch) do
 begin
  ch[li]:=char(255 xor (ord(ch[li])-ord(add)));
 end;
 entschlussele:=ch;
end;

procedure readefarbe(x,y:byte;var s:string;farbe,hinter:byte);

var ch:char;li:integer;

begin
 repeat
  ch:=readkey;
  if ch <> #8 then
  begin
   s:=s+ch;
   wrif(x,y,s,farbe);
  end else
  begin
   s:=copy(s,1,length(s)-1);
   wrif(x,y,s,farbe);
   wrif(x+length(s),y,' ',hinter);
  end;
 until ch = #13;
end;

procedure fadein;

var i,j:integer;oldpal:tdacblock;

begin
 for i:= 0 to 256 do
 begin
  for j:= 0 to 2 do
  begin
   oldpal[i][j]:=0;
  end;
 end;
 for i:= 1 to 64 do
 begin
  for j:= 0 to 256 do
  begin
   if oldpal[j][0] < zpal[j][0] then inc(oldpal[j][0]);
   if oldpal[j][1] < zpal[j][1] then inc(oldpal[j][1]);
   if oldpal[j][2] < zpal[j][2] then inc(oldpal[j][2]);
  end;
  waitohnedelay;
  delay(del);
  setdacblock(0,256,oldpal);
 end;
end;

procedure fadeout;

var i,j:integer;newpal:tdacblock;

begin
 newpal:=pal;
 for i:= 1 to 64 do
 begin
  for j:= 0 to 256 do
  begin
   if newpal[j][0] > 0 then dec(newpal[j][0]);
   if newpal[j][1] > 0 then dec(newpal[j][1]);
   if newpal[j][2] > 0 then dec(newpal[j][2]);
  end;
  waitohnedelay;
  delay(del);
  setdacblock(0,256,newpal);
 end;
end;

procedure fadeto;

var i,j:integer;

begin
 for i:= 1 to 64 do
 begin
  for j:= 0 to 256 do
  begin
   if qpal[j][0] < zpal[j][0] then inc(qpal[j][0]);
   if qpal[j][0] > zpal[j][0] then dec(qpal[j][0]);
   if qpal[j][1] < zpal[j][1] then inc(qpal[j][1]);
   if qpal[j][1] > zpal[j][1] then dec(qpal[j][1]);
   if qpal[j][2] < zpal[j][2] then inc(qpal[j][2]);
   if qpal[j][2] > zpal[j][2] then dec(qpal[j][2]);
  end;
  waitohnedelay;
  delay(del);
  setdacblock(0,256,qpal);
 end;
end;

procedure fadepicture(p:pointer;x,y:integer);

var i,j,a:integer;

begin
 for a:= 1 to 64 do
 begin
  for i:= 0 to y-1 do
  begin
   for j:= 0 to x-1 do
   begin
    if mem[ofs(p^):i*320+j] < mem[$a000:i*320+j] then inc(mem[ofs(p^):i*320+j]);
    if mem[ofs(p^):i*320+j] > mem[$a000:i*320+j] then dec(mem[ofs(p^):i*320+j]);
   end;
  end;
  for j:= 0 to y-1 do
  begin
   move(mem[ofs(p^):i*320+j],mem[$a000:j*320],x);
  end;
  waitohnedelay;
 end;
end;

procedure schrift(kx,ky,rx,ry:word;s:string;farbe:byte);

var x,y,nummer:array[1..30]of word;i,r,bogen2,l:integer;
    bogen:array[0..360]of word;ender:boolean;

begin
 settextjustify(1,1);
 s:=alleleerzentf(s);
 l:=length(s);
 bogen[0]:=0;
 for r:= 1 to 360 do bogen[r]:=bogen[r-1]-44;
 repeat
  for i:= 1 to l do
  begin
   nummer[i]:=((360 div l)*i)-(360 div l);
  end;
  for r:= 0 to 354 do
  begin
   for bogen2:= 1 to l do
   begin
    inc(nummer[bogen2]);
    if nummer[bogen2] = 355 then nummer[bogen2]:=0;
   end;
   setcolor(farbe);
   for i:= 1 to l do
   begin
    x[i]:=kx+round(cos(bogen[nummer[i]])*rx);
    y[i]:=ky+round(sin(bogen[nummer[i]])*ry);
   end;
   for i:= 1 to l do
   begin
    setcolor(farbe);
    outtextxy(x[i],y[i],s[i]);
   end;
   if keypressed then exit;
   delay(28);
   for i:= 1 to l do
   begin
    setcolor(0);
    outtextxy(x[i],y[i],s[i]);
   end;
  end;
 until keypressed;
end;

procedure circolor(x,y:integer;farbe:byte;r:integer);

begin
 setcolor(farbe);
 circ(x,y,r);
end;

procedure inituser(f:string;modes:integer);

var gd:integer;

begin
 gd:=installuserdriver(f,nil);
 initgraph(gd,modes,pather);
end;

procedure bootneu;assembler;

asm
 int 19h
end;

procedure waitohnedelay;assembler;

asm
  mov dx,3dah
@wait1:
  in al,dx
  test al,08h
  jnz @wait1
@wait2:
  in al,dx
  test al,08h
  jz @wait2
  ret
end;

procedure putpixasm;assembler;

asm
 mov ah,12
 mov cx,x
 mov dx,y
 mov al,farbe
 int 10h
end;

procedure lineasm;assembler;

var x:word;

asm
  mov si,x1
  mov x,si
  sub si,x2
  mov ax,y1
  mov bx,ax
  sub ax,y2
  mov cx,100
  imul cx
  idiv si
  mov si,ax
  xor cx,cx
@lp:
  push x
  push bx
  push farbe
  call PutPixasm
  add cx,si
  cmp cx,100
  jb @kein_ueberlauf
  sub cx,100
  inc bx
@kein_ueberlauf:
  inc x
  mov ax,x
  cmp ax,x2
  jb @lp
end;

function timer:longint;

var gt:longint;h,m,s,s100:word;

begin
 gettime(h,m,s,s100);
 gt:=s100;
 gt:=gt+6000*s;
 gt:=gt+360000*m;
 timer:=gt;
end;

function initvesa;

begin
 with reg do
 begin
  ah:=$4f;
  al:=1;
  cx:=modi;
  es:=seg(vesa);
  di:=ofs(vesa);
  intr($10,reg);
  if ah <> 0 then
  begin
   initvesa:=false;
   exit;
  end;
 end;
 with reg do
 begin
  ah:=$4f;
  al:=2;
  bx:=modi;
  intr($10,reg);
  if ah <> 0 then
  begin
   initvesa:=false;
   exit;
  end;
 end;
 maxxkoor:=vesa.maxx;
 initvesa:=true;
 l:=vesa.maxx;
end;


procedure setflag;

var biostsbyte:byte absolute $0040:$0017;regs:registers;

begin
 biostsbyte:=biostsbyte or flag;
 regs.ah:=1;
 intr($16,regs);
end;

procedure clrflag;

var biostsbyte:byte absolute $0040:$0017;regs:registers;

begin
 biostsbyte:=biostsbyte and(not flag);
 regs.ah:=1;
 intr($16,regs);
end;

procedure dicker;

var i:integer;

begin
 setcolor(farbe);
 for i:= r to r+(((getmaxx+1)*(getmaxy+1))div 30720) do circle(x,y,i);
end;

function getchar;

begin
 getchar:=chr(mem[$b800:(x-1)*2+(y-1)*160]);
end;

function prim;

var y:integer;

begin
 prim:=true;
 for y:= 2 to x-1 do
 begin
  if x mod y = 0 then prim:=false;
 end;
end;

procedure wintodos;

var i:word;

begin
 for i:= 0 to 256 do
 begin
  s[i].r:=f[i].r shr 2;
  s[i].g:=f[i].g shr 2;
  s[i].b:=f[i].b shr 2;
 end;
end;

procedure dactodacer;

var i:word;

begin
 for i:= 0 to 256 do
 begin
  t[i][0]:=s[i].r;
  t[i][1]:=s[i].g;
  t[i][2]:=s[i].b;
 end;
end;

procedure setdacblock;
var i:word;
begin
 for i:=0 to 255 do
 begin
  palette[i*3+0]:=block[i][0];
  palette[i*3+1]:=block[i][1];
  palette[i*3+2]:=block[i][2];
  end;
  setpal;
end;

procedure vertausch;

var c:longint;

begin
 c:=a;
 a:=b;
 b:=c;
end;

procedure dreid;

begin
 x:=round(-z*cos(wink*pi/180)*cos(wink*pi/180)/-sin(wink*pi/180)+x);
 y:=round(-z*cos(wink*pi/180)*sin(wink*pi/180)/-sin(wink*pi/180)+y);
end;

function dreidx;

var x1,y1:integer;xd,yd,zd:real;

begin
 xd:=cos(wink*pi/180)*cos(wink*pi/180);
 yd:=cos(wink*pi/180)*sin(wink*pi/180);
 zd:=-sin(wink*pi/180);
 x1:=round(-z*xd/zd+x);
 y1:=round(-z*yd/zd+y);
 dreidx:=x1;
end;

function dreidy;

var x1,y1:integer;xd,yd,zd:real;

begin
 xd:=cos(wink*pi/180)*cos(wink*pi/180);
 yd:=cos(wink*pi/180)*sin(wink*pi/180);
 zd:=-sin(wink*pi/180);
 x1:=round(-z*xd/zd+x);
 y1:=round(-z*yd/zd+y);
 dreidy:=y1;
end;

procedure svga386driverproc;external;

{$l svga386.obj}

procedure svga386(mode:byte);

begin
 if registerbgidriver(@svga386driverproc) < 0 then
 gd:=detect;
 gm:=mode;
 initgraph(gd,gm,pather);
end;

procedure init13;

begin
 asm
  mov ax,13h
  int 10h
 end;
 h13:=true;
end;

procedure pixmem;

begin
 if h13 then mem[$a000:y*320+x]:=farbe else grapherror:=1;
end;

procedure ptrtomem(x,y:integer;p:pointer;l:integer);

begin
 if h13 then move(p^,mem[$a000:y*320+x],l) else grapherror:=1;
end;

function filestring;

var akt,t:longint;l:byte;n:string;exier:boolean;

begin
 akt:=filepos(f);
 l:=length(s);
 seek(f,1);
 exier:=false;
 repeat
  blockread(f,n,l);
  if n = s then exier:=true;
  seek(f,filepos(f)-l+1);
 until exier or (filepos(f) = filesize(f)-l);
 filestring:=filepos(f);
 seek(f,akt);
end;


procedure bytetohex;

begin
 hex[0]:=hexconst[x div 16];
 hex[1]:=hexconst[x mod 16];
end;

procedure chartohex;

var f:byte;

begin
 f:=ord(x);
 hex[0]:=hexconst[f div 16];
 hex[1]:=hexconst[f mod 16];
end;

function hextobyte;

var a,b,c:integer;

begin
 a:=0;
 b:=0;
 if hex[0] = '0' then a:=0 else
 repeat
  inc(a);
 until hex[0] = hexconst[a];
 if hex[1] = '0' then b:=0 else
 repeat
  inc(b);
 until hex[1] = hexconst[b];
 c:=0;
 c:=a*16;
 c:=c+b;
 hextobyte:=c;
end;

function hextochar;

var a,b,c:integer;

begin
 a:=0;
 b:=0;
 if hex[0] = '0' then a:=0 else
 repeat
  inc(a);
 until hex[0] = hexconst[a];
 if hex[1] = '0' then b:=0 else
 repeat
  inc(b);
 until hex[1] = hexconst[b];
 c:=0;
 c:=a*16;
 c:=c+b;
 hextochar:=chr(c);
end;

function bintobyte;

var f,f2:byte;

begin
 f2:=0;
 for f:= 8 downto 1 do if x[f] = 1 then f2:=f2+binconst[f];
 bintobyte:=f2;
end;

function bintochar;

var f,f2:byte;

begin
 f2:=0;
 for f:= 8 downto 1 do
 begin
  if x[f] = 1 then f2:=f2+binconst[f];
 end;
 bintochar:=chr(f2);
end;

procedure bytetobin;

var f2:byte;

begin
 for f2:= 1 to 8 do if f >= binconst[f2] then
 begin
  dec(f,binconst[f2]);
  x[f2]:=1;
 end else x[f2]:=0;
end;

procedure chartobin(var x:bintype;f:char);

var f1,f2:byte;

begin
 f1:=ord(f);
 for f2:= 1 to 8 do
 begin
  if f1 >= binconst[f2] then
  begin
   dec(f1,binconst[f2]);
   x[f2]:=1;
  end;
 end;
end;

function dubblebintoword(var x:dubblebin):word;

var f:byte;f2:word;

begin
 f2:=0;
 for f:= 16 downto 1 do
 begin
  if x[f] = 1 then f2:=f2+dubblebinconst[f];
 end;
 dubblebintoword:=f2;
end;

procedure wordtodubblebin(var x:dubblebin;f:word);

var f2:word;

begin
 for f2:= 1 to 16 do
 begin
  if f >= dubblebinconst[f2] then
  begin
   dec(f,dubblebinconst[f2]);
   x[f2]:=1;
  end;
 end;
end;

function getmaxz;

begin
 getmaxz:=(getmaxx+getmaxy) div 2;
end;

procedure fastline(x,y,x2,y2:word;color:byte);assembler;
asm
 mov ax,$A000
 mov es,ax
 mov bx,x
 mov ax,y
 mov cx,x2
 mov si,y2
 cmp ax,si
 jbe @NO_SWAP
 xchg bx,cx
 xchg ax,si
@NO_SWAP:
 sub si,ax
 sub cx,bx
 cld
 jns @H_ABS
 neg cx
 std
@H_ABS:
 mov di,320
 mul di
 mov di,ax
 add di,bx
 or si,si
 jnz @NOT_H
 cld
 mov al,color
 inc cx
 rep stosb
 jmp @EXIT
@NOT_H:
 or cx,cx
 jnz @NOT_V
 cld
 mov al,color
 mov cx,si
 inc cx
 mov bx,320-1
@VLINE_LOOP:
 stosb
 add di,bx
 loop @VLINE_LOOP
 jmp @EXIT
@NOT_V:
 cmp cx,si
 lahf
 ja @H_IND
 xchg cx,si
@H_IND:
 mov dx,si
 sub dx,cx
 shl dx,1
 shl si,1
 mov bx,si
 sub bx,cx
 inc cx
 push bp
 mov bp,320
 mov al,color
 sahf
 jb @DIAG_V
 or bx,bx
@LH:
 stosb
 jns @SH
 add bx,si
 loop @LH
 jmp @X
@SH:
 add di,bp
 add bx,dx
 loop @LH
 jmp @X
@DIAG_V:
 or bx,bx
@LV:
 mov es:[di],al
 jns @SV
 add di,bp
 add bx,si
 loop @LV
 jmp @X
@SV:
 scasb
 add di,bp
 add bx,dx
 loop @LV
@X:
 pop bp
@EXIT:
end;

Function ShiftState:Byte;

Var Regs:Registers;

begin
 Regs.Ah:=2;
 Intr($16,Regs);
 ShiftState:=Regs.Al;
end;

Function RightShift:Boolean;

begin
 RightShift:=(ShiftState and 1) <> 0;
end;

Function LeftShift:Boolean;

begin
 LeftShift:=(ShiftState and 2) <> 0;
end;

Function Control:Boolean;

begin
 Control:=(ShiftState and 4) <> 0;
end;

Function Alt:Boolean;

begin
 Alt:=(ShiftState and 8) <> 0;
end;

Function ScrollLock:Boolean;

begin
 ScrollLock:=(ShiftState and 16) <> 0;
end;

Function NumLock:Boolean;

begin
 NumLock:=(ShiftState and 32) <> 0;
end;

Function CapsLock:Boolean;

begin
 CapsLock:=(ShiftState and 64) <> 0;
end;

Function Insert:Boolean;

begin
 Insert:=(ShiftState and 128) <> 0;
end;

function isdirthere(path,chek:dos.pathstr):boolean;

var sr:searchrec;s:string;

begin
 getdir(3,s);
 if Path[Length(Path)] <> '\' then Path:=Path+'\';
 {$I-}
 if (Length(Path) = 3) and (Copy(Path, 2, 2) = ':\') then ChDir(Path) else
 ChDir(Copy(Path,1,Length(Path)-1));
 if IOResult <> 0 then exit;
 {$I-}
 FindFirst(Path+'*.*',16,SR);
 isdirthere:=false;
 while DosError = 0 do
 begin
  if ((SR.Attr and 16) <> 0) then
  begin
   FindNext(SR);
   if sr.name = chek then isdirthere:=true;
  end;
 end;
 chdir(s);
end;

function laufwerkda;assembler;
asm
  mov   dl,c
  mov   ah,36h
  sub   dl,'A'-1
  int   21h
  inc   ax
  je    @@2
@@1:
  mov   al,1
@@2:
end;

procedure getalldirs;

var x:byte;

begin
 for x:= 3 to 26 do
 begin
  laufwerke[x]:=laufwerkda(chr(x+64));
 end;
end;

function tribblebintolongint(var x:tribblebin):longint;

var f:byte;f2:longint;

begin
 f2:=0;
 for f:= 24 downto 1 do
 begin
  if x[f] = 1 then f2:=f2+tribblebinconst[f];
 end;
 tribblebintolongint:=f2;
end;

procedure longinttotribblebin(var x:tribblebin;f:longint);

var f2:byte;

begin
 for f2:= 1 to 24 do
 begin
  if f >= tribblebinconst[f2] then
  begin
   dec(f,tribblebinconst[f2]);
   x[f2]:=1;
  end;
 end;
end;

procedure svgapixel(x,y:word;farbe:byte);

var pos:longint;page,offs:word;

begin
 pos:=longint(y)*vesa.maxx+longint(x);
 page:=pos div longint(65536);
 offs:=pos mod longint(65536);
 reg.ah:=$4f;
 reg.al:=$05;
 reg.bh:=$00;
 reg.bl:=0;
 reg.dx:=page;
 intr($10,reg);
 mem[vesa.w1seg:offs]:=farbe;
end;

procedure pointertosvga;

var pos:longint;page,offs:word;

begin
 pos:=longint(y)*vesa.maxx+longint(x);
 page:=pos div longint(65536);
 offs:=pos mod longint(65536);
 with reg do
 begin
  ah:=$4f;
  al:=$05;
  bh:=$00;
  bl:=0;
  dx:=page;
  intr($10,reg);
 end;
{if 65536-(offs+laenge) < 0 then
 begin
  move(p,mem[vesa.w1seg:offs],65536-offs);
  with reg do
  begin
   ah:=$4f;
   al:=$05;
   bh:=$00;
   bl:=0;
   dx:=page+1;
   intr($10,reg);
  end;
  move(ptr(seg(p),65536-offs)^,mem[vesa.w1seg:0],laenge-(65536-offs));
 end else}
 move(p,mem[vesa.w1seg:offs],laenge);
end;

procedure puttruepixel;

var pos:longint;page,offs:word;

begin
 pos:=y*vesa.maxx+x;
 page:=pos div 65536;
 offs:=pos mod 65536;
 reg.ah:=$4f;
 reg.al:=$05;
 reg.bh:=$00;
 reg.bl:=0;
 reg.dx:=page;
 intr($10,reg);
 move(farbe1,mem[vesa.w1seg:offs],2);
 move(farbe2,mem[vesa.w1seg:offs+2],1);
{mem[vesa.w1seg:offs]:=r;
 mem[vesa.w1seg:offs+1]:=g;
 mem[vesa.w1seg:offs+2]:=b;
 mem[vesa.w1seg:offs+3]:=0;}
end;

procedure intro2(f1,f2:byte;initz:boolean);

var dac:tdacblock;

 procedure showsvgadbm6448(s:string);

 var f:file;y:word;p:pointer;l:longint;dac2:tdacblock;

 begin
  assign(f,dbmpath+s);
  reset(f,1);
  blockread(f,dac,768);
  fillchar(dac2,768,0);
  setdacblock(0,256,dac2);
  getmem(p,32768);
  l:=0;
  for y:= 0 to 8 do
  begin
   blockread(f,p^,32768);
   pointertosvga(l mod maxxkoor,l div maxxkoor,p^,32768);
   inc(l,32768);
  end;
  blockread(f,p^,307200-l);
  pointertosvga(l mod maxxkoor,l div maxxkoor,p^,307200-l);
  freemem(p,32768);
  close(f);
 end;

begin
 if not initz then initvesa($101);
 showsvgadbm6448('tp256.dbm');
 if f1 = 0 then f1:=15;
 if f2 = 0 then f2:=15;
 fadein(dac,f1);
 fadeout(dac,f2);
 showsvgadbm6448('tpk.dbm');
 fadein(dac,f1);
 fadeout(dac,f2);
 showsvgadbm6448('tpk2.dbm');
 fadein(dac,f1);
 fadeout(dac,f2);
 showsvgadbm6448('tpk3.dbm');
 fadein(dac,f1);
 readkey;
end;

procedure setzerahmen;assembler;

asm
 mov ah,10h
 mov al,01h
 mov bh,farbe
 int 10h
end;

procedure showsvgadbm(x,y:word;s:string);

var f:file;z:word;p:pointer;l,l2:longint;dac:tdacblock;

begin
 l2:=x*y;
 assign(f,dbmpath+s);
 reset(f,1);
 blockread(f,dac,768);
 setdacblock(0,256,dac);
 getmem(p,32768);
 l:=0;
 for z:= 0 to (l2 div 32768)-1 do
 begin
  blockread(f,p^,32768);
  pointertosvga(l mod x,l div x,p^,32768);
  inc(l,32768);
 end;
 blockread(f,p^,l2-l);
 pointertosvga(l mod maxxkoor,l div maxxkoor,p^,l2-l);
 freemem(p,32768);
 close(f);
end;

procedure lauftip(x,y:word;s1:string);

var s2:string;l,t,farbe:byte;

begin
 s2:='';
 l:=length(s1);
 for t := 1 to l do
 begin
  setcolor(0);
  outtextxy(x,y,s2);
  waitohnedelay;
  s2:=s2+s1[t];
  repeat
   farbe:=random(247)+1;
  until (farbe <> 16) and (farbe <> 17);
  setcolor(farbe);
  outtextxy(x,y,s2);
  delay(75);
  waitohnedelay;
 end;
end;

procedure klappeauf(x,y:word;farbe:byte);

var x1:word;

begin
 setcolor(farbe);
 for x1:= getmaxx div 2-x div 2 to getmaxx div 2+x div 2 do putpixel(x1,getmaxy div 2,farbe);
 for x1:= getmaxy div 2-y div 2 to getmaxy div 2+y div 2 do line(getmaxx div 2-x div 2,x1,getmaxx div 2+x div 2,x1);
end;

procedure makepal(s:string);

var f:file;dac:tdacblock;

begin
 assign(f,s);
 reset(f,1);
 blockread(f,dac,768);
 close(f);
 setdacblock(0,256,dac);
end;

procedure setseite(seite:byte);

begin
 with reg do
 begin
  ah:=$4f;
  al:=$05;
  bh:=$00;
  bl:=0;
  dx:=seite;
  intr($10,reg);
 end;
end;

function getseite;

begin
 with reg do
 begin
  ah:=$4f;
  al:=$05;
  bh:=$01;
  bl:=0;
  intr($10,reg);
  getseite:=dx;
 end;
end;

procedure offne13hdbm(s:string;pal:boolean);

var f:file;dac:tdacblock;p:pointer;

begin
 assign(f,s);
 reset(f,1);
 if pal then
 begin
  blockread(f,dac,768);
  setdacblock(0,256,dac);
 end;
 getmem(p,32000);
 blockread(f,p^,32000);
 move(p^,mem[$a000:0],32000);
 blockread(f,p^,32000);
 move(p^,mem[$a000:32000],32000);
 freemem(p,32000);
 close(f);
end;

begin
 setflag(numl);
 clrflag(capl);
 clrflag(scrl);
 h13:=false;
 sb:=false;
 grapherror:=0;
 randomize;
end.
