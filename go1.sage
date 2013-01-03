attach "explicit.pyx"

ncpus = sage.parallel.ncpus.ncpus()

def f(label, xvals=200, zeros=5000):
    print(label)
    o = OscillatoryTerm(EllipticCurve(label), zeros)
    for n in [3,4,5,6]:
        o.animation([10^n+50*i for i in [0..xvals]], 'animations/go1-%s-%s-%s-%s.pdf'%(xvals, zeros, label, n), ncpus=ncpus)

for label in ['11a1', '37a1', '40a3', '389a1', '5077a']:
    f(label)
