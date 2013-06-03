-- apl-lib.lua  (c) Dirk Laurie 2013  Lua-style MIT licence

-- APL functionality, Lua names.
-- APL arrays are Lua tables.
-- APL functions are Lua functions of two variables, returning one
--   return value. Monadic functions are merely those that do not
--   actually use the second argument. 
-- APL scalars are Lua numbers and strings. Other Lua types will be
--   treated as scalar but are not tested for.

-- The Shape function treats a string as something halfway between
--   a scalar and a vector.
--   Rank-0: Shape(x) = {}
--   Rank-1: Shape(x) = {#x}
--   Rank-2: Shape(x) = {rows,cols}
--   string: Shape(x) = #x 

-- The module returns a table. Naming convention:
--
-- CamelCase: APL function-- lowercase: utilities
-- _CAPS:     needed by system, or gives information

-- For most of the individual functions, the help system provides the 
-- only specific documentation. Recommended interactive usage:
-- 
--    apl = require'apl-lib'  
--    apl:import"help"  -- imports `help` into _ENV 
--    help"Name"        -- displays help on individual function "Name"
--    help(apl)         -- displays module table
--    apl:import()      -- imports all CamelCase names into _ENV

-- Dependencies: custom APL core, help.lua, standard libraries

local core = require"apl_core"
local  get,      move,      where,      transpose,      pick
= core.get, core.move, core.where, core.transpose, core.pick
local  each,      both,      compat,      iota,      rho
= core.each, core.both, core.compat, core.iota, core.rho
local set = function(t,...) core.set(t,...) return t end

local help = require"help"  -- customized near bottom of program

local sqrt,      log,      abs,      min,      max,      exp,      Inf = 
 math.sqrt, math.log, math.abs, math.min, math.max, math.exp, math.huge
local floor,      ceil,      random =
 math.floor, math.ceil, math.random  
local concat, unpack = table.concat, table.unpack
local char, format = string.char, string.format
    
-- This is kept in while the program is under development

DEBUGGING=true  -- deliberately not made local
local logfile = io.open("/tmp/apl-lua.log","w")
logfile:setvbuf"no"

local meta_ENV=getmetatable(_ENV)
setmetatable(_ENV,{__newindex = function (ENV,name,value)
   if name:match"^%a%d?$" then logfile.write(where(2),
      "A global name like '",name,"' is asking for trouble.\n")
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
local arr_meta       -- Metatable for APL arrays 
local unit={}        -- Unit elements for functions that have them
local loading=true   -- set to false when the module returns

-- -----------------------------------------------------------------
-- Auxiliary functions. The ones declared forward are documented in
-- the Programmer's Guide.

local argcheck, arr, checksize, checktype, core_index, core_newindex,
   extent, indices, is, is_int, is_not, sanitize, shape, sort
local NaN = 0/0

local adjustindex = function (p,a)
-- calculate length and starting index
   local n,i,j=min(p,abs(a))
   if a>=0 then i,j=1,1 else i,j=p-n+1,abs(a)-n+1 end
   return n,i,j
end

arr_meta = getmetatable(rho(0,0))
local core_index, core_newindex = arr_meta.__index, arr_meta.__newindex

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

arr = function(_w)
--- Make _w into an APL array; respects existing fields, but sets apl_len 
   if not is"table"(_w) then _w={_w} end
   rawset(_w,'apl_len',#_w)
   return setmetatable(_w,arr_meta) 
end

checksize = function(A,B,op,name)
-- If op=1, check term-by-term compatibility
-- If op=2, check multiplicative compatibility
   name = debug.getinfo(2,'n').name or name or "<anonymous>"
   local ok, m, n = compat(A,B,op)
   if not ok then     
      error(("bad arguments to %s:\n %s≠%s"):format(name,m,n))   
   end
end   

-- LuaL-style type check
checktype = function(val,typ,pos,name)
   name = debug.getinfo(2,'n').name or name or "<anonymous>"
   if type(val)~=typ then 
      error(("bad argument "..pos.." to %s: expected %s, got %s"):format
            (name,typ,type(val)))   
   end
end

core_index, core_newindex = arr_meta.__index, arr_meta.__newindex

-- number of elements implied by shape
extent = function(shape)
   if is"number"(shape) then return shape 
   elseif is"table"(shape) then
      if #shape==0 then return 1
      elseif #shape==1 then return shape[1]
      else return shape[1]*shape[2]
      end
   else return 0
   end
end

filler = function(x)
-- neutral value of same type as first value in x
   if is"table"(x) then x=x[1] end
   if is"string"(x) then return '' else return 0 end
end

-- iterator for actual indices in a matrix slice
indices = function(n,i,j)
   local ni,nj = #i,#j
   local k,l,m0 = 0,nj,0
   return function()
      l=l+1 
      if l>nj then 
         l=1; k=k+1; if k>ni then return end
         m0=(i[k]-1)*n
      end
      return m0+j[l]
   end
end    

-- non-error type check
is = function(typ) return function(x) return type(x)==typ end end
is_int = core.is_int 
is_not = function(typ) return function(x) return type(x)~=typ end end

local like = function(w,v)
-- Object with same shape as w and value v (defaults to filler(w))
   local m,n = shape(w)
   v=v or filler(w)
   if not m then return v end
   return rho(v,m,n)
end

do -- sort package
local max_chunk_size = 12
local small_sort = core.sort
local merge = core.merge

local function merge_sort( array, low, high, precedes )
  if high - low < max_chunk_size then
    small_sort( array, low, high, precedes )
  else
    local middle = floor((low + high)/2)
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

sanitize = function(_w)
   if is"string"(_w) then return arr{_w:byte(1,-1)} end
   if is"boolean"(_w) then return _w and 1 or 0 end
   if is"nil"(_w) then return NaN end
   return _w
end

shape = function(x) if is"table"(x) then 
   if x.cols then return x.rows, x.cols else return #x end end
end

local unsanitize = function(_w,_a)
   if _a==2 then 
      if is"table"(_w) then return char(unpack(_w)) else return char(_w) end
   end
   if _a==1 then return _w~=0 end
   return _w
end

local first = function(fct,tbl) return pick(tbl,1,#tbl,fct) end
--- first(fct,tbl): The first index in tbl where fct returns true.

local invert = function(_w) 
--- invert(tbl): Switches keys and values in a table.  
-- Return value is just a table, not an APL array.
   local t={} 
   for k,v in ipairs(_w) do t[v]=k end 
   return t
end

local circfunc = {
   [0] = core.circ0; -- sqrt(1-_w^2)
   [1] = math.sin;
   [2] = math.cos;
   [3] = math.tan;
   [4] = core.circ4; -- sqrt(1+_w^2) 
   [5] = math.sinh;
   [6] = math.cosh;
   [7] = math.tanh;
   [-1] = math.asin;
   [-2] = math.acos;
   [-3] = math.atan;
   [-4] = core.circ_4; -- sqrt(_w^2-1)
   [-5] = core.asinh;
   [-6] = core.acosh;
   [-7] = core.atanh;
}

do -------------  LuaAPL functions A-Z  -------------------------------

local downrank = function(_w)
   local rows, cols = _w.rows, _w.cols
   local res=rho(0,rows)
   local i0=0
   for i=1,rows do
      res[i]=set(rho(0,cols),1,nil,get(_w,i0+1,i0+cols))
      i0=i0+cols
   end 
   return res
end

local stencil = function(w,s,f)
-- Constant array of shape `abs(s)` and value `v`. `s` defaults to
-- `Shape(w)`. If `f` is absent, `v` is `w` if scalar, `w[1]` if an 
-- array. If present, `v` is replaced by `f(v)`.
   local m, n, l, w1
   s = s or Shape(w)
   if is"table"(s) then m,n = s[1],s[2] else m=s end
   if not m then return end                           -- bad shape
   if is"table"(w) then l,w1 = #w, w[1] else l,w1 = 1,w end
   if f then w1=f(w1) end 
   if w1==nil and not (m==0 or n==0) then return end  -- bad data
   return rho(w1,abs(m),n and abs(n))
end

local uprank = function(_w) 
   local m,n = #_w,1
   for i,v in ipairs(_w) do if is"table"(v) then n=max(n,#v) end end
   local res=rho(filler(_w),m,n)
   local j=1
   for i,v in ipairs(_w) do          
     if is_not"table"(v) then res[j]=v 
        else set(res,j,nil,unpack(_w[i]))
     end 
     j=j+n 
   end
   return res
end

-- If op(f) works on a vector, spread(f,k) works on a matrix along axis k
local spread=function(f,k)
   return function(_a) return 
     function(_w) return Rerank(f(_a)(Rerank(_w,-2)),2) end
   end
end

-- It's annoying, I know, that the _left_ operand in infix notation 
-- maps to the _second_ operand in postfix notation, but there is
-- method in the madness.

-- Coding convention: arguments (_w,_a), return value res

-- ---------  Forward declaration of all basic APL functions  -------------
-- If you ever change anything here, these changes need to be reflected
-- in the program section "Put functions into module table" several 
-- hundred lines lower down. Also remember to cut-and-paste the changed 
-- block to the string `forward` below the declarations.

-- numeric monadic functions
-- these functions generalize term-by-term to any array
local Abs, Ceil, Exp, Fact, Floor, Ln, Not, Pi, Recip, Roll, Sign, Unm
-- numeric dyadic functions
-- these functions generalize term-by-term to arrays of the same shape or
--   when one operand is a singleton
local Add, And, Binom, Circ, Div, Log, Max, Min, Mod, Mul, Nand, Nor, 
   Or, Pow, Sub, TestEq, TestGE, TestGT, TestLE, TestLT, TestNE 
-- one-of-a-kind monadic functions
local Clone, Down, MatInv, Pass, Range, Ravel, Reverse, Reverse1, Shape, 
   Transpose, Up   
-- one-of-a kind dyadic functions
local Attach, Attach1, Compress, Compress1, Deal, Decode, Drop, Encode, 
   Expand, Expand1, Find, Format, Has, Get, MatDiv, Rerank, Reshape, 
   Rotate, Rotate1, Same, Take 
-- monadic operators 
local Both, Each, Outer, Reduce, Reduce1, Scan, Scan1
-- dyadic operators
local Inner
-- end of forward declarations

local forward = [[
-- numeric monadic functions
-- these functions generalize term-by-term to any array
local Abs, Ceil, Exp, Fact, Floor, Ln, Not, Pi, Recip, Roll, Sign, Unm
-- numeric dyadic functions
-- these functions generalize term-by-term to arrays of the same shape or
--   when one operand is a singleton
local Add, And, Binom, Circ, Div, Log, Max, Min, Mod, Mul, Nand, Nor, 
   Or, Pow, Sub, TestEq, TestGE, TestGT, TestLE, TestLT, TestNE 
-- one-of-a-kind monadic functions
local Clone, Down, MatInv, Pass, Range, Ravel, Reverse, Reverse1, Shape, 
   Transpose, Up   
-- one-of-a kind dyadic functions
local Attach, Attach1, Compress, Compress1, Deal, Decode, Drop, Encode, 
   Expand, Expand1, Find, Format, Has, Get, MatDiv, Rerank, Reshape, 
   Rotate, Rotate1, Same, Take 
-- monadic operators 
local Both, Each, Outer, Reduce, Reduce1, Scan, Scan1
-- dyadic operators
local Inner
-- end of forward declarations
]]

-- Exceptional functions, i.e. not fitting into the classification

local Set

-- Functions that have passed quality inspection for Lua⋆APL 0.3 --

Abs = abs 
Add = function(_w,_a) return _a+_w end
And = function(_w,_a) return _w~=0 and _a~=0 and 1 or 0 end

Binom = function(_w,_a) 
   argcheck(is_int(_a),1,"integer expected")
   if _a<0 then return 0 end
   local res=1
   for k=_a,1,-1 do res=res*_w/k; _w=_w-1 end
   return res
   end;

Both = function(f) return 
-- Applies dyadic f term-by-term; second argument may be a scalar
   function(_w,_a) return both(f,_w,_a,false,true) end 
end

Ceil = ceil 
Circ = function(_w,_a) return circfunc[_a](_w) end

Clone = function(_w) 
   if is_not"table"(_w) then return _w end
   local res=rho(0,shape(_w))
   set(res,1,nil,unpack(_w)) 
   return res
end

Deal = function(_w,_a)
   local n=_w
   argcheck(_a<=n,'pair',"can't deal ".._a.." from "..n)
   local p=iota(n)
   for k=0,n-1 do 
      local j=k+random(n-k) 
      p[k+1],p[j],_w = p[j],p[k+1],_w-1 
   end
   return Take(p,_a)
end

Div = function(_w,_a) return _a/_w end

-- Applies monadic function to every element
Each = function(f) return function(_w) return each(f,_w) end end

Exp = exp 

Fact = function(_w) 
   argcheck(is_int(_w),1,"integer expected")
   if _w<0 then if _w%2==0 then return -Inf else return Inf end end
   local f=1; for k=2,_w do f=f*k end; return f 
end

Find = function(_w,_a)
   if is_not"table"(_a) then _a={_a} end
   local past=#_a+1
   if is_not"table"(_w) then
      return first(function(x) return x==_w end,_a) or past
   end
   local lookup=invert(_a)
   local res=Clone(_w)
   for k=1,#res do res[k]=lookup[res[k]] or past end
   return res
end

Floor = floor 

Get = function(_w,_a)
   checktype(_w,'table',1)
   if is"function"(_a) then
      local res={}          -- don't know the length in advance
      for k in _a do res[#res+1]=_w[k] end
      res.apl_len=#res      
      setmetatable(res,arr_meta)
      return res
   end
   if is_not"table"(_a) then return core_index(_w,_a) end
   local n=#_a
   local rows, cols = shape(_w) 
   if not rows then 
      local res=iota(n)
      for k=1,n do res[k]=_w[_a[k]] end
      res.rows=_a.rows
      res.cols=_a.cols
      return res
   end
   -- indexing a matrix   
   argcheck(n<=2,2,"expected two indices, got "..n)
   local i,j,submat = _a[1], _a[2], true
   if is"number"(i) then i={i}; submat=false end
   if is"number"(j) then j={j}; submat=false end
   if i==nil then i=iota(rows) end
   if j==nil then j=iota(cols) end
   local l,m,n = 0,#i,#j
   local res
   if submat then res=rho(0,m,n) else res=rho(0,m*n) end   
   for k in indices(cols,i,j) do l=l+1; res[l]=_w[k] end
   return res
end

Has = function(_w,_a)
   local t=invert(_w)
   if is_not"table"(_a) then return t[_a] and 1 or 0 end
   local res=like(_a)
   for k,v in ipairs(_a) do res[k]=t[v] and 1 or 0 end
   return res
end

Ln =  log 
Log = log 
Max = max 
Min = min 
Mod = function(_w,_a) return _w%_a end
Mul = function(_w,_a) return _a*_w end 
NaN = 0/0; 
Nand = function(_w,_a) return _w~=0 and _a~=0 and 0 or 1 end
Unm = function(_w) return -_w end
Nor = function(_w,_a) return (_w~=0 or _a~=0) and 0 or 1 end
Not = function(_w) if _w==0 then return 1 else return 0 end end
Or = function(_w,_a) return (_w~=0 or _a~=0) and 1 or 0 end

Outer = function(f) 
   checktype(f,'function','f')
   return function(_w,_a)
      local n,m =#_w,#_a
      local res=rho(0,m,n)
      local k=0
      for i=1,m do for j=1,n do
         k=k+1; res[k] = f(_w[j],_a[i])
      end end
      return res
   end
end

Pass = function() return end
Pi = function(_w) return math.pi*_w end
Pow = function(_w,_a) return _a^_w end
Range = iota

Ravel = function(_w) 
   if is_not"table"(_w) then return rho(_w,1) end
   _w=Clone(_w); _w.rows=nil; _w.cols=nil
   return _w
end

Recip = function(_w) return 1/_w end

Rerank = function(_w,_a)
   checktype(_a,'number','_a')
   if is_not"table"(_w) then return {_w} end
   if _a>0 then argcheck(not _w.rows,'_w',"already a matrix") end
   if _a<0 then argcheck(_w.rows,'_w',"not a matrix") end
   if _a==1 then return uprank(_w)
   elseif _a==-1 then return downrank(_w)
   elseif _a==2 then return Transpose(uprank(_w))
   elseif _a==-2 then return downrank(Transpose(_w))
   else argcheck(false,'_a',"valid values are ±1, ±2")
   end
end

Reshape = function (_w,_a)
   local res=stencil(_w,_a)
   argcheck(res, 1, "can't reshape nil")
   local m = shape(res)
   local n = shape(_w)
   if not m or not n or #res<2 or #_w<2 then return res end  
   return set(res,1,#res,unpack(_w))
end

Reverse = function(_w,axis)
-- The Lua programmer has access to `axis`
   axis = axis or 2
   argcheck(axis==1 or axis==2,'⍺','Valid values are 1 and 2')  
   local m,n = shape(_w)
   if not m or n==1 then return Clone(_w) end
   if not n then res=rho(0,m); set(res,1,nil,get(_w,m,1)); return res end
   return Rerank(Reverse(Rerank(_w,-axis)),axis)
   end

Reverse1 = function(_w) return Reverse(_w,1) end

Roll = random 

Rotate = function(_w,_a)
   local m,n = shape(_w)
   if not m then return _w end   -- not an array   
   if not n then                 -- vector
      res=rho(0,m)     
      checktype(_a,'number','⍺')
      _a=_a%m
      if m<2 or _a==0 then return res end
      if _a>0 then set(res,1,m-_a,get(_w,_a+1,m)) end
      if _a<m then set(res,m-_a+1,m,get(_w,1,_a)) end
      return res
   end
   local k = shape(_a)
   if k==nil then _a = {0,_a}; k=2 end
   argcheck(k==2,'⍺',"number or two-element array required")   
   for k=1,2 do if _a[k]~=0 then
      _w=Rerank(Rotate(Rerank(_w,-k),_a[k]),k) 
   end end
   return _w
end

Rotate1 = function(_w,_a)
   checktype(_a,'number','⍺')
   return Rotate(_w,{_a,0})   
end

Same = function(_w,_a) return sanitize(_a==_w) end

local scan = function(_a)
   return function(_w)
      if #_w==0 then 
         argcheck(unit[_a],'f',"function with no left-unit",'scan')
         return unit[_a] 
      end
      local res=like(_w)
      res[1]=_w[1]
      for k=2,#_w do res[k]=_a(_w[k],res[k-1]) end
      return res
   end
end
Scan = spread(scan,2)
Scan1 = spread(scan,1)

Set = function(_w,_a,v)
   checktype(_w,'table',1)
   if is"function"(_a) then
      local j=0
      for k in _a do j=j+1; _w[k]=v[j] end
      return v
   end
   if is"string"(_a) then 
      error"Use rawset if you really can't do it with rho"
   end
   if is_not"table"(_a) then error(
      "Index '"..tostring(_a).."' is out of range, table length is "..#_w)
   end
   local n=#_a
   local rows, cols = shape(_w) 
   if not rows then 
      for k=1,n do _w[_a[k]]=v[k] end
      return v
   end
   -- indexing a matrix   
   argcheck(n<=2,2,"expected two indices, got "..n)
   local i,j,submat = _a[1], _a[2], true
   if is"number"(i) then i={i}; submat=false end
   if is"number"(j) then j={j}; submat=false end
   if i==nil then i=iota(rows) end
   if j==nil then j=iota(cols) end
   local l,m,n = 0,#i,#j 
   for k in indices(cols,i,j) do l=l+1; _w[k]=v[l] end
   return v
end

Shape = function(_w) 
   if is"string"(_w) then return #_w else return arr{shape(_w)} end
end

Sign = function(_w) return _w<0 and -1 or _w>0 and 1 or 0 end 
Sub = function(_w,_a) return _a-_w end

Take = function(_w,_a)
   local res = stencil(_w,_a,filler)
   argcheck(res, 1, "can't take nil") 
   if is_not"table"(_w) then _w=rho(_w,1,1) end
   local m,n = shape(res)
   local p,q = shape(_w)
   local a,b = _a
   if is"table"(_a) then a,b = unpack(_a) end
   argcheck(q or not b,1,"can't take a matrix from a vector")
   local i,j,k,l
   m,i,k = adjustindex(p,a)
   if (not b) then res[iota(m,k)] = _w[iota(m,i)]; return res end
   n,j,l = adjustindex(q,b)
   res[{iota(m,k),iota(n,l)}] = _w[{iota(m,i),iota(n,j)}]; return res
end

TestEq = function(_w,_a) return _a==_w and 1 or 0 end; 
TestGE = function(_w,_a) return _a>=_w and 1 or 0 end
TestGT = function(_w,_a) return _a>_w and 1 or 0 end
TestLE = function(_w,_a) return _a<=_w and 1 or 0 end
TestLT = function(_w,_a) return _a<_w and 1 or 0 end
TestNE = function(_w,_a) return _a~=_w and 1 or 0 end

Transpose = function(_w)
   local rows,cols = shape(_w)
   if not cols then return Clone(_w) end
   local res=rho(0,cols,rows)
   transpose(_w,rows,cols,res)
   return res
end   

-- Works for vectors but not matrices

local reduce = function(_a)
   return function(_w)
      if #_w==0 then 
         argcheck(unit[_a],'f',"function with no left-unit",'scan')
         return unit[_a] 
      end
      local res=_w[1]
      for k=2,#_w do res=_a(_w[k],res) end
      return res
   end
end
Reduce = reduce
Reduce1 = reduce  

-- Functions that have not passed quality inspection for Lua⋆APL 0.3 --

Attach = function(_w,_a)
   local rho_a,rho_w = Shape(_a),Shape(_w)
   if rho_a and #rho_a>1 or rho_w and #rho_w>1 then 
      return Transpose(Attach1(Transpose(_w),Transpose(_a)))
   end
   _a=Ravel(_a)
   if #rho_w<1 then _a[#_a+1]=_w else set(_a,#_a+1,nil,get(_w,1,#_w)) end
   return _a
end

Attach1 = function(_w,_a)
   local wr,wc, ar,ac, wl,al = 1,1,1,1,1,1
   if is"table"(_w) then wl=#_w; wc=_w.cols; wr=_w.rows or 1 end 
   if is"table"(_a) then al=#_a; ac=_a.cols; ar=_a.rows or 1 end       
   argcheck((wc or wl)==(ac or al),2,"rows must be of equal length")
   local res=Range(al+wl)
   if is"table"(_a) then set(res,1,nil,get(_a,1,al)) 
      else res[1]=_a 
   end
   if is"table"(_w) then set(res,al+1,nil,get(_w,1,wl))
      else res[al+1]=_w
   end
   res.rows, res.cols = al+wl, wc or wl;
   return res
end   

Compress = function(_w,_a)
   local res=arr{}
   if is_int(_a) then if _a>0 then
      checktype(_w,'table','_w','Compress')
      for k,v in ipairs(_w) do set(res,#res+1,#res+_a,v) end
      return res
   end end
   checksize(_a,_w,1,'Compress') 
   for k,v in ipairs(_w) do if _a[k]>0 then set(res,#res+1,#res+_a[k],v) end 
   end
   return res
end
Compress1 = function(_w,_a) return Transpose(Compress(Transpose(_w),_a)) end

Decode = function(_w,_a)
   local res,d=arr{}   
   checktype(_w,'number','_w')
   if is"table"(_a) then 
      for k=#_a,1,-1 do d=_w%_a[k]; res[k]=d; _w=(_w-d)/_a[k] end
   else 
      repeat d=_w%_a; res[#res+1]=d; _w=(_w-d)/_a until _w==0
      move(res,1,#res,#res,1)
   end
   return res
end

Drop = function(_w,_a) 
   local n,res = #_w, arr{}
   if abs(_a)>=n then return res end
   if _a<0 then set(res,1,n+_a,get(_w,1,n+_a))
   else set(res,1,n-_a,get(_w,_a+1,n))
   end
   return res
end

--[[
      if _a then checksize(_a,_w,1,'Each') else _a={} end
      local res=Clone(_w)
      for k,v in ipairs(res) do res[k]=f(v,_a[k]) end
      return res
   end
end
--]]

Encode = function(_w,_a)
   local res=0
   if is"table"(_a) then for k=1,#_a do res=_a[k]*res+_w[k] end   
   else for k=1,#_w do res=_a*res+_w[k] end
   end
   return res
   end

Expand = function(_w,_a)
   local res=arr{}
   for k,v in ipairs(_w) do 
      res[#res+1]=v
      if _a[k]>0 then set(res,#res+1,#res+_a[k],0) end
   end
   return res
end
Expand1 = function(_w,_a) return Transpose(Expand(Transpose(_w),_a)) end
   
-- Format is defined after the A-Z group

Up = function(_w) 
   checktype(_w,'table','_w','Up')
   local x=Range(#_w)
   return sort(x,function(a,b) return _w[a]<_w[b] end)
   end;

Down = function(_w) 
   checktype(_w,'table','_w','Down')
   local x=Range(#_w)
   return sort(x,function(a,b) return _w[a]>_w[b] end)
   end;

Inner = function(f1,f2) 
   if f1==Pass then return Outer(f2) end
   return function(_w,_a) 
      checksize(_a,_w,1,'Inner')
      argcheck(not _a.rows,'_a',"Can't handle matrices yet")      
      argcheck(not _w.rows,'_w',"Can't handle matrices yet")  
      local n = #_w
      local res=f2(_w[n],_a[n])
      for k=n-1,1,-1 do 
         res=f1(res,f2(_w[k],_a[k]))
      end
      return res
   end
end

do -- Format

local function aplformat(f)
--- convert APL format to string format
   if is"string"(f) then return(f) end
   checktype(f,'number',1)
   return '%'..("%.1f"):format(abs(f))..(f<0 and 'e' or 'f')
end

local form = function(item,fmt)
-- invert the order (APL's format is _a, not _w), convert minus to 
--   high    if is"string"(item) then return item end
   item=format(fmt,item)
   if not fmt:match("%%s") then item=item:gsub('-','¯') end
   return item
end

local function rawformat(_w)
   if _w==nil then return "_" end   
   if is"string"(_w) then return "'".._w.."'" end
   if is"number"(_w) then if not(_w==_w) then return "NaN"
      else return tostring(_w) 
   end end
   if is"table"(_w) then 
      local cols = _w.cols
      local data = {}
      local n = #_w
      local L,R
      if getmetatable(_w) then 
         if cols then L,R = '[',']' else L,R = '(',')' end
      else L,R = '{','}'
      end
      for k=1,n do 
         data[#data+1]=rawformat(_w[k])
         if k<n then if cols and k%cols==0 then data[#data+1]=';'
         else data[#data+1]=','
         end end 
      end
      return L..concat(data)..R
   else return type(v) end
end

function Format(_w,_a, level)
   _a = _a or apl._format or "%.7g"
   level=level or 1
   if _a=="raw" or level>1 then return rawformat(_w) end   
   if is"number"(_a) then _a=aplformat(_a) end
    if _w==nil then return "_" end   
   if is"string"(_w) then return _w end
   if is"number"(_w) then if not(_w==_w) then return "NaN"
      else return form(_w,_a) 
   end end
   if is"table"(_w) then 
      local cols = _w.cols
      local data = {}
      local n = #_w
      local l = 0
      for k=1,n do 
         local item=Format(_w[k],_a,level+1)
         l=max(l,#item)
         data[#data+1]=item 
         if k<n then if cols and k%cols==0 then data[#data+1]='\n'
         else data[#data+1]=' '
         end end 
      end
      if cols then for k=1,#data,2 do 
         data[k]=(' '):rep(l-#data[k])..data[k] 
      end end      
      return concat(data)
   else return type(v) end   
end      

end -- Format

-- Put functions into module table.
-- Local values (whose names are only visible during compilation) are
--   assigned to permanent names.

local num1, num2, gen1, gen2, op1, op2

-- If you ever make changes to the forward declaration near the top of 
-- this file, I have provided a tool to automate regeneration of the 
-- next group of statements.
--
-- Cut-and-paste the string `forward` given above to the program 
-- "funclists.lua", replacing the previous version, run the program, 
-- and cut-and-paste its output below, replacing previous version. 
-- If you like, ask your text editor to reformat the paragraphs.

num1={Abs=Abs, Ceil=Ceil, Exp=Exp, Fact=Fact, Floor=Floor, Ln=Ln,
  Unm=Unm, Not=Not, Pi=Pi, Recip=Recip, Roll=Roll, Sign=Sign}

num2={Add=Add, And=And, Binom=Binom, Circ=Circ, Div=Div, Log=Log,
  Max=Max, Min=Min, Mod=Mod, Mul=Mul, Nand=Nand, Nor=Nor, Or=Or, Pow=Pow,
  Sub=Sub, TestEq=TestEq, TestGE=TestGE, TestGT=TestGT, TestLE=TestLE,
  TestLT=TestLT, TestNE=TestNE}

gen1={Clone=Clone, Down=Down, MatInv=MatInv, Pass=Pass, Range=Range,
  Ravel=Ravel, Reverse=Reverse, Reverse1=Reverse1, Shape=Shape,
  Transpose=Transpose, Up=Up}

gen2={Attach=Attach, Attach1=Attach1, Compress=Compress,
  Compress1=Compress1, Deal=Deal, Decode=Decode, Drop=Drop,
  Encode=Encode, Expand=Expand, Expand1=Expand1, Find=Find,
  Format=Format, Has=Has, Get=Get, MatDiv=MatDiv, Rerank=Rerank,
  Reshape=Reshape, Rotate=Rotate, Rotate1=Rotate1, Same=Same, Set=Set, 
  Take=Take }

op1={Both=Both, Each=Each, Outer=Outer, Reduce=Reduce, Reduce1=Reduce1, 
  Scan=Scan, Scan1=Scan1}

op2={Inner=Inner}

local groups={gen1=gen1, gen2=gen2, op1=op1, op2=op2}
apl._F = { num1=num1, num2=num2, gen1=gen1, gen2=gen2, op1=op1, op2=op2} 

-- Replace numeric scalar functions by their expansions

for k,v in pairs(num1) do
   apl[k] = function(_w,_a) return each(v,_w) end
end

for k,v in pairs(num2) do 
   apl[k] = function(_w,_a) return both(v,_w,_a,1,1) end
end

-- Copy over other functions

for _,group in pairs(groups) do
   for name,value in pairs(group) do apl[name] = value end
end

-- Populate array metatable

local function reverse(f) return function(_w,_a) return f(_a,_w) end end
arr_meta.__tostring = Format 
arr_meta.__index = Get
arr_meta.__newindex = Set

-- Exceptions

apl.Get = Get
apl.Set = Set

for k in forward:gmatch"[A-Z][A-Za-z]+1?" do
   if not apl[k] then 
      logfile:write("Declared forward but not defined: ",k,"\n")
end end

end -------------  LuaAPL functions A-Z  -------------------------------
   
--- Customize the help system
-- Help is defined in three ways:
-- 1. Immediately after all this, there is a list of about 70 calls 
--    to 'help' giving the function and its helptext as arguments.
-- 2. When registering a function, 'help'is an optional argument.
-- 3. Very short functions not otherwise documented have their own 
--    source code as help. This feature relies on `apl-lib.lua` not 
--    having been modified after it was loaded.

help("Arrays", [[
An APL array is a Lua table indexed from 1 upwards whose metatable has
been set for arithmetic and to-string conversion. If it represents a
matrix rather than a vector, it has fields `rows`, `columns`.

A small number of APL functions, such as `⌷` (Squish), can work with 
arrays in which the entries themselves are arrays.]])
help("Programming", [[
Big topic. Read the manual.]])   
help("Memos", [[
You can say `help(topic,"help text")` to define your own memo on the
given topic. A topic can be of any type, but it will only be listed
by `help"all"` if it is a string."]])
help("Guessing",[[
(APL mode only) Chunks you type in are guessed to be either APL code 
or Lua code, according to the following criteria applied to the first 
line in the given order.
1. If it starts with `return` or '=': Lua.
2. If it does not start with an alphabetic character or `(`: APL.
3. If it contains the string `apl.` or a double-quote: Lua.
4. If it contains a statement separator `⋄` or comment symbol `⍝`: APL.
5. If the number of non-ASCII bytes is more than the number of alphabetic 
   bytes: APL.
]])
help("Symbols",[[
The best way to learn APL symbols is to start from `help(apl)` and ask 
for help on individual functions. Otherwise look in `apl-compiler.lua` 
for "Definition of the Lua⋆APL function-to-symbol mapping interface".
]])
help("Importing",[[
`apl()` imports the bare minimum of what is convenient.
`apl:import"*"` imports the whole module table. It swamps rather than 
pollutes the global namespace, but in Lua mode, that's what you want.
]])

-- Redefine help. 
local basichelp = help
local helpnil=0
local helpNaN = [[
NaN: Not-a-Number (whose type is 'number'), result of invalid arithmetic,
   e.g. dividing 0 by 0, square-rooting a negative number, converting nil
   to a number etc. A NaN is not equal to anything, not even to itself.]]
help("customize",[[
After `help(arg,msg)`, where `arg` is any string except `all`, and `msg`
is a string, the message you get when typing `help(arg)` will be `msg`.
If `msg = false`, any existing help for `arg` is deleted.]])
help = function(...)
---    help(topic)
-- `topic` is a function: Prints predefined help, if any; otherwise
--    its docstring, if any; otherwise its listing, if short enough.
-- `topic` is a table: Prints contents. For example, `help(apl)` 
--    lists what is in `apl`.
-- `topic` is string: Prints predefined help on the topic, if any. 
-- `topic` is "all": Prints available topics. For example, 
--    `help"customize" tells how to add your own help topics.
   local s, mod = ...
   if not s then 
      helpnil=helpnil+1
      if helpnil==1 and select('#',...)==0 then 
         print "Cut-and-paste this: apl(); help'all'; help(apl); help(help)"
      elseif select('#',...)>0 then
         print "That's nil. Import it first, or use the table name." 
      elseif helpnil>5 then 
         print"`help'start'` retypes startup help."
      else return basichelp'start'
      end
      return
   end
   if not(s==s) then print(helpNaN) return end
   return basichelp(...)
end

do local _ENV=apl ----------------------------------------------------------

help('Circ', [[
Definitions of circle functions (assuming that arguments are in range)
  (¯4 0 4 ○ ⍵) = ((⍵^2-1)⋆0.5,(1-⍵^2)⋆0.5,(1+⍵^2))
   (1 2 3 ○ ⍵) = (sin ⍵, cos ⍵, tan ⍵)
   (5 6 7 ○ ⍵) = (sinh ⍵, cosh ⍵, tanh ⍵)
  (⍺ ○ (-⍺) ⍵) = ⍵ ]])
help(Abs, "Abs: ∣⍵ → math.abs(⍵)")
help(Add, "Add: ⍺+⍵")
help(And, "And: ⍺∧⍵ → 1 only if ⍺ and ⍵ both nonzero, else 0")
help(Attach1,[[
Attach1: ⍺⍪⍵ → rows of ⍺ followed by rows of ⍵
   Vectors are treated as one-row matrices.]])
help(Binom,"Binom: ⍺?⍵ → C(⍵,⍺), the number of ways to choose ⍺ of ⍵ items")
help(Ceil, "Ceil: ⌈⍵ → math.ceil(⍵)")
help(Circ, "Circ: ⍺○⍵ → circle function, see `help'Circ'` for more.")
help(Clone,'Clone: +⍵ returns a copy of the APL-visible part of ⍵')
help(Deal,"Deal: ⍺?⍵ → ⍺ distinct numbers randomly selected from ⍳⍵")
help(Decode,"Decode: ⍵⊤⍺ → Decompose ⍺ into base ⍵ digits")
help(Div,"Div: ⍺÷⍵")
help(Down,"Down: ⍒⍵ → the permutation that grades ⍵ downwards")
help(Drop,"Drop: ⍺↓⍵ → ⍵ without its first ⍺ or last -⍺ elements")
help(Has,"Has: ⍺∊⍵ → does ⍺ occur in ⍵?")
help(Encode,"Encode: ⍵⊥⍺ → ⍺ considered as base ⍵ digits of result")
help(Exp,"Exp: ⍟⍵ → math.exp(⍵)")
help(Fact,"Fact: !n → ×/⍳n")
help(Find,"Find: ⍺⍳⍵ → position of first occurrence of ⍵ in ⍺; not found is #⍺+1")
help(Floor, "Floor: ⌊⍵ → math.floor(⍵)")
help(Get,"Get: ⍵[⍺], see `help'Indexing'")
help(Max,"Max: ⍺⌈⍵ → math.max(⍵,⍺)")
help(Min,"Min: ⍺⌊⍵ → math.min(⍵,⍺)")
help(Mod,"Mod: ⍺|⍵")
help(Mul,"Mul: ⍺×⍵")
help(Set,"Set: ⍵[⍺]←v, see `help'Indexing'")
help(Nor,"Nor: ⍺⍱⍵ → 1 only if both ⍺ and ⍵ are 0, else 0")
help(Pi,"Pi: ○⍵ → math.pi times ⍵")
help(Pow,"Pow: ⍺^⍵")
help(Range,"Range: ⍳⍵ → {1,2,...,⍵}") 
help(Ravel,"Ravel: ,⍵ → vector containing elements of ⍵")
help(Reduce,"Reduce: ⍺/⍵ → copies elements or columns of ⍵ as counted by ⍺")
help(Reduce1,"Reduce: ⍺⌿⍵ → copies elements or rows of ⍵ as counted by ⍺")
help(Rerank,[[
Rerank: ⍺⎕⍵ → array of one rank higher or lower
   1⎕⍵ → matrix whose rows are elements of ⍵
  ¯1⎕⍵ → vector whose elements are rows of ⍵
   2⎕⍵ → matrix whose columns are elements of ⍵
  ¯2⎕⍵ → vector whose elements are columns of ⍵
If ⍺>0, each ⍵[i] is treated as a vector and padded to the maximum length
   with zeros or empty strings. ]])
help(Reshape,"Reshape: ⍺⍴⍵ → Make an array of shape ⍺ by using ⍵ cyclically")
help(Reverse,"Reverse: ⌽⍵ → elements or columns of ⍵ in reverse order")
help(Reverse1,"Reverse1: ⌽⍵ → elements or rows of ⍵ in reverse order")
help(Roll,"Roll: ?⍵ → math.random(⍵)")
help(Rotate,"Rotate: ⍺⌽⍵ → columns of ⍵ rotated left by ⍺ (or right by -⍺")
help(Rotate1,
   "Rot1: ⍺⊖⍵ → rows of ⍵ rotated up by ⍺ (or down by -⍺")
help(Same,"Same: ⍺≡⍵ means Lua equality but APL 0-1 result")
help(Shape,[[
Shape: ⍴⍵ → {} if a number, {#⍵} if a vector, {rows,cols} if a matrix.
       #⍵ if a string.]])
help(Sign,"Sign: ×⍵ is ¯1,0,1 according to whether ⍵ is <0, =0, >0")
help(Sub,"Sub: ⍺-⍵")
help(Take,"Take: ⍺↑⍵ → The first ⍺ or last -⍺ elements of ⍵")   
help(TestEq,"TestGE: ⍺=⍵")
help(TestGE,"TestGE: ⍺≥⍵")
help(TestGT,"TestGE: ⍺>⍵")
help(TestLE,"TestLE: ⍺≤⍵")
help(TestLT,"TestLT: ⍺<⍵")
help(TestNE,"TestGE: ⍺≠⍵")
help(Transpose,'Transpose: ⍉⍵ → matrix transpose of ⍵')
help(Up,"Up: ⍋⍵ → the permutation that grades ⍵ upwards")

end ---------------- _ENV apl --------------------------------------------

help("start",[[
    apl:import"help"  -- imports `help` into _ENV 
    help(apl)         -- displays module table
    help"all"         -- lists topics you can read by `help"topic"`
    help(help)        -- says more about `help`
    apl:import'Func'  -- imports `Func` into _ENV
    help(Func)        -- displays help on `Func`  (no quotes)
    apl:import"*"     -- imports all names not starting with `_` into _ENV
]])

-- Insert last-minute items into module table

setmetatable(apl,{
__call = 
   function(apl,env)
      env = env or _ENV
      env.help = apl.help
   end})

apl.NaN = NaN
apl.help = help
apl.import = function(apl,names,env)
--- apl:import(names)  e.g. apl:import"Rotate,Reverse,Range,Shape"
--    imports selected names from `apl` into global namespace
--  apl:import"*"  imports all names not starting with underscore
--  import(source,names,target) in general does this from table `source`
--    to table `target`
   if not is"table"(apl) then
      print"Did you say `apl.import` instead of `apl:import`?"
      return
   end
   if not is"string"(names) then
       print"Did you forget the quotes on `apl:import'Func'`?"
       return
   end
   env = env or _ENV     
   if names=='*' then for k in pairs(apl) do 
      if not k:match"^_" then env[k]=apl[k] 
   end end 
   elseif is"string"(names) then for k in names:gmatch"%a%w+" do
      env[k]=apl[k]
   end end
end

apl.util = {argcheck=argcheck, checktype=checktype, logfile=logfile,
  is=is, is_not=is_not}

-- welcome message

logfile:write [[  
   BUGS: 
1. Only halfway into implementing new version.
2. Not implemented: ⌹.
3. Not enough runtime checks on input values.
4. Too few functions have been adequately tested.

]]   

print [[
Lua⋆APL 0.2 © Dirk Laurie 2013.  
Bug reports are welcome. You'll find me on Lua-L.
Try `apl.help()` if you don't want to read even the README.
--]]

-- clean up

setmetatable(_ENV,meta_ENV)
loading=false

return apl


