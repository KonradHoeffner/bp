uses crt;

procedure dreh(Rz:shortint);
var Re:shortint;
{Re = effektive Richtung
 Rz = Zielrichtung
ÚÄÄÄÄÄÄÄÄÄÄÄ¿
³ Re = Rz-Rf³
ÀÄÄÄÄÄÄÄÄÄÄÄÙ
      0
    -1 +1
   -2   +2
    -3 3
   (-)4
}
begin
 Re:=Rz-Rf;
 if Re>4 then Re:=Re mod 5-3;
 if Re<-4 then Re:=Re mod 5+3;
end;

begin
end.