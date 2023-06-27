angleConversions = require("angleConversions")
require("ecef2lla")

function convertOrientationFromUnrealToDIS(value)

--convert geocentric to lat/long
lat, lon, alt = ecef2lla(lastPositionX ,lastPositionY , lastPositionZ)

lat = math.rad(lat)
lon = math.rad(lon)

local roll = value['Psi']:toFloat() -- heading
local pitch = value['Theta']:toFloat() --pitch
local yaw = value['Phi']:toFloat() --roll


value['Theta']:set(angleConversions.getThetaFromTaitBryanAngles(lat, lon, yaw, pitch));
value['Phi']:set(angleConversions.getPhiFromTaitBryanAngles(lat, lon, yaw, pitch, roll))
value['Psi']:set(angleConversions.getPsiFromTaitBryanAngles(lat, lon, yaw, pitch)) 

end