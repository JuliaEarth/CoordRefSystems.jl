# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    RevolutionEllipsoid

Parent type of all revolution ellipsoids.
"""
abstract type RevolutionEllipsoid <: AbstractManifold{ℝ} end

# ManifoldsBase.jl interface
manifold_dimension(::Type{<:RevolutionEllipsoid}) = 2
representation_size(::Type{<:RevolutionEllipsoid}) = (3,)

"""
    ellipsoidparams(E)

Parameters of the ellipsoid type `E`.
"""
function ellipsoidparams end

"""
    majoraxis(E)

Semi-major axis of the ellipsoid type `E`.
"""
majoraxis(E::Type{<:RevolutionEllipsoid}) = ellipsoidparams(E).a

"""
    minoraxis(E)

Semi-minor axis of the ellipsoid type `E`.
"""
minoraxis(E::Type{<:RevolutionEllipsoid}) = ellipsoidparams(E).b

"""
    eccentricity(E)

Eccentricity of the ellipsoid type `E`.
"""
eccentricity(E::Type{<:RevolutionEllipsoid}) = ellipsoidparams(E).e

"""
    eccentricity²(E)

Eccentricity squared of the ellipsoid type `E`.
"""
eccentricity²(E::Type{<:RevolutionEllipsoid}) = ellipsoidparams(E).e²

"""
    flattening(E)

Flattening of the ellipsoid type `E`.
"""
flattening(E::Type{<:RevolutionEllipsoid}) = ellipsoidparams(E).f

"""
    flattening⁻¹(E)

Inverse flattening of the ellipsoid type `E`.
"""
flattening⁻¹(E::Type{<:RevolutionEllipsoid}) = ellipsoidparams(E).f⁻¹

# ----------------
# IMPLEMENTATIONS
# ----------------

# Adapted from PROJ coordinate transformation software
# Initial PROJ 4.3 public domain code was put as Frank Warmerdam as copyright
# holder, but he didn't mean to imply he did the work. Essentially all work was
# done by Gerald Evenden.

# reference code: https://github.com/OSGeo/PROJ/blob/master/src/ellps.cpp

"""
  Airy🌎

Airy 1830 ellipsoid.
"""
abstract type Airy🌎 <: RevolutionEllipsoid end

const _Airy = ellipfromaf⁻¹(6377563.396u"m", 299.3249646)

ellipsoidparams(::Type{Airy🌎}) = _Airy

"""
  Andrae🌎

Andrae 1876 (Den., Iclnd.) ellipsoid.
"""
abstract type Andrae🌎 <: RevolutionEllipsoid end

const _Andrae = ellipfromaf⁻¹(6377104.43u"m", 300.0)

ellipsoidparams(::Type{Andrae🌎}) = _Andrae

"""
  APL🌎

Appl. Physics. 1965 ellipsoid.
"""
abstract type APL🌎 <: RevolutionEllipsoid end

const _APL = ellipfromaf⁻¹(6378137.0u"m", 298.25)

ellipsoidparams(::Type{APL🌎}) = _APL

"""
  AustSA🌎

Australian Natl & S. Amer. 1969 ellipsoid.
"""
abstract type AustSA🌎 <: RevolutionEllipsoid end

const _AustSA = ellipfromaf⁻¹(6378160.0u"m", 298.25)

ellipsoidparams(::Type{AustSA🌎}) = _AustSA

"""
  Bessel🌎

Bessel 1841 ellipsoid.
"""
abstract type Bessel🌎 <: RevolutionEllipsoid end

const _Bessel = ellipfromaf⁻¹(6377397.155u"m", 299.1528128)

ellipsoidparams(::Type{Bessel🌎}) = _Bessel

"""
  BessNam🌎

Bessel 1841 (Namibia) ellipsoid.
"""
abstract type BessNam🌎 <: RevolutionEllipsoid end

const _BessNam = ellipfromaf⁻¹(6377483.865u"m", 299.1528128)

ellipsoidparams(::Type{BessNam🌎}) = _BessNam

"""
  Clrk66🌎

Clarke 1866 ellipsoid.
"""
abstract type Clrk66🌎 <: RevolutionEllipsoid end

const _Clrk66 = ellipfromab(6378206.4u"m", 6356583.8u"m")

ellipsoidparams(::Type{Clrk66🌎}) = _Clrk66

"""
  Clrk80🌎

Clarke 1880 mod. ellipsoid.
"""
abstract type Clrk80🌎 <: RevolutionEllipsoid end

const _Clrk80 = ellipfromaf⁻¹(6378249.145u"m", 293.4663)

ellipsoidparams(::Type{Clrk80🌎}) = _Clrk80

"""
  Clrk80IGN🌎

Clarke 1880 (IGN). ellipsoid.
"""
abstract type Clrk80IGN🌎 <: RevolutionEllipsoid end

const _Clrk80IGN = ellipfromaf⁻¹(6378249.2u"m", 293.4660212936269)

ellipsoidparams(::Type{Clrk80IGN🌎}) = _Clrk80IGN

"""
  CPM🌎

Comm. des Poids et Mesures 1799 ellipsoid.
"""
abstract type CPM🌎 <: RevolutionEllipsoid end

const _CPM = ellipfromaf⁻¹(6375738.7u"m", 334.29)

ellipsoidparams(::Type{CPM🌎}) = _CPM

"""
  Danish🌎

Andrae 1876 (Denmark, Iceland) ellipsoid.
"""
abstract type Danish🌎 <: RevolutionEllipsoid end

const _Danish = ellipfromaf⁻¹(6377019.2563u"m", 300.0)

ellipsoidparams(::Type{Danish🌎}) = _Danish

"""
  Delmbr🌎

Delambre 1810 (Belgium) ellipsoid.
"""
abstract type Delmbr🌎 <: RevolutionEllipsoid end

const _Delmbr = ellipfromaf⁻¹(6376428.0u"m", 311.5)

ellipsoidparams(::Type{Delmbr🌎}) = _Delmbr

"""
  Engelis🌎

Engelis 1985 ellipsoid.
"""
abstract type Engelis🌎 <: RevolutionEllipsoid end

const _Engelis = ellipfromaf⁻¹(6378136.05u"m", 298.2566)

ellipsoidparams(::Type{Engelis🌎}) = _Engelis

"""
  Evrst30🌎

Everest 1830 ellipsoid.
"""
abstract type Evrst30🌎 <: RevolutionEllipsoid end

const _Evrst30 = ellipfromaf⁻¹(6377276.345u"m", 300.8017)

ellipsoidparams(::Type{Evrst30🌎}) = _Evrst30

"""
  Evrst48🌎

Everest 1948 ellipsoid.
"""
abstract type Evrst48🌎 <: RevolutionEllipsoid end

const _Evrst48 = ellipfromaf⁻¹(6377304.063u"m", 300.8017)

ellipsoidparams(::Type{Evrst48🌎}) = _Evrst48

"""
  Evrst56🌎

Everest 1956 ellipsoid.
"""
abstract type Evrst56🌎 <: RevolutionEllipsoid end

const _Evrst56 = ellipfromaf⁻¹(6377301.243u"m", 300.8017)

ellipsoidparams(::Type{Evrst56🌎}) = _Evrst56

"""
  Evrst69🌎

Everest 1969 ellipsoid.
"""
abstract type Evrst69🌎 <: RevolutionEllipsoid end

const _Evrst69 = ellipfromaf⁻¹(6377295.664u"m", 300.8017)

ellipsoidparams(::Type{Evrst69🌎}) = _Evrst69

"""
  EvrstSS🌎

Everest (Sabah & Sarawak) ellipsoid.
"""
abstract type EvrstSS🌎 <: RevolutionEllipsoid end

const _EvrstSS = ellipfromaf⁻¹(6377298.556u"m", 300.8017)

ellipsoidparams(::Type{EvrstSS🌎}) = _EvrstSS

"""
  Fschr60🌎

Fischer (Mercury Datum) 1960 ellipsoid.
"""
abstract type Fschr60🌎 <: RevolutionEllipsoid end

const _Fschr60 = ellipfromaf⁻¹(6378166.0u"m", 298.3)

ellipsoidparams(::Type{Fschr60🌎}) = _Fschr60

"""
  Fschr60m🌎

Modified Fischer 1960 ellipsoid.
"""
abstract type Fschr60m🌎 <: RevolutionEllipsoid end

const _Fschr60m = ellipfromaf⁻¹(6378155.0u"m", 298.3)

ellipsoidparams(::Type{Fschr60m🌎}) = _Fschr60m

"""
  Fschr68🌎

Fischer 1968 ellipsoid.
"""
abstract type Fschr68🌎 <: RevolutionEllipsoid end

const _Fschr68 = ellipfromaf⁻¹(6378150.0u"m", 298.3)

ellipsoidparams(::Type{Fschr68🌎}) = _Fschr68

"""
  GRS67🌎

GRS 67(IUGG 1967) ellipsoid.
"""
abstract type GRS67🌎 <: RevolutionEllipsoid end

const _GRS67 = ellipfromaf⁻¹(6378160.0u"m", 298.2471674270)

ellipsoidparams(::Type{GRS67🌎}) = _GRS67

"""
  GRS67Modified🌎

Geodetic Reference System 1967 Modified ellipsoid.

See <https://epsg.org/ellipsoid_7050/GRS-1967-Modified.html>
"""
abstract type GRS67Modified🌎 <: RevolutionEllipsoid end

const _GRS67Modified = ellipfromaf⁻¹(6378160.0u"m", 298.25)

ellipsoidparams(::Type{GRS67Modified🌎}) = _GRS67Modified

"""
  GRS80🌎

GRS 1980(IUGG, 1980) ellipsoid.
"""
abstract type GRS80🌎 <: RevolutionEllipsoid end

const _GRS80 = ellipfromaf⁻¹(6378137.0u"m", 298.257222101)

ellipsoidparams(::Type{GRS80🌎}) = _GRS80

"""
  GRS80S🌎

GRS 1980 (IUGG, 1980) Authalic Sphere.
"""
abstract type GRS80S🌎 <: RevolutionEllipsoid end

const _GRS80S = ellipfromab(6371007.0u"m", 6371007.0u"m")

ellipsoidparams(::Type{GRS80S🌎}) = _GRS80S

"""
  GSK2011🌎

GSK-2011 ellipsoid.
"""
abstract type GSK2011🌎 <: RevolutionEllipsoid end

const _GSK2011 = ellipfromaf⁻¹(6378136.5u"m", 298.2564151)

ellipsoidparams(::Type{GSK2011🌎}) = _GSK2011

"""
  Helmert🌎

Helmert 1906 ellipsoid.
"""
abstract type Helmert🌎 <: RevolutionEllipsoid end

const _Helmert = ellipfromaf⁻¹(6378200.0u"m", 298.3)

ellipsoidparams(::Type{Helmert🌎}) = _Helmert

"""
  Hough🌎

Hough ellipsoid.
"""
abstract type Hough🌎 <: RevolutionEllipsoid end

const _Hough = ellipfromaf⁻¹(6378270.0u"m", 297.0)

ellipsoidparams(::Type{Hough🌎}) = _Hough

"""
  IAU76🌎

IAU 1976 ellipsoid.
"""
abstract type IAU76🌎 <: RevolutionEllipsoid end

const _IAU76 = ellipfromaf⁻¹(6378140.0u"m", 298.257)

ellipsoidparams(::Type{IAU76🌎}) = _IAU76

"""
  Intl🌎

International 1924 (Hayford 1909, 1910) ellipsoid.
"""
abstract type Intl🌎 <: RevolutionEllipsoid end

const _Intl = ellipfromaf⁻¹(6378388.0u"m", 297.0)

ellipsoidparams(::Type{Intl🌎}) = _Intl

"""
  Krass🌎

Krassovsky, 1942 ellipsoid.
"""
abstract type Krass🌎 <: RevolutionEllipsoid end

const _Krass = ellipfromaf⁻¹(6378245.0u"m", 298.3)

ellipsoidparams(::Type{Krass🌎}) = _Krass

"""
  Kaula🌎

Kaula 1961 ellipsoid.
"""
abstract type Kaula🌎 <: RevolutionEllipsoid end

const _Kaula = ellipfromaf⁻¹(6378163.0u"m", 298.24)

ellipsoidparams(::Type{Kaula🌎}) = _Kaula

"""
  Lerch🌎

Lerch 1979 ellipsoid.
"""
abstract type Lerch🌎 <: RevolutionEllipsoid end

const _Lerch = ellipfromaf⁻¹(6378139.0u"m", 298.257)

ellipsoidparams(::Type{Lerch🌎}) = _Lerch

"""
  ModAiry🌎

Modified Airy ellipsoid.
"""
abstract type ModAiry🌎 <: RevolutionEllipsoid end

const _ModAiry = ellipfromab(6377340.189u"m", 6356034.446u"m")

ellipsoidparams(::Type{ModAiry🌎}) = _ModAiry

"""
  MERIT🌎

MERIT 1983 ellipsoid.
"""
abstract type MERIT🌎 <: RevolutionEllipsoid end

const _MERIT = ellipfromaf⁻¹(6378137.0u"m", 298.257)

ellipsoidparams(::Type{MERIT🌎}) = _MERIT

"""
  Mprts🌎

Maupertius 1738 ellipsoid.
"""
abstract type Mprts🌎 <: RevolutionEllipsoid end

const _Mprts = ellipfromaf⁻¹(6397300.0u"m", 191.0)

ellipsoidparams(::Type{Mprts🌎}) = _Mprts

"""
  NewIntl🌎

New International 1967 ellipsoid.
"""
abstract type NewIntl🌎 <: RevolutionEllipsoid end

const _NewIntl = ellipfromab(6378157.5u"m", 6356772.2u"m")

ellipsoidparams(::Type{NewIntl🌎}) = _NewIntl

"""
  NWL9D🌎

Naval Weapons Lab., 1965 ellipsoid.
"""
abstract type NWL9D🌎 <: RevolutionEllipsoid end

const _NWL9D = ellipfromaf⁻¹(6378145.0u"m", 298.25)

ellipsoidparams(::Type{NWL9D🌎}) = _NWL9D

"""
  Plessis🌎

Plessis 1817 (France) ellipsoid.
"""
abstract type Plessis🌎 <: RevolutionEllipsoid end

const _Plessis = ellipfromab(6376523.0u"m", 6355863.0u"m")

ellipsoidparams(::Type{Plessis🌎}) = _Plessis

"""
  PZ90🌎

PZ-90 ellipsoid.
"""
abstract type PZ90🌎 <: RevolutionEllipsoid end

const _PZ90 = ellipfromaf⁻¹(6378136.0u"m", 298.25784)

ellipsoidparams(::Type{PZ90🌎}) = _PZ90

"""
  SEAsia🌎

Southeast Asia ellipsoid.
"""
abstract type SEAsia🌎 <: RevolutionEllipsoid end

const _SEAsia = ellipfromab(6378155.0u"m", 6356773.3205u"m")

ellipsoidparams(::Type{SEAsia🌎}) = _SEAsia

"""
  SGS85🌎

Soviet Geodetic System 85 ellipsoid.
"""
abstract type SGS85🌎 <: RevolutionEllipsoid end

const _SGS85 = ellipfromaf⁻¹(6378136.0u"m", 298.257)

ellipsoidparams(::Type{SGS85🌎}) = _SGS85

"""
  Walbeck🌎

Walbeck ellipsoid.
"""
abstract type Walbeck🌎 <: RevolutionEllipsoid end

const _Walbeck = ellipfromab(6376896.0u"m", 6355834.8467u"m")

ellipsoidparams(::Type{Walbeck🌎}) = _Walbeck

"""
  WGS60🌎

WGS 60 ellipsoid.
"""
abstract type WGS60🌎 <: RevolutionEllipsoid end

const _WGS60 = ellipfromaf⁻¹(6378165.0u"m", 298.3)

ellipsoidparams(::Type{WGS60🌎}) = _WGS60

"""
  WGS66🌎

WGS 66 ellipsoid.
"""
abstract type WGS66🌎 <: RevolutionEllipsoid end

const _WGS66 = ellipfromaf⁻¹(6378145.0u"m", 298.25)

ellipsoidparams(::Type{WGS66🌎}) = _WGS66

"""
  WGS72🌎

WGS 72 ellipsoid.
"""
abstract type WGS72🌎 <: RevolutionEllipsoid end

const _WGS72 = ellipfromaf⁻¹(6378135.0u"m", 298.26)

ellipsoidparams(::Type{WGS72🌎}) = _WGS72

"""
  WGS84🌎

WGS 84 ellipsoid.
"""
abstract type WGS84🌎 <: RevolutionEllipsoid end

const _WGS84 = ellipfromaf⁻¹(6378137.0u"m", 298.257223563)

ellipsoidparams(::Type{WGS84🌎}) = _WGS84
