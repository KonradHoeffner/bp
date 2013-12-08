{ ÉÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÍÍÍ [ PiCTURE.PAS ] ÍÍÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ» }
{ ³ Dez 1995                                             bY iceTrancer^LL ³ }
{ ³  Inhalt: Zugriff auf BMP/PCX Dateien (nur 320x200x256)                ³ }
{ ³  System: VGA                                    SavePic by Tom Killer ³ }
{ ÈÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¼ }

unit picture;

interface

   type
      bild_array        = array [0..64767] of byte;

      pcx_header = record
       kennung,                                        { Format-Kennung 0ah }
       version,                        { Versionsnummer (5 fr Version 3.0) }
       kompression,           { RLE-Kompession verwendet (1) oder nicht (0) }
       bits_pro_pixel   : byte;                            { Bits pro Pixel }
       lo_x, lo_y,                            { Koordinaten linke ober Ecke }
       ru_x, ru_y,                         { Koordinaten rechte untere Ecke }
       x_dpi, y_dpi     : word;    { horizontale/vertikale Aufl”sung in dpi }
       palette          : array [0..47] of byte;     { 16 Farben, unwichtig }
       reserviert1,                                            { reserviert }
       anz_planes       : byte; { Anzahl Planes (bei 256 Farben eine Plane) }
       byte_pro_zeile   : word;    { Byte pro Bildzeile, gerade aufgerundet }
       palettenart      : word;   { 1=Farbe oder schwarz/weiá, 2=Graustufen }
       reserviert2      : array [0..57] of byte;     { reserviert (meist 0) }
      end;


      bmp_header = record
        signatur        : word;               { Signatur 'BM' der BMP-Datei }
        flen            : longint;                     { Filel„nge in Bytes }
        dummy1          : word;                                { reserviert }
        dummy2          : word;                                { reserviert }
        offset          : longint;                { Offset auf Datenbereich }
        info_size       : longint;                       { L„nge Infoheader }
        xmax            : longint;                   { Bildbreite in Pixeln }
        ymax            : longint;                      { Bildh”he in Pixel }
        planes          : word;                   { Farbebenen (muá 1 sein) }
        bits_per_pixel  : word;               { Bits pro Pixel - 1, 2, 4, 8 }
        compress        : word;                         { Komprimierungstyp }
        xsize           : longint;                      { Bildgr”áe in Byte }
        hdpi            : longint;                  { Bildaufl”sung in Pels }
        vdpi            : longint;                  { Bildaufl”sung in Pels }
        cols            : longint;              { Zahl der benutzten Farben }
        coli            : longint;              { Zahl der wichtigen Farben }
     end;

     puffer_array       = array [0..65534] of byte;

   var pcxheader               : pcx_header;

   procedure loadBMP (name : string; var puffer);{ liest BMP 320x200x256 ein }
   procedure loadPCX (name : string; var puffer);{ liest PCX 320x200x256 ein }
   procedure saveBMP (name : string); {speichert Bildinhalt(320,200,256) in Datei Name}
   procedure loadpic (name : string; var puffer); {liest Pcx und Bmp -Files}

implementation

{ ÉÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÍÍÍ [ loadBMP ] ÍÍÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ» }
{ ³ l„dt eine 320x200x256 BMP-Datei (Windows 3 Bitmap)                    ³ }
{ ³  Eingabe: name   : Dateiname (evtl. mit Pfad)                         ³ }
{ ³  Ausgabe: puffer : Puffer (64768 Bytes; erst Bilddaten, dann Palette) ³ }
{ ÈÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¼ }
procedure loadBMP (name : string; var puffer);

var
  header        : bmp_header;
  f             : file;
  dac           : array [0..1023] of byte;
  dac1          : array [0..767] of byte;
  i             : word;
  dummy         : ^bild_array;

begin
  new(dummy);
  assign (f, name);
  reset (f, 1);
  blockread (f, header, sizeof (bmp_header));

  seek (f, header.info_size+14);
  blockread (f, dac, 1024);

  for i := 0 to 255 do
   begin
     dac1[i*3] := dac [i*4+2] shr 2;
     dac1[i*3+1] := dac [i*4+1] shr 2;
     dac1[i*3+2] := dac [i*4] shr 2;
   end;
  move (dac1, ptr (seg (puffer), ofs (puffer)+64000)^, 768);

  blockread(f,dummy^,64000);

  for i := 199 downto 0 do
   begin
     move(dummy^[i*320] ,ptr (seg (puffer), ofs (puffer)+(199-i)*320)^, 320);
   end;
  close (f);
  dispose(dummy);
end;

{ ÉÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÍÍÍ [ loadPCX ] ÍÍÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ» }
{ ³ l„dt eine 320x200x256 PCX-Datei (Paintshop Pro)                       ³ }
{ ³  Eingabe: name   : Dateiname (evtl. mit Pfad)                         ³ }
{ ³  Ausgabe: puffer : Puffer (64768 Bytes; erst Bilddaten, dann Palette) ³ }
{ ÈÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¼ }
procedure loadPCX (name : string; var puffer);

var
   f                    : file;
   puffer2              : ^puffer_array;
   pos, counter, i      : word;
   header               : pcx_header;

label
   loadPCX_shift_dac;

begin
   pos := 0;
   counter := 0;
   new (puffer2);
   assign (f, name);
   reset (f, 1);
   blockread (f, header, sizeof (pcx_header));

   if (header.kompression = 0) then
    begin
       blockread (f, puffer, 64001);
       blockread (f, puffer2^, 768);
       goto loadPCX_shift_dac;
    end;

   blockread (f, puffer2^, filesize (f) - sizeof (pcx_header));
   close (f);

   while (counter <> 64000) do
    begin
       if ((puffer2^[pos] and $c0) = $c0) then
        asm
           les  di, puffer2
           add  di, pos
           mov  cx, es:[di]
           and  cl, 3fh
           mov  al, ch
           xor  ch, ch
           les  di, puffer
           add  di, counter
           add  counter, cx
           rep  stosb
        end
       else
        asm
           les  di, puffer2
           add  di, pos
           mov  al, es:[di]
           les  di, puffer
           add  di, counter
           stosb
           inc  counter
           dec  pos
        end;
       inc (pos, 2);
    end;

loadPCX_shift_dac:
   asm
      push ds

      lds  si, puffer2
      add  si, pos
      inc  si
      les  di, puffer
      add  di, 64000
      mov  cx, 384

   @loadPCX_1:
      lodsw
      shr  ax, 2
      stosw
      loop @loadPCX_1

      pop  ds
   end;

   dispose (puffer2);
   pcxheader:=header;
end;
procedure getdac(var dac); assembler;

 asm
  mov bx, 256
  les di, dac
  xor cl, cl

  @neu:
  mov dx, 3c7h
  mov al, cl

  out dx, al

  mov dx, 3c9h

  in al, dx
  mov es:[di],al

  inc di
  in  al, dx
  mov es:[di], al

  inc di
  in  al, dx
  mov es:[di],al

  inc cl
  inc di
  dec bx
  jnz @neu
end;

procedure saveBMP (name : string);

var
  header        : bmp_header;
  f             : file;
  dac           : array [0..1023] of byte;
  dac1          : array [0..767] of byte;
  i,counter,d,d2: word;
  pic           : ^bild_array;
  a             : word;

begin
  assign (f, name);
  rewrite (f, 1);
  new(pic);
  with header do
     begin
        signatur        := 19778;               { Signatur 'BM' der BMP-Datei }
        flen            := 320*200+1024+52+2;   { Filel„nge in Bytes }
        dummy1          := 0;                   { reserviert }
        dummy2          := 0;                   { reserviert }
        offset          := 1024+52+2;           { Offset auf Datenbereich }
        info_size       := 40;                  { L„nge Infoheader }
        xmax            := 320;                 { Bildbreite in Pixeln }
        ymax            := 200;                 { Bildh”he in Pixel }
        planes          := 1;                   { Farbebenen (muá 1 sein) }
        bits_per_pixel  := 8;                   { Bits pro Pixel - 1, 2, 4, 8 }
        compress        := 0;                   { Komprimierungstyp }
        xsize           := -100663296;               { Bildgr”áe in Byte }
        hdpi            := 0;                   { Bildaufl”sung in Pels }
        vdpi            := 0;                   { Bildaufl”sung in Pels }
        cols            := 16777216;                 { Zahl der benutzten Farben }
        coli            := 16777216;                  { Zahl der wichtigen Farben }
     end;

  blockwrite (f, header, sizeof (bmp_header)+2);

  getdac(dac1);

  for i := 0 to 255 do
   begin
     dac[i*4+2] :=dac1[i*3] shl 2;
     dac[i*4+1] := dac1 [i*3+1] shl 2;
     dac[i*4] := dac1 [i*3+2] shl 2;
   end;
 blockwrite (f, dac, 1024);

 for d:=199 downto 0 do
     for d2:=0 to 319 do pic^[(199-d)*320+d2]:=mem[$a000:d*320+d2];

blockwrite(f,pic^,64000);

dispose(pic);
close(f);
end;

procedure loadpic (name : string; var puffer); {liest Pcx und Bmp -Files}

var ende:string[3];
    d2:byte;

function lastpoint(str:string):byte;
var d:byte;
begin
  for d:=length(str) downto length(str)-4 do if str[d]='.' then break;
  d:=length(str)-d;
  if d=4 then d:=0;
  lastpoint:=d;
end;

begin
  d2:=length(name)-lastpoint(name);
  ende:=copy(name,d2+1,3);
  for d2:=1 to 3 do ende[d2]:=upcase(ende[d2]);
  if ende='PCX' then loadpcx(name,ptr(seg(puffer),ofs(puffer))^);
  if ende='BMP' then loadbmp(name,ptr(seg(puffer),ofs(puffer))^);
end;

end.