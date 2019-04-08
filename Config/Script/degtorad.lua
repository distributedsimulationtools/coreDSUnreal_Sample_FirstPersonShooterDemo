function func ()
 for k,v in pairs(DSimLocal) do
 
if "table" ~= type( v ) then
	DSimLocal[k] = tostring(0.0174532925 * v)
end
 end
 end