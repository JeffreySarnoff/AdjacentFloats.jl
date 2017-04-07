# AdjacentFloats.jl
Faster versions of nextfloat, prevfloat that work similarly.

These routines return +/-Inf when given +/-Inf.    
That differs from nextfloat(-Inf) == -realmax(), prevfloat(Inf) == realmax()    
(prevfloat(Inf)==Inf makes more sense to me, and likely is more helpful).    
And they step twice when given values of very small magnitude (see paper).    

The alternative implementation, converting to [U]Int and adding/subtracting 1,    
returns NaN when given +/-Inf; and checking for Inf adds branching.    

refs:   

Siegfried Rump, Paul Zimmermann, Sylvie Boldo, Guillaume Melquiond.    
Computing predecessor and successor in rounding to nearest.    
BIT Numerical Mathematics, Springer Verlag, 2009, 49 (2), pp.419-431.    
http://dx.doi.org/10.1007/s10543-009-0218-z    
https://hal.inria.fr/inria-00337537/document    

> "The routines deliver the exact answer except for a small range near underflow,    
> in which case the true result is overestimated by eta [the value added/subtracted]."    

Siefried M. Rump, Takeshi Ogita, Yusuke Morikura, Shin'ichi Oishi.    
Interval arithmetic with fixed rounding mode.    
Nonlinear Theory and Its Applications, IEICE, 2016, 7 (3), pp. 362-373    
http://dx.doi.org/10.1587/nolta.7.362    
http://www.ti3.tu-harburg.de/paper/rump/RuOgMoOi16.pdf    
