-- apl-compiler.lua  (c) Dirk Laurie 2013  Lua-style MIT licence
-- Adds the ability to translate APL code to the `apl-lib` module,
-- plus a few extra functions.

-------- requirements

local apl=require"apl-lib"
local help=apl.help
local lpeg=require"lpeg"
local C,     P,     R,     S,     V,     Cmt,     Cp = 
 lpeg.C,lpeg.P,lpeg.R,lpeg.S,lpeg.V,lpeg.Cmt,lpeg.Cp

local util = apl.util
local argcheck,      checktype,      is,      is_not =
 util.argcheck, util.checktype, util.is, util.is_not
local concat=table.concat
-- This is kept in while the program is under development

local loading=true
local logfile=util.logfile
local where=util.where

local meta_ENV=getmetatable(_ENV)
setmetatable(_ENV,{__newindex = function (ENV,name,value)
logfile:write(where(2),"Assigning _ENV.",name,"\n")
--   if name:match"^%a%d?$" then logfile.write(where(2),
--      "A global name like '",name,"' is asking for trouble.\n")
--   end
   rawset(ENV,name,value)
end})


-------- utilities

local utflen = function(s)
   return #s:gsub("[\xC0-\xEF][\x80-\xBF]*",'.')
end

-------- APL compiler

local load_apl
local apl_meta = {__call = function(apl,code) return load_apl(code) end }
setmetatable(apl,apl_meta)

local Monadic_functions, Monadic_operators, Dyadic_functions, 
   Dyadic_operators = {},{},{},{}
local _V = setmetatable({},{__index=_ENV})
local APL_ENV = {_V=_V}
local apl_dict = {}

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
local utc = R"\x80\xBF"              -- UTF-8 continuation byte
local utf2 = R"\xC0\xDF"*utc         -- 2-byte codepoint
local utf3 = R"\xE0\xEF"*utc*utc     -- 3-byte codepoint
local utf = utf2 + utf3 - P"←"-P"¯"
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
local monadic_func,    dyadic_func,    amphiadic_func 
  = V"monadic_func", V"dyadic_func", V"amphiadic_func"

local apl_expr = P{ "statement";
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
   dyadic_func = amphiadic_func + Dyadic_function;
   monadic_func = amphiadic_func + Monadic_function;
   func_expr = '('*(dyadic_func+Monadic_function)*')'/1 
     + Dyadic_function + Monadic_function;
   amphiadic_func = func_expr*Monadic_operator/"%2(%1)"
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

local classname={[1]="monadic function", [2]="dyadic function",
   [5]="monadic operator", [6]="dyadic operator"}
local classes={[1]=Monadic_functions, [2]=Dyadic_functions, [3]='either',
   [5]=Monadic_operators, [6]=Dyadic_operators, [7]='either'}
 
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
   local class=classes[code]
   argcheck(class,1,"Must be 1,2,3,5,6 or 7")
   if class=='either' then 
      for k=1,2 do register(code-k,fct,APLname,LuaName,alias,helptext) end
      return
   end
   local cname=classname[code]
   checktype(APLname,'string',3)
   checktype(LuaName,'string',4)
   logfile:write(LuaName,": ",cname," '", APLname,"'")
   if alias then checktype(alias,'string',5) end
   if helptext then checktype(helptext,'string',6) end
   checktype(fct,'function',2) 

   argcheck(not APL_ENV[LuaName] or APL_ENV[LuaName]==fct,2,
      "name '"..LuaName.."' already in use in APL runtime environment")
   argcheck(not class[APLname],2,"name '"..APLname..
      "' already in use as "..cname)
   if alias then 
       argcheck(not class[alias],4,"name '"..alias..
      "' already in use as "..cname)
       argcheck(alias~=APLname,4,"name '"..alias..
      "' is the same as the APL name")
   end

   if alias then logfile:write(" or '",alias,"'") end
   logfile:write((" (%s)\n"):format(tostring(fct)))  

   class[APLname]=LuaName
   apl_dict[APLname]=LuaName
   if alias then class[alias]=LuaName end
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

-- Grant temporary access to axis-specific APL functions (not in apl-lib)

apl_meta.__index = apl._F

---- Definition of the Lua⋆APL function-to-symbol mapping interface ----

local f1 = {Abs='∣', Ceil='⌈', Disclose='⊃', Enclose='⊂', Exp='⋆', Fact='!', 
  Floor='⌊', Format='⍕', Ln='⍟', Unm='−', Not='∼', Pi='○', Recip='÷', 
  Roll='?', Sign='×', Copy='+', Down='⍒', MatInv='⌹', Pass='∘', Range='⍳', 
  Ravel=',', Reverse2='⌽', Reverse1='⊖', Shape='⍴', Transpose='⍉', Up='⍋'}

local f2={Add='+', And='∧', Binom='!', Circ='○', Div='÷', Log='⍟', Max='⌈', 
  Min='⌊', Mod='∣', Mul='×', Nand='⍲', Nor='⍱', Or='∨', Pow='⋆', Sub='−', 
  TestEq='=', TestGE='≥', TestGT='>', TestLE='≤', TestLT='<', TestNE='≠', 
  Attach2=',', Attach1='⍪', Compress2='/', Compress1='⌿', Deal='?', 
  Decode='⊤', Drop='↓', Encode='⊥', Expand2='\\', Expand1='⍀', Find='⍳', 
  Format='⍕', Has='∊', MatDiv='⌹', Pass='∘', Reshape='⍴', Rotate2='⌽', 
  Rotate1='⊖', Same='≡', Take='↑'}  

local op1={Each='¨', Reduce2='/', Reduce1='⌿', Scan2='\\', Scan1='⍀'}

local op2={Inner='.'}

-- Characters looking the same (or nearly so) and considered equivalent.
local alias={['∼']='~',['∧']='^',['⋆']='*',['−']='-',['∣']='|'}

-------- Build the compiler tables for functions and operators ----

local apl = require"apl-lib"
local function build(mapping,class)
   for LuaName,APLname in pairs(mapping) do 
      register(class,apl[LuaName],APLname,LuaName,alias[APLname])      
   end
end

build(f1,1); build(f2,2); build(op1,5); build(op2,6);

-- Terminal I/O
-- local prompt = {[0]='?',[1]='(lua)?', [2]='(APL)?'}

local Print = function(_w) print(_w); return _w end
help(Print,[[Output: ⎕⍵ prints ⍵ and returns ⍵]])

-- Assignment

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
APL_ENV.Assign = Assign
help(Assign, "Assign: ⍵←⍺ → assign ⍺ to ⍵, see User's Manual")

-------- Add the new functions

apl.lua = lua_code
apl.register = register
-- apl.Assign = Assign

local import = apl.import
apl.import = function(apl,...)
   if ... then import(apl,...)
   else
      _ENV.help = apl.help
      _ENV.lua = apl.lua
   end
end

local Define = function(_w)
   if is"function"(_w) then return _w end
   return load_apl(checktype(_w,"string",'⍵','Define'))
end
help(Define,[[
Define: ∇s returns APL code 's' compiled as a Lua function
        ∇f returns a function as-is]])

local Execute = function(_w) return load_apl(_w)() end
help(Execute,"Execute: ⍎⍵ → Define(⍵)()")

register(1,Define,'∇','Define')
register(1,Execute,'⍎','Execute')
register(1,Print,'⎕','Output')

local _F=apl._F
apl.help = function(topic,...)
   if topic=='APL' then help(apl_dict); return end
   local h={}
   for i=1,7 do 
      local t=classes[i]
      if is"table"(t) then
         local n=t[topic]
         if n then 
            n=n:match"[^12]+"
            local f=apl[n]
            if not f then error(('`%s` maps to a non-existent function'):
               format(n))
            end
            h[#h+1]=help(f,0)       
         end 
      end
   end
   if #h>0 then print(concat(h,'\n')) else help(topic,...) end 
end         

-- clean up

apl._F = nil
apl_meta.__index = nil  -- deny Lua access to axis-1 functions
loading=false

return apl   
