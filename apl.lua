-- apl.lua  (c) Dirk Laurie 2013  Lua-style MIT licence

if ⍺ then end -- in order to diagnose whether UTF-8 codepoints are names

-- There is not much fun in viewing this file unless you have a UTF-8 font 
-- with decent APL glyphs. Consult the README.

-- Dependencies

local core = require"apl_core"
local  get,      move,      map,      where,      transpose,      pick
= core.get, core.move, core.map, core.where, core.transpose, core.pick
local set = function(t,...) core.set(t,...) return t end

local help = require"help"  -- customized near bottom of program

local lpeg=require"lpeg"

local sqrt,      log,      abs,      min,      max,      exp,      Inf = 
   math.sqrt, math.log, math.abs, math.min, math.max, math.exp, math.huge
local random, concat, unpack = math.random, table.concat, table.unpack
local char = string.char
    
-- This is kept in while the program is under development

local meta_ENV=getmetatable(_ENV)
setmetatable(_ENV,{__newindex = function (ENV,name,value)
   if name:match"^%a%d?$" then print(where(2)..
      "A global name like '"..name.."' is asking for trouble.")
   end
   rawset(ENV,name,value)
end})

-- check the Lua version
if not _VERSION:match"Lua 5.2" then 
   print ("WARNING: 'apl.lua' has not been tested with ".._VERSION..
      ". You are on your own!")
   end

-- semi-globals, available as upvalues anywhere in this file

local apl={}         -- table containing all functions
local _V = {}        -- APL's namespace; later assigned to apl._V 
local apl_meta = {}  -- Metatable for APL arrays 
local helptext={}    -- Help for a few specific APL symbols
local load_apl       -- loads APL code as a Lua function
local unit={}        -- Unit elements for functions that have them
local newfunc        -- add a function to `apl` and the APL compiler
local newoperator    -- add an operator to `apl` and the APL compiler
local argcheck       -- LuaL-style argument check
local checktype      -- LuaL-style type check
local is             -- non-error type check
local loading=true   -- set to false when the module returns

do -- APL-to-Lua compiler
 -- upvalues: apl2lua, functions, operators, lpeg
local C,     P,     R,     S,     V,     Cmt,     Cp = 
 lpeg.C,lpeg.P,lpeg.R,lpeg.S,lpeg.V,lpeg.Cmt,lpeg.Cp

local utflen = function(s)
   return #s:gsub("[\xC0-\xEF][\x80-\xBF]*",'.')
end

local lookup = function(tbl) 
--- Cmt function that succeeds when key is in tbl, returning
-- the value, and fails otherwise. `subj` is provided by `Cmt`
-- but is not needed.
   return function(subj,pos,key)
      local v = tbl[key]
      if v then return pos,v end
   end
end

local numbers = function(str)
   str=str:gsub("¯","-")
   local v,n = str:gsub("%s+",',')
   if n==0 then return str else return '{'..v..'}' end
end

local _s = S" \t\n"                 -- one character of whitespace
local dec = R"09"^1                    -- positive decimal integer
local sign = P"¯"^-1                        -- optional high minus
local fixed = dec*P"."*dec^-1 + (dec^-1*P".")^-1*dec  -- %f number
local number = sign*fixed*(S"eE"*sign*dec)^-1         -- %e number 
local vector = _s^0*number*(_s^1*number)^0

local first = R"az"+R"AZ"
local later = first+R"09"
local utc = R"\x80\xBF"              -- UTF-8 continuation byte
local utf2 = R"\xC0\xDF"*utc         -- 2-byte codepoint
local utf3 = R"\xE0\xEF"*utc*utc     -- 3-byte codepoint
local utf = utf2 + utf3 - P"←"-P"¯"
local neutral = R"\x21\x7E"-later-S"()[;]"  
local name = first*later^0 + utf + neutral

local functions={}
local monadic_operators={} 
local dyadic_operators={} 
local funcname = _s^0*Cmt(name,lookup(functions))*_s^0
local monadic_operator = _s^0*Cmt(name,lookup(monadic_operators))*_s^0
local dyadic_operator = _s^0*Cmt(name,lookup(dyadic_operators))*_s^0
local operator = monadic_operator + dyadic_operator
local varname = _s^0*C(first*later^0+utf-funcname-operator)*_s^0
local param = _s^0*(P'⍺'/1 + P'⍵'/1)*_s^0 -- not to be looked up in _V

local apl_expr = P{ "expr";
   expr = 
     (param/1*'←'*V"expr")/"set%1(%2)" +
     ((V"variable"-param)/"'%1'")*'←'*V"expr"/"Assign(%2,%1)" + 
     V'leftarg'*V'func'*V'expr'/"%2(%3,%1)" +
     V'func'*V'expr'/"%1(%2)" +
     V"leftarg";
   func = funcname*dyadic_operator*funcname/"%2(%1,%3)" + 
          funcname*monadic_operator/"%2(%1)" + 
          funcname;
   leftarg = V"value" + '('*V"expr"*')'/1;
   value = param + vector/numbers + V"variable"/"_V.%1"; 
   variable = varname*'['*V"indices"*']'/"%1[%2]" + varname;
   index = V"expr"+_s^0/"nil";
   indices = V"index"*';'*V"index"/"{%1;%2}" + V"expr";
   }

local apl2lua = function(apl)
   local lua,pos = (apl_expr*_s^0*Cp()):match(apl)
   pos = pos or 0
   if pos>#apl then return lua 
   else error("APL syntax error\n"..apl.."\n"..
      (" "):rep(utflen(apl:sub(1,pos))-1)..'↑')
   end
end

local register = function (class, fct, APLname, LuaName, alias, help)
--- register a function for the APL compiler, Lua interface and help
   argcheck(not class[APLname],2,"name '"..APLname.."' already in use")
   if alias then 
       argcheck(not class[alias],4,"name '"..alias.."' already in use")
       class[alias]=LuaName or APLname 
   end
   class[APLname]=LuaName or APLname
   apl[APLname]=fct
   if LuaName then apl[LuaName]=fct end
   if help then helptext[APLname]=help end
end

newfunc = function (fct, APLname, LuaName, alias, help)
   register(functions, fct, APLname, LuaName, alias, help)
end

newoperator = function (fct, APLname, LuaName, alias, help, adity)
   if adity==1 or adity==3 then 
       register(monadic_operators, fct, APLname, LuaName, alias, help)
   end
   if adity==2 or adity==3 then 
       register(dyadic_operators, fct, APLname, LuaName, alias, help)
   end
end

local preamble=[[
local ⍵,⍺=... 
local function set⍺(v) ⍺=v return v end 
local function set⍵(v) ⍵=v return v end 
return ]]

load_apl = function(⍵)
   checktype(⍵,'string',1)
   local lua = apl2lua(⍵)
   local f,msg = load(preamble..lua,nil,nil,apl)
   if not f then 
      error("Could not compile: "..⍵.."\n Tried: "..lua.."\n"..msg) 
   end
   help(f,⍵)
   return f   
end

local function lua_code(⍵)
   if is"function"(⍵) then 
      local source = debug.getinfo(⍵).source
      if source:sub(1,#preamble)==preamble then 
          source="∇: "..source:sub(#preamble+1)
      end
      return source
   else return "Not a function"
   end
end

apl.lua = lua_code

end -- of APL-to-Lua compiler

-- ---------  Forward declaration of all basic APL functions  -------------
-- These groups of names are exported as subtables in apl._F

-- Numeric monadic functions
-- These functions generalize term-by-term to any array
local AbsoluteValue, Ceiling, Exponential, Factorial, Floor, Logarithm, Negate, 
   Not, PiTimes, Reciprocal, Roll, Signum
-- Numeric dyadic functions
-- These functions generalize term-by-term to arrays of the same shape or
--   when one operand is a singleton
local Add, And, Binomial, Circle, Divide, Equal, Greater, GreaterEqual, Less,
   LessEqual, Maximum, Minimum, Multiply, Nand, Nor, NotEqual, Or, Power,
   Residue, Subtract
-- One-of-a-kind monadic functions
local Clone, Execute, GradeDown, GradeUp, IndexGenerator, MatrixInverse, 
   Ravel, Reverse, ReverseFirst, Shape, Squish, Transpose  
-- One-of-a kind dyadic functions
local Attach, AttachFirst, Compress, CompressFirst, Deal, Decode, Drop,
   ElementOf, Encode, Expand, ExpandFirst, Find, Format, MatrixDivide, 
   Reshape, Rotate, RotateFirst, Take 
-- Operators 
local Reduce, ReduceFirst, Scan, ScanFirst, Inner, Outer 
-- Other
local Assign, Define, Index, NaN, Squish
-- Local utilities, not mapped to symbolic APL functions
local First, Invert, Map, Pass

-- -----------------------------------------------------------------
-- Auxiliary functions

local arr, checksize, is_int, is_not, sanitize, sort, utflen

-- All argument-check routines prefer the actual called name;
-- the optional last parameter is a fallback when no such name
-- is available (e.g. a tail call)
argcheck = function(cond,pos,msg,name)
   name = debug.getinfo(2,'n').name or name or "<anonymous>"
   if not cond then
      error(("bad argument "..pos.." to %s: %s"):format(
         name,msg))   
   end
end

arr = function(⍵)
--- Make ⍵ into an APL array 
   if not is"table"(⍵) then ⍵={⍵} end
   return setmetatable(⍵,apl_meta) 
end

checksize = function(⍺,⍵,name)
   name = debug.getinfo(2,'n').name or name or "<anonymous>"
   if is_not"table"(⍺) or is_not"table"(⍵) or #⍺~=#⍵ then
      ⍺=type(⍺)..(is"table"(⍺) and "#"..#⍺ or "")
      ⍵=type(⍵)..(is"table"(⍵) and "#"..#⍵ or "")
      error(("bad arguments to %s:\n  expected (table#n,table#n), got (%s,%s)"):
         format(name,⍺,⍵))   
   end
end   

checktype = function(val,typ,pos,name)
   name = debug.getinfo(2,'n').name or name or "<anonymous>"
   if type(val)~=typ then 
      error(("bad argument "..pos.." to %s: expected %s, got %s"):format
            (name,typ,type(val)))   
   end
end

is = function(typ) return function(x) return type(x)==typ end end
is_int = function(x) return is"number"(x) and not (x>Floor(x)) end
is_not = function(typ) return function(x) return type(x)~=typ end end

do -- sort package
local max_chunk_size = 12
local small_sort = core.sort
local merge = core.merge

local function merge_sort( array, low, high, precedes )
  if high - low < max_chunk_size then
    small_sort( array, low, high, precedes )
  else
    local middle = math.floor((low + high)/2)
    merge_sort( array, low, middle, precedes )
    merge_sort( array, middle + 1, high, precedes )
    merge( array, low, middle, high, precedes )
  end
end

sort = function( array, precedes )
  local n = #array
  if n < 2 then  return array  end
  if precedes and precedes(array[1],array[1]) then 
    error"invalid order function for sorting"
  end
  merge_sort( array, 1, n, precedes )
  return array
end
end -- of sort package

sanitize = function(⍵)
   if is"string"(⍵) then return arr{⍵:byte(1,-1)} end
   if is"boolean"(⍵) then return ⍵ and 1 or 0 end
   if is"nil"(⍵) then return NaN end
   return ⍵
end

unsanitize = function(⍵,⍺)
   if ⍺==2 then 
      if is"table"(⍵) then return char(unpack(⍵)) else return char(⍵) end
   end
   if ⍺==1 then return ⍵~=0 end
   return ⍵
end

First = function(fct,tbl) return pick(tbl,1,#tbl,fct) end

Invert = function(⍵) 
   local t=arr{} 
   for k,v in ipairs(⍵) do t[v]=k end 
   return t
end

Map = function(ft,tbl) return arr{map(ft,unpack(tbl))} end
--- Applies ft to every element of tbl. ft may be a function or a table.

local circfunc = {
   [0] = core.circ0; -- sqrt(1-⍵^2)
   [1] = math.sin;
   [2] = math.cos;
   [3] = math.tan;
   [4] = core.circ4; -- sqrt(1+⍵^2) 
   [5] = math.sinh;
   [6] = math.cosh;
   [7] = math.tanh;
   [-1] = math.asin;
   [-2] = math.acos;
   [-3] = math.atan;
   [-4] = core.circ_4; -- sqrt(⍵^2-1)
   [-5] = core.asinh;
   [-6] = core.acosh;
   [-7] = core.atanh;
}
help('CircleFunctions', [[
  (¯4 0 4 ○ ⍵) = ((⍵^2-1)⋆0.5,(1-⍵^2)⋆0.5,(1+⍵^2))
   (1 2 3 ○ ⍵) = (sin ⍵, cos ⍵, tan ⍵)
   (5 6 7 ○ ⍵) = (sinh ⍵, cosh ⍵, tanh ⍵)
  (⍺ ○ (-⍺) ⍵) = ⍵ ]])

-- -------------  LuaAPL functions A-Z  -------------------------------

-- It's annoying, I know, that the _left_ operand in infix notation 
-- maps to the _second_ operand in postfix notation, but there is
-- method in the madness.

AbsoluteValue = math.abs; help(AbsoluteValue, "∣⍵ → math.abs(⍵)")
Add = function(⍵,⍺) return ⍺+⍵ end
And = function(⍵,⍺) return ⍵~=0 and ⍺~=0 and 1 or 0 end
Assign = function(⍵,⍺) _V[⍺]=⍵ return ⍵ end

Attach = function(⍵,⍺)
   local ⍴⍺,⍴⍵ = Shape(⍺),Shape(⍵)
   if ⍴⍺ and #⍴⍺>1 or ⍴⍵ and #⍴⍵>1 then 
      return Transpose(AttachFirst(Transpose(⍵),Transpose(⍺)))
   end
   ⍺=Ravel(⍺)
   if #⍴⍵<1 then ⍺[#⍺+1]=⍵ else set(⍺,#⍺+1,nil,get(⍵,1,#⍵)) end
   return ⍺
end
help(Attach,"Attach: ⍺,⍵ → elements of ⍺ followed by elements of ⍵")

AttachFirst = function(⍵,⍺)
   local ⍴⍺,⍴⍵ = Shape(⍺),Shape(⍵)
   ⍴⍺ = ⍴⍺.shape or {1,⍴⍺[1] or 1}
   ⍴⍵ = ⍴⍵.shape or {1,⍴⍵[1] or 1}
   argcheck(⍴⍺[2]==⍴⍵[2],2,'Rows must be of equal length')
   ⍺,⍵ = Clone(arr(⍺)),arr(⍵)
   set(⍺,#⍺+1,nil,get(⍵,1,#⍵))
   ⍺.shape = arr{⍴⍺[1]+⍴⍵[1],⍴⍺[2]}
   return ⍺
end   
help(AttachFirst,[[
AttachFirst: ⍺⍪⍵ → rows of ⍺ followed by rows of ⍵
   Vectors are treated as one-row matrices.]])

Binomial = function(⍵,⍺) 
   ⍺=min(⍺,⍵-⍺)
   if ⍺<0 then return 0 end
   local c=1
   for k=1,⍺ do c=c*⍵/k; ⍵=⍵-1 end
   return c
   end;
help(Binomial,"Binomial: ⍺?⍵ → binomial coefficient C(⍵,⍺)")

Ceiling = math.ceil; help(Ceiling, "⍵ → math.ceil(⍵)")
Circle = function(⍵,⍺) return circfunc[⍺](⍵) end

Clone = function(⍵) 
   return is"table"(⍵) and arr(set({shape=⍵.shape},1,nil,unpack(⍵))) 
   or ⍵
end
help(Clone,'Clone: +⍵ returns an exact copy of ⍵')

Compress = function(⍵,⍺)
   local t=arr{}
   if is_int(⍺) then if ⍺>0 then
      checktype(⍵,'table','⍵','Compress')
      for k,v in ipairs(⍵) do set(t,#t+1,#t+⍺,v) end
      return t
   end end
   checksize(⍺,⍵,'Compress') 
   for k,v in ipairs(⍵) do if ⍺[k]>0 then set(t,#t+1,#t+⍺[k],v) end 
   end
   return t
end
CompressFirst = function(⍵,⍺) return Transpose(Compress(Transpose(⍵),⍺)) end

Deal = function(⍵,⍺)
   argcheck(⍺<=⍵,'pair',"can't deal "..⍺.." from "..⍵)
   local p=IndexGenerator(⍵)
   local t=arr{}
   for k=1,⍺ do local j=Roll(⍵); t[k],p[j],⍵ = p[j],p[⍵], ⍵-1 end
   return t
end
help(Deal,"⍺?⍵ → ⍺ distinct numbers randomly selected from ⍳⍵")

Decode = function(⍵,⍺)
   local t,d=arr{}   
   checktype(⍵,'number','⍵')
   if is"table"(⍺) then for k=#⍺,1,-1 do d=⍵%⍺[k]; t[k]=d; ⍵=(⍵-d)/⍺[k] end
   else 
      repeat d=⍵%⍺; t[#t+1]=d; ⍵=(⍵-d)/⍺ until ⍵==0
      move(t,1,#t,#t,1)
   end
   return t
end
help(Decode,"Decode: ⍵⊤⍺ → Decompose ⍺ into base ⍵ digits")

Define = load_apl
help(Define,"Define: return APL expression compiled as a Lua function")

Divide = function(⍵,⍺) return ⍺/⍵ end

Drop = function(⍵,⍺) 
   local n,t = #⍵, arr{}
   if abs(⍺)>=n then return t end
   if ⍺<0 then set(t,1,n+⍺,get(⍵,1,n+⍺))
   else set(t,1,n-⍺,get(⍵,⍺+1,n))
   end
   return t
end
help(Drop,"Drop: remove first ⍺ or last -⍺ elements from ⍵")

ElementOf = function(⍵,⍺)
   local s,t=arr{},Invert(⍵)
   for k,v in ipairs(⍺) do s[k]=t[v] and 1 or 0 end
   return s
end
help(ElementOf,"⍺∊⍵ → does ⍺ occur in ⍵?")

Equal = function(⍵,⍺) return ⍺==⍵ and 1 or 0 end; 

Execute = function(⍵) 
   local v=_V[⍵]
   if v then return Squish(v) else return Define(⍵)() end 
end

Encode = function(⍵,⍺)
   local p=0
   if is"table"(⍺) then for k=1,#⍺ do p=⍺[k]*p+⍵[k] end   
   else for k=1,#⍵ do p=⍺*p+⍵[k] end
   end
   return p
   end
help(Encode,"Encode: ⍵,⍺ → Calculate ⍺ given its base ⍵ digits")

Expand = function(⍵,⍺)
   local t=arr{}
   for k,v in ipairs(⍵) do 
      t[#t+1]=v
      if ⍺[k]>0 then set(t,#t+1,#t+⍺[k],0) end
   end
   return t
end
ExpandFirst = function(⍵,⍺) return Transpose(Expand(Transpose(⍵),⍺)) end
   
Exponential = math.exp; help(Exponential,"⍵ → math.exp(⍵)")
Factorial = function(⍵) local f=1; for k=2,⍵ do f=f*k end; return f end

Find = function(⍵,⍺)
   if is_not"table"(⍺) then ⍺={⍺} end
   return First(function(x) return x==⍵ end,⍺) or #⍺+1
end
help(Find,"⍺⍳⍵ → position of first occurrence of ⍵ in ⍺; not found is #⍺+1")

Floor = math.floor; help(Floor, "⍵ → math.floor(⍵)")
-- Format is defined after the A-Z group

GradeUp = function(⍵) 
   checktype(⍵,'table','⍵','GradeUp')
   local x=IndexGenerator(#⍵)
   return sort(x,function(a,b) return ⍵[a]<⍵[b] end)
   end;

GradeDown = function(⍵) 
   checktype(⍵,'table','⍵','GradeDown')
   local x=IndexGenerator(#⍵)
   return sort(x,function(a,b) return ⍵[a]>⍵[b] end)
   end;

Greater = function(⍵,⍺) return ⍺>=⍵ and 1 or 0 end
GreaterEqual = function(⍵,⍺) return ⍺>=⍵ and 1 or 0 end

Index = function(⍵,⍺)
   checktype(⍵,'table','⍵')
   arr(⍵) -- maybe Index was called directly
   if is_not"table"(⍺) then return rawget(⍵,⍺) end
   local ⍴⍵ = rawget(⍵,'shape')
   if not ⍴⍵ then  -- ⍵ is not a matrix
      local t=arr{} 
      for k,v in ipairs(⍺) do t[k]=Index(⍵,v) end
      if is"table"(t[1]) then return Squish(t) end
      t.shape=rawget(⍺,'shape')
      return t
   end
   argcheck(#⍺<=2,'⍺','must be a vector with no more than two elements')
   local I,J, m,n = ⍺[1],⍺[2], ⍴⍵[1],⍴⍵[2]  -- ⍵ is a matrix 
   if is"number"(I) and is"number"(J) then return rawget(⍵,J+n*(I-1)) end
   if is"number"(I) then I={I} else I=I or {} end
   if is"number"(J) then J={J} else J=J or {} end
   -- both indices are now array-valued; dispose of case of full columns
   if #I==0 then return Transpose(Index(Transpose(⍵),{J,I})) end
   local t=arr{}  
   if #J==0 then -- full rows required
      t.shape={#I,n}
      for _,i in pairs(I) do 
         j0=(i-1)*n; set(t,#t+1,nil,get(⍵,j0+1,j0+n))
      end
      return t
   end
   t.shape={#I,#J}
   for _,i in pairs(I) do
      j0=(i-1)*n; for _,j in pairs(J) do t[#t+1]=rawget(⍵,j+j0) end
   end
   return t
end
help(Index,[[
Index: ⍵[⍺] → Index(⍵,⍺)
  ⍵ is a scalar: ⍵.shape is ignored
  ⍵ is a vector: ⍵[⍺] term-by-term, result has same shape as ⍺
  ⍵ is a matrix: ⍺ is coerced to a two-element vector of vectors
    first element of ⍺ chooses rows, second element chooses columns
    empty vector means all
See help'[' for shorthand notation in APL expressions.
]])

IndexGenerator = 
   function(⍵) 
      checktype(⍵,'number',1)
      local t=arr{} 
      for i=1,⍵ do t[i]=i end; return t 
   end
help(IndexGenerator,"IndexGenerator: ⍳⍵ → {1,2,...,⍵}") 

Inner = function(f1,f2) 
   if f1==Pass then return Outer(f2) end
   return function(⍵,⍺) 
      checksize(⍺,⍵,'Inner')
      argcheck(not ⍺.shape,'⍺',"Can't handle matrices yet")      
      argcheck(not ⍵.shape,'⍵',"Can't handle matrices yet")  
      local n = #⍵
      local y=f2(⍵[n],⍺[n])
      for k=n-1,1,-1 do 
         y=f1(y,f2(⍵[k],⍺[k]))
      end
      return y
   end
end

Less = function(⍵,⍺) return ⍺<⍵ and 1 or 0 end
LessEqual = function(⍵,⍺) return ⍺<=⍵ and 1 or 0 end
Logarithm = math.log; 
Maximum = math.max; help(Maximum,"⍺⌈⍵ → math.max(⍵,⍺)")
Minimum = math.min; help(Minimum,"⍺⌊⍵ → math.min(⍵,⍺)")
Multiply = function(⍵,⍺) return ⍺*⍵ end 
NaN = 0/0; 
Nand = function(⍵,⍺) return ⍵~=0 and ⍺~=0 and 0 or 1 end
Negate = function(⍵) return -⍵ end
Nor = function(⍵,⍺) return (⍵~=0 or ⍺~=0) and 0 or 1 end
Not = function(⍵) if ⍵==0 then return 1 else return 0 end end
NotEqual = function(⍵,⍺) return ⍺~=⍵ and 1 or 0 end
Or = function(⍵,⍺) return (⍵~=0 or ⍺~=0) and 1 or 0 end

Outer = function(f) return 
   function(⍵,⍺)
      local n,m =#⍵,#⍺
      local y=arr{shape={m,n}}
      for i=1,m do for j=1,n do
         y[#y+1] = f(⍵[j],⍺[i])
      end end
      return y
   end
end

Pass = function() return end
PiTimes = function(⍵) return math.pi*⍵ end
Power = function(⍵,⍺) return ⍺^⍵ end

Ravel = function(⍵) 
   if is_not"table"(⍵) then return arr{⍵} end
   ⍵=Clone(⍵); ⍵.shape=nil; return ⍵
end
help(Ravel,"Ravel: ,⍵ -- forces ⍵ to be a vector")

Reciprocal = function(⍵) return 1/⍵ end

Reduce = function(⍺)
   local u=unit[⍺]
   return function(⍵)
      if #⍵==0 then return u or argcheck(false,'⍺',
         "empty arguments to a function with no unit") end
      local res=⍵[#⍵]
      for k=#⍵-1,1,-1 do res=⍺(res,⍵[k]) end
      return res
   end
end
ReduceFirst = Reduce  -- will change when shape is implemented

Reshape = function (⍵,⍺)   
   if is"number"(⍺) then ⍺={⍺} end
   checktype(⍺,'table','⍺')
   local tomatrix = #⍺==2 and ⍺[1]>=0 and ⍺[2]>=0 
   local t=arr{shape = tomatrix and ⍺}
   local n=tomatrix and ⍺[1]*⍺[2] or ⍺[1]
   if n==0 then return t end
   if is"table"(⍵) then argcheck(#⍵>0,'⍵','empty vector given')
   else ⍵={⍵} end 
   return set(t,1,n,unpack(⍵))
end
help(Reshape,"Reshape: Make an array of shape ⍺ by using ⍵ cyclically")

Residue = function(⍵,⍺) return ⍵%⍺ end

Reverse = function(⍵) 
   if not is"table"(⍵) then return ⍵ end
   ⍵=Clone(⍵)
   local s, m,n, j = ⍵.shape, 1,#⍵, 0
   if s then m,n = s[1],s[2] end
   for k=1,m do move(⍵,j+1,j+n,j+n,j+1); j=j+n end
   return ⍵
   end;
help(Reverse,"Reverse: ⌽⍵ → the elements of ⍵ in reverse order")
ReverseFirst = function(⍵)
   if not is"table"(⍵) then return ⍵ end
   if not ⍵.shape then return Reverse(⍵) end
   return Transpose(Reverse(Transpose(⍵)))
end

Roll = math.random; help(Roll,"⍵ → math.random(⍵)")

Rotate = function(⍵,⍺)
   if not is"table"(⍵) then return ⍵ end
   local s, m,n, j = ⍵.shape, 1,#⍵, 0
   if s then m,n = s[1],s[2] end
   ⍺=Residue(⍺,n)
   local t=arr{shape={m,n}}
   for k=1,m do 
      if ⍺>0 then set(t,j+1,j+n-⍺,get(⍵,j+⍺+1,j+n)) end
      if ⍺<n then set(t,j+n-⍺+1,j+n,get(⍵,j+1,j+⍺)) end
      j=j+n
   end
   return t
end
help(Rotate,"Rotate: ⍺⌽⍵ → columns of ⍵ rotated left by ⍺ (or right by -⍺")
RotateFirst = function(⍵,⍺)
   if not is"table"(⍵) then return ⍵ end
   if not ⍵.shape then return Rotate(⍵,⍺) end
   return Transpose(Rotate(Transpose(⍵),⍺))
end
help(RotateFirst,
   "RotateRows: ⍺⊖⍵ → rows of ⍵ rotated up by ⍺ (or down by -⍺")

Same = function(⍵,⍺)
   return sanitize(⍺==⍵)
end
help(Same,"Same: ⍺≡⍵ means Lua equality but APL 0-1 result")

Scan = function(⍺)
   argcheck(unit[⍺],'⍺',"function with no unit")
   return function(⍵)
      if #⍵==0 then return unit[⍺] end
      local res=arr{⍵[1]}
      for k=2,#⍵ do res[k]=⍺(⍵[k],res[k-1]) end
      return res
   end
end
ScanFirst = Scan  -- will change when shape is implemented

Shape = function(⍵) 
   if is"table"(⍵) then
      if ⍵.shape then return ⍵.shape else return arr{#⍵} end
   elseif is"number"(⍵) then return arr{}
   else return #⍵
   end
end
help(Shape,[[
Shape: ⍴⍵ → {} if a number, {#⍵} if a vector, {rows,cols} if a matrix.
       #⍵ if none of the above.]])

Signum = function(⍵) return ⍵<0 and -1 or ⍵>0 and 1 or 0 end 

Squish = function(⍵) 
   if is_not"table"(⍵) then return sanitize(⍵) end
   local j,n = First(is'table',⍵),#⍵ 
   if not j then return Map(sanitize,⍵) end
   local m=#⍵[j]
   local culprit = First(is_not'table',⍵)
         or First(function(x) return #x~=m end,⍵)
   if culprit then argcheck(false,'⍵',
      'row '..culprit..' and row '..j..' have different length')
   end
   local s,j = arr{shape={n,m}},0
   for i=1,n do set(s,j+1,j+m,map(sanitize,get(⍵[i],1,m))); j=j+m end
   return s
end
help(Squish,[[
Squish: ⌷⍵ → convert ⍵ from Lua to APL.
   Vectors of rows are converted to matrices. 
   Booleans are converted to 0-1, Nil to NaN.
   Strings are converted to arrays of bytes.
   Vectors of strings are converted to vectors of rows of bytes.
   Other scalars are returned unchanged.]])

Subtract = function(⍵,⍺) return ⍺-⍵ end
    
Take = function(⍵,⍺)
   if not is"table"(⍵) then ⍵={⍵} end
   local len,given,t = abs(⍺),#⍵,arr{}
   if len<1 then return t end
   set(t,1,len,0)
   local n=Minimum(len,given)
   if ⍺<0 then set(t,len,len-n+1,get(⍵,given,given-n+1))
   else set(t,1,n,get(⍵,1,n))
   end
   return t
end

Transpose = function(⍵)
   if not is"table"(⍵) then return ⍵ end
   local s=⍵.shape
   if not s then return Clone(⍵) end
   return arr(transpose(⍵,s[1],s[2],{shape={s[2],s[1]}}))
end   
help(Transpose,'Transpose: ⍉⍵ → matrix transpose of ⍵')

Unsquish = function(⍵,⍺)
   if is_not"table"(⍵) or ⍺==2 and not ⍵.shape then 
      return unsanitize(⍵,⍺) 
   end
   if not ⍵.shape then return 
      Map(function(⍵) return unsanitize(⍵,⍺) end,⍵) 
   end
   local t=arr{}
   local s=⍵.shape
   local n=s[2]
   local i0=0
   for i=1,s[1] do
      t[i]=set(arr{},1,nil,get(⍵,i0+1,i0+n))
      t[i]=Unsquish(t[i],⍺)
      i0=i0+n
      end 
   return t
end
help(Unsquish,[[
Unsquish: ⍺⌻⍵ → convert ⍵ from APL to Lua
   Matrices are converted to vectors of rows. 
   ⍺=1: 0 is converted to False, other values to True.
   ⍺=2: Numbers in the range 0 to 255 are converted to bytes.
        Vectors become strings, matrices become arrays of strings.]])
   
do -- Format
local function sizer(x) if x<0 then x=10*abs(x) end; return x end

local function defaultformat(⍵)   
   if ⍵==nil then return "%s" end
   local fmt
   local ⎕pp = _V.⎕pp or 5  
   if is"table"(⍵) then 
      if First(function(x) return not x==x end,⍵) then -- NaN found
          return "%s"
      end
      local nonint=First(function(x) return not is_int(x) end,⍵)
      local mx=-Inf
      for k,v in ipairs(⍵) do 
         if nonint then mx=Maximum(mx,#("%."..⎕pp.."f"):format(sizer(v)))
         else mx=Maximum(mx,#("%d"):format(v)) 
      end end
      if not ⍵.shape then 
         if nonint then return '%.'..⎕pp..'g' else return "%s" end
      else return "%"..mx..(nonint and '.'..⎕pp..'f' or 'd') 
      end
   end
   if is_int(⍵) then return "%d" else return "%."..⎕pp.."f" end
end
local function aplformat(f)
--- convert APL format to string format
   if f==nil then return defaultformat()
   elseif is"string"(f) then return(f)
   elseif is"number"(f) then 
      return '%'..("%.1f"):format(abs(f))..(f<0 and 'e' or 'f')
   elseif is"table"(f) then 
      return Map(aplformat,f)
   else checktype(f,'number',1)
   end      
end

Format = function(⍵,⍺)    
   if ⍵==nil then return aplformat(⍺) end
   if is"string"(⍵) then return ⍵ end
   if is"table"(⍵[1]) then 
      local f={}
      for k,v in ipairs(⍵) do f[k]=' '..Format(v,⍺) end
      return concat(Map(tostring,f),"\n")
   end
   ⍺ = (⍺ and aplformat(⍺)) or _V.⎕format or defaultformat(⍵)
   if is"table"(⍵) then
      local f={}
      if is"string"(⍺) then for k,v in ipairs(⍵) do 
         f[k]=⍺:format(v) 
      end
      elseif is"table"(⍺) then 
         for k,v in ipairs(⍵) do f[k]=Format(v,⍺[k]) end
      else checktype(⍺,'table',2)
      end
      local s=⍵.shape
      if s then 
         local k,m,n,r = 1,s[1],s[2],{}
         for i=1,m do r[i]=concat(f,' ',k,i*n); k=k+n end
         return concat(r,'\n')
      else return concat(f,' ')
      end
   elseif is"table"(⍺) then 
      return concat(Map(function(f) return f:format(⍵) end,⍺))
   else return ⍺:format(⍵)     
   end
end 
end -- Format      

-- Classification

numeric1 = { AbsoluteValue=AbsoluteValue, Ceiling=Ceiling, 
  Exponential=Exponential, Factorial=Factorial, Floor=Floor, 
  Logarithm=Logarithm, Negate=Negate, Not=Not, PiTimes=PiTimes, 
  Reciprocal=Reciprocal, Roll=Roll, Signum=Signum }
numeric2 = { Add=Add, And=And, Binomial=Binomial, Circle=Circle, 
  Divide=Divide, Equal=Equal, Greater=Greater, GreaterEqual=GreaterEqual, 
  Less=Less, LessEqual=LessEqual, Maximum=Maximum, Minimum=Minimum, 
  Multiply=Multiply, Nand=Nand, Nor=Nor, NotEqual=NotEqual, Or=Or, 
  Power=Power, Residue=Residue, Subtract=Subtract }
monadic = { Clone=Clone, Execute=Execute, GradeDown=GradeDown, GradeUp=GradeUp,
  IndexGenerator=IndexGenerator, MatrixInverse=MatrixInverse, Ravel=Ravel,
  Reverse=Reverse, ReverseFirst=ReverseFirst, Shape=Shape, Squish=Squish,
  Transpose=Transpose }
dyadic = { Attach=Attach, AttachFirst=AttachFirst, Compress=Compress,
  CompressFirst=CompressFirst, Deal=Deal, Decode=Decode, Drop=Drop,
  ElementOf=ElementOf, Encode=Encode, Expand=Expand, ExpandFirst=ExpandFirst,
  Find=Find, Format=Format, MatrixDivide=MatrixDivide, Reshape=Reshape,
  Rotate=Rotate, RotateFirst=RotateFirst, Take=Take }
operator = { Reduce=Reduce, ReduceFirst=ReduceFirst, Scan=Scan, 
  ScanFirst=ScanFirst, Inner=Inner, Outer=Outer }
other = { Assign=Assign, Define=Define, Index=Index, Squish=Squish }

-- ----------- end of named APL functions -------------------

--[[ Mapping of APL symbols to Lua functions.
Entries are coded as specified in the comments to `make_function` below.
--]]

local APL = {
   ['?'] = {Roll,Deal,lua="query",expand=2},
   ⌈ = {Ceiling,Maximum,expand=3,unit=-Inf},
   ⌊ = {Floor,Minimum,expand=3,unit=Inf},
   ⍴ = {Shape,Reshape},
   ∼ = {Not,alias='~',expand=2},
   ∣ = {AbsoluteValue,Residue,expand=3,alias='|'},
   ⍳ = {IndexGenerator,Find,expand=2},
   ⋆ = {Exponential,Power,expand=3,alias='*'},
   − = {Negate,Subtract,expand=3,alias='-'},
   ['+'] = {Clone,Add,expand=3,unit=0,lua="plus"},
   ÷ = {Reciprocal,Divide,expand=3},
   × = {Signum,Multiply,expand=3,unit=1},
   [','] = {Ravel,Attach,lua="comma"},
   ⍪ = {nil,AttachFirst},
   ⌹ = {MatrixInverse,MatrixDivide},
   ○ = {PiTimes,Circle,expand=3},
   ⍟ = {Logarithm,Logarithm,expand=3,help="⍺⍟⍵ → math.log(⍵,⍺)"},
   ⌽ = {Reverse,Rotate},
   ⊖ = {ReverseFirst,RotateFirst},
   ['!'] = {Factorial,Binomial,expand=3,lua="shriek"},  
   ['<'] = {nil,Less,expand=3,lua="less"},
   ['>'] = {nil,Greater,expand=3,lua="greater"},
   ['='] = {nil,Equal,expand=3,lua="equal"},
   ≤ = {nil,LessEqual,expand=3},
   ≥ = {nil,GreaterEqual,expand=3},
   ≠ = {nil,NotEqual,expand=3},
   ≡ = {nil,Same},
   ∧ = {nil,And,expand=3,unit=0,alias='^'},
   ∨ = {nil,Or,expand=3,unit=1},
   ⍲ = {nil,Nand,expand=3},
   ⍱ = {nil,Nor,expand=3},
   ['.'] = {nil,Inner,lua="dot",operator=2},
   ['/'] = {Reduce,Compress,lua='slash',expand=0,operator=1,help=[[
If ⍺ is a vector, collects ⍺ copies of ⍵: 2 0 4 / 1 3 7 → 1 1 7 7 7 7
If ⍺ is a function, applies ⍺ in between ⍵: +/ 1 3 7 → 1+3+7 → 11
   Returns unit of `⍺` if `⍵` is empty.
]]},
   ⌿ = {ReduceFirst,CompressFirst,expand=0,operator=1},
   ['\\'] = {Scan,Expand,lua='backslash',expand=0,operator=1,help=[[
If ⍺ is a vector, puts in zeros: 2 0 4 \ 1 3 7 → 0 0 1 3 0 0 0 0 7
If ⍺ is a function, cumulatively applies ⍺ to ⍵: +/ 1 3 7 → 1 4 11
   Only defined when ⍺ has a unit u, i.e. an element such that ⍺(x,u)==x.
]]}, 
   ⍀ = {ScanFirst,ExpandFirst,expand=0,operator=1},
   ⊤ ={Decode},
   ∇ ={Define},
   ↓ ={Drop},
   ∊ ={ElementOf},
   ⊥ ={Encode},
   ⍕ ={Format,help=[[
1. ⍵ → tostring(⍵)
2. ⍺⍕⍵, ⍺='width.decimals', negative for e-format
   Or supply actual Lua format as a string.
   Vector-valued formats apply columnwise.
]]},
   ⍋ ={GradeUp, help=[[
GradeUp: ⍋⍵ → permutation that sorts ⍵ into ascending order]]},
   ⍒ ={GradeDown, help=[[
GradeDown: ⍒⍵ → permutation that sorts ⍵ into descending order]]},
   ∘ = {Pass},
   ⌷ = {Squish},
   ⌻ = {Unsquish}, 
   ↑ ={Take,help="Take first or last ⍺ items from ⍵; pad with zeros"},
   ⍉ ={Transpose},
   ⍎ = {Execute,help="Execute: ⍎⍵ → Define(⍵)()"}
}

-- create functions with APL semantics

local function create_monadic(f,expand)
   if not f then return end
   if expand<2 then return f end
   return function(⍵) 
      if is"table"(⍵) then 
         return Map(f,⍵) 
      else return f(⍵) 
      end
   end
end

local function create_dyadic(f,expand)
   if not f then return end
   if expand==0 then return f end
   if expand==1 then
      return function(⍵,⍺) 
         local g1=function(⍺) return f(⍵,⍺) end
         if is"table"(⍺) then 
            return Map(function(⍺) return f(⍵,⍺) end,⍺) 
            else return f(⍵,⍺) 
         end
      end
   end
   if expand==2 then
      return function(⍵,⍺) 
          if is"table"(⍵) then 
            return Map(function(⍵) return f(⍵,⍺) end,⍵) 
            else return f(⍵,⍺) 
            end
      end
   end
   if expand==3 then
      return function(⍵,⍺)
         local scalar⍺, scalar⍵ = is_not"table"(⍺), is_not"table"(⍵) 
         if scalar⍺ and scalar⍵ then return f(⍵,⍺) 
         elseif scalar⍵ then return Map(function(⍺) return f(⍵,⍺) end,⍺)
         elseif scalar⍺ then return Map(function(⍵) return f(⍵,⍺) end,⍵)
         else 
            local n = #⍺
            if n~=#⍵ then error("array arguments of unequal size") end
            return Map(function(i) return f(⍵[i],⍺[i]) end,IndexGenerator(n))
         end
      end
   end      
end

local alias = {} -- needed only by help function
local make_function = function(name,func)
--- make_function = function(name,func)
-- name: name by which APL compiler should recognize function
-- func: {monadic,dyadic,key=val,...}
--   monadic: the Lua function to be invoked when called with one argument
--   dyadic: the Lua function to be invoked when called with two arguments 
--     These parameters must loaded functions, not source code, but could
--     have been created by `∇` or written directly in Lua.
--   lua="LuaName": name to which the compiler should translate `name`,
--     only needed when `name` is a special character
--   alias="alias": another name recognized by the APL compiler as
--     referring to the same function
--   help="helptext": what should be printed by `help"name"`
--   expand=0: don't treat either argument termwise (default)
--     This is the proper case when the function makes its own
--     provision for array-valued arguments.
--   expand=1: apply termwise to ⍺ if array-valued
--   expand=2: apply termwise to ⍵ if array-valued
--   expand=3: apply termwise to either ⍺ or ⍵, which must be of 
--     equal length if both array-valued
--   operator=1: `monadic` is a monadic operator. 
--   operator=2: `dyadic` is a dyadic operator. 
--   operator=3: both are operators     
   local expand=func.expand or 0
   local f1 = create_monadic(func[1],expand)
   local f2 = create_dyadic(func[2],expand)
   local f
   if f1 and f2 then f =       
         function(⍵,⍺) return (⍺ and f2(⍵,⍺)) or f1(⍵) end
   else f = f1 or f2
   end
   if func.lua then alias[func.lua]=true end
   if func.alias then alias[func.alias]=name end
   if func.operator then 
      newoperator(f, name, func.lua, func.alias, func.help, func.operator) end
   if not func.operator or (f2 and func.operator==1) then
      newfunc(f, name, func.lua, func.alias, func.help)
   end
   if func.unit then unit[apl[name]]=func.unit end   
end

for name,func in pairs(APL) do make_function(name,func) end 
  
--- Customize the help system
-- Help is defined in three ways:
-- 1. Immediately after an A-Z function definition, there may be a call 
--    to 'help' giving the function and its helptext as arguments.
-- 2. In a function definition table, such as the entries of 'APL', there
--    may be field called 'help'.
-- 3. Very short functions not otherwise documented have their own
--    source code as help. This feature relies on `apl.lua` not having
--    been modified after it was loaded.

help(nil,[[
Assuming you have loaded the module as 'apl',
   ∇(str) -- acts like Lua's `load` except that `str` is coded in APL,
   ⍎(str) -- returns the value of ∇(str)()
   bare_APL_code -- same as ⍎"bare_APL_code"
Try "help(apl)" and "help(help)".]])
for topic in ("cache collect get iter keep map move set trisect")
  :gmatch"%S+" do help(topic,nil)
end
help("Arrays", [[
An APL array is a Lua table indexed from 1 upwards whose metatable has
been set for arithmetic and to-string conversion. If it represents a
matrix rather than a vector, it has a field `shape={#rows,#columns}`.

A small number of APL functions, such as `⌷`, can work with arrays in 
which the entries themselves are arrays.]])
help("Programming", [[
Big topic. Read the manual.]])   
help("Memos", [[
You can say `help(topic,"help text")` to define your own memo on the
given topic. A topic can be of any type, but it will only be listed
by `help"all"` if it is a string."]])
help("Variables",[[
APL variables are kept in the table `apl._V`, which becomes global `_V`
if you run `apl()`.]])
   
-- Redefine help to look in `helptext` and `APL` first.
local basichelp = help
help = function(s,...)
---    help(fct)
-- none: Prints short help. 
-- function: Prints the docstring of `fct`, if any; otherwise
--    its listing, if short enough.
-- table: Prints `help` field, if any; else contents.
-- string: Prints help on the topic, if any; otherwise if name of an
--    APL function, help on its monadic and dyadic usage.
-- "all": Prints available topics. 
   if not(s==s) then print(helptext.NaN) return end
   if alias[s] then s=alias[s] end
   if helptext[s] then print(helptext[s]) return end 
   if APL[s] and select('#',...)==0 then 
      for a=1,2 do if APL[s][a] then 
         io.write(a,". "); basichelp(APL[s][a])
      end end 
   else basichelp(s,...)
   end
end

-- report progress of project

local locals, missing = {},{}
for i=1,200 do
   local k,v = debug.getlocal(1,i)
   if not k then break else locals[k]=v end
end   
for k in ([[
   Roll, Ceiling, Floor, Shape, Not, AbsoluteValue, IndexGenerator, 
   Exponential, Negate, Clone, Signum, Reciprocal, Ravel, MatrixInverse,
   PiTimes, Logarithm, Reverse, ReverseFirst, GradeUp, GradeDown,
   Execute, Format, Transpose, Factorial, Attach, AttachFirst, Squish,
   Add, Subtract, Multiply, Divide, Power, Circle, Deal,
   Find, Maximum, Minimum, Reshape, Take, Drop, Decode, Encode, 
   Residue, Expand, Compress, MatrixDivide, Rotate, 
   RotateFirst, Format, Binomial, Less, LessEqual, 
   Equal, GreaterEqual, Greater, NotEqual, Or, And, Nor, Nand
   Reduce, ReduceFirst, Scan, ScanFirst, Inner, Outer 
   Assign, Define
]]):gmatch"%u%w*" do if not locals[k] then missing[k]=true end end 
print"The following forward declarations were not completed"
help(missing)
print"WARNING: Not all functions that should respect shape do so yet."

-- tie up loose ends

helptext['[']="Index: ⍵[i], ⍵[i;j], ⍵[i;], ⍵[;j]"
helptext[']']=helptext['[']
helptext.NaN = "NaN: Not-a-Number (whose type is 'number')"

local function reverse(f) return function(⍵,⍺) return f(⍺,⍵) end end
apl.NaN = NaN
apl._F = { numeric1=numeric1, numeric2=numeric2, monadic=monadic, 
   dyadic=dyadic, operator=operator, other=other } 
apl._V = setmetatable(_V,{__index=_ENV})
apl_meta.__tostring = Format 
apl_meta.__add = apl.plus
apl_meta.__sub = reverse(apl.−)
apl_meta.__mul = apl.×
apl_meta.__div = reverse(apl.÷)
apl_meta.__mod = reverse(apl.∣)
apl_meta.__pow = reverse(apl.⋆)
apl_meta.__unm = apl.−
apl_meta.__concat = reverse(apl.comma)
apl_meta.__index = Index
apl.Assign = Assign
apl.make_function = make_function

setmetatable(apl,{
__call = 
   function(apl,env)
      env = env or _ENV
      env.⍎ = apl.⍎
      env.∇ = apl.∇ 
      env.lua = apl.lua
      env.help = help  
   end})

setmetatable(_ENV,meta_ENV)
loading=false
return apl

--[[ BUGS
Not supported:
  domino function
Not matrix-aware yet: Expand, Compress, Inner, Outer
  APL array might include information "apply row-wise", "apply columnwise"
  to ⍺ and to ⍵. 
Not enough runtime checks on input values.
Format bugs
  support for strings and matrices still sketchy 
  NaN in a matrix
Many individual bugs, not all functions fully tested.
--]]
