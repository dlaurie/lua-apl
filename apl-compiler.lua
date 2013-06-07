-- apl-compiler.lua  (c) Dirk Laurie 2013  Lua-style MIT licence

-- Adds the ability to translate APL code to the `apl-lib` module.

-------- requirements

local apl=require"apl-lib"
local help=apl.help
local lpeg=require"lpeg"
local C,     P,     R,     S,     V,     Cmt,     Cp = 
 lpeg.C,lpeg.P,lpeg.R,lpeg.S,lpeg.V,lpeg.Cmt,lpeg.Cp

local util = apl.util
local argcheck,      checktype,      is,      is_not =
 util.argcheck, util.checktype, util.is, util.is_not

-- This is kept in while the program is under development

local loading=true
local logfile = util.logfile

local meta_ENV=getmetatable(_ENV)
setmetatable(_ENV,{__newindex = function (ENV,name,value)
   if name:match"^%a%d?$" then logfile.write(where(2),
      "A global name like '",name,"' is asking for trouble.\n")
   end
   rawset(ENV,name,value)
end})

-------- utilities

local utflen = function(s)
   return #s:gsub("[\xC0-\xEF][\x80-\xBF]*",'.')
end

-------- APL compiler

local monadic_functions, monadic_operators, dyadic_functions, 
   dyadic_operators = {},{},{},{}
local _V = setmetatable({},{__index=_ENV})
local APL_ENV = {_V=_V}

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

local first = R"az"+R"AZ"+"_"
local later = first+R"09"
local utc = R"\x80\xBF"              -- UTF-8 continuation byte
local utf2 = R"\xC0\xDF"*utc         -- 2-byte codepoint
local utf3 = R"\xE0\xEF"*utc*utc     -- 3-byte codepoint
local utf = utf2 + utf3 - P"←"-P"¯"
local neutral = R"\x21\x7E"-later-S"()[;]"  
local name = first*later^0 + utf + neutral

local monadic_function = _s^0*Cmt(name,lookup(monadic_functions))*_s^0
local monadic_operator = _s^0*Cmt(name,lookup(monadic_operators))*_s^0
local dyadic_function = _s^0*Cmt(name,lookup(dyadic_functions))*_s^0
local dyadic_operator = _s^0*Cmt(name,lookup(dyadic_operators))*_s^0
local operator = monadic_operator + dyadic_operator
local funcname = monadic_function + dyadic_function
local Param = _s^0*(P'⍺'/'_a' + P'⍵'/'_w')*_s^0 -- not to be looked up in _V
local Var = _s^0*C(first*later^0+utf-funcname-operator)*_s^0 - Param
local aplstr = _s^0*"'"*(1-P"'")^0*"'"*_s^0 -- non-empty

local apl_expr = P{ "statement";
   statement = (_s^0*P'←'*V"expr")/"return %1" + 
       Param/1*'←'*V"expr"/"%1=%2" +
       Param/1*"["*V"indices"*"]"*'←'*V"expr"/"%1[%2]=%3" +
       V"expr"/1;
   expr = Var*'←'*V"expr"/"Assign(%2,'%1')" +
     Var*"["*V"indices"*"]"*'←'*V"expr"/"Assign(%3,'%1',%2)" +
     V'leftarg'*V'dyadic_func'*V'expr'/"%2(%3,%1)" +
     V'monadic_func'*V'expr'/"%1(%2)" +
     V"leftarg";
   dyadic_func = dyadic_function*dyadic_operator*dyadic_function/"%2(%1,%3)" + 
      dyadic_function;
   monadic_func = dyadic_function*monadic_operator/"%2(%1)" + 
      monadic_function;
   leftarg = V"value" + '('*V"expr"*')'/1;
   value = vector/numbers + aplstr/1 +
      (Var*'['*V"indices"*']'/"%1[%2]" + Var)/"_V.%1" + 
      (Param*'['*V"indices"*']'/"%1[%2]" + Param)/1;
   index = V"expr"+_s^0/"nil";
   indices = V"index"*';'*V"index"/"{%1;%2}" + V"expr";
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
local classes={[1]=monadic_functions, [2]=dyadic_functions,
   [5]=monadic_operators,[6]=dyadic_operators}
 
local register = function (class, fct, APLname, LuaName, alias, helptext)
--- register(class, fct, APLname, LuaName, alias, help)
-- Register a function or operator.
--   class: number of arguments, add 4 for an operator
--   fct: the function itself
--   APLname: the preferred APL name
--   LuaName: the Lua name
--   alias: an alternative APL name (optional)
--   help: help text accessible via the function itself 
   local cname=classname[class]
   class=classes[class]
   argcheck(class,1,"Must be 1,2,5 or 6")
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
   if alias then class[alias]=LuaName end
   APL_ENV[LuaName]=fct
   apl[LuaName]=fct
   if helptext then help(fct,helptext) end
end

local preamble=[[local _w,_a=... 
]]

local load_apl = function(_w)
   checktype(_w,'string',1)
   if _w:match"^@" then return APL_ENV[_w:sub(2)] end
   _w = _w:gsub("⍝[^\n]*\n"," ")  -- strip off APL comments
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
   if is"function"(_w) then 
      local source = debug.getinfo(_w).source
      if source:sub(1,#preamble)==preamble then 
          source=source:sub(#preamble+1)
      end
      return source
   else return "Not a function"
   end
end

---- Definition of the Lua⋆APL function-to-symbol mapping interface ----

local f1 = {Abs='∣', Ceil='⌈', Exp='⋆', Fact='!', Floor='⌊', Format='⍕',
  Ln='⍟', Unm='−', Not='∼', Pi='○', Recip='÷', Roll='?', Sign='×', 
  Clone='+', Down='⍒', --[[MatInv='⌹',]] Pass='∘', Range='⍳', Ravel=',', 
  Reverse='⌽', Reverse1='⊖', Shape='⍴', Transpose='⍉', Up='⍋'}

local f2={Add='+', And='∧', Binom='!', Circ='○', Div='÷', Log='⍟', Max='⌈', 
  Min='⌊', Mod='∣', Mul='×', Nand='⍲', Nor='⍱', Or='∨', Pow='⋆', Sub='−', 
  TestEq='=', TestGE='≥', TestGT='>', TestLE='≤', TestLT='<', TestNE='≠', 
  Attach=',', Attach1='⍪', Compress='/', Compress1='⌿', Deal='?', 
  Decode='⊥', Drop='↓', Encode='⊤', Expand='\\', Expand1='⍀', Find='⍳', 
  Format='⍕', Has='∊', --[[MatDiv='⌹',]] Pass='∘', Rerank='⎕', 
  Reshape='⍴', Rotate='⌽', Rotate1='⊖', Same='≡', Take='↑'}

local op1={Reduce='/', Reduce1='⌿', Scan='\\', Scan1='⍀'}

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

-- Assignment

APL_ENV.Assign = function(_w,_a,ij)
   argcheck(_w,'⍵',"Can't assign nil to an APL name","Assign")  
   if is"function"(_w) then
      register(1,_w,_a,_a,nil,help(_w,0))
      register(2,_w,_a,_a,nil,help(_w,0))
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

-------- Add the new functions

apl.lua = lua_code
apl.register = register

local import = apl.import
apl.import = function(apl,...)
   if ... then import(apl,...)
   else
      _ENV.help = apl.help
      _ENV.lua = apl.lua
   end
end


register(1,load_apl,'∇','Define',nil,
  "Define: ∇s returns APL code 's' compiled as a Lua function")
register(1,function(_w) return load_apl(_w)() end,'⍎','Execute',nil,
  "Execute: ⍎⍵ → Define(⍵)()")


-- clean up

setmetatable(apl,{__call = function(apl,code) return load_apl(code) end })

setmetatable(_ENV,meta_ENV)
loading=false

apl.logfile = logfile
return apl   
