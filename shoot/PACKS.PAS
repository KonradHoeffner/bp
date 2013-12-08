unit Packs;

interface

uses uni,gamedata,download,grafik;

procedure SetMuni;
procedure GivePack;
procedure Count;
procedure SetWeapon2;

implementation

procedure SetMuni;
 begin
  if pack.wahr then paint15(pack.x,pack.y,muni)
               else paint15(pack.x,pack.y,black15);
 end;

procedure GivePack;
 begin
  if pack.wahr then
   begin
    if (p1.x = pack.x) and (p1.y = pack.y) then
     begin
      inc(s2.muni,10);
      pack.wahr:=false;
      pack.counter:=300;
     end;
   end;
 end;

procedure Count;
 begin
  dec(pack.counter);
  if pack.counter < 1 then
   begin
    pack.wahr:=true;
   end;
 end;

procedure SetWeapon2;
 begin
  if W[2].wahr=false then
   begin
    paint15(W2[2].x,W2[2].y,Weapon2);
    W2[2].x:=90;
    W2[2].y:=45;

    if (p1.x=W2[2].x) and (p1.y=W2[2].y) then
     begin
      W[3].wahr:=true;
      W[2].anz:=2;
     end;
  end;
 end;

begin
end.