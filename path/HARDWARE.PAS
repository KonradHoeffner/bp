{-----------Unit Hardware------------
 Funktion: Senden von Steuerungsbefehlen
 an die Motoren ber den Parallelport
 -------------------------------------
}
unit hardware;
interface
procedure sendb(b:byte);{Sendet ein Byte an die Motorsteuerungsplatine}
procedure setbit(b:byte);{Setzt ein bestimmtes Steuerungsbit}
procedure clearbit(b:byte);{L”scht ein Steuerungsbit}
{Setzt den Roboter zurck (entspricht sendb(0) bzw. sendb(stop))}
procedure r_reset;
function testbit(b,nr:byte):boolean;{gibt angegebenes Steuerungsbit zurck}
const
{Adresse des Parallelports}
 base:word=$378;{Achtung: auch $378 m”glich!}
{ $278=632 $378=888}
{-----Bedeutung der einzelnen Bits:-----}
{----Motoren----}
 motor1=0;{1}
 umrel1=1;{2}
 motor2=2;{4}
 umrel2=3;{8}
{---Fertige Steuerungsbytes---}
 vor:byte=5;{vorw„rts fahren}
 rueck:byte=15;{rckw„rts}
 links:byte=7;{im Stand nach Links}
 rechts:byte=13;{bzw Rechts drehen}
 stop:byte=0;{Anhalten}
{---------------------------------------}
{    kollision:boolean=false;}
var sb:byte;{Speichert den momentanen Status des Sendebytes}
    eb:byte;{Empfangsbyte}

implementation


procedure sendb(b:byte);
begin
 sb:=b;
 port[base]:=sb;
end;

procedure setbit(b:byte);
begin
 sb:=sb or (1 shl b);
 sendb(sb);
end;

procedure clearbit(b:byte);
begin
 sb:=sb and (255-(1 shl b));
 sendb(sb);
end;

function testbit(b,nr:byte):boolean;
begin
 if (b and (1 shl nr))>0 then testbit:=true else testbit:=false;
end;
procedure r_reset;
begin
 port[base]:=0;
end;

end.