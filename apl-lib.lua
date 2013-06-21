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
-- CamelCase: APL function
-- lowercase: utilities
-- _CAPS:     needed by system, or gives information

-- Dependencies: custom APL core, help.lua, standard libraries

local core = require"apl_core"
local  get,      move,      where,      transpose,      pick
= core.get, core.move, core.where, core.transpose, core.pick
local  each,      both,      compat,      iota,      rho
= core.each, core.both, core.compat, core.iota, core.rho
local set = function(t,...) 
   core.set(t,...) return t 
end

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
logfile:write(where(2),"Assigning _ENV.",name,"\n")
--   if name:match"^%a%d?$" then logfile.write(where(2),
--      "A global name like '",name,"' is asking for trouble.\n")
--   end
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
   extent, filler, first, indices, invert, is, is_int, is_not, reverse,
   sanitize, shape, singleton, sort, start, sum
local NaN = 0/0

local adjustindex = function (p,a)
-- calculate length and starting index
   local n,i,j=min(p,abs(a))
   if a>=0 then i,j=1,1 else i,j=p-n+1,abs(a)-n+1 end
   return n,i,j
end

-- All argument-check routines prefer the actual called name;
-- the optional last parameter is a fallback when no such name
-- is available (e.g. a tail call).
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

arr_meta = getmetatable(rho(0,0))

checksize = function(A,B,op,name)
-- If op=1, check term-by-term compatibility
-- If op=2, check multiplicative compatibility
   name = debug.getinfo(2,'n').name or name or "<anonymous>"
   local ok, m, n
   if op==2 then 
      local m1,n1 = shape(A)
      m = shape(B)
      n = n1 or m1
      ok = m==n
   else ok,m,n = compat(A,B,op)
   end   
   if not ok then     
      error(("size mismatch in arguments to %s: %s≠%s"):format(name,m,n))   
   end
end   

-- LuaL-style type check, return value if no error
checktype = function(val,typ,pos,name)
   name = debug.getinfo(2,'n').name or name or "<anonymous>"
   if type(val)~=typ then 
      error(("bad argument "..pos.." to %s: expected %s, got %s"):format
            (name,typ,type(val)))   
   end
   return val
end

local core_index, core_newindex = arr_meta.__index, arr_meta.__newindex

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

first = function(fct,tbl) return pick(tbl,1,#tbl,fct) end
--- first(fct,tbl): The first index in tbl where fct returns true.

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

invert = function(_w) 
--- invert(tbl): Switches keys and values in a table.  
-- Return value is just a table, not an APL array.
   local t={} 
   for k,v in ipairs(_w) do t[v]=k end 
   return t
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

sanitize = function(_w)
   if is"string"(_w) then return arr{_w:byte(1,-1)} end
   if is"boolean"(_w) then return _w and 1 or 0 end
   if is"nil"(_w) then return NaN end
   return _w
end

local function tableaddr(x)
   local mt=getmetatable(x)
   setmetatable(x,nil)
   local addr=tostring(x)
   setmetatable(x,mt)
   return addr
end

shape = function(x) 
   if is"table"(x) then
      local r,c = rawget(x,'rows'), rawget(x,'cols')
      if c then return r, c else return #x end
   end
end

singleton = function(x)
   if is_not"table"(x) then return x end
   if #x==1 then return x[1] end
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

start = function(x)
   if is"table"(x) then return x[1],x[2]
   else return x
   end
end

sum = function(x)
   if is_not"table"(x) then return x end
   local s=0
   for _,v in ipairs(x) do s=s+v end
   return s
end   

local unsanitize = function(_w,_a)
   if _a==2 then 
      if is"table"(_w) then return char(unpack(_w)) else return char(_w) end
   end
   if _a==1 then return _w~=0 end
   return _w
end

---

do -- start of scope for APL locals

-- ---------  Forward declaration of all basic APL functions  -------------
-- If you ever add, change or delete a function name here, it must also be
-- made in the program section "Put functions into module table" near line 
-- 1000 of this file, according to the instruction given there.

-- DON'T CHANGE ANY OF THE COMMENTS IN THIS BLOCK OF STATEMENTS.
-- scalar1: monadic primitive scalar functions
local Abs, Ceil, Exp, Fact, Floor, Ln, Not, Pi, Range, Recip, Roll, Sign, Unm
-- scalar2: dyadic primitive scalar functions
local Add, And, Binom, Circ, Deal, Div, Log, Max, Min, Mod, Mul, Nand, 
   Nor, Or, Pow, Sub, TestEq, TestGE, TestGT, TestLE, TestLT, TestNE 
-- gen1: one-of-a-kind monadic functions
local Copy, Disclose, Down, Enclose, MatInv, Pass, Ravel, Reverse, Shape, 
   SVD, Transpose, Up   
-- gen2: one-of-a kind dyadic and triadic functions
local Attach, Compress, Decode, Drop, Encode, Expand, Find, Format, 
   Has, Get, MatDiv, Rerank, Reshape, Rotate, Same, Set, Take 
-- op1: monadic operators 
local Each, Outer, Reduce, Scan
-- op2: dyadic operators
local Inner
-- end of forward declarations

-- auxiliary functions that depend on forward-declared APL functions

local along=function(f,k,func)
--- If f works on a vector, along(f,k) works on a matrix along axis k
   k=k or 2
   return function(_w,_a)
      if not checktype(_w,'table',1,func).cols then return f(_w,_a)
      else return Rerank(f(Rerank(_w,-k),_a),k)
      end    
   end
end

local inner = function(f,_w,_a)
   local m,p = shape(_a)
   local q,n = shape(_w)
   if not (p or n) then return f(_w,_a) end
   if p then _a=Rerank(_a,-1) end
   if n then _w=Rerank(_w,-2) end
   if p then 
      if n then return Outer(f)(_w,_a)
      else 
         local res=rho(0,m)
         for k=1,m do res[k]=f(_w,_a[k]) end
         return res
      end
   else 
      local res=rho(0,n)
      for k=1,n do res[k]=f(_w[k],_a) end
      return res
   end
end

local stencil = function(w,s,f)
--- Constant array of shape `abs(s)` and value `v`. `s` defaults to
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

-------------  LuaAPL functions A-Z  -------------------------------

-- Coding convention: arguments (_w,_a), return value res
-- It's annoying, I know, that the _left_ operand in infix notation 
-- maps to the _second_ operand in postfix notation, but there is
-- method in the madness.

Abs = abs 
Add = function(_w,_a) return _a+_w end
And = function(_w,_a) return _w~=0 and _a~=0 and 1 or 0 end

Attach = function(_w,_a,axis)
   local res   
   if is_not"table"(res) then res=arr(_a) else res=Copy(_a) end
   if is_not"table"(_w) then _w={_w} end
   if #_w==0 then return res end
   if not axis then
      local l,m=#res,#_w
      rawset(res,'cols',nil); rawset(res,'rows',nil)
      rawset(res,'apl_len',l+m)
      return set(res,l+1,nil,get(_w,1,m))
   end
   if res.cols then res=Rerank(res,-axis,'Attach') 
      elseif axis==1 then res={res}
   end
   if _w.cols then _w=Rerank(_w,-axis,'Attach') 
      elseif axis==1 then _w={_w}
   end
   local l,m=#res,#_w
   rawset(res,'apl_len',l+m)
   return Rerank(set(res,l+1,nil,get(_w,1,m)),axis)
end

Binom = function(_w,_a) 
   argcheck(is_int(_a),1,"integer expected")
   if _a<0 then return 0 end
   local res=1
   for k=_a,1,-1 do res=res*_w/k; _w=_w-1 end
   return res
   end;

Ceil = ceil 

-- Circ
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
Circ = function(_w,_a) return circfunc[_a](_w) end

Copy = function(_w) 
   if is_not"table"(_w) then return _w end
   local res=rho(0,shape(_w))
   set(res,1,nil,unpack(_w)) 
   return res
end

-- Compress
local compress = function(_w,_a)
   if is_not"table"(_w) then _w={_w} end
   local n,v = 1,_a
   local ista = is"table"(_a)
   if ista then
     n=#_a
     if n==1 then v=_a[1]; ista=false
     else checksize(_w,_a,1,"Compress")
     end
   end 
   local res=rho(0,sum(_a))
   n=0
   for k,wk in ipairs(_w) do       
      if ista then v=_a[k] end
      if v>0 then set(res,n+1,n+v,wk); n=n+v end      
   end
   return res
end
Compress = function(_w,_a,axis)
  return along(compress,axis,'Compress')(_w,_a)
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

-- Decode
local decode = function(_w,_a)
   local res=like(_a)   
   if is"table"(_a) then 
      for k=#_a,1,-1 do local d=_w%_a[k]; res[k]=d; _w=(_w-d)/_a[k] 
      end
   else res=_w%_a 
   end
   return res
end
Decode = function(_w,_a)
   return both(decode,_w,_a,0,2)
end

Disclose = function(_w) 
   local m,n = shape(_w)
   argcheck(not n,1,"can't disclose a matrix")
   n=1
   for i,v in ipairs(_w) do
      if is"table"(v) then n=max(n,#v) end 
   end
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

Div = function(_w,_a) return _a/_w end

Down = function(_w) 
   checktype(_w,'table',1,'Down')
   return(reverse(Up(_w)))
   end

-- Drop
local drop = function(_w,_a)   
   local m,n=#_w,abs(_a)
   if n>=m then return rho(0,0) end
   m=m-n
   local res=rho(0,m)
   local i=iota(m)
   if _a<0 then res[i]=_w[i] else res[i]=_w[iota(m,n+1)] 
   end
   return res
end
Drop = function(_w,_a)
   checktype(_w,'table',1,'Drop')
   arr(_w)
   local m,n = shape(_w)
   local s=singleton(_a)
   if s and not n then return drop(_w,s) end
   argcheck(not s and not n,2,"can't drop a matrix from a vector")
   argcheck(s and n,2,"can't drop a vector from a matrix")
   argcheck(#_a==2,2,"can't drop an array of rank "..#_a)
   return along(drop,2)(along(drop,1)(_w,_a[1]),2)
end
   
Each = function(f,ex1,ex2) 
-- Applies function to every element. `ex1, ex2` control whether
-- first or second argument may act as singleton anchor.
   if ex1==nil then ex1=true end
   if ex2==nil then ex2=true end
   return function(_w,_a) 
      if _a then return both(f,_w,_a,ex1,ex2)
      else return each(f,_w) 
      end 
   end
end

Enclose = function(_w) -- make nested array from matrix rows
   local rows, cols = shape(_w)
   argcheck(cols,1,"Expected a matrix")
   local res=rho(0,rows)
   local i0=0
   for i=1,rows do
      res[i]=set(rho(0,cols),1,nil,get(_w,i0+1,i0+cols))
      i0=i0+cols
   end 
   return res
end

-- Encode
local encode = function(_w,_a)
   local res=0
   if is_not"table"(_w) then _w={_w} end
   if is"table"(_a) then for k=1,#_a do res=_a[k]*res+_w[k] end   
   else for k=1,#_w do res=_a*res+_w[k] end
   end
   return res
   end
Encode = function(_w,_a) return inner(encode,_w,_a) end

Exp = exp 

-- Expand
local expand = function(_w,_a)
   if is_not"table"(_w) then _w={_w} end
   local m,n,v = 1,1,_a
   local ista = is"table"(_a)
   if ista then
     n=#_a
     if n==1 then v=_a[1]; ista=false
     else checksize(_w,_a,1,"Compress")
     end
   end 
   if not ista then m=#_w*v else m=sum(_a) end
   local res=rho(0,#_w+m)
   n=0
   for k,wk in ipairs(_w) do       
      if ista then v=_a[k] end
      if v>0 then set(res,n+1,n+v,filler(wk)); n=n+v end
      res[n+1]=wk; n=n+1
   end
   return res
end
Expand = function(_w,_a,axis)
  return along(expand,axis,'Expand')(_w,_a)
end

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
   local res=Copy(_w)
   for k=1,#res do res[k]=lookup[res[k]] or past end
   return res
end

Floor = floor 

-- Format
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
      else return ("%.7g"):format(_w)
   end end
   if is"table"(_w) then 
      local cols = rawget(_w,'cols')
      local data = {}
      local n = #_w
      local L,R
      if getmetatable(_w) then 
         if cols then L,R = '[',']' else L,R = '(',')' end
      else L,R = '{','}'
      end
      for k=1,n do 
         data[#data+1]=rawformat(rawget(_w,k))
         if k<n then if cols and k%cols==0 then data[#data+1]=';'
         else data[#data+1]=','
         end end 
      end
      return L..concat(data)..R
   else return type(v) end
end
Format = function(_w,_a, level)
   level=level or 1
   if _a=="raw" or level>2 or is"table"(_w) and level>1 then 
      return rawformat(_w) 
   end   
   _a = _a or apl._format or "%.7g"
   if is"number"(_a) then _a=aplformat(_a) end
   if _w==nil then return "_" end   
   if is"string"(_w) then return _w end
   if is"number"(_w) then if not(_w==_w) then return "NaN"
      else return form(_w,_a) 
   end end
   if is"table"(_w) then 
      local cols = rawget(_w,'cols')
      local data = {}
      local n = #_w
      local l = 0
      for k=1,n do 
         local item=Format(rawget(_w,k),_a,level+1)
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
   if not cols then 
      local res=iota(n)
      for k=1,n do res[k]=_w[_a[k]] end
      rawset(res,'rows',_a.rows)
      rawset(res,'cols',_a.cols)
      return res
   end
   -- indexing a matrix
   argcheck(n<=2,2,"expected two indices, got "..n)
   local i,j,submat,scalar = rawget(_a,1), rawget(_a,2), true, false
   if is"number"(i) and is"number"(j) then scalar=true end
   if is"number"(i) then i={i}; submat=false end
   if is"number"(j) then j={j}; submat=false end
   if i==nil then i=iota(rows) end
   if j==nil then j=iota(cols) end
   local l,m,n = 0,#i,#j
   local res
   if submat then res=rho(0,m,n) else res=rho(0,m*n) end   
   for k in indices(cols,i,j) do l=l+1; res[l]=_w[k] end
   if scalar then return res[1] else return res end
end

Has = function(_w,_a)
   local t=invert(_w)
   if is_not"table"(_a) then return t[_a] and 1 or 0 end
   local res=like(_a)
   for k,v in ipairs(_a) do res[k]=t[v] and 1 or 0 end
   return res
end

Inner = function(f,g) 
   if f==Pass then return Outer(g) end
   return function(_w,_a)
      return inner(function(x,y) return Reduce(f)(g(x,y)) end,_w,_a)
   end
end

Ln =  log 
Log = log 

-- MatDiv, MatInv appear after scalar functions have been expanded 
local rank=function(S)
   local s1,rank=S[1],0
   for k,s in ipairs(S) do
      if TestEq(s1,s1+s)==1 then break end
      rank=rank+1
   end 
   return rank
end

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
   checktype(f,'function',f)
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

Range = function(_w) 
   local got=Format(_w,'raw')
   _w=singleton(_w) 
   argcheck(_w and is_int(_w),1,
      "integer-valued singleton required, got "..got,"Range")
   return iota(_w)
end

Ravel = function(_w) 
   if is_not"table"(_w) then return rho(_w,1) end
   _w=Copy(_w); _w.rows=nil; _w.cols=nil
   return _w
end

Recip = function(_w) return 1/_w end

--Reduce
local reduce = function(f)
   return function(_w)
      local n=#_w
      if n==0 then 
         argcheck(unit[f],1,"function with no left-unit",'reduce')
         return unit[f] 
      end
      local res=_w[n]
      for k=n-1,1,-1 do res=f(res,_w[k]) end
      return res
   end
end
Reduce=function(f,axis) return along(reduce(f),axis,'Reduce') end

Rerank = function(_w,_a,func)
   checktype(_a,'number',2)
   if is_not"table"(_w) then return {_w} end
   if _a>0 then argcheck(not _w.rows,1,"already a matrix") end
   if _a<0 then argcheck(_w.rows,1,"not a matrix") end
   if _a==1 then return Disclose(_w)
   elseif _a==-1 then return Enclose(_w)
   elseif _a==2 then return Transpose(Disclose(_w))
   elseif _a==-2 then return Enclose(Transpose(_w))
   else argcheck(false,2,"valid values are ±1, ±2",func)
   end
end

Reshape = function (_w,_a)
   argcheck(_w, 1, "can't reshape nil")
   local w1,w2=start(_w)
   local m,n=start(_a)
   if not m then return w1 end
   local res=rho(w1,m,n)
   if w2 then return set(res,1,#res,unpack(_w)) 
      else return set(res,1,#res,w1)
   end
end

-- Reverse
reverse = function(_w) 
    local m = shape(_w)
   if not m or m==1 then return Copy(_w) end
   return set(rho(0,m),1,nil,get(_w,m,1)); 
end
Reverse = function(_w,axis)
  return along(reverse,axis,'Reverse')(_w)
end

Roll = random 

-- Rotate
local rotate = function(_w,_a)
   checktype(_a,'number',1,'Rotate')
   local m,n = shape(_w)
   if not m or m<2 then return _w end   -- nothing to do   
   local res=rho(0,m)     
   checktype(_a,'number',2)
   _a=_a%m
   if _a==0 then return set(res,1,m,get(_w,1,m)) end
   if _a>0 then set(res,1,m-_a,get(_w,_a+1,m)) end
   if _a<m then set(res,m-_a+1,m,get(_w,1,_a)) end
   return res
end
Rotate = function(_w,_a,axis)
   if is'number'(_a) then return along(rotate,axis,'Rotate')(_w,_a)
   else
      if axis==1 then axis=2 
      elseif axis==2 or axis==nil then axis=1
      else argcheck(false,3,"valid values are 1,2","Rotate") 
      end
      return Rerank(both(rotate,Rerank(_w,-axis),_a,1,1),axis)
   end   
end

Same = function(_w,_a) return sanitize(_a==_w) end

-- Scan
local scan = function(f)
   return function(_w)
      if #_w==0 then 
         argcheck(unit[f],'f',"function with no left-unit",'scan')
         return unit[f] 
      end
      if is_not"table"(_w) then _w={_w} end
      local res=like(_w)
      res[1]=_w[1]
      for k=2,#_w do res[k]=f(_w[k],res[k-1]) end
      return res
   end
end
Scan=function(f,axis) return along(scan(f),axis,'Scan') end

Set = function(_w,_a,v)
   checktype(_w,'table',1)
   local v_tbl=is"table"(v)
   if is"function"(_a) then
      if v_tbl then
         local j=0
         for k in _a do j=j+1; _w[k]=v[j] end
      else for k in _a do _w[k]=v end
      end
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
   if not cols then 
      if v_tbl then for k=1,n do _w[_a[k]]=v[k] end
      else for k=1,n do _w[_a[k]]=v end
      end
      return v
   end
   -- indexing a matrix   
   argcheck(n<=2,2,"expected two indices, got "..n)
   local i,j,submat = _a[1], _a[2], true
   if is"number"(i) then i={i}; submat=false end
   if is"number"(j) then j={j}; submat=false end
   if i==nil then i=iota(rows) end
   if j==nil then j=iota(cols) end
   if v_tbl then
      local l=0
      for k in indices(cols,i,j) do l=l+1; _w[k]=v[l] end
   else for k in indices(cols,i,j) do _w[k]=v end
   end
   return v
end

Shape = function(_w) 
   if is"string"(_w) then return #_w else return arr{shape(_w)} end
end

Sign = function(_w) return _w<0 and -1 or _w>0 and 1 or 0 end 
Sub = function(_w,_a) return _a-_w end

SVD = function(_w)
   local m,n = shape(_w)
   argcheck(m,1,"must be an array") 
   local A
   if n==nil then A=Reshape(_w,{1,m}) else A=_w end
   local VT,S,U = core.svd(A)
   m,n = shape(A)
   local l=min(m,n)
   rawset(U,'rows',m); rawset(U,'cols',l)
   rawset(VT,'rows',l); rawset(VT,'cols',n)
   return {U=Enclose(Transpose(U)), S=S, V=Enclose(VT)}
end

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

TestEq = function(_w,_a) 
   if _a==_w then return 1 end
   if _act and abs(_w-_a)<_act then return 1 end
   if _rct and abs(_w-_a)<_rct*abs(_w) then return 1 end
   return 0
end

TestGE = function(_w,_a) 
   if _a>_w then return 1 else return TestEq(_w,_a) end
end

TestGT = function(_w,_a) return _a>_w and 1 or 0 end

TestLE = function(_w,_a) 
   if _a<_w then return 1 else return TestEq(_w,_a) end
end

TestLT = function(_w,_a) return _a<_w and 1 or 0 end
TestNE = function(_w,_a) return _a~=_w and 1 or 0 end

Transpose = function(_w)
   local rows,cols = shape(_w)
   if not cols then return Copy(_w) end
   local res=rho(0,cols,rows)
   transpose(_w,rows,cols,res)
   return res
end   

Up = function(_w) 
   checktype(_w,'table',1,'Up')
   local m,n = shape(_w)
   if n then _w = Enclose(_w) end
   local x=Range(m)
   return sort(x,function(a,b) return _w[a]<_w[b] end)
   end

-- specializations to be used by the APL compiler
apl._F = {
   Attach1 = function(_w,_a) return Attach(_w,_a,1) end;
   Attach2 = function(_w,_a) return Attach(_w,_a,2) end;
   Compress1 = along(compress,1,'Compress');
   Compress2 = along(compress,2,'Compress');
   Expand1 = along(expand,1,'Expand');
   Expand2 = along(expand,2,'Expand');
   Reduce1=function(f) return along(reduce(f),1,'Reduce') end;
   Reduce2=function(f) return along(reduce(f),2,'Reduce') end;
   Reverse1 = along(reverse,1,'Reverse');
   Reverse2 = along(reverse,2,'Reverse');
   Rotate1 = function(_w,_a) return Rotate(_w,_a,1) end;
   Rotate2 = function(_w,_a) return Rotate(_w,_a,2) end;
   Scan1=function(f) return along(scan(f),1,'Scan') end;
   Scan2=function(f) return along(scan(f),2,'Scan') end;
}  


-- Put functions into module table.
-- Local values (whose names are only visible during compilation) are
--   assigned to permanent names.

local scalar1, scalar2, gen1, gen2, op1, op2

-- If you ever make changes to the forward declaration near line 300 of 
-- this file, you need to make corresponding changes below. I have 
-- provided a tool to automate those changes, but you can do it by hand.
--
-- 1. Save this file and run `lua funclists.lua` in the same directory.
-- 2. Cut-and-paste its output below, replacing previous version. 
-- 3, If you like, ask your text editor to reformat the paragraphs.

scalar1={Abs=Abs, Ceil=Ceil, Exp=Exp, Fact=Fact, Floor=Floor, Ln=Ln, Not=Not,
  Pi=Pi, Range=Range, Recip=Recip, Roll=Roll, Sign=Sign, Unm=Unm}

scalar2={Add=Add, And=And, Binom=Binom, Circ=Circ, Deal=Deal, Div=Div, Log=Log,
  Max=Max, Min=Min, Mod=Mod, Mul=Mul, Nand=Nand, Nor=Nor, Or=Or, Pow=Pow,
  Sub=Sub, TestEq=TestEq, TestGE=TestGE, TestGT=TestGT, TestLE=TestLE,
  TestLT=TestLT, TestNE=TestNE}

gen1={Copy=Copy, Disclose=Disclose, Down=Down, Enclose=Enclose, 
  MatInv=MatInv, Pass=Pass, Ravel=Ravel, Reverse=Reverse, Shape=Shape, 
  SVD=SVD, Transpose=Transpose, Up=Up}

gen2={Attach=Attach, Compress=Compress, Decode=Decode, Drop=Drop,
  Encode=Encode, Expand=Expand, Find=Find, Format=Format, Has=Has, Get=Get,
  MatDiv=MatDiv, Rerank=Rerank, Reshape=Reshape, Rotate=Rotate, Same=Same,
  Set=Set, Take=Take}

op1={Each=Each, Outer=Outer, Reduce=Reduce, Scan=Scan}

op2={Inner=Inner}

local groups={gen1=gen1, gen2=gen2, op1=op1, op2=op2}

-- Copy over nonscalar functions

for _,group in pairs(groups) do
   for name,value in pairs(group) do apl[name] = value end
end

-- Replace scalar functions by their expansions

for k,v in pairs(scalar1) do
   apl[k] = function(_w,_a) return each(v,_w) end
end

for k,v in pairs(scalar2) do 
   apl[k] = function(_w,_a) return both(v,_w,_a,1,1) end
end

-- Functions dependent on expanded APL functions

Add, Mul, Div = apl.Add, apl.Mul, apl.Div

MatInv = function(A)
   checktype(A,'table',1,"MatInv")
   local M=SVD(A)
   local S = M.S
   local i=Range(rank(S))
--  +/((V[i]÷¨S[i])(∘.×)¨U[i])
   return Reduce(Add,1)(Each(Outer(Mul))(M.U[i],Each(Div)(S[i],M.V[i])))
end
apl.MatInv=MatInv

apl.MatDiv = function(A,b)
   checktype(b,"table",2,"MatDiv")
   checksize(b,A,2,"MatDiv")
   return Inner(Add,Mul)(b,MatInv(A))
end

-- Populate array metatable

arr_meta.__tostring = Format 
arr_meta.__index = Get
arr_meta.__newindex = Set
arr_meta.__lt = function(x,y)  -- lexicographic comparison
   for i=1,#x do 
     if x[i]<y[i] then return true 
     elseif y[i]<x[i] then return false
     end end
   return false
end

end -- of APL local scope; functions are in module table now

-------------  LuaAPL functions A-Z  -------------------------------
   
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
been set for a few basic operations. If it represents a matrix rather 
than a vector, it has fields `rows`, `columns`.

A small number of APL functions, such as `⊂` (Disclose), can work with 
nested arrays, i.e. the entries themselves are arrays.]])
help("Programming", [[
Big topic. Read the manual. In fact, there is a separate manual on
programming Lua-APL itself.]])   
help("Memos", [[
You can say `help(topic,"help text")` to define your own memo on the
given topic. A topic can be of any type, but it will only be listed
by `help"all"` if it is a string."]])
help("Guessing",[[
(APL mode only) Chunks you type in are guessed to be either APL code 
or Lua code, according to criteria something like the following, 
applied to the first line in the given order.
1. If it is a Lua comment, has `=` shortcut, or contains a Lua marker: Lua.
   Lua markers are words that are likely to be present when an APL string 
   literal is used in Lua code, e.g. "apl", "Define", "Execute", "help",
   "return", "print".
2. If it starts with an impossible character for Lua: APL.
3. If it contains anything except printable ASCII characters: APL.
4. Default: Lua.
If the guess comes out wrong, try putting APl `∘`, `⍕`, `⎕` or Lua `return` 
in front.]])
help("Symbols",[[
The best way to learn APL symbols is to start from `help(apl)` and ask 
for help on individual functions. Otherwise look in `apl-compiler.lua` 
for "Definition of the Lua⋆APL function-to-symbol mapping interface".
The available symbols are given by `help"APL"`.]])

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
         print "Do `help'start'` and follow some of the suggestions."
      elseif select('#',...)>0 then
         print "That's nil. Import or qualify it and try again." 
      elseif helpnil>5 then 
         print"Try `help'start'`."
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
help(Abs, "Abs: ∣⍵ → Lua's math.abs(⍵)")
help(Add, "Add: ⍺+⍵ → Lua's _a+_w")
help(And, "And: ⍺∧⍵ → 1 only if ⍺ and ⍵ both nonzero, else 0")
help(Attach,[[
Attach(⍵,⍺): ⍺,⍵ → elements of ⍺ followed by elements of ⍵
Attach(⍵,⍺,1): ⍺⍪⍵ → rows of ⍺ followed by rows of ⍵
Attach(⍵,⍺,2): ⍺,⍵ → columns of ⍺ followed by rows of ⍵
  In the matrix cases, vectors are treated as one-row matrices.]])
help(Binom,"Binom: ⍺?⍵ → C(⍵,⍺), the number of ways to choose ⍺ of ⍵ items")
help(Ceil, "Ceil: ⌈⍵ → Lua's math.ceil(⍵)")
help(Circ, "Circ: ⍺○⍵ → circle function, see `help'Circ'`")
help(Compress,[[
Compress(⍵,⍺): ⍺/⍵ → copies elements of ⍵ as counted by ⍺
Compress(⍵,⍺,1): ⍺⌿⍵ → copies rows of ⍵ as counted by ⍺
Compress(⍵,⍺,2): ⍺/⍵ → copies columns of ⍵ as counted by ⍺]])
help(Copy,'Copy: +⍵ returns a copy of the APL-visible part of ⍵')
help(Deal,"Deal: ⍺?⍵ → ⍺ distinct numbers randomly selected from ⍳⍵")
help(Decode,"Decode: ⍵⊤⍺ → Decompose ⍺ into base ⍵ digits")
help(Disclose,[[
Disclose: ⊃⍵ makes a matrix from an array of rows. Each ⍵[i] is treated as
a vector and padded to the maximum length using zeros or empty strings.]])
help(Div,"Div: ⍺÷⍵ →  Lua's _a/_w")
help(Down,"Down: ⍒⍵ → the permutation that grades ⍵ downwards")
help(Drop,"Drop: ⍺↓⍵ → ⍵ without its first ⍺ or last -⍺ elements")
help(Each,"Each(f): f¨ → make a term-by-term function from f")  
help(Enclose,"Enclose: ⊂⍵ makes an array of rows from a matrix")
help(Has,"Has: ⍺∊⍵ → does ⍺ occur in ⍵?")
help(Encode,"Encode: ⍵⊥⍺ → ⍺ considered as base ⍵ digits of result")
help(Exp,"Exp: ⋆⍵ → Lua's math.exp(⍵)")
help(Expand,[[
Expand(⍵,⍺): ⍺\⍵ → inserts neutral elements into ⍵ as counted by ⍺
Expand(⍵,⍺,1): ⍺⍀⍵ → inserts neutral rows into ⍵ as counted by ⍺
Expand(⍵,⍺,2): ⍺\⍵ → inserts neutral columns ⍵ as counted by ⍺]])
help(Fact,"Fact: !⍵ → factorial function, ×/⍳⍵")
help(Find,"Find: ⍺⍳⍵ → position of first occurrence of ⍵ in ⍺; not found is #⍺+1")
help(Floor, "Floor: ⌊⍵ → Lua's math.floor(⍵)")
help(Format,"Format: ⍕⍵, ⍺⍕⍵ → convert ⍵ to string, see User's Manual")
help(Inner, "Inner(f,g): f.g → generalization of the matrix product +.×")
help(Get,"Get: ⍵[⍺], see `help'Indexing'")
help(Ln,"Ln: ⍟⍵ → Lua's math.log(⍵)")
help(Log,"Log: ⍺⍟⍵ → Lua's math.log(⍵,⍺)")
help(MatDiv,[[
MatDiv: ⍺⌹⍵ → minimum-norm least-squares solution to the linear system with 
  matrix ⍵ and right-hand side ⍺. Depends on _act and _rct.]])
help(MatInv,[[
MatInv: ⌹⍵ → Pseudo-inverse of ⍵. Depends on _act and _rct.]]) 
help(Max,"Max: ⍺⌈⍵ → Lua's math.max(⍵,⍺)")
help(Min,"Min: ⍺⌊⍵ → Lua's math.min(⍵,⍺)")
help(Mod,"Mod: ⍺|⍵ → Lua's _a%_w")
help(Mul,"Mul: ⍺×⍵ → Lua's _a*_w")
help("NaN",helpNaN)
help(Outer, "Outer(g): ⍺ ∘.g ⍵ → ⍵[i] g ⍺[j] for all possible pairs")   
help(Set,"Set: ⍵[⍺]←v, see `help'Indexing'")
help(Nor,"Nor: ⍺⍱⍵ → 1 only if both ⍺ and ⍵ are 0, else 0")
help(Pi,"Pi: ○⍵ → Lua's math.pi times ⍵")
help(Pow,"Pow: ⍺⋆⍵ → Lua's _a^_w")
help(Range,"Range: ⍳⍵ → {1,2,...,⍵}") 
help(Ravel,"Ravel: ,⍵ → vector containing elements of ⍵")
help(Reduce,[[
Reduce(⍵,⍺): ⍺/⍵ → copies elements of ⍵ as counted by ⍺
Reduce(⍵,⍺,1): ⍺⌿⍵ → copies rows of ⍵ as counted by ⍺
Reduce(⍵,⍺,2): ⍺/⍵ → copies columns of ⍵ as counted by ⍺]])
help(Rerank,[[
Rerank: Rerank(_w,_a): array of one rank higher (_a>0) or lower (_a<0),
   stacking rows (±1) or columns (±2). See Disclose/Enclose.]])
help(Reshape,"Reshape: ⍺⍴⍵ → Make an array of shape ⍺ by using ⍵ cyclically")
help(Reverse,[[
Reverse(⍵): ⌽⍵ → elements of ⍵ in reverse order
Reverse(⍵,1): ⊖⍵ → rows of ⍵ in reverse order
Reverse(⍵,2): ⌽⍵ → columns of ⍵ in reverse order"]])
help(Roll,"Roll: ?⍵ → Lua's math.random(⍵)")
help(Rotate,[[
Rotate(⍵,⍺): ⍺⌽⍵ → elements of ⍵ rotated left by ⍺ or right by -⍺
Rotate(⍵,⍺,1): ⍺⊖⍵ → elements in columns of ⍵ rotated up by ⍺ or down by -⍺
Rotate(⍵,⍺,2): ⍺⌽⍵ → elements in rows of ⍵ rotated left by ⍺ or right by -⍺]])
help(Same,"Same: ⍺≡⍵ means Lua equality but APL 0-1 result")
help(Scan,[[
Scan(f): f/⍵ → ⍵[1], ⍵[1] f ⍵[2],  (⍵[1] f ⍵[2]) f ⍵[3] etc
   Last term equals Reduce(f)(⍵) for associative functions only! 
Scan(f,1): f⌿⍵ → scan over rows
Scan(f,2): f⌿⍵ → scan over columns]])
help(Shape,[[
Shape: ⍴⍵ → {} if a number, {#⍵} if a vector, {rows,cols} if a matrix.
       #⍵ if a string.]])
help(Sign,"Sign: ×⍵ is ¯1,0,1 according to whether ⍵ is <0, =0, >0")
help(Sub,"Sub: ⍺-⍵ → Lua's _a-_w")
help(Take,"Take: ⍺↑⍵ → The first ⍺ or last -⍺ elements of ⍵")   
help(TestEq,"TestEq: ⍺=⍵ → 1 if ⍺ equals ⍵ within tolerance, else 0")
help(TestGE,"TestGE: ⍺≥⍵ → 1 if ⍺>⍵ or ⍺ equals ⍵ within tolerance, else 0")
help(TestGT,"TestGT: ⍺>⍵ → Lua's _a>_w")
help(TestLE,"TestLE: ⍺≤⍵ → 1 if ⍺<⍵ or ⍺ equals ⍵ within tolerance, else 0")
help(TestLT,"TestLT: ⍺<⍵ → Lua's _a<_w")
help(TestNE,"TestNE: ⍺≠⍵ → Lua's _a~=_w")
help(Transpose,'Transpose: ⍉⍵ → matrix transpose of ⍵')
help(Up,"Up: ⍋⍵ → the permutation that grades ⍵ upwards")
help('import',[[
apl:import(): imports the bare minimum of what is convenient.
apl:import(name): imports only `name`
apl:import"*"` imports the whole module table. It swamps rather than 
   pollutes the global namespace, but in Lua mode, that's what you want.]])

end ---------------- _ENV apl --------------------------------------------

help("start",[[
    help(apl)         -- displays module table
    help"all"         -- lists topics you can read by `help"topic"`
    help(help)        -- says more about `help`
    apl:import'Func'  -- imports `Func` (comma-separated) into _ENV 
    apl:import"*"     -- imports all names not starting with `_` into _ENV
    help(Func)        -- displays help on `Func`  (no quotes)
    help"APL"         -- displays functions available in APL source]])

help("_act","_act: absolute comparison tolerance")
help("_rct","_rct: relative comparison tolerance")
help("_format","_format: default format, 'raw' means no prettyprinting")

-- Insert last-minute items into module table

apl.NaN = NaN
apl.help = help
apl._act=1/bit32.lshift(1,24)^2
apl._rct=apl._act
apl._format='%.10g'
apl.import = function(apl,names,env)
--- apl:import(names)  e.g. apl:import"Rotate,Reverse,Range,Shape"
--    imports specified names from `apl` into global namespace
--  apl:import"*"  imports all names not starting with underscore
--  import(source,names,target) in general does this from table `source`
--    to table `target`
   if not is"table"(apl) then
      print"Did you say `apl.import` instead of `apl:import`?"
      return
   end
   env = env or _ENV      
   if env.help and not is"string"(names) then
       print"Did you forget the quotes on `apl:import'Func'`?"
       return
   end
   if names=='*' then for k in pairs(apl) do 
      if not k:match"^_" then env[k]=apl[k] 
   end end 
   elseif is"string"(names) then for k in names:gmatch"%a%w+" do
      env[k]=apl[k]
   end 
   else env.help = apl.help
   end
end

apl.util = {argcheck=argcheck, checktype=checktype, logfile=logfile,
  is=is, is_not=is_not, rho=rho, shape=shape, where=where}

-- welcome message

logfile:write [[  
   BUGS: 
1. Not enough runtime checks on input values.
2. Too few functions have been adequately tested.

]]   

print [[
apl-lib 0.3.0 © Dirk Laurie 2013
Bug reports are welcome. You'll find me on Lua-L.
If you can't remember the README, do this:
  apl:import(); help'start'
--]]

-- clean up

setmetatable(_ENV,meta_ENV)
loading=false

return apl


