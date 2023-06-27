require("__concatenateEntityType")

function startswith(text, prefix)
    return text:find(prefix, 1, true) == 1
end

function FilterAllExceptBulletAndGun (value)
	-- if Platform of type Munition
	
	entitykind = __concatenateEntityType(value)
	
	if((startswith(entitykind, "2.1.") == true) or (startswith(entitykind, "3.1.") == true)) then
		return true
	end
end