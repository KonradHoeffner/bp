{Versuch einer Bresenham-Linie}
{Counter: ca. 75000 Linien/s PII-266 bei Pascal-Linie
          ca. 136000 Linien/s bei Assembler-Linie !!}
uses konrad,_32bit,crt,_13h,dos;
const anz=60000;
var t:word;
    screen1:^tscreen;
   h,h2,m,m2,s,s2,hs,hs2:word;
   diff:real;

begin
 randomize;
 getmem(screen1,64000);
 filllongint(screen1^,16000,0);
 Init13h;
 gettime(h,m,s,hs);
 for t:=1 to anz do
  Line(seg(screen1^),160,100,random(320),random(200),random(256));
 gettime(h2,m2,s2,hs2);
 movelongint(screen1^,screen,16000);
 readkey;{}
 freemem(screen1,64000);
 Textmode(3);
  diff:=(h2-h)*3600+(m2-m)*60+(s2-s)+(hs2/100-hs/100);
  writeln('旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�');
  writeln('쿞tartzeit: ',h:2,':',m:2,':',s:2,':',hs:2,'           �');
  writeln('쿐ndzeit  : ',h2:2,':',m2:2,':',s2:2,':',hs2:2,'           �');
  writeln('�                                 �');
  writeln('쿣ergangene Zeit: ',diff:3:2,' Sekunden   �');
  writeln('�',anz:3,' Durchl꼞fe der Schleife      �');
  writeln('�',anz/diff:3:2,' Lines/Sekunde            �');
  writeln('읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�');
  readln;

end.