(* ------------------------------------------------------------------------- *)
(* --- Copyright (c) 1998 by Edgar F. A. Lederer --------------------------- *)
(* ------------------------------------------------------------------------- *)

functor BasicFUN () : BASIC =

struct

fun I x = x
fun K x _ = x

fun non p = not o p

fun pair x y = (x,y)
fun fst (x,_) = x
fun snd (_,y) = y
fun swap (x,y) = (y,x)

infix member
fun x member (y :: ys) = x = y orelse x member ys
  | _ member []        = false

fun lookup xys a =
  let
    fun h ((x,y) :: xys) = if x = a then SOME y else h xys
      | h []             = NONE
  in
    h xys
  end

exception Lookup
fun lookupE xys a =
  case lookup xys a of
    SOME y => y
  | NONE   => raise Lookup

exception Zip
fun zipE (x :: xs, y :: ys) = (x,y) :: zipE (xs, ys)
  | zipE ([],      [])      = []
  | zipE _                  = raise Zip

end (* struct *)

(* ------------------------------------------------------------------------- *)
