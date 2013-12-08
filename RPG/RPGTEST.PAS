uses konrad,sprites,crt,_32bit,_13h,picture;
const
 path='';
 Bild_Start='start.pcx';

 Text_Vorspann1='Vorsp1.txt';
var

Procedure Init;
Begin
 Randomize;
End;

Procedure MyWrite(S:String;color:byte);
var t:byte;
procedure MYwrite2(ch:char);
begin
 Putsprite(buchstaben[ord(ch)],cursor.x,cursor.y,screen);
 inc(cusor.x,8);
end;
Begin
 textcolor(color);
 for t:=1 to length(s) do
 begin
  waitretrace;
  MYwrite2(s[t]);
  delay(20);
 end;
 for t:=1 to 40-length(s) do write(' ');
 cursor.x:=0;
 inc(cursor.y,8);
{ writeln;}
{ textbackground(15);}

End;

Procedure ReadTextFile(Filename:String);
var f:Text;
    s:string;
    farbe,count:byte;
    Code:Integer;
Begin
 count:=1;
 clrscr;
 filllongint(screen,16000,0);
 assign(f,Filename);
 Reset(F);
 while not eof(f) do
 begin
  readln(F,S);
  If pos('&',S)=0 then
  begin
   inc(count);
   MyWrite(S,1{Farbe});
   if count>21 then begin readkey;count:=1;end;
  end else
  begin
   move(s[2],s[1],length(S)-1);
   val(S,Farbe,Code);
  end;
 end;
 Close(F);
end;

Procedure Vorspann;
Var Puffer:^TPuffer;
    Palette1:TPalette;
Begin
 palette[1*3]:=0;
 palette[1*3+1]:=20;
 palette[1*3+2]:=20;
 setpal;
 ReadTextFile(text_vorspann1);
End;

begin
 Init;
 Vorspann;
end.