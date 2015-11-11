(* ------------------------------------------------------------------------- *)
(* --- Copyright (c) 1998 by Edgar F. A. Lederer --------------------------- *)
(* ------------------------------------------------------------------------- *)

signature BASIC =
  sig
    exception Lookup
    exception Zip
    val I       : 'a -> 'a
    val K       : 'a -> 'b -> 'a
    val non     : ('a -> bool) -> 'a -> bool
    val pair    : 'a -> 'b -> 'a * 'b
    val fst     : 'a * 'b -> 'a
    val snd     : 'a * 'b -> 'b
    val swap    : 'a * 'b -> 'b * 'a
    val member  : ''a * ''a list -> bool
    val lookup  : (''a * 'b) list -> ''a -> 'b option
    val lookupE : (''a * 'b) list -> ''a -> 'b
    val zipE    : 'a list * 'b list -> ('a * 'b) list
  end

(* ------------------------------------------------------------------------- *)
