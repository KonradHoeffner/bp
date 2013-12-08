uses _13h,_32bit,konrad,crt;
const maxs=9;
var screen1:^tscreen;
    t:integer;
    df,sf:pointer;
Procedure Scroll_Up;assembler;
{scrollt das Bild um eine Zeile nach oben und interpoliert}
asm
  push ds
  les di,DF             {Zeiger auf Zielbild laden}
  lds si,SF              {Zeiger auf Quellbild}
  mov cx,320*198                 {99 Zeilen scrollen}
  xor bl,bl                     {wird als Dummy fÅr High-Byte benîtigt}
@lp1:
  xor ax,ax
  xor bx,bx
  mov al,[si]
  mov bl,[si+319]
  add ax,bx
  mov bl,[si+320]
  adc ax,bx
  mov bl,[si+321]
  adc ax,bx
  shr ax,2


  or ax,ax                      {bereits 0 ?}
  je @null
  dec al                        {wenn nein, dann verringern}
@null:
  stosb                         {Wert ins Ziel}
  inc si                        {nÑchsten Punkt}
  dec cx                        {weitere Punkte ?}
  jne @lp1
  pop ds
End;


Procedure Init;
Begin
 randomize;
{ Getmem(screen1,64000);
 fillchar(screen1,64000,0);}
 Init13h;
 for t:=0 to 127 do palette[t*3]:= t shr 1;
 for t:=0 to 127 do palette[(t+128)*3]:=(127-t) shr 1;
 setpal;
 screen1:=@screen;
 df:=screen1;
 sf:=screen1;
End;

Procedure Final;
Begin
{ Freemem(screen1,64000);}
 Textmode(3);
End;

Procedure Abfrage;
Begin
 if keypressed then
 begin
  taste:=readkey;
 end else taste:='n';
End;

procedure interpol(x1,y1,x2,y2:integer;step:byte{;ran:byte});
var mx,my:word;
begin
 mx:=(x2-x1) shr 1+x1;
 my:=(y2-y1) shr 1+y1;
 screen1^[my,mx]:=(screen1^[y2,x2]+screen1^[y1,x1])
 +(screen1^[y2,x1]+screen1^[y1,x2]) shr 2+random(step);
 screen1^[y1,mx]:=(screen1^[y1,x2]+screen1^[y1,x1]) shr 1+random(step);
 screen1^[y2,mx]:=(screen1^[y2,x2]+screen1^[y2,x1]) shr 1+random(step);
 screen1^[my,x2]:=(screen1^[y2,x2]+screen1^[y1,x2]) shr 1+random(step);
 screen1^[my,x1]:=(screen1^[y2,x1]+screen1^[y1,x1]) shr 1+random(step);
 inc(step);
 if step<maxs then
 begin
  interpol(x1,y1,mx,my,step);
  interpol(mx,y1,x2,my,step);
  interpol(x1,my,mx,y2,step);
  interpol(mx,my,x2,y2,step);
 end;
end;

Procedure Doit;
var x,y:integer;
Begin
 for x:=0 to 319 do for y:=0 to 199 do screen1^[y,x]:=random($ff);
 screen1^[0,0]:=random($ff);
 screen1^[199,0]:=random($ff);
 screen1^[0,319]:=random($ff);
 screen1^[199,319]:=random($ff);
 interpol(0,0,319,199,0);
 for t:=1 to 7 do scroll_up;
end;

Procedure Main;
Begin
 repeat
  abfrage;
{  waitretrace;
  movelongint(screen1^,screen,16000);}
  for t:=0 to 255 do inc(palette[t*3]);
  waitretrace;
  setpal;
 until taste=#27;
End;

begin
 Init;
 Doit;
 Main;
 Final;
end.