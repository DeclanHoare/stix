program test_ein;
(*$D TEST_EIN * Test Sprachmodul * V.K. *)

uses
  spr2_ein;

begin
  (* tells how many and which languages are used here:          *)
  (* ENglish and DEutsch. The 2 letter langauge combinations    *)
  (* should match the use of the LANG environment variable      *)

  LanguageTableHeader(
                     +'EN'
                     +'DE'
                     +''
                     +'');

  (* defines the strings:                                       *)
  (*   name (without the 'textz_' prefix),                      *)
  (*   value,                                                   *)
  (*   value..                                                  *)
  (* this function is used for 1..4 languages, there are others *)
  (* available for more                                         *)
  LanguageStringEntry04('programm',
                        'program',
                        'Programm',
                        '',
                        '');

  LanguageStringEntry04('buch',
                        'book',
                        'Buch',
                        '',
                        '');

  LanguageStringEntry04('rechner',
                        'calculator',
                        'Rechner',
                        '',
                        '');

  LanguageStringEntry04('format_test_2p2gp1_3m3gp2',
                        '2+2=%1 3*3=%2',
                        '2+2=%1 3*3=%2',
                        '',
                        '');

  LanguageStringEntry04('non_ascii',
                        'non-ASCII chars: ^+a=É, `+i=ç',
                        'Nicht-ASCII-Zeichen: ^+a=É, `+i=ç',
                        '',
                        '');

  LanguageStringEntry04('greetings',
                        'yours sincerely',
                        'mit feundlichen GrÅ·en',
                        '',
                        '');

  (* finally, this procedure outputs the include files                  *)
  (* first parameter: filename for the string include file              *)
  (* second parameter: filename for the string pointer include file     *)
  (* third parameter: identifier for the string block                   *)
  (* fourth parameter: identifier for the string pointer block          *)
  (* fifth parameter: type identifier used for for string pointers      *)
  WriteLanguageStringToFile('TEST_P$$.001','TEST_P$$.002','language_module1','language_start1','pString');





  (* another set of words. this time in an array. uses modified initialisation procedure *)
  LanguageTableHeaderExtended(
                     +'EN'
                     +'DE'
                     +''
                     +'',
                     true);

  LanguageStringEntry04('digits', (* this is the first entry in the array - new name.. *)
                        'Zero',
                        'Null',
                        '',
                        '');
  LanguageStringEntry04('', (* this is the second entry in the array - no new name.. *)
                        'One',
                        'Eins',
                        '',
                        '');
  LanguageStringEntry04('', (* this is the second entry in the array - no new name.. *)
                        'Two',
                        'Zwei',
                        '',
                        '');
  LanguageStringEntry04('', (* this is the second entry in the array - no new name.. *)
                        'Three',
                        'Drei',
                        '',
                        '');
  LanguageStringEntry04('', (* this is the second entry in the array - no new name.. *)
                        'Four',
                        'Vier',
                        '',
                        '');
  LanguageStringEntry04('', (* this is the second entry in the array - no new name.. *)
                        'Five',
                        'FÅnf',
                        '',
                        '');
  LanguageStringEntry04('', (* this is the second entry in the array - no new name.. *)
                        'Six',
                        'Sechs',
                        '',
                        '');
  LanguageStringEntry04('', (* this is the second entry in the array - no new name.. *)
                        'Seven',
                        'Sieben',
                        '',
                        '');
  LanguageStringEntry04('', (* this is the second entry in the array - no new name.. *)
                        'Eigth',
                        'Acht',
                        '',
                        '');
  LanguageStringEntry04('', (* this is the second entry in the array - no new name.. *)
                        'Nine',
                        'Neun',
                        '',
                        '');

  WriteLanguageStringToFile('TEST_A$$.001','TEST_A$$.002','language_module2','language_start2','pString10');
end.
