: <swap [ pull pull pull -rot swap rot push3 ]
: <rot [ pull pull pull pop rot [ ] push3 ]

: hanoi-1 [ 2dup swap 1- swap <swap [ hanoi ] push2 -rot ]
: hanoi-2 [ dup pull pull pull rot pop push2 quote -rot ]
: hanoi-3 [ 2dup swap 1- swap <rot <swap [ hanoi ] push2 -rot ]

: hanoi [ [ over 0? ] [ pop2 ] [ hanoi-1 hanoi-2 hanoi-3 pop2 cat cat i ] ifte ]

4 [ 1 2 3 ] hanoi
