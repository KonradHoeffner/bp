uses crt;
const door=3;
      anz=100;

var doors:array[1..door] of boolean;
    t:word;
    b,b2,b3:byte;
    key,key2 :char;
    take:byte;
    percentage:byte;
    win,loose:byte;
    anzahl:word;

begin
 randomize;
 win:=0;
 loose:=0;
 anzahl:=0;
 repeat
 inc(anzahl);
 clrscr;
 for t:=1 to door do doors[t]:=false;
 b:=random(door)+1;

 doors[b]:=true;
 textcolor(yellow+blink);write(' Super Show');
 textcolor(lightgray);
 writeln(' by Simon and Konrad');
 writeln('컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�');
 writeln;
{ writeln('The car is in door ',b,'.');}
{ write('What door do you wanna take (1-',door,') ');
 readln(take);}
 take:=random(3)+1;
 repeat
 b2:=random(door)+1;
 until (b2<>take) and (doors[b2]=false);

 writeln('The car is not in door ',b2);
 writeln;
  writeln('You can choose a other door ! Do you want it ??? y/n');
   key2:={readkey}'Y';
    if upcase(key2)='Y' then
     begin
      writeln('You go to the new door !');
      b3:=0;
       repeat
        b3:=b3+1;
       until (b3 <> take) and (b3<>b2);
       writeln('The new door is ',b3);
     take:=b3;
    end;
 if doors[take]=true then
 begin
  writeln('You have won!!');
  inc(win);
 end else
 begin
  write('You have lost!!');
  inc(loose);
 end;
 writeln('The car is in door ',b,'.');
 until anzahl=anz;
 writeln;
 percentage:=100 * win div (win+loose);
 write('You have won ',percentage,'% of your games');
 readln;
end.