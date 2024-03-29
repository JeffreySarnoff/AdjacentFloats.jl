module AdjacentFloats

export prev_float, next_float

const halfeps(::Type{Float64}) = eps(Float64)/2
const halfeps(::Type{Float32}) = eps(Float32)/2
const halfeps(::Type{Float16}) = eps(Float16)/2

const leastfloat(::Type{Float64}) = nextfloat(zero(Float64))
const leastfloat(::Type{Float32}) = nextfloat(zero(Float32))
const leastfloat(::Type{Float16}) = nextfloat(zero(Float16))
const negleastfloat(::Type{Float64}) = -nextfloat(zero(Float64))
const negleastfloat(::Type{Float32}) = -nextfloat(zero(Float32))
const negleastfloat(::Type{Float16}) = -nextfloat(zero(Float16))

next_nearerto_zero(x::T) where {T} = leastfloat(T) - fma(halfeps(T), x, -x)
next_awayfrom_zero(x::T) where {T} =  negleastfloat(T) + fma(halfeps(T), x,  x)

@inline function prev_float_signed(x::T) where {T}
    signbit(x) ? next_awayfrom_zero(x) : next_nearerto_zero(x)
end

@inline function next_float_signed(x::T) where {T}
    signbit(x) ? next_nearerto_zero(x) : next_awayfrom_zero(x)
end

@inline function next_float(x::T) where {T}
    if !isinf(x)
        next_float_signed(x)
    else
        if !signbit(x)
            x
        else
            -floatmax(T)
        end
    end
end

@inline function prev_float(x::T) where {T}
    if !isinf(x)
        prev_float_signed(x)
    else
        if signbit(x)
            x
        else
            floatmax(T)
        end
    end
end

    
#=
function next_float(x::Float64)
    x !== -Inf && return next_float_signed(x) 
    return -realmax(Float64)
end

function prev_float(x::Float64)
    x !== Inf && return prev_float_signed(x) 
    return realmax(Float64)
end

@inline function prev_float_signed(x::Float64)
    signbit(x) ? next_awayfrom_zero(x) : next_nearerto_zero(x)
end

@inline function next_float_signed(x::Float64)
    signbit(x) ? next_nearerto_zero(x) : next_awayfrom_zero(x)
end

@inline next_nearerto_zero(x::Float64) = -fma(+1.1102230246251568e-16, x, -x) + 5.0e-324
@inline next_awayfrom_zero(x::Float64) =  fma(+1.1102230246251568e-16, x,  x) - 5.0e-324

function next_float(x::Float32)
    x !== -Inf32 && return next_float_signed(x) 
    return -realmax(Float32)
end

function prev_float(x::Float32)
    x !== Inf32 && return prev_float_signed(x) 
    return realmax(Float32)
end

@inline function prev_float_signed(x::Float32)
    signbit(x) ? next_awayfrom_zero(x) : next_nearerto_zero(x)
end

@inline function next_float_signed(x::Float32)
    signbit(x) ? next_nearerto_zero(x) : next_awayfrom_zero(x)
end

@inline next_nearerto_zero(x::Float32) = -fma(+5.960465f-8, x, -x) + 1.435f-42
@inline next_awayfrom_zero(x::Float32) =  fma(+5.960465f-8, x,  x) - 1.435f-42


function next_float(x::Float16)
    x !== -Inf16 && return next_float_signed(x) 
    return -realmax(Float16)
end

function prev_float(x::Float16)
    x !== Inf16 && return prev_float_signed(x) 
    return realmax(Float16)
end

@inline function prev_float_signed(x::Float16)
    signbit(x) ? next_awayfrom_zero(x) : next_nearerto_zero(x)
end

@inline function next_float_signed(x::Float16)
    signbit(x) ? next_nearerto_zero(x) : next_awayfrom_zero(x)
end

@inline next_nearerto_zero(x::Float16) = -fma(+Float16(0.0004883), x, -x) + Float16(6.0e-8)
@inline next_awayfrom_zero(x::Float16) =  fma(+Float16(0.0004883), x,  x) - Float16(6.0e-8)

@inline next_nearerto_zero(x::Float16) = signbit(x) ? nextfloat(x) : prevfloat(x)
@inline next_awayfrom_zero(x::Float16) = signbit(x) ? prevfloat(x) : nextfloat(x)

=#

# fallbacks

prev_float(x::BigFloat) = prevfloat(x)
next_float(x::BigFloat) = nextfloat(x)

prev_float(x::T) where {T<:AbstractFloat} = prevfloat(x)
next_float(x::T) where {T<:AbstractFloat} = nextfloat(x)

end # module
