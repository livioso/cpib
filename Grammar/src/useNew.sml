SMLofNJ.Internals.GC.messages false;

let
  open Control.Print
in
  printLength := 2 * !printLength;
  printDepth  := 2 * !printDepth;
  stringDepth := 2 * !stringDepth;
  print ("printLength = " ^ Int.toString (!printLength) ^ "\n");
  print ("printDepth  = " ^ Int.toString (!printDepth)  ^ "\n");
  print ("stringDepth = " ^ Int.toString (!stringDepth) ^ "\n")
end;

let
  val sources = ["BASIC.sig", "SET.sig", "FIX_FOXI_CORE.sig", "FIX_FOXI.sig", "Basic.fun", "Set.fun", "FixFoxiCore.fun", "FixFoxi.fun"]
in
  app use sources
end;

structure Basic =
  BasicFUN
    ()
structure Set =
  SetFUN
    (structure Basic = Basic)
structure FixFoxiCore =
  FixFoxiCoreFUN
    (structure Basic = Basic
     and       Set   = Set)
structure FixFoxi =
  FixFoxiFUN
    (structure FixFoxiCore = FixFoxiCore);

open FixFoxi
