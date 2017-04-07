using AdjacentFloats
using Base.Test

@test prev_float(sqrt(2.0)) == prevfloat(sqrt(2.0))
@test next_float(sqrt(2.0)) == nextfloat(sqrt(2.0))

@test prev_float(sqrt(0.25)) == prevfloat(sqrt(0.25))
@test next_float(sqrt(0.25)) == nextfloat(sqrt(0.25))

@test prev_float(4096*realmin(Float32)) == prevfloat(4096*realmin(Float32))
@test next_float(4096*realmin(Float32)) == nextfloat(4096*realmin(Float32))

@test next_float(realmin(Float64)) == nextfloat(nextfloat(realmin(Float64)))