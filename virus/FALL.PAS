{旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
 � Virus "Fallende Buchstaben"              �
 � 袴袴袴袴袴袴袴袴袴袴袴袴袴�              �
 �                       Konrad H봣fner 1999�
 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑
 쿞peicherresidentes Programm, das s꼖tliche�
 쿩eichen vom Bildschirm fallen l꼜st       �
 �(Textmodus).                              �
 쿍enutzte Units: Dos                       �
 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Idee: Man klinkt sich in den Timerinterrupt (Int. 8) ein, der 18,2 mal
      pro Sekunde aufgerufen wird und manipuliert den Bildspeicher so,
      das ein Falleffekt ausgel봲t wird.
      Dabei muss aber beachtet werden, da� die alten Timerfunktionen
      immer noch ausgef갿rt werden!
      Diese werden auf einen anderen Interrupt ausgelagert, so dass es
      einfach ist das Fallen r갷kgangig zu machen. (siehe Stop.pas)}

{$M 1024,0,0}{Compilerbefehl $M: Voreinstellung 1024 Byte Stack, kein Heap}
uses dos;
const warte=6; {Alle "warte" aufrufe des Int 8 wird das Fallen ausgel봲t
                (f걊 "warte"=18 bedeutet das ca. 1 mal/Sekunde)}
      nummer=$50;{Nummer f걊 neuen Interrupt zum Speichern der Befehle}
type textmode=array[1..25,1..80] of record
                                     zeichen:char;
                                     farbe:byte;
                                    end;
var alt8,neu8:pointer;{alt8 zeigt auf alten Int. 8, neu8 auf den neuen}
    r:registers;
    zaehl:byte;
    bild:textmode absolute $b800:0;
    {Der Textmodus wird durch einen Array zug꼗glich gemacht, ohne
    write zu benutzen. Dieser Array wird mit "absolute" auf die Adresse
    des Bildspeichers gelegt ($b800:0).
    Wegen der Arraystruktur muss man die y-Koordinate zu erst angeben,
    auch wenn dies anfangs verwirrt.
    ->Zeichen schreiben: bild[y,x].zeichen:=Zeichen;
    Bsp.: bild[25,80].zeichen:='H'; -> es wird unten rechts
                                       ein "H" geschrieben}
procedure int8;interrupt;
var x,y:byte;
begin
 intr(nummer,r); {Int $50 ausf갿ren (s.unten)}
 if zaehl=0 then
 begin
  for y:=25 downto 2 do for x:=1 to 80 do   {� Fallen der Zeichen}
   begin                                    {�}
    bild[y,x].farbe:=bild[y-1,x].farbe;     {�}
    bild[y,x].zeichen:=bild[y-1,x].zeichen; {�}
   end;                                     {�}
  for x:=1 to 80 do with bild[y,x] do       {� L봲chen 1. Zeile}
  begin                                     {�}
   zeichen:=' ';                            {�}
   farbe:=0;                                {�}
  end;                                      {�}
  {Andere Variante (schneller):
   move(mem[$b800:0],mem[$b800:80*2],24*80*2);
   fillchar(mem[$b800:0],80*2,0);}
  zaehl:=warte;
 end else dec(zaehl);
end;

begin
 zaehl:=0;
 getintvec(8,alt8);  {Adresse des alten Int 8}
 setintvec(nummer,alt8); {Alten Int 8 auf Int $50 setzen}
 setintvec(8,@int8); {Int 8 auf Prozedu Int8 setzen.}
 keep(0);{}          {Programm im Speicher lassen (Fehlercode 0)}
end.