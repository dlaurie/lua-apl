apl=require"apl"
apl()
idiom = require "finnaplidiom"

tests = [[
2 3⍴¨5 4
A←⍒⍳10
A,0↑A[5]←-5
n←(0,⍳10)!10
f←n⍪?n
⌻f
⊖f
⊖⌻f
1 2 3○○÷6 1 4
○÷¯1 ¯2 ¯3○1 2 3○○÷6 1 4
(∘1)⍕∘1
2⌻32+⍳94
⍟¯1,0○1.4
0 1∘.∨0 1
0 1∘.∧0 1
0 1∘.⍱0 1
0 1∘.⍲0 1
10|(⍳9)∘.+⍳9
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
]]

apl_tally = {}
lua_tally = {}
omitted = {}
for k in pairs(apl) do omitted[k]=true end

function occurs(S,k)
   local c,j,i=-1,0
   repeat i,j = S:find(k,j+1,true); c=c+1 until not j   
   return c
end   

print""
for S in tests:gmatch"[^\n]+" do
   if S:match"%S" then
      f=∇(S) 
      print('   '..S,lua(f)); print(tostring(f()))
      for k in pairs(apl) do
         local c=occurs(S,k)
         if c>0 then             
            apl_tally[k] = (apl_tally[k] or 0) + c
            omitted[k] = nil
         end 
         c=occurs(lua(f):sub(4),k)
         if c>0 and not (',.'):find(k) then             
            lua_tally[k] = (lua_tally[k] or 0) + c
            omitted[k] = nil
         end
      end
   end
end

print [[

     Tally of APL functions tested
     -----------------------------
       APL     Lua]]
for k,v in pairs(apl) do if apl_tally[k] or lua_tally[k] then
   print(k,apl_tally[k] or 0,lua_tally[k] or 0) 
end end

print "\nThe following APL functions are not represented"
help(omitted)

