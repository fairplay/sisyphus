\ List operations
: @ ( pair key -- bool ) [ swap pull -rot == [ ] swap i pull pop ]
: @? [ swap pull pop == ]

: @: ( stack-of-pairs key -- stack-of-values ) [
  [ @? ] push filter
  [ pull []? ]
    [ ]
    [ _ i ]
  ifte ]

: !_ [ [ @? not ] push filter ]
: !: [ dup pull pop swap -rot !_ push ]

[ [ a b ] [ c d ] ] [ a b ] @? ' True TEST
[ [ a b ] [ c d ] ] [ a b x ] @? ' False TEST

[ [ a b ] [ c d ] ] a @: [ a b ] TEST

[ [ a [ [ c y ] [ b x ] ] ] [ c d ] ] a @: [ a b ] TEST

[ [ 5 a ] [ [ 3 b ] [ 4 44 ] ] [ 3 9 ] [ [ 3 c ] xxx ] ] [ 3 b ] @: [ [ 3 b ] [ 4 44 ] ] TEST

[ [ 3 4 ] [ 5 6 ] [ 7 [ a b ] ] ] 7 !_ [ [ 3 4 ] [ 5 6 ] ] TEST

[ [ 3 4 ] [ 5 6 ] ] [ 7 8 ] !: [ [ 7 8 ] [ 3 4 ] [ 5 6 ] ] TEST
[ [ 3 4 ] [ 5 6 ] [ 7 [ a b ] ] ] [ 7 8 ] !: [ [ 7 8 ] [ 3 4 ] [ 5 6 ] ] TEST
