from sage.all import EllipticCurve, pi, latex, parallel, save
import os

curves = ["11a", "14a", "37a", "43a", "389a", "433a", "5077a", "11197a"]

def raw(E,k,s):
    # THIS IS WRONG.
    r = E.rank()
    Z = (8/pi) + (-1)^(k+1)*(1/(2*k+1) + 1/(2*k+3)) * s
    return 2/(3*pi)* ( 4 + (-1)^(r+1) - 8*r ) + Z

def medium(E,k,s):
    return 1-2*E.rank()

def well(E,k,s):
    return -E.rank()

def sympow_table():
    res = ''
    for lbl in curves:
        E = EllipticCurve(lbl)
        ra = raw(E,k,s)
        row = lbl, E.rank(), medium(E,k,s), well(E,k,s)
        res += '<tr id="#curve-%s">'%lbl + ''.join(["<td>%s</td>"%x for x in row]) + '</tr>\n'
    return res


@parallel(len(curves))
def compute_aplists_and_zeros(i):
    num_ap = 10^8
    num_zeros = 10^4
    if not os.path.exists('data'):
        os.makedirs('data')
    lbl = curves[i][0]
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
