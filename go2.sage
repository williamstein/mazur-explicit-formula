attach "explicit.pyx"

list1 = ["11a", "14a", "37a", "43a", "389a", "433a", "5077a", "11197a"]
list2 = ["816b", "5423a", "2340i", "2379b", "2432d", "29862s", "3776h", "128b", "160a", "192a", "10336d"]

ncpus = 16

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

def lseries_data(curves=list1+list2, rng="1e5"):
    B = int(eval(rng))
    @parallel(ncpus)
    def f(lbl):
        E = EllipticCurve(lbl)
        zeros_sobj = 'data/%s-zeros-%s.sobj'%(lbl, B)
        if not os.path.exists(zeros_sobj):
            v = E.lseries().zeros(B)
            v = [int(ap) for ap in v]
            save(v, zeros_sobj)

    for input, output in f(curves):
        print input, output

def zeros(lbl, num_zeros=10000):
    assert num_zeros <= 10000
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
                                  Xmax=[5, 50, 1000, 5000], exclude=[0,5,10,50,500]:)
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



def zero_sum_distribution1_params_table(curves=list1+list2, samples=100000, 
                                        Xmax=[5, 50, 100, 200, 1000, 5000, 10000, 100000, 1000000]:)
    if not isinstance(Xmax, list):
        Xmax = [Xmax]

    path = "plots/zero_sum_distribution1_params/"
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
