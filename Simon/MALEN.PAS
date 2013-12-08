{Achtung!!! Man kann nicht alle Farben ausw„hlen!!!}
{MalProgramm - Simon Trmpler - 25.7.1999}
uses crt,konrad;

var t : integer;
    pal  : record
           x,y : integer;
           end;
    maus : record
           x,y   : integer;
           Taste : byte;
           Farbe : byte;
           FarbeDemo : byte;
           end;
procedure putpixel(x,y:word;col:byte);
begin
 screen[y,x]:=col;
end;
procedure Mouse;assembler;
 asm
  mov ax,3
  int 33h
  mov maus.x,cx
  mov maus.y,dx
  mov maus.taste,bl
 end;

procedure Pallette;
 begin
  for t:=1 to 255 do screen[pal.y,t]:=t;
  if t > 254 then inc(pal.y);
  if pal.y > 5 then pal.y:=0;

  for t:=1 to 10 do putpixel(t,199,Maus.Farbe div 2); {"Div 2" siehe "PrintMaus"}
  for t:=1 to 10 do putpixel(t+309,199,Maus.FarbeDemo div 2); {"Div 2" siehe "PrintMaus"}
  end;

procedure PrintMaus;
 begin
  mouse;
  putpixel(maus.x div 2,maus.y,15);
 end;

procedure MausTaste;
 begin
 {*******Fr die Demo Farbe******* }
   if (Maus.x>  0) and
       (Maus.x<256) and
       (Maus.y>  0) and
       (Maus.y<  5) then
        begin
         Maus.FarbeDemo:=Maus.x;
        end;
 {*********************************}
   
  if Maus.Taste = 1 then
   begin
    if (Maus.x>  0) and
       (Maus.x<256) and
       (Maus.y>  0) and
       (Maus.y<  5) then
        begin
         Maus.Farbe:=Maus.x;
        end;
   end;
 {Oben: Fr die FarbAuswahl********}
 end;

procedure Del;
 begin
  putpixel(maus.x div 2,maus.y,0);
 end;

procedure PaintPixel;
 begin
  if Maus.Taste = 1 then
   begin
    Putpixel(Maus.x div 2,Maus.y,Maus.Farbe div 2);
   end;
 end;

procedure init;
 begin
  Init13h;
  pal.y:=1;
 end;

begin
Init;
 repeat
  PrintMaus;
  MausTaste;
  Pallette;
  PaintPixel;
 { Del; }
 until keypressed;
end.