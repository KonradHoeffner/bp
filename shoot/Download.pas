unit Download;

interface

uses uni;

const MaxSchuss = 50;
const MaxStones = 7;

var P1 :                        record
                                richtung : byte;
                                x,y      : integer;
                                oldx,oldy: integer;
                                leben    : integer;
                                act_weapon:byte;
                                end;
    W  : array[0..10-1] of       record
                                wahr     : boolean;
                                anz      : byte;
                                end;
    W2 : array[0..10-1] of      record
                                x,y      : integer;
                                end;
    S1 : array[0..MaxSchuss] of record
                                x,y      : integer;
                                wahr     : boolean;
                                richtung : byte;
                                end;
    S2 :                        record
                                muni     : integer;
                                end;
    pack :                      record
                                x,y      : integer;
                                wahr     : boolean;
                                counter  : word;
                                end;
    anz :                       byte;
    Sshoot : array[0..MaxSchuss-1] of boolean;
    PressFire : boolean;
    Splayer: boolean;

procedure Init;

implementation

procedure Init;
 begin
  Init13h;
  setmaus(0,1);
  p1.richtung:=1;
  p1.leben:=100;

  for t:=0 to 9-1 do W[t].wahr:=false;
  W[1].wahr:=true;

  p1.x:=15;
  p1.y:=15;

  pack.wahr:=true;
  pack.x:=45;
  pack.y:=45;
  pack.counter:=3000;


  s2.muni:=10;

  anz:=0;
  for t:=0 to MaxSchuss-1 do
   begin
    Sshoot[t]:=true;
    S1[t].x:=-20;
    S1[t].y:=-20;
   end;
 end;

begin
end.