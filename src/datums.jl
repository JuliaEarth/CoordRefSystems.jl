# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    Datum

Parent type of all datum types.
"""
abstract type Datum end

"""
    ellipsoid(D)

Returns the ellipsoid of the datum type `D`.
"""
function ellipsoid end

"""
    epoch(D)

Returns the reference epoch of the datum type `D`.
"""
function epoch end

# ----------------
# IMPLEMENTATIONS
# ----------------

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.

# reference code: https://github.com/OSGeo/PROJ/blob/master/src/datums.cpp

"""
    NoDatum

Represents the absence of datum in a CRS.
"""
abstract type NoDatum <: Datum end

"""
    ShiftedDatum{Datum,Epoch}

Shifted `Datum` with a given `Epoch` in decimalyear.
"""
abstract type ShiftedDatum{D,Epoch} <: Datum end

ellipsoid(::Type{ShiftedDatum{D,Epoch}}) where {D,Epoch} = ellipsoid(D)

epoch(::Type{ShiftedDatum{D,Epoch}}) where {D,Epoch} = Epoch

"""
    WGS84{GPSWeek}

WGS84 (World Geodetic System) datum with a given realization `GPSWeek`.
Currently, WGS84 has realizations in the following GPS weeks:
0, 730, 873, 1150, 1674 and 1762, 2139, 2296.

See <https://epsg.org/datum_6326/World-Geodetic-System-1984-ensemble.html>
"""
abstract type WGS84{GPSWeek} <: Datum end

"""
    WGS84Latest

Alias to the latest realization in the [`WGS84`](@ref) ensemble.
"""
const WGS84Latest = WGS84{2296}

ellipsoid(::Type{<:WGS84}) = WGS84🌎

epoch(::Type{WGS84{0}}) = 1984.0
epoch(::Type{WGS84{730}}) = 1994.0
epoch(::Type{WGS84{873}}) = 1997.0
epoch(::Type{WGS84{1150}}) = 2001.0
epoch(::Type{WGS84{1674}}) = 2005.0
epoch(::Type{WGS84{1762}}) = 2005.0
epoch(::Type{WGS84{2139}}) = 2016.0
epoch(::Type{WGS84{2296}}) = 2020.0

"""
    ITRF{Year}

ITRF (International Terrestrial Reference Frame) datum with a given `Year`.
Currently, ITRF has realizations in the following years:
1991, 1992, 1993, 1994, 1996, 1997, 2000, 2005, 2008, 2014 and 2020.

See <https://www.iers.org/IERS/EN/DataProducts/ITRF/itrf.html>
"""
abstract type ITRF{Year} <: Datum end

"""
    ITRFLatest

Alias to the latest realization in the [`ITRF`](@ref) ensemble.
"""
const ITRFLatest = ITRF{2020}

ellipsoid(::Type{<:ITRF}) = GRS80🌎

epoch(::Type{ITRF{1991}}) = 1988.0
epoch(::Type{ITRF{1992}}) = 1988.0
epoch(::Type{ITRF{1993}}) = 1988.0
epoch(::Type{ITRF{1994}}) = 1993.0
epoch(::Type{ITRF{1996}}) = 1997.0
epoch(::Type{ITRF{1997}}) = 1997.0
epoch(::Type{ITRF{2000}}) = 1997.0
epoch(::Type{ITRF{2005}}) = 2000.0
epoch(::Type{ITRF{2008}}) = 2005.0
epoch(::Type{ITRF{2014}}) = 2010.0
epoch(::Type{ITRF{2020}}) = 2015.0

"""
    Aratu

Aratu datum.
"""
abstract type Aratu <: Datum end

ellipsoid(::Type{Aratu}) = Intl🌎

"""
    Carthage

Carthage 1934 Tunisia datum.
"""
abstract type Carthage <: Datum end

ellipsoid(::Type{Carthage}) = Clrk80IGN🌎

"""
    ETRS89

European Terrestrial Reference System 1989.

See <https://epsg.org/datum_6258/European-Terrestrial-Reference-System-1989-ensemble.html>
"""
abstract type ETRS89 <: Datum end

ellipsoid(::Type{ETRS89}) = GRS80🌎

"""
    GGRS87

Greek Geodetic Reference System 1987 datum.
"""
abstract type GGRS87 <: Datum end

ellipsoid(::Type{GGRS87}) = GRS80🌎

"""
    GRS80S

GRS 1980 Authalic Sphere datum.
"""
abstract type GRS80S <: Datum end

ellipsoid(::Type{GRS80S}) = GRS80S🌎

"""
    Hermannskogel

Hermannskogel datum.
"""
abstract type Hermannskogel <: Datum end

ellipsoid(::Type{Hermannskogel}) = Bessel🌎

"""
    IGS20

IGS20 datum.
"""
abstract type IGS20 <: Datum end

ellipsoid(::Type{IGS20}) = GRS80🌎

"""
    Ire65

Ireland 1965 datum.
"""
abstract type Ire65 <: Datum end

ellipsoid(::Type{Ire65}) = ModAiry🌎

"""
    IRENET95

Ireland 1995 datum.
"""
abstract type IRENET95 <: Datum end

ellipsoid(::Type{IRENET95}) = GRS80🌎

"""
    NAD83

North American Datum 1983.
"""
abstract type NAD83 <: Datum end

ellipsoid(::Type{NAD83}) = GRS80🌎

"""
    NAD83CSRS

NAD83 Canadian Spatial Reference System.

See <https://epsg.org/datum_6140/NAD83-Canadian-Spatial-Reference-System.html>
"""
abstract type NAD83CSRS <: Datum end

ellipsoid(::Type{NAD83CSRS}) = GRS80🌎

"""
    NAD83CSRSv1

North American Datum of 1983 (CSRS96).

See <https://epsg.org/datum_1192/North-American-Datum-of-1983-CSRS96.html>
"""
abstract type NAD83CSRSv1 <: Datum end

ellipsoid(::Type{NAD83CSRSv1}) = GRS80🌎

"""
    NAD83CSRSv2

North American Datum of 1983 (CSRS) version 2.

See <https://epsg.org/datum_1193/North-American-Datum-of-1983-CSRS-version-2.html>
"""
abstract type NAD83CSRSv2 <: Datum end

ellipsoid(::Type{NAD83CSRSv2}) = GRS80🌎

epoch(::Type{NAD83CSRSv2}) = 1997.0

"""
    NAD83CSRSv3

North American Datum of 1983 (CSRS) version 3.

See <https://epsg.org/datum_1194/North-American-Datum-of-1983-CSRS-version-3.html>
"""
abstract type NAD83CSRSv3 <: Datum end

ellipsoid(::Type{NAD83CSRSv3}) = GRS80🌎

epoch(::Type{NAD83CSRSv3}) = 1997.0

"""
    NAD83CSRSv4

North American Datum of 1983 (CSRS) version 4.

See <https://epsg.org/datum_1195/North-American-Datum-of-1983-CSRS-version-4.html>
"""
abstract type NAD83CSRSv4 <: Datum end

ellipsoid(::Type{NAD83CSRSv4}) = GRS80🌎

epoch(::Type{NAD83CSRSv4}) = 2002.0

"""
    NAD83CSRSv5

North American Datum of 1983 (CSRS) version 5.

See <https://epsg.org/datum_1196/North-American-Datum-of-1983-CSRS-version-5.html>
"""
abstract type NAD83CSRSv5 <: Datum end

ellipsoid(::Type{NAD83CSRSv5}) = GRS80🌎

epoch(::Type{NAD83CSRSv5}) = 2006.0

"""
    NAD83CSRSv6

North American Datum of 1983 (CSRS) version 6.

See <https://epsg.org/datum_1197/North-American-Datum-of-1983-CSRS-version-6.html>
"""
abstract type NAD83CSRSv6 <: Datum end

ellipsoid(::Type{NAD83CSRSv6}) = GRS80🌎

epoch(::Type{NAD83CSRSv6}) = 2010.0

"""
    NAD83CSRSv7

North American Datum of 1983 (CSRS) version 7.

See <https://epsg.org/datum_1198/North-American-Datum-of-1983-CSRS-version-7.html>
"""
abstract type NAD83CSRSv7 <: Datum end

ellipsoid(::Type{NAD83CSRSv7}) = GRS80🌎

epoch(::Type{NAD83CSRSv7}) = 2010.0

"""
    NAD83CSRSv8

North American Datum of 1983 (CSRS) version 8.

See <https://epsg.org/datum_1365/North-American-Datum-of-1983-CSRS-version-8.html>
"""
abstract type NAD83CSRSv8 <: Datum end

ellipsoid(::Type{NAD83CSRSv8}) = GRS80🌎

epoch(::Type{NAD83CSRSv8}) = 2010.0

"""
    Nzgd49

New Zealand Geodetic Datum 1949.
"""
abstract type NZGD1949 <: Datum end

ellipsoid(::Type{NZGD1949}) = Intl🌎

"""
    OSGB36

Airy 1830 datum.
"""
abstract type OSGB36 <: Datum end

ellipsoid(::Type{OSGB36}) = Airy🌎

"""
    Potsdam

Potsdam Rauenberg 1950 DHDN datum.
"""
abstract type Potsdam <: Datum end

ellipsoid(::Type{Potsdam}) = Bessel🌎

"""
    SAD69

South American Datum 1969.

See <https://epsg.org/datum_6618/South-American-Datum-1969.html>
"""
abstract type SAD69 <: Datum end

ellipsoid(::Type{SAD69}) = GRS67Modified🌎

"""
    SAD96

South American Datum 1969(96).

See <https://epsg.org/datum_1075/South-American-Datum-1969-96.html>
"""
abstract type SAD96 <: Datum end

ellipsoid(::Type{SAD96}) = GRS67Modified🌎

"""
    SIRGAS2000

Sistema de Referencia Geocentrico para las AmericaS 2000.

See <https://epsg.org/datum_6674/Sistema-de-Referencia-Geocentrico-para-las-AmericaS-2000.html>
"""
abstract type SIRGAS2000 <: Datum end

ellipsoid(::Type{SIRGAS2000}) = GRS80🌎
