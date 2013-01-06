#########################################################
#
# How Explicit is the Explict Formula
#
#   (c) William Stein, 2013
#########################################################

import math, os

from sage.all import prime_range, line, tmp_dir, parallel, text

cdef extern from "math.h":
    double log(double)
    double sqrt(double)
    double cos(double)

cdef double pi = math.pi

################################################
# The raw data -- means
################################################

def raw_data(E, B):
    """
    Return the list of pairs (p, D_E(p)), for all primes p < B, and
    another list of pairs (p, running_average).

    INPUT:

    - E -- an elliptic curve over QQ
    - B -- positive integer
    """
    result = []; avgs = []
    aplist = E.aplist(B)
    primes = prime_range(B)
    assert len(aplist) == len(primes)
    cdef double X, running_sum = 0, val = 0
    cdef int i, cnt = 0
    for i in range(len(aplist)):
        if aplist[i] < 0:
            cnt -= 1
        elif aplist[i] > 0:
            cnt += 1

        if i == 0:
            running_sum = 0
        else:
            running_sum += val*(primes[i] - primes[i-1] - 1)

        X   = primes[i]
        val = (log(X) / sqrt(X)) * cnt
        running_sum += val
        result.append((primes[i], val))
        avgs.append((primes[i], running_sum/X))
    return result, avgs

def theoretical_mean(r, vanishing_symmetric_powers):
    """
    INPUT:

    """
    mean = 2/pi - 16/(3*pi)*r
    for n, order in vanishing_symmetric_powers:
        assert n%2 != 0
        k = (n-1)/2
        mean += (4/pi) * (-1)**(k+1)*(1/(2*k+1) + 1/(2*k+3))*order
    return mean

def draw_plot(E, B, vanishing_symmetric_powers=None):
    if vanishing_symmetric_powers is None:
        vanishing_symmetric_powers = []
    mean = theoretical_mean(E.rank(), vanishing_symmetric_powers)
    d, running_average = raw_data(E, B)
    g = line(d)
    g += line([(0,mean), (d[-1][0],mean)], color='darkred')
    g += line(running_average, color='green')
    return g

############################################################
# Plots of error term got by taking partial sum over zeros
############################################################

class OscillatoryTerm(object):
    """
    The Oscillatory Term is a real-valued function of a real variable

        S_n(X) = (1/log(X)) * sum(X^(i*gamma_j)/(i*gamma_j) for j<=n)

    where gamma are the imaginary parts of zeros on the critical strip.

    Return object that when evaluated at a specific number X,
    returns the sequence S_1(X), S_2(X), ..., of partial sums.
    """
    def __init__(self, E, zeros):
        self.E = E
        if not isinstance(zeros, list):
            zeros = E.lseries().zeros(zeros)
        self.zeros = [float(x) for x in zeros if x>0]  # only include *complex* zeros.

    def __call__(self, double X):
        cdef int i
        cdef double logX = log(X), running_sum = 0
        result = []
        for i in range(len(self.zeros)):
            running_sum += cos(logX*self.zeros[i])/self.zeros[i]/logX
            result.append(running_sum)
        return result

    def plot(self, double X, **kwds):
        v = self(X)
        return line(enumerate(v), **kwds)

    def animation_svg(self, Xvals, output_path, ncpus=1, **kwds):
        if not isinstance(Xvals, list):
            raise TypeError, "Xvals must be a list"
        if not os.path.exists(output_path):
            os.makedirs(output_path)

        print("Rendering %s frames to %s using %s cpus"%(len(Xvals), output_path, ncpus))

        @parallel(ncpus)
        def f(X):
            return self(X)

        V = list(f(Xvals))
        ymax = max([max(v[1]) for v in V])
        ymin = min([min(v[1]) for v in V])
        fnames = []
        for X, v in V:
            frame = ( line(enumerate(v), ymax=ymax, ymin=ymin, **kwds) +
                      text("X = %s"%X[0], (len(v)//6, ymax/2.0), color='black', fontsize=16) )
            fname = "%s.svg"%X[0]
            frame.save(os.path.join(output_path, fname))
            fnames.append(fname)

    def animation_pdf(self, Xvals, output_pdf, ncpus=1, **kwds):
        if not isinstance(Xvals, list):
            raise TypeError, "Xvals must be a list"

        print("using %s cpus"%ncpus)
        @parallel(ncpus)
        def f(X):
            return self(X)

        V = list(f(Xvals))
        ymax = max([max(v[1]) for v in V])
        ymin = min([min(v[1]) for v in V])
        path = tmp_dir()
        fnames = []
        for X, v in V:
            frame = ( line(enumerate(v), ymax=ymax, ymin=ymin, **kwds) +
                      text("X = %s"%X[0], (len(v)//6, ymax/2.0), color='black', fontsize=16) )
            fname = "%s.pdf"%X[0]
            frame.save(os.path.join(path, fname))
            fnames.append(fname)
        cmd = "cd '%s' && gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE='%s' -dBATCH %s"%(
            path, os.path.abspath(output_pdf), ' '.join(fnames))
        print(cmd)
        os.system(cmd)

