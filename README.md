Lua⋆APL
=======

© Dirk Laurie 2013 Lua-style MIT licence

Lua⋆APL is a module of Lua functions with APL names, by and large doing what the corresponding APL functions would do, but operating on Lua numbers, strings, tables and functions.

Contents
--------

    apl.lua         -- Returns the module table
    help.lua        -- Returns the required module 'help'
    test.lua        -- Tests a large selection of features
    apl385.ttf      -- A public-domain APL font by Adrian Smith
    lua-apl.xmodmap -- APL key mappings for X
    README.md       -- This file
    apl.c           -- Supporting routines in C 
    lctype.c        -- Modified Lua kernel source providing support for 
                       UTF-8 characters in Lua names

UTF-8 essentials
----------------

There are three things, or rather four, that you must do before using the Lua⋆APL package.

1.  Get a UTF-8 font with decent APL glyphs. `apl385.ttf` is recommended. On Linux systems you put it in `$HOME/.fonts` and select it from your application's font selector. I'm told it is even easier on Windows systems.

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

3.  Rebuild your Lua so that 2-byte and 3-byte UTF-8 codepoints look like Lua names. You need to replace the original `lctype.c` file by the one supplied here and do `make linux` or `make mingw` etc again.

    An unmodified Lua gives the following error message when `apl.lua` is loaded:

    lua: apl.lua:3: <name> expected near char(226).

4.  Nothing to do with UTF-8, but you must follow the instructions are given in the comments to `apl.c` in order to get the module `apl_core`.

Quick start
-----------

We'll do this as a transcript of an interactive session at a terminal running `bash`. It's probably not the same as what the current version would give.

Lua⋆APL provides interactive help. For most of the functions, that is the only documentation available. You get started with `help()` and `help(apl)`. This is the only name that Lua⋆APL puts into the global namespace by default.

For the same reason, it is recommended that you put the Lua⋆APL functions in the global namespace (this is done below) but that is not the default.

    …/apl$ lua-utf8     # That's my UTF-8 enabled rebuild of Lua

       apl = require"apl"  -- load the Lua⋆APL module
    The following forward declarations were not completed
    Contents: MatrixDivide MatrixInverse
    WARNING: Not all functions that should respect shape do so yet.

       help(apl) -- help(tbl) lists all the keys of the table
    Contents: / \ _V backslash comma dot equal greater less lua plus query
        shriek slash × ÷ ← ↑ ↓ ∇ ∊ − ∘ ∣ ∧ ∨ ∼ ≠ ≤
        ≥ ⊖ ⊤ ⊥ ⋆ ⌈ ⌊ ⌷ ⌽ ⌿ ⍀ ⍉ ⍋ ⍎ ⍒ ⍕ ⍟ ⍪ ⍱ ⍲ ⍳ ⍴ ○

       apl()  -- loads all of the above into the global namespace

       help"⍳" -- this is the preferred way to get help
    1. IndexGenerator: ⍳⍵ → {1,2,...,⍵}
    2. ⍺⍳⍵ → position of first occurrence of ⍺ in ⍵

       help"∇" -- but it is not always available
    No help available, try help(∇).

       help(∇) -- in which case this alternative should work
    Define: return APL expression compiled as a Lua function

       n=10 -- names in the global Lua namespace are visible to APL code

       print(⍎"(n,n)⍴(n+1)↑1") -- this is how to run a piece of APL code
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

       sum=∇"+/⍵" -- this is how to load a function coded in APL

       print(lua(sum))    -- The actual Lua code to which `∇"+/⍵"` translates.
    local ⍵,⍺=... return slash(plus)(⍵)

       print(sum(⍳(10)))  -- Executing built-in APL functions via Lua syntax
    55

       print(⍎"sum ⍳10")  -- Executing built-in APL functions via APL syntax
    55

General design
--------------

Most of the functions in the module table have one-character names, and most of those names are non-ASCII UTF-8 codepoints actually occupying two or three bytes. The characters are traditional APL characters, e.g. `×`, but they are not special characters. They look like names to the patched Lua 5.2, and they need to be separated from other names just like the usual names.

In some cases, the one-character name is an ASCII character, e.g. `+`. These have been kept to an absolute minimum, and non-ASCII equivalents as described under **UTF-8 Essentials** have been used whenever possible. Whenever the function name is a non-alphabetic ASCII character, an alias consisting of alphabetic characters has been provided, e.g. `plus`.

The functions do what one could expect the corresponding APL functions to do, except that the values they act on are Lua values: numbers, strings, tables and functions. They all take one or two arguments, traditionally called ⍺ and ⍵, and return one value.

Although an APL reference manual would help (e.g. `APlusRefV2_8.html` as installed by the `aplus-fsf-doc` package) there is no attempt to reproduce the exact behaviour of any existing APL implememtation. *The definition of the function is what it says in the interactive help for it,* which often is simply its Lua code.

There are two kinds of help:

1.  Help using the function itself, as in `help(∇)` above.
2.  Help using the function name, e.g. `help"+"`.

The first kind is always available, but is not always very informative.

    help(plus)
       apl[name] = function(⍵,⍺) return (⍺ and f2(⍵,⍺)) or f1(⍵) end

`help(plus)` is the as same `help(×)` and many others. All it says is that `plus` can be used monadically, when `f1` is invoked, or dyadically, when `f2` is invoked. It does not even tell you what `f1` and `f2` are.

The second kind is not always available, but when it is, it is more informative than the first.

       help'plus'
    1. Identity = function(⍵) return ⍵ end
    2. Add = function(⍵,⍺) return ⍺+⍵ end

APL types vs Lua types
----------------------

From here onwards, "APL" will mean "the dialect of APL supported by Lua⋆APL".

APL recognizes four types: functions, scalars, vectors and matrices. These are accommodated directly in Lua types as follows:

-   APL scalars are Lua numbers or strings. Most APL functions do not distinguish these in cases where Lua would not, e.g. `×('3','4')` will happily return the number `12`.

-   APL functions are Lua functions.

-   APL vectors are origin-1 Lua tables. There should be no holes, i.e. positive integer indices for which `tbl[k]==nil` but `tbl[k+1]~=nil`.

-   APL matrices are origin-1 Lua tables like APL vectors, but have a field `shape` which contains a table with two numbers, the number of rows and columns.

Mapping from Lua to APL is done by the squish function, e.g. `⌷{{1,2,3},{4,5,6}}` creates a matrix.

### Booleans

APL has no Boolean type. APL comparison and logical functions return 0 or 1, *both of which are `true` to Lua*. The squish function `⌷` converts Booleans to 0-1 values.

### Nil

APL does not have a concept of `nil`. The squish function `⌷` converts nils to `NaN`, which has the type `"number"` even though it is not-a-number. All arithmetic operations involving `NaN` have result `NaN`; all APL comparison operations involving `NaN` have result `0`, even `NaN==NaN`.

### Strings

Lua strings are treated as scalars. APL-style characters and character matrices are not supported, and the use of string-valued arguments to any APL function except `⍎` and `⍕` does not form part of the design of Lua⋆APL. The coherence of both APL and Lua is so good that useful results may well in some cases be obtained from string arguments, but that kind of usage is at this stage an unsupported lucky coincidence.

### Tables

Like the Lua table library, APL relies internally on the built-in `#` function to give the length of arrays. If you create all your APL tables via buit-in APL functions, including `⌷`, this should not be a problem. If an APL function ever returns an array with a hole, it is a bug that I would like to be informed of.

All APL functions accept any Lua array, but returned array are APL arrays. The only difference is that APL arrays have a metatable, which defines a `tostring` function reminiscent of how APL implementations print arrays, and metamethods for the arithmetic operations and concatenation. Arrays passed to APL functions may on return be found to have acquired this metatable. It is not considered to be a bug when this happens.

APL matrices differ from APL vectors in having a `shape` field. The presence of this field influences the behaviour of many functions, most of which however have not been implemented at this stage. The shape is a two-element vector giving the number of rows and columns respectively.

### Functions

Any Lua function is a valid APL function too. However, there are a few things to bear in mind.

-   Make sure that your return values are valid APL values, for example by passing them through the squish function `⌷`.

-   APL thinks of all functions as having the header `function(⍵)` or `function(⍵,⍺)` and returning one value. It can deduce from the syntax whether a function is called monadically or dyadically.

### Other Lua types

All other types are considered to be scalars, and the chance that APL can use them sensibly is remote. However, you may be programmming in a mixture of Lua and APL, using APL as a sort of greatly extended table library. If you keep them as values in tables with keys not recognized by APL, there should not be a problem.

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

-   If `⍵` is nil, it is replaced by `NaN`.
-   If `⍵` is boolean, it is replaced by a 0-1 value.
-   If `⍵` is a string, it is converted to an array of byte values.
-   If `⍵` is any other scalar, it is returned unchanged by `⌷⍵`. This is unlikely to be useful except in the case of a number.
-   If none of the entries in `⍵` is itself a table, `⍵` is converted to an APL table by setting its metatable, and returned. No new table is created.
-   Otherwise the entries in `⍵` must all be tables of the same length, and an APL matrix of which they are the columns is created.

`⍕(⍵,⍺), ⍺⍕⍵`  
The dyadic format function uses a number as format: `12` means `%12d`, `12.6` means `%12.6f` and `¯12.6` means `%12.6e`. You can't have more than 9 digits after the decimal point. An array of numbers can be given: they apply term-by-term if `⍵` is a vector and columnwise if `⍵` is a matrix.

You can also supply a string-valued format or array of formats.

`⍺←⍵`  
The assign function `←` stores `⍵` in `apl._V` at the key `⍺`. This value takes precedence over a global Lua variable with the same name. If `⍵` is a function, the assignment is final. Any later assignment with key `⍺` is an error. The reason for this is that the APL compiler sees `⍺` before it sees `←` and does different things depending on whether `⍺` is a function.

You can force reassignment by calling `←` from Lua: `←(⍵,⍺)`.

`⍺/⍵`, `⍺⌿⍵`, `⍺\⍵`, `⍺⍀⍵`  
When given an empty argument `⍵`, the reduce operators return the unit of the function `⍺` e.g. `⌈/0⍴0` returns `-Inf`, or raise an error if no unit is defined. The scan operators always raise an error if no unit is defined. At present only the associative dyadic functions `+ − ∨ ∧ ⌈ ⌊` have units, and there is no mechanism to define other units.

System variables
----------------

Variables whose names start with `⎕` are reserved for system variables, that is, APL variables on which the behaviour of certain functions may depend.

At present, the following system variables are recognized.

⎕format  
The format to be used by monadic `⍕`. This must be a Lua format string with one slot, e.g. `%.14g`.

⎕pp  
The number of digits appearing after the decimal point in the format used by monadic `⍕` when there is no `⎕format`. This will be used to generate an appropriate format for the particular value being formatted. It is ignored if only integers need to be formatted.

* * * * *

The single-purpose APL routines
-------------------------------

The basic routines defining Lua⋆APL are delivered in `apl._F`. Like `apl._V`, this table is not exported to the global namespace by `apl()`. The routine names are mostly commonly used in APL documentation, such as `Ravel`.

Many of them are wrapped to allow application to array-valued arguments.

This feature is temporary and will be removed once the package reaches pre-alpha status.

* * * * *

The core C routines
===================

These have been adapted from other packages, especially `xtable` by John Hind and myself. They are delivered in a table returned by require `apl_core`.

Block functions
---------------

Block functions all have a table and two integers as their first three arguments. The notation `tbl[a:b]` is used for a block of values with increasing keys if `a<b` and decreasing keys if `a>b`. Thus `tbl[b:a]` is the reverse of `tbl[a:b]`.

* * * * *

### `get(tbl,a,b)`

Returns `tbl[a:b]`. This function may cause stack overflow if too many items are requested.

* * * * *

### `pick(tbl,a,b,fct[,count])`

If `count==1`, returns the first index `i` in `a:b` such that `fct(tbl[i])` is true. If `count>1`, ignores the first `count-1` hits. If `fct` is not a function or if `count<1,` returns nil.

* * * * *

### `set(tbl,a,b,...)`

Sets `tbl[a:b]` to the given values, overwriting existing values.

If the vararg list is empty (not even containing `nil`), stores nothing. The list is treated cyclically: if it is exhausted before `b` is reached, the supply of values is resumed from its beginning. If `b` is nil, values are stored in `tbl[a],tbl[a+1],...` until the list is exhausted.

* * * * *

### `transpose(tbl,a,b,target)`

Stores the transpose of `tbl[1:a*b]` in `target[1:a*b]` and also returns it. `tbl` is assumed to contain `a` blocks of `b` elements, and `target` will contain `b` blocks of `a` elements.

`tbl` and `target` are not allowed to be the same array.

* * * * *

### `trisect(tbl,a,b,v[,cmp[,tag]]])`

Partially sorts `tbl[a:b]`. See the documentation of `xtable` for more information.

Other functions
---------------

### `keep(count,...)`

Returns `count` arguments, starting at the first extra argument. As in the case of `select`, a negative number indexes from the end (-1 is the last argument).

* * * * *

### `map(ft,...)`

Each return value is the result of `ft` applied to the corresponding value in the tuple.

"Applying" means indexing if `ft` is a table and calling if `ft` is a function, which is assumed to be unary with one return value.

* * * * *

### `where()`

Returns a string identifying the point in the source code from which `where` is being called.
