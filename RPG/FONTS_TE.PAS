uses konrad,sprites,crt,_32bit,_13h;
const font_width=8;
      font_height=8;
      chars:array[ord('A')..ord('C')] of array[0..font_width*font_height-1] of byte=
     ((0,0,0,0,0,0,0,0,
       0,0,0,1,1,0,0,0,
       0,0,1,0,0,1,0,0,
       0,0,1,0,0,1,0,0,
       0,0,1,1,1,1,0,0,
       0,0,1,0,0,1,0,0,
       0,0,1,0,0,1,0,0,
       0,0,0,0,0,0,0,0),

      (0,0,0,0,0,0,0,0,
       0,0,1,1,1,0,0,0,
       0,0,1,0,0,1,0,0,
       0,0,1,1,1,0,0,0,
       0,0,1,0,0,1,0,0,
       0,0,1,0,0,1,0,0,
       0,0,1,1,1,0,0,0,
       0,0,0,0,0,0,0,0),

      (0,0,0,0,0,0,0,0,
       0,0,0,1,1,1,0,0,
       0,0,1,0,0,0,0,0,
       0,0,1,0,0,0,0,0,
       0,0,1,0,0,0,0,0,
       0,0,1,0,0,0,0,0,
       0,0,0,1,1,1,0,0,
       0,0,0,0,0,0,0,0));

var buchstaben:array[ord('A')..ord('C')]  of tsprite;
    cursor:record
            x,y:word;
           end;

Procedure MyWrite(S:String);
var t:byte;
procedure MYwrite2(ch:char);
var x,y:word;
begin
{ Putsprite(buchstaben[ord(ch)],cursor.x,cursor.y,screen);}
 for x:=0 to font_width-1 do
  for y:=0 to cursor.y+font_height-1 do
   put13h(screen,x+cursor.x,y+cursor.y,chars[Ord(ch)][y*font_width+x]);
 inc(cursor.x,buchstaben[ord('A')].width);
end;
Begin
 for t:=1 to length(s) do
 begin
{  waitretrace;}
  MYwrite2(Upcase(s[t]));
{  delay(20);}
 end;
 for t:=1 to 40-length(s) do write(' ');
 cursor.x:=0;
 inc(cursor.y,8);
{ writeln;}
{ textbackground(15);}

End;

procedure Init;
var t:word;
begin
 cursor.x:=0;
 cursor.y:=0;
 for t:=Ord('A') to Ord('C') do
 begin
  buchstaben[t].width:=8;
  buchstaben[t].height:=8;
  buchstaben[t].image:=@chars[t];
 end;
end;
begin
 Init;
 Init13h;
 MyWrite('bcaaaaaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbb');
 readkey;
end.