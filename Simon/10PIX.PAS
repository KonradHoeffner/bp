{Hi Simon! Hier mein Vorschlag f걊 dein 10-pixel-Maus-Problem
(ich erspare dir mal die virtuellen Seiten, die ich eigentlich benutzen w걊de).
Also heute versuche ich mal ganz verst꼗dlich zu schreiben/kommentieren,
 da kann ich gleich mal 갶en f걊 die Info-Jahresarbeit.
Da ich gerade in Leipzig angekommen bin und es Sonntag abend ist und
ich noch eine Mathe-Berichtigung machen muss kann ich
hier nur eine Minimalversion liefern.
In einem richtigen Programm kannst du nicht st꼗dig die Maus abfragen,
die neue Mauskoordinate ist meistens mehr als 1 Pixel von der anderen entfernt
das ganze wird nicht richtig fl걌sig (stell mal den Waitretrace an und die anz auf 10-50).
Falls du nur vorhast, sp꼝er mal eine Mausspur zu machen (f걊 Laptops...)
ist das nat걊lich kein Problem, so werde ich die Hauptschleife so oft wie m봥lich
durchlaufen lassen und die Anzahl hochstellen um die n봳ige Fl걌sigkeit der
Darstellung zu erreichen.
Ausserdem h꼗gt dann die L꼗ge des Schweiffes von deiner Rechnergeschwindigkeit ab,
ich verwende z.Zt. 1000, allerdings wird es immer noch nicht fl걌sig
genug, wahrscheinlich ist meine Maus nicht aufl봲end genug (Billigmaus).
Die L봲ung w꼛e nat걊lich das Ziehen von Linien zwischen den einzelnen Pixeln,
aber das w꼛e aufwendiger und vielleicht willst du ja doch eine "Laptop-Mausspur"?

Da kann ich ja eigentlich gleich mal 'ne Beschreibung machen,
falls dir das hilft.
Ach so, soll jedes Pixel in dem Schweif die gleiche Farbe haben, oder
willst du eine Art Abstufung erreichen? Ich nehme mal letzteres an,
sonst musst du nur das jeweils neue Pixel zeichnen und das alte wegnehmen
und sie nicht jedesmal alle neu zeichnen.
Vorgehensweise: (nur die Hauptschleife, dadurch scheint die
컴컴컴컴컴컴컴� Reihenfolge anfangs vielleicht unlogisch)

 1. -> vorher letzten Pixel im Schweif auf dem Bild(-schirm) l봲chen,
    den Rest nach hinten verlegen -> letztes Element im array wird gel봲cht
 2. Maus abfragen
 3.

}
uses konrad,crt;
const anz=200;
var schweif:array[1..anz] of TPos; {s. Konrad-> Record - x,y:integer}
    t:word;
Procedure Schleife;
var nr:word;
Begin
 repeat
  waitretrace;
  with schweif[anz] do if (y<>schweif[anz-1].y) or (x<>schweif[anz-1].x)
  then screen[y,x]:=0; {letzten Pixel l봲chen}
  for nr:=anz downto 2 do schweif[nr]:=schweif[nr-1];{array nach hinten schieben}
  Maus_Abfrage;Maus.X:=Maus.X shr 1;{Maus abfragen}
  Schweif[1].X:=Maus.X;
  Schweif[1].y:=Maus.y;
  for nr:=1 to anz do with schweif[nr] do screen[y,x]:=255-(nr*255 div anz);{ Damit die Farben von 1-255 gehen}
 until (keypressed) or (maus.taste=3);
End;


Begin
 Init13h;
 for t:=1 to 255 do SetMyPalette(t,t shr 2,0,0); {s. "ps.txt"}
 Maus_Init;
 Maus_Abfrage;Maus.X:=Maus.X shr 1;
 for t:=1 to anz do
 Begin
  Schweif[t].x:=maus.x;
  Schweif[t].y:=maus.y;
 End;
 Schleife;
End.