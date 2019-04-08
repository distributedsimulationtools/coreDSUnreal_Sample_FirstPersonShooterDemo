function decode(t)
   local tbl = {}
  for i=1,#t do
    if (t[i]~="0") then
      table.insert(tbl, string.char(t[i]))
    end
  end
  return table.concat(tbl)
end

function FilterByMarking()

local decoded = decode(DSimLocal.MarkingData);
if (decoded ~= "2") then
  DeleteValues = 1
else
  --print("Value accepted")
end
--print("'" .. decode(DSimLocal.MarkingData) .. "'")

end