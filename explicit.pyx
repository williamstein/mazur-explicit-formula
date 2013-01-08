#########################################################
#
# How Explicit is the Explict Formula
#
#   (c) William Stein, 2013
#########################################################

import math, os, sys

from sage.all import prime_range, line, tmp_dir, parallel, text, cached_method, nth_prime, load, EllipticCurve, walltime

from scipy.special import expi as Ei

cdef extern from "math.h":
    double log(double)
    double sqrt(double)
    double cos(double)

cdef double pi = math.pi

################################################
# The raw data -- means
################################################
"""
sage: dp = DataPlots("160a", 10^6)
sage: v = dp.data(num_points=5000)
sage: plot_step_function(v['raw']['mean'],color='red',thickness=.5) + plot_step_function(v['raw']['delta'], thickness=.5)
"""

def data(E, B, aplist, num_points=None, verbose=True):
    """
    Return graphs of the raw, medium, and well-done delta's,
    along with their means.  By a graph, we mean a list of
    pairs (X, f(X)), where the function is sampled at various
    values X.

    INPUT:

    - E -- an elliptic curve over QQ
    - B -- positive integer
    - aplist -- list of Fourier coefficients a_p
    - verbose -- print estimate of remaining time to do the computation
    """
    if verbose:
        print "Time remaining:",
    tm = walltime()
    if B is None:
        if aplist is not None:
            B = nth_prime(len(aplist))+1
        else:
            B = 1000
    if aplist is None:
        aplist = E.aplist(B)
    primes = prime_range(B)
    assert len(aplist) == len(primes)
    M = len(aplist)
    if num_points is None or num_points > M:
        num_points = len(aplist)
    cdef int record_modulus = M//num_points

    delta_raw = []; delta_medium = []; delta_well = []
    mean_raw = [];  mean_medium = [];  mean_well  = []

    cdef double ap, p, last_p=0, X, last_X = 0, \
         sum_raw = 0,  sum_medium = 0,  sum_well = 0, \
         last_sum_raw = 0, last_sum_medium = 0, last_sum_well = 0, \
         integral_raw = 0, integral_medium = 0, integral_well = 0, \
         gamma_p = 0, last_gamma_p = 0, EilogX = 0, last_EilogX = 0, \
         length

    cdef int i = -1, cnt = 0
    for ap in aplist:
        i += 1
        p = primes[i]
        X = p

        # Update the sums:
        # raw sum
        if ap < 0:
            gamma_p = -1
        elif ap > 0:
            gamma_p = 1
            
        last_sum_raw = sum_raw
        sum_raw += gamma_p
        
        # used below
        logX  = log(X)
        sqrtX = sqrt(X)
        
        # medium sum
        last_sum_medium = sum_medium
        sum_medium += ap/sqrtX
        
        # well-done sum
        last_sum_well = sum_well
        sum_well += ap*logX/p

        # Update the integrals that appear in the mean
        if i > 0:
            length = p - last_p
            # raw mean
            integral_raw    += length * last_sum_raw
            # medium mean -- an integral of log(X)/sqrt(X) is 2*sqrt(X)*log(X)-4*sqrt(X).
            integral_medium += ((2*sqrtX*logX-4*sqrtX)-(2*last_sqrtX*last_logX-4*last_sqrtX)) * last_sum_medium
            # well done mean -- an integral of 1/log(X) is Ei(log(X))
            EilogX = Ei(logX)
            integral_well   += (EilogX - last_EilogX) * last_sum_well

        last_sqrtX = sqrtX
        last_logX = logX
        last_X = X
        last_EilogX = EilogX
        last_p = p
        
        # Finally, record next data point, if it is time to do so...
        if i % record_modulus == 0:
            if verbose and record_modulus >= 1000 and (i%(10*record_modulus)==0):
                per = float(i)/M
                if per > 0.1:
                    print "%.1f"%(walltime(tm)*(1-per)/per),
                    sys.stdout.flush()
                    
            delta_raw.append((X, sum_raw))
            delta_medium.append((X, sum_medium*logX/sqrtX))
            delta_well.append((X, sum_well/logX))
            
            mean_raw.append((X, integral_raw/X))
            mean_medium.append((X, integral_medium/X))
            mean_well.append((X, integral_well/X))

    if verbose:
        print 

    return {'raw'    : {'delta' : delta_raw,    'mean': mean_raw},
            'medium' : {'delta' : delta_medium, 'mean': mean_medium},
            'well'   : {'delta' : delta_well,   'mean': mean_well} }

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
    d, running_average = data(E, B)
    g = line(d)
    g += line([(0,mean), (d[-1][0],mean)], color='darkred')
    g += line(running_average, color='green')
    return g


############################################################
# Plots of data suitable for display (so number of recorded
# sample points is smaller), which benefit from having a
# pre-computed aplist table.
############################################################

class DataPlots(object):
    def __init__(self, lbl, B, data_path=None):
        self.data_path = data_path
        self.B = B
        self.E = EllipticCurve(lbl)
        if self.data_path is None:
            self.aplist = self.E.aplist(self.B)
        else:
            self.aplist = load('%s/%s-aplist-%s.sobj'%(data_path,lbl,B))

    @cached_method
    def data(self, num_points=1000):  # num_points = number of sample points in output plot
        return data(self.E, B=self.B, aplist=self.aplist, num_points=num_points)

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



