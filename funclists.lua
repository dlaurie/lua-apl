local source = io.open'apl-lib.lua':read'*a'
local forward=source:match"-- scalar1: .*forward declarations"

for group,funcs in forward:gmatch"([a-z].-):.-local(.-)-" do
   io.write(group.."={")
   local item={}
   for func in funcs:gmatch"[A-Z][A-Za-z]+1?" do 
      item[#item+1]=func.."="..func
   end 
   io.write(table.concat(item,", ").."}\n\n")
end
