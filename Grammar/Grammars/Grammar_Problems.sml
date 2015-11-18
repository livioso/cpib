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
  | term3
  | factor

val string_of_nonterm =
  fn expr   => "expr"
   | term3  => "term3"
   | factor => "factor"

val string_of_gramsym = (string_of_term, string_of_nonterm)

local
  open FixFoxi.FixFoxiCore
in

val productions =
[
(*
    expr   ::= term3
            |  expr ADDOPR term3
    term3  ::= factor
            |  factor MULTOPR term3
    factor ::= IDENT
            |  LPAREN expr RPAREN
*)
(expr,
    [[N term3],
     [N expr, T ADDOPR, N term3]]),
(term3,
    [[N factor],
     [N factor, T MULTOPR, N term3]]),
(factor,
    [[T IDENT],
     [T LPAREN, N expr, T RPAREN]])
]

val S = expr

val result = fix_foxi productions S string_of_gramsym

end (* local *)
