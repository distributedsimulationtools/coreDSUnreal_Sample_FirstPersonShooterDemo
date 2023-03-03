require("ReferenceLatLongAlt")
angleConversions = require("angleConversions")
require("ecef2lla")

function convertPositionFromDISToUnreal(value)

	-- Since we are working over a fairly small part of the planet, we can assume a flat surface
	a, b, c = EcefToEnu(value['LocationInWorldCoordinates.X']:toFloat(), value['LocationInWorldCoordinates.Y']:toFloat(), value['LocationInWorldCoordinates.Z']:toFloat(), referenceOffset_Lat , referenceOffset_Long , referenceOffset_Alt )

	--convert geocentric to lat/long
	lat, long, alt = ecef2lla(value['LocationInWorldCoordinates.X']:toFloat(), value['LocationInWorldCoordinates.Y']:toFloat(), value['LocationInWorldCoordinates.Z']:toFloat())

	lat = 0.0174532925 * lat  -- convert to radian
	long = 0.0174532925 * long  -- convert to radian

	yaw = angleConversions.getOrientationFromEuler(lat, long, value['Orientation.Psi']:toFloat(), value['Orientation.Theta']:toFloat())
	pitch = angleConversions.getPitchFromEuler(lat, long, value['Orientation.Psi']:toFloat(), value['Orientation.Theta']:toFloat())
	roll = angleConversions.getRollFromEuler(lat, long, value['Orientation.Psi']:toFloat(), value['Orientation.Theta']:toFloat(), value['Orientation.Phi']:toFloat())

	value['Orientation.Psi']:set(roll)
	value['Orientation.Theta']:set(pitch)
	value['Orientation.Phi']:set(yaw)

	--scale back from meter to cm
	value['LocationInWorldCoordinates.X']:set(b/100)
	value['LocationInWorldCoordinates.Y']:set(a/100)
	value['LocationInWorldCoordinates.Z']:set(c/100)

end