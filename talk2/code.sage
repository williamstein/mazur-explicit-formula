def apsign_counts(label):
    E = EllipticCurve(label)
    v = E.aplist(10^7)
    pos = len([x for x in v if x > 0]); neg= len([x for x in v if x < 0])
    print "<tr><td>%s (rank %s)</td><td>%s</td><td>%s</td></tr>"%(
         label, E.rank(), pos, neg) 

