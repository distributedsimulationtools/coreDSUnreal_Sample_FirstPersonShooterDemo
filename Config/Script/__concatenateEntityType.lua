
function __concatenateEntityType(value)

	tmp = tostring(value['EntityKind']) .. "." .. tostring(value['Domain']) .. "." .. tostring(value['CountryCode'])  .. "." .. tostring(value['Category'])
	tmp = tmp .. "." .. tostring(value['Subcategory'])
	tmp = tmp .. "." .. tostring(value['Specific'])
	tmp = tmp .. "." .. tostring(value['Extra'])

	return tmp
end
