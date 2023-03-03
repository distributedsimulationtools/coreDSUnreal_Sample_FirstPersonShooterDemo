
require("__concatenateEntityType")

function UseEntityTypeAsUniqueIdentifier(value)
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

	newvars = CVariant:new()
	newvars['UniqueIdentifier']:set(__concatenateEntityType(value))
	return _, newvars;
end
