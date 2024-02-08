1 2 3 [ a b c ] stack [ 1 2 3 [ a b c ] ] TEST

a b [ 2 3 ] push2 [ a b 2 3 ] TEST
a b c [ 2 3 ] push3 [ a b c 2 3 ] TEST

1 2 3 -rot quote push2 [ 3 1 2 ] TEST
1 2 tuck quote push2 [ 2 1 2 ] TEST

[ a ] [ b ] cat [ [ a ] i b ] TEST

[ 1 2 ] []? ' False TEST
[ ] []? ' True TEST

_ [ 2 3 ] ?push [ 2 3 ] TEST
1 [ 2 3 ] ?push [ 1 2 3 ] TEST

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
10 iota [ 2 % 0? ] filter [ 2 4 6 8 10 ] TEST

1 [ 2 * ] 5 repeat 32 TEST
