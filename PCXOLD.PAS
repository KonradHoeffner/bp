Unit SaveLoad;
{Zum laden und speichern von .PCX}
INTERFACE

{ Die folgenden beiden Prozeduren arbeiten ohne Komprimierung
 =nur speichern,keine .PCX}

PROCEDURE SaveScreen(x1,y1,x2,y2: Word; Filename: String);
   { Speichert einen Bildausschnitt in den 16-Farben-Modi unter }
   { dem Dateinamen Filename ab. x1,y1 markiert die linke obere }
   { und x2,y2 die rechte untere Ecke in Grafikkoordinaten      }
PROCEDURE LoadScreen(x1,y1: Word; FileName: String);
   { LÑdt einen Bildauschnitt mit dem Dateinamen Filename      }
   { von Diskette in den Bildspeicher, so da· die linke        }
   { obere Ecke am Punkt x1,y1 liegt. x1 wird auf die nÑchste  }
   { Bytegrenze (d.h. einen durch 8 teilbaren Wert) abgerundet }

{ Die folgenden Prozeduren laden/speichern Bildauschnitte    }
{ in den 16- und 256-Farben-Modi als komprimierte (echte) PCX-Datei. }
{ Die Parameter enstprechen SaveScreen und LoadScreen.       }

FUNCTION LoadPCX16(x1,y1: Word; Filename: String): Boolean;
PROCEDURE SavePCX16(x1,y1,x2,y2: Word; FileName: String);
FUNCTION LoadPCX256(x1,y1: Word; Filename: String): Boolean;
PROCEDURE SavePCX256(x1,y1,x2,y2: Word; FileName: String);

{ Die folgenden Prozeduren arbeiten mit verbesserter Kompri- }
{ mierung, die Dateien sind aber nicht mehr PCX-kompatibel.  }

   { Komprimierung in vertikaler Richtung, 16-Farben-Modi: }
FUNCTION LoadV16(x1,y1: Word; Filename: String): Boolean;
PROCEDURE SaveV16(x1,y1,x2,y2: Word; FileName: String);

   { Komprimierung in horizontaler Richtung, 16-Farben-Modi: }
FUNCTION LoadH16(x1,y1: Word; Filename: String): Boolean;
PROCEDURE SaveH16(x1,y1,x2,y2: Word; FileName: String);

   { Komprimierung in horizontaler Richtung, 256-Farben-Modi: }
FUNCTION Load256(x1,y1: Word; Filename: String): Boolean;
PROCEDURE Save256(x1,y1,x2,y2: Word; FileName: String);
{ ================================================================ }

IMPLEMENTATION

Uses EVBios; { wegen BIOS-Funktionen zum Laden/Lesen der Farbregister }

CONST HeaderSize = 128; { Grî·e des PCX-Dateikopfes }

TYPE   { Die Farbe in 8-Bit-Komponentenform. Der    }
       { Typ PrimaryColors ist in EVBios deklariert }
     PCXColor = ARRAY[PrimaryColors] OF Byte;
       { Der Dateikopf: }
     PCXHeader = RECORD
                   ID, Version, Encoding, Bits: Byte;
                   xmin, ymin, xmax, ymax, HRes, VRes: Word;
                   Colors: ARRAY[0..15] OF PCXColor;
                   VMode, Planes: Byte;
                   BytesPerLine, PaletteInfo: Word;
                   Unused: ARRAY[0..57] OF Byte;
                 END;

CONST BufSize = 1024;      { Grî·e des Datei-Puffers }

TYPE  DataBuffer = ARRAY[0..BufSize-1] OF Byte;  { Datenpuffertyp }

VAR   PCXFile: File;       { Dateivariable }
      FBuffer: DataBuffer; { Dateipuffer }
      FBufRead: Word;      { Im Dateipuffer vorhandene Bytes: }
      FBufCount: Word;     { Index des nÑchsten zu lesenden Bytes }

CONST ScrSeg = $A000;      { Segmentadresse des Bildspeichers }
VAR   ScrWidth: Word ABSOLUTE $0:$044A;  { BIOS: Zeichen pro Zeile }

{ ------------------------------------------------------------------- }
{ Die folgenden beiden Prozeduren speichern/laden als Minimallîsung   }
{ einen Bildausschnitt in den 16-Farben-Modi ohne Komprimierung.      }
{ ------------------------------------------------------------------- }

PROCEDURE SaveScreen(x1,y1,x2,y2: Word; Filename: String);
{ ---------------------------------------------------------- }
{ Speichert einen Bildausschnitt in den 16-Farben-Modi unter }
{ dem Dateinamen Filename ab. x1,y1 markiert die linke obere }
{ und x2,y2 die rechte untere Ecke in Grafikkoordinaten      }
{ ---------------------------------------------------------- }
   VAR f: File;
       ScrOfs, y, NrOfBytes, NrOfLines: Word;
       Plane: Byte;
BEGIN
  Assign(f,Filename);            { Dateinamen festlegen }
  Rewrite(f,1);                  { BinÑrdatei zum Schreiben îffnen }
  ScrOfs := ScrWidth * y1 + x1 DIV 8;    { Offsetadresse links oben }
  NrOfBytes := x2 DIV 8 - x1 DIV 8 + 1;  { Breite des Ausschnitts  }
  NrOfLines := y2 - y1 + 1;              { Hîhe des Ausschnitts }
  BlockWrite(f,NrOfBytes,2);             { Dateikopf erzeugen }
  BlockWrite(f,NrOfLines,2);
  Port[$3CE] := 4;               { Index fÅr Read Map Select Reg. }
  FOR y := y1 TO y2 DO BEGIN       { Alle Rasterzeilen abgrasen: }
    FOR Plane := 0 TO 3 DO BEGIN     { Alle Ebenen abgrasen: }
      Port[$3CF] := Plane;             { Read Map Register laden }
      { Zeile aus der Speicherebene auf Diskette schreiben }
      BlockWrite(f,Mem[ScrSeg:ScrOfs],NrOfBytes);
    END;
    ScrOfs := ScrOfs + ScrWidth;  { Offsetadresse der nÑchsten Zeile }
  END;
  Port[$3CF] := 0;       { Read Map Register mit Default laden }
  Close(f);              { Datei schlie·en }
END;

PROCEDURE LoadScreen(x1,y1: Word; FileName: String);
{ --------------------------------------------------------- }
{ LÑdt einen Bildauschnitt mit dem Dateinamen Filename      }
{ von Diskette in den Bildspeicher, so da· die linke        }
{ obere Ecke am Punkt x1,y1 liegt. x1 wird auf die nÑchste  }
{ Bytegrenze (d.h. einen durch 8 teilbaren Wert) abgerundet }
{ --------------------------------------------------------- }
   VAR f: File;
       ScrOfs, y, y2, NrOfBytes, NrOfLines: Word;
       Plane: Byte;
BEGIN
  Assign(f,FileName);              { Dateinamen festlegen }
  Reset(f,1);                      { BinÑrdatei zum Lesen îffnen }
  BlockRead(f,NrOfBytes,2);        { Dateikopf lesen }
  BlockRead(f,NrOfLines,2);
  ScrOfs := ScrWidth * y1 + x1 DIV 8; { Offsetadresse links oben }
  y2 := y1 + NrOfLines - 1;        { y2 = letzte Rasterzeile }
  Port[$3C4] := 2;                 { Index fÅr Map Mask Register  }
  FOR y := y1 TO y2 DO BEGIN       { Alle Rasterzeilen abgrasen: }
    FOR Plane := 0 TO 3 DO BEGIN     { Alle Ebenen abgrasen }
      Port[$3C5] := 1 SHL Plane;      { Bitmaske fÅr Map Mask Reg. }
      { Zeile von Diskette in die Speicherebene laden: }
      BlockRead(f,Mem[ScrSeg:ScrOfs],NrOfBytes);
    END;
    ScrOfs := ScrOfs + ScrWidth;   { Offsetadr. der nÑchsten Zeile }
  END;
  Port[$3C5] := $F;       { Map Mask Register mit Default laden }
  Close(f);               { Datei schlie·en }
END;

{ ------------------------------------------------------------------- }
{ Die folgenden Prozeduren speichern/laden Bildausschnitte in den 16- }
{ und 256-Farben-Modi als komprimierte PCX-Datei.                     }
{ ------------------------------------------------------------------- }

PROCEDURE PCXOpenRead(FileName: String; VAR Header: PCXHeader);
{ ---------------------------------------------- }
{ ôffnet PCX-Datei FileName zum Lesen und        }
{ liest den Dateikopf in die Variable Header ein }
{ ---------------------------------------------- }
BEGIN
  FBufRead := 0;                   { Datei-Lesepuffer ist leer }
  FBufCount := 0;                  { PufferzÑhler zurÅcksetzen }
  Assign(PCXFile,Filename);        { Dateinamen zuordnen }
  Reset(PCXFile,1);                { Datei zum Lesen îffnen }
  BlockRead(PCXFile,Header,HeaderSize);   { Dateikopf lesen }
END;

PROCEDURE PCXOpenWrite(FileName: String; VAR Header: PCXHeader);
{ --------------------------------------------}
{ ôffnet PCX-Datei FileName zum Schreiben und }
{ schreibt den Dateikopf Header in die Datei  }
{ --------------------------------------------}
BEGIN
  Assign(PCXFile,FileName);        { Dateinamen zuordnen }
  Rewrite(PCXFile,1);              { Datei zum Schreiben îffnen }
  BlockWrite(PCXFile,Header,HeaderSize);  { Dateikopf schreiben }
END;

PROCEDURE PCXClose;
{ -------------------------- }
{ Schlie·t die Datei PCXFile }
{ -------------------------- }
BEGIN
  Close(PCXFile);
END;

FUNCTION GetFileByte: Byte;
{ ---------------------------------------------------- }
{ Liest ein Byte aus dem Dateipuffer FBuffer und fÅllt }
{ ihn gegebenenfalls aus der Datei PCXFile wieder auf  }
{ ---------------------------------------------------- }
BEGIN
  IF FBufCount >= FBufRead THEN BEGIN
    { Pufferende erreicht, Puffer neu fÅllen }
    BlockRead(PCXFile,FBuffer,BufSize,FBufRead);
    FBufCount := 0;     { PufferzÑhler zurÅcksetzen }
  END;
    { Byte aus dem Puffer entnehmen und PufferzÑhler erhîhen }
  GetFileByte := FBuffer[FBufCount];
  Inc(FBufCount);
END;

PROCEDURE PCXRead(VAR Destination; Width: Word);
{ ---------------------------------------------------- }
{ Entnimmt der Datei PCXFile mit Hilfe von GetFileByte }
{ Bilddaten, expandiert sie und schreibt sie an die    }
{ Zieladresse, bis das Soll von Width Bytes erfÅllt ist}
{ ---------------------------------------------------- }
  VAR j: Word;
      b, Count: Byte;
      D: DataBuffer ABSOLUTE Destination;
BEGIN
  j := 0;
  WHILE j < Width DO BEGIN
    b := GetFileByte;
    IF b AND $C0 <> $C0 THEN BEGIN
      { Byte ist kein ZÑhler, direkt Åbernehmen }
      D[j] := b;
      Inc(j);
    END
    ELSE BEGIN
      { Byte ist ein ZÑhler, nÑchstes Byte    }
      { Count mal in Ergebnispuffer schreiben }
      Count := b AND $3F;
      FillChar(D[j],Count,GetFileByte);
      j := j + Count;
    END;
  END;
END;

PROCEDURE PCXWrite(VAR Source; Width: Word);
{ ------------------------------------------------ }
{ Entnimmt der Quelle Source Width Bytes, kompri-  }
{ miert sie, sammelt sie im Dateipuffer FBuffer und}
{ schreibt sie abschlie·end in die Datei PCXFile   }
{ ------------------------------------------------ }
  VAR i: Word;
      b, Count: Byte;
      S: DataBuffer ABSOLUTE Source;
BEGIN
  i := 0;
  FBufCount := 0;  { Dateipuffer ist leer }
  WHILE i < Width DO BEGIN
    Count := 1;    { WiederholungszÑhler }
    b := S[i];     { NÑchstes Byte holen }
    Inc(i);
      { ZÑhlen, wie oft sich Byte b wiederholt: }
    WHILE (i < Width) AND (Count < 63) AND (b = S[i]) DO BEGIN
      Inc(i);
      Inc(Count);
    END;
    IF (Count > 1) OR (b AND $C0 = $C0) THEN BEGIN
      { ZÑhler in Dateipuffer schreiben, da sich das  }
      { Byte wiederholt oder Bit 6 und 7 gesetzt sind }
      FBuffer[FBufCount] := $C0 OR Count;
      Inc(FBufCount);
    END;
      { Byte in den Dateipuffer schreiben }
    FBuffer[FBufCount] := b;
    Inc(FBufCount);
  END;
    { Die j Bytes der komprimierten Zeile in Datei schreiben }
  BlockWrite(PCXFile,FBuffer,FBufCount);
END;

FUNCTION LoadPCX16(x1,y1: Word; Filename: String): Boolean;
{ ----------------------------------------------------- }
{ LÑdt einen als PCX-Datei mit dem Dateinamen FileName  }
{ gespeicherten 16-Farben-Bildausschnitt in den Bild-   }
{ speicher, so da· die linke obere Ecke bei x1,y1 liegt.}
{ Gibt bei falschem Datei-/Bildformat False zurÅck.     }
{ Braucht ReadPalReg aus 6.2 und SetColorBlock aus 6.7. }
{ ----------------------------------------------------- }
  VAR Header: PCXHeader;
      x2, y2, y, i, ScrOfs: Word;
      Plane: Byte;
BEGIN
  PCXOpenRead(FileName,Header);  { Datei zum Lesen îffnen }
  WITH Header DO BEGIN           { Dateikopf testen: }
    IF (ID <> 10) OR             { Keine PCX-Datei? }
       (Bits <> 1) OR            { Bits pro Pixel u. Ebene falsch? }
       (Planes <> 4) OR          { Anzahl Farbebenen falsch? }
       (Encoding = 0) OR         { unkomprimiert? }
       (x1 DIV 8 + BytesPerLine > ScrWidth) THEN  { Bild zu breit? }
      LoadPCX16 := False         { dann kann Bild nicht gelesen werden }
    ELSE BEGIN
      LoadPCX16 := True;         { Bild kann gelesen werden }
      IF (Version = 2) OR (Version = 5) THEN BEGIN
        { Palettendaten vorhanden }
        FOR i := 0 TO 15 DO BEGIN
            { Farbinformation auf 6-Bit-Format bringen... }
          Colors[i,Red] := Colors[i,Red] SHR 2;
          Colors[i,Green] := Colors[i,Green] SHR 2;
          Colors[i,Blue] := Colors[i,Blue] SHR 2;
            { ...und in passendes Farbregister eintragen }
          SetColorBlock(ReadPalReg(i),1,Colors[i]);
        END;
      END;
      ScrOfs := ScrWidth * y1 + x1 DIV 8; { Offsetadr. links oben }
      y2 := y1 + (ymax - ymin);           { y2 = letzte Rasterzeile }
      Port[$3C4] := 2;                    { Index fÅr Map Mask Register }
      FOR y := y1 TO y2 DO BEGIN          { Alle Rasterzeilen abgrasen: }
        FOR Plane := 0 TO 3 DO BEGIN      { Alle Ebenen abgrasen }
          Port[$3C5] := 1 SHL Plane;      { Bitmaske fÅr Map Mask Reg. }
          PCXRead(Mem[ScrSeg:ScrOfs],BytesPerLine);  { Zeile laden }
        END;
        ScrOfs := ScrOfs + ScrWidth;   { Offsetadr. der nÑchsten Zeile }
      END;
      Port[$3C5] := $F;       { Map Mask Register mit Standard laden }
      PCXClose;               { Datei schlie·en }
    END;
  END;
END;

PROCEDURE SavePCX16(x1,y1,x2,y2: Word; FileName: String);
{ ----------------------------------------------------- }
{ Speichert einen Bildausschnitt in den 16-Farben-Modi  }
{ unter dem Dateinamen Filename als PCX-Datei ab. x1,y1 }
{ ist die linke obere und x2,y2 die rechte untere Ecke. }
{ Braucht ReadPalReg aus 6.2 und ReadColorBlock aus 6.7 }
{ ----------------------------------------------------- }
  VAR Header: PCXHeader;
      ScrOfs, i, y: Word;
      Plane: Byte;
BEGIN
  FillChar(Header,HeaderSize,0); { Erst Dateikopf mit Nullen fÅllen }
  WITH Header DO BEGIN           { und dann mit Werten bestÅcken: }
    ID := 10;                  { Dateikennung }
    Version := 2;              { mit Header-Palettendaten }
    Encoding := 1;             { komprimiert }
    Bits := 1;                 { Bits pro Pixel pro Ebene }
    xmin := x1; ymin := y1;    { Bildkoordinaten }
    xmax := x2; ymax := y2;
    HRes := 75; VRes := 75;    { pro forma die Auflîsung }
    Planes := 4;               { 4 Speicherebenen }
    BytesPerLine :=
      x2 DIV 8 - x1 DIV 8 + 1; { Ausschnittbreite }
    PaletteInfo := 1;          { Farbbild }
    FOR i := 0 TO 15 DO BEGIN
      { Farbinformation aus Farbregister lesen... }
      ReadColorBlock(ReadPalReg(i),1,Colors[i]);
      { ...und auf 8-Bit-Format bringen }
      Colors[i,Red] := Colors[i,Red] SHL 2;
      Colors[i,Green] := Colors[i,Green] SHL 2;
      Colors[i,Blue] := Colors[i,Blue] SHL 2;
    END;
    PCXOpenWrite(FileName,Header);      { Datei zum Schreiben îffnen }
    ScrOfs := ScrWidth * y1 + x1 DIV 8; { Offsetadr. links oben }
    Port[$3CE] := 4;                    { Index fÅr Read Map Select Reg. }
    FOR y := y1 TO y2 DO BEGIN          { Alle Rasterzeilen abgrasen: }
      FOR Plane := 0 TO 3 DO BEGIN      { Alle Ebenen abgrasen: }
        Port[$3CF] := Plane;            { Read Map Register laden }
        PCXWrite(Mem[ScrSeg:ScrOfs],BytesPerLine);  { Zeile schreiben }
      END;
      ScrOfs := ScrOfs + ScrWidth; { Offsetadresse der nÑchsten Zeile }
    END;
    Port[$3CF] := 0;     { Read Map Register mit Standard laden }
  END;
  PCXClose;              { Datei schlie·en }
END;

FUNCTION LoadPCX256(x1,y1: Word; Filename: String): Boolean;
{ ----------------------------------------------------- }
{ LÑdt einen als PCX-Datei mit dem Dateinamen FileName  }
{ gespeicherten 256-Farben-Bildausschnitt in den Bild-  }
{ speicher, so da· die linke obere Ecke bei x1,y1 liegt.}
{ Gibt bei falschem Datei-/Bildformat False zurÅck.     }
{ ----------------------------------------------------- }
  VAR Header: PCXHeader;
      x2, y2, y, i, ScrOfs: Word;
      b: Byte;
      ColorData: ARRAY[0..255] OF PCXColor;
BEGIN
  PCXOpenRead(FileName,Header);  { Datei zum Lesen îffnen }
  WITH Header DO BEGIN           { Dateikopf testen: }
    IF (ID <> 10) OR             { Keine PCX-Datei? }
       (Bits <> 8) OR            { Bits pro Pixel falsch? }
       (Planes <> 1) OR          { Mehr als 1 Farbebene? }
       (Encoding = 0) OR         { unkomprimiert? }
       (x1 + BytesPerLine > ScrWidth * 8) THEN  { Bild zu breit? }
      LoadPCX256 := False        { dann kann Bild nicht gelesen werden }
    ELSE BEGIN
      LoadPCX256 := True;        { Bild kann gelesen werden }
      IF Version = 5 THEN BEGIN  { angehÑngte Palettendaten }
          { Dateizeiger auf Palettendaten setzen: }
        Seek(PCXFile,FileSize(PCXFile)-769);
        BlockRead(PCXFile,b,1);  { ID-Byte lesen u. testen: }
        IF b = $0C THEN BEGIN    { es liegen gÅltige Palettendaten vor }
          BlockRead(PCXFile,ColorData,3 * 256); { Daten lesen }
          FOR i := 0 TO 255 DO BEGIN
            { Farbinformationen auf 6-Bit-Format bringen }
            ColorData[i,Red] := ColorData[i,Red] SHR 2;
            ColorData[i,Green] := ColorData[i,Green] SHR 2;
            ColorData[i,Blue] := ColorData[i,Blue] SHR 2;
          END;
          SetColorBlock(0,256,ColorData); { Alle 256 Farbregister laden }
        END;
         { Dateizeiger wieder hinter Dateikopf setzen: }
        Seek(PCXFile,HeaderSize);
      END;
      ScrOfs := ScrWidth * 8 * y1 + x1;  { Offsetadr. links oben }
      y2 := y1 + (ymax - ymin);          { y2 = letzte Rasterzeile }
      FOR y := y1 TO y2 DO BEGIN         { Alle Rasterzeilen abgrasen: }
        PCXRead(Mem[ScrSeg:ScrOfs],BytesPerLine);  { Zeile lesen }
        ScrOfs := ScrOfs + ScrWidth * 8; { Offsetadresse nÑchste Zeile }
      END;
      PCXClose;  { Datei schlie·en }
    END;
  END;
END;

PROCEDURE SavePCX256(x1,y1,x2,y2: Word; FileName: String);
{ ----------------------------------------------------- }
{ Speichert einen Bildausschnitt im 256-Farben-Modus 13h}
{ unter dem Dateinamen Filename als PCX-Datei ab. x1,y1 }
{ ist die linke obere und x2,y2 die rechte untere Ecke. }
{ ----------------------------------------------------- }
  VAR Header: PCXHeader;
      ScrOfs, i, y: Word;
      b: Byte;
      ColorData: ARRAY[0..255] OF PCXColor;
BEGIN
  FillChar(Header,HeaderSize,0); { Erst Dateikopf mit Nullen fÅllen }
  WITH Header DO BEGIN           { und dann mit Werten bestÅcken: }
    ID := 10;                    { Dateikennung }
    Version := 5;                { 256 angehÑngte Palettendaten }
    Encoding := 1;               { komprimiert }
    Bits := 8;                   { Bits pro Pixel pro Ebene }
    xmin := x1; ymin := y1;      { Bildkoordinaten }
    xmax := x2; ymax := y2;
    HRes := 75; VRes := 75;      { pro forma die Auflîsung }
    VMode := $13;
    Planes := 1;                 { 1 Speicherebene }
    BytesPerLine := x2 - x1 + 1; { Bildbreite in Bytes }
    PaletteInfo := 1;
    PCXOpenWrite(FileName,Header);
    ScrOfs := ScrWidth * 8 * y1 + x1;  { Offsetadr. links oben }
    FOR y := y1 TO y2 DO BEGIN         { Alle Rasterzeilen abgrasen: }
      PCXWrite(Mem[ScrSeg:ScrOfs],BytesPerLine);  { Zeile schreiben }
      ScrOfs := ScrOfs + ScrWidth * 8; { Offsetadresse nÑchste Zeile }
    END;
  END;
  b := $0C;                          { Kennung fÅr Palettendaten }
  BlockWrite(PCXFile,b,1);           { an Datei anhÑngen }
  ReadColorBlock(0,256,ColorData);   { Alle Farbregister auslesen }
  FOR i := 0 TO 255 DO BEGIN         { und in 8-Bit-Form bringen }
    ColorData[i,Red] := ColorData[i,Red] SHL 2;
    ColorData[i,Green] := ColorData[i,Green] SHL 2;
    ColorData[i,Blue] := ColorData[i,Blue] SHL 2;
  END;
    { Palettendaten fÅr 256 Farben an Datei anhÑngen }
  BlockWrite(PCXFile,ColorData,3 * 256);
  PCXClose;  { Datei schlie·en }
END;

{ ------------------------------------------------------------------- }
{ Die folgenden Prozeduren arbeiten mit verbesserter Komprimierung in }
{ den 16-Farben-Modi, die Dateien sind aber nicht mehr PCX-kompatibel.}
{ ------------------------------------------------------------------- }

PROCEDURE Expand(VAR Destination; Width: Word);
{ ---------------------------------------------------- }
{ Entnimmt einer Datei mit Hilfe von GetFileByte Bild- }
{ daten, expandiert sie und schreibt sie an die Ziel-  }
{ adresse, bis das Soll von Width Bytes erfÅllt ist    }
{ ---------------------------------------------------- }
  VAR j: Word;
      b,bx,i,Count: Byte;
      D: DataBuffer ABSOLUTE Destination;
BEGIN
  j := 0;
  WHILE j < Width DO BEGIN
    b := GetFileByte;        { Byte aus Datei holen }
    Count := b AND $1F;      { Bit 0..4 als ZÑhler isolieren }
    IF Count = 0 THEN        { Wenn ZÑhlerwert 0, }
      Count := GetFileByte;  { dann ist nÑchstes Byte der ZÑhler }
    CASE b AND $E0 OF        { Kennbits 5..7 untersuchen: }
      $00: { 000, Folge von Nullbytes }
           FillChar(D[j],Count,$00);
      $E0: { 111, Folge von FFh-Bytes }
           FillChar(D[j],Count,$FF);
      $20: { 001, folgendes Byte wiederholt sich }
           FillChar(D[j],Count,GetFileByte);
      $C0: { Kennbits 110, die folgenden beiden }
           { Bytes wiederholen sich abwechselnd }
           BEGIN
             b := GetFileByte;
             bx := b XOR GetFileByte;
             { bx dient als XOR-Umschalter, der b abwech- }
             { selnd in die beiden Datenbytes umwandelt   }
             FOR i := 0 TO Count-1 DO BEGIN
               D[j+i] := b;
               b := b XOR bx;
             END;
           END;
      $60: { 011, unkomprimierte Daten folgen }
           FOR i := 0 TO Count-1 DO
             D[j+i] := GetFileByte;
    END;
    j := j + Count;
  END;
END;

PROCEDURE Compress(VAR Source; Width: Word);
{ ------------------------------------------------ }
{ Entnimmt der Quelle Source Width Bytes, kompri-  }
{ miert sie, sammelt sie im Dateipuffer FBuffer und}
{ schreibt sie abschlie·end in die Datei PCXFile   }
{ ------------------------------------------------ }
  VAR i,j,StringStart: Word;
      b, bs, bx, Count, StringCount: Byte;
      S: DataBuffer ABSOLUTE Source;

  { Vor der eigentlichen Prozedur erst mal 3 Unterprozeduren: }

  PROCEDURE StoreCount(ID, cnt: Byte);
  { Kennbits ID und ZÑhler cnt in Dateipuffer schreiben }
  BEGIN
    IF cnt > 31 THEN BEGIN
      { Kennbits und ZÑhler separat in zwei Bytes }
      FBuffer[FBufCount] := ID; Inc(FBufCount);
      FBuffer[FBufCount] := cnt; Inc(FBufCount);
    END
    ELSE BEGIN
      { Kennbits und ZÑhler zu einem Byte verknÅpft }
      FBuffer[FBufCount] := ID OR cnt; Inc(FBufCount);
    END;
  END;

  PROCEDURE StoreString;
  { String aus nicht komprimierbaren Bytes in Dateipuffer }
  BEGIN
    IF StringCount > 0 THEN BEGIN
        { Kennbits 001 und ZÑhler speichern: }
      StoreCount($60,StringCount);
        { Bytestring unkomprimiert in Puffer Åbertragen: }
      Move(S[StringStart],FBuffer[FBufCount],StringCount);
        { Dateipufferzeiger erhîhen: }
      FBufCount := FBufCount + StringCount;
      StringCount := 0;
    END;
    { Quellpufferindex als Anfang eines neuen String merken }
    StringStart := i;
  END;

  PROCEDURE StoreID(ID: Byte);
  { Kennbits und ZÑhler fÅr komprimierte Sequenz speichern }
  BEGIN
    i := i + Count;       { Index in Quellpuffer erhîhen }
    StoreString;          { Erst eventuellen Bytestring behandeln }
    StoreCount(ID,Count); { Kennbits und ZÑhler speichern }
  END;

BEGIN  { der Hauptprozedur Compress }
  i := 0;           { Index fÅr Quellpuffer }
  FBufCount := 0;   { Dateipuffer ist leer }
  StringCount := 0; { akt. LÑnge des Bytestrings }
  StringStart := 0; { Quellpufferindex fÅr Bytestring-Anfang }
  WHILE i < Width DO BEGIN
    Count := 1;    { WiederholungszÑhler }
    b := S[i];     { NÑchstes Byte holen }
    j := i + 1;
      { ZÑhlen, wie oft sich Byte b wiederholt: }
    WHILE (j < Width) AND (Count < 255) AND (b = S[j]) DO BEGIN
      Inc(j); Inc(Count);
    END;
    IF (b = $00) AND (Count > 1) THEN
      { Komprimierung als Folge von $00-Bytes, Kennbits 000 }
      StoreID($00)
    ELSE IF (b = $FF) AND (Count > 1) THEN
      { Komprimierung als Folge von $FF-Bytes, Kennbits 111 }
      StoreID($E0)
    ELSE IF Count > 2 THEN BEGIN
      { anderes sich wiederholendes Byte, Kennbits 001 }
      StoreID($20);
      FBuffer[FBufCount] := b; Inc(FBufCount);
    END
    ELSE BEGIN
      { Untersuchen, ob alternierende Bytefolge vorliegt }
      Count := 2;
      IF i + 1 < Width THEN bx := b XOR S[i+1];
      bs := b;
      { bx dient als XOR-Umschalter, der bs abwech- }
      { selnd in die beiden Datenbytes umwandelt    }
      j := i + 2;
      WHILE (j < Width) AND (Count < 255) AND (bs = S[j]) DO BEGIN
        Inc(j); Inc(Count);
        bs := bs XOR bx;
      END;
      IF Count > 3 THEN BEGIN
        { Komprimierung als alternierende Folge, Kennbits 110 }
        StoreID($C0);
        FBuffer[FBufCount] := b; Inc(FBufCount);
        FBuffer[FBufCount] := b XOR bx; Inc(FBufCount);
      END
      ELSE BEGIN            { Komprimierung nicht mîglich }
        Inc(i);             { Quellpufferindex erhîhen }
        Inc(StringCount);   { BytestringzÑhler erhîhen }
        IF StringCount = 255 THEN
          { Bytestring speichern, da sonst ZÑhlerÅberlauf }
          StoreString;
      END;
    END;
  END;
    { Eventuell noch Åbrig gebliebenen Bytestring speichern }
  StoreString;
    { Die Bytes der komprimierten Zeile in Datei schreiben }
  BlockWrite(PCXFile,FBuffer,FBufCount);
END;

FUNCTION LoadV16(x1,y1: Word; Filename: String): Boolean;
{ ----------------------------------------------------- }
{ LÑdt einen mit StoreV16 unter dem Dateinamen FileName }
{ gespeicherten 16-Farben-Bildausschnitt in den Bild-   }
{ speicher, so da· die linke obere Ecke bei x1,y1 liegt.}
{ Benutzt PCX-Header, ist aber nicht PCX-kompatibel, da }
{ nach anderem Verfahren vertikal komprimiert wird.     }
{ Gibt bei falschem Datei-/Bildformat False zurÅck.     }
{ Braucht ReadPalReg und SetColorBlock aus Unit EVBios. }
{ ----------------------------------------------------- }
  VAR Header: PCXHeader;
      x2, y2, x, y, i, ScrOfs: Word;
      Plane: Byte;
      Buffer: DataBuffer;
BEGIN
  PCXOpenRead(FileName,Header);  { Datei zum Lesen îffnen }
  WITH Header DO BEGIN           { Dateikopf testen: }
    IF (ID <> 10) OR             { Keine PCX-Datei? }
       (Bits <> 1) OR            { Bits pro Pixel u. Ebene falsch? }
       (Planes <> 4) OR          { Anzahl Farbebenen falsch? }
       (Encoding = 0) THEN       { unkomprimiert? }
      LoadV16 := False         { dann kann Bild nicht gelesen werden }
    ELSE BEGIN
      LoadV16 := True;         { Bild kann gelesen werden }
      IF (Version = 2) OR (Version = 5) THEN BEGIN
        { Palettendaten vorhanden }
        FOR i := 0 TO 15 DO BEGIN
            { Farbinformation auf 6-Bit-Format bringen... }
          Colors[i,Red] := Colors[i,Red] SHR 2;
          Colors[i,Green] := Colors[i,Green] SHR 2;
          Colors[i,Blue] := Colors[i,Blue] SHR 2;
            { ...und in passendes Farbregister eintragen }
          SetColorBlock(ReadPalReg(i),1,Colors[i]);
        END;
      END;
      y2 := y1 + (ymax - ymin);           { y2 = letzte Rasterzeile }
      x2 := x1 + (xmax - xmin);
      Port[$3C4] := 2;                    { Index fÅr Map Mask Register }
      FOR x := x1 DIV 8 TO x2 DIV 8 DO BEGIN { Alle Spalten abgrasen }
        FOR Plane := 0 TO 3 DO BEGIN      { Alle Ebenen abgrasen }
          { Daten fÅr eine Spalte aus der Datei in den Puffer holen }
          Expand(Buffer,BytesPerLine);
          ScrOfs := ScrWidth * y1 + x;    { Offsetadr. Spaltenbeginn }
          Port[$3C5] := 1 SHL Plane;      { Bitmaske fÅr Map Mask Reg. }
          FOR y := 0 TO y2-y1 DO BEGIN    { Von oben nach unten... }
            Mem[ScrSeg:ScrOfs] := Buffer[y];  { Pufferbytes in den Bildspeicher }
            ScrOfs := ScrOfs + ScrWidth;   { Offsetadr. der nÑchsten Zeile }
          END;
        END;
      END;
      Port[$3C5] := $F;       { Map Mask Register mit Standard laden }
      PCXClose;               { Datei schlie·en }
    END;
  END;
END;

PROCEDURE SaveV16(x1,y1,x2,y2: Word; FileName: String);
{ ----------------------------------------------------- }
{ Speichert einen Bildausschnitt in den 16-Farben-Modi  }
{ unter dem Dateinamen Filename ab. Benutzt PCX-Header, }
{ aber eine abweichende vertikale Komprimierung. x1,y1  }
{ ist die linke obere und x2,y2 die rechte untere Ecke. }
{ Braucht ReadPalReg und ReadColorBlock aus Unit EVBios.}
{ ----------------------------------------------------- }
  VAR Header: PCXHeader;
      ScrOfs, i, x, y: Word;
      Plane: Byte;
      Buffer: DataBuffer;
BEGIN
  FillChar(Header,HeaderSize,0); { Erst Dateikopf mit Nullen fÅllen }
  WITH Header DO BEGIN           { und dann mit Werten bestÅcken: }
    ID := 10;                  { Dateikennung }
    Version := 2;              { mit Header-Palettendaten }
    Encoding := 1;             { komprimiert }
    Bits := 1;                 { Bits pro Pixel pro Ebene }
    xmin := x1; ymin := y1;    { Bildkoordinaten }
    xmax := x2; ymax := y2;
    HRes := 75; VRes := 75;    { pro forma die Auflîsung }
    Planes := 4;               { 4 Speicherebenen }
    BytesPerLine := y2 - y1 + 1;
    PaletteInfo := 1;          { Farbbild }
    FOR i := 0 TO 15 DO BEGIN
      { Farbinformation aus Farbregister lesen... }
      ReadColorBlock(ReadPalReg(i),1,Colors[i]);
      { ...und auf 8-Bit-Format bringen }
      Colors[i,Red] := Colors[i,Red] SHL 2;
      Colors[i,Green] := Colors[i,Green] SHL 2;
      Colors[i,Blue] := Colors[i,Blue] SHL 2;
    END;
    PCXOpenWrite(FileName,Header);      { Datei zum Schreiben îffnen }
    Port[$3CE] := 4;                    { Index fÅr Read Map Select Reg. }
    FOR x := x1 DIV 8 TO x2 DIV 8 DO BEGIN  { Alle Spalten abgrasen }
      FOR Plane := 0 TO 3 DO BEGIN      { Alle Ebenen abgrasen: }
        Port[$3CF] := Plane;            { Read Map Register laden }
        ScrOfs := ScrWidth * y1 + x;    { Offsetadr. Spaltenbeginn }
        FOR y := 0 TO y2-y1 DO BEGIN    { Bytes von oben nach unten... }
          Buffer[y] := Mem[ScrSeg:ScrOfs]; { in den Puffer Åbertragen }
          ScrOfs := ScrOfs + ScrWidth;   { Offsetadr. der nÑchsten Zeile }
        END;
        Compress(Buffer,BytesPerLine);   { Pufferinhalt wegschreiben }
      END;
    END;
    Port[$3CF] := 0;     { Read Map Register mit Standard laden }
  END;
  PCXClose;              { Datei schlie·en }
END;

FUNCTION LoadH16(x1,y1: Word; Filename: String): Boolean;
{ ----------------------------------------------------- }
{ LÑdt einen mit StoreH16 unter dem Dateinamen FileName }
{ gespeicherten 16-Farben-Bildausschnitt in den Bild-   }
{ speicher, so da· die linke obere Ecke bei x1,y1 liegt.}
{ Benutzt PCX-Header, ist aber nicht PCX-kompatibel, da }
{ nach anderem Verfahren horizontal komprimiert wird.   }
{ Gibt bei falschem Datei-/Bildformat False zurÅck.     }
{ Braucht ReadPalReg und SetColorBlock aus Unit EVBios. }
{ ----------------------------------------------------- }
  VAR Header: PCXHeader;
      x2, y2, y, i, ScrOfs: Word;
      Plane: Byte;
BEGIN
  PCXOpenRead(FileName,Header);  { Datei zum Lesen îffnen }
  WITH Header DO BEGIN           { Dateikopf testen: }
    IF (ID <> 10) OR             { Kein PCX-Header? }
       (Bits <> 1) OR            { Bits pro Pixel u. Ebene falsch? }
       (Planes <> 4) OR          { Anzahl Farbebenen falsch? }
       (Encoding = 0) OR         { unkomprimiert? }
       (x1 DIV 8 + BytesPerLine > ScrWidth) THEN  { Bild zu breit? }
      LoadH16 := False         { dann kann Bild nicht gelesen werden }
    ELSE BEGIN
      LoadH16 := True;         { Bild kann gelesen werden }
      IF (Version = 2) OR (Version = 5) THEN BEGIN
        { Palettendaten vorhanden }
        FOR i := 0 TO 15 DO BEGIN
            { Farbinformation auf 6-Bit-Format bringen... }
          Colors[i,Red] := Colors[i,Red] SHR 2;
          Colors[i,Green] := Colors[i,Green] SHR 2;
          Colors[i,Blue] := Colors[i,Blue] SHR 2;
            { ...und in passendes Farbregister eintragen }
          SetColorBlock(ReadPalReg(i),1,Colors[i]);
        END;
      END;
      ScrOfs := ScrWidth * y1 + x1 DIV 8; { Offsetadr. links oben }
      y2 := y1 + (ymax - ymin);           { y2 = letzte Rasterzeile }
      Port[$3C4] := 2;                    { Index fÅr Map Mask Register }
      FOR y := y1 TO y2 DO BEGIN          { Alle Rasterzeilen abgrasen: }
        FOR Plane := 0 TO 3 DO BEGIN      { Alle Ebenen abgrasen }
          Port[$3C5] := 1 SHL Plane;      { Bitmaske fÅr Map Mask Reg. }
          Expand(Mem[ScrSeg:ScrOfs],BytesPerLine);  { Zeile laden }
        END;
        ScrOfs := ScrOfs + ScrWidth;   { Offsetadr. der nÑchsten Zeile }
      END;
      Port[$3C5] := $F;       { Map Mask Register mit Standard laden }
      PCXClose;               { Datei schlie·en }
    END;
  END;
END;

PROCEDURE SaveH16(x1,y1,x2,y2: Word; FileName: String);
{ ----------------------------------------------------- }
{ Speichert einen Bildausschnitt in den 16-Farben-Modi  }
{ unter dem Dateinamen Filename ab. Benutzt PCX-Header, }
{ aber eine abweichende horizontale Komprimierung. x1,y1}
{ ist die linke obere und x2,y2 die rechte untere Ecke. }
{ Braucht ReadPalReg und ReadColorBlock aus Unit EVBios.}
{ ----------------------------------------------------- }
  VAR Header: PCXHeader;
      ScrOfs, i, y: Word;
      Plane: Byte;
BEGIN
  FillChar(Header,HeaderSize,0); { Erst Dateikopf mit Nullen fÅllen }
  WITH Header DO BEGIN           { und dann mit Werten bestÅcken: }
    ID := 10;                  { Dateikennung }
    Version := 2;              { mit Header-Palettendaten }
    Encoding := 1;             { komprimiert }
    Bits := 1;                 { Bits pro Pixel pro Ebene }
    xmin := x1; ymin := y1;    { Bildkoordinaten }
    xmax := x2; ymax := y2;
    HRes := 75; VRes := 75;    { pro forma die Auflîsung }
    Planes := 4;               { 4 Speicherebenen }
    BytesPerLine :=
      x2 DIV 8 - x1 DIV 8 + 1; { Ausschnittbreite }
    PaletteInfo := 1;          { Farbbild }
    FOR i := 0 TO 15 DO BEGIN
      { Farbinformation aus Farbregister lesen... }
      ReadColorBlock(ReadPalReg(i),1,Colors[i]);
      { ...und auf 8-Bit-Format bringen }
      Colors[i,Red] := Colors[i,Red] SHL 2;
      Colors[i,Green] := Colors[i,Green] SHL 2;
      Colors[i,Blue] := Colors[i,Blue] SHL 2;
    END;
    PCXOpenWrite(FileName,Header);      { Datei zum Schreiben îffnen }
    ScrOfs := ScrWidth * y1 + x1 DIV 8; { Offsetadr. links oben }
    Port[$3CE] := 4;                    { Index fÅr Read Map Select Reg. }
    FOR y := y1 TO y2 DO BEGIN          { Alle Rasterzeilen abgrasen: }
      FOR Plane := 0 TO 3 DO BEGIN      { Ebenen rÅckwÑrts abgrasen: }
        Port[$3CF] := Plane;            { Read Map Register laden }
        Compress(Mem[ScrSeg:ScrOfs],BytesPerLine);  { Zeile schreiben }
      END;
      ScrOfs := ScrOfs + ScrWidth; { Offsetadresse der nÑchsten Zeile }
    END;
    Port[$3CF] := 0;     { Read Map Register mit Standard laden }
  END;
  PCXClose;              { Datei schlie·en }
END;

{ ------------------------------------------------------------------- }
{ Die folgenden Prozeduren arbeiten mit verbesserter Komprimierung in }
{ den 256-Farben-Modi, die Dateien sind aber nicht mehr PCX-kompatibel}
{ ------------------------------------------------------------------- }

FUNCTION Load256(x1,y1: Word; Filename: String): Boolean;
{ ----------------------------------------------------- }
{ LÑdt einen als PCX-Datei mit dem Dateinamen FileName  }
{ gespeicherten 256-Farben-Bildausschnitt in den Bild-  }
{ speicher, so da· die linke obere Ecke bei x1,y1 liegt.}
{ Gibt bei falschem Datei-/Bildformat False zurÅck.     }
{ ----------------------------------------------------- }
  VAR Header: PCXHeader;
      x2, y2, y, i, ScrOfs: Word;
      b: Byte;
      ColorData: ARRAY[0..255] OF PCXColor;
BEGIN
  PCXOpenRead(FileName,Header);  { Datei zum Lesen îffnen }
  WITH Header DO BEGIN           { Dateikopf testen: }
    IF (ID <> 10) OR             { Keine PCX-Datei? }
       (Bits <> 8) OR            { Bits pro Pixel falsch? }
       (Planes <> 1) OR          { Mehr als 1 Farbebene? }
       (Encoding = 0) OR         { unkomprimiert? }
       (x1 + BytesPerLine > ScrWidth * 8) THEN  { Bild zu breit? }
      Load256 := False        { dann kann Bild nicht gelesen werden }
    ELSE BEGIN
      Load256 := True;        { Bild kann gelesen werden }
      IF Version = 5 THEN BEGIN  { angehÑngte Palettendaten }
          { Dateizeiger auf Palettendaten setzen: }
        Seek(PCXFile,FileSize(PCXFile)-769);
        BlockRead(PCXFile,b,1);  { ID-Byte lesen u. testen: }
        IF b = $0C THEN BEGIN    { es liegen gÅltige Palettendaten vor }
          BlockRead(PCXFile,ColorData,3 * 256); { Daten lesen }
          FOR i := 0 TO 255 DO BEGIN
            { Farbinformationen auf 6-Bit-Format bringen }
            ColorData[i,Red] := ColorData[i,Red] SHR 2;
            ColorData[i,Green] := ColorData[i,Green] SHR 2;
            ColorData[i,Blue] := ColorData[i,Blue] SHR 2;
          END;
          SetColorBlock(0,256,ColorData); { Alle 256 Farbregister laden }
        END;
         { Dateizeiger wieder hinter Dateikopf setzen: }
        Seek(PCXFile,HeaderSize);
      END;
      ScrOfs := ScrWidth * 8 * y1 + x1;  { Offsetadr. links oben }
      y2 := y1 + (ymax - ymin);          { y2 = letzte Rasterzeile }
      FOR y := y1 TO y2 DO BEGIN         { Alle Rasterzeilen abgrasen: }
        Expand(Mem[ScrSeg:ScrOfs],BytesPerLine);  { Zeile lesen }
        ScrOfs := ScrOfs + ScrWidth * 8; { Offsetadresse nÑchste Zeile }
      END;
      PCXClose;  { Datei schlie·en }
    END;
  END;
END;

PROCEDURE Save256(x1,y1,x2,y2: Word; FileName: String);
{ ----------------------------------------------------- }
{ Speichert einen Bildausschnitt im 256-Farben-Modus 13h}
{ unter dem Dateinamen Filename als PCX-Datei ab. x1,y1 }
{ ist die linke obere und x2,y2 die rechte untere Ecke. }
{ ----------------------------------------------------- }
  VAR Header: PCXHeader;
      ScrOfs, i, y: Word;
      b: Byte;
      ColorData: ARRAY[0..255] OF PCXColor;
BEGIN
  FillChar(Header,HeaderSize,0); { Erst Dateikopf mit Nullen fÅllen }
  WITH Header DO BEGIN           { und dann mit Werten bestÅcken: }
    ID := 10;                    { Dateikennung }
    Version := 5;                { 256 angehÑngte Palettendaten }
    Encoding := 1;               { komprimiert }
    Bits := 8;                   { Bits pro Pixel pro Ebene }
    xmin := x1; ymin := y1;      { Bildkoordinaten }
    xmax := x2; ymax := y2;
    HRes := 75; VRes := 75;      { pro forma die Auflîsung }
    VMode := $13;
    Planes := 1;                 { 1 Speicherebene }
    BytesPerLine := x2 - x1 + 1; { Bildbreite in Bytes }
    PaletteInfo := 1;
    PCXOpenWrite(FileName,Header);
    ScrOfs := ScrWidth * 8 * y1 + x1;  { Offsetadr. links oben }
    FOR y := y1 TO y2 DO BEGIN         { Alle Rasterzeilen abgrasen: }
      Compress(Mem[ScrSeg:ScrOfs],BytesPerLine);  { Zeile schreiben }
      ScrOfs := ScrOfs + ScrWidth * 8; { Offsetadresse nÑchste Zeile }
    END;
  END;
  b := $0C;                          { Kennung fÅr Palettendaten }
  BlockWrite(PCXFile,b,1);           { an Datei anhÑngen }
  ReadColorBlock(0,256,ColorData);   { Alle Farbregister auslesen }
  FOR i := 0 TO 255 DO BEGIN         { und in 8-Bit-Form bringen }
    ColorData[i,Red] := ColorData[i,Red] SHL 2;
    ColorData[i,Green] := ColorData[i,Green] SHL 2;
    ColorData[i,Blue] := ColorData[i,Blue] SHL 2;
  END;
    { Palettendaten fÅr 256 Farben an Datei anhÑngen }
  BlockWrite(PCXFile,ColorData,3 * 256);
  PCXClose;  { Datei schlie·en }
END;

{ ================================================================ }
END.  { Kein Initialisierungsteil }
