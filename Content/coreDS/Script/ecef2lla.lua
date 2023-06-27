--ECEF2GEODETIC Convert geocentric (ECEF) to geodetic coordinates
--
--   [PHI, LAMBDA, H] = ECEF2GEODETIC(X, Y, Z) converts point
--   locations in geocentric Cartesian coordinates, stored in the
--   coordinate arrays X, Y, Z, to geodetic coordinates PHI (geodetic
--   latitude in radians), LAMBDA (longitude in radians), and H (height
--   above the ellipsoid). The geodetic coordinates refer to the
--   reference ellipsoid specified by ELLIPSOID (a row vector with the
--   form [semimajor axis, eccentricity]). X, Y, and Z must use the same
--   units as the semimajor axis;  H will also be expressed in these
--   units.  X, Y, and Z must have the same shape; PHI, LAMBDA, and H
--   will have this shape also.
--
--   For a definition of the geocentric system, also known as
--   Earth-Centered, Earth-Fixed (ECEF), see the help for GEODETIC2ECEF.
--
--   See also ECEF2LV, GEODETIC2ECEF, GEOCENTRIC2GEODETICLAT, LV2ECEF.

-- Copyright 2005-2009 The MathWorks, Inc.
-- $Revision: 1.1.6.4 $  $Date: 2009/04/15 23:34:43 $

-- Reference
----
-- Paul R. Wolf and Bon A. Dewitt, "Elements of Photogrammetry with
-- Applications in GIS," 3rd Ed., McGraw-Hill, 2000 (Appendix F-3).

-- Implementation Notes from Rob Comer
-- -----------------------------------
-- The implementation below follows Wolf and DeWitt quite literally,
-- with a few important exceptions required to ensure good numerical
-- behavior:
--
-- 1) I used ATAN2 rather than ATAN in the formulas for beta and phi.  This
--    avoids division by zero (or a very small number) for points on (or
--    near) the Z-axis.
--
-- 2) Likewise, I used ATAN2 instead of ATAN when computing beta from phi
--    (conversion from geodetic to parametric latitude), ensuring
--    stability even for points at very high latitudes.
--
-- 3) Finally, I avoided dividing by cos(phi) -- also problematic at high
--    latitudes -- in the calculation of h, the height above the ellipsoid.
--    Wold and Dewitt give
--
--                   h = sqrt(X^2 + Y^2)/cos(phi) - N.
--
--    The trick is to notice an alternative formula that involves division
--    by sin(phi) instead of cos(phi), then take a linear combination of the
--    two formulas weighted by cos(phi)^2 and sin(phi)^2, respectively. This
--    eliminates all divisions and, because of the identity cos(phi)^2 +
--    sin(phi)^2 = 1 and the fact that both formulas give the same h, the
--    linear combination is also equal to h.
--
--    To obtain the alternative formula, we simply rearrange
--
--                   Z = [N(1 - e^2) + h]sin(phi)
--    into
--                   h = Z/sin(phi) - N(1 - e^2).
--
--    The linear combination is thus
--
--        h = (sqrt(X^2 + Y^2)/cos(phi) - N) cos^2(phi)
--            + (Z/sin(phi) - N(1 - e^2))sin^2(phi)
--
--    which simplifies to
--
--      h = sqrt(X^2 + Y^2)cos(phi) + Zsin(phi) - N(1 - e^2sin^2(phi)).
--
--    From here it's not hard to verify that along the Z-axis we have
--    h = Z - b and in the equatorial plane we have h = sqrt(X^2 + Y^2) - a.

function ecef2lla(x, y, z)
  -- flattening
local f  = 1.0/298.257223563;
--equatorial radius
local R =  6378137.0;
-- Ellipsoid constants
local a  = R;       --Semimajor axis
local e2 = 1.0 - ( 1.0 - f )^2 ;   -- Square of first eccentricity
local ep2 = e2 / (1.0 - e2);     -- Square of second eccentricity
--f = 1.0 - math.sqrt(1.0 - e2);    -- Flattening
local b = a * (1.0 - f);         -- Semiminor axis

-- Longitude
local lambda = math.atan2(y,x);

-- Distance from Z-axis
local rho = math.sqrt(math.abs(x)^2 + math.abs(y)^2);

-- Bowring's formula for initial parametric (beta) and geodetic (phi) latitudes
local beta = math.atan2(z, (1.0 - f) * rho);
local phi = math.atan2(z   + b * ep2 * math.sin(beta)^3,rho - a * e2  * math.cos(beta)^3);

-- Fixed-point iteration with Bowring's formula
-- (typically converges within two or three iterations)
local betaNew = math.atan2((1.0 - f)*math.sin(phi), math.cos(phi));
local count = 0;
 while (math.abs(beta - betaNew) > 10e-6 and count < 10) do
  beta = betaNew;
  phi = math.atan2(z + b * ep2 * math.sin(beta)^3,rho - a * e2  * math.cos(beta)^3);
  betaNew = math.atan2((1 - f)*math.sin(phi), math.cos(phi));
  count = count + 1;
end

-- Calculate ellipsoidal height from the final value for latitude
local sinphi = math.sin(phi);
local N = a / math.sqrt(1.0 - e2 * sinphi^2);
local h = rho * math.cos(phi) + (z + e2 * N * sinphi) * sinphi - N;

--local h = rho * math.cos(phi) + z*sinphi - N*(1-e2*sinphi^2);
-- Transformation from radians to degrees
phi = math.deg(phi);
lambda = math.deg(lambda);

return phi,lambda,h;
end