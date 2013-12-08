type ttext=array[0..0] of byte;
var f:file;
    s,fn:string;
    text:^ttext;
    count:word;
    drin:boolean;

function such(s:string):boolean;
var i:integer;
    c:char;
begin
 such:=true;
 for i:=1 to length(s) do
 begin
  c:=char(text^[count-i+1]);
  if upcase(c)<>upcase(s[length(s)-i+1]) then begin such:=false; exit;  end;
 end;
end;

function lowercase(c:char):char;
var co:char;
begin
  if c in['A'..'Z'] then
  lowercase:=char(ord(c)+ord('a')-ord('A')) else lowercase:=c;
end;

begin
{ if paramcount=0 then begin writeln('no command line parameters!!'); halt; end;
 fn:=paramstr(1);}
 fn:='test.htm';
 assign(f,fn);
 reset(f);
 if filesize(f)>(65536-10) then begin writeln('max filesize 65,526 bytes !!');end;
 getmem(text,filesize(f)+10);
 blockread(f,text^,filesize(f));
 text^[filesize(f)+1]:=0;
 count:=0;
 drin:=false;
 while(count<(filesize(f)+1)) do
 begin
  if such('img src=') then drin:=true;
  if char(text^[count])='>'then drin:=false;
  if drin then
  begin
   text^[count+1]:=ord(lowercase(char(text^[count+1])));
  end;
  inc(count);
 end;
 close(f);
 assign(f,fn);
 rewrite(f);
 blockwrite(f,text^,sizeof(text));
 close(f);
end.