require("ReferenceLatLongAlt")

function convertUnrealPositionToHLAForInteraction ()

-- Since we are working over a fairly small part of the planet, we can assume a flat surface
--convert lat/long to geocentric
DSimLocal.X, DSimLocal.Y, DSimLocal.Z = EnuToEcef(DSimLocal.X, DSimLocal.Y, DSimLocal.Z, referenceOffset_Lat , referenceOffset_Long , referenceOffset_Alt )

--scale back from meter to cm
DSimLocal.X = DSimLocal.X * 100;
DSimLocal.Y = DSimLocal.Y * 100;
DSimLocal.Z = DSimLocal.Z * 100;
end