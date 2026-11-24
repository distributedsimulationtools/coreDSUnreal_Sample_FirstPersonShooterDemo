require("__concatenateEntityType")

function startswith(text, prefix)
    return text:find(prefix, 1, true) == 1
end

function FilterBullet (value)
	-- Keeps the entity types starting with 2.1 (munitions), discards everything else

	local entitykind = __concatenateEntityType(value)

	if(startswith(entitykind, "2.1.") ~= true) then
		discardUpdate()
	end
end