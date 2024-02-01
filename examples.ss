: gcd [ [ over over eq? ] [ pop ] [ [ over over lt? ] [ ] [ swap ] ifte over - gcd ] ifte ]
: fact [ swap 1+ dup rot * [ fact ] push push ]

[ 0 1 fact ] [ ] [ [ i ] cat ] 6 repeat i [ 6 720 fact ] TEST
5 15 gcd 5 TEST

