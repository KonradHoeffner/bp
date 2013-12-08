unit vars;
interface
uses konrad,sprites;
const
 maus_cursor:array[0..5*5-1] of byte = (1,1,1,0,0,
                                        1,1,0,0,0,
                                        1,0,1,0,0,
                                        0,0,0,1,0,
                                        0,0,0,0,1);


{---Paths---}
 path='c:\eigene~1\bp\rpg\view1\';
{-----------}
 felder_x=200{14};
 felder_y=200{11};
 maximages=240;
 maxsprites=100;
 filename='tiles1';
 mapname='test';
type TImage16=array[0..15,0..15] of byte;
     TImages=array[1..maximages] of TImage16;
     TMap=Array[0..felder_y-1,0..felder_x-1] of Byte; {0..y-1,0..x-1 !!}
     TFeld_Stat=(walk,nowalk,sprite);
     TSp=array[1..maxsprites] of TImage16;
var
 sp_anz:integer;
 feld_stat:array[1..240] of TFeld_Stat;
 screen1:^tscreen;
 t:integer;
 taste:char;
 Rects:array[1..maximages] of pointer;
 images:^Timages;
 Map:^TMap;
 vp:tpos;
 s:TPos;
{------Sprites-------}
 Pfeil:TSprite;{MausCursor}
 sp:^TSp;
implementation
end.