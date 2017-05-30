using AdjacentFloats
using Base.Test

@testset "AdjacentFloats" begin

    for (f, g) in ( (prev_float, prevfloat),
                    (next_float, nextfloat) )

        @testset "$f" begin

            for x in (1.0, -1.0, 3.0, sqrt(2.0), sqrt(0.25),
                        Inf, -Inf)

                @test f(x) == g(x)
            end
        end
    end

    @testset "NaN" begin
        @test isnan(prev_float(NaN))
        @test isnan(next_float(NaN))
    end
end
