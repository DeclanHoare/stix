program test_aus;
(*$D TEST_AUS * Test Sprachmodul * V.K. *)

uses
  test_auu,
  spr2_aus;
  
var  
  i: Word;

begin
  (* simple translation *)
  WriteLn('Buch=', textz_buch^);
  WriteLn('Rechner=', textz_rechner^);
  
  (* StrF will return a string from integer, 
     StrFormat2 will do a string replacment for %1 and %2 *)
  WriteLn(StrFormat2(textz_format_test_2p2gp1_3m3gp2^, StrF(2+2), StrF(3*3)));
  
  (* use translated array of string pointers *)
  for i:=0 to 9 do
    WriteLn(i:3,'  ',digits[i]^);
  
  (* a string that has non-ASCII chars *)
  WriteLn(textz_non_ascii^);
  WriteLn(textz_greetings^);
end.
