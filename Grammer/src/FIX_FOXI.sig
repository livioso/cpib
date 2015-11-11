(* ------------------------------------------------------------------------- *)
(* --- Copyright (c) 1998 by Edgar F. A. Lederer --------------------------- *)
(* ------------------------------------------------------------------------- *)

signature FIX_FOXI =
  sig
    structure FixFoxiCore : FIX_FOXI_CORE

    exception GrammarError'_empty_language
    and       GrammarError'_unexpected_warnings

    type ('term, 'attrib, 'nonterm) ff'result =
      ('term, 'attrib, 'nonterm) FixFoxiCore.fix_foxi'result

    val dispDiagnosis : ('term, 'attrib, 'nonterm) ff'result -> unit

    val dispTerms    : ('term, 'attrib, 'nonterm) ff'result -> unit
    val dispNonterms : ('term, 'attrib, 'nonterm) ff'result -> unit
    val dispProds    : ('term, 'attrib, 'nonterm) ff'result -> unit
    val dispS        : ('term, 'attrib, 'nonterm) ff'result -> unit
    val dispNULLABLE : ('term, 'attrib, 'nonterm) ff'result -> unit
    val dispFIRST    : ('term, 'attrib, 'nonterm) ff'result -> unit
    val dispFOLLOW   : ('term, 'attrib, 'nonterm) ff'result -> unit
    val dispMM       : ('term, 'attrib, 'nonterm) ff'result -> unit

    val ? : unit -> unit

    val extractParser :
      (''term, 'attrib, ''nonterm) ff'result
      * ''nonterm FixFoxiCore.warnings1
      * (''term, ''nonterm) FixFoxiCore.warnings2
      -> (''term * 'attrib, ''nonterm) FixFoxiCore.parser

    val fix_foxi :
      (''term, ''nonterm) FixFoxiCore.productions
      -> ''nonterm
       -> (''term, ''nonterm) FixFoxiCore.string_of_gramsym
        -> (''term, 'attrib, ''nonterm) ff'result
  end

(* ------------------------------------------------------------------------- *)
