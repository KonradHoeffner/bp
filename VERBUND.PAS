uses konrad,crt;
const sizey=20;
      sizex=20;
      tileanz=3;
      tiles:array[1..tileanz,0..1] of byte =((1,2),(2,2),(2,3));

var feld:array[0..sizey,0..sizex] of byte;


begin
 fillchar(feld,sizeof(feld),0);

end.