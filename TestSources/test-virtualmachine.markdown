**Given the following iml source code:**

    program intDiv
    global
      proc divide(in copy m:int, in copy n:int, out ref q:int, out ref r:int)
      do
        q init := 0;
        r init := m;
        while r >= n do
          q := q + 1;
          r := r - n
        endwhile
      endproc;
      var m:int;
      var n:int;
      var q:int;
      var r:int
    do
      ? m init;
      ? n init;
      call divide(m, n, q init, r init);
      ! q;
      ! r
    endprogram


**The resulting intermediate code should somehow like this:**

    0, Alloc 4,
    1, IntLoad 0,
    2, InputInt m,
    3, IntLoad 1,
    4, InputInt n,
    5, Alloc 0,
    6, IntLoad 0,
    7, Deref,
    8, IntLoad 1,
    9, Deref 9,
    10, IntLoad 2,
    11, IntLoad 3,
    12, Call 20,
    13, IntLoad 2,
    14, Deref,
    15, OutputInt q,
    16, IntLoad 3,
    17, Deref,
    18, IntOutput r,
    19, Stop,
    20, Enter 0 0,
    21, IntLoad 0,
    22, LoadRel (-2),
    23, Deref,
    24, Store,
    25, LoadRel (-4),
    26, Deref,
    27, LoadRel (-1),
    28, Deref,
    29, Store,
    30, LoadRel (-1),
    31, Deref,
    32, Deref,
    33, LoadRel (-3),
    34, Deref,
    35, IntGE,
    36, CondJump 55,
    37, LoadRel (-2),
    38, Deref,
    39, Deref,
    40, IntLoad 1,
    41, IntAdd,
    42, LoadRel 42, (-2),
    43, Deref,
    44, Store,
    45, LoadRel (-1),
    46, Deref,
    47, Deref,
    48, LoadRel (-3),
    49, Deref,
    50, IntSub,
    51, LoadRel (-1),
    52, Deref,
    53, Deref,
    54, UncondJump 30,
    55, Return 4
