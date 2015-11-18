(* ------------------------------------------------------------------------- *)
(* --- Copyright (c) 1998 by Edgar F. A. Lederer --------------------------- *)
(* ------------------------------------------------------------------------- *)

functor FixFoxiCoreFUN (structure Basic : BASIC
                        and       Set   : SET) : FIX_FOXI_CORE =

struct

exception FFError'_incorrect_example

fun example e = if e then () else raise FFError'_incorrect_example

local
  val non     = Basic.non
  and pair    = Basic.pair
  and fst     = Basic.fst
  and snd     = Basic.snd
  and swap    = Basic.swap
  and member  = Basic.member
  and lookup  = Basic.lookup
  and lookupE = Basic.lookupE

  val concat = List.concat
  and filter = List.filter
  and exists = List.exists

  open Set

  infix member
  infix elem
in

fun distribute_in list =
  let
    fun h (a, b_list) = map (pair a) b_list
  in
    concat (map h list)
  end

val _ = example (distribute_in [(1,[1,3,4]),(2,[2,5])] =
                   [(1,1),(1,3),(1,4),(2,2),(2,5)])

fun distribute_out list =
  let
    fun h ((a,b) :: rest) accu =
          let
            fun contains_a ab = fst ab = a
            val     a_rest    = filter      contains_a  rest
            val not_a_rest    = filter (non contains_a) rest
            val b_list        = b :: map snd a_rest
          in
            h not_a_rest ((a, b_list) :: accu)
          end
      | h [] accu = rev accu
  in
    h list []
  end

val _ = example (distribute_out [(1,1),(2,2),(1,3),(1,4),(2,5)] =
                   [(1,[1,3,4]),(2,[2,5])])

fun invert_distribution list =
  (distribute_out o map swap o distribute_in) list

fun check_memo f done memo x =
  case lookup memo x of
    SOME f_x => f_x
  | NONE     => f done memo x

fun make_memo f =
  let
    fun combine (x, memo) = (x, f memo x) :: memo
  in
    rev o foldl combine []
  end

datatype ('term, 'nonterm) grammar_symbol =
    T of 'term
  | N of 'nonterm

exception FFError'_destruct_T
and       FFError'_destruct_N

local
  fun is_T (T _) = true
    | is_T _     = false
  fun is_N (N _) = true
    | is_N _     = false
  fun destruct_T (T a) = a
    | destruct_T _     = raise FFError'_destruct_T
  fun destruct_N (N A) = A
    | destruct_N _     = raise FFError'_destruct_N
in
  fun T_set alpha_list =
    (Union o map (setof o map destruct_T o filter is_T)) alpha_list
  fun N_set alpha_list =
    (Union o map (setof o map destruct_N o filter is_N)) alpha_list
end

fun find'terms        prods = (Union o map (T_set o snd)) prods
fun find'nonterms_RHS prods = (Union o map (N_set o snd)) prods
fun find'nonterms_LHS prods = (setof o map fst) prods

fun normalize prods0 =
  let
    val empty_RHSs             = find'nonterms_LHS
                                  (filter (null o snd) prods0)

    val distri_out             = distribute_out prods0

    fun h (A, alpha_list_list) = (A, concat alpha_list_list)
    val prods1                 = map h distri_out

    fun p (_, alpha_list_list) = length alpha_list_list > 1
    val multiples_LHS          = (setof o map fst)
                                  (filter p distri_out)
  in
    (prods1, empty_RHSs, multiples_LHS)
  end

fun make'PRODUCTIVE prods1 S =
  let
    fun f1 done memo A =
      case lookup prods1 A of
        SOME alpha_list => exists (f2 (A :: done) memo) alpha_list
      | NONE            => false
    and f2 done memo alpha =
      let
        fun h (T _ :: rest) = h rest
          | h (N A :: rest) = not (A member done) andalso
                               check_memo f1 done memo A andalso
                                h rest
          | h []            = true
      in
        h alpha
      end
    val all              = insert (S, union (find'nonterms_RHS prods1,
                                             find'nonterms_LHS prods1))
    val PRODUCTIVE       = make_memo (f1 []) (listof all)
    val PRODUCTIVE_alpha = f2 [] PRODUCTIVE
  in
    (PRODUCTIVE, PRODUCTIVE_alpha)
  end

fun reduce1 prods1 S =
  let
    val (PRODUCTIVE, PRODUCTIVE_alpha) = make'PRODUCTIVE prods1 S

    val unproductives = (setof o map fst o filter (non snd)) PRODUCTIVE

    val result_option =
      if S elem unproductives then
        NONE
      else
        let
          val prods2' = filter
                         (fn (A, _) => lookupE PRODUCTIVE A)
                          prods1
          val prods2  = map
                         (fn (A, alpha_list) =>
                          (A, filter PRODUCTIVE_alpha alpha_list))
                           prods2'
        in
          SOME prods2
        end
  in
    (unproductives, result_option)
  end

fun find'reachables prods2 S =
  let
    fun h pending done =
      if is_empty pending then
        done
      else
        let
          val (A, rest_pending) = choose pending
          val reached           = (N_set o lookupE prods2) A
          and done'             = insert (A, done)
          val pending'          = union (diff (reached,
                                               done'),
                                         rest_pending)
        in
          h pending' done'
        end
  in
    h (setof [S]) empty
  end

fun reduce2 prods2 S =
  let
    val all          = find'nonterms_LHS prods2
    and reachables   = find'reachables prods2 S
    val unreachables = diff (all, reachables)
    and prods3       = filter (fn (A, _) => A elem reachables) prods2
  in
    (prods3, unreachables)
  end

fun norm_and_reduce prods0 S =
  let
    val (prods1, empty_RHSs, multiples_LHS) = normalize prods0

    val (unproductives, result_option) = reduce1 prods1 S

    val warnings = {empty_RHSs    = listof empty_RHSs,
                    multiples_LHS = listof multiples_LHS,
                    unproductives = listof unproductives}

    val result_option' =
      case result_option of
        SOME prods2 =>
          let
            val (prods3, unreachables) = reduce2 prods2 S
            val terms                  = find'terms        prods3
            and nonterms               = find'nonterms_LHS prods3
          in
            SOME (prods3, terms, nonterms, unreachables)
          end
      | NONE => NONE
  in
    (warnings, result_option')
  end

fun make'NULLABLE prods =
  let
    fun f1 done memo A =
      exists (f2 (A :: done) memo) (lookupE prods A)
    and f2 done memo alpha =
      let
        fun h (T _ :: rest) = false
          | h (N A :: rest) = not (A member done) andalso
                               check_memo f1 done memo A andalso
                                h rest
          | h []            = true
      in
        h alpha
      end
    val NULLABLE       = make_memo (f1 []) (map fst prods)
    val NULLABLE_alpha = f2 [] NULLABLE
  in
    (NULLABLE, NULLABLE_alpha)
  end

fun make'FIRST prods NULLABLE =
  let
    fun f1 done memo A =
      Union (map (f2 (A :: done) memo) (lookupE prods A))
    and f2 done memo alpha =
      let
        fun h (T a :: _   ) accu = insert (a, accu)
          | h (N A :: rest) accu =
              let
                val accu' = if A member done then
                              accu
                            else
                              union (check_memo f1 done memo A, accu)
              in
                if lookupE NULLABLE A then
                  h rest accu'
                else
                  accu'
              end
          | h [] accu = accu
      in
        h alpha empty
      end
    val FIRST       = make_memo (f1 []) (map fst prods)
    val FIRST_alpha = f2 [] FIRST
  in
    (FIRST, FIRST_alpha)
  end

datatype 'a terminal_or_end =
    U of 'a
  | $

fun foldlX f e (list as (_ :: rest)) = foldlX f (f (list, e)) rest
  | foldlX _ e []                    = e

fun make'FOLLOW prods S NULLABLE_alpha FIRST_alpha =
  let
    fun f1 done memo A =
      let
        val follow_A = Union (map (f2 (A :: done) memo A) prods)
      in
        if A = S then
          insert ($, follow_A)
        else
          follow_A
      end
    and f2 done memo A (B, beta_list) =
      Union (map (f3 done memo A B) beta_list)
    and f3 done memo A B beta =
      let
        fun combineX (T _ :: _   , accu) = accu
          | combineX (N C :: rest, accu) =
              if C = A then
                let
                  val first_rest'accu =
                    union ((setmap U o FIRST_alpha) rest, accu)
                in
                  if NULLABLE_alpha rest andalso not (B member done) then
                    let
                      val follow_B = check_memo f1 done memo B
                    in
                      union (follow_B, first_rest'accu)
                    end
                  else
                    first_rest'accu
                end
              else
                accu
          | combineX ([], accu) = accu
      in
        foldlX combineX empty beta
      end
    val FOLLOW = make_memo (f1 []) (map fst prods)
  in
    FOLLOW
  end

fun make'MM prods S =
  let
    val (NULLABLE, NULLABLE_alpha) = make'NULLABLE prods
    val (FIRST,    FIRST_alpha)    = make'FIRST    prods
                                                    NULLABLE
    val FOLLOW                     = make'FOLLOW   prods S
                                                    NULLABLE_alpha
                                                     FIRST_alpha
    fun f (A, alpha_list) =
      let
        fun g alpha =
          let
            val first_alpha = (setmap U o FIRST_alpha) alpha
            val terminals   = if NULLABLE_alpha alpha then
                                union (lookupE FOLLOW A, first_alpha)
                              else
                                first_alpha
          in
            (alpha, listof terminals)
          end
      in
        (A, invert_distribution (map g alpha_list))
      end

    val MM = map f prods
  in
    (NULLABLE, FIRST, FOLLOW, MM)
  end

exception FFInternalError'_make'M

local
  fun h (T a) = T (U a)
    | h (N A) = N A
  fun f1 (a, alpha :: _ ) = (a, (alpha, map h alpha))
    | f1 (_, [])          = raise FFInternalError'_make'M
  fun p1 (a, alpha :: []) = false
    | p1 (a, alpha :: _ ) = true
    | p1 (_, [])          = raise FFInternalError'_make'M
  fun f2 (A, a_alphas'list) = (A,    map f1 a_alphas'list)
  fun g  (A, a_alphas'list) = (A, filter p1 a_alphas'list)
  fun p2 (_, a_alphas'list) =     not (null a_alphas'list)
in
  fun make'M MM =
    let
      val M            = map f2 MM
      and multiples_MM = (filter p2 o map g) MM
    in
      (M, multiples_MM)
    end
end

fun analyze prods0 S =
  let
    val (warnings1, result_option) = norm_and_reduce prods0 S

    val result_option' =
      case result_option of
        SOME (prods3, terms, nonterms, unreachables) =>
          let
            val (NULLABLE, FIRST, FOLLOW, MM) = make'MM prods3 S
            val (M, multiples_MM)             = make'M  MM

            val warnings2 =
              {unreachables    = listof unreachables,
               grammar_not_LL1 =        multiples_MM}

            fun h (A, x) = (A, listof x)

            val analysis =
              {terms    = listof terms,
               nonterms = listof nonterms,
               prods    =        prods3,
               S        =        S,
               NULLABLE =        NULLABLE,
               FIRST    = map h  FIRST,
               FOLLOW   = map h  FOLLOW,
               MM       =        MM}
          in
            SOME (warnings2, analysis, M)
          end
      | NONE => NONE
  in
    (warnings1, result_option')
  end

exception SyntaxError'_terminal_terminal_mismatch
and       SyntaxError'_nonterminal_terminal_mismatch

exception FFInternalError'_generic_parser

fun generic_parser (S, M)
                    (string_of_term, string_of_nonterm)
                     (file_name, term_loc'list) =
  let
    local
      fun display (string_expected, (string_found, string_loc)) =
        let
          val error_message =
                                                                   "\n" ^
            file_name ^ ":" ^ string_loc ^ ":"                   ^ "\n" ^
            "  Syntax error: " ^ string_expected ^ " expected, " ^
                                 string_found    ^ " found"      ^ "\n"
        in
          print error_message
        end

      fun string_of_loc (line, (col1, col2)) =
        Int.toString line ^ "." ^ Int.toString col1 ^ "-" ^
                                  Int.toString col2

      fun f (U a)        = "terminal " ^ string_of_term a
        | f $            = "end of file"
      fun g A            = "nonterminal " ^ string_of_nonterm A
      fun h (U (a, loc)) = (f (U a), string_of_loc loc)
        | h $            = (f $,     "-")
    in
      fun syntax_error'TTM (a, term_loc) =
        (display (f a, h term_loc)
         ;
         raise SyntaxError'_terminal_terminal_mismatch)

      fun syntax_error'NTM (A, term_loc) =
        (display (g A, h term_loc)
         ;
         raise SyntaxError'_nonterminal_terminal_mismatch)
    end

    fun remove_loc (U (term, _)) = U term
      | remove_loc $             = $

    val lookupM = lookup o lookupE M

    fun p (T a :: rem_stack) (term_loc :: rem_input) accu =
          let
            val b = remove_loc term_loc
          in
            if a = b then
              if a = $ then
                rev accu
              else
                p rem_stack rem_input accu
            else
              syntax_error'TTM (a, term_loc)
          end
      | p (N A :: rem_stack) (input as (term_loc :: _)) accu =
          let
            val b = remove_loc term_loc
          in
            case lookupM A b of
              SOME (alpha, U_alpha) =>
                p (U_alpha @ rem_stack) input (alpha :: accu)
            | NONE =>
                syntax_error'NTM (A, term_loc)
          end
      | p _ _ _ = raise FFInternalError'_generic_parser
  in
    p [N S, T $] (map U term_loc'list @ [$]) []
  end

datatype ('a,'b) parse_tree =
    TL of 'a                             (* terminal leaf   *)
  | PN of 'b * ('a,'b) parse_tree list   (* production node *)

exception FFError'_leftmost_derivation_too_short
and       FFError'_leftmost_derivation_too_long

local
  fun f (T a) left_deriv = (left_deriv, TL a)
    | f (N A) left_deriv =
        let
          val (rest'left_deriv, rev'parse_tree_list) = g left_deriv
        in
          (rest'left_deriv, PN (A, rev rev'parse_tree_list))
        end

  and g (alpha :: rest'left_deriv) =
        foldl combine (rest'left_deriv, []) alpha
    | g [] = raise FFError'_leftmost_derivation_too_short

  and combine (X, (left_deriv, accu)) =
        let
          val (rest'left_deriv, parse_tree) = f X left_deriv
        in
          (rest'left_deriv, parse_tree :: accu)
        end
in
  fun make'parse_tree S left_deriv =
    case f (N S) left_deriv of
      ([], parse_tree) => parse_tree
    | _                => raise FFError'_leftmost_derivation_too_long
end

exception FFError'_token_location_list_too_short
and       FFError'_token_location_list_too_long

local
  fun combine'pn_locs (SOME (l, _),   SOME (_, r))   = SOME (l, r)
    | combine'pn_locs (loc as SOME _, NONE)          = loc
    | combine'pn_locs (NONE,          loc as SOME _) = loc
    | combine'pn_locs (NONE,          NONE)          = NONE

  fun f (TL _) tok_loc'list =
        (case tok_loc'list of
          (tok_loc as (_, (line, (col1, col2)))) :: rest'tok_loc'list =>
            (rest'tok_loc'list,
             TL tok_loc,
             SOME ((line, col1), (line, col2)))
        | [] => raise FFError'_token_location_list_too_short)
    | f (PN (A, parse_tree_list)) tok_loc'list =
        let
          val (rest'tok_loc'list, rev'parse_tree_list', pn_loc) =
            g parse_tree_list tok_loc'list
        in
          (rest'tok_loc'list,
           PN ((A, pn_loc), rev rev'parse_tree_list'),
           pn_loc)
        end

  and g parse_tree_list tok_loc'list =
        foldl combine (tok_loc'list, [], NONE) parse_tree_list

  and combine (parse_tree, (tok_loc'list, tree_accu, loc_accu)) =
        let
          val (rest'tok_loc'list, parse_tree', pn_loc) =
            f parse_tree tok_loc'list
        in
          (rest'tok_loc'list,
           parse_tree' :: tree_accu,
           combine'pn_locs (loc_accu, pn_loc))
        end
in
  fun attribute (parse_tree, tok_loc'list) =
    case f parse_tree tok_loc'list of
      ([], parse_tree', _) => parse_tree'
    | _                    => raise FFError'_token_location_list_too_long
end

local
  fun format (string_of_term, string_of_nonterm) =
    let
      fun string_of_nonterm' A = "<" ^ string_of_nonterm A ^ ">"
    in
      (string_of_term, string_of_nonterm')
    end
in
  fun fix_foxi'core prods0 S string_of_gramsym =
    let
      val (warnings1, result_option) = analyze prods0 S

      val string_of_gramsym' = format string_of_gramsym

      val result_option' =
        case result_option of
          SOME (warnings2, analysis, M) =>
            let
              val parser'' = generic_parser (S, M) string_of_gramsym'
              val parser'  = make'parse_tree S o parser''

              fun parser (file_name, tok_loc'list) =
                let
                  fun remove_attrib ((term, _), loc) = (term, loc)

                  val term_loc'list = map remove_attrib tok_loc'list
                  val parse_tree    = parser' (file_name, term_loc'list)
                in
                  attribute (parse_tree, tok_loc'list)
                end
            in
              SOME (warnings2, analysis, parser)
            end
        | NONE => NONE
    in
      (warnings1, result_option', string_of_gramsym')
    end
end

(* ------------------------------------------------------------------------- *)

type ('term, 'nonterm) productions =
  ('nonterm * ('term, 'nonterm) grammar_symbol list list) list

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

end (* local *)

end (* struct *)

(* ------------------------------------------------------------------------- *)
