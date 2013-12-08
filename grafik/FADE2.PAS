uses konrad,_32bit,_13h,crt,picture,graphic;
const {path='c:\eigene~1\bp\space\';
      testbild='space.pcx';}
      path='c:\eigene~1\bp\grafik\';
      testbild='test.pcx';
var puffer:^tpuffer;
    s:string;
    bild1,bild2:^screen_type;
    t:word;
    zielpal:tpalette;
{}


procedure fade_in(anz:word);
var t,w:word;
begin

 for t:=1 to anz do
 begin
  {for w:=0 to 768 do palette[w]:=trunc((t*zielpal[w]) div anz);}
  for w:=0 to 768 do{ palette[w]:=round(zielpal[w]*t/anz);}

  if palette[w]<zielpal[w] then inc(palette[w]);
  waitretrace;
  waitretrace;
  setpal;
 end;
end;
{}
begin
 init13h;
 fillchar(palette,768,0);
 setpal;
 for t:=1 to 100 do fillchar(screen[t,0],320,t div 2);
 for t:=101 to 199 do fillchar(screen[t,0],320,(200-t) div 2);
 for t:=1 to 63 do zielpal[t*3]:=t;
 for t:=64 to 127 do zielpal[t*3+2]:=t-64;
 for t:=128 to 191 do zielpal[t*3+1]:=t-128;
 s:='Konrad H”ffner''s Fade';
 outtextxy2(30,102,s,80,screen);
 outtextxy2(30,101,s,95,screen);
 outtextxy2(30,100,s,127,screen);
 s:='---------------------';
 outtextxy2(30,111,s,150,screen);
 outtextxy2(30,110,s,170,screen);
 outtextxy2(30,109,s,191,screen);
 fade_in(90);
 readkey;
end.