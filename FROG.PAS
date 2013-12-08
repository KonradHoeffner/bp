
program test;
uses crt,graph;
const f_anz=50;
var i:integer;

function betrag(x:integer):integer;
begin
betrag:=x;
if x<0 then betrag:=-x;
end;

procedure init;
var gd,gm:integer;
begin
 gd:=installuserdriver('svga386',nil);
 gm:=1;
 initgraph(gd,gm,'C:\bp\bgi');
 randomize;
end;

procedure intro;
var v1,v2,j:word;
begin
     v2:=80;
     inc(v2);
     line(0,0,getmaxx,0);
     line(getmaxx,0,getmaxx,getmaxy);
     line(getmaxx,getmaxy,0,getmaxy);
     line(0,0,0,getmaxy);

     for j:=0 to 255 do setrgbpalette(j,0,0,0);
     for i:=1 to getmaxx+150 do begin
         if keypressed then break;
         setcolor(i);
         if i mod 11=0 then  inc(v2);

         line(i,i,getmaxx-i,i);
         line(getmaxx-i,i,getmaxx-i,getmaxy-i);
         line(getmaxx-i,getmaxy-i,i,getmaxy-i);
         line(i,i,i,getmaxy-i);
         v1:=255;
         delay(5);
if i>63 then begin
         setrgbpalette(i-19,0,0,0);
         setrgbpalette(i-18,0,0,30);
         setrgbpalette(i-17,0,0,50);
         setrgbpalette(i-16,0,0,75);
         setrgbpalette(i-15,0,0,95);
         setrgbpalette(i-14,0,0,110);
         setrgbpalette(i-13,0,0,120);
         setrgbpalette(i-12,0,0,130);
         setrgbpalette(i-11,0,0,140);
         setrgbpalette(i-10,0,0,150);
         setrgbpalette(i-9,0,0,160);
         setrgbpalette(i-8,0,0,170);
         setrgbpalette(i-7,0,0,180);
         setrgbpalette(i-6,0,0,200);
         setrgbpalette(i-5,0,0,210);
         setrgbpalette(i-4,0,0,220);
         setrgbpalette(i-3,0,0,230);
         setrgbpalette(i-2,0,0,240);
         setrgbpalette(i-1,0,0,250);
         setrgbpalette(i+0,0,0,255);
         setrgbpalette(i+1,0,0,250);
         setrgbpalette(i+2,0,0,240);
         setrgbpalette(i+3,0,0,230);
         setrgbpalette(i+4,0,0,220);
         setrgbpalette(i+5,0,0,210);
         setrgbpalette(i+6,0,0,200);
         setrgbpalette(i+7,0,0,180);
         setrgbpalette(i+8,0,0,170);
         setrgbpalette(i+9,0,0,160);
         setrgbpalette(i+10,0,0,150);
         setrgbpalette(i+11,0,0,140);
         setrgbpalette(i+12,0,0,130);
         setrgbpalette(i+13,0,0,120);
         setrgbpalette(i+14,0,0,110);
         setrgbpalette(i+15,0,0,95);
         setrgbpalette(i+16,0,0,75);
         setrgbpalette(i+17,0,0,50);
         setrgbpalette(i+18,0,0,30);
         setrgbpalette(i+19,0,0,0);

         setrgbpalette(i-50-19,0,0,0);
         setrgbpalette(i-50-18,30,0,0);
         setrgbpalette(i-50-17,50,0,0);
         setrgbpalette(i-50-16,75,0,0);
         setrgbpalette(i-50-15,95,0,0);
         setrgbpalette(i-50-14,110,0,0);
         setrgbpalette(i-50-13,120,0,0);
         setrgbpalette(i-50-12,130,0,0);
         setrgbpalette(i-50-11,140,0,0);
         setrgbpalette(i-50-10,150,0,0);
         setrgbpalette(i-50-9,160,0,0);
         setrgbpalette(i-50-8,170,0,0);
         setrgbpalette(i-50-7,180,0,0);
         setrgbpalette(i-50-6,200,0,0);
         setrgbpalette(i-50-5,210,0,0);
         setrgbpalette(i-50-4,220,0,0);
         setrgbpalette(i-50-3,230,0,0);
         setrgbpalette(i-50-2,240,0,0);
         setrgbpalette(i-50-1,250,0,0);
         setrgbpalette(i+0-50,255,0,0);
         setrgbpalette(i+1-50,250,0,0);
         setrgbpalette(i+2-50,240,0,0);
         setrgbpalette(i+3-50,230,0,0);
         setrgbpalette(i+4-50,220,0,0);
         setrgbpalette(i+5-50,210,0,0);
         setrgbpalette(i+6-50,200,0,0);
         setrgbpalette(i+7-50,180,0,0);
         setrgbpalette(i+8-50,170,0,0);
         setrgbpalette(i+9-50,160,0,0);
         setrgbpalette(i+10-50,150,0,0);
         setrgbpalette(i+11-50,140,0,0);
         setrgbpalette(i+12-50,130,0,0);
         setrgbpalette(i+13-50,120,0,0);
         setrgbpalette(i+14-50,110,0,0);
         setrgbpalette(i+15-50,95,0,0);
         setrgbpalette(i+16-50,75,0,0);
         setrgbpalette(i+17-50,50,0,0);
         setrgbpalette(i+18-50,30,0,0);
         setrgbpalette(i+19-50,0,0,0);

                  end;

         end;
settextstyle(sansseriffont,0,10);
for j:=30 to 50 do
begin
setcolor(i-(j-50));
outtextxy(50+j,10+j,'Space-Frog');
end;
readkey;
setgraphmode(3);
setbkcolor(blue);
settextstyle(sansseriffont,horizdir,4);
setcolor(red);
outtextxy(0,0,'Space Frog ');
settextstyle(smallfont,horizdir,5);
setcolor(white);
outtextxy(0,100,'Betaversion 1.0  ');
outtextxy(0,134,'In diesem Spiel mÅssen alle Fliegen vom Frosch verspeist werden,');
outtextxy(0,150,'bevor er den Hungertod stirbt oder er von einem Gegner');
outtextxy(0,166,'vernichtet wird.');
outtextxy(0,192,'Spielsteuerung:  Cusortasten');
outtextxy(0,getmaxy-50,'ENTER drÅcken...');
readln;
end;

procedure start;

var p:pointer;
    taste:char;
    x,y,jump:word;
    b:boolean;
    fx:array[1..f_anz] of word;
    fy:array[1..f_anz] of word;
    f_live:array[1..f_anz] of boolean;
    allefliegentot:boolean;
    bl,br,punkte:integer;
    pk:string;

procedure weiter;
begin
setcolor(red);
settextstyle(triplexfont,0,6);
if punkte>-1000 then outtextxy(0,10,'Mission erfÅllt')
                else outtextxy(0,10,'Sie sind Verhungert !');
delay(2500);
halt;
end;

procedure froginit;
begin

 setcolor(green);
 setfillstyle(1,green);
 fillellipse(19,23,12,12);
 fillellipse(12,10,3,4);
 fillellipse(27,10,3,4);
 line(9,30,3,36);
 line(27,30,32,36);
 setcolor(red);
 line(12,27,25,29);
 setfillstyle(1,black);
 setcolor(blue);
 fillellipse(12,10,2,2);
 fillellipse(27,10,2,2);

 getmem(p,1600);
 getimage(0,0,39,39,p^);

end;

begin
 setgraphmode(3);
 froginit;
 x:=0;
 y:=0;
 jump:=0;
 bl:=0;
 br:=0;
 b:=true;
 punkte:=1000;
 for i:=1 to f_anz do f_live[i]:=true;
 for i:=1 to f_anz do fx[i]:=random(getmaxx);
 for i:=1 to f_anz do fy[i]:=random(getmaxy);
 settextstyle(defaultfont,0,1);
 repeat

  {                     FLIEGENsteuerung }


  allefliegentot:=true;
  for i:=1 to f_anz do if f_live[i]=true then allefliegentot:=false;
  if allefliegentot=true then weiter;

  for i:=1 to f_anz do if f_live[i]=true then
   begin
    putpixel(fx[i],fy[i],black);
    fx[i]:=fx[i]+random(7)-3;
    fy[i]:=fy[i]+random(7)-3;
    putpixel(fx[i],fy[i],white);
    if ((f_live[i]=true) and (betrag(x-fx[i])<50) and (betrag(y-fy[i])<50)) then
    begin
     setcolor(red);
     line(x+17,y+28,fx[i],fy[i]);
     delay(50);
     setcolor(black);
     line(x+17,y+28,fx[i],fy[i]);
     putpixel(fx[i],fy[i],black);
     f_live[i]:=false;
     punkte:=punkte+30;
     outtextxy(0,0,'Punkte:');
    end;
   end;





{       ENDE der FLIEGENsteuerung        }
  delay(5);
  if b=true then dec(punkte);
  str(punkte,pk);
  setcolor(black);
  outtextxy(64,0,'€€€€€€');
  setcolor(blue);
  outtextxy(64,0,pk);
  if punkte<-999 then weiter;
  if b=true then b:=false;
  if b=false then b:=true;

  if y<430 then inc(y);
  if jump>0 then dec(jump);
  if jump>0 then y:=y-3;
  if (bl>0) and (b=true)  then dec(bl);
  if (br>0) and (b=true) then dec(br);
  taste:='1';
  if keypressed then taste:=readkey;
  case taste of
   #75:bl:=27;
   #77:br:=27;
   #72:if y=430 then jump:=200;
{   ' ':feuer;}
  end;

  if ((br>0) and (b=true)) and (x<getmaxx-1) then x:=x+1;
  if ((bl>0) and (b=true)) and (x>0) then x:=x-1;


  putimage(x,y,p^,normalput);
 until taste=#27;
 freemem(p,1600);
end;

procedure mainprog;
begin
 init;
 {intro;}
 start;
 closegraph;
end;


begin
mainprog;
end.