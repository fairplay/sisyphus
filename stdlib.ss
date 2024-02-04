( "stack*" is the result of "stack" execution )

\ Helper functions
: " ( a -- [ a ] ) [ [ ] push ]
: -rot ( a b c -- c a b ) [ rot rot ]
: tuck ( a b -- b a b ) [ swap over ]
: cat ( a stack -- [ a i stack ] ) [ ' i swap push push ]
: dip ( a stack -- stack* a ) [ swap [ ] push cat ]
: empty? ( stack -- bool ) [ [ ] eq? ]
: 2push [ push push ]
: 3push [ push push push ]

\ Church booleans and logic
: True ( a b -- a ) [ pop ]
: False ( a b -- b ) [ swap pop ]
: and ( bool bool -- bool ) [ dup i ]
: not ( bool -- bool ) [ [ ' False ' True ] dip i ]
: or ( bool bool -- bool ) [ dup not i ]

\ if ... then ... else ...
: ifte ( cond-stack stack stack -- stack* ) [ [ ] push push cat i rot i i ]
: TEST [ [ eq? ] [ ] [ _ i ] ifte ]

\ Math shortcuts
: 1+ [ 1 + ]
: 1- [ 1 - ]

\ List functions
: range ( n m -- [ n .. m ] ) [
  [ over over eq? ]
    [ pop [ ] push ]
    [ swap dup 1+ rot range push ]
  ifte ]

: iota ( n -- [ 1 .. n ] ) [ 1 swap range ]

\ High-order functions (combinators)
: fold ( stack accum f -- accum ) [
  [ rot dup empty? ]
    [ pop pop ]
    [ pull rot tuck [ ] push push cat i rot swap fold ]
  ifte ]

: map ( stack f -- stack ) [
  [ over empty? ]
    [ pop ]
    [ swap pull swap rot dup rot swap i -rot map push ]
  ifte ]

: filter ( stack f -- stack ) [ [ ] [ pop _ ] [ ifte ] 3push map ]

\ Loop
: repeat ( f n -- something ) [
  [ dup 0 eq? ]
    [ pop pop ]
    [ rot rot tuck i swap rot 1- repeat ]
  ifte ]

\ List operations
: get ( pair key -- value ) [ swap pull [ -rot eq? ] [ pull pop ] [ pop _ ] ifte ]
: find ( stack-of-pairs key -- stack-of-values ) [ [ ] swap [ get swap push ] push fold ]
