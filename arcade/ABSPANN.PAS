unit abspann;
interface
{-----Prozeduren-----}
 Procedure A_Abspann;
{--------------------}
implementation
uses _32bit,vars,_13h,crt,pcx,konrad;
const col=255;
 Procedure A_Abspann;
 var text:string;
 Begin
  asm
   mov ax,13h
   int 10h
  end;
  str(level,text);
  text:='GAME OVER  -  YOU DIED IN LEVEL '+text;
  filllongint(screen1^,16000,0);
  loadpcx(imgpath+img_a_1,screen1^,palette);
  setpal;
  outtextxy2(15,100,text,col,screen1^);
  movelongint(screen1^,mem[$a000:0],16000);
  readkey;
 End;
end.