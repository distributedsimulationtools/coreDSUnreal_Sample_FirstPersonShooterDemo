angleConversions = require("angleConversions")
require("ecef2lla")
require("ReferenceLatLongAlt")

function convertPositionFromHLAToUnreal(value)
	-- Since we are working over a fairly small part of the planet, we can assume a flat surface
	a, b, c = EcefToEnu(value['WorldLocation.X']:toFloat(), value['WorldLocation.Y']:toFloat(), value['WorldLocation.Z']:toFloat(), referenceOffset_Lat , referenceOffset_Long , referenceOffset_Alt )

	--convert geocentric to lat/long
	lat, long, alt = ecef2lla(value['WorldLocation.X']:toFloat(), value['WorldLocation.Y']:toFloat(), value['WorldLocation.Z']:toFloat())

	lat = 0.0174532925 * lat  -- convert to radian
	long = 0.0174532925 * long  -- convert to radian

	yaw = angleConversions.getOrientationFromEuler(lat, long, value['Orientation.Psi']:toFloat(), value['Orientation.Theta']:toFloat())
	pitch = angleConversions.getPitchFromEuler(lat, long, value['Orientation.Psi']:toFloat(), value['Orientation.Theta']:toFloat())
	roll = angleConversions.getRollFromEuler(lat, long, value['Orientation.Psi']:toFloat(), value['Orientation.Theta']:toFloat(), value['Orientation.Phi']:toFloat())

	value['Orientation.Psi']:set(roll)
	value['Orientation.Theta']:set(pitch)
	value['Orientation.Phi']:set(yaw)

	--scale back from meter to cm
	value['WorldLocation.X']:set(b/100)
	value['WorldLocation.Y']:set(a/100)
	value['WorldLocation.Z']:set(c/100)

end