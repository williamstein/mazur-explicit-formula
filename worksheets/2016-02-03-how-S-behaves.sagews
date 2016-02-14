︠4754e85a-97a0-48c5-879a-c61d65d9c996i︠
%md

(from Barry)
> Hi William,

> Very helpful!   It would almost seems as if S(X) is going down by a factor of, at least, log X, and maybe a fractional power of X??  What do you think?

> One reason why  it might be a good idea to Cersaro smooth, is this: if you consider the explicit formula, we have

> a simple sum of local terms  =  Mordell-Weil rank   +  a simple continuous function of X + S(X).

> Now, if you Cesaro smooth, it is dead easy to see how this changes the LHS. It does't affect the   Mordell-Weil rank  (which  is going to be the thing we want to get of=ut of the formula). It is easy to see how it affects the simple continuous function. So, th mystery term is S(X). In summary: if we want to know how many term of the  simple sum of local terms  we need to compute to predict the  Mordell-Weil rank, it is almost as useful to bound S(X) as its Cesaro smoothing.
︡d71022fb-63f4-4e8d-b13f-9be67a856eb8︡︡{"done":true,"md":"\n(from Barry)\n> Hi William,\n\n> Very helpful!   It would almost seems as if S(X) is going down by a factor of, at least, log X, and maybe a fractional power of X??  What do you think?\n\n> One reason why  it might be a good idea to Cersaro smooth, is this: if you consider the explicit formula, we have\n\n> a simple sum of local terms  =  Mordell-Weil rank   +  a simple continuous function of X + S(X).\n\n> Now, if you Cesaro smooth, it is dead easy to see how this changes the LHS. It does't affect the   Mordell-Weil rank  (which  is going to be the thing we want to get of=ut of the formula). It is easy to see how it affects the simple continuous function. So, th mystery term is S(X). In summary: if we want to know how many term of the  simple sum of local terms  we need to compute to predict the  Mordell-Weil rank, it is almost as useful to bound S(X) as its Cesaro smoothing."}
︠d2216e9b-1885-4e1d-a060-bfc20775afb1as︠
%auto
load("../explicit.pyx")
︡6862e94a-a30d-466c-a3c2-b899c71f05bd︡{"auto":true}︡{"stderr":"Compiling ./../explicit.pyx..."}︡{"stderr":"\n"}︡
︠deda217a-2688-4007-a4e5-bc556b20d7daas︠
%auto
def CS(E, xmax=1e4, num_zeros=100):
    S = OscillatoryTerm(E,num_zeros)
    # evaluate S at each point
    return [S(x)[-1] for x in range(2,xmax)]

# cecaro of a time series (naive implementation -- fast enough)
def cesaro(t):
    return stats.TimeSeries(t[:n].mean() for n in range(len(t)))

def plots(E, xmax=1e4, num_zeros=100, B=0.05):
    print "S(X) and its Cesaro sum: for %s up to X=%s using %s zeros"%(E.cremona_label(), xmax, num_zeros)
    s = stats.TimeSeries(CS(E, xmax, num_zeros))
    show(s.plot() + cesaro(s).plot(color='red', thickness=2), ymax=B, ymin=-B)
︡0c45b538-234d-4b46-88d0-5f73204f44bd︡{"auto":true}︡
︠7f3965c1-255f-4fe6-be58-416de943e3d9i︠
for lbl in ['11', '37a', '389a', '5077a']:
    for xmax, B in [(100,.3), (1000,.06), (10000,.04)]:
        plots(EllipticCurve(lbl), xmax=xmax, num_zeros=1000, B=B)
︡a547f430-275d-4f69-80a3-f76bc0a0dd5b︡︡{"stdout":"S(X) and its Cesaro sum: for 11a1 up to X=100 using 1000 zeros\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"2d3a1495-d903-47fa-9c36-873a465bf2c3","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/19584/tmp_gxyFs5.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"S(X) and its Cesaro sum: for 11a1 up to X=1000 using 1000 zeros","done":false}︡{"stdout":"\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"e30404d1-7b9c-44d2-b559-5853d6db61f0","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/19584/tmp_76ktu8.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"S(X) and its Cesaro sum: for 11a1 up to X=10000 using 1000 zeros","done":false}︡{"stdout":"\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"79cfa28f-40f4-4aec-8538-3a491907ff50","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/19584/tmp_a6OKle.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"S(X) and its Cesaro sum: for 37a1 up to X=100 using 1000 zeros","done":false}︡{"stdout":"\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"0de6a426-d3bd-4089-a06d-9209cd244b5a","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/19584/tmp_7EkkzB.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"S(X) and its Cesaro sum: for 37a1 up to X=1000 using 1000 zeros","done":false}︡{"stdout":"\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"a92f7319-77a8-4148-8b6e-67e5863587f5","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/19584/tmp_7EcTqo.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"S(X) and its Cesaro sum: for 37a1 up to X=10000 using 1000 zeros","done":false}︡{"stdout":"\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"151e2e85-e55f-42ff-8085-e329e50e174e","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/19584/tmp_665XPK.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"S(X) and its Cesaro sum: for 389a1 up to X=100 using 1000 zeros","done":false}︡{"stdout":"\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"baa272e2-340e-4718-b535-dbff6a69f290","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/19584/tmp_XhInha.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"S(X) and its Cesaro sum: for 389a1 up to X=1000 using 1000 zeros","done":false}︡{"stdout":"\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"131b4b9c-392c-475a-9ca1-7fddce57a78f","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/19584/tmp_wGfJbD.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"S(X) and its Cesaro sum: for 389a1 up to X=10000 using 1000 zeros","done":false}︡{"stdout":"\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"54fb65ea-76a0-4feb-85af-b33a1d98137a","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/19584/tmp_pWd_dU.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"S(X) and its Cesaro sum: for 5077a1 up to X=100 using 1000 zeros","done":false}︡{"stdout":"\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"1a776430-4dd2-4a0b-a21d-627a0ee59974","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/19584/tmp_f2FNC3.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"S(X) and its Cesaro sum: for 5077a1 up to X=1000 using 1000 zeros","done":false}︡{"stdout":"\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"32e0daa2-fd0f-49eb-9a5d-65a1e60bba17","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/19584/tmp_oPs2wu.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"S(X) and its Cesaro sum: for 5077a1 up to X=10000 using 1000 zeros","done":false}︡{"stdout":"\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"551207a3-8d5c-4404-8bb3-4aef3f2d128d","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/19584/tmp_eeMeWn.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"done":true}
︠963c909f-5846-44ef-8491-93b6cfbe9862︠

for lbl in ['11', '37a', '389a', '5077a']:
    plots(EllipticCurve(lbl), xmax=100000, num_zeros=500, B=0.05)
︡efa3a515-137d-42de-b1ea-5825b2ae1870︡{"stdout":"S(X) and its Cesaro sum: for 11a1 up to X=100000 using 500 zeros\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"fe968754-e22b-4fc9-95d6-6a529fbae1aa","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/19584/tmp_oXlncZ.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"S(X) and its Cesaro sum: for 37a1 up to X=100000 using 500 zeros","done":false}︡{"stdout":"\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"80e1d537-2c36-4ab0-b2b8-dbf7d118d95b","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/19584/tmp_g7WMFH.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"S(X) and its Cesaro sum: for 389a1 up to X=100000 using 500 zeros","done":false}︡{"stdout":"\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"8bf26606-b19c-4565-925b-e231f63172a8","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/19584/tmp_KcWftZ.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"S(X) and its Cesaro sum: for 5077a1 up to X=100000 using 500 zeros","done":false}︡{"stdout":"\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"e1403f61-802b-4f1c-a82f-ae8c718fb721","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/19584/tmp_NkRnsE.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"done":true}︡
︠c8e11428-588a-4e82-8f00-c4e7b8684c65︠









