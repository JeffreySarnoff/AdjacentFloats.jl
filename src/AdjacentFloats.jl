module AdjacentFloats

export prev_float, next_float


const IEEE754 = Union{Float64, Float32, Float16}

next_float{T<:IEEE754}(x::T) = signbit(x) ? next_nearerto_zero(x) : next_awayfrom_zero(x)
prev_float{T<:IEEE754}(x::T) = signbit(x) ? next_awayfrom_zero(x) : next_nearerto_zero(x)


# exact for |x| > 8.900295434028806e-308, otherwise may be two steps rather than one step. |x| > ldexp(0.5, -1019)
next_nearerto_zero(x::Float64)   = (x-1.1102230246251568e-16*x)-5.0e-324 
next_awayfrom_zero(x::Float64)   = (x+1.1102230246251568e-16*x)+5.0e-324

# exact for |x| > 4.814825f-35, otherwise may be two steps rather than one step
next_nearerto_zero(x::Float32)   = (x-5.960465f-8*x)-1.435f-42
next_awayfrom_zero(x::Float32)   = (x+5.960465f-8*x)+1.435f-42

# the multiplicative formulation for Float16 is exact for |x| > Float16(0.25)
# which is quite coarse, we do not use that here. Exact for all finite Float16s.
next_nearerto_zero(x::Float16) = signbit(x) ? nextfloat(x) : prevfloat(x)
next_awayfrom_zero(x::Float16) = signbit(x) ? prevfloat(x) : nextfloat(x)


end # module
