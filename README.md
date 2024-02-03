# Sisyphus

Toy stack concatenative language implemented in AWK.

Named because of "pushing", get it?

## What is it?

Sysiphus is a toy concatenative language inspired by Joy <https://hypercubed.github.io/joy/joy.html>

It's written in AWK and tested under mawk and gawk and should works under any awk, I believe.

## Usage

Run the test suite for the Standard library with debug

```bash
cat stdlib.ss stdlib.test.ss | mawk -f sisyphus.awk -v STACK_DEBUG=1

...
( lots of cryptic stack states with the currently parsed token )
...

|-

( empty stack, no error means all tests are passed )

```

Run Hanoi towers algorithm without debug

```bash
$ cat stdlib.ss hanoi.ss | mawk -f sisyphus.awk -v STACK_DEBUG=0

|- [ 1 2 ] [ 1 3 ] [ 2 3 ] [ 1 2 ] [ 3 1 ] [ 3 2 ] [ 1 2 ] [ 1 3 ] [ 2 3 ] [ 2 1 ] [ 3 1 ] [ 2 3 ] [ 1 2 ] [ 1 3 ] [ 2 3 ] |
```

## Internals

There are two main stacks: Data and Program. Data stack is used for data representation, while Program is used for the tokens execution.
There is one Dictionary, where your own defined words are stored.

```
\ Word definition
: square [ dup * ]
```

## Data types

Sysiphus datatypes are:
- "atoms" (or "words", or "symbols"). Any sequence of characters without whitespaces is atom.
- "stacks". Do not mess them with the Data and Program stacks. Any group of atoms or stacks enclosed in `[ ]` is a stack,
  - e.g. `[ 1 2 [ dup * ] 4 [ [ 5 ] ] ]` NB! whitespaces after `[` or before `]` are required.
- "numbers". Technically they are just atoms interpreted as AWK numbers depending on the context.
- "booleans". Atoms `True` and `False`, theirs behavior is defined in `stdlib.ss`
- FAIL. Represented as underscore `_`

```
_ [ ] push  => [ ]
[ ] pull    => _ [ ]
_ i         => ( leads to failure )
```

## Primitives

There are several primitives well known by the similar stack-based or concatenative languages like Joy.


| Word                     | Operation                           | Example                              |
| ------------------------ | ----------------------------------- | ------------------------------------ |
| `+ - * / %`              | Arithmetic operations               | `32 5 + 6 % => 1`                    |
| `eq? ne? gt? lt? ge? le?`| Comparison predicates               | `5 2 eq?    => False`                |
| `clear`                  | Clears stack                        | `1 2 clear  =>`                      |
| `pop`                    | Pops the TOS content                | `1 2 pop   => 1`                     |
| `dup`                    | Duplicate the TOS                   | `1 2 dup   => 1 2 2`                 |
| `swap`                   | Swaps top 2 elements                | `1 2 swap  => 2 1`                   |
| `over`                   | Puts the second element on top      | `1 2 over  => 1 2 1`                 |
| `rot`                    | Rotates top 3 elements              | `1 2 3 rot => 2 3 1`                 |
| `push`                   | Pushes element to quoted stack      | `1 [ 2 3 ] push     => [ 1 2 3 ]`    |
| `pull`                   | Pulls element from the quoted stack | `[ [ x ] y z ] pull => [ x ] [ y z ]`|
| `lookup`                 | Looks in dictionary for definition  | `See below`                          |
| `i`                      | Interprets quoted stack or atom     | `5 [ dup * 1 + ] i  => 26`           |
| ``` ` ```                | Do not interpret the next atom      | ```1 2 ` over => 1 2 over```         |
| `:`                      | Define new words                    | `See below`                          |


## New words definition

You can define your own words, check `stdlib.ss` and `stdlib.test.ss`

For some reason I allowed to use stacks for the word definition, e.g.

```
: [ sqr 2 ] [ 4 ]

[ sqr 2 ]          \ => [ sqr 2 ]
[ sqr 2 ] lookup   \ => [ 4 ]
[ sqr 2 ] lookup i \ => 4

```
