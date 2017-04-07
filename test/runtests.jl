using AdjacentFloats
using Base.Test

@test prev_float(sqrt(2.0)) == prevfloat(sqrt(2.0))
@test next_float(sqrt(2.0)) == nextfloat(sqrt(2.0))

@test prev_float(sqrt(0.25)) == prevfloat(sqrt(0.25))
@test next_float(sqrt(0.25)) == nextfloat(sqrt(0.25))
