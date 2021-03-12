angleConversions = require("angleConversions")
require("ecef2lla")
require("ReferenceLatLongAlt")

function convertPositionFromHLA()

--convert geocentric to lat/long
lat, long, alt = ecef2lla(DSimLocal.WorldLocation.X ,DSimLocal.WorldLocation.Y , DSimLocal.WorldLocation.Z)

lat = 0.0174532925 * lat  -- convert to radian
long = 0.0174532925 * long  -- convert to radian

yaw = angleConversions.getOrientationFromEuler(lat, long, DSimLocal.Orientation.Psi, DSimLocal.Orientation.Theta)
pitch = angleConversions.getPitchFromEuler(lat, long, DSimLocal.Orientation.Psi, DSimLocal.Orientation.Theta)
roll = angleConversions.getRollFromEuler(lat, long, DSimLocal.Orientation.Psi, DSimLocal.Orientation.Theta, DSimLocal.Orientation.Phi)


DSimLocal.Orientation.Psi  =  roll
DSimLocal.Orientation.Theta = pitch
DSimLocal.Orientation.Phi = yaw

-- Since we are working over a fairly small part of the planet, we can assume a flat surface
--convert lat/long to geocentric
DSimLocal.WorldLocation.Y, DSimLocal.WorldLocation.X, DSimLocal.WorldLocation.Z = EcefToEnu(DSimLocal.WorldLocation.X, DSimLocal.WorldLocation.Y, DSimLocal.WorldLocation.Z, referenceOffset_Lat , referenceOffset_Long , referenceOffset_Alt )

--scale back from meter to cm
DSimLocal.WorldLocation.X = DSimLocal.WorldLocation.X * 100;
DSimLocal.WorldLocation.Y = DSimLocal.WorldLocation.Y * 100;
DSimLocal.WorldLocation.Z = DSimLocal.WorldLocation.Z * 100;

end