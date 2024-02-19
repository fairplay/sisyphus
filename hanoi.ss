: <swap [ pull pull pull -rot swap rot push push push ]
: <rot [ pull pull pull pop rot [ ] push push push ]

: hanoi-1 [ over over swap 1- swap <swap [ hanoi ] 2push -rot ]
: hanoi-2 [ dup pull pull pull rot pop 2push fence -rot ]
: hanoi-3 [ over over swap 1- swap <rot <swap [ hanoi ] 2push -rot ]

: hanoi [ [ over 0 eq? ] [ pop pop ] [ hanoi-1 hanoi-2 hanoi-3 pop pop cat cat i ] ifte ]

4 [ 1 2 3 ] hanoi
