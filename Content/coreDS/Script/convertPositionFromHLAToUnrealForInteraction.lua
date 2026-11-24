require("ecef2lla")
require("ReferenceLatLongAlt")

function convertPositionFromHLAToUnrealForInteraction(value)
	-- Since we are working over a fairly small part of the planet, we can assume a flat surface
	-- Geocentric to local ENU
	tempEast, tempNorth, tempUp = EcefToEnu(value['X']:toDouble(), value['Y']:toDouble(), value['Z']:toDouble(), referenceOffset_Lat , referenceOffset_Long , referenceOffset_Alt)

	-- Unreal X is north and Y is east, meters to Unreal centimeters
	value['X']:set(tempNorth * 100);
	value['Y']:set(tempEast * 100);
	value['Z']:set(tempUp * 100);
end
