uses konrad,umap,crt;
const name='landscap.map';
var t,x,y:word;
    rix,riy:boolean;
begin
 init13h;
 readmap(name);
 x:=20;
 y:=30;
 rix:=true;
 riy:=true;
 setmaus(x,y);
 repeat
{ maus_abfrage;
 x:=maus.x shr 1;
 y:=maus.y;}
  if rix then if x<100 then inc(x)
                      else rix:=false
        else if x>1
                      then dec(x)
                      else rix:=true;

  if riy then if y<199 then inc(y)
                      else riy:=false
        else if y>0   then dec(y)
                      else riy:=true;

  drawmap_xy(x,y);
  waitretrace;
 until keypressed;

end.