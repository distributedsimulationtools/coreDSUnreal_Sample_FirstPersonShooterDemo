require("__concatenateEntityType")

function startswith(text, prefix)
    return text:find(prefix, 1, true) == 1
end

function FilterGun (value)
	-- Keeps the entity types starting with 3.1 (life forms), discards everything else

	local entitykind = __concatenateEntityType(value)

	if(startswith(entitykind, "3.1.") ~= true) then
		discardUpdate()
	end
end