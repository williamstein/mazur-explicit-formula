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


def zero_sum_no_log_animations(curves=list1+list2, num_zeros=[10,20,..,500], Xmax='1e20', num_points='2000'):
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
        frames = [line(zero_sum_no_log_plot(v[:n], num_points, Xmax), thickness=.4) +
                  text(str(n),(log(Xmax)/10,.15),fontsize=16,color='black')   for n in num_zeros]
        ymax = max([f.ymax() for f in frames])
        ymin = min([f.ymin() for f in frames])
        A = animate(frames, ymax=ymax, ymin=ymin, figsize=[8,5])
        A.save(fname)

    for input, output in f(curves):
        print input, output

