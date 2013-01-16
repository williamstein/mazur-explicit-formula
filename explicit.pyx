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
    double sin(double)

cdef double pi = math.pi

################################################
# The raw data -- means
################################################
"""
sage: dp = DataPlots("160a", 10^6)
sage: v = dp.data(num_points=5000)
sage: plot_step_function(v['raw']['mean'],color='red',thickness=.5) + plot_step_function(v['raw']['delta'], thickness=.5)
"""

def data(E, B, aplist, num_points=None, log_X_scale=True, verbose=True):
    """
    Return graphs of the raw, medium, and well-done delta's,
    along with their means.  By a graph, we mean a list of
    pairs (X, f(X)), where the function is sampled at various
    values X.

    INPUT:

    - E -- an elliptic curve over QQ
    - B -- positive integer
    - aplist -- list of Fourier coefficients a_p
    - log_X_scale -- if true, scale x-axis on a logarithmic scale,
      so the point (x,y) in the returned list indicates that
      mean...(exp(x)) = y.   It is important to do this scaling
      in this function when *computing* the mean, rather than taking
      the returned data from this function and then rescaling, because
      we have billions of sample points and this function only returns
      a few thousand.
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
         length, plot_X_position, next_plot_X_position, plot_X_delta

    next_plot_X_position = 0
    if log_X_scale:
        plot_X_delta = log(primes[-1])/num_points
    else:
        plot_X_delta = primes[-1]/num_points

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
            # raw mean    -- an integral of log(X)/(X*sqrt(X)) is -2*log(X)/sqrt(X) - 4/sqrt(X)
            integral_raw    += ((-2*logX/sqrtX - 4/sqrtX) - (-2*last_logX/last_sqrtX - 4/last_sqrtX)) * last_sum_raw

            # medium mean -- an integral of log(X)/(X*sqrt(X)) is -2*log(X)/sqrt(X) - 4/sqrt(X)
            integral_medium += ((-2*logX/sqrtX - 4/sqrtX) - (-2*last_logX/last_sqrtX - 4/last_sqrtX)) * last_sum_medium

            # well done mean -- an integral of 1/(X*log(X)) is log(log(X))
            loglogX = log(logX)
            integral_well   += (loglogX - last_loglogX) * last_sum_well

        last_sqrtX = sqrtX
        last_logX = logX
        last_loglogX = loglogX
        last_X = X
        last_p = p

        # Finally, record next data point, if it is time to do so...
        if log_X_scale:
            plot_X_position = log(X)
        else:
            plot_X_position = X
            
        if verbose and record_modulus >= 1000 and (i%(10*record_modulus)==0):
            per = float(i)/M
            if per > 0.1:
                print "%.1f"%(walltime(tm)*(1-per)/per),
                sys.stdout.flush()
                
        if plot_X_position >= next_plot_X_position:
            next_plot_X_position += plot_X_delta

            delta_raw.append((plot_X_position, sum_raw))
            delta_medium.append((plot_X_position, sum_medium*logX/sqrtX))
            delta_well.append((plot_X_position, sum_well/logX))

            mean_raw.append((plot_X_position, integral_raw/logX))
            mean_medium.append((plot_X_position, integral_medium/logX))
            mean_well.append((plot_X_position, integral_well/logX))

    if verbose:
        print "\n-- Done computing raw plot data; returning."

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
            print "Computing aplist"
            self.aplist = self.E.aplist(self.B)
        else:
            print "Loading aplist"
            self.aplist = load('%s/%s-aplist-%s.sobj'%(data_path,lbl,B))
        print "done"

    @cached_method
    def data(self, num_points=1000,log_X_scale=True, verbose=True):  # num_points = number of sample points in output plot
        print "Computing raw data of plots"
        d = data(self.E, B=self.B, aplist=self.aplist, num_points=num_points,
                    log_X_scale=log_X_scale, verbose=verbose)
        print "Done computing raw data"
        return d

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



##############################################################
# Plots of mean value of error term involving sums over zeros
##############################################################

def mean_zero_sum_plot(list zeros, int n, double Xmax):
    """
    Plot this function on a log scale up to X at n sample points:

      -2/log(X) * sum cos(gamma*log(X))/gamma^2

    where g runs over zeros, which should be the positive imaginary
    parts of the first few zeros of an elliptic curve L-function.
    Returns list of pairs of doubles (x,y), which are points on the plot
    """
    cdef list v = []
    zeros = [float(x) for x in zeros if x>0]

    # start at X=2
    cdef double s, gamma, logX=log(2), logXmax = log(Xmax)
    cdef double delta = logXmax / n

    while logX <= logXmax:
        s = 0
        for gamma in zeros:
            s += cos(gamma*logX)/(gamma*gamma)
        v.append((logX, -2*s/logX))
        logX += delta

    return v

def zero_sum_plot(list zeros, int n, double Xmax):
    """
    Plot this function on a log scale up to X at n sample points:

       (2/log(X))  * sum sin(gamma*log(X))/gamma,

    where gamma runs over positive imaginary parts of the first few
    zeros of an elliptic curve L-function.

    OUTPUT: list of pairs (x,y), which are points on the plot.
    """
    cdef list v = []
    zeros = [float(x) for x in zeros if x>0]

    # start at X=2
    cdef double s, gamma, logX=log(2), logXmax = log(Xmax)
    cdef double delta = logXmax / n

    while logX <= logXmax:
        s = 0
        for gamma in zeros:
            s += sin(gamma*logX)/gamma
        v.append((logX, 2*s/logX))
        logX += delta

    return v
