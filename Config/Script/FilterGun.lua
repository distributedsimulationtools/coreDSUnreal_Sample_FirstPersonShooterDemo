require("__concatenateEntityType")

function startswith(text, prefix)
    return text:find(prefix, 1, true) == 1
end

function FilterGun (value)
	-- if Plateform of type munition
	
	entitykind = __concatenateEntityType(value)
		
	if(startswith(entitykind, "3.1.") ~= true) then
		return true
	end
end