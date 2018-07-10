module AdjacentFloats

export prev_float, next_float


const IEEE754 = Union{Float64, Float32, Float16}

const eps64 = 1.1102230246251568e-16
const eps32 = 1.1920929f-7
const eps16 = Float16(0.000977)

next_float(x::T) where {T<:IEEE754} = signbit(x) ? next_nearerto_zero(x) : next_awayfrom_zero(x)
prev_float(x::T) where {T<:IEEE754} = signbit(x) ? next_awayfrom_zero(x) : next_nearerto_zero(x)

function next_float(x::Float64)
    x == -Inf && return -realmax(x)
    return (x + (copysign(eps64, x) * x)) + copysign(5.0e-324, x)
end

function prev_float(x::Float64)
    x == +Inf && return realmax(x)
    return (x - (copysign(eps64, x) * x)) - copysign(5.0e-324, x)
end

function next_float(x::Float32)
    x == -Inf32 && return -realmax(x)
    return (x + (copysign(eps32, x) * x)) + copysign(1.435f-42, x)
end

function prev_float(x::Float32)
    x == +Inf32 && return realmax(x)
    return (x - (copysign(eps32, x) * x)) - copysign(-1.435f-42, x)
end

prev_float(x::Float16) = prevfloat(x)
next_float(x::Float16) = nextfloat(x)

# fallbacks

prev_float(x::BigFloat) = prevfloat(x)
next_float(x::BigFloat) = nextfloat(x)

prev_float(x::AbstractFloat) = prevfloat(x)
next_float(x::AbstractFloat) = nextfloat(x)


# exact for |x| > 8.900295434028806e-308, otherwise may be two steps rather than one step. |x| > ldexp(0.5, -1019)
@inline next_nearerto_zero(x::Float64)   = (x-1.1102230246251568e-16*x)-5.0e-324
@inline next_awayfrom_zero(x::Float64)   = (x+1.1102230246251568e-16*x)+5.0e-324

# exact for |x| > 4.814825f-35, otherwise may be two steps rather than one step
@inline next_nearerto_zero(x::Float32)   = (x-5.960465f-8*x)-1.435f-42
@inline next_awayfrom_zero(x::Float32)   = (x+5.960465f-8*x)+1.435f-42

# the multiplicative formulation for Float16 is exact for |x| > Float16(0.25)
# which is quite coarse, we do not use that here. Exact for all finite Float16s.
@inline next_nearerto_zero(x::Float16) = signbit(x) ? nextfloat(x) : prevfloat(x)
@inline next_awayfrom_zero(x::Float16) = signbit(x) ? prevfloat(x) : nextfloat(x)


end # module
