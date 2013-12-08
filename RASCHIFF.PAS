uses crt,graph;

var a,b,c,d,e,f,i,h,j,farbe,farbe2,farbe3,farbe4,x,y : integer;
    q           : char;
    maus:record
         taste:byte;
         x,y:word;
         end;

function treffer(x1,x2,y1,y2:word):boolean;
begin
 if ((c<x2) and (c>x1)) and ((d<y2) and (d>y1)) then treffer:=true
                                        else treffer:=false;
end;

procedure init;assembler;
asm
 mov ax,0
 mov bx,0
 int 33h
end;

procedure abfrage;assembler;
asm
 mov ax,3
 int 33h
 mov maus.taste,bl
 mov maus.x,cx
 mov maus.y,dx
end;



procedure exp;
begin
    setcolor(white);
    circle(x,y,5);
    delay(100);
    setcolor(black);
    circle(x,y,5);

    setcolor(white);
    circle(x,y,8);
    delay(100);
    setcolor(black);
    circle(x,y,8);

    setcolor(lightgray);
    circle(x,y,11);
    delay(100);
    setcolor(black);
    circle(x,y,11);

    setcolor(darkgray);
    circle(x,y,14);
    delay(100);
    setcolor(black);
    circle(x,y,14);

    farbe:=black;
    farbe2:=black;
    farbe3:=black;
    farbe4:=black;

    x:=random(600)+1;
    y:=random(400)+1;

    repeat
    if x < 50 then x:=random(600)+1;
    until x > 49;
    repeat
    if y < 50 then y:=random(400)+1;
    until y > 49;
    Initgraph(a,b,'d:\');
    end;


procedure Schuss;
begin
 setcolor(green);
 line(c,d,c,d+10);line(c,d,c,d-10);line(c,d,c-10,d);line(c,d,c+10,d);
   delay(30);
 setcolor(black);circle(h,j,5);
 setcolor(black);
 line(c,d,c,d+10);line(c,d,c,d-10);
 line(c,d,c-10,d);line(c,d,c+10,d);
end;

procedure schiff;
begin
putpixel(x+2,y+2,farbe); putpixel(x+1,y+3,farbe); putpixel(x,y+3,farbe);
 putpixel(x-1,y+1,farbe); putpixel(x-1,y+2,farbe);
 putpixel(x,y+1,farbe3);
 putpixel(x,y+2,farbe4);
 putpixel(x+1,y+1,farbe3);
 putpixel(x+1,y+2,farbe4);

 putpixel(x+4,y,farbe);   putpixel(x+5,y,farbe);   putpixel(x+6,y+1,farbe);
 putpixel(x+6,y+2,farbe); putpixel(x+5,y+3,farbe); putpixel(x+4,y+3,farbe);
 putpixel(x+3,y+1,farbe); putpixel(x+3,y+2,farbe);
 putpixel(x+4,y+1,farbe3);
 putpixel(x+4,y+2,farbe4);
 putpixel(x+5,y+1,farbe3);
 putpixel(x+5,y+2,farbe4);

 putpixel(x-2,y+1,farbe2);putpixel(x-3,y+1,farbe2);putpixel(x-4,y+1,farbe2);
 putpixel(x-5,y+1,farbe2);putpixel(x-6,y+1,farbe2);putpixel(x-7,y+1,farbe2);

 putpixel(x+7,y+1,farbe2);putpixel(x+8,y+1,farbe2);putpixel(x+9,y+1,farbe2);
 putpixel(x+10,y+1,farbe2);putpixel(x+11,y+1,farbe2);putpixel(x+12,y+1,farbe2);

 putpixel(x,y-1,farbe2);putpixel(x-1,y-2,farbe2);putpixel(x-2,y-3,farbe2);

 putpixel(x+5,y-1,farbe2);putpixel(x+6,y-2,farbe2);putpixel(x+7,y-3,farbe2);
end;

begin
init;
a:=detect; b:=detect;
Initgraph(a,b,'c:\Bp\bgi');
c:=300; d:=200;
e:=300; f:=200;
h:=c; j:=d;

x:=200; y:=200;
 repeat

 farbe:=green;
 farbe2:=lightgray;
 farbe3:=lightgray;
 farbe4:=white;

 schiff;

  if c < h then h:=h-1;
  if c > h then h:=h+1;
  if d < j then j:=j-1;
  if d > j then j:=j+1;

 if e < 0 then e:=679;

 setcolor(green);
 line(c,d,c,d+10);line(c,d,c,d-10);
 line(c,d,c-10,d);line(c,d,c+10,d);


 if keypressed then q:=readkey;
 setcolor(green);
 circle(h,j,5);

  delay(30);

 farbe:=black;
 farbe2:=black;
 farbe3:=black;
 farbe4:=black;
 schiff;

 setcolor(black);
 circle(h,j,5);


 setcolor(black);
 line(c,d,c,d+10);line(c,d,c,d-10);
 line(c,d,c-10,d);line(c,d,c+10,d);


{  case q of
   #77 : c:= c + 2;
   #75 : c:= c - 2;
   #80 : d:= d + 2;
   #72 : d:= d - 2;
  end;}
  abfrage;
  c:=maus.x;
  d:=maus.y;
  if x>c then inc(x,2) else dec(x,2);
  if y>d then inc(y,2) else dec(y,2);
    if x>630 then x:=630;
    if y>470 then y:=470;


 if maus.taste = 1 then
  begin
   setcolor(red);
   line(0,479,c,d); line(639,479,c,d);
   schuss;
   setcolor(black);
   line(0,479,c,d); line(639,479,c,d);
   q:='0';

   if treffer(x-7,x+14,y-4,y+4) then exp;

end;

 until maus.taste = 3;
end.