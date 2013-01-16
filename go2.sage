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

def zero_sum_plots(curves=list1+list2, num_zeros=100000, Xmax=1e9, num_points=10000):
    @parallel(ncpus)
    def f(lbl):
        fname = "plots/mean_zero_sums/%s-%s-%s-%s.svg"%(lbl, num_zeros, Xmax, num_points)
        if os.path.exists(fname):
            return "already done"
        zeros = load("data/%s-zeros-%s.sobj"%(lbl, num_zeros))
        v = mean_zero_sum_plot(zeros, num_points, Xmax)
        line(v).save(fname)

    for input, output in f(curves):
        print input, output

def zero_sum_animations(curves=list1+list2, num_zeros=[1000,2000,..,100000], Xmax=1e9, num_points=10000):
    @parallel(ncpus)
    def f(lbl):
        fname = "plots/mean_zero_sums/animations/%s-%s-%s-%s.svg"%(lbl, num_zeros, Xmax, num_points)
        if os.path.exists(fname):
            return "already done"
        zeros = load("data/%s-zeros-%s.sobj"%(lbl, num_zeros))
        v = mean_zero_sum_plot(zeros, num_points, Xmax)
        line(v).save(fname)

    for input, output in f(curves):
        print input, output

