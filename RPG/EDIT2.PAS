{Achtung: mehrere R- bzw. R+ !}
{Dateiendungen:
 - Tiledatei   :.pcx
 - Mapinfodatei:.inf
 - Mapdatei    :.map
 }
uses konrad,_13h,_32bit,crt,picture,myrpg,sprites;
const
      UGrndOn=1;
      maus_cursor:array[0..5*5-1] of byte = (1,1,1,0,0,
                                             1,1,0,0,0,
                                             1,0,1,0,0,
                                             0,0,0,1,0,
                                             0,0,0,0,1);
    maximages=240;
    felder_x=200{14};
    felder_y=200{11};
    Map_Pos:TPos=(x:0;y:0);
    Grnd_Felder=6;{Anz der Bilder, die zusammen einen Untergrund bilden}
    Grnd_Tiles=16;{Anz. der entstehenden Bilder/Untergrund}
type TImage16=array[0..15,0..15] of byte;
     TImages=array[1..maximages] of TImage16;
     TMap=Array[0..felder_y-1,0..felder_x-1] of Byte;
     (*0..y-1,0..x-1 !!*)
     TFeld_Stat=(walk,nowalk);
var
    TileInfo:record
               F_anz,Std_anz,Grnd_walk_anz,Grnd_nowalk_anz,Sp_Anz:byte;
               feld_stat:array[1..240] of TFeld_Stat;
              end;
    ArrayList:array[1..maximages] of Byte;

    tilesize:word;
    screen1,screen2:^tscreen;
    images:^Timages;
{    Sprites:array[]}
    Rects:array[1..maximages] of pointer;
    TilePalette:array[1..maximages] of Pointer;
    Palette_Anz:byte;
    Filename,MapFileName:String;
    F:Text;
    Map:^TMap;
    usedtiles:byte;{StdTiles+Grndtiles}
    Pfeil:TSprite;{MausCursor}

Procedure WriteKar;
var f:file;
    x,y:integer;
Begin
 assign(f,filename+'.kar');
 rewrite(f,1);
 x:=felder_x;y:=felder_y;
 blockwrite(f,x,2);
 blockwrite(f,y,2);
 blockwrite(f,tileinfo.feld_stat,sizeof(tfeld_stat));
 blockwrite(f,images^,16*16*maximages);
 close(f);
End;

Procedure WriteSprites;
var f:file;
    anz:integer;
Begin
 assign(f,'tiles1'+'.spr');
 rewrite(f,1);
 blockwrite(f,tileinfo.sp_anz,2);
 with tileinfo do blockwrite(f,images^[1],16*16*sp_anz);
 close(f);
End;
 Procedure GetTile(img_nr,nr:byte);
 var y:byte;
 Begin
  for y:=0 to 15 do
  movelongint(screen1^[y,(nr-1)*16],images^[img_nr][y,0],4);
  Rects[img_nr]:=@images^[img_nr];
 End;

procedure Init;
var t:word;
begin
Maus_Init;
SetMaus(1,1);
Pfeil.Width:=5;
Pfeil.Height:=5;
Pfeil.Image:=@Maus_Cursor;
for t:=0 to 5*5-1 do Maus_Cursor[t]:=Maus_Cursor[t]*255;
Randomize;
getmem(screen1,64000);
getmem(screen2,64000);
getmem(Map,Sizeof(TMap));
fillchar(Map^,Sizeof(TMap),0);
filllongint(screen1^,16000,0);
filllongint(screen2^,16000,0);
getmem(Images,Sizeof(TImages));
end;

Procedure Final;
begin
{ Randomize;}
freemem(screen1,64000);
freemem(screen2,64000);
freemem(Map,Sizeof(TMap));
freemem(Images,Sizeof(TImages));
end;
Procedure Getimage;
var puffer:^TPuffer;
    f:file;
Begin
 getmem(puffer,64000+768);
 loadpcx(Filename+'.pcx',puffer^);
 movelongint(puffer^,screen1^,16000);
 move(puffer^[64000],palette,768);
{---}
 assign(f,'tiles1.pal');
 rewrite(f,768);
 blockwrite(f,palette,1);
 close(f);
{---}
{110}
 with tileinfo do for t:=1 to sp_anz do gettile(t,f_anz+t);
 writesprites;
{---}
 freemem(puffer,64000+768);
End;


Procedure Rotate90L(src,dest:word);
var x,y:word;
Begin
 for y:=0 to 15 do for x:=0 to 15 do
  images^[dest][15-x,y]:=images^[src][y,x];
End;

Procedure Rotate90R(src,dest:Byte);
var x,y:word;
Begin
 for y:=0 to 15 do for x:=0 to 15 do
  images^[dest][x,15-y]:=images^[src][y,x];
End;

Procedure FlipH(src,dest:Byte);
var x,y:word;
Begin
 for y:=0 to 15 do for x:=0 to 15 do
  images^[dest][y,15-x]:=images^[src][y,x];
End;

Procedure FlipV(src,dest:Byte);
var x,y:word;
Begin
 for y:=0 to 15 do for x:=0 to 15 do
  images^[dest][15-y,x]:=images^[src][y,x];
End;


Procedure ShowTileFile;
var
{    s:string;}
    b:byte;
    x_line,y_line:integer;

Begin
 TileSize:=16;
{ write('Name der Datei (ohne Endung)> ');readln(s);}
 Filename:='Tiles1';
{ if pos('.',s)=0 then s:=s+'.pcx';}
 init13h;
 GetImage;
 palette[255*3]:=25;
 palette[255*3+1]:=25;
 palette[255*3+2]:=25;
 palette[0*3]:=0;
 palette[0*3+1]:=0;
 palette[0*3+2]:=0;
 setpal;
repeat
 inc(b);
 movelongint(screen1^,screen,16000);
 if b mod 2 =0 then
 begin
  for x_line:=0 to 19 do
  begin
   line(screen,x_line*16,0,x_line*16,191,255);
   line(screen,15+x_line*16,0,15+x_line*16,191,255);
  end;
  for y_line:=0 to 11 do
  begin
   line(screen,0,y_line*16,319,y_line*16,255);
   line(screen,0,16+y_line*16,319,16+y_line*16,255);
  end;
 end;
 delay(300);
 waitretrace;
 if keypressed then taste:=readkey;
until taste in[#27,#13];
 textmode(3);
End;


Procedure Prep_Images;
var t:word;
 Procedure Prep_Grnd(var i:word);
 var t:word;
 Begin
  t:=i;
  with TileInfo do
 { if Grnd_walk_anz>0 then}
  Begin
   for t:=t+1 to t+3 do {Die Ersten 3 Tiles einlesen (normal,einzel,LRO)}
   Begin
    GetTile(t,t);
   End;
   FlipV(t,t+1);{LRU}
   Rotate90L(t,t+2);{LOU}
   Rotate90R(t,t+3);Inc(t);{ROU}{->6Tiles fertig, fehlen 5}
   GetTile(T+3,T);Inc(T);GetTile(T+3,T);{LR+L einlesen}
   FlipH(t+3,t+4);{R bilden}
   Rotate90R(t+3,t+5);{O}
   Rotate90L(t+3,t+6);{U}
   Rotate90R(T+2,t+7);{OU}
   Inc(T);GetTile(t+7,t);{LU}
   FlipV(t+7,t+8);{LO}
   FlipH(t+7,t+9);{RU}
   FlipV(t+9,t+10);{RO}

   Inc(t,Grnd_Tiles-Grnd_Felder);
   For t:=t-(Grnd_Tiles) to t do Rects[t]:=@Images^[t];
   Inc(Palette_anz,16);
  End;
  i:=t;
 End;
Begin
 with TileInfo do
 Begin
  Inc(F_Anz,(Grnd_Tiles-Grnd_Felder)*(Grnd_walk_anz+Grnd_nowalk_anz));
  for t:=1 to Std_anz do
  Begin
   Inc(Palette_Anz);
   GetTile(t,t);
   Rects[t]:=@images^[t];
  End;
  Prep_Grnd(t);
  for t:=t to F_Anz do
  Begin
   Inc(Palette_Anz);{Inc(t);}
   GetTile(t+1,t+1-(Grnd_Tiles-Grnd_Felder));
   Rects[t]:=@images^[t];
  End;
 End;
End;

Procedure ReadTileInfo;
 var t:word;
     status:string;

 Begin
  Assign(F,Filename+'.inf');
  Reset(F);
  with TileInfo do
  begin
   Readln(F,F_anz);
   Readln(F,Sp_anz);
   Readln(F,Std_Anz);
   Readln(F,Grnd_walk_anz);
   Readln(F,Grnd_nowalk_anz);
   Usedtiles:=Std_anz+Grnd_Felder*(Grnd_walk_anz+Grnd_nowalk_anz);
   for t:=1 to Std_Anz+Grnd_walk_anz do feld_stat[t]:=walk;
   for t:=Std_Anz+Grnd_walk_anz+1 to UsedTiles do feld_stat[t]:=nowalk;
   for t:=usedtiles+1 to F_anz do
   begin
    readln(F,Status);
                     if status='walk'        then feld_stat[t]:=walk
                     else if status='nowalk' then feld_stat[t]:=nowalk;

   end;
  end;
  Close(F);

 End;

Procedure MakeTileInfo;
var select:Char;
 Procedure WriteTileInfo;
 var t:word;
 Begin
  Assign(F,Filename+'.inf');
  Rewrite(F);
  with TileInfo do
  begin
   Writeln(F,F_anz);
   Writeln(F,Sp_anz);
   Writeln(F,Std_Anz);
   Writeln(F,Grnd_walk_anz);
   Writeln(F,Grnd_nowalk_anz);
   for t:=usedTiles+1 to F_anz do
   case feld_stat[t] of
{    standard:writeln(F,'standard');}
    walk:writeln(F,'walk');
    nowalk:writeln(F,'nowalk');
   end;
  end;
  Write(F,'Made by Konrad Hoeffners Levelmaker');
  Close(F);
 End;
 Procedure InPutStatus;
 var t:word;s:String;Feld_Gr:boolean;
 Begin
  for t:=UsedTiles+1 to TileInfo.F_anz do
  with TileInfo do
  Begin
   Feld_Gr:=false;
   Write('Nr. ',t,' ');
   repeat
    select:=readkey;
    case select of
{     '1':Begin feld_stat[nr]:=standard;write('"standard"');End;}
     '1':Begin feld_stat[t]:=walk;s:='"walk"';End;
     '2':Begin feld_stat[t]:=nowalk;s:='"nowalk"';End;
    end;
    if not Feld_Gr then write(':',s);
   until select in['1'..'5'];
   writeln;
  End;
 end;

 Procedure Neu_Anlegen;
 var t,Anz:byte;
     select:char;
 Begin
  Write('Anz der Tiles (max. 240, ohne Sprites): ');readln(tileinfo.F_anz);
  Write('Anz der Sprites: ');readln(tileinfo.Sp_anz);
  Writeln('Status der Tiles: ');
  Write('Anzahl der Standardfelder: ');readln(TileInfo.Std_Anz);
  Write('Anzahl der begehbaren Untergr걆de    (',Grnd_Felder,' Bilder/Untergrund): ');readln(TileInfo.Grnd_walk_Anz);
  Write('Anzahl der unbegehbaren Untergr걆de: (...) ');readln(TileInfo.Grnd_nowalk_Anz);
  with TileInfo do Usedtiles:=Std_anz+Grnd_Felder*(Grnd_walk_anz+Grnd_nowalk_anz);
{  for t:=1 to TileInfo.Std_Anz do TileInfo.feld_stat[t]:=walk;}
  Writeln('1. Begehbares Feld');
  Writeln('2. Unbegehbares Feld');
  InPutstatus;

  Write('Eingabe beendet. Datei wird gespeichert. Enter dr갷ken...');
  WriteTileInfo;
  writekar;
{  writesprites;}
  Readln;
 End;

 Procedure ReadOutTileInfo;
 var t:word;
     b:byte;
 Begin
  b:=0;
  with tileinfo do
  begin
   writeln(F_anz,' Felder');
   for t:=1 to F_anz do
   begin
    inc(b);
    case feld_stat[t] of
       walk:write(t:2,'.: walk  ');
     nowalk:write(t:2,'.: nowalk');
    end;
    if b mod 4=0 then writeln else write('      ');
   end;
  end;
  writeln;
 End;

{ Procedure Erweitern;
 var t:word;
 Begin
  ReadTileInfo;
  ReadOutTileInfo;
  writeln('Hinzuf갾en von Feldern:');
  Writeln('Status der Tiles: ');}
{  Writeln('1. Standarduntergrund');}
{  Writeln('1. begehbares Feld');
  Writeln('2. unbegehbares Feld');
  Writeln('3. Sprite');
  repeat
   Writeln('Weiter (j/n)?');
   repeat taste:=readkey; until taste in['j','n'];
   if taste='j' then
   begin
    Inc(TileInfo.F_anz);
    InPutstatus(TileInfo.F_anz);
   end;
  until Taste='n';
  writeln('Eingabe beendet. 럑derungen speichern (j/n)?');
  repeat taste:=readkey; until taste in['j','n'];
  if taste='j' then
  begin
   WriteTileInfo;
   writeln('럑derungen wurden gespeichert.');
  end;
  write('Enter dr갷ken...');
  readln;
 End;}
Begin
 writeln('MakeFileInfo:');
 writeln('컴컴컴컴컴컴컴컴컴컴컴컴컴컴�');
 writeln;
 write('Name der Datei (ohne Endung): ');readln(Filename);
 if not Fileexist(Filename+'.pcx') then
  begin
   writeln('Zugeh봱ige Tiledatei nicht gefunden. Enter dr갷ken...');
   readln;
  end else
  begin
   if fileexist(Filename+'.inf') then
   begin
    writeln('Fileinformationsdatei existiert bereits. Bitte w꼑len:');
    writeln('1. Neu anlegen');
{    writeln('2. Bestehende Datei erweitern');}
    writeln('3. Abbrechen');
    write('> ');Select:=readkey;writeln;
    case Select of
     '1':Neu_Anlegen;
{     '2':Erweitern;}
    end;
   end else Neu_Anlegen;
  end;
End;


Procedure NewMapFile;
const RStartX=238;
var t:word;
    vmaus:record {"VirtualMaus" - Koordinaten im Tileset rechts}
                 x,y:Integer;
                end;
    weiter_y,zeilen{von 0!}:byte;
    current_side,current_tile:byte;
 Procedure PaintLeftGrid;
 var x,y:word;
 Begin
  for x:=0 to 14 do line(screen2^,x*17,0,x*17,11*17,255);
  for y:=0 to 11 do line(screen2^,0,y*17,17*14,y*17,255);
 End;

 Procedure PaintRightGrid;
 var x,y:word;

 Begin
  zeilen:=(Palette_Anz+3{TileInfo.F_anz+3}) div 4;
  weiter_y:=(zeilen+2)*17;
  for x:=0 to 4 do line(screen2^,x*17+RStartX+13,0,x*17+RStartX+13,17*zeilen,255);
  for y:=0 to zeilen{5} do line(screen2^,RStartX+13,17*y,RStartX+13+17*4,17*y,255);
  line(screen2^,RStartX+13,weiter_y-17,RStartX+13+17,weiter_y-17,255);
  line(screen2^,RStartX+13,weiter_y,RStartX+13+17,weiter_y,255);
  line(screen2^,RStartX+13,weiter_y-17,RStartX+13,weiter_y,255);
  line(screen2^,RStartX+13+17,weiter_y-17,RStartX+13+17,weiter_y,255);

 End;

 Procedure PaintTiles;
 var x,y:word;
     rect_nr:byte;
 Begin
  rect_nr:=0;
  if Palette_Anz>4 then
  Begin
  for y:=0 to (Palette_Anz div 4)-1 do
   for x:=0 to 3 do
   Begin
    inc(rect_nr);
    MyPutRect(Rects[rect_nr],RStartX+13+1+x*17,y*17+1,screen2^);
   End;
  if Palette_Anz mod 4<>0 then
   for x:=0 to (Palette_Anz mod 4)-1 do
   begin
    inc(Rect_Nr);
    MyPutRect(Rects[rect_nr],RStartX+13+1+x*17,(Palette_Anz div 4)*17+1,screen2^);
   end;
  End else
  if Palette_Anz<>0 then
   for x:=0 to Palette_Anz-1 do
   Begin
    inc(Rect_Nr);
    MyPutRect(Rects[rect_nr],RStartX+13+1+x*17,1,screen2^);
   End;
 End;

 Procedure PaintEnv;
 var x,y:word;
     sicht_ende:TPos;
 Begin
  Sicht_Ende.X:=Map_Pos.X+13;
  If Sicht_Ende.x>felder_x-1 then Sicht_Ende.x:=felder_x-1;
  Sicht_Ende.Y:=Map_Pos.Y+10;
  If Sicht_Ende.y>felder_y-1 then Sicht_Ende.x:=felder_y-1;
  for x:=Map_Pos.X to Sicht_Ende.X do
   for y:= Map_Pos.Y to Sicht_Ende.Y do
   if map^[y,x]<>0 then
    MyPutRect(rects[map^[y,x]],17*(X-Map_Pos.X)+1,17*(y-Map_Pos.Y)+1,screen1^);
 End;
 Procedure ShowScreen;
 var y:word;
    xs,ys:string;
 Begin
  for y:=0 to 199 do
  begin
  end;
  MoveLongint(screen2^,screen1^,16000);
  PaintEnv;
  Putsprite(Pfeil,Maus.x,Maus.y,Screen1^);
  str(Map_Pos.X,xs);str(Map_Pos.Y,Ys);
{'('+xs+','+ys+')'}
{  Outtext(1,240,10,'A',screen);}
 Outtextxy2(1,1,'('+xs+','+ys+')',255,screen1^);
  waitretrace;
  MoveLongint(screen1^,screen,16000);
 End;
 Procedure Take_Tile(nr:byte);
 Begin
  Current_Tile:=Nr;
  MyPutRect(Rects[current_tile],RStartX+13+1,weiter_y-17+1,screen2^);
 End;

 Procedure Grab_Tile;
 var grabbed:boolean;
     Maus_nr:byte;{Nummer des K꼜tchens an der Mauspos.}
{current_tile}
 Begin
{$R-}
  if VMaus.X in[0..17*4-2] then
   if VMaus.Y in[0..(zeilen+1)*17] {$R+}
   then
   Begin
    Maus_nr:=(VMaus.Y div 17)*4+(VMaus.X) div 17+1;
    if Maus_nr<=Palette_Anz then
    Begin
     Take_Tile(Maus_Nr);
    End;
   End else grabbed:=False;
 End;
 Procedure Put_Tile;
 Begin
  if (Maus.X in[1..17*14-2]) and (Maus.y in[1..17*11-2]) then
  Begin
   Map^[(Maus.Y-1) div 17+map_pos.y,(Maus.X-1) div 17+map_pos.x]:=Current_Tile;
  End;
 End;
 Procedure InitMapScreen;
 Begin
  Init13h;
  setpal;
  PaintLeftGrid;
  PaintRightGrid;
  PaintTiles;
 End;


 Procedure LoadMap(filename:string);
 var f:file;
     x,y:word;
 Begin
  Assign(F,filename+'.Map');
  Reset(F,1);
{x/y}
  Blockread(F,x,2);Blockread(F,y,2);
  blockread(F,Map^,Sizeof(TMap));
  Close(F);
  writekar;
  End;
 Procedure LoadMapWizard;
 Begin
  Textmode(3);
  repeat
   Write('Dateiname: ');readln(MapFileName);
   if not fileexist(MapFileName+'.Map') then writeln('Datei nicht gefunden.');
  until (Fileexist(MapFileName+'.Map')) or (MapFileName='');
  if MapFileName<>'' then LoadMap(MapFileName);
  Write('Enter zum fortfahren...');readln;
  InitMapScreen;
 End;

 Procedure SaveMap;
 var f:file;
     x,y:word;
 Begin
  Assign(F,MapFileName+'.map');
  Rewrite(F,1);
  x:=Felder_x;
  y:=Felder_y;
  Blockwrite(F,x,2);Blockwrite(F,y,2);
  blockwrite(F,Map^,Sizeof(TMap));
  Close(F);
 End;
 Procedure SaveMapWizard;
 Begin
  Textmode(3);
  Write('Dateiname: ');readln(MapFileName);
  if Fileexist(MapFileName+'.map') then
  Begin
   Writeln('Datei bereits vorhanden. 쉇erschreiben (j/n)? ');
   repeat taste:=Upcase(readkey) until taste in['J','N'];
   if taste='J' then
   Begin
    SaveMap;
    writeln('Karte gespeichert unter <',MapFileName,'.map>.');
   End;
  End else
  Begin
   SaveMap;
   writeln('Karte gespeichert unter <',MapFileName,'.map>.');
  End;
  Write('Enter zum fortfahren...');readln;
  InitMapScreen;
 End;

 Procedure Tools;
 var select:byte;
    Procedure FillRestSingle;
    var x,y:word;
    Begin
     write('Tile-Nr.: ');readln(select);
      for x:=0 to Felder_x-1 do  for y:=0 to Felder_y-1 do
        if Map^[y,x]=0 then  Map^[y,x]:=select;
    End;
  Procedure FillMapSingle;
  var x,y:word;
  Begin
   write('Tile-Nr.: ');readln(select);
   for x:=0 to Felder_x-1 do for y:=0 to Felder_y-1 do
     Map^[y,x]:=select;
  End;
 Begin
  textmode(3);
  writeln('Kartentools');
  writeln('컴컴컴컴컴컴');
  writeln('1. Karte mit einzelnem Feld f걄len');
  writeln('2. Leerstellen mit einzelnem Feld f걄len');
  taste:=readkey;
  writeln;
  case taste of
   '1':FillMapSingle;
   '2':FillRestSingle;
  end;
  InitMapScreen;
 End;

 Procedure Vorschau;
 var x,y:word;
     restx,resty:shortint;
     gerade_x,gerade_y,unten_gerade_x,unten_gerade_y:byte;
     Oben_Links,Unten_Rechts:TPos;
    OldMaus:TPos;

{     Echt_Sicht:TPos;}
 Begin
{  filllongint(screen,16000,0);}
  restx:=0;
  resty:=0;
  Oben_Links.X:=16-RestX;
  Oben_Links.Y:=16-RestY;
  Unten_Rechts.X:=Oben_Links.X+18*16;
  Unten_Rechts.Y:=Oben_Links.Y+10*16;
  repeat
  filllongint(screen1^,16000,0);
{Innenbereich zeichnen}
  for x:=Map_Pos.X+1 to Map_Pos.X+19-1 do
   for y:=Map_Pos.Y+1 to Map_Pos.Y+11-1 do
   if Map^[y,x]<>0 then
    MyPutrect(Rects[Map^[y,x]],(x-Map_Pos.X)*16-restX,(y-Map_Pos.y)*16-restY,screen1^);
{Obere Zeile zeichnen}
{if}
  for x:=Map_Pos.X+1 to Map_Pos.X+19-1 do
{  if Map^[y,x]<>0 then
   MyPutrect(Rects[Map^[y,x]],-restX,(y-Map_Pos.y)*16-restY,screen1^);}
{}
   OldMaus.x:=Maus.x;
   OldMaus.y:=Maus.y;
   maus_abfrage;
   maus.x:=maus.x shr 1;
   if maus.taste<>0 then
   begin
    inc(restx,Maus.X-OldMaus.X);
    inc(resty,Maus.Y-OldMaus.Y);
   end;
    if maus.x<5 then dec(restx,2);
    if maus.y<5 then dec(resty,2);
    if maus.x>315 then inc(restx,2);
    if maus.y>195 then inc(resty,2);

    if (Map_Pos.X=0) and (RestX<0) then RestX:=0;
    if (Map_Pos.Y=0) and (RestY<0) then RestY:=0;
   if restx>=16 then
   begin
    restx:=0;
{    if Map_Pos<Felder_X}inc(Map_Pos.X);
   end;
   if restx<=-16 then
   begin
    restx:=0;
    if Map_Pos.X>0 then dec(Map_Pos.X);
   end;
   if resty>=16 then
   begin
    resty:=0;
    inc(Map_Pos.Y);
   end;
   if resty<=-16 then
   begin
    resty:=0;
    if Map_Pos.Y>0 then dec(Map_Pos.Y);
   end;
   PutSprite(Pfeil,Maus.x,Maus.y,screen1^);
   waitretrace;
   movelongint(screen1^,screen,16000);

  until keypressed;
  InitMapScreen;
 End;

 Procedure Map_InPut;
 Begin
  if keypressed then
  begin
   taste:=readkey;
   case taste of
    '1'..'9':Take_Tile(Ord(taste)-Ord('1')+1);
    TLeft: If Map_Pos.X>0         then dec(Map_pos.x);
    TRight:If Map_Pos.X+14<Felder_X-1 then inc(Map_pos.x);
    TUp:   If Map_Pos.y>0           then dec(Map_pos.y);
    TDown: If Map_Pos.y+11<Felder_Y-1  then inc(Map_pos.y);
    'l':LoadMapWizard;
    's':SaveMapWizard;
    'v':Vorschau;
    't':Tools;
   end;
  end;
   Maus_Abfrage;Maus.x:=Maus.x shr 1;
  if maus.x=0 then inc(maus.x);
  if maus.y=0 then inc(maus.y);
  if maus.y>199-5 then maus.y:=199-5;
  if maus.x<RStartX then Current_Side:=1 else
  begin
   Current_Side:=2;
   VMaus.X:=Maus.X-RStartX-13-1;
   VMaus.Y:=Maus.Y-1;
  end;
  if maus.taste=1 then
  Case Current_Side of
   1:Put_Tile;
   2:Grab_Tile;
  End;
 End;


 Procedure Map_Init;
 var t,x,y:word;
     name:string;
     karte_pos:TPos;
 Begin
 { Write('Name der Tile-, Map- und Tileinfodatei: ');readln(name);}
  FileName:='Tiles1';
  ReadTileInfo;
  GetImage;
{  Palette[254*3]:=63;
  Palette[254*3+1]:=63;
  Palette[254*3+2]:=0;}
  Palette_Anz:=0;
  Prep_Images;
  For x:=0 to Felder_x-1 do for y:=0 to Felder_y-1 do
  map^[y,x]:=random(TileInfo.Std_Anz)+1;
  InitMapScreen;
  Take_Tile(1);
 End;

Begin
 Map_Init;
 repeat
   Map_InPut;
  ShowScreen;
 until taste=#27;
 TextMode(3);
{ readln;}
End;


Procedure Menu;
Const terminated:boolean=False;
{Var Select:char;}
begin
 repeat
  ClrScr;
  Writeln('1. Teildatei 봣fnen');
  Writeln('2. Tileinfo-Datei erstellen');
  Writeln('3. Kartendatei bearbeiten');
  Writeln('9. Ende');
  write('> ');Taste:=readkey;
  clrscr;
  case Taste of
   '1':ShowTileFile;
   '2':MakeTileInfo;
   '3':begin
   NewMapfile;
   end;
   else Terminated:=True;
  end;
 until Terminated;
End;

begin
 Init;
 Menu;
 Final;
end.