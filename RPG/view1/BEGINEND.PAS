unit beginend;
interface
{------Prozeduren------}
 Procedure BE_Init;
 Procedure BE_Final;
{-----------------------}
implementation
uses vars,konrad,crt;
{------Prozeduren------}
{----------------------}
Procedure LoadMap;
var f:file;
    x,y:word;
Begin
 Assign(F,mapname+'.Map');
 Reset(F,1);
 Blockread(F,x,2);Blockread(F,y,2);
 blockread(F,Map^,Sizeof(TMap));
 Close(F);
End;

Procedure LoadSprites;
var f:file;
Begin
 Assign(f,filename+'.spr');
 Reset(f,1);
 blockread(f,sp_anz,2);
 blockread(f,sp^[1],sp_anz*16*16);
 Close(f);
End;

Procedure LoadKar;
var f:file;x,y:integer;
Begin
 assign(f,filename+'.kar');
 reset(f,1);
 blockread(f,x,2);
 blockread(f,y,2);
 blockread(f,feld_stat,sizeof(tfeld_stat));
 blockread(f,images^,16*16*maximages);
 close(f);
End;

Procedure Cursor_Init;
Begin
 Pfeil.Width:=5;
 Pfeil.Height:=5;
 Pfeil.Image:=@Maus_Cursor;
 for t:=0 to 5*5-1 do Maus_Cursor[t]:=Maus_Cursor[t]*255;
End;

Procedure BE_Init;
begin
 asm
  mov ax,13h
  int 10h
 end;
 LoadPal(filename+'.pal');
 setpal;
 Maus_Init;
 Cursor_Init;
 Getmem(screen1,64000);
 Fillchar(screen1^,64000,0);
 getmem(Map,Sizeof(TMap));
 fillchar(Map^,Sizeof(TMap),0);
 getmem(Images,Sizeof(TImages));
 Getmem(sp,16*16*maxsprites);
 LoadKar;
 LoadMap;
 LoadSprites;
End;

Procedure BE_Final;
Begin
 Freemem(screen1,64000);
 Freemem(sp,16*16*maxsprites);
 freemem(Images,Sizeof(TImages));
 freemem(Map,Sizeof(TMap));
 asm
  mov ax,3
  int 10h
 end;
End;

end.