unit suchedat;

interface

const
  nicht_gefunden=-1;

function suche_zeichenkette_in_datei(dateiname:string;startposition:longint;suchfolge:string):longint;

implementation

function suche_zeichenkette_in_datei(dateiname:string;startposition:longint;suchfolge:string):longint;
  const
    blockgroesse=4*512;
  var
    datei:file;
    posi:longint;
    laenge:longint;
    (*$IFDEF OS2*)
    block:longint;
    (*$ELSE*)
    block:word;
    (*$ENDIF*)
    puffer:array[0..blockgroesse-1] of char;
    such,z:word;
    ungleich:boolean;
  begin
    suche_zeichenkette_in_datei:=nicht_gefunden;
    assign(datei,dateiname);
    filemode:=$40;
    (*$I-*)
    reset(datei,1);
    (*$I+*)
    if ioresult<>0 then exit;

    laenge:=filesize(datei);
    posi:=startposition;
    while posi+length(suchfolge)<=laenge do
      begin
        seek(datei,posi);
        if laenge-posi>blockgroesse then
          block:=blockgroesse
        else
          block:=laenge-posi;

        blockread(datei,puffer,block);
        for such:=0 to block-length(suchfolge) do
          if puffer[such]=suchfolge[1] then
            begin
              ungleich:=false;
              for z:=1 to length(suchfolge) do
                ungleich:=ungleich or (puffer[such+z-1]<>suchfolge[z]);
              if not ungleich then
                begin
                  close(datei);
                  suche_zeichenkette_in_datei:=posi+such;
                  exit;
                end;
            end;
        inc(posi,block-length(suchfolge)+1);
      end;

    close(datei);
  end;

end.

