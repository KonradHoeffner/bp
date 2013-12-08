uses _13h,crt,konrad,_32bit,picture;
var u:word;
    f:^screen_type;
    p:^p_type;
    d:shortint;
begin
 init13h;
 getmem(p,64767);
 getmem(f,64000);
 loadpcx('c:\eigene~1\bp\space\space.pcx',p^);
 move(p^,f^,64000);
 move(p^[64000],palette,768);
 setpal;
 repeat
 for u:=0 to 199 do texline(319,u+d,0,u,f^[u,0]);
 inc(d);
 until keypressed;
 freemem(p,64767);
 freemem(f,64000);

end.