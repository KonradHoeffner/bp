uses crt,uni,Download{Initialisierung},grafik,gamedata,PlyerDat,Packs,Cheats;

begin
Init;
SetStones;
 repeat
  p1.oldx:=p1.x;
  p1.oldy:=p1.y;
  ShowSchuss;
  ShowPlayer;
  ShowWerte;
   waitretrace;
  DelWerte;
  DelPLayer;
  DelSchuss;
   SetSchuss;
    Tasten;
    Limits;

  Leben;
  SetMuni;
  GivePack;
  Count;
  ReguliereSchuss;
  GetFire;
  Cheat;
  SetWeapon2;
 until key = #27;
nosound;
end.