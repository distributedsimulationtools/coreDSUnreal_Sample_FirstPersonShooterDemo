angleConversions = require("angleConversions")
require("ecef2lla")

function convertOrientationFromDIS()
--convert geocentric to lat/long
lat, long, alt = ecef2lla(lastPositionX ,lastPositionY , lastPositionZ)

lat = 0.0174532925 * lat  -- convert to radian
long = 0.0174532925 * long  -- convert to radian

yaw = angleConversions.getOrientationFromEuler(lat, long, DSimLocal.Psi, DSimLocal.Theta)
pitch = angleConversions.getPitchFromEuler(lat, long, DSimLocal.Psi, DSimLocal.Theta)
roll = angleConversions.getRollFromEuler(lat, long, DSimLocal.Psi, DSimLocal.Theta, DSimLocal.Phi)


DSimLocal.Psi  =  roll
DSimLocal.Theta = pitch
DSimLocal.Phi = yaw

end