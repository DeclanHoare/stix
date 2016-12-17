program six_def;

uses spr2_ein;

begin

  sprachtabellenkopf('EN'
                    +'DE'
                    +''
                    +'');

  sprach_eintrag04('Fehler_beim_Entpacken_',
                   'error unpacking (',
                   'Fehler beim Entpacken (',
                   '',
                   '');

  sprach_eintrag04('entpacker_fuer',
                   'decompressor for ',
                   'Entpacker fÅr ',
                   '',
                   '');

  sprach_eintrag04('benutzung',
                   'usage ',
                   'Benutzung ',
                   '',
                   '');

  sprach_eintrag04('Dateiname_Zielverzeichnis',
                   ' filemane Targetdirectory',
                   ' Dateiname Zielverzeichnis',
                   '',
                   '');

  sprach_eintrag04('Datei_nicht_gefunden',
                   'file not found !',
                   'Datei nicht gefunden !',
                   '',
                   '');

  sprach_eintrag04('kein',
                   'no "',
                   'kein "',
                   '',
                   '');

  sprach_eintrag04('gefunden',
                   '" found !',
                   '" gefunden !',
                   '',
                   '');

{
  sprach_eintrag04('Schreibfehler',
                   'write error',
                   'Schreibfehler',
                   '',
                   '');}

  sprach_eintrag04('stError',
                   'Access error',
                   'Zugriffsfehler',
                   '',
                   '');

  sprach_eintrag04('stInitError',
                   'Cannot initialize stream',
                   'Einrichtungsfehler',
                   '',
                   '');

  sprach_eintrag04('stReadError',
                   'Read beyond end of stream',
                   'öber das Stromende hinaus gelesen',
                   '',
                   '');

  sprach_eintrag04('stWriteError',
                   'Cannot expand stream',
                   'Kann Strom nicht vergrî·ern (Schreibfehler)',
                   '',
                   '');

  sprach_eintrag04('stGetError',
                   'Get of unregistered object type',
                   'Get of unregistered object type',{?}
                   '',
                   '');

  sprach_eintrag04('stPutError',
                   'Put of unregistered object type',
                   'Put of unregistered object type',{?}
                   '',
                   '');

  {
  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');}

  schreibe_sprach_datei('stix$$$.001','stix$$$.002','sprach_modul','sprach_start','^string');
end.
