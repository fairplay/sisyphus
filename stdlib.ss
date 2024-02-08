( "stack*" is the result of "stack" execution )

\ Helper functions
: quote ( a -- [ a ] ) [ [ ] push ]
: -rot ( a b c -- c a b ) [ rot rot ]
: tuck ( a b -- b a b ) [ swap over ]
: cat ( a stack -- [ a i stack ] ) [ ' i swap push push ]
: dip ( a stack -- stack* a ) [ swap [ ] push cat ]
: []? ( stack -- bool ) [ [ ] == ]
: 0? ( n -- bool ) [ 0 == ]
: _? ( a -- bool ) [ _ == ]
: ?push [ [ over _? ] [ swap pop ] [ push ] ifte ]
: push2 [ push push ]
: push3 [ push push push ]
: 2dup [ over over ]

\ Church booleans and logic
: True ( a b -- a ) [ pop ]
: False ( a b -- b ) [ swap pop ]
: and ( bool bool -- bool ) [ dup i ]
: not ( bool -- bool ) [ [ ' False ' True ] dip i ]
: or ( bool bool -- bool ) [ dup not i ]

\ if ... then ... else ...
: ifte ( cond-stack stack stack -- stack* ) [ [ ] push push cat i rot i i ]
: TEST [ [ 2dup == ] [ pop pop ] [ _ i ] ifte ]

\ Math shortcuts
: 1+ [ 1 + ]
: 1- [ 1 - ]

\ List functions
: range ( n m -- [ n .. m ] ) [
  [ 2dup == ]
    [ pop [ ] push ]
    [ swap dup 1+ rot range push ]
  ifte ]

: iota ( n -- [ 1 .. n ] ) [ 1 swap range ]

\ High-order functions (combinators)
: fold ( stack accum f -- accum ) [
  [ rot dup []? ]
    [ pop pop ]
    [ pull rot tuck [ ] push push cat i rot swap fold ]
  ifte ]

: map ( stack f -- stack ) [
  [ over []? ]
    [ pop ]
    [ swap pull swap rot dup rot swap i -rot map ?push ]
  ifte ]

: filter ( stack f -- stack ) [ ' dup swap push [ ] [ pop _ ] [ ifte ] push3 map ]

\ Loop
: repeat ( f n -- something ) [
  [ dup 0? ]
    [ pop pop ]
    [ rot rot tuck i swap rot 1- repeat ]
  ifte ]
