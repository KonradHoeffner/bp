unit cheats;

interface

uses crt,uni,download,gamedata;

var Eingabe : string;

procedure Cheat;

implementation

procedure Cheat;
 begin
  if key = 't' then
   begin
    read(eingabe);
     if eingabe = 'live' then p1.leben:=100;
     if eingabe = 'muni' then s2.muni:=MaxSchuss;
     SetStones;
   end;
 end;

begin
end.