(* ------------------------------------------------------------------------- *)
(* --- Copyright (c) 1998 by Edgar F. A. Lederer --------------------------- *)
(* ------------------------------------------------------------------------- *)

functor SetFUN (structure Basic : BASIC) :> SET =

struct

type 'a t = 'a list

exception E

val elem = Basic.member
infix elem

fun insert (x, xs) = if x elem xs then xs else x :: xs

fun setof (x :: xs) = insert (x, setof xs)
  | setof []        = []

val listof = Basic.I

val is_empty = null

fun choose (x :: xs) = (x, xs)
  | choose []        = raise E

val empty = []

val setmap = map

fun union (s, t) =
  let
    fun h (x :: xs) = insert (x, h xs)
      | h []        = t
  in
    h s
  end

fun inter (s, t) =
  let
    fun h (x :: xs) = if x elem t then x :: h xs else h xs
      | h []        = []
  in
    h s
  end

fun diff (s, t) =
  let
    fun h (x :: xs) = if x elem t then h xs else x :: h xs
      | h []        = []
  in
    h s
  end

fun subset (s, t) =
  let
    fun h (x :: xs) = x elem t andalso h xs
      | h []        = true
  in
    h s
  end

fun seteq (s, t) = subset (s, t) andalso subset (t, s)

fun Union set_list = foldl union empty set_list

end (* struct *)

(* ------------------------------------------------------------------------- *)
