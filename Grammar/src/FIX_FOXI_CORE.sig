(* ------------------------------------------------------------------------- *)
(* --- Copyright (c) 1998 by Edgar F. A. Lederer --------------------------- *)
(* ------------------------------------------------------------------------- *)

signature FIX_FOXI_CORE =
  sig
    datatype ('term, 'nonterm) grammar_symbol =
        T of 'term
      | N of 'nonterm

    type ('term, 'nonterm) productions =
      ('nonterm * ('term, 'nonterm) grammar_symbol list list) list

    datatype 'a terminal_or_end =
        U of 'a
      | $

    type ('term, 'nonterm) parse_tab_mult_entries =
      ('nonterm
       * ('term terminal_or_end
          * ('term, 'nonterm) grammar_symbol list list) list) list

    type 'nonterm warnings1 =
      {empty_RHSs    : 'nonterm list,
       multiples_LHS : 'nonterm list,
       unproductives : 'nonterm list}

    type ('term, 'nonterm) warnings2 =
      {unreachables    : 'nonterm list,
       grammar_not_LL1 : ('term, 'nonterm) parse_tab_mult_entries}

    type ('term, 'nonterm) analysis =
      {terms    : 'term list,
       nonterms : 'nonterm list,
       prods    : ('term, 'nonterm) productions,
       S        : 'nonterm,
       NULLABLE : ('nonterm * bool) list,
       FIRST    : ('nonterm * 'term list) list,
       FOLLOW   : ('nonterm * 'term terminal_or_end list) list,
       MM       : ('term, 'nonterm) parse_tab_mult_entries}

    datatype ('a,'b) parse_tree =
        TL of 'a                             (* terminal leaf   *)
      | PN of 'b * ('a,'b) parse_tree list   (* production node *)

    type term_leaf_location = int * (int * int)
    type prod_node_location = ((int * int) * (int * int)) option

    type ('token, 'nonterm) parser =
      string * ('token * term_leaf_location) list
      -> ('token * term_leaf_location,
           'nonterm * prod_node_location) parse_tree

    type ('term, 'nonterm) string_of_gramsym =
      ('term -> string) * ('nonterm -> string)

    type ('term, 'attrib, 'nonterm) fix_foxi'result =
      'nonterm warnings1
      * (('term, 'nonterm) warnings2
         * ('term, 'nonterm) analysis
         * ('term * 'attrib, 'nonterm) parser) option
      * ('term, 'nonterm) string_of_gramsym

    val fix_foxi'core :
      (''term, ''nonterm) productions
      -> ''nonterm
       -> (''term, ''nonterm) string_of_gramsym
        -> (''term, 'attrib, ''nonterm) fix_foxi'result

    exception SyntaxError'_terminal_terminal_mismatch
    and       SyntaxError'_nonterminal_terminal_mismatch
  end

(* ------------------------------------------------------------------------- *)
