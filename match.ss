: match-list-list [
  2dup 2fence [ empty? ] map
  [ False False ] ? [ pull swap rot pull -rot match ] when
  [ False True ] ? [ pop pop ] when
  [ True False ] ? [ pop pop ] when
  [ True True ] ? [ pop pop ] when
]

: match-atom-x [
  swap $ ? [ ] [ pop ] ifte -rot swap match
]

: match [
  2dup 2fence [ typeof ] map
  [ atom atom ] ? [ match-atom-x ] when
  [ atom list ] ? [ match-atom-x ] when
  [ list atom ] ? [ swap match-atom-x ] when
  [ list list ] ? [ match-list-list ] when
]

\ [ [ 1 ] ] [ [ $ ] ] match
[ [ 1 ] ] [ [ $ ] ] pull swap rot pull -rot matc
