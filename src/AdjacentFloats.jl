module AdjacentFloats

export prev_float, next_float

using Compat

#=
  These routines return +/-Inf when given +/-Inf.
  That differs from nextfloat(-Inf) == -realmax(), prevfloat(Inf) == realmax()
  (prevfloat(Inf)==Inf makes more sense to me, and likely is more helpful).
  The logic for finite Float64 and Float32 values steps twice when 
  given values of very small magnitude (see paper).
  The alternative implementation, converting to [U]Int and adding/subtracting 1,
  returns NaN when given +/-Inf -- and checking for Inf adds branching. 
  ref:
  'Predecessor and Successor In Rounding To Nearest' by Siegried M. Rump
  "The routines deliver the exact answer except for a small range near underflow,
   in which case the true result is overestimated by eta [the value added/subtracted below]."
=#

# exact for |x| > 8.900295434028806e-308, otherwise may be two steps rather than one step
next_nearerto_zero(x::Float64)   = (0.9999999999999999*x)-5.0e-324 # (x-1.1102230246251568e-16*x)-5.0e-324 
next_awayfrom_zero(x::Float64)   = (1.0000000000000002*x)+5.0e-324 # (x+1.1102230246251568e-16*x)+5.0e-324

# exact for |x| > 4.814825f-35, otherwise may be two steps rather than one step
next_nearerto_zero(x::Float32)   = (0.99999994f0*x)-1.435f-42      # (x-5.960465f-8*x)-1.435f-42
next_awayfrom_zero(x::Float32)   = (1.00000010f0*x)+1.435f-42      # (x+5.960465f-8*x)+1.435f-42

# the multiplicative formulation for Float16 is exact for |x| > Float16(0.25)
# which is quite coarse, we do not use that here. Exact for all finite Float16s.
next_nearerto_zero(x::Float16) = (x < 0) ? nextfloat(x) : prevfloat(x)
next_awayfrom_zero(x::Float16) = (x < 0) ? prevfloat(x) : nextfloat(x)

const IEEEFloat = Union{:Float64, :Float32, :Float16}

next_float{T<:IEEEFloat}(x::T) = signbit(x) ? next_nearerto_zero(x) : next_awayfrom_zero(x)
prev_float{T<:IEEEFloat}(x::T) = signbit(x) ? next_awayfrom_zero(x) : next_nearerto_zero(x)


end # module
