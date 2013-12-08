unit umap;
interface
uses picture,_32bit,konrad;
type mtype=array[1..10] of ^screen_type;
var anzahl,anzx,anzy:byte;
    map:mtype;
    puffer:^tpuffer;
    s:string;

procedure readmap(filename:string);
procedure drawmap_y(y:word);
procedure drawmap_xy(x,y:word);

implementation

procedure readmap(filename:string);
var mapfile:text;
    t:word;
    name:string;
    result:word;
begin
 getmem(puffer,64768);
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
 freemem(puffer,64768);
end;

procedure drawmap_y(y:word);
var bild,zeile:byte;
begin
 bild:=(y div 200)+1;
 zeile:=y mod 200;
 movelongint(map[bild]^[zeile,0],screen,(200-zeile)*80);
if zeile<>0 then movelongint(map[bild+1]^[0,0],screen[200-zeile,0],zeile*80);
end;

procedure drawmap_xy(x,y:word);
var bild,bildx,bildy:byte;
    rx,ry:word;
    t:word;
begin
 bildx:=(x div 320);
 bildy:=(y div 200);
 ry:=y{ mod 200};
 rx:=x{ mod 320};

{ bild:=anzx*bildy+bildx+1;}
 bild:=1;


 for t:=0 to 199-ry do
 begin
  movelongint(map[bild]^[ry+t,rx],screen[t,0],(320-rx) shr 2+1);
  movelongint(map[bild+1]^[ry+t,0],screen[t,320-rx],rx shr 2+1);
 end;

 if ry<>0 then for t:= 0 to ry do
  begin
   movelongint(map[bild+anzx]^[t,rx],screen[t+199-ry,0],(320-rx) shr 2 +1);
   movelongint(map[bild+anzx+1]^[t,0],screen[t+199-ry,320-rx],rx shr 2 +1);
  end;


end;

begin
end.