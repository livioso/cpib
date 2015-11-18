(* ------------------------------------------------------------------------- *)
(* --- Copyright (c) 1998 by Edgar F. A. Lederer --------------------------- *)
(* ------------------------------------------------------------------------- *)

functor FixFoxiFUN
   (structure FixFoxiCore : FIX_FOXI_CORE) : FIX_FOXI =

struct

structure FixFoxiCore = FixFoxiCore

exception GrammarError'_empty_language
and       GrammarError'_unexpected_warnings

type         'nonterm  warnings1 =         'nonterm  FixFoxiCore.warnings1
type ('term, 'nonterm) warnings2 = ('term, 'nonterm) FixFoxiCore.warnings2
type ('term, 'nonterm) analysis  = ('term, 'nonterm) FixFoxiCore.analysis

type ('term, 'attrib, 'nonterm) ff'result =
  ('term, 'attrib, 'nonterm) FixFoxiCore.fix_foxi'result

fun string_of_a_or_end string_of_term (FixFoxiCore.U a) =
      "terminal " ^ string_of_term a
  | string_of_a_or_end _               FixFoxiCore.$    = "$"

local
  fun g sep (x :: (rest as (_ :: _))) = x :: sep :: g sep rest
    | g _   list                      = list
in
  fun string_of_alpha (string_of_term, string_of_nonterm) =
    let
      fun h (FixFoxiCore.T a) = string_of_term    a
        | h (FixFoxiCore.N A) = string_of_nonterm A
    in
      concat o g " " o map h
    end
end

fun display'parse_tab_mult_entries
      (string_of_gramsym as (string_of_term, string_of_nonterm)) ptme =
  let
    fun h1 A        = print (string_of_nonterm A ^ "\n")
    fun h2 a_or_end = print ("  " ^ string_of_a_or_end
                                      string_of_term a_or_end ^ "\n")
    fun h3 alpha    = print ("    " ^ string_of_alpha
                                        string_of_gramsym alpha ^ "\n")
    fun g1 (a_or_end, alpha_list) = (h2 a_or_end ; app h3 alpha_list)
    fun g2 (A, aoe_al'list)       = (h1 A ; app g1 aoe_al'list)
  in
    app g2 ptme
  end

fun print_error () = print "Error: empty language\n"

local
  fun print_warning (list, string_of_warning, f) =
    if null list then () else
      (print ("Warning: " ^ string_of_warning ^ ":\n") ; f list)
in
  fun dispDiagnosis
        ({empty_RHSs, multiples_LHS, unproductives},
         result_option,
         string_of_gramsym as (_, string_of_nonterm)) =
    let
      fun h A = print (string_of_nonterm A ^ "\n")
    in
      print_warning (empty_RHSs,
                     "no alternatives on RHS",
                     app h)
      ;
      print_warning (multiples_LHS,
                     "multiple occurrences of same nonterminal on LHS",
                     app h)
      ;
      print_warning (unproductives,
                     "unproductive nonterminals",
                     app h)
      ;
      case result_option of
        SOME ({unreachables, grammar_not_LL1}, _, _) =>
          (
          print_warning (unreachables,
                         "unreachable nonterminals",
                         app h)
          ;
          print_warning (grammar_not_LL1,
                         "grammar not LL1",
                         display'parse_tab_mult_entries string_of_gramsym)
          )
      | NONE => print_error ()
    end
end

fun dispTerms
        (_, SOME (_, {terms, ...} : ('term, 'nonterm) analysis, _),
          (string_of_term, _)) =
      let
        fun h a = print (string_of_term a ^ "\n")
      in
        app h terms
      end
  | dispTerms (_, NONE, _) = print_error ()

fun dispNonterms
        (_, SOME (_, {nonterms, ...} : ('term, 'nonterm) analysis, _),
          (_, string_of_nonterm)) =
      let
        fun h A = print (string_of_nonterm A ^ "\n")
      in
        app h nonterms
      end
  | dispNonterms (_, NONE, _) = print_error ()

fun dispProds
        (_, SOME (_, {prods, ...} : ('term, 'nonterm) analysis, _),
          string_of_gramsym as (_, string_of_nonterm)) =
      let
        fun h1 A     = print (string_of_nonterm A ^ "\n")
        fun h2 alpha = print ("  " ^ string_of_alpha
                                       string_of_gramsym alpha ^ "\n")
        fun g (A, alpha_list) = (h1 A ; app h2 alpha_list)
      in
        app g prods
      end
  | dispProds (_, NONE, _) = print_error ()

fun dispS
        (_, SOME (_, {S, ...} : ('term, 'nonterm) analysis, _),
          (_, string_of_nonterm)) =
      print (string_of_nonterm S ^ "\n")
  | dispS (_, NONE, _) = print_error ()

fun dispNULLABLE
        (_, SOME (_, {NULLABLE, ...} : ('term, 'nonterm) analysis, _),
          (string_of_term, string_of_nonterm)) =
      let
        fun h (A, nullable) =
          print (string_of_nonterm A ^ " " ^ Bool.toString nullable ^ "\n")
      in
        app h NULLABLE
      end
  | dispNULLABLE (_, NONE, _) = print_error ()

fun dispFIRST
        (_, SOME (_, {FIRST, ...} : ('term, 'nonterm) analysis, _),
          (string_of_term, string_of_nonterm)) =
      let
        fun h1 A = print (string_of_nonterm A ^ "\n")
        fun h2 a = print ("  " ^ string_of_term a ^ "\n")
        fun g (A, a_list) = (h1 A ; app h2 a_list)
      in
        app g FIRST
      end
  | dispFIRST (_, NONE, _) = print_error ()

fun dispFOLLOW
        (_, SOME (_, {FOLLOW, ...} : ('term, 'nonterm) analysis, _),
          (string_of_term, string_of_nonterm)) =
      let
        fun h1 A        = print (string_of_nonterm A ^ "\n")
        fun h2 a_or_end = print ("  " ^ string_of_a_or_end
                                          string_of_term a_or_end ^ "\n")
        fun g (A, a_or_end'list) = (h1 A ; app h2 a_or_end'list)
      in
        app g FOLLOW
      end
  | dispFOLLOW (_, NONE, _) = print_error ()

fun dispMM
        (_, SOME (_, {MM, ...} : ('term, 'nonterm) analysis, _),
          string_of_gramsym) =
      display'parse_tab_mult_entries string_of_gramsym MM
  | dispMM (_, NONE, _) = print_error ()

fun ? () = print "dispDiagnosis\n\
                 \dispTerms\n\
                 \dispNonterms\n\
                 \dispProds\n\
                 \dispS\n\
                 \dispNULLABLE\n\
                 \dispFIRST\n\
                 \dispFOLLOW\n\
                 \dispMM\n"

fun extractParser ((found_warns1, SOME (found_warns2, _, parser), _),
                   expected_warns1, expected_warns2) =
      if found_warns1 = expected_warns1 andalso
         found_warns2 = expected_warns2 then
        parser
      else
        raise GrammarError'_unexpected_warnings
  | extractParser ((_, NONE, _), _, _) =
      raise GrammarError'_empty_language

fun fix_foxi prods S string_of_gramsym =
  let
    val result = FixFoxiCore.fix_foxi'core prods S string_of_gramsym
  in
    dispDiagnosis result ; result
  end

end (* struct *)

(* ------------------------------------------------------------------------- *)
