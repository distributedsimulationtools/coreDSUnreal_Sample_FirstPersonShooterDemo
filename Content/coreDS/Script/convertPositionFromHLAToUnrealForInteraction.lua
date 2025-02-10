require("ecef2lla")
require("ReferenceLatLongAlt")

function convertPositionFromHLAToUnrealForInteraction(value)
	-- Since we are working over a fairly small part of the planet, we can assume a flat surface
	--convert lat/long to geocentric
	tempX, tempY, tempZ = EcefToEnu(value['X']:toDouble(), value['Y']:toDouble(), value['Z']:toDouble(), referenceOffset_Lat , referenceOffset_Long , referenceOffset_Alt)

	--scale back from meter to cm
	value['X']:set(tempX * 100);
	value['Y']:set(tempY * 100);
	value['Z']:set(tempZ * 100);
end
