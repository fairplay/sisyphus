: <swap [ pull pull pull -rot swap rot push push push ]
: <rot [ pull pull pull pop rot [ ] push push push ]

: hanoi-1 [ 2dup swap 1- swap <swap [ hanoi ] push2 -rot ]
: hanoi-2 [ dup pull pull pull rot pop push2 quote -rot ]
: hanoi-3 [ 2dup swap 1- swap <rot <swap [ hanoi ] push2 -rot ]

: hanoi [ [ over 0? ] [ pop pop ] [ hanoi-1 hanoi-2 hanoi-3 pop pop cat cat i ] ifte ]

4 [ 1 2 3 ] hanoi
