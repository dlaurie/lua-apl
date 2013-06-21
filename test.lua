apl=require"apl-compiler"
apl:import()
idiom = require "finnaplidiom"

local char = string.char
local function Str(x,y)
   if type(x)=='table' then return char(unpack(x)) else return char(x) end
end
apl.register(1,Str,'§','Str')

tests = [[
2 3⍴¨5 4
j←⍒A←?10⍴100
A[j]
A,0↑A[5]←-5
n←(0,⍳10)!10
f←n⍪?n
⊂f
⊖f
⊖⊂f
1 2 3○○÷6 1 4
○÷¯1 ¯2 ¯3○⎕1 2 3○○÷6 1 4
(∘1)⍕∘1
§32+⍳94
⍟¯1,0○1.4
0 1∘.∨0 1
0 1∘.∧0 1
0 1∘.⍱0 1
0 1∘.⍲0 1
10|(⍳9)∘.+⍳9
'raw'⍕10|(⍳9)∘.+⍳9
'%d'⍕10⊥10|(⍳9)∘.+⍳9
10 10⊤10|(⍳9)∘.+⍳9
10|(⍳9)∘.×⍳9
10|(⍳9)∘.-⍳9
10|(⍳9)∘.<⍳9
10|(⍳9)∘.≤⍳9
10|(⍳9)∘.=⍳9
10|(⍳9)∘.>⍳9
10|(⍳9)∘.≠⍳9
10|(⍳9)∘.⌈⍳9
10|(⍳9)∘.⌊⍳9
10|(⍳9)∘.|⍳9
⌈(⍳9)∘.÷⍳9
⌊(⍳9)∘.÷⍳9
1 2 3=1 3⍴1 2 3
1 2 3≡1 3⍴1 2 3
(⍳3)⌹3 4⍴⍳12
(⍳4)⌹⍉3 4⍴⍳12
+/(⍳10)⋆2
⌽+\(⍳10)⋆2
]]

aplchars = [[! + , . / < = > ? \ § ¨ × ÷ ↑ ↓ ∇ ∊ − ∘ ∣ ∧ ∨ ∼ ≠ ≡ ≤ ≥ ⊂ ⊃ ⊖ ⊤ ⊥ ⋆ ⌈ ⌊ ⌹ ⌽ ⌿ ⍀ ⍉ ⍋ ⍎ ⍒ ⍕ ⍟ ⍪ ⍱ ⍲ ⍳ ⍴ ⎕ ○]]
apl_tally = {}
lua_tally = {}
apl_omitted, lua_omitted = {},{}
for k in aplchars:gmatch"%S+" do apl_omitted[k]=true end
for k in pairs(apl) do lua_omitted[k]=true end

function occurs(S,k)
   local c,j,i=-1,0
   repeat i,j = S:find(k,j+1,true); c=c+1 until not j   
   return c
end   

print""
for S in tests:gmatch"[^\n]+" do
   if S:match"%S" then
      f=apl(S) 
      print('   '..S..' → '..lua(f)); print(tostring(f()))
      for k in aplchars:gmatch"%S+" do
         local c=occurs(S,k)
         if c>0 then             
            apl_tally[k] = (apl_tally[k] or 0) + c
            apl_omitted[k] = nil
         end
      end 
      for k in pairs(apl) do
         c=occurs(lua(f),k)
         if c>0 and not (',.'):find(k) then             
            lua_tally[k] = (lua_tally[k] or 0) + c
            lua_omitted[k] = nil
         end
      end
   end
end

t={}
for k,v in pairs(apl) do if lua_tally[k] then
   t[k..":"..(lua_tally[k] or 0)]=true 
end end
print "\nTally of Lua functions tested"
help(t)

print "\nThe following Lua functions are not represented"
help(lua_omitted)

t={}
for k in aplchars:gmatch"%S+" do if apl_tally[k] then
    t[k..":"..(apl_tally[k] or 0)]=true 
end end
print "\nTally of APL functions tested"
help(t) 

print "\nThe following APL functions are not represented"
help(apl_omitted)

