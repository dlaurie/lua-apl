-- apl.lua  (c) Dirk Laurie 2013  Lua-style MIT licence
-- APL-like library and APL compiler for Lua

-- This is a long program. Search on `APL_LEVEL` for major divisions,
-- `--##` for minor divisions.

if _VERSION~="Lua 5.2" then error[[Lua⋆APL runs under Lua 5.2]]
end

local _VERSION = "Lua⋆APL 0.4.0"
_APL_LEVEL = _APL_LEVEL or 2

-- You can set global _APL_LEVEL before requiring this module. 
-- It's mainly a debugging tool. See discussion in the Programmer's Guide.

-- External modules

local lpeg=require"lpeg"
local core=require"apl_core"
local help=require"help"

-- The main module table 'apl' and some of its subtables

local load_apl
local apl_meta = {__call = function(apl,code) return load_apl(code) end }
local arr_meta = getmetatable(core.rho(0,0)) 
local core_index,core_newindex = arr_meta.__index,arr_meta.__newindex
local util                                          -- utility routines
local _V = setmetatable({},{__index=_ENV})     -- APL variables go here
local APL_ENV = {_V=_V}       -- environment for compiled APL functions  
local apl_dict = {}                            -- APL-to-Lua dictionary
local lua_dict                                 -- Lua-to-APL dictionary 
local unit                            -- units of some dyadic functions

local apl=setmetatable({APL_ENV=APL_ENV}, apl_meta)

-- Debugging aids 

local loading=true
local logfile = io.open("/tmp/apl-lua.log","w")
local where=core.where

local meta_ENV=getmetatable(_ENV)
setmetatable(_ENV,{__newindex = function (ENV,name,value)
   logfile:write(where(2),"Assigning _ENV.",name,"\n")
   rawset(ENV,name,value)
end})

-- forward declaration of util routines
local argcheck, arr, both, checksize, checktype, compat, each, filler, 
  get, invert, iota, is, is_int, is_not, replace, rho, set, shape, 
  singleton, start, sum, utfchar, utflen

          do --## local scope for util

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

both = core.both

checksize = function(A,B,op,name)
--- If op=1, check term-by-term compatibility
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

checktype = function(val,typ,pos,name)
   name = debug.getinfo(2,'n').name or name or "<anonymous>"
   if type(val)~=typ then 
      error(("bad argument "..pos.." to %s: expected %s, got %s"):format
            (name,typ,type(val)))   
   end
   return val
end

compat=core.compat
each = core.each

filler = function(x)
--- neutral value of same type as first value in x
   if is"table"(x) then x=x[1] end
   if is"string"(x) then return '' else return 0 end
end

get = core.get
iota = core.iota
is = function(typ) return function(x) return type(x)==typ end end
is_int = core.is_int 
is_not = function(typ) return function(x) return type(x)~=typ end end

invert = function(_w) 
--- invert(tbl): Switches keys and values in a table.  
-- Return value is just a table, not an APL array.
   local t={} 
   for k,v in ipairs(_w) do t[v]=k end 
   return t
end

replace = function(s,t,u) 
--- copy items from t to s, moving old items with the same keys to u
   for k,v in pairs(t) do 
      local old=s[k]
      if u then u[k]=old end
      s[k]=v 
   end 
end

rho=core.rho
set=function(t,...) core.set(t,...) return t end

shape = function(x) 
--- shape as a variable-length return list
   if is"table"(x) then
      local r,c = rawget(x,'rows'), rawget(x,'cols')
      if c then return r, c else return #x end
   end
end

--- if x is scalar or has just one element, return it
singleton = function(x)
   if is_not"table"(x) then return x end
   if #x==1 then return x[1] end
end

start = function(x)
--- first two items of x
   if is"table"(x) then return rawget(x,1),rawget(x,2)
   else return x
   end
end

sum = function(x)
--- +/x
   if is_not"table"(x) then return x end
   local s=0
   for _,v in ipairs(x) do s=s+v end
   return s
end 

util = {argcheck=argcheck, arr=arr, both=both, checksize=checksize,
  checktype=checktype, compat=compat, each=each, filler=filler, get=get,
  invert=invert, iota=iota, is=is, is_int=is_int, is_not=is_not, 
  replace=replace, rho=rho, set=set, shape=shape, singleton=singleton,
  start=start, sum=sum }
apl.util = util

          end -- local scope for util

          do --## local scope for compiler

local C,     P,     R,     S,     V,     Cmt,     Cp,     Ct = 
 lpeg.C,lpeg.P,lpeg.R,lpeg.S,lpeg.V,lpeg.Cmt,lpeg.Cp,lpeg.Ct

local concat=table.concat
local Monadic_functions, Monadic_operators, Dyadic_functions, 
   Dyadic_operators = {},{},{},{}

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
local String = _s^0*"'"*(1-P"'")^0*"'"*_s^0           -- non-empty
local Vector = _s^0*number*(_s^1*number)^0

local first = R"az"+R"AZ"+"_"
local later = first+R"09"
local ascii = R"\x00\x7F"                -- 7-bit ASCII
local utc = R"\x80\xBF"                  -- UTF-8 continuation byte
local utf2 = R"\xC0\xDF"*utc             -- 2-byte codepoint
local utf3 = R"\xE0\xEF"*utc*utc         -- 3-byte codepoint
local utf4 = R"\xF0\xF7"*utc*utc*utc     -- 4-byte codepoint
local utf5 = R"\xF8\xFD"*utc*utc*utc*utc -- 5-byte codepoint
local utf8 = ascii + utf2 + utf3 + utf4 +utf5  -- any codepoint
local utf = utf2 + utf3 + utf4 +utf5 - P"←"-P"¯"
local neutral = R"\x21\x7E"-later-S"()[;]"  
local name = first*later^0 + utf + neutral

local Monadic_function = _s^0*Cmt(name,lookup(Monadic_functions))*_s^0
local Monadic_operator = _s^0*Cmt(name,lookup(Monadic_operators))*_s^0
local Dyadic_function = _s^0*Cmt(name,lookup(Dyadic_functions))*_s^0
local Dyadic_operator = _s^0*Cmt(name,lookup(Dyadic_operators))*_s^0
local operator = Monadic_operator + Dyadic_operator
local funcname = Monadic_function + Dyadic_function
local Param = _s^0*(P'⍺'/'_a' + P'⍵'/'_w')*_s^0 -- not to be looked up in _V
local Var = _s^0*C(first*later^0+utf-funcname-operator)*_s^0 - Param

local expr,   leftarg,   value,   index,   indices,   func_expr
   =V"expr",V"leftarg",V"value",V"index",V"indices",V"func_expr"
local monadic_func,    dyadic_func,    ambivalent 
  = V"monadic_func", V"dyadic_func", V"ambivalent"

local apl_expr = P { "statement";
   statement = (_s^0*P'←'*expr)/"return %1" 
     + Param/1*'←'*expr/"%1=%2" 
     + Param/1*"["*indices*"]"*'←'*expr/"%1[%2]=%3"
     + expr;
   expr = '∇'*func_expr
     + Var*'←'*expr/"Assign(%2,'%1')" 
     + Var*"["*indices*"]"*'←'*expr/"Assign(%3,'%1',%2)" 
     + leftarg*dyadic_func*expr/"%2(%3,%1)" 
     + monadic_func*expr/"%1(%2)" 
     + leftarg;
   dyadic_func = '∘.'*func_expr/'Outer(%1)' + ambivalent + Dyadic_function;
   monadic_func = ambivalent + Monadic_function;
   func_expr = '('*(dyadic_func+Monadic_function)*')'/1 
     + Dyadic_function + Monadic_function;
   ambivalent = func_expr*Monadic_operator/"%2(%1)"
      + func_expr*Dyadic_operator*func_expr/"%2(%1,%3)";
   leftarg = value + '('*expr*')'/1;
   value = Vector/numbers + String/1 +
      (Var*'['*indices*']'/"%1[%2]" + Var)/"_V.%1" + 
      (Param*'['*indices*']'/"%1[%2]" + Param)/1;
   index = expr+_s^0/"nil";
   indices = index*';'*index/"{%1;%2}" + expr;
   }

local apl2lua
apl2lua = function(apl)
   local i,j = apl:find"⋄"
   if j then 
      return apl2lua(apl:sub(1,i-1))..'; '..apl2lua(apl:sub(j+1)) 
   end
   local lua,pos = (apl_expr*_s^0*Cp()):match(apl)
   pos = pos or 0
   if pos>#apl then return lua 
   else error("APL syntax error\n"..apl.."\n"..
      (" "):rep(utflen(apl:sub(1,pos))-1)..'↑')
   end
end

local classname={[0]="reserved", [1]="monadic function", 
   [2]="dyadic function", [5]="monadic operator", [6]="dyadic operator"}
local Reserved={}
local registry={[0]=Reserved, [1]=Monadic_functions, [2]=Dyadic_functions,
   [3]='ambivalent', [5]=Monadic_operators, [6]=Dyadic_operators, 
   [7]='ambivalent'}
-- Class 0 has phony APL names. They have no real purpose beyond being 
--    search keys for "help".
-- Class 7 is not used by the module itself. It is there for ambivalent 
--    user functions.  
 
local register
register = function (code, fct, APLname, LuaName, alias, helptext)
--- register(code, fct, APLname, LuaName, alias, help)
-- Register a function or operator.
--   code: number of arguments, add 4 for an operator
--   fct: the function itself
--   APLname: the preferred APL name
--   LuaName: the Lua name
--   alias: an alternative APL name (optional)
--   help: help text accessible via the function itself 
   local class=registry[code]
   argcheck(class,1,"Must be 0,1,2,3,5,6 or 7")
   if class=='ambivalent' then 
      for k=1,2 do register(code-k,fct,APLname,LuaName,alias,helptext) end
      return
   end
   local cname=classname[code]
   checktype(APLname,'string',3)
   checktype(LuaName,'string',4)
   logfile:write(LuaName,": ",cname," '", APLname,"'")
   if alias then checktype(alias,'string',5) end
   if helptext then checktype(helptext,'string',6) end
--   checktype(fct,'function',2) 
   if not fct then logfile:write(" undefined!\n"); return end
   
   argcheck(not APL_ENV[LuaName] or APL_ENV[LuaName]==fct,2,
      "name '"..LuaName.."' already in use in APL runtime environment")
   if code>0 then argcheck(not class[APLname],2,"name '"..APLname..
      "' already in use as "..cname)
   end
   if alias then 
       argcheck(not class[alias],4,"name '"..alias..
      "' already in use as "..cname)
       argcheck(alias~=APLname,4,"name '"..alias..
      "' is the same as the APL name")
   end

   if alias then logfile:write(" or '",alias,"'") end
   logfile:write((" (%s)\n"):format(tostring(fct)))  

   class[APLname]=LuaName
   local dict=apl_dict[APLname]
   if dict then dict[#dict+1]=LuaName
   else apl_dict[APLname]={LuaName} 
   end
   if alias then class[alias]=LuaName end
   apl[LuaName]=fct
   APL_ENV[LuaName]=fct
   if helptext then help(fct,helptext) end
end

local preamble=[[local _w,_a=... 
]]

load_apl = function(_w)
   checktype(_w,'string',1)
   _w = _w:gsub("⍝[^\n]+"," "):gsub("\n"," ")  -- strip off APL comments
   local lua = apl2lua(_w)
   if select(2,_w:gsub('⋄',''))==0 then  
      lua="return "..lua 
      end
   local f,msg = load(preamble..lua,nil,nil,APL_ENV)
   if not f then 
      error("Could not compile: ".._w.."\n Tried: "..lua.."\n"..msg) 
   end
   help(f,_w)
   return f   
end

local function lua_code(_w)
-- Display Lua code of a function
   if is"function"(_w) then 
      local source = debug.getinfo(_w).source
      if source:sub(1,#preamble)==preamble then 
          source=source:sub(#preamble+1)
      end
      return source
   else return "Not a function"
   end
end

apl.lua = lua_code
apl.register = register

apl.help = function(topic,...)
-- Displays brief documentation of a function or a predefinedtopic; 
-- lists keys of a table. Examples are given in `help"start"`.
   local h={}
   local dict=apl_dict[topic]
   if dict then for k,v in pairs(dict) do
      local hv=help(APL_ENV[v],0)
      local addme=true
      for _,t in pairs(h) do if t==hv then addme=false; break end end 
      if addme then h[k]=hv end
    end end
   if not (topic==topic) then topic="NaN" end
   if #h>0 then print(concat(h,'\n')) else return help(topic,...) end 
end

utfchar = function(s) return arr((Ct((utf8/1)^0)*-1):match(s)) end
utflen = function(s) return #(utfchar(s)) end
util.utfchar, util.utflen = utfchar, utflen

          end   -- local scope for compiler

          do --## Basic APL routines

local register = apl.register

apl.import = function(apl,names)
   if not is"table"(apl) then
      print"Did you say `apl.import` instead of `apl:import`?"
      return
   end 
   if _ENV.help and not is"string"(names) then
       print"Did you forget the quotes on `apl:import'Func'`?"
       return
   end
   if names=='*' then for k in pairs(apl) do 
      if not k:match"^_" then _ENV[k]=apl[k] 
   end end 
   elseif is"string"(names) then for k in names:gmatch"%a%w+" do
      _ENV[k]=apl[k]
   end
   else
      _ENV.help = apl.help
      _ENV.lua = apl.lua
   end
end

local Assign = function(_w,_a,ij)
   argcheck(_w,'⍵',"Can't assign nil to an APL name","Assign")  
   if is"function"(_w) then
      register(3,_w,_a,_a,nil,help(_w,0))
      return _a
   end
   local global_name = _a:match"_(.+)"      -- global assignment? If so,
   _a = global_name or _a                   -- strip off one underscore.
   local ENV = global_name and _ENV or _V   -- Select namespace
   if not ij then 
      ENV[_a]=_w 
      return _w 
   end
   _a = ENV[_a]; checktype(_a,'table','_a')
   _a[ij]=_w   
   return _w 
end

local Define = function(_w)
   if is"function"(_w) then return _w end
   return load_apl(checktype(_w,"string",'⍵','Define'))
end

local Execute = function(_w) return load_apl(_w)() end
local Length = function(x) return #x end
local Print = function(_w) print(_w); return _w end

register(0,Assign,'←','Assign',nil,
   "Assign: ⍵←⍺ → assign ⍺ to ⍵, see User's Manual")

apl.f1 = {Length=Length, Print=Print, Define=Define,Execute=Execute}

help(Print,"Print: ⎕⍵ prints ⍵ and returns ⍵")
help(Define,[[
Define: ∇s returns APL code `s` compiled as a Lua function
        ∇f returns a function as-is]])
help(Execute,"Execute: ⍎⍵ → Define(⍵)()")
help(Length, "Length: ≡⍵ → Lua length operator applied to ⍵")

          end -- Basic APL routines

          do --## primitive scalar functions

local Abs, Ceil, Exp, Fact, Floor, Ln, Not, Pi, Range, Recip, Roll, Sign, Unm
local Add, And, Binom, Circ, Deal, Div, Log, Max, Min, Mod, Mul, Nand, 
   Nor, Or, Pow, Sub, TestEq, TestGE, TestGT, TestLE, TestLT, TestNE 
local Get, Format, NaN, Pass, Range, Reshape, Same, Set, ToString
 
local abs, concat = math.abs, table.concat

local iverson = function(b) if b then return 1 else return 0 end end

Abs = math.abs 
Add = function(_w,_a) return _a+_w end
And = function(_w,_a) return iverson(_w~=0 and _a~=0) end

Binom = function(_w,_a) 
   argcheck(is_int(_a),1,"integer expected")
   if _a<0 then return 0 end
   local res=1
   for k=_a,1,-1 do res=res*_w/k; _w=_w-1 end
   return res
   end;

Ceil = math.ceil 

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
Div = function(_w,_a) return _a/_w end
Exp = math.exp 

Fact = function(_w) 
   argcheck(is_int(_w),1,"integer expected")
   if _w<0 then if _w%2==0 then return -Inf else return Inf end end
   local f=1; for k=2,_w do f=f*k end; return f 
end

Floor = math.floor 

Format = function(_w,_a) 
   return _a and _a~='raw' and _a:format(_w) or ToString(_w) 
end

Get=core.index
Ln = math.log 
Log = math.log 
Max = math.max 
Min = math.min 
Mod = function(_w,_a) return _w%_a end
Mul = function(_w,_a) return _a*_w end 
NaN = 0/0; 
Nand = function(_w,_a) return iverson(not(_w~=0 and _a~=0)) end
Nor = function(_w,_a) return iverson(not(_w~=0 or _a~=0)) end
Not = function(_w) return iverson(_w~=0) end
Or = function(_w,_a) return iverson(_w~=0 or _a~=0) end
Pass = function() return end
local pi=math.pi
Pi = function(_w) return pi*_w end
Pow = function(_w,_a) return _a^_w end
Range = core.iota
Recip = function(_w) return 1/_w end
Reshape = core.rho
Roll = math.random 
Same = function(_w,_a) return iverson(_a==_w) end
Set = core.newindex
Sign = function(_w) return _w<0 and -1 or _w>0 and 1 or 0 end 
Sub = function(_w,_a) return _a-_w end

TestEq = function(_w,_a) 
   local _act, _rct = apl._act, apl._rct
   if _a==_w then return 1 end
   if _act and abs(_w-_a)<_act then return 1 end
   if _rct and abs(_w-_a)<_rct*abs(_w) then return 1 end
   return 0
end

TestGE = function(_w,_a) 
   if _a>_w then return 1 else return TestEq(_w,_a) end
end

TestGT = function(_w,_a) return iverson(_a>_w) end

TestLE = function(_w,_a) 
   if _a<_w then return 1 else return TestEq(_w,_a) end
end

TestLT = function(_w,_a) return iverson(_a<_w) end
TestNE = function(_w,_a) return iverson(_a~=_w) end

ToString = function(_w)
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
         data[#data+1]=ToString(rawget(_w,k))
         if k<n then if cols and k%cols==0 then data[#data+1]=';'
         else data[#data+1]=','
         end end 
      end
      local res=concat(data)
      if #res>=72 then res=res:gsub(';','\n ') end
      return L..res..R
   else return type(v) end
end

Unm = function(_w) return -_w end

local lib = {Get=core.index,NaN=NaN,Set=core.newindex}

local f1={Abs=Abs, Ceil=Ceil, Exp=Exp, Fact=Fact, Floor=Floor, Ln=Ln, 
  Not=Not, Pi=Pi, Recip=Recip, Roll=Roll, Sign=Sign, Unm=Unm}

local f2={Add=Add, And=And, Binom=Binom, Circ=Circ, Deal=Deal, Div=Div, 
  Log=Log, Max=Max, Min=Min, Mod=Mod, Mul=Mul, Nand=Nand, 
  Nor=Nor, Or=Or, Pow=Pow, Sub=Sub, TestEq=TestEq, TestGE=TestGE, 
  TestGT=TestGT, TestLE=TestLE, TestLT=TestLT, TestNE=TestNE}

local gen1={Pass=Pass, Range=Range, ToString=ToString}

local gen2={Format=Format, Pass=Pass, Reshape=Reshape, Same=Same}

apl.rank0 = {f1=f1, f2=f2, lib={}}  -- primitive scalar functions
apl.lib=lib
apl.f2,apl.op1,apl.op2 = {},{},{}
replace(apl.f1,f1); replace(apl.f1,gen1);
replace(apl.f2,f2); replace(apl.f2,gen2);

local helptext = {
[Abs] = "Abs: ∣⍵ → Lua's math.abs(⍵)";
[Add] = "Add: ⍺+⍵ → Lua's _a+_w";
[And] = "And: ⍺∧⍵ → 1 only if ⍺ and ⍵ both nonzero, else 0";
[Binom] = "Binom: ⍺?⍵ → C(⍵,⍺), the number of ways to choose ⍺ of ⍵ items";
[Ceil] =  "Ceil: ⌈⍵ → Lua's math.ceil(⍵)";
[Circ] =  "Circ: ⍺○⍵ → circle function, see `help'Circ'`";
[Div] = "Div: ⍺÷⍵ →  Lua's _a/_w";
[Exp] = "Exp: ⋆⍵ → Lua's math.exp(⍵)";
[Fact] = "Fact: !⍵ → factorial function, ×/⍳⍵";
[Floor] =  "Floor: ⌊⍵ → Lua's math.floor(⍵)";
[Format] = "Format: ⍺⍕⍵ → format ⍵ according to ⍺, see User's Manual";
[Ln] = "Ln: ⍟⍵ → Lua's math.log(⍵)";
[Log] = "Log: ⍺⍟⍵ → Lua's math.log(⍵,⍺)";
[Max] = "Max: ⍺⌈⍵ → Lua's math.max(⍵,⍺)";
[Min] = "Min: ⍺⌊⍵ → Lua's math.min(⍵,⍺)";
[Mod] = "Mod: ⍺|⍵ → Lua's _a%_w";
[Mul] = "Mul: ⍺×⍵ → Lua's _a*_w";
[Nand] = "Nand: ⍺⍲⍵ → 0 only if both ⍺ and ⍵ are nonzero, else 1";
[Nor] = "Nor: ⍺⍱⍵ → 1 only if both ⍺ and ⍵ are 0, else 0";
[Not] = "Not: ~⍵ → 0 if ⍵ is 0, else 1";
[Pi] = "Pi: ○⍵ → Lua's math.pi times ⍵";
[Pow] = "Pow: ⍺⋆⍵ → Lua's _a^_w";
[Or] = "Or: ⍺∧⍵ → 0 only if ⍺ and ⍵ are both zero, else 1";
[Range] = [[
Range: ⍳⍵ → first ⍵ integers starting at 1
       ⍺⍳⍵ → first ⍵ integers starting at ⍺ ]];
[Reshape] = "Reshape: ⍺⍴⍵ → data given by ⍵, shape given by ⍺";
[Roll] = "Roll: ?⍵ → Lua's math.random(⍵)";
[Same] = "Same: ⍺≡⍵ means Lua equality but APL 0-1 result";
[Sign] = "Sign: ×⍵ is ¯1,0,1 according to whether ⍵ is <0, =0, >0";
[Sub] = "Sub: ⍺-⍵ → Lua's _a-_w";
[TestEq] = "TestEq: ⍺=⍵ → 1 if ⍺ equals ⍵ within tolerance, else 0";
[TestGE] = "TestGE: ⍺≥⍵ → 1 if ⍺>⍵ or ⍺ equals ⍵ within tolerance, else 0";
[TestGT] = "TestGT: ⍺>⍵ → Lua's _a>_w";
[TestLE] = "TestLE: ⍺≤⍵ → 1 if ⍺<⍵ or ⍺ equals ⍵ within tolerance, else 0";
[TestLT] = "TestLT: ⍺<⍵ → Lua's _a<_w";
[TestNE] = "TestNE: ⍺≠⍵ → Lua's _a~=_w";
[ToString] = "ToString: ⍕⍵ → string representation of ⍵";
[Unm] = 'Unm: -⍵ → unary minus (negative of ⍵)';
}

for k,v in pairs(helptext) do help(k,v) end

          end -- primitive scalar functions

          if _APL_LEVEL>0 then --## vector functions

-- term-by-term versions of primitive scalar functions

for k,v in pairs(apl.rank0.f1) do
   local f = function(_w,_a) return each(v,_w) end
   help(f,help(v,0))
   apl.f1[k] = f
end

for k,v in pairs(apl.rank0.f2) do 
   local f = function(_w,_a) return both(v,_w,_a,1,1) end
   help(f,help(v,0))
   apl.f2[k] = f 
end

-- new functions

local Copy, Disclose, Down, Enclose, MatInv, Pass, Ravel, Reverse, Shape, 
   SVD, Transpose, Up   
local Attach, Compress, Deal, Decode, Drop, Encode, Expand, Find, Format, 
   Has, Get, MatDiv, Rerank, Reshape, Rotate, Same, Set, Take 
local Each, Outer, Reduce, Scan
local Inner

local transpose=core.transpose
local abs,max,min,random = math.abs,math.max,math.min,math.random
local sort,unpack = table.sort,table.unpack

Attach = function(_w,_a)
   _w=arr(_w); _a=arr(_a)
   local k,l = #_a,#_w
   return set(set(rho(0,k+l),1,k,unpack(_a)),k+1,k+l,unpack(_w))   
end

Compress = function(_w,_a)
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

Copy = function(_w) 
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

Decode = function(_w,_a)   
   if is"table"(_a) then 
      local m=#_a
      local res=rho(0,m)
      for k=m,1,-1 do local d=_w%_a[k]; res[k]=d; _w=(_w-d)/_a[k] 
      end
      return res
   else return _w%_a 
   end
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

Down = function(_w) 
   checktype(_w,'table',1,'Down')
   return(Reverse(Up(_w)))
   end

Drop = function(_w,_a)
   if _a<0 then return Reverse(Drop(Reverse(_w),-_a)) end
   if is_not"table"(_w) then _w={_w} end
   local m,n=#_w,abs(_a)
   if n>=m then return rho(0,0) end
   if _a<0 then return Take(_w,m-n) else return Take(_w,n-m) end
end
    
Each = function(f,ex1,ex2) 
-- Applies function to every element. `ex1, ex2` control whether
-- first or second argument may act as singleton anchor.
   if ex1==nil then ex1=1 end
   if ex2==nil then ex2=1 end
   return function(_w,_a) 
      if _a then return both(f,_w,_a,ex1,ex2)
      else return each(f,_w) 
      end 
   end
end

Enclose = function(_w) -- make nested array from matrix rows
   local rows, cols = shape(_w)
   argcheck(cols,1,"Expected a matrix","Enclose")
   local res=rho(0,rows)
   local i0=0
   for i=1,rows do
      res[i]=set(rho(0,cols),1,nil,get(_w,i0+1,i0+cols))
      i0=i0+cols
   end 
   return res
end

Encode = function(_w,_a)
   local res=0
   if is_not"table"(_w) then _w={_w} end
   if is"table"(_a) then for k=1,#_a do res=_a[k]*res+_w[k] end   
   else for k=1,#_w do res=_a*res+_w[k] end
   end
   return res
   end

Expand = function(_w,_a)
   if is_not"table"(_w) then _w={_w} end
   local m,n,v = 1,1,_a
   local ista = is"table"(_a)
   if ista then
     n=#_a
     if n==1 then v=_a[1]; ista=false
     else checksize(_w,_a,1,"Expand")
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

Get = function(_w,_a)
   checktype(_w,'table',1)
   if is"function"(_a) then
      local res={}          -- don't know the length in advance
      for k in _a do res[#res+1]=_w[k] end
      res.apl_len=#res      
      setmetatable(res,arr_meta)
      return res
   end
   local m,n = shape(_a)
   if not m then return core_index(_w,_a) end
   res=rho(0,m,n) 
   for k=1,#_a do res[k]=_w[_a[k]] end
   return res
end

Has = function(_w,_a)
   local t=invert(_w)
   local m,n = shape(_a)
   if not m then return t[_a] and 1 or 0 end
   local res=rho(0,m,n)
   for k,v in ipairs(_a) do if t[v] then res[k]=1 end end
   return res
end

Inner = function(f,g) 
   checktype(f,'function',1)
   checktype(g,'function',2)
   return function(_w,_a)
      return Reduce(f)(g(_w,_a))
   end
end

local Add, Mul, Div = apl.f2.Add, apl.f2.Mul, apl.f2.Div
local dot=Inner(Add,Mul)
MatDiv = function(_w,_a) return dot(_w,_a)/dot(_w,_w) end
MatInv = function(_w) return Div(dot(_w,_w),_w) end

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

Ravel = function(_w) 
   if is_not"table"(_w) then return rho(_w,1) end
   _w=Copy(_w); _w.rows=nil; _w.cols=nil
   return _w
end

Reduce = function(f)
   checktype(f,'function',1)
   return function(_w)
      local n=#_w
      if n==0 then 
         argcheck(unit[f],1,"function with no left-unit\n"..help(f,0),
            'Reduce')
         return unit[f] 
      end
      local res=_w[n]
      for k=n-1,1,-1 do res=f(res,_w[k]) end
      return res
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

Reverse = function(_w) 
   local m = shape(_w)
   if not m or m==1 then return Copy(_w) end
   return set(rho(0,m),1,nil,get(_w,m,1)); 
end

Rotate = function(_w,_a)
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

Scan = function(f)
   return function(_w)
      if #_w==0 then 
         argcheck(unit[f],'f',"function with no left-unit\n"..help(f,0),'Scan')
         return unit[f] 
      end
      if is_not"table"(_w) then _w={_w} end
      local res=rho(0,shape(_w))
      res[1]=_w[1]
      for k=2,#_w do res[k]=f(_w[k],res[k-1]) end
      return res
   end
end

Set = function(_w,_a,v)
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
   if v_tbl then for k=1,n do _w[_a[k]]=v[k] end
   else for k=1,n do _w[_a[k]]=v end
   end
   return v
end

Shape = function(_w) 
   if is"string"(_w) then return #_w else return arr{shape(_w)} end
end

Take = function(_w,_a)
   if _a<0 then return Reverse(Take(Reverse(_w),-_a)) end
   if is_not"table"(_w) then _w={_w} end
   return set(rho(0,_a),1,min(_a,#_w),unpack(_w))
end
    
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
   local x=iota(m)
   sort(x,function(a,b) return _w[a]<_w[b] or not(_w[b]<_w[a]) and a<b end)
   return x
   end

apl.register(0,Outer,'∘','Outer')

local lib={Rotate=Rotate, Expand=Expand, Compress=Compress, Scan=Scan,
   Reduce=Reduce, Attach=Attach, Reverse=Reverse, Get=Get, Set=Set}
local f1={Copy=Copy, Disclose=Disclose, Down=Down, Enclose=Enclose, 
   MatInv=MatInv, Ravel=Ravel, Reverse1=Reverse, Reverse2=Reverse,
   Shape=Shape, Transpose=Transpose, Up=Up}
local f2={Attach1=Attach, Attach2=Attach, Compress1=Compress, 
   Compress2=Compress, Deal=Deal, Decode=Decode, Drop=Drop, Encode=Encode, 
   Expand1=Expand, Expand2=Expand, Find=Find, Has=Has, MatDiv=MatDiv, 
   Reshape=Reshape, Rotate1=Rotate, Rotate2=Rotate, Take=Take}
local op1={Each=Each,Reduce1=Reduce,Reduce2=Reduce,Scan1=Scan,Scan2=Scan}
local op2={Inner=Inner}

replace(apl.lib,lib,apl.rank0.lib)
replace(apl.f1,f1,apl.rank0.f1);
replace(apl.f2,f2,apl.rank0.f2);
apl.op1=op1;
apl.op2=op2;

local helptext = {
[Attach] = [[Attach(⍵,⍺): ⍺,⍵ → elements of ⍺ followed by elements of ⍵]];
[Compress] = [[Compress(⍵,⍺): ⍺/⍵ → copies elements of ⍵ as counted by ⍺ ]];
[Copy] = 'Copy: +⍵ returns a copy of the APL-visible part of ⍵';
[Deal] = "Deal: ⍺?⍵ → ⍺ distinct numbers randomly selected from ⍳⍵";
[Decode] = "Decode: ⍵⊤⍺ → Decompose ⍺ into base ⍵ digits";
[Down] = "Down: ⍒⍵ → the permutation that grades ⍵ downwards";
[Disclose] = [[
Disclose: ⊃⍵ makes a matrix from an array of rows. Each ⍵[i] is treated as
a vector and padded to the maximum length using zeros or empty strings.]];
[Drop] = "Drop: ⍺↓⍵ → ⍵ without its first ⍺ or last -⍺ elements";
[Each] = [[
Each(f): f¨ → make a term-by-term function from f
Each(f,x_w,x_a): (Lua mode only) Fine-tune constant arguments.
   x_w=x_a=0: the shapes of _w and _a must be compatible.
   x_w=1, x_a=1: _w,_a may be a singleton, which will be used every time.
   x_w=2, x_a=2: _w,_a is used as such every time even if it is a table.]];  
[Enclose] = "Enclose: ⊂⍵ makes an array of rows from a matrix";
[Encode] = "Encode: ⍵⊥⍺ → ⍺ considered as base ⍵ digits of result";
[Expand] = 
[[Expand(⍵,⍺): ⍺\⍵ → inserts neutral elements into ⍵ as counted by ⍺]];
[Find] = [[
Find: ⍺⍳⍵ → position of first occurrence of ⍵ in ⍺; not found is #⍺+1]];
[Get] = "Get: ⍵[⍺], see `help'Indexing'";
[Has] = "Has: ⍺∊⍵ → does ⍺ occur in ⍵?";
[MatDiv] = [[
MatDiv: ⍺⌹⍵ → minimum-norm least-squares solution to the linear system with 
  matrix ⍵ and right-hand side ⍺. Depends on _act and _rct.]];
[MatInv] = "MatInv: ⌹⍵ → Pseudo-inverse of ⍵. Depends on _act and _rct.";
[Outer] = "Outer(g): ⍺ ∘.g ⍵ → ⍵[i] g ⍺[j] for all possible pairs"; 
[Ravel] = "Ravel: ,⍵ → vector containing elements of ⍵";
[Reduce] = [[Reduce(⍵,⍺): ⍺/⍵ → copies elements of ⍵ as counted by ⍺]];
[Reverse] = [[Reverse(⍵): ⌽⍵ → elements of ⍵ in reverse order]];
[Reshape] = "Reshape: ⍺⍴⍵ → Make an array of shape ⍺ by using ⍵ cyclically";
[Rotate] = 
[[Rotate(⍵,⍺): ⍺⌽⍵ → elements of ⍵ rotated left by ⍺ or right by -⍺]];
[Scan] = [[
Scan(f): f/⍵ → ⍵[1], ⍵[1] f ⍵[2],  (⍵[1] f ⍵[2]) f ⍵[3] etc
   Last term equals Reduce(f)(⍵) for associative functions only!  ]];
[Set] = "Set: ⍵[⍺]←v, see `help'Indexing'";
[Shape] = [[
Shape: ⍴⍵ → {} if a number, {#⍵} if a vector, {rows,cols} if a matrix.
       #⍵ if a string.]];
[Take] = "Take: ⍺↑⍵ → The first ⍺ or last -⍺ elements of ⍵";
[Transpose] = 'Transpose: ⍉⍵ → matrix transpose of ⍵';
[Up] = "Up: ⍋⍵ → the permutation that grades ⍵ upwards";
}
for k,v in pairs(helptext) do help(k,v) end

          end -- vector functions

          if _APL_LEVEL>1 then --## matrix functions

local lib,f1,f2,op1=apl.lib,apl.f1,apl.f2,apl.op1

local attach,    compress,    expand,    reduce,    reverse,    rotate,    scan
= lib.Attach,lib.Compress,lib.Expand,lib.Reduce,lib.Reverse,lib.Rotate,lib.Scan
local decode,   drop,   encode,   rawformat, take
 = f2.Decode,f2.Drop,f2.Encode,f2.Format, f2.Take 
local Each = op1.Each
local Disclose,   Enclose,   Transpose =
   f1.Disclose,f1.Enclose,f1.Transpose
local Add,    Mul,    Div,    TestEq,  vecget,  vecset = 
   f2.Add, f2.Mul, f2.Div, f2.TestEq, lib.Get, lib.Set
local Outer=apl.Outer

local Attach,Attach1,Attach2, Compress1,Compress2, Expand1,Expand2, 
  Reduce1,Reduce2, Reverse1,Reverse2, Rotate,Rotate1,Rotate2, Scan1,Scan2
local Decode,Drop, Encode, Format, Get, Inner, MatDiv, MatInv, Rerank, Set, 
   SVD, Take

local concat,max,min,format = table.concat,math.max,math.min,string.format

local along=function(f,k,func)
--- If f works on a vector, along(f,k) works on a matrix along axis k
   k=k or 2
   return function(_w,_a)
      if not checktype(_w,'table',1,func).cols then return f(_w,_a)
      else return Rerank(f(Rerank(_w,-k),_a),k)
      end    
   end
end

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

--- iterator for actual indices in a submatrix
-- n: length of a row
-- i,j: selected rows and columns
local indices = function(n,i,j)
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

local inner = function(f,_w,_a)
   local m,p = shape(_a)
   local q,n = shape(_w)
   if not (p or n) then return f(_w,_a) end
   if p then _a=Rerank(_a,-1) end
   if n then _w=Rerank(_w,-2) end
   if p then 
      if n then return outer(f)(_w,_a)
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

local numrank=function(S)
   local s1,rank=S[1],0
   for k,s in ipairs(S) do
      if TestEq(s1,s1+s)==1 then break end
      rank=rank+1
   end 
   return rank
end

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

Decode = function(_w,_a)
   return both(decode,_w,_a,0,2)
end

Drop = function(_w,_a)
   if is_not"table"(_a) then return drop(_w,_a) end
   argcheck(#_a==2,2,"can't drop an array of rank "..#_a)
   local w=singleton(_w)
   if w then _w=rho(w,1,1) end
   argcheck(_w.cols,"can't drop a matrix from a vector")
   return along(drop,2)(along(drop,1)(_w,_a[1]),_a[2])
end

Encode = function(_w,_a) return inner(encode,_w,_a) end

Format = function(_w,_a, level)
   level=level or 1
   _a = _a or apl._format
   if _a=="raw" or level>2 or is"table"(_w) and level>1 then 
      return rawformat(_w) 
   end   
   _a = _a or "%.7g"
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
   local rows,cols = shape(_w)
   if is_not"table"(_a) or not cols then return vecget(_w,_a) end
   -- indexing a matrix
   local n=#_a
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

Inner = function(f,g) 
   return function(_w,_a)
      return inner(function(x,y) return reduce(f)(g(x,y)) end,_w,_a)
   end
end

MatInv = function(A)
   checktype(A,'table',1,"MatInv")
   local M=SVD(A)
   local S = M.S
   local i=iota(numrank(S))
--  +/((V[i]÷¨S[i])(∘.×)¨U[i])
   return Reduce1(Add)(Each(Outer(Mul))(M.U[i],Each(Div)(S[i],M.V[i])))
end

MatDiv = function(A,b)
   checktype(b,"table",2,"MatDiv")
   checksize(b,A,2,"MatDiv")
   return Inner(Add,Mul)(b,MatInv(A))
end

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
 
Set = function(_w,_a,v)
   checktype(_w,'table',1)
   local rows,cols = shape(_w)
   if is_not"table"(_a) or not cols then return vecset(_w,_a,v) end
   -- indexing a matrix   
   local n=#_a
   argcheck(n<=2,2,"expected two indices, got "..n)
   local i,j,submat = _a[1], _a[2], true
   if is"number"(i) then i={i}; submat=false end
   if is"number"(j) then j={j}; submat=false end
   if i==nil then i=iota(rows) end
   if j==nil then j=iota(cols) end
   if is"table"(_v) then
      local l=0
      for k in indices(cols,i,j) do l=l+1; _w[k]=v[l] end
   else for k in indices(cols,i,j) do _w[k]=v end
   end
   return v
end

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
   if is_not"table"(_a) then return take(_w,_a) end
   argcheck(#_a==2,2,"can't take an array of rank "..#_a)
   local w=singleton(_w)
   if w then _w=rho(w,1,1) end
   argcheck(_w.cols,"can't take a matrix from a vector")
   return along(take,2)(along(take,1)(_w,_a[1]),_a[2])
end

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

local helptext = {
[Attach1] = "Attach1(⍵,⍺): ⍺⍪⍵ → rows of ⍺ followed by rows of ⍵";
[Attach2] = "Attach2(⍵,⍺): ⍺,⍵ → columns of ⍺ followed by columns of ⍵";
[Compress1] = "Compress1(⍵,⍺): ⍺⌿⍵ → copies rows of ⍵ as counted by ⍺";
[Compress2] = "Compress2(⍵,⍺): ⍺/⍵ → copies columns of ⍵ as counted by ⍺";
[Expand1] = "Expand1(⍵,⍺): ⍺⍀⍵ → inserts neutral rows into ⍵ as counted by ⍺";
[Expand2] = "Expand2(⍵,⍺): ⍺\\⍵ → inserts neutral columns ⍵ as counted by ⍺";
[Reduce1] = "Reduce1(⍵,⍺): ⍺⌿⍵ → copies rows of ⍵ as counted by ⍺";
[Reduce2] = "Reduce2(⍵,⍺): ⍺/⍵ → copies columns of ⍵ as counted by ⍺";
[Reverse1] = "Reverse1(⍵): ⊖⍵ → rows of ⍵ in reverse order";
[Reverse2] = "Reverse2(⍵): ⌽⍵ → columns of ⍵ in reverse order";
[Rotate1] = 
"Rotate1(⍵,⍺): ⍺⊖⍵ → elements in columns of ⍵ rotated up by ⍺ or down by -⍺";
[Rotate2] = 
"Rotate2(⍵,⍺): ⍺⌽⍵ → elements in rows of ⍵ rotated left by ⍺ or right by -⍺";
[Scan1] = "Scan1(f): f⌿⍵ → scan over rows";
[Scan2] = "Scan2(f): f⌿⍵ → scan over columns";
}
for k,v in pairs(helptext) do help(k,v) end

local lib={Get=Get,Set=Set,Rerank=Rerank,SVD=SVD}
local f1={Down=Down, MatInv=MatInv, Ravel=Ravel, Reverse1=Reverse1, 
   Reverse2=Reverse2}
local f2={Attach1=Attach1, Attach2=Attach2, Compress1=Compress1, 
   Compress2=Compress2, Decode=Decode, Drop=Drop, Encode=Encode, 
   Expand1=Expand1, Expand2=Expand2, Format=Format, MatDiv=MatDiv, 
   Reshape=Reshape, Rotate1=Rotate1, Rotate2=Rotate2, Take=Take}
local op1={Reduce1=Reduce1,Reduce2=Reduce2,Scan1=Scan1,Scan2=Scan2}
local op2={Inner=Inner}

apl.rank1={f1={},f2={},op1={},op2={},lib={}}

replace(apl.lib,lib,apl.rank1.lib)
replace(apl.f1,f1,apl.rank1.f1);
replace(apl.f2,f2,apl.rank1.f2);
replace(apl.op1,op1,apl.rank1.op1)
replace(apl.op2,op2,apl.rank1.op2)

for class,group in pairs(apl.rank1) do -- copy over help for new function
   for k,v in pairs(group) do 
      if not help(apl[class][k],0) then help(apl[class][k],help(v,0)) end
   end
end

help(Rerank, [[
Rerank(_w,_a): array of one rank higher (_a>0) or lower (_a<0), stacking 
   rows (±1) or columns (±2). See Disclose/Enclose.]])
help(SVD, [[
SVD(A): A table with three entries containing the SVD of an m×n matrix A.
  S: min(m,n) singular values of A. 
  U: nested array of left singular vectors.
  V: nested array of right singular vectors.]])

          end -- matrix functions

          do  --## Build the compiler tables from the dictionary

local f1 = {Abs='∣', Ceil='⌈', Disclose='⊃', Enclose='⊂', Exp='⋆', Define='∇',
  Execute='⍎', Fact='!', Floor='⌊', Length='≡', Ln='⍟', Unm='−', Not='∼',
  Pi='○', Recip='÷', Roll='?', Sign='×', Copy='+', Down='⍒', MatInv='⌹',
  Pass='∘', Print='⎕', Range='⍳', Ravel=',', Reverse1='⊖', Reverse2='⌽',
  Shape='⍴', ToString='⍕', Transpose='⍉', Up='⍋'}

local f2={Add='+', And='∧', Binom='!', Circ='○', Div='÷', Log='⍟', Max='⌈', 
  Min='⌊', Mod='∣', Mul='×', Nand='⍲', Nor='⍱', Or='∨', Pow='⋆', Sub='−', 
  TestEq='=', TestGE='≥', TestGT='>', TestLE='≤', TestLT='<', TestNE='≠', 
  Attach1='⍪', Attach2=',', Compress1='⌿', Compress2='/', Deal='?', 
  Decode='⊤', Drop='↓', Encode='⊥', Expand1='⍀', Expand2='\\', Find='⍳', 
  Format='⍕', Has='∊', MatDiv='⌹', Pass='∘', Reshape='⍴', Rotate1='⊖', 
  Rotate2='⌽', Same='≡', Take='↑'}  

local op1={Each='¨',Reduce1='⌿',  Reduce2='/', Scan1='⍀', Scan2='\\'}

local op2={Inner='.'}

lua_dict = {f1=f1, f2=f2, op1=op1, op2=op2}

-- Characters looking the same (or nearly so) and considered equivalent.
local alias={['∼']='~',['∧']='^',['⋆']='*',['−']='-',['∣']='|'}

local function build(mapping,funcs,class)
   if not mapping then return end
   for LuaName,APLname in pairs(mapping) do 
      apl.register(class,funcs[LuaName],APLname,LuaName,alias[APLname])      
   end
end
build(lua_dict.f1,apl.f1,1); 
build(lua_dict.f2,apl.f2,2); 
build(lua_dict.op1,apl.op1,5); 
build(lua_dict.op2,apl.op2,6);

for k,v in pairs(apl.lib) do apl.register(0,v,'',k) end

-- Functions 

unit = {[apl.Add]=0, [apl.Mul]=1, [apl.And]=1, [apl.Or]=0,
  [apl.Min]=math.huge, [apl.Max]=-math.huge}
 
          end -- Build the compiler tables from the dictionary

          --## Finish off

if _APL_LEVEL==2 then arr_meta.__tostring = apl.Format
   else arr_meta.__tostring = apl.ToString
end
arr_meta.__lt = function(x,y)  -- lexicographic comparison
   if is_not"table"(y) then y={y} end
   for i=1,min(#x,#y) do 
     if x[i]<y[i] then return true 
     elseif y[i]<x[i] then return false
     end end
   return false
end
arr_meta.__index = apl.lib.Get
arr_meta.__newindex = apl.lib.Set

apl._act=1/bit32.lshift(1,24)^2
apl._rct=apl._act

help("APL",help(apl_dict,0))
help("NaN",[[
NaN: Not-a-Number (whose type is 'number'), result of invalid arithmetic,
   e.g. dividing 0 by 0, square-rooting a negative number, converting nil
   to a number etc. A NaN is not equal to anything, not even to itself.]])
help('Circ', [[
Circle functions. Assuming that arguments are in range:
  (¯4 0 4 ○ ⍵) = ((⍵^2-1)⋆0.5,(1-⍵^2)⋆0.5,(1+⍵^2)⋆0.5)
   (1 2 3 ○ ⍵) = (sin ⍵, cos ⍵, tan ⍵)
   (5 6 7 ○ ⍵) = (sinh ⍵, cosh ⍵, tanh ⍵)
  (⍺ ○ (-⍺) ⍵) = ⍵ ]])
help("_act","_act: absolute comparison tolerance")
help("_rct","_rct: relative comparison tolerance")
help("_format","_format: default format, 'raw' means no prettyprinting")
help("start",[[
    help(apl)         -- displays keys in table `apl`
    help"APL"         -- displays information on topic "APL"
    help"all"         -- lists topics available as `help"topic"`
    help(Func)        -- displays help on `Func`  (no quotes)
    apl:import'Func'  -- imports `Func` (comma-separated) into _ENV 
    apl:import"*"     -- imports all names not starting with `_` into _ENV]])

print (([[
%s (Lua code) © Dirk Laurie 2013
Bug reports are welcome. You'll find me on Lua-L.
If you can't remember the README, do this:
  help'start']]):format(_VERSION))
print("In Lua mode, you will need `apl:import()` first.\n--")

          if _APL_LEVEL<3 then -- remove links to internal tables
apl.APL_ENV, apl.f1, apl.f2, apl.op1, apl.op2, apl.rank0, apl.rank1, apl.lib 
   = nil
          end

loading=false
return apl
