{Dateiendungen:
 - Tiledatei   :.pcx
 - Mapinfodatei:.inf
 - Mapdatei    :.map
 }
uses konrad,_13h,_32bit,crt,picture,sprites,MyRpg;
const maus_cursor:array[0..5*5-1] of byte =(1,1,1,0,0,
                                             1,1,0,0,0,
                                             1,0,1,0,0,
                                             0,0,0,1,0,
                                             0,0,0,0,1);
    maximages=240;
    felder_x=200{14};
    felder_y=200{11};
    Map_Pos:TPos=(x:0;y:0);
{Umgebungskonstanten z.B. f걊 Wasser zu Vermeidung von Quadraten}
    U_normal=1;{das normale (quadratische Feld)}
    U_einzel=2;{eine einzelnes Feld, wird an 4 Seiten von Rand begrenzt}
    U_LRO=3;{unten offen}
    U_LRU=4;{oben offen}
    U_LOU=5;{..}
    U_ROU=6;
    U_LR=7;
    U_L=8;
    U_R=9;
type TImages=array[1..maximages] of array[0..16*16-1] of byte;
     TMap=Array[0..felder_y-1,0..felder_x-1] of Byte; {0..y-1,0..x-1 !!}
var tileinfo:record
               anzahl_felder:byte;
               feld_status:array[1..240] of (standard,walk,nowalk,sprite);
              end;
    tilesize:word;
    screen1,screen2:^tscreen;
    images:^Timages;
{    Sprites}
    Rects:array[1..maximages] of tsprite;

    Rect_anzahl:word;
    Filename,MapFileName:String;
    F:Text;
    Map:^TMap;
    anz_standard:byte;

procedure Init;
var t:word;
begin
Maus_Init;
SetMaus(1,1);
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
Begin
 getmem(puffer,64000+768);
 loadpcx(Filename+'.pcx',puffer^);
 movelongint(puffer^,screen1^,16000);
 move(puffer^[64000],palette,768);
 freemem(puffer,64000+768);
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

 Procedure ReadTileInfo;
 var t:word;
     status:string;
 Begin
  Assign(F,Filename+'.inf');
  Reset(F);
  anz_standard:=0;
  with TileInfo do
  begin
   Readln(F,anzahl_felder);
   for t:=1 to anzahl_felder do
   begin
    readln(F,Status);
    if status='standard' then begin
                               feld_status[t]:=standard;
                               inc(anz_standard);
                              end
                     else if status='walk'   then feld_status[t]:=walk
                     else if status='nowalk' then feld_status[t]:=nowalk
                                             else feld_status[t]:=sprite;
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
   Writeln(F,anzahl_felder);
   for t:=1 to anzahl_felder do
   case feld_status[t] of
    standard:writeln(F,'standard');
    walk:writeln(F,'walk');
    nowalk:writeln(F,'nowalk');
    sprite:writeln(F,'sprite');
   end;
  end;
  Write(F,'Made by Konrad Hoeffners Levelmaker');
  Close(F);
 End;
 Procedure InputStatus(nr:word);
 Begin
  with TileInfo do
  Begin
   Write('Nr. ',nr,': ');
   repeat
    select:=readkey;
    case select of
{     '1':Begin Feld_Status[nr]:=standard;write('"standard"');End;}
     '1':Begin Feld_Status[nr]:=walk;write('"walk"');End;
     '2':Begin Feld_Status[nr]:=nowalk;write('"nowalk"');End;
     '3':Begin Feld_Status[nr]:=sprite;write('"sprite"');End;
    end;
   until select in['1'..'3'];
   writeln;
  End;
 end;

 Procedure Neu_Anlegen;
 var t,anzahl:byte;
     select:char;
 Begin
  Write('Anzahl der Tiles (max. 240): ');readln(tileinfo.anzahl_felder);
  Writeln('Status der Tiles: ');
  Write('Anzahl der Standardfelder: ');readln(anz_standard);
  for t:=1 to Anz_Standard do Tileinfo.Feld_Status[t]:=standard;
{  Writeln('1. Standarduntergrund (z.B Gras)');}
  Writeln('1. begehbares Feld');
  Writeln('2. unbegehbares Feld');
  Writeln('3. Sprite');
   for t:=Anz_Standard+1 to TileInfo.anzahl_felder do Inputstatus(t);
  Write('Eingabe beendet. Datei wird gespeichert. Enter dr갷ken...');
  WriteTileInfo;
  Readln;
 End;

 Procedure ReadOutTileInfo;
 var t:word;
     b:byte;
 Begin
  b:=0;
  with tileinfo do
  begin
   writeln(anzahl_felder,' Felder');
   for t:=1 to anzahl_felder do
   begin
    inc(b);
    case feld_status[t] of
   standard:write(t:2,'.: standard  ');
       walk:write(t:2,'.: walk  ');
     nowalk:write(t:2,'.: nowalk');
     sprite:write(t:2,'.: sprite');
    end;
    if b mod 4=0 then writeln else write('      ');
   end;
  end;
  writeln;
 End;

 Procedure Erweitern;
 var t:word;
 Begin
  ReadTileInfo;
  ReadOutTileInfo;
  writeln('Hinzuf갾en von Feldern:');
  Writeln('Status der Tiles: ');
{  Writeln('1. Standarduntergrund');}
  Writeln('1. begehbares Feld');
  Writeln('2. unbegehbares Feld');
  Writeln('3. Sprite');
  repeat
   Writeln('Weiter (j/n)?');
   repeat taste:=readkey; until taste in['j','n'];
   if taste='j' then
   begin
    Inc(TileInfo.anzahl_felder);
    Inputstatus(TileInfo.anzahl_felder);
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
 End;
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
    writeln('2. Bestehende Datei erweitern');
    writeln('3. Abbrechen');
    write('> ');Select:=readkey;writeln;
    case Select of
     '1':Neu_Anlegen;
     '2':Erweitern;
    end;
   end else Neu_Anlegen;
  end;
End;


Procedure NewMapFile;
const RStartX=238;
var t:word;
    Pfeil:TSprite;{MausCursor}
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
  zeilen:=(rect_anzahl+3) div 4;
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
  if Rect_Anzahl>4 then
  Begin
  for y:=0 to (Rect_Anzahl div 4)-1 do
   for x:=0 to 3 do
   Begin
    inc(rect_nr);
    PutRect(Rects[rect_nr],RStartX+13+1+x*17,y*17+1,screen2^);
   End;
  if Rect_Anzahl mod 4<>0 then
   for x:=0 to (Rect_Anzahl mod 4)-1 do
   begin
    inc(Rect_Nr);
    PutRect(Rects[rect_nr],RStartX+13+1+x*17,(Rect_Anzahl div 4)*17+1,screen2^);
   end;
  End else
  if rect_anzahl<>0 then
   for x:=0 to Rect_Anzahl-1 do
   Begin
    inc(Rect_Nr);
    PutRect(Rects[rect_nr],RStartX+13+1+x*17,1,screen2^);
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
    PutRect(rects[map^[y,x]],17*(X-Map_Pos.X)+1,17*(y-Map_Pos.Y)+1,screen1^);
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
  Outtextxy2(1,1,'('+xs+','+ys+')',255,screen1^);
  waitretrace;
  MoveLongint(screen1^,screen,16000);
 End;
 Procedure Take_Tile(nr:byte);
 Begin
  Current_Tile:=Nr;
  PutRect(Rects[current_tile],RStartX+13+1,weiter_y-17+1,screen2^);
 End;

 Procedure Grab_Tile;
 var grabbed:boolean;
     Maus_nr:byte;{Nummer des K꼜tchens an der Mauspos.}
{current_tile}
 Begin
  if VMaus.X in[0..17*4-2] then
   if VMaus.Y in[0..(zeilen+1)*17]
   then
   Begin
    Maus_nr:=(VMaus.Y div 17)*4+(VMaus.X) div 17+1;
    if Maus_nr<=Rect_Anzahl then
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


 Procedure LoadMap;
 var f:file;
     x,y:word;
 Begin
  Assign(F,MapFileName+'.Map');
  Reset(F,1);
{x/y}
  Blockread(F,x,2);Blockread(F,y,2);
  blockread(F,Map^,Sizeof(TMap));
  Close(F);
  End;
 Procedure LoadMapWizard;
 Begin
  Textmode(3);
  repeat
   Write('Dateiname: ');readln(MapFileName);
   if not fileexist(MapFileName+'.Map') then writeln('Datei nicht gefunden.');
  until (Fileexist(MapFileName+'.Map')) or (MapFileName='');
  if MapFileName<>'' then LoadMap;
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
  if Fileexist(MapFileName) then
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
    OldMaus:TPos;

{     Echt_Sicht:TPos;}
 Begin
{  filllongint(screen,16000,0);}
  restx:=0;
  resty:=0;
  repeat
  filllongint(screen1^,16000,0);
  if restx=0 then gerade_x:=0 else gerade_x:=1;
  if resty=0 then gerade_y:=0 else gerade_y:=1;
  if restx>=0 then unten_gerade_x:=1 else unten_gerade_x:=0;
  if resty>=0 then unten_gerade_y:=1 else unten_gerade_y:=0;{}
  for x:=Map_Pos.x+gerade_x to Map_Pos.x+19-1+unten_gerade_x do
   for y:=Map_Pos.y+gerade_y to Map_Pos.y+11-1+unten_gerade_y do
   if Map^[y,x]<>0 then
    MyPutrect(Rects[Map^[y,x]].image,(x-Map_Pos.X)*16-restX,(y-Map_Pos.y)*16-restY,screen1^);

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

 Procedure Map_Input;
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
  Rect_Anzahl:=0;
  with TileInfo do
  for t:=1 to Anzahl_Felder do
  Begin
   if Feld_Status[t]<>sprite then
   Begin
    Inc(Rect_Anzahl);
    Rects[t].width:=16;
    Rects[t].height:=16;
    for y:=0 to 15 do
     movelongint(screen1^[y,(t-1)*16],images^[t][y*16],4);
    Rects[t].image:=@images^[t];
   End;
  End;
  For x:=0 to Felder_x-1 do for y:=0 to Felder_y-1 do
  map^[y,x]:=random(anz_standard)+1;
  InitMapScreen;
  Pfeil.Width:=5;
  Pfeil.Height:=5;
  Pfeil.Image:=@Maus_Cursor;
  for t:=0 to 5*5-1 do Maus_Cursor[t]:=Maus_Cursor[t] shl 7;
  Take_Tile(1);
 End;

Begin
 Map_Init;
 repeat
  Map_Input;
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
   '3':NewMapfile;
   else Terminated:=True;
  end;
 until Terminated;
End;

begin
 Init;
 Menu;
 Final;
end.