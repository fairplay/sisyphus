1 2 3 -rot " 2push [ 3 1 2 ] TEST
1 2 tuck " 2push [ 2 1 2 ] TEST

[ a ] [ b ] cat [ [ a ] i b ] TEST

[ 1 2 ] empty? ' False TEST
[ ] empty? ' True TEST

a b [ 2 3 ] 2push [ a b 2 3 ] TEST
a b c [ 2 3 ] 3push [ a b c 2 3 ] TEST

' False not ' True TEST
' True ' False and ' False TEST
' False ' True or ' True TEST

[ ' False ] [ 123 ] [ 456 ] ifte 456 TEST
[ ' True ] [ 123 ] [ 456 ] ifte 123 TEST

4 6 range [ 4 5 6 ] TEST
5 iota [ 1 2 3 4 5 ] TEST

: 2^ [ dup * ]
: 3^ [ dup dup * * ]

5 iota 1 [ * ] fold 120 TEST
2 5 range [ 3^ ] map [ 8 27 64 125 ] TEST
10 iota [ dup 2 % 0 eq? ] filter [ 2 4 6 8 10 ] TEST

1 [ 2 * ] 5 repeat 32 TEST

[ [ a b ] [ c d ] ] [ a b ] get [ c d ] TEST
[ [ 5 a ] [ [ 3 b ] [ 4 44 ] ] [ 3 9 ] [ [ 3 b ] xxx ] ] [ 3 b ] find [ xxx [ 4 44 ] ] TEST
[ 3 4 ] 5 get _ TEST
