: var ( vars state atom -- vars state ) [
  rot push swap ]

: var? ( vars state atom -- vars state bool ) [
  rot tuck swap in? rot swap ]

: in? ( stack atom -- bool ) [
  [ == ] push filter []? not ]

: assign ( state k v -- state ) [
  quote push swap push ]

: walk ( state k -- state v ) [
  2dup @
  [ dup _? ]
    [ pop ]
    [ swap pop pull swap pop pull pop walk ]
  ifte ]

: unify ( vars state x y -- vars state ) [
  -rot walk -rot swap walk rot
  [ 2dup == ]
    [ pop2 ]
    [ 2swap rot ]

  ifte ]


[ ] [ ] x var y var quote push [ [ y x ] [ ] ] TEST
[ x y z ] [ ] y var? quote push2 [ [ x y z ] [ ] True ] TEST
[ [ x 5 ] ] y 6 assign [ [ y 6 ] [ x 5 ] ] TEST
[ [ x 5 ] [ y 6 ] ] y walk quote push [ [ [ x 5 ] [ y 6 ] ] 6 ] TEST
[ [ x 4 ] [ y x ] [ z 6 ] ] y walk quote push [ [ [ x 4 ] [ y x ] [ z 6 ] ] 4 ] TEST
[ [ x 5 ] [ y 6 ] ] t walk quote push [ [ [ x 5 ] [ y 6 ] ] t ] TEST



[ x y z a ] [ [ x 4 ] [ y x ] [ z 6 ] [ a b ] ] y a unify
