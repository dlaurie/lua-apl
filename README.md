Lua⋆APL
=======

© Dirk Laurie 2013 Lua-style MIT licence

Lua⋆APL is a module of Lua functions with APL names, by and large doing what the corresponding APL functions would do, but operating on Lua numbers, strings, tables and functions.

Contents
--------

    apl.lua     -- Returns the module table
    help.lua    -- Returns the required module 'help'
    test.lua    -- Tests a large selection of features
    apl385.ttf  -- A public-domain APL font by Adrian Smith
    apl.xmodmap -- APL key mappings for X
    README.md   -- This file
    apl.c       -- Supporting routines in C 
    lctype.c    -- Modified from the Lua source in order to provide
                   support for URF-8 names

UTF-8 essentials
----------------

There are three things, or rather four, that you must do before using the Lua⋆APL package.

1.  Get a UTF-8 font with decent APL glyphs. `apl385.ttf` is recommended. On Linux systems you put it in \$HOME/.fonts and select it from your application's font selector. I'm told it is even easier on Windows systems.

2.  Configure an APL keyboard. I don't mean a physical APL keyboard, I mean that you must have a reasonably easy way to type APL characters, for example via the keyboard's Level-3 and Level-4 character sets, associated with the AltGr key.

On systems that use X-windows you can run `xmodmap apl.xmodmap`, after of course having first backed up your present settings by `xmodmap -pke > original.xmodmap`.

On my keyboard, doing that produces the following layout:

      ~ ⍬  ! ⌶  @ ⍫  # ⍒  $ ⍋  % ⌽  ^ ⍉  & ⊖  * ⍟  ( ⍱  ) ⍲  _    + ⌹
      ` ⋄  1 ¨  2 ¯  3 <  4 ≤  5 =  6 ≥  7 >  8 ≠  9 ∨  0 ∧  - ×  = ÷
      
            Q    W    E ⍷  R    T    U    Y    I ⍸  O ⍥  P    { ⊣  } ⊢  | ⍙
            q ∣  w ⍵  e ∊  r ⍴  t ∼  u ↓  y ↑  i ⍳  o ○  p ⋆  [ ←  ] →  \ ⍀
      
             A    S ⌷  D    F ≡  G ⍒  H ⍋  J ⍤  K    L ⍞  : ⍂  " ⌻
             a ⍺  s ⌈  d ⌊  f _  g ∇  h ∆  j ∘  k    l ⎕  ; ⊢  ' ⊣ 
      
              Z    X    C ⍝  V    B ⍎  N ⍕  M    <    > ∵  ?
              z ⊂  x ⊃  c ∩  v ∪  b ⊥  n ⊤  m −  , ⍪  , ⍀  / ⌿       

In each 2x2 matrix, right column requires AltGr, top row requires Shift. The four-symbol combinations should come out the same on your keyboard too, but their positions probably will not.

Some characters seem to be available on both keyboards. In fact, only `<>` are on both; AltGr `∼∧⋆−∣` may look the same but are non-ASCII. There are no commonly accepted non-ASCII alternatives for `<>+=.,!?/\`, otherwise I would have used them too.

1.  Rebuild your Lua so that 2-byte and 3-byte UTF-8 codepoints look like Lua names. You need to replace the original `lctype.c` file by the one supplied here and do `make linux` or `make mingw` etc again. While you are at it, you may as well redefine the prompts to give your session three-fourths of an APL look by compiling with `-DLUA_PROMPT='"   "' -DLUA_PROMPT2='"      "'`.

An unmodified Lua gives the following error message when `apl.lua` is loaded:

    lua: apl.lua:3: <name> expected near char(226). 

1.  Nothing to do with UTF-8, but you must compile the module `apl_core` from `apl.c`. Instructions are given in the comments there.

Interactive help
----------------

Lua⋆APL provides help via the interactive help system in `help.lua`. This provides most of the specific documentation. You get started with `help()`.

Lua⋆APL puts `help` into the global namespace, because that is where it needs to be for interactive use. For the same reason, it is recommended that you put the APL functions in the global namespace (see how to do this below), but this is not the default.

Quick start
-----------

<<<<<<< HEAD
We'll do this as a lightly edited transcript of an interactive session at a terminal running `bash`. It's probably not the same as what the current version would give.
=======
We'll do this as a lightly edited transcript of an interactive session 
at a terminal running `bash`. It's probably not the same as what the 
current version would give.
>>>>>>> 843aa6bf5345c59638db7b35421e8e4379b20650

    …/apl$ lua-utf8     # That's my UTF-8 enabled rebuild of Lua
    Lua 5.2.1  Copyright (C) 1994-2012 Lua.org, PUC-Rio
    (UTF-8 version by DPL)

<<<<<<< HEAD
       apl = require"apl"  -- load the Lua⋆APL module
    The following forward declarations were not completed
    Contents: MatrixDivide MatrixInverse Transpose
       -- The author has lot of work still to do!
=======
   apl = require"apl"  -- load the Lua⋆APL module
The following forward declarations were not completed
Contents: MatrixDivide MatrixInverse Transpose
   -- The author has lot of work still to do!
>>>>>>> 843aa6bf5345c59638db7b35421e8e4379b20650

       help(apl)
    Contents: / _V comma equal greater less lua plus query shriek slash ×
        ÷ ← ↑ ∇ − ∣ ∧ ∨ ∼ ≠ ≤ ≥ ⊤ ⊥ ⋆ ⌈ ⌊ ⌽ ⍋ ⍎ ⍒ ⍕ ⍟ ⍱ ⍲ ⍳ ⍴ ○

       apl() -- loads all of the above into the global namespace

       help(⍳)
    IndexGenerator: ⍵ → {1,2,...,⍵}

       help(∇)
    Define: return APL expression compiled as a Lua function

       sum=∇"+/⍵"
       =sum(⍳(10))  -- This is Lua syntax for calling an APL function
    55
       =lua(sum)    -- The actual Lua code to which `∇"+/⍵"` translates. 
    local ⍵,⍺=... return slash(⍵,plus)

General design
--------------

Most of the functions in the module table have one-character names, and most of those names are non-ASCII UTF-8 codepoints actually occupying two or three bytes. The characters are traditional APL characters, e.g. `×`, but they are not special characters. They look like names to the patched Lua 5.2, and they need to be separated from other names just like the usual names.

In some cases, the one-character name is an ASCII character, e.g. `+`. These have been kept to an absolute minimum, and non-ASCII equivalents as described under **UTF-8 Essentials** have been used whenever possible. Whenever the function name is a non-alphabetic ASCII character, an alias consisting of alphabetic characters has been provided, e.g. `plus`.

The functions do what one could expect the corresponding APL functions to do, except that the values they act on are Lua values: numbers, strings, tables and functions. They all take one or two arguments, traditionally called ⍺ and ⍵, and return one value.

Although an APL reference manual would help (e.g. `APlusRefV2_8.html` as installed by the `aplus-fsf-doc` package) there is no attempt to reproduce exact behaviour of any existing APL implememtation. *The definition of the function is what it says in the interactive help for it,* which often is simply its Lua code.

There are two kinds of help:

1.  Help using the function itself, as in `help(∇)` above.
2.  Help using the function name, e.g. `help"+"`.

The first kind is always available, but is not always very informative.

    help(plus)
       apl[name] = function(⍵,⍺) return (⍺ and f2(⍵,⍺)) or f1(⍵) end

`help(plus)` is the as same `help(×)` and many others. All it says is that `plus` can be used monadically, when `f1` is invoked, or dyadically, when `f2` is invoked.

The second kind is not always available, but when it is, it is more informative than the first: it tells you what `f1` and `f2` are.

       help'plus'
    1. Identity = function(⍵) return ⍵ end
    2. Add = function(⍵,⍺) return ⍺+⍵ end

APL types
---------

APL works with numbers and characters, which may be either scalar or organized as a one-dimensional vector or a two-dimensional matrix. Lua⋆APL maps numbers to Lua numbers, and vectors and matrices to origin-1 Lua tables, which we will refer to as "arrays".

Lua strings are treated as scalars. APL-style characters and character matrices are not supported, and the use of string-valued arguments to any APL function except `⍎` and `⍕` does not form part of the design of Lua⋆APL. The coherence of both APL and Lua is so good that useful results may well in some cases be obtained from string arguments, but that kind of usage is unsupported.

Just like the Lua table library, Lua⋆APL relies on the built-in `#` function to give the length of arrays.

All APL functions accept any Lua array, but return APL arrays. The only difference is that APL arrays have a metatable, which defines a `tostring` function reminiscent of how APL implementations print arrays, and metamethods for the arithmetic operations and concatenation. Arrays passed to APL functions may on return be found to have acquired this metatable. It is not considered to be a bug when this happens.

APL matrices differ from APL vectors in having a `shape` field. The presence of this field influences the behaviour of many functions, most of which however have not been implemented at this stage. The shape is a two-element vector giving the number of rows and columns in the matrix.

Using the functions directly from Lua
-------------------------------------

I'm assuming that you have done `apl()` as above. When function names consist of one symbol, it quickly becomes tiresome to type `apl.` in front of them.

You write `⋆⍵` in APL to compute the exponential function; you write `⋆(⍵)` in Lua. If `⍵` is an array, the function is applied term-by-term.

       =⋆{1,2,3}
     2.71828  7.38906 20.08554

You write `⍺⋆⍵` in APL to compute the power function; you write `⋆(⍵,⍺)` in Lua. This is confusing at first, but quite logical: otherwise you would have had to write `⋆(nil,⍵)` to get the exponential function. You only need `⋆(⍵,⍺)` if neither of `⍺` and `⍵` is an APL array, otherwise `a^⍵` will also work.

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
      1   2   6  24 120 720
       dotprod = dot(plus,×)
       =dotprod({3,4,5},{1,-2,1})
    0

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

You can't return the function generated by an operator as you can directly from Lua. I.e. in Lua `f=slash(plus)` is perfectly legal, but in an APL expression you must give arguments, i.e. `f=∇"+/⍵"`. Since `f=∇"+/"` will not work as expected, the compiler disallows it.

A nil-adic function can be evaluated immediately by using `⍎` instead of `∇`. The result is a Lua value. An APL function can only return `nil` if there was an error.

The resulting experience has an APL-like look and feel. It could be made more so by patching `lua.c`, but the intention of Lua⋆APL is to give APL-like functionality from inside Lua, not to provide an implementation of APL. You can always write your own read-evaluate-print program.

APL expressions may contain user variables.

       x={1,2,3}
       =⍎'+/÷x'
    1.8333333333333

<<<<<<< HEAD
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
The result is always a function of two arguments, i.e. `function(...) <function body> end`. You can see the compiled `<function body>` using the function `lua`. It always starts with `⍵,⍺=...`.

Calling this function from inside an APL expression is less versatile: the string arguments needs to have been created earlier since string-valued constants are not supported inside APL expressions.

`⌷(⍵)`  
Lua-to-APL conversion. This is not a standard APL function and will normally only be called from Lua.

-   If `⍵` is not a table, it is returned unchanged by `⌷⍵`.
-   If none of the entries in `⍵` is itself a table, `⍵` is converted to an APL table by setting its metatable, and returned. No new table is created.
-   Otherwise the entries in `⍵` must all be tables of the same length, and an APL matrix of which they are the columns is created.

`⍕(⍵,⍺), ⍺⍕⍵`  
The dyadic format uses a number as format: `12` means `%12d`, `12.6` means `%12.6f` and `¯12.6` means `%12.6e`. You can't have more than 9 digits after the decimal point. An array of numbers can be given: they apply term-by-term if `⍵` is a vector and columnwise if `⍵` is a matrix.

`⍺←⍵`  
The assign function `←` stores `⍵` in `apl._V` at the key `⍺`. This value takes precedence over a global Lua variable with the same name. If `⍵` is a function, the assignment is final. Any later assignment with key `⍺` is an error. The reason for this is that the APL compiler sees `⍺` before it sees `←` and does different things depending on whether `⍺` is a function.

You can force reassignment by calling `←` from Lua: `←(⍵,⍺)`.

`⍺/⍵`, `⍺⌿⍵`, `⍺\⍵`, `⍺⍀⍵`  
When given an empty argument `⍵`, the reduce operators return the unit of the function `⍺` e.g. `⌈/0⍴0` returns `-Inf`, or raise an error if no unit is defined. The scan operators always raise an error if no unit is defined. At present only the associative dyadic functions `+ − ∨ ∧ ⌈ ⌊` have units, and there is no mechanism to define other units.

System variables
----------------

Variables whose names start with `⎕` are reserved for system variables, that is, APL variables on which the behaviour of certain functions may depend.
=======
Lua⋆APL searches for these variables first in `apl._V` (or simply
`_V` if you invoked `apl()`). If not found, tries the environment 
(i.e. `_ENV`).

The names recognized inside APL expressions are more restricted than 
those recognized inside Lua. Only the first character may be a 
non-ASCII UTF-8 codepoint, and that codepoint must not be the name 
of an APL function.

For forward compatibility, it is wise not to start a name with any 
of the currently unused symbols on the APL keyboard given above.

In an APL expression, user-defined functions may be used, but they
must already have been defined as functions at compilation time,
whether in `_V` or in `_ENV`.

~~~
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
~~~

Note that all names used in an APL expression are non-local. That
implies that the function `f` executed when you finally evaluate
`s2` will be whatever value `f` has then.

## Notes on specific functions

`∇"APL source"`
:   The result is always a function of two arguments, i.e. 
    `function(...) <function body> end`. You can see the compiled
    `<function body>` using the function `lua`. It always starts
    with `⍵,⍺=...`.

    Calling this function from inside an APL expression is less versatile:
    the string arguments needs to have been created earlier since
    string-valued constants are not supported inside APL expressions.

`⌷(⍵)`
:   Lua-to-APL conversion. This is not a standard APL function and will 
    normally only be called from Lua.

    - If `⍵` is not a table, it is returned unchanged by `⌷⍵`.
    - If none of the entries in `⍵` is itself a table, `⍵` is converted
    to an APL table by setting its metatable, and returned. No new table
    is created.
    - Otherwise the entries in `⍵` must all be tables of the same length,
    and an APL matrix of which they are the columns is created.
 
`⍕(⍵,⍺), ⍺⍕⍵`
:   The dyadic format uses a number as format: `12` means `%12d`, 
    `12.6` means `%12.6f` and `¯12.6` means `%12.6e`. You can't
    have more than 9 digits after the decimal point. An array of
    numbers can be given: they apply term-by-term if `⍵` is a
    vector and columnwise if `⍵` is a matrix.

`⍺←⍵`
:   The assign function `←` stores `⍵` in `apl._V` at the key `⍺`. This 
    value takes precedence over a global Lua variable with the same name. 
    If `⍵` is a function, the assignment is final. Any later assignment
    with key `⍺` is an error. The reason for this is that the APL
    compiler sees `⍺` before it sees `←` and does different things
    depending on whether `⍺` is a function.

    You can force reassignment by calling `←` from Lua: `←(⍵,⍺)`.

`⍺/⍵`, `⍺⌿⍵`, `⍺\⍵`, `⍺⍀⍵`
:   When given an empty argument `⍵`, the reduce operators return the 
    unit of the function `⍺` e.g. `⌈/0⍴0` returns `-Inf`, or raise an
    error if no unit is defined. The scan operators always raise an 
    error if no unit is defined. At present only the associative dyadic
    functions `+ − ∨ ∧ ⌈ ⌊` have units, and there is no mechanism to
    define other units.

## System variables

Variables whose names start with `⎕` are reserved for system variables,
that is, APL variables on which the behaviour of certain functions may 
depend.
>>>>>>> 843aa6bf5345c59638db7b35421e8e4379b20650

At present, the following system variables are recognized.

⎕format  
The format to be used by monadic `⍕`. This must be a Lua format string with one slot, e.g. `%.14g`.

⎕pp  
The number of digits appearing after the decimal point in the format used by monadic `⍕` when there is no `⎕format`. This will be used to generate an appropriate format for the particular value being formatted. It is ignored if only integers need to be formatted.

* * * * *

The core C routines
===================

These have been adapted from other packages, especially `xtable` by John Hind and myself. They are delivered in a table returned by require `apl_core`.

Block functions
---------------

Block functions all have a table and two integers as their first three arguments. The notation `tbl[a:b]` is used for a block of values with increasing keys if `a<b` and decreasing keys if `a>b`. Thus `tbl[b:a]` is the reverse of `tbl[a:b]`.

* * * * *

### `get(tbl,a,b[,inc])`

If `inc` is omitted or `abs(inc)==1`, returns `tbl[a:b]`. Otherwise goes in steps of `abs(inc)`. This function may cause stack overflow if too many items are requested.

* * * * *

### `map(tbl,a,b,ft,target)`

`ft` is applied to the values in `tbl[a:b]` and the result stored in `target[a:b]`. `tbl` and `target` may be the same table.

"Applying" means indexing if `ft` is a table and calling if `ft` is a function, which is assumed to take one argument and return one value.

* * * * *

### `pick(tbl,a,b,fct[,count])`

If `count==1`, returns the first index `i` in `tbl[a:b]` such that `fct(tbl[i])` is true. If `count>1`, ignores the first `count-1` hits. If `fct` is not a function or if `count<1,` returns nil.

* * * * *

### `set(tbl,a,b,...)`

Sets `tbl[a:b]` to the given values, overwriting existing values.

If the vararg list is empty (not even containing `nil`), stores nothing. The list is treated cyclically: if it is exhausted before `b` is reached, the supply of values is resumed from its beginning. If `b` is nil, values are stored in `tbl[a],tbl[a+1],...` until the list is exhausted.

* * * * *

### `transpose(tbl,a,b,target)`

Stores the transpose of `tbl[1:a*b]` in `target[1:a*b]` and also returns it. `tbl` is assumed to contain `a` blocks of `b` elements, and `target` will contain `b` blocks of `a` elements.

`tbl` and `target` may not be the same array.

* * * * *

### `trisect(tbl,a,b,v[,cmp[,tag]]])`

Partially sorts `tbl[a:b]`. See the documentation of `xtable` for more information.

Other functions
---------------

### `keep(count,...)`

Returns `count` arguments, starting at the first extra argument. As in the case of `select`, a negative number indexes from the end (-1 is the last argument).

* * * * *

### `where()`

<<<<<<< HEAD
Returns a string identifying the point in the source code from which `where` is being called.
=======
⎕pp
:   The number of digits appearing after the decimal point in the
    format used by monadic `⍕` when there is no `⎕format`.  This
    will be used to generate an appropriate format for the particular 
    value being formatted.  It is ignored if only integers need to be
    formatted. 

---------------------------------------------------

About this file: The Markdown dialect used is that of Pandoc.
Although the Github display looks OK, you get even better results
by making an HTML using Pandoc and combining it with Github's
CSS.
>>>>>>> 843aa6bf5345c59638db7b35421e8e4379b20650
