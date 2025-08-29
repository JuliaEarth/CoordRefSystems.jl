"""
    Stereographic{}

[Description]
"""
struct Stereographic{Mode, lat₁, Datum, Shift, M <: Met} <: Projected{Datum, Shift}
    x::M
    y::M
end

#TODO: Constructors


# ------------
# CONVERSIONS
# ------------

function formulas(::Type{<:Stereographic{EllipticalMode, lat₁, Datum}}, ::Type{T}) where {lat₁, Datum, T}
    ϕF = T(ustrip(deg2rad(lat₁)))
    🌎 = ellipsoid(Datum)

    e = T(eccentricity(🌎))
    a = T(majoraxis(🌎))
    π = T(pi)
    #It seems like k₀ tends to be 1.0, however if one unit on the map should not be one unit in reality, this needs to be changed
    #Still, https://neacsu.net/geodesy/snyder/5-azimuthal/sect_21 states that for projections of Europe, Africa and Asia the values should be 0.976, 0.941 and 0.939 respectively
    k₀ = T(1.0)

    function fχ(ϕ)
        sinϕ = sin(ϕ)
        χ = 2sqrt(atan((1 + sinϕ)/(1 - sinϕ) * ((1 - e*sinϕ)/(1 + e*sinϕ))^e)) - π/2
    end
    χ₁ = fχ(ϕF)
    m₁ = cos(ϕF)/sqrt(1 - e^2*sin(ϕF)^2)

    function fx(λ, ϕ)
        χ = fχ(ϕ)
        A = 2a*k₀*m₁/(cos(χ₁)*(1 + sin(χ₁)sin(χ) + cos(χ₁)cos(χ)cos(λ)))
        x = A*cos(χ)*sin(λ)
    end

    function fy(λ, ϕ)
        χ = fχ(ϕ)
        A = 2a*k₀*m₁/(cos(χ₁)*(1 + sin(χ₁)sin(χ) + cos(χ₁)cos(χ)cos(λ)))
        y = A*(cos(χ₁)*sin(χ) - sin(χ₁)*cos(χ)cos(λ))
    end
    fx, fy
end

function formulas(::Type{<:Stereographic{SphericalMode, lat₁, Datum}}, ::Type{T}) where {lat₁, Datum, T}
    ϕF = T(ustrip(deg2rad(lat₁)))
    🌎 = ellipsoid(Datum)

    e = T(eccentricity(🌎))
    π = T(pi)

    #It seems like k₀ tends to be 1.0, however if one unit on the map should not be one unit in reality, this needs to be changed
    k₀ = T(1.0)

    function fx(λ, ϕ)
        k = 2k₀*(1 + sin(ϕF)sin(ϕ) + cos(ϕF)cos(ϕ)cos(λ))
        x = k*cos(ϕ)sin(λ)
    end

    function fy(λ, ϕ)
        k = 2k₀*(1 + sin(ϕF)sin(ϕ) + cos(ϕF)cos(ϕ)cos(λ))
        y = k*(cos(ϕF)sin(ϕ) - sin(ϕF)cos(ϕ)cos(λ))
    end
    fx, fy
end

function backward(C::Type{<:Stereographic{EllipticalMode, lat₁, Datum}}, x, y) where {lat₁,Datum}
    T = typeof(x)
    ϕ₁ = T(ustrip(deg2rad(lat₁)))
    #TODO: add k₀ parameter
    k₀ = T(1.0)
    λₛ, ϕₛ = sphericalinv(x, y, ϕ₁, k₀)
    fx, fy = formulas(C, T)
    projinv(fx, fy, x, y, λₛ, ϕₛ)
end

function backward(::Type{<:Stereographic{SphericalMode, lat₁, Datum}}, x, y) where {lat₁,Datum}
    T = typeof(x)
    ϕ₁ = T(ustrip(deg2rad(lat₁)))
    #TODO: add k₀ parameter
    k₀ = T(1.0)
    sphericalinv(x, y, ϕ₁, k₀)
end

# ----------
# FALLBACKS
# ----------

#TODO: indomain and Base.convert functions

# -----------------
# HELPER FUNCTIONS
# -----------------

function sphericalinv(x, y, ϕ₁, k₀)
  ρ = hypot(x, y)
  if ρ < atol(x)
    zero(x), ϕ₁
  else
    c = 2atan(ρ, 2k₀)
    sinc = sin(c)
    cosc = cos(c)
    sinϕ₁ = sin(ϕ₁)
    cosϕ₁ = cos(ϕ₁)
    λ = atan(x * sinc, ρ * cosϕ₁ * cosc - y * sinϕ₁ * sinc)
    ϕ = asinclamp(cosc * sinϕ₁ + (y * sinc * cosϕ₁ / ρ))
    λ, ϕ
  end
end
