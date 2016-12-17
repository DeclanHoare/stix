uses suchedat,dos;

const
  suchfolge='.EXE';

var
  name:string;
  fund:longint;

begin
  name:=getenv('COMSPEC');
  writeln('"',name,'"/"',suchfolge,'" ... ');
  fund:=0;

  repeat
    fund:=suche_zeichenkette_in_datei(name,fund,suchfolge);
    if fund=nicht_gefunden then break;
    write('<',fund:13,'> ');
    inc(fund,length(suchfolge));
  until false;

end.