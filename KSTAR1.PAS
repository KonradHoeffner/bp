Uses Crt,graph,modexlib;
Var Sterne:Array[0..1000] of Record
                              x,y,Ebene:Integer;
                            End;
  i:integer;
   t:word;
   e:array[0..319] of word;
   st_nr:Word;



    procedure sinkurv;
    var x,v:word;
    begin
         v:=0;
         for x:=0 to getmaxx do
         begin
              inc(v);
              if v=361 then v:=0;
              e[x]:=round(getmaxy div 2+(sin(v*pi/180)*30));

         end;
    end;

function a(x:word):word;
begin
if (x<50) or (x>255) then a:=255;
end;


Begin
  sterne[1].x:=installuserdriver('svga386',nil);
  sterne[1].y:=0;
  initgraph(sterne[1].x,sterne[1].y,'c:\bp\bgi');
    sinkurv;

  for i:=1 to 255 do setrgbpalette(i,i,i,i);
  Randomize;                    {Zufallszahlen initialisieren}

  Repeat                        {pro Bildaufbau einmal ausgefÅhrt}
    For St_nr:=0 to 1000 do Begin{fÅr jeden Stern neue Posit. berechnen}
      With Sterne[st_nr] do Begin
        PutPixel(x,y,0);        {alten Punkt lîschen}
        Dec(x,Ebene shr 5 + 1); {weiterbewegen}
        if x <= 0 Then Begin    {links raus ?}
          x:=319;               {dann neu initialisieren}
          y:=Random(200);
          Ebene:=Random(256);
        End;
        PutPixel(x,y,Ebene);  {neuen Punkt setzen}
      End;
    End;
  inc(t);
  if t>319 then t:=0;
  putpixel(t,e[t],{a(t)}t);
  putpixel(t-70,e[t-70],0);
  waitretrace;
  Until KeyPressed;             {Lauf, bis Taste gedrÅckt}
  TextMode(3);
End.
