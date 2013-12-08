uses konrad,sprites,crt,_32bit,_13h,picture;
const
 path='';
 Bild_Start='start.pcx';

 Text_Vorspann1='Vorsp1.txt';
Procedure Init;
Begin
 Randomize;
End;

Procedure MyWrite(S:String;color:byte);
var t:byte;
Begin
 textcolor(color);
 for t:=1 to length(s) do
 begin
  waitretrace;
  write(s[t]);
  delay(20);
 end;
 for t:=1 to 40-length(s) do write(' ');
 writeln;
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
 Init13h;
 directvideo:=false;
 Filllongint(screen,16000,0);
 fillchar(palette,768,0);
 setpal;
 getmem(Puffer,64000);
 LoadPcx(Bild_Start,Puffer^);
 movelongint(Puffer^,screen,16000);
 move(Puffer^[64000],Palette1,768);
 for t:=0 to 767 do palette1[t]:=palette1[t] and $3F;
 Fade_In(Palette1,200);
 Fade_Out(200);
 freemem(Puffer,64000);
 waitretrace;
 filllongint(screen,16000,0);
 textcolor(15);
 palette[15*3]:=63;
 setpal;
 write('.');SinCosInit;delay(300);write('.');Randomize;delay(300);write('.');
{ for t:=1 to 6 do
 begin
  delay(300);
  palette[15*3]:=not palette[15*3];
  setpal;
 end;}
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