: match-list-list [
  2dup 2fence [ empty? ] map
  [ False False ] ? [ pull swap rot pull -rot match ] when
  [ False True ] ? [ pop pop ] when
  [ True False ] ? [ pop ] when
  [ True True ] ? [ pop pop ] when
]

: match-atom-x [
  2dup 2fence [ $ eq? ] map
  [ False False ] ? [ pop pop ] when
  [ False True ] ? [ pop ] when
  [ True False ] ? [ swap pop ] when
  [ True True ] ? [ pop ] when
]

: match [
  2dup 2fence [ typeof ] map
  [ atom atom ] ? [ match-atom-x -rot ] when
  [ atom list ] ? [ match-atom-x -rot ] when
  [ list atom ] ? [ match-atom-x -rot ] when
  [ list list ] ? [ match-list-list ] when
]

[ ] [ 2 ] match
