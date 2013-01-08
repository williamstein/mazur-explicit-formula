attach "explicit.pyx"

ncpus = sage.parallel.ncpus.ncpus()
@parallel(ncpus)
def f(label):
    print(label)
    B = 10^8
    dp = DataPlots("160a", B)
    v = dp.data(num_points=5000)
    for w in ['raw','medium','well']:
        g = plot_step_function(v[w]['mean'],color='red',thickness=.5) + plot_step_function(v[w]['delta'], thickness=.5)
        g.save('plots/%s-%s-%s.svg'%(label, w, B))
    return label, v['raw']['mean'][-1], v['medium']['mean'][-1], v['well']['mean'][-1]

for input, output in f(['2379b', '5423a', '10336d', '29862s', '816b', '2340i', '2432d', '3776h', '128b', '160a', '192a']):
    print output

