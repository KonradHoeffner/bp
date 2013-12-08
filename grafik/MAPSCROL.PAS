uses konrad,crt,picture,_32bit;
const path='c:\eigene~1\bp\grafik\';
      name='map.map';
type mtype=array[1..10] of ^screen_type;
var  x,y:word;
     map:mtype;
     anzahl,anzx,anzy:byte;
     puffer:^p_type;
     s:string;
procedure readmap(filename:string);
var mapfile:text;
    t:word;
    name:string;
    result:word;
begin
 clrscr;
 writeln('Freier Speicher: ',memavail,' bytes.');
 writeln('Reading Maps...');
 assign(mapfile,filename);
 reset(mapfile);
 readln(mapfile,anzahl,anzx,anzy);
 for t:=1 to anzahl do
 begin
  readln(mapfile,name);
  getmem(map[t],64000);
  loadpcx(name,puffer^);
  movelongint(puffer^,map[t]^,16000);
  move(puffer^[64000],palette,768);
 end;
 setpal;
 close(mapfile);
 writeln('Freier Speicher: ',memavail,' bytes.');
end;

procedure drawmap(y:word);
var bild,zeile:byte;
begin
 bild:=(y div 200)+1;
 zeile:=y mod 200;
 movelongint(map[bild]^[zeile,0],screen,(200-zeile)*80);
if zeile<>0 then movelongint(map[bild+1]^[0,0],screen[200-zeile,0],zeile*80);

end;

begin
 init13h;
 getmem(puffer,64768);
 readmap(path+name);
 y:=400;
 setmaus(0,y div 2);
 repeat
  maus_abfrage;
  y:=maus.y*2;
  waitretrace;
  drawmap(y);
  str(y,s);
 until keypressed;
 freemem(puffer,64768);
end.