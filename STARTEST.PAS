uses crt,graph,modexlib,ktools;
const maxran=30;
      getmaxx=319;
      getmaxy=199;
var sterne:array[0..1000] of record
                              x,y,ebene:integer;
                            end;


   p,p1:pointer;
   e,e2:array[0..319] of word;
   st_nr,i,t,t2,c:Word;
   b:boolean;

procedure putpixel(x,y:word;farbe:byte);assembler;
asm
 mov ax,0a000h
 mov es,ax
 xor di,di
 mov ax,320
 mul y
 add ax,x
 mov es:[di],al
end;

procedure setpal;assembler;
asm
 push si
 mov si,offset palette
 mov cx,256*3
 xor al,al
 mov dx,03c8h
 out dx,al
 inc dx
 rep outsb
 pop si
end;


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

    procedure sinkurv2;
    var x,v,r:word;
    begin
         v:=0;
         r:=0;
         for x:=0 to getmaxx do
         begin
              inc(v);
              if v=361 then v:=0;
              e2[x]:=round(getmaxy div 2+(sin(v*pi/180)*30));
         end;
    end;



begin
{  sterne[1].x:=installuserdriver('svga386',nil);
  sterne[1].y:=0;
  initgraph(sterne[1].x,sterne[1].y,'c:\bp\bgi');}
   asm
   mov ax,13h
   int 10h
   end;
    randomize;                    {Zufallszahlen initialisieren}
    sinkurv;
    sinkurv2;

  for i:=1 to 255 do fillchar(palette[i*3],3,i shr 2);
  setpal;
  b:=true;
  c:=0;
  repeat                        {pro bildaufbau einmal ausgefhrt}

    if b=true then inc(t2);
    if b=false then dec(t2);

{    if t2>200 then b:=false;
    if t2<5 then b:=true;}
{    for i:=1 to 255 do setrgbpalette(i,i,i,i);}
    if 255-t2<1-t2 then b:=not(b);
    For st_nr:=0 to 1000 do begin{fr jeden stern neue posit. berechnen}
      with sterne[st_nr] do begin
{       putpixel(x,y+e[x]-90,0);{}

        if y+e[x]-90 < 0 then putpixel(x,getmaxy-abs(y+e[x]-90),0) else
        begin
         if y+e[x]-90 > getmaxy then putpixel(x,y+e[x]-90-getmaxy,0) else
         putpixel(x,y+e[x]-90,0);
        end;
        dec(x,ebene shr 5 + 1); {weiterbewegen}
        if x <= 0 then begin    {links raus ?}
          x:=319;               {dann neu initialisieren}
          y:=random(200);
          ebene:=random(256);
        end;
        {inc(y,e2[t]);{}
        if y>getmaxy then dec(y,getmaxy);
        if c>319 then c:=c-320;
        if y+e[x]-90 < 0 then putpixel(x,getmaxy-abs(y+e[x]-90),ebene) else
        begin
         if y+e[x]-90 > getmaxy then putpixel(x,y+e[x]-90-getmaxy,ebene) else
         putpixel(x,y+e[x]-90,ebene);
        end;
       {putpixel(x,y+e[x]-90,ebene);{}

      end;
    end;
    inc(c);


  inc(t);
  if t>319 then t:=0;


  waitretrace;{}
  until keypressed;

  textmode(3);
end.
