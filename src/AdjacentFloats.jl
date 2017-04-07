module AdjacentFloats

export prev_float, next_float

using Compat

# exact for |x| > 8.900295434028806e-308, otherwise may be two steps rather than one step. |x| > ldexp(0.5, -1019)
@inline next_nearerto_zero(x::Float64)   = muladd(0.9999999999999999, x, -5.0e-324)  # (x-1.1102230246251568e-16*x)-5.0e-324 
@inline next_awayfrom_zero(x::Float64)   = muladd(1.0000000000000002, x, +5.0e-324)  # (x+1.1102230246251568e-16*x)+5.0e-324

# exact for |x| > 4.814825f-35, otherwise may be two steps rather than one step
@inline next_nearerto_zero(x::Float32)   = muladd(0.99999994f0, x, -1.435f-42)       # (x-5.960465f-8*x)-1.435f-42
@inline next_awayfrom_zero(x::Float32)   = muladd(1.00000010f0, x, +1.435f-42)       # (x+5.960465f-8*x)+1.435f-42

# the multiplicative formulation for Float16 is exact for |x| > Float16(0.25)
# which is quite coarse, we do not use that here. Exact for all finite Float16s.
@inline next_nearerto_zero(x::Float16) = (x < 0) ? nextfloat(x) : prevfloat(x)
@inline next_awayfrom_zero(x::Float16) = (x < 0) ? prevfloat(x) : nextfloat(x)

const IEEEFloat = Union{Float64, Float32, Float16}

next_float{T<:IEEEFloat}(x::T) = signbit(x) ? next_nearerto_zero(x) : next_awayfrom_zero(x)
prev_float{T<:IEEEFloat}(x::T) = signbit(x) ? next_awayfrom_zero(x) : next_nearerto_zero(x)


end # module
