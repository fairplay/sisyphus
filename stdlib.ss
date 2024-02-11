( "stack*" is the result of "stack" execution )

\ Helper functions
: []? ( stack -- bool ) [ [ ] == ]
: 0? ( n -- bool ) [ 0 == ]
: _? ( a -- bool ) [ _ == ]
: ?push [ [ over _? ] [ swap pop ] [ push ] ifte ]
: push2 [ push push ]
: push3 [ push push push ]
: pull2 [ pull pull ]
: pull3 [ pull pull pull ]
: pop2 [ pop pop ]
: pop3 [ pop pop pop ]
: 2dup [ over over ]
: 2swap [ [ ] push2 -rot [ ] push2 swap pull2 pop rot pull2 pop ]
: quote ( a -- [ a ] ) [ [ ] push ]
: -rot ( a b c -- c a b ) [ rot rot ]
: tuck ( a b -- b a b ) [ swap over ]
: cat ( a stack -- [ a i stack ] ) [ ' i swap push2 ]
: dip ( a stack -- stack* a ) [ swap [ ] push cat ]

\ Church booleans and logic
: True ( a b -- a ) [ pop ]
: False ( a b -- b ) [ swap pop ]
: and ( bool bool -- bool ) [ dup i ]
: not ( bool -- bool ) [ [ ' False ' True ] dip i ]
: or ( bool bool -- bool ) [ dup not i ]

\ if ... then ... else ...
: ifte ( cond-stack stack stack -- stack* ) [ [ ] push2 cat i rot i i ]
: TEST [ [ 2dup == ] [ pop2 ] [ _ i ] ifte ]

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
    [ pop2 ]
    [ pull rot tuck [ ] push2 cat i rot swap fold ]
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
    [ pop2 ]
    [ rot rot tuck i swap rot 1- repeat ]
  ifte ]

: repeat-till-empty ( f [ A ] -- something ) [
  [ push ] push map
  [ ] [ cat ] fold i ]

