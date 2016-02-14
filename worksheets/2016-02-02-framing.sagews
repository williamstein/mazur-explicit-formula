︠2fea6a9e-3d2d-49a6-ba36-a09d055d7e66as︠
%auto
%time
load("../explicit.pyx")
︡11255ab3-9157-4864-b78e-7ddefae8718e︡{"auto":true}︡{"stderr":"Compiling ./../explicit.pyx...\n"}︡{"stdout":"CPU time: 0.42 s, Wall time: 8.14 s"}︡{"stdout":"\n"}︡
︠727f4db0-fdb5-474e-b789-2da79edc0dcei︠
%md

> Hi William,

> I'm trying to work out a statement of a conjecture that is essentially  (or at least only epsilon more than) the union of  all the conjectures that the analytic number theorists have that are "finer" than RH.  The main ingredient would be to have a conjecture about $S_E(X)/\log(X)$  (notation as in our paper).  The simple straightforward guess (Sarnak) is that this tends to zero as $X$ goes to infinity.  But thinking about what the graphs you computed look like, it s tempting to do a "Cesaro Smoothing" of it  (i.e., $F(X):= \int_{x=0}^{x=X} S_E(x)/\log(x) dx / X)$ and see if the graph looks like it is something we can conjecture about.   What do you think?

> - Barry
︡be8bf4a6-bb50-4265-ad37-38e22b5da098︡︡{"done":true,"md":"\n> Hi William,\n\n> I'm trying to work out a statement of a conjecture that is essentially  (or at least only epsilon more than) the union of  all the conjectures that the analytic number theorists have that are \"finer\" than RH.  The main ingredient would be to have a conjecture about $S_E(X)/\\log(X)$  (notation as in our paper).  The simple straightforward guess (Sarnak) is that this tends to zero as $X$ goes to infinity.  But thinking about what the graphs you computed look like, it s tempting to do a \"Cesaro Smoothing\" of it  (i.e., $F(X):= \\int_{x=0}^{x=X} S_E(x)/\\log(x) dx / X)$ and see if the graph looks like it is something we can conjecture about.   What do you think?\n\n> - Barry"}
︠e908eced-3882-4394-9565-f46bee0b74a7i︠
%md

Hi Barry,

For some reason, I don't know if we ever just plotted $S(X) = S_E(X)/\log(X)$!  So let's start by doing that, since if we want to make
a conjecture about that function, we might as well start with some plots of it, so we understand it better.

The good news, is I happened to have implemented fast code for evaluating it ([in the file explicit.pyx.](https://cloud.sagemath.com/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/files/mazur-explicit-formula/explicit.pyx))

So here are some plots.  In each case, I plot in blue the plot for $X$ going from $1.1$ to various bounds using first 100 zeros, then in red using 1000 zeros.  This gives you a sense of whether convergence (i.e. using more zeros) is an issue.

︡7c8cda5e-0593-434d-8ef7-dd65b5898d86︡︡{"done":true,"md":"\nHi Barry,\n\nFor some reason, I don't know if we ever just plotted $S(X) = S_E(X)/\\log(X)$!  So let's start by doing that, since if we want to make\na conjecture about that function, we might as well start with some plots of it, so we understand it better.\n\nThe good news, is I happened to have implemented fast code for evaluating it ([in the file explicit.pyx.](https://cloud.sagemath.com/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/files/mazur-explicit-formula/explicit.pyx))\n\nSo here are some plots.  In each case, I plot in blue the plot for $X$ going from $1.1$ to various bounds using first 100 zeros, then in red using 1000 zeros.  This gives you a sense of whether convergence (i.e. using more zeros) is an issue."}
︠b794e9df-2d2e-481d-9d99-0fc370dd7d9aas︠
%auto
def plots(E, B=0.15, xmax=1e5):
    print E.cremona_label()
    S100  = OscillatoryTerm(E,100)
    S1000 = OscillatoryTerm(E,1000)
    g  = plot(lambda x : S100(x)[-1], 1.1, xmax)
    g += plot(lambda x : S1000(x)[-1], 1.1, xmax, color='red')
    show(g, ymin=-B, ymax=B, figsize=[10,4])
︡cef3a90b-70cc-4f1a-b21d-bcb075e86c15︡{"auto":true}︡
︠08097bff-16a0-4374-8b0d-18a08fbf03e4︠
%time plots(EllipticCurve('11a'), .15, 1e3)
︡6a0f7503-f9ba-4847-b8e5-93552362885f︡︡{"stdout":"11a1","done":false}︡{"stdout":"\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"1c5644f3-9f5c-41b0-a7cb-0d641981e094","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/20233/tmp_dL8FAW.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"CPU time: 1.22 s, Wall time: 11.07 s","done":false}︡{"stdout":"\n","done":false}︡{"done":true}
︠f63bb101-890e-4adc-aabb-cdb8e0177822︠
%time plots(EllipticCurve('11a'), .15, 1e5)
︡deb465e6-8fac-4b2e-a9b1-da571d921784︡︡{"stdout":"11a1\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"2c607999-c350-417b-a781-8363c67f08f0","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/20233/tmp_6Kl31R.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"CPU time: 1.19 s, Wall time: 11.64 s","done":false}︡{"stdout":"\n","done":false}︡{"done":true}
︠3818b70f-95e5-418f-a986-7d9e3fcff7d8︠
%time plots(EllipticCurve('11a'), .05, 1e7)
︡3323ebb1-5b68-4556-8695-e9ef0633cea2︡︡{"stdout":"11a1\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"a87ac9cd-4f21-4150-a949-9f77babb2892","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/20233/tmp_xk3_0m.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"CPU time: 0.66 s, Wall time: 7.99 s","done":false}︡{"stdout":"\n","done":false}︡{"done":true}
︠ce06773d-ac29-40e0-90c1-742f1c606d56︠
%time plots(EllipticCurve('37a'), .15, 1e3)
︡70e0ec36-861b-4c5a-abe9-51a05b1a844c︡︡{"stdout":"37a1\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"e752f95e-92f2-47a4-891d-c4652648dbfe","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/20233/tmp_sUJEC7.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"CPU time: 0.69 s, Wall time: 11.60 s","done":false}︡{"stdout":"\n","done":false}︡{"done":true}
︠3624f0f0-17cf-416f-bb38-a824bd3e80a1︠
%time plots(EllipticCurve('37a'), .15, 1e5)
︡023c93c4-bbc9-4d5e-9921-8cb093798d74︡︡{"stdout":"37a1\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"6a44f720-eb88-4b70-bae4-1e03c33d47b7","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/20233/tmp_VPwAsx.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"CPU time: 0.68 s, Wall time: 11.58 s","done":false}︡{"stdout":"\n","done":false}︡{"done":true}
︠50e9787c-3a63-448c-a9f4-214c33958ed3︠

%time plots(EllipticCurve('37a'), .15, 1e7)
︡be635d21-8e76-4ade-98de-b2a748e41ff4︡︡{"stdout":"37a1\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"1f5461cb-fe1f-46ff-83dd-a8a119c2bd84","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/20233/tmp_V3LSh0.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"CPU time: 0.80 s, Wall time: 12.64 s","done":false}︡{"stdout":"\n","done":false}︡{"done":true}
︠472bd0ec-8680-4d62-b37d-f4c96e5675ab︠
%time plots(EllipticCurve('389a'), .15, 1e3)
︡73aa7802-1dfa-47cf-967d-2155edd93ba7︡︡{"stdout":"389a1\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"14abb3ab-2665-4cf2-a49c-8ef220dc88d0","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/20233/tmp_DVA8Yz.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"CPU time: 0.82 s, Wall time: 35.68 s","done":false}︡{"stdout":"\n","done":false}︡{"done":true}
︠f4ddf0d6-2f8f-44d6-ab55-5e3ad26d774f︠
%time plots(EllipticCurve('389a'), .15, 1e5)
︡4476005f-f3a0-4ce6-b0b8-c0f91f6e2048︡︡{"stdout":"389a1\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"9a66866d-6abb-4a99-a4c5-d77cafb1f0d8","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/20233/tmp_A_WIn_.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"CPU time: 1.11 s, Wall time: 46.49 s","done":false}︡{"stdout":"\n","done":false}︡{"done":true}
︠0c669406-ca53-490d-8bdf-ec8a87acc5a6︠
%time plots(EllipticCurve('389a'), .05, 1e7)
︡d91fae39-017e-4bed-9d12-3eb4c08a52b6︡︡{"stdout":"389a1\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"00bdb9e0-94a3-4caf-9188-75ca14247257","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/20233/tmp_yXnvXL.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"CPU time: 0.69 s, Wall time: 45.05 s","done":false}︡{"stdout":"\n","done":false}︡{"done":true}
︠d3d1de61-3d2e-4333-842c-829c292be7fe︠
%time plots(EllipticCurve('5077a'), .2, 1e3)
︡65763b87-12bb-44d6-be9e-b2b63928b7a2︡︡{"stdout":"5077a1\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"47ee8fe4-f75c-4f61-bbe4-4dc1747d4689","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/20233/tmp_v_sGp7.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"CPU time: 0.77 s, Wall time: 64.77 s","done":false}︡{"stdout":"\n","done":false}︡{"done":true}
︠34931e9e-c00e-462b-be57-de79350f90cb︠
%time plots(EllipticCurve('5077a'), .2, 1e5)
︡bc039e55-9fc4-41a4-bb39-c822ea4f5ab4︡︡{"stdout":"5077a1\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"92de091d-f6c1-4379-86ef-d4f2eb890c5c","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/20233/tmp_dGkeYC.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"CPU time: 0.73 s, Wall time: 47.46 s","done":false}︡{"stdout":"\n","done":false}︡{"done":true}
︠da816ed5-81b0-448a-9461-9fbc7cf9483e︠
%time plots(EllipticCurve('5077a'), .2, 1e7)
︡4e0b9204-ec28-4ae3-8f91-86fbd128489f︡︡{"stdout":"5077a1\n","done":false}︡{"once":false,"done":false,"file":{"show":true,"uuid":"dc3bc623-7ccd-4504-a909-edbcd6967068","filename":"/projects/95d92fa7-cb50-414e-a35d-9897eabe44de/.sage/temp/compute4-us/20233/tmp_BGGMtb.svg"}}︡{"html":"<div align='center'></div>","done":false}︡{"stdout":"CPU time: 0.78 s, Wall time: 45.18 s","done":false}︡{"stdout":"\n","done":false}︡{"done":true}
︠9577d46d-d45a-48a4-958d-c7ceee3e62eb︠
︡11a2237e-ba7c-4a67-96ca-cca01e81232c︡︡{"done":true}
︠374b942e-99f3-4ebf-a99f-086b29e4b33f︠

︡a185d16d-1f4c-449b-b862-19ab11475afd︡︡{"done":true}











