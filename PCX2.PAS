unit pcx2;

interface

procedure loadpcx(filename:string;var puffer;var palette:array of byte);

implementation
var pcxheader:
record
 manu,version:byte;
 encoded:boolean;
 bbp:byte;
 xmin,ymin,xmax,ymax:integer;
 hdpi,vdpi:integer;
 oldpal:array[1..48] of byte;
 reserved:byte;
 nplanes:byte;
 bytesperline:integer;
 paletteinfo:integer;
 hscreensize,vscreensize:integer;
 filler:array[1..54] of byte;
end;


procedure loadpcx(filename:string;var puffer;var palette:array of byte);
type tb=array[1..1] of byte;
var f:file;
    t,count,max:word;
    b,b2,anz:byte;
    p:^tb;
begin
 assign(f,filename);
 reset(f,1);
 blockread(f,pcxheader,128);
 with pcxheader do max:=(xmax-xmin+1)*(ymax-ymin+1)-1;
 count:=0;
 p:=@puffer;
 while count<=max do
 begin
  blockread(f,b,1);
  if (b and 192)=192 then
  begin
   blockread(f,b2,1);
   anz:=(b and 63);
   fillchar(p^,anz,b2);
   inc(count,anz);
   inc(p,anz);
  end else
  begin
   p^[1]:=b;
   inc(count);
   inc(p);
  end;
 end;
 blockread(f,palette,1);
 blockread(f,palette,768);
 for t:=0 to 767 do palette[t]:=palette[t] shr 2;
 close(f);
end;

end.