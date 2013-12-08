uses uspace,crt;


begin
 asm
  mov ax,13h
  int 10h
 end;
 fillchar(palette,768,0);
 for t:=1 to 32 do palette[t*3]:=t*2;
 for t:=33 to 65 do palette[t*3+1]:=(t-32)*2;
 for t:=66 to 98 do palette[t*3+2]:=(t-64)*2;
 for t:=99 to 131 do fillchar(palette[t*3],3,(t-96)*2);

 for t:=132 to 163 do palette[t*3]:=(t-131)*2;
 for t:=132 to 163  do palette[t*3+1]:=(t-131)*2;

 for t:=164 to 196 do palette[t*3]:=(t-164)*2;
 for t:=164 to 196 do palette[t*3+2]:=(t-164)*2;

 for t:=197 to 229 do palette[(t)*3+1]:=(t-196)*2;
 for t:=197  to 229  do palette[(t)*3+2]:=(t-196)*2;

 palette[255*3+0]:=63;
 palette[255*3+1]:=63;
 palette[255*3+2]:=63;
 setpal;
 for t:=0 to 199 do
 begin
  fillchar(bild^[t,0],20,round(t/199*32));
  fillchar(bild^[t,20],20,round(t/199*32+32));
  fillchar(bild^[t,40],20,round(t/199*32+64));
  fillchar(bild^[t,60],20,round(t/199*32+96));

  fillchar(bild^[t,80],20,round(t/199*32+131));
  fillchar(bild^[t,100],20,round(t/199*32+163));
  fillchar(bild^[t,120],20,round(t/199*32+196));
 end;
 readkey;
 textmode(3);
end.