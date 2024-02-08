: prime? [
  dup 1+ 2 / i 1 swap range swap [ swap % ] push map
  [ [ 0? ] [ 1 ] [ _ ] ifte ] map
  pull swap pop []?
]

17 prime? ' True TEST
24 prime? ' False TEST
2 10 range [ [ dup prime? ] [ ] [ pop _ ] ifte ] map [ 2 3 5 7 ] TEST
