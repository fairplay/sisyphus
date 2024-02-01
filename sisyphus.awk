BEGIN {
  delete Stack
  delete Dict
  delete Program_Stack

  Quotation = ""
  Level = 0
  Top = 0
  Defined = ""

  Program_Stack_Top = 0

  # Mode
  INTERPRET = 0
  COMPILE = 1
  QUOTE = 2
  DEFINE = 3

  COMMENT_NONE = 0
  COMMENT_INLINE = 1
  COMMENT_BLOCK = 2

  FALSE = "False"
  TRUE = "True"
  FAIL = "_"

  Mode = INTERPRET
  Comment_Mode = COMMENT_NONE
}

function error_failure() {
  print "Error: failure"
  exit
}
function error_stack_underflow() {
  print "Error: stack underflow"
  exit
}
function error_syntax_error(err) {
  print "Syntax error: " err
  exit
}
function error_redefine_error(word) {
  print "Error: attempt to redefine '" word "'"
  exit
}
function error_type_mismatch(data, type, where) {
  print "Error: '" data "' is not the type " type " in '" where "'"
  exit
}

function put_token(token) {
  Program_Stack[++Program_Stack_Top] = token
}

function put_tokens(tokens,    len, arr) {
  len = split(tokens, arr)
  for (i = len - 1; i >= 2; i--) {
    put_token(arr[i])
  }
}

function get_token(    x) {
  x = Program_Stack[Program_Stack_Top]
  delete Program_Stack[Program_Stack_Top--]
  return x
}

function program_stack_is_empty() {
  return Program_Stack_Top == 0
}

function stack_show(token,    result, i) {
    result = "|-"
    for (i = 1; i <= Top; i++)
        result = result " " Stack[i]
    print result " | " token
}

function add(token) {
  if (token == "") {
    return
  }
  Stack[++Top] = token
}

function clear() {
  Top = 0
}

function pop(    x) {
  x = Stack[Top]
  delete Stack[Top--]
  if (Top < 0)
    error_stack_underflow()

  return x
}

function dup() {
  add(Stack[Top])
}

function swap(    x, y) {
  x = pop()
  y = pop()
  add(x)
  add(y)
}

function over() {
  add(Stack[Top - 1])
}

function rot(    x, y, z) {
  x = pop()
  y = pop()
  z = pop()

  add(y)
  add(x)
  add(z)
}

function push(    st, x) {
  st = pop()
  x = pop()

  if (st !~ /^\[.+\]$/) {
    error_type_mismatch(st, "Stack", "push")
  }

  if (x == FAIL) {
    add(st)
    return
  }

  sub(/^\[/, "", st)
  add("[ " x "" st)
}

function pull(    st, x, tokens, count, end, i, counter) {
  st = pop()
  if (st !~ /^\[.*\]$/) {
    error_type_mismatch(st, "Stack", "pull")
  }

  count = split(st, tokens)
  if (count == 2) {
    add(FAIL)
    add(st)
    return
  }

  end = 0

  if (tokens[2] == "[") {
    for (i = 2; i < count; i++) {
      end += length(tokens[i]) + 1
      if (tokens[i] == "[") counter += 1
      if (tokens[i] == "]") counter -= 1
      if (counter == 0) break
    }
  } else {
    end += length(tokens[2]) + 1
  }

  x = substr(st, 3, end - 1)
  st = substr(st, end + 2)

  add(x)
  add("[" st)
}

function operation(op,    y, x) {
  y = pop()
  x = pop()
  if (op == "+") {
    add(x + y)
  }
  else if (op == "-") {
    add(x - y)
  }
  else if (op == "*") {
    add(x * y)
  }
  else if (op == "/") {
    add(int(x / y))
  }
  else if (op == "%") {
    add(int(x % y))
  }
  else if (op == "gt?") {
    x > y ? add(TRUE) : add(FALSE)
  }
  else if (op == "ge?") {
    x >= y ? add(TRUE) : add(FALSE)
  }
  else if (op == "lt?") {
    x < y ? add(TRUE) : add(FALSE)
  }
  else if (op == "le?") {
    x <= y ? add(TRUE) : add(FALSE)
  }
  else if (op == "eq?") {
    x == y ? add(TRUE) : add(FALSE)
  }
  else if (op == "ne?") {
    x != y ? add(TRUE) : add(FALSE)
  }
}

function lookup(    x) {
  x = tolower(pop())
  if (x in Dict)
    add(Dict[x])
  else
    add("_")
}

function execute(    x) {
  x = Stack[Top--]
  if (x ~ /^\[.*\]$/) {
    put_tokens(x)
  } else if (x == "_") {
    error_failure()
  }
  else {
    put_token(x)
  }
}

function define(defined, definition,    k) {
  k = tolower(defined)
  if (k in Dict) error_redefine_error(defined)
  Dict[k] = definition
}

function eval(token) {
  if (token == "[" && Mode != COMPILE && Mode != DEFINE) {
    Mode = COMPILE
  }

  if (Mode == QUOTE) {
    add(token)
    Mode = INTERPRET
  }
  else if (Mode == INTERPRET) {
    interpret(token)
  }
  else if (Mode == COMPILE || Mode == DEFINE) {
    compile(token)
  }
}

function compile(token) {
  if (token == "[") {
    Level += 1
  }
  if (token == "]") {
    Level -= 1
  }

  if (Level < 0)
    error_syntax_error("unbalanced square brackets")

  if (!Quotation)
    Quotation = token
  else
    Quotation = Quotation " " token

  if (Level == 0) {
    if (Mode != DEFINE) {
      add(Quotation)
      Mode = INTERPRET
    } else {
      if (!Defined) {
        Defined = Quotation
      }
      else {
        define(Defined, Quotation)
        Defined = ""
        Mode = INTERPRET
      }
    }
    Quotation = ""
  }
}

function interpret(token,    tokens, token_orig) {
  token_orig = token
  token = tolower(token)

  if (token == "clear") {
    clear()
  }
  else if (token == "pop") {
    pop()
  }
  else if (token == "dup") {
    dup()
  }
  else if (token == "swap") {
    swap()
  }
  else if (token == "over") {
    over()
  }
  else if (token == "rot") {
    rot()
  }
  else if (token ~ /^(\+|\-|\*|\/|%|eq\?|ne\?|lt\?|gt\?|le\?|ge\?)$/) {
    operation(token)
  }
  else if (token == "`") {
    Mode = QUOTE
  }
  else if (token == ":") {
    Mode = DEFINE
  }
  else if (token == "i") {
    execute()
  }
  else if (token == "push") {
    push()
  }
  else if (token == "pull") {
    pull()
  }
  else if (token == "lookup") {
    lookup()
  }
  else if (token in Dict) {
    put_tokens(Dict[token])
  } else {
    add(token_orig)
  }
}

{
  if (Comment_Mode = COMMENT_INLINE)
      Comment_Mode = COMMENT_NONE

  tokens = "|"
  for (i = 1; i <= NF; i++) {
    if ($i == "\\") {
      Comment_Mode = COMMENT_INLINE
      continue
    }

    if ($i == "(" && Comment_Mode)
      error_syntax_error("nested comments")

    if ($i == ")" && Comment_Mode != COMMENT_BLOCK)
      error_syntax_error("loose ')'")

    if ($i == "(") {
      Comment_Mode = COMMENT_BLOCK
      continue
    }

    if ($i == ")") {
      Comment_Mode = COMMENT_NONE
      continue
    }

    if (Comment_Mode)
      continue

    tokens = tokens " " $i
  }

  tokens = tokens " |"
  put_tokens(tokens)

  while (!program_stack_is_empty()) {
    token = get_token()
    if (STACK_DEBUG) stack_show(token)
    eval(token)
  }
}

END {
  if (Level != 0)
    error_syntax_error("unbalanced square brackets")

  if (IN_COMMENT)
    error_syntax_error("loose '('")

  print ""
  stack_show()
}
