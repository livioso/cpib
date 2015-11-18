datatype term
  = ADDOPR
  | IDENT
  | LPAREN
  | MULTOPR
  | RPAREN

val string_of_term =
  fn ADDOPR  => "ADDOPR"
   | IDENT   => "IDENT"
   | LPAREN  => "LPAREN"
   | MULTOPR => "MULTOPR"
   | RPAREN  => "RPAREN"

datatype nonterm
  = expr
  | repADDOPRterm3
  | term3
  | repMULTOPRfactor
  | factor

val string_of_nonterm =
  fn expr             => "expr"
   | repADDOPRterm3   => "repADDOPRterm3"
   | term3            => "term3"
   | repMULTOPRfactor => "repMULTOPRfactor"
   | factor           => "factor"

val string_of_gramsym = (string_of_term, string_of_nonterm)

local
  open FixFoxi.FixFoxiCore
in

val productions =
[
(*
    expr   ::= term3 (ADDOPR term3)*
    term3  ::= factor (MULTOPR factor)*
    factor ::= IDENT
            |  LPAREN expr RPAREN
*)
(expr,
    [[N term3, N repADDOPRterm3]]),
(repADDOPRterm3,
    [[T ADDOPR, N term3, N repADDOPRterm3],
     []]),
(term3,
    [[N factor, N repMULTOPRfactor]]),
(repMULTOPRfactor,
    [[T MULTOPR, N factor, N repMULTOPRfactor],
     []]),
(factor,
    [[T IDENT],
     [T LPAREN, N expr, T RPAREN]])
]

val S = expr

val result = fix_foxi productions S string_of_gramsym

end (* local *)
