function __concatenateEntityType(DSimLocal)
	-- Available variables
	-- DSimLocal.Category
	-- DSimLocal.CountryCode
	-- DSimLocal.Domain.Category
	-- DSimLocal.Domain.CountryCode
	-- DSimLocal.Domain.DomainDiscriminant
	-- DSimLocal.EntityKind
	-- DSimLocal.Extra
	-- DSimLocal.On Data Received
	-- DSimLocal.Specific
	-- DSimLocal.Subcategory

	tmp = DSimLocal.EntityKind

	if DSimLocal.Domain then
		if  DSimLocal.Domain.DomainDiscriminant then
			tmp = tmp .. "." .. DSimLocal.Domain.DomainDiscriminant
		else
			tmp = tmp .. "." .. DSimLocal.Domain
		end
		if (DSimLocal.Domain.CountryCode) then
			tmp = tmp .. "." .. DSimLocal.Domain.CountryCode
		else
			tmp = tmp .. "." .. DSimLocal.CountryCode
		end
		
		if (DSimLocal.Domain.Category) then
			tmp = tmp .. "." .. DSimLocal.Domain.Category
		else
			tmp = tmp .. "." .. DSimLocal.Category
		end
	end
		
	tmp = tmp .. "." .. DSimLocal.Subcategory
	tmp = tmp .. "." .. DSimLocal.Specific
	tmp = tmp .. "." .. DSimLocal.Extra

	return tmp
end
