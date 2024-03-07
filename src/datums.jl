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
    latitudeₒ(D)

Returns the latitude origin of the datum type `D`.
"""
function latitudeₒ end

"""
    longitudeₒ(D)

Returns the longitude origin of the datum type `D`.
"""
function longitudeₒ end

"""
    altitudeₒ(D)

Returns the altitude origin of the datum type `D`.
"""
function altitudeₒ end

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

ellipsoid(::Type{NoDatum}) = nothing
latitudeₒ(::Type{NoDatum}) = nothing
longitudeₒ(::Type{NoDatum}) = nothing
altitudeₒ(::Type{NoDatum}) = nothing
epoch(::Type{NoDatum}) = nothing

"""
    WGS84{GPSWeek}

WGS84 (World Geodetic System) datum with a given realization `GPSWeek` (default to 1762).
Currentry, WGS84 has six realizations in the following GPS weeks:
0, 730, 873, 1150, 1674 and 1762.

`WGS84Latest` is an alias to `WGS84{2020}`.

See [NGA - WORLD GEODETIC SYSTEM 1984](https://nsgreg.nga.mil/doc/view?i=4085)
"""
abstract type WGS84{GPSWeek} <: Datum end

const WGS84Latest = WGS84{1762}

ellipsoid(::Type{<:WGS84}) = WGS84🌎
latitudeₒ(::Type{<:WGS84}) = 0.0u"°"
longitudeₒ(::Type{<:WGS84}) = 0.0u"°"
altitudeₒ(::Type{<:WGS84}) = 0.0u"m"

epoch(::Type{WGS84{0}}) = nothing
epoch(::Type{WGS84{730}}) = 1994.0
epoch(::Type{WGS84{873}}) = 1997.0
epoch(::Type{WGS84{1150}}) = 2001.0
epoch(::Type{WGS84{1674}}) = 2005.0
epoch(::Type{WGS84{1762}}) = 2005.0

"""
    ITRF{Year}

ITRF (International Terrestrial Reference Frame) datum with a given realization `Year` (default to 2020).
Currentry, ITRF has eleven realizations in the following years:
1991, 1992, 1993, 1994, 1996, 1997, 2000, 2005, 2008, 2014 and 2020.

`ITRFLatest` is an alias to `ITRF{2020}`.

See [The International Terrestrial Reference Frame (ITRF)](https://www.iers.org/IERS/EN/DataProducts/ITRF/itrf.html)
"""
abstract type ITRF{Year} <: Datum end

const ITRFLatest = ITRF{2020}

ellipsoid(::Type{<:ITRF}) = GRS80🌎
latitudeₒ(::Type{<:ITRF}) = 0.0u"°"
longitudeₒ(::Type{<:ITRF}) = 0.0u"°"
altitudeₒ(::Type{<:ITRF}) = 0.0u"m"

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
    GGRS87

Greek Geodetic Reference System 1987 datum.
"""
abstract type GGRS87 <: Datum end

ellipsoid(::Type{GGRS87}) = GRS80🌎
latitudeₒ(::Type{GGRS87}) = 0.0u"°"
longitudeₒ(::Type{GGRS87}) = 0.0u"°"
altitudeₒ(::Type{GGRS87}) = 0.0u"m"
epoch(::Type{GGRS87}) = nothing

"""
    NAD27

North American Datum 1927.
"""
abstract type NAD27 <: Datum end

ellipsoid(::Type{NAD27}) = Clrk66🌎
latitudeₒ(::Type{NAD27}) = 0.0u"°"
longitudeₒ(::Type{NAD27}) = 0.0u"°"
altitudeₒ(::Type{NAD27}) = 0.0u"m"
epoch(::Type{NAD27}) = nothing

"""
    NAD83

North American Datum 1983.
"""
abstract type NAD83 <: Datum end

ellipsoid(::Type{NAD83}) = GRS80🌎
latitudeₒ(::Type{NAD83}) = 0.0u"°"
longitudeₒ(::Type{NAD83}) = 0.0u"°"
altitudeₒ(::Type{NAD83}) = 0.0u"m"
epoch(::Type{NAD83}) = nothing

"""
    Potsdam

Potsdam Rauenberg 1950 DHDN datum.
"""
abstract type Potsdam <: Datum end

ellipsoid(::Type{Potsdam}) = Bessel🌎
latitudeₒ(::Type{Potsdam}) = 0.0u"°"
longitudeₒ(::Type{Potsdam}) = 0.0u"°"
altitudeₒ(::Type{Potsdam}) = 0.0u"m"
epoch(::Type{Potsdam}) = nothing

"""
    Carthage

Carthage 1934 Tunisia datum.
"""
abstract type Carthage <: Datum end

ellipsoid(::Type{Carthage}) = Clrk80IGN🌎
latitudeₒ(::Type{Carthage}) = 0.0u"°"
longitudeₒ(::Type{Carthage}) = 0.0u"°"
altitudeₒ(::Type{Carthage}) = 0.0u"m"
epoch(::Type{Carthage}) = nothing

"""
    Hermannskogel

Hermannskogel datum.
"""
abstract type Hermannskogel <: Datum end

ellipsoid(::Type{Hermannskogel}) = Bessel🌎
latitudeₒ(::Type{Hermannskogel}) = 0.0u"°"
longitudeₒ(::Type{Hermannskogel}) = 0.0u"°"
altitudeₒ(::Type{Hermannskogel}) = 0.0u"m"
epoch(::Type{Hermannskogel}) = nothing

"""
    Ire65

Ireland 1965 datum.
"""
abstract type Ire65 <: Datum end

ellipsoid(::Type{Ire65}) = ModAiry🌎
latitudeₒ(::Type{Ire65}) = 0.0u"°"
longitudeₒ(::Type{Ire65}) = 0.0u"°"
altitudeₒ(::Type{Ire65}) = 0.0u"m"
epoch(::Type{Ire65}) = nothing

"""
    Nzgd49

New Zealand Geodetic Datum 1949.
"""
abstract type NZGD1949 <: Datum end

ellipsoid(::Type{NZGD1949}) = Intl🌎
latitudeₒ(::Type{NZGD1949}) = 0.0u"°"
longitudeₒ(::Type{NZGD1949}) = 0.0u"°"
altitudeₒ(::Type{NZGD1949}) = 0.0u"m"
epoch(::Type{NZGD1949}) = nothing

"""
    OSGB36

Airy 1830 datum.
"""
abstract type OSGB36 <: Datum end

ellipsoid(::Type{OSGB36}) = Airy🌎
latitudeₒ(::Type{OSGB36}) = 0.0u"°"
longitudeₒ(::Type{OSGB36}) = 0.0u"°"
altitudeₒ(::Type{OSGB36}) = 0.0u"m"
epoch(::Type{OSGB36}) = nothing
