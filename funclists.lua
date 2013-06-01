local forward = [[
-- numeric monadic functions
-- these functions generalize term-by-term to any array
local Abs, Ceil, Exp, Fact, Floor, Ln, Neg, Not, Pi, Recip, Roll, Sign
-- numeric dyadic functions
-- these functions generalize term-by-term to arrays of the same shape or
--   when one operand is a singleton
local Add, And, Binom, Circ, Div, Log, Max, Min, Mod, Mul, Nand, Nor, 
   Or, Pow, Sub, TestEq, TestGE, TestGT, TestLE, TestLT, TestNE 
-- one-of-a-kind monadic functions
local Clone, Down, MatInv, Pass, Range, Ravel, Reverse, Reverse1, Shape, 
   Squish, Transpose, Up   
-- one-of-a kind dyadic functions
local Attach, Attach1, Compress, Compress1, Deal, Decode, Drop, Encode, 
   Expand, Expand1, Find, Format, Has, Index, MatDiv, Reshape, Rotate, 
   Rotate1, Same, Take, Unsquish 
-- monadic operators 
local Each, Outer, Reduce, Reduce1, Scan, Scan1
-- dyadic operators
local Inner
-- end of forward declarations
]]

local groups="num1, num2, gen1, gen2, op1, op2"
local group={}
for k in groups:gmatch"[a-z]+[12]" do group[#group+1]=k end
local k=1
for funcs in forward:gmatch"local(.-)-" do
   io.write(group[k].."={")
   local item={}
   for func in funcs:gmatch"[A-Z][A-Za-z]+1?" do 
     item[#item+1]=func.."="..func 
   end
   io.write(table.concat(item,", ").."}\n\n")
   k=k+1
end
