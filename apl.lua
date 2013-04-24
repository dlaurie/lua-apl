-- apl.lua  (c) Dirk Laurie 2013  Lua-style MIT licence

if ⍺ then end -- in order to diagnose whether UTF-8 codepoints are names

-- There is not much fun in viewing this file unless you have a UTF-8 font 
-- with decent APL glyphs. Consult the README.

-- Dependencies

local core = require"apl_core"
local  get,      move,      map,      where,      transpose = 
  core.get, core.move, core.map, core.where, core.transpose
local set = function(t,...) core.set(t,...) return t end

help = require"help"

local sqrt,      log,      abs,      min,      max,      exp,      Inf = 
 math.sqrt, math.log, math.abs, math.min, math.max, math.exp, math.huge
local random, concat, unpack = math.random, table.concat, table.unpack

-- This is kept in while the program is under development

local orig_ENV=_ENV
setmetatable(_ENV,{__newindex = function (ENV,name,value)
   local w=where(2)
   if name:match"^%a%d?$" then 
      print(w.."A global name like '"..name.."' is asking for trouble.")
   end
   rawset(ENV,name,value)
end})

-- check the Lua version
if not _VERSION:match"Lua 5.2" then 
   print ("WARNING: 'apl.lua' has not been tested with ".._VERSION..
      ". You are on your own!")
   end

-- semi-globals, available as upvalues anywhere in this file

local apl={}         -- The module table
local _APL = {}      -- APL's namespace; later assigned to apl._V 
local apl_meta = {}  -- Metatable for APL arrays 
local helptext={}    -- Help for a few specific APL symbols
local apl2lua        -- APL to Lua compiler
local unit={}        -- Unit elements for functions that have them

-- ---------  Forward declaration of all basic APL functions  -------------
-- These names are not exported

-- Monadic functions
local Roll, Ceiling, Floor, Shape, Not, AbsoluteValue, IndexGenerator, 
   Exponential, Negate, Clone, Signum, Reciprocal, Ravel, MatrixInverse,
   PiTimes, Logarithm, Reverse, ReverseFirst, GradeUp, GradeDown, Squish,
   Execute, Transpose, Factorial  
-- Dyadic functions
local Add, Subtract, Multiply, Divide, Power, Circle, Deal,
   ElementOf, Maximum, Minimum, Reshape, Take, Drop, Decode, Encode, 
   Residue, Expand, ExpandFirst, Compress, CompressFirst, Find, 
   Attach, AttachFirst, MatrixDivide, Rotate, RotateFirst, Format, 
   Binomial, Less, LessEqual, Equal, GreaterEqual, Greater, NotEqual, 
   Or, And, Nor, Nand
-- Operators 
local Reduce, ReduceFirst, Scan, ScanFirst, Inner, Outer 
-- Other
local Assign, Define, Squish, Index
-- Local utilities, not mapped to symbolic APL functions
local First, Invert, Map

-- -----------------------------------------------------------------
-- Auxiliary functions

local argcheck = function(cond,pos,fct,msg)
   if not cond then
      error(("bad argument "..pos.." to %s: %s"):format(fct,msg))   
   end
end

local arr = function(a) return setmetatable(a,apl_meta) end

local checktype = function(val,typ,pos,fct)
   if type(val)~=typ then 
      error(("bad argument "..pos.." to %s: expected %s, got %s"):format
            (fct,typ,type(val)))   
   end
end

local function is(typ) return function(x) return type(x)==typ end end
local function is_int(x) return is"number"(x) and x==Floor(x) end
local function is_not(typ) return function(x) return type(x)~=typ end end

local qsort3
qsort3 = function (tbl,cmp,first,last,p)
  if last<=first then return end
  local i,j = core.trisect(tbl,first,last,tbl[random(first,last)],cmp,p)
  qsort3(tbl,cmp,first,i,p)
  qsort3(p,nil,i+1,j-1,tbl)
  qsort3(tbl,cmp,j,last,p)
end 

local sort = function(tbl,cmp,first,last)
  first=first or 1; last=last or #tbl
  local invert=last<first
  if invert then 
    move(tbl,first,last,last,first); first,last=last,first;
  end
  local p={}; for k=first,last do p[k]=k end
  if last==first then return p end
  if invert then move(p,first,last,last,first) end
  qsort3(tbl,cmp,first,last,p)
  if invert then 
    move(tbl,first,last,last,first); move(p,first,last,last,first) 
    first,last=last,first;
  end
  return p
end

local function utflen(s)
   return #s:gsub("[\xC0-\xEF][\x80-\xBF]*",'.')
end

First = function(fct,tbl)
   for k,v in ipairs(tbl) do if fct(v) then return k end end
end

Invert = function(⍵) 
   local t=arr{} 
   for k,v in ipairs(⍵) do t[v]=k end 
   return t
end


Map = function(ft,tbl) return arr(map(tbl,1,#tbl,ft,{})) end
--- Applies ft to every element of tbl. ft may be a function or a table.

-- Package for the circle functions. This should be implemented 
-- in C for the sake of efficiency and in order to avoid the fancy 
-- footwork required to preserve significance near 0.

local circ0 = function(x) return sqrt(1-x^2) end
local circ4 = function(x) return sqrt(1+x^2) end
local circ_4 = function(x) return sqrt(-1+x^2) end

local log1p = function(x)
   local u=1+x
   if u==1 then return x end
   return log(u)*x/(u-1)
end

local asinh = function(x)
   local s=abs(x)
   s=log1p(s*(1+s/(circ_4(x)+1)))
   if x<0 then return -s else return s end
end

local acosh = function(x) 
   return log(x+circ_4(x))
end

local atanh = function(x) 
   local s=abs(x)
   s=log1p(2*s/(1-s))/2
   if x<0 then return -s else return s end   
   end

local circfunc = {
   [0] = circ0; -- sqrt(1-⍵^2)
   [1] = math.sin;
   [2] = math.cos;
   [3] = math.tan;
   [4] = circ4; -- sqrt(1+⍵^2) 
   [5] = math.sinh;
   [6] = math.cosh;
   [7] = math.tanh;
   [-1] = math.asin;
   [-2] = math.acos;
   [-3] = math.atan;
   [-4] = circ_4; -- sqrt(⍵^2-1)
   [-5] = asinh;
   [6] = acosh;
   [7] = atanh;
}
help('CircleFunctions', [[
  (¯4 0 4 ○ ⍵) = ((⍵^2-1)⋆0.5,(1-⍵^2)⋆0.5,(1+⍵^2))
   (1 2 3 ○ ⍵) = (sin ⍵, cos ⍵, tan ⍵)
   (5 6 7 ○ ⍵) = (sinh ⍵, cosh ⍵, tanh ⍵)
  (⍺ ○ (-⍺) ⍵) = ⍵ ]])

-- -------------  Lua APL functions A-Z  -------------------------------

-- It's annoying, I know, that the _left_ operand in infix notation 
-- maps to the _second_ operand in postfix notation, but there is
-- method in the madness.

AbsoluteValue = math.abs; help(AbsoluteValue, "∣⍵ → math.abs(⍵)")
Add = function(⍵,⍺) return ⍺+⍵ end
And = function(⍵,⍺) return ⍵~=0 and ⍺~=0 and 1 or 0 end
Assign = function(⍵,⍺) _APL[⍺]=⍵ return ⍵ end

Attach = function(⍵,⍺)
   ⍺=Ravel(⍺)
   if is_not"table"(⍵) then ⍺[#⍺+1]=⍵ else set(⍺,#⍺+1,nil,get(⍵,1,#⍵)) end
   return ⍺
end
help(Attach,"Attach: ⍺,⍵ → elements of ⍺ followed by elements of ⍵")

AttachFirst = function(⍵,⍺)
   top, bottom = Ravel(⍺), Ravel(⍵)
   local cols = function(x) 
      return  x.shape and x.shape[2]  or  is"table"(x) and #x  or  1
   end
   local rows = function(x) 
      return  x.shape and x.shape[1]  or  1
   end
   local n=cols(⍺)
   argcheck(cols(⍵)==n,2,'AttachFirst','Rows must be of equal length')
   set(top,#top+1,nil,get(bottom,1,#bottom))
   top.shape = arr{rows(⍺)+rows(⍵),n}
   return top
end   
help(AttachFirst,[[
AttachFirst: ⍺⍪⍵ → rows of ⍺ followed by rows of ⍵
   Scalars and vectors are turned into rows.]])

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
   for k,v in ipairs(⍵) do if ⍺[k]>0 then 
      set(t,#t+1,#t+⍺[k],v)
   end end
   return t
end
CompressFirst = Compress  -- will change when shape is implemented

Deal = function(⍵,⍺)
   argcheck(⍺<=⍵,'pair','Deal',"can't deal "..⍺.." from "..⍵)
   local p=IndexGenerator(⍵)
   local t=arr{}
   for k=1,⍺ do local j=Roll(⍵); t[k],p[j],⍵ = p[j],p[⍵], ⍵-1 end
   return t
end
help(Deal,"⍺?⍵ → ⍺ distinct numbers randomly selected from ⍳⍵")

Decode = function(⍵,⍺)
   local t,d=arr{}   
   checktype(⍵,'number','⍵','Decode')
   if is"table"(⍺) then for k=#⍺,1,-1 do d=⍵%⍺[k]; t[k]=d; ⍵=(⍵-d)/⍺[k] end
   else 
      repeat d=⍵%⍺; t[#t+1]=d; ⍵=(⍵-d)/⍺ until ⍵==0
      move(t,1,#t,#t,1)
   end
   return t
end
help(Decode,"Decode: ⍵⊤⍺ → Decompose ⍺ into base ⍵ digits")

Define = function(⍵)
   checktype(⍵,'string',1,'Define')
   local lua,p,msg = apl2lua(⍵)
   if not lua then error("bad input to apl2lua: "..msg.."\n"..⍵..
     "\n"..string.rep(" ",utflen(⍵:sub(1,p)))..'↑')
   end
   local f = load('local ⍵,⍺=... return '..lua,nil,nil,apl)
   if not f then error("Could not compile: "..⍵.."\n Tried: "..lua) end
   help(f,⍵)
   return f   
end
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

Encode = function(⍵,⍺)
   local p=0
   if is"table"(⍺) then for k=1,#⍺ do p=⍺[k]*p+⍵[k] end   
   else for k=1,#⍵ do p=⍺*p+⍵[k] end
   end
   return p
   end
help(Encode,"Encode: ⍵,⍺ → Calculate ⍺ given its base ⍵ digits")

Equal = function(⍵,⍺) return ⍺==⍵ and 1 or 0 end; 

Execute = function(⍵) 
   local v=_APL[⍵]
   if v then return v else return Define(⍵)() end 
end
helptext.⍎="Execute: ⍎⍵ → Define(⍵)()"

Expand = function(⍵,⍺)
   local t=arr{}
   for k,v in ipairs(⍵) do 
      t[#t+1]=v
      if ⍺[k]>0 then set(t,#t+1,#t+⍺[k],0) end
   end
   return t
end
ExpandFirst = Expand  -- will change when shape is implemented
   
Exponential = math.exp; help(Exponential,"⍵ → math.exp(⍵)")
Factorial = function(⍵) local f=1; for k=2,⍵ do f=f*k end; return f end

Find = function(⍵,⍺)
   return First(function(x) return x==⍺ end,⍵) or 0
end
help(Find,"⍺⍳⍵ → position of first occurrence of ⍺ in ⍵")

Floor = math.floor; help(Floor, "⍵ → math.floor(⍵)")

GradeUp = function(⍵) 
   ⍵ = Clone(⍵) 
   return arr(sort(⍵,nil,1,#⍵))
   end;
help(GradeUp,"⍋⍵ → permutation that sorts ⍵ upwards")

GradeDown = function(⍵) 
   ⍵ = Clone(⍵) 
   return arr(sort(⍵,nil,#⍵,1))
   end;
help(GradeDown,"⍒⍵ → permutation that sorts ⍵ downwards")

Greater = function(⍵,⍺) return ⍺>=⍵ and 1 or 0 end
GreaterEqual = function(⍵,⍺) return ⍺>=⍵ and 1 or 0 end

Index = function(⍵,⍺)
   checktype(⍵,'table','⍵','Index')
   local ⍵shape = rawget(⍵,'shape')
   if is"table"(⍺) then 
      if not ⍵shape then
         local t=arr{} 
         for k,v in ipairs(⍺) do t[k]=⍵[v] end
         if is"table"(t[1]) then return Squish(t) end
         t.shape=rawget(⍺,'shape')
         return t
       end
       local i,j, m,n = ⍺[1],⍺[2], ⍵shape[1],⍵shape[2] 
       if is"number"(i) and is"number"(j) then return ⍵[j+n*(i-1)]
       elseif is"number"(i) and j==nil then
          local t, j0 = arr{}, n*(i-1) 
          for j=1,n do t[j]=⍵[j+j0] end
          return t
       elseif i==nil and is"number"(j) then
          local t = arr{} 
          for i=1,n do t[i]=⍵[j+n*(i-1)] end
          return t
       end
   else return rawget(⍵,⍺) 
   end              
end

IndexGenerator = 
   function(⍵) 
      checktype(⍵,'number',1,"⍳")
      local t=arr{} 
      for i=1,⍵ do t[i]=i end; return t 
   end
help(IndexGenerator,"IndexGenerator: ⍳⍵ → {1,2,...,⍵}") 

Less = function(⍵,⍺) return ⍺<⍵ and 1 or 0 end
LessEqual = function(⍵,⍺) return ⍺<=⍵ and 1 or 0 end
Logarithm = math.log; helptext.⍟="⍺⍟⍵ → math.log(⍵,⍺)"
Maximum = math.max; help(Maximum,"⍺⌈⍵ → math.max(⍵,⍺)")
Minimum = math.min; help(Minimum,"⍺⌊⍵ → math.min(⍵,⍺)")
Multiply = function(⍵,⍺) return ⍺*⍵ end 
Nand = function(⍵,⍺) return ⍵~=0 and ⍺~=0 and 0 or 1 end
Negate = function(⍵) return -⍵ end
Nor = function(⍵,⍺) return (⍵~=0 or ⍺~=0) and 0 or 1 end
Not = function(⍵) if ⍵==0 then return 1 else return 0 end end
NotEqual = function(⍵,⍺) return ⍺~=⍵ and 1 or 0 end
Or = function(⍵,⍺) return (⍵~=0 or ⍺~=0) and 1 or 0 end
Outer = function() return end
Pass = function() return end
PiTimes = function(⍵) return math.pi*⍵ end
Power = function(⍵,⍺) return ⍺^⍵ end

Ravel = function(⍵) 
   if is_not"table"(⍵) then return arr{⍵} end
   ⍵=Clone(⍵); ⍵.shape=nil; return ⍵
end
help(Ravel,"Ravel: ,⍵ -- forces ⍵ to be a vector")

Reciprocal = function(⍵) return 1/⍵ end

Reshape = function (⍵,⍺)
   local tomatrix = is"table"(⍺) and #⍺==2 and ⍺[1]>=0 and ⍺[2]>=0 
   local tovector = is_int(⍺) and ⍺>=0
   argcheck(tomatrix or tovector,'⍺','Reshape',
      'must reshape to vector or matrix')
   local t=arr{shape=tomatrix and ⍺}
   local n=tomatrix and ⍺[1]*⍺[2] or ⍺
   if n==0 then return t end
   if is"table"(⍵) then argcheck(#⍵>0,'⍵','Reshape','empty vector given')
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

Shape = function(⍵) 
   if is"table"(⍵) then
      if ⍵.shape then return ⍵.shape else return arr{#⍵} end
   elseif is"string"(⍵) then return #⍵
   else return arr{}
   end
end
help(Shape,[[
Shape: ⍴⍵ → #⍵ if a vector, nil if a scalar, {rows,cols} if a matrix]])

Signum = function(⍵) return ⍵<0 and -1 or ⍵>0 and 1 or 0 end 

Squish = function(⍵) 
   if is_not"table"(⍵) then return ⍵ end
   local j=First(is'table',⍵) 
   if not j then return arr(⍵) end
   local m,n=#⍵[j],#⍵
   local culprit = First(is_not'table',⍵)
         or First(function(x) return #x~=m end,⍵)
   if culprit then argcheck(false,'⍵','Squish',
      'column '..culprit..' and column '..j..' have different length')
   end
   local s,j = arr{shape={n,m}},0
   for i=1,n do set(s,j+1,j+m,get(⍵[i],1,m)); j=j+m end
   return Transpose(s)
end
helptext.⌷=[[
Squish: ⌷⍵ → APL array with the same elements as ⍵
   Matrix is given by supplying columns. Scalars returned unchanged.]]

Subtract = function(⍵,⍺) return ⍺-⍵ end
    
Take = function(⍵,⍺)
   local len,given,t = abs(⍺),#⍵,arr{}
   if len<1 then return t end
   set(t,1,len,0)
   local n=Minimum(len,given)
   if ⍺<0 then set(t,len,len-n+1,get(⍵,given,given-n+1))
   else set(t,1,n,get(⍵,1,n))
   end
   return t
end
helptext.↑ = "Take first or last ⍺ items from ⍵; pad with zeros"

Transpose = function(⍵)
   if not is"table"(⍵) then return ⍵ end
   local s=⍵.shape
   if not s then return Clone(⍵) end
   return arr(transpose(⍵,s[1],s[2],{shape={s[2],s[1]}}))
end   
help(Transpose,'Transpose: ⍉⍵ → matrix transpose of ⍵')

-- Operators and other exceptions

Inner = function(f1,f2) 
   if f1==Pass then return Outer(f2) end
   return function(⍵,⍺) 
      local n = #⍵
      argcheck(n==#⍺,'⍺',"Inner","unequal array sizes")
      argcheck(not ⍺.shape,'⍺',"Inner","Can't handle matrices ")      
      argcheck(not ⍵.shape,'⍵',"Inner","Can't handle matrices ")  
      local y=f2(⍵[n],⍺[n])
      for k=n-1,1,-1 do 
         y=f1(y,f2(⍵[k],⍺[k]))
      end
      return y
   end
end

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

Reduce = function(⍺)
   local u=unit[⍺]
   return function(⍵)
      if #⍵==0 then return u or argcheck(false,'⍺','Reduce',
         "empty arguments to a function with no unit") end
      local res=⍵[#⍵]
      for k=#⍵-1,1,-1 do res=⍺(res,⍵[k]) end
      return res
   end
end
helptext['/'] = [[
If ⍺ is a vector, collects ⍺ copies of ⍵: 2 0 4 / 1 3 7 → 1 1 7 7 7 7
If ⍺ is a function, applies ⍺ in between ⍵: +/ 1 3 7 → 1+3+7 → 11
   Returns unit of `⍺` if `⍵` is empty.
]]
ReduceFirst = Reduce  -- will change when shape is implemented

Scan = function(⍺)
   argcheck(unit[⍺],'⍺','Scan',"function with no unit")
   return function(⍵)
      if #⍵==0 then return unit[⍺] end
      local res=arr{⍵[1]}
      for k=2,#⍵ do res[k]=⍺(⍵[k],res[k-1]) end
      return res
   end
end
helptext['\\'] = [[
If ⍺ is a vector, puts in zeros: 2 0 4 \ 1 3 7 → 0 0 1 3 0 0 0 0 7
If ⍺ is a function, cumulatively applies ⍺ to ⍵: +/ 1 3 7 → 1 4 11
   Only defined when ⍺ has a unit u, i.e. an element such that ⍺(x,u)==x.
]]
ScanFirst = Scan  -- will change when shape is implemented

-- Format

local function aplformat(f)
   return '%'..("%.1f"):format(abs(f))..(f<0 and 'e' or 'f')   
end
local function defaultformat(⍵)
   local ⎕pp = _APL.⎕pp or 5
   if is_not"table"(⍵) then 
      if is_int(⍵) then return "%d" else return "%."..⎕pp.."f" end
   end
   local function S(x) if x<0 then x=10*abs(x) end; return x end
   local mx=0
   local nonint=First(function(x) return not is_int(x) end,⍵)
   if not ⍵.shape then return nonint and "%."..⎕pp.."f" or "%d" end
   for k,v in ipairs(⍵) do 
      if nonint then mx=Maximum(mx,#("%."..⎕pp.."f"):format(S(v)))
      else mx=Maximum(mx,#("%d"):format(v)) 
      end
   end
   return "%"..mx..(nonint and '.'..⎕pp..'f' or 'd')
end

Format = function(⍵,⍺)    
   if is"string"(⍵) then return ⍵ end
   if is"table"(⍺) then ⍺=Map(aplformat,⍺) 
   else       
      ⍺ = (⍺ and aplformat(⍺)) or _APL.⎕format or defaultformat(⍵)
   end
   if is"table"(⍵) then
      local f={}
      if is"string"(⍺) then for k,v in ipairs(⍵) do 
         f[k]=⍺:format(v) 
      end
      elseif is"table"(⍺) then 
         for k,v in ipairs(⍵) do f[k]=Format(v,⍺[k]) end
      else checktype(⍺,'table',2,'Format')
      end
      local s=⍵.shape
      if s then 
         local k,m,n,r = 1,s[1],s[2],{}
         for i=1,m do r[i]=concat(f,' ',k,i*n); k=k+n end
         return concat(r,'\n')
      else return concat(f,' ')
      end
   else return ⍺:format(⍵)     
   end
end 
helptext.⍕ = 
"1. ⍵ → tostring(⍵)\n2. ⍺⍕⍵, ⍺='width.decimals', negative for e-format" 
apl_meta.__tostring = Format       

-- ----------- end of named APL functions -------------------

--[[ Mapping of APL symbols to Lua functions

Non-ASCII alternatives are used whenever available, but the corresponding
ASCII symbols also work. This list contains only ambi-adic functions 
and functions that can be applied termwise. See "Direct Equivalences".

   [1]: which function when monadic?
   [2]: which function dyadic?
   expand=0: don't treat either argument termwise
   expand=1: termwise application to ⍺
   expand=2: termwise application to ⍵ (default)
   expand=3: termwise application to ⍺ and ⍵ simultaneously
   scalar=0: table-valued arguments allowed (default)
   scalar=1: ⍺ must be scalar
   scalar=2: ⍵ must be scalar
   scalar=3: ⍺ and ⍵ must both be scalar 

--]]

local APL = {
   ['?'] = {Roll,Deal},
   ⌈ = {Ceiling,Maximum,expand=3,unit=-Inf},
   ⌊ = {Floor,Minimum,expand=3,unit=Inf},
   ⍴ = {Shape,Reshape,expand=0},
   ∼ = {Not},
   ∣ = {AbsoluteValue,Residue,expand=3},
   ⍳ = {IndexGenerator,Find,expand=1},
   ⋆ = {Exponential,Power,expand=3},
   − = {Negate,Subtract,expand=3},
   ['+'] = {Clone,Add,expand=3,unit=0},
   ÷ = {Reciprocal,Divide,expand=3},
   × = {Signum,Multiply,expand=3,unit=1},
   [','] = {Ravel,Attach,expand=0},
   ['⍪'] = {nil,AttachFirst,expand=0},
   ⌹ = {MatrixInverse,MatrixDivide,expand=0},
   ○ = {PiTimes,Circle,expand=3},
   ⍟ = {Logarithm,Logarithm,expand=3},
   ⌽ = {Reverse,Rotate,expand=0},
   ⊖ = {ReverseFirst,RotateFirst,expand=0},
   ['!'] = {Factorial,Binomial,expand=3},  
   ['<'] = {nil,Less,expand=3},
   ['>'] = {nil,Greater,expand=3},
   ['='] = {nil,Equal,expand=3},
   ≤ = {nil,LessEqual,expand=3},
   ≥ = {nil,GreaterEqual,expand=3},
   ≠ = {nil,NotEqual,expand=3},
   ∧ = {nil,And,expand=3,unit=0},
   ∨ = {nil,Or,expand=3,unit=1},
   ⍲ = {nil,Nand,expand=3},
   ⍱ = {nil,Nor,expand=3},
   ['.'] = {Outer,Inner,scalar=3},
}
local operator = { slash=1, backslash=1, ['/']=1, ['\\']=1, ⌿=1, ⍀=1,
   ['.']=2, dot=2}

-- define aliases
local alias = {}
for k,v in pairs{⋆='*', ∼='~', ∣='|', ∧='^', −='-'} do 
   APL[v]=APL[k]; alias[v]=k
end
for k,v in pairs{query='?',shriek='!',dot='.',comma=',',plus='+',slash='/',
      backslash='\\',less='<',greater='>',equal='='} do 
  APL[k]=APL[v]; alias[v]=k 
end

-- create functions with APL semantics

local function create_monadic(f,expand)
   if expand<2 then return f end
   return function(⍵) 
      if is"table"(⍵) then 
         return Map(f,⍵) 
      else return f(⍵) 
      end
   end
end

local function create_dyadic(f,expand)
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

for name,func in pairs(APL) do if not alias[name] then
   local expand=func.expand or 2
-- local scalar=func.scalar or 0
   local f1 = func[1] and create_monadic(func[1],expand)
   local f2 = func[2] and create_dyadic(func[2],expand)   
   if f1 and f2 then 
      apl[name] = 
         function(⍵,⍺) return (⍺ and f2(⍵,⍺)) or f1(⍵) end
   else apl[name] = f1 or f2
   end
   if func.unit then unit[apl[name]]=func.unit end
end end

apl['/'] = function(⍵,⍺) 
   if is"function"(⍺) then return Reduce(⍺)(⍵) 
      elseif ⍺==nil then return Reduce(⍵)
      else return Compress(⍵,⍺) 
   end
end
apl.slash = apl['/']

apl['\\'] = function(⍵,⍺) 
   if is"function"(⍺) then return Scan(⍺)(⍵) 
      elseif ⍺==nil then return Scan(⍵)
      else return Expand(⍵,⍺) 
   end
end
apl.backslash = apl['\\']

apl.⌿ = function(⍵,⍺) 
   if is"function"(⍺) then return ReduceFirst(⍺)(⍵) 
      elseif ⍺==nil then return ReduceFirst(⍵)
      else return CompressFirst(⍵,⍺) 
   end
end

apl.⍀ = function(⍵,⍺) 
   if is"function"(⍺) then return ScanFirst(⍺)(⍵) 
      elseif ⍺==nil then return ScanFirst(⍵)
      else return ExpandFirst(⍵,⍺) 
   end
end

--- APL-to-Lua compiler
-- The "get" functions all take a string and a starting position,
-- and return a one-item table and a stopping position.

local function get_name(str,pos)
--- get_name allows standard Lua names (except those starting with an 
-- underscore) and names that start with a UTF-8 codepoint but are otherwise 
-- standard. It does not allow UTF-8 codepoint anywhere else. It actually 
-- is a little more permissive, but I'm not documenting the details.
   local p,q = str:find("^[A-Za-z\xC0-\xEF][A-Za-z_0-9\x80-\xBF]*",pos or 1)
   if p and not apl[str:sub(p,p)] then return str:sub(p,q),q end
end

local function get_number(str,pos)
--- Like Lua numbers, except that high-minus replaces minus and 
-- plus must not be used.
   pos = pos or 1
   local numbers = "^%s*([0-9.¯][0-9.¯eE]*)"
   local p,q = str:find(numbers,pos)
   if p then 
      p=str:match(numbers,pos):gsub("¯","-")
      if not tonumber(p) then error("Malformed number: "..p) end
      return p,q 
   end
end

local function is_apl(s)
   return is"function"(apl[alias[s]]) and alias[s] or is"function"(apl[s]) and s 
end

local function get_one_char(str,pos)
   pos=pos or 1
   local p,q = str:find("^[\xC0-\xFD][\x80-\xBF]+",pos)
   if q then return str:sub(p,q),q else return str:sub(pos,pos),pos end
end
   
local param = {⍺=1,⍵=2}
local function get_one_item(str,pos)
--- Get one item and classify it. Classes are:
-- func: name of an APL function or a function-valued item
-- value: ⍺, ⍵, a number, or a vector of numbers 
-- name: an unknown key, or name of a non-function-valued item
-- blank: only whitespace
-- msg: syntax error message
-- Possible ENHANCEMENT: for operators on user-defined functions, extra 
-- code will be needed at `--//`
   local function maybe_operator(s,p)
      s = is_apl(s)
      local t,q = get_one_char(str,p+1) -- is `s` followed by an operator?
      t = is_apl(t)
      if operator[t]==1 then                -- monadic operator
          return {func=("%s(%s)"):format(t,s)},q
      elseif  operator[t]==2 then     -- dyadic operator
         local u,r = get_one_char(str,q+1)  --// See above: ENHANCEMENT
         u=is_apl(u)
         if not u then return {msg="APL function needed here"},q end
         return {func=("%s(%s,%s)"):format(t,s,u)},r
      else                            -- not followed by an operator 
         return {func=s},p 
      end
   end

   local s,p = str:find("^%s*%S",pos or 1)  -- find first non-blank
   if not p then return {blank=''},#str end
   pos=p; s,p = str:find("^%b()",pos) -- look for balanced parentheses
   if s then return {value=apl2lua(str:sub(s+1,p-1))},p end  
   if str:find("^[%(%)]",pos) then
      return {msg="unbalanced parenthesis"},p
   end 

   s,p = get_one_char(str,pos)  
   if is_apl(s) then return maybe_operator(s,p) end
   s,p = get_number(str,pos)    
   if not s then                -- Not a number? Then it can only be a name
      s, p = get_name(str,pos)
      if not s then return {msg="what's this?"},pos end
      if is"function"(_APL[s]) then  --// See above: ENHANCEMENT
         return {func='_V.'..s},p
      elseif param[s] then return {value=s},p
      else return {name=s},p 
      end
   end
   local v = {s}
   repeat  -- look for more numbers
      pos = p+1
      s,pos = get_number(str,pos)
      if s then v[#v+1] = s; p=pos end
   until not s
   if #v>1 then s='{'..concat(v,',')..'}' else s=v[1] end
   return {value=s},p
end
            
apl2lua = function(str,p)
--- apl2lua(str)
-- Translates an APL expression to a Lua expression. 
-- Returns a string or nil,position,message
   p=p or 1
   local ⍺, ⍵, f, a1, a2, p1, p2, p3, msg

   a1,p1 = get_one_item(str,p)
   if a1.msg then return nil,p1,a1.msg end
   if a1.blank then return "" end
   if a1.func then                            -- monadic function
      if get_one_item(str,p1+1).func=='←' then
         return nil,p-1,"must have name of a non-function here" end
      f=a1.func; ⍵,p2,msg = apl2lua(str,p1+1) -- ⍵ is everything to the right
      if not ⍵ then return nil,p2,msg end
      if #⍵==0 then return nil,p1,
         "Non-function required here" end
      return ("%s(%s)"):format(f,⍵)
   end

   a2,p2 = get_one_item(str,p1+1)
   if a2.msg then return nil,p2,a2.msg end
   ⍺ = a1.value or '_V.'..a1.name               -- first argument    
   if a2.blank then return ⍺,#str end    -- just the one item
   if not a2.func then return nil,p1,"two adjacent non-functions" end

   f=a2.func; ⍵,p3,msg=apl2lua(str,p2+1) -- ⍵ is everything to the right
   if not ⍵ then return nil,p3,msg end
   if f=='←' then -- assignment is special
      if a1.name then ⍺="'"..⍺:gsub('_V%.','').."'"
      else return nil,p,"must have a name here"
      end
   end
   return ("%s(%s,%s)"):format(f,⍵,⍺) 
end

-- Direct equivalence

apl.← = Assign
apl.⊤ = Decode
apl.∇ = Define
apl.↓ = Drop
apl.∊ = ElementOf
apl.⊥ = Encode
apl.⍎ = Execute
apl.⍕ = Format
apl.⍋ = GradeUp
apl.⍒ = GradeDown
apl.∘ = Pass
apl.⌷ = Squish
apl.↑ = Take
apl.⍉ = Transpose

-- Customize the help system

help(nil,[[
Assuming you have loaded the module as 'apl',
   apl()  -- makes all APL functions global, after which:
   ∇(str) -- returns a function that returns the specified APL expression,
   ⍎(str) -- returns the value of ∇(str)()
Try "help(apl)" and "help(help)".]])
for topic in ("cache collect get iter keep map move set trisect")
  :gmatch"%S+" do help(topic,nil)
end
help("Arrays", [[
An APL array is a Lua table indexed from 1 upwards whose metatable has
been set for arithmetic and to-string conversion. If it represents a
matrix rather than a vector, it has a field `shape={#rows,#columns}`.]])
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
   if helptext[s] then print(helptext[s]) return end 
   if APL[s] and select('#',...)==0 then 
      for a=1,2 do if APL[s][a] then 
         io.write(a,". "); basichelp(APL[s][a])
      end end 
   else basichelp(s,...)
   end
end

-- report progress of project

locals = {}; missing = {}
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
print"WARNING: No current function except ⍴ and ⍕ respects shape."

apl._V = setmetatable(_APL,{__index=_ENV})
apl.lua = function(⍵)
--- returns Lua code of ⍵
   if is"function"(⍵) then return debug.getinfo(⍵).source 
   else return "Not a function"
   end
end
local function reverse(f) return function(⍵,⍺) return f(⍺,⍵) end end
apl_meta.__add = apl.plus
apl_meta.__sub = reverse(apl.−)
apl_meta.__mul = apl.×
apl_meta.__div = reverse(apl.÷)
apl_meta.__mod = reverse(apl.∣)
apl_meta.__pow = reverse(apl.⋆)
apl_meta.__unm = apl.−
apl_meta.__concat = reverse(apl.comma)
apl_meta.__index = Index

setmetatable(apl,{
__call = 
   function(apl,env)
      env = env or _ENV   
      for k,v in pairs(apl) do 
          if not alias[k] and not k:match"^_" then _ENV[k]=v 
      end end
   end})

-- setmetatable(_ENV,orig_ENV)
return apl

--[[ BUGS
Not supported:
  shape
  indexing
Not enough runtime checks on input values.
--]]
