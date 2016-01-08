**Given the following iml source code:**
program main
global
    var position: record ( var x:int64, const y:int64 ) ;
    professor: record ( id:int64, level:int64 )

do
    position.x init := 4;
    position.y init := 5;

    debugout position.x;
    debugout position.y;

    professor.id init := 1007;
    professor.level init := 19;

    position.x := 42;

    debugout professor.id

endprogram

**The resulting intermediate code should somehow like this:**
0, AllocBlock (4),
1, LoadImInt (0),
2, LoadImInt (4),
3, Store,
4, LoadImInt (1),
5, LoadImInt (5),
6, Store,
7, LoadImInt (0),
8, Deref,
9, OutputInt (position.x),
10, LoadImInt (1),
11, Deref,
12, OutputInt (position.y),
13, LoadImInt (2),
14, LoadImInt (1007),
15, Store,
16, LoadImInt (3),
17, LoadImInt (19),
18, Store,
19, LoadImInt (0),
20, LoadImInt (42),
21, Store,
22, LoadImInt (2),
23, Deref,
24, OutputInt (professor.id),
25, Stop
