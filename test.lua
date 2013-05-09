require"apl"()
idiom = require "finnaplidiom"

--[==[
print "    The Lua⋆APL module"; print''
help(apl)

tests = [[
2 4 6 8 + 100
5 6 7 8 - 1 2 3 4
×¯3 0 5
×/3 4 5
÷⍳5
+\÷⍳5
1 1 0 0∨1 0 1 0
1 1 0 0∧1 0 1 0
1 1 0 0⍱1 0 1 0
1 1 0 0⍲1 0 1 0
~1 1 0 0∧1 0 1 0
⌽⍳5
2⌽⍳9
¯2⌽⍳9
x←⌷3 1 4 1 5 9 2 6 5 3 5 8 9 7 9 3
(5↓x),¯10↑¯5↑x
(0,⍳9)∊x
(0,⍳9)⍳x
2⍟x*2
x≥5
⍋x
1 2 3,4 5
⍴1 2 3⍪4 5 6
1 2 3○○÷6
10⊥?9⍴9
10⊥9?9
⍴1 2 3∘.+4 5
⌊/0↑3 4 5
10 1 9⌊4 5 6
(2⋆⍳10)⌈100
13|1e13
(0,⍳10)!10
]]
for S in tests:gmatch"[^\n]+" do
  f=∇(S); print(S..' → '..tostring(f())); print('',lua(f)); print''
end
]==]

X=⍎"?20⍴26"; Y=⍎"?20⍴26"; print('X=',X); print('Y=',Y)
for k=1,idiom.maxn do if idiom[k] and idiom[k].arguments=='X←A1; Y←A1' then
   local utf=idiom[k].utf
print("Idiom "..k..": "..utf.."\n→ ",⍎(utf))
end end
