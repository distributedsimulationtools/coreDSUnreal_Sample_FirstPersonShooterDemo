angleConversions = require("angleConversions")
require("ecef2lla")

function convertOrientationToDIS()
--convert geocentric to lat/long
lat, lon, alt = ecef2lla(lastPositionX ,lastPositionY , lastPositionZ)

lat = math.rad(lat)
lon = math.rad(lon)

local roll = DSimLocal.Psi
local pitch = DSimLocal.Theta
local yaw = DSimLocal.Phi

DSimLocal.Theta = (angleConversions.getThetaFromTaitBryanAngles(lat, lon, yaw, pitch));
DSimLocal.Phi = (angleConversions.getPhiFromTaitBryanAngles(lat, lon, yaw, pitch, roll))
DSimLocal.Psi =  (angleConversions.getPsiFromTaitBryanAngles(lat, lon, yaw, pitch)) 

end