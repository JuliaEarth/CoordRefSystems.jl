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

"""
    ShiftedDatum{Datum,Epoch}

Shifted `Datum` with a given `Epoch` in decimalyear.
"""
abstract type ShiftedDatum{D,Epoch} <: Datum end

ellipsoid(::Type{ShiftedDatum{D,Epoch}}) where {D,Epoch} = ellipsoid(D)

epoch(::Type{ShiftedDatum{D,Epoch}}) where {D,Epoch} = Epoch

"""
    CoordRefSystems.shift(Datum, epoch)

Shifts the `Datum` with a given `epoch` in decimalyear.
"""
shift(D::Type{<:Datum}, epoch) = ShiftedDatum{D,epoch}

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
    ETRF{Year}

ETRF (European Terrestrial Reference Frame) datum with a given `Year`.
Each ETRF is a realization of the European Terrestrial Reference System 89 (ETRS89) ensemble.
Currently, ETRF has realizations in the following years:
1989, 1990, 1991, 1992, 1993, 1994, 1996, 1997, 2000, 2005, 2014 and 2020.

See <http://etrs89.ensg.ign.fr/>
"""
abstract type ETRF{Year} <: Datum end

"""
    ETRFLatest

Alias to the latest realization of [`ETRF`](@ref) in the ETRS89 ensemble.
"""
const ETRFLatest = ETRF{2020}

ellipsoid(::Type{<:ETRF}) = GRS80🌎

epoch(::Type{ETRF{1989}}) = 1989.0
epoch(::Type{ETRF{1990}}) = 1989.0
epoch(::Type{ETRF{1991}}) = 1989.0
epoch(::Type{ETRF{1992}}) = 1989.0
epoch(::Type{ETRF{1993}}) = 1989.0
epoch(::Type{ETRF{1994}}) = 1989.0
epoch(::Type{ETRF{1996}}) = 1989.0
epoch(::Type{ETRF{1997}}) = 1989.0
epoch(::Type{ETRF{2000}}) = 1989.0
epoch(::Type{ETRF{2005}}) = 2000.0
epoch(::Type{ETRF{2014}}) = 2010.0
epoch(::Type{ETRF{2020}}) = 2015.0

"""
    NAD83CSRS{Version}

North American Datum of 1983 (CSRS) version `Version`.

Currently, NAD83CSRS has the following versions: 1, 2, 3, 4, 5, 6, 7 and 8.
"""
abstract type NAD83CSRS{Version} <: Datum end

"""
    NAD83CSRSLatest

Alias to the latest version of the [`NAD83CSRS`](@ref) datum.
"""
const NAD83CSRSLatest = NAD83CSRS{8}

ellipsoid(::Type{<:NAD83CSRS}) = GRS80🌎

epoch(::Type{NAD83CSRS{2}}) = 1997.0
epoch(::Type{NAD83CSRS{3}}) = 1997.0
epoch(::Type{NAD83CSRS{4}}) = 2002.0
epoch(::Type{NAD83CSRS{5}}) = 2006.0
epoch(::Type{NAD83CSRS{6}}) = 2010.0
epoch(::Type{NAD83CSRS{7}}) = 2010.0
epoch(::Type{NAD83CSRS{8}}) = 2010.0

"""
    Aratu

Aratu datum.
"""
abstract type Aratu <: Datum end

ellipsoid(::Type{Aratu}) = Intl🌎

"""
    BD72

Reseau National Belge 1972.

See <https://epsg.org/datum_6313/Reseau-National-Belge-1972.html>
"""
abstract type BD72 <: Datum end

ellipsoid(::Type{BD72}) = Intl🌎

"""
    Carthage

Carthage 1934 Tunisia datum.
"""
abstract type Carthage <: Datum end

ellipsoid(::Type{Carthage}) = Clrk80IGN🌎

"""
    Datum73

Datum 73 from Portugal.

See <https://epsg.org/datum_6274/Datum-73.html>
"""
abstract type Datum73 <: Datum end

ellipsoid(::Type{Datum73}) = Intl🌎

"""
    DHDN

Deutsches Hauptdreiecksnetz datum.

See <https://epsg.org/datum_6314/Deutsches-Hauptdreiecksnetz.html>
"""
abstract type DHDN <: Datum end

ellipsoid(::Type{DHDN}) = Bessel🌎

"""
    ED50

European Datum 1950.

See <https://epsg.org/datum_6230/European-Datum-1950.html>
"""
abstract type ED50 <: Datum end

ellipsoid(::Type{ED50}) = Intl🌎

"""
    ED79

European Datum 1979.

See <https://epsg.org/datum_6668/European-Datum-1979.html>
"""
abstract type ED79 <: Datum end

ellipsoid(::Type{ED79}) = Intl🌎

"""
    ED87

European Datum 1987.

See <https://epsg.org/datum_6231/European-Datum-1987.html>
"""
abstract type ED87 <: Datum end

ellipsoid(::Type{ED87}) = Intl🌎

"""
    GDA94

Geocentric datum of Australia 1994.

See <https://epsg.org/datum_6283/Geocentric-Datum-of-Australia-1994.html>
"""
const GDA94 = shift(ITRF{1992}, 1994.0)

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
    ISN93

Islands Net 1993 datum.

See <https://epsg.org/datum_6659/Islands-Net-1993.html>
"""
abstract type ISN93 <: Datum end

ellipsoid(::Type{ISN93}) = GRS80🌎

"""
    ISN2004

Islands Net 2004 datum.

See <https://epsg.org/datum_1060/Islands-Net-2004.html>
"""
abstract type ISN2004 <: Datum end

ellipsoid(::Type{ISN2004}) = GRS80🌎

"""
    ISN2016

Islands Net 2016 datum.

See <https://epsg.org/datum_1187/Islands-Net-2016.html>
"""
abstract type ISN2016 <: Datum end

ellipsoid(::Type{ISN2016}) = GRS80🌎

"""
    Lisbon1890

Lisbon 1890 datum.

See <https://epsg.org/datum_6666/Lisbon-1890.html>
"""
abstract type Lisbon1890 <: Datum end

ellipsoid(::Type{Lisbon1890}) = Bessel🌎

"""
    Lisbon1937

Lisbon 1937 datum.

See <https://epsg.org/datum_6207/Lisbon-1937.html>
"""
abstract type Lisbon1937 <: Datum end

ellipsoid(::Type{Lisbon1937}) = Intl🌎

"""
    NAD27

North American Datum 1927.

See <https://epsg.org/datum_6267/North-American-Datum-1927.html>.
"""
abstract type NAD27 <: Datum end

ellipsoid(::Type{NAD27}) = Clrk66🌎

"""
    NAD83

North American Datum 1983.

See <https://epsg.org/datum_6269/North-American-Datum-1983.html>
"""
abstract type NAD83 <: Datum end

ellipsoid(::Type{NAD83}) = GRS80🌎

"""
    NTF

Nouvelle Triangulation Francaise.

See <https://epsg.org/datum_6275/Nouvelle-Triangulation-Francaise.html>
"""
abstract type NTF <: Datum end

ellipsoid(::Type{NTF}) = Clrk80IGN🌎

"""
    Nzgd49

New Zealand Geodetic Datum 1949.
"""
abstract type NZGD1949 <: Datum end

ellipsoid(::Type{NZGD1949}) = Intl🌎

"""
    NZGD2000

New Zealand Geodetic Datum 2000.
"""
abstract type NZGD2000 <: Datum end

ellipsoid(::Type{NZGD2000}) = GRS80🌎

"""
    OSGB36

Ordnance Survey of Great Britain 1936 datum.

See <https://epsg.org/datum_6277/Ordnance-Survey-of-Great-Britain-1936.html>
"""
abstract type OSGB36 <: Datum end

ellipsoid(::Type{OSGB36}) = Airy🌎

"""
    PD83

Potsdam Datum/83.

See <https://epsg.org/datum_6746/Potsdam-Datum-83.html>
"""
abstract type PD83 <: Datum end

ellipsoid(::Type{PD83}) = Bessel🌎

"""
    Potsdam

Potsdam Rauenberg 1950 DHDN datum.
"""
abstract type Potsdam <: Datum end

ellipsoid(::Type{Potsdam}) = Bessel🌎

"""
    RD83

Rauenberg Datum/83.

See <https://epsg.org/datum_6745/Rauenberg-Datum-83.html>
"""
abstract type RD83 <: Datum end

ellipsoid(::Type{RD83}) = Bessel🌎

"""
    RGF93v1

Reseau Geodesique Francais 1993 version 1.

See <https://epsg.org/datum_6171/Reseau-Geodesique-Francais-1993-v1.html>
"""
abstract type RGF93v1 <: Datum end

ellipsoid(::Type{RGF93v1}) = GRS80🌎

"""
    RGF93v2

Reseau Geodesique Francais 1993 version 2.

See <https://epsg.org/datum_1312/Reseau-Geodesique-Francais-1993-v2.html>
"""
abstract type RGF93v2 <: Datum end

ellipsoid(::Type{RGF93v2}) = GRS80🌎

"""
    RGF93v2b

Reseau Geodesique Francais 1993 version 2b.

See <https://epsg.org/datum_1313/Reseau-Geodesique-Francais-1993-v2b.html>
"""
abstract type RGF93v2b <: Datum end

ellipsoid(::Type{RGF93v2b}) = GRS80🌎

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
