(* this unit is for                                     *)
(* - including the generated string pointers            *)
(* - including the sets of strings                      *)
(* - having startup code to call the code that          *)
(*   sets the pointers to the strings                   *)
unit test_auu;

interface

(* type definition used by the strings *)
type
  pString=^String;
  pString10=array[0..9] of pString;

(* generated include file has names of string pointers, *)
(* and a special identified used below as second        *)
(* parameter at the begin.                              *)

{$I TEST_P$$.002}
{$I TEST_A$$.002}

implementation

(* unit that has the language envirenment detection and *)
(* string pointer setup code                            *)
uses spr2_aus;

(* set of strings, wil special header that tells how    *)
(* many strings and of which language, the block        *)
(* identifier is also used below (first paramter)       *)

{$I TEST_P$$.001}
{$I TEST_A$$.001}

(* call the pointer setup code                          *)
begin
  SetLanguageStringPointers(@language_module1,Addr(language_start1));
  SetLanguageStringPointers(@language_module2,Addr(language_start2));
end.
