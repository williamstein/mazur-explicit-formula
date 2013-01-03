#########################################################
#
# How Explicit is the Explict Formula
#
#   (c) William Stein, 2013
#########################################################

from sage.all import prime_range, line
import math

cdef extern from "math.h":
    double log(double)
    double sqrt(double)
    double cos(double)

cdef double pi = math.pi

def raw_data(E, B):
    """
    Return the list of pairs (p, D_E(p)), for all primes p < B, and
    another list of pairs (p, running_average).

    E -- an elliptic curve over QQ
    B -- positive integer
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

def the_mean(r, vanishing_symmetric_powers):
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
    mean = the_mean(E.rank(), vanishing_symmetric_powers)
    d, running_average = raw_data(E, B)
    g = line(d)
    g += line([(0,mean), (d[-1][0],mean)], color='darkred')
    g += line(running_average, color='green')
    return g

class ZeroSums(object):
    def __init__(self, E, zeros):
        self.E = E
        if not isinstance(zeros, list):
            zeros = E.lseries().zeros(zeros)
        self.zeros = [float(x) for x in zeros]

    def partial_sums(self, double X):  
        cdef int i
        cdef double logX = log(X), running_sum = 0
        result = []
        for i in range(len(self.zeros)):
            running_sum += cos(logX*self.zeros[i])/self.zeros[i]/logX
            result.append((i, running_sum))
        return result

# NOTHING TO SEE HERE -- THIS NEVER HAPPENED -- not clear if it is meaningful
# def zero_sums(E, zeros, B, prec=10000):
#     #
#     # E -- elliptic curve
#     # B -- positive integer
#     # zeroes -- list of imag parts of zeros or an integer (in which case list is computed)
#     #           it takes about 5 seconds to compute 1000 zeros...
#     #
#     if not isinstance(zeros, list):
#         zeros = E.lseries().zeros(zeros)

#     # we evaluate at primes up to B.
#     primes = prime_range(B)
#     log_primes = [log(p) for p in primes]

#     def zero_sum(double x):
#         return 2*sum(cos(g*x) for g in zeros)

#     zero_sums_function = []
#     running_average_function = []
#     cdef int i
#     cdef double z, sum_so_far=0
#     for i in range(len(primes)):
#         z = zero_sum(log_primes[i])
#         sum_so_far += z*(primes[i]-primes[i-1])
#         n += 1
#         zero_sums_function.append((i, z))
        
