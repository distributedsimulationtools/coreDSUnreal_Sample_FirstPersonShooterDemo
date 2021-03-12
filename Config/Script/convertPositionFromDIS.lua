require("ReferenceLatLongAlt")

lastPositionX = 0
lastPositionY = 0
lastPositionZ = 0

function convertPositionFromDIS()

lastPositionX = DSimLocal.X
lastPositionY = DSimLocal.Y
lastPositionZ = DSimLocal.Z

-- Since we are working over a fairly small part of the planet, we can assume a flat surface
--convert lat/long to geocentric
DSimLocal.Y, DSimLocal.X, DSimLocal.Z = EcefToEnu(DSimLocal.X, DSimLocal.Y, DSimLocal.Z, referenceOffset_Lat , referenceOffset_Long , referenceOffset_Alt )

--scale back from meter to cm
DSimLocal.X = DSimLocal.X * 100;
DSimLocal.Y = DSimLocal.Y * 100;
DSimLocal.Z = DSimLocal.Z * 100;

end