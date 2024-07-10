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

WGS84 (World Geodetic System) datum with a given realization `GPSWeek` (default to 1762).
Currently, WGS84 has six realizations in the following GPS weeks:
0, 730, 873, 1150, 1674 and 1762.

`WGS84Latest` is an alias to `WGS84{1762}`.

See [NGA - WORLD GEODETIC SYSTEM 1984](https://nsgreg.nga.mil/doc/view?i=4085)
"""
abstract type WGS84{GPSWeek} <: Datum end

@doc (@doc WGS84) const WGS84Latest = WGS84{1762}

ellipsoid(::Type{<:WGS84}) = WGS84🌎

epoch(::Type{WGS84{0}}) = 1984.0
epoch(::Type{WGS84{730}}) = 1994.0
epoch(::Type{WGS84{873}}) = 1997.0
epoch(::Type{WGS84{1150}}) = 2001.0
epoch(::Type{WGS84{1674}}) = 2005.0
epoch(::Type{WGS84{1762}}) = 2005.0

"""
    ITRF{Year}

ITRF (International Terrestrial Reference Frame) datum with a given realization `Year` (default to 2020).
Currently, ITRF has eleven realizations in the following years:
1991, 1992, 1993, 1994, 1996, 1997, 2000, 2005, 2008, 2014 and 2020.

`ITRFLatest` is an alias to `ITRF{2020}`.

See [The International Terrestrial Reference Frame (ITRF)](https://www.iers.org/IERS/EN/DataProducts/ITRF/itrf.html)
"""
abstract type ITRF{Year} <: Datum end

@doc (@doc ITRF) const ITRFLatest = ITRF{2020}

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
    AmericaS2000

Sistema de Referencia Geocentrico para las AmericaS 2000
"""
abstract type AmericaS2000 <: Datum end

ellipsoid(::Type{AmericaS2000}) = GRS80🌎

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
    Chua

Chua datum.
"""
abstract type Chua <: Datum end

ellipsoid(::Type{Chua}) = Intl🌎

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
    NAD83

North American Datum 1983.
"""
abstract type NAD83 <: Datum end

ellipsoid(::Type{NAD83}) = GRS80🌎

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
