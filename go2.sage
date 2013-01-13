attach "explicit.pyx"

rng = "1e8"
B = int(eval(rng))

print "output path = ", rng
print "B = ", B

ncpus = sage.parallel.ncpus.ncpus()
@parallel(ncpus)
def f(label):
    dp = DataPlots(label, B, 'data')
    v = dp.data(num_points=5000, log_X_scale=True, verbose=False)
    for w in ['raw','medium','well']:
        g = plot_step_function(v[w]['mean'],thickness=5,fontsize=24)
        g.save('plots/%s/%s-%s-%s.svg'%(rng, label, w, B), gridlines=True)
    return label, v['raw']['mean'][-1][1], v['medium']['mean'][-1][1], v['well']['mean'][-1][1]

for input, output in f(["11a", "14a", "37a", "43a", "389a", "433a", "5077a", "11197a"]):
    print output

