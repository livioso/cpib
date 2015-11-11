(* ------------------------------------------------------------------------- *)
(* --- Copyright (c) 1998 by Edgar F. A. Lederer --------------------------- *)
(* ------------------------------------------------------------------------- *)

signature SET =
  sig
    type 'a t
    exception E
    val setof    : ''a list -> ''a t
    val listof   : 'a t -> 'a list
    val insert   : ''a * ''a t -> ''a t
    val is_empty : 'a t -> bool
    val choose   : 'a t -> 'a * 'a t
    val elem     : ''a * ''a t -> bool
    val empty    : 'a t
    val setmap   : ('a -> 'b) -> 'a t -> 'b t
    val union    : ''a t * ''a t -> ''a t
    val inter    : ''a t * ''a t -> ''a t
    val diff     : ''a t * ''a t -> ''a t
    val subset   : ''a t * ''a t -> bool
    val seteq    : ''a t * ''a t -> bool
    val Union    : ''a t list -> ''a t
  end

(* ------------------------------------------------------------------------- *)
