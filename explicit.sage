from sage.all import EllipticCurve, pi, latex, parallel, save
import os

curves = ["11a", "14a", "37a", "43a", "389a", "433a", "5077a", "11197a"]
means = [('11a', 0.6474706006966815, 0.5979459030113199, 0.15543478452293413),
('14a', 0.7521823115223413, 0.5541743260941198, 0.11443069533660696),
('37a', -1.4116143718516094, -1.9670347032628086, -0.8160519544427207),
('43a', -0.3659895692713372, -1.9059869298758216, -0.792188062142615),
('389a', -2.6577327851232084, -4.292846440582865, -1.6630873161756692),
('433a', -4.054771989404445, -4.166734867770748, -1.6174451331282922),
('5077a', -5.228033507844708, -6.59770992518664, -2.5074196009380243),
('11197a', -4.428204654385869, -6.288709783782257, -2.360221866060336)]


def raw(E):
    r = E.rank()
    raise NotImplementedError

def conj_medium(E):
    return 1-2*E.rank()

def conj_well(E):
    return -E.rank()

def example_table():
    res = ''
    for lbl,raw_mean,medium_mean,well_mean in means:
        E = EllipticCurve(lbl)
        row = [lbl, E.rank(), '%.3f'%raw_mean, '%.3f'%medium_mean, conj_medium(E), '%.3f'%well_mean, conj_well(E)]
        res += '<tr id="curve-%s">'%lbl + ''.join(["<td>%s</td>"%x for x in row]) + '</tr>\n'
    return res


@parallel(len(curves))
def compute_aplists_and_zeros(i):
    num_ap = 10^9
    num_zeros = 10^4
    if not os.path.exists('data'):
        os.makedirs('data')
    lbl = curves[i]
    E = EllipticCurve(lbl)
    aplist_sobj = 'data/%s-aplist-%s.sobj'%(lbl, num_ap)
    zeros_sobj = 'data/%s-zeros-%s.sobj'%(lbl, num_zeros)
    if not os.path.exists(aplist_sobj):
        v = E.aplist(num_ap)
        v = [int(ap) for ap in v]
        save(v, aplist_sobj)
    if not os.path.exists(zeros_sobj):
        zeros = [float(y) for y in E.lseries().zeros(num_zeros)]
        save(zeros, zeros_sobj)

def compute_all_aplists_and_zeros():
    for X in compute_aplists_and_zeros(range(len(curves))):
        print X
