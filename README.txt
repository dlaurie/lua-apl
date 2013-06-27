Lua⋆APL 
=======

© Dirk Laurie 2013  Lua-style MIT licence

Lua⋆APL is Lua powered by APL. (That's an APL pun.) If the symbol 
between Lua and APL in Lua⋆APL does not look like a five-pointed
star, chances are the rest will look unintelligible too. Get yourself 
a proper APL-enabled screen font as described in [UTF-8 essentials].

The module table contains mostly Lua functions mapped to APL names, 
by and large doing what the corresponding APL functions would do, 
but operating on Lua numbers, strings, tables and functions.

The present version checks that its host Lua satisfies 
`_VERSION=="Lua 5.2"`.

Package contents
----------------

This is what you should find in `lua-apl.zip`.

    apl.lua          -- Lua code for the module
    help.lua         -- Module 'help' required by apl.lua
    apl.c            -- Supporting routines in C 
    lua-apl.c        -- Replacement for lua.c allowing immediate 
                        evaluation and display of APL expressions
    Makefile         -- Gnu makefile for Linux systems

    apl385.ttf       -- A public-domain APL font by Adrian Smith
    lua-apl.xmodmap  -- APL key mappings for X

    README.md        -- What you are reading now
    lua-apl.html     -- User's manual
    prog-guide.html  -- Programmer's guide (i.e. for this software itself)

    test.lua         -- Tests a large selection of features
    finnaplidiom.lua -- A Lua module containing the FinnAPL idiom library.
 
External dependencies
---------------------

    lpeg             -- Roberto Ierusalimschy's LPeg package
    lapack           -- Well-known linear algebra package, must be 
                        available to the C compiler as `-l lapack`.                    
Installation of the Lua module
------------------------------

On a Linux system, make sure that you have `lpeg` and `lapack`
installed, and type `make` in the module directory. Copy `apl_core.so`,
`help.lua` and `apl.lua` to where your `package.cpath` and
`package.path` will find it.

On a non-Linux system, if you get it running, tell me how and and I will
put the intructions in with due acknowledgment.

UTF-8 essentials
----------------

1.  Get a UTF-8 font with decent APL glyphs. `apl385.ttf` is recommended. 
    On Linux systems you put it in `$HOME/.fonts` and select it from your 
    application's font selector. I'm told it is even easier on Windows systems.

2.  Configure an APL keyboard. I don't mean a physical APL keyboard,
    I mean that you must have a reasonably easy way to type APL characters,
    for example via the keyboard's Level-3 and Level-4 character sets, 
    associated with the AltGr key. 

    On systems that use X-windows you can run `xmodmap lua-apl.xmodmap`, 
    after of course having first backed up your present settings by 
    `xmodmap -pke > original.xmodmap`.

    On my keyboard, doing that produces the following layout: 

    
        ~ ⍬  ! ⌶  @ ⍫  # ⍒  $ ⍋  % ⌽  ^ ⍉  & ⊖  * ⍟  ( ⍱  ) ⍲  _ −  + ⌹
        ` ⋄  1 ¨  2 ¯  3 <  4 ≤  5 =  6 ≥  7 >  8 ≠  9 ∨  0 ∧  - ×  = ÷
      
              Q    W    E ⍷  R    T    U    Y    I ⍸  O ⍥  P    { ⊣  } ⊢  | ⍙
              q    w ⍵  e ∊  r ⍴  t ∼  u ↓  y ↑  i ⍳  o ○  p ⋆  [ ←  ] →  \ ⍀
        
               A    S ⌷  D    F ≡  G ⍒  H ⍋  J ⍤  K    L ⍞  : ⍂  " ⌻
               a ⍺  s ⌈  d ⌊  f _  g ∇  h ∆  j ∘  k    l ⎕  ; ⊢  ' ⊣ 
      
                Z    X    C ⍝  V    B ⍎  N ⍕  M    <    > ∵  ?
                z ⊂  x ⊃  c ∩  v ∪  b ⊥  n ⊤  m ∣  , ⍪  , ⍀  / ⌿       
    

    In each 2x2 matrix, right column requires AltGr, top row requires Shift.
    The four-symbol combinations should come out the same on your keyboard
    too, but their positions probably will not.

    Some characters are available on both keyboards, but beware: 
    AltGr `∼∧⋆−∣` may look the same but are non-ASCII. There are no 
    commonly accepted non-ASCII alternatives for `<>+=.,!?/\`,
    otherwise I would have used them too. The difference matters only
    at the Lua level: inside an APL expression, you may use either of 
    the look-alike characters.

    The above layout pays some respect to tradition, with changes
    mostly being additions.

## Installing the APL interpreter

This is optional: you can do everything almost as easily without it.

1. Copy the `src` sundirectory of the 5.2.2 Lua source to your module 
   directory.
2. Optionally, customize `src/Makefile`. For example, I like to put

    MYCFLAGS=-DLUA_PROMPT='"   "' -DLUA_PROMPT2='""'

    so that my session will looks like an APL session instead of a Lua
    session.
3. Copy the supplied `lua-apl.c` to replace `src/lua.c`
4. While inside `src`, do `make linux` or `make mingw` or whatever is 
   appropriate for your system.
5. Copy the Lua executable `src/lua` you have just made to your 
   execution path, changing its name to `lua-apl` or `lua-apl.exe`. 

Make sure that `apl.lua`, `help.lua` and `apl-core.so` or `apl-core.dll` 
are properly installed and your keyboard is APL-enabled, and do `lua-apl`.

Quick start
-----------

We'll do this as a transcript of an interactive session at a terminal 
running `bash`. The resulting experience has quite a realistic APL-like 
look and feel.

The first few lines show how to use APL as a desk calculator, and what
you would need to do if you prefer not to compile the interpreter.

The next few lines show how to define Lua functions in APL.

The last few lines show how to get interactive help.

    $ lua-apl
    Lua 5.2.2  Copyright (C) 1994-2013 Lua.org, PUC-Rio
    Lua⋆APL 0.4.0 © Dirk Laurie 2013
    Lua⋆APL 0.4.0 (Lua code) © Dirk Laurie 2013
    Bug reports are welcome. You'll find me on Lua-L.
    If you can't remember the README, do this:
      help'start'
    In Lua mode, you will need `apl:import()` first.
    --

       n=10    -- this is straight Lua
       (n,n)⍴(n+1)↑1
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
       return apl"(n,n)⍴(n+1)↑1"()
    -- The above is what the previous line looks like on replay on
    -- systems with readline history. That's all that the interactive
    -- interpreter does.

       f=apl"(n,n)⍴(n+1)↑1" -- the same code as a function definition
       n=3                  -- redefining the global variable
       =f()                 -- executing it
    1 0 0
    0 1 0
    0 0 1
       g=apl"(⍵,⍵)⍴(⍵+1)↑1" -- replacing the global variable by an argument
        =g(5)                -- executing it
    stdin:1: unexpected symbol near '='
       =g(5)                -- executing it
    1 0 0 0 0
    0 1 0 0 0
    0 0 1 0 0
    0 0 0 1 0
    0 0 0 0 1
       h=apl"⍺÷⍵"       -- a function of two arguments
       return h(5,8)    -- ⍵ is the first, ⍺ the second (explanation below)
    1.6
       =lua(g)        -- Show the Lua code that is actually executed
    return Reshape(Take(1,Add(1,_w)),Attach2(_w,_w))

       help(apl)
    Contents: Abs Add And Assign Attach Attach1 Attach2 Binom Ceil Circ
        Compress Compress1 Compress2 Copy Deal Decode Define Disclose Div Down
        Drop Each Enclose Encode Execute Exp Expand Expand1 Expand2 Fact Find
        Floor Format Has Inner Length Ln Log MatDiv MatInv Max Min Mod Mul Nand
        Nor Not Or Outer Output Pass Pi Pow Range Ravel Recip Reduce Reduce1
        Reduce2 Reshape Reverse Reverse1 Reverse2 Roll Rotate Rotate1 Rotate2
        Same Scan Scan1 Scan2 Shape Sign Sub Take TestEq TestGE TestGT TestLE
        TestLT TestNE ToString Transpose Unm Up _act _rct help import lua
        register util
       help"APL"
    Contents: ! + , . / < = > ? \ ¨ × ÷ ↑ ↓ ∇ ∊ − ∘ ∣ ∧
        ∨ ∼ ≠ ≡ ≤ ≥ ⊂ ⊃ ⊖ ⊤ ⊥ ⋆ ⌈ ⌊ ⌹ ⌽ ⌿ ⍀ ⍉ ⍋ ⍎ ⍒ ⍕ ⍟ ⍪ ⍱ ⍲ ⍳ ⍴ ⎕ ○
       help"⍳"
    Range: ⍳⍵ → first ⍵ integers starting at 1
           ⍺⍳⍵ → first ⍵ integers starting at ⍺ 
    Find: ⍺⍳⍵ → position of first occurrence of ⍵ in ⍺; not found is #⍺+1
    
    The above is probably not quite the same as what the current version would 
    give (that applies to all the other examples too) but you get the idea.

If you know no APL
------------------

APL functions are _niladic_ (no arguments), _monadic_ (one argument
on the right of the name) or _dyadic_ (two arguments, one to the left
and one to the right of the name). In function definitions, the left
and right arguments have the reserved names `⍺` and `⍵` respectively;
a niladic function has neither. The distinction is only made at runtime.
Unlike Lua, APL can overload function names to call different functions
when called monadically to when called dyadically.

As shown above, you can use `help` to find out the Lua names of APL
symbols or vice versa.

An APL function can called from Lua by giving `⍵` as first and `⍺` 
as second argument, i.e. `3÷5` and `apl.Div(5,3)` do the same thing. 
This is confusing at first, but quite logical: the argument that might 
not be there is `⍺`, so it must come second.

Functions cannot be called niladically from APL. You need to give at 
least `⍵`, even when you know that it will be ignored.

More details are given in the HTML files on the repository.
