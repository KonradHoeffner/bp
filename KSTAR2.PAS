Uses Crt,graph,modexlib;
const maxran=30;
Var Sterne:Array[0..1000] of Record
                              x,y,Ebene:integer;
                            End;


   p,p1:pointer;
   e:array[0..319] of word;
   st_nr,i,t,t2,c:Word;
   b:boolean;




    procedure sinkurv;
    var x,v,r:word;
    begin
         v:=0;
         r:=0;
         for x:=0 to getmaxx do
         begin
              inc(v);
              if v=361 then v:=0;
              e[x]:=round(getmaxy div 2+(sin(v*pi/180)*30))+r;
              r:=r+random(1);
              if r>maxran then r:=r-2;
         end;
    end;



Begin
  sterne[1].x:=installuserdriver('svga386',nil);
  sterne[1].y:=0;
  initgraph(sterne[1].x,sterne[1].y,'c:\bp\bgi');
    Randomize;                    {Zufallszahlen initialisieren}
    sinkurv;

  for i:=1 to 255 do setrgbpalette(i,i,i,i);
  b:=true;
  c:=0;
  Repeat                        {pro Bildaufbau einmal ausgefÅhrt}

    if b=true then inc(t2);
    if b=false then dec(t2);

{    if t2>200 then b:=false;
    if t2<5 then b:=true;}
    for i:=1 to 255 do setrgbpalette(i,i,i,i);
    if 255-t2<1-t2 then b:=not(b);
    For St_nr:=0 to 1000 do Begin{fÅr jeden Stern neue Posit. berechnen}
      With Sterne[st_nr] do Begin
{       PutPixel(x,y+e[x]-90,0);        {alten Punkt lîschen}

        if y+e[x]-90 < 0 then putpixel(x,getmaxy-abs(y+e[x]-90),0) else
        begin
         if y+e[x]-90 > getmaxy then putpixel(x,y+e[x]-90-getmaxy,0) else
         putpixel(x,y+e[x]-90,0);
        end;
        Dec(x,Ebene shr 5 + 1); {weiterbewegen}
        if x <= 0 Then Begin    {links raus ?}
          x:=319;               {dann neu initialisieren}
          y:=Random(200);
          Ebene:=Random(256);
        End;
{        if e[t]-123 >0 then inc(y,(e[t]-123) div 2);{}
        if c>319 then c:=c-320;
        if y+e[x]-90 < 0 then putpixel(x,getmaxy-abs(y+e[x]-90),Ebene) else
        begin
         if y+e[x]-90 > getmaxy then putpixel(x,y+e[x]-90-getmaxy,Ebene) else
         putpixel(x,y+e[x]-90,Ebene);
        end;
       {PutPixel(x,y+e[x]-90,Ebene);  {neuen Punkt setzen}

      End;
    End;
    inc(c);


  inc(t);
  if t>319 then t:=0;


{  waitretrace;{}
  Until KeyPressed;             {Lauf, bis Taste gedrÅckt}

  TextMode(3);
End.
