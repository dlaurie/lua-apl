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
    lua-apl.html     -- User's manual
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

Installing the APL interpreter
------------------------------

Make a fresh copy of the 5.2.2 Lua source directory, copy the supplied `lctype-utf8.c` and `lua-apl.c` to replace `lctype.c` and `lua.c`, edit the Makefile in the Lua source directory to suit your environment, putting

    MYCFLAGS=-DLUA_PROMPT='"   "' -DLUA_PROMPT2='""'

so that your session will look like an APL session instead of a Lua session, and do `make linux` or `make mingw` or whatever is appropriate for your system.

Copy the Lua executable you have just made to your execution path, changing its name to `lua-apl` or `lua-apl.exe`.

Make sure that `apl.lua` and `apl-core.so` or `apl-core.dll` are properly installed and your keyboard is APL-enabled, and type `apl`.

Quick start
-----------

We'll do this as a transcript of an interactive session at a terminal running `bash`. The resulting experience has quite a realistic APL-like look and feel.

The first few lines show how to use APL as a desk calculator.

The next few lines show how to define Lua functions in APL.

The last few lines show how to get interactive help.

    …/apl$ lua-apl     # The APL-enabled Lua interpreter
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

If you know no APL
------------------

APL functions are *niladic* (no arguments), *monadic* (one argument on the right of the name) or *dyadic* (two arguments, one to the left and one to the right of the name). In function definitions, the left and right arguments have the reserved names `⍺` and `⍵` respectively; a niladic function has neither. The distinction is only made at runtime. Unlike Lua, APL can overload function names to call different functions when called monadically to when called dyadically.

An APL function can called from Lua by giving `⍵` as first and `⍺` as second argument, i.e. `3÷5` and `apl.÷(5,3)` do the same thing. This is confusing at first, but quite logical: the argument that might not be there is `⍺`, so it must come second.

Functions cannot be called niladically from APL. You need to give at least `⍵`, even when you know that it will be ignored.

More details are given in the HTML files on the repository.
