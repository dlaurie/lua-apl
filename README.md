Lua⋆APL
=======

© Dirk Laurie 2013 Lua-style MIT licence

Lua⋆APL is Lua powered by APL. (That's an APL pun.) If the symbol between Lua and APL in Lua⋆APL does not look like a five-pointed star, chances are the rest will look unintelligible too. Get yourself a proper APL-enabled screen font as described in [UTF-8 essentials](#utf-8-essentials).

The main module table contains mostly Lua functions with APL names, by and large doing what the corresponding APL functions would do, but operating on Lua numbers, strings, tables and functions.

Package contents
----------------

    apl.lua          -- Returns the module table
    help.lua         -- Returns the required module 'help'
    test.lua         -- Tests a large selection of features
    finnaplidiom.lua -- A Lua module containing the FinnAPL idiom library,
                        needed by test.lua.
    apl385.ttf       -- A public-domain APL font by Adrian Smith
    lua-apl.xmodmap  -- APL key mappings for X
    README.md        -- What you are reading now
    apl.c            -- Supporting routines in C 
    lctype-utf8.c    -- Replacement for lctype.c providing support for 
                        UTF-8 characters in Lua names
    lua-apl.c        -- Replacement for lua.c allowing immediate 
                        evaluation and display of APL expressions

UTF-8 essentials
----------------

There are three things, or rather four, that you must do before using the Lua⋆APL package.

1.  Get a UTF-8 font with decent APL glyphs. `apl385.ttf` is recommended. On Linux systems you put it in `$HOME/.fonts` and select it from your application's font selector. I'm told it is even easier on Windows systems.

2.  Configure an APL keyboard. I don't mean a physical APL keyboard, I mean that you must have a reasonably easy way to type APL characters, for example via the keyboard's Level-3 and Level-4 character sets, associated with the AltGr key.

    On systems that use X-windows you can run `xmodmap lua-apl.xmodmap`, after of course having first backed up your present settings by `xmodmap -pke > original.xmodmap`.

    On my keyboard, doing that produces the following layout:

          ~ ⍬  ! ⌶  @ ⍫  # ⍒  $ ⍋  % ⌽  ^ ⍉  & ⊖  * ⍟  ( ⍱  ) ⍲  _ −  + ⌹
          ` ⋄  1 ¨  2 ¯  3 <  4 ≤  5 =  6 ≥  7 >  8 ≠  9 ∨  0 ∧  - ×  = ÷

                Q    W    E ⍷  R    T    U    Y    I ⍸  O ⍥  P    { ⊣  } ⊢  | ⍙
                q    w ⍵  e ∊  r ⍴  t ∼  u ↓  y ↑  i ⍳  o ○  p ⋆  [ ←  ] →  \ ⍀

                 A    S ⌷  D    F ≡  G ⍒  H ⍋  J ⍤  K    L ⍞  : ⍂  " ⌻
                 a ⍺  s ⌈  d ⌊  f _  g ∇  h ∆  j ∘  k    l ⎕  ; ⊢  ' ⊣ 

                  Z    X    C ⍝  V    B ⍎  N ⍕  M    <    > ∵  ?
                  z ⊂  x ⊃  c ∩  v ∪  b ⊥  n ⊤  m ∣  , ⍪  , ⍀  / ⌿       

    In each 2x2 matrix, right column requires AltGr, top row requires Shift. The four-symbol combinations should come out the same on your keyboard too, but their positions probably will not.

    Some characters are available on both keyboards, but beware: AltGr `∼∧⋆−∣` may look the same but are non-ASCII. There are no commonly accepted non-ASCII alternatives for `<>+=.,!?/\`, otherwise I would have used them too. The difference matters only at the Lua level: inside an APL expression, you may use either of the look-alike characters.

3.  Rebuild your Lua so that 2-byte and 3-byte UTF-8 codepoints look like Lua names. You need to replace the original `lctype.c` file by the file `lctype-utf8.c` supplied here and do `make linux` or `make mingw` etc again. You may like to go the whole hog and also replace `lua.c` by the file `lua-apl.c`. See [Installing the APL interpreter](#installing-the-apl-interpreter).

    An unmodified Lua gives the following error message when `apl.lua` is loaded:

    lua: apl.lua:3: <name> expected near char(226).

4.  Nothing to do with UTF-8, but you must follow the instructions are given in the comments to `apl.c` in order to get the module `apl_core`.

Quick start
-----------

We'll do this as a transcript of an interactive session at a terminal running `bash`. The resulting experience has quite a realistic APL-like look and feel.

The first few lines show how to use APL as a desk calculator.

The next few lines show how to define Lua functions in APL.

The last few lines show how to get interactive help.

    …/apl$ apl     # The APL-enabled Lua interpreter
    Lua 5.2.2  Copyright (C) 1994-2013 Lua.org, PUC-Rio
    Lua⋆APL 0.1
    The following forward declarations were not completed
    Contents: MatrixDivide MatrixInverse
    WARNING: Not all functions that should respect shape do so yet.
       -- That's why it's still only 0.1

       n=10    -- this is straight Lua
       (n,n)⍴(n+1)↑1  -- this is APL code to be evaluated immediately
    1 0 0 0 0 0 0 0 0 0
    0 1 0 0 0 0 0 0 0 0
    0 0 1 0 0 0 0 0 0 0
    0 0 0 1 0 0 0 0 0 0
    0 0 0 0 1 0 0 0 0 0
    0 0 0 0 0 1 0 0 0 0
    0 0 0 0 0 0 1 0 0 0
    0 0 0 0 0 0 0 1 0 0
    0 0 0 0 0 0 0 0 1 0
    0 0 0 0 0 0 0 0 0 1

       return ⍎'(n,n)⍴(n+1)↑1' -- The same code when played back
       -- duplicate printout not shown here
      
       f=∇"(n,n)⍴(n+1)↑1" -- the same code as a function definition
       n=3                -- redefining the global variable
       =f()               -- executing it
    1 0 0
    0 1 0
    0 0 1
       
       g=∇"(⍵,⍵)⍴(⍵+1)↑1" -- replacing the global variable by an argument
       =g(5)              -- executing it
    1 0 0 0 0
    0 1 0 0 0
    0 0 1 0 0
    0 0 0 1 0
    0 0 0 0 1

       h=∇"⍺÷⍵"       -- a function of two arguments
       return h(5,8)  -- ⍵ is the first, ⍺ the second (explanation below)
    1.6

       =lua(g)        -- Show the Lua code that is actually executed
    ∇: ⍴(↑(1,plus(1,⍵)),comma(⍵,⍵))

       help(apl)
    Contents: ! + , . / < = > ? NaN \ _F _V backslash comma dot equal
        greater less lua plus query set⍵ set⍺ shriek slash × ÷ ↑ ↓ ∇
        ∊ − ∘ ∣ ∧ ∨ ∼ ≠ ≤ ≥ ⊖ ⊤ ⊥ ⋆ ⌈ ⌊ ⌷ ⌽ ⌿ ⍀ ⍉ ⍋ ⍎ ⍒ ⍕ ⍟ ⍪ ⍱ ⍲ ⍳ ⍴ ○

       help"⍳"
    1. IndexGenerator: ⍳⍵ → {1,2,...,⍵}
    2. ⍺⍳⍵ → position of first occurrence of ⍵ in ⍺; not found is #⍺+1

The above is probably not quite the same as what the current version would give (that applies to all the other examples too) but you get the idea.

APL functions are *niladic* (no arguments), *monadic* (one argument on the right of the name) or *dyadic* (two arguments, one to the left and one to the right of the name). In function definitions, the left and right arguments have the reserved names `⍺` and `⍵` respectively; a niladic function has neither.

An APL function can called from Lua by giving `⍵` as first and `⍺` as second argument, i.e. `3÷5` and `apl.÷(5,3)` do the same thing. This is confusing at first, but quite logical: the argument that might not be there is `⍺`, so it must come second.

Niladic functions cannot be called from APL.

Installing the APL interpreter
------------------------------

Make a fresh copy of the 5.2.2 Lua source directory, copy the supplied `lctype-utf8.c` and `lua-apl.c` to replace `lctype.c` and `lua.c`, edit the Makefile in the Lua source directory to suit your environment, putting

    MYCFLAGS=-DLUA_PROMPT='"   "' -DLUA_PROMPT2='"   > "'

so that your session will look like an APL session instead of a Lua session, and do `make linux` or `make mingw` or whatever is appropriate for your system.

Copy the Lua executable you have just made to your execution path, changing its name to `lua-apl` or `lua-apl.exe`. Create a batch file, bash script or alias so that typing `apl` will invoke

    lua-apl -l apl -e "apl()" -i

Make sure that `apl.lua` and `apl-core.so` or `apl-core.dll` are properly installed and your keyboard is APL-enabled, and type `apl`.

### What does the APL interpreter do?

The features of the modified interpreter are available for interactive use only. If you plan to use the APL functions only non-interactively. you don't need to replace `lua.c`. Replacing `lctype.c` is not negotiable: the module `apl.lua` will not load otherwise.

1.  Four functions are put into the global namespace by "`-e apl()`". The interactive interpreter will not work without the first two, and the other two are convenient to have.

    -   `∇`: load APL code as a function
    -   `⍎`: load and execute APL code
    -   `lua`: return the Lua code of a function
    -   `help`: interactive help

2.  When you enter a line of code, the interpreter decides whether it is Lua code or APL code, according to the following rules:

    -   If the line contains a single or double quote, it cannot be APL.
    -   Otherwise, the number of alphabetic ASCII characters and of bytes outside the ASCII range are compared. If there are more non-ASCII bytes than alphabetic characters, the line is taken to be APL.

An APL line is modified to return the result of a call to the APL execute function `⍎`. This modification goes into the history buffer, in the same way as `=` is changed to `return` in a Lua chunk.

To force a line containing a UTF-8 character to be interpreted as Lua, rephrase it so it contain a quote somewhere. To force a line with many alphabetic characters to be interpreted as APL, invoke the APL definition or execute function `∇` or `⍎` explicitly.

### How does the APL compiler work?

The example above shows the APL code `(⍵,⍵)⍴(⍵+1)↑1` as being translated into the Lua code `⍴(↑(1,plus(1,⍵)),comma(⍵,⍵))`, which may look a lot like APL still but is actually a fully valid Lua expression when executed in an environment that knows the APL functions by global names.

That translation is not the full truth, though. The APL code is in fact translated to

    local function (...)
    local ⍵,⍺=... 
    local function set⍺(v) ⍺=v return v end 
    local function set⍵(v) ⍵=v return v end 
    return ⍴(↑(1,plus(1,⍵)),comma(⍵,⍵))
    end

This function is created by the standard Lua `load` function, with the table `apl` provided as its environment. Therefore `⍴` is the function you can call from the command line as `apl.⍴`, etc.

The `set⍺` and `set⍵` functions are provided so that there is a way to set the values of the local variables `⍺` and `⍵` by function calls, e.g.

       =lua(∇"(⍺←⍺+⍵)⋆⍵")
    ∇: ⋆(⍵,set⍺(plus(⍵,⍺)))

The APL compiler has rudimentary support for finding syntax errors. It displays the source and indicates the first character such that the substring up to the previous position is still valid APL code, but that no further progress is possible. For parenthesized expressions, this may be long before the actual error, but otherwise it can come quite close.

APL syntax depends on knowing whether a name refers to a function, a monadic operator, a dyadic operator or a value. For the built-in functions, this information is predefined, but for user-defined functions, the function or operator must be registered. An unregistered name in an APL expression is always assumed to refer to a value.

You register a function as follows:

       apl.make_function('%',{∇"⍵÷100",∇"⍺×⍵÷100",lua='percent',
         alias='p',expand=3,help=[[
    1. Percent: %⍵ → ⍵/100
    2. PercentOf: ⍺%⍵ → ⍺×⍵/100]]})

which can then be used as

       return ⍎"5 10 20%400"
    20 40 80

or as

       return ⍎"5 10 20p 400 600 800"
    20 60 160

Note the space after `p`, otherwise `p400` would be parsed as a name. `help(apl.make_function)` tells more, including how to register an operator.

General design
--------------

Most of the functions in the module table have one-character names, and most of those names are non-ASCII UTF-8 codepoints actually occupying two or three bytes. The characters are traditional APL characters, e.g. `×`, but they are not special characters. They look like names to the patched Lua 5.2, and they need to be separated from other names just like the usual names.

In some cases, the one-character name is an ASCII character, e.g. `+`. These have been kept to an absolute minimum, and non-ASCII equivalents as described under **UTF-8 Essentials** have been used whenever possible. Whenever the function name is a non-alphabetic ASCII character, an alias consisting of alphabetic characters has been provided, e.g. `plus`.

The functions do what one could expect the corresponding APL functions to do, except that the values they act on are Lua values: numbers, strings, tables and functions. They all take one or two arguments, traditionally called ⍺ and ⍵, and return one value.

Although an APL reference manual would be useful (e.g. `APlusRefV2_8.html` as installed by the `aplus-fsf-doc` package) there is no attempt to reproduce the exact behaviour of any current APL implementation. *The definition of the function is what it says in the interactive help for it,* which often is simply its Lua code.

You get help by giving the symbolic name as argument.

       help'+'
    1. Clone: +⍵ returns an exact copy of ⍵
    2. Add = function(⍵,⍺) return ⍺+⍵ end

You get some kind of help by giving the function itself, but this is not always very informative.

       help(apl.plus)
             function(⍵,⍺) return (⍺ and f2(⍵,⍺)) or f1(⍵) end

`help(apl.plus)` is the as same `help(apl.×)` and many others. All it says is that `plus` can be used monadically, when `f1` is invoked, or dyadically, when `f2` is invoked. It does not even tell you what `f1` and `f2` are.

For APL functions that you defined yourself, `help` prints the APL code and `lua` gives the Lua code as a string.

       f=∇"⍵/(1+⍺)"
       help(f)
    ⍵/(1+⍺)
       =lua(f)
    ∇: slash(plus(⍺,1),⍵)

APL types vs Lua types
----------------------

From here onwards, "APL" will mean "the dialect of APL supported by Lua⋆APL". This is mostly APL⋆PLUS (from which the APL star in the name has been borrowed), but without the things Lua does better: program structure, strings, IO etc. So there are no numbered program lines and no `→` instructions; no character vectors and no string constants; no `⎕` for standard input and output.

APL recognizes four types: functions, scalars, vectors and matrices. These are accommodated directly in Lua types as follows:

-   APL scalars are Lua numbers or strings. Most APL functions do not distinguish these in cases where Lua would not, e.g. `×('3','4')` will happily return the number `12`.

-   APL functions are Lua functions.

-   APL vectors are origin-1 Lua tables. There should be no holes, i.e. positive integer indices for which `tbl[k]==nil` but `tbl[k+1]~=nil` are illegal. Vectors of vectors can be handled by some functions.

-   APL matrices are origin-1 Lua tables like APL vectors, but have a field `shape` which contains a table with two numbers, the number of rows and columns.

Mapping from Lua to APL is done by the squish function, which converts a vector of vectors to a matrix with the given rows. This can be called from Lua or from APL.

       A=apl.⌷{{1,2,3},{4,5,6}}
       =A
    1 2 3
    4 5 6
       =apl.⌷(A.shape)
    2 3
       t={{1,2,3},{4,5,6}}
       ⌷t
    1 2 3
    4 5 6

You can unsquish too:

Some APL functions require that numeric values actually be integers or 0-1 quantities. Their behaviour when given invalid arguments is undefined: they may in some way still work; there may be a test for the required property; there may be a Lua error message; they may quietly return nonsense.

### Booleans

APL has no Boolean type. APL comparison and logical functions return 0 or 1, *both of which are `true` to Lua*. The squish function `⌷` converts Booleans to 0-1 values.

### Nil

APL does not have a concept of `nil`. The squish function `⌷` converts nils to `NaN`, which has the type `"number"` even though it is not-a-number. All arithmetic operations involving `NaN` have result `NaN`; all APL comparison operations involving `NaN` have result `0`, even `NaN==NaN`.

### Strings

Lua strings are treated as scalars. APL-style characters and character matrices are not supported, and the use of string-valued arguments to any APL function except `⍎` and `⍕` does not form part of the design of Lua⋆APL. The coherence of both APL and Lua is so good that useful results may well in some cases be obtained from string arguments, but that kind of usage is at this stage an unsupported lucky coincidence.

APL operations on strings are handled by converting them to vectors of byte values.

       x=apl.⌷"⍺-⍵"
       =x
    226 141 186 45 226 141 181

### Tables

Even though holes are illegal, it is very inefficient to test for them all the time. Like the Lua table library, therefore, APL relies internally on the built-in length operator `#` to give the length of arrays. If you create all your APL tables via built-in APL functions, including `⌷`, this should not be a problem. If an APL function ever returns an array with a hole, it is a bug that I would like to be informed of.

All APL functions accept any Lua array, but returned arrays are APL arrays. The only difference is that APL arrays are provided with a metatable, which defines a `tostring` function reminiscent of how APL implementations print arrays, and metamethods for the arithmetic operations, indexing and concatenation. Arrays passed to APL functions may on return be found to have acquired this metatable. It is not considered to be a bug when this happens.

APL matrices differ from APL vectors in having a `shape` field. The presence of this field influences the behaviour of many functions, most of which however have not been implemented at this stage. The shape is a two-element vector giving the number of rows and columns respectively.

### Functions

Any Lua function is a valid APL function too. However, there are a few things to bear in mind.

-   Make sure that your return values are valid APL values, for example by passing them through the squish function `⌷`.

-   APL thinks of all functions as having the header `function(⍵)` or `function(⍵,⍺)` and returning one value. It can deduce from the syntax whether a function is called monadically or dyadically.

### Other Lua types

All other types are considered to be scalars, and the chance that APL can use them sensibly is remote. However, you may be programmming in a mixture of Lua and APL, using APL as a sort of greatly extended table library. If you keep them as values in tables with keys not recognized by APL, there should not be a problem.

Using the functions directly from Lua
-------------------------------------

The Lua⋆APL module (loaded say as `apl`) does not place anything in the global namespace. You access the functions as `apl.⍴`, `apl.plus`, `apl['+']` etc. This is intolerable for the very commonly used `apl.∇` and `apl.⍎`, so `apl` has been made callable to put these two functions as well as `lua` and `help` into `_ENV`.

If you use any other function often enough, it quickly becomes tiresome to type "`apl.`" in front of it every time. So for the rest of this discussion I will assume that the required function has been made visible in the current namespace, whether as a global, a local or an upvalue.

Functions with UTF-8 names are easiest. You write `⋆⍵` in APL to compute the exponential function; you write `⋆(⍵)` in Lua. If `⍵` is an array, the function is applied term-by-term.

       =⋆{1,2,3}
     2.71828  7.38906 20.08554

You write `⍺⋆⍵` in APL to compute the power function; you write `⋆(⍵,⍺)` in Lua. You only need `⋆(⍵,⍺)` if neither of `⍺` and `⍵` is an APL array, otherwise `a^⍵` will also work.

For the power function, as for most of the standard arithmetic and comparison functions, `(⍵,⍺)` can be any combination of scalar and array. If both terms are arrays, they must be of equal length.

       ⋆({1,2,3},{4,5})
    ./apl.lua:454: array arguments of unequal size
    stack traceback:
        [C]: in function 'error'
        ./apl.lua:454: in function 'f2'
        ./apl.lua:467: in function '⋆'
        stdin:1: in main chunk
        [C]: in ?
       =⋆({1,2,3},{6,5,4})
     6 25 64

APL operators look exactly APL functions from the Lua point of view, but have different semantics. The arguments to operators are functions, and the result is also a function. Since monadic operators have only a left operand, the operands to a dyadic operator are (left,right), not (right,left) as for functions.

       prod = ⌿(×)
       =prod(⍳(6))
    720
       cumprod = ⍀(×)
       =cumprod{1,2,3,4,5,6}
    1 2 6 24 120 720
       dotprod = dot(plus,×)
       =dotprod({3,4,5},{1,-2,1})
    0

System variables
----------------

Variables whose names start with `⎕` are reserved for system variables, that is, APL variables on which the behaviour of certain functions may depend.

At present, the following system variables are recognized.

⎕format  
The format to be used by monadic `⍕`. This must be a Lua format string with one slot, e.g. `%.14g`.

⎕pp  
The number of digits appearing after the decimal point in the format used by monadic `⍕` when there is no `⎕format`. This will be used to generate an appropriate format for the particular value being formatted. It is ignored if only integers need to be

Using the functions via the APL compiler
----------------------------------------

The `∇` function creates a Lua function from a given string by parsing it as an expression written in APL, according to the APL syntax rules:

1.  The right argument of a function is all of the rest of the expression.
2.  The left argument of a function is only the single operand to the left of it.
3.  Parentheses may be used to override the first two rules.
4.  The left argument of an operator is only the single operand, to the left of it, which must be a function.
5.  The right argument of a dyadic operator is the single operand to the right of it.

An APL expression may freely use the ASCII names of functions, even when that name is a single special character. The Lua equivalent, being valid Lua code, will contain either a non-ASCII name or an alphabetic alias.

The resulting Lua functions may be nil-adic, monadic or dyadic, i.e. they take no arguments `()`, one argument `(⍵)` or two arguments `(⍵,⍺)`. The specific names `⍺` and `⍵` must be used. When called from APL, `⍺` refers to the left argument and `⍵` to the right argument.

You can't return the function generated by an operator as you can directly from Lua. I.e. in Lua `f=slash(plus)` is perfectly legal, but in an APL expression you must give arguments, i.e. `f=∇"+/⍵"`.

A nil-adic function can be evaluated immediately by using `⍎` instead of `∇`. The result is a Lua value. An APL function can only return `nil` if there was an error.

APL expressions may contain user variables.

       x={1,2,3}
       =⍎'+/÷x'
    1.8333333333333

Lua⋆APL searches for these variables first in `apl._V` (or simply `_V` if you invoked `apl()`). If not found, tries the environment (i.e. `_ENV`).

The names recognized inside APL expressions are more restricted than those recognized inside Lua. Only the first character may be a non-ASCII UTF-8 codepoint, and that codepoint must not be the name of an APL function.

For forward compatibility, it is wise not to start a name with any of the currently unused symbols on the APL keyboard given above.

In an APL expression, user-defined functions may be used, but they must already have been defined as functions at compilation time, whether in `_V` or in `_ENV`.

       s1=∇'f*g⍵' -- assumes f and g are non-functions
    ./apl.lua:171: bad input to apl2lua: two adjacent non-functions
    f*g⍵
       ↑

       g=load''   -- a dummy function
       s2=∇'f*g⍵' -- assumes g is a function
       =lua(s2)   --> ⋆(g(⍵),f)  
    local ⍵,⍺=... return ⋆(g(⍵),f)

       f=load''
       s3=∇'f*g⍵' -- assumes f and g are functions 
       =lua(s3)   --> f(⋆(g(⍵)))
    local ⍵,⍺=... return f(⋆(g(⍵)))

Note that all names used in an APL expression are non-local. That implies that the function `f` executed when you finally evaluate `s2` will be whatever value `f` has then.

Notes on specific functions
---------------------------

`∇"APL source"`  
The result is always a function of two arguments, as described in [How does the APL compiler work?](#how-does-the-apl-compiler-work).

Calling this function from inside an APL expression is less versatile: the string arguments needs to have been created earlier since string-valued constants are not supported inside APL expressions.

`⌷(⍵)`  
Lua-to-APL conversion. This is not a standard APL function and will normally only be called from Lua.

-   If `⍵` is nil, it is replaced by `NaN`.
-   If `⍵` is boolean, it is replaced by a 0-1 value.
-   If `⍵` is a string, it is converted to an array of byte values.
-   If `⍵` is any other scalar, it is returned unchanged by `⌷⍵`. This is unlikely to be useful except in the case of a number.
-   If `⍵` is a table, and none of the entries in `⍵` is itself a table, `⍵` is converted to an APL table by setting its metatable, and returned. No new table is created.
-   Otherwise the entries in `⍵` must all be tables of the same length, and an APL matrix of which they are the columns is created.

`⍕(⍵,⍺), ⍺⍕⍵`  
The dyadic format function uses a number as format: `12` means `%12d`, `12.6` means `%12.6f` and `¯12.6` means `%12.6e`. You can't have more than 9 digits after the decimal point. An array of numbers can be given: they apply term-by-term if `⍵` is a vector and columnwise if `⍵` is a matrix.

You can also supply a string-valued format or array of formats.

`⍺←⍵`  
The assign function `←` stores `⍵` in `apl._V` at the key `⍺`. This value takes precedence over a global Lua variable with the same name. If `⍵` is a function, the assignment is final. Any later assignment with key `⍺` is an error. The reason for this is that the APL compiler sees `⍺` before it sees `←` and does different things depending on whether `⍺` is a function.

You can force reassignment by calling `←` from Lua: `←(⍵,⍺)`.

`⍺/⍵`, `⍺⌿⍵`, `⍺\⍵`, `⍺⍀⍵`  
When given an empty argument `⍵`, the reduce operators return the unit of the function `⍺` e.g. `⌈/0⍴0` returns `-Inf`, or raise an error if no unit is defined. The scan operators always raise an error if no unit is defined. At present only the associative dyadic functions `+ − ∨ ∧ ⌈ ⌊` have units, and there is no mechanism to define other units.

`make_function` :

* * * * *

The single-purpose APL routines
-------------------------------

The basic routines defining Lua⋆APL are delivered in the subtables of `apl._F`. The routine names are mostly commonly used in APL documentation, such as `Ravel`.

The subtables are classified as follows:

    `numeric1`: monadic scalar numeric
    `numeric2`: dyadic scalar numeric
    `monadic`: other monadic
    `dyadic`: other dyadic 
    `other`: functions with special syntax or operating on Lua types

The basic numeric functions are defined for scalar arguments only. The actual functions known to the APL compiler have been wrapped to expand to non-scalar arguments. You can see whether this has been done by printing the function addresses:

print(apl.plus,apl.\_F.numeric2.Add) function: 0x815d7e0 function: 0x8168248

* * * * *

The core C routines
===================

These have been adapted from other packages, especially `xtable` by John Hind and myself They are delivered in a table returned by require `apl_core`.

Block functions
---------------

Block functions all have a table and two integers as their first three arguments. The notation `tbl[a:b]` is used for a block of values with increasing keys if `a<b` and decreasing keys if `a>b`. Thus `tbl[b:a]` is the reverse of `tbl[a:b]`.

* * * * *

### `get(tbl,a,b)`

Returns `tbl[a:b]`. This function may cause stack overflow if too many items are requested.

* * * * *

### `move(tbl,a,b,c[,d])`

Moves `tbl[a,b]` to `tbl[c,d]`, overwriting whatever was there. If `d` is omitted, it is calculated so that `b-a=d-c`. Returns `tbl`.

* * * * *

### `pick(tbl,a,b,fct[,count])`

If `count==1`, returns the first index `i` in `a:b` such that `fct(tbl[i])` is true. If `count>1`, ignores the first `count-1` hits. If `fct` is not a function or if `count<1,` returns nil.

* * * * *

### `set(tbl,a,b,...)`

Sets `tbl[a:b]` to the given values, overwriting existing values.

If the vararg list is empty (not even containing `nil`), stores nothing. The list is treated cyclically: if it is exhausted before `b` is reached, the supply of values is resumed from its beginning. If `b` is nil, values are stored in `tbl[a],tbl[a+1],...` until the list is exhausted. Returns `tbl`.

* * * * *

### `transpose(tbl,a,b,target)`

Stores the transpose of `tbl[1:a*b]` in `target[1:a*b]`. `tbl` is assumed to contain `a` blocks of `b` elements, and `target` will contain `b` blocks of `a` elements. Returns `target`.

`tbl` and `target` are not allowed to be the same array.

* * * * *

### `sort(tbl,a,b[,cmp])`

Sorts `tbl[a:b]` by insertion.

* * * * *

### `merge(tbl,low,middle,high[,cmp])`

Merges `tbl[low:middle]` with `tbl[middle+1:high'` according to `cmp` (specified as for the standard `table.sort`). Both halves are assumed to be already sorted.

Other functions
---------------

### `keep(count,...)`

Returns `count` arguments, starting at the first extra argument. As in the case of `select`, a negative number indexes from the end (-1 is the last argument).

* * * * *

### `map(ft,...)`

Each return value is the result of `ft` applied to the corresponding value in the tuple.

"Applying" means indexing if `ft` is a table and calling if `ft` is a function, which is assumed to be unary with one return value.

* * * * *

### `where(level)`

Returns a string identifying the point in the source code from which `where` is being called if `level=1`, the point from which that routine was called if `level=2`, etc.
