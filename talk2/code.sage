def apsign_counts(label):
    E = EllipticCurve(label)
    v = E.aplist(10^7)
    pos = len([x for x in v if x > 0]); neg= len([x for x in v if x < 0])
    print "<tr><td>%s (rank %s)</td><td>%s</td><td>%s</td></tr>"%(
         label, E.rank(), pos, neg) 

def delta_E(E, B):
    aplist = E.aplist(B)
    N = E.conductor()
    primes = prime_range(B)
    v = [(0,0)]
    for i in range(len(primes)):
        p = primes[i]; a = aplist[i]
        if N%p == 0 or a == 0:
            g = 0
        elif a < 0:
            g = -1
        else:
            g = 1
        v.append((p, v[-1][1]+g))
    return v

def delta_E_plot(E,B):
    v = delta_E(E,B)
    line(v).save('svg/delta_E-%s-%s.svg'%(E.cremona_label(),B), figsize=[8,2])

def delta_E_step_plot(E, B):
    v = delta_E(E,B)
    plot_step_function(v).save('svg/delta_E-%s-step-%s.svg'%(E.cremona_label(),B), figsize=[8,2])
