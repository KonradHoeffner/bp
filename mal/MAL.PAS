{Farben:
 0=Schwarz

l= laden
s= speichern }

uses konrad,_32bit,graphic,crt,_13h;
const anzx=5;
      anzy=5;
     maus1:array[0..4,0..4] of byte=
                            ((0,0,2,0,0),
                             (0,0,2,0,0),
                             (2,2,0,2,2),
                             (0,0,2,0,0),
                             (0,0,2,0,0));
    grenzo:byte=2*2;
    grenzu:byte=197;
    grenzl:byte=2*2;
    grenzr:word=317*2;
var screen1:^screen_type;
    f:file;

procedure load;
begin
 assign(f,'test.pic');
 reset(f,64000);
 blockread(f,screen,1);
 close(f);
 loadpal('test.pal');
 setpal;
end;

procedure save;
begin
 assign(f,'test.pic');
 rewrite(f,64000);
 blockwrite(f,screen,1);
 close(f);
end;


procedure init;
begin
 init13h;
 getmem(screen1,64000);
 filllongint(screen1^,16000,0);
 maus_init;
end;

procedure main;
var ende:boolean;
    farbe:byte;
    oldx,oldy:word;
 procedure putmaus;
 var x,y:word;
 begin
  for y:=maus.y-2 to maus.y+anzy-2 do move(screen[y,maus.x-2],screen1^[y,maus.x-2],anzx);
  for x:=0 to anzx-1 do
   for y:=0 to anzy-1 do
    if maus1[x,y]>0 then screen[y+maus.y-2,x+maus.x-2]:=maus1[x,y];
 end;

 procedure loeschmaus;
 var x,y:word;
 begin
  for y:=maus.y-2 to maus.y+anzy-2 do move(screen1^[y,maus.x-2],screen[y,maus.x-2],anzx);
 end;

begin
 ende:=false;
 farbe:=red;
 repeat
  oldx:=maus.x;
  oldy:=maus.y;
  maus_abfrage;
  if maus.x<grenzl then begin setmaus(grenzl,maus.y); maus.x:=grenzl; end;
  if maus.x>grenzr then begin setmaus(grenzr,maus.y); maus.x:=grenzr; end;
  if maus.y<grenzo then begin setmaus(maus.x,grenzo); maus.y:=grenzo; end;
  if maus.y>grenzu then begin setmaus(maus.x,grenzu); maus.y:=grenzu; end;
  maus.x:=maus.x shr 1;
  if maus.taste=1 then {screen[maus.y,maus.x]:=farbe;}line(screen,oldx,oldy,maus.x,maus.y,farbe);
  putmaus;
  waitretrace;
  loeschmaus;
  if keypressed then
  begin
   taste:=readkey;
   if taste=#27 then ende:=true;
   if taste='l' then load;
   if taste='s' then save;
  end;
 until ende;
end;

procedure final;
begin
 freemem(screen1,64000);
 textmode(3);
end;

begin
 init;
 main;
 final;
end.