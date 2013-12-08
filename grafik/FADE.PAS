uses picture,_32bit,_13h,crt,konrad;
const {path='c:\eigene~1\bp\space\';
      testbild='space.pcx';}
      path='c:\eigene~1\bp\grafik\';
      testbild='test.pcx';
var puffer:^tpuffer;
    f:file;
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
    waitretrace;
    setpal;
  for w:=0 to 767 do
   palette[w]:=round(zielpal[w]{/anz*t}*sin((t-1.2)/anz*90*pi/180));
{   palette[w]:=round(zielpal[w]/anz*t);}
{  if palette[w]<zielpal[w] then inc(palette[w]);{}

 end;
end;
{}
procedure fade_out(anz:word);
var t,w:word;
begin
   for t:=anz downto 1 do
 begin
  {for w:=0 to 768 do palette[w]:=trunc((t*zielpal[w]) div anz);}
    waitretrace;
    setpal;
  for w:=0 to 767 do
   palette[w]:=round(zielpal[w]{/anz*t}*sin((t-1.2)/anz*90*pi/180));
{   palette[w]:=round(zielpal[w]/anz*t);}
{  if palette[w]<zielpal[w] then inc(palette[w]);{}

 end;
  fillchar(palette,768,0);
  setpal;
end;

procedure load;
begin
 assign(f,'test.pic');
 reset(f,64000);
 blockread(f,screen,1);
 close(f);
end;

procedure save;
begin
 assign(f,'test.pic');
 rewrite(f,64000);
 blockwrite(f,screen,1);
 close(f);
end;

begin
 getmem(puffer,64768);
 init13h;
 fillchar(palette,768,0);
 setpal;
 loadpcx(path+testbild,puffer^);
 movelongint(puffer^,screen,16000);
 move(puffer^[64000],ZIELPAL,768);
 for t:=0 to 767 do zielpal[t]:=zielpal[t] and (1+2+4+8+16+32);
 delay(400);
 fade_in(150);
 fade_out(150);

 readkey;
end.