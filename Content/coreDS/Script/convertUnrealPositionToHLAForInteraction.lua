require("ecef2lla")
require("ReferenceLatLongAlt")

function convertUnrealPositionToHLAForInteraction (value)

	-- Since we are working over a fairly small part of the planet, we can assume a flat surface
	-- Unreal centimeters to meters, Unreal Y is east and X is north, then local ENU to geocentric
	tempX, tempY, tempZ = EnuToEcef(value['Y']:toDouble()/100, value['X']:toDouble()/100, value['Z']:toDouble()/100, referenceOffset_Lat , referenceOffset_Long , referenceOffset_Alt )

	value['X']:set(tempX);
	value['Y']:set(tempY);
	value['Z']:set(tempZ);

end
