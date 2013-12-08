uses crt,konrad,picture,_32bit;
const bild='grau128.pcx';
      maxx=120;
      maxy=115;
      krumm=0.04; {Entfernungsverkleinerung}
      hoehe=3;
var t,u,v,w,x,y,pos:word;
    i:integer;
    b:byte;
    s:string;
    frame,frame2:^tscreen;
    rx,ry,pers:real;

procedure init;
begin
 getmem(frame,64000);
 getmem(frame2,64000);
 asm
  mov ax,13h
  int 10h
 end;
 loadpcx(bild,frame^);
 for t:=1 to 256 do fillchar(palette[t*3+1],3,t shr 2);
 setpal;
end;

begin
 pos:=maxx;
 init;
 repeat
  filllongint(frame2^,16000,0);
  for t:=1 to maxx do for u:=1 to pos do
  begin
  pers:=1+krumm*(maxx/u);
  rx:=t*320/maxx/pers;
  ry:=u*200/pos-frame^[u,t] shr hoehe;
  x:=trunc(rx);
  y:=trunc(ry);
  frame2^[y,x]:=frame^[u,t];
  end;
  waitretrace;
  movelongint(frame2^,screen,16000);
 if keypressed then taste:=readkey {else taste:='n'};
 case taste of
  #80:if pos<maxx then inc(pos);
  #72:if pos>2 then dec(pos);
 end;

 until taste=#27;
 freemem(frame,64000);
 freemem(frame2,64000);
end.