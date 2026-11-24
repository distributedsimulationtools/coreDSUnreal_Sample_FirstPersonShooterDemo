require("__concatenateEntityType")

function startswith(text, prefix)
    return text:find(prefix, 1, true) == 1
end

function FilterAllExceptBulletAndGun (value)
	-- Discards the entity types starting with 2.1 (munitions) or 3.1 (life forms), keeps everything else

	local entitykind = __concatenateEntityType(value)

	if((startswith(entitykind, "2.1.") == true) or (startswith(entitykind, "3.1.") == true)) then
		discardUpdate()
	end
end