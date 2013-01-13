attach "explicit.pyx"

list1 = ["11a", "14a", "37a", "43a", "389a", "433a", "5077a", "11197a"]
list2 = ["816b", "5423a", "2340i", "2379b", "2432d", "29862s", "3776h", "128b", "160a", "192a", "10336d"]

ncpus = 4

def plots(curves=list1, rng="1e8") :
    B = int(eval(rng))    
    print "output path = ", rng
    print "B = ", B
    @parallel(ncpus)
    def f(label):
        dp = DataPlots(label, B, 'data')
        v = dp.data(num_points=5000, log_X_scale=True, verbose=False)
        for w in ['raw','medium','well']:
            g = plot_step_function(v[w]['mean'],thickness=5,fontsize=24)
            g.save('plots/%s/%s-%s-%s.svg'%(rng, label, w, B), gridlines=True)
        return label, v['raw']['mean'][-1][1], v['medium']['mean'][-1][1], v['well']['mean'][-1][1]

    for input, output in f(curves):
        print output

def data(curves=list1, rng="1e8"):
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
