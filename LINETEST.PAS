uses konrad,_13h,crt,_32bit;
const test:byte=200;
var x,y,t:word;
    screen1:^tscreen;
begin
 randomize;
 init13h;
{ for t:=1 to 50 do line(screen,random(320),random(200),random(320),random(200),random(255));}
 getmem(screen1,64000);
 filllongint(screen1^,16000,0);
repeat
 for x:=0 div test to 319 div test  do line(screen1^,160,100,x*test,0,15);
 for x:=0 div test to 319 div test  do line(screen1^,160,100,x*test,199,15);
 for y:=0 div test to 199 div test  do line(screen1^,160,100,0,y*test,15);
 for y:=0 div test to 199 div test  do line(screen1^,160,100,319,y*test,15);
 waitretrace;
 movelongint(screen1^,screen,16000);
 filllongint(screen1^,16000,0);
 if test>1 then dec(test);
until keypressed;


 readkey;
 freemem(screen1,64000);
end.