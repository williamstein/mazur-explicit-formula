attach "explicit.pyx"

list1 = ["11a", "14a", "37a", "43a", "389a", "433a", "5077a", "11197a"]
list2 = ["816b", "5423a", "2340i", "2379b", "2432d", "29862s", "3776h", "128b", "160a", "192a", "10336d"]

ncpus = 16

from math import log, exp

def plots(curves=list1, rng="1e9", ncpus=ncpus) :
    B = int(eval(rng))
    print "output path = ", rng
    print "B = ", B

    def f(label):
        dp = DataPlots(label, B, data_path='data')
        v = dp.data(num_points=5000, log_X_scale=True, verbose=True)
        for w in ['raw','medium','well']:
            g = plot_step_function(v[w]['mean'],thickness=5,fontsize=24)
            g.save('plots/%s/%s-%s-%s.svg'%(rng, label, w, B), gridlines=True)
        return label, v['raw']['mean'][-1][1], v['medium']['mean'][-1][1], v['well']['mean'][-1][1]

    @parallel(ncpus)
    def g(label):
        return f(label)

    if ncpus > 1:
        for input, output in g(curves):
            print output
    else:
        for lbl in curves:
            print f(lbl)

def aplist_data(curves=list1, rng="1e9"):
    B = int(eval(rng))
    @parallel(ncpus)
    def f(lbl):
        E = EllipticCurve(lbl)
        aplist_sobj = 'data/%s-aplist-%s.sobj'%(lbl, B)
        if not os.path.exists(aplist_sobj):
            v = E.aplist(B)
            v = [int(ap) for ap in v]
            save(v, aplist_sobj)

    for input, output in f(curves):
        print input, output

def lseries_data(curves=list1+list2, rng="1e4"):
    B = int(eval(rng))
    @parallel(ncpus)
    def f(lbl):
        E = EllipticCurve(lbl)
        zeros_sobj = 'data/%s-zeros-%s.sobj'%(lbl, B)
        if not os.path.exists(zeros_sobj):
            v = E.lseries().zeros(B)
            v = [float(z) for z in v]
            save(v, zeros_sobj)

    for input, output in f(curves):
        print input, output

def zeros(lbl, num_zeros=10000):
    assert num_zeros <= 10000
    file = "data/%s-zeros-%s.sobj"%(lbl,num_zeros)
    if os.path.exists(file):
        return load(file)
    else:
        return load("data/%s-zeros-10000.sobj"%lbl)[:num_zeros]

def aplist(lbl,B):
    return load("data/%s-aplist-%s.sobj"%(lbl,B))

def zero_sum_mean_plots(curves=list1+list2, num_zeros=10000, Xmax=1e9, num_points=10000):
    assert num_zeros <= 10000
    @parallel(ncpus)
    def f(lbl):
        path = "plots/mean_zero_sums/%s/"%num_zeros
        if not os.path.exists(path):
            os.makedirs(path)
        fname = "%s/%s-%s-%s-%s.svg"%(path, lbl, num_zeros, Xmax, num_points)
        if os.path.exists(fname):
            return "already done"
        v = mean_zero_sum_plot(zeros(lbl,num_zeros), num_points, Xmax)
        line(v).save(fname)

    for input, output in f(curves):
        print input, output

def zero_sum_mean_animations(curves=list1+list2, num_zeros=[10,20,..,500], Xmax=1e9, num_points=10000):
    assert max(num_zeros) <= 10000
    @parallel(ncpus)
    def f(lbl):
        path = "plots/mean_zero_sums/animations/%s-%s"%(Xmax, num_points)
        if not os.path.exists(path):
            os.makedirs(path)
        fname = "%s/%s.gif"%(path, lbl)
        if os.path.exists(fname):
            return "already done"
        v = zeros(lbl)
        frames = [line(mean_zero_sum_plot(v[:n], num_points, Xmax)) for n in num_zeros]
        ymax = max([f.ymax() for f in frames])
        ymin = min([f.ymin() for f in frames])
        A = animate(frames, ymax=ymax, ymin=ymin)
        A.save(fname)

    for input, output in f(curves):
        print input, output


#########################################################

def zero_sum_plots(curves=list1+list2, num_zeros='1e4', Xmax='1e9', num_points='1e3'):
    path = "plots/zero_sums/%s/"%num_zeros
    if not os.path.exists(path):
        os.makedirs(path)
    fname = "%s/%s-%s-%s-%s.svg"%(path, lbl, num_zeros, Xmax, num_points)
    if os.path.exists(fname):
        return "already done"
    if isinstance(Xmax,str):
        Xmax = float(Xmax)
    if isinstance(num_points, str):
        num_points=int(float(num_points))
    if isinstance(num_zeros, str):
        num_zeros=int(float(num_zeros))
    @parallel(ncpus)
    def f(lbl):
        v = zero_sum_plot(zeros(lbl,num_zeros), num_points, Xmax)
        line(v).save(fname)

    for input, output in f(curves):
        print input, output

def zero_sum_animations(curves=list1+list2, num_zeros=[10,15,..,500], Xmax='1e20', num_points='1e4'):
    assert max(num_zeros) <= 10000
    path = "plots/zero_sums/animations/%s-%s"%(Xmax, num_points)
    if not os.path.exists(path):
        os.makedirs(path)
    if isinstance(Xmax,str):
        Xmax = float(Xmax)
    if isinstance(num_points, str):
        num_points=int(float(num_points))
    @parallel(ncpus)
    def f(lbl):
        fname = "%s/%s.gif"%(path, lbl)
        if os.path.exists(fname):
            return "already done"
        v = zeros(lbl)
        frames = [line(zero_sum_plot(v[:n], num_points, Xmax), thickness=.4) +
                  text(str(n),(log(Xmax)/10,.15),fontsize=16,color='black')   for n in num_zeros]
        ymax = max([f.ymax() for f in frames])
        ymin = min([f.ymin() for f in frames])
        A = animate(frames, ymax=ymax, ymin=ymin, figsize=[8,5])
        A.save(fname)

    for input, output in f(curves):
        print input, output


def zero_sum_no_log_animations(curves=list1+list2, num_zeros=[4..100], Xmax='1e20', num_points='1e4'):
    assert max(num_zeros) <= 10000
    path = "plots/zero_sums_no_log/animations/%s-%s"%(Xmax, num_points)
    if not os.path.exists(path):
        os.makedirs(path)
    if isinstance(Xmax,str):
        Xmax = float(Xmax)
    if isinstance(num_points, str):
        num_points=int(float(num_points))
    @parallel(ncpus)
    def f(lbl):
        fname = "%s/%s.gif"%(path, lbl)
        if os.path.exists(fname):
            return "already done"
        v = zeros(lbl)
        frames = [line(zero_sum_no_log_plot(v[:n], num_points, Xmax), thickness=.3) +
                  text(str(n),(log(Xmax)/10,.15),fontsize=16,color='black')   for n in num_zeros]
        ymax = max([f.ymax() for f in frames])
        ymin = min([f.ymin() for f in frames])
        A = animate(frames, ymax=ymax, ymin=ymin, figsize=[8,5])
        A.save(fname)

    for input, output in f(curves):
        print input, output






def ap_sign_counts(curves=list1+list2, B='1e9'):
    path = "data/ap_sign_counts/"
    if not os.path.exists(path):
        os.makedirs(path)
    @parallel(ncpus)
    def f(lbl):
        fname = "%s/%s-%s.txt"%(path, lbl, B)
        if os.path.exists(fname):
            return "already done with %s"%lbl
        v = ap_sign_count(aplist(lbl, int(float(B))))
        r = EllipticCurve(lbl).rank()
        open(fname,'w').write("%s\t%s\t%s\t%s\t%s\t%s\n"%(lbl, r, B, v['neg'], v['pos'], v['neg']-v['pos']))

    for input, output in f(curves):
        print input, output



def zero_sum_distribution1_histograms(curves=list1+list2, samples=100000, Xmax=50, bins=1000):
    path = "plots/zero_sum_distribution1_histograms/"
    if not os.path.exists(path):
        os.makedirs(path)
    @parallel(ncpus)
    def f(lbl):
        base = "%s/%s-Xmax%s-samples%s-bins%s"%(path, lbl, Xmax, samples, bins)
        fname = base + '.svg'
        if os.path.exists(fname):
            return "already done with %s"%lbl
        v = zero_sum_distribution1(zeros=zeros(lbl), samples=samples, Xmax=Xmax)
        #save(v, fname + '.sobj')
        r = EllipticCurve(lbl).rank()
        g = finance.TimeSeries(v).plot_histogram(bins=bins)
        g.save(fname)

    for input, output in f(curves):
        print input, output





def zero_sum_distribution1_mean_std(curves=list1+list2, samples=100000, Xmax=50, bins=1000):
    path = "plots/zero_sum_distribution1_histograms/"
    if not os.path.exists(path):
        os.makedirs(path)
    @parallel(ncpus)
    def f(lbl):
        base = "%s/%s-Xmax%s-samples%s-bins%s"%(path, lbl, Xmax, samples, bins)
        fname = base + '.txt'
        if os.path.exists(fname):
            return "already done with %s"%lbl
        v = zero_sum_distribution1(zeros=zeros(lbl), samples=samples, Xmax=Xmax)
        r = EllipticCurve(lbl).rank()
        t = finance.TimeSeries(v)
        #save(v, base +'.sobj')
        open(fname,'w').write("%s\t%s\t%s\t%s\n"%(lbl, r, t.mean(), t.standard_deviation()))

    for input, output in f(curves):
        print input, output

def zero_sum_distribution1_normal(curves=list1+list2, samples=100000, bins=1000,
                                  Xmax=[5, 50, 1000, 5000], exclude=[0,5,10,50,500]):
    if not isinstance(Xmax, list):
        Xmax = [Xmax]
    if not isinstance(exclude, list):
        exclude = [exclude]

    path = "plots/zero_sum_distribution1_normal/"
    if not os.path.exists(path):
        os.makedirs(path)
    @parallel(ncpus)
    def f(lbl, xmax, exclude):
        base = "%s/%s-Xmax%s-samples%s-bins%s-exclude%s"%(path, lbl, xmax, samples, bins, exclude)
        fname = base + '.svg'
        if os.path.exists(fname):
            return "already done with %s"%lbl
        v = zero_sum_distribution1(zeros=zeros(lbl)[exclude:], samples=samples, Xmax=xmax)
        r = EllipticCurve(lbl).rank()
        t = finance.TimeSeries(v)
        #save(v, base +'.sobj')
        g = t.plot_histogram(bins=bins)
        mean = t.mean(); sd = t.standard_deviation()
        key = "%s: Xmax=%s, sd=%.2f, mean=%.2f, exclude=%s"%(lbl, xmax, sd, mean, exclude)
        g += text(key, (-4*sd,1), color='black')
        pdf(x) = 1/(sd*sqrt(2*pi)) * exp(-(x-mean)^2/(2*sd^2))
        g += plot(pdf, (x,mean-4*sd,mean+4*sd), color='red', thickness=2)
        g.save(fname)

    for input, output in f([(lbl,xmax,ex) for lbl in curves for xmax in Xmax for ex in exclude]):
        print input, output



def zero_sum_distribution1_params_table(curves=list1+list2, samples=100000, Xmax=[5, 50, 100, 200, 1000, 5000, 10000, 100000, 1000000]):
    if not isinstance(Xmax, list):
        Xmax = [Xmax]

    path = "plots/zero_sum_distribution1_params_table/"
    if not os.path.exists(path):
        os.makedirs(path)
    @parallel(ncpus)
    def f(lbl, xmax):
        base = "%s/%s-Xmax%s-samples%s"%(path, lbl, xmax, samples)
        fname = base + '.txt'
        if os.path.exists(fname):
            return "already done with %s"%lbl
        v = zero_sum_distribution1(zeros=zeros(lbl), samples=samples, Xmax=xmax)
        r = EllipticCurve(lbl).rank()
        t = finance.TimeSeries(v)
        data = [lbl, xmax, t.mean(), t.standard_deviation()]
        open(fname,'w').write("\t".join([str(x) for x in data]) + '\n')

    for input, output in f([(lbl,xmax) for lbl in curves for xmax in Xmax]):
        print input, output



def well_done_error_terms(curves=list1+list2, samples=50000):
    path = "plots/well_done_error_terms/"
    if not os.path.exists(path):
        os.makedirs(path)
    ncpus = 8  # lots of RAM
    @parallel(ncpus)
    def f(lbl):
        base = "%s/%s-samples%s"%(path, lbl, samples)
        data_name = base + '.txt'
        if os.path.exists(data_name):
            return "already done with %s"%lbl
        v, w = well_done_error_term(lbl, samples)
        r = EllipticCurve(lbl).rank()
        t = finance.TimeSeries(w)
        data = [lbl, t.mean(), t.standard_deviation()]
        open(data_name,'w').write("\t".join([str(x) for x in data]) + '\n')
        line(v).save(base + '.svg', figsize=[8,3])
        save(v, base + '.sobj')

    for input, output in f(curves):
        print input, output


#################################################################
#
# Code for my talk in Madison, WI
#
#################################################################

def animated_histogram(v, frames, log_scale=False, **kwds):
    """
    Given a time series, animate the sequence of histograms it
    defines, where we have the given number of frames.

    INPUT:

    - v -- time series
    - frames -- integer
    - log_scale -- if true, sample at a log scale
    """
    B = len(v)
    if log_scale:
        step = log(B)/frames
        X = int(exp(step))
    else:
        step = float(B)/frames
        X = int(step)

    g = []
    Xmin = Xmax = Ymin = Ymax = 0
    while X <= B:
        h = v[:X].plot_histogram(**kwds)
        g.append(h)
        Xmin = min(Xmin, h.xmin())
        Xmax = max(Xmax, h.xmax())
        Ymin = min(Ymin, h.ymin())
        Ymax = max(Ymax, h.ymax())
        if log_scale:
            X += exp(log(X) + step)
        else:
            X += step
        X = int(X)

    return animate(g, xmin=Xmin, xmax=Xmax, ymin=Ymin, ymax=Ymax)

#####################################
# 1. BSD/Sato-Tate animation
#####################################
def sato_tate_animation(lbl, frames=50, B=10^9, **kwds):
    """
    Animation illustrating Sato-Tate for an elliptic curve.
    """
    v = sato_tate_data(lbl, B)
    return animated_histogram(v, frames, **kwds)


#####################################
# 2. Chebeshev Bias
#####################################
def chebeshev_distribution_animation(frames=50, B=10^9, **kwds):
    v = chebeshev_data(B)
    return animated_histogram(v, frames, **kwds)

def chebeshev_bias_data(B):
    return chebeshev_data(B).sums()


def ellcurve_data_plots(lbl, B, frames=50, **kwds):
    d = data(EllipticCurve(lbl), B, aplist(lbl, B),
          num_points=num_points, log_X_scale=log_X_scale)

def ellcurve_data_histograms(data_object, frames=50, **kwds):
    result = {}
    for which in ['raw', 'medium', 'well']:
        v = TimeSeries([y for x,y in data_object[which]['delta']])
        result[which] = animated_histogram(v, frames, **kwds)
    return result

#####################################################################################
# This function orchestrates computing all plots not already computed for the talk

class Madison:
    def all(self):
        self.sato_tate('11a')
        self.sato_tate('5077a')
    
    def path(self, name):
        return os.path.join('madison', name)
    
    def done(self, name):
        d = os.path.exists(self.path(name))
        if d:
            print "%s done"%name
        return d

    def sato_tate(self, lbl):
        print "sato-tate %s"%lbl
        target = 'sato-tate-animation-%s.gif'%lbl
        if self.done(target):
            return
        sato_tate_animation(lbl, frames=100, B=10^9, bins=10000, ymax=1).save(self.path(target))

    def primes_mod_4(self):
        target = "primes-mod-4.gif"
        if self.done(target):
            return
        chebeshev_distribution_animation(frames=100, B=10^9, bins=10).save(self.path(target))

    def prime_race_mod4(self):
        target = "primes-race-mod4.svg"
        if self.done(target):
            return
        v = chebeshev_bias_data(10^9)
        v.plot(thickness=0.3, plot_points=10^6).save(self.path(target), figsize=[8,3])

    def riemann_oscillatory(self):
        target = "riemann-oscillatory.svg"
        if self.done(target): return
        g = plot(lambda x: zeta_oscillatory(x, 0,10000), (3, 1000), plot_points=10000)
        g.save(self.path(target)) 
        
    def riemann_epsilon(self):
        target = "riemann-epsilon.svg"
        if self.done(target): return
        v = zeta_eps(1000, 10000)
        line(v, thickness=.5).save(self.path(target),figsize=[8,3])

    def data_plots(self, lbl, B=10^9, force=False):
        targets = ["raw-data-%s.svg"%lbl, "raw-mean-%s.svg"%lbl,
                   "medium-data-%s.svg"%lbl, "medium-mean-%s.svg"%lbl,
                   "well-data-%s.svg"%lbl, "well-mean-%s.svg"%lbl]
        if not force and all(self.done(t) for t in targets):
            return
        dp = DataPlots(lbl, B, data_path='data')
        v = dp.data(num_points=5000, log_X_scale=True)
        for w in ['raw','medium','well']:
            g = plot_step_function(v[w]['delta'],thickness=1,fontsize=18)
            g.save('madison/%s-data-%s.svg'%(w,lbl), gridlines=True, figsize=[10,4])
            g = plot_step_function(v[w]['mean'],thickness=1,fontsize=18)
            g.save('madison/%s-mean-%s.svg'%(w,lbl), gridlines=True, figsize=[10,4])

    def oscillatory(self, lbl, B=1e30):
        target = "oscillatory-%s.gif"%lbl
        if self.done(target): return
        z = zeros(lbl)
        v = [line(zero_sum_no_log_plot(z[:k], 10000, B), thickness=.4, figsize=[10,4]) for k in [5,50,..,500]]
        ymax = max([g.ymax() for g in v])
        ymin = min([g.ymin() for g in v])        
        a = animate(v, ymin=ymin, ymax=ymax)
        a.save(self.path(target))

    def bayesian(self, lbl, B=1e30):
        target = "bayesian-%s.svg"%lbl
        if self.done(target): return
        z = zeros(lbl)
        t = TimeSeries(zero_sum_distribution1(z, 100000, math.log(B)))
        g = t.plot_histogram(bins=1000)
        mean = t.mean(); sd = t.standard_deviation()
        pdf = lambda x: 1/(sd*sqrt(2*pi)) * exp(-(x-mean)^2/(2*sd^2))
        key = "%s: sd=%.2f, mean=%.2f"%(lbl, sd, mean)
        g += text(key, (-4*sd,1), color='black')
        g += plot(pdf, (x,mean-4*sd,mean+4*sd), color='red', thickness=2)
        g.save(self.path(target), figsize=[10,6])
        
    

def madison():
    m = Madison()
    m.sato_tate('11a')
    m.sato_tate('5077a')
    m.primes_mod_4()
    m.prime_race_mod4()
    m.riemann_oscillatory()
    m.riemann_epsilon()
    m.data_plots('11a')
    m.data_plots('5077a')
    m.data_plots('2379b')
    m.data_plots('128b')
    m.oscillatory('11a')
    m.oscillatory('128b')
    m.oscillatory('5077a')



#########################

def negate(v):
    return [(x,-y) for x,y in v]

class PechaKucha:
    def done(self, name):
        d = os.path.exists(self.path(name))
        if d:
            print "%s done"%name
            return d 

    def path(self, name):
        return os.path.join('pechakucha', name)
    
    def data_plots(self, lbl, B=10^9, force=False):
        targets = ["raw-data-%s.svg"%lbl, "raw-mean-%s.svg"%lbl,
                   "medium-data-%s.svg"%lbl, "medium-mean-%s.svg"%lbl,
                   "well-data-%s.svg"%lbl, "well-mean-%s.svg"%lbl]
        if not force and all(self.done(t) for t in targets):
            return
        dp = DataPlots(lbl, B, data_path='data')
        v = dp.data(num_points=5000, log_X_scale=True)
        for w in ['raw','medium','well']:
            v[w]['delta'] = negate(v[w]['delta'])
            v[w]['mean'] = negate(v[w]['mean'])
            g = plot_step_function(v[w]['delta'],thickness=1,fontsize=18)
            g.save('pechakucha/%s-data-%s.svg'%(w,lbl), gridlines=True, figsize=[10,4])
            g = plot_step_function(v[w]['mean'],thickness=1,fontsize=18)
            g.save('pechakucha/%s-mean-%s.svg'%(w,lbl), gridlines=True, figsize=[10,4])

    def oscillatory(self, lbl, B=1e30):
        target = "oscillatory-no_log-%s.gif"%lbl
        if self.done(target): return
        print "Plotting oscillatory plot (no log) for %s"%lbl
        z = zeros(lbl,500)
        v = [line(zero_sum_no_log_plot(z[:k], 10000, B), thickness=.4, figsize=[10,4]) for k in [5,50,..,500]]
        ymax = max([g.ymax() for g in v])
        ymin = min([g.ymin() for g in v])        
        a = animate(v, ymin=ymin, ymax=ymax)
        a.save(self.path(target))

    def bite(self, lbl, B=1e30):
        target = "bite-%s.svg"%lbl
        if self.done(target): return
        z = zeros(lbl,500)
        t = TimeSeries(zero_sum_distribution1(z, 100000, math.log(B)))
        g = t.plot_histogram(bins=1000)
        mean = t.mean(); sd = t.standard_deviation()
        pdf = lambda x: 1/(sd*sqrt(2*pi)) * exp(-(x-mean)^2/(2*sd^2))
        key = "%s: sd=%.2f, mean=%.2f"%(lbl, sd, mean)
        g += text(key, (-4*sd,1), color='black')
        g += plot(pdf, (x,mean-4*sd,mean+4*sd), color='red', thickness=2)
        g.save(self.path(target), figsize=[10,6])

def pechakucha():
    m = PechaKucha()
    #for lbl in ['11a', '37a', '5077a', '389a', '5002c1', '5021a1']:
    for lbl in ['5002c1', '5021a1','431b1','443c1']:
        m.data_plots(lbl)
        m.oscillatory(lbl)
        m.bite(lbl)
