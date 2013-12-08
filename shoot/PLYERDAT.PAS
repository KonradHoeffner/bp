unit PlyerDat;

interface

uses uni,grafik,Download,Gamedata;

procedure Leben;
procedure ShowWerte;
procedure DelWerte;
procedure ReguliereSchuss;

implementation

procedure Leben;
 begin
  if p1.leben < 0 then halt;
 end;

procedure ShowWerte;
 begin
  for t:=1 to p1.leben do screen[1,(t div 2)+230]:=(t div 10)+39;
  for t:=1 to s2.muni  do screen[3,t+229]:=(t div 5)+39;
 end;

procedure DelWerte;
 begin
  for t:=1 to p1.leben do screen[1,(t div 2)+230]:=0;
  for t:=1 to s2.muni  do screen[3,t+229]:=0;
 end;

procedure ReguliereSchuss;
 begin
  if s2.muni > MaxSchuss then s2.muni:=MaxSchuss;
 end;

begin
end.