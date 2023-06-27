require("ReferenceLatLongAlt")

lastPositionX = 0
lastPositionY = 0
lastPositionZ = 0

function convertUnrealPositionToDIS(value)

	lastPositionX = value['X']:toFloat();
	lastPositionY = value['Y']:toFloat();
	lastPositionZ = value['Z']:toFloat();

	-- Since we are working over a fairly small part of the planet, we can assume a flat surface
	--convert lat/long to geocentric
	a, b, c = EnuToEcef(lastPositionY*100, lastPositionX*100, lastPositionZ * 100, referenceOffset_Lat , referenceOffset_Long , referenceOffset_Alt )

	value['X']:set(a)
	value['Y']:set(b)
	value['Z']:set(c)
	
	lastPositionX = a
	lastPositionY = b
	lastPositionZ = c

end