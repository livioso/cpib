datatype term
  = RECORD
  | IDENT
  | LPAREN
  | COLON
  | RPAREN
  | TYPE
  | COMMA

val string_of_term =
  fn RECORD     => "RECORD"
   | IDENT      => "IDENT"
   | LPAREN     => "LPAREN"
   | COLON      => "COLON"
   | RPAREN     => "RPAREN"
   | TYPE       => "TYPE"
   | COMMA      => "COMMA"

datatype nonterm
  = recordDeclaration
  | recordFieldList
  | recordFields
  | recordField
  | optionalRecordFields

val string_of_nonterm =
  fn recordDeclaration    => "recordDeclaration"
   | recordFieldList      => "recordFieldList"
   | recordFields         => "recordFields"
   | recordField          => "recordField"
   | optionalRecordFields => "optionalRecordFields"

val string_of_gramsym = (string_of_term, string_of_nonterm)

local
  open FixFoxi.FixFoxiCore
in

val productions =
[
(*
    optRecordDeclaration ::= LPAREN recordDecl RPAREN | Eps $
    recordDecl               ::= storageDeclaration repRecordFields $
    repRecordFields          ::= COMMA storageDeclaration repRecordFields | Eps $
    optionalCHANGEMODE       ::= CHANGEMODE | Eps $
    storageDeclaration       ::= optionalCHANGEMOD typeIdent $
    typeIdent                ::= IDENT COLON typeDeclaration $
    typeDeclaration          ::= TYPE optRecordDeclarationList $
    optionalCHANGEMODE       ::= CHANGEMODE | Eps $
    DOTOPRfactor             ::= DOTOPR IDENT | Eps $
*)
(recordDeclaration,
    [[T IDENT, T COLON, T RECORD, N recordFieldList]]),
(recordFieldList,
    [[T LPAREN, N recordFields, T RPAREN]]),
(recordFields,
    [[N recordField, N optionalRecordFields]]),
(recordField,
    [[T IDENT, T COLON, T TYPE]]),
(optionalRecordFields,
    [[],
     [T COMMA, N recordField, N optionalRecordFields]])
]

val S = recordDeclaration

val result = fix_foxi productions S string_of_gramsym

end (* local *)
