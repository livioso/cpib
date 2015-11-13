datatype term
  = RECORD
  | IDENT
  | LPAREN
  | COLON
  | RPAREN
  | TYPE
  | COMMA
  | CHANGEMODE

val string_of_term =
  fn RECORD    => "RECORD"
   | IDENT     => "IDENT"
   | LPAREN    => "LPAREN"
   | COLON     => "COLON"
   | RPAREN    => "RPAREN"
   | TYPE      => "TYPE"
   | COMMA     => "COMMA"
   | CHANGEMODE => "CHANGEMODE"

datatype nonterm
  = recordDeclaration
  | recordList
  | recordFields
  | recordField
  | optionalRecordFields
  | optionalCHANGEMODE

val string_of_nonterm =
  fn recordDeclaration    => "recordDeclaration"
   | recordList           => "recordList"
   | recordFields         => "recordFields"
   | recordField          => "recordField"
   | optionalRecordFields => "optionalRecordFields"
   | optionalCHANGEMODE   => "optionalCHANGEMODE"

val string_of_gramsym = (string_of_term, string_of_nonterm)

local
  open FixFoxi.FixFoxiCore
in

val productions =
[
(*
    recordDeclaration   ::= optionalCHANGEMODE IDENT COLON RECORD
    recordList          ::= LPAREN recordFields RPAREN
    recordFields        ::= recordField optionalRecordField
    recordField         ::= IDENT COLON TYPE
    optionalRecordField ::= COMMA recordField (optionalRecordField)*
    optionalCHANGEMODE  ::= CHANGEMODE*
*)
(recordDeclaration,
    [[N optionalCHANGEMODE, T IDENT, T COLON, T RECORD, N recordList]]),
(recordList,
    [[T LPAREN, N recordFields, T RPAREN]]),
(recordFields,
    [[N recordField, N optionalRecordFields]]),
(recordField,
    [[T IDENT, T COLON, T TYPE]]),
(optionalRecordFields,
    [[],
     [T COMMA, N recordField, N optionalRecordFields]]),
(optionalCHANGEMODE,
    [[],
     [T CHANGEMODE]])
]

val S = recordDeclaration

val result = fix_foxi productions S string_of_gramsym

end (* local *)
